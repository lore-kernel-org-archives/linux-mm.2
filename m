Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2607CD778A6
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBB76B052B; Fri, 23 Jan 2026 13:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC816B052C; Fri, 23 Jan 2026 13:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF206B052D; Fri, 23 Jan 2026 13:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4B86B052B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:06:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10BECB9CD7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:06:04 +0000 (UTC)
X-FDA: 84364007448.25.7164817
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E51C1C000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:06:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1gE1yFX;
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769191562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcLGkCfuB/sIPTdRBcsJjPn4bR/XfGlb046z63lGRwk=;
	b=5M1nj41jxzkk3fkCb90Su+beFoAA0832RF8jPwXWSjt/czsltQUpkVkuo3j41ivWB6LnDa
	1Qy6L3rD1u1D21HuFDD292s/i+dHlqftv0ag3E+Cgq1RMzyMCKdCx5WXywuBzoGpX+jwWx
	O76Xgu7NfWCxdF4YEmi2/OMWHwug45k=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q1gE1yFX;
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769191562; a=rsa-sha256;
	cv=pass;
	b=eQZ9JExFd4eBhzEUHlO9oT38scnApHJjlJgnew/5vaC3nisqVvsET50/5WedcQiMeJRhs+
	TA8Bx4kQPTh4Q7QwfTQETInLagFd0I3RjYBK2Qom8Zwg3j0Ejj4GFNKQot/QxH/6vnGGqA
	h5Ax1JQ5XUzUNApz3d1xC/tzMQgLKI0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee4539adfso27007015e9.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:06:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769191560; cv=none;
        d=google.com; s=arc-20240605;
        b=cRRT5UbR1a+f8rjEe7+tPi2AZtJi6DfJXOm3CYRyQIlTv7k4Y9HZDk5FJHCrGkJkbY
         nDHkMCnBU3w9BSsAwS4L5KeTk1tRD3PSTNO/gNybD5cG+5VquQdr1P+z0rPd44qeDNfa
         HQeHYoMdFHraLmicUvB431c0SblBEeMRDmstveDIHpUPSHExgydmcyVxg3JL+uPXnTym
         aNhEUrP9l2Mle/D2Dd/mioz0z8JDc+zG4axj+bUjxRG0ybbmVOoEetuhbXcHWS+eBhfj
         JmPaBc2KHCMTFOurYvV0+XlLLWy8Btm//XcHEpoKzXiFjNLypJPjPKT+ghOxPo02qXz5
         x5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FcLGkCfuB/sIPTdRBcsJjPn4bR/XfGlb046z63lGRwk=;
        fh=g1SXi0yKWKz8lerCXJPFKeglt2rQvtZHqEHn8EPN7Tw=;
        b=LI6/wVzQWF5VpIaUZ2ldSJAo9IU7t6TCsnBDNfT8eW4fBO3C38wAlCjDD6KT7gHYqT
         3077nIjkeBE5+sPTnbpPDUJecg4YYzKRGJwYkI8CH5P6+e9Rx0pI01qoL0mxDOwAgXr+
         GRjyCMbpQFKCoXNL0iGYfU6nrEw1aMpfqMEUEbrCugHiLMxRQSGx+3f5VAbG7mom3bvw
         EnU0fFHLDPbx+3GcZHF1EXhv5Iel1fHDNFw1q6srRn7eydYBK9mgETOrzcrw7VQnlrPN
         WUEck4UWiVnY/9ICnlAeexzMBhKpoxNL5l2e3rnUTpj6/EslTmWd6P8kRlZNodrOFJxK
         qwYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769191560; x=1769796360; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FcLGkCfuB/sIPTdRBcsJjPn4bR/XfGlb046z63lGRwk=;
        b=Q1gE1yFXvB0Auwf1F6u+/keuqndfQWPPCw4PTLNx/4xLezVzlB1UuEwOym/oneUBqE
         61+3+tgX7Ws/ad6nquUDf1a43FXGfTCIr6rLgvDTKeJkrXakaEDYkevr7fUyvvq6eM/E
         RvMp9BGdu+37iVOkmg/DJ9Hdx7vw9n359kUaOAIjktvaiYWgJFT4zirI9n3Mq/0K/Kui
         ajp7djMQex8sTOpmOIcvVZyl3V83vVeSfbLB/MkEg899N9WJprvMaysMg1Roq7CZWcT4
         05qko5kSdiQNdgtemQ9goSy2dvFUuiLIciWWjy8aZm2OMZD6IRfeSvI4qxYMEJ0yiKGF
         4BjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769191560; x=1769796360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FcLGkCfuB/sIPTdRBcsJjPn4bR/XfGlb046z63lGRwk=;
        b=F2CISvfwPOZJYKW5FbzLi7Wuz4uG6yuz4SCJzx8bD0+OiKSvS2c+J890nrsS9FdpRt
         AEF4t2vd2tap5S425TKp1q576cZOruTFX4Ei8MsIrtm8OlW1S9BWKmmNQWMTOK4F0zQB
         GQN4FRLiM6Jq8PhjnXv7GaTPilHV0NQKbbxScTAl90dqQ/g8oUdLDDhP8lVD+ABwJX+f
         gla7CGBhJCR6RipJUysSxNSRmDxax891oPnHrBPnocoJtBmzRK2LYfBsP/SJaFN19Lp7
         R/OHdwJFrWTgl+Y+la1+m3V+UJKzCx9FSTHrDsO1gzYeDz6kRa0JNt+90pOxMPsXdI9F
         RkYA==
