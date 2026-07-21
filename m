Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E30C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361646B008C; Tue, 21 Jul 2026 14:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB696B0099; Tue, 21 Jul 2026 14:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C676B009B; Tue, 21 Jul 2026 14:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE6916B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:21:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B4E3160292
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:21:44 +0000 (UTC)
X-FDA: 85013602128.18.2101285
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F920C000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:21:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBS1CkQn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WED5aVE31e9UmcJgmLBdBgW0L+ihGmbx3NEOMbcoNj8=;
	b=ZDJLaKlzHC2fOQi194GM4Y7S+GyEl/FW9ImGNUJKqfqOT5wQWhMiyIatlaCgpB+mee3NZm
	f2mHBZrfrzDm0gIx3LGphHjFHXaksYbZw83ABKrXHIBzjjYGpzEiwN8TS43YDlSZJ9yV86
	dlIpMIoUIgbfRFXGfhzQQLmb0Qf42PI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBS1CkQn;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784658102;
	b=umJi4RmxqlvYruKXSZr4sM30tqmk74v1HwsORMf6J0jujNCqdrXazo6+ukKein/hH1WIRJ
	pcJ1yX12nXWlEmTWcgj3TsddCr/IADuD6mTjbJ+RhAXlBq/eThYtPpfcvM8/L257VRUc0k
	nOFGro/iUEZanPLDEYSrUpX8izuMrVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C487B600D8;
	Tue, 21 Jul 2026 18:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3578A1F000E9;
	Tue, 21 Jul 2026 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658101;
	bh=WED5aVE31e9UmcJgmLBdBgW0L+ihGmbx3NEOMbcoNj8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NBS1CkQn+apjU9r6kMfeBbrfcScZVkMbtbg0YyRdbXNT+gb4TpmpHJl+AOBiN1KVA
	 HwrHXpXfZNMr9D8vd+zfaoUpFJBcF3TlSQ4xpe/XUE/Jd2I1zSJ1+gJB/NQRHdQkiU
	 euAQM8EjX27K5x3alp4YE9DIy6wlXv0AmkFFEPPyENPX9nkSAGX/WlmcvYG0UgaDrD
	 oHj+KMHEfIuSx1gyjONCpBlMYtBxQ9nwdZ8hoFq5/ABYRveZE9N0ZtbiFzc9j8NwYx
	 HKBs6XvN+IqTFBSymLn8MS6F3gx+mXhj0GSEL22UekMGMVca95FdR81fu7ZBMfmcdJ
	 368TJQQ7O2ErQ==
Message-ID: <78087721-6598-44f7-b89d-1fd98dd94b6b@kernel.org>
Date: Tue, 21 Jul 2026 20:21:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com,
 rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org,
 klarasmodin@gmail.com, chenhuacai@kernel.org, kernel@xen0n.name,
 kas@kernel.org, zhangtianyang@loongson.cn, wangyuli@aosc.io,
 tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com> <al-wLXp0tAv7hNv-@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <al-wLXp0tAv7hNv-@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F920C000E
