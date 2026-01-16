Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B11ED4899D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD956B0089; Fri, 16 Jan 2026 08:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3896B008A; Fri, 16 Jan 2026 08:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6406B008C; Fri, 16 Jan 2026 08:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D86C6B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:36:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B67D1A0144
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:36:15 +0000 (UTC)
X-FDA: 84337925910.08.F856029
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B39F1C000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:36:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SYuSCDFp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768570573; a=rsa-sha256;
	cv=none;
	b=i2gx9Ar/sG47G2fDqbOKInpHjV9QPuhucHeoB0oOdaB7uhWJVeRK7VVPAPgT8TH7kPxGOb
	gFvFy4exRi36zON1cLKb4zAkfEmS7LQcGNpJZAC3NS9LWSfH3SplWPXnbO6ac9LVa4ylvk
	bSxbbC2KDLeGPag+JsFgZF0HDUxFBuY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SYuSCDFp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMOjuo+sGduAgoZx+VCdetEtL8RwS69nkBaJxVuZUv0=;
	b=CDa2rbGtZKUf6hTP6NVHHeufjf3yXTgJWnmtHcipL7HlK6QW5HhP0jm8YY4zVm0/T2dfdX
	mYFvbmbo/j72OO0SY2N4TJuLZROEveReBa+H/axDfILTZZFblKnW6hVx0/t7/EKlQBtwM6
	sJaMuMmpiRbpnsfOpfwqxqkmUIglIc8=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59b7321e7c3so167067e87.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768570572; x=1769175372; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMOjuo+sGduAgoZx+VCdetEtL8RwS69nkBaJxVuZUv0=;
        b=SYuSCDFpe/o/mmbCx27sAms6Y1wCcGbOFkVxX5ByLD5FklV2HT2U5LXq2tvbmxtNe0
         oGGez1W/itXwWnANto2WWbSGLNvNjHRorKKa28lSxUCCCYyLL89ocaoLAzdKYeKBxCUk
         K989FXsabMT9UDOUJ/nkjAx0H/FVmzwv+O1ZBnSzuDxEsYebl8qGvR13jtUgJI3qVmJv
         jIELky8N7AdaMS7bwWi65fwFVyhDuUm2qR6QYQQdsu1eJlY9G0hcM86oaHboPMKOAglY
         +gkUr/l4ls+BUA8xzoZ0UdJbP0eBgrbJj38tJ2QObN9pQe7oE1VEDePzarKartpR6tOl
         kmiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768570572; x=1769175372;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMOjuo+sGduAgoZx+VCdetEtL8RwS69nkBaJxVuZUv0=;
        b=A9+4uah5WkeZyAgaQAg5zFE6RlBU/GpJXgP8mbHKYwDbKYtZQwmJwMV//qlh/qXPFk
         BrYsX9akrLM3j8sANcPRCvW8TSreIzuZaLsNxv0WYLpOO3WJ9Ln2JyAQzhXDbffnH9W0
         vcT7eCVWhDlWA+yltk4iAshnhB0Dond+bNCl+BNmRVAxtx+uCEAdiwfc3wXlHOtKEbJj
         uqpX70u5g769vYRtjfWK6XZdKnAjtgY/4xcni4hu29K8Ef4uY+0zPeiCM2RHgW3ZlQU0
         HfWA2Z9fcFV/DM7AQZDQHjlRk29c4FUz9fzzTYjHSPtuexA43ov28ncHExEKhHhgk2YY
         2kBw==
X-Forwarded-Encrypted: i=1; AJvYcCUHqM5UBPpYmlsO2WWUSkD49o1KxVGUnL9NtTwwlZJy3K+ouDgdVfk1bjMEQV9ECR6scJlPF+jMhg==@kvack.org
X-Gm-Message-State: AOJu0YydC6uvJHpzf/WoMKlnvEa1iTlUAQ/4YR6QEGBrCp+MIHErm5rW
	ewWfNp5HuUZY/i7zuF01UmxkwFtnJBj4SF553bStUBDVwLHp6Kr0dhD4
X-Gm-Gg: AY/fxX5naAQPzcqqIQemBK1RQrj7EFwItIUw8fgg1VigH5kcWBQQB7vSj5bYNlpOKMb
	JvSxmH3tqrhp+8rn4qwfiZc5HiYCXe4JjsXVSpPwOnB3+T7xL+QsbCZVhnX2g9wUXwU4XIjiv4y
	TGaRUfUMu3fP411tmD8pvAtGWUH5UjKroebXeObcdelwvmihtsSEZdBZEuhvgx1qF5Zm9qOcot/
	EOA5Nw5jhZ6kRpMKmQNfeNURY2+vS2GQHRbpvCMENwBX8mnhXjDBmDq0QSeFa8nMI/3oSNQV/4U
	WZcp6SOMHi/z22VyT8sxQTpWUtgLkXLU37pPBVsoo4GBDpZAbShjHTYWpTVVz/4fr3ZGz+LhhgQ
	LWD6Z46S/T5slr6WXV4PHfC8JAQFIQz2qhk7tFs3u8IXWnjnYsfJAEv4p4btbwlaMU6SU4H3khK
	y4txonDAcOZiejsAVX/Q==
