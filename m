Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB98EC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7768E6B0088; Fri, 28 Aug 2026 02:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7285B6B008A; Fri, 28 Aug 2026 02:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617B36B008C; Fri, 28 Aug 2026 02:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE6366B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:27:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAAA816025A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:27:39 +0000 (UTC)
X-FDA: 85149697038.21.B893DF4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5704220005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:27:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=E6R1TV3Z;
	spf=pass (imf03.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787898457;
	b=G3E0qBB435StvZmWnWcJpRiIORLls0m3RhiraOoD62FVLMnzPbr0YCO68FGd5AuEapR6pm
	aw0r3IT/hn9WaswtShNq7h63TDVRDCimRMMtcOxx+cgyFmWJx5J/zbWFrclHSUldKbpflE
	p2CwQFDmytAeweK1cn6iTOfutUdLRWg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=E6R1TV3Z;
	spf=pass (imf03.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787898457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08QJ7WX+Qx2EfeECqXNbEubqtic/1iOmC+2hSxugyAU=;
	b=Y09fm6OV05a+3OjDFGb/xccnUAB3UWyE98h3C7VMaW0beRTFo3+/c1DHtOHYP10WNwS4KA
	PJ36ZEosQ0PV0CabNybfp3YaA1LrfWHjn8XqX+4h540gmo+t/p+v6ntAKlHwpHrYu3t8z4
	IOoLCHgqfaKrv9MAl4zIDY5BM7kIwWs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S22EtN2941254;
	Fri, 28 Aug 2026 06:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=08QJ7WX+Qx2EfeECqXNbEubqtic/1i
	OmC+2hSxugyAU=; b=E6R1TV3Zh8DilQBFnv5jOdww7B7Ge8HPjU3Fuajpb5vM0F
	FNd7MwSCILkk4PJXbE12AtqfNo4pDQlvekLmv0jnYZHc8KDAjxlJ8PLwSeEbOn9P
	1Of7lARvcZukwgahmBKggQrRZkgnUZgWbP/VQGf/Ntu+vu2+fQO3L2U6SUqnd9/1
	JAKVy3oIoe4FyBH8Xxat37hGEpl06E3TIkgA761tjVm/Szzkynx8eu3TlSj6lWkG
	vspxaObPOqcD0k+4JbDAq5pdyHVp8GZhT0ckxIcdu8N56DLbn31YXbZOX047t75d
	BjX0s1+VG/N9xHdRZXKjbea5/ch3sFMFmXFbRgAg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73eradh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:27:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67S6QWnu011615;
	Fri, 28 Aug 2026 06:27:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qmxmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 06:27:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67S6RB6I44957980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Aug 2026 06:27:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D080620043;
	Fri, 28 Aug 2026 06:27:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CCB220040;
	Fri, 28 Aug 2026 06:27:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.22.178])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Aug 2026 06:27:05 +0000 (GMT)
Date: Fri, 28 Aug 2026 11:57:22 +0530
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
Subject: Re: [RFC PATCH v3 07/11] iomap: Add DSYNC support to RWF_WRITETHROUGH
Message-ID: <apEoLNmw9iNYYVqf@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <a679d79b676d3a43332aba54ba25660c9ea9e1dd.1785908600.git.ojaswin@linux.ibm.com>
 <aoMLboIzOmJzn7C0@quentin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMLboIzOmJzn7C0@quentin>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 4lPX-uCG8bHkTopq-KdpTceOIvG01eO4
X-Proofpoint-ORIG-GUID: 3XAbkb7WmxBnZS8QQwjJ2iRJXK3zB4xx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1MCBTYWx0ZWRfX7s3KbLjkSGKs
 LlZUMi2mYTLjZBHargYG8vOtxILSPzVMu2xhS2M6UwzDkpcnKT7UJKU3dP4jY+wHrmarpofmaoR
 yfboQKpiHgVX6xB76+mkaMPJokn4QzRrHWmw8unj10hixq3d2hLWlzywoTYF0nttAX3heZB0pH7
 MQk0XleUqSvnhx7FFAmuQ8Lb7tgNKZVxMe1e05fXGS9/tevoN8J61cZrt0JmEdxQ2Ef8kFMPdvR
 VWpCPaX+sEjgvNMbF4kR9eHP19/NXyUHCWUHosCnwg5DpwK6g4gNeDQgW1SqY4EdhGkGjeiG9zj
 mwU+zHKgjsMoc4PGZFXQs9txGuyue3iqrdlxcTyu1phPS9nM6+lLd27+U69o9c6zh2XT45rvOso
 gBv5f+hngo/DG6ynmMmMi5vDKF15D6CUEapt6YyS5IIti0Z7deTLTFoCPGsIQE1UTDG90RJBrej
 9N+2RPd4n8csJ7Wmatg==
