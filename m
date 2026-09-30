Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA48CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAF26B0092; Wed, 30 Sep 2026 04:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B736B0093; Wed, 30 Sep 2026 04:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8AB16B0095; Wed, 30 Sep 2026 04:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 799126B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:57:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDACBA06EB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:57:50 +0000 (UTC)
X-FDA: 85269825900.04.E432840
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53298140003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:57:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=MEbkSTuE;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=8733822579=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=8733822579=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790758668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSbzH3J8GpCu3CO+DRX2zaPG7BxRBagXxEyW5XsxKiw=;
	b=ryFG/3UjVIeOzWTtvk1ZKH/giHJoeJljRRn2r/vRxc9M+LZlHWk7L7MqZY0OHKYDJ+OeX0
	/oX42sYSTL6EYGUiOyFVw56AUKAHhb2snZJ7gUM1gndu9qfJDdSWU50gLNVmjX63EXsZTg
	38X04lEQ6rCO5kJv6zKo9ZA2MTcShbc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=MEbkSTuE;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=8733822579=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=8733822579=alexghiti@meta.com";
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790758668;
	b=GWLWq+MwlCD8ohnhgl4xzlP1mDyB1bSaq9Y3A//8s7WNb2froga81YB373U14zRzzYjGGY
	2a4jF1TPjV5ebRtwrx3Dis17kn2DWtQSsDL4eX8bKsB8FQy5q72sbpVPBogSi6bUvy+XMv
	2DXSGQtiQB+vvlq/6WMDLJqL4KCj+fw=
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7e8jT619292
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:57:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=FSbzH3J8GpCu3CO+DRX2zaPG7BxRBagXxEyW5
	XsxKiw=; b=MEbkSTuEtJDyWYMNO6YL71WnCSoBA2M2Ck/I1j+uuUHs9mx4xl1lP
	gEqVlxysJcR7edYasoLN4634LrDsZRUwbwdmJVoFzEjMQJrdc2dUZfzF+dZo469C
	5b186aQQR+hHRBosxnqh344iEb4SzDtTYD/teK309BdwlV2lRDorTb6kPJni+ZWa
	W4E/9CX0ofByb7dQQjPCOTa2hzmevHGcOwgw3KwZjp0bp4d0aaffmeV4b5S63UWM
	uLJX101Vdvir1zuV9/bkNFYr8hoPBW91pSuY/NMULyzKjf/x1DEgQ91XgiTsTBK+
	0Q34mZldvMxcKiDGUn9y4QuzYXk5yFVnQ==
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4h0u9s9dwq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:57:46 -0700 (PDT)
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a5d7e3ac13so5306940a12.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790758665; cv=none;
        d=google.com; s=arc-20260327;
        b=d7CotYdxfoCpAYfx5b5xlTHIeHEktHhAL1mFh1X2EM6oLJuIl+/bw+bqFvGjaK2Voy
         vT22ZCc1PF8QlfZROtO/WilAqu0O0Nv6T3XiZfe/lD7qEOGuYU10YDD66Bibwgyejw3A
         GPwJi1nCN/65wN2EqDKLNfzz99qqlN7jWk+xYEau0KLTvVkV0/LzfBetZYKx/BKdBbTG
         yDF/7NlK+QhUxswtOVdg0szyx1qn05OCsoKZl7/117hjlm8P1ZbEUhl9oCKClLHB6jAv
         fYQDMLuVqVVwLSkprrBd6QHmJHH5aDIvjT9MbXhD+Ccmue86s3cRUH5UhhLWyFcphnjg
         S2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=tm60U/TGR2G1p40eU4sJMqqHLE9qAL4X5WQ6mS0UHeE=;
        fh=VIj937d0TwDJMtnPzyynLB/U1md9S92ibvDR3Pgcx3s=;
        b=hsyHsUVqVa6xmE4qfvWHRbDxdEFy4VE5d9Jv47zzQyAmPlMZjDSHew+0jZtxq1RzC4
         Ul51dPsSG6T62JrwMOgaIdqhYGkKVViNrclfV0fYo9YsuC6sSTyo7Z/njduw08N98FHs
         L6qIeM6h//2HvhDPApssV/vyft32Q/nyakYA588aCSi7KspMLSllmbwb8g983dSDLI+e
         dRqHcG4p17/KwEgmH/CIoczbzfjSRWX+Z25P9ZdQ7uVPV4Frnv1w2ZaV2x+siU69LpGs
         C4JPhifx+wd509hqOJ+FFMIWhGHifIje5HtRtnK0Tfd9RuyiOPpVwdIVXglGg61L05Bp
         5oGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790758665; x=1791363465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tm60U/TGR2G1p40eU4sJMqqHLE9qAL4X5WQ6mS0UHeE=;
        b=K9J+O1ujHoXXwoasAzBArR0xSNyLrRvJv2N2dh/bLYI4md36+2/0PUAjCNRZCNj26g
         Y//dYUibgko/I3iftaBCBn5L1mgUm1h69EVjPY9gyc840QfC3ox6idmMZO/vQM8/NAIX
         3S90drUGhuT85w4nxT3X3qXaTQ0eeSTHP7eMJdvmREqfRRvGIDJShFx8fBjZNdNS2CQh
         dllG7Ob3k01NhWNnJOx81OzF62FT3CCdZkr88ubphtvK3syaueXhlW8WgPIpCR2h9l+G
         UNsQ4QvbSzFBG51c5XLVYlVswCu0rnF7oY6dTCJjlGKrJkhx8D2E9nXw52uvSG2cNH+O
         IGdQ==
