Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E21C606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=q9o7sra/
Received: by kanga.kvack.org (Postfix)
	id 5701F6B05B1; Mon, 26 Oct 2026 17:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547CD6B05B2; Mon, 26 Oct 2026 17:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D546B05B3; Mon, 26 Oct 2026 17:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C73D6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:24:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F3BAA08DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:24:08 +0000 (UTC)
X-FDA: 85366055376.27.91A8BB8
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB16E1C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:24:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="q9o7sra/";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793049846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H3XFudOIVUpfowGZGMfKOHChQPyfvsUBh9VsbVmyjQ=;
	b=xUdm+oU9m3xISnwyXachRAt/mJjtGPZlLT8cZtKZeiFe9sOwwAG7UlYbwwdSxIZDuYixCL
	l0zM7aAWc92HH2PTDefq46Nd0a9BqoAv+V+m8PnetWWnZPf+vAR9XRfowDtVW6TeHnOj89
	P6FefPEsEbEAQAcsZt9D4m5SWLInMwY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="q9o7sra/";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793049846;
	b=dMOLnZxWSFxRcRalGjKTT78El07Xq7rFZzcwqfyl5q33/V9d9wDaDJbDspTgfDFJ9Ss74R
	pg05S996sC9uP8Wgs0z1OO9V8kB+p3NVcKH1rWk40k0JCaWGwPotWwQrvpFE5uFXDBR183
	QU14xctLUoc72koyVE2PZ9P+PbBreLI=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93cb9e9405fso163448785a.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793049846; x=1793654646; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5H3XFudOIVUpfowGZGMfKOHChQPyfvsUBh9VsbVmyjQ=;
        b=q9o7sra/+FliO3UoXQ/orVKyvV2oy44JgQTsNpwfcauVNqcVYYN20AwQM+FtI4i5FF
         ykFAAy/wDtOq86q9PKZsS76ViDqX3En5xJXi/S+ryuE0zzBY2mDBPEugP65e1gMFeKYi
         oiEFJjOH+rl/4+1Yzwo1AglS0I12Z3Jbwq3tmAHZllTdXqiuPyStaezNHGDYOXgrswZD
         OlDdLYWliPwl9iRjl5DELFgsioM+tuMS1EfNrUgHEiGxTPfHv31kdtHVKfKPUv76pX89
         zmnFz9OX64LAJ8s6XIZmqEY/o/OfyU9YgKqBrZmQqBGAOWo6U8kpx4JZnNVC4nVMQKkp
         UgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049846; x=1793654646;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5H3XFudOIVUpfowGZGMfKOHChQPyfvsUBh9VsbVmyjQ=;
        b=oZcGQ980HYB9n1EPaAC7cuy+GeXLMWClsx/zJAGg/KClms4IN3U8NZ9vEDPxZUpFjS
         jdWTF5wGqc4bPCH1YkCjkK6Qy4DAZI6ycvqme7wiSnzh4YaM9GtvHOY7IkwYXFTf4IHT
         eYR71uJQPOoVfyfcVv1Fs+oRzzz7Mmn/Hkh+rDf3pQ48D2hje3hMVUlvW0qh91tTSiLq
         CSc+vDqQnxLq22ckUVNDC5QJ2y9kkesDwUUNdsq63ajpD2+pIStXK7NfEigIAhz9Uy2K
         TO4guX/BCCHiSOHBDdnZ/p/HnA/ft6GXPF7+iit8/Z3uf3TYChgutH6tB0zJWX9v7slg
         pgCg==
X-Forwarded-Encrypted: i=1; AKwUvByRzfcrTXFAlhEG33ALa+aHojs1e4rQ33xNAs6Rb8mlKiLHLsKn24XE3LyQY5G3xiHDR5YIsEpDtA==@kvack.org
X-Gm-Message-State: AFq9FYI7z6fn2yoOElwWNTNav/KJhSMR/dOiR+6hWEJQCLxfAQmfc2+h
	EsRu95MCcaW1FBAmEx8HPtggIlQZjgj/osAIlydPrwSE3W4Qz8yvPEQVHd0Vb6NuYbE=
X-Gm-Gg: AYBFou3j3l+BTBxWQxE8RR0jhG1MqpXVjZkiBIz1pzS9GLNvLVLdoV9/W96kIFzClBM
	HEATNl4lml0/D7MFg+OrpyFbhMBmyn10PeYkGLYxmGu9q2ozUCO+ideiQZQ5N5RJRlpP8euRDdK
	ORm75in8OzQml8SBKyZLuZXj7LAYsj2ltcRUCk1SrrTVM2PIHAb/13C9qHLGvHjyMao61wO8ZCU
	/B3QF39xEDgeRCqpcikU3+zByJDZYLdKWjmOfG8k+EEtFkOox/7laJqI/UEU0TRWQu/eF/VFnvN
	iq/rYPmnU40Ybudz20BXQaTKpnxRv1haNt8hKwqn+09hmrnfdbrMaqlmza3ZtQX0NRS3CTeNNx+
	Nj7mIronDunAHhv5cYKAXcOt7s4xpDxzZGq4W60s8q/YAwIuRwahjgsA4jsdXCDJObcSircjJXP
	bs55hdzqJo8ssWouRGVrvkBVyQOhh6+PwPSD9Pz8cyyo8r5NQYwbsLiFBkWlp6Jo2eYFUUMUI0y
	qVjvSKrdfAQjRDM+x5Y3N5Xe52Kji/IuW8sxMgBYrzu67Qct8EEvG49r7EbQAih4ESFW+M3r2hs
	8FAtbhqQTUfdLaoL11HgbfDFsho=
