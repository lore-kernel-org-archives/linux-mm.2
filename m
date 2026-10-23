Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A44606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iDJmJZao
Received: by kanga.kvack.org (Postfix)
	id 811976B0B69; Fri, 23 Oct 2026 09:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2926B0B6A; Fri, 23 Oct 2026 09:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1D26B0B6B; Fri, 23 Oct 2026 09:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 431706B0B69
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:50:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1FC9C03FE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:50:21 +0000 (UTC)
X-FDA: 85354025442.23.CC2E3A3
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A9A040005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:50:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDJmJZao;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763419;
	b=hp/83RCSxwlqORuLqzLJlXolsQQMbqrQhCC3/cMC2VDz1DKGoTnLZcx9bHe0/dETv7rqEW
	6HoBVFeG0OgiUg7kth2HXBBln93ahjPUnOZ2OKNRji5KfaJWm5LHewaD2CCMtl0LIkm+HO
	TDokAm1w1DJKiIbzuPJrfiOM9JP5nTo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDJmJZao;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
	b=42Ox9ryLsnKWh7Lml8XSziUChiRIPyU07MjbXLA1KmG5PAvxqn+KBYb3bBdjD5ApkASaN+
	PDIUjtpr9uaa/rXdEnIEtX7AIl7bIEvKzEC/FkRYqxfJ6G4ty8JUEA0uhP0xvDTkDNyHnX
	xuuIK319v98Tjo9kKG6ocUCBzYwpTuE=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso385806a12.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792763418; x=1793368218; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
        b=iDJmJZaop9gfhn+SVFZWN0u7t0mK/EORV3mhANlAslKG3IYACzqrytk6pqyG5zEKMu
         JG9DyQJlfnmjxrubz2X1kKZF9aJGg3t1ZJjUL8krAkpspl0wnwnb5J764V02olt/qBjV
         KC+/8emklGBBDHqtkCoEGT7wa4RdkTltxoXXpZq6XAudGm+e6kEzpydVm/1aOZqOfgYF
         NMmh19PRN5p0apd7KSVh+rGEnC/zquwPadvu5og3L47GS2YyfAjU9EMtMzpe9846gz15
         SPy86OmmBhHj/s12Y37IF7HfF2yPT5fomTDh8ry3oIbg9PutZH78Hm6530XiXq1RRvrT
         tZ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792763418; x=1793368218;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8FyuJnnll3uJwbR+wT99CVBO9fzREsmjzeqnUECMRTY=;
        b=v3WyzSSehWUOL3xRKaVoQJ9gjWnLDkYfKxbIkejk6zGP/0njYMjWJwp0JFngQ/kXVV
         gcoyrtFBkx/aAI+COI2I9VDsXAhi58GSBwg3w9kFkLeAtM34CvSmbLofxYd3/S0LXBNu
         GYYwlOVsFV5xAwc3m7sFuoMrjpXb9HRDZlEZT3mgGDuaYjbn1BDw5U7/eSh/VsTHPrEE
         gjkaXRPZ+bqrvlmeVBrwAqQmTjjXdXYwvV23Zq2IshpTZoXJ+cSy4eJy1tU7WIxARHm1
         JXqX5vKYW5xSUBi7IMSB8vnq8ogehE0ZBe91wlHi+JVnzUwXPIm5IJlnFPtmIa6PbTJV
         FOpg==
X-Forwarded-Encrypted: i=1; AKwUvBwp/sFwdoGSsLr2wOOM93K4HYRBjLTcRDoIydjub/Ahk2faGU7QZeIAOyw76uGP0eBO9tI2uq0pKQ==@kvack.org
X-Gm-Message-State: AFq9FYLBzsYkrMgqejg5JZ8S4NyQKsOf8qKOqpM3mqVgt21gvWUNyPDV
	vqquW9/nidW1QPu0A5v5Hh7rvthF0p7T2gXddxVU2oUTnBvlsFO/w7tkrenIg3/Tqw==
X-Gm-Gg: AYBFou0yHBmiXVrlN+KBQOChYrFj3X6SXMcxXsd880xKPO8VdgnYiKLgzEkPYH5k5lA
	5hYAsqI6NtWhIbbumHnBAZdS5CVCNVeWTh+skgfwwRPCKEefDSbabDVZdjmoNgQSivM+q7mbQ1F
	p+CKuz0CFRhRqWc5dTZ3Epat9qkbRfL3LnkkCX4nVTzGWNAmcwSr2ADQqULlXrM2Lf4RQLR6aGv
	rzHq6jGJ2aeypzp6TQuGscoqjmV9jmNMIjajJ2IxNXKHeQci4a72AMwANXz2M1/c1/niAR1w/ba
	oED+nqgLvl5+DIkQiR/yeaSnX76ejUEO0WIgwNSknInINqNztL1oz5kTcjMIKvb0OQkDUr2p1rw
	IwucsEDJATZR2s4eUFZ9jR2jq5cXrGHch/HzlN89adDdyy98zCFKB+vOYC3G8hRU4a5d9/7Ljhm
	ZQ5zLSaGRBIAcCk6eGYyJvIJfgl7007YPvO/jfUNifC9leN62rNso/nOfGrSCPqWqh2JnckJ7vz
	T7Y4eSXvqhNy5Y/ABEr4GWigZxKF0la2fRJKOqA/a+yDNSnYrwqpGEZ743cfpPBTiCCIoBjBxaG
	HkJc8QCs7Qs83z0IT6KBnjGuR0gRbbBsXQkGoQ==
