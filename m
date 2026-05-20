Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79B7CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552096B009F; Wed, 20 May 2026 16:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502AE6B00A0; Wed, 20 May 2026 16:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330506B00A1; Wed, 20 May 2026 16:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF7C6B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7C90160E1F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:46 +0000 (UTC)
X-FDA: 84788992092.02.F33BB0A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B29F4000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=RaMC69iL;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuYZUEpkdlDPA/MoPFg1KYmaCTdNZxzaMhmmXnS7n5Y=;
	b=H+z5XRpO1vAB6RikJz4He47pBTAY+oTOJj6F01w4706+y7UA65FDLxbhVC/DS2+79CGzA+
	+o9QQR7ZMSmHbNZ4LUaKOiF0ygHUi9XeHXLJn0g8kUibfQ7sYMZoqwyEVWG6xY383ZAUxN
	LaYCIV75c1KQkO4tt2pC+Zvzz5gmXZ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=RaMC69iL;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310244; a=rsa-sha256;
	cv=none;
	b=jmXBhMMOfXBCtMphrDx38BUT6iA+BbyKi+vx88UBFly0ju/GetySexKnkh1btaUjn3KKJO
	zjqIhIIBVGdWHMEdBhT7E/zQZA5dStSzU/tOW/sSEew8aCLZAf2Up1qoa2s4dIx+CDQPKD
	zI6LWedwznAiFjSLg1SqTRVDrnsgBDs=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOKlZ3139292
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=NuYZ
	UEpkdlDPA/MoPFg1KYmaCTdNZxzaMhmmXnS7n5Y=; b=RaMC69iL96yzOK/lRDf+
	5JstGQzPJTY3tGXJTW72lq1IMm7QXNtfTzTcW2dJzro8iQN+IyGFfOMigEK5kXJC
	TkrRPLlM6LLPe9Qif+6bs3GDBj8mFTAx3sj1CYxGfo0lwJ12gOLSKkDssy69M3pY
	kO3SoZGr2BJkk0iYM1n0FLY1CbFqNx1ykfaoWTx5Gb/OxbWLZcWDyIt9kLP3mzNJ
	cSuJlBH9j4SixMkwpaTYSSyeuOORn178xTCgNO7LWnmh8yB6rbXufNbbbx689Wdj
	/ONqFgUH4ENnnf762oQfQfPGjfmIXn9BhZXTOIt21neOwtoYd6cH77WqV6mIabu4
	Rg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9d3hv05n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:43 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8aca29dcd69so154103396d6.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310243; x=1779915043;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NuYZUEpkdlDPA/MoPFg1KYmaCTdNZxzaMhmmXnS7n5Y=;
        b=U8UqDbdoa6l+kpD9KgY+hDZ32NwwgRlX6iXeV7NRPcZVP2w1L8UOUzdMZjUse/HZb6
         MGjyBGNTvq2OFq0L6r4XGshrBvso+HOzFG3xcAc226ue9/+CD/ibKPchrRlyvhWIv1yw
         8h6PLEhiwjBchhjqpOCqvZ1Uj/YqKfPedK+6i3P9eo3Jt/OVJkG29MhQHbESDW8FAjz9
         KKBrQUDYl9wQj4Ov2N7HFLh1CyEQfb7IEe2SRF7pIKs7DfuvQB6mVa6Y8KdzLjT8837f
         hqdnAhK2jNc9GcWLNZB0l1ZCquO1T/5on+r5LEYuua90fvTLcWIdOo6zAULalCxt1VPB
         X8lg==
X-Forwarded-Encrypted: i=1; AFNElJ8sHeumd2XA7i0dcVDcOfEGR6X4YsOek3RmGm3FYqowCXvnclkljGaWBVsBHz+oYw+PJk97GJ28Og==@kvack.org
X-Gm-Message-State: AOJu0Yw1aMGPf3/+P9H94HcxGWr1k3GQETExmLeJo+2Cs62ngajdsTHz
	KB+GKoU55nV6t2IK2pBtgKrY6beqA5aF5ip6fSPa/ECPoZAgE6tug+e5jntKSoY17DxsdLoesl9
	v2UMQRGG7ew4D9nQelEY/JDmk/pe1A5KD4c/d34C89LTDMhjL
