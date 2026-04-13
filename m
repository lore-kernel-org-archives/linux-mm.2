Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5AFF531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EC36B00B9; Mon, 13 Apr 2026 15:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F496B00BD; Mon, 13 Apr 2026 15:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D0E6B00BE; Mon, 13 Apr 2026 15:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C25B06B00B9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:57:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A2FCC02B7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:57:28 +0000 (UTC)
X-FDA: 84654592176.10.D1C7902
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3CA51A0012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:57:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I0ZlpRIG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776110246; a=rsa-sha256;
	cv=none;
	b=YQqZWC8wVVT7BFOc1sQEIKXKtgToK26OngGgThnQvACHRF/QBWFnmU++enAzyd0ECOMqbU
	NyZlwy2pCPcZdDA/NUeXuXfXi1UU2XEuKt45aSXgm0OWJ7qFkHL46syFORrSTMWw7QKe+D
	1IMUY4BvRqMHnJQwaWJ3XOrXRGjz/Yk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I0ZlpRIG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQesWBA0SakvidWM6gQk3GOHIWTseku/UPhU1Pz5m2g=;
	b=XK/1GEDnJUwnCkdXoN+0JQ/bjPyYbY+sB9LL1wDVizN7d98pUZl9URHRFjIHUvuiWYIYNR
	k7ADKCSiqfUZ3afmcYNXbUBodUKSpQMbOduc8QBDWoNDL1OrTaoSPHEwvZ0iw4Gcf8Eykp
	0wHUdku0BQX6LasqoBLtj021DQ57B3o=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c76af7b0f94so3255805a12.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776110245; x=1776715045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQesWBA0SakvidWM6gQk3GOHIWTseku/UPhU1Pz5m2g=;
        b=I0ZlpRIGY1nxI4pVLkfZQ/5V5erpc5YqaHPuLMS6bgvPnBra2vtjhjZ++/b1VKpN4K
         ml3yDUEFyKDlOTZ1h3HHq3WZgmNitVjf4Y+z9A6h6QNZ4QWa/5PEiG+bQNPQn+N1kBUB
         rJzKYaTLXTgIFH7fDFBS/upw96FjpC7t+HlLy8M1qNiZFqsv1S0sxpJpqJ1xgozPG0WL
         6Cp6rHwO8uW5XQZQcJP25of9ABNInqvGeNz7Vcw4gf3ZH+ip6j+zWfHeO+gh4mN4tgIa
         n9DMerWn+8z/R1Drw1FVv+8bzmHyW+9g/0e/B4u3JnswraJEgPDjwvI0NL9SmsPvbISJ
         cTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776110245; x=1776715045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQesWBA0SakvidWM6gQk3GOHIWTseku/UPhU1Pz5m2g=;
        b=BKChRftthSfLnsAkd0pXtsIagD/qXt/5pITnEA4SWCIKmLhwuxDjokp4nsycIG8A+g
         FlYhr4QBI+WdirWvZECDCQg3hHpdziaPyMzWaLfsKRAqnEGqhIKS0CPX7RZQxz5SjOl0
         xhRrjM2eOjVJ1fdtblevyvsPgUnLsM7O6+onL9ZBQojUZOZQED1mzOIT31vuuXM+a3BN
         P6rwbNYCB+GjKXTDrSAs8sAInehsLrsrcv+Ynj3gW2XdWRwPw7zrb+s8h6WqO6QRTIPL
         9o8Y+DUeSD4dugmB3jGOxyWJ7jg62rsKGy7zXW8v2QkIu5suhc7Jz8fujVm1YYTOl/DI
         +giw==
X-Forwarded-Encrypted: i=1; AFNElJ/Mr+ETgYr/GE912YeAc/w2JNAIbq/u9dYSnInhaNLw1GAwddT+aj7u45Q2wIRRM6eQpmtAmvBGTw==@kvack.org
X-Gm-Message-State: AOJu0YwLVeLAEZz9GlQgimkdv93j32wXcb1kEvCcGm//ejeekQduLdp+
	B4IHLM/U1uwfd2srvZdjqAcXG6ZUwmkf7hrMlLxHPNeFqdFVvuPywjtO0cNBRw==
