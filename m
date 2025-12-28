Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A66CE784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 13:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BEF6B009F; Sun, 28 Dec 2025 08:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49DB6B00A0; Sun, 28 Dec 2025 08:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900636B00A1; Sun, 28 Dec 2025 08:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE2C6B009F
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 08:30:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27BC78E25B
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 13:30:01 +0000 (UTC)
X-FDA: 84268963002.17.19FAC29
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id EDB644000F
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 13:29:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sw21qMHa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of sergei.shtylyov@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=sergei.shtylyov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766928599; a=rsa-sha256;
	cv=none;
	b=u3eaB7ZYhe6puyAEluUwdZvZiFeqhlxvNuctycH16dDE5WfhOrqlVHOLNE2KNRSCNO30tY
	L52sZGdrieYjLjarIFPSrjkgdD+7/5/DLGSoxMe3yUn3urkTS85I0svFNHpfCRdAPEQtGL
	EEpJRLeGYcsofN2qYi93F36EPOgiSAs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sw21qMHa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of sergei.shtylyov@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=sergei.shtylyov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766928599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lWyQqsYJqWc7lm9cTjRQLwXSVE/IuAz3ei2okz3340=;
	b=8lgC0j0SRdeDXZJScrAjUqBIOlHM914VybxCLhgIAX61xJsqKRC2z1eGyQYOHHSUYRqVdF
	TAmVTxlH1evfmKXHUJHnsExNFPQYLMNciJINjC1uNTZfbkJ7tZk3uMjRlaxbPsOplHVoK9
	POmrK/iTs/H1SZR5acYvmNC3doViVck=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-598f8136a24so9403983e87.3
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 05:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766928597; x=1767533397; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7lWyQqsYJqWc7lm9cTjRQLwXSVE/IuAz3ei2okz3340=;
        b=Sw21qMHac802RRnW1qIhM+0E+Sq84UioHj+qQoQDisyWyOKFh/i8hr0hzceXO7BHFW
         /EN+jbaNL1Hg4xVjqajvrpT8OKjINSjh4sPz0uL8Xszx0ZhKAIrZDEO21SBn//pUoXyi
         BFCa7yjUeVay5ChvzGDFDn/SlY1Ax6nFuNao1iKdoCXmWdOBarp1UuR8IoN0MgEWX8z/
         aVw5qKYsnJPMW1q0ywguzPnE/SArGhVaZ8p6rKh5gcXgos6llTSJkBHnHdrnPkM3uhp3
         XeKTA7bBe86sQb4gI8WGrCq3PPSOYQPFZ+VDo8sdRyN9E0C6QGpKQkVgdY7d3aZ8a9yy
         FNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766928597; x=1767533397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7lWyQqsYJqWc7lm9cTjRQLwXSVE/IuAz3ei2okz3340=;
        b=U1qhlAZd0THyA5l2S05aAI95/jZutLfy54NMiSYWx5NOUV+s41lkyoyWGGwtpLc9vK
         WvZtxubPX39AhEtALNjhH3mO2pztT9QjytvmN1EuvcvdWtWq1tUCxsnj/KWumhIuE7NL
         PSSOMIAV6Qd3kpm0kOoOb1q3BBX4cg2aj2ucC0Qi0IFlf5M1ImPcvSc3i1S+fzmoFP+G
         kkI12lcf4QEKFpYjBvyRsm98Pc+DQl89xohyXTZ4pEsrR/jjWXMpfVtdxHj8+7cRGOUO
         ljpk57HPGDBVK+ge8NkmeFfQ56+aPEygc1WGDZUOimKbngr+yn6Vigm/olYOGzuAmdCl
         OCLA==
X-Forwarded-Encrypted: i=1; AJvYcCWSxPQoewKO6KWp3vW3sbXM85DIqJNYjw7YVfraZlAvV/EAaHOWj9ElMWNRRIv45x4+Q1q21Iq1jw==@kvack.org
X-Gm-Message-State: AOJu0Yz9ozoKnWvKHH6xK4sDIqB8UZov1nWUZ1Yma0rNujC2ir8J3Ss1
	xqxtcxkmVu+Vd35MMDpOkSjP43NQJWiCMrdG/H8PRQIfpqzvK0fdJpUT
