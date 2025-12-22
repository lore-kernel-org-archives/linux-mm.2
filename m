Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92906D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035A26B0088; Sun, 21 Dec 2025 22:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F264F6B0089; Sun, 21 Dec 2025 22:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E326E6B008A; Sun, 21 Dec 2025 22:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF75E6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:42:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77D668B91D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:42:12 +0000 (UTC)
X-FDA: 84245708904.27.8566207
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71037A000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:42:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eauXRlRI;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766374930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCa5J6nrIt8TzRBn2bC3Wx/bNx4m7hYE101pdrt0GvI=;
	b=Q5AIQtHqFIJY8D6gbdQ/aUIYUgqnPO/Aax9S/ulRxlVX3qHejs2hisCfbZ2SDRqiObbvtD
	AgAp5rsz40tVgjsiYClG91AtruROK6P+vWU13obfHzE/py4Mos5ofd7czi39oHpxMs8/4W
	6q6uLyhohzXGPh5xxTOJ1W4lzkqf8AY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766374930; a=rsa-sha256;
	cv=none;
	b=4aEw+LepX5bmt9eKaEYmnJSoj33CRWtduEG+FSBluQFqDeW+wE1q9Q6AobrSLATZKTgkUT
	KlymjSuWdvT3GhiaLt8Zxz+Tpor/qJIJytV7RrcpuqsDwtlQf9FtB445WpTXLNTaptZZNM
	MRTSfL/eVETN/ls4jwcPZT67l9Z5C9c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eauXRlRI;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766374929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCa5J6nrIt8TzRBn2bC3Wx/bNx4m7hYE101pdrt0GvI=;
	b=eauXRlRIXcLkb2DhzLjnmZBJViSpwXq5SSSRLFce/sbifgnGqqv8xJtDTkIm14viKoz7MC
	/CGfvDZ/ipGrhihQZSBZWNvCBX18ely/RjzMMfcxK293QCffQTNHiAi0Q4gTkBZWpK8E8E
	KZYFSznD8y5zAS4XsBrHwauvsDJ8dEA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-ChcZXYkiN7O8limJST5bAQ-1; Sun,
 21 Dec 2025 22:42:06 -0500
X-MC-Unique: ChcZXYkiN7O8limJST5bAQ-1
X-Mimecast-MFC-AGG-ID: ChcZXYkiN7O8limJST5bAQ_1766374924
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2152195608D;
	Mon, 22 Dec 2025 03:42:02 +0000 (UTC)
Received: from localhost (unknown [10.72.112.76])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FD561800664;
	Mon, 22 Dec 2025 03:41:58 +0000 (UTC)
Date: Mon, 22 Dec 2025 11:41:55 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 15/19] mm, swap: add folio to swap cache directly on
 allocation
