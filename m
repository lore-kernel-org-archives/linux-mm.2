Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E42CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693CA6B0088; Mon, 12 Oct 2026 10:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645206B0096; Mon, 12 Oct 2026 10:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CDA6B0098; Mon, 12 Oct 2026 10:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19E626B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:45:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87AA940ED8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:45:52 +0000 (UTC)
X-FDA: 85314248544.21.31081E2
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F563C0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:45:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gtlybd9Z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791816350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGrNTBjii+g6uIsj6txOBfGumy2pNID11P1zmPmCOWs=;
	b=dYreZuB/ub9ssWx1J61fGf6AZLez3d4xpGOJWle7dqtFigeNSe8cCqxS6j4y4XjQg9w3/6
	uTZK7rLP+6SbSTF/jMRyx2aV4jkJHSu+pwkjyiBA+L5RjECK8R9IR6GL8VSF1abhNjeg3E
	IU2Y+8to1+OZCNOAzYgqOSarh1H6NIo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gtlybd9Z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791816350;
	b=j87BfmmxqaqVuqbySMJOU5hpPKQhdHr2zodIVC+E7opuqTmiLqmACE4VeKSiwRNfl2tmoG
	0RjTSmX6AGrodIWmMPy324iRjQFoePBqF2xMcm4IkiT+dC+uBuamJzF7KTgas/B+KDarV9
	CuCQAiZFdyUzUiZdrquqrmgQYXe9w00=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so69765ad.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:45:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791816349; cv=none;
        d=google.com; s=arc-20260327;
        b=j8gvUYUHUJI92neHSLLm5YLHwxuizHah1Z+dlwuEG/xaQYrTBvfatXUxtawpRUrlFa
         nuYLo+0tp2qx0QkekJV/Q5Pwy7cqcv47a7BAVY3ESqYp2ZpsJLFegprTGdY++dhrHWrq
         s7PbAfzKy32KjagVIjrWHRJN6Y0DJqkyL42VujY8XGZgfa1w79SSIfGmsvCDn4cjhqwv
         roF/0W8GvkxOf6W2Pl3llq6WRHfUTZAypaGqQxLQtkNYSo4DZpdDj2ZcYm2JpNlVC+e+
         Cf6E+xk1Lyv8Yra7rgwY6WsFrAQl8AiqsCsSXwh5wzQ8pjWKB0Rmq3UOxbF5SGutIR8B
         81yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gGrNTBjii+g6uIsj6txOBfGumy2pNID11P1zmPmCOWs=;
        fh=E9SuPo18/SB51pPjHvNz8ejgfFVw50FoHpm/QgwuNls=;
        b=rYNzt6IGzbjMSzKwakLh0YKe4kwvF1/BkeP4BZCfR/Z/ScJTs9vGfzHY+/RY5wlMvT
         2JEbkcSs0R7DqczeV0UVji8Ha9KjvA/0/2TnmEx55dR1cgNX9E96Zkgtf+RXJK55Qq0y
         yjkWbo95VxHnzZSAiSzCPbishCYkk7KBt8l5L1XUlQ94jAYbF0p++syi/UdGvCovhDgW
         VroNlMtZLpsweEIcJ2OG4k1S6bGofxWVxcMGlo+wcmhWSmn+hcKlYEsGu1ZtXByDlGku
         bqGDFT6M5qDR0TJvYYPUyNA+tCfdw88ixaJVHrYg3/WdsmGYUIWFmDQV+OsHyUEC2YJG
         LMqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791816349; x=1792421149; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gGrNTBjii+g6uIsj6txOBfGumy2pNID11P1zmPmCOWs=;
        b=Gtlybd9ZbsdOUrW8z/Jpa4VKKbpGfXznMkJ1VvKvt5lljK24YXgZIkt3JiJk7Bj2dT
         pFbU17ggvznbahBpfS08GysBkT+TrUAliR/KiZ48SZW3NkzSwXWj2/70AKIpP1twhPrE
         PpHA5Zifpg8k+JYbzdxDPRLSr/Tu7vBvOZrEhgB314fKt4QVJuPEhi5q86y4NZJVi7CT
         FALp7IwDXTzDNsc4zPoHToDoJhTo7ambkfQOjdrY1cuex4bBMpm93KA1xf+O8X1J6A2K
         r5QWoMXH6/dKXsEB7XpADYcubRPq1nrNYzi0ZLI0itxa6Cw0dFCp8H+RzyFgcyQ8bEVW
         JLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816349; x=1792421149;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gGrNTBjii+g6uIsj6txOBfGumy2pNID11P1zmPmCOWs=;
        b=FFcELddz/idWAVz4ofYJsfxRSsDf/0uNdxg5d6AfPMlbQxIVB8iKol/WZeYz5dbsYV
         1rD3ZO4ZdBGaTPijldK6sm9/5gkn4l31joXRAHkxt6PKIoIEIuMxdIsP5pWe/s99K1WM
         7GVMwBR0ztPDIawRypzvKxyIBicYhC+Oi2LoWQgiSp0W1lCGhJnwsdDymMC6gJ/K+vXB
         Zjldhu2Ry7siobXqULfc29Ct2M1lZleP24xYnQZP2oJnO9hZyqtEejs1t0VOJ3ScXS1q
         JNgFc+REvIUD/CBB8sLB1FtVjcTblWY/4Vn6N0lBuUEMXEX8G5SwBnavL3dfQofIu2Ee
         aiEw==
