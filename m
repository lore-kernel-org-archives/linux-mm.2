Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 988A8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97ED16B00AF; Wed,  3 Jun 2026 15:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F526B00B0; Wed,  3 Jun 2026 15:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F72D6B00B1; Wed,  3 Jun 2026 15:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8E36B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:13:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A4A1C1F4D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:13:39 +0000 (UTC)
X-FDA: 84839550558.07.3551605
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 521B020002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:13:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/r/IFo6";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780514017;
	b=pmY9/cde1HWsIBnXDqQXoM9OdycJ5L7rnkf2s2YuN+TcKSWB6pCbHOU2AGnxB5n0C2a6dH
	YAHvDxBP4YdEjhrw8LXXkEgE1NiKV1un9fyai8Y5U9HpdUSHrgoDgBClACNdeUJk4W4tQ2
	ncsWp3t8SCVT3OczJ8sD/YgkFcBCo/4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/r/IFo6";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780514017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRRc8ydgJvk3dCRJzMoxz+ZM/cka9KnQs2wvZBmcrYw=;
	b=KRQ+adVt+lkeS3ghjxAODeEF+Totxq/73CYfyK/i0zNPHgtLTfmmVZlzx7izqUrb+bYnVS
	MofQzWW9x8+75DLcG2yVPf1XgRYJTeyiWOBN80viLiFzZL9gft+R8HjcyS5e141t8WkAeA
	AW6L+B150NVqfM+MZPvqXzr3ocBmqbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96C75600AE;
	Wed,  3 Jun 2026 19:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0951F00893;
	Wed,  3 Jun 2026 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780514016;
	bh=JRRc8ydgJvk3dCRJzMoxz+ZM/cka9KnQs2wvZBmcrYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D/r/IFo676vUApletMFZxTexyQsKoBkTA1G9DhNDmguCEgLDxVNm1u/AYN4XmV8Wl
	 lJQcodJTA0k7HSI+dsqUOU7oyJEFY0g3/PE1QCVBkPdo1akBrAhfJF523TyurX9LZD
	 PbUweaF1Epcv1Ys2i6q9cmWQ8zInCEffbwOSivMSBbc8ggeM26RJ3PXqhsAeh43GsF
	 Mak2qHILhAzFXX221XyWE/VgebrN8XxVeHYGRXtqXasP3Lp7nBTjDqNx344DCG85QW
	 T9a1Tr5UFhj6wue31HJp2HEimqryurvP/0EfhwpE+1HcQHw2MGF5Tagw/WlpTejf0c
	 lNksNWWghOJ+Q==
Message-ID: <b637ede2-73da-49f0-a7eb-70ec79e79624@kernel.org>
Date: Wed, 3 Jun 2026 21:13:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
 "Luck, Tony" <tony.luck@intel.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>,
 "Lai, Yi1" <yi1.lai@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
 <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
 <20260603121707.7eccb9fb@gandalf.local.home>
 <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
 <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
 <20260603130006.7d2c4a62@gandalf.local.home>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260603130006.7d2c4a62@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 521B020002
