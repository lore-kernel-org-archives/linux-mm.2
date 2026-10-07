Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD68BCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 14:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4631C6B008C; Wed,  7 Oct 2026 10:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413D06B0092; Wed,  7 Oct 2026 10:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC466B0093; Wed,  7 Oct 2026 10:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 023786B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:04:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97F401A0245
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:04:43 +0000 (UTC)
X-FDA: 85296000846.01.C1ECF58
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CCCF140005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:04:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gl63wSnu;
	spf=pass (imf09.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791381881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1yjiadCaFm4oqkKVvCsI8gTbCtsHibfKKqmZZFHvIc=;
	b=hARv1qYgGObiC7Tjtm6r4WRr/J5a38F4Ni6dFlMfT9fIRqn49gIKlJluwPnAvU2cpN+jWp
	3WGSm12AiLH1o4PAtz36d7A4d2NymBKL9RBF2HzvabEPq1G1/rGbSNnboBVKIyKtDmYvgr
	PP+wbk2yxqjksk7C1cLLBqhti2PObT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791381881;
	b=kuWP8qmklEyDPvXuwBK9AixOIpaZXxQS2rqo9Z+NoBNbepif2OpnUPQ5wxCy+AQc4SGNbk
	TMnbddar60yty7zQxQIVaXdTFuQlvFjqmL6Ha0zLBdIErZvtApalIq2M+Qk+WO39QKOka+
	m3gk+e6mYZJ5A5l4/WSsFXVJsY0Q5jc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gl63wSnu;
	spf=pass (imf09.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZdOI2259599;
	Wed, 7 Oct 2026 14:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=d1yjiadCaFm4oqkKVvCsI8gTbCtsHi
	bfKKqmZZFHvIc=; b=Gl63wSnu+bGPdNYFH2Z3U4JYIJK7yEPZH1t8UO1CSpD0PW
	WMBP2lEHmtK8TTVB70vJxD8WJBhMIh9sMClXCkONI5nllWH077i4SDIjPRcmkd99
	OHGkn1+8X/e/YxXaX41TC6oYLQP5eqRjAfW73rk0sk0ujagGv4NEwzoZbXmJVjbU
	LtpjJNSwi0lzrw2aZxQVOxopjCH7emmyDiw5AYqJWbR3YsbcrHzs5Y4JdGinjdBf
	POXcDUe7vReTMWsbOIImSIH8ac50UeENN9JOHAYBOOam3gWF6ArN132+xW0oIoTm
	HGhq4emzu0lONOanb3vGDElqIxhHw+AwtV943VKw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2q4jw8q2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 14:04:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWcxq1810428;
	Wed, 7 Oct 2026 14:04:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h58ek331h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 14:04:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697E4LUv45220104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 14:04:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F67020040;
	Wed,  7 Oct 2026 14:04:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBB622004B;
	Wed,  7 Oct 2026 14:04:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.188])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  7 Oct 2026 14:04:14 +0000 (GMT)
Date: Wed, 7 Oct 2026 19:34:29 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>,
        Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <asZQk_YX-9ofMPbO@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
 <asYOJs4PYv326KNe@quentin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asYOJs4PYv326KNe@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 8UP0k0ykbTQxtf3RKvIFyv2pTeDeoQU8
X-Proofpoint-GUID: A8Ph-_bRfhXlDSeNkkhQTSY5XglcXUlc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA1NCBTYWx0ZWRfXy+nDHHDmMxHz
 hhWN6A0kiHma/nDiI9hKj/oE5Gc9+WJdbVLtdApQB89DUGL49/yHM6mXeQt2ptmUQGx5nVBSwRW
 jY5WKa6k6rvDFfLwvqP41UiHDdWlHww=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA1NCBTYWx0ZWRfX+yHevGnshdQ6
 uRPqrF4XBFze+913qrw48G5EbQChaFN2z467BVuojreGUEflTis6zlpksKZ+4NudsVrpaupN5Bc
 JmQKmEZmeBPecNMJl8t8jBHvsy5tdgCezh2+5sn4URxFlQ8Z1Is92LYX1LO4+wojqLfMeSB7Rth
 e7pK/nB/7/L0JByHj9GzpMFGLhzjaztmTUpcCsIC3amXkb3SGsQvpkiVPQI3L1rEcLLfXq8w/Xr
 UOdo+ERGSGyKqEfceafixfQEi0Ztp702revOileXXStlXpEahBvBf5IBpdb4+rCNq2L/6HP/abJ
 xeLanVnstrG2FcKDnpewZ4OlwxCEM5I+crydR6Ly6bPZ6ndKGr0xuO/dz93Ayv3Lipq26Ym+eFA
 YVDA9PDAp+ZrpJl+/iOc5v6CMWfQQGQuQQU9RzU34PLoCFwqT1t4b3ddqGsurR+tCR1PxohoSTG
 FWhCIyMSlpyA/3+6GhQ==
