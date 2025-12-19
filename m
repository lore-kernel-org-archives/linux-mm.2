Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03EB0D78784
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6596B0089; Fri, 19 Dec 2025 09:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660C36B008A; Fri, 19 Dec 2025 09:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DB96B008C; Fri, 19 Dec 2025 09:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4972D6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:27:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C48AC0361
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:27:21 +0000 (UTC)
X-FDA: 84236448282.08.DA47AF4
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4AD5E8000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:27:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FI10MAdM;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766154439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5IhjDUP/NczS+J8Ok9NbT6xw9wH/Rgf3ojkCWKEhKc=;
	b=iiWZomyYW8NXLj3Tdm292GKxFN8pprMkYjOYtZIYizC71Oj7NORlwcoEB2776Rq91vhRuJ
	FCjPOvidx9rnhMlTxfIJBVf1yN3fAVkOOVieBBHTgrrismlmyiD1NzejaUvqcJFPbcffP6
	knFjqJPG8Tdp4rwhmVEWne4Aj2wrJQ0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FI10MAdM;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766154439; a=rsa-sha256;
	cv=none;
	b=t35yfLXdmQ0CgGwtKYPF9HDDn9jir6CwhjGi2Mq1/0PjytX9+X/YGclTyHvRTiqrJlk6Ba
	1a6Jy5RdMUKTm3Qd48SyvEqDTC/IQDsnjmD6rVoCA+5luwOSuv+zN3Pf0n3C+yvMhZ6acA
	qMkDVsmccGCh5E9qQMk89hDAuYSJs3k=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a3d2f3299so21134306d6.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766154438; x=1766759238; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u5IhjDUP/NczS+J8Ok9NbT6xw9wH/Rgf3ojkCWKEhKc=;
        b=FI10MAdMZ6L3LG5x18+KERUQTiVyBpwkYx/j+8BfI04IZa1d43Qo45KpA/RwJ1QRWF
         4PHNbDCGxkeetpSiWimKjl5HtvwwRrGxik5V9z0jaYNTBK6jakmnBVrgP7M+lAY5EFmv
         NHMwZdYMFy7yuH32a+NIIU8rCQ5Ry+u0eya1OgeIgE8VihovpQQTdimoiNykTHwTSAUF
         1v8tIhoaLg+1M/elxjomeY3QK/c9yvnNnnXej3K0hDcxxWagMYIHYLgxeLGSxJ7Rs0Yl
         IEeQ+Sop9yD++25T0rC73s3m/F610ean4vUS3/uOHMA98PpClZyfnTSXZqtkA55J0Jzb
         tO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766154438; x=1766759238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5IhjDUP/NczS+J8Ok9NbT6xw9wH/Rgf3ojkCWKEhKc=;
        b=D9w7a8js81GtsDyi1k6AT+0KSiUs0Zqwj55ePEJb90feAOaohst1HGfqyMsqMsso5O
         N5NQqUfDVaRCCuPm3y7OEAMGfpoj/TrVZgPSq8ZwayltdjGg830jrX13ww02FBMuLlBF
         M7EeuWCu0TU0gwMOnn4FL9OLVMM197Kc7wEprrQ462gsbofjkOX5DiN9FI/WhXohMt+f
         nq8APzIT0KuXyuXBPlQj7ZhO+rk1MqIF0sqpF5a0X+EAoyPCrxXSPciv4Qbfp1OIUhtz
         quPX3r/uGR1nGMiAThDMvs9BXyj7/+dK9v2VFrbV1Tpewg20WxtkdFLDIQhvCPhlBAbw
         luIQ==
X-Gm-Message-State: AOJu0YyYRq6T7D9pq82lSP0lhUQPnnhn2MGND+QkD2dtNiivn4CJMMqQ
	J8jtO0WKckRVC2qWuiL6b/dga5bd95fCTnNxZB9ViDLas/ozXZRullGTHyWsOt9q2u4=
X-Gm-Gg: AY/fxX5knejzJdvh5R8RZGP7pTzKYoETwsD/P98gFSIKo2KuEeIQeAmDHRwUBGw2DUI
	KiO6AoILuC9EzHWFIHfI4+nYmvJRCuSluXE6jWko1dhat5kU+wduB4WGQWQQO4XDMzjJoEdxNrL
	E2AAmdjdqEbiPZJFnbvEOj8FZk+TjittBMpfFS/oPquMfS8sg6zzyzPYU5SDY57RQTHEwzwjIPQ
	0UncXSlyjwNZY1w6YW7tTWLUyq75rs+ZV/6c226OsSU75V9f0YGz90FoksvsPSg95VPI4P0mMbV
	xwpzgfYPDMc0Kcgznic7dayZDqC4ZJVXxk98UN0cAVsN3q3u2rW8TNRk9DCaLWOWrhxS9hQgbeH
	14bgedQD+ZnAlzgcwXK25Pts+sVwa8Zw8Mdugxy8A5qjEVZsWFHCwyXRd4AShlohz6yWw0Rnag4
	afksbVHc+s8gqlLEtE/sSswXD2AAVLu9JmxJOMnk+q+8ELvW4fJYXryK2YGFNqt/3IjRCUHw==
