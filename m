Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46002CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FAE90017F; Thu, 14 Aug 2025 10:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3764900172; Thu, 14 Aug 2025 10:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63AF90017F; Thu, 14 Aug 2025 10:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1DD900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:15:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51C89C06AF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:15:18 +0000 (UTC)
X-FDA: 83775560316.03.270C57D
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 35B388000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:15:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=NmvqVtt3;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755180916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BUQkPCyVmoncxak/Y7aRi7IQhlbH4GfyrdWoO6ES88=;
	b=YZQZF4l6ylAYLqgnTJOf1iL/1e9H+48IkvemEbp4rAddWvH+VSXQKfZf32Wq7dQ4vF893q
	pZQfpjIkn9d/XGcRl523UpUrupLk8R5svHDa/+LmAwWPpPm6q44NewiK4o9Wg9wCWv080i
	58XadzIsKa8UYOAa/ko0mvifHru9RKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755180916; a=rsa-sha256;
	cv=none;
	b=pAOKmIOaQPsjJSXi5jb9TiaPJ/QeViXU+wIptjH/YYJ0d3vufCyCD9HfuYPrngTFziSXao
	lLrZn943iVm/3ppPwXR5NLP44RcD0qVAgOk5M3+tWSyf8TIZDKm6qBEOzuh+ecamguvByd
	rwMJvCYbSFUkAs2jOIlFTcgIeUDlLI8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=NmvqVtt3;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b109c482c8so17783121cf.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755180915; x=1755785715; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BUQkPCyVmoncxak/Y7aRi7IQhlbH4GfyrdWoO6ES88=;
        b=NmvqVtt3AUJDcctZKsaCqXbTY2fFOnv12VGR01jIpLpx+CEbbEPmpkfrb1RoKgbYaI
         iILJ0TNAXhNzNHNKEs99iezHf726DfSl3Ifc1c2H3YGRpLvc7uuPXsmpsfZIWg6ItIj/
         WLAdC3FnmW8H9PIVpefAUVtUMvX/U596djVWebYQSFSxDttLzpc4OHiYlFD/hfMyPcTn
         weeRdeKwuL5slqOF9H+I+TdZf6NA86Ypii3gqwbHMaRUVSXiYlmWfwiZcZ+cZ3+56UF4
         Pfk3eAV8wTAxjg8VJUnfzYwkLBDYJdBb979pMe7M+ZdGjH1mbxWo8NG6iNpU3ofi7QNE
         I87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755180915; x=1755785715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BUQkPCyVmoncxak/Y7aRi7IQhlbH4GfyrdWoO6ES88=;
        b=Cpoy2mHoe0bkFcJMZc3cbJUX0brsudIVyi8pB/eNsksIjSOSNu9JNuivdXKL9eB7x/
         CVQR/BPhnZA38Mq5bRyb/JQMtTgn+rvzE8MVTUzrvsQ+LZvK8+8/z86uJsgLmdYjmF/A
         gktb8h/ej27Yb3UIHBuCMqPjYddUVhA0iEq3QlIV8QvA+HTkAel939PMbNXQ3vkyAwbb
         PElg4xFNPFcUEdQqPgy2ER27tHRhM/Da2PoKuKl6PAFJ0aiOrVyM0XfHS1oAQfae2x9G
         fSAAjQDb8oTcn4k070jGCHk7B4nbrnqbUGpMHx/Plhd2MMKo78g/c3bMgYmlTkx5aKTn
         7mzw==
X-Forwarded-Encrypted: i=1; AJvYcCWSd4vgC18P+vxgPd3b3AohRYq8iqLQzWvvIDTo2U1T2U+Zey85O6ZzIhuSFFZQS6aEQmcSJSUZPA==@kvack.org
X-Gm-Message-State: AOJu0Yy+YV3vIbd5nkPW5yFHFBaOOoaT2IeYxhVMHErzNSkiFYArsDQN
	gPyx62NKfS46K019Gf0yNptTanedEOoGGqHlwyC7TjJ4IZ2m2DcYQqIqD428iwWtDEE=
X-Gm-Gg: ASbGnct4kK1ZFOaqtsh82JKw3Lp1WpzrfVhd7MpaADsIuL2Lj8c5m/Yz68VfzEooocy
	tKs/n9pVzZM5FydV1vhpuzw8R0jalO3lT8p75NbNA7pj4pl6K/7MALvxI3LRobhQShHZHB0XAPS
	S6GA60QrJPpx9LKpKR87C8QpW/LUGKqSXs9GL9BDymXCGUMXXm742SFNzQaf7esHiz5dRVk1ck3
	0bO52dQlavvbELXf0iKWXsB5lyqrgJm4pQ97Mfuo5XcRK6G3JTlACdDlM7lM1wAuWwwD6R16Dth
	zL+xbKmBBmLsTdW5YK5ArWozhVt9h9zR9a9FAhwi4O7N0ERwWL6Q84nTqI1ufT21+V3S0N4i+aD
	vlq/Y8W9qt2+SRmySfzvncLYaDVFZzijl
