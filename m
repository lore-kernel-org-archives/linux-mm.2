Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B827CC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF576B0092; Tue,  8 Sep 2026 00:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80796B0093; Tue,  8 Sep 2026 00:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E6A6B0095; Tue,  8 Sep 2026 00:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9360C6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:11:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3820016035E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:11:26 +0000 (UTC)
X-FDA: 85189270572.24.4EBF4B8
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6390020002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:11:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E0OmA1yd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788840684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3IBDytwN2H/xXV0TEBFachD5Go/E9+5M3oIjuDOU/c=;
	b=qQjc1rf4USfoBXVhCGcklneNRPgq/KmgAyDXZfyPqRS2MYMKSpYtPvViCoJYHJr0MpAh05
	olsOLA6PWkqq4NXpZlbL76cQi+lxIIRrfPYIA6REKa7n4sMIzzNmdu3xegFcBOQiSGf4lh
	dFrkGKltzmLBVnBXTQabH8HBhyTBJBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788840684;
	b=pqo6hvNlGnoHgHTxmihCM3qIMZWb5bwddyJDTVMeIMWUn6X+W/mBnWcrEq8+rESxJ31Wj0
	HA4iYZbf9221x+sJMU32JdH1T9AwzuK+sW/g9dwpQpytteME+StHsKuUwFP7md0AcNAHN8
	/UZ8k4fbKHHXhTCseXMRIlvEI+chOOs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E0OmA1yd;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-382ef647e20so4220644a91.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 21:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1788840683; x=1789445483; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k3IBDytwN2H/xXV0TEBFachD5Go/E9+5M3oIjuDOU/c=;
        b=E0OmA1yd1oVMUZ3N9cNmItLwJTux1yKEsntqscbBvilU5/Q/kalA45H2hKgBeut5B+
         Mg64WPaVSAnwP34QOOWcLtRPxt98PPsvU/BnygsAEPpOCHmQMKG3ZszjT6uw52iTQXty
         3oPpXDfu69j42d4bxFf0mZsUMfdIAIus2CWsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788840683; x=1789445483;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k3IBDytwN2H/xXV0TEBFachD5Go/E9+5M3oIjuDOU/c=;
        b=P2SQdM9bRAldWMBPamjIBqxuoPRfXIiYB11iVdPZSDTPCHspLmxTlQ48w7lwJzt8U8
         E2J9hpKzJ5kBIP/O/DSubNprMyozEly4pa/zxvEJGCBMkFpUOJfVpMpIsVIMAUqVNnbi
         rdGQd/83JjxZnVx8zthQ4xrMpdejHIDUWXl5Lycy1tFvmyWB9q1btH6e3ZPjD1DrL4nW
         9PRbYfyoqkcmVrJdlHf71wC+fk4Tg6Mhrr/o38117nKXoMV8+vvc546Dnlzl1Vqwta5r
         850R2BDgOkt8Iaqe2P5b55IjIvgXwPZNU282PBhB6qZB6wAUjvT67i7/stVFg3OU3Ubu
         NxnA==
X-Forwarded-Encrypted: i=1; AKwUvBy573fqmV2I6o7Eait43+x5FoiwWrsrw3nNhji7HiFHVpmvxhlPbb9kEG3Acl7Mk94nQueXJJRLcg==@kvack.org
X-Gm-Message-State: AFuF++n7+ePSpmhrOLXWB58z0qz9KXvx6MzsZPQ/8Amt73M7FuPSikqJ
	Vqt2mDDcZcEFIO853k5Nii0/qI70v4gl4MVKieezSC/bmMpQwduHuHPCjfovMmQ0pQ==
X-Gm-Gg: AYBFou2xYYIX3Np8P/BHqKM67xTTdpA5XBkGbjEhRSIPpBAqEcGtXItfAOaHMpIYDgM
	N3eSBlMF5P1ZvqtHvsm5I9Z0nR0Iy8So4u65U3hLY8SvNQzZuZV8BwBFcpl1AJiJn8bDYxzQIQh
	FYlNeHzf1kMnKSINkbxzPuO6ECRB1a5aJbkGfSc+1DfFkOVu8E9U0Olui+PPEGKe8WziEydi3Yu
	HaYXv3ZpsKxyY0K2ZouVlXIPU5wYbqdVvyz6EUJwzMJD5ND08f+/DzGNDpV9MFPb0O6OIu33R1y
	fyHNtp0OQWhaPF5RBjzba9ydtCbjnR6LOT7nqpFv2VP4aXCLbHRopRMumOfH/mD5v1gMpHpIC8d
	AiC791jOgDN2D7PrvmyUC3FxL6YsEgLSS2x2/Rn0MOkpt8G3TFqdpEwGNx8JIxbQFN4Vtt0Hg61
	sSocm2e+hSTdQLjTqxyAdSzwU/JT98BPm9kYGjmWsCmLsJuOAsCjlzWKSUF7jTioHUTsmeSbKka
	3XcC7/B9ZGzx7tDEizn6uXtCCZ2
