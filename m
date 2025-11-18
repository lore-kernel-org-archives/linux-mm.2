Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D1BCEE349
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18CF6B00A2; Tue, 18 Nov 2025 13:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC90E6B00A3; Tue, 18 Nov 2025 13:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90A56B00A8; Tue, 18 Nov 2025 13:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969026B00A2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:39:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 301BE867C7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:39:48 +0000 (UTC)
X-FDA: 84124591656.04.0E25873
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 405AB2000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:39:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQZ6h+Rm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763491186; a=rsa-sha256;
	cv=none;
	b=1Xz4kTE8WwJ0SC0bB/MHQX6MLKl7h3JQL8kxC2qXhhnry11byzG1yTwTCB07fSsQEF1MOp
	J2H9GXAf6vleXeINV8wUEgSGq5zSYwQLNjVyeVfu5BHJtQBHRV4ONmRBW/AE+R1NDxpRFZ
	1RC+6nD8ktrzkFYXLJ6g8Xy9sP3+T8I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQZ6h+Rm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763491186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9V6aLA+CV/5v4QAU6QWKGjd1JLxGYjp0JB58rm3Rtm4=;
	b=FdTlOGVDIPkW4dhqE1qm/JjNCh8ks3k930ds16iObxmNWTi29c7KXEDr6273zyKfSL4Aug
	IvqCaYqIfLs9uNnu5lkH3Js3u3dXilDlOtcdjOu5zAuAcVnfUF4dB8WhxGj8Fv3GHIXzvK
	dRC/f1sKpf0idPopuH6TNYyRjA/q1sk=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso10248360a12.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763491185; x=1764095985; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9V6aLA+CV/5v4QAU6QWKGjd1JLxGYjp0JB58rm3Rtm4=;
        b=WQZ6h+RmaTRGWMXhheJY2EZXDeH3cYp7x2EqnNS56SWmUZVkx06gvYs/NLvOCRdqhi
         0/kU8hOlA61RklVYOvgBWcsterhA7GjRPEI3kmJd/ZPvWbLixcsx56vba/5o8t7k2xvY
         6kjPOPumlk0uqEFyahKQBpftsCcptJoKw9m8DbB+0qn7A3Y/bV6NTk1xJ6A3X76w10aG
         Ws6f3xzfi30Uklc8kpYBvJWLimAHTr9a4t09w1k+RXYhyzzfSqALHlHF4n3/h4i8wHIq
         +ywU1xPsYELd9AIsNSp1nqOYH5D21QxP+cGTDbLbAgivIB3TeeosT7bm5ZSmrT5u1pd7
         4kDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763491185; x=1764095985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9V6aLA+CV/5v4QAU6QWKGjd1JLxGYjp0JB58rm3Rtm4=;
        b=orfDq5BvV279DNIwR0ZezyN4Rbpyz0iSVBn7hXfSzoCv4aaI4kJI9yAzqjIBCHSAQe
         zgjooDUiT2Klkkk+QaOPYRSlzvKiPJCAx0TJBq+RREWuahUdEjVzlk+kchyDLtKrmpWG
         a99GLCdhA+l0v0uTtiw6GcXoCVVJqd5wjzzBsCyJZj5VHScPTm6fOIQr3fP5AEDrsU3F
         FHmphwq8Mp0Z9lOl0CpnmRmejQrfyiIhcQbrHSECsCR4eZWXctCsrksPuKWz07Ys3O4H
         Ne1mxC5cU4dkv7Zb00kqyVdTi8egAC4PeNlhlms1BuG5MktOl0uC2H2a9pl+lOJadN6i
         +KOg==
X-Forwarded-Encrypted: i=1; AJvYcCVA6fbIHku0dMZHx5csEOeFsR1iZV+IvdfUJ3Z5XhoB/g6wCQ+BnrfUyjmIwo92UZeJj+ClohVp7A==@kvack.org
X-Gm-Message-State: AOJu0YyUYMLfFa4DGfT2fRjPs19gI2wNxJc1GfL+bD5J0a/JWqta7akc
	eNnTuLhOfXkAgx3k4IQuczU9doTzKbx6Ux57vmUCepVLP4RRFZcAMi5jYtp8jJGsulgMU+jicKz
	HONhZmFY0aHxgagkWXe90531TzLozGSVV1s+muxT28A==
X-Gm-Gg: ASbGncv5UiwASp4HyoKCdk20dG9Fa6pdp/tnhV1uJ9ZHPp7zlCXKVW6aRkCAdcEHf3P
	DXbramAbKFGrgtA0WhZV+3tLQfgm+1fZ5kd0JHpta0GabhWGeUiKO7LiP0T0+jCWveUcSsQeK1f
	59I7J6HbDwmz4mhWTUJlrxPRWTGiPi4dq5BjTYMfl+rTISm3Z3C5lZPm1Tyu/s8ho962fkIbgBb
	DcrTHTaYVqirLdffwCDhmBS6zg+wVQ67ZSGNRAEpIRpYUfkRmNhr5oY6CJartDi2w11LxM3ZadY
	Q14=
