Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5D2EE020A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C306B0005; Tue, 30 Dec 2025 10:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244086B0089; Tue, 30 Dec 2025 10:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124EB6B008A; Tue, 30 Dec 2025 10:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0281D6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:04:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C68FE1601D2
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:04:19 +0000 (UTC)
X-FDA: 84276458238.25.4653772
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7A63C0019
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:04:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8IYaLVu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767107057; a=rsa-sha256;
	cv=none;
	b=AUoyuK1lELcUpxRcsvyzQ8d5B+HcNNOvmxVpA9N/mstnlHWXf80uRvmi9n7uGfMzG4Llgw
	7riR8femXJYUTAM3thvewrXq+g/V/A3o47g7XmqZPEc79TiNG44tPpbnvdOk5j4HdhjV8x
	LYFLliOOK8RvUjXuGUNsv8MiJtkPGLU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8IYaLVu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767107057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XEZ16r/np+0BpHZEzmtxDGM0fdTpCICHyYjlfdyoeQ=;
	b=UlzH3BD1yxirArQz+3fADNaJvCLovaYZus9EBmcfPCT4HQny/wb8z2Mp0G0O7G5RAHcRvp
	UsuXA6V7f7Ncu2/oaP7nzaEGdCRj5CKiGz78hoQFOc2JJ59Nfn61YmmhBAYvCesYhXPI0J
	mgNOENuGjtOVi7WwVQAevFJV6X7WPVQ=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64b4b35c812so13846209a12.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767107056; x=1767711856; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XEZ16r/np+0BpHZEzmtxDGM0fdTpCICHyYjlfdyoeQ=;
        b=R8IYaLVu6W2ug7ERbeGwwiqXklILEWNEHvhiD1UpA+ZJKGBWKyjSJeH20ZMhiTGcDz
         yA3vH+ass6f9RwPbIDbeSwA7G+xX5IAGHR93k/LdeTJAGrKuHCIBEG4AOFnS5nlZfdg7
         P+EFNptmSddzJgV0QiNkdDL2MBkCmt6YZqQs5cTvcLmPWsPx1TV6Gv4iR0MbGQ4tZNgu
         k6d+yibAQidTW5XUrwFlbg+iuBWv/uuvR6TyTEnz+By7uFVfbLtTqYIJjeRhxvNDba8E
         /npYUbQ9DT3Pv883RQTTQbEd+zzUg2+V81f54RU3DEiJLSD9p55iBQrDQL90hWH03Pw3
         d5dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767107056; x=1767711856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3XEZ16r/np+0BpHZEzmtxDGM0fdTpCICHyYjlfdyoeQ=;
        b=eOOl6kL4HoQqpH2ayXLD26VEUwqW9uzK9epqLsqzR84JtGsvkTmxJ/U8Ewy2XhDhYb
         pwXN9WFk+pX/NLTao4DvAwk89Sh2OiIsHTSYfp6C2HTodHi8pzZKlQDoWYgGIaZLhH5c
         VXUsTQ1DVI+RtiGHd0+tu3BxTStFfCnoGqBKxzSNNM5LyUEkcTqNVfitow6EECqVEm7R
         RSOMpqEaohNyvAC9o57SnWn8K7oTfv0KX2H2M4Bp69QjgWDnFtiQ8d2HRp1CysOYoerO
         MtCn2LLUwUfXx6T8rjw0yYnI2R8G1nB7u/QZATwjfyZgA404gHqusrLqTxSBsihlsGC2
         v4Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVGy2GeiddFgKP41J0GYCv+RcTszNC8upzu5kefVgo1B5Uj5JaOuy6KZy17VhkA6gW7++de/3lJZA==@kvack.org
X-Gm-Message-State: AOJu0YxyVnfkJ9GXGPFvoGxJG/MraIe4eCu0SVx5VsH8aY7/w13IiLBW
	DFq2kW8nyZfq/QqDHqvPUZsoLUi3djZSBHmOEiCiRyEaAw+cQIrKVRFgRFfTiGh6VYmAXtexY+o
	My403LCofTLxF3tM/y/ADFLq458VKMerx32xXE9R8qQ==
X-Gm-Gg: AY/fxX7U1YvU+71gQ6fr1iHxewQJFxVRzzWt8cqV69t5WD4G73skKyHkvbmVr/mRHCr
	3PR0UlWUGe4NQ9nlNTHVjuQ5WhzVIAiuntOqYDg62g9iMmrDEzXJ3neOzP4PRZ3PMjjQ/7fx9IV
	Tk2/eIh5PI5czMg4b/xQN2iiXbLwlkhXd5GXBlWHc4TCy6+x/xuMVerE1CWV5AmCIsppb41gLkK
	htFjNkGenEwkB4NAdbJgZYCMID4m2ibOd1kyBn8IJPcWTOAAzUMjsmHpPYGU9f6xRZOnXSIkwjc
	QtXnHLDu2ARK3G2qG5pID0kPpw==
X-Google-Smtp-Source: AGHT+IHQMNdZxKpFplxLNEZDOJPbPyGwfr/HlkFZY36RmkmAFCMov8zhCujR2fQsSGMcUi5+FxSA2oJ6tr2W+Ngwqlc=
X-Received: by 2002:a05:6402:1d53:b0:64b:654f:8738 with SMTP id
 4fb4d7f45d1cf-64b8e94bf4emr28321463a12.14.1767107056147; Tue, 30 Dec 2025
 07:04:16 -0800 (PST)
