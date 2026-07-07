Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741FEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B516B00A0; Tue,  7 Jul 2026 03:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC046B00B5; Tue,  7 Jul 2026 03:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4A16B00B6; Tue,  7 Jul 2026 03:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 134576B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:01:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B815A0300
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:01:24 +0000 (UTC)
X-FDA: 84961084488.15.2843478
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D181F4000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:01:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoZG+FAi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783407682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nMQF9iK728jaHfWKAl1oxb3wEavhMGIGIQQBs08uWU=;
	b=Y97R1+2JtlE9e/xfwlDG93OMIqaE8+Mi/8JHfLXxOCvnNQ2aj4lLSCvfQXDGDEY/WY0XxC
	2m7FXlf8ZcpGsWR3fOkNwPHK7AEB23gwzDCIBlaveXEcVwG47CQjY7895T6iVxUBXmot4h
	I6ukz5l5evTKR+SpdFcMT2+5zBJwue8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoZG+FAi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783407682;
	b=DXE9W6LnqOrlxN1eWwxhfPHbIiRoIJea0dM3rzU7Jf+ZJKoj/c8hp73XzR0twyM6SdN51E
	vnBBlZIj+fmdvqJIAVQ0ptnCjqA675KjSGiD1ZbtzsFZBDnvLNFC/dZkf1Ur0eICcfMOvk
	AaG7fxpick5EbWv49ney+XNy4/nvOWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 365DC601DE;
	Tue,  7 Jul 2026 07:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD71F000E9;
	Tue,  7 Jul 2026 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407681;
	bh=8nMQF9iK728jaHfWKAl1oxb3wEavhMGIGIQQBs08uWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RoZG+FAiYOh7N/YyQC+cC7CslMmQU2SOM06P5nPWu1gu2qX2Ye3qHB0GWnn7sIBVt
	 7NLWJ2C9ORJQKRRKgoXoaB2KFiaBFu5gkdfNewh/Y+HO0NAQJOg4K3FpOWyMCkvSEf
	 oDz3UESvJxy4dJcABhpe8VUAjM7/MIVkVWBaLpMXUF+vKN60NZeiBfyfvrdhgzL9Qx
	 YVemSw8dsdOHBqyABeulcUCCtEVqqLEEZB9dGtAXq5zzcD8kL+DjkJJHr2DlS0N1bX
	 6Uylhickpd+JF3duYPoAueIzC0jgRPQw6vqjmYvKycbMktocEwWvSg7H5NwaEazYZI
	 KQ9WDnMScRCEw==
Message-ID: <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
Date: Tue, 7 Jul 2026 09:01:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
To: tao <tao.wangtao@honor.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 willy@infradead.org, sj@kernel.org, kees@kernel.org, luizcap@redhat.com,
 zhangjiao2@cmss.chinamobile.com, kas@kernel.org, ljs@kernel.org
Cc: hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jack@suse.cz, riel@surriel.com,
 harry@kernel.org, jannh@google.com, jgg@ziepe.ca, jhubbard@nvidia.com,
 peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, muchun.song@linux.dev, baoquan.he@linux.dev,
 nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 shakeel.butt@linux.dev, ryncsn@gmail.com, jparsana@google.com,
 dvander@google.com, zhangji1@honor.com, wangzicheng@honor.com
References: <20260707063308.29176-1-tao.wangtao@honor.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D181F4000B
X-Stat-Signature: tz77gu1r4ofpd7utnuh84mcq65ci4etd
X-HE-Tag: 1783407682-995459
X-HE-Meta: U2FsdGVkX1/bn+iKm4F3IM0H9681X554GLDEwyFGbH7/LPX75B16NHp79tdnOrkML/ts5QdA0ZSgy0FZjQrH6w2qn3pFoyeEgG8BHIiebDcsmvyZpzzYP09lf/5wbo+NZAIFyzmP/P3/Mxa2+aOMCfLszkuwG78tH6Z3rAav8HeaWFZV1d4fPyBfa6IOZE3xrjAjZjRihhluYjSLGtLLHHGWrUuF2hIIWiQ/P9yGWF/K4aDWHdTKwEN7hwY64As+cAKR1x8tapaldIpaUmmLQoXJgIIOBBIItjYSenaRC3H5OFwu0xxX0gVSO0lH2mYvCl1iUABOCj30HY75qv5g3T6EekdaYTlGMP+Eu6r6snRsRZuJxvfUxP2c5CoNlAve3PadNHuWstQMqRJwZRWEOmGk8QMITF5Dt+DlPCi1mgoTqVsjkhW9V2KHJDc6rGT15EMwzMRD47sFbjNajc4JkxHK37r9ao29SKzKlkN6rK7Jc9bzZgUSBKfw5duAmWSOvWrkUHUIvton3i3osdPR6DtMN+Oo9Hy6YJ+7F1PGWxwIbhSze+jmMOT09Nc850BEoXrtPFw3VP4xBbuWEOmXd7cCMOIWl5WLdfAKDR7ihNZ0hxRtcrhDlqCqxXDCx5H6qqgYVR33MEAFOG2hE4M9+VnG30lO2uQrOC0N3q9U6bW4DFBJkhwWsDZeAr+6VD/i6T/5eILSGLptAgC4mM3x/3msx8i0VrA8yETYBZxL1JwhGn01p/G2v+axJ4QDtXoBEwcV1rm6opcOGPMHE7itzAQqfH1zV3YkqdSWuh6DL4gZ1CGY9fg2XVucXQC9e+d2iRx3IMlgZgCHGyNaKfrfxszDjFI+oDDPiGv41FR/4Moh62Mzwkqe4OfTe3SY3DB/XToTCxwKZobztztT/4f+EZfa4FCepGfjW94hT+vv2m916kxB1T4VMzo8EEk2tmdZrSdeXTzbPnOXs3P9i0E
 N4YGn4N2
 AX7CLta5TejvNlBX4klQUi7Ew0U55K9EVBF5ji8ZnkSecLwSybholusHHb0vt72Zci4chWLmxpa2bn0N07Bo1ee+OdfsiRr1bEsa+Tt6ayocFaag/oLzfyoSCsdG3C73msA+PNYoJlqsEKL80wp8BqOjAuNtpcB7l4pscsaOD24C6EDI+Q3SxwE5i2W1fptaNmwyCduQZPnW6CY8qxrlrq8onVopOdR38tmrlzaGiHyxmfe4+7WIamBFRqC5j1RFGDHVCKChX9ylUWaw16aOjb69TpfcUL31NWYjxo9Kx3VyYhmvKo4PhbUf+p7s014PYmLbYLtCVBLoOSFL6Ky4Uir9eUx2CTWlQ6BwWeL9ixAGTy1Vxm79/sH24mWvZ3JWHH9khiTzQQn7NfX4uv9YEawiU9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 08:32, tao wrote:
> Hi all,
> 
> Since v1 was relatively complex and difficult to extend, this version
> adopts a simpler anon_vma implementation approach.

I really hate to repeat myself, but you seemed to have missed my main point [1]

"Lorenzo has been hard at work exploring various design options (and I'm afraid
he might be one of the 3 people on this planet that understand anon_vma in full
detail), so I suggest we wait for a redesign proposal from him and see if that
is doable?"

[1] https://lore.kernel.org/all/70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org/

-- 
Cheers,

David

