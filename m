Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829F5CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D64C8E008B; Fri, 24 Oct 2025 09:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6865F8E0042; Fri, 24 Oct 2025 09:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575D88E008B; Fri, 24 Oct 2025 09:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 401388E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:11:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF4C113C452
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:11:57 +0000 (UTC)
X-FDA: 84033045474.23.AEB54C2
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id CE8051C000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:11:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E7J0cind;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761311516; a=rsa-sha256;
	cv=none;
	b=Gf7KYmNZguuiHUoxNkqnSOFXjk2mh155VMxYCtOlUscMncYFlDKEQJEitgKRqVng46g3OX
	WidnuZaTltkNKocNW5o2a+W2M9pQSGxaBPr5jDUBqcy6GQojntR3Jb6zaqXKSWWMKwvbo5
	NRdbg1EUJywfB1/y2PHmrqGqv5w64vQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E7J0cind;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761311516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUFjBoOvLfPTJUpNwq8FsuiPCzN1aQ2yq2Ml6/Jyk1k=;
	b=dl2JVXjhR231/rg8Dg2Z5zTmKvXN3EJr89ghMPNlejg1HY4liHBISnngLwsqr04sNK89gF
	o+/e6Eo6ZPjpmGBrh+pLMjDlDofsC69s4l2LuwKlCgUTpOL4hRxij/1TGCUfhmQzgpZSuM
	/eLXDDmcCDqHEoIQr/esXaIofBPAkWI=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so2934117a12.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761311514; x=1761916314; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HUFjBoOvLfPTJUpNwq8FsuiPCzN1aQ2yq2Ml6/Jyk1k=;
        b=E7J0cindnayqmQ792C4KA3+z7kK3QVlek2hm1WT0oA/fUits3hhd0ntuyEFhhkoRhU
         IEb5CLuFLn792GJFdi02IMKLmk11koDKTydBscKp5iEnqNqzoCtIFhYG9YlObIpydJfV
         W2pGyGLHG+rfzAtzyAPt96Hp4FinNHw6MvRdB2EV8Ke3YElfvyjgadqqVIXk6uBHYDIr
         qDq2Z//eWSTg/csPYVCgI+iMiSINgzMftNiyX8PHZKIkuPr3o4OrEQZmCI7rBuE8jwBd
         e3YcgQbhZuao0Xpd2Lm+qHyJmni65TIG9R49RnuBASipT1WAl1RHnpWIuvvMO/dw4PQ5
         HeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761311514; x=1761916314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HUFjBoOvLfPTJUpNwq8FsuiPCzN1aQ2yq2Ml6/Jyk1k=;
        b=xIGYVGsedDswP9GWFkL2EJrhYOo5HFneghIE+4Vwmrf44RTn9uBj/oTXAfQtDbl5S4
         /lPj7BHnjmUsitnAH7EEFf+oL8IA7RfNY5CLZx/XjzCZ4DO4F5EV/lQUMuBq/W74Mc1i
         jt2wd8qpvHva8Nk+stUVAVlK4hnspqmkt4i/F5l01BToK0CfMjSGVsjBdCl3p9cwQIm1
         N2doNtMpYitFLAW+lJP8GqDGqTSvedH1I878lxfNYCprqAkc2SNwyQ1k/dcvM9I61EpK
         13RXQf/0qw0ITZDGPMjELUxQErUFesL3T6JHn82dT6pu7+O7rHstpzRjgR5Ymcr2yK6J
         dTAg==
X-Forwarded-Encrypted: i=1; AJvYcCUN1iOQWSdgV1xhPhxym0MP3vs6/JDYsM+VIxeO/NIq5dsfX2UaiyOWqg23CRlsobNTK3IhTTYD7w==@kvack.org
X-Gm-Message-State: AOJu0YyfHnUJX/V9bmP117qakxv3p4mKXWbkVBJQpmNT4RyTCFEiYwOB
	XvF1Qlw77NN10gPRZoXA7f4bI5xjDRjFzpZrE0IQChNTHrlXkEFDbxi3lvTsc2wGhaZ9prFAJNX
	pwji0ELBBccipCBbztnU1TOqByZSbc1R1wOdegAd+6Q==
X-Gm-Gg: ASbGncvZwbc4dbCJVVojEs7U8kDGULbgTRKAgktvEyOa/lYDCnggPZG4+IQjizUILGl
	A54ZZIHKV/nHYjDfMVKvO5qnhEWOOa9uw9VMlpCIIkmDruDLfO8gh6CxezULCwe9PA2H0L15I0A
	1Dc1/p0ZZ2zAaaXLWNFssXCWsJHkE5yyGQQTL+q3cITMW8AldtB8IO1Lql9E+odGKxLAjN1LEAG
	qivBzpRiYesDrxSpK2GySbudMVDgUsuxbQ2FAmQkU8ss8yqNblPznD3Fg==
