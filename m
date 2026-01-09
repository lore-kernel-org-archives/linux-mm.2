Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CA7D167F3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BA96B0088; Fri,  9 Jan 2026 04:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8092D6B0089; Fri,  9 Jan 2026 04:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714EA6B008A; Fri,  9 Jan 2026 04:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE036B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:59:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F16691603FC
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:59:33 +0000 (UTC)
X-FDA: 84311978226.15.8732DD0
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1501D4000A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:59:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CabXiZLt;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767952772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kdGrZacv9IowSY78WMAynQv1ZGunoCXgOt7xY17SxA=;
	b=avxyYa75d9lbZZ2yo3cbSz3om9ARSWGZLk4xy+B1LKje549MsFXohhzaXWmKbZfIF+DNCc
	9FfIky7RWjRD6/n1VyZWDTUHGh4TfjJFaYo0AEuj62Z+Qg4LfsaVKGRY0eGtNXTSUv0ev1
	RknQsNZcFFB0cZ1GOzT98lDLhs4Y8ps=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CabXiZLt;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767952772; a=rsa-sha256;
	cv=none;
	b=ntgTwA3vcEIy1UQiaNrBIrH+lvp57qJrCgYRd/2XmFm7DAP495aVbAoHT64OBpIYcM72ZY
	ub208PRdokYaLoXSyiFKr3bPHs3IXn+HEzaEH7LaXbxD7yu36mBjLkrFGJRBbLQxNlEWSY
	7e9kJJIaCFh3FiUiCYufUZ9D26uEe/g=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a34450f19so41102026d6.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 01:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767952771; x=1768557571; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kdGrZacv9IowSY78WMAynQv1ZGunoCXgOt7xY17SxA=;
        b=CabXiZLt5t02Air3HWmsIRwOFXRiCfWosenyLuopqpvo3bYZSjQnZR66o0lHhwINN5
         /dXfsu8Leh4iZ+zPGs010OI2xSY/cZDDnfGb5By4T2LuZPWzJnjLep5ikIT5L+AiSn3T
         2OzCot9loDauGs3kzeAfl7U5cLRFpj8A8qGWsXa4Fr3HZ7WGu20ar5TfJErJeELPSLQ0
         8vj2c8QeGsnKGn4gJr/4ZiqCOBPaM5SEW7PqhbmujfSC4i/zchfR1hZ/uoXuFYzCH3EX
         YQARmTufZVPm75z5t2tTLcACryqE7JwptTgK9z8NgWS6Dc5jNIi1hUBVNrO9GsLjupoG
         Gp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767952771; x=1768557571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7kdGrZacv9IowSY78WMAynQv1ZGunoCXgOt7xY17SxA=;
        b=FOuNDgd7efuuC3lMO7zzUsJWxfqNIYBrz6MVV4DoZz+Md8xNHTnqIIca6rUz5Aw8ls
         dtKW/GqX58gqXLbrtm2U3qcruCaaZ/dRoh3GjJOsE5INxzVJKmEmcIrW82+YNRXNCo6b
         ZU9p0nYNB+oACDb3Z04J9+hS8h/e2s1pPcTtV5MeKh/UhpeBPHBZIf0SX7CadMq/xiK7
         U9Zl6ly2ozjnrtPmXJNJnjbDQzSOB7OafITmfeOnqWU/JhZ2V8uv3GEPa7jqVnqGyPP9
         tHruQQxAEfkAH2I51bO8AZMcGQ8HtO7VWJ4zRgDOZJWcLscoS7bifv8pxJmkwVYUori7
         q5vw==
X-Forwarded-Encrypted: i=1; AJvYcCWJH4XGDWTv50Jjc5RoSPLGYAs33RxsDujl5sgb48ZgPrAXqjeJws/Du4KprTNmAImuB0EArZ7j6g==@kvack.org
X-Gm-Message-State: AOJu0Yxmk71LCuxM2AvNeM2SIE21PMDt17TC6X7R4UWy8XwIA+bF0jNE
	eiWOKtD+kLH58chEsTKyfWXjb9hY6Ya1Hm4wNo3ut6eLT14GdsAJ6Oybm/AywV1R3AyfN8G5u30
	2gz26ZmZ8d0AbR/K/UU/nZcvPdT5zrI8=
