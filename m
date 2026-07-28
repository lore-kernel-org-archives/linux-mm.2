Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772F7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBFD6B007B; Tue, 28 Jul 2026 15:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3BB6B0098; Tue, 28 Jul 2026 15:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1DC6B0099; Tue, 28 Jul 2026 15:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEED16B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:20:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 869F91204AD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:20:21 +0000 (UTC)
X-FDA: 85039151442.05.47AAB47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FAAE20004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:20:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CVE5DmOs;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmnt6SkHcrWhFD1fG8EVQQRclAuSqsq9ZXY40QI3bgQ=;
	b=c8xne0EFdGfieRGYWtbDmoQ9rN5a001XrT7i5gYJVmyh8bunXfHAkwPrYLHks65vH0urh9
	bvqPCw0eXeXzeavW7awtjhVINk+0xtGfOWtvPL+P2BgMv3gOUQaJUuGQZLuibr+GPpe44B
	h0ZCnbbwcrRVp7j0s/7RNj6G9d8lDpE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CVE5DmOs;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266419;
	b=Q/rC471Rs2EDJX0VlaUnx/KZ14rEQkqrmLiFAFWf+c4Q+kfllOpx96J+UmEX8BaFUhJFtq
	WkDgLG5QcViJXP+LpYPpVBaSsLW6dZ4HMrFWQ6Fsz5QdIE2E5p8j7KNipFgDccAOxKLw8+
	uJMCCDWmdAP0c/QxUlqaLF9ej21Zqvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A1DF43B90;
	Tue, 28 Jul 2026 19:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F271F000E9;
	Tue, 28 Jul 2026 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785266417;
	bh=jmnt6SkHcrWhFD1fG8EVQQRclAuSqsq9ZXY40QI3bgQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CVE5DmOsX+lilJkFtFeF/hr1FfHaZt6FgvOUsBAvyQ+gcMxNyKH8lhRl5X2C2A3fO
	 cuzJ/roSOKTIg/Dp/yoFAOSCr/Zvqpo8A4YgrAyQXL0zwhRB5frv0f3aQIkU3t6Fzh
	 HBIdZgq8m2caLuMsXDQGoyAq7hDSOhrbuO+SppLQ=
Date: Tue, 28 Jul 2026 12:20:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 lance.yang@linux.dev, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive
 test
Message-Id: <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
In-Reply-To: <amh1nZVVaaZSGD3M@gmail.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
	<20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
	<ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
	<20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
	<de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
	<amh1nZVVaaZSGD3M@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FAAE20004
X-Stat-Signature: pzejnqseyhxu1odwji7f7drde8qbbmsi
X-HE-Tag: 1785266418-461997
X-HE-Meta: U2FsdGVkX1+Lwy/jMabqW5sG4ZH8MRdS/J1t0S54uOkSExI0cHNWE7MeOwRLX96t6PnsjbZKz/+BhngYSFM+f12cITdTlWg23hp0V56BCIIpy0ChdnyogJ7hat8D/kw80Htd9g6vsLTF4MA0qF17x8N3MED7OoRtn0kwicq/ODtIJ7wbP4PKcF2lUmj1zZbXey5+O1kuux6sX+ODdasTXgJRC0M8RKj5ZyUyfpdy56UB4Q55Wwl8UBr0BSFlPcYJjJjGXj64JEJu8j7b667Hm3pmOnE2WnPWQqJ7341cVXip77Hokn10rnF0cWvRo8KjfbIAPtVZ6YGLIyFUGw1l9YXW8H6SD0fPE32RjQp3tBeCl8Ih1eG44ktEz+3ZVg4Wf/AqlE0H+FLRXmxORoCexXGAExP3S8tfWw/HeFVLLus2TNr/DYrcWfX0cRDdiaDfgGX7kl61j4stwxO/HWoGc25rAjr5yN64a1rG0nOzrnq/2ofRgK2QFD4ZZjho62IpRRwQLEBEYXtiTXx0Kj47pyjD6/+G4pvYadaunB6djhnQMQA247AhUMlEuijhesbI7Rf5xRRO59j1spFGJzlm/6AgegkGopVcFjTGSpJwfsKG+uVUDBu6Mb9BXN8Jmlckw7uiwllXN4PeQGLj+Wc6JAp5O9JZ8spiHiXoeT4NvL0yh3479h3/VQI2owBPrTyTsRDtNOlCo742w2c4f0iaieWlQfNjfUfAa8hfTPzjwLXkXFmnE99zBO6Sq2hBrDMUsiUeRqKOEFkx3DFy3gVFO/PAEeldBpMNLNf35cmxIosVaTHSqcYKfZ41SNsyhYqpr68FaemZD9YFEuXjK2IHOjsK//Kc0LDG8C6rHfY9SUlqU2H48zubzOaNSAJyx4S+vZ0o4RHSF0Kv8YelG8DLnWgO2+HwZM98mP2wFBDszSslSANRYe/AtHG/BbQ5RbAqIQfa02cz9/ly+xMFnGD
 IeaLrHXn
 wnaZ+RyOQLUxZB3ufcd2/ZJ5XaxprMaC81togZ0z5OHgfQpy0N79n+YeJJq0QUzgdxumic8CVhMfSRNbOOb4tkDLEwSNp0fpjvQII+S49c6Uw1psPWInyjEmPyhc5UGI/AhqDq3n7f3Ll93T+nX688+g/15WpHnPXzs9gOfYrUBxCmkUnT9/4UCGkqVv0pvzczf4qTQm2T25bPDnCD4VaPQXW43wJdd/O174+Z+KLKawqW5TX7Jut7Eo1KY6+H8ruX8L+w4IJwcKuaN9a2WccqnCVs/CyQyp1rvA4Mj7pfK+gdFye8EBEK1VAbleN5uwB8ddGgWVD5et1z5NVhS7cmXy+cL2jyUYSnVwETOjamzuxl7gjWoM2nEKHOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 02:29:39 -0700 Breno Leitao <leitao@debian.org> wrote:

> On Tue, Jul 28, 2026 at 04:57:13PM +0800, Miaohe Lin wrote:
> > On 2026/7/28 12:24, Andrew Morton wrote:
> > > On Thu, 9 Jul 2026 11:34:05 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> > > 
> > >>> The script is intentionally NOT wired into run_vmtests.sh: every
> > >>> successful run panics the kernel, which is incompatible with the
> > >>> sequential "run each category in the same VM" model that
> > >>> run_vmtests.sh assumes.  It is also not registered as a TEST_PROGS /
> > >>> ksft_* wrapper so a default kselftest run does not opt itself into
> > >>> a panic.  The script is meant to be executed manually inside a
> > >>> disposable VM (e.g. virtme-ng), one variant per VM boot, and
> > >>> requires RUN_DESTRUCTIVE=1 in the environment as a safety net.
> > >>>
> > >>> Signed-off-by: Breno Leitao <leitao@debian.org>
> > >>
> > >> With Mike's comment addressed:
> > >>
> > >> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> > > 
> > > As I understand it, Breno would prefer not to rewrite the selftest in C
> > > at this time.  IOW, we stick with the bash version for now and add
> > > "convert this to C" to the todo list, OK?
> > 
> > Sure. Should I make this change or should we wait until Breno has time to do it?
> 
> Apologies for the delay. This is on my TODO list, and I'll prioritize it.
> 
> Just to confirm: the feature is already in mm-next without the selftest, so I
> only need to submit the C version of the test, correct?

The bash script is still there, no known issues.

We have the thing and tests are useful.  I'd say retain it until the
rewrite-in-C happens?

