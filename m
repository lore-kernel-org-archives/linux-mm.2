Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E759D6AAE6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6763E6B0088; Thu,  2 Apr 2026 12:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E326B0089; Thu,  2 Apr 2026 12:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515DD6B008A; Thu,  2 Apr 2026 12:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41DFE6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:20:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD123E19FD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:20:34 +0000 (UTC)
X-FDA: 84614128788.12.9D1F539
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id B450B4000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:20:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fmZ7zqtV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775146832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XABnzafTexu8r9STfdSEhkFwL2mOaywT8y1TwNRcZwM=;
	b=csBnBzrlqeQooqAaa8fr79J052ZlfFZbhTIsEaEClo3ORi5RgENIPsWLEwyynaboBSxVkI
	bU1TI7uJk4P8GtU2ZLgXKqUuuHXvyNH6lRe/9bRXKQZHwOV5ymrQ5+SeFvEzS5SzRGjSmb
	J0z0v2N7F8EfiIVtQQv7CONZCjHZ0v8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775146832; a=rsa-sha256;
	cv=pass;
	b=ETyinGfAFZnHNKuqBIDBW5o67DWRfZehDaX126/fiLnqjmKYl/f/34Y97dCJJtuD4j6iOL
	p1aC0UCGk2K3RFGHSLHQ20kA5oTZ8ZAwbELryZCKD8ay2nv3ywz/2gnAmn5ljEFvMQ1swQ
	ZpluJMeygW9c5fkBXvu0Rsgt1oaEbP4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fmZ7zqtV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-94de664b541so345870241.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 09:20:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775146831; cv=none;
        d=google.com; s=arc-20240605;
        b=fMbDXjr5EzbTv0PI9sKzzTsNPiQtcqKgeMXw3W29nzcGooROBl1IMtPqaLApf241CZ
         2ME2u922wWP91Ec5eQSUwyX2CWVxsrEo/gSsuBD+TYZCD9815RKJvlix/5b2XDXBxmGA
         v4lEV9iJSVb9CuMlPaiA/yFetX2RYYQSmwIchohFTlsm8LGNfNwkfqZVWK7IlmMxxrg3
         AMmaBaZsMTC8RM/QkO2/yTc2DYE6XoH52VxqnSSXLcvGRgD8XS2Lx6bN6VqSGbkEe6vb
         oZukUgwa+8D8FEnNYS5oEUJB+w7J2GAaxQoA4wNXqR4Yipa7oeOmgX9HqZLVlH+waDE0
         A08g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=XABnzafTexu8r9STfdSEhkFwL2mOaywT8y1TwNRcZwM=;
        fh=kuk/3SgVsdg+Pl6lOBGb625RrbGu8Jujqjx8k2g84Nk=;
        b=Pt8iPZhBlnbUfTwXv8FNHC729Xq0Pb45VWbZ3wY1cY21P1hOKC3a6FkKTXkNutyqIn
         G6rXZSDNB13vpU3s1fjldWZGJF35KS4P904QAQN5J7Q5KhklC+SNGWyqooN5vlxIsgsa
         0unhC38/ynLRMC6CHSRqsefTwgq+wxZc1OaFNg4xTNgldEZvxxsUySlvEhXrTGQYRXlj
         4Q75GhnzWcg+YoOVgMiXV0HyilRd489qXvtCHyuyopMoq7w83HumYyqkAXtwcCwXqRWr
         HmyddHgp5Wc02DV3fZC/7Adi3igQ9K17swvzaPu2pIgn850+YhlbOQsPRJpQDkNDb91E
         9QOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775146831; x=1775751631; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XABnzafTexu8r9STfdSEhkFwL2mOaywT8y1TwNRcZwM=;
        b=fmZ7zqtVSg4IMP21sC72xUvUA4i3YuejQg2WSkfssDhiTjTCCtP5ak7FEtxIyb8r8T
         MnrRbyEayQlrm2PMF/9en8wx1RYPkBMVYz5dmtmKAmazxHcIqM82xA34HM38JjR3JpY8
         uomv/SqVnjOOZkTUpssdAbelMi2mLl8j8OVSST63EgcNUO793q2ajxQDMFXHYGqQpQ6h
         n55tyeNrERsoU+2gZxk4S9mnY29i5woHGyPJ767MYL9j3aZqyhbtOn084knA9AaGXqsi
         8l9523uqur6P53qXIZAz55utypkXBxCCKeMbITo4m7PoAWtcgLb4503Xqv6bBgwlv64C
         sE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775146831; x=1775751631;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XABnzafTexu8r9STfdSEhkFwL2mOaywT8y1TwNRcZwM=;
        b=A+W3+JjE6IZdf1bzGMF5pZYqOpLkh6REcibaQiqdhSu75eTN+Nclrr0MKFuhtDXGv3
         KvLO18umSjmCEB8ug4JiA/G5dP9XmRxdEbtPkEKYr8QhhQ0GqNT32iLMlej7cJgweLdv
         3xhmH/tdLPDo6s/4Lg5+mMHOTRRWzsztRyMexDoULoQLu9V21HDKtOfTLClOduxc1AXh
         AzcXvs8RTrBuTD36ccdcWotB2Za4mJnLqP9vCVR0mRhzNJszHyK+vhGuhOCGVAodvdeg
         1quFihuyydoUbyGh1z+W4VObWoHi0NHdhEH7zjrk4lUqeW6VZyKEQGhS/KtrHZ1ABkHD
         nuRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMuEak+gqDqhmkvCRhJ/66yVs0eS/3o9lfJ91aXRw3Su1JMmKBCewNgFGxBRIdeT9g1Xa7glIXBQ==@kvack.org
