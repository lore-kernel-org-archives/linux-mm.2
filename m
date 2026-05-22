Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A76CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3966B0093; Fri, 22 May 2026 08:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9950C6B0095; Fri, 22 May 2026 08:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB1F6B0096; Fri, 22 May 2026 08:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 770846B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:18:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2894A1C079F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:18:31 +0000 (UTC)
X-FDA: 84794958822.10.65E9190
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id A95191C000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:18:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QXI5kMYZ;
	spf=pass (imf18.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779452309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ScjPVgAsdJW+wEXrKpRoUOaQ0I9D+qqUd8b/ES6NUY=;
	b=g6WC1wApF0U/BOmgxn8G68BNEBVjlFRy+6mM7hFhoHSmFvrhSmkXCeVlVszSgcozFIhizy
	Jq1sH9xEjouc4o+mOUo7+Cj01Xldfm7U22F74OzcDpC4ozSKK6KrQmNeNoHLivn4SNT3bk
	rw5tDdhF3neti3GiToSDhtGkhBiHWCk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QXI5kMYZ;
	spf=pass (imf18.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779452309; a=rsa-sha256;
	cv=none;
	b=uGG0/FGu/ycV1n2alH2B7fn4NE0sUV7WIOiSg9fDs0BwY0Pr0NWv8wdPOqAWS4by27Hh9n
	XOYEoUkLDkL1zstkvF/IowNMWIXt4rpKbJXmDxVFiy0eud+zq7sydNR6V3Z9fuwoTO//Sc
	SV9WKV6C/qqfrflTdBVbkD/01OJ4CV0=
Date: Fri, 22 May 2026 14:18:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779452302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7ScjPVgAsdJW+wEXrKpRoUOaQ0I9D+qqUd8b/ES6NUY=;
	b=QXI5kMYZp5a6wrREFTPwq00taIPiLqrhoe+uresI1mP6PT+BBgZ/tgFvI7+BkC86XIPoeW
	mxASzakHwRpQQswwcp6nVY0IeJCQaaz6Fkh1M7z30qMx7sH9lF4LuR+JjVpfsJyaqSwWBp
	K1JLjHmr+/RO7kiUqvOu1Am+45fMyZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <ahBJiHu4GLnVyqYS@linux.dev>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <ag7pFxHpMGU0zLvq@lucifer>
 <ag8cvjwDGCt_14pY@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag8cvjwDGCt_14pY@lucifer>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: epnhynn4ad6bby65xpnd5oe4k3g1eqkh
X-Rspamd-Queue-Id: A95191C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779452307-379710
X-HE-Meta: U2FsdGVkX18B+BRMkyqZP4Hkj81h8KL8sEsHpQganjTw9boZ+pEbiFmsVig4LatgHOSvXOH7gDHpgEMU+fqngzYDRNqrUr7HUWsLCHR0XugZbskcC9rPdaqbTjaCTzYAG7uhoxe70tANI/KZ8smJ/balOUXhfdamifH4BsHfloBJn29slfHAYhxJA0dJPEuhK0k61R2YlS8Nr1NLu3+UbRSnD5ByJoSOigKNMi2XcpY/swsaMa5Io0Z4D8MMFsV0Ltav3Lf68pjIAfV9enIdc+ssbf3eG2UfDvqnN5nZQo458cNh8Jd6/N6B6RxcBr3v+GcRjvOAV4k9CV8utPhLjRtUoGVh68T8pBh4+f91NcRGJ8u24gzt2re+l0HY8eSXzsCDeS8M+3WroTZwPd0DVPbrPFww8sRNLAr1OWiZExuMlmk1VPq+kdbxohwXWi2MF1AysuZJX7pQGDoSnpe91YV5oA1W8VLq5NEDEaetuBntmI/og8ZAO6ecLkEGGBvfexnPd+U8bcYkCkarAYJsqD2ervvDLtnlDVfc9Je/1oaGW3jDF2WGoQfpZ92md2MXwjkzC83TXxwfl+Xe25NsSqAonaxrycm0D1M9YfoaYzmesSET1hulRD0YFyLh1dT4E83v+cuJ3oPiMCZj68UWuxuE/UsR72Jt+M+2yY/UgGz2hXMQd9k2r8BE2JPEKSDPpfH0OSsbSJYXT3ASd1ZHVMGpWxD1uplnTyrEsSG7+FR8LOxH8NWy/QT8A+yV/8fz71mrySAfYfpF3zpw3juA66WOuuNnzih/vqyuVAoi/zqAYnUomNMcT8LZGzFnjS4E9U5k7rCnJjDRkUgTfubbomYqon4xB9+F/nQW/DDgOLZVfAru9WSVwS/1RxOUSLZ6P4J909OfTn6tqGO84Mo7iM9Id7BkoIU1FRf1edjDhB3N6eD/P//5iJcnAgdV5ghlSZJVyQhkL9YjRG02SKk
 nGNxmMls
 ctQ6m0wW/RrZNPhl3m53VCuGdpkm1S1TcZw42tkBQ69PJI3ykb6sjIWDOoUB3w5H3lK7ZLWkCW+7WP/2x3i3VBZpN15E+DofJ55W9cGh01LFY7fnRaLEHs47otKQ/4DM2Ba4F7NoWShddiT7mZWgXsXHy3hx/hMzEytO5nXEWgF8AT4U3pI15VxFxJKt3CzymEUE10IKirtezaFrS5yzuuJJujTHBUjZ/yORqC2xiKnzbBhsRbnnw8MQnE/TpW1XsX3wm0CxaPAcg6L+frdUM1N/aEHiq2qkeJbFCK7+S/WuVVcETRpXmWqlpJPsi6vfMTlhtR0HIe3LVnC9JGdlMaUFS2WqCdQNZ+Zlh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 03:56:19PM +0100, Lorenzo Stoakes wrote:
> On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> > On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:
> > > Move offset_in_page() out of linux/mm.h so users that only need page
> > > offset calculations can include the lightweight vdso/page.h header
> > > instead of pulling in the large linux/mm.h.
> > >
> > > Include vdso/page.h from linux/mm.h so existing users of
> > > offset_in_page() continue to build.
> > >
> > > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >
> > LGTM other than dropping the include below (maybe Andrew can do it for
> > us?), so:
> >
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> TBH I'd like to withdraw this at this point.

OK

> Unless a series can be put forwards that sensibly justifies this, not some
> random change somewhere, I'd rather we not take it.

Using lib/bitmap-str.c as an example was apparently fine, but since that
is being removed, converting lib/string.c instead to use the same
idiomatic PAGE_SIZE - offset_in_page() calculation and include a
lightweight header is a "random change somewhere"?

> Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page() is
> really an mm thing so that's another reason not to move it.

Adding a new header was rejected (ok), but moving offset_in_page() to
vdso/page.h was your and David's suggestion, not mine.

Let's just drop this series as I don't think this is going anywhere.

Thanks,
Thorsten

