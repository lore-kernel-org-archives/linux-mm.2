Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92B3CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 13:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E0E8E000F; Tue,  7 Oct 2025 09:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55788E0005; Tue,  7 Oct 2025 09:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C048E000F; Tue,  7 Oct 2025 09:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C56728E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:30:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66A8156AB7
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:30:27 +0000 (UTC)
X-FDA: 83971402494.03.5853CE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D9F4180010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:30:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfq10qwA;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759843825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgnid4GhMJCMXY3bn3j9nrIxoolw6zNsfcgmZnb/AMQ=;
	b=BhaMBPCa6bcHRYbN0gI7l2f7rEcKmoBg5Esztjocw6DrMEZOARJg1JQ2UhYrgXh2l8BEbC
	CxkvD8guheuyAAQkkxa8Y7NC17Nm+OxHdEyF0rKxDZ3jc/mUYV0wpJUAK0icGL9UMsLgSN
	cX63uBqE2oDi/Ez2V4W3mlxa+znMNFw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jfq10qwA;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759843825; a=rsa-sha256;
	cv=none;
	b=okLwY8QMtrxhMZLefsKbS5hLdORAUew9qsQuHoTNyIJShPoJSzv2cAztzj8m+kRkv2PL+3
	rcrm19l1feqMNvvLJS+gKxKKXX7uqaK8cz7e9P+mSY9kuRvSf6GSTzS0c7YkdPgCEWo4dD
	9hkCIiigkgO0NIElA2UhJSEd26VKPys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27B6B404D2;
	Tue,  7 Oct 2025 13:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92074C4CEF1;
	Tue,  7 Oct 2025 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759843824;
	bh=a+hLMRZ89lMMfohnZj5rrKyndKWksZlfn0//bNtRnv4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jfq10qwAPMrOKPp2UWn6SkGdeFAYE0GUabtMligJY3wVU7Aq8Vpaig+nucTfu4Ajc
	 2ZCWUllTifw2PXGTtyHvi0afbUzDzKw/xEMI/Q8cFAwORA+B8jPmQ9V7pxjNOq9ctl
	 5JPz7CoVYIKtFXHWaamduBxbDeVM1quhrxSUpII69Yno07vmItODHPdyJ7qSIdWWHs
	 SILxDRyD+XXt0fsILH398D4Gz7J+B0xg4U7oABmaICYhXnaroMvkJQGGd6lY22XFQn
	 JzXBXN9OevTrIdhHUH1Bhdhv5w8wAKiTNGOxeYy9nUDUor5zr1ITtH9MlNKTsS0c6d
	 psfRTjxGAHJ6g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  jasonmiu@google.com,
  graf@amazon.com,  changyuanl@google.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 03/30] kho: drop notifiers
In-Reply-To: <CA+CK2bCFsPZQQQ0JFErnYt=dbzBx=ZJdV+eNXYWyNUE+xk7=yA@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 7 Oct 2025 09:16:24 -0400")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-4-pasha.tatashin@soleen.com>
	<mafs0tt0cnevi.fsf@kernel.org>
	<CA+CK2bA2qfLF1Mbyvnat+L9+5KAw6LnhYETXVoYcMGJxwTGahg@mail.gmail.com>
	<mafs0playoqui.fsf@kernel.org>
	<CA+CK2bCFsPZQQQ0JFErnYt=dbzBx=ZJdV+eNXYWyNUE+xk7=yA@mail.gmail.com>
