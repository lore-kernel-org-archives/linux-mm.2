Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068FBCD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1209C6B009B; Tue,  9 Jun 2026 05:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1CA6B009D; Tue,  9 Jun 2026 05:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02D46B009E; Tue,  9 Jun 2026 05:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1966B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:50:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 847581647EA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:50:39 +0000 (UTC)
X-FDA: 84859904598.18.F8E6A89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A498320003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:50:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="isVl+sB/";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780998637;
	b=VnK+rLabvOyCRhlij3MCzOnRSw7x1HLa/Skbs1SJq3i/DTfLTC4bI60T+hZhIvf/uhX+z7
	ll6UN5vTwkiMs2j4trON2P3xr3/C9DvS2QDZV6E7/A38V1QxAOFb3fsyB7NWkYVv9syd0p
	+CT2yahtTW+7AYwtBGJCpu4mCmsuQ08=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="isVl+sB/";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780998637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npatsvxFpEUExBZprH7y6acM3CECn55+b2n/zGR7Ocs=;
	b=QK2yATrvgaMbi+OybbK1FLZ1qURcKprWWUjZS0QIN+chcv1xurvxSejTzT0iFXB4m4fnIR
	O7cZbKlI16ACGUbDF+Bm52k8iGcpwU6YE3sbJL3k4bH2No4SjljzU07TQ8lPpw/d8iWY1+
	Qf6HKCgmTD9wy9XARC7RNalnCpsTtak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C23F601DC;
	Tue,  9 Jun 2026 09:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF67B1F00893;
	Tue,  9 Jun 2026 09:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780998636;
	bh=npatsvxFpEUExBZprH7y6acM3CECn55+b2n/zGR7Ocs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=isVl+sB/Uumf+OqYKOTAI8zicn/UuohcBTKeuFb/0b6hIUMtYcXspbVUAScdcv50U
	 bFGCilGdEQU0iFaR55wjMHbkQtETqtNBMFuME9TocVTyEXLFqbpNDSPo+7qGHWlPN4
	 Vo3i9TI1n/e514PM4BEDz6ExnBn4n/Ncc/U6By1RENU5MGOeMXCGduVeH81laDc2xk
	 BUITZgnj+y5QhtuH+7uQefvkUcxQo43DRBnqosgyxDlRPNCoHeUQ8VM2v8KvMbh2lE
	 S7x1eXW/wbAASegQ8q0+MBhA8q+z92rG+ZRUkpdntkNuidXUamRJBV1UJzQxQb+nxZ
	 Te3xK2jlUetMg==
Message-ID: <835c3fd8-635d-4380-b14e-e468eb0bb136@kernel.org>
Date: Tue, 9 Jun 2026 11:50:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] mm/memory: add memory_block_aligned_range() helper
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605211911.2160954-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A498320003
X-Stat-Signature: icc3jffz1wauqpnxp6umdw9wuk6bn13d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780998637-377366
X-HE-Meta: U2FsdGVkX18A7sA+cdHvENmLqZNkFl/Gm+0oc0vKkdN91qcSENkQ5IzOnuCVes8KP59/qhVsyFyKXiJKxjIOhTwMyLG7X0M5CLiQnkRuDkT7xD99oZEkyE9X1hDV/11WjTmrjiba2cpyY48sGTViBkK/5ZMoe6rS/G0pSQ/WRpCxIKXi4iRWPJJ2neoT8tsl4bqOGUIWiXPRGbPIw0nAPDzTdniMw/1JDJWJ9HssmaZUNhrdXQGkPTdGUzNEnkF5VyQKTPHt5jo8cLwf6GSHCyczfkbVTMlV4oFrQUC6q5jCwEAOncTKDKDkq8qUmynpBzdRClApDdM7qOEV3gwuw8z9UbywPM0rsiFECwnjx5fw8q2NhRgBltskPBcfj1KsC0A48udwJ7j14DH8CyQuit7xCx9yUen25A/EfzcuHsgJKcjFf6pOHCfxdpsxXbaigm37wUfD9YP+cPC0oTJAEUYWo/QqBrQCe9N9vXpEPVygJvPdvD/VXpCcNgtG1BIDdfHFPaNwiW7rV4AEorA0bnOuX0JI+9eQ7X+mPos31Ih0pomJj1niukr+Fg4q6XDijNnJExmiU5jl6zWfpmy7La08NvASIie2rv8w15o35jg/Ms2YVXB9u12OMx/4dYrWgx31iKC9CAOgoIuYbs3bLE7nKZ6Q4E3ivZVP6qXHY00dedEuj7smMDUUy79fHjMDw0U/mrBgQqqdq0iDMBkXVLhFkfUoN7Sd0nU05noyZMGs6LG+F6W/74ThrswZI1MduBpE3BG5cudkOiOElJW5EHKD7ld2PWSWZ98/jTey3wOvjergtm9jD/PPl3iEppX6c2EbeqRoxA9GgsxtGlmLEuGov+1h0Csc8m6uz74Ms/pUD/Jc2Q7wRMUTHYx+0px8Q1LQHOBktP7laA7Qlvy27AxshqXMOP8rKtc1D1IARc/CfBAQfhj4xwt6os5y8oj6+q7CAheZHUi3WHmsuoO
 m4iGJaNK
 kgPDSm1ePOyC8amIJ/VW1HIc1E0l/3TpADfUDriFq1M1Uc4JHypmMpPSR38QHEj+fmp1S7k1Iv7AzkffJNpT6y9idl/Hn/o4WnhmoFFW9YWQ/1vouITByQ71RewL0Iu0IzRutYTW8KCw/x5e58eX8Je9Fw0qViAaXG3vIJC/NVJYnFYU8afG9wgTwGlC8G+hMm17IxaTM3rtyz06hi3WW+l+Aq9dNkC3lC92xyDXl5TQ9jLGUXuJynBSsmIy6ZeNF1pEKmWxuDSAffwLVmET4lOJWa8W7VYDfXYX0zOcFW5J0LnzrBHf7qRx8B5pG7/tWaK+EF0k7rdK+gOha2ag3zq7BvHMJNfktK+dsmiAiQDpcLUruWOiKXq3vvmq79DOHiYrL/k1HFAczoDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 23:19, Gregory Price wrote:
> Memory hotplug operations require ranges aligned to memory block
> boundaries.  This is a generic operation for hotplug.
> 
> Add memory_block_aligned_range() as a common helper in <linux/memory.h>
> that aligns the start address up and end address down to memory block
> boundaries.
> 
> Update dax/kmem to use this helper.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

