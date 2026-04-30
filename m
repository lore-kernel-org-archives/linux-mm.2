Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5474DCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F616B008C; Thu, 30 Apr 2026 12:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875FB6B0092; Thu, 30 Apr 2026 12:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B706B0093; Thu, 30 Apr 2026 12:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6554E6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:17:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4446544059
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:42:34 +0000 (UTC)
X-FDA: 84715639428.09.594CBE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id AFCA9140005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:42:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bg5kXYtm;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777563752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWlOrGB3uzSP7r2d6xQ9PldArz9tx4N60VGyQKuxC4s=;
	b=yN865NUcH0+jWZr9pJ+Kc6R+32IKPIjtEwylWUZ6yzuCh8CXLUDP7TBc0qxKehZtkM2eda
	8fUC6s4vjmPg9OZYKKJJlUj6PGBU0W/Awroh4+mzFwb1snBrRK/cxv5LsNVjlFMQM37AA2
	8HMTkpi0XAhbO+h9OqyuZIvqzJGkVYo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bg5kXYtm;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777563752; a=rsa-sha256;
	cv=none;
	b=XkVjmAJcZpWJV0+zb7FIB/+eCHsoq5HVfWQpOtcSOW2ynCUgBaer1Abt2IawEn57Qw9aB2
	PyvNGqq+KC9jrj5VL8aApIbhkP3ou8N6bjohNgR5v3XCkXbR6I70EeCzTaIPXOb4LXg+a7
	fu0mLYOEq4fhmk8kF17m0PKgC82mP74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777563751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWlOrGB3uzSP7r2d6xQ9PldArz9tx4N60VGyQKuxC4s=;
	b=bg5kXYtm8I1+TuWg/UWENX0EzOQOLIXS5bdUHuDMh5Hkn95JryaYuTz65g/mrg/KEfR9TI
	n8jF1gxsfEzaKxPW/H6GZJ5Vbmkqm4ecyAfUwUEF4DoXNewOViYg61EB+7G8iENqv+D0vD
	ULTfS9ZgPUWCnFzI3+NGKR5EjWV/F60=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-JwY2fktuPgSMl5TefGhlVw-1; Thu, 30 Apr 2026 11:42:28 -0400
X-MC-Unique: JwY2fktuPgSMl5TefGhlVw-1
X-Mimecast-MFC-AGG-ID: JwY2fktuPgSMl5TefGhlVw_1777563748
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d8e8c47a3so26319681cf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777563748; x=1778168548;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWlOrGB3uzSP7r2d6xQ9PldArz9tx4N60VGyQKuxC4s=;
        b=TiosCkOSfulAk9EtuoNBPCONYQVmmRTSnSkPMV7Up19WdRRNRlX2DCIEXPp1QRv5Hf
         h+gK3QQ2drxcJMQykI44z5WB1rzm1EazW1v4AeRlfVHqITIr++X2GVY/8kIlK/3FoZvR
         AT3WVi1lW/Z7TAHXCzZe/xDypFsQ0zUuoE5+UUQwS7rUH88DgYwAW66wFJq9+YZJp9jv
         BxgH90MN8+DaQqdxvP+AUdCFy0zNSNuTOU0sDP0Dm2zmuUsPgHcg52te3lpGIKXAcUlg
         zQ6O8St4G3tZXNFjFgGMj2oEaWpRHcI461WWt9NMonA2r/Ch2E9+SdEwS+sgzMcN/PXu
         ZSsg==
X-Forwarded-Encrypted: i=1; AFNElJ9iVKKo/RJDCVfXF+sR/8XqPHQD01SrmpVSUxHGez8qV+H4tn9qHc0MkYalmAvjq/pLZMFIErBEIw==@kvack.org
X-Gm-Message-State: AOJu0YwD9ybSC95i2kPYS3vO5r53iHaSwZ6lQK1RIFsOeGy4QQFrr20j
	ITqPJraJzwI3Y32rrf01oChC0uN6V3LsJgfcEvhtyt3Li50xHx7iySpFRy4D212JkccLOVWnegx
	07l+Ifr1LVtwqRMlGFekssgaQrx/vcQt3ibq08zH0u2VFqqyXN04x
