Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 722F0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD66C6B0005; Wed, 20 May 2026 05:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EB76B0088; Wed, 20 May 2026 05:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DA06B008A; Wed, 20 May 2026 05:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF6D6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:38:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46A4A1A0202
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:38:29 +0000 (UTC)
X-FDA: 84787297938.28.C089F48
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 560F1A000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:38:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oXWQ7ctJ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269907;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVTQmbrETv5mK3lzRRB7IS3srcOG1eF8+E4fWkWcGbg=;
	b=2WsL8movQXU7qQxh7yAjZ6+fwdbF9/hu3UkhMEwVVH3ElvoCfTzLoeik9ecE8NkPWWhYDE
	VWN5za5fWm/09QgEaZ7A319/BSFzQkpAo4d8QNmiqQ+phFuwguaDW6MgMtgPYGcR/3LMr5
	AmVqimqLbHcbO979/XhEFzEQcGTH0M4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oXWQ7ctJ;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269907; a=rsa-sha256;
	cv=none;
	b=VrCCl4RRBRQFbSGycJKn8W+rVZ6govPawJ94WIlSijLXEyK2F4/vfrxPB3YpaIjN/PTdbh
	/zG5vCfcWCz+tYnraGQ3Mt63ykfyUuFvekPYUVHSJsYQrFNzA0OJVZ8QuvK4qrQ481yUvp
	mWkW6vr7gimAsvOjjM3baU+kFbRWsPo=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bd4f8260e4eso944757366b.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 02:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779269906; x=1779874706; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVTQmbrETv5mK3lzRRB7IS3srcOG1eF8+E4fWkWcGbg=;
        b=oXWQ7ctJOyD3FWkBNdCluMTeYLzC1Vx696Q61FiNc/lN/qjnDyRtBRCeg+2Z7G+JTE
         58lcNIc6za1OAcGYXsdeGdPU7t3ZHVIw0DIirf1AZwyOziDnl4bpSjk3TGbC7mNPn1FY
         XXkirAMPivyLrfFvTgrX40IOYu8jmwSdeh4IumtBiQzY/B+/LgJ6Xu6g0+LDlbw+lJIk
         xirq23VS8D0lxHxmD8nm/P/NHS/Sn7V61Jq1e4K1Iom4EZ0ldFbKKFvdeGjh/EQJCx0J
         sFi7tkUmCXyuNvhsMpWKhJ61xkqx2R3Z60yvMgRUeBSEFTJZo62nJmf1hVF5Voi4wyXl
         1SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779269906; x=1779874706;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BVTQmbrETv5mK3lzRRB7IS3srcOG1eF8+E4fWkWcGbg=;
        b=UcmF3bPd/78qTh3qdE9++XdSkig0P+WHHH2WkBMEhMwc8xkwL6jT0dZ1fhC1GX+HPh
         hHz42/3omqParR4skDWO5lo7eYwvroyWxeVPd7NFk6zG2Nh5bTQAo+sOC4NCy+NPBwvA
         Gj9WHi9G8Al4HuYrxAoEfVY7eaHq2C2OxPj8PLEHIj1QPYj/Vgvzo4Lfju6P6NrPrRdd
         NbhdfbA9A0VbnnQPLQslsvgGL7OBSsdIeapJmLp+bCOZhD4bv7LvaA7Ke1SXNW8hcdW3
         dWst0u2tOBYwgFNH5x2c3J0V8UHsGuWW1mCYxW5EGWJVfMNxuFMFlzEQ7A+ckWu/s0pa
         lSRg==
X-Forwarded-Encrypted: i=1; AFNElJ9guyD/vp/iUt9FFdm8kQ7gAf9oVgTzq+3CszczUEga4NMGwUI4I313oGWiILQ1++YfV9GPa+5jvg==@kvack.org
X-Gm-Message-State: AOJu0YxbJCJtB6gzJKO860xYO0KErRGPBy5YYBUh+T2wmYV/ETeOsO0f
	QLN/arI5AyqCzi8lx0qR6oZBBnsk/+6INGua2KOtxJiSTX2AsgGHeux7
