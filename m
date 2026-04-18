Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7003F8DFFF
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 07:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4676B019F; Sat, 18 Apr 2026 03:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D645A6B01A0; Sat, 18 Apr 2026 03:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54096B01A1; Sat, 18 Apr 2026 03:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3C1C6B019F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 03:33:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E9B51B7F51
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:33:42 +0000 (UTC)
X-FDA: 84670861884.21.4462E91
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6185C0008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:33:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Md4TUMmJ;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776497620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+8x3UTkmDSK/0XW5zoJPfvCfQVWX7N6GA0ekPrt54Q=;
	b=6Ix84UzJOPxguUyRofMD+J0uJWsYqsLwmN/XRet3+5Jezbca8dBrUGY+SCD9wh1GAPB9Ri
	xoCgLupRCOc+ocniD/jxMDyKXn4Zvd1VL/KRsorQOD0s1zWHjdJ59bkoUf992AvpFNqorE
	ZUhctYIeX98ByN86VMlrM7cZzom6bQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776497620; a=rsa-sha256;
	cv=none;
	b=7oCteXPqGaOzgia+Zt8OlKPgEvtLqux6lhKqLdG+7V66AnLF07RWY3hnZVuyzgdeB6EbzO
	gEqEWxKzYS6xXgXqMfJpgp7uJVnLV+hm1H9hBd3GymLCMXujM7CbNBjYFBpK8oIK6P0ET9
	H6LtLmOjCWZtrJQ/0Ur8gKkckCINK2Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Md4TUMmJ;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63I41cPM2687272;
	Sat, 18 Apr 2026 07:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=J+8x3UTkmDSK/0XW5zoJPfvCfQVWX7
	N6GA0ekPrt54Q=; b=Md4TUMmJX8N0cv1cJnValWJUk37E2iBp8okN3vEs39GUvm
	/41zIqys+FbhiwUAFWvvjXAo+F+5HYyU4n46zThnuAyGgni5M+95bJexnc0nzW1A
	GDB/WcN8lV+bBcOCnkGpAP4QKlcOudzFXYN9x35Gx+MXpyxOzXt3+QoNn9s2vIZn
	20DrrMQtkVhJOyUHQRzAB23+B/aDtfw42Z/xLUl46EoPD6JQZ1Fer/IDa7PZHYeb
	9iU4JL2CnHlnvBClks2ltjBCpDPH2FZ8KD1Chp5KP6kkj5J129LtVwFCPV3Hly1f
	A/xTdMQyRULAKCH9+mdzdGvbse4DlgMMhISXqing==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2j68ewf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:33:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63I75PDm028404;
	Sat, 18 Apr 2026 07:33:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dm22k0h3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 07:33:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63I7XQwT13762958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Apr 2026 07:33:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A815220040;
	Sat, 18 Apr 2026 07:33:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD8CC20043;
	Sat, 18 Apr 2026 07:33:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.145])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 18 Apr 2026 07:33:22 +0000 (GMT)
Date: Sat, 18 Apr 2026 13:03:00 +0530
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
Message-ID: <aeMzrKNO7SPgjLyc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <2dmo4my5rml4ymfuw5afc2fnbcxn2l3w3bz2boj4eevognilni@vgy4vwlikqx7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dmo4my5rml4ymfuw5afc2fnbcxn2l3w3bz2boj4eevognilni@vgy4vwlikqx7>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE4MDA2NiBTYWx0ZWRfX/TvXlMxHfyfq
 mjqgI2sJREm5linMAn5otpl2Cp8gk5T3mnsNhQWfbd0jC6p30ZEMwGzcpq/bXaKUNLp4zcxn4IR
 VblcCW2ZmaCsMmMEKGQzE0obGxltOZpPzAoI92G4CCXsbmZBvZLu3O1YzRW9NqBR+bNQPu6W8wf
 Rs0iWhSDx6ObytfUPqITj+kbwP+PvlCf8E2b+Sd78+/kC0B0R9fdf62OSAm2LpjQWVKci9liaUJ
 sBQXEGgMa63ruur59OP+nFCBsdxHbnMPf//9WDf8WJqOUJkaOp0XXZdG7Q6weq+5OcgMg5HUNGp
 LiftT+ii/XwXjQS1+U2AGw5Mnd7oyNRtYuyTgy1awNGOd8N3G/b0YvSf+NpI2s9pxobazU71RJ2
 FayHYkh/EjyAR6hbBmICqsjVLRJTfPGGPsNc4ruaAJsBJilsXq/zVCXwEFy8RGEeB4Hc8go9iuN
 q7RgqGJNqgtrb0MIbTw==
