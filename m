Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F8C7C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C4E6B0099; Sun, 30 Aug 2026 00:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA15D6B009B; Sun, 30 Aug 2026 00:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7F96B009D; Sun, 30 Aug 2026 00:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7A936B0099
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8C391C103C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:25 +0000 (UTC)
X-FDA: 85156631490.28.80A4DB0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BC2D180007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=St5YwczI;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063564;
	b=yW9y+OVmdMBSzpvtbQy3YzMkp0UHo8om6uzJwO1S07jkDZVySJFRuZAAIR5LIISmKuU6on
	t/dr3OOy8cCx5PLskF7+UeidC7TUWm1sl31YfhzmdvABgp3xDE6M5Sx4I2Uj6Qz2aBiqiL
	2dtofPBgUE+1jIVFaq6Hotb54AbYQwg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=St5YwczI;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LhwqzyL2tHWHjKBCqUfd5fZsEqJTMNd4JrJ5Ssrbtk=;
	b=ULY9uXInee1kSGWT1VFpcWhPrVnC/KbJxzAVHULtorNpKCu2SEt8BbRiyTQQC5c0Wr/hOi
	FmRg3UzwDFQIsUP+Y3BAwUVxsOqDMDdyfB2ydaTVPUHDfITtZdMl4Fw4qf8yJ147b2oaoF
	J2ThV3JIzScFd0eLrzWrM3qCgLS99y4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=/LhwqzyL2tHWHjKBCqUfd5fZsEqJTMNd4JrJ5Ssrbtk=; b=St5YwczIjGD0oycKcDall0vCVj
	B/1aacESJcnXac0qwwdgA/3w7ddFCpbvgsmZ/nlVJWobcV88bxg9CPvLkAGBCmV8ocwJagWRH8n/Q
	F216KC+E/t18eabT9+uXGIANM5zKCAR54zmlgGDg86mc8YESyhqBWaZu0k8XEEXkc7+Ll73JN1N9e
	S0K736Ep457HSJh8byMrQqKhowm2Z2zDnpX+PtHZrMZDRAXNuO8Q2e3KDVtpG2GzHgIXlWZUeiWzt
	KYUd1hZSWA+A5i6//HQpp0cdcprL0TWsBtQFQSGfDQWm31miYDxSCH2g/AIYWfGA5lOLoy0abA+8C
	1XFm7/+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i5-2UZC;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] filemap: Remove redundant FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:55 +0100
Message-ID: <20260830041901.2668-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BC2D180007
X-Stat-Signature: hqzdfpq5bz9yfneuthnp4aa3hp9mzzje
X-HE-Tag: 1788063564-908192
X-HE-Meta: U2FsdGVkX1/DeHx3DbRpn2miIkwFTPhZ7q003Loa59rWLomhL6uy57kNlNArBA0dI1t3myO4106QfSTvaYaf63PdTBuboxdcHRKISmGyNZpT9EzwfwOW3VRwCr9RjVRHAI2c/NPYD20ItBTrL6EPhj3HYfVEPUc5xyZwB7KjTjf2sEM/zTSvT0tj1/pr385h1SZKMOmhfYmBfbGxVBXVnLzxJp9iABumzp9nJgTU7E40BWDTHWVHLFHfVJKHAtoz2b5WEDWT168xrCV/ITjQgIFyuTRFbO28VuU9q83x0PMcDoboD3C+FLJ8POPNnwBr2o+NPEBemvPMxKx9DPVdtWWXVd73lyPC0hU3SZtOA29Z7Ncrq0VRNvMbw14fF8/Y79yWXts0hITuIsg5US9EixOCwJKFevxpV+HU6EliyGduVMn/DxbaUdI5KasAYh8yyBGDZmjVHbCrUSNHHGH83ZpAn1Rh/A2IcughPDPVVFnZH6/NfcECxGBtU66H6R24ym1hmvs2rLZez3r384od1F0kV3VnhKit3xo5DcLaF86Y/Xf9IVm/+KaWiQeORFJonOK/e2DytBHqgIoK5przPyUvPzHp5U5Ger/FAYlpVgUKGm1Xjq+9obkScOllkitkuDt/BvDa/rEyiEhyyfcmL9fSnv/1oujlV4Ve8Zcjl5rM+LoDeXWl3BtSI31lot94PsEYvFKSyUEiyujQsyaU4xd2OqcL+KIonk/L0ZCwVhu9YZGaPTIEhvZ9LM8ZWJ9Dmektn9m1+CfKEtGn7eB2fVBx3JaSNuHcEMDVOqkpCxgBdsep22qHVfXy1Qceqwr+90Gkj77kUz2TZn4WA+cLQYni31CzN7v4KlCCTz26G/fplp8Q2dzrer4RpzJkr5aZGiksxAD51a7ImTfs4QdMtJi2vMCVRV3elpsWdH8/69sGSIgvG2dRFNwVwpq5Vd7tc4SUuY0woTowISpDOaP
 jp3HQI/n
 P/uAEIT2xdT7MwDVYhroarMnEjnR6Mj5SLbx4HK6yfyNEJPXxT1RiUN3KWR2x7kE8ZZSYoT8km3Fbvzlboy+W/gH3c08fT/Q+m9p199dPNx7BRk4O88DgCf3qWQ9p1UB/fv9B/JfPC5ADrGC++Zybiq5WAE0cS1+KhcSg1QAkYhR+Ug/r3xXIK0MVMru/6YDVMkX80kFNOj0BZHkVjip9mDy85fRjYzDX98RRx7kRrKukib0VqMefXLMzHqgquV0jXu7aasVcEdof8TW8WD2VBfhY7xdovJcFhdWFMbXywE6hGCDPR8ElIBbVDS3wDdRlDjBwzIbF8CuHjyHERyy/QLLPe2wnwAzcDLIDKBaMGk69hOIqLUt7Dh6reQ56H0pRe8F7Z4hXMg4fhUBOAnr2zutjvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The flags already include FGP_NOWAIT which prohibits all reclaim, not
just reclaiming from the filesystem.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..3974b063a049 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -929,7 +929,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
 				pgoff_t index)
 {
 	return pagecache_get_page(mapping, index,
-			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
+			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
 			mapping_gfp_mask(mapping));
 }
 
-- 
2.47.3


