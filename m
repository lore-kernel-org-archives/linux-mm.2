Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E41C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2196B0092; Tue, 25 Aug 2026 12:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2ED6B0095; Tue, 25 Aug 2026 12:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B17B6B0096; Tue, 25 Aug 2026 12:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 327B36B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:58:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98F891C004B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:58:03 +0000 (UTC)
X-FDA: 85140399246.17.C35ACFE
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20E11C0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:58:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="UYo/pK6O";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=6697db029e=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6697db029e=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787677081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=loWudOev40SaMy1gWOxNzMQ9/yXEiAhMPQP2s1OUbAQ=;
	b=ORJNfOpUXarUfl1ZnLaMFpRkVHOeKx5YupOi7PfrRqbO2vkd/9kiL9VnP1nh0aeiH0nQ5Q
	qS9qSbFUdYWR3fiuyMq78Ld71BzdV1PNpSQYGcOF3Dxk6ZAO4PU8/9doxs46eFALs1RxDH
	H8TSNzV+KD/frTpSc3cLLR2CtKe4BVo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787677081;
	b=WFWvFlkWQ7Sir2LO0yL9sTn+Vy7gEknh9wiTDQmGgLmMLdEfxfnpFtUjbDsJw4Y6LeNaVY
	MsHtHoH6a3PHvBF093gxUzZP4otBEn22bx4ioVeb+6uBTE0+l8QD6RPGzB2lX+9EoL2DPJ
	yutXgGYIifNwtxYc7GL5UNpBpZ5xeJM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="UYo/pK6O";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=6697db029e=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=6697db029e=alexghiti@meta.com"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67PEZeoU3530144
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:57:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=loWudOev40SaMy1gWOxNzMQ9/yXEiAhMPQP2s
	1OUbAQ=; b=UYo/pK6OQrzN9pDz924Eea1oQAKLPKglyIsf/4Z5EKtFnDRcd3dnl
	DC6nBKUMFY3Y4SO+9pNsBEtIVKlOunHZo9W3uZ/MevlaUXUcjSUoSXf3iZagWNX+
	tELBntBQotYgyW8daOzfrCwgAKs9mZ3IFIkYsiCsoFrtmbyjb4GJL4EhR7Ua9gpT
	EM1+jCtcmr1/f8JJe5kf3e8a/SFgIrqueSi+HgYEs+RwRiiD6IhnlprCl2aImAKY
	7aXPY2Bftkw5BkFMqfN05PeqiYcf29dFPOuSLzhXDqYY85EMn2inO7HxEUPp1eEq
	JSE8Hw4y8dNGFkblq66pNQhzxdSrue0Cg==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g9cek9827-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:57:59 -0700 (PDT)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a14f2e8c47so5927752a12.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787677078; cv=none;
        d=google.com; s=arc-20260327;
        b=BGgePdqa7iyh+hymtsqadg6IYM6tzspB5P0W1cLXIFqvf/PEahGMa+vu+UA8HwIQdX
         7/IJS4SrnlUzKqX9uEmIjHZVNFWCPzSwsNOiplpQ8mynVOewBm0IeJ52c9DN4blQJPvQ
         S+50BkF58Yrt81FNGwF4JnLbk/vvnjNfwtATeuMrlJZWP0g1lLMZsz7akmR5zcZKC4dB
         i5XL9v0ax2UXNP43UQIOLG/rZApMf0DunuhZYG7mbcqp3OwyMp+WRNqddKEfrfqDbRcu
         +8nMnCN+zaZJBwTv3u3kiIAGCoE/pY6U/WCP764boXoKL0EVHwL5INSpu2hoUwxNz1Cm
         jttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=mN9rywOUvztkO2ESvsNFKcV47QutDX1+/ahyJs+xJwo=;
        fh=hPKR5fiJ3ZnuWRj1a6LouYC5cDpMc8CSnNe+jeij9rA=;
        b=WnXLibDKR4gV+XAneC18pSx8ntVFI6zN6P8e4tnZ0WrzPfJmohemHtg1KYkS4r3tfW
         vi5G1i5JcFAU9oTyXAZ3Kq+OUuil27+Jf7ZUB2WcCa62GVyRDsxqfLfsdhNdvEGZdBU6
         9wrlMW9H/cegfXgMeFK7Ih3yd4WUgYUIEWDAxNKGmMmAyBFwrlQA0pqfkeFYeGLFgfir
         evpMsy9vw/p3P3VJUX07sWF3n/+VQW2GwwUG0XnpeUM+Ck7328xdmSqShOl4eRdNVUNe
         K0O4thjTunq4XJmyhI35zrcCqE2ySZzQRTi32altzRXqYnaNh25hUfyxFy+1VDVmmINE
         Lpxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787677078; x=1788281878;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mN9rywOUvztkO2ESvsNFKcV47QutDX1+/ahyJs+xJwo=;
        b=IAFJxKT8thV5OL7bwCcFT/qMQFoytNrUHONMhhvqrNayNFwnt0o3FiRY3kmwA2VNxa
         q2KqfcymUBvz7P6Axtzwv25cZlqsCyDfWD3h3iRfYKY96PYjlAJQjUm+qBSPbRYtRCxE
         Bb2882vKVusJ06i9fYkoKSyKk9EHZwr/tOVrAd4BfvCNEbDH5IKl85/2kGtgsyQo/DtJ
         H8qHvZIpRMFiqovgwtJpP7envktM35JMAxjmYG9goKiXmRTn+YY0ff8Ozac5bLUkO35C
         p8b4fLJok89R5h+bfz1snGRFYArwDKWrE7XUap/luEQfm+vrse9d8EKQnxHc/PUhSq/q
         2ISg==
