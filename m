Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D98CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8C08E0012; Fri, 10 Oct 2025 04:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899A88E0002; Fri, 10 Oct 2025 04:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760B18E0012; Fri, 10 Oct 2025 04:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58AD58E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:13:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07FC8856EF
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:13:20 +0000 (UTC)
X-FDA: 83981489760.10.E3A6EF5
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1CF0414000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:13:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OWUeGoeX;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760083998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wM+C8meSFUf89iBos4e9b9ElmXv19ZrqBcY5kPeD/U=;
	b=FdxtoqczJ73DSHWr7mxfewKbHXVwL6GywcYe3NEC+d7vTZZDM7XpwugboeTrvW6xpnza20
	/SEHokDK/vECy/rugwY+QevadXTYlQDhzS9Df02yurFCulDFrU8NOiVSlZb/BJIq9Ycgwr
	O62CKSQWMGC7gPbU0JttbaiZnLg97Hs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OWUeGoeX;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760083998; a=rsa-sha256;
	cv=none;
	b=TbUl9feJDptYNLZuE1tQ90Xdl0vp548jz2aHatHKAr/hf3JhK2y/1qD+FmNfPcLF+IhP69
	xjS6vEqXxP4UpNOJEWZG8wBbjSzSc1AcbYZ57jqSdn42JN9uszRMLHKSoujGR7hgShL7YQ
	Dgjy0N5uCfIzJO6SwTRX/15vaKSRoNo=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-27ec3db6131so3547295ad.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760083997; x=1760688797; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wM+C8meSFUf89iBos4e9b9ElmXv19ZrqBcY5kPeD/U=;
        b=OWUeGoeXoxUjKav+xcLFPiB0Ch1Ql+D4AqkkxBvL+SPcpMIFkWggBF1vnuX8ItXW6i
         lkLVsEfOLaK6h83KflOHgMzVPWoBiTE/uhkzlsrNTp3pC3cUq6O2BtSrG/3mGRr+8PGD
         GfPTEmW7uHR/NdtyBnujSLwam+rCtObO7BmCPdiHtlarSjYP6sJOnjBgTfie6yE2U5la
         nXuY9aX1rgze/gr7A57EvMj/UmCQbNu+8Lh1/LxW+zi348Q/md1lVPKin75PPAlERx+7
         0G2cLaa2kxV+jHKF2nkbQsIrL/354DWiHYcb07jEFbqwuf+Pj/azSRWX5xkEQX4xCbKa
         t3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760083997; x=1760688797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wM+C8meSFUf89iBos4e9b9ElmXv19ZrqBcY5kPeD/U=;
        b=WRLe1zrIsNABd47DrznCGggPDijhqo79rqAJ6vwXYyMC2vcWpEVl829+CQH2E3rnrz
         VQeSiBfq5QIrA+HNGq7m2yJIU6THftdmC3U9O9V7MpPoYKMAT1ODmpWw0G7BxoWsQaSh
         jPMj9H2hCxi/Nnb4GdmOW/EKfaFCD0c3CT2TEr66lPuIG4GV104RGfa7kbZ2sKz94g67
         ofI/swxUWxuYzpUjsDEaE2Mro6bG+om3x4oBA8Ko4Ytig+NEuCOFFOQQymUxQC3KJ+gY
         mybEGIjqAoTPlbeEghlwYmMQjiMvWfkjoDV1V2vUI5ay7Y/RduSjmwqTAsxZI/YlN+fS
         1WKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVYALQRfNeUeZIj82o+4dOD2k9mwQxT8YyLBdKMSvCcIMNyLxIClt9faL9g52O+n0bINnBZQpHHw==@kvack.org
X-Gm-Message-State: AOJu0YwaNu2zOY6HjIHA2cAmIhah/CqgkPawS4NPBTw7CmzVqIHH+tsz
	AhzW37MWppIzoOqagjUSmdZ7gDgEW0FO1YLv5SscX5mPaMRamVZW4mdgGjQhUGRK9zSmGOZipEi
	dB7nElE8/Jkl5/yMp6J1yOF34qnWKlsM=
