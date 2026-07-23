Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79CFC44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B80C6B00CB; Wed, 22 Jul 2026 20:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968A16B00CE; Wed, 22 Jul 2026 20:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87ED96B00CF; Wed, 22 Jul 2026 20:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6625F6B00CB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:05:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA0AB1A0354
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:05:22 +0000 (UTC)
X-FDA: 85018096884.07.027841E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3504140002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:05:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QttpmbDm;
	spf=pass (imf12.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784765121;
	b=lPplNF/kT8u81C4KZbm71Wkk1joGP5eSKLUj38FjEbNLfsCGuyMulr3rXEa/YFhRb6q/4F
	Dy5gZv0HIlWRlTUiGsHcKHuh7+o573XMG2ubJxZ8mjWTt58OhvphFdzrCO0MkDN6NLn7MN
	rlZHf+CN/Ka0SaKY7CLj5M2F89vARnw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QttpmbDm;
	spf=pass (imf12.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784765121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cERcVi3l194vR2K7MPvUZ59VryqFLMg43o/10bMmISM=;
	b=aVlos89XFliT3VCgq37kJlA3X1lMeDXMcuGBH/rpMQy6Vjc8l+C2q9NzNOt5pW5jtoSDD5
	mnECPUeoBsWxFemn40UTDE2XtxtU3E/iIwuQdQAnLUu829JZ2GooBy5hmM1lmrfoatJoB8
	MLvcWaDtIslzY2qMkwUVjQhdk9uFl8M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5156D40672;
	Thu, 23 Jul 2026 00:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE6B1F000E9;
	Thu, 23 Jul 2026 00:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784765120;
	bh=cERcVi3l194vR2K7MPvUZ59VryqFLMg43o/10bMmISM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QttpmbDmFm3XT7advN73O+eWorj1Ah46zEsaAUHvor3l+aSKENGVnf8JVCdfRJMoC
	 UtILpVt6UfIYIJXf/mi8iq+Geg1cQwTn7RAO82o10FnFichBdWbjjPcQu/nuEYnDw3
	 J9nPPAZuGX9RDBc4b/IjDypVrNUKXfd/dbOugDl50C/rH+2ey51sYFijTgfyPqp1EF
	 J5i/WT8GDkNXkeZxffEoCJiV19FVq+XBCrTfmMPuRYUSdWm2J4uStkirxgsmga1tmE
	 sY7TbKMmaarKpQLKirwlyrmklQal0pzhh7tj4avo7ifK5m9QezOMgb/JWh+fB+G02a
	 wOisoMdBcnkYQ==
Date: Thu, 23 Jul 2026 09:05:11 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra
 <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox
 <willy@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Randy Dunlap
 <rdunlap@infradead.org>, Alexander Potapenko <glider@google.com>, Marco
 Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints
 for hunting memory corruption
Message-Id: <20260723090511.bd1547ef01b8702a0449c887@kernel.org>
In-Reply-To: <0565e7d4-fb0f-4b84-a20c-0c73ac964b51@gmail.com>
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
	<91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
	<20260717181004.GBalpv_MOaAflgFxgh@fat_crate.local>
	<20260720232442.3e6b0e70c6939541b8362e05@kernel.org>
	<0565e7d4-fb0f-4b84-a20c-0c73ac964b51@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8chymirb59wotu83r7go7eqisenc4e9e
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3504140002
X-Rspam-User: 
X-HE-Tag: 1784765121-618156
X-HE-Meta: U2FsdGVkX1/BrQ+wUoCR3LXLQmWaJVO/MGEqqfgeGaQ5SInWs2COhN6D/46n0dk/zy3+B1ZlD2+BRqZRiUyfUG0CmT3rxKK3lQGcPHCnqcvIp/L7IGmai2lnN7qa3mZ2kYc+OtgxJAX7kVJwVyCWjO6fQlTU8xeJWdD+ADXD2dKDf5qjnhgI2YDDZ9BnzkJK9AOp0lYAwPR8qKyJobB2kH+OgpgBhkJleWsPPMTiwlgXatnSB1sCCghzQ988TbhFD4wtlP3OIMA+nHveDL3w35DXR/PoQda9Pcw/GVkwpVHMBicc2DWLjabMEbuGROiaYkK5+mo0XlqJ9lph5gIHVVT+gtk5gwfIK2idJolrezpOF/MZdm0vmT4V1M44xzccczxKjrvXTHcdmV/LWwEsA7UNK1UoJ6cPGcLAEz5oRhRZZzesg7+3ttis/+Ch/VL16GJk4+/1DhawxVMWDldsNVZKUTi2zpbBLlg+v+lzaRTiSeHH8aiZa0SKn6/I65bxGxFXzPu/GlN5acIo9i4LTnRjcr84AHfiqNgsF7B6jT/GYVGZOw0yvPE09KXFT2m4YrQRW9bRIJwJDAdtba5sAJzgph46BiHf3tSPffFSB0qjFm8R/it69fdvhAIdx8g6eOaliPM2tmyT4zBwfOM+E4+orM03kHySNSx2eNPCsy/c6H1WxCTZh4i5mbtm6f9v3KvVobJyYAHHnjPZPqqXBk02R8umJZR4NkdMg6AShPp8FOfknnm0XjDxiVFvHwO1PxRQQXKwA1AVHBnOv4dVXiUtWzfSgGAMUF54XPhY1qxRYlF+fGkuMvorunkzxLsN3tUaFvPT1DzgLLoR5/Qiquk5dNXNeBYRLbE0L5Bp5JFv8kSC/YQCLrsqZnVtzChpgd3T4Tn41Y9h73YFEfJSEPrEmZpP1IfmTF4Q+eDJVjzdRM5mu7BN36SwHhmS3cet1WYCsu+29sDRuSMQeXq
 6tafa0Lg
 1MQnRadIp0AskNa/9gOWUXc5E7rt+Jf2wInGtGBL8yk47woat9iAgSKtYI9UaZWGdRfG/T9572l1xgUF4JxTTLHnznVUBVmDpVRegcOEDaNARAo4jVujYuAaN4Oy67dKWXiB6yVnd9npSfAPgcA+BB+5Z9+6ud67hML0PnIdjgFqEIfEGIoZca2WLmVZlSlvGAYVzrt4w0AJqXaLoD4wHSORyLrlAteGFYxBtWSe5AyBFrZ9tzx2S7GTbF3NraFTT7KutFKq3o8pASLqfHJTxnaUaK9aDohKsQIPFHcmw75PGt+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 08:36:01 -0400
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> On 7/20/2026 10:24 AM, Masami Hiramatsu (Google) wrote:
> > On Fri, 17 Jul 2026 11:10:04 -0700
> > Borislav Petkov <bp@alien8.de> wrote:
> 
> >> Looks to me like folks need to sit down and agree on strategy first.
> > 
> > Yeah, I need to talk with Jinchao.
> > 
> > Like kprobe, wprobe itself integrates watchpoint functionality into
> > the tracing subsystem. Jinchao, I would like to ask you to redesign
> > the kwatch tool based on fprobe and wprobe events in user space?
> > I think that could reduce redundant efforts on the similar feature.
> > 
> > Using fprobe entry and exit event trigger, we can make a Function-
> > scoped watch window. Also, since fprobe and wprobe are having BTF
> > typecast support, you can access to the members of data structures
> > more naturally.
> > 
> > If you are interested, I would be open to having you handle the
> > development of the necessary features for wprobe.
> > 
> > Thank you,
> > 
> Thank you, Boris and Masami.
> 
> Boris is right that we should agree on the overall strategy before
> moving either series forward, especially since they share the low-level
> HWBP work. Masami is also right that fprobe and wprobe provide a more
> appropriate foundation than introducing KWatch as another standalone
> debugging tool.

Agreed. I just sent v10 because v9 lacked base-commit and Sashiko did
not reviewed. (so it just add a trigger-side BTF support which was
dropped in v9).
Think of v10 as the complete set of ideas we wanted to implement
with this wprobe.

> 
> After reconsidering the design, I will stop the standalone KWatch
> series. Instead, I would like to work with Masami on extending wprobe
> to support the function-scoped dynamic-watchpoint use cases that
> motivated KWatch.

Thanks Jinchao, I appreciate to work with you on this project.

> 
> Masami, thank you for being open to having me develop the necessary
> wprobe features. I am interested in taking that direction.

OK, please share your thoughts on watchpoint usage in the kernel.

Basically, I will fix the points raised in the review, but please
let me know if you have any other suggestions.

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

