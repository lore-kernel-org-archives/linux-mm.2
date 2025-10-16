Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DBFCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8908E0025; Thu, 16 Oct 2025 15:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82238E0002; Thu, 16 Oct 2025 15:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B299D8E0025; Thu, 16 Oct 2025 15:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB298E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:26:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45FF313AB9B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:26:36 +0000 (UTC)
X-FDA: 84004959192.16.34AC4EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6216140004
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:26:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D2R1ZmEF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760642793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msR0ZBpYEHAnmAg4rddKbDGdznbasqHjFLWWxAmY12M=;
	b=gZTGh442XbaXKnN9H9k1/vMt5LA8qMF90IwxJT5e7cQVrIsErp56biF5addn5VxhUtmbk+
	EMjDNsmDKgz617o6aTvCBNy+XtV2aaazkXeBoM1iyNPmPt+nv8eZndriU3vzZVIcWeO/+J
	3bba7KHnYac4OFQ5t1Y7JbblT72+JnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760642794; a=rsa-sha256;
	cv=none;
	b=lLfk5H23wxbyB6MCdgN/cmG54KehLSWRb2K0tUq9CXftJvCcXnFBmZRILMLhX8fN6eMz+3
	Jf9jHJ0HAoPqPg0ikk9jRqRD25pljIuZjWg0WSH02tu0HKss8enHf64SKpBsiMMt9p4ys+
	SrObrCzvsjckVAZSsWtczheUJoGzouI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D2R1ZmEF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760642793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=msR0ZBpYEHAnmAg4rddKbDGdznbasqHjFLWWxAmY12M=;
	b=D2R1ZmEFRsuZ0fk4R6XDjLbi83xJxExxA1ZMJoT3nRswC1UXEPAwX5UnlsdNPvx0GsY4DK
	rUP2eN8zyBG/1xNMOPhvDHb9gTuVCM+HM629WQ8IXOrLZM1k0H2jEZOfSeOUF35uLKdkOt
	DmpouqCzBD6e2ZA5gjl0MGS4MgLYzBg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-NJDcKRL6MvqCe2cPalVZVA-1; Thu, 16 Oct 2025 15:26:31 -0400
X-MC-Unique: NJDcKRL6MvqCe2cPalVZVA-1
X-Mimecast-MFC-AGG-ID: NJDcKRL6MvqCe2cPalVZVA_1760642791
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso692873f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760642790; x=1761247590;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msR0ZBpYEHAnmAg4rddKbDGdznbasqHjFLWWxAmY12M=;
        b=NNRPkWRX89xebpI62I+Y7FDTaLYsxvjk2eVH6tLsmWF+v+Spak2/NHVqlwar6H3GeV
         /wOPi+Z1zZM4qtD0ZJVtPdWWHepaDLaIubt5QHcQO4Q2xTurE/SnZffEbVDD+JdjfKSt
         pnWUsOohnVbbEabTlbd2BM8HgTdBhEb4eYXd3eThVDxzXSEE8rZsupZ2zyC09apdZSw1
         xRNmKkK7/ZgcPsyvQX0R0SHBEU6HjB2/JFuXnNz4f8Yy0dm3Ri/HQf4A68Dlb2Redkiy
         3rb1VWubPe7IgesI0ubRFRIY0qkrxVyARa6LaG35Otx4aT9NhGpWUII74CbrwCKzdjVY
         mAhg==
X-Forwarded-Encrypted: i=1; AJvYcCUfIVEehVtGNOUB0oULAeEbfaxpkBTzsnO+dJhLg94xaqYyWP//2qRPlfYGJRQCdU1p6eEPU94OLg==@kvack.org
X-Gm-Message-State: AOJu0Yz03Y+a/kmSr0VHAb/AOS42YtW1UuSAv0thNio9mym24QaIU30f
	4HwEPpPcxOQh3tt3W/m1SOaTOXLseIt3aBF22ovA/UaE+La6g8HNQOgvclyP5woqNVDOuScxiDY
	H+S9PRPolKWsi0kN93lZ30hmfVsSk01fqipHNLqyANXjDEzPsj3s7
X-Gm-Gg: ASbGncsREm7QCuybxJJNTqQ7KpMxSKsF1IYBJoeDn68iv//Nn4byw4EbcDqs6Zm1bY+
	SuyHnut1zHahO3HJv3dwrt46Xo6UZ7dxbiRa2gOQZ5ESnrVhiBek4ZRdJKr4pdSCvEPLp/v7f2u
	tCPzmufQ6T4itUPS1maHadLjrjZ0h9/KhcVWvAJQicPc3ghS3JYUnOjcBQZTOo55ELVGmBhkiNL
	lLXIArJUynrNbEjLJzZEsrJgiRwRuk9YLqK7ZEggNMiFQ07ShA4Mf4L9eRrZvGmoANSADDKdN1l
	AFIKp9xvuBpJNamCyGFtFu8be2ew9cjGCrxeH4cNYM9C95lOj+6FiDbKqpOLjBTTZA9Lx4u+jj9
	nCYPxlQJNmsKgM1ZVwu4xwkWcaS9OYv1bJCGJzvlwOFL21P0pf7UoFnNgm+TkjTVkovepSyZF3P
	wwgdYIamMKoAmEwcvWZFfUxZc/SRA=
X-Received: by 2002:a05:6000:310b:b0:3eb:8395:e2e0 with SMTP id ffacd0b85a97d-42704dab124mr776075f8f.51.1760642790386;
        Thu, 16 Oct 2025 12:26:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyMIju1bud+5UvtGP+4+k2+lDXhOQIehYLmTBnYw4ldcLbEqw/fyQAEb5hw8VUiraCPtRD+w==