X-Forwarded-Encrypted: i=1; AKwUvBzrCurPPu7F2cCDBvLR0QjBppqE7BPrLq/dciSxlon2Za7IbPyenb/7xjKMTSHc/H/0cwm6G4F+bQ==@kvack.org
X-Gm-Message-State: AFq9FYIQxynJ9QsoOxMF5hU7eTBZh8DnFLqHG5SCi0Rv+O5KkOmesVDz
	mCcpWDJgg2q/7w1ededU3g/56HC/Y+hJAUBeChCOTX1+85OPpvqBWJm7mmi+q0qV+XGu+EHMJeD
	ZIUqXBhQpFbHOH4lr4exqAkeZDWG+oOPnH+d6zqkk
X-Gm-Gg: AYBFou3yTK1JuiiXKZ6xr3GgGgVnqoC90IYZSGzT+at0Dw7oyn3MuEjEeduPIU6QzGW
	Q4d3e66ZlISXgh8ilO3bYBZ042ghChAzMAvKWpxaQef+iwxAoiPzt+ywt1Mwc4SmAV1EpujMuxX
	8BTyjonH8Y8RXFNHyNblO+24AeeFngvKSsUkmq4UFMHixb88FWHkCjq1Yu3FkP93P+sfg+3+t/5
	X1XNJ2+5zI8HdAg3mu9ZTokHP2iwCYYuTu5gl14TJv77BeL771nT5YDMwK7pO/oTHQHqDOzj3gt
	Hx+3+qyqbymytVhaNz8c6MpVCh5Tb/JT0EdIsl7rQNsmnOCUNmgwM1rB
X-Received: by 2002:a17:902:ebc6:b0:2e2:d665:6ad8 with SMTP id
 d9443c01a7336-2e87bc2190fmr6225715ad.4.1791816347416; Mon, 12 Oct 2026
 07:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
