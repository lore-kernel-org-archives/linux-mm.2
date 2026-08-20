Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D93C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF57A6B00AB; Thu, 20 Aug 2026 15:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5826B00AC; Thu, 20 Aug 2026 15:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC686B00AD; Thu, 20 Aug 2026 15:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDE76B00AB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:34:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 151C81602AB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:19 +0000 (UTC)
X-FDA: 85122649038.19.95CA702
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76DB9100003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:34:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gK+a6hxJ;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254457;
	b=iXwBNjyog1e9RkPVJ6w/VyXkh6lT01dCUc5+V68Ep+CPd4E4K/20LvNeHDwqg8AlMzQdvD
	DgdCggqtn4StZeHXp1GYRx0phX3Z9HDm6rHhyRQSmFj+q8aE6+TjlHXqQGf1LCLuo6k+E2
	Aal/NuDP6ic/a3yiX5rqvhhlFNvydPw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gK+a6hxJ;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzEUj4hlm5g43Y8sYo0gJEtX4l9xsY1tZauPsEw2Wqo=;
	b=yg5s1Xgs+NhwvRmeNUwcjPyV7ZS6a+AC4G/N+lDKqqP2Rlj39HlSFJbNczhKcP1MV98rDd
	Ike86JbvyEU5FwCXNDozeoycqXy29xKzPzMdpN2galBRlM3PM2IBT7Rs4ipROa2w9GLWhR
	2fbXgvE4YTiRZFpiOT+2OypgRnV7x/I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LzEUj4hlm5g43Y8sYo0gJEtX4l9xsY1tZauPsEw2Wqo=; b=gK+a6hxJT7qvWllQUtPGM8F6CP
	c/+4Zz6aBT8Bi3I6i7eFeH2Qj+B8NY8VDHA3xOgk0qesJuC6WVisRTI73/rfDhI0AVKFYUcomlAyV
	GRJP9ae6EKC7VbNqbPUFtpGJADRW8Qz3oLfsyvn4zRe14CiFLI0yqkg+l44bIMbZz5qEyd9d5TGUl
	YZJ7UNsC5PrcqbEdE3EqrSCIipNgjIW9CD8bTJR2upzWZAltzDokJXCQamLsGNmXCmG3c6Ucoulfg
	V6pAILiCli0k2vTtvb/K5MwSGA2u1DwSR35QNsR1oeFX6jO7qqJji4M3DcoHIYAcne4UnY+L2DS/d
	K/XT99Sg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx8WH-0000000GALj-1JTQ;
	Thu, 20 Aug 2026 19:33:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6/7] orangefs: Remove launder_folio implementation
Date: Thu, 20 Aug 2026 20:33:39 +0100
Message-ID: <20260820193343.3852967-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820193343.3852967-1-willy@infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76DB9100003
X-Rspam-User: 
X-Stat-Signature: igbw4h6qmastf5bcsz69er5sx8ba4kst
X-Rspamd-Server: rspam06
X-HE-Tag: 1787254457-852317
X-HE-Meta: U2FsdGVkX19ecq6xtEde4iy6T6y4Y5pru47U05DwHR3I8mn4vFbXCmOuHVrcIBBrELoYS2jKH8acJKgDse/d+Ys8fcDMk/sT584pyEGMPYHWjFfY3efEJSH6N8y7rcJjbYtqwioEombmN/9eAsofDX5aDGUuaGAZtkT2s+2YyV2hEKbpXBVoozmwoGrv85hvtJHfoYyngbQEVe4T5sEmc1YoYcQ8M/b8GfXliYB2j5kCa2D8tERzYNSpC4pcn4gDagyt4R1QvDPP6XT9SBZ+s6iNp8BhKxEBVtwwyondQiI4AQCPXYANTJols/nS6vJVGJOeOXcQzaeB3K6WEj/7lGdh23t2/6V16AmEbpextJ2vpuhjC3keg1PBruLrt5KSKlD4tP9wSExDijZBI6/wkTSqMNBW359k6epiW0x8U37i7KeuyjFx3Va4cMABGLPBcivoCPgdWcuZlnek220CZe7/WT0bmZQIYnD/h4D8up1aY4MXYpACZxRhAXvAKtpZEEewGnlYATj3R0HFuaspxiCohja/f1818ht8lSJ4pLrcE/GxdFYNggh5QPIja5w7HvxO9aLJEhKKybwYIxL3PKYv09v4RfwFE0BhowEYdZfo8qCABqrlvEfoB26tQJS3rTDxZZL6aypWzs6ZoVGfg96fS4Lbu/EgheBnx6oxfNaFMuJh2t7lkOp6KJ+sB+4nSBBW9i32zdXgmYbCZgfIeEK+OnwU3rvIvTxnTgKoxmbKlPuS1FwisFpuUWHSDGxrEs+86RjJrmdeRVgW/ULbkuuwAl4Nc6CtgYoFWsh1adEYk4LJmeh+BvT07GR6xZqsSsez8z6ugZ7yUgdve36Pe6jotIKJUkexgqGUtHiKT+qE/ztEG8fb/EF8RGIs+LCejEfTGC0Kn5yUUQHmUrkeW52t8oZvMJ9FwyC7pKAwnB5ChZXFXwpbF69ujfzFwKLQLsFo8OX3plHpt8oEdQN
 /DATsNqE
 9/IbVIpwOjWsRR48qsBkoSF/zCIN4mChvrpDzgTDFihxw93hy30Jmb2m/z5ZyAxoo4/ioRl0jdCjzjzUNavSHoWyvOg8jMN82hAPhFGmLb3eiD4Fb7Y62t/H9jzP+bHtTFBDvQvPWmHPzonmdYGiLRaqY5y/c9BIO6423xdx2rj2P75qjrwG/wbOk0pHKlQQJTURiwYmW8UH0gE8RiFzhO4wIai8dvs4MBtgsmBX2Kzm8+oa11rYHjPMG0WeduVddUFkSZvAJjzwuEcgBcsDWUVatJ9V9vEphVxU39UjqiHo8pGC0dJVPf/RObM7mSX0zYvcvIWgpwOFuHY/5x5lsU4pi/qqJjAMa7vt3xikbxKGEW9sCNUCzx0V685npT/ANFcrEisA+2k1L76D6CaY58fxk3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There doesn't seem to be a good reason to implement ->launder_folio
in orangefs.  Leave orangefs_launder_folio() alone as it is used
in several places and removing it entirely would be tricky.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/orangefs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 7143b64b5b25..c1f5658ba8af 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -616,7 +616,6 @@ static const struct address_space_operations orangefs_address_operations = {
 	.release_folio = orangefs_release_folio,
 	.free_folio = orangefs_free_folio,
 	.migrate_folio = filemap_migrate_folio,
-	.launder_folio = orangefs_launder_folio,
 	.direct_IO = orangefs_direct_IO,
 };
 
-- 
2.47.3


