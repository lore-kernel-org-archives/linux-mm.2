Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2B2C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3586B008C; Sun, 20 Sep 2026 06:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663716B0092; Sun, 20 Sep 2026 06:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552946B0093; Sun, 20 Sep 2026 06:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA3F6B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:40:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7490803FB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:40:02 +0000 (UTC)
X-FDA: 85233795444.26.8FC27B4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CCAA120004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:40:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I5esfV1r;
	spf=pass (imf29.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789900800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RK8MhFEjoR9MsQ7lvitTMuOcWt5G4pq46ghGLdTd364=;
	b=IFm1ds7OSP8ZI+MRq7Dbm6V7xIecg1z/zhkx0HPWLKqe+Eg+6JWwGddfZ+zPQQrcorPvSV
	y1hRG5T2p6j+swc/KCFsdFhS2N0UVNrlELnV9+4lz9KFkOb3hJ/i9GGlNKMv7TL/TnIsCC
	mSWpO/8YMM9HRIfZABCH0v0mRRU/x40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789900800;
	b=OEKq/gRIp7HjRmrTjD55UN3RYtPVgyWJpsiMJYGhuNwdkfZpt1YS2DA32WJ1ihQ+iVEETK
	Eg9yN48n5mWWF+mwZTQDc6Fv3enNcfN8E+hYq7o9OmtTlhNl4hwj15ptmFLLIOVgQyXNL9
	zMQtTUuBlCh3IJFHJEcx2oia6vjxB4U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I5esfV1r;
	spf=pass (imf29.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68K8a8fd374521;
	Sun, 20 Sep 2026 10:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=RK8MhFEjoR9MsQ7lvitTMuOcWt5G4p
	q46ghGLdTd364=; b=I5esfV1rc3LJTMYJppGN9nmElaeBUtDMXVAVes7n+N0wJO
	aN9AS+tKJuQ4XyMrJYa68afJ7G3FfBiCFreeKxavzL9qJoENgJR+cqbmw2jdOr+K
	6k/IXQXEiX5e/JRib/mfoefZdml2nLAPnExbS9+v9rJ/ku3Z3DdZjRcqfNsjn82e
	wLuKbbeW7MYtCVemia5jjhvEZThd+7Px362ukgcFQcjl9UvaFwQGkLVG4ByfDSd8
	SHFy4ps+JDlsjAwPOC6CBMj+cgQbm6plm67loPhSrK5+fS8wQgXMYEeZ1ivpBM6l
	4fml3VuNhuxorHWM+SyxJ5xFTEPKMiRRLDz8ad9A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1c7dt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 10:39:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68K8Wipm3691561;
	Sun, 20 Sep 2026 10:39:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt6xg9324-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 10:39:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68KAdjb542729774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 10:39:45 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 725362004B;
	Sun, 20 Sep 2026 10:39:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3243220043;
	Sun, 20 Sep 2026 10:39:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.136])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 20 Sep 2026 10:39:38 +0000 (GMT)
Date: Sun, 20 Sep 2026 16:09:35 +0530
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
Subject: Re: [RFC PATCH v3 01/11] fs: Add counter to track inflight writes
 that need stable pages
Message-ID: <aq-354yFNejvTMIl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <548c55490029490e68287aeae3d737454fa78e0e.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548c55490029490e68287aeae3d737454fa78e0e.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: iMIGYRX6mZp8ilyUkWcZ1FhI8CP3hpa8
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6aafb7f4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=qKU8kmA0DVxVJx7tx1QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDE1MyBTYWx0ZWRfX2cmciqSaQgZw
 tFhrMLyZA0X4/KtOMQWu8tlttFRNGMfr3cPy95HUe2LD/qqTvGMq5YiYlaCSV/zspqVz5D63oWZ
 JEiJUQrUH7QdbHnl6ebk+MM6NnQnLSo=
