Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7E8C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327CB6B008C; Tue, 22 Sep 2026 23:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9406B0092; Tue, 22 Sep 2026 23:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8AD6B0093; Tue, 22 Sep 2026 23:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F31506B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:12:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D42681606DA
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:12:05 +0000 (UTC)
X-FDA: 85243553010.21.EBBA5DF
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3D28160007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:12:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fM6+ok9X;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790133124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXqRRRTZoDrLgtSIIIeujmLVFncqWjfihFp3XOxyNoc=;
	b=UVsTxE/v2tZ5dj5TzjQq4AliiaI64u4z/huim8JZcu98BFgSpvoIWvf8Gv/U4A7e1hyWQo
	neJScw1fWeelr0HLUd2/xpMVxq/5eYkBCG2S4A0FTAdbYkOEIWhsQRdlHYUN9Q5dR1NElD
	OuUn8qoavRZJQU0JyUh8frpHnBaeASw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fM6+ok9X;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790133124;
	b=M/UQGQlIiY2bG7XbAHeqDG46bY4zvOJ4DdTE+5RbmOfyu7yAp5tO/ecOyzxHBD6XaNzMw1
	aJh7pUFJODiN9aL+JVoQb/Jw/vEitWJKiiHWbfiKTieDMMc7xLo0s/p5u6OMrT9fifBAq8
	M4PvQU+pwiViPcM+W7GHVBDzBOf2d3w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790133119; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GXqRRRTZoDrLgtSIIIeujmLVFncqWjfihFp3XOxyNoc=;
	b=fM6+ok9XqnzP751xZiXV3fbENazwmZRpgysMf4lM3pLyVlUVuxC8+bBvW+iCeHgIjImhW43S5nc6k0TipeAgFjkTBEUMze6bCaCzV4K200hIMqfVGPOdpAkmaPYFlg58I9cYnc5XahmxHX2jWUy/iO1EiuZo8WmsXT4WS2jbU8s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBVZ2Ep_1790133116;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBVZ2Ep_1790133116 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 11:11:57 +0800
Message-ID: <37f7fca9-76c3-4731-b1c0-2687a03eefe2@linux.alibaba.com>
Date: Wed, 23 Sep 2026 11:11:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] kselftest: mm: remove check_huge_shmem()
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-3-d25ec991159f@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260921-fix_split-v7-3-d25ec991159f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fath8jozoce14pbqdz6z5eg4zc83toy5
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3D28160007
X-HE-Tag: 1790133122-456665
X-HE-Meta: U2FsdGVkX1+Zriy+S+BOQLrpCVNsE2KNJjpV1lQ6+aLsRcrmECmHKtYWlDwOkgIFxxHIy04aUUKlnvxJZLkvtbaEdatLTAonTyvp5w2+6+p/RUaHCh542yWri659qHU5GoucGop8+Iw4l4Yen9MdjdxZlaA5zvl3AUSX6kTatxDCk8T5kApZd81nJCBRU2eDoZZRvyZLEDZG2OtOTECMralVXdRcu26uclfpstReNATMbwwT5zcZvNIX7RAt82C9tNbLWd/aT0s7kUyB1I4YdcAmmnKDqRUY4APBk+5T21ixoi85RHu0yetyj3ky7052N1xeYMNA6dLPP5UgxYLGpfDrr5mwcLjQbMclfyI220l4PX43JJS6Ty+sVP5CSn//wG9UTmFM81Nt73kb64OfS4HIjUwL2PyWy8ZUGz1WqmO9dieTWS187nB7/shjHwEGR19wAddstL0a8+UZohTEsqrav7G6xDcTr2sAbejjrjNX+QTpOti3GxaoSQHRCUFccR8QxnQ7ikNY3QiX07Ut1EhsU1UXuKHFzge/+mX8GsXjYX5B68/PRuEYXRnazDp0iG/MJe+vwEB85cBIKAoS5nankJE2rkays/C8Q8In9GRrl6xka1BXf5odc7RT1M5+QXu+y2lDEN3cP0e00k8G7NIqRm2Lk7AUMJpWQ97rYSGBOFg+vL4am76kzpl5WRLSFE0OYGrtZWBjD7tw+JsIhVUcmewJhVbiqAbskUBipc+CwYFSzFQEEa3sh4heC55RRKZcfTXjcKsRUF4dPOVl5Sj8ZUUi2FMYcQ4jDruRYpxsVzIuRRZNZIcpLCSmo/kpF6KEXGamv5QSlsYiktVqviHm+v6JVpGM4vi84B43DLHDpUa0fGX+hqQGMgFFCtNItQPJo0DMZdydjPY4WShD3Q1hTwLRGA34uxOH3k6jQfVhMw6w+Qla5Xomzqt+guXVK/02uAF0SXII5G9Pjta
 5YaOUsim
 bDlciaywPDhnFU+bi4vH6q0Y6PFPiM/Ur+Pcjn5ZRiH5Iak6v71SC/w2xBcAyilKz9XyVx8u1xVksmDEWolMLUnx8DJYRqPlbPCK65Wy+G+1x3yt4mtaByL2siE1VM0lGXpWMRjURvD6UurVhyNa6RMYreyZ6PiEf1zhhjD6olKlMVmT3oIT3jM4/h6g98wMrn8tSeLrQpHejFHkY0t7KxvfyxG7GbFU3rqw4plsRasCIjgRd8GvhQx9fQ29Q0j/OuXkF8ekL4cQedOvpzY0b6ymkHB+YuMdbKtQ9Tf6Utz05GPL2EUBAXDsc9cYnfLEP87ZKhwu1eDu5Z7i7eWkn5aEYUPcBurvgB1pERuCl3k4dHwMlK1B1DeA+yJTnml4nSeN688AJ+Oe8nZPAqSec3wViWfOs62pth8/q7LB58bqth2U11FNiLDvY5YURvEzcHX0xb1ngZeJRD84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 6:40 PM, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated “ShmemPmdMapped” entry,
> as opposed to “FilePmdMapped” for file-backed huge pages.
> 
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
> 
> Therefore, remove check_huge_shmem() and use check_huge_file() instead
> and cleanup khugepaged's check_huge operation in mem_ops.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

