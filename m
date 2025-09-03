Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543B7CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614546B0007; Wed,  3 Sep 2025 03:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC216B0008; Wed,  3 Sep 2025 03:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502BF6B000C; Wed,  3 Sep 2025 03:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403E06B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:58:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ED37BA059
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:58:52 +0000 (UTC)
X-FDA: 83847187704.26.700731C
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id E70A9A000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:58:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0YCW9dy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756886330; a=rsa-sha256;
	cv=none;
	b=3V9EQpTpV0qwxn1tpn4pRfeo80Q/nCgo3Ez0tY+8AGT7m8Q+MAFPtE/ltIEMWqntRV6VWH
	PXNjnmXutYVAsFW9WtkLsuk0GIwkrGlUfczl5aM2M8oQW9PVfrcu70P8fwjJdeB+l415xh
	yIb9dprHRZrXMYCoK1WnO1Zfg18Wyys=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E0YCW9dy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756886329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhAVnScp5EkAabs+130F6qkoMdoZHl96tw+d3Qg0Q1c=;
	b=1FnxgZ5ELQGLyJFn5r+4CQZrnISUOCOP2Uubu89zRhBKgNCEIfJyvwzHwMr0HviVgJceaZ
	46rGsZVXr/qWnXp+xLU+3LtK9TKQzkg3jOVs4mJ1VX36Wk41Njdzpm+aAi3k3aTuqwcvME
	hmI9yPFUmgT1OBQr/QUjTRoN0B0MYX0=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d60110772so52992767b3.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756886329; x=1757491129; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yhAVnScp5EkAabs+130F6qkoMdoZHl96tw+d3Qg0Q1c=;
        b=E0YCW9dyQ/s/e2D+j/i1aw/vWUmKh71o7RoNBIKd7/trnbWjngZ2J899zJ/Y6rDcPb
         1UXDf904qZbE734Ve9vWimmTNG6bWcs9+bhJ9yjpYdCbJb5oPRdEtmm70xeXlRcvrai9
         gvyxVYJBpqjfJhSqxFwjZTsQ0A8FlE75WKYvI30LAwI9VfRj0p6oakBe+HmyN87cE86x
         y3cYFHodLy5sDv9bK/CSs4mF3SNtor/HnCj03k1Tds2YipWZATfg/KT67BLRQPvYpzMd
         gS32yN6DYEso6VvFBIQgZTdJgDGPnWosVnJ5dZJWDzvkFiTA77u9ueGyucIjbE6xzfY/
         OneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756886329; x=1757491129;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhAVnScp5EkAabs+130F6qkoMdoZHl96tw+d3Qg0Q1c=;
        b=l3S6GaV2kqebhVywb5mbefNXdygPrNf70dpnXvBm+95OCh1jVQQ9RcOdoaKlIZfxYF
         a3nrfBrwFfklLI8o8gJqLWU10NR2cVR+8Fzt0AwpxDbD2ovS+8CK81ekiFMAKXsM6OD0
         nV+Na9xgwAIYPQK3uDq82/9MhtzcHzU6Y0aYHdD8Wt3A1V63j9napstcAL+y4HjZldUx
         R8gWD4j2ERoZxvWwrzLDenILU+8hqzPdPagLhf4viJyDsdRNhV2v4Vri0L3ZAlOOTd63
         neydnWzpiVZcfOHk13mxXn8iynXXlJXpuFZhI8Q4iueU7p825yH24YsEc5WH6gJbOV8N
         7ozQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsTeAyakQzvpGrXHcFQVxZyEkmEiYylsVix3Wo5IHYTSpPAE7a5O/qT6iVGgNRDE0CC2oz8xAHvQ==@kvack.org
X-Gm-Message-State: AOJu0YzlvHTbU1b49oDg12cbVcX0WBNS0DgK/GZ/B42I0n1bg8KBN3kA
	eX1kR4yAsxq1uO4rExVvYF/OY+PiY64j+tsBLzes5UwZRlsMzYeYT1MB
X-Gm-Gg: ASbGncv+XzvIkeBMmVPT+5SF7KqwVofDpy0N2ZAQ5DSN+CEHzHYa658GiatJEqwLMhj
	VXEK7QgcnTpORZp5q8heTkugBg5Th+2UVRcx/Iwsp7UBW/zLOU+PeOaRNpLLI4ICMyNwyjxpZoD
	bkGFMyim9qiTYobugBDzb3Pd/wworWJoOnl+DdPUN5GA7glBe0ajpEwu3Tyex8FBbJf5Geh2BtE
	UQP+Cjr+LWQjS0AxVc9TRsxbIfnJle/S9xIo9zI7vwCyBN5iAmEwRWlBlcYcy7L1hCQownlIDSQ
	M7eGgeyaN3p2RdmGjh20Z+k17duebhQ3x39kgfX+b0l4xKbW3phF2LlpqLCupNHkdI5keQVFDGM
	zZK02Ai8uTQ9Wgc7Fx4DoLW9+75rXdA==
