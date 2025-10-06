Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36737CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5F78E0014; Mon,  6 Oct 2025 09:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D258E0002; Mon,  6 Oct 2025 09:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CADF8E0014; Mon,  6 Oct 2025 09:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 524878E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:53:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1F058781A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:53:57 +0000 (UTC)
X-FDA: 83967832914.29.9FF3619
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5E1DD14000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:53:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759758836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FEJ/8bgV1ek/fE6kHbi9de5agG1iCj5gCnXHtuWr7Hw=;
	b=NnKkzul0Yt4PwsBfSQfGIlJ4/6AbzDnXi2a9cje6hswDGqaUcakrxG5RlAFu1SgApdJuQM
	6M2PhouUq/MZ7BFWW6rXFAL3s4o0fz4yx+nPYpeUyyX4KJ0wvf061qW7R3+QMvbiie1/kl
	zqxO+7x9OX2Su+kgSk3ur0NF6pj62sk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759758836; a=rsa-sha256;
	cv=none;
	b=BBCCcLdbMBry80XWOx2moyZ5Wg0W39pk3TWMT9ptFpPyqBWXbgDX6Osj2MFheyhqRS2CDK
	0R0WUQwQasJVcLQRTZsytqjK7fy8xuZihdgHGEgZrTmnQh/hinRLEZonJgmAkLzgtNaKyr
	d7vQCfBTEp0bvYpzCWyHab3XzuwYXXY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AFAE1515;
	Mon,  6 Oct 2025 06:53:47 -0700 (PDT)
Received: from [10.163.66.9] (unknown [10.163.66.9])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECFD03F738;
	Mon,  6 Oct 2025 06:53:50 -0700 (PDT)
Message-ID: <5b6f302e-b2bb-4ad5-a8d5-4e1a8fa2af70@arm.com>
Date: Mon, 6 Oct 2025 19:23:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: Consistently use current->mm in
 mm_get_unmapped_area()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251003155306.2147572-1-ryan.roberts@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251003155306.2147572-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E1DD14000C
X-Stat-Signature: e15b1sxsgtpx95frswigiaqc3f9mh7pw
X-Rspam-User: 
X-HE-Tag: 1759758836-168976
X-HE-Meta: U2FsdGVkX18JhZDzF2L4PtZIpP99vfkCoMw5IhVwbMIMEZ2mOPuaT6HestQxd0W5lxTb1y8VJtqWdSdlGy7Ja2HB/5UvXs06MLjCf/TsVvzQJKBisrXfsDL4E6sj8ch+ghFWxfszPFH//h1Pv+bIfqBVyTlKlwYPQtsXw+KteJAKW1q3ooqS7YpAVGrW4kROi2OT6Y4mZTg2rDD7SJ+2wb8qunaHfZxSSLwlQu8+alvM/HHZZJZoSTa8fgX9rrWMcpDE1ULOmO8vZ9encKXrpAL7AYEQ575QKpJ0BH0wa4h5f7S/KI3ao6iNh0Cgm+rpQsS9jM3KMWbcaS7qwgrkZyQezGkhFofV/93ANCCmoH5lKskZdTMk1ctIZg0NJWiTdVY48PwVHjQ3kWPJptPNzNblrw3skqdwfM28az7iozf7vcNmio7b7X3Dj+p+qu76NowQdusVaIycpWyD375SvnfwW0wE7s0RrJx5eKMyqRLFKRJcbn3f9pHkaCgrfvBcbU8Mr7VUVwlFrEzCLOq56UceTYZqKqpJ73q22LBczoHT92rEbLPEFxIvsng7sSO1d8p4WBwancUcN8xtvzbYIFbMX1DQk6du0Xl7FcVvdZ566m1luRGhpgv13GqmypYMBagvrr/OpyCZ8693bJDvrvUBG9g8JMOmGslHisKycE9gDU6QSDXX2NCrCmH2UYkvbTMmEYN8btXo9StTjXm40FGZXUfpS5Iq8QsaS3aGZziMoSB8GLIVL/Lf5K7cPKME0kDX9V9u+j+Hs9umPmDZT0W0RiTe3eOOIOzxNUeOThE3zL5qXI8txIUKPcBDKho82EdIyGB5a2JiXZd8Ikmv64cxY0py5gT82pRcjyI/vfkk3k9FWte8ybznH1gyu0HJ0hXpBbV70G4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/10/25 9:23 pm, Ryan Roberts wrote:
> mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
> arch_get_unmapped_area_topdown(), both of which search current->mm for
> some free space. Neither take an mm_struct - they implicitly operate on
> current->mm.
>
> But the wrapper takes an mm_struct and uses it to decide whether to
> search bottom up or top down. All callers pass in current->mm for this,
> so everything is working consistently. But it feels like an accident
> waiting to happen; eventually someone will call that function with a
> different mm, expecting to find free space in it, but what gets returned
> is free space in the current mm.
>
> So let's simplify by removing the parameter and have the wrapper use
> current->mm to decide which end to start at. Now everything is
> consistent and self-documenting.
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>

>
>

