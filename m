Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA1510D14AC
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89846B008C; Mon, 30 Mar 2026 09:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A4E6B0095; Mon, 30 Mar 2026 09:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29D76B0096; Mon, 30 Mar 2026 09:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B23466B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:26:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 513F31607AC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:26:44 +0000 (UTC)
X-FDA: 84602804328.29.26460C2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8AED8A000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:26:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774877202; a=rsa-sha256;
	cv=none;
	b=ZYJm0KiB0/8z06lgLNvGtGHVuXSKFlqJHNIw3bx38lz2PWh+2t5A5iYo1vh43ITPhFJeyG
	IlR4LszOHlKvkeifRQE+S4INh5nxiuVLIVRU5Yhb/ikac5LwG8xLrUbT5fK4Dp/f/uJazg
	/FHgM7s6jSpy3PXO652KrROgn78ZXmw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774877202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jpfyCcZz8Jd+Su23FCem94rY3t7MKFny0hPzPaRNH6E=;
	b=SZb/5tvEHhaEuiAJg7/ibw1ikJhXxEiP0TGzHP5WgqnQoLQZOtWfPXj4FshU11BgchyFDp
	w1oGY1y8NlFZO0Gsm2cbMeWOUiDeklPlvfqaprWg65JUUUpZLSeWu8Oaku7Bk6JbIEvq3d
	qd/oZDk2xzroINVr/5xYVm77SmPvMiQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fksTl5vwpz4yjjC;
	Mon, 30 Mar 2026 21:26:35 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 62UDQMjt034504;
	Mon, 30 Mar 2026 21:26:22 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 30 Mar 2026 21:26:25 +0800 (CST)
X-Zmail-TransId: 2afc69ca7a01963-6ca50
X-Mailer: Zmail v1.0
Message-ID: <20260330212625434Ie7ad0bGFfZpP0q_aFY4X@zte.com.cn>
In-Reply-To: <02c6bf8f-303d-4451-83d6-4cc2b1dd4550@kernel.org>
References: 20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn,02c6bf8f-303d-4451-83d6-4cc2b1dd4550@kernel.org
Date: Mon, 30 Mar 2026 21:26:25 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1Yjogc2tpcCBmcmVlbGlzdCBjb25zdHJ1Y3Rpb24gZm9yIHdob2xlLXNsYWIgYnVsayByZWZpbGw=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 62UDQMjt034504
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 30 Mar 2026 21:26:35 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69CA7A0B.001/4fksTl5vwpz4yjjC
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8AED8A000E
X-Stat-Signature: 57e915qty4oqd5f1pe1yai8uspku4u9o
X-HE-Tag: 1774877201-377060
X-HE-Meta: U2FsdGVkX1+LWUKH/BR8R1F3S4Z+pebGBdVtZYweCLYFXfoEklyL4sZQpmVSXwqfDi2rZqxwrKtDSulXnf6AyzUdeyUpuWsr4bdvrPbwej5psmlWXr7KUIawOpypkyIUmbgwvkUyIsrIC/J5tsZH0NcqCAkIIs5Csn9NRFPwVRIVQIeSE6m9eLUyESPMC8Gy5NVhaH/ZwxFiRNtbptUff14/ZgnckJQQDwD/e5dmvQCDEt7eBgNsiaURnqSRgVhrKmxQ7t8BpeRMmG2awJCgX14Nrk9jrxhPwj4dMzNHXLULuhU8I8x7KQvasfLnY97TqhjMdkV+9JiAfdUHIhU692TIXYSl8RWOufx/fBj7jrZMQwp5fj/5Igf5ub6gVFvr4CGU6ULeHXzg7Cq8ZLM4fB2BIOwO/tQ4rlaU650mLogB+OkOjsLq+qUVanGuY+al33T+vQNzezUOvNwxF4kxszFlb1XbcuTcvYHTBuGvyGRGYsXCDBMPltyvMd/b12Upxp+PJUcUkw1/yuN4OP55sQlPT9YDb6ISGk0sfohb3naIQ9h0wWQzJI6bgScb8WgVN+yZwcMtd/nv+wXPFf5l4VIF60PbJWX+Et2yXt1dYvi7VLdSdDVMnNb6p0pI5lMWZYoWeZ6LIsv+myVKjjkCXw85MY7OEKo2zjclCwfveESa/mkB9/V7OPcy4GRwhNHGPNw0kWN/jbLK9iQxsUfF2k/9ghM0ovsHvWZhU/Ldjh/UYOyK+/LOcam5CmUl5UFj/AuS/2XYhFKQaQQZ7jqBkphJiZiWCq0Ax/R1xYJBE41QxamWw/5nkGeiOgl0zX2x6D70DUMTRj1RNC0gj1v+ch6AFh2oYNLFYzAGJX1/clBni5fSjx1FTxNH2c3qo8xOOsOYUxBJ52wOSjbZKiSVChunEBlCntnQ26iHOhFGXekxtT1hrqkYGMZA5trQfLx6KQyaWzG8ap4ABsUR35k
 I1IJC73B
 qOud6sioa/lswoPCoaSlBuBXASZvvRoUs1/kyuqx360pGixr3LUCMSM7HB3WGa7z8nMzrEA48+Yay69wjoMGfBYqV3OXCTmTktVmWTSYWSZNzZKKh0ai1arDUviHZkc2PGPSA+NLc4GFRQt3E426xIlaF56UTdjTZ9PKCgzwGfBv/5i21YxMmQ1HQc1zjtMEdPfnqKb7p84q31k3DHAmPQoqJ4NrJySj2//cGCtMCugjZSNGReT3HzEBEO1bln0PdekLI5vx+uqxUm/2XMkmu3xdqhj8Ah0IDakQa5lZsOgBz1By0WuKkshOqXialv51ULZ6B3X2rOk0TvzQikn+A6vCsq9xw8FJkUAJbTuPZDqFTMKKXNnL7T5yQ+n+Y596amU/7Cb5WAqe1law=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 3/28/26 05:55, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > refill_objects() still carries a long-standing note that a whole-slab
