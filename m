Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE270C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349AE6B008C; Fri,  4 Sep 2026 18:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FEA6B0092; Fri,  4 Sep 2026 18:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8BC6B0095; Fri,  4 Sep 2026 18:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87A86B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:24:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4682414024E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:24:30 +0000 (UTC)
X-FDA: 85177509900.30.A5C6AB4
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55669C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:24:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ESICFc25;
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788560668;
	b=C3q6N9wh3YrTRyHZJ/OPhZW/UQv3mWJWK+UkSTl7O5agc4C9ChK0zVtY0TsJu8xOwKC6vS
	WNoOnlny33/XKACx1qMqXcbgqsxWWLYAfXLCyZHT3gx8akDNH5blbreFqMcZBtBvL7NJ1x
	37KkICtKl/rh+y1PYbtnHX4phtcmyfY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ESICFc25;
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788560668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSoy4tzP5/vZd/n79Ub53Qw/sODynJmx2A4LOY3bVO0=;
	b=4RZJ0M7Wjm7PdHQ6RmtS5IVrsv0TYatDO+sp7o+VFZw+WIldhF5MtWEJnx8cvLqhuUb+ON
	u88HzODzQNg6uPY8AHGgwtT+u0ry96G9HtnznVy+kiVtqbQt0VhzL43XzqjG6uemhVp++S
	i32IcayRFMulQcDEnVJ3y86sV4oILRs=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1c3c90074so1304806a12.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788560667; x=1789165467; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eSoy4tzP5/vZd/n79Ub53Qw/sODynJmx2A4LOY3bVO0=;
        b=ESICFc25xgEM5D7Z5+pfLDWo64TWzzNAWzlqCnxjyCoL9QEf+MULNTqWw9XPaebdlE
         /+8sjURCw/Cepsu5X4Fyqjr0rtmhMaDLIzla7j/9zEp182SD9tT+/56T8DPZeL60BxXx
         lidHW2K2TYjerTlnXFCm8IlqBpf1YLCa1awPao6K4+YmUVQUQKyJYhzRg5YpULMVrKxk
         Iwjd1iBSDb8hLn6+ce2eY0v0gslWiSqiQ46LF9qXl4TGndCdYgX0BqeqD9l71EeNS9BN
         mqs6COS4hK+67Zf14ZVhkBxD3yuXi9MQd9TAXKoxCAJtCkxG9UMzpUWnFPTTKH5wTziF
         Aecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788560667; x=1789165467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eSoy4tzP5/vZd/n79Ub53Qw/sODynJmx2A4LOY3bVO0=;
        b=FJCFWqa2o+RREWixWxytoe/gD1ZpLA9t6fK0fj60KEdwml8guTbsz1/uOTZ1OxDTjV
         OgbP56uxht3MiQv3CIhJi5hjd+JMzZ9FhTe9jKaXg4FtfI2Trnz0ZzqSGYcZb3naV185
         HKTC3Jn3Ny5AalSwsjISj8wXRkiD+RZNadN+PSXUvdUySpAZU0ThQ6NsPX7Juh4N2L7g
         NxHbw8HS1yTdci476WLIty9RdOiDJiaNla3/MH4mLvnyM7YU2v9dUMb52Tdvn7PRlTNL
         miJZ/yTGDnCpcFi96+rjdYDt9Wc1hAnlqjtyWFP1fc38p6hMOSNHUztH13N9R85gRCTd
         jwkA==
X-Forwarded-Encrypted: i=1; AKwUvBxi+O5Nh6DhivHuSuicC7TdLqDwZMRMfug3FPK5u06yF2vWFAno/lDGPLae6EhUh+z2iZUGs5XrsA==@kvack.org
X-Gm-Message-State: AFuF++nT9fwE2nkbAphRh60hcH8FcyRn6CNWFBh4j53wznwL0v+6DAR1
	oZya9h0JbGq8iPEg0WQRYf+Ak0lthoHtV44UQ1K+8q5Jf3z9istdP+d+5hyjIh7gDw==
