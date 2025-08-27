Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA1ECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CCC36B000E; Wed, 27 Aug 2025 10:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5246B0010; Wed, 27 Aug 2025 10:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1438E0001; Wed, 27 Aug 2025 10:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5EB6B000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:42:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EDDDBAEA0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:42:00 +0000 (UTC)
X-FDA: 83822802000.07.E1044D0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EF09180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:41:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WgmO/Zt5";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756305718;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6vIrA2DQOHDf/Q4IwHsVjkoNuFaBasbd/XbLZkvLWE=;
	b=EmjDTerLuWdByMfRSbfoPcZnxlk4mkFsIe+HIB8KmbtpqBkWyC5e4mGfiBt6FZC5Kc2Au3
	CwofudU5pXQjE6bmK+ISPiNTlOPKN3DKNWuEIjAz/3w2UyAzreqT9EwfASaIMxodtL6+iq
	HSuNwT1xtN31RE59brTE5vsliG4b104=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756305718; a=rsa-sha256;
	cv=none;
	b=GXb33GHOkSiD4U5EMa2hx5Ho+tn1zUtrTJgrOkTKJr2hzACzRT3LfFR4KbI1RqRziUuyXu
	/pqVygwp4rApyrNgzMDtlgX/I4sMnX83aqI1jpaEPIkMw/5tmuXuTd8zOLtBUCPgOhWjNj
	FdRJSaT00M8B73QUSJRtqIqB8CXnM6A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WgmO/Zt5";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7a2befdso1040486466b.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756305717; x=1756910517; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6vIrA2DQOHDf/Q4IwHsVjkoNuFaBasbd/XbLZkvLWE=;
        b=WgmO/Zt5Hhh8creXkadQ3tyAJXVLU6gL6djPItzO4RY0yHkHYroY/KHYUMkxiQPE5m
         lZ0UpPmfOnso+c4qMq1XjI83nGyU3ulFzHFatSXHW18CbrBnlPnmFDPWbktOYhNMEAwi
         KrNe3jX1CqABUeAnMuhyUNuryboqcL/yCUlCqftQyk3PlJRNj5JO07lQmDJI4qMtowXR
         2PBxdU/b7LQ/6KekcKdUWk3UZnFvL8eGun5Sc9pbHSR3SZ/ZfGflWBI3oOgL1HRxtlm0
         4+iwR1AcXnT4vzm08BA5aQ6gUZFvkwV1VHD6OCyNpoIE9HCedetywbv9HmsKPxscJW+6
         6smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305717; x=1756910517;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6vIrA2DQOHDf/Q4IwHsVjkoNuFaBasbd/XbLZkvLWE=;
        b=dUt60qDPoBFrPOu88Kk00jNjbYj6H2c5oidqYCLNIby4cVjQ3UXc0pcrWUC3HKs0ux
         diksuC+wDy45shJPIo9ySuUR1ERR48+DilUsq79ZXBASyfMWoORAmRWDr7TlpiiUCAI0
         aH+8ZfUlOX9UZtkSOLmAuqPHXByogEcYU7lmtzhxmbBJ011UfHVsxAhlbW+mrvWgf4Tf
         WO4am0FNJGFI5l2hACP4rx2xlkUtMJgKYUtMIBkKC5rZs4wbNKNI/NMYnfv75RLD9c6T
         kY9iC5aujlXXVUIw5bUhH3OwojgDM5vGmAX6eC4V5NFG4OwFo4Gd0bhmdxbKKsrCVNNf
         BWWg==
X-Forwarded-Encrypted: i=1; AJvYcCUp6HSJz89XUKnJ/HkT/+25fHBQCQq9QTggx3MCtUklfmMfaL3eV3RmE31bDiCMEbPCon1xqDDATw==@kvack.org
X-Gm-Message-State: AOJu0Yx5hw1HNHLfGZgysL6G9VD2SiJMv7aonLBy3+PWrEVfppkiba3+
	lw2b9n76SWHhyfq1bKrqTMYyToYdi09zGxU05/sjARZm/6H09EoxEceS
X-Gm-Gg: ASbGncuIM1DeEXshCiz1Qj2SRaIc09JOS+OkKWue+qoE8pSRemNEgBUb4pFLna9W3yY
	6pkDam/hlnlmF+VyO3a/PSZO6s3gSeD3vHkTosAvhEgtWSJtRt0f9nJ+pRgjKt5Pdw8tRlixe3w
	nYZRr/CMmqllrZqgQXnqWELQfPdxAOZSoOODPmFWaYYl9JJUDJye+R3Y2Z33JWbYeuKgIziw/ul
	HvmRGx7Ass4RNjC0fSxvjF5VQqXSehRafh6K8cGZgmgxgkP3yTkVV2/fqSJulwqFTrwd9FSu9s1
	Vhu/PX3gnXTHzQgkw3uNOTpH68DG9icZlmPQQ4ei3OLG2MPz4iPRd1OsO3KkgkxLTXXqJ9FjGwl
	N1BXgxOKQp0VymxcgaKQ5ZByf0WoV9dFdF2+j
X-Google-Smtp-Source: AGHT+IHcbfYShha277hCZP/20JeN5pm2jbLcLGas/E8ofVINO7+kU4+fWXoIZYlc3WgabQ8leZIlpA==
X-Received: by 2002:a17:906:7943:b0:ae3:b2b7:7f2f with SMTP id a640c23a62f3a-afe296e74c2mr1936528866b.40.1756305716610;
        Wed, 27 Aug 2025 07:41:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe87c2a0cesm617144766b.2.2025.08.27.07.41.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 07:41:56 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:41:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	vbabka@suse.cz, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
