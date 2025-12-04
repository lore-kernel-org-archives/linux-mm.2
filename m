Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E87CD21680
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 21:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888476B00A4; Thu,  4 Dec 2025 16:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838546B00D0; Thu,  4 Dec 2025 16:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727C26B00D5; Thu,  4 Dec 2025 16:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9F06B00A4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:07:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 087D912DE5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:07:09 +0000 (UTC)
X-FDA: 84183023778.27.5FC3E18
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EBF1C0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 21:07:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R9XufZk+;
	spf=pass (imf28.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764882427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObKFiKGAyLeMY7FeWXEgr99pvhYgBonkdMqLPE6SxiE=;
	b=sXF0vcRfQ6IWzsECqhrNT6gTKFgm33SRvPRWsjOpaegToikrjSJeJnmGrNnigEvNUcSQuL
	824rBOBVzKwmTHy29f+32/tWyM1WpzUGyzgiD9VJxRblpS59sBAqgZ77icuKMB1v+PiOHu
	W8S4dqXnBAfCmsaIAS2aIV6HxRsxw38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764882427; a=rsa-sha256;
	cv=none;
	b=RsQeMfHkJhc8QfPhyHUKxp9wSV0NSTwEvem5vxQQqaBTUydespmFSZT4xzE9Ia6MvVQiNp
	qBDpbyyQzE7rW+v+0ncwBPAcLTxLnjoBrS6I6NIpCRyghSl1XoPa3li72xOEOv1hSLrMeO
	/ng5Kr2KxKUwABontcenKcNZmICqP7I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R9XufZk+;
	spf=pass (imf28.hostedemail.com: domain of andrewjballance@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=andrewjballance@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c71cca8fc2so1088396a34.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 13:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764882426; x=1765487226; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ObKFiKGAyLeMY7FeWXEgr99pvhYgBonkdMqLPE6SxiE=;
        b=R9XufZk+3Mk0crB11IHYEy5ZIEZ53zl7NdR6JNqijlxG6/k/jqohebNinTmSgm5K4d
         bgQKpf3ea7KJ5GRwoRqyOm71qzVs3k4gGg9Ja/1qQIdQZSb4bJY3rGCERLNJ/X9AgiS6
         C1lbhH7EWhabX76H7uP/smu+kmKjqTqyUM9P9DM6MXHLAxfb4XcHKcqzHsQvO5KKZpgO
         +5kzDIs328D17OBME0OxqhmH3fSCdPZ69I4FFWLKsLwt8F6VfHkPF6QJ+ERheoqUyheZ
         ued5xSyZJ/gxJuAVtwDlKO2lyky//JAU6lZ9vBzQnqeV1rlokRp/U0oQ4dSRbSh3NuQu
         Z5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764882426; x=1765487226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ObKFiKGAyLeMY7FeWXEgr99pvhYgBonkdMqLPE6SxiE=;
        b=rDJ47nxHlEJwoVN8xHeSkoKwZVeGOSqJ8KsZJlJ5N6jgA8gcOH9PY9eWG1+llgXJ3R
         +MTgkc5TBWGDx7Ih8e8gmboDseth76n/6wyrkqXicR3teJQx3kRYvL9PvBOx4bjMFgDO
         JEPiDKCCxycNKG51rcQxE7eZ/CbT7wKWXpbujIiQDn0eOKdaytmd5Hcotovz2ew2gDGm
         iJH8HhkylhD59CE1vagz3MTN8upvnUuGgA1LfhMXe3bqSVN4RR/h5xfWpiveyksChBWD
         xVTDwTGQs173q1elbDAff3nkBb4Aj7t/X6m2cf/QXnrJysE7CVGSlIORP8PSQOgAQ800
         pk8g==
X-Forwarded-Encrypted: i=1; AJvYcCVU71wBkg05cnm2wFPVtK9Lgz84bvpBMfUzpSAXE91KHyBrNiWLirOVIC7nKgeILJMdRyyMwO7dUQ==@kvack.org
X-Gm-Message-State: AOJu0YxaEk5HXqSydrHaALBL//TmPNnmi4GOs1kPnGRe51vbZx3uue0j
	tz2s4vG21r9t8JfBtPa5DIubrPhCQ5651x+bUT+2UuBCUWQHcgYKS776
X-Gm-Gg: ASbGncv9Hzo3qMkd90++YEeImvTnD8lvnQsXeVTj9sikqI+5dHvUw4Zp+pihcHByWW5
	4qAjk+VM1x89ZPvywy+8U4b9xfYCpc5OEkXLnZkSZ/NeZkHS+7VU1lQUH6O2DyKCugyN/ECAcve
	OySbjBkWekPKZakkHAK/RBw+YPOaRSy0Sejic2Rjgb2zBe6yeKcohVYp4yZPeL5izaeE8YqWnpC
	g97B6I9Ildg2lCykVgt/nlTKovcfHI+ch4hwug/Q+YfcoUdSQDaD2gsaYU+2J2KLK2awgU1v8MP
	dso5EL12aM8iULO2KPJssPvUyJlccPLhjEvYpoDZ/CVXxPRTQSxcUKETPczBAAt/LuPrEmMO3qs
	ZyIy0BqDB3u6W8w7IH7/99DnUDyVkdrU7a2iupm6zbkuGum69tpNSOjm2kVL/U680jxS96BKRoj
	MZ6PavND8bFskXNAXMC5EfCGu/OhtyzbO6sj6E9Tc1oYcgaEtFSUk5mee0JizOY8hd
X-Google-Smtp-Source: AGHT+IFTX3Kk74h8stCW4HxZx6IIYHLV1Qpqejw7b6IEFFd7sdO8FN8wywBMKHB8xrUETeni0+4gtA==
X-Received: by 2002:a05:6830:6ecb:b0:7c7:2cdb:ff4b with SMTP id 46e09a7af769-7c94db62470mr5185115a34.20.1764882425955;
        Thu, 04 Dec 2025 13:07:05 -0800 (PST)
Received: from [192.168.86.36] (c-73-166-115-174.hsd1.tx.comcast.net. [73.166.115.174])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95ac8418esm2173751a34.16.2025.12.04.13.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 13:07:05 -0800 (PST)
Message-ID: <be85b0fb-4bf0-4cb7-bba0-702c1682778c@gmail.com>
Date: Thu, 4 Dec 2025 15:07:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/46] rust: maple_tree: add __rust_helper to helpers
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
 <20251202-define-rust-helper-v1-23-a2e13cbc17a6@google.com>
Content-Language: en-US
From: Andrew Ballance <andrewjballance@gmail.com>
In-Reply-To: <20251202-define-rust-helper-v1-23-a2e13cbc17a6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EBF1C0005
X-Stat-Signature: qx3estx7mks6if7prxuq6pxm5ium48ae
X-HE-Tag: 1764882426-525801
X-HE-Meta: U2FsdGVkX1+FZmsmR87fKwfFFlCveg3oZeMNYvcgTylv9X/UeWD4f3WFYDmB0i4HcD0KvWhxFc/xtfFDcH8cscoBW4rk1z0hfDzjmrZN/7Cu27MPavwZqVWmYEUom94OgU6n+tQVqIozx+f11fs/c6FLCYJOlpclYwwxrxhmOSjErnaX1ab9mVkg0tSHo4a1MHKHRDdkbLRIYr2s6TK59B0j5ro+rp8Ud0KcooPGp3wkpwvfyUmo5q3HoWp8gPeitQt5ATsFnuIAj/frgJaM/rRBpPgxsMHWcNzirYvHLqt2uoSHD9YgC7gTJPW9x8NPBmSFddkxBZMCCHepxfaZ6Fycr0DJ5xvcGoMW1XDws0JeR+hnC8NnqRDNXQyU/Mm0wr9anNzJIOcdGCe18DEHrgcOezXZeGcJpy/AjH1K2QbalURCOsGormoGOyFlagvY8ECoK+gY+YRE0ibUQ/s736CbjP1NfHg6ciXNjyQV/5GbXFNl0zYQ8M9MhyWlOtG3wcjZ/XjPEohRTwYa/eo6qVU/O8udseScYDqO+pNNyrzQ32uKrgROrQ1deU7irP+6V+bp2raCI9WeGvvrcWPsEYi44lk+uVuVAJYYUxUgBmZ6cOa6mM/jIFPJMLIjUsRtjOiFJ3pBBT48F7Hn3OcpdRmT1PqnIAzpPUcJrlM6MVX5QRowluzB90A/qo4QarD3TTGZbqVuW9sl+EaMIVnUtmsm3r5lDzUup0RdzPJadloaj4zjCpjK/yMXwf1ASiccQ4+2DA60qUeD9UL+at6Zhd4JhaFOt/Va3w90Ry2jipPku1W1D1ymDF4KTf/hfeeurNq33OS+HmsUg0aoPdPiYd4769QDW5cK200PdhLQhLSbgatKDKnI1Li1pIZcaDO/oYXAhzqQoQ8vioMe6ZoqDDUKoOiEBE35M/L87kaULyT+SKDS5MxYzPn8ioIRuP29PgdnRajAvtsHaXMUBRA
 7PeqfmcZ
 DFYKkCW/ymZ5+xYfN0mIdzH3UBbvZx20tGAJgqHTHRTeONdFRTeODPqQm+H3GsND+xXVLTI5rpKuCcB6EfRlaugZwm7fIOk18aRBMXVor0HtPjKdDhYYCkoo2WpdWP4IoYe71elYG4QOzFleafvW07XZOD8qNo/u9QTrh3tGIfQoWM54JA1Rl5XLQOZhal76jbaspcjaSP08O/usXVVI30DJGXu6oSzrMS4QYVOANBKymTR2j3zMnRnNDixPlwLqJGg9YsSZmIUIxubU5G5dsKmbMneyNp+ClicCvQGRWjLy8vi2UjZeJWb6pwMe69oCzeQbRzoZlwjXj6kcrckPkJJaLTC0fF+FQ2/9dcRUSOj5vp9srNF4lnMrtAh23THPzZqT9+fMt2D/4qZi8Ogwlprvtjm2kscGw3GqTFNWm0Lf2fbU0c4ehNJWVOJ9TnF4JCEseyB0T691g200iJariK1Xp0yI1JGvz+Bi6q+u8KM03TlXL4/I82ERJHzPiUn7g5FgSvQ9vHoHPK7PsS2kCggdH1wahMyUzTkvujCx5faqOd4ZgpZRv7+hc+vsWcf8b5eYRGTFoQDrs9+svttLVzNwg3AVqK4rp29HJVX3COiRqZmUlTsHe3sLArLscL3DTwsBgiWhRUWCnSA9IUOmrbjRNRk9SKyDpWKNMvK627+YOsQQCu9pXW7nZ5jk0RxvBB1X7CSwzq4DiJVquw00tIxxF4dvlmbLopjwE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/2/25 1:37 PM, Alice Ryhl wrote:
> This is needed to inline these helpers into Rust code.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Andrew Ballance <andrewjballance@gmail.com>
> Cc: maple-tree@lists.infradead.org
> Cc: linux-mm@kvack.org
> ---
>   rust/helpers/maple_tree.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/helpers/maple_tree.c b/rust/helpers/maple_tree.c
> index 1dd9ac84a13feed53c0ed5eec6805517081d0673..5586486a76e0de60969af1510b4b0428392920e6 100644
> --- a/rust/helpers/maple_tree.c
> +++ b/rust/helpers/maple_tree.c
> @@ -2,7 +2,8 @@
>   
>   #include <linux/maple_tree.h>
>   
> -void rust_helper_mt_init_flags(struct maple_tree *mt, unsigned int flags)
> +__rust_helper void rust_helper_mt_init_flags(struct maple_tree *mt,
> +					     unsigned int flags)
>   {
>   	mt_init_flags(mt, flags);
>   }
> 

Acked-by: Andrew Ballance <andrewjballance@gmail.com>


