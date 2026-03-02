Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F087D58E79
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D162D6B0005; Mon,  2 Mar 2026 03:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7756B0089; Mon,  2 Mar 2026 03:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BCC6B008A; Mon,  2 Mar 2026 03:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A62106B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:19:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60C5C160A85
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:19:08 +0000 (UTC)
X-FDA: 84500422776.13.D384E10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C137120010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:19:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtcHjAcd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Igypx7l3IKNdtGaG+I4FfjkpBJrncwUml+1yFoAO2Yk=;
	b=wLcMBm7ATN3hLW4L1RJqfmAPAsi1UksKaq4gpY4YommUjKqx67Z+GHX6tOqClZgx7A/+1q
	CUB6v4Fh/5APty42zCExN3qttG/js6KPM9mLvOEJ8yN7O9FJ0TqH0CoIu5f2KM/4+2yZjM
	u33OE93JwxVVENsKpfGkh/M06aIqjGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772439546; a=rsa-sha256;
	cv=none;
	b=hOGCX7am3LLxzSsS0cfZeYCLH4Dc+C/KlKvcmtgn/5IVCl8WsxRD2HFc+vQbYdGEE/hQXC
	9Q8t4nWPVXGjZNAes4IXe7fWTQB6x3pvuHdjhhA2zJBKi24wYWAkOQwtRtMkgM88PkgMDm
	ZczwusReJLSh86FDLyI3sVJJvagg2WM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VtcHjAcd;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81674600AD;
	Mon,  2 Mar 2026 08:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42C3C19423;
	Mon,  2 Mar 2026 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772439545;
	bh=WmUymOIJMfyfhcBz2h3rfkkfmDcPbAvC1z+3AaqwZ0g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VtcHjAcdNUspXks9MnWnffCAOqhBHNybP+7Ni7w8KdFY/trDOnhcMQKmf8ZqBAo9v
	 2oPq6TzzmlTs/C9RNRmZ/bhgByD+u1nfj6UxwxomjOQCu2sY9HuCtu0I3smP44soG1
	 z3JiHjnOWXVROlMpnAOszR6Llw0KBEFBuQA/dpMNDX95fR6stQpR5WnTZjAG5K+8C3
	 J8dr/QWrvH7T+g/mBKT5sBlBT5fQFIHiyIyYAdI/Wil4qScmZd5DeCh046NcNpwp9+
	 rTrW2LUZVcITpNBX5owhZeWoh57rxakj8ZFLJUaCvflED3tgx9mlEtXGwa4FzT086v
	 UCdEEMmXLFPAA==
Message-ID: <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
Date: Mon, 2 Mar 2026 09:18:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from
 zap_page_range_single()
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
 <20260227200848.114019-3-david@kernel.org> <aaLh2BxSgC9Jl5iS@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaLh2BxSgC9Jl5iS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aw8ki3rfs8t3twwomfbzq4u1gdmeky1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C137120010
