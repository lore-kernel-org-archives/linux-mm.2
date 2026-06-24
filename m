Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DBBCD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6410C6B008C; Tue, 23 Jun 2026 20:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6186D6B0092; Tue, 23 Jun 2026 20:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F246B0093; Tue, 23 Jun 2026 20:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 102B26B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:14:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CDBF1401AB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:14:43 +0000 (UTC)
X-FDA: 84912885246.22.E89CCE0
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 296B4100004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:14:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fip7M5Lf;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782260081;
	b=PO94zBYj23RKFzHFlWWpCPQAIN1JpWVwTi+HwGBNROO0bvBoV9e/Vr5CfU0Xt1m6gWQPLq
	cPJOiljeT0NuX/yN5IOsmxRXL9wIoeN7ZGHSuGwiuXMQ8fn5v4Wg6hy7YmdUL4ssYRl0Ew
	SA8B/B4yP5hG9hKttTkBkut/tpasnRg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782260081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cZCA67GzL1hK3vWmOV/udgJCrdJrxhZ2WqGtT4YW1w=;
	b=P2/77TwxaZrSys4TL1/hIZzmuV4zw1kRfqpKTLmKopfWV/ef9oeRrtlidBZcz3DtzTQT70
	czkvA687gSyGEWLIwXqMYrKeEmZEht8Ud9K5qjAFRnEG79Sx7kbesr+3az0KhgJ05LmF8X
	/Gt4+anzg4ZMqq21VaQ77E36FtiNUPQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fip7M5Lf;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-13986d61b4eso901017c88.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:14:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782260080; cv=none;
        d=google.com; s=arc-20240605;
        b=JxQDdHOF8VgIrdRGmRIU7R4kdfxLMTCytWkSVtsBhgQiiwy3wydGHyYPX7tRniMCLu
         5M5wReT+J/Szs3U0Iya7jOXGkv5tjs6dQ43RsY1+A4Pue4+ovYwEjDFYqaQHfw1jmSov
         9D3GtoUfETaDAhS74toQ4AbhCRM9K6AkyR9uPIyLS8bxNHHZgI6OP2svcT+mb6e2uZhM
         wBAmGGPvGHPppZvYoCV8UQRkc8iq4oeN+Dgv6B0LpJWbbcmAM63wHTXQRyQdfr8skyF4
         toUQm4C6//Mrbn7G9sB/K2SRi7t09KhBx64VHPdSCFb78rAQfIid/Ooqglez/XsudroM
         CXug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=5cZCA67GzL1hK3vWmOV/udgJCrdJrxhZ2WqGtT4YW1w=;
        fh=CaBo803nMB+yESxAnQTSpJqLnSlqd+Wl5SYtp0B1eQM=;
        b=g38319fDZU8fUnwr1RQ+LqV4XbZ3TLf4CLfonkcH/vuNzKFk4S0HA8qzLQoSQ24Pg9
         XUgCo7tO7t4bwOaxyHFGZLd4TfE0TPJOBIhfKXuZ3nKFMG/xOIJQuKMU/FB7be8v4Kly
         BZFamDLIbLU42K7g1PVUdT7THcyupoKfLF/vJcA9yNrcuOYbvpL3SGETjSavvZfHCqRj
         Axu97JM5tukeier99hVoZpfuZyeuqUr1PXs4nI6CVwg5vgKoCIbnw5s9O1aoTRlrXrDO
         HkoatiHc79+zvmwyQMjcq9xtonxn5jMERrzfKqqMqaDGR+UU7PN/c1IyYkm2Hi2xBhQn
         cn3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782260080; x=1782864880; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5cZCA67GzL1hK3vWmOV/udgJCrdJrxhZ2WqGtT4YW1w=;
        b=Fip7M5Lfr/eCF3dU8EDrDLKH5SOwitvUDEpYMSC0enCdyagZY1hSDGsO/CEy+n9jb9
         k8TzEvecJyXDSnjWJX280P9OAi9dYdvsyYPOiVnweP+NUINUQa3tX+R2suSQ58E4Xd4k
         EqWjGqlaSFk3s5CMG1FwUpZbcC0lxKwKqINz7IQuLcKk/0V/X9VXvwdFEU+9n+HNYY5x
         MF5+9brgmaBJBF2dmkHbVgI+lw41u2kZtn1A4HrWhUf/0a9xU5iVVmmPOzBKJvEW/Ygv
         Yv4347uYw1LmJ+fBHAGHlcZkbdVIsyI2PvPH2B7LIWKFfnWrZfTeN8syQR7fwLSPpvyl
         nxzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782260080; x=1782864880;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cZCA67GzL1hK3vWmOV/udgJCrdJrxhZ2WqGtT4YW1w=;
        b=ToT/T2OagH67Rr8ErC+0l5/TTCITJNi9Yj13ihmPakNibS5rUkTy8ak9haMfGhsDAq
         WF8ZuQ8Kpii/5UEV5begI/7B2EF+AzBk+cXgHxBQ/GTUEgrOijyEdjq83WiVgZ17NK9C
         MldCFchxYAjYzjCm1AhK0tGq0g9kZgkmYly7l0HHhZRz23c1U+mThSuoar/zrZIF5icZ
         Ehr295Oi3+hGeU2xl3F8gV97/97r9gUjmsk/LDxz67hwvPqPuDT1eA7W0P0lOs9We6x+
         mprCO3UHUG18c8da+RgL93m5JLpn0oEOnu9Nnl/DbEA7wMgMLoPO1UOmSOlhc9G6gxg7
         mZsg==
