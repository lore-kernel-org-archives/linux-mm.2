Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1988606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=tGIe4fN+
Received: by kanga.kvack.org (Postfix)
	id D90676B05B0; Mon, 26 Oct 2026 16:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41B06B05B1; Mon, 26 Oct 2026 16:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30706B05B2; Mon, 26 Oct 2026 16:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97E7A6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:49:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16DA580868
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:49:10 +0000 (UTC)
X-FDA: 85365967260.16.6DB3AEF
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 405551A0008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:49:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tGIe4fN+;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793047748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
	b=8MJ0uxnwERtxl62ngK+9wNGEH5SEimMhv4NZXvi5pYKzfbeUCXJv4WRkB628VQTIsiWr0h
	+9Dv26O+Avka8DZ3m/vE2wADmcZ01WoAmh7OlxncR3WSfpH6nxRdZrDMEEDpx6XX6L9HHs
	vDnVTKn8ST/wvTkvmxyp310PyTMdYI8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tGIe4fN+;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793047748;
	b=fBy9lV4Dx23fgE039gM6DHDVv+1SNy7T2W08VB9sHgRbz9MnNDvCLwYfr7fe1q+FDCD33k
	zP+696VO+HmpsZWgy1w9y11MzGQAHhMrWxt1jlo+IdXwd5M13lwi0zpQzbY2dRlhQmUHM2
	gbunVN1qh1Ad7fNzAdWIaTAipEawoU4=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso2044470a12.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793047747; x=1793652547; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
        b=tGIe4fN+Zlxd05NrL4X8+C4cN6bB2RT1qXzkCP0Bwps3k8vPyAOSHx3XNGcN8SBq98
         r6QsCFpIsNDjcG1pX9OHRJsNre4B4n3um6B1+pejKvVI0NgVxmKDsoeE54/MaqCBT+2x
         zfn6dzfV8fZFU2pssfT3iqeL3zUb7mpEvKlP15LoJaUfWvh2OD+isV11jVSjXZYKsYo4
         va1GXZu4KST5Xh3tqqyqsl6moYC3bI6QWyITJ9btTDLDsA/rF0EAQNWLozVCDM0Pa4Fg
         +B2g6Ue9+CvJKKydn6LvE47VI4rnO1FqR9I9mAg+u9gh3lwJ9wMinq2pq0woryFvaxHN
         51kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793047747; x=1793652547;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PJBAWhG3vQY26e/Nvx85KnaVoYI7FZuNNNc/vdxGNMI=;
        b=xnz/1Fap0kZl9OlPj3dZmjgfb6gyewgVL7QB1R/YX4Gvp3lf2AMyphoq1ztlFMnykW
         eSUN6i6XGqA6z/3U6/JVobv0KRFnSJmEB/IYdK3M1DHxyniif5C3s1Ulc23BxTGLbB5V
         Ssh/vtfVUjyDL0n0dD8TrLKWxuFIG+CvRWgtMcBUNXidt5RexbiDLXufnpBlCCtsqaDA
         /wBm+4gECO+teBjPaMTJrXmhGqDC7b/SN0+BnfCvBYglmkbdii34aRn++4j1V9mTOe3y
         bmgDhmHVNnGf4LLvK5A3OQs6rDA4wWdqwk+FMXQbrg0cORYR84AsmzcxWCQpXUOMsHJB
         /rcw==
X-Forwarded-Encrypted: i=1; AKwUvBxyMjHXnpuYjENPyE734zx8tBW+qtQOUa76YqJoBpdNSiM5bz5bsakz9yCL8RVZZkFR8jUZdViEoQ==@kvack.org
X-Gm-Message-State: AFq9FYJN1I3eehoVVtBHnJn7WOFa3IBr2pZAQHmUu5f4NoeUmsYALtT4
	99xKjCnxdGNJoyx6EvaLJMXoAoZRivZZj0CwAhXydPQEOUF38s83CXDuQMv8RJHQNA==
X-Gm-Gg: AYBFou2wdYhIxOmMggC/jjpvizQfb3XqpqErKPw2HUW4x+hQfav4yMn5UVixnoiQJBd
	pTmp5T9IqnFCmw9hzrJYqpSSOEBBLwUtS4ub1HbJJql5roYrmE0VsHcpecx7VjkWaKmA4mJtvhm
	pj0W7ZlYDHiex49UJ8NAY3ejkQTKyLbBye8nxqWdtm+XZGD6ltAguC5pinnAPdVo8tmYMGYeqRi
	QGuzvTai6eKmnc8gDULql5P4Rf8kx3nwr01BTo4hD1xv/frIX0J3EzA0RF5SHuCtHpPpp2I84nY
	Tjw9Mhg5TzAVnjF35sCFp7dx3v6+60WlzWjtycczIIwUou10zdEdmA0hoL0oAIiDsd+UmGNDC49
	gmguRQ+4ZYtK4ZG/S70pxetokrECo8T5UfyvN6vDwK+camNtcdG8B62Gt6ub0KCteM2wHVxnKTd
	ZW0lyBJ8l7YKvgG41Qg7p+m9M4DXiGKAf9Es63oBGOeR+FyhDBoq6x/Rty18y7YP5Arpl/98Uf4
	fg3ypUEIHhmVjpoumS+mzcHkxp0PVt7wxGRXMS4RsewGZvYN159o/zFg/XKD+uigsDGQDSpeOfz
	+iCa/aEumyxw/ccO