X-Gm-Gg: Acq92OEmdPcY15GzTEB+dFeDjCcYxOQ9WLKyT7mtFUlAircPWAhvyarVnz6nF6kd3Rf
	v8xWV9gFYW5wgEh7WuyxbUJKqxfzxkNNyjEylhe6HA9xR6ZHfR1K5zD1jhqLOXhNWUi1nBWCC7G
	ire1mD/ZqXJyKhoBjZUtDv46AtSbN9YbGaPWZmQ+Db/hod6Rtq4mXk/+JhIvNpXN8XTuxcjeUwz
	7GrfLBGhydm0JyeZ+cxPewzRPm9Kedr6OH8fHLw4ozamwtw9MveiuhAmulQhjHqaqkko/4sLcWW
	fAzqvjLIhEgL8ksxBDwLIyM4hvP9D3oTCmGGgE15JNDZ6xh10q1zkUcVe9DDLYIjrg+Ld/tABkw
	SyB82FoKrxFZkcfdVjt4ygqgfVIbeXKA610F3FRMF4ksowlxqpQO21rGFKh7NWCS045WXB8ss8e
	9dv1UQImE5QT2WXsgqP4i0rpQVesHC8ZWC
X-Received: by 2002:a17:907:8d8f:b0:bce:267f:19cf with SMTP id a640c23a62f3a-bd5177bfe13mr1418541666b.12.1779269905399;
        Wed, 20 May 2026 02:38:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c28c0asm848870666b.17.2026.05.20.02.38.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2026 02:38:25 -0700 (PDT)
Date: Wed, 20 May 2026 09:38:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: close fd on write error
Message-ID: <20260520093824.eannlavh64fpxyrz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520020336.28914-1-richard.weiyang@gmail.com>
 <20518530-12e3-4731-9b4a-54cc950239e2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20518530-12e3-4731-9b4a-54cc950239e2@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 560F1A000A
