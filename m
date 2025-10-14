Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259E4CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695848E0151; Tue, 14 Oct 2025 18:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D508E0090; Tue, 14 Oct 2025 18:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A93A8E0151; Tue, 14 Oct 2025 18:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CFE88E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:20:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB9C25C477
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:20:25 +0000 (UTC)
X-FDA: 83998139610.24.E5D66D1
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E70820004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:20:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yczk7LBo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760480424; a=rsa-sha256;
	cv=none;
	b=AJ7J7xeyj6YJL7mPtSjPb2819LLH1R8j+zr6uKwCRf+hIc7xkNuhB4lqTgWS21hUqhjoI/
	9gLdpo72nJFueeB0QU9U8tCrkAhhH++8iUMKLF8GVXV4TWlvbzPRfHY0Ad6vO4681BYXYl
	5Qh+TuymM1jiOBF9yTMd4yze+fGhnkc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yczk7LBo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760480424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiESf9E6LuhQtvYIrJoiu1eDEMYyeYxDUHowV6aD21k=;
	b=RjCNNw3yBWmMhgcZ73gV9fzIFUEJKlA37p6Y9XhW5nX7S8j4NyzPN1soPhn9ERaP1XiO69
	AuR8SsnCemCuejxR792ajnF8RbZqRgWGxAMbLaAJOD46B2xNROVllOh1RPLoG+2GHvK6po
	iLcl2um36pqgOAE37eeJRnKqfIZSKsA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2897522a1dfso54765775ad.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760480423; x=1761085223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiESf9E6LuhQtvYIrJoiu1eDEMYyeYxDUHowV6aD21k=;
        b=Yczk7LBo9jNFtZHSnAiX28HJ23NbKj6iBOkrj1GxZ4vTHG3SwXts3IANULlG2y+HFt
         gb+e7R66XR5zzz5mYBXPc3fKYjySDk3iRt6TGjv9+i7ZpoUg1s8Ysd7TvgRIv+GIchsp
         gpBUViy9oNZrLDbV+XQrYtrY1eO+h9/S9lskhp4ifNYhf8u5CbJZSmsJXBkcto7cAMjj
         wEBO+qVkeJdVvKULRgHJ/cWKV4vgGz8SuQL+U2woeSUnDIn4We18M9zT1TpwxVcHaGqs
         Rw0ZscwUFF1YCFItDX68Yyd7Lzo9yqnuTf4WS0wkE3ZkyYqJYug2ami6oIbNt8ytzRUW
         4PRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760480423; x=1761085223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiESf9E6LuhQtvYIrJoiu1eDEMYyeYxDUHowV6aD21k=;
        b=i/sCpAS0yIc0nzlUBRovXb9hNQQY1O/cxcNJyZU7Th+r5nO5SMDecXAeq8q+ytwADZ
         jlMoGsK5eY/r2lTl9DQlpgis6XWba4KTc1sTOm2LltGMH+/wqQP9yhmxZjSkAK1qoC1K
         g1Zl4RWjSX6Wy0z22kYhxMXTTl7GqdRATo5nN+i3BJNnh7DeCRmgbrBReBjUtaRdgoLr
         7G7Xs5FEoeZTxtPXTjUx9bYdTKd6o2lyl9hT2WKhPWDrPTie9c8kt4HyByuohk8PtmdO
         OP2nSrZq6uFtuxTVudeTFyPcpGfN8Pjyy2ANaEWdocGTdwoJDyJ0wdu5HKmHSIjiD8mj
         KsgA==
X-Forwarded-Encrypted: i=1; AJvYcCXtWTlRXxLsIbdhdXTH/UZJO2VNbvtMzcETSpsWxXgjmevsj8BOpt1pZiGNdZithQO+32gf8mKbLA==@kvack.org
X-Gm-Message-State: AOJu0YxIWE4F7qLriTERws5rjsb37uG3lijaOT/bNpy1RCQ+m4GIf13Q
	g+RAcC3ooF/tnC/KnsEiOwp+qXkYeM+Ai1TPyi6nSMFrwbt9CYUm7HJF
X-Gm-Gg: ASbGncueydZD73izo5ac0zWe8Nvi76s+zCOPNjpXrbPlykz4p/0b6J/6sYxNaQTDamm
	ZwNtqGA25PGvSBiqq5XbEq+7K16i5gJBimGM5WrvoWIIlPxSCiusODSZ30g2+7b6BrRLfRQG5G1
	EqbgyPpRFFq8Lz57olQKVpvE4aNsNTwElJ5q6eEwIlsLx+kBE+C3MMZr9IXjxNGtVxhUD5gESpB
	P90IL4EqVt6oM5lIUhsVGmCWckK3sPqDlewiiGNCnbZfx5QL4xA/2vuK8lvtUg9oEtTAsdHvG6u
	kLpvDBlOvHM6CdMcT6W3dC7zQ/PbQHY+7NTa7XjsjFU+6JLfrpnx1ZBNoVcDfQmCYrKKgRuIv1R
	+fURruQyuytViSKHamqSJ2mS365sq95I8wUx603ot61IP1HXLPZt5kP4tQn6oJ8ebJ/9+Ho6EXm
	DbfGcjM8GBElMae0oLtg==
