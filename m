Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABDECD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 12:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1D86B0092; Mon, 15 Jun 2026 08:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383EB6B0095; Mon, 15 Jun 2026 08:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298F96B0096; Mon, 15 Jun 2026 08:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17F416B0092
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:24:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA2F3A09E0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:24:06 +0000 (UTC)
X-FDA: 84882064092.22.C671CF2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id CFA8210000C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:24:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OmKyK9nB;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781526244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3ueRdH34oY7RNPNueN61e8MZTeWRpWsScceLyDJzwI=;
	b=yTMUEtYTHW7v4c26/x6dHbauP9vnnLPZGavXgEDaBa3GbC+/HfyF4eZ1BgD0E3YBwd1UEF
	AzRvnFst6bHPlH1kp//GEpDGsb3ZgY34csfHxEeWA8QF9bLzuh3Ps6uQ6kJXfE4QUyPZ4l
	41E8rrn96hCuHRGBoM7+v2iOjFyanL4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OmKyK9nB;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781526244;
	b=fyHhUdORtt0FNqGzIEIuflEQUUV8/N4Qrmetj+eLcsAX0loD89+BRb2UTNHbFwp3zzbRIl
	JTSQmOShVL0lJ1qn9Iw+2ZpGDLwkzZb9mAe4Mj3LVYEwUm6QWdCoVaChxkj687dXQxipzx
	PKf1QSkfvBYC2HTRsIV7IixJMT4GmR8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso24455035e9.1
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781526243; x=1782131043; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3ueRdH34oY7RNPNueN61e8MZTeWRpWsScceLyDJzwI=;
        b=OmKyK9nBMzeGf/XzMdXfoXerW1hZ57RY7LSrI7T+rUPxdFDk0RSUlYQChpE/7SwnWO
         dEAImc5rd/i65TB6il8PwS1r0VX/6sgkkQuVlg5VuwqQnZ/106Tniy4fI+EHSi/Q610B
         Buo/Hn6KPZjDoj3UP0GbjpK/z+hzfMtbkt6F969IpVK31zgaM48gCHNSp3tRc8zAihWx
         k1OtqTHysrsOPcRLioJawUDImItqhgpo1Zl2mRO5XFOJHWnh9Ca6PRcz5t6BUbr5y8qg
         JJ2vFK9IgwQC/RZ1RuK/v98Q0ZQLYKSfUsRd8z09g3Em1VTOyHRrokBgJPSMiwM8O9VT
         guIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781526243; x=1782131043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K3ueRdH34oY7RNPNueN61e8MZTeWRpWsScceLyDJzwI=;
        b=NZeC11bOUpj3VAhQNVppTFemsi8i55moxVroUc7sqSgQlEYOesaKjbmEUx+sffRNKV
         augNtQZ/OOiBJd1M9Axp58sQjrs+3v6oXWgtdZjwtE1JoWSejwolJcIObZAuzGBwH28Y
         CwDPjnddny3Wz/GOGYMnYvN2cyr0pqp2dPzKStPXam7HFwC96hh7iujJx9VYs8yK/dpq
         laNbB2Ff/atEO5/5e4d3XeER10NXhlaVh5KWWcJRGpV29DntpYeQ2kho3tvvHYDd1l5r
         abMWHYgkkoKWbfLylngwNdv399eHjX7QkdlTWYRJXYn3LPnc0zGIcX0TJskAvCoDevBU
         AxCg==
X-Forwarded-Encrypted: i=1; AFNElJ9c2qC6INKLCXf5hNSyvlxlJM/4B5uDi30Omo7/9+XGZDrF4aEDTwdUhGuVDwMMC6BgY0yJiA41WA==@kvack.org
X-Gm-Message-State: AOJu0YzvBM0Zh3PhqgSV4Y611FmzaXARmDVYl1GOwUdHbcXsuTvz2CB0
	O6Ke3TSYCjekH7ce/u9SEb0PUqpdcLA+Ze14BSzqPDu8FX8aFoII1nyn
X-Gm-Gg: Acq92OHhGLCw7wSYmu9DPjI5HvygwKJ6GtRkY7NPVp+Gq8PUZUkVQR3Hh+CelBNOfKw
	j3+PAKjwW2Hc9oNt+utG6TsZcbpBGUrvL4/Ki2s43QU/EFp3fT4Xh95aWozhIW/T0yv6Jdi+uX1
	kzcjWBOFEyvl+Dl+5uTcwk0s6yyDk45Tsm/h0Og46p2iXVPy16P+pq8Vtu4T6/R8ZsF07I7wFKz
	U+0Q3MQH/TIwg9ttvKTlesPq5o7sqrFZ4ZkyHb8ml8JDtUgew2e6q0BR5U5BSe8AoUlVTahq97q
	004re0Z5NXPEeGSuAUiL6XJaKVXZQwpX6SFJmzfKH7VJBIY5DNoQQFE9lbtLnTdOsgVad8ZQGWd
	N5/a9f0u4oeTjjCAwHz/AnogRQxKLHwzVjrkByPbAvZZvvyN40o1khlkA1f6MCdP46AxEelBOLN
	fOLIh0f0Mgr2xfHmY34fOet9OZ9RxRRKzNehnSk5IjJrTwSYgRIjwlNqPJy1QlZDRMYWf4oqbEF
	qFLb2JF3+U2qSpNqUohILswrb+/GM3QMnITn7uWokzI
