Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CBFFDEE2F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BC936B00A6; Thu, 23 Apr 2026 13:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CF66B00A7; Thu, 23 Apr 2026 13:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5341E6B00A8; Thu, 23 Apr 2026 13:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FACE6B00A6
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:56:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC78F1A03FF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:56:16 +0000 (UTC)
X-FDA: 84690574752.04.6DE5E15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6AAF240008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:56:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SgjZvDZ1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966974; a=rsa-sha256;
	cv=none;
	b=mwF8l/3dNE4K1oVRThJJNHUpngLIpqUfrN9Ye69d39GpMxGZhBd+g/5zgYPtgpMwECIygC
	ifDHSLvDKoA/CPabjHm2IqP2obRQIUvNi/s/YD0nQ9y/FYmQHMDRu2/7xyvme2XXsEzKBy
	mAJiuHYINTqRv6x+JitjTpESwWPsmXE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SgjZvDZ1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWsc2qml4fpvUwZl0dBqHVvJB7WWRuOvmtX8LdSQLCU=;
	b=zY6fmS51cajFZyf1iZwCHO1Zf2OOg/meU07g3O476b9a3om7DO5MIW02PQ0rE/HFQAHHQ6
	aRVm6yAFoXkYr0Nw2R6DuSy85kFOPjkN51V/mWo4SWXOtb9dUn01v+sakMIaOOAWR6Erl7
	7dPlpnNgYihu3Ds2uL7JvSAf+vHftdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776966973; x=1808502973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=MHCLyYmnhbQiKGQwL1kRnRWZZa91MoZwsILrqccXVac=;
  b=SgjZvDZ1C/MhYiXhZhS4x/olxpT9cByl1C1a4zG68UvwhW/Z4GCFOxN3
   pcum2ddJeqGlfTCZr9/l5uqp4CoyCQxyzNEh4dtVrb19r3v9JBuB5Rllt
   E8wtGVAwaTl+XsGJ1JIVDDbYbvo399lkcTiDY3JNciFUfJKrp94+8WG04
   bfGQ9MTT8hSHBNqCRmIk2OYGWr2Rn9A3GdTgFwBYOfBrRqsnxV6LMqEkS
   u9afBszHEYmrfgFEe7X5cnAK/RHpmiyd4l8CvNOGl0u7bHzOl7FvnfkVk
   j6uPiugirq5VcuRFJhjk474DeST96baDe9iJLtG06s6CxjgptgjT/yFpg
   g==;
X-CSE-ConnectionGUID: REg/MzVrSdmP3oDUNvD4rg==
X-CSE-MsgGUID: o79kQwyUQZWjlvASHjDdxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="77825813"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="77825813"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 10:56:11 -0700
X-CSE-ConnectionGUID: kq5U7E4nTBurAK6FbWX4Fg==
X-CSE-MsgGUID: c8PrEufTT7GgBg2zPvyWYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="226192054"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.108.10]) ([10.125.108.10])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 10:56:10 -0700
Content-Type: multipart/mixed; boundary="------------TpncX0p2dB2Ohe6Tw0NCcsID"
Message-ID: <f856051b-10c7-4d65-9dbe-6b1677af74bd@intel.com>
Date: Thu, 23 Apr 2026 10:56:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v9 2/2] x86/tlb: skip redundant sync IPIs for native
 TLB flush
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: peterz@infradead.org, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260420030851.6735-1-lance.yang@linux.dev>
 <20260420030851.6735-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260420030851.6735-3-lance.yang@linux.dev>
