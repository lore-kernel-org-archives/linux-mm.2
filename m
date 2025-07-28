Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D71BC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B8E6B0088; Mon, 28 Jul 2025 17:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBDB6B0089; Mon, 28 Jul 2025 17:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAE26B008A; Mon, 28 Jul 2025 17:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6286B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:19:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2786D1A03EE
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:19:52 +0000 (UTC)
X-FDA: 83714940624.26.E45303B
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 272924000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:19:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=I2QvFwLw;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753737590; a=rsa-sha256;
	cv=none;
	b=d9pbnelWZfrSrizGjIueQt3/PwknKPGQBE9yM566R3riKXuPRkjf+7TapHBXHGhKUFnqJA
	qfEM6R7IK2ZyWJNDLgKKwYZAWgXUJqoc5M2Ez8HKm9UbPWfj2ADZaVOQt5DyhX8GYN8d2J
	LU90ZAgjz145wymOrj9J9QlKHGiHLDk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=I2QvFwLw;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753737590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fk12aZ1hILTEk1VujnCvLZyceUntOHKQSLYJRpJHq1U=;
	b=gm7iBNfJDJ2Hp8xPhM42D92fzYm0+fOBqKuH7n1uUAxMldaEZTbaO1PNhIx/0kfOiSL9tr
	A6Py3R09yzIqoXmhpbYOlUyFR+3YzoyEeF+FqN0si3zkNpQLG96qYy3m+nqf3GC++Oxc9p
	ZJLU0Djn1b4nbBeB8GZNLN7jq/VRy7E=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-748e81d37a7so3265897b3a.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753737589; x=1754342389; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fk12aZ1hILTEk1VujnCvLZyceUntOHKQSLYJRpJHq1U=;
        b=I2QvFwLwtX3aPU39lmkMmtWkCkFni3lVgRJro37FqMW38ExFSoOU9FaOu6EPoWY5ZW
         hlbbEdGGo4Q8mRl1FoD4H476JvXP/g/sfUWVc8TXo1Z96AKL/BJuUe1QIfaEQF+uf36r
         vFQ1ScwC4ttw9tUFIwP0Rx6ZR7hx1+wZu26xkbsrcHXpidRnrgjUYkn3OB4RaKDob0SJ
         +JwEYpbV3Iv31Dpt/nHUOBAeVE14hwB/Qr/w9gukux1yTyZSv+jDcCBoANDScd/fcqjB
         o7b6AiAH2J1oFES+qmpEgxOdEs5wZtX3LcmKBae6a+xMUMV2KK6+5W6VmAfvRvc7ZH3a
         KLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753737589; x=1754342389;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fk12aZ1hILTEk1VujnCvLZyceUntOHKQSLYJRpJHq1U=;
        b=Azf91YtDod44TVljeQ9HA9dFdiwu5yCZp1WOzwB5fr7OAfDQUdBRAa1vuI8g2Z4McC
         W4Lh4+l2IiD00vj2yane5QrGlDnvZ41VlepIzd1ktebveWCA7iIbk2NITcf+rNqrtrxo
         HVQDYYstgBCAUe4NPjcVO4PY833p+38PgIMdgOht2zhxNKcx4LQ4biXu+Axn3sMZgmzb
         gI46hv0jU0Ex3Hc1SFn2R1YWChMLj7WSw91/lRaXQnQhrh3XpQBKAAnOYsHZQEK6fJUD
         C22zwzE8LE61Y7yf8mv7FerL56Nz0vLhVCRA1jwGkI3sr+SU/zJiD1QFTDtTv7eOY9qc
         ssOA==
X-Forwarded-Encrypted: i=1; AJvYcCX0MiAJPODfwUOf2B7KtcWt49kM0/Hffopq6aEc9bHYNbfkZKhSIjIefR9Rc6r8kBeFNQuE3JXGtQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9FKTqRPnsWwAE15mtHIURk9LntgCANKpwch2I0w2Uc+6I7BM1
	2MiTO0t9+cuLP8EhA2mFmNvZmUjxLxmAYVd75N5st8GiR7wQnDKGH4m2+GNVncaCavw=
