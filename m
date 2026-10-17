Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19DECCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 10:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350206B0088; Sat, 17 Oct 2026 06:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300CD6B008A; Sat, 17 Oct 2026 06:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216A66B008C; Sat, 17 Oct 2026 06:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1DFE6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:34:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A3361C2A65
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:34:10 +0000 (UTC)
X-FDA: 85331758260.12.8C540D3
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36C8EC0005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:34:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=FqybWiE+;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf10.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792233248;
	b=BqkSy5jMSpTPpbK4fQwL2GuM2NvYZeuUA1WdQo96pwbt//kTwhlX5K3wLnxSOiJLBFgCrf
	CD5aQPTkQ5GjKMEprwT91VtroOz4m83Xx0+Hmb2mv1EWekbHTY8LYZ6SNX1+VbmRjBhKj1
	VXnbjUE8xo4y8KkkgsJ/A35Hoyag4YA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=FqybWiE+;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf10.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792233248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZzWUcIAA2c0Q37uYzsYIsOQf1QMgb2uNEy/L4s1hKI=;
	b=NxuvDy+VnwVu4BPkdiAjE5jFtgAB/1gZ/HRu2YYbXjrvDZ37qsD1W5Z6Lmu/HvQNfT6FCR
	IABB3ay2o0rMwFYIX5DT8+om5ZtlgRLk5EcM9SGulKEKedPNHd3wMnoZCXX+Hos2jz25LS
	tuMs9+k2CLsg74duqmjrC/LuO5v9mPk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=sZzWUcIAA2c0Q37uYzsYIsOQf1QMgb2uNEy/L4s1hKI=; t=1792233248;
	x=1792838048; b=FqybWiE+NOhFYF6DNvpqj5n2NTodYXMJAGAfWBR/sToRTwvpEWlqnVZywQXqj
	zudtivYiK988XOBlzySNtvlOcyT+/VH/3rY73EOfC73cjtbD7mlBmx8cVBPAsRQDNr7JkJbe0hjIF
	o3h5UkmxEC2T3YlYvPv+cbFkkkyE0zsgpKMZluEx+h2D3FLoD7x8B/Rk50gTr+2XYJc6uePdDFa+s
	bzK1En8ADA2MzgYEmgLdrtMF2h1JxRnMjahmd/2qHy8LeyoiliGdF+pVf3KIsUWjVE9gqcVIBVmGb
	fR4FBYhk5l3l59TD6hP57dBiV8QWy8OPbhoR1tsKs3zfiFz9RQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xI1jn-00000001t7p-23Zx; Sat, 17 Oct 2026 12:34:03 +0200
Received: from dynamic-002-242-066-005.2.242.pool.telefonica.de ([2.242.66.5] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xI1jn-00000002z6y-0gKZ; Sat, 17 Oct 2026 12:34:03 +0200
Message-ID: <cf92126e6c10883ace50789869a45dada32e4859.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 1/2] sparc64: flush only the aliased page, not its
 whole folio
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Imre Kaloz <kaloz@kernel.org>, Andreas Larsson <andreas@gaisler.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Matthew Wilcox (Oracle)"	
 <willy@infradead.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, Andrew
 Morton	 <akpm@linux-foundation.org>, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org
Date: Sat, 17 Oct 2026 12:34:02 +0200
In-Reply-To: <c74a2d45-2267-b380-c7fe-b6a2d3f8251b@kernel.org>
References: <20260928132102.1707-1-kaloz@kernel.org>
	 <20260928132102.1707-2-kaloz@kernel.org>
	 <61ab29d3-929f-49de-bb64-5a49318ede00@gaisler.com>
	 <c74a2d45-2267-b380-c7fe-b6a2d3f8251b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 2.242.66.5
