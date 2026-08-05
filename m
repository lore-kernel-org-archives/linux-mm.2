Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EC1C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D632D6B008A; Wed,  5 Aug 2026 02:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A2C6B0092; Wed,  5 Aug 2026 02:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29616B0093; Wed,  5 Aug 2026 02:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2126B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:28:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D98640307
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:47 +0000 (UTC)
X-FDA: 85066237494.06.0D19A46
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id A2A5118000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fcoiw1zo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pkmszG1Na0Plls6Ov9aF6W6+pkS7H87z0OudU7AipEA=;
	b=JD08A3GJ9WFpRdoftueQqvkKNWomJ5RyMMijTk8wBoVfGtc3QcNpOotyHnwv2Sp5xVzM5j
	DhTvcZ2CxZ810UTCVX531Wpus2pFDwUdhPmwz8iK580MrkLte+Y7kau1BVdBsDZgCEGShJ
	W9n5nQZea5L/L60Y7xg57LcDkwiWzl0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fcoiw1zo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911324;
	b=45WWYSIUqhx2sLtHoBio7S89WQM6q0Uy5lijD4jaR4gbCip7+DS6rcAlM/2b/iJ3/XYcgY
	Aw+DcwnMndUVWY2L9bHsUDSZs12/eFFh556BibNP1vJnR4k3mP2stSXw+T7L4VgekJ4Q0C
	ZlAzqcvM7jQ0FgrSL/Kh7l/nZU3OJqo=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lb6f3005243;
	Wed, 5 Aug 2026 06:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=pkmszG1Na0Plls6Ov9aF6W6+pkS7
	H87z0OudU7AipEA=; b=fcoiw1zolg7N2glZkLMFbEgf7O0tbshn53/OKjRxO+60
	8RGcQCJ9WTS+widBgeR6PeXYbP3YyhJYFoQE/kHlpGhkQezrmRiLJ0IqkjOGP1Av
	EKPRH7JhnoF/RxkUG29mmdd4iRg+04vfq3NTw/oP2EJIMYCuQjNTjVHeHFcSbb9m
	JIWf9ZA0ojpPV0eWhpxQjk9fWWlTd9kf2dd8E2iPsIZ4L5vanZ0J8IU9gv091HxO
	YaWPWhQxkjfpZRXDfsP2rRAOCxlehisFlHUXW4kGQ1TPxmu4qqi6A92giYElQsTo
	EQAPToBZAqfK0wvH6E5mbVU2gIMRpFPK7chOwgrI0Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51n0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QGEL019919;
	Wed, 5 Aug 2026 06:28:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhd8nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756SNMd15991084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EAA820040;
	Wed,  5 Aug 2026 06:28:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABA2E20043;
	Wed,  5 Aug 2026 06:28:18 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:18 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH v3 00/11] Add buffered write-through support to iomap & xfs
Date: Wed,  5 Aug 2026 11:58:06 +0530
Message-ID: <cover.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX040WrqKKshqY
 FrS/kJQdw05jrBISY1djrEsj36ImOXuyb4lZwBgsYAJKgty0Nd88B7SRmAI4o8zvmEzMM0I6Gvs
 hXqQlPpjeHwo/5GtKNoZGEf8WeIfxCk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX0d3YBn046skv
 dhDTyn5eolVNzpZNGtKCF3zJ5VibDB51kkf7VjURbWPmxymPFlhHiD032w2hoB6EfoI5pfqOA43
 F75m5lpxs6SjIs2ZnZUnLOQlZIITBM5WiGUvMmaSwJGa0PQnZ1TeFjJAgIvi7Cbxn82NcvgcP5g
 QWrH8Y8tBntYoH6kuFMhaHCvmtQs+2yssa76k0v9uHyEt55CYxtAbREC/4g5WNpBA3XcBW+Mso0
 IQoAEhSQZ0HgCkOEx4L23KKaU7Z+aew9vbp2RrffyDhVNwXPART7hOrMLciaWewDiaGJsTtAl9Q
 CtEfH4aKrY8Ym8mCb9uvVJOcPLLzospNON2a8RyCVPHT8BPfLV9bi1SehdmGPBmrF1oWcjlMUYT
 0Vm4xsLtDav0aGO5hLDIQRGs2qZOpJNVdiW1GdzL2pyyISb1sxUBaFinNvR/Ar4hZK+4IwGbw+P
 sPn8yGUiJgdlVYWJGOQ==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d80b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NEAV23lmAAAA:8 a=07d9gI8wAAAA:8 a=hlUArMIrs65LrmiY9OkA:9
 a=QEXdDO2ut3YA:10 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-ORIG-GUID: 5CcLuVUzKl7wftjPtEFqPbcnVio5BxHP
