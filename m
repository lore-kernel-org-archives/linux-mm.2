Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CACB60A260E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=E5NMNEos
Received: by kanga.kvack.org (Postfix)
	id 48F9D6B05B2; Mon,  2 Nov 2026 02:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440346B05B3; Mon,  2 Nov 2026 02:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307956B05B7; Mon,  2 Nov 2026 02:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 011BC6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:55:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 824B5C0C39
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:55:24 +0000 (UTC)
X-FDA: 85389418968.26.596AB22
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1908840008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:55:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=E5NMNEos;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793606122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVESOeH8KV93dptPiWjIINeuJuLkSH8q0hNNGTbvaJs=;
	b=XmQsjrj+P1psGOC9UnylTwf5upnp4FgC/S8eLR8Njv6sTdWRlWqCQF3bC4dk++g8lcOTG/
	rGjP/DAcwnBnMQwSq8IoA2iQUYtNI9BSZaiYnRqnb7Jb45/9NCrW16JBqgkZIh4tIPpdns
	3znbXIGey1KwI1pIcRYlg1E+wWTcK1Y=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=E5NMNEos;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793606122;
	b=EF51i4s3jqLVKrIq5BmDbmOdfl5oycFmR6dKNYpCdGEhpswsyZblOSpDIn9TPQ3sgz6Ox7
	osWEwznTMnsCgBSczVQGFmw/jwBZTPraxYVgOGMJiZ0SdpSeKgnCcsYlRQ2s8R7eyaDDFM
	MLXmOEsmARG0j9h9P3MD3HPWIaYGlfU=
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A248Tnv2144744
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 23:55:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=VVESOeH8KV93dptPiWjIINeuJuLkSH8q0hNNG
	TbvaJs=; b=E5NMNEoscTnD/bxw+Q2JSm3eB/Ick4L9TQL/86Q2iZ1BDTJUL4CrQ
	2wBOAqIzJbO9ZkJxE+sA7DTGoaytiW5h4ww8XdGT0aAyluMmQ7HJT3m5aw+s5aDd
	HKguWIR6i8YzwRjYzTB0FvX8dQIJK+9Y/8qOJZlIJ/xnFz4xzLG5pUXWm1Ih31/L
	ZiqIyb//6yTvSYs9VLmuQFgJ3cLPlNUNsajxCKQ671OnaBstC+jo88o2fJREAYLh
	d1oPUUxy44eMDFLt7A6Qga7fkOq9i/XVkCiK97Ew8rXph7u2RGfBTdQhK69Autqq
	h3OLRQTYs3i2TDG8XCjnPdQpUt8FVoXUQ==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hne577m0h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:55:20 -0800 (PST)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b4931346fcso2401964a12.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:55:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793606119; cv=none;
        d=google.com; s=arc-20260327;
        b=gfNyk/MNpRRUiybMdliyQ6U/lHsH/vWSeyMWXYs80MdUq0L0pylKBkjPAR7Lbll7i/
         I966Jm/+O669n6GKxq+AbRoTf+Z9TtTEZ5JTuteRqM0RtwgzHeE/QHvBummV3yXJle3M
         4jqVHKcR50pWZAf6N2r5ZMhUB61pTA1TUT+aaH+I8XpqWId91JF/i3yPjbW9A3auS0r1
         sMR19ecAWDa9bCd4DNpgQl5EPY2DtLP795wmJcuuIrtO3QzU3tQTO8zNM0BOJ95z1d4/
         TzECqDWC9QgmcB/UHG387Hx34Qy0ncGIUPgQIO096IyFxmwveF1QfSwjhNkD23TSMP1Z
         k8jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=tJb4lf6fiPg2LPN5JU8WD73ddi6jNhw7+gXQyIOaxMs=;
        fh=1R7XC8tAUX/niur6dhUpvcqVRsQjmt9/VawxWeDY79Q=;
        b=SxnDSLfA56NkPmsQNfCOTeckZ4zGFam17xVejGI5oDgP8UXLLts98pUElG2A7waYkA
         Br5Q6z/o+ElALRvjCGP498X6/K5o16WnrNi1a8gN3ITvg8doGNrKdRLS+SQjCcB7ZYJ4
         ddsCHBHyES8jI9+6ryoo/Ja4AMDQ5NMkxB2rxgKdIZcB3K4p2VtSLeVH2pLU1MHRBIRt
         8joWy57wEv7ySr0eaKqxZvnT0mCuct7cN7/2YzQhTbg1UQGfknLametBYycrJIS+riSR
         FHaYOWAjZ3gkpORcXj/zjMnrjXFiReiKqtYrdouqs86p0IWQeFKC7BWRNoTCxp3hdusg
         VHGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793606119; x=1794210919;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJb4lf6fiPg2LPN5JU8WD73ddi6jNhw7+gXQyIOaxMs=;
        b=XoKDZxq+yT2uxeVBVJQ0+Tv5mpvwl/ghDFaoELOCg2+t7LlnY44M8NMaot8RMxNqhy
         Z9/eHeE/AQaIWEafQF98e/S8yjgAeSiSrTTlBNQ9PLzOSVc0JM0jmfgpjniXIJEz1q5G
         WqndeGQqgqKzRO0iH1ZYOrYNlkhSp5UwG1ymZ8+EHyVMk1NbmDAdZSMjJi7WB3QOxPjj
         3NF5RMRjb+S7ljaDi58oQFlRWkOmemvMLXhUTDyppFkMIsPgcvEtkXt0r6r/49xx6CT4
         qi/PDy3jKEE59E4ZLdav2p9T3gyUwsbSv8CoFYYKuVot942zug/rAutqbeX94ZeLv/jg
         LCJw==