X-Gm-Gg: AY/fxX6ukvQMEY8t1GkqWZR1ShHHBkvsGwCydbOkTKeFelyszen+rNgxbVVNzIXOz8C
	ql6OxfPjTscWK081k29hNHapjoQ8VfOKpVv/2jS7X8SRpm9/U8PhLSViiptSnbYk92VSrHUjCZl
	XpbiSK8W3h8/i4FDeBM4OOrb3V9dYWt4VBKS9uUVKhDNnoqQKFONGWkUBL4fNDdbODdtgEsKoXH
	qP+zQT87SDyrWXcN//ZLo1Iv14BPss5fOq7IZDKsDsS3Uts6wVT1ESYmaaOy97hPLdceNfJtdY2
	Qdpqyc/gIOqqj3F5DpO3kNeKD8jKyUkEJX68wp6EIvIyHVPOeoMxzqbzHY06q9NP0V6VkpuuZDm
	deS9PbSWgHBkTeUQ6nuHvyau5ueSjUHokE3tiBuWQPC6+/hdGVE9NrgyaRx2yYpUAIAD2m41q0H
	pEgLy331mYUMrYp9lBYNRHhGyAzT1/AdkMOOB2/0zxT3qfeIravbSeFW8h44+/SZ+gcG34kpGdT
	DSuMeVw
X-Google-Smtp-Source: AGHT+IGo/pr+AQ2VNaaG2TyhewLh2BG0nsRAoXdF/d33J1EZZvYOr8FxE2Re2WZCgj4kGCoIAYrr8g==
X-Received: by 2002:a05:6512:3b0c:b0:59a:11b2:2c08 with SMTP id 2adb3069b0e04-59a17dd5fb7mr9312428e87.43.1766928596662;
        Sun, 28 Dec 2025 05:29:56 -0800 (PST)
Received: from ?IPV6:2a00:1fa0:425c:b771:d34f:d055:3147:bcd9? ([2a00:1fa0:425c:b771:d34f:d055:3147:bcd9])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185d602fsm8238417e87.11.2025.12.28.05.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Dec 2025 05:29:55 -0800 (PST)
Message-ID: <d58d6cfa-d9d1-47fd-91e4-533756f3b3bd@gmail.com>
Date: Sun, 28 Dec 2025 16:29:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/28] x86: don't reserve hugetlb memory in setup_arch()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Stafford Horne <shorne@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20251228124001.3624742-1-rppt@kernel.org>
 <20251228124001.3624742-26-rppt@kernel.org>
