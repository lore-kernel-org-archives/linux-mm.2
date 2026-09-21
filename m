Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FBCFC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8566B00CB; Mon, 21 Sep 2026 05:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98FB76B00DF; Mon, 21 Sep 2026 05:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A57A6B00E1; Mon, 21 Sep 2026 05:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 623F36B00CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:13:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 509CC1A0605
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:38 +0000 (UTC)
X-FDA: 85237206516.09.2A9AD1D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4ADBC0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pKci3Ps+;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHpbWh7ilinEK48bRJAdvGAA+5jlm2rCmcP1EDTkoz4=;
	b=EunkkqwUz/WQZcsnY98qf+4T/FjjofjvgN10L8tXsGzS10VDzp5Vd7RxNL2VCZIFc3EgWv
	YqXZPciKgW3yuqHZ0/8t8mjk92ByRlizx1Fy/39SBryG0AlWl3x4kynq/t0IuSZa/vfbZL
	NitvOK0kfi4V1QBVumXXR9LzTRpkPKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982016;
	b=f/AMhPRkHI9MyN5nOP4mpwKWv+QgSuLP69cNTVSCzo2lmmIdcOhOF8DK8M4duU2k48F0Lz
	qwRvjMMWAhCcdIbmfEvdCZiO+vN6Z6nnjFBp9x/eNls/MFgDSykbIQauUdHYPSQyuvf248
	OZ+kubdsvmvvBJMlO4XEheG2PQZ4PqA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pKci3Ps+;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7ZNxo3153438;
	Mon, 21 Sep 2026 09:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uHpbWh7ilinEK48bRJAdvGAA+5jlm2
	rCmcP1EDTkoz4=; b=pKci3Ps+2aw2U5R77z+tRH0KMIIy39lGtvbMJ+gdtBZiRt
	XhEm/AXhPSH3hctgwMPABnss/uqbHzSH593IUdAD2t4pjQOnxsX5vLIHSfY6x3gK
	znL6s/QaX1WtfUM9j8rvnstSomglvHqgCbCYfTYltH9Ei7MsX2LNjWUsWorCgcvG
	0qtD8l5oi0UC/su4IJAu8iEBMNpU8dabcnrH+D/UC2/tzBZG59Zm6dfX39wwwYxI
	xxYWL++xeB/NilAV0eP7Yz2yschmDwBYfX9Pg1RX6zOYr1W2Q4fsSGanZGMRAXN9
	vMByWddAzO5hDzSubz3hmo6wvj+JNaTeTyvqHUsg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1fpws-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:13:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7HmQp931526;
	Mon, 21 Sep 2026 09:13:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt6xgcdym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:13:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L9D51F8454422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 09:13:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BBD820040;
	Mon, 21 Sep 2026 09:13:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D72420043;
	Mon, 21 Sep 2026 09:13:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.16.92])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Sep 2026 09:12:59 +0000 (GMT)
Date: Mon, 21 Sep 2026 14:42:57 +0530
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
Subject: Re: [RFC PATCH v3 05/11] xfs: Add RWF_WRITETHROUGH support to xfs
Message-ID: <arD1GWfg3fH0FhIo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <c284da9ae8f72cea47dfee7bd9f28a270c31a08d.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c284da9ae8f72cea47dfee7bd9f28a270c31a08d.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: XS3xRSuQdjeYIFIUQHGQYYN3KuZLWfc9
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6ab0f524 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=N6Loc1iCyasMdZpCZgQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfXxS1QcLmEMZV9
 lUHzF7Eylxtv46P8/KT/+lnTMiSyCfBmiSe3eGpQXWqW29y339SCozQI+9rtWFkA4d4Ga14yWqK
 s8+YtrcWgpJjK7C6HaCzIgoptX1UIG4=
