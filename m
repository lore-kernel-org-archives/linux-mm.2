Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F353CC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A256B024E; Tue,  1 Sep 2026 10:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0614D6B0250; Tue,  1 Sep 2026 10:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92EB6B0251; Tue,  1 Sep 2026 10:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADE7E6B024E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:29:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2493DA4221
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:45 +0000 (UTC)
X-FDA: 85165427130.02.BC1C570
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4556EA0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tH2gm4nT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VIJBhRLr;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvOt4XcqRa4ZBjSZBBs6iCTuthgQbep0Dh/wljdrLa4=;
	b=lAPmPxSZFg8ud3Ei0ZMnTD1xB2vQCiejlnBJe6C1NyX/0ICsQzqnPFeJkJUb1zhXFl+lt2
	0+oQGJqgnrvtCYkAffCWpYFVw5LVq25w0aWL6fYJ3s/r91Kbj/9XyvAYRPsxvzEk5/9GrQ
	c23/0rydQFxTKjVMY3orraOQahh/tAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272982;
	b=AwTDzMTLdLOdtcSAmYo4Z05PU519lb2g9j7jyeAYCeTh8RFa9UDW1JdK6YA9cB47QFL8bZ
	Z/jxt9Lj7dpIh/vxULQKjBw/V8mAGljwvecLkkrVtOHg6TZahKE5FYwrh+cGHs7C1hpxGJ
	+asUqXToSfGcrC/rDZ5qQGyUHjd7SDk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=tH2gm4nT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VIJBhRLr;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681ENN1v1434309
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 10:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HvOt
	4XcqRa4ZBjSZBBs6iCTuthgQbep0Dh/wljdrLa4=; b=tH2gm4nTlpG2NR8ZjwVz
	3IJooSkOTzfHalbIw0MNM+iaAdQsE80Kvxf+ZYUwRaROXRsa7NYVivtA1tcGgZPD
	m2GVdKFUdJyVJbhBSc7Q/j3XXvtIItb0UW+eiO4h6ZqTpW1SjdWjJGjH3qPByl+H
	AInl7QytNwZQv1m860JCof8NysTImtYAdn96klvoZFdlTZ2Vv1gBGbFDq41yUy4N
	FGkt668u1YrBBh6TWp1G5ylyD+ZKbbOGfLYhwYej64zCsuxtShzzn4iI2UyL0mKL
	C2dckBfdjhxZlEL0RndCSgcgH7g7sAjvs5dBfkMPbIT3orBHfOIQmivdeLMJ1Esj
	iQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gdye2gpkr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 10:29:41 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-939281526e1so104254285a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788272981; x=1788877781; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HvOt4XcqRa4ZBjSZBBs6iCTuthgQbep0Dh/wljdrLa4=;
        b=VIJBhRLrYzDhIqBE0s5+644SB/zLCPu+pkHARKoCUbWNzaUSp8RiZJXz8m2ev/+5/v
         jMMWwtiEcdNtFoKEn+LWIYH+dWfayqAmgcJetYmgJzERRv4nwm2Akn159ZpQqOPWAssl
         kJ3ae0t7v/cAPkNwXWobmuPN7tyQ0QIkZIx2RLkB1JIQKyCIgYoX/i2O00PzPO5sAAwW
         LHV+8O7snvcpFX5Z9zowuXMT0K4mn1+pLJX6Ojunc1oJ+TgpDf+Q0xM7zoO3xprnTjWU
         BbgWo+Zlh2vk37CVDhD+9UYGFgFuK5ZpsOz02T5GLqgo+4gotiDBUPGiEIrE1tqFED1T
         o7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788272981; x=1788877781;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HvOt4XcqRa4ZBjSZBBs6iCTuthgQbep0Dh/wljdrLa4=;
        b=ittTzmdKQIz9sgKMDQ0/XrUfzW72h4jCphS7sgvCcQBLohfb6C6Mlhb/9i+MZgm6En
         I60hBv/3ERjHvrF4A/dYeGlGR/qa3nNsStPifZr/o6Kjn9eOrxXeyyxh3VMLS7h0Xn/F
         oGQBo11FufpgiFQVG1tuCeG+R0vBQuCgbHHnHdAcHxwLIoQylhygoTYiB0WJbneub6nc
         GAC8tnj6DTCzCh8HTzeQ2OWXpYzBzUcjF7z/r7PvIrXlbdczavzM5RK/NjJAB65g8Y3E
         D1AAsGec+ay4N33iESsPWbm7bS+FAkD5XqGE2pNFdlojOZudATIwLJmMMTNuDDN25wPf
         ynTA==
