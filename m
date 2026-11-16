Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C40606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=GJZa5fT2
Received: by kanga.kvack.org (Postfix)
	id 167106B05B3; Mon, 16 Nov 2026 09:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118286B05B4; Mon, 16 Nov 2026 09:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006296B05B5; Mon, 16 Nov 2026 09:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB9106B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:03:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B4AD140910
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:03:07 +0000 (UTC)
X-FDA: 85441148814.01.747A9E6
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60C67180020
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GJZa5fT2;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.224.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794837785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
	b=tHWvZRYUAgAwLK3h7npCxhtFpS9FPY+OHZ8+NV/9eeTEPkN7G+1HfZfsGxDUjnEmNrE27B
	toITqCm2PjFYXPiHljDSS6jPwlskWVuylCuC0PrTVZfdSjtStYUGNtAJeQokp4al4PW+qr
	+yaUVyx/3VpSLY6D+afj3UWw0FcKkS8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=GJZa5fT2;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.224.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794837785;
	b=hGKX1solGSXUB4LCeJDp8HaZDu3cpwoEWRXLPEFnOV2kPGvOAMhpFOy+hFRHYctEtoYL7R
	H3bAMN0Jtn4Ia9ss6T9hZgTlXv0iAx8xyLQGQOHucuY3lODa564KIryCfo7Ojwr+yK1uyd
	F+Uc2XNTHbevArdhi26lbXPgMhg2aO4=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67990a45e02so3580262d50.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794837784; x=1795442584; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=GJZa5fT2RQ1i5A1HgfxGHPaHZdMyIsdnaFqelB5mbWiN5NGyu9IhTlEh/sDt+N+a2/
         3D7zpz2RyGFcJRdsGp7VppngLLtU0ZdyAm/S3ZC/DJmVwxSGeZ8aFqrl6vF4InixlUeM
         Mqkii7fwNUNvoEa0ay+RlfEK+BHh7KUTk3aDAe9udSSHPh3EVGa84Gpd7JDhV1daLK8x
         NBR9tytpmBrIo0CalceKeiSIiLsd2jXZPR/IAu+1kj652SWV2jHud3wgP27JzbvDzjXR
         k/2BzUJdctig0lhIRmnjW5CWVpNY1HzLv3CNw5k2AHlbNAANxBVumVz9QV7ZtxkEcv4p
         e4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794837784; x=1795442584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=hPjjKa8j7IpC1MEK5kusu91P+V/SrfJNrDWn+d+A+1nCck/kipPmsgN1E6c88cdYf1
         PLcIAyhwUWBC5xE8t6TObWFWCbSNCzzwFihSJvbQGyFsi3PFO/CKreRtIQxF/Oxyj+xO
         ugdHoSZGjYPMJrjeZjb53/12y2CJExbUWILxbtATTMna4lPF4kTVEQs7LQhM+OcCCjPA
         OKh0Uwm3bK2CRFiWZIlt2fzYiWfflCd44A394ZTBsDFhnYZwdxnUDQ8C2sJfP2Ml/ots
         m+dp8QUAiKx8Ka1QuWEFdC507vW+ikUVXatVziFFZYXAwvkbykTiuaPogg0Z3eiYyutP
         dGWQ==
X-Forwarded-Encrypted: i=1; AL+hErFgJQJr37JL1rh7TpODHuLt4+V7tFsOGz5PqL0FgRJyQkNHrrri2qvNk/H9C5nfiyjNXtYrmW02uQ==@kvack.org
X-Gm-Message-State: APuU4Z+QaAwGZkNsWAt3ZHSHutNCS10jdZX+aynTZ9NgWTHSVZFDiVkr
	oD1RqDnDaZ5+Dc4LHtStWswtZm9q84PGirLYBfvokuZdkBuM6wU4FMdXNik0XDiPfqY=
X-Gm-Gg: AZFdTZdxnlSedoG4/qzcDWC8893bjH7FJRZI8nKExeJG9j6aeR41iwnJ6tly1L+L8Ab
	AtyeBbh8wq2C7UY+t+JB82zKrMghjL3usthPrTMP/ip8yvS7V+nSbYGdPrLKDp2X4UffazVEmly
	ZdSB6z+66lRrTj6CVNj65O23xmiivsu7Fh//TtC/Rt+P0++WjW7mpIP7AmqaeCc/kq5z9UUON6Z
	GsMEio0qMMBXOSCT54SGao0D9e0qDW9FriFWbO1iQW6vt1Wunu0LzHPlCaGUuDKxTbJ2hr926B8
	5kLx6pm2SZoIVu9udkFslm5C9Rr33GaJo+J1jD6w5MQl0Dx8DsN+QZVE00sQChPlyTMZaJcVwoI
	vihuNWVGQHsejnlCKv0oA5l/OuSZOPwhwtMCBZnzYcCQrrDn+DdR6ZJAMUp+JsBW9zpBLa4cip5
	RFueduw/RoqQEOpo4qDjSRFJXApo0KD/FD/K4TBV6PglkPWdOsVBgvtYS6ttAh1Nyhrc1qz/dCd
	1wrgCwtsc6e3ym94lyqCe6VB/AhHn0oqxpmOI1BWbBUaNa+uK9oPYW/Ha9f0GV/2vQ8IEmszl6C
	eDpLYz4tZe6TWGcPMP3+QUoIe+o=