X-Received: by 2002:a17:90b:5105:b0:3ac:9176:e81c with SMTP id 98e67ed59e1d1-3adeae76765mr6903041a91.46.1793047746368;
        Mon, 26 Oct 2026 13:49:06 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066aec8sm743744a91.15.2026.10.26.13.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:49:05 -0700 (PDT)
Date: Mon, 26 Oct 2026 20:49:02 +0000
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
Message-ID: <at-8vkVpN2SF3XgB@google.com>
References: <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 405551A0008
X-Stat-Signature: p5ij3a6zmckfd4s1pooc1jajux71zszi
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793047748-600887
X-HE-Meta: U2FsdGVkX1+xT00K58bLdHjRDN+OkF86Y+s1XPtA1uKwz5Io7TyeDjvnmFfu3KTAzeivhoPDHe9c721KggXhD0YTEBZluCOdP+CH+NfSV5UMQI3oMPr3iIdtP3iK9GpoNzc64pGrfdWbYtBwphUqleDYoqNpyM/A9e8vwGlEvffHaxEXZC8sBzW3eBKcG944Bu5EfYN/xbPTIVPNu1BelKxJW3JLhNFavZK/QK77ANL/YX+UBL9dfr//WMOrCWeZ0WXgZPR8O2yVwTNIunUB0bk3+4j+GfpJe42F7PWcVfLGT4szMuIRQFJiD+5eW/SepOi9ua4lSl8w3B8jSvyndYf/O+qANGFArY37uWKmWi28/f2j3UlcWPFMNdj6bGOkBcJQDJpecQ6qNFJGJgOvtYpcveC3WSpwSO4ZNVyPxVduNeZwxneh41hYcLd2qbIYzsyzSToU1D8hYnNFtCmXYreaj6E+CDFuR+AbxrHzHHsm/OwCnTtkokrHL2eu6IowFb2Cv5iisodktTIwNRr8H5I6hFSr0f4o+m6+QwmGCy/PGGswr7brpcwdSrry+9pbOiwrySfA6abU48WA+rCz6wfa/mrQgE+xgBGA4nymI0YawQVFm0wZAtjStIyB3v5QoF2EPPoV9KvZaGLMEV2gJpBlBPHggBxSOToB/7Hdcu8Acgi92qxOtywmyjVfKX3aPKxiF1F37PfUMLpd4iDlo/E+4h0L6m8siFKNgN0ge0luE8YXazwG1qGfHzaI6gbe4Z1T0Ch6AN1B3lpeN3T06eIwXQrHYjg8GXVi1Nv9LDzVv8I3NL623bSSul0ur3uon15V0CUQLkJdG6HDTZHf+HgWHZG2MX283tZTCTrVPtxcV0dMkwt2StVui3NvZ1OhQ+ERtRccfml0Pqc9cK5KAIj5Es6CEZxETVkDMrM9+toVst2dglioCUc9wsUR/KH8bVr4+kWQDa91TR4L5Or
 XezJb8Gp
 K22Jra+doe95Gy+9lNdNzbSV5Fcy6pkKKuX148SG7eCJgwDhRDuGnA386P1Yxg2wO+lJk5+ga45gmdmbkhxEBCfGY5utP4cdGSezGBNP82S4CASqKvE5nIenBpq49sBy8GZS5gNbl+6IxyjpcMYnmMfkkd9a6fikzl7nrK0Cw8+ZaRn9pG8krg53R92LZit82StvpixtQLp6OXEIsNnh+mCpcsg4qCXeUPk/yiP5sgEJm3fLxh6h2LMPJjmXjlLVjdrkmGYJRtY1JtL7HcWHr3TwkQGc8vGxswNNWfAn/nAWq27EuP5XdjEE1CW+OE/zt6o6K6u1+daajTDjnVnNV65pR6HGLuuhOPZUGtdJy9QC4dFAo0kqiq60DMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> On Fri, Oct 23, 2026 at 9:50 AM David Matlack <dmatlack@google.com> wrote:

> > Sure but why deal with all the complexity just to save 8 bytes? All of
> > these structs are allocated on folios and there are kilobytes of unused
> > space to fit this header. And even if we optimize that we are talking
> > about 8 bytes per FH/FLB... or 16 bytes for structs with arch-specific
> > sub-structs like the KVM ones.
> 
> The reason I care about keeping the header compact is that we are
> defining a foundational kernel ABI and want to use this header across
> almost every serialized data structure so we can evolve them later
> without breaking compatibility. While some top-level structs are on
> sparse folios today, other serialized structs are tightly packed, and
> we are looking to add KHO slab support in the future where tightly
> packed allocations will be common.

My intuition is we will have a small number of headers per preserved
file and per preserved FLB. One for the top-level struct and then
optionally a few more for sub-structs like arch-specific data. That is
why I am less worried 8 bytes per header, even if we fix the folio
problem.

Maybe where our visions differ is when there are collections of
serialized structs, like KHO blocks. For collections I don't think the
elements will each have their own headers. Otherwise the elements could
be different sizes.

Instead I think the struct that owns the collection will have a header
that includes features for fields in the elements. The header defines
which fields in all elements are valid. The field contents then convey
the per-element information (which might include 0 or -1 values to
convey this specific element doesn't have this data).

> That said, in your proposal, as long as nr_flags == 0 is allowed when
> a struct has no feature flags yet, luo_ser_hdr_size(hdr) is already 8
> bytes and only grows to 16 bytes on the first feature flag. I am OK
> with that.

Yeah the header will be 8 bytes until the first flag is defined, at
which point it will grow to 16 bytes.

Great, sounds like we are aligned on the header. s/luo/kho also sounds
good to me.

> > > This is not an issue on the incoming path, we never cast incoming data
> > > to struct name##_hdr or access ->payload directly. Instead, we parse
> > > the incoming buffer, dynamically compute the header size from the
> > > continuation bits, and cast the payload offset to "struct name *"
> > > based on the negotiated feature flags.
> >
> > How?
> >
> > This is the only data structure that describes the header. Are you
> > saying the incoming path will parse the header purely with a void *? Or
> > use this header but just be careful not to access payload?
> >
> > We should have one header structure that can be used on the incoming and
> > outgoing path. We should not have one header data structure that can be
> > used on the outgoing path and one that can be used on the incoming
> > path.
> >
> > Also we need a standard header that can be shared across all structs,
> > not a per struct header. Otherwise you will need to do weird casting and
> > overlays to implement the shared helper routines that parse it.
> 
> Having DECLARE_KHO_SER_WRAP() in include/linux/kho/abi/ makes it
> immediately clear just by looking at kho/abi/ which serialized structs
> have the versioned header and which do not, while also enforcing the
> header when preserving and static-asserting the combined struct size a
> compile time.
> 
> So with your header (and let's use KHO as we want to version KHO
> structs as well):
> 
> struct kho_ser_hdr {
>         __u32 size;        /* Size of header + payload in bytes */
>         __u32 nr_flags;    /* Number of features encoded in flags[] */
>         __u64 flags[];
> };
> 
> The wrapped struct will look like:
> 
> #define DECLARE_KHO_SER_WRAP(name, expected_size, nr_feats)                \
>         struct name##_wrap {                                               \
>                 __u32 size;                                                    \
>                 __u32 nr_flags;                                                \
>                 __u64 flags[DIV_ROUND_UP(nr_feats, 32)];                       \
>                 struct name payload;                                           \
>         };                                                                 \
>         static_assert(sizeof(struct name##_wrap) == (expected_size),       \
>                 "struct " #name " size mismatch!")
> 
> On the incoming kernel we don't use struct name##_wrap, but we use
> struct kho_ser_hdr for the wrapped data, validate the flags, and
> unwrap it via kho_ser_payload(hdr) to get back the struct name *
> payload type.

I still think it's not advisable to define name##_wrap since anyone
could accidentally start using it on the incoming path and we wouldn't
notice at first (especially since same kernel Live Update tests would
keep working totally fine). I also don't think asserting the combined
size buys us anything. The header size is just a function of the
number of features, and what we are trying to protect against is
structs embedded in the payload changing size.

So I would just do:

  /* Marks struct name as a KHO serialized payload with a kho_ser_hdr. */
  #define DECLARE_KHO_SER(name, payload_size) \
          static_assert(sizeof(struct name) == (payload_size))

  DECLARE_KHO_SER(luo_memfd_ser, 16);

Plus helpers that allocate and initialize the header and return the
payload as a typed pointer. Both the outgoing and incoming paths find
the payload the same way, by computing its offset from the header,
rather than through a struct with a fixed payload offset:

  /* outgoing */
  hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
  ser = kho_ser_payload(hdr, luo_memfd_ser);

  /* incoming */
  hdr = phys_to_virt(args->serialized_data);
  ser = kho_ser_payload(hdr, luo_memfd_ser);

