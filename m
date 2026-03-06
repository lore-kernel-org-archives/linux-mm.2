Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD2EFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F326B009F; Fri,  6 Mar 2026 10:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07096B00A0; Fri,  6 Mar 2026 10:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33516B00A1; Fri,  6 Mar 2026 10:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFD5B6B009F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:44:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7783B1B83DD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:44:13 +0000 (UTC)
X-FDA: 84516059586.29.82DD665
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF50540003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:44:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Sin/qmdA";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIIKSpXiSEn9rzNPXunOa3Fzz7GPfqj+KXB7gTALr/4=;
	b=MQ/fR6WJJB19FbFQmR3EFCq2yILEYcNV+9trBJyjVSIvwCknK9/L77U28tcmp81NYXK//y
	PqxszXKofVqGRGDswWrnj174lX/LzOttqNirZHF+8J42+J6qyTNKH/lfrtctOvTtbt7PH4
	0HaaX+Gvt0rR9EaAZsFnUfqj9BzU5QY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Sin/qmdA";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811851; a=rsa-sha256;
	cv=none;
	b=AR8QvTMTo7koDo4/vB1Ah7uilQpbJ9EimyHLwCXg+lapl+qXN7KIg8AUoM5zQcjubn4nrz
	I/GxmOXvI9SFzD+Mjfpz7FKQL88gor0/ENPtx2fEtV9VUTDcOyzB4tY2tKD+piJacd7iE/
	O8WnH9udg1xHGcuI6xFDDWzjRk3gvF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6080C60018;
	Fri,  6 Mar 2026 15:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CE2C4CEF7;
	Fri,  6 Mar 2026 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772811851;
	bh=Wk4h9dnWkeV9U+ZTFSAgXgbx28Yra+Fa6gacJCp9eGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sin/qmdAh+e/cLQeAo844HNn73cnfzU0zCaK+3+yI6EQKZy9MgUHlMZfTkACMkyKc
	 nGe+r3tk5rmd59+6VDMakoi4yvDy+lCSprKwKB40jG2KH9tw6FMzpGj8zK8RMSd6tl
	 ucJ6SJywQ+x84Ds8R2AISvdvGCQ1omneuwqbqMFmEX9c+tygyAi+oSLR7Ceh8EoZdY
	 RwXUqrzDidOWGTZvYHsTOClFSvEUF3qEY7oJX4970UNlbPwlbl6cC/MK2XbXWitZmS
	 MZ+H7nmL51/ciAm6uORvQI3b6uzzQpDRPVn+eDRn1Q4SGg0TfFOSFYgy3zhSDsU/bi
	 xcV5fhyeMurXQ==
Date: Fri, 6 Mar 2026 17:44:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memfd_luo: always make all folios uptodate
Message-ID: <aar2RJ3Bvs6Egmq8@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
 <20260223173931.2221759-2-pratyush@kernel.org>
 <aZ64ikDtz8tF_rFU@kernel.org>
 <2vxzqzpybqyd.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzpybqyd.fsf@kernel.org>
