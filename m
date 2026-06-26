Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F855C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7586B0098; Fri, 26 Jun 2026 11:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341846B0099; Fri, 26 Jun 2026 11:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2116B009E; Fri, 26 Jun 2026 11:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5CC16B0098
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:28:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36A7540494
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:28:38 +0000 (UTC)
X-FDA: 84922445916.27.4EE589E
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C4EF40006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:28:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TsaQqMPd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782487716;
	b=CdUMZaV1TyHqBPe6wdMdNsHtjyG80yl8cY6aLoR0UERU+rYMdfJDHpo9dAh36E25puNVZE
	TrNStL678WqGfd8y1bcWalrbCB+oTfbt5PVlPzrgDxxIEOklAzb13YrIYBY+6eF8B5mHMu
	pa+yRfCsdPRl1x0df7V3+rzGUh819gw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782487716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSgVUERoRNVGTFJweVHOL66/ldGV42KdpD5nvU6ojsg=;
	b=t/nEMW5466aNn9ZWBqQs1C58xfOBq/p5zq7QhO1j6/2lDkI4N6Z5wGdi0mWRWi/jdsqNM9
	m4p0rAyPbappHzHYk7sMKWVSUuAh1RD4lxhmlHnYVK9TqtQnfpA8ruc7XzymTovE0fGve6
	C6cgGuSdmaCG9j5ju6DhjMJMm2oDqE8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TsaQqMPd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-139d5c9a495so119256c88.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:28:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782487715; cv=none;
        d=google.com; s=arc-20260327;
        b=odX0Bt4JMAMqb1iUKGgoQFvzBBZ9IxqzPACjRxyFkfvFid2OWXlWARWIBRBCX26AzS
         sCJg9gx8uWhp086xQDvgPqX5WQR9alGDRmt5Rv7kYlmm4AwnUyFGdO7V4mlBnjDYJK5W
         sIJHi/xr6B4gdWOu+WR4M5gz/YMMvHnLFve3ulWR+arsLcauS45y6a8aet5Gxb2yt5Xx
         v5Jz8a99Jhn/VA15aSNcULWORaaSn72J4HDaQRX68LelVDhY4BgkAqge+ZXGlY86P+e2
         ylIl8lA0RiCYf6Uv390H/4qjtxDbuA29aoeYCEqdF/LGWJG71OjEuWpxEhF7SbLzAUjr
         sJjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=JSgVUERoRNVGTFJweVHOL66/ldGV42KdpD5nvU6ojsg=;
        fh=zNZRQaPicvUf1x5liV7zShcMnltUXMCHmy9q8mS1+qk=;
        b=n85PIX3D8kBCCoaeBkfn+A4+YkzaLtQswbkVCHyIXAAa+VTeVcI2MnaKSxH8WVNXcI
         FiDNHvbzpr6cdQ5L3LpD3P7ypIAwfmXIcqqw+sq2EXGDqq14+dAehWixUFPnJv7Aqz6b
         iOkr2qea3sumtgEFESDzqVOqSDac49gJLv4JjdG4N4goh9x76l7wVKzNp+mrI8vFViq5
         SeJn2rTRsuQLmMqwvbp1UZ/kTkD0rmKXbeaAFSc2HUF0BlFW92lOiCJk/mKmicCkDI5e
         JQbBNJFlFWdyU7iYR0T9v12RMh9hmdVSE+6qrFDm5zJ4f6S4Km0Pu0LfcZWu71BxhVZx
         Eokw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782487715; x=1783092515; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JSgVUERoRNVGTFJweVHOL66/ldGV42KdpD5nvU6ojsg=;
        b=TsaQqMPdBoLCLCs1FrC3hwnVuxxZunqX2rbDpmt1K3fuMB3/0/qC5wfmV3DVeE6SMw
         ZeoPkiuhwUwZzA/64Ctr/uSvkYN0mKBrXrHpZk7L5aWwoEIYR/EDwSG8tUsFc1+rLT/7
         jXcpYZNsBOfD+ornFMs/xTzt19Jdj/GYkRYyFA2/FZ1VeuPIgH0/jrF+4lh0Y3qEbrQP
         CIT15ZUexrESMzcifEkb8OOcDh5Qm1fExQwuyEmyLL9J1jmi2TPgOAQCndlruuhg51qL
         LIsnFq2JdcY467M1WloAHVguFNkQ5nV10nfmMc+UpeSZGGz8Vigv23y5mWdr6YURRcL1
         P0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487715; x=1783092515;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JSgVUERoRNVGTFJweVHOL66/ldGV42KdpD5nvU6ojsg=;
        b=btAYb+G9ZzNYTd8Lc74ywUQsKNP9GiMSA2i53UwgpkdMXm1F/f8SjKmIRXAI7TQrFu
         EWA/yd7y7VlqoPLMEfvtOiyCTbDDpM5CUj5p5JOtRG5TYVmXurjDHmhKQIAd7UDSK7vl
         H3gQP1Tz/13+3f9H8amlMC66ntCxJ/ONkdVT1Lq06a3LZ8TSJL7ji3yQcIOXU/wD3N9e
         vyYCSMqcRXtWsynUed7RADFPNMfjb1azANJH7VfIPRkh4bdeef4xWUJo9v7KvxvNPU+V
         oXPJQZeBaMu8wHpEmOqJSKQDGWiEfqwXYycF8t4JBaXRpdA1yIirrZ78iVIQstOUB5+H
         0XpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+fTlQ0Ee/iWWSWBiN2hAVjs/quhEmFbrVOl5pD7nnfI10OVSxLzc4ACjzsC1QVeX+OdwSBYtft3Q==@kvack.org
