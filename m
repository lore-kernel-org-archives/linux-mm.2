Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D67FCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 13:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98838E000D; Wed, 20 Aug 2025 09:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72E88E0003; Wed, 20 Aug 2025 09:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86C28E000D; Wed, 20 Aug 2025 09:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95E1B8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:19:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DACC1604BF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:19:07 +0000 (UTC)
X-FDA: 83797191534.23.9275C38
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id AAF9C40008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:19:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FauLlOGe;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755695945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAMXUsIDqPU8hdhM2JBX5eSeLOvw6AYekbiBZi6aVVM=;
	b=cg3F6F0JkhaPRE3yhVjuw7svtz/RscbVZePGJsm2B1qfBCZv/hy+2Aep2jf6zsnCImK2zK
	jnjvKjrATsoZKTb/6Q7H1DG67rLtjBRcWWonhS2c9MB8lp6bs1wX9Y4zCoJSa0JULYy6En
	5p0i3cJ1rssK6ImmwMySoh4BCtAkLd0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FauLlOGe;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755695945; a=rsa-sha256;
	cv=none;
	b=of3zSKnl1n425qVEhGeypA3KE5P2Dwmsg9OP0oX86YUHoKg+R17RY2pdBC1g3YxKCiYi9i
	fE9H/50HghOBraiLUqc+osQZ+XjpYuAW5vr9uC19BaOcykOjgqIcBuFYKuwww1TnPp++eK
	0EJm5j1/Qx99Zvuu6B5ONYiQ+FHiwNA=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-61c044ff13dso1131014eaf.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755695944; x=1756300744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAMXUsIDqPU8hdhM2JBX5eSeLOvw6AYekbiBZi6aVVM=;
        b=FauLlOGebv1EjoOVrNX/9guuSsT6IUKgYkPW329Vg8FnEVfdNmK9FrOeD6A9cEefIv
         EtK0htuKXOYRTH+LWXreFwzZQZJVE7PN+aSniG8OqF4uH5rkc2jcIHbFOxypuSWoLEqX
         uM6cROA+eXXVPRU/IAuaOts0pc9Y070dmsaoV+13uCmG4XKFdrEsgFjmiFozcKfm2I/q
         qhsZUDjP6SXLFM3Yf1ygu4AhLSavZr3biOESTpX9A2a3xF6+44tHWe3FgT+oeGo1iVXd
         W7eTiXaMLcPVIm2QEC0275Jzrr7/I0qB613V3HrDUsswgqyuO28YpXPr0Xyhl8xyr3Fh
         b1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755695944; x=1756300744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAMXUsIDqPU8hdhM2JBX5eSeLOvw6AYekbiBZi6aVVM=;
        b=ptZs6AuwVsED9J7RDOFJycC+5Przj7F4J98SxqI7PQqCN8QGX7KEU7/R4VJTH8C6h3
         ahe2fk/SRNHefCNrTQJRjROtIxoFnTn1SBXKVRwaNJTe/OO+3ctm/tbe9jjKenYvFU2o
         A5Aa8eprFrrA9EiNBBFMwAt1vbTU587l5oWk8EJYduGPxvVviEaZrzXBsFIdY7AI9rKx
         t7klB5s2+UN86WSMMgNTjUcWFTmPGRUXzsTo+jYOOr3D5GF1BjTrvaepNgd6rX0PzJ6I
         +CGdfRPef/DPfWc1UlIGdzuy+h5f4s1h2pNmKLpjYOkJE6MsrUUsdKu0yw4MWXGJpRrm
         jxmg==
X-Forwarded-Encrypted: i=1; AJvYcCXTV/Y/wI+Ooe4269VCFBMOQLW+ENRID0owDYaT7xiIQQlOQfS9VG0n2cuyMkXHrS6OmIq+jYRUnQ==@kvack.org
X-Gm-Message-State: AOJu0YzaalCp5yNfGWJU69mLibXU5eBMy+MX4YhvRQGt78G5DE6PKG0m
	/t46aQD/P/dk50/JDtHzkJeGTqWr0Jp6FLhpo3lXEihFRC1xi4IKea5iWvl4rO/5XuElvbS9DFv
	W9K95n76kDrhPYyTWiAvmnyQnCh7Sylc=
X-Gm-Gg: ASbGncspT0JsUC29xv2ivAXvZ3pP8HfQUEvKkYHVpifgKzYl6gfPv6QS6/dQt0nwZ8X
	NSW8ct+/TfGSgG8WW6KNO5t5I64u7qqrNhbmq8X/pv22W1/d5nlK8qQqCL0KZUgy+AzQg9q6yFu
	TCBKWnhJGbNxzvDJ51HuxcvVFijUDRh0AkDk7DzfTuZEPLnSETc5MuNd/j1E9ALPVmpOt2AqgV2
	NNk
