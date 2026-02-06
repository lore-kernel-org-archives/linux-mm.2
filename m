Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34C6EB28F4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659716B0089; Fri,  6 Feb 2026 04:00:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644766B0092; Fri,  6 Feb 2026 04:00:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D036B0093; Fri,  6 Feb 2026 04:00:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4055D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:00:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD8D013BBEE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:00:33 +0000 (UTC)
X-FDA: 84413435946.05.4ECFD95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F089712001B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:00:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6j1z8no;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvc9exR4lmlUC+x59cTZfqWcxDZzkLPrfzlnUPP7c8o=;
	b=Bo3I57PNL7yOS4JjXX2FFaz3A7QGxg0GtiHQFwgIqwY50v86lDCxJMY9iJ27jQ3Szgv9R/
	z1gsaPujL19QbixH+2zfVYA528HE3MBnFAv99j6C49D7+c1C5xYXgRzqZelI+LfCL/EeTW
	yPOVsx995CM9j5cRa3N7iF+iUWAAAsI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6j1z8no;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368432; a=rsa-sha256;
	cv=none;
	b=xDAKCyi1RHdCK/+ONSapSV7FwNnoSFz720Bp4DpK/Lb8dB1zYwfgVCpvGv6mg00JQ8HcX+
	BrO3/P43Wv+YUkZsRpVubhWYBpmXbRb/AAz5MUN1cctol+YGUdYcMtHqZwgXRu0dy5W91a
	I0NuF1KgDPLPlfZG/ZDEoECOsX1Ll8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CB2F600CB;
	Fri,  6 Feb 2026 09:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FE9C116C6;
	Fri,  6 Feb 2026 09:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770368431;
	bh=7kbKaWndHwVcjwzjrw/nCKTho2SsZNBybxIV+9B7yZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M6j1z8noyjDeshwcAcpPlo3uI3Gn0y10+P9ZmDbTWHSHCPiJCl+GDiHCTcfk8LLPb
	 AVV5UjOZapQt/7rRp56VT0gV43hKaZld7yDo0oj++EdF5vsvNfig1rhAVcQwvjz+hA
	 wcwbuBgboJQmh7tveMrIrC153XymblYrJURUXtjAv3a1vP83qlBWhD/VPZAxCkMiJU
	 pvbaUrI1WAG/XsMPxlT8kD2cOvtjh44NrZYBYoWI5FPySRnoLVyDUvNcPPyi4MD0YW
	 PkrSb6sUH6JeAAXthe9b1ioolfnJz7gRMFwLO60l1LF8rnd9VFp1HN5bfBsOHwB3DS
	 MA7wi4K8g6TcA==
Message-ID: <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
Date: Fri, 6 Feb 2026 10:00:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9pwgfr8s9kgdhaonwrxyax7yngh6arcg
X-Rspamd-Queue-Id: F089712001B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770368431-462136
X-HE-Meta: U2FsdGVkX18ytc+Fy80g8116dWviGNisodw+HZTvOjc2dtpRfM0J6bP+ZQMsOnxgejZb49DfEGxQLoSllZ8E78/IsCi4qH3bUuVSBuWNYoqqSRXRFmKmR4KxVtZWtClGUV3MEl0o9yozhHFI9YE+VMTSCBoffZgs4JP11LIGmXBIyexgSYbJxctC5XjALFsq5f7tOwAIfoxSagHVPLxG+k0UyKBsdCR4YluX20oxDbnP6kc8j9V8ho4vxHV5PZXq/fAXCk4Psc6C/I3tVspzv6gARbRJnA8l/DEehqInaHClvbjJhsjPMk1qB2AzoDz95xy3n8MMjNJb8qaVpccR7LlncMx4sAgFjctYY7xZa99UuqDgRZdeklL5S0sxcX/tE6OfBV4LDO7kIZvIaBKGsZ0GQ8/SLQ5/zOjiIexsqCVDF4ILR5jGB8+vS8N/HbxPfHk+E/tScTIh7gil6A2F0u6Nz2HEVEOuavRxST/N4fC2q3PHMt6YY9OWLzEEyuTnLiqzVp5tS6B84QJ/XT47Xz3D00WxsrEGEJ10sXKdK1EJuq/+n2Zfu3oauqZhK1dCfKk58QbwfqgUlKQtoHh1UA1z/Io329jEhXfmmjVoxqpGyyVntd6rhxkWDMdg35UMndxS0EUXO6p/DScjLUC8XGTp2OlFry6N3LHnzScaknA9Bom+jXVbnHHG1Owk1O2nLjZeYaK8sq+OTyLGyEKgTJDXpA3XMkmQ6AttyL23TN7/ccwRIfEWP9BWbdBfCq5Y/Qnx2t8HET8jdpHcUjVZv4GIbiwpGu++uSBx7dRQuzRphn7EuPpUL/HrFHy5NYhUULz5ytR62NImdyM6DQAyUcDjkr/fxFZEL2Iq8oZTm6LA8FKd7aiyRRnVS+9teteYUTMciG3SFBhK9ZdNQc4bjNhtpwfXZHB8jPCE9h3KmzZ+yKfAS9fmAVbQe6M7WN0ITNk7k7fOSHx1ZtrMnsU
 twPh50rt
 0n3kP36vOVJfuyn4NUg9u0qwJlFRpVUvucBVKJjFaEwvAgj/prJqEAvpE0oikOllI9uREANijkL7cc/4tcsmFayyTr3PDYzFGIIj2hcVAoIohyjZDWXFbkzRJpACpHxrbzrTzE3X4hK6+vY57VNVwi9TT6j5o7r+ByzaET2toCKAaiXtGJNAbF4NftkTC+q2qrdKZsbAq82wY/uF7hGnqhHZt/6+wGMehpecQoW50pXEm/NjoR1dzUcWGX7aJwSojr5kJ6ncS2ggE6dbYhw/k3G5qMpM1I9fzgU9a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I recall that there is a notifier when the system is preparing to 
>> sleep (pm notifier or something). Could we simply hook into that to 
>> tell khugepaged to suspend+resume?
> 
> Do you mean “struct dev_pm_ops”, which is used to register PM callbacks 
> for devices? However, I don’t know how to use it with a kernel thread.
> 
> Also look at how kswapd does it, kswapd also uses 
> kthread_freezable_should_stop() to check the freeze state.

Right, mimicking what kswapd does sound reasonable!

-- 
Cheers,

David

