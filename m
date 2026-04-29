Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F09EFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060826B00A4; Wed, 29 Apr 2026 11:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F996B00A6; Wed, 29 Apr 2026 11:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40ED6B00A7; Wed, 29 Apr 2026 11:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D19C16B00A4
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:06:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 370841202FF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:06:35 +0000 (UTC)
X-FDA: 84711919950.05.170A00B
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 422D7180004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:06:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T6rLUcyV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3dx7yaQYKCNIG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dx7yaQYKCNIG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWWhH3tU6Hs8N8nztl0MRExY7a1xORY3xqlQgty50GI=;
	b=IUBJjaETJLNJafCeFz6I8ZX8wuDK1OOmqnQOBjBCgyvBMH18F11MwXztO3yHn4BEifM1iG
	r9EbhAdtq4pRtScS/iVCIIlXyBu+uaSkSP3ZhmqbhYNd/o0rrPFkSFf9CNPZNJ5jC10wPQ
	1hcuHygsrJFcJZQN99kFki2zsFmtp5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475193; a=rsa-sha256;
	cv=none;
	b=21Qy3rKKa3g8L3ccH6BpeDmm8iF66qXKdfXHUxdyVyXulnqxI1AyGbjHQmcT9RKmanOhn5
	0JOYrrB1WRtaD0YQEK3cfNHuJwzW3qSTrdlVEW2StcDoOvba024sPzFO9ykRZnHfXVVHS2
	fL2t9GChwZW+9sBLIIBpaCErstgC0Zg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T6rLUcyV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3dx7yaQYKCNIG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dx7yaQYKCNIG2yB704CC492.0CA96BIL-AA8Jy08.CF4@flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b241be0126so244255705ad.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777475192; x=1778079992; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xWWhH3tU6Hs8N8nztl0MRExY7a1xORY3xqlQgty50GI=;
        b=T6rLUcyVsOtBEWqYitokn7qBb6qigiEetiFa8cfgRF0ovUZoa3ZeyeBb7R4RhVNbAX
         2Mo8wpRjEgTleX7qb2rYUnu38mr6RZnNChRRp/KdtwmjnGYWnoYHWYAWdIryP8fSOY7c
         mTJwol2qPBy9Uftvgdy1HyV7QCBmfcItn4DstdaR2U1PAXN+PgW+7K3LZzDtXbmXSbf8
         s1vmPnW8qk4cIxJWiuQqJm2h4A3fHRrfvI0Yw/OAbkQYvCbapKl13P3IsZ8qH4kR5YR6
         +ZUYjSRqC/8oPXMijeHnc785s0sZ0GTJTqvWMlIsxS4eAw19EUnwUeKr6NQQQ3y8lBX/
         slJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777475192; x=1778079992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWWhH3tU6Hs8N8nztl0MRExY7a1xORY3xqlQgty50GI=;
        b=B8y1LDmfVqHu5PvtvCmKbh4iTXyLnfl5Olz7Fwvs2Avrer/bQGyAOx8XVXDwRC9rQx
         mr1vb+8Ld1FoQxHq6VGipeVf4hWOrD7fbBtM97IuL6VtNpJMrRRuDgFY621oP9eLbgWF
         9ahvWBTZc458V7lhpPUKERck3bgAodvhrQnzCDXvXNjqgkliq5mbrzeo5cEBP17SbOzK
         R9PJsjckH6NAcDz5nCEO92zVMrQQAhXyX0CHhNVTdd6YOaEubJBr/hiXi/LH4CJkQbIu
         GU80lo6AGt6j3aib+4j4wKhc65x3j/7wqCksCiE6nboDKwnB1xmRmVCDvUebO6omTpYg
         wRCg==
X-Forwarded-Encrypted: i=1; AFNElJ8cSSYjo2u+JlIg6UBQ1RQogJ0hr9uH3oFugV38TGJn+QM5b3CxLKRkgg8ylZnTnFQDDa2vPqQckg==@kvack.org
X-Gm-Message-State: AOJu0Yzn5v+NWLv4QlCSfvJMTWoqZP+cG6zJotmJKvU+CuvibvPacAE/
	GEOfuKySrwm5hSl7bRWvVK4Yos0OZgzt2dlZYqTbTm47mReEaqPaZQVh4++iWE0w4wSJ0mSDzXw
	L5rnXfQ==
