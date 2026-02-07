Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DAABEE0AE8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693846B008A; Sat,  7 Feb 2026 17:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6412A6B0092; Sat,  7 Feb 2026 17:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523146B0093; Sat,  7 Feb 2026 17:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E17A6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:31:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D32FDC1DD5
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:31:54 +0000 (UTC)
X-FDA: 84419109348.14.EB61582
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0909A0004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:31:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnOoDnuN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770503512; a=rsa-sha256;
	cv=pass;
	b=JxG6Jzk/ascnNQp4wp9VLZNg0BOsGR3UBxCa87loxOXzvmcSa46h1nQ2vPux+T9Wo0QF45
	feW7vZFErfWJWbEgwYB6qeI5Z9ynsPnZ9qS1C56t+G/2rr26mZjbBDuE1U93MsQSsE45rJ
	Qxe3mLp1A61miHJ92agFmO5lnUJO1e8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnOoDnuN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770503512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGG3Tmu1N1oqV02HmaCAabr0AkA0/RFT9l301VCDKNg=;
	b=UpHh/KkrfAj+wp2uUJypkZaDtppQPQ4FdcrgeUCmM0uMpCf3yimjT5vwrQIyZN2HcEwyQb
	AHilB0Fkm0g6lcSZlGVyxvoJnO0NszCDvIgp3FPfO+Ze8iqoFWHHWO/hWcuHE7kyp09VxA
	IAggTCZWgBMYxD39EHvlDfXzaZyAzpE=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-894674a4c4aso31648326d6.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 14:31:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770503512; cv=none;
        d=google.com; s=arc-20240605;
        b=cIOsS62KEsr2wKcIfrRCDHKl8ZdFmhxBJRxSoNpQsobjH33BjcfB8d5Jn5wcUOmQxe
         LlwOWgbF89j8IMt2p7luKkPMC7PUuijSF0b23SH2o2lhiBSXJ+hMLThg/k56lpYYf/mB
         f1CKGvJlVbEjQBGI3PQc+27l0/CS36obF6BQflPqEdAbWKs7HTLBQbpn5Zhcg8gfo1PX
         87UYEEQHw6+GeVo36rgtwU8MXcQM6Ewx8dPPHnjMcf3gABWoBDHmKLYaxX+QGHJQiWr3
         dT3GsenAwVgkkHsEmdwWr8Wluw8KMaK640WdIRktGDSiKyUOLF+D4KAP1wzGFzUI/s1x
         j1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PGG3Tmu1N1oqV02HmaCAabr0AkA0/RFT9l301VCDKNg=;
        fh=dg7fwzb1Js4s+WPyjue+PS+oUZ3L0ZU8T4j8onD165c=;
        b=b4jn4ByDZjrDmIH9jbI/cUzBFu6Mxex619kntzFv6t/ibDoXo5InWTZh2jW9hYTdmg
         GZwfcJaF8EQcXGs+IHVpSM08QLyvM+FCYs3uXArkOxU38JWcL3iEtXqSZtBbghgxUgPj
         eWH3H8mWCK7UWSUD/ODFWbKNcBGAfsyCSpCsKqRfSgSymS9uGzXykmXSKXeNRMHswPAc
         MN/51dEuvseZrwPraNEb9X9tq9C/gfTBlDpFimjc6w/h4LY9YS5PSkj5P9iDkauYu0lP
         YyPPIchdh4dkq8FIfKd71/rTwdeONI0oGDXC82y9CkkHRth1ePMhxn2gmFH8y5L8ql/a
         ekxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770503512; x=1771108312; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGG3Tmu1N1oqV02HmaCAabr0AkA0/RFT9l301VCDKNg=;
        b=LnOoDnuN6eUUwVzP3Q/Z7znTYBdbzoKrB/80/EhcSV4UruFp5ub/XmmojZeHc0vI6Y
         hRTPKXjQlnOYyEKzoZhg4NBdFnGGUqx1xW30QyQ5RXnUSSkPK2h5jYbvtDuN/8FqQWl8
         42ZjJVE+yn248sv97QlIBskN9SlHNdzlxi46t3+olwLtHYr4twRHulaY1AAH6l0jUuNo
         KaUngNW+LZTIbAZ1ykvOCY3Day3cEz8fRRY+hZ63heQBgY82USyTONSRBB/VFne624+3
         wLG8DnRh1Tt248NeyDR4LdEKG2OSCMasficsGJ8cDPBYUv82boYFT1COd8jYPtuWhNSt
         3Egg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770503512; x=1771108312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PGG3Tmu1N1oqV02HmaCAabr0AkA0/RFT9l301VCDKNg=;
        b=S0qenRJN9u8HfyAUXsZ/5PKG3968h6SLpnURie9GFNrLsMsxuPFB0XIcCZQyhhdJCc
         jbd5wM5UPrLUM4CIV+H/EGakoINZnRG2cIR3PeKf9je6bpjE2sGzj9TU08v1+/vM7pUP
         5X06SLcE+W4EnWOtMTdIfCURE8W/Cg/GyRioE+JmGCg09rlSGAnfyQluyT5CPaY8m++d
         qQeHsy4IusQ9ZUX5DAeiXu9lvoJZR1PlHgrFEkUN6n8om0mKzvDVILBzxO1/VlByrvdu
         N6rEbX60MUXSeD8S3g0toKRTBjTlMZ8X9uRwSSe6UaaYFIjFGFNyQxTb1phUoCkf9ASO
         Rdrg==
