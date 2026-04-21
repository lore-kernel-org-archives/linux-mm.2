Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B438F94CA4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 18:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624B66B0005; Tue, 21 Apr 2026 14:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6516B0088; Tue, 21 Apr 2026 14:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5AF6B008A; Tue, 21 Apr 2026 14:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2DE6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:15:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9D3DBD886
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:15:56 +0000 (UTC)
X-FDA: 84683366712.20.DE5DC6D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81FD818000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:15:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o8/qWa4t";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776795354; a=rsa-sha256;
	cv=none;
	b=6wi7g3HZQZtbfJ1riMOfLbxw+rTIrI9tqtckdd7F0PKtnZQpdlJkBzZbngVFlVUErZ4l1I
	UBOgjBsSdSHzY9mQeeWP5T0MGZskepDWWIQcj6ocGeAKl0ZQfFRhqbVQPDDdsoQUlB+lMD
	1dN7KiqaqnP/8F4u+ylspw+cRQNEW34=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o8/qWa4t";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776795354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/M2ql55deJBXwgrNvuvQcgHfU/E88NoJNIezEXyITc=;
	b=4G6D20nLcKKaoCF8UFKbpGVHytHDOBHc71I+VcCN/KCFiVvSW1vOZMFO68wpCeqtlEbX7b
	OrT62lCgJ99jPtox/N0pr/zyANuvPQuOsM3XleJZ9viVGcGW23Qi0ziwJ+3dcluss9Xe8L
	UGJXxMlBdWzeurTd8fSNAVZ5ZQOMqMU=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LHoB3T753710;
	Tue, 21 Apr 2026 18:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Q/M2ql55deJBXwgrNvuvQcgHfU/E88
	NoJNIezEXyITc=; b=o8/qWa4tC5O04YnEVrhapsWZRAMvKopusd8ObM2NLb+h05
	73VB0k+5b9xqsRSH0QgI47hAeNNYA9R+M1yeCxqhdqRAAXLf9qn+xmNAQwLEyCtq
	tJ8i9xWbXNPVRM8NQgCsXKkdC+RoGSSwIrtwIvHjPyNMRnbA3qU/8TBKPn6OqgPU
	gtKgFBsa0wb4YOsmaV917/UlMWm37AK4FB96rd8SPpupcLIjqbQlxYUKmrB7zdHI
	ZrlSUyAgyjiXBeFWnfiruBxxy8IXh9lKDv9b/mhy90slZ/LJNKZVd9l1mbv+6TFi
	Oc/u/NdnRAdda1wRHqF1d3s59vEzJ6oDvwQZrHKw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2nf5ra9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:15:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LHZIcp009830;
	Tue, 21 Apr 2026 18:15:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9k1tv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:15:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LIFfuP61669838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 18:15:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E768A20043;
	Tue, 21 Apr 2026 18:15:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A03520040;
	Tue, 21 Apr 2026 18:15:36 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.146])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Apr 2026 18:15:35 +0000 (GMT)
Date: Tue, 21 Apr 2026 23:45:33 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: y36Nuu59mSgnJb-uQq-EDrVFDYuFRljY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE3NyBTYWx0ZWRfX99+kfwP9K8GZ
 YEvRRYzVFnAXxgPhX+oxgfDX5G0Ygs2AjsgDPKwvyaus27lu73g8pJf2RdL1V9BUluclbuYqv0J
 JEqN7/xHp+x9l+aiOZcWKXmRwG+J53C2XgqRuU3OfTNkj7ENaE3AzyVmoHSH/Atqhb/iKFDB3s0
 5aFmYn9C5kxaMYJ1c1YuCnq0IyTEEcoJvWjA5jtyRk+NNAKlxXEzT0nPF73o8YvrX2BEhy8UBKO
 C8HGsJNN79s/a8PmjsicfViblBl7PcBdTmK0OUr6rdpV+RBQdDMTYLdAi/tVx4VBX7iyaZNheWh
 thIUS//th7iID74yWnL1jLykbGhksX0rlqLru0zCqz+VlbwQj69K68WjOOj566HAcESCU7+b+F7
 EUzW9WYHwJWXry6msY+nsyU8Wl/ptEXwTd4/z1ZywOku+aWBFX3KzHDUOGU+45EhJfP1VcGIjfY
 Dr1p4apDJ6P+Y1HmR5A==
