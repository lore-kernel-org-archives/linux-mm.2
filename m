Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A642AF9D0C0
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F3E6B0088; Tue, 14 Apr 2026 07:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9F96B008A; Tue, 14 Apr 2026 07:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA3C6B0092; Tue, 14 Apr 2026 07:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6E406B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:20:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68678B9B46
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:20:56 +0000 (UTC)
X-FDA: 84656919312.23.26FDA65
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FCC740005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:20:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C4k2hj74;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776165654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mm3jwhb6+OKntvMAoPGWsQTvhsdxLGsWKJzqFLjZ1Wg=;
	b=JU2vV5qnMQ+uXN2ugUaA4wcSNzM7xWibb6XOlQDYZNCvQPvWZ7qyFVtjWY4L0RJuDPblEb
	9qg28SS1t9Zb7VoTsHIYeOWHyVJQdSap4c8hAzyJ6qmtUKLYYBFK4JZD8yeKDfH7MG0lJH
	cYi/OuG+GyUTApeah0gQ+9azbFcpo/Q=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C4k2hj74;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776165654; a=rsa-sha256;
	cv=pass;
	b=JbwR+7QOI2Xui4ZfJKYBg0Bk2ZnURYRwZr1fzGL9hLPSOSJKGIH/hUIuaW+Gw0QoZT3DaJ
	QTbLXdoA+jtjmXvI+3m1MDvjsNMWj3h0HiusYu+fdj1U39QrF/Asypcos5SriEevfmXR7b
	RCeovZyD7bgqlfxHTccwA+NQ6mp1DbY=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-65019c1dc32so451987d50.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:20:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776165653; cv=none;
        d=google.com; s=arc-20240605;
        b=FhYZh2lPFMu2QjTXzudYe3kgvO23ozGFKGKMuV1Av100mcHQ4qbRoOAgwLZx1X9u8T
         R3kRt/DoMvvccoW4mVaMbOUk68EoamX4GJw+OMR+qLrDAtPC2Pzjay3JXUkbCIPmSGa/
         NONSqtgZgOB+HhF+pDPPoUjtvDXdeDolAI9CtPgOhcBr16Ik6TPj27LhrmQUu0su33of
         /viYplqvVTKTpVX5vm5Z23pFEpzs8fl/voEh1siUYcqKBLatW+P69RDBtnGpzwY26SB8
         1l0L1f8s71xOb/RHXWmwPWBX8qzkPGjQhkmjDxKJEsnckwIWeAgNJnN7zcrhaKp3awSg
         uErw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mm3jwhb6+OKntvMAoPGWsQTvhsdxLGsWKJzqFLjZ1Wg=;
        fh=irZu6ha1jLBRi5/SFgAOzDCFvSSA4LnUBd2IDaUQt9s=;
        b=efYcawALWw2/Gl9TqZOBC+giwwXiX1OCxAr2+YtiUd8VoTTvFJX/ivtfXgg0Rf+Qb7
         FdvLhffNTfzmo46R3ektsB/IWXjPO8k5dQA4EXDrTPCP+5MUm74DV//XcnxBJZX5d4Fm
         3EFo655XBvhQVujV3Pt/XjqRPf25Ww3Cjsj3aLN+2Zv2SQP2OFhrX+OBUXuWhmK5RjYe
         ImSJumJYqAJaGjOGFRJPApwR3NEo/FNaePaRv+RZLqOxKq+qsJAfH4LKM5oSxdeA3D2O
         ge4XwasUORqYWo0wDqOdmCJeDqP2ykzVMaOMpLnuoLy/dw47tvkp8QPcBQtowzVNIfvj
         UV8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776165653; x=1776770453; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mm3jwhb6+OKntvMAoPGWsQTvhsdxLGsWKJzqFLjZ1Wg=;
        b=C4k2hj74J79PvH9CDqZw3GMNPTBge+kRlMZuq4/nhNy68DK1wrnPAHq/Nc+nbfAmnj
         0+EWmEO3POgtSEQPS61QoCQ8b5zmMeNOeBY0TL/b3E6BwX1PpL30Y9wrRfLGvXXBjmZY
         574yRsdqmUwrdk2NCh/EmvrxpR8SRTtuGkMJ9N97hLN62CpCXvn16lzXzrLE0StSrWlK
         thTXcIesE4XQc7czqdg7AGuP+15gV6o99DKoKBRNX11d+WcayRE69oJFtrGcfxeS3kN1
         /8uG5m4C2Gli6/jeFxBtsO3dn7bDw/vxubmZMLBbGFP38gWRDMqNmc980vcUEmWN7QHW
         gDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776165653; x=1776770453;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mm3jwhb6+OKntvMAoPGWsQTvhsdxLGsWKJzqFLjZ1Wg=;
        b=obxhCNV3k+TCiFZtA9xfqCmLqb2iJeTg//kkhTQlNFfvy86D+v/15fLF68ozU0B/et
         uqMkSMv4Vtpo+gXTI/iZcFsmTOzr59xvCKxJzUzuRuObD+RH6+Z0lGnBGV0SGUlZZP/j
         pvL5ZY0QAWoSygoMujuMDyTQkIhkJJJUM5vXGW51P9JtxpMO2tluGGDCtSJaY6lnbULe
         rtq1AvmaTsNdqdFZWb62h5y0DznE2NU4Qg2JuEkmO3YZjfj/SP1LLhpHbYz+Wz94DwMM
         vA4YynudxrMpu8zwBkNuqcn3z5I4Q1LCqfJPnFlFURb3P1pzc3L3Tbv9x0s/S4jY5ktj
         vZ3A==
