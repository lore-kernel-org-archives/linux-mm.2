Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A86CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21336B0088; Mon, 28 Sep 2026 08:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1836B008A; Mon, 28 Sep 2026 08:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0676B008C; Mon, 28 Sep 2026 08:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFD66B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:44:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1608DC01BE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:44:46 +0000 (UTC)
X-FDA: 85263140172.05.E5CEE07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B2051A000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:44:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzG5j3GA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790599484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZo2AMqW6bb34y5z594VrLXKq20u+UKoMHD5xT8vo4s=;
	b=u+jv3Inr2Vd2Pa3Rogt9ATwmIs77xVrfFs7LC7iR15YWYevi5rU543se5CMhmCbUHqTl50
	kJuy5+KaUbeDRmmRF1k+kBt/HxIZ1mTkszMwmngWUYtKRp78YCy/npJf8lJ4cXTLG0LHGU
	Cw85uylw4V4OYCoFLacwV7o/1z2qr3s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzG5j3GA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790599484;
	b=rF1kXXeQD4PmlcYJ8T58rrQCfM2Tci29kZdSjRQD1lzZL2V3WElVVJOAGC5AE1BQTbjvNl
	cx2qUuBuke2I2otiCFg5exbF+4hAD6J2+Oiek4iGTQ0K3cvHLy8uX8XPCs3ZZId8RX6wNA
	xSVspXopIbJXzftRPb68eq6aAJ4jTdg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5897E43FEB;
	Mon, 28 Sep 2026 12:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAF71F000FF;
	Mon, 28 Sep 2026 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790599483;
	bh=JZo2AMqW6bb34y5z594VrLXKq20u+UKoMHD5xT8vo4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SzG5j3GAsaLpl1Ye6fKOp9yIOCabQQBJFvzTvELAV3SaTU+j4D4qIExCiYuzY2I+u
	 hp5nXm+u8GUW/jN7ksy2K0fk+UUAZL/u+MbwYjid9ntbZFN8TIk4zajHZNf+ADaGmJ
	 45/Kz6LZvU89GpqMaAyk0eWOZSGK4df07O5AQ5jPEVMLRhlG3bYJYCuWdBv+nT9YIN
	 m6RE2n1e1xi+8QZYxVjL3DWvLY2gpqLH8Ig0RkdcnQu2Eq/jM2JiQs3Sg3Sl2U0J81
	 0zOcvnH8W74eJy8nCWPRCCGNK1sC9aOjVQ1i1R3l7X3/aQ7caz86/gTEgVfMiJ6K8i
	 6Ws7iqKGL9Mmw==
Message-ID: <607759bf-59f2-4ad6-b95b-e780ed2acba3@kernel.org>
Date: Mon, 28 Sep 2026 14:44:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, muchun.song@linux.dev
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B2051A000B
X-Stat-Signature: fxd6jod4figwrtjwxs3unr9oyniocrd9
X-Rspam-User: 
X-HE-Tag: 1790599484-564989
X-HE-Meta: U2FsdGVkX190E1ES8+JV+ZSmpMiqa9eoW7z+h9c7StMNDd7cPOQvc8SvKAhk+1l5b6my0Xdh6Q9w8GvreazsAP0R/H+biUa82xspD74+wwBnSXUGoGw2dfqs6dcwVgtLJ1WrNK7Ve0BhbD52SOLqKKq4FuVmBORWZ15zDK/DRbLHVET6Ah18MEpUFgCXjHrN6nlKe4xFUbDZdh7QLKRoli7aOSBKoyib3llW9BwugCi+N8tUtM7OUdBR+ncvhYRzXAGbpnPBYUaabpK9j1+X+emC9bg1dyA9wwj4ll+WBZeuM1NB9KJPNGXbGLVvH2JkIwmHdP3SI6um4vuH2g37X6TfLY/EIMotkpD/wOs8vJpBPSZqGp6BKCRDHQWAnapKHqxDTEWdsNjbtfdEASmfYttH1bdv4iWoGAd87DomgOUCSfjR5a83NDMgSTc/DTPME6f85egZDLxSRhQnfT15vyiaKGEbK6b2yJ/8vARPOYUTLmOD1ztgGgTn3flzTm4N7QpTXC55Yhl6ICQWFZkotUEyu5z25qJn7Ybr7ptXNrt97qjmwtQ9Qs+DX1n7AceuVnpWSilaxZfNDE68V+TZVtcy6wu3ay2aHFkRoAh/QYRHu51XYZgsNfya8eo/PVwdP9Y5T3baLxVqMX2pxny6t+UgnwzL/osPUwLa6gCjal/WuS8KNSe/ORMGdkogj08+iJQ9oc3bIcFkIaoYoNhJT4lzalC0uSWEqed5bmMvfkmS3SfVodQRxULZgBrpoUhho13HucXW5jiH35IQk0OB+vDdHo67I1nn9VTlFLacj7lNpkMfMRPWBhyd+6kjZNlRrWfsMKcvFV7kPVUoRB4/EngiZh8mo4Jylosyv/oes8x9RGEfu1e1S2SZ87DvY4ffD9UQCV3UsxVI5z9k+KyZ+2lJeZPJdTFOqqJ0olKeRRYfcYVvF5V1us61pbj2DceXYh53gTNguwDVI8KpkMZ
 2EkpNQ3w
 iwFfryOgMg55g1VkqQR1df1iYVOnRNAy4PC+8yZ4EEd/EcRDoJcHSOJnn/84HnaUnrVitSlNTq98+mrUmlmxQCGFyCNmVpF56Rbn1y1YhQIImtehoEGJaJl1x6Ucd9zB/Yg8273B5bDib4r4BljJ8WBl4VSmLuww/cZ8vqIDgZTCQDs+wkQ4iw4iXN6xTbKCUEOMfRSAyfzcTZtHC9UvlhhE5vdZYITbcgUEc2EAbGrwrZRwhEomjVoUxhIgohwtIgzPK2VVmq/2jDeeZUNE2McqKXuF1MkNzmoigDmXwhvwzWanRmUGor45Z2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 09:52, Muchun Song wrote:
> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: unifying their vmemmap population paths.
> 
> After the preceding Device DAX conversion, both HugeTLB and Device DAX
> describe optimized vmemmap mappings through memory-section metadata and
> use per-zone shared tail vmemmap pages. The generic code, however, still
> carries a Device DAX-specific population flag and compound-page population
> path, along with arguments and helpers needed only by that path.
> 
> This series first removes VMEMMAP_POPULATE_DAX and moves selection and
> reference handling for the shared tail page into the common vmemmap
> population path. It then removes the generic Device DAX-specific
> compound-page population path and routes section vmemmap population
> through vmemmap_populate(). The powerpc radix path continues to use its
> architecture-specific compound-page population implementation for
> optimizable sections.
> 
> The remaining patches remove the unused ptpfn argument, open-code
> vmemmap_populate_address() now that no caller needs its returned PTE, and
> add a warning for inconsistent zone initialization of shared tail vmemmap
> pages.
> 
> This is the fourth smaller step toward the broader HVO generalization.
> After this series, HugeTLB and Device DAX use the same population model
> instead of parallel generic paths, while powerpc keeps its
> architecture-specific implementation.
> 
> [1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

How does this series relate to

https://lore.kernel.org/r/20260927025441.741633-1-songmuchun@bytedance.com

?

-- 
Cheers,

David

