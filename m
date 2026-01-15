Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02862D46634
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E0E6B00A9; Thu, 15 Jan 2026 17:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BB16B00AA; Thu, 15 Jan 2026 17:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403DE6B00AB; Thu, 15 Jan 2026 17:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA786B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:56:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE782590BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:56:39 +0000 (UTC)
X-FDA: 84335709318.04.20ADB03
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDED21C0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:56:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CiHK+jgP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768517797; a=rsa-sha256;
	cv=pass;
	b=HIkrX0Yi39Gbafq7Iv/DwFT7dzO6plCqoD+PHo885XDp1GNEzR6QB8+AL2fPdvPUZ0yWKN
	uYcdDy4fvQjFr5SJt0oCsTfGAqjRDaM+4MlRriS1M29SweIjJ8zYUsp+7sYSSDyi4zwLZE
	hWnzaTC3mPq9XyNv8jIH+ftQfVvzjPc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CiHK+jgP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768517797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEdoa0LzyB5ZZeQkVWbziVQYsbxYPnLCNu+lRAWmgEk=;
	b=0uQoGvuaakn5HusAU+yR4orGhyOz/bVoF42YTMr3hcyRQcBe3Pw572o03GwjCx6MGvOF13
	geibAbLANiJwxc4ooJ24eFrJk67s/5OxA55iw6MJxXttujQaFaBfa0h1K9DsZgfiLjQMKx
	l5gdglGeUb333H6YJrq1XEBXywxHM1c=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014acad6f2so81111cf.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:56:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768517797; cv=none;
        d=google.com; s=arc-20240605;
        b=kCXcNMknE0Qg2igt1VND9lhimjzu9tfvuq2A1xyCvQCem/0J0UqOvponG8/tiKg08N
         l0h8u1w5BV9mgKmc5TyGIGQeVGmKd/XxJmMDFSmPu46aqLqbo7uEhJjDFu1IjUyPGJqQ
         5Q5LwtLRrwYYP3Zot1zJhNmSytxNxno7Ep/r6HBzMYQjBgqSOzsfJKcK31Z1nGzpMkqD
         Zvpu/cR021g+kK3EXq3iRYy9Fm31OEf7WXtTcXkq9ABWvrfyZa6O4JOaFU1sSPsv403B
         BaeTXTlbqqRWPvxVfpZXDmWiguXn4A5IcRYAIA7o8b5SqCN3ZhUAZelji7lq4cFw/7ss
         IpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WEdoa0LzyB5ZZeQkVWbziVQYsbxYPnLCNu+lRAWmgEk=;
        fh=vel1VeeU5H73hcw3rgJ0WtZB2HfKZ/znS8E1KSUDbCw=;
        b=aPiJ+hMjGw/H+u1fWpqiPlCSApBzczoJI9MO3aKXK4wpYTd3PorvDNi/y3UcslSxV3
         BP7f9tdjKBC0z80zQsS9i1CfJ7/OofBPTBSq+GaGG8KXxxsVT+Bygy4iFlWmIiRi8T+S
         MtDJR1uTwIQfl09Zz4ko1yEowpy1aPoza7fZMHKNr/bszu1ILHfo9knl7m6oWSVsnzzE
         wBvgOWgZcaNsq4khWKRI+5LvdiVzYWo7haILeNPBAQJ10rAcet3ACopHb8MuF/mEUWN3
         oeGU398zEBOQ2zK392YuiwpR4bup5HgPrNzWXeAcPb6gVhQZlZlzWMLyfIPM7I8s1k2+
         iamA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768517797; x=1769122597; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WEdoa0LzyB5ZZeQkVWbziVQYsbxYPnLCNu+lRAWmgEk=;
        b=CiHK+jgPaD6ik843sN4BtBtRiAfScmwcXK6HY7xDOl9bJomV0h0hZk82GVqxCsFEV5
         9Dgwo8See0yuOnHehhOxLHvYbczF3G4XEmwiF4Y7S4as61vyX3gb4NHo72m/3PSm86T8
         C11mgZd1A9j9uYTJrZbM1sdXXn4VKbBrUDdkU49WlJlLnXod7TVB5Ke+AsZiExCYNLoi
         on7nYobah6iDyEsn0P+mrD37m4JCeGIKQv2tCkcOAVmg2pBLy6wPYGKR8ZgA8iBcLiMV
         i2n/Lp6lsCO45X+JkGNFF157+CMxiBt+bTOU1dKfhUe6GmmmdnQisi0YaPh0EQVeRgUd
         HZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768517797; x=1769122597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WEdoa0LzyB5ZZeQkVWbziVQYsbxYPnLCNu+lRAWmgEk=;
        b=Gr/m9MoxpcS+2ZubzAbWhLwArKYlleiMi1aK7DQxhj5zwQYVBE8tVUgvlfSPWMhXB2
         BE77MdCs3g/jlRW/EQCcHG1fzwPNt4olTEAWd5nwjEYg3N95juE9UxO2tWwMqkQblrpn
         ww+C//j2w3Anwv5hOqVjHVhPjL+NeZE2oSeKITnKHRwCT+DhabE9DbwXjXLF3upWHmhs
         3rB0IW1t+eskOr1p717Xw2qOHTn4sD4MX91d7wgbIEh5OWY3H6oS9OXD6iABS2octARc
         UKvnSMe9Yfmmfd1zJs7Fl5zNhgvQLnTzAasaIJjB7NSqb/6c+Rc9RSwePHYEbh31jz92
         jPuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWexQkkJmKKfaKNM6OL5Nze2MCQtihnjkCtt7YcgM/6Xo8oxmD2g8QajAQYHwys4RSmwZHRqiaj8w==@kvack.org
