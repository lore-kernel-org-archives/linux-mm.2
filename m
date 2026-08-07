Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510DFC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F916B007B; Fri,  7 Aug 2026 03:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0346B008A; Fri,  7 Aug 2026 03:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFA26B0096; Fri,  7 Aug 2026 03:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1367F6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:15:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83D478035F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:15:58 +0000 (UTC)
X-FDA: 85073613996.12.A19EC2F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id E029320006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:15:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYyA4hTi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786086957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4DWvEGYbao3vqUAJY7j23ePYp52prm/BteFU7Kg8VM=;
	b=Kyx0bzz9wSaVAW570hELFkyVXFdFn4QJf6eqvdu3yGCsaSxCLzuSIkR+U/oj5jIAOOaI4s
	O9rEZLThAe+aRnSDd88CwkSMpqtuMwDAUc0kvbo9nf0scrHXv8eJW/qAdio4vyNCgcHVSP
	Hg8FCEftW4oITU6cf8A1A5pK8rkXJQU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oYyA4hTi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786086957;
	b=JtAkfeOQkqAQIBnFEGyuNBUO5S3FhVIa3ZEvLarS4xbuqBF7m150QvSbZEFBsoLv7KYiQE
	hzH1vFAmXfZXeEtD9f67BUsnkls0LIiI8uLw3y7MggmVg/NObEWD+bpjKMNW9hLK/a59W5
	GeDV1eaJn0/Gn+lpfkb2hTecNCdMWrc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786086954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l4DWvEGYbao3vqUAJY7j23ePYp52prm/BteFU7Kg8VM=;
	b=oYyA4hTiStR5sbH3FPHxiOI76f0UYzrrcwsX51RqGMtYzV/aHmKaypBzke7NaK4fgYs3ae
	cyCIxSiTD+8iylSdqeVzsKiTtrBZVrJ6uJpNQc14z22gO3wJe57xeUDXG3oHK6VKr3TaSq
	/WQpafIFXAchGBmT973PI/8Ry0tvv6k=
From: Hongfu Li <hongfu.li@linux.dev>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2] selftests/mm: Drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Fri,  7 Aug 2026 15:15:33 +0800
Message-ID: <20260807071533.48130-1-hongfu.li@linux.dev>
In-Reply-To: <20260807003126.81629-1-sj@kernel.org>
References: <20260807003126.81629-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E029320006
X-Stat-Signature: h7dzn9qkchxxyn3zy9c16uqqf5q7ssmx
X-Rspam-User: 
X-HE-Tag: 1786086956-196421
X-HE-Meta: U2FsdGVkX1+fDIT8zdt2Xut1s/0EvOpfGFZvtAtYAVZWidqX2qGBgLhz+5Q2eb9tVZ9d/TwQn8RmOJmvgDdGKBHVmvJlbOkassnIuIEvoWQQf/Z2rlqwrIvs9bTX4E3ASQkO7XlHCUV/+2VKQzF+Rz8duEQwX5OpGk5ztW5dlMKh+vyffott8S6/z/T7tIwtTi7CjB1LungpB3T0FkuHCZKPk9LrhwedrziVjWSGIsyzFX0yZqU+TAQlZqxUm3r3udwYH5CYlOOm8PXukGt7N/tnRt6BLu8rkWbw4JEjN+nQ48e1RPrHBHJZSHsLLXf+MWDGhjHCgL1zNSZGoZgGLs8Gfom42q2tf29v1Um4BF18Z6sRGWfUmqVFrl3aWIwUxFWlh7Vu/sfzTQ+ckAFUEW5Cz/KL/gtd8z8FIJxIE2YZiK5NiKHz1ybAVy0LNbnc8UosGJsqweruxLcqdzhreCsJB0fN0/3ILqyKHVzSyv16KwtuFzAvA7nCKaH53VFIkIXg2slIMrabB1npMpvvwU82OHe6X+UsEYZA/US+OO+4jaxYFQMc6LxR/UUiA+aMZC77surFaGTo4srVMcbMdwehdpnH7kP0MIUSrUwuYSMyEmtmTDyQNE8fgIJoG97dOEVupQ5YZVAhDlB9aZNKEAd/ebDGVBGKfeStt6yv0ZT1UUMVOm3/W/dy7d48RuzBawUyqjnw7lOCTeqaNQ+Ub/oq/Kolp33aLxrfaLxknOcDe4sbIGcJZiN2vUep3GycZ+v47tBuOVlDnqiYAcAdQMy62IRdfwAwLGSIZOfh5+NzldV98i9Q0wArAa6ekeSRuYlWqI59DCaPIyfpzjXJIkyj6CaGn8g9dOtA6F1OOEKPfCYGZH6rTXpBmbKMHcKBoz16jrzH7ZPSG5WG7IXSnUDpH3qtINYyLFcEC8iRrFja8i3+gsY/cSwoXFfbptxLu3Ufw0hbw0W2wXhZ6iG
 NDAHoFeL
 8DH5lanXng16LVeCCW5hXimqQEr/wnuuWq4aPLArXrUuOYMBED1dTPkJdA47t1Tbq2H3doOdNo+nhN3s9GY4KEgVuCKXfPOS+H6Mq/UEQ3LC+TqGSc0N9dxMkt0/kHquZbD6DZGYziwmPu+Oc2/omqUr+hkTViDnX3qr0vIFkHFf0jzzywna06vonaXNPndegTVr+JRqlGweRQpLK1DFBtbl1zzMlnnCc7p9QcKBhNMQ20z572VKaI8PLQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > ---
> > v2:
> > - update ksft_set_plan(88) to 87 to match the actual number of tests
> >   after removing the duplicate call.
> 
> I wonder if there could be an automated way for this.  Obviously not a question
> to the author but just my loud thought.

Glad you brought this up, I totally agree with your thought.

Something like the below refactor could achieve that automation:

+typedef void (*test_fn)(void);
+typedef void (*test_fn_seal)(bool seal);
+
+static const struct {
+    test_fn_seal fn;
+    bool seal;
+} tests_seal[] = {
+    { test_seal_mprotect, false },
+    { test_seal_mprotect, true },
...
+};
+
+static const test_fn tests[] = {
+    test_seal_addseal,
+    test_seal_unmapped_start,
...
+};
+
+
 int main(void)
 {
...
-       ksft_set_plan(87);
+       ksft_set_plan(ARRAY_SIZE(tests) + ARRAY_SIZE(tests_seal));
+       for (size_t i = 0; i < ARRAY_SIZE(tests); i++)
+               tests[i]();
+       for (size_t i = 0; i < ARRAY_SIZE(tests_seal); i++)
+        tests_seal[i].fn(tests_seal[i].seal);

Though I'm still unsure whether this extra complexity is really worthwhile.

