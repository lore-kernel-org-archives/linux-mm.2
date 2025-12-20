Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693DAD78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 12:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE6E6B0088; Sat, 20 Dec 2025 07:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC4E6B0089; Sat, 20 Dec 2025 07:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E7E6B008A; Sat, 20 Dec 2025 07:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A20D6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:52:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD04F8B3AE
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:52:09 +0000 (UTC)
X-FDA: 84239837178.17.A8E7C6A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B35C140003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:52:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=di0RNQMC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766235128; a=rsa-sha256;
	cv=none;
	b=FGIF+Y3iNH0KQ75lOIIm/Gl86WDpLoyMwuNzRXf0qTmApmTcEsN3LuH5Xjbalx+pNDaRRN
	m8qeBA4B/NM1uC++b2214C4Rdu9BvEMtMxgE08gz/tFwWvwpKUMf5+8bEkHCNw/lrl+2NU
	en//0oqft6sjNVz64W4kJt3c/Su1k2E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=di0RNQMC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766235128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dbDPICBAvFxThOmxuLLN+XESg+4otRZJCktLSd/IHI=;
	b=gaz8Brd+oz2pR+AoU3bp2MItTeFQWRoIvjAEEDlhDRcFMmDlAzV7T6btQ140gOfEpoe1o0
	wavFLIeTddyvXe+vm/oR0N5t44Hygr0Fhrhaa/nzlj90v2HfGC3VXnuteFVmQrjDnAJiHY
	0rIt6I3Egy86H0GwK3W85bPU1+xIZ28=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso1674619a12.3
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766235127; x=1766839927; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+dbDPICBAvFxThOmxuLLN+XESg+4otRZJCktLSd/IHI=;
        b=di0RNQMCaKNVO/Wv0IwI6KfeHHbG3qozqr76qUwtKzG/TeFOtBlv2S0TG0Miv9dpH2
         8QjtEKJnEpobbLvZdEZB1yStiIyh9f0fTwPCmR4AcPq1uBlIL0TAbX3xYi6p7D/kYh40
         X4nhNoKDATI47dTBrBdXN1rXHlY2apXIHVUQtTS0q7Em8q6E/V049G3cACuNQsxrSyin
         rEUQzjn/70Sno2Rzm0qIQnMGnBjFVt61mVoItuK+crIq+nenafe8ZebqQMxu3QWjxa8I
         xTfM69gv3wZ8t5WjEvF4XkYtjaK3mTSam940v45tfr9uOAGMTwhJgMXOD5aVg0Um/Ux/
         F2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766235127; x=1766839927;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dbDPICBAvFxThOmxuLLN+XESg+4otRZJCktLSd/IHI=;
        b=ojhsbXiaqUQR4gObg30zjSjaydOEpY3kv+a5WW9osR0C2/cidkpnLcdcIdaLZS7Yv1
         7wVJfMzK2a/v2kwMtrH//6+2PGpXGBMZvVMMuAUMY2B1r0pTTrDVzfBvf/GvyOUbE8Zo
         4uWivdcxAnV8Qojb9zfK4C6xqJIg+XI+dhs4ie4/f0HO/GDZ6Wo8kIkUqgkN2Xi1qtPv
         ZDC96+9Y3huHBoUgMBMeE7ZNeBQCyGs449gJIHD28UwuCb2mg5NBOLFlrjZR2h2PLFD6
         t1wKBanDcDovSYZd8deCPnHE2jdJ9QWZxyPs9Ht0u+zIsf3zHs0QFXlCTZByB5zpOFlP
         1g+g==
X-Forwarded-Encrypted: i=1; AJvYcCW2ixcCV57TpbONqE3Q9R51lypEcwNDIeHbXsGcmepKdExs2WVpXCOevsBGH1H+9M/f1QfmEsjnqw==@kvack.org
X-Gm-Message-State: AOJu0Yxfh8+aT9UjGUn9xI+4zx//AweC7g4t/jSo/U6rzt+nuol9y9i6
	PQ7zzT/FzupRgSNgB12cZKnl2JLUrGQt4O5fATh/d7y2r41XdQH/e9aa9yY/xNeZH1bhLHQH9hX
	GA5PpzC7UNIGAP7c9yxmgSJNdI9i9TYhidlSg6STs