X-Gm-Gg: AeBDievuOYMWAJqxeFj35X0MG8Hk+7ouMrMxAXoiuIHfN129ah57ouseZC55OTbLfeP
	isD/D25vXjLZ7EtcRdMghm/RPcftOSeKEen2jMPbD8eYqEWbnkJObN+C/6HBiOdF+1UnEEkksom
	tBL7UsXBjuUT7c8qm5lYhq09hzM5J6iOlBEwMcH0ylpVbXShyFPyQE9wXlgTQRjQafDer7MZGaR
	PTt1kfCYaMpuDDNePG8WC1tzPQkliyRjRSQGuJkWdiKZVqREqG+/uYF9f/+UEdo+ZS++VosLHC+
	QL2wqqFgHeaK7I2I+BE0T52Oe+CVRtGatMItWIxnME72hUgGcaH0C7Bqd38NzQQU8lFWaH2vCI8
	/kgrB94jVq2qsj15nDYgl8S1xhXUp+BPk71agbQmvcARRWQ5m2kRuzZGU5jHLlChBrejm/2N1kw
	OuQpoJAXszyNWd0spyY1t8FHptOewdm0o7orIvDmfTX2ZxZq8TAwk=
X-Received: by 2002:a05:6300:210f:b0:39f:706d:630c with SMTP id adf61e73a8af0-39fe3d8b842mr15287754637.22.1776110245459;
        Mon, 13 Apr 2026 12:57:25 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79216fff97sm11417016a12.7.2026.04.13.12.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:57:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH v2 2/2] mm/damon/reclaim: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 03:57:29 +0800
Message-ID: <20260413195729.19302-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413185249.5921-3-aethernet65535@gmail.com>
References: <20260413185249.5921-3-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sy7hqkx76wbbrw1pk6pa5tn7bck3yew1
X-Rspamd-Queue-Id: A3CA51A0012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776110246-797007
X-HE-Meta: U2FsdGVkX1+k1bceUFpCRxjPocdWw611sh48/YaRKuvACQArsNx9RXJMSaPk/ZBGVq4MTNUArh8JOoOd93BuXyk5EVz28kxvOOARtKF35RpQ223f+VdImHeIuxn6pxzN4SuaZfpUTUlR1R/4zhRjHdqBssdSVNgE2C5koW2oqsQnX2eJ0kjbLknJQDU6FWgPo1AcrUhGw9tv9uP0TkrWVfPhz9TvYArDC0I5eIsRrf6kk/gCtPyxe5U0LrUa7wdtIuatwqaHjLY7V3SkFYMV19ssMecaZz21jm1N1Bv3h5ED+dciUjxBl1KxoYTpPS8fY3UR/YU+RrXl4lCVLKqEObdOxNKIJF7F0N9EjiuNv3nKEUM+hWhxqYm6WgiRa6Xh/KYK/9FELJtU1MZCfIhj3pkIpR9SkV9N8ByS/xNSPVeV7r4+a6Ai3rrJfOvvC4JArrixWJ++DMDx1l0ebWOmDya1JJ13o41A0hb6UhrhY5om6vqeUdZlsA7udFcPnVpkR5az0mqBC8Q3+QoQUe2+ymjv4tIEh48BoAboNictr2/dseq4TdF/ey4vuXsHHTki+S0gPorKFE88zUhNixqxuAulTCOXRQzwBSsP3ya2sAoG4w0Ju+Ij3JrPLXER6eBppcfs+dLIj+yjamrWqPiuHV9NZKKvn0HbudCUffl0xdZ+3qpeRRGjZOO7tPZgoGMhnbDiarryjXZ81qQx4zQCasi+XtGa5NFArXThq3nOo5cc3DY1kD0/XHRVOeQcU4qGeEFJ2IIoDGP/6mna882Co3ej0+3+fwQG4jSUL3zYxs7kexoyLPfoSRPPI+R9fXJ47HtjeQuZjX8IBJg/rnzltANp+IcWl7tAfiQpaA43cwhKX0FX6ZOUZVmFEM076LtSEawp7T2ibXDdad0qWmA4A9xvgm9uiX//FsKR4xpftw4sLJcAQYTTmGjZa1AmB5+U1AFobWyFiEkGtChbuUd
 YWnw47Ja
 vFsrkFIQNztu1dot1O53/2xk1CM+uhpoRI0OxW1o74if0Svb2h+dmcYt0PMxI5CKKpDlfdkgA/AKj4lAOOOFxmPamMStvOJyiPCNOxcO4oWHOjiFN6GH1WeQ0H6TJX+xtMa7pFFwlLm0jWMMvTJqZ3zt3RLXEu45smonjTxWJRqqQb9FbCGLwnojus0IcCUfnON/WhARRkIBElpua6zWwHbkTuPVeVx7vqIWMLs0gVC08Jv4XmvNP8ZtWMMWChG77+F/lIMm3QhQff0zWvjBsPTYVTFmyJD4gdsSjFScekcSdsq1Z9LtQ9RktHJOvplLd5meQkpTAM+dZG/CBoui91HYWGgxRMYkjxeCZI5v2acfBZ48AHrWW3vsZ4PliYfS8GlEy+jeuLnTf9PW3R2AfbUYevfF0pmoIOWjMC6zeu2nuvlBeAPWeRWYQ6MipN4uZxhgEBVrfAnXgZ0uNah8me9gV9oNnpSTjZGm57kIsQRGeQFMQFl61pYi/Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found some issues, so I will send my comment for it soon.