X-Proofpoint-GUID: QmoOPoBIiT2Xgnop7Sjxbxi1qTn-39yW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfX5sy/h8HRajq7
 mbYA4O3K+QkXU0RJy2e+pDazA3NMDYrsw4X7Q5YXBmtZyiWb/UeSUAqhEJxv/sajcaDkVjdXdaR
 1CI3rJbFV0vbDFWGh+HpTFV5QysOKuL/sbyBbzNyNOEuq1WkqAeT9jdzq2iA9uJDhcIC0X97WBr
 nykKjjmsm2V2cWifiiDUh3SK9Rxr0c6sccv3E8oIsKEoFE+Dbhsn3NDMOpDgMXM7/k5EKVfqL3d
 RBa6UJioZFcANPSPwCF2mDdNZhg4PddrB67QOEo1Qp99gyXjSGybwPC3od4WrPi3V8PUr03QsD4
 R/EdKy/drQJlJxm/lIzYycrtw2KyE872zcoAtevQhD6D7B/ecJlaeaeDP7fAgOSeZewbEXsGcGM
 e2u7woLMJsTQxoIG/gpy5a5xxi5TTCAafqw/JyLhnr/HUUSMieOGTnNn8rIerEyWhlAD/T8C0uH
 gTI5+VhPxdMEYf9TM+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210130
X-Stat-Signature: bun58r95uncntrt45rqnkknth9698zmi
X-Rspam-User: 
X-Rspamd-Queue-Id: E4ADBC0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789982015-166578
X-HE-Meta: U2FsdGVkX19lSqcRFjRQKZ9x72lJpStXlsSOyvX7J9U+1JXJC2m117QwkS1pAywqwdMDLxePcqmcE5JOneek/7SAnfFYPExfsA4IxyTTQyCrUgewqfWn1QNqqZt3rFOcbUOzdQ87g8r7442JgVCV3Utaf58005oUOLAmslMLNbrrgVnpgs+fEwKulhXiwaDZ6cRLRPmT+BLkAHbpEyQvoU/7GwpAYTOTjzpYHtu6hVkDVy9kLK39EX8yAegto25h96vHnKdRCpknx4kQJf5TtkPxj0/QmDPJkrqj9yCJM8GFlMpzIMS+GyqItqZX3XJjM4au3MWr/oHeYGw0rv2XNe+xwX8W8+WbBIG/SH7H0nqIgTIdDFNCwQB7URZFumJTFyddkygRHr2iD/Vp4KdR7uS9bC+rz/a5D/4Tuqy6QUEMoPFA0kUAtvhA7VZ4WckgC/cEMtYxOYxp/3MX/4XK5QeC1kKlukG97yKYfgJ3C4lhxdKAUzAFHb8OpzDxzi84CheUl3fBjjzB1DfQ9pm1jpO4iprvH31f+jGUNxnhaO95TwJVtd0GRjSlwhDZ7AAO1OnAGX6/sHOYnYYUOjX0sXV2Y1uYLFrl80waZLd1ElN1H8BAWmu6FBvsyeJtcQzEP67pBngLxLSuNMEbCGaAKnfd7HFvq6eiVhERcDbMPrT9rU/pnxOrUq54yN2Kr7J5o1RbPuBKS1Np4ykCpwVT/wHQXOBk/eQ+KkAc0t8VeiuPgBdPwDAJtTGGCUYOM54yHyiJNYzq5ZcXesFPN/mbv+xh4nOCz03pgI2pnrN3IGmxVdlEfwji8KOBEFi/9bn3iKsWEzZIWPMEBPys5hmqPQzrCce5crC5ceiy5teX2JgVvFToFKIFCYuOpCBz5s72EIdsDUcfKPDN5YQ7X6P9T6t0oYX9JilDXQf+fK98txJzZ+ZjfXioC0bnz9uzApQMD4Q22fPWCUY59J521+n
 nA8O1c0z
 c3NmyqI1s8k63rD5ZlSwboypnffqiWrkWEonRX1rAGQNTPxkZHYoMkIhyQ6LG12BqtSJL+IMC3PUjObxgEHxCv4N5dihP+mdtvJrMVFoB71mHkSBx9Pk1TWuES0VORj+KhE7z8qPRYV3Rw1BVpfIC6B6FEj2z36O4/sigDXyhdQRSRIr264QZ9CFDKwLVh5n7tNmGlL6pkEWpi8N+na6oI4WJU4Wz4qddQeqqXW7SFlGtiC+7QhzRLxo5eZQtISehPy+f8ephOSR07Qgr0DH6Vcet6Es0nqYs3cHflUCanyqFOL/DRA9zUVnQ1tjeeH8OcdyDULbRo5Vq7g/wLq1QKYb3pTUwu2yVCtMjTKB3TUa/vUbLKguoFALSb3NilQc/pMovb/YZigjW4Cy64TCY14JM30s+H6lsYtYvnpWsiyaHDFXiUf2chXVp8iZgXHmxC/EuJwACYSldzX/6Mjb4BybrjvN3k16AZAFJrGhoC8Vw/m4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:58:11AM +0530, Ojaswin Mujoo wrote:
> Add the boilerplate needed to start supporting RWF_WRITETHROUGH in XFS.
> We use the direct write ->iomap_begin() functions to ensure the range
> under write through always has a real non-delalloc extent. We reuse the xfs
> dio's end IO function to perform extent conversion and i_size handling
> for us.
> 
> *Note on COW extent over DATA hole case*
> 
> In case of an unmapped COW extent over a DATA hole
> (due to COW preallocations), leave the extent unmapped until we are just
> about to send IO. At that time, use the ->writethrough_submit() call
> back to convert the COW extent to written.
> 
> We initially tried converting during iomap begin() time (like dio does)
> but that results in a stale data exposure as follows:
> 
> 1. iomap begin() - converts COW extent over DATA hole to written and
> marks IOMAP_F_NEW to handle zeroing.
> 2. During iomap_write_begin() -> realise extent is stale and return back
> without zeroing.
> 3. iomap begin() - Again sees the same COW extent but it's written
> this time so we don't mark IOMAP_F_NEW
> 4. Since IOMAP_F_NEW is unmarked, we never zeroout and hence expose
> stale data.
> 
> To avoid the above, take the buffered IO approach of converting the
> extent just before IO, when we are sure to have zeroed out the folio.
> 
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/xfs/xfs_file.c | 83 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 77 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 768cabf6250b..4b45ceacd461 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -702,6 +702,36 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
>  	.end_io		= xfs_dio_write_end_io,
>  };
>  
> +static int
> +xfs_writethrough_end_io(
> +	struct iomap_writethrough_ctx	*wt_ctx,
> +	ssize_t				size,
> +	int				error,
> +	unsigned int			flags)
> +{
> +	struct xfs_inode *ip = XFS_I(wt_ctx->inode);
> +	xfs_off_t offset = wt_ctx->iocb->ki_pos;
> +
> +	if (unlikely(error)) {
> +		if (wt_ctx->flags & IOMAP_DIO_COW)
> +			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> +
> +		return error;
> +	}
> +
> +	/*
> +	 * writethrough completions are handled same as dio with the exception
> +	 * that we need to explicitly change the i_disk_size. This is because
> +	 * unlike dio, we have already updated the i_size and hence the
> +	 * (i_disk_size < i_size) check will fail in dio code
> +	 */
> +	xfs_dio_write_end_io(wt_ctx->iocb, size, error, flags);
> +	if (offset + size > ip->i_disk_size)

Okay so mostly the Sashiko reviews are straight forward but I would like
to discuss one of it here:

  Is it safe to read ip->i_disk_size locklessly here?

  On 32-bit systems, a lockless read of a 64-bit value can result in a torn
  read. If another thread is concurrently updating i_disk_size via
  xfs_setfilesize(), a torn read might yield a spuriously large value.

  Could this cause the offset + size > ip->i_disk_size condition to evaluate
  to false, skipping the on-disk size update entirely?

Although this seems like a valid concern and we can end up tearing
i_disk_size read on 32 bit machines which can lead to a skipped disksize
update, I see that same sort of unsafe checks for i_disk_size is also
present in the endio code (xfs_ioend_is_append() call)

Shouldnt we ideally be fixing those sites as well or is there something
I'm missing in xfs that makes this acceptable?

Regards,
ojaswin

> +		return xfs_setfilesize(ip, offset, size);
> +
> +	return 0;
> +}
> +
>  static void
>  xfs_dio_zoned_submit_io(
>  	const struct iomap_iter	*iter,
> @@ -1033,6 +1063,39 @@ xfs_file_dax_write(
>  	return ret;
>  }
>  
> +static int
> +xfs_writethrough_submit(
> +	struct inode		*inode,
> +	struct iomap		*iomap,
> +	loff_t			offset,
> +	u64			count)
> +{
> +	int error = 0;
> +	unsigned int		nofs_flag;
> +
> +	/*
> +	 * Convert CoW extents to regular.
> +	 *
> +	 * We are under writethrough context with folio lock possibly held. To
> +	 * avoid memory allocation deadlocks, set the task-wide nofs context.
> +	 */
> +	if (iomap->flags & IOMAP_F_SHARED) {
> +		nofs_flag = memalloc_nofs_save();
> +		error = xfs_reflink_convert_cow(XFS_I(inode), offset, count);
> +		memalloc_nofs_restore(nofs_flag);
> +	}
> +
> +	return error;
> +}
> +
> +const struct iomap_writethrough_ops xfs_writethrough_ops = {
> +	.ops			= &xfs_direct_write_iomap_ops,
> +	.write_ops		= &xfs_iomap_write_ops,
> +	.end_io		= xfs_writethrough_end_io,
> +	.writethrough_submit	= &xfs_writethrough_submit
> +};
> +
> +
>  STATIC ssize_t
>  xfs_file_buffered_write(
>  	struct kiocb		*iocb,
> @@ -1055,9 +1118,13 @@ xfs_file_buffered_write(
>  		goto out;
>  
>  	trace_xfs_file_buffered_write(iocb, from);
> -	ret = iomap_file_buffered_write(iocb, from,
> -			&xfs_buffered_write_iomap_ops, &xfs_iomap_write_ops,
> -			NULL);
> +	if (iocb->ki_flags & IOCB_WRITETHROUGH) {
> +		ret = iomap_file_writethrough_write(iocb, from,
> +						    &xfs_writethrough_ops, NULL);
> +	} else
> +		ret = iomap_file_buffered_write(iocb, from,
> +						&xfs_buffered_write_iomap_ops,
> +						&xfs_iomap_write_ops, NULL);
>  
>  	/*
>  	 * If we hit a space limit, try to free up some lingering preallocated
> @@ -1092,8 +1159,12 @@ xfs_file_buffered_write(
>  
>  	if (ret > 0) {
>  		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
> -		/* Handle various SYNC-type writes */
> -		ret = generic_write_sync(iocb, ret);
> +		/*
> +		 * Handle various SYNC-type writes.
> +		 * For writethrough, we handle sync during completion.
> +		 */
> +		if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +			ret = generic_write_sync(iocb, ret);
>  	}
>  	return ret;
>  }
> @@ -2104,7 +2175,7 @@ const struct file_operations xfs_file_operations = {
>  	.remap_file_range = xfs_file_remap_range,
>  	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
>  			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
> -			  FOP_DONTCACHE,
> +			  FOP_DONTCACHE | FOP_WRITETHROUGH,
>  	.setlease	= generic_setlease,
>  };
>  
> -- 
> 2.55.0
> 
> 

