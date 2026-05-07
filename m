Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916ABCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 18:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A517D6B0088; Thu,  7 May 2026 14:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A290C6B008A; Thu,  7 May 2026 14:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940046B008C; Thu,  7 May 2026 14:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82F0C6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 14:31:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2411CC2176
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:31:59 +0000 (UTC)
X-FDA: 84741467958.12.1C41EAF
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24BB94000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:31:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uc6m5jIw;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778178717; a=rsa-sha256;
	cv=pass;
	b=ne7JYIV7xzNYU9Nxzkxum8U04VcbhdEBp+yWznyVD5PGooVqFkGruz0RVvoeo6rXVXX+Ox
	SPsn33n2wtU49cKnmj0/clR0IexN8ahcNmID7A+UHo+JnSXuLEHffnuJ2RthTfZ9tGW8RK
	BCSr/SKipB2U/IQ7birlO5rSb9HVQSE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Uc6m5jIw;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778178717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goCC1MXS8+Hmwnd2WWRAT4Rp01B0ycJCM1C1lBpTnIs=;
	b=DTNUr9DOBVADpoyNS9Zjkc6rUu4/fJOP/crHI26XCw4xeCvAvOzgrWJDihVf2x/ty0Et5r
	BgoNRw/OaBgYkA/Vwx+KlZ/yz34Xp20o5EJRjcnQ7Nr/iLGpmXoU6Kq14UEb7QbLhsTMXK
	9noSVH/DSp+Ma0Nq7PJenNBzTpY1gZA=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-575212eb419so881297e0c.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 11:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778178716; cv=none;
        d=google.com; s=arc-20240605;
        b=BFNily0SkKd/Ep9yykLJgznliGtINTMQ1TQV905AQRCkAn2YgBTD5Ms8ISZiZFmHLY
         gOtJ0rMtz03BPCydUORI13diwh9eYZd+8FDeCcjLEVBkLnA1bucXsVHjVM+yD8YyBduv
         AiL8ei6guPJ/s36z0hsMLCChPV0Xtb6n4QQSJuyE/Cqwle0zWL2vdW1ywRNu3rAndm0i
         h8SWQfrme6EzE0b8EGVMIchF3SOdcA+9JDIGPLt8L0vjj8ufnEwxygIFoqqJKUW4PqOJ
         /E8jPESvFPe+zImxnstnLch03XyD6R/AxLwHkA2Z1I1IjgBcwny3Qrwrc3tSaPnTjWf7
         y7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=goCC1MXS8+Hmwnd2WWRAT4Rp01B0ycJCM1C1lBpTnIs=;
        fh=nuWV+Nh1x6vrdyJH7QHRBOA7Hpnnr0nF39h2kXweqDI=;
        b=aPEXR1He+Qx1d3j7twxNqPuYbwAw4IB4NmxAHZ89/pYhFa8UYruja4qIAmMmWkQzw9
         gFKUJGppTEw6izUao1nDCnwLLwy5xdRQHYI2PJgD7k31GimlwD/gQI3VtprCembBdbkv
         9NV3OkPzMrX2QLKJGUF2DwuvNNkEoZEZUaLpn3QquHHNNJbVt8K210c8TQyPZk+9Iq1Q
         3ICd70QFWCqKNCp2sjGiihh9PsZn2Bbtrx7E+AhtnQm1TpL2rcgV9TMiyRpnhZAa1Zo7
         PATzI+7GhOQHFaBBdv8/RkPQx0cqNbIDugf+urcp2OQ0vtRC0ciegmWV8xKJCK/Qz1sX
         D57A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778178716; x=1778783516; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=goCC1MXS8+Hmwnd2WWRAT4Rp01B0ycJCM1C1lBpTnIs=;
        b=Uc6m5jIwBFz7VvZ4wD6PSbifR+pB/BgFMgyXyy8t3hq9sP9iP6BpxTJdcT9K34P1Tq
         IMK998QFmrlxN9iisU9gBsr1BVIZLz6vVtmiNj17PxeRddbrwtqwI/GzVG7fmLffWUzq
         LlL+GorhcD7RJHpjY83bHvk7wQL1SPC7LiWGMsmYMQ3WpawN0xtTeC9q+Wzt3ZPmjfCt
         YFXxPIidHOScIQzd2aZhWp/t3hPxW6C1suhT0JhxIhlqNcqdpYeT8Z6rl+t7fcLc7QeQ
         g0nRBzGwytHkpr3h3lHxcc99IXfuF+icVac8CuFmAuJsDZDEyVEQWLPr47vrRLO/zG8a
         uUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778178716; x=1778783516;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goCC1MXS8+Hmwnd2WWRAT4Rp01B0ycJCM1C1lBpTnIs=;
        b=PR1NrweqLXcw7FQOMHa0Flm9DKX+uJeBK/R6UodhBC+lGFHHK/Bs1ZU4pWNWGsMXHs
         Q9QUJ82l3w1RxbPdlDbgGEW+t1ZYzaRzNX1bcqK9vKHQVXMrqikfI1smS1inFFDBbfY1
         EP6BQ9TZx3EIXyqlgE5u7Hfil7zL58t1tkdJ2v89h+k1oezUyhmcHudMVIdzpMI+U7DH
         okgc6fSRDQyo3RU01i8nGPb1+gBv2diWV0tBHFqWgQBcX2qsmitKbwfFud6rDV0yLuC3
         GbpTRk+H0htueziINJK2HaWsnSnptc+TdCyWQYmZxQV7ryWxETnVwFy1JUwJcx+FeJtR
         HKHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DQoJhK/tpi5EPM+7MRv3sry7ax0qx3k3DpFtuuKerboCHrZ0pACy1GX1kWVjjyJSyk90S1U0pMg==@kvack.org
