Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84423C5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C206B0093; Mon, 10 Aug 2026 20:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515846B0095; Mon, 10 Aug 2026 20:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B546B0096; Mon, 10 Aug 2026 20:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27FD76B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:14:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 915B340300
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:14:51 +0000 (UTC)
X-FDA: 85087067982.07.48A29CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0031F40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:14:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKM9VFXT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786407290;
	b=HCLS4MqbmKh1NbDfJAmqHORePY4d82wmdlkIXJJZKn1K2IIn/SgSgpM5HcCRo2dZD+eJt+
	sYOCTKUxq9LzT4LTzeoZrGnwVKeUDDjWECwssxlp4kfwmU0STZYYWGS1Xw/eW2JbNxB4kf
	+n7uZJsuxtnIduxgAoJZIUHbENdEv4s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKM9VFXT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786407290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S842M+3n5foIBaw7PfExfIo338XkNBz7Heie7VOdBHs=;
	b=3OzSm8wtlgQgIIulTZZAmGxxsIF79vhPonV3ogZVSGY4QKTQS0aAt3ObYTNmvAgbiSffTk
	h17VtBWG0KoNYoKlOKfLOM55NPV6pxg7+2x+nfBZSyGAmHfrWREV/Y1u7N++frbR8iO+QB
	OPr8xj++HhPQaBhD/H/lnUlVYNB60RM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37F2B418E2;
	Tue, 11 Aug 2026 00:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC671F000E9;
	Tue, 11 Aug 2026 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786407289;
	bh=S842M+3n5foIBaw7PfExfIo338XkNBz7Heie7VOdBHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKM9VFXT7C8RTuuoXq4xhMvUlWXrYg5/sDDHUAiI8E2ZVq3ShgIPAP+a3DNdtH3Ie
	 3Ittxtkc9ePPf1SoQG4mPGRn6TLCkXIZ+ndPpCCbUAYK2beENX2+Zo/ywqvmIaTPWF
	 vdHBnhrnwSYyPc5b2uqr5sVDqI1VV3CfU5ocfdm/CaBcxORcUMh+YMBiUMP5etREcO
	 7Gto+zvpyw6/aGnmNPiqneoNTjNCPJfn+oiglCwInzHhQ16yjBKETjYPwAvKYaBVJ/
	 c4VZXO12K10cpa8cp3k0R/JBtTp20Ni9GtT4sW8XUfRxepwm2TEcENt5o+IKIkrESD
	 jX6/A7OOre+kQ==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/cma: remove stray newline from auto-generated CMA area name
Date: Mon, 10 Aug 2026 17:14:40 -0700
Message-ID: <20260811001441.96169-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810093215.91419-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0031F40003
X-Stat-Signature: d4prhohjiepu54i7qohiwc11jg8xx5na
X-Rspam-User: 
X-HE-Tag: 1786407289-907893
X-HE-Meta: U2FsdGVkX1/K4XcGzAucogjgYAIUi4X/nWfpmtAypt/lXKcCei9Rwpw4IdFf7GlnYDfAi2Tp4wWe0bRWrJDZOCI9wL8yaUs/CJDu0gsc3UhQXpi7ytZLAgED+T+a+La3Lw5gjghFy7WOT5dif/f5PlNo3EPOIOQpKXLj75keV+1EDG/Kk8DX7+tFNkW9j3hm2fNZI3jixfyfQjdj16MshRN3Ve09GFI5tIUio8+C3V2bLYribd7bLyy206bBb3SxRAwVEoIuyOOaoGk6TCnofKpDv/KezuO1qQm/D7bT8BKPAnlo9mzgIy95cSrDcDJaYjyrGXntjctRabH4mj3GgwtwChAnHnnMbOlAZTXEsqzRCFQVhJVA2pQzet7PyhlCQPhw7Jk+8r8F2j5z4DthqmxIyOJ5ME+LiQ6zPWFFf2VyuiHMEF4fBfEu5IJCl3FgFjFHTTIBz0Ykt/Tzo+xeoV30FRw8KgfktYLpmhCh0y+yXhok3Iwum0okK+GENX48ouL5uIT1X+vw/VxwTGoG0l8UTyr8ebRcr4+1W2JlPBvQ44HOXPp84wzweMQVSMiTAl1Apr8JomMUY2J2m4spfY8iGVezV7IbNqmX00Avi2n5cY0AVVyNklMY+17jVq0IRrPjWofOAEqEC70A+Y64m+u4kenxGu2fINzFsmppS9GaFjoD1Alq4eO+AZl8A//SGMlR34fLBMwAaVkppQnMOnu8NbwcxTfmbLua7BGDOrp7G8FPoH2kXUvX94w7NKRhbqIUf3Degt+IBRyyYcg+5zKSUDg54M5Ddj+/suLYRUdyssyi4nF0ccz02dhHN4OgiIDHRqKuo++KUtdcc1iI5mhl+EImpuXWI/oRd639lOd0zC78cru6fDGqqOkGS230ZLMykudG7D8zuc/enTl42v2oIIpDhoPx5ogsfZ1xFNA/kwUVvsM+tvdwis1RSli8zT83pD8Ml0XXgtY2e10
 lwVl2RmZ
 /46KIEwQUmDoKuLcWEuHA5Bk9cNREgHi43yv2P7/c0l0mQczsyZ/T7pT9MpW6DlBWe1e88hjTEftD27TTuWACyD05h//ybXuLuhXp82ZjNoHNDuhanxQsj1Ft85UAjhsHk5t8owouwwxaw2OO5IVsBwQH2DaclKZznQZoAucPQaBCITePwZo8tkTIX56829ZUC+B5m96eWtZi45C9zAZsauRIsxshTrdivGa7saDcWNuduZB7+CTlwyyW2tOtTMxEC5x0HfVTLnAkjrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 17:32:15 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> When no name is supplied, cma_new_area() generates names with format
> "cma%d\n", introducing an unintended newline character ('\n') in the
> CMA name.

Nice catch!

> 
> Most CMA regions are created with explicit names, so this path is
> seldom hit. The newline only creates cosmetic noise in debug logs,
> traces and debugfs with no functional impact.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a7929c758df1..a10ea37a261d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -242,7 +242,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	if (name)
>  		strscpy(cma->name, name);
>  	else
> -		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
> +		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);

It also removes one unnecessary space!  Nice!


Thanks,
SJ

[...]

