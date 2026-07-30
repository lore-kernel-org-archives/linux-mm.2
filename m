Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B4DC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C9F6B007B; Thu, 30 Jul 2026 18:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E826B008A; Thu, 30 Jul 2026 18:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6C06B008C; Thu, 30 Jul 2026 18:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3B096B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:20:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 479FA160137
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:20:34 +0000 (UTC)
X-FDA: 85046863188.07.E039326
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48CA5140002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:20:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0ZKELil;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785450032;
	b=kRXg/S3Q0N8H0l33Ain+5QFNW+brcvUOr162DHve4PJXe6Mg2t3WKgMbOtkU1s7V0OFGtG
	fqq09OCPk4pSMnnHitf2NxWjgMqeDgnhh63SycNeC9WniJ9SNSwclEyN8vK8ihGhK12MaG
	494+RSRt0laG/oh72RUt4BB5XOe6fHk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h0ZKELil;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785450032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lof6e1ot4kuBZAi+0NXUHy3Yo358hLoUkT/iaCauSXA=;
	b=Sx35vZUUmFi1a+9CwjvOfGXbYXJWgPNrRhzpQm245l/zX4j/h1U4esxEhmhRl9KeHHLkpp
	OZDhL3hG5ky2nZJBPtMKxoLZnmmMIMrgh0m8Vezmn6fAr9GdTT4rnqC23O7tZkVWSa2MqZ
	cJTezzdyn57+WHYudCYXD13N3OeBofk=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso479475a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:20:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785450031; cv=none;
        d=google.com; s=arc-20260327;
        b=ZtdrrIVrW1XdmvvfL97SOmyQC7P7QPfCGVaxt2s51XRH70SvoEImBC7159VpmBbGf0
         bX8PWKroX2hCpAlDBgHqhrsNEJaQS1NrWl712q4O9P5VzsVQQAcNTflZ5O0hGfs5K73Y
         RtafTQe81M+8Gzvwzy25nqeCf3kXJuAxPCjIVj9IePTPqE1LPrWqhO6WTDUPmb7wr9se
         d6A/azwz5YtDl8RQL8HbHX5zR+62IjuZC7oLHwew/6wFAq7brsskkm+n/JFAk2EJIX7E
         RlPZyVIDVFr96vviXQDN7qpE82nbDveJ3rN98kuSeDry94S8ArJFqb5llg8z2xKJQPHg
         hqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=lof6e1ot4kuBZAi+0NXUHy3Yo358hLoUkT/iaCauSXA=;
        fh=/eXMiYVcehLKaO3RGcOy8oQAxXlI8b5aWC5ojnq8nBs=;
        b=ZyFXHrXzUjRR2cZSejlJ6qIme2zASTW5k5JmVjLeK/84qSgZYTUm8Tz63ammkvoOup
         r0dQa+vfZ7Sg7XCKVSwWPx+BE1BNJ64EQt5wZLDbQNPGcWwvkyNJ7wispAgyStz51BFM
         f28/i8AaSabl0iAUDaoy85GEiFRqWewXYEix5asUsFml7W+1l6KbL6ryV1adSh1Jc+Pv
         EikANfk4NXb8s8lg+GRcs+PqoKGT+M0ixZXLvVA9YXre4L+vf7H+f7YRMUI7JRO7ksex
         ce8ISDBYPuzA71IQIYUhnulDN6sSGtTFiXbtaOKjd6YPvEcaRMwpSdQ/JrwttvrJU4eu
         mbfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785450031; x=1786054831; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lof6e1ot4kuBZAi+0NXUHy3Yo358hLoUkT/iaCauSXA=;
        b=h0ZKELilEPOPWQ0NddArE2RCg1XiNjCL9ccHZ8mOZaWF/gAXzI5gY4eO1OKTpQBLUd
         bdBDxIwwiQJOtxtzRDC4IHvsQ224YohDXBSrlCT54U2rx3mfRRi9GbQ/QIMEqMTqjXFq
         1BlTqkPx76oITPkyYo/mFNPZ2vEPxyZGQXHTYAn3XNVBfMpBgMMV+C8c5xF3PSvKvsB9
         JM/PP5QlPIfqnwvMreWTc34T1MIaBMqHOZTzgktgXtdYu+RrycNmV308xf50UXYCChvt
         5lgquIUIsEtcdQSgbpR2/DlAIEeWnoDRQ/X7jtXRp54xH7XXrXiYaK3NzbH3jn/97wbQ
         t4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785450031; x=1786054831;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lof6e1ot4kuBZAi+0NXUHy3Yo358hLoUkT/iaCauSXA=;
        b=DXT0LSx1+Eri/Go+9mVxmcNEutfvlaIzDjLO5erd5cGPjSPEQgSfBf/RJXnxuUuRk0
         4wHExvbjgnAlZWV/aCCl3geqqlnE//0FNGDtNeIYzWJeQmIBmsjN+aZEZlvN9UnD3Pfp
         U+kkO5bSlSpd9y2aSldcRFid3kPOuXZ0+rOUI9u8ukKEIrOdIqG9XihrXmh7zBxWIabZ
         MfyrlqFBFMas024KLKbICTJB+qR2FSE5KCfLPSHz2EZXjz1EW+CP/I7OWo4ZzbSeET7v
         FwYlGD1lIdcWRuGqXEp0h+Kj8SRdmMKgDAiaUfpdjLpsFJvHu+VqkT2kGamIJOz9ENkn
         HTRw==
