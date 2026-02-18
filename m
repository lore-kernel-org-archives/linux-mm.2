Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D2EE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 20:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FF26B0088; Wed, 18 Feb 2026 15:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D886B0089; Wed, 18 Feb 2026 15:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F956B008A; Wed, 18 Feb 2026 15:23:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5A46B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:23:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDC708AF2B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:23:05 +0000 (UTC)
X-FDA: 84458701530.06.2466FCF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66B27140012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:23:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jhZQuTZW;
	spf=pass (imf23.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771446183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+i1/faGO1lFhzHanw7UXC5RtBSvvF1mijuShk8gkfI=;
	b=t/JvgqtZh1JF/U5TQu4VP1qy7Wu3L++SJJBhEtrczfLByGtXKnUBCrSwAEOGrNc2UCxELo
	IR9+OVaQZDY4/qkHOvaErnNlgJ5Uuh+FgH2a/Os27/s8LEXR0ZM3YkMCOAzvGJ2AC6CnjT
	IGjn965GWzrVv6mDa/3bKppLVx5M1FY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771446183; a=rsa-sha256;
	cv=none;
	b=Yb78A7T0fhqB3R2glsQm5/CTEOTM2uaSVh08+/c6HFuBdTsd0XdqCaoQnpBy8ktFzbC5YI
	nBuhK0Br6HHsQ3uUnuxONvPFxlWfvSOpYiaVD8h6EfOgtgtOSCsQ4l1WXxlUl62HqgGpA3
	LCrw7O33vXBh+ImdGTd2qmPI/CZ2+uU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jhZQuTZW;
	spf=pass (imf23.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IEAEB41410265;
	Wed, 18 Feb 2026 20:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=E+i1/faGO1lFhzHanw7UXC5RtBSvvF
	1mijuShk8gkfI=; b=jhZQuTZWDC526OZq7bI3InheN/0s1ee1iDdXS7sBdxxWVT
	0vxcEQ+6dr5E3yVw0MQ9DgMKFl6Ww7fr4IPPYiDrkdIqrla7V/eiKL5bfjrHfBOD
	PfPhfTQCzlu1zVfjT5ayvpHPxFcZOiz5JmS+skR1x+SzOvXd7QDC7lmHtn5LKvKD
	U/WNr+5N6QGJpXkYdyMkr6bQAaBUJe1blNUVbKOucrvqMgyM605aPwxmf4q5BldT
	hW0Cg+LfXMUWCgcF3D0nlRzzAeueE/FUkgCi5YnUgx0LJFbQjydT/L9nsXOEotWT
	/bFDlafoTxNKko6P9mkKS6ZUaM3sv+qc0gSFq3WQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj4khwth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 20:22:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61IH03pO012024;
	Wed, 18 Feb 2026 20:22:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb271eu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 20:22:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61IKMnkv35914068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 20:22:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C5332005A;
	Wed, 18 Feb 2026 20:22:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 196BD2004F;
	Wed, 18 Feb 2026 20:22:45 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.25.124])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Feb 2026 20:22:44 +0000 (GMT)
Date: Thu, 19 Feb 2026 01:52:42 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        lsf-pc@lists.linux-foundation.org, Andres Freund <andres@anarazel.de>,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com,
        Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
        Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
        tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZYfkuueWpMxEiHl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <bf6eek2jagskkgu3isixqjjg3ftrkp5juf6lge3rjjutzzhbdd@vkliyqpsmrry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf6eek2jagskkgu3isixqjjg3ftrkp5juf6lge3rjjutzzhbdd@vkliyqpsmrry>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDE3MiBTYWx0ZWRfX9FLEzf7jtPZJ
 gxRIrZ/x2mb/H3n910wOIdSzPtIrGUlfYxuofg56lSK0ItA0AyNFv8Kzn3TXJzZIrATwkusRCcG
 0Xu9sAKUIAo4niQIgJvB/rhGZ5z2sx70baKRjeCDv8ftTvGZth3eNx29448fjestSwgOHQpMKSz
 4EN8nz/qwWeVBGNI4PdG1jb8D4u50HpSPy6rPZvZ8AjixQDFsf+vXCnV9zBe9im2jSNVZLEeZ8D
 65VdPgdMP4yUsBDEWzmUtzHEAMdbrtHHG7x7WA8P0WNP3A6cKPh338RkH2592PRkf7PYbrixmft
 5xkKlIwNzF2cRpAscDzy90MLh+/F0Pgwb7rOsLImee/n4n/AUqN7bUtfV2wYRxp0FNR13VG8TnR
 zDFTGH23MCWaerUBCCb2lX9bse28g1p3GVo1g0wE8xxC91oeWvkMkSPe+E80ZmuKjhmmm53rCep
 /HZoD0qSHwr9ojMEJbA==
X-Proofpoint-ORIG-GUID: Wn6Xsq6wTeBZ9-DdGXuQDbfw6exEBFXj
X-Proofpoint-GUID: K4HPm-rnhFQtBUYE8FvRoE8HPd9myNYa
X-Authority-Analysis: v=2.4 cv=M7hA6iws c=1 sm=1 tr=0 ts=69961f9c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=iox4zFpeAAAA:8
 a=NybPXLiR-Eq3wr7rucQA:9 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602180172
