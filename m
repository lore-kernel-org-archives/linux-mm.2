Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BADCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876C08E000E; Tue,  7 Oct 2025 08:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DED8E0005; Tue,  7 Oct 2025 08:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AD88E000E; Tue,  7 Oct 2025 08:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69E638E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:10:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02D458498F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:10:11 +0000 (UTC)
X-FDA: 83971200264.09.6FA2D0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2DACD14000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:10:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LD9oTq4j;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3kOZ6ZGIEmpHggLPNudEijuGEXi2mhTggJkYmbKlg0=;
	b=Hva/WIDBq5kS/Xp96bjWcK+ZzcP1K3l+OqgU71ZiuIOHsTr5tcFD3hPXiZKER1T8QWyBeF
	48m+OW7YcGCYsxHzvQ4PYK9bsC88bUguMH8MBl67ZSP+iddlDMmxGwaKUIecJK4gi1IXus
	wS5Ats+UNWIQ60fHdH+2Z4z0i7hJoMs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LD9oTq4j;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839010; a=rsa-sha256;
	cv=none;
	b=vrjrLLziRz7xtlpTUec7oqLq9Zhe7xTk5xeei8UEPW86LfonsMcLOwVCN2/VXRdFjct0OQ
	y/eOypFG3EznsxshQH30Q6+jWqpg96ZLs0uJ9ETj5z6sobwPYyof7W89p4CnaXUSe/oZhc
	27sdUUu8FWuBoB6/PvAWkIPk7rGvJrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B6C91443DC;
	Tue,  7 Oct 2025 12:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBADC4CEF1;
	Tue,  7 Oct 2025 12:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759839008;
	bh=N6Czb2+ZTAi8kRLBoW7s3ZRCalj0NwNMB9s+8L5BhWg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LD9oTq4jq08CjZmVNJWgEnuAZwVCZdv8sfwkIEAh/c+Oe5kq8WPOa5ZPTqlZfQB1Y
	 CzDX/Z7o44Wj8DXBVHBYcbqxShGD991305RNKl9tWQjsBR9vCMG0D0Jpu0JZgXock7
	 M5TpqpIefyey4KfjdjXqQVvtUTKqxuF018Nec1Xegu5HV6SkxCOc34z/TWxWsHGFrl
	 ire6hI4YY9Ko51XhW8NG3YXirlw0Ij4LdPq2q0ry2dv2pYYxPeXmLtd2sgWiBaiGT/
	 v2MFPjwtTslmDq8xIix4nsIVroVpF5lL/UYQu/0PaqsgEUR9Uzu6tf6whF285JRFM7
	 h3OqwGMuIFkwA==
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
In-Reply-To: <CA+CK2bA2qfLF1Mbyvnat+L9+5KAw6LnhYETXVoYcMGJxwTGahg@mail.gmail.com>
	(Pasha Tatashin's message of "Mon, 6 Oct 2025 13:21:20 -0400")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-4-pasha.tatashin@soleen.com>
	<mafs0tt0cnevi.fsf@kernel.org>
	<CA+CK2bA2qfLF1Mbyvnat+L9+5KAw6LnhYETXVoYcMGJxwTGahg@mail.gmail.com>
Date: Tue, 07 Oct 2025 14:09:57 +0200
Message-ID: <mafs0playoqui.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2DACD14000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: odpjpaqw1hnwicaysyex3hufbynuuzm4
X-HE-Tag: 1759839009-247693
X-HE-Meta: U2FsdGVkX19PvnIS4D2B+ykxB9yXeG1ZcTqNcyQUQoZWHjuvYxmbBCwIGnq5jeMDXUP3sxM+A+Hoo+z+efhrgom1hMydQgQGSfCskLs/6SJqxE7aZN6Rz7WGXsUhHL3aUzf8FstynNb622Z1mHi2r7FjkziHl+XCFI2pTHvEc0jKdyytRs3GUJN/VAuUkSSzxNTPFYJg0QRvdMTNf+naOqvNfAqroimr7fOag9DCLnxCYDORb55YGlQox2+wlQvcdoNQ4ZMqo/hjMV6OB1meLNcOlVF03rbXeJcwN6Hb0Eq3oLwWC6JPq4LHQJ/8YMS+Ss+U+wsmxVe9AXPCRquI6pHumSrqf2oXreU0VNzXJ+KO8kWJ6vLIldzWFC2Ruuj1V23KNfNGm3A37GMvSOVdZy2JEnExowADvTGZ862RRPi1hCmjQ1R1mSFNZXdp366aZcrOF33vaHRnyzEiA15RR6xog9pJy8wINRYvorNWrySSOYLDx+lim60HdQl+uJH2JuZ4IcpcUbwskB7U0Qay9egLQNphIz2zcVEuwOTGNVZwY/oW5T5Lmq6FJ87jrkRM7pqSjyJKj38CSjdLM8NujC9WtrY9CvfvjkH+nwEGwGG93bydcAvBnsN965iuSBzhLOa/ApLaE1VNDTPV2v0v0YOZb9FAqA24cq8QPY6/K9m5PjXvttEHIKslvNDvSqoqHppndfTWJgaeR3Q92dHZhd/ZDgZL66KcGgWcyLo1vWUxrHnpqZvlRKoYlCGWnGiAHa9POPxX4iR1Sfg3U3CSYs6Nol4Rts0eQr17pmR+/hNhpxrUI+nmPgKeJKuuMJhxjpB/HACjoK1XJ5MA5P1niMZ0xrxpayU8qYcmgL0QnTotmvhYA/i4TqTGASAFGtg+QB0fsx5LLq13GxXsVssqm6qD4jPCURBcDUVWEbfnRw2M8S2YQ7bP258IaZbf5uQ/tY2PBQcWknjRuk2p02B
 spl+kOv/
 0CtWPoiIFPh/fgf5YHqf4vh/maGRVoPH1JnXj9n/4sVcc1JaAYUHX6u+gLmROCXWk6qKNgJE97W7emoRO2BzS7oQsOKBBCW8zQ+MpOEcWJkmMlF6vowqm3vU+jcnDR0H1LoMUVu7x+7iHDfQezTv4CeBotKxR2br6g4QELR42uWp6wQSykiwggvCvVujYsc/TXBvGR2nEw4xcfiHqZWNTztamAC/Dfunma84yi0U9k8TX9G4S9HE1SXhHXhfrKe74HKkVPHq0KGmAD9go3m22t+GVL46ngL4AarPSVZ0/YGx8GoDFE7VUZ4Ijy/6UZASYdoJK8iqGHsG4/ZjMTgVO9/e3uThmQwMT+vkZg1RsNEVSkL9YQxJJ9EMR2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06 2025, Pasha Tatashin wrote:

> On Mon, Oct 6, 2025 at 1:01=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>>
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > The KHO framework uses a notifier chain as the mechanism for clients to
>> > participate in the finalization process. While this works for a single,
>> > central state machine, it is too restrictive for kernel-internal
>> > components like pstore/reserve_mem or IMA. These components need a
>> > simpler, direct way to register their state for preservation (e.g.,
>> > during their initcall) without being part of a complex,
>> > shutdown-time notifier sequence. The notifier model forces all
>> > participants into a single finalization flow and makes direct
>> > preservation from an arbitrary context difficult.
>> > This patch refactors the client participation model by removing the
>> > notifier chain and introducing a direct API for managing FDT subtrees.
>> >
>> > The core kho_finalize() and kho_abort() state machine remains, but
>> > clients now register their data with KHO beforehand.
>> >
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> [...]
>> > diff --git a/mm/memblock.c b/mm/memblock.c
>> > index e23e16618e9b..c4b2d4e4c715 100644
>> > --- a/mm/memblock.c
>> > +++ b/mm/memblock.c
>> > @@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *na=
me)
>> >  #define MEMBLOCK_KHO_FDT "memblock"
>> >  #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
>> >  #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
>> > -static struct page *kho_fdt;
>> > -
>> > -static int reserve_mem_kho_finalize(struct kho_serialization *ser)
>> > -{
>> > -     int err =3D 0, i;
>> > -
>> > -     for (i =3D 0; i < reserved_mem_count; i++) {
>> > -             struct reserve_mem_table *map =3D &reserved_mem_table[i];
>> > -             struct page *page =3D phys_to_page(map->start);
>> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
>> > -
>> > -             err |=3D kho_preserve_pages(page, nr_pages);
>> > -     }
>> > -
>> > -     err |=3D kho_preserve_folio(page_folio(kho_fdt));
>> > -     err |=3D kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho=
_fdt));
>> > -
>> > -     return notifier_from_errno(err);
>> > -}
>> > -
>> > -static int reserve_mem_kho_notifier(struct notifier_block *self,
>> > -                                 unsigned long cmd, void *v)
>> > -{
>> > -     switch (cmd) {
>> > -     case KEXEC_KHO_FINALIZE:
>> > -             return reserve_mem_kho_finalize((struct kho_serializatio=
n *)v);
>> > -     case KEXEC_KHO_ABORT:
>> > -             return NOTIFY_DONE;
>> > -     default:
>> > -             return NOTIFY_BAD;
>> > -     }
>> > -}
>> > -
>> > -static struct notifier_block reserve_mem_kho_nb =3D {
>> > -     .notifier_call =3D reserve_mem_kho_notifier,
>> > -};
>> >
>> >  static int __init prepare_kho_fdt(void)
>> >  {
>> >       int err =3D 0, i;
>> > +     struct page *fdt_page;
>> >       void *fdt;
>> >
>> > -     kho_fdt =3D alloc_page(GFP_KERNEL);
>> > -     if (!kho_fdt)
>> > +     fdt_page =3D alloc_page(GFP_KERNEL);
>> > +     if (!fdt_page)
>> >               return -ENOMEM;
>> >
>> > -     fdt =3D page_to_virt(kho_fdt);
>> > +     fdt =3D page_to_virt(fdt_page);
>> >
>> >       err |=3D fdt_create(fdt, PAGE_SIZE);
>> >       err |=3D fdt_finish_reservemap(fdt);
>> > @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
>> >       err |=3D fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NOD=
E_COMPATIBLE);
>> >       for (i =3D 0; i < reserved_mem_count; i++) {
>> >               struct reserve_mem_table *map =3D &reserved_mem_table[i];
>> > +             struct page *page =3D phys_to_page(map->start);
>> > +             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
>> >
>> > +             err |=3D kho_preserve_pages(page, nr_pages);
>> >               err |=3D fdt_begin_node(fdt, map->name);
>> >               err |=3D fdt_property_string(fdt, "compatible", RESERVE_=
MEM_KHO_NODE_COMPATIBLE);
>> >               err |=3D fdt_property(fdt, "start", &map->start, sizeof(=
map->start));
>> > @@ -2507,13 +2475,14 @@ static int __init prepare_kho_fdt(void)
>> >               err |=3D fdt_end_node(fdt);
>> >       }
>> >       err |=3D fdt_end_node(fdt);
>> > -
>> >       err |=3D fdt_finish(fdt);
>> >
>> > +     err |=3D kho_preserve_folio(page_folio(fdt_page));
>> > +     err |=3D kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
>> > +
>> >       if (err) {
>> >               pr_err("failed to prepare memblock FDT for KHO: %d\n", e=
rr);
>> > -             put_page(kho_fdt);
>> > -             kho_fdt =3D NULL;
>> > +             put_page(fdt_page);
>>
>> This adds subtree to KHO even if the FDT might be invalid. And then
>> leaves a dangling reference in KHO to the FDT in case of an error. I
>> think you should either do this check after
>> kho_preserve_folio(page_folio(fdt_page)) and do a clean error check for
>> kho_add_subtree(), or call kho_remove_subtree() in the error block.
>
> I agree, I do not like these err |=3D stuff, we should be checking
> errors cleanly, and do proper clean-ups.

Yeah, this is mainly a byproduct of using FDTs. Getting and setting
simple properties also needs error checking and that can get tedious
real quick. Which is why this pattern has shown up I suppose.

>
>> I prefer the former since if kho_add_subtree() is the one that fails,
>> there is little sense in removing a subtree that was never added.
>>
>> >       }
>> >
>> >       return err;
>> > @@ -2529,13 +2498,6 @@ static int __init reserve_mem_init(void)
>> >       err =3D prepare_kho_fdt();
>> >       if (err)
>> >               return err;
>> > -
>> > -     err =3D register_kho_notifier(&reserve_mem_kho_nb);
>> > -     if (err) {
>> > -             put_page(kho_fdt);
>> > -             kho_fdt =3D NULL;
>> > -     }
>> > -
>> >       return err;
>> >  }
>> >  late_initcall(reserve_mem_init);
>>
>> --
>> Regards,
>> Pratyush Yadav

--=20
Regards,
Pratyush Yadav