X-Forwarded-Encrypted: i=1; AHgh+RrEoPzlRBrgOsojE4Nik4QJTslpC6yh6esTCv5RcBWHkQHpKDqgX8oC0oP/pR8f4g8nEo6Bmx1qaA==@kvack.org
X-Gm-Message-State: AFuF++lxzWQudcwbU/VsPor/8xuuB9jEYv3G0jbvXGhCxqg8Wnwtt1Pn
	UarBm0rwmoKGRAHU9CuMMAtZtMy1MaOF1kCxEw741Hddd56pMk4zSOfjWGXP9tPgFvwMD8jI1oD
	x/OkdEYQ80gHqitxhycZxKotT5eOtxxvrYC0waNEV8U8kGm/5obuG8e45ySwCcwMQrFQD7jgg13
	VCIRWRU4WR7gE9PcxAfw+sUv2dcA==
X-Gm-Gg: AR+sD12YC3s2RO+RZEN+MeadkWGV05HN6+wiJUATvDAth5q8w8XpDEC+gjc9a/AK1Y3
	85RwMc3I1V5oSRzfJ5Eppl/tci17dSWqFHpMBQepADWAyxNheBtoZeVA0WVFiNEBivdMfbvTjeY
	hVoWmjKN2HzTrJMf7sbC8e1M7F+PUS+u2zDhBDD3aFfoAWtAONN5AbKlcxxfLtaFLZVVzexw2/
X-Received: by 2002:a05:6402:3811:b0:6a1:7825:5230 with SMTP id 4fb4d7f45d1cf-6a5df64f1bbmr284130a12.16.1787677077973;
        Tue, 25 Aug 2026 09:57:57 -0700 (PDT)
X-Received: by 2002:a05:6402:3811:b0:6a1:7825:5230 with SMTP id
 4fb4d7f45d1cf-6a5df64f1bbmr284000a12.16.1787677077319; Tue, 25 Aug 2026
 09:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260825135209.3135169-1-alex@ghiti.fr> <20260825135209.3135169-4-alex@ghiti.fr>
 <CAO9r8zPsQ9J_mL-eYiNEZNu1LdxoVXL-mQ+=QMUvcT_71cf7cw@mail.gmail.com>
