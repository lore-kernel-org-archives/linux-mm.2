Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F830CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0E96B0005; Wed, 20 May 2026 17:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049AD6B0088; Wed, 20 May 2026 17:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53DF6B008A; Wed, 20 May 2026 17:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D41C66B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:44:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F7A340382
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:44:18 +0000 (UTC)
X-FDA: 84789126996.13.C847D24
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8FD8040011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:44:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N3N5dQ9T;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzeZHICde6LC2KLtrV1UyrIn4vikEEbCZhRCg7feJeA=;
	b=E1NFIt0dH5piF24FSMvbJ+J9LpEilZ8pv4+fFZfxMV4UbKRtHumgrSl049caU9clIZWgSm
	Th4N4D3V+/rHu5Rtx0Tdw1C5XBq3RpZxVT8k60lzrldvzFRmzS1AF99gCZsCyTJ3lqORWg
	Rhbwwztlx7d72qspIRPsKeTZckK2rkM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N3N5dQ9T;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779313456; a=rsa-sha256;
	cv=pass;
	b=bMk5a2HDCDBfDYArggGn2yLWRiCG8zikf2thE1f9ovw/zf18QJRSGLCwT/o75Q4szSRQBH
	AF7zWQ8JzB4VuFH6d81cZT0bHLkOiY+tD+EQ3i01EF72DGKfpqxk1t4ju2xirNAcpKeZoL
	KE0lgk736ysHeRN0hiyPZoOZP8I6IbE=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5780c38ecb8so3478004e0c.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 14:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779313455; cv=none;
        d=google.com; s=arc-20240605;
        b=WQmvDfp7Sm4VH2x0dTTU/upRE61qxUM2OWWy8aAs1Z0bs7YAqhqi6k0/K5tFkDP6Yl
         vmBImn6G19g/S7DEhmdUKLYOij+/tGXO1bTokiXQbVM3eCiBl+yXxgWY06P1L7dXhvm+
         UMa0FGE6H23t6Ci5Yy5yq1HUKlnhuI5tC0mEQAlKq5OIN7VRPHZQ5dQSbLHT/H++NFlQ
         zYqy1bN1kx+kjR/v/du/02Q8JafP5ENzUP2SDHtOj/ie1fcXs01Qx39xxr1Jhh/PhlIQ
         4CIVnzUpzwB/zrZnqN8Hyel1PGbgvJV5PgAc3AG7zl8n35Y8kDqDEl9mf4uO1InCZcQt
         61SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=lzeZHICde6LC2KLtrV1UyrIn4vikEEbCZhRCg7feJeA=;
        fh=+WtW5MKcV1+iKzcckUyyNEAVfQU/4BUFNbzK91AGdS4=;
        b=emB//ZToOEDV2dYcpHtG2C7FRxsaxVj0PWJdDX+3becfkkovvP9ODGTZCS0hcPZlMO
         n8uiotzWTFUminlqUvmRuRUvsKpoZMvIgw9E5xwJ1w6XyFObCEqzPJUFABeylC8mVFy7
         FbZN9jcVyn0DRJo0iOZ0p6v+dszuKZCSEaREIX/z6LXPphKHmw3bMHaJAlxgX1pPmILA
         aRviRuS8dRH/PJW80wRyaARyfmmqyRbABROMaQBApxKA8A+vrEd+yTQLP7rHXdyNsnxh
         0OG4WOwRnHgydc1gSqKKTMPFmkz36sv7tgMYBQAd94yK2pF+YUYjsJFQFLfdRPqAMRgB
         KOpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779313455; x=1779918255; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lzeZHICde6LC2KLtrV1UyrIn4vikEEbCZhRCg7feJeA=;
        b=N3N5dQ9TPFY8WVc/uGW13flpx38AQfvXkutcBcwuGUZUbOp50zv4D/QlcxD0w5DkEj
         GnRb7iTnac5jQZaC8+LTcuIM2wIpwRX6kQda083Ai/9BSWwrKFz/iSgYB5+6rYSbC91J
         175MDh9C1Yas6O8B8tItua9nlqrFOiD85Tl3SzWdv/11X0yn6aTwn3BcFPr8qwCFF8ro
         d1XPL9rLJaMqUaEGDnE9mrzbVBqXnN6+ax4sJR4jOAdOitS3MKeS4EbcmJvhgNvvwzXn
         vpPOkt0mg5SQqP5EV1+l6AHhPj+f6LbxQwibSGj7LVp+9eqYD01PoboCNkCKPHlSsLA9
         B1HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779313455; x=1779918255;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lzeZHICde6LC2KLtrV1UyrIn4vikEEbCZhRCg7feJeA=;
        b=MHBvKae37uTOj+pf4HZXXE7JLM1grsBlJZ5RYNVJQFTkfrKQJAmSMgTH1Wptt/P3Vi
         5TSYc/W+GjQCXbzPl3GEV/N0tauMDZgYsPZ5rq3+efm2/HHMtPzb7ungtwYEOzbvzuQW
         XaepCm4YQUrmvJDjiXYj+1VocSpGHpknZ+X/rSKBpG1qETd8V0MWTDhNLgobhi/hiftB
         iv4XfghSbhmUsP8lM3wEn1g1SnHCbSJwV1+eSE+EkBPbfzeLInda59TuC0zqHt4Ldyip
         2lVUCEqrEo3SyEz539F9RJE1pDKNWW4LfwcKWsNfmyTU/8OYPi3G3GhqAgm1gPsqztQa
         LQZg==
