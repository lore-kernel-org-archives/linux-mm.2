Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA3DCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 17:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2096B0095; Tue, 29 Sep 2026 13:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C923D6B0096; Tue, 29 Sep 2026 13:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BF46B0098; Tue, 29 Sep 2026 13:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C57C6B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:33:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F5B71205CD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:33:42 +0000 (UTC)
X-FDA: 85267497084.29.A8C3AD2
Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE06A1C000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:33:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Y5mWt+d0;
	spf=pass (imf18.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.128.226 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790703219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+B7DqXhhvj+xVqXComGurkMjL1zY7LiXD8G593LXtY=;
	b=wwAdMIuA32svIcBX0Dj7M7zko+cVGY4KYQ2KqqGMFvG6BR5vwFXdwtqfELOpc+b2xV+Scj
	na0In4nQ22z2SiV9MDXuLOF4XrykPWQ+hoFlCFyntG7O4sTQ1/OqlGrZF/+ViIogBQ1CtH
	1b/R8A3pHg4JQeQPET/iusR/l29uucQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=Y5mWt+d0;
	spf=pass (imf18.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.128.226 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790703219;
	b=ZnWTyAm7swTuOWbxEBWvFkU5SmlOj7audG0LSxNtlj2AzuWyry+r3ryt05xJEQCGfnvAJp
	j5gKHlowKEsiY2CsVu6pZCQRES5KcySBVPYoqtdZt1OCdIHZyLTLeBErWzviMVzu8Sp6Sr
	f4K5ciATrHh1XhEE8LoHmSg53HDig1w=
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-8abd68b3937so429027b3.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790703219; x=1791308019;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+B7DqXhhvj+xVqXComGurkMjL1zY7LiXD8G593LXtY=;
        b=iBVMdpee0PnobbETsHyv+rHdRfXcgtfy79wob8kbIMNtv+h1ksl4+Y5HEy43aKHmy8
         LTTmh5toDjIjMv3enBqdydtpx5KoZ0VcITHgMShLvWU1DW7PqePy9FjBXrSq3Enlk/fj
         +Wp3/tqvz5WTtNU81Qtv+VDISqVMtkNGPvRnswcsdXwPMWc12WRy9Pj76eev8YbnVvTJ
         OjKcWT3bwCHeRKx7IHH6qNXAR+wtMGpV8mO+d59Ld4Ok4kXG0TfEc/3DyjHi1yLNKBxJ
         bh3R0fjQvSFC4O15TVHj629WgWMnq0lSZrU2iw4QUR6IWxq1HyFwZlPbI9afbQu7sQmX
         1p6g==
X-Forwarded-Encrypted: i=1; AKwUvBzN+Ocx+SpI8FFmBiSjdiPDJ4mSL5vOst1zf25Ao6Ffcn3rlTkQZtZ8NMw3NKd1FWb0dJftmiLiAQ==@kvack.org
X-Gm-Message-State: AFq9FYLJpBkU0GgvwW2zJOQCfhkIaE0y3cYsI3VA4Bxl7SzrIFxOZBLX
	9zmvV47IfwWpVLowtZSYI8QtfW/cSY/gKCtQIJthgdvkc/ysNxqmpUHtHDuIA4M3c/Fpw9KNScn
	sa0nmGc51NHhSvbMjLE5QM8MkxqCoD5UHnelQ/dt4omw4DmdbU2Wg9G7Izl3i+9OeDXgLiDXa9c
	AZtzIdTC8P1A+Zg2xZUleQSW+dsDfM5oysiBfqBcjj5Wpsq/gXW9HdX3iCfikCio9BuNpJIsPke
	k0=
X-Gm-Gg: AYBFou0V13B2+Onz6BuMyyQ2fpGnp7nAKReiuoDgWJ4RMIRYG28EDxvEhUEbKTQKX+N
	NyOA6+r/6hQ8BTcs29oUAnv1FJ9cx1nXGxN1ffLQ4kpcr6/jsv7ZWKfo3pKvdZag6tx2e310XF4
	8o3g2A1CbX52xDlsFDdVNxYpoQaU/tTEOCx1zMwMmnm/XoiDcRkBmRJaWH2REuqVVKFXSVQGFvh
	zrPD8IA2oc4gtZcGTCN8j8w1r9S+usz48DUW0ta3EUFMo4cs5+HW3oTvVWrff6JFOOVO+d6fIx5
	Qym1KfI0So1zTqCTGtMtgMXsYo0x8d3s3EMlr+5mKIji8voHdBu6PJgtdoOLbDvNdGMNcyGzOtV
	sVPfGl94zXf+Zo705SHiXzS64Gjw5j5eW+xWtXkleETTyUMVCOFd66aYR9XdgnSGBjjt+nZh1gH
	dBDLinYzMGnVUHM3zYYPwKOcYo4oyi2ude
X-Received: by 2002:a53:a042:0:b0:669:586a:8673 with SMTP id 956f58d0204a3-672ed27bc88mr5759942d50.21.1790703218456;
        Tue, 29 Sep 2026 10:33:38 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-675b2800376sm94391d50.7.2026.09.29.10.33.37
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2026 10:33:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6aafdd5a5f6so4063442a12.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790703217; x=1791308017; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+B7DqXhhvj+xVqXComGurkMjL1zY7LiXD8G593LXtY=;
        b=Y5mWt+d0DqA0MRIISNYOsm9UZsogjmezN0Gv7xMZ6JOSFbvM/JCDpXQ15qaeBr28fm
         GHeZ+8Tfn70Eqip81bWSs+g6vj3fLauaNQPRmoG1VbHu8ppN8TqwgJ94em8bkvMBzQtn
         Xbk0nCeBwflirDf2Dc/EH14iajsTCd7AP/4dA=
X-Forwarded-Encrypted: i=1; AKwUvBzIUdphqU4y2y/oqmOXnJo7a99qsC0tKgXNx8Wh7ZkrhDAqrb+jxpyb1nNEWfH57G+qOJNTVV5z+g==@kvack.org
X-Received: by 2002:a2e:beab:0:b0:3a1:9562:732 with SMTP id 38308e7fff4ca-3a7716e854emr518971fa.1.1790702723821;
        Tue, 29 Sep 2026 10:25:23 -0700 (PDT)
X-Received: by 2002:a2e:beab:0:b0:3a1:9562:732 with SMTP id
 38308e7fff4ca-3a7716e854emr518621fa.1.1790702723256; Tue, 29 Sep 2026
 10:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260929040256.543767-1-zack.rusin@broadcom.com> <20260929053930.GEartPEjbZMpBVSvSk@fat_crate.local>
In-Reply-To: <20260929053930.GEartPEjbZMpBVSvSk@fat_crate.local>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Tue, 29 Sep 2026 13:25:09 -0400
X-Gm-Features: AclHuK9MtIFPSxXHWZMv2V63rPUuOwDojaWOanbSwfqwCxHPzt-TuhSiHt6biCo
Message-ID: <CABQX2QNmza+=i1FXgDtFS3e3O5oXxPZppRbRrL54P1LmrB2gBw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] x86/percpu: Share decrypted storage before guest setup
To: Borislav Petkov <bp@alien8.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, x86@kernel.org, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	virtualization@lists.linux.dev, bcm-kernel-feedback-list@broadcom.com, 
	linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Long Li <longli@microsoft.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Kees Cook <kees@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000272b7a065ca295cf"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE06A1C000E
X-Stat-Signature: uc96gnpqfhnw67up6gu1hidqkueqrxxr
X-Rspam-User: 
X-HE-Tag: 1790703219-425674
X-HE-Meta: U2FsdGVkX1/tnEPX81Lubhf2v6ITj/TOTMfHcM4fK0j+l/UH1KerIrU5lFYb9HzLIvk3W38AVAuRqPfKR0ylGEihdZ84x+Nog+xmmDJqddPPfVm7xaxSNMEJQGjXsA6f6jEPtXekR9hduJU1Os6r5Qdq3FlvbJeuEQ6IeIYPg5nZTFqmXE9AQ7nR3o53MVqMAGicrRC79teTYbEHX+d5xZmaFyT3lmFnoUgDonp1fMhgazTmOihiQC3sBpshnaw7WrU1gOVGTFADcDSdgHt7i+WtsMqnlgYFwlMnQdNwyDO94UihWJMKC0HZc5wJcKAkAjRm+/yQ9GWZ46Tj0a8O4hF1knFD6rktB5Ed205swyU/GdzP+lIdMDkJGssRJUBjlcabqIzvaqAsstBNJYbaEKCR2HEpfNl/rxMdLUbfocthtsLy5N+i5pvMBH37kDfun7bVgFgxkWROA9NGSCNpifCSnhg5vfsRqcNN59GvpqgJIecucYLRN0G5D/ebbwhIjNjzNrC6uXWpl7BDgEbJUpWxMRSAyAw1Zp7UpHj5ip2Lqvw2JjZVVpikBd8Dbp7mwcMvdSyYyQ9qL2//WXhBbf/3X1oJ13ac1Hm5gcC95rn1upkzBDxdmHLZazFz1n2Xgzpzs/Ff9KSWXJO+zy9QosXHt/uVky81ylz31vXfSMVWZrBCVultYy9c2d7QyW2nUVWTk34PAV8lO/m6RSsKjqlKtix60ddgasVTxlFXtKROmUnwqLUXyR8sIk00dykXwn59M5vw71qlCYPUm4EzgZo9jgCFjNCNnGqkdfnrCk0vD2TARdMOFATQmmAQFjdB/L0UXggrUqHUjxLsl7uvSghmQvj61NpooF6zv18fdOcTDoTJzFup9o+C3LU2pHwlqtb9YNuhYAW5Q6nbxAr2D+jwQMl5Wt7bGBkWxhZz7XpkXPtOqwlpjFTC4xVSTtNVedhguZjbD2H0W0I8T9O
 1Fk7E9Y3
 BIxpjUH7yFmyITiJi8V2HnX/fGX1O59cefpZEL1MyWSBR7f5ooOgVvLn0ZxRPrYr9BouAyvsrMNZkH0c1H0QiDET6yroL8HiXZyDCn8eXBXsa7huCNx2C/W9Rn85FYfGml7iCAfBD01C+X1j5sx/sfFISwOvOo9HA2lvI1QHs1JGi11FvB9hf9mNH4Fqqint72RvfOuY/TcH7whoIYGv6AeRtPsHd4UeJ8ErkfIZf2C1O0p5g9ILdyjN4Fnd3KYXCBmCfTONq4tn977GpxKUwhq0osKoXiRUWKGjBBiJk7bzVj/D1Wty9XUB4tbz3UbD6G3a6fQ3lDV8ZCn8lFvG2HV6Icpt8Q16pc4Q72dxVVEYqu8sGAF/RY8ZEGND+Gw/fjBMjBAbjKOCnF7vBY5/Mg9WVqc/z9e4l+CpfNjN33CZ6OfuXRsbkaREIBz327fAKG84kKtd722wc/vy6AqJG1MwFPcrlQesbXCN2f7KOF00z0ESV8UwZBjblAqfVo+bT7rXzAT+Kr3X1Y60ck5k+Vex3HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000272b7a065ca295cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Boris.

On Tue, Sep 29, 2026 at 1:40=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
> On Tue, Sep 29, 2026 at 12:02:49AM -0400, Zack Rusin wrote:
> > VMware publishes its per-CPU steal-time GPA without first sharing the
> > storage in encrypted guests.
>
> So this one liner is the only explanation why this patchset exists, AFAIC=
T. So
> I asked AI. I'm pasting what it said below, at the end.
>
> Is any of it true?

Partly. So steal time tells Linux how much time a virtual CPU spent
ready to run but waiting for the hypervisor to schedule it.

For example, during a 100 ms interval, the vCPU might execute for 70
ms and wait for a physical CPU for 30 ms. Reporting those 30 ms helps
kernel:
- account for CPU usage accurately: avoid charging applications for
time when the hypervisor wasn't running their vCPU.
- make fairer scheduling decisions: base task execution accounting on
the CPU time tasks actually received.
- expose host contention: the st field in top and counters in
/proc/stat help explain why a VM is slow even though its applications
don't appear to consume all available CPU time.

The benefit is greatest on busy or overcommitted hosts. On a host
where vCPUs rarely wait, steal time stays near zero.

To make this work the hypervisor writes a running total into a small
per-CPU buffer in guest memory, and the guest kernel reads it. More
below...

> If so, how much and is that the reason this patchset exists?
>
> I.e., you want for vmware monitoring tools to work with CoCo guests.
>
> Yes, no? Anything else?

If options are binary then "no" :) It's not for monitoring tools, it's
for the kernel's own steal-time accounting above, which currently
doesn't work in confidential VMware guests. So the issue is that in a
confidential guest (AMD SEV SNP, Intel TDX) memory is private by
default, so the hypervisor can't read or write it. Any page the
hypervisor has to write must first be converted to shared by the
guest. Linux gives us the address of the steal-time buffer without
converting it. The hypervisor then tries to write into a private page,
which doesn't work. Currently ESXi deliberately powers off the VM when
that happens. That only affects VMs with the steal clock enabled,
which ESXi leaves off by default except for Photon guests. I'll
probably change ESXi to just disable steal time when a guest gives us
a private page, but that only avoids the power-off; steal time still
won't work in these guests without this series.