X-Forwarded-Encrypted: i=1; AFNElJ/g0uGwwlbxuOQgcPYiKpwt8BAobkaaIB/3EpVk4K43hpmG/3Oh1lQ/5SrZF/BZwUn3i1TWDta5Yg==@kvack.org
X-Gm-Message-State: AOJu0YxFazjCYWI0wVV3tmXqMCbz88t95z0dXq0VgWkq/of9leFtMMJ1
	piQTSzNjeMVEkUdL+vs/TtOPb0Qmn6i8AOHz1Sg5gPCBhRPj3ySRhDzoo8ZjLhcGlLxTSaI+AaY
	C2JKBzWc9I5qk3muPQzKl2ddPLlhEidvwZa05v7Cv
X-Gm-Gg: AfdE7cl+xoFt8qyB3JGP/CUjJK6PBRRq/Jc/ctjwE58Ccxq1xF4swTp45XFsMq3Ziab
	bXqdMZGe9yAs3Ta45sU1RCmnFB0mfH7jfyiIx/WsS5jpCS4FBFK7yQTs8wQ5KD3Fp++o4khU7Ko
	fGJRz5cXxDc3VRBPirqZzbjw81pHM7MfkOJwGoT6rOREXXg0i6wg8Va9SGMC52pr7WrdgrprQlW
	qGfNNpIslzYQIFxAODlbRHnwCu++ZvJD4dTrTVHRUMI+elYG7bnCkXinFOe3xoYdLSZZmukLOtZ
	dx1JLqmNXc//xc+Wvz5T4z4KKv/X4QauisRNkjD+ZFyPsrO6J4F6wA7riFA=
X-Received: by 2002:a05:7022:7a4:b0:136:5e4c:7aba with SMTP id
 a92af1059eb24-139ad6ac8ccmr13781633c88.16.1782260078995; Tue, 23 Jun 2026
 17:14:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:14:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:14:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajnQVkLvFl_lMuGB@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
 <8e53844c-f2f8-4a4b-bf72-f3140c170d43@gmail.com> <ajnQVkLvFl_lMuGB@google.com>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 17:14:38 -0700