X-Forwarded-Encrypted: i=1; AFNElJ8Hg/7NXIBs1GJmXZmpf6zQ371svKvMnp9AHZZEwO7HtONOIhOstRuvbRBSdJRyKHZyLmh7pP8Bnw==@kvack.org
X-Gm-Message-State: AOJu0Ywn0cMm6mqkujFx4idHD/lrUuYA3nXy4ZR0SkGIFe9V6kzLq3PM
	BVZVQ27Bt/IQzx7V8k34McR5Yjkv0JsMCPGdCkD163aGHX7FC7qefe8pat8kQpDpaUhtBYRuTal
	03GCFelceaEzbZgrWdsgj+P4UmuG/LeIfBkLG75F3Twpr
X-Gm-Gg: AeBDiesCpjzQ8veC/VMD4CMmTM9zeaHvcgPiSuQYHedFEor+W+scDq8YqFkOsdUJyvX
	f7p2U0N7yEIiCx6naV8qvVcqD7cyRWmUvMucNTjH1Faihg9AVHd7ee7gQCj5edmeBiLAc4oaJyo
	Uoy9u1qiUTpAUASbTVQiBaoMIOTgryOsjWIT92kiRKx8kgtwsNZktsf7Xl2MyZU3vJ8SOwV3ybF
	DjYI2zU9QZ35tGpfBzhFNEA+pkyo90oIr9Vl7+P7OKGOQi/NvN311Z/Isg1WZWYxcKxjqpXxbcq
	JJCretSOYQ==
X-Received: by 2002:a05:690e:e8f:b0:64e:acda:c126 with SMTP id
 956f58d0204a3-6519a8a49c6mr10867058d50.4.1776165653304; Tue, 14 Apr 2026
 04:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260414094439.982853-1-charsyam@gmail.com> <20260414104353.989063-1-charsyam@gmail.com>
 <b1a5b96a-a525-4566-876d-5286c1367d7a@linux.ibm.com>
