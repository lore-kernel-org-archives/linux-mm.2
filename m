Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3262ACCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392866B008C; Fri, 16 Oct 2026 03:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3438D6B0092; Fri, 16 Oct 2026 03:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B766B0099; Fri, 16 Oct 2026 03:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E43806B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:25:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E0591402CA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:25:14 +0000 (UTC)
X-FDA: 85327653348.29.C559B36
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 06A3940002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:25:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fLD9xg59;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792135512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUjQYie+YkxgaUkmMfVVcmtbvoTR+CoU4zK0j8eDj6o=;
	b=WFdUKWseKsgOi6s3MY0LNPBx6ZUPcz5CXjxNKsRT11v4jDRxmVzbE6tdTgacHh6YK8zLkP
	tT7Z7dtHoCi+VHHBoSN/6nqgD8pMiTBY/w2KjUpjXqZwAMoZ7is/LXu2Z2BiKSM4ed7/VX
	t/qmcQFgkswAHTLhrOW+f4TGr6BaDE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792135512;
	b=nbEEfLJaSTDi4++4vOzioMes81NPwLaq4Qt3mOfbvycGQjVbzclgNaSGy2p2j4pjFZ7wQp
	8ovQ5LCuuYuvtIfruq/jpXOimHWGHdzEf2MheaW4gHYhWwQ6Pj6WUkqndEOZdnsHq/pe2Q
	FyqE45TKG+32vn85m9AefG2Uuxl2cYs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fLD9xg59;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FJjHJu575454;
	Fri, 16 Oct 2026 07:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=JUjQYie+YkxgaUkmMfVVcmtbvoTR+C
	oU4zK0j8eDj6o=; b=fLD9xg59ScuN1SuYDbNWU02qhgplPNAsZrchSo6AMFgJ23
	G0BO2N3XKrx6UEo5aOIXy7BN0nwwUZR/IqT0Ov82UEJcryNLdjivODsqepgMwmo3
	OgIYK9ywvCMt+1Gswi4UTYKv4SCrqxT8ycPjiNvgG6lJVTzbSVLu3nTw3w6WZ2Rb
	6m1NgmgY3fqPAl6T18Aq4UiqtPy59/u0U73/1eVe5z2mq6vZ/WzcPc1czp6tiAzl
	6aI7uWmfIkYqne5rYcOhnWzJ4RzdHcDMys9NyjQFW99MvpD17dobAgzS3K+mxeO7
	I9wJTZT0wT5wNPyV6g9dvjtAE1qnKpznfwiRXVNQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7e1wna7m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:24:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69G5sWmW2057780;
	Fri, 16 Oct 2026 07:24:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hawqwutgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:24:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69G7Orgk38994428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 07:24:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 965182004E;
	Fri, 16 Oct 2026 07:24:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A51A20040;
	Fri, 16 Oct 2026 07:24:48 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.31.170])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 16 Oct 2026 07:24:47 +0000 (GMT)
Date: Fri, 16 Oct 2026 12:55:32 +0530
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: Re: [RFC PATCH v4 12/12] iomap: Handle deadlock due to repeating
 folios in RWF_WRITETHROUGH
Message-ID: <atHRbMgzArepXTsd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <5159efdec832e8179e9f689a9292f9bf47d9a0fa.1790596383.git.ojaswin@linux.ibm.com>
 <as3t7j3P3mQhsr7p@quentin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as3t7j3P3mQhsr7p@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX8Ez8pm9LkYhN
 PJeJD7TtDpE1DeAUcnCwktcg9qVjLn1PFO6E2wBrEFYDKUN+eEC78KzwlpY4cf5HzLNtIIiEuoS
 TSN2wNgSt+8JbLZ3C20J2pityIkNaEY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyOCBTYWx0ZWRfX8xgohQ+J1SL8
 bHMhqrjoRcrywkI9x2RpnHyc0cfcRJlGaHcqoQ7x40AemkQU+CKYvS9xlnNHCR7Oc3UrZ4xLVk7
 QVu8PHA2ztJtyjuNcwVV36wLT5mTnmlABfUru23IodDgoqrqKjw91zjGUT7vaN9tSm7XfhYhXsK
 EjVBdMWzlea/oc72KeauQH684KRzmEVzA+n5yacjkmjW116MAwwDZPhz3ynVz/8HZ7CrEZ7cXfy
 j5q5I/OzeLZg9XjlNN9umH4RIVFCW53MljIBZvuvUpo5n4e28Wr2VtWqmweYJLvY63+8pLEtne2
 oT7WQfkKi4/ncsY21PnNzKnzCED9S5uwAdDc5fLpLHIWjh5zuQW9ozv6sMSpmJhZPA/GphZdXPq
 KWDeBfU2uUKFRB9ASXNgN7Qy8qPbKbKRHwQqJmE3gWgLZbPSorJ6ushdLwbdvzMziVBqm2tE0u3
 jxfHN9Wx8xnOGtuRcTA==
