Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42531FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E2E6B0088; Fri, 27 Feb 2026 11:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBA26B0089; Fri, 27 Feb 2026 11:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796786B008A; Fri, 27 Feb 2026 11:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63D5A6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 125FA1CA4A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:30 +0000 (UTC)
X-FDA: 84490802340.21.6C77A13
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3C0CCA0003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WJ4WE7fY;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kIopnbRq4jN3V/2gTsORTjLWBTvRkSveHkD2aWFgnTg=;
	b=2Yz47K7lBtW2j1Nit3EpKu7pruqJ0tnpoLCX5f7NR+R6H8CNZuRzoRW6a4Xa8iplqjACu0
	bXrcZOg1B8sNT+YtprCDUvnVUgJh+tCPvwxXvaEqx59C9Gfe2/chaDuVx5BX5fi7FAyyUm
	XekEL4gZf4o5tX8Pwwl5k5EBHwzi+co=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=WJ4WE7fY;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772210487; a=rsa-sha256;
	cv=none;
	b=Ryw3P0kmR1JHmjN/S5pctM1QoD5bsd+VI2UVySVh1KeL9Zs41eOVpp4cYE4OBf8MbD1xTF
	SA0PSMlhW9VHRM0S8BAMywZg/6jqipgTbtB8rt0Dusl8gi5fws1n0ewRHayYm6f0K5oJeu
	lRzpMm7od1PpvhjIEoqT9zt8hiDkWEU=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RGND2J1496658
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=kIopnbRq4jN3V/2gTsORTjLWBT
	vRkSveHkD2aWFgnTg=; b=WJ4WE7fYoUyiLGjnYIFC46Hw/0vUjE3nebGm34U/zr
	VZ/f462QjOtqeQqZLHDTtDdmUbsOAHcPrqc/Lvwfx91+uB0xBk8rkq5l4I5FzvrW
	aRsGK8IBpv2Im9i6x0aKDjoeIfX4KrI5kRkOqkW8bYQ5cbetHnqRZ1vnjc/jjE7Q
	2G5FNrqaZJh1N4OAXDAioA8u07YK/p2dQj6SVlccARRyT7vd/9vSGC0EeUPjQjhy
	Iay7JWvyDMuBOyZ2x5+pA6A2MPMgoo8Mj+2c13tnG7vnxK+D2zslW1qwNxiiVvEF
	SY+rN3sSzrh8QadkH7FOQtja5UpCp/iDBWPU4r3bYXWw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4cjsxdr4va-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:25 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89502dfd7b4so208477006d6.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:41:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210485; x=1772815285;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIopnbRq4jN3V/2gTsORTjLWBTvRkSveHkD2aWFgnTg=;
        b=xFptKgaO1rkAfaiD7YEV3s0xrjIINx608nyh8jqZDI9Pk7zWS/Al7g348o+TVGAJP3
         DhNkh3lrB9iKplbcPxSqFKilzG1QdjjKrr2il0fuVlmRylSE35jmdsHTa9LevX9wSQjP
         Q1aPalE2Nf6q8KETOyhxYnsPvIjNmOW5vcccko8xqCUbnUaoX3Wyq5w2Tb4sbZgWwo4o
         g0PGypfYXmc/VB1IyHwjZSkFSZHiMMw4ZslkvcwJzpx66GzUG4R4PW/Tzq69d0i6YS4f
         omiU+P2QvVsicSMlCPfIogA5le6v0dK5LYtR/3H0xEyKsl7kzchNJSGQfUTbq8rfqB79
         2Cgw==
X-Forwarded-Encrypted: i=1; AJvYcCVUzAR6YQyCyxf0BI6tay5PQ2dPu58OnSFIaBHed+gGDhvd5hY68eesePi7dTorI4UzvacHdQbrpw==@kvack.org
X-Gm-Message-State: AOJu0YzJveRoiWhxikfWTNC3jm+o8HZ51dY3ZpNcBAGEzsZg8Ppjtzul
	S2Cdqq8Gxm4Dcf3mcam0pJwM2Qy7WpF03VjSG256Wr97lGA4QF7aVAKC5l3rDspariwuiD3FdTV
	ij1QqckQnrNICClLjY/QVTq4QZzOtzEc52ssacxQfbbAOHZGX
X-Gm-Gg: ATEYQzxKDIgySBkGTI4g5j+7WPDJyW1X+ZLAX/6DNus8AKvzZeLJaCMslCF/pMAoExZ
	H8k8dgXFY4O+Py4pwj4HP00FsBBgmkdgbCE96NWDX3Kmv6+wiyBOijLxxsQmuhoieYE2XcuQAtA
	qzdBrcCIgl6QNqUyZt86qchQGkw2t7cVYKtjsRogsWSrrPt2aMFnSPfCGg7hG3ilSY5IjJuG1KB
	xczaZbIvRzhyZHqCZLCkMlxh0q0uz7fTp3s0iVBfJ3d/jrE82F2uXeRvZL5KG0Va7TG8WqNNlJf
	mY6iDw9Wfcc0koDBZC5cBA5uzcTi2Q5uLtnBySJqEH6y68WEMO3QH1aZhQK9wfc0j9/CaH+/rZ2
	BWLtcwI6Yj1OzPV22EcEN38IW5F/uNurwmsL4oKxVba5VwQ2xF+FmJnSufUMJsE4Z+BU=
