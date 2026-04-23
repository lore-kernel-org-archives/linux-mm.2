Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAF0F9937D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059076B0005; Thu, 23 Apr 2026 07:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009B56B008A; Thu, 23 Apr 2026 07:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62366B008C; Thu, 23 Apr 2026 07:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1F316B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:56:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77FEF12013E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:56:02 +0000 (UTC)
X-FDA: 84689666964.21.BDA1D89
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6621D1C0012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:56:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IBmXRr9a;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776945360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siDGmpSQgWAHKUux8b13NOof/DcmZ5a9QBx3K/qFpTk=;
	b=57Tw+9Yre9APZBXUaaFFcKTTZmHDsxaF/T2nJVka20mMFO3VQcW1hxthAgzaWTIZzmPup+
	sG0SiplkWCksri4eV8khuFrJXd4xCICxUo/moO3qTILaNgqYCov7Zz5WV5A5MNjFzm5CPX
	d1WGyLbsltPHRETUEW7pkeYeeE5PZNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776945360; a=rsa-sha256;
	cv=none;
	b=shodox0k12OoNRUzqm+n7ARExFlMVPcTuCHz8SEwGfnLWLNX+AIFIVCyazRcxtBetdfsB/
	EDjW6+Owicbkk2Qd/0yNlxYv9F/FCfgWG/ZSN00zBwr5VUNQjKHCcO9UGQAwVb1aqh6M3/
	k6tFeFCJ66UrwEqFw2PPOk2e2BJzvWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IBmXRr9a;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so107211145e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776945359; x=1777550159; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=siDGmpSQgWAHKUux8b13NOof/DcmZ5a9QBx3K/qFpTk=;
        b=IBmXRr9atxv2G3ITrhoBFN+pYKP1sip93HnHfLtsyfCMg7RrWP9yQ9SApeJ0zV+Y0r
         +qFDjbfB+v+FR+R8h1Xg2QbpfwQNz9ztuP5wJBOTXaK7206hXswjhIDlI1CbUOp2Yt9r
         1GJeKWOoZfmZEc7rIsobcwafBG183Gr3gLzMrDwD3cyN6S8jh9SkySwVNZRTgC3AwJfE
         +gcjhlbj4klGZdySLR8K8CqU1BIVu7+Zwldy383Evyt04bGK/8C42PWfjrvAtwiFsaer
         r2Mw6LSjW4cLJNqp2h6A2y++Gixe/3Swl23MehoQT3NxdwPLIL5U0+F43LKAFyptN6hH
         WPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776945359; x=1777550159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siDGmpSQgWAHKUux8b13NOof/DcmZ5a9QBx3K/qFpTk=;
        b=jq7CW2ejEZdoGkDvCrm+5D0lRpO0ankM7ADfm5vGIVeFs7F2v/natyoLym/dUfkXJz
         whOfDl7sDjEvtqphjUW8WTj+8kxG4IrKMPqXB/qHvBr2/t2AotmdxkVCiw/AETXyiFBL
         smtPXpI+JyVMkD5aGQFiurhcoeLN+Xw6UICFP6zvSgjfGWTg/JpMnLX2Nj9Ab37s8iHX
         QYt+EUA5vVNXn7JDyg3J14fJiiFsLsDXbMymthWxOOUTc8aAdSc0yW6NkrsUvRDO3AVj
         aLDyR8XKDrJ+nmfu38ZTGGaxEtLc10YsLQ5qoh1bVpFyUnlXRX6zJjjY/jjXWt1eUu0I
         8xIQ==
X-Forwarded-Encrypted: i=1; AFNElJ/OQT521PbVYemH0dki3CviiSzWnEVtf9p82Nedj30ESdgMPQjn2DLMlf5NffG4KdjnqLes+IC7aA==@kvack.org
X-Gm-Message-State: AOJu0YzSgYKdUOBy2g69diCveNyPkGVrdpF7XGVuy6EbWq3T5lpboOLJ
	hn40iK/nW9idGg7g6Da4lLD6nPyWqZ1Gnxs0QSLb11bClpadpe2utRoD/QMA9djk0UE=
X-Gm-Gg: AeBDietSbL7YLbbJPp/UlCWyZJi+WN9ic25tHO4VIQdsOJXYPd+rQsuSkDnrxofOd8g
	POcyzQO1sT//zZvzkdE+u5q5uT6Fz9sEVBFrCUOPXDbkef2rMTjl/bv8hrEvx0spBMV8hUsa1oS
	LZgRM6oLapTf6WWDO70tZ40hNyy2XReXs7Ava9C8cYJ0LuSiJyCjZu1ayvI3i+anqLT8J6HbaoY
	eLw6iLrU1C0AGpUo7yx4kpddpOe0h87n/hzLXYoQCkq6ZdkX9IvtH3L+mxNPAwjkia4JnAUWQzJ
	r1PnyR91byvL9R170QSVvK5wTilZS4vqasxUzKvlqM2myPvRpNkQePNcPCqx5qk1vPnUUXm1eu5
	hcQL9G91L0TL6+AbA7nPe3ur06nORhqvdsgNLhfQ9bRN+fr3kIcAio2UU2hJUO5hBmate8d6Kg9
	+CTGKXEoz2/dGNDX5OBYIyPnChtQfkR50ERiy7NYQe9ZnSBWw=