X-Forwarded-Encrypted: i=1; AFNElJ+ZnJ4H+gqqn34NqLn5IJlkd7zzIhS/kAUn5XcMWFcsWZjA88xjvn7pFMYivbGaXQazbgfxNA5yNw==@kvack.org
X-Gm-Message-State: AOJu0Yyb91fb+/kN0cqCfu1CqfryE8ekZSDsHeOVbdKZMoWA15ewDeqB
	lsQsIF1sSxn80mEswmgWgmo/zmxqQBWKMttdSVZJdwMqauklHCSJqg513XI9X1U4+b7q8ajGx3U
	uG/j32mYtJG6cPCXz2HuBeiovLYCEHukyVZrM4Yrm
X-Gm-Gg: Acq92OHgxe9k2xZ8atsArLZ8O7BpisvjZV2vZ8pGhGG6xqWAOFhfWFoxY0Hq/7I7lXD
	/MsJbsjqk4w9POgJnDVe9j+lslkQb4ObPxW5K39qdPl61X/vsC8GCA6ff8KXGjk/NIVgJf46DHJ
	OjaEtaIn0mD3T2oOesM9tat6s1nGP8zf9DGihUeSQL//pyWK/VpzrM7O2jYLELzR7mRXbST+6x0
	y0mdUYBUIKXB6jd5CdrE3mREbCJlPQ6LwK4ic8TR/rxjIWMc+7bky6/ooF0dH3eQknOeE9GACEa
	3KbVxmb7p2+UjzviES/2eLIE6rBvKh3gCBXAKiU9CzNHF3a7UHGN3GqLjduuBEliGFj3du1aNV9
	JcSoR
X-Received: by 2002:a05:6102:32ca:b0:631:8665:3510 with SMTP id
 ada2fe7eead31-6739e54982dmr235113137.31.1779313454629; Wed, 20 May 2026
 14:44:14 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 14:44:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 14:44:13 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com> <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 20 May 2026 14:44:13 -0700
X-Gm-Features: AVHnY4KMeQgcJsvqoO4sP8lu-TRiPVeIaM4bWX0cqtV0EsssjCZBV_2_Gq2a7HM
Message-ID: <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
To: Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tz8k8qmm3uu7y1q4ihm4p1txqa18qgi8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FD8040011
X-HE-Tag: 1779313456-626765
X-HE-Meta: U2FsdGVkX1+AMUuGQ0o+sQV7rMLT4jvhQUiIPPTTR4A5tmQO3MXqIROVpty24jIAorod23923oTU5tzW2wfAnEIgsQSenG8bWFXMRojfyPikRN0hHzsnVCuMt9oA1PeehHFk9N8Gr09v27pSuzvv5UdruWyP1NlF15VmsIYyUEBpcHyLLv28Su6Ud3S/YsNxnxwkWz+G4b0PnPP4wv4UWrHZogzIT2kupugVNI1I7tGN4gTSZYJMreRtkqPjaY+ogxejASVmuNhwpjhVJvuAGirTHLXSFOze9iIKzrTX4N2t099MPI1KqCyu+4IzZs2tpA4nN09MigxmImUkC4WbKAokLAQFnRfzdS1rriaaG1O4BYMovgbGVvIaWffABVuQidCXC3dJOLNBd6bDZrPDG7fTHk0AHkxCyHQC3JdP7NT+fDD3b8FdThX4DEJ9gf4VcA+Th9Dbv80D9gF+RdynVe1aG9rVdEYOdfkBETSfucYGPj+WUYukqI4zvWFzuwuZnYGnIGAjYx4JS3VdwFesi4agDVFEI1gcBURpGu+ikZyIttM4KPs0j5UjljK5/DdtrorZktvdJcTiKVa14sL2Im7fddNT8HK+8TxVjNXm3zCAKjpdl75G2s3/kyTaqrL3zT2N/cU4+Fhjk9pVyHbw2Lb9CQcx93A0+qNkVgcakbfLQDZzfSwy1Ej4zXQu/HMUKNJHX6Pha0curqkghW3y/7p0KkcA8pfDV6RNX4RfyLxlJfMTkNGnE8Ms0TJpToTFoP4GxXq4XhkPhtCZdbpN1UOUeukp3G3UXStUSRkfVr959R5lL1oEwtiV4etxcDMxI6GcZuqqepgef+i1X4KxVA4AZ9tNGnvrwAc4YIsoSI7C5Zej5koslKyDEPaCy5sSvzMBX2ghvQTyxFiukSo+I/CxtNRLh1Yowo4v1dJp6oOy5GQNY7t3YnZcu4ukscOezsMuXdclw7fYxUc+jnS
 7D3IxUEV
 SDSRCrml//ZBE4d91vLy927QD1Fer8zLh2NPa7MwxIE1gpg/SDIX0bf4VHB34v1emtNu2tMWHtgomRJRkZd+ECaQ9i2llZgIOeRKdZRWlFsmsyLXryFpnDs8DKbZbP1T58KtVp+RqMilGb3bReaOOKKitQnepDU2T9YCYVAwsP+VVuywJWGs6ad4cqLWp4dfJnCqn4AEIi9GRyqpI50y7Li7DeNwp72EedvfohCdRAk6wB2k/eRK9BvKTBrkqUVXoYwhN2PioD0e2j9Aa0jl5tGwUIfoVaBmhCHTCcK8lGPfQVi+TjP809R2A/UskuWAwro6m+l2cica1FIjBw2iMN6qjkpqWjR6GJAgsmR64TRx7tuqqQGCsNUSX0Jf4wL2gtHHedv4+7nUJQt7bj8zQ5vEKbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