KVM has the same need for three of its per-CPU buffers (steal time,
async page faults and PV EOI). It already converts them, but only on
AMD and in its own loop. Kiryl asked on v1 for one common place that
converts all such per CPU buffers early, on both AMD and Intel,
instead of each hypervisor driver doing it. That's patches 2-6.

Patch 1 fixes an old layout bug in uniprocessor kernels, where these
buffers can share a page with unrelated data. The series also fixes
SEV and SEV-SNP guests on KVM running kernels built with CONFIG_SMP=3Dn,
which currently hang at boot (we reproduced the hang).

> And looking at your commit messages, they don't really talk about why the
> patches exist.
>
> And I don't think you know your audience - you're sending a bunch of patc=
hes
> touching arch/x86/ and you throw all that virt gibberish around like it a=
in't
> no tomorrow and you're thinking that tip people can follow. And I think w=
e can
> follow only bits and pieces but all of us will be mostly head-scratching =
here
> and probably ignore the whole set.
>
> So perhaps you should lay off your virt hat for a minute and try to expla=
in in
> an approachable way what you're trying to do so that even non-virt people=
 can
> follow.

Fair enough. I'll rework the cover letter and the commit messages so
each one starts with the problem. The series originally wasn't really
touching x86 core parts and I haven't updated it for a larger crowd.
Would you like an explanation of steal time, like the above, in the
cover as well?

z

--000000000000272b7a065ca295cf
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
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIJNP
S6jDImrUmlay9QeGHdRpWRIu9sjbDlG7nS4YLZLtMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI2MDkyOTE3MzMzN1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAA8zCWNhaEpuWRYMKXdPmschVWKCn6WVYNOpiS0J
NcjhQyOZmzj+fewFY9z8KHh47UemODMYpjaFYGH1xpOf7STFPyzkaqyyqJU042DjODdRMRgNhZ0D
ovSNnkqdM9qk9/sXA4NuOVedrTIrMn6iuLkhnHDOhQSHcZ4hT13qSK9ic+no5Z9GN7mrE02e6wTV
4Sr/h/vgwpboKIy2aTD+OkYtCE1OKMyTrpA8DLUJg7mgrpwJKxSe9XWmQ2UkCRSdTPo0+UKlmxBW
ZVYUSlBEwDm+6GKsfEGieDgU0f4xG1T8jL3OlgLTLSx7Nf59uYYciCEwgSwWtmEgD7UyEtzTfno=
--000000000000272b7a065ca295cf--

