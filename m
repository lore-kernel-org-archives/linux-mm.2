Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEAD0E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA156B00B6; Mon,  9 Feb 2026 17:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D996B00B7; Mon,  9 Feb 2026 17:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B636B00B9; Mon,  9 Feb 2026 17:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B556E6B00B6
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:50:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 641868B2D8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:23 +0000 (UTC)
X-FDA: 84426413526.07.30C721C
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 823B240012
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:50:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f5LOg/Jg";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770677421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA4dh7jgOju15KIFAKWH2cMywlL7aEgIic5gcSPDokc=;
	b=VmMWiH4C70f6XphydJKeEPNinzWuXGgDMbNbuhdTltGK8pEy+3wYXpzTwj5rxuJ7A1gUL0
	M6HDsNSIa5rTfhYakvdKRrY1YTQvtMCJoFRG/IQhw46fJg5FlSsBkmNRlbafS3Q6CrG54+
	WjmIhT5OL2kFMAJIOoi6jz6JK3VnkK8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f5LOg/Jg";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770677421; a=rsa-sha256;
	cv=none;
	b=37NheqlYmDN98b8ibVfhXUmx458CNhLg29ANRILs/knrFlxZUlqkqE88/6UfP57ybBjQHq
	RP2sgme8LejAud8Z6dhljYfpMTaSNCVmUAt4+syyJ1hIuFtk8puChlrBGO6m1Zp/pc4PF2
	T7UwJhuhu+2hqATJTXPZkZzsyRzPUEw=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4094d7d71a9so1159488fac.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 14:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770677420; x=1771282220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xA4dh7jgOju15KIFAKWH2cMywlL7aEgIic5gcSPDokc=;
        b=f5LOg/JgkmfxdSaa9p6tlQxb6z2qNtNwi3c+vHMdqGpwrh21p4Us/5Qho+ZVl3LNU5
         /9GT5XwXjYpMOUa7X/mNBYIH71pvlseQfCEb/b5yNhmdh6d9ooI4Bu3TgJXQG8mY8gkT
         jY7RyorsZ8JeIuS7ZSIsv8Pz4pzdHrBs9F0Nv6X8EbjpngNUj82hQcF8B6d5W1KcpWDz
         39g2prs5rk48FuQlQkLhdxiLmlyJBGEIx6wjxbxsBJel2Qp411vJyni0GmgdVpv4OAlV
         U6RzynCq26Jp4CPBau4O0dQF61INZy5KBYcgvGrbKnF7+vd77v0lAzTMomqEcvrNE7SY
         BT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770677420; x=1771282220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xA4dh7jgOju15KIFAKWH2cMywlL7aEgIic5gcSPDokc=;
        b=a/+qFc67ueM23aGF11wNjCobwjSLc09lZvq6koQLxmHIXfS10YHBGAUZ4pkdDVjF+D
         VYlHnVx6sC96Rxo9PsLIZx5y584Qzxu5MfrESyruWn/aJpn9Hk4+35xzZ2QV0F0xxIZS
         ggJh55SMyVI+ueL2wN52DOOz97piZ/p8SfGWPlyCu+3gWBZziD0z6KZIVAzOD5QQB5eD
         mRNemD9Y/KW8PGPVtF6emGzeBVN8fDkvshMvl+pQgq/9jSVGDqAELU9kz36ijxOuuHD7
         UDJwZjfgpRVJmYbGQdVyERGC//bPacfmkp3jn364HxldOyDKo1pXRnqj1XfTXncJM/Fh
         nRnA==
X-Forwarded-Encrypted: i=1; AJvYcCUfNA17YsAmzqjLLCnctq9Vt8nHqL8lY5H/1ZIlNYOHxt4mErfvBwqNncLh34D7/MK/MfxIf7uO1Q==@kvack.org
X-Gm-Message-State: AOJu0Ywha2mSCRMLjzzm8ZucOPQ7ONkYBJwKuHuQ42kylMSedDy5aHpQ
	u2o49kdDBf/5r4BpCVsmSJK1Fp+74wBRbHkmlWjrd8x+GHLLatMadoje
