Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DE21073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F182E6B0005; Wed,  8 Apr 2026 09:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF626B0089; Wed,  8 Apr 2026 09:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05B56B008A; Wed,  8 Apr 2026 09:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D01D56B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:40:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECECF1A017B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:40:28 +0000 (UTC)
X-FDA: 84635498136.25.D32689D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C4EE100015
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:40:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqZdxZT2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5/GhS5A4F78WZhl+U6BXWPJcW6puWlb5Tq2pz1F4OI=;
	b=RE4L4hZC1uwL3FVBT78j1MP6KmkoXKGG2zkRheVIZMuztHWUCLH7HlwHI1a8a9wpbvih+f
	qLjLdzaA5ulYzr4drYyb/8z1bYUCNuhdgF6owXjuK3yQXj728P0Uvf9PeNwbWJUG5hABPC
	0rc8KOgTmZjWFkXtQ/IwTHfQkz7CDYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655627; a=rsa-sha256;
	cv=none;
	b=eH3j1t/682Nj7wk5Xt65Ld7wqcJoCtxPw3b4ZraKXVM7HgpeBien50ztEvw3NFSs4jztTT
	VPyELHoV1HYqRIiRghMPHgpvW204jt+c7tmaaFYng/YCBsE/IUA63IFpnww7rZW9T91tRR
	EN/g9vHWSlBYQSPl4Fqf7FMYDFSWUag=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqZdxZT2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C8FC600CB;
	Wed,  8 Apr 2026 13:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15564C19421;
	Wed,  8 Apr 2026 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775655625;
	bh=4451wQAvA3Z3+yOi17fdB7/Xv7Fv5ZDQ0G+NydWM/LM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FqZdxZT2tRM7cqTip2cr6awHnoFvrEHt/DZv4x0MsQyxTobHO6Pn4KJYj+8v0BuWL
	 0C92GZvzP1P4ndiyNj6GtcvvXkJNGeFiLdkLZ86dhWkz2ynhg14v4rxdh7cdpW0cxn
	 rjjl9tvEmCatx6Yg03+WOmLEUB6JY8O4lXeXlH8+MfOJf0Nr59i+nufBxl678Vc71L
	 OoCySTzGWbw9Ult2MIiqyp9Z5rbYqF2nz2B/xIKZnP3S27ppBqH1Q8nswBw7DAYhKi
	 u3M70kw0cO/2pU9d5vzDx/jf3+nWSQT0F79trRBLMn8KFPoJ8ME4lG/9N210IHJ+3g
	 pQx4TXMwqk0uQ==
Message-ID: <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
Date: Wed, 8 Apr 2026 15:40:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: yinghai@kernel.org, Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260407083951.2823915-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: t6zrk7ohawmkcu6pimsg56b4eo3xpg6s
X-Rspamd-Queue-Id: 0C4EE100015
X-Rspam-User: 
X-HE-Tag: 1775655626-445608
X-HE-Meta: U2FsdGVkX1/M7HuebHhPnEryE9B2fJDV7LeNBEaxZHBCP6y0k4jeK5qCTJhXAflHNzbV06CP/JyHAJ3CCqomxTvXEdPtZSTE4+JTZKiBUvPXUB9MRvtd+W1agnmF64xhaiG2KKi8524v+Guk/gBmGTkXI8h2KxOSFVDRKlSde1Ht2YULNUGRysrz02e5XbnBIgJ6QE60w0q26zXgmcT3yeyBRAVw4JgDwo3nT6EgwV7KL58TQIZ5279cty9DPwb7BJHYZMhl1iN4cOe7+2uetw5lg6PL33rfHU0Zkos96dMV2VETvT5pPB2ce3DZXBYLY3tkB1EzI+0KKgdf6g9HBR4s+S2D6rs8PNbadaGhyLmyOteYf/mT43BheDHe1c5/qUozV6zSfm09H2cgeY+Lf7Aga6woEkYOn8CaYMxFcIKj38YboV9gtX7tx3qooYNJh2q9y3YL9nhOGOtEg404rUDvnI5149aT5/CBbFK3LFXyol/u4ucZ+qTolfSafzRHJ5UKjSLe+EkXftkaFBZreW+MicKChy/w2IN7tmsSS8phOsv35VFknf/0Dvny7HV1Y/oqz6h55Xd92fqkETSQjHxKsAcgeh9IAAdHdawXSicYkMLenc2sQfdJfDoseFFMsldbGgtg6Hyas1AKXXeYHjIR+ZcusqMpJrIxcpLG9zxWtJBOcScyzcLUz6lb5+AYpdBRJnoGKSitinfnvB83xDiO3qpO67K2rH/fHPhqBIiyIFrFvzHmCkrLkA3nLYo6bju/EsToXFbBLYWBAxpdUeStzc0xMbb8Beb0C4pSRPskJNBvOEJhnThmZ7PVxHIoPxXzvMSsWvqwT+yjURWkgo58wSwtcAeWakAh/+AL1mIkQzg+syXlFB+VGqaK0/AYIVvsM5wwndkg8cBOOzG7Zd5f57KOahAm7NbV4mwZnRK3ax7mlck1z0OZ01hxLWFlg2XQ3xGM16bYvHrpyF4
 +QeRaFbj
 vnfEgHexaFUTIz56MZ4+WnJGkZwfJ0/tT65ltn0Nz8wlbyuykEyF5nPPE2DVWC8DWJNVlnhxOkoea3A+tzhIN8ilobNp7OOhrJcr0fJsnLlniRN3G31Fw+HiS+/3NMVvfly+tUDaKHPQQRQgt3H36jX+gwPr7RVr8GN1sw/6IjNLb2KZWNQ32Oi+RbHtpmwjMTEGTgIFM1JMxYgEzdcUMBFBAEUuho+wMFsb2udMd3WXaxt/Eexj+9bTwSH8f6CdLh9v7DGkguxrJlFnyNzxT2wJg9eYh+pqT5sjURYoQFGjUla6az9SOUsQTJYfaf9dmw2YxoEs+WKXKFvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 10:39, Muchun Song wrote:
> The sparse_buffer was originally introduced in commit 9bdac9142407
> ("sparsemem: Put mem map for one node together.") to allocate a
> contiguous block of memory for all memmaps of a NUMA node.
> 
> However, the original commit message did not clearly state the actual
> benefits or the necessity of keeping all memmap areas strictly
> contiguous for a given node.

We don't want the memmap to be scattered around, given that it is one of
the biggest allocations during boot.

It's related to not turning too many memory blocks/sections
un-offlinable I think.

I always imagined that memblock would still keep these allocations close
to each other. Can you verify if that is indeed true?

-- 
Cheers,

David

