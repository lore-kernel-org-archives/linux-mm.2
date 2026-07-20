Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CC4C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAD46B00A2; Mon, 20 Jul 2026 11:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45AD06B00A4; Mon, 20 Jul 2026 11:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3719A6B00A5; Mon, 20 Jul 2026 11:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F18776B00A2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:26:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B9F31401CD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:26:42 +0000 (UTC)
X-FDA: 85009532244.16.6A79A86
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 87530180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:26:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ok8OBzi/";
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppRDMOFJLBPX6KQmdpRBZE7SlCyjKiRE9PJURFV6vac=;
	b=U26LTY95l+zyALkSgqUxKa+f9x2cVVZ0NqSKA5CxxWpZHUfcbrvS15NXHIYPA9LoGpmNAX
	RoAs24gRUmnAOVwY3PAIQ3a8xpfVgP/SsojB65/u4EfQxYqurpPzasipbWS3/uMi6kkev9
	IXyT0TeuP7HGNLuHGI36Jb5G7sLjjfw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ok8OBzi/";
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784561200;
	b=JIo1S4TUOaE3K9uwCGuQyMSttukhpM8bzhq7/0prblDEiePMmQQjp86WGpumLYfqi+BlEa
	SAR19+sk80eXLf0UKTEWpY0KCkKxzeB8da+vRkNwV2g2nfXaq7hH3hFpRJasqY6/h5Kx2o
	P3JlGbNArHkvAEiRSwH9h++9koS5i+U=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-381216921aaso9938353a91.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:26:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784561199; cv=none;
        d=google.com; s=arc-20260327;
        b=HNEAUXMxBF5wtbvKwbTTCQsrOQuclXAtJYe2HBTUoR5vwhaoxYcWBf9XXPGYVy4w7V
         TKOJmJv5Namd1xeG7HL4y4ZDpya/aqFZ+dL9NfKLF3qdOWkjtz5d8xlD3qbX1LoN4bfR
         GCVkwHPEmJHYHaokWB1zkxNEBew2fDuiFX+u21ev5ejC/FGhpWoNblvj2AWxZ8CAbZwK
         FAI0/t7jkEwaVRy/TzAHLTZpea5EEDTI+sFig7TGrUxDQbqI8G5KH2sl/4MSTeoposC0
         ioejATJY7Q0usvtHKGYoqvFX1E++J05KTeF4r5AX4/samm8sAu5uzbHTSulOP4EZCvMg
         nhDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ppRDMOFJLBPX6KQmdpRBZE7SlCyjKiRE9PJURFV6vac=;
        fh=tv1uX9FK3Ujl0JHd81Ah5C7goHqL/YhNMUD45xuxdpg=;
        b=Tfb3+kn1v1ZMJFqHj72RuE8PopRRayGd9zOh8+VLDrXyWz5Xnw73AKs/IqS51xoDQy
         RVnvDz91TqziQLW8lEJraPe+qLfb/SxhfHdaTHToBwjgNx1f8KvgVr64qQ3bxs7UddIK
         qTl92ly1/r2SHIHG3Y0FzyvkjgSn5dHJz5RjTHlCB4hke+sGUd0B2QjNrSc3nQRb4eNn
         mlE1TfZm34wxEpSIPiuGnpl/yY3VZV4Cpr2EMPqHKsZmqvuRv6++gv7ojtT901IJfcSI
         j/atfyFdnra47GzmJ6eUgmCuxbDOSjwO6g3yhvqdlxuWuBZDO5HU+UgIYrA7ZQPUb0xa
         bl1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784561199; x=1785165999; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ppRDMOFJLBPX6KQmdpRBZE7SlCyjKiRE9PJURFV6vac=;
        b=ok8OBzi/ZU7J8YD7DWK1g00FCovq9Cy7+cU981UBHs8zGZ+COZj64+albVa7LnD87a
         JKkbneJs3IeGfX0EcPPRsGaKi2MC1tMkrH8j43QdL7zXioKNXDRNnUEi3zkawyYkNGsk
         XcXnEkpYcKk7gSHJ3NgbfEHSfopJX8xi/w2Gvto9V4mrD3Tvg7uIL3iZ9hh56xwtiQBo
         klBDiQDA2bXe9hB4INRw532QXlrS4BBvzINNzgXEGOJdORpN36vXdyI4aExcFwZ1n+pw
         znhtbAXpNil3fe5gsgXGAs06cmruuOgnkNTFPi+BT8GXhBztAe95oXzddUraQx94d5zm
         oLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784561199; x=1785165999;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ppRDMOFJLBPX6KQmdpRBZE7SlCyjKiRE9PJURFV6vac=;
        b=etoxq+ynaXEmLE+a/kapTAChDnq61OLtO1zcY48+VMPay4OZ1dxTSvKF4EdrjTHDiq
         TIyNJPryFulInpV2B7880rs9+nnREckvNIOBwvuxQJYzPMcwzGoT+mJeDvwOIsykFnUS
         l8tg+AvGke2LFL3yCVAKg3nNqJsrKlK01E/9KoFW/asfXnJxmZ8CC0622P47TxWHj8An
         GAhhVMN+RHVCM3IEjvhAo3UklgXMMn3RFUsWm35iTGruZfapKT4MQ6fl/I+D1ztvDQaB
         uosrWCkeh9ajOVChuhg3T7RsUrqCm9ar6lGdwi9273ZpcK7UOQtjOttIuJJNVMBN7t1d
         sLkA==