X-Proofpoint-GUID: _hz0RkEw3IBUz3S1xAiLJDRXO3jCZBEr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: kyex1oqgcfz9fyj9oosu7m8bd1uswtq1
X-Rspamd-Queue-Id: A2A5118000C
X-HE-Tag: 1785911324-912080
X-HE-Meta: U2FsdGVkX1/uneeNPnwku5j0nboYZo2hbA7hdO5WRn3cToN4CfYxbXmcL/x5fJWaPF0plYK+PrHUwXX8apOAwa6uWAWY2J+7rz4wDwCA1Q1/wqBSF0dBLBq4NBoKiCFPGJN3ZWTtajX+dxkLG7PS1VvoRFpzp43uDJ1NGJ/7RRVIeTNyJXkw+nvwdt8zAn+I8mjkKi9EoNHpqgQh/GIaFVAGnSJnp+VyAwE0q1nsK41xF7Sc5/vTbEMrcJI8qAcM2ljNZJbZwvDc3NrdgwPCCHY68IxWbqL9+bkwltpxcPY6WlvDNw4smmx+QAYjTnndkJNQz93r1I/wd5mLQggowwDMtjGfILQG9SLBbeRiQH7Tek3Ap1W2wkubt6FQKysVYyZRHhqvBGQa0LWDCC1aoxZqiPXMgn/RXJo/traaEFYyaefO97vS7tZopzjirsbVgJ1GUwwsRKN40+fnCcPh3LZuuECe/4DpfIbRaI8oUGdxxyri5T4fNOTlTTUmIL9QCaUBZgMPGGiSMZAbDZunMZrlecDm4JtYwclkB1AnY/13lKyJAjr3/I6Qh4XiNbWdFr2MfBA7bJGQlB8UydfxD6uOxRDK4F4y3Qdtp6YHLY6gj5oHapLruVWIbPz6Bgw+deOqtaVM3Z2shlWdHzYDKtVVug/sxdEvwnE25ht2NKlk0wc9oN4P3GANEXaOOU02R3bEOY/8m2f80EQsxsaR+t8S8ywsB6mEKwVjMB+4Hhz3sKC/JyTSqHCtn9g3KRzw2OERyGh2yLzzDCobBNobXDqXoHVSRaapL2QacMnN8p8ufwaRkdXn/XraGaadGIQhbujpSCriKRx7zl6FWtAJTeyccj8lVgCTfI62vWxCawWNu/1DTfPpYQuGswlIEjSzEL3CKsLtXZ8xQFw3PdBoXrjd9g7eLuZV3R9sAk1a2Is5vPpM+jJYh9NsPkod2iU9M1lm4qO2E2MMd9s3V12
 LBweNVQD
 g9sx/zO8LtzEiWkli8PL1qfywnZaTT1i8OKYcPFpYYts+IArClhcyW66igG0GtUlsjC5WUTO6C0brXjgzuf/LwqKhgN5NKUOzPB23NAXNKY9LMfZJSUsJ15aVwU4nCz2oAmDiCVMK9XPf+2KX1hCsSycJsuV3fXhcE5j7YGP3C3OukIz6P3vB4D/fNg4IzTEhkOn1CEKqERERMEUOZWts63hfCdynZaNM1UHNH2N4SmaYGlDiOkjMeaW30PplpRzjiQGX1897IpG2p4L8hasq2S37JgHH889gZ3lIE6FWilMK+kSqzLlM8Yw/eYi8nqoUDPXiShXUrhohE6JImC7NfsHWZ+3EjoXM30AS41+OI7BGBmq8dD7nGm80DKwy1tFvFlAiMRsAzPQJYbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the next revision of writethrough series. I'll quote part of the
original cover:

    Hi all,

    This patchset implements an early design prototype of buffered I/O
    write-through semantics in linux.

    This idea mainly picked up traction to enable RWF_ATOMIC buffered IO,
    however write-through path can have many use cases beyond atomic writes,
    - such as enabling truly async AIO buffered I/O when issued with O_DSYNC
    - better scalability for buffered I/O