X-Gm-Gg: AY/fxX531XuQKd2FehDW3wLCnNXGSl4wRJp6JucgLQeRMJJysCCXLqEucOH55WNXx+Y
	3S7Y0waMvJRkg+KIttMtExC0tDBH/x5QRniZ+TeYSfp7N4LXll3UJma3HDLiPi0WNtKYdJxLwTn
	Gd0V2Jt3xh6FH5V+ln+enz14fpZKqsSWxCmi/BF0JawP2GnuEHiO9J7AVzknVDck5hTU2QJVhVo
	XWGrrYJXx9M9pcvGu9RTOAgprhJC6g8Uz9yJ6hCEoCTifU2R2nggyxyrwIlqJPpsv0cAAoQvuEW
	tDUh2n6ZT0atI03f/ONnAhZIHnE=
X-Google-Smtp-Source: AGHT+IFK+Y5PBS3dXibTZfBS01UEAFChnwqe6iaCyTB/4jIaIz5ZwPF8qLO8d7Qf00M2Z85ZCatTVKEE522UP0jz/Ik=
X-Received: by 2002:a05:7022:6291:b0:119:e569:f61e with SMTP id
 a92af1059eb24-121722e12e7mr5961881c88.23.1766235126461; Sat, 20 Dec 2025
 04:52:06 -0800 (PST)
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-25-elver@google.com>
 <9af0d949-45f5-45cd-b49d-d45d53f5d8f6@gmail.com>
In-Reply-To: <9af0d949-45f5-45cd-b49d-d45d53f5d8f6@gmail.com>
From: Marco Elver <elver@google.com>
Date: Sat, 20 Dec 2025 13:51:30 +0100
X-Gm-Features: AQt7F2ppWjAa_1uLXQb3ar2W4qqqhjA5uP_vsvi-YrCuihuPYztcukGp4Yjpido
Message-ID: <CANpmjNOUr8rHmui_nPpGBzmXe4VRn=70dT7n6sWpJc6FD2qLbA@mail.gmail.com>
Subject: Re: [PATCH v5 24/36] compiler-context-analysis: Remove __cond_lock()
 function-like helper
