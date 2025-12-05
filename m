Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4944D2E017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2176B00BC; Fri,  5 Dec 2025 02:21:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A406B00C3; Fri,  5 Dec 2025 02:21:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC776B0125; Fri,  5 Dec 2025 02:21:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37B5E6B00BC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:21:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05ADE1A04F4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:21:03 +0000 (UTC)
X-FDA: 84184570806.09.72E1658
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 05A4620004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:21:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhJ61rdo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764919261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz0Looyy1EKTh6igJJhb5SyOqLVdyy67umD/p6pJLsU=;
	b=ivLfEk6LENqmMSWt8YOcRJeBiRifPx4QUjE41ZrobHe7jP/W52dhPPlbzDHGeR6PTEkmJF
	E2t4zxrwZZgVHQeQyMF1zv4BAjsVCnZjAmPczQOrUij+O1/5CoFypB2NCbJ1Vokw57+6i5
	Ab1YP39IYrprE9gcX3eKxNrL5bCgFYM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhJ61rdo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764919261; a=rsa-sha256;
	cv=none;
	b=A+WGNm7Am71Utwd0iFgCNQEM9MzgeL8hVPF5B1gIsdjxZpoLtg+4X2RkYgpfKr+oLinVoD
	ovoMEuII67/CdKiwu/6zUiSq71wtybp/f1dAx/vDkJ5LLQyalp+IkLAgPqsnvFCCwnyx8E
	YL+6lGfslEZrC3yPfLQv8fJyAV5sc+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764919260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qz0Looyy1EKTh6igJJhb5SyOqLVdyy67umD/p6pJLsU=;
	b=BhJ61rdopjs3/Plj+ay9/gXc8ggc7oGNtgl1YNHMGvSdSjPJFdpk798cYfZzkCamnj7xv/
	WMevvLmXLpBGmKU9Vgdo12Tv88DnZlBZsDOZJ0/2OOKZCf762xT733nHd4we/lUpSWUtVx
	sCirRausGvMnF4laGYDlIwCm1e/mMiE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-SWZoQuqHO1mLKMvsCtHm1A-1; Fri,
 05 Dec 2025 02:20:54 -0500
X-MC-Unique: SWZoQuqHO1mLKMvsCtHm1A-1
X-Mimecast-MFC-AGG-ID: SWZoQuqHO1mLKMvsCtHm1A_1764919252
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBD551956055;
	Fri,  5 Dec 2025 07:20:51 +0000 (UTC)
Received: from localhost (unknown [10.72.112.128])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADBA01953986;
	Fri,  5 Dec 2025 07:20:50 +0000 (UTC)
Date: Fri, 5 Dec 2025 15:20:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 01/12] mm/kasan: add conditional checks in functions
 to return directly if kasan is disabled
Message-ID: <aTKHzmxR3JA2R7qD@fedora>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <20251128033320.1349620-2-bhe@redhat.com>
 <CA+fCnZfDYHUVKX-hdX3SgmuvJEU-U+MuUJGjs-wJJnfRDHz2sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZfDYHUVKX-hdX3SgmuvJEU-U+MuUJGjs-wJJnfRDHz2sw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Queue-Id: 05A4620004
