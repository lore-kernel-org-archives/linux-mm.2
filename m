Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20178CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 07:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157376B0005; Wed, 17 Jun 2026 03:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F456B0088; Wed, 17 Jun 2026 03:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CA66B008A; Wed, 17 Jun 2026 03:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28C96B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:09:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DFD8140384
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:09:54 +0000 (UTC)
X-FDA: 84888529908.12.D058461
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5B11C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:09:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Fgn61NTz;
	spf=pass (imf10.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781680192;
	b=6ent3tK70ggTdVn6tMHSl5SNqM0m5rX9AtBpDhI/Ek3P99OTUpCGa2nU8ggkY7z7ReUzSl
	R6cGwRbzxCsiz1geidsRsNhVf54CT9e91hc053fxEMBZYVktCERKasPntlwE+BkVn1ZcXl
	y50X+gRmUDRNjFiApI3/hnTfgReqfRA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Fgn61NTz;
	spf=pass (imf10.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781680192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYe48FXtGS7x+UkZI1CFOAhBXOK6xAri4I08muqQyk0=;
	b=7SK5sxe50PmZ1Kfg9+sfJJ6Mg9RPLVm3J5pLPozmFbmWFl56HpkaA4xSHHpoQpCIfAPkuK
	zQkLnO8/C+g3WS/E9UadgOxHJTIsZvb8ayQ41e9NMFVcTA92fjhisrhdSs/FXpJwqaid3n
	Mt+hBrOfEAOm+8Lm4CYGgsuIJoTp6k4=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GLn4Rr2895326;
	Wed, 17 Jun 2026 07:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XYe48FXtGS7x+UkZI1CFOAhBXOK6xA
	ri4I08muqQyk0=; b=Fgn61NTz6UUL7y3O0pToliAEkaK+Tawvq9A+fnWT7HjxiO
	rX9MyNOzpRh0Pz1j9RUyheov4WluyBTMf4yxOyckmpiX90ISUyQQYx/j+KBFdSKC
	GU8/zmtcYWiDxwjtyxJi5QVf/jXK50AqaE8nsvQG78UV01riwXukz97SR7/aGS/S
	q698Q2yHMCyk1L2mOVeHOynymPpKl98igr+DLQOqUj2WNtCEj0z0hXTD4YOAVyL4
	54fAVn5rDleGOjIkeCRTxa/NFmkzBmB2ISUKHCYkXMdzw8kReNUgUo9oebIXwsJD
	mnGzdGKsQcDVIP0L9dkIEtxiAS1FVgvH7tQHxeOQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4euequ1p3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 07:09:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65H74d7S032425;
	Wed, 17 Jun 2026 07:09:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eudvaa06y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 07:09:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65H79bFs49414440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 07:09:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1233020040;
	Wed, 17 Jun 2026 07:09:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AED1620043;
	Wed, 17 Jun 2026 07:09:31 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.28.216])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Jun 2026 07:09:31 +0000 (GMT)
Date: Wed, 17 Jun 2026 12:39:28 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <ajJIKK-pNudXtpMS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDA2MiBTYWx0ZWRfX/7m7W/uw9PI1
 OVmW8NGg0/6VrzlRHWamFIww74OfS1DqI47YRP4npQ4VC8KWo+NNoPXx3XSWVltqbOwK5IY12hp
 12oijk52KC/4cn0497JXiAJLE7HA5R4=