X-Received: by 2002:a05:6512:3515:b0:59a:10c1:8f27 with SMTP id 2adb3069b0e04-59baef10857mr597870e87.6.1768570571302;
        Fri, 16 Jan 2026 05:36:11 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf3543d2sm770392e87.43.2026.01.16.05.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 05:36:10 -0800 (PST)
Message-ID: <901fa77a-b23d-4268-81aa-fc76846ac73b@gmail.com>
Date: Fri, 16 Jan 2026 14:35:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/14] x86/kasan: Add arch specific kasan functions
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B39F1C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 1b1zyycea41mqpcn7dpiwru5a37ubhrz
X-Rspam-User: 
X-HE-Tag: 1768570573-784432
X-HE-Meta: U2FsdGVkX181RZJvRebrJ/2hc05MsIHauIgTYRcgAR5xZMSxwtSzYTgUh+w6HojuHFY/7pYEs149eWxOMFNcaqqmvQS3HwP7NbLqlcv3DoOG+QzsPXlxgPiELr/A0miNIZBrxkNqLPz7OEJg/640dmheQFvs68cfF74qajtray42xtUSp+qzbhn34xByLwgSMcoCkQsqCKIWqcU1XIlcb5CREkUGDQhIAxSTFfd0zcMjehS622XOjVXoibl2bRe1+olbp2bsADTyH+wy27Ls/HoET2OVyFq7TZX/5VHCBGWI+cMW/u/1El0vaexnWJQwGcCGce8dQJPLLn6J0pisrN4md+irwcLgJgf/hMQ3zoUvEN6oPAOkg+ZagdfCvw21vJzXtEnKq1Jx4Phwj2MGC/iT0QAI//MSnVISch0o+91zpd0y60nln8J/+4gvxuZ2LJYHW8mEelQ26QcQvdIBMjAHNanHb+vkDTYPRMOMhx6G4l89N6mvi2MD8jk/GFAxbTJGCIpc5OhOV3VCOAfz01a84uQri54UU5XI+Lh8B492POMyqJ4zSKtaAHtDt0Qi3I/7ecO79kUqJM/CvsBExh50b91hMX1wiYmKShhlS8PgnjaDILp9gFEItTqE9lEk9gip6cmkBDBGD3IpGinfQYyfR1jcrnZBTJASJBzZ4UgtR+uX/LkRj9ily4WwdGtxwNL5uBV9eTEyk23lGubBf/AhoQKVZk8oakd8IpoUVftApRMLdrXEAy1XTiQiCMlqBLhJ8XS4iW5TTddjyAWUii5UJQhfL4NjjtjHa8Ofmi2PNdfSRZZhRaNcLrlr59oXuIworpZtqRWmsmltf1eLIe4VvCESjNg9CnMn95e3EMIt5uLLjFb3SqqOMIdEfWdb4NLzqg5xVo+rLQS6TtgysztR81/2CYK/k9n5EzeKwhb4GL1zFKiGGSclDD8rXwMuvjcOoOswKoW4rIf257y
 HZKiP726
 9ae55W8kG76xD1X7oW4hx7tRegLLsV460pVEcCIIcSy+w8wx+s2thbu6aTI4Z4LjolRWvNge89oWJEpwrJ9oh3P4CyqyasiWxku9cWOT3LA5Xnxx8a1ZCBmaHYI7ukRYWP5IXAtgO/LdZPqGEu/ctvqkiv8wCRUdh7oeiGGx4gzyVDuSy6OxRq2lAxPSe7SBT3jYi4v/Y5AM8YFr0hjj/cdJzU7vYI2F9J5WaLgk7JQLqaSACJVo9irzQ8DHzBxeZNGKXbhV9UjlxVdXCn/R6AopQQVsz35MnMYnohjyap2mhynv9xoVsZUbSlQfmqmbx725V8zVznTHLAbI18MdYeyhvT4VuB0Cl3B/NBLhPhBIapnrUoaPcmTo1ErT3ke1PsN/K77fjkaUmyjCYL+edQWTBTmuZQHZcWbpAze/EhSYIXGpcfAGvHZJ+4gmMXp3lzLq/h4s1NLga/hDtEEpf4t/2GhYR/0T9hKGJFKoDIxc5CO4iQBeELCny4hDQheVLRPj8LcUK2YJY8cc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 6:27 PM, Maciej Wieczor-Retman wrote:
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> 
> KASAN's software tag-based mode needs multiple macros/functions to
> handle tag and pointer interactions - to set, retrieve and reset tags
> from the top bits of a pointer.
> 
> Mimic functions currently used by arm64 but change the tag's position to
> bits [60:57] in the pointer.
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>


