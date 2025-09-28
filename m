Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C29CAC5B0
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 01:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59DC8E0003; Sat, 27 Sep 2025 21:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A3D8E0001; Sat, 27 Sep 2025 21:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9208E0003; Sat, 27 Sep 2025 21:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6768E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 21:29:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43E0B440F8
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:29:47 +0000 (UTC)
X-FDA: 83936927214.04.593AD7A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FB7D180007
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:29:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUk51kTF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759022985; a=rsa-sha256;
	cv=none;
	b=rkyJYUFBRmNS/hbOfJadC+UT1AVJA3te7P2/r4WghpEwK0YA9w6tKqkpzWAcqxcNZuNp93
	FDqj+3ke4AZXCXm3Y6m9W091KhXWwWu6kabCOfAvDtyM1miOUln2PlVnMOveH83ke7r02D
	8caNwlZ7XvLYLs+F4PTvk7j7oByDJKQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nUk51kTF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759022985;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaaA7VF/d1dd6Y2aehhgBQqzOxirTeBTgDR7whafJPs=;
	b=OaO2n9GCPeoLT1jBuHg3SNNEM/Uyfs9puR+9IQS5MseibUvDSfwJYIkgCq4DnGQcGCv4u3
	IQmdtxkOEgHLfUyngrMOHnqOa9NzBb+/KPyNA01bmKN7jNUngk6EBb5pgrpAGRecXacPX0
	rOpyj5OQPs/qT08XwO3ozvmjxck62e8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6349e3578adso6421354a12.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 18:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759022984; x=1759627784; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qaaA7VF/d1dd6Y2aehhgBQqzOxirTeBTgDR7whafJPs=;
        b=nUk51kTF4PG9fHW8uC2y2SjTNsh9DTTqvgSZTwi8HrdQ5+ZDg4PV3VsgMjkCSYiLNP
         EroYaHnNEd+7CkJS5/mTFPP6ytOpqRNPy+s0foHPxfBEUXCadAazUlRqW3dOFGA7Zr1V
         n0VWJoY++IwHoGYUkYXUvOyG84Id0Bq4ooPDTUugwIUwtLVnt2TJTkgDUZk9cvfGTJER
         y2TIG+xDdtOUmMBQmG9DkvBpr5AXbF1wYBI7y/TuMABeNixNzDhNsla9QcdJC4BjmLc1
         +k6uEm0Ju+Y+/YbdCllQmS/uBGasLKp9D657bOGtzkK3zE4BO3tyEw2uo9wZh1vEMXPf
         xU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759022984; x=1759627784;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qaaA7VF/d1dd6Y2aehhgBQqzOxirTeBTgDR7whafJPs=;
        b=p0SSILVpO05lYh7bBzUAQYtPHwDB6IqjQLEap0eYdAZtS1EIYrWmC3nHZ3t49zvblD
         gA3o6zTv8fFlNPWVRu6HVxpr/j4Q66OI3CdgoqFH4HfTXZY7vVFnKAvwxvk8APH1Pl/e
         EelwstSb3X5PysN2F+mHDMRSdlLQY8PlFEulXzdekauUrYpYzin8Bjqf3S2jA3vxWqQ7
         okgSYbKLMqBZU7+39Ootmhexweav9JMiN5NBFKiOBII8VhJuw0lw4z8aJEamT1ZjdJVl
         WPhFEJ3a6KlnjXBvDq6BT7UV2UPveR9zaMd7YXgzULNEqbklsmA1eEsf4y9Jj4IjodQ7
         x4aA==
X-Gm-Message-State: AOJu0YxG2A4dAlnD2B8FDxZ2xREMnYM+H3S1qiUKfpAsx/f+lJ0tuFRH
	PYYGvAAtaRrMf9TizYV5hijEewW4GMNGqRUCrIiP9HG24qFOYVLn7wI7
X-Gm-Gg: ASbGnctHGNERcUYERbCMNEx8u3aej7K5/OfR9WbYT6OjafLMN9KJ4XJwfRC+ZOBD7RI
	sd0EusjfZZiL+znka/ZBmXBUXXRfTSiH3MigVOEt0hz/QfNmY1se3ZZKXVx9UiSUqkI/KExzdMB
	QFfosS/TibRubbzoVSA4qmThhI7RZEt/3ELA9zx4tEeA539G5CTfjhD0zVIBnC3h3qHEiOL/5+X
	7Z2LtCaj6QAvh8aOFfJnFwAf7w2rH6Qu7oOLdniSylrdjqnpalyV3PlqXWTM+g69Hu5R9Fsd9Ja
	wdUPx26Mgyaio0PsVWGSqYtwmaFYNa8eGRgUHYG21lR7iQ8jXwWggE+4mnNIkEU+7KAQEW5HDiS
	obO2jpdIff+OwE/x93rIrwl8r3Q==
X-Google-Smtp-Source: AGHT+IH8PMCyGq17Grbmlu3IHSZf8Q6pFvykXtFEHcjxN4vNb3KgLD91h4nEUAxKcQcxVpCFfsUfRw==
X-Received: by 2002:a05:6402:44c3:b0:62f:ce89:606f with SMTP id 4fb4d7f45d1cf-6349f9ef17cmr9469195a12.12.1759022983448;
        Sat, 27 Sep 2025 18:29:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634bf4a5351sm3206980a12.43.2025.09.27.18.29.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 27 Sep 2025 18:29:42 -0700 (PDT)