X-Gm-Gg: Acq92OERS7mDRC4t+7I7m0J73lDk4pxjVnhIqi8e9OIrcG+Fnmx08peD12ZF6kRpnRp
	HNiW+ye8BLgDtAAM9Yhe4eVuTmHoxyy6pTS2dcGwcpU5WQQPZ5nAvrnu8rCcjurFzJZs1+ZMy5o
	HoTQ82C4X77jp0ocSSTYdHj3hxV0h730XCtgEagD5p//zZgB2VuTCbB8mpbnqg1LnMmlRaYzpcu
	W+wDnxvDJ+wd/mKnfgBIxso+ew3l4t6zwUZIKShBfm1a8hJmz+i3zzU3kGIcwqDH9/zaCUUQfgj
	9zbKPwOntlrGsPaUtbAx9UKgo9whfYZFSAsTdKjv3FsIrulBmQZ+RuIEn0kAJOGUKyA6cQIBJIN
	pS3DfnEsY9pKypNOzqmNSFkakEeOzcD7VpolpR7s4IH5a/Snnf+cHCItza40Z+cwYfnAgUL5oAV
	p+WQ==
X-Received: by 2002:a05:620a:258f:b0:8ed:dc5a:f668 with SMTP id af79cd13be357-911d00b7d27mr3703468685a.58.1779310242790;
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
X-Received: by 2002:a05:620a:258f:b0:8ed:dc5a:f668 with SMTP id af79cd13be357-911d00b7d27mr3703462585a.58.1779310242221;
        Wed, 20 May 2026 13:50:42 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:49:01 -0400
Subject: [PATCH RFC 10/11] fs: move generic_file_read_iter() to
 fs/read_write.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-10-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=8508;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sWXCb2voUNh/5RgXFZA32Pq1QXHhhJuRnYDZVKm8gu0=;
 b=c4SVT0/EKyeLALT++GoCtxlOHEW6EtdwGs6LfnqVwX3PEcOVGXnxyAlvuksJ5kGk//rUF733e
 +mKRneLOBHUCwxRiU2NqVzX9ZiVWHPnX8ZDbFnwJYl64fBDuIVt5eIF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fsvsol4f c=1 sm=1 tr=0 ts=6a0e1ea3 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=gH0tmTfNonLjgA-2hfQA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-GUID: CIdjldE-nF1Yd12cjr9f3w1erVsVX6nM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXxU2Al5cCh26D
 AdHXbemv9xjewmXJoXUC/MiwwMKtVMiPQUUivED08zKtTGquQfb/NmHERYcddEln2v5KEyuD2jY
 JfS5Eo3eWmrlSj2QOAjQPBWRfbNCfHp7HkRnHSYjlew2SpAHAYx5v92flvR7DDPv+NP5O8R9f4Y
 3gXA6KZybFwXEpQkfZsxKIVkANt4qdITIsurSS8g/G9/zXmqrfQflcoL460R10B4oB2/JDgh73C
 g9wt0IR/fMVjtdxaMG4faKZTjQwyqGjK4KcEAOFHMuVudJwFB14p8nHSA37H2Txi9XluZ2xyc2S
 4Zpgmhu1sXs0u0cQWqVDpOyRIcoW1E9lV9Yj3/SfFw8qcczzuKhzm8ofWCEq47m3eafTVOaCMKp
 R2rDT2UYSRxEAJDQ7j4jBhplDkyK5ASInkogqUtEeMV5f5j9QdvDPIzWP91zkw2JivwXRIJW+Ur
 6IMrdguTcz35KfkGstA==
