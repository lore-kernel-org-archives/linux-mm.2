Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E3C9CAC5B5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F408E0010; Wed, 24 Sep 2025 08:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E063E8E0001; Wed, 24 Sep 2025 08:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C838E0010; Wed, 24 Sep 2025 08:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE9948E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:29:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6215A160734
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:29:10 +0000 (UTC)
X-FDA: 83924073660.01.12BCCED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0398040011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:29:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYr4fkpm;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758716948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zg/KeJeUvNE6SDnPn43Ej3SICDgB1VedGAUJQ2XUMaw=;
	b=1fnu7WM3rszfW0hLIITePUP4acPnmF6Lx67pzbXEo0NyPQUCGLb6LXxX9xcfz5j5sjqCtP
	3IslFZb01NU4hw2oQGfAtaV4F7RElgBcIj47AHYn0FTAzJs7/A6wZUl0ku6Ntp8+ELPU8h
	y1aXRN10YmEnxuWOXoHhiWbWYwokPLM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYr4fkpm;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758716948; a=rsa-sha256;
	cv=none;
	b=LG3GxSvtT4i8TgEiWX7yxztb2qw6MjZvnzC6T+yQkN+pY+RTGCxsJAW/7o+cJYosnD2SNF
	4SBmCU5c1byC/UMdf+fh7nR8WP+WwQ9X+STsslveqzjGd94KMLgkIOAViNpeD3OvI1oLHU
	PjmVqjsZdAMk9T3tb/ahWIclpe9Owt8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758716947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Zg/KeJeUvNE6SDnPn43Ej3SICDgB1VedGAUJQ2XUMaw=;
	b=PYr4fkpm+ZY82JZEBZ9yJJrfWIxv6xfCfPvvt1VanUkXuw564qCmRq5siEnBzRFl/90+vc
	M8OoqMc/C29FQ+9PFSOKif2IaqeTdS0HtuqD973Na+lgaOFW3ke3ZYZPHQWshitXjhZWAh
	mDyPL+HCJ8K/4d8nkr3iXj1COZIO1tU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-eqU6PbX2NYSP4163aCx3xg-1; Wed, 24 Sep 2025 08:29:04 -0400
X-MC-Unique: eqU6PbX2NYSP4163aCx3xg-1
X-Mimecast-MFC-AGG-ID: eqU6PbX2NYSP4163aCx3xg_1758716943
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so2896294f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758716943; x=1759321743;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zg/KeJeUvNE6SDnPn43Ej3SICDgB1VedGAUJQ2XUMaw=;
        b=OTdS89f7AdQD6+bC0PIEGNF48ioKNi74jMmOA1C/NitF8aJNYkO3EjfOMQn8wJP5at
         diOXgPHmUDRXFPwI1NGkTXBKgLyKfJX9DVXKBM7NAVvJhY3nv/FG1/8+X8EN5YFT2g9L
         LCedYxOoWlSFGWQ6HAWunoKNLuVJnkXOvblyyykxrcrugAxoQ9n2ZN+E9E9G8BryQG9w
         Ag49Rdaftt4ZlnUXDQmVGVjbCM9PAQ+iaQx7V/heIBNrJ4fFmbLcFxyMUAkmf7RsHbc1
         hs41h2NBqjuFs8YNc6NQKYPV/+SUCNSS6b0k0Xq6oehAJL4+A/JNF4adfaZ3pu4nfJ2H
         mA3g==
X-Forwarded-Encrypted: i=1; AJvYcCXRCn2eKN40YbXBGcS4K7oOn35BXirfWOeS7MiTfXgvUujuy07awA9qrX24Gtgn1G372rlaV0oVuQ==@kvack.org
X-Gm-Message-State: AOJu0YwShVI/fzbRtWmjBCH7l9wefJOVnpy4uxRQ6r7yL+IoW6vAhecM
	PYSuOVg0MVvW7yGDMbqx0lkaMAIg6MRTs9FkyDDU28iANMV35J3o6zJ3BeFwZaaDa3gPhcvLUsM
	V1PXy60QKMJFgiUYybickZQMNM7+HtEjpeM1m355dstgB6LxDtysb
