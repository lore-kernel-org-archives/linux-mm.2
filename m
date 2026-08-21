Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E70C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0802E6B009F; Fri, 21 Aug 2026 05:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031016B00A0; Fri, 21 Aug 2026 05:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B116B00A1; Fri, 21 Aug 2026 05:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3ED46B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:53:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47D4C403DC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:53:46 +0000 (UTC)
X-FDA: 85124814852.29.0DDD6E6
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAC8710000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:53:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=LY0XSeJr;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787306023;
	b=Cksj0o9RxUDffTMn4lVen6NFwHVwsqlD6CWtfbdtM5tGk9Rwkms20XpNNwoQdR+P9Spusb
	2DG79ezGOXFbGsygP4e+hsYuieEmGo30xau1y1ExIf+gCvp6KjJLnPtI62bnSnYTZ+Jsh1
	yLk+4rqJgK+UW7L9ZDl5HOqxI2L3zBk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=LY0XSeJr;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/b5fVo2WxJIZnLRI3/yvoL8jlPSjpb9T+ok0n3ErCQ=;
	b=BogqTyh5t7ta1CXfjhgqxgq6/AXMDLn8pRaZADb4b9iN6LoIiKq6+UpyYqu0m2+KrzPBz7
	ykim93eaK+OekkTJhKpRIUfOQ/npy0EkiRbTqodnO3hVCBTbipVDRWYFxVqc2U6bX0BOLq
	h/YS1gPhGS/xkybCrjgLXt1cGWygBGI=
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67L9LlQ83114803
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:53:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Q/b5fVo2WxJIZnLRI3/yvoL8jlPSjpb9T+ok0
	n3ErCQ=; b=LY0XSeJrzaoLLXHaa1OQZqLoVbsuZvyCQJzBJI6Bpc3zYPsHyyQb6
	1CP2XY8YkUqy5NDqVQ3sW3fxmFq8KcAOlGof/gV6uD5oQsmqaz79YSlFeiEjm2oG
	GyaTI6R9M0qOadiiEf3vd3xeNijttySRR7Nbcru0uxWEsAOqGoKfXrtDzEc6Q59s
	8KYgDS57nWWyN9yNJw2mQPOAxch6ASz8ZjT29MSq692FcoF3Dk3cU6W0Zw+wLI7e
	x3jBpNQ9H3t1bIjZqnkG/drNJCYVXeQqew0h5ONCDwxZEJ4ExwV+6CBQAdjUlhi+
	fzFk3uW4BG9nuVSWbRMbblA545jPeFltg==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by m0089730.ppops.net (PPS) with ESMTPS id 4g6edu1t0r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:53:42 -0700 (PDT)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a17c89d8c1so1231362a12.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787306021; cv=none;
        d=google.com; s=arc-20260327;
        b=KNh4jtS3bKSC9BT36vmyur5vbaKf+3JQyf6mYh283yyZYMltpExFaaVI3sI+tKZ61u
         WRB46VSff8VIX50mjGScfnTrTYeNhhPH/hhQQZL1fYgrcsadqFe9wm8la4P1OfbzVAUP
         aIWB1ZyqZ60ynXdiGC5MQDdit0bT55/vxgN9y2qhUq1dUTevM26H1nBDt4CTz5fzo6LW
         1u1NcUPY8O9RtFDXyEo74Gd3yjNlL+2QvcApsFBJaOeW9TGcHHCO9U82fJAPWPVKi1+w
         e4ViV0DipXXSe3XmelEfRqsxTcjbnTVqncexhJ8rWzoLjeIcJYaxbytqA2mAh88sXi6U
         Su9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=ej/zOQeAlckNdnxilgVX/wASDqQzfo0LnhQaPbJcOkI=;
        fh=7GzgmKDzPB7c8PBpUgMERa9QMmD36joWS33U8NKbKJs=;
        b=m5VcdziGpMQ728lqkp+L8ac2GZTMxsF+//pYtCtetsg0rspL2jWdfMK/LXXqJPs8/F
         ypwMlbJUKGb+JPXylPKO7om9h+zfU2OnN7RVJzhZfGgKgE9VDGPy/fuJk645UFCuIHdg
         6uvaj90SeEYFyL6XIqpUBWgLPWzrhXBvqSv/uL/w4M8z5G44UbVkdzwfW82PxCDo/YZG
         fdDRi0ALX18ZZ3WPrbCk8LpyoinA/Bv76W7Qofljzx68oSyzkJYmoWM9kD2FmZ3LZscp
         1Bt04INX8U/tCs08RPcqHbIaSg7HSgF3wyCj60dTRJ201SegUeXnOJwbDpyDoDEZwib+
         0xJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787306021; x=1787910821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ej/zOQeAlckNdnxilgVX/wASDqQzfo0LnhQaPbJcOkI=;
        b=cTwTmSkwKtPPtHxP/zGYjZgRMZ6j3uaZ9f8pgs4RHy/3Bzxn8+1v6ctbwmeEQUteU6
         b/MQsf3ht7NsnaY2amoDlL0QTvCOMMI02PgGXnK6kvY673+SWMjBnNdUyO9o1sjn77bq
         6QcQCX2fqcRZskEigUmG2SiyTs0uaSSTY6UqxVMtDc7kt0vMQGHClc+QgMsnSSuIbKdp
         9of/mmLWwDe8KvnL48bYg3TJ+0oS519AQU3M0sB5BQCDQeTl93ssSyTuXCTjXpxPDAxe
         Mpl10PsK1V1m2ZmN+sH6jOQw1b0NLDVQmJpjUmyogthxNik9MJsX9Hv29oduQcS1vwVf
         5aZQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRCjIhU/1CM+lzcTB+MARcSR2p8fa/JDY0Qj9/RTJpgM4LaNxcdHmVTWn6hHwG6jCmkbMb5qa/GA==@kvack.org
