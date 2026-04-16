Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD19EF8D751
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39EE6B0005; Thu, 16 Apr 2026 10:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11EB6B0089; Thu, 16 Apr 2026 10:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F016B008A; Thu, 16 Apr 2026 10:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D30C86B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:21:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6232A1A0964
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:21:22 +0000 (UTC)
X-FDA: 84664631604.08.325795D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 975264000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:21:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oe2t5+z7;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776349280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4K2jZDLOgjLqE8vzZ8VsMxoGITMbdET6bIYikWU0Amw=;
	b=qxkpKZgGFqgZqQBUTdfQe6prCFqE88xHI1JzfGI6VcbLcwmdiDZgOMxPoav0ntFt8soV7k
	/ID65BTAbLNX+vvNwjvKSmGNh8AGO7eutNuXQzx6o1v/yDujnmxB84LHuY67ZxAV4Y/H9E
	Uysu+eK0+bNtJYMBHID24bkeeTJ6qAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776349280; a=rsa-sha256;
	cv=none;
	b=quFOFcra88m+/NxJbkdnaXBoTsnyVJcOxImsMqnucW/Yh2VZceG1wRRtmvcbuzkGRGB0NO
	dqsctufOXk4ZphD6tYwVz3URDIxI4Cpc/7HA54PlpVLWzNaR1kfMMZNti/JBA7UXpjZhUu
	2aEBd9plE1QPaXL9/Bew3rTKeG65d3A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oe2t5+z7;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D36F41784;
	Thu, 16 Apr 2026 14:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB81C2BCAF;
	Thu, 16 Apr 2026 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776349279;
	bh=goIGr1VWqtoxFlJd8A5Gj+T0KxtAuEIioygKOm6pnII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oe2t5+z7jeGkFU/MpzQtFWXZsqynXqZ4J6NpuGlEk3K03M0+KQDfzqzIoCbO0yL3W
	 UGw14fcnDzbxdobtmPd7iJWuRVScG7OOig+LNPPNHqHXNQSlylJyDuAux0dfyQg62f
	 gSErogIWoQCR7b1M69KHitv1ZUi2d5yREua8EUvTLn5vLumpMWMFH5mCXmFfdfS02a
	 uw2Hj1spvasrwAC1FGv485/xzb6SGBncFCBhplaCVJbbceTBHbBVkpFreiygCpqvJD
	 9sWw82CgB56xgsF9/+dsH8jS9uldKPF3PSSHnvTlcY97vTKsFDbxJgPHCalbTov77n
	 Cf/UndihzvXig==
Date: Thu, 16 Apr 2026 17:21:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4] liveupdate: fix return value on session allocation
 failure
Message-ID: <aeDwWSQ_po0ytRQo@kernel.org>
References: <ad-xwh2Ecr3Yg270@kernel.org>
 <20260415193738.515491-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415193738.515491-1-pasha.tatashin@soleen.com>
