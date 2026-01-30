Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565EBE6BF30
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 17:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732D96B0088; Fri, 30 Jan 2026 12:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E06D6B0089; Fri, 30 Jan 2026 12:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC636B008A; Fri, 30 Jan 2026 12:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0026B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:45:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7EF8C2212
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:45:18 +0000 (UTC)
X-FDA: 84389356716.06.E7DCB4E
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7877EC0010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:45:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cXT6Sa94;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769795117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XISFnwseCiWle6bCCXT0yDlbArJXGMqSLymypJCKt4=;
	b=la8vNphsTU/GQf2X03PUZX1nuaoZZ+s7QkZaqqIoY5gVfon4mgGyHS5j6VXN/MAvma3u19
	ekOVjbUM5sF6A6qeyGOm413Sp8htj/++udx8C7mxUOj+oi4c0q3uvJbyu4w0KrFQ85/BUM
	WlaEzpcJnJPAVpB3DPh5JSdE6L6z2MY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cXT6Sa94;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769795117; a=rsa-sha256;
	cv=none;
	b=h3MtI6316kALTI5uJethIyHp1RzutFduOb/ifZ+oky5pIPTIIvut2JurBexTWfRTe1+jVG
	VLmPEOaSl0Z1tc+/nZ5kguFQuHHVSDlPRWs4BOCuwfCXYB7oCBpY0K/mjhrPL0xh/NYXz7
	54OshZTerYNnX8UUgcGy+tOIrmKbkl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769795111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6XISFnwseCiWle6bCCXT0yDlbArJXGMqSLymypJCKt4=;
	b=cXT6Sa94g/FXZxZqXnTzJB2MKp403aqaQL6P12TRbhkveGjbPghqAkS7wa4Sn+VMPwjdbL
	XEkGRbr4bV7Ch01JPMLVLpOs3sknQpLOxfiaL2h7kaMnfglomgWFBTIPeRiqt7qk6sLwZo
	aXDUx8OtXV5e8AZDna/BzoJ2WkdfnIg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: JP Kobryn <inwardvessel@gmail.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Andrew Morton <akpm@linux-foundation.org>,
  bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next] mm/bpf_memcontrol: Add missing newline in
 pr_warn message
In-Reply-To: <20260129035014.3283392-1-hui.zhu@linux.dev> (Hui Zhu's message
	of "Thu, 29 Jan 2026 11:50:14 +0800")
References: <20260129035014.3283392-1-hui.zhu@linux.dev>
Date: Fri, 30 Jan 2026 09:44:53 -0800
Message-ID: <87pl6rknai.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: xt9pucaxut44cxjgpdhjafekaus5kw6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 7877EC0010
X-HE-Tag: 1769795115-393839
X-HE-Meta: U2FsdGVkX1/q5OzBMM9BlapMy7U4wMQwfuiyR9owRPJPLPmasPPVPnfq2jhtgwjadaISCMpGCMpnzOz63kIfz2B1AiAtPSu2kJC34Yz3pHvg5gmHl7YBsR40M3A4qjjTovgTn7rBBPq7W/BxfiGttU7PrAAkMKiUccztRGN+jQ8TsO39hUZ5xp6por2BWWI8tVMQdNAvaWO5zrlTQmLKoQ2DtzXe0u7NeSVgIHlvLPqWKVHO7ApdAZBqffFlcj47M4czRZjgPs13UrlUYJqUNb/cetKnhwN88cwM1qOl/RsVerJyVqp9ifhhRWiTYRYFCIQAfA+chKl5tP9FZVbDdVipdcDc1cMnCCohXLImBUwuu4pznfcliB0CYlEGyes2vP1Ji3dAiU4Wvz0xJ/oEg1J0V8BTfG7dd9epVj+TupwvastrHy/wzR31WrFBwxVFY2FFFRUvdohrultfKsHBt151iHj5bkWsb/pA0LnfGaCU3ipZwsRYOzAT0RWgaEqQWjKCvuxUaLwKW91ya547uSxm9J7P4M9B5/eDE2VV3pvY/3fn1v2lNrNcljQ2Wn/C4P3izqbGKLKhMQRTiOptBucwfwJA2qcqpznBJxo23OY806/eoiFdoKNlZdYqU58EXG5vDNPBF3kxdZaZrUzph0c4fiy9+QoyKO0FBUkTkzu0YvhtML5xfQylsgDiMPOUDXQ1HG2y4Hc7+pfyH7scpy0TNSxkzLufcibipQYqD4RxDzO1uPGwEvHfBwswQWMgCs15qi6PxQU7+CYWIzBE3Ig7th8OhhaPjNuQsFbAatWPg02kkXMs2jbR8r8q0YhBqo5jOpYStmrW9Ud3wi2xFa+V2158WgBWp7xLtU7izV1JXqoZm6nIVH/RZ644wNeSQkji41JqBH74kNBCLnRxi+AG+C8kYVV/YNmnlxGddGo6It7aozbT3jA0Rq/t/npqKMoD4QG4lqtPXfXDzDH
 v4/OJ2rp
 L47Js0DVLXcuQ/R4ynuQrHKLVs4KePKwSvPl9LNYBs8MUi96SztGqk/VnhYyVRdr/P2kFb6Sw7P6uo3f7qb2ekZaVK27zqjpRdaspuns2KmHotZ/19QYInhDhs2JwWE2zTgA/FsgGgfXFmKQ/vvm4uHef4+gFbcwjFJ3C97Yphex5YekkhXoYAqUBOZLMZg4imUqy3A463GFY+GkwnMUPXqcN62xJYA/dDVhqdzmBx9+kG3S+miyN0/NOVqNTHqt4hvRAdg/tPGOKk04=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hui Zhu <hui.zhu@linux.dev> writes:

> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Add missing newline character at the end of pr_warn error message
> in bpf_memcontrol_init() function. Kernel log messages should end
> with a newline character for proper formatting in kernel logs.
>
> This issue was pointed out in
> https://github.com/kernel-patches/bpf/pull/10864#discussion_r2735018210
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