X-Proofpoint-ORIG-GUID: FTv06Lx3gRkmq5lUbvea8RPEfx3p8Qen
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDA2MiBTYWx0ZWRfX49nhjzbA6mOJ
 o7wu2aMC+fQoDiGqfeEx5JBByLXcve3v8I++zv5fLxZ+MEWyTmkp1N2NL/gEKpe0+BW4bsrS1/e
 /zGdhkOcMU6K1ehuyyh3MINKjEt7o/9Jpifs9M2U8bY7w2l5ZQgcjACJGw8jvV4BEqx/gaZ7KaA
 cKAP/PPvwArZq965Wlsead16iVzqsjQUmOx/hxjjv6LiNVJH9HiqNhDgMDyZ5tsFGu9prNFKUvx
 1+8HwsAglwjQYacHQC/lZwT63x5IBpB0HoWZxDjxofVIGjO+wrJofwm59fBKUEn+Yu4btyS4my8
 ZbaMgRIHPbQJYWxpeRVRdtkPO2h6hXqMTFUWTKBSE0rRR8w5xYfnYslWJhVGMM3aRjj8Zy3Tu9T
 Qm/0p0TKRszc/AnVMxEZ+d6qiBRM2A0IY4PNaddoa8U5fTgtf8zn46qj9z9U7JBQ+DvmpK0GuD8
 NkrQfhIk577on62TPjA==
X-Proofpoint-GUID: IFVLhdqCq6mqL5VWJ-Ne6GKnwYBxvYdT
X-Authority-Analysis: v=2.4 cv=L9gtheT8 c=1 sm=1 tr=0 ts=6a324834 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=zrfNUkBl4axGHCdo8dAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_05,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170062
X-Rspamd-Queue-Id: C5B11C0002
X-Stat-Signature: 87bhth4cyrai17aqj3rw9qfgreq76y5y
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781680191-501993
X-HE-Meta: U2FsdGVkX1/yyyMkEiGvMFxpQ1ClBoTX+wXqb7hkoyKOz/oH7cSztM0fcVkRjfob653ttvJmTTda2QQy5lUpiSC88FMLVRhV95Hw/0Uek+oFqCUp7gjNMaHSfShbIiPfvaYJfJ/jAnpP0L9eiN1cFoWgU9MXB6pO/uDmmIKGIb3VrEDVkrWwghftgqABYd1TmRfPSix+SiO/3rErW9ikP3kCKzGckdv2ItfkBjvuXOtOhhE4vPAfcpXQ0zKa/l/JNNUlyMwdhNInnjAMUjxDSWgALYYaiYHtvnRFlT4H69gh2SJgX8x74x4l9ZJjHwYzQZr52SQSMaUzPP46ZT0az9DADo1NdXPqUURaujXimXJu6LjPJHhnajQ04SAKyMVjcfFXsQWGocigH5bCPBpEvLfDhTIcMW/Dkzgxny6VIrRc+k401VRBEi+T4CjAYrVjCgGLHBCZJPbcYyisOiTVYKwRAj3Y4QYZdtZPnFUbHiUtWxdpkuMVGZIy5xS0UVH7paUQNp6d2SYrUmXY1HfNWlsIavb4aJoRqJcj/Itax6VjIzT2wMunfBv/wFJ8NBcD8EJb++l7GTP12x5BW8U2POCOnONSjQ31ECu96PiMGk86gr5pIq4hR+CUVdoZhr+aHcqJ9+p6yMIm9pmvgQdcQ5rqyH0Gg0gu1Vu89njGUHrLrbaJRLgnGpBjoaWfNXRDzvY43sDX6oWhst6qt4YrO403cXwHmY1a5GsdM6QOsqV5qSzyJwMAwoUHgq8LGGrLf/Mfgc3L2P+RcqoPol6TcsX7RZvb4aLO4K3sI/YD98DPHf1vMVYOPegPtq+Z9cloymRny+CRIDUvpMBltkezIFMgJVOH8cgbU3/j8YApGCEaVFGczpY9EeVOlEr+MaHq7BNUEryqH3jJnblNfREuynfeTyRktAL5CNeDFR5/pah+bcSPAIDIke6CZxatFcPsqeQhMnjzVEL9mtxm9vL
 Zc/OmABX
 PEZcsYEEyyXiK2EYRsaqUjhsRjYzy+d+yOhJkhNforME++WX25eRNFGw6C9Yq0ilTCyhxXDnaPfty4gyUGNjjLBguqee6O8n/qocV1MBmhmnbs2SKP0ak/u7wu2QyYYNF7pvg9v5oVfCVgLTe9MOV+O1EPI/zBmdFrHmpwSCiUH1g0j8EWyr5S7AMiRctCrYPw38xQ/7D7srNFzM1qXCYvAMjwCWvXZMaci2rz5T+H57G/ggIT/aMy0cNZ7eq+95UIMAxhBVItp0YvalRiNd93FgM320W4KUTIFvTaOK/F9XrJbNqYnKBWfw1GseNJK/9Ng2npgogrlXs27BHMEn51KSlxvFd0bqWngGkrdHICYilaR4SLGc28/kMBXia7qIphiyYnwBCg0NHNPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 03:57:21PM +0200, Daniel Gomez wrote:
> On 01/06/2026 18.49, Ojaswin Mujoo wrote:
> > On Wed, May 13, 2026 at 11:14:21AM +0530, Ojaswin Mujoo wrote:
> >> On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
> >>> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > index 720bca83..1c76634b 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -2077,16 +2077,34 @@ test_dontcache_io(void)
> >         return 1;
> >  }
> > 
> > +/*
> > + * Use a temporary file to test RWF_WRITETHROUGH so as to not modify the
> > + * original. This is so that fsx expected contents and the actual contents
> > + * of the original file don't go out of sync
> > + */
> >  int
> >  test_writethrough_io(void)
> >  {
> >         char buf[4096];
> > +       char tmpname[PATH_MAX];
> > +       int tmp_fd;
> >         struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
> >         int ret, e;
> > 
> > +       snprintf(tmpname, sizeof(tmpname), "%s.fsx.XXXXXX", fname);
> > +
> > +       tmp_fd = mkstemp(tmpname);
> > +       if (fd < 0) {
> > +               perror("test_writethrough_io: mkstemp() failed\n");
> > +               exit(132);
> > +       }
> > +
> >         memset(buf, '\0', sizeof(buf));
> > -       ret = pwritev2(fd, &iov, 1, 0, RWF_WRITETHROUGH);
> > +       ret = pwritev2(tmp_fd, &iov, 1, 0, RWF_WRITETHROUGH);
> >         e = ret < 0 ? errno : 0;
> > +
> > +       close(tmp_fd);
> > +
> >         if (e == EOPNOTSUPP) {
> >                 if (!quiet)
> >                         fprintf(stderr,
> > 
> 
> 
> I think this is missing:
> 
> @@ -2158,12 +2175,6 @@ test_writethrough_io(void)
>                 return 0;
>         }
> 
> -       if (ftruncate(fd, file_size) != 0) {
> -               perror("test_writethrough_io: failed to ftruncate to 0\n");
> -               exit(132);
> -       }
> -
> -
> 
> The fix works for me after a stress loop test on generic/457.

Awesome! and yes since we use a different file now, we can remove the
ftruncate() call.

> 
> > 
> > Im unable to replicate the 415 failure, but this one is strange because it
> > doesn't involve any writethrough IO. In you previous runs have you seen
> > this be flaky?
> 
> I couldn't confirm back then, so I think we can ignore it. Also, unrelated.

Okay.

> 
> > 
> > Admittedly, I've not yet started thorough testing since this is in early
> > RFC and the design is still getting finalized but I appriciate the help
> > in testing this.
> 
> 
> No problem. IMHO, testing makes a design more robust, once the path is
> agreed on. That said, do you think the path needs changing? Reading LWN
> and the patch series threads, I don't see any blocker. You can cc me for
> the next iteration and I'll follow up with more testing.

Yes definitely and really appreciate your help in testing this. As for
the design, the current design suffer when many writers are writing to
the same file, because the inode lock critical section is increased. So
I'm trying out a few optimizations that will lead to some non-trivial
design changes (like deferring the IO to outside the inode lock). 

I'm in process of preparing and benchmarking the new design and would
hopefully post it soon. I'll keep you in loop, thanks.

Regards,
ojaswin

