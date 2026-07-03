Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3AD5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957B46B01AA; Thu,  2 Jul 2026 21:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F9E6B01AB; Thu,  2 Jul 2026 21:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846596B01AE; Thu,  2 Jul 2026 21:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 518856B01AA
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:35:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6CC11C332D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:35:49 +0000 (UTC)
X-FDA: 84945748818.03.616716F
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1462640008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:35:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZdYMkyoS;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783042548;
	b=TThfO37nKdAPMAv5CCaYGkbA16sv80dVYkGIG5fqoHUCNBy1YoRPKkgK0LO+ar1ZadQF8r
	Ekg0TwGp8zIXIHh8zwshzF8ZWYkZys5Mi03FH97l0ojuohhhYp6OPELCXm8mw8Oc39MaBd
	7YqIMf8ji4zI63MRNUum0sXX0etQU1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783042548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kSg3nzeojJtGncTC+IVv65TYIvUH3I5uxPnaBH7ssA=;
	b=6iwOxNw3+cFk09vjd3fDC57oWD/EKkLWk9yi1qrrLmsBfUGgacO9IGV52Sps+8NYn8Mf3L
	M+tfxRLmRjXC40TcCpy2zs3K72RG+0t8/MHCGq3v3q3/jhsApJtRCde0DYbMc9KK2Nkys1
	8eYKN4dSo1UwEr5LKAPdYPbE3lbAxyM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZdYMkyoS;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-847a52edeb2so33995b3a.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 18:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783042547; x=1783647347; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kSg3nzeojJtGncTC+IVv65TYIvUH3I5uxPnaBH7ssA=;
        b=ZdYMkyoS/Z7CwivdeV/W2+0/jQUGF/YIKxpmC0pAquYOKA6mNWSXOH97Lk4mPaXa2Q
         LMQOVdpGOhjdxMY5kTEjkrl/mTw/CITB3IdOU41DLjKHyICkHWsZ/NYP/7JtfC2GBg4Y
         ZvRtkp3UU7m42VEAnR2BgL6n/tHH0NbyGQukHKBiDzwThEN3og8o19jhAWQb6FmP7k16
         ge+rcBOcTS5bn4WATyYbcQpVbWJ/SsgD0MpC6TOOHn8sdvbXVI6v+xsyLSCCM8Kkkj7F
         ILorTS7QosraRs+6Iw+AQLIFyTT/zztFC5rB3u35mePcFdRsLr2AyR8s1fuNZymx4ZtD
         axnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783042547; x=1783647347;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8kSg3nzeojJtGncTC+IVv65TYIvUH3I5uxPnaBH7ssA=;
        b=EDZ7CP6yIr6p2mrMzLg6Hddzf1mhoqFoac85HswyPOtvjP9+NDGLmPfZnJA8Oue5Ex
         zt5GpR46+wmKqnnBBhy8H/cxNuzDcWbd0c2LIuCS7q9ZHTwge4DO5L90DNr7rkI+t0nv
         q0/rj5m4rQJs07OgNO0m4teWdJJ7epYMSPqNkeMo46V9hCUqX/DCKRqfeKcmoYyA9wHM
         7yVWqiXkF+kkPewK4ZBsHycLEWVcOml13i8q/+LHAJRtntKPDh6Nhpbf9uevcfU1uuTO
         XIeGJAmMunjtvxoFlZU1j40GbAlC31FxvQW9w0OOGz20nyn5El9DpHQhrPo/H00Eb6Cq
         Inxg==
X-Forwarded-Encrypted: i=1; AFNElJ/U3MsgeLVxAdpq+q/jqMy8VJfkIxBgpem93j69CAkZiD7IHlcTK38bCPOkQwuex6gLnSj2fvx64Q==@kvack.org
X-Gm-Message-State: AOJu0YxK0eEZRYrSohAoHijO/xQafjiS46DJwbIG6uZpbZo3RxebJdPy
	cGJRwlIx/Ejb4LK4bRao8VC7RxloZ52bbh0yQa6+rd6QZzI5MictFGiH
X-Gm-Gg: AfdE7cmiEaLb6h8zb/NCthUWY84h3Z99v54mkzMamunulCo18+2mQkMz34K29S57JhB
	iAq9irl4KcLmOOjo1da+eqhFnWsNyqfCN8iHJZugWNpk8xgMiSa5ehgqbhSE5tiCH9QorOuUi9L
	FpEwpd1J6Na1oKvlQ8+6acYY9OY9AEoOp4U49rq2kAkFVYT6Qjwsurmin5k8f7XlEaWb2IusG9C
	tYaj3IC5IOJMpvlqYbljltdm228vpRw6fOH9ksWFRkIjHwP+XILx9CCjZZ9HbUuKeWXSyrjlkYW
	AfScb3EtDjJVcKOL6qlDN4sJ3A1KF8gN7J2vKVZSbY2NkHrhEvzXTj6Ln9GAQfQl8sccH3jlkJj
	di/7ndr2Kulky3G7smFQmpsHmFkgxex+AedRbvk3k2t88x6QTmpZBWaK6O3cyl5vdy4dzwSI=
