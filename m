Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0C7606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZD2W6ANq
Received: by kanga.kvack.org (Postfix)
	id 178BF6B00EF; Mon,  9 Nov 2026 10:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1512B6B05B0; Mon,  9 Nov 2026 10:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A6A6B05B1; Mon,  9 Nov 2026 10:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAA0D6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:53:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CCDA1C4013
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:53:38 +0000 (UTC)
X-FDA: 85416025716.24.A221946
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB170140007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:53:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZD2W6ANq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794239617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbGDBqU4nxW38rvN5cjz46VE+ozOGhYAeWZw2r2wWtQ=;
	b=Wu1baGLw9SCv+SWj01FVl2DBU+Isg9NfFjnPsTNjQHAxM/weDBBoqK86+jSIPFrhr2ZALz
	drnoHXjIX6LRs3Cmn8iIMVhiu0GabbsRCdulhJYdKeN8Hv5RrUatRRFSaYE01ipJ8uXSVM
	3QDGSgsIx0sMBIGDkcZ0aOzzJap2bw4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZD2W6ANq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794239617;
	b=UCbW7fr+4bEqJpRnV8DAGf0e6LZIrIMdj2hAyq6iWz1sU5nuug+QAhE5W/dM1zUGkQvINV
	G82qVMQNfaH3PKhE0+Re9rxxAlfI3jqMihy/Bb28hwRW9YmJDbHPEhlWLyZfxcU1D3V3fL
	7AqaEnrb0TvUWHvcqd19GlbTjYUBtVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F78163379;
	Mon,  9 Nov 2026 15:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E61F008A4;
	Mon,  9 Nov 2026 15:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239616;
	bh=YbGDBqU4nxW38rvN5cjz46VE+ozOGhYAeWZw2r2wWtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZD2W6ANqH+nwDuzFgWpsFsA1zcRkNWiLxO/AHawwaWKnymA4Do/F+Yk/v4oqUYWjD
	 v+fCAIHVschbqevMzl0HOkMedPkWkRMeOpbmBfb/l18Nz9xSx/doUHrxhU/N3FLJk3
	 HUytSJv7gwmtQsUOPZjjZnZX/4XbF3JJqhZIabx3+AX2mJ7lieg0pupBpmIMIKMOha
	 CDfeZgIMepWKOrYYoVVWxyuF+jyYn7+xYKKzdQ9FaMxOq4APVpl4yfCAPDmOVjPtKz
	 4P3adLtS9aofXJYW+yUHUHfsRffabDS+NsC2T1ahdAYiX/1Yt6naGxIwEHJihk56M9
	 NMk2DZfM1UNtQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 6.12.y v2] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Mon,  9 Nov 2026 10:52:51 -0500
Message-ID: <2026-11-09-1-daily-reply-0009-damon-psi-6.12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261109011347.92467-1-sj@kernel.org>
References: <20261109011347.92467-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB170140007
X-Stat-Signature: buffm5uqqc8dwpkgwwam8mu44w4xbu3a
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794239616-560775
X-HE-Meta: U2FsdGVkX1/0c79lUGXEbws5+2IRWJcCOc2YGz9WCkA4lGG+PoLpSsaOVl9mX3od+bXwAUppg4oTSbIl20quBUXFumoWj+jZcsVIzNlYmEg/zPXPF9meO0ikJLdSXGIqawtrMBFGdaMq+73dta5oY33/pJPo7XkkQTyoNAziHzJMw7AX64gkBTvjejVbc+iL2hBXcghoegZPb/xjCs0JgqQMB9gMmI5XKCExYgcQ6t2uTUrmNt/Z02lBXTab4HDrI/Spm8GayBWwSaafJDKxOR9Bi6IsO553pfYqoISGWrelAmA/mq1kur+xCCFZfzGONnJPV21iCrisaVUkBTBbEqtKUxzTUMZ8CJzpVTD4x3mrOIDu2jOuTCYZTYf8Rb0iYOKeELivvRe9ICHvKdOyz89187bfSJXagtEhM1CsuR5h2e6SdvBXXHKszEmLWbuFfLFwGhzjyb1r1+iTIw1Oh1nU8gHvsUyI0K+NER6mkT+ctYlDed4IMrDN3Skac0Lm00I87qVPb0l86TcntsGB+uBQQsHe6oPDHuIRKF5XXHyQxxYIgwO1p4xQnav1pBIxogC6q9gBNPHFGAxP9hDPzo5SrICLH3Nyy0cIgs+7Ema+9FkimkCMtzYO93Q3s1BCSuVHF49HCflZ21E325DKdJhjEOu4f1+p1SUt16fG0uMR1sq/o2K+7vNMlhLu7A4PHV7T1omq3113s8DIwKbh9vgddHsGtxJy3XUJQWlA5gW0HPOPwhKfh6e9/uekwkmh4Rx8vgRLe7OC7m9RDtTDbAxswCreNQH1dZQnGHKh8MtfqrXLtbSoUs6XTNjjcI2cBPSMsOzU80ZkHTRwQk9R9DyvPcXRsbM157W5M56F19h4wN8R9UDhYkliVw1R4rTba5fBPvFIgTCrjMS44QujBFNAexk57qjUslI3YS9YSEq84kIoqdKyV5mlifrUEs66JbJc1PaXawYJGdep38M
 Qdq3FPzP
 K1k+4VUpiGq5yP/RNXt/7Sb98TfkQXZHJSD1pNrXRgUMInk8P692VRpN43OWionGPDk9DMlgMKX8s7bPjjLcQBMInwHAry16GJumIkU8IWiz38vie/Scxsc759J0JjrNxq0Afrce25faCfdQVYUljVLHOUzKe9CQ2UPJDNopbqWAaET7d2WoNRfaY6BbhJBjmqRWH29GsOuZYudzhKc5PnQRRkjOGXdjNZQOlT3oshpV+rMiQevLB0eiEzct0asV8Vs+5DM+EOACsiZow9CP3rqbdcfU1/vk0kQswTYbyQ+sFbolXkmmnlBVA2iZYjXKfBp3sSXomBS+2Xb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

