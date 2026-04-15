Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75D6ED7B99
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2D46B0093; Tue, 14 Apr 2026 23:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498FA6B0095; Tue, 14 Apr 2026 23:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6116B0096; Tue, 14 Apr 2026 23:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCB36B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:20:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA30EC1442
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:20:03 +0000 (UTC)
X-FDA: 84659336286.27.134E7F8
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E93BC0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:20:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wc7FaSkQ;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776223202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcGhwNl9tCxinhH/Mw8L5+KsTgwgIEcOsH66vEObKtk=;
	b=VorE6rJ1hB429Hb1s4YLuFENC79MOoLscox4DoBvCO3W0LVhLVa78V49dFPl2aMsyL260A
	DxjgHyQHc/zBy/Bk+nl3RQK0DH8exiVrIC1fIqkLk1iaMb8V/VcxaqFGNxYyqJrSchIQSe
	m1vSs89X7tdc84AaMqbBf7F8XTD+tEc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wc7FaSkQ;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776223202; a=rsa-sha256;
	cv=none;
	b=54EJX9kQ4ZynlXAvmpWLZaG3m2hG9ch1AKkcCaQrPCtUr8Qqc+EZ5J71q3x3HC77lhbKO6
	mWuDdcnqGn/5PeqKRWt3r3ixmrnOSWuoiYBXSIRfi2bU3Mr8DOBDjuSTHMnFhBZhhA4V9W
	/PcHdMc5UXo3zOr44Diujwotrt9Mz8g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776223197; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CcGhwNl9tCxinhH/Mw8L5+KsTgwgIEcOsH66vEObKtk=;
	b=wc7FaSkQL9ki5rwq/KsYWFzxEEBmWLzYVfSvJH4BQo5bVZDQ0BzaQRW2unZhuY9uxu6HMvCgyeddsUYmyKfSvJSGbx0k0lvcEZUpxoQE2D0y6smhzM4gOW5uhqgiV6VSod5VINo/gk6+DSd4lCnm/6ipDh80GuNrHh2dBI1zo/8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X136K2n_1776223196;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X136K2n_1776223196 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 11:19:56 +0800
Message-ID: <cd687269-4bd9-4d8e-8a3b-192956d7aba6@linux.alibaba.com>
Date: Wed, 15 Apr 2026 11:19:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/14] mm/mglru: remove redundant swap constrained
 check upon isolation
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8jg3mzp3beaepgfd3zn3t93ei9x67zem
X-Rspamd-Queue-Id: 6E93BC0008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776223201-144076
X-HE-Meta: U2FsdGVkX1/im1DFz+PfGMlOKOxnxjrEaMQ2T2NfYrdpYpoL1wDUGTpm7KW6wLHVhHUM1N47cMYo6XmfSrc1x64kYpZxrzrSwwaPmD1wAln1z4tHuGprtaFQyxzEc2JSYjzmsvJBxi+ZBz5ksAhmHw5+TEUWiGnvUaiCZfZgwr+ntPs+Z/ZxkTJ5JrjZLp4VRoS6KPloIvna17Xh/WHzZhPCivmjM0eLIFQ0nFN6RoGmGTe6QSleRcCTp6Kj6tM07QxTLBLoBOUWEUFSCUrSROo0wPO1PrjpLPiyU2FloOqebunmUGxxO9nQu2QdQbBlfnRTptcXX5L0VrvfkW89O5XjPS+fu5Nq8ZNXo11mb2y59hxoPLPC9GYGnLZ+z/qHgBsmT94Yevr/kVLST7s3INdlAY3Hzirgup8JCRk+cT4bmbB+aqZuW56ASN+gzeZruidn1JVMbEZUGuzuDq4+Ya8XWQGG1C16/Z2E6+qG+WnaarjPBsYFmWn19a2/e3AL06pY6ldC3f7pn2tPKylu4JIvtSXU52CvE5t6o7WjpA21oJ7a14fmBlohAvfXvVo/WL5vRZuKclb5n114WMaNC9Rj+rKY6mSpTUod1kK0kz4pQ0f1yXeIhcpF5eGzsXrDL9MSDH43IpxY2IsRNvbufM92T8cZZQ/AdpVR6996FF4332xV/YEr7cvhGTXjPnHzU5JM95Ti9niEU5oi14QOKTiojQxQXkzy9+0xPxiSyrp5q15PclSSb6/3uZIglA/uKxDdIk683TDpGe7B2MgBaZKHxcfDrR6hqRp4KY/rt9YUx2u+XDPKw3RJ0ELZkeUhi07QV2ZKAxXh7VwmuNIW2xpQn8BSCps7y5MlgWXCgJ9ll4aGZtZ0w3Cv47hGZgV9G70XPoXRbaE4DZN09aVX+/pQGyOcVC4G/kw0B7MSDTek5AFLWNvqiBCvussNaNbU/9HrpnJl44Yc9NIaRRO
 Vo7f+pn3
 vYb1dI2w8Zl7gfaF4ftvWBdTOiwwg//lquz/Wjj5jzRthn2VDnJ+9kDLWgSW2FO/n8fPK2KKJBWpU3m1nOlZwMweXbgpTXqqAIQSAj5WxvXCF8Fzj/Nrx7j6Sla7/zHe7fOIOZ6cJRc3ezrI/kZVsbWm1IZcVnxjAkSFi8W6Cmg+0zwxzwVOBDQJj4Tf0DOqi15VJSqxMG2VnKMtJPtasPCPtfj05Xpn0GUlgzphuzgVbawPIOOpDwgm8P3W5YHzk2nAlwV8ZGIdCr+Jbi6j4hbxBm2jGX+IWggbDQ3yBRIMMGhUIoMeZ5Fwt7DMoNGuH7/e9jggXkQppfiTl1QskYvhnBZdnpG4AB+FVUysjRD5mhmy564YsyfEzrP0JixOJMnqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/26 12:48 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Remove the swap-constrained early reject check upon isolation. This
> check is a micro optimization when swap IO is not allowed, so folios are
> rejected early. But it is redundant and overly broad since
> shrink_folio_list() already handles all these cases with proper
> granularity.
> 
> Notably, this check wrongly rejected lazyfree folios, and it doesn't
> cover all rejection cases. shrink_folio_list() uses may_enter_fs(),
> which distinguishes non-SWP_FS_OPS devices from filesystem-backed swap
> and does all the checks after folio is locked, so flags like swap cache
> are stable.
> 
> This check also covers dirty file folios, which are not a problem now
> since sort_folio() already bumps dirty file folios to the next
> generation, but causes trouble for unifying dirty folio writeback
> handling.
> 
> And there should be no performance impact from removing it. We may have
> lost a micro optimization, but unblocked lazyfree reclaim for NOIO
> contexts, which is not a common case in the first place.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

