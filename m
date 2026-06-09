Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BADBCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5946B0096; Tue,  9 Jun 2026 09:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CD36B0098; Tue,  9 Jun 2026 09:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C246B0099; Tue,  9 Jun 2026 09:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78DBE6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:20:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C78A1205C4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:05 +0000 (UTC)
X-FDA: 84860432370.30.10AE70D
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 66C8940011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gqK3Z85d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvy4DWne9ysaGXsdY1H8ASxix4oKBI9EnEfYdxECItc=;
	b=Xjurz6K2366sYKNyfeftwmctq/QgHhNDuvb6Zu0jFJmNhTq9cTVH7qm9o0LpQIVIcWaGrL
	iWIVcYeV5jvnD2vp4EJRXtwcl9snHZX1iWIJ9f0wMM9BzZ0+cyLhev8DSZV+YRgqLul7IT
	LXGLTxdlznTjfyItqmCOoFDPPwM2KQM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gqK3Z85d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011203;
	b=dQLSFehlkeOQ4kRJ13ANSWuUEc9vLk+ZzzdSfZtNxB+IDHLk2EmEFfJYqeLiicgyn5HNZZ
	UYZb3HtlpFACS4eduzvNvYQ46gpfvs1QDtA7Zlro19JGyAZU4KCPdySAImOx8g7b2RuxSz
	TluTYG9JkFqwNufcbNBhIkQPs61nPJA=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-304ddfcf72cso5707914eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781011202; x=1781616002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvy4DWne9ysaGXsdY1H8ASxix4oKBI9EnEfYdxECItc=;
        b=gqK3Z85d1d5bkt9/Ayr5RsmyVkFljvTbji0kdIBEcZx51Dyi1uCSPdTtJHGsLqXVJg
         nqMd+Jv1L/g7tdyg2B5OFCrm491p1Hzjqb/Y5dq0Y0e2qLVO2YEN6ap1i1LJkcOHFMjO
         1DwabJLrXZYCcZEkMqxxb05zj+/Apcu7akUTuFScTADUOPuP+JxxEmmh9LfyjFBlXMdN
         qHLFgYe0V+jhs97/BIE3wIu2y7XJyR7eXCE01D305zXpIsx+kEUIKGQtUDWa8EDkTmO0
         sj7Z2c/Til+WwYJdfmlzeJ5drPN3BtS98jtPmFe0D1ycPh2heHnyM0sSDIwWx9bjqPG2
         O8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781011202; x=1781616002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hvy4DWne9ysaGXsdY1H8ASxix4oKBI9EnEfYdxECItc=;
        b=VBtHEwlW2cYEBWmM91wo1I6rM808Y5kON0g0r3hl8ogohWk07KndcDDSZJbjLANgPY
         aLtW5Li40+uzj2dXvax70CEJMvDq76DK+Erf6Rp6DCsClEraiewKR96UIiQa3KUXdIEw
         vSYHuJUTxNaPB0nflqByip/CMl+JzeezzP8pWC+/e++BPmXxKqWeuebA7Lxa8LWUUeMY
         mgH9tT0+pmysMXRKSyZeayrsYUqJB3uAefALNup+Rptomdbzt9vlnvcJFQr4BuDveg1I
         8erVu51rrjjqnZZPZJYvMDMQLsXlLVI1uhul61F8Nh4J+e7BDHwnzBAatrECPXedLvGf
         V4cQ==
X-Gm-Message-State: AOJu0Yx7rppQOB8I7/fM/5v+s2o25xrggrwgomv1SG2aPQkv+F+lOcZB
	Nb510VZlGcmckusKz6MrkL01QJxnWnZq9idF4p9hbMHrwsbKoTSMDpz95Yz2TQ==
X-Gm-Gg: Acq92OET/WrshFk406vWHqhXFeFgI4dFmt7HJN2WUH4iN8+3RmsZ8cwXUSeAQJAHRB2
	TPquMmbdPNRYBi8WKYJY7oMowIPiF3FaUWhD9UGwonmMcCe7ozMhsdZaf2ffuwWYMJYoo0yzplC
	abXI+q8WJonV95IEOc6N3/3QDvOVZibIjUoN6y4zNBv97bBWg46AomSCaelxaTIud1gajrzTvzk
	o+KCqZ0zrFTmrExbnkeficdW31Ccp9H0JzGzAbiqkx8nQdZ9yxr4bPys3ItiElbRJcQMVOR4Mam
	9NfTvY62KzHZofu3y2Pn0lUM8+4dawmd98joAojjrkq/3taI8zVBKSmA/rWZhJ5LEFNsPOyrmZ4
	kHe1WAOWC8rKVKZUVqslqKadzxhV60V+mwYPXR30RIb2sYBl84XsMtNZOrP49/z77UUydg2c+Ug
	iSZQm76VZlub64xe2A8qv2LTc9n+t77a7HkX1VZwwS/HDF9Lzfxdy8PoEwNkP9VqnE7x0g/Dc=
X-Received: by 2002:a05:7300:320c:b0:304:e7c9:b528 with SMTP id 5a478bee46e88-3077b2f4881mr10893136eec.30.1781011202153;
        Tue, 09 Jun 2026 06:20:02 -0700 (PDT)