X-Forwarded-Encrypted: i=1; AHgh+RrrtmO9esQ0bx6bYl4wFoFa37Q57rnyOupyW5R7h7RPhmudyoJ2fBGC2mcdS1jqzLTY0vD4SXAs/A==@kvack.org
X-Gm-Message-State: AFuF++ngXlhpe/WZ4z+eFf8JQPeTkwCDAmB0Llh2bWf91fTiAefmZbat
	86dHuoUJfpJZb6VXqKJqksjRzkgNJkSAJuPZubMI1hDPbhVU7PuokI1q43GBvFq8MDKX2/yfsy6
	ul+JB9ZXoGvK9V7GHa/u/qAV+87UUk+MGlnr7RuGvprftkA6n
X-Gm-Gg: AR+sD10EXQKMEBL8l4LcTGj4lwx5Z1Jeug4z3OKsBRiKsf9JJwOn0w2S4mBsvU0ewXj
	Fzagd3EkkdBtf5BzbVN2xCcswZFTF2paBDRGdokoeIFaNTaR6me77Zs2Zm6PHcMRjkOnxarCKsB
	fvn+0v9YuNaJHS2+OJEfAQbCVJhprfN40gvfEBb+T/OBjAEc2N+l/SqAAhw2oINaPs38wzRfJEc
	gFrsDo3pLrvGPcH4aZD+6wcAL2ZzC5x3F86L7Qxgw6elVjJbZAmBTVT2kFYnKSFfdQDCeLFBOJz
	rRxf0557z+LZzi6nVYkqtL2aBTuw3x1JXmFK4wo4Z5BySKO2RhzFamEHVWPVHJZ8at7vX3ENTFR
	s1zAnmB7f3VK4fCJyK7ziMAOHw8KcLkyw+izxc0nQ7Vhj6GtOVQ==
X-Received: by 2002:ac8:5f95:0:b0:51c:555:7dea with SMTP id d75a77b69052e-52fb9690435mr397976391cf.30.1788272980604;
        Tue, 01 Sep 2026 07:29:40 -0700 (PDT)
X-Received: by 2002:ac8:5f95:0:b0:51c:555:7dea with SMTP id d75a77b69052e-52fb9690435mr397975171cf.30.1788272979958;
        Tue, 01 Sep 2026 07:29:39 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe878f4esm96424981cf.31.2026.09.01.07.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 07:29:39 -0700 (PDT)
Message-ID: <3a494e29-fad1-48cb-8ac8-d9a20d97f020@columbia.edu>
Date: Tue, 1 Sep 2026 10:29:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett"
 <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
 <apbbw0A0f98nlVol@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <apbbw0A0f98nlVol@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDEyNyBTYWx0ZWRfXx6yhmSYpX5Sc
 5ga2g6RmPcSBNKqJOTsvUqKY7Qw/mFyugLm0p+cgsKSiN8NDftn7h7Mpz/DLn7jmoD3BP4I6Qvk
 VCdNDOzZ5lCZK6Bm1GQQh9MRSoBIBHi/FvJhqIRoOiZymSip9Nqo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDEyNyBTYWx0ZWRfX3eTk2ZUWm9n/
 JGjw1JG+XvDcLxVez2YEqbFp1oLyZl8KZXTiMvzMrKu09It8456wm7LfIgmA3SJtWqeM4V82oJO
 VKtetA2ZBGlWTsbJivPJs7cUsv+cAi5DNlWW0hJNNVgtB8NuhX5b+IdFZXZp5TV3WdJaK+Zahl9
 eVPDbVNQqQOUiaY5qVrEPeqXvj+YDU7VJdFU+ebOsiGTyRvkB6HBd4C9tPTF1H2SG4ERM+iPhzV
 vzBUtn1DLJiyCuU8pAiu9s3kX8PNuLKJlfZTHpjpSdWiLaZCWl9Waf9RYQPX5N0lfE8ZirJZLKq
 WdhK4i8tRMn/HYqOLVnGJrMXi+aGoChWv4xG609kxTBLs9UblkceJtU+dus1ahOlTjrBTkD6pml
 W1BwCezc2PoGqUK/Y7Y8rdzLQtwMxCB+nrnfGo3y3I9UtGH+I+zXWlku03Njc45PxcyAWstlEe4
 Q7x7UhKMKrOOb/DPx6A==
