Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF42C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68B76B0088; Mon, 29 Jun 2026 04:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FB16B008A; Mon, 29 Jun 2026 04:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FF06B0092; Mon, 29 Jun 2026 04:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 612DA6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:10:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFF64C1B87
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:10:41 +0000 (UTC)
X-FDA: 84932228682.20.4C6820B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A7D31C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:10:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=an42CPPM;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720639;
	b=tzD80NAPRS4WzMHnmxS7UY/scmXsaNN2DSg7ZmmjJ0REXRb4bou7CUq8XP21KfyCBJJsqc
	m/DgBpfvThIAkucaN8DZhZ8usJptqMV8IVASJDWp5xDpuhkhF6R48qk6gAVJ/yKkZxEyg+
	OaPSKbSfy4ZUj5Ng2FWh+KvC8Hcsk4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfZ+eLRL94nE3BApW8xdPyWC54V3q52Zz68GpVEJjh8=;
	b=1Wlz8cmwJCKwosdYiNpHQTyQz0xiLx0KtiDw7uydwDowPoZbt+DsjHxzKMN4Lzjs/7C+PQ
	cgR9dUo7XcsCxKdJ/uMnzfqN3wMOJAp1jzdrM0fPgqaf5yj9dAcJ+Eom6K5L2YK0lBmjIW
	0l37P8OlXhvgjpYwAooYS3ZpewdY9rE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=an42CPPM;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782720638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YfZ+eLRL94nE3BApW8xdPyWC54V3q52Zz68GpVEJjh8=;
	b=an42CPPMQW7GzG0xanEA7A0pdzd1YgNFavBrrtt1xh25zZWOBLi6H3w74Nn9hzWxPZqcp7
	5OR+L0NuhbI0Y1vCwyG5eMGamd6qGqG1lH7iyz4J6FpX7209fBCq28CGxUqibB8tOzFqOM
	9tKRy9l9G8C6mgVI2y8z2j2N7/oW+go=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-2KpU_aPzMy2MiVe5s_JISA-1; Mon, 29 Jun 2026 04:10:35 -0400
X-MC-Unique: 2KpU_aPzMy2MiVe5s_JISA-1
X-Mimecast-MFC-AGG-ID: 2KpU_aPzMy2MiVe5s_JISA_1782720634
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36d97a4e08fso2238001a91.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782720634; x=1783325434;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfZ+eLRL94nE3BApW8xdPyWC54V3q52Zz68GpVEJjh8=;
        b=bni1KxAVe/MC6U6pQYj80x0ki5B5QUo8g3xIZRyHaci0mj8cDdwbv99FIlM+Z1ZmGy
         VDiHD+OemOb/KpJGuLp2f6H/p8zd3O9wsXQdn11XX66iQn+AyRbwVnajM6vxOBWx7YDn
         2Twau3SGZGpR1qnTC1dRomYLR4OsiVuhMbAXShXv3/tvq41M1wgBYEpcA5Ms2I3Sgo/G
         u7Hn0y1AHREQhXHickOe7QgrAeglsdocM2CCt6TRpqfW3Lo5VJFy+VOujdtnIP8qMd/1
         Kj80ltSX6tDiwfbVSDYK+wcpSgLJYhX0w7zf6QeCCc9qxF9EnhWVMJp1qPbwBgZNiF2N
         2pnA==
X-Forwarded-Encrypted: i=1; AHgh+RquaudWdg1LmOtU0eq8qv0b7EMf/Td+IxWb6m74FG7yopH7/Iqej8yJUznebEh+nLnFTA6BHmQNbg==@kvack.org
X-Gm-Message-State: AOJu0YyXuhJYtUAJhh2tsYmN8+UtpjmI17XrHIqqSanl/FzGJEsyYlLg
	LPsW2vd5ilGPFbtRm0U/BeF/XDD0rg/cgpWKF7ZtArNo9ns2x59qEk02OKF25ufhgtfT1wtuCtR
	uBDi0TfOTh0ElopEF29TbD43ISrnFa60O1eHsm15dDVm2W+2oSsVs
X-Gm-Gg: AfdE7ckyyx9nhk16tO96fhrArWIjOFKmSopEG3HwVjQ7Y/UGGdKGEgOYum6tLBTx+v8
	1eLF6vfr6N6pWfzmATdam2+5UZYaHCCupqBDdnp6XXsvL6CqW39Rw8htgiE/iMMBkyybBDd7X9M
	h42ah2phbp19melPU8YZVGWt3AApAdZrTzoxsCsHRCnqmn3o5Y0r7ob5n6pT9thj1v06brBhHIr
	Wd0SKgm5nY5u94e5BrBbE60EERQmDJFOSUO/3NHVlfgiT8N0+tneYqrBctDr3mSV7dOMsFvDQpA
	OO++LoMRAkE4t37iYep6v89RhrkB7OJ1oWxMm7CRmR82ugwmIjiSqeTjI1AfPXKlejxA3PmcqxB
	EupJ7MQrp72dyj2DJaPzu906xN+m2o2Ap
