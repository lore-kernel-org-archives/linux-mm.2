Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBBEC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B074C6B0088; Tue, 15 Sep 2026 06:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFDC6B008C; Tue, 15 Sep 2026 06:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7D06B0092; Tue, 15 Sep 2026 06:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74A126B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:57:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D74DB403A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:57:36 +0000 (UTC)
X-FDA: 85215695712.03.A5426BB
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49796160004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:57:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=IXaVTCXT;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7718530270=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=7718530270=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1789469854;
	b=C677CyLZJuyhMFxl65K1ctFRbhHszPYNA8yAU3i5BjRemH5CHE/B6c4kkSX1S2srtrjRtW
	o8D5B9L3jd4fe+OXQTQpqTHzha4JAksUdO0jAoro2nflMU+WYDM88wcKBKIdPt6VauRqxz
	7ltoyFIypufoKsDzNEkT+EsfOI/WcoU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=IXaVTCXT;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=7718530270=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=7718530270=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789469854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fwGVw1TonoALoLn/YIvVihwPl3cu9x2/fqzQL6Ga4w=;
	b=LM5ojsWDqL13p9ZEBdi97ihlMHWjQcYVmIlxSHDWok9XT81Jtkn5icgSkwh4UHbbNGt1Gq
	9yz9HvZ7qtOWxX23QhrxrOeIxOVOHuDJb/QCdPjkWHVpkd74hFg7zX9XMVo7aj/1kPpou7
	ZnVFr2+dSgEdYmnrJYQ9ipmpLS98KBQ=
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FAVg8S3799629
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:57:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=8fwGVw1TonoALoLn/YIvVihwPl3cu9x2/fqzQ
	L6Ga4w=; b=IXaVTCXTNefIpGsfMsoPMnrW3uIAuc+dMeUFFmuE2r+q3fMJpbqrn
	p9rpVGS64edQMzMoCQv2sX5EBCFexQl8hWl4C9+pAkfuxdn2+BasPlPtnj6rfAXd
	n+ZUt//4x5He3fui3JYVvqYuL9K4NFRcWv3Nw9//wJA5yvP+SizcTg4Sr2UT7sVi
	mfdpIBpPI/dZXAqdh259VL+RdGEl8/Wjn9UZ8DY6uKhPMWX1/CnG1WIP0USvs9JC
	SxkGQNonVmQjY8wL80DzCkLgr5rU1ODsgpafn0CqJI7slzj861oS4/EbLp9IlWuJ
	f/B9kSg0OEM1JvwomDCTlVOleOWKYWVxQ==
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gpvmy2ngh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:57:32 -0700 (PDT)
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293a65b577so390382466b.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:57:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789469851; cv=none;
        d=google.com; s=arc-20260327;
        b=dMeU8HCWrhIAIZA8rCpgAVzUge2ZuapDRm+I3mW08uA7e6LDMXh2wyiZC4eDVVhDfR
         4srMMIfGr6lILyME0B2/P4AqXFhb13XDte8iRGMnVtbBXtH+8uYp+Kuc5A9fOIrEho0a
         uxTtO+ZtbLFxtsGPP5UG/w9zW60CmG5pCxf1XBDhLPiM8ZMSnekMo5KnVJ0icXenIV0N
         k6igJ++keQyKhscGTI6gRfu/7Obmqt4c0Xh7algy3PSyOvNh4G9I8W/YI6ZLUCovQgqR
         JPUHazySgU0RCoHH6NdoPuiiIehpwbP9pQLuqJmK7PrD1wLrqPEVrJ2GfxJCfUAJdNld
         G55Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=KQ3JU1tpv7p4RGZxv0vqijCnUKi340SMsq6EFsNMVHk=;
        fh=pYrx+yRfRhOgxQlA3C16k2knJPGbkGZQsK3nYqUX+nk=;
        b=TMNbkPMu5FCt38pO/NS5LNVNDg59kq+Biyi/s0EeVlBDf/qzfsXQhfedVybYYh7toZ
         8/F36L7KOZrt50XhBXZqBF6u3WfCvriKDwTYxaD09shYVDow44Eo8hsakCbARCr5lZBe
         HpB9SekitOJyyFIp3GduMnwmq+EpGjojcBVZO/ThRyK5O1oAWIqiNtAFE/SJ80KoPLMg
         HuA/KZTrwAtikOUAXNLuscR4AwF+6NH+/ucgrJpV+lZZ4bpFQeWpj1hazaap0KbyqSKf
         JRO/8y4f7lCMkVNU7WgBLuFbreDTjMWw8Z3VvpSysUKcGblK+H0ixYhPCVX+h0JdulLf
         C1fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789469851; x=1790074651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KQ3JU1tpv7p4RGZxv0vqijCnUKi340SMsq6EFsNMVHk=;
        b=o10QOznlf911Vi6m50kum1TfZ/mxLHSULwxmkEFPYoM3Ui2atNzbOKFVlZ+JTb93/x
         FWSmz8dyaIZ/7VJn+rVr3Q6lgXqXUVd0gQIpavT1eszBm2To9n7m5nv+5UlvIjLd8v/m
         qkkFhEs6JNp4TZrZIxMkrADmndrUa/hqjzNfC/oVpom2i9aZBcgNd5SJuXlySbonEKPD
         2d4AZAN6yRxYhyc3HBEDzmeTEiNtb6YKbv4NGcuMZTeiDtsQiTd3IXLJ7MsBUC5NWTsr
         o2iU2I3b/hdVTFQGfNLU51d83Vdn/EgKJ3Z17mTGkgLNw15iMaX0VgfwVIybIijkhaYY
         sqPw==
