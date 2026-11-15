Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463F8606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 01:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UFbhdwE7
Received: by kanga.kvack.org (Postfix)
	id 6278A6B05B1; Sat, 14 Nov 2026 20:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFB76B05B2; Sat, 14 Nov 2026 20:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514B46B05B3; Sat, 14 Nov 2026 20:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25F866B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:10:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A89101604C9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:10:27 +0000 (UTC)
X-FDA: 85435572894.19.3D8AFD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7B89100002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:10:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFbhdwE7;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794705026;
	b=gOYLLrxbctGHeEFXXU/j/hwbllQXPOily5e/PN4e5l+tLDUCmhOTwtEXcyt0OX64dsjHYu
	96uErQ7GJ/oPNEnb9d2m1eQl1nAYkG3z3pl0Ad3JzRaKewZ/GsNlqPZ1GtvKeMr2BZC3Sa
	dWssJrZWjPJI7hNRQOvFgBuRnQRNGDc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UFbhdwE7;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794705026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AelhBmrJLWe4zD6L7dcIJH7/5wFn4seF5lv4zQ+trgw=;
	b=6NOWt+PW3Sz0r1FNkfRFlFVprgTLTyFd4j5RatpvBBQvhDhWt7UE25Kuo4y5V4juvRz5KT
	4vQTg35ohOPEe+J/RmgyJxDYheSXgwLvpNTZqjndsBs7+j2eyh2qfmkHVCMBis9/Zy18Kp
	EF4xtllBa7JE6JsIU0Ak7w9eh+G8cCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4F2046040
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0451F000C8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794705024;
	bh=AelhBmrJLWe4zD6L7dcIJH7/5wFn4seF5lv4zQ+trgw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UFbhdwE7eijvMM0FuCK1sV1GnOf2X46h0M2xQq/13vl8fV0W3CHHYVR/nkegaybQ+
	 3aFyen39iK9K2FmHYMKmOCQYeshSCBFlpV/TalqhwKqkPlEGf0t/x4tiVNBZPWiYXr
	 pMa5/S+Vz5FJBK+zGPlsP4HVxNvRw/M012qarg7HJbvcS/GR+2fYf0M6kK1ZHVLqTZ
	 Hy8pw689O+kI3mgZxwlv42Au3iBwbUpg5sSzzeG6cKk7RbMLvTlr33wdaQgVex/mfS
	 WB4ZB5TpiJBcd71kt9B1Ph2MuMOcxUNiTocfgmHd6zuQNNaNN36vJEm2Yc593JZJlw
	 mWxehKyLLnRgA==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9496577d4c4so96627985a.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:10:24 -0800 (PST)
X-Gm-Message-State: APuU4Z9Z8Hbp81UNnMZOyVlODVL+Bf58iAYoRt4yxm1gA+bDUh0g0VTJ
	/adkUdgANPqltx+lDGFt3nqBgdbf4vRzfKrODfllI+jRYHyYeWUCom1s+TsLBQPYCEOaQUaqz9w
	2ihM9VT0vLOnsgsW0UJo/HR7N0vfTrNw=
X-Received: by 2002:a05:620a:6c8e:b0:93f:2b65:593b with SMTP id
 af79cd13be357-9493314c330mr1571588285a.38.1794705023885; Sat, 14 Nov 2026
 17:10:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114140949.c47f9cf9c1ea22315092d880@linux-foundation.org>
