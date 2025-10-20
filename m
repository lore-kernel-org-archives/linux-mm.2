Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2FCCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE778E0021; Mon, 20 Oct 2025 11:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F4E8E0002; Mon, 20 Oct 2025 11:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E4C8E0021; Mon, 20 Oct 2025 11:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39C1D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:29:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEE4E56F30
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:29:52 +0000 (UTC)
X-FDA: 84018877824.12.B4C1918
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18E4FC0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:29:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uXiJrIJ6;
	spf=pass (imf10.hostedemail.com: domain of khalid@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=khalid@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760974191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yox3rtt8fTIgEW98Bi6M9IwIdFYPUAhizxz+bWlLT9U=;
	b=kFC/ViqM2xhuI2Cif+0ILg4Iimj9tg7cp9aZ2Iz4vOCvz6qmSLZHSTslJSwcm2EbgkCySg
	tTnlVJOetQIz2OH6+TeOqn4xPPxGpBABTuqlbFnldMsQCCwO3czlaZALgZ+yJ6yij/DwqE
	wO66iVeZLvCRnjljPw2sqt+aMEp0G6A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uXiJrIJ6;
	spf=pass (imf10.hostedemail.com: domain of khalid@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=khalid@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760974191; a=rsa-sha256;
	cv=none;
	b=a2iWYRUK85UPeg3xJfJJIz3re0klEli2vUGMS4lhht8jEPq+/eBsgyPjtWeB2QqF8Sw0IS
	2Xd5xcFhQuFXyRBjxQH20uIx/xWB83UdOop4n3HNMxuhfDtp3UqfhZoWK5cpTrH/1aYA3b
	PhK3zydp1k6/Z8bXWe1bwmIjKZmlKTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 060E348CEE;
	Mon, 20 Oct 2025 15:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D2BC4CEF9;
	Mon, 20 Oct 2025 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760974189;
	bh=O1orugBr2pvTT4K3ZaPXwEVdYUClnxbj+YqzNevsSfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uXiJrIJ687SJ+ZX5Q9oD4LYK5sQUkdBCyvr+bs6NtwlmsufLYur10NjjA0u5WTGnm
	 JRmI2YhfP4weHJj8V5eSziLaUAUrt7B5YAVrqZyN+PdEDso6q/fNmLpcA3aux5cj8Y
	 Yk9PpxF/uV91kzuWgAU2Tir+58s4qs+jJtHrYpYULtU5lGBaWp2fNWq4wkUH0fkZ1J
	 c8i/yjnj8QJ5tGDRgXbs4gd1hcUg3sL2NJLjzdbgbW1UJ3Dj616krygQMks7XZFvaD
	 +pSHufqszj8KlVb4M+mdQ5Q0yYyA4R8RSGEhsuAZt3bAtITJC8UhwAtrw4LJtxwzRD
	 v+BiJRk4g+3Ig==
Message-ID: <33f2a0f7-3e15-4256-a631-70e68fdec15d@kernel.org>
Date: Mon, 20 Oct 2025 09:29:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: Use kmalloc_array() instead of kmalloc()
To: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>,
 akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 linux-kernel-mentees@lists.linuxfoundation.org
References: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
Content-Language: en-US
From: Khalid Aziz <khalid@kernel.org>
In-Reply-To: <20251018201207.27441-1-mehdi.benhadjkhelifa@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8gbf7rjoe9qbzfw6u7cno9e34uaphtny
X-Rspamd-Queue-Id: 18E4FC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760974190-203272
X-HE-Meta: U2FsdGVkX1/X8nuT7tKdsTi6pjl0tTxer+0dLAsPwwam8H1UbUAyNvu71pNsOXtFoMvJn4i1FEb/sEdW4kA8PEHlmLgeuWAEu+uO2fOO/vMsiXqDaQPf5lgVsDm5ldPK+QG7QxFt70m/NO91I++840H1jjIsILXd3rEvzt7SQh+5Q73/6zdfEXB2ej6aOdZQDGKJBKeLkI+NOntNUIi+Wauh9XsFTAy/IZJjZ64328cKtQEzwXu98CmzH+G1Q8zHjU282kzUo5rYIVrOuFobZgPJJJ9KrwinDNPsoo82Jcu4YxSoO/qkW5UnLcWlEK+dPe0jkTB54s8R8Y+Q/cgQsK/fXwROVjHMeUKe+408FypCv6W0OMlQdE3UmJaZvyvrc3XOEPmaUo8KYMxvdTpcZN91ar9FK7b6VPXIIpNVoBMXcv0buGwtkZVwt+ZfroQG9uErjln1/Qi5XjDAHQDaPR4TbHq4TgrX4jJJbdF0LOy8z2Oy2dXHJpgo1PAt0sIebxpMD9tx3bQ/a5VDD5VDoFZCsUM2njYvNk/W/49MXFFqg8L67TV8xZd2mRnJElL3xo/GFNRkfNbMGSqPeMAUozO1xU05SOP3UL4xpTVzl1Jj0uSL8wfUTN++snYd4fep/GOEzSNmZY9gYexUfmfDWklPepUIsvuzCM/Y03/fTaHIzc/sGMHmqxQNwMQIwFUcBXAu2d18MZ+wu6nW02ppPGgroEDvlzg+lqZc32f0hvyfyMY4JHMHyXAA662LdGQhh3F/wj9orexGi1eT0AofqMCpb4Ny08yzA6Q5PSuCmkOfdiFOwpApZGBQHclzhcVOkNkQ72RWc2gfaOrqECWDRYCtA8qRHOkkp8HSRU3jf48LcwzGNXhtlSKE3U/RwdHgmI+KAQhje3A2DH47/ZGQa/MHCtcoiVumTtPqc7urG2mXKY9QgFGeh7brxs/M2nVEoMEnmxGq3Df3ReA3fN6
 obyN6EXS
 Y7J6K2X3kOSYrgU89ALkeTLnMIUjWM7SVyQJ6ZOihG2v1bEqWOWz+N4UyRQEY/+i3zAnbPTMvDXbjskKdKwJbZRRCokRGF5ZbZLhFq0bQueJJL5rcxQyp2qemjqk7M/uQn/5aSwXkRXO2ILpchukFcuLIshxHreiK5VIwL7Y6civl+mECWNNIcgPwQ3inHIdkftsYJbqF1/ef86W//G5/7l6U0F3T5IJ8Bey5IsHrWnAGzYhNSzbnzD7QF3rLr94ZC16N1us86L04NxXOKRwqE3CbuUDWczh6dd0Cn/egJ4YuuSw/eRoofo0fvAB1j5F6aHt436KhFGcZ/ftKHhNS2d+STpP/KQj7rv0V6R/Ksj92woOYZciEQqYH8neltn7imfGnsFl3lww85E74GwfyNPaT3hZiw77W4XdQbc4D9vWHg5i5nGYTkaos1jMLUOLX5IvWR6nApqeuM60=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/25 2:11 PM, Mehdi Ben Hadj Khelifa wrote:
> The number of NUMA nodes (nr_node_ids) is bounded, so overflow is not a
> practical concern here. However, using kmalloc_array() better reflects the
> intent to allocate an array of unsigned ints, and improves consistency with
> other NUMA-related allocations.
> 
> No functional change intended.
> 
> Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
> ---
>   mm/vmalloc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..697bc171b013 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5055,7 +5055,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
>   	unsigned int *counters;
>   
>   	if (IS_ENABLED(CONFIG_NUMA))
> -		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
> +		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
>   
>   	for_each_vmap_node(vn) {
>   		spin_lock(&vn->busy.lock);

This looks like reasonable change for clarity.

Reviewed-by: Khalid Aziz <khalid@kernel.org>

--
Khalid

