Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2B6C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88576B009F; Mon, 24 Aug 2026 10:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38746B00A2; Mon, 24 Aug 2026 10:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28206B00A3; Mon, 24 Aug 2026 10:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEDD6B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:09:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DE30A25D9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:11 +0000 (UTC)
X-FDA: 85136344902.29.D5536DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 58DB41A000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/BbPk+F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvvHdWSgiKDtzeEGBLXovDEMQB/etn0YLv2VjHha/oc=;
	b=x1sOLFqK3g4JvqkObqW51SyvVp4LTLpU/ulGTjH9dYZaR5W722NfkbP3YchxeTrr4bOu5D
	lmyaQS5RBTefRHWiJokQVFeyJblClxheCeOVoBK8oWqx1yqgAZV3DRV8LAYypCkqcsr3X2
	KqP90Fmk8MPvXRXAP2P1fqhU8sH5W90=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/BbPk+F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580549;
	b=COclVs7I0t1dWZX3b/sHYdp0LQShJihAsl5ipHBjmSWE+DloOK3UGnXXl9/Lne5Uj9I94t
	zjg2xUzov3EWn0jcMu7kBxl9GQ2MMcyVFqGTflEmNLo83098klk0pvECMdISG7VDSecxh2
	D43gmZWcIl6k2ZTQfmUp3JkOSNt4ssk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53B1040876;
	Mon, 24 Aug 2026 14:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3361F000E9;
	Mon, 24 Aug 2026 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787580548;
	bh=JvvHdWSgiKDtzeEGBLXovDEMQB/etn0YLv2VjHha/oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A/BbPk+FxFEQ7oFT5u7LI+e00+LwJ8IO/tJbOrC0smfoSE0yUbc9lytxqk2Yiorgc
	 tKR3edSILfdUmhd0Ib0PcfUQFOXlgk+xSApmYONRI2jpmdWiBUQSkre4Zv6YnoBQvD
	 MgeUymGFV5ALU3CHWpSHPCZxhukm+xJ7OetA9tDtw1Fqzss0sJs9oKiEBAY6fAtH4h
	 fXGpIkulZD/NESDP7H4I/qelVbDR5VuYUDcuychKaLxuk/SEEeDKYRYWLg/4wlPlHQ
	 JHutl3YkVq3R0WGLgWLowBeKwNqnrLY9oOnU9h9NjRAiKkbQ4HlRw/BMVfH4cBNuWo
	 QJ9jMLUruA/tg==
Date: Mon, 24 Aug 2026 15:09:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aoxPzKTVRmZgmBKg@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
 <aow0Z6mrG2esKpRZ@thinkstation>
 <e1c8c6f5-1b5a-4cad-a52a-f7eff00997c3@kernel.org>
 <aow6J1i2G7U0spjH@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aow6J1i2G7U0spjH@thinkstation>
X-Rspamd-Queue-Id: 58DB41A000E
X-Stat-Signature: 1dc9x9kkqns5ieptt7uqhib4jo5fofjq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787580549-121332
X-HE-Meta: U2FsdGVkX1+n0bJu7bQK1+sBx5jcd7UXcRAbiQd7XFesQw1gSuZLx1SuNKnOCBbeO4Iv16L9kqDvuQ+9DQK9/N9yVjOJ1RD5hw29M/icjInQ77xWn7ZbOck2+2V270ky3x4x0mMBv4FKveCEnX6jMN2mEtnT3ziemj2UlEg6k92DurM1MwMuhUfW/vLRWmdKDU9SJGc99tYLTWWOHHaBaxlNGFH+tUUEKseVv6U8G5WPrRhlB/AT2mcgoFmdja8DCVe2U5fDDeWaxXegZsiP7KgedOt8dqbsxReWyzreDIFDgMImLVjX1j45WuOWfyeCgHenY0UPKNiIGOlBxL5R3p4HyuuTJm0n68EPtp+aFWdnBNrVKbg+e7a60okihfecnGMSt8/l97oQsNMbCKBic1n81YOpRqoN8M/bJ5pvP7xGL/R4ckuXcSz2IIAo4wjlzJcvY5v7xDkPzEwtwBTfSv2TVr1N/cmwyWU6AGUZhEPisVgXY7S1jvMAQfsrjvkZTp0p4fzgbyj8JtPrR/Rwat8u9YRcf5ipy+lh0KpQZDchSSO7RwcjUn73kRg1am91fshrfSTzlDYGen/JnrcIPtTD7qgctzsNWh7O8KjHGZSrL/ofoCgRy3NsSQRoCnHc1xLHchPSCGGxI8aM8VxWE9840sdxGPtFZbNgv4HJn6pfqp7IGiFv2EFtj4V3l3TKhwMZACkst1gmYR+VBMIiZCQpbytUImDdyjOvuRFerahJQcgtmYkbat3XJBkGZ5/1HTBidOVVSTBnP+lVK3s8uggqu9sJfHx3vXkbKk6teVzf1tvtjKZ/Ou4QqwQgkiqxK2hx21ZMaNioT2vP2D8OVFHCuMnxEFmcDOOJNfi67so+VSF1vqODiXHUq1rmgv1VBTUyig4Edv3/U+HNMaCJ/cv22wjUZg2VnijP8Emt7WZyszLfa1X4iZ0K+e1JAsvphBWM4iTlpkEkYJdn147
 5BPW7uip
 yh5y6bRpFAPykp71k/N+dwQVHYN8VbGSwFg0fjq6YipcIf/AXXjJ94s2qOAMkU550w+SM4oI9YZbcNDNoEz561q7z7Gob48u+FziGD/WxeYCwcqNu4iOocduQQ0R7iYpizSZyj2aJRVFo52yBY7eTjyCfUkYjBUl1XLnmRTme6b2h8PjsX5ciox545ZOir2qt6KX33fikY09aq2THaNGbx6YWcOuUvKpFK/zUCvXu+XcdEIJAlvyIb5aV9BfptaS1sdzc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:36:03PM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 02:28:39PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/24/26 14:10, Kiryl Shutsemau wrote:
> > > On Mon, Aug 24, 2026 at 01:47:54PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 8/20/26 13:11, Kiryl Shutsemau wrote:
> > >>>
> > >>> I went for a clean collapse.c on purpose: the engine is new code, and a
> > >>> new file keeps it readable while both mechanisms are in the tree, with 28
> > >>> as a plain delete from khugepaged.c.
> > >>>
> > >>> Your shape is less churn, though, and it keeps blame: 29-35 move about
> > >>> 1700 lines as add-and-delete today, and most of that would stay put, with
> > >>> only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
> > >>> khugepaged.c.
> > >>>
> > >>> If you prefer it that way, I can give it a try for v2.

Please don't respin this as a 57 patch series.

You need to break this into a smaller initial series that lays some
foundations.

Cf. what I've done with scalable CoW series as an example.

> > >>>
> > >>> The rename has to open the series, so it will collide with anything in
> > >>> flight that touches khugepaged.c.
> > >>>
> > >>
> > >> Kiryl, I have to ask, are you using AI to write your replies?
> > >
> > > Yes. I use it check my claims and fix my grammar.
> > >
> > > Why?
> > >
> >
> > It doesn't read the way you would usually write. In a bad way.
> >
> > E.g., "Your shape", "has to open the series"
> >
> > Consider telling the LLM to not change your writing style and focus only on
> > fixing grammar.
>
> Right. Asking for rewrite with proper grammar was a bad move on my part.

Even this reads as AI-generated... Consider writing the replies yourself
please.

You've generated a ton of work here and the AI-style giant replies just
create more.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

