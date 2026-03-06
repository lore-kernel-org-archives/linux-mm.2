Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A32FCB602
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B8B6B0005; Fri,  6 Mar 2026 09:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEA16B0089; Fri,  6 Mar 2026 09:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FACB6B008A; Fri,  6 Mar 2026 09:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC396B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:42:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1404597CC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:42:10 +0000 (UTC)
X-FDA: 84515903220.29.71F4E8B
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2DCAD1C0017
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:42:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="iPhnnC/A";
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772808129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emAb7Y3Xy3vZ9CUMK+IpAxICUzam8RYIdfg00ey1KxU=;
	b=WTj/QobZJHnXOZm9XLTflSEcJndwlTLDucjBSSQb4tNcWRYW9m3Oiw9ktvlUuXZl4qXjiT
	8p4LM/pDjp/3m1d9DMzpcIR8HoiZfYZ75k1RZpOuhGByDbt8+3jgrZCQE2bFlIrZ+LrQT2
	eVddA5roQ/Qz82KfTvCHBOoaZNX+nBA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="iPhnnC/A";
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772808129; a=rsa-sha256;
	cv=none;
	b=NOcquKZV0CBMQXYtRKV+HfkVB9AvylUL5usk2fas+M2+DFzVx2K7s1eMv4pgxmZNVB1iUR
	+o13rfdq3xHLTz66lyvX1u1jLpILDRY2pr9hth0bUdjBP+auoRmM9IkSeoZS1Ob4/DljBK
	Gwl7g1vRfuGnYDNMokMigOU24chE/5c=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1D0CB40E0169;
	Fri,  6 Mar 2026 14:42:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GexwHBDjzfzW; Fri,  6 Mar 2026 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1772808120; bh=emAb7Y3Xy3vZ9CUMK+IpAxICUzam8RYIdfg00ey1KxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iPhnnC/AJNtKdGPUOG709iZ+fDJD2cUvZK9ZQqrh9EbAiHzyHgUQ8q/awRtExmEkT
	 i4pNnZFDJd9Taa9S3K2O7hMzO52n5FruntDH6rYXvsa07+ahRmTVSoi82ToquNO41I
	 9H16wu6grg2cjxbg8kDXjM5cf/ctUIlhf+GuP/+I6yqgshen7nU5npeTENeLgvEAZL
	 NHCZ8u38VwtY2ZPBm4dbKDPgfOaqZPMqQdY4ENevqTkTYnfc2b75Rvluchmo9PXYgi
	 hStACr6y6Pc0VtI5eLDoNu83rsyS6TbeNGBZx21Cc1LpqH+8GD9k2CC5wj8swSUA0I
	 BMGbXxW4YlDPWgkRMUzNg09+vYY3tJPbtcK7FDbQPFBq5zI/z9FpmSfefHeEdCpa7G
	 T73Wax+MgYvRwsHJNCCyYfW8MBAuCv8CjA+laR84FGR92tsoynfAEKfl1ih8tKQiVG
	 zHehI24FrSvkqseBTgJBl2hCqKN4JsfFnpFIjn1VK4eFjepK0kMMCd52tzhVomqmc7
	 y5qz8JlHk/zJTlP1SHYqvnwsctkyEUzgam0lwS2yYVjJFJJ1KLrle/2IhluVoHQ0RG
	 pBkywudupFdUchBasgL54K7aLPRMTLXNWpGF9qrsAkJS1wkkpXoLjFTFglpfNroWpx
	 8abR3MDD67jxkCp6iHE00so8=