X-Gm-Gg: ASbGncuwsXvsBv4F5Et1Bp+dLNIaJAZTCx1J6p8/4CYQM3ZB9BIdYjjuBh47As/apC4
	0a6lP/o4ROnUG6Y1GcJZKeLu72N9SGhd530M9dos5Lh6mSbLWzZrX5XnYTkCO0ECOg59wJHCfy8
	xir494IgUzdgoJqoy3sxK+5Ibu7gL+UDBfHyz00AXjokgEvS9wMlPnbObyT4JWhF/mgAe5tTku2
	IMrf/zhZRIgRSF+GHOUbzTf9UcYplIh+W+raZmgzT5ZFzd9k1kjh+sNfB2rW6gUtEDTj3F0Ij8n
	42cnOgW7cmCADsCrPP+KdS7/Hr+OO08Z+qzP8OTd7wx0P9BKiZntxItGFRPyzEaEB4geYXZe9hj
	YN4XM4aJ2CgYNisSyY6WgikHUAEQ3vVkvFSXaQACpt5g0mV0y0dIt86wIMHOjNjteLw==
X-Received: by 2002:a5d:64e9:0:b0:3ec:d740:a71b with SMTP id ffacd0b85a97d-405ca959d79mr5315911f8f.31.1758716942794;
        Wed, 24 Sep 2025 05:29:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3xevDTMGBQG/yt32a0HQ37hskBklE0qC7Sm/CkDYkjJXHbzM/EDh9lB7E+58ArZeOtFZBpQ==
X-Received: by 2002:a5d:64e9:0:b0:3ec:d740:a71b with SMTP id ffacd0b85a97d-405ca959d79mr5315882f8f.31.1758716942363;
        Wed, 24 Sep 2025 05:29:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab62233sm30792525e9.21.2025.09.24.05.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:29:01 -0700 (PDT)