X-Gm-Message-State: AFuF++mD9AQh+Zpo+wyz3tOG+5NWPvPJCB2THRj9tbbY/Qq4Bj42bEPH
	mrqBwHSDfvFac4mpDPUal58zrSqi80K1xHmjhjnnPYihiOm1ZwhwxX3+Zm2RZVUxtMWDiBkRNP0
	S0KI/kU1NXcrDv7FkmkzX+1ug69QVfnx/WYHWTVHdKym2CT2vKn/bkIZLgDcFzalAWfFjs1fUe0
	SKHQdfcORuJS0GN0yUOKTm8KUNqw==
X-Gm-Gg: AR+sD12uQsrAvdSJ9ZMsoxmBimvlFvmEOc7xApL2YcoLFCHTrn33rFotdE+GHBNeBJR
	GIuxWn8c7O1HA7IiIJiJD4ZOlbfCBGHVTQV342M+0yu5ThhAxULtBQ8LThgZoknfeNNT1ERyC1Y
	botOl46bAfsXRboLSmo1k9Tu4LRsoodJouG637+spLkp08V0CG1viT7zTsdqvrkc6/GARoXpxPS
	KR8+kFdPvVdYpB1rA==
X-Received: by 2002:a05:6402:2353:b0:6a1:f95b:8cef with SMTP id 4fb4d7f45d1cf-6a42f179014mr4703998a12.4.1787306021567;
        Fri, 21 Aug 2026 02:53:41 -0700 (PDT)
X-Received: by 2002:a05:6402:2353:b0:6a1:f95b:8cef with SMTP id
 4fb4d7f45d1cf-6a42f179014mr4703944a12.4.1787306021163; Fri, 21 Aug 2026
 02:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-3-alex@ghiti.fr> <20260821083500.856970-1-kunwu.chan@linux.dev>
