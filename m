Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D61DCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7376B0023; Fri, 29 Aug 2025 04:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2F16B0024; Fri, 29 Aug 2025 04:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A1D6B0025; Fri, 29 Aug 2025 04:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 811196B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:56:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E377BA45F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:56:47 +0000 (UTC)
X-FDA: 83829189654.22.DE3879A
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D3531C0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:56:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cpTsAsCa;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756457805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3oJFsmmS2ZGu6eiSOuhkdlqFpqNjNFn9XhNWqVm6U0=;
	b=DQ2GqTBii0tMBTqdwPCOhI0J0ddE6Zlad2jQpMy5AKt45ZFx2tvUFkIMyXkB6SZXehU26L
	900e5ZAKvhXOmwGaH/nUEM9c3+gPXUgv8o4f0M8zbgg8rcNoz8l0VU4g8Ygb/0tZPXF4E0
	z0ibeiHFgGchhiGwVYevK8MPVv57bnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756457805; a=rsa-sha256;
	cv=none;
	b=fCV66xHEGL3V6BUAomnBlBqBzZ7KDkziiV0QdfIin9f1lBxu2kQG/6IIs8G5l6BTdhiGL1
	pQVOXU+jW6u+HN8EsC4HM6NIkHYahBfK/3D+FiAVgs2bFiAJJvxteBUkNnSg1rcIdsZh2v
	v0gZhf4gi+OVfcAsJ7t1KjIwEltQog8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cpTsAsCa;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-771fa65b0e1so1007935b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756457804; x=1757062604; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T3oJFsmmS2ZGu6eiSOuhkdlqFpqNjNFn9XhNWqVm6U0=;
        b=cpTsAsCaa3F+sZLSEpTq5rT8y/rXaS5fSD6H5uNKHSO4Eaan8jSaodbEpOyaiCiy49
         XkmV6AUVmxDXyXnVfOs9acvL1IeUNwL0sksz8MtTKFicwlxHDhPNVmVk9zVtysUj0yPK
         Ehyrd+9lgKtWS0RNSA9c04AAKiXbxGbDSjbR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756457804; x=1757062604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3oJFsmmS2ZGu6eiSOuhkdlqFpqNjNFn9XhNWqVm6U0=;
        b=q9eNLaDm0v1QqMK/GC7gTegB6CwkTAC6H2EXm9Cv5g4H+Y9jPLDAgzKuoVZB+3AgTZ
         PUmqB8KwfyMQIVKPwXRPdx9Jg/OcW2x1oORe1u+9U4s7f6vE6Mo2aUuHlguPWQOdPmJH
         A8z5TdmQr6sw+7VNBLmlY5YrDXxU6r9QmUYvuVhftJ9y/JkvUJBrAHkGvBLmq1tt6qij
         h+4AJs5KClQiEUUbWorZbz5Haf+UAN+6HO9XLEoZc+3kmwuRFoq19WO9MAWt+9asGH//
         JooVgJJekIe7JkC9/PDxcRVytFvr3aqVkpPOrrzid5AV5y2qmsIbbPyHWI61EAG3pimU
         ecuw==
X-Forwarded-Encrypted: i=1; AJvYcCU+Q77ZncQ4HE2XtOODwJB+gI2Uy41WTJ6ycgw4lIOjXnUX5WicPZWrhYmaR3T9k+MW88RYUizRuA==@kvack.org
X-Gm-Message-State: AOJu0Yz4A2Z9fHs/IC7cUtYGY2PuEuOeSdsRTguWkLnMMcJvz+e+A3+l
	sm2KHiw7Sfu2/V43gcxtbCgjbFmah40kQNfuonBAZ0KbifHTS1dYJm+UWsTv7XqBig==
X-Gm-Gg: ASbGnctV7KwCVJZNSyfJWhSsxKjcC/TEqtOU7feOYGIkdJImayzprWDgaBQAHWiPoH9
	9j3phBEHikXwydMfNM3fEG8+4FfyrR2KnKj1DgAUgeZAiZ9AjT+v1PbPGaVEF3wpHvrDup71P1s
	/HXhsW1M5kvie9U74Ak2cwNERHget3Kdzy0vrRCZQTcTmzHOmlTdTaxKfHumT1bDt6QLPjD9m6Y
	Kva7TwJAsvMK3cGZrvShhuIqlnKJAdPJT66NjjhmNjp2rA0mqZdnK6MgBxwGsMnbL8BKAD5c2Nx
	eyspO+KjRXnYcN15J9k78jLTVHIxOvcm9yq4hr6IqF03DVgteC0ng5097ayeW3bWj78rfBLsmoA
	XHIoGHn9STFeIG/ZruSqaSH/Ql1MtpNLlysWK
X-Google-Smtp-Source: AGHT+IE77behwFNSbRmH3pk8zfkxHLh0n20scBchwb33vR4SG2CIgdoHEVISGNZBOKMJtizOBeKA1w==
X-Received: by 2002:a05:6a00:4098:b0:771:f34c:2d36 with SMTP id d2e1a72fcca58-771f34c350dmr22224461b3a.32.1756457803984;
        Fri, 29 Aug 2025 01:56:43 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b838:d833:3d57:68da])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1d4fsm1692519b3a.73.2025.08.29.01.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 01:56:43 -0700 (PDT)
