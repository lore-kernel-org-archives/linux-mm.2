Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65EECDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5CA6B00A5; Wed, 24 Jun 2026 10:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5ED6B00A9; Wed, 24 Jun 2026 10:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8704E6B00AB; Wed, 24 Jun 2026 10:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536B66B00A5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:38:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDE281C5B7E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:38:43 +0000 (UTC)
X-FDA: 84915062526.10.8A73D7A
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE97F12000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:38:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="M/Lmz4ez";
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782311921;
	b=VFQGCgU9BDODpBoNie8ZRqY+3MhydJrmf8bEzsgkQ36yeqeMkpGLg59Aa73ZNFIP/ckizn
	bj03elGplyEAxEN7DTFwzuIMHtddY8Ib2c6HfV0KyewZYjJNSN2drLu67w791gBaT43wyU
	u/uAKnhxxFwLSzZ7slnUbKPTV+7KWVc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpVAzGtumZJ9rywOtX3ITBDfHQ1Vjgs3+apnvgsrs7k=;
	b=pX7O4Z6sv3sYTJp5MeeAqtnTwlLGl/h2skzOuWfIY0ELirmPcSnLtCb3M3CoxHZshq+V6Z
	sFDrjNwp3ryob7jT/PWIff6XDNkVmY/M/WSn8sZtGwfsIZFWRHaVwB+asNzI1SD4YaTWA5
	zEedkTG2PE7H0r+Yc6ogf0Fp9GPQfrg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="M/Lmz4ez";
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-137335bc3caso1833259c88.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:38:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782311920; cv=none;
        d=google.com; s=arc-20240605;
        b=goc6Mp/1i8MvPEihRcgqUtQXQW1JWGhTx1QG+9JT3li/xZIDai1+hCHQEVet4E2mVX
         fG6ajTmS+6iy05L3+OqyB0IQnwG6p5KeoKFxlS0kjOn4j9DTz4LghWjWuAkoeSdgaKxe
         dYX+xEIj2QgrqabZ+0d3g5xfjXDcEh3rMl5/qouxFnDuT+jQnjy2pqcbE/4J8Ls1Gp3V
         A+GTXM9MBxcJfxap3F/q4dqN8S9dSdJmKDHnIOhIBlg76LCwDSD3cAw5RJ3OJq1Ywb+A
         tER7i7YxpLz6T3JdRj4D2MPnuJaM5kYbvD7aCIHVUCW0eW7WKxiGxSKYyy4YJKjcQNZa
         RDgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=HpVAzGtumZJ9rywOtX3ITBDfHQ1Vjgs3+apnvgsrs7k=;
        fh=9XbQC546erH8XJ36J3UXzfc3YXZYpJabSrymCftD/Yc=;
        b=kP4Sk98bIwsIAzCkHAq8ULaHTkqaN2hO8u4TYZ+ioK7wIgrlQNtIDvpM+cmEntUGoA
         meDlwHHoyHXs/jOF7h+ky9DSQ58qPCjr04/IBd9qlzzz2fjUOE+2sK3AwoB5sS+aX19V
         Cs2BUDN+IaQUqQ2XHCz82DoM+bjQNhfZPKwRYHeDVc5sQ0llQ/SLETam4qTfU/gD+0/O
         7QTcyTXP6QnBYAIdfoVAzSyh4OZ7cJk8cVsLnHOKkGYnieQdj4QG+7U9fkYPAiHW5e6W
         d3kX0izJqrrK3r3BVGz1biULnF7r/Sl7YLRdkeGFgf8DkwovA80ymslfbStHmfJBuROS
         AGDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782311920; x=1782916720; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HpVAzGtumZJ9rywOtX3ITBDfHQ1Vjgs3+apnvgsrs7k=;
        b=M/Lmz4ez9anfHdE2TQziIoXx8AZL5987J/HqAkPHWQ1S7CTLD3HlCuxa5b+6DsVGf6
         BAJSybUoSK/2QsvnNY7UCi/c3F9sgn5Xygum6rh7+ssC4Cm8MUscyMXBo8b9UoTcRAXO
         EcMNGtIf4Fugt95FMLsVbMrcdEvA/861fNgjyNtciIKsrygmjIyXh+LBY5BgLyPywagZ
         IHcGtEEPFVaMyHotbutES9+zaIX5Np4t86AF+LroWEHPsMhECIGguf9L3RNN9OO8VQb6
         RUuLRpHb1WjipLwvSD6438+ldd13aOKfh57vLVmFhrKZ2q080E5LX874aBRQIrBbXZ6a
         t4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311920; x=1782916720;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HpVAzGtumZJ9rywOtX3ITBDfHQ1Vjgs3+apnvgsrs7k=;
        b=A3GPZohN7+ZhPQnasvpx5kg332bl/kLMsTjOQxWB86Nf+RD7y3REhjpHRpWh+f1v7I
         horTVy0doeJkLyGMl7QwvhyCl3oMMeYkg6QdikCjA2VwPY7PaKDAZyH36CT1r0+jOwVw
         6kTaUKsB9DkFkFNPGIv+3xBatKXrjpLL4jKpHJW9CJXqd5gW0e5Mhb9m/wq9b+AHt/d4
         TjyYdE3boMrZGO0sQtvP0f0/z9ls8+tRmUNE2S82zLnDg9nIdcSfeU2gN15sgWADxPPr
         GLGTIshSXR6YsxMv16MAm8IQnkxlaQZtq0ecpbVWVNkUR4OIMSZUYr2FCBZlbK8rhll8
         S2/Q==