X-Gm-Gg: AeBDievqjV+L7EIMEKI+GTt70/pLI0AY3eRp65iaDjwWXLmsQfVZlplWo+SHKXiadQ6
	4IbbYQAZaqHydEsmzghBLRerBA0gvIHfFVPrUd7gY20SYeO1HPl9FPpUgnG9+YKDLlvzyEEu+Z4
	5SASXqkTa9OSVl9NN3nVCKH6cVYMjFFqV7oZcCyUWj6lRTT7ML1HVbkYvqzelWTafAOYESTtLlX
	yBm4MQgBm2y4yGD7A/foujcFrO8rWVDOu8wdmfKUJ1SghKYpTueRMqQO6iAXb3fmvNwDhAYAB40
	IiQYxJ7UBdrb4eyok5UvmO3edAZEq/t2cn6mz5FYkqOemyENMTrYkVaZdJDm9Ms53KhH4ma6kC0
	B9wZuEbLagkQ//lMiOgYSTqOLS0c1v4Qt5is=
X-Received: by 2002:a05:622a:8ca:b0:50b:526c:541c with SMTP id d75a77b69052e-5102ae320bbmr47576361cf.50.1777563747822;
        Thu, 30 Apr 2026 08:42:27 -0700 (PDT)
X-Received: by 2002:a05:622a:8ca:b0:50b:526c:541c with SMTP id d75a77b69052e-5102ae320bbmr47575841cf.50.1777563747268;
        Thu, 30 Apr 2026 08:42:27 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5103b605192sm1164301cf.24.2026.04.30.08.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 08:42:26 -0700 (PDT)
Message-ID: <14348c25-a272-4cd8-a9d9-fe8673fb0487@redhat.com>
Date: Thu, 30 Apr 2026 11:42:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/54] selftests/mm: va_high_addr_switch: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-21-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-21-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aUFUwqhzRsJtlm0qW1pHtqU2Rj3BJ8qnuINX-lg7ULI_1777563748
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AFCA9140005
X-Rspam-User: 
X-Stat-Signature: wpfjbh19i5o6ug43eug7ga19emmzaymk
X-HE-Tag: 1777563751-866137
X-HE-Meta: U2FsdGVkX19vZVBCzIvcIoSI1/PxjwZ2Xza8IkTAafxvWUNJuGJTZdtBS+U8BLgTaR03yF6Q1xr9p22h3pYLxmZybNI3RXFrSI5L+URk5Qc/ydh7KZfIit6ioM/6k0+RyMQItX9ohKBoOE3yF3yqXDY6VjogEE3pEyrlt0uTMF4G6PKGxonfw93/+bEpl3kUHKdey7VEfPVoSgXB0rmJS03P5W/WYNaBjhiMALmuAN+xSKmIED26+s252HLjvhbN3ZMEynSquAtRm1o73izZ5IFwTlUuiVuRxSm9n1ozUJyq4PitU7I0OvEhkEME1dDQE3Bns5vBVTOrMk7JQAxx+yvLlT0zu2xWZP9ia8bSov4F42hI9J+LuKG6g2uwQ4+afBci+FmkmNURLGbaG9ZbrAX12Wjd/ER/tvk8dQWISAIERSZNGug7dQQ3loShyr9PaylJTOElQvMDqLlVJrTN9L3yafg7Fy9j/kx3Q5PEsmylc6v9DvxvDMu6TGMFhOrA+i8ECX6Ye5G5sZMrTpoPR23meNORrDVNZCH437KTkEIX1X4sg8ZTiIykkJWjD656CLGB490fMeQOVbw2EDkLn/t5Q93JPK9/jhTQIVdAvECsp5umVuqgO8Xb1JLG//SksLGo9KAa52D6Di65C9gXCzVRz41qZ28vKxcnyIIsP80U+gxODnHpt3gmnEuXLBMJ1Qq5cfDPlDtnwaXS7AsR71xTw/BsXH99xKYue3rIDW62wi0eN/LJtG1F6BP7F+hFFhp5n2bvb2JtitAC1RmXMuHz3Ympd9exw4ktVhtSDKLQrWkoNq2jOANsbcoYmmt74YzmKKevGPE/O1KJhUdAgmehy7ciF8UJFTQpDi2gy1EfNenjwwqy2q7jO6+71mHiIQBuetgC9JiILMThbiDP0Wfj+qrBYumrQwMO2hPhPnizuEE9UyzVp8l/slkDge+9fdpDjewC/2ziGHAqcP2
 4S4O3PNn
 BeWhAbGcM6Gof7O1jdfdBvexwDwcyBxw9R6Fsp4qMLv3yaPRyCvjBwTfzFIx+uKemZY6L9tIdh/DuMXGnjPNRvNVCxF/6FlBN3tx5O/D7dnHQGZVaH9Deirn2J+4D283PHiIxgx0UfckIYpcoA4DAcb8pVcplscITNhDPzO4VUCDmfVlN5ErSbv1GD6BiwEThAB/C8fz142MpXyBohXh8nRPLoqyoBCXfqV6ppuY6zK3sayH2PFtTC4KXB115TkJg/wcvQIfU13aPPcu42TAhFCSzG2nuy2KZL3I2TKOnggN3HjrPpZWWVCspjvOKBM+Jrky8ItBbh11fpfHBLlJwvIHzZp0xxKaOfbtW7213hsoGCLlxxdFHCFM0SlQ5zHastxB0adr38KIcXnS/s1IURWX1yAdpVXLakLCYZH6VDASPyNTp59Vz8pK1V8yvdr/c3cFY7RguuzTx38SJMEh9cUseuCFlmD4WQAts4Icc5g6mdJNgxBr29vkhGJz2t9AYWsxVYVztzfKlLXCFrB22EapBqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert va_high_addr_switch test to use kselftest framework for
