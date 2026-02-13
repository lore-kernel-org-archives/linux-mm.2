Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8379CEDF161
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 13:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9846B0092; Fri, 13 Feb 2026 08:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56D66B0093; Fri, 13 Feb 2026 08:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ACF6B0095; Fri, 13 Feb 2026 08:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81B446B0092
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:33:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F240160518
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:33:04 +0000 (UTC)
X-FDA: 84439524288.08.C2CB1F6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 159C3C0004
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:33:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GMAHpWt5;
	spf=pass (imf28.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770989582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbfOTr3RHfBlMe9NBhQ7IHeh9q5RDg4Ij8qWUPerPmw=;
	b=d2mqpSe5KNutf0KCXIBcqIOeXnaXB7Xj+OL9NZ8BkdAIbcc7eGuCOtq+U/AeJvrq+EBLAH
	H8ECGXsvyZ+CGi1wDrKwPvADp8sENjavf2Wcos8xTBzKM5d4/psbKu4tvHstm5q+bh0K2J
	H2j4vDM1cYSSH5n4wDc05TK6Mp4K89w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GMAHpWt5;
	spf=pass (imf28.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770989582; a=rsa-sha256;
	cv=none;
	b=BD4Cwc9E+0+0oyKmo9voygNFSmKSqV6L99qZvtdOCvA15GdZ7dWC7u64m9dLD0QZxMEBNK
	9c6FhDuuqwkrAWLEtHvvgnHKdGSuYUxNwWkovF706dcd2hi0JK9/aYGsZXXpn1COYY5CD2
	iPERYBVRoGsYSrY1frY9LHrFgn9fgf8=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CLj8Ai2771696;
	Fri, 13 Feb 2026 13:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=rbfOTr3RHfBlMe9NBhQ7IHeh9q5RDg
	4Ij8qWUPerPmw=; b=GMAHpWt5x+x+dgRf+NGd9UWvTQYaVwAprI9nyjqhW2sDbr
	TRS1WhqjqG+zbl0bKDBK/KcFcRxa3YXPh/wpHdw8NjEddo4Jv/ixMPwmFyiJ9mb2
	jxMegnXKYEy4Zp7Dt4jwRu1kAy6gbu2PjYaI75bLyqt8tlAh+kOpWycISdLgxiM1
	WB5poKZglakudZa41mtVP+TZDcvmPmzGbcNV2OSCp9dkFhDLHeorFgIQQdn1xNOp
	3Y5bim7EkbQEjh3E05YIHAO4sN+CLy3p3LEnBzXqcQ6Yfju0tY4uRAN4pdjA/6VZ
	iiQZXaFh2EAzVBZFTvCAB3urV5oKm8ukzHnfKjdw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696x8601-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Feb 2026 13:32:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61D93bJn019274;
	Fri, 13 Feb 2026 13:32:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxkes10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Feb 2026 13:32:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61DDWjof35848614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 13:32:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAD0320043;
	Fri, 13 Feb 2026 13:32:45 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1DF520040;
	Fri, 13 Feb 2026 13:32:41 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.148])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Feb 2026 13:32:41 +0000 (GMT)
Date: Fri, 13 Feb 2026 19:02:39 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Andres Freund <andres@anarazel.de>, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
        ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
        Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
        tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698f2801 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=07d9gI8wAAAA:8 a=VnNF1IyMAAAA:8
 a=epTmVMiNAAAA:8 a=JfrnYn6hAAAA:8 a=og4LjZuHdkhFjIL0nAUA:9 a=CjuIK1q_8ugA:10
 a=e2CUPOnPG4QKp8I52DXD:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: B6mVAiWSQUiync0uu1rfzNnJOP1uUAz-
