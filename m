Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C0E606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JOpmQDys
Received: by kanga.kvack.org (Postfix)
	id C817A6B05B0; Wed, 11 Nov 2026 11:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31E96B05B5; Wed, 11 Nov 2026 11:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21D56B05B6; Wed, 11 Nov 2026 11:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48BBA6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C32F8A031A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:25 +0000 (UTC)
X-FDA: 85423436490.18.FD7C3E5
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id CEF2CC0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:54:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JOpmQDys;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794416063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0NO6skQHrEQV9uToLezs2xtI4SoBkJ0aZ39MACRQvg=;
	b=iZJiKAHHpRosLT8KA8AlVHEkaNt3V/RZuXM4X0tEZNJGe9RQ8VC+V0EGp1gQmKB7Za9KqX
	6GezJieXU5ISIkm7YW36+czFWJTOsxqmyZWWzpmcFzhcjOzRR1cBIrhXcaOieAsm6qw90t
	eipCCElM1Pf9Sm8eOLnv+otHL59+nLg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794416063;
	b=F62jmxUMpZsPeFwn3Rz8EHTUlOb9YNYeET5d2Yi/rX0MKiHdbmY2mPH+gH7g2Mi0oNTGE5
	2UONX3WR8I7Ts2ilsSCVoxVWzILiQ3ElT9DqyYfKf/rtj7wJab21n/XFmHE5R4L0u8M7pX
	R7U1poVAx4bL5iY+FQ2j9WvG1zwS/MQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JOpmQDys;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a208d93758so36384195e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794416062; x=1795020862; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D0NO6skQHrEQV9uToLezs2xtI4SoBkJ0aZ39MACRQvg=;
        b=JOpmQDysaQEyEMmnqYvGbYsOh6zBM6fii/3rCzt3OtJp1ywagyewjtidjhSdm6yyXb
         4XJckHUrX2mZ8gaiNR+m8qhzoA2xT1wWaxHGj1mWW36J2IciiArY3GSoEOHFe0lFgywI
         YBfIAz/zdPFrlAm+Ji3lzT5zFJElU4DKc0BOL1YX5mK2vCOZuw0WfkAevsWAEsN0uvbk
         kc7YqobAqe5pYn5NPotyEZ0JF/0lfaVbMFZnwIXCp3dXwIRuRdNSE+Q7QwU/4k8WRBXh
         ZrFwULPzJVeF0bxJJItD2Dskqf8+DFsOcDAwHfpAG904JkD6iKpF8iv+gDAWz11y9KTe
         +xTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794416062; x=1795020862;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D0NO6skQHrEQV9uToLezs2xtI4SoBkJ0aZ39MACRQvg=;
        b=yPCEBJfnRoTfJNAJva0C34cSQZCDM3UNs0y8+We+AGDH1xHZ4xmbpwCRCvkDB6xlwL
         TqgQFbQ4mKzh51+HhoYw0ad5cVQE7p7nlN8jxhWQkX7RH0xUd5Oy1rX/kHBOqxmhIH+2
         l34Yc1gXd3J2ohe5BjH0kLpmReNOMCPmv3GhgaSSxfYah7MQ3JLr2Hy9o1ceAfcBvi/H
         iCR0j6RDxZR7NoXdPBwjeIkN0OHFI7QifdRKsrwE8R/Yl5XUtJJYIm9V5TB33CHCgV1i
         uXze+zB9xfB5Z9MZnZXA781cLkcyw+iecf1iwjkDhVm1c0KRmOenvaYFrdO9Ef0pNENO
         BYVA==
X-Forwarded-Encrypted: i=1; AL+hErF5YJDQJ3uKtT5dco6+7a1f8XOfUJpS+Fr1q5c77eLxG+F4DR6IT9SJEyR04I85UWt2z5Oy2L5jtQ==@kvack.org
X-Gm-Message-State: APuU4Z+h3MEvDRs+H9DDgpi4iN7YM9HtiQw2iiNpIXVhW195e6yQEvQp
	1MQbNaNXOjqZa3Uj8whmSM6PPMtA/Gqw78ex/CMVhVmGPSbUBtucGoR9
X-Gm-Gg: AYBFou2ahZ+T/YEZ4GzUU3WdZtgFP8IOYmQHneM2RgpvXf3SKQ9q8CUnrHN0R1yExdC
	RM8IOf9sLRdKMVQMPUdBHlw5lKGfPnZNVAbljGZX5XVumQtP/9CKxCO4mJWGoCE/540cYdZqFgm
	+LSv4PI4JWrrQnjXWacXe+DpVlSEtu7eu0lOCltn9HhLNwh9ktbmxh4a+FACn95dp/yQ/U/IrT5
	rwsxJtDakf6cOvoq9n0Gu5l+Sk3YGae3cpABpwPc3GQ4ymcwM0OfCnDp4BhfdvJIGHukMTpJlAS
	sWst10jsDVS6+7uCXTC6ssoywBFHDQ11Ax2XD87qHg+17WHS8ciId3TQPwEmvOFyIzdntEKnil4
	/xyuPfdCG5j1tGSFmfz4I8LeredmNmPIKXES9nCJpPSM6Nmc6Q7+yS85zHwaCMSJE6tehOp1taq
	PoRpUyjVK1Qe54xbDN4W/zvOaGqvJp6CxYgrPej1x74YV5zLELq1ejPV3k5pLsKgIbWGdyqY0Yn
	NH0zaZ7OYIijLpnb/QwOt4oodY96Aei8b3I0d/sUS4sGQob2uVxK7IaaWM3YZ4wneoyu1D/+R1h
	h7UcoIBGm0eJ8hIh/wvY1XQrjGCz5uNPN1zLIHLFG7AdaRwgCMnOKhgp9PnoHQYMtLdM