X-Gm-Gg: AYBFou12yeB+COWIYvSgiVnumXJcARkPQMH76z3ixpFzAodHVk57QUM4HkNp8fdwx7D
	FcEEHLn0oeG1aZ3m6T533Vf0EHQo5X5NM6bEjxuD5d6w+k7YB9dsmSNZl2YEojXHKseLXPqMopX
	fZ7aHs68yhLJG1vbtK4MwkuHggtRxAtOeK//UB5yemN3+agpVicX7BpcMNsxkVBbhlw3FOWhG7Q
	/ZOi2kkNzojYBhR0TXIvO6bmXZ4b+2qVGJ4uyxKWDEw07ZCcwdG6h2P05ctzGZwYDZi0Qy/mBAT
	emoM3pBfI3C7Uj29g3OhSsEFj1900PQt4+fSUHx0XVPcXwSa2GTYNZywSN1Dmmi2I5ZIKdBlwGE
	MZlOQKaHsM3/qmcOGZsdwrNi+6FwpxwYDdWT8iYXMbfkvaJSUUlgQ/r9LTQTvq8IrjIfAVrl14K
	gEvPe2vB/RhgpzMVWeD/QOxWRJ46HN2X4/N5uGOvzCYU8gpaFkuTO+eHnWBAufMdG0xetSf5tBE
	MftclOGaRd6rWv2chgs/6aHrUWhEw==
X-Received: by 2002:a05:6a00:2e99:b0:84c:4b58:2cec with SMTP id d2e1a72fcca58-8616b26f6bfmr12056954b3a.15.1788560666130;
        Fri, 04 Sep 2026 15:24:26 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153a1c1basm1621740b3a.52.2026.09.04.15.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 15:24:25 -0700 (PDT)
Date: Fri, 4 Sep 2026 22:24:21 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, seanjc@google.com,
	bhelgaas@google.com, alex@shazbot.org, kevin.tian@intel.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <aptFFYqcSiBdMLE8@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260904160009.GV4157646@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55669C0003
X-Stat-Signature: d6iz8wcunpi949xibrqdxucqteg4qo6j
X-Rspam-User: 
X-HE-Tag: 1788560668-973771
X-HE-Meta: U2FsdGVkX1/bamBbn77kxuDTfjpJ+2WHBAHxmzpkgdmfkq7500nzDrELrTc8L1MoMHLsZfR2jjvn5HyKWFpVjTgqBQTd3FwyVSRyPIKIFggnibdCxDXwUgiF9TwV2E5oWUyiBSseFZqhbnUNyOFYZdFe8cBhyyU5EOh4vD9ffAoUQOnbuqkWUBab2Q3oZ9gyvt83v5ZxwVt4TcnZbY1c02lVAc3xLqWhlHqvLa6pNX65cWvsBQHmmOSmfItmj/gI5BJdd8wXjo959zQyvIti9Je/Xag3XDAVHu6y2NIF2mlsYwNJkoYiytWnCc0Cu49QxLyYSH7H10so0gkuasjVLoIGljFo5rI8OFblmKjX7B3WVQK3qem2gxXxt6n+rq3Z9koyaGadCR2Y/I7r0yDZUs4xN0BMedWlODjSQFGODyYTdfCS471HwhA8COLHZClir7hB1dPsj/vcYmio2LDaMyXFQ1uhflCANDhINkUjCk4Ym9M9gYwotTOrpeyP7iYE6Ipo4rjSp6EPS1uJwmbz4BTU2WCoyFciiLlnC3fmdVRR79J1m6N8rz5PHTNprsxM8eW3VjhaNWEUdaqVIRY5SLj36RXAaAeORa3VuXTGIGfzgmmFRomW5JCySyCd4/ATMJuaWUp2Q/eKN1GEEcYHZrCl3GcU8koxq+XVR2gLZ76bqHBiyAfBm7gvQQAKJS9Qpg+3Qm3Fjm1Qy1s2O7uH1X6QZrvZJwqgbe2oY8D/HEIC3st0YxpDnRiIOpVPrc6m1mZpr1dYRTcNqBI0qXCbUdccdX8bZZANOm4RW1hUay5nEs8GB3Tp8uG45TOuYXgWe5mWODPdLGFeeIRuQZqpgcWz7jdjvPcpwImUYrY9hSnjpiMbj1XXWVayOAYMQ28vWOUxOjW0JoTI0BuS69yS/ygPiXoQpafv49ArT0PlcLyUYSBIzedwyjvm9TfdlohciE8Eb7Hj27qhK/kFJYA
 XXFJ/VIf
 1CTwEJ9EIu/pyq6Xp2MWz8+9RFZV9MUn3iHVyPA3orkzJSud1VtwvmaFOICmkzE/E8UVOKIUK6xZW0sYWcs87J/ZeCKCm0BKtxm8/OBAalWcdVoEvWnbc8bhUHw5pBneqklwileAR1Mpq1xZsMLn+kJTKvDJs4MdPvegov6nrdVe/bze7xEXoIu8gIOaPY5EcvMXY0PeGqKuDs7Sxig7IccVrgZ8UgloCKdFJVFjVT/8ckiXs1f57/4fG+h5krxInjw8Xv2emWB0sT74u1uW0MkYqnhIeiFBONGdQcB+BFFamqsVXz5nx/BG4lw877UdXLJ405Q9ILxBXLfPTdKDeuM3ocoAJ27lnrMx4/VhvtxrTSEW9RL/2dOOVkZfvk/FcWLxjZVmRAk4m506oW7eiZEomnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-04 01:00 PM, Jason Gunthorpe wrote:
> On Wed, Sep 02, 2026 at 07:34:49PM -0700, Logan Odell wrote:
> > We're including maintainers from all subsystems that currently is or
> > will be expected to participate in live update to ensure alignment on
> > the path forward for compatibility.
> > 
> > Currently, Live Update Orchestrator (LUO) and its file handlers rely on
> > monolithic compatibility strings (such as "luo-v5" and "memfd-v1") to
> > validate ABI compatibility across kexec live updates. Any modification
> > to serialized structures requires bumping the version string, which
> > strictly breaks compatibility between adjacent kernels even when changes
> > are additive, backwards-compatible, or optional.
> 
> That was the intention, I aruged strongly that upstream does not want
> to maintain a CSP matrix of endless kernel version combinations. That
> is far too much work to push on maintainers. Upstream would do much
> less, maybe only same-version, depending.

We received basically the opposite stance from Sean regarding the KVM
LUO ABI:

  https://lore.kernel.org/kvm/aoSCCTTBn9D5hqzk@google.com/

So we're trying to use this series to get some alignment across LUO
ABIs.

> > This RFC series transitions LUO and subsystem file handlers to use
> > granular feature bitmasks instead of compatibility strings. We replace
> > the compatibility string with a header structure that includes some
> > reserved space to define the features that are included after the
> > feature.
> 
> The compatability string is only a small part of it, you also need a
> serializing ABI that can handle some random mixmash of these
> features. Ie the various TLV schemes that were all proposed. What is
> the plan here?

The proposal here (which is inspired by the KVM UAPI) is to ensure every
LUO ABI struct has 2 properties:

 1. A field to encode options/features (e.g. u64 flags).
 2. A way way to grow without breaking backward compatibility (e.g. so
    we can add new fields).

Each flag can mean whatever it needs to. e.g. It can indicate the
precence of one or more fields (i.e. new fields in the struct), or it
can mean a field now has a different meaning (i.e. union in the struct).

This would enable adding support for new features without breaking
backward compatibility. Downstream users would have to ensure their
kernel does not start using a new feature while it can still rollback to
a version that does not support the new feature.