Date: Sun, 28 Sep 2025 01:29:41 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "jianyun.gao" <jianyungao89@gmail.com>
Cc: linux-mm@kvack.org, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"open list:DATA ACCESS MONITOR" <damon@lists.linux.dev>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KMSAN" <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] mm: Fix some typos in mm module
Message-ID: <20250928012941.wildyant57igw7zi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250927080635.1502997-1-jianyungao89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250927080635.1502997-1-jianyungao89@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FB7D180007
X-Stat-Signature: wqgsbdkdtqwer7guxuouqftssgur57ta
X-Rspam-User: 
X-HE-Tag: 1759022985-617542
X-HE-Meta: U2FsdGVkX1/hyoxtEKRUBw61euqVJ61bwJydUGwJQ8y1bmyDKxhnypFj+ok5LbzZtzmVqR05/xXGe6A6LsT3zq9/3IxCPEoONk0tBBoHlg4t2KkqNaA0+pZ6lO66MSKEucUwAobVPuqjzIXdhwqiDGw1zw0StVn73OSmnSjmLxXZAy7YuJBAuGpgxOrciHEjs/0KbKZqIpqhvBTs2EhCQ32Wb2P9pcqBpIj37/sm5/wWoxonRhe6eyMcjsQ5DRFrV83BrbRTGUXpoxeLq/CQ1HTTGKmS2qqc0XK75yVIFu+Q6GDYbl7Q8Ob3jk0bvAmIvDgA4c9+9Fmpokyu+wu3xYrjNNuH4hPPOsuflLATTjvGfd4TswF3lFBAGkybeSE2yV7SzwQLike/YxvJQdnaT80JVv5Sae+L7LQKzzGaE/Rcss4J/nQu1T0dQoHKnn/qkK97u1Pbsq+7hzqePdYKHhlLbH8X+aG2HtFGwXZ1U4uSZI5xz0Qwa//CPFf2cEI2g0SjmN3BUR6Iwe2obfXGt55eUoIiVuAlz8vjGwIbtzEX95zWlFZGIzyW5N4wakzCmPOZq7xrf0Xvz9os321WPZH5S4/HeqEULg5M4k0n1r9W0fF4jl4mliMOMo/ggpDlV1ex/r9+S+dMBRNtLKHisRR3qqV5eHsw7l1ighQbTWZxf9GHvBA19Bm1vHAn4BJ0Or8GoaBQ2Vwx0ytQIYivmLWwOS86eU1oRknwOmhxmqG2MMlt0xJ7cv6Gd2kzOOEDrHQs/TGNn2Kgg4s884C/MlOGIBAQE8zkd5O8G+ZdhfQsqIgxJH2QhBlejtR+l3SDYeK4oOCn3PkH6XvlCNCl9cxq1gTRCtPvM96GTpzqIGPubGCsGvd6B1AXWu8VIYW113nyafz3CyPFZ0ba9wB+yj18wOHOhaV7zoKjCptPFvsrrugHlvUNw86B1t8E4zrhzr8QEvWhmDosNEOnqHr
 AAGeqnw+
 Ytu/xVUlpeeaNRpZqdEO64dvCmYXUytmikFth5u+a6Uw+2avuXhEVv8GGd6Infdpa/1po2fJwvbRiZTddZB7Ba93YmqDb0HpWrkxgB0E/OVpXG2vy0mzldVatjeAkwk6OiG2AFmwOXEBUEAyAPULRzk+crgvZNwt3ux2Gf6WEEO4NbHLF2h3tUjAQZD15DISJ/aDCQbCua0omtvorAyLtKadJEpAVXpAEV/Gi9qpTa6zz7uo66hBFS4u3St2r0FSt8azzIcLuKR1KWWpzAfLqCkiqp91PPMhx7Y7Ny6bi4BuAZ2IEtt4m3jRTKWv9y9iZhjzPzo8ThUvny12LCtSoSZeQkchh5rLiUI4L0Sfwu8CY8dNd/+dbfC5YqtRahYwFOtHF4KhgkEbqJBdOoDFZeqTPDboW03f7iJ8V1PNIYlSH9hgrzzzovxQ3BpmjwekLKVh0UQbAL9MzjIc1n1KZUBZhnO+1domKYdxKIkb4gX1k5AXjDm17m7LB9L0SSS2OIV+rbb/BBY8/HD+PZoYKbWxfLt0rLg88TMyVaGmp/c8zj6LqB0y+JcjssNf4vjzIf9SMw8oEa715NoTmQU17tNpjPKUOUBAFHD/WhD34clGXwGniBmw4jfoCq4PMNx45shX5WgMI/DyqpnrbEhTspcXdWtpp4BtBXeO97tSZEpDCfwO6qTo9920nmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 04:06:34PM +0800, jianyun.gao wrote:
>Below are some typos in the code comments:
>
>  intevals ==> intervals
>  addesses ==> addresses
>  unavaliable ==> unavailable
>  facor ==> factor
>  droping ==> dropping
>  exlusive ==> exclusive
>  decription ==> description
>  confict ==> conflict
>  desriptions ==> descriptions
>  otherwize ==> otherwise
>  vlaue ==> value
>  cheching ==> checking
>  exisitng ==> existing
>  modifed ==> modified
>
>Just fix it.
>
>Signed-off-by: jianyun.gao <jianyungao89@gmail.com>

LGTM, thanks.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

