Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310B1E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F91E6B0088; Wed, 18 Feb 2026 00:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6CB6B0089; Wed, 18 Feb 2026 00:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B31E6B008A; Wed, 18 Feb 2026 00:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 151586B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:56:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8410613ADFD
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:56:45 +0000 (UTC)
X-FDA: 84456518370.25.FB9A32B
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 951E440004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:56:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LC8beNr4;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771394202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIoM8nBn4QNw8zgwn+yhPSEBk9RvVOffdbuB/k6eMvk=;
	b=eEbU+95PsYIIInFIvb4zx4bH+F9SsybM0aULaC1xJbIRTu5bZAL3yuGMpSVsgvx0RELDj+
	d1zvT6Cl8pvmbcgt+rkUv7mV/IvRlq43ZemAn0syF9aJKh7JQjUSLHt+D6FHBteONlMMEo
	6H2bz7ry4Q0OAFOekhA3i7HS4o0qdXI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LC8beNr4;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771394202; a=rsa-sha256;
	cv=none;
	b=uQYJMGp0gbTsGuib2MWlVsaSZOKEhL9H9Z++3d3JZQ0MSEzZskYbKb/avMAKPF4iAmwQ+F
	gBDo6gtNxmzxaHy8oYnY3nPOLDc26UCVJs9NQj7IIGIThJ738yJWmKcMI/uACRdhCGiRmr
	ImrElW4DSbYdAKtr34YN1vsZuzgggd4=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so1904395a12.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1771394201; x=1771999001; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dIoM8nBn4QNw8zgwn+yhPSEBk9RvVOffdbuB/k6eMvk=;
        b=LC8beNr46C6g9iogiTs9b4QF2OwfdWHGGv1T30pU2iL8liNt4y8pVNZJv9W/+vNSyr
         CcFIq3abGDyQZs6A9bJjD2ohvpwQrEbN4FoGumy8XhwfwWMooYtvPqFKtC1X8ww2T7WC
         My+xgCm8qZbh9BBtTbIZm42nqAazcuhS1p7k8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771394201; x=1771999001;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dIoM8nBn4QNw8zgwn+yhPSEBk9RvVOffdbuB/k6eMvk=;
        b=pVM9CR0Y26nKB1ffPuRhJGcqNJv4RKdxbRG6aoCvVjup5Yf3mArvxFWoOHtQrLwjLt
         d5c7wpMu5+cCm1cL8M1uzqYgev4OZJMQ2cqOc3NqSEwIvfwmx9kbrb80UwsZjhmDCJ9C
         h4X/3darSZvS2pavKR3xH0T0qcNtBOidCtJxe9CGPM+k1RXL7BHz0GcD9396qF1znP+T
         BNL72RCdkvMo/ZvteTC8YahTmUw+xABTG5qWDbVHxLwuj5m7eME9QoWLZyAkHLMyM/8R
         H5FXPcp2zborhSQmIzj04hTRCo2m3QYSaRlBulzdfIa1MrzOELUMNgmga00D/VGlobni
         3gDg==
X-Forwarded-Encrypted: i=1; AJvYcCUS1fAH606RU6Kff5EctKEtSnD5b+kE41Qji4lwQ2TEONClopWeVrDL2MlQJMnV4Pzni/1Ht8VJsQ==@kvack.org
X-Gm-Message-State: AOJu0YycQQoMViTSHRIaHwMt4Rh2NVe6MiAhU2ZD6QbVOvQypMmM8I4j
	5VLQSlPlwXAy05er7ZIY6CPA2jSjCUq74/r/HTYPhs1uitSBlLxXYxYlP9TeGR9XUA==
X-Gm-Gg: AZuq6aJmV379hZZ3z4oKWF5D2f1ehbJDGOrcLFK+gV6z1/HaMcoiRfOynLZyMVYHtKc
	IV4y37MvZvGug5uAQglL8dl16Xp5tEGfYRsXCKFtqipzK1Jeo7TMyyNOOyue1yp5ojdh2NRPizV
	/oQnL/ZoIMOu0zXzpXBD86MB6UcGOLPRhWI/hB712KVozwi9JyBSukc7HnduunZiDlGWFv93pYT
	c6GomKoZg4k/LXFCfAN+sF5Fti8MpZXws9QDuRSI0zTthiLCrjtPVmGaoOtKVPSODwluUtb6Ia+
	oq1w82Q//+7/e5dHQPFpIYm78VTOVAdDpOQhANgbl64X3syyySFS/Fj+lCoWqjfVQIY/dPBl7/m
	5GIhbuQLeYCyWpdRJ/fJFjO28MgLZwx1KVVU3ko925duLe+g8WPspyEvZayPZJvwTu/J044ll6u
	TJkpIulL29gMpdFksqvEzn2Arggd8ZhJ4r3LjaUTFgzXtMcoSpP0vydlDQgvaHsHE=