Received: from zn.tnic (pd9530d5e.dip0.t-ipconnect.de [217.83.13.94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 0716440E00DA;
	Fri,  6 Mar 2026 14:41:34 +0000 (UTC)
Date: Fri, 6 Mar 2026 15:41:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
Message-ID: <20260306144125.GIaarnleCxQjM2Ocm6@fat_crate.local>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
 <6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org>
 <DGUT0WT67V0F.32RH4R5HZ91VP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DGUT0WT67V0F.32RH4R5HZ91VP@google.com>
X-Stat-Signature: zzegjxwkrutaqb7dz5kfbt7hydwnbfbw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DCAD1C0017
X-HE-Tag: 1772808127-871919
X-HE-Meta: U2FsdGVkX195vM4OASkGzksmDNlev4bIgQE5bDMi0IWbs0CDui2zC9ksHJAO8ekJASo84MPce5gGrK8VrL7RoZdVjsz/FgqZqVlzHSIeSRdLvXZ00E5Xahkz8nfWnHvFRJI7vts7vhAUGmQszP5kowPxwVxJwlQX9mhYrGngG5zLEIAi0lru17EmR/nhr6S8HYzpx9TCH37b7hz8b/MQNFaFyy686+zIWjMNlKsvmWfP1mm1TQE7iIwa1HW/74vt3S8GOzuyxy15UJQQ2m/QmN1j+gTm65airl7Hu2DZCDfnRG3CNpxnFNLs2HZShV+TtoeV7cZnwFjv2gXCdv7clQhOPWZkvaHeJAeQAkwK/uzJhGnZImyzP2gC26iP5lc0BaY9wg1A7T6e1qhdDJyqxoRn+7BmGl0Zz5Vz13U0snvkQlTe8tL8izUwaWjV3whLXmkVd1VAHDf1tr4Igo1qOimqJ+7/rJbxqf8xSjyJUtzxTxMgywFXWktRmlAJ4Cc4dGrEMawL4EbqNBfK++GP2hgKqAagHSf4wUaRoCpSW/0nSkyXrWwDb9xMQ+RaJIQSVjNS0RN7pGDnTh33y1CR31HoQByuV6Bs311U1m7YHBhpp7uOnXva9p+Gdi3n71eIlbJkvvELW/IZcpkiaPeX0t4QABV5NHR+YeHo7Jjl65XtEeQrrHf1JePX459myWK6dndFJIxN5IR3YLuTY9/XHw0nZ6GNw6b3jO4P3d8ADw808YjHEChXHdwxc9X0QKnetLoITMWHqzILorrM1iOEE5MykmDzSAzMUy7FxyXsbADHIMNBoBEj0W3yY6jJjYR+GVqxFkRiNrfeotFuQCbbepSq/jJJC+9CZL4rDE7/4moFvozgqGZMWPZxmGfziciidWdEvhI+eA/6iO/i8kZ83M6cw8uu1jP7N2n2I8of7ch2PipGr5OQoASb+1NRq0dCosAhvHD/09W1BcTFwq6
 gQ4RCOD9
 k8RmpTQwLuFr8UCReoQgjamRt/KHNCvOGXts6qrgL1khKUgsv5PlsxY8Jjdxr8/i6RU+QL9BSo2TiH0DNDhP4u5CsdgjACis5Q267l6JqhAe/Qwx0ViCU/V5yuxC5W7x3E8FDsTfxvqzArLdzK0FCGqBn41QWf/++Le1xKt0wouHG1c8xce0fysWM+rrBLscwifqbXq8POiYCzLi4OeiABCi38Elv5Ch6jFpYfFPxmyKBI771rPVjVByJIvwr32UTxXiOnNLlTk8htQDA/UTBi/G1nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 11:16:07AM +0000, Brendan Jackman wrote:
> Ultimately the fact that we have KPTI for 32-bit makes it sound like we
> would also want ASI for 32-bit, so I guess I would still want to add a
> GFP flag to support that on 32-bit. But that's a pretty futuristic
> problem, I would say we should focus on __GFP_UNMAPPED in isolation
> right now.

I'd wait until someone really really presents a valid use case to not move to
64-bit. And then justify the effort for adding and supporting ASI on 32-bit.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