X-Received: by 2002:a05:600c:15c7:b0:492:1e36:8c71 with SMTP id 5b1f17b1804b1-4921e368cb8mr105895235e9.36.1781526242900;
        Mon, 15 Jun 2026 05:24:02 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492202e5d6csm270653965e9.3.2026.06.15.05.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 05:24:02 -0700 (PDT)
Date: Mon, 15 Jun 2026 13:24:00 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] tools/mm/page_owner_sort: free per-record allocations
Message-ID: <ai_u4Mfr1KMacaED@fedora>
References: <610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFA8210000C
X-Stat-Signature: idpo48wzhudg1oze4phocm3upik7kswy
X-Rspam-User: 
X-HE-Tag: 1781526244-404326
X-HE-Meta: U2FsdGVkX1+G7R0mOUit39iELdTlqITzWDuvD5xvUgxJfq6XsuTuy1foGd0RwjyecUd8F7+L+AhWkasKEayow9cgveKN3shUqtze+GbGsO/CX69NSdJftwHKXjm/4Da9eDxyCA4z0jGv6j2MebfC5Ty2EiyJq742gcYpHA+vT2nAsNmcRkHPJATt6vSij/NyYbC9EkuaydUKs9D2edsMNKMJpnOaFyq2YNePXGq1ZZSicfuOvUcIBEuC5qmkFlJrKwk1aAU1iXC3022Se0o1VFOWh6l4U1nr3sW3wQPFs0lNMIgFSpim/7dyyA427RtBLr+z9lfBbhwXTpj0/RltG+O5XVRnB8IXRzEhHcdYdnWnb6a4Lf6l+zH+tbMzJE7MTHo219qoB7QG/DgcDBSg2A8+WCwxs5jXgqjLmhgD19f5sXycsOUT6JeAXkxX5lp5Q/3Vao0Dk3+SdqJA4WPYs8q6f8iPlVCS+rCBzN1G4ZDMhJW1l0qjf2uVV4fujoG/WNuTBsNLK2ZW+xqOLCdh93oLi2AM7UuqWdDEYfBJT/nUaVBYAsBbCo+1zAMLmSdhjt2r29Hv+Y3p2Q47VulFn7Ocj23agDKFTHeoXIQDD2GAWoSKAacoznl/+GDArCuaP+Z6oIL+U1JX6KlGdzTvOTbb5YiQAT4h8xy0/MoRrd7ddVBAE8UnfzPYRxGzhln4ou+B4uZeWozHH7mz73+Mf8GwuQwSbMoQa87Z9622Jm8pHul8d2qV3nc+DnaB7/gkGzpWAVys1bNHuiJnRKX26DDk2HXmli7TBAGscLSP0lt65K3ZBJ/kSgAbiUkwHt0OM9HaiJTGdDuFN8ucyXDn2JrnH3JS3JyM0sN0XS4CMV9MItusGNg1T9Ltn3OdfIEsz4cD4TnKNxrxyWUddZwLYHkE1n1xneihvKj0ypcZrpMvDH1VrrGcRPZJVrUeCrWE1yXwkcbDnpylT3yzccM
 pCLbEgil
 eWUXgDvAw2bR0ua33FUpLXFq4cZBE/X539QfEKn6Z201EsWPIGh7Refs3WqfcYD9kjL3jD9TE6u17F8hfCQIQbONyCxegEQZLty6jRSybiJ/ReRoUEUbQ4OAL1X39gcFBFE+AincRo/YPQHg/mGy25DgKwHDM+AeXRYH6J0iuYTmefMYYN4YNa4FyXG31emJ4MDL8iqXKCIVpUTqE4b/tA76Ek3OfkTB3eWP8T+UQoZ6mq2P9arU/YMe4gEZHOhgkuAzENmFtFy38n6S+OzKeSL09p9CG1yJN4NDgQ2xVWeYNlflAEFLb1ZGeMHwitp3qe7MaV0frhhGkk9VboE2N/Pd09s7q0YLq8Fh3ih1n2LnhrBAXEkDadcjl86CFnhB5vRlX0an24HLNVCxQn0Momw+7RfMvwZDn0njIPxe+t7X8jl9A/BnbePjP+J5Cz5Dfi6Ox3UAs+XyeFaV/tntQAiD8F7K6SlEbPzgksPF/tPJBc56tZATChJ+P01KJ0KyIXOb8nLjMfKu2wxOtoOpW8Cnbysa71nAxpLE7abkY8EEiDMoAz95QLImVCZaCqe/ETxF1nkFSNVRIalampLlpBTLg8MCTr+eyEwzX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 01:50:17PM +0800, Yichong Chen wrote:
> add_list() allocates comm and txt for each page owner record, but the
> cleanup path only frees the outer list array. This leaks both buffers for
> every retained record.
> 
> Free partial allocations in add_list(), discarded records during
> culling, and retained records on exit. Return explicit error, skip, and
> match results from filter_record() to handle get_comm() failures.

Nit: IMO its bad practice to rename function names without stating it in
the commit log. Especially if you reference its behavior in that commit
log.

> 
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---

I like the enum approach. Splitting it out and having this as a 2-patch
series would have made sense too (since doing it this way has
2 distinct logical changes).

Whether combined or split, you can add my tag:

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

