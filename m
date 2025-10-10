Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2429CCAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818418E0015; Fri, 10 Oct 2025 04:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8E78E0002; Fri, 10 Oct 2025 04:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEFA8E0015; Fri, 10 Oct 2025 04:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5850E8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:24:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00DAB85804
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:24:32 +0000 (UTC)
X-FDA: 83981517984.13.B0B84EB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC4E31A0007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:24:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e0ChkW9A;
	spf=pass (imf19.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760084670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qavWsGO2ICGhByK2Q9LHVjUOlLmEB0dfk2oRjmCWkh0=;
	b=Cp4jVExeMDSPU6296zoSkm/ed5RcXSOKozC/c3M2TDWRON7xCD4sinB9j3FhR1vahbq8Hr
	MgYwslaCS138H8wSkE0yvx9/CK32Lw0ztCxcjON9uBvHmda2HKByypC+5tl7p9mXCc3b05
	HOW8PjDJoyR1Iq0/dPspK5Z/jW6uw/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760084670; a=rsa-sha256;
	cv=none;
	b=sVvTK0urIrBbFCstj/SoV4HfwDs0rItWNqWpwEfYOEbm2azlj9IDfTlui1EchLd5CT7k3B
	y7nefF9ml5fpjLBGiOSotI1pR3FYv4Vks1OL2md20k5ZIbF4hRig+lzKooJIST6NzQxkJY
	AWjaK797h/fjPZ14uV5hMXHsNLtSAaE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=e0ChkW9A;
	spf=pass (imf19.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 599N0tI4014358;
	Fri, 10 Oct 2025 08:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qavWsGO2ICGhByK2Q9LHVjUOlLmEB0
	dfk2oRjmCWkh0=; b=e0ChkW9A2wg9ITC4/lyvYxZY8/cv+Qs9niFzjHO95XOK5w
	Nt7SXjZdLzy1LR3XqihlaYsiyRNUm4m2R+p534MUSKePSBL0Vp7OghTVRcs6lxLm
	mBxkO12PbK0OZDhqt9n8Z1AZYySh4oOqHHkAhQOzGp/par8++Oa90VYTf46Fye8l
	SgJ4fJpb5A6ZPm6WuE2JsMZx/t3wuskotJWJ7fifXIDLC+RPIN7CCBr+JH0J8mGW
	rFseuLMHqkoJ4knzzfJIKJ3xAPHw2hlk9pIi8VdykJgRYq6LuIvP1IOcX5wqZU77
	DcXUPPPMi69Wt58cG6sRUCb8WpjpFAZLlvs7StRg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84semr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:24:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A83mOS022785;
	Fri, 10 Oct 2025 08:24:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv8vgxcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:24:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A8OOhu55706096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:24:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8FB92009B;
	Fri, 10 Oct 2025 08:24:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70C1F2009A;
	Fri, 10 Oct 2025 08:24:24 +0000 (GMT)
Received: from osiris (unknown [9.87.154.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 10 Oct 2025 08:24:24 +0000 (GMT)
Date: Fri, 10 Oct 2025 10:24:22 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v2 0/4] Support dynamic (de)configuration of memory
Message-ID: <20251010082422.9132Ab1-hca@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HKPO14tv c=1 sm=1 tr=0 ts=68e8c2bd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=UwsUwdPkb3g6lyiBZaAA:9 a=CjuIK1q_8ugA:10
 a=HhbK4dLum7pmb74im6QT:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=pHzHmUro8NiASowvMSCR:22
 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-GUID: 9oZHytQRScHbm5AyVxGfRyjZpTAspd4x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX0YvvAOYC2Pqg
 9MCA4tD7XrwXlehV0PArgZ8JR41dSSoWNYzxnHLmmyPnS2awJh0O4s3KENFDz0lYgqwfP+2Xzl+
 Nzt31t2COkpg9Hq6QxOt/U7sdr83L28ocD2oJintflT2sApb8yXAl4KyfxHeql5aShx1Xrx4Kjh
 664YB2ss4ySci+HQC9Q/xJMWNy1idO8oGoV3bj5XPRGb5D0fxd7QXvEZgFkdjlCjjSfR5q1KMW9
 uvl+HvYII6Fw+aUpSB0HEsyNLa27MW9wfvft3yjUEW00Ew1LeE2BkXXi+SXHBFeUGuupt1n8jTW
 JSVaaG5v0b8WSDsr42L/VYAJJtQ+frSVWA4U8USlqHES7oT4sRnYhMHmny1aex87vIZr1OISmP5
 a480eigGHDEZILKrgQHNYoJfo1w7cA==
X-Proofpoint-ORIG-GUID: 9oZHytQRScHbm5AyVxGfRyjZpTAspd4x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Rspamd-Server: rspam05
X-Stat-Signature: zf5qpq9k5ddodq1c3545zf65pnkks9io
X-Rspam-User: 
X-Rspamd-Queue-Id: BC4E31A0007
X-HE-Tag: 1760084670-38126
X-HE-Meta: U2FsdGVkX18n6DUMq4+oTjyEjTme7m1+f452I6EhJQLzKWME3w0r1CQxWswUeCLXotkDxxAmw9nRpnsfUUaur4GoZfo2njHY7+nME5ObnXaY8XiK/IiNZM4KVDVdkNyynQsqSVE3HuLfG6FzyyrGWlF28JjmOONO/8r46wx3/yfWOHN0aKHqeZLos9xhpLAB+fhHCo3CUSVANY5w3WgVysocMq7tWpe0SncYcp0WYsQGVyt19EmshArQ9On89d4MSdOFk2lj/MOWyqexSlmNLlxoMOZSnlJzhLFqmm/ZUIOahb0TJmxtsbDuKMKr51zX7Diuxp0wEAUwglQ28Xh90uj4Lkjcg9NA+9OJbSpO0Nyies4Slr57TwoXw7o2sz9dbUTEnYKeUn205T7LRww7tQwkB3DbioWzfhU8fAV3SFXlGvUcUvqnqdhEp4g4arFJ04SpKPRqx1EOogZ4/1DQbjjyecxJXhxhyPZ1VqMqK90MNJrei4YHCebEtKfugbOhwGUJRVn0zBeFeS3lM4nS8mUgG7A59FsP/ncSHjINNuJmzI8loZAyK4mjKm95L1h1bRBc0WMnTwnR7ukvZ2iBwL9npg8RLtIz7zQNK2vVQKOnv+00WWayHOoM4bDIT+iFYEpo9sZJNbVjT+8AX9zXQ5eVTQvmiuVHDhgh/TZ7jI2XRWOQhiUoHkmYKAAimDLG2AZpof+/saTPBuE+U31ckr4z7PcmiFeqObuA+32sX7nm3JibOtcJj3TRpu0O2bhLF8BRcz8Ts9Uos20lGlYZfItVrBaLuqqfFFgeR/0hLpkdww7Lq/1x5ScPSO7HDJE2oTYFvBnfmBXQcJ2kkFqZmjD3ubGeW8Fo8FJXf7uqz8Oi061Idk6Ssam45Pv1jVPvDs4veD3n0l5TOrdiKZ4f3WMKwl24YArlvEXqCdvcgCMew/bm1G75IaqGzAlIdLa+r/ZMzh6/dHbNfGKVc/C
 Ly0Alr84
 XOjBZzuoKNkRHNQ3c0I/49vp02K1TSorHGvCg1JxCMBkRK7+WtKnAhXCHRNnnMs6VdrUcsHHUtx1/VvgpGVTvcs2bbhMrFOjAfhwn9w0CKJKDfkox6S5Z77L/GLueuKsGNq4if/y1ipEUmm9K2snAHjUg7Txns8YQV8uC6Tt2x9zDDHL+uaIBv51MGDffjy5pojaa+n17FJeESOGAqtfV2UDYNdfGhuo5ofutPgVYFTRYZWpEVzjzBSgG6A+GU04IsqipCP7r38PL3XcrKpQchZmJckPDul4omRRI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 03:18:35PM +0200, Sumanth Korikkar wrote:
> Hi,
> 
> Patchset provides a new interface for dynamic configuration and
> deconfiguration of hotplug memory on s390, allowing with/without
> memmap_on_memory support. It is a follow up on the discussion with David
> when introducing memmap_on_memory support for s390 and support dynamic
> (de)configuration of memory:
> https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
> https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/

Andrew, David, we would like to carry this series via the s390 tree,
including the fourth patch, which is common code only.

Is this ok for both of you?