X-Received: from pgac22.prod.google.com ([2002:a05:6a02:2956:b0:c74:42:899a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e081:b0:39b:862e:634d
 with SMTP id adf61e73a8af0-3a3af6802cfmr4445875637.39.1777475191266; Wed, 29
 Apr 2026 08:06:31 -0700 (PDT)
Date: Wed, 29 Apr 2026 08:06:30 -0700
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
Message-ID: <afIedjYxPBrit2dX@google.com>
Subject: Re: [PATCH RFC v5 00/53] guest_memfd: In-place conversion support
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 422D7180004
X-Stat-Signature: ft7akp6uzunoewkwpjbd3zaxrg9gxucp
X-Rspam-User: 
X-HE-Tag: 1777475193-585566
X-HE-Meta: U2FsdGVkX18q5iIOKLA7ubk2dwzw+17kPcuTvle8xQ8Ci6TPjH5GxGno4Hy8BZ7uOSa9T63Bco4J8UKBBBI4wydaU+6T7XgTn/md9TqlT3ellECDPNyclkfhYbHiwcI8iCRx8FClHGq7STCVkFtESF88fDkCVe7JqbR1z99lCcX/2bWDweSn+Fmd4w9OoXbJuj11wX+ZLMMYtMYCRDqzj88dO5tbaRHxqoO4LyRwqgEGsMYnn1RyAUEZ8hwkmZimfXJ+GtVbSAvcZcM2VC1EgQUvHoRCRTi9J4pulnFi7MFHKwtCLa8AXXXNdnMGjKUzYmJFMCDCbR5NHkBs1nA4smG9QIqH0LWCzNN6+V/OfGuw0lnX4xkLtfuQ7Rz20w8Xwg0LUYPwZ+CyK/BYwgznzGGU3Xkssd/XsJNs+fwxFd42Cd7K4djpreBjxKyj8UGp+Tu963NlpDv2RSx1fHCCS1uDqtfUb2LID7hTAb/AS3vA/dhgMXe+aVPjXxOzPPfcv2YmLJIkwv41cEZ/KjE9JhINrWIb9OLsAY/3VxilwGdlkwjurcsKJMTUY9jRiWDdaVUF5QVbYEP/bkp5LfSHQPdp4YMNayuatt4wl3yhSGRH222AuwDfSFdc2RJkUidOYQmvoqPaMdSZLa/rX3AcisHsuiDZrQDNE2dWMwBK/nJCEPrM4rC8y3W5euIssNVMDaUHsdkaFDfzNV4wal59M2cd4ewDMAIj2V/fK79I6dKoeG2v3xIv3/imAvISOd3KKuylt6zCY5xbBLZyBAN3a655ffS7m+jQZMvHdh0rhrwPkYcAVq6DEX8DvIyZd9aSXJ5dxtI9NHqvNIbdO3SXSu10y20g14sO07s5ZtroFi2bD+PS+rCAH9UNh6ymLL2NDhpB0M5ZBV6sOWnOOvNCBayxa0zUqVi9+4dtJlUPCX6DSkl3RvO/A1JPplXBuX04LObgsxhO+H849YuPzuV
 Z+ug4iQ8
 RNxHwNAs1IMJ/0EgAvIchygoOz22MTYU3CQ0VbjGe+cvlpP1361TZ9Gf0EHQ8p5Jgr5UCb4rRy/xOYoiUqWnLkni0AdXFQAJ0vVf4/st9sVnnoDoAeuMrnO445cTBOeBTjIwNpXaLNa6JK8cyeHaDCpig0cZoqDb7EQdrzNTwEJY6LUywy7lLeYJOJf1Q93H7CQIX5LSFIQujlcUhdO8ut8KRsir52BNsZmIR717cEJe1bEQ1RWp357Ng45vfu3KniOOdppPowBuhAzEXmaNsmBPv0IaxKgnD+myPn1xXaunDHnCNdNQPv/7TjQ9jnp1WxV4z3PQwkv9TTcBv6OwyfWdkA9+WTmveVLty+Y5YKHTl6IiN/Z8tFhYZjW/xa8tCKKyaFYDP4pux+Ogn2n2Gr9/Vr0n8da0vg/dWsyj/HBobGyHNBxubi0lYIvbk+WeugzDiyYExHaq10lVXdCSwatQHSpq8/PiD3tD77zeaGC4SOMYnJ9xUiYSsI1u/3mwt3BOEFdIx76lvwhTEzXEclxt343zCpyHN/rdz/xt1kxR90bT2bj/Tmb71LUvIakRUs0VTgov4kjXSTIdFeYwiRKuMVqRL8evjNU1YFQqHFLLuCfT+DgtvkdwNOS1A/X3jDmRenSzSy4Wd60DqtXypJ/vilA2gv7HKhGH4edjzhADY1V7FBNHitF0YOKiIm99gCYjPyTkgi8vNw0jKgGN5npKGuh8rhg4ilIRu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026, Ackerley Tng wrote:
> This is RFC v5 of guest_memfd in-place conversion support.

...

> TODOs
> 
> + Perhaps further clarify PRESERVE flag: [8]
> + Resolve issue where guest_memfd_conversions_test, which uses the
>   kselftest framework, doesn't perform teardown on assertion
>   failure. Please see proposal at [9]
> + Test with TDX selftests. We're in the process of rebasing TDX selftests
>   on this series and will post updates when that's tested.

Why exactly is this still RFC?  The TODOs here don't strike me as things that
would make this RFC.  Blockers for merge, yes/maybe/probably, but at a glance,
it feels like we've moved beyond RFC for the code itself.

