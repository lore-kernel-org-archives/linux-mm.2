Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D2DCCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C446B008C; Fri, 16 Oct 2026 04:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D2C6B0092; Fri, 16 Oct 2026 04:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C316B0095; Fri, 16 Oct 2026 04:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B446B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:36:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 637CE1A032C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:36:47 +0000 (UTC)
X-FDA: 85327833654.17.6B75E72
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E80D140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:36:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EFIw1vOP;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792139805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ko2nFEKzryM0Joy0DntqtRQJcRZwX6j2MQIGWblaJQ0=;
	b=xkY8egLejbG+1QKhLlvtqC+ABwRqRiBQrVWMNBgLyb1K0GClR3ZFbj+jYI4WVUg75u0AZ9
	7gV7QwwVDNChcOLkvNfcDO7ruC63cNaBW8d5H2mi8SqensaAH/vuQ/uN2y4Q4DF7uDvrQ/
	aHAj4K1TlY5GsvflKnfZeJSpjv4DYwE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792139805;
	b=cBOaJpRO5yUDBapB8fk7sIj8WsvUj0gLvxtmnPxeUO08Uz6PyjOMxgivDMCK/jx87s9uSr
	JrtCC8zZD2poSIqNK1fAvqfs3E1W0rbUyAkjtWRmlzHYnnhuIyz7N+RuzZ0Q4dLj7JBGjQ
	ZMpnthpW3RVVrY1nUdvgnx9fLDC+/vg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EFIw1vOP;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c34bff61551so861329366b.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792139804; cv=none;
        d=google.com; s=arc-20260327;
        b=LuvBUd0IbsaHTi7UEYe3NtY/TOmlVoKr3FLlNmmbshoGTKfuWN83OjHmhV3uq0LOB1
         3C2CKKEaSS5quMFbp7ZNd+bW5MxbnkuIjkiIzOL6R0TFJJUc/Xu0buIEa2siPh3UkVjC
         qxlo7RFh1EN0wMtajv4wjOAJy1HlnkCDse+cerxduRCj2Rk6e7bX9RB+Wz9BGWavltmG
         mYpm8WeN95wDotnhpyk1iQw4XmJwmYqTn+JHougyh6SvLxt0n1BCQLX8PsH2JYALlX2M
         plUS4yTo4lFurv4Zup2Nxq+l6qi5aU6SJFKocv+wUc4KpMemad6y1k/0sY6AUiqSxT0q
         xMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ko2nFEKzryM0Joy0DntqtRQJcRZwX6j2MQIGWblaJQ0=;
        fh=mKstcqRIZ2IB6Lc0gWHQlAwnyOy/0YJkw5nPAf77h88=;
        b=cX84Hninc1+37WBuzfcR4LXKP0ZFU8u72X/YvqfxjN3jUUYmrhB/rJUczUZszxiYXG
         Zf9JS3QRTudABfw5WfaMtY5CLCvdiMOKIe59I8EM7uiRgP4i84cdU2FzcYlVdx1XqBHo
         v0Gq//obqmOIrHsQiEXtau0QdcZ3BAiMAIJdeB1uGyR9yhE9f615jqzqXv5wbOzCI+Dm
         WiDxns2JuWIDzONK2old73ueHTyV4W3fn6EgmXuDRaMKc/rzV7bsTse0nKCnbtORodou
         oPSEVd0FIIUKTB+sr74gBUPfDEfuOMX62/ncVwM9hGTHVHKHs2zYgzpkOksKikDzlejO
         Fu/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792139804; x=1792744604; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ko2nFEKzryM0Joy0DntqtRQJcRZwX6j2MQIGWblaJQ0=;
        b=EFIw1vOPZaOgxaquVU743weIDRqJgXlffGJ4WvEyivMS+rDIwaX0yAReuctfKTvHGH
         Vif1YEB22zVoKyHMGhFeF5COmgr74cJ55eVhCzlF21Ek+Weh6tKiAhadPW9QxVVoPkkn
         Mg2QiA0TI7Ph/6hna5GDrkRjBKL8V5RCUXb0alSiVTT9fXDkb0yKxJG9qK+2VlxBBK7C
         AOyM3xgcLnvEf2Y5bbFu5+BS7QQl4QYfLVLF2tO0gvJEw95e2/5HjrIY6ePWbatysvnq
         u79YDm9paycWh5MKbaFIzKi9sULvH0FjQMTR4KA6Yi3ro6xo53h4QlHQWFCm+a9AQN88
         Up8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139804; x=1792744604;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ko2nFEKzryM0Joy0DntqtRQJcRZwX6j2MQIGWblaJQ0=;
        b=hVARc/lCDnCBDN9r+opPccikpZtprPo5eQ97F7O7LL1gmjempVK93bbKnbBFyCiG4S
         5CAHnYDCulPrlrYzqyZvams+pTAoQ23YxZjT9kXQW9thkqjl2gahVbWC9ULAY+27UM4E
         OrFH6fiF/W1PGduSU7CNbOboYLAUYD1vQFlDyKe/HjSW5Qm3n5F1QHNsP+MFD8vV3X1I
         qKlWWwoWEXKCKKKr8LndESLS04WwbJlz5zmVQiHuEGqx3QsoY/7U+UBblriFe7PL+TVX
         0Pzf9psADgV4JvabZX1hX8G6ZPWcoQZJyygK841tCpMG10kEZWuRKmCYLx5qaeKef3bJ
         GvOQ==
