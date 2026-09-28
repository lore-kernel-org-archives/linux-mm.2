Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF62C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F096B008A; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFFA6B008C; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198C56B0092; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF4DB6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65A8E401BC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:42 +0000 (UTC)
X-FDA: 85263036684.25.9D3A655
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA8454000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aKaV9FI3;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qTPH+LuBBsdk+i/aIrmXxuiwVGclQtxHAckFFByBp5M=;
	b=GjTkeoT5xioptW6fm9hE9ZLG4SwadBis4pHAqX+/FpmlOGVW9TK9zhlVlzr1cM4cSx/jjr
	xARw6wQpztPbEIXRo+Xl3HF0vQO9mw0yfQb0e/Wx/s3DfR1Q8+xLDxhUA1ijYRaahC3uvb
	j5x6M8QqG1a0/Mr86YbETSnq6vmKI/E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aKaV9FI3;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597020;
	b=fvSOLGmkJGTNdjoh66VKav30lanQNuzSBXUQMlIfOMys1P2KlS1DfbSPaOwkDBVtW7Ksph
	SPxz3BQtivU6MNJMiQC3zcHl5XHr417xZK4HL2Z77/5Hd3VOf6u1oCF9KU1ABTTo8Y0Qz2
	d0vqpwB3DzvxRocKicXCf5KS97tk+ds=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZj3A1047250;
	Mon, 28 Sep 2026 12:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=qTPH+LuBBsdk+i/aIrmXxuiwVGcl
	QtxHAckFFByBp5M=; b=aKaV9FI3jI7ARTDtgdKARy/Gln7J0WgKptYYZuJ0FA24
	CSBQ0WjfklvLRwtfIvtiOSTACiTpwDwYmC4JYB8YTtSn0TAxzHVSonpZ1xzXcKlz
	M9et9lCETlPU38LWwU04qR71E0BAPczyk2LxO5fjJIPemTENnomznCSZpn5YrrjY
	xeXtZZsAhtK8ALoKaaT7uqjMVHQL7cAmNiZ43xxKJl8xxoo1COZdVJU+rG4PZ2BR
	R7tTyhZ2R9lv+P6yyk3lZSdngOJR5Q2GzmcoEfzZVYFg8dLFQWnmlrCaLs6mtklP
	UNbuJ2gG2WBNjUMyLz4tHHx9Uc5KEPsOzkDXE0pJqQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5164u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHVDs027102;
	Mon, 28 Sep 2026 12:03:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxrrw560q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3KYe48628072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AA7E20040;
	Mon, 28 Sep 2026 12:03:20 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 463E720043;
	Mon, 28 Sep 2026 12:03:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:14 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 00/13] Add RWF_WRITETHROUGH support to iomap & xfs
Date: Mon, 28 Sep 2026 17:33:01 +0530
Message-ID: <cover.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXxm8mFAPf+aii
 jNaEIGwjS0IM8PzZPyTD5ONZgkkpmILrsJU5uCbttsYSlZ78sze3UkiLvANCZUT+8f1s8Do3TiE
 MReLengLnpp34CXZtQqQdaEBOok3+kk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX77AIMzrREoE0
 EHKlUJiCZsdM+2TROmWmnciEg38yelgdCD3henNVSmdjgpHUACCEn/dN4ubcyFAduAddOjqb12s
 eLX0sFNIgAW7BW3gdJS0IcUy492WBLx7Yq4DwhStJNS7GX7+3PGEKFRFpH341puF51osCj6TMwx
 vxzbCCihRbHpIStH2zqBt0GyMe7j4LXnFDeNy5Juu/VZSXoOfaWI1mlYEno9Oj1I20Z7lnXhXm0
 ALY9pxN0pydHJnYD8Ko3W6c/W6Bh6FoAWhZMggqQ+HkG4cC7yQ0M8rrBs0fyhoR3RmmVkgH9U0N
 +p9xrakztK3VgyIHiDEE6ficOIc/tU90ZKTfw+t6xQ+UeQO5v8VwMTjDV852i/8Pp1ELNJBSHON
 C65MqJ16iDQMTLrF91YzMIsvYjDyNCDGQQSdMlBwfDWlk+/cMFG34YmNtULtRXoHDbNPQy8LU9l
 HqOPD/usFkCtt1XWwXQ==
