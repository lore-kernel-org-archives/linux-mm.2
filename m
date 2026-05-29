Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F5DCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480CF6B0088; Fri, 29 May 2026 14:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457C56B0092; Fri, 29 May 2026 14:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E2F6B0093; Fri, 29 May 2026 14:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24C8B6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:38:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D859A140255
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:38:37 +0000 (UTC)
X-FDA: 84821318274.08.E8D7E3A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id CBB072000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:38:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pd3aI4Hq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iWiuvGopjfPOqN1ltMMiCqrYpx4WW05J/mF6yDghGQ=;
	b=prwAfNxPFTf356DUuakPNm7DC9VlOwKFZtltBXhI2HLyd+ZTmmOG6NW3k4MOaqKT1WYBb2
	L0p/wdBH3SiWA+xLIj2azoI/R+AhUs0RDjDMYGSSAy1+NPQAZyNIYYubScATYKXQXHOU0w
	thgLObpkZO2Ofjgnnc9igSmA5J/QksU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pd3aI4Hq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780079915; a=rsa-sha256;
	cv=pass;
	b=cz4JcxsJQ1KwD4z27T+HNRhWIaaYIO4GfrBylF0CRwJLzRGrYvvxiof44lMr8Kx9xSV7MX
	6ViebV0xQMcGSTvfJIXnqcORwxRfPVmRufGb5KovIj3Rvrq0wjZ+9aXRE7RRN3XpNdccRa
	jMG3v++GX3Oxe7WBQu8RMjkPiLI16Mo=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso85809975e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:38:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780079914; cv=none;
        d=google.com; s=arc-20240605;
        b=C9akoo8HPk0uB+hZOZllUM6Va3gKgitKQc2rVWrw5KeLggOecTfWBhJo3An3V/w/S7
         Aj75R1VL9SUq9cJZMrGxu7KepKizOiPhvj6kV31srkK58SmszjqmJR5vEF7kAKfEDJai
         GYM8pFGWQDqgSE2QcvqhD0RZ3bCQ1Z9Cq4ByqXL4FYk2alEC4Nu6WlPpPOnE82NoFH9E
         gshLczlmR7MCBsZL5mZuUAQ487D/D7aahD+IT7pk+siS2bSUX3ttlETi6WVC6ROdNppv
         EcusreWeaa7ZBhAEcXF26+3bH2aIoUCnR05RVZvgOGW6dszu3TtzWragH4LrX6tYN7O9
         PBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/iWiuvGopjfPOqN1ltMMiCqrYpx4WW05J/mF6yDghGQ=;
        fh=av1Y1KOHxQmQVY1IZrbtBF0mlRoaBRRPe/NNWJ10Mjc=;
        b=bU8lUVM3NJbGurKxiWPccLvJcPeI/qIhCjEgso9CSYdcz75VGw/gVMNwVIKhYpe03c
         hPvBKfji+NfU4ifvRg3RcXEXKEXLhbUmLvWcQUDeCv/KbC30r6hU2NkxeeqgmyR14/tM
         Z19bz3lR9oees6lRr67UXvUOyT+OEr2jbQhT8Qs7a/eosOjjWlUeCMttXY6lcbpCHhJv
         u7SJE2R4O8t+IOR5aD778w04VgklO1L0khha4NvJTV1VOMSpWEnyoMRDEelFcYGdHgii
         BpYIuk6eOTKAOUp2DkMZpIPlQ6aeL21PIeLz8Wkvpvm5Xy3N0eg6hVTtjGXNIHaz9npT
         bMlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780079914; x=1780684714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iWiuvGopjfPOqN1ltMMiCqrYpx4WW05J/mF6yDghGQ=;
        b=Pd3aI4HqbUgUpr3QBwnJESo6DH3nZ1K7vGe9CdQosHBZ/gZaiyPMx04UUHJqU35tFH
         3T1mIAtrs/Fxbm9IhNA6FrrCrwUatzPGKbmYuKchAaxDTFGO1EM7hGzOExyrg7hfGwFB
         GczQepyDcPr8hI0LBShvN2oY3oKX8o/WZgltIJuJTbEjEspwMhpFYaJCiyctdNksdnJW
         BJteMHimc82KTZZ7eHXHulrHwrki5dMukNK9RUN4GFo1yGdvi/Dt2jAhvDjGnIxYv0iZ
         CqnOTnzBcBBoGBTO2D0b2vE+0yjXwoSyoCJvi8+I9qa8I/ScULVZCGYG6ufSWqFY5jJ1
         hSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079914; x=1780684714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/iWiuvGopjfPOqN1ltMMiCqrYpx4WW05J/mF6yDghGQ=;
        b=fx06aMvMKVbtgOLW+D72WigTZDl6ISzP6lhZccD9fN+W3q/C4ZhiPKb3bLivTGfW5p
         ZL9qQ8U1EKrIza5w/FNKGnJTWSIf5GkdDZf8c6j3RN0IdHpBUXCp0u3UN1eJbt7S9gZd
         YI7Y00gFIeUDKBZU9EssdtfjC9q4L+d/vqu03mb2UwHLBgGPk6hDiLZr7RBowfSdpUmf
         sF6UEIwMfhVtuQJnJnG4oBYW+4U64yWnOKBrNeriqpVTnt72OSfgExjZ5CpA7SOowOlB
         TsS+GAm7ezAVAjj2jFCBWLilMiXmUUI3lcBkJunEOT0+WXU/gs6UuOlbNkg22yIwhAuE
         e9jA==
