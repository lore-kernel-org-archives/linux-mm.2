Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EE0C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D21A6B008C; Mon, 24 Aug 2026 11:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AADE6B0096; Mon, 24 Aug 2026 11:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28E26B009D; Mon, 24 Aug 2026 11:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D61316B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:24:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D27F1160184
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:24:07 +0000 (UTC)
X-FDA: 85136533734.25.E03893A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 435EE40006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:24:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DJGSGg/b";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcw1FaqpqN1fC2wyOxEQI80FG3a+BD9XUeXDJIlvzec=;
	b=sWtR2bz+9XM43rAawZQhZ9Bv91M9nc7AvraxkdlD6pxy9Az7VCYUu0TDvaWJRao1rppJqQ
	FEAdZJO+W4gj879RV4WeHtnWnXgOhsKP/+5raM3vdNqCYOZFzYkQHwrr6xFH7j6VHzbTQ/
	iMtnXtMLPws0OYNr7+O3Ob3PvpetnxY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DJGSGg/b";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585046;
	b=f8wG02b7SInAIGolUJDvJ8saRLEideuxqhYbM8rPjNlSJplzeeL1xEnJ45hd72bl/NTZdR
	MtfF9hJINz+mhweiPtuSZNLGhXm3saSgOxblUrgcHJzNitjPBGHMB1vFMYVsOTx0Gi5KQc
	Qpfzsa6+WGqM+lymBfb1vZskXy3Tkjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A814660120;
	Mon, 24 Aug 2026 15:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257291F000E9;
	Mon, 24 Aug 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787585045;
	bh=mcw1FaqpqN1fC2wyOxEQI80FG3a+BD9XUeXDJIlvzec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJGSGg/bjUAW6H+yCzR0IePkcLMVg6lpFFuJzo46rAW9B3BtEaYUULCpInzdAqUWe
	 vcaRx1Jx/UhRpu0qLAKSgT9KAXEfeHIYrGC3WJnOuIh0A/TMlfm8IX60QgW5rBZ5Ty
	 z9KkznHNyo2VPQefi824jviu+tkLIvtkx4cP9AVQo3KjdBGZuWvSxrRT/HYTOmcr6I
	 i/nvI+3bJlAFq7uflyCBPdUTUwprHSmujalKrwNengBMSmDtqO+FrvFDTJvP3W/RUC
	 MKGbfsbxI/S0F52UNWpLbSvgbh6CsplJAXRLexTykf7z9DvVxUimeLEHFzko/qLNE+
	 d6LlExTi11C6w==
Date: Mon, 24 Aug 2026 16:23:57 +0100
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
Message-ID: <aoxhUy6198VLCryN@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
 <aow0Z6mrG2esKpRZ@thinkstation>
 <e1c8c6f5-1b5a-4cad-a52a-f7eff00997c3@kernel.org>
 <aow6J1i2G7U0spjH@thinkstation>
 <aoxPzKTVRmZgmBKg@gremlin>
 <aoxe92BxF-5xaScD@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxe92BxF-5xaScD@thinkstation>
X-Stat-Signature: ogtr4bguqtdxnt19g1izdn8qrodwbbmh
X-Rspamd-Queue-Id: 435EE40006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787585046-126709
X-HE-Meta: U2FsdGVkX18rUVB7qTo2i08N9pk9kuiOBSCoE6GmuPo61jJQ2nVWN8yPHpqC83gzBl4LK2L3bwIDhxzfTsrsdce3w0SFNmm+IOv3SxpEHpwkRaymSSzR95v/YlvbPekhI6t78A1ULzBVflrtHD2t7KX6zWqvDZ0rHWZNAfSKvT9s3Gx0oIlrQJAnucQjZNoI0AbKTF5Y3K/FuZ4t0fzLU15wNlrNo7cypROyHPoTCULzUL34+sKXHaQIQteLDi9kuWVTVD5KhqYAS6J4a4b/ZJnLJFC7lEtMK5ATn+Y4KPc3t7oNzlf4VuztcBi0eo2KZgnvAXuDjHE3pWo4Q9WizDG9vTyjfm+cZ5oT9jqToJBo50+xssrjWmnjXi4KXVCzCiEBWq6iH3NPZ5VFFQ9YK59y3GBE9hcLHHKt7jqb8Wo2lO7E3zYKV8LueR3Pf+6smLku2DUbHQEBg0qI0dNTp1uambWWkHAng8v7f+dOjqPUgPzd3YETPx0DIElh+yH7s5IOHtRZvvr2VY6RDjKMcj/wPOYpF1STtLSTnLmQLLOW0Br9wCqgcMbypc2HD4+prhdBizUsmm0RfCweEhgt32Bf0LcHWAjFAG3HbcAftCmTTnAvTmpRJHMvLTaQPOJ5kQJ3MdHH3NoygFIorqoBrbS2V4ogd1uv2ALwd/3VzSA2ZN46DJGZmUapZWw+rtJ0EFfwDVmBesSZ3MAcciLKbGOeoERi62aV/1x/6fMscYcXVLEpy0XrjAr6MLzc/+S7bHLzpqvvKmdI4Tvr28l0nqvd/QnAi7hRiyKmSG58BI6MaVVE18iB95zyRokBaV9mrAr1SY+IZKKELMcRuGfEKvWXsL5YOfaqBSYUF3/Td9S/QHXH9idtZTkIdEI3Z26OGZSkyMqNO8+tECHvc4ZzH8hvMdpUHF6zdBG/j141hEsrIfx2BcG7u4B3WiZ89xAgUw4EDOQgCFDaBH8Dwvc
 fcaDdMKt
 +wv6l8yUhhYDw/5MELQKNtgCIoefqucdUg5q12b/Vm6GZHpJcH6NbYsi8Oi2SSf6TKav/54mrJLwWtFDdeWU0aLO6+I+3HdzswnFS7x0L+VzrTJiIIHzw5JT+0F5druTBJ8JSHYQN2AIBwjZSctVzgTXW7L0tB/DoUm6cgzWPbfV1EhqBB3VDiw7J2BNFIbV93io+WvKeDBHK6Csc3X+AH3lHLoKiK8oo+64uuVnpzbC7Xm3EIAnnsSLERvJSxR1qMZt6Lo06/PK3wcVq8SZxLzE+3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:18:09PM +0100, Kiryl Shutsemau wrote:
> > Even this reads as AI-generated... Consider writing the replies yourself
> > please.
>
> Seriously? This is border-line insult.

Sorry that wasn't intended as personal. Text is a bad medium.

What I meant to say is I agree with David re: the use of LLMs in replies, it's
not helpful in that it leads to the usual issue of very large blocks of texts
that are difficult to parse.

So put in a clearer way - I meant to say that writing them yourself would avoid
this issue.

My experience is that the series as a whole is overwhelming to review in its
current form, and adding more material to get through this way makes it more
difficult.

Hopefully this clears up what I was trying to say... :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

