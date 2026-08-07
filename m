Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D5DC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485FD6B008A; Fri,  7 Aug 2026 06:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4101A6B0092; Fri,  7 Aug 2026 06:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D77F6B0093; Fri,  7 Aug 2026 06:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2BC36B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:06:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CACB4036A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:06:00 +0000 (UTC)
X-FDA: 85074042480.19.0E60725
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D408640009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:05:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7RODPVc;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786097158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3Y82uuF/XQW5iDFHNIUgMEdIc1HrOdEgL8h46LMPJ8=;
	b=kHtrOwiFfpERx2Gn6rPryE/1XZ25YkLBBoRNRlwTYMjWxrx65/Z+ZkJqL4giW0hAhD/sEL
	AOZX2lm18Ysg1peb+hJWtRAWi04aCspaKvgv0GKzzzo2vehn5hh1rPi0I8qHXgjggk4LjI
	D73ERYMxXeL2sZx3nedA3/6dDfM9LGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786097158;
	b=kPp1pKZV76fEAk2TB9sf+FX6nDu7gP9uHZxWtgImNV0qNSRMgmH+IgOQj6HpogBwkdw7y9
	uqlOolCqZWVKJWTn0RnX0zk15UpKlNXUvQXN8slg++1+0EvXaN0g0rM0ySfrkHf99I1MsK
	Gz6NucVbgXDjqxRM8erKj8wl0Zkrq4g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7RODPVc;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24E7360AB4;
	Fri,  7 Aug 2026 10:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DD61F000E9;
	Fri,  7 Aug 2026 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786097157;
	bh=O3Y82uuF/XQW5iDFHNIUgMEdIc1HrOdEgL8h46LMPJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I7RODPVcJBRsd6s9UWRbtl8lpLOuBZpmxFX36HCqgpaIVZNVcAujidNCKp4lU2FFe
	 BAm1Sq94dhTqpSAovKm8Qh0kXVTk4OAQ/EgO69kB7YrXIJOSCR3U1XsIEdq5+PQj10
	 dgsj562UwM3s3jCZHLRr76XK0JLD0TgCBH/4qVwMueLXjV59DBZ080kXS6S8sd9xO9
	 dakp9bUiDf+bNOEaUGRXfrC+ZEcoMu7JNmMhqMRnS+jsDDRTLzjdmrIIJlVcLWVmQ9
	 u5ExWj5KFg4XfPKlyW3XiWRNCETRpSCzh7i3n/3YhxppLjDvmfAIQ6+yPKfkV6Mpni
	 yea7I4chqnnyA==
Message-ID: <2fcfa480-e4dd-477f-9c02-42756f3aa373@kernel.org>
Date: Fri, 7 Aug 2026 12:05:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
To: Jianlin Shi <shijianlin11@foxmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
 linux-kernel@vger.kernel.org
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
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
In-Reply-To: <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D408640009
X-Rspam-User: 
X-Stat-Signature: coxswyw6mddgncmrhg8ta188up7696p5
X-HE-Tag: 1786097158-965463
X-HE-Meta: U2FsdGVkX18z8nj/rJEaEuHhkGtEffK0pL2p66Td/xc3HOguaxnKeOceM0aG/JaT10qWafgQQo6HxPJB4cZ7TSBYXM3gEjjB8NVrlEvNxRFyMfkDH/kQSE0lEGxtWJHsM0/rSd78V7sBaJ+ZsYdEImtCIUioq6vvgLIPEHjS3DevGtxrNkUSKo4Q/XB6KqCCu2IQ4jqEEnj9hGUuQ162rRUxKr+8PEMweGbh+jXidVwCNZv0HeEmaj80ag7vNXmmJKmMxHGvj6DNME63SI4qxSGsW6pUln9Z3kA/R/Z5Jig9hzDKapCcq3Zwn9yxRzy6P8rDv9XoFX98DTtgR3OJ047B+i5UrZXDlGomKNh98KD2vYYJCsUZWGByYbqki5EtKKt6NkkDVbv5QQ7zX3IzwGU7WkUvcAu8CAyPOAXlj/+XVphfaVkF5Rzpq4c4BVKWmT+qZoqP1N/m+JBlmMuJzRmtLhLxgTZCVEFOTsR14mlOXNLFWz6eDFzpON5hY8jST1pqZqVDQ+aMDQlSTf3BwoSAQ1Kawe1hpLDORsiXYE2uUGO4+Veb0DyOEWx6GwL675THVTsUij34GvpJJ7cHb6OIeVOq2wP4x4p0512oKwFuNGazhTYRICtznIdSJDDske+wQKTzd7Z4zSaBrTiV//XIsUYQ5CJR51+LvZhJyEhigTuamX8fNbsCh4HNRCZ4ccGBweAQjblEjZMIh1nt70CkAO+NK34DyKdSwafND8saJ0/J/0KdKCXfjOSX+6uyRZdJtOv+iDfw+DEVi9FnAPyc+7RKAv4yZkXnVD37B1S8LFHo0cSL/97LyG8OXyldsHpjUPFb2nlJA2iNtEun863X1sqM38qtgFDcy2ORO2ZuyVhh4mOAyaZ0jqdVASpHaEBT4s19SaNfgmqSvFW0L1h4n+6tjY+fncGAToqDU+sJ+iPDG+u691faQYFnhg71d9m8t1sBjE6AiOgrgOk
 EW8DlmGV
 eMoJ9kXRgCv6pcs7mJSZeBkV1jm7F0KcEVM0jAUEgDaWh2HKphRQLpUEfgrQ5Lb/yAqVQZ1/Dx5MtGu436QSZdS04UwWOa8Sm5/uutng9YxeLEE7xg1RG36c+1nkRwMmHhTFTRHRBUnBcrGoeIubVkGk9tnlSSKLxI30ACRNcHMuPNtVjpZSCYGclBV5zT5BOLflnNUaEGiG4EEOF7nIXDc/P90NuYHfhDtYB0wVBZzbmA4QPakQET4UV6E5LvPhvWwJNDa1Xo9Z1aVmsjaNuNCE+JVmMRcv79BClhljwWupbbKOysTOFx2vmFb/UG5Av8/xyoJ1/R6H/a+35ThgMOFZlq1R6tfCMEyznJ9Ow7OQzkjH664wS/x3zQuA112hpQS/ipD5+iGhGLttJKu2dDknlGUvp2tZ+pdmU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 10:27, Jianlin Shi wrote:
> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
> 
> Fix three issues:
> 
> 1. Propagate errors from proc_dointvec_minmax() instead of always
>    returning success.  For example, writing non-integer garbage to the
>    sysctl now returns an error instead of silently succeeding with
>    unchanged values.
> 
> 2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
>    actually written, matching the write-only refresh pattern of
>    min_free_kbytes and watermark_scale_factor handlers.
> 
> 3. On write, parse into a temporary ratio[] array and only copy into
>    sysctl_lowmem_reserve_ratio[] and refresh derived state after the
>    full vector is validated.  This avoids leaving the ratio array
>    partially updated while skipping setup when proc_dointvec_minmax()
>    returns an error on a later element (suggested by Andrew Morton).
> 
> Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
> SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
> the minimum on write; negative values now return -EINVAL instead of
> being silently coerced to 0 (suggested by Vlastimil Babka).
> 
> Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
> 
> Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



