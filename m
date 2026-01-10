Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A76D25028
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 23:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8077F6B0098; Sat, 10 Jan 2026 18:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5496B0099; Sat, 10 Jan 2026 18:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1F66B009B; Sat, 10 Jan 2026 18:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58A4C6B0098
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 18:57:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 069931A01CA
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:57:25 +0000 (UTC)
X-FDA: 84317718450.01.40775CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53229C0002
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:57:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B/S6dfKK";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768089443; a=rsa-sha256;
	cv=none;
	b=TEgPyzC8QcnyYtwS5+7kP4sDujRauPfrhMlk/SrCZuBnDm9H7JCVCmzSauXf1ltZ5vKsGi
	cwVrmdUbyijxdkK7C9RLsxfA7BQ7Bw5yR3MU7SoB6ey6hoCkD0nNtYnyYEnBbY0zEf5qdH
	ctPL/EZd33xNJfFps1WzjRSVJOahbJQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B/S6dfKK";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768089443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McO9BFcjOidcXLDiHmVTfYISq5dQDBvTVo7iE3vCWkI=;
	b=LjnOmhnWizaBodUOELXKCZZj9P2EW4XY/xYtVubznLaK+RRxcH1NpEgMtmWu7W10I6lawp
	5YnHoqz8RSE5l+ES0njF7z1pgATr3wwEMAHTKc1iTv+GHWuJXvLpe7QITFggtpMRjq6zRA
	Q3cXhWXwWMRiVbb5FarSFBmV0uTfx+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 880416017A;
	Sat, 10 Jan 2026 23:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54E7C4CEF1;
	Sat, 10 Jan 2026 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768089442;
	bh=mHfbHG1wFYh4YWBIT6/g5Nu1yluPi5pyE6+5ZlNa4z0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B/S6dfKKPGCBNqrEpUiQxa9PV/WrRAt8QFAv8ZX9aVy8EfjjOcrphhLtQN7kZdO6x
	 yKH4Ez6dLJga9MhgvtUuW+D7s/Es0SGyH+l0gcwiZhHx8rh7BBJdlp95RS35L3C6Gx
	 iZyrP4OY6ncF0uVnKnNkypQKTgmIMl/hVmIG8hCI=
Date: Sat, 10 Jan 2026 15:57:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/early_ioremap: Print the starting physical address
 in __early_ioremap()
Message-Id: <20260110155721.84af2e403badeeb29c7734e3@linux-foundation.org>
In-Reply-To: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
References: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53229C0002
X-Stat-Signature: i3pys7isgi4oc9drpjctifan4u7rqryn
X-Rspam-User: 
X-HE-Tag: 1768089443-870598
X-HE-Meta: U2FsdGVkX18Cfrn6Bilzu1lsy2f3Z9NkRiC7rG51iIWbQqTaAWhP/6BZrnKwjFHNNM1Je7Gs4zyGpLpSdF5NwAetA7aI7z+a55qCa2fRGZ9ednbRWxoURwqjDplMlQxtUSnUKPJ22REWr9/2HMHQ2UMn/QDpF+y16pO2bO/XKzFp7XP6AQIk4tQiW+YPj1DRkINlXrvVZUCvPaGHGIO1s/g33SUqYhk1iuwASnAf47tzQYlZvLuyml+z3D6VU/JFWya5/qg15VW5c3YxBW9n/hYktqpo2gtvx4+j6iBbub9/Aro/R9USi/CwTqyUzl088OX+G3+Ev/rufz+Oa7dVTspY7bA5SW3IBGX6UgVxMtp6v7mbgmfNj4Sa+zqmEnZZ1IMuPUDmwMBbgtmjX0DQh3nj0/I2+kj0umW+PMzPR9TAWAY1i6676Ou8fTKvAc6j9SX799AIe0U5R99VsJ1n95Ibp+/tiM7KozYB+//BLL4uDryI3t2xF/55KQgDNswHzzEE5nn9qLN4pRMQbA2j61SCCYsP+0PG13/aIDcXdB+cnZFaXrur/uegzV6VYV0uFB0bAVREj4WgnX9WUlxRmglA+uMXr4ewEYecgt5yJXi1XLLT2FrNLwtvDqL9pjhJ7RgYcEEaHVSld0IqxHtkMb1WSWunEwvkrl0et6xmTY5ZA05aB2iiDyUk7j4SkjELtWsVYf//mtlcu7iD9/8GOr99aFnuDnZn2LpwClWLEyrL8qF4u+SwYXxoYLe0mQALdTXnakK/KlrUM1egCeFOpk9N62UF8hVGtQ/sqMI94aTVFTDFUUtjVAqQrzT0RsxNp7QntWVvf3uOq45ly0yzU7vW0g09CCKrDIvxkxFAatYjnQfc8CkTFGHuXKFoeEt/HQjNB4EJj6DZJuKzESbhavHQGX0/Pi5dAD0NB8SKzkCXhgw1SVjmtd7ejHFeX2KEc2IPCpuhiqnr/owX6qh
 DF9Y3ixk
 hfohZ3bFMbqFnx3Acms6Z7ALNmgupTkNpt71WLc7bWxZLDEDk7Ffvv4r4Ss3zoxBzQP5MIH5eXo91dYWC8KOQqE/BGDqjF5vYR/pMMu+1enV0KCLkwBd+uNjTJmZmG0dxkHilI67qxy+5rxJeOI49NMV9wKgLyRUV9Pfn67Qg96UjXnaRpztg8DGJojUwpo1KRl39mjGBkRdhQpZd4lSLqMlMWw4RVNIxopU6GJ6Vtb/jzHvJoNZCcB4Yd+x4ggeupXp+2vodUJ5WlsHISef8gw1hLRgTn611kaS2yf9I1374zdoWQnJBgrG1Qh4rHeJzGkWlvOKnHeNTMal4w8mISgx5/S+oDHT/LNdvNSccZnXzCMezlW+lQkCWNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 21:31:51 +0800 Hou Wenlong <houwenlong.hwl@antgroup.com> wrote:

> The debug WARN() printing occurs after the while loop, so the
> 'phys_addr' reflects the last physical address rather than the actual
> starting physical address, which is not useful for debugging. To
> simplify, the WARN() statement could be moved up before the loop instead
> of introducing a new variable to record the original 'phys_addr' value.
> Additionally, swap the print order of 'slot_virt[slot]' and 'offset', as
> this will enhance output readability.
> 

yep, thanks.

> --- a/mm/early_ioremap.c
> +++ b/mm/early_ioremap.c
> @@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
>  		return NULL;
>  
> +	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> +	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
> +
>  	/*
>  	 * Ok, go for it..
>  	 */
> @@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  		--idx;
>  		--nrpages;
>  	}
> -	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> -	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);

It's strange that this code uses WARN when nothing is wrong.  The rest
of the function uses WARN appropriately.  But that's off-topic!

Reviewed-by: Andrew Morton <akpm@linux-foundation.org>


