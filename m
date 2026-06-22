Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEF8CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA506B0093; Mon, 22 Jun 2026 18:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181DF6B0095; Mon, 22 Jun 2026 18:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098046B0096; Mon, 22 Jun 2026 18:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2D736B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:59:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B6531A033A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:59:08 +0000 (UTC)
X-FDA: 84909065976.21.00734C9
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7874D1A0008
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:59:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y2iJiDW5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3OL45agkKCPMoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3OL45agkKCPMoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782169146;
	b=jsSlV9HlpNl1081D2gQaBZFEfmr9k4LaOPKNYAa+rhOsBR0g73RERFOQSIYfJgN71hqlVZ
	9KZQ6OfgrCY+TMheQecPLvlJ15T8H2kxdvzXSBn5pf9uo9QcP8MpCHt9AkxyEcZD1096uq
	qXwjLAMIKkvwt6tNDmv9UHtz6eoPKqA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AB8TF/nTTwkjJ2DauD9OsPoaeTkyxV0ScT5eapW1Gw0=;
	b=Zt/2WdfMxdumO7YzowrBPq8ZjaiqGnh1TtTsHQvIWIxqtlUmgy/DYqedMLWlT3jMIETPEV
	ZqWMuFj9m4app6d+zIXw0yuyHOnkLntCwpVZvxn4Do/EjT9XeyJYMcPCIN1+Q7E4M1Zr2p
	/jxM2jTmezzb00M7XXV10Sp6ysRqTOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y2iJiDW5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3OL45agkKCPMoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3OL45agkKCPMoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-697bd22237dso1308874a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169145; x=1782773945; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AB8TF/nTTwkjJ2DauD9OsPoaeTkyxV0ScT5eapW1Gw0=;
        b=Y2iJiDW55XMAc9BIRlvuTMeoOLaOvhQj7SO8zdLEboL9MgpMQgn3WtXFVOzZlfl3sl
         VpwQlXXyKlRv1jVT8oxfjKisbhKfDE4prxnUA+pCR2LzLKm/IEAh2Lq2wN//v1GSbxfU
         QhHYxF9ATDnCk/srNIXRRDrb2pyjOAQZz0rctFtJ73K2l829EzW7JCJQmUhnamTLnxCV
         9jlr9Q38fkP8H0nZSFW8avKs6XfkoToiGQy30tXberp/mgb9FSVNRJGV9+xHUXRAhniN
         BZCCxx9ALorOmNZF7FV9A1pdqPpz7Jl77hUOdzr6/3PhAhqsPE/gs6alwnc2tHTdAPld
         oRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169145; x=1782773945;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AB8TF/nTTwkjJ2DauD9OsPoaeTkyxV0ScT5eapW1Gw0=;
        b=KEUMUkKYpH58bSLNMsVTFhpSox592dSZZXqH/GfxEm75ehk5zRPzSXqi2jWYdGB7YH
         UFb8qkNPhbMJ/ualSXAOcfQWYCwlHAn6rWQjRfXExRak6LyFFIRH/7L+JlBfBu9asNqS
         fEyzUfE3bySwy13x5/XSl+Ng8moFe0WtAVvCeEpDEMZT4Kgn7/dCF+Z8aqx/AYUvAH4X
         u7c0RAsxmTWidszAL4LX3T0B2XyPX9cepj/eLDqrwSMjslLX5/2kwNGGqYrN6hDPe5+L
         6S/BaQh3Uo5rJnRbNeRpX/zpa7gD6vMfx3opdbruAQfAqngReCjraup3y7rxtYanqnBO
         fWGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/nWiVOvaL629T/B81xK4ynfmnY0V6LWX8r0djlhCuG2mFSuBpdpoID0KTFY3HindhtCjT/pSYYCg==@kvack.org
X-Gm-Message-State: AOJu0YzkSC+BmrTiC7ZmgQFQfJsajSpKahJ9bWvu6x4PslcbMpvzQN/4
	g70r0IiKd6DzNtKLmj2Wqv6B7KGAGvNH49j+egabv1l4IwOTqOaoUx8HvR3ks/CqsX05Rr7kWv7
	ztPTNi6MWF5JqMth1lg==
