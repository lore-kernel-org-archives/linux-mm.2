Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7D9CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3756B0088; Tue, 23 Jun 2026 20:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64A46B008A; Tue, 23 Jun 2026 20:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52F46B008C; Tue, 23 Jun 2026 20:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF626B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:09:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03BA41C101B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:09:30 +0000 (UTC)
X-FDA: 84912872142.05.1C50C7A
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id E560F40005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:09:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eowbJm2O;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782259769;
	b=4rl35ydTPjPpfCmDmQaudV9XrLa66VvTduCsqyel7wdWu5bLYwpTRsVbPlWOtLfrhN5M8I
	LsSjZse8zcem3PhZPf5mR3sRMvE+xykc+bcwkzkEfiIETBzFEjt2FtOtUHiY+hBCey6/vj
	cgU2xNYdGsFsjunasJluu2x5bWAYViY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782259769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOf9tviNFkAeKYv+XoLw2pXVKZU7weWckYUjDtw8Ax8=;
	b=vcyQYRExTlxVifVf2MzP3ivXxyO+kHIQj5GHCKaJEcwYrN5+YuC10RI23TFiLE7UDrFnq7
	B3P2wadxPAUKv/XIy9XZHFANpi1Qe3SzhG/Jg0u64SXn8Vfox+6Y6wOQS0wB1hJO9Gt3hA
	xSCfO0+OTmsVOcR2ZWxYh45+YFooBDI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eowbJm2O;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-13981833e13so523683c88.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782259768; cv=none;
        d=google.com; s=arc-20240605;
        b=MhlZxpYyBfXEErZ4PTmudAVTud7ErRqSh0zlvqj4Udy+6/73Qgd7QRsLiERYRhn6+i
         1ywnj9KhOVKR8xOsWSnWFE4Sbmkr0HPSTmc/qHKAlGRwZZOoULd17soLvSY0nrbYO1jK
         MbDzPZwrh7jX4vHdeLtLk57cWCSSVtmkjMTeGh9xI/JHmQ51+Yam8Dlx7LJ1ew8sLRqJ
         UzcGMn+7eS1WD1NBr77W1OOICUc9pHJdTvgy1aP/+MlswPmETU2s4+HDMQMuWRFO/n4q
         cOqwlbbL7aU0XxQkCgpr483tvwFnXpTHVRjvMYomKRENkU6NUe1mPEdHVu0HcnylAIX5
         3Tiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LOf9tviNFkAeKYv+XoLw2pXVKZU7weWckYUjDtw8Ax8=;
        fh=TpWrl5/5JEvT+OnLshKJssQ0TLV5+WQ6qyAyJwFdimI=;
        b=YC71f4asf1S7fa7xicPG4x7gaSeHX/0wwZGZMjS7fL8XJcda/K83a3yUAilbGPiLlD
         aBDeaod8bGDih7EdwRqYurJHN4PvA/OaKnt4UFVPbMdmsVl0birueC6p6F6LGHHuDbgL
         8/im0KOg0mQFcbvoQWafGM+gzXqXUqMG51bPZB6hJLWYB+y3yw0H3OaXDX3D2j75GM3m
         LaiK8HC0Z73GZFUPOnHhXX0jRqQFD4nexQgZaYI19GJhAhmK+Fu5NCdbXcmXqpwk66oX
         Cy5pJRPFIR8UgIJaAF4eWtQc1pfOMIy1oy8bJQKNJl7qFgjLuuh9QO7ImaCYO/t8YcdV
         uPjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782259768; x=1782864568; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LOf9tviNFkAeKYv+XoLw2pXVKZU7weWckYUjDtw8Ax8=;
        b=eowbJm2OKkhK9U2nUQcXO0lrilhUloWYzN+PFHUz5oHdif/hzfik6TJOoVr1ReCu/K
         kqBFFD+5n5LkUuKdmowSiIaGgr/DTbgtWQ7thBLgOrFKhZx5SzBY0qG5q56dMpUp0gTE
         T5ZK2V2ROxZ5ONPxd9Rb754LuBWcFPS6lRWeZ6/IjHswwFSrLiZy3KU25fuL5oFDN/nu
         HUR3Z4EIyGP5eeVWUr3WEnqsA1AyzsYIOBDoH2kcUqi7Y3/pDreJPawGNONr+TpAFZiW
         4zUwP/IGxxlH4ucsHxULiwpoCRqYnjYnMR1OuIIa5CuZ0I1z5ZsDAH9R8QGKUmNzBXqd
         6rUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782259768; x=1782864568;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOf9tviNFkAeKYv+XoLw2pXVKZU7weWckYUjDtw8Ax8=;
        b=Rh+PHyuZtErOw9f0pe2Wr57+gmkW6MQedg64XBfJ4x9jiCcaBHPmAWMhi6aW6Bk0HP
         DrgxfWiq34jHO9y7YzjrmtY17rIkDybgTYG5m3W0lziZPQZ8fH3rO1jESJBk2lLRHrXg
         QhvTLYhUq6YOc0n5cJ8X5GIF/N7e5JJEChUMNAYzUkEC8dggXB0wKSMX6LuXXCXgSciP
         fvC3v51F8abImFOvEPsu0UbU63IMHFOfxt6OXOfUv6omhpcewnw+gPTCmZuFvrjU27B9
         k3WOulsw3m96flL3HghnYxo9lsrH5AcjUKEeUmW6Q95IVMGRuQJL0M576daXW7U1n/D7
         /KrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IpfxXIJEzMg2GxVdBdttjoURnANGTqXgDwBZZrHSBkyCY3xucNb5EZXKjb0inEAxHn4ZzC7GtIg==@kvack.org
