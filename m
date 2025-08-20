Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49826CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60756B00D3; Wed, 20 Aug 2025 05:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10776B00D5; Wed, 20 Aug 2025 05:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF4E6B00D6; Wed, 20 Aug 2025 05:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3026B00D3
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:18:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56B95C0450
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:18:18 +0000 (UTC)
X-FDA: 83796584676.17.1E6B0D8
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80B0B180007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:18:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fs7qQUbn;
	spf=pass (imf06.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8Q1QWRR0gJ3fgBmnbNhIKOn7vja2odMQbjJmMsdlbo=;
	b=xlA9X+Z38SlE5aXI8/Ua92HX2gwNQwsHtqu1VCF08Whj33sn49t3yjhPp60DRR7A6OdL2I
	tWUyjP6dkoT1s7XoZZx6o1cLIj02qzUcj4zIlDpcG1J6IevqXmQbi0vhJBXdob1mMzxn8n
	9nZEqVHVNMcYZ/YKZwbPcjCeCr4HF9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681496; a=rsa-sha256;
	cv=none;
	b=nf7j+84nQ8/EyrriiUsO32bI7wUxEkjkpnGV7iyDSSriDv+NVrhWVjB92+J2jmuUCR6Yc0
	chWo59qoNYmVmDEUIJshMBPj6zm5WndwLE525UqlUjNvd0Vq0afc+I9QhUHSPw9OGIILRu
	YNRaJHjGWAt0f57Ol6YE3s5SemgPFok=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fs7qQUbn;
	spf=pass (imf06.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so1275928a12.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755681495; x=1756286295; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G8Q1QWRR0gJ3fgBmnbNhIKOn7vja2odMQbjJmMsdlbo=;
        b=Fs7qQUbnQak+1jclRij8c6wg3NvZMblArVc2F33NJAYFbWe4XTppaY0dTTDv4a9fI8
         1dIr0uT3p1wbXcBgFrZMykSmIRo2Orj1OJWt+upTEjvSiEepu+EtpfgKFlWl9TU7ZmlJ
         E+rpqtqRnU/ekyCN1rWytTYfTnkTIsl+DZXnwm/32L0HCNCpDo3PuEb5G3qjVPPhLjb0
         /6fu1V1qfA580ag192HaJFlubmrbPbpfJqTFuJbNPRgKXjiE5SXfU50AiM54TOtjVGqe
         TF0rU0bqkOFg+c5uIZdEnrvyt5qSfS7KlfU6uta6g8bO73kbPLaSXSdIfIopxz93wrAp
         jL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755681495; x=1756286295;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8Q1QWRR0gJ3fgBmnbNhIKOn7vja2odMQbjJmMsdlbo=;
        b=Tp4d5MCcQQq7sutyPOlfqfOZQQMgQk8V2Uet+2xH0DXB1jkkkCbMMaqfA0fTknVfi2
         OV5DoxDXpt3iwlW4gHF7QGFus2CwEJDMMuAEdOzW/8liZquX6okIIZWlrebWXls1IMsM
         j/IUPAZSOcDJRmK5kHbiJW+pq+lpydd48Ab5mRdxt0w6Hby2VkmCn+3eCzgLdfI6FeBe
         DAPIbqSR8Aojrd0wBAgHLbJIV00f1bcVrQzpEzY1nx78J1ytgirEwxSTEAzeIYMRI5w9
         yvPx7yKS4DsrJU74cBiA5E/6aE2SCFl8wxubOYNWx8EFpWEvNDo8BSWtloSBd//DRZQD
         bOZw==
X-Gm-Message-State: AOJu0YxIA34L6R/Twf1WWG/G2DHjzq3nE9ooyULkZPIi9TuSC9dLXfrw
	ZztahQXXtWSRvl6pbWPPsPVKKrKNE7m9xQGL58UjHTy7SRju1cLzDrLxnllZKZrcYwj4HkuBa1h
	quiM4sZPtPbUdnmEmn50a2+CbO9M5Rgc=
X-Gm-Gg: ASbGnctRhCq++cPox9yCXyVKmGyXUHyNqVfAfKdILYqFBOqp7bWqrQR++fY4A7BZYdr
	gHyU2vTTds1+XL925kvR+NzHjWUFqo71XXMoms6CWjMWs1klN42826aeJoOdpA8svUADXAWarfk
	zGxZQ+ZYcHC7nf/Y/XAS4UEqvCVaojZQHcUfHkSyy7/VJ5utNgUrUDiOYtv2WxaTN//YB8/+g/D
	Oi3fAZmIw==
X-Google-Smtp-Source: AGHT+IHQJXOuU+tNL4WsvowWGbczc1m7pTzJ5CkWT4xHDAbbLHqpDDfTYp3NQJwZ4QNOggU00MpfaKGHwmR9rh7aagw=
X-Received: by 2002:a05:6402:2350:b0:615:3667:f4eb with SMTP id
 4fb4d7f45d1cf-61a9755ccd7mr2069826a12.6.1755681494536; Wed, 20 Aug 2025
 02:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-3-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-3-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 11:17:38 +0200
X-Gm-Features: Ac12FXzdqMNQq5JRtACKutMxFrrk4Q2rtIYRhFlrV2llWZ3zWUQ7A6pvqVxx7ks
Message-ID: <CAP01T767o1-KyhRLGcm8gXU5GiY8_OtifT6bNVfMuf+MT+3ZBw@mail.gmail.com>
Subject: Re: [PATCH v1 02/14] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80B0B180007
X-Stat-Signature: pa79wgpahx5tykgt3q17ouhzs59kx74z
X-HE-Tag: 1755681496-767411
X-HE-Meta: U2FsdGVkX1+FLkAjzDN7ha6Pb0ga2hKrnHIgERHQzVZupsWHUhexpUDpnqDRPq4PyEGUZlNhxbD4maQ/7wLh+hsDgr7dfx4IZ4A37mMg/dI5onA9x9Y9Yt1EnIjSVsuvgUUhJdBQm6lhcblol3k2i2QW0erIpK7UXVXTlRvKDJ6MUlLTOzfAZhbkhRmIACyVJE+gkkaTSjcT43EGrZG1SzMVssd2VvpwJwrZeKNqNT+AgahZD2gKauGsag3ogU4kYaC/n9me/Qgxf1llp/t0YC1/LB2e0JPhwh6A+JjacXbkgsSaNM2L+lF8Fj94OiTQMlfKl4XU6ZbZHJrcLQYLVlgufyJJsk23OcT4MJ9496k/cczZQpmtokoGIz72n6rF2PZl1dGn5t8RspRVt2J5CnXplGHG6zyU6h2wMny2zEz82kYHtaAL9rNoD+dpgNccOyH2qTf2hNT0Zf0c9FDa2Gl+7qOaH+xxgoJzBa55BwIm0qEs68CBBRe5105BgJzJ9aev+iCg02UjAzRL6vDugT2ZMeVDVxD6rJ4Y4bxBIUjFqUy9/t4ESjOPfXcxX464O7F8SkhdtDmn3d1MLdo+o7b5fDSagU7aXKAMe1als3p5Txy20ricXe6b7+/knaQY+kZAnGp6A893ydnly71hl1OIHFQUedexZk9S8/eBWbf/TJOl2DqefnzFTrKr9274qiR52Ss2U+mtsQ1p8yooC99DVWlDkFQjdPF/O7884MwGOXWhWwuLHP4ZKph7RizgBXQBHwvJtbg0QBN/iKMzaxxTIn8BnQUEgprem6Az/7vziWi4++D1y0VCjuWgATgd9K4El8YP7A5ZzkV7LaWbYE9bgORGnfx+L2coM5pSsIn/FA/CeSGWAbuTl/+lf49R+suwVI4PeruvIQZTxJY1fNe1/wQNDDPMHyXe/MT4WkSwS7aaW2zZ7xiHkIAGnsI2wrimMY2K5pVAlSrmASv
 FgCC3iyt
 0F9EtnbTDAYwnKh6/oRM62JAl4Zw56FOK909khpmRuoPiSHkYHUmSgoJADhJ9JBW7nHkbQh0KcC+0BjJD1U9Mydxhd3n1tbfQKi8pfmq6gAmPF5A5OPxfTTwLqeO8qQcy0HSPn0HVfm5lncDOh8kiWiXB1QYf/FUsUU4tn5j7JeyiDqajwMREAMjidAtkXZ0b/B3AyrDDNeyh4Iq084Wir59ideL//iph6euKrAE/ivRXzUTYq9jff30qNCJMHzwGHJdJS0HmDJSNpRlGYU1BNUTRu3OBqcTw3lBHmYPYmvXdJv8i0lyOPzucyLWfDVKH+riZd82fErZdEcPALi8TU4tTxIEzKcQ1mpfzmcb+IWUED7rEpf+GjBByvxF7RgUP+DFzoDgzOv8X2R9u8O2ydN571OC3TvRZqPBGU5V+aii6iZGO9uZ8segRtRb2wNEKXCvgRQ0896bT+ZS8MoWUr1ASxQETKWAYOBXkXCz26DITr+t10QHCria07TtBxO+AprsvGZqw4pTz550qH5YbdkxbSMTDk884g7Gt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Struct oom_control is used to describe the OOM context.
> It's memcg field defines the scope of OOM: it's NULL for global
> OOMs and a valid memcg pointer for memcg-scoped OOMs.
> Teach bpf verifier to recognize it as trusted or NULL pointer.
> It will provide the bpf OOM handler a trusted memcg pointer,
> which for example is required for iterating the memcg's subtree.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