X-Proofpoint-ORIG-GUID: qxmG_EN45RmzD-rMRK5_7Sp_3ffjxWpW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDEwMiBTYWx0ZWRfX+r0QdfenqGXJ
 gJSDfWtJd00KP0XCjZYfpcoiM36d/IiY23XuA2VE7yg/bOqJJzx/nkpgvEwlk06J07+p3Y76PjX
 2M7GwenSfAlZjfFZ2yKBbVIFBgN+P4zuJt70nWax2mdBVs1zFTLwoJOaxlKtDn2r5Ik9cC5NcUc
 Xu9PVt1Zt121yo5bz2AkidD0RGtTNR5xTCpqb1c95XVpJe7RYMvk81Z3OQLU67pd+wv9z/syDQr
 NvqNIqsnt42uMRc0ssQOUVUW0QrRSOabCV0lgVbNQ/E5Fb0iNlzBFuWvHTj2lo9bKYHRAxAJ94J
 W2z+Ctpq9jkCv1/B6OhtfpeBaKo8O7DHW2LD/67wZIDVHUrVzCLKFjUtLmtGCyBOelXVFy7GW0n
 E8NhyZ1UQtLg7Tb36bFXxQB5MyUQu+iw24IwT1TUC90lg9w09TEccR1DfJPevVkDiJa5+TEE5H1
 AiB5x6mthDdDL9jVA6A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_02,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602130102
X-Stat-Signature: qho995bmwgrxq8wnup6jmnfa3jau9jtt
X-Rspamd-Queue-Id: 159C3C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770989581-276460
X-HE-Meta: U2FsdGVkX18CGIsjwGPN78vr5JYh4PXjteQRVsw4+m5eQf24lgBI7OgkFXkjPa4A5/y0yE/C/id7i1PAljqOeWArSVlEs9/8IVE6eWfnE1QPy3IOdgVQ1C4VWx1+ID/dqBdi0VwBTQjvhUs4k3HMTf5htZyP/WL8Fu8+DSSkxqAqed1cUWhU0IyW0AwHYi80Eyp5lnFW0UKpZRPSy9b0TSezb4YqEOcmS99xLOI28t8nB6CxS74kFE4vWTyzkOTFuop4cTbl73pIbCcQDi0ePCvTcn5EVhbx5GaYxd9MUZS3TRUSFQL3BV7tcat6g7sp5lzbD9cI4EjYITgPX7I9O7eQ36DdtbNZN7uQ1cLEkGWQGPJi0LZ43+2qju6t2hYcBfWG9oR2G1dj0xSLZW5KuUX1RseE4lZsc5YgzZyQFUyv16s0LBV+eC4PSy5bXKb4l7W/b2PvOqrqIkIQW0Pcwaw0ffdDQyCosuhi8jh1O1Ch5xzRn4fex6lGnfdOMgyFVWIBasxKS47zjeH0wOQu7eGe0AC1T9vrMiKG0Hyd5CfvVEoZsFgiRDi6L0hwZgRB974GThbUebq0dx0nUqFjOCs4v8ikikYtH7dvsRXpzDeYH7M/3jRLpmqrsgaYy5F9Yarxm8Un18JvwVvWNgwSI1WDiZVhbD0ixQ6UITA6oTVkcIvaRkudSMIJgVezeC8kwNDTTNDpAYlnYAb4auvkgD8IxILb5CWY8G5jiqxujQsmrJ2TRdn1XvC0r+bN466Th/oUF9UELM+syzWAI6nMHZFWWkCQXZvahapsSc+gG5TXi23NM92jtgf+eMxIfphRf1TzBBNJjVQ23xS5RkasVGD2Rs9N0tKyFtVUE5PX2VkFY255SopWMjXEHaEDTvJMNAd4v1p1UEZJ0ttkTjdaOVYLhAIkTgigb8j4/8CK+aCaDabPCPGmMnX8aYLaZh6gkdGW1C8N3AdWyLMeO+E
 5SeOgm9r
 0RgnZ7yaqvMKiGenRJQs/Nyug5GOlKx51KxddWvtHdZv1qu3+FzE/kNVzrmzNv+a64INYA1VTir2qczI7Gs0l/s7RJsNigLWMJQ0mSrKiHz2UI0TMZS18AowKi6Gn1fG30wIzdmef2M6/lD3pzzMNhRG8lLUm10Ydn9fOaiBkh5G8SE74XrosphfpsCgnFPUYKr5PaSzbyYUYRhI0TkWTBdBXX02a8y9mLY+BDQ1E6F8ZqKGUswvJR9iX6HHqvEKLiw+hRy4XOoi9hxzM7Vnjyh3BUpDriiTyyIAgayZRl6FMFDGxHGsF0c0JIsBPZkFLEzfMyJcDsOKUDLMWTd+F29bYC4v6lmkSyMs19W+KMJWGQ1Q/T0P8KmA+GaQ53mtcDEi7vB+ZeJ075DEwTkPaXgg+GhVg/0qM0DQzenrc+oR46q3HID3REq1bXR/089cze3EfcYNcz38WAR9iNBkHC7YCeU9gU5AFzEhdHkVtHRLOzXL72A5t6hYy8a5bTWEghDz5nXpDGSKjRXoPjb1RRJaTg0tuD1jJaXhXeY3bjFNz78hguEK6sqgrgwuW22eFk9F6UwAmVTpFzH0QIWimt0iziaHg7PBk+VIHTO3F2vSqiJ7Yaeaqq+UG+HHhxm0K21pzdEcsAVbHbqDvpcO5dNUnXPkFJ04bcJFUE1dnO1LXB0AaHmd+vKWqbZr9O/D+VfiU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> Hi all,
