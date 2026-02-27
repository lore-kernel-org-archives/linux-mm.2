Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E076FEFB48
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19A76B0005; Fri, 27 Feb 2026 07:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC79E6B0088; Fri, 27 Feb 2026 07:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3426B0089; Fri, 27 Feb 2026 07:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 853FD6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:27:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E098C23DC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:27:38 +0000 (UTC)
X-FDA: 84490162596.19.D70E601
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69720140004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:27:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BP4naFIt;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772195256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBCa2Iq0/hu0sJwRb681qcL3bM1nOatkl9qB4gJ48xY=;
	b=rfN0ZokF4wWE5KFav+P6/bgbO0n+1akU6Om7LPiK6XiEnLxOdfJB0lNUsafuwbRXbUYo88
	PQpBMYh4gtJhUWnTlacP1QGTWFmGQjS3o6+Np1zkbOw88q6Evmy1v+q2faGks7GGFAz/At
	dQ6xnS3vas4UeJOqjEjY3z6R9nDdGog=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BP4naFIt;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772195256; a=rsa-sha256;
	cv=none;
	b=KNV5A618HJ+CSB6kOnw2WdMSuz03WFOQyoHAY8/YA7DJyEZd2cFc9tj3U1VPrBOIt6aE5N
	Mq/L4+JwAf2KctefIyS75oBxVvv05ruETImnujZHKMyx3TezWMGZZqW2pr5lq3/EOcOBUm
	oXc23QftqOZVRrLYF0NLmFbt18P5raE=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-824b5f015bcso2354406b3a.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772195255; x=1772800055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBCa2Iq0/hu0sJwRb681qcL3bM1nOatkl9qB4gJ48xY=;
        b=BP4naFItfTKW5Ua/V63Gxa35mgF2x+dBf7g0jId+CnrZWTKfSjkQQ7GvoOJZBGQemr
         Ue+AuipbTpcf0eFLCA8gN16/iH0epEVQQEw1TTkbRAunhw7UwxuK1FLS8SsdyBSj1ayR
         4/ME9xCPslQtdrpxmAXC/6lM4bQV4mdJO/GNpAc2nljd9ffb+EHWeJXjLyI6Cx7aeC3a
         78UDlWkYH8MOoUXr/YEQSQqsyKVNYHAWg57Yi45VIeCjN5jWO0qRbBkHAFcqNO4xfdax
         pyWr51PRAbK82RzlyCX4z6Y66sP2X6b4R7t43Q8hafbw1Y1BwMJvvAV2Dep7Blk1J7dk
         WOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772195255; x=1772800055;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BBCa2Iq0/hu0sJwRb681qcL3bM1nOatkl9qB4gJ48xY=;
        b=MbVa5vT1uXHCjRdQuER6Kc9tP/UNO2NSRzqntBvvVekoJOwaHlWHXpbbTOV5IE1rlT
         jL/duAjt7OKrX/XSDR/TerapqaRUPpvtxWFaV7fG9DYQoEuM0D7+EF0eJO2YdLWZcpZ0
         5gwtrst8PYFtmUE2pu1khXc4ZkP8PjzxJQ8z6MMA5xmvMnAhbrAQe79VM5BxtgCnwIbH
         FrJhHBSCAw0hoMhvDhw4NOJKiWxmLxKssrfBh9OtgW2kTTkAMa3qf13v5M6AM3CeSkT+
         xuPSzEJ73ns9dxzOmfW9WFRpqzKBbCxJNqM8lIs0yjkAzUhq0kbQX+si6yFk4Lj6sm5l
         VEmA==
X-Gm-Message-State: AOJu0YxExjGLLbuMlw1KSzNdqBSlLxMQkndI8+Ahnfod0u2gcZJx6sAZ
	11Xw+9tfGdUV8YYNn0SNKTUZYdAdTNYj5Yj5s8dybRFaJ+Ku9O1vtV+b
