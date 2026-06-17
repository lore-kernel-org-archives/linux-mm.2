Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2130CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44556B008C; Wed, 17 Jun 2026 11:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDDC6B0092; Wed, 17 Jun 2026 11:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996FD6B0093; Wed, 17 Jun 2026 11:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEA26B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:40:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E89741C288B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:40:46 +0000 (UTC)
X-FDA: 84889817292.25.384020D
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FA8C40019
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:40:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=W0TRQnDc;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf04.hostedemail.com: domain of "prvs=46286f5251=riel@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46286f5251=riel@meta.com";
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781710844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/RUstE4gyVs5/jMtcWA71vEvXf+Ut9p7GjDbht36iQ=;
	b=zP6H3trmtPwB3/CbBgUY/fIOXOCY+PyqMsUT/zCORG8YuKHN4/TLtdYVVZtl81GOKA8/SM
	sICsMQz5DqSwIWGO7/35xwlrFvk7OgX+oxBdFFSwbsXcuD1O8irfk77M3QwrEMTKGGNSgs
	fgAEtGhG+O3N7M7KzVILMQ2kQncwpXo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=W0TRQnDc;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf04.hostedemail.com: domain of "prvs=46286f5251=riel@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=46286f5251=riel@meta.com";
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781710844;
	b=sRXJUUTmVeyXXw4eCtP17EB8mWwCuOyYmmQ3YGM8nrTnTHkxbvCobbNYhkM07YcZKy+vAB
	V6S7DJlGtAVTs6AC2VvC4+f/5T71Uu1LRTkDPhDHySUjJgkZ0CL0fjyRFultrK2BKorJ/2
	eFz6nrDH9vF1WKFOk7RHxKT4ex5MYJw=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFUrjV113716
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:40:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=8/RUstE4gyVs5/jMtcWA71vEvXf+Ut9p7GjDbht36iQ=; b=W0TRQnDcQObF
	3H6h14IZdhs8yftLE6mdJwe0AC9mXG6LitRCMa8s2CF/ta4zdGGhFMmSBEvoh3/k
	hSHv1m1Y7yg7ODl103FUQy1KvTMnj6GqffLmH0n0saXDA6NSVAeDvB+GbeAbd8JF
	TFiWyguFfm9o6/MXJHTuDGFk4tF4Uu4H+ZXe8niE0HQ9QGh5zvrhYZmTkHTHzkJP
	OwCm7h50TelWrWeYpltisQNPMWxU2Pck092AVrPzJTY1oPIeGyNtxQbOuAwhVJ31
	XctCNFbGcijgkylpDbPvb1ZYPxUieUyIA0hFFRRA0uMe6fTAQI5d572iUSF4QzFR
	SSoKTHGt1Q==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eueg8n2xv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:40:42 -0700 (PDT)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7f582244e9eso100214957b3.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:40:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781710842; cv=none;
        d=google.com; s=arc-20240605;
        b=DdgPIvL57buornk/KJIq+YcFVxhGJ2Fy5qoCqzmrF7/aRxeB7b8msiFSQxbdvqVNeM
         P7LX+XDx6OkMGhDNxKYsujitQpleTsn9q07Q7zddHaEMt0vfEB9lf8/0AOezxBLbvez5
         XsKIiwsGBQXoQ6R0mudBITJ+EMgg4O7ofiPsxR3+wmi2vFs5F/ZquyGki3D2O6J88s8g
         v3yf+4XSliAxoS3hlhs0o6KnXq2qCXzVfKBA2H2tH9xzG47tkkHKsIKe1ANhuNDDuItQ
         Nhw2oqbHVIhod0/C9qIrsKCDL8Nw1yAKTFGKuMvhav+VgOPHO9b3Az43JwBH5J/q9r8D
         RGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=8/RUstE4gyVs5/jMtcWA71vEvXf+Ut9p7GjDbht36iQ=;
        fh=sj1TsyRtw5M7bXymrFyPEZSjdYhDkdi0qyVQOgvETRE=;
        b=Po1blGQuc5zZTjLZB49RvQ7NUXzKH3ojsltz1ct1d6HfE5yNENK75kIJVsq1ETI2nz
         ZbknYwH3oiem2bEUMES7IBUG/bEnx+7rcf0XIrU8Vfy3VeK5k2orTbhUVgtXOkxBGBb+
         nB+CNBHZHonh92CcJdTDfUYISBj5++lsOfQUCqtSYB/Uq6V/E0w5CaowlFE6ssMF2zW0
         DcX+99qVcltlC3hKc3r3joiZjCPbW4X76lpUJseTPCQ1Hp2NZIYzaiuZAKcjN+nLsoGA
         hme9Ms7VRwHl8i+2mK3caFCtPCIjDo75V5BgW7OnmxTTbMppYwgTLIaszaGG+KzNz9rb
         5ASw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781710842; x=1782315642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8/RUstE4gyVs5/jMtcWA71vEvXf+Ut9p7GjDbht36iQ=;
        b=ip4RtRIbJ9BmkRTUEVdNmp2QsboqSFQkZLHrJtyGbrcL4OablJZBaQQrV0aeU/aa7C
         ee3+FSYXyTuGRJh593swrquPKNhwDPl7c2VrM4Y0EPIrhO2Tpq3Qqt3zK48YXdwBDC45
         AQGEgdpiyLNrNuwg61i2RyAiZnw1Z/+CE2t8JTU4cHpObU7RDZcWoBhWDHHWoE9S5ie5
         7g/TEV7lCZ37JRLFS/kEvYHUnDIkoyixQ3E4TLqe4mXPu4Ko9xq61UOCuIXS+0cgUGWa
         z9wrXqYXFWmUP2hjP1HQ2q2U3bbVT+fBxUT1vXZGyuenKAzmPwl6ewKW6VS3GqFKieWm
         hQLA==
