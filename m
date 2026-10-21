Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E649B606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G5/BThqd
Received: by kanga.kvack.org (Postfix)
	id 0FB7F6B07E9; Wed, 21 Oct 2026 19:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC8B6B07EA; Wed, 21 Oct 2026 19:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDEE6B07EB; Wed, 21 Oct 2026 19:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C73986B07E9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:28:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A487C0708
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:28:57 +0000 (UTC)
X-FDA: 85348225914.28.4995E18
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8289BA0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:28:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G5/BThqd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
	b=xF35/yXhmDbaHzIYzUTBphos1+jxkBviRgpe3N0UVUPGmMHZkreC6T9RsX8WWyDGCvEGr2
	H6jycm0Ew6JqkDauywuSFE0kY885Q/HISVcejZEABXMTIskZAFRpwzzo0ewzAn1xz/tLbv
	Ggl7kEviwF3NQHhj4cv70V5byqafIOY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G5/BThqd";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625335;
	b=QfhMKb1WLarprL19NNZOTEFBv4qmIgqBnY4UbNwD8BtJyxOXcgIbccmXJGry3qSGVYMV9+
	8yXhkwDeCxW5upa8LoMNadz4kO8QJYpUa0zlJPo7MqHpOZQCLf08K10GARG241vkqPAM/c
	+jmfVRgKdjQSn6XcAzUCOFtGaeEuyoo=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so686296b3a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792625334; x=1793230134; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
        b=G5/BThqdklaTbMMpc6QwfOZ/i0d4gjLBXbkVleKvYQiz3pQdtM3ShaTW6c3760o2/d
         8uL9VwgE+u2rFf1brWtD91PxEvTedKAnPNyAuc7FllGvTgSHhJ0ZWRPRI71ypmzMWeWT
         hB4pY4gSq/52/bhukVpIjcDYnslFTy/wRMhHr9PpBJeG8BFy7pgT21iOmLxiGj57HeOS
         srPI41xRa5zsdz1DSWUKS+iY+18JCWZzM3BfB6FIxU9qZVO1WoPRX4pFfEuenfut+mM9
         96y52YtAaH/BSK7iDRsazGy+syRELT6eiQLJgRmrQHuLfFPe3Tv9lbeVUjgrXjFugL3i
         wwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792625334; x=1793230134;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j1gtu/2ECGchElAdjQsJmcTzWPpoWAuSh1B1l3W6hUU=;
        b=oFRRrNLkDESj62Sxl/Gu6Y4ignZ7ZzCw+sHPhoS52JbjIA0JNVX8kgBkaa6thnPWDm
         6FAobnUEQcNhVlY2o06gKCsu/EdXN8dh3OE7hm1j/IpJPOOb9JLWZVDOZFsfJvW6wn5w
         9PY5EP13QHHVlb509jQDyeYHJyCKPl/eK6W3TRuNvzLr/0dKNVHUae/6TE79x14s19K/
         p4lTqHGsnWsibPMx2aNbr9WibIHwwCUEw/ByhPdPFOi2By42g/yCncbLyoiBhuygKyi6
         aw9b5hUZiWF7r2d7YYuakCgNMc/rsEFlrNJo6FhEjboNOeu8ej+Fw6tiAeJo7TeKy4MK
         /CUA==
X-Forwarded-Encrypted: i=1; AKwUvBwMYady/q0tRYPUOQTSuqzGdXA6KI4x8VTxGTxEpHJ9yMjySJL7WlsMOmhnNiWRugKvJpsHNRuxGw==@kvack.org
X-Gm-Message-State: AFq9FYLZjoBVu6YH61j1WJEyi1zTeSIXCMKBa/DjKB5nnXUwnZIET3DC
	qghrmaSUhsGdxh9ZgN8idjv4dpEA7XCUZOJsKTNwf3iVaROaI3HHKmt62fZJLapJWA==
X-Gm-Gg: AYBFou2OUWZEnW1oOYfH9lGqMO6ocHPlPqxqgVTbTcOWp6jA7Y4q68BBC/LNbxEC/z9
	W+shxu00/1P2mAa17cca+vIFbsuFQxAuCydokO3DUnePtBBRZTth1b56bZvbkuFAiuPhbbafuzM
	H7abtKqLdCo2bEYLYBgn+HeyfNqo7tEuJT4Peq48RX2MThTASG5w1erIV/I9osSiz8qtx3L7NTN
	ScrlbqmMTREFm6TzGZKiC9af2G2eK8QCdM+TmQ5c7U4i0B9avLlsKviOVrLnYswsGvxK7aGX7nf
	2YcYoyfNFGmGHg58uZLn6RzayPbkNojJuy4phB9UNX5h3N4iiSQAaTqw/hV1NbBt3WCI5yzphS+
	CxABmJHfRkzVBw7ig9y/ByRaiZPCeRFTu4P0pdUXOH9TYStXLodFAj6ZEcuXrgFwea6OQulozqr
	HMOE0n6uz1tATePFQtl+H/vu36qk7H1BFDHs4Gk0WE6xCQGF+h8wpQ6HJ7fi99FNA9kFqzYIXH6
	rS6znJTSpraZgdC4Xrhel12Saw1MJGBDEKqH3PLrGmECODVyrm6ul7Zex3VHpQE1rbQIH5fvk6S
	AW8l23ZMarzvDcpd