X-Forwarded-Encrypted: i=1; AKwUvByb+GxlU610roV/tnWASiVDVStc4+EMzUzaMeTvuCxpQzJ7Xq5H6Nxm3jfzG6AEW4TsjGELp7ubDw==@kvack.org
X-Gm-Message-State: AFq9FYIPCL241IkK3hy/kGeDsOD91uMQdWnsNftwap4OIdC1zz5lR8hI
	qDEjw+koyeMA1r8lnSkiMxtCZa/ydiwxmAEEOz32XaHjqZ9irzCz4qIfVnyfDuo9FgmhnnXIA7A
	i4U8MyzL5LM1IPhi8MMmB0M6fI26aejc=
X-Gm-Gg: AYBFou2Cw/1KgvG2LOCr7lvzLd/wPaQqiHsXcJJI+x/2OvPJJSL2MoQZkyCJiapoP/1
	9GhpjErqzmr22oo8Z+2yn2rwr5wrc5SblczRtZFxFohYar590hXk8MQ91dX5aWuhwHnfPuOM7mk
	GQNV+7b/P4hbd7Oi6ONz2xUMAkamuEbioQfHMVSUlLQb6epDJ3wIReyAh2mbrUXRHjlN4XAJzJ5
	FOdwuYFLlAjUqcdAHz2S5JgplgWZMo9ZcjThPH6S1KNJYwkG8f4blwTrsYn1nNas8FBxOMrhjNa
	VDdw11siS+a5pzRJr2IpA3T7UeGY2ZNUS/316mGBVUx1xKp72+dGcV+y
X-Received: by 2002:a05:6938:a082:10b0:c3e:f39b:2286 with SMTP id
 a640c23a62f3a-c3ef39b2474mr293285166b.0.1792139803822; Fri, 16 Oct 2026
 01:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20261011194902.97364-1-mathieu.desnoyers@efficios.com> <20261011194902.97364-3-mathieu.desnoyers@efficios.com>
In-Reply-To: <20261011194902.97364-3-mathieu.desnoyers@efficios.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 16 Oct 2026 16:36:31 +0800
X-Gm-Features: AclHuK999gbk47tvgPj7S_99XIxJx7kM0oNSpmR7D65tPGL3PLvLQleVMZhU9_g
Message-ID: <CAN_Opa_aBH0iP+q_GoG=2JhVaCpgu6_K5S7hPDhLQ4u1jw=jqg@mail.gmail.com>
Subject: Re: [PATCH hazptr v3 2/4] ptr_eq.h: Introduce ptr_eq() to preserve
 address dependency
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, 
	John Stultz <jstultz@google.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik <mjguzik@gmail.com>, 
	Gary Guo <gary@garyguo.net>, rcu@vger.kernel.org, linux-mm@kvack.org, 
	lkmm@lists.linux.dev, Nikita Popov <github@npopov.com>, llvm@lists.linux.dev, 
	Lian Wang <lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E80D140005
