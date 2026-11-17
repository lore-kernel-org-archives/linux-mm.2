Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50FD606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYjgvtoN
Received: by kanga.kvack.org (Postfix)
	id F3EBD6B05C8; Tue, 17 Nov 2026 07:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF00F6B05C9; Tue, 17 Nov 2026 07:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90086B05CA; Tue, 17 Nov 2026 07:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE6F86B05C8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 390A6A0400
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:58 +0000 (UTC)
X-FDA: 85444487436.18.54DA3EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7B84D2000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYjgvtoN;
	spf=pass (imf31.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/GxyM3xQ3jHfxh/01l7Pa4ILI1xRNFU3MUIalnJ/Ic=;
	b=3ua30+pPmFarFlA0+xngNZGITonM3PCr+Pk/LJtMVRqE5RPErLkCpz5Y0451bvMwEc4jKv
	jCEhmd6RcaTH8V1O4yV/PfJLe99xyc49NZ20PeJhfw8J5nEpFR0AqKcKwFeTEKIzF/E3oQ
	jG/Q5lR+FbNEKLq50uNNu9bftVPR/J8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917276;
	b=5fTbIVMFWMVRzihxkCMlhHDl1I9egH3DZk//qNJ6E3mU7sm0IgLbjtYysCkYh72OuQmPJm
	yMmSXmFrrRnIpsJCKaj9mnB1O/O3Q/gJ1xWEyVvNzLnqlZNeG8d8xpqvLkTOBteon/m7JA
	3ShFCkBuImZcjxfBBeafjU87o1DCxf4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYjgvtoN;
	spf=pass (imf31.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B318044F15;
	Tue, 17 Nov 2026 12:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568641F00934;
	Tue, 17 Nov 2026 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917275;
	bh=s/GxyM3xQ3jHfxh/01l7Pa4ILI1xRNFU3MUIalnJ/Ic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TYjgvtoNuQZfGkR/SgqLaJ5HoTzQ3ZEBdzd/+euHF+gqzHqfw9aoVgzXdgQ+dIJuk
	 uGrTDvInZqzbx0XvBdevqb/w0aOKtbE/d1/S1Hufvhq+QeUVQcQlTiRvVGlr1EfA3h
	 e+IQj9nh2dI/1foUD7Ho193uxD7s3+11q3hcayoip/FuKx4ODfCsC/lOw6CbyzuApi
	 OPk/igYER2aoVVLOL5wduIqtTcSVxEfCBxVygpdtTbz/6YB4P8ZWXbqDTvoZdukb8h
	 ebah/4xrrgRrreD/h9x3OsMl2NuftMm7xJgS+TXAeEowpt+h3psMuf2GiMNxLfdVPQ
	 A2CmscMuHGmnA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
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
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
In-Reply-To: <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org> <20261116140259.GL2532299@ziepe.ca>
 <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
Date: Tue, 17 Nov 2026 17:37:07 +0530
Message-ID: <yq5a7biby844.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B84D2000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 19tskmgdjoycpth4b647oyuouahonuem
X-HE-Tag: 1794917276-143866
X-HE-Meta: U2FsdGVkX1+3lALYZUbTGAfCsLZMPmfsZotYL8lVQVqYdeqdmmBUlDzY+JtcfIKYZrJE64r8lS/KkS7weFN071jBnLcQuO1D1D4DnjEUp3T+UC6ziVjzrXIqrEdro8TEd7rqILZ2cYIqRWCWJV+vc1yZbXdsIvVbDLsKQTYLSDN7FgaWktsMKSXKBECWraPeG6omUpBioeAt5gxeHwFJt37HEalbQ6JaB6MosIFnhWDzYbpCwB3bhmjMM6JR3yd1RzJCuVxn+GnyEgxxbdrCJjPJaXRnn3BTygYj7IfceCXcxJ0LWwQ2BM49tPgOtFq5IRwM/OO4ZmN2ANATgZDXrRQi/3zG14FyuBHb8cnI5BSZyit1c7s91MtaRqYYGDbG2BaA1FM+/lu6wfydiC3eog9qR43WJzHueNC235JOmBHEjg7KtnMGkUL8cA26MIigisVSdo/jm3Q7dCWDoaIXGCvNB50AbFeced4PTBbmnPT3fiE5F+ziasXMBsFQRKeLgnAt1iXQaY1/P99wuJD9VXy4nSMY3dG70XjYiMr01XCRSoJkKCK9CB/ycKl55/GC+V8615R4yLvm/CxnNp1bFmJCOWeZfh+nOvbdJC/cLpzydGWAY/AUl2dbS8pt8xhS0K+Dy6UhNSw9SJT7cnrwxMtwPnM1ZQ5WtXUHVtPXqtPw8cp0S8pxrLfTHrg8XLIP/wT/wSEl3xSzvADlem/lvQSVNjUIHOv3xVDmzvP91SP6X7UHUu6+oosHgdB0IZyYbUjWX5FR6Ms+Gf1DsgotFTGwtDTtPMaqdBEL1KdxDyrxd4YKSeM6McHlWNekkg8piUh/e67b9Bg/cryz7ajoR0IKsv1VDjcsFWj4D03H4QTqjFX1tLA5FmKhJuTUrd0nwEArKWDa3y1YhxsblUKDcToAkim+/WLDkQssoXYJ6PGdK8FdHd5gZ1OH4v31vlzndbvcjHa59KpeIGJxllW
 KBfAEkbp
 q5ldQR1rRQGYcTPu6SxxWQ/jtFAszMJoIHVUWsgzdAUHzu24pPJE0FYBtc9UuQ8hsjaqh+7aQrDRJVKYeuRgMmG2SPNa7/oCySH9aPf/eXtLAaObWqF+1ghPRE65rgIc78b5q44qOvJE0493jPRcIxYjdfd8qifTcVio8aLOKs+uZZox/s668BzOqY9iqGr4R1eNFlfbc4gCZqbahscJuAZw9ohgcGQakDtmQYqI3z/e4yFjt2jpeYqUwPC54GEPM6XT1tMGDWUWQK7gYy3FnYwhhfHlgVrSoCUOr5J2eglLGxsPPBvJq8ifsaPTz06Ewb13ceTAkoZwz7UZZwCqP8L2kIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fuad Tabba <fuad.tabba@linux.dev> writes:

> Hi Jason, Aneesh,
>
> On Mon, 16 Nov 2026 14:02:59 +0000, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> [...]
>> Just like you are wrapping set_memory_decrypted() in an allocator API
>> the user that wants to have the no-change sharing needs its own
>> special API too.
>
> That works. A separate API can cover no-change sharing when a user
> needs it, so I'm fine with set_memory_decrypted() zeroing.
>
> Aneesh, the pKVM hunk does need cache maintenance after the memset(),
> which I have in the Cc: stable patch I posted earlier today [1].
>

I will add that, along with the relevant comments.

Thanks,
-aneesh