X-Forwarded-Encrypted: i=1; AFNElJ89eVoTk117Y/rIHDokapb35RJJRWylwkltNSd9ZvVPmKZiYk6drD3rzfJVqff0PAwZ4W51owTkbQ==@kvack.org
X-Gm-Message-State: AOJu0YxTI+2HSCra+xe+pRwW2bWdyrRjB39FGUA9tsw9CmuV0jKqFfNq
	Dwnls8AOaU9qp3tl2h4D2M5MeDHguF90ZnCi+Kaa4qyqeSakAKBd+wxeC7Nw9+TyDlxNUd9sWYl
	hHywvQjBrhi4SlAwddgk1Ox/aAkg2U/PrpCiGJulwfgo38sb0DO+rKq5IarZJEkSj+iel5NoGc9
	upkrzsthVNejd4YhwgEJejADUVLw==
X-Gm-Gg: AfdE7cmn3Cmq+zIJ2LO2NDsEcLed/9QH9Qv7czJ8K8jG9mzHJWPhSw2TCdaa2WFcGD8
	eOSTWlF0epmIERA2L6krNELVjbypeQJHU3aDcV0wUkNdJJTipLfe8QlDzeqXqdQSW8lQfei4jnp
	5/m7FVIeZJAp3cE9qYSi5AfmcV6vt/OW1ObmrqBMYHTphNCiFKyexuUiGu6zECkW3c343+fDIg2
	NdBKqPrkMU=
X-Received: by 2002:a05:690c:2501:b0:7db:f0d5:bf57 with SMTP id 00721157ae682-7fe5b8d6391mr44137117b3.1.1781710842006;
        Wed, 17 Jun 2026 08:40:42 -0700 (PDT)
X-Received: by 2002:a05:690c:2501:b0:7db:f0d5:bf57 with SMTP id
 00721157ae682-7fe5b8d6391mr44136477b3.1.1781710841484; Wed, 17 Jun 2026
 08:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260616145413.1491961-1-riel@surriel.com> <ajFrxhGf7loEHUeX@casper.infradead.org>
 <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com> <ajID7ZpnBYOucAVz@casper.infradead.org>