X-Forwarded-Encrypted: i=1; AKwUvBxcJCqr6hCuQ2av0wnbGC8DZ+Ce7T7YcG/OkN7F/xdndXDwa5OuwXRnBZVBN7Czzh7fbxHAwNom5g==@kvack.org
X-Gm-Message-State: APuU4Z/UG92FqdMKWgKREZYMo33j0aUkycVO3OZX3NUOKu4d1n/vRF+H
	mgOxAuLK6HH/XEN6gXxzA+7zZU44MH3wMAoMzBDHKbpJ2i9W/RTkG9uIsUPAGTfe82tcpIlkQb1
	Jm6gzOeucsdVBfCaBcGIWGNN5KTTQdAdlsU9VrJll1KW2t4tZ5SnAC03zmZAYv5I/0b/hIdFuJ5
	/SFvvu0IEeYteJ1+v1LrerqrBafg==
X-Gm-Gg: AYBFou25h8Dr5mT+6bNG0hADj161xf+Xmy4AxGqRMzW080Idb3e+BU8Q+5ElhZtkzw4
	ZrQ3lIQ6spbLIQx0Tp43KYD10lzpnLMcHEg2FxzdkcVkWT/J3T760fTnmd9wswEWxnHDU8TDGYO
	qew6ZIUWgl5UuGlQaefn5KSKDEdjs+ST/rhyuKSTQ1FO1duPs//WFavky+U/VhA+exY5V5lXhWa
	toboT3WCsy3kyvLQg==
X-Received: by 2002:a05:6402:1345:b0:6b4:bf13:b4a3 with SMTP id 4fb4d7f45d1cf-6b4d61ccc7amr4438928a12.43.1793606119504;
        Sun, 01 Nov 2026 23:55:19 -0800 (PST)
X-Received: by 2002:a05:6402:1345:b0:6b4:bf13:b4a3 with SMTP id
 4fb4d7f45d1cf-6b4d61ccc7amr4438916a12.43.1793606119115; Sun, 01 Nov 2026
 23:55:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <20261023211629.16227-1-baohua@kernel.org>