X-Gm-Message-State: AOJu0YzYH0n6ZhtNZpZKdXwS4cLv/l9apo/5aVD08U0JRJR2JEAyZDtO
	xM14rau1d2lg85E0sgFf5WQvWdiDjgR9GB/jRonandmeUMFX5C6HB7sb6XzTJrgOSRGBpYCP3QU
	cwJsrIbwFSFmBVnMF8qNmia0ZOtQGCBVnRjFNINcl
X-Gm-Gg: AfdE7clkmzHiBQNb5AMeRQZvOls48nB4UItemJcBt0Ay5wZvjA7Z4sQvHhNb3CmfElt
	nn+kGPzWGXIv3CQUciT8Vkn/45f8MQMZdbZpZlezQXQeu4MaHY5u9SFm1HzSSBrY3Aev8luWnvJ
	BivKS5ma3kWrI3Ed8ptxyyyDdKC/b/Kk7xo1hTzXPLAnNWcJljNqpF/EV21KHFQ5ctGSU4y+98b
	Q45dcxHxO1T3iM8ajq+AljAipqXz9OtR+MzmSHyWDmi7dye7CVBKWqOFcD17WdcRVKhdfeLwhHf
	j/xsLs6cX5Qgnc2+GbVwrIsCuDIebB8gJkj0JO2MJSNEt0qHBGlvSztPTWs=
X-Received: by 2002:a05:7022:45a4:b0:127:3f2a:af21 with SMTP id
 a92af1059eb24-139c5cff378mr4117596c88.15.1782259766886; Tue, 23 Jun 2026
 17:09:26 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:09:25 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:09:25 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajnjTJdQKD1Kz3tf@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-1-9d2959357853@google.com>
 <aceb07e1-77bc-49b6-a932-5fd9b5a21727@linux.intel.com> <ajnjTJdQKD1Kz3tf@google.com>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 17:09:25 -0700