X-Forwarded-Encrypted: i=1; AFNElJ8J6q0dzwqOzG5vBil+dJ17G4ZR78VilLrMBhXO57u8HAzeqLMG1HsUoHM5UkO4iBg6mjuLNVB5dg==@kvack.org
X-Gm-Message-State: AOJu0Yzx3p4eZlMWaBCNLe1n8lq+1CNrYE/ziroDEaiA+FVHAEr/EhqJ
	26ms8vDWAdvsWBv5sR8LUzVXYgiH+S2byyfPW9pOCzc4AxoPNZOmGBjCqUaYcyMGnPurRm8gJ5l
	27Rt+o8YTm2ANc4E2NOBkdnRbX9nS/0SNHLz9WcBh
X-Gm-Gg: AfdE7cngt2qT4SH3QTHLq0EnMOmW87LT+5cR5p9aTAZ9kviALxTsljU3Vm9JNWp6TZS
	WjSFLHrOuxlfxxNZfvleGJ/9aJaXZBe0ZG/7tsPjg/s9hFN4SxqMsJ77PwsMFky0jNaF94mt46p
	/YuHM7PYCn6I3mvAZmgaZoYXU7qaE7/q7fwB+Y11o5ttBFdQSDe+hYKUVf4dPuhEgyHrDY97XMO
	+za9De0PTWD4/yngJxhNdXsKvy8GIRl/ZVi/iFbS7zU5IGju+V96xNsVb3TqydpGOsIMObVJtPo
	caFYZ4YN0vT3MeJGvo2e1apohmpI
X-Received: by 2002:a05:7022:6612:b0:133:3bb1:8d40 with SMTP id
 a92af1059eb24-139d0c24496mr2539007c88.15.1782311919284; Wed, 24 Jun 2026
 07:38:39 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 07:38:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 07:38:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com> <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 07:38:38 -0700