In-Reply-To: <20260821083500.856970-1-kunwu.chan@linux.dev>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 21 Aug 2026 11:53:29 +0200
X-Gm-Features: AcwNN1VwPpnVY928RhWmXd4qrgisMWDu8nlBflGB812tXUe-FhICPDNcvqK498w
Message-ID: <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kunwu Chan <kunwu.chan@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
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
X-Proofpoint-ORIG-GUID: ljAjNQkH2eTzqLOCoTqvhDq15JAIvWEu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA3MyBTYWx0ZWRfX0zV0X+YzU0QG
 aUV+vFv3qBEEFO3mlFN4U4gY2fikCQw9BLa+jtLo2y2BiQy0U8gTOXoFqRf0kaBnaIKs+1N0Pkv
 5+rlnMVNxh1acYDIuu6DUd0Iqlj17/YdQfAj1s1jqDYpu1BTHNpXyRQLYatVwtEf0YjZ1FzxnUB
 ojUhc2vvPJoDcANqQin0wy8XioWJxRvTBOM79H1mnNrPM/lE/vKvXdSQKExGTAy7lxBwYLB3fYt
 HGv+UjveBf4Pmn8DCOzFXcdkQGmwhP29Q5pmDX6S/GTCmyYrm/1oyKTCDWwsFqSzANQIZp9IW/6
 uIMFofakMx5Px1o6xXhTyuP1YUma9drg7MW57vvRzZIrrF1OUDMWf184+rJrhMs8S2oHmgBxPcW
 jeUGm3wxQdu+Y1exTpXKseFjcgngwks97+7HjId87JjrUoqBfVxm734M2LTXb/WrXRbI5Ec537A
 7zOcus5dYva74c5bghw==
X-Authority-Analysis: v=2.4 cv=CaE4Irrl c=1 sm=1 tr=0 ts=6a882026 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=855S8uPTkML1Oy45N9_h:22
 a=pGLkceISAAAA:8 a=aLlJzFw6OyoQ_NU6FLYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ljAjNQkH2eTzqLOCoTqvhDq15JAIvWEu
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA3MyBTYWx0ZWRfX+wcGHnTkxVns
 JeEKOu5Mww7G0dFkTyI/ONlGJmvBDg7twkW6oF7WGeJiqaXf6sJ0WhKjmZKqaPDfM4Mx9kNIRLw
 CC7Vj93cFI+HXesJnVz6HNm/x9o78ac=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Rspamd-Queue-Id: CAC8710000C
X-Rspam-User: 
X-Stat-Signature: pbbai3rgwfaciyqyj6u3zeejn8668imd
X-Rspamd-Server: rspam06
X-HE-Tag: 1787306023-39561
X-HE-Meta: U2FsdGVkX1+0bDboF6MsbmWNXdKqxUD1jYyxC6nlu0ciQFcRHFfWwFv/7kmTNTnqW+Hlvq8n7lrQopfs6VKx/voM71B6D/6YEKoTlf9cwi+1th2+ZrBNwVoRR6llGc/LWQfr09PRt2fousupCCkUPuHakB2QomHSQpshgfAqu0AKx1oEntdsVKLyh9zW53hDmJoFk9nodJCBEO+wLOguTwjaRpwpN+canmg4+X0GInE1BRiOVxND+4m7o84E7286nKjXp+qSC2ox2ucYw9FdTqglqaC6dJpgodcaQGftoAhVlEo+anDNIp9jyZEeNR7YD9Q4cE3t0uuv0KjUmdNA7LabN8ALaeBMRlQ1JOO1Pk95in2BEPoYgX5Ry0Ud14aFoIKBMw9o1/rZCEboWQ1aw93LsjwMXoi28wH8CkEIL75etFQ0cghKCA+080xkk3AohNo6/Xv7bOUTZzKEbwZGQaBCybM54372/DvXE3h34ZpI3jy9jRgu293MlcNUxfum5LpPEEIcALqeUPOSscXGoEUefUaxSSy28IKpe5+tc00wSeFUexvx2wVPf1Gbhw3TAoICsQ7K2ZDtcmSlZI69uY7ig0YA/hjcJoDCuw3l8lZHe1qLBP5h34BMCp1BKke610tF1A5eqYC532IP05uf2MyjOgG32UXGTylUOuJToBSDTspRttf3bCzqCtK1L8CSVNsfWoquBJoZ7k+RnxlrF1PWk6SQ2FOVIZxCSeTEufLJsR3Z51CihlmEvgRm5nD74RSWW8s8ba9UIOVTqceczNEPF+gMtn/GVSTHUqxn60djiPD4Dn7GOUCW81CJzh6djMO/4f12zaRpWwpFF2cNjd+BoGfSxdaw9E30NjSetMP04S1mHd66tbTdNM7tmnC1GnoD9hdBgKRBoLJ17jLvXVhmaNxxRIJAnF8454ljROcMBzWCY5frrPLSCl/qXVl2EyeAVQgd15Nkksc10z/
 inRDiKEK
 s73YJPDY+W66PqeKN7JOPtgP2DqTde72X7ddcUI1PBEoKcNXErGyWINbeb9HHXxXHZAnZf0wJssYREh31cC9xrnULyVxngdwMnSXWEzNLNS4NTuxHMih+sc53Gz7hI9nwhUFiIi7MJrFwNzSYN617lKfn2wsXTHZDLAxyFAH0IaM/KOzrjPsR1wo4Vr9SKINF7ixO9IPBhvQrSCY9aDCdDDEbt5N/+1yCT+T+4c6S4Cd/ky56ti4i3jQu/YqBOjBTkcpEzNBUpY1a+pKKu6zQgXEKrnMDJxoL3jJgw/j7f3TdWoaKonIVkyZUoA9FaymnITZ26HC6mgSceshW5RScfenMGV/QTk2VuQouK1zgRRXxEUwKm+H9XWbZeCbXE3XpVHhTq5T91AE0Uhou3MZIAQPv3qgIxLRxhH6oJdSyIDDEJx438lLvOWJNpqBIQ21RTxWkpm3A73uBRBfKYb4CNygO8R3XnpiMP0oMnt9d4Je8bu6hGN/0fQsPHO+mzNcN2QCmBZ1RqsIqZU+mDJoBRtRdSdr+5tSX4wph
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

