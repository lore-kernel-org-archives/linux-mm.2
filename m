Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBDCD60A2602
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=a0WUo4hq
Received: by kanga.kvack.org (Postfix)
	id E8D036B09A9; Thu, 22 Oct 2026 13:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55DE6B09AA; Thu, 22 Oct 2026 13:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08126B09AB; Thu, 22 Oct 2026 13:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07F56B09A9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:51:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37019A7471
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:51:24 +0000 (UTC)
X-FDA: 85351004088.27.45647E9
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 520E7180005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:51:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a0WUo4hq;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792691482;
	b=pvNyTKVs2SC7lbKhBtuvLMTRlflzb4jV0+BIoK5UhPp9V9mrdtvMFm6Vzdtg+wDFQGLKZG
	Fa1jyEoUghxlo/uZagZYRYAA7wwiBy3ZjP/FnBwrimtSKJRj2S33SizR5DklGVLA+U4m+D
	GKYp/DbB638maTWGK8fy3+DYDkjnc0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a0WUo4hq;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792691482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
	b=Q6Zhs9R94y7gh6CyWzUahSWsNi63XedGCveIR6iPE4RS+BEzFZyTZvq9e812fHRte7KCIL
	c1wDaPHfoI2M/bS53Z+vBh842CX6X7Z8HRTvl49JDezHgLK2C88ltPkHMjrZQmA9jujUgp
	ACUTbU/SEfHAQtHUbCzg8V9xYS1nkUc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e60f9af6e6so4965ad.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691481; x=1793296281; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
        b=a0WUo4hqOe53LMxMesYZyccNYWYtpc8wVB4VmnAQMaaKHQMTGCrNfOHPsiS3ufqlxe
         UwzohawtpMg42X4R8ekXk8Fv/vsZymEW0peg7TfHOHd/68cRmqee4RsMvxBhHJQ+scYw
         ADUA8sLuEMNkeOdCG9P3co3+aWTQMxUMjoEnsKYk/xByuzlrMLoZZCBQ+U9GHIwTLT03
         +Vm9dyuk24SL8CDubYHXxXOw87aVG8iHi+uyApjXnpxwMijep7Th2ec4o516MBrEwpFf
         AXf7xRZJe5GSIcSka3i1/MFZCGmrqEjcwnr3BPg2k3RsmWMdx2qOfJTq20orT9OgZ+wu
         s3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691481; x=1793296281;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VXuE27163XQs95Y17MHXQoRtZevE9c0I3KUjJaU7M5M=;
        b=IpyIn27+MsECOKocxtZ39+ZJ7+Y9zU1UXzfVcIo5BNwwBTeK2aJNXEvTZC9EroSF8a
         dyOlIz6YKFAoeeXUUsqeW90SF6qKqTklildcTofeNCADZ+oWBp859OAM9CCJ2bVwJ4gu
         WDCVrJTdJBH7ER/v6OCWIcRe6Z9i64mBjFzTqe+H89qhAQdxf1Io+nOARFgIYkPEOHW/
         gLbeg8grPLARUJJP3UDUPbRzPhZ8jC3JxyKFRmdbs6NBYCiRaW0ZVzfxr+OhcUiFI/En
         jcUs1O4DoQSp9qKKJSrfxkIFhYyyDgjevIJQc40CeB4m2SWN3VXd19HTner4buGaGB2a
         QPNg==
X-Forwarded-Encrypted: i=1; AKwUvBy5jkeWRBgTqYT/wL/812TqnUOErrSRfGQI8yjd78uO5yspXmsee+kDbgK55pHESCDWK/svBLI0pw==@kvack.org
X-Gm-Message-State: AFq9FYJ4XpKPVdP0S4s1jK74HiKPks0ndY6n6bzU+opWsOVBQ+lLE0In
	nDH3Ok7C2zD+YKbNILxfTgtURm7TXYJOCk5p4NCXA5sr5Av3CwSZXLsHI7izQFVh5A==
