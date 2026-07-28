Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA4EC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A126B0088; Tue, 28 Jul 2026 00:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B436B008A; Tue, 28 Jul 2026 00:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040AF6B0095; Tue, 28 Jul 2026 00:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2D726B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:24:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63664A0C47
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:24:06 +0000 (UTC)
X-FDA: 85036892892.12.8517A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A237B120008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:24:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zk6eLt81;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785212644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQyIhBnDSp1LeV5j63D6Dt0ddnF6P/tt+RnNOupEkLI=;
	b=dbxgfO1Q5YRhrLbLTfibZAPeEBFNm01dAzlQsOjT18gRzHiKFIn34UFHSkjT7xgCZapekA
	LuMaRgcEiNukR3M9WU3Fr8M0X9RkXusc2j0E1QpQ9+2M9/hLgorCJQYHAzBeiHtY/+r0+G
	5HsPOWfeqMOM3lUJ1DvXdSdzCW4b/+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785212644;
	b=ip9qtrMhvQV1z2dw4TeBA4v4b4ZCZLWpWOdHS/hGRozHV844sf2idFJ2LfxkzbuzDw0zEN
	JrRWT60Acih4CPy3GP4EnSJCdjbDhjpDHUr6UnCa++a0t888GstIPMIpOe55COEO06m6le
	X13oAsYSuMAAmSaoBWge/n/J/ZWrSfc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zk6eLt81;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96BAF41906;
	Tue, 28 Jul 2026 04:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD47B1F000E9;
	Tue, 28 Jul 2026 04:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785212643;
	bh=PQyIhBnDSp1LeV5j63D6Dt0ddnF6P/tt+RnNOupEkLI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zk6eLt81z8NT0gqcdR0ASwDusUAygxVuTdX3+9SkcYZjzBv6w/o0AK0w754iNu4Sc
	 HybK6J4Th2iMENNUY3oEniHIGPeaxNSWE3hFyyIyRFaXokBHx0td3W28F7xOm6Svwm
	 5bdIAtZ0o95LWV/SBC5RR8k0twaZwbGmQNQNgSHk=
Date: Mon, 27 Jul 2026 21:24:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Breno Leitao <leitao@debian.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, David Hildenbrand <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett"
 <liam@infradead.org>, <lance.yang@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive
 test
Message-Id: <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
In-Reply-To: <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
	<20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
	<ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A237B120008
X-Stat-Signature: 5kbt5ro4qca11gd35zzn7mbmaf8nwyp8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785212644-553297
X-HE-Meta: U2FsdGVkX18v2k9R5EJbgF7uqcg5neaDNPWDh6ueQTUMCyMKcdngThEV0Tt26tQEelMSGwlPNkV8xGyFyKdTm9ndHOLkUb6WXwwFGciL0rfvQm7OFmQlyoTQ3tOmprMDCEqx3ZPjB6rYVUJQRTQKUYDNg60KM4uFRI1hr5/m7RS1aveGqst6gMP5r1XdqTtzZiSxs52a68OiryhcO5Uw6McJ5DYjvVSysnVvVZIE/e5NQ7pdbHk8tvl+VRsjPKPEe9boNQFbXHsf+JEEjmp51qKZzCfvSlKy5f6MKzD0B4jPusL8rWsB54u/9uR9FPDqxe8mueaGzQldSPXhnZUfLGoq+3YjiyzKu81+XCS9FJj1gOtIqlxvUyacSMtIjbWbI4/MHZMWz3kcPDU1+GYi5tGcy+hqaXSs9jkKruKmSrcpqlDyT2aGZNvaIapjrOl/86r9BrnGbeAuobfV7aJf1BriNvL0DJoWGlJ/XEfoOp4otvt74XuFJK8TJUb3mwWfAm1gBvYuKdYqTBOB7rnBa0oqko+mICVhZNotJVWl/eL72c3czKOAHLs3kM+zVr7ETtUdynEY6eFI4wtVe9Ub+tOY8GQ7tuGqB+7gGA9gLXJyex6zFxD2FENMV9R5E73MxAMDp3HGUB7K2IQuvpFTnc7TT1gn2/bXa25J72DZ9nkyyJDdFU4/5b7YDF+pMLX2bM+c/i9ZmsWjil2U3zkoTRK30YJiGREF6n094Mi6KYPy99RyHDF/0LKPZmgm8MfqwSGAVMW9OC/H90Bu2oTHJ3o1Kgu07COjShWNJ82yi6Z4x17W4vAhbzIHeNMdyU17mjwSqxc+mK11j8bnMnD3Z2gHZtk+mJHGCMQLIQyCehB/34aT17lY3oFhA8FcqUTZs5mMcIDSeuqt0MRAzJXQbnfTfcH0qlHdMApJDIaKfanyZMmAuOIh1F2vBOFGnCwEpzs4pL3X76GL9Yuvk+8
 azFImQoZ
 axQ5Qo7WmrfEme6PEYAOjo1zTt/I6pXy8adHM9RUu29WnslxVHjmhtXEAyNy7XMDXvpaTVGt8rmwrR4kxSLFdlleta/WgeSK+eH1MkuVZA8lGShuTJKiMqgGq8VvxRH0fBLLacajptnbdaL0GDMRljDRW01zzrGqSnQTD8pTToUBNXb4lSg098I9j8/OL+aT430dGmz82POhqiT5gdAA7+B/xvTUfbgRsjcb685Hmabt2XO8ttVGQC/8V6jfEwLfVB1a4tLE3swMDQ/lupxQREqumgWdqyWg7Z2bLXaz5u6h4ryjAx05x2DNaPO6vjXElem3FjyRmSoMdit7WM6n9Lf7ZO4i47gi6g19nmSxoomzSNstFwBaVkd98yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 11:34:05 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:

> > The script is intentionally NOT wired into run_vmtests.sh: every
> > successful run panics the kernel, which is incompatible with the
> > sequential "run each category in the same VM" model that
> > run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
> > ksft_* wrapper so a default kselftest run does not opt itself into
> > a panic.  The script is meant to be executed manually inside a
> > disposable VM (e.g. virtme-ng), one variant per VM boot, and
> > requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> With Mike's comment addressed:
> 
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>

As I understand it, Breno would prefer not to rewrite the selftest in C
at this time.  IOW, we stick with the bash version for now and add
"convert this to C" to the todo list, OK?