X-Stat-Signature: 1ghbq3zakk83yogh5zbxjqboicstjmcn
X-HE-Tag: 1784658102-869474
X-HE-Meta: U2FsdGVkX18X8KddGM4FrvvnOAKXfT65AxJ/OiqXFRsoY29Kio+fkchaDi8Tna5NOSusauE07Ik7yjkmOS4J9iv8dY4m8x7axHhAdR1GmCdHK4gkAXET05J8wdx4tcAmRhusypRQwRDtnQX9ptP6CUxTMsBwcjhglmR79PqJAcpFJOr0JWeAW/K7ZQ3B4wj/WyI/Y8DBeTMpBHTPcnWAaBcJHzRfIyhXiYXZzMVLb2Vlq31XAQQjao6hUX6jdyyVKJ5xNzG0jIeSkN9fOzxrtR/u7HUyFUmU+obqym3Eh8yw3/eN5t2rNFpWjMhtY9VRn7R5LvOfTTUvLRcrxLpTcWuC0oKySNMpIGEjkgTo7JGzIsfYkpEJseHx4raVipE5YToER0OqONWDVbdV/xbmFoD+Rhh3Sh7krd3XsCV/QshXdj4fvvcuLrODW4z4rUEPYjsFlloRXgIlBzN/2VoNsNdCRMXnb080WlX3GZrfOM72pBW0oAWLri/inuBzDz3KrWRW55oV3mUg2Oygo7UwutDRUS2La87X0IPkjXd8/YlbflUW+gS+fNVTL39TuaiRwVMa9LJutxs+8cfQ+7nGuT8GmqqfdAnVuHYQSeDHGsbh3p4LYMnrJLDuuY01iwdBILjf3b2gskhzlnKQXP4JtESADk9VYDMN4xAPoHxbY2blnjWU9HXokkFlpU6xaSOh/f80NjhyXMPZ7GvSN0QFbStR9YqKMbPgdXFADS9HBDDq1Dldqq7jNuF9duorAd9T/i6nSzglqe48bzvEF7At1tYAZ/YTlcsg5ofDHxvRFkrd8hkDEHDKcmjm9AhjOsoboZ9PcqEnwmGxdxQAz8f6Iy/R0WOtYLPVB1DOcxh3niwhDO4S6s/Vk3ghjx9zfM8hMrXqi2LA8sc/RK/GtrgL+M9BpB3FcoAXbx8Zk8uHSBhh2V+ainRDsHb4zPfFQXrbbror0yV8JrLAwBz5kw7
 RbOuoxwT
 49Je4W0JEs1uOQVbHHOmAwiH8s+RrF/3Qlv0j8POzqXMMSO7KxMBglAk/Aj5pmYhv/yB/tyFJEEq0+sVrMSoSiXHBBho4RtdFCLSECTTLLqL137z14yVLaYGZS+5mQNitFqUsKD+NGWwM3RpA+XYl7V1l5KZ5h5K6nvnuVCoCYfNMvegGZ1QTpNZjOqF3zxYpBJbYDXn8e0KwBobyWom6gi+j84qoInjJFpPq8KsCkcDUKcZ4v2RJTH6rbrctafMaLOIPrquyiqeHwfuJSP5Gq61CE1G40jLokfq4iuUreko3m+fkuXIhBUb5aRuQqUpNRQhQivGnKaye22pX9XtFehfHPOPa4zVxc+zq+EqsDjP0TXTomgD+vDBOYzgppm+EwkKs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 19:45, Yeoreum Yun wrote:
> Hi,
> 
>>>
>>> Yes, exactly. :)
>>>
>>> And I agree that it is something we should be optimizing.
>>>
>>>
>>> I'd be curious about that as well. I mean, looking at the generated code
>>> it's clear that it is suboptimal.
>>>
>>>
>>> The solution space I see:
>>>
>>>
>>> (1) Pass the result from e.g., pgdp_get() into p4d_get(), so it can just return 
>>>     the value with folded p4ds.
>>>
>>> That requires extreme amounts of churn in core-mm AFAIKS, so I don't see that as feasible.
>>>
>>>
>>> (2) Rewrite folding code to make p4d_present() be a dummy instead of 
>>>     pgd_present(), and make p4dp_get() return a dummy value.
>>>
>>> ... a lot of churn across architectures. I'm sure we'll learn soon why it was done 
>>> ike the way it is today in the first place. Something interesting to look at,
>>> certainly, but a bit of a stretch just to optimize reads.
>>>
>>>
>>> (3) Make folded pgdp_get() use an ordinary read instead of a READ_ONCE / dummy.
>>>
>>> I don't like that, because we couldn't catch easily if the value is then
>>> actually used some old/new code.
>>>
>>> If pgd_present() etc are supposed to ignore the value, I'd rather have a mechanism
>>> that enforces that the values are actually ignore in pgd_offset() etc as well.
>>>
>>>
>>> (4) What we do in this series, but instead of forbidding set_pgd(), make it only 
>>>     complain when we are passing in a dummy value.
>>>
>>> The expectation is that it would avoid touching most architecture code in patch
>>> 12 -> 27 and still prevent mistakes in the future.
>>>
>>> @Yeoreum can you play with that and see what the end result would be?
> 
> If there's no comment anymore for (4), Could I post next version on tomorrow?

Works for me.

As discussed off-list, we should look into de-duplicating some of the arch
vmalloc_fault fixup code, but that will be a separate effort.

-- 
Cheers,

David

