Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F50EE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 05:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3B66B0088; Wed, 31 Dec 2025 00:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61906B0089; Wed, 31 Dec 2025 00:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DF36B008A; Wed, 31 Dec 2025 00:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8821D6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 00:28:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F772B981A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:28:08 +0000 (UTC)
X-FDA: 84278635056.03.62CB594
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 619E540005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:28:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+P4VHSD;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767158886; a=rsa-sha256;
	cv=none;
	b=Uft/3kdnT0w18JhPhMnOcU2UhGSIJ6tr5rNkEewesdK8AOeltUm15UyhCortfVVysC+Z16
	WS0T5N+hHl7WN0pk1zECxpZ6og95Ap+DRCk+SbIQCcv3l2zhON/w6/LM35bl3/XMX6xu8X
	fQVxyAgEaB2n9k4pxXOxHcDJa3RVNa4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+P4VHSD;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767158886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neE2xjkWXwgvUgGg5ZJ/mbPsEp4n4zK4JeRN0ZAZy7U=;
	b=SsuK6CFXcTdeRARjyyg4+wAtvyJpvR2tIgC0jR2v6dEPaytw6wbtMAw/nlLwUdDFCwO5IN
	SCdglZP4xpkCRncf1g7jdswSAQqx5UoijtBFhAgxw7hQkbXfRVrECQaN1t9wQe5G7nssvy
	0ESM7NZnSDgo4dKBmrwo5P6KxjlBmwI=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6446d7a8eadso8629657d50.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767158885; x=1767763685; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=neE2xjkWXwgvUgGg5ZJ/mbPsEp4n4zK4JeRN0ZAZy7U=;
        b=S+P4VHSDQv7mQYXKykJt3fovvIJ4yqucNV2PYpWQYHCxFtRxmZ4R6C9VNw6EFUA3yN
         qkeYoWwVYhRYrnftvnmVGuvmvR+T+WCYHw8r0gc9ZLpi1pxPuHwR4ujFdZDlbSpF9ASN
         Su3mBVVOM1FKedLVYnl49BMmChRTlDIdX+0zWs0+qO+jPS4tHc9oGOkIIa8Z5BBoqaSY
         CyyNmbr7SnBQGx3WHXmJwrWpMvrnUNKICrvvKt6XS9dUKCpF1cWuJ3ol3l38Cxv99O3d
         91FnIVfV4LT1SJdpq7niEvYinYsOvCf9Eh4IlEgdv/MAnHng1K3xAX8QvFMTm/KhbOIq
         LwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767158885; x=1767763685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neE2xjkWXwgvUgGg5ZJ/mbPsEp4n4zK4JeRN0ZAZy7U=;
        b=d9lWNyGtYJMBNN6khMi9+VHel+CwJjhgRWgyYdKzibvUrzkJ0Sl1+Ab9jo2bEv7KRS
         P8ql9bQ7ZfJiTkMAMIvtUwJeS/7hjxmCR/uN1SBu8OFP/LMvJ0jAdhwJjfGyL2tJao4J
         TB0gkCrrGZ76Ok24lCeU+EuS4/rEKX1MAaGD5On2MJQSRxeReX/jGKOBy5ZklFubA6+y
         NNoH1DB9FzE93v3Vo72uGREtSoVjeqBj+UrQILjmGjX7zapficCZP11XTV+Mc1mkFXSI
         QLem0GKBwIB7fS5M8SHlYw1xyAo0eFkno9FpSBiYxvT8BNvuMMYjo8GGTFoQNWMlq7Rk
         f7GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfmF8XYvnVehJmBXB7Vso5z/ndFJ/DsYw4a1NPk+i4arc8s4OOPI9gLYKuvTu9tiAN8o9QdhRwSA==@kvack.org
X-Gm-Message-State: AOJu0YxMgHtTNwDurSRwfE9a4BkJUHOPLrfA4FY/qp9H16QbWPy9gWxz
	l+TtG4GcIAgaT7Or1OciOvgEsXA8fZ6c8DRATMMjzSOnbCu0u0TA9V1KKEhYfjmftpRQEsKNBPy
	QFmLs/M5xu8NlJPf38P9FCTlnr+/+Kc8=