X-Gm-Features: AVVi8CcXn2j2iTyhoMEqe261E6HKS7rSa97Iz0Ayq-UgAfPllC9cKLpff9jWWSE
Message-ID: <CAEvNRgGhWL-tWfu8EHf-zsU4C127xKT2wyV7wMBnLKs8g=pEmg@mail.gmail.com>
Subject: Re: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable
To: Sean Christopherson <seanjc@google.com>, Julian Braha <julianbraha@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8sf4ibotfupmfqhfr7bkxuutqag3rkco
X-Rspam-User: 
X-Rspamd-Queue-Id: 296B4100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782260080-637729
X-HE-Meta: U2FsdGVkX19YlfUw8aSaTicXklrlPoDR9B/GzTlnq+E+Oe+Y3AHLXW2YdtJc3CxkRZ4DxrDCzjpPzHX9KLBPPLqSogA+Kmk0vaFtsz1j5NQ/yxxlIn5sgOW4z93/JVHRiHmKaBw+JdSWVSs9kwYH/gr1bkJjMTmRSTaArvzjyRZzDz98Mf+DfbYLJLlkxkwT89BLp64sz6B9RgimQgYgmd0pQrJEo9xZghd0/KQDdPDw2R3JTyEjsE2lWEk/dj6zx/cQNK8u1F5BhvgLJsgxEkBKCqwd/e1M+Sd/mzu1Sy8Eb2XlZJKebHga9h0NjsPPrMXs+vyIEerTdb5jHpWlRXpx6bOqf3vaxM9JA4W7JCAm0nRZeQBSIRlABC2QVe5EyE3NGMjQxuF660EucdZ1VITseV2XMpomG0tqfE8Wla3dIpYtee1gj4ayJmKOX4tBiB52K1KNymW5Y5pUH9/MqTTUpkcQ+3xkyiAjHBR6rOXqnQMjURKQeBsTyvYwbrPbelQ6qpIH+wgy8ejNnX65udPKE1srTEtFN/ALAE9mUKAvJId2txdEUfyP8AbDxjT8Fb0pOLqcOkPyAzEqfYxSAM+0S3RI0IUU76OVppImiXTr+4WHne/BNe8r5Nmpws0lDJEJUwgUwHG09V6F4kOv0MYj1vMRZCjWgpR3ExUrsgDg3qgciXUgEzdsm9AJRInfEmvkb1R++yoF6nbnMnj3c1BuJbFXaRSxBXI9EYTkPKCqBnBFbByBHeWQzwbV7YgmjnUfaZFjYOqm2jJR29QeQ2/RQ0jgs+7Isnx+5ptZwFrjfJA5BFmz/VXiR3MWp0cDOXGHgc4KXJ6mxPiW0i6K8s10anxjjFLttBC8hvOotuBZP2A7hCJgbiT/RKzWmHOQ489BJcCS8DZB7ltAlvB9BZ/JXYPFV3ax6uKIO/cNEbyexljoMJyfGEMZmzQAE/n9SIGDw0HbpjPPCxp7vCy
 DQN/EOpU
 AHIXE2+qyedpxr8Ic532F1Shy7D1oDu5FaPtuQUiqK9jeHoy9rzVR89wZRkrXMRb4Hhss8GBaxF1qdQyBWhXFjIXw0xy+BR/RqLMVc+gzcVeqrh6PySDOrP0QcroqsHRH+o9kddNiL4jeI1gPASJ+Cy27pJ/8TDP1GgicQAuZUzylNfWJO6nxsonDSAwjrT6xRMA4MkNt3B5tFHkOt8bkx3iQvAulEjts3fiUMTE3P4XNhjFA0gQC5E9YgfZf3Il6dHD/RCYY9HIctgpVkQyk4IC/416SN1PJ0uM8plU5SY5agRM1jjkaZrQ25P03/R15rM5lUInZecxglsJEDZxh1yoFlkfvMJufOhFKDDovXKv3ySu8z4cDhI8LPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jun 19, 2026, Julian Braha wrote:
>> Hi Ackerley,
>>
>> On 6/19/26 01:31, Ackerley Tng via B4 Relay wrote:
>>
>> >  config KVM_VM_MEMORY_ATTRIBUTES
>> > -	bool
>> > +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
>> > +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
>>
>> Sorry for the style nitpick, but could you keep the type and prompt as
>> the first attribute in the Kconfig option definition (like the other
>> options do)?
>
> No need to be sorry, I've no idea why I put the "depends" first.  I don't even
> know if that qualifies as a nit :-)
>
> Ackerley, if you can provide your SoB (for Fuad's feedback), I can fixup when
> applying (assuming nothing else necessitates v9).

Thanks, didn't notice this when consolidating this revision.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>

