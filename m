Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E91E7C704
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 07:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062B96B0088; Mon,  9 Feb 2026 02:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D2C6B0089; Mon,  9 Feb 2026 02:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48536B008C; Mon,  9 Feb 2026 02:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80DD6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:36:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 744C11406A3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:36:33 +0000 (UTC)
X-FDA: 84424110666.03.826CF35
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A16A20011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:36:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mjNXtNI5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770622591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vdvgt99PcRK8hiWKZZhQq4N7eLbMYGzCOLNBd7EwcXM=;
	b=uBEBE1DEulxPk8hkLyHP4dQFUczc1UZEsv9uNfxgFiLHXHM60F/xvfi0zaw1xLZ+V1NZA6
	a2YKxxMbchciO1DaDv9DaVbngErjIl6c+d6kBWPNPVpTJY0QsPItNCkkUyxZfGmCyI9QFu
	4Nbu6I+aTYviCz9eJaVtplNjBc057O0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770622591; a=rsa-sha256;
	cv=pass;
	b=1q5I3hycMFZFnwNUgjrnM6Wg91MvUoka5FXrBLepzm18kpsi+YHdhvBd+oZvPPhd2afNKP
	As3z9uxcXf6QKAkK27D3YAx2SN2ZPbC5NooDOM3eY94Y0rGBLdepGcQYboRuNjebCUEEaF
	FUP5uHuiFnhigxM/6MsyMaCLTIoTxpc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mjNXtNI5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59b717b0f80so658813e87.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 23:36:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770622589; cv=none;
        d=google.com; s=arc-20240605;
        b=HthnM4AIAewExTNAXBk0Y+Op+qipfKVFi1nkPvZxoFLMnwozxTHdOnV123ro9NREcW
         Kt5YNTCfDNarQWigsB5++4MMhoYSBN7Qg5j24U3Crdxu93/FWGohfois/3PM7johvez+
         EqksIYBIBgbGxIAJviZVk0Fo+twjMM+qKewUGjeKW/Wzj6iPBGtdcWTg2O0BsUal6jyJ
         4zcVGyudxoWc5eXHJsjv0Emi3bDBsnEYq0WAfRkxWexbgycEN+2invBiruiAznr9p2A0
         nTig+fu71DHEOhhPZjjcOlWvr4oO8fq3SPOXonHr3klDAxOgV6RrrJ3lg03jVUN43L19
         duAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vdvgt99PcRK8hiWKZZhQq4N7eLbMYGzCOLNBd7EwcXM=;
        fh=mQx5LfgHKd/tkHZw++7k7NoNBqK0cJCnFx8sS/5Wf9c=;
        b=EW5ajGN/axtT2LB6uTTfmzpELMpgglKpJUa93+ydxBlqlsU/+aLd4/Nyu7vFiMwDBu
         FnUV1py1ijNGTzn41FgIjPu/F+70IotQvnrrqFI46hJoxZWYaCMrY82cPXqLo0TVaOat
         PobwHYL+qsjTPZb6kON+FcjGwzUuwDfPDm1xreZkjxgjIpgsJGUfYxNaqSXtRAo6V/bJ
         CMI+SqMrwtS/KMIAx9dBmqgGbdY4JPPNWsDjuw0xk9vi/GenOtqj985/XAb7nRVwGtnw
         Qx+HWWApkXhSL2M4Ti+ebKO3kbJkIQ+KWToh5YvwPlZ6I67YfUxxmnoRCZJE2nCXYf55
         YuqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770622589; x=1771227389; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vdvgt99PcRK8hiWKZZhQq4N7eLbMYGzCOLNBd7EwcXM=;
        b=mjNXtNI5NkaUFw3puTvgO2rm1VyDYV0dbdlqcbMsfYqAFtYWbzKoVNuDnaf895zcH1
         c2Graa5QYlkbasMiqy4+LNWt36Iy/pn2r3C4HlUNuT87IqweLeXlXQ6oxrfzFGcxkGgz
         BsSobIP4LWtRsUnVFDIVdqjg9HljW4UAb00iLkiTLs1wJdQZhVr0sWVr/+KvUHVrgB9c
         x8QoNvn4VWFJYZHm5NE6WGcHo+cKDgpKnID/c+vMDGsJWFBLXKy7pncJG+/ID+25BNug
         +b2yc9aW8Fj8aaKPWQjdXDxPaoKuu+TUdeSRdkRTghPFNMB0+/8bCT3toMXaiMvpeDu3
         jbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770622589; x=1771227389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vdvgt99PcRK8hiWKZZhQq4N7eLbMYGzCOLNBd7EwcXM=;
        b=go6Kf8LAl3rmxUJHRBBBXQN3rwfEhVkmCC6r4nGIQQ48Mf2YyjzdsaSAJ0tfzb99ln
         IIe4wU9MCllqupTOYKy859YoBW3vQJgkNXCN3aZV0i1R3os21v6wT+t/3hed019mqq91
         QTF0Aswqh7kWW67b8GbDhZ8ZmkRsLbteck12DGybB028q7VuSsLUVxzw+QYST9MSRKu7
         IcdqwW6+nSMjPK2nCyaVthHhUI8HgAm8ockuRUE8D73MR9oLdefxsiRn8CFYOdLnz6GJ
         H4OOYz7T/AhPmdvncOuoyBzIEPwtSC7IcLoIFc4rB3qIctqsLJ3Qi/CYSvRePtx9mz0L
         8hBg==