X-Received: by 2002:a05:620a:2603:b0:93f:565f:e46 with SMTP id af79cd13be357-940ef97fb6emr1203588085a.52.1793049845808;
        Mon, 26 Oct 2026 14:24:05 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a78c06sm789620285a.35.2026.10.26.14.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 14:24:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
In-Reply-To: <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
 <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
Date: Mon, 26 Oct 2026 17:24:02 -0400
Message-Id: <179304984259.319828.7383468637599462048.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB16E1C0006
X-Stat-Signature: yyyqhkxrxp57ygtz77ue7t8xaoku3iby
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793049846-475019
X-HE-Meta: U2FsdGVkX19uUS4KmaUxfIZ0dNaqkGX/AhX/eXKdZZXxdHMbVzN7yHvmgb8S5amzS1YN3goOZlvOaNCGeoh1kt7Wcavxgzpe4IlOefx7HOLoyM2x50qQNGj7JDe/IUWgwGzfsT+S2E9E1nVYki82HBZogN/gIXuJE4nwSK7cUc/qX+J9Jm1pFCV+z58Grw8dqZHzxShcpNzAE/KIAkOrnTKLl+JWMm0LN/zCWkF2sb8yghVF/DN06QznedMCmPzot98TY08zBCU7gDsYT80i5sNcDyMJR/ygYoXu+7nXxtrfmOjaboy0RTrBekH60HbwNoYEtCKgX9tN0YV7IHnIRjcyveOkhbysKo/OVIF77+Lkb4pjQLHApgEUhBrG2FDTp3ipceQls8kX/EDPPxk1XPqWhbBfZ2l7jD0UTAMZYzSqKRucYlVCvzjHuRL2hcAwq3xi43c61R4qVU6Est0NDq2YMISnhFYbWj2zFGhzWdAVLwz8I+a3zwQmy1WrnyOB8LRlwRHYbUg2y574y81LgFY8Pd1ckStgUaY6uFRsJmL0anH+n36O+5WoyYfqU1KDJ00FBHTBUiRAlzoSddjdkvVKwz0j862YfrHNpR+7zTM9nXpOJEt7wINJypJ6PLPzNJPr+RV40ft7JzjtqycOC7VjWVtbAIoIez1yzai7Gp+KIzbDIRkg1q7LTq13vw2XDKNJhEAmSieO6o1WfX6SRelO8+VG5A4CqboBb9jkUE7RAkt9U4km7Dln/gkpvcAJbLfPfEIi786s0loD7oAkgj8k7NkkVWc3atZ++jrtRostAOy4rV8o5i3fH10xZnZWGNaUwJRKo+WdNiwitLqTNGGxpSx+YqCq0iV5oscp0aUoNJJBXuPXoc7GJ299230IMFDAj+HG/dJv+ksskKFKrfEaZaBzd6Eb0OLZJPHBloTD5pq5AtHb+LfQMuiCjVeuBGRE+2IYKI9y5yPa5AQ
 bxb6pMMx
 otYQto1mbQYfLg36tfJUH1XEcbBCk/kV+1F1aSYj4/NkKEIZ+h0ZgpHfX9pKnklSm8dYAvZnP/ZfP2+UfOPJZ+5QVigxiRW1SqEpEu5bqcZnxP8V2/gbOANjpOvO2mlUtVeqPAUBu/HBDZFlnTS22Ineu+zsUY7OFGKTo98NxNiABwJtJKJLqHmWWTQn6/DtUgB3c9jCBJYB3H5Bwg4RTj96CGnuJkHyclN7RThPwP2mhNMtylpiFEEWhP5fVWATAoxZg3fMeUz2xIgNeK4Bbo/nQ/yFx4xFkarMt5X4q2zvks3R3GCP00PH1oWKZX5NhWGxL6fKSQrACusy2/6KjzGDpMKv2IopX2+u5b3gLisWtfZIrxdOFWO+IYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-26 22:09 +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 21:08, Gregory Price wrote:
> > On Mon, Oct 26, 2026 at 10:40:33AM +0100, David Hildenbrand (Arm) wrote:
> > 
> > feel free to take or leave the selftests.
> 
> Thanks, no time to polish selftest ;)
> 

It's there to show the work more than to merge, but the long-term goal
here is to feed these tests into a larger session that does the polish.

Fixes: -> Tested-by: -> Analyze -> Proper Self-tests -> Upstream
                                   Or unit-tests :]

Usually these tests are not things we want to test for long term,
but they do help define the contracts we DO want to test.

~Gregory

-- 
~Gregory