X-Gm-Gg: AY/fxX56N9KlPidr8v4ZeD9qWyqv859FTtFnvIuX7HxjfyI+1v7fZbwKEiYlWxjt69/
	adHCj/Kswyp6/iiV9c/lEV1XNFMYX+5wAOJ6BK7Gv0YBwxdhJBpwK7junrtPnVpUy7Bqbu7tRTh
	Qxz9FeCPl9rZg7NlpkxBAXSld30EsWLYOK2p68PDV7cu718lEbucMEVDqKfu7VT27Mm1VFAPsuV
	eXyDr7ELBpLdfehvGThMpAyAcbKm8xjn43viATo3166o9TARxO9NrqcRJACABvIr8v8vA==
X-Google-Smtp-Source: AGHT+IGLLavd9VSrxbJpf48jMuM2/5lKiUGJv0WgqjpUW+4hVqviEz1DHlO0GEpWhIRNikxjBoOI3myDSpdIqzuejYg=
X-Received: by 2002:ad4:5c87:0:b0:888:7c7e:fce1 with SMTP id
 6a1803df08f44-89084175250mr143596366d6.4.1767952770961; Fri, 09 Jan 2026
 01:59:30 -0800 (PST)
MIME-Version: 1.0
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
 <aV_3fxlzwOSz8B0t@willie-the-truck> <CAGsJ_4waQsxPKTcGvtpTAF4kVbYQXeH_iHaQX3aAYDNo-8oDLQ@mail.gmail.com>
 <f9d1c2d2-a6d9-47b7-9f1d-382a28bb88b8@linux.alibaba.com>
In-Reply-To: <f9d1c2d2-a6d9-47b7-9f1d-382a28bb88b8@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 9 Jan 2026 17:59:19 +0800
X-Gm-Features: AQt7F2oy3Qu2Sj8vfVPOtvE_KvUT6ywyCoxwqUYtKMcnoV0-UNLT0j8awhGcZs4
Message-ID: <CAGsJ_4wzZV0maShXW7MO-8coascv2nKhWW=sAcyg1BvWRRFqeQ@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all pagesizes
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: r9pnohjikibyazsg3mf13zn1howq61b5
X-Rspamd-Queue-Id: 1501D4000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1767952771-410413
X-HE-Meta: U2FsdGVkX1/1e497GaLEgVG/AUAAU/aOnu7YRvP7HYChTBjPjWA0g8irhvmXA8LR1VtbgDAyNqb4QBPzqmK11veow1dXxdw69KCvg+2mgrGv+YnSVxfpOdBJv7hD7d00skUsmsGeqG5ghLf3xlABhxr5l7mgT/yl8EfuMgoEBouiV0tQHahyvpZaJpBSXXR4lp7JxwT49JtXhRj2uw/hsxBlrHe9WU7+T9s8OeTuwWPTNhWaCA/k3uSa/4J2ppDCFUgpA2vJ/XKvpRL3XwgGkG99kc5TDgnFY4bSv5FmIE0e1rtdDop502KN14D+FuY6W10VDpTVOGx9z6DJletGLY+dEMWdUOFPUEBsxnvcudXAoj12N/ohuXr8zlmm5oITH7uLBQzhGbCJJh6Aj1Hb2C05tgZc/2MB6gk76t4dEOjAlrj0haC9GQ9c6O6YuGa/y7eTdIl/Bee1nVsIhV6rIWBYM+bKMzsk/b6TJI83AiQ/bp6kYm3538OGIVLs665Pzh6DYZ610SpaRkLd/bifU4iEwOFHPkZ0cNKwZRhv+lufx4k5yMiLk6kBhuLXOe9XsYDhyHviDf3qYw6D3lQJo7ZmxY9w8lxCEWcQRyrdiGyeGDgkKetx5brX7ZCry2vS73O3g/V4lyukV4R5B2tV7x8ewRoX8sCTBfbyUzl668mzswvGbF5WACsZWGDsSoTG353OApz7cqDerdorkcC3WgkcusEWPskp1rfAz5Tfc2XLL9m/S2vyo3lFCkJK/bTSmF3KNtfVNEG7wh8W5UeG7DGSl1o7gObAZdYLI50im/O9HrKdT3aLZi1nWwatgAvAQSj8ne388zaHS9mA2brYR4ZPteWMtXgdb0NuKVZ+j4ryG4fJwyw2ii8qqbF9n7a7f83TJVYIFA3EFfBKQRlky0lUSCL3fyjPQ0xI896E8fawKSp35PPMZ1YeyDeyzVko+2zi1UG780BdI6pAxHC
 leavkavB
 mEVzrvd3ZSI+BLeLkOk1zwoYA2A2zoW1XkC59syhYV1XFzp+kVaM0Fm0Gmsylj/C5AILPg3wRtPm4ehendUKnh+tsxnQsNX8AzY91ZYJj0RIXXvQ3mPvxxJ/pTKTUakWO3OT80VDNOKJFRFnLDlYOK0DMVMFH6/ihvor6G71pcppCQF+jl0nS8ysA3O0ltznUDXVrcpfEOEzLFsFs8QVmeBqhceySIyNRfKRNlaWx7bIjTucQLcTuAR/KVr98MwLtFLBtrQ69XlKTZL2OzmMacc1I+bZDHOQPM3e+xEYJD2qGH9S4olCy2WmpYq4f6HXsSG7nswhQhIPRTgYuiX+Z8MmG11ww7B7LobZ7KpwJRip3Lk5vzYrfJDdEojS9FYPTZ5lTPT7GHIYSlkaHVqOntLEWRg3WlgGiMvnt87BPrsUbF6M7XwthNIFfP+XXEiHlwOoRMCbWtZrl0uzF8UqiJoQVh1g/vd1YjEC1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 4:32=E2=80=AFPM Weilin Tong <tongweilin@linux.alibab=