X-Forwarded-Encrypted: i=1; AKwUvBygj0jCCA7IB565s1t5kV3r8TT8OjVfb+KkdKKXCPNvIdpeAiYXSbkHzXoc8wF9y7deHDPA0j9eGA==@kvack.org
X-Gm-Message-State: AFq9FYJP61Nd5nijJXYrous++AVvQgEPLwxf/87tkki4aXefmNyg5ycI
	bJKN4HNibGha0qxBjKQta/QYo3iWMMK6MPu+NwwWxx7DNlJPxpS6po7PiLt7bsTWuwctkTpJlC3
	Vtl85dsvjQq2oRmzvpV/ILn0PzVW+2rX/lK8o/9i6AJq4tDba+Y+rZQ52J/3KfQzRooIZBwVavg
	Mj/jY5Wof52W9LrEK1nlPq5iieug==
X-Gm-Gg: AYBFou14fKw1iHA6c49m1Dvfee0SGc69IHSHOwLTtlzqb1sG/tCkV77KVEOXSgYFMCp
	FIl4juPB/SD0oEKFNdf/MLzu8hF8xJ3zQXwBqsXK2LZsa82T+itqm4BrclvVI+Dg0C88DuWO1xc
	Sa4K/Q7qZnSnkDopLj3WACtDoGhEnTUoLmQnGdoOJMcrEnwxa+SLGm2OQVv8D4RqmfMc9Ko9YJr
	0lvSW3/qjq09l/O0Q==
X-Received: by 2002:a05:6402:24c6:b0:6ab:1c2:967e with SMTP id 4fb4d7f45d1cf-6ae1997603cmr348798a12.32.1790758664845;
        Wed, 30 Sep 2026 01:57:44 -0700 (PDT)
X-Received: by 2002:a05:6402:24c6:b0:6ab:1c2:967e with SMTP id
 4fb4d7f45d1cf-6ae1997603cmr348775a12.32.1790758664322; Wed, 30 Sep 2026
 01:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr> <20260928081900.4187482-5-alex@ghiti.fr>
 <CAKEwX=PJjGe3kjYCHwxijaZ+W8HvOiNQTTS-Da1R02hPW=kCDA@mail.gmail.com>
