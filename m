Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B12FED2F6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D066B0088; Thu, 12 Mar 2026 05:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FE66B0089; Thu, 12 Mar 2026 05:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABE16B008A; Thu, 12 Mar 2026 05:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 580466B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:11:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBBF9C311C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:11:00 +0000 (UTC)
X-FDA: 84536841480.19.0F4D7E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 488344000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:10:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uReTo9Y+;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773306659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89ek+uLq2IOhei3TuzAj1c90f2NxyfqwQ6lxUqB1C/g=;
	b=Wg0V8kcBurikHEGXUjVnOdASjZJEOzR2hoJ54AkWl1AxLJUyIujsJ4Y7LdTraSh1XL9mfx
	HJ/rfMN5PU2baCIJf8DgqUC1SzKmRfS/vjRCLctxqss4ony+I03+ufrWdoNEt+xIsUBCkk
	CTmI6DipWF2Qy2tXKPxEk7FYmfEGkps=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uReTo9Y+;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773306659; a=rsa-sha256;
	cv=none;
	b=z65mQD1146O0yrHOgf0/djZbnHl99xLdgZchXzhpbvxHL+LPeCCVNwiPykpMc4aL1VXyAY
	wNZSlvDB4491cmJahALzO42UOncPpqiDboEByzW+/CRQsjll22KJhXlCNnSgjnNDIFSe3U
	6BjOBD1xLw5vXBacMTdeOkLgDf6QpQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC30860054;
	Thu, 12 Mar 2026 09:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9529BC4CEF7;
	Thu, 12 Mar 2026 09:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773306658;
	bh=2IGrdEFg5B+lcOPX4/6iBaciXlB+vTGeAMbcDN/IjVk=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=uReTo9Y+ostRIw5T2Pea4W64l8Bg8YSr5o0a7CJAJNzk14r6XuMZp3voETmvfLMz1
	 vGk7Johd1h3He+Oc03bLs9c11w5JYrVQ2rZSS73qiU7AfXoUjeH79sjNKE8Zx/Q0f0
	 xX8s1Lw77jGJ3XhicV7Y+RWDJHXq21fORao1cp8cB9NVsSA7Loa9ttd/CNdMER3P6U
	 ywqBAdjZLff6N58Bb/C5umfl+TIBRmWGYmbKpQkDo55vFouEpI1CqgI0Avml6ov8z+
	 sY/m8wNiPhqYs2W+Yus2Ima9ChSkc6zH1UgML00voWc/dhIqeyxVLrX959uN3eLWHz
	 3JW+sAhq5C5cg==
Message-ID: <bda340f2-1d49-4ff3-bfae-e3065607e918@kernel.org>
Date: Thu, 12 Mar 2026 10:10:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH] slab: remove alloc_full_sheaf()
To: Qing Wang <wangqing7171@gmail.com>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rientjes@google.com, roman.gushchin@linux.dev
References: <20260311-b4-slab-remove-alloc_full_sheaf-v1-1-c4c5bb587ae5@kernel.org>
 <20260312033105.593829-1-wangqing7171@gmail.com>
