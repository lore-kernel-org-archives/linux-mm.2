Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D775CD98CE
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419996B0005; Fri, 12 Jun 2026 20:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1436B008A; Fri, 12 Jun 2026 20:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307086B008C; Fri, 12 Jun 2026 20:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 202EE6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:23:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B290EC0D27
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:23:11 +0000 (UTC)
X-FDA: 84872989782.25.7BA8344
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id CA378100012
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:23:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VhD70hUH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781310189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQuTjrXkDdFV2QV/Z7GUPJ6mtkFqvtbAqj6efLfB6Xc=;
	b=DJRIg2VuxxVI/+AOGhEPGwXgCzsjWUWPNteQfZi/2UsCe0ZQYcRuXgNiYU8f5fasT+zdUx
	DyIP9qAKYv25xkCYPPegtlLKGNRjTASZHnNmGDrzvet0BLbQWBwpWrgOuYWA4vnuecJpaF
	4juPIqX3pNkFAe7yRzI4qCdbTZ7k5Ug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VhD70hUH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781310189;
	b=tyeNY5PBc77Kjacb9aoTX6/zTUXknXcOalvwvJRkTe2YzgGuTaWUrJklLNsPt970ujc0jd
	Y2MKykx+oLua5+SH3gDiQUv3UPuyJ/h4VET72MiyjZvQl9WylNnLlwB96FP5nEjh8HRg+C
	FVt08KPtkzjX5ktdEViDVz9HrZyJ/Xo=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1336742714fso2023c88.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310189; x=1781914989; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQuTjrXkDdFV2QV/Z7GUPJ6mtkFqvtbAqj6efLfB6Xc=;
        b=VhD70hUHQp9gBULzyIE7JzjIC9iybSyejYhG+82x/ClqNQQEDmmcWZZ47RptQsYSwz
         xEAgPii2J+l5rrkRaXvBhwmfFFmOoRJzZ1rs7VWGQFOE187kK1QEKJsKnoFGptUeFUXl
         2oQIRfhg6i4gdvOO00odzuHjPVJrzgo+cFqPj30GGUNAdNPGbswmKQRfGDi7RfGVPRdO
         D9h8/uoUD0nzsItcN2uA1SCgidwUn/0sBvGOSBoBj9xqNN+0NknGirJ3QFt1kOivKcJE
         TVQjsqffsUa6qhJjTZKwQqlqf6EgAelQ5ziW94L36X3U9LCuleCXxGRLMjD2V2iTWaB3
         Owqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310189; x=1781914989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQuTjrXkDdFV2QV/Z7GUPJ6mtkFqvtbAqj6efLfB6Xc=;
        b=okM24gP2q4NvGDvD5WOxW67fYv9JXngCrzCd+xhz85rh79MKNwC6beUzzspy8BJzxg
         /bLQy/1gWfVEQmVuBiWbgLEnloTArqLO9JySv+tEYjqfW3gI6jTA4hb+QBe6h/FMKluT
         qKb8VBECBmxVoaRcqFLUgQ0soP+AXiDdLhnldXLZ0EuOo0HZ0WyLsXouWokMcRtNamt/
         LbY7hQbzy/gl6sgmP0PGarL1cvmz0Z9lfBRnCIqlntY8zFD7hui9Sl6yTJxlN+vQ24ic
         RlWdG8BV6ku6U1gYXKX6V6DF8KhWii3CLTZvupbvLgOkAFmEnAA/g7Gkgs0x5RmtmHOq
         TF+Q==
X-Forwarded-Encrypted: i=1; AFNElJ8kSggZQPPqx1DbGcO98xipht8a99NQjSqf9/+aSzSdkSClNXG7vLJaepUyltajf5U1e0y9ayA4Fg==@kvack.org
X-Gm-Message-State: AOJu0YzzD1ZH0y/Xa1JLvTDch7JJ5Di0NDRjaHlneJHKCJGJ14YbXcWE
	iQx8ZQ2iW00xadlGpapWI9kybLMNaDSJZ5UeC9SP8vvmuFMWABnZ5h8koLevNac8YQ==
X-Gm-Gg: Acq92OGyjYTaPu8W2w+cvLoHbBsXVsGJ+UlT7Z/KR90oo2aFMjJZbNqQgRB0+qFavwZ
	Flq+BlojgzV47avh0SIrpjX03z1GROw8Yg4mPhKWQ8ZPWLE3q/B4zosE8UvRBXSwFxt1A0lqvuq
	IMr6e4l0bvKgNH0KA+xbwwBY4CqmiyhlUUQFTLrCoWzJQ+fd3rOa3MqA0p9/Vf2PoeyCjed+GU2
	SFLj+dVvHdWnw0B6FOxHTfDB1shqjnpLghs2n59TihSKnGOho83yTeKiEhH0D5CKPEZP6BgKbSZ
	T8XRhVUGsRhcUFht+GTCw1gEFmbHWui5Vr+LeviwnaJ26+JVoJlb7XK0CkrkxKmaphXDRVtF097
	mQ5tYrkx+vejltJcxb6E0JBtt04h91I7nnfno1vZ7N+u7wnq18tcCJ296v1fI2BddmRXU0RDthE
	nqvBmQ9nI1ZG9AGM+ETuCxKUs48m4sg9AbZi6U+yUI8cnNElFYtJLftFBuCzrmgxl5
X-Received: by 2002:a05:7022:98f:b0:136:fcda:bd43 with SMTP id a92af1059eb24-138f3b6d806mr40653c88.5.1781310187835;
        Fri, 12 Jun 2026 17:23:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:e362:1a25:b90f:e3ee])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e489621sm5610188eec.6.2026.06.12.17.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 17:23:07 -0700 (PDT)
