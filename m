Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071D7CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 13:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7608E0060; Wed, 20 Aug 2025 09:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EBF8E0003; Wed, 20 Aug 2025 09:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC188E0060; Wed, 20 Aug 2025 09:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCD18E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:20:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 316B01604BD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:20:38 +0000 (UTC)
X-FDA: 83797195356.12.B3E320A
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3FC882000A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:20:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jazHm3JD;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755696036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huBJkkuAghaPrkL3HWrTjs62vW58FasajnWT6m2aMfQ=;
	b=hIaYXrFDN2BSepHe/r8RXBXBRT9fojlw0sG/TY2axbCbaptALrteNCw4drtk5eG6yYgPmN
	b5fmoyEW2G3zw6V/BBvWLPvKO++U6ycsPHynh5bdgX+H9WE0KJk0phVP0Im9mhxSAO2n0m
	XVs1CASH8NiMqFGyUhlvAfP8KkVIwGs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jazHm3JD;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755696036; a=rsa-sha256;
	cv=none;
	b=IBJt7v6D7hPt6qIXOiIbaVi0BRnZHvGO/ytVT33VnW7UM6KojSW7uK5S/Tyav6DXw/tH5s
	XTAMoRSNiEmiKLJKJf3Umt3qqIZsNn7I8uifYJl8/EcIJvwaX7Cpwz0IkfJJuuhuQq4Tjn
	+dStrc1wD0xhvwHDv9NFbmqkWWe8U4o=
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e94e40fd4f1so2122422276.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755696035; x=1756300835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huBJkkuAghaPrkL3HWrTjs62vW58FasajnWT6m2aMfQ=;
        b=jazHm3JDsvaQzULn0RWjJ+US6tOPESvxr7LOaU1IiaUC8NcoJtZQyOv2hDK0vbqBxh
         3tqe6tV7HchHYsGwQRuyGcWarX7qeC3Wec37QTxMcStf3iZrZ2V44+Ezjr2EpHRBOe29
         hRPkjhUzMqeG/4pzxApiREe86o+ReRGpYJKZMqDleTO+NsNlu0A1iXrOt2PwhGu3z6do
         oM18BBcH1nkRqn1HlFBkUBylEqw0UrEauQ/dQRD6ylzTm+dUNNM4nqh3KXqtygT6Gs5b
         BpZLfuHfPKgczdbi8wgCa2BpTEr+5xnmufmWBbmnnvgQx9uOIzTdmLA/mOYEGG24Asjp
         wCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755696035; x=1756300835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huBJkkuAghaPrkL3HWrTjs62vW58FasajnWT6m2aMfQ=;
        b=flb2maAb+6HYAIPfYuGsZ4aZ2A/NQrEtDjyPiKfXp3PROtqOlBItZcQJol+YjmXiaa
         A1hmGpDLLNOiEakg43XUvdAUua5WnHOSEbNin5pZzpGEgbxrAdLfurTDsu5MddTnUkw+
         6FVTM7aH9y61gGNf5H0lGkyNvgX7fdINM5wfeFyIvuAB5cAnL9lfC75nqOgU30+0FHAP
         4raBsDJAp0Epc6ngVcl6iP49vif5kxN/f5UJorGmSZfeMFE0QcECbE3a9a2u6iCjGhcG
         Dw3TxrPqAqKh9jDwBJmWLE/IWhWRVxeCwJXNB1iWy4H9h4e/yJXA0EqYN+gUJw8Iyyd6
         t7Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWFubIb76zm7NmGB77uZ4anmCQHH2+yPJJ61ZbpLkeDVFF4rNQQWyhoPv5r221C9Euiqk9imW4e6g==@kvack.org
X-Gm-Message-State: AOJu0YzCLD2pFOwvtQ4O2G85YLAzCZV8oxde+vklTrsfrj5973RH5vjj
	EXCw+iEGIQQR3To+Pbgwyc4COf0UGafFWfO9DqCQoLN8AkfQ+TVUBx7g
X-Gm-Gg: ASbGncvOv9PRjnV+ySaa7fRmgx8+HosUcvHdZ+77FHeJU/TO6aIId6ZflGnPlwlXwTr
	9KCLnBlfcmVdDZwv1rF+kkELZvhbYt0TxET2bA2z1BCDMYkHKmvbzzzKCDjSicw5U7JucRyZ1Zj
	Ld7ZY5a6YLx1J/1K68POVqcMG7iNH0N8p0QWkNmHkMwBmT0SqVNMVKmIfoOgP/BqbIOeUgiPWf3
	npFNnDSfCynwAUcHSsdfWtc50UTIVaUTbL2EvPT89gUUj9bVM++xshOp6IQxP6MRfEk/tZZhseD
	Y8mdV5enAUVppnxrFLc70BY3UF6k4Qm1JN35kLX2VgKf+cPgRPpNbl0zrKs7AJez1dGqpKhzf9+
	VGjqeeJc0zpkhwRve0yIKoQ==
X-Google-Smtp-Source: AGHT+IFe3l5NW+k7VU45XzYFiqnjIqKJUrlUrgIYjymvF/QLwecLD1IxZTW6nifz4i+UybYBiKZuHw==
X-Received: by 2002:a05:6902:1549:b0:e94:e1e5:377c with SMTP id 3f1490d57ef6-e94f66b1ed7mr2856141276.50.1755696035015;
        Wed, 20 Aug 2025 06:20:35 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:52::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94ee7b9ec3sm1219738276.17.2025.08.20.06.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 06:20:34 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@gogle.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Wed, 20 Aug 2025 06:20:32 -0700
