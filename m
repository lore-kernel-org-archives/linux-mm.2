Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9174C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFF16B0088; Thu, 24 Sep 2026 17:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98496B008A; Thu, 24 Sep 2026 17:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987026B008C; Thu, 24 Sep 2026 17:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFBB6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:28:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DF6F1603F2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:28:15 +0000 (UTC)
X-FDA: 85249944150.24.BBB7E39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4A2A71C0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:28:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VwHSdknl;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790285293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvxW6mT8d7ZwNs8y43DE6kGy175JV3A6s1NeHg7Y31U=;
	b=0zYC2xSQK6Vg7liX8PoMAsIQjZWhbUbPwr5qgqATsOHRxhIYQ6L027MGIJUJoMj2URhmZF
	1kXgmbwLcT1fcB51ldob4hGVV2LZOWxkDzncZoYx6N8bSe2/Bo9epVnCnRhCViQjnI/UtJ
	CSVgppLYX86ZwM7p58jViNxLjxjePWs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VwHSdknl;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790285293;
	b=ioNHy7MH7MeCCGpHxWNbSSR27InxeEhqkG38lwZAF+aNGVFvI/XUjxb21S/tWU65PN+K72
	smUV4FpDyeK2i7YQLMnMPwJMbvWKf5QRFgNfm1clcpYsPXDRkPAjUBRaG0cNNfm1NLiAz5
	V9qnwcTrLzhGv+5AaCFWWiyxdqZFk60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD874601F6;
	Thu, 24 Sep 2026 21:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1645B1F000FF;
	Thu, 24 Sep 2026 21:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790285292;
	bh=XvxW6mT8d7ZwNs8y43DE6kGy175JV3A6s1NeHg7Y31U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VwHSdknl7xEP7b1FaEVkfGQvgzY7Bq9QPy8oz/e1NE3fFPK+E0EqmxLUxVD6E474Z
	 9jLHR6aIzNMQjPqFMytn8DTkkTYrzOe6CsCFDiaEE+onUHG0VnkyhRDtFb0iXKTCQs
	 aKjp+2GLv3gYu+5U2lMHWSihDZzI8HSxzxFXHdSk=
Date: Thu, 24 Sep 2026 14:28:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Miaohe Lin
 <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara
 <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Christian Brauner
 <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>,
 "Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-Id: <20260924142811.ae18e0b9b741530f5991533c@linux-foundation.org>
In-Reply-To: <arVxle46OHWjL7Sk@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
	<20260805210557.1118966-9-willy@infradead.org>
	<a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
	<an3uN4TAAZ2miXhe@casper.infradead.org>
	<7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
	<arGidwZQrrWVPAoj@casper.infradead.org>
	<7a23511f-365f-436f-b934-6a520510409c@kernel.org>
	<arQkP2uEzog8ChN0@casper.infradead.org>
	<6121136c-de9d-4577-a30d-f00dbe244e5d@kernel.org>
	<arVxle46OHWjL7Sk@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uc8cgq7a7jpa6upm69syrea5dd39bw8i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A2A71C0007
X-HE-Tag: 1790285293-609795
X-HE-Meta: U2FsdGVkX1+PCRBT3EYux5BY5FP06Ke2rAli+6gOKfw12MPZ3KE3DszHFI1ZLC6S2YPGr6dQbER0qExhYX1WGEugvy89vlr1fobUEHiQh5Z3uzX4mfZ12YtobKsr4Yjz+YQQEzofsg0dCwwUbzpQgKyOjCbBGoSxioK3Drks15K4HuEa4p49nywP7+BLSQDAVzpJN/DbERuQ9GLE00zt2P9OtUboIIYSb/z7T42IBXCkxEN2Svp5ldDByziayG4jHqhR+62lIo7dt7rpkU4I7j3tmkcWEoO1SJc6uFHrUvoCNAzeWivjKhQ1wYTaA8dKwIZyQ29anLFccnpYVNf0+v9F28TIZlCfQk/IuSz+gyCcpSAC3+LeCUL5aWOU4ym6ETF1riB1GkL3kSO1VTV3CN0qXHP9ss5ZbtSLKTZQjnpRF7WE8twYMqBjgaSvHRiyIiiKtPoGyDS+zsyFr4k3PnWF2I4sXBSuMtwccNrdFFAlhO1cbW29iu9/G70DWI3dVEfoof8NzdWXeVHZJ0UaaSyqm0nvLj4wyfZHRBGj93aUchLqFXXDFUJXnUKAIAwpaLqqmzGzJ7uMZ43BtRA3IWectv3cbKn0vnly6cwOUhIoFDcM05DcK+PmbnS3O2hdA535QpemKwBcoZrm3eyA42bgIdrPKsvElIqXEsvCr/DQkaUdw+45x77PsaLIVyL1v9/tBI9cv9+8/xa9Z9J/i1H8GnaKY54G3tatmeyLfE8cAK/hdTY5fFrXcYepUMi98/+ojnaqZNtPFahOUshFRzi+9FIj91FNlHSEXZbqN22+loHj4P6V6EMs0l0Tb6yqq+Gsvp4yWjmxxpu13Jo8HYJnhQNW5iuqXniSH90aW+ZUb8tyLLSNI8HDymn7FXF/5IWankP2R2Afo1Xcc9UsE8KECtsmyzbtWo5+j+daPu5H5oaN5x5SuXiG+qxcl75frPwTymNyWyQHiF3DFOB
 lc9l+dPg
 0QlNXU+QY03nYkQLXnFucKbcqGRAl2qTyKaFeNE+NeP3RoQfztgXfY8SzY9jTKXTzjfzgwshEJYHhcuzNZW/D9cV4nxQe95ymBLlGiW/RKgkIzf3xXxh1DOGhUT4lxOgnY/eD1oSVcDELjRRpJ8uyYrxukC0wkK7epCj1pVgpbHugjoKelD6T7p0xL+jKV3oY73DuPShHdOPRImTGvq8mEtoJP56ngO2OCDKhukFvUJH7JdQZEoMnSeJIVcGxsIXDYd83qMOO4V8L97/hX4NBjWlRXZlcJr9bPF8d/WGy/p1cAsyhI0aqkqYUC3/FEZsajXEkacDi/ymAm0UO1WEEawZINSDLOI5Ci7/uUOGtGxHHu0DPufj9l94Pp0KjxuLHhPZp/YqQKWq5DCXK9/00HBX4pPWF++TDsNqPZsapBhVK655t0Hv/VgXcTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 19:53:09 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Thu, Sep 24, 2026 at 12:32:13PM +0200, David Hildenbrand (Arm) wrote:
> > > Oh, no, it's awful and complicated.  We could strip out the two bugfixes
> > > which are at the start of the series, but why would we want to do that?
> > 
> > Andrew usually wants us to separate bugfixes (especially stable ones) from
> > other work. Unless we all agree that they are not urgent and can go in in
> > the next cycle. I assume that's the case here.
> 
> I don't understand that preference, to be honest.  As long as they're
> first in the patch series, they're easy to pick out and don't depend
> on the other patches in the series.

It's a timing thing.

Backportable fixes go into mm-hotfixes and get upstreamed in this -rc
cycle.

Less urgent material goes into mm-[un]stable and get upstreamed in the
next merge window.

I'm OK with merging cc:stable material in the next merge window, in
which case there's no need to split the series.  But the decision "we
don't need to present this to -stable maintainers for another month or
two" should be carefully made.


