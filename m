Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529C5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 19:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470AD6B0149; Fri, 26 Jun 2026 15:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420DD6B014A; Fri, 26 Jun 2026 15:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB7C6B014B; Fri, 26 Jun 2026 15:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0850A6B0149
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:06:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81F4814046A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:06:44 +0000 (UTC)
X-FDA: 84922995528.20.70C44DC
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCFD2140009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:06:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uo+eYQv5;
	spf=pass (imf23.hostedemail.com: domain of 3wc0-agYKCLAiUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3wc0-agYKCLAiUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782500802;
	b=N/pQ/l/03v98fl2UbgV7wiZ245PndRi1t4WZEVLSI3tqGBDeIpfDu4Aip8+gItO3lttrPW
	c9ET/3KSVdknOkQrRtvU2jMjYbcOMYEGOd091+8Z2lINUBfnQfU26bQEiXsKTfZMOm626d
	/CvCaPu8+OhFJ0sVlRJFebBkn5DtHSI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNIeHjjlzgODJP9uSdZfrjN2ZSrm2/bid/6mJJUT1aA=;
	b=NOXe97/xk7Fox5HTkxElygVfwzeNn5GQTHIpk+pyXawVDG3Kdyf2+TqkZRFrDk4o9s+m5S
	ZTR4MV55z1+VDiHy+xEOSkfD1d8kxtxxAn84ivDS3mrrk8IBMATbtwl4/mNYH7WndYbh5T
	nFcJ+vajQXyqhyjkpumu1h2gI2SQV5I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uo+eYQv5;
	spf=pass (imf23.hostedemail.com: domain of 3wc0-agYKCLAiUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3wc0-agYKCLAiUQdZSWeeWbU.SecbYdkn-ccalQSa.ehW@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c891ed872ddso736289a12.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782500802; x=1783105602; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNIeHjjlzgODJP9uSdZfrjN2ZSrm2/bid/6mJJUT1aA=;
        b=uo+eYQv5H6cgruJSj1vcqzc7FXPyDeaAkSkVdIi8wxsj93y/VAXuPhfAFeT7REXmpj
         ZDi2ErCtdLs9Is5Ar0cn8CLo5XFrJ+OPPt8iLwbirp78zmqDUERlIvffZ/uYCg7dsJpu
         CbmJeKyqLFnc+65qZ1ohLnLuX8uG+TF27kV704mY/VIhB9+uaHr7SeIdPSqxSEjwdEeG
         zwgY40MHoX2YLZtPZgcX3+ln7I6Bl1wDleT1BoXoIB/WsYkCKKdLgcGseMDcUHTlxMiK
         FKyGxr72VrJaRC61++ZW85slXXF9BmI/vvwtRzZVQn3wLLVg7Wu9MMVqvORhdaXneq7Y
         G2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782500802; x=1783105602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNIeHjjlzgODJP9uSdZfrjN2ZSrm2/bid/6mJJUT1aA=;
        b=RUhM2Y9hkRRgECkrBUX/xamitggx2YYQghcWMAn1qbjpD/F1kXxVLgaZKzss5xGMW6
         Ogh3ZhWeF4YOlfkiERhJs/FFCooepjJeUeTp1nPVPGuEa3lfRFvw6vmW+rTy8Jml0iad
         B/PT/ymfh0CXI9/2tGKwSkDutWiiWKTMgnxCffzoWkKxeMlrfY5nhiEIlbjMoj96phgr
         +cuPlgg2ec1ZFT84cOe1OaLi/sSWX2xAMFtZbWHEHejXak8hPcmzPSQOE2HLVklQR3uG
         zQvpFOlwa7e8HdOlc72J4VSj1gt4/bWK48ic6s54fItp/c0Y5/U3dmz1JgMfo9+RL8kE
         O62Q==
X-Forwarded-Encrypted: i=1; AFNElJ8BkvaKF4JlVgX0CSxWdw3HVWfZUFmKJI3o5ufP/tH0S+pNSYlIGFvKPIhobrNn0C0SOIjw/SMFNA==@kvack.org
X-Gm-Message-State: AOJu0YyIYFBNhTNotmiP+Pxmls74J2voIP+t7jjf6jIDiaKYJut0H2HU
	W5PJ98B9/3EFVSYV0xtJzEM9IKXijdV/lEDei0svtYkcIvhMdZQ6q/hF2jB4QRGb8nMBQr3DqGT
	s+Rraxg==
X-Received: from pgbcu10.prod.google.com ([2002:a05:6a02:218a:b0:c79:7778:c050])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b40b:b0:3b4:87c0:d7f
 with SMTP id adf61e73a8af0-3bf69cca854mr1600938637.32.1782500801179; Fri, 26
 Jun 2026 12:06:41 -0700 (PDT)
Date: Fri, 26 Jun 2026 12:06:40 -0700
In-Reply-To: <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com> <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com> <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
 <aj0Jf30PS2f7x1nt@yzhao56-desk.sh.intel.com> <aj087H1UWSFxbShR@google.com> <aj3H2sxymOYTWTnE@yzhao56-desk.sh.intel.com>
Message-ID: <aj7NwCRwWEfLK-gQ@google.com>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the default\
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCFD2140009
X-Stat-Signature: ukerx6ztacn83z5in1mp6cykc9c19h36
X-HE-Tag: 1782500802-103116
X-HE-Meta: U2FsdGVkX1++UpVMMsF7la7fhDTfv/OGljmZGBDTpDJ1HNxaMRVmdRMpkZQ7Ontlw7isVIsTh1oC+tjai5K2HrlsfXM8wTA7y16mOFvK1irs6XsgUpg288CFa3OyWQUrLGb/oqtB9hMMm1zW0B3jLEWUXRVi9RTh4Ahh94EVnjeDfpQzhHMMvlHYqNYTZkQZFHnMCH3xVGqQrnDNuhtdMKkKLRNxPK0XHtTOZyGs5V3ws42P3wGYthuWddDpVHUaWi3ihE9/ak7wbzzp1nnDQomrThhiHtS1T9q+6Fjrin/CsEtEGnjWbK3dzF5I3jgUHpB7jlfrITuRqKpFFLnxgqWKqS7/SQz33lbFvUG2S/VtlwMt4n+qcmIsoy7S0jRCGCqHY5yz0pUSPikrVqLU7KYUCLdPmAWAhvlLEJRA/E+falTXkogfwttb/9etEpc9Q+isvkR76blV5pa/fRXNSZ1zZx48THuS1nL+vHyK8jaQdM4LiVZHYVBHjzZ+0IWJl92zWkFZKJ++g45V2wSu7dk7Rr4JkFJwFfPW5cn1u3LntGVrTkfdXmzKzeW62/1gMggyVmaYesnQM2UduJrhO2ZyM0gO3w/x4KRC+/no/tDhmECvknGffGuL39kdeKmJ5jaWl76+vpcjs6riBcckKSjK6GXJzI6SqgBg1OIvbSq+fEF136txqxg+sGkG00l1ysETNuh11qQEpT+N2/9OKLVZi6JGfKkaXX+ifRTtNOs9hcIGczlwDZHJkqsKGolpTmAdgVevrx942zQZfiTz7xIflp81mRhAXYQVU9SzBSMdONClAb453kRniYsxZZzLyopsp9hGx3AXuqKOCN8j1bZbI67nbzaRGN0xZ6xXQWi1Gu4HZzimPrEOKzWBk5BcikyHJvTfIpzWLlJN+QC/92QfU7680jFVpevfrfNQs945EsGg8QzVJ6XE96w5Cn0lu3jY+PBqusKFQCMt3Fs
 OKl3fzuM
 OSK8/C37EpJIQC4b8jlkpg0NX4qkKFnJ4lps52c52rOK0TEj1KJRidbtHAxTtALpw2ptEJdAJzHrpVL40kzh1pxCMkErEu/63duWNpw5gjflCSdOL9941Dwr3lEJOnzbRzUXNx+IsDwKU74gnXCL8CSklqEZr/GDDTIZw8oakg8uxP+OlJahkleA44O8Q1wx+kgYPVI5nuri7QjK5u7Dg0VC3IuzD/ZIbWst2tTKAsEfi9c/fZXdIMfTPYWKVoMLU+AWHMNRv5Tfue6l2AefiM/unT+hYJzRztuzVEyBqSKXwymiFbpiQQet5uHHZSjlbsEDuMLNJFXydiyyHRZrUS61crXx4owN5E0+nZVh+SHlgtRpz4ysTnxT9/ebe4X2budG2OWzabeal8pGr9X3snt792lNtXHWThSY7inuj3fk4BuFFH4Gf451N3EQtv7tSbeiC4EaaQSxZ3CPoPGi04RtpWj6NpMK9ymEbDNMmZMMKw5FxM6whW9I5KyR4/RXojTp0UI5QRVwE/ppgJdTXknYQJbiutTBS9i1mSe0xoQDQsnkVANJUxpE81ro/BPZUmYUfx17rV5wgm2WjV6m9vnx2ByZm/dBRclNO5t+6pBggmYF+mF3N+Yub6amQZ3nTocJJHr4ClzAx1lI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026, Yan Zhao wrote:
> On Thu, Jun 25, 2026 at 07:36:28AM -0700, Sean Christopherson wrote:
> > On Thu, Jun 25, 2026, Yan Zhao wrote:
> > And I'm not remotely convinced that prepending allow_ to the param will help
> > end users diagnose "unexpected" memory consumption, in quotes because anyone that
> > is deploying a stack that utilizes out-of-place conversion absolutely needs to
> > understand and plan for the additional memory consumption.  I.e. if the memory
> > consumption is "unexpected" to the end user, they likely have far bigger problems.
> My first impression of gmem_in_place_conversion=true was that it enforces gmem
> in-place conversion. However, it actually only enforces per-gmem private/shared
> attribute.
> My worry was that people might think it's a kernel bug if userspace can still
> have shared memory from other sources after they configured
> gmem_in_place_conversion=true.

Ah, I see where you're coming from.  FWIW, truly enforcing in-place conversion
is flat out impossible.  E.g. userspace can simply replace the memslot, at which
point the memory effectively reverts to shared.

> However, I have no strong opinion if you think gmem_in_place_conversion is good,
> and with the above documentation. :)

Ya, I think this largely a documentation problem.  I agree that a param name
like gmem_private_memory_attributes would be more precise, but I think it'd be
far less informative for the vast majority of users that only care whether or
not KVM can do in-place conversion, and don't care about how that is done.

