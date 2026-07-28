Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048FFC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A766B0093; Tue, 28 Jul 2026 08:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D727A6B0095; Tue, 28 Jul 2026 08:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BCC6B0096; Tue, 28 Jul 2026 08:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90DB56B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:58:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B5988038D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:58:56 +0000 (UTC)
X-FDA: 85038190272.21.BBEAF77
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AF2D14000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:58:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=Od6U0Lca;
	spf=pass (imf23.hostedemail.com: domain of "prvs=66691c787b=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=66691c787b=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785243533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXl3Dygthf2hrndTRS/55sXaTkDWj3llKR8jZYjv2Q8=;
	b=f4m70Z7WVM2uWuexrjHOGmRVR78PkDsNLA75HX2b6DVnsJwdO13dltxkbA8HkJ3hFCihgP
	xgUYrsMS3wAxuu4AR5xm5OhGTYeH2J3eCqZN11pOfAtpFRVxb3NDzSARPDR7iXJYCSfW5X
	fnkVRVzHNcITpJwSMVEGcQPPPh3i7eA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=Od6U0Lca;
	spf=pass (imf23.hostedemail.com: domain of "prvs=66691c787b=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=66691c787b=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785243533;
	b=bKRCC8OJ1rUyFaE/QqlG5KbnzcVcBhMeu3RNiYNOpR4wKOW5QzAq0L2uv/54xlO4PkCGBk
	iZ+tK29NSFTvIB6NQez8VLfszTYAyjm6EZExGCqpTngdHj2eH9jI+PyzNH2QF9OkrWSzPY
	NJ7EE1ImviRJEILdDhwiR+OoJAJwVoY=
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SBGY3k132032
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=SXl3Dygthf2hrndTRS/55sXaTkDWj3llKR8jZYjv2Q8=; b=Od6U0Lcawfj7
	nyAmUZX7J8TEJjSp9OoQjhRwGJuGj3EIgBEVGlv+H2SpGDF9qK/F2R/ENWb8zOGh
	OJOsFuH5mD+fRR22GH73n1w7jqQrb9t5YhhfuCJjggGHGGERMBlaXOhPS8hwtWvO
	4fyMfy1x+FwP1ugAC9AUqUhSQI6fYGO847UppJNhljTpSz1ijkb11IrnWn7jM4bU
	FeJ5xHckd+LucTRbAG7FNyO4sbhIyiwyObgp7I7/IZqXlewynDRqtczCQRqfS1JX
	bQgGQVLw00Nmydf/+yBxDP76WpV3pql47axpi/J0xEm91AyECxlxsAKWdlx1sRek
	Cp2T33JePQ==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fndshmwdn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:58:52 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-698b899b53cso3309831a12.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:58:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785243531; cv=none;
        d=google.com; s=arc-20260327;
        b=IytqXoLObIBNoOWAYT27e2IBBt7qqRPRrtqr9IWmnURqUtFNntPJAgL63elSVtOXqA
         1sPU3K6g+Gzc4WW2ZuhWzi8zeQouw5/zKhrVs364lHrlBBQdMq3snRJdEoxTRgvuf/av
         J9pfqG915KGjG+B5JbnMQC9VwE8ZsGOwt3wU3mnwEF1EswH6OgaA5LPIc5DawO/AsDB3
         dqYIkc0pj4OUEBrn7N2yaF7Oxd/dAY7vz+6YqmSd4PajHIUG1uzPaUPGes3TUKdqQXP/
         DUVNhiOQ/tSNBeBP1+mW9Ao9KTeU626nRVLn5ozQnzA4sDAPZuk8uG2VC6vGntC2xUrc
         nqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=QhugU40GjKcu4+9ufgNH7Pw5kuHqIDfQcoIE+6xGOXc=;
        fh=HZgSAGo/f2YxT4ATD7tamIyx58RJlgeIIiUf8oo1gmM=;
        b=FM8i3RcndQkK9D8dE9vTkOzfGd/xxj6UaYpD+2iXxxP1nHMIo4DAcxBNewqIGxaObg
         BCUo2NgXvETYHU8Gh0w8+Q5BebUJKuYixW1DrVteXt7WUS6fP/whpEpXlO0PkrtNti/o
         CIsqlaRgoV+oxLgpx6brp/0SbKZrR9OGcqL9ONHu5niALmFrsP5F5VyCaXGQKzCK+ARh
         /u4FCoHgYdv3gIHtUbwRkBT/lHM+DSoe4miOZcUkt9Bv6aT1Op0xu2548Thg8fcZC1kf
         mCYGqWpzY7RDJakRNLFgsbrcv1fwWWOCv5+87bkS79eVL+YoKuFCVO0YZPiVRftzUTsw
         hZng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785243531; x=1785848331;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhugU40GjKcu4+9ufgNH7Pw5kuHqIDfQcoIE+6xGOXc=;
        b=fnAupSVzlufwrJ9YxJpWtUGpDa2NJ41Pvw9Dd34kyOOnMHuuYu60GJCkz11G/NXEUI
         MrlF9d8RHBFNCXDQtjBUCsXlanvXvGxChQbEwAoSm5V79lwtECalcFCINTCS635rQXm3
         0wth71MFlX3AFUv3R9YoDR33u3JohrkciSt8qNQ0emeLFl4GYQJSvaaJhcu0GHHNn7bR
         in8AR5Mpxn6ZdUrj2gpiBtKqX8hBEjEmWSX03Ujw1wwcv4tCGhiI7hx6HWS8KkpY/8/e
         hDh3ZL020J5FEQUBDzqqdImrZRHoL3GZr37G7m2GKGNNkF4jtAYytaqK+SgwP95nLaPw
         LPWw==
X-Forwarded-Encrypted: i=1; AHgh+RoiHtGP+tWjUnIUwNFDQ8nqtQ9BPxYyHaWkYU9SgI0uxE5rU4iYF3h+GxKH+2584l0fa6humPRqCA==@kvack.org
X-Gm-Message-State: AOJu0YwotkUXg+PqLOtqLHf2zsG04dtC8P3IUqOAnSR8Uuf3AbixNj5/
	3UlfrJH5GC2KaeXQ4t5gDP5zaJaJWtziwHLjuazFT5ZPRYzrbAVAgmZYDL2rH2gzNQxf0AYXw85
	1uxvqmbWqF8CpYTibIn1i+gu/jZSYNe1RhvoDHV1cFacH/mcNb9y9e/ecpzqATCuA/09QKEHFB3
	Ejw7UKk5wLF93TMjXnjDsh2XP2tg==
X-Gm-Gg: AR+sD13/lUzXlwyhpGwF8ZfF9zLqO7Ddz3ABq5YN8nnEShIz39LlkHMUOBqhhalztAd
	fcWaR6joJGKnlsw21nYH1SQnni63sLgabztp1KIs578oFyQmxfgbp75lwth8gDK40SYlWBF0ABy
	kB+6gjWcjXrlBdgltA2HiQKjSVKiwJ9NW8pwEY/rNBPDWkrkNSc6rMtMxteZgXW7MagDXpD6hhD
	Gkls/79xV4qmTONWg==
X-Received: by 2002:a05:6402:2b8b:b0:69a:a9a6:61e4 with SMTP id 4fb4d7f45d1cf-6a034af6478mr1087018a12.39.1785243531247;
        Tue, 28 Jul 2026 05:58:51 -0700 (PDT)
X-Received: by 2002:a05:6402:2b8b:b0:69a:a9a6:61e4 with SMTP id
 4fb4d7f45d1cf-6a034af6478mr1086992a12.39.1785243530773; Tue, 28 Jul 2026
 05:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
In-Reply-To: <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 28 Jul 2026 14:58:39 +0200
X-Gm-Features: AUfX_mzjKO3uJ7rF1H8sSacugSHiH37kgZqfgEB2G31tBk8Z2Cqkag1XvoujA4Y
Message-ID: <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
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
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDExNCBTYWx0ZWRfX1np3VTQnEBp0
 or77zkeuR/T5FPzRd7q2drgyqvMuwpkd4pR+gx9vyCueAizSc3RTY4HPsFs1oKTEx+C5bB1LJDs
 GTHV3+OmocDLoYtDkBcP1/VEgWhASAj1cvcmX0qWkVR+7etyGoO9I5WU/iYs9WjAeZJSYmvx7pS
 IMGSVC3TYjF3Gj2Wx54gzLhBSgDFXHRUzfcMYv1LyKyevPZK5inzhG1qlSYamPmyOMneC213eN8
 V3gSEFj7zs+DYMFuUMvnniLZfZ9YFh3xNl5sAHOzE6bU0ju09GmOu0OnSKWzTfeY7onfcTq0lWS
 qdek9yCb+DdiNUW6P49KxtPAwA6rlDyx9W/n+6R9+18YJP3qx9MWSqNEkfmJ2qVJYBk4rkhuAsx
 dVB2VWmZZZ0IIK+jkXYKUvterKl75ZwkA2mdRS0cvj9w35EUOiSYER1d8uI6W5yVFcgCdD6Fev2
 9knebIknxU2PnqHrggQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDExNCBTYWx0ZWRfX6Z17tnjic5Di
 GU7bR9WBCe0Jzd+xr7+2OqKIIwNyYgN2JcW4EHQiyFXmq5+jJIJLBEmO6jR3ag9vHwDK3gbbdjT
 d2fd81CIdOERLOtDXCUwRxGJwEPlxdQ=
X-Proofpoint-GUID: D-jBQWsco9CM9H0iTeZfcFQY0VinUjqV
X-Proofpoint-ORIG-GUID: D-jBQWsco9CM9H0iTeZfcFQY0VinUjqV
X-Authority-Analysis: v=2.4 cv=X+1i7mTe c=1 sm=1 tr=0 ts=6a68a78c cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=VwQbUJbxAAAA:8 a=ufHFDILaAAAA:8 a=pGLkceISAAAA:8 a=m9DhMxF7bdjla8aEOqQA:9
 a=QEXdDO2ut3YA:10 a=22KAYETGZJnyhCxlFjxL:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_03,2026-07-28_01,2025-10-01_01
X-Rspamd-Queue-Id: 9AF2D14000E
X-Rspam-User: 
X-Stat-Signature: 5ia9k9yq1cobrrfir8djgbodom7ony43
X-Rspamd-Server: rspam04
X-HE-Tag: 1785243533-979009
X-HE-Meta: U2FsdGVkX1+pKWDVeERjYkKXj/q6tggNJyLHcT/onTaKhYyld+KZOJPng8kIRolET+2XYoEwjWAJBwc7DBeDhJKKgk+1Sprq+0lxCJie6o5bJPM35ARx+gJTjUkhhHU8KDuTp8pf18nmfICXWUPy+t5usK1U3KkFun8VInqCNrrtVC/owYKmhkE5NhZ/bUiVriWZsWFebRoVhERftX4ouWzBsVLlHR1pm3ESoHaN/A5xRphYwXNHt/XuTcwrAzKAEtio2qJS/7+eRJKLj7T/XbMV2xkNIH6x9blkiUy1dVJy2OEYqtdXI3ShujkiZlzkmluiZXUailaJpChm0tHOGKnWWmPdVL2qjSiB4VGmGZVsfXFX0IRRnG34rZZVi6/RMA+awx8zoDe6gtiyYcx3PcN67yy58qdzwnPHuZm0b8c+ZAH0XZIOT+7nHaEFGGR76gB/fPIZpO4BpT2BNWNJXXcSUndeHP+vCMkOrIjBogpmMzIK1DCI7dqVtwIqB1bbjsC+WSKgZnMv/1TB02poSeR+WiNEZ3PGOs3nWW/SvyvSNeHvf65li/bW4sFOu5O+IguiaMkJRXjumr7Ab9c1xZeWCmhDH8Y8Lc/qGPL2a9d63r/zb2L/SnXaSjf9U33vrX0id+xzg63p2aUCMPpEvEloN/N0BpOOvk1Qmg9ERveeF3aaXwvcDGbevHUjkpnaxDDvboUKa+VDlQP3lsm7+/Ifkhcrp67EQfj5Zxt2bkFUZoEvK3zd0Q6Y3hl5k42lXmZXQ37ArWufkLkCSdlKDmIRqzcgE7XWDoMkcsgAj8dklVbJTcTwPlY79xbHkgy1x2Q+Mc9pQGydH3DQxr9s6iLVvE0GIg0MmLer0hZRA9FpkLuYHQGk4vcKEIC3yV5x8PwpbQGuytA+FSSJUY/bQhb6NrAuVRVoHwSnDt+E5RXkPz0OL8xvhOuFAtohEvRXWDGPVlAPbww1K+Ebm0O
 CAS7Mnbg
 Bolq2ed5RJ9NvI52RNMmKZaciHQ7Xa/NvhJdzKTpLCJJ64MtBUK9cWHoTWU503ouQEr8GdCHNGc+rddj5wxk386YAQstInMBbtW1Dgu6bRuVB4OAvFcaqCaX7WbwO6BuUbbOMaIjt2KTUZUilt5BhbPmuoFzh52GOULc+/Nq+GRljlQYLDrVAruWaCq19MHQzoxmUDV5we6SDr+9oAoXlJr083PYkwSyFnwc78slBHvzg7GpJMGuK63ZdhQKJQOn7bnj4iEdTSOKfGQ+F8kYsfKNCF91qfuIzAjsZNSBCgJfN2fxP4dLZ/0fCDrPUaeXNmMa20r3Kw2MrMh4Jqalq9wK//gamYZTZC/doKk+riwLTuD4CTFJUE9r6h/xQvkIj/1t5tuOoWR8fJZg8PvxJz8VMwpS18f71W0CWax6a5i7I8JGp0DHEenPs54Bj2moy0zIjyCGLc6LEH8dI/i28OBM533i5t4ADo/3IemS/QMSvSvXJamMLmQpuv4yFBp/KbuzMUaZXTEGFvrqRwQ9dz9Xvy9jjQoVL0nlaa47AEX9IfEKJNJyzjYzl76zxD8CL5tg6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Mon, Jul 27, 2026 at 7:05=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> >
> On Mon, Jul 27, 2026 at 7:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > zswap writeback decompresses an entry into a fresh swap cache folio and
> > writes it back. The folio is cold by construction, yet it is left on the
> > LRU for reclaim to find and free later, wasting a reclaim scan and keep=
ing
> > cold memory resident longer than necessary.
> >
> > Allocate the folio off the LRU and drop it as soon as writeback complet=
es:
> > mark it PG_dropbehind so the swap dropbehind path frees it once writeba=
ck
> > ends. Synchronous-IO devices complete writeback in this context, so the=
re
> > the folio is dropped inline instead.
>
> Why does this need to be handled in zswap? Doesn't writeback from sync
> devices still call folio_end_writeaback() and do the dropbehind
> handling?

That's an optimization rather than a real need: since we know we are
in a sleepable context, we can safely drop the folio from the swap
cache here. And since we don't mark the sync folios as dropbehind,
they never enter the list handled by the dropbehind workqueue.

But maybe that's not worth it? I don't even have numbers to back the
optimization claim, so I can drop this in v3.

Thanks,

Alex

>
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/zswap.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8163e6c5f76c..e37828e02938 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
> >         struct folio *folio;
> >         struct mempolicy *mpol;
> >         struct swap_info_struct *si;
> > +       bool sync;
> >         int ret =3D 0;
> >
> >         /* try to allocate swap cache folio */
> > @@ -999,6 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entr=
y *entry,
> >         if (!si)
> >                 return -EEXIST;
> >
> > +       sync =3D data_race(si->flags & SWP_SYNCHRONOUS_IO);
> > +
> >         mpol =3D get_task_policy(current);
> >         folio =3D __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0)=
, NULL, mpol,
> >                                          NO_INTERLEAVE_INDEX);
> > @@ -1013,7 +1016,6 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
> >          */
> >         if (IS_ERR(folio))
> >                 return PTR_ERR(folio);
> > -       folio_add_lru(folio);
> >
> >         /*
> >          * folio is locked, and the swapcache is now secured against
> > @@ -1046,12 +1048,17 @@ static int zswap_writeback_entry(struct zswap_e=
ntry *entry,
> >         /* folio is up to date */
> >         folio_mark_uptodate(folio);
> >
> > -       /* move it to the tail of the inactive list after end_writeback=
 */
> > -       folio_set_reclaim(folio);
> > +       if (!sync)
> > +               folio_set_dropbehind(folio);
> >
> >         /* start writeback */
> >         __swap_writepage(folio, NULL);
> >
> > +       if (sync) {
> > +               swap_dropbehind_free_one_folio(folio);
> > +               return 0;
> > +       }
> > +
> >  out:
> >         if (ret) {
> >                 swap_cache_del_folio(folio);
> > --
> > 2.53.0-Meta
> >
>

