Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5EBCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA0B8E0009; Tue, 11 Nov 2025 01:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AD78E0002; Tue, 11 Nov 2025 01:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659308E0009; Tue, 11 Nov 2025 01:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 524E88E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:12:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD88D1A03CF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:12:25 +0000 (UTC)
X-FDA: 84097306650.04.A10452A
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id DDB4614000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:12:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=HoL2n8c6;
	spf=pass (imf09.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762841544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWwWHfVGkeFFK0gt3TeAwp+q+y/27u6YbRdVkJwdPgA=;
	b=u8mplAOjS0lMgn6qfChxHtF5kekHS89HVl7/wqgnJ7mnIUFHYuGV2vBi8iAIUDgM5Vsozm
	9OLF/5jfWamf2NQZtKfKInqRPFb3/PybRkmdWIzCjr/L1TDt07X7eQVT9SQQbsX5AMvbsF
	CAopq4wOb4UvwybuDER3aDlAeiWULEA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=HoL2n8c6;
	spf=pass (imf09.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762841544; a=rsa-sha256;
	cv=none;
	b=Z6xUVz7NdNybf9svl+maHQkgj4miGy/Rj2OlMhH+awLI8aK54T0bncxtV4q7F2Dr7JKZ4X
	vW8JEVVSrbQ6XVrGPYwv9rthUbX592dQSfJABUedhZ3OlgcorqsbeqXo5QqcHWhuT/4mr/
	xgbTOxjw9R+nlK7SCDeNwkbuKQqEGwk=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7af6a6f20easo3086132b3a.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762841543; x=1763446343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWwWHfVGkeFFK0gt3TeAwp+q+y/27u6YbRdVkJwdPgA=;
        b=HoL2n8c6tfZmWdruhK2lVNkHSPWfikY1jcY6MyXya2Yp5SlKG3yCGE5bm/5m1bFnIr
         LfpFCLvjlUkL1X8r7mpF8cIrLeAzRnRacmJKAeO7mvMTGivf1aMSAPZj/OBCr7Ev62Wp
         bbmdLe+ZgdOnTJYpKrVkkf4GB9bDS/v/+oLyH3jjucV5cSJ1hNHlSeNkbC5fvZEu1nAM
         VEP8SfQulE1CGHkwZ3G+uCitOhGsJSfHsLsr36rt0KndzrIRNq+iBE3y3OvsRERlz2rg
         inzQRyEdLlYQuSZomid9L8ojEAtR9F7qRslHssDE0VKJqR+uEiBArDBaMHWpGgT3Cmmi
         sbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762841543; x=1763446343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FWwWHfVGkeFFK0gt3TeAwp+q+y/27u6YbRdVkJwdPgA=;
        b=a8t3UkL4e/y9NBRQeSkSE1az8mcfLVZtd3A4N774d57eVI/fVOsTi2UQyxGw86VVDK
         GP8gjKw7aGbyXoK1o26BjQoWe1qU89RQz48/PwM34n10xBTxHU3x4OWJz3w6vUzbS3C8
         4p5/k+dBI1cTr5fNaUo3/lVbL/o06GSFVbK1IBXQMJ/1Tm+7ThXpARWPvJcXcnlDxc/4
         CZGAGKjQZr7OYOA622Acux2beoOZHhkMEsZ1WX7VD1BNTDd88i7d2fvHDp5Jp+Ox7Kll
         fborxZyX5QMxUWu7tGt/ni3sRxtlSEcwZhpcClbV12WYtrOpcSquT6fUI1N4CU8udJgg
         P3fw==
X-Forwarded-Encrypted: i=1; AJvYcCVgoOpJl+/Qih9jr945eBwzuBVF4F7SDMYos5HRJ/XRoO2dUJvsGC+xKMpIdSIbQsOmbYWXHgLbTA==@kvack.org
X-Gm-Message-State: AOJu0YxOyqAdByjCRrJNFrGBmfWdvBlUepvLeyDdCHfqYwjmBjER9PyE
	IlAHYMJ5kxywq1sqn2GWMMnetdWG5iH/9S9sUMUO+2dxIRUu7XlMZ8db1kFekzysBk8=
X-Gm-Gg: ASbGnctIDFD9GUsTP1Y13gK8adA7OukrAWPp3Gjz3x0ipP3mNhXQBc4kZMOBugpxZTi
	ZI4LL2N/WFJEsslJ6JEvjvor3OESQL84RyCUZdar0AVBntI3nKwnr/biT1BQEjetR5AM+hkUp5I
	ciGQ6QUnXUEc/fb9n7v2RZfWWsk1TbLzM2NLpyPdzA04i8BEQtR2V7P0xZGAMKyC1pgEeCrFKwT
	GK0/F+mPT2KCA1qx+TgcM0Sd/LRWpfnVvT2d449YUkS+XQHWfDgw2Wq9jw2iYbvbZOt8bdwrNc0
	E/0fTvn90S4TdZnot4s9QlAgJTzvwrvkjuVhZRKe6u7Y2f0TyEQYgCNVaeDXyBn+ndUiNdj/Mrk
	OYU4bmS+ZnQtM/2xZSchZWhMrH9hyL6SOPwwLYXktV0TPpleemT3o0OnPZtZCPyimBvjmpgONcC
	uniREX3HwHh3ZQ3ZYZ5uIu0Tjt
X-Google-Smtp-Source: AGHT+IFvxypcxwiOfBwdgzPuM+j/Y1RLEUCRj28ISBfw3r7KvT4isOe0gB52rHuhHDaQS6UnBqQMLw==
X-Received: by 2002:a05:6a00:2d8b:b0:7aa:a2a8:9808 with SMTP id d2e1a72fcca58-7b22668efe6mr11556484b3a.20.1762841542634;
        Mon, 10 Nov 2025 22:12:22 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ca1e7b19sm13755722b3a.32.2025.11.10.22.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 22:12:22 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for on-demand stats flushing
Date: Tue, 11 Nov 2025 14:12:13 +0800
Message-ID: <20251111061214.70785-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <aRHMWewcW41Vdzed@tiehlicka>
References: <aRHMWewcW41Vdzed@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DDB4614000E
X-Stat-Signature: c3fpq46io7uz1ab13u5xoqjybjp8rftg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762841543-319624
X-HE-Meta: U2FsdGVkX1/nE5/RW2pRAAyqvf1PuxiMRxALBb0kUHlfC0lLASGvnpKsoLkbGH8fLtHTogyn8KFK2KLuTisT3lTTUBbpQchg/eJdlaHNn9LJS3BrNG8SUZOuh72JYNkB7SU6/7WrjwaCW/bsEGdMvqhTgVH5HKJjodA2bLk4irjpmyZ3A85dg/TiRCjgcO77++BuG5taLAPw5N9OCuz2jWQgeXv5VaWBiLN+Sf3AUYJHM+e4k0+4cQRLKHqH1i7vnKU+RFjCEmHWmwrwKCtRvil6olDi/+k71dV4AoXMUxxZxefLmK8JRBSBO2/Mjo+hHEP587ZDhSMthKkmkzKFo24mu/wNCBZzsaVi0YLzMV9Xy6s2FqPS98nA0B6e8S7MTOkCa5gX61vT8RdsMik1JIUIRap80xf3r1Pnkyul7G4YZrR2SZLA3dCgLSluF0b7VtzrL2UpS/21V3jtjo7KRl8qre3mLRIIpMxUxZB5iWAzqTpAqOXIwzgc0BDP3EwOOU7e+GKDVHASmjLRfe212sDc8KRsI64wQ2xf6a7BYrXw0iZBfpNYKidrRx7edqabHHfiDgQo1DMHMwMmeuXCm+nvdR80RWGy52cFRg14TYYLTIUIyFMseeTxMGIbl71RJ6N26uS+tdOrCf6k7N+VFMJfAkXpuaATVbJq+f2ZIKDY70sJQMcRqZ0Ed8QerJRWF8wbvgmEsqF8p5xIiuGwob9WMexmigefAnh5K9IrfKOT8EwWGRMk3lC3V9m0uLxQ6hghlbO4O8svTd/Zct/ql7AdyhQiZkHx5IebH2PoQwID8LCOL9wxmeqpZCMdQ2o9DS4LFFzNYcGUe6W3UIU5MGkKQAkwR4jrQcbAhcF162FbevzMKV7AM/faK3jOj6foL9SHZTApelkU9UiP9sm9+2BxSUft8hUoCl1xci2BJRBZy3nh5y7U1/e0XMKOQbM4a4j7CW4515Z7QdKRAx9
 AkgJCHGc
 BjSoqJAjOmcCAt6dKhNQwne8ztSXZwxP7MxlkRUe4rLKW2J8ChNgFmdjEvzOeoMg0GdKCH0tQSVlZjgZWss88Li+X54UGRfQi7lxuLadh2Nke+40asehsduY7JbXrkelM94s6nJsKmKWb9mmE+0h028+geiTJ1xAuQxgTQps7v/mcKBbZLP5RhfsIRPH68EZZDSEfAEMAtWzr+2/o06X/8gWb2WaGmwKiB9uZafxVGUuYIDjCu+kYjPgwKjR/4wTQV4ffbU/jVG/GnAwLd1Fwe0WzT991kYZa62n9orILZSVlV5v+aNyo5wDJWPJBWsxgClGUD+5ki9Ndu8Pii95a8DI6yJeafoYvrzM8jURxf2nCjpQocQJsS8VU2UG9laNIHkN1UxG370V+CBiJMS5EFT8AJ4veZ8z8QPsp7aD8IFmNSMOfxsGlxoZWXz/T7fgKbyVXvVMkVagameXSP5Mwbbuc2/oL3jx2jIlBdwWoMufwwZ4z/O6FMe7JGIUoxXLxBl00WEUhj9NdsVQEcpOYC1StiuKE8pAKBLl6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 7:28 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Mon 10-11-25 18:19:48, Leon Huang Fu wrote:
> > Memory cgroup statistics are updated asynchronously with periodic
> > flushing to reduce overhead. The current implementation uses a flush
> > threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
> > determining when to aggregate per-CPU memory cgroup statistics. On
> > systems with high core counts, this threshold can become very large
> > (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
> > statistics when userspace reads memory.stat files.
> >
> > This is particularly problematic for monitoring and management tools
> > that rely on reasonably fresh statistics, as they may observe data
> > that is thousands of updates out of date.
> >
> > Introduce a new write-only file, memory.stat_refresh, that allows
> > userspace to explicitly trigger an immediate flush of memory statistics.
> > Writing any value to this file forces a synchronous flush via
> > __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
> > descendants, ensuring that subsequent reads of memory.stat and
> > memory.numa_stat reflect current data.
> >
> > This approach follows the pattern established by /proc/sys/vm/stat_refresh
> > and memory.peak, where the written value is ignored, keeping the
> > interface simple and consistent with existing kernel APIs.
> >
> > Usage example:
> >   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
> >   cat /sys/fs/cgroup/mygroup/memory.stat
> >
> > The feature is available in both cgroup v1 and v2 for consistency.
> >
> > Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks!
>

Thank you for your review.

Thanks,
Leon

[...]

