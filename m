Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B170D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 05:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A1C6B0088; Sat, 10 Jan 2026 00:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647E16B0089; Sat, 10 Jan 2026 00:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BC86B008A; Sat, 10 Jan 2026 00:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4186B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:34:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82641B5A69
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:34:03 +0000 (UTC)
X-FDA: 84314937966.27.F2BB494
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5AC4B20005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:34:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=RB490bEf;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768023241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wyW1DTuW/y7tVtllh5RzaabVaZZ0QjTpvnBZEV9Z4w=;
	b=egaXF1dmIbD2C/y0nI0en6c4ZH7MfiiBPIV3VxPfvSEPYqxjzp6zFem2z+8FFADorewrp5
	fZUMNsM31V2mJKdfp8X0TYemx0ubvwP888+YtgqS/0VtgCO+qAuvxqmQ3tFZs9d3V8XST7
	D0XHQka1HcdxWDfTlcz2hrNw0z5P1JY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768023241; a=rsa-sha256;
	cv=none;
	b=KC3P9V1+S0wmRwvEiHO3enTXnlgtt4+tgLRRkDo3QgLO0wNonLoH8ql0lIsl+p6JoJVCO2
	Dd0xceLr/QCIyRI3PF2AK8d//+DDLQT7WdHcbUfKRIzFFHrgafC7tdLK7pNebnKF6A2T/E
	iZhvpKgSO2UiJZ5K1CJgjCOOpxiOroI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=RB490bEf;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8052725de4so690176766b.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 21:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1768023239; x=1768628039; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4wyW1DTuW/y7tVtllh5RzaabVaZZ0QjTpvnBZEV9Z4w=;
        b=RB490bEf9zEWvEOiINJIUTNkhop32iPbmSsPUQJWrneiwe9qtISoyzMAQWGKdDB5tA
         VPiAHcHzVVCalmnLj2Jy7l/ruAfscukK2UsQeFE8Vemi2pWoX+K6yyoB54VID0H3ReBv
         VZE796WGmCKWR+FSkscsyHcxcT4O4pwpkwiy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768023239; x=1768628039;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wyW1DTuW/y7tVtllh5RzaabVaZZ0QjTpvnBZEV9Z4w=;
        b=mxk7GZjNpUAIGcv3e8wcvSS8JUO6JFGhhxz1mGGUi1yp6GGjt3b0zeD0Ur5kM48D9x
         SpA4e9ylJtIMewKhUY1rwT73VBDS83G89lBr7w0i307bynll1+UnU/r3kfPeP0kr/qD0
         RCr3/NE8aWSKYKZDy01HkPszfxfWlPg9IK9b6ki865ZhwiNrlkipqtmNwFqo5HVyl1bN
         8CIzdfRbMdwt992wm/U3xj8ST5ETq1aIAVzGg74OflBLbZjW/JAWOHex6fQDIHrT+AQe
         HQ0nIEhHSQKsaiP0Aej/DulDFvBKvW/ybKQM3VgQwSSC2sZYaDjZcnYupX8YVpssKJlx
         Sokw==
X-Gm-Message-State: AOJu0YwBywL3/UEoY8+g4F//Wzg2+QJssUN4IKZL/d3aJ93sD6C0mFpJ
	LXo1eNn/xbL9dzfduGCGYfRQu0MB/B1wMaBddMceX9p57BHAmd8DC8cVy+Tsibi0y2hYy7Rr869
	gbdHOJAY=
X-Gm-Gg: AY/fxX4S205MW2m+9gi+WGGRkKg8hAU0pP6lQZKDxj0rs/gsdPCLqJirgAz+2qoMNeu
	pFa36S9sHg50/QW0y23jmunOYDTXPwU+AucQMWNbgSqjOif9qcyrR0valNwbgumm/wabKattBC6
	DdTshHAUqfBc2efpVzUzr7CujfpWgd81mwQc4rG/Wl1vJ5XtxmYxw5RrsLHsi1jyk2gg0T1XaYS
	xyofjZX70VvGkCfnWqa7nmuAD7Sn0B1nSxF/A1oNdnu2A+wW3k7zASEWByLYtclqAnKYUDZP0eM
	Iql/BK9twCN7ncWZ//IJpUuqC9JfNWUsJgwYAlRWZO4qvQS29FLrJHG2UrzWNWeUVzZFxGM5UmB
	t4edhZ65iOlzwPgwpUBbA0Oda862DzB73fbUY5ekmgaecgL+tNnm3qMX2Am75zTYQweGLGyjkYm
	WjrQKHi+WIG8ShEnoldbf4yM2E10/vWqi+xN4KSP9FX9w3BagTBlFsNqKHBJeu