In-Reply-To: <CAKEwX=PJjGe3kjYCHwxijaZ+W8HvOiNQTTS-Da1R02hPW=kCDA@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 30 Sep 2026 10:57:33 +0200
X-Gm-Features: AclHuK8QO5DXy2cZ_qgdu0179rbpj5mlyiQ1Y2SMBWaoqm3aGlQoLCg7t0LKm2c
Message-ID: <CAEmasaWgracciCPNB-39iZ6RRCbGfQYFNiWSHsfP0qaaxCXCKg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] mm/zswap: move reclaim-driven writeback to a kworker
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        david@kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAzNSBTYWx0ZWRfXyNaL5zcS2MRp
 zQ1ahiZEhLpmFQcM/0R36F0nmQM3l9P0iKii8TpiI9N53ei/6pbQWm6nqeLRax7doTsDPc8uBvF
 ejg3hUZ1Cb6yrG5y6ubhzhBGLWB8svXD5ENcqv5fBGCy8Qx4EtTLi6vJv/mltQDkjMPPeDWFi5i
 OQuY7FM9opMoAFOo8rdMXzzy1AfK7+RXtNGFTJgGN0hw0j7ONqZJgJxysjxBEjHHhwUu3HJg8xT
 ZEBVXwL1jwRHA95Y6+f4rPOcLHM4e4yBQ1fhvlx+z3OS3cnPZnS2Naxeq2h/1dPXEOgJvNWeCiv
 +PYKw0FEQouA71NvvArV/iJ+LEGSWywFtsyyGf9yQpjp+L2d3AfgKBGeX6wX3x3Dq4V6uSoKMdy
 zWj5XRcwWtdmmaQG6Si1a0AG8QcQMayTt0JGTEDORYouSU4qZHAAUIfJ0VgMNEbiMW3HKTu01Gm
 lZqYh5oFgZZ6wfwugqA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAzNSBTYWx0ZWRfX5GcPA/KjwYy5
 fzA9onsUU0FQiJTWTgFj7GLYNj9hiIQ0C9cWqWKO7Rl1HfaCQi3aUHuVm2867Y3EcFBzgfzfpaT
 0iczscZYiesqizQZ+S0a6Tb8L7xjCtI=
X-Proofpoint-GUID: qEfM37FRhZIfp2QxbqEKFA498kRSsKLS
X-Authority-Analysis: v=2.4 cv=PK+aavqC c=1 sm=1 tr=0 ts=6abccf0a cx=c_pps
 a=DTy5UCxgudPLKrSn28m7Kw==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=pGLkceISAAAA:8 a=Esfd6WMfZuu0XR_NPF4A:9 a=QEXdDO2ut3YA:10
 a=VzYV69SsQLkmnS9OQLw-:22
