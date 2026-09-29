Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57DCCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B553D6B0093; Tue, 29 Sep 2026 10:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B059F6B0095; Tue, 29 Sep 2026 10:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A70B6B0096; Tue, 29 Sep 2026 10:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 618CF6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:01:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1A1C1C335E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:01:33 +0000 (UTC)
X-FDA: 85266962466.28.513C2E1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4286E1A000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:01:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gGMmGqu9;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790690491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/yJWK1stUje8CsMHuV/XRC7f012iODF6wXZWiJffxM=;
	b=YzVuR77VgpjzNntzSCqtvGuUcHmCOg+8CZscNlV1QFb6bON5j7R7fuAsgmNqcTyaTP9ZT2
	vNaqG4gvrJ3m6WhIMRehgpviWaDcjHem6e5JpLkPuCzOSj+Obtqacaei018IjnK2Vn4sw8
	2uOfRMffN21ITSTO+tfQJqhGnNHrY/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790690491;
	b=C5KZ0rMDxEgEWW1RMcJza/Ug8wgXT9sCEd7pHBuBpS0oTFEg7mv+/eggOTuaTgNrErYaUV
	9HK2jwAfo8pWeN5EAN7L2gTL01qhflXQWep+jofU8MdiwIGybRRMIbpfpN/9/4D5m3iWlC
	U4clvXJwXo9H8o5mRy6Ogfv+fgQq0Bw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gGMmGqu9;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TB6Buw4018608;
	Tue, 29 Sep 2026 14:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=a/yJWK1stUje8CsMHuV/XRC7f012iO
	DF6wXZWiJffxM=; b=gGMmGqu9t+NoZKnLIYeeU5NgzcPlxFlIUYko29vVnQu2be
	Ii7eN7aGhPykSqoCO4c5L3VjKFuY6zObGjzs6mo53Gfs4jmO7bJ4L7n+6UQwupz7
	mVND5zAhsMSA7tU+cNmXYXq4p42cnane1k8UK/UU44Re/vN6Ab/s0im55PkVf1KA
	n2aLoFP7LO9qK/8hCQfj+PNVnVmuVdZzutUQeiu5p1xHm878/K6ibtW5LHcflT8l
	gQ6h6N9ppBIjW8ZcZk3GIVHFWITeVEurfhYNIeHPsx0fzSdexuzL0wsiLcS8MIdq
	RvmK/xpvX3nvlSH/ULlA/DA+pJZGGbzP9lTV352w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5pt6mru-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:00:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAlWoP1667683;
	Tue, 29 Sep 2026 14:00:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsvhhx6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:00:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68TE0rDn39715106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 14:00:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02C2E20040;
	Tue, 29 Sep 2026 14:00:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9EC7C2004B;
	Tue, 29 Sep 2026 14:00:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.132])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 29 Sep 2026 14:00:47 +0000 (GMT)