X-Rspamd-Server: rspam11
X-Stat-Signature: kw3d69dggsxmse6x44sxt7epsa1srm5f
X-HE-Tag: 1764919260-273518
X-HE-Meta: U2FsdGVkX19mKiYo0bdP4T2f4D+Cx4Xkgm6B1H4ETobqR6dbuM7aR0UoTFGdRH1I7OEyRWKKzY0OeerzpdrZBQRyT4Xj6rBP3Ai0KBtVmGoVpqtkhK+JwgVGbb6dq0DFgdMRMfFZPxfofGBOOkNqZLXcmamIVyihlaLFx06CbFFMZdnWl3pNFPG4h/J459JjX8ab216W+vxxpgUGKQqCFf79H9anwWK3h6CK6Kt+RonmetlfxPI2INk8xjP56SKtRz5iyhqIjja5UmVV+AFuTJZMxGTtCsW9Q4Fm+W8+5TL6ZSVdK1WMEpLMuML70XtccEu1fndQdh62CLNfPKG/KIL1Jm9CE4bOHVsmCRMoLrXhSttPBORRYbAOgWddlcPEB8hloSqpIYWYx53bQ89d+k+L0wxfDhHqPyEUSlcIBxe/XjGRzabMxXTle86RDCIik6c2Ue+egXmNHw50PLimBZN6ZG/eTkSb1NpsH3qdINUayQc9zEGO9EgbqJwnZiVKTaVXXS7nF3WtYmnn7hg43wfWemxU026s3InmIjZPG5p500BBV2fYQOQCDznKzA5xLpTyCSqtp6J7HoXy5wkue7zvI07uxtHy6Zs7iapysF5CSMef4HfANmyTW1I/0v8XxAkDpp6KAbeu2A2Su50wYzH9ex/NK+YaZpOg9oWz+34IqGHfnPajlACBPKkz1b9KwL3P4w7aufzTPcCNi2hiAGjh19adFko2Zb866xuGNP+1iah0ydL5Rn6Qcz/ta2pAdA+xrXGpxNGc0twsp+BqinZwwgEpExfxdItGefbpF647Le3HfagFOjRVqxryPyurBWoGF0P7mDAuBKiMpZBIqWB2Kw0ju/RRaayUYPeixUD0+e8fOx3Y0+Cfb4huXnxdENnT8FBwNEqJVClmoMhS59CL+WF0+DwgRevl93Fgt7/LB+ZFu9QGbyqD6JaLbDGEfslErD/MHQvHYvhWMUO
 XyQJ2jeV
 Z9LpxbtdcDJGE3+DG30LPLJWggnqMBNG//iqFFIw5dEPfYYbr3HYzcuhXf5imFi3APkoC74Z4mAPe40WPy/Fw1eggO6yub8vPm63deMl/mtG/9sHPwHLrvQY9D+ufX71hRVA6PLhQ4AAXYYIiApJ4qJVigS6GcFvfE1wRBT+e+zM7DJZsMA5s9PwMQKZXrdcD67CicEiFRVGoOkb2o/+xrwkAtpQw2FjarxLFy2bqVN7orUbzQSHjBfO+Qhrhyq+hjo/ttP0UEFPB7pSCAj4B8pKbn6ulDJzxatQCpGnoRXBrmm3RAt3xwlk1Rs+8QMaBsGra+kv86bp+L3F54pvnwV3zHSK9iRJTItyh+MW/1QkikkjX4D9smwE/KR+IV8NgRmL+V/IiaqVOsCj0H4OrEpoPgm0CHnt0ClORiJskuroCDitv3ckgaOB9j9pdnpUtvtXYVGY1a70d9QBayrvsPGrj13NupwGambJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > The current codes only check if kasan is disabled for hw_tags
