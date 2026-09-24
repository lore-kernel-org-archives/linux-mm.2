Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89F3C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB4B6B008A; Thu, 24 Sep 2026 05:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B9A6B008C; Thu, 24 Sep 2026 05:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4AD6B0092; Thu, 24 Sep 2026 05:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0C226B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:52:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5651D1602D7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:52:26 +0000 (UTC)
X-FDA: 85248190692.05.791595E
Received: from mta1.migadu.com (out-66.mta1.migadu.com [95.215.58.66])
	by imf06.hostedemail.com (Postfix) with ESMTP id 37F9918000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:52:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+yfmRxo;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790243544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5JfTgo/JfQbkxDCgf9+aPeit9yY1xCsCc4Qg6TuzmI=;
	b=5FQ3PIpaOxK8wyXKsRIs8S0AutRWP97WU7khrM/lEEA/XXLhHz7L62up5RujmXwLhIse+J
	1LaLVls2vf4CjzFzVr2s+pMxAxt27977J6wHZpB6DOhRsypM/NBkCVYJ/l++jnhDwFIgV2
	wVphkL9qDKAXxFR0t8sjHtxmIE7qvag=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+yfmRxo;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790243544;
	b=nHshUO2pxwHYDRlBwJx/cHodnzSn1wnJUSh1R18ddglD9qgYflqgL3EIE8P1reCRo3PDsi
	qrBXRFvgBkIL7rOvTDny96Khfp1At1kdDSnlekAcskzJyAJOPKOvS9AhAoXD03ja/K8ecZ
	lKkWGQ/Umwf5GFXo3Uo2P6EWe6GZ2Ss=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CACgk1em+Vy8Gh1bLJdug8Dy1sGNAy+1bOJLeSRf7IU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790243542; v=1; x=1790848342;
 b=v+yfmRxoiCZYw0BX/hk9KDD8VZSGbzrq1Zazi/MgI2IRvjP8/xr69rKJLi5gUbimeabIicDX
 KjwI1XZz8RPD1kiYG/1ke+Gnjv0ijR/4/1UZYgcybhbqu3cXe3y2IjeN4SfGEWL2lyxr3NgGFTl
 lwqycXdp9Bs7ZwK2oDeCEk7k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c0029a296d3c7a22;
	Thu, 24 Sep 2026 09:52:22 +0000
X-Mizu-Trace-ID: c0029a296d3c7a22
X-Migadu-Flow: FLOW_OUT
Message-ID: <057359f7-0e8f-416b-8b5e-0b60c1c936e9@linux.dev>
Date: Thu, 24 Sep 2026 17:53:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] alloc_tag: Introduce selective tracing for MAP
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1790025465.git.abhishekbapat@google.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <cover.1790025465.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37F9918000B
X-Stat-Signature: ffeek89f658r5pgdj7git5zduew6jxjj
X-HE-Tag: 1790243543-145649
X-HE-Meta: U2FsdGVkX1/4vT6Y5aafXlATrTUqOprhxUXNu9b0BGvwJbU/epelwypmwqArgiYERv3zA6m+YOs+a72um+sUF4Is/O6rb03wQU9yOZ55YvOKea0Fcuk5QFBJfRuvjw9KUzGyQjEV9aWWeiJagGCvCxeY2wzdH+af09jR4iH9e0P2keFH0BzEHAt0F974XHLStoQH0rJp/1pm3GyVkDvFNG+gqLep6vW+rwNJGWWSvcVJF4GQrxBwkH55Y1R/38sH8C52FVdZvj8rUjzOrWRCBLAHx5ph4AK++53+/cjUl6KmRsfePlDrF9q34Er7tLhpQZ2LrQB42e2h21q8FfVWaryDsaO8kNJyp3Z+WG4gMOiVCl5yAJyyOPcxml15njexuutBk0FF/erj5TVjRnDnISd7c/XDiY+GivCQyOE4d3Kj2xDPO4uOjo+t1Wa3E8OEMdzEDEhRuUJv01ApsUekeFXKyQz7HJ3y4aExtD5G/LQS9tP+JZg0iMsPXz9McZornW9qXV6FKxskDGOV9YdTvXmBxLMG3Q1izzjHDJKMLSHx+YZoThvDMVl5iLqivWMi9TjFH0VEn11X0sOh6JIIJGVLhEweea4uoUhcpjoxOupW+wM1JBQosBHVpgiYflLrkLYX0lWW6MCtNv0GzLMbGZWr19ImCuZEuePno6qcmI9QS21fFulODFkSdxNZN9ecfx++q2Q0w003NE/3ViSi7JbmjFMYIibT3llaUaGH6Ur7xz9Rju7soxa07sFSEVEbTRG29M7tRly2U3yi85wAP99gUIow7YRbyo/+jOfA3nr1R/9ps8fjEo4oyWBCW9oMXhunNKJpgMLuGcag4Eb+sNGin/6o8e9/LAribMbo5YTNm9dYhOzChtIx9bxkGapT/gzAxeD1Qlgh7blm6a7ZumPvsPJ7dbq5xQcJHHFZMqwdt5Ht2SjnvJfH31GOaSVV2hr6Bf7W2caYjxO4Zc1
 C2g/lLmG
 Pn6z25iJCaItyFB1KQ1WICugCBA1nKy5Eo/pjuNtyfkoHWkfNUVkVfFfV/RWurV6cgD+4woXsEEjn7WK44lLlvPwRbsY3EjYIUNvVH7qGFtw317l9AEwzd1JVz8eOZy5wKUx2Vgo7n6wW96ZEdaIw7gXbcS3YtWDClNyEcjo8rHQLo/ctHbErN4Y307ipmULmtpqibMPOn5M7lsgGH/TMwLS4DeX984IHZce504N4UZX6HCmcpa/bCHXeeYggtUa8rRzgTyDM2PJX7FL5POnmE7Xl6Bd+qPf2J60Z4ApH66KCmKNCSGxAXnf/k9jEr5PWRBBkCLDyArAFrKB7uC0Ot9Tpy/3xqUACSTf7fIrj2gnfKxbcM+z0KTs7pRdY+iKQ10njZZYilyR3BZ592Wtpp5mupQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek

