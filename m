Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95492D10381
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 12:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFFC6B0022; Wed, 26 Nov 2025 07:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487BB6B0023; Wed, 26 Nov 2025 07:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A41C6B0026; Wed, 26 Nov 2025 07:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2948F6B0022
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:15:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B86C2C05A0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:15:37 +0000 (UTC)
X-FDA: 84152653914.14.EF8524B
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 946A6C0019
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:15:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PHcX5BlD;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764159335;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CmYl+SbsPMRI8iRq/pAxBRo1VZNLGn0qzoX7EmgTSA=;
	b=qqwvQrWjW/wib0Ys0/xmk5IFrRP8XPyLjCj+RjXrczamNb3pB9uW9bAelw87R8ZDd6AZcD
	6kh6qCbsYCd68e1HELQ4q2D6oT3Zyf4hShdjI37Vpg6YpYxj3kR5WhDPmlQ6jpRAPU9y8m
	RoTJ4BcRwGIOMRnLsQ3nXBD5N0L1/QQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764159335; a=rsa-sha256;
	cv=none;
	b=QcFqDziuCdBqGjniQr2C4mW5sB1aHZJSoXhPVvUjqXwHwCcBXiA1rHGQ+V0WEHSliQ1qKj
	34n1uNVN6FbTARR0IKrH54cMIvFa2lj/SzREzBZ+gRV6yYVv6cQJcgXP+QYRFeSmOxAVVP
	bJ7eXJB8T2fscWQ71ssYpZLz4wFu4TQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PHcX5BlD;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b73545723ebso1260721666b.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764159334; x=1764764134; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CmYl+SbsPMRI8iRq/pAxBRo1VZNLGn0qzoX7EmgTSA=;
        b=PHcX5BlDI4bQe0cVUlnth2ax2Y814C8SBHHCPsiGD7aRCPECPjNSFmkZPPzgOMWHRi
         I4gWOIMw5exIV/ZRfi7y3Q6GhAQTt2KaHTy+bgLOJFS+ILQTq9W1TcOG9e2FfppQYGtH
         Na8Fex+aZCVMKtOP6iLCmsSVXcUMbpnEs7yL5MegwuhllbkDPuewXO7+JdT4bgKoRz3A
         i1dPLyVFcnT8GW6UTc/Gu77CARkPHd9g3XafZGQ16D28Y8eit1yIyYKlI5/8CAqaz1bP
         JA0wmo9d1iaG1Gyhi1WrZj+0q1Rm3BHgHPBAtFYX+VeiRh9h4wS3AXGAd0hkrKv2ezhs
         yzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764159334; x=1764764134;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8CmYl+SbsPMRI8iRq/pAxBRo1VZNLGn0qzoX7EmgTSA=;
        b=L1ps2exYSOwXB4coZieWFvzbsvRUJpGWEotbbufZdDisSCdtIaYSRaKNPKnHJGS8FG
         w3nxAkGzkTpefmOOiVB9iDKQ8cFUQcCW2CgpCaUmyckqTSipxlb8VFKjvvKpa/DhlRHy
         oOukHPaXYkOF7z1mQ2ABnhCU3EVpDauFROPDbpwSXFhVmbhNdfnuDWNGf4QtzjRu8NNx
         6V0N6ECHPtde6rL+iK4JZUWnIY4chZER4BRZtfHmwiov0km33wivZaIUo87iFPhx5rUS
         urrWvI/KyrL8vxn0cissbTZnJCLypsPvP74MM7Zp88ckZAXL3kFVMS+iBy8GVHqDlkQ0
         ayuw==
X-Forwarded-Encrypted: i=1; AJvYcCX+f8KHQYjvObX8vjtjmzXp7q562vHT7n5OXzZTouM2EJsKEOdsaenGLvWT/RLxq1KDs4qNsxltnw==@kvack.org
X-Gm-Message-State: AOJu0YwCjc1Rz3nMSbW8q6FmxsoOnzo14D+tAzJeYM3nTGWJKBN2N+EP
	KCiuIZ3pu72WVhEOuR1xzB+BB9R3doY2GFyg7sFW421KvrYZVW49Z/SU