X-Received: by 2002:a05:6214:4109:b0:88f:a4a0:2ddf with SMTP id 6a1803df08f44-899d1e5070dmr56245806d6.46.1772210485161;
        Fri, 27 Feb 2026 08:41:25 -0800 (PST)
X-Received: by 2002:a05:6214:4109:b0:88f:a4a0:2ddf with SMTP id 6a1803df08f44-899d1e5070dmr56245036d6.46.1772210484479;
        Fri, 27 Feb 2026 08:41:24 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c716caebsm46535886d6.15.2026.02.27.08.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 08:41:23 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC v3 0/2] block: enable RWF_DONTCACHE for block devices
Date: Fri, 27 Feb 2026 11:41:06 -0500
Message-Id: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACLJoWkC/3XNywrCMBAF0F8pWTuSR1+4EgQ/wK24SJOJDdZGk
 jYopf9uyEoKLu8d7pmFBPQWAzkUC/EYbbBuTEHsCqJ6Od4RrE6ZcMprylkL3fAA7cZJSdUjCNE
 yIbSmZYUkbV4ejX1n70ou5xO5pbK3YXL+k39Elk9/uMiAgZG6rpsKTcPMUblhfnZW7lHPGYv8B
 +DVFuBAoaHYSFWmPW03wLquXysbLKrzAAAA
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772210483; l=3619;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=BEeIa88RvYQBpBW8wSWS7+9ZmJtRT8takeYNLITWrCY=;
 b=P2OAzuWnRvGmfMu3FKgpEoLuWT0SusPENu+T5BBqjDCAzaIIHtNgLjq1p6L6MeydJbtozid2B
 FzfMGcUqZEjAp//Ioln1ll+QavLMRrtpcuVgSj1+WlZ/W6AWGzIkaUw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: jCYNu-ZB5ekKt2_rGLhaw_ulvAOb9ejB
X-Proofpoint-ORIG-GUID: jCYNu-ZB5ekKt2_rGLhaw_ulvAOb9ejB
X-Authority-Analysis: v=2.4 cv=Reydyltv c=1 sm=1 tr=0 ts=69a1c935 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=sdoS8YJ70VgF2Jk85QkA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0OCBTYWx0ZWRfX9J69cSBXBLKt
 ajGFwDG3LgPbwvg1iY5w9MswlEFdT/VtWDcofHmccncRlf8vR5l8jFesUhc3FSVWNNLGdP8aVrl
 xhzpJmhfflL0+QvsveF/tIeiHe1hDOHnio14pK39a9AVl4EOjSF5iPF6Id0E4vvIPDK4oSzrdZ6
 yEcC1I+cUC/8IWhUk4sDLEbn8AI7PP5dFiqi6CyTI3Nm9qRLpyvf5Mu/gBLg0/TNUwIQ5IeIym9
 D6TD9bAm9xfOyPWIRa8AT7GVQvVjmfaxXjX8N4Dr1xFTVE34Adu9AM7dTyAtyQI+LN43Ut7ke7f
 fbOBpzA1uV1GOlXHxRWZ+uDciky9xdo+ZPcvzHz5tQFNYRoK1rEtfVGC9DDs9cnZ3Erdw1vZ399
 Q0LoGEB32juA8M/eM5sa/Yma66e2+VLtx27WuhhFtBb2xyh/cuRBcNuujJBtMeH/9201vWZktve
 IAomeEz00DtttGpyMag==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11714
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=10
 lowpriorityscore=10 suspectscore=0 priorityscore=1501 spamscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270148
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C0CCA0003
X-Rspamd-Server: rspam08
X-Stat-Signature: nfzbzq8q5ttdgosio97f3wdhumibk5q3
X-HE-Tag: 1772210487-73654
X-HE-Meta: U2FsdGVkX18Gd6s5FWVupxYBCdUxf3TbFxnm1fT5PYpl+fCyXl30wgzK2B0oq5S4+PtW1x8o20I6zyn66bbT/OQyW2ALFVaq8Bek5x8oTkYeeO76s7PdrKaW6Pzx2pnQeVpAkrix6aIBnk5hdSdnPe4ls8NEoCwe8Zn6Yds7bTjULb0vsfBOnrkv0Z8Sj8ZidxPL5NXhGkENz3qvNZPzXK9ucHgatK/6dDCPz52UrMglVdKAc8zHzF/1nN8IQpxISyfdnuUBygcmQSNHdUvqKLg2yd8dTcC1U+yUJUCZNlC4YF0kkOLc730U64EyoSp5zIhRk+kgNdApFKwpRpraZNI14j/Spm4HJZEcOgyo+OHO+EMKVyIXw2cfvsJEPYuA4bXldxkWZD6xkTPDKWRcE+BDlC5jjeYaT721D+TeFueCczejHh1nQ2xvVO/kPSZGPRwhrNMeMyDOh+d1PEX+s5S6Efvl98tjE9plKG4tVWcHyI2VxZsxHUHiIKFJ8St1DYLTzMk0Pqqu7sU92mUSVSLJuhSs28ZuvRk2mKQTH/n1cqGM0MR4Liz44ABZ2+xF6bxESI+pZjKqcpoo+uTMxB5XgC2khXegTyLwj+5SkRT/k1OaU8rBNDS6o7RfS1Rop9St/ZlJoRch3UqrY7xc+Bi5rtaIAKtkkd+ZKpz6Sh190QJwqiX9UgTDw6/cWFqsrilo3MUYP8TJu/85iv4QiLYuKnNWhj9VTbY0nufnsm6a2i7FFrvYELh8D7W1NsghQHRSPxBFGDnWzlSFMAS5X32iSlzEwpe6Rs2GVziRayia3J/O3New4iamGO4/KyLSDEpXfGRvJWCZ0Uo3x4vDJcMWygpNNbxyPQiE4GqLYr9EciPu9NkeCz5quFzayVYt157nVyCwcinw+fHNOdEnFjduBIFMv2r3W70KRL9uxksFSzS0tEwVaitc1IUY+Pvsjq5By2K2exkMeG4XiMN
 PYsGOEXS
 7TbGNC+PyoOgMjJu9XUF29AK6OHgwjNbGGBNbxDEcGoTNskoL3oEor+rPr9shl3ZMFm5uke2Z2f2aOuIUqtlNShRDI1Y4ivkWM97eSAClsovXlaFUEjDgxVPRQfiz6hwamF8xd15Gvk/pWO+8HmuPmHW44jybYealG5omElm1FoAyWAnNFIsTftVYwyFU4CpQXj4ESushGbMtMOWvEo9Xvt2Gs+eJ2JX6uYVhouVUOPREN7hIyeLlowrrEJckpU1HsScmEum3K7tFAfWEE5fI77ecBhnplrQVtMEh67zi/vo3LmF9FYeValtpGeVquJDLLMAIVVuRfIIXFyqgjQUO7u3tRqRfokLjjM/bHRd2rbOMjR8adJ97MzcR/CT2ClAIFLqshM4w6n24Dn6KFnjjcyXTNtbQe9c+FEm8/PDg31chQbCr71nk1Fk0knILUEZMf49DqmlCVDy7/vMMONzvpzDxDcJfsOsYoJv+6pc7P3XAgxEg2QAQoEtnAk+QSpBPuvcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices and other
