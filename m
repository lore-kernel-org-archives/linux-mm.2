Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76FDEE020A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 14:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2356B0089; Tue, 30 Dec 2025 09:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CFE6B008A; Tue, 30 Dec 2025 09:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185F66B008C; Tue, 30 Dec 2025 09:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9B16B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:54:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DFCE1A01AF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:54:55 +0000 (UTC)
X-FDA: 84276434550.14.9AEA50F
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id A872380003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:54:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HivXNJnJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767106493; a=rsa-sha256;
	cv=none;
	b=ABmzadxF2ftvoIDfgBkYaEW9whO2gkVpf7b3ZPCTZpdQJLUxM367yJdAuiLawLKCLKZOpG
	/p/isLuPeNleTdEKZJ7VHWpFDI7c8L/aFhMwLNs57NzYJH7v6kS15y00inHVaK6ku0KcYI
	vzwhH4N/UUxZ+cfpayGC5YjnITHZmbM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HivXNJnJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767106493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPtqrJDx2LN6WVicurIDrVxMqrl3W4SxYvYgfkqo6hQ=;
	b=rIsdGecfXX/MOzksrx+aw4MwBF4/7lBsab2eS4rj+61FCpSaRxuRSouOEI8F26f3E2htd8
	L+B5v7y3nv+PRQLF+/KyUqcnL3po1zvbWsaUZv1WF3hHuHLnZw8rwNlZEDj1EV3DuoFTpS
	3M7u8WcqByqk+cM6Hcrw0KQkGiK1LTY=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so14098277a12.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 06:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767106492; x=1767711292; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPtqrJDx2LN6WVicurIDrVxMqrl3W4SxYvYgfkqo6hQ=;
        b=HivXNJnJk76OUUKBlMwYrfoWv0kaMo/6dRqkQzjgNJltSsM6BirtD+wdCj3ImJPVtP
         ZiHtnTcCw5E/vEnXXO2OUbaYQbDHTJAxw5PmMOkkvQwTvkPzynJPB18pSkghsI+WaONJ
         s8p/0TWs2ZwRZlBPiUcVzejGcTKTZIDvJOhIlLkb1/biWDJLRe+n/UoXfyNY9vMQi3H0
         F+dvaRSZMq08tY1O0QmUtR58pnPyKNxn+pv1FWpM62smUwDaFgC8Xq7pYu6E26a4ZQFd
         y686ciiYXye1NPbks1iiNtDAczmw9A2oJjXwgS4ac79BnSYUUk+VH2Xb6fFLmiYqXnb2
         Eb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767106492; x=1767711292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iPtqrJDx2LN6WVicurIDrVxMqrl3W4SxYvYgfkqo6hQ=;
        b=PbufuUUVmiABpyaTbh7TtJsVHx+pKvdv5+2LyeMjc4FhwDEQjHbcFC5R26tO4DTkQ9
         yPXwXFvhG8MyRoIyA0SXWSuG6TWK29jdWSrawCiATmPlHeuauGlnJI4xL7nHjz1o+7P9
         BGyIVxkPM5niBdoGUeg+aggG7ogRTZTKmD0nOA1FC6WnVHQgyRHLUuJzNVvt9GesFuW+
         E3LUKiSMkWW5+Tq88Gi46L/YVmrq6LOxETeonyTYc97GurLgLNkf5nC1HB1AwQaUW20R
         v0T3Eg9WcVGe5tdpUJHHI9sKXTXeU7kR3WkOGAqj1zj6P0fCJTQG+i2Nbv/pvhwTt9cN
         guHg==
X-Forwarded-Encrypted: i=1; AJvYcCVf95SDuAO90Pjncz2FdWsndlVUACGL44WQFOBr+2h1Qatg2lADcM8Lly3QVhpjz15NGLBqdFEw0A==@kvack.org
X-Gm-Message-State: AOJu0YxYQXfoCWUTg8LPtcBz9hRpFphGuHx3tVv2QRN5XY+Y0GPTN0tN
	CRi/uYMapKDcSDoiqA71V9Oj+vcKEZgY5LdZWCNaFGQhcc10VQqCCKYcAMKtBE9zC7zytTEXYOP
	S1fMQ7PysCRwMxojdFbMsgJU+VkMAmCHCTmFjh4Yp0w==
X-Gm-Gg: AY/fxX4p2BY59BgR+Yr9wpLRMNVkZg0u49dig3ELIGiRYma8kqdiCUqwX8nQ5XdxHMQ
	D77aP4tMYJhIsbxsCA5Gtt3QU+8gc/k51K5HTR8v/3o+nfq9r80+4gbQ6St2anD6yz6IpohCVp4
	NJJO4rWfGcHCjSlWGwmOhoZ/7E7RIAcdDUGpzz8QYqno4UaTb5BAxEQSqFjgaLkLdBL1lcP2zSf
	nbyClElrbYiEdg2KXj0IAL2Brwh3GdyXd7aPzhxlTVsXMTLOg4mrFYEhKHy3R3z7dfRvVvOKGEv
	YVhNG3G9L3PxtMlYIDX0L/KQnA==
X-Google-Smtp-Source: AGHT+IH80ajjJWOaxcjGtpMhq2PVrxdNN/j3le0q5PDwI3wE9afEkM7XXrFvUS0ZiRI+ut8Ssexxvc+Ly344fi7D0p4=
X-Received: by 2002:a05:6402:2807:b0:641:3d64:b120 with SMTP id
 4fb4d7f45d1cf-64b8ec6c4e5mr34741660a12.18.1767106491852; Tue, 30 Dec 2025
 06:54:51 -0800 (PST)