X-Gm-Message-State: AOJu0Yw6v1rbLFwjYpq5agM59gqByJUwGlomWivozwyyUfjfwQ+SRyb2
	t1687Pj2shEL9z84lxSALLKXLP+OgzlGhRFCXyNzibAODcvu/E2Rrs+3n1jXF9v99ix+0MVoStZ
	YxcEAgGh14xIN2LcPTt5c9yBPr0q0G5q0fJ7LnOjM
X-Gm-Gg: AeBDieswZJeq/LuEl48xtr2Y8es925rG+Z+n0HIaKWrWB4TkKCUnYlsXByIcd15s72u
	P4Wguv6IfZq8BfpYh3GvaXOTOY21+7kvwcwvwaRdxkVqoP/jpkwUAeNiGHmkeqUHgh1VbtyDG5T
	iFE5M8fsPZZNclKe/g2tngog5ESx5X7AkVoifxoxYvkwPg8n56KkB2E6tcOkYCMA5G99N4+gud/
	tZKuwlas2jXp+fgAix/hokbljTbwV/1nyfUznZ+8fNq+3h8KBiuGzXRir2lA0bXy+JPu/EP7XjQ
	V/02eA5X19VzlzhTBFR8fpGW5TreQwasqb8qs6i87xjSngVaAEFK/+a6Gg0JTobLz00rA91Wa/4
	pGArf
X-Received: by 2002:a05:6122:6304:b0:56b:a7de:7129 with SMTP id
 71dfb90a1353d-575702cc825mr1528185e0c.7.1778178715530; Thu, 07 May 2026
 11:31:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 May 2026 11:31:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 7 May 2026 11:31:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <byywwfin2aenobdwuesqihm6nzxyx6ecedwgbt7f5tvaaul6fi@u7bmexpavwdn>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
 <20260428-gmem-inplace-conversion-v5-1-d8608ccfca22@google.com> <byywwfin2aenobdwuesqihm6nzxyx6ecedwgbt7f5tvaaul6fi@u7bmexpavwdn>