Date: Fri, 29 Aug 2025 17:56:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Mel Gorman <mgorman@techsingularity.net>, kernel-dev@igalia.com, Helen Koike <koike@igalia.com>, 
	Matthew Wilcox <willy@infradead.org>, Thierry Reding <thierry.reding@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, neil@brown.name
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <filznxw2rq5ylpawl3auho7luiyaqxkmitf76bbpxyihkbkw43@pos7qfwb3i56>
References: <20250814172245.1259625-1-cascardo@igalia.com>
 <10cdada2-f28f-4868-b821-4a13ed627e76@suse.cz>
 <77058118-b481-4c45-8f86-d9a67ea6a187@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77058118-b481-4c45-8f86-d9a67ea6a187@suse.cz>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D3531C0002
X-Stat-Signature: 1nmc7sd3xqxfg6pfash5d55f65rartug
X-Rspam-User: 
X-HE-Tag: 1756457804-595618
X-HE-Meta: U2FsdGVkX18io/jTm9Ae0MXTl9U8pYpkZVh9zkpq22/LuoMSHNVzuBR0J3p3uCNHnRrdS05TEt+t9rsxgNU0g3HpzQLjjkARpCuCQft9dknwOf0Ar23q2uHhu2FOD6YiyVWolwz8u9gWzQ7xFl+PokQ46+bGiNgJoYk/Qe+YCJqdEQ26b7nwYgoHr5xPeqpUVRXZNxsbOmtaT6lKOl47/e4QR7BRPrS8Ekk3qdpTlinap0OrV54yXlVQWG4ZbXslB7dyFSp8p4cKmlcV8918VMaeBx8fVajY5o6baKr5HsPW9JCP/YowEBzCh7k54zbXZ19lgYwWpr/JGpq5neCChEPL9wgAJy9dimiRig7DN5THZj2GLmy8riIUwquysASLBGWFO9ohmiW60Tc0SbIV4ViyqJUxdXCwbsfvKijMWQaP1iqpu4OdRCmanueTY6KRXEjoNSbKLZs2hDZgJGe2WrvnlVqpYaOO5AHbjotcZ8lH2rwvJkafEAD40ZWy57zbYee5pvHawdIy01xOXUXa9/5OAtYdBf3xZkjMbM7YmwznNJsYKO4OTt1N8rRuZ6fTIoM21ic+Nvk+twpAiVJAEjLc/9LSEqKxrFzNbePAwtscHcgW2UC/63/uZcxutOgjkXn6Al/ImSuPWXZuEoRAMkXzG3oHtmzR4jT4AXyCOQfeUyF6N6YgL+6sjV9CN9UHVitDGpeqeJsPqYoT7BHuAtSLjZMAiXTQJ0WWG4g7x4RFdpX6I2Ue/OmEYgh7FyFEzEhcL70Bc7hLTmf24HEs+ulw8+Yi21T3bYmW9I8aD85WK8ydGWCMTaCSG90IHji1dXEqSjKeNspLRAKOlr6x6u8XzSTfPQL4bPP/lY0J3Rjwk5PlSmJEKshYE0vk/ut/OtvqwSdSdnaLWsyo0aEYrrVNeY5ckD7GYIZNTW2Fb+arl0tOl3yIe+t57X/drF+WFIfVKHGnyFM9AcdC3PL
 bd13Acgi
 7K9bWMwegSNY+DF3zX+sqEMpyDIVTbqJ1BIA1lEkk5Esb6jM3yUZj2dqYf7rXH/iZffOphZXh4r6LN0ISBqF9G9ziLFy4e6rpPodZM8whEdygyOWGSyU6obOtnIzrehvFLxT9U7KdIEwVJA90vGYbFEfrnUNdk0qXDdf8kgefAKcSs4BzHdwKknycQSFmGmFQtAKxa98NWpurLmbEP3AaJ+PHaMe4uJhRUFsm7TW2od9hDWFXvHHdFzssA9P9IZg0g95BjoldSwqI+2p8/jKO31dQft3lWAJsuxX7U1JFkcfy/KBiaBkQr37Is92p6Y49Q5FmagFL0Z1qbGJS9yPoVQCJqOex4PO/3aYxDRE75uq/Ab/jOzX2pdHyQNOjFZQvqE8FJxgbmmDBUql+LRg9qWYBIfwL6B6KwH7wJ3bA1AnInLmPPnT3cpwG/7viOSd1kh7udqdvn+RZMKtL3p/v+MnS8jgjhSi/jza9Yq3iCHpTFjE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/08/29 10:38), Vlastimil Babka wrote:
> On 8/29/25 10:36, Vlastimil Babka wrote:
> > On 8/14/25 19:22, Thadeu Lima de Souza Cascardo wrote:
[..]
> > Agreed with others that this change matches the original intention and it
> > must have been an oversight. Also found nothing to the contrary in the
> > original threads.
> 
> Oops, forgot to add
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thank you!

FWIW
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>

This needs Cc: stable@vger.kernel.org  all the way down to 5.15,
as far as I can tell.