>
> [...snip...]
>
>> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>> +{
>> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>> +       struct inode *inode;
>> +
>> +       /*
>> +        * If this gfn has no associated memslot, there's no chance of the gfn
>> +        * being backed by private memory, since guest_memfd must be used for
>> +        * private memory, and guest_memfd must be associated with some memslot.
>> +        */
>> +       if (!slot)
>> +               return 0;
>> +
>> +       CLASS(gmem_get_file, file)(slot);
>> +       if (!file)
>> +               return 0;
>> +
>> +       inode = file_inode(file);
>> +
>> +       /*
>> +        * Rely on the maple tree's internal RCU lock to ensure a
>> +        * stable result. This result can become stale as soon as the
>> +        * lock is dropped, so the caller _must_ still protect
>> +        * consumption of private vs. shared by checking
>> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
>> +        * against ongoing attribute updates.
>> +        */
>> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
>> +}
>
> Doesn't this imply that all consumers of kvm_mem_is_private() should
> validate the result using mmu_lock and the invalidation sequence?

Let me know how I can improve the comment.

I think the "consumption" of private vs shared here actually means
something like "don't commit a page being faulted into page tables based
on the result of kvm_gmem_get_memory_attributes() without checking
kvm->mmu_invalidate_in_progress.", since a racing conversion may
complete before you commit.

kvm_mem_is_private() is used from these places:

1. Fault handling in KVM, like page_fault_can_be_fast(),
   kvm_mmu_faultin_pfn(), kvm_mmu_page_fault(): this already handles the
   entire mmu_lock and invalidation dance. No fault will be committed if
   a racing conversion happened after kvm_mem_is_private() but before
   the commit.

2. kvm_mmu_max_mapping_level() from recovering huge pages after
   disabling dirty logging: Other than that it can't be used with
   guest_memfd now since dirty logging can't be used with guest_memfd
   and guest_memfd memslots are not updatable, this holds mmu_lock
   throughout until the huge page recovery is done. invalidate_begin
   also involves zapping the pages in the range, so if the order of
   events is

   | Thread A                     | Thread B          |
   |------------------------------|-------------------|
   | invalidate_begin + zap       |                   |
   | update attributes maple_tree | recover huge page |
   | invalidate_end               |                   |

   Then recovering will never see the zapped pages, nothing to
   recover, no kvm_mem_is_private() lookup.

3. kvm_arch_vcpu_pre_fault_memory()

   This eventually calls kvm_tdp_mmu_page_fault(), which checks
   is_page_fault_stale(), so it does check before committing.

Were there any other calls I missed?

> sev_handle_rmp_fault() calls kvm_mem_is_private() without holding
> mmu_lock and without any retry mechanism. Is that a problem?
>

Sean already replied on your actual question separately :)

> Cheers,
> /fuad
>
>
>>
>> [...snip...]
>>

