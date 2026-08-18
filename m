Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D9BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8346B077C; Tue, 18 Aug 2026 12:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79686B077D; Tue, 18 Aug 2026 12:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940376B077F; Tue, 18 Aug 2026 12:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661516B077C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:04:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E00EA4012B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:04:36 +0000 (UTC)
X-FDA: 85114862952.04.9A42D77
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73BC3A0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:04:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PA2y/Q3s";
	spf=pass (imf25.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GcnCyLG75obtAvBlP35RBRJpiMoGm0EyyPyoIzan5Y=;
	b=aFM1s20q5o/P9UpfUAEIuHV+h7ljNiPtYwHKzpw2wHR+hQwfbJSdANuL+SELU1Dajmfejv
	zedIMPv83KRgAdrHN5coH74RRBzyQegOErRAnxlNjKhzziPcHTUemWN5xUJidydqZiJTae
	sQvcLeQtehUeigvv0s8H+Y9I/ou3A7U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PA2y/Q3s";
	spf=pass (imf25.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069074;
	b=fjughwvoVCdPffguHEka96XGmjtsKsLbGGggdUNyl/U3NG8xhZhVNgob9fGXDTBEQQ8Ldu
	zHOH5Cn1Ca74IG5/Ftp8qkjiVcD0QnQpqNRmWuQH6e+6dGrkaz8CTw6tU0m0My9wWlTdgK
	put+YB2EfdvRTsXWZwbqGE8KheYw2rI=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IE45uH402315;
	Tue, 18 Aug 2026 16:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7GcnCyLG75obtAvBlP35RBRJpiMoGm
	0EyyPyoIzan5Y=; b=PA2y/Q3sQp6wybUCOnKYvCzHmaRKeveJB/slnjSsF0sKj9
	Rs4xSd9UbkXZFmdKGUY2aIV+nWRXQZPo9lNh+mElrXBgJbFqe+Etf7cMuGONZ0P6
	rp6aEUi11NUl7LqMF9IHktsSaumpmteLY+CXMnpN2+DyaT8QojhnHCK5N/LfBUeL
	jfDGE2UCyhNIaDckmoY4hG/WzwNX3VmnbY43tqXK4KY3MlqVWnZe4gnNwbfcAzjA
	0ZNVdMIYRkfJzjeHJo93NKIsp7hiL8ZR5cDTGxrCK2g15xVXgm7FwxK/BNYNJJJB
	OXJVrYrzYC+Np80ll1zDyuLq9lBWzGf5+8q/kYDA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2dhm14q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 16:04:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IFuMTF027544;
	Tue, 18 Aug 2026 16:04:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ngbvbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 16:04:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IG4Dgo51970544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 16:04:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A82822004B;
	Tue, 18 Aug 2026 16:04:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D08E20040;
	Tue, 18 Aug 2026 16:04:09 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.16.140])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Aug 2026 16:04:08 +0000 (GMT)
Date: Tue, 18 Aug 2026 21:34:06 +0530
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
        linux-mm@kvack.org, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v3 04/11] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aoSCdnKqCjy8zRTJ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>
 <aoMCtTAZFN_DlZjw@quentin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMCtTAZFN_DlZjw@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDExOCBTYWx0ZWRfXxzB03zp0uDAf
 t50aGjTES+mPTXNMTEJRlw06Xou7kuHQWFGitRTd7zlGNRtCCW6aIqieK7NWog1ni6KI+c4q/je
 6vT49k16FLwlCLWdlSdXZiOidH0Nm/UdLMXWg7B1LtgTvnVhwxC2hXR7isAhVzJVQcQgZG51Roy
 MYSQh6aur0WClwyneZ2uwKJ4YOLkcKU0WMCpr3AzOANEFxiCwN61GRYq7zuUfHARyNHfCHv6iOY
 1YQjsHs+XNwJF9YLq+A7SGaZqRUyEltx4bBaq5LOYeQKSeLVFVCAnCWSxFcWfKJJtANCsEuYvED
 WQnTpW5TAiQbtdLJmaF0kgQ2U4oXxlc8VquAio8LxiPVEClaDutPii3besnT/cwADz75zZU21f6
 HqLXUqgkNc+X8lZ+hLLn8q+6f+7whAZ/4q2bWB+JphzddWYTl+qpv1eQEjXaJXyHT0iJrGyOw/A
 2VWeZO3BTUEn90HpPZw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDExOCBTYWx0ZWRfX/MZOWtvovkxW
 irxu9Hgg9ngIkjIz0xiUusImXZGejp3TBYawO4LhMRjvncv1iRq4h88Vkj92Sj02bwWln9odO8b
 06193M1HKqLTHtzFMYBxaC4IXIWUyo8=