In-Reply-To: <ajID7ZpnBYOucAVz@casper.infradead.org>
From: Rik van Riel <riel@meta.com>
Date: Wed, 17 Jun 2026 11:40:28 -0400
X-Gm-Features: AVVi8Cdnn09ZX4nhr9yjxhpt9OG2EJuTVoc3FDSZGE-r0-r18jHpxXs7bBfkQMI
Message-ID: <CAPkx9x3BV3vMh8d8P36wCEOYRshRobT1G0Q9v4h1OABj1ffS=A@mail.gmail.com>
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed collapse_file()
To: Matthew Wilcox <willy@infradead.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, Rik van Riel <riel@surriel.com>,
        ziy@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Hugh Dickins <hughd@kernel.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: VTyEXvfsWxhNL_7qlS831K4X6IIdHS5h
X-Proofpoint-ORIG-GUID: VTyEXvfsWxhNL_7qlS831K4X6IIdHS5h
X-Authority-Analysis: v=2.4 cv=LaoMLDfi c=1 sm=1 tr=0 ts=6a32bffb cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=JfrnYn6hAAAA:8 a=Rq89yvuFuwweqddcMoQA:9 a=QEXdDO2ut3YA:10
 a=kA6IBgd4cpdPkAWqgNAz:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX3dSxwH1WPQY3
 gXzbh1NrEa0rQhIjqvS2LwVkPyulp8r3Cw+fWdAu1Ny3pU4OK4X81F3AdPUk/poAEZMWYBytydG
 kKdVbzlcUIHsRcE4Rx70uaezUXdatEY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfXxv2e7Gmi0RGO
 vQ6lVJK1tN9pMJo65kmHf5gmeSFyfqQCEgug1z8yi7EDw5Gt6LV1w6TObeYA7ENS5+pFbzCuAAW
 7WNCa/w35rGty/4FXSvaATa7w3Li712uIWWNA4NSeLPeRN43pO8WuKBvOMW5yI8yxxMXbTFGKcp
 1lXH9QeayL9hr5QHIe21PnFnk9mQgIlAZ7py4Wu9YKcjpTA40UUhQ0CKVUNsiIcnEGxlbR/0MHE
 A1ii7OcxvUj4ajW+LKeLr3w6y7nV4KXct49NXqLL4CHFbUYfCs/P9YKe3pv1qWihdwby2OWs57d
 4p3UfFkjYR+rV7Gw/dhwrU8ELNQDNejgzDcgaUsYgL/GDA+U00ZqP8wGV2rBqdKcY46o9wYh5qP
 BerdRh29wcDdOk3v29FqJzyj9NtsARcobO9mlDnTNS7jHEIiz9gQR9+wyXTeVTIupQWfjtYIfDu
 KbQDP3flyfbnk589Mhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Rspamd-Queue-Id: 4FA8C40019