X-Received: by 2002:a05:6a20:94cf:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3bfed47e012mr9720045637.46.1783042546577;
        Thu, 02 Jul 2026 18:35:46 -0700 (PDT)
Received: from smtpclient.apple ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0b813cd9sm13515735eec.8.2026.07.02.18.35.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jul 2026 18:35:46 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split
 actions
From: wang lian <lianux.mm@gmail.com>
In-Reply-To: <akY6ZzPnwk-CToMp@lucifer>
Date: Fri, 3 Jul 2026 09:35:28 +0800
Cc: sj@kernel.org,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 daichaobing@sangfor.com.cn,
 kunwu.chan@gmail.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7759CC5-6A63-4A48-B7A6-648742A5BC12@gmail.com>
References: <20260702094633.75658-1-lianux.mm@gmail.com>
 <akY6ZzPnwk-CToMp@lucifer>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1462640008
X-Stat-Signature: 7pxmdnqdspzhw7erozaebgnkzr46pji5
X-HE-Tag: 1783042547-51376
X-HE-Meta: U2FsdGVkX19mFhz4faUt+oEf/lV5GpnOvuQIuV/7Ixupm4zxO5WEFsQUiih41wcotjHgMAFA0Uy6k2vn2qGrPLELjZYlOBqHsZHJ6UD+IiUcdRzMX2gWtk5wZNQY3VMCz8TlBVFtxvPoBR63dE0y+QRFfHJctlW9zvmfeQDI0s7u1IsvQK5wXmUQJBHm4k9YP4yJRfl3ZXnIZcd9BQ/F+2ePrAxI+L2aLIYCbBJSJZZ+9EVb1Ix2jKIftTEhnqnY+hKWRAyMVzhu1RQNPl0lsZ8f3aqFZ2DKfZnh+e4/ffpJmtfSeQsavBNcwxdUUhrv5CWktzjKc2YzNyUQJbtj0FroU1OEuVm+oV9YyhGysg7+EdgVSYfJ/3RD3GzbaPbYDXnfw/7M3lzed6M93c5pm5V84s3pUKm1szKMUtX3QZnCNjupJ+XRLbf+7U+J0/vCzCFzqZsUxkrgw3j6Ay2uecSOD2nnvB7eUoVt4LnVfhUx/nt/0zK0bKE5KT+DYBkAFPKnobkw3XX1Rlt8f/PIwt/n8MmxEYF4bN3kcCPh2OTKGiIzBHDB0J8yIVFyFylqVZINBqDNN3tJRV4XBG4Gpx5gdS2VzIO5+olW4jbVerTKeEywSRLw28WaVNke7C7JPZv2J5aBqk2PeiW41SJCzARkVHsM8Ivoe5qK/Ns9pQlOASiEhDw04SVTTu42sxJ2bOwCNtPb278VmSO/BlshSpOXth4fl7cROl3Diz6XF+djxl/MqwP2gn4dHP2NTyfTr9v4Aemh43SGUUizU9ZLUfPU4ReE9fhz7qWVZmlCSqekJ7p9zPlTi/5WJCnvOrTDHymfan7PWxy4zAdu9y4eOL9NOLENDacBn1X8cGJgPFb3G2VN1Ui2GoAF0acRLLEv4sFIU2ULzxiy91ut6xtP+X1Uxbb6egzaUFgYvzzEpTql3srpSJczS2dy2mSt1H6LKVzf2oBESSc/VtSYWt8
 P7DvnVZ8
 U1WMDBxMNtuk84Fm+PdS933/wawxNGkNILUnE15mcEZwnQbYSgMS0kC5gwJVqQvJr5m+zVPQ1FKH8B6IPoiKroB5Cy4lR4WQqhR12miuy3mt1oCJL6xYc+3ww5JzUfmqeJFl3dbNT/tY+sDA4cePD2bwHqTwp1r+VWplkz+GKLPQcu6jqdHyJjnPuj9+uU94Cc5uH4F7TpdOPlfwyI06PSylFGL/5vfzHkPOfgt1NAVXQISQdlIEFjC9yixfzaJ6yk0k+Y1XoMGHBWww3EsbfL/4T3NlT791wgkZUamsd2P6QUTJ06ZNLRA+d+S6dWI5PiZpnkHCdL0QYt/9e+O6makB9/DulhYpls24Ot6yf7HA5edl93ogqq+/x9HSqHhJvKG4+AJ2s79HOomsdq3kxubiETrtBT/IdguyGM9tSQYYFLRxku1Lvn1LO8Fh3EnXndTSUMIgTK8JCZlgDU/Cn8I+V5qmHghMqMn70yFsvYd6/tFWhGqI+RSQj01bWZ5r43QsBUxFZXYFho6qKZbRG8FkMdCEUIgyT7vGU3tcDNPHVzjfSaX50IOoXaY4nJlfjJ772P/AIlRq6Ii9/lN4fWYKCjvF92bk/1AXPie+1zLzFhOs4EoAGfhshO+/poxPTEwrcCsxxON+d1u6RWFfMoYjg5dklIx9sdMDLgPuBzibPUOys1/vV4iK4PZUyBADtaIdUezhyf2W+VX2wgrVkuWCW9g1JdOk8RE7U0l53JhGXM3ZSVc14zihy8qAmUZQ1b4L4XroooTqnJiCtN3muunB/POk5Vl10LNnYkAfKcH6VARMWCGlELkaT+ycyKwz8JkZ+bSMb8cpmOnzJ9LgigmLCNZTYDcPjmbOOAuOBzNdjvuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

