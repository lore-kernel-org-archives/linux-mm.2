Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08867CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA5E6B0088; Fri, 29 May 2026 14:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282A06B008A; Fri, 29 May 2026 14:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B706B0092; Fri, 29 May 2026 14:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 097C36B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:37:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAEDCA026A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:37:52 +0000 (UTC)
X-FDA: 84821316384.25.99618C1
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9CD7CC000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:37:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WNtGt/KW";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780079870; a=rsa-sha256;
	cv=pass;
	b=nzMQ963J8hkNNsZMRJceYb77Q13PrNIEIc1eyNgbE9X5XFA0avPxhatoWEh+LcSGbxPvJS
	TzYxvZuv5dPM9wRxRgliytvQT0Jp0ADsOaEAII3ta5QuNbymcXopnFOUwH08CObJTsKuG0
	347KE7iDakIlIRnrXmSR73lEX53+Xgk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WNtGt/KW";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyyGXznH756Ari3cnm0vtA8k1/gvoDt7hkckKPbPwiA=;
	b=kc6F2KccbKyu06dceF91/ouFB7SEqcWM1F47T2BYLsFQE5lFRJkw+csNQe8d8lhEj6p/PO
	YHwpZpnIpQRhAAtJJsDPSOtEbh7AXtBPzveMqZoBGJz6IGE5HJh/mtt4mZxwak//EzjjS7
	j5Eq6XU5tjDr4ayO1220CdqZBhtS/D0=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef5146b56so475270f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:37:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780079869; cv=none;
        d=google.com; s=arc-20240605;
        b=E3Ck7UXCKADoG6MoWrl8ivNigvBeqHZLBFS2J8sN21ZIVCcE24705QK8OaWDw2UMRq
         HoDelJhgj+cQNmCW3qTzC5ONRpGdomtrFqP06qIy+STnr4jQUadKoC+OnnifSbypI2d5
         RzyiqVH46hL1M0pVk4996WZDvL3WVfo4o//zhL6wsVMPmJ56pOFP9h+U5M7RpDtpSU1c
         m479FBAX5g1gb2mLwjtoSFoDdjxn9foHk3hCsbpo0gmysJlrwk4ceMT3IhW9lV4CPq+0
         1BaAsc6B4rgEgSzAAmuEYpmslnF7L3HvfRdMzM4qJ+fk+CH3Vlx6/OBtJHp44eilkH9E
         c/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OyyGXznH756Ari3cnm0vtA8k1/gvoDt7hkckKPbPwiA=;
        fh=+SgpRUWivUKCtZoVzXn8hQ1jlkxrNUiONV1CZkJ1yRI=;
        b=OORKj8SH1Dblhf3J7Br4Xx/2Y5nwlJuV51Uue+Vz5g7DvgSRp24hBWq9oTftpPRbwp
         PG0KNSR8S+jfjJu3FbRbmgACLScTpBsAOfNgf00LI+TpBUsAXEkGjASZmIRpguleQ64x
         e3uLppqBHD20YB+s05umUZstFrXYCW+ifO91Io7wsCfSEiedr8H8BO2I2bFgJckdd905
         V+OV8nikGf4HB80V318XI2n/ZYqVPqUdqJR1oe6gGRhejMaREjGkI2u1FJM8+m1lFHXe
         42rOq0OFKcEzUiNLR6xhSW51T7LChE/XFvSMuDY719Ufa5uFGhszjoBorRgZgcHRsd4b
         LaTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780079869; x=1780684669; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyyGXznH756Ari3cnm0vtA8k1/gvoDt7hkckKPbPwiA=;
        b=WNtGt/KWG3/w+WCCXEtEeHQGIO/NZKLH94U0dM6DSUxj43WYjeb7k0kFQqzZCYCFMY
         Hq0mjuxF+ipcIY++JRvz7CDL7p30Kcr4Tn+xqBho3rEYNUuK+4UlikTdZS2bKzkhd4Nz
         +z//dqfGvqScWSNEr6gO9CB9keNcwbtKctOHjyGDSb5Sw9aKgTBCoTzuYHny7+aA1R0B
         ytrJHbl1V2kXbkuu8FR3rJBPPq1WMajc+4X2a4bH6dzccEdqi8VNngHnYgvW0CCyhCE1
         YPjp93TAuhVK4P+C5JE9xqNDnVih95mwmsIP0Z2O3Fv8hCj+fI9NZ7bGY8Qi/2PHkMKZ
         txbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079869; x=1780684669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OyyGXznH756Ari3cnm0vtA8k1/gvoDt7hkckKPbPwiA=;
        b=qXVeCkM6Qq+ssqB8RnZA6zhBznwGk9BBqTfqZKgAqUNShEZ+5O18ijlMiVZNgBon4h
         QH3gZ/hQd40W+FtXPCsDLVbISLjm0ZzqosBAXdB8vuNiWgj5Y+aMVNPZrzu5iHaM0dis
         FtJn1AocTJPk5CVSfDQjbuhkofU6XIfqhI1cRwTyVQnWxT1o9wNjTVtnMpnhqJ+jt6kc
         cDwNpIOfraRSxmXTEXifbch6clJMcn9T7q8R9wEUjnHvlNOfboQ9KRCQweaVMJERmV7/
         rV1TfJD9GZAooTpyehvw7scxBq5xdMbpkNpIb9tv145DJ5rCAJPvTI9vKPTWYlFWR1xv
         CL+g==
