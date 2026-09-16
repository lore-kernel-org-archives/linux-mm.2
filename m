Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F145C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB106B008C; Wed, 16 Sep 2026 11:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79136B0092; Wed, 16 Sep 2026 11:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982B86B0095; Wed, 16 Sep 2026 11:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44EDC6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:41:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578A01A0787
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:41:41 +0000 (UTC)
X-FDA: 85220040402.23.A788986
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	by imf08.hostedemail.com (Postfix) with ESMTP id 133BB160013
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:41:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=fzVd5DEh;
	spf=pass (imf08.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.99 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789573299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=514YjgdJRrYAyC7L0v47cSPNxTqa23tF756JLZnIgaE=;
	b=jxGRMuvPmytwAMPAB21OjbqCEQLnOrH84KFp155YrjBc+AcIaV1sHhq3KsYztKWjthvLog
	DtOLqq7lROgSkZFnY2vmLFnJuSswDvod+Vkcxegc/mGWOmqD3Fa6egCybPa3Vy8eeceGCf
	HAQTnGWtkOaQ6BPeWhgSSov9I5EdqyM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=fzVd5DEh;
	spf=pass (imf08.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.99 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789573299;
	b=zaTGER3MFWjlI3d/8WkJgSdX0qHCTY9SP3cwDc67PifRJFidS0JkpqPDqo7zMVqQIj5aa9
	Sq9psOeymTFO3sxCsbwgL1eo+dYEvsPPq7GGi1GvD4pPZjD9XheOW1iwOWdrHGiFedr01P
	E0KE9yiqVrrdLk3vcaJWXnMCxgWgJ00=
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so4424488a91.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573298; x=1790178098;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=514YjgdJRrYAyC7L0v47cSPNxTqa23tF756JLZnIgaE=;
        b=03E2G4wWE28ojM7hg0Bck7fLIgRrtzvU8upG5xn7aSRH80HAdfml4o8vPzdXxIEQNi
         iY7/aDYADlpj1heBVOLsdEqe6aez/WhGPl8Ns08m1RDghzKKxoUlU9IdTxe4bQzJGOEK
         aSOgfSzuqoH5Jib3XNnxad0adkxUEvAMTiW4yiJYzNDCJeBqUBSc+ci8+NIw2G2tEICE
         nvNKvtVYRJXIUnNJzn5/l3SO78lxGC916ESfey/bSajjjO9V3ntm7XxvAbjVkgkmBr59
         ix7kRlB6j/KaK2aPGJ9ohOOL9N5NwNun5ZMXo78vPHf1YOAKx9FkiykMVfrEPXXHpFOo
         4xBA==
X-Forwarded-Encrypted: i=1; AKwUvBxrW+3tmwj8/e+gdZt/QOaEIRRqwA13y2xLNRXUmBEH9kuFFr0iXO/B/Vnysg474/8KE9cq6g2qOQ==@kvack.org
X-Gm-Message-State: AFuF++mqd+vvvSInLZVNRvLSWZ+6QR6SYHt/rJhCZQbgc56+YQgGfj7z
	7LU7sipnfbh3fyBHAnyn4XIdL9KBDjdgu5K6J95KytOUUuY/6v6k/tmAC492svVxtsfdbAeREyV
	xAeXjuMrjv5qeR7jkyWhICWK26HEeuUQQSzsYj14qqJtedsmRxEgQl11bWJucBcleENoyysTJ6f
	/8Clw/8O199Y746dF8/3EJO/kEOzKEwhZvkSBwjdKJUm0r3s0uU+/KTIebYDXPg/qKLTeLPr49D
	zI=
X-Gm-Gg: AYBFou3MiqwEAOIKJHuCeH7Ig+Qz+aQFbxw5jNwyHS7CCX4/ia+igpcpWE2N0sS9vvr
	JPvHZ2r0mv2QpRYnqf1CtCVeT0wkLAmftiguPDuBB6pkTvRFTP7r0N6RCtViMrnYgYRhv/Y7L9I
	CI9vKypP2cwPRITtA6WYeVvtYhmNJyEvAjW6ZdX+oGvYtc0DBR3Xv8ExWbEIWxYqGuwZZ8RW7oQ
	aobi8jfNFTf4Mcsjs52N8YxaMnaMIyuq0GvRQu/9ClST2r4z5hy1OgxKr0/0eDFvrW+4L/rfPH0
	mvABD/kok9mVPyltkWAL9VUC0c0W/PpCfR+9ab7INW0ISRqdym1K8OsNyYRFCN793UvhGH3r72t
	A2fDFp8nJ9y8/rri+thDxpxKDv06n5GB5UnmulvBspcJ050A5tZbI4EewrOw69eH+clBIYauQ5g
	i+PT06bCASMhwP5fbNJWqI0zC/cRsAhbDM
X-Received: by 2002:a17:90b:578b:b0:39e:14db:4371 with SMTP id 98e67ed59e1d1-39e1e27a374mr6894734a91.1.1789573297302;
        Wed, 16 Sep 2026 08:41:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e35da787asm19454a91.1.2026.09.16.08.41.36
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2026 08:41:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a58fef21b3so22381751fa.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789573295; x=1790178095; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=514YjgdJRrYAyC7L0v47cSPNxTqa23tF756JLZnIgaE=;
        b=fzVd5DEh4YbXkR3besDtQdoka6WNyRUwCgD86KaDIgcqsOjKFlwCC5W3ET229/sPKY
         pCi6fzsQyIhX2cNIzvhb1GKeyuU7QuMhnLx20lC/v4RLTerwaNuWshwg/01tdQyN125T
         R+JKTWn/45FuxSsB2MpmyepxfbMEioV7cv2MY=
X-Forwarded-Encrypted: i=1; AKwUvBwK7CxQGMU7s4FWTZ8MUNura9HQk4uuGstN5lofeZCzLRWpFRg2xF6Rhnp2Im8wNl1ef3M6if/Geg==@kvack.org
X-Received: by 2002:a05:651c:222c:b0:3a3:42cf:c014 with SMTP id 38308e7fff4ca-3a5dc988ee4mr6734911fa.7.1789573294669;
        Wed, 16 Sep 2026 08:41:34 -0700 (PDT)
X-Received: by 2002:a05:651c:222c:b0:3a3:42cf:c014 with SMTP id
 38308e7fff4ca-3a5dc988ee4mr6734611fa.7.1789573294062; Wed, 16 Sep 2026
 08:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789488039.git.zack.rusin@broadcom.com> <aqqGUAX65s4LdJkr@thinkstation>
In-Reply-To: <aqqGUAX65s4LdJkr@thinkstation>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Wed, 16 Sep 2026 11:41:19 -0400
X-Gm-Features: AcwNN1X8EphbssgNJGAU5J8Ew6yzojuFKn8poYC7Vw-gA-ySadQxgIJcWpvSrQw
Message-ID: <CABQX2QMAfszf3z+Auo0AdwGsf94kTX0DrTrd8k6G1PTNMYsdXQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] x86/vmware: Share steal-time storage in encrypted guests
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, x86@kernel.org, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev, 
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000008eefeb065b9b8058"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 133BB160013
X-Stat-Signature: 48fjeymet9zmsaffi6kyobtb3n1mmgpc
X-Rspam-User: 
X-HE-Tag: 1789573298-80874
X-HE-Meta: U2FsdGVkX19mvcAVUzthUbBZx98S2zlBX0NXlWllU1+xtoNxjcLOXkTQmf6iuLQZanM6+4ao43AC4Ix6Q2XFsVCaB2gPHsgtoSava5e6OU56wTG3Bgox4B+ftyZItZTzp24BVmr84eqG6z+wnSyPNdX/Dny9yNPYfvORAyYjpSteo/ojpVXIyivVEQG7G8v2QxCsSM/Er/ZP3La7Idi+XAp86NoTKdeOZfg7xoHlej+JH1+Zf+B9vXFIJmqj2s2AQGrw2Iy3WynQZ2STIBaZEgLXLtHAx6kIOwsufK707bd+El7e42wOlr4FtErRCY4tbcXWGQW7TDYVawtLc2AbGHv4KgMIWRBQGdlSVaQqoF1VulUPpXwrSEYSZ7hcCQ6zTHy85TWnTq9hjKGiNrZ5AKtoT9h7mzGHRVUEPlmFK/UEQY9oGqd5JQmpfDFmGNw9xUROAcoL2x81qFsLNAWdKQG/Js+G0AQT88v47w8/mluKHBS3nboHPMps6Jra4dg4PRa5Pr49XZFD3j+G8RVFGuyoH6drASihaeln6l0CMHAUQGm9krvTc+/O0Yv6kSvHb/6+gq0YJTS59IvWNCuwTvXcBwZ14NukMYuVz4fiIEqNf1liqbMIG/gKRj2/GG2UNWKDZYyah15k3FgSTvr6Pr+EpgtTD95pwrVmZgAY5bWhQCaew9Isb5Vxwo978S4UO+5SCATIsw/E8YUn2gN797uJm7u4a7yqwZqYyDVXKvQ6IqBXbSSC4izdpWLoig3wdGygbmaCH3nzlb6K97FO72sMNaeD//yDlp3WCApgtjgxzJW6IWFvkV+djPZnRkKFCl1su9Rp155V3/KLXbPrugvf+SASnzhg+VKSGkqDedAf9C51gmA23T+pDq/FWitXq9qdQXrTTTv1/F1BOm5SlLUR5M5HAHPj04f4knsP/OwCgGy2yQjB3VEIlpHf2dAXM/NmmvRlG7ycjJWyl2T
 ruQbiQsT
 N+shI91bW6c9nvPV4zeObhoeijV1AH0OMhLbhyNavFDMW9xOdg1rzGb3utMD1NtjA4Crmdhh56NTbg5tQY7mtJSKtwG8mLh7KRPXXYX7fB9zQpAUIjUGVKmtKYklX/pYb4lFv/T6zEjJgBqxRxknRrDjbWd5Y1CKtGKQa9NqaewL8VzVGpHfqV7iZBs1WwXStO2YdKffouRJlHUoY0gqzPYmu6ttmhJXo07oKt9bptojT4EdDg/l0enMNdVajZ/6RRJK1wkAUKCBubzG7i38qwboIVk0ZKSwtMLWy9sGvZ5Y6nmIegLnlk+9BaFn3ajRy145wFfrxxeoDImUY9t3OenEfjD/PwoUin0DiIU5/5a/RB+v6wGdlSq41z8cClYtFCLuosPFw5tOFLngj/f9d1l8CqT6ilBooicFMCzuqCTqLi7HoO9yJBRiuSprsuQ2wKcxk4f3u3JOlXNE0KFG8yvvMpQhFT11HaOE6LI82IQUy5wwzdDLch4+x288DCQggpYfY5VHza2rWBMdq5tpOs5sQnyaUkcX14VOgrbWOiMWKe0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008eefeb065b9b8058
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 16, 2026 at 8:18=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> On Wed, Sep 16, 2026 at 01:05:38AM -0400, Zack Rusin wrote:
> > VMware registers each per-CPU steal-time GPA with the host. An encrypte=
d
> > guest must first convert that storage to shared memory, but the existin=
g
> > setup publishes the address without conversion.
> >
> > Patch 1 makes the decrypted per-CPU section available with
> > CONFIG_X86_MEM_ENCRYPT, including TDX-only configurations. Patch 2 defe=
rs
> > encrypted-guest setup until allocator-backed page-table splitting is
> > available, converts every possible CPU's storage before publishing any
> > GPA, and attempts to roll back all conversions on failure.
>
> I acked 1/2, but I don't like where 2/2 does the conversion.

I saw that, thank you. Since I'll be respinning v2 of this I can go
ahead and drop the unused DECLARE_PER_CPU_DECRYPTED in that one if you
want as well.

> A variable declared with DEFINE_PER_CPU_DECRYPTED() ends up in a
> dedicated, page-aligned linker section. The point of the section is that
> one place converts it. Instead every user does it itself: KVM in
> sev_map_percpu_data(), and now VMware in vmware_decrypt_steal_time(),
> each with its own vendor checks and failure handling. The macro today
> only buys page isolation, not the shared mapping its name promises.
>
> The underlying problem is that the whole "decrypted section"
> infrastructure is built around SME/SEV and was never generalized.
> __bss_decrypted, early_set_memory_decrypted() and
> mem_encrypt_free_decrypted_mem() are all under CONFIG_AMD_MEM_ENCRYPT
> and implemented in mem_encrypt_amd.c. sme_postprocess_startup() converts
> .bss..decrypted only if sme_get_me_mask() is set, so a TDX guest never
> shares it. 1/2 moves the per-CPU linker section to X86_MEM_ENCRYPT, but
> nothing that would act on that section follows.
>
> Rather than have every TDX user reinvent the conversion, I would rather
> see the infrastructure made vendor-neutral: boundary symbols for the
> per-CPU decrypted section like the ones .bss..decrypted has, an early
> conversion primitive that works on TDX as well as SEV, and a single
> conversion of both sections at boot. Then sev_map_percpu_data() and
> this driver's loop go away.
>
> > TDX's conversion callback uses __pa(), so patch 2 preflights every poss=
ible
> > CPU and leaves steal time disabled if a TDX guest uses vmalloc-backed
> > per-CPU storage. This covers percpu_alloc=3Dpage and automatic allocato=
r
> > fallback. AMD encrypted guests support those mappings and are not rejec=
ted.
> > Supporting them in TDX would require a separate conversion-API change.
>
> Refusing vmalloc-backed storage on TDX is the right call, and not because
> of the __pa() in the callback. Converting a vmalloc alias means either
> fracturing the direct map or leaving a private direct-map alias to a
> shared page, and the latter is a guest shutdown the moment
> load_unaligned_zeropad() steps into it. See the comment in
> tdx_early_init() and the earlier discussion of the same idea:
>
> https://lore.kernel.org/all/xqi2bkulnhen2vax5msbzczlaywx3dsc7ezpn7oo5qn7u=
7xzap@xmaseinov7tf/
>
> But that decision belongs in the same central place as the conversion.
> If the first per-CPU chunk is vmalloc-backed on TDX, the decrypted
> section is simply not shared, and users see that, instead of every
> driver re-deriving it.

I went through the linked thread, including the dropped 2022
Quote-buffer alias approach and the 2024 netvsc work's kexec
regression, fix and re-review discussion. I will keep TDX vmalloc
support out of this series and correct the explanation to cover alias
consistency, direct-map splitting and load_unaligned_zeropad(),
including removing the suggestion that per-page GPA lookup alone
resolves it.

After tracing the boot paths, I think there are two distinct pieces
here. The SEV boot GHCB needs .bss..decrypted before BSS is cleared,
whereas the SMP per-CPU instances do not exist until
setup_per_cpu_areas(). KVM then registers its boot-CPU per-CPU buffers
in smp_prepare_boot_cpu(), so the common conversion needs the early
primitive you proposed. A shared early_initcall would be too late for
KVM. The UP registration path probably also needs handling separately

My suggestion would be to do one of two things (or at least I think
those two options are realistic to me, given that I'm no expert here):
- add the central per-CPU infrastructure and migrate KVM/VMware
together, removing both loops and putting the TDX vmalloc rejection
and readiness state in common code. Would you and the KVM maintainers
be happy with that first, and generalizing .bss..decrypted separately
while preserving its earliest SEV setup? afaict the latter also needs
to broaden the annotation and linker guards, and changes kvmclock
storage and sharing on TDX-only builds.
- a smaller VMware fix using a separately allocated, direct-mapped
page per CPU while the common infrastructure is developed. Using the
normal allocator would also defer ordinary-guest registration, unless
I kept their current static storage as a second path. This option
would retain caller-managed sharing and buffer lifetime handling.

The second option is, of course, easier for me, but I'm happy to do
the first to get steal-time storage working for us. Do you have any
thoughts on this?

z

--0000000000008eefeb065b9b8058
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
6U6qgI8F5eiKsQyE0HgYrQJx/sDs9LLVZlaNiA3U8M8CgEnb8VhuH3BN/yXphhEQdJXb1TyaJA60
SmHcZdEQZbl4EjwUcs3UIowmI/Mhi7ADQB7VNsO/BaOVBEQk53xH+4djY/cg7jvqTTeliY05j2Yx
uwwXcDC4mWjGzxAT5DVqC8fKQvon1uc2heorHb555+sLdwYxAgMBAAGjggHYMIIB1DAOBgNVHQ8B
Af8EBAMCBaAwgZMGCCsGAQUFBwEBBIGGMIGDMEYGCCsGAQUFBzAChjpodHRwOi8vc2VjdXJlLmds
b2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3I2c21pbWVjYTIwMjMuY3J0MDkGCCsGAQUFBzABhi1o
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMwZQYDVR0gBF4wXDAJ
BgdngQwBBQMBMAsGCSsGAQQBoDIBKDBCBgorBgEEAaAyCgMCMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwQQYDVR0fBDowODA2
oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMuY3JsMCIG
A1UdEQQbMBmBF3phY2sucnVzaW5AYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8G
A1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBQNDn2m/OLuDx9YjEqPLCDB
s/VKNTANBgkqhkiG9w0BAQsFAAOCAgEAF463syOLTQkWZmEyyR60W1sM3J1cbnMRrBFUBt3S2NTY
SJ2NAvkTAxbPoOhK6IQdaTyrWi8xdg2tftr5FC1bOSUdxudY6dipq2txe7mEoUE6VlpJid/56Mo4
QJRb6YiykQeIfoJiYMKsyuXWsTB1rhQxlxfnaFxi8Xy3+xKAeX68DcsHG3ZU0h1beBURA44tXcz6
fFDNPQ2k6rWDFz+XNN2YOPqfse2wEm3DXpqNT79ycU7Uva7e51b8XdbmJ6XVzUFmWzhjXy5hvV8z
iF+DvP+KT1/bjO6aNL2/3PWiy1u6xjnWvobHuAYVrXxQ5wzk8aPOnED9Q8pt2nqk/UIzw2f67Cn9
3CxrVqXUKm93J+rupyKVTGgKO9T1ODVPo665aIbM72RxSI9Wsofatm2fo8DWOkrfs29pYfy6eECl
91qfFMl+IzIVfDgIrEX6gSngJ2ZLaG6L+/iNrUxHxxsaUmyDwBbTfjYwr10H6NKES3JaxVRslnpF
06HTTciJNx2wowbYF1c+BFY4r/19LHygijIVa+hZEgNuMrVLyAamaAKZ1AWxTdv8Q/eeNN3Myq61
b1ykTSPCXjBq/03CMF/wT1wly16jYjLDXZ6II/HYyJt34QeqnBENU9zXTc9RopqcuHD2g+ROT7lI
VLi5ffzC8rVliltTltbYPc7F0lAvGKAxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBD
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEING+
tS9jluKZG2ayZ4pYr4+TXQr15tnm2U0384jZyaB7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI2MDkxNjE1NDEzNVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAiJiiMRjpbhErRjga91uv6fyg7gDKiW/hzIZv4u
twci6FZEZWPYJYzwugbWz8tTef7pmY99e2ozuPN8cvLqjnDD9CdmDOA1oKFiKeuhTxMKrmsdFxUF
A/zaoj8Hh15JhRNwQB/Hn6JooqcOmUZINDYEDse+KmMcxuCsMi2D7N2/2bOB9PHl/2uBiCZ9NiEZ
8LmqSKB/hjxWSvkm/Mo6WmsPYtekjp5MRu5wYBMZQMyPCnQKGpZMzVOUOG+THnEj5pJvLhzj6pvT
nOEp+MloSY9rk0lmdMFQxK3qy6ZXjKFT1dUSwPdfPpSmc6WHa5huCNvC0hBo8Pn3HvKrY0Xmtgc=
--0000000000008eefeb065b9b8058--