X-Google-Smtp-Source: AGHT+IEx4yv1FTXUxNGpW0sEZ9ARp8JFX0NW96PCFD5SvnuIG7mMycDbU9MFc55AdRFLd4MlHcYEOA==
X-Received: by 2002:a05:690c:688b:b0:722:6a42:5cab with SMTP id 00721157ae682-7227635cb7cmr150931017b3.3.1756886328733;
        Wed, 03 Sep 2025 00:58:48 -0700 (PDT)
Received: from [127.0.0.1] ([2a12:a301:1000::20f3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8510229sm11638517b3.37.2025.09.03.00.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:58:48 -0700 (PDT)
Message-ID: <5a6dde06-11ee-4ce7-9cb5-f0b8096e42ed@gmail.com>
Date: Wed, 3 Sep 2025 15:58:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
 <284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
 <20250902231152.442041a74774d888cec39201@kernel.org>
Content-Language: en-US
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <20250902231152.442041a74774d888cec39201@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E70A9A000A
X-Stat-Signature: 65pgqpxancr6rato83yg9pes8453giuz
X-HE-Tag: 1756886329-441681
X-HE-Meta: U2FsdGVkX18cep75yZffPQlEm2tGhUxhcYZkexZIU2Nc0NkC9KVxXIslh1mV49ahvMEXtNgbCDL23B1fk1dW+W+K8EISyBq8bIFkS/s3YKbdXz2zaCpI6iT7zoXVBFh4mQulztnjkIH5J2ZD9EUf02ntNvD+zjyKLDtof5AbZJnHoOFFid0HvwRucxcBri0eXldOtd7k1tZzFXKN2TObt4sacBCyq7zT4iaIUii2DmDZC7wldznuo4FELg9pYV6mE8aDcW9A7XCJdZQK17frWd1c1ySvtj3PbT3WHWgSGq6Zcp5pgTZZoDKbDhHYutEA16LSu5reEfMLvRJpy+O6M6gRKJBkL9IbQlVyYWr6LjkI784rQQgYvSxYtmlkMXHxRoUJYxWeRFker4Hx9dDCwPJqLEoCvsVBQOPG8BSDLwkO2jnv0pciW4RX5UBmDPnTlXxZfE46BE4eNVh51iGa4AZU1MjZDLKblSBeKs4XFxZfNglMT95pWaBUjGffL/gK7441bes4fkMd0LGR5n8Iuiv/TOxik//jK4pWO1qhfOzQd8QlMGeZ35h+AfGbe+dS40vSkvkL5mvdsy1LYPVi55IxK6N54+NvSsy3zRVrran16GDaGEbja6K9Txe4/DmN0WRrGLl0sCsj6Ksuosuo0vi96kl9jQoTwcDjLw9i6BCZ6yRbKw67VmvBUD8xqHvXhrVv+mmHyIS3MPD6MAOKZt/th9EkI7VUCDOn3IHdfVZVw53rd77fyCfKWe7wWaBcIuNjj8r4mdvFhGzNgJrFsfRJTEPttbqP+p3lR/bx0c+/lR6WEbteAJIkbAHgkIxdLMOeBXd4EQFOaMRGnWf93vVLxIO1zc7AUCvEsJmTkj5lt8W2i76Qw47q5Lt+QUrVp5mH/Q3MWGth+eUuo9Gsbd5pJ+7r8X7d33Myzwl5QQVwBBq/1MB3bAGTHBcWqvAbUA2Xv3zKM+mrCAucEYW
 WyloDgYf
 xWvA/CKw9lU84XTh66b46neo4Ttv/6yZmRivCDTUmvMzr3tnlaVT7t9vsoGodSxZxjZaBPU8HEeyf3974K3c5UTkfdVanxgago8dCwJhnh+Mxs5PnmYzB/F13wcGLVb+hSZfySeo/eNbQC7zPlMAbumbMUnWjwYh71121PRoLLIjRt3k7nEdMNksr/8qaF9ggvwhAalD9R4evf17wHYi2yU/2nVl9AWU4Geoboil7L7XvPWhPXATzi27Y9eT5BYhJiUyeijft8PnhCORASDWBOkzDgTRLoCuIBkfWvHXhVBZ69jSHkjeXF4qgM4M2WszEQNgzAdRHZ3X08RWmVuUe1gz2T3nyatpHlFnqTN09MoLVcyNyRw61DS5gpux99x2hPXJ5rYQ0NDvaWkQlZ09hXhC9RPRtjZyj1/7T4UOc4RjoDFWD0SQ0Re+LinToDePSnRMIRGXAHPDiM96rdyqdQZztsaQ6OxxvnTHK7Oiz7CZ6gS4TFXw6a0rSLMTFJpKwmWxyvwsrwGDS9zZlrD0FWuTx8ueRJmHuQmktd+M8lqrQovFLmUdA1IjBpENsqlsJoWcF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 22:11, Masami Hiramatsu (Google) wrote:
> On Mon, 1 Sep 2025 18:23:44 +0800
> Jinchao Wang <wangjinchao600@gmail.com> wrote:
> 
>> On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
>>> Hi Jinchao,
>>>
>> Hi Masami,
>>
>>> On Mon, 18 Aug 2025 20:26:07 +0800
>>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>>
>>>> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
>>>> of hardware breakpoint parameters without deallocating and reallocating
>>>> the breakpoint slot.
>>>>
>>>> The existing arch_install_hw_breakpoint() allocates a new debug register
>>>> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
>>>> use cases require modifying breakpoint parameters (address, length, type)
>>>> atomically without losing the allocated slot, particularly when operating
>>>> in atomic contexts where allocation might fail or be unavailable.
>>>>
>>>> This is particularly useful for debugging tools like kstackwatch that
>>>> need to dynamically update breakpoint targets in atomic contexts while
>>>> maintaining consistent hardware state.
>>>>
>>>
>>> I'm also trying to find this interface for my wprobe. So the idea is good.
>>> But this looks hacky and only for x86. I think the interface should be
>>> more generic and do not use this arch internal function directly.
>>>
>>
>> I agree with your point about the architectural dependency. I have been
>> considering this problem not only for the hardware breakpoint
>> reinstallation,
>> but also for other related parts of the series, such as canary finding and
>> stack address resolving. These parts also rely on arch-specific code.
> 
> Yes, even though, the hw-breakpoint is an independent feature.
> Directly using arch_*() functions (which are expected to be used
> internally) introduces a hidden dependency between these two
> components and looses maintainability.

Yes, I am trying to improve this in the v3 series.

> 
>>> It seems that the slot is allocated by "type", thus, if this reinstall
>>> hwbp without deallocate/allocate slot, it must NOT change the type.
>>> See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
>>> whether the architecture support that interface.
>>>
>> Regarding the slot allocation, I would like to clarify my point. I
>> believe the
>> event->attr.type should not be changed when reinstalling a hardware
>> breakpoint, as this defines the fundamental nature of the event. The type
>> must always be PERF_TYPE_BREAKPOINT.
>>
>> The event->attr.bp_type, however, can be changed. For example, from a
>> HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
>> reallocate the slot. This is useful for future applications, even though the
>> current use case for KStackWatch only requires HW_BREAKPOINT_W.
> 
> I understand your point, so it also needs another wrapper which checks
> the type is compatible on the architecture.
> 

I think the wrapper should handle the type by type_slot, something like[1]:

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 1db2c5e24d0e..6fed9521baf2 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -752,6 +752,7 @@ modify_user_hw_breakpoint_check(struct perf_event 
*bp, struct perf_event_attr *a
  {
  	struct arch_hw_breakpoint hw = { };
  	int err;
+	enum bp_type_idx old_type_idx, new_type_idx;

  	err = hw_breakpoint_parse(bp, attr, &hw);
  	if (err)
@@ -766,7 +767,9 @@ modify_user_hw_breakpoint_check(struct perf_event 
*bp, struct perf_event_attr *a
  			return -EINVAL;
  	}

-	if (bp->attr.bp_type != attr->bp_type) {
+	old_type_idx = find_slot_idx(bp->attr.bp_type);
+	new_type_idx = find_slot_idx(attr->bp_type);
+	if (old_type_idx != new_type_idx) {
  		err = modify_bp_slot(bp, bp->attr.bp_type, attr->bp_type);
  		if (err)
  			return err;

For kernel breakpoints, we might also consider introducing a
modify_kernel_hw_breakpoint() helper, similar to
modify_user_hw_breakpoint(), to encapsulate the kernel-specific case.

[1]https://lore.kernel.org/all/20250903075144.3722848-3-wangjinchao600@gmail.com/

>>
>> By the way, I have sent an updated series.
>> https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
> 
> Yeah, OK, let me review the series. Thanks for update!
> 
>>
>> Thank you again for your valuable review.
>> -- 
>> Best regards,
>> Jinchao
> 
> 


-- 
Best regards,
Jinchao