> 
> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> remains a contentious topic, with previous discussions often stalling due to
> concerns about complexity versus utility.
> 
> I would like to propose a session to discuss the concrete use cases for
> buffered atomic writes and if possible, talk about the outstanding
> architectural blockers blocking the current RFCs[3][4].

Hi Pankaj,

Thanks for the proposal and glad to hear there is a wider interest in
this topic. We have also been actively working on this and I in middle
of testing and ironing out bugs in my RFC v2 for buffered atomic
writes, which is largely based on Dave's suggestions to maintain atomic
write mappings in FS layer (aka XFS COW fork). Infact I was going to
propose a discussion on this myself :) 

> 
> ## Use Case:
> 
> A recurring objection to buffered atomics is the lack of a convincing use
> case, with the argument that databases should simply migrate to direct I/O.
> We have been working with PostgreSQL developer Andres Freund, who has
> highlighted a specific architectural requirement where buffered I/O remains
> preferable in certain scenarios.

Looks like you have some nice insights to cover from postgres side which
filesystem community has been asking for. As I've also been working on
the kernel implementation side of it, do you think we could do a joint
session on this topic?

> 
> While Postgres recently started to support direct I/O, optimal performance
> requires a large, statically configured user-space buffer pool. This becomes
> problematic when running many Postgres instances on the same hardware, a
> common deployment scenario. Statically partitioning RAM for direct I/O
> caches across many instances is inefficient compared to allowing the kernel
> page cache to dynamically balance memory pressure between instances.
> 
> The other use case is using postgres as part of a larger workload on one
> instance. Using up enough memory for postgres' buffer pool to make DIO use
> viable is often not realistic, because some deployments require a lot of
> memory to cache database IO, while others need a lot of memory for
> non-database caching.
> 
> Enabling atomic writes for this buffered workload would allow Postgres to
> disable full-page writes [5]. For direct I/O, this has shown to reduce
> transaction variability; for buffered I/O, we expect similar gains,
> alongside decreased WAL bandwidth and storage costs for WAL archival. As a
> side note, for most workloads full page writes occupy  a significant portion
> of WAL volume.
> 
> Andres has agreed to attend LSFMM this year to discuss these requirements.

Glad to hear people from postgres would also be joining!

> 
> ## Discussion:
> 
> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
> Based on the conversation/blockers we had before, the discussion at LSFMM
> should focus on the following blocking issues:
> 
> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
>   write might span page boundaries. If memory pressure causes a page
>   fault or reclaim mid-copy, the write could be torn inside the page
>   cache before it even reaches the filesystem.
>     - The current RFC uses a "pinning" approach: pinning user pages and
>       creating a BVEC to ensure the full copy can proceed atomically.
>       This adds complexity to the write path.
>     - Discussion: Is this acceptable? Should we consider alternatives,
>       such as requiring userspace to mlock the I/O buffers before
>       issuing the write to guarantee atomic copy in the page cache?

Right, I chose this approach because we only get to know about the short
copy after it has actually happened in copy_folio_from_iter_atomic()
and it seemed simpler to just not let the short copy happen. This is
inspired from how dio pins the pages for DMA, just that we do it
for a shorter time.

It does add slight complexity to the path but I'm not sure if it's complex
enough to justify adding a hard requirement of having pages mlock'd.

