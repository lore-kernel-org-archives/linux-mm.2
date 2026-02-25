Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED960FD377E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471AA6B0088; Wed, 25 Feb 2026 13:51:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D3F6B0089; Wed, 25 Feb 2026 13:51:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369336B008A; Wed, 25 Feb 2026 13:51:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 226546B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:51:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBC145A3E7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:51:47 +0000 (UTC)
X-FDA: 84483873054.20.7D7568F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id C47971C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:51:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kLLFT3yu;
	spf=pass (imf21.hostedemail.com: domain of jstultz@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772045504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oh/ifwivL8l9J8VT3JA58Q6ouuCYd8eO2HrHQHPvGw=;
	b=16J0lYArVs2FJMmDgzTfT8y1KEqXF4jX4EgU3qnYBwgKS25nyS5cBd5/pfV6zdUgRTDgKo
	iitK5/jGRtedfwIxwDfMRD91uGSE5gqv7fvuKNhyrEMahkResDFxYd0g3h1OMYOn2Q7Ua8
	+IbTUuJPjBLfIwiVIFikEA7tFTSB2QI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kLLFT3yu;
	spf=pass (imf21.hostedemail.com: domain of jstultz@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772045504; a=rsa-sha256;
	cv=pass;
	b=hOv2MKD75TCuCySZ232Lk+7Myu0FzeQ2JC64ZKof2NxcFttABcLA64ClJ62IQImb3pT6/I
	bqkw5Llbt+cpoLf5ybATO7iwEqQSzXieafU/wKk6puo+tNDivjd5VLo/FZnGYOJ56H1qo1
	VNY7drZwju0gQxKpYD7n5ecpLhmwHWE=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b90bc00578cso4133266b.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:51:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772045503; cv=none;
        d=google.com; s=arc-20240605;
        b=TGZAb5j+31CXFC6eUpBLe7YzYPbOz4IrRVJnQbzXibYqi79VgTjW9H7OekZM2ER5yT
         DfhYJNL8XmgGUgZrdABJK9P98VkV6SftZgEk8DW02B/v7u6ygxGBj1jN0187S7DpATRR
         6pFegqlBPVa7xM8KSVtFfn+grrvvgvpWbVYx5vs+jgzDfKYjS73u4oAaaGRKnLL37qZK
         D2U6YmevIZjVS8+vpdgBOWhNLPiw2UhI8ndoAMmHQ5t8AAz4jP+iIGwkIuPr3M+JvsKe
         oOCIVQ/pFZVQwJh/lj+pRxMX+sbjH+lt0kyc6RdlK8Q+Hta6vYv/1Kmbdafv8oOl/4Q0
         CBbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4oh/ifwivL8l9J8VT3JA58Q6ouuCYd8eO2HrHQHPvGw=;
        fh=Otu0AqWeCdmHtvD6TbDt3ixRudjIZ6jtwifY4kQsmAM=;
        b=hZT70tiAhmHk1ZzAAQn2D7xyV0e1kC6Y7p2tOdZ1M+JIAJjl3xdCbBswFilUCm0CjF
         2WV7TQ1iNihkQIKPt64kiKkycoOTxs+c0tJLU/HBJ2UtNGuMasylBECNrcbBx5qCMEnx
         uzszOR28E7+oMb6X0Wt5Dq9x4zglBwHqqNRjQimih4NRAW1gIHWHsIqk6p8g8PWcet5Q
         mp6OSGpp4FKEizpMyMSGJI71YKzj5UyNPF5y9W88bx93OmAznwK1MpjzmpOODWIiKR0Q
         uRb3iWdpJM50tnf15ZGovbBpdLyf4XYOd/ei/3Rsr5WevfdgxuYOrM1doKsxQLp/zZP1
         ge7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772045503; x=1772650303; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oh/ifwivL8l9J8VT3JA58Q6ouuCYd8eO2HrHQHPvGw=;
        b=kLLFT3yufT4RZ9iy6yV+pmfTKOEJ1udR40BIMTYM87J82AvJ7rHVDy8YBU7XQu1ubB
         Z+cY3eUZINjBn8182r+SbonoeRFQk/+ibwOEq6rK9zV7D6BKNgY4L+L62EQoIBtFs8JI
         vHNVFvedInaxWUVEjLI7jnoij9g74DRBCi119LDkJ7gKR90Vx80oUFE6eob0df4KNeWh
         +n9IxoijoEZaucXAfKX46X3vKfGFaSWRZTEy8vvAzE2Gl6bF7xErX8ANwGvZvSP7Pa02
         ufM+9c4qA4hCOsrufl+4lm4ccD18pOGmZjhbcugepAg9YZcjdckteHGUTIvUSO8tadbi
         xveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772045503; x=1772650303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4oh/ifwivL8l9J8VT3JA58Q6ouuCYd8eO2HrHQHPvGw=;
        b=DFjjVsUD6qhno/HPfN/wHoJliq48YL7YpJ0jGSoB+gnCYssy94d6Z1hsT0Bwl50+iA
         OjtWpd0QDvJxs2R5vOcPFXr7jVgfgxz9qwLVRw7pXMyUge8yuEg9UUUxWtkgHUwkQRlc
         ysOP9yU1wja3CtLLLEXCx7LT2wtoA13QG3n7hNeYetR/IZ/vrnJGXvQvWOGvr1b1V8kF
         du0rKtGcQqyUSEMbDfUvJp29NwMjGPRfafvZLQpx73UCsoaSta/k9QVIdq+grrW4zR8M
         yL5ZAHTmvygu/ifyk5yqw3hCgn7bSMr1wbmPzmvI/LoPaZV5Pi5eSq2uuSL+i0dMgGfX
         0sLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIl5gtQer2N0+TAaXLY1y1wbFnUfUYlLXjCoAe0eqp21pFKbqSbz0OeTmqVilQrcFfNS1HpnXQsg==@kvack.org
X-Gm-Message-State: AOJu0YxF9JfjB7qyQ3SMHhRsWI8jS62Th62Nfgc1UD6bYIV/fO3gAFb9
	cGZUhJ/bDQzDc2HS35t1hsoFxtdIkU2s4Hbhro9Q7JHAZw5A9m2UhoAqI8Y0UxiowsjAy2DaboO
	1lBKr1KttO6GOii/Beg0u0OPneQtL1XFn5Y62Vq4=
X-Gm-Gg: ATEYQzzt0gs29NionvZN+eBhtNtck3ArMWE6mMZxv97/ztZLjXFTp+ZrCZ9r9jy67Ge
	W3pQG7lTSAO7ppJsFsjVc6N9n6iXJkREr0DKOwC619dqOYH19kEo21oSoiw/bgSEEprnbyeJGY5
	riltXvFH82xumMqSpoSvqAeKebRBESqeumqtYUINj4EExieBRPcnxWmZ+9+c73vlusfx+bErC9l
	MSSzivZYmn2k/Udnayu0m3qLDauKTz3mUlXKZuLu63SeF1nX3+Jco/yFtPTWa7lZ6VQzZclE3js
	EjX71z1/at3S8Q1HsRkKmpnBoX4STUQcDNKA
X-Received: by 2002:a17:907:6094:b0:b93:3792:4b03 with SMTP id
 a640c23a62f3a-b933792588fmr385769366b.32.1772045502705; Wed, 25 Feb 2026
 10:51:42 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Wed, 25 Feb 2026 10:51:30 -0800
X-Gm-Features: AaiRm510JicR5yB6-6HzIZrjZoL6Jbi8o9bjBsqrkrZBCAWaavoCU9peMfkjjyM
Message-ID: <CANDhNCqk9Uk4aXHhUsL4hR1GHNmWZnH3C9Np-A02wdi+J3D7tA@mail.gmail.com>
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: diwyzyfo6mdar4oskr5g3kgnyzmfmsba
X-Rspam-User: 
X-Rspamd-Queue-Id: C47971C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1772045504-313645
X-HE-Meta: U2FsdGVkX19vUF1/Bb2sZW5XYVsbH7k+qW7QYKpMHV7KwqF0ExmUiecuUZY1Mo8yER2978EQbPKPlGVQAfbare9oYpCceRm/5V7k8p+MvdbNv70wi5he18e23qpKx83gLvf/uN80AZIsCTsXK91zST0IGrRiZlzLWPBfUfiXf82BlSFAPecV5Aq6ydTpnVjOK03tr3TAMApl8D5PbJsEHEqjRopSwjIuHcF934eOVuz2UtffLeNPbAowwy7RaLWttli6ar/s3q+LlNfP2u5teu+CFPK2IWXiC6fDisEGxw4e2ZfENgzJvsIXJvRwJ1Frrj2Pnio+DY5+1yWXXQerYTFa8I4c5FkHrwLoaatSy1j6MYURunPWxiK0hDTfdzvJpAyL067EEF76sCBFRKd5DRkmVU+TJSsze4voXlotcmo5tcUelaOxQTsAA3Q8ByFendgHFBixcDQ8j9FoIBfWTw21+SOEvRCI6FadKjDqHIWnQYhDrb6Yk4DcwwZDhl3TkDEYCVKJfm8+ZLzPREcfFQ2FN05nN2XyoVm+NhOBvE02dkrEtVshHod0SGtiWexLz9HF1NK4ds4xxhfdTIG5+KemVejHhWBnLJOaiMPW09pyPlIC/fmDrxgbWDWYvAtI4arwAhtcGsveWsvKd2ZKY8CNYrHg1J3Af0k87n9mpJu7NFmmP08imnfZk2wMQgjLuQmU3pikKNc7Ky43hJwjbxJDow/HOnTKIpqEp/xWwFwxuwB1v0LBlqYMuk+yZwnfmhETI+Xc3/iYSi/thD+BwmKaCMvObzdS9fzrAqSauRfRwgKsU021wySXv/Ifi43cAVqh+Wq2Hf9sipzFL8C/qQPjwzvjM4Slh9C9Q8UWURktvZcQJ/CPhq1Eb8N5BcTBKfa5kQSbCWRZ3bHid1/GemiynITJzgg4odtdgcipGblNdzCagGTwFT6xv35YhsY6LDC1e/P0rb3NwTHPLS1
 QkElyU/T
 sLYVj5TX8eamDfakC6Kn68qh/DWHF48KLjcYKdUwgZfUuo2fXf5qm7JVGuAoB9XVeKRgXHL3N1HSh+eGolmPekCf7AVPri03KfqYiK2XMNftaFwijegqhW0lpsybcE2MFhU+p/ZsQObz3Gyja3LUGMbXZTT6lJ7iZsgIUAhhDozbcJGfJ/o4TyoBL9goP+thhJwNBoYUilgiR9ko6YgW94TL/9oLh6HnI2GZK82v1PgHo3QN99ZAxOL9ggmV936S/wNMiZcdAZPKWOL+Y00s60i27b8aNnM+D7d02mTHl0PLHAJ+OtsUBz4XHovjIOJ4nVAOZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The recent introduction of heaps in the optee driver [1] made possible
> the creation of heaps as modules.
>
> It's generally a good idea if possible, including for the already
> existing system and CMA heaps.
>
> The system one is pretty trivial, the CMA one is a bit more involved,
> especially since we have a call from kernel/dma/contiguous.c to the CMA
> heap code. This was solved by turning the logic around and making the
> CMA heap call into the contiguous DMA code.
>

So heaps-as-modules is common in the Android kernels, and was
attempted to be upstreamed long ago:
  https://lore.kernel.org/lkml/20191025234834.28214-1-john.stultz@linaro.or=
g/

And it got a fairly chilly reception, but maybe having the additional
optee heap (as well as other proposed heaps) might sway folks on this
now.

There is also the kref bits you might need (which Android still carries):
  https://lore.kernel.org/lkml/20200725032633.125006-1-john.stultz@linaro.o=
rg/

thanks
-john

