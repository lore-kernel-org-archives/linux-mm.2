Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E251075262
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889746B03FE; Thu, 19 Mar 2026 02:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839B36B0400; Thu, 19 Mar 2026 02:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F656B0401; Thu, 19 Mar 2026 02:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 60D396B03FE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:41:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0976B913C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:41:07 +0000 (UTC)
X-FDA: 84561865374.29.671F539
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5AA1B180002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:41:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BbguUpda;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773902466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1mdaIGIx853k/Oe8qWYkRnKkbI6dGMHnMB8adNIIoM=;
	b=fTvwIDkARHYxorVIZ0dUtep3ip/VhMW/1TV1OAoo2u1iOO5chIo/WOibTXby2fPy2v92Hp
	tDMG0K4Dzkzw+qpPlJUiON+zij75XMwR6UkX7lWMPELt3yjUdBAAzfeIobdoTVQ2gGFISf
	HfcXJuQEa2bpzRisH3jrB2BLrNpDrD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773902466; a=rsa-sha256;
	cv=none;
	b=Gb6zbBEvccsjAyBRDMkUOZ8jTPtsVbrkYQqqiop7axjiggg/s3s/mUuIfTMmGrVHMYeeG1
	TpJ7kOANk/FX+/sld++i+t7IwOeaNmlo1e2wCMdJ+2jy/2aZvewWaHq49j6YwG74VB8Np9
	5TYzGXpgaTKZB3HnXEuY5tOBr3nGXbs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BbguUpda;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773902462; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=B1mdaIGIx853k/Oe8qWYkRnKkbI6dGMHnMB8adNIIoM=;
	b=BbguUpdaPkbqx6EDnfKxG4GVDxL2KH5wDCmZptR59HbPhLGkzkiK6oiujIVJauggPQVWQPwmiPpBpZvLM+z+a8LPXDeAXibd+OUxPJPlMTynfhsnIl/AD5focxwwRSlMI+MnZN7f4YOqiytLuWAQE8P26n1xB+jhYXyEDbQ47Rw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.HUZpe_1773902460;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.HUZpe_1773902460 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 14:41:01 +0800
Message-ID: <cd72aa72-2e86-4b7d-8147-61aa6e30c213@linux.alibaba.com>
Date: Thu, 19 Mar 2026 14:41:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/huge_memory: have zap_huge_pmd return a boolean,
 add kdoc
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <20e00d784adf1540c32b46024a709dfe1be93019.1773865827.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20e00d784adf1540c32b46024a709dfe1be93019.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5AA1B180002
X-Stat-Signature: eni775kpe73f7qm7u5cbzsjqfgs75fxt
X-Rspam-User: 
X-HE-Tag: 1773902464-35242
X-HE-Meta: U2FsdGVkX1+8jRqqDlDzL5qLaLiwxIFf4yQIAVVRDRibBUrxlhSSKCIq7TKzX4XrbrC/v9AKbxX2dF5SmCajkVotESbbfXxQRodVdBAzM4DMRqV5dSWRB6OV64WJdAx3GQRb0LLwJKrDY9e/SrHoq+b7HSlTBmg31prMhdJwYNYmB2ZYyiEkvLERK7hcptTnCZp9cW0e+1TIZBj1HE2bvEuEejX+69YHs2UVFhI137HSOURess2gui9SRAglUK4f2ieTi41PDGCwKA4Ky/s5NOPWK6QdVKoA8HnKg3wAyz2FqEEtFTCgE09vCjzuFZzjIEHPMYtBZKJFSQx8AvZluOUk2slyYjXxRCEu5JYVFC1qtT6k3Afu4ImFO7DCv4KoL4P/kN23jV+crB+pQKb4Ukr75t2kF1fTx766ecepBP69l6e0hRse9pq1DuOtxXW1e8oiWICA+XNxrD1bYrQvBaH7CV9iPveaRKsEmCpRxcUVimEiveKrSZJB/Shd/NbUqDqHkK2GeXZ7L3otSwiNyZgEJpEZNw1ioB8V1/oje1IlEuvc80KaaY1JA8FnDsAPAjR2sj0ZC/6s2C0hvy6+KLkEFbPurkexdHV9Jllsw1Z5RHT7Ei7NNrNPvKCcx03+7Q33XhZ3G2TF5rcI2/uy5mc66e2yKGax1wyGPYmpZtqOO+qZuTWGvubsns0R2fD180rajY+Ygn8N+hJSLU9WbmPp8/OclB5anIuqqNPT003VyKHo1XkUenaTiRx/3ob+IR6ejquqA8Pq69Xd0IQIddwBus40gU6MS2GV9dcD72Jaosb0nekVhZW5thZKXeL4q/uuhNK4uKsVpCPDb9gr4B7BTKQn8Hlcq/IEKdHFEXdCp9ljuESVaM9puZbHS5qPepv/RGMB8B0P2vkV8zFNgjR7qlnDlra03VQCFTwjCrlwfXtnEVcgmI6B6iMuAjTuV7DAzvCEDYyyZg8XGHA
 ce4d6EwH
 HG2Vn/8HCZwwutrPi7Wt7We+PtG1X70xCyJdj/XWhpN4oB6/F6bkY/Gnpeec0VfGQV147USP2TB97QGtmxql5mi9AsbI8UOfEMUGntZS4s6smzsttPSCcd6xx/qlslGcvT8uQK7BbKTnfgWgAvsItJBQeDw/HKHGAYugo2CAXnrrwGKlcF5DEw/V112NNq5fWKoYNsbif3fY7/riYnFv2NVlVo/wGqPs1dJJr2TtptrswvObgBnREMrP9D5mmdaRc17lILW/cfc1iBDK0mP7cqhthgLbcSDQB8HAAAHgmLbVLQZ7tgoJ6dvZxMboY5f+KuE7VfiAK+wtAWdhKMATru7yyYH9n2Ng0b0mJjDltNTp6yfsXAgbPas/B9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> There's no need to use the ancient approach of returning an integer here,
> just return a boolean.
> 
> Also update flush_needed to be a boolean, similarly.
> 
> Also add a kdoc comment describing the function.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

