Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A2DEB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3316D6B0089; Tue, 10 Mar 2026 06:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E90C6B008A; Tue, 10 Mar 2026 06:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F356B008C; Tue, 10 Mar 2026 06:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 125E36B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:33:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC6B21B83C4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:33:47 +0000 (UTC)
X-FDA: 84529792494.27.48DB5B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 09A2A40006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:33:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PoBiWwP/";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773138826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAiiRheaH2AeHI/DwDRcz8L/YNZeEcKvchS3XukuuHM=;
	b=TXE8hhCn6WkWhpK4MWBwkg5sjDMo4TcPfgcqadV8RbRDh9JiKg/aVOrr2Q8dIBkIzFgm1d
	411vOyGf2ezdcRZuiG0hXkU4BKplWwRHwZzM/bIQjx3RNwggEQbxjPkpUgia1FWipAwlPZ
	b7cm5Y1EZFyWb8CRgDe59S7UZHH80lU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PoBiWwP/";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773138826; a=rsa-sha256;
	cv=none;
	b=CDZ7GxrRxrUI1y9rpryd7yNP18o3MFrG8MCDmYZ3REQbgaGv0Cx2DTx3c5K49IOyqC2/i3
	BccVDwdMf75h0nldBcnOYNrpkZgSY3apjkb4SH/CuVMwZppcB+nb5aXq/qhbwLUklxEcv6
	6lx2JyIPu3r14AyXVi6DDifcAEy4Wt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F041443FA;
	Tue, 10 Mar 2026 10:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C35C19423;
	Tue, 10 Mar 2026 10:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773138824;
	bh=ECE4xmh6kRZf/kIT7/6rB3iS7so/etotWxeKzoWbm+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PoBiWwP/Rm5yU49N/sDms4v+xmjkjdzd1To0opImrEbV59JC3YYemr/v4RJrp3yjP
	 LvvfPpnP8JK+d7w3Qr6jcO+BUL2mv4wTohbNyO07suKvUOJsdxTvjicOstulgBda+b
	 pB4ugJ/JE5RkftJfWPF9X2YMh0W/4atpTARAW/LTXbXjgua/kIMcTc5P/zQcMZrJ3k
	 wbCT2aTHtwB+kOGcsDhmLo+Q25U450SutGLnVZEKekCPRpP8hmtgr1QAPTMdzCm5gO
	 2c3y+56HcVJNEWpv5peHiGeIRWJVj+7NLfQlO5mOH9dTJuy84IBrizkcRc0fZM/cKs
	 uqnD7h5Spsaug==
Date: Tue, 10 Mar 2026 12:33:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: drop restriction on maximum page order
Message-ID: <aa_zglmh3AU2_RA0@kernel.org>
References: <20260309123410.382308-1-pratyush@kernel.org>
 <20260309123410.382308-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309123410.382308-2-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 09A2A40006
X-Rspamd-Server: rspam08
X-Stat-Signature: qyap39p9ryn5rydcxgw46jit6bh1yoft
X-HE-Tag: 1773138825-909104
X-HE-Meta: U2FsdGVkX1+jk5Fl8h+gXq/tq6pGmuN7Ff/2Wk7v9dJU8TD8p04tQJaKDzMTuRr3jU4znCWvwETBqNpxIsXL9cQygTKeW0Tp0G2h0DFhjrsdlri5wSbEhpjTbKdzx6bdWRFYtXzTDXKEAvzr/Pbe2Yj3qV5BI5sIDHs2cnTXCzbwzrVZ2hLV3wdAIWvcWy2uLvGoRAGybuReZ2ivbyXYIjHS/UlVC51u1rcl+Qa7SmO7KdR8f0ISWIrGjepKalY/OUO66d8xkQW4PlVPFv83aEYs7ucaFwpomknUy7e1t8OtZSfW8XIQkAiq7uqWPYJZ0UBbUAI4xo6Ar137PlQ1VWJiHnAF9I2824jRMIhRhQCLD7Db0AdSxxU6AajNLaPDmcBy+B2BSxIwqjK7tWhSfdMLJKD2c+nbqV0rcXp8G9wiFlsjj2N330BWGl8XagxwtXba4VUuS7W6Nlo8W8xKkg1MKo42LFlKHRsuaNG6r0lkRnyglQzlx5yn9Cle/397euKaNYy/gsjv5zGjEmK061nhHxccfFaxZxVB1bc/okUUqAC+OMvenxlncgfXGM7YotOGV11wpoHUrfr4BLRDRHmJFRqYaqn9X+HP3BfZhAyoZQmhlOg7WBYnf3j0oyw1VQJht04J4VzpLUKlb//FK2l5ck57aZr/zZfP+M9jGUhhjTxa5q5ur2wItrfP6dqaSmpgGYW8sIZleeqzzs7+uMVuDz6wdZB7tb0mtC1W6QqnINvt5mhvblasQDtMUDIPptIp9y/ZVG6TrX4xyC+VNCtFBMdtv8Pvwaud0TcGlxAhYUaYWBSy3ESZCVw4DwXmC0fOVsOkIg1CDZjMYvJpb8+73MqnLwzPkumEvuN+yWnyWxN73hxzt9j2DwQIV2MrMEeDCgbPqxS64NA8X0wwiacBvgGi9btoH0w8gIvXo37you/O1DSDuDx2dreFZPn7joAANhQvWDFrwAwqTlb
 QN9ZKCgO
 Z8/KAmlhay+N0XgKQcvcVrQRq2MQaYk5rUS06MSGW8FMMWloQRlkaUFWYjmx0IJpaCuHB2MvvjcYKg93fRTm2AEppYSu1QjR6q3R27hvD2pJQSGAB5acQ3/TkVMePRMF8urZ3jFNJEiKuHWNpw/JxJ85GeDn4uPZABiKN2Zo9uDsPd1s19rMZ1neJeB2jrIvQwUSb2UhfCHYqfmgboUO2lLzbBzy5U/mMEWWtOe6l5Ps7eyIg+tcDGm7zjglJLDYuyqI9yvjvFrCPpHiTBWhePddkXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 12:34:07PM +0000, Pratyush Yadav wrote:
> KHO currently restricts the maximum order of a restored page to the
> maximum order supported by the buddy allocator. While this works fine
> for much of the data passed across kexec, it is possible to have pages
> larger than MAX_PAGE_ORDER.
> 
> For one, it is possible to get a larger order when using
> kho_preserve_pages() if the number of pages is large enough, since it
> tries to combine multiple aligned 0-order preservations into one higher
> order preservation.
> 
> For another, upcoming support for hugepages can have gigantic hugepages
> being preserved over KHO.
> 
> There is no real reason for this limit. The KHO preservation machinery
> can handle any page order. Remove this artificial restriction on max
> page order.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

One SOB should be enough ;-)

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     This patch was first sent with this RFC series [0]. I am sending it
>     separately since it is an independent patch that is useful even without
>     hugepage preservation. No changes since the RFC.
>     
>     [0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u
> 
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index bc9bd18294ee..1038e41ff9f9 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -253,7 +253,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	 * check also implicitly makes sure phys is order-aligned since for
>  	 * non-order-aligned phys addresses, magic will never be set.
>  	 */
> -	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
> +	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
>  		return NULL;
>  	nr_pages = (1 << info.order);
>  
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.

