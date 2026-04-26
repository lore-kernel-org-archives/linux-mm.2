Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BD9FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070606B008A; Sun, 26 Apr 2026 08:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046A66B008C; Sun, 26 Apr 2026 08:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6676B0092; Sun, 26 Apr 2026 08:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D99BB6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:36:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E488C17A8
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:36:04 +0000 (UTC)
X-FDA: 84700654248.12.60A7CEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4FA6160003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:36:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dtw9Mvfg;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777206962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDbrgHw+jZdxcc0yj+q24rw9RPXOdbYWmdGQz7WtJYg=;
	b=V7lcqpIM1BhCPtMZfLoMPBNQSYK34YNPVEvly8SkEfhRUIkoyMyT97BlV0axmPDDS5F1yn
	pJULZBP0WlzRK9NoQ6LQQ1O3nIJLAM7toGgbF+uszXBGQtxmozeJtu2+3kmtVTACcPsWbx
	KXz2zKctw8hi0zVBbWAGcAsjsfcDHMw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dtw9Mvfg;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777206962; a=rsa-sha256;
	cv=none;
	b=Ar59B2XRmEJvtN3OJct7jrjSJnnP7zQELBZHOY8UNtkbMklz+DmtZLANebkfklVThkRPXZ
	YPRxhJJW0rSq5FQvhgZy1kQpsapQZ8EwbbAgO03BAP7DgApzp47BbrEiIry/YjMmjo5sGj
	ooTotU75E8IBwD7Ghm1aRnt5lFresPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13D3860125
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5F8C2BCC9
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777206961;
	bh=UDbrgHw+jZdxcc0yj+q24rw9RPXOdbYWmdGQz7WtJYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dtw9MvfgRhXX/ZPqDbg4IyvPfwVxAjlQp3G94FNPlOBt1LgcFzUkYqAzynWEsBllY
	 G3v4D45pa3Dptv3F+SugseC+G5YTIsrozEp+UcVQ0mQVf8mQR7j+Qt7xuNeD1yrivZ
	 3WP2Ysa2CSA5wyeDfQyLLmOoGDbTyNPyZLYxjnIZVhnS9AvQqx4JvYIUm07Ibahasv
	 QmwMVCDu1Y++NyDB0W8763XX6mTg9dRDHuEmgum23Kk18Z8rlr22MvN2Zikl1W11C4
	 hHqdHpg9rbAHtkmg/+sO5btZRigjBqiLINITX12fO+KYXeDXgCCIcxkImCNODaQb68
	 K3yP243S5H5Ug==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d75bfb259so69646811cf.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:36:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8KzKiAZkhajuBtPUvdt/XJpQ2enOVLc5GL1nKBElsXKoQO771hGDA1SvRBiPp0u32tLOgKvUT3vg==@kvack.org
X-Gm-Message-State: AOJu0YxeMLFWCaOdUdS6lLEVgdRBSXL/1eTey7x5x1AArgVwNeMZgQ8C
	t8M4u3PwLN7BnPJzwVgx8VG7UrmcqGLTgdLtkdaR5e5RcZwSwFzGoH3OKMIPbRFqb7CWYHuHFRd
	0R3vY1lo7X0YQz+igllmodCIatl8BiF8=
X-Received: by 2002:a05:6214:3385:b0:8ac:aeb0:2eb4 with SMTP id
 6a1803df08f44-8b0281573bemr664694236d6.45.1777206961024; Sun, 26 Apr 2026
 05:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