X-Gm-Gg: ATEYQzyIIQNVaLSxRNmxs8cQVpMbspBwuiizuoOOb6NcOCSZQKdCfmh199oTqd0ycuQ
	8K6eUajirth6yS6/L4bPH8l+hIfmN8/jD4kSx5M10CXbspLNcKTUA3Qy6pH4x5z1ZStD7x4K6VG
	U83eQvZBaPBeHsChPSbxZz4meyqImRn5iYtHeBe91KT2wwDxEU++hg4nHtYnDYHC1Ah7kqr6mrt
	9YDzrvld6DwBTM0Nxd1Q7DuHLQ/PqiShBxcURAvEf/prZz+dVMCZ/pSUapRbmSFU3sOGsRPEu8V
	TuAqULQ5Rsw7bP6IYQ9n+4pBgjsaXFTQXSy2919DLJ+KXzIALDh/x0w9pP4BYzfmQirhXcwXG3r
	pawWoowRVd4j5g0gc9Zc+YzAsRGhN35C9XBFz88CCLGqCmxsnWHoiYk9uoZbPUNyBcxGaMDoud7
	cXE0BlraR1WY+shnFOZQ==
X-Received: by 2002:a05:6a00:4c81:b0:81f:3ae9:3f71 with SMTP id d2e1a72fcca58-8274d9d0704mr2242350b3a.28.1772195255179;
        Fri, 27 Feb 2026 04:27:35 -0800 (PST)
Received: from dw-tp ([203.81.240.187])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff1c9esm5479908b3a.32.2026.02.27.04.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 04:27:34 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [RFC v1 2/2] powerpc/64s: Add support for huge pfnmaps
In-Reply-To: <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
Date: Fri, 27 Feb 2026 16:02:25 +0530
Message-ID: <87pl5qh3ye.ritesh.list@gmail.com>
References: <0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list@gmail.com> <d159058a45ac5e225f2e64cc7c8bbbd1583e51f3.1772170860.git.ritesh.list@gmail.com> <abfbe83b-23fb-400d-9069-b8bf4ad21d95@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69720140004
X-Stat-Signature: 9bzsej5j7hixbrwyzx9u5objjcgo8x6g
X-HE-Tag: 1772195256-576570
X-HE-Meta: U2FsdGVkX1/GKdCFjQ/aNjwjWXWTSYmVA+M2AsQJHSQyG5wqDu+RNd0lpgwGyns9E6oc9GVX8Gs35YxZN/1fQndF222mI4cdk54MgPxQZv4jZcst5KPj2iu1Lpi2FGz386V/PCaz+SDp5DxJMOcJoBe+ngc3Ocz/nmhn3v2JZmFcFdAhjTIEdeMizzXL6ZEg9G8Fk/0J8+0SW2WTUKrBdfIuvC2KmmFW8ZmSHIW8y6ow0orCKtoHjAwXmNuDEaLwN6Ap9tnAOA1yhWIBI4AaBpBXQngBp+s4lfh8SisIjEQlLKyXCDl3hoQKSng/8KU9qsP/Ev03msbjnPWbquNKuJsEt2LGEH3ET/TXMo0UyA3rh3QT+T93tsoY/HkAxwQfRo0C4qpxVI4jQb+aBMSoTcnydemM/QCXt6bVkld4/MHkQrtQYy2IP9yAumiEQD3toPC/qq5W7wM76nNbR83F9OVjYc9TOIeNiQc5mv62S/wgLyNcLDGxBu7XuGn12CLZ/pA6ZoxK3lmJtrBJENxpn09taMLAOxPeofnTf9Wau/zKNlxXlDzjwbe2yD+fqsHZ+rUQ6QCNElcHAGNGk8EtwztQYrkM/wNibn3Slmn4//UQuthPl6/P2IOriRDiU9Nee0v0I+SOz9WpbBqzAPbpqIMKTHYqe1kGDoHx1yZQY8JEMkiONKJyIx/XeQciMcITofrATqloJPeiwG0jwGRhiXxLo0xT0xm/Hl3TiOhI+DtJM7FB0GAuqvmRtE7bWqbXQnmVKyBvgxABvHGNaBbmJXvQbOw4st6/sf8GYgr3x/w0GVIR7jQUwnI6iiXJM/O66NVhvfUk5xdbldqqjcQ9ZdR/hfQvIOoU/83EmIiVwlDUQk8oQ7fuyjIeQyCrAJYVpVow5Z9916xBd6sbSzUw/f5sz56mUiWS8uJYM/4uhhp0nU7WnhCdlGR5nWDWbS3eeHAeYnEy92Tji2PAhZB
 Yvwo7ZrJ
 sL/fUB9B88Wx9b0Wuk9xpT6ID0vPKzS9lSGxJDVgLVFrBXadbjPDQBQhsGNlA68yPzTpYszLebpHMLTWGoyFgiSjocLOIOkQ1V36R48Hl1V4IHGWMfkVaAoiQpi4e5c5CsfTNuaPXFGw9SFYICcHHw/DAHPb2InD5KGtvjWKwoUMKb8OwilHTx9+c0p4hVqAux0W8vpqV1OKDw5IrcuZ1gIz67alwTzg6IZ6bSGH6ubx60KBgPAJHwOFzTbwDHkslr668vnAXZ9FNOy5HoTzsMlxix77Eifqt3lmPHcnNUyaV9krBor8lcZyJNUwKax6oz+w6SA4PpwBOAQCk+somD+eZfso0qhlsJe9qPFuPydQT4PdMWhCLeJ+A/UxKC6boVcWHINgx9OunU/0WHoKKU150nEqCImhz7Wgve4NzhmMG89VYaVAusYnwvLSPmITs0LRXvrUwg3eHqQTUS4Sk/Uo7Mg1jRUotxhyzEeiLAtu40aVgrmR9Zr094nSk7zVkw7Fj6uroMZl7MvFLt4rTMktmnv8qZ1CmfOZ9UpXLrmlNMxzheGgsfwJQSCwu4zfYyo6qRYi75+ccoQiG9OS5PKhzO+Ju0PNaMZ/0xZtFcBGkqhbhq9OGbITosw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 27/02/2026 à 07:16, Ritesh Harjani (IBM) a écrit :