X-Gm-Features: AVVi8CeozOwjsDHz095RESzI1L73Y_-_c-08wJAGuPOXvsS0FIpnjscm-5zrczA
Message-ID: <CAEvNRgG-WDzHp-15Mig4hiU5Dag0pFCu70-R-9b=PkD69W=ZMg@mail.gmail.com>
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE97F12000A
X-Stat-Signature: ki4qoap7capfsnog9tpdqzoctsdcenib
X-HE-Tag: 1782311921-706809
X-HE-Meta: U2FsdGVkX1/62axNmUNovlG+0LObXKIxcEZRbAW/mTzM0Vx3VrY23J5IE6iD9/ByvrW7whIPziEkHY1yHVuxClqvIO3Fq+LUtuEuSf/B5mEaKGVnA2iHHln+L5NqHzbmZQqB6tiS4mSLHt/PXPgVHdnbY2mQR4nLdxZvfOQEOwqwZcPvKe8ofu6S3gtcbBl3pHHtRRXjqqrcvBi0r4scs0YtasvBrt/yhPzpTSabInGMlDXvIxEwuHWXg7lmavWiqMkgq3GHG8xDBrLTerDjvvE/sCvypuCtCkpUR4DUbJsJNZLu+FLtKlXTNqMd/XRcRjZUwAr8/SLRPvVAj+Fjp30HVYoaCCfykjMxk7bB8MTiXXKEpKrlr+6gapOmMGVyiqqPfq+QllkUEGCoFJ2+cRtvYeqL2g30O3Q1v7iqDfXL++lL+A7Js057S4ZGXwEuWbA84MnQ/AbjzMbXTR0H+AmRjOup7GxfBmRkPUT8+wiRnOHKGNpJIlvtFZuNKRky36AgJzqtRwBg458ER5wPo6qPKWJnh+vupI/QmwwAk3LI8bkpL1F/hcxsSAGCaEGU2/0HQVJ8j8TOfkP48ObrkSpvpeyenUy6zq04tGHdUEuEe8Y/RJClensTjlAGqCD4lLjcFUIsn8Z7+d4cF47ymoBa9PXvm6OYawT0FKxouLKvGKVUJnO2Ntrvs9wP0RQfv7JBDUIla69zJcVMXxkcy4SFbSlAhjJSLhuVS+ZqwXQO2Bvoovm7GxIgzl3Kedb1ksbP3YHaZx1z0ocOTA3ljCtTZJRDsNzH5Oga7xQvU3HfV/PbAVvY5FCmyobluNOLrHPwkuTvHni2hmjBJeFA/7ey6RaAUzRXXaWI9nr6b5CIUEUix7r2urUHUV141F1Cotvfu6TMYvytG9qpLeplf+agULyUbD2jQzByXPil7ZZYl9YwUaSFuiiCxG1smM+04OvlbF/v6NAuJSYzd0x
 FPMf0wM6
 yJVQokaoqHvUdhDZlEcFO/dEbVxW6Jsj7XeLv/uuryzOdmG2SMify+SpNT1x95lFpNW46vFJQiN0XBWbLXIPg/l/h17CUrYxWD0iB5Cu8WxzMGgLzChJMwaUn3ZqjtkC2v3l3BgkBf4yZdKnKZAismgLr4EliUJYK2GrNzmgvmWOXTBvfknfuoEjzHYqYKh2kv0LDf0qHQSyctI26kUA+j9DP0xODyAdThP84m0idQPVryNYWuK161XUk+lDFY+jyF9gB5JrAMYezCSopz30gNyHNQKbtBUSaEXgUxdNknaHPu02ESj/9bnodmC+1VZvTYIPqfOxH/wveMLW90D9bZBU79HEtJwEShPEzgpG9TKFsH3ycx63dZqanLPxlWK4j2BRWp0F3hztyLv9KrOG7vMPyfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

>
> [...snip...]
>
>> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
>> +{
>> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>> +	struct inode *inode;
>> +
>> +	/*
>> +	 * If this gfn has no associated memslot, there's no chance of the gfn
>> +	 * being backed by private memory, since guest_memfd must be used for
>> +	 * private memory,
>
> "guest_memfd must be used for private memory" is a bit confusing to me.
>

Hmm good point. Is the source of confusion that guest_memfd can be used
for both shared and private memory?

Perhaps this can be rephrased as:

guest_memfd is the only provider of private memory and guest_memfd must
be used with a memslot, hence if there's no associated memslot, there's
no chance of this gfn being private.

>> and guest_memfd must be associated with some memslot.
>> +	 */
>> +	if (!slot)
>> +		return 0;
>> +
>>
>> [...snip...]
>>

