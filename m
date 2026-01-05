Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50512C2A096
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 10:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA2E6B0126; Mon,  5 Jan 2026 05:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9B16B0127; Mon,  5 Jan 2026 05:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0376B0128; Mon,  5 Jan 2026 05:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB486B0126
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:52:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E8AF1ABA11
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:52:48 +0000 (UTC)
X-FDA: 84297597216.25.89C5646
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BE13A0008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:52:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MqB+3rEU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3_JdbaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3_JdbaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767610366; a=rsa-sha256;
	cv=none;
	b=QhrDAL00n/p945xt5tr/YEoG2OHnYwZXiTiE9pmB5BmDhpgJaFDnwsbcbQMdLDhBBm3UL5
	Hb7Xo+GsMSYWKvJFq9l2TLE1CvxdUIXk2x9N261AAVIK+xKMrNBQIwOwjtxVZu4+1yKNs4
	ajELXqtgzbrPr6HLCq1FbLhTaPcNQxg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MqB+3rEU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3_JdbaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3_JdbaQgKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767610366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZIE86Erp1QGbs2m/K1kc889xwmLfFaps0VsChU7D34=;
	b=u0mvNvxxm+7MFURjLXHHcJZkDhyZxrEfRSInrxioLgLbdxqfQNdAFfrfkXDJxm8m1YXqq4
	+dxx7UCF+Vyonnb9G3svBBzEWU17Gyu1fd90EdMS+oS15yFfC+fo1sVLmH4DXSJe4pMFZ6
	BBnrTr7/GF0sWZu7lxURXQAgZ+dNREg=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fcfe4494so12668826f8f.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 02:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767610365; x=1768215165; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eZIE86Erp1QGbs2m/K1kc889xwmLfFaps0VsChU7D34=;
        b=MqB+3rEU3axDp04vadMY3BnwHtjsLI/V0ILKqy2oVQUvfYSlPLDxBo5HjX3SJ10w54
         sdYxO7XeVxTIWYdGvIbcrN/GsAHGMUzvSRRuOMsID4u3d6d6U6/giG/FQwgbDjzOvBRV
         SNuJW1C/M4EsWOgUC74d9gW+ef6k8lzM5QSZQ1zM0Maf8hSt/4h5VzicUkJrQZh2MCdO
         +RKp5K7D17QmOHzQwZb7Qi6tjPxh8N5f6QgrQnWEJy9n6sswjCv+IBLvxlIpPf/00RVx
         he9W5TTLHunB07XQLbAZuU85IradIl9sTj6VfRb6NA4YwsMeHZyXS//NkW3EYsHJm8oR
         DI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767610365; x=1768215165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZIE86Erp1QGbs2m/K1kc889xwmLfFaps0VsChU7D34=;
        b=IwbB+fwrbGECA1emMBrtAy2JNOIGhZyINjCyv1HUsB01XfZ28VthqXomUTcLH3oXGB
         NzA60uMIHbWfAE+zYZErxwqqDXMmZl/IVEg5hyDf8okjL29rUXLyOssyBXEDa9l5QccH
         n0w9jh8nUvv2PT0cIEUH15kmCEUGbnxGi28tdAucMZNHULStO7TT1mUzc4ZHx1o29rAI
         AKZYv/iNKYJ4GO4PBxhEGGd3Yb1bJBGNUDPtuVfr5LrM88mFT79ZyK8vVmeo0QE+8Urf
         coKxG222QlqYN2ySwPMQFSuIicuWslh9CFcagu+yZS7sLQyREvAahTk563b2x0tawq+z
         wxTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBhY4HKsBWVogAG/NWDyW6/R8GRwY2CrYTFrdTF+Cvfv/DfkbVea4Vu+z7uZ5Gd3uJ2p8QsdL1TQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6n0FdMzI2eQOhO7/G+5g1QiG+QxcmrG3eomqGPaxdfwALgtkA
	6jCxy5pQ2zkmWYMgj0GElz7cGE0wTRHJe/tLhnORtr58C2QFro9vCaAd5yKFNiqRKM8iXIs0DKJ
	BwGVeQ9U1Gee9/Q==