X-Authority-Analysis: v=2.4 cv=QsRuG1yd c=1 sm=1 tr=0 ts=6a912a43 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=o2WM25ACUX-w9Fkcq3gA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1MCBTYWx0ZWRfX4YdHHO1JmDlc
 CYPgWudyF60oGYizpV6sSZ28PuGnIma9ckWfu6yheOVZYusq8dmVbVBh+jSJbSL8q1Mj4//FRoE
 fiFNpboHbGpy1Aa3DIL9sxatz7c+gys=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_01,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280050
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5704220005
X-Stat-Signature: 1kkrf4ps5h3xxbyf3m7woiig1788kzo8
X-Rspam-User: 
X-HE-Tag: 1787898457-58597
X-HE-Meta: U2FsdGVkX1/BTbnP3BCUTlFIkZhIj3sHTh66UBAPFx7fHq912PO3NQNHL7C+XEH2RgFSZpQrC4eHiJ8Zs03rahlxUtRbBxE/gDnt3H1VhPRcetlXbPKK4y1FNf7W1Z+G/vxJjO3tfTAUaV9vbbIlF8RNs/Qv48SYZeF8pByJeLfW2C759Zo6/Vlg8V3KFsPWGzbX34nhYdDYKDjiUNPZQ+48VrQvnEdGOI5zNpYDiN4IFvPCnq9i52J3xB5ws6rdbvBwtOAd5IITE4P08Q/Hz1zjzgsTSzMDQteS/XZLFAjSwgDqW0zaVjKcjCSYygsxt509eX42ssdUId3hxbXhKZswrn0Me0o3ncNeFtqydIVZ2O2CmbMLYEPhImkmhA/lkvlFreMn6I+wGowd8GWntNCkSYljvqsfacLw+DEQbUGuD3hlm5z4KOFPGNDntT6JvlOUL+44Vu9512j242sLop7ROBBYihtLqKsYxz8lznA+rTm5BneH0z7B3b0rOth3uxtNYKO4pIILrgFyqktOKbCiF0T//ATjCxz7f7rV2Eqlc8VZHv0aiqvtTQ3BWPQM2zNcCACpruPtqXQsyYP5PYQGxVzNtQb5GD/jkEDBr6vatbYi9qynT3e9lV2U1FuXRVCPxcZbiUHeLL9I714UwwcmjO37Z4hlgbxNnEg/FzACjPAhTkxEv3ty9YZm9wPz39z5XGmyaGmKVF2WoGAP8p/6wQ+yFhXZdFFubQhUBGoGCox4aLo4mnK5VvzyoMKRKY8r+Olv4/xm5UM+znPpHfUYK9eTDTaeCs3TJADBP6la0Lf4LxahJUx8vKOWSbnocLJ+q1Chc3q4wykM+WuxIwEWx/eFvQpoEJJxvGfh2V+ueQNLExGbOPZn2MVYfOFHVwokpzPHPdB7D5wldSLM01iOOddzZho2k0/+Rja7W/LCR5Y2ba7RkBNbTJgFDbJGx8I6yTkHp9LrE2NNHKA
 +fQU118j
 6o2t75wRGkMLUom1wVZImkaWcGXeEIe74gL4ZGIh/MtqWL1VpcV8GC7Ea8W8SGtxHO/znssVaHbR9juio0doE9RBqXCSc76uunXplk171InGnBsfPOLZ/204Tj3W2aqfI6ErzPjwdhHUp3IU84QrfVv9xgFS69Y1hQGQbuG9CUn2g1WDON/XqauwfO5oYIT5a1FZRygd+pLdNwE+irkH/WQdpo9oLjveJZ55LYVh+MbQSHs0kA2nMvI3g0B41ZGIMkBAZpArWDA9NIG+Y0l4rsY4lgBn0GzgVcovG+QhbKzxC45ANO1TKyvnS5LwR4BJs2QLnj+Ub3PgwtCf9ZNOjPHsbO4ZYGll0wX6m+WjDUVQhkwDHOmt+li5hR9P0JxP4178UlKxYlThlOUpb6meckg2gwEu46yceW7ORxC8ymtjTzhNCQauTua9YyuVNDVC1LEn9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:26:18PM +0200, Pankaj Raghav (Samsung) wrote:
> >  		return -EINVAL;
> >  
> > +	/*
> > +	 * If we realise that cache flush is necessary (eg FUA is not present
> > +	 * or we need metadata updates) then we turn off the optimization.
> > +	 */
> > +	if (wt_ctx->use_fua) {
> > +		if (iter->iomap.type != IOMAP_MAPPED ||
> > +		    (iter->iomap.flags &
> > +		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||
> 
> > +		    (bdev_write_cache(iter->iomap.bdev) &&
> > +		     !bdev_fua(iter->iomap.bdev)))
> Shouldn't this be similar to DIO code: !bdev_write_cache() || bdev_fua()
> ?
> 
> As long as bdev_fua() is supported, it does not matter if the
> bdev_write_cache is there or not right?

Hey Pankaj, sorry i somehow thought i replied to this already :/

So yeah we do keep the logic same as dio. In dio we enable FUA if:

    (!bdev_write_cache(iomap->bdev) || bdev_fua(iomap->bdev)))

and here we __disable__ if 

    (bdev_write_cache(iter->iomap.bdev) && !bdev_fua(iter->iomap.bdev)))

So its the exact inverse of the dio check.

Regards,
ojaswin

> 
> > +			wt_ctx->use_fua = false;
> > +	}
> > +
> 
> --
> Pankaj

