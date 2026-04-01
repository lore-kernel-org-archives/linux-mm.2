Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B39D35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BC46B0005; Wed,  1 Apr 2026 04:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B51C6B0088; Wed,  1 Apr 2026 04:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4696B0089; Wed,  1 Apr 2026 04:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04D446B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:24:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 914308C209
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:24:43 +0000 (UTC)
X-FDA: 84609300846.07.EA62BE9
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id B091320004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:24:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILT4qvGp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oi8b6kNbARyFvnrDLDVCGkFE4VG0ORxMai3aXTvGZjA=;
	b=lqy3qY13cYndSXCBBPW0fSsVqp02Bo+VBBJ7ibZ5WbZMFGAJMfwFa9mT+8CTCeW/stPn1W
	aJhZLm55qti6SFggaZhgOhVSTHJjDPsTrrm49QxyyBMLWVtCBXugclMtHAyAVuHglEvYj2
	0KKEJH86bq8WFYVKL6s2Ki+sKMDbKTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031881; a=rsa-sha256;
	cv=none;
	b=Pa0b4EkaMHn2Te4vf2jatoXYXc53Uw3u291IC4pFO8Spqy2Yp3p/EjpRBE5nzYt1NbS62V
	x8dNL4fOTpKY3cz0sTGKO7fPUcGW8oAuLqJF0PjiWbWHrvy+KLgTdQNtasnC3qcL1Tfhwb
	DkHbsRpXcZWkElBKx2O83blZsb35wtQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILT4qvGp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82c68339cf0so430542b3a.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775031880; x=1775636680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oi8b6kNbARyFvnrDLDVCGkFE4VG0ORxMai3aXTvGZjA=;
        b=ILT4qvGpQoNpniQxDHk0ZMpFDEI1HV/TOaRawdgW5I5zlrvcXbZaMP367AWTqXsVEQ
         g8lNqDGNgOl3knd0dS/D9doEOBAiHb9m2y90STufA4h3nKNCoFlnTiUlTI9xHJH1ppaa
         jDlehDTGrvHM0tG5g7++Cy7A+hGUsXjt+JTF5pRmzUbw/QIkYDcRWI4nWSmE/nsK1yfj
         MZ31FDDU33/UK1yEtp7D+8mfyrveYDmkBcSRUvLjI7OCPlUCp5T6mVODaXAIhB8tvhwP
         CwBgW1xlERwdXMxjCYpNlPPYzIyBguwA6sf1+Q4Ve9D4QoG/CuffbYEJnatJdjAJDCS+
         36bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775031880; x=1775636680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Oi8b6kNbARyFvnrDLDVCGkFE4VG0ORxMai3aXTvGZjA=;
        b=DEopGZejijaviTFJniQ/OkWVWKAeK60QieAIPXw23oTmRXH9KoCxZHs/SuNTfua0c3
         q/wFOq2j8s3nVPxu7m9BzQMq4Z7gQNz2/pP8U1r1WceO10kPapKP38E1cixrZ8pSt13n
         3dsd8ZfP9Y0yiaCNeCR6K/JwzVsdyKobPNT1Fljf8eGewnsPVgzKIbCDuTKZKFaZ5Vw2
         97gAQr2CGFAI5biqFMVt0Ih7fZnRg9SXx+3hhpFq25LNIcehbGLy9sexF56h/OZeOYYL
         7BlymdvGfkdQHg3KjQrsOwlK6/X++KRT8VzYX0NYBKq5CKfBxdkZmtpJAEtDenVCHbdx
         sZAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0x7ZMIMkk6+FD6FRFJiY/M0H8lvIcUk66pI1zXcVDY6iCLnbU9xTBGsmNAXy2Dt7cXRCTHxuKTw==@kvack.org
X-Gm-Message-State: AOJu0YzdrpDuyale1mZ+uUoHvhRDMkVYtd7YMD08HVmF/qGDnBUP+oq/
	EtKzOKXSabENm7KlL8draDThuApx0YAWSGwc+Cee342PrRoafMY7Qawxu3tAGA==
