Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C59606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CdqqVnYF
Received: by kanga.kvack.org (Postfix)
	id 37F346B05B1; Mon, 16 Nov 2026 14:52:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357656B05B2; Mon, 16 Nov 2026 14:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246136B05B3; Mon, 16 Nov 2026 14:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFD46B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:52:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BF0D1401D1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:52:18 +0000 (UTC)
X-FDA: 85442028756.02.191CD23
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 19270140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:52:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CdqqVnYF;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794858736;
	b=s5cPNk89IscPU7fBHGNKxQM/KrhO2i1Gj0WFtPtsBe1pfxnD7iu7yjbUltUm3Oi6QtM1Kp
	Id3jMnqJ5TFNx7xgVx3VHuY+lA288B2KL37Wt8iiHijDn734j6qFS+2rODcyr8FLf96dZW
	5o19EWo4Tj3bPHcb3cvmsmZW94AfK+4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CdqqVnYF;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794858736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
	b=hZChtLvubydO6wY4+13asMcrq3fFTnEM6VW7bTEHYW5VtbajdwId3Jnx8trW5PQFIPa2nx
	jETeVuM5PX3v0sBo4EBGeM6KizlCHh1KmD7o7Dt7JVdKrjrhU55D7KGfTH1Kcec5J98ScZ
	dnOhX7AOW/Grz4SpU75ZkdzxkzWYFzA=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-55d3563e50eso21365971cf.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794858735; x=1795463535; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
        b=CdqqVnYFb18pQ+RHH0AZVqtV3TDpb4l9J7YPL8ysFCwcmJPzLSH+Utw4hUC/OoiMmn
         An9T/lPpqYZCX9giyeMhfgAwBySkDNQPq+vPv+tH5dYNn/sdHM3esacFWZ8ve8d5kTcq
         0bsV3DbRDsBzx2A5vD90aH6BGdBa1AqpzLt5Hwbt6KvtyeRRDq64xKbE2uTdtn36hQDt
         yd3IeE2kb8dzgXoqkHMW12g65miVCS7e39yAyuPBnpRrhV7UQCmel9froQa+TJcVAt6n
         DfmWbkZ9gQIXlIAUrhZtwuYJsunFcWf3Touwr3oa4mymiwqtam80659Ux2xOR2T60sla
         QCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858735; x=1795463535;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
        b=RP1pwAWfRytJZ5N2+cOhpejpQZ3708ND2t9+hNAiZ/2+tdBVZg99+r94Tq41hMHLUh
         43nlnH8IIRrz6Jt3YmklZRlOoGUo11oH5Nux5EaNzuRQh+SkJKa3+wqrmvpUHp1VZhLa
         vCPywSk3bhv5b5wdRCcesGywpBaPSiorItiSrPS34Y0OU3gf3G2ZoLLXO2QnapaGfZoK
         rjN4xQMH6JlUfV1QqPgQVGdxJSJMbnHdESaVSaZOTzYtyFiEdbGtD99Gzpts6Q6ArWPI
         eHGJEFj7U9375gwyft+zDQL6m7cFMKo7nUxyCguQcFLZMi6U5Lw8pzpS4UCE2QnvYidQ
         zPWg==
X-Forwarded-Encrypted: i=1; AL+hErHlqMIpKMbJY8Up68J5vxh5Y0VIfio8smDEmT4w6IFEVmv5qPIJ8ZXrl2YKVMKCVSzPS0ZwrnAR/g==@kvack.org
X-Gm-Message-State: APuU4Z9gRHwpeOzWsd0Fry+2CdPanDf812f8dfFVF15nVMTapzThWPoW
	NmRfrLk+nqJ3d15bRlZrC1VEN+bzneuyTEthMP1fAj9eduWbACj5AMsnc49wD2n02B4=
X-Gm-Gg: AYBFou2fqpfhGEGALjLpwHchk8kRR2t5Gg7UE5y2ZfE3WOL0555qBWPvOqGYckN7NQd
	1bQxOchO0XIWcVmieCbM0SD1TCixubz50B6ay8yfKRXB6pxRqHzpwiNT0t3RT3k1pna7hgc/x8X
	RHzQsS408oDPQbOfbgxqW25nKv6j0empAEj8NCvN+BZDu3QINE2JDqYjVqug4Icp1eJDVdne/X5
	e9ZfNkTEq4InMkeFip4eTCRPjEFppYCMqtlFknuEkwg4RxkIvgzY07o6PDchmyHtf7qC0ztQzBB
	9DFfGLpEl9PDLbvc73lItCTl2KOXkMbTtc/sVvhVjKj54Njrf/Egu8kUfZOQLtrdvFEIKjAQCNC
	TAveZKMKT+yBYZczhvZ27dU2Rg1TUEnu/SFl4N4x0zZ4avzEHfBi2XxoIPpUNiKXS5glYxnrAT7
	BtwLpN+COtYUCO7Ues4GezkpaLz/7e4AiJWfXsAWV8C8mxVKGcPQbpcBTu0cjZ8scf/RhmQJQGw
	9g7IvbZ/CqrA9zUWIYJapEZVInJ9me0BVK0MuxWFa5dFX1NMK4jn1jTBVhBng/pg7B0AIdbKgP2
	muYDMA==