X-Gm-Gg: AY/fxX66dDTZku6aOxA3+Pd0TEFRE2vptFayD6V3LXzD2Tz6Qx3aHyyzNqBOaM6eF9b
	oOFXph5IWxauypl8WSZBymjgaI5VkU0AcHzX3NfvQRQkd7kmwF/Mh3P4M7EnB2P87zgOg9DgZQv
	6b+Ckso/7tm87vnDi/UKjOwDJeVCV6QVkss6K0EJcgE7NUJyCLPtvfy1+1tEpIkcOiAZQTy6XRv
	nf9SoZwys0seJecTB8YLGv8jUd7qoLMdXDatcWxVcUvPxxUUr4vE00T5auVbxEZEKG1Bim0MJZG
	dTpJPWk=
X-Google-Smtp-Source: AGHT+IEXZaIdD+WLGv3jQi1HvQb+WET+wjlJvMaD1oEmCvE1HqOdYGi+snxXD9Pe5VDdymn3M0Y1Zoc0IoKr3Gc7U/Y=
X-Received: by 2002:a05:690e:bcb:b0:640:dfa4:2a6c with SMTP id
 956f58d0204a3-6466a8b6e4fmr28144084d50.63.1767158885298; Tue, 30 Dec 2025
 21:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20251230034516.48129-1-sj@kernel.org> <20251231012522.75876-1-sj@kernel.org>
In-Reply-To: <20251231012522.75876-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 31 Dec 2025 14:27:54 +0900
X-Gm-Features: AQt7F2qc4ikpHLFjT-n4BMfolCsHaYaz_KyU9_25Xqa-F_N79PKbP9l9_QEVNRY
Message-ID: <CAHOvCC6F5zLnBF=v7G5k1WdDZZmkBAK94ixzLiPF0W53wdtyeA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "# 6 . 14 . x" <stable@vger.kernel.org>, 
	damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 619E540005
X-Rspamd-Server: rspam04
X-Stat-Signature: cffkjaipi8np8fdma4jwb7cbpy9cfqu1
X-HE-Tag: 1767158886-225327
X-HE-Meta: U2FsdGVkX19fQllKDbiDXWLRUO3NOoEOOMeMy3HMGzj1L+/QmPTACqlspW38Hh9zK2k8BkTX3y5l5bzUKNIbOAxyeifC9SynFXQs2Nv39ezuoIAw9CztPNpYFgigGCVMpjJJMMPPJssWw8/VLaH69vDp/1Fbwm8OTIOILnKKAypTLN7z9fNrT2LKfzSNXCyIARrBeHCgHSZ7ojVX7bAazRg031aiQbmEy6DXnHmrI98kfPokmj6yZ5/fsWPSePPYE5JDL5RNBkgjYmV8j+rXevqBULx7W/n4WsX6iU+FB2b8vgFnnwGoCugLuTUBxJHK/1sJBD0a1wmCSQjpcO6RJ5rHKPRsO0mzHnvP4ci9ar4Uky+xiUy+heem0VPrTsr9rHicrUc0J25cgCs3qBHzpN9ccJ31BV9hYhjqnfqQIaUIL2bHsJS7Duu+C2840kn1EJoiXEwYxEM9hwHks1+OJqaKt2j0EGS7iEIK1cuAeBCKNIk/WQoxOTC2Fg2gFR0wpgVERDZESNxmtbxq21+SBwmXmjJxXTYHb5VQrPlTI4/pMco/EJ9vW7GW0Hyn9s9hSOKcdmYDTxlaxPCn2LcQoDPCkmaPXYHOBXWWFRlCOZYGeTNwra3H+v0xaBC8Fuw3S7W52ukSoAaRf4skHeeoYxjpZEKEUT2HKhzf2CduJJ6+APJ6DH4JScfrz9p+k4GmNAFJQFz5kbVHXBgplO/CE7bcC86/MnqVrlRgBUntyIvoGz0PzAe7qtbskHO0YUr5SsgcZbcQJVwUftQBUDDECvU0LgnRQZO8e0ewqpVzetC8ldfUo2SJwvmJeMHqn4ApBA+JnaQRiGrZI+lX38ROnCactPiBLeBWArO18NTdlIoMS5HMTbB6kF0DSQbZpjtGp/Sj8iQ8UaQnuKakmNTBpByXTqAeSiIblPBtisvqV+Qzub59JkDBH5tME6oP8RVG9QBqS5knvrj7/t6WoIh
 YNbjqacN
 Jgw7fIljBj/cHJi7zmJpI7PX0WG0sRWgQuaU2PVKeFN9IuinSDeM/UPn46vsi5OAmYB9RTcD0eBH/YJBLB39OIIhUaCkIcvZDe2oRD/xUoIE7aX35FDg69QsPlIb4QseHOKzk+oEtzeWetOsWs4o751NpeuSoHzsro/FSi/DLTTIKDi8kuIvY6hPI3O4J099r7TxJpkJo4+3f6lqVMfnMmMSmPuzX0O8z68zEK7TJ6FVSJMZM0x7KHPza7BepPdxW7EqYDlSTIX/BlLkzjnXZDH4ohmQ8sj/30RoIFbYv9WrA9bYJgxzIb5w19oAq4//Rl1gm5flNb/ydcGfOQdgMQqDpCPypWknsq/3yAAu+mnJibJZGTCvIufq30TqFs7a+ZaVQqTCdQeCeGjgwnCRenk3nykoreJh8zSp42SB+OnYNNqLwDkD85BsMSiE/sUpSq15V8seSNJaDd6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 at 10:25, SeongJae Park <sj@kernel.org> wrote:
>
> On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:
>
> > On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> >
> > > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > >
> > > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > >
> > [...]
> > > > I will send a new version of this fix soon.
> > >
> > > So far, I got two fixup ideas.
> > >
> > > The first one is keeping the current code as is, and additionally modifying
> > > kdamond_call() to protect all call_control object accesses under
> > > ctx->call_controls_lock protection.
> > >
> > > The second one is reverting this patch, and doing the DAMON running status
> > > check before adding the damon_call_control object, but releasing the
> > > kdamond_lock after the object insertion is done.
> > >
> > > I'm in favor of the second one at the moment, as it seems more simple.
> >
> > I don't really like both approaches because those implicitly add locking rules.
> > If the first approach is taken, damon_call() callers should aware they should
> > not register callback functions that can hold call_controls_lock.  If the
> > second approach is taken, we should avoid holding kdamond_lock while holding
> > damon_call_control lock.  The second implicit rule seems easier to keep to me,
> > but I want to avoid that if possible.
> >
> > The third idea I just got is, keeping this patch as is, and moving the final
> > kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> > removes the race condition between the final kdamond_call() and
> > damon_call_handle_inactive_ctx(), without introducing new locking rules.
>
> I just posted the v2 [1] with the third idea.
>
> [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org

I generally agree with what you've said so far.  However, it's inefficient
to continue executing damon_call_handle_inactive_ctx() while kdamond is
"off".  There's no need to add a new damon_call_handle_inactive_ctx()
function.  As shown below, it's better to call list_add only when kdamond
is "on" (true), and then use the existing code to end with
kdamond_call(ctx, true) when kdamond is "off."

+static void kdamond_call(struct damon_ctx *ctx, bool cancel);
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:       DAMON context to call the function for.
@@ -1496,14 +1475,17 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        control->canceled = false;
        INIT_LIST_HEAD(&control->list);

-       if (damon_is_running(ctx)) {
-               mutex_lock(&ctx->call_controls_lock);
+       mutex_lock(&ctx->call_controls_lock);
+       if (ctx->kdamond) {
                list_add_tail(&control->list, &ctx->call_controls);
-               mutex_unlock(&ctx->call_controls_lock);
        } else {
-               /* return damon_call_handle_inactive_ctx(ctx, control); */
+               mutex_unlock(&ctx->call_controls_lock);
+               if (!list_empty_careful(&ctx->call_controls))
+                       kdamond_call(ctx, true);
                return -EINVAL;
        }
+       mutex_unlock(&ctx->call_controls_lock);
+
        if (control->repeat)
                return 0;
        wait_for_completion(&control->completion);

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

