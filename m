Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B8C10FC466
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C9F6B0005; Wed,  8 Apr 2026 22:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854A46B0088; Wed,  8 Apr 2026 22:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A5A6B008A; Wed,  8 Apr 2026 22:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6374E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:36:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 114A1140373
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:36:01 +0000 (UTC)
X-FDA: 84637452522.10.BB42EC2
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC7B6C0002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:35:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UGpa0zeX;
	spf=pass (imf10.hostedemail.com: domain of sion.ji@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=sion.ji@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775702159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Svwkd34gA5sOnhAwfBHI8rDp7I4bZYBAYTElFQpGfuY=;
	b=jmiz8Sz5Ry6UfxK3LfWabVAcZW+OqJ8tC78UfLnefyYK7WXIuts7+tQo0oyU/Y/730JzRv
	E4Lbrz9PP6tMn3nDIiltp9b4s4L47C/h6lIifRR3a822Zc1dHPzZ0oNTMCV+jrN7s+ul23
	6iTLpyrm7luajLySFDZi+iVD/offx7c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UGpa0zeX;
	spf=pass (imf10.hostedemail.com: domain of sion.ji@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=sion.ji@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775702159; a=rsa-sha256;
	cv=none;
	b=57Rlmkr15gbg75rTgPeRAhb2GrFPBck7uK1A8VpNulpMccfTdTzYi6HP1yJGgMOdYUau6e
	EtKgpNmCM+1MkhrieTLhCSnRmO9X2wuN1JJwj0TMLZDDArzVwzobXQv2ColIGcLDJcE1nG
	3jMLNPC3orGhhEDpZsl2NXQDggBfoNE=
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260409023554epoutp01a30b34e6611fcdd2add6fcc39ba3dbc6~kj7OIBOsC1819618196epoutp019
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:35:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260409023554epoutp01a30b34e6611fcdd2add6fcc39ba3dbc6~kj7OIBOsC1819618196epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1775702154;
	bh=Svwkd34gA5sOnhAwfBHI8rDp7I4bZYBAYTElFQpGfuY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UGpa0zeXYvwxImJu2Xw0qS9DNYeORc4H7+2xLADkYUxMdVnVQLJ8TbF4n+Ave30V0
	 NIsNWjDoG/u7BZBKQIkc9ev/6kDBwyqq9hcS0X/ta1G/hHJxMN9mvX1nSMve2SZ5v2
	 sMHpRwgFi8LNqKaug2sNw8ze95gAu/4MjtO0SHK0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260409023554epcas2p29b35a3c31622764ae384f17ce2139964~kj7N0E8dH1248612486epcas2p2R;
	Thu,  9 Apr 2026 02:35:53 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.209]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4frkZK3t6Kz6B9m7; Thu,  9 Apr
	2026 02:35:53 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20260409023553epcas2p2e40d1d79206f0169a765fadcf180b010~kj7M6g5qo1249512495epcas2p2L;
	Thu,  9 Apr 2026 02:35:53 +0000 (GMT)
Received: from AE (unknown [12.81.78.179]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260409023552epsmtip12b61a69ae4dbba27ca8fa276504ffec5~kj7M0tsTX2647326473epsmtip1j;
	Thu,  9 Apr 2026 02:35:52 +0000 (GMT)
Date: Thu, 9 Apr 2026 11:35:52 +0900
From: Sion Ji <sion.ji@samsung.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, linux-mm@kvack.org, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Tianyou Li
	<tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <20260409023552.GA2807@AE>
MIME-Version: 1.0
In-Reply-To: <20260319095622.1130380-1-yuan1.liu@intel.com>
X-CMS-MailID: 20260409023553epcas2p2e40d1d79206f0169a765fadcf180b010
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----atTJT_IMamyeT3aYIDqNfPm07F0lpbeBE4hx2ZgfjOvbTF6B=_51383_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260409023553epcas2p2e40d1d79206f0169a765fadcf180b010
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
	<CGME20260409023553epcas2p2e40d1d79206f0169a765fadcf180b010@epcas2p2.samsung.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC7B6C0002
X-Stat-Signature: ns7h9nxkqrarc4o6ycjj1sw4m8mij9f5
X-Rspam-User: 
X-HE-Tag: 1775702157-193159
X-HE-Meta: U2FsdGVkX18xR2bgnupW9fYE/sXiYdgqWzxIGfwKntBGrN1EzHVTPCcC5cECAR4OXXyjTQFXfK9/74E5iw2J5ZpkgJ9xX4oo+VYDccDcBbZ+s19wtz+xQL54iUZ7IoaSSu++mJcOUXZONJUcLupzSNXV0NDrc8BqJxHTF7demlRR6HcFN3+JenQgD6r4VXtCP5+tD+5UBAah0eZxoWdm6z5dlz03JRCKFIvV8UfEAmKVP9a1ixi/avz5+yKTCzXyEMtjJCDuHa7eBVwGgmDaZLTBh0Gk6IffrNvrgLu1PRp1pCanFcGJOL9ip1is8022dknXCQzrIvSZfs1q1Owj1/l5B/gRnyvBPOqLjlXmgiCNZm1jiV9cslXiFy3Jn+APz73VMT93K6ICgZMvQBKRaj0Q6uCp2POEkTaiYFDxcj80yvTrCDKRQlquGt9hP3aZbRpNGeFmHaqLMgPpk8iHzbEY7ZS0t/qOvHIVJWtEahvjvif4jiXzFfIECsSAlz1gX/IwrIFQ+zx/lTjFeTwbvvQer9dBTOCSPB3a2DSs3/sLqL4T5nW0xIbgb+ptgIBdRkMRJonekVlcx/7MxT2GPPgIAe5a5j09MfwfdskXtmbo2YPXbk4st05wJm7hMECpw+DbvGuCfRt4Ebr0u+SybTPNZ6IvcgE5NxCWst7OfknFTXfRLMo37Xo7hYHohmTwLl48ARFKEGNb4iPx5iWxY2rppaK8NSbXFUmGd+0dqhYflrJYdMKLK6Gscs48JhyMOY5dWKrgiUy3ImwmnsBv3Bpjqqlpra96tpqdh+4FFLVORTm8aUqtBTZKh1zYy58Z4jY8sJ1uwlnoaP9rbVhAkE2DTzWeMc90BtiC53XNDCdryxw673506bF77Yr/b6OD/QN489EsfXSBwUeuqCQnb+7+PsvczFAV+t6gpdv6iv+Y9JdqT4PD887qz+Wn86fdAdTVvTkpaCWLJHatF1u
 t62EsFJ4
 BpYgWLcsUqvfVH2CNPvcpsrzPxkfx6dkFVslHPaLx6RbiiRje3XxPn4JFdeG2G86nbuFpja3ZFBHIjT16EmwPSjVJsE5zdWNpiIU2Cw/u5BTWdpxZ+IsYr7bJI6Qm61zW3oe50gKIMMoLQ7dferrRnCupj7gyUlJQKe4Lft+BNnF7MswHwWL3fsDAbUXHWGIJJBuMXLouLUP7SP2d5nNqMlHdaHkI2XQgPzIpb8gIBh0awss6RnbtNMIoyTs5tuOBvFNXos/x8vRwVgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------atTJT_IMamyeT3aYIDqNfPm07F0lpbeBE4hx2ZgfjOvbTF6B=_51383_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Mar 19, 2026 at 05:56:22AM -0400, Yuan Liu wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add a new zone's pages_with_memmap member, it is pages within the zone that
> have an online memmap. It includes present pages and memory holes that have
> a memmap. When spanned_pages == pages_with_online_memmap, pfn_to_page() can
> be performed without further checks on any pfn within the zone span.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      7s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      9s      |       75%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v7.0-rc4
>     Qemu         : v9.0.0
> 
>     Launch VM    :
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>     memory is recognized.

Since the above results were tested in a QEMU environment, we ran the 
tests in a real-world environment [1]. The kernel version is v7.0-rc4,
which is the same as the QEMU guest kernel. We configured remote memory
node using 2 and 4 CXL devices for the 256G and 512G tests, respectively. 

We replaced the QEMU hotplug commands with the daxctl [2]. We tested by
changing the value of /sys/devices/system/memory/auto_online_blocks. 

The following is the result when the kernel onlines added memory blocks:
(echo online > /sys/devices/system/memory/auto_online_blocks)

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Plug Memory    | 256G |      6.7s     |     4.4s     |      -35%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      18s      |     8.7s     |      -52%      |
+----------------+------+---------------+--------------+----------------+

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Unplug Memory  | 256G |      2.8s     |     2.6s     |      -8%       |
|                +------+---------------+--------------+----------------+
|                | 512G |      5.2s     |      5s      |      -4%       |
+----------------+------+---------------+--------------+----------------+

[1] Platform        : Intel GNR-AP
    CPU             : Intel(R) Xeon(R) 6960P
    Memory          : Samsung DDR5-4800
    Hotplug devices : Samsung CXL 2.0 128G Devices
    Kernel          : v7.0-rc4
    

[2] daxctl commands to hotplug memory for a test:
    time daxctl reconfigure-device --force --mode=system-ram dax0.0 
                                                           (Plug Memory)
    time daxctl reconfigure-device --force --mode=devdax dax0.0 
                                                         (Unplug Memory)


The following is the result when the value is set to online_movable:
(echo online_movable > /sys/devices/system/memory/auto_online_blocks)

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Plug Memory    | 256G |      4.5s     |     4.4s     |       -3%      |
|                +------+---------------+--------------+----------------+
|                | 512G |     18.6s     |     6.6s     |      -65%      |
+----------------+------+---------------+--------------+----------------+

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Unplug Memory  | 256G |      2.2s     |     2.6s     |      +18%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      5.2s     |     4.2s     |      -20%      |
+----------------+------+---------------+--------------+----------------+


FYI, it is the result when kernel does not automatically online memory.
(echo offline > /sys/devices/system/memory/auto_online_blocks)

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Plug Memory    | 256G |      3.3s     |     4.4s     |      +33%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      6.7s     |     6.6s     |       -2%      |
+----------------+------+---------------+--------------+----------------+

+----------------+------+---------------+--------------+----------------+
|                | Size | Time (before) | Time (after) | Time Reduction |
|                +------+---------------+--------------+----------------+
| Unplug Memory  | 256G |      2.2s     |     2.6s     |      +18%      |
|                +------+---------------+--------------+----------------+
|                | 512G |      4.4s     |     4.2s     |       -5%      |
+----------------+------+---------------+--------------+----------------+


We hope this result is helpful.

Regards,
Sion Ji


------atTJT_IMamyeT3aYIDqNfPm07F0lpbeBE4hx2ZgfjOvbTF6B=_51383_
Content-Type: text/plain; charset="utf-8"


------atTJT_IMamyeT3aYIDqNfPm07F0lpbeBE4hx2ZgfjOvbTF6B=_51383_--