X-Forwarded-Encrypted: i=1; AJvYcCXBruyMNjzSfI2H0zjmtLLv2f572wv9ONRpZqTrKwUcZ3dt1oD2maX4nPFSjunHLyOut1ceF3AZIA==@kvack.org
X-Gm-Message-State: AOJu0YxPP0rffDBixHSO4/67i4088O4i8Taa6UpHFcKHtcGa4yZcTW7e
	b4toKVl1G707Pmhkc7QZOAozLxFqZ5dzvfdyffmZQKa2YugY6g25OowEFGXdfUstKDvK+nZ8nXl
	/Qh0UrNDDXzs73USXuFAd05+0vQTpAoM=
X-Gm-Gg: AZuq6aK+3XNSNVHBR+Wdtj+R/0Xe7b1CEkbTALY378VmPOZ9DgEEVNdlRl/hIfgi26f
	SZ4RoDxDU0YrsVtIrLor0ia0ZP1Jx6pukD0NKBrz3DktKsh9BQvtQII/g6n7S99weP8wMBWjbCN
	sxahOAGvfUuzO464grw34s/u5yvbXKkeCtjI8wJOrF4fQt1qJ6qOQP9vzT89eGTlq70E1Jd99YO
	WNIrGG1H4sM/U9YstVfyvP40LCTQGHP6YrTYtFVOSTTlE67LUQaAX3mHjmPYS6Cq9wHsATS
X-Received: by 2002:a05:651c:4205:b0:37b:9b58:dd23 with SMTP id
 38308e7fff4ca-386b4ee9fc8mr17986021fa.2.1770622589107; Sun, 08 Feb 2026
 23:36:29 -0800 (PST)
