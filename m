Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40580109C057
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422406B008A; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F95A6B0092; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F0C6B008C; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3C06B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2EEC8CA06
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:45 +0000 (UTC)
X-FDA: 84585577650.19.4A44853
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 73F3840005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DQGQun1h;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774467043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HA8D23GhyMmgO7Ma7d4u4MjK11kduWqDfN99ZCazVFY=;
	b=lpjPFFsp/MxtWjImQeuiQpWMjhNnpAnoxwH4b6STSOxXsBYtuG7gg7tuWwT4DDe28nW30i
	iVTJkn52fPxXhfq1M9IsBK0ldoue3gd3Q5Uh3Lffj79s3cc2yxXLe4C8DkoUlqI51uIocO
	E0R191GbgjM4yZKHYklO9Ibpic+q6rA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774467043; a=rsa-sha256;
	cv=none;
	b=1UZmcC2R7qJhmg4FWup7cr/S0pHAd5Kw8Ifs69aSqgNuQKNBzvJ+wlErDlujNKoQt2aJcY
	7lVcwHWYjXXGtLbGAD6M3UsYrpUUCxRcty5DBUGc0BFsemgNYwFnESQ38nVpVQu51V3MNK
	42HaVFQJBfdF6X9v3L0nRsLUnJRQTXY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=DQGQun1h;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PJSsGN478050
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=HA8D23GhyMmgO7Ma7d4u4MjK11
	kduWqDfN99ZCazVFY=; b=DQGQun1hSa+QSSxUr1i8su6bffWvkVZW2sXUVXgnlt
	spnIeP4au9kWZU6PdGp9HPtniIjnetnIaBZ/4Hit3Koj7U7ggQPK9cq5xePIQU77
	YlFwwGlCOaWH4hrsUEsr6/uSlFegWdbd0iMlu24ImT3aWBqZWHzRJg7xvZ5bTEu1
	weYJ8Uu1Jy+hPpNC/TiiyQHTRZWyIgj09wbccT+4egTjtLVkeqs4I16mYSCFUf+K
	fXBQuxcnDsxRTIzsQqwBxNXEQvUnHkGkbJwvMgMLXIzDGFZEiKixwOlC8nFIvy+D
	i7HLIHgQ5vueOIACUJxRXYmWRuwGCH9OOV6nGTk2h7GA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d42nnq9sk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:42 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5093025ffecso9773951cf.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467042; x=1775071842;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HA8D23GhyMmgO7Ma7d4u4MjK11kduWqDfN99ZCazVFY=;
        b=eXoaCWuOUW46J5Bz4ZWcIt65Bxu1GArUBc3nBkS4gZnRUf3DAcAMSb9xFT5lrCaE0A
         Y50YqADmuVCh+n7cOlpT84KKJbGi8dW5m2Sp3c+98h2MlaFECf5I7r/qzM3cZG7FljjA
         ODSQckVuub2yIA25rn3uC0oVinRH+twQay3XTinSdxm3Im5ohs6B7cLsIswiXal8hXdZ
         Tn+daBNfcEogIipjNJbYFcwVfbs95ihA+ZnlpJ17ecXykZLIkWHMfB6EHCz7dvKqRokZ
         Hk7vTq9w8pyNaD4EzgYg9lsrpA51L8GSFOf/k/BizBrAtNZ42TXESFUxBWbel6X5VVaf
         zqYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZj/XEvogC3OxKr1/YoYDs9xM2Ix2HR3MKX+XE814IiEo37aRZZki/elTPVE9GCcQ0lZUaWB1RBw==@kvack.org
X-Gm-Message-State: AOJu0YzkGY/UYQxIrBqCbksaqHPEA3WGMgtz44K5bxgHxETHb8i6LD42
	zUQjD7DJ/+fh73uP15VPn3kpOCg4k3eKI3fMvSLUPuoB2NJGmZX3/FXddGS1PMQkdLmgYqRCkM8
	UAZMQ7c+YUtsQn2ayzVu5rh7aeijjslA6CUTsXIjmmlo5cEjN
X-Gm-Gg: ATEYQzx8d0RnHRDWQCmeLDJEaxAFL9xp1vH2kUjdj1Yvh+T89HxO2pABiXBm6/JrhM5
	VBELH0o9EGbh8hF3oyATgMVgqkhbL7jT5DJIHVTg7H5jovhxrMBGnbXuT8Mm2xCdjMvedF2A2de
	EPC+c82lTUJRgKQzETkd/CYIojXp6uk8FWtZKNcCQkfWhzhjbZ1oTzamFV1cSxnay90auczovQ+
	YVYTC7uhCewYCknJXSYZcaL+qXC8ar+6p5Hg264o2iKH8W6pY/ZLMuUEShlCCyKuVL51mFj42IP
	gsSeQ/cVbCExbMK8Yj/0JtuTz6rrx3wHvMkRE9H40sLiZZOT9g2pwzw7d91kYghYyxw5jkH63nF
	3CwGQ3OEke4JdQihP2jn0mEkIhHsKzWpPhDHENQ==
