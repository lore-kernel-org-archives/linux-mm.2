Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875CBD58E7B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5FE6B0089; Mon,  2 Mar 2026 03:22:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB12F6B008A; Mon,  2 Mar 2026 03:22:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92E76B008C; Mon,  2 Mar 2026 03:22:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAB1F6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:22:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 939808C948
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:22:53 +0000 (UTC)
X-FDA: 84500432226.12.871AC6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF998180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:22:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fi9qbBnC;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xmCrFWw+yvgcWGK2jQ5KqFcskOI+oqjYmu3aekYgIc=;
	b=htMqkeI2IbrcKe7/S4Q7Fvl5ER6pkdFcWb9XEJjj1bsdmjHjYkJyqvnUXAIWvAv5//L8jM
	pzHXcphRZ5p344Y5+2FOg9CCStGkaVNCUn56I3ec5oNbePxUspuezBKP6R5z7RE2DMpdQk
	AYK/3dUIUR+XBRLWvrb7UWvHZJ6Xp/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772439771; a=rsa-sha256;
	cv=none;
	b=vxe+Vkf1/1OlVgtuZ/2ZifGiJURinxhghZvsUYp7YPLRj2cQAQ3rLOEJUfgxFjYBeBE1iU
	3oLH+GtcZvBeOwmDu4npKEAh/rHuN90l4DMVzPL4sQ/K4un7SwCFVoDSvXMo4u8MRq5Amk
	sJut8U1B47uqUhMmKT/xkR1n1l62X3o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fi9qbBnC;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E055060018;
	Mon,  2 Mar 2026 08:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6CDC19423;
	Mon,  2 Mar 2026 08:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772439770;
	bh=XDKJkaVhQfYzVUj3ho/S80emIEXa893QeTlONkL4P1o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fi9qbBnCFSKTVd+ug21vuDlAi7DzRlnYMKJGAuXRQMzE43DC/DTPknV2/delTOlUN
	 QA6XFh+xbVpMSMVu51hR58tTjm2Oi+IHTYmtFOwTUz5kDyM25Bv/CD47bqGImWTsGA
	 Xx72UDJWQsYLHva66lVFR8w9EI6Q89wXI+87ro6UBqUVlO+W+Ve83utQ2uC8cfvToG
	 +aD3dO+R2rZlEoqF7GuvEI+/NyO4JvLmd7EEDzu5pE/jvuvgfFLXABqTen2akk4FTT
	 DHeWQN6tlgkQkbPQc02rL0mxOhVrxxRN8s7xO8qmNmz7FGmJaFy7IU4+i7AcWW0zxM
	 u8BBuqn/3yaqA==
Message-ID: <15fcc4f9-a2e8-4979-8e67-6a9c9cc86740@kernel.org>
Date: Mon, 2 Mar 2026 09:22:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 14/16] mm: rename zap_page_range_single() to
 zap_vma_range()
To: Alice Ryhl <aliceryhl@google.com>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-15-david@kernel.org> <aaLjK2Q2q5ghE-uE@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaLjK2Q2q5ghE-uE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: n4oz53itetfud91gbdmahusbgzc48j3c
X-Rspamd-Queue-Id: DF998180008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772439771-644986
X-HE-Meta: U2FsdGVkX18e6hcPXuI+tzVe/ZKSR3zMqTmMYNZcEuj4cthEuAlBKLY4718K5IPpbop5IoY1kQnaFt5m5JzhJnCEgdWqCz/WNmZJPVN/R/tcy+gj/tDBt5p46fhMABUZJUybNSaWPstvKboIrwGhXyAYWnGauhOb+uWbnlE2R8za7gWg6ASKXt+slvPAihRezePDZX6rAsqZ+kYIEO2kW9CooVG5Z/9gquSYShDl+rWXt5YLNqE49uZkwOwT7FE0nHwk6fyaaI6NoCzZf2E/C8EWvm5r6/Wx17qRhqS9YnJlaD8oddo9uBf7apHVgtxrUv2Se+ZD5Xp8T1l7RnuNvp5ISfX8ml7oYnpy1IKnoRaKGYymGnkXYBIcVDSNyGtO37h4w0Z2tUNyQb+ZQUojwUV14/cOwyvjzeKoYqG7gctUwWCWFM05QI2nZ9yutKdS+cLNGqSLmo0Soz9NApQO8j260MrDd7wWF/bHXJjHE2tk/4nAW0GZtRzQfYhJuvsvQSNJt1GZAIchk+6lJ0MdSB8hHYmnt382AXHnIBuZOqkR+OvhIt7ZDv/tBTGD6bm0Ll+P7KRq7LzlNlWNv+BN3lqia5zAhw4a77tr+7fy0W6BftkaYYhxZRI5J43watGImQSO5tVw2FglGK0pbhWsKI+/SLxKQRateNrnWa3srm90BSrVgaigrcyMHwocGmUyTaZo8zS/dLyhBEjtS1NQP0xWwrLCvXEeSd2x4IuBNgSEj+8xYWCSSP3v20snl/T1ulA8mKrzHi1Q2w3hdQmsi8b/xHre+zS4SYVV/LcydoEgAzt+HNCpeVhhoCFItE/1Q6rdtVcmrOoRY59uwomAnh/r1e0V4ypUvWG3KG0GZluqEtAOlslqYZujf+qbTO4WbvfYNOUlCRboCMQpr3SO/iIzKJ6QSVwRGc4iJx3mNYuWWSTqXbfZ9Y2uWUVwO118A/3B0Qn17ClR8OIYg9Y
 mziowze8
 bjaddSKdQkFm4wd2dTufAEF6jRLZVDI9SxAR3idtAVcmlanvucdFNrQ7/d8RDcTpRN6Cg+pmLlN89fRf+RGmLN/6cWeC/mJ25jKmk2MzybCcUdBjwiA7T/zdMnXDT0rKPbF2CArFpiUTjoPOjpYKG0xkogN5MXcE6JTLp8njVHsNjytDYPFswFxkAPqFGDeWovOtB0Fniw/GXm/8gLk1Dy9qk6zBD/yzNzWMSjOuE8AbsfVBp8Vc6ZHT2awnMliGVTZf7qcXwJPSfFAuY/weSKY+tcqtFbjSDUWcxvIbfPWnTZBTTwCQGWUKuAwF1B2+JbzwXFE3Cnfn8sVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/28/26 13:44, Alice Ryhl wrote:
> On Fri, Feb 27, 2026 at 09:08:45PM +0100, David Hildenbrand (Arm) wrote:
>> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
>> index fdd97112ef5c..2fddd4ed8d4c 100644
>> --- a/drivers/android/binder/page_range.rs
>> +++ b/drivers/android/binder/page_range.rs
>> @@ -130,7 +130,7 @@ pub(crate) struct ShrinkablePageRange {
>>      pid: Pid,
>>      /// The mm for the relevant process.
>>      mm: ARef<Mm>,
>> -    /// Used to synchronize calls to `vm_insert_page` and `zap_page_range_single`.
>> +    /// Used to synchronize calls to `vm_insert_page` and `zap_vma_range`.
>>      #[pin]
>>      mm_lock: Mutex<()>,
>>      /// Spinlock protecting changes to pages.
>> @@ -719,7 +719,7 @@ fn drop(self: Pin<&mut Self>) {
>>  
>>      if let Some(vma) = mmap_read.vma_lookup(vma_addr) {
>>          let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
>> -        vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
>> +        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
>>      }
> 
> LGTM. Be aware that this will have a merge conflict with patches
> currently in char-misc-linus that are scheduled to land in an -rc.

Thanks. @Andrew will likely run into that when rebasing, where we can fix it up.

> 
>> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
>> index dd2046bd5cde..e4488ad86a65 100644
>> --- a/drivers/android/binder_alloc.c
>> +++ b/drivers/android/binder_alloc.c
>> @@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>>  	if (vma) {
>>  		trace_binder_unmap_user_start(alloc, index);
>>  
>> -		zap_page_range_single(vma, page_addr, PAGE_SIZE);
>> +		zap_vma_range(vma, page_addr, PAGE_SIZE);
>>  
>>  		trace_binder_unmap_user_end(alloc, index);
> 
> LGTM.
> 
>> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
>> index b8e59e4420f3..04b3cc925d67 100644
>> --- a/rust/kernel/mm/virt.rs
>> +++ b/rust/kernel/mm/virt.rs
>> @@ -113,7 +113,7 @@ pub fn end(&self) -> usize {
>>      /// kernel goes further in freeing unused page tables, but for the purposes of this operation
>>      /// we must only assume that the leaf level is cleared.
>>      #[inline]
>> -    pub fn zap_page_range_single(&self, address: usize, size: usize) {
>> +    pub fn zap_vma_range(&self, address: usize, size: usize) {
>>          let (end, did_overflow) = address.overflowing_add(size);
>>          if did_overflow || address < self.start() || self.end() < end {
>>              // TODO: call WARN_ONCE once Rust version of it is added
>> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
>>          // sufficient for this method call. This method has no requirements on the vma flags. The
>>          // address range is checked to be within the vma.
>>          unsafe {
>> -            bindings::zap_page_range_single(self.as_ptr(), address, size)
>> +            bindings::zap_vma_range(self.as_ptr(), address, size)
>>          };
>>      }
> 
> Same as previous patch: please run rustfmt. It will format on a single
> line, like this:
> 
>         unsafe { bindings::zap_vma_range(self.as_ptr(), address, size) };
> 

@Andrew, after squashing the fixup into patch #2, this hunk should look like this:

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 6bfd91cfa1f4..63eb730b0b05 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -113,7 +113,7 @@ pub fn end(&self) -> usize {
     /// kernel goes further in freeing unused page tables, but for the purposes of this operation
     /// we must only assume that the leaf level is cleared.
     #[inline]
-    pub fn zap_page_range_single(&self, address: usize, size: usize) {
+    pub fn zap_vma_range(&self, address: usize, size: usize) {
         let (end, did_overflow) = address.overflowing_add(size);
         if did_overflow || address < self.start() || self.end() < end {
             // TODO: call WARN_ONCE once Rust version of it is added
@@ -123,7 +123,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
+        unsafe { bindings::zap_vma_range(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise


> with the above change applied:
> 
> Acked-by: Alice Ryhl <aliceryhl@google.com> # Rust and Binder

Thanks!

-- 
Cheers,

David

