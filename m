Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6362CFEA80C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 06:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB6E6B0005; Wed, 25 Mar 2026 02:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984966B0089; Wed, 25 Mar 2026 02:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873236B008A; Wed, 25 Mar 2026 02:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79E326B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:07:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 255231B883B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:07:34 +0000 (UTC)
X-FDA: 84583553628.05.1A2993E
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3562E140006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:07:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsfFvV0N;
	spf=pass (imf09.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774418852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtCjk7jIGe8HtkgOl+H4cw5it+c5WJ0CClrVvqXmnPw=;
	b=dHAt9fJNkciYrSNL1I8dRQ1qy3/LoQWC8uBEEgfQfmp+1uBrlSxLu31JLU2HgmKDpOK9Hq
	196b9WPCq0ynCMYlMB0szraxKSBLLedr15LZFuWdmQ/kaxcQliDObdztUGTtb4l0xglSKx
	zms2F9RRlX1m+qII/11zfY6dMv6MpTs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PsfFvV0N;
	spf=pass (imf09.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774418852; a=rsa-sha256;
	cv=pass;
	b=IqWdJcXXz0W4N74c7+ZPdAirQzdV2/BjrWhJf8x6PWEId/DCFKNEAL+dE3U5W+gXti8Tcu
	auEf6GTSngaOtjeKobv3E2UDBfVVpyGAuTivNzE7hl1YSkByLdydTlmeNwVHkE8Bmg7LNj
	2vIsHHhHZY6lf14tocXBtKwLh3fSKkM=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12a693cdf29so569699c88.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:07:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774418851; cv=none;
        d=google.com; s=arc-20240605;
        b=iI/Sk7wcJOd21RcAo9l100Twv5owVetxBl966CBihevyrpyb1lc/29quXBX1wGgNrZ
         11agliCle0lK2aUR6LL0BI2ceqK8yAi8tX7OhLCPmYYqMFUKaOaKNkCUDIn4NIsCtFZC
         9ziXFZx4Zse+9pU6R4iAleex39vTh9zsaJZTUUfUNbZvDHO7W/BlfdrvhHNKO4IQ8xMh
         Tf97MzUplJekNWmNuNWVCY2Bh6bgWNyJQZW9k2FTI5kqNiKjqStmMPPhe/Xfk4oDfSAS
         l+dzZi2XytOW0U2Lbj1jOQteN6BFVTUH3q9XcEJYRsL4cKzhrPlNURdTJMlfUFyML4x4
         n2pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KtCjk7jIGe8HtkgOl+H4cw5it+c5WJ0CClrVvqXmnPw=;
        fh=8T/LsIY8ZbfvLFHkYIQy66pNts+AJmfCk2D/eUubOt8=;
        b=g/oBXCBd055s6xAUorGRdQ0G0bbsKUeOaJtpmMuJcmjW5IdjYtl8G63UawCWbkQbhp
         jYrs2ODPrhWdUIzuw3I9ZjBHKwZV/dc/wuT8fxUFJClQ+vN/duz3fd4DEe7NKFRFeGcq
         OVwNEaRal5Fpq52ejQ4Vo3mn2A4YYxI+hr/oye1hKHl8w8nRLfKqmP8CLdzSlwdlRFB9
         +yJ7ll/YGDdwOhpActU/D6SvdwIG7VWMyV/opOX+yUqFRGD4NF16yoU5bsdUviq5zmY1
         FyHAMDSVcZI27eZk5qYNWpgUC9917LzE0sucILMk4e64/CKouT9hnZCIsFR0L+QhFYEL
         rCJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774418851; x=1775023651; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KtCjk7jIGe8HtkgOl+H4cw5it+c5WJ0CClrVvqXmnPw=;
        b=PsfFvV0NixprlELcEQOi7OwCxh+GU8Vepwbe9ffu11FYccMX0lZvwe2ChJZUXANogO
         8+wF0nceDanYWWbN2FCGY2ETEfT/s7djYHmeARKR5yGjnYS1VQFGtgg0WROBzmlxl5k9
         Mxjeb5yOVqKGzraUt6zO83spfc08GO5brRDvl90rdRvTED/lZBEYcHhoOxIz9WYcYRvm
         Zl6rHt1iDVm1BYj7E+67TyaAdnWlbykY1y9O/OnwTgkTCkn3EenXLenBJs855DpNo0vE
         jv6mpX78e3vFdDE7iJQbKO4npQOTcUELRaX3kIy2Ym63CaDpZSK8gLSDFp8LdY4nqTYy
         /rJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774418851; x=1775023651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtCjk7jIGe8HtkgOl+H4cw5it+c5WJ0CClrVvqXmnPw=;
        b=hOljCO+7NcCk4wf55wK+WcVaZx2pyyJWjnjyApAUOD6B4OFTd5M7BL/rb52+AJTKlK
         6hNz1ou/Hv0FxUnfdTgyc/Ea1t8PdRC3Cj54MKBUlrhWO/fKd/SgUhTKdnDbhkHZ6kC3
         5Uf8BmY/6QEVO5k+vX3mJ9BTWMMo0qKiXv1xxnrcR3cF/MUAcN3oe1qcYXn/yigoZSa9
         7Azb/vdDmvncWB6U7xV3mbnX1JEd9E3tdvN/CWC8kEBKjR5czdyVR+S3mOh0v+/LPhM9
         CbgMHcCWp4s/PjLPI0VmW8Abk2RpsyTxnDXcGM7aTmOTrgTurwJIKkiUyd3AfDsOSo+k
         Nnew==
X-Forwarded-Encrypted: i=1; AJvYcCUbqlYmAZr6p0HqwmAPiWBVv7OeiIZXUpERl3wZk8vCtCndW/etdZMf4D8mGlq7EbtJMZeQCtY8Pg==@kvack.org
X-Gm-Message-State: AOJu0YxMOkEnDrA62GvWrl0cnTIUNcsr5hcGGpQ274VxSYugVqv1nV9L
	pEwlouTrsGIoKyoFC6KPjakyXWN3y+NiVVzOQklafppjs6MDXQlypPS3KufcFE2J2Vw0fEueo6Y
	wAXNsvZQ+T2K3bG2J7bUJrS8Xy67XtB8=
X-Gm-Gg: ATEYQzzHSiSJn7pSAZFfgcjXotmLGi9IEYUKuSUMNJXRf6cytPJ/LkmDwGsS5tuhC5h
	WKBLjKScj0R2EFecsh5r4QrI5BEtD0CDhKvQGwPWmkZfxsyapt+JZP1bU9HO61w4aLNoiZdtwfK
	y77qebcNfHCjY/muaB7GWrUl+MCZP0/6SvNPZZGLV44aZGYkyItWnGAeEafTqIgOmLUHXnsIqh2
	EAf7GbcuQtRN6QnbEHSw6AzSnEi+OEG7jQ9MH/WtBRiWXhOtJoDpZ7S3L1TcAmKvrwNhXXdrwDh
	kTUBnXdv5Q==
X-Received: by 2002:a05:7022:418b:b0:127:38a9:5abd with SMTP id
 a92af1059eb24-12a8e12779amr2781669c88.12.1774418850537; Tue, 24 Mar 2026
 23:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org> <20260325010618.85366-1-sj@kernel.org>
In-Reply-To: <20260325010618.85366-1-sj@kernel.org>
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Date: Wed, 25 Mar 2026 14:07:19 +0800
X-Gm-Features: AQROBzDgekBiTRh3Wyt5V3QjVPaGatJnjSIYcCimGVtb7zNwBX34hEmD52gmYHc
Message-ID: <CAEgWzV5vp7bfr8=W6aVXNBFqxd9nVc-BGtG1jFUXJ_-+WWmPPg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash calculation
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jane.chu@oracle.com, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3562E140006
X-Stat-Signature: ipxq5borcqin9nn5wdni75pkryfqgsgz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774418852-102386
X-HE-Meta: U2FsdGVkX1/WsUzfrFZIbhkWl4GqIe+x7LeLXPokftKyeg2mKiGeYfgSJY8jeg1rxm5OPIWeEx/BtzoPmvaOYX7MzdNeQolxyn4YrfwEhFhihnFkGMYGnyUaIGUdIAPkzjRijWRBF7DZnZVXaSkTNawFDKe+FzUyytqxI2iwsCAsCWpIE17qjjzYpCVMaeLsHhpOUbz/GbQbiyF6XExYkbeaALL20R5N7KplLgYF/7/2O1hLil3A7e5IKP/21msz9YW1pHpgpUBvjTF9iemgNJL+bZSj3zqLNNzu1pSsgETZmKZ5LgkxPiNTw/DOEmVcSX78nE5cEd3UTguR513ne17s4xbbXIQj1MSwkq1gzb+SqY4hDtNA3tHmdTuivNt6laAm9fqMcVvlvYIadyq2VsJSGeELL12vwxpNzMuCskj1v18cFojoymXrEJwaiGYITryvrb7t5MwOfYrq0ZcqyRoOH3Df04G9m4CSkqDA5Q6H3dGyaSZV0Fxiv2f03PkstqMmoPxdp/2GODjL3Y7h5cpFVHKrADxbT3tbC9F5iEboFjk0Do4+1WlrwbqHPERsn+KiJLl7rBY1fNnj/G0qhDhgztK+GNG8O/GkhZ667Gvxs8g1ccLMzV5+FgpDIqpQYknSkhP19UhLQWVAAmQwP72MyYDdFK26UUUL0SJQkkXt9OimJA2LZ7clrAyjK9U73LBfIW7CtUolMpkwZUpIt3eS1aGUfJfMfCSBWo1Cr2ZwH6BFgxWq8Ulu/hYEvAIc9oVZMrNhwlf70ASLeJw/W3qrp0brxIn6aVtx9XM47Gg0VaZSvdBemX5NAkvddN6ht1Zza/Atc1RPVXC3J4ZZbfnGrbVZB+oyeRjkZ4oosAP6x4tvggSqU0HDbEgy8al4TsRKEcvjVuxT5afvLo857kDL6BvqPZ8qycf9nTj4A9NV81raGdOpfp/JmtWru6IyutRJ5XEm6IKov3+qzRv
 dzbyiAIx
 AIdhMahDDghy3eiADs2++Pz+sLikLCzJEFDJ+V079Bxjp6FaJ3i44gFbeB4GVnO1EMeZw5ErfyaQem27oiSx4SoXevvqbGKNGLc4QVVOdL8+h5krYo+gb6ojPMoUqr/89lvBcEM/gZZ5cfoYFCMBrnH4lGrCkxTOykEAe/WrnTe7fpD7Rs8m4ykwRM8sepSZq68wX7UHlf37PtxiWcZGim4BVtWkespTRiKXJuXbA6zHt2npPbPw9TPNJknB3+Tvxk621ykQ49DR+HPGZQ/Bi8768vLr59u4M/pjz8YT8waEbalpIo4TormFw1O/Y2LxOagCHj7wFLb1af/VGY0Bp0HHnYSsCcJGB5vR3HLEHxLbFYPdboiL01msVHc/8KtpvzFWSWnCvILWAWsRsxMLbbLj0mC2FaBdYrbLBiBhYwivhakZ9reE5qS9Rnh+t44UFnOLmx99MoGoUwGbAFd8TE16oRH7Ito3QzGRVqQr/jbbmbVMESrTNnIqqcr6J37jRyIguv/tSDJ/iEv+Tb6vzIQnvuJq+YZebejJLEs+wZM/4IFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 25, 2026 at 01:06:00AM +0000, SeongJae Park wrote:
> Seems userfaulfd.c is the only caller of the new helper function.  Why don't
> you define the function in userfaultfd.c ?
I kept hugetlb_linear_page_index() in include/linux/hugetlb.h because
this is hugetlb-specific logic, not userfaultfd-specific logic.

The goal was simply to avoid open-coding the hugetlb index conversion
outside hugetlb code and to make the unit change explicit at the call site.

