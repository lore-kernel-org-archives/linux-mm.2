Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCA8CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7026B008C; Wed,  7 Oct 2026 06:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486D06B0092; Wed,  7 Oct 2026 06:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375876B0093; Wed,  7 Oct 2026 06:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10A106B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:30:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72B464018C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:30:43 +0000 (UTC)
X-FDA: 85295461566.14.BFA6405
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 324A7140002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:30:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="Ecf2W1/p";
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf26.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791369041;
	b=XkFwNTlAfOYkNSDrZ5M2qgVHBwqgX6wHYMLwjGiTGkfthAXBette87PbHwnDvbFXStJMEx
	7kdZWUTAlY0n7xKqutEw779VVgwPu/Xh1J5qNdwtksSw3n2r/AaGl8dvLOHcxSGF8FfyHM
	HGozPC6tZUPha+zNs2cYXQZ380S31Zw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="Ecf2W1/p";
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf26.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791369041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Qacvnr9+rdohiy2Wh/N/8ObAl8Kh5+mo0TjMl6VdFo=;
	b=rwEB9v1uq1rlJFab+0EsownWfvPReqAQOgAWDmk9OJPMLTIy0ZSQGjN3pR0FewlFPwgC9M
	6Ivz8j11518AjRfbgt87d7GzuJFmp3ytzUceMripSY76a9aBvxtZImwZg8cW7juyTZK4to
	FFEEzdqyj9tiTaxPPHyWyQfTui4ZPd0=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4j08XY6fTxzMlLx;
	Wed, 07 Oct 2026 12:30:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1791369037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Qacvnr9+rdohiy2Wh/N/8ObAl8Kh5+mo0TjMl6VdFo=;
	b=Ecf2W1/p6gXYnZ0aToASIXX/nhBCP9Ld2OBgnaX1tN4jhbl/WtGAEU5FMgTycWed4Q6eO6
	504I9Exym3TEjaUWXIMyReR9KXdpfuxYyX3uvq4Z9/kXnlQm4iNeOEBtIkxfyurnG8xM/s
	K14uYyTUIxO8ngD03YLYr9NPW6EEpGaAn7WxVEvkMzCk8Q3jo3qC6ver1eUsXYSpvHzucI
	hGj9wEaPopSHQtNzgLhr5k7XlW2Zu1yoAZsXMyQpuHCVK4GUllNJ6gdRZYmhOfcbL3ceb4
	4kQxVdNQahyfLoj9zoCOFYl8ABl+4r69+aGgiBDBJudzJnNyyXyHnwUjHGr+gQ==
Message-ID: <311d97da9ba4b870ef03aa412586b751bc7da3f5.camel@mailbox.org>
Subject: Re: [PATCH 1/3] Docs/admin-guide/mm/damon: Fix various typos
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>, SJ Park
 <sj@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	ahuang12@lenovo.com
Date: Wed, 07 Oct 2026 12:30:33 +0200
In-Reply-To: <20261006061549.627-2-adrianhuang0701@gmail.com>
References: <20261006061549.627-1-adrianhuang0701@gmail.com>
	 <20261006061549.627-2-adrianhuang0701@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-ID: 0e0d33099551aaf3e49
X-MBO-RS-META: xas4d1k19jcabmc9ci34dwoejeb97b31
X-Stat-Signature: ueeocdekoc8tkunf7w1r1bqyd44wcu1p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 324A7140002
X-HE-Tag: 1791369041-224580
X-HE-Meta: U2FsdGVkX18lDVTSus54u2rHPGLzOS9Jz2yhUjSwSGbCII1iwu/NisA1NEtq5po3eVkE8D6gwxxz2P9HNVOL3fAN99mW0iJ9ZlufUygQiB1cmZEKS2h/KxNzewXGYAJtBH0s3RUkUEwMs3syHspMnHZhb0JQZFUWSLaSTxwGTnbiw28I7IyHg/1jm5+FuAgZzHBWZvBpoUkgjN1DiWF5NqJz/Vyg73eJiQOmhM2/Hr3C0v61B5TmFVyTx3p5eNJHfUnJyTN9rsxNWD/bpkGuzTxAyAoF9t+T2N2+X2+FGLZ4mNmByrBXavy0darDsc7GyI2lGr20KIPiz60OT8QlOFeoM+rBhHfxBlOb1D3Q97WaGvWM4AH3EVwSegWed8C6CSAYcngO4pI7jrGyiQFD4KT4VBQ7bqAsLl0nzQTvhCQNEG8hYsWaJGPwv0Gb3EVtjPMQEdLDOY86TbufutpIhaoP/75rhf9gm4RXF5bC6ZSdseTB6LMiScWOHjeUQUJDTpq6mFxV4JvW5dORJP96hv3cqe92ECFjXeoE3r5wNXBZn/sca3Y8toca7vmfo+z7bpzJlkSlfIkEZ91QcvSt+6aDD0fx3fwtUNN2r4BC9+AChfSaBL33US8cSz5hQmsmlBFuur2pZEVBSolQN+d6qTocYxfTdSI8Iw5vHg2SIpThPYVRxUKNw9spy6PQCEIji/Bs+nibacRup5veHh+zDjjx00oOLn/gaBYMv02LNX2r7bayJUssRTmQeAg5Iu5noSL5PMrsSNka8p+qif4xWeGMrhiJpJGoDXW04hW7M7Ro6am7qrMZBE5CnjWykBG7p71my2h0i5eQmxUQ8JLefrhRLwE6ZO12JPRMA28tOIHvVzhmxwkomgu2HXhJ75FKBS9n+xvgTA4pNUH/5fqyzgXSU90G97VgTfrB5ENQ+6AftzQGTrL4yWwFtW6LGP+5Zso4LkZV3JiNe0HLjmb
 I0k4QorY
 g1akodkmjkgP7LvLVMLB64NYo/iHZzsMfEzzkB4bza5fx7ZO3PLhN7ABS7UlXWlSYwvSfcmFUqUx79ZkYDOAZmrYvcs1hh8aEu3yhyBRKs0pbg8XvbjnxfFlBk/iouzNVTQn7zYdhkSwZO/MtahY9pGMKQ+Tlg20DgMwijq7pKsCl7fkuT+oJiZgju2tzLkD5mCNAFqA4f26V816ofzB9gi0j5MbVo83HfqRDUr99PAqU6uSJLFalOeM7z9xJZgQ8ti1ZC4iBqPxcOP+pgfJDqdU+2+EIiZDe77JAM0hnQDLZLD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