X-Gm-Message-State: AOJu0Yyl1VbvBO8v/t5h5pgLKOlMhaEL9/qv25SHAdoWufRGnGZ2H/5o
	RiSUdMOnah0ixONRAnXmzGNd4WJYdj9NmbXmPRVNBt2mW4pYYXGamusvYq56s2nj00lgK6oTGij
	QW9iMiiwAjUQiThlLpE7e3zbzdA/O/xXo8ARZ4/Bp
X-Gm-Gg: AY/fxX56G8TD3hFvb4PA74YIbg6pNyOv4wU8O3wlL8k4uxQq3+3O/tkpPCHzgq0dpu9
	CZ3GdcHw+I8lVtzluknCDGICRlPM74JNbAyh0S4OBszKpoAqJ9+kCpyzR9ToPZzLE5QE9f3FM8/
	tQWUtqh727ZrTNGwMMUe1KxTIBTB1cAQmXHlZCvUSfRg0YojAcIqFGViPad3rVy2abwe/4G0oK4
	kzNWDLWJwSe3xRHQp38HLXqT57F/LI0ZOwEZhqowlZwSFcFe61SUg8elO6qKl9hkAg7UA==
X-Received: by 2002:ac8:57cc:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-502a20d18b8mr3289171cf.0.1768517796737; Thu, 15 Jan 2026
 14:56:36 -0800 (PST)
MIME-Version: 1.0
References: <20260115031536.164254-1-ranxiaokai627@163.com>
 <20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org>
 <CAJuCfpEFZNwmpwfUqM45StJKPZG3s+qZpv8Vy2ohF6StsL4LGg@mail.gmail.com> <20260115141222.2fd0f636c1f480a664d583a4@linux-foundation.org>