X-Received: by 2002:a05:600c:a10e:b0:485:3b9e:caa7 with SMTP id 5b1f17b1804b1-488fb773f38mr287588885e9.23.1776945358704;
        Thu, 23 Apr 2026 04:55:58 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e591cesm71273809f8f.36.2026.04.23.04.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 04:55:58 -0700 (PDT)
Date: Thu, 23 Apr 2026 13:55:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
Message-ID: <aeoIzYSnJK8YeZEb@tiehlicka>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
X-Rspamd-Queue-Id: 6621D1C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: zjmm88o9i4bnxstbpmi49rof9bfe3oai
X-Rspam-User: 
X-HE-Tag: 1776945360-842622
X-HE-Meta: U2FsdGVkX196UoB7S0vnTxlGfcD0MM4l0sI6VTiqDW9XvhYKkgT5j78wbq86sS6Z0JrCOc6WwlbRNo/apkhCm4H+6i54hqGJQVDiE/0IQIerserXDlQjt6nruL2sWT8SyzYrUl+OIKheAHuBMW5aunIOPCq15IumsXYwgw6ZI63ZeMlLX8K8ccJfFmi3SyIqEjuQahq5hmzwkrDF2eUsDY5Nw3njvraEadPsGFAZjTpVSZXxrql6FaCnBNu8F7L9Rw79kBd1zhImak2XS2NcUtd6TlzL+EH6rAyhkiG8cMTBO5TUNxhqBZspUAdWhB597NQtgkdNyIHcxHyaaA+4yQ1B8ubmFmvLDrzMBgmLepEApY/ymUZRYWnFLhXT43OBgfjtp1uN4HY3Nx7KFf9UQJSg8Ccy5Nb1zXHIjuuRK8KjrcdMVwghPQ107AIUhFXWgTtxXusApFqCsidsJd8MokM+4hxz0gB8+NNb9rgel/f99IgSTIWifukLoiZR0ZU08LdRmJHo8L1dbE6IC17rxS5EOK8IdTGXjz2NBvalgAXdXoPiO0dHxwqy+W178XX0huEAiLLs/d5pXhswS/hESeQqHv5BBEh47Ycz4gChSZrvC9C5kn9vj90DEnsfAK0dKv1Z7EPDSjl/YxqCAjY42wj1ol230zMShUcfuYEz/HOAnPvRrFOgVbG2Racod81e5kbOi9MyDTKHOVKiIpjr398w91tn4IBR4hNlq+0VYhrCrUzgw1W/duej3xabWa4NRV1t4f+GZX1DyC120UoA/IMZxcH4B0MY7MV3VpdB2aUEeVHx2DnABMfKtFJw9VLoWx0sBDmn1zNxE3C1Hj3oD9eOEZLQWNct03jehjUBZuHeOTI+OAS/6mfqaOqghDSTX5awLB/mS8nPoWZWaaWDY28bN30yQOlpSEBFWxQk8ZgVYDmR1U+1VLkPiowVkHtFzXBwywRBK/BQj+c1h1C
 ebYRiEpX
 j+Vz94S/ib/8nVqrGHoJR78icb7FSbZ7aOwMIrVpA76rRinqm/YT0JLb6S+3WefDJECzFdT6qaYrfWC2iHXBsO3lkABw9jPUZho3ClicnbA/On8FGraCVEONdE0BV6nJuuJ16ylD1WSe5KJDGi1cO90xUNuCk26WIyKpX2Ofy+UZu7bL6Rmu3QeiEp1g2s/HiYlTpOcscKUenEmpQAySJjRLDG65ba+kVdFHrxAUuymiLCUf9OJdQvH+uV20zmtLEUlphRcEZUQsw4mfTc/qChC7XIvO+DibkfQ1RRyDqCZhew5XgSWfZTxCLfnm8HmhKjcSSRjg88aD932y0KwNUcy38ODL7FXctAj94h5UGCictYBxi8aVdpL3cjRpDWs5u40cGxgqk5WnGAqM4pnnSx1XDfwdszg2FCYq/yo7/Xi1n3qVHZqwLfu5YevprxIuzQaKlw64m+YEqoKAFtXleloWtthgr6CQBJ/PutecKacvjypJZ0yZ3M/FAElCGkke3/EtXvL7RxuBfo7a6m8QFxArjkhQLrnWqheFkIk4HlJ/QOy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-04-26 23:03:16, David Hildenbrand wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>  
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>  
> 
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
> 
> Best regards,
> -- 
> David Hildenbrand (Arm) <david@kernel.org>

-- 
Michal Hocko
SUSE Labs

