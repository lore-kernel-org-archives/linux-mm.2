Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C15B606B0DE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LvGjbVxP
Received: by kanga.kvack.org (Postfix)
	id 8AC286B05B1; Mon,  2 Nov 2026 12:40:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DA96B05B3; Mon,  2 Nov 2026 12:40:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749D66B05BA; Mon,  2 Nov 2026 12:40:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52F0E6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:40:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDF14A019C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:40:48 +0000 (UTC)
X-FDA: 85390894176.13.6CF44E8
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id E58314000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:40:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LvGjbVxP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793641246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
	b=fA7S3ZzDHgLEM4JfdPjG/dRNMD74TEAcBwe8qvrQf2oD76U3/AL7mhv8PS+HA9HZjhxxET
	uSe2Nysky9vbhR3DJWeIlL9Df+qQPam+FfspGvst/5IuD1/sUQpNkB90xodrpFPLsmh2Z7
	JoAgYiSGS+8mCk2yXep732A/rzzmjEQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LvGjbVxP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793641246;
	b=4ljkdN2+hnY5hNIhB4WPeXYrHQd/mFMopOn8f66hKhLX6gRFmDB14hjsglVtKtHPfvPXTg
	+Chj5cq26/UA0nEj3hyPWPQbEq4Pqb6yVNBAq+VTeyak4M6T8Do2L3vIedc2uTgoSaV/mw
	OpqHQwNc8GlP7OFfQg4frJeDENXBXEM=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so768656241.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:40:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793641246; cv=none;
        d=google.com; s=arc-20260327;
        b=PtrHCjWWigSqMb/+jGE4m3Cq8oYM07sYyu/ga9K5P1r4Koxb4i+bAm3DGCIbKOzFWv
         qJDDoamvhiY8i9axzMBGcsoQBGOqMgIvQN171qCKVV2j2r48Q/lAwMXKZkoYqL3779xV
         YV8W+ddM+7+jmU1NE2miMQM2SgcaZZMNsREA/oj3h7EXCZSmvepUXZ3dlTgv9ZOIV6mL
         EbEUtA2u1tSSt3nlY7aPTlhe3Nvf4xXMunNanhAymbi3tmR1/W8T8p/f1Ll9dtbgC4bY
         /b5MMyBb//Xu3GyhYo958n+YR9N8ZWIEabnqq6IG6Lbl5sR6vwnXk9vOJjnjYr6OLnd7
         ONVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        fh=iST0seGqYSw6zDL86dOT6T/cB9EV/40+o/p/Ycrmntc=;
        b=KfRQNlBWQQhQBwlg0WhfBUnFxeL+wXDDMHGY7D4GZX+j6eYfppF8cyQQI1hSwhmncs
         HeJHQOxVHDqhS5Jj6p4NVoe9uQ9yeRC/sCqSdLoPhbd8dHlTUuakDT6eXHnKoxAWTF0R
         N6wRkfn1YkgegzBmOxxkHd2MrWFlIYH++77QiZX91wPK/LPmLU1vgLczAaMuhfbhW+jZ
         aoGgnZztwunZbn3zGHcbNSym6DbFJ7S28D15j+T6zPapO8q8ixe0pJBoZK/1Ur7IxU4Z
         G3NC9UtCGBr3i0aHLS11eODfn6s3ae8g22vA6hhVDg3l3kwhVyvnHQGF50yGzj7q+1pQ
         RQow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793641246; x=1794246046; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        b=LvGjbVxPBlyf96ccj+nNW3dETlhhvIH/ZH7cafWfF74YLLp7kJ7xP5AP5IbKyrW3ci
         8ORuJH8CVUL9WTS9SmNLnp2JnPZWG/b09Y4Bvt013rmN21mg5+EbUGT1aajIX2ah5/Fr
         +ojr1q8Oh1WM88QPChwCuR94rwtFjQJOhEDzi6FEBQ4hSdSvW6ppQgyJY1m+S56EdurW
         gETh7lYcYQRrzaQiGVdQWidyqdzc4+oQRSxQEpXcFostwyWmTKB69/AKgE/iZcvf4+jU
         I3nTNLLSJ2ABSLr71VCZ/zVTlOU53o+1aIWufRPZIXHSPwAfIZihheBTJChOOtH7SlbB
         rw7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793641246; x=1794246046;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        b=Sk8mbNXxSKGjvmi4ypYUagX9p6zm/EEFn7r0a4Ewb74XpIWLO8Bjwa44nGJzsXj+vx
         MdM84sqocuK2go0WuDnJ3z4Ny9JlGQ72suqYCPtOR7HY+Jh01Tb53fUSXmgULXk1a0/e
         tb1OWPA7Tc/WBtK4UJaY4VxJCZquaBSrx4nbYjhAgmDqqjW1OU9Lwi/OrADbR/EAzuvO
         gLPX/nlZjPBHWbiYisu/oZhc+JihMLy8poSfYVjEZHr3ohMu/sl40gs5NZTc55O9x1M7
         nXmivfXsLxujy4MWWICThKRdD8mV3u9eCZvQQ3RF6QiTcZt8FJb4+N+krN/9AkiSnazA
         11Qg==
