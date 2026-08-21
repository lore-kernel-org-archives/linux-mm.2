Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77F5C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31216B0095; Fri, 21 Aug 2026 05:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07A46B00A1; Fri, 21 Aug 2026 05:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E0E6B00A3; Fri, 21 Aug 2026 05:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88DFB6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:45:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EE0B1C0C72
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:45:27 +0000 (UTC)
X-FDA: 85124793894.08.303F6CC
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8298B10000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:45:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=NxCGu8eJ;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787305524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67xWBhStUlEa5ZCxXGQASV+DpM5l8oGPnwA7uXJMVYs=;
	b=7V5jlaVMFGMms0ufNwr5vB29c2F+dFUfT09WJuBo4DiCljx6iSIsoT9TQTqGIiD7dGuBNX
	uffYYcjPoBj/fST1HNbTrw2XvjkbASBUOPhBV3GoAgyLgiKawCHs4PiEhSeU7ES9IyBNQl
	Tp/nSn1BXt1jrSq78LUT2VSP/lUwi8k=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=NxCGu8eJ;
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of "prvs=6693323b7c=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6693323b7c=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787305524;
	b=3oxnlsHeWoNnwfR+i1738xz8AE4izoCstz+yyqRJarVRSJBMHXADBIhba2pztreWJ3nnmw
	pJSr4QHfz527HeEDEedqR1lN6qPAGz4iQ14fJ9XX2Jgh4tzPr0QxA61MlPf2TWeWbmWF7K
	ZoS6CbG/5lJEjpGccoREoYG3MT9TOrU=
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67L9Lnov3938205
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:45:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=67xWBhStUlEa5ZCxXGQASV+DpM5l8oGPnwA7u
	XJMVYs=; b=NxCGu8eJ5CmY8xTc+8eRhlNpHC6TWP3eL1KkX0I0K2H2qCBm3fwcd
	Rip6LSwpSngQggQBw+qTX2hc4+k3lLrzR3PpauZI5VhBCqhA3s3i2U3qxGNs0fJW
	QYE9sVmZNrHICVa91aFEHfwcul1jJTu3IMJDXQrfrmFvvyHTUt3K2YhwP+wEEpmO
	FlCaA/bkTaqeioWMGa3Sz6TIT/0AgkrSsNJLdaPjFCw6ooNxrAoIOgDMFQIL486b
	Qg89AdKgkluLSkb8AjDlA1BND6aGW4Hc5nU/WB1n2uxctvufTf5faygCvNE2RKsy
	/SpNnJTb5cenrXxCXi149HsM1YQh2/g9A==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g69y3bd30-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:45:23 -0700 (PDT)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a3ef31687dso849546a12.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:45:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787305521; cv=none;
        d=google.com; s=arc-20260327;
        b=SWVIXM2NfXnIBUi+JOjNDuoY8jQ1on5+qZ1uWjU5Aa90K/kcbuhYJNW5ONf7PAPM8p
         BrbI67pnHWIsLSeqw4rSZWq5i/xKhX0zDBUu+PsRfk4zQq8N6zJvWw9XRayc80HReHTm
         aSNN2wqaQzc5dnF1RL0NrdWjc0j8eTCXfRMhfyCsY6r1FzhcQEtODQXqLsTiUvIYQ3rk
         infGY64ydz1z7HG7k/I+yd6ficyN+4rFTpYufNM2gQYKRHreEFyqswazLEYebT1rtzEX
         qWB/Nah+R3Z4c0ACW9pXvRJNsHDjRUHPBSJB1NysLFvi7AZELz3Am+HwoXfr9Bjs5jZp
         Fqvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=40W8wfxklkZeQ+jKlByOaxuR/jIsuDaNHmF/e7+vztg=;
        fh=HLFv5Dh2xoy7Y0dxKKg9AQ+5Oz/X3PGXxMUQCTzp87M=;
        b=I8GNGkvWuRx0RIvj8eQQOvK0VeHjr6k5Cd4gzbC78Vo3iPYLcukxSLvfu57VYLkzAW
         ipKZq7OfAmyIiwIEepliAuqqhnwnc3UzcaFt+AMmVJIyzyO+pbGmwTGB/F0EZJa+3m7o
         U0jO4dlBZXXj3BC4CsafL4KHIl7exRLTEm0GyD7W8fkgkn+nICGXpKvM1tMA8y9pCORU
         QJF41NsJc45WEoYPh2gwB/urpbgqY6rQbRNgC2eSTTn7r24hv6HL7rhotfAMpWs4Vdxk
         ZgJTQw1S/YXmFADgwQ3TSPhA1UvO1kW39EBJRbJRpMEvcmxt7z5Ogwnn2pzHkWTeMwcq
         WAZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787305521; x=1787910321;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=40W8wfxklkZeQ+jKlByOaxuR/jIsuDaNHmF/e7+vztg=;
        b=W2+Zam5Vs5Ps7HrDuHyuumSXY6VW5F0YvwYLiB2WJHer5Zq245WfNbqVFdbA9+bUOS
         8SzGThtSDPI95+V7xXOw/TTJSYJA94CeBL4JOcCoo/SxU2HlA8CigDxg2LVlu49NK2+h
         Fi5qRc44Mu8acyoCi/37zbRm2scCbAWsBIwjm6cGI0zfDrCpJoyFFK6dzFgX+t8mTLWV
         IJj2+oUIp7CbCdkltgZG6UnV/UarzvqDFLGfDmgHO6UOB1+3JNfBjm9FHOqolHGhza2K
         UMSgSXfWSt/VFEoi4qoVjb+nv2tRACpTj4XbvRnpcL4vjV2gpcKH6roVEAxu1zF7KOEl
         eRfA==
