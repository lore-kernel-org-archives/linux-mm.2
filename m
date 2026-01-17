Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77421D4A5F5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 04:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D576B0005; Fri, 16 Jan 2026 23:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CABA6B0088; Fri, 16 Jan 2026 23:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC796B0089; Fri, 16 Jan 2026 23:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69DFA6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:22:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF875C1838
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:22:23 +0000 (UTC)
X-FDA: 84340158966.01.6B064AF
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id A90EA20004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:22:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zfw6OcYI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768623741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwwVufJSXMMpg8wn2EK6222WS/5UWaw2HgzMNQzZXZI=;
	b=zKvqY0GcDbXPz377UzmAqcdiDppYQodQOxEvKs6XzpY45fp6mbemWS0aCWTV3XJw/8GbY0
	omprW1+JLIu9/anK/daGHRVHaq5xKomsT2puAL5rGlgTQr0WqrQoFWeHVJB3RI1Ef5n+f+
	sWo9hGmY5tY4SIuaTf8bcs6FfNkZNg8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zfw6OcYI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768623741; a=rsa-sha256;
	cv=pass;
	b=1pABZwwcKIlUMDKnkMNbvLVbMvAB7zZSk/luwSzqxKxd68cSe1cwyWKozgc3aNp/aDnrh5
	mmdeVleSMXQiD/1h54De63Z3f3w9njHIFQGhWu+4VYAZ9bqgSHuMhdvhRolJ4kvJi2sCw2
	U5B8Ov2nov13zVSnVpuhCoOg0XijYYI=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-382fb535b73so23484011fa.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768623740; cv=none;
        d=google.com; s=arc-20240605;
        b=jlgqe+yfszW5dWMdmfzSt9dPxKDW0oedoXbgS1dw+GCcrwG0EN/W/+52EbOLJcsclE
         5JdE2jEh2Zur36SKSBGEAbjytINKw8Q4HrfHmzipIevHCdZnWEeimveb2zGb+v17bZ/E
         0QRMQJPOIXEvMXjtBuNpMtv4IGUDPzu9VtH/dYMX8iXpyNNG2QcmL83OpjkAh8cDb7Nu
         /BNVzwCPSQz+/yIrEX46H0ha8TntLWH05XVQHUap+fRGjV96ptrgQkfq6dz2FksLvQLK
         skv4JBbQgLbzzBVtJ1dk+HMde3wiy7P1iZTFJL56pa29q6bK6DajiloYUpzRJauZbaMp
         8yGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dwwVufJSXMMpg8wn2EK6222WS/5UWaw2HgzMNQzZXZI=;
        fh=x9Sn1BPZL4XR1a4xrfVfTQMUULNq4uAmXcze94TMeMI=;
        b=ZKqWNIGhQip45oZtsk/KkgZIRfv88ADE7mgW4euVT7W+2Gvu85PwR+JDT2iAZw1qox
         8JuxKMiUvC48tNdtl9skEqooY2g+/dbZJP3jemRkmqneCxnjOJ0q70PQY/xIn3iVxKlO
         n+NMzCrRpXPDEjTmygvoTCWB4JYWAc9veo8VSNmgrXlvH/If/YfbKHRYsc0wnO9mhjO0
         6O4h82nxtYYcOy+hhoo5wr8ze1mCP1WczyxTRCxnKQfmC/FXN0FUvsb8c7d0fz9J/Eyt
         tklgAfYOPkFXyBQxlKOq8nyCCcbEOwPs0aBFZ1Ny3Qxw7JJs7lSBDHS/Cml92J7z0bI+
         h0Jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768623740; x=1769228540; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwwVufJSXMMpg8wn2EK6222WS/5UWaw2HgzMNQzZXZI=;
        b=Zfw6OcYIIbtELiQ6DOp0tMbIoyAL8cSPjIOT1n7uNoou6pgsfSo131ekKFsGtZ9nPu
         lzaaxSM8ETAp9amcMK7hj+4gZ/qsc6q6w/r2X5EL7hGl0iAAGra6PCv5t8EW/hZmHVkW
         STsTBtkCIs5sxk0NHAcqWakxHxezDU4unViMEBeeocnQSijMEdr7VwL5934C8WHSPwmf
         xeZYUridkIiRQppsXQLwI2Eh6T05g2dOFPutc0j67fbZk/g9+HAKI7O03FmA3Mr2O7La
         pw7PneLpZCpHmw4ZJa3fFLfDKBRvJ40bGAMa+vZ5VieBzw6MNDsB+Zsc0Sc4MW2Usd09
         Xsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768623740; x=1769228540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dwwVufJSXMMpg8wn2EK6222WS/5UWaw2HgzMNQzZXZI=;
        b=E0+18tVracaYSsOgiSfeZHF21UWT2zblDCNNsdY9IDcRY4Wsaq0D+T9L+A0dsLGUZN
         6jKjk2K2J/XalFgcQG+dCIfGn965qIZNlxt+Mc64CFvM/M9FuHBfQ5rzr9e8k90XUQ4J
         E0Qa5rT+EZZxDnE++Ej+bmCwOwiptC38oh7wtBNfm+QuBSUO3wJiJ7eRbi7JySsnYBup
         PIPk6Bn+uVMw04y8WusOY21CU51nlYCTG3qEw6t51aBIuqqydhvxcn+BE+x/6EcNvZ2s
         TReEv6hEiY29iNmcBBHfP3h87nEHRWpQCkzLJQHj6jv1iaDe2u6nW/xMqHhTJvhEnGfc
         sp2g==