X-Received: by 2002:ac8:660b:0:b0:509:3cd:b243 with SMTP id d75a77b69052e-50b80d1817fmr51206771cf.21.1774467039791;
        Wed, 25 Mar 2026 12:30:39 -0700 (PDT)
X-Received: by 2002:ac8:660b:0:b0:509:3cd:b243 with SMTP id d75a77b69052e-50b80d1817fmr51206021cf.21.1774467039043;
        Wed, 25 Mar 2026 12:30:39 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC v4 0/3] block: enable RWF_DONTCACHE for block devices
Date: Wed, 25 Mar 2026 14:42:59 -0400
Message-Id: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALMsxGkC/3XNTQrCMBAF4KtI1kby0zbVlSB4ALfiIp1MbLC20
 rRBKb27IatSdPne8L6ZiMfeoSeHzUR6DM67ro0h224I1Lq9I3UmZiKYKJjgJa2aBzVdO4CGGqm
 UJZfSGJblSOLm1aN17+RdyeV8IrdY1s4PXf9JPwJPpz9c4JRTq01RqByt4vYIXTM+K6d3aMaEB
 bEARL4GBGVUMVQasrhn5Q9ALgG1BmQEwEi2BzB5WayBeZ6/w0/PZzQBAAA=
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=4705;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=SDa413NBu0hIgtXUq9skjN+ObizbWtqbWL36k4Lizgg=;
 b=rVqeNMymQnbkbA09jjFwfm2fWjVL0ioo1AkqXQ5jcutSE4d0XRwJmwhfNzYW1IkNqhZq2eWVM
 qHy178rbPMXAdte8ZiWpsnVx+A2KACM+e+P4EnG/GBnw2X8s/dYeyYJ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: DM24Phh7GwerFK_bISURhk1RMyvYeLrS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfXwYN5Pn6t6wTn
 qkWIk56+dZzC5eSTBhGzoBhjDgugIIm+eu0EsrVErp4cLOywJon/mLq6WAwQjduTfGprF73apZQ
 JiQc8ZDrGWPuLIcrx7AMUlKJGoy6XPomZ7KjDJ2VXaxXnsBzSEqPgBwt/yNXnTAEMZIJyBS8sBH
 pBPPKFTK62iFWkpPmc1aAViEXbUfp+zSsdhfxEqDhUTMHVNcw3FAlEPI5WYvlu182m+zCNbk9RW
 yYLzE3tBNTMz2bfSALYVsgIpspd7bbr9xx6pdkmJoz9NrkJPn7RDvB3lMLjWG5u1HKiNgwnEKVu
 TyVDHGGTIQaSC0N9gLimk5fE3e/si4+ZJqV9zYX0hbf0D0VOAXayTE9kP9VP/ItfuM6YUv5T9NX
 jIWcjataE7cBhuXifcxIKfFGS2rPuV+DrODJ8D7aZldBCQ5WK8mth3n5SDpdNi2OL8d75WeYBrW
 OuZzBrZaN0KvLERv/uw==