X-Forwarded-Encrypted: i=1; AHgh+RpbvT4gLRnyaK7csL8dVt+8Mzg/aSg2TuIyIHBRG1v82mmyntmcTW8SX20WfqbJ+pQWbpCcyfatdg==@kvack.org
X-Gm-Message-State: AFuF++k/NeCGWAlqvC6QhCvaGFoBER8BA5Jbhx3HmEmhLJonE0wkzs4S
	c7/XS7hiMDcuY79VxoDrfcJZ5CXbecp7+7krFX039GKPl3g70uOq8Ya4SGWnYIbD4KGVPj9ireZ
	RixhBnz8vKNHZZG9Lz2wkCK2TWjiZEOT2hG1XzXSn7Hg17VwF8Drfw68+cHjpug0YSkE9BCzXdP
	60Udac0MFE2JL0OU2/z6bOApbHYQ==
X-Gm-Gg: AR+sD12zwz1mnKMYNzgp6RO2EjPtyu7hDLa/qUhZXPMY+dYwOu1VcFLmL3wZ2KtJOaI
	Dg3llb644VLNTcMX/xGX4RchON2lMg4BkhfghDwjeEm35rc8JVgidLxSebkZ1rMXYc86MtJQk57
	ZwpXlMWtdNTc9258XsKUq8PRSluE8p8Ij2v13kZJPIs19BRW1hMg2ibd6Kw5wwSyTx5SMCLG7M0
	lKLZMvikeKy18vcxQ==
X-Received: by 2002:a05:6402:44cf:b0:6a4:cc9:e32b with SMTP id 4fb4d7f45d1cf-6a42f23958dmr4744351a12.9.1787305521472;
        Fri, 21 Aug 2026 02:45:21 -0700 (PDT)
X-Received: by 2002:a05:6402:44cf:b0:6a4:cc9:e32b with SMTP id
 4fb4d7f45d1cf-6a42f23958dmr4744295a12.9.1787305520648; Fri, 21 Aug 2026
 02:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-1-alex@ghiti.fr> <20260818163221.589352-3-alex@ghiti.fr>
 <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 21 Aug 2026 11:45:09 +0200
