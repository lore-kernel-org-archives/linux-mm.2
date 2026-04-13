Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA8DF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BDF6B00B4; Mon, 13 Apr 2026 16:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74066B00B5; Mon, 13 Apr 2026 16:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962BE6B00B6; Mon, 13 Apr 2026 16:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD176B00B4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:35:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EC4B1401F7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:35:28 +0000 (UTC)
X-FDA: 84654687936.20.A232DD6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3582180010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:35:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GZMRD2xW;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GZMRD2xW;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112526; a=rsa-sha256;
	cv=none;
	b=CnyaXM5ZjsaKevvpsvXu8A0buLCJ1bjjNKkKpIym3idueTStoN8l1j//Xwal2Nuqd3G77U
	Wq3PUakOmXghZVLczDye97nbLFbJWnfJXbnibY0rqGLQq89FBSCeoyJWPjBI+IdLLwvlhI
	jjDHgkAk8ndwtXCJCl2AmA6Q2ZwScr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GStuJI1A/J008doSpFXCtvMZRtsnt6jcoaLjFghqr5o=;
	b=4QaO/1w31aIMNKcg8SdvgvPf3MKsS3PdWXhAVf4U6jo+uT7P3cpWQ7kWLQc3cTFQaJKxVE
	+aM11oLIPYTVE6rT6DWV9yuD/CCIA+lRaO+vdFwbReLaLm2EDCDerY+WSY7jzsQjuuDuvx
	fjzbY/M9PvKQjERetXsIzuSo+qwS3+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776112525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GStuJI1A/J008doSpFXCtvMZRtsnt6jcoaLjFghqr5o=;
	b=GZMRD2xW6t5Y/JUXzT9j7hifFqbtB8V3kUj1M/71qvBJBqwTKpOCizb2XK/J8/Z/bXraRL
	pgDWnVrrmReJy5SrNGOlZ+VQvwfSpjbOdav4UVSj0CexRt1+PbovOSHmBsAUKcMSBaI3WX
	5crMs3xOLLXfpuzXH9+BmmuXAoYQiFc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-QUuIEaTXN_qQv8hYyv7h_Q-1; Mon, 13 Apr 2026 16:35:23 -0400
X-MC-Unique: QUuIEaTXN_qQv8hYyv7h_Q-1
X-Mimecast-MFC-AGG-ID: QUuIEaTXN_qQv8hYyv7h_Q_1776112523
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so39771635e9.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112523; x=1776717323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GStuJI1A/J008doSpFXCtvMZRtsnt6jcoaLjFghqr5o=;
        b=qgwanj1g51mnKnsMHkmapo1XicM9mvK8XYVjW3Ez9HclRmzHbBI7RTDEwKwcocbP1h
         KNQyEgzVQB0Tvv4Pw7NNUgiG7/BhArpXLtTfzRfAhaaeLbJQIglcnK5+vukplP5mEvNx
         578PDJon0pMH1ll81O/YHVSDrjYlhLoshxxiugu9ILBhBoLavw17k3iusSAHnLK/LHG0
         AcdvqQziqa9Rz/vV8i+O2lqRZxIwVHLan6LvFR3q8wB1D9wCgpbJR0YDhFEVjp8tQstj
         QPKQj3YHKDPnduvxvke4rnM6Je5GmhfxY0Z10cBAK/75RhC4MCgRg3iqJpq+Iloph2HP
         aYxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BS6Qpd65LV+zNNsLfZjTG3Phm1kmOktU5J2FeBOQbLfEXWki3TozgDlKIzmeMFblkRF57P1ckWg==@kvack.org
X-Gm-Message-State: AOJu0YxRC/YuCdzAL6UV1mdfKLR6n/IicfhXc+M+uHNO942bNWoUuSd+
	Kt5Q+XHoI/D7Mk+H8h7uX4cTbbcM5/1CTXuDHCNrk/usdrOPIItBtNnqyLGw+N2/lIH/4IvNggK
	ULW+MBpD6fjB+dgVyriCPhizMzhWTQM5OSyRtemzbbjfDYh4JFJ3x
X-Gm-Gg: AeBDievltiqZs5NFFL670QD6NtGPNJ5uoK/DpZgWna7vcIl4BxvOvZiSBo/BxsjEbsR
	cCB4BC1oGS3F+ZEb1SuFPFJBNhB8VPEV2nfHmqU/rXKeoJwwJ032XdjSIOwoiuN14U6/xbOVdAI
	Kkh7ODRlLTqlQPIyxUTl5zaguz4xcqku4tD9ADX1bHLyyK20NrvsW8BVW7HqtP2FPOjZnLl7Q8J
	NuFlZYoL1ph/7Dyznqlbdh72dKuZz2wEw8MKDekBJOK3MaTuTpK9XDgfEKwRTUE17/3XNk4uMm1
	lpL3uOykEAhKKmO/OeVUmEZU7ZluoGvfa5c4ojhXggMrjsFm3r+DCx66YozPAHlHSN16rErbIEI
	2pqNpGiofPyJGqENSVXW4CDJhqfvj1+1IiaozPcribQU=
