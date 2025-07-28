Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653D8C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 19:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA23A6B0088; Mon, 28 Jul 2025 15:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B536C6B008C; Mon, 28 Jul 2025 15:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B2A6B0092; Mon, 28 Jul 2025 15:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECA56B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:24:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32AC8803F7
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:24:03 +0000 (UTC)
X-FDA: 83714648766.08.085317F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FB2A40013
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:24:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=y0o+enez;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753730641; a=rsa-sha256;
	cv=none;
	b=PhqFBmATT1uEL8YAFfiSb2HvUQXyojK9+7YduoISdRzyZAdijc1qy9VnreMj3sZNO6hCMn
	OBTwaNlPnEfbOLe8mU9u0Ljex3PNirWHNuLKCVkCT6gtFCOzltSN01D3JfHfmCcweEf9J9
	DnLBEWIwPCQ7lj36FlRKn5bVr0iXYZ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=y0o+enez;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753730641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3EpnuB7zTUqYSeFqP3vThQ9a5pqY5H3+hi7C80bQ0U=;
	b=STr9lXCUOUv3ZS70FiJnqVp0EKYpuff2cBCIoDeV8jnVDw76koMEZCWyYU9Z+W4D2WWsBV
	8jRyY19+OCd4+gHu2Bf52beY9SOM9ijR+yhnZ9Q5gzlvPUELa0CmMqi3CMzl4Z1QkKVh/9
	seAjU+AA3qvy0Oap9gs1v8u6QduyRos=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74b54cead6cso3138497b3a.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753730640; x=1754335440; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I3EpnuB7zTUqYSeFqP3vThQ9a5pqY5H3+hi7C80bQ0U=;
        b=y0o+enezKmNHVkfttMNcwWCpBjJk6iZyl1mqsGlTBiKSSuG9R1FRxNwHlXfN0v97zG
         thhGtbO5ouAXL8DLNRq1mm0s4vRkmE+Ln3U8OPrWJ+qmWdTjiYnzdRXutTr73sQRWCjY
         pFpabGdUdbeumgqyy+HU4mmMk9Qi2eXv4QfZ9qrubPLYftOwMWyZYMA+sYltReq00qBq
         Ch1s6AZAztqlgxX7mjYKL2DC4g6ieETjIV0iQg2ldzo+OPNelS+mNdN0wq5BGap1KVSu
         nYP+Hn0/NcMAZEvHmqhdIo1ErI4UWe4rSQdwe4MkDafl3mP7GJgsYS5XRTSKGDKHukk1
         P13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753730640; x=1754335440;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3EpnuB7zTUqYSeFqP3vThQ9a5pqY5H3+hi7C80bQ0U=;
        b=MdIhDw+9/qoeniPNR7y4DWykXA4uD9IZ5yH16F/VZY1L34AdPBTdXBz9l8DbA90kk8
         KbTbEkEFJ771TX9ZNK8aViR88PxSgjdZ91W/wJkrmnEca71k76AaZKwGhUzIyw4L/xPg
         m5hp/bAO+JwVEOmuobN699NIgY1VIYBDwVqlbx9j/DZrQAKIEDZxo7QNR8Kwo20u5/2f
         deDrmUrQyyN1cuYaQ52zOdLU74YniWua8N7AnSwfNGB3vOrhV0++xmorzikufU7bYJ2w
         kBFx6w098i36wibVHZ8VUmwZt52d1C6IDiFpyDlhHdvpFK6OWHlnv+M5T/bG05udsrOq
         dVtg==
X-Forwarded-Encrypted: i=1; AJvYcCWp5bSZi5ql+bCMBofRAnNxHgUejdzQ7z99WCsvX8w/cFyGmumklJLktoZ4D3Rx7hM7u6HkUUIk6w==@kvack.org
X-Gm-Message-State: AOJu0Yxlpz0D9B62FZ5Ae0L7b+ODypegiAIICQkVTVkHklH9aI6q1WMr
	GUR7BWv/TTzY4aZcE7CBGMtT7cuI0GqrZ0lgDF6DqLytagiztsdZLJL68M6vw+NAmfQ=
X-Gm-Gg: ASbGncsO3G++Va0zvmYMdlIog70z0Z2UCAoyvyUQp0SB3XdefdZ1HMU4XqIL8xRRRl7
	x52Y5sGA/IzKVdIg1j5EI5p+C599J1Kv7Dbdz4pBNPqG2+Y/B5ZC+ymlsMLGsfuGjUEqgFl+kzs
	0wKreEo2S+SlrcM7e/z/7rBSusWp6SsV8oInrqiHVqZJ1r1Eye6+wS6bToJj12TfL0QMSW8U0Qb
	6z09IgXZzLcnn8RGbOjHRzbLjmtDWNSCmGexBKNk2EOywUVPOr13AKXyAldjirUAtEApU5FnjNC
	6eFTE2rbx+nAmsUk1Zwc63UFz0PR6A0uaA+OdsTeWWtBCo0ocFGyT4UBqCnLVcxFgIpNWnzB4j2
	sRmotejBh26eyRaGK5ZkvAYTZkFKpPDFP