X-Forwarded-Encrypted: i=1; AJvYcCWTo8iG0naCrHcmDQwvel5eE/1n5/MzGc9I62lIWdpBK/Q7ybOIUYGh9PfUH2Jlk6wcGQOSOGUGjg==@kvack.org
X-Gm-Message-State: AOJu0YxS03UaUD/ClSzVdW98uEMtG3VF+QcZpNjunS/k0h28pdTrArwQ
	w3vrg9w0EOtynkwZtQk1Mv0S7jBjEl8pufkZd6NU9EN2ApJCFRKD9tup7VG2up5VYvS+96TodmN
	5VBGnE9x4zAbumhi2gMT/oJFK7jM09tQ=
X-Gm-Gg: AZuq6aIf7gmYUknCBm7oZ0oS/fa5Mp2ZiMPNc6xVZjzebxf3ToAlRU33Ehz0CBLvg2t
	spdQ/Cp+RwLaDFnvCzjlF8ixFUEup5yK6tTGXzyyjwlfa2JDMi418IjHR/hSGlFj0OWAWEg6tdU
	WYkwPXSX63LS0nM1rkzD8PG+sI42ilVzU/0S2+jbJLG/xonPskTWdLkkazVGdFW9duxhIgELMpa
	JoQAelI139VYadtFjkhEFYXee7drnScqoTKvX/BSBmRUDtf4hbb/RBTnEYW+EMzXb/OIA==
X-Received: by 2002:a05:6214:e6c:b0:88f:d4b1:4c2d with SMTP id
 6a1803df08f44-8953cd995b2mr98440976d6.60.1770503511579; Sat, 07 Feb 2026
 14:31:51 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev> <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
 <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
 <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org> <CAGsJ_4zBpL6a5ORAQUFwZMM+ikmMS8JSo9enLDZ7VFT9kkge+A@mail.gmail.com>
 <bfda8f27-cd2d-43dd-9fdc-cebf7b7cd7f8@kernel.org>