MIME-Version: 1.0
References: <20260205064528.32794-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260205064528.32794-1-zhaoyang.huang@unisoc.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Mon, 9 Feb 2026 15:36:17 +0800
X-Gm-Features: AZwV_QiAoxcSbZbABqQub9SQVQ8W-yxYihzRfiHLE8H6Qnuc3j55DAJFqhy7XYw
Message-ID: <CAGWkznGom7mCk=6dHT6EDouexo2YLFiYpzeTcS4Nexuww4__dA@mail.gmail.com>
Subject: Re: [PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A16A20011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: keb3ihygk3nxpichjdnyzhm3m9a8hf5u
X-HE-Tag: 1770622591-799964
X-HE-Meta: U2FsdGVkX18m5VwLn9zFc5CvG6VPxw2FzQsQOfoaf/5e4+69w/rgIS/fO8NkhVC1wFfS2yN9Q/tkjmcMAqqawNR1OW1Sc5b6XWqD/3uUH0B5sYk1wABysq1cMdWikLMZs5KkEYfMwFAHT9Nts+P/5HoOrvUYsv55tOxhEn/NznqNBrRN72o3rrAftjlSB4mrNiMX8T6A7jjY6cWGoypz/F7OLctNh9GqbYxbCQ0/EP+LYJOsZHBOIN3OxW1AyjLgWmh/9VpDiqF3JxaqH5C+PjOFlhIUbDXBP+tbrHcFrGpr7gALk/Mv7ZA9ydbpSEhfxGMykJEVX4EWiar13b5gzCbPwX5Kz4X5weLq2BRSnf8ZouiTzdFTCdkKaj6XpaDtHv5koDD8eQd2dViMz0MZb1ExKy0BlKa5sUoaiJkW/cVK6i6MQbl2vLExSuvqappcYdrWdbL7DQJv+SJtw1oDoRkquPo6++TdCylKk20FfROKQNCmXMxG4BnU0wdXuM+x3UD6FVGYsuqixIEwNF4HA7v6Hoxt2+TE+44eWEPx2dFYqDU0uUTm/C+n/7zT2jTX0SlYlc68rSlsdbQwnj5o26t6IywwV4oW+jpK+F6KZ7JO1cR54FNkO+yaFAttNSpWq8uDDZr2UyLhyvjPrt0iEDI52r2reow/gwWOf9X3WM7WCKOCLNacyYPhGe/pIX4TvxXttAExjNviCtxXMf7ZFRRwmF+naBieGbWiub4W2WDgoCcqR3pCQRFoLaAXNYSPyiw5ajJAcGMOz6xls6mktxZ5NffzCeQprna2GwLoraSMv9+THJZSpC8LT2SzbgqXTmbCatISlCNxqSr0gIuzxpLKpjLlrxmj4xYvW8q6AHB3f4btt15STFg5rA4hiaEXJHFoEA+hwq/nvV0F9/cDOMiLFgpj4yfHKPngELYF9rjUn+QDgCpYib1n//miJ4MaOskXwoEkwH7IaUB38Al
 IGu2gpZB
 wqwj5cvdNFMB9Q9v/Nu49mGn1qqX6RAc4KhhGk8V/kd62YiYqIpUKJnr1w2D6UWngt64UAmlF6HUjS/itxl3480QRWyBDYvWnKEW8nDkN1ZOd/r9rl682Zmyu/ZSLX3c2qrXat83sl31+7Bc/0tjCPexeIH2PzFJ4YHmV+2EjZiFyUwkNwtgp+DuQ1N7TnBa0/ICtwu9DMRmifeNHb2EFNewId6ubytUldShIatq7P3XS6+/Rl+8iiHqGeMWy46nhRrRGYmMGzPXWwrQu4lXxvwgqyLaDgQi8bK8bduTGmUMmY0b4CmHfWdI+XIZ3pzNsfm/qcfuf0Vlu4bTXV6nwhxeMeSyoDzksbE0C0+25CCqZxEHYezEhobTq+vaofkF8zv9GH4Dv7REUHzHHwvYzY+o2XfAo2I9xRysMk9IN5kgT1zl4Hx9T23RcZJvsXBQJzGLz1wcKmKuNfALaW2xKQGna4LQBbEW9piiouZ2baaSDJClRYRPkGexIpAgbZGstk4mYPjaKORVCgcqcXkVbtbB4gtRUitATjCWk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 2:47=E2=80=AFPM zhaoyang.huang <zhaoyang.huang@uniso=
c.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Oversize reclaiming observed in "echo xxx > memory.reclaim". This commit
> would like to sync the stop criteria in shrink_node_memcgs to
> shrink_lruvec to have partial cgroup_reclaim bail out as early as it can
> be.
>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..03bda1094621 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec *lruvec=
, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> -       /* don't abort memcg reclaim to ensure fairness */
> -       if (!root_reclaim(sc))
> +       /* don't abort full walk memcg reclaim to ensure fairness */
> +       if (!root_reclaim(sc) && sc->memcg_full_walk)
>                 return false;
>
>         if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->=
order)))
> --
Talk more about motivation. Nowadays, android systems replace madivse
with memory.reclaim to implement user space memory management which
desires to reclaim a certain amount of memcg's memory. However,
oversized reclaiming is observed as there is no limitation within
try_to_shrink_lruvec when MGLRU enabled. This commit would like to fix
this by judging sc->memcg_full_walk.

> 2.25.1
>