==============================================
** Changes since rfc v2 ** [1]
==============================================

1. Refined the error handling semantics:
----------------------------------------
Writethrough has 2 steps - memcpy to folio & IO to disk. Only the part of write
completely submitted to disk is considered successful. With that in mind we have
2 types of errors. Suppose we have 16K write and we encounter an error after 4k:
 a) If have only memcpy'd the 4k and we are able to submit it for IO, then we
    can return 4k as a short write, since everything is consistent.

 b) If we have memcpy'd the whole 16k but faced and error (like EIO) after the
    first 4k write, then we return the error to user. Since the page cache is in
    inconsistent state, the user must treat this as a buffered IO fsync failure.


2. Introduce RWF_NOSERIAL to allow parallel writes
--------------------------------------------------
As per our discussions in LSFMM 2026, we noticed that writethrough (v2
design) suffered from a big regression (~65%) in workloads with multiple
writers writing to a single file. This is because writethrough submits
IO within the inode lock and since buffered IO has an exclusive lock in
write, this hurt massively. In LSFMM, we discussed 3 approaches:
  a) Defer IO submission outside inode lock
  b) Avoid folio dirty - clear cycle
  c) Shared lock for writes

We tried a) by only staging prepared folios in a list under inode lock and then
submitting them outside. However, the initial implementation still showed
around ~30% regression even though the code complexity was significantly
higher. As the ROI was not worth it, we dropped this idea (if there is
interest I can share a github link for these patches). So we finally
decided to go with b) and c).

With b), we can avoid cycling folio through dirty and clear as we immediately
submit the IO. We also don't use the heavy folio_start/end_writeback() and
instead only use the writeback master bit on folio. This cuts back
significantly on xa_lock contention.

With c), the NOSERIAL flag allows us to do writes under a shared lock if
possible. This violates guarantees that XFS has historically provided however
its expected to be an advanced feature that should be used by applications who
know what they are doing. If used correctly, it can give a very good
performance boost to parallel workloads. This is something that was also
discussed at LSFMM 2026 [3] and since WRITETHROUGH is a new path it
seems like a good time to introduce such a semantic change . For now we
auto apply NOSERIAL for writethrough and disallow users to pass it till
we finalize the semantics.

With b & c, we are able to see a good performance improvement in almost all of
the cases that we regressing. More details and performance numbers specific to
the NOSERIAL flag can be found in the respective patches.


3. Use REQ_SYNC | REQ_IDLE like dio
-----------------------------------
Writethrough doesn't go via the writeback mechanism and it's IO characteristics
are similar to dio. Hence we pass REQ_SYNC | REQ_IDLE in the bio, just like
dio, which allows us to bypass writeback throttling.


4. Move inode i_size update from completion path to write path
--------------------------------------------------------------
As per Dave's suggestion we originally wanted to update isize in completion
like dio however this resulted in a big regression in extending IO because we
end up holding the exclusive lock throughout the IO. To avoid this, we can just
take the buffered IO approach of updating i_size in write path so that we can
safely drop the inode lock and allow completion to finish outside the lock.
This brings back the append IO performance in par with buffered IO.

5. There's a deadock in v2 that is fixed in the last patch. If needed
this can be squashed in but I've kept it separate for now for easier
review.

6. Added a patch to make stable writes more compatible to our usage
model. Check patch 1 for details. Thanks to Darrick for suggesting
this!.

7. Addressed reviews from Jan and Sashiko (thanks).

===================================================================
Performance Comparison Tables (with fio snippet)
===================================================================

Table 1: Extending writes using (libaio + O_DSYNC) - All writers on single file
+----------+-------------------+---------------------+
| numjobs  | Buffered IO       | Writethrough IO     |
+----------+-------------------+---------------------+
|    1     | 133 MiB/s         | 133 MiB/s (+0.0%)   |
|    2     | 179 MiB/s         | 243 MiB/s (+35.8%)  |
|    4     | 253 MiB/s         | 358 MiB/s (+41.5%)  |
|    8     | 366 MiB/s         | 376 MiB/s (+2.7%)   |
|   16     | 474 MiB/s         | 449 MiB/s (-5.3%)   |
+----------+-------------------+---------------------+
(fio --ioengine=libaio --writethrough=0/1 --bs=4k --rw=write \
     --iodepth=32 --sync=dsync--file_append=1)