X-Rspamd-Server: rspam12
X-HE-Tag: 1772439546-469021
X-HE-Meta: U2FsdGVkX18q9IK+bFLNm5clZaWdLdB3EwCEXXw9wVnVItC+xhDwSQ2w3GWd8YCuVpV4TFuKAH4sXyRXCCF8dMcpQECtygfl876OI5Jcoo9hKGaHJ5+wA9t0VDyPPNSM1jT0+q8OuOXJ+voChF4kBeu+TO2atvaR45twWKgJybonV0SOt6LQ94Pke/MSNoH6WtcI7ZdpbmNc6jaSbztmYIcZaD1WyzLHp1qj8Vnc3hdLUb+QOd3afcGogWDlrdWBPFZ0OSGOGvxDFSKzJMLShQ2OXAjC9JaTqM/BbQqqd7uPsHVJAWyc7Tte1MQATPwontzW9wJ5BzazFAdrqmMM/O7ubiDkaSaOEMDgQBP2b4eJsp5l0CDleawPkcOFelkmrVd/RPpwP5uS+O00wfKqrYal28GsFfspIpI9hb51SccpWFJd6FmKW/QRNdGTo/rF3qLDDgxLNI80VXPx0JLIX+lU552PIAdVqsFX0oqKZTkEIUqrL00M0BgM8iUm4wkHJ3xM/XtgiOXiHbMJOr1C435XmSWWxkp9kYcoZpb78LkrRb12TlWMcySmmVzs3/XtuWxy/YYOtgwC92Qqj3K04TY9wBLw2dwVNHyBbDFd2b+8r54osstPdHvAM3fdavsZTjS8yJOXfA7qd+c+/9muQM2FBC7qSACBi1jKQnbr+7P6oqQsNFNTIbfqCS9q/hjsfs2/79iikXyqBe6nI52/eWlhrW1QQMuJP/8/6CS47usuaisIDoBZ1cv5U69kfFG1CG2HgpyNvaCoYSCAKn6TLDeoWnCRKejHIDuHJkAH0DzkemTRRP+75YGmh1jL4YFyINfkgbL8rljTjiOHjM7e6PA0cLRvZThVqtTG/v469mpVlBAyCPebJXVUWGd6plF+XbbGlfbdohC4M207MCZBQNeLwM0fjAD7XpP3nobGj/LoBM74AKPxSo2UPEW569vRG+VFCMB9Ngvlu5tAQ/a
 UkVsXnnR
 ATTlioyeckcP3FNWuzyXRqlx2sbCye/l2maw1Xh69qqIFFiGqrUfOjPN02jWbmvzP0ZLxCS0Yh4MrIaiJuNMG63xgrVaEc3ksL+R0wwXv57gNtNauNVNQU7hbgOov4iFTJu8wELqRg4ir/lI0B/MjO8esGV3shSLukF9DszHXR8S3GsuIkxiVGDlzylZ7f7JOcjzYDsslHnueeNCX27nzCCwQ9YxVLi3ZEAHadJuAXT9ew/WKJpcGFD043E5AnWYzkR+zTcjyk3OJrwzCt7CUNl42r9gxXVzTWGU5FCeG1GLo7iYYD6nI71+tm2AVT9FSL2fyekDvPrqA5CsTmw9xxHzAh5kSEbBqw/ka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/28/26 13:38, Alice Ryhl wrote:
> On Fri, Feb 27, 2026 at 09:08:33PM +0100, David Hildenbrand (Arm) wrote:
>> Nobody except memory.c should really set that parameter to non-NULL. So
>> let's just drop it and make unmap_mapping_range_vma() use
>> zap_page_range_single_batched() instead.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
>> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
>> index da21d65ccd20..b8e59e4420f3 100644
>> --- a/rust/kernel/mm/virt.rs
>> +++ b/rust/kernel/mm/virt.rs
>> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
>>          // sufficient for this method call. This method has no requirements on the vma flags. The
>>          // address range is checked to be within the vma.
>>          unsafe {
>> -            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
>> +            bindings::zap_page_range_single(self.as_ptr(), address, size)
>>          };
> 
> Please run rustfmt on Rust changes. Here, rustfmt leads to this being
> formatted on a single line:

Having to run tooling I don't even have installed when removing a single
function parameter; did not expect that :)

> 
> unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
> 

@Andrew, can you squash:

From 5128f2e34d219722a8883c1fa94e057bd34601f2 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 2 Mar 2026 09:17:19 +0100
Subject: [PATCH] fixup: mm/memory: remove zap_details parameter from
 zap_page_range_single()

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 rust/kernel/mm/virt.rs | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index b8e59e4420f3..6bfd91cfa1f4 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -123,9 +123,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size)
-        };
+        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
-- 
2.43.0



> with the above changed:
> 
> Acked-by: Alice Ryhl <aliceryhl@google.com> # Rust and Binder

Thanks!

-- 
Cheers,

David

