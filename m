Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E3A606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vF92+BJJ
Received: by kanga.kvack.org (Postfix)
	id 87B506B05B4; Thu,  5 Nov 2026 06:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852626B05B5; Thu,  5 Nov 2026 06:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7426F6B05B6; Thu,  5 Nov 2026 06:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3106B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:29:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35DEBC0975
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:29:00 +0000 (UTC)
X-FDA: 85400843640.06.12DC26E
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4307540005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:28:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vF92+BJJ;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793878138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYuAf/nYjeBNHG1mG8AOx1BUbgAUnA1j6gAMCPYxxlM=;
	b=aJVqNXOSmac/lrCFOzvSdJ+s7nyNwnSw1iuZd5FPhD+a9ho7rzLcFE/jmzwu4Q5QWL+x8X
	WfI8Hs4gMPEqGDEb2fY5HYBxlY65o8lfmVOz3dAS4NLPsucdkQCgHt0QQnPYInuQvtJ4Z1
	SFBzX8bcMhCDl7arqZD3RCLnpRQxqKg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vF92+BJJ;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793878138;
	b=ayWZdD2LUUCUaaMclQrPVNherApC3P8BJSxZtuYxE6DdG5bqPAsALRk87oIFb6D/kRYVK0
	rKt8Nd09s+OTvIRdK1Yt3Kn+ZlEPEl3KMsK9IIPIUy4fhhSU6TJkilSrzUOW2JM5Sq1Pz+
	CrrCnq85LpxsJ/9hX5d5In6pG+G04tk=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so15785965e9.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 03:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793878137; x=1794482937; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KYuAf/nYjeBNHG1mG8AOx1BUbgAUnA1j6gAMCPYxxlM=;
        b=vF92+BJJ4EpCECR8mBPdGfNQfJv/RgUfUGhCaWuZ2NMJfg3uxOobrHEYtc6W0gplEB
         IfFFJ0czZjY5zT8QVGVW7n8HcT3AuqlBMWwk5TM/FCC4XxC9CDK/nCM3a1cN8x6KNAk6
         g19NnIEH7t6U9RxEUEc3YpbEUCnbu9fKvhzF6mX9JQhGAVTg6ZPgKNf2Fby/8g7gRi5F
         oZXD6vBd1hWDsSmwDu5uCovUpoxrMtjSJ8DBuQS+OlPtD8ByiEQAwOrxf3xtseC8fV65
         CDhc/pNwdAjvJRbh1ZvwvKtXS7NJHztuva1YU4dtllB97Hp3u+Ax5gQ3e6we1Of816Ey
         LKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878137; x=1794482937;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KYuAf/nYjeBNHG1mG8AOx1BUbgAUnA1j6gAMCPYxxlM=;
        b=sd+oArtkurq5CgDREWTSSx120SIimAcZh5BFKpODz9d40NpYJnGu1SFEg6uogJ8ZSL
         UOnCRG+FXzhN8VZf0CwvESKXg5So6ya/o2ZPJ+BIO0cKUJlaRKzCqDvHG9vtxpdF689t
         6WB6k6CkmeT9tQ64hx4C4Uh4oWrpKZQ+jaOYseSCOmQx1dbmZ9AnGtxTtW/J43rQY4LT
         DCCGl/xHaA9setqep60jMgz7L04zw8KBVOMmG7CgH4Fw3gxFP6cV+W1cIsaWBI+n9Dk+
         PPlUhh/dY3wVtCdeuJpEwEq1IcvtK6FO6gLy73I3rJyaUtm9dmqE+caaUbBHFswaACmn
         0BLw==
X-Forwarded-Encrypted: i=1; AKwUvBwbNlf8wj8jaRhUuX4YZz60LxU0/W9SErmBVLIL58rA2j8l5E5vAWLR3XuUevTUMliYxGY82gruRg==@kvack.org
X-Gm-Message-State: APuU4Z/blTXMmdE6r5OoGvQMpGpqVl5tn3MvVN14tNJYrMlaSSi+GluR
	0glCON3oLEbrJSg1zfOtqgVx840CS9exH1UShArx+oriMNkP/ee7laxh
X-Gm-Gg: AYBFou09v7cPpchGyy4ZPJwg1Wps1qeY3QmJ9GDh58RrqXovfiXUV43tAStw2X8BfEd
	Et4rhBsW8qEtrtrg5NrUy8oxVGFGwQfybdGamyyuOU/newpvh2POYrd+1AnkHXsKsKvr0CkynPK
	DbqYHHRCobaMTPo8Sapc5ewXWx9KPMQh+6+dZQl9Wx2rBW/74zXVORWqcOVx4sd5JHyYLoXmVyi
	0sOR3LGO6i7jREsHau5Lz1hS/cEjsZAGz+im9SyYsuQR9kNIKemUMr+gDv7nNx5pqH2epqFSxES
	AMwfmx/1i5LapyTDKMATcDfO0PFxhqkKxacewZyFYNLcYagS5+EjmZm5MsZPXto6Or5cTMT4qOZ
	qNjYvni6vpwEolMvNABJlBqBwuCHC7AH4fRIojzaTBfIhSgeE51JSCIlvewyZOziYu/7SSHwomd
	SjcsKcnYBIiEyKHuOye7dG/kvS6St9gjRlm3yAr9/YtZlhKoTRdhHddGdaom9CrZ1wd3vhcKrQR
	O0+yR7Rk+kuceYLTjEbM8DQpnYlSGOOlf3ks18nKSm6fIZ2sxnFdmu0S7oY0IHfGmQAp2lCYgG9
	5oqwak5vaOmWaiDniwfL0sU=