X-Google-Smtp-Source: AGHT+IFPdLU4oYkdFHTrvm3ufxvrZdc5fdQZYxhgkZuVLW1U36Xs+bmTvPNB3im9GWGpOgsCyvBrh0Ifv3TOSGRmd+g=
X-Received: by 2002:a05:6402:27c8:b0:640:ebca:e682 with SMTP id
 4fb4d7f45d1cf-64350e8a783mr15180576a12.21.1763491184719; Tue, 18 Nov 2025
 10:39:44 -0800 (PST)
MIME-Version: 1.0
References: <20251118182218.63044-1-pratyush@kernel.org>
In-Reply-To: <20251118182218.63044-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 13:39:07 -0500
X-Gm-Features: AWmQ_blXXv0EIUAeTANiMUfiQ-ZE8U7GHZIeNO-VAyI_9nKD9wCvkFnt-Ipg4hk
Message-ID: <CA+CK2bChpd-k0tpcQRdVmK0nmnOGKWExViVVwcmhryZVEZJFPA@mail.gmail.com>
Subject: Re: [PATCH] kho: free chunks using free_page() instead of kfree()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 405AB2000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 41cidmrh3dqpfpaj5ezr77cm688bf3q8
X-Rspam-User: 
X-HE-Tag: 1763491186-567687
X-HE-Meta: U2FsdGVkX19QNgmvxFHcBX4mNcGnEg8Iv29cv509Xhir9PMHtOZZaDBPOE9g+W1DhsxDTkddTj7+artyR7e1OhsUUzeih0PtXHLTKAc5yPjKwSnqLbHt0tzxgQmotMCgEk4CITVpUCdMxrA8CXQ7mYv6fSjTiWjrmPYUkSKHKPQU1ZLz94OX8eM2KJ3aPbJye/gUHWsBQ8Wbs7zsCjCGcOnDZqRffZir8UwwqPzklQnGpC18NE94vpZ01di9Y2hEGjrmTMq6012htzqYxCid6KybGMPzvFG1iwf52ajk4UI6IxX2XoIB+LWJfIRJTQEQDMwaOo8ko4Joj9/f+iE46LFW+EYbTgbKYheS2F41Hbn6q3696yKHgKJjTHBYK8FhALQpPku3+RysZ4wps6LmCQEUSVnFtBO8hcStrzRTWLynxAUrSrm9pezVdHeOUjPYyJzjnVQVJhwh3luIYWMdc4hEujqYRzinGqwZEulFH94fc+NZ7xSAvinEZn/p/5UtwaId04Rl+fVkvmSMnuDxFB1sGoANZjjhO7u3ZXLLdn14teWeB8TDd02OmA4NjXU8TsxGptvEhjADtTYG3XGQRt28KNHGHtVui65NRtxj3iJ7HrQpRG3sqBMLl+NnlOHR5yfNrsJYr5ycaur22m8m0KS61/EIz5hRU1zSFQ5qiwtm71yFrYw+SLggdQSGn2TbgOq/a2n/ZWZRlOv80CzXQkezdYkLqW1C17zVOmF5Me/rGxfL+OTIxczIM4VCmrksHzXzlawdY5cabwy5670W83Xt+yEcubZTZul10OWVDh52R7ySX2A82qaYAVXPwQX4Hujft+UOafDRCYckAXuKuz6kdUw+2CmHY2gq9G1uP3z85kfmnTxkx2NFt8l+zrHK2oqBr8XOlbjMJtFTT641P5l3YMiT/9MKvdHyry9/ILx8kHWSG6w0fRRFWXf9bNoSOdhWCKszDtjYPhwFeaR
 KzImBn+U
 UqvgWDMUztbJDMpIB/WC7dMHF6LnTdF4EpvlTsPGvokq9GsVgeFC5JWrHID0d/ihHDMGzWUZwXarDpZfrwvSdmTYSi+KgVlnzrVRzy2Q3WgYmFiUymrCTOi56miXrw/2IhZc6VcHZWITzNwW9WKpwnp4XDVjg1w0BCTDg8tz7+5WhuSJglpNTaA+YtPMtzP7a9BR/p0Tl5FWwuY02le8EgKsrzMD0HuM65DoztNJairHMlhX9cMTMb5c4PUV7MgOsCj2CJKlb4rznZKHBfLp21v60ezcHmNw6NnsgXDm54Mmlrs0MIeDa9EEwbx7WF/2gspvS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 1:22=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
> buddy allocator"), the chunks were allocated from the slab allocator
> using kzalloc(). Those were rightly freed using kfree().
>
> When the commit switched to using the buddy allocator directly, it
> missed updating kho_mem_ser_free() to use free_page() instead of
> kfree().
>
> Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy all=
ocator")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Thank you for finding and fixing this issue.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

