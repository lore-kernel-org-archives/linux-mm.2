Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A971CCFD314
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 01:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15BD6B00A3; Sat, 22 Nov 2025 20:51:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDAF6B00B0; Sat, 22 Nov 2025 20:51:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0AAE6B00A3; Sat, 22 Nov 2025 20:51:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDD396B00A3
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 20:51:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83A27160A6D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:51:14 +0000 (UTC)
X-FDA: 84140194068.16.444E9F8
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A7ACC000E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:51:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jlh93hQ/";
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763862672;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nVpiFdX7itUjcz/kHm7teZ1ePNKGm4Y4akUt0BwQhs=;
	b=n8xIzBsp6eobEDNzB9BNsFHLnyBUdMhR0d+QySLjiQnM4XltMOwoowT0zPoImljEKEfD1b
	6iSsUnQwDKAubk9E6iWmCUidjKs5e713cTIOhA+nlgNtsMtDpxU1kym8w6MthTPyg+7BSz
	fDmbb4oa93FXyTR5pRYHtCkX+4+3xKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763862672; a=rsa-sha256;
	cv=none;
	b=E4sTg2wF0O8mpkD9iNZx79W1V0B387siJsXUD6Az7Iz+I8TzPGPz79CcdxM9AXo89f7fGN
	P6syN5YLtomVoBG1ndKQQnGF4OviauHbLCbRZH2fzcGbRZCnYkIK5EKtYMbESoW90aXwd6
	8k3aJ4vAJROqb2lp4W78IqGZBLIlYZg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jlh93hQ/";
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so5643083a12.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763862671; x=1764467471; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nVpiFdX7itUjcz/kHm7teZ1ePNKGm4Y4akUt0BwQhs=;
        b=jlh93hQ/ihyTVh0LIuHvEAUEYxwyjqNh4o/lJvmBoLiw238G74jOLzkhXRCI8kCnjc
         F1+s1qfq4+mRM9Aj6Wp1c96Nn1amysYYoJETob3qxg52gdcKdi+cS0vjGPrwmiSCuGrs
         ia+g2r0eQSBEfW3W5YvsY5oJvVo1Etazzozj92kQol7hS5OoUjuh3RyUHa/Y+UeJhbnu
         +671oHxTXIUFoOpc2buxx0HNqXavaejgrEM5bDXaHI4wIoHfADE5mA+6MW/SCHtxWWBI
         sZP2hn0OPaJiHM/wjZO4CXjBEWjXizCbMaGVf258rYk0k/vCy/yvdjBPI364zsVIkVix
         E5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763862671; x=1764467471;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nVpiFdX7itUjcz/kHm7teZ1ePNKGm4Y4akUt0BwQhs=;
        b=fO2KQybBmbsSA24A+aZ9L0XJjR4izm4F4vve7NhXt+DVnbIhfqhhQuIW/h6hFGREXR
         3bIj/U37saf9OnShInKyGYm0IUj1oI8oA7nLeI36An1RfgiNWxnVfOcTgtjMP3SB4uJJ
         HHQbltc3i2g5gwTkEfJqrbNAHrMvLaqzciPF63EydVOlj9x0QCFux1YNMxgiLUtt2pX8
         QSUooHeI5PiprCWwz6RvSLs0419JA9RRkwg9CwVlSGzRaHfZ27HNY0ZQL4dWShRKTvJp
         cgYpyuDOKpeUTrtH7fTdn1B1h5u2PhaE0ighxj9+FiYL7xrzKeGUUUSIJ6HHwsgJRILV
         ri0w==
X-Forwarded-Encrypted: i=1; AJvYcCXALsUdxJIizEElQs/wOtOUE4nhGkgnI7vP2qO+RcKQgiU0GS/RGHcYk6gJCCtraZQAssku9nqo+g==@kvack.org
X-Gm-Message-State: AOJu0YxQd1TCXagxMInGc1BokBbOIgzFOz13/77txFooh5PB6Y1ERL+J
	3NT3/lOPds3fC9Az1HYfRhA+OiZdmPOm9sMcFw1vwFfFA3s6oQsJdJ02
X-Gm-Gg: ASbGnctPpGn1ezfYncebotPyAHtKy5kEpsT6V5ly48UH9K/KEv/MiWBiS+TxIF1OK+3
	UbsGnc2MT0wEyzff1CKAt8kzhcAkyrZtFFevSZ7KrqRBfIGlm3M9u+m95RKZlrXgfvyGm2XCJmW
	HDYZmePVgB+NjgMj1/LDz2biaXCFmUTIRAabEbKnDqEgn7rjZtxPlf3umSAfXdjqavTcbVbntxW
	4KbyVvMX3iNoeiGc14XwPAnVKTermpCYyGLqjvt7WHoR2E4SVVn1JnRjmCI7i+hkaxhQZVxDT9Q
	vnjxh/D/RB5XOASYhI+/D+UxvTyVsRHRIvR5yh2ZBubez0xUAJt64MWorobmpBMpHxNwbW2Yrp1
	VSU+A1Jn7CWIxZvosRgiXpkJs98/bnL2pqu9ZvvZ8mPHH0f2qO61lbQ4oegJnAXc0hYh4RmvitR
	IKOi1J1KKJzXvIHw==
