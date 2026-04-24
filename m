Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660EFFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D244D6B008A; Fri, 24 Apr 2026 15:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFBDA6B008C; Fri, 24 Apr 2026 15:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAC86B0092; Fri, 24 Apr 2026 15:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC8486B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:08:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70EC81202A1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:08:50 +0000 (UTC)
X-FDA: 84694386420.21.FD52DA8
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F1D740007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:08:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cuLW9lsf;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZtEXtNhHfkNb6REgZmVRn/FfCDvY0I1XuFnEkLVDpk=;
	b=8bwQKCMtAKF+F6rILt66yS9rOhyZ6wH50V5gpruueijpp4h6smdw/uuCg0tL6IlPD4yPuG
	ExG+kj57jjRV43S9YJhyOL/Icwmd6FDeZvq/u8ven80rETdhq4j5COeR6hXSyeNAHPWpS8
	m2YPGhT5enfwr0VCyslJMqZrQTfwCgw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cuLW9lsf;
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777057728; a=rsa-sha256;
	cv=pass;
	b=CtY5sIPImD3XIj5XHTgfJFWVWZzkroWiZlxkQBzi0Cy3+rzst6CZzZGT5TuohFdam1936U
	T6reNmR0Ro4SRYW6ormVKUX+7H2UgNT2fz2zwytmopyrTsx+dCSEdle1Qj9xFbtRA2C/iB
	gF+8JYxu9hKQJnD0G0uXNg0BkDxy7fA=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-56a857578a8so3069595e0c.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777057727; cv=none;
        d=google.com; s=arc-20240605;
        b=YVBzb7m0zYQjVgGbuvNWwXOZfRlqHFC3fjHgWiOwixtt1GPK+vaX8B5g92cjkvxrVE
         31QHbDdQAeMKq71ZF7/YiWs7TeLkyeBn6Ag+hgaDvmoDjABD7d4iKz5EQvzxWsqRzZjE
         PqAlkfhhCZVgonwL3kWjFuopWYUfraXS2dJDdFSrdd6qJn/udo/0wWd8/LvExYJSfZL5
         cmLaOYwCSqGS/Xn/0B0r3FE78QJrRhb6CZ/fCH86AFtO/d8zNdfWNfa+ayeZSEIBaeRD
         2zHuBlpC+LKqVg3BFg3ceKVhQeMkScs2NvpMjXV3Cl4smbaWcg/NPLSzTFRLINrJ5374
         LskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RZtEXtNhHfkNb6REgZmVRn/FfCDvY0I1XuFnEkLVDpk=;
        fh=GNMHew8SeXn3R70n3kV1NNx5C2zpneFqVik3VZIxJes=;
        b=aRzb6AHCySK4zBcOfUCsM4jzQc1zWanAHK03e1kZiaO1MlMw0Zk01HGQKIybeFmIBe
         CZIrTNI9p09jsAujeDiRrKVKOAD92RMATDEx/iiiTkAaG2UfbygL6TYBLSCkpb0gol2J
         K27qGgjjr0/KPkkHOu23k6OGp8lkILlVd32cz8fGcsX3L0cRN32KDpnVYVUo1ShV2yMG
         eiLBsB7tvjSxbPJ9+3FOm/zjE1anN2A7CPXtqSvCPGbAm5F2cV0ILRbPVHunhBsBuyTn
         ZPL37Ki34tsrvHY0OED7dzs2LiA59WTFeC5jW2qXgtMAk3CmHFxCn37ZGS6tjF6fOk+Q
         gn+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777057727; x=1777662527; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=RZtEXtNhHfkNb6REgZmVRn/FfCDvY0I1XuFnEkLVDpk=;
        b=cuLW9lsffQVZvis15C9zIj1KVdysxU/kPnh4eW7aC/BUd7BCpjOmJhWmc6AbDexj/3
         sGKbyizFg4kbjaUJI64R4dGPIczCQE3uSEaLWTfQrz/p2a1TTtclmIHQiZy1BETTSQ2y
         P3TEosqDjVVVBgQG/RCFVE6dWKn0P+1fTGkCpiWaTfgq+VhZTjpJT1+wmWJdK2yHkAR0
         30iQrmUP45Tt25Sa1rKyVB00IMSAEJGl0a0CgFDLtqOpsnUOLwTfnjnIfjL9Xemo74Us
         YAT7e+nS/rmUIzS3Ba5v6hlFVXqAap//OsxGJ2RBdWTeDg+S7zoz3fBsggl7yuc/jgr1
         1srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777057727; x=1777662527;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RZtEXtNhHfkNb6REgZmVRn/FfCDvY0I1XuFnEkLVDpk=;
        b=f3hDA47fD2aa5IPiiPAi1Bw42DaWGT0a1SOp+so9V/WxGh1QRwER2UAmCQt3/Gl2x1
         HlDKsBzdlw0Qz75h0AwPofcNpGLBssBewRGjK2SUaUkOhlHlf3zzVlp40hpjq/MJ4qRb
         +BP94ZyHx7Pdzhf69Svd229dn9uyALD1MxPA+dizRMgZ/cqAcvRRSkdv2DmW/BpNUvrq
         1OLrWz8MOsQzLEOyQPEphSVh+dpmO3SeOgojxbzQ+l0QKyTaMfSnM9ppO154gG+6HVpQ
         QayEQ52kQF/c+8Xh8MT06GOsvmubIXEyQKwPINWOJicEAPICR6FKtCmikt93eUr4xkRp
         V9Iw==