Received: from localhost.localdomain ([129.41.58.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm27162467eec.6.2026.06.09.06.19.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jun 2026 06:20:00 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC 1/4] include/linux/swap.h: Remove unused leftovers
Date: Tue,  9 Jun 2026 18:49:31 +0530
Message-ID: <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781000840.git.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66C8940011
X-Rspam-User: 
X-Stat-Signature: uguryys595si7a5az7ifaio554xduemp
X-Rspamd-Server: rspam09
X-HE-Tag: 1781011203-49794
X-HE-Meta: U2FsdGVkX1/pF6ONAD2/JvTeZuyd4JHN5nfxSrpF/2oQx3E3bEEkIaLh7xm990bBDYu4wqSN8JeI5J61tjV1rHuih+HQX2NDP8HgPht91ffkvtQnCq2MPMSy42vYFKFm2M/b5cFHER47QFEiDYtSe7LWz7U593JlP1pEUeUgRemcngxczx0nmuVEeWnoe91UOiT0YhEU1J4eiVhKb8rGRYXvSS4WfZEGZAjLKQal7aypSJq8PsR/hEL71aVimSSyCzJu83goCXixiVyzuamoPqfr8SRfVfnxhW46dyZVmm2X5ADAeoflid0XfWkqZMZLFJhxt0Ko3kpWaXFA1AgFYPGTBK1HjeQ7u/xcuVxUQX9u0pczcPzLTv0Lk3c/XEqasDY3Se0Ue88OoydtFfJ5wchOv5o0nEh03VxyJkh5f3/jLxiR2xGrwCYXUipX3ZNGEsa7HO4Nw26ufxiUUm+Js69HFZAsPHz/8qFNRVIV9sNhlEx6Z9Un3ZcL6tcX49eDjnpQV5eLGFDG9q9WMO5akzVHZB156vAEq9vZCQXaK73umA3nyI0+oAnX4/7CbAeQtXxjRGNEWZd5wbESBPXA7ZpDMWKryTH2A9kL8kGWPWLa/Hc9rvTukIOHd89U9+kjSEMIpv3dWntUpq2KqjS/vZT4dGp26fLBuiS/e+qwh4tySM72pWsPvI0hhBaM4qmbKukNmdzlz01RzapL0QFx1UhGdpVdFvj0kusWVNQ7JlxfkDWtA7HgfIVp8Zic79yriqDm65aS5VVC9/IBcet7SCx7+I9RVK5P+5Kjy9JHbqlAGdPrQQ6yBlhPQCCRgFmAoG90iAp8mODZBjjsr1mgSR2+BjOMPOBsC71JL7AshYzrwXwR6n6TAkr913RVN+b5r0CqiOx1wYKqcGvBa8neZXUqsMlQA0Xbbfg8aFW5Lo/erRtJNYdC0ijWuZdwBptArd3G10jFc3fE1WQvrn0
 IJnzGc6e
 xcO0m05VRmKFLYseDZhsSqd6Anp9mwhbjJHiDSM2o5DuqLXcUCtdRE5QmYFcQYpyugp36cT/RqtFdr3+dbmfwj30surom0da3RrKShXs/fDo0mp5plgu2NdE9PELWPsoKRR+DZEbIt4TkkJ4835A9JkBgIx35OUnObvYP2aFp/FSg4S/GQUQgRXmYQuJdqHibOdcz6ugdhEDwcojso5tGM9ovT8OBwz0yPMoLc19gBFgt8KQsQ9pmPw+kj0061aWygDBR05kzHgERgXAxXt8d+v7xn7/z1IADCTGrMi4xr2I/c0AQxeRmEgqV6nwGgCcwnS4YgUWrMhYmNnX7/kEUL01451S2Gg3HbSE/I5UldxPgfVK/EORRh3S+Faxa/ScIoNoxA5Hd9NEhEesrQ6DZ/JhfKzyVOgMXfYN6wfEFf8+1US0GOivbywZT3qc2j3sHTptLAv8Oca5LOfuIx9nTjBF4Pe0OhMXNFkMbwHG9do5jbwCxYOZjo++L18Pk24E4Dw9N2sQqamRjqlSMXoDgMKnPY+61fpTJ/9VtLwXUZ7zS04oUm2zHY0QB4zN5iJTZXhR3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This removed unused leftovers most of them are forward structure
declarations. Also removes SWAP_BATCH macro which isn't used any
where in the code.

Found these during manual code review.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 include/linux/swap.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..46c25523d7b8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -16,10 +16,6 @@
 #include <uapi/linux/mempolicy.h>
 #include <asm/page.h>
 
-struct notifier_block;
-
-struct bio;
-
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
@@ -29,7 +25,6 @@ struct bio;
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-#define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
 {
@@ -175,7 +170,6 @@ static inline void mm_account_reclaimed_pages(unsigned long pages)
 
 struct address_space;
 struct sysinfo;
-struct writeback_control;
 struct zone;
 
 /*
@@ -442,7 +436,6 @@ extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
-struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
-- 
2.39.5