X-Google-Smtp-Source: AGHT+IH9rsE8M2MY/COIAjepb78sZJfunMk8EVwR7yVf5O/90QQr0+6a+OVf7DIz8KsKgykJe6HVYhzJZDMVC3FYg8s=
X-Received: by 2002:aa7:c958:0:b0:636:a789:beb9 with SMTP id
 4fb4d7f45d1cf-63c1f6dc078mr18925767a12.37.1761311513782; Fri, 24 Oct 2025
 06:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-4-pasha.tatashin@soleen.com> <mafs0ikg7fbez.fsf@kernel.org>
In-Reply-To: <mafs0ikg7fbez.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 09:11:16 -0400
X-Gm-Features: AWmQ_bn6L1OcjOCSKybf_c3mHT-I2GiF2haRrAMI3CbUcf4To6YoULyp-vpHjEg
Message-ID: <CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hbeaie8znmn5cegbymg4ptk8fx816oe4
X-Rspamd-Queue-Id: CE8051C000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761311515-89485
X-HE-Meta: U2FsdGVkX19FCoQS6IvN7wOoxlSeL5qnBb5SyWApi+Ddr6cUbbH1N5BAr0gYnoIVv61dToQdAy8BG3ndUFWdAJTyOv/Ln6wZYK3aHag0ryJI/j8vC5AB1Z+yVeAdbMvMnxZQrHCU9cKeSFdopEIpuQZj6uHY8ucl08hsraphUJCFeZRk3KKy7HIAsaMZ4AL23/zEn2qBS8k7Tk9VcQ8cSTskrHH4E+vZRcZhUy66PD8lPRO9B8WwhyhQsyo8fpf7QhB67uKpt7vvkosV6ZXpusLObEpqMJIHTM8rpCZwOnNZaS1dUzkUXHkmRhIUiyy2/QZfIr6kqJi+DXGiiaYP0LOg7f7Zein4qNtXnJc39toj/NbVrfA+BV7BzeQh38T6uCvQUL9gJMe5wUooiEytR5sm65qF7DU3rN7z7s9LkCVLJRzl5sSMD7gogm1tFpNz0IDSB4Rz9Ayu2kkduxO+Rmb6YxF5BfWblYiEvsbJ1gB6/Tmdg9vhmYwGm1M4mRdmNLJ+Q7VjO+VFxFDuTjWKPCW93Hk7q2HNAJBN/RzVAgx8XyLSJowNrLIWipEbZ6fqbTInYPogoJArHny3Cm7d00Wb/iv9A3h3+XuzVbVedTNHf48z304sZljB1wj6Gkprus5gRM9F5WMRzl2T9ZbuMS8f7CA+0g3aVs7oTlP401aWr+bILgjzuE8Kzw4kB+/qkaUO9j+7hBprQeOhX07LLpPlwXNgsG0Sce1I/4Qy2EY38Vnvgbp3jNXvv1Hvcu1ub5UIZmz6WRbIR3Aq42ImqP2XL3Qg8RW64E1BiJcafHK9mQuNvrjz337WwW8G39N9NzmqPtJmDAcm51LuMRanUcINz4r+Viw8ofuJX+QyNPKoH/dJ+vvLiSjeVOUHxs2G2rW0mktb5WEzKfE+8+bVLT1flQklyTiMQSnzXjgCFDjGZ14L0mnHxAfmcDKd29A1XXjrDwSCKNRV+OGrJrN
 D9O2JjoH
 EpIfa+k1JcDqgAKmyafjoR3wQMMWL7kBz3+quj8VSvUW2j0uCIDAbunJTb5JCqVt2NZmc1RlMRkukFr09+ElKIlu/mURvuZBAMI0ArsWAChywXOBlhWX951hMIoeljdII/2L76cvFPv5DU+XH8QWOeaBE8BvnqsWVs6Zf4h0oCjKh9GKDRLt8gFhZIAgjV5Y9WW6eGnPCVbk4kMQll7YmZYIOHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > -int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
