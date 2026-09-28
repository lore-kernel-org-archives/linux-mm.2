Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61913CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617656B0092; Mon, 28 Sep 2026 07:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0246B0093; Mon, 28 Sep 2026 07:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2756B009D; Mon, 28 Sep 2026 07:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27B6E6B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:09:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F0C7140155
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:09:20 +0000 (UTC)
X-FDA: 85262899680.22.5752ECD
Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	by imf14.hostedemail.com (Postfix) with ESMTP id B262E100005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:09:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHi350v1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.98 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhEmqCbusXo+nqRRJWT3aL6p0OXcgNvckJxMKD5ctqM=;
	b=QKfI4mj9AErQXIX6D7qJhjNoZ/0X+qiBLXxkrnB/0+opmqApWyVUSnTkoLBxwUbJKrfB0O
	vEi0unG/pI5jh43CBlbjbQE54ejL7HrnNVQx8rCcAIoNSZVaClgeSpW1vnA8zgiSrh9YUA
	BZOXXOao4klgiCCFZKfNda/2Eis9OIc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHi350v1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.98 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593758;
	b=cFTMtJqA9YaLOXKCwl5W22zcn0J47ESwh5eJOL1fzWY0Jgp6ZhGlVNhWyD3quR+ap+NPT9
	3K3uyyyvPsg6ymGergvehkFm7POj0nL1WfB7ztdr5u0Vb46oAJ9AEFKl4xgykPZ7ynQiGX
	B2eTOBXAygwyzYIrxabX09c3Swy/Ut8=
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae7b7fe22so4874526a12.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790593757; x=1791198557; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AhEmqCbusXo+nqRRJWT3aL6p0OXcgNvckJxMKD5ctqM=;
        b=PHi350v1XtCuvnMMh0KdmxnojBM+9b27dp4IgXC6BfyTh/W+6d2J8kfxbItU21iW6z
         8YgavsH+KovyE/0saL8rxTmiSytTB61mEZK0Dte6eUf49e6ztqQw1cagYr+jG7zNUcjD
         LnGYboTKpWtSQpcNiUW8B692bKjkoF/mtoCk3XiYW6BbtE+l+Zf2EiYIs81VAciby4xt
         6V0Pca/NJUbFu7+beFuxHXIZWhTcZynQnRMMbyqQwRZv8kIMOmtj5q7Bq2FCl19Lu7i1
         RjsWBem9TagbtUVgL1sv/32JHuNBMCvV0pYvydl0m8pvtsJsajkFQDjsiXprOGraGtgM
         LCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790593757; x=1791198557;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AhEmqCbusXo+nqRRJWT3aL6p0OXcgNvckJxMKD5ctqM=;
        b=sovMlYG45yYicRIIlH8+ZE6H2g/DNIYh/PcV1V2luX1qaAYxRfC52GCPmaDYTlwgs5
         QckEKcVo2cCu0peJLdgfYm2HqAgUQQ87K2RlPT9WccbHP1RreNHBUJG3CTymdhYhkqgk
         dECvNeohj+0b8RRjyxHaFNaMhDryx+hYBIAG1P3yazLXS58uheENcApfs7luFdIDlPo4
         5ljD2Iz9qXD2bWfBVxT1BKJ55tyNW+ezj74ovHQbw//Hy0vvqEjZhWPuEecVVSOGOliH
         VtT61mjUJm2NbN6BcBx0SF6zjpIvt6V9NdVnCm/g4qWGKNgr7HI3TthqWwoKj/rLl31o
         LSsg==
X-Forwarded-Encrypted: i=1; AKwUvByYxfSDhT8wfTw5/oxJc61pCH0pvV6khXNEF9f12hKmpxqQXo4Ds3gaKIPg3WtZODtvST0Bf4mkPw==@kvack.org
X-Gm-Message-State: AFq9FYLBNaBMY4nBtt0gHQWgQtXYEw/QmcclRn81J9SqZ1FiXzXSPtjs
	cT0ylfpa1LzDmfUmYbHvY2qqWOEhCCS/KgnlHMgFv3PJo396YW+bRt8X
