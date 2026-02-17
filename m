Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF53E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 22:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921406B0088; Tue, 17 Feb 2026 17:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A47A6B0089; Tue, 17 Feb 2026 17:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B04F6B008A; Tue, 17 Feb 2026 17:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 636556B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:00:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 059D58B5C2
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:00:25 +0000 (UTC)
X-FDA: 84455318010.24.5967AC4
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3BC3D40012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:00:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771365623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4YomJL+wvD7W0OeZIHmpJ/lU+3gtDl1Rwyw/IeIuhOU=;
	b=P3P/RyJSZ45wchkwYHyKos7MiFKwUKQvqptTq9n/W1QlTenuLjIHbNcOzNes2rVknObyTC
	1wU0n03NfcgQ9MtxFPbI4wMqnhSljUBkOIFdWubqjLpsxBQRsVdzCYQlJGl60br+8Aj1BN
	E6OhBz9wTqckl/h4Xj9I7v62tJdaFAM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771365623; a=rsa-sha256;
	cv=none;
	b=vqVzfnuqJ39TBC1esPQ2yfDWm5KutoHkhgW/AHrBRSnT4Dx7/vCJ1HAl1GAMHN8uXE/45B
	2t+RB0wQoBTK9pnuvyZVWkvQcIFQaXaKkiCYaa3sncrE2c7CfmAqT8lq3WF7bfOwiG/z6I
	0fv6KgIaCduFESCxLpssJZPVG903s8g=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61HM05GC464945;
	Tue, 17 Feb 2026 16:00:06 -0600
Message-ID: <f99446cac275cc49de94b998b222614111250baf.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Wed, 18 Feb 2026 09:00:05 +1100
In-Reply-To: <aZRfzbSLGCkxx8fC@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <aZRfzbSLGCkxx8fC@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BC3D40012
X-Rspamd-Server: rspam02
X-Stat-Signature: k4ricpnc3oqmj54gbod6g986sths5qj1
X-HE-Tag: 1771365623-329063
X-HE-Meta: U2FsdGVkX19L85Iw8MSuC8aBnKjYieTnXuY13wt0td/0+jhVYZ8yQm040Mpr771TchlTJiftEP+lw/KGmh0WvEVlZy8KeMbsVaDg/E2sjqVq26NGH0sLkVf4XCSflL3O4EhgIhT/jDZUaBFp3EvgfZxm1BKH4TQkReyr1yVn3ryNyy5j4R0zdO8e5OJlb498pOseO7OI/X1r/JIDIIdBX22OBpJqxEHFcNiMVRyDUpCZCL0GPLXjmwKqFwVSsOWJc0B1Z4arZSlTPKAlh4cn/U1Zy1VNxYyuRepsXzLr+C1FsJaAijNFO/e0YyIHtiyU5YR1xSOiM0efYh+ijxxKIXX8Wwb96fr8lgPCMDlglQZ9WA6D0XfdHUCY6wFAj7PrB2tDCucFefpKLMcnJz68BcAzioDxrSRwl72SausWSB1nvxPLGOwi+LLNmAarahkaM9kvQgiY7J5RSn1l/JiOvu+LVLrBY4fzsnwggXUisFG4WgWlIf2BdHdfXVrZ5Z9HZuIekSrud7UJu1fX+g95ltUwqLWs3srIEfW0klClLXjsbrIYIGPZFSTXKaZkAn2YdaSzlDZTeFcjPkH0sgE0DnXRsOUpV9BnDPLRGA8wJxOl4brR0gN/8/wUXmHePylpwAtrfqSqQA+cGUvMzC+0E2HZgve647SBFPFPydDQemE6U0JHeBd+Dux8XKqnDY5qj8ALLrz5oxLhXjUP36cQhTnPqGCLBkUrOGv4+9jk/6e+wMoiSkqukuC8k1Y4keC3oeki9qJ8UyFEBUQZ7OGMgc/aaqnwGPyyQPOYI3V9WYMlEOpC+zBE/dKQ/0aPJqjzyewtRLkWRVg5lpFCSP6Fmj0mAW7cTFOh3nmeOCCVTcACUe0PjKoJNBn7CWW+V5x3ykXFJW2PtLzSjWOORWXQh98x0aGJwI//TIXLN1O4SQNqvgNpcI7yyJ8Uj/h/0AGvohATIESQRO2kNOqLkCA
 WqeWaaaH
 JbMVbV8fqSVavDzG1qxLyNKzKwZhV8130fyEcBtvcB0klKqIaezR7Pwlq7GMZNIPdVS2+IS/iVobmD0gLWNLUp2HbIgXhpGX24ceeadrk9u+xxJHfQsHjVR15hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-17 at 14:32 +0200, Mike Rapoport wrote:
>=20
> Took me a second with the double negation. I like
>=20
> 	if (WARN_ON(!PageReserved(p)))
> 		continue;

Fair :-)

>=20
> > +			free_reserved_page(pfn_to_page(cursor));
>=20
> We already have page here, no need to pfn_to_page() again=C2=A0 :)
>=20
> I can fix those up when applying.

Haha, I added "p" and forgot to fix that one up. Don't apply though.
There's still a problem. See my other email.

Cheers,
Ben.

