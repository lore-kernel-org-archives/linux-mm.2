Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4F2C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D68E6B007B; Mon, 10 Aug 2026 10:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD086B008A; Mon, 10 Aug 2026 10:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2416B008C; Mon, 10 Aug 2026 10:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486426B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:35:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC81F1A018E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:35:53 +0000 (UTC)
X-FDA: 85085608986.10.7721E38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8DDE100005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:35:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mokf2unt;
	spf=pass (imf14.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786372551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rrAvPgRrohANHyT7hdY7z+O8aQ4K1pdWWyNquNpNJ8=;
	b=pxo22zmpS7eZvXxQlZQ85sY0cFvDqgq4a6WRNe9rOOKwBqJ7UFh9unJi/teUiC+oeij0hc
	NDKv9w0UEBk89e0lI4SmisFhtiK22/QMOvHEL+DvVEW8mOBZNSzs1/rx39YUg2XDI47MVQ
	Ax3DtQX0SfjneMDcOAfgS2oRgmwaOdE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mokf2unt;
	spf=pass (imf14.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786372551;
	b=Eg+yfOzQUVldskfsdyR9f4zrbq+dyMf53LIhtzZqPOEErHyGEknlq8etfITnZeWWzhoyCG
	q+sEdCnatFvUDn5r6pjMLUVPDqWgt1TXOn77IYrX7b8QOy9kQfi4LniAi5GTze07abw6UU
	VVf5hqOXLh13MRm1o3rOEczeLzT5JZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C1643D1B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE021F00A3D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786372550;
	bh=5rrAvPgRrohANHyT7hdY7z+O8aQ4K1pdWWyNquNpNJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mokf2untmLnI3fXVkZl9R1TO+I3D6j3AGjfvZwlTjVihK2ebOho2oQYup6uW9rOtJ
	 ImXvrtxVu0Xd4nsZKmwB6BqLwDEpy7Rl/+PPEzC4UFFM+NUR0ljJB9JsFTVCvsSZKf
	 cVNj8v6IBepszhYaAdBd7rrMrYOUeqJOZdB4pBHj5VPk2FaMAsepKXFAPYgBQKtTv1
	 kvMMNBdFm54k5NusUJR9CltM7nilqfNZ0Y6bjhbdu0ttPM5ZAo5TMeSqd+qZyTPRjM
	 Yjw9y/j2HOh6NyXhEDTPUV3kda3hc3Z63LKyCZRgDia2v6J6v/nAMSC8FBzsMaagHq
	 cW4vCyK8OiTPw==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so1838732a12.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:35:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro58dLhzjJOK68lfkAMn6bJ9YJle8BmQuXBQ6IORk7AOxrXzzGV5X0KL8+Hp0DGYCCLx4KGBpE4lA==@kvack.org
X-Gm-Message-State: AOJu0Yz8ewHIMOQ33/soPSt+fiPefLLCC7Zsb8lVKNMvzUIJWPJnn2NF
	VU6EEFg4y65kgx091kfrCfS+DVeRO76IkRBCDwVxHciY65+X/0nRSs8utMQkFIrIKiN/USlrCsy
	J8rb42d7N7v3YyU7BSzbQJUd5H8Fl4Zk=
X-Received: by 2002:a05:6402:190b:b0:697:e953:d14d with SMTP id
 4fb4d7f45d1cf-6a1b4b9a7c9mr14019689a12.17.1786372549348; Mon, 10 Aug 2026
 07:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260807103714.33074-1-dongtai.guo@linux.dev> <20260807103714.33074-2-dongtai.guo@linux.dev>
 <CAAhV-H4xxPXVRNXP42CBtMdVXbBZ4E6A997jZmw7HpEUSFAj9g@mail.gmail.com> <96bd0e57-b517-4008-905f-9860661afaf2@app.fastmail.com>
In-Reply-To: <96bd0e57-b517-4008-905f-9860661afaf2@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 10 Aug 2026 22:35:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
X-Gm-Features: AUfX_mx7myO5n6AdZGyKWT1euUf6zZnDQmB3Nd8fohz-ozaccG8I_T8jUbfMATo
Message-ID: <CAAhV-H6UufWevaCds851xSxEMLeLcq+8wpoWq8OyeXib25GEUQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] efi: add a KHO configuration table GUID
To: Ard Biesheuvel <ardb@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>, Mike Rapoport <rppt@kernel.org>, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, shuah@kernel.org, guodongtai@kylinos.cn, 
	WANG Xuerui <kernel@xen0n.name>, graf@amazon.com, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8DDE100005
X-Stat-Signature: u4phm4fcqwnobr1ys6bp59363e3jkufj
X-HE-Tag: 1786372551-984163
X-HE-Meta: U2FsdGVkX1+N4lJvKWoaIV/6GkuDKbVkP9bbLtjPjecGIahL2ut5SJ7xWqU7fMBfHkrxsRj35Bf7cKW+A1rXbRBW+GqnhQQ/TKyCiHuDF0NZCMaLEU852F2pM/lkQrI/MSVfpJpVqvdVAIuscpFbTGDvwKSeOkorZ/c/5kslLr0s/1itOhPV7yZR5noYnjalPcEB2IDF2yAwIMHDlUbamKQo7brIbQbH14XUMg4kI9K9yKjjtLJ5d8mFdfcGA0RDLniCNQP1gRPx6zAZMNouvme2oJAK1TKOIx8ofTLiQ0IZmqWZ9rCj/aHCS5K0QUj1uJGbENW3ruCcW/ynumL8Gj4Inbj6bcN3+sO4aeECiRPYvNKD+RnP/Vvls2ZLhmQ2XfMSSKlZ3j9M4tyTVXrI1Bx2BfxRT5w6ObkM4Kp/xHND/wO3KMH0S45Er//v2nWtqOI3y0EYJ0Bd7tCcZCMbtUw0E4TfyiWyULQ5ezClLJuoFsTpsMJqPr8M+w+7yfyX4P9HV2l0EJYUiGaq/N4urMqt17uPHQ4b8yNeZd87+qcSYqBzkKPCU3HQquuBGS5xdsADWUNgyWEJEoS3e9KK35quALcqBW9z+uqyfyC+C8ava0veau4L4hjoyWDnzg+tTBwf/1Xg3cTjr+pTvPtexq0tyr2lJcQObw4q+VmJLeBwRtZSiLlN1Qj4hvnVSeShGtDJ6YBX6gZjG1daEjzC5LzRMjsP+WMacDIgOXFGmOBVr8Pk2i09cY/fpkD/DvxWxjHhMBzwicypSpw/kuZ42g7lf2wuJuo/KhhIH1m6tnP88wBr3IbhC9l9dMQEcjIP8q7u1PLZ8uGg0RGyuAKcUR/A7JNHpjZV8I/96W74lhSemy5CuKUGtmx55H0s1C4ID10gHTb8muT64zQCzay98DVNRjy3S3wbM3z5UTk1ODUrdkWKBQjJrFqe5hZd23sefFCZAC9S8a7++R4AH3a
 6SGdD4MY
 LNrmNCANwHNx/oJp7jHubuSLR8JiHFyjU6fh3zRWRlkE/4JToq6Vg+qSKuJJgbV1KE858G8i0+Yblm95MB0j5BIYS6IYQxqYY1/d/AlxI4mV759f0fIiaSLloRuFEINySqurlkmXTrnRdEsYe/08rlfEhnW4vGMJA4lk4PGsrrL6ANpkwdN75qBliQsOQZiinc79UhSSfisad8YE6+CMxPBWcYOvvqD2BaTbjjsXzHXZreklymcoQr5d71v970WSdkEGi3BleJ2cUfKTmmuQzFa4sCkcM8LkSAE4/0v30wfXcqPmCff9E3bZaSuixIQnflVQgb1HF9enNEXJ1fR4xZyrqwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 9:14=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Sun, 9 Aug 2026, at 06:18, Huacai Chen wrote:
> > Hi, George,
> >
> > On Fri, Aug 7, 2026 at 6:38=E2=80=AFPM George Guo <dongtai.guo@linux.de=
v> wrote:
> >>
> >> From: George Guo <guodongtai@kylinos.cn>
> >>
> >> Kexec Handover (KHO) passes the address of its state FDT and of its
> >> scratch area from the current kernel to the next one.  On architecture=
s
> >> that boot with a device tree, the current kernel writes the
> >> linux,kho-fdt and linux,kho-scratch properties into /chosen, and the n=
ext
> >> kernel reads them back in early_init_dt_check_kho().
> >>
> >> Architectures that boot through EFI without a device tree have no such
> >> channel.  LoongArch is one of them: its efistub passes the EFI system
> >> table and the command line to the core kernel directly and never creat=
es
> >> an FDT.  x86 has the same problem and carries the state out of band
> >> instead, in a struct kho_data in the setup_data chain of its boot
> >> protocol.
> >>
> >> Add an out-of-band channel for EFI: a LINUX_EFI_KHO_TABLE_GUID
> >> configuration table entry, under a randomly generated GUID, pointing a=
t a
> >> struct linux_efi_kho_data.  The
> >> current kernel loads the structure and an extended configuration table=
 as
> >> kexec segments, then switches the EFI system table to the new table
> >> before jumping.  The next kernel finds the entry by GUID and calls
> >> kho_populate().
> >>
> >> The structure carries no version field.  An incompatible change to the
> >> layout must use a new GUID, which is the usual rule for EFI configurat=
ion
> >> tables.  The handover payload itself is versioned separately, by the
> >> compatible string of the KHO state FDT that kho_populate() checks.
> >>
> >> This patch adds the definitions only.  LoongArch is the first user; an=
y
> >> other EFI architecture without a boot FDT can use the same channel.
> >>
> >> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> >> ---
> >>  include/linux/efi.h | 24 ++++++++++++++++++++++++
> >>  1 file changed, 24 insertions(+)
> >>
> >> diff --git a/include/linux/efi.h b/include/linux/efi.h
> >> index ccbc35479684..789ab9e4312a 100644
> >> --- a/include/linux/efi.h
> >> +++ b/include/linux/efi.h
> >> @@ -422,6 +422,7 @@ void efi_native_runtime_setup(void);
> >>  #define LINUX_EFI_COCO_SECRET_AREA_GUID                EFI_GUID(0xadf=
956ad, 0xe98c, 0x484c,  0xae, 0x11, 0xb5, 0x1c, 0x7d, 0x33, 0x64, 0x47)
> >>  #define LINUX_EFI_BOOT_MEMMAP_GUID             EFI_GUID(0x800f683f, 0=
xd08b, 0x423a,  0xa2, 0x93, 0x96, 0x5c, 0x3c, 0x6f, 0xe2, 0xb4)
> >>  #define LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID    EFI_GUID(0xd5d1de3c, 0=
x105c, 0x44f9,  0x9e, 0xa9, 0xbc, 0xef, 0x98, 0x12, 0x00, 0x31)
> >> +#define LINUX_EFI_KHO_TABLE_GUID               EFI_GUID(0xc941b6c7, 0=
x7b3f, 0x4af6,  0x9e, 0x50, 0xfc, 0xb3, 0xa8, 0x86, 0x8a, 0x17)
> > I don't know whether it is allowed to define a new TABLE ID while
> > doesn't touch the UEFI SPEC.
> >
>
> That is fine in principle: the whole reason for using GUIDs as identifier=
s
> in UEFI is that everyone can invent their own, and the risk of conflicts =
is
> negligible.
>
> All LINUX_EFI_* GUIDs are Linux inventions, and are not mentioned in the
> UEFI spec at all.
OK, then I think the direction of this series is correct now, and I
hope there will be more archs share this GUID.

BTW, I think LINUX_EFI_KEXEC_HANDOVER_GUID may be a little better than
LINUX_EFI_KHO_TABLE_GUID.

Huacai
>