X-Stat-Signature: iuqo3yf1yzx9jptxs8w48j4qwqoitepy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 975264000D
X-Rspam-User: 
X-HE-Tag: 1776349280-931243
X-HE-Meta: U2FsdGVkX18zaf6n1etboi4ZnCW3YXNibI+NwBTuSYHTqf04Mshgq1W2tzaZ6z0PTQXjo/mZP0dDgNJTePeRAoh5vVX/5i18zaeJSi/TEa5J8N7YD2kKrugy0Rpl/rs1L4bq6VKk1xG1MrnGxI7yqf2HaJ5FdpirQvyxjn85NK5Muv8GvcJrdpRytuYfMIhyQf1OvQdRUIfk3DILUfTi+HPR2QeUap8bCT+QYTCK3QXofYzGqKwtIcASNYzzWpvYUf3KGQMLBzeKP1gB/MCYcysIyVc84NVgcYlUCf7mN11Oy/hBIce+wNDVClpROZfpviuiOIOcF9R+BGGQtPdqbdjUCumy1qPaAeZJ+RG+bm9kfedoqbja4qtIIKUhLfZnISSgPwXl3iSINealhrEGEa1lwlw0e10m48Gddf6p0ZKV2Ud0QgBih7AixDrRheLoJwHClKZOdHeSouUPwAA7gdw6Pfm1UrQw64xfFLEAcyYEpvDUNuKYTdSZeUdQ23bfo9uNnvwARHsFjxcuwHmN61jL1PQUYpREvuSn0MWAE2Zl+pxFR/v69CxLTCiuMfoiA/mn2t4HrkK/qcKidKZ3KPL8fxHUw3Y6q20Mjsw5FubMOO4ZJtDShdf/IHj0HBs6rHrKL63dY+dBR71QNoFHHEjgoHMBwrFgKKkm+h5lS8GM+igjwpUHb3pgWIrqELhTLqG52qzbieRHtKUW6RV0anNjqFHju9H4AxRTf20Iy/+n0bk8Cv7A0rto9RNkyagIC1XwHFx4BvCI0cu322iwj9l+3v3kNBAfIR1BiNNsgUQR/H052d2hmjslxlHzasZAFFzUBO+M/6TBL8vR+jz6zDzS+A+GgcrXZ/q8U5FxoNBHUXIA8MdVI6agdijEXU+vf37jUH7/sMtgU5DxecHtdpWgWTmqruXHVl4GCvY7nVi/4LdbDrKPohbzAvY1nJDS3IwobzFxNlo3IuYPic1
 kxJF6P3A
 6V3i7EzYglASsuDzmGRh1GzTKZgyBAtz2P0V0+EdTOVdq60bWNMIJdjm6L50L8eMcjW6vzVlOdLV+Of+vr61eRKmAgD1d7cTVFMt/fExYr2aB7zlt1T93puoGO00MlGcYCTQG4IUEYSsHJJGXgNFJrX0mi3wfoOmeZ+NOHCjXZ2FDY+xI5nRGGSRgGON2BeTusYdBpDLKGW53jjrEci/lbsVcOqty3PdWBlcB+3100eSKVuBWjevTv9t7ClplV0s/0dD2iYMzqExABU43ZQ+P+rii99QHqLXFlCJ/DkktiXOTJywxhWhOhM3Z6NA8xRglLgfTpm5pMLxzuXzJJKnlOGzrhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:37:38PM +0000, Pasha Tatashin wrote:
> When session allocation fails during deserialization, the global 'err'
> variable was not updated before returning. This caused subsequent calls
> to luo_session_deserialize() to incorrectly report success.
> 
> Ensure 'err' is set to the error code from PTR_ERR(session). This
> ensures that an error is correctly returned to userspace when it
> attempts to open /dev/liveupdate in the new kernel if deserialization
> failed.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_session.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index a3327a28fc1f..7a42385dabe2 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -514,11 +514,12 @@ int luo_session_deserialize(void)
>  {
>  	struct luo_session_header *sh = &luo_session_global.incoming;
>  	static bool is_deserialized;
> -	static int err;
> +	static int saved_err;
> +	int err;
>  
>  	/* If has been deserialized, always return the same error code */
>  	if (is_deserialized)
> -		return err;
> +		return saved_err;
>  
>  	is_deserialized = true;
>  	if (!sh->active)
> @@ -547,7 +548,8 @@ int luo_session_deserialize(void)
>  			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
>  				(int)sizeof(sh->ser[i].name),
>  				sh->ser[i].name, session);
> -			return PTR_ERR(session);
> +			err = PTR_ERR(session);
> +			goto save_err;
>  		}
>  
>  		err = luo_session_insert(sh, session);
> @@ -555,7 +557,7 @@ int luo_session_deserialize(void)
>  			pr_warn("Failed to insert session [%s] %pe\n",
>  				session->name, ERR_PTR(err));
>  			luo_session_free(session);
> -			return err;
> +			goto save_err;
>  		}
>  
>  		scoped_guard(mutex, &session->mutex) {
> @@ -565,7 +567,7 @@ int luo_session_deserialize(void)
>  		if (err) {
>  			pr_warn("Failed to deserialize files for session [%s] %pe\n",
>  				session->name, ERR_PTR(err));
> -			return err;
> +			goto save_err;
>  		}
>  	}
>  
> @@ -574,6 +576,9 @@ int luo_session_deserialize(void)
>  	sh->ser = NULL;
>  
>  	return 0;
> +save_err:
> +	saved_err = err;
> +	return err;
>  }
>  
>  int luo_session_serialize(void)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