X-Google-Smtp-Source: AGHT+IEBPPMIaQlSu5uKVWCdzZHJc0FhuYbrfheptoNcuXeIv+/Kd5lGGATtoszSal7LwhGI4xAJ2w==
X-Received: by 2002:a05:6a21:6d96:b0:220:9e54:d5cc with SMTP id adf61e73a8af0-23d70190c47mr24772860637.31.1753730639759;
        Mon, 28 Jul 2025 12:23:59 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f7f67a8basm4451072a12.40.2025.07.28.12.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 12:23:59 -0700 (PDT)
Date: Mon, 28 Jul 2025 12:23:56 -0700
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
Message-ID: <aIfOTC6CfyCsaEpv@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <3d579a8c2558391ff6e33e7b45527a83aa67c7f5.camel@intel.com>
 <aIO8uSqiplnyyNOd@debug.ba.rivosinc.com>
 <a19c1338f2fa4cb19a4f8b7552ff54ded20b403a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a19c1338f2fa4cb19a4f8b7552ff54ded20b403a.camel@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2FB2A40013
X-Stat-Signature: ijq4u6e3htg7myq9r4jd9jqbnsjk9f5f
X-Rspam-User: 
X-HE-Tag: 1753730640-37239
X-HE-Meta: U2FsdGVkX1/o2ih3OW0+z927nPfcHg/CMw+/1omeCYcfb85rARN6yNSTA66whPUC+6Mh2Zq7+moGD0msXeKUHY+b9m4Xz7YoROXw8wzgMcuVvMDiLzYoCa2SPKLHeb7uukd48elXoc6P3ktYivxxlS6rfdRfpVZcrtDwQnsVmkya/t/HY6NKVOSuejZsg+nPlhtO72dtpftVY4zYImt6Bal9JbIdDEeDeNDHX21VtFc7TFA9roaAF5SGuFVpg6whJlcNLVUYSbv4fPe8NmvtOENksvTlauYomtL6SkaTmKSjILXW32tzfhH80+JWD9GFUoz9+2XIGRQppBsksf7+KFrXTCkL8sotJYYVyeOsb1FpLLXgqFbPNjpnDAllp3ufwzrg5+ohkpxPXsRe6MxPl0v394YxbFdFZJKBs+Ro0oyZgqMp/59afFOJxXis2nBBmz/VMhSaCYLI+mfyxKbr6Y/ZN7PWvAMtnsbL5gPh+bp1lGTcikW71ZNMiBP5ihgGbrCalueQd+zmuKyPRUMUeNIhOOV4zOs2KcKZfiQYKj1fmv6/OKh/5wvVrVs8De9g83//LYEYG0rw9Ii2BPhlJ1IqMCuUsfnPm0OEXvyb/Kr77a9nWrchPaxhWSK99WPzuU65y0mFzfy7/bebSnRGjtVBgZlIcQWDUNwYgwtC/AMKrC6KMPUjzBVYZ0cOVLoLtTjwqYDfgD27o2KXZHRx8XKABRKNOhb6YpaJK4jt/Xeyi51rqRRVSaRvMs5rH4ENUiBMiUuNE5PIyRWN6p45SN9dfuGCHFnPJQYSMRrQTd6ZlNJESO/w6a0OfpiAA296cjw4xQ7TlLH3WzrRt9cD3ZRyZG9MjDfgjdjKqlKQWyCeZqF0KBAPBiVqtIAlKzLwUCJsilY2MW3sR8SFgdeSGXYdDgLOjoe2792vsh9wcaoMvEndm+s4B+1FPKpZbzuLzb4EC41gkNqW5nQhr44
 lFZNtmRC
 QWXNYcWr7fCGLZ641vtmpuekhSqokaNusR0kkuixOUATlFQUFAMUvgazWZx+2nBtT8lYoqB/BePBOysSfdH/Mky4eCkiEV82myJ6KCQw6u+uf4t+dTGN5w7jDewctZZTTuqBXT/tDrLkRJ6SJQC+427AoSmmpLBE+hp8vEkgcMOxiOrnbKfVXzbqP+vzT/Km3Xy7o3a8qoIsLbRUzavOZHWyeoA7+fiRuvS+9hMtCkWV9k0eRG17nhpCslfvOspYQOnQMA4AB4ANDrBh0f96suid7TIe9BxCLz3MT5pRux+FlU30gTYALj5En8tzQFSOE6ogE2iDRBhJZFqWC/s86g8HTHpT4jd+bWXHM5yHt4r28AKYsUf9X/y/CyIu5Tr2hp9xKQwaz5yHn/K8vbVtDcRKW984EnRCkYyOMtU/o5qzXxPMCd3Hm9lI3qEg2Laz4fo+Y23DrP6Lxll14TPr5fVjF6Z4QSknS6Pdr1CUOKn95h+9CvQKqX7gIvc8qWYLLBUqZ+ODwcmxl7uoMbxtRJDjjz2+DQAszLhgKFAKA+g7bIw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:05:22PM +0000, Edgecombe, Rick P wrote:
>On Fri, 2025-07-25 at 10:19 -0700, Deepak Gupta wrote:
>> > This doesn't update the direct map alias I think. Do you want to protect it?
>>
>> Yes any alternate address mapping which is writeable is a problem and dilutes
>> the mechanism. How do I go about updating direct map ? (I pretty new to linux
>> kernel and have limited understanding on which kernel api's to use here to
>> unmap
>> direct map)
>
>Here is some info on how it works:
>
>set_memory_foo() variants should (I didn't check riscv implementation, but on
>x86) update the target addresses passed in *and* the direct map alias. And flush
>the TLB.
>
>vmalloc_node_range() will just set the permission on the vmalloc alias and not
>touch the direct map alias.
>
>vfree() works by trying to batch the flushing for unmap operations to avoid
>flushing the TLB too much. When memory is unmapped in userspace, it will only
>flush on the CPU's with that MM (process address space). But for kernel memory
>the mappings are shared between all CPUs. So, like on a big server or something,
>it requires way more work and distance IPIs, etc. So vmalloc will try to be
>efficient and keep zapped mappings unflushed until it has enough to clean them
>up in bulk. In the meantime it won't reuse that vmalloc address space.
>
>But this means there can also be other vmalloc aliases still in the TLB for any
>page that gets allocated from the page allocator. If you want to be fully sure
>there are no writable aliases, you need to call vm_unmap_aliases() each time you
>change kernel permissions, which will do the vmalloc TLB flush immediately. Many
>set_memory() implementations call this automatically, but it looks like not
>riscv.
>
>
>So doing something like vmalloc(), set_memory_shadow_stack() on alloc and
>set_memory_rw(), vfree() on free is doing the expensive flush (depends on the
>device how expensive) in a previously fast path. Ignoring the direct map alias
>is faster. A middle ground would be to do the allocation/conversion and freeing
>of a bunch of stacks at once, and recycle them.
>
>
>You could make it tidy first and then optimize it later, or make it faster first
>and maximally secure later. Or try to do it all at once. But there have long
>been discussions on batching type kernel memory permission solutions. So it
>would could be a whole project itself.

Thanks Rick. Another approach I am thinking could be making vmalloc
intrinsically aware of certain range to be security sensitive. Meaning during
vmalloc initialization itself, it could reserve a range which is ensured to be
not direct mapped. Whenever `PAGE_SHADOWSTACK` is requested, it always comes
from this range (which is guaranteed to be never direct mapped).

I do not expect hardware assisted shadow stack to be more than 4K in size
(should support should 512 call-depth). A system with 30,000 active threads
(taking a swag number here), will need 30,000 * 2 (one for guard) = 60000 pages.
That's like ~245 MB address range. We can be conservative and have 1GB range in
vmalloc larger range reserved for shadow stack. vmalloc ensures that this
range's direct mappping always have read-only encoding in ptes. Sure this number
(shadow stack range in larget vmalloc range) could be configured so that user
can do their own trade off.

Does this approach look okay?

>
>>
>> >
>> > >
>> > >   out:
>> > > @@ -59,7 +72,7 @@ void *scs_alloc(int node)
>> > >   	if (!s)
>> > >   		return NULL;
>> > >
>> > > -	*__scs_magic(s) = SCS_END_MAGIC;
>> > > +	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>> > >
>> > >   	/*
>> > >   	 * Poison the allocation to catch unintentional accesses to
>> > > @@ -87,6 +100,16 @@ void scs_free(void *s)
>> > >   			return;
>> > >
>> > >   	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
>> > > +	/*
>> > > +	 * Hardware protected shadow stack is not writeable by regular
>> > > stores
>> > > +	 * Thus adding this back to free list will raise faults by
>> > > vmalloc
>> > > +	 * It needs to be writeable again. It's good sanity as well
>> > > because
>> > > +	 * then it can't be inadvertently accesses and if done, it will
>> > > fault.
>> > > +	 */
>> > > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> > > +	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
>> >
>> > Above you don't update the direct map permissions. So I don't think you need
>> > this. vmalloc should flush the permissioned mapping before re-using it with
>> > the
>> > lazy cleanup scheme.
>>
>> If I didn't do this, I was getting a page fault on this vmalloc address. It
>> directly
>> uses first 8 bytes to add it into some list and that was the location of
>> fault.
>
>Ah right! Because it is using the vfree atomic variant.
>
>You could create your own WQ in SCS and call vfree() in non-atomic context. If
>you want to avoid thr set_memory_rw() on free, in the ignoring the direct map
>case.

