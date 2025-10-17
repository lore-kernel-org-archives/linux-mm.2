Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D19CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2AA8E0052; Fri, 17 Oct 2025 11:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABE28E003B; Fri, 17 Oct 2025 11:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBE98E0052; Fri, 17 Oct 2025 11:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D79CB8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:01:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 821DAC021F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:01:57 +0000 (UTC)
X-FDA: 84007921074.17.07D0451
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0717540014
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:01:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OCn34bF2;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760713315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjlOEpjA/dZDxYCSjsqfVgbZFM/SxanKWySMXDeQTRA=;
	b=s8x6o4AXIhdpLWtNphr2vhUihs1zQTC+++0jt9HTOuM6HQ/jWs1x20Xd9GFbYUaESiNMDK
	+D7MeFUvk4wvofSbfk4Swc+ajTBeWE5osGnBWoddXtC1qHI6vB3ZtMvA92rf8N9AVmHdeX
	jWDDMORJOU5NRsGqZeamXtAKfn8D++Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760713315; a=rsa-sha256;
	cv=none;
	b=jhXc7507A5xrTMLMI6wVaMK2DmDQS3Kk78hxPrDOXm9jALYfu6KeGl56KLS7chaRwvgg3R
	yb8Hw7RpTPOqI/TOePfW/01zm+6hKFKzgqE26MPsn8YmxgAHsLTP19kaz6acsS+hXOZuf2
	jBfvkt06rnvQUZ6lucyg4wf1xix3qQI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=OCn34bF2;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of borntraeger@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=borntraeger@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HBHM9h021066;
	Fri, 17 Oct 2025 15:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WjlOEp
	jA/dZDxYCSjsqfVgbZFM/SxanKWySMXDeQTRA=; b=OCn34bF2k/4rTHZa89TN+a
	tJKPMQDGoxH2pn9ne2v6SOaGqeVSxpPjHe/iOg5w/NXb5+58U+J80m+CDwg0WZ6U
	DY9ssF3TJmj8rLrVmIQkObSShDGbdGdd3+JJIpxjN3lnvCq+e2UGidVRTL3trVh8
	Mbh+epPmp8zruQgMiRuj9VbWP0cLNmAoWlBVbIj6jGWy2mfkiHhqmR3w4ndJOQqS
	IPORSIeVzR9+5OFTlGysUwxV6uOitTHZnEuToToFS24otgwEj1BSALjizSgTBdfJ
	b0dLnWC2Ixo1T2Yoy4SFlRczoKLEN9UWT1G0iqHDLsEH8uDPk5aDwpZDDtExCGMw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0hwd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:45 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HEY0SR015227;
	Fri, 17 Oct 2025 15:01:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0hwd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HBd3uE018917;
	Fri, 17 Oct 2025 15:01:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jn5x58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HF1ge619988834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:01:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E81E20043;
	Fri, 17 Oct 2025 15:01:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E57DF20040;
	Fri, 17 Oct 2025 15:01:40 +0000 (GMT)
Received: from [9.111.36.47] (unknown [9.111.36.47])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 15:01:40 +0000 (GMT)
Message-ID: <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
Date: Fri, 17 Oct 2025 17:01:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: David Hildenbrand <david@redhat.com>, balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
        apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
        dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
        gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9LKX8Nmv4XcVUXrLvHE_HxecLxk_cP8h
X-Authority-Analysis: v=2.4 cv=eJkeTXp1 c=1 sm=1 tr=0 ts=68f25a59 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=U-Hwjmto4vr2S7wfJqkA:9 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXwHOgqQ6tTe+U
 eJeOmxYOFp6+xojNs6VzBRrLhYngNWxnQYx4056hPZU3A7tztlpmQKe0jl4dRsHm2EY5V4OwECd
 wfXh8kvLFSBLNWQO6YChYGy8sO5WM4VZzr8m4sgqW6h5Ode2RGLfx0nNgfJ6/OIZqgqp3jebCHe
 dmip45P6cxhsJignJNv2FmPri77wdU9CW/FxJ8EHR1zW+g4xOQmIisNydT7y5lhEebl5F7X762z
 F59ssPdVoDm8ELtqeqRw8YLucK+fiFaZoZ6bzLG5yyQGtkx8T1J2LG04XKhx60ksW8Zheieeyiy
 hdZEIis1wsxG2DnvxK4WS+PNIjnS5x8eC2KBhybUtz5i6wzPM91FG6A/3s+VFhy+r+YRTQPrmaJ
 LApWx8jnpGwmr0TM/gRlRO66VANL4g==
