Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987DEC5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9537B6B0331; Sat, 15 Aug 2026 02:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92ADD6B0335; Sat, 15 Aug 2026 02:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819B06B033D; Sat, 15 Aug 2026 02:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 502786B0331
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:51:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3F97120125
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:51:25 +0000 (UTC)
X-FDA: 85102582530.02.81B6981
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4A61180004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:51:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u5yStvdb;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zq2c0RpFytAPpB30mO0XEj2mdkMZ8ArlW2dXXmz706Y=;
	b=64B8wvQujIFPIEobO5k7fa4EaCK25bzvAi4BVQp93EDevTF9PHnk/r/z0hz5PPD3nc/VaC
	1ewEl+UMW6rj0lvsPWKb/TisBQ9mPsUqYS3cKk1Pno3S3cXTQ4MtWFKM2YGRYgV/GVUjl8
	9c3oDHDLDDBKda5yP0Jnr3lQgpQ3VXY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u5yStvdb;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786776683;
	b=WUYz48Mend0OCyTaqK90rH82PyLpf1O2w4ClpBUChuOiKS/kRpTv2QN5fw0THtdcZZ/0jj
	heHu3y7X0bMLRKasYfrWfh3rRf5hrL8BZDubeoc7Eu/Dru1KgUMoSZsKnt1Pp4RNy1gEFB
	gp8Ce63S/RwczytIfq+7xHGZmsDczjs=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c01c79467so481671cf.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786776683; cv=none;
        d=google.com; s=arc-20260327;
        b=nQGptCJ6NJG9z0Yi7QDTCTA1nOkmGPT0rYD8lSeaxPIaQ82GmSPIpr2iCfFTRa/Iyt
         Nhyo4s2npf3p/xJCHSbRowVGJ0L7j0uvShlJRNgFTu069vQ9I+2BAzWUTCiJdIp4nRl+
         fhgwksoPt4pzu6CK7OO7LyOYEjgseofl6rKLL9xkTVxKHBUCHdh6kPQ2D5isq7en1vZ1
         11vruwIEJstZSaryXR3X3i524ONIulwQLrGLhuPETBT61nSKoe7++buxAk7uyuSV3hbC
         k6IoUUJThnJYr+IuIQEE6MqKmx/dUO1m0BUW7TV232GtZ+gDZdDpUR6y1oSLq9SSh4U0
         patw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zq2c0RpFytAPpB30mO0XEj2mdkMZ8ArlW2dXXmz706Y=;
        fh=Q0Ciw8HEY2YBBRyuxhHyqUR2lqsPp4yMhw+JEpz9wU8=;
        b=YJEYXhNqnDZKUdAafMWO8xn6KTOah+CQY75GzNOpQTOaAwcZXLH/9lI0BD31QDsVwW
         loDZJqGeA30mqnGdwtKLUY1RiO9GIKH3Aekzm72k6J8RV5iT9dLYsal2ZiYjyY3p+V9y
         lbPazGKES6Yl6QrPAnIaFxnxXkEoABCj37fVacwFszvDqNvCwKFZOxekcKsuyZ67zVOZ
         vYcC89NKFXTqr7ebztQ/L2aFZeynSw+z8VKXN+0zBuV/+J0o+lbMINXlAEM7MemirPjJ
         70tq2OBpKTmAp9nh38FNIQjU0Z44sCGkJm8TXlmWUxaFnqX9f5LVSRYrkD2s9nTL09S7
         671g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786776683; x=1787381483; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zq2c0RpFytAPpB30mO0XEj2mdkMZ8ArlW2dXXmz706Y=;
        b=u5yStvdb3krlXvWzCRug4Tk9bxFInyaNMUJgoBRz6KrrnMuZoI5el0BikYRA+Blrex
         fpLh5B2BRRieaQt8+3Ivc8sr0SF2mJ0/amucrCFOArlbdPHnROi4Spwosi5YwvkNfVMp
         ygaW1dqCSJpRgY+DJPZsWv5j4YdewO5XZfR/pD0I9jGDtctCd7RZKn0WCy0cexFfGNzw
         HvDHpHUsRMbNav967igH5gQOjSpLyM6p3bpaWB0hsj1qqxdkCjT4TcDUJul77LkHURrF
         Zcnl8lm/Yx4hW+8CY3TykLBBMbQHR8san0ylA/AP+qVpv8uDeJoW9yhvHrU/4jcmrKbc
         pzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776683; x=1787381483;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zq2c0RpFytAPpB30mO0XEj2mdkMZ8ArlW2dXXmz706Y=;
        b=MnpNKLq0Tw+lC+XrnGLKHekPlF6JtVvPY2PADvP5GqX8Ho+BLsckXCqJ6Amw38uZwk
         xLm5nSbCLjcgo7sHovQfDlPn2TpxnmQ7c46c6ejQYcMH16uejvAOzvatMIuhfnJUIY1I
         bRR9zGOnaTrJ5K3QTbR48ZlLvalsEYAQC6qIK+xhMqQuvv/U5IH7h0Hu82NgCAVSJDn4
         FRFebC1t7Tepns1/S9bhbB+vS1sF9AV4r9bqBh9ndIarMg8CGqPW9xgYKg29PwbdXHoy
         xZ3w2Z3YoFq2uaOG5qICBkQcrbzqlcESzyOdGpY/T8xBxr1PDQeegLmSc54H10vtRyUL
         n//g==