X-Google-Smtp-Source: AGHT+IGr8rKQBFa7oMvw8UPeCjSuZwPpiw0MQs64usnbnAp1T4vxRigxd2e5nQ9hOelY88Xonn1OALndKlXWmb7UviY=
X-Received: by 2002:a05:6820:2214:b0:61c:378:acbf with SMTP id
 006d021491bc7-61d9b6e1746mr1657811eaf.5.1755695944429; Wed, 20 Aug 2025
 06:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250819150123.1532458-1-ekffu200098@gmail.com> <20250819172718.44530-1-sj@kernel.org>
In-Reply-To: <20250819172718.44530-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 20 Aug 2025 22:18:53 +0900
X-Gm-Features: Ac12FXzi0_NOd2NnDrtbBEuBmHTiFEm9xR0_nofBUIe_5yrnjsOC7F9A8Jr1bJE
Message-ID: <CABFDxMHpodpNQM_a=T0vf48k486mYqukCVnQPbanLh+G_HH+9g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hs678i78z9jbqrb3y7pnxoo5o7hh3bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AAF9C40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755695945-18949
X-HE-Meta: U2FsdGVkX1+6/0N+2hhpy1xlxIMts/p8NvS2MwVEQ4yLLPbd/2u7SdOezgzuHvQVLOUonZ6a7fa5wE+rA1yH/GrUz6QKRh6GOzEBOyI7iz3o30kXpD5fXL39j4pg2+WR0gHwfrko1iJ1NggnG2oe78reFP3s54wZn4XywJuvA8oEjSPmeFEV81iTxlg3GwVLNAZpmS6ZcSQxBVuPGj/31XCq4mK4nWY7Xu7MpHMJTiVij5n71wp6j5aKASSN2cJrdhIHca/PF95+ymPDgqylHIiBUEgpbXuRh8vPl4wsYNpDMPLEB0QgajuSXQ+irYs0RtBb0dzKTDOTFkAI+WjD1s/od3NFTenFkcdBLdGFHH/D14WJpSNJ4Do57jfO9fDSGKUsIEpoxCuocQnTJWz8M49Cy6kIRWPkpqw8yPXoMe4WnRcwLN5unoWkOg4+VBrlHI0tcWKGHg/3BTjd8tdBYJ/kAWZET1PHgHZ8Q6KWNaYqWxtz7imLsbLJ/K58S7rhtZvt+r6ODrE8JVAp3W5lNby7N/GLViCtG1muoR+d8Weo8eWokXG6akFjevyuvyX5czkl9cwZ/PoVoDxoWvelW8vHvEg8sx4NFRUsTAhFAwxQE4sGZIPNadnH+inbPPMrxHrmL+Tk2xSku/WBrT/+2L8mdg4FWUKDM4kJKnpaVld6s4D9SrwYyWna1ihG56a3FAXlbtc9d/Q3qD+/Qp2iVIketdrQjtxGK5s14LCEc484vJXmJJ5rMLSJ4ZyiiOC7J8AJt/jZqRkZl72zCcugtE8L62/EqgS6ZrO4Q9KTgmsjA7qBDl8hjPG36n9KdDoUU7LwnNNXcmdVwyE6X2iDUz9PpwfJKhXyHwlsuTxY6d0UpzyHzTnXw8CXQsdHA2k6JGG+jj3BVSmO81Kja4cMUmDCVHblXlAonyd1yQUTQFKcNpkDlf7fCmasrslCLMjTJ1YmoCge3dLwgtXCVJU
 ZwK53lHO
 PAxyYFBDqYUULlZ8rfx8iOeffWJKVAA45nhty8kf+eOlCbollTyhcNAjAXCk+it/GYUcUP2ILvFAf9UBbgbFaoO771u0KyJsM+apahc54pvi93iz+EK9rQ+Waq2an7etHvzY7dz//ev+x85fCJJ/mUXI9x7v7Crmykxr8krukkpyjeuGYioGMwupPQZgNG3gG4yVMTdFFrvCdToeviF3LfAOWbggo3hSpLM2QyS0PWCRTe5vg5ItnYxeTQybHe1dwDM3a5OOXyMXN1AVm2VReY7skRVy1BcFlC4V1P584tIrl3ryln7Q8upPWJxKcRr0mAzx3KuAeJWXgWV0Wr8J43mXYOcFlmh0/tEr4OL5xQD9rtl+cwCehZosuj7mOWQMbywVRLnNBiEDIUf3/6siyDGvS3kOSaDpSpKGG/Aoas1Wlg+8eNWV8+CsnyDgak6RsdApk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, SeongJae