X-Gm-Gg: ATEYQzyqKWYARRHbVjKZiL0wzAM3WbGqCR26Smn4YuAE+Gp2pGjxDeVlKOjixyaa4bj
	jTnW6fgO3eJLR852BOw4onb6fq/rGqUTlHAWi0yJqXWJo1ZIp1gJJQIn6JecE2pkpZiNQua52fl
	hV7hlMOurShrKIpIsjFwB1Nun5uy0AYeueReOjk/qnK4An0IGAglmevYmJJa6WagnU2oMnRimwf
	wc5a77iNRxd/SB1aBjMgNscCsqv8lkcN+Cq24egQ2FMVQgx+ydv5UzPGQ24iD43zZaWAjDYuTmb
	JzXJGTPNatXB8NUE2/C10K0GkPcBIjj3/sP8AzyQ0HsdCanS4Ip747gdr9jMzefm/TSSqTwzJJL
	zDncGSb15/wDBxU4CChx2q5QFHaynuwnY61Q1LdV6QJVGhtwF3uuAXpkSDOlVHbchTy+yfTreG3
	tgLyp+XOl5iZ2CqT8w9m28b3Pt+XStZsTsg0K5DDjRbEK/iGr1STjD9rwPXso+Lw==
X-Received: by 2002:a05:6a00:4188:b0:82a:7918:7f4b with SMTP id d2e1a72fcca58-82cd66c574dmr5739470b3a.34.1775031880237;
        Wed, 01 Apr 2026 01:24:40 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cec36da5fsm2597927b3a.2.2026.04.01.01.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 01:24:39 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed,  1 Apr 2026 16:24:39 +0800
Message-ID: <20260401082439.12612-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401004400.85613-1-sj@kernel.org>
References: <20260401004400.85613-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B091320004
X-Stat-Signature: xcqbubirjkb74q4aqmft3tcz1pyk3bft
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775031881-333757
X-HE-Meta: U2FsdGVkX18FFL6JgLy7j/LrR1lgea79vt5fkzCnq67VsqzFBg3M3AfVkPJakQMxWG9k3mbuQGWktdSo7BGh5kysvMy7yRwVll80hr+CJv1dk+FCM2BaAGHpeGZoCd9tcDThKOdlySODgDVsJhKG5NfsvbaI3yN0poCROLH8yU6ycC9vlEGZQoCKgvEwQouDBYf0bWSb0n5IzdtZLKGARS0+g1ZudQ7QQmTeFS1qoVbfdd4EB68nGA+47MY41cyJFei3ZqdkNmoE4zS8dZyqmg5uD12eaTQkx3C6axudkXaLDVlkeNwrZ/rcelvsCy//kDm13lSZZrooZzRrDi/HPw7QEdeZjgp2VRq5PjixlBw9SF8lXk4WWCSbF6PEUbm1Cwperx67fxTxIVWTYwjICb9exG9Ipr6CigpJYm3T9UrEyB20ScYHkyADWhz0huGWA444MrfrZnyMs7dduP1Wx+O8ieZPxhBp+aH5KjvmorSymdbdf/Fenbz0drv2kRIamhXJ1nv37yjR4SLxxaVzUWK62uKNUBUPklBA1P0NVKDF1W8hu9EzjOCT9O15ddHG6baV5U4YCWSXzHG5KF5u0eU5YZQ9lOuh4kSZQbAGYgHUq7ns+YZlGq35tQnncwlTQiNCL/ZcarFr/4E/suzf/bNPsl/APAaeO2SiWuhKOfT+U46ZJbb9VInZFuW6vGlHcnRnAmUlNOdiMZGO8hKyq3E2hCUeQARHlPtv+JpXjbiyfUPTV0gh7/aIzAmZt7uw6txFbLadCC2a0UqjxCBWr2wqkMvd3dmOlUTzEcuO2xayMfGBl0qifZYHUPUQQJtwMNn7qPKOuSJnauwwEcOVfF/yydzqs+IL6hgbJfhlWG4HnAmejaPFePsqskoFG+PMJ6nL3MGIC0tqAu2y/JaUZRy0QKdEEcyjpkWL/u0WVoau2R971C9H1w4xhYtxxiH32IYzlM/iqScDFVCiZg/
 uhs3yLr0
 TBavdjP94f4k5mbUPksu84Nb4OqgwqyOfREmGD6Kbtx5ZzLcafqM+WuMwKtaeXSO5E0aBRzo/Lf/qfomRjEMmwQ5Fidr/ywKKfUuih04lS5ACdPgrI9wDBi629MM4Cq7eOaB+X2QVfNA0jjrdZDxDtEBFuBL8Mifwv6wao0Pa+UqVf5aFwwb/8pqGF07h0iBfSUKxa7A1AxWAS31oXo8W8yxenmz3XAHgAb/gNcECbf3MpRTHHnDEXoTBNfV1PV3BvzFfKW4Q3LP+eVznsCJ46JpIoPYsRgSNCxB4mm3UH314PI+K0xC017tRkc7djEEMvLfv9mK1Z7ki8uyO6GuguM5g8NZosB+6zqQm4d4BmBh2dKUDIx5A0fbxrABlLL7cpK6wnUaPB6rYQd5U+tEpqCvPFpFxgDXRqVtJjrWEFLgVheSiQY/PGv5QqpRQTE0EZ3+Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 17:44:00 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed,  1 Apr 2026 00:09:56 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > > [...]