X-Gm-Message-State: AOJu0Yw9tfo8lEmEBQilEhT//jW52XmaNcueuaVnItKNhfqisHfj5DKE
	/CEyTFZbs//j1UFpgzOxSp+UNCt2onm0oBkZvjiitozRIJ+CTe3v/mPTfura0IB5zQvW5MV57ni
	KtY5p7qaW0ALbddZrvMQyWFDkzCwCu2cMkNe963hi
X-Gm-Gg: AfdE7cktppgZ/ywdVGC2DE+vnsG5C3ohFFy98OrbC8qrlJkkTNZ4oAypKYYXpLkGMco
	lUILbBYUbgWBK+WKklJu6q0tts/uhyVIQJ6CKg0gZsQ6uoFFiyHz45XSzNiCr94+b1/eBlQpFgi
	0FvVy32jKK9J7yXppE3XAUzenTDWITqSMf/mCqt8of4mTxNs7pKh5enNOME+eIPL8ANNWZFwLOk
	cSN/zxZ6ScqgkRELH0v2GH6ifNNk52ER9YBpewl3FIWz++7vYqydzgRiMLFHY6Box7kPDab9smR
	CrX++5NKdKgU9iM5aCLyVdv2O71CYZX1UKuZd4meU3pSxvd/tTJT2HtGxHM=
X-Received: by 2002:a05:7022:481:b0:133:1ba6:f42d with SMTP id
 a92af1059eb24-139dbaa6f11mr6321808c88.3.1782487713577; Fri, 26 Jun 2026
 08:28:33 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 26 Jun 2026 08:28:32 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 26 Jun 2026 08:28:32 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com> <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com> <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com> <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com> <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Fri, 26 Jun 2026 08:28:32 -0700