X-Forwarded-Encrypted: i=1; AJvYcCUhScWyvXJe8IXx4D71+/EhZqohDYrX15HSXn6D9RHKeISZmkdzeDAI64MhcNVSdukRRXiVv4aT+A==@kvack.org
X-Gm-Message-State: AOJu0YxGRD8DzkOomTW1yeC1FuOiaOC+cswxLhR30nv0L+jofNiCjJra
	pXYpVbaV8eAKd67RkZwjrU4IpQKGAzXjoYzxNY1GPQ3k2oSqDALdnOrduGm52Zg8zDcMo82JYgr
	ZZqm6GYvIxpOek0QeHUSYQ/XgAza9khs=
X-Gm-Gg: AY/fxX6/uzeg85DiRlHRk1MmjxHPHp/peaVGqOox7Xij+xgueQuEezXtnmgMk5yc8KJ
	DZ76Jruo6jLYjwmXbQWzF99WizSk0HIDcP2JgtZcD7cexys53kZvCYJ+8+XTmPO6ipDbQzsLGkt
	j4ukyOk/pbZhL/HlCfxF2jnRsDCYlG4qJk9jzb8NuAykoOJf9e8iZhJq1p9HFOPi5mGLFMsGGIo
	9olPRtou5NqjFPY29HvsfSCkhTvBEOq0bqPLUtr7pWMZmXo/NMKtnuSzoqsK0+a5VyjENMkWFYO
	QOEI9w==
X-Received: by 2002:a05:651c:a10:b0:37e:862d:6b91 with SMTP id
 38308e7fff4ca-38384170802mr16400841fa.3.1768623739449; Fri, 16 Jan 2026
 20:22:19 -0800 (PST)
MIME-Version: 1.0
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-5-yanglincheng@kylinos.cn> <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
 <40381c7e-3f0a-4459-a287-4e098e9a4b13@kernel.org>