> > bulk refill could avoid building a freelist that is immediately drained.
> 
> "still" and "long-standing", huh :) it was added in 7.0-rc1
> but nevermind, good to address it anyway
> 

Hi Vlastimil,
Haha, fair point — that wording was indeed a bit inaccurate ;-)

> > When the remaining bulk allocation is large enough to fully consume a
> > new slab, constructing the freelist is unnecessary overhead. Instead,
> > allocate the slab without building its freelist and hand out all objects
> > directly to the caller. The slab is then initialized as fully in-use.
> > 
> > Keep the existing behavior when CONFIG_SLAB_FREELIST_RANDOM is enabled,
> > as freelist construction is required to provide randomized object order.
> 
> That's a good point and we should not jeopardize the randomization.
> However, virtually all distro kernels enable it [1] so the benefits of this
> patch would not apply to them.
> 
> But I think with some refactoring, it should be possible to reuse the
> relevant code (i.e. next_freelist_entry()) to store the object pointers into
> the bulk alloc array (i.e. sheaf) in the randomized order, without building
> it as a freelist? So I'd suggest trying that and measuring the result.
> 
> [1]
> https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLAB_FREELIST_RANDOM
> 

Thanks a lot for the great suggestion!

Agreed entirely — maintaining CONFIG_SLAB_FREELIST_RANDOM behavior is non-negotiable,
and the optimization’s practical value would be quite limited for most distro kernels
if it only works with the option disabled.

I’ll implement the revised approach, measure the performance impact comprehensively,
and append the results to the v2 patch.

> > Additionally, mark setup_object() as inline. After introducing this
> > optimization, the compiler no longer consistently inlines this helper,
> > which can regress performance in this hot path. Explicitly marking it
> > inline restores the expected code generation.
> > 
> > This reduces per-object overhead in bulk allocation paths and improves
> > allocation throughput significantly.
> > 
> > Benchmark results (slub_bulk_bench):
> > 
> >   Machine: qemu-system-x86_64 -m 1024M -smp 8
> >   Kernel:  Linux 7.0.0-rc5-next-20260326
> >   Config:  x86_64_defconfig
> >   Rounds:  20
> >   Total:   256MB
> > 
> >   obj_size=16, batch=256:
> >     before: 28.80 ± 1.20 ns/object
> >     after:  17.95 ± 0.94 ns/object
> >     delta:  -37.7%
> > 
> >   obj_size=32, batch=128:
> >     before: 33.00 ± 0.00 ns/object
> >     after:  21.75 ± 0.44 ns/object
> >     delta:  -34.1%
> > 
> >   obj_size=64, batch=64:
> >     before: 44.30 ± 0.73 ns/object
> >     after:  30.60 ± 0.50 ns/object
> >     delta:  -30.9%
> > 
> >   obj_size=128, batch=32:
> >     before: 81.40 ± 1.85 ns/object
> >     after:  47.00 ± 0.00 ns/object
> >     delta:  -42.3%
> > 
> >   obj_size=256, batch=32:
> >     before: 101.20 ± 1.28 ns/object
> >     after:  52.55 ± 0.60 ns/object
> >     delta:  -48.1%
> > 
> >   obj_size=512, batch=32:
> >     before: 109.40 ± 2.30 ns/object
> >     after:  53.80 ± 0.62 ns/object
> >     delta:  -50.8%
> 
> That's encouraging!
> Thanks,
> Vlastimil

Thanks!
--
With Best Regards,
Shengming