X-Gm-Features: AcwNN1UIrj5zAkato_eWA3fSuUoLbRh0fjctNdO3VB249rMLFedXk0i2OTg55Iw
Message-ID: <CAEmasaWsSqpN0VwnepBs3TcGydG_C91RNfRnX8V==LSS0mwoqQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDA3MSBTYWx0ZWRfXx9xuX86F2Zym
 2ejtr9JcMI7G0X2JzY9fCuPCkLaouCRdGzV5ePncQ8qgpAyurZd222Kv1ZzL2UTdX6phwH9NDG9
 xmM1bSz5qVWis9vcSJxTrJcz1fQKgyNUUdrz7AGPoedi6rlphxLB7YFazFB30sU/5oXBGo46XAj
 anfiwAW7/zDiMNzMmcUhKTpBHBC8SBOe3KWn+RdBAWw01SRCtQuOodezD9lreonMkQHY/14BIZq
 yZTO+n7aE5KZHduKmTw1hU1FX1IMlLafEiQzmJphKrGEW3r/L6OAtSB6aOv/rUFjLU6JMxI/I22
 fjVjZPrp64rM+q31zwFjhxPpwrCD0vyGArt0M4zzyCYPnaUMYI5UV+AtC2YaKdpmkzOVG3Wtrhk
 Z07wNzpvgsTLjGyQDHHztUBPjYm7c1VvPnkWd5b3IiTZasgJIu24Q5o9urB1WJcdsEzDS7EVA4y
 vr8IRWr/OiYZqzzq34Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDA3MSBTYWx0ZWRfXzhm/jwkM5PZC
 XbAyvnWAjElHZkBwnNLh+6KQI8wOAYimezPNTfgyDtD+3O2EVMDMrdGjOx+fLMKEupOE66j7crT
 DcEpn5XcgUN/yi2nX3/gdvxAkPHVqA0=
X-Proofpoint-GUID: -Tz8jlUPdgtaQBn8--HlCBeTIi4UCtB9
X-Proofpoint-ORIG-GUID: -Tz8jlUPdgtaQBn8--HlCBeTIi4UCtB9
X-Authority-Analysis: v=2.4 cv=efwNubEH c=1 sm=1 tr=0 ts=6a881e33 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=VwQbUJbxAAAA:8 a=mpaa-ttXAAAA:8 a=IeNN-m2dAAAA:8 a=ufHFDILaAAAA:8
 a=pGLkceISAAAA:8 a=XUwypK8endxQsPoB_R4A:9 a=QEXdDO2ut3YA:10
 a=j5kO0B45gQVIxiUYEfTy:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_03,2026-08-21_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: 8298B10000B
