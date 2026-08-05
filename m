Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC1BC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4DA66B00A0; Wed,  5 Aug 2026 04:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEA46B00A1; Wed,  5 Aug 2026 04:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17366B00A3; Wed,  5 Aug 2026 04:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A7C6B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:15:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D67F1C0C1E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:15:49 +0000 (UTC)
X-FDA: 85066507218.03.62B9574
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F33240005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:15:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kHT+RewT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785917747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzmyTxvmXxprlAPCgRd0UqqVb7Yl/SSQCszNPTVuf6c=;
	b=4vjU3Ud/9GepEIO1141npnakBWxG/GWXe9nPUxcCFoIBI488yqSRezjfE4bxnRQpB81Ks3
	5k82imckNXeFUAFBfGmYkwtYeNy0Hi7TCvLT3I40RivsZmtPGru1SuQfpuXENdJptBhFMz
	JULicNPNw5+O6mSDR5D3WZBcpZ3sI9U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kHT+RewT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785917747;
	b=iAV19qcwBdFyJQdWsNe9JOtzM3npWWanqnwq8eYliu9RUnQEhwkyyUXqA4rPQt/Biv+H8c
	x5k8czCb2gaAwBT/ebZ9A9Hyb8LQirsTy0wUnMer7nthDb27afEl5CxMEJ2XSJCV5yg8o1
	9JkaX3l06AfYBPS9F90YkibZsU/+EdQ=
Date: Wed, 5 Aug 2026 16:15:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785917745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzmyTxvmXxprlAPCgRd0UqqVb7Yl/SSQCszNPTVuf6c=;
	b=kHT+RewTiod0knktRTZrH4gLYx9KBQgtTZlBLKpn8BzpMybhx8PJQcORpuSP/9NSdVMd1O
	DYuIZo5245/oIxf8v+YGysl9JfhluavOJUq05+VlF42Yg2ih1Im8PL4+J4V9HywHD6SYT9
	dl3d23iKXZ6g/dQjZegWGZaNmaAOKmI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/11] mm, swap: serialize xswap map/unmap with a
 mutex
Message-ID: <anLxJlKBnNUwC4BA@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
 <20260727140503.1060918-10-baoquan.he@linux.dev>
 <CAKEwX=NNzJ-7uoHFG8jxeN=PYi_O9D42xc4or3O1im0UJpF2ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=NNzJ-7uoHFG8jxeN=PYi_O9D42xc4or3O1im0UJpF2ag@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: sug7wh8sxxh3h7cx6dnq67sfb4hotixj
X-Rspamd-Queue-Id: 4F33240005
X-HE-Tag: 1785917747-496259
X-HE-Meta: U2FsdGVkX1+PdMsXaLcVEsFf4X1ChWXwj16VT9ejr+ySvnv1VGni6TUCcxuuj6peH0MyN1dHfDCfc3vyjwKaqW4mV21jjzKktyDZHwQN8KsnKeQWPFj/cHqDsveM/7Qom4Fy5RH7Dkx+efXqcj8yahGGka4iaxLN5V6JjkXPeikBb0otTG0BTv65yVSjncsyptvo0mqgMfYphnc3oYzdpSc27QvLZ1WU0RI3M2FRZ7Lnd4AH1G16ddI2V3dVrYG2HzaRK/8NoS99DbV4jmtdP/Svx/hnUP/0NS8VHIPHQ/1ReziBc6RIgqAMu5KCvhY3x8NuAc/Sd9e2iDjI5WdqmPyW6vWsEX5GRm/i9W8mKd46yLf5AQWjKQnR88c142MVF0JzSPvSL1bKPkanUA3Cz1N9oB2Nb/UxPnfHW4ngzIXWnqrm6CTKLjkqlw+/B4Kfrvb1aPA6Wra9eiCyH8/VtH1X2oT/KMPoFBt3Lmdda2zwWl/qoQS8zFQ0W5RNCFpNCou+eXluaDumEk206oWUXUKqT/3669vxm+kqrbK7Y+VRd3RNQXy/U2PJoMqkTg00L7OGNgdTBB3lnBo9xBTOwlbZlm3MFmvwfolhfZlBCz7G8rF8tWQQ9AgGO8jKuXIPlptwW24mrbiw1yNro0k2LEtqIMVtNiY4JqoEu4cakBUcwpKYWeCp3bBClCZ4BU8gFJAIsnykNrk3WCT1MImzzdIcMa2rMj/5pAXRmjbh2NTfZL4UQ+xkzMk9db18YX43wfUmUehDYzYubxGglrw/4i63RqGTrne11HW1PG9QCXWcwXSZz9pkxHREBt+wNiDEH9n2d9h4LZ/aeh91NGwby5vSOZmTCbEPfgcZvp+7GfQeX1wQmdEbBoLJFF9cFLaz/yAondHJKx0J8yow6186vgwT3l7nqi7A9a8ZmJ4tEBRMz3tfsHZHUMmPOiHDdHlPW9/SGZ+qJotqKmoJ5N6
 ijyOxvXB
 v0YYVJkCPZfzA+VXp/ZYGctFvRUFXKatPCb0A9A1JcrgW9bMGd/A1avGb99iqPz2yXtDg+OOTtTj8GFPyjkFLIaqz04UylDs2sfMcGUVXiYklthqz5FH5VRJG+PMxx5tGebUY87fx+azKdXsnaufiKNJlDmw/cqqLcTooBDScTU/Sw21vvn47JkK42Lk1UlKfTYWMEUlxr3I3YvoH+DGnXgibdPMvmDVUOsO0YYHczg5rHw1nXf8N1E+4swvvoNq68etAZ28wrOJhc15hO8Ao0bJ7ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/27/26 at 08:13am, Nhat Pham wrote:
> On Mon, Jul 27, 2026 at 7:06 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Concurrent xswap grow operations race on vm_area_map_pages(),
> > triggering WARN_ON(!pte_none) in the vmap page table walk when
> > one thread sees a PTE already set by another.  The -EBUSY safety
> > net catches it but the warning is noisy and unavoidable without
> > serialization.
> >
> > Add a per-device mutex (xswap_lock) held across xswap_map_clusters
> > and xswap_unmap_clusters so that only one thread can modify the
> > VM_SPARSE page table at a time.  The shrink path is already
> > deferred to a workqueue so it does not contend with itself.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> 
> Seems like this should be squashed into one of the older patches, no?

Both is fine to me, because putting it in a separate patch can get a
specific log to describe it with more details. Have squashed it into
patch 03 as suggested since they are small number of lines of change.

Thanks
Baoquan