X-Rspamd-Server: rspam10
X-Stat-Signature: kiknhxj4cwdx74d7p6tq9bubu66i695k
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AAF240008
X-HE-Tag: 1776966973-687767
X-HE-Meta: U2FsdGVkX19PSi08pTRRAXG9M4pMoWbm6MhmY9x14abx9YSQb+5KwFxrCHo8rURKe79uVL64m8vJ8LhTjnb1QQSbrThEUPQNeKCUO6QbBbIrndc5dB1W0GFV0OByueReq2L7sylrjCK2Qh9Nu9awiRsuSJ7MOyl7E00zFEOjXouTBFUjMoROvjiPqk4A0WCk8rb8PQ51OZHraqHwzhKcKllOcJAxmYGlDqYpe/19BraR8PK4aBRvW0kKdjpNi4D1Xg2hZ0Cv4VnYr8vzflc/DTKZvDmDtbgHGaVrFY5mGTKOIVnqMqb0NXEBoos6IBFP0NggLz9yzlHiHmNJRAjV9jJr/Uu44o7gIAmoloJIQORRYGJxNLCLyThgy/XdYv+aS6o4A1T/yX2QzHd3lusVVrcX+yAJfKnPB1xtsjDxam9v6sY/1XTZxkaEC5Dm9s04Aw28A2R3M8Op6oRPT3WCzt2Y3d8lF6ZcW+6gNK2IgxDi7gB0vLdqIutdWC6tcfZ8Nv3JILNhHvr6e6cw8LlfdvSdj95VK6iv/uT6a8Z64qWe52cd3g3iF5RDuvrsDPMCp8+9FD9MlrGDVGdyAY1hkjnVtoZvZeSwLZ4T5A8T9DKuE3WwD9/8UUZzESmjCVOjXtU88LNmJAH1VD272BRUELKhUQBNEFtzo2UT9SVL5ttnb2uHdzPdhhMEteMqUjyD+sydHybrf3OAyJ0Cwx0uGxhJuCYD2Ovn4Y8QODl7NX8yT9vIUt1DNUiuXK3/gf/kiph85VaNFeoemTM6NWUSKAlyd2ChEBjmoeSbLzsSJKO6F8XKgqg0w2Ga68eXZPdmqtov1pMeRZSMf+CMgMZ4h76qoNYqmBJJ11iWzOYcyOq5NxF7VTFOwE+IYlwPg89JBCUm7X9hOti78OGldCJPjJIm9JWu3koQ2pYFIJkOKQGzKBSfeTo5JO9PExmYnFLhqFt2cJICY7XOcq2/2xl
 KEvPBSkc
 f+4Hij5UK8PSctPUdPy5Q/o0eYxBPzJ3BeIebsVkJAInjVmKAF2VBQyvtNYAQE6J/ZwX4qZ/3QJLdPhn3sUPIhrwNHRuME5V+vFTCOS2zE6H34Bj2F51/LGafQkAgde8nxzNSJIWXEnznSQsRZKhHhxfLDh/v2fJsRVm03YYtm+saBxdCnz+/vBguCMUsuBPD1kwnNCh4WxcsQeIH8qltsTeW84UY/opY27rE+sz8plIIt4iVP8/UAp0HJCZoB32YfqPGcyd0Iy0fk7xn+GyfkzQKl3Bx2RrkKVJxOKPAVDw3PrCZoSbl+zTRYNPN0jiYu/ggGunaqbqP0eC5uvEpj8bjbVhDoUpRp9vvc+mbVmfpUkhb5Bth8WsDZ39flSMVBg+7unp/sigWikgAJh4pFEsl6uTrPV7sG87ETHYMcS/KjUHeqTEGg8S9RROoW9nKUhVI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------TpncX0p2dB2Ohe6Tw0NCcsID
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/26 20:08, Lance Yang wrote:
> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
> +	/*
> +	 * Treat unshared_tables just like freed_tables, such that lazy-TLB
> +	 * CPUs also receive IPIs during unsharing of page tables, allowing
> +	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
> +	 */
> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
> +			   tlb->freed_tables || tlb->unshared_tables);
>  }

I've been staring at this trying to make sense of it for too long.

Right now, flush_tlb_mm_range() literally has an argument named
"freed_tables" and "tlb->freed_tables" is passed there. That seems
totally sane. It's 100% straightforward to follow.

But it makes zero logical sense to me to now mix "tlb->unshared_tables"
in there. Sure, what you _want_ is the freed_tables==1 behavior from
tlb->unshared_tables==1, and this obviously hacks that in there, but
it's not explained well enough and not maintainable like this. IOW, it's
still just hack.

I think what's happened here is that info->freed_tables is being
modified from being strictly related to page table freeing, and moved
over to a bit which tells TLB flushing implementations whether they can
respect CPUs in lazy TLB mode.

It's mentioned in the comment, but then ever reflected into the code.