X-Received: by 2002:a17:90b:5905:b0:398:9bd5:490b with SMTP id 98e67ed59e1d1-39b262133ccmr39121529a91.18.1788840682937;
        Mon, 07 Sep 2026 21:11:22 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:56ed:100b:a906:b2eb])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b3312f9a8sm21325570a91.2.2026.09.07.21.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 21:11:22 -0700 (PDT)
Date: Tue, 8 Sep 2026 13:11:16 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v3 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Message-ID: <ap-Kx9qjJX2ElrSw@google.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-1-6ae22f9d9272@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-remove-pg_private-v3-1-6ae22f9d9272@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6390020002
X-Stat-Signature: s3ocn8b86y74rpdfkeu1roeo3s3oyw46
X-Rspam-User: 
X-HE-Tag: 1788840684-363906
X-HE-Meta: U2FsdGVkX1/NKn8EyRLKMeHAAhvYJ/7ajj/Zkig9IhJ7wF6yfZk+HvX21NSxosIq3x39EyaoTbewU6p8CnM1YUERM7tI9ee2FjWETmOgwl/L7N751QgxhhfvdjyzAVvIhvyEjcxTi0ZEGLUUIUfWhB1Tb7VnPadkHgqNXxxD12eslPTSe4JLJ0QId3v1r9oG4EDP/zssSsMadZ86Ox7otelgb7Zkp0tEKzFo0xk6mXV1G9NR28Uv9uMzzIkWnTHr8se5l8iblvZUWlFkVuDur8HM3IFQPAg0xMdq7x43rw+Tdf6n2SmKcSJ703smc8QZ+JnYg8p/nRpaeA/tEwRovK2BP4B5c3e9P/ju6QUf+hQ4zDHVsEfVIjCgcYcxy6MzlqpvkAK0tWSdazmNNxlAz1k2EhUaZ3vGkbLT/7ZiiLmpswV3t2N+jNLguk9kDtFZnhWznywpovZOsz0bmGy3Hl1KWygZjEZoC2Xf3UafQiI4/KsmUZU0JUMZxGkLIUTg691NgIJQ25RnT5iJXjWQDlLaFlxmIJ9omqsSdyVWOvj+E6H5u+hiWBNtReCqqpTJtlhd1ZRRdjfxnlNBmHSZ88xuTZSJBoqqqwm8o2kG8DNmcfTeeiet0aN0CLGhTZs/Qzez2IYNh1Bne3Y8JJjMJPCwvAOqawqWD96rn98tIBlBqyEadIr/1tAEWbdN4hWI8c2sAmCo4AhOBRP0kpCqJYIpMw/Y7UZi9oQAbnJl6SYgeEXDb9wktiTRA+0qONLY+OP46Y5v4ZArs/7g7hrAm3W7WlCdmt9u9Tr7rVkWv7mtkFrQaEL7Vx/Uv04QaNmN5PwTZy/8tqkaCW22yZ0Y+5bWWfGTxMHlxaUzJVaybij1xQwL4ZJtwLKxOZo9zCBAORjvFfICnNJfx0dAxxPFD07iqB+BrzU2iDwcBDNKXzCsFbaMwU+El+mIJ31/XwZuVftCasksF9k0NyW4/8Q
 QwxBNpRM
 fMVT91dYIfXxWUjVY63P6vZiFiVpTkNdwdk5pD4rT2k0V2Sw9cUClHxxRHrLB3DHXTK2gJZHwVBiynfO+rOBaGwopbjJTjEgy4jrU2NvBx3AxBhds+vQcgHncvJ4EsixWpRrFPuztlEMzbKKmGY7W+3Ru1v1Q15gPG+1QynM2msMV334HHMcePttkMNmGkl+GhyPmoVOmHHqrBcZsw8A/AUCojcQYXMEXDX3S9czu5VH+Z47fksXOO+prXlB/eAeJWFDVwvKrsk9d0E+50C2NMCIyDawzBp9hRBFHZAWr2yYNsISpREEhXPo1Y1k3LCF8hpNwS1jpDnj/NKytcX7a2M6sz13wnsy1tdBOjDFRMrQRI4kv9Om3C8fN4zrCTRN3pB1y0fJkJP0WzWpdTI02YPTCluOjNAYZZWM4akQM1QHgoBQSF52Je/sEPwySgetN/MMkPkdH1dF/ZidPZ+rJwAqNwnChWgOHIyQcwYcAVgMNoX08aZz83Qopixvs+O3S0QhZ9Jw/qmEdI3ojMI5cwPgommxu29JtKHzK0ogPiQdWe+SfNNKLdnTBK9C2HZIqGXS1/bee4cG9+nOvd3h9oaQGEREIEUEaG1995gm47U8HV64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/09/07 22:56), Zi Yan wrote:
> zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
> equivalent to check zpdesc == zspage->first_zpdesc. Replace
> is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().
> 
> For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
> replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
> requirement of a zspage chain, where all zpdescs point to the same zspage.
> 
> is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
> should be negligible. While at it, change VM_BUG_ON() to
> VM_WARN_ON_ONCE_PAGE().
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Minchan Kim <minchan@kernel.org>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

