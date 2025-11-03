Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7FECCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F5A8E0044; Mon,  3 Nov 2025 03:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806DA8E002A; Mon,  3 Nov 2025 03:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CFD8E0044; Mon,  3 Nov 2025 03:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC118E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:37:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E6351A0AE5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:37:41 +0000 (UTC)
X-FDA: 84068642322.09.ADFCA8E
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDA9B4000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:37:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JzQKH7mE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of ptesarik@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762159059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6+8IBdXCcTU6eZ4JMuY2we8/fQYN6+oBue210uWprk=;
	b=Ez0SkUqHiKpKnqhGBMxUZ8jTGSJFkLGH2NkitfTKuN/CA2kpBPNExu5OrYgpLzhxdEXWmL
	GpOEOyCZs6o2PFsc+npU3qT5UiCLu7ppyNat8jNEp+BIn3UqqpULui/FNa8wGOs5WYZjVq
	NAdc78v8p5VWL8wSo2jZeaWegOEY6AE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762159059; a=rsa-sha256;
	cv=none;
	b=wBoCFTO5ubQILF6kVDw7WcvNgrfhO1zVmIZ4IDqhAXzBX0gFzEivV30WUaqC2FbGaFwGtM
	8FQ8n6gvhuGJ6QSLQZh7u+Qy/GYlyhjR8BMinNRrWG2LglWsJWX1owM5pgXNStNWp5MRFM
	9SeO7yj5tEmpjlLlo2i9w58hJdbSOmE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JzQKH7mE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of ptesarik@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ptesarik@suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6409cb34fe0so344868a12.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 00:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762159057; x=1762763857; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6+8IBdXCcTU6eZ4JMuY2we8/fQYN6+oBue210uWprk=;
        b=JzQKH7mEXH20eOumT1UcZJG/OTQBR6/kg4qTZI0tAv76qrLLuZ2VjtzDsNZOozliPj
         BEJePHqYd8i1y52oPiqFxYglSk2TW42UCEkkezL5rKR/JQHqAcoYrywyseho3GXc/i+b
         72Gg6sNfLIQYtOOyqvJOPDnG1jn1xMG7vzGFo1ypcojG3iRtiPMs1lGB9wqyBvU2tBJm
         wz7BUEExkms9I09fdkBfR8wdt61vU5gAki4scUyhKya+GCOWsagsd1YKV8UDYQD+UrwG
         Dq9CrqN2E1c95wwbymETNdyH4ekR2+KXQr4lsiw9u+zDtCo/zc9I9LM3Rrt+NFK6kp22
         s9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762159057; x=1762763857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6+8IBdXCcTU6eZ4JMuY2we8/fQYN6+oBue210uWprk=;
        b=ZqWqn1BZnsh1zDdEdp3WqawR3lFdsTHm+3YXaRTDPCnfezh5Ga+MdgSh73It1KxNO1
         g1ahRlbP06hZHb8mtLj53fUbpkhzS6+u5cnPxlFtT54nyYuvUnwvVLFNm6FXD/PcaIjV
         sEAwsY0ZqahyjWPozjPSt6VonTRz7j20JQWXGfAItxPJFwDFtnuSZch0MxuOBeEhJvCl
         STow0sxbL8R3dt5S9Aya9+7IgtcyoHxTaEx+xEaJU75FxVVRkPVkQcrMQDZUuA9baDjc
         MlCynckrbBaIDG0t3FcxURPnhrMwj/wkESq9R78y8kMidcsi9ZpWRJxF0106jlZ4GVKo
         FYvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOOT11/jorX/rZfOPddYgAwRHmR2cNJY5I9Dho9EGqRfXavmL9hFxddD+Pqg2bh1dt6TO9eN7uoA==@kvack.org
X-Gm-Message-State: AOJu0YzpJHEofyAE51iK0tTR97FOBt0ot9X+f9/pGMznbgv/z8vX+wCb
	Rp3Afzp/7gHUQgie4TwZV1oLzwg+oEjtXJVTmKzLCchXZKdpjWwTDc1o0JIQ7KnRNxs=