X-Google-Smtp-Source: AGHT+IGDbJxR38k0CDgJ6xIfXSvddpH6S6Qzkfm01XRydYuyQe1EOms7msfODKCix83hDBowWzuBgA==
X-Received: by 2002:a05:6402:1ed6:b0:637:ee0d:383d with SMTP id 4fb4d7f45d1cf-645543495b8mr7201615a12.3.1763862671082;
        Sat, 22 Nov 2025 17:51:11 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64536442993sm8555273a12.27.2025.11.22.17.51.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 Nov 2025 17:51:10 -0800 (PST)
Date: Sun, 23 Nov 2025 01:51:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Message-ID: <20251123015108.wxb7oyk7vlfrjlbi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 5749hoeg9yw4843ruot7ytjfz37ho6wh
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A7ACC000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763862672-934023
X-HE-Meta: U2FsdGVkX19sxWwLX4R1OOSY02x++wiNhriMocV9P6YsvuAzw6RYH19OkiCEuqx8A68b9SRRb92D7a+/qYhvG6KvmegZcVAuvllicAM8OGrIalZZiz6mKOU4RBdZSKfVmQsLWe2bac8bKY/9aTAP9bXGHaQgg9Ei+HLqGkR5iXMooP7L1neDGocsnZAeae/Lh3GEqpcz66TuHXqVss4yM++FRsGSSNiPMFHZ2OaxyeWvEVC7EvedSAcWCuykqH11H8Lsj+Y3XyQGqY6eo/8vF/c/pqBVrGUr4pswnaMD8jKTNaTD8Kgha0/y+NyRjMZqgmSBHJOHMOs+xmmlk97eRT1gw2gzO6ldzOWBkwflFDM5We3O7ARzR3nu5e79MQYL2tczB8YXATRtiiPbp+tQ9gP6d/ohjCpPPhHvyJjO148OoySKk3vR2dwxeu7WQu7C6hwLciJ151kAtVJGQGEC61GpawH9DWFSQv8gekEPR2sHCjjY+dH6V8ujeOZjU+4I+b1H+e14jcmQG3vWuUO/vlyYd4uYucHOhGUOlGDg2UlpxrT//n22FaiUE+cN6fvnQIWCUVepO4Dg+SY4DeB4AKO5S6Zfhwg9nOv5W7UeZoKqqU/jKz4MgVkGNSxcwHtyCvSt9+Oni4XW2w/5Itwm/HUL5LM8KWW4wPXUmJSpk/baJ3Flv3UO2TaLqVGDTzjHxIdwj7eSbhR1DvAosd0Nr0P3GKF3ZV8y8FBe0Lyexxw1rjkJNJqO5zzmJOr5hCpwETXN2DKxgSOSkJ8mDJpjFLiAtB9tZIHTJZKvEvqoihG6EhERcTtopVes5x4h+NcDj8dndZx0YC8rX24vmlVGcnWQNVLBkCF2oyI3QBEIbGNzj29hQmPbIIAI+KseNmBBoeqTUngF63vzrl6TPijADxzQhhKc5drZz2G1LNSZdtV7qmnBBVLll1nUTB4UDQIo4H7OA2CtGfQc7kqJRE1
 Mf4ZxsxI
 AAWO8b2CtsTsxtCW9c7Rg00L4HHhryEBpo5COtDy0Idv47ojE4TLypdX5AFooA6vprf8SnQzUAGK0x0nzjUASM/xsUeWsZW6F5YARBQfNPzp7gXajyQJXihMJQAbpeJG+M1WEiQ/8ZwwzzWkOHYLHFgmcq3w6rQn8sKpDR1pug/j1Nk1yhPlFqSOgzEPUmRcu1FVs3HxicMQ+eWySHL9EHly/psgtuY6LO3y/Q/NrGWEa9FpiGWrMW6sMiwYYK9aiEeObXegrYy1dbdgaNwZHOTZ+xpuSGg6fP4yibk8t/kZ1onlzPvvKz47ZFvbkwaMSyLKbBnHgXxUJNowvy9V4ybrR4ueDOykgrF2Yjz0ymzUHU197jtxTUzqVq7bO76wSnK1N59inFksgZdf7LjpSNoPi1wpnAkhvtpAdq95iMojeV6SiwOySUfhxcWqKM/SOQrXW9VOJ9nUOR80PC1DIeGJxnVH8TMstVvXX+opbTxD8vRyeYcUQvX0+CbwZZ9jy62kPJcUpOnrPl0U0HcroCcJWA5CgMhUZV9EgjdRzqV/D8meRiywgooCIwgPxWOpX1JFeP9il/hh0GqAfv+HDtcNg+8513cj/64IaoO/d6Ei1B3qQ4RrXbC56fUYu+LQNdUceZ2AgICW+h6JYS++RwnHBxI/4t0NciKXKz/B/tOushA1gNH2B5ISAfgYowwk/H3GAhEhjRHD5f2+iVYbcEAZDFULpI3B4VoZNHlPKYXiCMK//4TCHQvUpG74Y0kOpb5IteI9QsInAwZ9rjx4h3asiXSlp+MjDlTUGSsN4M/i0wzJxF7kFvZVYxF711S/RI0P1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:27PM -0500, Zi Yan wrote:
>can_split_folio() is just a refcount comparison, making sure only the
>split caller holds an extra pin. Open code it with
>folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
>used by folio_ref_freeze(), add folio_cache_references() to calculate it.
>
>Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, Thanks

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