On Wed, Aug 20, 2025 at 2:27=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> >
> > /*
> >  * Have the 32 bit jiffies value wrap 5 minutes after boot
> >  * so jiffies wrap bugs show up earlier.
> >  */
> >  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> >
> > And they cast unsigned value to signed to cover wraparound
>
> "they" sounds bit vague.  I think "jiffies comparison helper functions" w=
ould
> be better.

I agree, I will change it.

> >
> >  #define time_after_eq(a,b) \
> >   (typecheck(unsigned long, a) && \
> >   typecheck(unsigned long, b) && \
> >   ((long)((a) - (b)) >=3D 0))
> >
> > In 64bit system, these might not be a problem because wrapround occurs
> > 300 million years after the boot, assuming HZ value is 1000.
> >
> > With same assuming, In 32bit system, wraparound occurs 5 minutues after
> > the initial boot and every 49 days after the first wraparound. And abou=
t
> > 25 days after first wraparound, it continues quota charging window up t=
o
> > next 25 days.
>
> It would be nice if you can further explain what real user impacts that c=
ould
> make.  To my understanding the impact is that, when the unexpected extens=
ion of
> the charging window is happened, the scheme will work until the quota is =
full,
> but then stops working until the unexpectedly extended window is over.
>
> The after-boot issue is really bad since there is no way to work around o=
ther
> than reboot the machine.

I agree with your point that user impact should be added to commit
messages. Before modifying the commit message, I want to check that my
understanding of "user impact" is correct.

In the logic before this patch is applied, I think
time_after_eq(jiffies, ...) should only evaluate to false when the MSB
of jiffies is 1 and charged_from is 0. because if charging has
occurred, it changes charge_from to jiffies at that time. Therefore,
esz should also be zero because it is initialized with charged_from.
So I think the real user impact is that "quota is not applied", rather
than "stops working". If my understanding is wrong, please let me know
what point is wrong.

> >
> > Example 1: initial boot
> > jiffies=3D0xFFFB6C20, charged_from+interval=3D0x000003E8
> > time_after_eq(jiffies, charged_from+interval)=3D(long)0xFFFB6838; In
> > signed values, it is considered negative so it is false.
>
> The above part is using hex numbers and look like psuedo-code.  This is
> unnecessarily difficult to read.  To me, this feels like your personal no=
te
> rather than a nice commit message that written for others.  I think you c=
ould
> write this in a much better way.
>
> >
> > Example 2: after about 25 days first wraparound
> > jiffies=3D0x800004E8, charged_from+interval=3D0x000003E8
> > time_after_eq(jiffies, charged_from+interval)=3D(long)0x80000100; In
> > signed values, it is considered negative so it is false
>
> Ditto.

Okay, I think I can fix these sections with explanation using MSB.

> >
> > So, change quota->charged_from to jiffies at damos_adjust_quota() when
> > it is consider first charge window.
> >
> > In theory; but almost impossible; quota->total_charged_sz and
> > qutoa->charged_from should be both zero even if it is not in first
>
> s/should/could/ ?

Sorry for my poor english.

> Also, explaining when that "could" happen will be nice.

I want to confirm this situation as well. I think the situation below
is the only case.

1. jiffies overflows to exactly 0
2. And quota is configured but never actually applied, so total_charged_sz =
is 0
3. And charging occurs at that exact moment.

Is that right? If right, I think this situation is almost impossible
and uncommon. I feel like It's unnecessary to describe it. I'm not
trying to ignore your valuable opinion, but do you still think it's
better to add a description?

> > charge window. But It will only delay one reset_interval, So it is not
> > big problem.
> >
> > Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for scheme=
s application speed control") # 5.16
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> I think the commit message could be much be improved, but the code change=
 seems
> right.

Once again, Sorry for my poor english. I'm doing my best on my own.

> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> > ---
> > Changes from v1 [1]
> > - not change current default value of quota->charged_from
> > - set quota->charged_from when it is consider first charge below
> > - add more description of jiffies and wraparound example to commit
> >   messages
> >
> > SeongJae, please re-check Fixes commit is valid. Thank you.
>
> I think it is valid.  Thank you for addressing my comments!
>
>
> Thanks,
> SJ
>
> [...]

Best Regards
Sang-Heon Jeon