X-Proofpoint-GUID: Mk5rBBszko9gS9EKc84zqlLL37D5GbO-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDE1MyBTYWx0ZWRfXzY9M7AZCr4m2
 10NVRrYwr4GvVKlQszaoi9miZRtq1WF3ARRASDHBTSoPmFo+j8uBYsyrgLO9yH98Jo/YnxQvw4u
 /wMQYwiJSVAftUNvNaRuKflj2O+8l8nOdQRrPw99xZDCtdmBeknzMRCw9VR0qIz7DU3FWJGC5kG
 Mvwe2C/1DW8AgdYG75BonCumFO6KoGIx1LJRqdy2rGLKjvuJesSEzDdaOh4txvDqDcfzhSxmoBJ
 LbIvFPN6RdKhAk/WWziOM6vEvcbIXpu7auSCD6jnhTc8DyjUJlD/T2pOfNZtHTqCT1oTBkCIxpa
 ThX6L8GQVSocoxWW10PGqiBiOgCJWa60qS6nmQ/WlI2qkN3ZIqi5xTe3/TInEkS3gWvbQC4eTfF
 VOTTfnVz2S/9SpffHe546iowtJ6TD/w0lDWLBPH7eggpxJ4XQYuVdtAxoYxGoRTxtRB9KZW53pB
 uRTfG/TcW7XgfcHHTBg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609200153
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4uoete68k8iquguqxa4nxy7nyyxubjsr
X-Rspamd-Queue-Id: 4CCAA120004
X-HE-Tag: 1789900800-936801
X-HE-Meta: U2FsdGVkX192KETv6UbaQ0hRxtrx/OeEmCdIXa3aeyUFW3Qk0lIGGwtIdyfQwJhaog40BHacyFxC9Vr1RL4R7fIqOOirL/xOVj2CbibzblGIUL4Fe2e2VaDYplTaPhouBAPDhWT1P+UJnHoeNKZGFRlrhmDnEjg9INTEhjtxFn1jBVyRCcGpKyIPm3jp+BrvoyRYYIgC58Q2HbByVk7Lj8RKfUDH6cZCdArOnWdLtPKgrfaQDDk3obPq54horNPo3LN0/d1G/hws/3iCppuDEkHmpG95r8I/pEMdAbNmcVExgpv4HdF4UORFh0bKP3iNpdk310Y6dNI29w5C4hShRkJLikyxo9+Hxy4DIgm3y/i5ZARl2v36NqCk5B5l+jkt2A61wcny7ikWJg34d74Sjo84YAGtdMcvrNoS9mmFHbBvwz/JrtQNmwrj3GecwhNOJMpp9yOaS083sHSSnVXtEXbqXesHTTWP++ZBHlR/qtICoGi6MtjakiP4VY3AZ/RiMiN34py0QWKahNQ10ou1WDGc+6NP7z6kbdSjDQPumSCsXbENsxeWs5VEV00xxJcjQ8hEp/w4iVdBLr1YeAeTtv9XawGirMhBDMuIIRFBApPhnlXmd4/LKIslduKuhe8DQHrhk9zofpsJ0/fJu1vkpWP4Q6oqFxB21sp/mKZGlINpngE1ErSmLrUTq/r9ko+LFGOPHExSUQMwzh6UHs62Hwq3aNHwhpKxhqUfuIVGOxo2/Alif6Qap9eaC4xIgKu67jju4nw6Gd4I6t0iDhvTppWe3g9jbPt4iSw3sMzCEhp+1bbe8iKjShhTL7lZknBUrmzvhfSz2YyMETHMOlmFgMtiYNiZdWIDNzqSTaMQp7kVOMPx8VReMXhXNkdgtwf4THW4pNO8sUcZJcDaUoIv4o5e6hguBwxiGHBYtE6Rpmj9681mtoarlEniHjqzUZX3YHPzTgwmqiuN5YKgeQ3
 XhYdxkAP
 PcrSGwgEc6xu+Klr29xv5XauNTEhIoKwkghrp3oRauoRpB5HPqmSwZmt4IFOYCJf88X87DjQKK1dk7t2qCs1D6/ICX+Ei27ijGa4J1ZwyWJ7sb98PEpYdc7IgusprNHTxIUPjIpYMM+EYOgB+Goi3Gkwvi/rq4z8GmmwGmW6kEbfAQmIlQZOzm7QLXew8ceHs8Xfg3vyPTomXcRJEmDlLK/DAvzwXEKyn7qeAkmRmz4bah2ay8RPMnH+smSVKGnvTwnZA7Sx5ExaaL+2QNBiI8PSD70XsX7PN4cbQ+Y7fU6MEvpC2BE5LquhXzWxaQoYv3368/1ZkmEESaNQMIhrDEj2oc8PdYYSEBbzvMrspE3K8UZspcrznUMecEeRcPxmy9scBNL/FT8bReDAmUrfJ/TrBcqR5kOVfbf9KPsCeEaXa/XC/MpMB8k60QHrUqlsQ4Cbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:58:07AM +0530, Ojaswin Mujoo wrote:
> The current flag-style stable write implementation uses idempotent set
> and clear functions. This is okay because the users for the most part
> just want to set or clear it once based on factors like underlying
> device support.
> 
> However, this scheme doesn't play well when we have parallel users
> wanting to temporarily set and unset stable writes. For example, the
> upcoming RWF_WRITETHROUGH patches need stable writes to be enabled for
> the duration of the IO. The current scheme can lead to bugs like:
> 
> RWF_WRITETHROUGH write 1             RWF_WRITETHROUGH write 2
> 
> enable stable write		     enable stable write
> submit IO
> disable stable write   <---- WRONG
> 
>                                      submit IO
>                                      disable stable write
> 
> The 2nd write loses the stable write guarantee midway which is not
> correct. Fix this by introducing a new inflight_stable_write counter
> which can be used by parallel users safely.
> 
> Unfortunately, due to the way the current users are designed, we cannot
> directly migrate them to the counter approach hence for now we will
> have to keep both methods till all the users adapt to the counters.
> 
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  include/linux/fs.h      |  1 +
>  include/linux/pagemap.h | 14 +++++++++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8e9bc9dda0cb..5f17aa0ed4c7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -483,6 +483,7 @@ struct address_space {
>  	errseq_t		wb_err;
>  	spinlock_t		i_private_lock;
>  	struct rw_semaphore	i_mmap_rwsem;
> +	atomic_t		inflight_stable_writes_count;
>  } __attribute__((aligned(sizeof(long)))) __randomize_layout;
>  	/*
>  	 * On most architectures that alignment is already the case; but
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2c3718d592d6..eb8b7e292478 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -306,7 +306,8 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
>  
>  static inline bool mapping_stable_writes(const struct address_space *mapping)
>  {
> -	return test_bit(AS_STABLE_WRITES, &mapping->flags);
> +	return test_bit(AS_STABLE_WRITES, &mapping->flags) ||
> +	       atomic_read(&mapping->inflight_stable_writes_count) > 0;
>  }
>  
>  static inline void mapping_set_stable_writes(struct address_space *mapping)
> @@ -319,6 +320,17 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
>  	clear_bit(AS_STABLE_WRITES, &mapping->flags);
>  }
>  
> +static inline void mapping_inc_inflight_stable_writes(struct address_space *mapping)
> +{
> +	atomic_inc(&mapping->inflight_stable_writes_count);
> +}
> +
> +static inline void mapping_dec_inflight_stable_writes(struct address_space *mapping)
> +{
> +	WARN_ON_ONCE(atomic_read(&mapping->inflight_stable_writes_count) == 0);
> +	atomic_dec_if_positive(&mapping->inflight_stable_writes_count);

From Sashiko:

  If two threads concurrently call mapping_dec_inflight_stable_writes() when
  the counter is 1:

  CPU1
  atomic_read() // reads 1, bypasses warning
  CPU2
  atomic_read() // reads 1, bypasses warning
  CPU1
  atomic_dec_if_positive() // successfully decrements to 0
  CPU2
  atomic_dec_if_positive() // fails to decrement and returns -1

  Since CPU2 already bypassed the WARN_ON_ONCE via its separate read, the
  unbalanced decrement fails silently without being reported.

  Could this be made atomic by checking the return value directly, such as
  using WARN_ON_ONCE(atomic_dec_if_positive(...) < 0)?


Yes theres a race here. I'll change it to 

  WARN_ON_ONCE(atomic_dec_if_positive(...) < 0)?


Regards,
ojaswin

> +}
> +
>  static inline void mapping_set_inaccessible(struct address_space *mapping)
>  {
>  	/*
> -- 
> 2.55.0
> 

