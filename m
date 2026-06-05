Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC17CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8896B0096; Fri,  5 Jun 2026 13:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0256B0099; Fri,  5 Jun 2026 13:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5D96B009D; Fri,  5 Jun 2026 13:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC9B36B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:52:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7588E4023D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:52:51 +0000 (UTC)
X-FDA: 84846604542.06.C3D8DDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BCFE2140019
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:52:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvoZr4Uk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4zIeQlvQf78FCoQzZFvkcKsrBnu4s0OZArTXsfT7tk=;
	b=FJcSL/7QsZcA/KY5R/Yy5bVDb4vGfB3qEpoIwX7edBS7/Chb1fxDWjbWXDAcLhHPfMmkQT
	zWVbhn/d4itzS33NYav8OJONdaWar76PsOzZA+bHhD6uCmatvBcF4kbelSbXaYPKcUnBTv
	aNd2mePYzJbxGkVWwcrzjyoJQPTTS8I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvoZr4Uk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780681969;
	b=O7IrI7MMuWPOx60/efMqu8OEBmBMEHi7SR2HXZEKRVfP4AKgKWyEPu7Uv1A73iZDCbJubt
	uKssQDgFkg7FweUtBLwgzYEB0fKDXGPuH8HOA1xSvVfmq8gaU2b/hKuFGHlZxi/T9qAe5D
	gn2MoovkoGG1cErZ2/VHHeyC4n9tfKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 230EC601DD;
	Fri,  5 Jun 2026 17:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D549D1F00893;
	Fri,  5 Jun 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780681968;
	bh=L4zIeQlvQf78FCoQzZFvkcKsrBnu4s0OZArTXsfT7tk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XvoZr4UkuCFmy2Kh9C/g83cu3QpLQwjl1vpA4ZGtxKdPuCvStDsSjnA7H7Af0W7ON
	 KkuUi6zj2VK6mIf+QgXu2hZearnFIFEjHM/hArCZuGvwCoz1oJ1Mh3qJ6yDl1tOvCz
	 muYwWJwzR91ZlsRB1cz5q+5FyX9tgtL6J+vcPEQLET7j1hiTiLDOsHqo9HD+oyQTwh
	 9OPkyaLpG7Hv6s2gKZI9e6B+0srPLbcdkI/knDsdifekQfRPev2j7Tpo5DwW4uVBc7
	 N+A5GKOXb9i7mTIzDE5oTmfGA8LzmZoUGWpzyxy5NxsolIHRRsuVH6RDneMkmNvSdl
	 Wg+Slyqu7eLoQ==
Message-ID: <031f6304-a145-486b-b2b9-569cea4102a7@kernel.org>
Date: Fri, 5 Jun 2026 19:52:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 14/14] Documentation: mm: update the admin
 guide for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Bagas Sanjaya <bagasdotme@gmail.com>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-15-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605161422.213817-15-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BCFE2140019
X-Stat-Signature: i7gpj8rosge6tq5tdmt7jfii39wn19as
X-Rspam-User: 
X-HE-Tag: 1780681969-136858
X-HE-Meta: U2FsdGVkX1/UMub/bUWurOzQVhe2rppWbRAEjCDi7QneVKAe+31BpGBNmePKVJ6yTiq03jZwUKTiBgfccQIh8rRCYPcoTv0vNgsKmDSY6uvx6JHT5itVFCaP5vajjvmwGv64emKsjQtblbjx/rVMHyQ8RmHzlNXROfM14CbUGQ7xbF1o59mwnEjQpj+xQZOCPJEJ7b6KUYGS+GKbLdzgfDZUzKVhmKHaA0FXCn0A222FcfVxqHWC1fa2OIib76QwlXAAUR+XQq8s8+4/FNcQqBX0ZJLyEK4hXPcSymT0yWDbmEdycio8c7G0nse0JkJsj8gY7ZL+JEhHWarYUNdECcZ8KYjcY7DW0KfEDaEoTpegRXeIIxcnc0Ynh4LpuCnxOH+5nFKeaZ6LcQMgf6GJr2pl5wblwVRJgOgccD4thVa2yNQCyw1IjERwu9gw+Gdz9rOTnLGkfVkjtoXnvPlOGR2yemV+xVhIDL4EMjzsgjI2Xu/6ysCTgh92xWG6UeBpYAdOShlkrp1cYWvOuOP0bI46aVKU9FgAEc3VvjSjRYUrcM8u1SQaQIqzHyAlGxPVFUkO6SwulalX/peGdPWYYSoiYrV9RhSJaaBm5Y72LU0JYu9K2tiqe60rgwx0gqUV+jh8K9h2ha+fPiGtYCgcFM8G6pvGyngYjNHUfnpcgaRm4KCvx8XRiaD8ALuLxwfVgDJvjATzlZdioqYh+AjlTvMa6iBe/5q/t85Nw4tdP9CwKPbJD8at+aUfVn3OuRumUwGo6eWuYWbgnkPEkM4J6VLM9lkkqA7O/qWFTQlL4vuvtugnrWOHTJTlo0k38J2RBG5CFyh2Na2WbSFjWwtWLVPzBbMSRzOSbkTM3hP5KEgOtsfQNqhSQy3Khli5edrls9npR+4p3604ScbM1hbBSTYbSO1dQ4CZomwAljVhFKVIFcifEEWG6qeGFW5EwZwHsT1pWNhKEbS7o/UEJCA
 Z2mVEobb
 RROQKqyrmTW50NpnKGESOc4o15NwApmINVhfx4LnHgDBudsgowXrAZ8QP434U046g3mjWKbJTrYqdrfrAV88+tIU/PJXndmTfL7L59/iZJKCJwaaKL/oVFOy1m7PR4kylFEaNTsgjzfexTVaMj2D0FWRHMlfDBsUzk2Ffpj3zTLXqT0YUjyKjBPDCqm25lfkGlx6vpTRdMpGE7MXQWJjsoKQmoH79hJfM03lAqfLp4cKR8mS7G1p5mXp7vyglWgtrqRQINMHgDWWJtgRT7sNu5tF4hqCbq7NhdBAPwv5EVYx9F8shKYSlCXpJcqnKrl0/gOIqSShjpopPLfbDXxSDsB2G8jeR3cbt0PqUQRXclyEDPeN53pz8L0hotolbhGoFy627UQ2krtB/bgl5qSlL/BXT5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:14, Nico Pache wrote:
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidance on how to utilize it.
> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