X-Received: by 2002:a05:600c:628b:b0:487:1fbf:e0bb with SMTP id 5b1f17b1804b1-488d680851fmr196276445e9.6.1776112522413;
        Mon, 13 Apr 2026 13:35:22 -0700 (PDT)
X-Received: by 2002:a05:600c:628b:b0:487:1fbf:e0bb with SMTP id 5b1f17b1804b1-488d680851fmr196276055e9.6.1776112521752;
        Mon, 13 Apr 2026 13:35:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d688da2csm108300015e9.34.2026.04.13.13.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 13:35:21 -0700 (PDT)
Date: Mon, 13 Apr 2026 16:35:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260413163233-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
MIME-Version: 1.0
In-Reply-To: <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vbH3O0Dg4yffYXIG6L69JKpp80z023weWjT6eNyp_iI_1776112523
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3582180010
X-Stat-Signature: b1cwszi9ta3ujujm81uxt4mafizq7i97
X-Rspam-User: 
X-HE-Tag: 1776112525-99418
X-HE-Meta: U2FsdGVkX18V7oMJKqAb2Gz6JNEGV8FLIaRZih6QLkwWgc6IC2ZhuPiaMY8+EtX26vzdmHiVJihdPjIevhtiU1CqaCe+4bkALGexr5VQHAcTVaq6fsafDqA+IWNrAsrRjUucdhx2OjlA7J5no4Cq6QrUUaxkGhoV6N2BeKLj84h3wmkisV4GvJLe7OKdTQtEBZITnO3ZmQZ511kwqQhhj1BYQFTr2qJIcC0f3pDV/OD3UhyiKtM/ahs/0+824sYVVGQCXflrx7h/ICfZknGm2K9+WKORRQg6szh+MOPxXtq3sW84IDHKGzR8vPtexwEtLVabqc8GG3uyD5t6Fx/ewMm5/4Q3uo8dFDOqUpwgKFg2tf0PtUrQxachEadZmIOZxV5SdASwrJxaw0NARwSt/NAdOEWySpqHDLTCSP63tb4dfYcXsZxo879LuQg+aMu49jgj3K3ahlNgsJWRxWgIWUZ5bN7l5u7/Zzo/JFx/yQITvMjm2YL2bVEPRGQc0uMpvsMWEkD6/IWxqh81ugioDy5P0rNnw0ghM619/6xAr70f3OiwE1XE3t18eCfDCU7U3Gs32vbXGsoEQXGudmaNIGQHjvypuWGY0CmWo3IIrpQza+oAgCyv4zr2M07h2jzxH/Wa0a5nQE09Lz3fJBhV07AB9xWqpW2jj+a7Iuc0AjA4FbZvPFNg1GSIRryZr4a3YY8e7st9JySlfL7d6awZZcMf0lm0l8bhfacZpEmiKUtGUKfjXqu4I+qnBVYpmz3IrCnEUywjusZbNYnD+jywwzrKfMpt2Er7oj8jZsZ7kBwoqrZRICGWOUOgXsJDnv4ayBex9S5AC3RX+V6eTCkYJlCtIRbf3dowO4hwwUS4ZAM2SjP66u+7H0cEodFT2hFsJrVLIDneOMVk5GTUYYtUPz3gGHKDiHMsLwlCiCzo84fIN8PC7lCVjbbBxGGvxgtdGeWbVyYIMju28unh4CC
 KtYTczfY
 KBuE0eTLWF7/aOBT9dRoycrYZAqBhMQ0qFjvJw/vwYu4CqMHsezRMcZF4seYyKBIMdkRJLEtyxcKKFe5cjlNQmvRPyIWodFqKTKDwH1Li7Tv7j96cjilIMd1MwGVGMCZahWqPYWyLau89yTmZuXPxWylKz1G2Xx7cKK7B6IcjH5mCNt4u1hehvqr4fn6HPI7jJ82QJ0zxrsEMm/hyMra6xqVe3AvjjZiyQKML3RFfoQa3MJEHrAM4QvVtR8Oi5rjp5c6J8/c/j2iMaOEErHc2k/WuH7A8cA4ojefiJYANYqqpAjOc6cew5BPTYysc1Q3VTBaYwdZDNYjDmoOVRyFmkCxpvlgW6rRq/tr+50HEmALgiptpz30Ez8V7eIWNvXP+HfVDsyK+Rt+EeefD/LHkduRzGNWjnu7aiYb4Q0AK4v39sMHAgdzHtN6XvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> > When a guest reports free pages to the hypervisor via the page reporting