X-Received: by 2002:a05:6000:310b:b0:3eb:8395:e2e0 with SMTP id ffacd0b85a97d-42704dab124mr776067f8f.51.1760642789941;
        Thu, 16 Oct 2025 12:26:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf71dsm34704508f8f.29.2025.10.16.12.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:26:29 -0700 (PDT)
Message-ID: <7f5fe813-5921-4331-aa81-8be9aaa6a8d4@redhat.com>
Date: Thu, 16 Oct 2025 21:26:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/7] mm: Add a ptdesc flag to mark kernel page tables
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014130437.1090448-2-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014130437.1090448-2-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a6OKss68u-4eYH0ZVb8UJITMXBKyhIwFDTn2Bc-91lM_1760642791
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B6216140004
X-Rspamd-Server: rspam02
X-Stat-Signature: 11ctb8dafnp8uj5fi3bmbgbgsroinc7x
X-HE-Tag: 1760642793-101777
X-HE-Meta: U2FsdGVkX1/pqpBQTnpf6PJNTfJ971gYQ/ZPOJKtlSy7x2jMMG6BRuwqX2epSK9uuVYGYEheTL7fwwy5nKqtRWU3v+JuFhYFe7x4z3XsvezOJQZ7QM08PJRXQUIHiK1YAl3ulgi4eBFvPZtEIwVr5qpf9dO0r2BMbTIlZfEcfwev/pbHyIGzwMUs+aramGRcbuVRplIcacms8TtNHsvCiJGcoanjqD1cjZtERgQlacUt3VvRcyf2GGSnG8JT/pdrj+9zTACd3BpZW6YTDgU4ll7f7bEMdlkC0DUq/+sPuhjGap9naGhY83OxoFJC3dDFe46osnjvTS/1Gv7ZejfCMaTxsWv+zUNFLTLob3iucp4rAAz/uo6DChdWp6kdm+OFkqg3SQOvMwCctqiweCkQqSvOHSFO5GCZcBAuhfDIjcA/ekl8vhmd8MXL9dU7v+21azI/mdbaEHnJ0kAS+KdCXCBbVMlw4iPkEAs8JIPDgFpHKfszRC1nxQ0Ij5JSOjyMfjd13DE3r00OhpfnI7IwYS/4ErHrd8DmWmQu0lZe20Yp0b5DUx+FX2/sSWe85QdbQp837vuihO1KQ+H9jxLdZUtBrsFIkWAFq8DbO8sW+O4OtTnvT7wSHDOwEm/9Q6vusSCjVdsHJUxMBJVcE60rz8THKbPyBS2400P3DFTHTL99Z11kydob4/BF/WFrNYWpYfjK1NfRe3apWN8hU9+mcCJicdRyR58oIGlSa26tcRp/auojWsVFISgIbJbdmUDUVe14CWT8HLzIW8C93sv5ZzolUB8NuV/gAVuC4Y06jSQ4Q05xAE2l04/vWQN0YYCB6aUAn0855GSexE6QQJ0POKaIOUks4CLpvTj9zLm1o9/2DxUglELLEViwuQptzomUpQmgxO4bXidFxoGqEZlStxuzkF9Z/Z53VNTEivC33H98niBTg6BlW0k+nghn4/zJLhlTmfG4ORGRHvCsrmy
 iZ0SRUYq
 oEYqvxDbpeCh+LYzyp8W2vICypeFyeOf+7QyYBo7gixGn/Vh69CvqL9AcInhjXwoQGL6lk0EkCXHwaxII/GCU/IcBCJpDawoI4wd5imp34VEWsdzOFyWISxDl6e/AywAMry4ST+rS7okwUnJoC8W2/YfcvZ4qCZtUkYD1ui3EQeb/5Zc2B0EuEtrgoZ8X6mGDOcFpgefskedsuuGNaAZeyHy5pUUYOZewiOFZBoiQKfNWqBPQXhSzniknQrJxB6J3luANaTSo64Jlzl+x31xtUKP1E9VvzwXdYYcuNmKdcfvLqSZks4TXerHaz5iHNSBlvgoayLq8/9s1Pezxsqvya41KafOxJlYebTvQboMhK8/eg4xT2KIIXqleDhE7xyI1EiTYuwjpZqXTJE1SraUVRfR9VXu1/ENXQeuPPb27UKIZtNcUGj6RPbQ88JLHcMrJH7D33gt7ZjCxuuuWDg5P39REyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 15:04, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The page tables used to map the kernel and userspace often have very
> different handling rules. There are frequently *_kernel() variants of
> functions just for kernel page tables. That's not great and has lead
> to code duplication.
> 
> Instead of having completely separate call paths, allow a 'ptdesc' to
> be marked as being for kernel mappings. Introduce helpers to set and
> clear this status.
> 
> Note: this uses the PG_referenced bit. Page flags are a great fit for
> this since it is truly a single bit of information.  Use PG_referenced
> itself because it's a fairly benign flag (as opposed to things like
> PG_lock). It's also (according to Willy) unlikely to go away any time
> soon.
> 
> PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE. It does not need to
> be cleared before freeing the page, and pages coming out of the
> allocator should have it cleared. Regardless, introduce an API to
> clear it anyway. Having symmetry in the API makes it easier to change
> the underlying implementation later, like if there was a need to move
> to a PAGE_FLAGS_CHECK_AT_FREE bit.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>


[...]

> +
> +/**
> + * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
> + * @ptdesc: The ptdesc being tested
> + *
> + * Call to tell if the ptdesc used to map the kernel.
> + */
> +static inline bool ptdesc_test_kernel(struct ptdesc *ptdesc)

We fancy const-correctness now:

static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