X-Rspam-User: 
X-Stat-Signature: fw1pqmjeaccyosxesypz47fioumdmbux
X-HE-Tag: 1792139805-562936
X-HE-Meta: U2FsdGVkX18hYpdyU9NaqIM5fxD25WXM/tiHPG2D5XphjFReIoSEhS1sCOTf+Km2rw/sisUORU2SeR1iY8rMhX6+GQEETMQqrtv3+dQ3tEId5tLVxlGBkL+0VZbDFoEd0YHIveW1UqYYcHla6XYGxOA0pI+V4SJl0ADElXM6D5ZtUb9Htq2g4Xs4KDPBjQ9EATzluVVIhGRg251cRrqVciJH+Jhp9IaYyQIWs1bDbD1eMjWT2UonhMl/0g3BD3cCDzhacopGiGzPmn5c+HjWsuLYJSDM5caU2AMwB45QOWV1oly0dVQSe2lMRemiZhIe4f4g6qfTRveY+buBYXYYzjtVBD8KWQps2QmVRmG86yROxt5FWRSq+TKVAKzwyDzlKs4vcX80/oSB46pJ9WhPAcQrwt21GzHfursnPKyYZ0VIgjPlg8W8Gknu0g2iZvfnci4kwtLEfd4tSrFLM5QpJvfWO+ct3ixuNa/PSYMjd6jhsuZt94pBla3D5vCbwi4WWuAhW6J/RgusUmoRdCtLsfFwr5BzpIkRAVRcwnU4xDBeumv17Am3oOvRHKLuNeAJKTn8hKWu0Ch2WPzWXQhdLGtdWFXzO54rfxFp1sGBXPMQu36tGfh5gzMMUNFeNL9ZASllqN9Eb7/Fv7GGObyx5Ie8zUUDalWpEhH5TRbXIAOhTk+VSUIXjLB8DVkD6rV9IVOuekX2oQ1L6PAeX6V4ylQsW3teHmcUu6qGoeNpN8qcQdpUmLp8oA15JYe914W5FVS21aswhk0cyI8yAI7sISs9plho2Jp1mqfcU6usdWxrcAmzGZsKyBaRep4GXFE9NOEqxMj8tkdhzsc/6F/JSxrq3ThLFiNPDUN5AshO+SWbda6O9hZaZZj73KYn1Buut9UICnPv1KBddFX21Refu1Efw+TYI+m5U24vPmojQ6wtkViBfqefQ7wLu6LJA4n6HQpHuD28u5WCwfZzbNW
 2W1kmI+D
 MWH0+xbMgpkCxQHOXeDj52d8LwUwylxCwj9efk+1Bue71GMbBeFRxyLJfuzuoeRIFMZf8IdiVMrkKK+n5Wb11HhgC4Apt71KeFUbdy2N9LXt+QPP3uoNKR7UvY7yN4RfVrF1YQxh6WF7PtsqsKpwiwOF7vDeWanT36Pe3fip5O2xwADrZEq6Vk+owUrsT10YCvj8B4f4ymMnQaipdx9zYZlBOTEMgN3TjCxnxAno7Dt4IPqpZwyrs8sIXXn6CaLkVR+A2Tth+Y/x3l/Zh5VvB+EvuKSBBbBzfFb6kjKQnHlX7QCQMiu4qB+pqwmbxgTOyArPMvqkezcNhXEz8mUVzyupRcoqtkuq1+wuZwEntZSB0F7RePImI8yDS2yx4iqnh5kBfcR8JwyGtlwiZldIF4SuiAqI/yrytgkiEGPHWlW3BJuYgymFep54dXxNAGhArL14T1FfjASVUwmGKwkR/UwBLJhqIZbHDYkLuVNNWK1vkwfWKnxRkFO8RsleRskVjDMDzCzHCW1SAavRmzrK1tlXoKxnLfocEkFmAdpXu17nOxhza+eDMlAdZ9ihNcWB97XjUwNt2nby9z4+FjIc8KRqZJ//XSVQpy/kG88BWo4nKKvKf5SZ6mF9DCLSiaTGap532jG+K9T67E0rMPfJ0J6mesUU96bKhMGrYNzdK3cuJDQ89DFv+Mxh6zACJC73p8xlp0eBNoSOrdlWdEpP96jv/XNCa3cji2bClvzKRvumev95VjxfrTemgMa5HzjVB9rdTNcRgPNqdnBhieh+hYQrELph+34TTXJhX5JQeYF9V6gZ49zuQbjSCKpfT+RMBFOyaeAxk9uVIg5xM4omy8RdZp6J2UlQSbvL2osHJsEi6eq+kyuWd/IO7HMvd1NcFqDIjj8R59eJVVGWKsert7I+aGvMNEkkPMdhHqRtIPT9tSuJqGkavY3QflrljZqMOI9TPMaHjTPfPP+dQQyrbVE4ogbKf
 vSiUqT1Q
 fAt/qb+rljQv8XfT6DlJHdRCepsUXubdVuUiPQufJqt/IJ73GXQVNiFl3ElmJm+2gzZeTWg3kmIgdMRehYLfeMkRquptwHEeK7MZ/bY11r3jVhEk0D642nb4CyUhcrxbLsl6AUddgwAB7H7FT4Px9dH4vMQpqyzMdEu9KLtrrzMICQDa2d2bLJdOxgxlhnEOVwozhZovvPhSB010eeelVGALlD0QMZViFS13Tvrap3j3RA26gZak9x/dNh6ckd/92t3UYwfdk6YDRnpMwJhhz4pdCF9N0IibMyQkQ/gwsWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