> > mode. Here add the conditional checks for functional functions of
> > generic mode and sw_tags mode.
> >
> > This is prepared for later adding kernel parameter kasan=on|off for
> > all three kasan modes.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  mm/kasan/generic.c    | 17 +++++++++++++++--
> >  mm/kasan/init.c       |  6 ++++++
> >  mm/kasan/quarantine.c |  3 +++
> >  mm/kasan/report.c     |  4 +++-
> >  mm/kasan/shadow.c     | 11 ++++++++++-
> >  mm/kasan/sw_tags.c    |  3 +++
> >  6 files changed, 40 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> > index 2b8e73f5f6a7..aff822aa2bd6 100644
> > --- a/mm/kasan/generic.c
> > +++ b/mm/kasan/generic.c
> > @@ -214,12 +214,13 @@ bool kasan_byte_accessible(const void *addr)
> >
> >  void kasan_cache_shrink(struct kmem_cache *cache)
> >  {
> > -       kasan_quarantine_remove_cache(cache);
> > +       if (kasan_enabled())
> 
> Please move these checks to include/linux/kasan.h and add __helpers to
> consistent with how it's done for other KASAN annotation calls.
> Otherwise eventually these checks start creeping into lower level
> functions and the logic of checking when and whether KASAN is enabled
> becomes a mess.

Not sure if I got it correctly. Are you suggesting it should be done
like kasan_populate_vmalloc()/__kasan_populate_vmalloc(),
kasan_release_vmalloc()/__kasan_release_vmalloc()?

> 
> 
> 
> > +               kasan_quarantine_remove_cache(cache);
> >  }
> >
> >  void kasan_cache_shutdown(struct kmem_cache *cache)
> >  {
> > -       if (!__kmem_cache_empty(cache))
> > +       if (kasan_enabled() && !__kmem_cache_empty(cache))
> >                 kasan_quarantine_remove_cache(cache);
> >  }
> >
> > @@ -239,6 +240,9 @@ void __asan_register_globals(void *ptr, ssize_t size)
> >         int i;
> >         struct kasan_global *globals = ptr;
> >
> > +       if (!kasan_enabled())
> > +               return;
> > +
> >         for (i = 0; i < size; i++)
> >                 register_global(&globals[i]);
> >  }
> > @@ -369,6 +373,9 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
> >         unsigned int rem_free_meta_size;
> >         unsigned int orig_alloc_meta_offset;
> >
> > +       if (!kasan_enabled())
> > +               return;
> > +
> >         if (!kasan_requires_meta())
> >                 return;
> >
> > @@ -518,6 +525,9 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
> >  {
> >         struct kasan_cache *info = &cache->kasan_info;
> >
> > +       if (!kasan_enabled())
> > +               return 0;
> > +
> >         if (!kasan_requires_meta())
> >                 return 0;
> >
> > @@ -543,6 +553,9 @@ void kasan_record_aux_stack(void *addr)
> >         struct kasan_alloc_meta *alloc_meta;
> >         void *object;
> >
> > +       if (!kasan_enabled())
> > +               return;
> > +
> >         if (is_kfence_address(addr) || !slab)
> >                 return;
> >
> > diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> > index f084e7a5df1e..c78d77ed47bc 100644
> > --- a/mm/kasan/init.c
> > +++ b/mm/kasan/init.c
> > @@ -447,6 +447,9 @@ void kasan_remove_zero_shadow(void *start, unsigned long size)
> >         unsigned long addr, end, next;
> >         pgd_t *pgd;
> >
> > +       if (!kasan_enabled())
> > +               return;
> > +
> >         addr = (unsigned long)kasan_mem_to_shadow(start);
> >         end = addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
> >
> > @@ -482,6 +485,9 @@ int kasan_add_zero_shadow(void *start, unsigned long size)
> >         int ret;
> >         void *shadow_start, *shadow_end;
> >
> > +       if (!kasan_enabled())
> > +               return 0;
> > +
> >         shadow_start = kasan_mem_to_shadow(start);
> >         shadow_end = shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
> >
> > diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
> > index 6958aa713c67..a6dc2c3d8a15 100644
> > --- a/mm/kasan/quarantine.c
> > +++ b/mm/kasan/quarantine.c
> > @@ -405,6 +405,9 @@ static int __init kasan_cpu_quarantine_init(void)
> >  {
> >         int ret = 0;
> >
> > +       if (!kasan_enabled())
> > +               return 0;
> > +
> >         ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
> >                                 kasan_cpu_online, kasan_cpu_offline);
> >         if (ret < 0)
> > diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> > index 62c01b4527eb..884357fa74ed 100644
> > --- a/mm/kasan/report.c
> > +++ b/mm/kasan/report.c
> > @@ -576,7 +576,9 @@ bool kasan_report(const void *addr, size_t size, bool is_write,
> >         unsigned long irq_flags;
> >         struct kasan_report_info info;
> >
> > -       if (unlikely(report_suppressed_sw()) || unlikely(!report_enabled())) {
> > +       if (unlikely(report_suppressed_sw()) ||
> > +           unlikely(!report_enabled()) ||
> > +           !kasan_enabled()) {
> >                 ret = false;
> >                 goto out;
> >         }
> > diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> > index 29a751a8a08d..f73a691421de 100644
> > --- a/mm/kasan/shadow.c
> > +++ b/mm/kasan/shadow.c
> > @@ -164,6 +164,8 @@ void kasan_unpoison(const void *addr, size_t size, bool init)
> >  {
> >         u8 tag = get_tag(addr);
> >
> > +       if (!kasan_enabled())
> > +               return;
> >         /*
> >          * Perform shadow offset calculation based on untagged address, as
> >          * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
> > @@ -277,7 +279,8 @@ static int __meminit kasan_mem_notifier(struct notifier_block *nb,
> >
> >  static int __init kasan_memhotplug_init(void)
> >  {
> > -       hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
> > +       if (kasan_enabled())
> > +               hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
> >
> >         return 0;
> >  }
> > @@ -658,6 +661,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
> >         size_t shadow_size;
> >         unsigned long shadow_start;
> >
> > +       if (!kasan_enabled())
> > +               return 0;
> > +
> >         shadow_start = (unsigned long)kasan_mem_to_shadow(addr);
> >         scaled_size = (size + KASAN_GRANULE_SIZE - 1) >>
> >                                 KASAN_SHADOW_SCALE_SHIFT;
> > @@ -694,6 +700,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
> >
> >  void kasan_free_module_shadow(const struct vm_struct *vm)
> >  {
> > +       if (!kasan_enabled())
> > +               return;
> > +
> >         if (IS_ENABLED(CONFIG_UML))
> >                 return;
> >
> > diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
> > index c75741a74602..6c1caec4261a 100644
> > --- a/mm/kasan/sw_tags.c
> > +++ b/mm/kasan/sw_tags.c
> > @@ -79,6 +79,9 @@ bool kasan_check_range(const void *addr, size_t size, bool write,
> >         u8 *shadow_first, *shadow_last, *shadow;
> >         void *untagged_addr;
> >
> > +       if (!kasan_enabled())
> > +               return true;
> > +
> >         if (unlikely(size == 0))
> >                 return true;
> >
> > --
> > 2.41.0
> >
> 