X-Forwarded-Encrypted: i=1; AKwUvBwo1giI3AJScVjVQ+J94KjR9SYbfRHORCE6YtCDTWRqFq9Hyb144rP0q8MXYUbcC5A+LGkVLXDg9Q==@kvack.org
X-Gm-Message-State: APuU4Z8Gs98j+ITpDKO2+z4z8EwSYDeaYmuqNwH1f2/aqqwPCjewOrSf
	vXsjN2CyzaBHsVHMmGJRCz5fwyjI8PZTmvLmhs1+l1D4zNuyMZWB4yaMWZMW3AcJ/3ckVArENN5
	1zkwpK1P3jM2CmernYksnLAfqXsEJiBc=
X-Gm-Gg: AYBFou0J8/AEUmx0IGaHXwZACEqcNZzbWRcwgRZ4ZNV4dJjcb3QYGTJgWto8eoPd0Ja
	9T7meh4ki+SWEB2y975AHKUcpD2KAPSoWQhKAmF060QyoTtPqX+34cW+81xPlXbEDar7bSfj47x
	JWIMXlr0nq8g8FdofUWXfS31Yin5Ng3teIKU/N4ruFvaIaZ3yLRS97aqn7nHQ7PyOA7/RaXFuI5
	C0C1sIf5r3voWSgp3vSOhNvJvk9M+dfHa62B1qN/r6g1EyGcvRhA/4hhSuUTejDeg+SddwpeZGW
	5suFaUJNlInLTRddCIJElf1PbiUAvAKBbrojexHA0wrvNkC+VhOmwmcWRzPUNr3RKN/zD/Y9+pi
	ClSP9lLoHFwkTJ/o4gtTd1x0ByxRyAMAb5lBGX9jdX8x0QgHH32XZCY0co72ums6GUe3uf0lkMl
	x16jZVGjQ=
X-Received: by 2002:a05:6102:6cc:b0:7b5:7cd5:2a1b with SMTP id
 ada2fe7eead31-7d072634fbamr3742461137.10.1793641245530; Mon, 02 Nov 2026
 09:40:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <aui3TJqadHUv-4RW@tiehlicka> <20261102163014.237806-1-joshua.hahnjy@gmail.com>
 <aujCcqKKyio7oZ0x@tiehlicka>