X-Proofpoint-GUID: Lyu8jbUfO0hwPD7E7lAzJVb2JVhSV0lK
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6aba578c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NEAV23lmAAAA:8 a=07d9gI8wAAAA:8 a=wgoYdfdA01qhsVJ9b3MA:9
 a=QEXdDO2ut3YA:10 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-ORIG-GUID: Ph-RWe6UFrWNYTHhz5rKZh3wzdbuI3K8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280046
X-Stat-Signature: yos15too566nsd5gzz3ap79ke8z6o4je
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA8454000B
X-HE-Tag: 1790597019-696000
X-HE-Meta: U2FsdGVkX1+vEN56eSdZn6HaoqhvcVtjJNkJFkWIqxdest8hB15LaMzxNzQIy6kW60qByy2keRUtmHzeyizNbewAtcHQTZVzrQ0vECdCZSLM1co3BoTsQ6mMnz8TUiIOoCM5S6yIATllHFCE5Ps+aSjM/Ou5gethEe4s+vHdxfomz29LGl1qVqMaxRG5YmMsoAho0jeTfhkNUduzeRfawLLR232bPNhS/oirtVeFK3zM9WlUSu/pycAaDwBwqNE9ahvGKXfimt7ewZ8lu4/CwH5ui22buyg2/RQTRcG1oZcAFu3ijc4v5GU+J92ETw07nv8q5uVoI9dtzgE5ziv8mcHv9xCyVjjBCZSXDzESDJJPE3FS2anJGe2E9ADI7OJFh7o3lcaiJ4KNekO1sC221Sv4rDxutl6XlHvRvtEZRo0ohak2N12DK4ZbZgGgsltnInkOTdI0VQTNQoCwomYnZpqlZ6oD8i+D18fMEOM0DPz42a/f8g4XMZN4ujkVkg8g1vJSXS7yJ8z0n/xzFdLkaozZcHfRH2HPOO2iEW0LLNNvUtXTI0Z30y7JjXodX5ETmeab/911qztnRBxFT0O96HnGZOoL+EyMyH6WyqmXkPj/pve/+lzOs4eUYTxkKP2gkQseamCCzpbleeru92XY0VDxKrf2kTaXZQVDO5mwWc87zOoINQEOvOovXfUqGnCVL+LQriFDcUGSIYJ8CldH7c2F7nyf59oyWQyRe2uqSsbiYPe7DxfZXWqR3DDgi7zMYVCOlzSyNQ7pwwcXt7k75RP6A1uBc2cTQsLJdqCcdcH4oLM5aMdB2JAtu/9P4H5e5twSCOFFsT9Eo4c4J5Qo9H4gHMhY6XB8RFoS8qpzEB+wTOEcE3wFQ+YoooeTbVLwfLR1Q3Xy9YfNd6ISjwCXdHKGwAmFQRVbq0KL5mk4jX4AYQrMMuE3PrOJaN2zBWJDxC9QrH30Wz1GXX1HHwW
 r5EFv/d5
 +W8lB/UyEFKYdxq4OGWuo2RM74Z8zpfFGHP3HUo0v8EnrTEyQO735L4sW9ytzQShOiqB4RXWqhIOekOmmIVl+Gj8A2WzUJdqSX2lIW5eJ9W6Q3KdzCFlmFrFIuUvc/dQditOxPcQYQadAPcfKOxXP7STXKf/yPA3YjAPicLnbyShOpCgxPg9+4LysDnBisAx4rZFlbtsjEPIJvmHVTpgG1TnaqKHOdXz3rV7lhuqlOnWBHETIbNc8ZXx9/NQ/4OWyZ18exKPeXf89Surl/rNHzL+tRv71xW/tGfwmypb63h+t3Zd0H4eMydWvfRW7DgKU+6BKH++qQ9ZnjnD5gxfW1gYp/B3QfUzwLz/xofyEh6ymyHsLvKFAHVbiohl8McaHyeQJLQ1yadlfhYjMjugJKbMgbvdl08df54RinBCOzXGiIxlVTqcgmkjmpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the v4 RFC of RWF_WRITETHROUGH patches. Mostly the design is the
same as v3 with some changes based on Pankaj's review (thanks) and
Sashiko's comments. Further, the error handling is improved and more
defined. This series survives xfstests -g quick and fsx/fsstress
stressing, I'll do more rigorous testing once the design is stablized.

I'll quote part of the original cover:

  Hi all,

  This patchset implements buffered write-through IO in linux.

  This idea mainly picked up traction to enable RWF_ATOMIC buffered IO,
  however write-through path can have many use cases beyond atomic writes,
  - such as enabling truly async AIO buffered I/O when issued with O_DSYNC
  - better scalability for buffered I/O

