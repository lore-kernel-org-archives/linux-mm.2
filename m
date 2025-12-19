Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4919E66884
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD9F6B00A0; Fri, 19 Dec 2025 16:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4F56B00A3; Fri, 19 Dec 2025 16:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0986B00A4; Fri, 19 Dec 2025 16:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD016B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:10:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2406C01E4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:10:02 +0000 (UTC)
X-FDA: 84237463044.05.33830E0
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id E2C9780011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:10:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=twVDahaZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of elver@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766178601; a=rsa-sha256;
	cv=none;
	b=u7scXh5ndxN7YPY41PwwcMMjKltwvMUXw8ggLx85dr3KmOgGI0hmTD3cqat2A1fTEI8nP7
	Ut3pqaRmH63WxRqs0hpy6HopkGitOc52Z2NyWYVmrdDi/XdgO50R4zUsQyBSO5JGYjnC8V
	3dlRCSMyUzNm888nTqwm6uDWs73A3mk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=twVDahaZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of elver@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766178601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
	b=eDI2FWR3heNUBDpMpWax9RnrTPNojWw5INr7cl9kZC7/zc+RpabOiRkip+tjQTw10DYuQT
	YdjRnLO1Y69JSP4Wdju5QOzGQEJS/kan/uG2424Pl3qiv2/46w6QD8xaam0saynMxm10TK
	KfP1rqLjFjqXsMJbrJRbkKaz5tmhIyY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a12ebe4b74so34062055ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766178600; x=1766783400; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
        b=twVDahaZ+e2OggkWTbG2O+4UthyX8QeLOHH5vbpTvatpQeqzhupS4IV0lqMIDWaHir
         C7XiBAEF6NO1pxcjcHG0o5r/MnTDX7Ts27GXTYwvo+jT0SINBOc4RDcNfqDMSkwUHrlN
         DdMBI5JFeaGQEO6rPNg+fmP6OQkfDwMwvFZDI+eIHog2HzX9nztNqj1y/Q/Vdl2+SJ1z
         A48Gi/0Hd/2Tq60zY8MAqBcFaSiybTpHzLxRaCoh7HDE22kTnUout42uWyAWRnHMJg6M
         Jmwzn4I0JPnBi1ealiaGxQd6HVkIk1CIXCm9OM6t9zySTyKKBpiAjQekioKm/2mmq5ua
         6s7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766178600; x=1766783400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
        b=PaQ2Jq6wdcrXyahqBOF/Xxqx1wrBtptEMUKmf8KgE0nybRYkwdv6EosIkaFcw6lyhY
         hxcrmBNrOmUFHgAe6N7JFTA6FClCi8xEMOswYy5ayc0FEB5AgKN5H07HK3liAdQj8uQ7
         KlHk7PMNi9RLANppxouX5Qiz1u4cUSP9YPsj/WI5wTND1CUFtTVgE7LkkFHV82hAOF1x
         2EJVSVOQAX/xdecrvyoXvSU3VSljVqqw1Ezh4pYZNQVnImq5Vor4qaYaY11Im1la/vBm
         dxpDx7mE4MDQyKQKQjymGXKNU4RH147vav6GW4LRQd3OPaFKyJfmV7chjYtXf8J+/ucc
         EpsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVzqVazn7/fXtLC1zd3pXzuqBDzkHcCN9UbDoLT00xouB/6WjBaTo9gy793K9KvVXUJ7ex16jXQQ==@kvack.org
X-Gm-Message-State: AOJu0YziMGEdnDtZXo2RlVRePKPpf9r8VptvBsPjsm2DW9hFcXFtFJWV
	YfWCXpGQDuGISLNisiZ0lOw317L8rGKVhjBHESXhCQ20FTeSkbKEH70RES079qv/2SIaXsvpayV
	UAT+1jZeS57n1Sj/t5Rxp28S1xQIYVAUbl56jV6g1
X-Gm-Gg: AY/fxX4x13a8rpcFwrvFyxsyEOGsUbIZhToctt8LmjG04LwQWXd193KXW1lqKAFOpAl
	L2rnUeEv72lZP2jzt1S5B8v1kZZVOzYsoCp2IwP3Ng7cYysmwyenUZtauCfF/aaIMp4UGFoSeUa
	iMyi/ZwLPsindDPFsGWJkeMmL5KOVYDajSPZsZCqoWjv8N291ohzLVtL/+dkcyynWgcdki4Bjxc
	Yviz1W/A8xiNzVi9tk5ZDZ9Pb9DrdPtDr1l1N/W15a4BWv5mbk/hfT9S8185DImaZb++phZp/Jj
	bkAadDxFhw1zcENTLp8xPaFavPU=
X-Google-Smtp-Source: AGHT+IGdr0jH8cGEaDB7eA0QDwFP/5Ve8WscN7cZkV8XMcvDcmhs6BtuLqrVUM3kTfn7w87OZJ/+kODUMJAxXUcmHFc=
X-Received: by 2002:a05:7022:ef0b:b0:11b:9386:7ece with SMTP id
 a92af1059eb24-12172309509mr4284248c88.43.1766178599422; Fri, 19 Dec 2025
 13:09:59 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-14-elver@google.com>
 <3b070057-5fda-410e-a047-d9061d56a82f@acm.org>