X-Rspamd-Server: rspam07
X-Stat-Signature: g9tr1hcmmuocaj8zyfae3bb97bzzkh78
X-HE-Tag: 1787305524-913455
X-HE-Meta: U2FsdGVkX19vUIvCUZLtP2GR3o/r3mGwJrYxen1boo/QhicsZccwfyos3VsHFGXvqgAAyzHndFdyga2HaLDRWRq38WEfyivcEpl75f2VMuIhocd9DGIpPzwg2VUzVHhgTl5kcEoxQJQzCYbc2irbhyYPunSlK8YKnDJFfCURrQzEOy2tQXsQopNsd5oxRhGTBoFXIn+KlwgVpOnZND91KiJrtylX+xW9MACTNWDXNcL6WRq0yXQq7ptYkzeM7Yp7fn37wKgnTYM9eVzMCftlZ+HT+YWL30XGk2WdZilCZehoT6l2guDBeOensZ/0CzTEqs+wizD++SNey6xcCufV55WeROkaMbyxN8ZgTfboyx1rWcXwgfuL6UBB2JcQJuP8fZC5+PTxm1lzg/KFPuDW3+k4JFNWrubvg/GVQwEHMNycR3pLyFDupSYRYJ49bAmHw7KoqAa8lJcktsH/n5h8QFlDES4JZNFhxdIDHVt0QEEfhLd8Tp6CkHGvmXKLeHi5gYjnI5kIDJYFVKSkEVfYIfSsjtS191VV+hkwpKjmO9A10faPk66q6ojdzB751A5RcVbO5Iwms/2i9WzJrNdz2HvsJdG8U+iySfLb+9GvdfdXPqAwWCbpb9xswXIVgrykmKg9Q89wXkD0DEvqCMs1byCSKIq+Zvp3qV29EW4jry5+B81yB1neVlCRV+Gdu9IwFGBhu2xU9MMA05asJfj6N+bjv4qOSBYQaRNce4y9pzOLSCk9fNAfSBYMMSX07EV55CJGYES3feqBXS9uInj6RBpKbsmOmH6/NQSIt/XC/u7DOfE9277gdrBs6+vNNAfLakOqB6nJ22YnWYn7zNMV7MtFwiqeA3GWAHdSVNHfdrnIdeWkNU1nDUTkli4A5TDJ51VpqzHn6Amugq0v0fXReV0r4TvEn48kBwlEjukPb8w6vUaNcItJZ3mS3t3xHKn4RX+PN4sB+FTRm6ZOW6e
 ypVv88Zn
 iDxrnIAi3xWwLRW70Lims+UX77ImLXrheXHQwUj/gbdh+/TgThyfuu5dPDyTuqWZe9+Q0uMZCuf+S0sUvYK2ZqrPdbC3y0EGWPmvSpr3vNPeC4fi80waZwiRz2v/W0ZnLdu5e/kP7pi/IKw2MZdgj51mhDFWOCEpE4JrlzKynuJ4eYAu9pigykw+DZer5WaJsa3ZcJH8Jdt62l/GoKmDwXGdPrnf0P55k58EIs4zuoPH7c333VsDesSzf9U0kq5MBRELIUKBtOKB0m7PlVNV+zmMLsi15eO/0JlAzkiMDLbzi6J+2CCiV7WeihhTwjNxkcdwod3e0FZd3Mfc1niMBli/GDFzx2qrKtDpJBgmLIM/OgxX/z3K/nNUKI9On7bjNtGP5KzbxpVEP9s9kQneFDzub7R8gjxDnPOS1P5mOjhBrqW36pgArbWjLvunkrhhmhoorrh+4e6Bf9qa5/T7v6zbzNZO2p2e7VEVdPYqs+kM8jqS7418shdWmpE/SJbwvjsJ7aWc8VsNGL1AWV209gNriMhsTu2ekm0lQ+65uWLJMnoHOePFfmQm9UPvIi14JGbldtefpe0WUztwIionxQowIU8K+zYQdU2YhNjQCPE0knr/CVpeVqJZ1xQHio26AWn2+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Thu, Aug 20, 2026 at 1:37=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> >