X-Forwarded-Encrypted: i=1; AKwUvBwSIjoPduaOD7UVhf+BS0XscQ4z8LD8ADlzKAtHOCGazwDj4pVszzP1aDylwXF1N/WRYB5ZbR9Q+w==@kvack.org
X-Gm-Message-State: AFuF++l/QizlZPqI7g2KKS6XHNMoWEDKOrCOpQzCbzvL+6tNkPHkZuwq
	RjNdLivaKJIVTXMLePxTqyHnUwEKXGeGirUxipw0GCk3A4tl/DBKNnjI0X+tEey1z79Q4e0atzc
	5H6vx3qojuVK6IMZkXf11PCAi5ZR+XEVCo/9wX6CReHQbF/Vo3lqqggv8NgEAPbnFuzjpGpjMk7
	c1rN7sjv+soO0W24QjgnAJnAKeoA==
X-Gm-Gg: AYBFou35G3q5O2y8ohPisTD2iNsEzi0bEwnnOrRUvOczFRb4DmIFmij59sqqAzhWX4m
	V4hyvacjp6sgbYfQ7lFPtQfPdbYp+8UfPudyzf15WNpXeIWLTbPRtQk0rPlbFmYKI8nFkuSkUrJ
	wbgRwdk5SyLq/QAg5kTrwB8TIZY/XVhNgAY0umlZqTeWtH2K0GY0sd5IU0nG+ouKKuNvz7UJJQ7
	blw/fWKj6MggSiB5Q==
X-Received: by 2002:a17:907:806:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c29b86b7570mr748696966b.11.1789469851383;
        Tue, 15 Sep 2026 03:57:31 -0700 (PDT)
X-Received: by 2002:a17:907:806:b0:c25:2d27:5652 with SMTP id
 a640c23a62f3a-c29b86b7570mr748692766b.11.1789469850926; Tue, 15 Sep 2026
 03:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260911092012.92399-1-alex@ghiti.fr> <20260911092012.92399-2-alex@ghiti.fr>
 <CAMgjq7DwWYNrmqsvEGYkSepwnFLcqHpiyRJJRyKLCBnByvS+=w@mail.gmail.com>