X-Forwarded-Encrypted: i=1; AHgh+RoiA4/Hm8nCpv5cL/4IhBpqi3URAW2PsXBG7kyfAbxpMUPOd3ZJaGXJWw9jr/sosOkQIgxXLtMUaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7rHok0/kSCf+JuWEJkhEVmswp4Nkk6nnBgImzdQmjib4ivBuC
	NsunZqkcMN9nqmtgNrUmAFkk18mEYwNUQHyQlH6HcPc1Ji0aEvXacOT/g2yyQa1YGNn0cMm+h/d
	JdgQ3knbUniCNF0WViBxKhrMUE9AztVSXBpmeR8TS
X-Gm-Gg: AR+sD13XnuKZn8fvXzM4Ofm0X/JLlrLwkj35HkNHFJb0P+4C8pcyl93QOdrw6OJ6Doj
	Yc9X+3Wb9S1zFMzTXg0nYDFZhzHBmHYXahrKrcQkWjscpIeZVKyyZrU8u08tMtn/GEFseT0F5CJ
	fAwNLr4YhvqsXMfdtOUwE02quYmYbZCGAvaVLxvbpVavQQNv4xaHJolF2YkY292s1LJLLJRmZSy
	zYjaTUBUGXncc3f7XXHCQrTVWu4BfWB9kmoYSRhfNu6UUnUMqRAe7CFt7hjWthGMcZ6bKyHhEUj
	WASBi2yG2ztHISMns8SoyuMguaQm3VYGlmNFJuBBkDxpfwPjlvUZEofuDg0baWwLxNLGzljxSLP
	dRahLKwb4hPFCcE5TNrlzC+2dW87AqsIvdkU=
X-Received: by 2002:a17:90b:442f:b0:38e:70d5:b12d with SMTP id
 98e67ed59e1d1-38f9bd74015mr2426440a91.6.1785450030314; Thu, 30 Jul 2026
 15:20:30 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:20:29 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:20:29 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com> <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:20:29 -0700