X-Proofpoint-GUID: rqpRcvBTBogBp19_f8NgESjUZm6_IUnP
X-Authority-Analysis: v=2.4 cv=B7iJFutM c=1 sm=1 tr=0 ts=69e7bed0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Cl_7ivfH_JflWmaJJIsA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210177
X-Rspamd-Queue-Id: 81FD818000F
X-Rspamd-Server: rspam12
X-Stat-Signature: ae6jashozxgn4xeemf8yoikisu1i3rkq
X-Rspam-User: 
X-HE-Tag: 1776795354-848691
X-HE-Meta: U2FsdGVkX1/zh+TJsnqFhTxD5nyJOY+tyBWjpj0sJ52X/Ux9Y9OjS6v9vSY8nJNtBHNYhCQsaxygl8/X8nU80+0ADpEsesAY8HXv1y4aVHGXOQaSR8HIyj7Hlw0flGwil6RQtQTJ4VRV2YhT/UstUp7JKOCMvw3Vq7fSMyg4/Eys3TUx3NhWpbahZuBVrB9j4bgGAH78clnfbsLuIXZRFEs6Ms6LWk6DwNiEonO2xZeU+bPy8/nRlW1TkVLflAB2bVecJY6KjprhfjPeFCXTfPWNbtBrQ/a3jgH5HS8d62e2IbzNl4u3xo/84hiAF3sDP23kgvfwKSgO8ypaHzzXqP46gVvBvWDNxam5+2nQ2s4cNjMTqp/HKEkce6ctfLR58t1xjsJSCf03AesO+LQ/CUBAx9TiNBE4Ba/KQDhDny6BJPKNsV48WarUzj0T+Mt0N35mCFfeUw5KUF6kGYGMpXor/IspVp+nwByuQ62ckZCzax/zIK1UXf0WoWwh2tFrvT3XS5qTM82lIKYUg8/SVjI+mabZLZKn4Ku3ATNWuY/9M77I1Uk8MSYI5TebLysFWYu/zF8MEC5YTGL3F7uQCxLxs0pTqSaJItdS+zkAqB6CUimwiZtMXv5DPoRSSJTdGcaCta1CWecBTLRiblh6QSNOCQ83Nu/bPSknoLXCEURetRyeiynjyIz+WzQznE/xiW590/aQUpw95q1i3uNbIchhq448aBRK8iUp4gLiPtarB+svaSUeu7djhGYbDSRBPlehaF7tW9r+EoSKkiacrNlrif9sMPs+GMDRIsREnhGBmPZAFpwTcw6dxef/ghHPIdNopn/q/1XK+l1JnbJRbOm3sVOcnz77ownkN5PYO7zQAqBx8ZRkXN3Y5nkCqr5KBmQQEBHIvh9O8Mq/yZf+t4c7USIt8E19QUIY8DX7guxUiKwMnhBWInuTh/KUzhgQr8y6QyJj/lFtW4j9di4
 7v9/LLPc
 BkkyuXNO9/UvB72CsPR2bwwKu2DJH2d5u9qMTvBLAi+Z+7QqtNxXxPO1dSmzTEA7H4i1M/GybL1/Qb2JETioHeXc55/lev+G9pjHGsRXxzJHP4jxgfN1HUAV8IU5UoOgOHuVfJyhMs5ZRvsvg9oAb2W1C4teA8HNWxKYWAMJz9Ls21RwGzWLMb73lkL4Rd8CmsUpeKMKDrTNiBR0VpOG4/TNia1JGm49X1mgneTgWpXA3JZ6ZJ2dr2Cq6iNqzFNWGBiG7uZ5SzXAmsOUZE/h4hzGyEu0utXfdj5efSrH8FYb1EMJushi+ERJxuEgEdXxvfyRc64+dXYzroV5nllX9y/6mJcfsWcx+h08q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