X-Authority-Analysis: v=2.4 cv=A/th/qWG c=1 sm=1 tr=0 ts=69c437e2 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=tzuM4wBP0trzEmBACekA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: DM24Phh7GwerFK_bISURhk1RMyvYeLrS
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=10 bulkscore=10 adultscore=0 phishscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603250142
X-Rspamd-Server: rspam12
X-Stat-Signature: fmwzcszt8ktb7gq1hib5xmaspnm93ik5
X-Rspamd-Queue-Id: 73F3840005
X-Rspam-User: 
X-HE-Tag: 1774467043-856071
X-HE-Meta: U2FsdGVkX1+Uoh9NHNSE65wFjEpVGeITZ0kQo6t5wwPoVzb2xLSBBlQ9cgnhMpF0dypcF7uz/3yTvGVK1Rtb2g7Ee2uEp81x+2mjH9ulZFVM2fNQMA3GdrSounKRXCtw33rfJ4eQJYUnXq/IJzITQu96IM/vGGSuCdY0Ohb0yPIyOPt1AUm+VX8/w9cYSuUY2Zy+wKc3Y9e6G8Qqnlx90b9HPv6kh0pdQGn7tK1xH9IheCQoeFcEPjZW6zUZ670dJunmJGuJncxScrpSI6n8HQ9Sv7uPSXnHpdRh7MNa1H2GjmdYOysys/loFf3WcZ6edSZgRUCuDQaiWfj5fU7ChASaf7bwJtnoBS1cL7tAOILQzXooRDmoaOKeDxmSOtAsvi1qBXiHNYqhs4FN68c12DOMHtlNWWTyj/oVYx6dVi/HbDkj6IV1Cv150eTiRJ6z1Kz2r9YovB3Vtbr92Fpd+5IQvqhytTg4xMmGIPAdizA/yCMwG7QfilbD2VS9Jwb1IlDgi7kCO+C+2E9ZoeLVVq4jjvOIr9WHsOMI7eCxZ2u43soToT8V45pMTyrboJy1utdQlDfqZi1g6AdPw7pp9pu4/nt2vdvpARlm+ydgPdgUBQfXR2axOp5JasLRBDaGxhtTFIRuqZqN7AkxoeC3yoliyiONcH2RbG2SMthItwh24o3BbEporYXtuxlx5PiZ3WCd2zm2WOb5s2mta6GW8VrlKb/UKj3fbH/pgDok0fvbkkw5pEZR06U+yN27DRZSUM2ZN2i5ocYrcWRzKbBnT/k+BHXeuPqdoCV9IF8MC0q4Ah4U9G5e/8E27HFlkJadlcRewIuOBX5cSS82I6nB3YfqB1Aje5rQtWko9QCLNUw6CshG/zfzXHdz0NN6WAF2J7zWAbV6oIDCyi0cHBn6eVCOqguRS0mHTQInkmrjf2usqEEfDKnSN78BxsLQH5uOdLdp/aTYZwDfFS/Yh+0
 5zmEJr8/
 4Ipbz4ZGNKydzF8xwBMi5idlsaWoWoTn3MTwh+8wcRHU6Sl+fbt8ehb/JmrmLBxnoSgtyiSV40A/836TNVgNXlNuer1r1XkgoLcz8kZyKWbmX5c1/cXn/3zVTuQ+mcUNgBkke
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context.

To fix this, we can defer dropbehind invalidation to task context. We
introduce a new BIO_COMPLETE_IN_TASK flag that allows the bio submitter
to request task-context completion of bi_end_io. When bio_endio() sees
this flag in non-task context, it queues the bio to a per-CPU list and
schedules a work item to do bio completion.

Patch 1 adds the BIO_COMPLETE_IN_TASK infrastructure in the block
layer.

Patch 2 wires BIO_COMPLETE_IN_TASK into iomap writeback for DONTCACHE
folios and removes the DONTCACHE workqueue deferral from XFS.

Patch 3 enables RWF_DONTCACHE for block devices, setting
BIO_COMPLETE_IN_TASK in submit_bh_wbc() for the CONFIG_BUFFER_HEAD
path.

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
   1        1098.6          1609.0
   2        1270.3          1506.6
   3        1093.3          1576.5
   4        1141.8          2393.9
   5        1365.3          2793.8
   6        1324.6          2065.9
   7         879.6          1920.7
   8        1434.1          1662.4
   9        1184.9          1857.9
  10        1166.4          1702.8
  11        1161.4          1653.4
  12        1086.9          1555.4
  13        1198.5          1718.9
  14        1111.9          1752.2
----  ------------  --------------
 avg        1173.7          1828.8  (+56%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         692.4          9297.7
   2        4810.8          9342.8
   3        5221.7          2955.2
   4         396.7          8488.3
   5        7249.2          9249.3
   6        6695.4          1376.2
   7         122.9          9125.8
   8        5486.5          9414.7
   9        6921.5          8743.5
  10          27.9          8997.8
----  ------------  --------------
 avg        3762.5          7699.1  (+105%)

---
Changes in v4:
- 1/3: Move dropbehind deferral from folio-level to bio-level using
  BIO_COMPLETE_IN_TASK, per Matthew and Jan.
- 1/3: Work function yields on need_resched() to avoid hogging the CPU,
  per Jan.
- 2/3: New patch. Set BIO_COMPLETE_IN_TASK on iomap writeback bios for
  DONTCACHE folios, removing the need for XFS-specific workqueue
  deferral.
- 3/3: Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() for buffer_head
  path.
- 3/3: Update commit message to mention CONFIG_BUFFER_HEAD=n path.
- Link to v3: https://lore.kernel.org/r/20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu

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
Tal Zussman (3):
      block: add BIO_COMPLETE_IN_TASK for task-context completion
      iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      block: enable RWF_DONTCACHE for block devices

 block/bio.c                 | 84 ++++++++++++++++++++++++++++++++++++++++++++-
 block/fops.c                |  5 +--
 fs/buffer.c                 | 22 ++++++++++--
 fs/iomap/ioend.c            |  2 ++
 fs/xfs/xfs_aops.c           |  4 ---
 include/linux/blk_types.h   |  1 +
 include/linux/buffer_head.h |  3 ++
 7 files changed, 111 insertions(+), 10 deletions(-)
---
base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


