Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34099CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833B16B00A0; Mon, 11 May 2026 18:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3CE6B00A1; Mon, 11 May 2026 18:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D37F6B00A2; Mon, 11 May 2026 18:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 581EC6B00A0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:46:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 222931602BC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:46:34 +0000 (UTC)
X-FDA: 84756624708.07.BA36B4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 94AAF40005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:46:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2laXtpN;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778539592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+ZYh9yAPa+MU3yfzrRffpRV6t6zDd0OQWQqLoLTWvI=;
	b=lFPBABDvn/J2jXXBsOA3/NlRsyp2+tnx4WI/jsGtDkjx2h4p9UgUXtxMd0RdldSrB11mzF
	tyQaDryqb/mA1cbMMvV5iNMKZPW0DjZWJpY2Wkk//vJdnNexzY9mEk0rJhY8nHbSq4SnZU
	YX2iA9cbEDuXFa1yNnuckJZgkOf8vqA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2laXtpN;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778539592; a=rsa-sha256;
	cv=none;
	b=uLKhS7r8ahzjeb6xQ6ymzIqtyxqrCrgF376OZaBSWMIR7u76GmN/22KvRfRoZiOuD1r0Bk
	Mi5THFrOvHR612XIq3CPq11G6c4vvzh8gS6BkKBjnLy6wHnlhVIzkJwts7tGcwFBc7iVX+
	YBfikbtuyux4RGiisVl6WAuDa1da6Jg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD7DD6001A;
	Mon, 11 May 2026 22:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BF2C2BCB0;
	Mon, 11 May 2026 22:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778539591;
	bh=ZSi/5KocwBQnf1OnFPbhDuhQNcsMBXqvZzwUmu60IHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r2laXtpN2/+dlTE6cZ37R2GPzqKnLW8SO4fJywCOcZ4LZ5qaLvahducW4aXC4jzKj
	 rH0SCuEV4+ishUl4E7JlREPWZwH1OESXTQHYQgv96VFzohw+PMXYim3HIVD0xD4E9G
	 Wg8U2HzDDgVXd0dUyIX/6Gb01qDzstIBfHQ5UevZcl/DdS+q6wXoTBLzGXhRn5+H45
	 hiRWlsNW2nwB8kaXTlA2X4CiklVSUZZpopI102dNT+xxRAcJQbCZIkUCWSCTPm5Mi/
	 kdGFr2gKO+Q3YdQq/iLMXtJi7pTISjEV6+wXxcf6+7GoMXcB8XRmSM5Ddx8+V8/k4b
	 ukccLcDtgUgUA==
Date: Mon, 11 May 2026 22:46:28 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [PATCH v6 01/22] mm/swap: decouple swap cache from physical swap
 infrastructure
Message-ID: <agJcCZuLqWwU_sSR@google.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
 <20260505153854.1612033-2-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505153854.1612033-2-nphamcs@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94AAF40005
X-Rspam-User: 
X-Stat-Signature: p8zkh1g135yzz8sxoaq3c5tyr5b7is4q
X-HE-Tag: 1778539592-986109
X-HE-Meta: U2FsdGVkX19ykuWY/LuIGMTAoYp4rpWkJtQ8XWy3dCjG7TAReqrwb+NudwRJY4tkrlTsNU+YVgg6i3UeE0F7XD/4y8kcLSRKwjhjr1HV3AjfVIYj4RPu/IKay862LByhRt5lS5brEUZzSi97igsAl+2VhQ+YMCx2i+lBroi+4xrKSivAoVG4egFvDEoSJSy0XBLLwTT8x9VStT2E+Gi4qFWKIHe+9h1/N4y7LJZkN6dS6Jng+sCpMHpsxLdopiuYcW/euWXjgbQtwAwOkm8Ot1izv03hTvlyH1pkP3NG7J2l2gMr/AnKjSeXDs6wiNz03aWaJ20P0TO3KslZpb+CfaXzm/ahCBv6EgNHvqTKhkidUp3Y3yteTHvFD9V8jZflnEMRD1n11Hvt3HT559DvuDbTCTm7gU4tcM2367oBuTlR04OwqEPrtXIGhgxm8Rpj4DzqMlsYdgH2eHGIRFWY5Yh9eSRXBfcbB5Mb+qFwDN90KBRjQu2Q8gEDU+xcsvHNLLe72DipIsbnI86joROuZ1ayO6X+ftcb1r1ZBNbpcq/QzsnJnBpsYkvdX7fO4hq2aEB2ZJV/7EWs23IsipHek0WI1jKutyp9ript/TXq0jze2ueDsAQOjDFpfunfh3UI1OgXVXfK/laK9GnElLE1HOnydGw5xW5pGLY491UZMMMi/Gp4fJt+uLu0ouqw7ObWqfak4GT4y9ZCXWnlIFUGltZzwJi0fAqlNxUFHjpdcx4LQoA2xDGHWhR4a01u6YqJrTTZ7/ZfElAgNvGEIiKVNOyC+afzwpmSnU0RjWWM25ATXxX02C6LerAP0gcaFLesPe0eBbfiCy2zFEwJepeAkyckRMr1ErIhkFgkKUM9ho+H1psmo9vunWD3gWowFPMb3DEnPcm4ghSf2Iz8rZfektGy8awcw1UmUZR20pekd/YIwldDfUX5j9bdfH6fjnVMB/Y2NQH4nxbDO8FLIwI
 J6Ip83U9
 XXeRaXZEuiSMrzUi/ffmY2atMLgaeDwv+mdoQraMot9NpEbAJ1exHeQVNembbAV552nAw3F+KBVgf5l0zqWjLyScrAeo/B6AWTANDJJfm3d+ad8F2aiLvzY3tPW4hjDWCmQMvm3rJ10HrxjTDxn7QZ0LtlIhucybyOzJE8xXzrA3D3xCCcH5W67Lcps0Jpr6p+MT4w4t2nLLvu9XWQgxMhI+Yfko0s1OMWfTuyLXdsAAaNT9NpINHNMLl2Nv8gQ40S4D2wapx99iopeeM0NIARNlKbt/j0DGLUzgA0jNrelFDxMyibHanR1ovzUElkNkZp+s2W4/a4Ixh3xYFLzY6tn33h2bw4cP0BniMQATs9f1rFDYYary7CNayakmKHPWoJkYi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 08:38:30AM -0700, Nhat Pham wrote:
> When we virtualize the swap space, we will manage swap cache at the
> virtual swap layer. To prepare for this, decouple swap cache from
> physical swap infrastructure.
> 
> We will also remove all the swap cache related helpers of swap table. We
> will keep the rest of the swap table infrastructure, which will be
> repurposed to serve as the rmap (physical -> virtual swap mapping)
> later.

I didn't look through the entire series, but let me ask the same
high-level question I asked before. Instead of moving things out of the
swap table, why not reuse the swap table as the representation of the
virtual swap space? Seems like most/all metadata is already moved there
in a nice concise format.

> 
> Note that with this patch, we will move to a single global lock to
> synchronize swap cache accesses. This is temporarily, as the swap cache
> will be re-partitioned in to (virtual) swap clusters once we move the
> swap cache to the soon-to-be-introduced virtual swap layer.
> 
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>