X-Gm-Gg: ASbGnctxEREwo7dV8EZOv4Ig0LIFXcfte3ijeRu2EhTvId/5rbPjDu9HBzguU+lhdQH
	J2DqNko9PaVEyHlQ5nC8PPMNPmxfhHHAn8FE+yGDxQXEoOi79W54emz5sUxkabZp8MYSmPTjZxL
	SH7a6f5A3xg6Gs58knxppMi8crkB5C+RXNafiHUDSXhudAicr7cVweXxZgToF0OXh7LmgZGD7Wd
	qQ+kvoNqQ5ij+GNlJSEZcV0GUgcxKpFr8729zMzZdM+L9mejIzp5aVaYA4Wrtvw/+xJvLAnvY05
	PIjyErYs9P9SzEyzb2yE39nPY7zK7DpUIC5MQSG4TES57n0mjRx+3PQ8zAsZpR+VYty16Q3Yvgv
	CvpaqVeHOuy7vvIj9Wb2xzycPfobGamsCNt834stuL3QHpxZyVukgHdesfza4Mp9qdbUDs1DIIM
	eAgbJiHR+lvJubRhfg4lKzZS18ojeNUhQ/11T2Fi8kwwub3JNwtgb9y7NZImMp7z6BBbzrWTatM
	60p
X-Google-Smtp-Source: AGHT+IEXAMzB4Q3iZseWqc5EI+3z01yD/lkzyZQiHdGqXZRiWGSYaalZ7FPGcsDnEnqBbvKYbK1akQ==
X-Received: by 2002:a05:6402:27d3:b0:640:9eb3:3683 with SMTP id 4fb4d7f45d1cf-6409eb34460mr3244974a12.1.1762159057100;
        Mon, 03 Nov 2025 00:37:37 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6407b428119sm9012005a12.24.2025.11.03.00.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 00:37:36 -0800 (PST)
Date: Mon, 3 Nov 2025 09:37:28 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Josh
 Poimboeuf <jpoimboe@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Jason Baron
 <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel
 <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, "David S.
 Miller" <davem@davemloft.net>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Mel Gorman <mgorman@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>, Jann Horn
 <jannh@google.com>, Dan Carpenter <dan.carpenter@linaro.org>, Oleg Nesterov
 <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Clark Williams
 <williams@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v6 06/29] static_call: Add read-only-after-init static
 calls
Message-ID: <20251103093728.031042d0@mordecai>
In-Reply-To: <xhsmhqzujp9t3.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
References: <20251010153839.151763-1-vschneid@redhat.com>
	<20251010153839.151763-7-vschneid@redhat.com>
	<20251030112251.5afcf9ed@mordecai>
	<xhsmhqzujp9t3.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: w97ddt9rshcpwx11gd9q8bf16zt6z37e
X-Rspam-User: 
X-Rspamd-Queue-Id: EDA9B4000A
X-HE-Tag: 1762159058-130707
X-HE-Meta: U2FsdGVkX1/IWlbk8mRLnE1RCStNyUBgAk5lGdNIJVKHLzJt7c5UWS+W1YtxClifth17xu1JlvbhlkdT3Bm5gXTzJh+83MOz8uJxaQZ/Kmk0gC5V/pSFfH+fXf08pJwsFVIjiYCw91mUkTFgy/GbZ3pEEL1ZNX/HMJJMazAJmg82OXmbcy9d7opisN8mp6o8fdWYgLlKoTfPNogHgGU9kn0FtdurCQJd8AWWiMiigehNkILCUZSga+nD6WUgdc3TLk5CICsh5Urh8Tz1cY+z9qAXC2EUalL7ti6dACRFmZ6hRZVMo8qPz82ctZELnJZ2ZXNHe9pBt2iUvEx8BMX9aY9SdMpAbC1D7nwlqw6R903kHicDKWUby9KJ2JZHR9GXO/EquQR2prM5ktmzIhmXP8gEikW+yQxSHualaErwumw4j0VsYs/AngbqDqhomnqeDcl2bpFD8R/xep65vDd3Di/AGPxtWq3c7dBrlrBOpWjxeVjG43kBwp9pKnZnICtqeBxbzh8mD/YHn8xnOKlKFsAOy4wbujvh3GIwsryuO8Gke0qoEpUiw1L+QBqKcgWJk0OBxZrlkMMorCWXYIpGJ0eLLM/BFzsHq+2AOXpouu9Vv83SFnqg9gRQUt2s82iFlArVxLQN4AWF7wvwPkyf/hzUyPgSz4eEcn9qihzl58vaxKrTBxLMVtm0TFjetaoxPAieJGO/J8wFtXzXFXPkFWCykU4GVygmgnke2vDnyIy9McS0iB5b4A4sM9cK4UOCYd1n2UEev42FFEzbIrAIYgNXZxmvBqiSAvuCeoT4NsL6no9n0C2Ah9tllfyBQMpQXYCLSqN0Ec9wu8BHSJ9qzprLTeUPNSa7VC8Jx8hUNYJUqw1QOP5s22TkvQ90seOFQDcENaYaiFzxytNM+cvSP8mQDCig9n02SjbB6PVbDi4xUPYCe7XQMQHrKH8sqVuPR9vcGaYvz3B7UK28Dc6
 MECrsNYk
 s3K5rnk3IpC0vtzUaOHbZmMAOVFtcU8aimtIWFSBgTI31tgfFa3ZqLUI02pK4WcPJqi5CiCw0T8wtGk1VGvNFskAP0zFP647FEbtCmk1wXITvz1GyAogxHtBu7uvhM+IGGiIrIdBDeD4+vSPWCq8oTsxtg7dgfJw9EZup+siQ4zyB80fh4S35mEIRaUxVN8qpnG4fPTTmoHfIa6yRTOM15TLwS2hWy9Vb752kJWjEv4rOL5shX1j93f5jBt91yXPeQzPEF3hUim7Ykf9yRYatyngo5RhfnrDZixUvBGEffHGbLCKKaHUh4/iahDHgYdyUf6F7nflPqzvjJ7i8YQ9IJXhLJYezlXI6lKjdBDRuqDXRIXNHBH8nLen2subGU82gzjAj1RvbjCh1/H33CBsW5Sl8DQOHZlB6mBsI/lhG12lKERn/eFkir97mZSOB+VdHlpm2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Oct 2025 12:52:56 +0100