X-Stat-Signature: trgbygdho9ybhm895job86738tmomxni
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780514017-797037
X-HE-Meta: U2FsdGVkX18LSCdeK4xeGSI/CY0X9H+m5IMlTvasyEQnOXsbGN3caSiR9jlmIAHVGqysqNJnvw1WUUwu+foUXE9TeAU10bkg7gNZ3pikhKPwucpCS3P52+3rXxfLabomXD9WDWLBx8FwKYzH2jE4IeRMAM8GgGT+WaMWWQ34dMiwKVxiApqRcwJsM7ouvdhjzZLq91DcY/D+YAwviwnCUGRubRGhyTvw/6bbwAb+W0z7HeacLh4S69B/rh9Q6HcRN0uIeGuiV5+TDcuOAuA6+nQTo5h3oOfbh2lef6AfLH2oWs7b7Tn4peV1Knh3hvDjnLuYrzawEzqGKR6feMRXvNJaZLSl7e1mcWRMLHVt2BEVan7f94ulO8xHoXWjsuECB1iFXStMkI2g41sP44whGQgHHwfrPpgGD3iZhn10X44UlRhz4I5lbWBkNT6ANnX7xxc5GMS8lrT8ciu7BHIX4sBRd6KGklkpL8AdqxqIbpG4rchbPfzeMml4xajZuDfAydZAZZ2+wDvmUem2mr630d2rNQSNQHqBHJdSF/wNa0hzDOk7h6Wk+kQ79MgP+ox5TWVrI4B2aRa9UKjInqHnfWvfhRoj/mF/g/MmWhNtpXT39ZEeJPYV7G+LditVovorIzb+CcbkygJmeeDmxO29DZF/70bfDsdWRzNYYxclcqA1e0B4j+0vlWRsu1nvC+5Pn/BWp0Qolidiqgg+8bqNkHTzA/rWwNemWqrQlNHt7y7QZe4Bl2M9Pi7fS7uxrUUhGU6tf/6Q+jhv/y2r/2m+z+OQggRS2rYc/OHE8QoDQtWX0IITHyy915FZMbRaRPbnrs8CXVTQuFWVeLyMz0jO0xGrcyrtgKAutRbRJQ2pY2/RkiWHd6lXGCRNwV2xqOTZSogB/FCpaO85kyCEIwQkGM3mxFD2YaLoWdFPtE/KNCxxusGEDcp8ZgzoAHLf8GItBmRSvtk2UJYJpePKe7u
 urFjeI5/
 1R6ZVk0kkDEl8odgVnRFm9F4L83d54k/zZEvTqzDGeo84IATi9nGtF0GSu94fIbAiLIlRf43fNEhcZlsYcqYcJuQZcmQ7SJsTiRo4HOa2hsRpunXO0bxrHcb0Ye38+67MYF4VVc3lc7iRS0P87bLrH6o83EW1CDfEmexC+CK/mTKGjnc7aawWHTxAvVAhPJaM/Wx2chdBwwcA8Im7lDaw5HSKub4ZdTD/Er4VEp1d25HHCOesI9khDPXwENJpCXaGGxc3mePZrSwIyPBZ8YNuE9RJ6v22r0LWMKuCk2UBBkeCGmIub19kid7D1I0b/wm6Ld1CaGWMo7NUf2/UumkM8Y1SG2D8mH1iifp+4co3DBBrz7EbamogONmu3vSS9VMn6ItyRsJnqbWoryJt7E+K3afgI5XDNV6d803t51mmVWVGv9G2p5a20U25MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 19:00, Steven Rostedt wrote:
> On Wed, 3 Jun 2026 18:26:24 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> Yeah, I was fearing that when I read in [2]:
>>
>> 	"It has become clear in the past that this promise extends to
>> 	 tracepoints, most notably in 2011 when a tracepoint change broke
>> 	 powertop and had to be reverted."
> 
> Technically the issue is with trace events and not tracepoints. The
> difference is that a trace event is created via the TRACE_EVENT() macro
> which defines what is to be collected from the tracepoint and exposes that
> information to tracefs which applications can easily see.
> 
> A tracepoint is simply the hook in the code that you can attach to. Trace
> events create a callback from that hook to extract the data from the
> tracepoint to fill in the fields.
> 
>>
>> Which means that I now also fully understand
>>
>> 	"Some kernel maintainers prohibit or severely restrict the addition of
>> 	 tracepoints to their subsystems out of fear that a similar thing could
>> 	 happen to them. "
>>
>> Whatever the result of this discussion will be, I'll try to document it.
> 
> You can still create a tracepoint without creating a trace event by using
> the DECLARE_TRACE() macro. The scheduler subsystem uses that quite
> extensively. That creates a tracepoint without exposing it to tracefs. The
> runtime verifier uses these hooks to monitor the scheduler.
> 
> But you can still connect to these tracepoints from tracefs via a tprobe. A
> tprobe hooks to tracepoints that you need the source code to find (just
> like a fprobe hooks to any function). Thus applications *can't* rely on
> them because there's nothing there to tell you it exists or not.

Thanks, that makes sense!

So, would it be fair to say that, in general, what's exposed through

	/sys/kernel/tracing/events/

is stable ABI?


Would the following be sufficient to avoid a full revert and the dependency on CONFIG_RAS?

diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
index aa57cc8f896b..c46b17602578 100644
--- a/include/trace/events/memory-failure.h
+++ b/include/trace/events/memory-failure.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM memory_failure
+/* Some user space relies on ras/memory_failure_event */
+#define TRACE_SYSTEM ras
 #define TRACE_INCLUDE_FILE memory-failure
 
 #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)


-- 
Cheers,

David

