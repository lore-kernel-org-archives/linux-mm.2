Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F62C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4113F6B0088; Tue,  4 Aug 2026 19:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2736B008A; Tue,  4 Aug 2026 19:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA186B0092; Tue,  4 Aug 2026 19:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9B3E6B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:15:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8504D1A0309
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:15:53 +0000 (UTC)
X-FDA: 85065146586.06.7B5E7C8
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id A97461A0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:15:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stw8DfIx;
	spf=pass (imf19.hostedemail.com: domain of 3pHJyagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3pHJyagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785885350;
	b=xwo6Hl6cMCH7nVFcx69dwcjqJIYoiVf6MHXGl5IMLctUfq2gpsFZ+0VTNhkafYccTojClZ
	+H48bqEqaZ/OQlrFRbc/30muW8zflUQ9z2LRORPPIdgM4+/NsuZVI4XcWogRDTLpYi/KWM
	vkYcbz08Dho3EjOmpmCxG07mhJJtfzw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=stw8DfIx;
	spf=pass (imf19.hostedemail.com: domain of 3pHJyagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3pHJyagYKCK0fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785885350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz3QUw22bh8QYe/ZiAsreDFp91isZAPnzZuU7CX+ujA=;
	b=iMvfgaWKKdobbIkXgsUJJS3y6+WMbe3kz65WsGKsEbBwX2lG1ux2kjKex29oJI44xUJkON
	5ZhAuD/pdPVIJmP4gxX+NhUky2RTVmWJYoF2XDwEAvOk5FeYMEn3BykNShUdh/VK8l109U
	eIM8yr5QIr6W9AoVfJUptxE0rbVlH6c=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84870e7f498so314585b3a.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 16:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785885349; x=1786490149; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lz3QUw22bh8QYe/ZiAsreDFp91isZAPnzZuU7CX+ujA=;
        b=stw8DfIxE6Q3ypf86EqfvYM0JmBELYu49PqlqNnZgrX9RXB0+0zwrtI2cptuwSTLcX
         qecVu3N/hKdVUr8fdphR7/U2JDdn6Kz+E1fGQl6ier1lQB5Ip804cBVK+ELqwN9kKvNc
         1EuV5rNHOTvDjfe04PrhC+Ti2V3GOahGoCk6KWT2q1abBCWfU/J2/oW+pQSxWTRXjOBs
         8uDeNEsOD0JPq3agWwxWP5CGw+vvdDgaetF0xhaeIo4lyvi4W9sBdhMacV++xewAdbQM
         Cn6qBXTjuPOuS4+Af5nqqSBcOW91PFpNhDGeEaNbxVAFT/H5vDW/fB6DArRzGXnGt8u7
         P+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785885349; x=1786490149;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lz3QUw22bh8QYe/ZiAsreDFp91isZAPnzZuU7CX+ujA=;
        b=dktiICYJqQy/aQxXNFnnvuxW/FiJxR59eTjZ7/lexRXzfTM/lJmLIxwKQhfHSt+Lyn
         TPI7HXZlvuVT4CG732EzwAdMU/rzQ80wqXLzOCJi5y17/bJX7h/meGd7X0dYBh+3o0Po
         bSmgG1yo0WYZ/GNb2Dy57npH6BocbgYjcFlH0ML0PK3jdC7i0TLrBO17cJKok5U5goFn
         qTXIs8Gu2D/CthaLoOdzcNUulcqQWv4A16rtOUkN4ELGaNKZTTlH1Ey7PEXx/zFxx3pY
         BbiguRDQC43jQe+ADNsYg83BgCkvNeGOdS9sF+95UYtbZrtX97kCH/18/gWTeK6WskNz
         R1MQ==
X-Forwarded-Encrypted: i=1; AHgh+RqYDLYg125BWL3IJlpvP6QbFDg6FZjLVuzM1QS0T5HBTahUEnTCKUwQ2x4hNfMCc6UgnPLWlvhPmA==@kvack.org
X-Gm-Message-State: AOJu0YxcEsSxeI6Hvt9ehrQfwEVjElweXFeh+kte17FxEn7NEwkbGPSJ
	J62hO/j0AdJQweDNwaP/LkjJbAFL+Ue56Y6HSQRI5B8IJl2RI0hHPh80n0XybJKCXGQuXKytax3
	rDwIWoA==
X-Received: from pfbbq18.prod.google.com ([2002:a05:6a00:e12:b0:848:5740:db83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9517:b0:84e:e809:dd49
 with SMTP id d2e1a72fcca58-84f2e12d02bmr2017520b3a.36.1785885348892; Tue, 04
 Aug 2026 16:15:48 -0700 (PDT)
Date: Tue, 4 Aug 2026 16:15:48 -0700
In-Reply-To: <CAEvNRgEOE5oeFVRYYucsCGJaFAQYS1oNRXAwGKzRAyqmoHT9OQ@mail.gmail.com>
Mime-Version: 1.0
References: <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org> <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com> <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
 <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
 <anJbMf5GBe0Pxh_x@google.com> <de780cc3-8c43-46f8-b8e6-3ddfe93d753d@arm.com> <CAEvNRgEOE5oeFVRYYucsCGJaFAQYS1oNRXAwGKzRAyqmoHT9OQ@mail.gmail.com>
Message-ID: <anJypPblO8ww0IHY@google.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: A97461A0002
X-Stat-Signature: ghzee9wzcc997mb5b5tifkhbjwjej16j
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785885350-276374
X-HE-Meta: U2FsdGVkX18izh0es8O/nV5TDOZsdQOy9F6awWcY7bZUpze8ktXMXxl0KvtX4WXlVKmDgeohp2XPJTyF3bbmojcPibP8S27Ei1FDeJC3SiDE8oJDNqlAn8HCRXFNhQJ9E5Za+CFFupNUWWkFvOBMoSIWTTNAEv0f7E7znZ1TbqCwm0ITDUvqIosGP6WBcpEL5JxdkXjjfyZkYe3E+0Xrl3ucHlbJErbvZOeu6J1DaDfGOa374+zKz18KeO+s8rqz4fg0L8SbSXjPt6dwFrpuqTbdy1I6coveoJ1JNBwNsEah60wNGh0puJXBz52i3ppa6RP9PE2VHx22T8D6dUeRM0QSIn9tiM/9SNRCS+zHgX6QPYUpFPSpxM0gLefE95zP8SKLp2yXBkJ//WVbGz2T/nDo2QdCrmLMb8qv5Zf+FkRnv4pMnb3qSFkZHsn8PXRs8MbAWFh+ksfn5qykf/PfreIjcoDvo1Cruo+mbpNyT9DQNZIT3cMP41EvzMLLEEdhiy5KzJ3q1EMUY2bkhom4iwfLNqpyi4P6ZuprpeqzEJarxBcQHYYOK6K2MB9VTTjwWrxxHdtbYrMP1h4W1MNDRuA4RUyLHK4hPetdYdPXjQwSVGVd7XSpbjb/q4hPuKEIV7nnln69JZo5gekPls2ZCFx98AdDso5NkQwH45P3QJswoVr7O2uSwE620m2+roY0m4U8TxaMiCiCLS8dKFqXTj5/MTETnQBgWz6+ZrcIwqi0+udoJnUfkw2zMSIFuGAZvJNS0XcCUF3Dy3j4zKoaX6808/V6jPM4vWPNSr9vfTENDJvSN4uEGByUFI2d4K7OFc2dJq5iOmSoJ7tVoXhRkOgd0lahVhH5uCk8i8jT2GbQRkhKenZQBDPPePkXdluxi3trvOPmwG5V74yCWnd+xlT9MP1vOV+cfBV5ikIvSz2oCQIzMJdEXXuio6D2UfdEoLggIS63rr8gzC2OVMC
 9Zses5CA
 7On8AWAFlR0DdFvilCvX1HBWqICSUxzAmPiEiHUC5/B7DcUqYbNnxKRVB9/y2pt0OZ1rlhbkC8M330qM+LzwWEyPVPq04GxlnJiEPSzHRuFjNsWWdjIIvvOEygQIqYY4a3XwLapywbCuRlnA8t2V0X2n8zYvj8g+OIcJnL0T/2CXx1uoI8Htdq7hdSWCZJiwnrQDFuJ28q1KP50XI3vBqeumZ4XN2eIESyr9XbZGpLpskVFOzDEXrPP7pOFPpoNqLpASG+H/4SUkEas/EeoWbHAC7kPQ5z38hIp53husylp45HA83Vl129NEeZ3VexK2a8KQESqPl7Gf4psjFXjSWH+MNmXICj+vSHXF7VlfdhpTS8HFbWeG1iuR6ctyFoBZLdh/ph24IV4+gqUjYXuDn/wXFqlEosDr8rcd6n9b0oDAfOGQhpObPCm9Qrp4/hLddOe/n0zRXKnE99ejtF98U7lk7B9o0RKEae9RkSD+iPy0uW7SNzbhX6facDNL7EtuQCM0UG1CANQSjpwsXkA4VxZ8MoWqIDb4ANbjCrLl3EHeJU5fSuk+6I/ls3lRj8AXBGmPX1tNygIZ9JWf2m1IcI9qvk9GkwfTetLNIO1nwpT4uAaC92vtrfFdUr/E4DNi0H8De8nhEix5Xu+6BCsMm72Lv/WNqsg3KsJLONKroin+Xy7z2SUKQAC8Iasz8B45nZFHIbGjbo9tsWRMpak+P7Uy4mhjj4gVVqpUg22EzDtp2seAyuYRdBYRriIO53YlijTRyMnmSNbhN9uY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026, Ackerley Tng wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> Sean, for the two attachments you left, did you intend 0001 to be the
> first patch in the conversions series, or separately handled? 

Please include it in this series.  FWIW, it doesn't have to be the very first
patch, though that probably does make the most sense.

> and 0002 will replace these 2 patches (in-place, in terms of order), right?

Yep, thanks!

