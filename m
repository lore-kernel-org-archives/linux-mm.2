Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE63606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qu0TDpHX
Received: by kanga.kvack.org (Postfix)
	id 43A6E6B05B4; Wed, 28 Oct 2026 05:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB5F6B05B5; Wed, 28 Oct 2026 05:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBA36B05B6; Wed, 28 Oct 2026 05:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC5E6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:02:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A24BC140C0F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:02:24 +0000 (UTC)
X-FDA: 85371443808.08.1625698
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D645840007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:02:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qu0TDpHX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOwWNn0gibZHQc2EDK+4gHhTei1ryqyCLAasJqC6i4o=;
	b=FCmoXqqzN+JaU6CFaX9ExWA8kj20ArZZeNuQ/TguTsWs9iDssK5z+9OZbbX4voZNwapfjn
	vRG8CIR8Vjg1tIefKF+ILBK+UGdixVX60NSge/HQaKS/hCoAb9rfjuXaX/eiMXqDJxfo4e
	fATGPkfk1ZM7QJ0O/pl/6JaZp68D9Xc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qu0TDpHX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178143;
	b=6fuIJaqrhNmoCuUzSPRgFak/vIWWgfGLJauIWt/Z2S03QJhHPPN7Z9Zw7TfKFDJpe8cm0D
	TVo6MJs+vrXeTJ7JXNLSUWWt3tr9LIDSCyImrktZnce2l9lwppg83RfxZW+/MH+yadYx9N
	EtgWgY5slT44EW492+42BhDPMoMS/vc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A1F2414D6;
	Wed, 28 Oct 2026 09:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67401F01825;
	Wed, 28 Oct 2026 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178141;
	bh=ZOwWNn0gibZHQc2EDK+4gHhTei1ryqyCLAasJqC6i4o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qu0TDpHXppHbMLw4Ywd+W68Z2SfmHz0TSYxcDxEchzKQqHss7RIfbsrtyFD87s5Q9
	 0iI6Qr624LOBrqBHxGMtERKfUAa/HKE8mWaVw0hbBJ2e21B7j4NNdJODu0gyHVb2SL
	 BEJevBBCi+NSSGcu3ly1Rw/sHhdahONR+m6Z7LAoIrbmQ+RrAHNnd5WXFDspJ70IcO
	 5nUR8VBsy33Z4cAf64TYz0NJjlJ4ZfHTFQ/xSZ96OAmmEzfxC5YBtCsPsTXZN7983+
	 9EEmtAb2aVXpHG3i63jwsyDqoj4i3Yv/mGK5yuHjKno3Ca/l+P6yavYF2v8982ERIW
	 /sl9Z0WE6OBsw==
Message-ID: <c8468755-4f75-4502-8d41-5cb9245a356a@kernel.org>
Date: Wed, 28 Oct 2026 10:02:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: don't migrate folios containing hwpoisoned
 pages
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>, vbabka@kernel.org,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com,
 wangkefeng.wang@huawei.com, tujinjiang@huawei.com,
 mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
 <18602383-2326-4e54-8dec-bb695ae8878e@kernel.org>
 <20261027120854.1213156-1-xiangzao@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261027120854.1213156-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D645840007
X-Stat-Signature: 68jjbewaifaf7osfma17rbd8gxncgysa
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793178142-56413
X-HE-Meta: U2FsdGVkX1/yo2GDP8j/w/FovkNgJV9EKrJDhPDpV4WfeKt6lzo8+Yr+VAuvbUdtG/04HiE9bc9xUbyKaut0L5thbD+b8Ozl9/3i6d7Mc1jHDAMMCV0L1Dt7icBSktehapblxY2Ov+XP0BNZLSNpmfIcV60BDh9Q41BiV4YxPp9aWsku7v1/oTokjfeun31U+Z+8vwKR/PkCNnWr2NDdINrYn8SF8/DHqCEfzeifc32GnGuvfs1diHMWctDOxDdIRw/9BQzlGddbDEkbmBv2MlxJ2p5LnIsj1VmQ5uvrTii2wQn/6BA+mF4jLckk8UWlmpPji1ohVyVZjtFadcNVkPwp4Xx2CaB3JYs+dAQpQhXOks+4EV3CJorED62E/X5MgC4/+MtGmRpdSj2+gHGnsK0cn6KoNTyxxsUcvQPcUJnEaUnWPfQ0AYbKdHvAgzUv2IafaNb6Lq7vxnukKkOpPcpb5iy4spq0NEmMGFi+2BPO5RGTFlm9iICVVf4zs22Y1zN6aYarx0i4dLWgONueyLnMo06jfGtpsBMUfoN2nh7WxLPVdGYgqG6IC4zmI35WBqG7VyVfHPXMKjbaHpnrLnLZgVntdJ4g5hAxQJlJDpWtm4kQQ/zQNsAwXOSnJ6TSnH1XXX6CWqlfhDb52usEasl4bQZJ/vXg/HbTrIa8WGxgAsoyHiOGRwcvCRUeYkt6TWk92uEIC4o4TA6W/nHQ83z42RPU3N+Ir5urn4Os5OIjbIx7fYeu6zbebUxaTZEzvH3DAUiL8Lw6kAXZAM6ieiGUNLrYkkM0FI1TbnyV0QaS1VqUv8UkKhwch8rBm1M3sT0BUdB2oz/6s6qJIjsD4wL2NLAAwhP7J04FOOhyCpuSrIn/LDxxV9zEr85zmFe7+xTeR0JqXZiZdolo0Yr3eh5NCnGvRqqA6fDr1yPJ4vlgiWMksJx7mnvazCfy+jJN/msfMQ5CZgUaWmrKHKh
 BsgClG+6
 hXvdhL00DVZiGUeMIYmpWss2rM9Fi8SYoCSJe76SlbBoshV9nBx7x/KLdIn/R3ps6/pUthq3+uVHm9q4sdB/oSYtVNZgz+WmDr2phQw8Eo1rLv8iZV3NOdunogjc/U7spKpUsrHnPkUgVZidqpsGC7eBvAu+LSgMxsHEca191EXgji7+2wMjSOPDoajCQ5d0NK+g2dijXGquzm2OHxioeO5tJos14VZ1OHxrGw+AqdHyjdC2ZjwPiy9dd4UuyoYno1birdd50CxHYqKdTVDxoYs/1Haj/wKIPS8XKHa1o291mfOxR1tPT04zT8M6aGtCU2mWeMA60xLOrGho1Et4HOW2CnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 13:08, Yuanhe Shu wrote:
> The fallback check does not compile on x86_64.  There,
> folio_mc_copy() only catches a synchronous #MC at the copy, and
> software-injected poison never triggers one.  

Why is that a problem?

Why do you care?

-- 
Cheers,

David