Valentin Schneider <vschneid@redhat.com> wrote:

> On 30/10/25 11:25, Petr Tesarik wrote:
> > On Fri, 10 Oct 2025 17:38:16 +0200
> > Valentin Schneider <vschneid@redhat.com> wrote:
> >  
> >> From: Josh Poimboeuf <jpoimboe@kernel.org>
> >>
> >> Deferring a code patching IPI is unsafe if the patched code is in a
> >> noinstr region.  In that case the text poke code must trigger an
> >> immediate IPI to all CPUs, which can rudely interrupt an isolated NO_HZ
> >> CPU running in userspace.
> >>
> >> If a noinstr static call only needs to be patched during boot, its key
> >> can be made ro-after-init to ensure it will never be patched at runtime.
> >>
> >> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> >> ---
> >>  include/linux/static_call.h | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/include/linux/static_call.h b/include/linux/static_call.h
> >> index 78a77a4ae0ea8..ea6ca57e2a829 100644
> >> --- a/include/linux/static_call.h
> >> +++ b/include/linux/static_call.h
> >> @@ -192,6 +192,14 @@ extern long __static_call_return0(void);
> >>      };								\
> >>      ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
> >>
> >> +#define DEFINE_STATIC_CALL_RO(name, _func)				\
> >> +	DECLARE_STATIC_CALL(name, _func);				\
> >> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
> >> +		.func = _func,						\
> >> +		.type = 1,						\
> >> +	};								\
> >> +	ARCH_DEFINE_STATIC_CALL_TRAMP(name, _func)
> >> +
> >>  #define DEFINE_STATIC_CALL_NULL(name, _func)				\
> >>      DECLARE_STATIC_CALL(name, _func);				\
> >>      struct static_call_key STATIC_CALL_KEY(name) = {		\
> >> @@ -200,6 +208,14 @@ extern long __static_call_return0(void);
> >>      };								\
> >>      ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
> >>
> >> +#define DEFINE_STATIC_CALL_NULL_RO(name, _func)				\
> >> +	DECLARE_STATIC_CALL(name, _func);				\
> >> +	struct static_call_key __ro_after_init STATIC_CALL_KEY(name) = {\
> >> +		.func = NULL,						\
> >> +		.type = 1,						\
> >> +	};								\
> >> +	ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)
> >> +  
> >
> > I think it would be a good idea to add a comment describing when these
> > macros are supposed to be used, similar to the explanation you wrote for
> > the _NOINSTR variants. Just to provide a clue for people adding a new
> > static key in the future, because the commit message may become a bit
> > hard to find if there are a few cleanup patches on top.
> >  
> 
> I was about to write such a comment but I had another take; The _NOINSTR
> static key helpers are special and only relevant to IPI deferral; whereas
> the _RO helpers actually change the backing storage for the keys and as a
> bonus are used by the IPI deferral instrumentation.
> 
> IMO it's the same here for the static calls, it makes sense to mark the
> relevant ones as _RO regardless of IPI deferral.
> 
> I could however add a comment to ANNOTATE_NOINSTR_ALLOWED() itself,
> something like:
> 
> ```
> /*
>  * This is used to tell objtool that a given static key is safe to be used
>  * within .noinstr code, and it doesn't need to generate a warning about it.
>  *
>  * For more information, see tools/objtool/Documentation/objtool.txt,
>  * "non-RO static key usage in noinstr code"
>  */
> #define ANNOTATE_NOINSTR_ALLOWED(key) __ANNOTATE_NOINSTR_ALLOWED(key)
> ```

I agree, this makes more sense. Thank you!

Petr T