X-Received: by 2002:a17:902:f54a:b0:2aa:e6fa:2f74 with SMTP id d9443c01a7336-2ab50521f02mr154035795ad.2.1771394201381;
        Tue, 17 Feb 2026 21:56:41 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7f05:129a:91dd:6ce6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a738220sm121498535ad.37.2026.02.17.21.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 21:56:40 -0800 (PST)
Date: Wed, 18 Feb 2026 14:56:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michael Fara <mjfara@gmail.com>, senozhatsky@chromium.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH] mm/zsmalloc: fix NULL pointer dereference in
 get_next_zpdesc
Message-ID: <kqx5soah7aalionfss6kwht76xbp4ajwwyxawixkolmumj4m3i@cgdoxu25wp63>
References: <20260209193257.60393-1-mjfara@gmail.com>
 <20260209225018.1541260-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260209225018.1541260-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 951E440004
X-Rspamd-Server: rspam02
X-Stat-Signature: 1ngh1zusmmtgqoib93ockooz8biiwjnf
X-HE-Tag: 1771394202-396425
X-HE-Meta: U2FsdGVkX1/pan7phspHXh7DnVB4/8dvVyqzi3JNL8TNBEx0xwi1g76ERxSf9NesywlRlFGZPshRYyohttzvHArELc7YhiVtbjj60IEUozKzF02nFo7hJnoLSQhoTyrdZVIzrh81LquJi0yujor+XqRRpVENtlY+qN0LmBRJ44WB3XTGBL8znTmS4jUMz89xSIwqLZNT0z5IR27drG+4Na6u78jDK2EKcAOZJbPvDhd0etjJyUaizy2Gih90BKhfeRQSktp4e18+U4GBOPV5TgrNt15ca2qMhqNQRTxxh7B5nAzQ5okr5SMHlyJTn8c0/+9C0ATb/SYvXI0EtPH/f9dyBeI+mJA5psWE1gQCtOPEvgUzhIjYUsj7n/r4X84sW7RW/lan0mk5FQ9OV0kUgmotef5wLBZT2Pqysjsvy/lJJf0KlKEEFzvScv8tEs/bUl4Mm8gCsUBBes2UZtqunBW26rRTweILZpjbYuL28huFfNFnApt5mTMVsn123yDDeLjoAR8v4CJdEbag06D6JGSLaS8qeTPmftJ5ZqFqd+zKVkLOVRc1M+pCIKlQRbLbd3gNNMbAKEamqnvIerwAC20Sop17gN20/NuU7X9T23MMfxQNVOPsEPUo1+xXenTShLv6VyW1YE698XsAkWYEjQyHXJCttsxjffRpOgmuucCYQRhAr/QxPvyFMH7HbrhmRWoXlrk4iYJG3XIykQJIre1fI6dmi2fscgSpPzWBK8HS0T6mMP83zdEHX2I2Z1mjCChdpZvkA6uv6ecU2+XL4VYLQhLNcIzTzcUdQmnc/rCmwoLvop7Ur4yZ+MRIjCVMaolp1SiBJKYu+9LbNPvb8j4K4Rn90UEJc0nmFZc1LyyAmDFuAJWlwcLk87omg8TUCTRgmlY23KwmvxYGDHIG0qUoO4ysturpAhwvnWQ7GIH+E1DuEyjnzlBp5fc5EoTdvv1hV7+AK/2uJ1UnWO+
 SB90YIzi
 RMWKHclYaVV5R1PKGQTFL/yKoyC/7xpE0ujcWhXobi2/OWHSG4RXUgfI/XBupTf7QMTWTtFnxsTa8PnKSEnpOqGDft1dn5v1MwumcRrrKHx+k3vuw84r4SAz6+IznhA3qME6sYclxZV8Cbbk0FOqDcQ72zxkn6e1Tffitcc36JOEC3tCze0DFfWbVn06JQ1MwGkESY/ygwCWRE2pWB+TDnXpgzr0QyTxz7ZGXNjeOhg7uHm2z6AQ50BSgHWetFyv+jFzbFJqjiKNg1k2hMeAWdNbEybVRXcT1xLpB9l4/BKM8+ZJzHiskwDO4Ar3zSBH0P4Gd2cIuWD8cAUE/EV/qpb0viZhicEPS7HMe9wHmJ26qkXWe2i2wjyd5XSvQXhQ+rsUndtA/5RC4wxZ9H7OpeZ89bcTVZXc5A1EbInU6u0fMgjnBJmhOS9A6iJpmyX23xG3V9tFK4JI7afskAtzdYBZrOorC6emN8xogXF1cV5t4BCAJteH9AFbZXQtuLoGGBchbDdHGLx4+lRlewodI2hM3nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Recovered from SPAM folder *