Shouldn't we be doing something like the attached patch? Look at how
that maps over to the flushing side, like in the hyperv code:

> -       bool do_lazy = !info->freed_tables;
> +       bool do_lazy = !info->wake_lazy_cpus;
>  
>         trace_hyperv_mmu_flush_tlb_multi(cpus, info);
>  
> @@ -198,7 +198,7 @@ static u64 hyperv_flush_tlb_others_ex(co
>  
>         flush->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
>         nr_bank = cpumask_to_vpset_skip(&flush->hv_vp_set, cpus,
> -                       info->freed_tables ? NULL : cpu_is_lazy);
> +                       info->wake_lazy_cpus ? NULL : cpu_is_lazy);

That even makes the hyperv code easier to read over what was there
before, IMNHO.

Thoughts?
--------------TpncX0p2dB2Ohe6Tw0NCcsID
Content-Type: text/x-patch; charset=UTF-8;
 name="flush_tlb_mm_range-lazy.patch"
Content-Disposition: attachment; filename="flush_tlb_mm_range-lazy.patch"
Content-Transfer-Encoding: base64

CgotLS0KCiBiL2FyY2gveDg2L2h5cGVydi9tbXUuYyAgICAgICAgICAgfCAgICA0ICsrLS0K
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGxiLmggICAgICB8ICAgMTEgKysrKysrKysrKy0K
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGxiZmx1c2guaCB8ICAgIDQgKystLQogYi9hcmNo
L3g4Ni9tbS90bGIuYyAgICAgICAgICAgICAgIHwgICAyOSArKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLQogNCBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAyMSBkZWxl
dGlvbnMoLSkKCmRpZmYgLXB1TiBhcmNoL3g4Ni9tbS90bGIuY35mbHVzaF90bGJfbW1fcmFu
Z2UtbGF6eSBhcmNoL3g4Ni9tbS90bGIuYwotLS0gYS9hcmNoL3g4Ni9tbS90bGIuY35mbHVz
aF90bGJfbW1fcmFuZ2UtbGF6eQkyMDI2LTA0LTIzIDEwOjM3OjQ5Ljc0NTgzOTIyNCAtMDcw
MAorKysgYi9hcmNoL3g4Ni9tbS90bGIuYwkyMDI2LTA0LTIzIDEwOjQ1OjI1LjY3MDg4MDIy
NiAtMDcwMApAQCAtMTMzOSwxNiArMTMzOSwxMiBAQCBTVEFUSUNfTk9QViB2b2lkIG5hdGl2
ZV9mbHVzaF90bGJfbXVsdGkoCiAJCQkJKGluZm8tPmVuZCAtIGluZm8tPnN0YXJ0KSA+PiBQ
QUdFX1NISUZUKTsKIAogCS8qCi0JICogSWYgbm8gcGFnZSB0YWJsZXMgd2VyZSBmcmVlZCwg
d2UgY2FuIHNraXAgc2VuZGluZyBJUElzIHRvCi0JICogQ1BVcyBpbiBsYXp5IFRMQiBtb2Rl
LiBUaGV5IHdpbGwgZmx1c2ggdGhlIENQVSB0aGVtc2VsdmVzCi0JICogYXQgdGhlIG5leHQg
Y29udGV4dCBzd2l0Y2guCi0JICoKLQkgKiBIb3dldmVyLCBpZiBwYWdlIHRhYmxlcyBhcmUg
Z2V0dGluZyBmcmVlZCwgd2UgbmVlZCB0byBzZW5kIHRoZQotCSAqIElQSSBldmVyeXdoZXJl
LCB0byBwcmV2ZW50IENQVXMgaW4gbGF6eSBUTEIgbW9kZSBmcm9tIHRyaXBwaW5nCi0JICog
dXAgb24gdGhlIG5ldyBjb250ZW50cyBvZiB3aGF0IHVzZWQgdG8gYmUgcGFnZSB0YWJsZXMs
IHdoaWxlCi0JICogZG9pbmcgYSBzcGVjdWxhdGl2ZSBtZW1vcnkgYWNjZXNzLgorCSAqIFNp
bXBsZSBUTEIgZmx1c2hlcyBjYW4gYXZvaWQgc2VuZGluZyBJUElzIHRvIENQVXMgaW4gbGF6
eQorCSAqIFRMQiBtb2RlLiBCdXQgc29tZSBvcGVyYXRpb25zIGxpa2UgZnJlZWluZyBwYWdl
IHRhYmxlcworCSAqIGNvdWxkIGxlYXZlIGRhbmdlcm91cyBzdGF0ZSBpbiBwYWdpbmcgc3Ry
dWN0dXJlIGNhY2hlcy4KKwkgKiBTZW5kIElQSXMgZXZlbiB0byBsYXp5IENQVXMgd2hlbiBu
ZWNlc3NhcnkuCiAJICovCi0JaWYgKGluZm8tPmZyZWVkX3RhYmxlcyB8fCBtbV9pbl9hc2lk
X3RyYW5zaXRpb24oaW5mby0+bW0pKQorCWlmIChpbmZvLT53YWtlX2xhenlfY3B1cyB8fCBt
bV9pbl9hc2lkX3RyYW5zaXRpb24oaW5mby0+bW0pKQogCQlvbl9lYWNoX2NwdV9tYXNrKGNw
dW1hc2ssIGZsdXNoX3RsYl9mdW5jLCAodm9pZCAqKWluZm8sIHRydWUpOwogCWVsc2UKIAkJ
b25fZWFjaF9jcHVfY29uZF9tYXNrKHNob3VsZF9mbHVzaF90bGIsIGZsdXNoX3RsYl9mdW5j
LApAQCAtMTM4MSw3ICsxMzc3LDcgQEAgc3RhdGljIERFRklORV9QRVJfQ1BVKHVuc2lnbmVk
IGludCwgZmx1cwogCiBzdGF0aWMgc3RydWN0IGZsdXNoX3RsYl9pbmZvICpnZXRfZmx1c2hf
dGxiX2luZm8oc3RydWN0IG1tX3N0cnVjdCAqbW0sCiAJCQl1bnNpZ25lZCBsb25nIHN0YXJ0
LCB1bnNpZ25lZCBsb25nIGVuZCwKLQkJCXVuc2lnbmVkIGludCBzdHJpZGVfc2hpZnQsIGJv
b2wgZnJlZWRfdGFibGVzLAorCQkJdW5zaWduZWQgaW50IHN0cmlkZV9zaGlmdCwgYm9vbCB3
YWtlX2xhenlfY3B1cywKIAkJCXU2NCBuZXdfdGxiX2dlbikKIHsKIAlzdHJ1Y3QgZmx1c2hf
dGxiX2luZm8gKmluZm8gPSB0aGlzX2NwdV9wdHIoJmZsdXNoX3RsYl9pbmZvKTsKQEAgLTE0
MDgsNyArMTQwNCw3IEBAIHN0YXRpYyBzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gKmdldF9mbHVz
aF8KIAlpbmZvLT5lbmQJCT0gZW5kOwogCWluZm8tPm1tCQk9IG1tOwogCWluZm8tPnN0cmlk
ZV9zaGlmdAk9IHN0cmlkZV9zaGlmdDsKLQlpbmZvLT5mcmVlZF90YWJsZXMJPSBmcmVlZF90
YWJsZXM7CisJaW5mby0+d2FrZV9sYXp5X2NwdXMJPSB3YWtlX2xhenlfY3B1czsKIAlpbmZv
LT5uZXdfdGxiX2dlbgk9IG5ld190bGJfZ2VuOwogCWluZm8tPmluaXRpYXRpbmdfY3B1CT0g
c21wX3Byb2Nlc3Nvcl9pZCgpOwogCWluZm8tPnRyaW1fY3B1bWFzawk9IDA7CkBAIC0xNDI3
LDcgKzE0MjMsNyBAQCBzdGF0aWMgdm9pZCBwdXRfZmx1c2hfdGxiX2luZm8odm9pZCkKIAog
dm9pZCBmbHVzaF90bGJfbW1fcmFuZ2Uoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVk
IGxvbmcgc3RhcnQsCiAJCQkJdW5zaWduZWQgbG9uZyBlbmQsIHVuc2lnbmVkIGludCBzdHJp
ZGVfc2hpZnQsCi0JCQkJYm9vbCBmcmVlZF90YWJsZXMpCisJCQkJYm9vbCB3YWtlX2xhenlf
Y3B1cykKIHsKIAlzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gKmluZm87CiAJaW50IGNwdSA9IGdl
dF9jcHUoKTsKQEAgLTE0MzYsNyArMTQzMiw3IEBAIHZvaWQgZmx1c2hfdGxiX21tX3Jhbmdl
KHN0cnVjdCBtbV9zdHJ1Y3QKIAkvKiBUaGlzIGlzIGFsc28gYSBiYXJyaWVyIHRoYXQgc3lu
Y2hyb25pemVzIHdpdGggc3dpdGNoX21tKCkuICovCiAJbmV3X3RsYl9nZW4gPSBpbmNfbW1f
dGxiX2dlbihtbSk7CiAKLQlpbmZvID0gZ2V0X2ZsdXNoX3RsYl9pbmZvKG1tLCBzdGFydCwg
ZW5kLCBzdHJpZGVfc2hpZnQsIGZyZWVkX3RhYmxlcywKKwlpbmZvID0gZ2V0X2ZsdXNoX3Rs
Yl9pbmZvKG1tLCBzdGFydCwgZW5kLCBzdHJpZGVfc2hpZnQsIHdha2VfbGF6eV9jcHVzLAog
CQkJCSAgbmV3X3RsYl9nZW4pOwogCiAJLyoKQEAgLTE1MjgsMTAgKzE1MjQsMTEgQEAgc3Rh
dGljIHZvaWQga2VybmVsX3RsYl9mbHVzaF9yYW5nZShzdHJ1Ywogdm9pZCBmbHVzaF90bGJf
a2VybmVsX3JhbmdlKHVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgZW5kKQog
ewogCXN0cnVjdCBmbHVzaF90bGJfaW5mbyAqaW5mbzsKKwlib29sIHdha2VfbGF6eV9jcHVz
ID0gZmFsc2U7CiAKIAlndWFyZChwcmVlbXB0KSgpOwogCi0JaW5mbyA9IGdldF9mbHVzaF90
bGJfaW5mbyhOVUxMLCBzdGFydCwgZW5kLCBQQUdFX1NISUZULCBmYWxzZSwKKwlpbmZvID0g
Z2V0X2ZsdXNoX3RsYl9pbmZvKE5VTEwsIHN0YXJ0LCBlbmQsIFBBR0VfU0hJRlQsIHdha2Vf
bGF6eV9jcHVzLAogCQkJCSAgVExCX0dFTkVSQVRJT05fSU5WQUxJRCk7CiAKIAlpZiAoaW5m
by0+ZW5kID09IFRMQl9GTFVTSF9BTEwpCkBAIC0xNzA4LDEwICsxNzA1LDEwIEBAIEVYUE9S
VF9TWU1CT0xfRk9SX0tWTShfX2ZsdXNoX3RsYl9hbGwpOwogdm9pZCBhcmNoX3RsYmJhdGNo
X2ZsdXNoKHN0cnVjdCBhcmNoX3RsYmZsdXNoX3VubWFwX2JhdGNoICpiYXRjaCkKIHsKIAlz
dHJ1Y3QgZmx1c2hfdGxiX2luZm8gKmluZm87Ci0KKwlib29sIHdha2VfbGF6eV9jcHVzID0g
ZmFsc2U7CiAJaW50IGNwdSA9IGdldF9jcHUoKTsKIAotCWluZm8gPSBnZXRfZmx1c2hfdGxi
X2luZm8oTlVMTCwgMCwgVExCX0ZMVVNIX0FMTCwgMCwgZmFsc2UsCisJaW5mbyA9IGdldF9m
bHVzaF90bGJfaW5mbyhOVUxMLCAwLCBUTEJfRkxVU0hfQUxMLCAwLCB3YWtlX2xhenlfY3B1
cywKIAkJCQkgIFRMQl9HRU5FUkFUSU9OX0lOVkFMSUQpOwogCS8qCiAJICogZmx1c2hfdGxi
X211bHRpKCkgaXMgbm90IG9wdGltaXplZCBmb3IgdGhlIGNvbW1vbiBjYXNlIGluIHdoaWNo
IG9ubHkKZGlmZiAtcHVOIGFyY2gveDg2L2luY2x1ZGUvYXNtL3RsYmZsdXNoLmh+Zmx1c2hf
dGxiX21tX3JhbmdlLWxhenkgYXJjaC94ODYvaW5jbHVkZS9hc20vdGxiZmx1c2guaAotLS0g
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90bGJmbHVzaC5ofmZsdXNoX3RsYl9tbV9yYW5nZS1s
YXp5CTIwMjYtMDQtMjMgMTA6Mzg6MDIuMDg4Mjk1ODIwIC0wNzAwCisrKyBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3RsYmZsdXNoLmgJMjAyNi0wNC0yMyAxMDozOTo0MC45Nzk5NjU4NjMg
LTA3MDAKQEAgLTI0Nyw3ICsyNDcsNyBAQCBzdHJ1Y3QgZmx1c2hfdGxiX2luZm8gewogCXU2
NAkJCW5ld190bGJfZ2VuOwogCXVuc2lnbmVkIGludAkJaW5pdGlhdGluZ19jcHU7CiAJdTgJ
CQlzdHJpZGVfc2hpZnQ7Ci0JdTgJCQlmcmVlZF90YWJsZXM7CisJdTgJCQl3YWtlX2xhenlf
Y3B1czsKIAl1OAkJCXRyaW1fY3B1bWFzazsKIH07CiAKQEAgLTMzNyw3ICszMzcsNyBAQCBz
dGF0aWMgaW5saW5lIGJvb2wgbW1faW5fYXNpZF90cmFuc2l0aW9uCiBleHRlcm4gdm9pZCBm
bHVzaF90bGJfYWxsKHZvaWQpOwogZXh0ZXJuIHZvaWQgZmx1c2hfdGxiX21tX3JhbmdlKHN0
cnVjdCBtbV9zdHJ1Y3QgKm1tLCB1bnNpZ25lZCBsb25nIHN0YXJ0LAogCQkJCXVuc2lnbmVk
IGxvbmcgZW5kLCB1bnNpZ25lZCBpbnQgc3RyaWRlX3NoaWZ0LAotCQkJCWJvb2wgZnJlZWRf
dGFibGVzKTsKKwkJCQlib29sIHdha2VfbGF6eV9jcHVzKTsKIGV4dGVybiB2b2lkIGZsdXNo
X3RsYl9rZXJuZWxfcmFuZ2UodW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBl
bmQpOwogCiBzdGF0aWMgaW5saW5lIHZvaWQgZmx1c2hfdGxiX3BhZ2Uoc3RydWN0IHZtX2Fy
ZWFfc3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgYSkKZGlmZiAtcHVOIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL3RsYi5ofmZsdXNoX3RsYl9tbV9yYW5nZS1sYXp5IGFyY2gveDg2L2luY2x1
ZGUvYXNtL3RsYi5oCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RsYi5ofmZsdXNoX3Rs
Yl9tbV9yYW5nZS1sYXp5CTIwMjYtMDQtMjMgMTA6NDc6MDEuMjIxNDgzODc4IC0wNzAwCisr
KyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RsYi5oCTIwMjYtMDQtMjMgMTA6NDk6MjYuNzQ2
OTg1NjE2IC0wNzAwCkBAIC0xNCwxMyArMTQsMjIgQEAgc3RhdGljIGlubGluZSB2b2lkIHRs
Yl9mbHVzaChzdHJ1Y3QgbW11XwogewogCXVuc2lnbmVkIGxvbmcgc3RhcnQgPSAwVUwsIGVu
ZCA9IFRMQl9GTFVTSF9BTEw7CiAJdW5zaWduZWQgaW50IHN0cmlkZV9zaGlmdCA9IHRsYl9n
ZXRfdW5tYXBfc2hpZnQodGxiKTsKKwlib29sIHdha2VfbGF6eV9jcHVzOwogCiAJaWYgKCF0
bGItPmZ1bGxtbSAmJiAhdGxiLT5uZWVkX2ZsdXNoX2FsbCkgewogCQlzdGFydCA9IHRsYi0+
c3RhcnQ7CiAJCWVuZCA9IHRsYi0+ZW5kOwogCX0KIAotCWZsdXNoX3RsYl9tbV9yYW5nZSh0
bGItPm1tLCBzdGFydCwgZW5kLCBzdHJpZGVfc2hpZnQsIHRsYi0+ZnJlZWRfdGFibGVzKTsK
KwkvKgorCSAqIEVuc3VyZSBhbGwgcGFnaW5nIHN0cnVjdHVyZSBjYWNoZXMgb24gYWxsIENQ
VXMgYXJlIGZsdXNoZWQKKwkgKiB3aGVuIGZyZWVpbmcgcGFnZSB0YWJsZXMuIE90aGVyd2lz
ZSwgYSBsYXp5IENQVSBtaWdodCB3YWtlCisJICogdXAgYW5kIHN0YXJ0IHdhbGtpbmcgcHJl
dmlvdXNseS1mcmVlZCBwYWdlIHRhYmxlcyBhbmQKKwkgKiBjYWNoaW5nIGdhcmJhZ2UuCisJ
ICovCisJd2FrZV9sYXp5X2NwdXMgPSB0bGItPmZyZWVkX3RhYmxlczsKKworCWZsdXNoX3Rs
Yl9tbV9yYW5nZSh0bGItPm1tLCBzdGFydCwgZW5kLCBzdHJpZGVfc2hpZnQsIHdha2VfbGF6
eV9jcHVzKTsKIH0KIAogc3RhdGljIGlubGluZSB2b2lkIGludmxwZyh1bnNpZ25lZCBsb25n
IGFkZHIpCmRpZmYgLXB1TiBhcmNoL3g4Ni9oeXBlcnYvbW11LmN+Zmx1c2hfdGxiX21tX3Jh
bmdlLWxhenkgYXJjaC94ODYvaHlwZXJ2L21tdS5jCi0tLSBhL2FyY2gveDg2L2h5cGVydi9t
bXUuY35mbHVzaF90bGJfbW1fcmFuZ2UtbGF6eQkyMDI2LTA0LTIzIDEwOjUzOjA1LjI1MTI2
ODkxMSAtMDcwMAorKysgYi9hcmNoL3g4Ni9oeXBlcnYvbW11LmMJMjAyNi0wNC0yMyAxMDo1
MzoyOC42MjIxNTYxMjEgLTA3MDAKQEAgLTYzLDcgKzYzLDcgQEAgc3RhdGljIHZvaWQgaHlw
ZXJ2X2ZsdXNoX3RsYl9tdWx0aShjb25zdAogCXN0cnVjdCBodl90bGJfZmx1c2ggKmZsdXNo
OwogCXU2NCBzdGF0dXM7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKLQlib29sIGRvX2xhenkg
PSAhaW5mby0+ZnJlZWRfdGFibGVzOworCWJvb2wgZG9fbGF6eSA9ICFpbmZvLT53YWtlX2xh
enlfY3B1czsKIAogCXRyYWNlX2h5cGVydl9tbXVfZmx1c2hfdGxiX211bHRpKGNwdXMsIGlu
Zm8pOwogCkBAIC0xOTgsNyArMTk4LDcgQEAgc3RhdGljIHU2NCBoeXBlcnZfZmx1c2hfdGxi
X290aGVyc19leChjbwogCiAJZmx1c2gtPmh2X3ZwX3NldC5mb3JtYXQgPSBIVl9HRU5FUklD
X1NFVF9TUEFSU0VfNEs7CiAJbnJfYmFuayA9IGNwdW1hc2tfdG9fdnBzZXRfc2tpcCgmZmx1
c2gtPmh2X3ZwX3NldCwgY3B1cywKLQkJCWluZm8tPmZyZWVkX3RhYmxlcyA/IE5VTEwgOiBj
cHVfaXNfbGF6eSk7CisJCQlpbmZvLT53YWtlX2xhenlfY3B1cyA/IE5VTEwgOiBjcHVfaXNf
bGF6eSk7CiAJaWYgKG5yX2JhbmsgPCAwKQogCQlyZXR1cm4gSFZfU1RBVFVTX0lOVkFMSURf
UEFSQU1FVEVSOwogCl8K

--------------TpncX0p2dB2Ohe6Tw0NCcsID--

