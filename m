Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF369C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C726B008A; Mon, 31 Aug 2026 07:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73CB6B008C; Mon, 31 Aug 2026 07:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1346B0092; Mon, 31 Aug 2026 07:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A63816B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:13:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35DDE1C2000
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:21 +0000 (UTC)
X-FDA: 85161303402.20.CC3218A
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7ED46100006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:13:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EbgPLj9S;
	spf=pass (imf05.hostedemail.com: domain of 3zWGVagkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3zWGVagkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788174799;
	b=dSfjpZrPXm8RfjoLVSkR+5BOINto/yqqnlFFOfzxF38cG7DAHcOCHo5oTGsl8cXBZ6TfDa
	9gAjSmcoLC+YMqFgvlDZqh4NCc4737Yke+pYBX7a2ic1v6T8D08ZoGk+S64/M7Bql1heiV
	+dsBwfXTRzUUrcWZLhnO46Q5HsI2/Co=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EbgPLj9S;
	spf=pass (imf05.hostedemail.com: domain of 3zWGVagkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3zWGVagkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788174799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDmovA/vEGNiV5yN5Fli3lNnVvafbmOd9G0QStilyjQ=;
	b=qRsZlM8H5S/IMOs0M4O0MqHAR6xl2ymNsC9/1/QLQUJRoLZtuaum5AUM1gPCe1klswnfDJ
	ol47BFOrPsMRRwUvSTneEn+ePciilSWNwCB9/5cCYwsEe0qT3WfK7tW2LDg9XWrs+KEF9c
	PAVOxgfXHcxl5gR4ZOCV8eAHrx3UJCw=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-482f41ca436so2862161f8f.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788174798; x=1788779598; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WDmovA/vEGNiV5yN5Fli3lNnVvafbmOd9G0QStilyjQ=;
        b=EbgPLj9SGu7NEmx08l2GNTYnArl4ffGIguuyT/rjdtCQvxIf+pgYZwAKLwtAWfk0pl
         qhwyXr+IcHvOXtwl3R/gEBEXM60f3oHTc86Va1GiyXll7bTb4sfrMPOEoj/lPaQshk3/
         OQCbo57NeCTqPgUbJc+JoIQcy7LYhVXRLl4VAo1e0qO/udVhXT8/XjZMugiidu+hiEdW
         SDhf7tMzZsGwi2LGGFOTS0ivzoW//soYQ7rcqFLhl8Pp7b3nqE5DGs57bGjPDfgehGtr
         jjty7qYPpeQV23Yp0daezZ/8xIHNXF32A0Kqr+4bNv/yZ9jfQdp3Jkx6oNNZIIb5ndEc
         8LDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788174798; x=1788779598;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDmovA/vEGNiV5yN5Fli3lNnVvafbmOd9G0QStilyjQ=;
        b=j9/DlOdm8aC9nq0JwSbNeZLt7GIMYw3gTxpxib2YbbQ0sE/1My52e/BCdcJznpr/Fz
         H6rvYtfiAhXL5fxcv5Zxg+d0AMNZSMi8KRRVd7lFSW78DJxNNt0oOze0CCo9sN+i6Vez
         WIlopFJR+nFdGztyjqn6UyxHxnecL3H5WDvH37sazyqw8wqo1Yyh5e+VzTmx64+R+tri
         Qj1E/lYdzzGU0f/ohMI17FwxgMsyBGwmQ6XuMA/FSmd8+iNCQpd/W5a3VneNviqWgR9s
         XPtOvs3BVRLuCfTS5vtEqXw+AVaPaJPFlWVnIZpzP67A2YTqh7Hv0FPx4/7a5XLS5E8q
         XYRg==
X-Forwarded-Encrypted: i=1; AKwUvBzCMn32b1mCvFpJdTPh98ZHZQDNawklpLz8miUjHhsa5MuuyAINao4Y8rUB/CVYjAhq99xjEbqHDQ==@kvack.org
X-Gm-Message-State: AFuF++n7wZGz9gjd9VnQBL3zrBiZeqG5RF3tmYGVeZQw41kyn4Tf2nZX
	km3FrYVHSNqzOFvR9inqNtU9J2TAVYMIFilFXxx3wEQjR6WZcUAcJjv03PtcZZm7pFxBACXZ9qW
	Xu21Sni4Hgb3SPjg7yg==
X-Received: from wrte3.prod.google.com ([2002:a5d:5003:0:b0:47f:6f9a:3629])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:41de:b0:484:3315:1a37 with SMTP id ffacd0b85a97d-48436329b4dmr19698226f8f.27.1788174797557;
 Mon, 31 Aug 2026 04:13:17 -0700 (PDT)
Date: Mon, 31 Aug 2026 11:13:16 +0000
In-Reply-To: <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
Message-ID: <apVhzM2501wSiGGg@google.com>
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, 
	ljs@kernel.org, david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7ED46100006
X-Stat-Signature: 3uw5psa6u83funmio5i47g8oz8mbmbfg
X-Rspam-User: 
X-HE-Tag: 1788174799-651541
X-HE-Meta: U2FsdGVkX1+uXm1sqLgEL150K2QA7hb8lmjucS69wg8K7ZOQnVurU5ZAHQlk9eWY/1jkrZFwlkwdKGXloef/udZtEF/jXcwT8vJoGICFEA0jd06uVsuvYmjtxA1zeEIZNEyZjOPFg31q9M3y/dRaM/Fnl6dwyYBmEc5A+OyWgJjOuPw4JIE/qaN2o+E2Clb43VmQvRHD98bjqUsbcqLDIDDvecVvLB2zbN059Y//Ax6bXGL76QVxD64rGyxB4PpLy8AfcFD2pHv9qto3g/XLEz8tvhE9/rHqPqhBp5acIzilWvS83WXXxHiYx7ntUaNR/iXXBYHHtzVaIcvyt2cfk/RRSQGwjXzFSvPNcuBHlqIv1jZUeL9QcE/KF5/Vt40tbH9DoY91ZteM6vMZLjp89jxDNFBPHHkQvFzGZgU/bhYxFh75/ejMJ97tQM6UDdwlYm4ecZfTcz6ES60tfS4kTay30Lb5jA3HbhzEbUaMd1r4IrXXhxRGw5nFSWLvNx5DlE1tFcLvnJ6AqXJ/lM8lusMEymvIb3P1z5EZjCXwl9a0AQf/1CaiqZRuqOJwBUL2EBJt9cMdRBetTBMgUzQKDAEYBT/YXBAe++zbSzfhVDAzYFmuTbMvgQYuBR1DNAa9Y3M8osHMXuEJnuYx7iGAds44dtF5BkvWQi189yVsjmZ8P4wZerVLD2TyEXy9yaA1UnbnFS6pZ51ayNvHdxzKcHwS77x50KSbhH/kwWFQcP4ESRlHg3rmiqw+bGodxGzqRkz/lVhhX9lkObTvWR6nUHFWQ+2mFygN/IO9dlpykMESxFjrNBuHZ/kZlB3qPnApCSU+BIxK7KUqveFE0Rxf0aK16iN+rDLxtmSIcj+G2IOBSwW/nN4lTdy0lhCPlhpT7qrD2lzAzILvoH+S68X+SRXJ3huDJoimyEBDacg+xzAmHRIvqEQrvlHVj/MxDveAF4EQUIzAz26qGvqAOeG
 0qE/s/kh
 aG4sscT9LEoczgWwmM/JDiqWVWeO3F08AGB//e5/jBTQg8el3hL1uI2YFjfxexywGFzHwBk9u8yAb0T28+LnVxXRZDngYP/LkvmbIuCuWqW7i5Rge2vWzon5TAjFGz4f+UyERU/xTa7+TBmiO3GGU9PNGWGaBpOllQj3SVdKP3rMktNKqJTvi+LN3mZ2DkKEppQ3UPjlfjwFnmQ2iusBt9TDML8kVq/s1HvUTBtd2DJMU3w1bxRUpREN2yq0VqcX2F+v8TfN2+niVBPUH+kksCpjoAGHRn5Qfa6vr8o1IfVEdwHoOtLARAJIprrLD13EzP8WfT5w/YES0gFiAIFtB1SrZmc6xz1nvXz7PWKMaI7n3X6G1rbW7bmcioyfvq2o7PH8owKkmjPPtDt3Sb38SeaRHVeiFL3xuGzAcdTqgScnEThKUVpe2wybaFckZ517Lo01c5Lt1nWf7emJlTsnUs+CUPZWcP8AaGxl3e5FpTYnJou3yiCHmTEtCiQczc3kzn1wITCC1pLRt6NOy/6Eq/GILdUh+Sf6R26zryUGO6QSbANyiXkDaxXLQjN11kcLkVD2mBwFMdDVryQDMGeA+79vNjRn9haA8E6YuQomN2CT64XbECqGRboH+QfUsqJ/SUiO+DShSGfEWMGCgshAl8H8fhMWrTZO6rqt7PEhivA8WBDjJfHZUeefD2irnvfmbgJ8tEEK4tlIwBvl1A0u2mTsbPS58PI+WrMECxob5L7fhYrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> 
> > v2 version of this patchset [1] was written by Dave Hansen and per his
> > request, I'm taking over this series.
> > 
> > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > of the per-VMA lock users now that they can rely on them being
> > always available.
> 
> It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> 
> But it applies well enough and is adequately reviewed so I put it in
> there for testing, thanks.
> 
> AI review might have found a couple of pre-existing binder bugs:
> 
> 	https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com
> 
> and a small rusty thing which you might wish to attend to.

The binder bug is not actually a bug. When using VM_MIXEDMAP and
vm_insert_page(), the vma takes a refcount on the page, so there is no
use-after-free even if free_page() is invoked without removing it from
the vma.

Adding an INVARIANT: comment to the Rust code SGTM.

Alice