Table 2: Random pure overwrites (libaio + O_DSYNC) - All writers on single file
+----------+-------------------+---------------------+
| numjobs  | Buffered IO       | Writethrough IO     |
+----------+-------------------+---------------------+
|    1     | 131 MiB/s         | 391 MiB/s (+198.5%) |
|    2     | 377 MiB/s         | 791 MiB/s (+109.8%) |
|    4     | 695 MiB/s         | 1591 MiB/s (+128.9%)|
|    8     | 1217 MiB/s        | 1846 MiB/s (+51.7%) |
|   16     | 1197 MiB/s        | 1844 MiB/s (+54.1%) |
+----------+-------------------+---------------------+
(fio --ioengine=libaio --bs=4k --size=2G --sync=dsync --writethrough=0/1 \
    --overwrite=1--rw=randwrite --iodepth=32)


Table 3: Random pure overwrites (libaio + O_DSYNC) - Each write writes own file
+----------+-------------------+---------------------+
| numjobs  | Buffered IO       | Writethrough IO     |
+----------+-------------------+---------------------+
|    1     | 187 MiB/s         | 389 MiB/s (+108.0%) |
|    2     | 373 MiB/s         | 781 MiB/s (+109.4%) |
|    4     | 706 MiB/s         | 1568 MiB/s (+122.1%)|
|    8     | 1222 MiB/s        | 1796 MiB/s (+47.0%) |
+----------+-------------------+---------------------+
(fio --ioengine=libaio --bs=4k --size=2G --filename_format=.test_file.\$jobnum \
     --sync=dsync --writethrough=0/1 --overwrite=1 --rw=randwrite --iodepth=32)


Table 4: Random 16KB overwrites with sync_file_range:16 - Single file
(Roughly mimics postgresql IO pattern)
+----------+-------------------+---------------------+
| numjobs  | Buffered IO       | Writethrough IO     |
+----------+-------------------+---------------------+
|    1     | 1323 MiB/s        | 1275 MiB/s (-3.6%)  |
|    2     | 1779 MiB/s        | 2434 MiB/s (+36.8%) |
|    4     | 2092 MiB/s        | 2519 MiB/s (+20.4%) |
|    8     | 2272 MiB/s        | 2517 MiB/s (+10.8%) |
|   16     | 2328 MiB/s        | 2525 MiB/s (+8.5%)  |
+----------+-------------------+---------------------+
(fio --ioengine=libaio --bs=16k --size=5G --writethrough=0/1 --overwrite=1\
     --sync_file_range=wait_before,write:16 --rw=randwrite --iodepth=32)

* Environment details *

CPU        : IBM Power 11 LPAR
Memory     : 62Gi
Storage    : Samsung PM173-series Enterprise NVMe SSD
Kernel     : Linux 7.2-rc1
Filesystem : XFS (4k block size)


[1] https://lore.kernel.org/linux-xfs/cover.1775658795.git.ojaswin@linux.ibm.com/
[2] https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2
[3] https://lwn.net/Articles/1072019

As usual, thoughts and suggestions are welcome :)

Regards,
ojaswin

Ojaswin Mujoo (11):
  fs: Add counter to track inflight writes that need stable pages
  mm: Refactor folio_clear_dirty_for_io()
  iomap: Add helper to revert iomap iter
  iomap: Add initial support for buffered RWF_WRITETHROUGH
  xfs: Add RWF_WRITETHROUGH support to xfs
  iomap: Add aio support to RWF_WRITETHROUGH
  iomap: Add DSYNC support to RWF_WRITETHROUGH
  fs: Introduce RWF_NOSERIAL flag to indicate parallel reads/writes
  xfs: Implement RWF_NOSERIAL to parallelize RWF_WRITETHROUGH writes
  iomap: Avoid folio dirtying in case of RWF_WRITETHROUGH
  iomap: Handle deadlock due to repeating folios in RWF_WRITETHROUGH

 fs/iomap/buffered-io.c  | 570 +++++++++++++++++++++++++++++++++++++++-
 fs/iomap/iter.c         |   9 +
 fs/xfs/xfs_file.c       | 135 +++++++++-
 include/linux/fs.h      |  29 ++
 include/linux/iomap.h   |  50 ++++
 include/linux/pagemap.h |  16 +-
 include/uapi/linux/fs.h |   9 +-
 mm/filemap.c            |  22 ++
 mm/page-writeback.c     |  49 +++-
 9 files changed, 861 insertions(+), 28 deletions(-)

--
2.55.0