X-Google-Smtp-Source: AGHT+IF+uVtAAqgnG7qVyavs4DNKE+kIBncndz1O/yroSh92Bt71TOPgQgoxEYV7d7N1TNDWn8/+Fg==
X-Received: by 2002:a17:903:b0e:b0:27c:3b07:5812 with SMTP id d9443c01a7336-290272b5534mr324588815ad.36.1760480417943;
        Tue, 14 Oct 2025 15:20:17 -0700 (PDT)
Received: from Barrys-MBP.hub ([47.72.128.212])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b67d0d8391dsm5260980a12.41.2025.10.14.15.20.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 15:20:17 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: wangkefeng.wang@huawei.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	sidhartha.kumar@oracle.com,
	ziy@nvidia.com
Subject: Re: [PATCH v2 1/3] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Wed, 15 Oct 2025 06:20:03 +0800
Message-Id: <20251014222003.1358-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20251014113349.2618158-2-wangkefeng.wang@huawei.com>
References: <20251014113349.2618158-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E70820004
X-Stat-Signature: u4ne67qt3kcz4eqtgatqbf9uou7adp5p
X-HE-Tag: 1760480423-611942
X-HE-Meta: U2FsdGVkX1+jRpZcgJOJrOKCP1T/nqfq6EWITJZ2IelFrNd1DMd3Lmnq99Q9UuEUZrMHsnIu0djEIh16g/Lwd751ERynMBwD1M8ISG0qR4dxAWPMWTX5n23sJYF/JbufsGF1v5jZ+xv1ALEETpOiTulAOIODsE+fC6c7zRzSdaB0W18IbMjZjWHsMDqGUI2rQdDtu7li4h8oLhbP3CiPgyGyIvg0dBrg8DlIpo4hQ7q7ME5ZcxnfXKSDyOGj9CLlCW4uTxvCiKrBNsytujQx9wgiNeFtwMZCeheAxUHiuIH2jWtSTJzorKRn+vQo+qQ5owImRfuyDRn8vSbUgbcJ7PmD3myKHVO0XMsTe6q0qE2KFk/ddHA08udFvFOLc3bSVOMIN+X1XnZ3b4FMdc2DsVFwu0vJWVgfvXe7CuKr6K4f9UfBuwyeUdfAFjdJI4gAXNs6J1ovbNpplhhFnCo987I6Vp9ClkLwa5HyzAeyoB72fHrY6q3/6WGN7euQu2qD+QbZcSHiJsY3XhJNCkjSXqT+Gfm6S66ZEWhZdRFzZXvdlEjs0vZ4+ufd0yLLyMIp2ytxgVFNelkmQJIRw5LQDDv2UhuTA8oAt6S9HbnE4rQWMcbbrfnzRoKiey/yCOspsqlP1jP6uRNia910b1cmRVtpzNjc4Yora5s8INUB997jN13ahnPG5swMrWtY7froYnHOSWzHTo/y8wgovX9gs8YfwRLQ6JWoBK38kSN0ME9fLdGmpIz3Nx1Da7fo3guA92Y/K+BV0Lw79pW8Ul4fJliJIaH+xbsBf/e51/LtG9u2g3Xuy8b55jTCqFsVHtUyylta+E8zhRli3xDauPsndYfKxWReppd2XktPKcr+0I4BZq2QRtkCpEtCFvG6peCDg8XwGKYT301/03mak8htiFGdY8+iGBdFR22pFd/x0AnvHyxVKwJ1vbkkE76uR/Hxw5L5GNCLsaoMJUq7H6X
 zLyFKeFJ
 ciIufTCbxDgEiw8wGoxcMut6c0ShcpV3q7Dk/J8ujlpjaxx6O4odNgeL8UScmeemClxTMsATy+/Me4RSCVxpDuBy7eYbYNkgfeYyY79Tp9Z/tP2iVDdUUiA0Za8oRgjum8Dfc6FmyRGInJkgSttSzwKLkLxfojNiQdD9Tf/OgKkt8U18tPKytuY95hR3X2BRoLmm/EsfSq4y5FQmmG0/DVXlZItJAubBQliWPBfPpms8lBPJCZLLOXsZqIeXMkNmkmSwtIeBiZ8dbK/fVSJWGt6jKQIJDzT2W/MW60JezI0ZyNqbnfE3MZJalyyN3o6WXkulcsGPhmb9kWqyIzHJ9aWg0V8bRCHdI3Tl7sLfRDmPg9JJVberwzXtT9zy3U3dGYiq6RGSpfOK4lHGUCiVMf7Zpg41ti0y9Pk9QJ7rphxfXLKPELH5bYZ8t5ztPPK5AgRhfwYIQDxchAv19bDzXbPDwIAG36Aq23wyLtnc8XpL12MTbBlOCq7rjR5DYI8yPaLZ/oFVD1+uC3A8SgFmBu8+MawlhSh8B90imTFohal0m0oE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/mprotect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

