Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31115C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6066B008C; Tue, 15 Sep 2026 08:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286FA6B0092; Tue, 15 Sep 2026 08:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175AF6B0093; Tue, 15 Sep 2026 08:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E35B46B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:49:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D449803FE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:49:50 +0000 (UTC)
X-FDA: 85215978540.04.03A5BF4
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D135A0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:49:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVj6xlmU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mP8qopDle1Sc4k8F6w5GND/XUp1RUEWcrZG95tdjUPs=;
	b=wFoili/XcfqcI4dXnt233a4nPLTe0ZmXw40HxVC9z+RVsVQnrtzmCwzIaOu+o4FtjB+G9F
	GM9EvPtRbkOdCRRb3TWxWgjRlADuKcqf6yhi1nR6j7WctLu3hC43Vw/1Fe6hJaD5qVprYH
	//f1qcHa7aFEtM6qBTwSr/3nO2Ye1so=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476588;
	b=ZlKVR3SrFmVP2yvBVqa6SUM7KixEhrfzBGv6G6AXDC6o04YuWT3mpWI1qo5bk58DkI4HLe
	gPdFDvyS37pjwXZC7++uK3monKb/VCZKFKr8POlM7y9IG+mF/ZCcN/Yd0uF7Al7JSq4hgg
	PZEdRySjLG/2Q1CpLCsF+mbpQUFkPWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVj6xlmU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2dae660f31bso31695255ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476587; x=1790081387; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mP8qopDle1Sc4k8F6w5GND/XUp1RUEWcrZG95tdjUPs=;
        b=EVj6xlmUXwttaSdwJnWx0SMgauV5RmQjBYOShsjQ2oWHyRhmFVatahqjfahfZ3cM3H
         X3umwmPST6vt+VAGi0/9Tr2FPvYTsuV0PfVZMLFnUbh3jc+UTbpOdOr5l9WzA86OZsBU
         eb8hBDbVJOhvZJO7HHesDA1aavjj3by/UBe9UaRlx6UV2aI3fCBkviXyzW0Dwd0GembO
         q9wT3ssTCJYcgWjUyjxdJec5f+z2byr6CzJ0yUrqpfbMo2IF0XIc7pp/3MUPzZXvoNvi
         JFOPyEm+FHbxTRWnLJwxlS4XJOcGOzCeskT5KpPR3+cI9wF5244P/CozVOIMcfgGiNkd
         6a8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476587; x=1790081387;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mP8qopDle1Sc4k8F6w5GND/XUp1RUEWcrZG95tdjUPs=;
        b=yG3bV1BTTJUhaNDVP4OJ8LjCUJnKsbr0/tNoXevjVbOtjQBLnRnZyKXcqUQAeHDDbx
         r+6K/txfpVbt9MHFIAvjl5KYTmR15Wrii8uQql2YRufWToF6AxHxBoAovCKHLtDfnRe+
         5TyZekQ+lc1Gif5Y80WT2PqtfeQoYl1g/TL8UDb1Tl3CEQOb/Yss1iHKk8OOZuA6FPZr
         IEdBQNQrGbfxszYp+0g57VrQy8tKWbcdicghEE/oKTGS39mXDNmLn3GQtcvlsvuNW+6L
         CMEaaDX6neiS31uoqgNsT8tn5Vd62JEaKFYTsC6gl/6t/QWqLs97Q0bdqoJwIcZXkNgO
         9Eow==
X-Forwarded-Encrypted: i=1; AKwUvBz5w3Y1iStRPfLK8xLef9o7rNT0MEHSuzD1k2MqKFRsZYXeMtyfQfUXM0lrNaYBzkt+LmUebcmcvg==@kvack.org
X-Gm-Message-State: AFuF++n9GPXuLC/SPNUP5rmwQjRV9UPuY9e/4RcbxllD3AuGYhmHxqbW
	kYiTOgyHUw4gFqjCYjK8r7//4JFedKYu0bkO3/v10CxVgW5wxxbP68WO
X-Gm-Gg: AYBFou05RNrcnlGKhTOSjJpwacLKhQ8rkZkxRhba2F54m1EtKMDdUOwUjnaIgc1yYcF
	w4HrNgUnSCKBOpJ8hHH66ZrVmA9p8Nlj1h1Za0qUvMnUQo+ivYnVriuInjiFcyk8XwgBNdU/e50
	e5DCm4pnm9jyyhgssArcG+GVIyUKVS/ByntwJAOJvuXUgbFfZAGPLFrOZqIArJEUKDwa0vRyHI4
	g1Iz2dooWiKCA5CMGK6fdNNmXVZXonO8HDuSFgzhXaanhmNTyCxzDdQNbESUX1b15DJG1TJiD+c
	nU+//WOax+HHERaX3x9STadqCff63XSFWGmZQ4DNUfDlEhuKURqMwee/lwZ78qCN8eMWM8wNyia
	h5KzKlWfPU9tTY9pdx4YqdLT6nqhPPnmT2KlPhqgKtH2ddF5X7Sd2EOTJayioXoe/dOeFgc8D/P
	lrRWNFRFTFsuQ2KVWZckYL02wP4YqPnBDavuom85Dg5zxwWYTe5B2e0DWvCoMWtO+O5sYq/AfjT
	Dp2vPo=
