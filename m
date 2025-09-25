Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D63CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7B68E000D; Thu, 25 Sep 2025 19:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF748E0001; Thu, 25 Sep 2025 19:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5A28E000D; Thu, 25 Sep 2025 19:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4968E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:12:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5E6C11A47A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:12:58 +0000 (UTC)
X-FDA: 83929324836.12.BBBAA8C
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0457610000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:12:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Aaz8y2iL;
	spf=pass (imf05.hostedemail.com: domain of 3d8zVaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d8zVaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGCCSnKnyPGGdnUTp10aKL37FULfLm3dyeD1VoFdI2I=;
	b=Hz0f9RuKuZATMBwmb4DVq+knHaHOT+TXhYzTXjVgf/4hVhBeYW/p7zPXLDRFN6LNpWMcP3
	fiKoTugsH7GgvtAQnuai1Fmx6PkzG+9mAZYphFnuSdOLlZNG0rZSK7heIywuRhR5NO8d2k
	of0kMbqg3NIfRVd6HHEGSF08a7Yp8rs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Aaz8y2iL;
	spf=pass (imf05.hostedemail.com: domain of 3d8zVaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d8zVaAYKCLQmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758841977; a=rsa-sha256;
	cv=none;
	b=vN+YsdM6U+4xm+8eBWH1MK77bu9Tw8JnLqo9iTWwA0eAuwtQECrZdZIinkvh3dAqbmcNl8
	+AIg1tMh9QIJ1EbU0T3iJ8P/i1UL0FAUwy8diB/7L3etk+cz17xlfvUoBlLLeFL8bIzMMb
	UY8B0NQyR+15li+tUWpa54OMK6l0x5Q=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5509ed1854so1015149a12.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758841976; x=1759446776; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XGCCSnKnyPGGdnUTp10aKL37FULfLm3dyeD1VoFdI2I=;
        b=Aaz8y2iLWer8JnkM3Qk1r/jgot2khwebMc2gdUO2x13QWpy8z/DJ025lReRVUmSpFx
         N7vu4+6swpWeXEuAPyUulrChW58dYCF8zQBk6FVVwzDiO1mqzPPH4/zpvlZvi+9LNMvq
         qdHQTaYoLEMVvXSUjl4rIS7jDSBnLoCjz/6b/kM3HusOZ2JVvN56YbiTBLsuKT27MLKd
         19BYJHlFUjQsS+tK5rWU7yiKsMAGu+yfL3iYhTJV698c5/UgIiTZOyd/M4z+XEMMNkg6
         3As4ry4HQ6aS6UtAZp8hYmVmIpW/BB5SzztO78F+PwCRTaXTA6i8k2tJaAVuUPaI7xsI
         ceDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758841976; x=1759446776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGCCSnKnyPGGdnUTp10aKL37FULfLm3dyeD1VoFdI2I=;
        b=NfulkpAcC2FGRWIMXQLzRODa7JWLWeHQ27ezjf5XbBDewTgv2tTJhWYOIs6IYGQE6K
         w34Goi9W4SOcNs4JrtJc97OKDymtXLEYwVYabv6ueLh9foUzOFLbnzJOHaKMUw3K9+ku
         Tb4WKg1RUNql2GtU7nsKvaZTMaWJYtMjMjAAtuCan5FmXmFg01z0zwbleMpt4Wgna7bU
         +FerVe0obNCKPeXywTVBzN7Bn1q6D3m2icv2P1VUET6yjIdtOHz4tyIhrjMNw4/IZOf/
         wLVLAloqVK4PAEseVTYc4SIxdnS3ygfgBmg6gL0vGSXH/NG2i2z+X2g4gj9N1ukaa8av
         60Jg==
X-Forwarded-Encrypted: i=1; AJvYcCX15eHUTZ8Xto0q+LGtutkclJQhZErspoWt5R0hOfEq6w+sNk+5lQSBdD3yp0aylVlrHedVR+E5FA==@kvack.org
X-Gm-Message-State: AOJu0YwFKf/e9wgCUqBD9IfIUqIiO5HQgGwGHv9iQz9ALILNVWQSDT+a
	dItIeQdCBpz0kpVuqwFHVPg51I78uWl94JEOql1eMFx00iBRLVvlxJwPs4U+BrXiRNPBgubZC18
	xeEg3nA==
X-Google-Smtp-Source: AGHT+IFE8gFtFdnHNmX2p6THQrFO41fYST4gwotcfBj6rGswgxHnE9CG8NuKci3w5GnRskLMvJFI/+Q8X0o=
X-Received: from pjbjz6.prod.google.com ([2002:a17:90b:14c6:b0:330:9af8:3e1d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e883:b0:262:79a:93fb
 with SMTP id d9443c01a7336-27ed4a7ecbdmr51468535ad.32.1758841975402; Thu, 25
 Sep 2025 16:12:55 -0700 (PDT)
Date: Thu, 25 Sep 2025 16:12:53 -0700
In-Reply-To: <20250925230420.GC2617119@nvidia.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-10-shivankg@amd.com>
 <aNW1l-Wdk6wrigM8@google.com> <20250925230420.GC2617119@nvidia.com>
Message-ID: <aNXMdSZkqDtsGRLm@google.com>
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shivank Garg <shivankg@amd.com>, willy@infradead.org, akpm@linux-foundation.org, 
	david@redhat.com, pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, ackerleytng@google.com, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, 
	vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, 
	michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com, 
	Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com, 
	aik@amd.com, kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0457610000E
X-Stat-Signature: 6t6fyufq1388n5b51gk3a1qouwjwwmyu
X-HE-Tag: 1758841976-953821
X-HE-Meta: U2FsdGVkX1/+CadBubiPiu6KrtalHxxfb5a+dEwCDtdjdpOvi+x4wtjIIQAGbCex2e+bcTFvSslv0iPaHW89EbqVOyGppLIWe7qLn4uEtU+4U6SWZ4s8KhtvFV1701X0i4U1VscL5f5fAFuWilooWlSKiTpbISoE8/JNgUd19zUgqI/4zkyzlu4kERCZeqotApS7z2MCqET0rbnJbBoMTK2VKLKLShBYufir2/A5o1QCHO4+iYxFD/DTEc9vz3TdwWn4357nmwX0CLwQrbbcDJ40rEYbXpfk5aFX9vUf7wsL2DkIUXnN+/BQZ90CGMbQNcG3SgcvCiFGV/355bpECnyj57F2BFYndbf6iMmZh1I01yJ2Q30c1sFzfbHeruLpPSU9diPbqI2BRD0s1sal+yjbN6mkHhe+Rb8nFWGfDVNuqL+S+YOF86MKeXdziDIamG2remKCiqnN4qfMYRIr/y9dVkN8lKToO6crgLicB5pq3svA3U83CCUD0wz1vXzpnQHhjX6Htz1NmHa5WI9T5ls4TM7rc0KtHDfekjpTL3ogpj/uZVLnxLt7RYMGWa0KtDJLxUCI5WcWjU+DAFl2vyDgkIuoNJcTmap61ffKfVUSF3ndU7LVqBtVLC0gL6jpv7li2oPXooTduCS9+ObKaa7iEA3ruTKdXOF7VbDRd9PQ8dvCBGuSNzH6tUpfghc8t1/y8aO6K17QynDPHVly8UdnDXdH9ARdLPV8ep4QJ3UtDF574avhvvGwItMpyaQUC6/B2Is7VvVjiGBGNCEFa1mKWoTT6pjIyfgBaPYigXw1pzIRCs/dis5682StPxvVwbPp0MZbdNtqm+a5kbZA2AwmLoenwVJWujj/CAHe/spynVOsmoVBOyE4QnDL9sb2a+dOx8Jse0ha7QTe6NWEFhus03uwGWpnD9ntlqj4d2gmoxGabSzzFMITQ6GgHuTyPuR1Er76M3tHNOzItHZ
 r5yNsc6q
 WnjwKWA48vXCGSzrh+TAosSGbTq0FpAVJB0927wUsUTStHa0ItbzBIV5zSfToS4evPeVgmlTeIsU9eEa6iaxaV5Z32h0JLiZnQI7+UOrNin8QzfN6Ztow+LDvl4/BWGCeo12QiR+n4Iq320hd5O0LjdVACxrtGG+/slNFMYKioxfwpm4xUJZLQcVsvehlzyMJwHbpM2WiXYXVDFLa1mWzhVZ236qA+6wnquE0/mLYphryi64FYK/tqYbHzNVkiTxSqirlg48wd1xvHN3Axum3/r+p/9Re94LcPrQUsf4bFgBgz0csulsx3BigLOJ/RHITpd9ZhZAbXDEqdIzvXfFAT9nPScP3eU/WP6EzycqFR8y3kmYqWBUs1HcvfzuH8ZDqIUTGEMjJPtqDQgbXrz84RGxGurWb6nBC6Cgf1TkbmjttMLLEw0wBGf19UATwx16ARSCFVWAMn8hE82b+smlm505+2A+8DxFzoqyt2Ux1FfWJlyBT00l55414OorzjN2LKRq0svwSw+PhH3kuzuSv+YDARSAZDbbQMWQKQClPYSuLbX8RtuE9IKBZvi30ziicQPHBWC0vPRYw/21kbEfU3iqY7WjEVv2gBN4ndFs+qgOiX7WEp7fKCvsDxZeEVsSAvdC2enpWdnBELy/kyc6eV7v0AS1tK6Arf1O+ua12H40mF8+W2GlrsnKdKsyUFAt9mWRtyKCYvvwx8HOhGtzCgnCbMett4OUXuDozoDoyVnd5WFZ0zJxC5xftnQu743p93iXlI0eZ9xoO+NXSjoipi0NYIczo4IzmdXLk2icN1vBiAiDKM/DP2Jkl3vm5BUgkJA7t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, Jason Gunthorpe wrote:
> On Thu, Sep 25, 2025 at 02:35:19PM -0700, Sean Christopherson wrote:
> > >  LDLIBS += -ldl
> > > +LDLIBS += -lnuma
> > 
> > Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
> > any of my <too many> systems, and I doubt I'm alone.  Installing the package is
> > trivial, but I'm a little wary of foisting that requirement on all KVM developers
> > and build bots.
> 
> Wouldn't it be great if the kselftest build system used something like
> meson and could work around these little issues without breaking the
> whole build ? :(
> 
> Does anyone else think this?
> 
> Every time I try to build kselftsts I just ignore all the errors the
> fly by because the one bit I wanted did build properly anyhow.

I'm indifferent, as I literally never build all of kselftests, I just build KVM
selftests.  But I'm probably in the minority for the kernel overall.