X-Gm-Features: AVVi8CdXoJwmFS4d0lnA6dJlBDOu8Tqkyef5BrEHt8qMv-aHgkBxRUgcAuJaPfQ
Message-ID: <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C4EF40006
X-Rspam-User: 
X-Stat-Signature: gxqa6ietnacmui899nqwk51s5idgj3th
X-HE-Tag: 1782487715-91534
X-HE-Meta: U2FsdGVkX19ToaFbPAx0RD45h/9w5hh/29DnbjXOYRdiWr1wmuqA0/ouX47oj4DHj4i3+IQccl2HoE5mOSyekeH21N5Zfdau9ALBA3kgOy88qMVDdi1c5FqYDP0fOKqcp6HgazKqCHKfFK2Haj0QJu5yWWwjuPTxAA4II2Cb+96f87DNVHHU3qd6809dKIDiLwj0a764ppIqfYfHe5zSwqam0kYgRuKRI5P4P8XbvrxqkP7mYrH1bFOCZkv+gouj6zfyLGQaaT61tyEb3joUnn+hB08X/gQ408tUqeY95pevwajgY6Y1XOM6WBW/IXAcWZG0aovN4V4wai+yzEmDnMbQe4mhuMuspRJefn16ALIjzuKu8RZpHJyYuNJgfrya4wtLwhNZt2CUs9T4ePZleTlk8f7cfyV7qHV38skyLGLAP4CbikL88mwqccpH+4Hw02R23raJdyEm8h5GavtnRfN1/sifk8v0W4IkkmezlWJrg5iXdoTnpKtL5W4dkZJReXwUzMVsineuc6FdM06Pb2Y0sdi+EXrG9Zig7Tr7iJZ6fIGU857ZeOqiYZdczzUgWyLZ8EhlREnLIFARbiJNQshqGPHs0CbAzOsomcNFQiYMODfPZ95s2rWwGpWHAokmfomOlKADRpSi8H+Aujaw5n1n5kvQv5o1YcFP1QGeEDjIjXiP48TYFdfMqrXzVtlm2hbcaokwxUd1hTV7YGQGsCGGdufFpGntE0vn+QEO8H5yyCtl8f8Nhn+AC3k+8LeyM2uC3dU/+HeDsbZHR7+79RmS3WZGzqMJUc8oKoNpdCJhJr2HLZlBvRyGA7n9lCYCVsU+Ow5g+1/30RDrmd3IfsCjQdRxoTvCx+tcm6ELxTvc84FYxE6kqKsKXSxUtxJAIdjCM/u81rHG4F6D/ZIwWNdM4XsyO9RoD5rKZjyP9gVI70njTQzKiIdPLmpk23kI/aLuuQgtVJZyuRoYUhz
 3VFc/Ev9
 ihMo75a/R8/z38SPYuNlsK62jsyyL0Qr01wZLJOLk8a90RFi5RZfZyoTOgo+AO2jHF/ubzil+oX19M2oAbQC4WQWns4H8rynjgcc0xwA3KMxCqcvhprvDhJOfKA5FBA21Rah91uCS6JbRdlaqYL0aI5x7YYOwOvfXHL6rgiGUPJm+YWoB8If1hrAA9QqGrT2NIOGXUvO6EXw7nkd68KqVzK5ypcjG5IzkvgxGXxBa8yM1WUdkiXzDYC/LqBWBHwpw7i9Itju8JBa/eU+tDgljc/d22nIcC+teDY13KhEU+8SsACKOUG/rUREnIQ0AcPAN1qgjSMSWMdqhNi2JJGpY/+1L/2HZUXR7roeBMRfTn/vKwFsWxIy7WqoPM2NXZJFC5plZcCpBUYy8dtKcQ7uM7M1lYstfgeQKX66T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Thu, Jun 25, 2026 at 05:07:23PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>>
