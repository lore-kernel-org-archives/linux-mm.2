Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C093C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9A36B0096; Tue, 14 Jul 2026 06:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490936B0098; Tue, 14 Jul 2026 06:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3801F6B0099; Tue, 14 Jul 2026 06:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0863A6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:54:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EEBBC0315
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:54:47 +0000 (UTC)
X-FDA: 84987074214.10.1D3134B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AD6001C0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:54:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G62+q4R0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BE9Tn1RAp+IvoGH4WDLW9L8P6c+reQ5yX7yO2HvT8Kk=;
	b=O3cmKPrPX91VSGtjEBwHWST4FnenU5avVWrxd+TiZGBZl+5pZDnkjjDIscTuG/7Bj+1FsF
	4PbnOPzikoslyzhP4ITf3JwmKY9XnAPQm6KPoViVMcbv/38gcYbHaTjALU/wXaV+umlKJy
	wJu9VLoC3nGQ5ujDPGH7POXlBGff/Go=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G62+q4R0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026485;
	b=fYzU3Geg+iS4wBkb1c3RRCFtdUYADN07q9QO4ZaaTPIpGjGlslP+d2kc3wJ6waAWkah5Lb
	B4lGszm4+FjJ8873J5u3QFjyvFbB55K1CShIFm0aOvApoxYWTZM4SUob12SWYbsmPoIaZg
	NKXW2IQGfOptJ7tjDKPp1ZefkyaDDCY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 741C1419CB;
	Tue, 14 Jul 2026 10:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294991F000E9;
	Tue, 14 Jul 2026 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784026484;
	bh=BE9Tn1RAp+IvoGH4WDLW9L8P6c+reQ5yX7yO2HvT8Kk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G62+q4R01qBeZPrRNev9vE4OIHnXH7tAR6mXURlQFZOUnZg764GFzh5Ws+CzndRp4
	 6H5eX5vAbkjRrtpWKwbBi9XaZvwVe+KWg4XH1UQdflJKeI5T18qjLvG9xw+YmRCgnz
	 DpRikfkfs/jBBxY/QptbK/URo8iNoyoxP3bKNmBGo2YuJK2Y6G4uoCSNqoC/EnVykR
	 hVtRmY3TGkSaiYI3wuePNIm9SOdqK+DlYhJJU5CDgz6DkBceaTBpNGAuSF/E7EDSVp
	 0uMrFO+GfdEin9HAT0QicMbToGASgZQCdGjyxVVYSyDCGYH61NzH6E07faEz3sSD4U
	 bZb+fKYzllKhg==
Message-ID: <a5083625-40fb-4da1-b1d4-06ee44cb9074@kernel.org>
Date: Tue, 14 Jul 2026 12:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
To: Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com> <alYL7B0HAvmLVHGU@pedro-suse>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alYL7B0HAvmLVHGU@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD6001C0009
X-Stat-Signature: o6bp5n3hcitgo6w5zw9ackgx8ak6u1bf
X-Rspam-User: 
X-HE-Tag: 1784026485-247582
X-HE-Meta: U2FsdGVkX1/Oy5jIMU0/UPkOkFslzgY0zy5po6+7RcO+feY2G+UqU34s6PqXJkZ59KbTsiM4QfJ/Tm92SLkH5pwC0U1zXATBpNS1kSvhekTesv3b2MUCViZvTNRR2J297y8hGDE2TG9MZeWDJ9kAwFWHfp9RJzX41xlG7qYDw6SsBQRM7LQFMztjXtIaiEaLfqtdcAUFsHd1pRqOLtCR6L+CG203CnjmeI68F9mFvWy3TD4RCFN4yBAx6pOqFFCD1oIFEcjzgQ+jJepfk0KMSTRoWEP2rGELmxAm5kmtc9v+tA6QAq5VmjsWrdZSv8I4Be7pc7jZLd4qPoEazWnzyTtK97KGJPiA600PSzglXzMzCO+/s9zv66ahSb5As6IIMrrslQKanaYXuowwUGFEFaBDk1C1+AT8IOKDafNRY7ppDWcr828xRZiJ3KOpGilkCcb8jh+GpcnxrM74cSxgpLtF5Ey6/tCrwe0IzKXoUWAKpYAOVVtbJVHaNxvDn5HFOjT/GmDd8mnCVI3+FbY2eLKpfnrlmIQ1SHgtRbxRiG2Ba+n91XZrgrqzjsggUsGPX1VhoHk+nlGIDsnpQ17DhjEmz05iR3IAmb7B/6aNM84OzOApQHhW3wcewLQ4CTS5iUboIPMB5dgFk/6QvtNs52tJ7Yk/2CU2MyBp1ua52O7yqcVYmLxQz3eSnVhB0/wLvIIRMyfHzbsxGtBPLKbIPE2TLPeGU6am7tMKhcXUeX/G6ndffcX+GTGQNyasY3Qu3X+cML2Tl6RQRIku8rX3002MvGu546yOBf9ivyaWQ+Eayqshbo+pLwG+p9b5MRNE4coCh69NGJAGRiXJR5i3thOxOqwxA01JqTkoQKOVMSDDpVIHdZbBZ4to1jMHeJBEKQnUvnKCBWJoEK5zoCCwUNVdgRCGwD07ifLzZAxNKZSmmxOk1K5Ey56gGVp2xXrcdoHJx1r80UWeA4wZhoP
 o+foPlEg
 YiR+VG53ojutqU73q9OlV8GqBQudqRcmnq0OuLJn3iqrXMaLNBSpPUzxF9bTZBPBWWaiS0I1cvDzCIxX2pb/XUJ3vRSzVP1UAf1TdxdpY8SzwYCqiBp9vufg6mdGzQ5TKNqphVK9hDoJO7GpDrgqcwQgW1hnhoLc3Pk9nHghBCKYt6/0JVm8qZpnWcOgfceFvdTUC03nWX1ou3fznxkkTciOe20ezjkca10Ai6h5gDOROyc27Wi75G9Sp+HBy30N+hCfrCT0CVIv/VMz1ffYGl8KeduTmzDoXDOyzmBNk0Tuze/NI+wYlwszJ8Ucl3CMbkAktqb6pdQDS+74TqUvkpqqN0iQ4ZkB5X/39+S8QPCQy9+zWXpDpC5a1rSNJ0xv5YbEHBA01MOOVp07D1kf+VpbzEeb0H11oxq8bUyp8O7Hmgbe0s7WU1s01GD4uWw09vSfD30xcIP91K7ix4Gd/z1nLtG/JWwhppV1CeqVANzQloOmN6w8Sk2XrC/1OLcgEer8KTyzgJ/SKzA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 12:26, Pedro Falcato wrote:
> On Mon, Jul 13, 2026 at 02:55:41PM +0100, Yeoreum Yun wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> We don't want pgd_t to be an array, as it prohibits returning it from a
>> function, like pgdp_get().
>>
>> So let's just use an u64, and extract the right 32bit value in
>> pgd_val().
>>
>> Leave the STRICT_MM_TYPECHECKS case alone for now.
> 
> I have to ask: is there a good reason for the STRICT_MM_TYPECHECKS ifdef?
> 
> I see the compiler has an awkward time returning a u64 struct (see
> https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
> get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
> purposefully toggling it on for testing from time to time.
> 
> If STRICT_MM_TYPEDEFS's worse codegen doesn't matter then maybe we should
> permanently toggle it on.
>>
>> As an alternative, we could use the STRICT_MM_TYPECHECKS approach here
>> as well, but using an u64 looks conceptually cleaner, even though
>> pgd_val() gets a bit more involved.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> ---
>>  arch/arm/include/asm/pgtable-2level-types.h | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
>> index 650e793f41429..02052cef9437a 100644
>> --- a/arch/arm/include/asm/pgtable-2level-types.h
>> +++ b/arch/arm/include/asm/pgtable-2level-types.h
>> @@ -25,7 +25,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>>  
>>  #define pte_val(x)      ((x).pte)
>>  #define pmd_val(x)      ((x).pmd)
>> -#define pgd_val(x)	((x).pgd[0])
>> +#define pgd_val(x)      ((x).pgd[0])
>>  #define pgprot_val(x)   ((x).pgprot)
>>  
>>  #define __pte(x)        ((pte_t) { (x) } )
>> @@ -36,14 +36,21 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>>  /*
>>   * .. while these make it easier on the compiler
>>   */
>> +typedef u64 pgdval_t;
>> +
>>  typedef pteval_t pte_t;
>>  typedef pmdval_t pmd_t;
>> -typedef pmdval_t pgd_t[2];
>> +typedef pgdval_t pgd_t;
>>  typedef pteval_t pgprot_t;
>>  
>>  #define pte_val(x)      (x)
>>  #define pmd_val(x)      (x)
>> -#define pgd_val(x)	((x)[0])
>> +
>> +static inline pmdval_t pgd_val(pgd_t pgd)
>> +{
>> +	return (*(pmdval_t (*)[2])&pgd)[0];
> 
> Ugh. This isn't correct C code. It only works because the kernel passes
> -fno-strict-aliasing.

So it is correct C code? ;)

> I would recommend either forcing a struct here, or
> using a u64 with bitmasks/shifts.

I had that, but little vs. big endian was annoying.

-- 
Cheers,

David