MIME-Version: 1.0
References: <20251223201506.2334991-1-pasha.tatashin@soleen.com> <86cy3x9fkj.fsf@kernel.org>
In-Reply-To: <86cy3x9fkj.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 09:54:14 -0500
X-Gm-Features: AQt7F2qBBsnUSEYYrHnGNDVj_bU3ZxSfGPZ3QMIYdTCnkeg8TzTXkH1FuX1IcYU
Message-ID: <CA+CK2bA6qr8C-EtpprDZKZP9-VJyoOdZ4XHndd+GcQ66OqBVbg@mail.gmail.com>
Subject: Re: [PATCH v1] liveupdate: separate memfd support into LIVEUPDATE_MEMFD
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A872380003
X-Stat-Signature: ig9r7s85osczgi7mphd9jetrbmzsyf4a
X-HE-Tag: 1767106493-88062
X-HE-Meta: U2FsdGVkX1+eIEVB1PnSWeXn99dw+nZyHkUaYU1/o3ZMu6IEb4HHq6dgxnl1rMJbUzb6idMJHyhz2bjdfIGKp0VDwwoDoMCde+4JD5YiB+8i8QaKQCpXRo5E2w1W8ZikBtmaVWIF5UrSepO4kpplikUvenF/ka4Q280/8fKW+UWayaGII2UV7O/4WcWO4z9xr/lj4ILXgbFQY1N2D/qCcUJWeK+Vd5FqZ9YvgmdbD6XFVUuGeQg1Ru/VUp0ttr1U40KiARGep4j/Xacn7ntqAQlJx9koeP13VKuw8HrbQj/v3d1fAJCLzNj5A7/1NJfT5jolTe2OZbijHLM4G4nlwEu15eGl0Ci4X4KpXjpnoPL+vForZ0VOu3sZb2HiLbx0yZknAB7MDTGW08ISPNILSILy2uyt14VOGDbz4dmAjh2r2NkbHoSY2qdK9z0/tpeQe26eGo8XihHyEQ6Y81Mu1XEQxTLSYnm9Z6N0FowtW+SQJRDdQE0lLPd7D1k5XU5krpOm+WVFixqoNQK3Fh3qEwDX/rXKb82MziYAlxoJWrUZfPXk8xykDYv3l6QpbaHeCuhx59JAd1umnyQCAlj1SJr6J6pOEBzfMWmiOU0iy5mc6/XpAMobs1BwhQrO0+5H5yrGFc8O/fr0Xd6g0l2zGsGXVwUdAuYNZdWQlcy+BVuHHaiVSn+cRhv7Z4lZikrXNZ2dFcUIShtd7AxAKjusNbYq9lZVGSFkHy/Uk14U415LYKVUYXdzu0BhkYMdksZTDy6dJoGBTRvNI0BUT0Hkv9s2+eTa4aHkSD5d29WFdK+s692djw7UrSnK/Y1eYXLpkcj0lWAbsnpffDzzTEgxgTstgVCk1XgyiPBIcMed01YJ2/SnWW3xGEY4C64ocqGa28r2Y4NQ+ONwuDgUdwf8cZ2fMK63w7n2jtO+L5ODkdVjmk63y2WXlVhgMLHRZ6h2w72njFe24saSwVe+eLl
 1pNyHFZf
 nfpq17+gCeZyrcbsFuzQd2CCnyUckgso0q+RznYENW8gZJcBFjOrG2JlQW7NmgrRiyxr8HpVM+2nzhAfyNpTsQSw41jJexYh0kmcWLBtL/diUYHVHC77vaTI9KehcOijFpP16j0/KKJVLffZJww76DXVdakFEehz3LhwbpK6NWslfFNq/5fceEZXWmzHPV1KTZkkzEH0liVysmxenW2wxi7lG5shuc3F+g22aOmaAZyEIGofb38ZQ++yC8qk1MxaL/taJRBZVlvFaczU+2lDNKdv1+yFRyNeKcFUDGcqe8dJbOFIsBz+sxx+GFCa8bNA4Chb/vaDYk8ZAzj9G1TXi8YeoGP4T3pinDteaqtOhyKQX1MZagbrAQNp5I5L8PSNtKNkaZxk+hWxieA58Fqgkk8DKQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 3:52=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Tue, Dec 23 2025, Pasha Tatashin wrote:
>
> > Decouple memfd preservation support from the core Live Update
> > Orchestrator configuration.
> >
> > Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
> > CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
> > Update may be used for purposes that do not require memfd-backed memory
> > preservation.
>
> I initially didn't add a new config mainly because there was no other
> user of LUO. So disabling LIVEUPDATE_MEMFD makes LUO entirely useless.
>
> Anyway, we will eventually get other subsystems and this config will
> start making sense then. Might as well do it now.
>
> >
> > Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
> > SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
> > them, allowing the base LIVEUPDATE option to be selected independently
> > of shared memory support.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/Kconfig | 16 +++++++++++++++-
> >  mm/Makefile               |  2 +-
>
> I think you should also update tools/testing/selftests/liveupdate/config
> to enable this config.

Done

>
> With that,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks.

Pasha

