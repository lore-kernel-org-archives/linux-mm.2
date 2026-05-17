Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E45CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 23:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504E76B0005; Sun, 17 May 2026 19:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5606B0088; Sun, 17 May 2026 19:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB5B6B008C; Sun, 17 May 2026 19:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7346B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:52:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAE0A1C1AF8
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:52:27 +0000 (UTC)
X-FDA: 84778563534.18.3CE1803
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0BACCA0002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:52:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EpGxhJ8P;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779061946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPvPNKPIPF/Cm1TfhnhHC5W5nFcxyuwA1UWVeCgbwiE=;
	b=gis8nLYeGd0gYx6e2bmnIQVD1lLwEHhd3TwzH5GQ5GmkcqQVPkcnv+tVHEhYYVClAot7BM
	OMG/SQM+VhpsNXH3wCACRp4yLfZ29kwqDYXl0cLp6fN3+LEIvS/0uD2DpVC2NqR4WMiu2p
	wp6OkgQSorUJLY6jX5epsO3fItNGyd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779061946; a=rsa-sha256;
	cv=none;
	b=SAzOldTRdMhjeklgq16AKZ8BSuSL8dwZtI3+x/fYCG2qCUqKwEA3zT4irpzeXp+tqR5zuz
	YCdwu3YFUGz3ki11o1SF+bPaHYbJS/W+PHZA1yf9mq8NDYm0QBmix+UuvRC0EJQN1UGsDz
	4EPUmIU1MOZC4IpS6JBGHprmGZnAXGU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EpGxhJ8P;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 555116001A;
	Sun, 17 May 2026 23:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68247C2BCB0;
	Sun, 17 May 2026 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779061945;
	bh=l9YnwmGFtVsO7WOpwLzCd3C3mM7ny6syTlIW4Ak+ykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpGxhJ8PZ1mrZaWrDJXh6WWy2VPAoyvkCKryB5M1fTS99t/Pks+I2HzC2cjBlvMf+
	 IFJzzPUQJ4yOx2kRG1yXWa7TrEnQei8CnKBwFEXduc27937DyP2+fiB4kgSpUMpKig
	 zb4Rn0M8cHdTcNgjut3MAAw4sKYBJvfdXHzhEpn48+5knuJAQ5r8xuf9JIJEll6G29
	 cDSqAjE9kuFX5QXAQJXU0J0gFR32f8Gu5wcUOCp9+3vRrlKXcneVlEacUlNMUe4dYU
	 4FSWLB9i3pp7UszehCOX04rMN3f4ljmIDLe+vXLL3CsfVkcXp6nO3EAeF1Z0Lf4Ic4
	 aMVfpvaYUlPqA==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Docs/{ABI,admin-guide}/damon: fix various typoes
Date: Sun, 17 May 2026 16:52:13 -0700
Message-ID: <20260517235214.89662-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260517182624.7167-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BACCA0002
X-Rspam-User: 
X-Stat-Signature: pxunk13pwef73u4ng6e3atdic7yx7uz8
X-HE-Tag: 1779061945-99454
X-HE-Meta: U2FsdGVkX18+Elqp3VgirgSzOGnAjjI+dTratels4miHmHUwfKtRCpsrmOhev5ZqxbsastPbr0aifulKFhICyZGwc4n2+Voe39etcZBQqXOLaRjp5/ezWI2/YLcTw347ns1T9cIMQz5Fm4VXLAZ6e42Tpiorlhc1W9Lc+tzbE6JYGppZ36y5XfNaqycH1N3HylzW8IoxYTMablqncf/TTNmQhjGYvH9knXnJF8emw7A4LNEPbO83m3fcGUnWWYDjNLjE1N00TkOm6aFDTvVqaNxxvIrtvODKdloXCu0RaoUo4MXD1rA3ylpqw/Lq1eIdc3u81m1G9hA27r5lOhwarxhAz7bF9PxtC4PGk9C0nOjo+3+Wu9s8qoP4XsR0i35qqHHmbLp5wcnv7MGvxLs7rz5VBQw9CVRoGNpXdlOcQcJzSyV6n1fjFSPcZhU/xF9YRk8oXaN4TSRZlYD7F9U2IZfBt17YOtyM34p33LtH1rlRxmxwSpQ40voZf8qZPCBXveoQtuJuwTLltj5KF3SQPK8fhKDdhVaBJ1HhFdWa/sTRtNP8Yrkf2FmJirKDkH58C4fGJ5Cut+RrOYCnUwOW4iU9KCyQsfbA1wUCZiGzSINlEAHDwLbZCCTsgrEfE/VWRPjB9hOapJIs+j5oX6rjla1+s9GvkJ7ABbZgjSUGvaVgKI7KHLpUcEhWnJ0L6Hk/sgFJ+Y/DBzfqfGHsqQVmaiIg39JZrtiWg9dxfK7U2yJukv3zhWjVfxqplFvxQRdw4IqMxBxiK2htKmCTG6hMx6YugLyKsSX+iIkY1PPv2CF5UkLlrs3dkJQGWr5Dy8GZ/yxdhBG1dFlaKZHIKjb+QMHVRfIBmAqYLhkFmx40BMGCSw9eOqyvLdhrObj/SuCsAuFBdKvrtmp6uvxxV3GLZEy1GMWSrXAq1aBJEyFzeFpnhqm2fTOQM9iKMtDupHXTIUtwcXHTJJ39bhpeOoV
 b9PW0xHe
 ccfprjW5Gy4rd8+u6xEeGmKUxURw114YL39gv/ZCTEb4aZ13kxAf3UJ1y+2i2Cq6fpWUE+ECxAmuVEAOuOJIya77fSwNeKHG3uc10Vx/9MJVfVtR+IY3zvTlpGh7cNIwvy3A3pSsb77VaBQ+0rFRCHuZhwvFDDTub4C/ObNO/8bVjK0wU81hyrGzxwdAl7kk2L6tdq2AzhYcvWTb2SpSbriQTiT9H9Hw9psE1DxvivwogCvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 02:26:22 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> ``damon_target_idx`` was wrongly written as ``target_idx`` in the docs. Fix
> it all over the place, as well as the wrong directory count, grammar, etc.

Nice, thank you Zenghui!

> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