X-Google-Smtp-Source: AGHT+IGiCvHnHzJja/+2t7MMAv438Xl4aAj3Zsb6ckiim4rWrUw5BvlKcO4RPLNrslm87o0NcIT+7A==
X-Received: by 2002:a17:907:72d2:b0:b6d:4df9:68bc with SMTP id a640c23a62f3a-b8444c59fb8mr1095766966b.1.1768023239261;
        Fri, 09 Jan 2026 21:33:59 -0800 (PST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2338cbsm1302405766b.14.2026.01.09.21.33.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 21:33:58 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7a72874af1so887512466b.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 21:33:58 -0800 (PST)
X-Received: by 2002:a17:907:3e20:b0:b7a:1bde:1224 with SMTP id
 a640c23a62f3a-b84451adc45mr1025593866b.65.1768023237683; Fri, 09 Jan 2026
 21:33:57 -0800 (PST)
MIME-Version: 1.0
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Jan 2026 19:33:41 -1000
X-Gmail-Original-Message-ID: <CAHk-=wiibHkNcsvsVpQLCMNJOh-dxEXNqXUxfQ63CTqX5w04Pg@mail.gmail.com>
X-Gm-Features: AZwV_Qj8IjwLAZBCGylKcDX863bYH6zw4Q89VsNZ53a8fR2SwhwzXKAkrSSBlRw
Message-ID: <CAHk-=wiibHkNcsvsVpQLCMNJOh-dxEXNqXUxfQ63CTqX5w04Pg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage duration
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AC4B20005
X-Rspam-User: 
X-Stat-Signature: x8razh8u9obwdud7frd5qygi9ftz3e5x
X-HE-Tag: 1768023241-383787
X-HE-Meta: U2FsdGVkX1/zYk7vkr6NPG+0NvBeU01HhurLx4JSoguTjCpERpV3ARKuJGDKWfgbc1pt5uyNHQsX9HoDzDH38NxI2QDiGn1mfw/6uruEnhWOkvph9lOWfzbJqX06yWlKAQhOl9HbEb3+/M1xVCYUHZDOulcH2JsO2UDb9gzPQSHmtzy8LVXbWl8fY/NejJV4NMXzJDk1avvbXn57/Eh3M7DAsCi/N42hTaqaWiGXamLBxIKUfsGHjz4ojtxbcoK1W6ne3FU5HWltzp90e9Vx0Uf4/q3mGL96GbpslBcaY5pdQaKR3iGbg5LNeDPwikS7FHvOa9RMadjZZ5cDrwjkMU92msn00MVW+P+brhvf6y3SbLfHlTd1tyDN+aZExt5e1ATY4dvCP+QOEbt9kFUJaVZmNflvVJ5LavIjQF5BAN+Tpf2Xosyt4TDmV7zsP0miUSuwNlraxkTHLd52EMx+isBKhnY5DznIG4N02ZosmzQ5hCSkR4WrTpV34/P3UV/r7dcHKLrPUUiR0o4AUuQV3n9N9IyQTE215ABiLEnR6SzJ6VL961pfMLl+yClNlp4q/p8F1J9AJ7EOnaeie70FX/eMkxpkIGGkPRkf8ZpxbnNHe4lbX7X/8x4SyUUW/dVR5fA3jJCQs9rLDdc2K1OLb1/MDLqD7vBHAg9r9qoKVsITCxNrr/R658mqxtFqITNNnnHpIvbhytvLWP05lKlQ4BQsbFH8cRuVHzQBsu1OqUKMcxkO3D04EvrrZXKrMCL4jgBRbRwT/8N6cHt0KiZusbXBkkcT97ZFguUD0hVFH4kAxKGxowsyAWt9LG7/kIKrIouiiwPGtx7htDowSzsl1Sy9nttqxlkRVikNBiL0uqoUIDZGtS7L7lXh9KroBiIfqXYKUArQveSf1nZgIiVkbr3euDIQkbon1cEwKePKyb6N0dpM7gfcFvrTkwdwuoW3yVgbtjQ9Dy9/dSHjG2U
 bQA7vQZf
 VHaCx8RZYVGJscWYVZ6g5HbFY75fyvVqW5EXeOTixoSWzRth05Q1LD6QTtkd0uotjoxWX05K+YMBB5swv5JwPDM3B7W87aAp47nUPglYMaJOUD1sUEUtbcr71+2HJQkKS2DpDHn/Upo4g3d6jLQ1a48DmW0FWWTvKeaAcl1PKT6Ti9cY1ErcWGz7ax+NRsQ7hL+it2T//HEVSLfS5LwCIubc7DKTYC1EsaJjbaiG/ie7635LUpPAA+GQVM5JhSXfqxx3vurCRjl+/pEsdhQSM3vq0S6yXAAWdt/wKefA6VJyYr9YFLX8r9wid2UHWZxEuqHJEkf/na+INSKt6DcfW2oxBfL8zj2xFpQxFJ8Gq9TDbkxewVX21llZIm0Mb2lFW/kqJ/GFI/J0vuGdUVwj//FMvman5GuWhcXhWaPJoXbKMX8lPxKDrZqPEifLwtLf2veL+bWj3rgsfsBKCRhCqdRsO8/BaRB7CIU27c6pIIoEr8TCEBMoTw7OFQnJXmOyEZD+GV0VsMUCPdbG5h2nBP3/rc8AJhTrUM8E+sZhCIjh3NL8LcAYgqMczJc640KBFkzjVPiVP/siu+8FZz7EAQa9hSe6u2qWLHcg5HrUzgXLWD3mqMbaddNd7o7WtWnB1HgPUZqlRH18JnXUnCO0J7/UWRdcWb6GFgfx4Y3sbkPHqGzlWL1zRjyVyhffptlP2Uvr6ZINufLMVo5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 at 18:01, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         There's an alternative approach applicable at least to the caches
> that are never destroyed, which covers a lot of them.  No matter what,
> runtime_const for pointers is not going to be faster than plain &,
> so if we had struct kmem_cache instances with static storage duration, we
> would be at least no worse off than we are with runtime_const variants.

I like it. Much better than runtime_const for these things.

That said, I don't love the commit messages. "turn xyzzy
static-duration" reads very oddly to me, and because I saw the emails
out of order originally it just made me go "whaa?"

So can we please explain this some more obvious way. Maybe just "Make
xyz be statically allocated". Yes, I'm nitpicking, but I feel like
explaining core patches is worth the effort.

And maybe that's for the sad reason that I read more explanations than
code these days '/

                Linus