X-Authority-Analysis: v=2.4 cv=E6pYNqdl c=1 sm=1 tr=0 ts=6ad1d148 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=UyTkRMcuAzhAlBp-MlIA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: PTvjpi1rn2w4e-zcFJbRgr9JRBvAlwgp
X-Proofpoint-GUID: znIlKs1_pN1Dw6ZUpe9laAJQCsODY-SP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160028
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06A3940002
X-Stat-Signature: bwoz9tyrriormi6tumrjmgy8z5iykwtf
X-HE-Tag: 1792135511-142672
X-HE-Meta: U2FsdGVkX1//XGgNst3Ke9WgK24PNEXuQh0AmZlu8vy3H/uQW/odAcSGxwa5m3iOZV0KV3EmyzvWk+1GB3fPSi1DehyxXxEviBzFUeG6Xyk6qqFabfoKufSlS36Wpmy92uzea64J86RjTNX+ruRzy4+9uEoS24GWOOtdbCFeueqd2wKh5UkLiag5PZPaM/B3gmc0SKKD0wVHlIgXbtmjxZOerteBaa5U6ttU5ELTDOFaRsTZaoe26zB/J2qexca1asHY198EYUwbFVf5EpcZhbdFrFtb6ulVzgp8ajYjSnHpR9XoZ1HhQR9Pl2Y88dTbUL+kt+Y9Cnb9qEzZCwHYrghcWuW6HPjm9uDGRe0t4nigP8s2wDU3V7fozM4oTrztyAImb+MrlNpC1kWR728SrV5r6ZeFVo+BKRgB7YyKbRc4t0hlh869MNAdJaHChb/v+M02IFp1zkQxH04fUT7ZpmrkFfZl4IYVxwKsuEA8LxvASGGN4yYB4RTW7T/X+Mvzi2XEwh0Rn2rXJRk5IWosWq1j+s2JkbQnk2hb5FGpZ+T0uAMo6GN59OyZO44UHAMt/KMF4clFpwnjxhe64WQqypKCRE2FsuA3Q1IN82h807FX+lsS0MISvIgJp8vaFPS981wog0GVeyalDxfeLz/5TEPmPrWvB0lfjEjjXjmS/el7I7qzPIBbaPQSv1sTFYwZEyvl/f0dW544uqUb3NI8LcUKfoBSXacnvk9M2E8JqUaDTkuZt0jlbVnrpi1JQtzlIbrbuwwfKghSPndwqcnx35YC7YMNEY2iM4/kCOMTJ3Hu/svwsB7ZpJD3/mF1CAtxi3GrLK6Exg5en7uvEjMoCI4FZhMCkXm1QV4CW2FxfI4CsrLP4ts+k6lw3gRZJxFm/6zJ0l51l/a4KVg+nTALTBfT2TJaLiUPY/el82ntC8wrqRtmbC9jJz4GFzzBx2wYHUdyAVU3dHZEW4pdwfp
 gqp6TyK/
 9Kem3fdR6XjJ3NP4cTX5+Iz8mC2agduYsOOW6qmmzO78/imPmsr8dqO+2/hXITMpyhomF5v52B9+AeGuDi/IsJcsc9UDWuDtIocdR3+FfzHvlnXMYwfcJfHd9fzV/XEof6M+hHayk5LzKy3LIzXYewNw+uWz+nF8RY9yewP3Nxc/8Vb5qs2jsw42Z5Xjc4Jg4FiFofSYTFOMlz/a9dOzv0aYObnfaaceXtGCsEgXG8uDOT+fklpeavb6p1vD4tMX1NyAlNDQ+LAldHL9L4Z9QvZMNsDvaDc6CyDER6H3Rr7ZQYvmobx0QZBmB1CcsWEseHpYGekl1Gyy71GGcvhrOrxlvYGQAdwLqaK5n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:40:32AM +0200, Pankaj Raghav (Samsung) wrote:
> On Mon, Sep 28, 2026 at 05:33:13PM +0530, Ojaswin Mujoo wrote:
> > In iomap_writethrough_iter() we might encounter repeating folios across
> > multiple iterations. Repeating folios can occur if, example,
> > copy_folio_from_iter_atomic() does a short copy due to userspace pages
> > not faulted in. This is an issue because a previous loop might have
> > started writeback on them but not yet issued the IO. In the next
> > iteration trying to get the same folio with FGP_STABLE will result in a
> > deadlock. Since repeating folios will always be encountered back to
> > back, we can just use a simple cur != prev check to detect them.
> > 
> > Use this to avoid waiting for writeback or starting writeback on folios
> > we have already processed. Note that in ->endio() we might end up
> > calling folio_end_writethrough() twice on the same folio which can cause
> > issues with folio_xor_flags_has_waiters(). For simplicity, just change
> > the folio_xor_flags_has_waiters() call to an idempotent variant.
> 
> Is this an outdated comment?

Yes, thanks. I'll change this. We just use the folio_end_writethrough()
now.
> 
> > 
> > Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
> 
> Thanks for fixing it. I think I was able to trigger this in a VM with
> limited memory where the chances of short copy is probably higher. The
> fixes makes sense to me.
> 
> I will run some tests this week and report back if there is an issue.
> 
> --
> Pankaj