X-Stat-Signature: whbm9nnosnyumobw8r9sh8q8k7h7f4ke
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DF50540003
X-HE-Tag: 1772811851-994266
X-HE-Meta: U2FsdGVkX18yiDcEOYgV+NPkFPkA458zHlpCmnlVmWaDUsCgcyWuHhTKIIgl5StVvGRyWOivrFYOC7Ks6j573uBOtKIiDh3EAyk76S306/jl2c95ojdpAmb5NFYSyeTSZ68W26IPxScqzBNQvXZbUyJa8mC3mHZZed61GxDdnLnriQLdQ9wZD3Y34xXJq2beHdkrZCvUQtYMotWao4Wr2WpcKHXtHFd2NjL+DipdAOvrVreSn35vHY/LrlUoEuC3MNP2cmNE+lw9tGFTnvLeXF9g7xOOJwDg863iOebuBHZkjMUi/PP+RKv++wskELDtPN6wrDmEUll8vXnkoyDsZl/Ou0fxHVxQ58C0y3vHer1zGyW73S5nfJIcgTQQQRT8S4pKqzYVsi0cQTFD56vypdjt3pbD596Zwb5+WFN6XW+m9gIkk8YDpsnDLxIj7l1c8b+f/1EDkz0hCZgGZ3eZAnjzBW/+APNDApr3CnRWD5PHzCfrfFMK7Z8ngJjt5ypgS2aP6AgJ9XTlVytbVbGDPj+q8AobBafi3X6JnbN+hVsPvVvPkWdMlQghulxKjM3C9lWpj00lMreEGGHSrcMtUuJisiZo4tZ5XNE6DV0qVon9GDN48eDZX9NSBpVhr0JytaEN9CD9f0IP8OEJ3MLnpPf5kVFjDY1ydqP729esxGyQqhOO1uV/TLYSmVubYFKqrJuRcZ6fyuB7jGgSM+DctYRd1IdwK6g9XpLC83bYTG9xBwwjtIRUvWv34mAh+93caT2EYfk1ArMtzIJkSJkh3DjIBfUwzpbnxl2nuMsrmRpnXeQhkcqFGBQf1OxNtB4r/l0jX+/4Ily6ozsV0Cb8OMPi3HWphdFjICrTCuxs8mjvvhGAkE9aT5sCbCq86ZJhnCmWBXqhJkoTUCzY+ahoOXbQH/hweIZy/U/MxRKuJJmy23C2wO3TPodz7pMM2vKdJKtlWnaL8qulHedm//V
 ZrsLGfC9
 2rN9Xetgei0YEH9yh0vpl4GUfm+bnmw3Xym+eQzxGqmXUUYrU403loJ0z2whIGpdyNnQqorDn5DQp3P87bRuSxq7S5VfFQ/KeCU9CNF6BpQTtTM7hsBOMFT9W0c7TiezCRtzBTV5iEU4DySOtDb0JBWCzLlv52RH/scdp1KaZ0Y3OdSGjYhVMWibCgFbXe080XsHv4p5ETVfDMg3uvGn948QM5wJwT5LVqcNXTOj+RQA0uLrDLsusY4hrnQ5gPIZfJJxrSMs5LH1muECmyOCpbimbBL2vhBLq2hBNAfwPE2fe5I4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 09:50:18AM +0100, Pratyush Yadav wrote:
> On Wed, Feb 25 2026, Mike Rapoport wrote:
> 
> > On Mon, Feb 23, 2026 at 06:39:28PM +0100, Pratyush Yadav wrote:
> [...]
> >> +
> >> +		/*
> >> +		 * If the folio is not uptodate, it was fallocated but never
> >> +		 * used. Saving this flag at prepare() doesn't work since it
> >> +		 * might change later when someone uses the folio.
> >> +		 *
> >> +		 * Since we have taken the performance penalty of allocating,
> >> +		 * zeroing, and pinning all the folios in the holes, take a bit
> >> +		 * more and zero all non-uptodate folios too.
> >> +		 *
> >> +		 * NOTE: For someone looking to improve preserve performance,
> >> +		 * this is a good place to look.
> >
> > I'd add a larger comment above memfd_luo_preserve_folios() that says that
> > it allocates, pins etc and fold the last two paragraphs of this comment
> > there.
> 
> How about this:
> 
> 	/*
> 	 * If the folio is not uptodate, it was fallocated but never
> 	 * used. Saving this flag at prepare() doesn't work since it
> 	 * might change later when the folio is used. Make it uptodate
> 	 * now to avoid this problem.
> 	 */
> 	if (!folio_test_uptodate(folio)) {
> 
> And the comment above memfd_pin_folios() gets this:
> 
> 	 * NOTE: For someone looking to improve preserve performance, this is a
> 	 * good place to look. Also look at the folio zeroing below.
 
Looks great to me

> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