X-Received: by 2002:a17:90b:5906:b0:3ab:3437:554f with SMTP id 98e67ed59e1d1-3adce0073a2mr1983207a91.29.1792763417701;
        Fri, 23 Oct 2026 06:50:17 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea94677c91sm545015ad.4.2026.10.23.06.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 06:50:16 -0700 (PDT)
Date: Fri, 23 Oct 2026 13:50:13 +0000
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
Message-ID: <attmFVIFU_mS0Y7p@google.com>
References: <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
X-Stat-Signature: nqmca7njde58j86pipfs3g8n546tffba
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A9A040005
X-Rspam-User: 
X-HE-Tag: 1792763419-682762
X-HE-Meta: U2FsdGVkX1+U4gTmAapJo7L010qF6rIgCuFh9hrY9LP+ssWs/MMNye8UU1IvQOAGWwHmQL/AvBNf7A7nWPQKlP1WtO1OdhvTpOuuQN2uvqkWFXGSTUps4loOLXsayjdRgjWIlqYlMJhwMC/t/Jl0Iu6IJIJiXE1P7C4ooNU163+CvNxm4vRkj5TAfY2VRMOB8I0SE5h0qVxPy5Jc6YQBPePBu2BMoY4uwrqRIgQa33wL8RMA1ryTHiRuavXaqmxxxepq8Whe5XTwD3tBgg+IC9BWzmL5HUHpnfbggXINqeVYe2UctSPkXyJwy/GpjHX9z3t71jLlwfMSkUNFdzf2CgxaLtklv8UnMzdvclBm3eOAAjJKYx7qxcm2iTFAxF8m4Kzda5SHnuUnhr6wPsYi4YLivL4VKL1/uNRa9DOikFaYD8TNT1HnvIUWY038gEzjz9Fv5NPDp6tzAkNSHz1A4Z1crcCwXfXWCfCH089tcNjZtEilZnKfBmeDPe1vmF6V9dbZbPb0IPRV/hG5e1JESfUv65MUYxNL1DFe3ikCpcsIlt+7ekoJkuW8s5BOwuTDYz8aXVShdrp5AuBk2yg/JAyi702kNShFys+lVsjzbGljcKw4j1fAfw1a9GO0DXzNGIsgydVqDd+bvi1Hoo9aZD7jWyx2M2bqN0RYUx+evymcjrbPSGEF1LdAIDIOcn7QgYVkl6sjkGjtJLciYEo22Hv/18wms4ykBNPbvtNXk1XugEOH9w/BDPWzuV1J6OWigS9DGyjMenw+HuDFOZMT/jIqq69DtBKYIiVmhTNFzYdeupU40frJoEC9IzdewBkWGSDQm+XxurYcCR8PNKg1jNsafXPRHBbSB/dWQG0rmUqKfzuv/ZjQfGcWtvSoSzey7kFDdppBLShduYHbnPDFc1UcMKqi8etb1Qu+cOUblCWX+9aUNgHx03LHS9/Umw7yYBJ9otvM4BXmQ1e5Rb9
 myZB+xAV
 bFDg5AQlmqdPwg/qWPrAJ3K0eg5cykeJrOMw1Igi8GQ8WrH+jsQkZEh0iZOZ/8P2OylvEV+qNR43P1R3BhswOuEb9AbYkvOoJeyfEZvchX4T7ZeT5FUr784nKzdUWzzEpWa+QJ4T2DwfwsXpcfYXq5YYgzlCOYjO0iVENHEofrU7f9eWjoJxCkg1r4V09avO3OKLn4AJms+opxMwPdbvYVK2k3W3o/JfWy0N8fcxmc/I6H1JJWvc+8ZnrrwNWuDYmHay/hPjOLzlIZc8T2MO4mW53YY6CnlEmwS+yI7Lpifn0BNchYw63Uxed4yguZAz8XlkcWamZWpWO9hAoU/U00P7+dM5jdVxHKMZQKsR+mErzq0z9/J9fXE2/7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-22 04:53 PM, Pasha Tatashin wrote:
> On Thu, Oct 22, 2026 at 1:51 PM David Matlack <dmatlack@google.com> wrote:
> > On 2026-10-22 12:11 AM, Pasha Tatashin wrote:

> > > Lets drop the fourth macro argument and generate the combined struct name:
> > >
> > > #define DECLARE_LUO_SER(name, expected_size, ext_flags_count)              \
> > >     struct name##_hdr {                                                    \
> > >         __u32 size;                                                        \
> > >         __u32 flags;                                                       \
> > >         __u64 ext_flags[ext_flags_count];                                  \
> > >         struct name payload;                                               \
> > >     };                                                                     \
> > >     static_assert(sizeof(struct name##_hdr) == (expected_size),            \
> > >                   "LUO struct " #name " size mismatch!")
> > >
> > > For example:
> > >
> > > struct luo_memfd_ser {
> > >     __u64 pos;
> > >     __u64 size;
> > > };
> > >
> > > DECLARE_LUO_SER_HDR(luo_memfd_ser, 24, 0);
> >
> > I think we are getting close, bu I have two remaining concerns:
> >
> >  * Reserving bits in each flags word for continuation leaves gaps
> >    in the flag space that users have to know to skip.
> 
> Yes, but callers should never manipulate the raw flag words directly,
> and we can provide simple accessor macros or inlines that take a
> contiguous feature ID (0, 1, 2, ...)
> 
> enum luo_memfd_feats {
>     LUO_MEMFD_FEAT_HUGETLB = 0,
>     LUO_MEMFD_FEAT_SEALS   = 1,
>     /* ... */
>     LUO_MEMFD_FEAT_FOO     = 15, /* Automatically lands in
> ext_flags[0] bits 0:1 */
>     LUO_MEMFD_NR_FEATS
> };
> 
> if (luo_ser_get_feat(hdr, LUO_MEMFD_FEAT_HUGETLB)) {
>     /* handle hugetlb */
> }

Sure but why deal with all the complexity just to save 8 bytes? All of
these structs are allocated on folios and there are kilobytes of unused
space to fit this header. And even if we optimize that we are talking
about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
sub-structs like the KVM ones.

> >  * struct name##_hdr only matches structs written by the current kernel
> >    (in terms of length of array and offset of payload).
> 
> This is not an issue on the incoming path, we never cast incoming data
> to struct name##_hdr or access ->payload directly. Instead, we parse
> the incoming buffer, dynamically compute the header size from the
> continuation bits, and cast the payload offset to "struct name *"
> based on the negotiated feature flags.

How?

This is the only data structure that describes the header. Are you
saying the incoming path will parse the header purely with a void *? Or
use this header but just be careful not to access payload?

We should have one header structure that can be used on the incoming and
outgoing path. We should not have one header data structure that can be
used on the outgoing path and one that can be used on the incoming
path.

Also we need a standard header that can be shared across all structs,
not a per struct header. Otherwise you will need to do weird casting and
overlays to implement the shared helper routines that parse it.

> > How about this instead:
> >
> > struct luo_ser_hdr {
> >     __u32 size;        /* Size of header + payload in bytes */
> >     __u32 nr_flags;    /* Number of features encoded in flags[] */
> >     __u64 flags[];
> > };
> >
> > Each feature occupies 2 bits of flags[], so feature N is always bits
> > [2N+1:2N] of flags[N / 32], with no gaps:
> >
> >   00: Feature not present
> >   01: Feature present, safe to ignore if not supported
> >   11: Feature present, must be supported by the next kernel
> >   10: Invalid
> >
> > The length of flags[] and the header size are computed directly rather
> > than by walking continuation bits:
> >
> > static inline u32 luo_ser_nr_flag_words(const struct luo_ser_hdr *hdr)
> > {
> >     return DIV_ROUND_UP(hdr->nr_flags, 32);
> > }
> >
> > static inline size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr)
> > {
> >     return struct_size(hdr, flags, luo_ser_nr_flag_words(hdr));
> > }
> >
> > static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
> > {
> >     return (void *)hdr + luo_ser_hdr_size(hdr);
> > }
> >
> > and bounds checking is just luo_ser_hdr_size(hdr) <= hdr->size. The
> > payload is always 8-byte aligned.
> >
> > Payload structs are then declared on their own, with no header:
> >
> > struct luo_memfd_ser {
> >     __u64 pos;
> >     __u64 size;
> > };
> > LUO_SER_ASSERT_SIZE(luo_memfd_ser, 16);
> >
> > The static_assert covers the payload to catch embedded structs changing
> > size.  Asserting the header doesn't add anything since its size varies
> > by kernel. And because flags[] is a flexible array, the header can't be
> > embedded in front of a payload in a combined struct; it can only be
> > reached through luo_ser_payload().
> >
> > I think the only downside is that the header increases to 16-bytes when
> > there is at least 1 flag. But I don't think we need to be so concerned
> > about an 8 byte difference...
> 
> I would prefer to keep the default header at 8 bytes. With 15 features
> fitting directly inside the base __u32 flags word, adding the first 15
> features to a struct keeps the header at 8 bytes and does not shift
> the payload.
> 
> Computation-wise it is also very similar: for the 99% of structs that
> have <= 15 features, LUO_FLAGS_CONT is 0, so computing the header size
> is just a single bit test with no loop. Even if a struct ever needs
> ext_flags, the loop will walk at most one or two extra words.

Please explain why it is so important to keep the header 8 bytes that we
have to jump through all these hoops to map a contiguous flag space
onto a u32 + u64[] array structure where certain bits are reserved and
have to be skipped.

