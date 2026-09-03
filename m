Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8057C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619B46B00D9; Thu,  3 Sep 2026 05:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1D26B00DB; Thu,  3 Sep 2026 05:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507D66B00DC; Thu,  3 Sep 2026 05:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE366B00D9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:43:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A5C612043F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:43:38 +0000 (UTC)
X-FDA: 85171963716.19.DC4E2B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BF6F6180003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:43:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PQm2T7q1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788428616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eldXMd4hqRZkPJl7i6tyydiUfeNUbbeC/21E1NKLLUM=;
	b=tKJxz5ARWD9LigyUSnUaAQER7H1evlfuFsW/3H1tfNGi1T/yoTdk6zGGx75Y7F+qBizXaX
	XpUYz5IispqGR4W1zrM+ef95BnHbJFDV0oJdtVChV7bWQQNRYizftxSXETyldqk23VZ04v
	Kwf9+VdfFIaQTTgRtQbBbljXnwe+bNI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PQm2T7q1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788428616;
	b=BWKIdY3GIpCY/YcKtjoOe2RrZW1FGqyVUUttUPBEb4qC6XezVwvHqob3cyankXH+b9zVsJ
	dxzryrZ2lH+Kikqk+bFTevGI/NXmp5M4ifkp7fsG7Djx567l250HJpHQchEhO7+/0VmLe1
	nJNgWu7KfYf7Mtxo5AJbfqAnAg//V+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE74541A69;
	Thu,  3 Sep 2026 09:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A844B1F000E9;
	Thu,  3 Sep 2026 09:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788428615;
	bh=eldXMd4hqRZkPJl7i6tyydiUfeNUbbeC/21E1NKLLUM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PQm2T7q1sFBEZXzrTXsvySGsWdMAs3OwaNgKiY/BCwm3f+E7VHtDESnkCXMDLR3FY
	 Bn2APwdb5qNikT3TxprobcmAZ0KW0vMQAHmtInQQ/gf1qsAgwofqbrxSXM4Zcxgqib
	 TtKdqgxaS6eVdI7IaiN0jwr6sdv+kWugk3uBIZgQQZKNE0Qf6YBeByrgG4F1x4/MJA
	 ELyo/UOtC7fDzJ6k6HQl2TvmhXUXdgUA+8x0C6FBvGmUWhxv9GzSIhlj+TgtzBWQSZ
	 oklp+CyGoVf5WbUaE8ulxzaU16qL0MlU5pc33UuEBfW5Ryo6Rt9vOLdvCVhUYyNCmv
	 n0IlnbMvxe19g==
Message-ID: <87a29ae1-6a4f-4083-bd4f-7ff0295ff046@kernel.org>
Date: Thu, 3 Sep 2026 11:43:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: preserve original free_pid/free_tgid
 during folio migration
Content-Language: en-US
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260903092126.24685-1-hongfu.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260903092126.24685-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7a6sk8gda15mbyjay4bwbechr61acszg
X-Rspamd-Queue-Id: BF6F6180003
X-HE-Tag: 1788428616-739130
X-HE-Meta: U2FsdGVkX1+rqo4W9uBQgvRTYdTPMlBB7ehu/FpSNXo+5NWlOWXG9Zq5XSzkVVAPB0TW3+2UWrleNUUfeZUPdViqfy0l4w3b0sbRMUNLKt0FOrHzUlBgghAM6sN9zwqu78jDWGj24cSKEvLisvezGi9cEJ07nFthYIgEuGbEirbLOJOlCpIljjUT5JKgbEDWhj0BJmHKuBa4NN1uYnHtg2sIRjuroi7cZmZDbk+NPPc5r8kNI2DQyjISdVlXvreo19r7Vlx/UuRV+UNsCDSI5oAzUSWXvDAVyOl8c6WW2inJmNRh+xk4Qf/v6+Wy4O1qzZ2oezLMRH1f+MrmRBzVd3DxUmhbCkvUfGRHYic8uCmKLezTCmVPV3wzfPTYyRWaEetw6R/mHVTK0A1QeTiJqT1i70oh9Zo9WXd8Kb/GoSZy2VEyvlEffl/7vlmq1Vc4IE3ED+aXMzeNl12urYQbCqqZP5SwLp0x+3PQvg8EXTZBWjOozmm3Z80CXfxMIVxFtD9LLqMFk3TIEYp+mwW8YgxyDdJVYHdTjaKGi7qKUFGOduzuSdeM3vd87QFq6KUV8pUBGU3smkkwzXH9TZuf8zxERrz/n9tnfcye5GrNnSbJVKGTsAyEb6IYFY+mNJzCHV0tt72LxmUmtKVI3ydVjI9lbnPjh25l9HQokJ6rkBzWWI+tNIAQ6+5znN6KdSQAedWBtm6l/G7qLEOAvNCiqTuIQODD/P4bHXeEW2JnHIoB+TNOEFJ1XpPu9WX/upG+Bgp70QcgFvKKYjAzvmCZx+jzp0wmYCskqdY1Etq3v8VJBKT0oQxdsCzmNeOS5Dte7i4thJRLNLA+uCz7j75K8EKd/wQIk3guXNZgywCUA44AgdDhgBTE5VF9SwyjOK81sqsBmCozuM9VgZ8WuldJO32HPzDyGBg01IHoUrkIfC4h/K+PALbK+6W27lV69JvNo4KgWmdbOVjpq2q4w20
 OZzd+1TV
 j5t23wsYUspWRLh/ecDvaOtvJQf2gM6ZZEsXoMp01HtqLUK3Gqnq49V75QpnhgeE7buU/ijskuSogyvDCcNh9fLHsTyEqsDmA7xwP9nA8FflJhMr1jY4wvvdv8aW3OsisXXZNC3r3yeh0PUgwvsl/7T2Xd/UQeDUhVDCjUrdrh1klLnvnexSaatlYuoITPgQIHN1vGxg/Me++mZtR0cV4sL7R4EwNzcwsvYtA0UctSqobZsjk5nE3cxzM0+i6QxTjQcK+gEySO5Kw1msiIXJ4RK+D5GBcGwVoQIuspYVaL4mrSMUkOusnwZbi3BFYCX2lG+ByLBp+eKM4HAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 11:21, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> __update_page_owner_free_handle() accepts pid and tgid, but ignores
> them, always storing current->pid and current->tgid.
> 
> __folio_copy_owner() forwards the original free pid/tgid during folio
> migration, yet these values were overwritten by the migrating task.
> 
> Store the passed-in pid/tgid so the migrated folio keeps the original
> free attribution.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Fixes: ea4b5b33bf8a ("mm,page_owner: update metadata for tail pages")

(not critical enough stable@ imho)

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
>  mm/page_owner.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 3fc37d9b908e..cfc31c92d765 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -307,8 +307,8 @@ static inline void __update_page_owner_free_handle(struct page *page,
>  			page_owner->free_handle = handle;
>  		}
>  		page_owner->free_ts_nsec = free_ts_nsec;
> -		page_owner->free_pid = current->pid;
> -		page_owner->free_tgid = current->tgid;
> +		page_owner->free_pid = pid;
> +		page_owner->free_tgid = tgid;
>  	}
>  	rcu_read_unlock();
>  }