In-Reply-To: <40381c7e-3f0a-4459-a287-4e098e9a4b13@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sat, 17 Jan 2026 12:22:08 +0800
X-Gm-Features: AZwV_QhBPEpHN91ahDpuB62qJjqy_0noBeTZv2eMCVqHw7yajr33OufMeszFUI0
Message-ID: <CACZaFFOZBgdxefH0x2_=U=Ds7yFqcr7DiJM1MHS_73Wrr6jc7w@mail.gmail.com>
Subject: Re: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	akpm@linux-foundation.org, dev.jain@arm.com, baohua@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4p7z78o73tj8h8tw8rtu33o4opmi7ts7
X-Rspamd-Queue-Id: A90EA20004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768623741-889909
X-HE-Meta: U2FsdGVkX198h4RbSIucSUQKqUiiRnBh59688OKYKel9kdJDOUnB/CTde74dEuv6pU6U7wwFRqt4wI8RQx5pE86rXSz5Dw+aupAa3xZwtD/dNqeOIIIjyb72/1bRN5JUm9+NAB/2/I1PkRsNLfqB5ERXqZXQ3JDyC3qRRLMpwVQfUnHYKAX6864pHamBn2GNn9LT5ebXA2Ea6cjdNYo0SL2zSenssG273B0lZ81sm9NaoHb70yC/2RaIwo83+t28GaUDpHvWifktFzQfT8Dknc/o1lYzzo+GdWNvhhuXUL05NGYDhLVZvmWKzNah/kY1mBdevGNoMRVWxTxY1/gaQ57jaEIgN7HJSwJ0wYaOnu8hgITELJE5vTfyrr3kpfyIaq8suSX7+yMX+DXKggVOVg9b+hMtmcQsDrOKioBbZvyD2WvEwLAr36ijFqUVjHxQbWePABFlbvd6jnw7mzwI2VlTkiams/zDaOv6tpZFm/c+1C6QVLpe2OoN668blZDbsvkBldkTnbl6CjFidwklhc1rx1dJC7niQTD4I/0L6ggaVtmNv0mO/NE9XPnsZM4c801zOYHBoL13epKLhrs8MDmxuqFaN62cZshryIvnkIAdDvjqWSGKeEXFbvvkvQ4msKATiUxZT4V+SL1xOjQHw8sDEdRXMEIIt4WDUTiD7sZilrZNO/6tW+pFsWcnBvqL6XFzxRTJtWXmlmTejetT1OG3dlVnpTdKPUvfbueS4TnDLj9S8NGlrYZ4daImbBY7w4UZiPsS/DqCwGzw630oW6U4HAbZsqa2zzn17FvJgf6rodFrIVwS9tXkfg17nFl8CwzH+ojYQ6ibIZLolq3lEgJxRcumh2YZfQUBOb07UhSMUaka7OAI2Lf0qN7sJ02npgJ629IlbB6kjiNIwUb7Pi/fmj9HMcS5dZ6UQbot4bkCHLvos+5xgX8M7oVsyAhmfUGnzFYlH0m+uvyz1PX
 13XYiSdo
 vunKxZRogy/bZZ2Cn31bCnMe/ZTOgmIrCMVoRqSQPU0+fQHM83GOz1AvOW97rB26ZHwaHlSHmlO4p8jNwI6b1X+m2sN3M3YEWqMFEfZFpafd/jJb0MOCR2pQ7KKu8YTYzaZ7eRpd10agAEd0VpW2jXFsrVHzKP1afML0t+Dvyul6cyj4HBUKQKAvWSj9Yfdh1R9mKIvPZObv9vdNUcK3F53ehXuRgnUn61UcgPw5pm/usXEfjrj5IgI3bL2S2lu4Pczt+21ixmWrTmseD8fs5W/yhblCQRfgxV6lTME2WSVzApnq1wpV2mic7OIaPdw560Lj02CvLtcxCPFsRJ+F1OsrluTWltbwnk6GqTjdt8zxPK/Le/c4Zw0ov6Cg2MrBz8P348oMPlpV1NqUsDaKaFZYR55hjJqI917TP7F5Jav628Hf5r/G03TJeYOule8eslPJ+kAG2XxNy9SmDv3C3jHn8wUH81D3j95rrs1Ule/MDyeB1OSJTrWJq6fvTbz4pA+M+LPesHDKr5up9pg37onJBSTrxirqBCqX2unpAmCH6yiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:45=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/11/26 14:41, Lance Yang wrote:
> >
> >
> > On 2026/1/11 20:19, Vernon Yang wrote:
> >> Add folio_is_lazyfree() function to identify lazy-free folios to impro=
ve
> >> code readability.
> >>
> >> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >> ---
> >>    include/linux/mm_inline.h | 5 +++++
> >>    mm/rmap.c                 | 2 +-
> >>    mm/vmscan.c               | 5 ++---
> >>    3 files changed, 8 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> >> index fa2d6ba811b5..65a4ae52d915 100644
> >> --- a/include/linux/mm_inline.h
> >> +++ b/include/linux/mm_inline.h
> >> @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *pag=
e)
> >>      return folio_is_file_lru(page_folio(page));
> >>    }
> >>
> >> +static inline int folio_is_lazyfree(const struct folio *folio)
> >> +{
> >
> > It's 2026, could we use bool instead of int?
> >
> > Yeah, I see folio_is_file_lru() uses int but that's legacy ...
>
> Right, and why not call the function folio_test_lazyfree() and move it
> to page-flags.h?

LGTM, I will do it in the next version.