Date: Fri, 12 Jun 2026 17:23:01 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Dev Jain <dev.jain@arm.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
	glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com,
	kaleshsingh@google.com, 21cnbao@gmail.com, david@kernel.org,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [RFC PATCH 2/2] kasan: hw_tags: Add boot option to elide free
 time poisoning
Message-ID: <aiyi5flNkNNm0pSR@google.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <20260612044425.763060-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612044425.763060-3-dev.jain@arm.com>
X-Rspamd-Queue-Id: CA378100012
X-Rspam-User: 
X-Stat-Signature: 7wk98xwyno3kebp9ymqs6bybhkompb97
X-Rspamd-Server: rspam09
X-HE-Tag: 1781310189-989554
X-HE-Meta: U2FsdGVkX19+nqJNaUU6ea3+KNgQrZmkxzzN0xAE6KGaYdXYuFl8qzbJSgY2Ajyf4eJBlH0raTwBYMeNZY9Bg2YwMg3igc3wXxH7Dt4fJIAM6hseOW1uqBlp5BorqvDcEZRMX7LGR4sV15sl1Fq4Q5NCJrIw+kAzSHkI9xziZGqshTWnj5dc2lgpCjx/DD6hsB7pV7ygSljliKU4edlbvEZyuvGMWbcza0ZqWe0dbmSqDpf9QtFGVO/RAPT3LRLjt+S/okOZUq8m9j9aCJ9XSdo9rDvU9Q2UGBu11kXuKTW/dsFjkD5yln2I0ZnI/dkyt+nklE090y3Ee3V0g90WV/6aysxLQCnnRQS0v8qJL5k322Y3itcDCyFwpiW/OqbdvhEDw78TsfjaCEcqBoRDVTuaTfoHOy1YoExLalqRfTpw/jKYTSyYMOzl4G6fN5kT+QKhvV6nk/YEv6Gk3Kka8Iagkd6dbr/MNhEw87XAh7v3NdntgEWoMcUqToBeZPRS0M6TMVjB0lrWWjF3R5FvWnBcWGm3HDr4/NlL6gy/Uf0dJFtaTd8kZvaYSn1PK05L5RlIpE92haG/ANuaFxWp3T4UHevHiK0/rxFtMFoWcCRlC8oZaLrP3hTa0M8t7DiRXDX9Y4gyV8MU2Jmk2JMHzLXCSzr9zK3oVO043SSXGQDVvI9hJ4td5dWV49Rmnge800M79bGvzVfBWbL7uUb38uY96NoIxH3/bmrKi0uc1xCnpTeS+OObf0Sp/jxBpBlqmHvjRSM+RRzizZDR7ANrwcGbzco05AMEUikyb1ttxhmXu/2GQfJIABO+FZPTQkntK++WnEk7ZYgCZbrDNcjDWX04DTmrBs/jpbLszlxsKU8irVXdbC1t/XmX9RCGnMPbhTF3FpkRnCpmALgAY26EJe3cybRyyi/0QAQb7uAoi5vSY8P1oU7B1PlY0NZK77RJKUSaJJB5anS+nSKtZGJ
 TVqeG8Dv
 aDaFSOyVsT6VLpA/tsGunXDgjBALmsGzE88CYmfM0lAFOAzuMOE5rQYtb/TZEF6Mvzk/snJBjKWlaqoGHBRZDRtESAQHzmxmqKdlW4apMcNu3FgtxuYHE/v0cVKV5FiYCTo7cFD4XKuCZefR6ZhBuPdX2jcBsSwowpy4EAhV3b04uDTibp2L2AfOyqYBv27Aur7hodZFoCve1ce5YaFUSSk8HF6BY5B7Ws9GxeOrHe6evDbQsXmoejwM8c4K5J3mMAuGbqVfyldvin+PV1URkFv69BJ/UjR7yEg7QCuWh3Ui2SpAkwzVSqEDQP4Qp7P0LCY5iaTKxeYQh3leCSiFv3TWMBQVWOUCaZjj/78caE5x71icOiJMWxfsPmnmxoahO/qFIfbd4vHUa7HXxyDp+SugzvwoUhiQYdO74IwHViFFpt7GQ4Kz37MYSydcjYUGdOLA2iJrnaj7jDCF6N2RNWypbaWcH9Ep5aTSC/DbOtDD7vfkpisP9kqOAww8/Dt4y9bFt46CuIn+Dje0OWZtDeGwFhetJlsIlEBZMAoAx4c0GHUCahs+YnjSod1PlSqSePoMy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 04:44:24AM +0000, Dev Jain wrote:
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index fc9169a547662..4fa8abb312faa 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
>  #ifdef CONFIG_KASAN_GENERIC
> @@ -478,6 +489,16 @@ static inline u8 kasan_random_tag(void) { return 0; }
>  
>  static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
>  {
> +	if (kasan_tag_only_on_alloc_enabled()) {
> +		if ((value != KASAN_SLAB_REDZONE) && (value != KASAN_PAGE_REDZONE)) {
> +			if (init)
> +				memset((void *)kasan_reset_tag(addr), 0, size);
> +			return;
> +		}
> +	}
> +
> +	value |= 0xF0;
> +

I wonder if it would make more sense to have this as:

if (kasan_tag_only_on_alloc_enabled() && (value == KASAN_SLAB_FREE ||
    value == KASAN_PAGE_FREE)) {
	if (init)
		memset((void *)kasan_reset_tag(addr), 0, size);
	return;
}

That seems a bit clearer to me as to what it is that you're doing, and
also makes it so that you don't have to do any bit manipulation
on the value when you're filling in the redzones.

Thanks,
Isaac

