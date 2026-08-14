Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D7BC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC41B6B0678; Fri, 14 Aug 2026 06:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54E26B0679; Fri, 14 Aug 2026 06:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C696B067A; Fri, 14 Aug 2026 06:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82A326B0678
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:20:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E76CC1403F1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:20:00 +0000 (UTC)
X-FDA: 85099479360.17.61B9D29
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B14F1C0007
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:19:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4zGtVov0;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=19Bgy5OB;
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786702799;
	b=5aGmMJmvyRcguNI8BpW0DEEcSuSTnoENo3/ED/L4+iOV5H/+6eYG0rfudYMBVw5LYQV68K
	Mj5rjFoy/kdpB/YENTtXpt+JdMgH77aH6TouY0TvS+7UCv52CsoOba1ckwD+157BUoKm+Z
	r1t0FMHp0dUxxU0GPlLoV10oY4Tx+uM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4zGtVov0;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=19Bgy5OB;
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786702799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvtHqPooEuc/u7TjEr4XPu0LgsQ69YSnRmaEaxRUhws=;
	b=l2pH1sfk/ldmDKVWvcBPAzGxV4UvXjpkRQjcIlYh5hVl1NF5rKj3GBDWA4JNcsxo0FM8O8
	+ZegH1S5e4/23Tz0nTP2V/1nXgEus96anA2x3PlEE4P7kNomoFwQWOeQIcbKdsfAKpK/mu
	uIIwN4B+pqx42rIe4lSNoUQHkQPWT9k=
Date: Fri, 14 Aug 2026 12:19:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1786702796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XvtHqPooEuc/u7TjEr4XPu0LgsQ69YSnRmaEaxRUhws=;
	b=4zGtVov0LQYLDLxfPoU3VoETSJMCEQlPbBniPq2iErscr4pC44YBWsO9o9bjA4VRACCPyF
	SrOTrRFvg/cFOt7VmOa+pJ2nSGORtlNE3+gHtxs+xuS14M2FN8oEfWFUWIYa9v9Tv13uOg
	kyubTDRQu/gGq2Arlm1hPGf34TiR6jVbk7inuIeuFvlTlIAyPhtUdnzg3rD6uuwuArN6hF
	T9Z1DvOq5hb+s+9EsHOkIY211O2qGJOcrrmtyi2BZuL23D8r8PP3Pg6zJ64JE9ioTDqtZ6
	JSO4wH/TkvlnmG4hKVMfF/qKh86CcWb1vyi3wclhcvTbxbz6DEyyuBo/eLO78w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1786702796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XvtHqPooEuc/u7TjEr4XPu0LgsQ69YSnRmaEaxRUhws=;
	b=19Bgy5OBnx6HmGT2MiHKetc7EBCR3TivFBCVAI7MTWGOa8FBFegr1mnBG2xcYt7BGV1IzN
	sLy8fR1eiIUuuDAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	minchan@kernel.org, ryncsn@gmail.com, yosry.ahmed@linux.dev,
	surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <20260814101955.71AgFNAt@linutronix.de>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com>
 <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
 <anMPLgbrf7XMC7Qw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <anMPLgbrf7XMC7Qw@google.com>
X-Rspamd-Queue-Id: 1B14F1C0007
X-Rspam-User: 
X-Stat-Signature: zaqjfqjr9ka8778qrfmjeam11du9fhsb
X-Rspamd-Server: rspam06
X-HE-Tag: 1786702798-567078
X-HE-Meta: U2FsdGVkX18hsLrlfvn31mBilC0PZWHTWqgOmaSL15DOk7gvV1ysDNp5fQw+Sfj9e+51UH2RDglmYQiz1IIHTIM4P3WKUPl7B2B65mLrhMm3dDyyEWfjOWb2vNB+oNLaEpF1xRNFyN/O2hbW8jGzx9YpWIlAnUTrMdKYas4GiSMn//umZi2vINZkCBKayaIZGXl+oNwfFtYM4XMCPly5x3b+0cKQE8VRIgh9aTfi13rYicgAkrNIkWxwaiKozbyQQvfrryB53BmKrFdDbnoajZaae5Kf39PrWEg9CSiEqTMgHprZgBXDs6TUVg6npDeSvI+RO56XrFuHW/9Oz56s58CouTV393Hq3lP8BvXfOu7MK9OFgHEhJdqU+rDYTouh5zLx5jiUVgY/IcXG8zmKaD0IciPzPAPSa7L1FMjT+kQHLGNyI/8WaFHP3QHqh0CgvcUF4yGMhg5p85YhEgtobcXzCEMt/DbETN2N1yVrMQmgAwsmTi/VaSZdrqYdHHWs0a/XskENriajAR56f24MsNZ53Sv9IJ0fSpdpM2Qtv3XKydD3Gal/xf8Oj0l5QAk5jwVOt4fsXSPoAG2PVXqhhwSrKrR8YW0F+90QSuvQ4asBy+zHCyXSvwy7hAkGunGxYW7wW8bzsoiYnsveiRUsGLMNDmA49Dkfhwz/iaLVyTRcQQqcAqtBdtDoyU6kEYZo3cOVNZytkN43HM7KQt/qUEugXtj9++YzuRKfyw5+R2RgthYce0/xDzRnKGxc8q48yD1YrO+DP79g6tYDhqBsGI8DaQXXqlhUpuDyaS6qtziHazogrSEPtpX0mxrVjsTlZhTtKCO5V8ORR7bJiU8X3t2HTXgZdULtI10nLEQXodIbPw0U0b5MPxTSDtEMHMRAf5hSQ5HPcM1h758POrySMFR4HQvnGhow9/gDAuJ7aIjHrU9X6ZK1xqmEHcRr6CJm4g7gIGWCsh12m69eySJ
 +16WzMiX
 aQRzXTSMbR2ekmBCUsu1KYVrUV4cmxee0mvSA7Ez78T7tS9yRsNXLSnfkZtgp0kpeg3UrnlEAmvZQ4SGy2cIcFZW/AJkIhv87REKlg8lx5XUgHn9t+HnVh1Dxj7fdrZT/qN+3XbKvN7fBxX6NRd/hCzZEoaDZ4s6OvdHlhhNSIxBLTs4oGJ12+oawDjDuMielOnlmdwOqvoyboRQHlzekhBEiNehz+5XKGRJgTL57O/giIlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-05 19:25:23 [+0900], Sergey Senozhatsky wrote:
> Hi Barry,
> 
> On (26/08/05 15:50), Barry Song wrote:
> > BTW, I wonder if compression and decompression could use separate
> > mutexes. That way, a sleepable zs_malloc() in the compression path
> > would not block decompression, which is the more latency-sensitive
> > operation.
> 
> quick and dirty patch.  Just curious if this improves anything on your
> side.
> 
> We also maybe can have more that num_online_cpus() stream, if we
> switch to idle streams list instead [1]
> 
> [1] https://lore.kernel.org/lkml/20250130111105.2861324-3-senozhatsky@chromium.org/

After reading this thread, I got to say that this looks quite nice
compared to the other two ;)

Sebastian

