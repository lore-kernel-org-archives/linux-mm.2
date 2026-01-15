Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0520D46603
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429196B0095; Thu, 15 Jan 2026 12:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA526B0096; Thu, 15 Jan 2026 12:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDB46B0098; Thu, 15 Jan 2026 12:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFA46B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:26:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B58B5140402
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:26:30 +0000 (UTC)
X-FDA: 84334877340.08.1DCDBF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5C671C0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:26:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ERo6pPRP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497989; a=rsa-sha256;
	cv=none;
	b=1CBFDpOxw3jEVPNTlnedxM4HpbU2iBYa6NM4SoHp2a9cd/Tg8ZlbTlMVwrgZT/m9bMSzM+
	xeK0p2Ob7wr+V/dtFJd0e0I6a6UZLcyZXug8pRtkwG2K1xCHEFrNJ2VZe+psXU81A0v76y
	yBdNpk6wKIvDDZVD8bxvOrzmzYYL9Uw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ERo6pPRP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/jeozxCdYsY4xK+4tAkz+O6OeGUBZFY8ek257m8HUw=;
	b=g93nyy8D+o1f2IYYYIhVtKWPyWUzTYfmRDj/zfHEc9CQWT/9ZMovY/lWpj42r/27QEV/6X
	Vt3fVTe/Ww+K16ruPciE3KWSbp6GOvsiWncmAm5Ha9hpT4l7TIXz4J6Mh5PWqvbnNA7WWo
	cJuHvIN6IujjpRPgaatowvYNz4LYIDs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D94284085B;
	Thu, 15 Jan 2026 17:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C4EC19422;
	Thu, 15 Jan 2026 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768497987;
	bh=3kMg3+tU6CStGaP/2jSc6EBS4YSAzWA1eqL/7/QkxAU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ERo6pPRPc9N7MiF0CC5Ky920nNhr7uR3t/RZtcVc8WK7Ihzyq0keU29lB42a7yKlw
	 HtTmJBYUpV15tthGIpOjiWPn438FBi1t2CXbnnOgKAoQmnpyqrpMikuWnkhtbNKxIc
	 swl78vFHVCxCLJC62JT153qN6bFQi8nGdaA5ymtRwnVkCeH7B5lpErjGNvFcegPAyj
	 +oI/PiEvMAnam5dgCyFJ483ZCQtF0O1ODBfz2qaoYa/Pe/KauGBc0oNK9XrWbBAKr6
	 RpB9m9+bLwQ+tuHAZRACbND4oN4AA0PFYgAZLY569VsXsMyt/8+YPmpPS1RzerggB0
	 MtDke8z/QK6wg==
Message-ID: <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>
Date: Thu, 15 Jan 2026 18:26:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] add runtime hotplug state control
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114235022.3437787-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5C671C0004
X-Stat-Signature: rb6rew1ttd86jqtu7hgms9fa7nsuh434
X-Rspam-User: 
X-HE-Tag: 1768497988-205862
X-HE-Meta: U2FsdGVkX19FwT7cYQ1Suf/YxMSar4kOYm5ZFuiPge1hmlhB0tT1YcHEwcuEbhrC1P9yfNHtT4Q/tSn9Lt9tb1auP92sVLwJ0dCzfs3FGyBZBOCEU6rK+LWvFWxucuOEXTtOkFUv3a9rK5J6n8T2G/8rjB23K2qMvvJkvY5Td+dqVWmIMBDFewzvLP8AXE04/XQGVo+iJBlOsp36D3t0bDujDhd3qSjhjts+32AiOrY84iz3UFTPa5m+awVNWru48xKt4ddibb1AezcTUFLJZrxHKOcWQkOii609eMTWZZDjMPFtFnHzyvZN7XhpJi6forPREc5Fre6/F4Z+TTiGkUZWaOPkztwxvc9E9q9xozRWnJ4/4KlqGwCBaEMiwrmkmv9H1jXlYBXTe04E3TlO5hH7flPX9mDsu6x848Dp1N5ULKzxf9Ywb2+qupbhnN6MRUEWbhfKqlxUMz/WjjBbEl+bfM/tjiWK5CEG8ryY1SDfB2+Y+obEMDykMqhC3+T+HWZFrIDYKxsdaONjEX+W2dErs+DO9nhIWLzDjflgc53sqgqZHGi79BgrUGvCYDuY5xJ5YHAQzmgtdBEbLERpRU2d6tZBvFceS4ebiv1TF9Ve8eOQkP35Fif5/mZU8UTn3AiVIlcTRxxdv6Ip7IWhVCNJh+/ZXUlbf/dsz70KwdpDlKkevyAnT00v1cOMHQhXS7L7DcspL52aqUZ2ppmax+JmWAAX6yDz/IDjLmS/dlMaacTVgP62iy4fP6Pp/3Ewhf29LAnjpqinalATrt/VNFAClW/IDOHHopgPhIO8sb+J0Xoz8asBwRfgREpFX3hgftkLjSc4VaeQiATgK9OvIAnJ2t8kzWXB0nKpSUvBIyH8aiH++ZJ8JDkO8CRiqzlhaAr/3WqMsyo4AQFwqiOCLn9zHQsXeBYHkAz97tk9IVTPFGLD9aYnCUqJVBTk3JUYCiby/GVrgz/Ppr8/KMb
 E4bRyPTu
 RNY2LLWtwvjN2dJGKktImC8lxMvRah4/FDKa70ycntYwUe3J4CyYWSdlUUoR5hhqhEHFqXX14eLThvNttEsL7QxUc5A7lX49e5jYipaAWtuRVEWCh99B2KQ+Dn+QY6ZhLS5V56SSOUyPtbZGyZGG2myvXzoRXHE7NkMODcBFyv9Tul1aJ/b3gHPJNOqkTlvWGX3dkuO6RXjPiHeXx9HMfKxnspMgWnEwbVjvl6WfbDMF/Nk6c+EZzuDw/3daiRxm9s4X8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 00:50, Gregory Price wrote:
> The dax kmem driver currently onlines memory automatically during
> probe using the system's default online policy but provides no way
> to control or query the entire region state at runtime.
> 
> This series adds a sysfs interface to control DAX kmem memory
> hotplug state, and refactors the memory_hotplug paths to make it
> possible for drivers to request an online type at hotplug time.

Gregory, slow down a bit please. I haven't even had the chance to go 
through your replies on v1.

I'm currently on PTO and don't have the full day to review stuff :) And 
boy oh boy, do I have a lot of stuff in my inbox.

Maybe given this is the second time the patch subject is suboptimal is 
another sign to slow down a bit? :P


* Subject: [PATCH 0/8] dax/kmem: add runtime hotplug state control
* [PATCH v2 0/5] add runtime hotplug state control

I guess it should be "[PATCH v2 0/5] dax/kmem:add runtime hotplug state 
control"

-- 
Cheers

David