> On Wed, Aug 19, 2026 at 12:34=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> =
wrote:
> >
> > A PG_dropbehind folio is dropped from its cache once writeback completes
> > rather than left for reclaim to find later; this is implemented for file
> > folios in folio_end_dropbehind(). Extend it to swap cache folios.
> >
> > The drop needs the folio and swap cluster locks and may sleep, but
> > writeback can complete in interrupt context, so defer the work to a
> > workqueue that runs once writeback has completed and frees the folios in
> > batches.
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> [...]
> >
> > +static DEFINE_PER_CPU(struct llist_head, swap_dropbehind_llist);
> > +
> > +static bool swap_dropbehind_drop_folio(struct folio *folio)
> > +{
> > +       struct mem_cgroup *memcg;
> > +       bool dropped =3D false;
> > +
> > +       folio_lock(folio);
> > +
> > +       /* The folio was allocated off the LRU and nothing re-adds it h=
ere. */
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
>
> Hi Alexandre,
> Thanks very much for your patch!
>
> I don't quite understand why we only support NON-LRU folios. Does this
> restriction prevent potential optimizations for madv_pageout?

In the current implementation, I re-use folio->lru to link the
dropbehind folios for the worker to free, so folio->lru must not be
used, hence the folio_test_lru().

But that does not prevent madv_pageout to use dropbehind at all,
folios are isolated from the lru and moved to a private folio_list, we
can definitely prevent the latter if the folio is marked as
dropbehind.

I'll give it a try, I had only tried setting dropbehind on all swap
folios which caused large regressions.

>
> Also, zram might benefit from your patch in the future with
> asynchronous hardware compression and software compression such as
> kcompressd[1].
>

Thanks, I'll take a look.


> [1] https://lore.kernel.org/linux-mm/20250430082651.3152444-1-qun-wei.lin=
@mediatek.com/
>
> [...]
> > +
> > +/**
> > + * swap_dropbehind_free_batch_folio - free a dropbehind swap cache fol=
io into a batch
> > + * @folio: the off-LRU folio whose writeback has completed
> > + * @fbatch: batch of folios to free, flushed when full
> > + */
> > +static void swap_dropbehind_free_batch_folio(struct folio *folio,
> > +                                            struct folio_batch *fbatch)
> > +{
> > +       if (swap_dropbehind_drop_folio(folio) && !folio_batch_add(fbatc=
h, folio))
> > +               folios_put(fbatch);
> > +}
> > +
> > +static void swap_dropbehind_workfn(struct work_struct *work)
> > +{
> > +       struct folio_batch fbatch;
> > +       struct llist_node *pos, *next;
> > +       int cpu;
> > +
> > +       folio_batch_init(&fbatch);
> > +       for_each_possible_cpu(cpu) {
> > +               pos =3D llist_del_all(per_cpu_ptr(&swap_dropbehind_llis=
t, cpu));
> > +               llist_for_each_safe(pos, next, pos) {
> > +                       struct folio *folio =3D container_of((struct li=
st_head *)pos,
> > +                                                          struct folio=
, lru);
> > +                       swap_dropbehind_free_batch_folio(folio, &fbatch=
);
> > +               }
> > +       }
> > +       if (fbatch.nr)
> > +               folios_put(&fbatch);
> > +}
> > +
> > +static DECLARE_WORK(swap_dropbehind_work, swap_dropbehind_workfn);
> > +static struct workqueue_struct *swap_dropbehind_wq;
> > +
> > +void swap_writeback_dropbehind_folio(struct folio *folio)
> > +{
> > +       llist_add((struct llist_node *)&folio->lru,
> > +                 raw_cpu_ptr(&swap_dropbehind_llist));
> > +       queue_work(swap_dropbehind_wq, &swap_dropbehind_work);
> > +}
> > +
>
> This is good. For file dropbehind, I see both F2FS [1] and block
> devices [2] reinventing workqueues in their own filesystems or
> drivers, while folio_end_dropbehind() simply benefits from its safe,
> sleepable context. This seems a bit odd.

folio_end_dropbehind() is not always executed in a sleepable context,
that's why I only add the dropbehind folios to the list for the worker
(which executes in sleepable context) to free them.

But anyway, as Matthew pointed out, it seems like this patchset would
be way easier on top of [2], I'm looking into right now.

Thanks for your comments,

Alex

>
> So I'm really curious whether this could be extended to file-backed
> folios as well, so that those filesystems and device drivers don't
> have to deal with this themselves.
>
> [1] https://lore.kernel.org/all/20260820071438.695893-1-qiwenjie@xiaomi.c=
om/
> [2] https://lore.kernel.org/all/20260730-blk-dontcache-v7-2-3e8e6850068d@=
columbia.edu/
>
> Thanks
> Barry
>