I have read your patch and the affected files. I have found
a lot of issues, non in your patch.

This got kinda big, so if you don't want add it to your series
let me know, then I'll make a patch on top of yours.

Thanks
 Manuel=20

On Tue, 2026-10-06 at 14:15 +0800, Adrian Huang (Lenovo) wrote:
> Fix several spelling mistakes found while reading the DAMON
> documentation:
> =C2=A0 * trusworthy -> trustworthy
> =C2=A0 * DAMON_RCLAIM -> DAMON_RECLAIM

There's one more in in a comment in mm/damon/reclaim.c .

> =C2=A0 * charget -> charge
> =C2=A0 * hetmap -> heatmap
> =C2=A0 * colun -> column
> =C2=A0 * evelenth -> eleventh
> =C2=A0 * idlee -> idle
>=20
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> ---
> =C2=A0Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-

 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module t=
hat
-aimed to be used for proactive and lightweight data access pattern based
+aims to be ...

-situations including reclamation target pages selection under sudden memor=
y

+situations including reclamation of target pages selection under sudden me=
mory
 pressure.

-DAMON_LRU_SORT finds hot pages (pages of memory regions that showing acces=
s
+DAMON_LRU_SORT finds hot pages (pages of memory regions that show access
 rates that higher than a user-specified threshold) and cold pages (pages o=
f
 memory regions that showing no access for a time that longer than a

-You can enable DAMON_LRU_SORT by setting the value of this parameter as ``=
Y``.
-Setting it as ``N`` disables DAMON_LRU_SORT.  Note that DAMON_LRU_SORT cou=
ld do
+You can enable DAMON_LRU_SORT by setting the value of this parameter to ``=
Y``.
+Setting it to ``N`` disables DAMON_LRU_SORT.  Note that DAMON_LRU_SORT cou=
ld do

-condition.  Refer to below descriptions for the watermarks parameter for t=
his.
+condition.  Refer to below descriptions of the watermarks parameter for th=
is.

set as -> set to, a couple more times

there is '(de)prioritization', '[de]prioritizations' and '[in]active' -> un=
ify

-interval 5 milliseconds in minimum, and 10 seconds in maximum.
+interval to 5 milliseconds in minimum, and to 10 seconds in maximum.

-monitoring.  This can be used to set upper-bound of the monitoring overhea=
d.
+monitoring.  This can be used to set the upper-bound of the monitoring ove=
rhead.

nr_lru_sort_tried_hot_regions
-----------------------------

-Number of hot memory regions that tried to be LRU-sorted.
+Number of hot memory regions that try to be LRU-sorted.

bytes_lru_sort_tried_hot_regions
--------------------------------

-Total bytes of hot memory regions that tried to be LRU-sorted.
+Total bytes of hot memory regions that try to be LRU-sorted.

nr_lru_sorted_hot_regions
-------------------------

-Number of hot memory regions that successfully be LRU-sorted.
+Number of hot memory regions that are successfull LRU-sorted.

-Total bytes of hot memory regions that successfully be LRU-sorted.
+Total bytes of hot memory regions that are successfully LRU-sorted.


> =C2=A0Documentation/admin-guide/mm/damon/reclaim.rst=C2=A0 | 4 ++--

aimed -> aims x2

-DAMON_RECLAIM finds memory regions that didn=E2=80=99t accessed for specif=
ic
+DAMON_RECLAIM finds memory regions that weren't accessed for a specific

-out memory regions that didn't accessed longer time first.  System
+out memory regions that weren't accessed longer time first.  System

-automatically activated and deactivated with three memory pressure waterma=
rks.
+automatically be activated and deactivated with three memory pressure wate=
rmarks.


Thanks again
 Manuel=20

> =C2=A0Documentation/admin-guide/mm/damon/start.rst=C2=A0=C2=A0=C2=A0 | 6 =
+++---
> =C2=A0Documentation/admin-guide/mm/damon/stat.rst=C2=A0=C2=A0=C2=A0=C2=A0=
 | 2 +-
> =C2=A04 files changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentat=
ion/admin-guide/mm/damon/lru_sort.rst
> index b93ca9b0853d..c3b688385681 100644
> --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> @@ -7,7 +7,7 @@ DAMON-based LRU-lists Sorting
> =C2=A0DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel m=
odule that
> =C2=A0aimed to be used for proactive and lightweight data access pattern =
based
> =C2=A0(de)prioritization of pages on their LRU-lists for making LRU-lists=
 a more
> -trusworthy data access pattern source.
> +trustworthy data access pattern source.
> =C2=A0
> =C2=A0Where Proactive LRU-lists Sorting is Required?
> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentati=
on/admin-guide/mm/damon/reclaim.rst
> index ec7e3e32b4ac..e4e2ffa52e26 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> @@ -55,7 +55,7 @@ enabled
> =C2=A0
> =C2=A0Enable or disable DAMON_RECLAIM.
> =C2=A0
> -You can enable DAMON_RCLAIM by setting the value of this parameter as ``=
Y``.
> +You can enable DAMON_RECLAIM by setting the value of this parameter as `=
`Y``.
> =C2=A0Setting it as ``N`` disables DAMON_RECLAIM.=C2=A0 Note that DAMON_R=
ECLAIM could do
> =C2=A0no real monitoring and reclamation due to the watermarks-based acti=
vation
> =C2=A0condition.=C2=A0 Refer to below descriptions for the watermarks par=
ameter for this.
> @@ -125,7 +125,7 @@ quota_reset_interval_ms
> =C2=A0
> =C2=A0The time/size quota charge reset interval in milliseconds.
> =C2=A0
> -The charget reset interval for the quota of time (quota_ms) and size
> +The charge reset interval for the quota of time (quota_ms) and size
> =C2=A0(quota_sz).=C2=A0 That is, DAMON_RECLAIM does not try reclamation f=
or more than
> =C2=A0quota_ms milliseconds or quota_sz bytes within quota_reset_interval=
_ms
> =C2=A0milliseconds.
> diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation=
/admin-guide/mm/damon/start.rst
> index ec8c34b2d32f..d98b0eb8e771 100644
> --- a/Documentation/admin-guide/mm/damon/start.rst
> +++ b/Documentation/admin-guide/mm/damon/start.rst
> @@ -69,16 +69,16 @@ monitored access pattern of the process from DAMON an=
d shows the pattern in a
> =C2=A0human readable format.
> =C2=A0
> =C2=A0The first line of the output shows the relative access temperature =
(hotness) of
> -the regions in a single row hetmap format.=C2=A0 Each column on the heat=
map
> +the regions in a single row heatmap format.=C2=A0 Each column on the hea=
tmap
> =C2=A0represents regions of same size on the monitored virtual address sp=
ace.=C2=A0 The
> -position of the colun on the row and the number on the column represents=
 the
> +position of the column on the row and the number on the column represent=
s the
> =C2=A0relative location and access temperature of the region.=C2=A0 ``[..=
.]`` means
> =C2=A0unmapped huge regions on the virtual address spaces.=C2=A0 The seco=
nd line shows
> =C2=A0additional information for better understanding the heatmap.
> =C2=A0
> =C2=A0Each line of the output from the third line shows which virtual add=
ress range
> =C2=A0(``addr XX size XX``) of the process is how frequently (``access XX=
 %``)
> -accessed for how long time (``age XX``).=C2=A0 For example, the evelenth=
 region of
> +accessed for how long time (``age XX``).=C2=A0 For example, the eleventh=
 region of
> =C2=A0~9.5 MiB size is being most frequently accessed for last 3.7 second=
s.=C2=A0 Finally,
> =C2=A0the fourth command stops DAMON.
> =C2=A0
> diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/=
admin-guide/mm/damon/stat.rst
> index 46c5dd96aa2e..4a9db755a526 100644
> --- a/Documentation/admin-guide/mm/damon/stat.rst
> +++ b/Documentation/admin-guide/mm/damon/stat.rst
> @@ -81,7 +81,7 @@ Per-byte idle time (milliseconds) percentiles of the sy=
stem.
> =C2=A0DAMON_STAT calculates how long each byte of the memory was not acce=
ssed until
> =C2=A0now (idle time), based on the current DAMON results snapshot.=C2=A0=
 For regions
> =C2=A0having access frequency (nr_accesses) larger than zero, how long th=
e current
> -access frequency level was kept multiplied by ``-1`` becomes the idlee t=
ime of
> +access frequency level was kept multiplied by ``-1`` becomes the idle ti=
me of
> =C2=A0every byte of the region.=C2=A0 If a region has zero access frequen=
cy (nr_accesses),
> =C2=A0how long the region was keeping the zero access frequency (age) bec=
omes the
> =C2=A0idle time of every byte of the region.=C2=A0 Then, DAMON_STAT expos=
es the