X-Gm-Gg: ASbGncu7DHu4Br8wZ5qh3ImKSR/SEY7X0QvqBnl+7kDhkoDMws5z3b5to1lGjr36Bq4
	joI50FME8Ur09dPbZcLUNJodL4H38RPWeP2GP1r/bo/ZcwtvpGxOEa7diX8Mw5ey6rZKGMpWuYg
	Na46k+isMVoVgyVa4u1Q1mFw0uL05Jmfzc/T6Ow+yYihjz5cPzJq14182iHy4qkayKNfMHSDfCf
	D6OguRvWGTuYQpfn97MVuCcexwQLlm3rc6VejJwACduZuxzPpHvfA3f5Ta1QFZIPK84TixfHDaf
	hcORZ3/GreLwuorj04xnOqOFz9irwrEx7GMSBWkeWPs4
X-Google-Smtp-Source: AGHT+IFdkga+t+zjNZdz4Z2XPhEtJNUAlFk/vUhhv9BDFlxUqeNhsotPLJ09GEKkawpw/ItDjLsilTqPl3STcyuQYOU=
X-Received: by 2002:a17:902:d4d2:b0:25c:9c28:b425 with SMTP id
 d9443c01a7336-2902745c0a2mr89160145ad.11.1760083996696; Fri, 10 Oct 2025
 01:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
 <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
 <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com> <20251010074458.GA91144@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
In-Reply-To: <20251010074458.GA91144@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Oct 2025 10:13:03 +0200
X-Gm-Features: AS18NWCKK8TWzVbSWJUkTcYGK_N5_ArO41xibbqihc9xfH2UWC9bF9H18mvQyqc
Message-ID: <CANiq72mzrJNTe6aw5zJ_vyhXO1jDR96hmvQEXPkqFj=dnwSnSA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CF0414000E
X-Stat-Signature: fgp9unpdyoskbedtqogeybrua171guaw
X-Rspam-User: 
X-HE-Tag: 1760083997-636586
X-HE-Meta: U2FsdGVkX187mgW4I95OIBWuN/IEHMu9LOoHrDjX/Si8nrNJ4JFLL7cw5Q34l0Pb9mWjVv2t0cRHwvMSn71jarSeotGLPJMt2/ZTgCVSacrWGSZTYCSiWvgdGxPgR+pGxEXVuyLDm5fQGzQI29M6YEhGFxFHRjVZFkuySTFO5uyNb2WzSd/A5vOIN2J716ltjOlmNboxjeTHWZb8C++7C6l24XiLy7RN6WMQ3KYHD9NibyxRGmQscGAaz/pjjtcomTBFJc6cAFrDi0Vzs4SCRforWnLVX+7mibTwEduWIIistnl2NPWX5O5lxBS2CE+JsVonnBnFM+WPeMJG6nznzQpNqM8LWL2zF1h3qx33JX8DROE7h3HHMXfOS4fCm41+2swaehC3FXFic2k/PX0rchsgFlFoGOX1VPyFjKQkvZDw4a4L8BJbR+0gkau13xGYgTwyjeMHd/csYGaJZUpLzmrMLXgTYlOtCNGTpGv/KOMDehEA+q3MBpWLTFV+HTjkqBBJcJfB7YkpHnx6cYZiam7mZnGLQNLMZ1n2c1NAhlcP8oHE7910qCm/SRai2wPVhmi1WVeIs/pkhYg7EcOTHyy4OSvICyhdWa4QMf8cLoD3WIAdH9+rpyxecjFNUzJaA0KZqUoW/Ns4jayEPAil3utnrLCEJUmL1bK2mxPDx+vsMFlZSZormL1R4IAg9OqFEGdvVyUkdsRnALKdORW6hBcIRlF/OYfSGPOGktfohErWghVNppgGZ6v0RVvox7rUYgC90fSXH+0G/Xj0JnvXqeJ0sophzrFoCe3K+hUy9CWNC7sSdwcoK8aR53ISE27n4JC5nd/WOfwAIsTJURogOD4Y46EDcAnqSif6BAN8edGBjWzWuaTMqT/FKhqCNpvaI6nRHGakYAP8P6+7t8YVJ/sr27FWLTeAqjnPoaykuxybEpXw1rl+UuAL5AutB4LdaehWUBWB4yiLvckAnyv
 9roouUXw
 K6TjPpxuCxjCPwYj5BuxgZoxbKSlCMyc3XjZqlrs/O4vcivACnECvm3j70rRCH6+3dJ1n7eizHJMa8w3vs/2049vnEaEgUZFMhK684WfglWvbDwOw7JBNgvgdWQEXtscXa4oTO0IIhZIxMMt8iNlfjRGvFavJ+4ajE8bOzRM3GdzTb0s1xNvfVjRgtj6zPxhdef6/7jQJbRUE7/tObrhpH1owXxfuN+F4BQfYhkoYv95pX4UeNXEhLI2iyhoDB5YWh+29om4MxmoPxOjdauw4q2ir2t14Hcv6/fbyqizVpFtHpAtrsX0KeSAEx7YHW8GW7z+CVaV/5tUIlvmaDEzxYUKzSWBlAPq+PVmCj7eYiQPdM7fHwcUJ9vWfyZDfFyoYG6FQho2OKcNSyre77KEGIOHjdB8VezIvooZbmhOpnCVxfB6xlFM57fXhLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 9:45=E2=80=AFAM Jakub Acs <acsjakub@amazon.de> wrot=