Date: Tue, 07 Oct 2025 15:30:13 +0200
Message-ID: <mafs0a522on4q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D9F4180010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5y4qh8ni6yp85h7c8py13uzdad8miym3
X-HE-Tag: 1759843825-128784
X-HE-Meta: U2FsdGVkX18dQKu9NnzR650wYzq3zZShGPagCtKX034R3j7PGJrRArU8oTPCrC+4OfQGrfsEYuW+y4+WSHwGfQIyo45JViXepjModjQDLNYbHLUBKKiZWKlegxENg+quvmdXm117fhZmE3S6G7I8+8xATe1PbKv5OoDpxJd+m2Q/5ig3tSsaxdDIMkHkM2hoFtjZylKrl8aQN5KuTfsE7KanDgljbtwEiL5r1ELS4fsvDwB57Up7bhCV5IVJylV74gbSd7exihLuVooCYlTUb4dT0t+vnS7JhAltfPvOOBqoG1euGnMKQOG8+BFfdYp8f5tLdHVUHgBUqn+iygFhOYnSq/sWkTgVISfby74BjQeAP662z2z8zjctpJeopNJH9z/FUhpEXp+dxA307WTZS2RmFGC0nObNXSDnFpS4uK7ipTxL7eWx9EQzUYEtfYcfjt46UJ6Svx1gJtXGYmZHy52tE5fxuRf8XBbqXhEAkIO6CwXX0AzHwDNSX1trs0xxbbqJSO1p6FN19IGJ3XX0m26hVtTmheDM2SELihwjrSVIEq0FEGVRu52C2P24uv6eMsTNL79dW8Q1/lNA+ZKGaqCT5zi4D+YaXkA1dwvwEw6y7FZORNHvdmME0FsO4+VpSVWtCKgjFa+BHyUuIhBXhYh+cCmZTS0NiEMZsKFTqHeMHriCQ509vv6Xx75i0ACnHfmMe80n7qCxd1/NZyYqhBgqIBq/ew5KiN94C2LMTByRd771RTCnR5WycLg8KbrAxjkN3LI1UIQR3ewm1X6gI5hrSnQcoKv7ggqog6uGR1BOlxph0CoeKguESwr91ZwLlsUJ9/VmmT+gFNVkM2oGFXfV4x9yoRWa9aWDzdfEXBVMwkdOAL9wIfK8+f8UKDMcapodM1LdZPEUMe5sEaXsb98KnwhTNqnWUMXglau9KSc2FB2D+TS1ToLVrRbxJAV0BMxHD7VU26/rr/03v5j
 lKTXg8iz
 3UrX80d0UNZoi+aM31j4hH5nMxkVIYcr7pXkJYJafEl8HNGZpNtehkyJ0/mFE5WBpTlya+1kMmx4IpVlH9j+oIpvadYjTAJpYpBbnGWkohEYBKNtjKA0dwiT7ehaCjTYlwhMrAU1ptRqzspnFchJkwgZRZxuce+1Q9YWVtloYo1CU5eUDnIBPYcWXKRr4MwJsZt15UKOfI2HmCuhsyS+xYtDAW2sZTrFHEzyZgXFEJwTIuMdJfGtUDH9unHXaAefjhLPffxLUWuc54OexC0vYa33xlSOYA8Mvqxe5uqWOdgUnm4lxzD/ZResWei6yKCKSJJxP0RRkzq3lYr2rRMLy3mD+Wer6nvYiyewAujlM/uOLFajq9w6ddVWpMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07 2025, Pasha Tatashin wrote:

> On Tue, Oct 7, 2025 at 8:10=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> On Mon, Oct 06 2025, Pasha Tatashin wrote:
>>
>> > On Mon, Oct 6, 2025 at 1:01=E2=80=AFPM Pratyush Yadav <pratyush@kernel=
.org> wrote:
>> >>
>> >> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>> >>
>> >> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >> >
>> >> > The KHO framework uses a notifier chain as the mechanism for client=
s to
>> >> > participate in the finalization process. While this works for a sin=
gle,
>> >> > central state machine, it is too restrictive for kernel-internal
>> >> > components like pstore/reserve_mem or IMA. These components need a
>> >> > simpler, direct way to register their state for preservation (e.g.,
>> >> > during their initcall) without being part of a complex,
>> >> > shutdown-time notifier sequence. The notifier model forces all
>> >> > participants into a single finalization flow and makes direct
>> >> > preservation from an arbitrary context difficult.
>> >> > This patch refactors the client participation model by removing the
>> >> > notifier chain and introducing a direct API for managing FDT subtre=
es.
>> >> >
>> >> > The core kho_finalize() and kho_abort() state machine remains, but
>> >> > clients now register their data with KHO beforehand.
>> >> >
>> >> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> >> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> >> [...]
>> >> > diff --git a/mm/memblock.c b/mm/memblock.c
>> >> > index e23e16618e9b..c4b2d4e4c715 100644
>> >> > --- a/mm/memblock.c
>> >> > +++ b/mm/memblock.c
>> >> > @@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char =
*name)
>> >> >  #define MEMBLOCK_KHO_FDT "memblock"
>> >> >  #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
>> >> >  #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
>> >> > -static struct page *kho_fdt;
>> >> > -
>> >> > -static int reserve_mem_kho_finalize(struct kho_serialization *ser)
>> >> > -{
>> >> > -     int err =3D 0, i;
>> >> > -
>> >> > -     for (i =3D 0; i < reserved_mem_count; i++) {
>> >> > -             struct reserve_mem_table *map =3D &reserved_mem_table=
[i];
>> >> > -             struct page *page =3D phys_to_page(map->start);
>> >> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
>> >> > -
>> >> > -             err |=3D kho_preserve_pages(page, nr_pages);
>> >> > -     }
>> >> > -
>> >> > -     err |=3D kho_preserve_folio(page_folio(kho_fdt));
>> >> > -     err |=3D kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(=
kho_fdt));
>> >> > -
>> >> > -     return notifier_from_errno(err);
>> >> > -}
>> >> > -
>> >> > -static int reserve_mem_kho_notifier(struct notifier_block *self,
>> >> > -                                 unsigned long cmd, void *v)
>> >> > -{
>> >> > -     switch (cmd) {
>> >> > -     case KEXEC_KHO_FINALIZE:
>> >> > -             return reserve_mem_kho_finalize((struct kho_serializa=
tion *)v);
>> >> > -     case KEXEC_KHO_ABORT:
>> >> > -             return NOTIFY_DONE;
>> >> > -     default:
>> >> > -             return NOTIFY_BAD;
>> >> > -     }
>> >> > -}
>> >> > -
>> >> > -static struct notifier_block reserve_mem_kho_nb =3D {
>> >> > -     .notifier_call =3D reserve_mem_kho_notifier,
>> >> > -};
>> >> >
>> >> >  static int __init prepare_kho_fdt(void)
>> >> >  {
>> >> >       int err =3D 0, i;
>> >> > +     struct page *fdt_page;
>> >> >       void *fdt;
>> >> >
>> >> > -     kho_fdt =3D alloc_page(GFP_KERNEL);
>> >> > -     if (!kho_fdt)
>> >> > +     fdt_page =3D alloc_page(GFP_KERNEL);
>> >> > +     if (!fdt_page)
>> >> >               return -ENOMEM;
>> >> >
>> >> > -     fdt =3D page_to_virt(kho_fdt);
>> >> > +     fdt =3D page_to_virt(fdt_page);
>> >> >
>> >> >       err |=3D fdt_create(fdt, PAGE_SIZE);
>> >> >       err |=3D fdt_finish_reservemap(fdt);
>> >> > @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
>> >> >       err |=3D fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_=
NODE_COMPATIBLE);
>> >> >       for (i =3D 0; i < reserved_mem_count; i++) {
>> >> >               struct reserve_mem_table *map =3D &reserved_mem_table=
[i];
>> >> > +             struct page *page =3D phys_to_page(map->start);
>> >> > +             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
>> >> >
>> >> > +             err |=3D kho_preserve_pages(page, nr_pages);
>> >> >               err |=3D fdt_begin_node(fdt, map->name);
>> >> >               err |=3D fdt_property_string(fdt, "compatible", RESER=
VE_MEM_KHO_NODE_COMPATIBLE);
>> >> >               err |=3D fdt_property(fdt, "start", &map->start, size=
of(map->start));
>> >> > @@ -2507,13 +2475,14 @@ static int __init prepare_kho_fdt(void)
>> >> >               err |=3D fdt_end_node(fdt);
>> >> >       }
>> >> >       err |=3D fdt_end_node(fdt);
>> >> > -
>> >> >       err |=3D fdt_finish(fdt);
>> >> >
>> >> > +     err |=3D kho_preserve_folio(page_folio(fdt_page));
>> >> > +     err |=3D kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
>> >> > +
>> >> >       if (err) {
>> >> >               pr_err("failed to prepare memblock FDT for KHO: %d\n"=
, err);
>> >> > -             put_page(kho_fdt);
>> >> > -             kho_fdt =3D NULL;
>> >> > +             put_page(fdt_page);
>> >>
>> >> This adds subtree to KHO even if the FDT might be invalid. And then
>> >> leaves a dangling reference in KHO to the FDT in case of an error. I
>> >> think you should either do this check after
>> >> kho_preserve_folio(page_folio(fdt_page)) and do a clean error check f=
or
>> >> kho_add_subtree(), or call kho_remove_subtree() in the error block.
>> >
>> > I agree, I do not like these err |=3D stuff, we should be checking
>> > errors cleanly, and do proper clean-ups.
>>
>> Yeah, this is mainly a byproduct of using FDTs. Getting and setting
>> simple properties also needs error checking and that can get tedious
>> real quick. Which is why this pattern has shown up I suppose.
>
> Exactly. This is also why it's important to replace FDT with something
> more sensible for general-purpose live update purposes.
>
> By the way, I forgot to address this comment in the v5 of the KHO
> series I sent out yesterday. Could you please take another look? If
> everything else is good, I will refresh that series so we can ask
> Andrew to take in the KHO patches. That would simplify the LUO series.

Good idea. Will take a look.

[...]

--=20
Regards,
Pratyush Yadav