X-Received: by 2002:a17:90b:1a8b:b0:369:7f25:cec0 with SMTP id 98e67ed59e1d1-37df9d55f51mr14591054a91.0.1782720633633;
        Mon, 29 Jun 2026 01:10:33 -0700 (PDT)
X-Received: by 2002:a17:90b:1a8b:b0:369:7f25:cec0 with SMTP id 98e67ed59e1d1-37df9d55f51mr14591002a91.0.1782720633020;
        Mon, 29 Jun 2026 01:10:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37ec8b2fea5sm2343101a91.0.2026.06.29.01.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 01:10:32 -0700 (PDT)
Date: Mon, 29 Jun 2026 04:10:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629033608-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
MIME-Version: 1.0
In-Reply-To: <akHUboUaYi-OJHFu@firstfloor.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XrjzkJmSuumbH__2Zb0Qy3AMe-tvLDgFqv6R-5c1xu4_1782720634
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 81pkr7t4j9uhin7p1hfp1ers4fn15bzj
X-Rspamd-Queue-Id: 5A7D31C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782720639-404033
X-HE-Meta: U2FsdGVkX1/bEYofGGeQVlxFZc54+Ump8rchg4rVIElN0ks1HHrSJpQouW1Xj6Hs52l5b0+1IFCMee+TLvL+XU2MFTC1raPqfh2JXfZnfBTsi4uqwG/gzhmkfh+b84IkzAHVrYhesjfRdTCbY50jZgJVl1vvRevsha9swvLBtSmXqp6BC+QyQ7EH075KtzHqTMCxNEeSNtuEEZdwJUcCGIbHcsTc+tlq4T2O2cS9iaKjvvF1zm5gh1EQJn4JNi0sqjwOpwbx3zKuNe8kEK+25AcQ8IhgJsEGR/IJc66bJeWR68PKLN9HQ29oOKF9wsCv2cHILLj+1hinpiLZMnHQQIeO5cx2TdONLnhWDyuqk39CzYAxrHLHKYPsUFwPNrrzgA8HN7Ye6vgyh6BM+pOtnOpgH70Lkd/nmPV0HGwtXaRTbJEYQj7MWyqbbKOrY6zrvby2TagSKjgy6yLZkdeBhqHRqSIEkeOMnF+cS60GsqkWk2VoX6hQjQosMtWKH7qdAiSwnBFCYaXPz+6CJOWv2Yk737iRFTwnSSCC7hB6cRF0TR0+k7h81miggYRzsbFfjNhTyLfe3CmAPFnSClKLgmqKk1u5vZ37zM6yrzEbN39YhbYitomGTUyVeAbYjUIob1YzT0gj15JwBvWxzToeUJ2h2lxlwrGu6eNRfSQUvl56NWt6n8l3rGK4h+pGrsx9U+7GzQOUQp8SFHMxJ1IfZmH7LFIW84cUCzhDg6vAyM0+AmECac9j+lFhX5eCw6y5KJat8AuckNK7+s88GXzStPGqmpCb2eYeLqTb7daeInjr3HdQVhpHqNrZ0yZnmy7DenwA4469bLAYFacGbxe3NoKAxYzVk3DewShA8065aBUWSm63EXhNlvy+ZHoHp8ZRsAyFxJQ1bZ9KSakd1vwRcnsf0IbMnIGtN3sihQhobDZ+pwKbgUw73spnA8dajNpctyXY45GEq9Es8G6/u1E
 HndqwQVo
 cW5uG5pfUek5XFSCtZ7AWBvt2bAgFGhg3rYpxDZybkNvDbwF+OzfEYVeFDsFCyB8sE2kkOdeYeBUhCU4r266hPmbBNjRqqBvP371l0NhMMAae/7SIgeRw8E5Qz4Zz7nec/qpzYBd8TCmaj91FdHNfiuXhPzw/EqbC2BVPCVUpklnI0M3qmeegf5ADWN+MKHJ0P45TDGDJbkLWDtzDH37lt+0CEFejtPkWQqmiU2tqhB0tJjDhREJEQi0fhAlDtqOzfhzrOxjfOyEIc0tPsdI+g8/Ihrl6DgX6lVRiXuubzqlmaxrXLnJTaUPzP+PmbjBskcEFEM20KqGcjdtbXgp+ru4qKwgJdTnrow8fhwIwN8YYrucTX8xbIv/2mhgeug7Nu0JA21/A4UthRg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 07:11:58PM -0700, Andi Kleen wrote:
