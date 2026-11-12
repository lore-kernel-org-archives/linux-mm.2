Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67B760A261B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lZO8K1dU
Received: by kanga.kvack.org (Postfix)
	id ED81E6B05BF; Thu, 12 Nov 2026 04:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61D66B05C1; Thu, 12 Nov 2026 04:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB38D6B05C2; Thu, 12 Nov 2026 04:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92B776B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:01:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08A15C049E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:28 +0000 (UTC)
X-FDA: 85425873456.09.01F8840
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 46A2040014
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZO8K1dU;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bu4BdULQIHQlhCcJutXTiMEZNYcwzWTKws8acbVlwyE=;
	b=33Rh3XTQKvFkCI+aFkR1RINTnKIUbMsnYlp+V3gEoB2LXwsrfSuknxGsiHI9uWgx9ApvRf
	eeyZmNDdeu5Yt1UPtGFDR5L/Vf/2IWMqfIlFzL1kTCn+eHwqDivDkghPyNNDP5cEXy6BQu
	2/0X9fWCWQnASnWCwoJnbzKq03UOCrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474085;
	b=qcX2viu0EHSOrY+fT/wPxtKhThNbm2NRG0kW22QgI7MOr1MTYgXp1baClJnCN6T3AmqmPq
	zFy17UhKh3Ats34kbvD/uWmTn7Z0UZpNdvnYVrhR5CC30nllm21bgt2w0CIndxq0Dp7ZaO
	xBJKVs2JQscYDvUjdev+xC7v3x2bFhc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZO8K1dU;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA7BD618FB;
	Thu, 12 Nov 2026 09:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AB51F00A05;
	Thu, 12 Nov 2026 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474084;
	bh=bu4BdULQIHQlhCcJutXTiMEZNYcwzWTKws8acbVlwyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lZO8K1dUoIbaKau1/mQ2XLHj8U7HPGcOc+Jg3qG1bBjqPSXKQuPt5bBUVqkR43GNR
	 XbNj3yVFbPmlnKpom5Fxsn1EfnG8ogso6U83ClsEGmX8xmbdlboqZTq/00tV1jBWkG
	 El1lZn5FUCjN0qLn4AcbgEIKiLv26Zf5ZqQxI2rt27EuwkZ+u4hVATLH3ReQVTG5JT
	 tPYyAH++YbVOWgUKiM3fXw5bBc+Oizv+ZbST6ZIfQO5hvA3Wfzvhz4yHOWRnF0KEG4
	 lY4wumFPxplRHKvViXKZUXNXdpHNqKNUhadQoF8XC8Eyeg9BPqfr1XbjFo3WTF4Fnx
	 4oQ9xVunb02EA==
Message-ID: <3973721c-9524-4a08-9929-e88617d21961@kernel.org>
Date: Thu, 12 Nov 2026 10:00:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] fs/proc/task_mmu: account device-private PMDs as
 present in smaps
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: stable@vger.kernel.org
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-4-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111113904.650722-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xbcez5nadcygk1fyd3xezy1rhxnqq4fm
X-Rspamd-Queue-Id: 46A2040014
X-Rspam-User: 
X-HE-Tag: 1794474085-430877
X-HE-Meta: U2FsdGVkX18sW+h8UzuCeCi+d0IAAq8NN2iVONT2+hftfu1JqX1iBU01pdt6NH5tadx5NLlb1GttK2FfCpyIRuRlUngbnxX8RnHVKG8zsFwnyyTJ1vRx8bV6Oa5KVCPkjpgWZBmhTBhNjAFM2PZwqGP1n+sQ/ph/gxVhKf5grc8DOmhuQpMmq32iSYCn13HxD8nmdkysSChZF0WYA2wVqYLrLqbo9BDD9rYz0UeRv6IQUDYLp9rowqTF7FMMEDotz5uwxXCq7L0MuqVp3OWw2yArx5HMaUPB/fO1Tc+ViMTWbzEVeuNDIeywV28MIfK3jy7bB65JL8V3psaOVb3O1ordfpEMnN9GwN/quOtoQI52x7aZsyEbBO1/u3nWKoMPMv71aoBx3N1IcPmi01R6kAODgt6htDy7nO9CRqgQEwRklDLmM5Ff/tRUgda4zQ64csWo1usMT+/pcNjB6lje+HNMLSwvXmmB66UkrRr1OsDbMuRMtsa941tdZbj2Fx9EZvaAFgdi2m7xtCSgsVpBEaguLKAGUM+UQhd6VasOG0/VTCanFTFvVhpPPjQUqfMX989mJsGfwc5VIkiAlOR/+8TgvNTq4ovIjEqWwZL4T9/RtlnI8gepsTy06iYp2B7lYDRH9F13wBrryx+GdebD4NBjrYCnQcBVGYzG75k6vaa8TP4peRHOpz28IrLFDvfASWXTP4AdgGUcd6hH0fW0N7X4w8eTIX1hK6u3UO9ZzN5rBkkEjBMN1Y2xu+kAVvdt+0DnUQRbCpL7s0fgiOG+Voi7TfHp9GDaG30RjvZk0O2J8lJ4wFALTQGFi6HYvGacYyByQtQAmhaAaefKzDqTH0T0Eu3M8zmTlLX9mJzIr4kOYYTAaHqLQ767lAAMT4omqDubooQHqp1GsIR/4S17V/zQ/R+YHXjGInSsOLNgE9C7UnSS4Zc0Nq0XMUOYdgFbXx3MFNpU9syB6XokDhF
 1qpUimoO
 4Y4thdWrHED4PE+N8vsY5gRhptbgu3QeuTJ+TQiS9oYOGcUmcHNCXcmoQgc+n7np+e9wLIvfu23qMStnk4IXcEY3sLrzb/VSW49QZUSFcdGp2XAFf/tGzxbKZcF5Jbv67jefhNaxCRfakPwve9pd+23wYsTFy6aLzV5jK5PzTDUsOUS3djCy97a5EA2asaJ62tBc1rm4MIZP4d/fVn7lWBzqY5ChdiJYbzqlRYTbrPWQFdT/N4uClLMQoB6H28+73jj7caVDNRq91+sUrxMj6GjDAgFDK3VEMDHrvVHrz2RoKOQaK1WQyJmw4gEHenXLkrip5Ep5v06yTmQhEnccDxmiQkXFeow27vxXrCBKhfYCJBhOInXzjXRAxG2IWEOY6/SqJdnY1MZNafTpticOksjXQag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 12:38, Usama Arif wrote:
> Device-private PMDs represent mapped pages, but smaps_pmd_entry()
> passes present=false to smaps_account(). That treats them like migration
> entries: mapcounts are ignored, PSS is charged in full, and exclusive
> mappings are accounted as shared.
> 
> Match smaps_pte_entry() and mark device-private PMDs as present so
> smaps_account() uses mapcounts for PSS and private/shared accounting.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  fs/proc/task_mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c0d391186c2b8..ad97532fc1184 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1032,8 +1032,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	} else if (unlikely(thp_migration_supported())) {
>  		const softleaf_t entry = softleaf_from_pmd(*pmd);
>  
> -		if (softleaf_has_pfn(entry))
> +		if (softleaf_has_pfn(entry)) {
> +			if (softleaf_is_device_private(entry))
> +				present = true;
>  			page = softleaf_to_page(entry);
> +		}
>  	}

I think I even spelled that out somewhere at some point while touching that code
... or did I fix the smaps_pte_entry() thing at some point?

"present" is a bit misleading in general, because it's not pte_present() ...

Matches smaps_pte_entry()

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

