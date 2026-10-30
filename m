Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14270606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bXwIYEvJ
Received: by kanga.kvack.org (Postfix)
	id 407106B05B6; Fri, 30 Oct 2026 09:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF426B05B7; Fri, 30 Oct 2026 09:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F50D6B05B8; Fri, 30 Oct 2026 09:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 084ED6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D12A11C3BF0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:36 +0000 (UTC)
X-FDA: 85379321832.23.44581D5
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 06B5F18000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bXwIYEvJ;
	spf=pass (imf16.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZOCDzk4C5KN1JtOyDvdr0FxSEI/UMG9a/p3BL1dBmI=;
	b=rU7wpOmQuBGD9XCYWNAKRXltwlfVfDIuJitEuz62atgidQzlZlmKgMukvmJaknyONIWZ+2
	fZU0kcpP/ByvMst5Vg3/u5n+tJnv+BpzMGprf4Cpq2vzLS3yRZw1wRiWul2SU1cDMCyepH
	zOqhJp8Wws11wvZAlzSpG1i1ZsQ5/SI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365715;
	b=nqeg6KOEvvqWPJjneNhhM5zD+34eyzVgsoKKzyDZTocH1T66hZGkW3i7/eqyvC30p1yTx2
	s0Ia2sne5o09sBXWwZz66XeZwEmTXfQB2S84Ci5RkY5n42A4GwFm7pRaNoaMa9m1c4VFbp
	FY7IH99AJz8PqVSXkj+HTyhFDL3kiJU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bXwIYEvJ;
	spf=pass (imf16.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c4d870d54so417581f8f.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793365714; x=1793970514; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nZOCDzk4C5KN1JtOyDvdr0FxSEI/UMG9a/p3BL1dBmI=;
        b=bXwIYEvJgzwdRNU5rJ4Dz8RpKBvjN7I3dKkzip18fl4fovhjbp4zts4ZG/YdOuX8cC
         xu50KoGjouoLLPwxaaKsDYhy9n8yxllFdmxyNPImikN+/1ozOp0h/luS3GNGNbg4/D8r
         GZfBAQhYSjvvq0T0zfxP8UnTmcWKuybd2DsvP12JEM4Tdk5mLRra4duyHlm9IvrtUhz6
         07jPfaw+CHUn0OylHJ7VIQttz8T3kB+QPN9DiQ9NQhEV0qF7uJl1VGZh6rvcfA9xYpMT
         cMIqxdSLTYwHopXS0cV/k1iBWjrijDHtQG7ChX+PzOxU2UOZlfaPgObF0AMCMMXdS0DA
         GU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365714; x=1793970514;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZOCDzk4C5KN1JtOyDvdr0FxSEI/UMG9a/p3BL1dBmI=;
        b=y4XtZo4vLiap2mEFnsvrgze4wLzTRlyo3jzvImobQzR/2C55xtSP4W/HGIYPeQrPsZ
         DP19sTzJQqZQbD6QqUUAH2Xyzhy0JNGvXj1OedpRSoZ3BtJ26gyFa5PEy6ehOthCFY28
         kAKnG41Z/l0/Ih9rwRB4wned9tVCIfo0ZDumSYvowLviIKr4oxW8kkKkNWfBU2A7BdNd
         V37LBEUZDrg3en583HQf8Cg/BCWqf54MKOGyHqja+6TriFoy3uEca6e4WClHiFHGgDsc
         3DwXf7TiO9ga/wZnl9sx6gz1xxHRWyQS1qjmPC9eZL1or8rsjcB8lizu1afIDbTR3HsI
         Yo9g==
X-Forwarded-Encrypted: i=1; AKwUvBwqMpTzR1UcXym1lAGVSMJ5hDCJadme/EA88yvsRMC2QR6YX4CE9pwXG/5JbGJBvxEDNx2FDcol+Q==@kvack.org
X-Gm-Message-State: AFq9FYJ5XwEtEiTiQWKU8H3KKVZswsRhtwIp5tL+hsAHa/niV5IRKBY5
	CY42sFOknOLc7aMYbXcWpRJ6wtiFzY3WRIL1m2n3DM0v4wY5fq3891fm
X-Gm-Gg: AYBFou2W6dRpNFUjsArG+q3JZYzQ+00lYOdI125xHyi8gS3/pZweOrwK0xIguO+VH+H
	tPEP4mSwt+RwcDPg+q3uzUDaGS+epGjCUDBmoVIJWFDq+iWS5+oG8xWPYyuAcpM2lPs/iIiaG86
	sPVsg6DUkd8kNBVCgBXteArXPtYpqor9bHXBLWqaFafpqxRIA8B1mf+QYKfN4bU1x78WV62qqql
	eQATqQyQm8YOAteYCPmjsB4rHXHaVLeLipQvhIpXsIUT0vxHKtMWAuE/1mih+xrvY1fbpkqSjIR
	tdG/mSrLwgCP7eDsARXQS2f76WfVqHPLc8KAx+9pVNl2AorigTOSMQ3IeXnBSSiiWSw1o2w7VOo
	AIUoFyxrvAviyCvN912mQ1MO61cntS5uLJpED+m/ys71rfFhTeoaI0Plnph+sf+2GMf9UiCqhyj
	3Kkx+1ppcBLfsnG67ab0xGokugh40Q+6fDgYeuNrgo45eUSlXIJkJ3J2XxrHBTggLUjpb8ySoe4
	SlWusDVLWwROCpjFhJrk3DYoCw3RSWRcZFGWDaQtPgzgOMm2dG29yZ4p4xurOfUFbmjqGhcKt9P
	Kw==
X-Received: by 2002:a05:6000:2204:b0:48d:ffe8:ace6 with SMTP id ffacd0b85a97d-48e6e3004fcmr5231472f8f.42.1793365713640;
        Fri, 30 Oct 2026 06:08:33 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71baa1b3sm3053979f8f.56.2026.10.30.06.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:08:33 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 14:08:30 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: Test user memory kfunc errors
Message-ID: <auSWzm7W1SiQN0Ul@krava>
References: <20261029212551.56964-9-jolsa@kernel.org>
 <d023b011d67ae13695a93c94ae0197e96fb5d42bbc3a4a63b42fcd0c1852a605@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d023b011d67ae13695a93c94ae0197e96fb5d42bbc3a4a63b42fcd0c1852a605@mail.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06B5F18000E
X-Stat-Signature: 14fm96ngkh87rqmp5biwjb7eu5dt8jes
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793365714-154467
X-HE-Meta: U2FsdGVkX183exL48qrwnSBKQclJOcZNeiiFdOiFLM0b2tWPXBG67uvEFM54JWSjCH1f1K8J9sjXAFdIMR3eJcjooo7+fesPx7KvA7ArGUUZbOnDfmo5qqb1SSfpGKb+jVCjh0YjbgL7zxpy2iz5wZz2vWcffhy6Z0H3jo9sRbT73IN032NvoJBOkM4loRyUn20GGCX2saRml2iDG0SfNWuCRlNKWx/yaznOG0y3fPdmf06pHlK0vSwc1hG2DbTsWHEsY7vBjFdda6jEPO/6s4N43oVVpq+vDG4QJGLwedh/LNcOGFV2DIiz/bOvaQhJV+PgIAEUp/Gp6wb7rU20L/VDyi8H1dYL9pFAS0lfVcsvYGQnM7qChhntTYrx8tk+XWnXPWDhYEvVjfV4/6MQjbFp73L4kps5u1QWPHhCJBU2LYw98HpiZAXt6ziJ3XfvQRUGWi8msVCwn/SpXcjhj4Uit7qgqGVGmiUhj5zIvFKvmtGv6CSSs+VsZCm4Xxj5RVBLK/HHqHi799zc9Qnq25f1NXzlflD50znBxy9nD/pE2oBrV8Cwt6CKS+SIgNz1/yigbA19PSnUmKKuY9p1FwVmov9X1XRFz3NKMlkVP226JX2o1WsnT116mMYry8wic/RfL0v662UASD00EkMGxB6QBJsZD3YG+ldPpl/yNgjYQgGxlaeqIEBkdOb2McNBVQ/syUM8l4HJY00ASq/dI02m6TO9RGCSCXAOag1cYu3BGBTrIcLEp8Tb/MmoH7oBxyRMZzB3UeKtyCreU1iwjoPgarGRpp1OCI5mO2uc8WQwaT+7TFAr1g12XUXbKzpoGRTj+lmZ19Lm5Yq/i4yHMtCkAoMqK0EGPNDjIobPE3louzaDKrSvda+eXXmW5RHhD8/i4DTaQxEvL0UE4xaCfNAXEqkAHc/oxqDoC3pbB6mEXqH/kYQGPOAd4MnbnCLMdfaZV9coFmMLzVgVTP8
 Bmo6jCsy
 4O/VKHlNyy43IDQJfwgGpC/ic+yqGPTELk4puCc30cUan6UXKycDi9W0iBUS4HiHYjRWvCGHBpmbBGp9XNMOcMXhg7e7M9psvbUeeqypPUoJ8lLH/OcUW3NGdE/Y7WsT0nfCQpheEUI4/lArd+eMRgs/lWEL+flowVw4WBqFoBUszC4Us1ZlCS4S64cj3sEy+FcQDuC3s9dZrVHxN9VdCqS+bcVjCYXbwu+N7kMVedqAS+l3HjBEKJB+rYMH30GZ/9HrrwT2QHB+1MH3J3m+MpPyEvVtrvWGyEUQKJVGaT282EP97MGywzw9UHy8XawKsiO2sTMY5sw8fsoqKZEL4QDvlnaWcbl+NJA1+ziFAssvrZxghMlKLOZrqMzbBa8fwpQBk4qVUewhRLQo/cQbg0ahgise7FxqFmGujkmjW+Wxge2+yQXDwBYz2e3ozvE+yAikP0GG0HilKu8YtgjMxRXPTxuD6Ga3Vob4hsZaVmRsloKuRz1uuCaAQmMjmvDPpmkZv7ul6WxjEHec8i65DO0N99bPb9MjCxYgAaKoG55qY7DelmZ46AF/sv3iTAUP7faGRGvklV8FmzSQnfZyFYSEGWLh2stVICv/gJpRq8lmTsAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 09:59:33PM +0000, bot+bpf-ci@kernel.org wrote:
> > selftests/bpf: Test user memory kfunc errors
> 
> TL;DR: Commit message only: it claims tests for partial copy faults and
> read-only mappings that were added by the previous patch, and omits the new
> RUN_TESTS(user_mem) verifier-failure tests.
> 
> > selftests/bpf: Test user memory kfunc errors
> >
> > Test invalid copy arguments, zero-length mapping operations, partial copy
> > faults, and copying to read-only mappings. Verify that a failed unmap
> > leaves the mapping intact, and that non-sleepable programs and programs
> > without CAP_SYS_ADMIN cannot call bpf_user_mmap.
> >
> > Assisted-by: Codex:GPT-6
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> The changelog says this commit tests "partial copy faults, and copying to
> read-only mappings".  Is that accurate for this patch?
> 
> test_partial_copy_fault() and test_copy_to_readonly_mapping() were added by
> the previous commit 8f0bac0f80cd ("selftests/bpf: Test bpf_copy_to_user
> kfunc"), whose changelog already describes them, and this diff does not touch
> them.
> 
> What this diff adds is test_zero_length_mapping(), test_failed_unmap(),
> test_invalid_copy(), the three verifier-failure programs
> (user_mem_nonsleepable, user_mem_kprobe and user_mem_no_sysadmin), and the
> RUN_TESTS(user_mem) call that runs them.
> 
> The changelog also does not mention RUN_TESTS(user_mem), which turns the
> existing user_mem_test program into a privileged load-only subtest.
> 
> Could the changelog be reworded to describe what this patch adds?

yep, will fix

jirka

