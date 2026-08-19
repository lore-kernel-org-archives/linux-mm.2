Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B25C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 01:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FD16B008A; Tue, 18 Aug 2026 21:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0006E6B008C; Tue, 18 Aug 2026 21:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31596B0092; Tue, 18 Aug 2026 21:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B44EB6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:15:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0CA31203D4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:15:11 +0000 (UTC)
X-FDA: 85116250422.28.C050C03
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7AB07180005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:15:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=iq64qdYC;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787102109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+1yMs/TAg44PdtgHr4whUenCDXTlH65MGNSP0QkUgg=;
	b=lkJ3YpqgnEbf3plqmrbNdBcIXtc6jGxvrddMDHZo4NaKvCLCd2vNYsCLZ6TM+g0+a8VWKK
	pBPadFg/Bj6krV4npUSJUFLZ2lrONlmMTSGm1sP1bbYW9wbMTdnL2APmEuFdrhI+fGGSjv
	tpP3PUmZM6VMbBvymQgUIOxl3lgyo3I=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=iq64qdYC;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787102109;
	b=W9ZHp6Rs3GGAqay+d3u97oK66qT4tk8Sf/aSxGtY01XpMK3LfG03cTLCS11kFhi6nFE7/j
	J+QdsZYWbw7sH6xloAVfs9pm8G3dJcHhq+TnPPMKLZTWVzygurTcsmkixaXkFAbb7Pk3KC
	O/OLw7rGtqpS4rQ/xIlhpzN6kAyigAw=
ARC-Seal: i=1; a=rsa-sha256; t=1787102084; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Vb7w8BxrWfF9lHwWUjEbzRIx6KBRsUigHB1BIq5oHipa4Sd5jus0nZuCNwSMN16h13U89lzH6ju4G911GghpembRCVMf6Yw1CT8w/E/crZljRwsXmE/Li+OUqGXnCiffP8k9tD//Lp24NVcZUbhP1N5p4BakadY5nnGnGkrKlP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787102084; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Q+1yMs/TAg44PdtgHr4whUenCDXTlH65MGNSP0QkUgg=; 
	b=WzWWhEtFLhl2pB77v6E9NVuvONhpfr1iSWuWwttJmBuNvgr+2o5q3xLfDp00t9v7wxA6TtHtnvNzvU8dXWIOvWkefjmVNqix8VmBZHLHfLyjsAfPFlptN+Qb3+HpTwx+l+7OFJPjiKQdWKN6Hk7kagCTpAvX98Wc1+Uk45k0X3w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787102084;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Q+1yMs/TAg44PdtgHr4whUenCDXTlH65MGNSP0QkUgg=;
	b=iq64qdYCSRkOo6W1o0SCny2QBrEIZAAUw+Q6FRFTCwzUHg5s0qfJmEOfHSz1ivlZ
	DnhE8UtxYhGyGliZxovvaGRIYEAuZhGP9XmhynpPXodH7YfeM+jsfwNR5IstCYJqeee
	qfOU1FA7TEkwqMY9QjgL3LcezQkk/TXcXATx/tvM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787102084308142.55088526691668; Tue, 18 Aug 2026 18:14:44 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787102081175753.1506133241837; Tue, 18 Aug 2026 18:14:41 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:14:41 +0800
From: Li Chen <me@linux.beauty>
To: "Justin Suess" <utilityemal77@gmail.com>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Mateusz Guzik" <mjguzik@gmail.com>,
	"Andy Lutomirski" <luto@kernel.org>,
	"John Ericson" <mail@johnericson.me>,
	"Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <shuah@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Oleg Nesterov" <oleg@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
	=?UTF-8?Q?=22Micka=C3=ABl_Sala=C3=BCn=22?= <mic@digikod.net>,
	=?UTF-8?Q?=22G=C3=BCnther_Noack=22?= <gnoack@google.com>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, "linux-api" <linux-api@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"audit" <audit@vger.kernel.org>,
	"linux-security-module" <linux-security-module@vger.kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>
