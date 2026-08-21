Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCBD3C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59A86B0088; Fri, 21 Aug 2026 05:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A7A6B00A1; Fri, 21 Aug 2026 05:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2C96B00A2; Fri, 21 Aug 2026 05:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82F236B0088
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:46:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AAA91C17BD
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:46:44 +0000 (UTC)
X-FDA: 85124797128.28.207E222
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf25.hostedemail.com (Postfix) with ESMTP id 920F7A0003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:46:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=aS+VXbnl;
	spf=pass (imf25.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787305601;
	b=RXeLCnsiCeZLsO3294PInCczp/nqYL3a/Xl0NQMn45aRQiVMgihunIJGQFyVoH5qbdHRcu
	s+KJV/B5ySUeQP+8i3o+eJY5Dw65CtcLLGYKgmBFEp5jouf0DP9R07oPsLxSNjkuMPG96e
	Q5J9vFwLWfgoaCBYwIEjUKjlX2EAOpY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=aS+VXbnl;
	spf=pass (imf25.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787305601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWPICfmisuXNhOObQX5MJ7az+uKvgkfEFOnr0vRIyL4=;
	b=nwvJaDgM46NCTWVT7KV2y4wDJSYl3HNWAdbjyY0bEKQRgxn7jP+3uROHpmG8NgK8O/et6C
	qmj2ypsgkaPhdCoY774mT//blJ9aSUBVeNFynMx3Nwnz9QbgqJJUHsGdOyl12nuQNnp72f
	kQPzklD+ab17SmLC+trmhzJZzZHTnTQ=
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67L9MKTW3525292
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=EWPICfmisuXNhOObQX5MJ7az+uKvgkfEFOnr0
	vRIyL4=; b=aS+VXbnlWPrTOX1n6dVZVi98Dd+PZthKSZbPoEShqzYnyUIxg/cP8
	+42LAR2gGgRPudP5EUyHzYVnQ3k7ZFdQq8SYiomjZPzXYUDv6TnugtzLEGrWOAk3
	5tjLvHQCDZTC3zYsm41E94ptYEHx5X73XH1FdSqCMDPnefqK6SnkOQCYfAM9LP33
	elxW9o/cin/BzIut8HV/ct3n1i6Hgm/AtAgdGevxe6l7DvCeCPZLWo2sIIqI10IK
	SRD/UEnBrkLBsrabc9HEBIfNRvPBeZf4au3TsmxQDVMpiU6ESRbncjeL5i9SHyiq
	Tr6xN4ZZMGp3MP3pjlXJE2pHjnKvlIRtg==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g6a8gu89a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:46:40 -0700 (PDT)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15fed5653eso54514266b.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:46:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787305599; cv=none;
        d=google.com; s=arc-20260327;
        b=Dls3rw+fbrtjNCHKofqe5u2EjnouM9NKBTRQEh0PrLcZEPWtueyWTKL/R3iOzSbjlD
         NXp2wrR1/lZ3BjGYeW5sHpwxI5dvoPRL17bQ1G+sW/RHZq+JXYY2fA0ictS+xR/73JNQ
         Bz9C8AnftkyrM2Sg24wyQPbG8xso6hA3tc4ztCa+VSNr+21VIeJRjWShUlel9Om/MvEN
         vZw08crMLjgfZSWXgZ7y/a8Jlxa1H6NdCmrgLsI5jFOQibX5QSD9qKsr1CvxdeIa4UAp
         YbdZrZwQ8D1nXxjX9xTt6fjkyPUIlBYpf6+TcmrdpBpTxhcbNOsOqGDvFkuzdnVBPECG
         2s7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=9HkVIzWd5Q7EoAIhoiC25FGWtLTwPi27Z7RdtMF5NV8=;
        fh=gUR7sIq6LZ3ScSz+4p8GM16hQSkHATVfn26NCwqItW0=;
        b=KWYFZT6p5cY4+1BvuFl1i5tfGywRnZiR/bs+ItuXbyAcWvmEm5QsE+u+y+0XgyGHPf
         0+usm37zDKvevKad9umeACdgtZY6HSQMpcr5WwjfpHbFk8ag2yL7/+fJKx3NR/rV2ywN
         asKWazrY4FUrbZjjcR12Tkd1SIVVeVUNl8i3WPOX58dTvoQXC1FGGrt8+c4EMjTzL06o
         pYMkP3DS52EBnmFkFtRcZ+I1VAX7yF0XWF5164lenlnM/SfEtLY62q5kfldPs/JzAJXT
         Zznaeuq0ggvJDfDwbz0M1PJ66TjDrX32FoJe10qyBdE3LWCIKY2R70+qwPpCcMAG5se4
         cX0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787305599; x=1787910399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9HkVIzWd5Q7EoAIhoiC25FGWtLTwPi27Z7RdtMF5NV8=;
        b=HfwdAj31n5N4oTaj583LGeWZlKBmkuERNFMZUoliFIqAESPkcc8IldLKNukgNcaf1D
         shhl4yHD6Ds4atz02gCQOSr+s/3ZhUbHMXac1VG+cAfK4Hs5R7smZJsSVIOc1BONyUZI
         vCF/5x5GJ5WRH9XdjbxvuwffFn8nhYg9FjKl+JK3J1RQtarPGzsEmCA8vFvPxtTdFdLQ
         Er/oQ5T5e7fc2XDqCK1wbyD25jDlcUFJwEWobByV0w5E6tjqgN3Z7s4b6gZ5BUya+rh2
         9Y0Vg6snwRrO8NtrRcR4L2+qKGoOui9ydMU8/xNIYdnK3BUvCMrc81mG3CMT8RqYtZ86
         BQRg==
X-Forwarded-Encrypted: i=1; AHgh+RqxePGB5RYx5ivYbrAKrFBHv5JqPMDScrklwPaxXj/yAhK770dnqITK8p8dq5X4FabB8/+4CJLfxw==@kvack.org
X-Gm-Message-State: AFuF++nElIN+aYBxplz3Yko+kB3Ou5aiYKkiKAGlNufFAXnRMpalkOFL
	pqYprGDr86BFgUER4YTfoJzIUN761Zl2ngAn/xYsUs35umfA1P/sqSlGYX1nglF0BUnH5lRA8Mp
	TLbt4LXE4VH/o0Le2en7RkuNtDYA2xx3Lw8aq0nSXdm2h2t4cfRY2iEeTaZ/LidLGfwsS4MnLet
	3/m0EhOehbRJN+yJyqeGbH5U6TfQ==
X-Gm-Gg: AR+sD11x1HQMbtybYGde7YcXhu44eUxlBgbi829GZs1MqVVTKKBPx0HBePgDLlJjhdV
	N9zQByJTbF2tXUa9/rdonWO8KG26bKKzHErgPWLADPOB/zan9XVfTyouggv/Yspo4ViIp9aqI/J
	zbIwItJzMEZUx8i0rjKNPzj6eiyOTGhhPtTSb9OO0VQxDbWcm4KvI/1NNmL0UKWs1+cpKfRP3+e
	rVfA/GCJYU/Kar04Q==
X-Received: by 2002:a17:906:fd8c:b0:c21:960c:ec23 with SMTP id a640c23a62f3a-c246a2ebbc1mr501569566b.1.1787305599323;
        Fri, 21 Aug 2026 02:46:39 -0700 (PDT)
X-Received: by 2002:a17:906:fd8c:b0:c21:960c:ec23 with SMTP id
 a640c23a62f3a-c246a2ebbc1mr501462166b.1.1787305588569; Fri, 21 Aug 2026
 02:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-1-alex@ghiti.fr> <20260818163221.589352-3-alex@ghiti.fr>
 <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com> <aocfZSYFRvP7_vEG@casper.infradead.org>
In-Reply-To: <aocfZSYFRvP7_vEG@casper.infradead.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 21 Aug 2026 11:46:17 +0200
X-Gm-Features: AcwNN1U92tbMl3QMGUITXTu8dg9Y8CfgfmciuQft7EBeY9k3ATLBAj1TjTK2Aq0
Message-ID: <CAEmasaUmA0Z0j82jF_VnYBM6gsrtDiWSf_ev-2pdYH3xPJ8Yfw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <baohua@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>, Jan Kara <jack@suse.cz>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA3MiBTYWx0ZWRfX1ddo99DF0Zoy
 PyrQHQN4hS8KA6qZTHdeYLlokVTWyYvQ+jyduGi3F1PcxRpCZx300c/i1jw8GylZcaI2EMuvfXz
 h3d1xunuqtSZMRcVMEvtchC7TVAMOwI=
X-Proofpoint-ORIG-GUID: raJO_eCCs7IhKsRiB7Ig7iT_t8QjsKuB
X-Authority-Analysis: v=2.4 cv=PbHPQChd c=1 sm=1 tr=0 ts=6a881e80 cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=JNZ-dC8AXez8hvWtwcUA:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA3MiBTYWx0ZWRfX5sQMkCKBJUms
 Yc8DGpHH9U0xd2Ghi7f2+fPPCm3HYDxeA3papWPUvxCTKG6hkcORV5lKlYsPpmWcqBEbxhSd+tp
 Fl+Bn2VqRyi06AF+uyHuib8qVq5sNtgICo9nu3JUR6o26B6iEq7wN7QBjMwiJs2Ce+xQvRo6rld
 ocmsRoNkU+Ape/AfVUt4hJlao4jV5f7zrjhwKfKNFXuKgpe8cbYiKJFtZj7tm8kBSYnd3BR2VrG
 oJT3zjogLKbFYZISgBu6Z2WG7chYbFXfhDFlbPRRF50J0Qugv/FcxR6qaPn7he4bsbMOLky4ZLX
 076X2+3m2SXVCXXKAfjS1ljWvUO9M3S2zzdC+Rlvih/kAQi32xAS9Zh4RbZcxuPdF0N3+6ZOn+s
 dG5+7A2yrr9l8NxrrTZJG0KZuy9WZUTPsdOBEXqjW5DSNIHxZtJcl8bsUrx5Hf0YTKtlK6V5len
 O6fHUozIEf2+/HxxxDQ==
X-Proofpoint-GUID: raJO_eCCs7IhKsRiB7Ig7iT_t8QjsKuB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Rspamd-Queue-Id: 920F7A0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s9c6ng76gmxyfcehice8g3zzzum7gtar
X-HE-Tag: 1787305601-874475
X-HE-Meta: U2FsdGVkX1/RP58C54yt/5M5s2khDdzcQR4NbWswtx96X3XKMGLjX75Md5dJ1665UiDVXiFsY3De2+UVLZo4YS0b0NgQHzJ4+6J67CQ0iLYDXSgPOIGDMLfCg/8cj/KWoxm7JpInTm0TIT67faZV8K6O929WYvXK8dvt+ZdjSWVLAHAEuGX6N0xlts41G15/VYgfXo1FLkbniho1Y9IBl7Uy5DV5yoldVpfauLm/Zrf+GCnw3o0iBgyUL/AGOPrUu+vHbSANLf72jyW85nNh8Wzqu4usFONODnGPqBD8ToKQhTJ/nkcJXHxwDj7dQb3CkuvTLIHhCobvK/TXbpt+ZBl25tEUrem7LMFgpbZC7ZCasibaWhpZQsQpA2174zWc08IFncNvimjD31xtKn9ztHIvWdw1RA0X258pMCrfEh54eT6oBLNucMG7nEZy7xa5BXC/JyJW12Y7Td8XbqImql6h8d8EHYWKGGlNPNwC8q5Ukn9CX/f907HQbbCTbYm5KwL+qCcPq89AFCra8Bbf3ZzkWC+SMBUWcLzNwlfc5X3TaLvgDs6rLQc8KNjxenyY/BrgG8xsyyD24r7w2nNuBjkiNkUgxWis8vhf6jLxX0+LuyB98ZHqrIA2NZll1WRiojKlb8RLuH71UU53NYzdwr3hr/t2HBAnvf2kSXVay96z/DqUR59qGsmh7Ljh12yUnBycVk/VzZf8a05YebRBe7n7YBGU3Bdsh0UHRpeXGBhynL4JtGrhgLiMaC3UbtPcPk6R47Uv/Nr8elXgyT/lppVNwLHshJDXzUg+8tBLVYXkoKTdNPJIWIrUDu/fiwWYcOI8SJuTl1kYSAUSL8t77GvtB1k9FdhBWQmvH3rdwEXe6vg05ScSEICHwl+CvfKtujqz5MOt+mY/5OzAghyo7g60rA83P02SeCNlDqC4eZj0PbFY3PIuQWU49zfOPpneCCDz/gytl3jkb687ij4
 vjhXfuYD
 9ZZf4d6/36LbFSFmab5bLvHEMYV93m6Kx220txTknmoXIsHcLoAOn/e4x9oVNFweRxP7Vv5NdX4qPAkRSgR+5AQGg04cic27omB0MxBmgTw4HAVyDKIarT8rvsnS/2Ug+iagFea6v9J2NmrByEs6zXW3Px4Zv0j26EjBLT4n9X+/XoixLP9GcKqsXblWzWuVUHErO5a1znP6t9dvRgsafJ/zmHGOY4grra9iAvP4XJxxRUuBXU2jLTypG0YM4v+Jqu1VYax9UoU0B4HmrrxCO5KNacpbAT/Oatt4A8hWWfg9XAVFw0yLi4zQe3c5VswarADbQPqmOBLlV1Yph13LyDLY/30QW16lpTbKaokC8yrm6Sx5Bcc2oYhudwdjz0DWxoGEVTxeBWotybwHuCVhvnfx47irp0y06xBsQqqAz0HjUFDe/SKmsCBFVvNPIY2AYJMDKE/IXL2pixMUGoB177y1o/8U2xVtgB3r8Ki+pTWaOw/CcZ47whIeNXzrXsw7doR9ZxwoT5/PrF1wTmpDxXe0sxSSXeht3aMzI6LZwzfmGVoDr353ubXcu2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

On Thu, Aug 20, 2026 at 5:42=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> >
> On Thu, Aug 20, 2026 at 07:36:42PM +0800, Barry Song wrote:
> > > +void swap_writeback_dropbehind_folio(struct folio *folio)
> > > +{
> > > +       llist_add((struct llist_node *)&folio->lru,
> > > +                 raw_cpu_ptr(&swap_dropbehind_llist));
> > > +       queue_work(swap_dropbehind_wq, &swap_dropbehind_work);
> > > +}
> > > +
> >
> > This is good. For file dropbehind, I see both F2FS [1] and block
> > devices [2] reinventing workqueues in their own filesystems or
> > drivers, while folio_end_dropbehind() simply benefits from its safe,
> > sleepable context. This seems a bit odd.
> >
> > So I'm really curious whether this could be extended to file-backed
> > folios as well, so that those filesystems and device drivers don't
> > have to deal with this themselves.
>
> You should probably both be aware of Tal's series:
>
> https://lore.kernel.org/linux-mm/20260730-blk-dontcache-v7-0-3e8e6850068d=
@columbia.edu/
>
> In fact, I'd base this series on Tal's.  It would be considerably
> easier.

At first sight, it seems so, yes. I'm looking into it more deeply
right now, thanks for letting me know!

Thanks,

Alex

>

