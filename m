Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3F4C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A816B00AE; Mon,  3 Aug 2026 09:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4DB6B00B1; Mon,  3 Aug 2026 09:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA926B00B2; Mon,  3 Aug 2026 09:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 797D66B00AE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 301F5A0666
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:52:56 +0000 (UTC)
X-FDA: 85059494352.23.467EEA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 603564000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:52:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnDGQLIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AknyMFqIkIaCU6rSuEeZlYh75O08PGY4/BITC/7L1BI=;
	b=XAwALCX9NXWEBK49l5PswgVilGx9K51m3mg4jjRW9wFJNmQs0PkrSBK8ny+oMcnjr8EKvm
	v5oy5YbQYwdKPbka1B+jFBYlLQBQrhmNkqcQe+NsxPUuJhDvVcQIjIfit0PGGOwUGiaEFr
	mzuzn98V5ifHvn6iYsTp9slAd/IIEPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnDGQLIx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750774;
	b=X9BBxL8CvenwrvoEPIlC57KJ9QlGlxzhQ1oUUpkAVDfN+lRVxh05Xr04dHurjUm1+vybMj
	49lJayETA1y3jpEt8LR4So8dK4PBs73yBQK9QruKLHFr4pgIHdXOHOX2tpgNCkfpl7R73Q
	Z8OeYp2eHPYTCZPq19lSA0cBSPk/kcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7342D41AA3;
	Mon,  3 Aug 2026 09:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624851F000E9;
	Mon,  3 Aug 2026 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785750773;
	bh=AknyMFqIkIaCU6rSuEeZlYh75O08PGY4/BITC/7L1BI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lnDGQLIxWVkYsVzCVdlGVbWoQQMN8WzleG7V2hcirxFPvescDxiUKQ1V+K/UdoX2S
	 f5cxmLvSZpRIPDgpMimJRryp/HGveCXAaCapDH2by2h89kjWG80/dvEzSXowpJPN0O
	 YasMVeGxX0kliKmtnchXbGFnseSMRDaqYogjFmEAF+NBM3CNVx8hMVwPQiFbrz2Ija
	 EnnxmSsmRMAW8fqdSxSZevb+QF4JypAsuJRIyyAvTzJb1Eik4xoHSieHEwNu3IrL8b
	 jW3RPJlP3FeiO0ovfCed8tcm6G0p9lRLNsNLbogEvnTeN5g2g3wDmCwNNLGcIy2pBy
	 RpNfdyoRuPiLg==
Message-ID: <3f120b68-7c10-4a9d-850f-99f666f671bd@kernel.org>
Date: Mon, 3 Aug 2026 11:52:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/26] mm: plumb alloc flags into some alloc funcs
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-25-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260726-page_alloc-unmapped-v3-25-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 603564000E
X-Rspam-User: 
X-Stat-Signature: 6mww3kugindsonmo1cp4w8bee9pxk4o5
X-HE-Tag: 1785750774-795570
X-HE-Meta: U2FsdGVkX1/x1gf8XzdcMDWdHaAj/Txi7vh9VFJz8z+96Aaqbj5tSAo8+kdBPMWX/aE7XtEP/o7xvsneChbmLvdKIEnOfIAyujofNCUViDk8hHEPWE17tvlSoc1p27cT05/F8YcQs0VxDdEt1Gy1nLhdopBdzSpjmf9iSYlIz862BVDbXdbgfDIiRbt6WYaX6dO+2swpOj5HI7XPN7QzKNwW5ff3SJeflAOEjax+77M/arcRh3453ofi3MfDJ++jBNlHeRIjxRwCB5b/BUNcs72Ih/Ck/pFNkuZ08uv0mtU7FpQd48sHeAmvGcGGovYDyHAGxfGoF0BtPwxPbW4bGuPzTVdFHKAO1Yzz3Ucl75PJeCq8afeGbE0gAYP1cBUz77rTEO/U5tqxJCXkCxfwLvPIDSdMPAmgVN6ojzx3V0kXVobeomz/Mae0+zoq95eBxxWFxA/l3zwKglDg/u5TIsilxBDc+AXMJmN4S4T/e2VEOEzHM0aWXk1tnqKUf6DOYhkYaQsqfruc+RgXuB/9LP16T+o8KoioGQwbfRrbycZ/gh2bwhyU+H2mbnFJ7eyMVmzqfyI+f6Fah4CSq4u+mn3/ouUvBSSav1FA+Un5UUJsuPriXVip4z7BjNq1/r9/aze8QUrsbHF+q9V+ezB/Rcx9ZrPx1Zau1FVgymu6pboD+APIqo3l+ZCl1aGmankI92H05AvS5tG5pg77kod6ccsrLdoD007kaAzIPzyAELNYS5FKDU3od1cxD88JsF7eJ/XiJFglUlXRRlZgKx9sfcjhs7surUCfOS1tmj973Kbm0O1XXeUqtj+KHV3UOoAZOrXMQPBXzatWkkvQf9ekW7rb+Ot0ky54H3c7RoeWEzMgD9w67l1F3CQbT7GU6mLBdG1/ZrC4LiKVtIlzeRUb9PhKw5E2s3sAuTV0i7GcyMWPnWrz1YsJtf6jvc71W7EyxuLu7fJ7R51jMG89z+3
 Ir4xmFIE
 9zZ1q1KLe/zQn2Ny/t+ScZTJ1uOxIvQXChi1aWP7feZK2hnE5OadtoXxRphsV0RcbcXTMkNWM081T4odrP0+ZVkJBgfsTbsjg7SWoOwyAWNt4CNcf6XSQn3MnzYupYPyAhrTX6EKhXyUQfHVlCt7XmQDJa3RDZCAnEASMWk5PbKeb9wIzLWh2ExzUV1yWVlOYaiE6Bw59yFlSuiw1GKdwmgtTMf5SmP1x7WyNcfXczaVGYYbM8js5FwIMBa/LmVDVWS8T2TdvVR+Yydf+ZYvuWLYmIy8uOT0LdehudUKPIkNEoEUSQ26fmtqfPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> A subsequent patch will want to set ALLOC_UNMAPPED in the allocator APIs
> used by filemap.c. To keep that patch from getting overwhelming,
> split out the arg plumbing into a separate one.
> 
> No functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