X-Forwarded-Encrypted: i=1; AJvYcCXHyy6IbItQcJFQ2ByfISOmJP6dYTcZrEHUIp+1m56+OQ3BLAZZSFzMuqJP3SUX/ydNIioqbtjkbg==@kvack.org
X-Gm-Message-State: AOJu0YyTY/PtKbbtf2CjBnv/vf0fR9FrlZRCjvbRYXk4I7SHoM0AtoUO
	ZU48ukU0BKogcw4V8My7o0MMhkBtkT9/0x8MnfNDVws/NWN0MxU6vqxlgzzBCn4NIP0WMkiGfzs
	C7vaw9PLw9Os/NwDeACDctoxLpqIkfSI=
X-Gm-Gg: AZuq6aI9PCNOm62VH/nXqWAEknJw8HjbSaUXwYE8KSi1qYmZ68K7K6U5jLEMPb2Ig2g
	XHnrzLF80JXHFtyPPf1CB3peQs+uHDeSwp/9KP73uO3k26crwjFqsBsAv0rU5cy+cfJW6nQK6qX
	rNjSZ3wyl85/+SaNbd0xk95hy/Q1DYMZeGvGHpG0fJmiOrrfV/CsSavM6TI7uvFC/X8UhcayfOg
	TqVR5uxjaV7M5xxaorEc0adXR2tofUbUK6d5vxdvz4L9Hho4CYE8aBKp2Ekk06YgnTySTUtl43P
	WOKHFPsOjqTHH4/AcY6bQC/46K+h4H+OS53s5T5nQoxYV20VD60epd1sQXXJpmvgFgh6F2NG
X-Received: by 2002:a05:600c:621a:b0:47e:e076:c7a2 with SMTP id
 5b1f17b1804b1-4804c95e12dmr71414205e9.15.1769191560210; Fri, 23 Jan 2026
 10:06:00 -0800 (PST)