> > > Option 1: Introduce a generic termination callback
> > > ==================================================
> > > Add 'void *after_terminate_fn(void*)' and 'void *after_terminate_data'
> > > to 'struct damon_ctx' or 'struct damon_operations'. While this extends
> > > the Core API, it provides a clean notification mechanism. When kdamond
> > > exits for any reason, the module can perform its own cleanup (e.g.,
> > > resetting 'enabled' and 'kdamond_pid') within its own callback. This
> > > keeps the core logic decoupled from module parameters.
> 
> Maybe this is the right long term direction.  But to my understanding the fix
> should be backported to stable kernels.  Is that correct?  If so, I'd prefer
> simple quick fix that can easily backported.

I agree. While I hadn't initially considered backporting, this bug
certainly warrants it. A simple and easily backportable fix should be
our priority for now.

> > > Option 2: On-demand state correction in the module
> > > ==================================================
> > > In damon_{lru_sort, reclaim}_enabled_store(), if damon_stop() fails, we
> > > check is_kdamond_running(). If the kdamond is found to be terminated, we
> > > forcibly reset 'enabled' and 'kdamond_pid'.
> 
> I think this can work, and simple.
> 
> > > 
> > > My perspective
> > > --------------
> > > I personally prefer OPTION-1 because it ensures the sysfs state in
> > > synchronized actively.
> > > 
> > > OPTION-2 is simpler and avoids API changes, but it's a "passive" fix
> > > that only triggers when user atttempts a write operation. User might
> > > still see inconsistent value until they try to interact with the module.
> 
> I agree your concern.
> 
> > > [...]
> > 
> > To avoid over-complicating the Core API (Option 1 or current approach),
> > I've implemented a lightweight, on-demand synchronization mechanism in
> > the module layer.
> > 
> > By overriding the '.get' operator of the 'enabled' parameter, we can
> > detect if kdamond has terminated and reset the module-level state right
> > before the user reads them.
> > 
> > Since sysfs parameter access is protected by 'kernel_param_lock', this
> > approach is race-free and keeps the DAMON core decoupling intact.
> > 
> > Core Implementation:
> > 
> > 	if (enabled && !damon_is_running(ctx)) {
> > 		enabled = false;
> > 		kdamond_pid = -1;
> > 	}
> > 
> > 	return param_get_bool(buffer, kp);
> > 
> > Test Log:
> > 
> >     # cd /sys/module/damon_lru_sort/parameters/
> >     # echo Y > enabled 
> >     # echo 3 > addr_unit 
> >     # echo Y > commit_inputs 
> >     # cat enabled 
> >     N
> >     # cat kdamond_pid 
> >     -1
> > 
> > I think this approach is better than my previous OPTION-1 and OPTION-2.
> > Does this looks good to you?
> 
> Looks not bad.  But, what if we read kdamond_pid before reading enabled?

You are right. To make this robust, I could apply similar '.get'
overrides to 'kdamond_pid' as well. This ensures that reading either
parameter would trigger the state synchronization.

Would that be too heavy? Or do you think it's unnecessary?

> Also, what if the user simply try writing N to enabled?  Wouldn't user still
> see the partial-broken status?  So this doesn't seem gretly superior to the
> option 2.

In that case, we could modify the damon_{lru_sort, reclaim}
_enabled_store(). Before processing the write, we check if kdamond is
still alive. If it has terminated, we reset the 'enabled' and
'kdamond_pid'.

> Based on your above reproducer, I understand this issue happens by the
> damon_commit_ctx() failure.  If it is not wrong, can't we catch the
> damon_commit_ctx() failure from the calling place and make appropriate updates?

Yes, we can. We could check 'ctx->maybe_corrupted' right after it
returns, and reset 'enabled' and 'kdamond_pid' immediately if it's set.

Do you think this approach is feasible?

Best regards,
Rui Yan