X-Google-Smtp-Source: AGHT+IF9dyhnIQhWpXCycIJ6xPTYoImLg+4fKfvhwrB8MgdBLjKixENuSwgcpdo7nZyGKshdy3C1yA==
X-Received: by 2002:a05:622a:1ccc:b0:4b1:dd3:e3a1 with SMTP id d75a77b69052e-4b10dd3ee68mr26844041cf.64.1755180914955;
        Thu, 14 Aug 2025 07:15:14 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b06a86735asm155735351cf.31.2025.08.14.07.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:15:14 -0700 (PDT)
Date: Thu, 14 Aug 2025 10:15:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/show_mem: Print totalreserve_pages in show_mem output
Message-ID: <20250814141513.GG115258@cmpxchg.org>
References: <20250814092622.24535-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814092622.24535-1-ye.liu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35B388000D
X-Stat-Signature: 7ds4nbrz47x11ycieqtit3b79eqhkdoj
X-HE-Tag: 1755180916-459067
X-HE-Meta: U2FsdGVkX1/lyO0cI8Z5tpXL/Ulk7Hl5uXhdqvhu6Nb0EKJlpJGeU1d7GE71kxgf0ofRxyp8w9iuWmpYHTbwNQT3J+5PbgiU0CIW6nOGHu+ORj5dGAPadNbeMMaiIt7avX+OGnSvnp9mV3NyMC1G54RUNgQC4kipd2DZsJLDtxD2S7+WJ9eeIKPyAMRd4Ih3o0Za9jaEm3a6b0IdSs/feM1PMt8e30byPkfM86wKRzoRCIYYdQu1Q2cMacr/M8pG1Idz9ygNCMljSSInoL37EpmLh0r521Tknbs/+4RAr8D2j+95QCnxf09vM7hlDZ23A0lDIqz1a+KtnALQ6g0fEddwMfxEK5kCg9OYJ2VMgBPt1Kph2JRiw7fsZMV+ga+5NzAoXn33YVJ5EVFJhGSPCnE3KOaKxA5TsATWhSjT4pb6awjuWI9GGPZFuk+5WSZutYU9MGJyBYsi9rq90HMznn/sAMLYUmxJFr1yloHmVjAzhXZu6uegNAhYUwwkc5DPJiweEyQ0iA6N08GQdzIqviJSZ2jRYcMmaybDPSj75ajbM+GNieNHgTPWaPr4iHmdyC2rUpZVmR3JwsSOBgDQNNmcicMS4e/1JQ/bjsJqI0GvE74BtUSe8+1MxEfC9CbqRZPlOpLZrSJzmcdWrLGMCoQ7VoKI6MfEHMZziczRbftAH67+Q9nuDb4N0KRJnO3FhVoHtgnkV1Pi1QZsEYZq+6IN9r/UJRAiVxnXKpcX9NWjwN+0lxBayDxXwI22GCO4UPFWdrGd9U9zq4/YFJWcWRQeBoF/8dcZEFRgBL24LXo1s4UVwVkTOi+BxSdXSamwrge3wxeBSCX83CMOMLcvIsiKYzYJoe3YECRVwDGE4DPOSx9Su2HeIEkkTCP1YouhbIEXoRX8BmUTrUx+lDfCloNlka62mX0htdJckHnbETZVZpSzVHbiAh+1ukPZe28BuXstXQIiZT0kPzcQqPk
 hsg/yeat
 1YXfX0YgYOthkwDlruT22kTWvG5Rh9o2TNU3g8QvZK7UC9UUNzFb2DSotWDhbysI9rFLyOdG6xm9x6idPN3TJ4/0OmQVJNO8mMfoYU9jKfUyi3EV4wIMawYxeBbWT3YXFBOTcxbEilwc8HmQWmzXwwwu91cTlNgwwJjsHvSeI6oJ6YiaATaaHxnU/CabQr+Y/i5bCWIt19EyNHmiBc0LjMOVYDRQ0CncAhqzY4Ysk9qIrSDfa4OflsACLBKOe16UrqItcpnvU+4TPo/z4NWqZ5apWE24R3BrzExmIuyhqwD7URw1A6XkINs83pJipeM3AnQp/czoJp2LQJDQPtDACMSx/KMDft7m+64XrGOu16LoExvxqswQxfaEN4Vixg591L8x3mmV4zaKAGaR3qAi7zoEUZpGOYR0RoEHV6iNX2wNatWfU48lKsJwfgwzxEdqtUPcq3bmGXdssK19FNKic1fRxxN4JCFxT36Y8OpXYVvSUhi6CdicCJamNGDKQJRUJb9eEDk6sT+8XhYNlpvVErIpb42+g+6O3X1ioAj3J0TFdvxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 05:26:21PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Add totalreserve_pages to the main show_mem output line for easier
> debugging and memory analysis. This helps developers and
> administrators quickly see how many pages are reserved by the kernel
> and not available for user allocations.

This number isn't used very widely in decision making.

For actual allocations, what matters is watermarks, lowmem_reserve,
highatomic, and cma pages - all of which are already printed out on a
per-zone basis in show_mem().

