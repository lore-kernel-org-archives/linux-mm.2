Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370C5FD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745B26B0246; Thu, 26 Feb 2026 20:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B786B027D; Thu, 26 Feb 2026 20:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6450F6B028C; Thu, 26 Feb 2026 20:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C08F6B0246
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:01:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D38C913A9BF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:01:07 +0000 (UTC)
X-FDA: 84488432574.01.DB814ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39D894000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:01:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KhOiihU7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772154066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fon1TuG5yY88sql3MRRytXLk1XNt3D5r2VZlKWaGn3E=;
	b=CIBvmkv0uUKivs23YtUpCxE2vqN7BKpG/V7rAzcfiKep8cQ6K++wxGddAhYJfFwfURTlS+
	YgZfDDMQs4Zpxs0a092dDfUqGxn1gTKbD0XraUcDFzMIQdK55uIaQpHszYiHuyVEaLnWC0
	GFGHpq5O/e6bRmiPLDmgDvAXVbNBtkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772154066; a=rsa-sha256;
	cv=none;
	b=Q9CBcyjN+sXKuNlUo8D+gr/61vvI5dO1fBK0v2NGn2LSewmcb+Gox3BT3Dph9zqsQYcIjH
	u3LPp2HL/0JTKWrtEIAu4lq7d7yXK9xKB7hvxMP4zv1U4wX69gEXSks5mi5XXIH3bm1grQ
	Tp8CZZMoFyfmRvRDMZEotnYGStXIXM4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KhOiihU7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59245600AA;
	Fri, 27 Feb 2026 01:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9B8C116C6;
	Fri, 27 Feb 2026 01:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772154064;
	bh=4YdI8/6MUimXC2VDFbWkxlvCxNeEa5FLhacHbA0d8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhOiihU7ZB9Cr8MQYmAF08bXEpvDGKdqyps/7oS4ne/TiBggviba58jvCLU13BuA9
	 cIdn11OYqUHxEqH2i5ABKOPhiqRfk0NddR8fd0m3/xGNGekEcvWPG+5/allEzxFbme
	 D46WiENInelFfKP9o0GYV9RERbTkIZAYmS5e58MajYx5hxHnc4n3sVjHm6lWCnyzpR
	 LnzfwXodKZlRd6qCK/mWJEe8iITd53SLpGiJr970Ygn7jxMQ1N6fxRo++Fn4xKGDEo
	 7bbpKx4U/9xbkHRjC4U5ZIOSOkOrc/1XaxIoq0lGrBTbRPfLuEyf0gZx+2t1bXrm71
	 1o/d8n8JrMNWg==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: SeongJae Park <sj@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 1/5] mm: introduce zone lock wrappers
Date: Thu, 26 Feb 2026 17:01:01 -0800
Message-ID: <20260227010102.83789-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226195355.611ec7f3@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 39D894000E
X-Stat-Signature: 7qionrruyr5cxc7199cm77j1iuq9oeqp
X-Rspam-User: 
X-HE-Tag: 1772154066-187602
X-HE-Meta: U2FsdGVkX1+axCYjD54RgonhiCgx6BE/0Hyez2M5TboptB/2ONnw4xMii5Jv2ilEFYwJTR9FMx14aCliT9FJUMgfMryVd9TVokgXrayDSxANYnN86g4RrB29P1fWFniJa6ejDoYC5m5qMROXV+QftepQ46b7f5PSarQQYbIB3Rr9LSULN1Z7D9zX1dFlPweybKlJo1mnc/UhY/vLI2cHMhdLMzhSnjfUYBE1jCnDjDqtxUL3K/RyeU8cDkelbmtifeGJ3IGBM8P3+yUHT3fHmE1K8qnnKLlZg6UxtJaJy/SUCTEeRBdxkiaRyBCKYKbFigkCXnwGwe/6VnzCyIEKpDzD8oFNkybvkZHW/JJChqnA6Sg8Nx2qW/jzV0/CF/9FkHutj1vqz9/kgZuZqE1tYBN1lZPHEfyBcp0jAszVoGrB2kLzPvCz5nMGrUrwTmCUjvjrsCgWJ6A1ODAQcXJh5110dkJcj8+SWQK9sJNvr1jVuAExOo7Qd66bbdm7tmKBnZfIeDKC2OS3ld9R4maFiP7885l83UnvZZGn3TMpJmMrrggGHRpiNnjzUcrGVx+SZlOkuhBlUNBXPMJwsnXB1066HmikPHsBXNLgxC0KemrcmEaE5/C2ZHh9PPcd2eXG0bNtIvp9z5NhCDa62oOQWvtGdGpjxi6To5U6150U977iQ72d2kUA6QnTge86CBYvVNqHTzCQJvFlu88hYp+e9VFw002cD2t0VOQNDy1SLgutFIn+l3sU1OlX+H+vkYRU8Jnhs2Ha+KhqP3nfAQluUBC2ZtENCQf2VLXKeB90VXqjIFmnVKAeTMAbRzbUIBwsqo8yjTq4csKrba0L5YUAIidRT3c7YkWmw0ELH4tFL1Goho1vqCH/s/8oJwIqHZWXQjZWa4a0WQsa8Oyb2ecwedyYw9GdzRd6v0Z3rP3nTR7oMbrezlkVpJLTum+9U/zB4xJT0S5CgEa2BDJHR2D
 cf9bZVcd
 Km0RqG4+KReeIpNNem9vgAQB28CCHmEeVdEVyQvjenxr4pqPBHL21H+R0esjZJsYl/V3i6gsgxZPdhdouOtZUEanU/jn4hvR1rI7xnCmLKY+DSACKPoc8BpmWBNw48lcVLBK2LMZjuW1J73B8q/KXvKY5pHfcDXjY35hfPDxeHKqRb/jUmhrzj501ChrdMN78KqG+FteFnfFfwIFXm6i4uAnRn+2UPXx+I2j8CT/Ox0akMP9VHFKqO4MGK1FrjBLNNpXbi+Wy3dYFPphX0dgGMv7jE7v/VmpIu0Fx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 19:53:55 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 26 Feb 2026 16:38:55 -0800
> SeongJae Park <sj@kernel.org> wrote:
> 
> > checkpatch.pl complains as below.  Should be ok to ignore, but, may better to
> > kindly make it silence?
> > 
> >     WARNING: Single statement macros should not use a do {} while (0) loop
> 
> Hmm, why is this an issue?
> 
> >     #116: FILE: include/linux/zone_lock.h:13:
> >     +#define zone_lock_irqsave(zone, flags)                         \
> >     +do {                                                           \
> >     +       spin_lock_irqsave(&(zone)->lock, flags);                \
> >     +} while (0)
> > 
> 
> I know this is checkpatch and not you complaining about it, but I really
> think it's a useless complaint. I can see it better as a do { } while (0)
> because it is creating a "function" like feature but can't be inline due to
> flags.
> 
> This is one of the reasons I still never use checkpatch.pl :-(

Makes sense to me, thank you Steve :)


Thanks,
SJ

[...]

