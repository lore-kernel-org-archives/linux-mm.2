Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6149C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850936B00AE; Wed,  1 Jul 2026 09:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827706B00AF; Wed,  1 Jul 2026 09:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73ED96B00B0; Wed,  1 Jul 2026 09:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31A146B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:53:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B125B14038C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:53:23 +0000 (UTC)
X-FDA: 84940349886.03.1D2D92E
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2487180006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:53:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CeinzSqW;
	spf=pass (imf16.hostedemail.com: domain of 30BtFagYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=30BtFagYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914002;
	b=Llfn98tdBAcFxocpFOtD+Q12jyJm13w6pKqDkskBy3qGSayWTAgArusRZAWwxB8PxxgC5W
	rdcjA+T5U1fQVCogkSjDoz6pKNZ1s65Gmb8FwJy7Kc4Vu+ZzjP1v/Cl8biVB7zDsn2YUkI
	tbuPOHLz901dfdbbQsdHg2Y1qUa9LNg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dlvRC/ivhzraYV58bWG4aEWroXr163d0LU1VPS4Meg=;
	b=5pBg+i36oHUN6uWtKWtVXIaLOHUuuZkSYc7aVnpuocWmG8LvwMwJDcHdNIXWCypf4sfPZi
	cR32Z85T02Sj1W2XrLb7KCzPMLphxTNbKua9BtJig80ytLz3V3mIatuDRtNyGrrx+o73NO
	PesNq6TGxPG19luu29HMUHbK/rVLt2Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CeinzSqW;
	spf=pass (imf16.hostedemail.com: domain of 30BtFagYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=30BtFagYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c894391f000so982011a12.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782914001; x=1783518801; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2dlvRC/ivhzraYV58bWG4aEWroXr163d0LU1VPS4Meg=;
        b=CeinzSqWDcUJrdnTIwsUXNF9NgUxKcE+WEUpCtHC4zzofX9O5a6C53xhgba1I9ceZe
         zpyd9ZNe+pV8wQ9J3nIysoTWEHH5gwE6IlaD8Vod18+Kta2DnGe0+TasJarGb/Hw49jh
         AcRqM67EJhjL6sLD1CRTWuKJTxEs7ubHVScBV4fs6RWL92UfM8DZHcwCZZ8H60I/vWe5
         CWyJ+/FWY1ZQLKTcr31gYytnI3sE9r8LWZID+d3kSwf1DZjv1mhQewAzrDqAIN1Ya+gc
         xh6PHTzj8LJKusEeEOAdETU4fAe4H2PzrylpoiXXyOcG/cjF7SJQMOafZ6DD5RDS8ZNx
         SObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782914001; x=1783518801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2dlvRC/ivhzraYV58bWG4aEWroXr163d0LU1VPS4Meg=;
        b=UVhB2oAgN/zLyWLsU/WC7/L53TteOzw0v+KbKfSY/bL7fVRQ5UaNbzeXIND06/kJ3h
         mlsIisraqmve44qIwp+StEv17M1sl021u2Ss9D3gI+ZctAgPbJvPuaCI5HOB8pAH6WRi
         AV5t/DO6onrHf5tebBgkZcdVIbmPD3R8D3+EGBGbYgEQmcp8qKRiRdqeu3Ma3NTbx0fh
         sN923PwJUvlJYv6Pe7CEreg0hW1SKLKXPsgu/lDcopoSe0v4sZ14TNlVPuxQ9AZwtzkp
         T9zXSJEInO4GBS1t/i7fmaNzoeHDb2QHIJneNntqfs4eqZ7YT55LgSM9/AGFKpWJNtZs
         IZAg==
X-Forwarded-Encrypted: i=1; AFNElJ+8RmVwNKCaTC21GGs4n9rFAf9LCCL9M8ffcBniqgyJYX0s/EfFoSB1LaWOWTUDCHbDBJgFdpvNtA==@kvack.org
X-Gm-Message-State: AOJu0Yysw2yzaE11uB2i9nH7H6R3vkSFpAB3pIx5ky4eAvwgeDf1tAkl
	rO5RLTQvVY8e0JhMMUyYv/QKhJuv1pcEcn1cPI+wse3RVw6K1mkij5P2Vy0+DhMwJJe3HFDufdJ
	Mu+EUuA==
X-Received: from pgam26.prod.google.com ([2002:a05:6a02:2b5a:b0:c99:aff5:707d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a11:b0:3bf:acb2:5d48
 with SMTP id adf61e73a8af0-3bff4227b8fmr926021637.38.1782914000204; Wed, 01
 Jul 2026 06:53:20 -0700 (PDT)
Date: Wed, 1 Jul 2026 06:53:19 -0700
In-Reply-To: <25fdb77d-20f6-4b3a-8b3a-dbba0dc47046@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com> <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com> <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
 <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com> <aj087H1UWSFxbShR@google.com>
 <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com> <aj7NwCRwWEfLK-gQ@google.com> <25fdb77d-20f6-4b3a-8b3a-dbba0dc47046@intel.com>
Message-ID: <akUbz_kJvYulaboo@google.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default\
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Ackerley Tng <ackerleytng@google.com>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2487180006
X-Stat-Signature: y67xa31oe418ue4mn8dicjqtxypuwkz4
X-HE-Tag: 1782914001-779830
X-HE-Meta: U2FsdGVkX18TmLB3PY4BGqFBb4kfT/Tc0EnwPC1d0qb0SYrzuBoCE0O3hi6TlCx6Wdqq7W+j337Qv2Isne9u3eky7kxFr1rWHUoUxf+Zip4kRzIOswyGaS2oJc7TuzG5QnepugVWHKMvKDYzfmwHEevS8vbzFA9hVI4ypcUYrNsrQimY2iIHwIqBAyZd/jLo2VbRdgBKFR3XUr7bZ+fSITD0QwmlkeS25btKap/YOOiuV5WUYIQ6xjmWpu/vW9/mrCbNTserupKbbsEDz1m4l8X1fGC/9TVL4YhGav9j7vZnoq78KXrTEPwlY7zfAOg/l8qk97OB7+B7bAS1woawXxXN+dKr2JYxA7y69BXkd9fUbx4ZkXmek75bXLGP946QJGc6gGSxkw02/IZdKsISkvqYzz4dQACTTIoHnJX9U/ic+2R+3cgpRvLXnzc4lz4bL/CjlAOtvOeTc9MDhSrjqP0ZT86uroNKOJeATH41H8Pd6aTPXdoSkzZN8ejcdmdhaSzQCVEBLC0iZx8VP9AsKJUQ2rDWv/AsOB7Msxv7eXsyuGXhp3wqI+CBZ69yMujWZOfUTIalPLA9HBVuF8+XTXG6O4h3IAxvk54FC3rJpOvWhdPEhZfkSmAmR+uJgOODZZgdQ3QlhiG08hhYCJ6qT06LpBuZZZPTC9mAYQxj0ZSDfe3FkR8Xm9N1/aXoFp+f0IFOPLeKTJJ/yxSL0UY9+fKzalX+Do0PHEfj9vgeUt1NNX3nLAedOxHZewZpAxMbMkVfjqA6UngjwB1n3eoLQQkkR6y9ICve08PWgi7NS4ZrOBbIVRyiRIvk6jvi9W6FKsLys2rBJm4CmKUnCt3esDV8DNO3wIswF+szg1URqAB5dL5bH/Hw3IUfzqsyI2e4dCfm6xmpE/bvYR2FIGMDn8Jt0OdMTa0yu256FrsZLW/dRGr4gOBppEz4u2SeJsxynPnbVoiuEeoMrm0IAmo
 NrBSZlRL
 lUoob3D98nCWUzPyP2rsoocdUBInTtZ5PnTkQ2M1U6WhzqLMn4/ZPrmRf4Oc4804Zx9NBSTwTF/ZDWQ+QSHDljJkRdcS9dq11ROe02ggmPN32cALhfk5mYWUvq0m0cf5P2PVVE2GmJRHdwxauJknuEODYFKuKMWYUwlJv5T2Xm9b+etK16uZwhtwOJ//KYe+NqxHgSHgSAXmEhXTnELn6mE4CtV+cUr2Pwnkjkqpb0lJo5pcFy2EZhFfQpEu4OdwwrPr7RhjBh516wCSP36lqmwtkQkzBdiOegxXBLGsSdCPJq1ESh2LFU2CtVkp6kVWFtWmKwtAGGkmyTQ3MLZmcwOTU/OgG2qsBTvr2u6XwjWJVWlthYe51b/xqcvAxhGUyJAbJjPyhc0/W9pMiJQmQItZb4oTyk0J0wV3Jf79gVI3bntfnqXwcCA4cghupKJNSSBPr467P6YsDY4/cxc9JHOBUc+JImTDVRrgK4OngzE1ss4E2tyjzcAivwH1KXb7Pb8pjgsQzBzprlWr88WGSORxHtOwch+cdm/q64vi6ubJy3kZhRl7n3z0lIFhq6o8/44vU19KSjiGSB9+cn7ZNZOHhlGp1wI3EQsXhKYDrbnEiVcR/mX9JMZnJHrKmYyz3wD9TkULI05j5OOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026, Xiaoyao Li wrote:
> On 6/27/2026 3:06 AM, Sean Christopherson wrote:
> > On Fri, Jun 26, 2026, Yan Zhao wrote:
> > > My first impression of gmem_in_place_conversion=true was that it enforces gmem
> > > in-place conversion. However, it actually only enforces per-gmem private/shared
> > > attribute.
> > > My worry was that people might think it's a kernel bug if userspace can still
> > > have shared memory from other sources after they configured
> > > gmem_in_place_conversion=true.
> > Ah, I see where you're coming from.  FWIW, truly enforcing in-place conversion
> > is flat out impossible.  E.g. userspace can simply replace the memslot, at which
> > point the memory effectively reverts to shared.
> 
> would something like below enforce the in-place conversion?

No.

> Userspace can create a memslot without gmem fd, but that memslot can only
> serve as shared memory and cannot be converted. So it doesn't violate the
> in-place conversion.

But userspace can delete said memslot and replace it with a memslot pointing at
a guest_memfd instance that was created without INIT_SHARED, at which point
userspace has effected a shared=>private conversion.

