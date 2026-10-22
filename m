Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A93606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Hc+QXGOW
Received: by kanga.kvack.org (Postfix)
	id 67C646B085C; Wed, 21 Oct 2026 22:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6540C6B085E; Wed, 21 Oct 2026 22:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569B46B085F; Wed, 21 Oct 2026 22:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255B06B085C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:57:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3C771C405C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:57:49 +0000 (UTC)
X-FDA: 85348752258.29.188BCB1
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD96B40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:57:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hc+QXGOW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
	b=2eisHo6TJzei9AUAUHut5O8h0XSMM42UAVd5yRVkVeQKEeEhUrJm624ffBk18VrFiNiOyB
	8IFDhTdhJB7L37XmRDtlRczGtVWqe5hnjnXfzJemVf7M3UZ9WCcKel2+kyBY6VFDMtY5sX
	maUh47AnfbsOPvc3jY3PDLvpykJdeJc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hc+QXGOW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637867;
	b=O+bzBW6X+6X+9xwEnCl/ux71WxD2ErrmshROFdKHY8qXrHy7f8IABU8MAUVXCzXnkA66EO
	nNrpXU5SwGPaMuorORc84QgwYLRmUg39cNl8GaCZfKKeTS7PHyy4b7vKWMNIJbNq6/g9Ak
	wEN+M0ozijtac7WgcY9pwwwt4zzRmOY=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so531479a12.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792637866; x=1793242666; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
        b=Hc+QXGOWFXhqSUBiMks6D/JSfOGmzZU83x7h6i9WsZywxo7vuUY31tJNM4FKWVhfLn
         1loYDSyacq6hxQ0aY2HRr5YHCyiLi9NkTyLGdpIP9yBBGT/wcZj5ltz2BR8OaBkdZHEi
         RdKiFM+uxvNY2Ll62mis4NrnGSqTv3PSghyEYkjbDt7K+7roImNXr+hG2ZT9ymz+AF06
         +ggw8lkT4z91cSYGSXva0Ow0lo3YDVFOBpfJLJ9iA5ggyFR9ZTROws/u8pKui26YjHhG
         04NuyjTTvd9zDDamXlpvJRnj+NcSPzqU0K8xCeKm0+kydzM+R+tG8gUCEDhf2qnHNAVG
         bo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637866; x=1793242666;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9EhJunI31x30V5twb29p5JvXR/ZnOh8avGc16eTeBG0=;
        b=LsJS2iGGI3IaKzBPp4MSmarnAq+M7/Dqn/6AG7C3iLCuObDJO+vO/c0N/9ZHaoxZmp
         Su9E60g+kEXPXAw7K5ywWWkL3VuPDVukwTHOaQbCSkjHWS1cF49HQx6ksih8z26dzbf3
         lytW3Aq0o84bGMvJMlV7W+8S/mRtH1VwXC/wlimPaFnRuJlLyYraN780gckUIPZeOuCR
         Q+t3sperbPMHspv7sHURAyGRU/QeTzYFPtWL31Dbv9aEgsUkXoJqTdF5A9Uu4dY2DitZ
         QlU3ENGTRFKsu/P1/6CJeQyapI09iVWQuqUPXiU3C57MtBZs6JrwFFzfOa12AsV5d8TU
         uXtQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1LDPdUVg6rByU3LeSSnH1O+xzRxaMOoPcE2Ev8wF+BFutsxG9NhtEdI2dz6WxKzPsFp5YaeFMoQ==@kvack.org
X-Gm-Message-State: AFq9FYI7GKKfXhx6BB4R3HiwjmKd0QxBgo4l85bNi0QoLiOBjutRp+Dt
	H6jkCgWYge2CKSxOvwpyYsTi7kcfDDBgtGKlnMTGHo/U+k9dxnVBGJ/dYQtlq1nTMg==
