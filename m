Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD0DCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B0A6B0032; Fri, 29 Aug 2025 18:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB776B0062; Fri, 29 Aug 2025 18:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEAC06B0089; Fri, 29 Aug 2025 18:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B79EF6B0032
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:55:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77096C0A2F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:55:35 +0000 (UTC)
X-FDA: 83831303430.18.5934792
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 92F9540008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:55:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BMuJa8SI;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756508133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrAJaMy7hduOMnREthROQoMMaESzxew/avDD/RyMjuI=;
	b=Xz1MNQzSjv0lrA5JpN4Uu+yZXS4VUTytcdqAu4xLRt9sMVvYDDMFV9P/UEQ7WxfQJUAVpG
	o6IuUsyZu5HTDgfRsiyMn68haXTyy0Qyts//FxOSpZODq4Aq6wpQ2e20RjWUGICWAV1bZB
	SnXBl8bjpuVHQDYYkadmJ8ofhfz/2Bw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BMuJa8SI;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756508133; a=rsa-sha256;
	cv=none;
	b=EtEu8M/V7yhISI+SI/4sm96GD4pQOajyWQlKbStExjfhq2Dxm4+yjSUTZArc71n/o6AfKt
	HwB3eO+anHq/EB/9/2hW2cUl4f/Oj4MjwDd77q5g7we2YZe7ceiPh5Jq9ym6M5h2rl91vV
	YcAADRIXgenJ2Qml0x8IZazuF23Kd+8=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32326793a85so2140928a91.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756508132; x=1757112932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lrAJaMy7hduOMnREthROQoMMaESzxew/avDD/RyMjuI=;
        b=BMuJa8SI9M1C+nZhCLwYtvlJ9//gAzXVswTofPSZMMSqOQlBnBIvetkxMEIa2E5rPo
         7cs4nYUFBsYT9n9KlGOAwvvXRKoChxdy78KXzodGhNc/ShU06VmYdoFIfkdxbq3z4cdy
         Z7qKVvNnfxLeD+xlb8XYMFAHiC+SfKw2OsloF+d1N1k5UfjTRssJtx1Bb3EBL6gmvR4f
         gLbEDoLwyr5xvDGf1VM5svK1RaqPWjwijpkIlKhrEl0DeYvnq7kePhsFRQTtEckuhUiM
         h1/ze9B1FU7xMYZnDFozqZPpuiwPsO0yoJb/3ZGjLw7W5BrEOydsRvYcwppOtie70KkL
         6APA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756508132; x=1757112932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrAJaMy7hduOMnREthROQoMMaESzxew/avDD/RyMjuI=;
        b=XWB+C4PxeUyHxvXdK240WbpMZ/ctxfAcKQBWWN+Vb0OsJsWOJPnVzcPf7WfF5yW709
         DdL6W2qHMXXLEeAgQko+1vn9GYzPWOFSHFt4XIdpGFaSnQJEw19aSCRuSZ32oV7VBKCq
         UkoPe1BBBcJ+iXSZUf9blbUSilADIxazOYJsLfbR2YOE8triafmXPiPgeJKmbUsxfdpe
         116Ce6F8WwpFiXYYeWRojqgx8O9JOFtaU6Hja3WtrJ1+3lXt6DhWZ43UjFDN2brDPnFE
         j69ScaaP3aSCqjOG73MhAJbQSvcYCJ8FdQc78xcBxAmoUbIFs2+r2EskVrZVakUZcQMV
         2a9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcxXCN43IS8OrYRCl+K23WUw5wc5sQi5dChXqh/YMt5ZYiI4lAwH/NO3zf7T8wdo0GhnP7S1zpCA==@kvack.org
X-Gm-Message-State: AOJu0YzI1ezVj4EcgDBOyXMXV2FNIx9sJmsDdfEhwJS78nynubv5ToqF
	q8UFu4NJyrxDuaGlfTgjSou0jpfAzu6yerSgBmMSiTNTnF+/7s2btrER
X-Gm-Gg: ASbGncusTusPnsi9+yqxQzlRlcBdOYMwI4VcfDR9Z427TvOd6vghBpNaf35tU5SGJ/S
	ucsS9aANbpB5ljf5mSpgH1YlWvRXuwe/+5d7Xw+hLJdlR913U31yZC0k2K+v6TdY8HboJunBdLq
	GrNuLfPNbwldG5dB5oP6DKNt6bD8XI2wtMMwnPWcqcXqHshSbg7VuQNcGMH7PM5FgxMkOrM5m3v
	rL4Rdkq0naSPoXkYVAw/uWvW0aPzUr3jGf13xnWDQ4z0IPM2CotNxquk505xToiwV1H8ri1lhTe
	G/tExvrQgaGV71chLoviRCxviWpFHJCEjS9/lHe+cn5Q+wUQxSEenQSFiLMV1lsqqlOl/AwjjWj
	wCuKOuQ/ok+SGXOIizaJqEHDba1+XkF64re9jzqXA12CeddKXCokKvvd5G/8bAkCc
