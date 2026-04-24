Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9D4FDEE56
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AA96B0088; Thu, 23 Apr 2026 22:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB506B008A; Thu, 23 Apr 2026 22:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9085F6B008C; Thu, 23 Apr 2026 22:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8327E6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:16:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AFBD1C0C1B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:16:11 +0000 (UTC)
X-FDA: 84691834542.08.4594170
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98435180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:16:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wH9fOxRu;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776996969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dlxddP1P9He+AYlEf35eXxMUf+eEDoqi9U/ypnXl5w=;
	b=hi8gRJIz6iDf2KMDC49vuBqFx+QAOE3i4h1ZSZHH1i02dVBMhZkTuWH5QgO/PPxSn7QHAq
	o1y4/j+zeaDZ2nNHWxh7mtKuIvW6sYmlNi9HtkE0JZJ0WCt5PQpwxjYn7ircwn1hD7wkD9
	D0gHbrDr4K5nnEW63w2EyOoT1XNujU8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wH9fOxRu;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776996969; a=rsa-sha256;
	cv=none;
	b=n4VwmbmRmC43W9Kmzw/aJ6OVIQbOuGd4BohlJsHUveHBNWUCCBaROLthPbprR8ZZcV1fe5
	sAX9nDaeeygUu/gUIZOhu9fSL9khzFUe2WRMVdaTIFqBdGAKOW+wiHDJACBJHLLyzvqEVH
	WoITE6GyYEKgnqmW98DmKcXvzIXAE8o=
Date: Thu, 23 Apr 2026 19:15:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776996966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3dlxddP1P9He+AYlEf35eXxMUf+eEDoqi9U/ypnXl5w=;
	b=wH9fOxRuWf451/O8ybKiEaL2t5dS/lLC/mg65WFbJDBPxLQD92sK8Nr9NGZLzpTk7oHtih
	l4FDnlBfQA4xowe0r9Bo91650RHYbhyxtcvZy9ZuVGENxUu3fdBCw//xCi1xjnvozoSZDw
	fdbzLU3s1mCC29shJLsEisFjsHGOlqU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SUVONOV BUNYOD <b.suvonov@sjtu.edu.cn>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, david@kernel.org, mhocko@kernel.org, 
	zhengqi arch <zhengqi.arch@bytedance.com>, ljs@kernel.org, 
	mathieu desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: add balance_pgdat begin/end tracepoints
Message-ID: <aerSNntuPLdGWts6@linux.dev>
References: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
 <aepavbLy7H3odp6p@linux.dev>
 <1868971658.1970916.1776991584726.JavaMail.zimbra@sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1868971658.1970916.1776991584726.JavaMail.zimbra@sjtu.edu.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98435180003
X-Stat-Signature: rwmx5pjof5fm6dio16j6ejwyw4h9xj1z
X-Rspam-User: 
X-HE-Tag: 1776996969-281924
X-HE-Meta: U2FsdGVkX18iVNPyOpufxenk4TnbdceICzKIB7ZMwWYaJfU+oEw+4VZDTLl38fWFdIq6vCWtkWWFIheORNl4oO4ECQmZ0qn5Hfkf0A0R3dBGLa21RaY1cl1lwAh/rtteRGgoEqU45u5aZG03MHX9cYVq3pVZLi23OCXfk3GaN1qrEuoC0VrZPoxUdCeAuA8hOTf7bLVEkjLAj2/YuUBBjn7Gd/tdFpFNTPQW0q8YEIqh4OhaiYj2VdB+rqr/dYgsePvBJpeO/0qVl8Jo7byC3oGKPlEtaGVcGBrnQxtG3oeWbkq8AAT4s1nz+qPtcKf05GUsmngVwGepe/rKUS29+g17gUl58jIRtrn1JOK3ouHEm2sbse4Qfi4RMMR+oXi+lGAvU8edHNPujkR8Sw6uPVBJr8QaIBBFNrvRCSzK4fuosyjAfIF8EcYjKgtfKrcrIwMs4xiolNUlwsgyax4/5mLs0//E0OcbQTgT7omVV9sweFfQm8EafqClO6/YdcuC6oYCybHKgPZ/yFtMZ7Co1nN8cTPjr/89q3x0fnZ9Q0bk20Boh2XRmi7Kckk0BgYXwwwVAXRKPObq7fU/nJT+jxPB7TR7cHf44bKJ9rq3H84wJQOLITmqkfMK/fjwfiNsNs5sMiUnx/4muC7XUHXvAIMXx9cVP4z5QIU0yi7uHvJvXtueTHQiX++C48LxJWsDi/g/g5VdhGwdFr0Y7Fl3fvZqeFFZYgTOXGCkJtIWeIL2NUHO+BWd5wSHjZF4dH+cJ5/FDo6kTbo9eAozRjDXUvahhYOfu5iZ5OWDYDql+fHJ8+TJuW2yYN5d23+A/9IVGdX0wol9T/bdaf2utowMqnWETsL5SaHdvDJDlT+I/Du1dWr9eJdXozsloSz5vUmcbt1wujwHSb4XMzs/sKVrz9NgxCmfV577W7fDV0D7LiYn/rt0eTBfnIZozHYdO1ZR/Fo+10BE1+d1/XuJxF5
 MkE65vHy
 A53P6hC6nv4DZWi/nwvXJgY5nkKYuqfitALSEkwDL6eo3H2pKnji/U14NGje4dTh9V5au5lm5XoUuxKv7CDyHwX9cPrTVz+w87MZOW8/FwPU2dZj2oeXEl1VLik828Y0M2TOLG112LfL5lyjqh4DuWVXwCI6f79kXXvRD4KiRXpn59V6LlNAPpsz1zeDOOVO6MVq3dl2UnSGqSCPd9JpTLwL1QGZhV/+p6FAVX5OOGt0/cg56RMbTTJwSsz3BR1y/p6bw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:46:24AM +0800, SUVONOV BUNYOD wrote:
> Thank you for reviewing Shakeel,
> 
> > Do we need to trace highest_zoneidx at the end? Can it change within
> > balance_pgdat()?
> 
> highest_zoneidx does not change within a balance_pgdat() invocation. It
> is passed in as an argument and remains the classzone bound used for the
> balancing checks throughout the function.
> 
> I kept highest_zoneidx in the end tracepoint to make the outcome event
> self-contained. In principle, begin/end correlation is possible, but
> under sustained memory pressure kswapd reclaim can be frequent enough
> that consumers may prefer to analyze end events directly, and any
> dependence on matching begin/end becomes less convenient and less robust
> in the presence of filtering or dropped trace records.
> 
> Since nr_reclaimed and the final order are only known at the end, having
> highest_zoneidx there allows end-only analysis without correlating with
> the begin event.
> 
> For example, it lets users answer questions like:
> - this pass reclaimed too much or too little memory; what highest_zoneidx
> did that result correspond to?
> - how much reclaim was done when balancing up to ZONE_NORMAL vs other
> classzone bounds?
> - when highest_zoneidx == ZONE_NORMAL, how often did reclaim finish at
> order=0?
> 
> So it is there because it provides context for the end-of-reclaim result.
> Do you think this is sufficient justification? If not, then I can drop it
> from the end tracepoint in v2.

I think it is ok but let's add this reasoning in the commit message.


