Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABEFD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A936B0005; Tue, 16 Dec 2025 01:27:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D396B0089; Tue, 16 Dec 2025 01:27:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91F96B008A; Tue, 16 Dec 2025 01:27:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B079D6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:27:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D080B891E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:27:16 +0000 (UTC)
X-FDA: 84224352072.24.4A01284
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DC091C000F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:27:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H+70Q+04;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866434; a=rsa-sha256;
	cv=none;
	b=jY2mInIkX65T6WtzZJyb9fuKBkKUBo3dJJF2xTWvvQ3fBpEm2f6WUFqZN/VZIFrPrU/IN/
	E3jcH0239cIlnaa+yXrVYZ2STF39sJU0TpZs+Lwn/H9/xWLwFrew3caCS7EIh70ErBmZ/P
	PguFoa63gRMpNIYN0C6PZy9AFk4FT74=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H+70Q+04;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVGFbSBWqk+8thdIINLXihH2Q5jNi9zkhBBBIrJaIjw=;
	b=MbSkG/zpJUOGJbID8QJSSaeo0IhuiHhqe0NtZtBwXKNPMVHX+meJRKQOkWmJ0dK7LVGo1X
	BzYvlEB7VyI1f3en6TdcwneTJXrRcAVnxo7LOb4sBBY9AP1GfXhq1D+OYjpI3Q4u7CMe35
	aEmB5bzKMvgHar07hj1x5dd9MiK6O0Y=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7f1243792f2so2779852b3a.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765866433; x=1766471233; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eVGFbSBWqk+8thdIINLXihH2Q5jNi9zkhBBBIrJaIjw=;
        b=H+70Q+04ydZmVn/MmLZW7q1edf2vbHs2uVI6zwFJ96Ba2akNNEib8ofxpKeZxzmkd3
         771W6d5uAk03F7O/J0L6dhZolC2gJ4swo26u7LPwC0TD4ahwwj+6OllfpC+J4i1/GYvL
         ew7LQepxHiw1iEI7RNpneAiRPOHq5LtTlKDs3NxV+G4j7fHX7BcSHnxxRp7mM4hOPMLs
         dIKjO8AgDn7si+0k2wjtjeuV47bMeVEzeBMId0FBXnybRMceJAxvqzkP6ob/dl3raL3g
         Dlhc42mKt2Q9YdEhla8nUfmqv5iyVVE4HY06M2Aeu3BObMLzfol3WpPfvpZKy7LXwRXU
         GPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765866433; x=1766471233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVGFbSBWqk+8thdIINLXihH2Q5jNi9zkhBBBIrJaIjw=;
        b=vy/f07m6eE098GwkNZV8X8dWAsZwhjZPKzdzXOByWPlcbliOdpm+cRE21l5o1CBE8U
         A5YWXenaj9DbtXKKUdtKIVvywf+zTk5NdCB3dtntbuh2z9MYs6JpNAdM1ACYM/NsxDIg
         WKv3PWyrfpIJakNlB9Ww/I28CxizEIFU4IgWiLlblAGs0Ya0xX24uzxm8W7oYQOkltk8
         CQb3nLrjyyTfZAvzfQVJ6WpM6ubDtiQPBhubfUwNx4VewuANC9vNGDeviKksCple9NwM
         eqQnf2hJSErEn4+lAE551B1HmKlXmlt/hcZ53MuTv09UD+iXzP9bpNczBLxmCBVybFZb
         AKvw==
X-Forwarded-Encrypted: i=1; AJvYcCWmrHGQo/MFh4LjTO/UCxci+nNbcmfg6cexkZMdxaBpDt7PXYW74mZpgvIdhV1O1JwX1He25NKIJA==@kvack.org
X-Gm-Message-State: AOJu0YyQ7EWW1vOOulExo5dEt7IXmcGE+x32atZDxmug+1J8DGol3MM1
	GVhKko2z7QvM+6KCvTF6NuyajF0/sBYO7rhAjY6VHVeJX8BVTG/lTPYp
X-Gm-Gg: AY/fxX7VNlKuKj/ANjSysHx0DHSwNcQaPI+SEFIpgLbJvqGrA7NbizQZvUsqHofcxA/
	cXV/d3rRIMkUbf8OREmtYDED3yeGqOrrrveVee0sUPEnbXO6bDm2GD7jnukOyKO6CLY/xtZeB6v
	GjR56kuJcN2p3UoleKaIXEVKiTsEF8kv9zO0odTeW0sCCEJd6exIyOeBnuSVqxA/jH/m/uQwu6P
	fRW4zoFrlvO52iIVS68syNaH3Vvt7cJG3PhKsHUdPmiIl/W4Kw4LX9EjFMCTdIGR2q4mToWRwk/
	exIclbjiCbg+4BoVHug62CIJ30wLlfFaWJFutHE7DUNifrDDxXtDC79xwtUn2BPnFByv9lxrip9
	7XN+GEswHJd+IMsgAOAVmyf+Hunel1kCKGk08EbfveBOxW11Y+i9Igw//D1zAsya5fkVzM9/LNn
	UF4AhyfaBreiTuiiqwzsESTwQQ
X-Google-Smtp-Source: AGHT+IF6epENwBHk8KtQ8XxgX9Sp9gxmmjCUbBiVOhaXIN6EqUIJOTiu95N3+4+6qIa8lj+KVx1GNg==
X-Received: by 2002:a05:6a00:4307:b0:781:261b:7524 with SMTP id d2e1a72fcca58-7f667543006mr10600428b3a.14.1765866432601;
        Mon, 15 Dec 2025 22:27:12 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c4aa718asm14428905b3a.35.2025.12.15.22.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 22:27:12 -0800 (PST)