X-Proofpoint-ORIG-GUID: CIdjldE-nF1Yd12cjr9f3w1erVsVX6nM
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 suspectscore=0 spamscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=10 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Stat-Signature: xit1d91kbj9x17nbj5fhfa8wnds16t3d
X-Rspamd-Queue-Id: 6B29F4000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779310244-985730
X-HE-Meta: U2FsdGVkX19sRiQyvuGj6SSGqhw//G9mzjtbY2jYTZXCsXilgKzNqgYW+94YfUH08f9t3EESGG0JLPlq3/B6P3mQ0HXZU4vQ4WAs4ZQGxKrDO+61sVV5h8dCtzIlASZqW1vy0pRk71ohdX6XwDEjxidLrVt9RVU/x2w/zqI5D/Zkv33Eo1/N9I+zRvQTyGEL0hEt1NXwJ1YZG7ARZyyDdwL41SvQMiy1W6Pf5g2xqistXUm/09MThoohs7ZQ+UFQAOp8AY/LdGCJLj1n6um6yWAzvia8PycQmxV1AHWqoPcXqvr1ocBGk3S8Xf1+FIzkQNoLBOqr3DLgpUi2ZQb32NSMp9pkzMjKjcVx+jbCmdXIJUnfhj/EUF+RK1C0n17BNoAMePw+i9ajhdcrRUxKqfHp2m5Kc2dDOTQeO560RArl7dMzV8vk9s1FqBmWJHOlSjViUfbNWQZ43ePo3+vgD7pI/HCvBjwQO+ORvSEiThyck2lnRIC5xR4OOb0+L6MGMg5Gvd9H8cSUK6tn7ebaVj/sRBABet4/zWsDiifT8hpLl/W+TdZfCOOzqHMZmdEjcL4TEgU6h4rksy76l42tY58Qn/Ar/fR7ImYYVBACN6iqKWwzl46J3x7y5hNYwPk3713NsTFgXdmnc/TbIW4i8ZvWmsc1tDl+crTJxreYmYtovw+86CJ9j+64P9bpXOdsaR4UzEwdx/bUqtGYqVAaxdMVIwRcfXFqx0qsUiuK1aCnaijhuDvGZf9tGALKpNytMPhQw156A8Uh6aZnJGgQgIV+g9T8IRqNifqx4BClkdQTx+8MonnK+9yokop269Zy6dxJi1qK5G2ohKhlpDLYrIImUs7E1MFg/92JvbnzYfGhTvBHveCV9k96blbSadxWzpOudRTlliMyBtFOhJaExfeerLcZBGAZFNbtvQdJdOxhPu9dbSUSg8urRIpXX1CGXgNJze9dzEyrepoxJ+m
 kCSzhs+q
 PYzCKNIoQ9m9oUpq7AOhzaecqMPG9Hnf+LAYfh8sB4XkOG2KPkxC1iFwOqtUA6gCQ/mOnJEI9invuA6nCuTRyi1bw8s0PkGq70Gq6JWjVWiwkpAeqbagdgZVII7gqhik35Fm/gPYfvcpgFK3mt110FkzG1dRGcCDLR596eRnoikaLmondbVIrWkDH6XuLsO/jdOz9+o0538weVB8/GwWYVEh2UxqxsmfLEr5dywBT3GmWHtNfUJvzt/48SycYDr98hf1NeIq6Nmn9maB/ULohCdVcE2kkNPohS4Wp5z4jFxAqCSfAz5i2eGY6iR/CsGAnLH7Wrqs4DipKLbwRUYIcF/vk/Dgwk0EmTn0KBaLeYNO+9Q1M84COKx1/wGicLYSOZW+P6+OmjI+xcalCP6zqpjnH5VU56AcOIv1PmVzhxMx4liUi3/6eBbA+T9atvzOGIPBgxNNAPfbTZoZz1pkGkWo+J3aFxE3e1lTcHAUfrVQw5Yg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_file_read_iter() and its kiocb_write_and_wait() helper are
VFS-level read functions: Their callers are filesystems, and their job
is to glue direct I/O or the page cache (filemap_read) to a struct kiocb
and iov_iter caller.

Move both to fs/read_write.c, alongside vfs_iter_read. Drop the extern
from generic_file_read_iter()'s declaration and reflow the
generic_file_read_iter() definition to fit on one line too.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/read_write.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  3 +-
 include/linux/pagemap.h |  1 -
 mm/filemap.c            | 82 -------------------------------------------------
 4 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 50bff7edc91f..59ceea85c163 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -989,6 +989,88 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 }
 EXPORT_SYMBOL(vfs_iter_write);
 
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (filemap_range_needs_writeback(mapping, pos, end))
+			return -EAGAIN;
+		return 0;
+	}
+
+	return filemap_write_and_wait_range(mapping, pos, end);
+}
+EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
+
+/**
+ * generic_file_read_iter - generic filesystem read routine
+ * @iocb:	kernel I/O control block
+ * @iter:	destination for the data read
+ *
+ * This is the "read_iter()" routine for all filesystems
+ * that can use the page cache directly.
+ *
+ * The IOCB_NOWAIT flag in iocb->ki_flags indicates that -EAGAIN shall
+ * be returned when no data can be read without waiting for I/O requests
+ * to complete; it doesn't prevent readahead.
+ *
+ * The IOCB_NOIO flag in iocb->ki_flags indicates that no new I/O
+ * requests shall be made for the read or for readahead.  When no data
+ * can be read, -EAGAIN shall be returned.  When readahead would be
+ * triggered, a partial, possibly empty read shall be returned.
+ *
+ * Return:
+ * * number of bytes copied, even for partial reads
+ * * negative error code (or 0 if IOCB_NOIO) if nothing was read
+ */
+ssize_t generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	size_t count = iov_iter_count(iter);
+	ssize_t retval = 0;
+
+	if (!count)
+		return 0; /* skip atime */
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		struct file *file = iocb->ki_filp;
+		struct address_space *mapping = file->f_mapping;
+		struct inode *inode = mapping->host;
+
+		retval = kiocb_write_and_wait(iocb, count);
+		if (retval < 0)
+			return retval;
+		file_accessed(file);
+
+		retval = mapping->a_ops->direct_IO(iocb, iter);
+		if (retval >= 0) {
+			iocb->ki_pos += retval;
+			count -= retval;
+		}
+		if (retval != -EIOCBQUEUED)
+			iov_iter_revert(iter, count - iov_iter_count(iter));
+
+		/*
+		 * Btrfs can have a short DIO read if we encounter
+		 * compressed extents, so if there was an error, or if
+		 * we've already read everything we wanted to, or if
+		 * there was a short read because we hit EOF, go ahead
+		 * and return.  Otherwise fallthrough to buffered io for
+		 * the rest of the read.  Buffered reads will not work for
+		 * DAX files, so don't bother trying.
+		 */
+		if (retval < 0 || !count || IS_DAX(inode))
+			return retval;
+		if (iocb->ki_pos >= i_size_read(inode))
+			return retval;
+	}
+
+	return filemap_read(iocb, iter, retval);
+}
+EXPORT_SYMBOL(generic_file_read_iter);
+
 static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 			 unsigned long vlen, loff_t *pos, rwf_t flags)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 776cc82932a7..c0151ced8e7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3055,7 +3055,8 @@ extern int generic_write_check_limits(struct file *file, loff_t pos,
 extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
 ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
 		ssize_t already_read);
-extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
+ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index f86a550ad516..46cefd552a51 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -59,7 +59,6 @@ int filemap_fdatawrite_range(struct address_space *mapping,
 		loff_t start, loff_t end);
 int filemap_check_errors(struct address_space *mapping);
 void __filemap_set_wb_err(struct address_space *mapping, int err);
-int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 
 static inline int filemap_write_and_wait(struct address_space *mapping)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 079f9c3ac8a2..db7c53cd681b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2251,22 +2251,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(filemap_read);
 
-int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	loff_t pos = iocb->ki_pos;
-	loff_t end = pos + count - 1;
-
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		if (filemap_range_needs_writeback(mapping, pos, end))
-			return -EAGAIN;
-		return 0;
-	}
-
-	return filemap_write_and_wait_range(mapping, pos, end);
-}
-EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
-
 int filemap_invalidate_pages(struct address_space *mapping,
 			     loff_t pos, loff_t end, bool nowait)
 {
@@ -2302,72 +2286,6 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
 }
 EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
 
-/**
- * generic_file_read_iter - generic filesystem read routine
- * @iocb:	kernel I/O control block
- * @iter:	destination for the data read
- *
- * This is the "read_iter()" routine for all filesystems
- * that can use the page cache directly.
- *
- * The IOCB_NOWAIT flag in iocb->ki_flags indicates that -EAGAIN shall
- * be returned when no data can be read without waiting for I/O requests
- * to complete; it doesn't prevent readahead.
- *
- * The IOCB_NOIO flag in iocb->ki_flags indicates that no new I/O
- * requests shall be made for the read or for readahead.  When no data
- * can be read, -EAGAIN shall be returned.  When readahead would be
- * triggered, a partial, possibly empty read shall be returned.
- *
- * Return:
- * * number of bytes copied, even for partial reads
- * * negative error code (or 0 if IOCB_NOIO) if nothing was read
- */
-ssize_t
-generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
-{
-	size_t count = iov_iter_count(iter);
-	ssize_t retval = 0;
-
-	if (!count)
-		return 0; /* skip atime */
-
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		struct file *file = iocb->ki_filp;
-		struct address_space *mapping = file->f_mapping;
-		struct inode *inode = mapping->host;
-
-		retval = kiocb_write_and_wait(iocb, count);
-		if (retval < 0)
-			return retval;
-		file_accessed(file);
-
-		retval = mapping->a_ops->direct_IO(iocb, iter);
-		if (retval >= 0) {
-			iocb->ki_pos += retval;
-			count -= retval;
-		}
-		if (retval != -EIOCBQUEUED)
-			iov_iter_revert(iter, count - iov_iter_count(iter));
-
-		/*
-		 * Btrfs can have a short DIO read if we encounter
-		 * compressed extents, so if there was an error, or if
-		 * we've already read everything we wanted to, or if
-		 * there was a short read because we hit EOF, go ahead
-		 * and return.  Otherwise fallthrough to buffered io for
-		 * the rest of the read.  Buffered reads will not work for
-		 * DAX files, so don't bother trying.
-		 */
-		if (retval < 0 || !count || IS_DAX(inode))
-			return retval;
-		if (iocb->ki_pos >= i_size_read(inode))
-			return retval;
-	}
-
-	return filemap_read(iocb, iter, retval);
-}
-EXPORT_SYMBOL(generic_file_read_iter);
 
 /*
  * Splice subpages from a folio into a pipe.

-- 
2.39.5