X-Forwarded-Encrypted: i=1; AFNElJ/QlHzu02DFY83YdmBf+b0hpNHpufeLNVQoAEu85jfbzlOvxlwMH+hTeMKYhm9iKz2IvLd131+/mg==@kvack.org
X-Gm-Message-State: AOJu0YyvKGIx5mq8/7J7w9F9OCC3cDPhJIyIFkft6eVeeafxDz/joK8J
	q6rh0U+e6gnSc1VsBN0L4uvF6UOT7ju6PeiMWYj1lusL7O2e1qgGcVsIQ3WLIP9XJX67Z16mthq
	PPPEghR9It7czz/bUeZ+b8QA9Oo5jQFc=
X-Gm-Gg: Acq92OFQfkq9rz2V2znndQQ9yCNL96NfFAt13b45HtTdPLqhqnPPO3vYg7Nc7X8NQ8d
	6JoFDWdm0ldXxtw/7cgtldNfmiE8yZD0klPQaI1toMyB22AUu8t/3WD5wtWb4O79xpoNYN4D8Qq
	l0B9QJXYezpFUCf3o5Td7HVEyf9Ak+nvufk2wLz/0gCV9qaGVhwB/mR6B9g1Zahy/VieWM7zVBA
	5K/BVmWOg2V9IuHVcinazu0OeU9k0XL2JGpgNSh20fJBEYAzfS2YTlcg0CY99gorXTXGyp2X1LI
	E2C8aAi33HrmNxqyx6hPuXSY8T3mo8mfFm21Sf3CBhwnJ8MiTA==
X-Received: by 2002:a05:6000:2213:b0:45e:f3b2:1228 with SMTP id
 ffacd0b85a97d-45ef3b21526mr4824550f8f.3.1780079869239; Fri, 29 May 2026
 11:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_0F6F682C60B99E9E0F1553E6BF3D86468409@qq.com>
In-Reply-To: <tencent_0F6F682C60B99E9E0F1553E6BF3D86468409@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 11:37:37 -0700
X-Gm-Features: AVHnY4LiJVKg25l_5m8B9ErXgvZXvx5mC7FyBxv00LQERNLD-kc9M0aLPYUH4f8
Message-ID: <CAKEwX=NDfJud3FM4Y+Ek3RtTtwi2aXWeDCujNxh2ReUEq-m4oA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 9/9] docs: mm: update THP swapin counter descriptions
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>, 
	Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CD7CC000A