X-Gm-Features: AUfX_mzZQIbuyAIVKKa3Fs3idyVFYyPQCyW2ArgeeJkIMtuFBmetts4tKaZtmNo
Message-ID: <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48CA5140002
X-Stat-Signature: e7i5pah39j3sam87gpzhua61jcx7sdzc
X-Rspam-User: 
X-HE-Tag: 1785450032-428417
X-HE-Meta: U2FsdGVkX19+v+WEMlVifQSXQRQOQVuHPyo1imtalFsVFvHqWFdxFWeRXBLTvGpZa5NgEPTMOKYY1pdbHCGSmKDzquLIBJaWo7kdfCysw15G7GrY1Ib0RHRuA5++3/aEfHQOTSOw44BzyfzkKLCep24Mu0vCSQ5gIYAnndvHM+nT4CTVMTO07RzUqFmtp2o7LCIeqvKhq30wwteeD4/8bcxobxlJMP1XRPYKqaZ50EQO2x4xqju/MkJc1HN/t45Gb5GpXh3BY5OBtpuTGeNBQpsp/IqSOu9ruEWuzfgBaZC1GtcM9xDrJgQI8SKEncskckV2UD4Jkd73/Qv9khB5V9hgbt9XXNdcIrWoHhUITLO81EEAfi6aTzDQVCk7lXE4yjaKcebl6hRoBze1TApR8phsQ09ZtB5HW+kI9+yqvPuu7PBvv1eZRB0MW/WzsvBQq0mRZqzFVh6zfzqcXnKF5l6JMjOl4DYC7iRHWEEJxNEi7x/KzsoCecWKlGNI0Izls0aecnlQrabsmnYE1f5O1kzfzmiArwaXonaARM9B0VlkW/6iTrw51iwW0ugTkmpq+i3XaG6xFprqGuobm3rGcX027crYNqm1vfq2hnmVoEpxpr2INtj5f8FlVTlgWFvi85Nu3yOynh1smU7j/FJQbOB/Ehmac5vUCdZFnmYuQjMWCKjYXbahgUUiQReyjSuUBUpm25mWPhhcJ7UQp3dsi0RcUSMfLXNTTSSlCGxNWh0pyVv9OUplgHncmsOPaK6vHW2ljECMUE0GgWXUb/JKdzz/2jqsC2oVUuQ/XbfWGqtaHu3/J74OUX/gIk5mrN2RHEuTpOX4thOwcyarothE2yPIq/Hn8lXDF/HfUafo/xdD6Z0DfE1ebN9XcYpFWp8wqyRs64GHi5NaY+GFzc0i0ikd7wLY8kQmWIK/k2O7ySym0Z74ZEONQGKWZ/Vh6dctpP1wKQuCrBCbrt4AGtb
 w3pRF8hd
 zrGb7Ts/TMg8bln1gdCm7MI1Vru0PlV9k8cv70LD7ZlmN68vKowgs+xRS3H6244kHXwc/3EZ/pD0x1xTWjQukk0udR/57Du0p+A/PN343L17s8ylkkZ9CAh5RnK82WdKdvwyC5XOg0RhmyU/47QOnHo07ElLjfotgXuGgKcixv+kS4RMLCj1DGpKME/JfnI6Uq295XDnQs7bFPl3q6EOq9yS/pONaOlWACpA7jktRvb9ocwiGAknhoRN4ALBFCO0cLPDeej5K1h4DUDmY7Iyl3APFxCPB0PgN+k6GzaEaP99rDytZkYnUNKAkzOhKr6Jbo3utYECfM0Rz6IuiG64qqPFQ7c8dbTMsPH/dWy72izBxx+Rx9K+Bv26manQ/JMUG5Xpm88SEZYeB01HWUBSvzgsftBm2eAFR2iLAzS/kJkPjnBRcZE3vqHMpoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Extract the progressive LRU drain retry logic from
