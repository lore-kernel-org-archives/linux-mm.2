Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67861061B39
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AD36B0096; Tue, 31 Mar 2026 07:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C856B0098; Tue, 31 Mar 2026 07:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189796B0099; Tue, 31 Mar 2026 07:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0643B6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:43:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDC431A0120
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:43:02 +0000 (UTC)
X-FDA: 84606171804.24.96E0FD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 117F120003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:43:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mic0UrNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774957381; a=rsa-sha256;
	cv=none;
	b=B/E+Y4u2SWW8FlVpYyW0KVjlvYgx45Lgelap/gd9zHLG0nK0vn2Fa76cHmKtFA9+Lm07eP
	meAAbCgcevriMRVbfyxk15wQSoDs6XJdotkag7x7bZbwGb/L11l4taVB34fVKcJxaNqMk0
	VjoOBJGiKoyONbQ9wrSXgCzac0gkNWs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mic0UrNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774957381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVdnS8515qBZn12afe277s14u2j6qhWX36vHKXQ/1fg=;
	b=uEm4GyzJiU7gcWKjEITBy/xJMQQ1ewMubfWiBok4ELvgcY/MWYnhlZwjP73uC/kDolB0L+
	Vo8E7H66Uxwfm0P1LyQQrbxbKP8QI6lR00fK7eio+i/F7jCZRUtrlI1JtGv3Wie+c62xYW
	yKYz4eHHGseZmaLmLvPb7Y5zbARGYXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B12F441C7;
	Tue, 31 Mar 2026 11:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2921CC19423;
	Tue, 31 Mar 2026 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774957380;
	bh=247pA96YIQXewVCf132JKie0YIN1hc4dvqlsqaYdnbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mic0UrNqqNfV55zdjXUqwQrg9u7c13NFfUwM6GjdKIItNtcBY3kuGQ1pAkLONlASN
	 jORmduxma2Gej9GpBK7kjYfwebJhZlx7ATpi/8H9PHXaHmt/i0/gwTJwoZDxxt//YF
	 g1Gs8AuEfEuva8i2Vk6qYgW2xG/GJSbuzgLMnH7HbrTz9EBzev1Y7bX3hyoZpdF61r
	 ZG/ugAZG/0c67G0bXslH/6L71VmliJ3afB/cs/NWz9VzEbCDX88tTMSPVPTmzECcHM
	 tcgs6sWfhYGxyefuFkY+29YPca/u0uodDzLNBl+hqh5HAiwo1ZR53p4WTkJA8nlbZq
	 t+8vF8SHBIquQ==
Date: Tue, 31 Mar 2026 14:42:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/userfaultfd: fix wrong likely() hint on
 mmap_changing check in move_pages()
Message-ID: <acuzPjzx9byIJ2tG@kernel.org>
References: <20260328170101.184163-1-devnexen@gmail.com>
 <20260328170101.184163-2-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328170101.184163-2-devnexen@gmail.com>
X-Stat-Signature: 7be58zh7w3ajq1n9fjzd5zygk33f3jg7
X-Rspamd-Queue-Id: 117F120003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774957380-357341
X-HE-Meta: U2FsdGVkX1/qvOzTE8cmauduu0qNs/aBiVJ8KjMW1ZJc8xJbok+8HQIQNTQozH7A8zJDvLjebXyyW2NOU5TWEiseTvD9xFmeeQ2eYtinTYUk9T98aqG+wrerVPqmhjDpvjjIxV2V9oy/C1enARXJQOHKHk6Nq52jtWRplAxmZ0HinB4ovgQiSH1qmq5xi3sdCIlxggfYxqjcs57XtoZuzMU7G64uyUHjxLqLHdrDc/tXjIjYK7CBO3vvb2MBy61mpUS8KAor8Q3dwN3aiQtrF4JVKkj9LdmvnsV6V2iK2cu8x7CzEXg5YDEo0kSzmeGYnBHE5fjHNuq9oE/vy6NLFdJBlOrbWT3WCqDCUh/dl0kT1Gu13XumSQOzw0Sd9JRJyz5W9OYofHCQnELZX6swAStu+m0N8/KrvZ6nqj5ZHGCjOIje9veKlOeo1Y8AhqFT2KYeCkW/mOGDcyFx7I0oC1DteG++MeqzgSbbSC75T8Pb11pgV6kcsXdpsiIvAtG81cPXRcTiyxfAmet5GmYp+yFHAQJJnBUmMEiL1KGTaIYTibSt2Vh36r0FsVrQvdqs9RBX/5iA/Flfk8uNZbwLkH0NakV5wIi1ip9qFLpRRHP2Zq3wfZAl2R096HR2nlA21KZ0okO018Svov1yf6257pJZ2i/JmGG/pRRaXq3CWDe6rKMhoJASR/NiIca/CKgtvEQU81J5n1BBztOklk216MMo1a9VAnUVSCwcg7LI9mlPCoZDqCu9s0fey6xI3AybkLmNOvh8KjHZ/WIoOMlXEcRSnyQ5IctsNSMtZrzqUTKeoyn7COtCRnf4w9HXpDLLC9eh4yfmvY7IB8DJJAUZ3IhkgFqNVc+a5fq5W1R8KNVGcqWRzOG2565uiIgHaoWLI4nBQC6Gnvyj33JpWFX2VlHiGHN42POT8HWrC7UWqET35iRmoT9yibx7bvOo/3bAB3+aGpom/AuN6BY9WjK
 ZVz5JG/5
 S2kQCX7JnX7ePrYxuRLL5RN/3+V0wxXexvLOCDy9ujlmwOL8srXByRanrTKu0ScZt1Fjdaf8EyXhZ6NKBpvcG5kz6br3gpkbsHzsJcBiv4tJtnF7pQVfxlEc+eJMET17dcdMPbzQjyjygjSyYaGcL47AXirP18J80eOWO4g84nCRYH9Jh6aKsq32hU/UA0mzhA2tlsmCeOTzYVebFjUfO9ousQWcknGt0Unybk2ITdL2GkAt95rIelc1gPuckaXGdddQoK/UwV88TMEWB+z93u46k+SS0jxDBw90zeICAXix3vJgTO9yXnFyOZ7JorLDkl+1ekyIZYVHwlmX/eTcBMxchAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 05:01:01PM +0000, David Carlier wrote:
> The mmap_changing check in move_pages() uses likely() but the condition
> being true (concurrent mapping changes during UFFDIO_MOVE) is the
> exceptional case, not the common one. All other mmap_changing checks in
> the same file correctly use no branch hint or use unlikely().
> 
> Replace likely() with unlikely() to match the expected branch behavior.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

-- 
Sincerely yours,
Mike.