buffer_head-based I/O.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context. To fix this, we first defer
dropbehind completion initiated from IRQ context by scheduling a work
item to process a per-CPU batch of folios.

Then, add a block_write_begin_iocb() variant that threads the kiocb
through for RWF_DONTCACHE I/Os.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap parition (~1GB) in a memcg of size
244MB to force reclaim pressure.

Results: 

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         993.9          1799.6
   2         992.8          1693.8
   3         923.4          2565.9
   4        1013.5          3917.3
   5        1557.9          2438.2
   6        2363.4          1844.3
   7        1447.9          2048.6
   8         899.4          1951.7
   9        1246.8          1756.1
  10        1139.0          1665.6
  11        1089.7          1707.7
  12        1270.4          1736.5
  13        1244.0          1756.3
  14        1389.7          1566.2
----  ------------  --------------
 avg        1258.0          2005.4  (+59%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        2396.1          9670.6
   2        8444.8          9391.5
   3         770.8          9400.8
   4          61.5          9565.9
   5        7701.0          8832.6
   6        8634.3          9912.9
   7         469.2          9835.4
   8        8588.5          9587.2
   9        8602.2          9334.8
  10         591.1          8678.8
  11        8528.7          3847.0
----  ------------  --------------
 avg        4981.7          8914.3  (+79%)

---
Changes in v3:
- 1/2: Convert dropbehind deferral to per-CPU folio_batches protected by
  local_lock using per-CPU work items, to reduce contention, per Jens.
- 1/2: Call folio_end_dropbehind_irq() directly from
  folio_end_writeback(), per Jens.
- 1/2: Add CPU hotplug dead callback to drain the departing CPU's folio
  batch.
- 2/2: Introduce block_write_begin_iocb(), per Christoph.
- 2/2: Dropped R-b due to changes.
- Link to v2: https://lore.kernel.org/r/20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu

Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (2):
      filemap: defer dropbehind invalidation from IRQ context
      block: enable RWF_DONTCACHE for block devices

 block/fops.c                |   5 +-
 fs/buffer.c                 |  19 ++++++-
 include/linux/buffer_head.h |   3 +
 include/linux/pagemap.h     |   1 +
 mm/filemap.c                | 130 +++++++++++++++++++++++++++++++++++++++++---
 mm/page_alloc.c             |   1 +
 6 files changed, 145 insertions(+), 14 deletions(-)
---
base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