Content-Language: en-US
In-Reply-To: <20260312033105.593829-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 488344000C
X-Stat-Signature: i5yosay63414kki4hmj5pc6jywsuzo4d
X-Rspam-User: 
X-HE-Tag: 1773306659-434120
X-HE-Meta: U2FsdGVkX18mLf4+QwQZrLpdSzZexlJ21mSGsFvOWp3qC+a/vduL2HejhZ+0aFW/FOF9NdECm2/kpHR1/e9xWI3fIBYlUKScalCldFbbKmT7YoBxBlT/wirfvKb45AuNs2pRpAHgKxN6joO0UGgVd18DfxfsfXMoo9bSju3wjiSg92DMPJokic0ZmweF2lvvmScgq3HCy/5FcfQ7Wzw+zaGzYHUSDIL0AhUP6EcY50fJAioOPH6i+/jtDN/HGU5AL42+/KiuWJnVtQ/JlJ/47yrHsQoSDx60FZPbUlSW7MZ6sw0aXpYTBkuAQq38DOuxnKOSbSEH/rVUR1mqr7uVVQ4xuZzLLDYY4eWe1vh8AY9h5sGIK1RMeas9mB1l4YToV2mYWKF/qhosVoWeqJEdB46DH5WFGBEgPgnlFgip9EbElOkhnTXQ8e8BvIFs6K52Vx5GSmCpuW/9WanvGB061PioAgALJFyOH1+7kCKt6LppwvDXsuu65oJd4/hyY+WPZSIjogiSKNvoYlZ6crdkz/6xurIDTqN2KOUgChICbS89QCa+tEQzQ30cQe75+c3oZUidOcc7ypla5b7e4t1e7eMBuJKGRLmF6f8K3d36XiFOB9KYQOisG0KittGaCTqtgRIrRz2dNVw1UCrUXbbSdSZNxEfoXv9Hoom3v5K1xiAus0F85gpfuprWYVWvaYcRQpwhH+ImaJORHzaYXkzvXc4nJve7HwO24T/r5L4WkR96akbLUXYCIFWcy3tkZLKysALR/ZOXY3dBrIrcTiBYdxzuvpwK8VdqnbtuYUyl3z0g3Ge8JzLB4g7RNzLmLz0HtyTEqVk3TkiTK7DQqLPE5ig2Dn7djoZQ3IwwYqzud3rhTzEBzemk95Op+I1mrXGKFRq4g4kMsZW3sLHX0M8VP8U/PnYIEoBySvQdJdBEKZQqXj5/g92LemJ7+JUnoqcuoggdbbrvW4oOSkhiVhc
 oc/b0DbY
 xcXpgOjvN3ZPeOZv0LIewNbW2jx1DBMf16fJ/aMBmMdLYpEmtqzJTMNq9qzUC6xTFePbMs+RavEYDb7HRdypQTUDGUE9dm24BIBpWXD2JLr9bsquJ8zdKkkzl+Ih46laIdoAgnO0NhuLxigJ+dm1IbLsuk1NZIAxDPwBI97POQKGbX1AIUErX2cKyZBbfQ+e5ltVOjOgDd+7lGEoft8oOOQ4Nqvr6isRxVjR2PYzsdedeeXXtjh+ARJOpLS3zZUhMgKmhFJd1KUg9dEW0XKakzaI6c7iiwHrhbnCbE2CYgJR+1P+EeVbls45QJCbebdHyRp5EUxePXMLXu9lYdjyb3ZwLyPWdUQiBzKf1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 04:31, Qing Wang wrote:
> On Thu, 12 Mar 2026 at 02:22, "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>> -	if (!full)
>> +	if (refill_sheaf(s, empty, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
>> +		/*
>> +		 * we must be very low on memory so don't bother
>> +		 * with the barn
>> +		 */
>> +		sheaf_flush_unused(s, empty);
>> +		free_empty_sheaf(s, empty);
>> +
>>  		return NULL;
>> +	}
>> +
>> +	full = empty;
>> +	empty = NULL;
> 
> 'empty = NULL' is meaningless since 'empty' is not used after here.

Exactly, it's only for humans reading the code to make it explicit. And if
someone tries to make a change that will start using empty, it will oops
immediately instead of something more subtle.

>>  
>>  	if (!local_trylock(&s->cpu_sheaves->lock))
>>  		goto barn_put;
>>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>>  
>>  	/*
>> -	 * If we are returning empty sheaf, we either got it from the
>> -	 * barn or had to allocate one. If we are returning a full
>> -	 * sheaf, it's due to racing or being migrated to a different
>> -	 * cpu. Breaching the barn's sheaf limits should be thus rare
>> -	 * enough so just ignore them to simplify the recovery.
>> +	 * If we put any empty or full sheaf to the barn below, it's due to
>> +	 * racing or being migrated to a different cpu. Breaching the barn's
>> +	 * sheaf limits should be thus rare enough so just ignore them to
>> +	 * simplify the recovery.
>>  	 */
>>  
>>  	if (pcs->main->size == 0) {
> 
> LGTM.
> 
> Reviewed-by: Qing Wang <wangqing7171@gmail.com>

Thanks!

> --
> Cheers,
> Qing