On (26/02/09 14:50), Joshua Hahn wrote:
> On Mon,  9 Feb 2026 19:32:57 +0000 Michael Fara <mjfara@gmail.com> wrote:
> 
> Hello Michael,
> 
> I hope you are doing well! Thank you for the patch. I'm not entirely sure if
> the race condition that you note here is correct, and also if this is the
> right fix.

Thanks for taking a look!

> > get_next_zpdesc() calls get_zspage() which unconditionally dereferences
> > zpdesc->zspage without a NULL check. This causes a kernel oops when
> > zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
> > between zspage destruction and page compaction/migration.
> > 
> > The race window is documented in a TODO comment in zs_page_migrate():
> > 
> >     "nothing prevents a zspage from getting destroyed while it is
> >     isolated for migration, as the page lock is temporarily dropped
> >     after zs_page_isolate() succeeded"
> 
> I'm taking a look at zsmalloc these days, and I was confused by this comment
> and remember looking into what was going on here as well : -) My thoughts
> were that it should be safe in every other case, though.
> 
> > The sequence is:
> >   1. Compaction calls zs_page_isolate() on a zpdesc, then drops its
> >      page lock.
> >   2. Concurrently, async_free_zspage() or free_zspage() destroys the
> >      zspage, calling reset_zpdesc() which sets zpdesc->zspage = NULL.
> 
> async_free_zspage isolates the zspage first by taking the class lock and
> then splicing the zspage out. free_zspage is always called with the
> class lock held, and it likewise removes itself from the fullness list.
> 
> zs_free -> free_zspage -> trylock_zspage holds the class->lock
> In zs_page_migrate, we call replace_sub_page to remove the zpdesc from the
> chain before calling reset_zpdesc, so I don't think there would be a race there
> either.

Right, am having same thoughts.  I need to look closer, but sort
of expect that class->lock should have kept us safe here.

> >   3. A subsequent zs_free() path calls trylock_zspage(), which iterates
> >      zpdescs via get_next_zpdesc(). get_zspage() dereferences the now-
> >      NULL backpointer, causing:
> 
> So I don't see how a subsequent zs_free could race with reset_zpdesc on
> the same zpdesc, maybe I'm missing something? : -)
> 
> >        BUG: kernel NULL pointer dereference, address: 0000000000000000
> >        RIP: 0010:free_zspage+0x26/0x100
> >        Call Trace:
> >         zs_free+0xf4/0x110
> >         zswap_entry_free+0x7e/0x160
> 
> Is this from a real crash? A more detailed crash dump would be helpful to
> see what else was happening on the other threads!
> 
> > The migration side already has a NULL guard (zs_page_migrate line 1675:
> > "if (!zpdesc->zspage) return 0;"), but get_next_zpdesc() lacks the same
> > protection.
> > 
> > Fix this by reading zpdesc->zspage directly in get_next_zpdesc()
> > instead of going through get_zspage(), and returning NULL when the
> > backpointer is NULL. This stops iteration safely — the caller treats
> > it as the end of the page chain.
> 
> If we return NULL early, what happens to the remaining zpdescs in the
> zspage? In trylock_zspage for instance, we might exit early and think we
> successfully locked all zpdescs, when that isn't the case. It would eventually
> lead to a VM_BUG_ON_PAGE when trying to free the zspage later anyways.

Agreed.

