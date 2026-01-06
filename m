Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A36C98331
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94F26B0093; Tue,  6 Jan 2026 09:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FAE6B0095; Tue,  6 Jan 2026 09:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40F06B0096; Tue,  6 Jan 2026 09:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C21396B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:35:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78A911AAFB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:35:42 +0000 (UTC)
X-FDA: 84301787724.23.6FD804D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 994C7A0008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:35:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHWmxWE8;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767710140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9Mr5MCGLsJYJ4BGgidTrIVqbg3Lz/yZNTDt3U/JSAo=;
	b=Y3F8FGHezhyzniwpJ4r5Mf2V8ZdB2TJSUqugrQevdg5NR8mDu6ir6WVD855v7pU0rdVIHo
	5SGnL2bW8XhO0LzobD3AKCwEFOFAmsdCFfWh55VgDQw8fVw3J4jiYVFikJL717wZ5A/m6Y
	YtXlOu69Jh3gnHZ6q5ynFYw+PgcZ1pE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHWmxWE8;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767710140; a=rsa-sha256;
	cv=none;
	b=V6TmS0ZrrEYWF5fwUDm8HgvKJ4ArbSF/1rW1THG3f8Adm7kVRq0wbptL+jNrQEh9P7COe3
	shPSttHvGQCfl+pctTsNexkCOtiQYyeFiYdvAM7bEkwR9B5dE+z69UvfofzQhunXOX1iLC
	bt45IXJnuwB2Cw61/S6oZxkS6IMsKNk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B01C741861;
	Tue,  6 Jan 2026 14:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00765C116C6;
	Tue,  6 Jan 2026 14:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767710139;
	bh=3aey1rxhyZ3DGxEvx20ao4JiVSSZMfpaEGZCiLcboFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cHWmxWE82GCfipjOW4wSp2eiSFL7GX3slkYtxEOnlG40PamJVFJZuq/ou01pgfShe
	 AjZhRUSDPzBTmzL+L2E9oVUexngtFf0BuVuPvsqhVlzvYmIx0YhAodzSXJKq28OpLd
	 hcb2IBhuLrjGk12pURhF9MZ2K6dRTr5s0Fdv7oFf5JLrFNV+xWk8Ka9TwP/nEWxCuL
	 gVFcAGcEl7ABrQL7AfptHAs19hndNtKTW+GK559Kp8i6htL3xa6DYRT0X1DeRcONFc
	 KLm1DHPKSNTZDFnl3zDYQyRyXjlH1jt9EPye5oDU7C8BOGwHICeeDlv1xVa0zB/u3Y
	 0xgMEbnrILVLA==
Message-ID: <3c1000ae-6c4b-4b03-a458-e74edf64db8f@kernel.org>
Date: Tue, 6 Jan 2026 15:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 5.15.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
To: Harry Yoo <harry.yoo@oracle.com>, stable@vger.kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 jane.chu@oracle.com, jannh@google.com, kas@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com,
 pfalcato@suse.de, ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
References: <20260106115036.86042-1-harry.yoo@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260106115036.86042-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ks4yr86hucp9yb4h585gjmdac7ohiyjg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 994C7A0008
X-HE-Tag: 1767710140-525439
X-HE-Meta: U2FsdGVkX1+x8iC4zphpKIZhOYLHik05UH1bn3zZlZL7AXbhyoTDUwXfPPHj/sTg3oKtWwPT7bMllyCH7APFC67Yf1Tlq+mXRyBBH5GVjxIDG8bISgcoFk63MOZyfWA8rgJ1lEqWcBdl+lKICvVfNXdV1Fs3P9wlS5DwSffy/UlKKe8tOS7T26YOKQRbVNC+ZV+TZZgRsayX/90RNY/xBltXJWDd8Yvvhpi1FF+249y6eTLLOUzJxnwUmVL/CyOsgYIdkfNdq18tsTaI8uzsLwjbj9Y6VJBqt3Spxp+vK0jQlFKQhnoppyzoPUTd4xl2Pbw85sSJT9D5Cs1EDMa7fmRSSwvjY8Aq/5M8q2YOBn0ZK2npRdMLfdV7HBpQ6gjv3Raa4FfIYFEXB5UvXoALj0E1Y63otWStHWOE2Vrr8cfQc4EKGmkjvaXJf7wf4wfidzMgrxJNsY0YMzIjK+vH5orIU3Gk8sUaMsCEPv+i3MDuN2DgYEM24FT8k1PWaUnqm1XhGnN0xiohmBE6Jooln9Y9ZGUcFqTuEJB4zcE3ZOGkaEeBjIf0ZoklgWwckZw8SjP/BpmcF/vcgAB97zaztREqC8nyAWncGgE2HmtuvCOFjG1a9Myp7gK5RhxUW4eR6sUOw/Vnv8M2sNpzYFV7XSoUgXVmZO9rWAZz4126+0zSY2SPoiyHEtql0DOPUT9LiJ++o7MBf4Eq4wFYedKJPReMFpl8qn7HeqGXv501avYatI2CKUhwVxEt3iZuhLa8Ufnr+YXftqXLJ5mgR+ZeYkJZPgZv0LG55b81hMgbHE9eTpCiT/JU1b0JZVBmRfyPTYFn5wdhnN5iY5CiTNq+lMfgZQZO3L6yMw6bnnjx6+FiACQ3S1bJasp96BshJ1PCKNfU5eQicnDIk5U86vXFV3NHqrb/dEMSwVbZYDFokzbqTKnlmd7unEFh3QHCNblETs2VSguCgR3hIT07rV/
 GjwUGF5j
 gKGUFGdRzFfECVGwjCcvaVw38KTGro9A/G0MfLH8z+5645ZPOYYpUux/43GRb6mkx0Y/b1XFqPmqd+0VoFRBp6X2IkpYMQWZudt+OPkXlgAZoxpjzEvyuyAp7k3WHTDa064t3d76aI6EauhP8wYU2yl79jjbMHb790F+EJ/+ub/EZ16PDM9HX7p8P9/VcpoHna1wgQ0qa7lo4RIgkMRo4UPC1OLhqH81VFEsmlrVsgr5S7FFOccju2Y5MEKdVbAZDIckcU7t+1MqdYkERDOG0t9hc32qPMrcarFYYxOE2vABfuAC9qujlkMMaR9LFrKbVhLi8P8NDqvZDj28=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 12:50, Harry Yoo wrote:
> V1 -> V2:
>    - Because `pmd_val` variable broke ppc builds due to its name,
>      renamed it to `_pmd`. see [1].
>      [1] https://lore.kernel.org/stable/aS7lPZPYuChOTdXU@hyeyoo
> 

Ouch.

>    - Added David Hildenbrand's Acked-by [2], thanks a lot!
>      [2] https://lore.kernel.org/linux-mm/ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org/


LGTM


-- 
Cheers

David

