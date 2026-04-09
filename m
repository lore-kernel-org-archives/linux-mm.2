Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CC0E9DE6F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 09:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2756B0005; Thu,  9 Apr 2026 05:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BA46B008C; Thu,  9 Apr 2026 05:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC756B0092; Thu,  9 Apr 2026 05:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28EF46B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:06:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD1C213B6F8
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:06:14 +0000 (UTC)
X-FDA: 84638435868.26.56E394E
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C47080013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 09:06:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKh36J9O;
	spf=pass (imf02.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775725572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZryO0qKRF+cyo5NikEDT6axHoFUuS1poGw3MmfPXUU=;
	b=OIfMguxAw342nXB77Y+fjOfqal+K+HbFsM9vEIT27EadwIw5WK9m2hj9pnpPro5/FJHdOo
	dkHZCPR99gMrdSXUTRhugRBZOpEw+iAD8b56oM9OILN7rms0gyfZVl5wLwXeEXMaUKBydq
	IpimevilgC+0pcg1BM6pNsr+7dz4SQE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YKh36J9O;
	spf=pass (imf02.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775725572; a=rsa-sha256;
	cv=pass;
	b=oSayQwrZa1M8ubwBUFNbd4cP8ZJ/+EtTP6wHaW+KNCXmQQJDTpz7b3zV0BRhUGafyXOXrr
	ON9EgsK4opVqGOk1ociUdDvCwET1StCnGFCfG68r6VafdFjAFOfe1fHKL+4EYXfPtTKKPn
	HUHyG0mcqp7cUVxkkd0U+gZSB35/EHY=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38def541b0bso5697401fa.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 02:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775725571; cv=none;
        d=google.com; s=arc-20240605;
        b=cEg+X19J4qx3uB5sEODuiCqmYg6PMV2MElMtaA7+e7utJmSOXiWBAVQ38zY22HAN4B
         gzdKdFlMIC+kCTs9mgSPNYpNMyUCvZCEPyrhg1xz6HXn7oJYmPcgHM++o3KVY+RcY/m/
         eEDCa+H5DqUmhaobS8smdFWU77B3T/0bHMKQc29PEm2LLdeUOdS7qci623kdS2wp2z76
         tnFDKno+ZXFJ1X8RykQ/dbZE3kdqpuEXSYZKXZp/dF6CXDneflbGJrfsbEHXRHVa20hn
         G1s7SxYymoQ/48qRElowMb76XXzlh/Ou9WlBfSooug7V85F17EKNv67x0UaN2gl7NKjQ
         Z6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ZryO0qKRF+cyo5NikEDT6axHoFUuS1poGw3MmfPXUU=;
        fh=Vsx5jivh2CNvjnh03v+XC9BPvQsnB1E9o6hUkJrjK28=;
        b=fZaA9mRTJHuFAagJdn6EgO3PSGc3AFXXyQignA4d8AqaxdbpgOQJsBHAgXzTBVUJfU
         p4QVmcb7mpHKeaEr3XZvAfk8ZAOtRT+d9tCPMxmebugXrXi2UDEviSbn4J4z4pY1pyz4
         ZJEBHCo8dmqABM7a9hGmegapbLa6ZRNJo5OR5SBYB/iOn4SNdkaAM1nfSgCu59e7kKDX
         rkU9f8n2/NxACyEAwiI1Nw+pLMB0EALdonYmk1H6A2DKt+x8xgdXioE7AUsmMIirmXYV
         7rkNlQOWFjgoVfLb68I0kZzzDHg4ziIROKY6kAf2LJmvtO/9d8uzsKmBiHxvdUzN5lna
         8VJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775725571; x=1776330371; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ZryO0qKRF+cyo5NikEDT6axHoFUuS1poGw3MmfPXUU=;
        b=YKh36J9OdEmyS+GV8mpo8jP11kx3GkbmbaTHjkDn128sPpkU17xtJtH5b+Fr1uUx7c
         AN4ZIFq0Dpn+V9v+vSfxVd+coa06aeSvHRDYGVLdzIA/GuxLs6XqlOq42+OMpUFa1XPN
         iEUDhpbKGW4ROajvIwQ6Fn2uO1rDx2033LnJupOFdhm1LyVTM0/aJtpQyfKRLDM9czJZ
         MpnhuEhTmNaLRUZW8bWr8GHP6oOMJQbJZEDSSJN8sW+r4Oc8IoX4mxjn1bu6BY+D/6i8
         zD6bOJVdXboht/bKNxJwKAIm8MkxzKAPQdnffyFZaWfEeQE9Om+fnyn+J02BfJZqXPh3
         hD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775725571; x=1776330371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ZryO0qKRF+cyo5NikEDT6axHoFUuS1poGw3MmfPXUU=;
        b=IEk6ltrTSqO7AFDAlU1k2aRuoXjFy/yPnv1OdhdddwPxE4VQbM4Z6WSx9wD1kmb0zU
         wFfphPlm6D9jKHMUwcIalz8f3Xp0Sp1IVl5ulDwY+bLyetMIOGKQsfCu+nGhLyOmhvgw
         3t+YKvaNNkmglvGHzWOQ70W2J47OPbk3765e8u8VDgWBRMTlBDeYqvnY9uNCIclPe1Iy
         28VTdYAKXIo+MGZoEeQ87cAs0cz0dkoLRi7E0G99CRG0G+1FW5It6ISyaiFJjBL91PBa
         K8QdEfZoKgBL/U9gPxCHvgjsrfzMONF711GMuPysypbJDv3zI97LG4EidrfT6RWd8x3D
         IFXA==
X-Forwarded-Encrypted: i=1; AJvYcCWQeE2YaBYwtX9CDrSoRiqwEesZygniEH447IM9/AhO1w4N3Ax+2nfNnjPXyhvlZ+mSKsPo18Gf7A==@kvack.org
X-Gm-Message-State: AOJu0YxMqueTTlOhAgPwmpxFdKxG4N86/xT6bCDvIeuhF/BPsZE3YMWu
	f7x9E7GrjmprjyYGsR8IAq8P/3E5AkSfrSqWy56MWvSOEcqris0vyDAj9tdRboFpyXFt+M6U2Cb
	kfhQqMkgU01vcXgrqyXNsV0ZSD/1vyGk=
X-Gm-Gg: AeBDievEQ5NfIP9h4587foHpF6UtmLkECp1iTY0m1NbxUXoTE2UgDfbMEg4BB7J5QdH
	pO4x5uXUiSGIqNLdUR/TqTRMqfA9mtpIkYwlKhWevdhulSmlagX1SJ9pQal5kyCQrGCsLk5XSlu
	Q+cDupSVjQuWX/e2jZXmivNIkPGzmQ5WbI/rcf2OPNPSStTFjVwBX4xOwhhkaZuQUNDrJ71k5oa
	SQiALsMfkuOBe3puMOU5sNSk69DMk2aLxv0WuIy5iN4zoFjXqJWgWroBfkjmfDc2/oEdNQLC2Gd
	M1KR3dU=
X-Received: by 2002:a05:651c:1102:b0:38e:186e:350e with SMTP id
 38308e7fff4ca-38e335002e7mr9204291fa.7.1775725570037; Thu, 09 Apr 2026
 02:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260407081442.6256-1-komlomal@gmail.com> <20260408123700.1596800-1-usama.arif@linux.dev>
 <addcUpxfuR2llaiW@lucifer>
In-Reply-To: <addcUpxfuR2llaiW@lucifer>
From: "Denis M. Karpov" <komlomal@gmail.com>
Date: Thu, 9 Apr 2026 12:05:58 +0300
X-Gm-Features: AQROBzDfRsi8mYNwNmhy9bUN0g1ZwnamyHPiBKvKGT9BZOgi64bSgj3u90hlgn8
Message-ID: <CADtiZd11b89Bt7-7N9xa6AHLKFX9D12X=tQan9VJLoZd6PtuYg@mail.gmail.com>
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below mmap_min_addr
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, rppt@kernel.org, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, jannh@google.com, 
	peterx@redhat.com, pfalcato@suse.de, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C47080013
X-Stat-Signature: xy97apzcr37rso8wf3cg85du9yczegk3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775725572-193053
X-HE-Meta: U2FsdGVkX18EWUX64ku3JDxqVmCZyR18IP+UPrdSxrXwg0TPOBbQTv3tAJfuYmxj1GoUp7yZ44YOTBVm6cyIw9YiSacj/EHesgnKdwGGBzUFlaNspnPUp/mpn2EPMvrqozvnfJhTD+POLRV8a4TgX0f/iWNuKsgU3dseqIT5MLa68bi61ggysWwgcqpyetTJssQmzrLsW/7RyBJHYr4IMlR+KaHTWX5x+kMD1aagTsxGjNH/hd2NR542BfmmjagBFKharUk6C20XsBn6pIjuwXCWE5kQ6L4HGPIlLPyWcUuysymtuv0HwgBV20cH+r9RSzX0IthAOGYcM0IYAN7tl2Mk0kZq95+w6oEqmA4Ggd+CRxRPub5VfVtvqjl/fNDIYp0HUexd+e2PeKjZTm/FzDvSWee6UQ+KU3QGbTp4qgfqsJK1zBwbFsCvHW8Lc3zJIpF5tB8Zm+ioBawo/JpExXdi8k++rF0vqtdoB/l4FwWR24+JxKLPvfQjfaq3YIF/TfkICrn7VR1AHVdNyjQdTF3oV/c3Umu0uLv//f5VmPWwxtiwFkt/FGDjGqBWeqFIjEiuSqeBltm0iSkESLu82STmM9SnbH0CvN0kHhI4aqz1vwoqbt5WbDfWcH/CLSCzKdcva5PiHv/hgrJQ9na11dQjko/U0Mr4wa+c1Q36Ugy4DfvJ9oQ0XfCmMJ5JY4CzPmzLyBE44j6zPZJ5Ls9nmC1AI37vUr7A5l9Wf2YuvoysJv2sfrc2HbigudfwWaVKPWllNNv7kVe9v6ODDObNIjALPAouDP0FLjVLgSa07xIS6QJXtYuaVl27cQx/ap3IG75PV2f1Cp/OsCcBcdU/O81ynx1EVRfaG+kl8HonEkT47CsT6vBhISeaIg5eEjMnTfpheRu+1lfwmUYV6UMcxzmjsh8IWXqUZTG08meZguj00CvoDNpOLGmE0bfjPd+nJCKVX6IfSPxltRK9he3
 Av+k3+sS
 2DKCRDoCauRmorg690R8WChsgOl8ewSRl1Bgif+3sRIy2gotlZD7lzhnA2KWSAhz3WeHkwVhX1yTP3oeMIcWEbhPpbmnGb0Cr8eMX+7PqEf9qapOgBwffaPvZqju9RnJpPiI4kO10i9aQ59bjibkh/zy01zvEsZpbnzre+5V6qrC/8BqD0v0AbDuXbU96BqWimsJEEUoJaJhSuAMAcRYP1Kg4Re/8c0eZaqrP3tOKVxPXHb8a6up/FIixnPZBB1Ltoi70G6dLfWApfpsJvU1zjxPJ0Z82ulmoRfd1sUY/Gg2IDB1MtFvzKBKnbRYjVoCpewu+VLypYLLjXSjORkkBoGFP5dyd/aXQw5KDytCiEYEFrTt4w0r+XCRcpurM32ayjUWWM13SlcCKxBXG3ujmAqznuZksDl9dH+ZJYefFvo7gsF0eWGqrO/1x46FFS9Zmq/Z+P471t3D1ww9RN1PahMA3Bx/TjTG7OSilEqt+YiU4FZh3//1Bq18hlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(to Harry)
> Technically, it's less restrictive only if start < mmap_min_addr
> (setting aside the discussion of whether this is an appropriate check).
>
> Otherwise (start >=3D mmap_min_addr) it's more restrictive? (now, the pro=
cess
> should have the capability when registering an existing VMA to userfaultf=
d)
Hmm, I can't find any checks for addr >=3D mmap_min_addr in the security
subsystem,
only if addr < mmap_min_addr. Otherwise, one would need capabilities for
regular mmap() calls as well.

> Was it a private discussion? I can't find Andrea's emails on the thread.
Oh, it seems Andrea accidentally dropped some recipients from the CC list.
I have CC'd him here so he can clarify his points if he feels it is necessa=
ry.

(to Lorenzo)
>Duplicating this kind of logic in the already horribly duplicative (and mo=
re
>generally, horrible) UFFD implementation is actively buggy and incorrect I=
MO.
So, no security_mmap_addr check, no FIRST_USER_ADDRESS check.
Thank you both for the review. I'll prepare the patch.

On Thu, Apr 9, 2026 at 11:01=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 08, 2026 at 05:36:59AM -0700, Usama Arif wrote:
> > On Tue,  7 Apr 2026 11:14:42 +0300 "Denis M. Karpov" <komlomal@gmail.co=
m> wrote:
> >
> > > The current implementation of validate_range() in fs/userfaultfd.c
> > > performs a hard check against mmap_min_addr without considering
> > > capabilities, but the mmap() syscall uses security_mmap_addr()
> > > which allows privileged processes (with CAP_SYS_RAWIO) to map below
> > > mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() use=
s
> > > dac_mmap_min_addr variable which can be changed with
> > > /proc/sys/vm/mmap_min_addr.
> > >
> > > Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> > > with -EINVAL for valid memory areas that were successfully mapped
> > > below mmap_min_addr even with appropriate capabilities.
> > >
> > > This prevents apps like binary compilers from using UFFD for valid me=
mory
> > > regions mapped by application.
> > >
> > > Replace the rigid mmap_min_addr check with security_mmap_addr() to al=
ign
> > > userfaultfd with the standard kernel memory mapping security policy.
> > >
> > > Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> > >
> > > ---
> > > Initial RFC following the discussion on the [BUG] thread.
> > > Link: https://lore.kernel.org/all/CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh=
4eY_hUmH29S=3Dsejg@mail.gmail.com/
> > > ---
> > >  fs/userfaultfd.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > index bdc84e521..dbfe5b2a0 100644
> > > --- a/fs/userfaultfd.c
> > > +++ b/fs/userfaultfd.c
> > > @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned=
_range(
> > >             return -EINVAL;
> > >     if (!len)
> > >             return -EINVAL;
> > > -   if (start < mmap_min_addr)
> > > -           return -EINVAL;
> > >     if (start >=3D task_size)
> > >             return -EINVAL;
> > >     if (len > task_size - start)
> > >             return -EINVAL;
> > >     if (start + len <=3D start)
> > >             return -EINVAL;
> > > -   return 0;
> > > +   return security_mmap_addr(start);
> >
> > Is this introducing an ABI change?
> >
> > The old code returned -EINVAL when start was below mmap_min_addr.
> > The new code calls security_mmap_addr() which returns -EPERM when
> > the caller lacks CAP_SYS_RAWIO. Existing userspace callers checking
> > specifically for -EINVAL would see different behavior start is
> > below mmap_min_addr.
>
> You mean API change? :) we don't guarantee ABI for kernel stuff anyway.
>
> Firstly, as with Harry, I don't believe we should be duplicating checks h=
ere
> anyway. UFFD is duplicative enough as it is.
>
> And this is such a silly edge case that I don't think it is valid or reas=
onable
> for us to account for whichever totally insane user relies on a pointless
> re-check being done there and _then_ relies on the error code
> being... -EINVAL... which is overloaded for a million other possible fail=
ures.
>
> Let's let it be -EFAULT and remove this silly check altogether.
>
> >
> > >  }
> > >
> > >  static __always_inline int validate_range(struct mm_struct *mm,
> > > --
> > > 2.47.3
> > >
> > >
>
> Thanks, Lorenzo