X-Received: by 2002:a53:ccc7:0:b0:67b:f935:8639 with SMTP id 956f58d0204a3-67d89787ecdmr4996887d50.63.1794837784278;
        Mon, 16 Nov 2026 06:03:04 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8b889csm858426085a.32.2026.11.16.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:03:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSxIR-00000009Q2N-0sq0;
	Mon, 16 Nov 2026 10:02:59 -0400
Date: Mon, 16 Nov 2026 10:02:59 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory
 transitions
Message-ID: <20261116140259.GL2532299@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5ah5hgyj1p.fsf@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: hbqkp8dcrh668iftkxq5gk19dn5qbgx9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60C67180020
X-Rspam-User: 
X-HE-Tag: 1794837785-758836
X-HE-Meta: U2FsdGVkX1+zAjo6J/bHJXMK7tYjPXoFLgG5SEoi2CZe9uq25q90E9+121mAZ1nbOhJm+D885UYZ5PrEavMdpRnQ1VEAvJdv6KQo3ea3AHNVDPPLhKuDkBs580+5xVwAzVkQ9N0IywUPSSRWo1lG3UYyJvAtSE/QR78DXgX61STXPX1ESkceCQZmwF2AZ8GRGG6Pvzck9Vx5nH4OCHJMdmc3FbUjvNdd/+qE8ZSlHm4aTvf3YIBx7wMafilzY5DEO81wcMoXNrCNi0YIQYQFjvvYU6WHklMGIZxMwdSMT2DgQET4MjQw254PASy9FXn5Lc8GWzi0ib+AGIfiyzfr0Vm7eBkJRGckZBWvrQuuEqnCAegtM45BzsM/n0wCX3y8SnRP/OdxRWmnx+I8FvgiUJhMT2o8/106xNp8iQ5bOFA/FS/TtHIHIzQ2KrRsfuy1DW5jfcfFig/yVr/VVySi27PtTu2gZJ6cmK9wLEn/wB18a+ueAhQMuuB7eNcIgikk/EYRLb+z0z2jmBuiDaXeS61uBGpKPYkyEfAJKonLgzBpcsb0wP9jALutFDFOToa9kOgCxKp9hx7f3wJ13SuqRFo0JtVenYkLihMFHiq/qdGQrvNhVNO0VgDkyPI+9kSAruw92SpQviHYAD/gP2xEO/QqwnuGYNzje/6E2Yy3HbO21gdo7u2jSbgHX1QDyNkiSECPoMSCpm93YAEFqvXq5YW50D3RsbPchT5hKPrAJ0gzukXoFU6UQX6idWoklrYe0nuwkctqrpLFVKOZBz6tG0KRaKIrISmSmMl6qG+FD2J5/2x/sWG7X+Y4kgRy3TlxNsbBnx288dPB4bmErlAEzizxoT8IjFsxn4loaTP7+i4FNt+q43fwMLLHjsLZ3TI1rqMOCcmvF3H+kdOECgQK7H2hfm+DeMENnWamqSh+f8093Q/ZLdkfH8AP8NPo5so52oqVJMum0/4kmfxDYMF
 Lh57DOuZ
 nXf9cbRrFku4/VyE8CJT8X9nsleEGVOu1/MCnoU4+dIStghqGbfUpmPdAp3FBqp1Iq9y7IMaz8iCx/7rMgdHWxtZfENMenay1w611vt1EivAvwXZpyDmjZiebs4Sf+FPreBXq3yVoiG9snjwzay2TO1GWE++SG+mCG4pc8LsWhUNQREdgSDf+afrc/uKpDXbd8ztdm589RScrCqVHSkf5pUOyqS6ElueLnTYRro3jE3LayCHDycz1QK5HjKW3H9pyE7rt2Od8Xe60nVwpAV8ntmWUd1FMNsxKIk5a58jil41tIQXOg/GcBD/wwkU1hJTYDknQSbKpi6Wez2VB77+LLri9TjTeqnGOuyUx0l4Yq/5s6+NhZ63FH2JTQ0h7FyE2a0JNUnEQyA66JkGPllDIjG9poA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:28:42PM +0530, Aneesh Kumar K.V wrote:
> Fuad Tabba <fuad.tabba@linux.dev> writes:
> 
> > Hi Aneesh,
> >
> > On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
> > <aneesh.kumar@kernel.org> wrote:
> > [...]
> >> Keep allocations on platforms without memory encryption on the ordinary page
> >> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> >> intact. Remove post-transition memset() calls that are now redundant and
> >> explicitly clear allocations on paths where no transition occurs.
> >>
> >> This intentionally makes every private-to-shared transition destructive;
> >> callers can no longer use set_memory_decrypted() to preserve existing contents.
> >
> > pKVM shares memory in place, and a guest has to be able to share
> > memory it has already set up, as Vincent pointed out [1]. That was one
> > of the primary reasons for in-place conversion in guest_memfd.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/
> 
> 
> Thanks for catching this. We discussed it before, but I reached the
> opposite conclusion:
> 
> https://lore.kernel.org/all/yq5a5wzw2ree.fsf@kernel.org
> 
> My mistake. How do you suggest we handle this? We want to avoid zeroing
> pages multiple times with different CoCo configurations. For example, to
> allocate a zeroed page, we currently do:
> 
> alloc_pages(__GFP_ZERO)
> set_memory_decrypted()
> memset(0, PAGE_SIZE)

Just like you are wrapping set_memory_decrypted() in an allocator API
the user that wants to have the no-change sharing needs its own
special API too.

Then you can bury a special implementation for pkvm there.

Where is this special user in the kernel anyhow?

Jason