MIME-Version: 1.0
Date: Thu, 7 May 2026 11:31:54 -0700
X-Gm-Features: AVHnY4IrLeBlt83AneVyVg35mAkmDcan1kch_gmoyAe0Nsgg7IVb__9uDe3mtms
Message-ID: <CAEvNRgFGc7SRy_hkfSH3X=Cu00CP6wMHBJO0+55uebKTezWVnw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 01/53] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
To: "Liam R. Howlett" <liam@infradead.org>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4pxyeh886fxpnbu6pzr6dt48issw13se
X-Rspam-User: 
X-Rspamd-Queue-Id: 24BB94000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778178716-117072
X-HE-Meta: U2FsdGVkX19QjAFc9rToQl5PDIiaPEUwe5zShy/I5b9qo6C3EPzZJllND3ScXPO1D0yWUss9vGItL9odKzS25nWOp2qSYvdEFxe3FkoQzvyJ50p/Vj6eOU6R9vzhqT+zX8PdNMfVvpwZT9xXkF4Td7kR3GEMDParpEuYUmEld0nqBa7aD8IaScEdJ+pLE7E7AOuOAKlRednkLWUS/phgiHvmYQoysB1hrMVEZJRxOIwS8l5faWRxCxlRWHwdbyncUUCuB9XtlX5U6cqgRd3RnRp+RoAiTrNnE93CcD6t/0JLsqlbzK4D7+kTX1Xvkeeak/5X/ghMU2be5AWmkGv7mP/bNhjystezMMTkvT/i1Z1pklftamihKsek8SaH2aPnZYue3EyBzrDoA6gagWlMi+mN4RygfcsRDQY2+FusypgPMDheCULmyzXhlkf89FrTpNQolL0qYCtmoKSmVV3ActkHI2JU9LD+UmL6wqyj1eocX4ppCaVI5ZmtyXHF/DvcrXu6tuYRBTZTgslkXLQqPnMAbuyCyVdl2b8TZjv9rp7bZMq7uPvj9yBtdJJF82NfpHDaOKXH+3NmeplY9IwpmmT0CB+8XDosK77pU25KJwFtHtde6cc+fitCDul/Bcw2SNyLky8FHL2TfNAauviUOz092kj+lR/EcFvYXEnrGUkoh4ax35ZpV7dqnczJV9WuYuEbdyBcGJXcEVFHJzznpIwsrLwXzGQgc5WMW2DOCCVmdBxgiulXGin3uC9lV81L2zRXpWGiGuE1z/nhj8eXMIHBqRNcrJl6QEWle2uj3SIBffIwFTJgk8b3/Jq7vMCPJtGIqH6Sy2WM4h0ThLdcKETht1iehwzSAg8VM4fxD8826qMygMK8/2hqs6t3EDaZD1b4kbauZRvYSwKgSie7ZgjitmUat1DjBDtE4yy8abgKzyP4ISoa/rXGqM+MMNsZbeheq727rHi4fbmFRKc
 Eu9EJp2U
 ZdKbKfebVCbMM4Ik3SDlQh/t3SVALJjf12dFUVuaxfy662MlDFeRoYJEZcaHiOyn06oSlVyz51374DuBT0b54wDg/YX0XT0Pr+ijR4RB5xv2a43u1nfC4i5e/840KFSzHJ93VC/75m+TKek5//2gbDv+YAWDp9+QsxCa6i9yLAt6POmapQgA8Ut8mBxyA6SG8wbvx0lcV9t0pzBc7NV3LVUu7isCDZN+LeO5VFEihgHuXYAWzhev5aXp/Wg7wWiU4jwvOUOcUspc0AJggf8rN6jTrzeiNmx+TmZGyHKGvXdVAOrGJDaYK1CO4joEFvYG9W0hpovgSuIquhe2QybTtjiZ13OW9mgGbSpuq5N9ec85rL8ppjg/ieugE/mU+LbVZ1vJSTbN6hy58b11aNGm1o8kuQBi9YGwA3+4BZ38Wj1f1qcGPULxfpsN42XIBMz8ho7ku
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Liam R. Howlett" <liam@infradead.org> writes:

>
> [...snip...]
>
>> +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
>> +{
>> +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
>> +	void *entry = mtree_load(mt, index);
>> +
>> +	/*
>> +	 * The lock _must_ be held for lookups, as some maple tree operations,
>> +	 * e.g. append, are unsafe (return inaccurate information) with respect
>> +	 * to concurrent RCU-protected lookups.
>> +	 */
>
> Can you please elaborate how you see inaccurate information and which
> information is inaccurate?
>
> Your comment is incorrect and misleading as append will not be used in
> rcu mode.  Note that you have not set this tree up in rcu mode.
>

My bad. Thanks for clarifying about usage of rcu mode.

>> +	lockdep_assert(mt_lock_is_held(mt));
>> +

In the next revision I'll remove this lockdep and use RCU mode, and
kvm_gmem_get_memory_attributes() should get a stable result.

The other lookups using mt_for_each() in kvm_gmem_range_has_attributes()
and kvm_gmem_get_invalidate_filter() retain the lockdep since those
operate over multiple ranges. Those are called from paths that require
holding the lock to exclude other operations anyway, so the lockdep
requirement does not cost anything more.

>> +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
>> +}
>> +
>>
>> [...snip...]
>>