X-Gm-Gg: AYBFou34auxi3IGisP4eIDd++RS7tWM0e6ul8/m7lp8wWHt3Yb84s3pjv4G3LMG+pSd
	z+4n875N7dh4kPjkbkjsBQyCo1LDILbsQtK06vO6WO6y5l2eXTeAUIejaWYObVw9+x2duk866Tz
	T1msYSXCBTXxPqgnYS6Zda0LHkALGAwd2ixw9Rpp7HrNmbCGBb9g0z5qg32iEtnon1O/22GVKoj
	Un+VM/ZZH7l2h5lUExgSqXR5YbHBp3A1DBV2YyikeyvGYaRQodOrgChp7qJFui3Z8qX79NoD4ZK
	gSWMX+7AfQPKqXFX8h0jkVmi+AVIOcRXCBkA69OW9wZwCJ8hg5NVsbyzC08mQz7MHxZagMhqslr
	xx7mandqGnW+BGxGcNRXy0LvqIb2euILoVxuRsV+udB9NJKoUpY5txA4eqHjecM9hCvybLLtKEg
	nfrgcw4AiByCJxa9eEQneN0arD4HMRb9vv2OKI
X-Received: by 2002:a17:907:a2cd:b0:c2d:ca32:2160 with SMTP id a640c23a62f3a-c2dca323569mr320592466b.47.1790593756863;
        Mon, 28 Sep 2026 04:09:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7356d1csm458142866b.18.2026.09.28.04.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:09:15 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 13:09:13 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Message-ID: <arpK2bQrrUMvEvTP@milan>
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-3-hao.ge@linux.dev>
 <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
 <60642a7f-2949-428a-8290-40d69c989a77@linux.dev>
 <CAJuCfpG3d7n=z5WnUQYZsqvrt1pemF8TFvGiGyZGLO7ykVvqAQ@mail.gmail.com>
 <CAJuCfpGeRdFY6UPF-vXxwHvP2+tN=BKgRkmLR3PMLuWhxgzPRA@mail.gmail.com>
 <1dff448c-9cbe-4276-bca1-d91283b0c7b4@linux.dev>
 <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8005c24-ecac-45c4-840a-fd282f9693b5@linux.dev>
X-Stat-Signature: 1ijfmz5yzsminqcf7oyot7h68ngcp7gw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B262E100005
X-HE-Tag: 1790593758-5379
X-HE-Meta: U2FsdGVkX19kiSinITKF8r4mVbI6ikmSuzj2oL1PSaxuaia55W0LUYKFBMcgZyfvJdgYcKa0Ghl/DMj44wTLdcLJwgrDGQOUIx2LwRDKMm2ktG0UX/K8EwAh8trGjnaUrag5EaGTkkpfvSQXLJPv8mHwi4EGtiPi0RH6dm+Hb6I5mKpM08WK9S6kCPJHbUISKPh3qrTCMTfWbCDF8b2a33SwxCFoE60OVDPTr70QFA9YLqPPe0NDau2E7oaKCnsvhdPevBgo5w06iNUQhszLMl3dmP3f0xn5hAvLoAPptmrK3RfWymH9Ca109GjNygDMSH5PGwsm+kcPyL06eXbyxbHJDFnR73hVHTJaf/+YL2NUHx+IVwxI5KZ3Puw9OvTQM9XjnbnS+Y/dBm8TtEDSUX9aw+mSyjsLijCg3ChIOFTJ5IBH2jrPvMlz41iYj+1qsFzptLo+MaQvTleYuVKhuG5pQmBDUha6633p5CikYN5jCtpC0UnOSK65yV7ujjXevVcZFMtahEsPnozwH16vAJqDiVUwRRh2VWIz0i3xptUCxIj2PsryARjE6CCWsEwo/u3k2UmCNSMYvTD/C+wRPlhCa083trZVzIEbp37xYuziaaYfwpPSttxnMqEhNSSFqJyKf4SXnEtlox/ktPu0JF+XAG9hCJWJQYZiSKjudtUT12/9O2l8HDGdjZ2Fynyyncrvw1kHmbZQ7gFl+jDWzH96dd58hj9A0PcxggVVjYRPdGf2p0TFLIzjT5GLrwthTq0TiEvw3GSuRZpukFHM/GUvvwG0QFq8ZLowgyqUNqygzdLWQb1vDi/fYzU2atyec+Jj92yqHH0UVGiPYFtkPq3ZS9Sm/+dYRlamcevwXPixSkRdyNNJ3Qy2BF3s6JjXnEw4WLFKhVviTLCnB9cRSW/FxrJgDA879P7lR2iNB4wtae123YzUOFFEvIMeoK0pL4CMVyHrEMsG6id8G42
 OvNXbwNY
 OCknM7bau0XWkEgzF0TQnBimq/6uqA4QmC+5z77UdilpQnTmBiH4q1yoKc1muQqVXS8f4x0TtTbBwAH8osuLhbPLF3l2FcigKlI/yXXweT/mbYl5G7myNu+lgfUGnYdlhFqCtxtxf4lOjXA+rNSRbScUYnuKOvfWf07mK8BaS4y2IIDRE35kUuYeuvon0ZFzIw7GxF6EY7+40It84AWqzDi2UV57m66Obq0i9nPjV73L9Z/KZ9jR9hI5n8iYX0idZ8LF/Pm2cyiRuu4F4KaSXCSVGOJxPRSs7/wtuUxJTOCdRv1xOZtv/hOX3+Hb7Md0BQFFAhwSw47Dym/kL0K++i3bwIyvLRrIpyyY891xTx9C2J4F92vNGrxqmbrBduzuchdZ+Mmop7MgrvG1sEcubs/F7BeN/Th3AHtnDi1GjlM4Whx2hBDjDQ3kkCvV74+SY5PHCwdcAXhra1x1Yq3Oljs034rqU6FYD6mlg2NyacbNXrhbfi3WaJYO00kCY/CuGXDRXqGtyDKOZTlOTwkEhJFmyD0OPYJrGRfDwAktMjo6IPF8bd2N79Neze0OrSGo/gQQfzDAcJ31Y4TaffRD7tKzMmy0wK98/OY0YlyWRtv3HUs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 10:32:48AM +0800, Hao Ge wrote:
> Hi Suren、David、Lorenzo
> 
> On 2026/9/17 09:12, Hao Ge wrote:
> > Hi Suren
> > 
> > On 2026/9/17 03:07, Suren Baghdasaryan wrote:
> >> On Wed, Sep 16, 2026 at 9:31 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >>>
> >>> On Tue, Sep 15, 2026 at 11:00 PM Hao Ge <hao.ge@linux.dev> wrote:
> >>>>
> >>>> Hi Suren
> >>>>
> >>>> Thanks for you review.
> >>>>
> >>>> On 2026/9/16 05:09, Suren Baghdasaryan wrote:
> >>>>> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
> >>>>>>
> >>>>>> The reservation is already stored in the maple tree when
> >>>>>> vm_module_tags_populate() fails. A failed load never unloads the
> >>>>>> module, so nothing releases the entry. Release it and roll
> >>>>>> module_tags.size back. Without the rollback a concurrent load that
> >>>>>> already passed needs_section_mem() can reuse the freed gap, skip
> >>>>>> vm_module_tags_populate() and write to unmapped memory.
> >>>>>>
> >>>>>> vmap_pages_range() may have installed some PTEs before failing. A
> >>>>>> retry to populate the same range would BUG on them, so undo them,
> >>>>>> but only if vmap actually ran.
> >>>>>>
> >>>>>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> >>>>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> >>>>>
> >>>>> If a patch fixes two other patches, it likely needs to be split so
> >>>>> that each part fixes one patch only. But read on please. I'm not sure
> >>>>> if one of the fixes is correct.
> >>>>>
> >>>>
> >>>> Kept them in one patch because they only make sense together.
> >>>>
> >>>> After a failed populate the reservation is released and the
> >>>> size rolled back, so the next load takes the same gap and calls
> >>>> vm_module_tags_populate() again, and that retry would trip over
> >>>> the PTEs the failed vmap left behind.
> >>>>
> >>>> Without the rollback a load that already passed needs_section_mem()
> >>>> just reuses the gap, skips populate and writes to unmapped memory.
> >>>> So splitting them leaves each half broken.
> >>>
> >>> Yeah, that's why I think vmap_pages_range() cleanup should be a
> >>> completely separate patch with vmap_pages_range() doing cleanup
> >>> itself.
> >>>
> > 
> > I think I get where you're coming from now.
> > Thanks for taking the time to explain.
> > 
> >>>>
> >>>>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>>>>> ---
> >>>>>>  mm/alloc_tag.c | 10 ++++++++++
> >>>>>>  1 file changed, 10 insertions(+)
> >>>>>>
> >>>>>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> >>>>>> index 2070e682fe10..95ddf5b743d0 100644
> >>>>>> --- a/mm/alloc_tag.c
> >>>>>> +++ b/mm/alloc_tag.c
> >>>>>> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
> >>>>>>                                      next_page, PAGE_SHIFT) < 0) {
> >>>>>>                         release_pages_arg arg = { .pages = next_page };
> >>>>>>
> >>>>>> +                       /*
> >>>>>> +                        * vmap_pages_range() only runs once all pages were
> >>>>>> +                        * allocated, and it may have installed some mappings
> >>>>>> +                        * before failing. Undo them.
> >>>>>
> >>>>> If vmap_pages_range() failed to map the range, why should we need to
> >>>>> undo it? If it indeed leaves some partial mapping when failing then I
> >>>>> would argue that vmap_pages_range() should be undoing these partial
> >>>>> mappings itself before returning the error.
> >>>>>
> >>>> Yeah it does - none of the paths under vmap_pages_range() undo themselves on error.
> >>>
> >>> Hmm. I wonder if this behavior is intentional or requires a fix. The
> >>> only possible reason I can think of is performance but I can't imagine
> >>> a failure to map is a performance-critical case.
> >>>
> >>> +David Hildenbrand (Red Hat), +Lorenzo Stoakes (Oracle) what do you
> >>
> >> Huh, my gmail thinks you are still at your previous companies :)
> >>
> > 
> > I manually fixed it on the mailing list for this thread.
> > 
> >>> guys think? Shouldn't vmap_pages_range() undo its possible partial
> >>> mapping when it fails?
> >>>
> >>>
> >>>> pcpu_map_pages does perform cleanup on its own as well. There may be other similar sites.
> >>>> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/percpu-vm.c#L255
> >>>> so I did the same here.
> >>>>
> >>>> If we really want vmap_pages_range() to handle this cleanup internally, I believe that would
> >>>> be a relatively large change, and we would need to consider many more cases. So I think we keep
> >>>> the current behaviour for now.
> >>>
> >>> Yeah, I understand it would require a deeper cut but if that's the
> >>> right way to handle this we might as well do that. Let's see what MM
> >>> folks think.
> >>>
> > 
> > Sounds good to me. Let's wait and hear what the MM folks say.
> > 
> 
> I just looked into the call sites for __vmap_pages_range.
> And I found there's a bug in one vmalloc caller [1].
> When gfp_mask has __GFP_NOFAIL, the code keeps retrying
> __vmap_pages_range. If there are leftover PTE mappings,
> this can trigger a BUG(); [2]
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L3946 [1]
> https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/vmalloc.c#L121  [2]
> 
Indeed the below code is incomplete:

<snip>
	/*
	 * page tables allocations ignore external gfp mask, enforce it
	 * by the scope API
	 */
	flags = memalloc_apply_gfp_scope(gfp_mask);
	do {
		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
				page_shift, nested_gfp);
		if (nofail && (ret < 0))
			schedule_timeout_uninterruptible(1);
	} while (nofail && (ret < 0));
	memalloc_restore_scope(flags);
<snip>

and it should be fixed. As the __vmap_pages_range() can actually fail
and leave some installed mappings, we have to perform some cleanups
on failure or on repeat(if nofail is true).

Below code:

+			/*
+			 * vmap_pages_range() only runs once all pages were
+			 * allocated, and it may have installed some mappings
+			 * before failing. Undo them.
+			 */
+			if (nr == more_pages)
+				vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));

we can use but we need to check if partially mapped space is not an
issue for the vunmap_range(). And it looks like it is not.

<snip>
@@ -3953,8 +3990,15 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
        do {
                ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
                                page_shift, nested_gfp);
-               if (nofail && (ret < 0))
-                       schedule_timeout_uninterruptible(1);
+               if (ret < 0) {
+                       /*
+                        * __vmap_pages_range() may have installed some mappings
+                        * before failing. Undo them before returning or retrying.
+                        */
+                       vunmap_range(addr, addr + size);
+                       if (nofail)
+                               schedule_timeout_uninterruptible(1);
+               }
        } while (nofail && (ret < 0));
        memalloc_restore_scope(flags);
<snip>

--
Uladzislau Rezki

