Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8EFCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AAA36B008A; Fri,  9 Oct 2026 02:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B176B008C; Fri,  9 Oct 2026 02:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C916B0092; Fri,  9 Oct 2026 02:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9F2C6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:16:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DB45140250
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:16:52 +0000 (UTC)
X-FDA: 85302079464.02.267D893
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id F38C3A0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:16:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GFCK2Ltz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791526610;
	b=J6fHnUQA5y5UMAHiZfhNTaywUX94OUl1Mk7ZehTmNRDHVSiSV43nDODYOv5z3iO2oCRm40
	ige+FSbMt1mfPNNhpkMYLnifqzjgvoYGwM6/T1PBu/rMsre6dFlrQeg7fzCX2vtgvKjVss
	tsNcMRwUDbOEAKt6xH6rrGGcpgSf+cY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GFCK2Ltz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791526610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWW6pSaXaHUM1wAEC6gE0iO0re0mXFQVa9Pv7/vaQG8=;
	b=Os3Ypi9VPZyKSJjXPrNlo6R17iPeRd/edJJ086hXGxHKZpAEe+/tZ+Q2aKQhoWBrpL0bet
	nuZoY4jX1uX/r5e0kWcn7kyswNNHLkoCAPdxIFSAmCR5bMkXdRc5S7j1h57puTsc7QS4wY
	KITTpGLk0/gCP6z38OjPUPTV6e7P82c=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8871ada1a26so49186297b3.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791526609; x=1792131409; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WWW6pSaXaHUM1wAEC6gE0iO0re0mXFQVa9Pv7/vaQG8=;
        b=GFCK2Ltzz7fBWAf+qrRl48G8QcyyCSR51qx29NMxgqeY5wDIhqE6Q/V3kX+72X3dKZ
         RnlX8gxKVDAmJMSQiUQ4QSGf1BA+pbKxSvwAJlNwzt1poF+m+O2K+X5LeRs9BwxCA/rl
         73N9Unc0TfHaBL4vRFZfHpk2U98k7Uxj6Lw5fmURacf+wss5zeMri0y7DZkjihTeYvLg
         IY4iorQXXuQxCi8TB7vVjfXjTowngOL7VVF9genLtxqaUVxAaFyjOY5DaEJudr0TlCJ7
         6vI1CumSmicQwCNClWXaXcEhtyBk7/C5a9jzMwrGBANWXBYiMN1Sp3IBL9JWvgTxdMcH
         D25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791526609; x=1792131409;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WWW6pSaXaHUM1wAEC6gE0iO0re0mXFQVa9Pv7/vaQG8=;
        b=Hc4ITD8RKt3/VHV/k9sQwrltn8MVisIMivzc03mUdVoNw1dfZEmyKM026hXKLqdHMb
         hCzUEsBwcQtByMT4N8016d7wBHF4xWlzirGyk8bR/v2KDwTGRaYt2Ir5wK/qNWndAsfW
         /IJggGbU3dRYvN4VlwqT17mrZJfNflBsLzsjXZO1hile8zgJp5PwNc1QSd9lHoxq52Xm
         wjkqHOe5zx9qe3eC+iGWUcDSBJiAEB9azXPQQ80EEsWETZGkITrL88hMv/2gK6UjK8Ys
         gtxqqRnL5pDnqNjKH8V0u3iDHXqGu9QTpQCO7VTZpjhzETc3oaAli74/EvOEdHOLzANn
         sTIg==
X-Gm-Message-State: AFq9FYIM/OFgkApnsgA/aTtUymd4yRbVocyLBH+KEsGbW9f7Z0ElFHVw
	QIf0E+wsSiIz7JxQj4ZbHceE/qvEfzlfI5yfVGbvBrau4mxmBYnCaW7hcFwsn3jOCA==