> On Sun, Jun 28, 2026 at 05:45:22PM -0400, Michael S. Tsirkin wrote:
> > This series fixes the race by:
> > 
> > 1. Having memory_failure() call synchronize_rcu() + retry after
> >    setting HWPoison, so that any in-flight non-atomic RMW that
> >    read the old flags value completes before we proceed.
> >
> > 2. Wrapping all non-atomic page flag operations in
> >    rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
> >    so that synchronize_rcu() actually drains them.
> 
> It wouldn't surprise me if your underlying performance assumptions 
> -- an non contended atomic is cheaper than a rcu_read_lock/unlock --
> are not true in various CPU/kernel configuration combinations.
> 
> Modern CPUs have fast atomics when uncontended in normal circumstances.
> But it probably doesn't matter much either way because the difference
> shouldn't be very much.


Hmm. It's a bit silly that I didn't try. Seemed clear to me, but,
on this old xeon...

                                   insns/iter    cycles/iter
     -------------------------------------------------------
       base                       12238 +/- 1.0    17889 +/- 97.9
       rcu_read_lock              12251 +/- 7.3    17991 +/-191.6
       atomic ops                 12233 +/- 1.9    17733 +/-136.5


The diff in the noise.

And old, slow CPUs maybe don't have MF at all.

So maybe just atomics instead of all this mess.




>  It seems very complicated for something that
> could be much simpler.
> 
> But I guess it's fine.
> 
> -Andi

Indeed. David already said he's gonnu look at this himself, but here's what I
tested, maybe helpful for whoever wants to try this approach:

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..8f0940cf2f29 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -404,6 +404,44 @@ static unsigned long *folio_flags(struct folio *folio, unsigned n)
 #define FOLIO_HEAD_PAGE		0
 #define FOLIO_SECOND_PAGE	1
 
+/*
+ * When CONFIG_MEMORY_FAILURE is enabled, non-atomic page flag operations
+ * must be atomic to prevent clobbering concurrent TestSetPageHWPoison()
+ * in memory_failure().  Otherwise, use the cheaper non-atomic versions.
+ */
+#ifdef CONFIG_MEMORY_FAILURE
+#define __pf_set_bit		set_bit
+#define __pf_clear_bit		clear_bit
+
+static __always_inline void page_flags_clear(unsigned long *flags,
+					     unsigned long mask)
+{
+	atomic_long_andnot(mask, (atomic_long_t *)flags);
+}
+
+static __always_inline void page_flags_set(unsigned long *flags,
+					   unsigned long mask)
+{
+	atomic_long_or(mask, (atomic_long_t *)flags);
+}
+
+#else /* !CONFIG_MEMORY_FAILURE */
+#define __pf_set_bit		__set_bit
+#define __pf_clear_bit		__clear_bit
+
+static __always_inline void page_flags_clear(unsigned long *flags,
+					     unsigned long mask)
+{
+	*flags &= ~mask;
+}
+
+static __always_inline void page_flags_set(unsigned long *flags,
+					   unsigned long mask)
+{
+	*flags |= mask;
+}
+#endif /* CONFIG_MEMORY_FAILURE */
+
 /*
  * Macros to create function definitions for page flags
  */
@@ -421,11 +459,11 @@ static __always_inline void folio_clear_##name(struct folio *folio)	\
 
 #define __FOLIO_SET_FLAG(name, page)					\
 static __always_inline void __folio_set_##name(struct folio *folio)	\