X-Rspam-User: 
X-Stat-Signature: emn58n4axibxufapxo619hbpodu17bax
X-Rspamd-Server: rspam09
X-HE-Tag: 1781710844-919985
X-HE-Meta: U2FsdGVkX1+1JZQ3nMF3OJQseYrjMdWQwLhvY6idEbGORBb3mLCB60juyWknvldMtfC2EvNJXymq5D5Ma5xVU52rJ7BoJAsojGgKhQ4Wi1/IL9ZbVMlFR+3y9bbp6Y3SMPTGGo1febkCqs4AYy+/N13xeol9bUV1IIiwBFeuF7asZ4OdXKGeWvmigrOifm7yjdbhYtO8GtzkxNUn4ze0J3DZd7zZK8MhkDlZY1hirx9GbyGYbgOMut8srkOE5HYeO/gRidLtcH9AkH/4+7qY4lIjmyWFyOP3pwmrNcODMn+qYfjzUSHu3B1DgREm37s6YqB15SDCDujC7ab5G5n79K72C05tj5FO58qocJ1XsvZo/j7VydOQhIbc2fwiur/7mutCarZ7tK6hgKUpMlDvAKHpbDMpvH6seelo6ljy8L9zKWybZukAglCs8SwlI19q0SevPQ0K/hX+QfnNASk1ugzHIzeq7Erqs+A92rVm0KuzjTYSAD/ayf6oEVma8ujH8J81IXTpU4g3nlETll12+/r8glk2JVK+kX81buBewiKOrNB4X63WHwICVh76nl/NGScwshCtr0qeJBZ+Kwk6n+jKx7AgWgJ6Ctpg5bckCbit79AzPRQJBnyKrG8ISXfh1QecVsECH0ifdbGPmpyRGh9UCv7kn3xygPwJZg517K3JHj8mXMkm3Vs4TnZ31XZreVv9qiRIEpEMFOi+3hwnPU030hyU88yktBFLdCVZrRT6bIkV/JTIbljO0Tt0Mtn6DvLVjIyvgIu59tItnyDabRunBU1tfYgY2tl1eHdzZTAx3IFYLWF5i0//oGlkHLTpicWBtOG/csfyxfrF9ZY1V7IHGnpOGZ2F6EYiykhHhgjwldKgEktcuzUK0ST7n9mC4DLzB4VC2QadYAEW7EX0kntZBgmbra6PPVZZp+baQ20ExU8BqDZqLHy1kY6pWlxEDpRJWK6DsLQcuphsIkC
 PcVi5goA
 W+67K0Crba4dHuLl55Y+Oxrfjqn1nockOIJdb0xUvihTqakJQeJeOzdMuDJ7oIvJ2bfO4TopwDFFHq8MqUJ/1mBGZ0uLpyz4rBYmdtGT8taxb5wxKaMzo0y4D6AgPpw0c69Bt6VfQj5xVtS8B/G/P8OgXftO5CnzqWUZPimOKPC/IZrhj63ImRiQBUyiTYKDXlh2kBGSuzwmCLds08o09U1u/4Vog4YempL/3mgWX1L0/hceAX0gHlZhNqfz0Y8yKo3dSQrshqYJ+Tm+4Oey5ZxzVes5p7oIp2Cxlfc8Dg9YKxSskBOMmB7LYQsE3f8TWfq5F3VBYA9go4B0M+P1pHjMoG08xIHct/WWws64rz3WuM35vi7spsySjpLuQ0xyqRyYyEUuiJ/bcKgXhmASxsAbF9UaLnBHSoCTjuXw+fS3QRmcigGye9KQcQfXTJalOyNZDznAFPs5zM7KTeOquFevuFm22g6w68edcShb5+4ZLSsezS6UHsTVoed1mrPx+3qcYLnMzUbUChDqx1pKyuN8KOsnnghFfF/gp4FtxYK9R0jySUJA1vgESEPlUxDZ7kCSJusJ252JsCUKf1xELWLg38M1iXspzwb6ffRgPY6mJprg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:18=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Wed, Jun 17, 2026 at 10:00:59AM +0800, Jinjiang Tu wrote:

> > I can reproduce it easily with following steps. [1]
> > 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, an=
d
> > then mmap the file
> > 2) memset for the first 2MB
> > 3) madvise(MADV_COLLAPSE) for the second 2MB
> > 4) unlink the file
>
> Yes, but is there a problem?  That is, do we need to clear this up
> before we get to clear_inode()?

If there is no harm in leaving this xarray node hang around until
clear_inode() time, I agree we do not need this patch.

Are there no issues with large folios getting inserted into the
xarray at a later time, after zapping little ones, and leaving
the empty xarray node dangling?

If none of this causes issues, we can keep things simple.