> On Jul 2, 2026, at 18:23, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> +cc all those you missed.
>=20
> I really need to write a bot to do this, because I'm getting a little =
tired of
> pointing this out :))
>=20
> On Thu, Jul 02, 2026 at 05:46:28PM +0800, Lian Wang wrote:
>> include/linux/damon.h      |  10 +++
>> include/linux/khugepaged.h |   9 +++
>> mm/damon/core.c            |   2 +
>> mm/damon/sysfs-schemes.c   |  77 ++++++++++++++++++++++
>> mm/damon/vaddr.c           | 128 =
+++++++++++++++++++++++++++++++++++++
>> mm/khugepaged.c            |  46 +++++++++++++
>> 6 files changed, 272 insertions(+)
>=20
> You are doing damon changes, and that belongs to SJ, sure.
>=20
> But you're also changing core THP code? Please ensure you cc- THP =
people because
> without our approval this cannot be merged:
>=20
> $ scripts/get_maintainer.pl =
20260702094633.75658-1-lianux.mm@gmail.com.mbx
> SJ Park <sj@kernel.org> (maintainer:DAMON)
> Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY =
MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - =
THP (TRANSPARENT HUGE PAGE))
> Lorenzo Stoakes <ljs@kernel.org> (maintainer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> Zi Yan <ziy@nvidia.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT =
HUGE PAGE))
> Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:MEMORY =
MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> "Liam R. Howlett" <liam@infradead.org> (reviewer:MEMORY MANAGEMENT - =
THP (TRANSPARENT HUGE PAGE))
> Nico Pache <npache@redhat.com> (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> Ryan Roberts <ryan.roberts@arm.com> (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> Dev Jain <dev.jain@arm.com> (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> Barry Song <baohua@kernel.org> (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> Lance Yang <lance.yang@linux.dev> (reviewer:MEMORY MANAGEMENT - THP =
(TRANSPARENT HUGE PAGE))
> damon@lists.linux.dev (open list:DAMON)
> linux-mm@kvack.org (open list:DAMON)
> linux-kernel@vger.kernel.org (open list)
>=20
>>=20
>> --
>> 2.50.1 (Apple Git-155)
>>=20
>=20
Thank you for pointing this out again, and I deeply appreciate
all the tedious work you do as a maintainer to keep the mailing
lists aligned.

As a newcomer trying to transition into complex feature
development, I must admit my initial design is far from perfect.
I leveraged AI tools to assist with certain implementation
paths, and although I extensively self-reviewed, tested, and
reasoned through every single line of code, your and SJ's
feedback clearly shows there are still major architectural
flaws.  Just like my very first kernel patch -- which was
strictly reviewed and guided by you and David H. -- I know that
your sharp feedback is exactly what will help me grow as a
kernel engineer.

I will completely step back and radically rethink the design of
this series, especially regarding the cross-subsystem
encapsulation and locking hazards.

As for that bot you mentioned getting tired of running manually
-- let me write it for you.  An imperfect newcomer who just made
these exact mistakes knows precisely where the traps are.  I can
craft a pre-flight patch check script or a CI bot that
automatically validates the get_maintainer.pl output against the
patch file diffstat before any email is dispatched, throwing a
loud warning if core MM files are touched but their respective
maintainers are missing from the CC line.

What do you think?  I would love to build this tool to save your
and other maintainers' valuable time in the future.

Thanks again for steering me in the right direction!

Best regards,
Wang Lian
> Thanks, Lorenzo