X-Gm-Gg: ASbGncsOZBREe0LGS2uRrh/jmBLftnmrW3fr4+nomJ/2LrHa3x20dDPB/uyR+XCvZwI
	OQ7clGHty051T84JrDHpablTkrIgwfJsjkQrh9rzcGp6LtvFAevi42vg/9usLv7wkuUxFWgPr27
	ntW5V5FS84WR7wFMotz2HO3Ba3PGv32nH9QVt4wzBzRFs6dX4dr7yHWeWV+6Ud3e6uclN68SvS3
	XAp4Ttk1+DHr/Pi7G1xi6HvP/wZgbwCkvhUq7ebOMwODAoUfeDFOiEVUUiZ7mnb3BqfCWRWkgfB
	O1OcRTy9J2uK9y7gVyZPjCdJDOzoF7/fdj5V/2a8cPXVpcLjAF9Fm0RO3/HMvk0BlRVQt8XvwIW
	frmnHpxuRtIoyojK3YvQK1HHE/GSzwmoT7l+EjhuDDy/zlwhM50VLZQl9KB/Df/aVtIDqfU2tMP
	zduAPtDkt7yQ==
X-Google-Smtp-Source: AGHT+IFl0xNssyCKj5lSL919bRx5nck4/bkzdmCvQ44NH/BqDNyKr8lioAfBzAxQJ2AbX3Tr1D/ZxA==
X-Received: by 2002:a17:907:7f27:b0:b73:845f:4432 with SMTP id a640c23a62f3a-b7671a4690bmr1926029666b.32.1764159333528;
        Wed, 26 Nov 2025 04:15:33 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b766d386665sm1561263066b.53.2025.11.26.04.15.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Nov 2025 04:15:33 -0800 (PST)
Date: Wed, 26 Nov 2025 12:15:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use standard page table accessors
Message-ID: <20251126121532.tfwnlyaemak6qtb2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <9c32675d-c48d-405f-a38f-4c90a8edac74@kernel.org>
 <20251126100330.n66n3uvt3junflao@master>
 <16ae0a30-c6ee-40ad-98c8-ee6f4713e653@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16ae0a30-c6ee-40ad-98c8-ee6f4713e653@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 946A6C0019
