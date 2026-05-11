Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87F8CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460BD6B00D6; Mon, 11 May 2026 14:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4387B6B00D7; Mon, 11 May 2026 14:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375566B00D8; Mon, 11 May 2026 14:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 295266B00D6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:31:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC716A0223
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:31:05 +0000 (UTC)
X-FDA: 84755980890.20.5A7D34C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 14BC6180012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:31:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/8ZIydK";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778524264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYkluozGFITpM9NelFwzIhny7qYDLXpeBC1u0qrihRw=;
	b=gkCginIqxwzWObUp0ZZLkqRd0T4340oGdQWGbG+8UUQCjFDi1GOMXPKfclgcNht07qmPBm
	PlDeh+T5CjWrU71pI1AQC4SXXpygmfY2T9N5pzLvN+cbbQZyjgFTX6hAUeGI1qbuz1uF7O
	rfnYF6p4TldK8Qhw9qdLtENuE/2RUz0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/8ZIydK";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778524264; a=rsa-sha256;
	cv=none;
	b=5dPjrRjGAK/x8Shro/qrCIXdEjy1jxcdUPFbc3+hbkQFoA3UHK2cJl//GaVHfPo2/4kmrz
	3iiu1mtfqQBtn2kq73TicY5qjdwPiUipX7fmzUFwtaFkmI55qZ0mUPk2cOq0I3RbaVNSzJ
	aLk3bPNkftikSVvIFgBwshN3Sxemkec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AED9600CB;
	Mon, 11 May 2026 18:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD5BC2BCB0;
	Mon, 11 May 2026 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778524263;
	bh=EGNBeWGj//FtEgqBI6u1TnkDCr3A5GP106MZey7UBZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p/8ZIydKvITZ9Zj2K67WABbe66oyuylMByZNJuJY+mfZnekChL26b8YcO90CRtTMh
	 gYjJxv5JgCucqMMxDsR8XEoYhIbuiXOeeQMZJVIhZkyK/+2qT4xhnQCVmcru40FcRH
	 GluUwo18XFwH+hm2NTzMF1mfs4iXIxkGvaMx1IaYsvyv0OrLHduc+0gO90Ay9sA6wK
	 B0dHNpDIIbIYAQLzKl3hDu8n+Zw1IpVTdNZ7WMMGKSuhEyRakAucAfX11JMJjK9E1Y
	 VoRPiUtDO5jxdGK0FTMwvYuswTA4trFwltBbx4zTSb08shtKXCvdlslki/beRemppR
	 4h2irLt+OI6Lw==
Message-ID: <3706e714-f60e-4178-afe1-c1973e43bdb3@kernel.org>
Date: Mon, 11 May 2026 20:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/22] mm/page_alloc: remove ifdefs from pindex helpers
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-15-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-15-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14BC6180012
X-Stat-Signature: hf7utqy5c8pexnigeojf9us8eitfm93u
X-HE-Tag: 1778524263-330268
X-HE-Meta: U2FsdGVkX1/G+cdx/F/5YdBRqxipBQTljWC1J5ZTdxK92RynnotWPqBReCXZcTFFuOZTV+AvHzx6SFO3j8pxFTYqMwqyjAOSOZU2F/mNhageqHHGnGX53HT8dn9TwNd6aklpk90iUSKzsGpIxTzNFO4UmrKitgZOAoiGAd69iU/G1l+s2wcUpv41dMksh0EuyY6UixeASxGYr4+ieF2D4yEM36kGPLg4Vx67e3j+oqEj9xlRN/GctKVMrYr1cod/vtZvunQF/jlciPMqk4WM+8exZFDqidaVbbnQw/I++sYdnF4lTdRgMsvK03YTxb9Uxnjo3hGygw9x+uDcASh4GexLTEFYUblJf00AbZjk9y0yL+3JYLKzNRhwRS9BL7wcDdOHnPun7o246jozpQRzEc00HDL8B1OdnRmmYmX5pf4KxzBbOQHmHdXDofZWXnZWKRKgHdM7Dn6PZtANiJV7ZDxc8DYOM0jqJd/RHS3LQRYmD+18PEoh0bCjvjFV312sStKpPBd0abdET73XmZ6EtOfeJsQtWfG3/wTZrHx+E3DRD4wuBGydfBRTWE1Vj+Jam81iXbqDmTyL3I7VuNjjZ/GsLGe2V09UKwnQNyzzVwmZFVaHgMIps5QTN1zNA8LYs1XI9VKEhuPNCXlTh7upiuxhOyIfEPnfOiE6/lw9+foEV4uJDtr6I6jKM1bDTpfC+R6w8xJWCsHW96JqLDIYt9OrR3Dc0LHxoM3xX+phaAZQXnnqkYaAIxHMQApeG2wPefQ+moi3k70uoN6hVp3odKriiSAiW3jiWZebWFU32Wj2k7qPPnEYxcTf1o9QgTGgA2M7I6DnFJONV9vIkIN5DhgcQU3/v3ZnDkG8Fsk+B8h4sVCKZeyxo8+7oBL4pIdbaTjg1ORwlKPI8suh1lq9WGGskgVIxWICSyg4AcT64F0LnuUJ5ii5pKA7B6qL76mgx9D9IdFZx4uhTj45dHF
 US1il61p
 x0HPIt9DrSeRwEWpSCrFOT/ym7BQQVmEe09Ta1/OwsZ0vnArjuce63KCKuPJ2Gx8pBpb81WPb2GMTViG3NwR42naJ8R7F6qRusE7V994UzEXSiRdH0vuv26vd9z4t95v1OMm7LDuvJrwn5GJxViUT8E58uZv4rP+ll3HFQTQ2BfYU2nUo7JVupThxl2MTJbFa8uzTq5AwNRbKK06PsBjlwJsdhTrsRlgo7pFw6vbh1a9qewl48hh/yS8nY95WTFBvCrpvirz/0vomFKYAtxCscXqx50dN/FcvU00IBmEG5iqBuysX4n/V7BBP5fgjetCoKlCJqPWXo7BMlw4tD2UIM4bupUe+fDWLBKQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> The ifdefs are not technically needed here, everything used here is
> always defined.
> 
> They aren't doing much harm right now but a following patch will
> complicate these functions. Switching to IS_ENABLED() makes the code a
> bit less tiresome to read.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Also good for prep series?


