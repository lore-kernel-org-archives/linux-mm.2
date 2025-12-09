Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650F4D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 08:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B8F6B0005; Tue,  9 Dec 2025 03:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605166B0007; Tue,  9 Dec 2025 03:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC846B0008; Tue,  9 Dec 2025 03:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374086B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:18:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D08C358F56
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:18:57 +0000 (UTC)
X-FDA: 84199231914.04.9648523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4025B40003
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 08:18:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+aaFS9D;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765268336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aL/hwR8PIWPLlV6uFQBsf2fAQbPmjSBfIHKkmx7HAzw=;
	b=LO2d5j6JoDZNqHkIec/uVRTwCY1tOT5m8pR/+lEeeT3yDT1gFUlEQi6xTaBf06FBy1dCN7
	zK//dHIVUmB2MF4timvTJdER17YL5YCMWa8Dbyi5T33Akfm8JyJryYT9DFySd1vmOTXWJY
	Z+bT5gWqbcBPo6fuavaysQzbmvJip74=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+aaFS9D;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765268336; a=rsa-sha256;
	cv=none;
	b=a2w7/xrCZ1ykvW1JtQ0aknzADyp7BeXXf/7rv+x+p7AH2ruzIN/qcVyZJifCFNr4FHz1ZS
	ZI4iTDrSTIDIq+p4JbKaXpbOFmkiIO51X3leo6fGXYoOOXgn+nLT4ovFDwLrlITz8oylqO
	048pPhcldXU3WSRpT6fOEl2gUFnY75M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 414CB40408;
	Tue,  9 Dec 2025 08:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66519C4CEF5;
	Tue,  9 Dec 2025 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765268335;
	bh=aL/hwR8PIWPLlV6uFQBsf2fAQbPmjSBfIHKkmx7HAzw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=J+aaFS9DJjhtBzUXMwjiV1dTctAzbSTgd+qhpLMl5+L/KZvE8jsx3AyT07Pl72FmX
	 DBXpTNDIbkr0ESOZCipm+oEipaq4Us8aDhRUR89KNBqA+0HaL+Rx/ENO3lxV6x8fuW
	 zptCYOGL5rXnmjGw26F1L16Wwp931gY+IQ6hg2bslYXpzSAJ9LgoTsnFgsw9jq78ry
	 1BCC+EnCrO8RFAZGdvmCba4sJVIpSvxSVnHIHT/MVh7fJqJYfQHh7ASXPxCpKc5FTR
	 5B5vOjVS8NOEHgGq2/S31MnHy6yDdyNJoBZTN7PXj7Rf8Rl7DtrXCXmUHKkDB38QiT
	 z81VvUd0S+h+A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 00/10] liveupdate: hugetlb support
In-Reply-To: <48d0b46e-2b82-44b6-a717-94bc258a508d@linux.dev> (Zhu Yanjun's
	message of "Mon, 8 Dec 2025 20:43:22 -0800")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<48d0b46e-2b82-44b6-a717-94bc258a508d@linux.dev>
Date: Tue, 09 Dec 2025 09:18:45 +0100
Message-ID: <86h5u0ax0a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r6dq5oyfkt4mk19qxyp3cq1j6a8mpefz
X-Rspamd-Queue-Id: 4025B40003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765268336-900256
X-HE-Meta: U2FsdGVkX1/fj2M6iQEonHmf1CCKLEJ0EHGxledKQgNLIk3EtZYCUvrrnq/+J79ZJFzG/fd7PM+A/F6YNoZqDFsrYahD2joZiw3eGczAuDsPacFCzLv6/BSwkYaRxBGngYmsiOvPWIBk576IZ0uFjUVLI60jHKIhNmDOkwjsQtnKja/zKRlyqvVkBwYc9aM/1DqXTHLKCNtsi6hPODfgmuKF4kyCpQprBwRAv//McZuHix6U0BZEsWPSC7IFiQJGjTMO6UmX1tdlS+nqJTcl2YhyWFT7COeMF36tz6sknGTL9IqBccwN0hhQrXlQ9n3ab29bt1+9G8vyzivIuIX6bDEJ5Hm7hqqwAJVk3kYhILS1Ek0kYFc8sqfvENe/N7HGTo8Rp/19STFx+6hetxfMkK6HPckw4sF3EeveRTNqQzCaXNaFW5t4lrFAIMNYM+Mk9/H3NAqtSSb+AFSeFwm2ElJjT95QvUmlx96VNpFYiOX/+gpTnQqJ+osEmsMimUd3XPlaqyPnz0cM5NQ0kUqm/MVkC1nqYhTtsizK51nY87tVZdmyFKg9eq3R3pGoKA9AbHiWoKX6gwscD8uuBGV4Xh2LRDahGlMy7Q2p9NQjT0rQ8iDuw/aUY1fxKO4pCYKwhEF/TgYZReomGxSMl2xsfguC5ZmODH3tkni9ZSW79jM2XrivR7PxGvPlQ+zrSFoTcAE0H2Cy+OMxUVIZw78L6NO9OHbWYOMWcidoCRTRP/QNxYPe7kFFxJNOgwrDCPJK3vD31qDbCRTmpMFWbW2pcHDpUxUULhrzyOvPFwLQlhWKRzfWswhSf9L5pddLEN9D6WdTLZ2gZbXF3oHYqiP3A9e2jdRQScXGMzQ0gQAct8dzrotWyE7HNl4psa7SEW7sgSIMoncEf11pztRTrUwO2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Dec 08 2025, Zhu Yanjun wrote:

> =E5=9C=A8 2025/12/6 15:02, Pratyush Yadav =E5=86=99=E9=81=93:
>> This series adds support for live updating hugetlb-backed memfd,
>> including support for 1G huge pages. This allows live updating VMs which
>> use hugepages to back VM memory.
>>
>> Please take a look at this patch series [0] to know more about the Live
>> Update Orchestrator (LUO). It also includes patches for live updating a
>> shmem-backed memfd. This series is a follow up to that, adding huge page
>> support as well.
>>
>> You can also read this LWN article [1] to learn more about KHO and Live
>> Update Orchestrator, though do note that this article is a bit
>> out-of-date. LUO has since evolved. For example, subsystems have been
>> replaced with FLB, and the state machine has been simplified.
>>
>> This series is based on top of mm-non-unstable, which includes the LUO
>> FLB patches [2].
>>
>> This series uses LUO FLB to track how many pages are preserved for each
>> hstate, to ensure the live updated kernel does not over-allocate
>> hugepages.
>
>
> Is this patch serise based on the patches in the link
> https://lkml.org/lkml/2025/11/26/1665?

No. That is an independent series. This series is based on
mm-nonmm-unstable, which has the base LUO patches and the LUO FLB
patches, but not the VFIO or IOMMU patches.

[...]

--=20
Regards,
Pratyush Yadav