==============================================
** Changes since rfc v3 ** [4]
==============================================

  Patch 1: xfs: reexpand iter to original count when upgrading to excl ILOCK
  * Small fix for xfs write path found while working on similar code in
    writethrough
  
  Patch 5: iomap: Add initial support for buffered RWF_WRITETHROUGH
  * iomap: Prevent duplicate bvec additions for same block across short
    copies in writethrough
  * Error handling changes to ensure address space error is set when we have 
    inconsistent folio state
  
  Patch 6: xfs: Add RWF_WRITETHROUGH support to xfs
  * Add a comment on lockless ip->i_disk_size usage
  * Proper error handling in xfs_writethrough_end_io
  * Restart writethrough checks and re-expand iter when upgrading to exclusive 
    lock
  
  Patch 7: iomap: Add aio support to RWF_WRITETHROUGH
  * Propagate IOCB_NOWAIT correctly
  
  Patch 9: Introduce RWF_NOSERIAL flag to indicate parallel reads/writes
  * NOSERIAL can be passed by user and isn't default on with
    writethrough. It needs to be explicitly passed (as per discussion in
    v3)
  
  Patch 11:  iomap: Avoid folio dirtying in case of RWF_WRITETHROUGH
  * We use iomap_start/end_writeback() instead of just setting the writeback
    bit like before, because we need the writeback xarray tags.


Adding some snippets from the original v3 cover letter (updated) below
as it goes through some important bits of the design:

1. Introduce RWF_NOSERIAL to allow parallel writes
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
submit the IO. This cuts back on xa_lock contention.

With c), the NOSERIAL flag allows us to do writes under a shared lock if
possible. This violates guarantees that XFS has historically provided however
its expected to be an advanced feature that should be used by applications who
know what they are doing. If used correctly, it can give a very good
performance boost to parallel workloads. This is something that was also
discussed at LSFMM 2026 [3]. Based on previous discussions we've kept
the RWF_NOSERIAL flag serparate to RWF_WRITETHROUGH but, for now, it is only
supported with RWF_WRITETHROUGH.

With b & c, we are able to see a good performance improvement in almost all of
the cases that were regressing. More details and performance numbers
specific to the NOSERIAL flag can be found in the respective patches.


2. Use REQ_SYNC | REQ_IDLE like dio
-----------------------------------
Writethrough doesn't go via the writeback mechanism and it's IO characteristics
are similar to dio. Hence we pass REQ_SYNC | REQ_IDLE in the bio, just like
dio, which allows us to bypass writeback throttling.


3. Move inode i_size update from completion path to write path
--------------------------------------------------------------
As per Dave's suggestion we originally wanted to update isize in
completion like dio however this resulted in a big regression in
extending IO because we end up holding the exclusive lock throughout the
IO. To avoid this, we can just take the buffered IO approach of updating
i_size in write path so that we can safely drop the inode lock and allow
completion to finish outside the lock.  This brings back the append IO
performance in par with buffered IO.

4. There's a deadock in v2 that is fixed in the last patch. If needed
this can be squashed in but I've kept it separate for now for easier
review.

===================================================================
Performance Comparison Tables (with fio snippet)
(Writethrough IO = RWF_WRITETHROUGH + RWF_NOSERIAL)
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


Thoughts and suggestions welcome!

Regards,
ojaswin

[1] https://lore.kernel.org/linux-xfs/cover.1775658795.git.ojaswin@linux.ibm.com/
[2] https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2
[3] https://lwn.net/Articles/1072019
[4] https://lore.kernel.org/linux-xfs/cover.1785908600.git.ojaswin@linux.ibm.com/

Ojaswin Mujoo (12):
  xfs: reexpand iter to original count when upgrading to excl ILOCK
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

 fs/iomap/buffered-io.c        | 658 +++++++++++++++++++++++++++++++++-
 fs/iomap/iter.c               |  10 +
 fs/xfs/xfs_file.c             | 155 +++++++-
 include/linux/fs.h            |  22 +-
 include/linux/iomap.h         |  51 +++
 include/linux/pagemap.h       |  15 +-
 include/uapi/linux/fs.h       |   9 +-
 mm/page-writeback.c           |  73 +++-
 tools/include/uapi/linux/fs.h |   8 +-
 9 files changed, 964 insertions(+), 37 deletions(-)

-- 
2.55.0