> > framework (used by virtio-balloon and hv_balloon), the host typically
> > zeros those pages when reclaiming their backing memory.  However, when
> > those pages are later allocated in the guest, post_alloc_hook()
> > unconditionally zeros them again if __GFP_ZERO is set.  This
> > double-zeroing is wasteful, especially for large pages.
> > 
> > Avoid redundant zeroing by propagating the "host already zeroed this"
> > information through the allocation path:
> > 
> > 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
> >    drivers to declare that their host zeros reported pages on reclaim.
> >    A static key (page_reporting_host_zeroes) gates the fast path.
> > 
> > 2. In page_del_and_expand(), when the page was reported and the
> >    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
> >    in page->private.
> > 
> > 3. In post_alloc_hook(), check page->private for the sentinel.  If
> >    present and zeroing was requested (but not tag zeroing), skip
> >    kernel_init_pages().
> > 
> > In particular, __GFP_ZERO is used by the x86 arch override of
> > vma_alloc_zeroed_movable_folio.
> > 
> > No driver sets host_zeroes_pages yet; a follow-up patch to
> > virtio_balloon is needed to opt in.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  include/linux/mm.h             |  6 ++++++
> >  include/linux/page_reporting.h |  3 +++
> >  mm/page_alloc.c                | 21 +++++++++++++++++++++
> >  mm/page_reporting.c            |  9 +++++++++
> >  mm/page_reporting.h            |  2 ++
> >  5 files changed, 41 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 5be3d8a8f806..59fc77c4c90e 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
> >  				   &init_on_alloc);
> >  }
> >  
> > +/*
> > + * Sentinel stored in page->private to indicate the page was pre-zeroed
> > + * by the hypervisor (via free page reporting).
> > + */
> > +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
> 
> Why are we not using another page flag that is yet unused for buddy pages?
> 
> Using page->private for that, and exposing it to buddy users with the
> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
> particularly elegant.


So here's an only alternative I see: a page flag for when page is in
buddy and a new "prezero" bool that we have to propagate everywhere
else. This is a patch on top. More elegant? Please tell me if you prefer that.
If yes I will squash it into the appropriate patches.



diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 903f87c7fec9..b9c5bdbb0e7b 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -294,7 +294,7 @@ enum {
 #define __GFP_SKIP_ZERO ((__force gfp_t)___GFP_SKIP_ZERO)
 #define __GFP_SKIP_KASAN ((__force gfp_t)___GFP_SKIP_KASAN)
 
-/* Caller handles pre-zeroed pages; preserve MAGIC_PAGE_ZEROED in private */
+/* Caller handles pre-zeroed pages; preserve PagePrezeroed */
 #define __GFP_PREZEROED ((__force gfp_t)___GFP_PREZEROED)
 
 /* Disable lockdep for GFP context tracking */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index caa1de31bbca..3e46233d5758 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4814,11 +4814,21 @@ static inline bool user_alloc_needs_zeroing(void)
 				   &init_on_alloc);
 }
 
-/*
- * Sentinel stored in page->private to indicate the page was pre-zeroed
- * by the hypervisor (via free page reporting).
+/**
+ * __page_test_clear_prezeroed - test and clear the pre-zeroed marker.
+ * @page: the page to test.
+ *
+ * Returns true if the page was pre-zeroed by the host, and clears
+ * the marker. Caller must have exclusive access to @page.
  */