In-Reply-To: <CAO9r8zPsQ9J_mL-eYiNEZNu1LdxoVXL-mQ+=QMUvcT_71cf7cw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 25 Aug 2026 18:57:46 +0200
X-Gm-Features: AcwNN1XA-bGiBg4PQPCXw-lD0CMT8QITJ4O8DKFXilDnbFGAZj44avzq3h930NY
Message-ID: <CAEmasaX6L5Rghr0QSkv_x7kiJ9U-MaXwNBntePCkQBoyjOtP5g@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
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
        Kunwu Chan <kunwu.chan@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=ZtXd7d7G c=1 sm=1 tr=0 ts=6a8dc997 cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=VwQbUJbxAAAA:8 a=ufHFDILaAAAA:8 a=pGLkceISAAAA:8 a=hKD1uaKRyuBWxXnh-LMA:9
 a=QEXdDO2ut3YA:10 a=1oAhN8tkTtOBK6_UvoHx:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI1MDE0NCBTYWx0ZWRfX1MdKWuihWQ9x
 fUeQRXHlZyNUyksrNERUhRSmQr7jJAzBuyJAVn7eQrUvL7FAgtWopj89wfJhyeMqVYe/nrktl3+
 TzrfSbAQ2aOAcQUWPSotbFKBJRdp6k4oo5IPdwSAQfL3LpPi40G08MYm5Ry0N+Mx27ojAHK2g4v
 LGJZLsTzvTaBOCJn1/SlG7QIzLYrd9ANr8CkqFm7Ksks2RBr8MjzetKYBxFqWbZ1ab+ueYcqZRs
 69LddfLgJgoCMfhYiM3wuY2PTkPn5eAA8N3pr1LNf2SLS542Vk5yxF7Fk3PeZpH/9NTJuWMMHx7
 /XZK4vp+TC7ghPbHa0aRC5I2JWmdiOuDlzWvJvhNE9NDXAm+VVc4TV6f6jLUrWtbf9HG+HyhvQ8
 CbnVPFSdGEFMJ9fr+jaA7QYA+v9BN3P6HLIprncBYt5vnJOUlBKxK947CUszMpNiNedQmo+WvHl
 bEM//Pa2uPGctBj/9kg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI1MDE0NCBTYWx0ZWRfXzGo1ITyjfVqv
 72o0Dn/RQolfu6uZBriDBQnknMsYgTK8o0GM0JSPHpMakQoU3cqi0g4NyepKfdfi23om0Nv++py
 Cm5CgAr6diAU1Vo4jkS6zKnGjOTQOIQ=
X-Proofpoint-ORIG-GUID: y8qqFf1UnT2HyKU3ADwUnaRgxD32IxtC
X-Proofpoint-GUID: y8qqFf1UnT2HyKU3ADwUnaRgxD32IxtC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-25_04,2026-08-24_01,2025-10-01_01
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20E11C0004
X-Stat-Signature: u97pzhbt78tohdmz9rcigqcp3qeopd7y
X-Rspam-User: 
X-HE-Tag: 1787677080-895754
X-HE-Meta: U2FsdGVkX19nI2nxIfNjTInXkRH4h/aN7J6rNX47F/4Fkwe/09qgSBG0Ii4Idqmy+boHvdzCj8vBkyOXilrAF1zSlwL0zpM0l9nMjFG+7kHvp2SslOcGt1fA14PHwUuQ10RTXgqJL9z1W03eNEMbB3zP4nTcy+bJRICxUU0pb4R8LIe7/8hlP8VpDa/nqrjyJBZ9IRhavY3tLhn3k3XaXX1SR1CNYCuPJwBwUDQzPKpKba9VQFFa9LoiiZMzWqP3TkdEjnPyL6zLKTjhqAi9lPl8nr+0jUIymB14ar72lDuB2HPnRIYNwB+W8/aYr2Ag+EWxMu0+PC3n02QeaJHf1CKtaYh2+pwFB06HfsI0hM+ZK6PisHLaPNjYpWFC6XmEDA+FnPJGa03efTCPzGvQND+tDrMkKoc1GpT1WThhuUezcKNV8iOGIhYExxS3//W1zwdQJL3zr/Pqt7JbrRmAaMbb8wyA/PUc/NUO406wnajlu769N5AI/8O+AtH8EhEImJYLquZhCG1Y1ENC3mHdzhCtnB3VMwyPXOGQpl5Oo0A1uRluz/xzuAcH2wGUIj8fWI9ghFPS20JgIlBy9zUdEvgT+dOrEvQ5f/BqXvT8dEdYwOT9rM0bNtsiafOXMHcN3aADBkUePPeQdIlskCQWS+CK8/z6AI2AGgftoChNw4iIgeuJriXPeHIDKAI7LBS0Wt/04dbZDD2sQegbvtgECwAgvXcK+1D2mddQJ7Qd3CZSjotC2IvemuvUxARHmCJoY2v62zr/wYYTzaBoYfKFaTFKCHgNpIZxVZHEoLKHL/ew2YdsyFaB/Mi2mU46h7GBVlvPvrJXek5fpu355GSMMhomSoype9iPXJcMY12PL8pAC+LKanqo4IfjajaTRnGF3ZzlZHZwe8A0AC1IZdOXBw53ks6aNl7WiKjXsIsSOlziyKk/IYChp1cAlWRzkgavwvsmZTz91n8nqMfTl5P
 vvuCzfJQ
 bS3wGhfdyS+fI71fgM+vaG+OLBX/tutyAeM/IEq8I51RuK6RVVgKZsNa9WLYrXhQUOXZHD2Ph3TxtZUob/+8jDHRixXG7WFfN9tTigCiHRfXGZNMxo/YgS/c4FotGWfJgsuFa+oTBhARgKsUl2CMRDA+Vbvp6Q4De+25IZIrfCSBW9B6N1Tqm2UA0qGuPi1DGAqsCQyLscq656hZleMR0jyBXsqw8E4xGwWlHHUVNu4+sPt9l3sXV980g5onf5rjJDT2Edb5McVoXJ6cWZM3X4u62rh0/dtvBOYxX5ZtDt++I49ozCMU8G6gjR9uCp6J2jxci8FDrdML8z4jjyKpEzc1asSSFLyUFDo0SdqhQmejzpMvhyWZ5UfL1aGLzMDzPUB94ZELDqL38WqaqZf1s+yTvA+7Q6JmDcV9J+WUF3jU0fDk7qyVKJrfaoEdp1BVpuNI6cARiF03zosVNFe03PcYZDcPK22DYuRTcGk5d4S0pI5VTZZZnJ1DRC9zGL9/en6Rzm5aqrDUTh/dnGGq23w0aeJG5ptZKPlbkWA9CoYSO9YDA0aX/4uqlGcgjR3TceXFtqAqG9QDFyVsnPN59KCSCNRleDcNkLkj5ysvL8C+iyCu9HYYFmnj3icTGKxLSw1o4rVOuF2fuBrFWJzRQhxq5v8GAsYelUKcj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Tue, Aug 25, 2026 at 5:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> >