X-Rspamd-Server: rspam09
X-Stat-Signature: bg9eoqdcsoirfywetso6tj4y491nw6pr
X-Rspamd-Queue-Id: 66B27140012
X-Rspam-User: 
X-HE-Tag: 1771446183-434280
X-HE-Meta: U2FsdGVkX1/L1mr6qxvXyziKCmhX2xLKbHFCrqyKBDcxmdtUf9sEHzzFHDbUh5fQAY0ircSsYGTiiVkMCfiY/A5ejSzO4DwrId+b5KkInZ55PmZX2EbOKlzKTVH9GohEFA1vjAwZTB/jj6AXmbuDThFxma6/ZnnxsTU5cSUEl50EBxEfpDeCQCOgJkmtHBHpVjW5yZ00y7IozQWQ/uwDM0PHCm7B8TXgzTEVb+VqlAuwt8xrO6oUnkwo0l2+felz0aAAEhSZOsA0n8KIWMJu/Udlw39bfvG+iDuO8glQ93CS6uEtMc37a18pwiOFdUsGMWh4721m8+/I7eYiKGuYpkXEJ79wpZaZnMiJ+D3rhy8ATl98rH6mSs4LTW1Xr9qqY92SoJMK33zDLa3AGkYoQ9R8lZvPOrhpFyJy54AehM7BnUZCxdZlLOCyPtN+YxATDhTIKz0wTIgdEi9NS0FVAaug4P7LbaqNeIPRtavfw7st9Xh962fspTt98vvCzJAw5OwLUeOboEk9eFnOA7ZRwW0okopCRW2GaQDpUsmHAYMrB4AeMIlBzUVAWN0nzBylm+hjauQA/ST1D+2F2OKCVOQnP6Ff4w4/OaKUEd/Sc876aJrMUHjcR9uou2dXjX1uBxifHEhwjntqHrE1PVLpXenG64VJLRTRP8RAvxT+9ElFSsNv0mfP0+aOsxQf5Hi5N+JmIdrbRV+hLDcIM/8FOAlz+g4yVf8Mtr4snssVgXR8Y1zNcPbFcxYR6Rc02q/2EzXxXoF+qW+z+UBKuzFHfKBEIZQVs9Fdu/1zbPurHReTvQZ9KwQQcaJ7Pb0zbjiF8NmLMYFxL3TFDR160qgESRpWnwVzo0t7k88nUsp9DacmtwNKTtNb53WiOh2oFcK73+8x/Khzt5BYHGAF6lAuTddtoZginMicZhml8L1xg2PXTHPVDS14AoIQ/kXZ+EzQxq+fj5DmxJV+qSjmWBe
 xzjVaD8+
 9C7b4owsP2cR+Pk+XjaUL81iqNQNcgXZ/P3rgC89llkbpdudW0Vdp3nsHBI50y7Wcc4HbG/5xT8J99hDctT5nxtyLw7/FTDMPSUkNOYEmvXlPStt4lTnGS5K/NcH+XVt41PzwQyMxJY8i8VCTY50TdPyKg2FdlhIDDM9bO8nkdp5LTqXY3hAxIKnAwe/Qeb4L8ksSAay239jBD6R66m7gzD8gyx7HyCMOzHLcF3FyCI99xBkGoC+rHeZMD37fyd26dDu0nmYiMhkinHP0LHQtGH3o+5lwnH68MiT8oIP1PMB2DFhua4HfyiC0N10Ce1mMTApNWxxoJ9+uG6aap9NbCJl34vszyAk4jSFghEzA3uwUT1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 06:42:05PM +0100, Jan Kara wrote:
> On Tue 17-02-26 22:50:17, Ojaswin Mujoo wrote:
> > On Mon, Feb 16, 2026 at 10:52:35AM +0100, Pankaj Raghav wrote:
> > > Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
> > > pages based on `io_combine_limit` (typically 128kb). So immediately writing them
> > > might be ok as long as we don't remove those pages from the page cache like we do in
> > > RWF_UNCACHED.
> > 
> > Yep, and Ive not looked at the code path much but I think if we really
> > care about the user not changing the data b/w write and writeback then
> > we will probably need to start the writeback while holding the folio
> > lock, which is currently not done in RWF_UNCACHED.
> 
> That isn't enough. submit_bio() returning isn't enough to guaranteed DMA
> to the device has happened. And until it happens, modifying the pagecache
> page means modifying the data the disk will get. The best is probably to
> transition pages to writeback state and deal with it as with any other
> requirement for stable pages.

Yes true, looking at the code, it does seem like we would also need to
depend on the stable page mechanism to ensure nobody changes the buffers
till the IO has actually finished.

I think the right way to go would be to first start with an
implementation of RWF_WRITETHOUGH and then utilize that and stable pages
to enable RWF_ATOMIC for buffered IO.

Regards,
ojaswin

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