In-Reply-To: <20261023211629.16227-1-baohua@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 2 Nov 2026 08:55:08 +0100
X-Gm-Features: AclHuK_8krTVTi2LRMKaoOYCwc66AEL2XvylCPgWSL1llLe72wlEvVkXyXpTj5c
Message-ID: <CAEmasaVgBV+tYg7xDV96qBQ1oEVgUL3F_BnCLJW3LRjZ7ai+Yg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: alex@ghiti.fr, akpm@linux-foundation.org, baoquan.he@linux.dev,
        chengming.zhou@linux.dev, chrisl@kernel.org, david@kernel.org,
        hannes@cmpxchg.org, kasong@tencent.com, liam@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
        mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, ryncsn@gmail.com,
        shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
        vbabka@kernel.org, yosry@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: tRb7CtRTVCm4J-sOGlVQpg818WWysZ-k
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzMSBTYWx0ZWRfXxCoHykvhR85w
 egsouWK0U/ql5RR9QGq4BdxEObbl6KpxQ11oNs8xmyB8DDhSxObLFok/XSH7OamAUsyoYxOQ2Zy
 a8wNpWCe3019nB9dxwzaWsTD4Z9WpOg=
X-Authority-Analysis: v=2.4 cv=SJ/Xx+vH c=1 sm=1 tr=0 ts=6ae841e8 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=wpfVPzegXHpEFt3DAXn9:22
 a=VwQbUJbxAAAA:8 a=JvHM3WmaZCj6HjDewG8A:9 a=QEXdDO2ut3YA:10
 a=j5kO0B45gQVIxiUYEfTy:22
X-Proofpoint-ORIG-GUID: tRb7CtRTVCm4J-sOGlVQpg818WWysZ-k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzMSBTYWx0ZWRfX88wDLDFI2xDN
 71qHTpx3RTQo768o7DYNwLGHZ0z+0tMX+gt2ryq5IVURWmYpybvVHyyZ00/2ipUEJ4BdfxCxqa4
 WT+Zp1NQ8CwDKelF88AxQ9TLotNDWJXq4A5gbK4yXzJZ3CAgc8+38O11mEzsMLORc8ID9DKXaQ/
 SHvH0fRiWBMCLND7LdQBENvxjdyMRBJQjn4Q1aLgZW9Q5q2/HT/7MNELwEDMtyH3d2agyAAvypa
 jvu1hF+mYUTjG8laSvYWItAlSiH3OH02sORh3Oid6WXPGXtSbHpabUQm1BMV0JTmhFxo208TmbM
 /1AY8bb+z2kJLQZCwnWglxxbEIzfTMpWDUSWoMjkn5R0WKyWZpP4xwGpJkmDuZn4cLg2FdVox28
 9kU1K0N5jJOzwVgflS4NBV8aTxRAjfaB4p6h4TzR7SpifObk9/Rvq+G2sNck5KJ1sEG6VZJmo0U
 ntqe3EUPrtjMeW+zBWQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1908840008
