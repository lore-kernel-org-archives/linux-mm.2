Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DB4606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=djhtxDlm
Received: by kanga.kvack.org (Postfix)
	id 1C0D36B05B4; Thu, 29 Oct 2026 15:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170DE6B05B5; Thu, 29 Oct 2026 15:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060B06B05B6; Thu, 29 Oct 2026 15:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24206B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:27:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ECFC8048B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:27:11 +0000 (UTC)
X-FDA: 85376647062.08.3508CBA
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A169A000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:27:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=djhtxDlm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3DJ7jagYKCDUbleZplXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kuniyu.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3DJ7jagYKCDUbleZplXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793302029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdQRCRrJYOu5wxkzWtr5JmhvTpLm+/jNo5Ek6VGu/fE=;
	b=rPhS1o93cD2agQ74g+n+tVEhqgJz1ohJ55eUaqRa1FfE8qQFPuuGCw1EiihNIdAmsXVTJJ
	W42kU2S5xcv2kIN3GsDE0R9Y03vpzKFS6B6Mm6QI49tM24cdPYIDv1NRny+55iGJ1nbdIM
	ULJINRw0Z3/AF3MWLIBI4z1g17Swaq8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=djhtxDlm;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3DJ7jagYKCDUbleZplXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kuniyu.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3DJ7jagYKCDUbleZplXffXcV.TfdcZelo-ddbmRTb.fiX@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793302029;
	b=RbsetIxSDEFHspT/MZu4kvOcMMIPyyGvDzTRWMNGwDfnEv/YfII8vTwWNznWp9QOaVGXy3
	3rIGheec4sa1xhw4+PgkHtm07H9bUjWZEX7vk2HrBkJYbR/zE0toZPia2HNU3RoBmEMQfI
	RtgScDcRgPejPp47KCWyB5uLXBxmgzw=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd60a365440so1740806a12.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793302028; x=1793906828; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FdQRCRrJYOu5wxkzWtr5JmhvTpLm+/jNo5Ek6VGu/fE=;
        b=djhtxDlmtpb5QzJZPQm4KgNjfO34qNU6SazdsVuyRl3GMXdEJqKg94AiNjvCz+julX
         fw9W793zriOo5l9sb6lGQWsVDUStx2O4PGFjFMV70zWnC96S/w8/hk01ZI1yNRqoiPXo
         uHkBGARFbRcVyvlp0k7DEwM2KeYOgNbbSIBhHIMpjuGv2cx9/VrBFbZuM7EMAoL5HFVp
         OM3tPMmfViXUzqqMU36s4qIyTcmFIUUKJeg+nt3PxeL140KnaQzOEybqvsQBlTPXUKuI
         8aPQuvv6g8wAGwMhsBUszvfToJQKAL17IU6JXzXR6CPvwNEsvKVXALMk3o6cGyPMJStM
         l1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793302028; x=1793906828;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FdQRCRrJYOu5wxkzWtr5JmhvTpLm+/jNo5Ek6VGu/fE=;
        b=bTghtc3clD0Apl7eWkTjss2lrA/XFHFoihgKX14qXlGju20Jxs2Mhl32f8DOYWtnLP
         G7vaxU1RhO6wOzBZ2CdWl9NObVqLMCytmLvmibO35sMhPEwXWHHsb+En+ln7Klvniz4o
         q1HRM5jaMj0Jou1QcgDFO1GULJiRpgZUQV9rTfeXobcyw50U2ZZR0hOcJaORN0GqFHyP
         vaztT3M/iQAPhO1xiVZ9QnLNPRyiEK72XLrrYRgLQ1rx3lz7u+kquBvG+j616vzIXyG+
         L7uOQsNV/YQb7y2ljhxhfny7C4wQuxSzNd4r/ur0rKFQI8/gdyUcAUn7LS87ZfiyqlVi
         GLsg==
X-Forwarded-Encrypted: i=1; AKwUvBw51i06H7hcyI7xNiygcMJFX8gnGwA2JOxdWN+AhUhWAUWr2/qrIz4Jm+bzvN5Vt4zy0qpLgzqt4g==@kvack.org
X-Gm-Message-State: AFq9FYJ5+X2dHo0A2sdbHDPyug515N/PnvQQdnyGIO89g7zhcOEm8Ims
	qUI6kXa3AHyIKQhVHFWpYLUig8mwFSLwAnzkQlmZefZA3uQNB1CWb4IilSbmLfqD2AWDPnNrw15
	JzFvaWg==