>> This uses _RPAGE_SW2 bit for the PMD and PUDs similar to PTEs.
>> This also adds support for {pte,pmd,pud}_pgprot helpers needed for
>> follow_pfnmap APIs.
>> 
>> This allows us to extend the PFN mappings, e.g. PCI MMIO bars where
>> it can grow as large as 8GB or even bigger, to map at PMD / PUD level.
>> VFIO PCI core driver already supports fault handling at PMD / PUD level
>> for more efficient BAR mappings.
>> 
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>
>

Thanks for the review!

>>   #define __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
>>   extern int pmdp_set_access_flags(struct vm_area_struct *vma,
>> diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
>> index dcd3a88caaf6..2d27cb1c2334 100644
>> --- a/arch/powerpc/include/asm/pgtable.h
>> +++ b/arch/powerpc/include/asm/pgtable.h
>> @@ -63,6 +63,18 @@ static inline pgprot_t pte_pgprot(pte_t pte)
>>   	return __pgprot(pte_flags);
>>   }
>> 
>> +#define pmd_pgprot pmd_pgprot
>> +static inline pgprot_t pmd_pgprot(pmd_t pmd)
>> +{
>> +	return pte_pgprot(pmd_pte(pmd));
>> +}
>> +
>> +#define pud_pgprot pud_pgprot
>> +static inline pgprot_t pud_pgprot(pud_t pud)
>> +{
>> +	return pte_pgprot(pud_pte(pud));
>> +}
>> +

In v2 - I will add above under #ifdef CONFIG_PPC_BOOK3S_64 
to avoid build issues with 32-bit PPC.

-ritesh

