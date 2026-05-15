Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DCDCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 21:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446086B0005; Fri, 15 May 2026 17:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7596B008A; Fri, 15 May 2026 17:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CBC6B008C; Fri, 15 May 2026 17:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E12D6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:31:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98B65C1200
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:31:16 +0000 (UTC)
X-FDA: 84770950152.09.2A332C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B5185180006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:31:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QC2+bFND;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778880674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGAZv1TOY5JBR6TFn486G4e9IPRbbHlUsI3o/pUwbPc=;
	b=S7SwA7VgslrW0+xgLm+izf5rm0ongVBx2oOPiRIwYxGQPU3wB7y48DiZ2rBM8oHG3dmPPR
	iI52h6KgaXubgLkpDS1iLofo2KwCIs2u3A2ytkvGAUGcSBBNlfix+/PzMWHYgntRWupwgd
	kG8v9cYH2Q3C8Uroux/Hp81GdRt1c2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778880674; a=rsa-sha256;
	cv=none;
	b=kYiUs3Gc/yz8SnbSM82VvQnO+sAoN4VsMo4Tr7E5P5Pfq4aaXWTAEnixOT/me7IsSz2Xwi
	ivt2iPpyD/AtBiENGp0f7SICtvrjOeddczTYYbDSc0zBoztTVVx4d+SDBTQC8UPVK2H1ii
	6lMgMYq/e5Z+9+sXj3PMxv63Fs1FDdU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QC2+bFND;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FB14601DD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5EC2BCB3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778880673;
	bh=GY1cCvhL7tygE+XOKILACYNa8nZq/FLSTVGkz36KkCo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QC2+bFNDnC4ThkVzAUQ3PiS+q+MvZtNHRkGLqdjjRHonxm/YdYyHVkRdY0iI1SNCd
	 9y7SC1JtXSPO6oScdg4FjwIy9lSnRQ1nmm8xb7EkERPjVd3Qr5JtZKEfIEy3Kils0J
	 EhIFEDVZxAdjG+0ytLmgV/eDgmF3MZjMmPCytahpkaMl6uCuMxIdfwMs3Z9rVyjbvp
	 nxmLKWKFgZtqO8N+iJbxaJEjlyHyDQut0ZXOV9bF/GTOlYm5vR649VoiJQ5qNY3aFU
	 pwIZN23p3iBlJc9yDlW1ySMyyJVRkgyjdMHScXngfQL/DdwYaQCm1KtR1CyqP+86CX
	 pT2VbBmbmOXnw==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-65c7a459105so478260d50.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 14:31:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+zN3qtzdQzM7PatIKoLRajtKh7/t2A7qNBxl7eeXX9lbFcQ8aBJKRdz3tQrWewkgEYMjN6rVBK6g==@kvack.org
X-Gm-Message-State: AOJu0YxgnJDhEjtk3lBl8f9sObhH9DXbmSFdcaf5JOJTpVQyS4PjiVKU
	y9+5oTvnFBuMdyrC2hEzZRfHbtpayzoEDi2FlxS8+KjUmPFtCEMGO9hBfDI8pM1PafmPbndHUP8
	JgWRGjK7bWeAlfOr5Gv31Bh11HvZfJHmBukHw0gDuCQ==
X-Received: by 2002:a05:690e:4399:b0:65c:6ab0:b81e with SMTP id
 956f58d0204a3-65e0b2996bemr6363277d50.39.1778880673139; Fri, 15 May 2026
 14:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-3-baoquan.he@linux.dev>
 <agQM8YJgiMxGlI34@infradead.org> <agSZ3hZJTBAjgVOn@MiWiFi-R3L-srv> <aga9jI0gc_-yxeR8@infradead.org>