In-Reply-To: <bfda8f27-cd2d-43dd-9fdc-cebf7b7cd7f8@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 8 Feb 2026 06:31:40 +0800
X-Gm-Features: AZwV_QgxhNqRogNl6N9SKbBz4-2j5TRyVujP-FCTMTWOGQJSFKVLI-AR7kj7ONU
Message-ID: <CAGsJ_4w61iyE9WCGBjj6jufh4e8y2S8m=0-8Adjwg-hLODaRrg@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D0909A0004
X-Stat-Signature: hez9f9f4knek7osgerf8ucs9j9n41bxs
X-HE-Tag: 1770503512-758917
X-HE-Meta: U2FsdGVkX18iL0Zyfvyi7bBNfuHTYAUA6bNL/nRo1RedVsQUke4NwEdRaxQdSuLbW71XGE35LA1r/npRSniI/WYMdWXfklZwlqYlGkx4oXrDJykJQEjI5qKJutcUT2F4e6zrh7g2YxJHmUAOgmPsQPIZee9nvzclaZ9ONXEg7V0Wb1MmH+7TGkOljiJfy+dzhodr9jR43eFncWs6gJSy+mbUvG2LIOtd/cRoNb2Mj9BSydKucVdSkwEG0JxwnOaCpz8NwvSgs2y8Ktp8Zmm9vPvTvEnFApbyQj2bP//6XEt78EJsSnoxzaGDQJ4jLCd+h+mfNtw/UpC16MtGf9TnyczCMeQRVRfvR6lbWHkcD95UYN14Q2dDOkAa/4O6RJqJ77uDQKLX5C2wh4DgmTaBZ+pyIReGz1XtLIs6noBE50HZifJOHihxI+G97cG7M/vwBG4sQNWAFzWD7sZWOLDI9j3PL3TJZdxMOnPKRXMdBVaI/oSQBSEKzWgFs1pMz4wO7vy34KrpX4KjN2NpKyLZyU9tEdGQcMozrGr1C1LXPMWkAA6QHvHUmFIMHn1l84qHaBjWegZ57MXoue8i+L1JLbz/FjjAOREw11BSSPfsXQ1gerU9sAwAS0EAiiSGAj0vk7WsXA94mdZiIKzS5tSsVqUHQQyxjvnbR5ULOASiHi+rNTWkn2LTXZC8NZzQTWegGRcmQOtTPQ70NlZeW4OBXPlh++ZDYdoBAf84gBoazIqHXPHtfpycMeTnHJzJQN0SRjbr26KKr735Hj6m+jTKd81gEiJZN2RjY7jWK2LdbMORKnCGNO8BVUyZ5AAvMij0TwzzTaNoyDOFM/Ac9aiIcp8ybRIwewndW1zo+lDk70N8cIVGo4S/3UoYwdpIvQTgoTbbAcJjXCtaan7O8DYRdTRG4yZTW/NYXL6u38+kuFh5OH0lwMIEoB7HmYwCcDb0kcaE6ZLEScWy48a2C9G
 oOlge9St
 ApsDfa99ttAFSRUbfdu5YlK8uH2N5SFUNDzRwf2/FeGNDRUWsCFtAZzYKn/NIGZ8+iePSWwaLYsSS5+ayhdjCuNcBiesISgX4SHAGFzfJR0gPo5ZFA307BRa/YoDOU/43FwXBYxgU3S3+iCaMTbwL41j4nKjlnUKSdMzJaB906rniou02BfUtf7ABc8wZdlWUD3Ldfhvvd++da73wc7TlsuB8Ajx0QK8LwXXsqRMu/uDs2IwuBCkohDfjFnMTIe24o682j1rTiB6unpaSRZ9RDl7QQ499/gut5xFjLUBn65bSJRnvzA5ElvTQMYfIHp6s72h+v6gWcYds3fJYU+4xRDQefjaJhxzQDnN3qH1MBr6u/MDTjFjH0awf7aE0iHAkq7I3Pujqqt/iQT6u6BTFw4UJ26pAIPEUYAAU5tZTNva/PRg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 6:25=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 2/7/26 23:17, Barry Song wrote:
> > On Sun, Feb 8, 2026 at 6:05=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 2/7/26 23:01, Barry Song wrote:
> >>>
> >>> Maybe change =E2=80=9Cjust not skip=E2=80=9D to =E2=80=9Cjust skip=E2=
=80=9D?
> >>>
> >>> If the goal is to avoid the collapse overhead for folios that are
> >>> about to be dropped, we might consider skipping collapse for the
> >>> entire VMA=EF=BC=9F
> >> If there is no memory pressure in the system, why wouldn't you just wa=
nt
> >> to collapse in a VM_DROPPABLE region?
> >>
> >> "about to be dropped" only applies once there is actual memory pressur=
e.
> >> If not, these pages stick around forever.
> >
> >   agree. But this brings us back to the philosophy of the original patc=
h.
> > If there is no memory pressure, lazyfree folios won=E2=80=99t be droppe=
d, so
> > collapsing them might also be reasonable.
>
> It's about memory pressure in the future.
>
> >
> > Just collapsing fully lazyfree folios with VM_DROPPABLE while
> > skipping partially lazyfree VMAs seems a bit confusing to me :-)
>
> Think of it like this:
>
> All folios in VM_DROPPABLE are lazyfree. Collapsing maintains that
> property. So you can just collapse and memory pressure in the future
> will free it up.
>
> In contrast, collapsing in !VM_DROPPABLE does not maintain that
> property. The collapsed folio will not be lazyfree and memory pressure
> in the future will not be able to free it up.

Thanks for the clarification. I agree with your point =E2=80=94 whether laz=
yfree
folios are carried over to the new folios changes the whole story.

Best Regards
Barry

