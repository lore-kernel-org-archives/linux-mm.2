Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F261C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFE96B00CA; Tue,  4 Aug 2026 17:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186816B00CC; Tue,  4 Aug 2026 17:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C40C6B00CD; Tue,  4 Aug 2026 17:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D566F6B00CA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:35:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 602401C08F1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:35:49 +0000 (UTC)
X-FDA: 85064894418.30.AE6CE07
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id AFEF040009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:35:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpju236V;
	spf=pass (imf01.hostedemail.com: domain of 3MltyagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3MltyagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785879347;
	b=2KSw7sGS8f/qIPqgYuEFug91wMCfjDRMdVe7EV8attqckkDLVh5PMf24+eYlCYSIRiJRmO
	F53RWIxFsG905gCRcKpZy4RYtxwx4GdpSftJyRX7pRfpcb53qOPFYfi300xVTkOzvnRCou
	ai96oI9RBjbzZUS3n29ortk8NTMzhdI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vpju236V;
	spf=pass (imf01.hostedemail.com: domain of 3MltyagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3MltyagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785879347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bYnpDQ6zlSv6ilwY+IJ9PnRIeS2oETKLqCHbQFwvVI=;
	b=xdWxBsGDkt5XFTC8EUByUbVwa04TXr0YYPkyk41Lkt+TAv8iOWxXQxoLdDUGsqco0v9N2A
	o9Q+IjcnTW/XFXUBLmVyCGUR926YKqcYi7V790IO5OQEOdJ8GzPu6dZR1NCnvjGlou7zcL
	ZsAy4BIAwtLR+9VLnAZwpaJYG+E9pp0=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8487eb67173so391816b3a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785879346; x=1786484146; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5bYnpDQ6zlSv6ilwY+IJ9PnRIeS2oETKLqCHbQFwvVI=;
        b=vpju236VPjUtxeyWRevtxlT15zOjsnE/f/vnKDcv9mzD/g6OS9AhwbVRLbNZUMOVTs
         7HqypI5KZ+1HWUfZy3tB+0PZTv/hPfZdZxBJ6xKd+FT5qoSySSIa0kLHXmatTfoUeoD7
         HoofGNvXzOApa5uL7GIiKaokUgra85lR9xF8GndTbIaWBPG1/SNLUvwOCSfB32U51Ajw
         VYR3rdWur9kb5GFvDIZS7/hxVA+QTTthqryrwhaIYm9QHeq5t/dv/5josnEPKpQs6kBS
         sY8sFwsfdDqiPCQur2jDL71U6gw9BqkdrWhESYsQlG96jInBChwgCvJOpi1JmE82Hfrr
         JGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879346; x=1786484146;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5bYnpDQ6zlSv6ilwY+IJ9PnRIeS2oETKLqCHbQFwvVI=;
        b=UrTuwWQEYsWlawsOXVNdjwDaWOikVTuZWjNESVRbe9cAefBKSZAx1RxZN3ZYnsy1PL
         bFc4xYW3RHySKfOxIUCNKPSgGVKjT/wcj0PpjVDT4sCe9dUZDoygSHxjxJMviu4Sqaw9
         LtbPCENIoBaK/17fFnS7AQxZCrcunQuIuigB9RiE/z2OoVHDrRzndMFMh0grsqInp+pb
         A9ia0ZNUR8y61U/WyRqIap32MBgmbQrQ4rQi4Byq2usvOQ17sraecFkstkkBo6nYn55d
         dAk1U4QtTOxfKGJYRuVDA8MGw/XO/5TgEWn17GOvyIvwyf9lnCu3yJqnOpFLQqf1VUCE
         4OaA==
X-Forwarded-Encrypted: i=1; AHgh+RqEljeaDOD+bQ9E0WA7XHKe7byQD+yZ+BKdRua4oR7+0Tp9ZgfMe1gbyQKQ/fAw6rbI83TYGTxQbQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3J0Yx8/z3fbPNPOnV8x2s3vNVnDl+uoBkaNScrwvA75hC6a3e
	FWHvzbaTNDefSzPIShxtqrPOdTVIsTW2rQvii+gXUkqNXqmxC7Qytfw+UTmuW02phny2R/ahKN3
	cHnATVw==
X-Received: from pfbkq9.prod.google.com ([2002:a05:6a00:4b09:b0:848:8808:ae6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d12:b0:842:708f:39be
 with SMTP id d2e1a72fcca58-84f2dff7a22mr1642518b3a.5.1785879346115; Tue, 04
 Aug 2026 14:35:46 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:35:45 -0700
In-Reply-To: <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
Mime-Version: 1.0
References: <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org> <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org> <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com> <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
 <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
Message-ID: <anJbMf5GBe0Pxh_x@google.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFEF040009
X-Stat-Signature: 1ompg9gemo4d5b5hgimk1edorc6oah4u
X-Rspam-User: 
X-HE-Tag: 1785879347-199711
X-HE-Meta: U2FsdGVkX19+dbBSEmxjtehYC3dWMR1ncWwCWUT1aKUEfWIPWAisPy74bNinLNk1mvNo0oZyZhTvx7V1c7xjGdCBhR6OHBoWLzz8+bcD5l7F5R31q5+6GTdWbpoiQbZ1/54GPyz6LRpc9UZd4GM0J18EphglagUuuXBds1fae9Ng+5KkwIrxEn3uKxiHBV/IuPHahm/tU6MVDqlNUxDJ3BYHDEUOVh3yRe82Vu8ynE0pC/xZXoKeYJvgDXEb/gMstVcWO0W48uE2rnXhOZD+0DCP7xVetZRTqM5/TsG5jgkBZEJfub8PFq+NzRRNc96elqUUmwqOZA0OMQLojPMBlE6+QaxMwx0UlyoTv0hz7TY6Uo3ML0PDRSM82K/GWDEVCWR+rFjAFV/xuo8pOktgHLIWUu60VJpi9fb3jPH5vMEkKDdA3eW/sTLZEBsEj/Ri/O5cy2gj+Wl1lSR1jYTtBlxpvv3DXU5N1s1DrSAg/iPbK1Yjm309C7YRCV2X1/RrMBYsWzWE8y7/HduHjhiWpCDMJ/eOQCMdguWcG8UwcmfJ4/y6CKHkNpZTw4iKeThHGyp/wrrhsJ4WaNXp/UR0Kbe8tgmsqqkKkQje+faqeX/ZLULj2YfAurtkKi5Th4T9gq9HsnV03+6n9L3WtcF9zVhjvDk7eRRqsZXvMkOQIeviziY4pwytsxaz1Ep5IfxwKej/LAJypS8OVQg+cI4ulXE/R3vTXQiVm6kjLnaCmiHggMVrGbrP7GKxlSw4HDzjKvGsXj8/u3r8kS91hNODquPiyIUX3NqdhuoDCb61oqcFpUG2BUmc3Fmw9Xuu51tK/GG2exXZcBP3z1bR00MKHIiCQ/wG1fyDTzZDq8QPMKvEQzwkIE9OjPQfBXuAn67UYrZfWomRs3u8ugoQB3FK+I1+9G6fretpHL2lL1hrNaiSjX9aMKtdjJJOWeVXnJDcTna6A7I/gAuWu26WzrS
 0+7nagX4
 LQ4/EJ9XA0I0oqUamUWJlTsO1tKl0+YMMbqd7wIQtk1wUVzwlJPQsYtYAXtiIzkW8v+HcmIp5rdz536t6lMGBjf/Uj9FfsesEhfPfmXvuVywNUr35XjOR7f6AlTK0SaCwNSy0YBi4jaMqvgWhgXMAy+NOxXzuvU2StAmSkpx9gn4l8fTOLIQIBeLeGPiAuav2iOASGp45+sIsdJvOtMc/QfOd4GcXvWZ+mdIIJo/xYFAWzvmQ6TfRPZJC0Q3FOfwdizHk1+oHsv9PSC9wtQTi9bAdww0OKdKXz+Okb8jkPMHXGCfjbOukwEkdHMdcea84AQRYXPJKaEyAmwldXcqwKkk85ow/MKMANzS1VaHtxRimjkcgdOSpq0KcEgcYRzP523ckfUfNqtLLvgBo8x8vxPrNYjH7aU9TPr4Shc7Du/Ss6i5aE+2TcwLs7m8q4oiEcjWpOTwBbAEG9mV4Y8CKts94XLGtdhVhW3CtaMM5NoQ9TuaGbXYADyDEUIc54y5OX4d6sGdj24VybKD8alBfCAjRX33HuR06peUwmKxec6A5UgzFRV7HR1KFUKENxQWmCxqRsH1nHkGlrAySzQnQmt9Lydfct5B67RVGlPwM8EiIxK2KTp31+gMNhu9l0ij/drDQml4VvzCZIn39X3cnL0JZvxToaGYuIjxbNZkPz8N4WS5K9/T/omrHQ4umGMdH6Fi2nVh+mniNKvp6ODlJ2GtxaGaMgsW94yKGyhbsCkambBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> > Andrew wants to give it some more time in -next, so I'm expecting it to
> > land for 7.3.
> >
> >> 7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where
> >> the fix will presumably land soonish), and target 7.4 for in-place
> >> conversion. Then v10 can be applied against an early 7.3-rcN and we don't
> >> need to juggle branches (assuming Andrew is ok taking the proposed patch
> >> through the KVM tree).
> >
> > Agreed. We'd also have to get the actual preparation patch into 7.3. I can
> > send it out and coordinate with Andrew.
> >
> 
> Thank you!
> 
> When we were discussing this earlier at guest_memfd biweekly, before
> deciding to refactor out a function like lru_cache_drain_for_folio(), we
> did say that the likelihood of actually draining in practice is low,
> especially on a machine with heavy load making allocations all the time.
> 
> I think the threads with Xiaoyao have resolved, I can put v10 out
> tomorrow. Would it be okay to go with the following from v8, and then
> clean up later when lru_cache_drain_for_folio() is available?

No.

> I'm hoping not to push this back by a full cycle to 7.4,
 
Sorry, but we've missed 7.3, irrespective of the lru_cache_drain_for_folio() fix.
Even if v10 is perfect, applying tomorrow means it will get ~3 business days in
linux-next before I send pull requests to Paolo.  That's just not enough soak
time for land a 40+ patch series, even if half of those patches are selftests.

> and also hold back other series dependent on this one.

Eh, I don't think there will be meaningful impact in practice.  If v10 is good
to go, I'll get it applied on 7.3-r1, and will also get an early pull request
over to Paolo (probably around 7.3-rc4).  I.e. folks can start posting against
the landed series shortly after rc1, and I'll have a set-in-stone base on which
to apply more stuff around rc4/rc5.

And if v10 has issues, then *not* rushing it into 7.3 will likely be the fastest
path forward.