X-Forwarded-Encrypted: i=1; AFNElJ+wzrZv8E3MvYerbGnYUtARQIzdnaVbNf59oQxI2ksBNnL/jVLit3gkGaIWuZUUnL6vKr3LgkvCkw==@kvack.org
X-Gm-Message-State: AOJu0Yz5rbjt2XtGNknNjrUQpB8YYN/xArLhDZWOYEU6sIKCt8jONXzd
	dkUG3pLIZ7wf2gE1EMSjtr2fYnSsWqPV4mcXeJWNTtBXEE1qchYgwTmDP4bw731vfci3lNVx8IN
	tOsiK6xNxX2MjDMaT9y+kXj/U/LaMlGs=
X-Gm-Gg: Acq92OEBwukXKf8O5nhbEBmBKHDk57CZaRGysSWoTuqm/uZuLhf5Thl/wKGHMWdolck
	vpsvAMf15qadtrsAc/ipKnmkQRsp0+CzTbIgbakMJe3C//FYzzfoEZlQ8XGh824azZbSgcDLNi1
	pLy7d9+bRUb5vMNCcLtjBPchGHdx9LH0dJ39oPolp+82ejLbx0N2G0HnLlyKnHzu9j59ms6yEaq
	rTvpaWQW9JiPZMOyM98zxjfqSKJmPpc6woC5DfCORl7116EwetZFDpNyyT1zlRkyOj9Pb/pS/QX
	TLw1kIYXYLaZqeK6c7D+Cpj2DRHFRs+T9egzUlPfob4JmPSft++CDUaT1QV/7vTtHXUjjSzSvA3
	1aescFGRqjvT1CJSQIIAXOEwtZdfjoKMwXNVq5ldUkK4HKmk=
X-Received: by 2002:a05:600c:34c8:b0:488:ac01:72de with SMTP id
 5b1f17b1804b1-490a2b6e3d2mr7261425e9.5.1780079914175; Fri, 29 May 2026
 11:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260522172219.1423324-1-tj@kernel.org> <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org> <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
 <3901fe0537edee9d7acdfd91695ead28@kernel.org>
In-Reply-To: <3901fe0537edee9d7acdfd91695ead28@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 29 May 2026 11:38:21 -0700
X-Gm-Features: AVHnY4KtV1pUn-d6UzBaLOg5AUfIedwDfvDWPug9r5TxPVQH38dOVxXqqoga_T4
Message-ID: <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
To: Tejun Heo <tj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, David Vernet <void@manifault.com>, 
	Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBB072000D