In-Reply-To: <20260115141222.2fd0f636c1f480a664d583a4@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 15 Jan 2026 14:56:25 -0800
X-Gm-Features: AZwV_Qgmsd2-pG6um5t8L9I0aP1wHK2PcZR9kHpHQPrJIkmpu4WFAuUypUGDOfk
Message-ID: <CAJuCfpGZVrFZnBp=gO5kLY-Ky0jZE=L5Kv-qv2gW3FeQTt0s9g@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix rw permission issue when handling boot parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ranxiaokai627@163.com, kent.overstreet@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CDED21C0009
X-Stat-Signature: 15ewdnnj648cirb1w5hf9aisipj187kw
X-Rspam-User: 
X-HE-Tag: 1768517797-169595
X-HE-Meta: U2FsdGVkX18Nn+sAh0+O+G7XomrADl2m25Ho1mMqyRtjxW1xLMSsMGL4z6wgspmeNy7sZimxIxftnChTT4Zz0m/l4BU7bJ2iIRQev1TrC2AA5DDcIO2EZZDQI32YxDreNMjz3vYUPrBZTR5q6cLaxrBV2sP+j0TmztsWd2cSxIwBFb2r96O+s0nKQxvuIo5ZFkkgeM/CvWKgRWqCMuSQ8cM1kZJ+JA1H+L68L2y+4cOACMVFOhupCDGXkablq878iDiiTaKsl4fw//Ehnx3Su/2u8HnvVWlZgWD5QiKiDg0o2ibh0z5RX1BK/77orpsrBLpKxls/YOFY8kREOYKlbjY5cjLX0LjqMcuOhrWg7JOZXbprfM0Sc+UjHfMMP5+hOb5IrlUEG3YsYQlUfCMt9PMZJlQ5ByeehJUvGOV5Tq/55MbVr6Uorl6qkME65YE3jxrD2vI8EGxuIiDmlFBNlP60sZvmUllzyYII0MAHSJdJquccedPPEAbHrnu4efesI/94RC5xDYHQJ0ADRIerXHU8BzOidfpJvrfhmchbxhCHaBIWk3Gz0aRgInK9kMUzl4NXzdDz9VYyatfiCyzGTVRpEHVomrO+Tr5QgRjX2y6lt3GdfeAUQMHY95MrLUiOQiN4Cw/XWGQgsFeGd7naG1Ntu4Y26/PsJkFEsS+2P3r9V3AzYDvBbCE+brIj6kz1f+/+HdDn2erjhPQJgzMm9zfJZBX1XePdWRKICSokfWxuT6R74eeCZ3BGn744u4hjw7/0n2fYVs9WSIHoQm+kFOrNtKp7Hh1vWRRsPc1Qhmn8nxstYBiggUxTTDaUHMknbcKnG6UxW9fOerXS3CgmEH279i49ZC1YwkIzHG0dNqXeC37fT/1AUwrDNvK5+FAPbjMJz7vuvt/yYcYoffBlkqVj4FvdxgvKsJ57wt3vg1YQ+/wYn1JvgSqMJq34FWbzIV+8sTv2/0Pn+kyQcFW
 CfXTQQD0
 ts/e77T0kuLnZKqmkBzkix5+IG9BD+VtmqlXLjNF+pIAKLWDNmWOB4X8C9OpK1F9ekjNFmbywkRHdSqvj1or52oHDk63LmMKmLdDEcpE5dV4msS85kI+QeXzzx5beIJVQmJJWfmQnpS534G0uCPyCXmFSqloDimCKWSCGt5GLnjqPl55FVdh0mHlIrG5lccBpPLt5+GrYA1fDRZfuzSdJ4FYqZLa/EXSN2T8uey4EuvV63gDVBY5SOkeApBjDJyXWABb2KiA7o9iuKOEecOjLhYpeaFwQnHs7uGR6qSIlLyzDqHnrIQoWxdSZ1nRpuhOjo+9UHNk0KAsNteJs95SnZhMcIHv/UiQjewgmq0/CDIwjpkpHHAhmgZt2szkIfn/FzkfLtqD0M2sIcY2+yGUFxqd+nTvbSfne8V+DVSTjH2yXHuZ+5jf+uiVxFlUTgQk/hps9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 2:12=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 14 Jan 2026 20:58:52 -0800 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > > > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > > > Acked-by: Suren Baghdasaryan <surenb@google.com>
> > > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > Should we backport it?
> >
> > I'm not sure a single boot time warning produced only in debug mode
> > warrants backporting. Do you think we should do it anyway?
>
> Not if you don't ;)  Just checking...

The code around this recently changed and the patch will have to be
backported. I'm still happy to do that if someone asks for it but I
don't think it's critical enough to be proactive :)