X-Proofpoint-GUID: lZmppBzJlcsLpXL5MluOHtnYPsOuBekb
X-Authority-Analysis: v=2.4 cv=SOJykuvH c=1 sm=1 tr=0 ts=69e333ca cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=J4mrUdnwTHBwwN0GybQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: AlFrBinGigvIOFIpwWjlosqGmBosXcyT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-18_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604180066
X-Stat-Signature: eiidkyijcjcx5aa3uznn9btj1fh5ohiz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6185C0008
X-Rspam-User: 
X-HE-Tag: 1776497619-234121
X-HE-Meta: U2FsdGVkX1+MVn8HsAprN8CGexOYYER8m4B2W6Febc6dksxUYH8MvjFnqxYL0RNPixfEILOy/noTeGhYXtcOzg/8VkXlm10bptsQgz2xiSYUo1VfXmAlNqNOvVWdtMa3gqhCQmxXdOFGd5X5vmdC/1NBAVLHUp9Fty0zLjHr7x22LFAmSOnvP4KrDckJ9jBdxLbBcHi7j7oWg68081IY3XBlUyDybjjCEnkmYBY5uyz599zoWPKHbu6wtz7/xICdyQtUkoqI6zePfNr66GIzM/kp4NnX9X4RNXm+j060OxGGvyN0AuIebmX5V7DSx4i2rJSnD4uG6qRVD/qRnQrKeG3DSbK2/vEgqTDvjh+dHHvAy6MZhhnxlW+AHo+b1S2J7Ho/FRiO1nzZOT2PM6qiUeGZ7b/79cV4UiQ7kmYKbWlIRWRMT3cWc4bpcdQQdoRvB4a78GC5gnZSGtrDfv65Z979j1CCnBls93Oe4YU2sQpbKqUMxTaaUh/IwZrIwboA5dPsIx+FRv+6I3hvPuhpe/OweR2esBluBncvNikgUKSSvthNt0ixR0j54qJwyo9gPUwlWapvs7Fq5GiXoRHGK7rRVmy2mWprFdT+Yd/Uj8qM9eSbq3na9f9Ov5fGx8UwqhL4dl+QrL7G2zE5i2syVhMiPG/bQ0E0tQRUT5yJIo046nZ1i6GQqz9kv4dRGM1XiWkt+Kc4ui4dO3rpWmZnkM/A37SWvTJRszM89v89h6/RnY5Ptf0mKa4j0T3I4/ewzNUY9VDVOPWJw3peXpiPbqY1hoxKdc9jE8gy4M6gGxzj8P8/zc1ngl1jl0LbuZC9wYLJrq3yV0HepmTIxtA7FRasXhWGTNkz0l6dSnNAewqa4amVSPYiRKmcnEIN3ls403sm/ytQSC3HCfcQXOvDJdWD3zquqUY36bdgYJijTg5xhvm5/6X2M0rkG2JrdFv5EGlYqIXa75pVP+98eXU
 EOXmJ+gC
 64J9dlik54ZcEy7CKXkDb8TKFoh3UkkG46RUfA5PNioo4ZjdWSoXpOBbogSVRljqcPiCslfS1fosSgJ7DlkhrhWiUmesTzQ+qAGksVNKayleE53LbReu3MQAJ3UWIvJ/WNiRRkp2W0YNZuVnUlYs+qsi1549ZNGYFrlPaxn6qY+WMVBdli720oQruGTT+3IenoBCWFWj196nMDHfq7tc/rq6WrWCW0SgCbGDMU3qqKCmYmpExj7ji2e4Jd+g1kp57i3f4aDKI9gYWWa6rf0Eg/c+uAlc+381URnvDG9Cy/e/9hA3YPZqSSHY9eZfVEzlcmVvGChNMswIAztT+xHa2u2zpZ1qvS8TmBwL2lAUa6sgYgnvLnIWxm7h+KAOo+hzQlMvp8CJTxGG7rTpnt+oclMY7bAkXB/WPdNXAEQfcoTHmh9S2BKXAMpzczA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 06:13:31AM +0200, Pankaj Raghav (Samsung) wrote:
> <snip>
> >   3.3. Wait for any current writeback to complete and then call
> >        folio_mkclean() to prevent mmap writes from changing it.
> >   3.4. Start writeback on the folio
> <snip>
> > +
> > +/**
> > + * iomap_writethrough_begin - prepare the various structures for writethrough
> > + * @folio: folio to prepare for writethrough
> > + * @off: offset of write within folio
> > + * @len: len of write within folio
> > + *
> > + * This function does the major preparation work needed before starting the
> > + * writethrough. The main task is to prepare folio for writeththrough by blocking
> > + * mmap writes and setting writeback on it. Further, we must clear the write range
> > + * to non-dirty. If this results in the complete folio becoming non-dirty, then we
> > + * need to clear the master dirty bit.
> > + */
> > +static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
> > +					     size_t len)
> > +{
> > +	bool fully_written;
> > +	u64 zero = 0;
> > +
> > +	if (folio_test_writeback(folio))
> > +		folio_wait_writeback(folio);
> > +
> > +	if (folio_mkclean(folio))
> > +		folio_mark_dirty(folio);
> > +
> > +	/*
> > +	 * We might either write through the complete folio or a partial folio
> > +	 * writethrough might result in all blocks becoming non-dirty, so we need to
> > +	 * check and mark the folio clean if that is the case.
> > +	 */
> > +	fully_written = (off == 0 && len == folio_size(folio));
> > +	iomap_clear_range_dirty(folio, off, len);
> > +	if (fully_written ||
> > +	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> > +		folio_clear_dirty_for_writethrough(folio);
> 
> I get the point where you want to prevent mmap writes before the current
> writeback completes. It is not very obvious to me why folio_mkclean
> and folio_mark_dirty had to be moved out and then we call the
> folio_clear_dirty_for_writethrough wrapper. Anyway those calls are made
> after we do folio_wait_writeback right? 
> Is to cover the cases where we do partial write in which case we don't
> end up calling folio_clear_dirty_for_io? If that is the case, then a small
> comment on top of folio_mkclean would make it a bit more clear.

Hey Pankaj,

Yes you are right, we need to call folio_wait_writeback() and mkclean()
for partial or complete writes. However, clearing of foliodirty bit and
accounting shall only be done when the complete folio becomes clean, and
hence we call folio_clear_dirty_for_writethrough() only for those cases.

I will add a more clear comment for this in v3.

Thanks,
Ojaswin

> 
> --
> Pankaj