X-Forwarded-Encrypted: i=1; AHgh+Rq6hT6g6EHVFykxz9vG01GqwYNdNZSml6HBpzxOZcGKuA/EOr1rGFp5H/kpEntelOrvvOWuUmLKiA==@kvack.org
X-Gm-Message-State: AOJu0Yz8dVd2ciR0bhxT9IIavEee+9Qe2cXbChGNudOttAmUvnoZVFYe
	wLzzeqiz5872gXwx6MHLjW+UhepVM/puKzBomP7ZWAU7tetprCDLVjZDOusaIW8W3TBtnKcx8T4
	CPmTWQz88UduMMgFOmSAO6IeuNu+PhUapIrCq0s8h
X-Gm-Gg: AR+sD10LiDeFYtIclUZX+9qHa1XaqDmqtOQ9npVnbD97p9VSzrBAAHt3+bJiQWnSK3G
	ro9HGXheliy1qQbv7jWX1Oh0dATd8xMkRAW57qM8kdOMF7DkwwFDXYKiBeMax77Oaa2Sdsg7mUv
	ydvTnOefqOOFu1HwmqKj/oc1wTXv90p8Y4SsYKm5MZYPMtPVzJCBREIiXUr8JgOx+6A2TEsPpmA
	KNsUXWM7blkmKsXlbfJ4SgBryfDpltUMRKgzoAusjgikiSWJkT0fvXoc2G6RYsSru05pByTZKRw
	avnT0uWoLkpQD41FjU2rnyOx6DXJeq2J/BbmStQ7BUs=
X-Received: by 2002:ac8:5f8b:0:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-52d8631482dmr11055441cf.13.1786776682352; Fri, 14 Aug 2026
 23:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260813093421.135230-1-hao.ge@linux.dev> <20260813093421.135230-4-hao.ge@linux.dev>