X-Stat-Signature: zrhkz5wtzqjr7wcyq33z4d61938payhh
X-Rspam-User: 
X-HE-Tag: 1780079915-201179
X-HE-Meta: U2FsdGVkX19FRdXXWH7ZMUSnHgn1Jdl3Cse3URwvhuleeHotZUfiP8iHQt2BVuXVZ4EbVafasJmsdq/z68WEFHvJBiN6MDxn3/Yd3wZnyyEPD35yRkX+vOGLR1l64w48WoWDYopKk7hfT3Kow/bh3OHW3P0twhfKv/B++hsWQo/Fa7Jt6TIiiAvrawM7lcX32xdCg5PLdvA/dncwqpJrUkEvmddsp3L0lb8m7/Fac4Klc1rbxd5e+VPAQgVW7zrbh8NfR+SHo2Xei+shojOJT1Jv4foh4TlOGGomZV6+OdZT8wji5NpPP25p3/19NP1XJ058aC2sBJuLo2NuLWakpu3h8JPrP8tpbvbXgvobMoCsFV1lcqLrUHiveUJTrayqfgmSozNGAKhv6Sv/KFdSttm3NwGSumzpdMECPfrEXb+TJgXy1Q/6SvCZ9O+El74vTyCbx4EOpXsRydYFlMvSRfBiYeNKkYz/CZrVQWFedRThVeuWyVTx49dFy3EbSYpdp5JPG4XWD/RGHOPMZS6jnn0MAGMKgrkX6I0gGGfOXuG9M4ayLvXePxzNAm1K0zZNNX7Vz/gQyJGuE2berEjELSdymOiqfAjKw2CJ3RUIRWUzMpQLVZP/qf5v6NZuebUxkcZ43d6rE3rleXEn+5CJEqfHew+fhoBtDDLgwp3g6AxQ/RwCYEDa++FdXzMFyCqxFFoJtxd4pjVtxZ/ybMHbFR+l09i7MKWyRKm7D1JBeZWykT7JwLQp/NZICHyZv4L69/+euEUTW5NdZrZGF7AiNNTsUpC2es2UcUlttCZio2WSEDfZiwaKxYgJZQwBaWFyCZO3UpYl1FM2ZYex72+BpptyDxCs+RzVohU5V2V/m2fA+olnXDPj75Lt9Tk1aBeLEoEmxD1RNiglcJXCbToYtcaJ9XTtXSvqy9pThywzApXutNXmCXHbOyWsF2n6XOSvjp4mrOdPDkeljj8syyz
 lYSQoaqB
 eMy28AiKkYAiyXhrRlWqHq7IJSMj0zmIeKT0/lLjlhcpox+DpGslUqNi9U1UTYiz8Ib7g4pp6lobCyMeOrRdX9WjgKWKWWMvuv1QNurZByrz9E0hgrfyC7zor3U2esyHfbfZbjNeEAXcN4Wi++1m91o3iDew0z2Nm0WHqbhN5rMoPjziM64E/FYUS0mopUMvsY6x27W/IU/g7klv+fVT+FZuoW+LU1wH5iGoUYY6DIk8mjqU88oO+amHSJlifya6T2mwevtBGpe9tZJYh72rGGDuEdrB4o+TaUIzlT1Wc5+5iGut6lAB0WGC0iy49u4vL2/ib8UdqIAMFNl0x8aNkULoUr6KCc9EJhDsTNHffPFwSshwKOgssw2g1WrEkHBZJLNH/ZpNQ+dX1aR3+yCxxa9FNt1Cx6PmmVdiQaLQdFROZ+FI+JcRh2ghtqA+BRhV4Fx2K9l+PPOJaY+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 11:12=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> > It should do set_pte_at() unconditionally.
>
> I think two concerns are tangled here.
>
> 1. The racing write. set_pte_at() and the scratch installer's
> ptep_try_set() hit the same PTE with no common lock. On x86-64 and arm64
> set_pte_at() is a single atomic store, so it can't tear against the
> cmpxchg, but a plain store racing a cmpxchg isn't atomic in general.
> David, is that the worry - an arch where set_pte_at() is split and could
> tear - or something else?
>
> 2. The SEGV. It's a BPF program failure propagating out as a SEGV. Maybe
> not ideal, but as long as we surface the BPF error properly, it doesn't
> necessarily seem broken to me.

returning EBUSY because apply_range_set_cb() hit scratch page
is SEGV out of arena_vm_fault() and arguably ok-ish,
but bpf_arena_alloc_pages() returning NULL because scratch page
was in the range just sucks.
Earlier bpf prog passed the wrong arena addr to kfunc and triggered
that scratch page. It broke the contract and kept the pieces,
so ok-ish too, but overwriting scratch page with proper page
during bpf_arena_alloc_pages() is imo much better behavior.
That scratch page will cause all future bpf_arena_alloc_pages() fail as wel=
l.
Hence I prefer that check removed.

