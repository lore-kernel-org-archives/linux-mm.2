Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B846FB5191
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 05:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43856B0088; Tue,  7 Apr 2026 01:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3DC6B0089; Tue,  7 Apr 2026 01:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09F36B008A; Tue,  7 Apr 2026 01:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA7216B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:06:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAEAB13B4F3
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:06:32 +0000 (UTC)
X-FDA: 84630574224.17.6D31B5C
Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id E7834C000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:06:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=MRhmzOTd;
	spf=pass (imf28.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.36 as permitted sender) smtp.mailfrom=yukuai@fnnas.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775538391;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKPi8y8PdSpFcyowFDm1DUvLNnMU05AcHVXRyi7Ek60=;
	b=IYcJR302XsIFx7D+V+sYu/QMrUPYSh50jRGycsUok5y+X3wGaRgmZPV421u7nbdm8ZRspt
	C+QmlEEqXHN8wEHnaCewszvF0SUkX3MWHHBP4qR6DMldRV5QGsmny3Y+S725EXu5xBnSnr
	U9BLJmP19GnCyEpXGAk6ld3Xhxp9nrw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=MRhmzOTd;
	spf=pass (imf28.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.36 as permitted sender) smtp.mailfrom=yukuai@fnnas.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775538391; a=rsa-sha256;
	cv=none;
	b=U8wlvfv9vQ/4vqsvjWAAr5PFvj+p6hQdsLSMKfvAwlk4zSXzLd4G200Is2tGiDWV4vFu5e
	lq46b8x9zrqGw+vvqIYUWHkyOs1qHPGowSd7kK+As6wQgYUEw/h8CTJ5YNzhRa/kQXv0eE
	Dpe3GBAcWVR3VJGQE4hCzLdsGoADJmQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775538384;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MKPi8y8PdSpFcyowFDm1DUvLNnMU05AcHVXRyi7Ek60=;
 b=MRhmzOTdlg67zi/8ZKGOYd1NTalQiQTfU9guf4IjslsRqGJgEm87HaOzJdoFzXPbrbSYFP
 yc+ZLVXY/oHiTnw1NRYfsX4RxALZ0/wpNQtSPRayCD3vXfFiBaMjevQXInWuKj7p9bLxIR
 3ftSUTrP4eO2iaODQIMaMYyzdWxoZrDfhL6qgdbfnPhCb9uG0SUn0+gc6ECZuMcd0sP9BI
 IWz1Lo0A9uA28n5WvzFr/8pVr/unnHNRNrwmpN5nYKLJES6wP3qaptSm2thobSp2RhFdvq
 GqHUO2SUHzKRoSFvDRRBbchTtCvcQDKEk+ME2hV6+ro0jUChCxb17KmgDLI1eg==
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com> <20260308234202.3118119-1-gourry@gourry.net>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:06:21 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, 
	<syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>, <yukuai@fnnas.com>
Message-Id: <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>
Mime-Version: 1.0
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Tue, 7 Apr 2026 13:06:19 +0800
Content-Language: en-US
To: "Gregory Price" <gourry@gourry.net>, <song@kernel.org>, 
	<linan122@huawei.com>