Message-ID: <20250827144155.5gen2cdhiauamr6p@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
 <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
 <20250827064352.o5vw3f332ptlemrg@master>
 <c3f5deea-4d42-4991-86b2-98d3de73afed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3f5deea-4d42-4991-86b2-98d3de73afed@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EF09180006
X-Stat-Signature: 8fchpf66w3hmsrpc9umh1hhzy1qbzmfx
X-HE-Tag: 1756305718-587776
X-HE-Meta: U2FsdGVkX189ekOB5TCL3sP5GH9BH1ptAAyuEaNNIJmSgqu1xyg/0qI7MZgMPY/PZUtNYmmwLBNld+i08488uKTHLzSrbIj8/Lze5hqA1tbLIoKCv3+G+y53J5WIMsNBFzfhuwR+LoF0UJu9dryuS1rJgntXnT4ZvvRw3/hwS6ErgZc/5nA0CeFd6lQqYYuJ+v71KGA7H9xqM5jtqaP9aaMrBDRuzfruV5bC5FAXqT4QF2iSTb1t2vFCqA/DBTEOnMsW993KNwZhNwFWpaFwDNWLXYqdPSjQsjEdRdLVxfmXqxq6EXbAofmZ4ZB4n7n1PATyHFiTqnkU+nZ3QrY7663yUsRFgUZlyhR6thiOS3iJOIrgoMtvnFIGwZ0qKfyhLroLf599d9fMOViAzhY2ekCEluYGmWtGEybawe6vQyhq48wQDHo9AmLCctodGOn5/luJVnzz57FUnD83iladT1q0qWAxWfQvteXODB2AnxmMibWBVzVhM0SMphGG0c2HeGLAJaiZURuPebQibh6O0k+WtaXde47TF+lRamOWq4dwj4FnUmPcdr5VNwdmG/LSkQNSG1LbMCFCZe+F3eJE1tpvmCFTqdQWUUA68Oe1EZ87eMDJwihRtoobcXHc1nSlFfmT3q7lUDk7wS0YjAj6ifHqlxpnlPXTEEBqfdVMCtRIKMyLNiCViZAqa4Le7EaS0C80ncTprXogmPW6UFJZ+MYO9MBZo+w7w67ossV4LNBAODgw0Kw9UFvRpylQtCPuiiUCxUEAhXL1Z2lKVjbEBYkl/EQlzqvvl9qHtckEi4uGEMMiFyJXPev3HQd6X2o1XYM0DP+gGPlOMlgknMXMnYZCSG9sZvM/VSwdjIf+nkLLRhHHWlTK10h21oCqXiAtfrnDWVMF/SaYxY06swaDlEx1rJPG0dqkhhCXkyskU2fPBHwsWVSz0X1qf1V8ejjs72xueM2e2uMNZRTu+Jv
 pUe4kbI4
 yHgTTJTzJDR43T9B3+dCI0RV3hPidlZocAB6vmWhM2KCIT9D4DuU6k0s1nrvvPmkHpbpjm2K4vZAyxDhGgLEp1jPwkZqp2GFP6MC8dtdtZUPXbs9yF3ztA9GuNjpPB4pWAoIXk3+pKYoiDa04pmUAW1iloBJDnA848HDlDEIixAI4l78Ndo19TiVoht9T17CZEPdk+2BejkcAtN9aoj08j5TdJyKDW2Wj92RgmFRfKpD8bX8Skr9yhE/iwJQ/Sh4gIjcwwUR+2Fq/aF+mC/c+iTmygfNcA5SlUKCQtoYcvtTFs0LhiS8DPy04f1SdC0qcwlSluqS+ZpeJj7wLv9AsTB5sKEFv8Va51x9aE9juCXPr56+Gr2e+yF7FMcYwB4OVqqPWbl7tF8RINUl0XZo0wIAI9DVg4dWzoPa6EgEJfyZkkY7Fedz09sVGu8O4RHOjwUYYmV1EohSVQZojO8BCL4jtf7uutN4Mpjbpw85aZp+fl4lT0IlkCZkrgQQfYPUKUJ0FSwEndR1miKfi6oT0LiNStYjeiu9nXMObQQm5MTC6oGp5D4fC+i8TW+UEbabTTQFcA8IYXc+GtgccSvZ4hTLmPfKCytVWv62/Jc2RySvFUIDM+c0QIvBqE1BsG2bABKH4EFn7yasd1byegwIFTWmnNoeoCIzquyWBGpV7j7IXzvMvbIYqnMwKV5kv6y8y4E9QTQODBu1xr+K8pu4NYyxwwnp+3zOpQalzb6WclDgQutSq30AVrIb2jQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:16:02AM +0200, David Hildenbrand wrote:
[...]
>> > > 
>> > >   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>> > > 
>> > > -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>> > > +#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)
>> > 
>> > I think David meant
>> > 
>> > #define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
>
>Yes :)
>
>> > 
>> 
>> Oops, I thinks you are right.
>
>It goes without saying: please test your patches before submitting ;)
>

To be honest, I tested before submitting. And I confused why I don't see
error.

Finally I found the reason is I don't set CONFIG_CMA... fortunate or
unfortunate...

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