X-Google-Smtp-Source: AGHT+IFrPKnFakJua/gvKlF1EyBAEQ1oDkAjCqkDWD0uLjDx3iCLSPNR3Qp/0MhK7vYieeKeFiT0lw==
X-Received: by 2002:a17:90b:48c3:b0:327:f216:4360 with SMTP id 98e67ed59e1d1-3281541434dmr400473a91.8.1756508132438;
        Fri, 29 Aug 2025 15:55:32 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fce1160sm9304701a91.22.2025.08.29.15.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 15:55:31 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:55:29 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 02/12] include/pagemap.h: add `const` to lots of pointer
 parameters
Message-ID: <aLIv4ad8iaZ9e10B@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-3-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-3-max.kellermann@ionos.com>
X-Stat-Signature: 5rauj45zzak15e9ksmfduc1tkrijuh1h
X-Rspam-User: 
X-Rspamd-Queue-Id: 92F9540008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756508133-767510
X-HE-Meta: U2FsdGVkX1+LUhvwVzI18MI6K+GzMOR+8yVqRM/mG3klnylTR/9/q/A96oHnOGmoi7oXsHUKXUskH8rgyILlHBzQWZVO7YfFqoZClP0cDzvcTzc36kxQgTUDX90Brf83CVGsCtbscdRoScvGYv5jpParUPzg7mboUIVhuRfwMs3U3AGvIX1NMp3HE1h5VGR7fGyMqo326IhPl6WGnSpF7jv3bX+ic/S4bwF07c+WYbRpoFIuH2y5ohIOmNIQDeWFfgaO42fAF/BvueA3MmGhOt/azwGFuBtVNGQsPmR4pJUF5fVHMPoPFSuVBLp6nh9g5iv6/cgOMAaocm/Yply2WFMbHw1SzdE4WGjgybs1n02jFzmayaS0h+6XcNuzkYhsRYlbRfia3wkFC2UJS75xhkLy5K51wOzACZkteTb4gy5SxohxuYtX0KI3JMF/BOtDdEboddfaYm+KZqVuH+8OAiQARA+KBut2ZQc2v+7cMF3QO+XEwJNQDcy3TUfP5HNvvua9vhR6vMm+qOScxLNncrEIfRPxGqB1Jz02kczIjk+KwRFmFSIxJab5Ra+f7LlToicOWnKvDrq0LW6iAxK6w9dEUinYaBgwn0HAusPnHMVRPiHYn9omT8upB/EkNpX9lFQ/7LRhMW2LH0/DeVKQIaa++pKpfMrg7dbFoak3raveXCqVSP6uIJCoR3CT+GSwZzrbkcEwIGWHETLavOocUQsQzVM9a7HbGDT+QwKxH1IP8sX+A83s+UcU49dz4YIFCL7HBxZV5cO7b4mb9J09p6EQ/Su9/tLLVz2CAZNrZpXvLwTlyCaGvYeigS7y188POmbaHJ8Z3jLh9bYkT9gLAqp/8nwWdmLKA+g0Sc0DNF6xvb0z28zsvLUak8iyfr9ELkOOed9S1CJrit6G/9WpgVPlBuWsinlsDDrD6EVVW1ogNc28WMeKYEKD+HswbPwRZgXn4pVlprCY8nnzSeA
 NIkDhz2M
 FZkbfwU0otMdOFQks36pOvnwT2p6wJr1SEBKWTewQok7/eIrjSOGsCeyUALGBqGqmw7yMqVfk5Ph0lxlN5P+pfMw+RITxLzWFDTRf9Pbgm8PyHAlm0OpgJ54Z4HF7FZ+ajI5v8tWwMN0dsMwguUDfABzvrW3EdGTNzIUyHC4gFEjcjuBF/RUeQGgGLb35Olbkuo+bJM4RNTGa2GbvzfTlh+WiE+mwBiQP6NMxKkdb8yV9TqQnULz2I3qhANaD4lytO9Zi6LmZ3BZ7yMfzDc7z6lc/vdWriNEyGjcvV64uN5Yz83fDc8VglDPrLwNIwTxh6hdyaoTbGIZ3dMjgvxTCl2WJe5jxU6D8GJs0AkvPzGhXuLYDYMQMSjdObFVKqqbuyA4SE7xMwfIRFhveKMNeXB4oJ+X4CG6xuIZuf2nwOEwC1aqqYM/IJmvSB5JRL+qlNxNnG5kaeqFk7r1MVjLefwBQQDjEMXfcyqFqe3VevUWlDbkSjR53NLtcoa+b8Plg1FCeKH6DYTFdP4q+3YWM3juNJ7KM4E9n14E8w3eWYm9EapbaAYYMqBpU3fIlAYUByVFW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:49PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com> 

