Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3631BCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 15:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F826B00B2; Thu, 25 Jun 2026 11:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF546B00B4; Thu, 25 Jun 2026 11:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02186B00B5; Thu, 25 Jun 2026 11:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3EA66B00B2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:40:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50E8C8B432
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:40:31 +0000 (UTC)
X-FDA: 84918847062.24.8564C53
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7C3E6140007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:40:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kzfzjvgs;
	spf=pass (imf09.hostedemail.com: domain of 360s9agYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=360s9agYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782402029;
	b=nF39JW3j/lQkmQwatHrXP+gVxxbkONWX7g8WHNq+Od5Yc2Rk4gSQPwutCCOsz4Ka76W9Iw
	vmH8P/uBDR7/Bs/CYsl6Is0HouhnoY4wWkcl2CFa+I4g4llWgOMPdqAR/QEhcjqJaTpTYf
	45oCp3ixxBpKuygxPOX3GSihw1IL3Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782402029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Itjo2jMjkwhBM0k9+OlfOfXdIDoAWufeDNJNDd1hXfc=;
	b=mvPOEiBRg68algONEaztWs+KefUwqbLXbEF+mzFws8ylr4H+NXRXJRt+Enf28QqnQhRCP8
	qf9voM0i9g3GQs9oSpTfby5PKNQqEWlfW064/ykgZo4bww4PnhKN8QNKhwR/hhBhni4XsJ
	9wcRRzzxP5lFJdxlBhvId5yBSVs5j9c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kzfzjvgs;
	spf=pass (imf09.hostedemail.com: domain of 360s9agYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=360s9agYKCNAE0w95y2AA270.yA8749GJ-886Hwy6.AD2@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8428419982eso2501748b3a.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782402028; x=1783006828; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Itjo2jMjkwhBM0k9+OlfOfXdIDoAWufeDNJNDd1hXfc=;
        b=KzfzjvgsJpX9Zz3YXkvxofzi55EgsnSIIFIjd496gtFvQpcg28St/CouO3Z0xcbwzh
         G14a5hzChmBboXqbOAQ9vuwhOSMiB2calFDviZbzMX/ES9Tyx8DxHPVoGQJNT0Kk4mES
         XuJSnccMfaH5KIpw0zH8RM8PfYUFK77H8kuMF8gi3GXWgKYA+xRaZumfTt/C6mcmuhTD
         cYsRH9N2jalbg1aepQ5q/Z8jjV4RHTYkwU7fFVJFOaPVdWey2VmyE2JzYY4rQIoGgq0m
         wCJftOONxnz+QWiaqPGhVkhua6Fnx2kAcsIURQnGanG7R0j5XnwPuSoYlgAUVErItyub
         g60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782402028; x=1783006828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Itjo2jMjkwhBM0k9+OlfOfXdIDoAWufeDNJNDd1hXfc=;
        b=WnOX56D1eW3jDVIXKAUNnyX87JHXkWbAJS7B8+NsmB+HvDaHMZd72f5WHbMGHS73Ek
         OmUd6rk7hy/YP82z1QwOQ81UJvhxynU0eoelp0vAUhwx93mgdnMguN64gKRtrBvJUsgz
         zNqO0AnZlqQtvvyDAQ8f7puKJ+Y0DkayGx6jJkTFP4DwiRuafWVI+10Tq+sthnR/IiYP
         6U2dSgi3GPAUpvcY+YYuJoWgH5pe9Qgq5bNurmS8wsO1eIwUf35kufRmUbyxeKeVfdRA
         K/aZlvkgJSkzojcQt8n15HAS3YvOJyZg0UbnNuDKeHSWn/2hgJrHBScRstcVPkHXUS+T
         VX6Q==
X-Forwarded-Encrypted: i=1; AFNElJ9O8NdpLXvH8DJQVa68+nVEit3FB6kIep8+97FLK1MTsxzW7WEKPXsLEiHOsGhkAWtmpcnqhl4K1g==@kvack.org
X-Gm-Message-State: AOJu0YwfinaXKSOC1UV6MnbRwKTEFx5tPX7Gnll3/UfCvxws6FfAY3/u
	N4YlgRXaPaYVIxqAwGSz4Adx+viqWGMHhqySq3xMdaciszXCCCkBR1GuwrlMdR77/DfV1a83sg9
	agCwTWA==
X-Received: from pgbdk2.prod.google.com ([2002:a05:6a02:c82:b0:c85:9dd2:d11e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cc97:b0:3b4:5c6f:cf30
 with SMTP id adf61e73a8af0-3bd4b25b347mr3615613637.38.1782402027934; Thu, 25
 Jun 2026 08:40:27 -0700 (PDT)
Date: Thu, 25 Jun 2026 08:40:27 -0700
In-Reply-To: <6ed7d12a-c3a1-4572-8385-754e6d5b8b44@kernel.org>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
 <ajwMYCSrPlxg-Fok@google.com> <CAEvNRgE8HZDOnexMJeim6TjmxGG1AUXFY2+HH1YyKB=aM6D-DQ@mail.gmail.com>
 <ajx3vmNPRf-M9kR6@google.com> <6ed7d12a-c3a1-4572-8385-754e6d5b8b44@kernel.org>
Message-ID: <aj1L626RI3Ty_hh3@google.com>
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 7C3E6140007
X-Stat-Signature: x44g1hiiqzebigygiaqgcow96iwgiawm
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782402029-717475
X-HE-Meta: U2FsdGVkX19O15ryD+A3OpKv+zi45UfvZZvj/qfY/p0tOXaGaganCT7XQpPFWkW6WuxfF/RfhqunDmdREB4Cf4NFWjLRc/mPVLvjXo56EcUl3LvDqB6QVPTiRIoVIos5EIPitoF4Jai/954EsTMTu7AiMpvZhK8PFjHZ+gHoOk8zgkwLc6+jnexGy31goxMC9XwGI8RpOV2/pEBcXdJG5YHSo/LnUh5YZEKF7eeBvQKTacrqOakJyilSTQDAiDqpzQOjM3HV/tSW8l+FXMC2nPbfLZLUjf9iTj1zll+8SnlmGhw4KDgWgufludTRS3qxzWs7mha5zymZoEe+6Mt+1UI8cSY/xNpChZWJa4zeky+DNb4snaW2tPFCL7PxA/JPuj0ALt0oHF2jZ1AzXk58S9VSAulvXMr4Egln7qNxhOEGyGXMAc8dAKVpTp4k2XyCqYtaOV+4PRdTPYmoVQiMkJQLaadyd25I1AocZuiau2wQdEVZjYAx5i3EWtYE9RjmJvGy6VVLKfywPLC7vStcNL0oJQx89V6R14JdX3ZJ369JhGyVPVjhF3T8gO+IjySZWNiTNgSnmUXQnOFmnzd1fhaTnBIfz1law5v0JWpms6a/q7h2l9qgTj+NAE6i5NkYMVyWBngUE0hiwIO2Ab/cbr79kGg/IUBrLKRhkor2V7LFzzo0zY32Yr99kAADTJwyMwKSTdD1wRvIFwd/rUyPcf41YeZo0fykXgZ0EwYQAkXqU1j2kgxP2hsyn7b/wAB61auG4rFMfU7JToUtrLG7paPZJMroYEucB207PtHgSHEonkyAGLrxwRWxiiKXlbpczkVZB8E0nchQeT9TjGcPAmzuGCu0RlSO12FTnWz9j8Bx/vHJ+4IJ9ivgpmfRXHGocWN3AkJYUPYiQ/+oSQhQU2h4Tu9vKqOWtdGtLh1yGpSZXllNHRWS5Wnvng+SWAHoL9CYCoseZLreSecMeYe
 jhJTATkY
 iEQR+M+cZaPgHqCI5gXR2FlAYhDLbGhUPjPPFcWPmu3h5jxZlwBml+MljBOMw81xaLXysPW+rQZlsN9HbG0VXBaeNRy7Dul8iht5mOsRJ0mIeZPiYx3z4DIS9pazg667gT+7tEn+UkLRLa57SC70KCTzDy7KuFdV+Qvbb47UMzThAVn45S93oysny/Z9WeYXzlGkSkSuNiwZeDdcpTe2NBQPkKnuQhDSHlR5ytRUusdaAPEXrubRl2v/9jSPJv/hzzoi6SaGvc5W8WrGdciPpe/bQfGcaiRUezXK4Ks8gkhYCt40WBj6gs5EAxFgurE5pwbItb1059+SRuRWnWOBUNC4SGw+QI5mYV6f3MuXrFwDsPgTJGWOsU0tXmfDd1FECn+jgz5QXAnW7TzSnsEo6p1mN/8aC/3ZfTI6TbpFrEiIkzM5FNZFlO8VzDqE2xBBYyEfso/pHdj9QnL84ETMlfNXRC5k6KPtv64nr+y1rZXNmyzUHxRTtzFlYMaiMOhCBr0B/sum2ZR3koP+E9yeM5s4XaZaoAwwOQFGto42Qa6V3k4LjdlF0KN67kObqR9AZcw4KrJVOtj/QAgSosVIvtxRZfcDaOcq4MMKp9OtASMjMLAe3viHvKFeWH4MXDgCWThgtuc/Kmf7ozmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026, David Hildenbrand (Arm) wrote:
> On 6/25/26 02:35, Sean Christopherson wrote:
> > One thought I had, to avoid the IPIs that draining all per-CPU caches requires,
> > was to disallow putting guest_memfd pages in folio batches, e.g. by hacking
> > something into folio_may_be_lru_cached().  But due to taking a per-lru lock,
> > that would penalize the relatively hot path and definitely common operation of
> > faulting in guest memory.  On the other hand, memory conversion is already a
> > relatively slow operation and is relatively uncommon compared to page faults,
> > (and likely very uncommon for real world setups).  I.e. having to drain all
> > caches if conversion isn't safe penalizes a relatively slow, relatively uncommon
> > path.
> 
> Yeah, the lru_add_drain_all is rather messy.
> 
> We have similar code in
> 
> collect_longterm_unpinnable_folios(), where we first try a lru_add_drain(), to
> then escalate to a lru_add_drain_all().
> 
> Maybe we could factor that (suboptimal code) out to not have to reinvent the
> same thing multiple times?

As discussed in the guest_memfd call, we should do this straightaway, i.e. instead
of merging this series as-is, so that we don't export lru_add_drain_all() only to
drop the export a kernel or two later, and can instead export the helper to drain
any batches for a folio (or set of folios/pages).