-{ __set_bit(PG_##name, folio_flags(folio, page)); }
+{ __pf_set_bit(PG_##name, folio_flags(folio, page)); }
 
 #define __FOLIO_CLEAR_FLAG(name, page)					\
 static __always_inline void __folio_clear_##name(struct folio *folio)	\
-{ __clear_bit(PG_##name, folio_flags(folio, page)); }
+{ __pf_clear_bit(PG_##name, folio_flags(folio, page)); }
 
 #define FOLIO_TEST_SET_FLAG(name, page)					\
 static __always_inline bool folio_test_set_##name(struct folio *folio)	\
@@ -458,12 +496,12 @@ static __always_inline void ClearPage##uname(struct page *page)		\
 #define __SETPAGEFLAG(uname, lname, policy)				\
 __FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void __SetPage##uname(struct page *page)		\
-{ __set_bit(PG_##lname, &policy(page, 1)->flags.f); }
+{ __pf_set_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
 __FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline void __ClearPage##uname(struct page *page)	\
-{ __clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
+{ __pf_clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
 FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
@@ -806,7 +844,7 @@ static inline bool PageUptodate(const struct page *page)
 static __always_inline void __folio_mark_uptodate(struct folio *folio)
 {
 	smp_wmb();
-	__set_bit(PG_uptodate, folio_flags(folio, 0));
+	__pf_set_bit(PG_uptodate, folio_flags(folio, 0));
 }
 
 static __always_inline void folio_mark_uptodate(struct folio *folio)
@@ -1162,14 +1200,14 @@ static __always_inline void ClearPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
+	__pf_clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 static __always_inline void __ClearPageAnonExclusive(struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
-	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
+	__pf_clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
 #ifdef CONFIG_MMU
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06bbe9eba636..931dfc84319f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2343,7 +2343,7 @@ int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
-	page->flags.f |= LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
+	page_flags_set(&page->flags.f, LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 }
 #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
 
@@ -2503,8 +2503,8 @@ static inline struct zone *folio_zone(const struct folio *folio)
 #ifdef SECTION_IN_PAGE_FLAGS
 static inline void set_page_section(struct page *page, unsigned long section)
 {
-	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
-	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
+	page_flags_clear(&page->flags.f, SECTIONS_MASK << SECTIONS_PGSHIFT);
+	page_flags_set(&page->flags.f, (section & SECTIONS_MASK) << SECTIONS_PGSHIFT);
 }
 
 static inline unsigned long memdesc_section(memdesc_flags_t mdf)
@@ -2719,14 +2719,14 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 
 static inline void set_page_zone(struct page *page, enum zone_type zone)
 {
-	page->flags.f &= ~(ZONES_MASK << ZONES_PGSHIFT);
-	page->flags.f |= (zone & ZONES_MASK) << ZONES_PGSHIFT;
+	page_flags_clear(&page->flags.f, ZONES_MASK << ZONES_PGSHIFT);
+	page_flags_set(&page->flags.f, (zone & ZONES_MASK) << ZONES_PGSHIFT);
 }
 
 static inline void set_page_node(struct page *page, unsigned long node)
 {
-	page->flags.f &= ~(NODES_MASK << NODES_PGSHIFT);
-	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
+	page_flags_clear(&page->flags.f, NODES_MASK << NODES_PGSHIFT);
+	page_flags_set(&page->flags.f, (node & NODES_MASK) << NODES_PGSHIFT);
 }
 
 static inline void set_page_links(struct page *page, enum zone_type zone,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..100226f59490 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3624,8 +3624,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
 		 */
-		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		new_folio->flags.f |= (folio->flags.f &
+		page_flags_clear(&new_folio->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
+		page_flags_set(&new_folio->flags.f, folio->flags.f &
 				((1L << PG_referenced) |
 				 (1L << PG_swapbacked) |
 				 (1L << PG_swapcache) |
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..194ca2f04a87 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -494,7 +494,7 @@ void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
 		 * blindly clear bits which could have set my order field here,
 		 * including page head.
 		 */
-		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+		page_flags_clear(&new_page->flags.f, 0xffUL);	/* Clear possible order, page head */
 
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..a3447124a725 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1359,7 +1359,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		int i;
 
 		if (compound) {
-			page[1].flags.f &= ~PAGE_FLAGS_SECOND;
+			page_flags_clear(&page[1].flags.f, PAGE_FLAGS_SECOND);
 #ifdef NR_PAGES_IN_LARGE_FOLIO
 			folio->_nr_pages = 0;
 #endif
@@ -1373,7 +1373,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			page_flags_clear(&(page + i)->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
 		}
 	}
 	if (folio_test_anon(folio)) {
@@ -1392,7 +1392,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	}
 
 	page_cpupid_reset_last(page);
-	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page_flags_clear(&page->flags.f, PAGE_FLAGS_CHECK_AT_PREP);
 	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..a55199f642d3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -617,7 +617,7 @@ static inline void slab_set_pfmemalloc(struct slab *slab)
 
 static inline void __slab_clear_pfmemalloc(struct slab *slab)
 {
-	__clear_bit(SL_pfmemalloc, &slab->flags.f);
+	__pf_clear_bit(SL_pfmemalloc, &slab->flags.f);
 }
 
 /*