X-Forwarded-Encrypted: i=1; AFNElJ81iySzWNH36D2pmigwEQnd/FGPAj3Iylv/FktxLcYows7TPAwPY5AXUqytAt1s6Uu9rpEWLmuFbQ==@kvack.org
X-Gm-Message-State: AOJu0YxkJd11Sw9wXgPOo4/4RxWWlvu1lkUZxvdwNYW07OD4LHKqK/ah
	OjLaIapi7/jSYYxH1hGCWu3zXBLLI5oXaULRWfmODvHWMQLk71rOM85kHAuMQO0zW9QUKfWA4Yz
	iIfTZKIDVM6+YgYNqHdn4EIFTlkBsmBLtL+IeEX7N
X-Gm-Gg: AeBDieubddPy3Lrkik2mreD5KGwa4xPUJCPXtq/7dm+NhMIL1wDa90hjeT45DJRdxMm
	muHfYmY3XhftRMlaXs8H+RnpjDurwP1a3DFlf9T7Rhs+Bw09SnPvFq56ozepxfkis0x8c7h5WgW
	FUC2pH/Kz2g2wIO7L6UCc+ALO+oVXv7uZP/abCnjtNgAq9NGwbDKKxDKktyGnaotaJO/kCXUnzx
	+qk1gfHO27zUuxFu1JK0e6hqCCaGT146mDAGna3dw046Cl3KSM2gb8YbyGJ/HuxxO7Ti7eVpDHF
	MCYEHUJT195TyxgXikF7FiKjiTcvVOoEWQj0Hs4szlqTtOnSMMVhKCHNsKegiyOwvt/neYPzMPr
	SJHFj6AkLVo6S63k=
X-Received: by 2002:a05:6122:8b8b:b0:56c:ddbf:57e2 with SMTP id
 71dfb90a1353d-56fc6816e2amr12940121e0c.11.1777057726762; Fri, 24 Apr 2026
 12:08:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Apr 2026 12:08:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Apr 2026 12:08:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf> <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