X-Proofpoint-ORIG-GUID: qEfM37FRhZIfp2QxbqEKFA498kRSsKLS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_01,2026-09-21_02,2025-10-01_01
X-Stat-Signature: f8mgneywcna1are1hsrnwpp5jyxaxuop
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53298140003
X-HE-Tag: 1790758668-280672
X-HE-Meta: U2FsdGVkX1/qeqtSVuC4efFOym3eNEFkO/zyEV5y9RoHt+FiMAx8IwDGQNGjePkVfeoVV0AF/0Xu36IfwhYhGnRJNGCy6tTUoIdzkbsoJq8BIi0xS9yzFn/YpsR/VY3m4F+4sCtzLSJn1xSa34CXxxuwvNGyXhP6lErjyOQlruI4jFAhpoG/a0IA8ogU1Hv71OmVVjrZCZqP86KeSP9NzPp0tg+4P8OMvLmeQV41Xpq3jt75LrzEyQF8vEh4e/o/q35LjTTHZv+UH2uqfw3SRxgoceh3KIUBvFFGfshj+to4svom+L9i5yKvA647UtCF98N7qcaJ42iD2mjg7n8Jp6+4A2zL5w5LxZO82saOx7Tdo3rrJkD5vy7QokHKN5CztCR5g9VznYx/TaTMz+QFuDbyiYci70/dyEFvhS5qogdh6LXI7zO62oMZq4JNcoPiFLAUdZd99T34+XuaQd+e0eGZgMLTfvCwLvcSFWTG9wR7wb4Zy4nCKlm89GsCsCfiud5RyeVY3wcchpvuAbNpneMN+J5qGPbVBzBCMJ1LgziyVaQJhxGia77zFUeVF9Mbw9Z+rqpop1PWVvpOE5o0zZ5GXr2ccMULg+9aS0urvEAiVFWA5E4clJAWvIjiyAfQMxZ/wm0hWQKYN9aKeSNyRKydwCXQiCMaLfGa+aqQ2/79RdYkyceWc10iYzGN1cx+FptzFzAHIRPHdmJoCPgTHzao97Aayey72MATErPYMPC9eJbi6GjwHovXJobQwMh4oKG6rZFf6zKwRtl9RCrKM72YyQTskSw+7SaRc4cVcgvajYdsYZT7g9yl34VV7Df9F710Ddox/CWBVmFQjojPCIQoLXMkl4BmU1T3c+BifylrVhf0OfylKTBWrygUFrVp1FbgI3LANfAn4g59eUnn4olkp18mlQLvsuKoye2rBi6qaJ2gKpWwjJKLRPcywYoK8vVoqyLD7Hl5pSEl5KA
 m3TR9ueE
 hZZDG6i9+RQfuRCTczXTqbR7LvqcSWCwUs1ZFXgrRxu3jN0lKrVHHClHb+EFGiLNvMHetuMLeTmcyHO+MnimDpEtTJfSXjkiU3LZR1kMXZJSnvU1TcAZvoOQiiHKjWc9okPvYLuzVcKYRV4Q+yzIt22whplyubVVum+qKVt3ES03xB1kQirxCmdwo8R7aX9Qav8Uhcxj/ovrurDojk3l8JoB9qgIJJU5PR/WzEqK51JICEmrL7tNXtmwUczLooMugYqjKYiQ4xL8hkTJHtnzAYmL73yHXPhVPCyzgOIXLpVcG67xJOADsm5Mx/Ldp38R7u7wBZPDgqyD/S3+aVGbVqEjhEeRM/vIcRaoSsgV2aJD3RcQ/N1W7phZj2cvG916gvsGdvN79poCAe0qSABLwXjh+SNEl+/RWi0XjpQlKXCJ76odVMraCSHqS5Um6ojIN9+eiLs1BJPTYWMUFv1puC8VkMVkqNLfV81rUiNj3M0Fo4AWCeoJywoGxwRJM7JE9EUVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Tue, Sep 29, 2026 at 3:43=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Mon, Sep 28, 2026 at 9:23=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
>
> I understand the problem this patch is trying to solve, but this
> solution seems more involved than the changelog suggests :)
>
> >
> > zswap_shrinker_scan() writes back in whatever context reclaim called it
> > from: an application thread inside a page fault, or kswapd reclaiming
> > for the whole node. Now that the cgroup IO controllers throttle zswap
> > writeback, that context sleeps uninterruptibly until the owning cgroup's
> > IO budget allows the write. Such stalls were observed on a large
> > production workload.
> >
> > So defer the writeback to a kworker: each lruvec has its own work item
> > on shrink_wq, which writes back what reclaim asked for, SWAP_CLUSTER_MAX
>
> Ahhh, so it's one work-item (added to the shared shrink_wq)
> per-lruvec, not one kworker or thread per-lruvec.
>
> Hmm, supposed multiple tasks in a cgroup enter direct reclaim. In the
> past, the amount of writeback submission will scale with the number of
> tasks entering reclaim. But now, it's just a single work item
> per-lruvec - IIUC, the submission of his work item is idempotent, so
> it wouldn't scale like that anymore, right? I haven't wrapped quite
> wrapped my head around this, but this sounds like a non-trivial
> effect...

It would not scale indeed, the worker does not accumulate in this
version of the patch. That needs to be tested and discussed.

>
> Also, do we need to defer writeback submission for proactive
> reclaimer? Or kswapd? Only direct reclaimers have concerns with the
> latency blowup from the throttling right?

Today the writeback bio is issued as root, which incurs debt to the
cgroup. The submitting task repays it on return to user or on any
other IO of the cgroup until the debt is paid off.