X-ZEDAT-Hint: PO
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 36C8EC0005
X-Stat-Signature: y36i4dcr7i1hpy8efqu6ducab37i7q83
X-HE-Tag: 1792233248-309805
X-HE-Meta: U2FsdGVkX19M2FCMjty9Y1BjMKC9h+6jec7FaWQ7JrvM3KImIps1N8Lvf+dJj7tE2iWMBLDb1YNL7OeJtnbkw2Xg/dWYyZUs6k8Ai4PpmHGO7NBsgLAXvI/PVg7mud6YasNAmJ56lCqQCF7glEpeMcYuzheYxy3WjRCYl92hwKcN6VKUCZdAwN6msMd/h5O4BT8SvZ75HRlTDJCM9sGrHns/zijZM8laLwWPjuAanr0+KydwFEkApwIbsenQ6F4PJdG8KOij/RQbgI9mv4PZwzLU2JYI9nf/+fRGDqNISthEjKZe78K6FANCIFE1ZWQ9/nb0SNdDTA3TyB1vd4V67rSVXLMbJVLnG3tUH2NEhyMbtuoLoUIJ8sYClvufIrzfbrxH0HSbaRnmsXwbSl1i4j9rjkRlDnWs3EazKZbBz9iFr9998F0wuAhyyqWY+cTGN3fn8rByM88xzaZwLUY6wI+yv59dZKUHupv/+8im9gyzYOr9iguWry6Nv3fRR5ZQAOIcrWWz11jMa/pkFdi9ZRKPYtiLSe1N9ntslczA278I+WO/dbh8CYEcNql0dDhY3JnM7UfX6m8EKvYXbAatqkAVOYVxaz4TctsBOMfH96nOpzRAzJxkFQXMZZQOrN0g0oCE+eEtLf3eR3OIVS2SQXbCv+NFm/YtUQkkGDZHnaHgRfOJ50kTWTYASDZuZDBj0/NXWbULMRnB84VXTc2brmnoMfO4yimLJy8SpSjXb7zz4z0GLgleHRQi9Mg1tcmu7R7qJUqAU2rnP6lo43YoJI6nO/4b4FZfknDwWJxlkFofOt/d/EVhJy5PrvdZR4oA6RqpMFIk6ZaoyUfAYrzne3BPIAJ/rBAmGUgRUjcisMOXSj5EGHRhkyz+HsvxFZXJMY9mdr42vssU+ditzjui69bQ50DT7PW2d2sIHS7PjOG+Lc/Hef5DuPoXQjV/8OU6GGxc/P/iAhyAz/LVKuV
 vh+ziuPa
 rWbdbZb8MtvmcFM9idlGEDI8o1pOgoyeYg25fFS3lQCYMOzX2Bssaqiv8xxu6Vs2bbSk/xXwB50EXMX/7MkSaYGk/wuQim9lCvGPIUgHHcOxy6mLxeWc02X7HX162Stvk0Dh+ZFnq1h7WbP8LukviUbsApB6KI1nF8sWLOy8cpCjgV934kzNNIG2CayanBgVx/+o1wZV9Pn3YGZ/iHAkx1grWRL0t5CzVehANGv/Fc/a8dqPv1VtdhMIDiBgsLokXbKQwyAAw5GdfQ5UKjYvW6x2I2MFt8lDTfjyYk87VqUdMXq8CIQoNVNo4/E+5pKfwT+qc8zXgEez2B/zRnj0L752GJCKa7fI/1l+wkMk3oPTKYmWwXBN6DVuAzvucPfwylA00AMYnAyBQkqU7TvL9jb2j+os5dqPhRREsw1+eFMWKnaziIwRwNT14su95hRg3dYnmMXpr3ZjevenBNUD2oezpWe2aqqn62ZDw/ukwqgX+tiFFle6g3RoTsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, 2026-10-15 at 21:26 +0200, Imre Kaloz wrote:
> I like the nr idea. Since sparc64 is the only user of move_pte(), it
> would be a small change: move_ptes() would pass nr_ptes, the generic
> version would ignore it, and sparc64 would flush every aliased page in
> the batch. I=E2=80=99d still keep it as a separate patch on top of this o=
ne,
> though, so the fix can go to stable as a plain sparc64 backport.
>=20
> Matthew, Mike, Andrew, would you be fine with move_pte() taking nr?

With the merge window for v7.4 likely opening on Monday, I hope we can
still get these two patches squeezed in as my latest tests showed that
the kernel would crash very early on my V240 test server without these
two patches applied.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