In-Reply-To: <aga9jI0gc_-yxeR8@infradead.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:31:02 -0700
X-Gmail-Original-Message-ID: <CACePvbWT_7bzzp7PBB6FfuHymsnTbzgYd=eFzBsBsbTcPzWnjw@mail.gmail.com>
X-Gm-Features: AVHnY4IO7Uyr3GP_e7jGfzeI25m3ovpQ3TFBFJDq2yq4OzNA9Eu-dtj-2TEEyYI
Message-ID: <CACePvbWT_7bzzp7PBB6FfuHymsnTbzgYd=eFzBsBsbTcPzWnjw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's methods
To: Christoph Hellwig <hch@infradead.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B5185180006
X-Rspamd-Server: rspam04
X-Stat-Signature: tgfejhbh16norrg99aamp5m41orjpfmo
X-HE-Tag: 1778880674-947725
X-HE-Meta: U2FsdGVkX18UUiFu2BIEz9H4n6whqgJQQapjAIp9FW6IdI5mCYfRODRT9W7bu1E/6DjtdNClzF0ldTde6s6sdSuj304FEqBsFYa5n36AWYC9w1cfw6FsYVXfO3IbgRrZ/5h1nPlZ7jOKL9qaATcCNQo2oDxqoeBegK4zyDIHAk9HzCpY5tWs8r+4m2rGNP5oP5hAhkj+pR/Eo7vUTK2rlclgj22PeOBed91ufUEcUcKZaZN4fXkCv2t+52980FThYMcEyHD/c53cuDnxMkCTi2Fyaa+2NdEWXqVsnXgt5SDaw6K5BK0sHzlMMc9yAY2TNGmtMJ2G0GHbX1uSZGnBhyfe3IYIq94Y2IKzAna29u76zK6WNLWvjFCyKGeNDQ2FOldc1krwQ2+x4ngr/9LA8PComyYWrfIiFj/Uyw5lk+yr7oPTU4keVf2rxFQg0D3/HPOPMXXFhchZzqIyAtED/S5lOuq8UrCaN0XKhWyptFEjYJ2/qhuSvUI/oN6ratlAZ4BB7REXUUoU4WusIqZrqn/6okB1Mx8kBOaLk8G573RO71KTybkUW+JdKbZDL8wXTKGQVZZ4dQO6JCPxuWDyISlxFDNGl54EYup0swBiSb2saer48QQ9zBwqDsdaI7Jz71Q8hmYCS2Dg2/SB4MnqCZFguKxEXALhP1HU4InMS7VKyBoLpqS/VkFTRO3+jkyKH9m+w6c0HN676jUsHp9QCEK/NNsOsj6PH+HLVs2PClLKU9wyyJP04KekQkifeOlkd6OWX3sB5z445FGZZkFHDT3WSULyADFQ5JAZbxweY2cZHELca7mA+ghlB3LzSiwpnZ3yVCAET61/2KwEqrYOvqLegcWL8KxoS79a1elWVrz2YcfcxT9pg3fr96VHC3KkcNbJRkKrGQokpGNxA45C+6lpoIxp4cbZe/mVERMYkl0Pymi1tKB/WTjf5OTCotCNBoUn0rZpdbiEfzIu65X
 BBjd+Azg
 WIbRyIbIql7aEAPra2GxcfZ4yk2r3/PZTRCOAoKYIfUtlhChblJGBQTBR8pM6AzZ2HKOOYdPzcYWlrnUqvirhR+l6K7vRUPgJp5G/XTIRcl+qSAQLCbw7+6vPFcSWTK6P1D/fQYP6fFnT/l+Ap37TmZU/CYH6HoXnY9wG0zY6HfHSXZnTtBoYV/6T5BvBXYUBi+oQB/QTWVJKr4tA1R7vP31qTddi1Ky9esY/CATqF9XD3m1rlKfk7kgJaoTSIT+oNXXPaMFCVy2P+vsKej9sTi5Nw3V8t3g3lPlYhKDD3bil2kN5PbjWFogmDbj6VfYqRpjgj2x/+V5E6BJADlyA5d/kiV+IOITfNIFuyv8D4nF7bmtk8Cc/7GhOR73UkvGq6tBv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:30=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Wed, May 13, 2026 at 11:33:50PM +0800, Baoquan He wrote:
> > This patchset is part I. I posted v1 to collect suggestions, later I
> > took a leave, then people think the v1 can be merged firstly and helped
> > to post v2. I later came back and continue to push this part. If you
> > just found this patch series and come up with those cleanups, could you
> > wait a moment until we merge this part and part II is posted? I think
> > the split handling of block and fs in swap you mentioned is super cool,
> > and is beyond our plan.
>
> I've been looking at this a bit more, and I think it is going very
> much in the wrong direction.  I've started drafting a version that
> moves block to the same model as fs to build up multi-folio bios,
> which actually allows for a clean abstraction.

That is for the swapin_readahead() where multiple folios can be read
in one batch, right? I assume It should not impact the swap out path.
Curious to see what you have in mind. The swap_vma_readahead()  can
hit more than one swap device. The current swap_ops is per swap device
so your multi-folio bios will likely stay in the core swap layer. I
will take a look at your new implementation; hopefully, the swap_ops
can adapt to that as well.

Chris