X-Gm-Message-State: AOJu0YxDF6+BhiAiJxiLgmYpyVcINnH/BZGr1PsDUzeEy7DNkPQzNvTm
	VnxvbbPpvc7VUXjAMD/rFnFB4wEGIgQzPFDF1ArM73HnDpWOMRetmOuBnQt00E0+w16JxCcXdFh
	QrXot8JIA/G8IFoh+C3oGwMcrW+oG3kaINu3KEU47
X-Gm-Gg: ATEYQzwQihCXHQdaxAb/PtCjySxk44/ETW8X3PlN26e+3YAJCoEfAMQDGId5jyrpuow
	JZIDKAD4AVNSY3oNemsyyp7CZTgEUCRAOnDV/0grcWYGQZ+w8A9rszmUvDIuuVDOm3mriJBblVr
	ytsoOjWChiTHbl+a+ikRndbopXzTJn4D9aqnTvd7+rpODkmeN9y6Q+88vLficb2l9iKR3beNAPo
	3E38rbSPpRz8HAGd+jG0k3f0+KpSD2Lb167QzPZFOUed/NGRc1iyH2oJ75L/6QNw3MvOTiV45aw
	uZot/kobR2EspoAN8ZkLBLVlAhlPen2pS/yTc8O5ulFVgBDluCib8Lpyah6ikQtGouAj8LOsr/j
	EO7E=
X-Received: by 2002:a05:6102:3912:b0:5ff:9d74:967b with SMTP id
 ada2fe7eead31-60567f98c75mr3137498137.20.1775146830774; Thu, 02 Apr 2026
 09:20:30 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Apr 2026 09:20:30 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Apr 2026 09:20:29 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3> <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