X-Google-Smtp-Source: AGHT+IEAJYABQdl0S3AMd+Kym0YbP2ev2YfxQ/hHue5b+xcTvswe3K5CPOaAuQwSBUuFhDhZ84cMtaq210atDg==
X-Received: from wrbgv28.prod.google.com ([2002:a05:6000:461c:b0:42f:b138:c617])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8718:b0:479:1a0a:ebbe with SMTP id 5b1f17b1804b1-47d25082cc8mr551544395e9.14.1767610364788;
 Mon, 05 Jan 2026 02:52:44 -0800 (PST)
Date: Mon, 05 Jan 2026 10:52:44 +0000
In-Reply-To: <CABVgOSmMXsbhJsBBy9p=WK1RdB+gcgyuma_FTSfQOGWJ0eqU8A@mail.gmail.com>
Mime-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
 <20251223-b4-kunit-user-alloc-v1-2-fb910ae0e50c@google.com> <CABVgOSmMXsbhJsBBy9p=WK1RdB+gcgyuma_FTSfQOGWJ0eqU8A@mail.gmail.com>
X-Mailer: aerc 0.21.0
Message-ID: <DFGLKV1IYDM7.1W30Z9PG0WIA9@google.com>
Subject: Re: [PATCH 2/3] kthread: Add kthread_take_mm()
From: Brendan Jackman <jackmanb@google.com>
To: David Gow <davidgow@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	<linux-kselftest@vger.kernel.org>, <kunit-dev@googlegroups.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BE13A0008
X-Rspamd-Server: rspam10
X-Stat-Signature: 6yandfb5djt56719qdm8qpyapeoeqzdw
X-HE-Tag: 1767610366-910413
X-HE-Meta: U2FsdGVkX1+vJViUhPmm07sP07+79uYxdt/QX5BASdFTgxWxmtW6ahGronhWAeLhrdF2sFojybKhMJ873xUYz90tpoxxC8+/ap3wF+DD938Z8Yzp3vtQsHUQaRVEstbwUSYQSoNV+gHO8+uVPxgqHusV8hKYj4ej5ro/FgU27Z5VbeG3+vhogMRpoXTi/yB7goh9bhGlMOF+FnhR5ZPSfmWlKnrHZiNGrVrNj+w+9J6MNf3Iq+iPIK2aVT/jKydF/E4exBgYxcJ7vAOq1iVa04EpYlYUSfQKOTv2TYp9CBLQx4fBeoRWCBY/FmemQcx3lnLnlIDzQ2YDmx9CF3TTMGZxI/pmA0uoippNdyJMobvK+fYBx5swPiKBapV8z83yecQHXq0jKaFZVlcplMPurdY+r1QK1Gz8M1izpPPKfj8fyb6EBB0HmZbHVbI7NzRi0PHNs1V3hZftn2CbE/BhjkhF6ucnC71OW5oJ/QXv7WCHdjBhcH9UR81IYg/vuTUUyGSCclK4LakVsQuQwgmBpLWdCIGhiesQFqzb9empiRO4iJfUwhSzpItqJBW9QBMUTlMO3pGLHq7Yrkx751AEhBSR/b8RWnft2ybICWHwRyUVzxM6xHs4/qhQRkBhWnKYcU+Jhv/WvKz7MKY/RgsJHzxUWnmvhX+ahArkvfg7NGI+oqRDhZ+O6ZQIkPnkW7ABj63hOtVt6mkW5giZ3hJGaFM/Spw/835VBwzNke86bImNTwwZi4pSDm1Gs7hIMXfnZoHddNZW7mw6JMpfdx/d73u2sULiPYyd1LoEuV7bv9x80lzUUwsPncOYGlpyn0R6j2nAwCuzVLp0g+Sp9tw63fPpqd33QEfSl7Vs1rzFdx6T8gsFLHlFLzFSbAd48F6jpWaUtzS12ochBNP8qziyrdVzelcqs/k3xHwBWjp1A8T8e/lvD2nCG8t/6Oo3c8JDc6JWJBode+Vld+6hMLg
 yYn1MdJC
 ZO/Z75SfP1WrATo2xLrH/UkLa/eloO6q5fUtEcwoi+KZegSRSSZe92XIey57jx53WsGdzKVKNBQFmSAYU79DJti9rKKog3T1tDVxN4a6Nz1sLSFKUJ8Snr0V/TklGOOL49xfYV9bFPJ+yGxZLyYuRN2AKf5JK6yu1eEpqHobg4wQN5AQW65XMYq212koWyGRFaAqQ7AF+q5+RzPEG6koz0h7XxbD5Co9ToE/WOJYoToyZs3oBatkbRFCuDVYNsA43AnAGiVlkUrhOiEAfCaeBZ7KQIQF3VIzKLF5E1IXuRYxc79Zw3ytN5hYShCeL/0c2eblYSgQ9lD0ygFC9i1uhdaXm7+DLv8/dk6J/TwenKVRzRIkvWzAJfc9Sgp/VQiTtcHnSYyygQCisM+N7E84mhidoTojSuz0S8qLBs1/AnDmmTMu3txvPf/XVKUxnSn6Yi+APSgWyZf8QMaBrPbT8660i2jmNB3dVZICaUID4/VF1S38FI2VvxgmKZCtznn3d8fXd6MOEMSIXM4o+DpF05b1n29vgQIHaejPKcQRhQMQlmLjaD/wfBPTuALmFh0zJ0X/xHhMYcFqDK1o/uES/N6/cr8z2DMgqiHNwBDUc7pFfP2w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jan 5, 2026 at 9:56 AM UTC, David Gow wrote:
> On Wed, 24 Dec 2025 at 00:18, Brendan Jackman <jackmanb@google.com> wrote:
>>
>> lib/kunit/user_alloc.c currently uses kthread_use_mm() without a
>> corresponding kthread_unuse_mm(). This is a bug, but fixing it in KUnit
>> makes writing tests that use mms more difficult, because of KUnit's
>> resource/try-catch model.
>>
>> Therefore, introduce a new operation that does what kunit_attach_mm()
>> wants, namely an unbalanced call with cleanup deferred to
>> kthread_exit().
>>
>> This is actually just the same as kthread_use_mm() but without taking a
>> reference on the mm_struct.
>>
>> While adding this, clarify the reference returned by mm_alloc(), since
>> that is what kthread_take_mm() is gonna be paired with, in practice.
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>
> This makes some sense to me from the KUnit side, though it'd probably
> be nicer to have a way of actually triggering kunit_unuse_mm() at the
> right spot. I'm not sure if we'll want to have tests spawn additional
> threads sharing the same mm in the future, too, which this shouldn't
> make impossible, particularly if we have a requirement that those
> threads don't outlast the original test thread.
>
> Otherwise, Is there a reason we can't mmdrop() from another kthread
> instead of trying to kthread_unuse_mm()? I wouldn't be surprised (it
> doesn't _seem_ right), but seems to work here.

No I think this works and it's actually how I originally wrote the
patch. 

However I think it's very messy, it depends very heavily on the
implementation of kthread_use_mm(), i.e. it is saying "I assume that
everything in kthread_use_mm() gets undone by kthread_exit(), except
that there's exactly one mmdrop() missing". This seems like a natural
conclusion when you've just spent half an hour staring at
kthread.c and drawing up a stupid little ASCII diagram to try and
drill this godforsaken refcount API into your head... But once you step
away from this patchset I think it would look completely bonkers. Here
I'm looking for a way to actually solve this with a proper API.

On the other hand, I'm now adding a weird special kthread API just to
solve this one little problem in KUnit, which people might reasonably
object to.

So yeah I probably should have laid out some other options in the cover
letter. The ones I can obviously see are:

1. The current proposal.

2. Just call mmdrop() from the other kthread and spray comments
   everywhere to try and make it make sense.

3. Find a way to call kthread_unuse_mm() before the kthread dies, with
   some sort of magic in the kunit_try_catch logic.
   But presumably to make that all work with faulting tests etc is gonna
   mean more special APIs, probably worse than kthread_take_mm(). (I did
   not explore this very carefully so it's possible this is easier than
   I guess).


