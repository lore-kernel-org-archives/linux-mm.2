Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5F4F43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DA26B0093; Wed, 15 Apr 2026 11:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215596B0095; Wed, 15 Apr 2026 11:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152BC6B0098; Wed, 15 Apr 2026 11:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 070DB6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:16:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 839B2E3E96
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:16:45 +0000 (UTC)
X-FDA: 84661142370.13.BAA5DD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0F1BA0018
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:16:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PeixNtxt;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPaIksufZJio3K7xgkcnWKdJ1OEFRneeucF1RyJRGZk=;
	b=CM5MgNGM7388zmVBUK8mpoZS1jLf9K/C7JSjiGDXtUfwTnHOCpMtaGcfOinTyziFvcCK2o
	38SfpMvwsiUXmN8AjNp27MZ1S9Cqinn3GdreIcDmLNiM+FmEE5Ju1WHxA/rY/021o+NJln
	NkiLyzoZ+XJHTzqZgzQkP/dL9ESKPpE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PeixNtxt;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266203; a=rsa-sha256;
	cv=none;
	b=2VvNRnDrbC/7WBLCyUxJQDmlgvr2GqUjuRGFEY7p7kbuSrVThNgAzDal4q+NY4Pkpc4SSv
	HPFvNvuqdSiwHGKVVu5uHTGwsnU4aMqOMi+p+29ihfC+yd5bYO/+tpcWqgOpapOdj7ltkC
	KEPuyKhbPT3f44ocXa2Y8uYP24+Os4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AA5C600AE;
	Wed, 15 Apr 2026 15:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA662C2BCB0;
	Wed, 15 Apr 2026 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266202;
	bh=F4KGIvv+ekuAI3vB0oab0A2O4K7f+5iklLIkHdO7GE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PeixNtxtIIhouZiupwJ0kiocY0agTOJ1lTQJehFJpOeWbTt4Y62gNEG451Pz5dP3N
	 Ky1zY1/1mvTw0I4Np16cZTinUoY+/mwIjRkvcyH09ClXyVq9H52WUnUbECyKTRAJyJ
	 cFW3CJeJK54JQAZUdzEk0QE0DGFHnFtU7w34bWqjFEOPUUe13MuzURzWVKfqVRKnxw
	 3cGdkxstCp180ToMwh89CrCSoL6xBGRJ3TzQ+PRC7ji8C2xudc2/MnL3aGmicQLJGo
	 sz/4V4Zvw1i1O1on28DzgS3g4uar7rzZkQ36IhnAmCZdQbmr3rV2v93DpyUfdPixqG
	 X0pJlD+a49eEw==
Date: Wed, 15 Apr 2026 18:16:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 01/11] liveupdate: Safely print untrusted strings
Message-ID: <ad-r1WwHG3RxobAG@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-2-pasha.tatashin@soleen.com>
X-Stat-Signature: tqx3x4owpjbhxmywofap6wiqhrozq4oy
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D0F1BA0018
X-Rspam-User: 
X-HE-Tag: 1776266203-214947
X-HE-Meta: U2FsdGVkX1+IpZy3zWmYfiOtgBT3xf7RyKz2sTC0NKGeQyktfQPRERrfKxERQ3Yq/4v/wqaPf3yPagGdHDWbq+7Ng8+XY7EHUeuwgxz605IpFPxv6bc+dAmOLNABAj1LpHeF1ulL5BESjO7j27ZIlq7qehyXfCLtxngA87WsHvwc2kaZgj1UQ+ps9rZWfZy1CBYlbo46reu/XKyicgTieVFg18R21urIraSAECLxxfbRinuZ2eBVgft2kVsgQ4Fh0j/Pc0wnYkmwoaPkVqG7vuf+SD2SBrWMiQGDsrcsYYTZyPO4aIMo6kyPzESAvgYdxcwZYLfuWkqeq7Ove5iFFW5W2/h5gEOAT+XJuse+XJheRXNSlZCgeRPB3RnVym1j5Itn7wqq9RK2IiW7CGEUAjQA6AbvO5SAgDRgwkoLk8hD8htDnn0tQGigu40lwFXg8PJ3Uq9ac5iEIgLs3N5dd1m/FD7M9waa0Uyk7baVPzw+PaKoIw51f6JaHxrH8IaLfJcjXPswA7aXKG53ZELnPMtsz98kXRKKYoobPgIFzTQ9V0Y9p3aRNlXCq56c1zQaTWZZXZQmvVofKwniblERW9gsLpRZiGIXI2eYKWt2uw1QfQFGFDI/L+a7L6vbQaVzfRK6eEXtlJwWDiRosUN8bCrI7m6vy9hUbwNbyHTaLt4CFMTjKYEuS80wlKI00QNsei9h2JaWLMl1/LLfa0BQPL3e3KqP9UF8YR8sXZ/R+vE/ltCi+s0w+X0T8Z5TOZZ0gRMz2tgQmyugo64Q+BDsPeNe/CQDbOhGqnYw1akm1IVk5K0KazlffluQmN1azDGhKXhGNv1a27BAOyBkGiUXM94g9C4a83ulb/qj/AkUDYu1FaRe3Uk8ffJFwmVl1G1RgC9G/Tvu90m6me1Ai/XV7l9uKcijzIl23UuAL4zPcsajsLYfEqh3+l4GmP8ebTHJGUi3j7cZ5BlImbIlv+n
 ouLJ/nPZ
 EosUsKAqGd2bmrNem0NH/lricScXrzx0fhMaa0SH4k1xjfsWfpnD6odO7+MicQ9C13U/zX9Z850QAwN6EdZ14YKaXZ74uDI6Lo3YbvS8cF3E83Fr4P3+LgEek7o2OMr3+da9+7h5PTqCuqaJyAkE/BjoD4qNDoBJYld75TXNu2/JmTga8VYMv7CJaMi3QooareaWawU0vz71Uhl9W8XnErpYZ4F4J7rDrEINeY7jYYuj8YVIk3Omg33+TTXCXuLwpXVJIvkqhgm4hw1to9P0VPSInQu37AbZEJyi9jec4adk5VsfupVPzDsDECQvBO2BOO/SUOqda6JxKCmzqPWNa/OORGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:17PM +0000, Pasha Tatashin wrote:
> Deserialized strings from KHO data (such as file handler compatible
> strings and session names) are provided by the previous kernel and
> might not be null-terminated if the data is corrupted.
> 
> When printing these strings in error messages, use the %.*s format
> specifier with the maximum buffer size to prevent out-of-bounds reads
> into adjacent kernel memory.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_file.c    | 3 ++-
>  kernel/liveupdate/luo_session.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 09103cf81107..8fcf302c73b6 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -813,7 +813,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
>  		}
>  
>  		if (!handler_found) {
> -			pr_warn("No registered handler for compatible '%s'\n",
> +			pr_warn("No registered handler for compatible '%.*s'\n",
> +				(int)sizeof(file_ser[i].compatible),
>  				file_ser[i].compatible);
>  			return -ENOENT;
>  		}
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 25ae704d7787..8c76dece679b 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -544,7 +544,8 @@ int luo_session_deserialize(void)
>  
>  		session = luo_session_alloc(sh->ser[i].name);
>  		if (IS_ERR(session)) {
> -			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
> +			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
> +				(int)sizeof(sh->ser[i].name),
>  				sh->ser[i].name, session);
>  			return PTR_ERR(session);
>  		}
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