In-Reply-To: <b1a5b96a-a525-4566-876d-5286c1367d7a@linux.ibm.com>
From: CharSyam <charsyam@gmail.com>
Date: Tue, 14 Apr 2026 20:20:42 +0900
X-Gm-Features: AQROBzB6cCk_WsJcQ7n6sx5j0EXno6TJzt93U35Rlx7gTU857QJrtvn8_mIIG5U
Message-ID: <CAMrLSE7CAJ-eqxhijGJUw07_7Z8a7q7jpOi9+VE_4Uu3NovqZA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memblock: fix off-by-one page leak in reserve_mem_release_by_name()
To: Donet Tom <donettom@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000d3d80f064f69cade"
X-Rspamd-Queue-Id: 7FCC740005
X-Stat-Signature: 6ydq76xhpk8g8yo7wgcu5dzbcg5py63i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776165654-347341
X-HE-Meta: U2FsdGVkX18Inv21rI2VCAkiJl+K0kmxhcK+WLgLF5JVcwm8ADUGxuDyoSXE8Iyk57KGI7zhCvlkDhUsjS6inprH3dNqvsHNZ3Bh1NMxvEJWH9fF4tFg6LCNVW+JdgUStM9D/Mzn4yzffNFHd2WYwy/3nVXqyrBPezJeySNWcx+507WkMUr/Jsvn8h/PoRi6gswuJChl9Se3vzoVBsQCPulummJsWWE85nt66Y2BDmBhjcZuM2EMiF8RqBEMNG6IJYgGsSnWL2l7KgJnCuRDNTpsAC5MrOBEcNBvJi6vXpN5ZtxyIpQjFd+xdBifS9jk1Pp3Y3wlDPI1tBucSN5e1X5OaA1ZzeA3cw4eywfKIYz9lhx98aHb6obaz1pYQLlgyhAf5YJ73oJKBKhVS1V9/ZzAqg5m7n50YIf6Ru6T9dESa0cxDtscXc141UKA03j39y8Akf9jjU/hZ+MBus9Awpzl+o2oBP0Bt/EGPvNYcosjyyuHbaG3MTrSjN9XJngaDLlNlLKAVgbbPEiTisj7i2A/5nZe71kcaKihe8jWe86Cs57j/tExJjP4NuSZYWNajO+j6j9sqcVrWbkCy2lIlQD63+1Z8OYRVorslVyvZbFbwf8xrPsQP9ay1m0O45UHYH8lyl8GBam8fwvGjzYWuvY6mn83M7beINDWTov4/lgidriO8fID76B5tQYvW9O6wFIuMR8K6zt7Fh7ua+JAwbqPxLjzZ+wkCfuAyPZh1JkzHlcWrk6mpSUd8+Bx6ADgLxOfyuW8+svIS56xHKTH7rnUuwZVvB8eLZN0X9X2KdLi2XTueey/0zvWPsV3xadVTJGlr10I3awKgekbKa1OpBOKs54AQcO5tFiG3SSwkHUXAbRS67CxZlx/+eZz9umkHBh2RdS3KUH+EB2xkRtrzu2xO7FuOQikD72o/6JxlGdylrQ9yi5KQ5XIlko3WvoAL4Xkj9Qinu3NML6ua67
 uNmcSh+9
 jjbni8cRgJocuSc35cF/P1qJX/87lmJJlpUqEKy3zkPYZ6IW5QpWKnuMcFT1jAt6RP43hqsa8IhT4rG0HCdHg+9n94nfC8oMO+73pqFgZY6Aw6X6YgGFirhxKQBhs3esbrFArkQ1DRSz9ZPzGAvZtG8nfK+HpPcJggjPV6GYV3eUNLUh6dipJR698fh0f50A2hT8l+7t9R6JUAaXkYJgCHlftuOjbHKCjaPnRQgNu/plwy5Aw3X9NsM60jPd8M5wu1KhtL+tKqpWwHbb9GSbbQULI9HnAYWUGPPuwyLyoLsugd6Ix0bUXXj9ZVpq82/yfj/GAFZcsXZhktrvxWB0nq4xo77z4qhdBTvpPqCoocT+ObikfTg8Sxd/49u960guxyUaHKO9s7wztHwKpRxzCzHllURdYsUZzWQLrtMWzOZ+XpRo+41Iuw3rdT8V+97AVu3tD4GtVH7luVYWA2FwHvxu4YwVI0gf0DV0NRuqVrsWwDiJGmQAL2grFHHSm/zeVd+k0omGxZvCWY4bL6nxsmsQh4UUdR8GfTdfhe3X/wOt3jlaple/RjjUQKJXZ/keqH1J5ncQNrpRuulA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000d3d80f064f69cade
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  Please disregard this patch -- I just noticed the same fix is already
  in linux-next as commit c12c3e150780 ("memblock: reserve_mem: fix end
  caclulation in reserve_mem_release_by_name()") by Mike Rapoport.

  Sorry for the noise.

  Thanks,
  DaeMyung

2026=EB=85=84 4=EC=9B=94 14=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:13, D=
onet Tom <donettom@linux.ibm.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:

> Hi
>
> On 4/14/26 4:13 PM, DaeMyung Kang wrote:
> > free_reserved_area() treats its 'end' argument as exclusive: it aligns
> > end down via 'end & PAGE_MASK' and iterates with 'pos < end'.
> >
> > reserve_mem_release_by_name() instead passes 'start + map->size - 1',
> > which causes the last page of a page-aligned reservation to never be
> > freed. For a reservation spanning N pages, only N - 1 pages are
> > released back to the allocator.
> >
> > Fix it by passing the exclusive end address, 'start + map->size'.
> >
> > Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function=
")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
>
>
> I think it might be better to send v2 as a separate patch  rather than
> as a reply to the previous version.
>
> This patch looks good to me.
>
> Reviewed-by: Donet Tom donettom@linux.ibm.com
>
> -Donet
>
>
> > ---
> > Changes in v2:
> >   - Add Fixes: tag and Cc: stable (per Donet Tom's review).
> >   - v1: https://lore.kernel.org/lkml/
> >
> >   mm/memblock.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index b3ddfdec7a80..d4a02f1750e9 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
> >               return 0;
> >
> >       start =3D phys_to_virt(map->start);
> > -     end =3D start + map->size - 1;
> > +     end =3D start + map->size;
> >       snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
> >       free_reserved_area(start, end, 0, buf);
> >       map->size =3D 0;
>

--000000000000d3d80f064f69cade
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">=C2=A0 Please disregard this patch -- I j=
ust noticed the same fix is already<br>=C2=A0 in linux-next as commit c12c3=
e150780 (&quot;memblock: reserve_mem: fix end<br>=C2=A0 caclulation in rese=
rve_mem_release_by_name()&quot;) by Mike Rapoport.<br><br>=C2=A0 Sorry for =
the noise.<br><br>=C2=A0 Thanks,<br>=C2=A0 DaeMyung</div><br><div class=3D"=
gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">20=
26=EB=85=84 4=EC=9B=94 14=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:13, Don=
et Tom &lt;<a href=3D"mailto:donettom@linux.ibm.com">donettom@linux.ibm.com=
</a>&gt;=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">Hi<br>
<br>
On 4/14/26 4:13 PM, DaeMyung Kang wrote:<br>
&gt; free_reserved_area() treats its &#39;end&#39; argument as exclusive: i=
t aligns<br>
&gt; end down via &#39;end &amp; PAGE_MASK&#39; and iterates with &#39;pos =
&lt; end&#39;.<br>
&gt;<br>
&gt; reserve_mem_release_by_name() instead passes &#39;start + map-&gt;size=
 - 1&#39;,<br>
&gt; which causes the last page of a page-aligned reservation to never be<b=
r>
&gt; freed. For a reservation spanning N pages, only N - 1 pages are<br>
&gt; released back to the allocator.<br>
&gt;<br>
&gt; Fix it by passing the exclusive end address, &#39;start + map-&gt;size=
&#39;.<br>
&gt;<br>
&gt; Fixes: 74e2498ccf7b (&quot;mm/memblock: Add reserved memory release fu=
nction&quot;)<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable=
@vger.kernel.org</a><br>
&gt; Signed-off-by: DaeMyung Kang &lt;<a href=3D"mailto:charsyam@gmail.com"=
 target=3D"_blank">charsyam@gmail.com</a>&gt;<br>
<br>
<br>
I think it might be better to send v2 as a separate patch=C2=A0 rather than=
 <br>
as a reply to the previous version.<br>
<br>
This patch looks good to me.<br>
<br>
Reviewed-by: Donet Tom <a href=3D"mailto:donettom@linux.ibm.com" target=3D"=
_blank">donettom@linux.ibm.com</a><br>
<br>
-Donet<br>
<br>
<br>
&gt; ---<br>
&gt; Changes in v2:<br>
&gt;=C2=A0 =C2=A0- Add Fixes: tag and Cc: stable (per Donet Tom&#39;s revie=
w).<br>
&gt;=C2=A0 =C2=A0- v1: <a href=3D"https://lore.kernel.org/lkml/" rel=3D"nor=
eferrer" target=3D"_blank">https://lore.kernel.org/lkml/</a><br>
&gt;<br>
&gt;=C2=A0 =C2=A0mm/memblock.c | 2 +-<br>
&gt;=C2=A0 =C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/mm/memblock.c b/mm/memblock.c<br>
&gt; index b3ddfdec7a80..d4a02f1750e9 100644<br>
&gt; --- a/mm/memblock.c<br>
&gt; +++ b/mm/memblock.c<br>
&gt; @@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name=
)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0start =3D phys_to_virt(map-&gt;start);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0end =3D start + map-&gt;size - 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0end =3D start + map-&gt;size;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(buf, sizeof(buf), &quot;reserve_mem=
:%s&quot;, name);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0free_reserved_area(start, end, 0, buf);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0map-&gt;size =3D 0;<br>
</blockquote></div></div>

--000000000000d3d80f064f69cade--

