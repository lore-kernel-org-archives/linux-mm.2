Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A69CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2556B0008; Mon, 17 Nov 2025 12:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C835A6B0011; Mon, 17 Nov 2025 12:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFE56B0012; Mon, 17 Nov 2025 12:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC9A56B0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:40:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BE0D1A0221
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:40:15 +0000 (UTC)
X-FDA: 84120812790.15.FD91393
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id BDDA218000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:40:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ub6bc65y;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=og+tI+qgcqyr3k/rLDP3lRdV4OZ0BI7Iy+roWuiS7t8=;
	b=zDVQ4mGBAmtHEF1APqRyWj9LFsB6YsgWk3AzjaSCMpOJDcYulMeiQyFV8JgzEeRIENsSbI
	VGJTgM4LQD69CytOBe/1GHqMzs6vDFXmI/Cdu/bS5hPk4AFJ2LiPtO8FRiNJZ3m4ePHgzf
	sMvKm04sIDddIJ9G56jcPZRmLk7LR/I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ub6bc65y;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401213; a=rsa-sha256;
	cv=none;
	b=1gDM7rpVEhJeAU04lAf/1j1wPunHLH32rzj8bMoxgBbvXo9dMgB8ySCx5XFXKM9BX0uX2J
	osVdag10Z1VhnXfyFSvSAwzkQdta2rIMzLVZfujZcKlh60xC5xprr5Ka4jIJt30gS3lMtx
	RLWYtTTeeBhWpYFLg/m7/00QKpkXfv4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC90E43E52;
	Mon, 17 Nov 2025 17:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDC0C2BCB0;
	Mon, 17 Nov 2025 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763401212;
	bh=8qZhN0NBRQxt+JdBFlObP/D+8kNalh+BFzjZOa9IVwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ub6bc65yJ6CtqjV+o4FjeW+owuLgSh3vmzDhYrtlaELN8+Tbhqpp52kMBPcwiOA+s
	 hwVEPqPTTUNp5t+a48Vaa7M+CxgaHLsUmU5tArWGRraDT0I7uqmHGl+1YezuiIvEvm
	 XS5LAvogNCJGhBy1G6VF20cyteEiggf7dSr4Bcq971sYwMc2zH9GN8T6FJfHS99YJI
	 hGKe74SAXheDKQBV4MeGuXGz0+4U1FnEa80IpNIbpDyOURAcDGxmEI68+tRNgFzuY2
	 dDywo/5r9R9n5pqqSsQAZPeiTslCOVG+8Z3z7mN+LyEoXGBqUA5qQL+ChR8rxplzQf
	 ByVEg8BI3DkwA==
Message-ID: <c80c776d-182f-4f0e-a974-b9bcbcd394be@kernel.org>
Date: Mon, 17 Nov 2025 18:40:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 06/10] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <237bcb7f3d832457322210cc7f8d1272c4ac88ef.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <237bcb7f3d832457322210cc7f8d1272c4ac88ef.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BDDA218000B
X-Stat-Signature: qh4mu8j39edh6uipgb5d1deii4u6o5ci
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763401213-364397
X-HE-Meta: U2FsdGVkX184UUPobTtF70egewVlyulrJQR31FYtkLBID9cWa2o9JfTq7r+EHo37a0ylosOV0K/0VMwoDDdINr80VfoFWIEf6er27kJQFE1w+SR4RItTMxTH5OkVj+yn/e3M+KeV0HMmNb/2SPyoz3ykYVQHR1YhkH+tp+T6NQuL4AMVqg5OL+xqW7gNbmepnX4efxFV3Z4Cl9j3KPvPdM+0rm/urND9L4huCc42E/orpZq4XFXqIinMN4jpXseDj+TQwNduhO37GX2OY1vRfdSHpl8NpX2jBdQttWo3z7DKzGQejcCE/FXcUV6R86JziiRBvO+X2fk+BgJBiyBXjMLhgq6CVDWFhulEGO8+4PPy9hmfI0i6w/rngmwYMvLRekVHi4rf6WNaYpr6dbamNIncWdoRjMme2HggBfD3KLwClZqttLJ3of3Us96+PiNPG4CXJsOmvJPOh/pXDt8iUXo/FxAiBfch1XqZj1ooe9PjGxbUKYvRA7QWKpeOaVrxHeQMmKesCj6As0/rBHowLzFJUCUzFzQ3yXMylqklRsihZiodM3ZKwwl086Eb0MhWvuzwUiv9nG/HSLoRCxWNmj0AjqASikOl99WYPy572CoRwBlZCIP48gGMOTDMA7PCj8zGV45S/weii8pslmwvMDXLfkh9Srq4c2sXhSN4JVx2/yK6c4hWdRZtPGXbn4sfTLKnhlMAQWs/r0iSg1vym82z1+izCCdjg2uhwP22qGezRo+h3h/jBscA2JlEejaRKt3ybt4WoGCv3Ef1q1TKDBVlnOctEbXMz/Wu/5eP1+v/Ht6PnH4EP4ND0rmyqRUO2fiz4tCzPaFqxjyZ5Ln6bqM83eypLdyGGRfmul0vKrGm/0VR4wwRfiKzi9udTVCL+dDO8Q1i0hTqeFQWyUh3g+2VY4UidYI/CD5YosOH0Xsq8R3GAFoDMufWmJMqUKp2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
> check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()

Is that code even dealing with pages? Likely we really only want to 
check whether PMD leaves are supported, independent of any pages.

> instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/debug_vm_pgtable.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..241b36c78ac9 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -170,7 +170,7 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>   	unsigned long val = idx, *ptr = &val;
>   	pmd_t pmd;
>   
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>   		return;


All of these are currently protected by CONFIG_TRANSPARENT_HUGEPAGE, right?

-- 
Cheers

David