X-Received: by 2002:a05:622a:13c6:b0:55c:c7ab:4445 with SMTP id d75a77b69052e-55cc7ab469bmr121785021cf.29.1794858734926;
        Mon, 16 Nov 2026 11:52:14 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f8319d44bsm48973876d6.4.2026.11.16.11.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:52:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xT2kP-0000000ALbT-12cG;
	Mon, 16 Nov 2026 15:52:13 -0400
Date: Mon, 16 Nov 2026 15:52:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
	will@kernel.org, linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com, robin.murphy@arm.com,
	mason@kernel.org, aesteve@redhat.com, tjmercier@google.com,
	harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 5/7] iommufd: account the hw_queue page array to memcg
Message-ID: <20261116195213.GF2452510@ziepe.ca>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-6-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106131829.3228926-6-cui.tao@linux.dev>
X-Stat-Signature: apx359iapfc8r9t7wjuarguuhqspyr8q
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19270140009
X-HE-Tag: 1794858735-688464
X-HE-Meta: U2FsdGVkX19S+IAONqiE+fBs1gpmykiRuSC2bFV8AQRiJo+jVcc93dAjGinIlpe3DT80vd341SmlQ2r6ZLfbubTfHDzOzxu/jZI2RK/NEJ+4ZQi4PFR1Sz77KxQIKA0bvSFeT2ceIrUQI37iSULqSI/7xCWROq+xzkxkw49RfjkDUPVs/zSkADryiSOHaFlgM36vCXvySh0ioNr6Hb65EDN24bzjIUBBmt5Mz35Jh783zHqQ7I6oki+Q4TMqKV+Z69zeKqiRS/CroPG1eiKjC/6RXeO5/gS7UYC1aOtzxY5N2g3wfZVOtJBVrBEDVd/X7m9KBeQEaS9QtP2H7uL/Q1X4yn10HPSM/9OXp7yHMtJSwbLtO5STbjakLPMHD5B7H6anC4H/mh0DKpYtt/ovR6YFJwj/Wq4liSjQgNb3neLtjHPsPYxEqitNXipmOwx2cFaTeu8lLhkhqfmMBwstqX99Uhyu+OexIy6tAMoDwdEd15HbYjSzqK6wKjQKKWAsDhAEsyLenCyrUFCzvwtVw/FgUP3cc6PiHZbpfor/MzdnsvBMeKTjKgzFFyos/OuT4CPNJ44NkRWpUNzylchL7k/HnsOGHW6KLcbW9bSjNurGBL99z8gO4PWM5MWOGNWtW5UdHbKd1oXll2cpctpjThcOvrtMhMpHFz9XP30LU4T7N954zJWY7yyTtcEKXZ7U1amAoegVKUUimqawDpKDdZNk6DbsO3WRMhjyUMEUdBSfHcfglxHpJlVQ6mvIkM1D6u83A2WpVO3uOWEPHGa19AiytasUOGCVfrlCBcTgbrV1eUCwq0kAGNxKymixTkXOLqM7Qiafn8ZoV3A0i1ePkJ+h5LWMpH4bH2pg+gX+nQtPHl/eoMTQXtcU6lHa5mF9tLpdG8l1GDXxO4YdO/mJYI6st2X6t3DiOj7PLpc5LkK2IOaNKuyrgBcLFDo8nV26+rPUcWk5m/MJb/MaHo1
 CazMU4bX
 X4R61uhQB6bU5qvEiz+ojD3V4MXY4wfjKM+WXr3iDbQLH/jjlBH6+0adzNrLi8sxdhWApdail6lMnLeD/VFcWGA9NCh6D7pqtWYsotpSKREX1KR8DgUApT+p5D9l3oDRiUKa3KlgRph9SlcESGm6ZoEOSE2Fk0YdPtkwDJzPjQ+ROU2HPeptnLWl9NYVcP1EI1/SU4BbrAjGGTDYVU1mAef5DHUnUVBIDSpTpR6Ca7gXDB7CrP9Gxok6oQmHkZ2PZpThg/Tx9p47Pu5pNMHB1636W+nhq3YUlYSN/+SBGc8zpHIvGalOKHwkutPxAfXjJ19Qj/OHMKyuW0DfjOdbx0OUB4uOjA2FE+cp1XV+hjKBcrxYsFeGwVjs5O9Ih5W95zCj+ZeU2Asc1sCT9pgXr+tQApOwtkJmSAXlFqJHguIzflkvB/Y+10FCnuqgmB5dlN6pegEiYXLexAa0xpLGs15ciVgUrWgdjiFCWY/SjTi6xds8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:18:27PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> IOMMUFD_CMD_HW_QUEUE_ALLOC pins up to max_npages pages just to check
> that a user supplied queue region is physically contiguous, and the
> page array for that check is plain GFP_KERNEL.  The size comes from
> cmd->length, a u64 that is only overflow checked, and the array is
> freed again as soon as the contiguity check fails, so the allocation
> can be repeated concurrently: a 1GB region costs about 2MB of
> uncharged memory per attempt.
> 
> Every other iommufd allocation that scales with user input is already
> charged, and the pinned pages charge the mapper at map time.  Charge
> this array like the rest.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  drivers/iommu/iommufd/viommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