X-Authority-Analysis: v=2.4 cv=eYeo7LEH c=1 sm=1 tr=0 ts=6ac65168 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8
 a=Cl_7ivfH_JflWmaJJIsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070054
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CCCF140005
X-Stat-Signature: z4rxucew6sndrhjnm7n74uoihqj5rkb1
X-HE-Tag: 1791381880-252411
X-HE-Meta: U2FsdGVkX19+BBDGK2pZExgsi72Qn/C9vhRa+Kv5aAtr5BIeXNhPESsvYHb5aehEKeCvVxwqJ/z6Qi0RFeLw97ZIM3YafvuqikHT/0BvNCzG9yyPUbYLD1TMwoig+27fAQ7Wi/jYJhust9P7CW+3lEfnFNTpiBe+NuPe9NnB5OIszo2Pr7pTfnf5dKyUklK3pIrkEqmvtNHcUF3I52FXzaJJqTX22J6uK/QmIfvKzdFSQVGxnxwBx6fTzYh5ofxHto3uc+yL3e3iHS452idZ0LvWS8WvrxvoxVN3HxxEi9trPDVF4m4QZp1t4Ssp3uhzS2lqfl97ZuafKrmffVKKhoyeX4vE8zx1B5rQJNH4lsIJOGPngyeMXKapOZ3X1JlHWd4ZhMbg8ogafARCpfxvZKRGazvTiBr34kDQg80HYHaSVUCAJzUeelvinu7LVojfVlE7V3Y6eWJe1i1QKle32j0nY2yvh+7AdLxmWqBtDl0BEtrkITFrcYBeqSslaB6FiAbQKAcJEBtxFjkb5Pe86Dl6KVnHEqkwEATQI4G7Byg6p6ZWRqBgc4yj/d8YSyG//HP3buIF9lYose54/EmDqa+IGPokIWNPtDtIWTCp5yIzIJGEMo2psXD+URHHaNGos6ORdNLu6NybHEnnP18Uq5lV0hgHommtorz8D1Rjnq1Euvs5wfvmmQ1MJ+/QcrjmtCEJcaIqxiyZyjrhMNtCYusVCBbsFArltSIr3piq70jLjW5zGq4Up6a9wmU88KSRLe17oC/E0nsNHV9GGpsCduU7+E+75uH28TEi+qfEUT1z7Ri9N2ECs4J4z2GvLaEUTOsesUeQqFpb5PkUt+4BGCbuenGbK1n9tZT0kn3x+XJ+ZtE57gDGooazoaN22owhY7XW9N0ruOWGO9vLbfpO9bBsljtOKwU8eomTNUWAeNTGFJ8YuhiYtK4Ezc4T8ZCSQx7LnhkMrn1LdDwcO6/
 KpZ8UeVQ
 L3St7S0x6H3JuInIAYWN5Xg8Eqyu3cVuuaxCcX0gIq27Tf9L8u7dAEYz6VTCyDPOwYY7DNnTt1IuX1Dhk2CZYoYPy/z87KR1pRAN3ajnC+mSJleOiZ4Kb1VE9FemXhzg1YlPiGR2LvdaURW3hV+e0EOfFXvTtTt1FwVvfRhhC5CJlWXoqis2YmOXo11eHCIzsp/vpZUmClQqPAnt6gqS1m4+tMf8gTk+Gs2KD5SNcDcIW/emPepYuZsKaOqdAF0LdvRgkTOaRZXuh1P5SM3qwrYKxA4d1g9IU+jXbwvYUEsvv+FPKX5uoS0hNWsJuT+rfhOl/778JsRfHSx15g8jML/z4RfeybcQGtDxB1VWjs17SrDvW9uvOlJfGrwhFVltV84dM+vZVtcqsMFbgy8so0AHQLlcc99t0OKhdlAuZn/rveEo9Om37hoQm5EkKUnxmhCjfIogaedNYUePOmnRFBy9PAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 11:32:36AM +0200, Pankaj Raghav (Samsung) wrote:
> One general comment, all your commit headers are starting with
> uppercase.
> 
> iomap: Add initial support for buffered RWF_WRITETHROUGH
> 
> s/Add/add

Hi Pankaj, thanks for the review. Sure I'll take care of this.
> 
> Overall this looks good to me. I will run some tests via fio. Do you
> have a branch with WRITETHROUGH by any chance?

yes, I've this branch: 
https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2

The patches are a bit rough but it has writethrough support for fsx and
fsstress so we can stress the feature.

> 
> On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > +				   struct iomap_iter *iter, struct iov_iter *i,
> > +				   const struct iomap_writethrough_ops *wt_ops)
> > +
> > +{
> > +	ssize_t total_written = 0, pending = 0;
> > +	loff_t submit_start_pos;
> > +	int status = 0;
> > +	struct address_space *mapping = iter->inode->i_mapping;
> > +	size_t chunk = mapping_max_folio_size(mapping);
> > +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> > +	unsigned int bs = i_blocksize(iter->inode);
> > +
> > +	/* copied over based on how DIO handles these flags */
> > +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> > +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> > +	if (iter->iomap.flags & IOMAP_F_SHARED)
> > +		wt_ctx->flags |= IOMAP_DIO_COW;
> > +
> > +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * IOMAP_INLINE mappings have NULL bdev and would cause
> > +	 * iomap_sector() to dereference invalid memory. Reject them.
> > +	 */
> 
> Nit:
> I noticed that gfs2 sets the bdev even for IOMAP_INLINE. A better
> filesystem agnostic comment might be something like this?
> 
> /*
>  * Inline data lives in the inode's metadata buffer, so it cannot be
>  * written via a bio built from the folio.
>  */

Yes that sounds better, thanks.
> 
> > +	if (iter->iomap.type == IOMAP_INLINE)
> > +		return -EINVAL;
> > +
> > +	do {
> > +		 * blocks in the bvec again.
> > +		 */
> > +		if (wt_ctx->nr_bvecs && prev_pos + prev_len > pos_aligned) {
> > +			size_t delta = prev_pos + prev_len - pos_aligned;
> > +
> > +			/* Everything already added to bvec, nothing to do */
> > +			if (delta >= len_aligned)
> > +				goto put_folio;
> > +
> > +			pos_aligned += delta;
> > +			off_aligned += delta;
> > +			len_aligned -= delta;
> > +		}
> > +
> > +		prev_pos = off_aligned;
> 
> I think this is a mistake?
> prev_pos = pos_aligned; ?

oh right, I guess I didn't hit this in my testing. Thanks, I'll fix it.
> 
> > +		prev_len = len_aligned;
> > +
> > +		iomap_folio_prepare_writethrough(folio, off_aligned,
> > +						 len_aligned);
> > +
> > +		if (!wt_ctx->nr_bvecs) {
> > +			wt_ctx->bio_pos = round_down(pos, bs);
> 
> We could reuse pos_aligned variable here instead of recalculating?

Yes, I will fix it.
> 
> > +			submit_start_pos = pos;
> > +ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
> > +				      const struct iomap_writethrough_ops *wt_ops,
> > +				      void *private)
> > +{
> > +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> > +	struct iomap_iter iter = {
> > +		.inode		= inode,
> > +		.pos		= iocb->ki_pos,
> > +		.len		= iov_iter_count(i),
> > +		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
> > +		.private	= private,
> > +	};
> > +	struct iomap_writethrough_ctx *wt_ctx;
> > +	unsigned int max_bvecs;
> > +	ssize_t ret;
> > +	struct blk_plug plug;
> > +	size_t min_folio_bytes = PAGE_SIZE
> > +				 << mapping_min_folio_order(inode->i_mapping);
> 
> min_folio_nr_bytes could be used here.

Noted.

> > +
> > +	/*
> > +	 * For now we don't support any other flag with WRITETHROUGH
> > +	 */
> > +	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> > +		return -EINVAL;
> > +	if (iocb->ki_flags & (IOCB_DONTCACHE))
> > +		return -EINVAL;
> > +	if (iocb_is_dsync(iocb))
> > +		/* D_SYNC support not implemented yet */
> > +		return -EOPNOTSUPP;
> > +	if (!is_sync_kiocb(iocb))
> > +		/* aio support not implemented yet */
> > +		return -EOPNOTSUPP;
> > +
> 
> -- 
> Pankaj