X-Received: from edud24.prod.google.com ([2002:a05:6402:18:b0:696:7fdb:ab3c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4302:b0:697:769c:e381 with SMTP id 4fb4d7f45d1cf-697dba6ee52mr68191a12.8.1782169144805;
 Mon, 22 Jun 2026 15:59:04 -0700 (PDT)
Date: Mon, 22 Jun 2026 22:59:04 +0000
In-Reply-To: <178215570871.91679.11260349768439750235.b4-review@b4>
Mime-Version: 1.0
References: <20260622111215.4157974-1-tarunsahu@google.com>
 <20260622111215.4157974-2-tarunsahu@google.com> <178215570871.91679.11260349768439750235.b4-review@b4>
Message-ID: <9huzse6ew5af.fsf@tarunix.c.googlers.com>
Subject: Re: [RESEND PATCH v3 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7874D1A0008
X-Rspam-User: 
X-Stat-Signature: ssnbx9huy9q6ckocix6njh8y8rr8wdk7
X-HE-Tag: 1782169146-302243
X-HE-Meta: U2FsdGVkX1/wjQFvgnCZpFuFdHB2mMV9z9eKy/5X7kRZmO9E2tjrGl9xQmq1LrGKRbMq7lfieCGJUoawskTWEX+WxjURzWIqFXXW083E/GWcdi3N2/PZJEdPTEYg+TcubV4Wk3bqMcktl4slGH8AlXWB4JTv6KNge+ZD1D9p6smKB59sWKFJZ3RmWHBEv558orM/BzdfZDlPFW+6KaGDEvW+3mxtau1/IIOnOu8va3ck68zb35mS1lw6o6lWjeRJvl4I6ZqJRWHKWT+UYqaR4CJ+FPuhZ/QljY0oA2Fvslw3bXRce2+7yd6+9KSBxipRODwLWdWedy4atvoWVINH6pJiHHG6mHM5KZ6+ZpWovYWu7kUKcU0E/RHcWiGPeuk7zGjpBdCZtv0+04XP4hZEs/BopMXxsuVvM43c2e9SBMhParQCJRP+uzeDbez8XZ8xdSpKmb/tbjrX06PW0AWRRZnUYeUJfcS0CYi8LaeAd2IB48UQ4Rn09R1kv2Hd78nohdg3LkOAlnyoTcti8lgNsr1hRsZSdsbRhSox//3MC8gU+1KrSn1WSAcn+VKDouqV3/Ox4Fi3Gq02FHQyj0e3U310/CDX5MqVo//s9a+wnDynDlm58w2lxNnONrwFSbTCtJYb5CluaES0IOHfa6cQXGP7DDEIuAY1+4l15G5DeMJL8EFn3AqdWUGIjn4ZkFuwbkSdVhLxkcDu5lVAfzrxiPvAQeubGnFzM2/FxjfoyyDfpuSXTrvluGpR0LVsjdgu3v0Jbuey81DJE1fpRWY/szfPjKHY2nyX6fs06FZi61RI316qkppFcS884DOmoMe1SmTcxd6pJJldfQB5+0rS2wBfQClbIN5lHu7+hGcZ9pTWaM6dFV8UTsiMqg8n0qutiCdIfnXG42YYmjY36MhEQp027oV7w8pgvEWHuo6QcnXhrgEdz7C4MaNUHlH67QcYLib6Vl7xIwdoqX6Bqx/
 VKkZw+nD
 VvK7uap+0lHgtJUkTNx0lY5y9iI7aCEnEu87NXbdyu+Gd8zrIzwWsxhBdNLp/hlh8Zv2SPM5aQf5Rs0RVm3IwhBikX8ZbqB2y5G+7H7YK3X1wQAm6NPaQYSx3wGhRkbHGj/onk7Tu7WQKDaJnOItCB9Sf4EESianYP/fBUz0JrANfh8iVvYvZX9q3PCiPrRAc/FhjtzfLvbodWDXzEovvtxRAvLChtBcPPvhuXoVagO9QypqH6clMzNVWFn3xoPOrQnN44ngGjWuoxDC/oTXzLeTehI0w9aY+CzzbGeveofit43RLLwdCOLPhZ2xVAmWDWBTTVIJRJ1k39RFcgTCYi5CPoZhB7Xdy/4BG3cNEqCnA+t7tgF5HovSqBzcHmCy/JhDgkGYf0r7jV8Zoncshfam6tQXHuAoHbQ2xIU6HVl/m+of5aSerHsrZGUAkmCPxt1EmxsV3UyQFP0SrleJwAHpzSkAcD1L8fbsLWt2mfDpqeK+I8c+Tkool1GRNOm0p1AxraYn7MNVwvLshMyRgHkisyY0CyAzX5o5v9S39mjt/sPrfI65SglxcEKVR5U6u3ZPkGJRs50QnvSFw3lHTmN+Aez5Yfqo+zdL242nLBL0CsoWaivZmtJAS3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Mon, 22 Jun 2026 11:12:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index 5e2eb8519bda..618408fbe9c9 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -139,6 +139,18 @@
>>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>>  	})
>>  
>> +/* Copies one serializable pointer to another of same type. */
>> +#define KHOSER_COPY_TYPESAFE(dest, src) \
>
> Maybe name if KHOSER_COPY_PTR?
>
>> +	({ \
>> +		typecheck(typeof((dest).ptr), (src).ptr); \
>
> And if we could replace the typecheck with some other magic to allow
> void * we won't need the unsafe version.

Done! Sent V4.
Thanks for reviewing.

~Tarun

>
> -- 
> Sincerely yours,
> Mike.