X-Google-Smtp-Source: AGHT+IGBIKHJ5spcgh/qjVrTK4bS+iVhwL7ifjF3JY46vvR0Acnl2S82zGRYZj6g/6YfbIpf102MhQ==
X-Received: by 2002:a05:6214:2c02:b0:880:4ac3:fbde with SMTP id 6a1803df08f44-88d86869862mr54299226d6.46.1766154438159;
        Fri, 19 Dec 2025 06:27:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c096a8c758sm193246585a.24.2025.12.19.06.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 06:27:17 -0800 (PST)
Date: Fri, 19 Dec 2025 09:26:40 -0500
From: Gregory Price <gourry@gourry.net>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219000800.tnpqzvcdyeqcwryt@master>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AD5E8000F
X-Stat-Signature: 9a56ken6k7c87utm9a6m38nfswanwodn
X-HE-Tag: 1766154439-463073
X-HE-Meta: U2FsdGVkX1+YwUSO8tD3pWTXA9av1295PdAwfbKdFgnuTyk0CeVyQPpP9xDLqz/bGsON0b/ni5P2sPlKIecojlBRDiO1QfZlRQNT9z2GFOZbvHbw8IAgTsUfUUmEoJiyFjBRFqyYFzQF7tEUNmx1HbtJOvZr69R5+L8p2mf3UNDSSAkwD+ahOY8GpcHCy5YnpxjsrSF9xzMl7Erk26PJDTCF+CERYhiPdueq1ZZpdEhZZtvr89XVMR7VHU/+WLnLpy60sbUdtOPDAVeMIlD2PuWsfcVNoWFBd6WToCy7YPXMGiDVmHl1GIdAP1BDD7Q1cVqE1a0KwJiuKaAiSPhiQioFyc9y8xf2Ws2d6wZrI3y3i2G5hm1RJl6gwWoyHZWF9kJdSA0OMc6vQLvhHWR5srQKJ8Cw6aS6ZxMh7cmLab+eXNh0EiZOCKxaRXte/HNOy7x60mX3rOUh/gp9iPZh2cAtLWUci/x0b20J4r0uPT4YG0or2xzvp2svO3O2b7OuiXStxLwgvOcxHLXJw9tLwGvR1iIi63HGI7oU8wFbdZDZscxJJZQKPpHtQuMYyRaGj0BLHhpyi2v8MIXKaz8DvQXGMsbOkUckmyy2imVoD4uHBcA6DSpFWu1XlebuNpPeQcWeO89ZSX27s4yp8ZpOoUgmZhA3eOQp/Tybi7tHoWk4FC6WYEvLYpNmHDeOALtuh0mryq0bhXQ5b2B5f0MfKuQ9ch0CMvw3IPKzTmeHf7Jitsfcn+FQsiMzrhE28tb+PlswlDYN4pXmGCMRgFm20fen0PA4fEfrHizfygpo9J8XwqXDmo+XOl6UDEjQQf0o/rzEPuNuvUZv5KkKDpvNUXfNB6PCcM6gpR0sIGrFHFUGxTV6wznm6nUUCg4+EhWWJuI+XSahDFBV1Fxos8HjZ8/vnj6Wh+dPBldd7po01XHADT8HUPc+4DxVm0tsMu9BA/PCHTKkakpAEc41Z5j
 INCnb1KH
 baA1OXzHL5nmW2Yf5T8GIs92n8BjipHks6snjnMRsYPs7UZths5FXMCxA8E7UAfiYJLrsaKCgrPliJ7T2qF0Cgo0RkW+jlaFosZ8+rxCQ5LoTK4GBNAiKwvTQh00sAswstFxkUWCo1Vf4LkDGq4s5XIp4Zgotc7TqxoXPiTmzHfCgVdUimd2ypAmff9d7Km1/JnZqLfSHOd7dfVZrOoIbN492LK4phNIjETpqtfkT9pw/kZr8dXuG10QHdbw3C3VH3t0dvwLezwyiS5dmkeTgsezPwwuu4YMGVCeSxrPQrU7HPTHKxBmY5fCzRCFmwnA+fLZChXJPY5G+ljvompQfE24d8kZY3PPa9dMEHMfJDRUL4Zkae4l/lghAp6ak8E6rmAw8ByUG5dGXAQc0q40qAoz9lNxrgCTQN6XgfugyKuJbICbKVWSOOlV/f7z4GHs65hFT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 12:08:00AM +0000, Wei Yang wrote:
> >+
> >+			page = compound_head(page);
> >+			order = compound_order(page);
> 
> The order is get from head page.
> 
> >+			if ((order >= MAX_FOLIO_ORDER) ||
> >+			    (nr_pages <= (1 << order)))
> >+				return false;
> >+
> >+			/* No need to check the pfns for this page */
> >+			i += (1 << order) - 1;
> 
> So this advance should based on "head page" instead of original page, right?
>

hm, I think the thought here was that since we're moving forward from
start of an aligned chunk, we'd never hit a non-head page - but this
may not be true.  

Will think about this for a bit.

~Gregory