Date: Tue, 16 Dec 2025 14:27:05 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, david@kernel.org
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <uqlhxbrsl36quvxaflrueadujb3cwdfexw4yffvk6la3ry4szj@h62lqtp36g5c>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <d03d6ea7-68fe-4eb5-aa28-1020f3382f4d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d03d6ea7-68fe-4eb5-aa28-1020f3382f4d@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9DC091C000F
X-Stat-Signature: b3msx4uc1w83t85ommady17btkaeu1e6
X-Rspam-User: 
X-HE-Tag: 1765866434-373444
X-HE-Meta: U2FsdGVkX19oRDEfh5uvt80d/Iv+ledXIpk3fNHQ5rnSCsriNJDMHGqTQbvLvUpfBZ9tqV8PzUwRVs+ic/ks3BGuwtCeOXQj8TdeULzGaoa+7Wz0iWE4W3PheGmQktmG6wiYrqTbasH8UfI+BX/kq8RT8T43eRmsoogMibFYef2qcoa8BPRHmeFtu3Rez54cuxoj+XkyZ+y8h20JW5kDGKYbmZ9tedIt8z6pWXKyxk6isksbuyw+OsFsDwBkVDOsAe2kC2saiFTdA4C065YSGO2EJf3RfURzzDOrRPS1TvDe8uw0XStu5/8XJwYQZaenIPy2WR8E4opLPZjZ1kQMm/h/cYHdlfIZYdXUg4vOM30DJvAdpT4YcLdGTZxJ/Slo8XtZD2XjEZbMAWXcUf3BA6gJGCY9cMDJvaRRY3GhU+BbXhWK6pyE37N4Cz5JzVHXqadCuJCtApwtMTGTSHCHURVQQ3K41trAWCENzB/mvXIgUaiWfHGYoWzN9QieubGkAbhsG0Y50aKp1wWse+rjwIPUwfs1M+kY0LnSfy4EyDbNvR+Z2je4n2Yv/Bdh4AVK8qQdXBugio2OfEZCjMIgLMQFeZYflODYXQ+Gc1YTIgGiWc5dMe5X4ZExtH0qd7mV9qtf5XYDj/rCbjk8tzS/sHnFO13TKBCOBGaTTggytKJlTOW8MegPsM2cIVjEoyWaxI6N3QsGssHQR4JCU6cq8s6QYbTrjlPaM6ghH9fOxxA43YtZy3/hS2U3z/tt82lbNrXhd22jWqDjVosnRizoQ5oVWqgT2X2rAzrwmJz5rav3qUBlLeV/MQOaVDAjTWuE2B8zxCcOA6tNC5Tnai/Ak1rVOjdx95Z7McoanvqDNBJwtxMQHbT6PUVHCUPIKMQMjEcBxs3A1Ar5cJE9tqDxXE9bura5PHFFQo35RjvyyXELG2BJlyLAaKhsh/ZKoWV4VqbLzlZlC6p3ipiUsVl
 DUNqwh2K
 c5Q82/GR1krzKNJRkpeV1qu3z3TGu2eXsvBAKPwJkl1D0o2cBIAqpVcYqNXInmvW4FJdLZl2M6+h4EVKwly29xVIaALHGGv/nPimLH/cY3/3UuowyBR8oTb10DHsfC5lEpK0p0Rfsybv3VJlHWniCYKRhz6z/yZBoQLNTRYIvf03An/81StT9zWYsdE2OXvszxXv8N+jCmDwQQCnoh1yr6N0TJW88AJbdn2ZcfbWQQdbhowt1kO/ClkPWq86rgpdZkWbDdtJ0HT/Y6hAGOBTSh57GW3NeQF8y+3vZXGwRY0WG4+61PnDyk+YJDbIYBpG6uQjaeJrN1vACM76E9yj+NPWWyhiahxkbRm5FevTbFkz2Tb+NdkcVm9Kx48cJ8d4uHRzqnngHzqgJBIBSXHg21aGeL9jNiFt90UuxTZG0M8NGymmdhjHLaSbJ+s23qh4M/OEVIOIwLvok1bvwyGMS01lvcCgqmJZA9G2FnlF3SVpXeKSYxIPEb825k9XhPkc8/xnfZJhS+EfDfVUTOMBpWfsI/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 07:52:41PM +0800, Lance Yang wrote:
> Hi Vernon,
>
> Thanks for the patches!
>
> On 2025/12/15 17:04, Vernon Yang wrote:
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> > khugepaged.
> >
> > @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> > @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> > @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> > total progress size: 701 MB
> > Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >
> > The khugepaged_scan list save all task that support collapse into hugepage,
> > as long as the take is not destroyed, khugepaged will not remove it from
>
> Nit: s/take/task/

Thanks, I'll fix it in the next version.

> > the khugepaged_scan list. This exist a phenomenon where task has already
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> > SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> > list. If the page fault or MADV_HUGEPAGE again, it is added back to
> > khugepaged.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
> >   1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0598a19a98cc..1ec1af5be3c8 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -115,6 +115,7 @@ struct khugepaged_scan {
> >   	struct list_head mm_head;
> >   	struct mm_slot *mm_slot;
> >   	unsigned long address;
> > +	bool maybe_collapse;
>
> At a quick glance, the name of "maybe_collapse" is a bit ambiguous ...
>
> Perhaps "scan_needed" or "collapse_possible" would be clearer to
> indicate that the mm should be kept in the scan list?

The "collapse_possible" sounds good to me, Thanks! I will do it in the
next version.

--
Thanks,
Vernon