X-Stat-Signature: 9bzxboewkcxzt1quorgfm3uhcbfi6o8d
X-HE-Tag: 1779269907-804496
X-HE-Meta: U2FsdGVkX1/lWDtjoQv+Ze7QpVlIbQTwwUhNSlvan1xEnClngSrNPPJTyoN4c3+AX/UL/zx6ZatgRxtNWFkfQkO6XO2IiQZL3/W1oA+eYeCw3ZS5JGEB6cm4evtnLk8KuuQjMxWTJEKe2ydGf2+Yles9+DcAArEv3CKYWUIUM+LgMjYTijBvB4VVy2tjGjpj6dKKtXfObSl0ohhTzIGSqXobjvfpxm+aT/9yPUNtchHRASb3h2+H5gcSsaP0GeB84KYZbz98sVoE5GnPbE2a4xYspTba3gFnZmdvRSUq3u4mnA4tdABT4/Rwi8S6T2rkcylmnE2xr5QBWgrNepHchUl/V1jHD6jvuT7mQdkqDH+9S2eCHhPCvbQ/kcM9TnFcf+cyn5pAA3wtfNb5DOEmsbtELI2gSY1QMLv8ti9UUuqqC8FKcG4aestiQ/n3wXZMkEjT5TeusW/1wXyX/c13NHpyOpF9BNk2LorgrT295ds/2hpbJlIGqbLS/YVryHPLoRnTW1NsNN3adCFym5sTHBpJy2eAzFftZDrR/lR9eqjXyEupkdwrK6VwZR8/IlkGox5FnzyrDC5x/p7pYv9hsH9aKDtnqcmt7jhUJsjvbFar7Nd+bIkm0IFnnGj1gSc13wsUJ52Oxyn11OIs9eATJD74hL1eurnug/JX2yoix4gQ002CewgQ4Cb+hxicVspF1+r3PiSgjCAD2yL4JMhsbOaSVgbtMKtEEdJefH7FOpVuFAKX/FjUMxwexvfNcW4aisVO9cZaB+gfTzimeD+XwUWwweT1yTaUfq/pLx4WIhlfFZrzTO/17iirnSGl9NJGia4APys4UQd2WYzTw2zvF02Q5ACVqCez6a0Sf67tdNThZdLphfnRVZKLluruLys3W3eio1sIWiB/MlyumQW/4kcCKqoHcrLFkavt875w/Edw38gIxaMfMO5lbvzo7K+jE7sUzySb2HmKjJd1Ba7
 LHPNnBvm
 TxrI028OKStMreTMvUq70uDY2rJsPBJmfM/+Vjv4qont6H+ZfjM1fPbHuYZHo4DPbHKGGcJFtvVcG3VtlOaQhVxOhQAVA9Hm6CkrD+Cfgd6I1HKVSCp1FJ2XZbFP5J8AII0uRw+lRNU5AkQasF1j/d+mmMSNmhSNZ3rOFoa0AUdqTfR8eCZtS2YrO+KxEgXeNegZ7HyzMFVKp4GckgYEz67govNUEo1W5L3iORCATRa+R5jDPFprIEQe0JNhCeUNmaLAj09IH/QgWChNTQLAE01+09M7ke4UTupG2OMsvTo00+Q0uKOvi0Ue6c3ZklLrzfitUnRDPzWiFx44cVoyqtskdYyj8MBbeTtDNAffasps9f3P0oL9yFzjvUlqUb+vcEm0CVfEhnHTzfvhKa5qrnLALuwdu0tzrrmND5eGzYXrDh9Xg8BxztW/RV3fgCkl2rjcES56g+w0SiWQbCOgGXSh4Pt+AUWkOuFuzYwE3o/nAV85yFDBhK2wgWMLXnbPyOMDNDhrtiEJyawLTEtTesQ/AcuoZpScv1bMpBFp0z95cv85Xa2fBwdoXD+OdLzfpKKHaYTQyB146WAjwIrsjmVANtV0jeTZ8i9s+Y0f07yJFcSD65aXRDNaRQlBNH1M8oEkSy9OQJGQ8RBqxv2J3EP2YwYqy0xYp6w4ODlyF6fdKmv15bzJBRG5dtW+wf/Xqy2UszmXUD7LLlLdwXyHAxIFBA7alB14KdGlfXAOyyH/Hu/PsThAkeyciyARWLWc0hB3PL650eAaZXzcAeJV0dpEx+5h/q4G/zZlp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 09:21:48AM +0530, Dev Jain wrote:
>
>
>On 20/05/26 7:33 am, Wei Yang wrote:
>> When create_pagecache_thp_and_fd() write returns error on
>> /proc/sys/vm/dropcache, it just "goto err_out_unlink", which left fd
>> still open.
>> 
>> Use "goto err_out_close" to close the fd.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 460fa1f606fd..f30402ece608 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>>  	}
>>  	if (write(*fd, "3", 1) != 1) {
>>  		ksft_perror("write to drop_caches");
>> -		goto err_out_unlink;
>> +		goto err_out_close;
>>  	}
>>  	close(*fd);
>
>LGTM
>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>
>
>I asked AI and it points to another problem:
>
>for (i = 0; i < nr_thps; i++) {
>	if (is_backed_by_folio(page_area + i * pagesize, 0,
>			       pagemap_fd, kpageflags_fd))
>		continue;
>	ksft_test_result_fail("THP %zu not split\n", i);
>}
>
>ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>
>"If one THP is not split, it prints FAIL, but then falls through and also prints PASS.
>
>It should probably jump to out after the failure".
>

Thanks for AI.

It looks we should "goto out" after ksft_test_result_fail().

-- 
Wei Yang
Help you, Help me