Message-ID: <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty>
In-Reply-To: <anJE8SfBLtkh6QSa@zenbox>
References: <cover.1784204592.git.me@linux.beauty> <anJE8SfBLtkh6QSa@zenbox>
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: st4akoh5ijf49k9jx345isrrk7shoic6
X-Rspamd-Queue-Id: 7AB07180005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787102105-866238
X-HE-Meta: U2FsdGVkX18zMIWEND/p3Hn6UeVmmBigCdUAS8UVTxJmj5eq78i6wvnOJCuFEyCasoq87bLyih9/HMYNx9zSuaOV3ZQ0MwdMdp+H5y9xp5kMDcsPXmMd/zboY07hC2+mVAFbjLQ8ClmsPvLvaVkAu1FwrHVUhOaeRVbYymJbveJB7qIdsQhXcM9XSrWwSnoTqArV4Qpm6aPMZzeQnKuz/kdAiGqtGO2KfBdkUTFnE61t2ommdfwzs1xG4lYcNghQlLxptQvdG26byZiu4CS1Vv12ccdb7sKcBaW2Kxi1LiFE9omrMfbHzwYfP+3nHwVKU95E/fx8fl+O6vNnP4icjRaAawolh6dl72pgg44qwEFRAKFeOTsUL0YtcmGwG4wFxKjIpZ0HkE695dIwO96MUW13DE7TA67FxPTCoa75oprXtx577q6h+YXWvlWlfzrWLMuMP4vYoqlRzzVNjMwv3MmTR8SkrVatOXrjWTCR2udlaYMZI6JxzBV9cNgE1exkoXpG7WKXzBI/LcYaR/Yry564/EIXAeuD5+LU4xKWrvlATgjMrhwOuOZr1PvC5yVAISRzasHLvaUh0hCetWJrrAPBw7C6Lf89KTMnXBkMzNjkhoikJI47RczJTjHYhCbT+czwFqOzYQMHyMve55egbrDvGaTQ22cYDgD5DC4LtEL0yrDFqyDc6yvWfP4T0IPVveY4z7tqGeWhcXrERJap0qsPlXnWmcl9XUUOGX0gMB8RlAiiwN1zQmBANQKtcJj09rd56eUVvQF1wKUAAwj72xsFCQHk+0Ox/SOSc2fXdEN0CWi1yLglcsq7Su66yZD/eHvCcagQUOox3HZLyq/YgUfNM1tuuyeQsmvOVsTJruCaRAio/eZJJIEAZGX1qL58lWMlpQUnW46Du0Bk7K0/uB2Qo/YwWpkBVNC0UatqI1rMOnq50q1r1mjzmSptKZ3DXm/Ucjzukt7iMVeY/bB
 ILDW8tkI
 85djRAY1wyXiaFT+RGDWzN1m1zJc93Q1c++oZU4j5Rgx4OJVLiVlC83QMIZulUJTHl6nZAAf6dp2NT4RIFQWDAsAlnzuSy/qT7nHgUB/PS3vZo6pZHhUan+HFdrcp++tpREGGlMgfusieeu42njSAatg64vpqQdw1S3JFFPMoXkE9xmQi5aAU/uZTOaLRctdv6BphsI/c56YNQrWWNIYVoI5BruQnnjhYQtcLovK993YG5s54ElbsKgB8zq6WRgp6HeA+VzrFuUFM0qWveLjLjiMWsIWh0yoiSQwxku0wIv24sBC6VYLLPd8JTAJikRAsv4LSldF/Ou06rdt/q5NkfCkQ8ZMCUv/R75a59mksIvMm26AnOUrVlYfLeP+MYJT/+BYSNRn9yBrZyhOb2xqr9k16naJ8GMWMdc8Ct88ZA8ic548OhGh0r1gQUz2rkvk0AjPRY1/i1r0uRvNM/02bAXR4RTXasESBTUkRNguWmNPJ/GT+osbm9Xu3IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Justin,

 ---- On Wed, 05 Aug 2026 04:25:25 +0800  Justin Suess <utilityemal77@gmail=
.com> wrote ---=20
 > On Thu, Jul 16, 2026 at 10:31:26PM +0800, Li Chen wrote:
 > > Hi,
 > >=20
 > > This RFC follows feedback on my earlier spawn_template RFC [1]. That
 > > proposal made caching the primary interface; this one starts with gene=
ral
 > > process construction. Christian suggested a pidfd/pidfs exec builder
 > > modeled after fsconfig(), with enough semantics for userspace to imple=
ment
 > > posix_spawn() [2], and Kees agreed [3].
 > >=20
 > > This RFC is based on linux-next next-20260710 and depends on two pidfs
 > > fixes that I sent separately:
 > >=20
 > >   * pidfs: preserve thread pidfds reopened by file handle
 > >     https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.beau=
ty/
 > >   * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
 > >     https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.beau=
ty/
 > >=20
 > > The initial implementation is source-based. The executable path can be
 > > provided with the final run request:
 > >=20
 > >     struct pidfd_spawn_run_args run =3D {
 > >         .path =3D (unsigned long)"/usr/bin/rg",
 > This should probably be an FD for the path.
 >=20
 > This way it prevents race conditions over multiple configuration steps.

Thanks, that makes sense. Using an fd avoids the pathname race and pins
the executable we actually want to run.

 > >         .argv =3D (unsigned long)argv,
 > >         .envp =3D (unsigned long)envp,
 > >     };
 > >=20
 > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
 > >     pidfd_spawn_run(fd, &run, sizeof(run));
 > >=20
 > > Alternatively, the path can be staged before the final run step:
 > >=20
 > >     struct pidfd_spawn_run_args run =3D {
 > >         .argv =3D (unsigned long)argv,
 > >         .envp =3D (unsigned long)envp,
 > >     };
 > >=20
 > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
 > >     pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
 > >                  PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
 > Same here. Should probably be an FD to the binary instead.
 >=20
 > >     pidfd_spawn_run(fd, &run, sizeof(run));
 > I'm worried this pidfd_spawn_run just adds another varient to the existi=
ng
 > myriad of exec* syscalls we already have. Would it be better to just hav=
e this
 > work through execveat(fd, "", argv, envp, AT_EMPTY_PATH) instead?
 >=20
 > (i.e have execveat take a pidfd directly).
 >=20
 > Then you can get rid of pidfd_spawn_run which looks almost structurally
 > identical to execveat (with the argv and envp collapsed).

Thanks, but I'm less sure about using execveat() as the run operation, sinc=
e it
normally replaces the caller while the builder creates a new child and
returns. A separate run operation still seems clearer to me.

Regards,
Li=E2=80=8B