MIME-Version: 1.0
Date: Fri, 24 Apr 2026 12:08:45 -0700
X-Gm-Features: AQROBzBye4IStJFmb-zjsEcLePEkodFuzsfbkbSYLrRwBVn_bPHs_yld_lwLStI
Message-ID: <CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
X-Stat-Signature: xiwnfwxaqfxmggy3xj398ef3eb5odrzp
X-Rspamd-Queue-Id: 5F1D740007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777057728-536456
X-HE-Meta: U2FsdGVkX191L0Vwp4rCO+y0ioAMafvzmOCu6t///k0BD3XWgoqxzolEzLZVsXlGwTZrgHSR8lDFaYG+MgPR7Su1n953dNyK5oahWcI8bh2eLM1UFoyYcynILXUublQhbOYASwswRduJVrnlxSNb18bvdL1pGy0Z+gNSGSF3LTpxTgH/0Ag6NMwOrV/oeiYWGF5PvasCxAEYep4UkYN8mLMTJUdHTT0jv3ZPBgOhmtmclCiNF+FvYMaRYhsTAHEghHAxId0wr77UiwbhC9Zz0zax2lCMKJpenSPYMfufYWmERhYGcL/Bhc1KcZLA5FcJu2rYT7bejUOlRm9Z59UTDBk+clEjjasPn71c0qX8p+IC1htjYR1e7Gx9jN29++3QEaig06WhYtSUl7+mMpNKi66M162ixQ0i+qmdG1sK5oPcEYS295wx7yKDuzntquVRBaItoHfBZvnM8/kOxy0j3T8d1t5LwxBKu0xkyEnBpE5CMa7CddSrz/hrS9Kj4fKy/OOHLzc/S4QHWjgfYArDdzYwZ+zStdZuN3g65EMX1kTD+5L8S0IE81bFaU5vFDnXcR226adQC5Z9QRQSfQDTiChsaFRm74HwY2F90z0TuXuuO4W3yWapZoX79Zs/gzE2xLCKwvg+KwphDDqKRSyXOhEdlafgBcHpEh7KXklaxk/0iG0WNGNMl8lCelBB+W6gcPDsQ/Anemmnbeh40RIAiOINChWKKaJxbbjIAC2vVf5N0nY5f2NyhPvA4oQH1JVBHDCd0IlYcnyjs0Lk8Wc+wnzb3v0ywrrptxnNuUm96mTAIUhg2FFyC9OvtlI0QRJyTaPDf2IYrlRuyj0TbRS3gBJksBzTZ/BoLCRH13oQJUcsqWXVZ9aFoWwB27hpI2TO8zKiNYB3M7o7ie/NUlgPnQqy+eKNWVuf3XhRMJkcBja/o1yfNpYxSpIFAMdvpmfUPfPkH40UHqLevFFhwZp
 yr4cPLhC
 OeKhk6I0deXrDNHYvix+RUf1qQTiNddSOCMXdRKNT9xPyngenLYibTleMBy2ht3qfZL+nFdvF5JtU4P+VVgeUSsp4dsIAkjUilGG4DxHOJdryvsOLTTjwp02fEfRPYBwIkoznmoK8QRLXtbON4k9U0uaogS4nodnohNqfGZqVyFxuSiHWwVJdyDGt6uwOVX3o5lyB7KYyrwlo8xmU1l4j9h80Rha6pmjcsSnMSWpy5Tt/CadxHyFUUUnFYxCVns0ZKGoRwWfH+rMZSNWzWNYcFy9bNsfu9jN4LzYD+gi9SGffidsnupIaktDJ9L/oTpNe/7bcy+YuBQMKThCb8yU4jccpbtj3ir4NLLetvq7BcvTgBJwVl8fLzGammTkzALKpA4v+4up8Mel5OlCDrQd6HxmejQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

Thank you for your patches!

>
> [...snip...]
>
>>
>> I also did some minor updates (prefixed with a "[squash]" tag) to advertise
>> the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by
>
> Though I'm not sure how we deal with it if SNP/TDX at some point become
> capable of using the PRESERVED flag *after* populate... but maybe that's
> too unlikely to worry about? If we wanted to address it though, we could
> have both PRESERVED and PRESERVED_BEFORE_LAUNCH so they can be
> enumerated separately from the start.
>

Not sure how likely it is, but if SNP and TDX can honor PRESERVE
semantics after populate, I think we could implement support under a new
flag like CIPHER.

CIPHER can then be used to mean "do the encryption or decryption", and
for platforms not supporting encryption, they'd stick with PRESERVE?

Should we redefine the semantics of PRESERVE to be "ensure that memory
contents don't change while guest_memfd tracking is being updated" and
avoid making a commitment on how the guest should read the memory?

The above update would be aligned with ZERO not being allowed for
conversions to private (because KVM/guest_memfd does not make guarantees
about the contract between the host and guest.

This way, all of those (ZERO, PRESERVE) will focus on KVM's interface
with the host.

This lines up for SW_PROTECTED_VMs too, since reading memory that didn't
change in the guest is the contract between SW_PROTECTED_VMs and the
host.

>> userspace for SNP/TDX in the kvm_gmem_populate() path as agreed upon
>> during PUCK.
>>
>>
>> [...snip...]
>>