e:
>
> This is a tricky one - VM_MERGEABLE being `unsigned int` is only an issue
> if there are flags using any of the upper 32 bits. And if that is the
> case, CONFIG_ARCH_USES_HIGH_VMA_FLAGS has to be 'y', -> thus the enum
> will also have BIT(33), BIT(34), and so on. So from that perspective
> we're ok (checked by running a reproducer).

Ah, good, that simplifies things, yeah. A comment about the fact that
we rely on higher ones existing on the enum may make sense to add.

Or, even better, an static assert testing the type of `VM_MERGEABLE`.

> This ofc remains true, I'm not yet sure how to test that complication.

If we keep the macros, then I was thinking we can avoid replicating a
bit of conditional compilation elsewhere by blackboxing the zeros,
e.g.

    # define VM_SOFTDIRTY  BINDGEN_BLACKBOX(0)

That way we can keep dummier lists on the Rust helpers. But it does
look a bit out of place (though it is a smaller change than the whole
`enum` thing).

Otherwise, for the moment we can go with [1]. It is just a single `#ifdef`.

Cheers,
Miguel

[1]

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helpe=
r.h
index 2e43c66635a2..3c3a03051060 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -108,6 +108,33 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D XA_PR=
ESENT;

 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
+
+const vm_flags_t RUST_CONST_HELPER_VM_READ =3D VM_READ;
+const vm_flags_t RUST_CONST_HELPER_VM_WRITE =3D VM_WRITE;
+const vm_flags_t RUST_CONST_HELPER_VM_EXEC =3D VM_EXEC;
+const vm_flags_t RUST_CONST_HELPER_VM_SHARED =3D VM_SHARED;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYREAD =3D VM_MAYREAD;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYWRITE =3D VM_MAYWRITE;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYEXEC =3D VM_MAYEXEC;
+const vm_flags_t RUST_CONST_HELPER_VM_MAYSHARE =3D VM_MAYSHARE;
+const vm_flags_t RUST_CONST_HELPER_VM_PFNMAP =3D VM_PFNMAP;
+const vm_flags_t RUST_CONST_HELPER_VM_IO =3D VM_IO;
+const vm_flags_t RUST_CONST_HELPER_VM_DONTCOPY =3D VM_DONTCOPY;
+const vm_flags_t RUST_CONST_HELPER_VM_DONTEXPAND =3D VM_DONTEXPAND;
+const vm_flags_t RUST_CONST_HELPER_VM_LOCKONFAULT =3D VM_LOCKONFAULT;
+const vm_flags_t RUST_CONST_HELPER_VM_ACCOUNT =3D VM_ACCOUNT;
+const vm_flags_t RUST_CONST_HELPER_VM_NORESERVE =3D VM_NORESERVE;
+const vm_flags_t RUST_CONST_HELPER_VM_HUGETLB =3D VM_HUGETLB;
+const vm_flags_t RUST_CONST_HELPER_VM_SYNC =3D VM_SYNC;
+const vm_flags_t RUST_CONST_HELPER_VM_ARCH_1 =3D VM_ARCH_1;
+const vm_flags_t RUST_CONST_HELPER_VM_WIPEONFORK =3D VM_WIPEONFORK;
+const vm_flags_t RUST_CONST_HELPER_VM_DONTDUMP =3D VM_DONTDUMP;
+#ifdef CONFIG_MEM_SOFT_DIRTY
+const vm_flags_t RUST_CONST_HELPER_VM_SOFTDIRTY =3D VM_SOFTDIRTY;
+#endif
+const vm_flags_t RUST_CONST_HELPER_VM_MIXEDMAP =3D VM_MIXEDMAP;
+const vm_flags_t RUST_CONST_HELPER_VM_HUGEPAGE =3D VM_HUGEPAGE;
+const vm_flags_t RUST_CONST_HELPER_VM_NOHUGEPAGE =3D VM_NOHUGEPAGE;
 const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;

 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)