> > +
> > +	if (wt_ops->writethrough_submit)
> > +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
> > +					    len);
> > +
> > +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
> 
> We might want to check if bio_alloc succeeded here.

Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
according to comment over bio_alloc()

 * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
 * allocate a bio.  This is due to the mempool guarantees.  To make this work,
 * callers must never allocate more than 1 bio at a time from the general pool.

And we seem to be following this.

> 
> > +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> > +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> > +	bio->bi_private		= wt_ctx;
> > +
> > +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> > +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> > +				wt_ctx->bvec[i].bv_len,
> > +				wt_ctx->bvec[i].bv_offset);
> > +
> > +	atomic_inc(&wt_ctx->ref);
> > +	submit_bio(bio);
> > +	wt_ctx->nr_bvecs = 0;
> > +}
> > +
> <snip>
> > +
> > +/**
> > + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> > + * @wt_ctx: writethrough context
> > + * @iter: iomap iter holding mapping information
> > + * @i: iov_iter for write
> > + * @wt_ops: the fs callbacks needed for writethrough
> > + *
> > + * This function copies the user buffer to folio similar to usual buffered
> > + * IO path, with the difference that we immediately issue the IO. For this we
> > + * utilize IO submission and completion mechanism that is inspired by dio.
> > + *
> > + * Folio handling note: We might be writing through a partial folio so we need
> > + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> > + * in the folio after the writethrough.
> > + */
> > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > +				   struct iomap_iter *iter, struct iov_iter *i,
> > +				   const struct iomap_writethrough_ops *wt_ops)
> > +
> > +{
> > +	ssize_t total_written = 0;
> > +	int status = 0;
> > +	struct address_space *mapping = iter->inode->i_mapping;
> > +	size_t chunk = mapping_max_folio_size(mapping);
> > +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> > +	unsigned int bs = i_blocksize(iter->inode);
> > +
> > +	/* copied over based on DIO handles these flags */
> > +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> > +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> > +	if (iter->iomap.flags & IOMAP_F_SHARED)
> > +		wt_ctx->flags |= IOMAP_DIO_COW;
> > +
> > +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> > +		return -EINVAL;
> > +
> > +	do {
> > +		struct folio *folio;
> > +		size_t offset;		/* Offset into folio */
> > +		u64 bytes;		/* Bytes to write to folio */
> > +		size_t copied;		/* Bytes copied from user */
> > +		u64 written;		/* Bytes have been written */
> > +		loff_t pos;
> > +		size_t off_aligned, len_aligned;
> > +
> > +		bytes = iov_iter_count(i);
> > +retry:
> > +		offset = iter->pos & (chunk - 1);
> > +		bytes = min(chunk - offset, bytes);
> > +		status = balance_dirty_pages_ratelimited_flags(mapping,
> > +							       bdp_flags);
> > +		if (unlikely(status))
> > +			break;
> > +
> > +		/*
> > +		 * If completions already occurred and reported errors, give up
> > +		 * now and don't bother submitting more bios.
> > +		 */
> > +		if (unlikely(data_race(wt_ctx->error))) {
> 
> In the unlikely scenario where we encounter an error, do we have to also
> clear the writeback flag on all the folios that is part of this
> bvec until now?
> 
> Something like explicitly iterate over wt_ctx->bvec[0] through 
> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
> on them, and then discard the bvecs by setting the nr_bvecs = 0;
> 
> I am wondering if the folios that were processed until now will be in
> PG_WRITEBACK state which can affect reclaim as we never clear the flag.

Hey Pankaj, yes you are right. I think the error handling is a bit buggy
and Sashiko has also pointed some of these. I'll take care of this in
v3, thanks for pointing this out.

Regards,
ojaswin

> 
> > +			wt_ctx->nr_bvecs = 0;
> > +			break;
> > +		}
> > +
> 
> --
> Pankaj