X-Stat-Signature: zdaotnqdaixeyq3d4j6uw4sjbqb6p5wh
X-HE-Tag: 1764159335-874763
X-HE-Meta: U2FsdGVkX19TbMukyNoXu4p+BWI7vcih7aZW5+R7NDv/zHCW/UpdPl46TryT2R0j9iqEfe1VjzAaCdSKJJteY/msIGa055ox47xVJ3jYeVXHKEVC0+r3yj36A3tOsjtwjHvR+r+idLCVJVf0zVE+jbcasGjmHkbMGnDCv0AG4ksEIzTgcuGbrBGBi834fdnkDuS6u/7/MODpHHw3y4aGKDzKa5K5rmAIj+q11KGaPkf5GjN9ROf97cncFE/3zaw4BkFedk3bKF5gjKcM3zUbkM4w8i9RIC9U541Rg4FHRpa4vcgRXceaT06RvN2RU8gkoLM6jRYUk9C8EOfKjJwNr+VGLTrS2YoprYC55h0QkBQIXlXkfkSPlE56GfpNJUHxn4RMnAuVnwp+zCkdBHhbrSk7MZ4J7U2mOSkIZp+GGajsQD05wMe+iMW8rVMMO59C8W7rDWKA/NTA++GOo9OqsEz+YtEevvXueOuAquhfLksPfz/2yPuG+uZ2Na/CWoX/LlMqWXzVN3y6VfIXO621BgIU8oX6uc1Ih2hM198cd28iiwC59cxueA69cWpwb+dXQsIdVZB+XzgNVXyq3yvNFk4DMQE+7EuE/uDuTDwR7g62Sp/s8YXx7MFjNLFbqPAC40q6zBYaE3tiLwJ2k2lUfGDavjujVoqAvDfcmIZwDRaAwfjfdtwdZ342BQJn5uHOrtu/hdQxJ0PIrmfo/6n72V7a9wQYwvHP78PO+CAtC3nUvIZH0Jn7ALRJ094zTzJ1Rwl262ZYMgv1dTBWuotvLTnmR9fMxWoIR1RNYeU6uejh4pgfAJqzRsFqty9nXdOB++bIlZPxtq2GxNWNGXagFQmSJ16UR1u1HkaoU6lBVf+G/93//EvirYmGWFZ3+8q7j/HHM9ri/rBXDXaUTzWsw1r6+rfzfg2bNUwLs1v+UIJJ+nSgswYH6KFqLoI9uXe/gwhsE9yuoM4W7ntYcIC
 nIFBXOot
 7U57yb3jA4uk81xE6kLbBcFS48RQo7NGTN6jyk49gpNYHR84pp9le7dsHFk7msUF1bTuXbJ+Pen1rToi/78toWpZ2el7YUUwXoUO3nP/f3SyNsnsf6wkH4iYgNyHi9vS9n4i2yAV86uHBN2i4/Pb5zhfZqih74aOnoM2XEwmUEx2mNKr4XFQry02p4tpZyQvOQdM+zXyy4nbtPArIdHCtc/Y0heyIepdsCH/syTEbcjeSWofkUqSStZr+1Xhh0MLsfD5MqG4rkX11uF3nl6sc/HLmnZj1mQShHzQ/kJBLA/cLVXVoab9dFYBOFvbplcd9LVBynU0qXNHGK/zFkHIN3ckMFuInhk+qJeetL52hWEbBdi80XxAsLmU2qOGI14WR2VoxcwgEoHhrYEyQ1Ge/C9zmZgOPqEz+PuCGrwNVLxhohhL4ZXZn+aI4RVwecGnwuPQiYmwCzzselFZ+CqlfjYYIkOI5oJSKPoFjnvzOjHdwtUsRyUBEOpQLk5BtWDplEcRs9wx5NVYizAx5i0vvgHt/okUAjAuK2oJBEgUtScW/zS1qK37z4rC17G4HBA7WOXys1cUvZ2IKX9LF5tCIg0kTYburT+xvfYfwwH5Mvxgq3hSl+gz8P4tlBzl1NyE6GGywXjJ9NBB3dqNyhEUF1f5hKh7+PrjaRFXCEQ1liV1Wx5yU36pNPyDMNHFK6GJZSFovh9KoRWOIEzrb9YNLpFLi1GlKeyE62iX1bAlNS00llFil2NOF+NmBjOVFvXL/DkrsgVfQPlF5eRnB8+WKCQj0c56vS4tiFvfE+wkY4xDu4WRM5Cjbs5taZuWMoujuUJpYzX9IxeZELXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:28:37AM +0100, Christophe Leroy (CS GROUP) wrote:
>
>
>Le 26/11/2025 à 11:03, Wei Yang a écrit :
>> On Wed, Nov 26, 2025 at 09:15:24AM +0100, Christophe Leroy (CS GROUP) wrote:
>> > 
>> > 
>> > Le 26/11/2025 à 07:47, Wei Yang a écrit :
>> > > Use standard page table accessors i.e pxdp_get() to get the value of
>> > > pxdp.
>> > 
>> > Please provide more detail of why you want to do that and how you are sure it
>> > doesn't break existing implementation.
>> > 
>> > There was similar tentative in the past already which proved to give
>> > suboptimal results, see discussion here:
>> > 
>> > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2Ff40ea8bf-0862-41a7-af19-70bfbd838568%40csgroup.eu%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C63a7608567de4df0a16308de2cd31076%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638997482180349327%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=ly4LRRjkKqQNBY6ZpkbHS7%2B0xuu2c1r0op1eysPtbSQ%3D&reserved=0
>> 
>> Interesting.
>> 
>> The reason is P4D/PUD/PMD on PPC32 actually just has PGD/PMD. So it is not
>> necessary to retrieve P4D and PUD.
>
>More exactly, PPC32 just has PGD and PTE, no PMD either:
>
>arch/powerpc/include/asm/book3s/32/pgtable.h:#include
><asm-generic/pgtable-nopmd.h>
>arch/powerpc/include/asm/nohash/32/pgtable.h:#include
><asm-generic/pgtable-nopmd.h>
>
>
>> 
>> If this is the case, sounds other platform with less pagetable level would be
>> affected too.
>
>Indeed.
>
>> 
>> And this looks only affect when we walk the pagetable from pgd. If we just
>> iterating pmd/pte, we won't have this issue, right?
>
>Maybe. I have not looked at your changes in details, it just lit up a memory
>in my mind.
>

Thanks for noticing me this, I learned a lesson from you :-)

>Christophe

-- 
Wei Yang
Help you, Help me