X-Gm-Gg: AYBFou3YA9U/ntXxiYl96tRcM/6yrErFROzdDiQnGgMBehhro7g0J+VFNl4Ys79Ycxj
	xyqUtEbdExesMmp1mful05aqalV9tyxc1Z4SwE+NQgXo2+74npHZc23+iH0b2vUFxYNZkf/Ptw0
	ghE5ucWbqJ4+6jDERpRWdl5cmrz2iJO3wH6Jyp2PT4WeeyaqkU+6u0jCsbqhUnfV2E6AvmEmI2v
	pSkW3ijiTxhM0VlXNO8FaUk4PgMgNmlRFd2Mzr9fM48wWBHOQo3d92J/tG/GzqYpPSZzzK+Rm7N
	AK9myLjK0Bd523Lp9oqJtdliKnfI4O4/ikZG1RR9yJAYEOMaHkRRgnlwLPHdoVMwGq4SJYDYeur
	bzA8x3QXUqPoxDEm5PRQgGZve2+a2PjVa7o9wQjnlm65mnDCc11Y8ShnA8Xz7JsbyNwfLx0TGXh
	Oym/bhyLDLZpJYMqngsnzDNO6naOnZAnrkYXJ1GHUNrrLk0MNZ+UqVaz8jNE9Yee+qG5WqH78fs
	08J6NA6BPOopngljxmHyBLRoTXOezH4JMVEfR1q07Y9trJ2/BfJx9pZFaI=
X-Received: by 2002:a05:690c:3685:b0:89a:63bc:8c4 with SMTP id 00721157ae682-8b07ee6d7e3mr2905837b3.78.1791526608330;
        Thu, 08 Oct 2026 23:16:48 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b07f1ef106sm3668887b3.22.2026.10.08.23.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 23:16:47 -0700 (PDT)
Date: Thu, 8 Oct 2026 23:16:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kyle Zeng <kylebot@openai.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    outbounddisclosures@openai.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: flush deferred unmaps before dropping
 a failed folio
In-Reply-To: <20261007041001.43181-1-kylebot@openai.com>
Message-ID: <f079a394-32e2-d8aa-f750-d5e3e87a7f42@google.com>
References: <20261007041001.43181-1-kylebot@openai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 8cns654jfiy6fx5ohk5m8a1ryb544j77
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F38C3A0007
X-HE-Tag: 1791526609-282763
X-HE-Meta: U2FsdGVkX18sFej1S+3egB9fOM/HI4/QErPfG0DCcCct5d18Ck2nzlpghqZO5nsin+tTa3dnh6HYBOVkVQujG+d/XJLb9CZpPqx/JLhrNVetp2mEg2Z7W6uRFvJgGk8nyqlA4lcH2aHnH6J404S6EJLkl8/euhrzQI+OUzkULtbK3KcbTPoMlf+pIgf41ThQVgCcORqz9PBqFdAmKL/7vj4kBkU6QAdL3aEVi4NyjT6iHiK+8RqFUpwD5JmWGN7rRFyWf/RN4tm2ruEc12uGuOX7w1W6MhcJW/UwS/GsnFC56uUXZrYVaFMO6lKtP/rfxLvpQvUiLVd87svIPa64xQsRMiEaeBoPWi26HsbP1QFbZrbaWGXVT4wpli449vPGdgP5n0oQ0qDaLQF8U5vPOjRt7ah4PBBNBKoaAJ0gkGqBklNRzPxd6e7j6CqwM+4c21jutVv7MHb1t0abtVr46lH41vV/k2PndsLr3/Qcexxz3KW5En/XGDDY9IOf+fNbD8DOzQZCHPaktoSuyHoImhuCSuTOCIV0o5wYJ77vY4PjE6ZUrcExb91Occ3l2r0fzDODZ+1aHCmKl9NMuSYCdhSYdrJ4ihXjCs43LLPjcWIY/bHxMqbP5JZBQMKz2QgtRXq24GMDsmm3o9tUG1rADf8MHdBLvtWz2H6hIosmTfP3geo0IUVYcnW8k3dKX3H0jfuqvhZLxzQIMu1jjdmmH90ELKFpX4uZPHVWCYlhrf7APgMP96pIS7VLThuToe8VX4cWjxkjQ9OevMJ79dVPi+8IOg872M4rbrc8ZZpbJKFIsEsSQvs3ZTkNPwXrV6h5Qtb+bhQq9hRjwEDSyAeXiLPFM7Kxfgn8yOCRqIlZmblAeGk1b7pT5ZgQnmBmYJvnEp05rq5hjPz16FzlExmtXaAlZ1y39YB6khuNne2DBNsmi/ay/+BDRKSyi9cRo8oJuT0V2HZ0l+LfNAJathW
 98VaYsgH
 qkR7/CjHW1nuCd90aM1hNR2BAGQ+UpG6utuLb0ip7UYVQn4yOMFyEPVisgphRnbHLMWexAfrxOwSq7fLzTopedIbPUAk2kMqarXVgWjy6A96kIeJduPlpHomxPEjydHDHNI8kOjpT8g8JFm1eqhvK5MBuDpDOfQOZentYgcbczPT4L4Trif8RNr5QOexH0dgy5D1Or1jTirEkCHd1FDiPaRFkNjYOjRcvzKLgTQV24so4Ql5lm4bH0G19uV+0HHtYok4ulm535iRBaSEuGGLyPtRG6he2JaTpAcC/MSzauUet7sSfO/RJXiaMFHRtrUvrhxBNTfzVCFYaxzqtwUH1eTSDgVHOmFzF3LQogXI3o7um8CPpH7JvfsLNCPNaeQAYJEPXoBewRg1Z3ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Oct 2026, Kyle Zeng wrote:

> collapse_file() can fail its reference-count or dirty-folio check after
> unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
> then unlock it and drop the lookup reference before reaching the common
> try_to_unmap_flush().
> 
> The page-cache reference does not keep the folio stable once the lock is
> released.  Another collapse can replace and free it.  With its PTEs
> already gone, that collapse cannot flush the first task's per-task TLB
> batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU
> can therefore retain a user translation to the freed folio.  This has
> been reproduced with unprivileged MADV_COLLAPSE on a memfd.
> 
> Flush at out_unlock while the lookup reference and folio lock are still
> held.  The common flush continues to cover the accumulated pagelist on
> both success and rollback, preserving batching on successful collapses.
> 
> Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Good catch, yes, thanks: the folios already on the pagelist were correctly
flushed before reference dropped, but the one failing folio had its
reference dropped too soon.

I might have chosen to fix it differently (holding the final reference),
rather than duplicating the try_to_unmap_flush(); but you've put a nice
comment on its no-op when already flushed (thanks to Zi Yan), so I don't
think it's worth messing around with this good fix you've already tested.

Acked-by: Hugh Dickins <hughd@google.com>

> ---
> Changes in v2:
> - Use Assisted-by: LLM.
> - Explain that the common flush is a no-op after out_unlock flushes.
> 
>  mm/khugepaged.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 75639298efc2..e1a5890818ad 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2478,6 +2478,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		index += folio_nr_pages(folio);
>  		continue;
>  out_unlock:
> +		/*
> +		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
> +		 * Flush before releasing the lock and our last reference.
> +		 */
> +		try_to_unmap_flush();
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		goto xa_unlocked;
> @@ -2488,9 +2493,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  xa_unlocked:
>  
>  	/*
> -	 * If collapse is successful, flush must be done now before copying.
> -	 * If collapse is unsuccessful, does flush actually need to be done?
> -	 * Do it anyway, to clear the state.
> +	 * Flush before copying the folios, or releasing them in rollback.
> +	 * This is a no-op if out_unlock already flushed the batch.
>  	 */
>  	try_to_unmap_flush();
>  