In-Reply-To: <20261114140949.c47f9cf9c1ea22315092d880@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 15 Nov 2026 14:10:12 +1300
X-Gmail-Original-Message-ID: <CAGsJ_4wcufsYeDqEL2p+w-Dgfmd5jQcDG-OQ+WwK8kHFOYemuA@mail.gmail.com>
X-Gm-Features: AclHuK8bQQFBy0B7A7iwuDGInhNSf4l7oNrwYCEXahF71s6_QAeF3ChK4dYohsc
Message-ID: <CAGsJ_4wcufsYeDqEL2p+w-Dgfmd5jQcDG-OQ+WwK8kHFOYemuA@mail.gmail.com>
Subject: Re: [PATCH v9 00/16] mm: mglru: fix swappiness behavior
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <baoquan.he@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hui Zhu <hui.zhu@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	wang lian <lianux.mm@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	Xiang Liu <liuxiang.277@bytedance.com>, lyugaofei@xiaomi.com, 
	Michal Hocko <mhocko@kernel.org>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Ridong Chen <ridong.chen@linux.dev>, Mike Rapoport <rppt@kernel.org>, Kairui Song <ryncsn@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, =?UTF-8?B?5byg5Y2a?= <zhangbo56@xiaomi.com>, 
	Hui Zhu <zhuhui@kylinos.cn>, Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Content-Type: multipart/alternative; boundary="0000000000006ce8b40660465384"
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7B89100002
X-Stat-Signature: uzq7cs4ip3kqbbk3h6tznxtd5oafd1yo
X-Rspam-User: 
X-HE-Tag: 1794705025-481152
X-HE-Meta: U2FsdGVkX18EV7D5SwrU/368KlazJEfKREo+mO/kcvMnC3OeIvD/tG3f1FV9CtNJmC44l3lsYjMgAcbeZ6dDKS4tg2pjm0k28usVycFBd/UWZ5Bu0+IxE2+4oWMKAu0/2DrQaAXLJhsWtbwFYj/mFaniI72rBJycouq/XXwGhYhH+8I0ssbBvKinpmUeS4N9lXRVPA/niYtBOGHFwL9WR7vM0sVXmZGdCi5r0jZjV6/luyjmR1bIlrpfSsq1rBxqkNiale1ePIPwke8/rIh+8gLO2ibDWckoQhWd2ZxWjXa1emZKv7n6y8c60WqN7fVZTDyfGt5TqX57ADEiIL7TxpVG+YdOf1NKR6bKpuLfvsF5UEHg9UDmD4DAAVdZQEcX84n0VRIdHdXIzCw0MEvnG+Svhiy5YZObPMGoz4mzUW22lfwqflDrSu6aG+nYepRgfMAhnED2oEFQk5TYrR2AYILeDc/YEdKtEBZCNpJ33oXned7BcEbGsI0yByfW35if8W6JUBhdrvsHHH7/bNmFc30r187V2yEpxtzh3lJVIA4BUvEtVne4ReihrVWuNkBWgcb8p3/3esQZcdNs/LxolS+9T5wSqsbMBdDcb0NFBWyu32xabMOHvoGYk7D6cQQn5/ByWMxAaNW6TlRIiwtDgMh/hQMxU+AllVWV0WADc0ANrG40dyTYM6RXUp3mn3QEivyM1R1aYxrySX+5l5RnuIekr85sXT1YaSxk/oBUoK5MNGdTxoEIn9TlMbHy+B0zTce1rZTZPhtAmaultGpn0AJmAS0Hny0Uym2yU0ZnJWjOTw+SqhFq5Q66okxEnw0OQEQQBo908aaHva0OsmS1Hrl7NL7ZSD59xbPBkx9Q12jzySxK8sNy9iYJJ6lSU3PCINq9oiBdSi5kOYIVfzA54MBiRy3aJh+yCSYpMSwQ+LtuYyXNyyheCTIxNReBjPpna/aFPjc4W9zrZC270Td
 qdbT5l12
 QYx4nMBSb8Ldf8GVpPPkxZXIE8+3rwFkGdTBKUsS8yBmbxesz8rRagqS8EYKw0VDwVDsAIIKBAPpJAoIv+4J50DC6Hc+gw5byuzKPs8m68s4hPAwKk4Th7APaahuTjOpyAHa3HKigbwiRJKlNXFGQJPMmNkqQHF3ahG74FA3/wMI2yIN0NMr8dd3SmCSx94gnzYkhPIqg/Tws/kVpTG92EHjhvAWq/b5QQvIfsbi3W6zu74DeMdVWKO9XBvJd2qndQoMtPJVcfXSneXHyFHbwxGapsJqkUvENYpfO+/a10ADZ+Dfl2k5FZKN42+BC6q0CW8xduijL05fPP7gRm6MZzMec2VBjSka0NO36WAil8EX5nXHC1hNkhnF6aBp4TadfoCBrEPAvIbMPCDsY9FFBSoAmFOmVDo9+LzQdS+POnx144VrNZxnbiTGGqHo601tdPsOA6H4MY77givKc1vtO2j1SmrVpg2aCCb+8wMiWvDhJtI4lUykVeV9cadxOBzEw1Ig+UzOBarY2Mplo8CMrmvGZ5uwLkvb2WS/w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000006ce8b40660465384
Content-Type: text/plain; charset="UTF-8"

