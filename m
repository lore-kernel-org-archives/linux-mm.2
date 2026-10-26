Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87230606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nglWobNB
Received: by kanga.kvack.org (Postfix)
	id A11D06B05B4; Mon, 26 Oct 2026 18:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3926B05B5; Mon, 26 Oct 2026 18:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFCC6B05B6; Mon, 26 Oct 2026 18:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 692096B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:56:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC7081A07C3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:12 +0000 (UTC)
X-FDA: 85366287384.01.814FEEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73F0180004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nglWobNB;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzabUPaqxMDWk1LN5/UZ/6EnnSWEJcKuvFp3doWo4w8=;
	b=EF1GcncfH/zTt6n0JPjNiiFcZWoWpWGY27QjLPMrhvAvKoloe3GZSrOFYOYavQ0pkJYSdi
	qHTt96ZneMg0KDu9t870MynDJX5cg2HwuOLwBqz3UWsKsRfYtha3bXuLjv5e+3M6nxIQP1
	5QzluOBDRl0sw8WH9+ePOoE+q//WUIE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nglWobNB;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793055371;
	b=WRlyygSf19VHBuNfb2amJ/fZaC9xbwwaFFMAs9+DLlkIcem9jqAM+sjR5rq78gANJLeIBb
	c+o9hgy9/+InLa0ylabIO7OkeTso6KzhCAnzlJNiLyOOG6Oi1tNF5vVxW3M+L+gAR9u7A3
	6ehhsokFD9B5BBwDXSw3V2VeXqfBGws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 116B360229;
	Mon, 26 Oct 2026 22:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA4C1F031E0;
	Mon, 26 Oct 2026 22:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793055370;
	bh=hzabUPaqxMDWk1LN5/UZ/6EnnSWEJcKuvFp3doWo4w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nglWobNBsbPeQ7ZuKD7NSBzNFEyv22iXun1SdrDTsMNDxfNiIvMS++3ljx0JkrDhy
	 Ys8oi+oZxPQrYxioeu76kI81Y4CP0MxAy5m4Ebu+0SdvcZtqZWJ8HIE6kIPD5p+4wo
	 D5Is7BN9ivdhtNR9s8i0nc4VEs1yHACsIoQ2ff64+soFsUzvxke8Yl+kv6nRtk020W
	 Vvfj7D+0Z86Oizgym9suTHcwCUMUkb/AY0AW0NhJExj1rE86PBvArgzU+nKpmooWf8
	 Qbp+5as/ja+afBsEDyKhH+MqrxbsaLTBO6S0ZVuvmOhLcCf/P2UeD+bS+2x+y9JpVz
	 pXGRBEFc+qmwA==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.12.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 18:55:58 -0400
Message-ID: <2026-10-26-1-daily-reply-0007-damon-zero-target-value-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026135555.149244-1-sj@kernel.org>
References: <20261026135555.149244-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73F0180004
X-Stat-Signature: a3tgy513fbbjx7pfkxqn5qtpsrg8wacb
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793055371-531571
X-HE-Meta: U2FsdGVkX19aHwUMcPqOPZeMahMB2fP76oxoX2Sxh9Ga8trpwt+9xDdn6VIMLmg+fodoRONb2W3jh9YH20Ii9iMD/+HWL/vhVLhL6aJyw10B5dIzcNCcb+3rzW0+LDbq38AgJkoT0BkR80+1Qk+H4dgFOdZkFxUEX0nDGH1JGPSmWZCmehLJRHyNznQnWa8GN/ynzrVf8W+XECTvOSgrObEZ2M8habbubeg3EQUokq7l9bsBYZ3vQuKeaojYDPg26XU+yIHB0Wwv8m8pg8F6JFPbaoA/xT7UGZorDprbKY6NXsZQmyxW+jiDc7ti9iRG3A+5gRMqrkjGEDAuuXT0VAyPd3NuCjr//V6bFEYb+nVCtcYIuxksjRr4VGaJHAjojofWLcdUyz1543IZRuxj/MoTJMl5vhc9XIS/HuuWs/y/swZx5y4M/gpmoZ1w/gNR0K0Qxlh+ud50vJ8tLnzV2U1JU7cDzVL2ajsoYeja7OmNVAQir7FjxyVxFIX38RyQ1xcyDfu62mZ6CMs/Ajv5U8gd7oCxdKXenHM6+cJsR1UWCYMw3+YUflYV3zocnkhACg9t+q/X/UFj6w45z+kqg6UBVNrvHIldq8PIiY236ei2CAMpb7GdBNYE9zs5FNyELa9N/8SZws3NDKa5sZOv6k9QyL2KStMG+hCGgNqCGBmKH1jzmGoTVDIUS2z6SYOQIBrYCaNxF1dYjmy9BoF+VP9lB8VBAN3KfuyfSW07bI2wn/7NpmVN4xD6RzIWD/OMD76QnQ7Kj5zCQc9tFZy42QhLBYpADTRJsG9NgfYBKHO5NP4LVrxyscx9wHNEQVSIg8US7bBPzIa8ae02mfd/fTD7OhsxvuzY2Gw5LEu/kkTS4BrNyLR7wDVZkCNK4hB6nRRUcxbrFRmQighFeIVDOCqtiDrV+E6eul54DRRA9TsUYuR+GK3CEoFBS9ykJW0mMf+wwsnJ5XDSIWSfiRd
 PNctt5dd
 dnjssNvWK7tvS/QJndnkDo3Nth5sbu+0sIY6UiaAG3kFcUOcg1lGiUwgcnlaQ8WFa1iUdZl5PwSqzICSrXXaEPCUtxOJA/LlQ7s9eznPjtnw++nJy45j/qVu4+c8lYjxTI2nh29z+nGcJkKQZRn7dvbbZ3oKf7K97V8ZfYDDHjl8y0gWk3Hptywf3On18SI3Zckp/oHMMqmb2sZDdpUMQR+M97z2FY95MZOBNqMzu6NjI2O1h4a4vQblozUIDolX1P4wO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Also, the upstream commit on this stable kernel can fix the issue for
> parameters commit paths but DAMON start path.  That's because DAMON
> start path does not invoke damon_commit_quota_goals().  To fix the path
> with minimum change, add a new small validation of quota goal target
> value before damon_start() call.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