To: Bart Van Assche <bart.vanassche@gmail.com>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B35C140003
X-Stat-Signature: xcta14m1byqfar8qp1cotdi3fx1w119w
X-Rspam-User: 
X-HE-Tag: 1766235128-77953
X-HE-Meta: U2FsdGVkX19Sqf+o9UWCfXWJQOpFdjxPKVXzQsjGjjOry8zCufaaSHhFf0HpS2CMDxUZVRKn2GwkzBb/k55KSERAk6sAE4AwrW3RT2D3Dd7VZGWXSQwv7Gi8vu8fQtrGtqHCuhFRoAoWO0akQPGwnvxgOysrGpyDw73bN10dho+3h7E0NO1q1YJ50EzHhNJpVeN51W6uDP6Fkp30Wy3vJXjMa1qXnu/Sz8Cx6Pj7/kmuVOy7pj6jlQ7px1NFBbvx+IIHwvxM76ttMKSDvfjQ/i1DPObZTZLr94/R05fd8bWj5x3XI/vt1OGDSghfIL2OinYKRhfrZmHOA4VFb/fTj1odUOSlyUCyc9+jKIZHXtffdB01HW0rjeVZM17SdQQlQit59X4igXZfNV4c4jiXmEFIJj1gBhG2TX2EqpQ2euQWtFgFgNeBjpFozjlTxnVe3kY2GW55jFwjyJ/R+oYvFESWjNqYntzswNOZGD0upjrZ3DdjIiHzQjzYu55PHxzdG6NgzcywPdozmKoSRJ/O2AC0DmoTymx+Ll2MCvEVhLEb2VJpAwT1aY9/3S7dst0+HaFSXHAEzjfMPKgpUCToqkoqgVNCX/kctPOxwBCJlsbfteh6XCHl69EHAHk9tug45xJ3Eg8cP8uGeuUzPS+stqHLL6kmxUs7kxC9c3uHFrQhxwNZjEDD86nRiqxYvll5H3hjDTW8dIY1rcCMmMEWa5B1uQuAlk65tZccIWWUHz7sB0WKiSo1pX/k8h4mnrjfRaEhhwx4sZPcaNgNR+A6jZzPHzQ3rkGs7Glxch8x3pgs3hHrFc6oVhvQ3eZE7dnnrp4gPuowcQ/b4k385Bs97TyRt5sneiKdeq4BfvBfwgl102J1hK0HeaIqUhUPDY+ffew10rd4K4o6AubaRqBpLWEz+etpFg90NgFAPeoJ3ETRoZDa3Zs+PwvnDWyBXotw9p0EPbp51LUC1gFpjj7
 fEF+FbKN
 AsihBXjWyUhGCzo7Wz6fM+2NKS+r1UhCr+0T/Yf3ScQmx+ONHDOzhn7p6VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 22:42, Bart Van Assche <bart.vanassche@gmail.com> wrote:
> On 12/19/25 8:40 AM, Marco Elver wrote:
> >   Documentation/dev-tools/context-analysis.rst  |  2 -
> >   Documentation/mm/process_addrs.rst            |  6 +-
> >   .../net/wireless/intel/iwlwifi/iwl-trans.c    |  4 +-
> >   .../net/wireless/intel/iwlwifi/iwl-trans.h    |  6 +-
> >   .../intel/iwlwifi/pcie/gen1_2/internal.h      |  5 +-
> >   .../intel/iwlwifi/pcie/gen1_2/trans.c         |  4 +-
> >   include/linux/compiler-context-analysis.h     | 31 ----------
> >   include/linux/lockref.h                       |  4 +-
> >   include/linux/mm.h                            | 33 ++--------
> >   include/linux/rwlock.h                        | 11 +---
> >   include/linux/rwlock_api_smp.h                | 14 ++++-
> >   include/linux/rwlock_rt.h                     | 21 ++++---
> >   include/linux/sched/signal.h                  | 14 +----
> >   include/linux/spinlock.h                      | 45 +++++---------
> >   include/linux/spinlock_api_smp.h              | 20 ++++++
> >   include/linux/spinlock_api_up.h               | 61 ++++++++++++++++---
> >   include/linux/spinlock_rt.h                   | 26 ++++----
> >   kernel/signal.c                               |  4 +-
> >   kernel/time/posix-timers.c                    | 13 +---
> >   lib/dec_and_lock.c                            |  8 +--
> >   lib/lockref.c                                 |  1 -
> >   mm/memory.c                                   |  4 +-
> >   mm/pgtable-generic.c                          | 19 +++---
> >   tools/include/linux/compiler_types.h          |  2 -
>
> This patch should be split into one patch per subsystem or driver.
> E.g. one patch for the iwlwifi driver, another patch for the mm
> subsystem, one patch for the rwlock primitive, one patch for the
> spinlock primitive, etc.
>
> The tools/include/linux/compiler_types.h change probably should be
> left out because it is user space code instead of kernel code and
> the rest of the series applies to kernel code only.

AFAIK, the user space version is just a copy of the kernel version to
support headers that are used by both. See
4bba4c4bb09ad4a2b70836725e08439c86d8f9e4. The sparse annotations were
copied in ab3c0ddb0d71dc214b61d11deb8770196ef46c05.

And there's no point in keeping it around given it's all gone:

% git grep __cond_lock
<nothing>