X-Authority-Analysis: v=2.4 cv=JKkLdcKb c=1 sm=1 tr=0 ts=6a848281 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Qb9LMyuyepaNm-1pOgYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: N8cU29wC1u0R3-keFNEBzWoBycdbnVy3
X-Proofpoint-GUID: 3wcR2FtiJ0kKoahbrKqDONLrLhz0SU4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180118
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73BC3A0008
X-Stat-Signature: 1iaxjffnis44r8oq7qeu53m3uqttzyrj
X-Rspam-User: 
X-HE-Tag: 1787069074-978475
X-HE-Meta: U2FsdGVkX18CzZCIVGodPUen1dxNmFvjeIXoEfgIY3MNIBpbE4vYri17G39/BqlXY20aNg8wdZLcRLtRvgk1+d2imzgg7NlEoWo04AQpdcKVKNatH18CaSTKnTzX+ICDgmfZ/MlyXoqiQErhvhi0bJ8qVBSGpIDHyfonkROFoF2hBNXJOUITbsRzUudXQCqJCgKkyEgquFcXQ0lEIvVlahG7vP6mW0WziIWpud3NCbb+6PZ2j0KaipYYkGnOwrvytIKFVMgX/2gdCmutcPW3zUH4TQTImxJ06psaoTdSvZNo/uGaoXRazOyijCnP7DNq3gfI59FIakCS4CkdHHjkffpsE4J+59NLBnHsws0mi0vFoDuNY/dQTQA7wIaAKgw8JFRqYQM23Miac+V9++Xu2oGwowa65RKM6x9hqfBQyw70nF46WoANJ7OjZAbdliFPiwyleYw8OZqadGFoAXE+K9UqeYSnq70iVbpolm/3o348DRjPnZC/7tIKPhJXRG9TnYzwREP6PerwFdcro8jacCAQUornWvtR6nh/h6cnv37PbIhBgp5FmFeZYM8Gw9WsU27aUzAilMkQrfac4bX/gRCFGfjyii7fwtL9LJt8LcrnopW3Q8ayN8mxTsP7PL8BgDc2ZgcdV5/S76naYPCEdTi6H8SRe4+rfnfb2iZU6w/Wt5J7RQw3naxillvdBLbH5ubKGIsCYQcXtyJ6yIISPIVEaGNo69hlFsarUnYGS3EUdj/h0qTNF5ObkVWsyEdLVpamBzTFFRksAoETDQ7LurqcVhIHgYipQ1XAd7Nghujg70eGQsZ5IEQy9QXfsYzynU0EueDgSNeuDbX8QqW76i7mqQkE49g7m148kOInKEtbLLRIAGNLvij8D23bxhjGHoTwzb+o5v8MN8tUwh+rqP6s4x6ANWt+JZ4zo2A0vJmpDQpmqW4Rgx56QMKB+cMgMWR6dkD8mzXEudJxjZG
 zQf0bz+2
 obTTzbbLbD95sltZy5N+5U9aSCUDzGrOYdl3+uPxiwi4sdT4Pzd7E/WLZt69g1nY8dOfr7WdiO0lzcLhU7ubZMQu1Xa3OhJk8y4R62oQgVxmGQ3BWO7+zt61MWOXSZWd+TqNnc5y3QMJXbD012TgaZSnXMEF0UO2pkwap7JN6N/+4u6seUp7Zj+A2R1L/XBSeKDNQwY7+QNMjZWxZDIpmgp+dsY5o1knt6vkRMjixdxiVC/6cQTPOM0PtOtFOm8h1rc66GAugUe+/fzFTThHKDkuVeaLeBT5uMAzr+ms5D3lFalWhsEigrv4YpmKizImsVdBeEpbmeIoBw+P+v8SKkDqRfdtglRGAQwx2TvITeF4FAasDUZdrfedEXPLCgl8nK7UR7jDNKHx+90w2AIJPo1JKXOeeOh93e3gE1L9wfH7sfHCQp4ckAx/agmKzZQe176I4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:20:12PM +0200, Pankaj Raghav (Samsung) wrote:
> I have added some minor comments. I haven't checked Sashiko's review, so
> ignore them if it is a repeat.

Hi Pankaj,

Thanks for the review!
> 
> > +
> > +	if (!wt_ctx->nr_bvecs)
> > +		goto exit;
> > +
> > +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> > +		len += wt_ctx->bvec[i].bv_len;
> > +
> > +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
> > +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> > +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> > +	bio->bi_private		= wt_ctx;
> > +
> > +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> > +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> > +				wt_ctx->bvec[i].bv_len,
> > +				wt_ctx->bvec[i].bv_offset);
> 
> bio_add_folio_nofail()?

Hmm actually your suggestion is right but it also got me thinking about
if we are actually ensuring that bio_add_folio_nofail() will never face
any issues.

We make sure that we don't let the bvecs grow more than BIO_MAX_VECS ie
we can at max have 256 pages in the bio, however on higher page size
systems will a larger large page size, i think we can actually cross the
BIO_MAX_SIZE limit causing the bi_size to wrap around.

I think in addition to adding the helper, we should also add a check to
make sure we are not crossing that limit. I'll look into this a bit
more.
> 
> > +
> > +	if (!error && wt_ops->writethrough_submit)
> > +		error = wt_ops->writethrough_submit(wt_ctx->inode, iomap,
> > +						    wt_ctx->bio_pos, len);
> > +
> > +
> > +	atomic_inc(&wt_ctx->ref);
> > +
> > +	/*
> > +	 * In case of error we still need the I/O completion to run so we can
> > +	 * release references and end writeback on the folios.
> > +	 */
> > +	if (error) {
> > +		bio->bi_status = errno_to_blk_status(error);
> > +		bio_endio(bio);
> > +		return error;
> > +	}
> > +
> > +	submit_bio(bio);
> > +	wt_ctx->nr_bvecs = 0;
> > +
> > +exit:
> > +	return 0;
> <snip>
> > +
> > +		if (!wt_ctx->nr_bvecs) {
> > +			wt_ctx->bio_pos = round_down(pos, bs);
> > +			submit_start_pos = pos;
> > +		}
> > +
> > +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> > +			       len_aligned, off_aligned);
> > +		wt_ctx->nr_bvecs++;
> > +
> > +put_folio:
> > +		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
> > +
> > +		if (old_size < pos)
> > +			pagecache_isize_extended(iter->inode, old_size, pos);
> 
> Some new code has been added upstream to include VERITY. Probably the
> same thing needs to be done here?
> 
> if (pos + written > old_size &&
>      !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
>          i_size_write(iter->inode, pos + written);
>          iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
>  }
>  __iomap_put_folio(iter, write_ops, written, folio);
>  
>  if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
>          pagecache_isize_extended(iter->inode, old_size, pos);
> 

Oh right, I'll take care of it, thanks for pointing it out.