-#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
+static inline bool __page_test_clear_prezeroed(struct page *page)
+{
+	if (PagePrezeroed(page)) {
+		__ClearPagePrezeroed(page);
+		return true;
+	}
+	return false;
+}
 
 /**
  * folio_test_clear_prezeroed - test and clear the pre-zeroed marker.
@@ -4829,11 +4839,7 @@ static inline bool user_alloc_needs_zeroing(void)
  */
 static inline bool folio_test_clear_prezeroed(struct folio *folio)
 {
-	if (page_private(&folio->page) == MAGIC_PAGE_ZEROED) {
-		set_page_private(&folio->page, 0);
-		return true;
-	}
-	return false;
+	return __page_test_clear_prezeroed(&folio->page);
 }
 
 int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..342f9baf2206 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,6 +135,8 @@ enum pageflags {
 	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
 	/* Some filesystems */
 	PG_checked = PG_owner_priv_1,
+	/* Page contents are known to be zero */
+	PG_prezeroed = PG_owner_priv_1,
 
 	/*
 	 * Depending on the way an anonymous folio can be mapped into a page
@@ -679,6 +681,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
 FOLIO_FLAG_FALSE(idle)
 #endif
 
+/*
+ * PagePrezeroed() tracks pages known to be zero. The
+ * allocator may preserve this bit for __GFP_PREZEROED callers so they can
+ * skip redundant zeroing after allocation.
+ */
+__PAGEFLAG(Prezeroed, prezeroed, PF_NO_COMPOUND)
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..d3c024c5a88b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE);
+	post_alloc_hook(page, order, __GFP_MOVABLE, false);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1833,7 +1833,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	}
 	dst = (struct folio *)freepage;
 
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..ceb0b604c682 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -887,7 +887,8 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 	set_page_private(p, 0);
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     bool prezeroed);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fba8321c45ed..57dc5195b29b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1528,6 +1528,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			count -= nr_pages;
 			pcp->count -= nr_pages;
 
+			if (PagePrezeroed(page))
+				__ClearPagePrezeroed(page);
 			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
@@ -1783,11 +1785,14 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 
 	/*
 	 * If the page was reported and the host is known to zero reported
-	 * pages, mark it zeroed via page->private so that
-	 * post_alloc_hook() can skip redundant zeroing.
+	 * pages, mark it pre-zeroed so post_alloc_hook() can skip
+	 * redundant zeroing.
 	 */
-	if (was_reported)
-		set_page_private(page, MAGIC_PAGE_ZEROED);
+	if (was_reported) {
+		__SetPagePrezeroed(page);
+	} else {
+		__ClearPagePrezeroed(page);
+	}
 }
 
 static void check_new_page_bad(struct page *page)
@@ -1859,21 +1864,20 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, bool prezeroed)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool prezeroed = page_private(page) == MAGIC_PAGE_ZEROED;
+	bool preserve_prezeroed = prezeroed && (gfp_flags & __GFP_PREZEROED);
 	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
 	int i;
 
 	/*
 	 * If the page is pre-zeroed and the caller opted in via
 	 * __GFP_PREZEROED, preserve the marker so the caller can
-	 * skip its own zeroing.  Otherwise always clear private.
+	 * skip its own zeroing.
 	 */
-	if (!(prezeroed && (gfp_flags & __GFP_PREZEROED)))
-		set_page_private(page, 0);
+	__ClearPagePrezeroed(page);
 
 	/*
 	 * If the page is pre-zeroed, skip memory initialization.
@@ -1923,15 +1927,18 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	if (init)
 		kernel_init_pages(page, 1 << order);
 
+	if (preserve_prezeroed)
+		__SetPagePrezeroed(page);
+
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
 	pgalloc_tag_add(page, current, 1 << order);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags)
+			  unsigned int alloc_flags, bool prezeroed)
 {
-	post_alloc_hook(page, order, gfp_flags);
+	post_alloc_hook(page, order, gfp_flags, prezeroed);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -3276,7 +3283,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *prezeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3311,6 +3318,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*prezeroed = __page_test_clear_prezeroed(page);
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3372,10 +3380,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
-			unsigned int alloc_flags,
+			int migratetype, unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct list_head *list, bool *prezeroed)
 {
 	struct page *page;
 
@@ -3396,6 +3403,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*prezeroed = __page_test_clear_prezeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3404,7 +3412,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *prezeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3423,7 +3432,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, prezeroed);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3448,19 +3458,19 @@ static inline
 struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
-			int migratetype)
+			int migratetype, bool *prezeroed)
 {
 	struct page *page;
 
 	if (likely(pcp_allowed_order(order))) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
+				       migratetype, alloc_flags, prezeroed);
 		if (likely(page))
 			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+			     migratetype, prezeroed);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3851,6 +3861,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool prezeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3995,9 +4006,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+					gfp_mask, alloc_flags, ac->migratetype,
+					&prezeroed);
 		if (page) {
-			prep_new_page(page, order, gfp_mask, alloc_flags);
+			prep_new_page(page, order, gfp_mask, alloc_flags,
+				      prezeroed);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4232,7 +4245,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags);
+		prep_new_page(page, order, gfp_mask, alloc_flags, false);
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5206,6 +5219,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool prezeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5214,7 +5228,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &prezeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5225,7 +5239,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0);
+		prep_new_page(page, 0, gfp, 0, prezeroed);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6948,7 +6962,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, false);
 			if (!order)
 				continue;
 
@@ -7154,7 +7168,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, 0, false);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",