Date: Tue, 29 Sep 2026 19:30:44 +0530
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>,
        Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 08/12] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <arvEjPf_I0slxhLZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <ced8ea2c2bc9109837723ff3938a0359ffae834e.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced8ea2c2bc9109837723ff3938a0359ffae834e.1790596383.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CjT8fXnZds_4bXbfNx1G2QY6itM7qHZZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfX8PuKoX8Kkd9M
 Yi0wLqYWMeospKHWJ0IIzfhd3DJsPls0XGSpNvADJZLu6ibXBMpyTC2uy5HZgzDGIDT9cvlQOBc
 Ey5MYDLFHqrn7kwdeshIdWEZiZs+D4LG/hwzVr6dV19FNHoqeR8qmGEcMb0g/E0s/d0oyhdIY3t
 EZCKB05vP/bqUuUKkCywsQaX+Z+nVLH33f9bzdNRmCfdSMr13z8IYY6nkpqp4qQiy72WttmYrD1
 cjfo9KyYtED9gLbpL3QYsF/J2G8odafDWu60ft1yKYyC2DqgCC+VQ2kM5yxw20HRF8i9S49sUXi
 15yK7TxxH7j1ruNr5JsSLcOWfKwf2/6poxwJBZHuZms3qQ3dm9BnqFf90GeaGfBoKRA1eVpU8C0
 Sh/diq4hbh5qFttVDxy+SUuBe5gbCzDWKdr/yM/tKq9+F+WCJjyYYwkZ99Z9SE5Vj5i6axMkFoK
 JjtNOTrOIvfYOg2ep7Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NCBTYWx0ZWRfXyi5HmSe1k+no
 EvtTNmJBswmiwTfkQvLOPUqlPh97ru5kPQTwFFDIxAy6z5PWoIoD44YkM5Qdv3gTScoaK9AmZ4B
 WDlObc0g8VUg8l/20DJok2RTOx3R5CQ=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6abbc498 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=BWZS6MWZrVpQMnaX124A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: BZdTZffu_5U9v11aQCG_SSS0OTogAmHy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290054
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4286E1A000C
X-Stat-Signature: an9ayeq4i4meoiyyqom5gbp5fqtpo3i6
X-Rspam-User: 
X-HE-Tag: 1790690491-543790
X-HE-Meta: U2FsdGVkX19LZSvW7oZ7URrV+SoRFpBYzGsaouG46tgbufppkqwqfxApzjgwwgUEPQnzIsXICWTAtPluYclGJbo27sGQTeTT93I5apRYTIzr7YRZfV6/plP+sORDHCYGzEBR0AYXP+s35oBD3qAwUoMAL1GvImtN0QVL8dD9ql+HhsgJMC8H5NmJbJAcV8UuXEDKTWpaLSjBE3BiKaZDcQiYN4aUgrPwIL9rHOVoM4sKCMLhaS2Jlh5+09e6gqbgYsX/lWgJLkD2wRceyQFRj67Zaxt/1M+G9/br0ehwdyilrgfLSBGWNQWLFp+KMl2zddVtcYUsgNWYViFAHfk4zYCM5qdHuo0at0TZPoOhDS7WsVS4IRKpBqGdohVM6iPYdPYldZPQKxctuZgejIrJJ9JQ/ZuHReQwvIfxhNLt/MnklZb036KeDO5HMxrrhHh74FJ0brtudOXeSUgQq11V0CYhcz0oxV0INKpDBXl1xQzSyymmni0imB5ud12N80IvyjQpy8WzW7dcxUKHVDkrbssamozYMNeg4rwI0RYEUyQ2c/5JEbDLSyUoxXflU6R8XGGickzAz0MNUouWit7jyIp3gCAK1vp3vYVWOZgcUGjZGYZQOQLq1n63pALuhNM17CTpDG4ayaRtWn+yNESP10N0zx7ldx8hXGpEMG9myvku2M4ITyG573LT3BZxkGWuyoy//s6WJNo8apSLJnMFIYnFWzzKXhJn5K1dNZT7KCrjY3H6koAZBli+vQ0qYceEsZMAjIYPcgFfQIbLIu1Sadlf9qrbcFN0P2eS4SXpBmh/3iE/7AIwfWTdXbPW58WmwQuEiCAjiURFCHY7SY809hW0juMzLkpIzF8jL/VvvgjguBOWI8jYWeswwY16H/eBN2IDeBAXOE1kXj945EpCSKOZnCb6npV1cePn9A6d4hNat/1TRF9MBhPkFmnSb6WJScNJDubAI5Y0Xit1h8F
 MlLFvR1q
 IqWixeVS/CTOLknq0xt3O0Fsb/IRXQbCwOXQtIKjcNqwQRgfngCIBqHnHjAuw4vaeYqwZ7A5EWz7AmjZIpgOsuNEJjBej29xf8ityPgAWpnm0c/hWq3hW5sHM+ffLINeHdtvdrRGCKY8MxxTCiRJBEBRWnwr7Tqupv4agfgwIrHaM/HfM6FGOgI7EFsg+SxEuFYVCS3F7+YmipYr8E2L/h7946JnpQxTeaB15Rj7EOioiu4fHeLdONSHAeTPRuQYpA8DSuYQXPoimSCRaair5WCekLEJ9WUWV+jGq1ADEvzsdlW13ZmbLREVQcz87oumz8zscPFShFbW/94ii9YSxoQx05ffzTEukiKFeTEq4oWHo6E3Z/AG7YbypewUdazcFHtD46QLgYN6tkrNBIeKnm21H9jcIXeYMSdbc3j9wJWTStoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 05:33:09PM +0530, Ojaswin Mujoo wrote:
> Add DSYNC support to writethrough buffered writes. Unlike the usual
> buffered writes where we call generic_write_sync() inline during the
> syscall path, for writethrough we instead sync the data during IO
> completion path, just like dio.
> 
> This allows aio writethrough to be truly async where the syscall can
> return after IO submission and the sync can then be done asynchronously
> during IO completion time.
> 
> Further, just like dio, we utilize the FUA optimization, if available,
> to avoid syncing the data for DSYNC operations.
> 
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

I made a small mistake here while doing the final squash. This patch
also removes the EOPNOTSUPP on dsync in iomap_file_writethrough_iter();

@@ -1798,9 +1824,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		return -EINVAL;
 	if (iocb->ki_flags & (IOCB_DONTCACHE))
 		return -EINVAL;
-	if (iocb_is_dsync(iocb))
-		/* D_SYNC support not implemented yet */
-		return -EOPNOTSUPP;

 	if (iocb->ki_flags & IOCB_NOWAIT)


Regards,
ojaswin