X-Received: by 2002:a05:6a00:448b:b0:88b:7278:ebf4 with SMTP id d2e1a72fcca58-8a089dc6e77mr2781314b3a.18.1792625333734;
        Wed, 21 Oct 2026 16:28:53 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a08933aec9sm1368611b3a.2.2026.10.21.16.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:28:52 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:28:48 +0000
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
Message-ID: <atlKsD-aJB3mJr2j@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
 <9huzecdi6go0.fsf@tarunix.c.googlers.com>
 <CALzav=dLdJoVy=B1pv0FAurD9OhAzLSTjJNbtjTdJRmSqaB0yw@mail.gmail.com>
 <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAQRMAEXZyHTEuUN0_Fo59Sn0hBmYbme_J9ewjx6gPyJQ@mail.gmail.com>
X-Rspamd-Queue-Id: 8289BA0008
X-Rspam-User: 
X-Stat-Signature: ofzk1qbfqhtacaxcuior93hhs6w39jj6
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792625335-499132
X-HE-Meta: U2FsdGVkX18alOD/rMU3DGPbNQ6bveiJIApyX8ZqKy1JePzjvuB8bvWlyJNgsfHg2RYIb2XVKsY3Jy46Sm7pKAcNpQYtWcHKw9pl1WEQffIpZjEoM6PG151LlXdLx7rRD8kkH0GxyrpGzt8CC6+XbyVXU+dOrW+m0odJUmzbRHyRCysFPxy54ScUfqkGLKK449eZJ0ypHNPnnD0HBx96MIiSqaAmi5n3xDvK6znkKaqxNymrdRpZEkDGA3j34uW9dgbZqWKfWbwjrvXdq454qKIIyNB3dGi4C8JrN2jpkPGjrWrfZ+/VfUWq390yPynSAZYoPFwg6J3pw9ilruy3i6SQokb7reRePvI94qU51hsBDBQJjbSVXnY2hcN+LL+JHkyZcleWWbNrCkcRuZhcl3lVVc4pHSsmucV8UjlwOOwoFmKkb2ESxjBqBeLgflwppFLyLBszrlxSd6RK66W+9Qj3JECYd3OaNpHvT3nQDaXrPHNhGTuBwfhFSDUP86F9G96tqOwyu1cC0VOdsRGVWvlYhDtYdcBlQRlpdF+eiEMyENN0PsJquZzQExmE+Z+b80xzWdlFBvXF4D02t+tcW6HBzNc2c/fTMGxoL+wKcvKcqYwngqxoXyzZaEsf6yoBz4k0ACDY1LI2ENdh+MujTPtjUbWUt50cl2RU4eTEaOyXJpchSP6G5Tu1uRFfQa9D7Tv0ckIWU0tdUqwvwwDYOhsovGQZA05Jr+1KksEv0yiRn7EDhpX3K/nIfMRRmTmUadbo1Bs5wRfIEgWuG7JD3wDJIXR0z3evQIv3B2FNVnaT6rB+HWUFthqDxRC4CFVw0EZmRnyIOvoRapQ7UEkO3hqT3P0tUl/nQTFahm5BVQJe8ubwk0BMGFcY9jfrV5UhHFfqNwRDpTf11Qr6FhH8GYgqZFuGnHIdbSkmSlQgE9JbI7cHyRL3womQF7/EMpxYdNvTOH90v05Y6/hSq1M
 cEsH9XnC
 KioieCCoCWH5tD9UEsuAdqxFDMNz7/YoH3UJcg7z+/a2jv0QFNFE/ZasE3C75pCbV9264QbSfqX2Spp4QJk+kW4Ihl4ktR4Tcpem5NoW0IqW7uy8gFEloAuDmKaTluRRXhKg0WdHnVVzOD+haXnGvJeNXsQ64ndiirYjhwakDlFDC0KeMZpVpWEhR84xC+O41dhbDEGuIVfAnoph/yG79UARTK4Sex/T4w1gDC6+vD866NXiyrWNu9kgqhrXnp78SY9b0J3RtMdSeUuDl2CLc0MyZJDLx/+T2hmdYrwJqHDaECkuFs+zGq6m9NRM3cxs3FDrQtkWNAmzIb8YbYG4gr0AmW25TQT4ZNFhstJV/46X9p4kzqWupHfbyhUw+RD7qKebBoLVnNt6lm5FFj+JsJbaRWupyQYlDVjYr+vlHx/htMIGLAirLQIEzFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-21 02:50 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 2:47 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Oct 21, 2026 at 11:40 AM <tarunsahu@google.com> wrote:
> > >
> > > Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > >
> > > > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> > > >>
> > > >> LUO and its file handlers validate handed-over state with monolithic
> > > >> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
> > > >> structure, even an optional additive one, must bump the string, which
> > > >> breaks live update between adjacent kernels. Replace the string in
> > > >> struct luo_ser with a feature header, so that the target kernel can
> > > >> accept or reject the source kernel state per feature.
> > > >>
> > > >> struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > > >
> > > > This patch is all wrong; 128 bytes is far too large. For every _ser
> > > > struct, we only need 8 bytes instead.
> > >
> > > NOO, It is not. It is intended to avoid complex mess with unnecessary
> > > over-engineering.
> 
> 128-byte per serialized struct is not starter.
> 
> > >
> > > >
> > > > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > > > 30 feature flags + 2 reserved bits for flags extension). The last two
> > > > bits of the flags indicate whether an extended flags field is present.
> > > > Each extended flags field is 8 bytes, and its last two bits indicate
> > > > that yet another extended flags field follows.
> > >
> > > If we will have dynamic extension of flags, Think about this.
> >
> > To support dynamic extensions in a backward compatible way you want
> > something like this:
> >
> > struct luo_feature_hdr {
> >    size
> >    flags
> 
> __u32 size
> __u32 flags
> 
> >    extensions  // offset of first luo_feature_extensions (or 0)
> 
> __u64 extensions[0]  --> but the size should be specificed in
> declaration macro that I showed in the next patch.

I think you may have misunderstood what I meant. In my proposal,
extensions is an offset to the first extension, not an array of
extensions that immediately follow the header.

If the extensions immediately follow the header, then the number of
extensions is baked into the struct layout. Every field after them sits
at an offset that depends on how many extensions there are. If we ever
need one more extension, all the fields shift and old and new kernels
can no longer read each other's struct. That is the problem Tarun
pointed out. So in practice the number of extensions is fixed forever
when the struct is first declared, and we have to guess up front how
many features a struct will ever need. That's the same as Tarun's
128-byte header, just with a smaller guess.

What I'm proposing is a linked list of extensions, where each link is
an offset from the start of the struct. A new extension is never
inserted into the middle of the struct. It is appended at the end along
with the new fields that need it, like any other new field, so existing
field offsets never change.

Something like this:

struct luo_ser_hdr {
	__u32 flags;
	__u32 next;    /* Offset of first struct luo_ser_ext, or 0 */
};

struct luo_ser_ext {
	__u32 flags;
	__u32 next;    /* Offset of next struct luo_ser_ext, or 0 */
};

That's the same 8 bytes as your proposal. And because "is there an
extension" is next != 0 instead of reserved flag bits, all of the flag
bits are available for features.

For example, a struct starts out like this:

struct foo_ser {
	struct luo_ser_hdr hdr;        /* hdr.next = 0 */
	__u64 a;
	__u64 b;
};

Over time we add features and fields until the header flags run out.
Then we add one more feature, FOO_FEAT_C, which needs a new field c:

struct foo_ser {
	struct luo_ser_hdr hdr;        /* hdr.next = offsetof(struct foo_ser, ext1) */
	__u64 a;
	__u64 b;
	/* ... fields added for features in hdr.flags ... */
	struct luo_ser_ext ext1;    /* ext1.next = 0 */
	__u64 c;
};

- a, b, and every other existing field stay at the same offsets. Both
kernels can keep casting the KHO memory directly to struct foo_ser.
No memcpy() or variable offset math.

- An old kernel that knows nothing about ext1 can still find it by
following hdr.next, because the chain describes itself. So the old
kernel can still reject the struct if ext1 has a required feature it
doesn't support, and ignore ext1 otherwise.

- A new kernel receiving the struct from an old kernel sees
hdr.next == 0. It treats every feature in ext1 as absent and never
touches c, so it never reads past the end of the old, smaller struct.

The only rule for subsystems is that a field can only be accessed after
checking its feature, which a LUO helper can do by walking the chain:

if (luo_ser_has_feature(&ser->hdr, FOO_FEAT_C))
    c = ser->c;

If we keep size in the header, this is where it would be useful: LUO
can check that every next offset is within size and strictly increasing
(so there are no loops) before walking the chain.

> 
> > }
> >
> > struct luo_feature_extentions {
> >     flags
> >     extensions // offset of next luo_feature_extensions (or 0)
> > }
> >
> > And then an example serialization struct would be:
> >
> > struct foo_ser {
> >     struct luo_feature_hdr header;
> >     ... fields ...
> >     struct luo_feature_extension extensions1;
> >     ... fields ...
> >     struct luo_feature_extension extensions2;
> > }

