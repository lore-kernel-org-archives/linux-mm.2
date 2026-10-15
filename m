Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF23CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5E06B008C; Thu, 15 Oct 2026 03:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376E06B0092; Thu, 15 Oct 2026 03:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F816B0095; Thu, 15 Oct 2026 03:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF9616B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:10:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD449C0927
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:10:41 +0000 (UTC)
X-FDA: 85323987882.18.788B9EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10762180002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:10:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtteeYFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792048240;
	b=wLR+YZb36MLhLgVLBWpi8bwhVLp0GQzZ6+iWjwHGtaDCgnUP7DL2Nm+azO6/0cbbnqrsrG
	SkylqaPa2s/jYLsCqmV30KLna9uHcbQGZb4UGf5WD87ptg7ER7fUc69X3EtkhI6GhOguFA
	WvsPclXUuGTTyJaVPKP2U5zZ9Z/sRAM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtteeYFf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792048240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t35CZqhZ37FpgWrxYiwnoxvM2WrIBjmPysOYClvNAFg=;
	b=Nvb1Dg98ODOQoeBod/YzeAJfd6joOhAlBZJR7o/R2sV4dTezxo2L/GhvOrZQoZBDENzL5o
	7ea3+gXmyZp8n7nSOAO17LnPW2W1YQ0P6xN6bdnOXLGBOECaFusk8jd8jx+gC1Oiy20n6+
	8gBS1iGtqHk5kjbDdxCeEm0te9n50A8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B79FF6053A;
	Thu, 15 Oct 2026 07:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2571F000C4;
	Thu, 15 Oct 2026 07:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792048238;
	bh=t35CZqhZ37FpgWrxYiwnoxvM2WrIBjmPysOYClvNAFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AtteeYFfkxiI7tEEpMbi8Yt7KJIKQSaoWpn4H36UJAg09QBpf7WG4edfMyvKSNnmk
	 f8K68Cx3Q/125UsxrICx0flle39xsvHYEgg2vTNLdV9dvODivacIr0a2kWbAdpAY84
	 JkR5imJAv2Fud4Q/jO6EXhK4to8N6hfGPKinyQ6fKNWbtQwyzmf7Q2eTvxgEUdkFF4
	 KxtZAGiEhyIOGhpWb2ACDNImCrhkmB+dLsPbO92NkHm1xREah+d0w7UJcIBo/A9ADe
	 pOMorbyndlL677Oaj4VHidtSTpiYXIJ9HHYJfTMNOWR7sALvJZ23LBMBXZiCnhXrXq
	 joWvay/B8zEtw==
Message-ID: <51b242a5-3918-446b-8884-30d6d05327aa@kernel.org>
Date: Thu, 15 Oct 2026 09:10:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
To: Nimrod Oren <noren@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261014140859.1006967-1-noren@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261014140859.1006967-1-noren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 76xk77ph3k8kyc8euecotbd7p7fhkimc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10762180002
X-HE-Tag: 1792048239-288727
X-HE-Meta: U2FsdGVkX1/KQdFdgQmH/AHlT5VVncOP6K+iSpKhE+QBgYuGkn0ytmC+MTsJmQUh/dVxraIcdfEJCBko94PCARphRxqX0M39RYrdguWObPJ8cL4/Knt7NTKGHM4v6eRFR7eiBo0xwYBphvhSefLuYkpiIB5EIs5fvSXmxyKGxOuBZTe+OPELFT3tzCoWtam+dH07DJgWDjsr9XwH8tX5BaNgy7YDaJNt2qrsGD3hGvTNwhRdg/51cxbRFrWaeVDuVg4PIAdmDRxVH68UIl5uSha8CKLaIYXoTQy5CX3voUnv2YTDbBvHDOFCpbIMibO1Z8LbsgyNWB4TGwpSe61xywAwk2BYlRe41vx2TYkEfr02F1kf4r22PJYb1xopmAetd4svBZjGlRxwPCMqj3uhtQcF8DqlSG1tsJsRqeze5L1NX/rCGrydE8143ccDcoUW1SkhDMP6NJQwDfvBuihT/ZXU9r8scB2f9LXSzh4vQA4Euadw61KDhUtXahssJcNg56GBWRMPOi47AsIN+tposeGKNIn8Htcl9JhUjtfO11pU0KMq43Ki9IInbpzsyKS3aKrJvsbHzZHL8cO1r/8ulCB/uvif8D9kNXOzAW00TuE4doHyZiGFV+V2uV29zl2sM3T7MUe0K/pX0WHTNubgngUL19LRjnqVuudyLDLVrp2RhyJoPMzRg9CFYgTrj3jFgXotFGVexCyazHMiTG5iy02Pt0NgAL1qevJL6lUmrchVQbqUP4VDF5lV7YO4qrRHusmu32KwByctjYRxndwhul7rCns8Wi1O9P/97VIf4AsNrx+qluJZF1pgeKTVYfG8pfxx9zmuLnxjHIxxE0rZVLFxzTm7/Esf4gL66TIrmZhzCqHmQvSJg5UJn7NKGEtuC3YYsudzvy61hGyM2j58Ud0pOgaIqx4Kpk00Tzn1x2ZgfYmFHBWm5vzx3QBeD6H7l9fhoUPDbEQ/Feoxm3N
 gkwS/hoo
 p+mHMgmKXeZEzQhMrlZCfxWju4FI7wbCr0VbTZHdSDh2u2i9keQcqwZrBwINHKmaNFatlkcbF3xD6iElLQlKNjpCg58CKteMJfPgS0n1VkdiUiTd2DHK77jpaOraelvNHum/tiP+qMvu11pm744fbaAnrvP+MGdImdUwPEuKy/uoQRZ1BY4lm7LWcSuoyUgSSCOSaIRqQlvZUXrxaRLzbw1enMM0H3hukaHhGXYSOGSFtgp0RR+cRpmpPpSP/20QqvzTe0+MJTK7kjAyblzn2znszCSFVxM498jGBSc7eYuoTxPe59zmD9UaPOl8o8oNJpmwsxKJVVjb+2+1WwFVqzwZuyuNBdSGDuwJ7tHSMQw6HnzPco3Y4CNIK+bNTUBwAfF1WUz1EISOy3+8WcwzYQZ0tYPLdybBLN2sx2h8Zfdizy50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 16:08, Nimrod Oren wrote:
> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> writes. The new value comes from calculate_min_free_kbytes() or, while
> THP is enabled, from set_recommended_min_free_kbytes(). A value written
> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> higher, so a lower value does not stick. This matters most when THP is
> enabled on configurations with large pageblocks, where the new value
> can be excessive [1].
> 
> Stop recalculating min_free_kbytes once a value has been written to the
> sysctl. Systems where the sysctl is never written keep the current
> behavior.
> 
> Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/ [1]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org/
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!


