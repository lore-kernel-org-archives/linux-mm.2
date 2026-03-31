Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67D210F92E3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396786B0095; Tue, 31 Mar 2026 12:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347616B0096; Tue, 31 Mar 2026 12:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D5C6B0098; Tue, 31 Mar 2026 12:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12ED56B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:41:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B37EBB7C21
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:41:28 +0000 (UTC)
X-FDA: 84606923856.08.72921C3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D86D40002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:41:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k1V1MEb5;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k1V1MEb5;
	spf=pass (imf04.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774975286; a=rsa-sha256;
	cv=none;
	b=B0T7Y3RVWB7GuQJdWcObraOEGadJW7lkZVVX0uSCQydfcRDnVfgtqMCDbE1NZ+tygabtmf
	IQBuSm1Dmy2MdSY9mnGbJq64rRk7VHxuOPnKkXfIRxTYdCyqV6Rt1IdI3DyzrE+Bdm3/i2
	18pWtKlDlVFzrPXvO700m2+JolOYVsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774975286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8VElZD2L6oknDjxBd2uupgm7Hy05dqMUpCt0gFgZj4=;
	b=bHGISrC94OfLfp5hwhaAWdNXznDCikTqlIM5b+BDRxkO/AqcsyQyE7MNhHE3ro7QI1xTiU
	B7IJOWtoVqYLOueZOXoSp+bp9Mup9daDyH2TfvwlISs2CA+TepO/vIMydArHaKg3iZAZDp
	9EaUHs6jTkCyv59RyVFSqe9iyh2DzHk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62VDu8A13071713;
	Tue, 31 Mar 2026 16:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=p8VElZ
	D2L6oknDjxBd2uupgm7Hy05dqMUpCt0gFgZj4=; b=k1V1MEb5Twtx+XMI3zGh23
	72ijmPod70yiYKLaZoCH002M+48uFtuWaqpPdhFgl2uMZyItF+cZBqC5gMPYzHRD
	rwscwdw9k8KEG0GUVmopQk9VEKfxaPFzKelGZR4+5CjvcdvVq9dcmKLUHy6s3VHG
	Z5fNCIw/CDDQ0aTCMIqSYojKi1JundvVxKxATYENCQPTKd8QKFyZMbpWE09/Yx+8
	nuutX6RW1pmPreH46Pi9ic9vCvEWgSpjjzEMXL0dkwcIApElmR8uW12nBg9IW/9C
	NMdnhHgcYlr5BHijbBMVAMverZeqh1OX3eUKmbc1HS0RyJfWOW0KfTfDHwfS5cGg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66g1vch4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 16:41:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62VEtdoE021722;
	Tue, 31 Mar 2026 16:41:23 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6sasj41j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 16:41:23 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62VGfNtC33620486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 16:41:23 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23C3758057;
	Tue, 31 Mar 2026 16:41:23 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F8F958058;
	Tue, 31 Mar 2026 16:41:21 +0000 (GMT)
Received: from [9.39.16.245] (unknown [9.39.16.245])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Mar 2026 16:41:21 +0000 (GMT)
Message-ID: <b9a94967-1823-4341-86cb-6b41e1715889@linux.ibm.com>
Date: Tue, 31 Mar 2026 22:11:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in
 weighted_interleave_auto_store()
To: Jackie Liu <liu.yun@linux.dev>, akpm@linux-foundation.org,
        joshua.hahnjy@gmail.com
Cc: linux-mm@kvack.org
References: <20260331100740.84906-1-liu.yun@linux.dev>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260331100740.84906-1-liu.yun@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Fdo6BZ+6 c=1 sm=1 tr=0 ts=69cbf934 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=KRjjIoBpgHFGiB5EKsoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Gj21WBsf_9GbkkbSsoCXEPHnq8mYohAX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDE1NSBTYWx0ZWRfX7eBM7mUwd8vg
 qQfE67jewF5tjB24XMG05v2xrt/j/q6VSyKE2KeoFY6oher6A0bj148Ip5S7xsiLar3ZYaHxWGH
 eJJnYixbFVzD9heRDn4DgOdCxVvZEUcuXC3XagXeNLt7xwTd2MUzAlLd7AmuGDluk3uWzhJ/98+
 qpOgZoZinvymwRiCwI75wrMhDrTewBYo9w+OQJnbJPNqyXR0/H7CzJHBHwztNM2LXzTs06fBCFL
 EYVcGwcdiVLmk2Kn8UBo7UAf7wmpQsZOsU+D4D0V21VyINYvaISWKYN5Ldos/vLPJoCSV8wt/JD
 0oXOEHtwaXv5J+pX4Jreqffk44ZejEX/6O1bjZ1iZW/pSQTw/XkduukLfEka5nv5Rqeh8BVUDcA
 L2ZRVEp8mfuOuUitc6pxZq8KcdCP7VE6wfZYpPgRfYBD/f8wcrsZMcytd+ok6P2QQKv6P9ZD60m
 CuwAbQUblCQPFpX/AcQ==
X-Proofpoint-GUID: E71GekVBL8OelB9Oti3TGL2ZXN5wV4TU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_03,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 bulkscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310155
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D86D40002
X-Stat-Signature: 7je7qgp8arwzy8cjifaxrxktqbqurjd8
X-Rspam-User: 
X-HE-Tag: 1774975285-534720
X-HE-Meta: U2FsdGVkX19QZrtky9gY61ksyRm2Y6ZdJVvl5knetlnyzJw1iYG+r0+NsCNw7muCRq2tw7b0+eB1MIv7CW2vAgh4f9K1jbyd985PtkvAifzM02cYg91HDZ0JlRrCSIG47fm0LC8m2JMlihsX77v1RhE5Kj7yMaLt8/295HUIxpf19FEQu/LTGwBJfMVBxn4SPHynOsv1eNy3YSoMeq60Gk2Fto5j2pS0npmlbNT8uVgptuNjo5quOY8U/RSrLBr5f+vm6O7sjRQZh4eOltLk5IbKjI7grJt4XyBAblkxIJXLZ+yESmgjxaJPflzSMz4syqxlRmpJ2odfSGsTK0qSVt/eRuA/QV/Cszvbqck3ImrYtWirUtmy7jq3UjMaFf5XZA8B2xur+jQ42UsqKk1ysX/sTjcoDX71kqgYhqkX8VJQeUmC6+xUWmDqxFAAvi+L6khwE00FqAYroKyrBFF2hsHinXo/45eYq7O9hIffY4SH5/Im6Rd+Wci9G1fNHoURR0RsbUafdK7OwRkh7To2cYm+Y7qxnsWtk9IckdbbRF8px4IhvF6g9JD/gLNB9egupqrVcASSg/r7Wej4e8CwPw27tkipCnCbIo+DjrN5yae/uTa2R1+kQndwH09ZKB+leVExm5U1AYnWc/MoimkKWezhewojbilO0X4ZIEFfo6TOMTa1RCxDv73xw9lZ3IMi1St1NzQUfQUgsdLhDLclFl29obebxJgn5zaQ6K7k3JwjJElIND45VsQt5o1As/6pvrgPawvWQjeHGcmU6xrBkGc+J+aJ9n0b2brVfnYUxPXfkC/Nk7z2UTBQisd9sus4af6ROvZ+OnrkrLsvPGQFiDpxuF6RjmODang/YXB63t6X2bIUxbIkYoF7NDgPWpUplU0sl02W9aEKypZlePzheiU4zifv8nOJLM2kVMDZ3mUPb5YdR97wFqqgHaJUOSM9cSO9XGPM6VifiRmXWVG
 daRWwmdo
 GKO/g5JBiw7qHjaIoYEwcduGxQwzJ60pFJzCR0gnIiKtRhyuXKAHxj54jgrZduIaIb3/xaGhYKncrMcbhLX0UJjNHHdnpFmnispiF+qAXxS/GrOaH3sjPaQTkjQS8FtMC1B8PbVO83B8spEHu+oLPdV91vC1SDHy9JkZwk2cdzkcvcgP1krKNNqoF0lHWhu+S+32RzdMAtyZ3Zcfr2PFCbSUZioJO6nPKASD8tWnHCgevRo7liLfqoeAVTcJhFxHYBq1yyH8Jf6O5sTaWWWVdDlVe3uhtEY7w6l/765Gy1z3wCS36zGRmNf5kpus2DBkrcEtMcNKnoBDBR7Zkupt8+jaDFiCNM6l+bAuQRS4/k7Q7oyTPIjRbxRRbTX8doOtthbqi6EbkE1GXhDfwfXllzprlBysedNtspyxhuzE8dCnln2Sj8l/f982nbMXqRq8BO3p5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Jackie

On 3/31/26 3:37 PM, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
>
> Add the missing kfree(new_wi_state) when the auto mode is already set
> to the requested value. When a user writes "false" to the auto sysfs
> interface and the current mode is already manual (mode_auto == false),
> the function returns early without freeing new_wi_state allocated at
> the beginning of the function. This can be triggered repeatedly from
> userspace, leaking memory on each write.
>
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
>   mm/mempolicy.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cf92bd6a8226..9ac74178075b 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
>   			goto update_wi_state;
>   		if (input == old_wi_state->mode_auto) {
>   			mutex_unlock(&wi_state_lock);
> +			kfree(new_wi_state);

Good catch—this looks good to me

Reviewed by: Donet Tom <donettom@linux.ibm.com>

>   			return count;
>   		}
>   