X-Received: by 2002:a17:903:1a0b:b0:2d8:d4cc:be64 with SMTP id d9443c01a7336-2dd6c7134b4mr167097285ad.17.1789476587316;
        Tue, 15 Sep 2026 05:49:47 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd6f8ebbdfsm26424855ad.38.2026.09.15.05.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 05:49:46 -0700 (PDT)
Message-ID: <86a09d26-2de8-4590-b135-31564e2c7049@gmail.com>
Date: Tue, 15 Sep 2026 20:49:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/10] mm: memblock: add missing HugeTLB flag name
To: Mike Rapoport <rppt@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 baoquan.he@linux.dev, pasha.tatashin@soleen.com, pratyush@kernel.org,
 m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
 alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-2-chenwandun1@gmail.com>
 <178936321614.3691424.10386784926753862087.b4-review@b4>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <178936321614.3691424.10386784926753862087.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9D135A0005
X-Stat-Signature: ddytucximsffm1ogyxc4eyn9psrkcm49
X-HE-Tag: 1789476588-846981
X-HE-Meta: U2FsdGVkX1+ZN3W1CmZvImClV24GufanawQdreH8GQ79X0bR4/MqVPSXjxjGDAJdgZP8pOuweHxGvhjjZlzmPrUPcT/3g9AoU2rT9KxaNfKqr/TZjp9b1l1AdSqdEEmI/TLaGy8sD1cf/OXbTtegmxQT7AJ0pS8U8SEtUCVmu9sX9whq3sN1a1mUgXl4X9rZGUUeaEFTFUa5FV0XJ4nTHwVLAyWCA2nmXrw9sDkJALThLVooafH8ovKMhpPZxBDIpxPc0aIfx9bbP3OuP2x2bpX8o+wifqqRjSbXB3GPqD2DNISRr9SI04qYj7sQg2GDpRLdMePzIUKSgpGjNHb4RU4zBGVyVe6V9DD3dI4Q+lTZm1spRTc9XqjRDB+aIfae8UhIcaNhTWeXkTrvsuVkh4RSjw7aXLsxjGPSoioNeT4MW5lTWnHOU8eugybtIlEmQWdfGmv0WZP8FGYSxrUrHse0JC5kFp2izptZZ3j+VbzHFFttVVp+0FuH/GvaS5rBcSciiJ3qpsih/Ebby4e4h+7JxSwYcSp0SLFPI0vGU0KGkvXnNxxJabbKCUo0u2ed5iEGQ6Zs43RKBcWWgiobpBHg0r/Go+C+cTUNvAvjfF2F+YApl44IwXxDOCd+PhcKpQyCVmmv/K735W+8es5xCKZ8nCjajWcvo8jTreSkQrVlAUloNqJRKhaTm9gr8JEHMrYIFeaaOaLFHLoKIWePM3P7VEJg+6/4hSKjEEUUNl+n4tH7BiYSjZr51XVHzp6BYSVsII3LZO2l7dSXEwRfWGhwdn7gJN4Q0zPBl+koUX468cXerWBvvvwVPIXd++aDnyLWIdD5SDx7ALz9+PlsfxRntLbibYgDR4i1KbSmVBndXO+bicG1nfT/4hoTIPmZ1ArG05zceSCjXRtvzc+dJHzSV3IM2H/DA8zxye/+qx5ud2TIQSJD7gx9xZZSNJkpqsx18UrDYWlqiXvX+1w
 6kFH/P4a
 AzTOW2NgCygXXDsEuvLUTpQ3gT2bdHzeHEK4fb/mS3IoTR19c3O7ZMZm75lIJ6wtOVEguDYqVQqs0Q3RilL3YWP2E+oooZduOikXC5wci3lq4/lPm8zOt7SLKOUQadcNvKP7n+lM1/Cg9vsQFFxDtyCQscfgq7LMpfhk6sQl6BGEqPfBUKuvwS1LkhbUd8mzwJHRMER37alQ/WvjjCCj6vRF9Z76pEwxZQZ83u6r1oZyKh0P7WVwVsGCzhaf04bfl/t9cKN78JHWZlxNJL/CHCpTS7D6jt9PIHr2ng9o/wH+a78DkXqT7XOY3p9lhmrmzkzIJ2qf6zQFLuQF0krqhKr4ktzWwhcNBirAdRiJzVRFvSzhgDLYjbXu2cBJ41k5CgzKvjvf0rn2DHzi2MiS28d9mDhVxEpWbvFMdgh3IX4XF0UDCSqmP8Fs/COKUtqJ7HzpGUUTh42bODFyjweaH18nrdk/pFgzussL+AznW/ClM6E8oCzON0XsDmWa1lu5RL+4o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 13:20, Mike Rapoport wrote:
> Hi,
> 
>> Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
>> with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
>> entry to flagname[]. As a result, memblock debugfs cannot report the
>> flag by name.
>>
>> Add the missing RSV_HUGETLB entry.
>>
>> Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
>> Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/lkml/20260821020910.3428585-2-zhaomeijing100@gmail.com/
> 
> Can you please send this as a separate patch, I'll pick it to the
> memblock tree.

A separate patch has been sent.
https://lore.kernel.org/lkml/20260915124641.2498280-1-chenwandun1@gmail.com/

Best regards,
Wandun
> 