>> collect_longterm_unpinnable_folios() into a reusable helper,
>> lru_add_drain_progressive().
>>
>> When attempting to isolate folios that may still reside in per-CPU folio
>> batches, draining is escalated progressively:
>>
>> 1. State 0: Call lru_add_drain() to flush local CPU batches.
>> 2. State 1: Call lru_add_drain_all() to flush all CPU batches.
>> 3. State >= 2: Return false to stop retrying.
>>
>> Refactor collect_longterm_unpinnable_folios() to use this new helper.
>>
>> The helper will be used by KVM's guest_memfd in a later patch.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  include/linux/swap.h |  2 ++
>>  mm/gup.c             | 19 ++++++-------------
>>  mm/swap.c            | 15 +++++++++++++++
>>  3 files changed, 23 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 8f0f68e245baa..cd54f73f34f39 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -344,6 +344,8 @@ extern void lru_add_drain(void);
>>  extern void lru_add_drain_cpu(int cpu);
>>  extern void lru_add_drain_cpu_zone(struct zone *zone);
>>  extern void lru_add_drain_all(void);
>> +bool lru_add_drain_progressive(int *drain_state);
>> +
>>  void folio_deactivate(struct folio *folio);
>>  void folio_mark_lazyfree(struct folio *folio);
>>  extern void swap_setup(void);
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 0692119b79043..5f00435e2c635 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2268,7 +2268,7 @@ static unsigned long collect_longterm_unpinnable_folios(
>>  {
>>  	unsigned long collected = 0;
>>  	struct folio *folio;
>> -	int drained = 0;
>> +	int drain_state = 0;
>>  	long i = 0;
>>
>>  	for (folio = pofs_get_folio(pofs, i); folio;
>> @@ -2287,18 +2287,11 @@ static unsigned long collect_longterm_unpinnable_folios(
>>  			continue;
>>  		}
>>
>> -		if (drained == 0 && folio_may_be_lru_cached(folio) &&
>> -				folio_ref_count(folio) !=
>> -				folio_expected_ref_count(folio) + 1) {
>> -			lru_add_drain();
>> -			drained = 1;
>> -		}
>> -		if (drained == 1 && folio_may_be_lru_cached(folio) &&
>> -				folio_ref_count(folio) !=
>> -				folio_expected_ref_count(folio) + 1) {
>> -			lru_add_drain_all();
>> -			drained = 2;
>> -		}
>> +		while (folio_may_be_lru_cached(folio) &&
>> +		       folio_ref_count(folio) !=
>> +		       folio_expected_ref_count(folio) + 1 &&
>> +		       lru_add_drain_progressive(&drain_state))
>> +			;
>
> That's rather nasty.
>

I didn't really like this either, the drain_state thing is really
awkward, but in both usages (collect_longterm_unpinnable_folios() and
guest_memfd), there's an outer loop where if the draining happened on
the local CPU before it should skip straight to just draining on all the
other CPUs.

> I was hoping that we could embed more logic in a helper. The history [1] of the
> refcount check is rather sad:
>
> https://lore.kernel.org/all/c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com/
>
> ... primarily because of mlock() handling.
>

In the original code in collect_longterm_unpinnable_folios(), I couldn't
find anything that handles folio_test_mlock(), so I was lost for a while
until I realized mlock() doesn't add a refcount to the folio.

Are you kind of proposing an optimization to
collect_longterm_unpinnable_folios() by adding a check for
!folio_test_mlock()? I hope we can put that in a separate patch series,
I'm still hoping to get this series in for 7.3!!

> For guest_memfd(), would mlock() ever apply on a path where you need that check?
>

For guest_memfd, if a folio were mlocked, unmapping it would fail, and
so the refcount on the folio would be elevated. The
kvm_gmem_is_safe_for_conversion() check in the patch after this one
would fail, correctly.

I really wanted the caller of the lru_add_drain_progressive() function
to control whether to do the drain (see below), which would solve the
mlock problem by not assuming the use of folio_expected_ref_count() to
determine whether to do draining.

> Conceptually, I wonder whether we can do the following, and rely on the refcount
> check only on the mlock path.
>
>
> From ae30f7594692b0c47b44922c26b6480dd9584872 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Thu, 30 Jul 2026 12:20:14 +0200
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/gup.c | 66 ++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 52 insertions(+), 14 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b0..ec43071bd035a 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2259,6 +2259,56 @@ static struct folio *pofs_next_folio(struct folio *folio,
>  	return pofs_get_folio(pofs, i);
>  }
>
> +enum lru_cache_drained {
> +	LRU_CACHE_NOT_DRAINED,
> +	LRU_CACHE_DRAINED,
> +	LRU_CACHE_DRAINED_ALL,
> +};
> +
> +static inline void folio_likely_lru_cached(const struct folio *folio)
> +{
> +	if (!folio_may_be_lru_cached(folio))
> +		return false;
> +	/*
> +	 * Having the LRU flag clear either indicates LRU cache references
> +	 * or LRU isolation.
> +	 */
> +	if (!folio_test_lru(folio))
> +		return true;
> +	/*
> +	 * For mlocked folios, we don't have a real indication: we can only
> +	 * take a guess based on the refcount.
> +	 */
> +	if (!folio_test_mlock(folio))
> +		return false;
> +	return folio_expected_ref_count(folio) == folio_ref_count(folio) = 1;
> +}
> +
> +/**
> + * lru_cache_drain_for_folio() - progressively try draining the lru cache
> + * @folio: The folio.
> + * @drained: Status initialized to LRU_CACHE_NOT_DRAINED by the caller.
> + *
> + * TODO
> + */
> +static void lru_cache_drain_for_folio(const struct folio *folio,
> +		enum lru_cache_drained *drained)

The main thing I wanted in the proposed version
(lru_add_drain_progressive()), was to let the caller determine whether
to try or to continue draining.

I wanted the caller to have full control over whether to drain or not,
so I didn't want to pass folio into the function. I thought the caller
should first determine whether to drain, then call the function.

This version assumes that the caller wants to continue draining based on
something to do with a folio, and the folio may or may not be on the
lru_add fbatch at all, which is a little strange to me.

Also, this version enforces a certain definition of "expected" number of
refcounts on the folio. I guess in this case this definition works with
guest_memfd, but guest_memfd doesn't support swap so the swapcache check
in folio_expected_ref_count() isn't necessary. Also, if the definition
folio_expected_ref_count() changes, then guest_memfd is implicitly
affected. Not sure if the "expected" definition is the same for all
callers?

I guess if there was a function named
folio_ref_counts_indicate_presence_only_in_the_filemap() instead of
folio_expected_ref_count(), then it'd be the perfect function for
guest_memfd to use. The current definition of folio_expected_ref_count()
also includes page table mappings, but in this check guest_memfd really
wants to make sure that there are no page table mappings.

This version folds folio_likely_lru_cached() into the check, and I
adopted the check for guest_memfd because it'd help with huge pages,
though technically guest_memfd is always 4K now so the check is also
pointless.

I tried a macro version of this where the macro caller can pass in a
full condition, which would look like this:

  lru_add_drain_while(folio_may_be_lru_cached(folio) &&
                      folio_ref_count(folio) != expected_refcount,
                      drain_state);

but I thought that just created something people have to jump to, to
first understand how the macro works, so I left it as an explicit while
loop instead.

> +{
> +	if (!folio_likely_lru_cached(folio))
> +		return false;
> +
> +	/* Try local draining first, if not already done previously. */
> +	if (*drained == LRU_CACHE_NOT_DRAINED) {
> +		lru_add_drain();
> +		*drained = LRU_CACHE_DRAINED;
> +	}
> +	/* Try draining all CPUs next if still not an LRU folio. */
> +	if (folio_likely_lru_cached(folio) && *drained == LRU_CACHE_DRAINED) {
> +		lru_add_drain_all();
> +		*drained = LRU_CACHE_DRAINED_ALL;
> +	}
> +}
> +
>  /*
>   * Returns the number of collected folios. Return value is always >= 0.
>   */
> @@ -2266,9 +2316,9 @@ static unsigned long collect_longterm_unpinnable_folios(
>  		struct list_head *movable_folio_list,
>  		struct pages_or_folios *pofs)
>  {
> +	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;

I also considered an enum, but it would be another thing to export. I
was thinking to have drain_state just be opaque to the caller and the
only thing the caller needs to know is to initialize it to 0.

Perhaps there's a better way to "make it opaque"?

>  	unsigned long collected = 0;
>  	struct folio *folio;
> -	int drained = 0;
>  	long i = 0;
>
>  	for (folio = pofs_get_folio(pofs, i); folio;
> @@ -2287,19 +2337,7 @@ static unsigned long collect_longterm_unpinnable_folios(
>  			continue;
>  		}
>
> -		if (drained == 0 && folio_may_be_lru_cached(folio) &&
> -				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> -			lru_add_drain();
> -			drained = 1;
> -		}
> -		if (drained == 1 && folio_may_be_lru_cached(folio) &&
> -				folio_ref_count(folio) !=
> -				folio_expected_ref_count(folio) + 1) {
> -			lru_add_drain_all();
> -			drained = 2;
> -		}
> -
> +		lru_cache_drain_for_folio(folio, &drained);
>  		if (!folio_isolate_lru(folio))
>  			continue;
>
> --
> 2.43.0
>
>
> --
> Cheers,
>
> David