X-Forwarded-Encrypted: i=1; AHgh+RqfkixHrqQSbTKUP5mIVILHeZLUNSVHjuxAggiUR9O9usBCsWE2OuCaM8JNv/Jy4bLnQ70i2ehQQA==@kvack.org
X-Gm-Message-State: AOJu0YyIudjMp+rI2T2hyUVxcdpE/0+UTPybAWTWy3mB/+7rKlD9RXvK
	EWUss/8dzLcnGDDfID8a8lNR6Jsl08pAxCB6cykeb3WvzfkBN6UolxsTmUVZ7joDVlORBsvgnBw
	jmJionhXgamfzjIwDYKn+WNTWBKp1gM9y/HpgnoGa
X-Gm-Gg: AR+sD134hoNM1gDFBI/2FiLv7Gl+F/xGmLxK3uEGhbNQcKhzDW4zP5cg1x2qsi3MNCx
	L/3T2AGFKfLW+8W3nofgtnyF7aXlwRScRoEiypSfBDHQH8fsVHo0n341IFlA2QE5I+losMCFDRx
	SR5/xTtPBvIceycTq5k3kGU9XZjNFgWsIYOwjJCfcbwHcRRrIDj9hA4mESx0kaOrpimlU/bT9Yj
	tqhwbGHPrLfscFvyzHlaLc+OQfdcydejFI54VL0mxHaj5MrbiGJaB+lat78E0FjppyaKKOGxQUT
	f0dw1ICnt0DxpwhRJZl0hOBnqA==
X-Received: by 2002:a17:90b:580c:b0:38e:2524:724f with SMTP id
 98e67ed59e1d1-38e4b410109mr15364918a91.12.1784561197991; Mon, 20 Jul 2026
 08:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
In-Reply-To: <20260717125023.1895892-1-wangjinchao600@gmail.com>
From: Marco Elver <elver@google.com>
Date: Mon, 20 Jul 2026 17:26:00 +0200
X-Gm-Features: AUfX_mytGrClEjUL35sTA01mL-vDpdcepD52IC2sE_eAPBJUPR35g0y1m7pBRLg
Message-ID: <CANpmjNMpKXxk2KsZORakwwdOpDG=pRbtJKi7doBt7QmQwUKdgw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Randy Dunlap <rdunlap@infradead.org>, 
	Alexander Potapenko <glider@google.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 87530180003