X-Stat-Signature: 6q1ow9o1qpns91tt839azqfduagmnq1a
X-HE-Tag: 1780079870-24867
X-HE-Meta: U2FsdGVkX18EbWKCrI0Gzm+8GqTUgV/Fve6rxuZ5UDab+JeMoo71TPQ4estIybM/Bq8O/77KmjvPIbwDtJAUiEnuceimLsltVgabmmsV8dSFJvNMd7seBx1cQzIkzAFU5GOirIsFiXnTXzP3dfcGOuiVJBbLEtK3ana4pXuYqJ0m1TdnXOKkJ2jQgdWg4EMmUlnP7qatT1LMQJrh6yWrKjkGbVIVr6SOB2nHt5RyDmMHeEWXiRcm5ofxjOYEtoKPa91LIe5J2Tu3d1GDpGWHt10LDaZoh2MZB1IWILDx3KFtUL9URQCs9a2Nt2YbAuZgY+hTOIqC3S9CdU5rRgarg06PEAsgaKvMY3z5IGRsi8j83KG1fsGXsgWTI+Rl0mm1AQiQUaoKvUFpCvejtLljDMZhMJIzErRtMBAX7PyfMGd1CIitIPdmiKmliqAGh+IGx6qP467QbJAHnD/UsYHLdxUViTBXa6t6oKZauEda+sGoLQEBzndax71hcOndwkKnkmRCvMCtN6FzgV73JZIJYyuVEfHw5smMZd2DNC05xQ9BMH5E7grneNF0Oj9V1Pk6iShUGvPGZlCqje/lwc6+mGH7X514rThlJjQ4IfI302cIE/eE+xBkIIYoEG7BtKoUExrpZqYebVFrWXbd/ilB+uoHgoh9FA1JcgR5CPNMy9Qn7wlS3/fzsB7wcGHNq0knQD6ZIiWqrI8NfAdjk0nyQPO51zpbaSwvjtgxXReOl9cLdBXOb6Xt6j9UCyxMvCDaGTn6mUqNGL1oizvs6ih5b6jVNkEUl1BfRa8mp3D8bfh+sTuXYMKBA7iofCCRVq3ptMHAutwTSSV+X6ATNO3LPjCPIS2tqgW3xyjkqzJgkiwJEDSN2n1mtkm32jJOf/tGgue9qRhzESu2NVM3fdq88Ihouu8szJ2yWXMB2vueDb4PIQ7qQwkEj/m89hSybbD3jx/fgqvGatpeB6CexYC
 GYnlkAZu
 xjMxqdqULBEcnt7MIYOIFtqjn+mNtkRP46Jsy27QA2xNJP+lHkj+UVT6qzDvZT48yqG/RL5AZ5vAKpg0mKO8kcjnXzn/GZ2mMpHINnF2oN9c363R/h2LbIH8+NUb1uTsR32NwUq7HiBU4jzkA1pXr2YJ0Z6gD/Xi3AkhTzr9ojbcqrMr0nNFLIrPMkDZjk6yOZvOG74rTtQbQbGQd5DVLfAC9xl1mfelAuGkLzwDA+SD3XAoC+Ox6OfKpOI8r2LdhHsXcDg/1fOoWgX/G/c6drq5gFjcdJ1NkLScS7XiSj82vBYvjuI18P5G1BAr+XvTcVw2uEfkd+dWbmVKpvSzYSGWrTAiIyj2wbtNF6Pm3EazxNSMuc24YHx4rQyBJyNsP944aheEAawX2YlMhB++Z1faZEm7jXIqp5StFD34HNUnxP9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> The THP swapin counter descriptions still describe large swapin as
> coming only from non-zswap swap devices. Update them now that
> zswap-backed large folio swapin can also increment swpin.
>
> Also describe policy and backend rejection as swpin_fallback cases,
> since speculative zswap large swapin can intentionally fall back before
> doing large IO.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/a=
dmin-guide/mm/transhuge.rst
> index 23f8d13c2629..59b7a0d09243 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -667,13 +667,14 @@ zswpout
>         piece without splitting.
>
>  swpin
> -       is incremented every time a huge page is swapped in from a non-zs=
wap
> -       swap device in one piece.
> +       is incremented every time a huge page is swapped in from swap or
> +       zswap in one piece.
>
>  swpin_fallback
> -       is incremented if swapin fails to allocate or charge a huge page
> -       and instead falls back to using huge pages with lower orders or
> -       small pages.
> +       is incremented if swapin cannot use a huge page and instead falls
> +       back to using huge pages with lower orders or small pages. This c=
an
> +       happen because allocation or charging fails, or because policy or
> +       backend state rejects a speculative large swapin.

I think we should add separate zswpin and zswpin fallback counter for
THP rather than overloading swpin. We already do that for zswpout vs
swpout.