X-Gm-Gg: AZuq6aIOgaO01YZCdZTNpzZpQxXZ9ubm187KOPShuesaEIwCucTApwPY4EBbtFoaWRL
	aCfr6D5ZJ5QsbNotuXPZ5DH3xeE7l5xMH0b48CLhipXfmNGWGb7YgNSeniUF52M6wIfCUvj+wkX
	MvvqTtdst8EPwuWOWz949u/s5uGLp7WYhMTGDQG5Ctq0Tmysek9ZD1gwkU+BqZLlWhQ/E+p5oLT
	OJA8Nlp7VfyKlxRsuTGl8lgR98kvCop4oBqBfJZ3XDhl9ZjQTU15BbAF5L6UtE3xFWeq4pRzNbh
	sJSnb7EgYav7rirXF0C4+17va34x+hMfNhFBWnUrp+vgPuN0IOfmgOcGPlHyOlwYY3433hYnoIx
	ES19GruJGHLO4eg75OZqfv5nvlddSu9SOtKaOD3QPlNEgOoHCaYBErRoNZ0FtMpEF9mv+V3LvQ9
	P30BF4v9b+7g==
X-Received: by 2002:a05:6870:91d3:b0:404:3ecf:9ae5 with SMTP id 586e51a60fabf-40a96efb5f7mr6611040fac.40.1770677420355;
        Mon, 09 Feb 2026 14:50:20 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a99644531sm8546489fac.10.2026.02.09.14.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 14:50:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michael Fara <mjfara@gmail.com>
Cc: senozhatsky@chromium.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/zsmalloc: fix NULL pointer dereference in get_next_zpdesc
Date: Mon,  9 Feb 2026 14:50:16 -0800
Message-ID: <20260209225018.1541260-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260209193257.60393-1-mjfara@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 823B240012
X-Stat-Signature: ts411w56bhktahjadjn8wk8ibg6m3bqj
X-Rspam-User: 
X-HE-Tag: 1770677421-623224
X-HE-Meta: U2FsdGVkX181fmG4Wx5HK4Hq0cc0FoC3wEWFJIy9kZcjr3NPZElWMVEVvkUCNI1MVCqWAZxFHt8OvjX1AldKLhB4npF2zKAM7LtZ0PSSh+4sCbnD7VexD/eqEHm9XPjiXIblmYzpJcSA4r3ynDuQRNa23tOmF8wOlz8JtiLWXGErV8cQ+1QuoR1a3BpkBQLL1alVGLK/OlJJjfaRBNcYVy3Zmj3JEZfJnAK7mxKSSR0thGleQP51KY1exJp0bkt5V+zu17DLmWUn/PZexkkeyv0nJ2HNRkiJDYeiBneAl2p0TqJDRLgSYbmLocCBEuYXhzOqndaAINxQBjU42mO2G0yiWWClTYF6+AcQuRktY2iQCFp6qvrVCfq1KuXEqGdIBu3jaouRCZpJPBDPo2ScPiCc6/kkiR/ZerMo3t2f6r1Qs85b2A5ml6h3nGGsY5KqEowA4sFVRREQbs3kVk2VhSQkAiPtMHjUWpM2TcG8BPXxUzavzAhN5noqXvcHAnjAQ9lFcS57URedbmOGy0Gm179YDhUTqbYg5ur1BXVe/yjdR4Ylv69I+e6w4ksYYFmSyR0avErY+V94Fa7/zK0ZipSl8VbzykJXIlCgTPYHxTzWQE6EaQ1odSpbvO0Sk+W8gmZGUTbfok0sYyD2GWvjRpzPSio7RkQmXaov7cX8JUTmCbW707xJ68IohFJwfeW7SlgbAXs22/y9XcxbZ4x/YMWHr2hZEac3hfjZX0BaMci5l7bTfR1+srL2GhJPfk58Byn5gFDk/5FNgQVcbHVy1rSl+MAyNUPG7fxvyZHumyIZcFZrEm11mdzGgnbrcolkvKhrqc/hyPKRIeaHYsgeimeY44+H2jZ9+i3BEPC3WBZTJFfr57hX2hs2qjH9Lofd4FXBsiZAJFsRecNtniqKtQd13oSGc/awISK6z6t9i6Rjd42UVjlTfknbEv2lgb5cwkFheDbP0Zdo1VmpjJx
 RyEdrk/k
 SLjXXdTw5f/P1CRijXLLcCD/DOkhdAFO1O1Kut1nmWTtAhtkYj6EOoJN3FGGWlLbdTVuiuRQ8ycHDSCoIjKHWlem1uuYP/j8B2qTpRgpYu0uj4XO8G/ccrB26odvnzhMRjIqjq24bCrncvnf5AY2NOM5uZ4/llDhh50RxIvlKRdFk/ZciLXWr51MnyBq9jN2S8K3Qap2nZXiloepct2VvoDJhgEYR/uzJphoscnV+X9DU288FZ+Pn9X77PFIKod7pb6aNbtSKOHymp3bYSleVFO92Vxlk68BAEvHs/jUmc82c/7PttF+cAouWcgtMXOUD5gFnMl13DUpCNQ4Djgxh/QEjj797n5eLlFNe8v0Z1psRejUTaxxNKM7YsrtugvphSQJJhqFgFI1HbvceqF0EP6AbeSEpYjBzctS3zbi1cdsj1Acst5MHu7x4VpBrKEK+1OjL+JKMGREGlf4pBn4HwWg3cV6gQJ9X1i/NZogPpStnUwqd3NDfeNDP3LCCPkqpw+eYXbEeqq6JQsQY6XuBtKbh06WWkBKtuZCOeAEpqQOjfVaO/ZO4zG1ROmsGn03lgdkMZH2EPw8ishE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 19:32:57 +0000 Michael Fara <mjfara@gmail.com> wrote:

Hello Michael,

I hope you are doing well! Thank you for the patch. I'm not entirely sure if
the race condition that you note here is correct, and also if this is the
right fix.

> get_next_zpdesc() calls get_zspage() which unconditionally dereferences
> zpdesc->zspage without a NULL check. This causes a kernel oops when
> zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
> between zspage destruction and page compaction/migration.
> 
> The race window is documented in a TODO comment in zs_page_migrate():
> 
>     "nothing prevents a zspage from getting destroyed while it is
>     isolated for migration, as the page lock is temporarily dropped
>     after zs_page_isolate() succeeded"

I'm taking a look at zsmalloc these days, and I was confused by this comment
and remember looking into what was going on here as well : -) My thoughts
were that it should be safe in every other case, though.

> The sequence is:
>   1. Compaction calls zs_page_isolate() on a zpdesc, then drops its
>      page lock.
>   2. Concurrently, async_free_zspage() or free_zspage() destroys the
>      zspage, calling reset_zpdesc() which sets zpdesc->zspage = NULL.

async_free_zspage isolates the zspage first by taking the class lock and
then splicing the zspage out. free_zspage is always called with the
class lock held, and it likewise removes itself from the fullness list.

zs_free -> free_zspage -> trylock_zspage holds the class->lock
In zs_page_migrate, we call replace_sub_page to remove the zpdesc from the
chain before calling reset_zpdesc, so I don't think there would be a race there
either.

>   3. A subsequent zs_free() path calls trylock_zspage(), which iterates
>      zpdescs via get_next_zpdesc(). get_zspage() dereferences the now-
>      NULL backpointer, causing:

So I don't see how a subsequent zs_free could race with reset_zpdesc on
the same zpdesc, maybe I'm missing something? : -)

>        BUG: kernel NULL pointer dereference, address: 0000000000000000
>        RIP: 0010:free_zspage+0x26/0x100
>        Call Trace:
>         zs_free+0xf4/0x110
>         zswap_entry_free+0x7e/0x160

Is this from a real crash? A more detailed crash dump would be helpful to
see what else was happening on the other threads!

> The migration side already has a NULL guard (zs_page_migrate line 1675:
> "if (!zpdesc->zspage) return 0;"), but get_next_zpdesc() lacks the same
> protection.
> 
> Fix this by reading zpdesc->zspage directly in get_next_zpdesc()
> instead of going through get_zspage(), and returning NULL when the
> backpointer is NULL. This stops iteration safely — the caller treats
> it as the end of the page chain.

If we return NULL early, what happens to the remaining zpdescs in the
zspage? In trylock_zspage for instance, we might exit early and think we
successfully locked all zpdescs, when that isn't the case. It would eventually
lead to a VM_BUG_ON_PAGE when trying to free the zspage later anyways.

If you have a more detailed crash trace, that would be really helpful.
Thank you again for this patch, I hope you have a great day!
Joshua

> Signed-off-by: Michael Fara <mjfara@gmail.com>
> ---
>  mm/zsmalloc.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -735,7 +735,19 @@ static struct zspage *get_zspage(struct zpdesc *zpdesc)
> 
>  static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
>  {
> -	struct zspage *zspage = get_zspage(zpdesc);
> +	struct zspage *zspage = zpdesc->zspage;
> +
> +	/*
> +	 * If the backpointer is NULL, this zpdesc was already freed via
> +	 * reset_zpdesc() by a racing async_free_zspage() while isolated
> +	 * for compaction. See the TODO comment in zs_page_migrate().
> +	 */
> +	if (unlikely(!zspage)) {
> +		WARN_ON_ONCE(1);
> +		return NULL;
> +	}
> +
> +	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
> 
>  	if (unlikely(ZsHugePage(zspage)))
>  		return NULL;
> --
> 2.39.0