X-Gm-Gg: AYBFou0z+wHzV/g0eTp+jGwN7Ft+2I9iDvrr6j0VAwcyX1X84JtXXntJKbfWWhleaaE
	catzJLYNrvar9s3B0qJM2WMyllsrBw62otIXc7e763G8NygcGZ8TOIHmpmnC/qgg4az16JafLLZ
	pMq4Z/OAYjukrA2BbBQ8tuDHoqBqwriv+FbtULS+HPffaMPhqzGJg9lm8SKnw+XMIByMHlKgLeM
	YeF22Oi/ZMwGPZYrBAeW5ys/J6mJs8JtAZY7/mn0EuVK8gjV0M9bdOq0sAls8gncC3OjcJNv0bf
	7cafaOAdXkW5RLl0fBPWnXLiwVNTOo8SQNrO0k9aSZiC0PhFnx5zfGPgRNGQiQOzD32UsKeg88X
	aPZHtZS5xO9lGqQxQDZ1gjveVEYG4jvRJOXsLXeEd3jHw7OMgcOCKK377+s89pR8u79hRFgM1DP
	cZpGgGlSFJbQnGn2jXfQkIIt8BW74DPELAOCoBr9ld0zgMgAvG5nAZ8R3wRaxVnUBAqLHxkzJkE
	aW6JzqKo61S3EYS84dmIaBQOh2D9wcIPWy/4EM4iyUHKyXsemmKEVwnelzNYM+UZ2f8ToY5rPd5
	MpmvywVVI3Dqbu48
X-Received: by 2002:a17:90b:3ec8:b0:3ac:adce:60ad with SMTP id 98e67ed59e1d1-3ad86e96c9emr2886416a91.22.1792637865925;
        Wed, 21 Oct 2026 19:57:45 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada495315dsm2092370a91.15.2026.10.21.19.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:57:45 -0700 (PDT)
Date: Thu, 22 Oct 2026 02:57:41 +0000
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
Message-ID: <atl7peoVHdP5hz7z@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
 <atlKsD-aJB3mJr2j@google.com>
 <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
X-Rspamd-Queue-Id: CD96B40002
X-Stat-Signature: u65zro3oghxhkh7fia614qsa4e89zegc
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792637867-802376
X-HE-Meta: U2FsdGVkX1/4IrrpDcCzKHzOJMlELMJqb1ywx3fZ+CxPPKs0lvojCHvyRXeipcLBBmGMYhelnD58fpLZK43cnBr1898GaKmL/VatuXqCAqF9JQLPFSfP+TCkv6fV2I79ZXsBy0PcdGBLw3jKQbZ01K+Y8VWSWvWiHY7uoTUKW9hSwTO6ixkFfWCyRt5ivjhEPOM6UcLjHZH6Ce4LutH9/RFbfoodPM8qgZuIZtVhiHndKIxj6OJKjCbPKALTV3UjgCRtqdYfhAhp+O+H0e4c2NgC86KEplPoxV/ccmHwmphlA1zoyvMFNyh0e92AkbZMcPn+k5LYH0U+tptOJxrjXPqh2abF+mGwRNhlCqmSvEgx9KzsRVgOoWXv+jlpU0c35yDi/B6StmDQH8WWN4Ngv3ZQ02Ys1rP/ZVXNKBnaH3/+/L0uNGjj6ctUrwUCFIUZ0TQr5FH8mvuEaBtMZ+x/2c+Di3f87z1bbwIYGjhtOw70vMrB5cDWqzt0gBHusKnc8/XeefSlsAQBSzo7o2GAflg5o74MPrLa+nwRqaKUyZTbt9eYNViRYQ1SE8Fa7+RuXKSD1Wfav1VoWbjplni1Y7wCnenlbqsZ9EO5azeUluL/qSfftM+aJ335cMnExWF4pmoLllrkC8WQlbEBIRoMVVFdegjVseAUbZGtnyBaN51l+8fhUzhGwlLAHfwf9H8a3TItH8FPiG4vaTJhlY0ktvEO1kCLHpP99kC/DurJDE8xfPx0hh/Xotsfg1F2hzKdteoLUsL8YZ5d0dpwoLHoaP0sBW0Ttw7f4T2G4O5dvVeWPRCknNyEAL/sJolqfF8HVZhEi1DLA1EZ4fUfiLSFS+HfODUATowp36CdKbHEKY7ISe5XanAvYnMLkeWPF7jKyZ4QWdflT3HyMDCk/YSBt+fQ3PzD3w7Plb7z0FcB1WvZR305tHW8noLWzY4GkLETgp2wtin7I0e5wfeNq0I
 JG89oGPn
 2pHWqchUsOnaNVrEP+GQT77wllU6j/XBdpJptgLVU/hdlWVZPLG6OTbpCE5OXl5k6pM880AaYliTBLpKM1/1DqvU7AbvDA2lm6Q1Vr3AjnYCI22HCyBbHATNrG6Fr2L8wxYalJcdd7LxWaWKGkXb7Aw8zQDMJdCD0wT/xtPT0/1emgeTuCQN5co9FHDW9hR5ZSFs8q7jMtSD0GbwOoCUqYa8LqVq/WonWkm9RFBTP4yo3F8Q01cLXKbPAlUUruU+IfD1rQggkaVUi07JAnVtRn7hbFyH2nr9ONRN1SGZAX1fWu40vrdm5Yez1o+9shOC0KGIR0QuGh74SeLUkMFcFGKywLxMs3I7kUTDeNPbpBRy+mA3RanSCYJkZXdO8vHm78X7lWrJuENU6GG6enf+kJQNucKtOPzYiNuPis1xxQxcdwRQA9jl/0PWMYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 09:26 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 7:28 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> > > On Wed, Oct 21, 2026 at 2:47 PM David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > On Wed, Oct 21, 2026 at 11:40 AM <tarunsahu@google.com> wrote:
> > > > >
> > > > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > > > >
> > > > > > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> > > > > >>
> > > > > >> LUO and its file handlers validate handed-over state with monolithic
> > > > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> > > > > >> structure, even an optional additive one, must bump the string, which
> > > > > >> breaks live update between adjacent kernels. Replace the string in
> > > > > >> struct luo_ser with a feature header, so that the target kernel can
> > > > > >> accept or reject the source kernel state per feature.
> > > > > >>
> > > > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > > > > >
> > > > > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > > > > struct, we only need 8 bytes instead.
> > > > >
> > > > > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > > > > over-engineering.
> > >
> > > 128-byte per serialized struct is not starter.
> > >
> > > > >
> > > > > >
> > > > > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > > > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > > > > bits of the flags indicate whether an extended flags field is present.
> > > > > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > > > > that yet another extended flags field follows.
> > > > >
> > > > > If we will have dynamic extension of flags, Think about this.
> > > >
> > > > To support dynamic extensions in a backward compatible way you want
> > > > something like this:
> > > >
> > > > struct luo_feature_hdr {
> > > >    size
> > > >    flags
> > >
> > > __u32 size
> > > __u32 flags
> > >
> > > >    extensions  // offset of first luo_feature_extensions (or 0)
> > >
> > > __u64 extensions[0]  --> but the size should be specificed in
> > > declaration macro that I showed in the next patch.
> >
> > I think you may have misunderstood what I meant. In my proposal,
> > extensions is an offset to the first extension, not an array of
> > extensions that immediately follow the header.
> >
> > If the extensions immediately follow the header, then the number of
> > extensions is baked into the struct layout. Every field after them sits
> > at an offset that depends on how many extensions there are. If we ever
> > need one more extension, all the fields shift and old and new kernels
> > can no longer read each other's struct. That is the problem Tarun
> 
> We can structure it cleanly by nesting the payload: something like
> struct { struct header {...}h; struct serialize_data { ... }p; };
> That way, the header can expand dynamically at the front, while all
> fields inside `serialize_data` stay at fixed offsets relative to the
> start
> of the payload.
> 
> Since the header size is self-describing via continuation bits (e.g.,
> the last two bits indicating whether another flag word follows), LUO
> can
> easily compute where the payload begins in the incoming blob. This
> keeps the implementation simple, avoids linked lists of offsets.

Oh interesting. I agree a dynamically sized header at the front can work
and is simpler than a linked list.

So the header and the payload need to be separate, and the payload is
located with pointer arithmetic on the header. For example:

struct luo_ser_hdr {
    u32 size;    /* Size of the payload in bytes */
    u32 flags;    /* Bits [31:30] indicate an extension word follows */
    /* u64 extension words follow while the continuation bits are set */
};

/* Size of the header, including any extension words. */
size_t luo_ser_hdr_size(const struct luo_ser_hdr *hdr);

static inline void *luo_ser_payload(const struct luo_ser_hdr *hdr)
{
    return (void *)hdr + luo_ser_hdr_size(hdr);
}

On preserve:

    hdr = kho_alloc_preserve(luo_ser_hdr_size_for(nr_ext) + sizeof(*ser));
    luo_ser_hdr_init(hdr, sizeof(*ser), ...);
    ser = luo_ser_payload(hdr);
    ...
    args->serialized_data = virt_to_phys(hdr);

On retrieve:

    hdr = phys_to_virt(args->serialized_data);
    err = luo_ser_hdr_validate(hdr, ...);
    if (err)
        return err;

    ser = luo_ser_payload(hdr);

What would size mean in luo_ser_hdr? The size of the payload or the size
of the combined luo_ser_hdr + payload. luo_ser_hdr is self describing so
maybe it's just the size of the payload?