With this series the bio is throttled at submission instead, so
whoever submits it sleeps until the cgroup has budget:
- for direct reclaimers, that's the application latency we observed
- for kswapd reclaim, it would stall on a single cgroup's IO budget

So we need to defer for everyone.

>
> There are a couple more behavioural changes, without proper
> justifcation or mentioning in the changelog. More details inlined
> below:
>
> > entries at a time, while holding a reference on the memcg. The shrinker
> > does not queue more work while the worker has yet to claim the previous
>
> Why not?

In the large production workload I have worked on, when the shrinker
is enabled, the zswap pool size decreases by ~97%. So I did not want
to accumulate "too much" work to prevent zswap from draining "hot"
pages, it acts like an additional throttling mechanism. But that needs
discussion, hence the RFC.

And you're right, In the next version, I'll clearly point out all the
behavioral changes I made with their justifications.

>
> > one, and reports nothing freed, as nothing is until the worker runs.
> >
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> [...]
>
> > +
> > +static bool zswap_defer_writeback(struct shrink_control *sc)
> > +{
> > +       struct lruvec *lruvec =3D mem_cgroup_lruvec(sc->memcg, NODE_DAT=
A(sc->nid));
> > +       struct zswap_lruvec_state *zls =3D &lruvec->zswap_lruvec_state;
> > +       long old =3D 0;
> > +
> > +       /* Do not accumulate work: back off if the worker is lagging be=
hind. */
>
> Why not? This also has a non-trivial effect on the writeback amount...

Explained above

>
> > +       if (!atomic_long_try_cmpxchg(&zls->nr_deferred_writeback, &old,
> > +                                    sc->nr_to_scan))
> > +               return false;
> > +
> > +       if (!mem_cgroup_tryget_online(sc->memcg))
> > +               return false;
> >
> > -       shrink_ret =3D list_lru_shrink_walk(&zswap_list_lru, sc, &shrin=
k_memcg_cb,
> > -               &flags);
> > +       if (!queue_work(shrink_wq, &zls->deferred_writeback_work))
> > +               mem_cgroup_put(sc->memcg);
> > +
> > +       return true;
> > +}
> >
> > -       if (flags & ZSWAP_SHRINK_SWAPCACHE)
> > +static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
> > +                                        struct shrink_control *sc)
> > +{
> > +       if (!zswap_shrinker_enabled ||
> > +           !mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
> > +               sc->nr_scanned =3D 0;
> >                 return SHRINK_STOP;
> > +       }
> >
> > -       return shrink_ret ? shrink_ret : SHRINK_STOP;
> > +       /* Nothing is freed until the worker runs, so report nothing. */
> > +       return zswap_defer_writeback(sc) ? 0 : SHRINK_STOP;
>
> This will have effect on the shrinker control loop too, right?
> Shrinker API accumulates the number of writebacks overtime based on
> shrinker_count()'s output, and we serve that number of writebacks
> throgh shrinker_scan(). With this basically that accumulation just
> grows over time, correct? Check do_shrink_slab() in mm/shrinker.c...
>
> Feels like this completely breaks that control loop.

Yes, this is another behavioural change that I will explain in the next ver=
sion.

Indeed the work piles up in the shrinker control loop if writeback
cannot catch up but note that it is bounded, which is what we want
right?

>
> >  }
> >
> >  static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
> > @@ -1807,7 +1897,7 @@ static int zswap_setup(void)
> >                 goto hp_fail;
> >
> >         shrink_wq =3D alloc_workqueue("zswap-shrink",
> > -                       WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
> > +                       WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
>
> This turns a single-threaded workqueue into multi-threaded workqueue, IIU=
C.
>
> Worth at least an callout in the changelog?

You're right, and the explanation is "we cannot starve other memcgs if
one worker stalls because it exhausted its memcg budget".

Thanks Nhat!

Alex




>
> >         if (!shrink_wq)
> >                 goto shrink_wq_fail;
> >
> > --
> > 2.53.0-Meta
> >
>