Content-Language: en-US
From: Sergey Shtylyov <sergei.shtylyov@gmail.com>
In-Reply-To: <20251228124001.3624742-26-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EDB644000F
X-Rspamd-Server: rspam03
X-Stat-Signature: uiqhpw5onm6qhw7ist1bn17qsi59rf9j
X-Rspam-User: 
X-HE-Tag: 1766928598-588602
X-HE-Meta: U2FsdGVkX19coX0sX6XFawWtTyVjwu4XiTe17SKS3721Yx4pBKKWX4TohtWuA1aeljRRthl6Sx4UCd04A/tJvUMwKi97uKy71OiniNIHun6FXW8mvUx5787S9l3Uvc4ixG/nnEJz3ZU/KSZlhEe4hcy2BVzuKF4Q9P01Wo5exhH6o/sNQiCJl3E4W7banQGMwtPFCLZCvIOp4yQg9N6SW5I6arB5lUsnTHhAx8atQRRvH5d/feYyi31gtTy5NJLfLM3kpW+toFT0s4zO0F4wkrWJm+fzcgrucH+ML2KSBjGSHsSwE1AfFFH4Hf1IDIxsoxBs8jtlj6nAOcUIjvhcIC+TjxH6yiRYN9tYbacb8BOBU81AScdw4euHbkFx6c6WFiyJu8o/To+dt7l4KltY4J63DOBSH8sCY0SUF70JOJNM7+D2yEAH3vb6n37y8WyeI/GSh1WmXrrmahjrIAI5qHqjQf/xNY8BSah3X4lMWL8krd127pJWKmknJFCmtqjflmmzsJrMARlcRCZjOl0CkL5tWYVVJRbdTxeh981Xgv3Xc7g5CHreKrK0m1cANLHkYwLNVjrmGphwhtIK58rd5E9rg0XTDq0HvSvVoLVEivW5Kmn19OOjUOcQGrGX+O1OUkHm20gCtu41EklYdphmUWvaRg7twPjwWVRvC2RxJ0BTctyJNDMbI9YRmowNCF0Yhq7M4DURq5GwlV0VnuHvfS+7nUAR0lujphsZ8yjxYRN7QJaoGQjA3DZ+GTwvsj3ersM+E+iGheK1IWaZMx2wMSYXxeKy4jY6w2nQ5Serah6Qhbp5dk+CqjGL0iCmuRHUkXdYmp5mbd4uuOh5iBk3cdrF3tRbQgiIjxjWNKH6uUns/a5rmYSZ2qJeROmZlxBkuAcTjnsmzU135334r0MDPLzN7TF5upKcigdsTzDnQQoNexKp3lG86vjTizdx4OyK4MaoUlU9xYLXdaf87Dh
 ccJLmfUd
 OIICnn0+tZKslI0DmfrEP2l+37OhaiqHacDblmP3itEgu1DcjD8yUc1CheGmMybO0guSDumMjwS6gAppWGqNt94AgnDZ4fxiYxDmDfI4t1XpK/sJZD8W+V1tdf/+bsZm2xHCTtTHAH8+0kH8I5GBZI3Z7059XSE4z41mwgxOFQH1o4FHyvOhNqYKE+qlBsBZsOstFi+ewU1fcZB43TZoj+RE+NigMu7A92hrIWgWkhX6Q9gvBlgnIn17n8hblepFE4f9skhpLi81Ds1kwhDH9VnGjnUTO2BHiW/iTZ8FMHkWk1nPsinkGjxLdnBrnD4L8cNmQ/9ySL3TO3amj2eblLThBYLbqf4/7g6v3ENa5dtIS1vQfpT6dz7UX1DHbdoZ6cCpSnW0JNgV6F/xm7PZUeEcCX0NBABGI3ksYdu7Jj9iHMUkOxk0iA3BsB5l9j+e3wDMXJIKDC0eoOOGXpH3gMsYns+mDkNZ7vZre0b6bwuHjtqllpkVonRQui+RYLcC7lDLCB0XB/Ld/+T+jOVPhL7E35TB7DbcLsoa62alkJuEVCJUgvhG8a7VM5HT1ua/DAllusea8W3GwgiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/28/25 3:39 PM, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Commit 665eaf313314 ("x86/setup: call hugetlb_bootmem_alloc early")
> added an early call to hugetlb_bootmem_alloc() to setup_arch() to allow
> HVO style pre-initialization of vmemmap on x86.
> 
> With the ordering of hugetlb reservation vs memory map initiaization
> sorted out in core MM this no longer needs to be an architecture specific
> quirk.
> 
> Drop the call to hugetlb_bootmem_alloc() from x86::setup_arch().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/kernel/setup.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 1b2edd07a3e1..e2318fa9b1bb 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1191,7 +1191,6 @@ void __init setup_arch(char **cmdline_p)
>  
>  	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
>  		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
> -		hugetlb_bootmem_alloc();
>  	}

   You need to drop {} now, no? But seeing that this *if* gets dropped
altogether in the next patch, you may as well ignore me... :-)

[...]

MBR, Sergey


