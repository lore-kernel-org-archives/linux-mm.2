Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E00F3092C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B833A6B00A6; Thu,  5 Mar 2026 07:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AE56B00A7; Thu,  5 Mar 2026 07:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A680F6B00AA; Thu,  5 Mar 2026 07:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94D876B00A6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:45:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FFC416013D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:45:59 +0000 (UTC)
X-FDA: 84511981638.05.DB26FBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63D5940006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:45:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOooaEUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772714757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9zNDCoMtVOK3/jLGpI/7783E+KKK1K+i/IAecFaUwg=;
	b=ztRWK/ulMGAxDHTpl51x+fo1nQ5BrzJg66lOAycSvPf9/5ZEEu12FtXyyEeBBd7DaQ1g6M
	kgJVMNWuSu91SBEitC5C4FPl6h9I7AqRwo5tJwzBKRbgFydgjc3dn7fN2DCGQBbSjjYfOL
	QdH7a0OEVSf43zn+fViu/6/0fVJUM6M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XOooaEUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772714757; a=rsa-sha256;
	cv=none;
	b=gJh03qnljRN3Zq9pryw91VPNxfiBBGxPlAague2zhnmZRFHhbcApIsz3bxgqK4LZD3ZwSQ
	WJ42WdpVs/A+HZRbMjQh+HUikvj9wgkp1a8/oOgX380hij0r6eRc7BE+QSMzCM1YDdaOtu
	w9XjNvd+al4X38S9IEBycAUFK9Q+reQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA2FA61340;
	Thu,  5 Mar 2026 12:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56778C19423;
	Thu,  5 Mar 2026 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772714756;
	bh=u98IZxnDpUIQPVthChFWg0v8zRgS1k2ZMOAZG7mcz2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XOooaEUwh0f27grLzswRIShUgkOr/gxlCcTbrgYQpfqSJDjgDElcjsQHbtGTbPWT0
	 L9zHT7qnrBBwRLeS/9Z+zbvq3Dc+NgDfWh4I0yfUSget3XFfZXCm+eNLxPaL2fvGsj
	 cciUdkUtgD7lZBBVNQXDowqU6S6EdmffZn3z2h2UiFvM3c3nbE3bEydj34+OkcbYO5
	 b/Wfx3k/o9HzcJ6jssrpzggs3iWiF0iN43YZU+7FCGc5xs9TrJedHhtubyL5dhLytC
	 SPT6Ql+R692XHo/lseTEGuqL2/p3H4AZyF6cxoz2ZqlJTOFOy3InQXj+N+M+yEfpo2
	 yItlASf8dcjyg==
Date: Thu, 5 Mar 2026 12:45:48 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Breno Leitao <leitao@debian.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <cac26373-2323-4897-992b-5cc56e2b9481@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
 <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
 <ae48168f-c88c-4f74-8cf6-ab90f6c97c68@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae48168f-c88c-4f74-8cf6-ab90f6c97c68@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63D5940006
X-Stat-Signature: mptcgn3num1ime78cwaakgqj44fd9c34
X-Rspam-User: 
X-HE-Tag: 1772714757-30943
X-HE-Meta: U2FsdGVkX1+A9wxRrkC7LglvNoZDMlDrhBHf2Qq5lTBOISrVyv+r7B00jWFTJx0IdRZ/so+WagXmuIo6gVTENPV2sunMC9dNq8D4Lg1aSAyTYNW4WsX0w8+DItIvXOSeKHsMWVyxCefv/mPydHwfOcP1/+JRMc+n6CgxB7hoVzlNRlWIe0ebMmY1v0yTRQn3oTrSa8KsW9vxEi9+zV/DFXDZJJsYkf24yhPdsH9a5YLx9uek1OEllV34u5rWqfXP10Nfc0d0+ZUzdz4W4zztBtgTF2qtc22U0ePYISBCFkbBuTzVkjqtruLSiE6fV87t8HlFslVvMHvvkgxfTtNpPgfTb+HSoxHW4y/lVFgMdRhShxK4Jq9sqSSMGf/L6YXkiD2gsnGMt6C4L64/uFcrCy/np8AvlrS7NWwsfEqw7wm1gpWQ8N+11hF+6V85HbleTQM3fvClxwQbVYX1wDHnyYkzRXfOPjR5KKrkYPFSA9Mh6haPfDUnOdK97sHihIg+swHHcu3c3jOmoYFoJWg4wTPMbmRDyU9AOEZHJaaGXYW5hGX40M8UKijnWqlxIiLyUnacW8LptZMxxMq4qAXJ05jvA0gECuhLIFP/55xQn2y6OYZFWNXu8R0Hsk0OrVn8BtEoNaHtb6Zf3DQ1fuUU2T3XrsP9SV2gNgqnOlzkDNY16h9CJTaAYBYTVHALpluq2WbbUbJMtXEVZk+JDl7FK9OtMYA0ZBNC5sOEhAnnwES3D4R+QunE2wN7vNM/5rv2yDI6ICM1tm+CA6mDa4TRnNPDosdfV03UkUOMxm6K7fpSLt17rAZE9Ee1M4VP7t8OQlCsKTPf8hFs1EPqxkuIvgfSR5hj53quy81mN7Y/TYn5TAjkccmCMZLZ3X96ucfQaop8DGyT/OQrjU19Q+1t6ltubgGmLF/s3GZaSfCcTP49qRgsv4GWWcLZlegk6asNwgt+eE1V6rGJj4/NJLc
 anwOWDgr
 EBQ96Ly4+sfUJl8XeGRg9lNa2ulu8G6nHG8QhD58NBq2dSQGu1Bkee6SopCCzMe4bp0VUpMD8KiICP3XKBVQHwwTPBMAx8f6x++OKNVYDuPN2ovc21/5EplQiTmX7fUY8JutvzhlB31zzbWsTwlyzC8LBjdXItGKLIt+B8lW+gNaDwKZUlEr9Vs7226g7oO4p1ULx0Tp3kvNaRitQKHeqB7lN9y4y6F6RO8dTXL2/3shOe91UXJHxtxTOnAyu9iazqaRmE3hpc4BACYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 01:41:33PM +0100, David Hildenbrand (Arm) wrote:
>
> >> +
> >> +	/* Check if anything has to be done */
> >> +	if (hugepage_pmd_enabled() == !!khugepaged_thread)
> >
> > This is horrible, better to break out the latter expression as a small static
> > function like:
> >
> > static bool is_khugepaged_thread_running(void)
> > {
> > 	if (khugepaged_thread)
> > 		return true;
> > 	return false;
>
> return khugepaged_thread;
>
> should do the trick, given taht the return type of the function is a bool :)

Yeah I know :)

I mean it's subjective, but this form makes it clear that what you're returning
is _not_ a boolean.

I was a bit 'meh' when I first saw this pattern, but it's grown on me, sort of a
'make it so simple you can't get confused' kinda thing.

>
> > }
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