In-Reply-To: <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
From: Luigi Rizzo <lrizzo@google.com>
Date: Mon, 12 Oct 2026 16:45:11 +0200
X-Gm-Features: AclHuK-i8fHHmdGq1sG19E58z4J25P_7xaX9lSE-RrDdVmPDw1ep2a8coGIVdbw
Message-ID: <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F563C0002
X-Rspam-User: 
X-Stat-Signature: 5nj9i3t5jd85jf683m9rbowjo16mtzfr
X-HE-Tag: 1791816350-48629
X-HE-Meta: U2FsdGVkX1/4kp8fWbuNI+yxNNzfCdLDyTUUDhBvT5EotfbO0Y4gF3PXj6hnKKDVSpP1cowFcDWmb/EyV/aw4RoCWK2DW6FIsHYWN8WkHkxKlNI6Pp1Gmgf/mUmPrYSZd6IXlIi9lTLUut70LvCK5Z2HYjLl5hM4EsQgSMoamnR4QQX4tMaTkJ/HmapQBPDVTmSB4mhcCvefW6TAMLdZP6hVfz5GWv/7KgLEjtYanpYnmF00Jl4l9wtmrq8l+qFKu3j8NgRGFjAgaXE3eZe464IdYO2pkkt0ZDHPTAVB7rc8GJQR+RQImmKqGoMjl+DTkMGaDuWG0aiZcl7NGchIFCE9vxywQV+FqER3Plh9QdpczQC7KMp8PtRjEUQK31cCS1NtrnA+WiSGjRrtO40Q0eoobMZK0tErhvINo4EpiSJsZLhjyieDOZNf8zGPn8YiokJcst2E2JxYqnEktTRR6npiOk/K5SqbMF6FhMPZ2f7Kwvg6IhWWaMiV/BZQw1zEuoFSeifDYQOLcFqLx0XYxPivf7fJjhoMfecgOGlcV39sD9Pb+4kTJQUI+MFdT+Xxa0HOoOqpQ3ykg/cr5x5w/xLZoY2bRXeUiXU9IORt9szJuLubBfSEk2ez8kwlAZM11lisFKzO2jIR8mAW4/lznX5TbVUuDdDaDRSojz5N5DJAAhJsZKKlIe17NqNnfp+oseVDEtzfMBdG/17QRnYXj2qHb5Bk0mJGGfBXTLmbvsozRh7wg2e0ZYQJaGJtdfBBZF8Gi1ZoKdWQDBZRKb5uZdEhADiTITLIWpFBkWhKGW+6BnEwUu8jpaULEQe0V5HW+xv+BkY+99bV5WvOxYBZp1YyNd+kU6SHu4GWAuNL7LIUT0mzCELjyh6YJHUL2WBOa5hpXGz2OpH1AWADAJSBJaSN8KNJ5aQUA7qR6sRNqhhZ5TMpEFtzMtkOEe8jz5s2qOrcHzDC/fXmdOp5xSr
 QPxzvhHg
 EGdWaW1BErBRfkGx6KytB2eK9N45Xy4DzsacvLWYDrnm0jdSWbIG1sbzzHlI6STYRexsEAjRAw0QW4WiUECeuy1rXT/NUb6WGHmVucOVEbUETD20n1BSK8H6DleSNFZyX4898gyMy8m3BmWfPSl3+QW4s2dHWcjR9Yg5qY2k2vREs8IXgQbCsIxNWJccglmRVXiEMLM6lcgozeyKkLAZqNFk+wUqkLG8vj99/Ag+JAZtCrAPRK6o8x4ebKg29s696mLJ7zEpmwR6CrWaOKLRw+Tbr+9npUdEXr/3vYnHdw0aQSBCiqxNqEVeXYV8UI020XFgKqBmk9vYKycLE6H5rOlihWnqZrQf/+j+VPw0sdDleg0wB/I6nnHP4I8ijveYwSjqv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 3:51=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/3/26 23:22, Luigi Rizzo wrote:
> > Here is a subsystem called DMA_PMD on which I would like feedback on
> > architecture, possible enhancements, or kernel components that could be
> > reused to avoid duplication.
>
> Here is a feedback to a subsystem called DMA_PMD ;)
>
> Why is basing this on PMDs (and embedding it in the name) the right appro=
ach?
>
> On architctures with large PMDs (512 MiB on arm64 with 64k), would we rea=
lly
> want to use 512 MiB pages, or rather something smaller (e.g., 2 MiB) that=
 might
> possibly also have TLB benefits (cont-pte)?

I had to call it something... an earlier prototype used the name IOMMU_2M,
but I didn't want to suggest that the design was limited to 2M (it is not).

Aside from the name, the _current_ prototype restricts to 2M allocations,
exactly because too large units are expensive and wasteful.

In the code, decoupling the allocation size from the PMD size is trivial.

To enjoy the reduced IOTLB pressure the architecture needs to support
IOMMU leaves with the correct size. Looks like ARM supports a
"Contiguous" hint, but I am not sure how to tell if the hint is honored
(ie the IOTLB actually uses one entry for the full contiguous range)
other than measuring.

cheers
luigi

