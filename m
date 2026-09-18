Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180EBC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 05:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC28D6B008A; Fri, 18 Sep 2026 01:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73466B008C; Fri, 18 Sep 2026 01:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BCE6B0092; Fri, 18 Sep 2026 01:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 970316B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:58:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21CCF1A0380
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:58:54 +0000 (UTC)
X-FDA: 85225829388.12.91394C6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B0AB1C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:58:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ncb7ucBQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789711131;
	b=GVtYX2K71nQ6FtS4tnNSohqO6xvOZlb5uatNIDmJqxvqm8dHQT6KgXSoY0826i0uF81hxr
	4TDdcJA2iJWDKH5yDXa5Zf6Skwj2RymHlSCMZ4RPXeMaS/WNyIFKrHhSROx6aEIPURXjV3
	keNqqBjSPX9k9C6WqO34eeZoVR2LGE8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ncb7ucBQ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789711131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkKG5eHj/nYQoAmDG+rhMWoq3O/eAaBCq9IsR6KTnK0=;
	b=2bB40EvZ0Vjfp0cbQv6A0b5U5/gZAPm1JMPmC6NAdEC1Tbwd+J/G2f1ji6iZ8nqMWx/UTc
	XBQCC5QYXERNppC9Bt5mIecUO3r1192jhjyUqoZEjuNcswC2SI0YHesw9Q0pCnzuE8TiNS
	DQ/CGMFYwXmC0AuZb+ayA1CKdkaa9tA=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I2VjZx043142;
	Fri, 18 Sep 2026 05:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OkKG5e
	Hj/nYQoAmDG+rhMWoq3O/eAaBCq9IsR6KTnK0=; b=Ncb7ucBQiJs7MT8jp9Hogw
	KABJEWlOfG/dfbLL7sZXrcFtqQHDCdSSDXBhPAMUuhs5npkTH7xSnz/q0jSWnr5c
	ZCC+Z9ZhJ2KpZ454Fn/KC2n0Cp1UhVDSe8NFhDep6X9wG98D2tZxBsJtHEJV+45S
	EjULYJaU5L4OoJZA/qL9KCw7HIyFbmDcr8Gxlufr7nBlme16tZiYsBgiSeN/5+3e
	Nn0Z96JqJXvZkkqBRVQed78H4ZgW5hfnssCzeXUxadsAKb1Eb+ftmmjqeYG8wl3A
	9m5u+yGoAqzpnXlfik8qPHri7xqtulz88Ch6zS0Mn2/FCTO1TiNWTPWug9fanXnA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx846f5r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:52:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68I2ZKuK918969;
	Fri, 18 Sep 2026 05:52:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr7genjra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:52:56 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68I5qCZX3015250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 05:52:12 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0A5E5804E;
	Fri, 18 Sep 2026 05:52:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 876455803F;
	Fri, 18 Sep 2026 05:52:41 +0000 (GMT)
Received: from [9.61.58.220] (unknown [9.61.58.220])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Sep 2026 05:52:41 +0000 (GMT)
Message-ID: <1742b0d0-fbdb-433b-b2c9-b47b5cfd7666@linux.ibm.com>
Date: Fri, 18 Sep 2026 11:22:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
 <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling
 <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, llvm@lists.linux.dev
References: <20260918041744.1526924-1-yukuai@kernel.org>
 <20260918041744.1526924-4-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260918041744.1526924-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDA3MiBTYWx0ZWRfX/teiT0wiHNSW
 JEvRLv8jYQnWWkxliGMH7Y5gxw8A38G2pBCriGrXSm3DN6Pr3l9Oia/Cs3vbs5x2dSUFWw1cfFz
 f6YEK9tOomOpksip3Jp/NjjN7rrYdt/gOI5v+6Y8AX7cViJK8cnyaAE3PjMik7w12aaXKvh6tPK
 tFBlkzqye1G3IuT9fAG8wstP9g6OAj+fQK4ugA5oL55w2miRU2d/M5YZzNY15Wjk04uncsH6aDp
 pnj11j8nfR0QxLHiscSmDcegPweYS/JObE2+bA7JB/xXyGgpQjesnbr/WvDVc+wx6dyVbrWXmva
 TRZBv+CiIDmwlROqGoPTmI8+6j49IF5vWsKy4421LSK4L8hh5RZqcbHHtqWWNbP4U/H4xAE0VIg
 qjhdgXfijXio3Cfv4RwZ0wphiapFt2dpjyauojKMPHivJdWmZuJs2lOfIk/cS3ryMpVrfiI0Gg9
 /PO92Nr18Ody/I9Qj1g==
