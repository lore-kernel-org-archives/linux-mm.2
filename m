Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A1A606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OlfK2S7p
Received: by kanga.kvack.org (Postfix)
	id 806276B05B2; Wed, 28 Oct 2026 21:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B66F6B05B3; Wed, 28 Oct 2026 21:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4B56B05B4; Wed, 28 Oct 2026 21:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 462656B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:44:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA1131C24CE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:44:18 +0000 (UTC)
X-FDA: 85373968596.06.5BB14F6
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C18640008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:44:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OlfK2S7p;
	spf=pass (imf04.hostedemail.com: domain of 376TiagYKCCIISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=376TiagYKCCIISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793238257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
	b=ab2Rxpi7noma8TqC6q18nmE97rrQ35Y7HyYQbfwQk5XKuCEi9y8N1tvXy9q2H52fqe+C2F
	Mxiv5Z5D4Gi93NhOA58Kci9YwqbAXRNPQeevM5VYFwnWNs68/Uhtbkcg1v+eFQNK1Mw+7p
	oVUDUXNSvlZuv8cyrgTxriroU3ypaoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793238257;
	b=tr9t/BoiqzDdfuSRR2OXhP0W8ojB2g9EXeUAu43IcyuJdQd5zBaoSIgLQwqRhasf6a//Gz
	O38dNrYHrpIjR3wwYDmiJ7J817B5R78tf0iNbHuM4n4gp4usJIOQIdJahURZLTF9e71CcC
	Dw1a6E0WtGxI4CD81ITLa7QV870fF4E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OlfK2S7p;
	spf=pass (imf04.hostedemail.com: domain of 376TiagYKCCIISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=376TiagYKCCIISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so1831960a12.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793238256; x=1793843056; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
        b=OlfK2S7p+mMeMgL3khkbUvcD/R3LiR94Cx+uVZk78Uahqqus5iYdBkNDUifCgWylq6
         3vMBTLHvQNuoY/6TzOMBemI9BGJ5zmQ9G/rMADSD1bMMuhHMJausPdEfzpnh1f0ZBfP7
         IE2SnUWjkJIZFFd2N+X4a1jy2cAw3eW9/e6j1+N+koTnNoxgaJh07031AHSE6t+UzPgo
         dyu8Um6YElBO4VgIY/HNEiHIspuQ+Dt4K0cIL7LdKqsRHZwXBpjnBNcNxoFb5UpXHyIS
         UMfXnPRxnIkpdN690OXkF2QmWdVKmT/J4VajRpnYzmLyGfUyign0w1o688F4RUU4k8VT
         T+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238256; x=1793843056;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
        b=mU96u8riBlnH0SiZGb5ofYjjHiqPzHE64YOiZH0ql6C021Rpb0vOGLaPoQWF4Z86nR
         PRo+R9Iq9O8dpY4nfk0YVrxLYcP5cOUGiElCO+ibwJM8DUAbMTboyEWoCSnAMSSCU4GY
         dVWzMEm01oEy0to7+dNSYzL/qOBR5vSzVdXmpOfC+5CqrkfUgmuYIAfe/oP65g6vUHdH
         WVlPy8EKteGwN9xzTDh70ytkrkO8kfG2PsW8XfnY+2E6cYUrcBnj5eUXLDNpCz2Pg2V5
         xem5ehmAqcRFuWvcOMX+OLlW7p5jDpUHouPLEvGPEybvjGFil2ZUOyzTFhZ3txR7igX8
         cCWg==
X-Forwarded-Encrypted: i=1; AKwUvBwVO0Vvjngh0mfun+byC0NFtO9jr+aEnDxUxg2QPO2vamXdd8M9/iNcdm6VNpF5pIAV4yZ+vog7rQ==@kvack.org
X-Gm-Message-State: AFq9FYKMlZSvXxmOsw9eYtRXztOBTYfHlkLM5uTMTgpFfSlCa82BXs0N
	JcMvaNcVhnyokrF9V/vaGxtjkdO/jQtwVRVI4Y2N1spIptvL3PdpRQgU19kdXUXozUG18f7ib0O
	nytn22w==
X-Received: from pgbl4.prod.google.com ([2002:a63:5704:0:b0:cd6:14b:6a43])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:502:b0:3de:8ee8:8323
 with SMTP id adf61e73a8af0-3e902392f51mr3529188637.29.1793238255629; Wed, 28
 Oct 2026 18:44:15 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:44:14 +0000
In-Reply-To: <auKW_UkDicyxx6fQ@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <20261028185034.3607746-2-kuniyu@google.com>
 <auKW_UkDicyxx6fQ@linux.dev>
Message-ID: <auKi4o_Dsb1MMPdc@google.com>
Subject: Re: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C18640008
X-Stat-Signature: 5rntbdkywuap1ync99m6m7beyox33xyr
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793238257-879555
X-HE-Meta: U2FsdGVkX18XNPacCQLHOgMHQp0GVPjeHmDaHqDDIsDWms6QCaq1fq9WdUZW9H8Vv+/VTpLFxULdhOC5YdM2/IeikpeOYQtXuAGghpUsgl3kHyGwjR3OzIV7TILcTZUj/h6vZBdxkhnY4umCuPWchzFCXvQYYIrViCqX4uX1etEMw1WPwTk0ZMBXCaxmdp+IlHDet/zojZm455QH7B0HCXEO/cAhDaFmID4A/I/djiDTSCWCYoZ18jH7OGjfjAKw93mAcIvRNak8yN1QuCL1/JPnYvRof5QmDEBEovfkFQCUUJPDuf+TU6Ae4sinhkOSWOc4NFhVdJGo6LL11Q4A0E2bzEgLLF2K58eNGHR6LXOkkxyItJdiJMVf+aOMWDYp7v5AgvgUTWONrrMGRT/Yw5LLiQgZiVa79OkVliZzhPy4uYTgUR9Ee8WOpZIJ3uTIOjIrdLGG33aYnZWbxnA9QUAw9nobAB1klc3VF763jBjwfKujD09pjxpRG0x4+bZKGnwxTfCelfIC/GUHD9/sxa1pEBQePbsy/eGAbqdgAo42y/6ZbOHLI45LTDEgAPVsV5wonCtg0OO54w9pjm95ipYlQ8GwoaR6UNLZcuMjvVtzxjNL8iapdLZGgyZQywVeodYMjIJQ7uixwD28eUJbMd3JLA7fKm8b4I+ROZ+poHv4kasSwDW2VhGiFJ2ot0GxBvCGmnZdd6RC3W5N48HEUrB555rDhf5Uw2jIffQWW/Lv2tzNLKMp83cwskDc4Rs7ZWjlu/w3oQxjWVcz7wGKX9poDsKs/aeNqPm86U0iE1rGtcifHI+HTkorCIvVvnsAfHoiDAkc6012HbrLuOblwUB6D9f7sBGGPx2Aimnva+L4u0CGficGgxe1YChWg2YmteZoOzpeEIAnpkgEL0BxKLziqCU6ZC34nLD2lInk3QlTQyl9cltGE5AfBub56dWOkxzTJsljw6J8U2EVVHe
 xgWszbLX
 +X3RzTQ/5TGYfkVR/maHY4FH7qK4L3L6mssiTT/VFCB3ljH3NeuY0K9ymJ7nk5CnNBozchYh5+nzMTxocZ3LiIvWe+QzKtM3I0HOKyIeEgVT2YzD0BRu2RdoTDe85yqfewQXYF1L95cGygPZuIbyN2Qr/SKf8jG8VKiW97viQQDs/OtYnoehcrr6Jv2RU9wsPBXCr+jE94gJZEEDWEz+RU2yVp5PcEbMw7TMV2sQPtwpn0tCPHn3NR1C6IJym3RC3zT6S5F7mjiIFXU6EVLkXFCHZQ7Z4PZz/Qtw48q74odCD1rlOwyzPaDroH6TJfPHWSuNM4ynpq56k3yfrHpSxDG7jp6KiiWyJXGTGw4wY+ZLmHHFcpowQLRsb76jfoDwUf3XNcrxGBTPbuKSeflfaCPqAswRz/BojyUV2dD7QjFXOGvWX7VDKxmxNwsWgwoONsFmAfrUsv+iuno/F2F0GM3T+ojz11/ZlDDdQYBL5HCak9iPcQ2rIL29q+oTT2HvXSvZKNr6C49YqNQapoDwJ7k7/hAr6r4Bz86fZnFAhRdgxi03WR7eFwFnRZqfWM7sfMmNMeZ205yYVGWKY89J6lirDtRKkgxqvkYoioUjhpqL1YTGxDD216T7R0HTGmvW03ozinF+ukmQOYc+a8fSlwB4XvLZKm91AxRWdHEqDxGhwm6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 17:48:26 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:13PM +0000, Kuniyuki Iwashima wrote:
> > this_cpu_ptr(&memcg_stock) is always modified under
> > local_lock(&memcg_stock.lock).
> 
> You need to be more precise here. Mainly the cached[] and nr_pages[] are only
> modified under the local lock. There is flags field which is being modified
> without it.

Will update.

> 
> > 
> > Unlike is_memcg_drain_needed() under RCU, consume_stock(),
> > drain_stock(), and refill_stock() do not need READ_ONCE().
> > 
> > Especially, in refill_stock(), READ_ONCE() is used twice for
> > stock->cached[i], which forces the compiler to emit two volatile
> > loads from stock->cached[i].
> > 
> > Let's remove the unnecessary READ_ONCE() and eliminate the
> > redundant loads in refill_stock():
> 
> What are we gaining with that? Is this measurable?

I haven't measured, but here clang unrolled 7 loops and
each iteration had two loads, where it should be a single load.


> With READ_ONCE() at least we
> are very explicit that this field can read and modified concurrently by
> different CPUs i.e. better readability.

For me, this is rather confusing.

READ_ONCE() means this field is modified concurrently,
and WRITE_ONCE() means this field is read concurrently
(or modified if the writer is not under lock).

So the genral rule is "use READ_ONCE() in a lockless context
and WRITE_ONCE() under lock", and at least we should not use
READ_ONCE() under lock, which adds unnecessary volatile load
and implies non-existing concurrent writer.