Thanks for your patch.

On 2026/9/22 05:26, Abhishek Bapat wrote:
> The existing memory allocation profiling (MAP) tool accurately maintains
> aggregate counters for overall memory accounting. However, relying
> purely on aggregated counters restrics the visibility needed for
> targeted debugging.
> 
> This patch series integrates three new tracepoints (alloc_tag_hit,
> alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
> alloc_hooks_tag fast path.
> 
> Enabling trace events globally for all allocations introduces a severe
> baseline overhead. To limit the performance overhead, we let the admin
> select specific allocations to be traced.
> 
> A new IOCTL is introduced to allow privileged users to determine which
> allocation tags need tracing enabled. The IOCTL utilizes the
> pre-existing filtering mechanism to specify the allocation tags to
> enable tracing on.
>

I think this cover‑letter could go into more detail.
Also, the cover‑letter doesn't include any how‑to‑use.

Looking over this series, it seems you expect users to first call
ALLOCINFO_IOC_GET_AT to obtain a tag, then pass that tag into
ALLOCINFO_IOC_TOGGLE_TRACE.

This behaviour is not reflected in the existing cover‑letter.
Before reading the code, I assumed I could just pass a module
name to trace all allocations from that module. After going
through the implementation, that turns out not to be the case.

Because patch 2 enforces a full mask requirement for the filter.

struct allocinfo_filter filter = {
	.mask = ALLOCINFO_FILTER_MASK_MODNAME |
		ALLOCINFO_FILTER_MASK_FUNCTION |
		ALLOCINFO_FILTER_MASK_FILENAME |
		ALLOCINFO_FILTER_MASK_LINENO,
	.fields = params.fields,
};

So to trace all allocations from an entire module, users have to combine
ALLOCINFO_IOC_GET_AT, ALLOCINFO_IOC_GET_NEXT and ALLOCINFO_IOC_TOGGLE_TRACE
together.

I have no strong objections if this is the intended design.
That said, we should settle on the expected usage model up‑front.

Having corresponding Documentation would also be quite helpful. That way when others
ask how to work with this feature, we can point them to existing written material.

https://elixir.bootlin.com/linux/v7.3-rc3/source/Documentation/mm/allocation-profiling.rst

Thanks
Best Regards
Hao

> Abhishek Bapat (4):
>   alloc_tag: Add trace events for tracing allocations
>   alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
>   alloc_tag: extend allocinfo_filter to support tracing queries
>   alloc_tag: add a test for trace state toggle and filtering
> 
>  MAINTAINERS                                   |   1 +
>  include/linux/alloc_tag.h                     |  94 +++++++++---
>  include/linux/codetag.h                       |   5 +-
>  include/trace/events/alloc_tag.h              | 122 +++++++++++++++
>  include/uapi/linux/alloc_tag.h                |  17 ++-
>  mm/alloc_tag.c                                | 142 +++++++++++++++++-
>  .../alloc_tag/allocinfo_ioctl_test.c          | 111 +++++++++++++-
>  7 files changed, 462 insertions(+), 30 deletions(-)
>  create mode 100644 include/trace/events/alloc_tag.h
> 
> 
> base-commit: 8d61431ed2607386b427752505379536eb634ce8