X-Proofpoint-ORIG-GUID: IQzOuQqhULLvUviFRAhVAHKgtdnFYey7
X-Proofpoint-GUID: ZGCkVPtmRng54Q_CssYM4zmrTg3B8e93
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDA3MiBTYWx0ZWRfX7hqucrhMwMz+
 TMaoTQdDqBi4VtgFdBweWtZanWLjNVsk/ptq6fmVuMGXmra8Z54mRVbadv0oTv0nx+NSQH+0ts1
 oIkWCJgjmb268QlqzkGvSbLj1oWUnos=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aacd1ba cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=N7Slw706a9Tpp8ivUyUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180072
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B0AB1C0002
X-Stat-Signature: nksandkgxetzws7iputyubhp5izx13bf
X-HE-Tag: 1789711131-116882
X-HE-Meta: U2FsdGVkX191J/+GdDfcJrTixDimqjoW5c77JwOxkQjuhYIgk6E6KKTrtoqWT73x+rDR7G66KG/Vw3VD241vCxrg+W7Xjm5RlYtKYFACE+QaZgk685nEoLCximSZKYyKBKwGvu+OVGtWqLaT/N4npZZjqocZojz6bCdcH7e1SXqT1jas/8gt2CoOZ++p7q3NsJLWYsT6Wm9AFtU/GarsQU4yUl2SlZdjkj+Q+acsQ/Q+/XQMi0deZXziXcCwLCvVn4P3uvHFUzOe+eoNLHGe5T1lyD4d0enUeCpN2Gw5CXCeKWTuEl0X7wuDuQ7MaSCKuPGdOPDlg1fu8RglP2dwRysVAEfvQbR48rQg9pim4yahwoo9vYXygKkoOmjVHJ1elxcedVbbSMJoJ6EyD3kwI+yjDCJNGmfdKRA2Q5Q42FuEWlc3GDAf83zRLcDopB97sknVgMasFxTqmdulP1MLo8coKDGE6Sk/vwzSf1auWP4SyQkUeffAWwaVCwBQor01ffx4GMhOBVQ2Wv+NwxpxuYppMtOYWXWM9nay7QDegfKCdwInjT5OPMJFqDq9/djuNUBDMOgjPj0RiLzbt70H2qiJrfXIjoK/lL1oqp0Sm+IIP4mVFI4E7CqAwqNGre2pjeGifFjEnR5M7yxd2zZLnQ7ZhdymYqE9Qq2F2+HHe+hN3dhulNhzU9fRTiG2zakif5DqqEDkqPFmlZnpkCYd1XMcSv5PYkac6gpkorx/iS4OBOoG1MjYYT4bkIH+s68iiNKa2h8hDrGaQqybEw8TKhmhu3SZIOCEiaT6sSacb4Z8oPa3QV6hw1nFvRupkg6N4IlmxsbGQvyIinNFgZZIRHRqF85166KYE9tqFQn38/cDbFbV449ouvnue2MjuMKfHh+vZrVIi2j5ZSsq8kncQXRT0doY9nnA+pNciD13uzKH0xD2qoD1TvkUWn/yAlxRfZ6FPy/AvsJyV8j2oNi
 gox/3ZCf
 jouNp4RBQnsN29OtbIXkr1zW1J8ozNK4skPpnd1RpmmFtue4gwvbtVHfwF3evAeb62wBBKavN9d6YnQWXif1k+lIedDJwOi+4wPX6DXNlVo11ky7wJBDQb+Xp8e1ivoXWLHCjOQ+qKOZ/N12la9nGyb750/ECJ3xsubEjHnDYp/vmyeIF8pEM3h0UyxTJXEwcZeKq8gqICgSI3iklTxRo+GAlkLSdrP8vAJRsUQv/ZiaNHEetQ9b/Af+1Fg9M3aG8XGEsqfYx6Y42eHtnGCqG/mHdqxjUlC7D1KE92X/W7Y0nwHC4EEn1pvsKrUoiQMJZOtDEcAlX7JTNWjsm99vznmuI4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 9:47 AM, Yu Kuai wrote:
> From: Yu Kuai<yukuai@fygo.io>
> 
> blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
> now carry and pin the blkcg css, so punted bio lifetime no longer needs to
> be anchored by a blkg.
> 
> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
> policy is enabled, just to bounce submission from a shared kthread.  Move
> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
> punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
> are submitted directly.
> 
> This preserves the priority-inversion avoidance while preventing
> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
> policy.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

