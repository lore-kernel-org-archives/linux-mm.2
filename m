Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA83CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D914B6B0092; Wed,  7 Oct 2026 06:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68006B0093; Wed,  7 Oct 2026 06:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E616B0096; Wed,  7 Oct 2026 06:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A15FA6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:34:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E38D4018B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:34:09 +0000 (UTC)
X-FDA: 85295470218.07.C83E2F5
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4550C1C0009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:34:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=CAt5wCji;
	spf=pass (imf18.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791369247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/KXhGwdziWuRf/43cGrmsybatU402LAkrsoiMqhVuw=;
	b=VWG8so0ekcq/WDwYrHD+UqN3wZ5uX11anYlbvbyfrJJUXylIDoN75QrhPe7heTUSKTcVcN
	pjBf1VlurJXvnEenVXdTmfvWJfAvKnC1XH6Gk1HjaQSEmLGhHVZ6N1u1fCrPNNLAXedYJd
	aohxkc67II1tuDqf6OZkbC6gbVn78tE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791369247;
	b=LdRpv1s8DeGcc1gML+qi0lcW+W7gasZusFe4wvcwRIjwQoo319L1x8BHUKZWOm5amSHudX
	4EewcCgvgbpstDunOhduoMIX2xcp7EWE/FgZIlXuJPhL0l416Dqp5ABbvejqvpcZ4n+cTZ
	Ek8QL8PmHUoPIUpa1rsKA2khV0wd7EI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=CAt5wCji;
	spf=pass (imf18.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso20343955e9.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1791369246; x=1791974046; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/KXhGwdziWuRf/43cGrmsybatU402LAkrsoiMqhVuw=;
        b=CAt5wCji2UWG2PUXLqzIyd0O1mK+qgmMjLfBbf2ohpk/s8HYVSF0XKb6Zf5VWsgjE5
         LUjrh7Cl32Gkr51V0TF7IVhh28E/p6mX833uWQZpzTiXJ8mtw87wo162YfAXczbFItNE
         JyWVKaCB1LmlISm7QQdhUWjCZf5T2yqIMc3hOMy7s6aLwDQp9I75ueWV9DqrrVpyu8nA
         DXIiK74K6TBX0G050riaAS+TWc0+ZcSZ4Fst24N+9keYD/7LW843Dwn6XIYDrMSU71wM
         AI/W5bpkSrZsnVUWIY8Id3YYZ0BkJI92DFOFIl4TgDa8n4XTtzU8jxKwouFGyf6ghfIJ
         Ki5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791369246; x=1791974046;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/KXhGwdziWuRf/43cGrmsybatU402LAkrsoiMqhVuw=;
        b=f5bvZM4VVrYRX5COmanAkZS0eaUGQMykhkJnNA+6LrKLNoTTeZyka9ltSoWAZpSpmK
         HrgLOqNDMN+3o25Iedwi3y1t7fNQiSZj8u0GbEOzxQOpQ5p1ERKpudYiswfeVK0iGFAv
         r2Ptn1Edfv70T/vdSHQP+xYGOSZK6aXNQiL+9XSdoLGV4HDyb1Ee9sH6Bv5h2wgef/Wf
         V7MUh/4I9kNRi25S6YvhiraFhMZKNOPIzWw5tjYu6wG3wefM0lowVra9ZrYPc5wgsiDX
         vJbfOf8LpIB4kkNqLM8+3vAuvIbNVdNoaqvRrjr94UbbqXvUdR9TwJ2VUEduwZ5uIvqu
         G6kA==
X-Forwarded-Encrypted: i=1; AKwUvBxzA9ZwLML0ZhASmgh6whhCWHsn47J9FQ8vL4Ae40UrweIOCOMa+FpCDEDBKLLIYs6AfGCk27lUGQ==@kvack.org
X-Gm-Message-State: AFuF++lgOkLBxHnlkd0v136njk7JEt4AecWifLG0VUz8X0rQfuMM09nM
	nmEGNxmyzQRLbhMn8gpi2faXbHxUxn/ajbC4WGnRl2ZeRDfj8sxahWj7ARLSx5ItJV4=
X-Gm-Gg: AYBFou2ClUKyEny9GhPn0ROqqBH7Ufro0W4Pb5nt7swdAsihPAtlWzgJ+OxxDoNh4xV
	ZdnZXLEFCvNSvitAiAzVfdo6pltKLUUY+aGo2qASrJvtMeeWVmj0JEfDmQACr/yqwAqQ6ieKhJo
	CfkyRJ73Eol3rvtv+BRYg99KFrDdRe0G5vjAHPVJe2jVpkLAygoFOGtFiZ7eIaOGftAWeysl/9y
	JMTd5zBvlqkWXY7i9Bp7weOoFgLXBqHUF/BpKv+SpxW3XFkOEzkpK9UgOr7KR6Dqs92Z1BbPP9b
	kBYDz/TAqk3dEDt25HxJuqe/wEO+So/oNoazcUXSS+G0y7eY5gZpDXknx0pPvldQWClB77T65bd
	G25hVkKwrDm60qD7wyMrhf+ZYiwm7xINl67Sr9kNR5JvWoAKibkPhOZ6iXUjSvu/oTlAZkoPW7D
	9lPRcsXWkEmQ+q97llXV6Ls5bY1Q9FwFZqIGyAtbf4RfWpcodmpAiLO5+Npdo=
X-Received: by 2002:a05:600c:820f:b0:4a1:7367:5395 with SMTP id 5b1f17b1804b1-4a1802dc754mr27490115e9.2.1791369245576;
        Wed, 07 Oct 2026 03:34:05 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:26d2::3de:3a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178c53997sm204620105e9.12.2026.10.07.03.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 03:34:05 -0700 (PDT)
Date: Wed, 7 Oct 2026 11:34:04 +0100
From: Matt Fleming <mfleming@cloudflare.com>
To: Marco Elver <elver@google.com>, Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 00/11] stackdepot: reduce memory use for
 persistent stack records with a trie
Message-ID: <asYc-sRxG6kyu5yh@matt-Precision-5490>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4550C1C0009
X-Stat-Signature: o8gkdn33gz75fah4ontxgt3qs4hq7g9c
X-HE-Tag: 1791369247-604884
X-HE-Meta: U2FsdGVkX1+Jq/EXQ5JQMtdw74DRCb5Be59YsIkk1ljLRwJYDE+wwDaYEl5NHo/JMwTthB8nC2W8UjUJ41C7zUaG8wublIDYzXi8HWbHrbETTgRazrSSmjTxMPmmH2du5/mXgoX1IbS+muU0br9ZGB2ohBCSGa8vN7EgfFb81cShBQhrB7AhjWtKy3xt9XMEwZbxKWqio67jYO6VnwmX7QRlJzHKZ4ooLl2STNz7uhIPJqGN6p1QMc/DUGMCR19T7kZra6GNaeOv3MrftzGcwzU7Jr/QsUUQboItpzjg+mSxWRsC0J63+OXybxHhyGEQCppL6qRTZt/JjKq8oPjoKbpiFQRAU0R1Fhjj/ePvMW4y7gM81md5+fL9tyyMBKufnnxmBXx91fcTRlsPnxMm61ZlD00okCsE9mDbZberVw2Cv66LWoAyYpCrpEsm+m+Gp1HZivX+tCklxo8tUf8mS/gddw+EVZukdxKN4boC4tKQtZkdzZAkzmQ5bOrV/SlvB8YT7cIlBS+0TE5Z+8U1LD8fnmw8G+WVFHwyuGTL5yeN1h0FlvQWk3SXVO9OF9jBtakhe3UMDHShWFLLMe7obTyAlHl01fLeZywpCQUjjoHk4dEbPehnN+Ib0hJ2p2wCBhMJdzKNZ/PspQM4ya8ZcX4zWZ2KsumFrs8gSYf8+g0jGR2pgWrHDPTYMVIbDD6GIXIrsSWLonnq5Iykui2lUGcq0L7C0XNJjyCmf1vomf0XSYDdBgsqIovuD4A6l78vkzqWAwmmxrX1nuXb951HKuX63VXyZsqY1uSqMRJzUpdwBUeJFeO9uQQGEGrAv4O1hFDFcQlQWmO4H+KGL5ly19YpyWhtsKFF+DHm1JMt6W00htpK3SkBXiXuMSup/w3ey0PhIKqhdkthJ4qGUcgWuqTjnT4PogHWDap127oupL28CkRRWWjficzhoJI8ilfk0wngq18xbZAYG98rmqo
 t3SKp8rC
 5CQSQKn48pA+WAlRBfhAjSltHWWu2VCu+K1P6qLdnOjsjFHz3JNFgxSxQYS2ApWki7SKzXwf0czw1e91jsAkI3hiQYbHmySPM5vwbGGb1yaeuIlxTEWIyqTBHbAZs0VFxORzJWyfcEQrgHYcP1826ppudFDvjUMK9VxYuC6lZuKe+JFtTguOSyqGbRDs5pBmI0iDLvI3L5EheWI9gblyahLNSQBirLLfHv6d9NGDO5wHD65kgTNHyimVz5/yhn74wrTLPxok8q6otIOlbUJSsfrrwwauzpNJipZhW122LN8mb9CjokFi3QVTLytN6GfgSJyIfv1fwuib8phBiCQUK4nVfEalYpAw+9y9czuUuE4kjEUsDa7e2KdNX48UfEQhDtsYzgLprLk+J5N8pT73/Pe7JfPbSdLhgGxMI4CzWt5YQDsEyMw0w3k8xNay/WjXpfJVYhgAb0f03dOe8lUY4jypc+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:13:33PM +0100, Caleb Kan wrote:
> Hi,
> 
> This series reduces the memory used by persistent stack depot records by
> sharing common frame prefixes in a path-compressed trie.
> 
> Cloudflare runs KASAN on pre-production servers so allocation and free
> stack traces are available when diagnosing memory-safety bugs. On some of
> these servers, stack depot exhausted its pool budget even after we raised
> stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
> persistent trace returns no handle and a later KASAN report can lose the
> history needed to explain the bug.
> 
> With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
> Doubling the limit again would allow 1 GiB, but it would not change the
> linear growth: the hash backend shares identical complete traces, while
> two traces that differ by one frame are still stored independently.
> 
> The trie is opt-in and disabled by default.

Hey Marco,

Do you have any more feedback on this series? Particularly the bug fix
in patch 1?

Thanks,
Matt