MIME-Version: 1.0
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz> <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 23 Jan 2026 10:05:48 -0800
X-Gm-Features: AZwV_QjSjoenDUCyXmvsb5KH8Pd0BwP5NV53NJnMQ1RHDoaNt4mnnL7gEc0SK7E
Message-ID: <CAADnVQKW2Z62+xC5NUsx4ynqbwPh5yn_EJJrQ4kcPab6KWUK-A@mail.gmail.com>
Subject: Re: [PATCH v4 08/22] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E51C1C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 4ezntd4j4kaencrmd1t3r1k7wm46za99
X-HE-Tag: 1769191561-70440
X-HE-Meta: U2FsdGVkX1/Emq5lE2zBbmA9oJ1p2a9XJTBzoF3Eg60bg7f1MpvZXQVFE5NeJapAm9DhxcW17DElD88CObGuau1DtKET/WGWa3liEv2hfXx5c/BcCSX6ZgQR87jW4wIJK0zao9bR2hGO45+PXFN8Y4GnGDKxPLsGQM+ZPqg+Yo4ml1R0cAFVaC86xnbZJMYkToXZ3lWfrzdOne84hEVQpjf5nd6jkhjU/8EppdJLMNKVHQQfPS4oKHeXOKc37iCCkuc/JVOGAtFjyHiaYeT8+XqZLuTTgu3HSAG0lNrSAsiKC34kH2YpsM4i6LLXQ9GKVmfbUBekHQkQz/mALRxh0xIWiFqc6vVbCiTFGou6U3m6vCuKHMYitXxCHVH2gssaBGUO1n03bxI4D4HIRjj/+Swk0sITXg4oyz/sIy0ZH6o/NXeSD8wK4Be2g7DvttL2PY2LPD+QCmvi6LcjC3POopTf+hJBQmneRO3jZs45nFImqzWndGUL62IIbwzhuZ7l4jcF9fYHqncdXUDdfgGIslMgVB6YDhFoseh1cDHtdfyZw0M9LcT96mKY5RWC2uPdrQ1fXRK3AU+JwDa5CvvhYdENXpMoubsZxgGWbld1r4KjdK3yH4wyC5pBzgQK4c8QC+dVjI4HGXaW9nFjIGz9I8iKVmXj9iwa/iGLndNnG4uIjO+jDOHYHYa42da3iwNIVGaMJRhWtfhFAwTCazoK1p4ax6whwDC7Rv4AtU7WQz06hb4flreij+46wwPFpRe4kitw4o5mTYc4s6bS7IEFOAjxKWlCg52U0j82tOf/KnIH9vMre6En+eZrBRF+PcCZPDhou20yRDYiwSJ8S/XBYCl83nucWMP8nn17HpGoniMMMqli+32suHXfNHuxd/nHSDOqeFJCyUhoS4ss334gm2u7J/eipbXA92yVbZVWWorJ8JZdAyHy40JXTA5jmwEcgfK0BkUSHaXpqHcbAZ8
 YIRP34gL
 tD1zM9CU3G/5fQIqZgibZ7VMU1NR0Wkp2PkY54I2ZZEJ2uBx6AmSXnX+pVCKJDOOOFVWAshPScUyVhfruk64yGicRpUjlG5gf2mTpQyIvvWbONnZ15iB5OKKH7X14VH4dCvl0GYgJCQwmKNUjuxebxI6yzIZQfY0FGvavTazvj4tKkQ0xBNIx85z142VZXChTeTDUNS0uJk1iqHRCCIqnqixHgYoGGCKajzjgNKReYOEL08rXpAb7juDF6BmtH5PqR18e9yvqyQYOxanPR4CkthgMBVXx/fARNTtPBUMLOnqO9k4UNjj/uFRA0JnZQYL7tUBNyZM1dGmmHKZjTR7NnJzto/q0ji7BmEn/vGH8SNZXJR99/hHBkiAV6v+XgpoCpn+TP1gNY/na8PiLHnPIcVs3lnRYp86yjGi3u6Zq4xsaWYrsoq4ZoBwMc2hGdBaebAWpU2SLKpSbSQuvJTPMtfCgHQMRoDBd9mT//AFm1LbGaNWWVvksJ4AFDi2S49ATB8z0qQ+KKRFjNrPOOJ1UcUhyMrkNB1flw7RxEk2Rd6shnprlsmSZAIUnzoAkTKuY70yoLuVXAOIzHXYnCjC4hBIxE2gZ0ktUDdxQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:53=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
>
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
>
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Alexei Starovoitov <ast@kernel.org>