X-Gm-Gg: AYBFou2QQ/FKhtH2Fq+dvO9/I2mUG3Px/onCZ0mWfj2W35eCaJ+P7QO/DXn5zWhCcBO
	M28LWMzUCmm6WAgcujq/QaOkeqgQrATDTOq8pYVOnIC57Y6EPNKqK+St8L7mR7V12XZpgKpdlHi
	AEYwPEVi94GkabYt559qlEKvtgkROpWFuwIZqQy4CRpZDLKO1TMu8fnyTb1Afm97WOBNbbBHaCh
	rEbpNmTPeGsph3vOS/tVtMWXuX1C20/LIbjQBAs+5akqeiIDbKJv/YoQ1vqhMklFEYxKUdI6hAU
	lasELWZVh8ILovGyaX7ZLh6tRhCImEfb21dtr1T331uCBVAFw/ABxITrN3Rd5O793j46sCoGjYm
	XNZOXNoQEK7chWc6YAFl1MaQyPCBRFoFYNW0Nc6IBoeSSVXH9mh4oGoO1ND835iyDKfiOvA8CWW
	iMDYokNqTg4oXZcpQFwWkxPC6R1YEryWsH7KeAA5kFuHCJ1Aw4JV3tqRy9ryl7qrtvA2F2WHEGa
	+CDMlu3as8fRXDgy4diXefsqDgfvwu2wVt5XiqIXKlC9Sd/9q6Gr+W09D9IoZxzNHkMiq2NmVeJ
	9KF+575UoRK+aOmm
X-Received: by 2002:a17:902:e547:b0:2e9:502a:ddbb with SMTP id d9443c01a7336-2ea43c9f6bcmr53298445ad.45.1792691480085;
        Thu, 22 Oct 2026 10:51:20 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b346c43sm1644745ad.13.2026.10.22.10.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:51:19 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:51:16 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <atpNFEFIlqAoYIwH@google.com>
References: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
X-Stat-Signature: hpdx6eh6qncii193ppby67pap93xe5im
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 520E7180005
X-Rspam-User: 
X-HE-Tag: 1792691482-798382
X-HE-Meta: U2FsdGVkX18NLXybmgibO5I+9QmJgEf1VUc9HS6HpWiH+kLMxWXhvZgSUD6wHTmjanRw4EQKzwSLool8n5j06qyDzn1aS7xrP4D5BfdU8vhgfsfLCLR/nlPF0VsK0tH5pEJJplC8jZGmRRQ8z+/o90tJLHyvn1a7CyaBa6wGa9LmwLHOEC90HGoyXij1SeOBbqz6jx7a02qy1k9MYIls/MaN4BRCM9sr3lGVoYVAGY3cTYehH1zVr1Cz9VJ04XnFte/obEN6a1YeHEinoUTMATXxMVBFdKTQCIetgMp8nz/u103pxZe2ZVPbJno05V+jU4sWhU6/X9tC3e53bqEma2h7TFnbTKub/A+QPhG5qKrO32bBFsi/bda4qOoQg0emMmQBEXYhSLdrjC8WOGCkJIOJSvMtl7WqE93mdsKwfEDIZgsab/CKbHDKtVuoyxjGMn854DaLfGJ4UMGQNz0F/Raj+KAECbMm4uKOEr5xg0tBJpD4shLbSMCvxgLSbJF0UQQ6wPCDEyiMXQrOtqAhU/h7o9I9xiPiPN4pmYl4Nevz0sAngzi+a7Obi9KnUv+toZC+X0fmiEcON6B+FCakXt/Zsp7fEH23xlD+3TD4AnbHGW4QQWdzQzMtWiQnsRjPSINm90HfzoC6vAppYPJpkWQH0LTVaFgrTqHNaLPUMN6HKZ0QwfajKvqABEH2onhAVq2o3a+jJG8uqOSfQNveLkVInsKx+zIwANOmtRRMhmNn0w76+sYWRGy/Bmkolrk442sukYw1KGPe+MwMAuIpuurAaGCd3lde5ny81dLjglNDzzaB1ejTXQpupmEyEKIIqFUEIdAaNWrwEAa/K0O3AGM9dsSeSqQCFOpfeKJFkbiy3u3EhMmf44ZmHz20CleBdTmDEUcgBmv1STQFxh1rLCHxdW7PGFgKidp/uJELh5KdHAy5oBqM6JXhQS5lRswvhig+T70yJsdSy10fvpI
 hn4u9fbX
 oJYZuECd22zIcd6359PovhYgLE/VY4nDfBonH8P5F8tB2dtizgv0KqL7qiJM/OLmdvf87i3Ni0a04yNfzZqJksrE0JA5HIMlDSgGmcVNesanZTQ/9tOeYoohM7U49xb1qPHFgSSZNyilI9YG67thmwG26CPxw0xEOmGbU67O11bSMpKh8ylJGdkNNLQpgmAIpu7PueWsPXvjwnQsX7iDtB9UTMM6ae5WlYtV+DmczQ0b01UG6tdkv2PoswtvV3yZ8EBld8Ia7UVBEVSnI9KGyFAuNUGbdX9bqtxsyr1Ss6hl1/xzeyYkE56B5/0BSzGUf3y883CewSIYRzRpvVAa2jdgW1pYCtX0uejtvag6k6/z2Oz62AqJpkGWiVn0poQ/xVmMR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 12:11 AM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:53 PM David Matlack <dmatlack@google.com> wrote:

> > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count, payload_type) \
> > >     struct name {                                                           \
> > >         __u32 size;                                                         \
> > >         __u32 flags;                                                        \
> > >         __u64 ext_flags[ext_flags_count];                                   \
> > >         payload_type payload;                                               \
> > >     };                                                                      \
> > >     static_assert(sizeof(struct name) == (expected_size),                   \
> > >                   "LUO struct " #name " size mismatch!")
> > >
> > > For example:
> > >
> > > struct luo_memfd_payload {
> > >     __u64 pos;
> > >     __u64 size;
> > > };
> > >
> > > DECLARE_LUO_SER(luo_memfd_ser, 24, 0, struct luo_memfd_payload);
> >
> > This looks pretty reasonable but I would name the payload
> > luo_memfd_ser. The combined struct that DECLARE_LUO_SER() creates
> > should never be used directly since the offset of the payload in that
> > struct is only valid in the current kernel. So I would give that
> > struct a special name that makes it obvious you shouldn't be using it.
> 
> Lets drop the fourth macro argument and generate the combined struct name:
> 
> #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              \
>     struct name##_hdr {                                                    \
>         __u32 size;                                                        \
>         __u32 flags;                                                       \
>         __u64 ext_flags[ext_flags_count];                                  \
>         struct name payload;                                               \
>     };                                                                     \
>     static_assert(sizeof(struct name##_hdr) == (expected_size),            \
>                   "LUO struct " #name " size mismatch!")
> 
> For example:
> 
> struct luo_memfd_ser {
>     __u64 pos;
>     __u64 size;
> };
> 
> DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);

I think we are getting close, bu I have two remaining concerns:

 * Reserving bits in each flags word for continuation leaves gaps
   in the flag space that users have to know to skip.

 * struct name##_hdr only matches structs written by the current kernel
   (in terms of length of array and offset of payload).

How about this instead:

struct luo_ser_hdr {
    __u32 size;        /* Size of header + payload in bytes */
    __u32 nr_flags;    /* Number of features encoded in flags[] */
    __u64 flags[];
};

Each feature occupies 2 bits of flags[], so feature N is always bits
[2N+1:2N] of flags[N / 32], with no gaps:

  00: Feature not present
  01: Feature present, safe to ignore if not supported
  11: Feature present, must be supported by the next kernel
  10: Invalid

The length of flags[] and the header size are computed directly rather
than by walking continuation bits:

static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
{
    return DIV_ROUND_UP(hdr->nr_flags, 32);
}

static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
{
    return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
}

static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
{
    return (void *)hdr + luo_ser_hdr_size(hdr);
}

and bounds checking is just luo_ser_hdr_size(hdr) <= hdr->size. The
payload is always 8-byte aligned.

Payload structs are then declared on their own, with no header:

struct luo_memfd_ser {
    __u64 pos;
    __u64 size;
};
LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);

The static_assert covers the payload to catch embedded structs changing
size.  Asserting the header doesn't add anything since its size varies
by kernel. And because flags[] is a flexible array, the header can't be
embedded in front of a payload in a combined struct; it can only be
reached through luo_ser_payload().

I think the only downside is that the header increases to 16-bytes when
there is at least 1 flag. But I don't think we need to be so concerned
about an 8 byte difference...

