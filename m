Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EC4CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194CA8E0005; Wed,  1 Oct 2025 16:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145138E0002; Wed,  1 Oct 2025 16:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033588E0005; Wed,  1 Oct 2025 16:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF8318E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:59:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D77257783
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:59:20 +0000 (UTC)
X-FDA: 83950760880.21.1F3A75B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id E6CBA1C000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:59:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NgYMyeHZ;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759352358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0HadZFiMgp+DlYLs+MttGlBpdWKzPKqgXUkQdjT6mI=;
	b=NjlYqJItaw5lhDXUONCbtIyzc8ap2IGeo7O+z0jKAW/glQ6Hg/rwfrPEzQ0hUILv4rwmGI
	zLD51Nu5a+5UMPLgns3Q4pCe1/jaJkenBqZh7cVX4Q9oomOEmrUPyl7rkTzktWwEYIGC1j
	6NVJRSuZJRssIx9I7gnZk7klb6/uY0I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NgYMyeHZ;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759352358; a=rsa-sha256;
	cv=none;
	b=FtUgCkKtkCO6CTIsGLk2dmvTDcfssEEmYf0qByrk3Go1kNB1by2KWklwu0NwcArpHYtLfF
	RBNavZj6nUsoh8Qt/SXoGf0Aizp7nbnMgq0XoQq/Q/SYY9Jl0Zthw3AHFJiZkKmUkBCF5u
	pqCt5KPWIs6mgqTmlc4Jwt1rzjljx4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759352358; x=1790888358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L0HadZFiMgp+DlYLs+MttGlBpdWKzPKqgXUkQdjT6mI=;
  b=NgYMyeHZovwXiSG6rF0OIfBxyCTlkf6Y1ST9oVsdD0aK+pYN8QGcFGNk
   E/loYWbvVlyo12UucM9sk1ZlW2mXG3mgeO4Zxc9G8S0GLjTrcrlJStzIZ
   EMY1qI1EX/8EDkyJacWs0TPiOJFWaqK3GqQlLjTg+n20FqjSLcAWCJnFk
   ZmPA1XpVFdG1ltW2lf+6Dtnggy7u09E8nQkWsFvGhaphlKFNxn+bQDlCb
   iR1cq9wJrhH3M/RydM8ydjyW+VxChmvudZDN+dXDHOFm6ajW7wtSbrjgq
   W79s2HA24XKiws/pf6uN7dMl4m/dsNiDNvdpk/nU77ZSaxLMbcSfuWfFU
   g==;
X-CSE-ConnectionGUID: aaeoQTESROiuORHJMzPbtA==
X-CSE-MsgGUID: SsqnXbnNT7SGhA6LZlOLMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="71885950"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="71885950"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:59:16 -0700
X-CSE-ConnectionGUID: A+pFzs88QqKNagxbFnqvfg==
X-CSE-MsgGUID: pdzjycyCTeyCcD0oRis+JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="184069162"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:59:16 -0700
Message-ID: <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
Date: Wed, 1 Oct 2025 13:59:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E6CBA1C000A
X-Stat-Signature: x1uz9et7ufjxwsxj8q79453sphra3uzy
X-HE-Tag: 1759352357-710360
X-HE-Meta: U2FsdGVkX18wbz6koGaNcWvKKRhcTiZPcyXlpR8VLtB1P6dQhwVxnQIQlNvg2ED0ZW3fIItoXMZ/wVb2wJQGSuAXSvbngyh7kqgoLlpa+r1U4g1nuA109LwGw5CaN1m8CQHO9TEA8iR4mUB0vtoX90Rnyvr+2qv98bQ20WtkqD/2c1nIzwHbTuHjuuAik7xOhfctuhhdVv5ZXdLWPEOZFLobhJOEbcIv3dc3WKTol/Qep3/XVvxXMKlKStpxecBN7/vayQhg8v5uy/sFoYkLWuJyebOpwnR25uyRtKrBSMOkIBmqJrmBtvQknztYgLzmJwJDQy7amyQn94Szeci1JngnTKNVR2dVdLBO0TzQSLZaFz7DqQVBjbDfFpafHn/5pnStYC47qyZ2A6iltf2JOIjJrOeHorVBxmfGxN8fGaUznqODI982TYBCLc/auriKNLBzF6XR0A3z0wVX6S8lHvdR5sUXCyIbizHnxwVBjwp0OMCoUT3zSkjtN9aPCNt1m7bi36VJy/vKdfz46kVZOtfXTFEW+ZZwoYgRl8ZJL1mXLzojhY6SdsX5w2Ml021MZY+pk7tgWDQC3+HYHzOQoB9ny0Fh7960uSf09KsKAlSkaA97vKqD71HuNzxVyKQZWIH20QmEsXTfTkZQAGnkc+GZCVDBCQ3Gg5veRyEzf6nI6ifn0dwJP65iO+ssQA8Da7Kyesg10P8/+6o8PFwN4wC5PCFqD6LpCWYqr4+37zUGTu/21u6xIDPIt9dheWnty56OBRM5uq0Cyl/JACUgbDWJWdDxTjJ4cwwHjKh/fQ/Vla4C0+k62FyhhPfhaSis2MZSsgvGz1b2CS1PDTs5jItrlcypV0XRRJFBDhgEteAzOzBa7oQfbBDjDcyJMG2jEevlOSyNR4nj7XX0pqVEkgFnDJQC9z1kb5C2EIP4NgqtRWdQyUVoSbXw2u7mNW4PkA5XyA9uylMAgxkAxRv
 4KdWBGxR
 lQzw23up5bTsncVZLHP0AU+WECbd6Dgf48I6YZWNvXpwE32SbyI42Ar/L1B2M7Dxsel08Rkv9KMUE0ArkObX4Jf0Nv3CShoDI4MTfpQy76/DHSXl0XMaOQgwY1QS5CcegXpXz6aG9K+jz53i+7bjj7UbpvJI3d39nRzyO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> Why is this the scope of the first series? The objective here is to
> reach a MVP of ASI that people can actually run, as soon as possible.

I had to ask ChatGPT what you meant by MVP. Minimum Viable Product?

So this series just creates a new address space and then ensures that
sensitive data is not mapped there? To me, that's a proof-of-concept,
not a bit of valuable functionality that can be merged upstream.

I'm curious how far the first bit of functionality that would be useful
to end users is from the end of this series.