> > +int kho_add_subtree(const char *name, void *fdt)
> >  {
> > -     int err = 0;
> > -     u64 phys = (u64)virt_to_phys(fdt);
> > -     void *root = page_to_virt(ser->fdt);
> > +     struct kho_sub_fdt *sub_fdt;
> > +     int err;
> >
> > -     err |= fdt_begin_node(root, name);
> > -     err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
> > -     err |= fdt_end_node(root);
> > +     sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> > +     if (!sub_fdt)
> > +             return -ENOMEM;
> >
> > -     if (err)
> > -             return err;
> > +     INIT_LIST_HEAD(&sub_fdt->l);
> > +     sub_fdt->name = name;
> > +     sub_fdt->fdt = fdt;
> >
> > -     return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
> > +     mutex_lock(&kho_out.fdts_lock);
> > +     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
> > +     err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
>
> I think you should remove sub_fdt from the list and kfree() it on error
> here. Otherwise we signal an error to the caller and they might free
> sub_fdt->fdt, which will later result in a use-after-free at
> __kho_finalize().

I think, it is better to simply do:
WARN_ON_ONCE(kho_debugfs_fdt_add(...));
Now debugfs is optional, and there is no reason to return an error to
a caller if kho_debugfs_fdt_add() fails

>
> > +     mutex_unlock(&kho_out.fdts_lock);
> > +
> > +     return err;
> >  }
> >  EXPORT_SYMBOL_GPL(kho_add_subtree);
> >
> > -int register_kho_notifier(struct notifier_block *nb)
> > +void kho_remove_subtree(void *fdt)
> >  {
> > -     return blocking_notifier_chain_register(&kho_out.chain_head, nb);
> > -}
> > -EXPORT_SYMBOL_GPL(register_kho_notifier);
> > +     struct kho_sub_fdt *sub_fdt;
> > +
> > +     mutex_lock(&kho_out.fdts_lock);
> > +     list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
>
> list_for_each_entry_safe() here since we delete.

Not needed, we are breaking from the iterator when deleting.


> >  bool kho_finalized(void)
> > @@ -1232,15 +1248,17 @@ static __init int kho_init(void)
> >  {
> >       int err = 0;
> >       const void *fdt = kho_get_fdt();
> > +     struct page *fdt_page;
> >
> >       if (!kho_enable)
> >               return 0;
> >
> > -     kho_out.ser.fdt = alloc_page(GFP_KERNEL);
> > -     if (!kho_out.ser.fdt) {
> > +     fdt_page = alloc_page(GFP_KERNEL);
> > +     if (!fdt_page) {
> >               err = -ENOMEM;
> >               goto err_free_scratch;
> >       }
> > +     kho_out.fdt = page_to_virt(fdt_page);
> >
> >       err = kho_debugfs_init();
> >       if (err)
> > @@ -1268,8 +1286,8 @@ static __init int kho_init(void)
> >       return 0;
> >
> >  err_free_fdt:
> > -     put_page(kho_out.ser.fdt);
> > -     kho_out.ser.fdt = NULL;
> > +     put_page(fdt_page);
> > +     kho_out.fdt = NULL;
> >  err_free_scratch:
> >       for (int i = 0; i < kho_scratch_cnt; i++) {
> >               void *start = __va(kho_scratch[i].addr);
> > @@ -1280,7 +1298,7 @@ static __init int kho_init(void)
> >       kho_enable = false;
> >       return err;
> >  }
> > -late_initcall(kho_init);
> > +fs_initcall(kho_init);
>
> Is this change related to this patch? Also, why fs_initcall?
>
> >
> >  static void __init kho_release_scratch(void)
> >  {
> > @@ -1416,7 +1434,7 @@ int kho_fill_kimage(struct kimage *image)
> >       if (!kho_out.finalized)
> >               return 0;
> >
> > -     image->kho.fdt = page_to_phys(kho_out.ser.fdt);
> > +     image->kho.fdt = virt_to_phys(kho_out.fdt);
> >
> >       scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
> >       scratch = (struct kexec_buf){
> > diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
> > index a91b279f1b23..46e9e6c0791f 100644
> > --- a/kernel/kexec_handover_debugfs.c
> > +++ b/kernel/kexec_handover_debugfs.c
> > @@ -61,14 +61,17 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
> >       return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
> >  }
> >
> > -void kho_debugfs_cleanup(struct kho_debugfs *dbg)
> > +void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
> >  {
> > -     struct fdt_debugfs *ff, *tmp;
> > -
> > -     list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
> > -             debugfs_remove(ff->file);
> > -             list_del(&ff->list);
> > -             kfree(ff);
> > +     struct fdt_debugfs *ff;
> > +
> > +     list_for_each_entry(ff, &dbg->fdt_list, list) {
>
> list_for_each_entry_safe() here too.

Not needed, we are breaking out on delete/free.


> >  static int kho_test_save_data(struct kho_test_state *state, void *fdt)
> >  {
> >       phys_addr_t *folios_info __free(kvfree) = NULL;
> > @@ -102,6 +86,9 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
> >       if (!err)
> >               state->folios_info = no_free_ptr(folios_info);
> >
> > +     if (!err)
> > +             err = kho_test();
>
> This name is very undescriptive. Also, not the right place to add the
> subtree since the FDT isn't finished yet. I think it should be done from
> kho_test_save() instead. This patch is also missing removing the subtree
> at exit, and that can cause a UAF.
>
> I sent you a patch earlier with my take on how it should be done. I
> still think that is the way to go:
> https://lore.kernel.org/all/mafs0347woui2.fsf@kernel.org/

Sure, I updated to use your suggested changes.