Message-ID: <2dcffe42-141b-40fc-9bc1-b61a1ed7d74f@redhat.com>
Date: Wed, 24 Sep 2025 14:29:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH Next] copy_process(): Fixed jump logic error
To: Edward Adam Davis <eadavis@qq.com>, kees@kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SPdK5oBeQDEtNdCkT-ZXJkZEoHHHaH1rSQw0zH6_zp8_1758716943
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0398040011
X-Stat-Signature: qq4e68is4ub6oihx1okwoscfth17o5cj
X-HE-Tag: 1758716947-157876
X-HE-Meta: U2FsdGVkX1+MtNk9HKEHP0vdFHRgLYylYG5zQ1qS7OVU6r1w6K08snxIiqrRVYyPSYIPRKv3QWBmgTtYLaxEQQHRG72a+sawdj62QrCVxX2eiESap/zZL6dJvUNVnCYtFzsERf1QngHLV29rT9fU4Rii9+ouyTHzVHRrIiBQp5R0byn05T12NTL2qZUKCYX+FBqbr5T0dQNhQUX4pkXKjs7Nfo8p4j8jI/9MfEJ4QoVNRHZTUFM0ESoBS56mjXJdcr35wFLZFrU8QZh8FrQmHkZAkmmOdaYwnNUP0VXxeTFMn2OrM60CQ9Yf4E01z0yzTIhXXC3lUqTK4Qsu6kDblL0l2wS6UmEGorkC8ao8aoeT+TtyIVoUywfpE6D4cqOC47b2Yr9yzHk6Ba0MoGFuNGFKW5VyjaoYtKXDzrThs7meW6awP4v9JwIqT1fZpzTTZs6O1b/cYwFwikSWJ9YMhEKbNqrz1rtY0sT23tbULL9JcVCt6HsLPxULGt0U4ec+hrWfA6o51fSE5ACKcS3zrhpE8elakXYLDL70Wbb5v+JGwcuWJst1XUgOKTyToG/MgXTbydqALnUAXMMsWiXOmTwWQX/vs3/hs6QqG31U6nMHle0E8EEmWIM4FOR8wMaXqgkDlsMmuG+QrHq1A6c5D4gaequDfZDDCD1UuFVMFJQwpnLa5hYmCaiy00uU74WQ1SAF9rkCVRuw6RabZUkFf8amabcMvdNS+0ea8/ep0vFEpTHtY9c81lAcy9ua3sDM4ynAYAERIhXfXUgOVYXViWcojve7ItIh1mOcHJ6ruNWYE/Ow7wenOp7FthDK6HymE1rMu6eaIL4GCjvuOVP1XKgPZPMCR+PWoaLd0O3wZVTb4fVhV+ArF7CQzOCO7HfFkckali3QAxhBWTzu2oOeIt5W8bMeaj+jYXKzQK5SXhyN5I8oDJR6sQG+axiAILnXqHBN/+tS/UU+ZOKwQ7g
 wq82LlUq
 AKHmdpeKNuBK92DNGhuHIjzrQnPlDj7LVZW+91lsihUFLvWFz+NBITHPZE0ZFerAuZ12pb0hBSv/X8h80B8IKdXhzBB+OckF7QBudpexNJdXUEUyOh79YIqosJnZp0OlgaZEpEQNC0vAJlwRBB4FhIa8JiRKjZ1sc8lQXTv6fAse/2KY6Urjipu+KUcKTGySYn1KhjK4FZdc9zgdlZvcb7Iq3R+z4IT/N9B9ZifjSZLrRX3/lkiWRflgCnUFqAwCBm4/yazSjbt6YUsMH50AMMMmo9ZYraOr35G+3ncIyJ+L3L+cc0Wt8pjqsAB6F1AvYH0pFt9uY0ISKDvB6dUPPKdaHYsganhb6ADh4rhnS4zAmt9YGj7JunZ1b74JHLBRi2fMYekbIxUFaMWg6nvnTAa6ohqnZihZwm0Iu2ZrEI3DdhQuym87g0zZ4vmcYMGUnTH79PM5gZeDZdWGoj9evESW0YQ7tMs/IkIItg3PSu7glzSL0PKd2Lx0Dt+91A/bWVgmoL+/ZDjcZpG6daGjoLjqEf4E7onZhz1I+Y4DJ2lqjlvwkJ6iAT4lW4fD3TobVVRjxUj6+rS/6DnI8VQ8R/aLsEoXZkWBbEepSaQlJStRO/TLH+9Z7kaR3ScOCaXENE5zRYO9O/safS2BW5jFIqa0NEmD42LulyvjaqZQbtLkje7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 14:06, Edward Adam Davis wrote:
> After futex_hash_allocate_default() fails, the logic should jump to
> bad_fork_cancel_cgroup, not bad_fork_core_free.
> 
> Jumping to bad_fork_core_free would cause a siglock imbalance.
> 
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

If it's still only in -next (which I assume when looking at the Next 
tag), into which patch should this fixup get squashed?

Or is this already upstream and we want actually Fixes: and CC stable?

(staring at current master, this seems to be an upstream problem?)

> ---
>   kernel/fork.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e9a7fb5c3e49..a0b8eeeb1d27 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2349,7 +2349,7 @@ __latent_entropy struct task_struct *copy_process(
>   	if (need_futex_hash_allocate_default(clone_flags)) {
>   		retval = futex_hash_allocate_default();
>   		if (retval)
> -			goto bad_fork_core_free;
> +			goto bad_fork_cancel_cgroup;
>   		/*
>   		 * If we fail beyond this point we don't free the allocated
>   		 * futex hash map. We assume that another thread will be created

Makes me wonder whether we would have to undo anything the 
sched_cgroup_fork() did, or if that cleanup is implied in 
bad_fork_cancel_cgroup. Without digging too deep into the code, I assume 
the latter.

-- 
Cheers

David / dhildenb


