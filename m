Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DBCCEE49BB
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594F46B0088; Tue, 30 Dec 2025 15:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518C06B0089; Tue, 30 Dec 2025 15:16:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424DF6B008A; Tue, 30 Dec 2025 15:16:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 300826B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:16:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D52311602DF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:16:42 +0000 (UTC)
X-FDA: 84277245444.08.80597AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC6F14000C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:16:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OYzOxM/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767125801; a=rsa-sha256;
	cv=none;
	b=rBWGOws5qv6aUoReyR0PbYV0m9UIUkqfJy/vjVMtmZqkXoJV3H/IQUyppkoLxwF2eIkUaQ
	S2PlJ6gEqZjM/WLurqDXrx8aJHukGL4zHnuXdCIzPszrU8EYXTTSwoSUP7NTTMWHGzaUmg
	MBGoC98089EkD5QWLrcyD2Zq5s5k4Jw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OYzOxM/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767125801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2F/ZX2Zkxpq4Dm4HWWKkZeDSOeq+ySTlROW6dx/pgc=;
	b=GnEbe6/jUOXj7rMWCx2eG2Rh+wMGLPvbskvfwaz1P8HvNcoEvDT7nqWa1fLLjA/alddsO+
	cnwGfxkbsdsYvwg5o7hjQqkhB5WGs1hPYEsI7hhOzmjsm4nfeloK1dy/QVZTONsx2WqxZB
	weLVfGY6Y1hX7Rh2OgLlWZ4a6qR63LE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7D2943FE2;
	Tue, 30 Dec 2025 20:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9921BC116D0;
	Tue, 30 Dec 2025 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767125799;
	bh=fAIoBBiDaqC0FsW9SjJVK0gWBAByeEaSyWf11y9MmtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OYzOxM/yOBl0NCcvVYwccwhVcqhiBHOnxZr709F4oZqG8RxUryMZT/YRDLNdqUL5o
	 MjV2T0vkwD/gJrpiT7dj+ofSA+rQgcRWtzgy3km5x5edpSQBvKFIkVQqeVg7lTruuk
	 c3woRauXso35KcKKpBqNKpXxI8kQ8R+PNTUH0KW+KIVXTjKE97VUvjt+pXESKROSbL
	 ITpS/SnYjOYLVGpUy6zRGUFvuSVTt+tjKqx0ZwFwWm3h2FYm+NfEBr6i6bXkAyKf5a
	 ozY2pp9T8F6w5O5e+bEVlYvROcQZusMoz1J4TxucAAMSdFrlOkIdl58/sWTYeazRN/
	 A4jJBbe1ehqXQ==
Message-ID: <a8abdc11-d008-4abb-8fa5-966ff27e1488@kernel.org>
Date: Tue, 30 Dec 2025 21:16:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memblock: drop redundant 'struct page *' argument
 from memblock_free_pages()
To: shengminghu512 <shengminghu512@qq.com>, akpm <akpm@linux-foundation.org>,
 rppt <rppt@kernel.org>
Cc: "lorenzo.stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>,
 surenb <surenb@google.com>, mhocko <mhocko@suse.com>,
 linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
 "hu.shengming" <hu.shengming@zte.com.cn>, "zhang.run" <zhang.run@zte.com.cn>
References: <tencent_F741CE6ECC49EE099736685E60C0DBD4A209@qq.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <tencent_F741CE6ECC49EE099736685E60C0DBD4A209@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC6F14000C
X-Stat-Signature: ft935n11gxdja9q7e7hbhdq4955x4r9f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767125800-216520
X-HE-Meta: U2FsdGVkX19uM5MBaUUymQpqoQJ7V3mhKOS6Z6heva7qGw4+N6klZdnufDm351TIhanJEneVRcf9H6owbCYrG2lF3n8G4ROafIz52FbKBlY1/ipQlUgnLJFtYozSCtSJt+p89RcjGUGGRsrAD5RtG5OBr/jNi9wqXaC0HWUufB4IJleJsGBm6ErnsSOuYpOsJGBkyk6JUcML44vKkSlO0BnF9Tv7KsUzxmm+2CfWvWTPJ90HZuClw8ye7t+1O7bvTfPMrr6H/bRB81chCoRss+NltUvxHwubXilMV6XiRRKbYN6dwWFuM8haOMJvO9OC3WIMQ/ToUI0C9VCSdzuXHnUCrlarIbvFcqcJfneVqFjjXo09n8f/wtXwNxsIC3/+m/QV4ChvUl9CFQ58otGIMYpvhZWlDijM1ICmd0sYQpHKqXM2fOcSX0kz/zyirELgtIKjNp3gqDndJR8T855JqC9+NpbtDd1kT4DrJ68Om2dK0GyPWkN1Ze0plKoQXQrzdq8Fs2wN6Pz8/Sn7zgoy3L+2wbYy3gLTuTrI/VkI9SswXvyJlwMCI4NRd/pqW1ZUHL9MApW7AaOo86JZe+tJsOjN3tuf0Ba/lnYDLay8ut1WoEPb4Nnt56dPEaBAVHfGyqlsl5WnwUg0zZaCZCLxFAXcLn6eJb+pPbJkQIkWRmdE8DMWCpie9Y6TEm5slnQdQCI0iGKWxnlF6lK0C0MFA8h4Pk5HxD8zdEds5iWSVSrHPaRdyXmGF6aJGEpclRWALCF4+1e9kCmGYjQZg1yJiJ/UXuS6Do7zDAoODZCo2r/Nx0kkBG0fiGPf0ExInQQ7LNLabX3iUS12uGmvc+cewlDo0QcjabKDcVL59UoooTadUkcCHGCBJXsOi2EyzZ/qISvospYrBF3DXbRBZmuhPmOn1Aux6UvXM5uPE1WcNF6oxnqcvWqJIWbWE8wyCd7eFPt2Ry1TDmMA4IPggbv
 5U+C6NvH
 tIMi1RSiGyKku+l0VoXC+qtk45uYipOGtHVSBOiOGi3vrSYES0KtIk+mZwgkFIufppi7YMZIVojJ1MsFTbcUiMXyLbzy6aWA74xttG8COTUZ2X9JzQkbk/1HtlGQv/xlzNsZHHorYSNMaqpYtdrgk0f3i9MHrxxOgKOVFJvnt5PdPlCJ1wk7jpLmPZT8Mkkj9Y6Yu7i6LV4NV7UWK6Bmb0XHpj7FmnSxxC84/QQFbe5Q4l5lTNOgwrIxJezQGGoJ3vXG2mPSivDPnbaNTnCtnm2T8HlUmdRMUd7VH+D63gjBP5VVTUAV+oEhfVcUdvYQWcopsn+rmRoO43hz2TwCqoPJpplljaPF4OE4GbVLVI1atK7VPdTxJZoMmilXeB63xwh8dXbWE3b9DgGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 14:52, shengminghu512 wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> memblock_free_pages() currently takes both a struct page * and the
> corresponding PFN. The page pointer is always derived from the PFN at
> call sites (pfn_to_page(pfn)), making the parameter redundant and also
> allowing accidental mismatches between the two arguments.
> 
> Simplify the interface by removing the struct page * argument and
> deriving the page locally from the PFN, after the deferred struct page
> initialization check. This keeps the behavior unchanged while making
> the helper harder to misuse.
> 
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