X-Gm-Gg: ASbGncur1M3D8m7ggS2A5Vz/3v4jpy+xjfVmLO3nuL70wcy2WieWJAinPuGgLOsCteq
	7ICN85kZt5n1j9PFFwn+HrXaLV5uWOQORqhA3FbCjpNpqCKIxy0VF/wkU9o05HJ/F6B0mjrcmP5
	RgGbAC5qsObXQ8l2uQQhRxqmAEMpvIR8dogQIGwKAY7JnLmFCRZ1dS70kiWdz8f1n94EUIi1arM
	d3bnX9e6Z+Yg0akHXArk2Ektz27Jhdv8W5sk7+uSvEEC1DO4VuWiJjvjiN2nR7YkyZW0pPvheVV
	QIVM4hoTucDCLE59k5rhSGgXnyYKI+3mUDD3823/XDqspIuUNab/HHq+CObI/3V3D27m3pD6Kso
	IzRQvzqhj6pM6aJQbCyJEcSzJb4JAVcCn
X-Google-Smtp-Source: AGHT+IEnErxkfYjX+YJp8zR8qc4hw1otEJKlPu8QNYCPVpJ95RsieRy81jtW+UwHk4fD0hbvpRX7Lg==
X-Received: by 2002:a05:6a00:c89:b0:748:fcfa:8bd5 with SMTP id d2e1a72fcca58-7633636aefemr19113589b3a.3.1753737588883;
        Mon, 28 Jul 2025 14:19:48 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76408cf7759sm6272300b3a.31.2025.07.28.14.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 14:19:48 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:19:45 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "nathan@kernel.org" <nathan@kernel.org>,
	"kito.cheng@sifive.com" <kito.cheng@sifive.com>,
	"jeffreyalaw@gmail.com" <jeffreyalaw@gmail.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"charlie@rivosinc.com" <charlie@rivosinc.com>,
	"david@redhat.com" <david@redhat.com>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"conor.dooley@microchip.com" <conor.dooley@microchip.com>,
	"bjorn@rivosinc.com" <bjorn@rivosinc.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"nicolas.schier@linux.dev" <nicolas.schier@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"andrew@sifive.com" <andrew@sifive.com>,
	"monk.chiang@sifive.com" <monk.chiang@sifive.com>,
	"justinstitt@google.com" <justinstitt@google.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"morbo@google.com" <morbo@google.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"ved@rivosinc.com" <ved@rivosinc.com>,
	"heinrich.schuchardt@canonical.com" <heinrich.schuchardt@canonical.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"fweimer@redhat.com" <fweimer@redhat.com>,
	"surenb@google.com" <surenb@google.com>,
	"linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
	"cleger@rivosinc.com" <cleger@rivosinc.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"apatel@ventanamicro.com" <apatel@ventanamicro.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIfpcUmNtLFPd2cO@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <3d579a8c2558391ff6e33e7b45527a83aa67c7f5.camel@intel.com>
 <aIO8uSqiplnyyNOd@debug.ba.rivosinc.com>
 <a19c1338f2fa4cb19a4f8b7552ff54ded20b403a.camel@intel.com>
 <aIfOTC6CfyCsaEpv@debug.ba.rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIfOTC6CfyCsaEpv@debug.ba.rivosinc.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 272924000A
