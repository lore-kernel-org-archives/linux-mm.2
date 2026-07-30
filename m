Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E37C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831846B0098; Thu, 30 Jul 2026 16:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1986B0099; Thu, 30 Jul 2026 16:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC8C6B009B; Thu, 30 Jul 2026 16:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E696B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:42:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D43C8026F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:42:37 +0000 (UTC)
X-FDA: 85046616354.19.24C825C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C2281C000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:42:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F1Dxgz0L;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785444155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzyXsfKQYVbe7kXvY8Z4tL4HbFmN3e4/nufnZYtx15c=;
	b=MyVNZ3OJx6WwNXxeXgMDhn8gpg3iwRIudTp9OwsRNPtJT7rAzk3GJtkJ8XHoMtNnT3iOQB
	Gz6kbxzOHV+DS+jUOJMWOp0zZRfZS3rwkJpcVX9sGoX7DXO7jV93BweoZMM8FepoFogF5X
	r/DLzsO/areNE6J13+Eh5MUzr/3CETw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F1Dxgz0L;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785444155;
	b=A7iuB9EY5J37iEKO1ao5tg2tmKNMPfnSd2DletzmmEeh6fc2WetB+JxmoURVQZs/pXUwQi
	4UakFh/WzgRonn5qrhaQD8wLDw734c1KaLMC5dI6Lq+sIqhdDYHTLF+tX4gmwOJwzxye13
	Z4Whjif4fPMqC0dCPX0cJK/+dNP8ntw=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso352723a91.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785444154; cv=none;
        d=google.com; s=arc-20260327;
        b=Aw8rh/gzochS2CTq8CR3+H7TWuYkuc5Y4q6O6U6dbK0QWcg6tGwxuaWgSxYVyYO0re
         2BRrU8Vxx251/8xFXv0DC7mzfj6CLQVGjyRaTCpqvfqpfezIOh0QGrWJjIMiEHPjGqxw
         dKaqNgYhFbqGBhFZumXTtzIuqflRBS2CXT2K1vnVgQcOtVCU99WSeFcWuaIwAE54Aysg
         hpeUxE1Lz6ARHrLcmwQOL0HEoORKK9qXxP314KfHtpdRGCIjzvfnp2/4vYr15BWiwINC
         bzx7zIQ8lgsla8yNv42w6NdMTFCxaNeutSD3c8DOFNN9L7YLwtTUqF6FfyW1rmSzXspM
         JyKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=tzyXsfKQYVbe7kXvY8Z4tL4HbFmN3e4/nufnZYtx15c=;
        fh=8mp8FrA6P/qchw20zH/KiRbZlBASmMH8W7wM9xw8ZRE=;
        b=ayAkpNAIoxpNzOedseiFrtC93ogfm/L2WFmK0Bb6wpqQP0sdY9kBnAb7RoOZ5bpwcK
         YiJ/hdPEnEr16qJTg0krJyt0udk28os5wSQHbbJZ3fe0jHMnS8BWl1j5vf+RkFJIAg8W
         4EmGDzJRAsQ/m4kGL1Nlp5zCGwWiYwLgFUYXmE7KxtocaUX2zG2t4+0KX6rnq+twmHbB
         WuEFsGcDxdjjOPlqQVjvjRZj6xb3KjZfZuWDgTfpMsTnDXcrjfLA+sHui1xTuwwaFxcF
         OF7Bk26g7GbCOMdRytwGL4gBezcnCYUvvexnYlKVP3weMFLFPuqSii1N6i31Uf9LouH1
         /tTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785444154; x=1786048954; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tzyXsfKQYVbe7kXvY8Z4tL4HbFmN3e4/nufnZYtx15c=;
        b=F1Dxgz0LqPNwTDrvFzkkpIwDsIyoA2vz+sRgxtSIoh3DfAUAGPYknmwhWn3SirTuOa
         zwK+NCP7i/Zy4sgZAoZTp/HuMNS0US+v6+EpLpMhxGDCywNCna8P+MmAvv6GfZtX3ke9
         wsR4mn9LjWdqGrqyoE8HAn+93kMjb7LXAdZZBJ5PD7MhB67i2H+qbUTw+WhaUX2iFYKe
         d1rD1UtYd1yrONEhPBXdxjH8gp9dfXbhCWIKK1570CB9sKh39+vedoo6LNEDg4TSw3bO
         7vlz4p+3htRaVbQGxoig1BZAOVHgMBI99IOz0KHEpRiA0vaiooGzzabx867DXk/+xP30
         YIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785444154; x=1786048954;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tzyXsfKQYVbe7kXvY8Z4tL4HbFmN3e4/nufnZYtx15c=;
        b=DAbueR0deAGXu/YgTR1+3sp23bNrxPWWWMFnyfOnaOPjVJPwZP+0Khbvrxiyl6nfmE
         Nb8z7gNkQpLg77swkOyFemY8AgHIlyC89Ua7RnqivfNBxDy4ScPCVIRwsI2ntQP4tO5V
         G001bYWqertxWlZvoXYAmLqGJ7kyRXyJLDsQk2g2yewifBl6orG1rwEBwkehCWnv++Fg
         4yBExhV0k+HRR/uGq3BfkPRxI/RrDTTv7PB94+Fl0M4diTdhqliuwJU3aFPBFon37lwJ
         o1UY8asQ7S0fBKaAqgBN220sit6eCKt8ofkslfocSx+bfLMHzPEg5FqLbjWlTKEPRPM7
         xf9Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro5hpgbPGDJ3fdBm5fNOX6/Wh7qNyLzIF4bZig2Eb7vaTAc9cYyKzz86DI2liuqMwc7O7YKPoXVNw==@kvack.org