X-Received: by 2002:a05:600c:840e:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4ac17d168b1mr461927035e9.11.1793878136849;
        Thu, 05 Nov 2026 03:28:56 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae72dsm102176495e9.3.2026.11.05.03.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 03:28:56 -0800 (PST)
Message-ID: <4f63ce1d-4e74-4fed-aa97-e00cd30781a5@gmail.com>
Date: Thu, 5 Nov 2026 12:28:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org, lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: itf3d1yfjwssdsz56u76t641g1rxfoj7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4307540005
X-HE-Tag: 1793878138-178966
X-HE-Meta: U2FsdGVkX18IQt2tKwIRyBjQruIu5s9v1kBzUnJj1HGuP+HvKRIRarx5IrtJ98D3WUmLVTCbBhovvBXpD+SdZPQy+eIpVxbupcxSXd7s8fIePHAQl1TKER9DnJzSf+qdnD/5i6n3nJ9UP56oLVXSbplM7G+zLRIBPpZ4OEnTY5fxVCLCUVIKL5B3Yz+xybeZm32YSVydoG9Z56y+3dic6A6A6A4BoqdtegLgoTkDu6qx7/6ABsIuUxXoJmoW9l0QL10itqgdcD0jlu9YCM1xcSOH5sQtUupFHtkhbzL32d4Y/g8Q/nMOLOmb/GaHKqmE3KMQllgrQqDJyMD03POPL3ROPYyCRfcV66UF0gjtfyz+eKWx67sJSn2UJx9vbwZO90gaYPq4vGE7GTBC0VyYgaFEaOtMA/NjDIQRjZcRe3dVzEW0AG/BphXUwdSWRkZm/N/zb2VMXnAL/LO9BLkBkUK5dF7rR7r3dGwKhBaDhJHNqC09hKVUPNxHk8LR8gNrBbmk3XIEbP33oTwwXbEsxNrXsEjmxE5zgbt2WbzPLzf79VaAsxNAr4yYB9/L+3RBRHH3T5mVG4aw4nTEbotAoNlYZFkyl5Lp8TcmAknAVfeVFkbJW1hWiWVxR6dj1QZItj3WKy6s+DgdH9XIDCi2NKmZmCDOBB7jJTByKKGRfU80vxOYAR9HfUUJb2sy/6sLmrFlarQZcoSa1jqL8Gd1tewikVjOqVE0cGs9dEX751fvr4+krY8KS2vjIrG83XlDwjSAZA4YbHo+yo4sKl45Tja74DyUE8ijeo6S8vxeg97yorpw3ZmrwhsMhMVbAREWR6fks3CAixifKtSIHvlcy+ur7fB+f4db+SNnh63HeGirydKo6necthMH/IP/EBmKRU2t9+5s1yi0wE/46wPMTse7e/op0G0oXoxHvHu8+a6ma0QyuhV8GdYy63jZFFuah+b7DmOn7HNRHlBQW7s
 JmDJc5Fn
 KP/+w4KlztyZI7606lLZcDMWSfBDLNnTycEt9kgzCeK2iALJ5puAue0CMUNGXJc2uwpGRl/Wa44dyJd3CfPbEowLnpYnlgJ824VoIrtFNPVKhPg0NKA6Yx+l0p0fVW1gyannfNuIjwX3Gk7Uu+ChjUUb0RzE8gABFzqRl3rtcZsubeqmp9TP19O/IezDTrF1YX0nzVeL90YHXpJ4YejZMqAdGzjBcbSc24wqFmSgHmjJYnmKtoAYUvF848ZY1PkNpSjicKl/E0sAFSQPJ//VOqDznQhAvstH/QJqcHuqh0GNlJ0/vMRE+huEMmKS+wYDqTj7mi7sjs6fR0ZZxnBd1z1hDS/pDB7B20kkbnE7fPhRmdt15Sts17RY8bZqvEko7BiLJC1qxgMCkKzTvZ4eFrrDNZAkFVycSjGR5bq4yTLB7FYeuGrcWbfCfDsUuZFDwH8BJv5dny8L8FBS7803zR2G1xCpsgw68NosWsLNQcvloYTEanAdmGzMEfzXTGJdHjyfwlumKVfHeFvh7An6Xgu7PmfhC3ogo5taxZocejNp9zH+12Ki2OD/6TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 5:07 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
> during the first MPOL_PREFERRED_MANY allocation attempt even though
> the caller clears __GFP_DIRECT_RECLAIM.
> 
> Pass the caller's GFP mask through the helper so CMA respects its
> reclaim constraints when trying the preferred nodes.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