> reporting and tracking successful and failing runs.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   .../selftests/mm/va_high_addr_switch.c        | 41 +++++++++----------
>   1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 51401e081b20..5d38735ea60e 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -257,40 +257,35 @@ void testcases_init(void)
>   	switch_hint = addr_switch_hint;
>   }
>   
> -static int run_test(struct testcase *test, int count)
> +static void run_test(struct testcase *test, int count)
>   {
>   	void *p;
> -	int i, ret = KSFT_PASS;
> +	int i;
>   
>   	for (i = 0; i < count; i++) {
>   		struct testcase *t = test + i;
>   
>   		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
> -
> -		printf("%s: %p - ", t->msg, p);
> -
>   		if (p == MAP_FAILED) {
> -			printf("FAILED\n");
> -			ret = KSFT_FAIL;
> +			ksft_perror("MAP_FAILED");
> +			ksft_test_result_fail("%s\n", t->msg);
>   			continue;
>   		}
>   
>   		if (t->low_addr_required && p >= (void *)(switch_hint)) {
> -			printf("FAILED\n");
> -			ret = KSFT_FAIL;
> +			ksft_print_msg("%p not below switch hint\n", p);
> +			ksft_test_result_fail("%s\n", t->msg);
>   		} else {
>   			/*
>   			 * Do a dereference of the address returned so that we catch
>   			 * bugs in page fault handling
>   			 */
>   			memset(p, 0, t->size);
> -			printf("OK\n");
> +			ksft_test_result_pass("%s\n", t->msg);
>   		}
>   		if (!t->keep_mapped)
>   			munmap(p, t->size);
>   	}
> -
> -	return ret;
>   }
>   
>   #ifdef __aarch64__
> @@ -322,19 +317,23 @@ static int supported_arch(void)
>   
>   int main(int argc, char **argv)
>   {
> -	int ret, hugetlb_ret = KSFT_PASS;
> +	bool run_hugetlb = false;
> +
> +	ksft_print_header();
>   
>   	if (!supported_arch())
> -		return KSFT_SKIP;
> +		ksft_exit_skip("Architecture not supported\n");
> +
> +	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> +		run_hugetlb = true;
>   
>   	testcases_init();
>   
> -	ret = run_test(testcases, sz_testcases);
> -	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> -		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> +	ksft_set_plan(sz_testcases + (run_hugetlb ? sz_hugetlb_testcases : 0));
> +
> +	run_test(testcases, sz_testcases);
> +	if (run_hugetlb)
> +		run_test(hugetlb_testcases, sz_hugetlb_testcases);
>   
> -	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
> -		return KSFT_PASS;
> -	else
> -		return KSFT_FAIL;
> +	ksft_finished();
>   }