X-Gm-Message-State: AOJu0YzEfkdevP0Zs80puEgKZyW7OGNQsWMlCWN7HaensNrnmCumWs0g
	TAsVZ4yZ/ZTzfygbPvSc0gj5jgsOjGzVOeyo0fuqtA/pdJX7uhpwuWhPsRGEKjTSdKoRToy5QdG
	ySstvrQKrweA3ZJ7uZyLxvxfhhWEIAt2BV2RXHJdR
X-Gm-Gg: AR+sD13tkQ6Rpp0JIZBAuDvKXiHeqFgUmVfxWOgMZZof7xYRrbkzbFzlDaIQ+QbzfYK
	quLtSQZDDreFIeVhRMWxHLYGlTXq9bUlm9FbwhcbptTPj6uxiGIFQ2X8Tv2bO+b9JjgW48NtgAM
	qyCOs9zoZZu0So14EQpGIYSB/bs9PPpmtuCtUZQKsFy2Mvqq8VH0Mv8ja+c/JOWovOkWzNCRkW3
	BmvnlZ9dGx2iNyPmmSg07CpnNdjTxlsuWCbrRydGA6jk57Iot72m0IqG7jik82Ysy+2jnSbBvd3
	LoWIQtCiVWfBT75S9GAnzM1t7SJJZH4UD4vxRQc8RfvCHqg/f44m6K89Ad45Op8Hl7TzNe2M0HX
	XQVTQld72SiZUOLWmkZ8Mp3eQyr0xuLyoovs=
X-Received: by 2002:a17:90a:d88d:b0:36b:bec8:94c5 with SMTP id
 98e67ed59e1d1-38f9bd790e8mr3699903a91.10.1785444153113; Thu, 30 Jul 2026
 13:42:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 13:42:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 13:42:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com> <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 13:42:32 -0700
