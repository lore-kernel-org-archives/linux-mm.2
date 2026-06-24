Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF42CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE21B6B0088; Wed, 24 Jun 2026 12:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92BD6B008A; Wed, 24 Jun 2026 12:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82EE6B008C; Wed, 24 Jun 2026 12:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A32956B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:57:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7103BC1CD1
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:08 +0000 (UTC)
X-FDA: 84915411336.27.C714BF3
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 929D34000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OMTbHSw+;
	spf=pass (imf27.hostedemail.com: domain of 3YAw8agYKCMEzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YAw8agYKCMEzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782320226;
	b=EAJs6tNBoz/JYNj0EexfGmwjiknPSbU2OK5bRdC1FhFPNUbf6q35xlTLWcxG/F0pGcBJ1r
	3PvfMxx3N+8ETPn5ddzdnVQ45/FOxnXjJOuqG8CK6drWs7330vMNa229PqhRkQhsFQkFHB
	3E4542935Am7lTwqVBWxOw1IWZ3RBYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782320226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTiRAq90VFPvdthoswICGCbbk82NFtmBH/qctXPK1uM=;
	b=yXFipntsrUjAZAChYW9sHrLGSahrKF2zJhYai+Go0IzFfGOZAsxdUIIDqq4Wda8KVi1NmK
	bmYsRuHMugQKQ53YQfzAfYIvYejfGTKXinpV1SJHKDhedKxOD7JsQXke3ZtfL398DKvgbK
	9dxA7KKSMnJFTOtDHBoVCog8GE9AUVs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OMTbHSw+;
	spf=pass (imf27.hostedemail.com: domain of 3YAw8agYKCMEzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YAw8agYKCMEzlhuqjnvvnsl.jvtspu14-ttr2hjr.vyn@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0d0516ad7so8395715ad.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782320225; x=1782925025; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bTiRAq90VFPvdthoswICGCbbk82NFtmBH/qctXPK1uM=;
        b=OMTbHSw+QUTAbAKlmMxeS4jiITi3TRX2I3u6tNzNCDKpdPyd7Jk7JxX04al7I2Xvvu
         F/eD2KEvQ752cSKqb2rMS++p3ax1pq0hrQeRVngcH+1yUQBVdbMIZ9LWA8VyGSRBFi1Z
         yjPuIKUaZdwC4MnyE/Lnh2XJPj/1m/Onp6Ppn+nHqVpAmVsxss3PUrQsDhkQHgWKwYZ9
         +iuy4ZTFMd0BPX2t1CelYxlExj1jDjb9k81f7dJA1E3DmYldsRgJHHHVboZVnvk/zGLt
         amHpYGpIVaN3kWf6IgaSJlNRK+Zn42GTuSbEZd+cM4+yyaxeZWPhO5HcNOW5P1f8UB1q
         2NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782320225; x=1782925025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTiRAq90VFPvdthoswICGCbbk82NFtmBH/qctXPK1uM=;
        b=cssgk8Hctvwmz9iiHutKq98RVZcyOQAKEm0anJZYf6SC1jvdcuwSZPEIW2UI+u0/Gy
         fufbTiqYLj0cCwADpza7sPXKGl+e2cl6arOXH3YfRfGg7Gjh69O5lYcs1Z8l27L+3u2C
         W9au76wJM6bwl8MrDyrwhvOi48VAg5uY03aqlE/7fKRSnuIx+aLKEfCZKPAY0rlODFuB
         5PmVYvX99LdWcfjRmLZoaMiXMrG3LWpzquL4AyjFVnko2e48U10JjwwlpGR5+u9t+fKo
         DckdqnIljFHmkT5dgLsygohhvsauyPo5n49X3SPKlEQISsjSG647ExRt8tqqEBh2Snap
         s2PQ==
X-Forwarded-Encrypted: i=1; AHgh+RodA4BDyV+EkelKVFqKq/GCnNgo6YM+X8dKPR5ov9WtKMnFqI31OsLnXlwyIRJU5lnmoM2vsyIlPg==@kvack.org
X-Gm-Message-State: AOJu0YyfVSP4m0KTvTZKzpDG8Y57MvUMqnyHJ60Ql4E4IjU9UZnJkecU
	GYpBwoDaNUYGP16Axnr3i+nD01ZU6ffK1UD3Jmci5Z4rcpgECCPigtzYWvFmcshzEH25fzKw9Dl
	uC637Rw==
X-Received: from plpn21.prod.google.com ([2002:a17:902:9695:b0:2c6:b814:535b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fd47:b0:2c0:b081:84b1
 with SMTP id d9443c01a7336-2c7e1464d1amr26763135ad.10.1782320224855; Wed, 24
 Jun 2026 09:57:04 -0700 (PDT)
Date: Wed, 24 Jun 2026 09:57:04 -0700
In-Reply-To: <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
Message-ID: <ajwMYCSrPlxg-Fok@google.com>
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
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
X-Stat-Signature: hij3tywfodpu4qbirc1mcrb3rf1dww51
X-Rspamd-Queue-Id: 929D34000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782320226-899713
X-HE-Meta: U2FsdGVkX1+DqEzTiClrO+kDYxaxZwJtr71UQ/1dHz216JcVEIYTTJaEGWXtDNaH4EE/f6GlZbDvOR2pOLL4woSV9NkXjWpqxHRAMWRw1atBYDzBKJQYcDWe8LE0Gyhn01vZ4NHRCCHcMe5vP90Z5ZI7Q6Doss/950CHS+S8ZAnKgyqHT31BljfFmPZXSJYC8CQHMNiSshc9d+U0eUK5y25T1nPzqU8QdFnqzUh4J6pEu56Fw3ots3jnU23GCltHv5SlG0EERsxVy51pzzmSSh/0z94+zyqcxE6LcwioipYrTUC4BGx+Q541Q3ap7oaMjT3BR9xn0//NXDacL6gzQPElZWruZX9KWZb4jXBTtKO73RZ/RazFkI7jUoA5ubiUj7du2ZPsJRA051GaJigwvcm6F0uwKuuHvo5r1gDIOddVsxBMdGcoZw116SqOiiJ0PMCQGARmX+TkSqi2w0qV1IBRO0mPDJpmMLuq5bbIMgy3InaZy76nNV9FyXlNm8Q0xnCK5TprCwvdeWu3CCJcQJn5nS9HIa8Yh4d9PATfncJl+MALs00wfMl0NNtAqy2gBcybBmX6ByHjdYYZrlj4xeMWjN/SmqK8T5LsA3RSOan1dplDaeX1JmFB2Zl6cRB+B08JFpacXMQG4lQT7nmboQKzbC/5uZHCAmaxRPycI6X9fmDraJdCVEodfa9Gv26sVqQe1w84OtZnX/0egHMZQvQgIDaoz0FTocX1amLMRaHB6+qKv+zSS69dkA20wIu4mCrbOUXRVajpiaboNLK/yH+JUT2qyAYIHINwyQaO715hjQ4N0fHoYYQpkxv5jgEzozawm+/X31oD6Qo0DO+9YtXAiqIiRLkq8slbnEP4vtQtBPoQpfROGWNiYFt+jC7NzAb/6u4IP06pa8/sm64i0+a79h+Yovi9VWfeMtY9gkusKXohyVJKCG/Uf6ViUo8NuPzI+KC7yuNmlr6k/g7
 q9R1p7Ig
 Vy21T3ZXk1t3oUu6NZAWLUt9LzDjUMprwoaTHGKnCGKLKZD99a6F1gilCIVULosFOhFhH5cQvi19fY2UCX+YDle6XXHpxkLICkePQDG4STjrPztaMCNmb2Bj4pRZpAWxuV6JxFnjO3hDfPNMgdanpJESEhjJSR+7s/Uo8eqTgaKmTI4EK5rnFqzntKL7AAZc7ULoWT1/3M/Fe9/C+709BYs7YF7YKbh+T4EIZEN+K1jx+Sn5S00bFObe4nFzwGEYyBkF85ienDwndxPrm7Ei5hCFGmDKZZFozCTJLZeCShbGwx7W93LwXAlVVn58gbLb0bnfzpLYrUh461UPxVwz0Kg0jqs4d9XBFHxh1h6YmClLod4khqttWtzvT7l11hZo5uqCkxNrVv/voiwAf/876WKQdWKPNgT9gaYKzjDVc35rkctlTVP4WhuLM0qJbMgPKJ8HEdIxf6cxJ/pI2MBWDokGwsJYf1Gk54ltkmnfzvSVjoLZ0C4S8CLgw9QkhCJG1vlsdkg5NRKOrQMEmsL44u9xE9IBicEryCQY810kBZqDzGzxGF0CL9M1E/tCHqJqbGcI8sFW34DvJpILajXr4zSy2hK6YsM0o6ZrF+Jrd4I1lS1uKymVFS21pIOzpjUOvpl4CDtgJ5mivJy8icFG76IBJnVQseiWHF+Ps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026, Ackerley Tng wrote:
> When checking if a guest_memfd folio is safe for conversion, its refcount
> is examined. A folio may be present in a per-CPU lru_add fbatch, which
> temporarily increases its refcount. 

Under what circumstances does this happen, and what alternatives are there for
userspace to work around the issue?