In-Reply-To: <20260813093421.135230-4-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 23:51:10 -0700
X-Gm-Features: AcwNN1VO4OZ-i99wJIbsAO44f2g8Nco5BTsyXPWH4YOr-l5zjYCr5D9HdcxgZ24
Message-ID: <CAJuCfpGfQrYJ=Rgrar-8btsiUCg=OQotWPou0J-mpMFNzrJC6A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] alloc_tag: remove /proc/allocinfo outside of mod_lock
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4A61180004
X-Stat-Signature: 8nitcd8phojq9ditdusfz1zep1syeipc
X-Rspam-User: 
X-HE-Tag: 1786776683-652190
X-HE-Meta: U2FsdGVkX183wh63/V851dWj4jTwBrAZI+Wajonjh5vN8HnAYPfT2w8s3TWrZXqTcAV//RAgnyZS48lYO7v+0xPwtyibklNftYIAbhU0qhBI1RYGrzhO+m2EZSte/w663QgbCrB2gAB+G4IQe8uOCoBw0TuWjdtjHJUOlS+4Po5gJ+VnXfp873di0Ti/LBV188PAqqA39U2XtP2+0JaxGq7Z66KYTY8qMfYy5yxcxyRFVaNzdVgflS4+jttsUOa35wc9vJkQ1M0bVOfkN+2UUew2ApdZ0O4JtYntj/ywp/9OnlB7i/Xgu4VsKtpZoznP1pfAob2ojXnUQC1kJJrvtRFrVVD40LkTAOy2UIh6fmtxcEDWLTzgmTgFttmpAS8EPp2ngsnE88MFNfmGmbTHSzGCYuwlaFE+THtducgo0BvSHX5Rs4b8ks8BXcF6+SFegxbfeuNfIrgfgr6AgIE+pKarEeNm64JZRBjyqU07qenD3YMTgWkq/MallMngJFq4nsHvauuIPs5vIO4V50158U8mepvA/h1XqwdIC0U/arysLz5i+OpJALPBUtRelEInL5uzAzxPITELvcDE1BZ5I0746QXTpWFhsGJ7wpJJBSKbTGiAfsqXpTd5OUHePrtzrj+820e8k6y4oznWg7h8kFstUq1aGvJDL4DlSSoy0RIldgFR8ryQ3LWjbzQw+saQRy6muNjxPgFgZOea6rruMoDr/p814n+2N3ZkO2uV592fYDly6DSvJPxqS30m6kX5eWy0tB54Nt0LDmuDpJ2ZLlpC43KxCNtqjo2RZU5YAVW8H5HWQALtQsHhajADd2gzASc3j9dNR9qCN9b1pylDQBdxIh5l4ahVG0M3r225eAF1MpJN6nF4pZvSfEKZmFrflX/IR7Tt/r9EN4zDwSSwoEDyorTnbzjFCGmxldauo5nNyXjL3qr0kWGCoO6IjzdAtEJbbhObGk+8HZBT4Gk
 J+J/hbMN
 +k/+dTPW28ZZqFcTlf3AS1nXklZ8zErboP6aMEe0SeygLTH0UCw8Pg04g9LcGmN3uiOCfqP2zwP5IPCi0HR3KIvl6L6sXY96SW+Z79xqhGVH0O9KpcS4lH3xn8A0YhWedxPuS+s+AfZiVP3JKXxNXVwo26phb9/b6fApBacTGEJnsTcvwxayFx1+J6r1RVKq8QiAwqaLAAnUB9nk/iqo/euI6ILgQMC7I91l1KwaaGTdGUvyOwTHy9Icrc1xCRO1XGKdSvQUCKU3xapVg9d6x+yCiIGOQ1UZDlCH/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 2:34=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> shutdown_mem_profiling() calls remove_proc_entry() from
> reserve_module_tags(), which runs under mod_lock held for write.
> remove_proc_entry() waits for readers, and a reader takes mod_lock for
> read in allocinfo_start():
>
>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>   ----------------                   ----------------------------
>   reserve_module_tags()
>     down_write(&mod_lock)  [held]
>                                      use_pde()            [in_use++]
>                                      allocinfo_start()
>                                        down_read(&mod_lock)  <- blocks
>     shutdown_mem_profiling()
>       remove_proc_entry()
>         wait for in_use =3D=3D 0         <- blocks

Yes, this is indeed a possible race.

>
> Move remove_proc_entry() to a workqueue.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")

I think all these issues were reported by Sashiko, so you should add a
Reported-by tag.

> Signed-off-by: Hao Ge <hao.ge@linux.dev>

LGTM

> ---
>  mm/alloc_tag.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 7481180dadd2..b80f5a151f28 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -591,6 +591,13 @@ void pgalloc_tag_swap(struct folio *new, struct foli=
o *old)
>         put_page_tag_ref(handle_new);
>  }
>
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
>  static void shutdown_mem_profiling(bool remove_file)
>  {
>         if (mem_alloc_profiling_enabled())
> @@ -600,7 +607,7 @@ static void shutdown_mem_profiling(bool remove_file)
>                 return;
>
>         if (remove_file)
> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +               schedule_work(&remove_allocinfo_work);
>         mem_profiling_support =3D false;
>  }
>
> --
> 2.25.1
>

