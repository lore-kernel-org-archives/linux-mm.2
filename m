Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590B4CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91D66B0005; Thu, 11 Jun 2026 07:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42446B0088; Thu, 11 Jun 2026 07:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58746B008C; Thu, 11 Jun 2026 07:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94E216B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:28:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 283D214058A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:28:51 +0000 (UTC)
X-FDA: 84867409662.15.8011B5F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 38E3016000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:28:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bHjGb2ot;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdgeOS/fL910VwtXTjRXHW56j7n7QZNbTb7jGlebeO8=;
	b=fNMQKXRv5Xqk32MBUz2sNlWcKqQQ5AcH1VPKUYM9f/h19eSE6nwZG2XyZEBfONcWIb7HhT
	ZEtI9+hwzs2n/hRn6Cb4XzbaCiDjTN3s2syx5UHdynvFYgZbYCVALsMDphSlWry3Ou0x/I
	9ficMns/8DNrqUY5lXbeYKCg0HLQj5g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bHjGb2ot;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177329;
	b=o2jOp1Tn48KX5EciNiIEeuHST7fw2Ofw+Jx6Dg7QuFZgwb74+rLQQfXwy5YmtoahGZGCcg
	VeAFdOcHoLWtQa0FzejbPN0M6+Gx5XPH7CpAhu52wyDoDcV8VWbgvZfublO6BmdP6vnRMO
	/L5tQEBmB5ZGUmU0quy3Yg1FyjO+ILE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 967E41E2F;
	Thu, 11 Jun 2026 04:28:43 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C7B13F99C;
	Thu, 11 Jun 2026 04:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781177328; bh=fDfCQJhcd09WYJANwFXRSGh4CZ6yAMijmlQan7cE+uA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bHjGb2otGj8sHCXHA+REFVDEOzYnKhmAI5WIOTMF8IpIMBEg+oEHergt2V6NO2f45
	 d58PoItW0n3OB+mLvrQWvM7+7ob2xpfkyLXlPL3yO8bfEzjfBUrPQlFyjZuo6PJaCV
	 Ymyyg4JfhH+bvIM6ayEiyn0uR2gVd4bTJzy27ayQ=
Message-ID: <9f6ece0a-659d-4bbc-a61d-f70826026cf1@arm.com>
Date: Thu, 11 Jun 2026 16:58:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <bd9d1353-3053-4665-8f35-ae3f6e379237@arm.com>
 <bc29b740-8f1c-4e2b-9b01-c8c4a4183b3a@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bc29b740-8f1c-4e2b-9b01-c8c4a4183b3a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38E3016000B
X-Stat-Signature: ncpd4i8efbayfan5e8eobcbwmzhagq79
X-Rspam-User: 
X-HE-Tag: 1781177329-910939
X-HE-Meta: U2FsdGVkX1/ZRhrcJnzLBi5yfr0ldGPSsLL4e9U9lwrXSfsc+vk5HeCjboO+AO6ERNDpuvggscRgpf/RNYp4YchfLd73c3HGZaGPiamxM3hJzddtsc2ngWIrRUdskYBMpMi98Sr40aR2I8dq2IOBKuYXT5SEvKGlgH/q6n4fmIxEhvq9r/wwRsb6XGIIg6qAP9HP/J4Q+EniXLwi7wswz6wRMgAOpCMO5dNdY9jXsLbWNvPuoH5Ga8/TRFs6PaNMS79LAGkabXDp+RDXaeRZefd8TYNkh46yy4mjWmlhkGSU0JPV6eVXnaKqiZGnh3cHpu5ADLWX29D6nBwC2T3L9ScrazTDBcN7XzeRaNd9DLlrhrQxP35f4b1Fkh/L8XOvOh353207Wj9A6t5RBT4quzlZpPgi0GW38d22mflsBwHXwH11yJYAFNsOTYjexcFlwwfYlJOgMhVZS3rSHX7ykqBX5Ko+0yLXP/5Glxnk6G7MSX3zhw+OqtxS1iTDbNRTK053PamU71tkgvGmnF701lwtsQxP21mrQs1/cRYbM4JPe0yM76O+zAs0dtuP0CeAxtL9Xd2awXcSgy6Tce3pQVVXUwufMO8evDIKD9W1AKPMPqIcGrd4xOH5rPP38Kcs4xy5k2oYdDienAjuCKZnam42zX5yVD1p+Ir6uKbtwhbluLaYsUA65kfbKJR0WhkUPiqyRgJOKq9IyDYVjfwpvI5g+pMJlPMwVJk4IKSVJBiUK8JpLSc0fvQKKtCUIANX9ZDRiUplZCimHjUcuBKv+Les2J9WxN/pP/LvaaR23cUQJoAS3JOQ+AIA7ToWtIW3TMnG+pBdrEOzrOmY7E+DtADu2YLuEPWfEvbIsw94+TCOtRrLzkyBYUgeA9JzF+FLiHMx+DyFRzms18BkujwaXteEVgck2r0aQznurBKKRqeCB4n9EkZzMgXKeK9+NpG2NOrNq3aAmGD7coJJ0Xt
 0L39CwlQ
 cgC/AA8DFOz/G/uN+BDa6RWKEP8eYuopYzeOOA2Xj15MO07wO0TLpmnO2a1T1hUOmPyegjt6V3keEVLu9Fnt6tRDuVy14kHvu0jD9D80aPs0VBLOfw1lasLWEevM8T12RMoTWr5kGjywv3K4WUiIZjIPqjMtmDw5zm924gJ5Rv1MilOGi/ksqMeaMJlp3vU6XY8YgOs4hf/wk4hh/DZngQ1q8zMCerUBPvW6c0pREZL7qwI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/06/26 4:56 pm, David Hildenbrand (Arm) wrote:
>>> +		/*
>>> +		 * Speculative reference can temporarily prevent some
>>> +		 * pages from getting dropped. So sleep and retry.
>>> +		 *
>>> +		 * If a page is not droppable for 10s, something
>>> +		 * is seriously messed up and we want to fail.
>>> +		 */
>>> +		if (dropped)
>>> +			break;
>>> +		sleep(1);
>>>  	}
>>> -	kill(child, SIGTERM);
>>>  
>>> -	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
>>> -	exit(KSFT_PASS);
>>> +	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");
>>
>> You meant "MAP_DROPPABLE" behaviour? Perhaps that can be folded in.
> 
> No, I did mean "madvise(MADV_PAGEOUT)" behaves as expected with droppable pages.
> 
> Reasoning being that we might want to add some other tests in the future that
> trigger reclaim differently.

Makes sense.


> 
> Thanks!
> 