> On Tue, Aug 25, 2026 at 6:55=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > zswap writeback decompresses an entry into a fresh swap cache folio and
> > writes it back. The folio is cold by construction, yet it is left on the
> > LRU for reclaim to find and free later, wasting a reclaim scan and keep=
ing
> > cold memory resident longer than necessary.
> >
> > Allocate the folio off the LRU and mark it PG_dropbehind so the swap
> > dropbehind path frees it from the swap cache once writeback completes.
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/zswap.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8163e6c5f76c..d16822a516e8 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >          */
> >         if (IS_ERR(folio))
> >                 return PTR_ERR(folio);
> > -       folio_add_lru(folio);
> >
> >         /*
> >          * folio is locked, and the swapcache is now secured against
> > @@ -1046,12 +1045,26 @@ static int zswap_writeback_entry(struct zswap_e=
ntry *entry,
> >         /* folio is up to date */
> >         folio_mark_uptodate(folio);
> >
> > -       /* move it to the tail of the inactive list after end_writeback=
 */
> > -       folio_set_reclaim(folio);
> > +       folio_set_dropbehind(folio);
> > +
> > +       /*
> > +        * Drop our reference before starting writeback so the swap cac=
he holds
> > +        * the only one: the drop in folio_end_writeback() needs that f=
or
> > +        * remove_mapping_reclaim() to succeed, otherwise the folio is =
handed
> > +        * back to reclaim instead.
> > +        *
> > +        * Nothing can free the folio in the meantime: we hold the foli=
o lock
> > +        * until writeback starts, PG_writeback then blocks swap cache =
removal,
> > +        * and folio_end_writeback() takes its own reference before cle=
aring
> > +        * PG_writeback and donates it to the drop.
> > +        */
> > +       folio_put(folio);
> >
> >         /* start writeback */
> >         __swap_writepage(folio, NULL);
> >
> > +       return 0;
> > +
> >  out:
> >         if (ret) {
>
> This check is now unneeded as ret should always be non-zero here, right?

Yes, I missed it!

>
> We should probably also rename the label to indicate that it's only
> the error path. Maybe "error" or "fail"?

Sure, will do in v5.

Thanks,

Alex

>
> >                 swap_cache_del_folio(folio);
> > --
> > 2.53.0-Meta
> >
> >
>

