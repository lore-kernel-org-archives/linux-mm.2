Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2FECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 12:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C508E0005; Wed, 20 Aug 2025 08:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604548E0003; Wed, 20 Aug 2025 08:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A018E0005; Wed, 20 Aug 2025 08:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF318E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:17:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49847140457
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:17:03 +0000 (UTC)
X-FDA: 83797035126.25.FE0B8EC
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7346840003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:17:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Md4nw9Ph;
	spf=pass (imf04.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755692221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAyuXmmTiExKl6ZtNupk//S3JQWiRitMbriQKBEbaFc=;
	b=MUrnFPmeCfNJ+OZ6z1VHRtfxrCqVTHTyBTsVab9DGc8s8Tu0UO6oU/tu8HhEmOd75bgPWw
	LxjFmR4fS974nrVHUC9tUdygCGhNRfBVypBaHYicNMLUjd27ncTLd8+Fe8oDbcbOqXU2Nn
	xfNbGppMISHzE+YYy0fqqcEo8VBf0qo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Md4nw9Ph;
	spf=pass (imf04.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755692221; a=rsa-sha256;
	cv=none;
	b=sG/KuXwf7TwQVF6d0zqfj8LGRtsNiOK9rTznI1JAjImXenRYV03lWxWSFHnI7kpFrKsAg1
	7xk7WyfWl+X/xQqgJE1144AcMPyctdjrXQfRrLBoEx1jESOXpjKi8nX7u1kbGZzbzyYFIr
	WeKL22BVrmznp6n7FIhU+sLh9pEENdo=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b05a59dso4635865e9.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755692220; x=1756297020; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gAyuXmmTiExKl6ZtNupk//S3JQWiRitMbriQKBEbaFc=;
        b=Md4nw9PhljONFcFpXKdM1qtiBQhxBRT2HlpWSUNf5cJn3JwTx0Y8ZafxJ1uMmdi71b
         d0mlHUhn6MbKlDOAYFv0HO2ImD0vhcQGWk7afIXvq4lfCZRAOWPEtgx3KHSqqBKJZAtf
         XA4k88Vzc36GctUMRZjg7q+AZwIbm5MzOAb0f5fkUITPKkB/AALwYyNMuZGjxE0YW1qx
         bOzDt7rDkaRDgFFDs+MYtPqOWOFJw0PZGVLyvUPDzgNwzWLB7xYqX8KHzvSDWIl2bwvK
         ERDTTETpZlNxvHnWmZ6nwvkDPLJHfxIWhiVuJnFXzgpU3o3lzaugaRFj585Umv4vSkk8
         mKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755692220; x=1756297020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gAyuXmmTiExKl6ZtNupk//S3JQWiRitMbriQKBEbaFc=;
        b=SrBpFuRzYMn1J7wgikbeEXmngEFvlAOVDpio+V0cEUi4zix+ZxcNPHQjrb73fWq4j4
         7SOknWjot0VdFGlFKrreseOTA3k8sW8Ky+jI9cOfOTa1rP//RyLoOwd6dZaYltGP9/Cb
         rjwroQy9aKArlkf4NPUGW9XXtAyBWpo3V2K6jQXrvxG/UCA6jea7zR7J3FlFjPuBQ1be
         1rYYQIxXRuwL2K9q+3/vDHS6DTluKcSsA9qZaRd7KZL0zjFxrZga3UKB87m9DZzYio34
         E4QK5S3Og5J6/dKSV8NyQFDPP8vt8yoG8/ZYY8cGZMI2Hc34j5RQWBxLxvpS3hkgwWzK
         3vOA==
X-Forwarded-Encrypted: i=1; AJvYcCVJfcAkfnU8tmerTrP4v1KeoG4vzqvQ6nid4vi/Pa+E8EC1usZGN5i/+djcUOomvdxXdyh2rHhEHA==@kvack.org
X-Gm-Message-State: AOJu0YwxttnXo0ZmUP1hpciEWDxju4nCDTiz6EOYe7lZJzsQ5bWmHvMl
	FsxAueOEexanUxv0t3qNIOi/lK97yb9Y8BAX/1oUkZViBuE6Pg8yAsec
X-Gm-Gg: ASbGnctmbYB+y6UiLKQP7v5RKtIZbiOd2c2QQL1RqAFrgUk5hjzImm/Ut6elPbqho46
	EMUEFGzdKB2u5xm4tLzeZGVNqVGZ5wwptD+Iu4+Q37vsbLdIXLKXZlAMqxkPKnWv7/I9MjLvnKg
	LZuQPTzphATw8aL3MCl0dKqr6+XZagqpnlTurQ2z4e/QfK+Ev/S7BlNLVQSlDYMfVnRKrSAnvxx
	shUv+nzWkyUDAD1g880ff8zMZOz73bfG5GAh2zQDFnLcSRpQd0qVLhGQzWCbuIljAX9VRvw47WQ
	T1tex34Q7Pu1K/E2wVJrnMM90HbwDU06Ntc5OXu5LF9ebkJA/uDw6zmuhZjiVjKfXpUspMCJEl+
	i0h1qc45c4cTeGXwX7g5olADaaiyAtZlKHjU/x77EoAhMiZlasIn0
X-Google-Smtp-Source: AGHT+IEmicsSzxkK7EC0Py2jIPsFAnlzPswIDNRsBjO5fusLnw8AUn6MeAd7fI3HWXtD3hpJxw4JkA==
X-Received: by 2002:a05:6000:2282:b0:3b7:8f9a:2e2c with SMTP id ffacd0b85a97d-3c32df48f48mr941403f8f.6.1755692219725;
        Wed, 20 Aug 2025 05:16:59 -0700 (PDT)
Received: from [192.168.100.5] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c077c57aa0sm7531506f8f.66.2025.08.20.05.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 05:16:59 -0700 (PDT)
Message-ID: <24119aa3-f6ef-4467-80a0-475989e19625@gmail.com>
Date: Wed, 20 Aug 2025 16:16:56 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] memcg, writeback: Don't wait writeback completion
To: Julian Sun <sunjunchao@bytedance.com>, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <20250820111940.4105766-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7346840003
X-Stat-Signature: 1p9pkr7ueb5ttdupfg63pskryyr4qemp
X-Rspam-User: 
X-HE-Tag: 1755692221-410213
X-HE-Meta: U2FsdGVkX19Xps9lKecIBdLwsms4lQKRbrfvb+Hn/d/FvQ1Gor6pkp07rZzgxRj7s2sx5k+yL6IoIg06WdxDcC2ICxEGCbekGIBezwBtogdjnMINGbkYLhH9uk1n2xnW8ZPddKQOUL3noSpYFwNc0qenSai/3TglpAzHhH0JH5GuwB/Fqb8CX2DgXPAOV6kPVQag2NJZ92y7C9arN7CEfEYImsb0wS40ctKoQP6bUNRYsJT0P9nfb4DLSfY1IAKrvI9WmikqJyo7JG5fnQ6uXz1obu2gH/DMVUNyVj0symvrLLaPcp81Ywmswh1e/19sLRRgM+hGSYsVp9j6NaEysxoOXIBLcqaRgXKP/Eh2ZozPpZGHHuBE/52n3gwpBuBFphYx6L8UO2dLuQ6AIUSEqKX86ETiEoWHBxoRBCkiL70o9j8dJHM9WXP6snPusECbIsJadWFjpb999iFjJ3efBy4Nla7XIwpK/J3485KTL4Mu6+Ga1j0r9NPzISMYV9XnXwld7BX5BYyeZO4yaHKewICD4GAiAF71sPeS19ff8plwxaZiYB2T3P5d59tAzY2Qte0ZWV5jZ4O7E+xAhsJfZaEEnzI5EpoVddf2F0de4BVxSw8i+i7JtERYdF+fntTK7f2z05yvd/RuFpdKvxFHAMz+vHiv30gDWjhtS0jM/10568QDeuVStykDFZczciXRZoMIsepALrQ1EjnlQJ9trtM8oQw4GXrs1JG2Tz8lnbk20Mzhzwv1nhd2KZetuOqc0CVXyAZziLFkR9/W6jR61moQwUV11L8OK3HSPUMtCxshkQmu0SCn7yptB2KjalS2yTVE726A6608FIrY5EMX2QTjj8O5NroOgDxgl36+1zk7jXXKeGqmcYAUjePj5hH1SK7DgO0PVpjR+jWV9jtxRZWEfo1E2niFhvkzhefDEzPkyVvsAN+wNdNbRtIAEwGCOsk1yazTmdwFrCySm2t
 t+fy4iMD
 96eNn5W4aN1HDGpqLi014ko3GQlTW/qMZCp7swQolKKmkRG96W0/ggor6lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Could we add wb_pending_pages to memory.events?
Very cheap and useful.
A single atomic counter is already kept internally; exposing it is one 
line in memcontrol.c plus one line in the ABI doc.


On 8/20/2025 3:19 PM, Julian Sun wrote:
> This patch series aims to eliminate task hangs in mem_cgroup_css_free()
> caused by calling wb_wait_for_completion().
> This is because there may be a large number of writeback tasks in the
> foreign memcg, involving millions of pages, and the situation is
> exacerbated by WBT rate limiting—potentially leading to task hangs
> lasting several hours.
> 
> Patch 1 is preparatory work and involves no functional changes.
> Patch 2 implements the automatic release of wb_completion.
> Patch 3 removes wb_wait_for_completion() from mem_cgroup_css_free().
> 
> 
> Julian Sun (3):
>    writeback: Rename wb_writeback_work->auto_free to free_work.
>    writeback: Add wb_writeback_work->free_done
>    memcg: Don't wait writeback completion when release memcg.
> 
>   fs/fs-writeback.c                | 22 ++++++++++++++--------
>   include/linux/backing-dev-defs.h |  6 ++++++
>   include/linux/memcontrol.h       |  2 +-
>   mm/memcontrol.c                  | 29 ++++++++++++++++++++---------
>   4 files changed, 41 insertions(+), 18 deletions(-)
> 