On Sun, Nov 15, 2026, 11:09 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sun, 15 Nov 2026 04:07:47 +0800 "Barry Song (Xiaomi)" <
baohua@kernel.org> wrote:
>
> > Classic LRU respects swappiness, while MGLRU only weakly
> > honors it when selecting the scan type. The fallback logic
> > can easily override the bias established by
> > get_type_to_scan(). As a result, swappiness has a much
> > smaller overall impact when changing from 1 to 200, as
> > shown by the data presented later in this cover letter.
> >
> > In this patchset, patches 1-8 from Kairui introduce a model that uses
> > refaults to determine nr_to_scan[] for both file and anon in MGLRU.
> >
> > ...
> >
>
> Thanks, I updated mm.git to this version.  I included that Sashiko
> fixup.
>
> The patchset does seem to be changing pretty quickly so I'll continue
> to hold it in the mm-new branch until things have settled down

Thanks very much, Andrew!

I'll be traveling soon, so I've been working day and night to try to get
this settled before I leave.

Sashiko flagged some nasty corner cases, and Kairui also provided some
helpful suggestions. So I've made a few additional changes in v9 to address
these.

I expect the series to be much more stable from v9 onward.

>
> > v9:
> > * reduce one iteration for lruvec_populated_min_seq();
> > * let lruvec_is_reclaimable() count all zones, for min_ttl;
> > * refine lru_gen_imbalanced(), AGING_PRIORITY macro, roundup/down
swappiness;
> >   per Kairui;
> > * let evict_folio_lists() return "drained" per Kairui, thanks!
> > * one bounded retry for scanned=0 and reduce concurrent aging
> >

Thanks,
Barry

--0000000000006ce8b40660465384
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><br>
<br>
On Sun, Nov 15, 2026, 11:09 Andrew Morton &lt;<a href=3D"mailto:akpm@linux-=
foundation.org" rel=3D"noreferrer noreferrer noreferrer" target=3D"_blank">=
akpm@linux-foundation.org</a>&gt; wrote:<br>
&gt;<br>
&gt; On Sun, 15 Nov 2026 04:07:47 +0800 &quot;Barry Song (Xiaomi)&quot; &lt=
;<a href=3D"mailto:baohua@kernel.org" rel=3D"noreferrer noreferrer noreferr=
er" target=3D"_blank">baohua@kernel.org</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; Classic LRU respects swappiness, while MGLRU only weakly<br>
&gt; &gt; honors it when selecting the scan type. The fallback logic<br>
&gt; &gt; can easily override the bias established by<br>
&gt; &gt; get_type_to_scan(). As a result, swappiness has a much<br>
&gt; &gt; smaller overall impact when changing from 1 to 200, as<br>
&gt; &gt; shown by the data presented later in this cover letter.<br>
&gt; &gt;<br>
&gt; &gt; In this patchset, patches 1-8 from Kairui introduce a model that =
uses<br>
&gt; &gt; refaults to determine nr_to_scan[] for both file and anon in MGLR=
U.<br>
&gt; &gt;<br>
&gt; &gt; ...<br>
&gt; &gt;<br>
&gt;<br>
&gt; Thanks, I updated mm.git to this version.=C2=A0 I included that Sashik=
o<br>
&gt; fixup.<br>
&gt;<br>
&gt; The patchset does seem to be changing pretty quickly so I&#39;ll conti=
nue<br>
&gt; to hold it in the mm-new branch until things have settled down<div dir=
=3D"auto"><br></div><div dir=3D"auto"><p>Thanks very much, Andrew!</p>
<p>I&#39;ll be traveling soon, so I&#39;ve been working day and night to tr=
y to get this settled before I leave.</p>
<p>Sashiko flagged some nasty corner cases, and Kairui also provided some h=
elpful suggestions. So I&#39;ve made a few additional changes in v9 to addr=
ess these.</p>
<p>I expect the series to be much more stable from v9 onward.</p><div dir=
=3D"auto">
<br>
&gt;<br>
&gt; &gt; v9:<br>
&gt; &gt; * reduce one iteration for lruvec_populated_min_seq();<br>
&gt; &gt; * let lruvec_is_reclaimable() count all zones, for min_ttl;<br>
&gt; &gt; * refine lru_gen_imbalanced(), AGING_PRIORITY macro, roundup/down=
 swappiness;<br>
&gt; &gt;=C2=A0 =C2=A0per Kairui;<br>
&gt; &gt; * let evict_folio_lists() return &quot;drained&quot; per Kairui, =
thanks!<br>
&gt; &gt; * one bounded retry for scanned=3D0 and reduce concurrent aging<b=
r>
&gt; &gt;<br></div><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks,</d=
iv><div dir=3D"auto">Barry</div></div></div>

--0000000000006ce8b40660465384--