X-Received: from pgbm25-n1.prod.google.com ([2002:a05:6a02:6199:10b0:cca:c02e:bfe5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6372:a745:b0:3e8:b7fd:6273
 with SMTP id adf61e73a8af0-3e928d46c3fmr159781637.25.1793302028204; Thu, 29
 Oct 2026 12:27:08 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:27:07 +0000
In-Reply-To: <auNQ9fjjyF5Xa0qb@thinkstation>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028194014.3671161-1-kuniyu@google.com> <20261028194014.3671161-2-kuniyu@google.com>
 <auNQ9fjjyF5Xa0qb@thinkstation>
Message-ID: <auOddgOVRE7EDDkn@google.com>
Subject: Re: [PATCH v3 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Harry Yoo <harry@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 9A169A000B
X-Stat-Signature: u7zwifgrctru7awog7nezayz7to4xqi1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793302029-604735
X-HE-Meta: U2FsdGVkX18FEYmzf20EfP3LSsej4qK4IDdiFcqC45oa0DR6nhrxhN3BkddkWe0ZYGUjz4w52ReStsmqWesaDfQt5D7OjSXDz8PH5qEDnQIsJGEFH7SCt7eV+o9g55lSDFcU9RLLWce4iljhDt5OclndsSWS8BDLV86g9guBtKeMKlyB6I6JZlbuWZSAxDMFN8EJLTHeoT3H2pxHAzEDsqi6oE4Rwxa6kPjJtwi2tiNWgP+r6vW9OPL6Y1tt0XKz9hNPt54wAaX3XMQkzulO/5uBgiExTDTccplWE2fmpN+nezbPwftkhWJyJ0nxhfZpRsmc7Umsv0iRaRCRe6WOS3nps/canYCwM/FIcVfLuSuAubhkYfp6Q5992LXTCoMm7js2v9SOoYPBEfGD0sOXThpyScMe5BYPXXIggmQCI8f6g/wnX48Uuy1IML9sK/8qDaQNRXqsc0WRCp+PaK3FtMQgxIv9w0GQQBu2pwGw0fT6GCkJgGUpKoOqZIGwkuOnKcdD2oDc7B8jyPSc251XUPWJ+o3y9sUtZ5NoYOwdNaWunLLLsYGq8FDXoovtAP5RFqi8s0m+jw7ci2dmUpNOx3aopxuR0E9zw782S34xeQps5gk6H7EJViB6bxhKUxSTaXxR7T6/qft9dl0qGb7rzYetn+5PRwa+T0a4HhQlx8wpzGgbhByOa1GXqptj78psMROm13mQqMzV89bMB6ZDysmZBVbXm5OcaI7lPOkD0PnidPlW/1zQWF/C90O8HyU+rqw83s1BBcYKfhot5wG3hy4hD8wQdTqWEM8Kir1RLdofoKKVSwSv16aIs7MilcKCBixg8C2XtLD8BEeZCclTsKBVmDJT8QmGp7kX0Ju5ub4SyZ4w9gPM1AxMaU3+WU8JoRP5lqOBBH/i15yPAdCsB9HIHlThwnzWWuWv26wvIsSTywEHiLBF64Afz0yCEsp1EUeUTh237M0ga28hbF4
 SOkxmFc7
 CwbGQXy+z6HOfcITl9VhQU2HCpl0qoxln8200nl4X9HUK72shOiB8rQnKTD2M6teBKNG+QNzb8a2FWppTPPs5iQkATcy9YtAkkgWIr6FidEVY9lSapJ59eF4O2T+TyLNe6phv6Dggca3RK1D0tIM3TuFhbag/ErGzDDV3/Ob+CaqR/GwOSlIzspzEAKKzB5PAIHuSSdpaUPmlfyySWMYMw10AF6IxzLjH2pZnwFnWOZT6u3Z5uhBONFktLPm37zo1g/FZSpfD5iw0OUz1Tw9UZhX3oyjABShWYlQees4v/Kru/D4qWKv3aOmJG3I2+wlYcsyLKWCbVP9CDQ4MQPNu7F84u693izAzKi7YTOuE524shNiSSBaZBno9VN7Ok759bKtKnYUBAzB0DjGLBL49A/4r0abJTeV+oCa7PRqJIm3pK2Vhyk1IfrpJ9REgJpSSHo+5Yhendsj48lmNB3PKnr9VkyPW+GoGQLNU3AYdKx2hMXMzOTRwMPuJvKHE2EaKkS46qWss0mZ+RCEcf9kWBMCtQ3a4XCfIpc48Zl4G8lUG8b4X3mG0RmqTRMYnv/pzQ9SRwT6tt/de+dMzgEJx8LteSvwPymj5DDrHxm0Tcdxttn9W4yaTh1K7ZQ+tddKZAq8Y+op9FR2iQDOd7tYbsPafSsKxIE0qEgZjdPFniRT3eqr1dPxpFtHDMz8C5Qy+bwL9Y0ra/9EL5J5mIbekY7i5MzGCA5olfIYcOU/bDWnTZEcKGGTgFJhydw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 14:07:21 +0000, Harry Yoo wrote:
> On Wed, Oct 28, 2026 at 07:39:19PM +0000, Kuniyuki Iwashima wrote:
> > syzbot reported a weird use-after-free splat. [0]
> > 
> > In the report, an object in the kmalloc-64 cache was freed via
> > rcu_free_sheaf() while it was still in use, even though the
> > object should always be freed with kfree() (in xfrm_hash_free()),
> > implying that the object was a victim of a double-free involving
> > kfree_rcu() somewhere else.
> > 
> > When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
> > queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
> > kasan_slab_pre_free(), kasan_record_aux_stack(),
> > debug_rcu_head_queue(), etc.
> > 
> > As a result, KASAN cannot detect the double-free at the call site.
> > 
> > If the object is still in the KASAN quarantine when the sheaf is
> > flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
> > with no trace of the suspect.
> > 
> > Worse yet, once the object is evicted from the quarantine and
> > reallocated before the sheaf is flushed, rcu_free_sheaf() silently
> > poisons the live object, resulting in a false-positive use-after-free
> > report on the new user.
> > 
> > If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
> > can detect the second kfree_rcu(), but only while the object is
> > poisoned in the KASAN quarantine after the first free:
> > 
> >   kfree()     --(poisoned)--------------------> kfree_rcu()
> >   kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()
> > 
> > An object queued in pcs->rcu_free remains unpoisoned until the
> > sheaf becomes full and rcu_free_sheaf() runs after the RCU
> > grace period, so a subsequent kfree_rcu() or kfree() before
> > rcu_free_sheaf() cannot be detected by shadow bytes alone:
> > 
> >   kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
> >   kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)
> > 
> > These cases can be detected if we call debug_rcu_head_queue()
> > before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
> > free.
> > 
> > To detect these cases with KASAN, we just need a 1-bit flag
> > to indicate the state, which can reuse an unused bit in struct
> > kasan_track.pid. (PID_MAX_LIMIT is 1<<22)
> > 
> > The bit is marked along with recording the stack trace when
> > deferring slab frees in kfree_rcu_sheaf() and checked in
> > check_slab_allocation() so that any double-free pattern above
> > can be detected immediately.
> 
> Why do we not need the same thing when it bypasses kfree_rcu_sheaf()?

In the fallback path, we can detect it via ODEBUG at the 2nd
free, and I wanted to focus on SLAB Sheaf in this series since
it was the initial motivation, but I'm happy to follow up
if we want.



> 
> > Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
> > Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Tested-by: Alexander Potapenko <glider@google.com>
> > Reviewed-by: Alexander Potapenko <glider@google.com>
> > Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> > ---
> > v2:
> >   * Add Fixes tag
> >   * Add kdoc for @after_rcu_delay of kasan_slab_pre_free()
> >   * Rename s/kasan_record_aux_stack_rcu/kasan_mark_rcu_free_pending/g
> >   * Add comment for __kasan_record_aux_stack()
> > ---
> >  include/linux/kasan.h | 15 +++++++++++----
> >  mm/kasan/common.c     | 13 ++++++++-----
> >  mm/kasan/generic.c    | 17 ++++++++++++++++-
> >  mm/kasan/kasan.h      | 34 +++++++++++++++++++++++++++++++++-
> >  mm/slub.c             | 13 ++++++++++---
> >  5 files changed, 78 insertions(+), 14 deletions(-)
> 
> -- 
> Cheers,
> Harry / Hyeonggon
> 