a.com> wrote:
>
>
> =E5=9C=A8 2026/1/9 07:11, Barry Song =E5=86=99=E9=81=93:
> > On Fri, Jan 9, 2026 at 7:29=E2=80=AFAM Will Deacon <will@kernel.org> wr=
ote:
> >> On Fri, Dec 26, 2025 at 07:52:44PM +1300, Barry Song wrote:
> >>> On Fri, Dec 26, 2025 at 7:39=E2=80=AFPM Weilin Tong
> >>> <tongweilin@linux.alibaba.com> wrote:
> >>>> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 ker=
nels, but
> >>>> large folios requiring swapping also exist in other page size config=
urations
> >>>> (e.g. 64K). Without this config, large folios in these kernels canno=
t be swapped
> >>>> out.
> >>>>
> >>>> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
> >>> I no longer recall why this was not enabled for sizes other than
> >>> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> >>> it appears to be fine, and the swap cluster size should also be
> >>> more friendly to PMD alignment.
> >> You seemed to be worried about I/O latency in your original post:
> >>
> >> https://lore.kernel.org/all/20220524071403.128644-1-21cnbao@gmail.com/
> > Will, thanks for pointing this out! With a 16KB page size, a PMD
> > covers 32MB; with 64KB pages, a PMD covers 512MB. So, Weilin, are
> > we ready to wait for 32MB or 512MB to be written out before
> > memory can be reclaimed? By splitting, we can reclaim memory
> > earlier while only part of it has been swapped out.
>
> I got your point. In our production envs using 64K pagesize kernel, we
> only enable 2M and below size

If mTHP is enabled only for sizes below 2 MB, the patch makes
perfect sense. However, the problem is that we do not know how
others configure their systems.

>
> mthp, so swapping out as a whole is a better way. Or maybe we can set
> the SWAPFILE_CLUSTER by arch.

Even for 512 MB or 32 MB PMD folios, it would be perfectly fine
for SWAPFILE_CLUSTER to match the PMD folio size, given the
assumption that the swap table should be PAGE_SIZE.

>
> I will do some tests of this concern.

Right. It would be helpful to have some test data=E2=80=94for example,
with larger folios like 16 MB, 32 MB, or 64 MB=E2=80=94to see what
happens when memory reclamation kicks in.

One possible option is to call
split_huge_page_to_list_to_order(&folio->page, list,
                                get_order(SZ_2M));

for paging out.But this looks rather ugly :-)

On the other hand, if users configure mTHP to, for example,
128 MB, swapping out and reclaiming the entire 128 MB folio
could actually help with memory de-fragmentation.
So perhaps users should tolerate the I/O latency in this
case?

>
> Thanks a lot.
>
> > While splitting down to order-0 is not ideal, splitting to a
> > relatively larger order appears to strike a balance between I/O
> > latency and swap performance. Anyway, I don't know :-)
> >

Thanks
Barry