X-Stat-Signature: yhaswhrmmd4z537cqhi9xt3bqehzepna
X-HE-Tag: 1753737589-942481
X-HE-Meta: U2FsdGVkX18VDxejUrHfm0FNcyTwrcS/3Mhu6JVhzGkS4yJQp5gLjrlnBlz8ESBKhwon4jknqidkcPkZGFvI77qhMPywLODvSIZiz/wd96AgNkq6EpIW86dGsr/Q8cozFND8JPetQLZORBbNJVcmXDY7hAAtnIsW70j6Jy68QgId7BZgZvl6XR2whaZyITSjkwEwp+MZQzdO8/vTEUSdZSH/qnt/53DLt+9AdO701KQSRway9eXKc6IaA90ZpvhR4Z1IpO8UUx+A6Bo/LS5ndGRUG+tLL9nqCfieOuyvAGxZAW6lUtmkELxtJqIcv+9k88/fbToYi1dd7nJtbyQppeot9WLzjfk490YuemdQ0dnoJBGLdcs0+0eChCx479XswSrM2IsrLzg0FXQXge4yZxdh9TPhQESZl/xamDiM6OmfqaaYvXK5zXldUWjIdkwPKayAlgo4YFxf2E5tYYHLsfgNlmC1dDkYH6N/B4bxUFcbfezZvD9Gy8H/O4PwWgNp1Je1ecwwld8x41OBRdkRouQv+RAL2OTbFssFGOzepFEiTrKkR4WrwNKJwbibS0JeS+/Xb8YY/wBLmkJcsm5Q5h3dpc2V9mQetHGvyqHSHlONaJJCW20KJtXrUAGX8xxGEEcTUCTMCpR5ENXUiftSQjeQetJgWJlxVAEEkB9BKDI5guRs4QIwJhG7z+5P5xn7U9MRn8j9KkIzJZJ2KV4mx+gCkDQ+FALfLyxRoMHZ1p4LrRdDHWqa4RmCE6na4ZI44yQDQEatPzhfC2SPS9F68BG4NiCzBxA/5XandkNZg1vQYZA+5wUFYmOHdXes6sGbiC0sw7bZcOvLaHwWADYu749PMa0mQQIuS78UWPUX39AsE56v8THdcUtbGlGNi1H926Z3QkvISNSBr4Y28uVcwVW813pfiFb6xbgzeue4yc8ie9EIKWyt7ANG1ySQLCD73v/XU4GjqO4UrQN1eB0
 eYnMjUZE
 S6yWxXNUVMlRbU6qnRT3XfP0McmG7SNktuK0M7rje9RaX54y1TKP+MFS808SfxmyEGGcA1iv48YJfqH5pAyfYNOVxayVmtgGJlV5eUHsGJSLuXqu3iNF7oH6UEajvvVUHl7abWUpJqihvllRcexfsEeZt2viuVCw7mF/bJk4xQattlNqoS/kcLnEf6aR0R7NuEB/2bGDrB4IR+jpw3aaRG0jKSAGPVywA9rkJQyVl6GHq2KZPOwbRv+Ac0/f7mUzEj47+lmcNabEDLeJwiXPM+qwwIT9b2B0tR1nNQKAgGSfGWXtIslfTVW1gIEnMUJ6bH/yYu+N7ugWPxwnjF0MMjOtJ8ZRIysNo//VNU6P7QprIn6eo8udV1cYfnXAm3z4fSgdYDOhQYROTEfZ7YFzHUb4xnwPicD9UxhDj9S4X3QbXchE0Tc0Xk0R5nTsK9iU8cIxJ9LeolrbjpkcpAslMG2R/iuyCSUCK10fQJPkgbJKO93Z/Ym5sY/xhtHZeEtOQAGxUauELPP0RlfBVvNPtofuw6KD2+L9l2lWI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 12:23:56PM -0700, Deepak Gupta wrote:
>On Fri, Jul 25, 2025 at 06:05:22PM +0000, Edgecombe, Rick P wrote:
>>On Fri, 2025-07-25 at 10:19 -0700, Deepak Gupta wrote:
>>>> This doesn't update the direct map alias I think. Do you want to protect it?
>>>
>>>Yes any alternate address mapping which is writeable is a problem and dilutes
>>>the mechanism. How do I go about updating direct map ? (I pretty new to linux
>>>kernel and have limited understanding on which kernel api's to use here to
>>>unmap
>>>direct map)
>>
>>Here is some info on how it works:
>>
>>set_memory_foo() variants should (I didn't check riscv implementation, but on
>>x86) update the target addresses passed in *and* the direct map alias. And flush
>>the TLB.
>>
>>vmalloc_node_range() will just set the permission on the vmalloc alias and not
>>touch the direct map alias.
>>
>>vfree() works by trying to batch the flushing for unmap operations to avoid
>>flushing the TLB too much. When memory is unmapped in userspace, it will only
>>flush on the CPU's with that MM (process address space). But for kernel memory
>>the mappings are shared between all CPUs. So, like on a big server or something,
>>it requires way more work and distance IPIs, etc. So vmalloc will try to be
>>efficient and keep zapped mappings unflushed until it has enough to clean them
>>up in bulk. In the meantime it won't reuse that vmalloc address space.
>>
>>But this means there can also be other vmalloc aliases still in the TLB for any
>>page that gets allocated from the page allocator. If you want to be fully sure
>>there are no writable aliases, you need to call vm_unmap_aliases() each time you
>>change kernel permissions, which will do the vmalloc TLB flush immediately. Many
>>set_memory() implementations call this automatically, but it looks like not
>>riscv.
>>
>>
>>So doing something like vmalloc(), set_memory_shadow_stack() on alloc and
>>set_memory_rw(), vfree() on free is doing the expensive flush (depends on the
>>device how expensive) in a previously fast path. Ignoring the direct map alias
>>is faster. A middle ground would be to do the allocation/conversion and freeing
>>of a bunch of stacks at once, and recycle them.
>>
>>
>>You could make it tidy first and then optimize it later, or make it faster first
>>and maximally secure later. Or try to do it all at once. But there have long
>>been discussions on batching type kernel memory permission solutions. So it
>>would could be a whole project itself.
>
>Thanks Rick. Another approach I am thinking could be making vmalloc
>intrinsically aware of certain range to be security sensitive. Meaning during
>vmalloc initialization itself, it could reserve a range which is ensured to be
>not direct mapped. Whenever `PAGE_SHADOWSTACK` is requested, it always comes
>from this range (which is guaranteed to be never direct mapped).
>
>I do not expect hardware assisted shadow stack to be more than 4K in size
>(should support should 512 call-depth). A system with 30,000 active threads
>(taking a swag number here), will need 30,000 * 2 (one for guard) = 60000 pages.
>That's like ~245 MB address range. We can be conservative and have 1GB range in
>vmalloc larger range reserved for shadow stack. vmalloc ensures that this
>range's direct mappping always have read-only encoding in ptes. Sure this number
>(shadow stack range in larget vmalloc range) could be configured so that user
>can do their own trade off.
>
>Does this approach look okay?

Never mind, maintaining free/allocated list by vmalloc would be problematic
In that case this has to be something like a consumer of vmalloc, reserve a
range and do free/alloc out of that. And then it starts looking like a cache
of shadow stacks without direct mapping (as you suggested)


>
>>
>>>
>>>>
>>>> >
>>>> >   out:
>>>> > @@ -59,7 +72,7 @@ void *scs_alloc(int node)
>>>> >   	if (!s)
>>>> >   		return NULL;
>>>> >
>>>> > -	*__scs_magic(s) = SCS_END_MAGIC;
>>>> > +	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>>>> >
>>>> >   	/*
>>>> >   	 * Poison the allocation to catch unintentional accesses to
>>>> > @@ -87,6 +100,16 @@ void scs_free(void *s)
>>>> >   			return;
>>>> >
>>>> >   	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
>>>> > +	/*
>>>> > +	 * Hardware protected shadow stack is not writeable by regular
>>>> > stores
>>>> > +	 * Thus adding this back to free list will raise faults by
>>>> > vmalloc
>>>> > +	 * It needs to be writeable again. It's good sanity as well
>>>> > because
>>>> > +	 * then it can't be inadvertently accesses and if done, it will
>>>> > fault.
>>>> > +	 */
>>>> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>> > +	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
>>>>
>>>> Above you don't update the direct map permissions. So I don't think you need
>>>> this. vmalloc should flush the permissioned mapping before re-using it with
>>>> the
>>>> lazy cleanup scheme.
>>>
>>>If I didn't do this, I was getting a page fault on this vmalloc address. It
>>>directly
>>>uses first 8 bytes to add it into some list and that was the location of
>>>fault.
>>
>>Ah right! Because it is using the vfree atomic variant.
>>
>>You could create your own WQ in SCS and call vfree() in non-atomic context. If
>>you want to avoid thr set_memory_rw() on free, in the ignoring the direct map
>>case.