Message-ID: <aUi+A1xjbcUh54wi@MiWiFi-R3L-srv>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-15-8862a265a033@tencent.com>
 <aUYiLiGJPt/kAy3I@MiWiFi-R3L-srv>
 <CAMgjq7DG-LghGSs_jANXbFqqRFEt_BeCv5gJV7wcTzVEy+N5yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DG-LghGSs_jANXbFqqRFEt_BeCv5gJV7wcTzVEy+N5yQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: gwkpwt5ci1krxhtf9hfwzuzif34pxoid
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71037A000C
X-Rspam-User: 
X-HE-Tag: 1766374930-300789
X-HE-Meta: U2FsdGVkX18Z/oC0onnEfvDtLEN4F40sx63Nux37skNtBlUmHBtEp4Ms6VjU5VvQbD+H7vxVaHU25L7WR5u0NlldDKWMivrVk7vCDbPQTv1QrpL7HRB/w5gBP09Flxopti+Xecr4AjnwfGabZ1l76XGlhwztIiCCKnJJlHuFYjxiRD7hsdotd8JFuD8T+mC9tNUCGB7TqS2qcPF2FMrwm0rbgRp+4Dpm44NEoR9UpmqJuqz+/hyMSgIXwSjqxCpf5154bbGPqbwJcFLpmsjxmDb6g74piksXcnm4AmFpej+oBDALdT9W/T76/tPfzlaP8V1DQ1MX+/EGmZVXJ+m2WB27ZiRBu6YqDK+minvbrGlSu+0o9fU1xBgSIgq0Fx5Abr3D2oscfONV+jJF5rEXgZhqjcbELVujbAL5znkQC3vb7ufs/uwbpB8fVLjQ46bvHKTXyX0F7Kg6H7rLgvRZUUwMZxMceAnUpqracOzgTLY8idYhKsVObCmTWu5dbIPWnv4vFJwPmegeVnpM6eIasQZ8sAnCC6PBXvdWJLhzScQTDzIwv/vNLpi3UTZRCLvHxnlUGyzPIC49KKqQ/gKTIE4EUieCpkOhBpwKw/FTPl/Hxm08F6N0Y6QvGQnLXYJOB6KT5bzPWYAuI5SG0EA4ss2X6t4o55c8DriH0HYmy1Q0zUJd4EeI1gd2DJb8OYMvWZ56oOc6eG9V4hm890IJApF+RsoHkM8s6ACY4EFLecdJQBKN+oubSdyFkwLukv6nVXdhdhjldkIpf8tJJQnpsSeoEzzYKdf5Q/WBMYa6EWk0x+kDhmWRCTh/zFPrnk3BJk6/HPTOWDMZ9F6g7OYQdXqfDTZbd+qkR9/GodT9DdJ4I26McdhiYJdTr0eU1vhAiZjBbQ9VUSRDM074sfnk9is0qKsY1rfhaorrTz7PhAwOK+3u0elil1xKSuDhZU+RRgXQqCrTHq2+X7gWx70
 9z4Tf/p8
 /9chTYELysYpXgLDDkXWZFetiQalRQQT7TnVc28I5kmAtoCYH5RarEp9Yifgl3xXKr2XFdbglsG4fXI7gZgk/NSMPHpqeR0oTyX8ACXUjf04xYnyAdLAig0by4hBU2IB5qMeS8XYmJUjavSPRO8LUeJ0zoIU5eMy+5HsfMv8jp/NGUVNQcOjMvY11rUs/YZ7+LpqHfJkF3mi3kVSvKdsr5zMemiLyY0pA4SJlCr9bbUKB0FQMDLIj6E59mg5RMNDiNyaStUC8SgpDO/pmVk1FZmPMfKXhUJfAWYuWmAGXxiiNvahdj/6SaLydPcgygVVvGPXRz9QaKNgVgYabMVuFfDouLX70cudkKqr6o+BYUz0kgfotctcd4qgKUmL76XCFI23/wVBCcm+RDygLQlwBvBy/+TX/GQe3VpKyspEoEQJ2ziosM+OS6xrcm2Vr+ab08yJMY1X6oHgzF6GvmU1FixcRxFWouTVUiwBR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 at 10:42am, Kairui Song wrote:
> On Sat, Dec 20, 2025 at 12:12 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 12/20/25 at 03:43am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
...snip...
> > > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > > index 327c051d7cd0..29fa8d313a79 100644
> > > --- a/mm/swap_state.c
> > > +++ b/mm/swap_state.c
> > > @@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> > >       return NULL;
> > >  }
> > >
> > > +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> > > +                         struct folio *folio, swp_entry_t entry)
> > > +{
> > > +     unsigned long new_tb;
> > > +     unsigned int ci_start, ci_off, ci_end;
> > > +     unsigned long nr_pages = folio_nr_pages(folio);
> > > +
> > > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > > +     VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> > > +     VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> > > +
> > > +     new_tb = folio_to_swp_tb(folio);
> > > +     ci_start = swp_cluster_offset(entry);
> > > +     ci_off = ci_start;
> > > +     ci_end = ci_start + nr_pages;
> > > +     do {
> > > +             VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
> > > +             __swap_table_set(ci, ci_off, new_tb);
> > > +     } while (++ci_off < ci_end);
> > > +
> > > +     folio_ref_add(folio, nr_pages);
> > > +     folio_set_swapcache(folio);
> > > +     folio->swap = entry;
> > > +
> > > +     node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> > > +     lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> > > +}
> > > +
> > >  /**
> > >   * swap_cache_add_folio - Add a folio into the swap cache.
> >
> > With my understanding, __swap_cache_add_folio() is the pure
> > functionality of adding a folio into swap cache. While
> 
> Hi Baoquan, thanks for the review and suggestion!
> 
> > swap_cache_add_folio() is specifically adding a folio into swap cache
> > during swap in path. Not sure if we can rename them to reflect this
> > clearer. At least from the functiona name and below kernel doc we can't
> > feel that. Maybe:
> > __swap_cache_add_folio() -> swap_cache_add_folio()
> 
> The `__` prefix should stay, I think. This function requires the
> caller to lock the swap cluster.
> 
> > swap_cache_add_folio() -> swap_cache_add_swapin_folio()
> 
> Indeed, my plan is that `swap_cache_add_folio` will be gone soon, we
> should always call `swap_cache_alloc_folio` instead to do the swap
> folio allocation in a unified way, and just remove this.
> 
> Currently we can't do that because shmem and anon have different
> routines for swapin folio allocation. Having a unified
> `swap_cache_alloc_folio` will provide better swapin fallout control
> and cleaner cgroup charging to avoid thrashing, etc.
> 
> Also this helper is currently inexplicitly used by zswap writeback
> too, so adding the swapin keyword seems not accurate.

OK, sounds good to me. Thanks for detailed explanation.