In-Reply-To: <CAMgjq7DwWYNrmqsvEGYkSepwnFLcqHpiyRJJRyKLCBnByvS+=w@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 15 Sep 2026 12:57:19 +0200
X-Gm-Features: AcwNN1WlGhEQrRjARMumL4P6ekuYjXvAxEpudCJxXapjPxLelI-nisb4v3_r2zs
Message-ID: <CAEmasaWtFRk+gd-TJnvP+pigzvanES_fy8Zd3awJk9z7Y_9Mhw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
To: Kairui Song <ryncsn@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kunwu Chan <kunwu.chan@gmail.com>,
        Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE1OCBTYWx0ZWRfXyrrF12pQRgIz
 ELUqWMOpmZqLI9cIsNmfcU+4CGnc3mNzZPRi4UaC+KuPXt77BDNrCwUWLG2SjEgyMQN1hBObJUZ
 JYPoiV8agkKeg/lVzT+0Sa/nqzXBLWMylFRaGj1Gp0VbtYd37xO/8o+Ysv/0V96gnuEXkLeDJzO
 xtreqQ8YGhBiK4yfXROmz7q5tkL/GNsYi3k3HzCaCYKwMkLolFGHFxoSQculOVQy73IXotPLmOh
 /r+OZWXwBpOIfNm8HNMWT+9CbyYoWivCIvaMCeklPdii1kfXdktKEzMOqZL1i4Rcm3ZvJ3EleSh
 bhW41ggVm5Hcf1Y5hzw+mtg6XgDM1htRxZi9tZ/WL8fBia2dVl+PyS/ctv+1vzo7aKXl1RHz7Vm
 0IisL6mwwRdZcQB9cs78FlyDk+PuDgkOfpv4cavDydjLUTk2NnfhOCstrVqIoLoEuq3ZS8twqi6
 QDBCJJiiJm7dWJB8Eig==
X-Proofpoint-GUID: PRAJVeVdt9cfYQBM-3ewQ5MyESpBQLq9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE1OCBTYWx0ZWRfX7sOrhfWseWDe
 2FAIp8Yoz+FPHCFmuDmUrf0ZzGDh/lfYqrynVzwbB6rcOpHLoTeRq6uIjruuLo92q4wxD50ytBU
 kt7BcwZVmAWD+OcW24f70C9KpRx5kcg=
X-Authority-Analysis: v=2.4 cv=HdOB3SE8 c=1 sm=1 tr=0 ts=6aa9249c cx=c_pps
 a=Ak8bExYEjeps3Jj0Zi+cTQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=8Ky0kgImgTugmDi359EA:9 a=QEXdDO2ut3YA:10
 a=IIT_bRn7abC_HnDGr_W6:22