X-Lms-Return-Path: <lba+269d490ce+974e58+kvack.org+yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kmfu7rqhdwtq9kb5wot6xhoknc7j7rsn
X-Rspamd-Queue-Id: E7834C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775538389-177771
X-HE-Meta: U2FsdGVkX19olZY7ET8Oyqw3QUyo0v5pxNlOaEcX0a9e+XjKqQmg1PLkC/GcSWnYwxL5OI3iZYYBih/kxdYGl/SZuw37en9+qAjK2GNQNE+S6h1iYXywTo8JHIS9PVd24hIXAhldJPmh+s69reCprPZeBEMT/ubGVuovKp+BJOAQhbmVIdc48+fNPWQvuhcfXXP43qo0dMiJL3UPlUw/+oXLIFd4eMokhmpye1AkZwZdLbXYiWsSk8ZnNslhoyw7s2pUTpnq0swaz0o1TvdtzhRSUSVfMRXq0pKhCCQFU4LuwQzkNjj3uEnX4CYDv26/nA12CWXjpVRuiYbbBWz02Xv3s3r3Lv6YEpsftVWwbZ9BnQ3MrdFyuIwBzxGPHCRRluUIms+umx41r3uPJpVr7fB/BFpEd2SOVfKeA8MwNPcJ9+UIJ2SrSEgiGJRAuJ411Mj0QX9u+nvwgPduNAvyM0J77WfNob9op8wOKXXdZC0k2uA/gAH2+YtaQSyvDa+dDsN9JFVl5bLXfFR0CZgFY3b5wppN9yA5pc0ksNOaozpWGkUxI3YXkzoS0N77xD1/Tfv+uKQ2O33gAJANM70lv7eD+7we1FHEoCfI40jnF8DUScb2WnRCQkDnZZ7UX2dgJV5w/RH7gegRucPJ1kRClW0cdz7xW8oXPRIk3TazaQ5+dx4/6h+tGJ1sMkvtyiH9gW3zbpP28dE/rsyK9rnMjRR+Wkvlg5Bf9X38ga/ObRTKi7vzTrhVbhgCnEaw6KDQlDwPqsoT0y8T+1cL67RxWekyII8iF4oj0y7yRsGo7M0Col5bvzwku1pOtTKg2teZHDUTkDhLO7eiAeTCQW3nFHvqJ1rVdHIId/FXBAI3PYVJIXk2AtHBhYqkw18XLO9mUxcVEGR93NCoNxSOvPP451j1iTzDwY57RJ3/hR97jTIy6RW4VelJbOvrturKg1pdWHqa97v51Xorrj7waf2
 jeEhCBPp
 6rfvm17uS85uU5q3F28dDjOnqAmT5TipEE/zFIMdVhKT+zBgoBa0ZmdIhi4dzGc/3q71MVwh9ZhKxDvXcr/MNwn81lS99OfAEjJ802kirFIL0BrSVYMt2WXfx+Qjz32MOAxlMpWj/Z+tiSTYVlKlRSDN6xlI/QgNASVmK502EtcEWvMzb3WiDEaBv9g62lS8yj1iCQi/y2Yd/VIvTk1yDS2D2KWuqYHODeOLZdyWDOw8lI8cw4y6JpCKpXU4DJzy8ago8I/tktDXkAC2Biou3TnoFAJ9JA59URK2MQZsxNdeXB27YVy0jifdLQYJwxKvylzrhGxFDT95CNZGay39boLpUFZaU13KxuEhugBvxzODnv4qDR5WSsE9xJvETlwhKeYX1PfdAXsZgv5/+7u1rFfgI57FjOHgSSClXWVEYYvkhLLcHjaTGfi8eXA86w6YZT3FJRmOwhzMpMCu+7vk6eLfqKSD69hAnG7GZ+OplXpNgWKhy3TNaj9ZScwpm/aqJFFAS8RmV0Xmb7TmFkrWAqrHZKXVctKR4Dxh138ZhKwtFv6hBTgn8SP6bdeECqSg14KRHYJQjTTuKIGk8Gz2U0CIUg6VnY/n/K1xI2knHPua27/6HYzDDwpXrhvQk4yiSHhTFeqxB/JnYKH1fvN4dzIcPwHQWBjy8IVqIGvirSeQfnqP0/wZMoYNsTMK18wksVqNJLfqQrAx05TlBcd9JDN7X4KLmaKL9/8XKOd7NFta2mtN+QS3pOr2r4hsWEzqPL8M9MXcPMpVXnscpffTbXLh8yK6TPNVNJ/bc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/3/9 7:42, Gregory Price =E5=86=99=E9=81=93:
> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof(=
)
> triggered by create_strip_zones() in the RAID0 driver.
>
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
>
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs =
to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
>
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physicall=
y
> contiguous memory.
>
> Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com

Reported-by should be followed by Closes tag, applied tom md-7.1 with follo=
wing tag:
Closes:[syzbot] [mm?] WARNING in create_strip_zones - syzbot <https://lore.=
kernel.org/all/69adaba8.a00a0220.b130.0005.GAE@google.com/>

> Signed-off-by: Gregory Price<gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

--=20
Thansk,
Kuai

