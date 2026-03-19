Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBD71088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3456B0393; Wed, 18 Mar 2026 21:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4BD6B0394; Wed, 18 Mar 2026 21:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693E76B0395; Wed, 18 Mar 2026 21:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 560FB6B0393
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:12:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF8F11C8A1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:12:51 +0000 (UTC)
X-FDA: 84561038142.10.5658720
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DACE20007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:12:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDjQCQA0;
	spf=pass (imf13.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773882770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEY/9gdbRM2MjqS/0dLQIuTlut86W1qgepVu69ntd5g=;
	b=vMK3X4461pKQVblzKgc0u7LpNEaVBcEac41oHMuzcXuFTqSjITb6vytGxmtM9TMIoOyFcv
	t3Oy79qol3LWXcHLcJP28GbDSMJ6wkRK2yac32YrJ7QBXKehOdd2RZ0+FMW91kjojjQWAJ
	lnPQL4EYMAZjQbb2xCfgISWv+p6UvOY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EDjQCQA0;
	spf=pass (imf13.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773882770; a=rsa-sha256;
	cv=none;
	b=ot/xZhafESmPfY6zbRbpuScBSOZamFfDJdhYPa0h6Rzq2EJDR5xolsv9E5ptqBmNJIQvX5
	3QTVrLTxBTdWsCsrEaZHrsK+tkvkfN5U+ixe5/bibnHYFSK1E8mXNc1I4MyScHuU2vSEcA
	/JwLqjT+gX1k3wNSdfY9hvoQXwlaxBg=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82a73593410so218483b3a.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773882769; x=1774487569; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEY/9gdbRM2MjqS/0dLQIuTlut86W1qgepVu69ntd5g=;
        b=EDjQCQA0faozqZ9D+9h4iTMmFZ63mp0dXLSVcR5qa0CTJJjl9g06NpGWYGxBUfjDHX
         y7t/BInvYJO6vRaUfKoYFzM4+WscPbkWorfaFHo3mK1eHjrsXyYrogFqUL2pGB4NFFWY
         I2hzXwT6YtuhMhbkzO9w0OJDcOEDD0gYSlokkIszaipTwkhqo3+X0ynjYKLLqyOL71pt
         R3IFian3T0fsfHR3PFbNBRxvqppd2Hs39k8N4UQlZAbQD/EgfspbQDQ3U5ygB36Y7Vdr
         N2LI02WO1JZSRYXJxtgCiR8M+Vr7q2qN9K896iHomzvefGkX5IRYpXTVQUNoTf5Cd4id
         XbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773882769; x=1774487569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VEY/9gdbRM2MjqS/0dLQIuTlut86W1qgepVu69ntd5g=;
        b=AiMksxOo4Vic3fGM61GSdbDHa9JIz8oP8cj4bN4UsPNs9hQqc4Hc623WJ/zETijJ/I
         fpkIuKv2Q+40NLeQvt7vaDfOxQhbnppYB+Xe9mC6qs9dhj98PuF14O9MAwTXXPhcVR4t
         ND2tpRO7rtruwr8BjLwK63r2OpW2xsaIikK48bLEFqztwWmUd+HPhI3/9OuOrQaZX2uq
         BVOZLYktzITr0pf6zGqGHapKcsvDEPr0Hsv0G8jVI+dJZVUAF+iJQVN7hqYFto+qeefE
         gP3ejdN5K2jK8AxpU+TyO9ZVbhuIEWv8t/wG/w3AqGT5BPmkBu0iKGOsH/GAjzErGv8u
         V0Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWNaaq9UWJsFuMOwx9xB06zMjeXyMrCcCFRr5xHtt4FMOg6a7RVb4CQkKtFT3g+Uy7CBLejuJv4cA==@kvack.org
X-Gm-Message-State: AOJu0Yx/WuqF6RdhlqZqsCKle9JfQciEZf/FDR/G5EMqgopDzjA3nl7j
	cPgRofW2jnSi5pHVdXvNd/FDQhzgAX8DIbgP/koseq9ZyLFV2VqDnwuA
X-Gm-Gg: ATEYQzynZlyDD8yHwFvz2Hr1Ypefb1c0yCRW+Q4BuQIXhO6lafDAOqTTzqu5KnW+WK4
	NJ707aisCkPb6CeBy/QlANu4jZO7nEWRiHIG5kCzSPC2ie20omhc1b78AFyfs5rNa7CN4YIF2Ip
	9s478jQfWNypk72FM4U/0Ora/LUNIVHj7XhrPqunBB6jce5u3+lqIuBCsGzwxuPRKmaTDg7B0Dx
	A/oyhGf9uao8+LhAcykNdIoAZsR9rd+egaK+WTuOLh0cicTTeUKSrXOQJfsaBcIU8iFA6yn6eQ5
	nmAgS5N7yRYWh2mqTYorhAaccDlPIwXCeZlPrzxZZ6UDqYtii/Y726fE3yT7GKESYVBBKtX5T48
	jHc06+M5gCdXe8cbqSAFhpRQPvO+QxJbt9zmLf4aiOtlFV/5vXFctd8ZslUWxPY76yjC+DfDYlK
	fv0wpc6sG0cNVoVD/j8rt/neBITLnBB+I0ttClfLE36ozO
X-Received: by 2002:a05:6a00:140b:b0:823:b1f:892e with SMTP id d2e1a72fcca58-82a6ae17b43mr4671300b3a.43.1773882768792;
        Wed, 18 Mar 2026 18:12:48 -0700 (PDT)
Received: from localhost.localdomain ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6b565930sm4024243b3a.14.2026.03.18.18.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 18:12:48 -0700 (PDT)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <jiakaiPeanut@gmail.com>
To: ljs@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	jiakaipeanut@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	riel@surriel.com,
	sashal@kernel.org,
	vbabka@kernel.org,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Date: Thu, 19 Mar 2026 09:12:29 +0800
Message-Id: <20260319011229.602-1-jiakaiPeanut@gmail.com>
X-Mailer: git-send-email 2.35.1.windows.2
In-Reply-To: <20260318122632.63404-1-ljs@kernel.org>
References: <20260318122632.63404-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DACE20007
X-Rspamd-Server: rspam08
X-Stat-Signature: gwgmy6pukwy16zbu99dsumdnr17zfqn4
X-HE-Tag: 1773882769-243759
X-HE-Meta: U2FsdGVkX19RD5FpLF43Rwym3osdQJ79Guf1d4lqEgW8OgeXJTebj29iprKPzS6ghj/c+kvFwzevQMfEcw61UwTJVQF0whQttt6DRGaQT3jlbgzTy+dxues/kkvVVuGXnLP3Ud/wgoo/V2eOtMphT6JzT2paQ/yv83UpWDIPMGtnaZuVnge+hjstVWNNTOrqUgJDTmxKBThM6qgosYJa8Xowmnbfm/hAQWEYZHUzkt+xKZPgwLQmbnPNXrPB8fYDTYJ1KXGqoavcVTfS5C4qeJeKA6yOdRFaMRdPLSdk9fUsb6E4p8UlZI/nEyvSU493663xj1bT/MMSFdqjuGgNwzmrTGASsi25P2Sw4/hVSvJxejbqDUaPJZArSa9FefbeY44p2G/Z2E1SNyHPBgRsPhoPTsZv7Oq7ZyvR0vdUVSv7kR60vXG/477/ep9HF23e9lrd0Mu1qTqki1qXrUbzwc3WLJ7WGLud1QSxE1a0qfKHNp/ZK0PvU4Iec47Mt1Sm5x4Q5Xj6b/EhUZHp6zyVVoqtA/JP7VuKj2iRv/9GVe5NKMCqF4G1epLAUrt8XuesWOALX0ahJxsTFdh/NHyd0jpFiYvGluyPBTTssZ5FoPVix40iOe7/aaafySBzCy5HN8vOnXWG3uxysR+OFbqksNKnAUtOwBgxwBls99eiOpVJP+ZH5m2uvPYEFhnrzkM59gfR3aEy/4nV/75At9SqJnBWjTekdafFzPgEH4SDpSN+k6QmrBTDmxVXxP/K+93Q7yoBcFb905W/OUJWZ5d4yCkK8ibjh0BAgnjiUgdlB3xTJ9gbsIqq13bubgZhECTNLbSB7CARefjw9MNqtoNYOxIgqO6APuoCtwU9zeG56m6uduP3aIEkah2u4Z/ibjKnH/miff/labb5UIE681W539Gba3ccti2Q2byn/6fHD+lY9G8UZ+J6XcFQk8mW8JKOBQdCYhGIzGQGAXBpp4K
 o6IetZ8q
 monRatB/2Q8QjzlmJZPkitTt/cIac3cnyi/mumw9dc4kFiCVCTprPkoMmStuV4vROL/RFoU7bM0CoysKIYx7M+CFhMfGUOq2gkirD++F2PUa7P818725gOPTQky3AUEICeCVU/MrRC4wUcUP5xlfU7WA8K/OflzeN9kHPY17JANcidyVUijuXKNHP7Glabhmi4kedyult51L1jhLUnyolCWyZr72cS7dJJBnZWbdunSgiX3ZTP8EOEvrVdHMfaZJp1TR3x/YQtLp/tOhBMMn++vdm2dTp/Xu/1lyaNylUeH4dyI50Ol+a7Q0cx02nI645x4hI4eYUOEywe7LSRVOLNx5F6I0BiHILT6oWVml1hG68Az4qjhut4CF8YeUvicdTo0glNhBt9DgspCGwwZDqq07BCEq2oho3NHGGEnA8PI7Jhj5fv+cgoGF18ZKQ7bXi1dXPz5DIp7wgq2aZeuQTtVSlEMUMMJtU0Ewc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas=
()=0D
> comments, add asserts") alters the way errors are handled, but overlooked=
=0D
> one important aspect of clean up.=0D
> =0D
> When a VMA encounters an error state in anon_vma_clone() (that is, on=0D
> attempted allocation of anon_vma_chain objects), it cleans up partially=0D
> established state in cleanup_partial_anon_vmas(), before returning an=0D
> error.=0D
> =0D
> However, this occurs prior to anon_vma->num_active_vmas being incremented=
,=0D
> and it also fails to clear the VMA's vma->anon_vma field, which remains i=
n=0D
> place.=0D
> =0D
> This is immediately an inconsistent state, because=0D
> anon_vma->num_active_vmas is supposed to track the number of VMAs whose=0D
> vma->anon_vma field references that anon_vma, and now that count is=0D
> off-by-negative-1 for each VMA for which this error state has occurred.=0D
> =0D
> When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will=0D
> eventually underflow anon_vma->num_active_vmas, which will trigger a=0D
> warning.=0D
> =0D
> This will always eventually happen, as we unlink anon_vma's at process=0D
> teardown.=0D
> =0D
> It could also cause maybe_reuse_anon_vma() to incorrectly permit the reus=
e=0D
> of an anon_vma which has active VMAs attached, which will lead to a=0D
> persistently invalid state.=0D
> =0D
> The solution is to clear the VMA's anon_vma field when we clean up partia=
l=0D
> state, as the fact we are doing so indicates clearly that the VMA is not=
=0D
> correctly integrated into the anon_vma tree and thus this field is invali=
d.=0D
> =0D
> Reported-by: Sasha Levin <sashal@kernel.org>=0D
> Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@=
kernel.org/=0D
> Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>=0D
> Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3=
UKjYBJjCd09OfH55CKg@mail.gmail.com/=0D
> Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas=
() comments, add asserts")=0D
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>=0D
=0D
Tested-by: Jiakai Xu <jiakaiPeanut@gmail.com>=0D
=0D
Thanks!=0D
=0D
> ---=0D
>  mm/rmap.c | 7 +++++++=0D
>  1 file changed, 7 insertions(+)=0D
> =0D
> diff --git a/mm/rmap.c b/mm/rmap.c=0D
> index 6398d7eef393..abe4712a220c 100644=0D
> --- a/mm/rmap.c=0D
> +++ b/mm/rmap.c=0D
> @@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(struct vm_area=
_struct *vma)=0D
>  		list_del(&avc->same_vma);=0D
>  		anon_vma_chain_free(avc);=0D
>  	}=0D
> +=0D
> +	/*=0D
> +	 * The anon_vma assigned to this VMA is no longer valid, as we were not=
=0D
> +	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree=
=0D
> +	 * state by resetting.=0D
> +	 */=0D
> +	vma->anon_vma =3D NULL;=0D
>  }=0D
> =0D
>  /**=0D
> --=0D
> 2.53.0=