X-Stat-Signature: i4jg76pxxkm6f18kdz7cbuwbabctbdy3
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793606121-293446
X-HE-Meta: U2FsdGVkX1/HgLfZOFVV5P3U8KWMHTQBbPdKAbsgERYkKKgx+pNLLA601EtFr/cJfYLCrFz//thqwfBOy79JdQ+2sdEdr73mWEJ+klgSPovByAxE/iexLjBzbLveoMVqIvgny7uu9eG0e+fLEU99PbQLRc1InBYmvPJbSELXn+S1M+UkWsCZxg57MA0nmNX8C4NwG2LWHYv2BVYrCPKhihpSfpxL/U6LEEDCer9I09+Lgz043p+vZ2pFIzm+R8AHTlbAxToTBgXpIaInEPcTWbSY3R387BKBnjv4+UsU9CtoWqeM4UlNPcOv5G6DT5m55fHLA8/D46ncL4Z4hBPexujp0wiEnOqttglXyV+UEDPq1++TzYdPQhcy/DOIOINVCe0MswmfsqmBtLfSYrlsufT+mm5hWBsfAUoHtzFPaOW+oQWMual0oPCjN8AZIebB6NsuSR74Bx71NS8ktlZP0mIUo5MjdLeKD0W9sPuNXI9qQtMLaIoYdl/LqB87KCFU/n9opBSMJdAZMf/MCvpvH50MOvxQdKHe//Juotk3CwhmZo/LHpHjZa6s8bpv6ZfvAjyn5Pas9Ig/jdmkJAgheyJiF7jIYZkDyuxvNuR9BEJi3Y+A2t41zi0o7epbwgmlWr3hAzJVElDAM+oq9e9EgqLiq5fCNvVbQDKaSgyue0l59+FJR2plg1sTgszRrlSrbZm4SaHJ4Glc2C+ctlc22bNOHMA/VwPMgyel3E0qeSHqQHo1y8P+wd3w/7TrQkt06/KiFpX+yfZzDmD/LvfsXoTBcsErgdy6W6akb+FI4Otdvvsd7fd4ArQENcJRrks8ViZoQc01zTOcLrC1M0yypU8X1SSP/7I46AiLXhuU3QWnLG5zGRUZhYfkcmfKG0rOIoRo/MRW09otoSBLubJRtCrIOPd+UddYCNw+5U8gNy6Z1+OJHD/n1oZT/6IiYQuiQPDvmSH0LkCoJmZs/qu
 BZDDWucX
 NvphrlTxKr6RuFnVxmSqRhD5ILKjgTtkaTpIp/v/3rpNC7gw4I2w8yiENbmTgbKEZybgNADiuc/bSwV05Thno66yrMlO8EZmi+AETkrLWzL6fK+J/22yfQ8E1fK2s1mAkCRHZyKNW2t30hWO2KK6JVlOG+WbkVFQRUZX9LIiIjlCVjcGAbqeuqb7GQfFBy2BJy1x2+/pOoP7KsUbyJQJiDZDhvTgZjc6xyMArg9zaaUYomWN6qxzGYi7rPDTDuMLAe8Pfdes0JMjtT3PknTAZzSsv+ppPO3q0yBtWdFWi+huywbJ8HBcXEPPjuAiQio1wtPJB3048jeQEW6W02pEnKZwlCBJvJtfmEs0UKJORPh8IdA7ygSymziOdsRy/blMP32/XxR9tibzqzmi7iGiFMJepawi0Thy24iyERy1Xnd2PW3we8FQw7HF3RRq75C07uC8FwneeO2qeXtdzVb1cCuqSUJSZeBsO4WEHyqvzBMmo/yRhBhSE/qa0fCOKLS7/69mE0JO6kstoagKeQ+e5X5TyCvOB8ti4tSEhlwLEsyccY+wuwXYsmstWxIK2WZm7X2m9ODEKTFT1n9TbkfB2U754oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Barry,

I'm back from holidays, sorry for the late answer.