In-Reply-To: <aujCcqKKyio7oZ0x@tiehlicka>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 2 Nov 2026 12:40:33 -0500
X-Gm-Features: AclHuK8Kcc-o5KfW3KwHQal0BbNJdxHPlCZpE8gC1XELnC_g5cw3VrvhXhvc0MA
Message-ID: <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E58314000E
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 7mw6gbrtkamn7sf3yg3cryoi1ne4dyqt
X-HE-Tag: 1793641246-969461
X-HE-Meta: U2FsdGVkX18mnFyNQXnv8cEIy1GqO8H9+3hRkFTF7RFr13buzRzCJ3LFsaOFE3TDwDyx37qWIhJrISLHyG/bFFm9gYQqI9cq/XxYOTDeJumqRo9uAaQIcCfSDw1uWUh2oAs1IXnC04Y1uDsmQRQ8UihCEN2cjL87Y2olca17r9nN4sgLDp0H/bwQJ0kjtdnpObjSJpIv1foitQbmF75T07Us3OwrEsYcgXcYBUGjWx1N7udKDWrl/fH8mfIPYveJN0Xir3bBvtyitOsjoMxbJGHKsY/dRf25mkdhFvQmS7+raFJrnaBYMYgWjvnC5ZoaVOUK/oxH+iJRQAfnUzIf4gt6c8zhHEjFWHBLp44ljN4Wje3XAzQkwG7nhpcWXgOHsZx3zmAGZtpja+AeEMdYzfnaMJ62djuggI7NTFBHCymXag0xn3CmUikZL4j1m95819tkqOzwr6jN/yBS8p5zW54HAdk+gOZ9TwWuDOX0vAy9wR9sWJftl1TmRIzs3RpbJ5uZmDAdC4bN26nXdXvXIdRuufEQjg3XdO9F5UOTOHFp35aLP1CITDbFGd5KzKfiQYkKPm0/JoTzFccXVwfzj2uUzn4AcPCPyCTG0DU5TtjKu1y6QWt1l3yKaN7uv9YZy+AbYBoKfOxYTRxIPt9fFTy/ENXtt+CB1GduMhWmNjqNa8+0zrmsZNDZJkerDWF2T169bkMeSaI477I0IFooYJDzeczG3Jf6jOyXYmhQTga5E/HPtC1yry2DrgXJW1VP7FAz1yd9juOTgV15JHX6apNtwTDk7airLfb6TZVO/m7S5WyZ2f3vSqAaMFJh+WOZECQ5rV/AR36ovtty9+NCo5C9FV5dlAVkatRYQpqoZUnwOfRBor2+be0PbAMqRT4kXMUgaIBhoaIbjsRqe/ZCX0EfUXQXqINdOzDODLlfGmN6ez+1aSujypbwcYSJFnHmrIw0o64DEHb7ATceCOq
 9ZvqlVNB
 utBXTfAiohhnXK+YcHQPerSnvushMi6RBdgcw7xS37wKkhlgO6zH2RriZIKPz4RK/U1jpfr/zAn9KM6bHx7tbsMbx40fdUug+nbxdy8aTyxZJ8zsJrmzkJNEFUUC3xF3fv5UQWbOBwG75Cp+9ESF/Z/YxCs8S1QoxDfMe1qONN5gFTT8mnLwXfxvRlEFF6Z6pMnoTCs5kGsMYtE491mjE9uYssltv2XXOfrznuubtm2sdgXiWu/Jl2X41UWYl3D67yCKh5RKlkVYIdiOrylywR+EzwOjbdCIwPEfyGYpDhzASCPV1ICFer6Qajv05Soi6NZfbKINLDrj9ujfa+sIZPmGa6XI28/g85W62JLb2g/qfyli1LpMyknbAry6Dmu4lWZ70mbNOFBsgaCUlMXGgHfKh05rTZmEkA/Bn6DHDo7KC31Ik4b+77+ZUZ9xWlzQvQxEpXyHwzSDPmaF+K4VsoLBT4eC7OABAyr/mNoBwe+xPz4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > > > Personally I am a big fan of how try_charge_memcg looks after this
> > > > series, what do you think?
> > > >
> > > > > Quite honestly I am still not convinced this move
> > > > > is the right thing but I would like to fully understand the mechanics
> > > > > first. Having discrepancies among different counters just sounds like a
> > > > > potential source of future problems.
> > > >
> > > > I hope that I can present a good argument for why this is not as
> > > > concern as it may seem initially.
> > > >
> > > > My first point is that the memory usage counters were always fuzzy, as
> > > > specified in the memcg v1 documentation too:
> > > >
> > > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > > usage, it's a fuzz value for efficient access.
> > > >
> > > > Secondly, the raw value of the usage is actually always accurate. It is
> > > > just the stock portion that overcharge the memory at times, making it
> > > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > > bring the counters to their real values (like what happens right now).
> > > >
> > > > Finally, this is a change that is only limited to cgroup v1 users.
> > >
> > > Right but is there any actual point in adding caching for memsw charges
> > > now? If you have a way to opt-in to caching then you can simply disabled
> > > that for memsw counter altogether. Fewer problems to deal with, explain
> > > etc...
> >
> > I think the problem actually still exists, unfortunately. In fact I
> > think the issue becomes bigger if you remove stocking for memsw.
>
> Yes, you are right. We do actually cache memsw through the charging path
> which charges both mem and memsw with the batch.

Thanks, Michal! So it seems like we are in alignment on everything
except the cgroup v1 implications for fuzziness. FWIW I think nothing
really changes from the userspace POV. memsw and memory usage has
always been fuzzy due to stocking, so all this series does is to
change "why" and "when" the stocking becomes fuzzy.

What do you think about this? The other alternative would be to remove
stocking for cgroup v1 users completely. But I am not sure that is a
good solution either. For the record, I tried making the stock tied
together so that they refill together, but that was a nightmare in
terms of added complexity.