In-Reply-To: <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
From: Barry Song <baohua@kernel.org>
Date: Sun, 26 Apr 2026 12:35:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com>
X-Gm-Features: AQROBzANUl9Pcz9hyjO7uKCugSQGl3onSRWlRS_4KEaYUsDc_mdraZQmarUsz1w
Message-ID: <CAGsJ_4wo8Chd-B8oRwTEQsU+CQu_tvwmkx=PdNweTBTQLDsRUA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A4FA6160003
X-Rspamd-Server: rspam06
X-Stat-Signature: 4a9fjjg6i1ypkjx3boqkmn8ekh88fuh4
X-HE-Tag: 1777206962-368739
X-HE-Meta: U2FsdGVkX18/Te1NibdntQzzhj/AaVYgn2VfPmPlsahlXOlvRNGwQ9Az9PIpJufCH/oZTvTwfuxRT+JR+VwNTMWYnsD14eoKVQ0IUD6mYniP233mHAt+xCMEMO/fTxSWm5vaKHanYvWl5/BcNeFTwKsHBLKPrsBzmYBZDBrkF7MO2kP9DRZY9SlcIcAASOIwvQvcpo3EUI/DPasIoTJSqx6/haAxu8pYsCfhkxe4M9EsLAzHtPnsVWFhAIA2L3HZXuMdXOwJ9Ubh64CKjG/UWWUiHpGdz2O1RRsoZwwHGIqIe0vRcgZ7rYp/0PyHjs9XWRYoZNf8SNkStr3Fg4lydz7wJlK61dDcNbhzDNXZAwXO0lqA7AHNTN5MWLccKWLHuxYfGIfQOuxgFbNefEPOHUmDsnxoZSfkBQuFs+wy/y0gAZiZ8KTamaCcrwcBLs77dpNiGTqnWsTn+zGa0y6brxIt4i0JWdOEksBZOQGeptiOG4uWG3hq5mXwNy5madlWnmp6y9oEz6im6k7TCGvqBaozPRQGRRouGMDNGMrcprNE5P0Lzg0+oo3/eeCLxzfSPQsM8Kc39AmffZD1PiTiWXvUMVWsVYzf3BBbscxcL//TuLopZIGvssGCeM1/GARqRmr1yHVeJn7efWWP7MhUbESC3YA3+qBghzgCeHzQkxjrNEpXl/60dKkU6n5fc38rA10Y8CJgls1MZrtSDgVhpIfd+Zd9o4QiHXU9ms+oyOVAlijmJRtRCaJwTsv45J3rXnG7PKQDEl8bTPLfBfjUKYCzlH6uLM3RCObqYVVHh+IRGUlohqqpsvop+Xc4kkUmaYouVgz7PVpbbcc/UqxbIx+27iduYqWw48YUH0E+F167xaZNasFueIUaqoKbXAFQp1IbVpKd0cYNP6nbP70RsiGFUROzRj4zVI/fQ2eyFK7syYyFOZjr8Cl24pAe4sRPdK7CNKWv7NWImEOTGLx
 3S7ATFyO
 z3Ys/qs00ftnoq1ga+6Fy8B59N2RLPO1HQitQj10rRalhgBKUrQqj9P7LBEAK0UnRN9MhCp693ieHCnQrFKjiV5PW8/N0DANW7FLXLiChuhgp+OYH2qyNcdhMYhdZWJpZ1PoV9vNF5hW/ytoGoLgOtu/dq5gUL43mvuDSEBZqYJkc2dXENAeBR0ay9x+UH73MaBVhGvsX+dFJRM7lTNVir5CLU1AEuwnBW+Ed9qnZ3p575UJt65htqkGW+bSULB+0Pzf4ncyRdLBmAZ5F41+l/W8vXW8ykjx6WOTIwZ357QUUSkwJbRVneU6N9M4bt2g17hEiaSXnlm7XZuummJov5nZv+03CM/DaB7hKRwGCBVrnU3qGGNFXKkcikkoo3BfBYXN5tVpTdpsRapDI5T6H+i/UhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:19=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> w=
rote:
>
> On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> > MGLRU gives high priority to folios mapped in page tables.
> > As a result, folio_set_active() is invoked for all folios
> > read during page faults. In practice, however, readahead
> > can bring in many folios that are never accessed via page
> > tables.
> >
> > A previous attempt by Lei Liu proposed introducing a separate
> > LRU for readahead[1] to make readahead pages easier to reclaim,
> > but that approach is likely over-engineered.
>
> Why does this even need to be kept? I'm not sure it makes sense
> to even mark readahead folios as referenced.
>
> I'd suggest folios should only be marked referenced (or even active, what=
ever)
> when they're mapped. Anything else is a bit random and is hoping you are
> eventually going to map them in the future (which is not true for, for ex=
ample,
> anything in an ELF file that may be readahead but not mapped, like debug =
info,
> symbol tables, section headers, relocation tables, etc etc)

The patch targets the mmap readahead path rather than the syscall
readahead path.

With lru_gen_in_fault() in place, it=E2=80=99s roughly equivalent to
the mapped case, since readahead is typically 128 KB while
fault_around is 64 KB in PF.

Thanks
Barry