>> > On Wed, Jun 24, 2026 at 04:00:32PM -0700, Ackerley Tng wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >>
>> >> > On Tue, Jun 23, 2026, Yan Zhao wrote:
>> >> >> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
>> >> >> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
>> >> >> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
>> >> >> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
>> >> >> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> >> >> > > > > index ffe9d0db58c59..56d10333c61a7 100644
>> >> >> > > > > --- a/arch/x86/kvm/vmx/tdx.c
>> >> >> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
>> >> >> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> >> >> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>> >> >> > > > >  		return -EIO;
>> >> >> > > > >
>> >> >> > > > > -	if (!src_page)
>> >> >> > > > > -		return -EOPNOTSUPP;
>> >> >> > > > > +	if (!src_page) {
>> >> >> > > > > +		if (!gmem_in_place_conversion)
>> >> >> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
>> >> >> > > > without the MMAP flag, the absence of src_page should still be treated as an
>> >> >> > > > error.
>> >> >> > >
>> >> >> > > Why MMAP?
>> >> >> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
>> >> >> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
>> >> >> >
>> >> >> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
>> >> >> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
>> >> >> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
>> >> >> > > initialize the memory.
>> >> >> > Do you mean using up-to-date flag as below?
>> >> >
>> >> > Yes?  I didn't actually look at the implementation details.
>> >> >
>> >> >> > if (!src_page) {
>> >> >> > 	src_page = pfn_to_page(pfn);
>> >> >> > 	if (!folio_test_uptodate(page_folio(src_page)))
>> >> >> > 		return -EOPNOTSUPP;
>> >> >> > }
>> >>
>> >> Yan is right that with the earlier patch "Zero page while getting pfn",
>> >> folio_test_uptodate() here will always return true.
>> >>
>> >> Actually, this is an alternative fix for the issue Sashiko pointed out
>> >> on v7 where userspace can do a populate() (either TDX or SNP) without
>> >> first allocating the page, with src_address == NULL, and leak
>> >> uninitialized memory into the guest.
>> >>
>> >> Advantage of using the uptodate check in populate: if the host never
>> >> allocates the page, populate doesn't incur zeroing before writing the
>> >> page anyway in populate().
>> >>
>> >> Disadvantage: Both TDX and SNP will have to implement this uptodate
>> >> check. guest_memfd can't check centrally because for SNP, for a
>> >> PAGE_TYPE_ZERO, !src_page should be allowed with a !uptodate page since
>> >> firmware will zero and there's no leakage of uninitialized host memory?
>> > Another disadvantage: the uptodate flag is per-folio. What if the folio
>> > is only partially initialized by the userspace especially after huge page is
>> > supported?
>> >
>>
>> Good point on huge pages!
>>
>> The uptodate flag on the folio in guest_memfd means "this folio has been
>> written to". As of now (before patch at [1]), this happens when
>>
>> + folio is zeroed on first use by userspace
>> + folio is zeroed on first use of the guest
>> + folio is populated
>>
>> When huge pages are supported, the folio can't partially be initialized?
>>
>> On allocation, if any part is shared, we split the page. The parts are
>> separate folios that have their own uptodate flags.
>>
>> On splitting, if the huge page is uptodate, the split pages will also be
>> uptodate. If the huge page is not uptodate, the split pages won't be
>> uptodate, but that's ok since they will be marked uptodate on first use.
>>
>> On merging, the non-uptodate parts have to be zeroed and then marked
> If that's true, it would be good.
>
>> uptodate. Any parts that are in use would have been marked uptodate
>> already, so there's no overwriting data that is in use. I'll need to
>> think more about when it's safe to zero.
>>
>> I'm still on the fence between the two options
>>
>> 1. Using uptodate check in populate to reject src_pages that have never
>>    been written to or
>> 2. Always zero before populate
> 2 does not work?
> The flow is
> 1. mmap gmem_fd, make GFN shared, and write initial content.
> 2. convert GFN to private
> 3. invoke ioctl to trigger populate.
>

This flow is correct, is what users of in-place conversion should do.

"Always" is the wrong word, I should have said "zero if not uptodate
before populate", as in, with patch at [1].

By doing the zeroing in __kvm_gmem_get_pfn instead, by the time populate
gets the pfn, the page would be zeroed, either because userspace faulted
it in, and the zeroing happened in kvm_gmem_fault_user_mapping(), or if
userspace never faulted it in, the zeroing would happen because
populate() allocated the page.

>> but whether the uptodate flag is per-folio or not doesn't affect these
>> two options in terms of fixing the leak of uninitialized host memory,
>> right?
> yes, provided "On merging, the non-uptodate parts have to be zeroed and then
> marked uptodate".
>

Thank you so much for bringing this up, I hadn't considered this
before. I'll do that when I get to guest_memfd hugepage restructuring.

>> >
>> >> >> Another concern with this fix is that:
>> >> >> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
>> >> >> folio uptodate before reaching post_populate().
>> >> >>
>> >> >> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
>> >> >>
>> >> >> > One concern is that TDX now does not much care about the up-to-date flag since
>> >> >> > TDX doesn't rely on the flag to clear pages on conversions.
>> >> >> > I'm not sure if the flag can be reliably checked in this case. e.g.,
>> >> >> > now the whole folio is marked up-to-date even if only part of it is faulted by
>> >> >> > user access.
>> >> >> > Ensuring that the up-to-date flag works correctly with huge page support seems
>> >> >> > to have more effort than introducing a dedicated flag for TDX.
>> >> >> >
>> >> >> > > > Additionally, to properly enable in-place copying for the TDX initial memory
>> >> >> > > > region, userspace must not only specify source_addr to NULL, but also follow
>> >> >> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
>> >> >> > > > 1. create guest_memfd with MMAP flag
>> >> >> > > > 2. mmap the guest_memfd.
>> >> >> > > > 3. convert the initial memory range to shared.
>> >> >> > > > 4. copy initial content to the source page.
>> >> >> > > > 5. convert the initial memory range to private
>> >> >> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
>> >> >> > > > 7. do not unmap the source backend.
>> >> >> > > >
>> >> >> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
>> >> >> > > > to explicitly opt into the in-place copy functionality? e.g.,
>> >> >> > >
>> >> >> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
>> >> >> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
>> >>
>> >> Yan, is your concern that userspace forgot to update the code and
>> >> forgets to provide a src_page, and if we keep the "Zero page while
>> > Yes. Previously, it would be rejected after GUP fails.
>> >
>>
>> I see, didn't realize previously it would be rejected because GUP
>> fails. GUP failed because it wasn't faulted into the host?
> GUP fails if 0 is not a valid user address.
> But GUP would not fail if 0 is a valid address. e.g., in below scenario:
>
> #include <sys/mman.h>
> #include <stdio.h>
> int main(void)
> {
>         void *p=mmap((void*)0,4096,PROT_READ|PROT_WRITE, MAP_FIXED|MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
>         if (p==MAP_FAILED) {
>                 perror("mmap");
>                 return 1;
>         }
>         *(char*)0='Y';
>         printf("addr0=%p val=%c\n",p,*(char*)0);
>         return 0;
> }
>
>
>> That's kind of orthogonal, I don't think GUP fail leading to rejecting
>> populate was meant to help userspace catch these issues. GUP would also
>> fail if the user did mmap(), write to it, unmap using
>> madvise(MADV_DONTNEED), then forget and pass 0 as src_address.
> The original uAPI did not explicitly define 0 as an invalid uaddr. Whether 0 was
> rejected depended on whether the user mmap()'d address 0. If 0 was a valid
> mapping, populate() could proceed.
>
> commit 2a62345b3052 ("KVM: guest_memfd: GUP source pages prior to populating
> guest memory") changed the behavior though. It would return -EOPNOTSUPP for a 0
> uaddr.
>

I see, I only looked at this after commit 2a62345b3052.

> But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
>

I'd say the original uAPI perhaps just didn't document 0 as an
unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
was perhaps accidentally changed and no customer complained, I think we
can move forward with 0 as an invalid src_address? I wouldn't think
anyone relies on 0 intentionally being a valid address.

I could document that, if it helps?

>
>> >> getting pfn" patch, ends up with the guest silently having a zero page?
>> >> I think that would be found quite early in userspace VMM testing...
>> > I actually encountered this during testing this patch.
>> > I update most code path to follow this sequence. However, still some corner ones
>> > for TDVF HOB, which are less obvious and harder to update.
>> > The TD just booted up and hang silently.
>> >
>>
>> I think this is just the life of a close-to-hardware software engineer
>> :P no errors, got stuck somewhere, root cause is some unitialized
>> thing.
>>
>> >> >> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
>> >> >> > kernel to detect this mistake, similar to how it validates whether source_addr
>> >> >> > is PAGE_ALIGNED.
>> >> >
>> >> > The alignment case is different.  If userspace provides an unaligned value, KVM
>> >> > *can't* do what userspace is asking because hardware and thus KVM only supports
>> >> > converting on page boundaries.
>> >> >
>> >> > For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
>> >> > request would then be making assumptions about what userspace wants.
>> >> >
>> >>
>> >> Also, +1 on this, what if userspace, knowing that pages are zeroed on
>> >> allocation, actually wants to rely on that to get a zero page in the guest?
>> > What if 0 uaddr is a valid address? :)
>> >
>> >> >> > Since userspace already needs to perform additional steps to enable in-place
>> >> >> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
>> >> >> > intentional seems like a reasonable burden.
>> >> >
>> >> > I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
>> >> > just wen up with code that does:
>> >> >
>> >> > 	if (in-place) {
>> >> > 		src = NULL;
>> >> > 		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
>> >> > 	}
>> >>

