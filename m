Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95ECFC4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 06:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064826B0088; Sun, 19 Jul 2026 02:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F30656B008A; Sun, 19 Jul 2026 02:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7CF6B008C; Sun, 19 Jul 2026 02:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E48D6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 02:10:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F7E3C03F0
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 06:10:04 +0000 (UTC)
X-FDA: 85004500728.09.F83148A
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id B095CC0002
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 06:10:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=Sn8gWeuB;
	spf=pass (imf22.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 84.16.66.173 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784441402;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TqRXL2F+WoFOo1zhQuZVV4kwMzRDU1o2kleB4U2hm0=;
	b=YXxV7D7Qnl6GG1AF+A0AyZHzthcW1bK/JeK3L4nzoe/2KpWtjNu4NcsRwPVBZCLi+Jjbya
	+DyZxAoqKWzNLSOS0AzvPe6Zuf7F3I41b3eNA0YsnVBLL4Ns8+F7tlu6+IzBM3/s/dgFkf
	8Ms1il9UkRJlPpkC5+vzgeaK9v4x53I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ik.me header.s=20200325 header.b=Sn8gWeuB;
	spf=pass (imf22.hostedemail.com: domain of nadia.yvette.chambers@ik.me designates 84.16.66.173 as permitted sender) smtp.mailfrom=nadia.yvette.chambers@ik.me;
	dmarc=pass (policy=reject) header.from=ik.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784441402;
	b=oL7QD6CYTX5ta4VC3xaECsV/SyANNPJsT08Bq2ZQKpAV/eUgcFvpQ7FgsMzETkBYbx1j/w
	vfZbMaAKT/dxDu6a8TymcyUPSra3KQBm5BDIZHEhoPLTLoqCxjL6RikgaEoxqgRsoLc8wD
	KNuW0HCUnhimhW/JvSA50mmkbzSMjY8=
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4h2tXl46ntznF5;
	Sun, 19 Jul 2026 08:09:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ik.me; s=20200325;
	t=1784441399; bh=1TqRXL2F+WoFOo1zhQuZVV4kwMzRDU1o2kleB4U2hm0=;
	h=Subject:Date:From:To:Cc:Reply-To:References:In-Reply-To:From;
	b=Sn8gWeuBAu6i8Tkqja08LM7rIDP1TUyvxGkWnSxK03yfXUhUP6ObvApwM1Sjscn+y
	 GzjD5r9wW6UOUWTmwiaNi10SoDepSwnPuE3otV9e4SULE/kdcCBcK4fsGZZJ4s7VVH
	 ytQFjVhFFNYJeZv5x/hpCtHSrjV4re5X9ik50x3E=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4h2tXk6b2Hz7mS;
	Sun, 19 Jul 2026 08:09:58 +0200 (CEST)
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <8bdc154e-57e7-48d8-b1f7-5f0721ba57ba@mail.infomaniak.com>
Date: Sun, 19 Jul 2026 08:09:58 +0200
From: Nadia Chambers <nadia.yvette.chambers@ik.me>
To: Hillf Danton <hdanton@sina.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Mike Rapoport <rppt@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>
Reply-To: Nadia Chambers <nadia.yvette.chambers@ik.me>
X-WS-Location: eJxzKUpMKykGAAfpAmU-
References: <20260719052309.576-1-hdanton@sina.com>
In-Reply-To: <20260719052309.576-1-hdanton@sina.com>
X-Mailer: Infomaniak Workspace (1.3.1305)
X-WS-User-Origin: eyJpdiI6ImdBR1pLTWFEN3g1M0lRSEN0KzgwaWc9PSIsInZhbHVlIjoibVJxcTJETTluVFp1c3pmWWtoWHZidz09IiwibWFjIjoiYWJlMDBjN2RlMGE1OGRjZGFiM2U2MzI2MTRiNTNjYjNkMmFlYTBlODQ4YzcwN2YxNzQ1MjBiNTdjOWM0NDIyOSIsInRhZyI6IiJ9
X-WS-User-Mbox: eyJpdiI6ImljSG92ZmdhWmxSaXJTeHZzRlNPTnc9PSIsInZhbHVlIjoiSzdLcW9lcGg3Q2ptTzNjNTYxd3hzdz09IiwibWFjIjoiNjZjOGRkNjBkOTEyZTU3YTE2MjEwNDAxYjA2YTFiZjdjOGU4YWQwMGIzNzk2N2RkNDJlNDlhZDNhMTI0MmE2YiIsInRhZyI6IiJ9
X-WS-LOCALE: de_DE
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary=fMvjoqQv
Feedback-ID: :99fcc0409e571fb:ham:b89b32586f6d122
X-Infomaniak-Routing: alpha
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B095CC0002
X-Stat-Signature: bphgujkrgggg3m7bbmy6fm1sy9yrb58j
X-HE-Tag: 1784441401-749525
X-HE-Meta: U2FsdGVkX18xFjuF4eev6XP+zMMTpPWULR8wphFjpMPf45VebB5xIqib6yZOG2l9JKrRU0FLIuVQo/D7HapvSfGdq6hM+Of95Ebg5FPJ1Rjd9rhN2sYMhmHJbutpcBDuPDadjn5uS2+KhlOlM6mDAgPeECm2tGfXv1TOAEXe3/WuF4KRubFF/dqSCd29kl7i/4a3pEief5vjphHtXxWZ48oWLru0p0iatXoYW1eDPHaGpnqavHz2QOIoqIPIA9eD//idk9NgVyi00GI+WSm/t6dfulMVr4PjNvFYm4J9RCj8cjN81cl+mh5EhWM5/BBuKeF5iMW8C/URJqO0emiySYkhu7krpQa0aF2+cDx5tuG8YiudggaVpuzMPvMXKCrVyg6onQMu7sQZwgl4gd6Pb+iGagdM6FaCBuC260i356X3VlRgJ+7lv4Uhne4XGhHnx+oPmmr0aEISnoGji/W0NvuQixw/UaVezR5s23IYgzMEog6nMx/6Cn/Va5s8keX7QMTWm8TzPfomOU50EcYNZJoMhqEoaqlSiaLReuIeBBLujEm/k+tW2VJvCheK0SFA9T2pdPSTYhMmO3xtH2/tqpe3krF2NZjif2j05TDPQHsWE6V7YNkVx5Jb08nHepM64roeQG3O4wsQfCHWcQPJ3B234O/KqvRu8DKskOG2S9RXzjP06qoNpny+SYjaf2REqCPjMlZWX8ePqIIovjEthUtwt5wisedCQGFWa01wxp6DGuSKf/4rLUy+NbzBYppYtyv8L7uZKjvGd44liwVKRs5INGUKDyMxtX20zlqejDbFZpCRoPqAiJ2waGh69MwZpDdObcO3DRs3CeeNztYvwhqPsQ1FgP/uNXZ21SMiG2zTLt89tRMgTdWPUjxt5uggd8v0gAWhWSLy1vzXEZsWL3iFdKWjegsp8DBHiStVRQaa7dV84Oo7gZTpcczQEMpkF0inp23uabejgFnQins
 qF5Qv6bx
 8OaIZImMuTigtXo7EMYs10eCGWCVEypRt9QGbL5ZrC4p1QtMjGgwxI5k9p2rPSz6eY8IQ+rUUw6Avs+EmwkLzyZXabg2Jr/QTlXM0INuH238+2mhpdE2GQA30K8XuVjXxGmvVhqaTBmvcU/o2Tm8+BiFICpuYehdF0z2R0qUGOUR5AFqgDBxbOJLUOtFQe/6GXSyZ+bH+2k4DwqpjmOpLm8AAwSNHHPo867XxbJsdTe/P27tchZpQ27IW5ioPuNIZDz7YwBQtssPwc5h8hOOoFS7SQkkmdqfLJwCfIlpacuvhBFo/UnZtdlcVe3mlYNV6kU9N3Jm/7xdIUrcBWRJvCp1NoqMTvtZQZjp9sd0riL41msOqfM67KJlfMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--fMvjoqQv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am Sonntag, 19. Juli 2026 um 07:23, Hillf Danton <hdanton@sina.com>
schri=
eb:

>=C2=A0I=C2=A0dont=C2=A0think=C2=A0this=C2=A0discussion=C2=A0could=
=C2=A0make=C2=A0forward=C2=A0progress=C2=A0without=C2=A0clearly
>=C2=
=A0drawing=C2=A0the=C2=A0rule=C2=A0of=C2=A0thumb=C2=A0that=C2=A0which=C2=
=A0page=C2=A0size=C2=A0is=C2=A0supposed=C2=A0to=C2=A0match=C2=A0what
>=
=C2=A0RAM=C2=A0size,=C2=A0with=C2=A0the=C2=A0supported=C2=A0page=C2=A0size=
=C2=A0put=C2=A0aside=C2=A0now,=C2=A0because=C2=A0I=C2=A0dont=C2=A0know
>=
=C2=A0why=C2=A0128K=C2=A0page=C2=A0is=C2=A0needed=C2=A0in=C2=A0the=C2=A0xbc=
/yz=C2=A0environment.
>=C2=A0
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0RAM=C2=
=A0size=C2=A0=C2=A0=C2=A0=C2=A0page=C2=A0size
>=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A032G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04K
>=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0512G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0128K
>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04T=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A02M

What is the theory behind what you're doing=
? I would expect the most
directly observable effects of varying page siz=
es to be in situations
other than your own. It does a variety of things, =
but they seem likely
to be second-order effects behind a lot of other iss=
ues you're likely
to have before boosting the page size would help. Do yo=
u have more
detailed descriptions or better yet profiling etc. data about=
 what
you're trying to solve?

-- nyc

Gesendet mit dem Nachricht=
endienst von Infomaniak, The Ethical Cloud.

=20
--fMvjoqQv
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><br><br><div ><br></div><div class=3D"ik_mail_quot=
e">
 <div>Am Sonntag, 19. Juli 2026 um 07:23, Hillf Danton &lt;hdanton@sina.com=
&gt; schrieb:</div><blockquote><pre style=3D"word-wrap: break-word; white-s=
pace: pre-wrap;">I dont think this discussion could make forward progress w=
ithout clearly
drawing the rule of thumb that which page size is supposed to match what
RAM size, with the supported page size put aside now, because I dont know
why 128K page is needed in the xbc/yz environment.

=09RAM size=09page size
=0932G=09=094K
=09512G=09=09128K
=094T=09=092M
</pre>
 </blockquote>
 <div>
  <br>
 </div><div>What is the theory behind what you're doing? I would expect the=
 most directly observable effects of varying page sizes to be in situations=
 other than your own. It does a variety of things, but they seem likely to =
be second-order effects behind a lot of other issues you're likely to have =
before boosting the page size would help. Do you have more detailed descrip=
tions or better yet profiling etc. data about what you're trying to solve?<=
/div><div><br></div><div><br></div><div>-- nyc</div><div><br></div><div>Ges=
endet mit dem Nachrichtendienst von Infomaniak, The Ethical Cloud.</div><di=
v><br></div><div><br></div>
</div></body></html>
--fMvjoqQv--


