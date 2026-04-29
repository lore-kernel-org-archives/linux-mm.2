Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9489AFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C1F6B0088; Wed, 29 Apr 2026 04:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCDA6B008A; Wed, 29 Apr 2026 04:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2486B008C; Wed, 29 Apr 2026 04:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1B726B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:00:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EF871C00EC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:00:46 +0000 (UTC)
X-FDA: 84710846892.15.E960112
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 78D7B40013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:00:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fUak6XHb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777449644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKt07qcPF1NidEM1dAs7s4kLamhrOjHwcNAU0l78/qI=;
	b=U7f+whGKRUpR3eodeLwSh2OkyZYW7x72HbR2+NmxGANzHcIAspBuHlvQTF1bQZSRTa6Iqv
	dmDjPPDK08ElDI3CWl0yASS6SeTiBHCL5/SCqjfiopR9TxWnp+WilesszlO4o5oWvA2xwS
	In9YubPdt43I3OuNWA/npDN7C9D3m70=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fUak6XHb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777449644; a=rsa-sha256;
	cv=none;
	b=axZ+qE/5bJYgvEE6Fgm3ezDHeQ6Io9GTcupR35TLQ0sOjhYgoRAWa3AtgCnTizVAnAA/+2
	OWZFgRmzKQNCR+4uC/euy4SnLvKtDevP1paWBl6AZc6m3KfUMWYybxdQW0mCvmyanVdaQM
	TRw49P6KRf3avfDQPFOqBO9DHp7JfXA=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4836d9d54f6so18108345e9.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777449643; x=1778054443; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sKt07qcPF1NidEM1dAs7s4kLamhrOjHwcNAU0l78/qI=;
        b=fUak6XHb4hWk3Ov51GP87aQgpicJ1UiEMUt8D/Foxmpi9I6DLHrSC6kAoh7AhoBMV8
         5vPvCBvw0wZOY2kAE6JZkCAgp1toexS6y6dyk83F0zHGB/VyA2mYtxz9f0aryeLkNISM
         iPAm3nQO/h2ZjoTtAtTIdkyqp8KwpyjUGPSNpa5/1M484zhJ2zsQjz7RgstNYbqSaVuz
         nIm13+1yoTDzsI9iJ8fUzj083apljtM+jqfFFu/uQy2R/ZjrkFxBnp603xdou/7zEWj2
         t8ghDAEJN62/sXLssprdXKu2CA94WIhP87ORhGkM7EGy41HNdW8lKFmoNqOUVebixadI
         9DjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777449643; x=1778054443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKt07qcPF1NidEM1dAs7s4kLamhrOjHwcNAU0l78/qI=;
        b=TvGRMOMPyP6Bcj54exOUikRklPKnmreY7cXPS4lH8MN9z4/F3QvpteXfSBS0MsSQWF
         1BE3kCaqMsiICTxFjHPC8Zo/8dABRMsz4BzWQLJQvSUkYMqIgOHA1IlvW8rtj1eSSKjX
         AkAVCk70Biip648sqjssGD6/4UZjkQ2rpfmX9onWnTRtHIVo7HigYZLDwxdlzyTKuYz5
         DIyyn4ySY+czoqXBpvRXCiJvrtWksTeuZLhT/kcb/Ap8UszRrK0R/IYkVFvHoSvA33Bi
         /We5A5WtexrlBTPftl3Y/nO30slBpFVXEy20Ydvc6kCMVPeu9MLZv2OQBUwymOr5R/48
         ozpw==
X-Forwarded-Encrypted: i=1; AFNElJ/J5goE3R9BtIpAIE6nfS5f4+P8Ea+95e3GLmMGslLq1IJg33mddFIsY5QmMsdeqSXbPf5im2rWjQ==@kvack.org
X-Gm-Message-State: AOJu0YxsY5OshyEg2gqzVveIwDJn1CX7+XkZI0BtQbbjJTaidx+iQxkw
	ekoUM1cQymVHaYdSADVrqYJwRodyT5zRkjnA2efIH5BMcMEnaJoXTIu6ZHicbnj1dt0=
X-Gm-Gg: AeBDiesdy6K4YeR9iLDw364aniLTaFJs6pEmZh3y4Z8MF/Yjd87xPZ7AqOXwHuOfX3j
	ToKMdUdwBBqDTwghdBEtn3dvka8KcviTGiv2Obj2gnbyLrCdeC9RtrAVf9xt/UesjZgiIokFSHk
	5EuzMx98QK83+8JY4acRf4ItYPfSMrd2jD+TJ3zjahMwZQFbPb3Fj2lqD6RpoqkzWS1os78aD8u
	j3G1x5xCOGWPAHMCZAI4vHj8JabI1g9rf9v0tLY5GOIUlXFcMv5dFG7NwmYY+nQUBxvRvNNffbv
	BpyRCmU0r/40UVdbFOJ8qDyEyx0X3IFt20JNCPdwDm+YUhjgF5AfjoP7BcI7aBEkasvRD1JRZZn
	N/67f+qIlAELGrgh5FJfTYS6t5RkyERf+x6ZCDbDmRN/P+/T8OmSrxF0EGV8dFwkFdtiWcqcZ+6
	m7g6PoQnQghjPnGILRxvu7M6rlMGaOtAsa8wi5cJOiGcPFwP9OTgPaX7tV2iCMs9WIwAvB