> 
> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
>   PG_atomic page flag to track dirty pages requiring atomic writeback.
>   This faced pushback due to page flags being a scarce resource[7].
>   Furthermore, it was argued that atomic model does not fit the buffered
>   I/O model because data sitting in the page cache is vulnerable to
>   modification before writeback occurs, and writeback does not preserve
>   application ordering[8].
>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
>        where we always allocate new blocks for the atomic write (forced
>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
>        avoiding the CoW overhead while maintaining the architectural
>        separation.

Right, this is what I'm doing in the new RFC where we maintain the
mappings for atomic write in COW fork. This way we are able to utilize a
lot of existing infrastructure, however it does add some complexity to
->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
it is a tradeoff since the general consesus was mostly to avoid adding
too much complexity to iomap layer.

Another thing that came up is to consider using write through semantics 
for buffered atomic writes, where we are able to transition page to
writeback state immediately after the write and avoid any other users to
modify the data till writeback completes. This might affect performance
since we won't be able to batch similar atomic IOs but maybe
applications like postgres would not mind this too much. If we go with
this approach, we will be able to avoid worrying too much about other
users changing atomic data underneath us. 

An argument against this however is that it is user's responsibility to
not do non atomic IO over an atomic range and this shall be considered a
userspace usage error. This is similar to how there are ways users can
tear a dio if they perform overlapping writes. [1]. 

That being said, I think these points are worth discussing and it would
be helpful to have people from postgres around while discussing these
semantics with the FS community members.

As for ordering of writes, I'm not sure if that is something that
we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
been the task of userspace via fsync() and friends.


[1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/

>     - Discussion: While the CoW approach fits XFS and other CoW
>       filesystems well, it presents challenges for filesystems like ext4
>       which lack CoW capabilities for data. Should this be a filesystem
>       specific feature?

I believe your question is if we should have a hard dependency on COW
mappings for atomic writes. Currently, COW in atomic write context in
XFS, is used for these 2 things:

1. COW fork holds atomic write ranges.

This is not strictly a COW feature, just that we are repurposing the COW
fork to hold our atomic ranges. Basically a way for writeback path to
know that atomic write was done here.

COW fork is one way to do this but I believe every FS has a version of
in memory extent trees where such ephemeral atomic write mappings can be
held. The extent status cache is ext4's version of this, and can be used
to manage the atomic write ranges. 

There is an alternate suggestion that came up from discussions with Ted
and Darrick that we can instead use a generic side-car structure which
holds atomic write ranges. FSes can populate these during atomic writes
and query these in their writeback paths. 

This means for any FS operation (think truncate, falloc, mwrite, write
...) we would need to keep this structure in sync, which can become pretty
complex pretty fast. I'm yet to implement this so not sure how it would
look in practice though.

2. COW feature as a whole enables software based atomic writes.

This is something that ext4 won't be able to support (right now), just
like how we don't support software writes for dio.

I believe Baokun and Yi and working on a feature that can eventually
enable COW writes in ext4 [2]. Till we have something like that, we
would have to rely on hardware support.

Regardless, I don't think the ability to support or not support
software atomic writes largely depends on the filesystem so I'm not
sure how we can lift this up to a generic layer anyways.

[2] https://lore.kernel.org/linux-ext4/9666679c-c9f7-435c-8b67-c67c2f0c19ab@huawei.com/


Thanks,
Ojaswin
> 
> Comments or Curses, all are welcome.
> 
> --
> Pankaj
> 
> [1] https://lwn.net/Articles/1009298/
> [2] https://docs.kernel.org/6.17/filesystems/ext4/atomic_writes.html
> [3] https://lore.kernel.org/linux-fsdevel/20240422143923.3927601-1-john.g.garry@oracle.com/
> [4] https://lore.kernel.org/all/cover.1762945505.git.ojaswin@linux.ibm.com
> [5] https://www.postgresql.org/docs/16/runtime-config-wal.html#GUC-FULL-PAGE-WRITES
> [6]
> https://lore.kernel.org/linux-fsdevel/ZiZ8XGZz46D3PRKr@casper.infradead.org/
> [7]
> https://lore.kernel.org/linux-fsdevel/aRSuH82gM-8BzPCU@casper.infradead.org/
> [8]
> https://lore.kernel.org/linux-fsdevel/aRmHRk7FGD4nCT0s@dread.disaster.area/
> 