X-Proofpoint-ORIG-GUID: PRAJVeVdt9cfYQBM-3ewQ5MyESpBQLq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49796160004
X-Stat-Signature: yn895jbbb61nw7hakzdmbm5wb5jon1h7
X-HE-Tag: 1789469854-215480
X-HE-Meta: U2FsdGVkX19sL6l8ypqpS2LIkThFMcBEsgoRmBZMQ2WqCLEy9f0EvVy4MWDSUpFLDb/fKKdySSTTqQqfERW8mcc5WDwzJRWts9baaRBvyDPnHGqPFHG/RZgEop/p8f/NZM7wVVyBE6Bs02CQLswTBT/KxPyqNuCJDq3wHIG/hujAGQcIUHII6wIEwKf06zLEG0WUmZRLiy6WADeBOJF6/i8XXU+YKLQnmlCvzisvmQW28LBWiuVoWt8YL5eoA1B8507Sl24xteQcH/rbcfO+q8gJgHIpxghWbcockpUzWxKLVJZjokTz6R8WQDBSor8mPy9Gsa1Dg+tcmAEw4Z0S7dIy6GJXtMWhT7ST5HYx8uxBm/tfAnpCMGwf4/9TnRcNCurmq98xJYo3BhfkpBsAKC7hYaZAgvBH7YdqIpV8+1r84mVY94+aLN9UembpY5woe9BQ8mAWHaTRjl9jMcjGdySEvrkB6GZuXnc1nar7tDUqAFbKSaewoH7Tq21b7IfS2lzTXJ38doNPkN6bw7pSmI1MjnP3zjP92ZyuDx5IoTvSgRZVdagHbBmiQQ0MpqFzjnVR/HBTCpOw+SMeK1sn3u8BGACd/yBdDTG2JnmDpPzQOjUMHJPeNAbo2uOgO4lRVpicNfQnBUl/rqFgu3M1uDIc4TRmmZtPj8yXClvC8kd2R8Def62AEPisTp6SKDzOX0s8u/qrVe/qaAaIIDCislAjPCAj+9q5WR/Mzr9UR6cPBTWzpApMd3sG6X3msQHKXy+bCIZ00NS/MHa5DoJmY5mhDRjMMaXwkyPZC8ySNafrQRhZ72x4mK3tkFScx3HfrHEk2fZgGKY3a3F7rPGpc5Q/mPkEXEQpugzV4FDVccrPohetq6+ivNM+xiA5IrqMBcF0/DzaqwR3kiZeO5IUww3Ay2S5AlXNeCEHkeH6/zLCvLQwAmXnL/UK+xy0ASr6RxPQX5P/vH2LFoEd75d
 VP82cKee
 HWFoYvdLGGbChwDn+UR0yg4IwXZ7HyDr0pWebo6lQs5sRA57CVJFk30Tur1xci3b2FRgmOxxBkb7Tzr3MPvFqC7c82ZltAlwhh9+vARgO5qtx5dSzCDw4A1StxG+jOmCH4mJzGr9rAfdRzEwKjpgtF+3hyeV2kOGTuPwFxcspbV/oRlU+qY7c4JJssPZZw0Hvt7m7vwUnPyhpB/D+KK17RkR275p41M5rxT63O+0DJUS9Ual70LPHt5aghb8/FVEgCA4AJEN5lQ+1+yfCdFA6OQE+MU8fuc07bsjIXcGBVtuV0pQYIaymXtXcbrctoS+pBYDEjYc2lfIHVj0YNe/pR1Vr3XTZqMSvttLRlvsPhVLToEBkgTNv7qrWFpyBMRILAmbXtsbZzj6U0w5FoJ/splyQqC/D9g269I555cEc/yvhUHZcaesEZ7wI9MUB3aYjt2P1aJ3pUxQ9rJ/4a4vqtNKhiAegh80CYJ1QKG3ahqdP91YHofGzxpOkrq4x5FCgOSdXwDFjTkFmHWlw8SajP4244QUPWYoq1e9z9pQMXqXMlmaNhJ9ome5DLq4iNeYr/7mZqgYQfwtsdnirtc+Y2kRDqa7xADMlOTGlIyDlbQ6eViOyUBMSeqaNkR52J+L7gKIB7QGU7eSlv7cOIeS2qFUa9Df1rlkvImrYGpP49iu57yBmKYhksbxVrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On Mon, Sep 14, 2026 at 10:03=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> >
> On Fri, Sep 11, 2026 at 5:47=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > This is a preparatory patch.
> >
> > __swap_cache_alloc_folio() adds the new folio to the LRU itself, which
>
> I think you mean:
> "swap_cache_alloc_folio() adds the new folio to the LRU itself"
>
> __swap_cache_alloc_folio is the new name you introduced in this patch.

Oh yes, my sed was too broad :)

>
> > leaves its callers no way to act on the folio before it becomes visible
> > to reclaim.  Two users need exactly that:
> >
> >  - moving the refault evaluation out of the swap cache folio allocation
> >    requires it to happen before folio_add_lru(): that consumes PG_active
> >    to file the folio on the inactive or the active list, and under MGLRU
> >    it also reads PG_workingset to pick the generation.  Setting either
> >    flag afterwards does not move the folio;
> >
> >  - zswap writeback dropbehind needs the buffer folio to stay off the LRU
> >    entirely, as the per-CPU LRU batch would hold a reference on it and
> >    keep remove_mapping() from freeing it once writeback completes.
> >
> > Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
>
> And you defer the LRU insertion and and rename the helper.

I'll reword this, thanks

>
> > each of them adds the folio right after the allocation, so there is no
> > functional change intended.
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Acked-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/swap.h       |  6 +++---
> >  mm/swap_state.c | 20 ++++++++++++--------
> >  mm/swapfile.c   |  2 +-
> >  mm/zswap.c      |  5 +++--
> >  4 files changed, 19 insertions(+), 14 deletions(-)
>
> Everything else looks good.
>
> Reviewed-by: Kairui Song <kasong@tencent.com>
>

Great, thanks Kairui!

Alex