X-Proofpoint-GUID: Yeyk7oWekUUD6p9Y7IgCWLQwnpEvt7p5
X-Proofpoint-ORIG-GUID: Yeyk7oWekUUD6p9Y7IgCWLQwnpEvt7p5
X-Authority-Analysis: v=2.4 cv=I+BVgtgg c=1 sm=1 tr=0 ts=6a96e155 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=B0BthrHYGA8IgNGofVsA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11893
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=10 bulkscore=10
 impostorscore=10 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010127
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4556EA0002
X-Stat-Signature: bkhihaib6xtf1dxxfnhp1ej44pnj5n5a
X-Rspam-User: 
X-HE-Tag: 1788272982-996755
X-HE-Meta: U2FsdGVkX1/a95OxTpPQp7tAD202ZB0ivSKqp20GbRJdGsACS9OXWkwt0kvZ7YzFOu2lM1P5elMvWX72nPWPCej7VflEw63QumKWonfEM5CyAlzVlymvk5EXl0FJ9ORd2CVkcZdFpRjmTCz7wzi6veU7kYgCyqr3mDvrXCqcf8j5P4FuysX6C75PSKkBYelZ1gEV7hqOIUTnR8iwfenj4VwmH0gozX87hKI3UOYBuFbHHWcBQngBbT5iKQW45cHgfMF9Plb6l3SfwfP+OOPTdTxgAYHcLqOLlx9QycQgWecbb/Ag46dNH8k/z5FNUJkuggktswQbA9PzpArVUcmf0WZLUcCUt+FBuoTz3fg/TEjeOS5t0wocUi3UVQNRQzIMBoRrTZU7LmV+4RTUPtOShkxEj1dYY46Bd7LTBMcFP4AvhN8eYBJUu6wmBIUg7Yt5YuEgR/6M2XZrU3YEzPKHxNLdazkjM0s4fJreQLPPLgF6xOuazoyE5tkfpLDFemObSvCevTT35GGhMiOJ3mdkWCoDW/sqK6RenSKYkZie55gdqlJ4pS3ZRfPS58TWcB8phe5g3Uakf/J7QyHHGmU1iXgLunOVEDFPzZHMxa2KxSeEHlv35ClnUzyRVN/7/zoyL5oh3f9747rrhZmUQ4jSrFJYwneSrHZENadv4skUbS4U9+KxC5FoAbJlWzEqvA8MmsTP38Ra58lZj0GorI9VWvgqG9sqaK4jzf1MD4KYZm/kOuorOm152Rb2wQAy+GOFKC0zSRVOFCkE1mqMNspeQ9qbkGa3ko0dGvQICCeD5xGmnHjzv8f5ZfDiejylIAOHBBqV1jd+9n+bUjiwwoWnJErgDJPMNdRJro3CzJ85FfBxNn2yecTiJnOqzW0TUgpfTQR/FEAS5gylPuoB4GCH/NhbDq0wwk3T+lfoK0EMQC3pryjoM1QOkcw+XtqrZGtAUR6V1c1c16ZGs9XPc5W
 DieiwFD9
 qFRUWIUI9duPoDfXiNnCWU3QFeGYDHPJkhDHCCrRmLsDfu85KUKLVRwaxqXRPQkKSwYRoSfTpoZCTwpt53rlCJhU7EHxanrEksBjrx1IDgZaA1nRBY2KaBZJh3Dki1yFmSkYNV8wtC+nBbii31zocFePm9Oo2a/mwHpAWVzXBszR1g5p1BZ6fRtCGCE/v+rsPA7zpjJozHUeA2nT0zWDxCVA1w3FRubaUg97Vg3UidzWIY95YhJ5pGIAyeMnZYAxN+H2yBGKpaaeKHvcQaJ0M7a34kiHvTLFLBOAS9nkVXaYfDq3cFMya8kjgurR944TVrgwcYkBtxNBSoYU9LfettGETFua5OPkk5fUBFfvZ+ZzNT4ahbQqLXvraX6MzZQ7lyFD2RBsSNkr77NP+chgfY+FVSKY6cDHTbavblBQq56S1CRHj8OyUdFx/u2mlUWQTGq1FTTz/TpMCRSLTQFxd2CC3T9OMPYsmr2mMEszfp9cElvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 5:06 PM, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 08:59:20AM -0400, Tal Zussman wrote:
>> totalram_pages_inc() and totalram_pages_dec() have had no callers since
>> commit 7fbc5e26123e ("memblock: extract page freeing from
>> free_reserved_area() into a helper") and commit 287b89773d81
>> ("powerpc/pseries/cmm: Use adjust_managed_page_count() insted of
>> totalram_pages_*"), respectively. Remove them.
>>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> With additional change requested below addressed, LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks!

>> ---
>>  include/linux/mm.h | 10 ----------
>>  1 file changed, 10 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e3736c42c4db..c105a3758915 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -57,16 +57,6 @@ static inline unsigned long totalram_pages(void)
>>  	return (unsigned long)atomic_long_read(&_totalram_pages);
>>  }
>>
>> -static inline void totalram_pages_inc(void)
>> -{
>> -	atomic_long_inc(&_totalram_pages);
>> -}
> 
> I also see totalram_pages_inc() in tools/include/linux/mm.h - could you remove
> it too to keep things consistent? Thanks!
> 

Yes, will do. For some reason I was under the impression that tools headers
are generally synced separately as needed, but that's clearly not the case...
Maybe I was thinking of the tools uapi headers.

>> -
>> -static inline void totalram_pages_dec(void)
>> -{
>> -	atomic_long_dec(&_totalram_pages);
>> -}
>> -
>>  static inline void totalram_pages_add(long count)
>>  {
>>  	atomic_long_add(count, &_totalram_pages);
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