X-Gm-Features: AVVi8Cdk7fD1H5RbfHSz0rAk7YN_q01NbBdLx3di9F5nnt4X6vdgAPFTH7tGEuQ
Message-ID: <CAEvNRgFU4H5FrjQvLMQm9DOQ9ujiHfFfsV6zVKNVi-rzC_zSxA@mail.gmail.com>
Subject: Re: [PATCH v8 01/46] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: Sean Christopherson <seanjc@google.com>, Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
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
X-Rspamd-Queue-Id: E560F40005
X-Stat-Signature: ukaeto76n4sm8xapjnfbizz96o3surqz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782259768-992730
X-HE-Meta: U2FsdGVkX19uNoJd3Qefwhh2KvjGvKdtJ19Li+lGn8sxZA/sUpVCQXrM/fYlq6vctJzJTQeXqcB10DO/QtZy68S94dn8/R9DbAARbBm63DdrX+OTw8s8VAC1SDONx4+UNV/agrdPB9iscec/5u9pLWGRPZ+M47TF/EczHEO7UNA2V1IOAm39CSUPd8GsMevyrvy4oub++7Ql6NlNroRgYY3VHz/iWC82JIHSzKuKhHoAiX4ymdue6BVfVXkYl3DS8/O7mtQCuPlNqu4xOs5uZOGlnX7l25bypimxZXofYh+hPOX8j+D+rTFora36i2l95F+TBO4gcnadW4ko3+AYwnIqnPLFx2jSMolr7ukh0rD9BcgQokHAFSpv3efZNACYyAJzHZ/H/skybXI2DxyoF+VQ4XI3y90i0fcPjfm9eLYUGwbJuUy/eK8Dumc8HN9ug/WffuTH41jPctuCONNnDFDQ9fovjtnzrTW1yqE9T+cvz367bJsW3xAxPIIm19r7dQove4ATnyxGG2zFDKiAUshfLci1+yd11RfNc9UnN3xOpXT45Cw+KbCmbdnJ+dCF3ofpeXrhspiwPPNBkou3FToS2G3rWiZib05e2/3QktMUKhx4YnCpoT318Vj9ZdQOPyHvBlK5JvtmNXqTI+MHZY/cmO9eVZyXzRwn1VylVGnUjJi002Fq/MckAbbx6Zlh29XnqHYZV2Eo2W7O0MtxMcrp/0KEOTpGtGvCbAh4rLSgJV83/THXJPafSCgQ9YgoDEN4UYEzbKzXznX2aVX6HdctiQ9M8RpIjaYZT+YtuQpanndnBuQd1ZnDyMLCr3b1HCygesktZln0MFuNQJOn2eyyPqAySDY/BgpoEeINaA7QiciVudYlIWlWNPl1m7ewSTCWXDrYRqgI/Re/8BJ9RNmNSYXPivcHJ21rPSB7X0XOsKr03H6CBsG9fPl6Vp0F43iPn+vN4Mrurv4Eie0
 CJEKJwmZ
 203PD3SIkbgeGKWi6kKyswTCIixxiF1WAp9gcN+i30ePPTIGs1fWe2uGRdvojx4Q0qtJXTFf630t2hZ5haxG1A5cjbRmDoCEaHf83DYOFvijuJocnL1kcHqtADPU3aDHC8el8jrplY1NotwsEWQlVa1BEieBtujDmRwk/lfD8fmzQkpHRcHKK8pvYhzPslDomZMrOBtFOh9vCTZ/hHvvxkeLoosLdzjg654G9YFu19AACVtXh/AhePYka0ySdk7OD0mCH/wxxsT0n4A1MRpLp6pCB+iVm2W0AIAuQ3AXMAbqQuKf3EB0bC4j2UyHdsosIa6ZIQG2hFon7R5S9/VIObBPL9J/3I7v0gS6nWxIE0dRK4oXwoInkAr/nEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Jun 22, 2026, Binbin Wu wrote:
>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>
>> [...]
>>
>> >
>> > +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
>> > +{
>> > +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
>> > +	void *entry = mtree_load(mt, index);
>> > +
>> > +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);
>>
>> If the entry is unexpectedly missing, returning 0 means the attribute would
>> be treated as shared.  And then in kvm_gmem_fault_user_mapping(), it would
>> allow the userspace to fault in the folio.
>>
>> Should gmem deny such edge case?
>
> After several bugs this year where a WARN_ON_ONCE() fired, but was entirely
> insufficient to prevent true badness, I'm definitely senstive to making the "bad"
> behavior as harmless as possible.
>

I guess both are indeed awkward.

> However, in this case I think we're just hosed.  If KVM treats the memory as
> private, KVM will incorrectly do prepare(), incorrectly allow populate(), and
> will caused missed invalidations (though I suppose __kvm_gmem_set_attributes()
> "only" lies to userspace in that case).
>
> That said, assuming SHARED is definitely odd for cases where guest_memfd *can't*
> hold shared memory.  Ditto for assuming PRIVATE.  What if we instead fall back to
> the "init" state, e.g.?
>
> static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
> {
> 	struct maple_tree *mt = &GMEM_I(inode)->attributes;
> 	void *entry = mtree_load(mt, index);
>
> 	if (WARN_ON_ONCE(!entry)) {
> 		bool shared = GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED;
>
> 		return shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;

I was wondering if we should not only return the init state but also set
the init state, but that would involve performing a conversion to the
init state... Too complicated for an edge case.

> 	}
>
> 	return xa_to_value(entry);
> }

Thanks Binbin and Sean!