X-Proofpoint-GUID: P8unXoLWz4BehbTrBCBmfoLT7VBR8y9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014
X-Rspam-User: 
X-Rspamd-Queue-Id: 0717540014
X-Rspamd-Server: rspam02
X-Stat-Signature: 38tcqf1aychkfaix8e9ujyqfda1h3ez7
X-HE-Tag: 1760713314-681627
X-HE-Meta: U2FsdGVkX1/7Qj8fa2Q3cnYYfqUKzb6/h9wBa54UDTV+fxfSujfWpuwdVr81hurUN8Yw7iDgX2wKrCYFuU4IIb7qd8oKpJgYc3EFi4/XYWSCvIMx6FFTmxvcLxJIxJRVILIN2GoIVhWXoqXcLZ15IdCDvrlpL3058pdFabDJsrz29Fh1PAA/nKpMA4cwkz14RxoA2ERddFPhv400v3KEO+0dlfLXY0g1/g+ZM280neVK5H4LA2XOaiLP1sUUOYb+M3Q2nA9Cy0tQQtl0jmMf8uHAzjG9A7+S6AhpaWN050yS19+r1JlVrA4x/CAERVpv2ti/1iYMjy8NHCpiUuhw9NaHk0sNe0WIZcx+YfBPrjbgM8V0H7+t6PX+3B1bFLbe77jOZkPZJ9ECHbYnHdxmAlr6Y2go7qRNSHokpNCiGSDRqxPkxZWKohYsJfANTFphf9EL3YOw3o0QwI+PRumdvO93lQ7EVIZIh9c+2DhW6R3IQ8ngW3BoRZXbWICgvmaAjEt6hOkZnY0ktYONmY2wWhNUAtFcPMbAGmmbFGH5oIYZeDQHoO5KoiXo6wEnRzN6IBcCzXiRbq4QvhAOOhwAFWhatGIgSukSm495LjXJpMQm8FtlkhuADY7+ytoBtV4uC3sTB8GY87aYi9BTGeofCKIaO+FVsVpXbc6yodNA+3OezKKAEsjQq1ZOB/uXd4a6uayuY/1yyR9jvdwfBxBYYjybiLxPuybY4/msbOQyRCcFMnn06Yguf5XJ1I+TmevQGtgvRrQ1LmSJD3Kfe/T5jwk+xMBupyfuXxVhdN5ocN6ApoZgV9y7Rh0NlwNbiupXKDSmlwvw5dmAoozzUV3qjlFxjaPKY6sOpMDoBYlrQBYv2u1J/g1rKj0A2pMeh7nMSmMwamJnh7ejYAY1zGBC/es6wci3uqWtivENxiBrLoYjm+SRIJYnBNdstswe2juB9NahD6MTFsR35oo5B+W
 G4xQHPIs
 QN9G6sXbaWiBndo5joQGYNym/sbt79u8/w7Uvfa2Per0+QZY0lIkBlRhQPNma8dUMYaH60ntLLIvOluOHxdPbM2WhWVR00+ZpEHDWe5Y41nPZt5ewJszm2JbCbcEQFdeIVLWCppYcwe6hmJt/IDy+cJJBB6F0GG1dDrmxt3VVd5+/M3MqD3cRY2N8tHtYyvNL7/uYsbX5wyPp4BaWkmh9xteNW1itL1WoJF1ixy4VsXY7nUgOGX89pRInaZfphH9zD6gUC1bsqSoOe3sQJsbyAqHXn1nk4TQPCMAE/tvqKIX6Wy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am 17.10.25 um 16:54 schrieb David Hildenbrand:
> On 17.10.25 16:49, Christian Borntraeger wrote:
>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>
>> error: kvm run failed Cannot allocate memory
>> PSW=mask 0000000180000000 addr 000000007fd00600
>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>
>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
> 
> Only when running KVM guests and apart from that everything else seems to be fine?

We have other weirdness in linux-next but in different areas. Could that somehow be
related to use disabling THP for the kvm address space?