MIME-Version: 1.0
References: <20251230-kho-v1-1-4d795a24da9e@debian.org>
In-Reply-To: <20251230-kho-v1-1-4d795a24da9e@debian.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 10:03:38 -0500
X-Gm-Features: AQt7F2rG1eJ6wegbNUrAZYGhxgtB9GBYd5uKgFVrn4Rx6w8K7hySaB_w8u97UO4
Message-ID: <CA+CK2bDCKQrK3+6832Lxw8fZx_yt+8z0fFPdugC59p1zdSeSZQ@mail.gmail.com>
Subject: Re: [PATCH RFC] kexec: add option to print previous kernel release
 after kexec
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, usamaarif642@gmail.com, 
	rmikey@meta.com, clm@fb.com, riel@surriel.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7A63C0019
X-Rspamd-Server: rspam03
X-Stat-Signature: u4it7x5wky88egjg5jh3xmee49515aw4
X-Rspam-User: 
X-HE-Tag: 1767107057-504242
X-HE-Meta: U2FsdGVkX1++fAGjhB4DGzfH8zs4se2iXY8Y8CCgNmdDDpgqAgoREob2gaZxTG+0K5ThQiraHXmvebxZvWY0xs0mbQP7JbDpAOW6BJGeknIGAtn8wvOnojCjNr768s/9ZES3LsUydm6GVp6pTqRAr39xh8yNEUM10h0MGJzHhzlqRHx7WU+l0BIewdKjksB6bN+XtO1bolMdPyA+Q0ZEEkRs6l6Bu8HWj4eE6kGwJHsOdSKt4WECziOYvuKM1mqXoCbukci+6xmcffhPTv/FsYGGOw9rHxT03PUFI83XoqI9BsV3p+dsZUE/5B9pimlhaGwkWsuqxlBMR1d4SrH8UIcVfzu6cZr39IJWSUq+R/T2Ti3hdQ6nx3hHSyQbNXpD+KPTH1lDkdSGp1iB5UE+CECU3pGbne1EwfNEJiK4zP+6tt/PPNAsbnvkbrvmiw7oU/sDsqfOC89kljsNxr5SpBYVKXa5xKjESDkj8IRSRObs6R4K/xbrprfgjSmKCN9nXckFNwPiMYQtUhAGheS4EbqQdga80vCAPiCR+eRxkRbFbWzlVSkTc5klddePKAX/gdt/1oQBTzfHPuIVPo0oqqifvlpMZ3ZoJm0Xkna3CoYCI47mYSwgTS8mih0Knh/cn/910FpsGtCk5QEv8+k+tIxtDk6IqhSuY/76i0nQjtwGcevN2WcVr3qcz8sOmiiblz9QAJtBqws9VPC3Lky1R8IhYJKG6YNp3mEOwljB1UoNAxS9w6vk3y74YV6LCqtVb3aaaZ+f0Baj7D5flSnZFawTTgIQ3GaLZSo2HYJ0lgawN3wO54YOP92ALD15kA3AMEQa+U0LqImuOZGPjLvd8yO1cO/6mWN2uNlt0DxZzY6V/RKgBJa01AxhVnI7F5ZoAghxHJPHD4rny6I5WBm/cjaW1RDwJAu8mK/aO6KZB8jI97F68Clq3LdnEx7LS8fd3BttJxnTcbdCna24Bxd
 XyXedBKY
 /iLI4iP5JNHiQe88EOtF8L32wLwCLIjLZZubCJh+olD53Lq/jRTgc35Ttx/aqwDMPmb4CE/kWlBtFzC+8101aBqZe8oUZ2HA9c5tClPpd+NPhMEwIOrzafK6pIKJjACEIIjT1cdlRbj2AtLot0y0Jb591iw/tBd986In3qAAHk5zBXiTyKsrL//bHTnqe3VWO1dR2T+5/r4Tn4wZL3nNy4OBh+D8xWWIxrXBOQs9iV8rCIF7EePt5SEeVtDTnIWor02SptREqA82Ojb8DH2m+ZKZ3H717lquw61jqIpROCbw7jd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 9:13=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Introduce a new Kconfig option, CONFIG_KEXEC_SHOW_PREVIOUS_RELEASE,

I don't think we need a config for this. Let's just show the previous
kernel version unconditionally when KHO is enabled.

> which enables the storage and display of the previous kernel's release
> version across kexec boots when using Kexec Handover (KHO).
>
> Motivation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Kernel bugs that depend on the version of the previously running kernel
> are not uncommon, especially in scenarios where a buggy kernel kexecs
> into a new one and the issue only manifests in the subsequent kernel.
>
> Recent examples include:
>
>  * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level p=
aging transition")
>  * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to a=
void corruption")
>  * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
>
> As kexec-based reboots become more widespread among Linux users, these
> issues are becoming increasingly prominent.
>
> When such crashes occur, correlating them to the previous kernel version
> is challenging, especially at scale, where the problem may only appear in
> specific cases and it is hard to correlate.
>
> With the introduction of Kexec Handover (KHO), we now have a reliable
> mechanism to pass information between kernels. This presents an
> opportunity to address the problem by carrying the previous kernel's
> release version to the next kernel and printing it at boot time.

LUO added the number of times a machine has been live updated to help
debugging problems that are related to live update, perhaps, in
addition to the previous kernel version, we should also add a number
of times the machine has been kexec'd. It is useful when a bug
manifests only after a number of kexec's which is also sometimes a
case.

Pasha

