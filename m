Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C62A10FCAE4
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75CA6B0005; Wed,  1 Apr 2026 17:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D7D6B0089; Wed,  1 Apr 2026 17:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A631F6B008A; Wed,  1 Apr 2026 17:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94ECF6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:08:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F5A81401FC
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:08:51 +0000 (UTC)
X-FDA: 84611226462.23.5677237
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 988A3180011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:08:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GlX466ic;
	spf=pass (imf16.hostedemail.com: domain of 3YInNaQYKCP0xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YInNaQYKCP0xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pu8VN/18EKGWu9s98ZXH5MFFrHb1clMJomnWtLClx2s=;
	b=GyGbV85inffa7YNI9WN/fQoVp9MVXdQqSnGuDJYvFNFIPgFE5C+cojfExsksXAO8bpBGgq
	J1l9rfO3xy6DwOYd9gqshC5lo6De7LXag0qWBimSTyf7LK+H1h5TTizbEawIbUWf+ai19e
	A7cOm8I6+f9oLYTm+j+6X72JQHZc4ME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077729; a=rsa-sha256;
	cv=none;
	b=0NqeMHJLrSwzhDI7/t5XP9v3sqrQ2A41VJlYWrLy2AD+DUW3+WIkJxbSp5E8BfXKhfltN1
	p/I7kbsyZwxspIgUnEdpQTBJisQQuzNeUDl7GuAOfrXRm4c/gTqJfspZyxjM2u5KDQcFDg
	Ze/dLjIgnclSEa+TMFf4fcXX1NKOP34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GlX466ic;
	spf=pass (imf16.hostedemail.com: domain of 3YInNaQYKCP0xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YInNaQYKCP0xjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adef9d486bso1553675ad.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775077728; x=1775682528; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu8VN/18EKGWu9s98ZXH5MFFrHb1clMJomnWtLClx2s=;
        b=GlX466icu0roOdXvAqfwc6mYxzTdIuvPPhZPCe9iGdffxm8HvfFwO89q2lDhxZA3BL
         QZQz+vB7JAnm1Dfke42D/Df0cCgmS79Jk2jak7eS671a33HgroRBRY6kzfE+z6/7aIX3
         lJlYM6+vKtuwkvcVp0CjQ2KRZcnjU3MgYkRtpsmcrsPh5QRi1FRTP4b0HRgt/DzUYqmi
         UCTl7OkPJ4/x1oY/t9CHEaBovpJxT1N5Sk8g+Oqm8vpd4IailKfzgp9uBkyLuH2pZEDM
         e7OhOPzf079g71SlHv9nK683DQaPPef88vhXy4j7c6xSYbhC9Y6mAq04Hr9qq880vspC
         7CBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775077728; x=1775682528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pu8VN/18EKGWu9s98ZXH5MFFrHb1clMJomnWtLClx2s=;
        b=AW2kY2BcGbps/+2pWhrIwQcSH8hA9ptNGlcX69Vc8v2J2kL71k2Tbbbg+FJGWaBZyZ
         5RediR+JOYzI7Ljtr0cuMLosyAU+lx7GmRA3jCBzSgqSfdTXA9/zL+ajDOLWiDRazuF0
         UFY+gW73sbi9xIqJrTSOF4xCJaXI7ujdn1Ql8ODp/LZWHAHlLKhLR/y1s6WbM023Ytqg
         tcJR4+pvqOCGjkOAJVEKkYVhNHtQoPbweIhYR8l0yZMbqxpbVit8/Q40teXY/oTgRNAr
         8uG+zPawOiGedoTy2yvcByuE4zFurg97QsMEM7gYBmfGp0740vzJmLEYBFEYWL2P/tTY
         a0Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXdtSkrq7Tw55zIvX1ITSpoymbailZ+rqqpQoLe8utokWUET1igElOFZqBWMWu6mHnYfgwDLRg6EA==@kvack.org
X-Gm-Message-State: AOJu0YzIIX4sXE6XVjx77WHGaAwW7c8sQx7qi8U+8ZX1kNhrzdiMF7FL
	n5kcSeh73SwxVzMlmG65y68NHaT9+bNDfoYBZiE3J5Wxgayw8vBYIY1CFBVQm7ZLsIvbD2Pdm+J
	q49iKiQ==
X-Received: from plbka15.prod.google.com ([2002:a17:903:334f:b0:2b0:46bd:4fe5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:248:b0:2b2:52fb:bf28
 with SMTP id d9443c01a7336-2b269d08defmr45254965ad.46.1775077728024; Wed, 01
 Apr 2026 14:08:48 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:08:46 -0700
In-Reply-To: <CAEvNRgE6Tn81Yddgbjqs-gs491NzpppjbDHKzpmdPCxgSPeUPQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-25-e202fe950ffd@google.com> <CAEvNRgE6Tn81Yddgbjqs-gs491NzpppjbDHKzpmdPCxgSPeUPQ@mail.gmail.com>
Message-ID: <ac2JXrdcv8vb7x9y@google.com>
Subject: Re: [PATCH RFC v4 25/44] KVM: selftests: Test basic single-page
 conversion flow
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Stat-Signature: yga8ocutd4dm6hjbomq75omcr73p5rkd
X-Rspamd-Queue-Id: 988A3180011
X-Rspam-User: 
X-HE-Tag: 1775077729-586263
X-HE-Meta: U2FsdGVkX19dx+HT7mDuYG+vbhA0c8WABXNlepN5AEl/CW9pOHWyqCeBRPdmjefnHUDjE2/H5AOTsgCzYtURjapXMxEJJumagSGpufJaK8BDvUqoLQhora6dzGXroq587e50lMTbP23qccBRKzOGIiHIVChThpjoFLcc/oyf+poy5d3WQLCwBoxo4ivO4pm6pODfoWu3cOjBmULX5WRz1dwMv7zuGCyNdUyCM6/p1LHcuIPyQcKfjLO+Y7nHuk96VfCGk6cu0zaAN6zyFt9Kyne6cZv8Hx8wyROvF2OPffcPz742rSEFhXJzxqZw0yhETMve/oSZxUcgdOAA9ctx5Nd5ZVk50hCACn6A1Vt0MhmgxxyLJzPSoibwDDGxPMdnhD195jHtHOgULvfXXXrC4qrl5a7Fqr0Ej8G782TTFnwAHKALsyisIC+O2PIhUwLtj3Fq+ZJBEqpMuhTXbLqt5dK1A3ysP4OfpIk6iEb1R9KNjgBCNB15uu1N0Ke0lNfylh4pormsyD11Lc9+aAVYfAF2GRXzCEiq4NL+n74a4wNrB6TY0aJD+hJNTk0gslWlUx1te9WmnEgrMmjX512mUoENMzpu0Zg7ti2SiM/fCyxyWA4Vy+reWZhVa0FQfK5KK+tENOqK2p++XmpJan09VuiN/VEQMYb1Sq83FQs/X1cG4JQ3z6r8qdef2voZc6wjB+rOxouA7tCrIamtjJEc96IajCCKuLG05hdbv4b22TaR1mguGujNI5xPhIT0+Yos6Wi1EK2ptMFE6ff4nQqV9fVi8/yR0QMDLtqK+0P1p/Vkn0Xpb3e4l2Uul2CVNKaGFNKYplSHBiyl3IbdyFUCVgHvULJngP1CPnO/oLO7GHEKmHXx8GW72Gdw3ZPjB53OZAd681+j8z07GuffNo1T2O47d3Nt2uw+PCkoTH2LxUMUj36dr6QZ7c8P5sGnZFlgxoqrCvB6dAttDOHYcTZ
 2cg4/BKn
 45oV3W9VIrOJWKLvq0GqCjElTGTM03pKPRID9NjbPEZM1RVwCyQ5ShmrJ3Tu2jFgKK2CdJXgxK/QUsV64QhrDefsBBYLoGD7tEp7C0gD3W6nKY8YJYH81QxMX93cM65XgM2dN9ygsFLwJMa6SuAvSRjbDlSUebvPioZ4KIVB3Zh8Cj2mdvnq+aOSZVmxeeukMj3Jd/9X8FM0nVq+DjstyB97D5T5aEZw+g2iWsty01OiaOubWoUF5WhNQr+uWuLAwLLhKtwO3pS9BkJ0GHEYMsqVgnB+xOYC6OpcG6GUPbZ7YIQvCTKOcPmnUFES3VsxBxNrpYni4uI5/T+C30TQj0yauJGsKxpQfo5lsn1awsEGMh9VJxu+6QGOV82Zc0aly6lJz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:

Please trim your replies (even more, since you did trim a little).

> > +static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
> > +			     char expected_val, char write_val)
> > +{
> > +	struct ucall uc;
> > +	int r;
> > +
> > +	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
> > +	guest_data.expected_val = expected_val;
> > +	guest_data.write_val = write_val;
> > +	sync_global_to_guest(vcpu->vm, guest_data);
> > +
> > +	do {
> > +		r = __vcpu_run(vcpu);
> > +	} while (r == -1 && errno == EINTR);
> > +
> > +	TEST_ASSERT_EQ(r, 0);
> 
> TEST_ASSERT_EQ() ends up calling exit() on failures, which skips
> FIXTURE_TEARDOWN().
> 
> Other than the explicit assertions not working with the
> kselftest_harness, kvm selftest library functions like vm_mem_add() also
> call TEST_ASSERT, which doesn't play nice with kselftest_harness.
> 
> Any suggestions for this? Should we use the kselftest framework with
> these tests?
> 
> (I ran into this issue while trying to test something else, where I
> needed FIXTURE_TEARDOWN() to clean up system state.)
> 
> Or is it "okay" in this case since FIXTURE_TEARDOWN() only cleans up
> stuff that would happen if the program exits anyway?

Can you see if any of the ideas in https://lore.kernel.org/all/ZjUwqEXPA5QVItyX@google.com
would help?  Converting more tests to TAP+FIXTURE is still on my wish list, I've
just never been able to carve out cycles to see it through.