> > +
> > +		cond_resched();
> > +		if (unlikely(written == 0)) {
> > +			iomap_write_failed(iter->inode, pos, bytes);
> > +			iov_iter_revert(i, copied);
> > +
> > +			if (chunk > PAGE_SIZE)
> > +				chunk /= 2;
> > +			if (copied) {
> > +				bytes = copied;
> > +				goto retry;
> > +			}
> > +		} else {
> > +			total_written += written;
> > +			pending += written;
> > +			iomap_iter_advance(iter, written);
> > +		}
> > +
> > +		/*
> > +		 * If we fail to submit the bio, we immediately call the
> > +		 * IO completion handler that records the error. We
> > +		 * shall not retry anymore cause this could lead to
> > +		 * infinite loops in case of non-transient errors.
> > +		 */
> > +		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs) {
> > +			status = iomap_writethrough_try_submit(wt_ctx,
> > +					&iter->iomap, wt_ops, &pending);
> > +			if (status)
> > +				goto submit_failed;
> > +		}
> > +
> > +	} while (iov_iter_count(i) && iomap_length(iter));
> > +
> > +	if (wt_ctx->nr_bvecs) {
> > +		status = iomap_writethrough_try_submit(wt_ctx,
> > +				&iter->iomap, wt_ops, &pending);
> > +		if (status)
> > +			goto submit_failed;
> > +	}
> > +
> > +	/*
> > +	 * In case of an error, we only consider the bytes we were actually able
> > +	 * to submit IO for as valid data and revert the iters accordingly
> > +	 */
> > +	if (status) {
> > +		/*
> > +		 * we still need to run the endio completion for cleanup work
> > +		 * hence call the below helper to take care of it, if we haven't
> > +		 * already done so. We can ignore the return value here.
> > +		 */
> > +		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops, status);
> 
> Do we even need to call iomap_writethrough_submit_bio() here? 
> 
> In all the failure scenario we reach submit_failed directly right? In
> the cases where we fail before copy_folio_from_iter_atomic(), we will
> not have anything to do anyway, therefore, making the above call a no
> op? Am I missing something?

Actually if we break of of the loop due to some error and nr_bvecs
is empty then I added this call so that we could handle the cleanup and
even if there are not bvecs to submit, it is still responsible for
calling bio_endio to set wt_ctx->error = status, so that later we can
return it to the user in iomap_writethrough_complete().

But as you said I think we might not need the complete endio flow and
further, I think in this case even wt_ctx->error is set in the higher
layer. I'll take a look at it again, thanks for pointing it out.

> 
> > +
> > +submit_failed:
> > +		iomap_write_failed(iter->inode, submit_start_pos, pending);
> > +		iomap_iter_revert(iter, pending);
> > +		iov_iter_revert(i, pending);
> > +	}
> > +
> > +	return status;
> > +}
> > +
> >  static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
> >  		const struct iomap_write_ops *write_ops)
> >  {
> > @@ -1345,6 +1700,88 @@ int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
> >  }
> >  EXPORT_SYMBOL_GPL(iomap_fsverity_write);
> >  
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
> mapping_min_folio_nrbytes can be used here.

Right, I will make the change.
> 
> > +
> > +	/*
> > +	 * For now we don't support any other flag with WRITETHROUGH
> > +	 */
> >  		__folio_cancel_dirty(folio);
> >  }
> >  bool folio_clear_dirty_for_io(struct folio *folio);
> > +bool folio_clear_dirty_for_writethrough(struct folio *folio);
> >  bool clear_page_dirty_for_io(struct page *page);
> >  void folio_invalidate(struct folio *folio, size_t offset, size_t length);
> >  bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index bd87262f2e34..9c8d91b926a7 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -451,10 +451,13 @@ typedef int __bitwise __kernel_rwf_t;
> >  /* prevent pipe and socket writes from raising SIGPIPE */
> >  #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
> >  
> > +/* buffered IO that is asynchronously written through to disk after write */
> 
> Isn't it synchronously written?

Oh right, I think it got left over for an earlier variant. I'll fix this
thanks!

Regards,
ojaswin
> 
> > +#define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
> > +
> >  /* mask of flags supported by the kernel */
> >  #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
> >  			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
> > -			 RWF_DONTCACHE | RWF_NOSIGNAL)
> > +			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
> >  
> 
> --
> Pankaj