I checked both implementations of ptr_eq().

The x86 version uses inline asm for the comparison, so
the compiler cannot reason about it as an ordinary C
pointer comparison.

The generic version uses OPTIMIZER_HIDE_VAR() before
the comparison to prevent the compiler from propagating
the original pointer values through it. I verified this
with GCC 13.3 on ARM64: the generated code uses the
second load's result for the dependent access, rather
than reusing the first load's result.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

On Mon, Oct 12, 2026 at 3:49=E2=80=AFAM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Compiler CSE and SSA GVN optimizations can cause the address dependency
> of addresses returned by rcu_dereference to be lost when comparing those
> pointers with either constants or previously loaded pointers.
>
> Introduce ptr_eq() to compare two addresses while preserving the address
> dependencies for later use of the address. It should be used when
> comparing an address returned by rcu_dereference().
>
> This is needed to prevent the compiler CSE and SSA GVN optimizations
> from using @a (or @b) in places where the source refers to @b (or @a)
> based on the fact that after the comparison, the two are known to be
> equal, which does not preserve address dependencies and allows the
> following misordering speculations:
>
> - If @b is a constant, the compiler can issue the loads which depend
>   on @a before loading @a.
> - If @b is a register populated by a prior load, weakly-ordered
>   CPUs can speculate loads which depend on @a before loading @a.
>
> The same logic applies with @a and @b swapped.
>
> The header "linux/ptr_eq.h" is the expected include target. It
> contains the documentation of the ptr_eq() API.
>
> An architecture specific implementation of the pointer comparison
> can be implemented by each architecture as asm/ptr_eq.h. The x86
> implementation is provided initially. If no implementation header is
> present for the architecture, an arch-agnostic fallback based on
> OPTIMIZER_HIDE_VAR is included from asm-generic.
>
> The arguments to ptr_eq() are const volatile to take advantage of
> implicit conversion that adds cv-qualifiers, which are thus added
> implicitly.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: John Stultz <jstultz@google.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Zqiang <qiang.zhang1211@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: maged.michael@gmail.com
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: rcu@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: lkmm@lists.linux.dev
> Cc: Nikita Popov <github@npopov.com>
> Cc: llvm@lists.linux.dev
> Cc: Lian Wang <lianux.mm@gmail.com>
> Cc: Kunwu Chan <kunwu.chan@gmail.com>
> ---
> Changes since v2:
> - Rename ptreq.h to ptr_eq.h (x86, asm-generic and linux headers).
>   Adapt the include guards accordingly.
>
> Changes since v1:
> - Move to linux/ptreq.h, implement x86-specific comparison
>   and asm-generic header (fallback).
>
> Changes since v0:
> - Include feedback from Alan Stern.
> ---
>  arch/x86/include/asm/ptr_eq.h | 16 +++++++++
>  include/asm-generic/Kbuild    |  1 +
>  include/asm-generic/ptr_eq.h  | 16 +++++++++
>  include/linux/ptr_eq.h        | 63 +++++++++++++++++++++++++++++++++++
>  4 files changed, 96 insertions(+)
>  create mode 100644 arch/x86/include/asm/ptr_eq.h
>  create mode 100644 include/asm-generic/ptr_eq.h
>  create mode 100644 include/linux/ptr_eq.h
>
> diff --git a/arch/x86/include/asm/ptr_eq.h b/arch/x86/include/asm/ptr_eq.=
h
> new file mode 100644
> index 000000000000..8e521cabe24b
> --- /dev/null
> +++ b/arch/x86/include/asm/ptr_eq.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_PTR_EQ_H
> +#define _ASM_X86_PTR_EQ_H
> +
> +#include <linux/types.h>
> +#include <asm/asm.h>
> +
> +static __always_inline
> +bool ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +       bool ret;
> +       asm(__ASM_SIZE(cmp) " %1,%2" : "=3D@ccz" (ret) : "r" (a), "r" (b)=
);
> +       return ret;
> +}
> +
> +#endif /* _ASM_X86_PTR_EQ_H */
> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> index 2bc00c67dc54..86cee0dfd47f 100644
> --- a/include/asm-generic/Kbuild
> +++ b/include/asm-generic/Kbuild
> @@ -47,6 +47,7 @@ mandatory-y +=3D percpu.h
>  mandatory-y +=3D percpu_types.h
>  mandatory-y +=3D pgalloc.h
>  mandatory-y +=3D preempt.h
> +mandatory-y +=3D ptr_eq.h
>  mandatory-y +=3D rqspinlock.h
>  mandatory-y +=3D runtime-const.h
>  mandatory-y +=3D rwonce.h
> diff --git a/include/asm-generic/ptr_eq.h b/include/asm-generic/ptr_eq.h
> new file mode 100644
> index 000000000000..2bd1c3b8a56f
> --- /dev/null
> +++ b/include/asm-generic/ptr_eq.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_GENERIC_PTR_EQ_H
> +#define __ASM_GENERIC_PTR_EQ_H
> +
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +
> +static __always_inline
> +bool ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +       OPTIMIZER_HIDE_VAR(a);
> +       OPTIMIZER_HIDE_VAR(b);
> +       return a =3D=3D b;
> +}
> +
> +#endif /* __ASM_GENERIC_PTR_EQ_H */
> diff --git a/include/linux/ptr_eq.h b/include/linux/ptr_eq.h
> new file mode 100644
> index 000000000000..7a2bbf6e64b3
> --- /dev/null
> +++ b/include/linux/ptr_eq.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PTR_EQ_H
> +#define _LINUX_PTR_EQ_H
> +
> +/*
> + * Compare two addresses while preserving the address dependencies for
> + * later use of the address. It should be used when comparing an address
> + * returned by rcu_dereference().
> + *
> + * This is needed to prevent the compiler CSE and SSA GVN optimizations
> + * from using @a (or @b) in places where the source refers to @b (or @a)
> + * based on the fact that after the comparison, the two are known to be
> + * equal, which does not preserve address dependencies and allows the
> + * following misordering speculations:
> + *
> + * - If @b is a constant, the compiler can issue the loads which depend
> + *   on @a before loading @a.
> + * - If @b is a register populated by a prior load, weakly-ordered
> + *   CPUs can speculate loads which depend on @a before loading @a.
> + *
> + * The same logic applies with @a and @b swapped.
> + *
> + * Return value: true if pointers are equal, false otherwise.
> + *
> + * The compiler barrier() is ineffective at fixing this issue. It does
> + * not prevent the compiler CSE from losing the address dependency:
> + *
> + * int fct_2_volatile_barriers(void)
> + * {
> + *     int *a, *b;
> + *
> + *     do {
> + *         a =3D READ_ONCE(p);
> + *         asm volatile ("" : : : "memory");
> + *         b =3D READ_ONCE(p);
> + *     } while (a !=3D b);
> + *     asm volatile ("" : : : "memory");  <-- barrier()
> + *     return *b;
> + * }
> + *
> + * With gcc 14.2 (arm64):
> + *
> + * fct_2_volatile_barriers:
> + *         adrp    x0, .LANCHOR0
> + *         add     x0, x0, :lo12:.LANCHOR0
> + * .L2:
> + *         ldr     x1, [x0]  <-- x1 populated by first load.
> + *         ldr     x2, [x0]
> + *         cmp     x1, x2
> + *         bne     .L2
> + *         ldr     w0, [x1]  <-- x1 is used for access which should depe=
nd on b.
> + *         ret
> + *
> + * On weakly-ordered architectures, this lets CPU speculation use the
> + * result from the first load to speculate "ldr w0, [x1]" before
> + * "ldr x2, [x0]".
> + * Based on the RCU documentation, the control dependency does not
> + * prevent the CPU from speculating loads.
> + */
> +
> +#include <asm/ptr_eq.h>
> +
> +#endif /* _LINUX_PTR_EQ_H */
> --
> 2.43.0
>