MIME-Version: 1.0
Date: Thu, 2 Apr 2026 09:20:29 -0700
X-Gm-Features: AQROBzDMmtxznwwWBs0nZ4oqZut-IIYidHQDWkMKzAfittGrfvUDuSGnGYqXsAk
Message-ID: <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
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
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B450B4000F
X-Stat-Signature: pkf4kj91nhy793hs33g6ofru4o3iky8j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775146832-357802
X-HE-Meta: U2FsdGVkX19V9pEadGHEcvvHdvcEDX2iKA66az9oE9S0xJCEhm9J9Hw/o4JGj9lVUYUAD2RcGMvIjAU/km+imhLO2ybAvBGFGSxJZCotRyFocmEoTNZ/5WKWSnu5t59H2KSpgV4+bNZgNOQ8MOJnMj7UfX6Y1fHqf+9DTvv58Ycum+VZ9XapEnNmgb5xvr2VPnISZRXDEo52Mf1FjDI1wN/bWe44Yf1Upq2sNUJ+9kEBp5mRdA8SRAFcoNPtEyp7x8jJiNLUpKTRj61WVXCviovyuwToCUWT5YGGkD3tEDgeGqBu1t2dgiaA75toTOHzOSM/JFN7hYIxfCFtHmEsSeO16Iq1ZnD9xXJY6NufcDOalpID+9SwInK/356C2USnLiiAKnI2XnbBgD0vgIEGoUdKd2Uf5SXU1wKL8r8qLReJnlR3r3Wg3q2bTMbwT+7lLyJVRlJwd+p60XSKaUUzDXa2zagrQj96OjpCnnIGH0UWz+LwOBNGMsAEwe/x64FMvNa1x/RZqJX//8j1QoXRV3wvieTZU5ImQGLicy3mplPH+eyXsTRPbEqyyeDAGCnsF0cUDJoHyparKV3mFEYD48ZvlbNCq3wfbT8ldFL+o/acgqNRbR4XZ9GvRkpYvoKajhKzXDhcZv5wXN8bx3fpzXgj36BfMZYsKcSCQWzzKP1eLsGXjjRYIGQEL9ceDCz69hyOCWeGXld3ACq6bUeNjlq4r2O97zW0TUYPN2i5yPjEHto3WLfN4pS6nA79VIQRLD2o1TT+syWaOVNxsPnYUkkDf/1/0iL3gHxME4L+vstkbH8jzfWkmafEhdC8yi+4PQzUaVUPLbdogCxH9ICRZi6bVeVk49Xdj6F4bYcGRjDm3X4fvyCfDSrdKAooy+pMVRT4+Q9X1fef/r9XBOGKlS8kmNUELBk6YBU7EkPigSB1LdwR1CS6IUDGJTwmp2cH0rsrsKqx5FpR3FPSO1F
 LiG30i3l
 nY4qPv0ko4uzdvjcrKx4d/692djkhbmAPwl0MXKQcYBe9+01kDvEzSMGvdoTQbCcopsedoXLOfUE+9fBX8srzkq7oVA1bb60DzB4BGtlsw4DDOE2FIpCrfpnUiztHxTxl0UfbNERpC3W+Zgnxhu3a+eq25zGlg9ViaFuxiNfGCkWMRtUNVC9nAZb5hEY2+ZMm7A1v2f47/p9oR34nsDI2neeXmXxfqvQf4SNrEJafGFnSNKEoHLto3ltbok36tV02z24d2uKnwMfqlai5sFjCtVH50xUh0de9IKHe9Njgo/MPFOEU2NOG3dCgFWiBOXq5nEmd2yKIWSZuoFguGcB7yMPjwm6gS5h2abzMNVM0o+cpUe+8QgXIYzNnOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>

>> In the case of SNP, there is a
>> documentation/parameter check in snp_launch_update() that needs to be
>> relaxed in order for userspace to be able to pass in a NULL 'src'
>> parameter (since, for in-place conversion, it would be initialized in place
>> as shared memory prior to the call, since by the time kvm_gmem_poulate()
>> it will have been set to private and therefore cannot be faulted in via
>> GUP (and if it could, we'd be unecessarily copying the src back on top
>> of itself since src/dst are the same).
>
>
> [...snip...]
>
>
> Btw, if snp_launch_update() is going to accept a NULL src parameter and
> launch-update the src in-place:
>
> + Will userspace have to set that memory to private before calling launch
>   update?
>     + If yes, then would we need some other mode of conversion that is
>       not ZERO and not quite PRESERVE (since PRESERVE is defined as that
>       the guest will see what the host wrote post-encryption, but it
>       sounds like launch update is doing the encryption)
> + Or should launch update be called when that memory is shared? Will
>   launch update then also set that memory to private in guest_memfd?
>

Update after today's guest_memfd biweekly:

guest_memfd's populate will first check that the memory is shared, then
also set the memory to private after the populate.

KVM must not make assumptions about any memory that is private, so it
should actually only be operating on memory that is shared. This is
aligned with pre-in-place-conversion, since before this series, there
was no way to populate from private memory anyway.

>>
>> [...snip...]
>>