X-Received: by 2002:a05:600c:3acd:b0:489:e696:127d with SMTP id 5b1f17b1804b1-48a76f82973mr58572165e9.5.1777449641184;
        Wed, 29 Apr 2026 01:00:41 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c303c3bsm18098475e9.7.2026.04.29.01.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 01:00:40 -0700 (PDT)
Message-ID: <78978a11-8345-4b84-bef7-90d17f4c581c@suse.com>
Date: Wed, 29 Apr 2026 10:00:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
Content-Language: en-US
To: Manuel Ebner <manuelebner@mailbox.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
References: <20260429070759.309110-3-manuelebner@mailbox.org>
 <20260429071445.309733-2-manuelebner@mailbox.org>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260429071445.309733-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 78D7B40013
X-Rspamd-Server: rspam06
X-Stat-Signature: 16fumx5rpfnxy55ga5yeacuiu8e8jbgu
X-HE-Tag: 1777449644-499948
X-HE-Meta: U2FsdGVkX19FvhUEDTBP/HUvkt6Vc57Cxgt3/Z2P54wWWtkxjLP6YindZRkXOyEzJraLjFurvuv+w9yTh+yfl8z1H5NsqLm4rWwk5TosvVMiRAvHh2sCf5+ZVSAVhcKPWqvShyB4qVWbawQlvXBNbsK+xTclfMZ6pETg6hZDvUvuJ3HdOyi1/Cn8tUdAUhF1tp9K/HfFldjASvoiP9NwemoieSzS66y95oqg6BEml03k+ZwmTNHbH1TECivH0x+vxorg2ekeK4q2dZS6H2Du6KR83otEB2kOLbKIUL6RbgOaszAhqe5M/NVUaCPRrMLqN9Jc3I5T3T/0hVsY0db0GIpOm3cW+DUiO5UqeLR0CugmJCPzVvrNqb3TW7MuvEbLNLGE5RJ/gVQsv+x3vYGAw0+mQmUajcELYglKszs2Q3MjfFu205Uyz8okD0QqA7fcV6+KuGuX+PRTzDYeBt1gRAvCogTjz5fanCgoWROI9WeFz0+Dgyh1uCM+SfNN/Sp2j83jwO75VGGQAyDQZWVbzMRP5olKxfWRLvdDVt93VsTrsWhqhruRLKAwhVCXh7cPSoNODyk1K+7zLueCafY7TQXDPAq0BCWJFVo0RJkfU9RyfVARUsPlRI/fO21fe42Gbo1pGDsjUoQ8ASnJbIXL547DQHblOmX+9U0KTy0rNMFCKiQ9IoO7fevhn7yG8nuXA4G2xKsj+m+DOUtyHDCl0K+tbUQIM5LsyyamGZ2KQa+AcP1pID8QhyIX030UZvoG22ymeXw/aLDGRA0C683uzzcwlkzhABcxe5ARwER6jYY1wvRNV4uQIyj89OfDAdc/MvYZX49Xh1gwZdU9XQ2o134OQ0gNCOU2rwLwEHzSe0zWBZ67KGVgNDcKBYyHTqLCLI/s6R6kB/TOnvUmKAW4ZWtSlbNdxwadNLEoKNj3X6v6R6dd4GZIYm+kkJHZqUXnj5tEnLq2cQLU9rD23Mu
 Kr3sXMom
 7flj9DzpRtjy3rRwrGnS+sPlNEQQSY25ZkEB6031MuBuImJDao423QoWEX0PPruKZtcXXVvQ8ciKTT8trvl745xq1IHQWXp51m30caIlJP+qm6xmQn/IfLrHpyCol1DQbPJvbBGflaNguSaLQlxB3QZcwglR62/0h+2BbzSrjdvFF+GclGLkFgE29tNvBplPwNxvHG68koR7z0abirICAXGpFK7aohpUYeKv3/iUpHL5uEoyvEFGtVRPr1Nkpp3xmtvm6l88cLs+ziUl85LIjv80cMeYRXVF3wckQnZ/DydJoYg+p6wf2wC2Hhg9LAfSCPXLwtI223xblza2vZAvRrrKUOu3NVM5vrjuc+T0E60+9/XK6nAVIQAfPwlkvAL5u1wl2lXuXjEfAHy5dkmGLOGIvTe6LKpjAgNZKl3Qf4S+vUesBfLegL4vx+QpJ3DBI0ltG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 09:14, Manuel Ebner wrote:
> Update the documentation to reflect new type-aware kmalloc-family as
> suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> and family")
> 
> ptr = kmalloc(sizeof(*ptr), gfp);
>  -> ptr = kmalloc_obj(*ptr);
> ptr = kmalloc(sizeof(struct some_obj_name), gfp);
>  -> ptr = kmalloc_obj(*ptr);
> ptr = kzalloc(sizeof(*ptr), gfp);
>  -> ptr = kzalloc_obj(*ptr);
> ptr = kmalloc_array(count, sizeof(*ptr), gfp);
>  -> ptr = kmalloc_objs(*ptr, count);
> ptr = kcalloc(count, sizeof(*ptr), gfp);
>  -> ptr = kzalloc_objs(*ptr, count);
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