On Fri, Oct 23, 2026 at 11:16=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel=
.org> wrote:
>
> >
> On Wed, Oct 7, 2026 at 11:39=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahea=
d.
> >
> > zswap is the same kind of in-memory, synchronous backend as zram, not a
> > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > swapin_readahead().
> >
> > Here are the results from bypassing readahead for zswap too: it was
> > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shri=
nker
> > off, on Sapphire Rapids and 3 iterations.
> >
> >   768M memcg (sustained swap thrash):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          405.0       341.7    -15.6%
> >     zswap-in (GB)            79.5        53.0     -33%
> >     zswap-out (GB)          144.8       115.6     -20%
> >     swap readahead (pages)  6.79M       0.45M     -93%
> >     swap_ra hit (%)          72.1        89.9     +18pp
> >
> >   1G memcg (light pressure, build not memory-bound):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          177.7       176.0    ~same (no regression)
> >     zswap-in (GB)            10.2         7.5     -26%
> >     zswap-out (GB)           27.7        25.1      -9%
> >     swap readahead (pages)  1.07M       0.08M     -93%
> >     swap_ra hit (%)          68.6        87.2     +19pp
> >
> > Similar gains were observed on an AMD EPYC 7D13 host.
> >
> > The gain is from no longer prefetching pages that are pointless for an
> > in-memory backend: readahead inflates anon residency and thrashes the
> > page cache (file pages get evicted and re-read), lengthens each fault by
> > synchronously (de)compressing a cluster of neighbours, and adds
> > compression traffic when those extra pages are reclaimed.
> >
> > Bypassing swap readahead for zswap therefore makes sense.
> >
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
>
> Hi Alexandre,
>
> One thing on my mind is that for synchronous devices, we always free
> the swapcache during swap-in, thus releasing the compressed copy and
> metadata as well. We could do something similar when a zswap entry
> is found.
>
> I wonder if we should do that as well. I don't have time to
> investigate this further myself, but I wonder if you'd be interested
> in looking into it.
>
>     mm: free swapcache on zswap hits in do_swap_page()
>
>     We already do this for zram and other synchronous devices. The same
>     should apply to zswap hits. Freeing the swapcache will allow the
>     compressed copy and metadata to be released earlier.
>
>     Suggested-by: Barry Song (Xiaomi) <baohua@kernel.org>
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 55b5a84d1016..d22c779fda93 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4711,17 +4711,18 @@ static inline bool should_try_to_free_swap(struct=
 swap_info_struct *si,
>                                            struct folio *folio,
>                                            struct vm_area_struct *vma,
>                                            bool exclusive,
> -                                          unsigned int fault_flags)
> +                                          unsigned int fault_flags,
> +                                          bool sync_swap)
>  {
>         if (!folio_test_swapcache(folio))
>                 return false;
>         /*
> -        * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. =
Swap
> +        * Always try to free swap cache for synchronize swap entries. Sw=
ap
>          * cache can help save some IO or memory overhead, but these devi=
ces
>          * are fast, and meanwhile, swap cache pinning the slot deferring=
 the
>          * release of metadata or fragmentation is a more critical issue.
>          */
> -       if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +       if (sync_swap)
>                 return true;
>         if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
>             folio_test_mlocked(folio))
> @@ -4977,6 +4978,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         rmap_t rmap_flags =3D RMAP_NONE;
>         bool exclusive =3D false;
>         bool rwp_restore =3D false;
> +       bool sync_swap =3D false;
>         softleaf_t entry;
>         pte_t pte;
>         vm_fault_t ret =3D 0;
> @@ -5059,7 +5061,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
>                 /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es and zswap */
> -               if (swap_entry_synchronous(si, entry))
> +               sync_swap =3D swap_entry_synchronous(si, entry);
> +               if (sync_swap)
>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
>                                             thp_swapin_suitable_orders(vm=
f) | BIT(0),
>                                             vmf, NULL, 0);
> @@ -5325,7 +5328,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * Do it after mapping, so raced page faults will likely see the =
folio
>          * in swap cache and wait on the folio lock.
>          */
> -       if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags=
))
> +       if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags=
, sync_swap))
>                 folio_free_swap(folio);
>
>         folio_unlock(folio);
>

zswap already gets rid of the compressed data but indeed keeps the
metadata on swapin, we discussed that with Nhat 2 weeks ago :)

I have a different patch for that: zswap marks a swapped-in entry as
dirty (so it gets swapped-out again) so I was thinking we could use
this property to free swapcache metadata in that case. I'm pasting the
diff here so you can tell me what you think. Anyway, to answer your
question, yes I'm taking this over but before I send that upstream, I
need to test/benchmark this approach. It relates to
https://lore.kernel.org/linux-mm/20261022145615.2184343-1-alex@ghiti.fr/
where poking holes in the swap table currently results in inefficient
IO grouping.

diff --git a/mm/internal.h b/mm/internal.h
index 2112576a70a2..0c4598326d2f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -626,10 +626,13 @@ static inline bool
should_try_to_free_swap(struct swap_info_struct *si,
                return true;

        /*
-        * Free the swapcache only if we are the exclusive user and
-        * this is a write fault.
+        * Free the swapcache only if we are the exclusive user and this is=
 a
+        * write fault, or the folio is dirty: its copy in the swap slot is
+        * stale then (zswap loads are exclusive and dirty the folio), so t=
he
+        * slot only holds swap space.
         */
-       return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
+       return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
+                            folio_test_dirty(folio));
 }

 void folio_rotate_reclaimable(struct folio *folio);


Thanks for your suggestion!

Alex