Message-ID: <20250820132033.1267317-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250819144421.7a52f8df3f0fe5c315f90aa2@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rqtm8nh5651t48nbe3w499ej15m43mq4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FC882000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1755696036-499078
X-HE-Meta: U2FsdGVkX1/EWod1S4lU2FxPz1NN37p1QNlPRvluwvUE8ZxxmTjXfgdog3ojxeA4LLe3ktdIOLknAEMYDypM5w6jRb/h8Mly1rO7bQYAlZbrGzPKxnfmFDN4UkCuPyI//aUD14ihj98sZXBYQsfper0WPDVDrIehFAlhiTqYkxMWHrFAb3ih9rnBDxudcX97IygPVILDk4G4miMNk8YssWFqTI16r3GYYCRtmcKavVZHokDQXNBxQFKhQiP79Bn2nbvv0EDtt21TLHIDH4nqnj96MBPo0nr/mr3aOR5V3Y21WBRGflhARe6W4MviwXq6JsmhjSI3oo2oA54S/dTJH1lDgTlPYzyh0EaoujZQ8BpVM0GxFC9tuPuO9RxDIIB9p8y6YReveR0rYDtRzYrGFguNzMLofnOMNRVubn+O+Nagvyvd4XoRt/H793ob+CXbl5JnR1F2wBRiBxDyceu1pA3uvXmFiyXHsv8KTh6nhK3ww5E8P3vYRXksdgU65jirB2hPjwREp1GOBiw349iPgWwEw6nij/uC8QuT7uoo4Y5eWn4Ir3gMPVFyp4pa9g5Rwp5WhoKX50Y5NL7/R4ysGW+r+4N6Wi5SLS4tzEev21ScPeBdlOBJ3LFp5DCU/L3BOQNpaf1Srv5YwODSNspvAQX1Kzpfz9PFZNyPG/+jA2w5fblu4kWxQJ9OfKTRKXzgCjz2vJjjYnNOcs/Q8Jd16Ioy4NcL04is11E19bRabLORI4HGC1RG7TyB1rzQ5Hj94qycrKz5Ag35APkWLafbxSELGFdNBYUhbdJB45FRHgV8126A1zmcwkRUWIlPgOaw5RI9/8mk7+hbZQHgqwoGYtY8mlrqNXh+vemcP/jFEMsxgejZ4VOkTZrdfi+rTGqxgSdv3CoTJLIHs4uvca4DWGIdtMwikfXtUrPMGf+s7MkOw+U7WUynt1dwxBGm8vknOPPd4+6v2zDlBeJ+UT7
 VUZDS0XW
 TqjfG1EEG3l8ppRKpW5V6Dj46YrGKpydQYoi6QQEnqzICa2Z2DUs/+2Dy0uaZi4EuZmZcAOfqLtJggL2aDVTZjtr5DFu4ciZAMqmwAvTzdPoJX2xU14hFn+i2iX9dlrzKlwTkmhhUFJIApESoxw3FDpzGxzOO1Hjm6cnsta2Wzkjakl4B42F2RjhFV9FcrShmkzfgN30sCdfsjpzPWEUdtsV4P1RV9zi1OZedPeliN5xZp2/GxM3C94E1aIGtdADD/i2BtmuQExYzZz7ABQ0oxwsaSeVqSau3usr9+tDc/SHH+gg7Ce7FYTY0ASqdJvwFzidwKtclDq4TeCLuQpCc+ZiE4ICkyDLGpw3lewjdQnvCl3EWzy+KXoXIP0qIIrJAT3Dn5TQxgvZnd8Jje/5SN+eYgtOAHi33ffQE/93JtdJP3l9uFzOEaQUt+9E8IVb3UMEm5tassFoLFn9biqCaRjndDRgDXptQlrzRqD3Zll/PwCNavxyBSFctkZYuVGLjwN+hHchE7EjI9VHCbMnerW+GLqBfUhK1ELCeE/20M1NZHctl+lq//kK8zyjn2r5LtVdTF+Kh8Fxl6omRzPjdbW2rOjtHSuppRnXC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 14:44:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 19 Aug 2025 08:18:45 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > > Pretty this isn't.
> > > 
> > > Sigh, we do so much stuff here and in __free_one_page().
> > > 
> > > What sort of guarantee do we have that the contending task will be able
> > > to get in and grab the spinlock in that tiny time window?
> > 
> > Thank you for pointing this out -- I don't think there is any guarantee.
> > Kiryl suggested that I put a cond_resched() here, in order to guarantee that
> > the contending tasks will be able to grab the spinlock. I think that's a great
> > idea -- I'll make this change in v2.

Hello Andrew, thank you for your review!

> cond_resched() might help because it takes more CPU cycles and expands
> the window. A udelay() would of course do this more nicely.

I was wondering if we could rely on the spinlock implementation here in order
to allow some fairness in who grabs the lock. From what I have gathered, on
a lot of architectures, the default implementation for spin locks use a
queued spin lock (on x86 and arm64, among others, just by doing a quick
grep for "select ARCH_USE_QUEUED_SPINLOCKS"). This means that whoever was
waiting the longest for the spin lock will be able to grab it, guaranteeing
that this function doesn't immediately lock again.

With that said, I understand that the solution should be generic and work for
all architectures. I wonder if it would make sense to change the zone lock
into an explicit queued spin lock?

> But the contending task is already in state TASK_RUNNING so a
> cond_resched() won't have any effect on it?
> 
> Also, callers hold pcp->lock, so cond_resched() cannot be called.

Ah yes, that makes sense.

> Sigh, I dunno, it's all very nasty.  I have vague memories of there
> being a way of relinquishing a lock to some other task which is
> spinning on that lock.  Or at least, a proposal.  Or I dreamed it. 
> peterz would be a good person to ask.

Cc-ing Peter, please let us know if you have any thoughts about all of this!

Thank you Andrew, I hope you have a great day!
Joshua