X-Rspam-User: 
X-Stat-Signature: t9rbt3yxx13ce793y71z7zqkjkfwg8ye
X-Rspamd-Server: rspam04
X-HE-Tag: 1784561200-568528
X-HE-Meta: U2FsdGVkX187LtrUEOPfNKB42FBIhCpuB6/VbvfFmeRiq8uL0U5mULzSBV8NtQA43mzHRfsg6sOdlFBhd1N7pd9z0l4cxugQDia5N+ZdgXWDeruNmEmMSPwBrVxtNjGNIkYH758Zx1w6if0Ww2JyoCNI+pSGpxawf+g8Df39DLQSz8zPeW097UPdDrpxirGnCuc+Z2N3Cq8I7ZUMq703Risns2z9rNXNMsQJZ7rEtmaxKeDwLNnRYOewQXiOvdrsfcF9VkPyKGeaIF3bQVYAES4eU1sXVwzAD8nYGoXSEatxj1saOcSF9xH9CDSj5UPJfbtRX5f0tTOQMG4zkg6eoxVEy5dzpE0yw5cnH4EmoV1cFhEjAN+Jqsc1Pf+tO3mZUNI8E0Puo+Jztc2QrfLP7c1Ukgg8+pUxfWmexEmnDlnsXfd6YAK5owajMQ3ndubFeohEjdJJlBqs2lHcGKVy4I71kmpjYBlSsGY/jG1uJqDhp0giZsHIrgXoffsUGNdqHEM/bPd88duz4dCZjG1PyU4GkqCMbCgXMROJHxEh2aqPooKt4LY8KcRCXISbo812iJHY3H0MJZjxhy6JynpCycdZ7TvHafpGaenXWNu+xlWpZdn851WCFsDMq6VYePs9OiOVN9ks/cxNNqGHU55/i7R9kIs9nYwjNlDDYJy2Rw40wCoOSAshKvJc/N7dF+jGJMfhcBpIzGCl4baJzJKS6GF/DZoaElEZpSbtDn/bfNv/pQBiHKL1RBpSLrbAlXknx0tpKn0SOG+Ns1EJhKeevr2C4QiygMMdgf4PhcXH5VggLM8ilzm3yq2KRjG+vZRVibQfgBe/kgYUygeTscwElw36vBgFcf0M0UbYtNYRiUBBoDXksjfyGOkCkEWOmwuIRZ4sv/R8+MqRlIGuS2bhApYki4JvJKsAKMfWgLO5x1QtC3Q97ObMbulFoXtnij/jz6sf1A4B0Z8pvZ20zYn
 1ZNpq9Tl
 HIvyV79nPZC6W6Ryb1lLTjU9yK0bXi7Uz/jJdKVILPF4WnoXK6JniIvWdXTcv3ybu5EZBwTjc7M8SfFm6I2X4GPl8i7j/x/9Lct7G14hBTnQP73vNG3XyVlIM+rp3m0ymSqI+vl/ol0swrrxhwa9LYOTeqI/Y5IPUosy329hndneSnNqEzXI27jIWK9Em/GuBi9Cuo39/j5CNvRsBjDDdgscxBPyiRn717Sx3FzELaVHgoVDzlFeMK0wmGE/bl2dBQPYWvrxmmrfZ25MITMzbELPOCJiVc41sM68wyMVr9MeaXLrdsjSv6tveiOVqKJHkvEi1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 at 14:50, Jinchao Wang <wangjinchao600@gmail.com> wrote:
>
> Motivation
> ==========
>
> The hardest memory corruption bugs are the silent ones: a rogue writer
> scribbles over a live object through a stale pointer or a race, and

The stale/dangling pointer (use-after-free) case is the main one you're after?

> the victim crashes in a code path far away from the culprit. Any
> single developer hits such a bug rarely, but across the kernel's code
> base and install base they keep arriving, and each one is
> disproportionately expensive to localize. The question to answer is
> "who wrote to this object, and from where?", and it is hard to get at
> with the existing tools:
>
>  - The kernel's own reports - an oops on a clobbered pointer, a
>    BUG_ON, a list-corruption warning - fire at the victim's access,
>    not at the corrupting write.
>  - KASAN/KFENCE catch memory-safety violations: out-of-bounds
>    accesses and use-after-free. But they have a blind spot: a
>    corrupting write can be fully memory-safe - a *valid* pointer, in

Language-semantically speaking, a use-after-free write to recycled
memory (be it in heap or stack) is NOT memory-safe. The detectors may
not always catch these (KASAN relies on quarantine for that to
increase the chances, but yeah, not guaranteed..).

>    bounds, to a live object, written just at the wrong time or to the
>    wrong place - and then they stay silent by design. And even for
>    the bugs they can catch, KASAN's rebuild, overhead and redzones
>    change timing and layout enough that racy corruption often no
>    longer reproduces.

There's also tag-based KASAN (KASAN_SW_TAGS or KASAN_HW_TAGS), of
which KASAN_SW_TAGS has an x86 version based on LAM (not yet merged
though? see https://lwn.net/ml/all/cover.1773164688.git.m.wieczorretman@pm.me/).

One property of tag-based schemes (and any other lock+key detection
scheme) is that upon recycling some memory, the tag (or key) to that
location changes, and any previous pointer that still has the old tag
will fault. The caveat with current pointer-tagging schemes is that
entropy is relatively low (4 bit tags).