Forwarding sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260413185249.5921-3-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit cefd2ed657fa3baedb834d79191ef3af7c5363ac
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon/reclaim: reset thread status parameters upon kdamond termination

This commit aims to fix an issue where an unexpected kdamond termination
leaves the enabled parameter as 'Y' and a stale kdamond_pid, preventing
the user from restarting DAMON without a reboot. It adds fallback logic
to reset these parameters when damon_commit_ctx() fails or when
damon_stop() fails but the thread is no longer running.

> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da147786583..e3e148fd80f97 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
[ ... ]
> @@ -250,6 +250,10 @@ static int damon_reclaim_apply_parameters(void)
>  	if (err)
>  		goto out;
>  	err = damon_commit_ctx(ctx, param_ctx);
> +	if (err) {
> +		enabled = false;
> +		kdamond_pid = -1;
> +	}
>  out:
>  	damon_destroy_ctx(param_ctx);
>  	return err;

Can prematurely resetting enabled to false here introduce a race condition
leading to a use-after-free of the DAMON context structures?

If damon_reclaim_apply_parameters() is invoked from the kdamond worker thread
(for example, when applying commit_inputs) and damon_commit_ctx() fails,
ctx->maybe_corrupted is set to true. This signals the kdamond thread to
break its main loop and begin its teardown phase, such as executing
damon_destroy_targets() to free lists.

Because enabled is set to false asynchronously here, a concurrent sysfs write
of 'Y' to enabled will succeed and immediately trigger
damon_reclaim_turn(true). This unconditionally calls
damon_reclaim_apply_parameters() and executes damon_commit_ctx() from the
sysfs thread.

Since damon_commit_ctx() locklessly mutates and frees items in
ctx->adaptive_targets and ctx->schemes, would this race directly with the
still-exiting kdamond thread traversing and freeing those exact same lists,
resulting in list corruption and a use-after-free?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260413185249.5921-3-aethernet65535@gmail.com

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260413185249.5921-3-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

