Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC336FD88F9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 04:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5EB6B0005; Wed, 11 Mar 2026 00:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B966B0089; Wed, 11 Mar 2026 00:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074036B008A; Wed, 11 Mar 2026 00:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC21C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:59:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7398C1401B3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:59:21 +0000 (UTC)
X-FDA: 84532578522.09.1BC8D37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9B15C000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:59:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7QWHNq5;
	spf=pass (imf22.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773205159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYqmy7AhteoWd7btCXx2BOmJQ8zsXIG+24a7NHfSMRU=;
	b=UVD3WX+48sAJEsJdWr4LPCQDL1GkfsPq6xcZeQaCkitylcNgK99xGzHtbuAZ5JhcbaWrFo
	WXqoDgTsJJ1kEg6bJq2mfnB8jicIT2QZQ+rfSRxqydPg6sTa8TeVllECIVG2VH05ESjmnS
	WVo+CZVMwP27SSQPwI/yhp6TgBzFwlg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7QWHNq5;
	spf=pass (imf22.hostedemail.com: domain of mhiramat@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773205159; a=rsa-sha256;
	cv=none;
	b=2QNoidQU4lFpwDlJumsN4wFILWe2VqaMnLUCizW710DJObZOJV2waJDFMC8AjBxNrZNa/y
	x/tFqBHQwe5GlkgxFWB8O4mKcTugtaHWRX4TeHr7aWdDRscHuyQx8rdocREx7B4VJly/k7
	vsJ/4CGLjDBMrGSTOPlhW/iZm65LqkU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3382160054;
	Wed, 11 Mar 2026 04:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C9CC4CEF7;
	Wed, 11 Mar 2026 04:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773205158;
	bh=hs7h01zebVZ3Cw5TSlyQoCCjwzUa+l8Cgq+3i/i+v4I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=R7QWHNq5KYIpTwVo6Up5GHHSOdSE2gpk5GaKkIBbqjAR4gbzmNPFWIlQW10KkTPof
	 EwepFELDieEhDwLa7MFg7ekO96kgeq0l/+LlK0SmYNrKgD9B5JFn2p8cKdN19q4bAB
	 ZH5nM61a+EeP1bfo59H2leGLnAv8MA9DVbVTjKyoY75UQZCsrcqb+6U4ml2aryZAOd
	 53HkEOSnemZkK807SePgE6JYJ0qIK9ypnQbQrEKCx7cEo9CjlroOKs6BchxOV0buhD
	 E4Ehzc8FteV6XUFhu9KE6nGI0Pkr7s204WVgcSsEwXmzro7D3LuhuKd0AU39V1R3Ja
	 2cWkRLISF31UQ==
Date: Wed, 11 Mar 2026 13:59:11 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Philipp Zabel
 <p.zabel@pengutronix.de>
Subject: Re: [PATCH 57/61] reset: Prefer IS_ERR_OR_NULL over manual NULL
 check
Message-Id: <20260311135911.ced50d67e940cdf933a98d1a@kernel.org>
In-Reply-To: <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	<20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9B15C000A
X-Stat-Signature: dp491fa5o4q4imwmfheeha7beih7t6yn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773205159-449146
X-HE-Meta: U2FsdGVkX1/RJl/5px6MFOY5LFShK03NzTbg2VL3X+sAwbqgvYxu5e+6ufBftRiguXgFxp84IZzd75w5MU65xo/SMw7vZNgS8QtoCzvkLzk4tMgqxhyFoLE5t+cKDmOeTQZ34o67iSXEYNfk9CYRKNDIe40z6SZql5sZufA6grcv1kwlQxw5OxroV6dlxXsUKkDjNlIGSpHxjtv61NAWwI0sU4k2UeQhsCwm52u9kSs799tiLHTMpqmYtNkL8DsyRef7R1pdv1AEfhGOga88gQ0xUDln1P1xJZZ65Mdkf9eIIhDFtQF/dtpxI89HXPOENnl5mWXddDNwGz0tsl2bfbCJNyDlQJD4o/u11bD94/oV3rRHPV/LcDkAjq1wsj/Sl7tTAdrBhi87331M72ShmRPx1JrFgja2MgJqjA4vqHeksb45mYF2FyhaYNT9nJEFR2xbxMvjdO8ZPDOLBSIJSra+xtYMbea6/qI/t7curdHvCdvdRdNpu5Sll9De5QyTJ29u/RRsphCA7XZHKbafpAxaFSdXH+eLxIXevv/0D89/VfSXaAIGPodGEGydRJLxe62zrUI7Fadv9KXlzMpTQ4O7tib72Rg5nugjPksU8c3ZiqR9gPjY24ZdJniJcHu/Xnwawb/Y/y459YzR4pYowTqRy34t9cJ878BtE8MkDNjVIoS2fQG/crkcPWNZJ7G/2org8LOqcJ99GBHCacs+lUoiaOumkM+sbXJmx8QcMN5ymCJ7RMXCC7iRxN21qugvTtkI7RAc37wi8YHJP7Iaufw1YT+owPEW+HJ/x4sF/53LNlRo3tBIQEwHGR6d9ecbt4mvnZMBe3OZOrgdvKLsInosVGQvXq4HW6O2OhCH8FfZY+YUwsGBQWuOHXzs357FV0uJAS0jNbiLMs5m23SfCk+1hofCdAHIAMoGgf+qOfau8sPOUbjaXKQLspaDNBaH/9J49GsWiziGA2lpVhD
 wBH4+1M3
 LxArP+SM0k0cCgWgKUJ742MlkbwO9wWlQhcqOOxi0x72z3sGOY8W7EyngfQaYOaSzF8Occ3qpxsFURoef+yVFLYSuM9uFkXtVHRSeSPTnDYBAIPNMzDMwE5K0jS8u5BzujP0IVE9d04VvZE/KiiRIXir2xqnrEdvRtAR26S64+qMaja/lmP2uWedAqNYEPxJpMYQtoMEs/x8dGk8iqewMNlYA9VhtO1thYwdknjnU9oc6mpMPZ8DVwJHTPWQOKJrpCAv4dELnIF1VbXPj9iKxKiq0vpzZhAaxMwcwNa2UhJL1sb28XZCMXDqDV5LUieM1koqbpGvVy5X8fxaNVCF4iJW5aLAmQtxqAt+GaTPeGSfX+cwAyVf0wiS81vkFW/tsKIlT3lVbjILkJmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 12:49:23 +0100
Philipp Hahn <phahn-oss@avm.de> wrote:

> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/reset/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/reset/core.c b/drivers/reset/core.c
> index fceec45c8afc1e74fe46311bdc023ff257e8d770..649bb4ebabb20a09349ccbfc62f8280621df450e 100644
> --- a/drivers/reset/core.c
> +++ b/drivers/reset/core.c
> @@ -715,7 +715,7 @@ EXPORT_SYMBOL_GPL(reset_control_bulk_acquire);
>   */
>  void reset_control_release(struct reset_control *rstc)
>  {
> -	if (!rstc || WARN_ON(IS_ERR(rstc)))
> +	if (WARN_ON(IS_ERR_OR_NULL(rstc)))

This changes the behavior when rstc == NULL.
WARN_ON does not hit when rstc == NULL in the original code.

Thanks,

>  		return;
>  
>  	if (reset_control_is_array(rstc))
> 
> -- 
> 2.43.0
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