In-Reply-To: <3b070057-5fda-410e-a047-d9061d56a82f@acm.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:09:23 +0100
X-Gm-Features: AQt7F2racRCVQBtX1XHCEqHFLvRozCqLgqx9fCp_0Wp28A2qceHYZ0Bj23R_eEk
Message-ID: <CANpmjNN6QrxwUUkpAopTfxLwUqGfB53J96dwOWHNcoYrOrEocQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/36] bit_spinlock: Support Clang's context analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E2C9780011
X-Rspamd-Server: rspam10
X-Stat-Signature: swbsxyi5k63gaw4z6gzqkodsrrwag3mg
X-HE-Tag: 1766178600-791057
X-HE-Meta: U2FsdGVkX1+2qzFeg+4V4lCWBSXc6loDWam/M9J1rJ2GppcOa0QXi+UTuPsOHR5cYCMLomhk2vdFETYDu/PUHHXlzjq+EOIMToQn6lWlXkvTopJwQbNN4tm1Nm2hCwKGt6J3cZ3JFCjb9xvXdktLKo7F5ZsZhAVIwcqYTKBvf5AmzMp3LvfOjZncEQqOvSOMT74t5j8F/cllUt9wW9/vHyhP0tm4HVSWyh+4eYf3V/6B6Sb1ItXA3KkFJEHLF5uTE57fTNL4FkIyefiND29kSKA47Fckvyz8lDczHKAGGTAOftxuDOWaWbwaqjJnXDlWkucDcqlPAHDpiFGblIOWKR6UWunUVpDoEZtWnwsL2li/uCU/HB8BgXarewpxxPJ9M3KgreJolhSHXYUrctkiRPWZLTvVpIj709/Yz/WM99RiRLHQdWgFUhGlc+Mvz5U40GgJjb4+x04VO9QtzDTJbln5EK63JSHyoTzI8CZUGgo6D7cuFIWGx1L+1uRcL4K0v8ziQzES2OA+RQhfdJ/mS8LvV9wDrkhVUbtvzho0pUZG76a2SOVs2YSXsvUORzEEm1RoT33T1RhnxyRutq+fl+Ifo1FRApgqqE95mO9VkZ7+i0HcEeRCjt1lDL6BAS0/6uTMu1AjcRqMWGTAGEpKK+Y45UOexGTDauKKeje2iwaoEq0Og4qESLIb4EP9n6cj56dpqFZCPQ4rGyuX+DYTkbV7wwhmxi/LcNOjxv1MjEofBUPHFBIzMKlF5XXEhtNSTlf0RK+C/W6Axe/LKEo578fjZCrJeiuqqJvcje0t9BTfFJrwU1w9uO+Og6+8uixOc76hsZppk161A6Gii8KG0KqDzADoMpo8ngz0g2FA0KPT3aZ5usZ2L9QCm5s423SjOoIItiHUDCoshjM/64bu/oU50/ezwPkIYJdjvAI2z2t+n+27XZDPQ9Tds5IJIcsYXjSyJr8CvTmGQRpS+R6
 AtHGS67V
 709j9UnFvc4Bhw5AuRcgSlAlUESQXjM5nDmfxeM4eBeMpMeAu1FEbgn4+Vf6VWfhXHv3aENOUkTToivdeOq4684JYUD7iE5pg6Uq0ccJ+XSxjEvAeA81en9160AdBU9Do3JOccf+3eUMSWSHYOxU4dbk3/CQ+PzX8kJP5N6kbE/wqsp1F9gDpdp7BqUkcc28J6hrjwiRdtESJ4+NCD/nRNX6KjsD4JEAX11fP7vb+B/JBqp47LLZgNev0wwursyKKXlw9nXhezKMki3cSWaNN2EBzZzV4C9Dw29Z8SRA6gDP3iuMPt/W/yRSn+BxEzzjk8TackreYuPZfMnaq+vxGxPf2V1MTYABNUWK6tmf/2FKfTdBem6ByVz3/Kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 21:48, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On 12/19/25 7:40 AM, Marco Elver wrote:
> > +/*
> > + * For static context analysis, we need a unique token for each possible bit
> > + * that can be used as a bit_spinlock. The easiest way to do that is to create a
> > + * fake context that we can cast to with the __bitlock(bitnum, addr) macro
> > + * below, which will give us unique instances for each (bit, addr) pair that the
> > + * static analysis can use.
> > + */
> > +context_lock_struct(__context_bitlock) { };
> > +#define __bitlock(bitnum, addr) (struct __context_bitlock *)(bitnum + (addr))
>
> Will this cause static analyzers to complain about out-of-bounds
> accesses for (bitnum + (addr)), which is equivalent to &(addr)[bitnum]?

Only if they decide to interpret never-executed code (i think the
kernel has various dead code that's optimized out that might trigger
static analyzers if they analyzed it).
But this could probably be improved by using a different idiom, and
using an empty inline function that takes bitnum, addr as args, and
Clang simply takes the call to that function as the context lock
identity.