X-Received: by 2002:a05:600c:354a:b0:4ba:6d8:df8f with SMTP id 5b1f17b1804b1-4ba0936f447mr55057305e9.15.1794416062148;
        Wed, 11 Nov 2026 08:54:22 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498362eb158sm11708192f8f.36.2026.11.11.08.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:54:21 -0800 (PST)
Message-ID: <6a2c3f50-bce4-4214-8621-e0daa0637e91@gmail.com>
Date: Wed, 11 Nov 2026 17:54:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/huge_memory: don't warn when a page table blocks a
 huge pfn insert
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-4-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111140655.34281-4-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bofxcb4c5ghi551segc7hqw5byfaw9j1
X-Rspamd-Queue-Id: CEF2CC0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794416063-173188
X-HE-Meta: U2FsdGVkX1/XnoO0PoiMqkZIawvpEKB7WmYIgV5Itu7lLRMiLZbm7PPORLBPgoohy8ATV/g4KGcsVZkxfP/lvyv14/2A1DLOwRkKHMFdB8E70qbzhi87SZ3BZNYaDS0ypnXRXCDl6uJnj7P8cUz7MvRs330tYr6qwH1FvL3kjS5pdqaakWCD0FI9UoL7wg6/eYtWePnvrA6QGIKZuDZZ20ZUcjHx3X5xLi2Yszi6oVdlvtyoUGfP8F1y1R6iK+wVwKbXe7+6La7rmiFGUPJZc6ktLYJ34v3OiFe7a04yu/G/jXe7Xaf0ThewboZkBDNXV9OyEU8vG8Q8kryqq5h5t+9d2MKDIWnNaowcOFw5gBkUi2jS7RVCaNYd59+fTgWo3eyMdaAlQyDxCqc32SSrl1UiQFOrpdF9+gZkgxIuh0a6Ft9f0iU7NHR23E5dIzdAF3cYJCA2d4CbRXYYcgGiduwhmbyhYUensNLX90LCdEBqDASdtG4Yzi5ofFlPqkxWBSL+AejeZR42uVCuEToJ69edzsGvslW1CIk6B8PsOxoA9hppL2US+Bu6KX5bXgihSr77m5bISBsSnK5yWTHw/GB6b/UGdNfBzV78g6lI82Bffux2vRvcmX1Y0d0Mw0iO+3Mgt7XXKeLAkDOIhTVjL7FMrhPU23QGieHvghl4VEbJFxs5aOtukC18+uZBtar7wMPX5mU3eTInnlzF0ZjdlJOHaCFLu7JmbVBrHXcZyFCab777j2UfBWieHKJpbLkFUq/oAMbHTu8WLd9XIRNmu0DGrkhSEY5RnmWAWQZwOew28RCXFr8LjJNknLmBmNJbYF/Ll8/ApMoSxaW/LlpjndrMYkU7grU1afk6tqNds7l40H74M3I51qm4goVkK3THZve4Rt9z4jvSVNEQCzvxU0yiE+qH6HsVkbFnoGFwj6YHn5/ukV0MFF4gcf2IuQhAu/+61dvLc9BJJ0bP0/u
 7Yuoqb3w
 pYOOHD1br3oX/EbwK0xp7iTt7hVVlKfMbV7IOZIaIftwhgLg8fh418GTOYngDSAbUlzoocj/YhTU3cFy6JsmWN/WQMOP3+7lJJUE1yozNkuEfJaoIHOux6cyeT8mP+AmzkN4m6vZikB6WnHN/zmOBm3e9x/MBVYqBiwuNegREITyl6jUEsAk3qDDkJXywLsR8/HiYqNkG4gwrhApUZNdXU+NKB2eDHNVh6iSqc61gU8lyHoI5Zkrotk6f4CZ80Ywmjt1QFBQbdmZ0utmOAOX2YSEs3rQJQ9pIl63KckMdTLMI3BSteDzN47nA5A0VerMS1OvtFfvlsPKEkjxKV6M9Sr/WrmTpIXMhwjbETqP/0DymXdhtoRJf4NQqWGQs+mcWNv8TChKHjT56S3vq37LHsQbEtwTar1Iwg6nx8Zxv2wh36ZtijaF7ztYdLO0LnQBuRVA+tCzJZ8GXhHUYOHwOkcgnkPzcYohdnTIz3AwGO2Jddw06YQOeCBF8BEsryoBqbrwRrjwmEjjhTOBa8UXdkpSq0uo4IIqcjyn8RhDTeJZTS1B03zA3a+aGVIby1DBWnf5HkMRHPY27ix7xq/UuH1yPTh9TRvccRZB44BUo1ecFBvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 3:06 PM, Eliav Farber wrote:
> insert_pmd() and insert_pud() treat a non-empty entry at their own level
> as a leaf and compare its PFN against the one being inserted. A page
> table installed by a concurrent order-0 fault also makes the entry
> non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
> which never matches. insert_pmd() warns unless the entry is the huge
> zero PMD, and insert_pud() warns on any mismatch.
> 
> A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the
> mixed orders: an order-0 fault installs a page table over an address
> while a concurrent huge fault on the same address reaches insert_pmd().
> Changing an mm's THP policy while another thread faults the same PMD,
> for example with prctl(PR_SET_THP_DISABLE), is enough to do it.
> 
> Compare the PFN only for a leaf entry. A page table is not an error, so
> take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
> lets the access refault onto the smaller entry.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