On Fri, Aug 21, 2026 at 10:35=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com> =
wrote:
>
> >
>
> Hi Alexandre,
>
> I have a question about the reference ownership/lifetime model in the
> synchronous-IO case.
>
> Consider the synchronous writeback path in Patch 3:
>
>   zswap_writeback_entry()
>     folio =3D __swap_cache_alloc_folio(...);
>     ...
>     __swap_writepage(folio, NULL);
>     folio_put(folio);
>
> During writeback completion, Patch 2 does:
>
>   folio_end_writeback(folio)
>     folio_get(folio);
>     ...
>     swap_writeback_dropbehind_folio(folio);
>       llist_add()
>       queue_work()
>
> With synchronous I/O, is it possible for the dropbehind worker to run
> before zswap_writeback_entry() drops its reference after
> __swap_writepage() returns?

Yes, totally! The window is short though and in that rare case, we
would fall back to the initial behaviour (almost, since we put the
folio back onto lru but not rotate it). And for async devices, I don't
think it can happen at all.

>
> If so, the worker will attempt:
>
>   swap_dropbehind_drop_folio(folio)
>     ...
>     remove_mapping(swap_address_space(folio->swap), folio, true, memcg)
>
> while the caller's reference is still held.  Looking at
> __remove_mapping() in mm/vmscan.c, it expects a refcount of
> 1 + folio_nr_pages(folio), but the extra reference still held by
> zswap_writeback_entry() would make the actual refcount one higher.
> It therefore looks like folio_ref_freeze() will fail in this case.
> Is that the intended behavior here?
>
> If the removal can fail, the fallback is:
>
>     folio_clear_dropbehind(folio);
>     folio_add_lru(folio);
>
> This appears semantically safe, but it means that the dropbehind
> optimization is lost for that writeback: the cold folio goes back onto
> the LRU and has to be found by reclaim later.
>
> This seems particularly worth checking because v3 intentionally removes
> the synchronous-I/O special case from v2.  The cover letter describes
> that special case as an optimization that was not worth the extra code,
> which I agree is a reasonable direction if the generic path is
> sufficiently effective.
>
> Could you measure the corresponding fallback rate on a synchronous
> backend (e.g. zram)?  The 99.996% success rate in the cover letter is for
> asynchronous NVMe, so it does not tell us how often this particular race
> occurs with synchronous completion.
>
> More generally, I'd like the reference ownership across
> __swap_writepage(), folio_end_writeback(), and the deferred worker to be
> made explicit.  If the caller's reference can overlap with the worker's
> reference, I'd also like to understand whether that is an intentional
> and acceptable trade-off, or whether the overlap can be avoided without
> reintroducing the synchronous-I/O special case that v3 is trying to
> remove.

I need to look into the patchset that Matthew and Barry pointed to and
check if it's still relevant with this patchset on top of it. If so,
I'll add a debug counter to confirm we don't fall back too much for
sync devices :)

Thanks for your comment!

Alex

>
> Thanks,
> KunWu
>