X-Gm-Features: AUfX_mz2wy3LvLLQqF5XvT23FybAB1M_PJOCVj4Bbwu3P1vsWolBi1Qny-gSolY
Message-ID: <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2C2281C000B
X-Rspam-User: 
X-Stat-Signature: bkrpncsujm9f9gkeamouuaep5tunwddr
X-Rspamd-Server: rspam04
X-HE-Tag: 1785444155-956445
X-HE-Meta: U2FsdGVkX1/LaAhoiOyamwe6+vEyA1obwknqpKbXxj9iSXEjsac2mtCYeVozfWDRLUH1luWjQxEr6uRJPEQTUlu15iBYIEbJ7ZN24I4XryNksCRv47rAZP4sPGMztMKxOG0TaKTvMxAc+7UjG9uelORvDdeLc0uKg5G+0nTm8PB7tnoeYZ4XR3lyFiCWWb5OM/VPUD2pFEfRkwzhKouylExjO6c5eRVUfDlNjCVzXdZwknzix/p11VjdLmiS/yeB6khI/FNCje3lQiP3tgXGuHT7ZKVzzqaQ/cRH5DIDgR2TxvvQ8TJVRQSlPMco6uP68TYcwhMrq+Lrc22WwSzczS+3Rh4KvPY6tTj+j/GyoNEoceJ4zea7AF7SJEipDM7qFqCZQhWnKRyMOtgKhqYKBYNzGuFXg8LPNVLdhfERVoJjE6CuOu2jafC+xW3NZqAuDYaeIOOfrwLnrbWwMGDdWa5qRUJ/VeWBSc4jrahJFTlJkiIqOEkM74qFON2da4KdwRlYRZ+AMlEfolaS+5PI49OjRb91XGPYxrlv++6KGS1VfmFi+w2jcAg9LO9LdBa+uVJNnIiLirlnpkSAH/G5HHlGErwlyh+obbPUGB4EGVyGfkZfJBPZ179Lb5XDWREHcst93dKQ88pXg0kdZ3AdV1zn4+6Xfu65xqv0Z9hdaA1hDXSXThZCRlI+48DUyNszGqmEpx42TH9AMw5sHUQsXBNZzKcpyahTpoINmgKmu8x96MIcbZpENB13s41HdFWTxTn2mV9kmaWmvdLdzTBbNvzqZ4GJ7ZIOK7jJVmVxHlc88gakGliT2q2ekpz9BC3er02nqs9Qq4H7ONrPYuoFLTeuLEV2PuI7zjZPOFo/Np432scLp13n45W8eKzCwmB2Y8PtGEt7CLxXifCLoCAsvtL5r0nd5InDB6GiCs7puWIF4DE2Zm5iNko3mU35pnzbp6CB0/nir7zcl4camp8
 TvgODFf6
 kSjpD00sON+w0jI9ZiMiDwiEOW5v1HOdeZQEIZ3HtxJH1frL7IoASnTrjEpr3OorEkPaQvJap4jyOfKKxvzKfqXwDSPmQ3/aTj1s/0Prl+kW8aHw/PDJRMHPrpwfkmqey24r2y6iuhsJhuSkPJJ3/h8lnlssjedgrwnbxNqEQ27toL3Fbo2j1sf+0GWYUrDQnUIO8+9ibVdzkVxHgH3qtcVgsMTgBIF7hg9MfHB72FiS9PNXedtz5BGbVkIYpUMGVl7ptO7qZzz0oFetKjWxXtI6DK5VqS3aJ9ppz6asNLFcvBFikmUOmzOTHmxIXp3W6Ir4/Wjzrq0CSi2a/e1S5+cuZqIgXl71skzlA+traDeJuUSzHYTjZwL6MXNlBksA9ssX/dDavW59fjIA6zGKAg/lzN/yGvlPvE9UL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 33c9830190e2e..89cf922232920 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>>
>>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>> +static bool kvm_range_is_private(struct file *file, pgoff_t index,
>> +				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>> +{
>> +	struct inode *inode = file_inode(file);
>> +	pgoff_t last = index + nr_pages - 1;
>> +	struct maple_tree *mt;
>> +	void *entry;
>> +
>> +	if (!gmem_in_place_conversion)
>> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +
>> +	mt = &GMEM_I(inode)->attributes;
>> +	mt_for_each(mt, entry, index, last) {
>> +		if (kvm_gmem_interpret_entry(inode, entry) !=
>> +		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
>> +			return false;
>> +	}
>> +	return true;
>> +}
>>
>>   static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>   				struct file *file, gfn_t gfn, struct page *src_page,
>> @@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>
>>   	folio_unlock(folio);
>>
>> -	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE,
>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>> +	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {
>
> It's checking if a single gfn is private.
>

But with huge page support we'd need to check a range of gfns... I guess
there's the argument of not keeping complexity for the future, but in
this case it's undoing functionality for this series and probably adding
it back later.

> We can just use kvm_mem_is_private()? And it seems can be a separate patch.
>

Do you mean that this refactoring could be a separate patch? I could
refactor out kvm_range_is_private() in a separate patch, then put in the
mt_for_each() check in this patch together as part of all the rest of
the "wiring".

I considered that but it seemed like the refactoring was too small to
separate out into another patch when the mt_for_each() part is going to
be in this patch anyway.

Or, I could add an earlier patch to first replace the call to
kvm_range_has_vm_memory_attributes() with a call to check just 1 gfn,
then this wiring patch would be simpler.

Let me know what y'all think is best. Thanks!

>>   		ret = -EINVAL;
>>   		goto out_put_folio;
>>   	}

