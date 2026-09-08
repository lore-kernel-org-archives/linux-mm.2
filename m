Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3633C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88426B00B1; Tue,  8 Sep 2026 12:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FED6B00B2; Tue,  8 Sep 2026 12:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75B06B00B3; Tue,  8 Sep 2026 12:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 952E96B00B1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:05:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 173B11206D7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:07 +0000 (UTC)
X-FDA: 85191069054.18.81E01D8
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2BF14140017
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FGZErJEU;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFc84YmPQ7APJ72znZItLC1opm46HMB1M/+k8Tjpgc0=;
	b=NcU6HeE1+O0uTi/BAJZX6jAi2JKF/pHhPGLqgXw7Qb0dX9Qr1jRUhfOcWi5DzTeAftvmEd
	M8oWltLuIBr/9aGcKdZIXHNhrQFF5ZH5DRK5Vj4YjArdAq8hYXzL3p3cr/TqBc5AwOY1Tj
	eRhTqbxMkzZngnyfhb3EnV2LmCClAFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883505;
	b=spX/HGtNiddLJ+sgrgTbcbbgzFblSMnXQuR1ubd7jbQkQL4fHIzyD+jJtaan0GMgKyla0r
	TXpMACSQhPOoi5+XKQkysrw8GOriB3di669yJT6lsONX6E9F6MOhZr22VIJzDri67yTLwT
	c2rL05+RIZvy6Em8UhURhYLY3q9YCDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FGZErJEU;
	spf=pass (imf09.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8620ffc9ec7so179930b3a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 09:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788883504; x=1789488304; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EFc84YmPQ7APJ72znZItLC1opm46HMB1M/+k8Tjpgc0=;
        b=FGZErJEU3iXto+6KzNrf2v1nt6WDeCGX2ssazY31owZRtDkveZVpTAjqwjawSUpRan
         ZQFND2YxmBL23frDOzgkVneYvSOmjkO4NEVIMgyXHnqrWiqlxvqezau5ip1tQ16nYbi4
         qvlViJuWdMKCsj4AXLqK460jvHnBwzyqt3+LCyqvq9K1p0di2WnFCo/m1CfavMl27rVQ
         H3FMZBAzG2AITSHTNq3xK4GnVjl++b+r4R/0YMYGxyaSWQ7L+o5eiKHFnP9dWQRoDiIp
         PPv9K25lvckCZ8lALPcuug+vxUKT7qszE3vVAbRerC3SJDqhaQtLUUvQGd2TQ4zrSXzF
         y3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883504; x=1789488304;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EFc84YmPQ7APJ72znZItLC1opm46HMB1M/+k8Tjpgc0=;
        b=LNWI3L1/P3VizXfZvy3zaiGZn8KDZtFXXn7oZ6uVMX0uMHI6zoZC/FRnwK0i43bJwx
         aqgHwI5jJ47ivaIuvocoDAUQiDgoJJqlJWpEvZt2jcQQsAGjoiD74uT6wGUkVlxHzxrj
         zhDZE9DWqSMvMOlbHnDlMfbpG5NB3tj8Lh8xdtxG6YA5OQ5hM3+fm/DkmC7H1EVnMnP5
         E293mMaE9SKBoeFPvL22CFecfKU4pHzMbXhnxzs1ehZfAuS4K5NXES7JitOx6Geh+c+B
         h+ABGyzX8w+8JXA9ULgt2RMql/pIiiHdd556RfQedTQEGr3ePN0Db0nUrUFdS0dr8bxa
         ku8A==
X-Forwarded-Encrypted: i=1; AKwUvBzOiwcYL4cRzCAuPGszdMWQuva6Bl3YNVCWvl7c5vNyzyJ8JcpHba5nqv6BcH1KhPNwQUGlCb9cdg==@kvack.org
X-Gm-Message-State: AFuF++kqm/E8ER3yJH5E2KAy3OrXsOoJwSlfQjaZ4FkQQijSNF8jr9AC
	nqEqdBuWILTacZI1aIndALDHyY1mHnLVWxdzCOq+DaP+ABHq3VPfgYjg
X-Gm-Gg: AYBFou181n+FBGCiiB3kYIvjqbdHqyGcaBk6vNppQaIbO5YNZCa2E51tWKs9O1TRMcn
	JPWM2oz3z8lnNRrwW0voCu/k8yeP0XsfwYk9D7NjOzeRD+W5llHOC8Wa06UZMXPqF3Rtm1cqAwV
	MU40QOmvj8SE4vxp4n07TNwjNnkw3TynU/5xwQC/FPdwFAo1/tedsqpMxUBdjbd0visdKo51Ek/
	fp6lHMMM5aq2lvwbSmpks8zCR6m5qdH6H2Dl5PkOIuEe6McOzjPILP6r0DLo1YbeEzcTnq3yp0j
	n2mx+/xrG79TppT4YnVFdK4v6DqI2ci3MlgSdjCoqfAeMNDdblY03dz+h07yceCOedlCkMOKm6d
	g40ZNDdVewTQPpC5RKY9W5NyLSuWezPjstHJCWwi2zeU2Ji+TEP1oh5s/4uMjPisqJmwBPL/i8F
	EPy1/0TgyIaF5O0T7AC26J4NHUR0XOP4PSW1h3aSZm1MdsW2S47pk5ESwHj3bt1Ze9Fgscy+9i8
	hALf6pTFyilkveYhLbXBRTW6A==
X-Received: by 2002:a05:6a00:4787:b0:863:2fc0:4052 with SMTP id d2e1a72fcca58-8632fc04106mr12652769b3a.2.1788883503595;
        Tue, 08 Sep 2026 09:05:03 -0700 (PDT)
Received: from o6.lan ([240e:391:e05:8d20::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153027951sm5767881b3a.40.2026.09.08.09.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 09:05:03 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: surenb@google.com
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	david@redhat.com,
	willy@infradead.org,
	jannh@google.com,
	paulmck@kernel.org,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 0/5] read proc/pid/smaps_rollup under per-vma lock
Date: Wed,  9 Sep 2026 00:04:52 +0800
Message-ID: <20260908160452.1548235-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907063918.3432401-1-surenb@google.com>
References: <20260907063918.3432401-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ards5cs1fifat4d7mfhss8y61ya4y9zy
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BF14140017
X-Rspamd-Server: rspam03
X-HE-Tag: 1788883505-631725
X-HE-Meta: U2FsdGVkX19X49Hw4q0F8zTsSPYjqp6bjeDxZGRFIPP0k8uEP1tf1KXSyHLOVZ8Dd6sgUcuWNTqMTkQGObYQ3L0I+5+TbqF89RpH4nCnD9/8fphZcnsVas9W14UtkABrXKtXVHZ30MuPXi14JyU7Xj7JghHctr+hjIK4WkfsWfxyRvVSW3cVJdnYvg149/ucpj3iQC4hYsJT6cllUMHH12gbCeSjAYGkZrFVrM+a4RZAO9Tf9vfhlmFATpOZmssqt5x5wgpAUu+/y6OzUvX++ObPrhBXFWxibyia6bg4cIqPeWzt4QEx+qjNHRouRGK4pcnGsw8ekKjJMVJO1rCROe1NUQ8eF1lRFowuEW4zWDMcFfOIBpD0t9EYWGOzMbONF3oA/M8fH429aGsqBGFwFTRSAmlDjA2wxTt3TE3Yxwo9+YHuZlRdamBr3QglVXrHTNEBALm878qSbsVMw1YejrBW4tqrYSGMW0DDbLmnxxVrN2XQbDROw0B6bfDLLpOnA6z5plJeNa3Rg9ljlwGMuRhb/hUi/X+l0s6y9Cq04Ek5hd/MA3bnSSfaKCYUKNei+pzejo/Yvpn2yrW3LJFZXcEghsZOfGqcZZ6Rb0M8qFVG+idN0MaKys7mhPEEDXIGQrM4+6N6fmG3YKo+d3A/EX1ewk956ygwZFRE65ck8YjsefAZZHowCotz5kK1eEuwdtpMXO3/EpnHpSBN3oACOvx/sOdVEwbCJBETV5qXZjfRR4Jox0s8FkJkzzO3T7eiNl6UW50eINJMVYvyer22vom3Bk0e7XZ0nfjUr8yjt+PIrUoFMwyUOWzE9V5kmXXWhitc5hP00hLPQZ6RupHV6lKi87+8eHsGSvr5Ux8Hafige3WC7f/zI7xBDLN4wDSRE9Youq4HP6kyl+RlqwtcCsnDKCtmrgFZ6vexmKLRWzgC2ju9ll3eKLh8PoznC73m/QbJollyoWsIlpOEPQV
 PwP02qDF
 CkkDp+Giz3gnj/yye5kZV6d8lxofQ7kcjfgRN1BT80Gfzj3CHjYrM4pjo7pFKCiyF7QksEqEmhC4Oav5mEwktvaEttYKQlfnPy5E7mtBvdXk4+wCvl6bzzWAhBna2cY8cX98lLfVRk4GEfs1IvU5H+b3ijVgSE8G8lEh+7MFG5mfxuGFyxgrOZlcro5ccW2paDAvg58Iw4gvUqfIXYIE0VitLZ8mmC5SvAA3J2swiG1YLky9LtjOk2c/LR23ZEwEVsWo4k/FRAYvx6DjWwRp4Sxfd+fBmhZZsFUX7xb2R1FUOoLQIIpawl//It0WZlIWjgm8qBRcZiesa5wRLbc6vTV08JcHkhqKJ3uIzw1pKFt/2Mb6WGZM4RtXqJI7pkxpMY/CGW7uLu076cO6Tn3mThMs7s17dQYcq3nV3W/hzejk7bJOjRUieufO+3EBFbQcdCccCbZdAqYCozeuPXd6eoBoTsKpJbkiMCOS/ocGGmbyPzFzEN9QtedM5rdl4VBPto6rMkpGTiQAaF29mCjAYXkd/NCZdT2H3UZdGfJM+NfDadyNQdTqZ0r+sVuwiETe6jXMx9Wyxs+jbH0rCzjeUXb3cSgklzXPNtEHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Sep 06, 2026 at 11:39:13PM -0700, Suren Baghdasaryan wrote:
>proc/pid/smaps_rollup can be read using the combination of RCU and
>VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
>required to safely traverse the VMA tree and VMA lock stabilizes the
>VMA being processed and the pagetable walk.
>Note that we have to keep the logic to drop mmap_lock on contention
>because even when using per-VMA locks we might have to fall back to
>holding the mmap_lock.
>

Hi Suren,

I tested this series on my arm64 24-core machine, using the same
command:

run-proc-vs-map.sh --nsamples 20 --rawdata -- \
--busyduration 2 --procfile smaps_rollup

baseline:
  Median   Minimum   Maximum
    0.132     0.121     2.600
    0.132     0.123     2.768
    0.132     0.123     2.804
    0.132     0.125     2.835
    0.132     0.125     2.837
    0.132     0.125     2.849
    0.132     0.125     2.858
    0.132     0.125     2.888
    0.132     0.130     2.894
    0.132     0.132     2.896
    0.132     0.132     2.915
    0.132     0.134     2.921
    0.132     0.134     2.927
    0.132     0.137     2.945
    0.132     0.141     2.984
    0.132     0.246     3.004
    0.132     0.270     3.381
    0.132     1.316     3.533
    0.132     1.321     3.551
    0.132     1.343     3.924

patched:
   Median   Minimum   Maximum
    0.006     0.006     1.950
    0.006     0.006     1.955
    0.006     0.006     1.955
    0.006     0.006     1.956
    0.006     0.006     1.956
    0.006     0.006     1.957
    0.006     0.006     1.958
    0.006     0.006     1.959
    0.006     0.006     1.959
    0.006     0.006     1.961
    0.006     0.006     1.962
    0.006     0.006     1.963
    0.006     0.006     1.964
    0.006     0.006     1.966
    0.006     0.006     1.969
    0.006     0.006     1.976
    0.006     0.006     1.982
    0.006     0.006     1.995
    0.006     0.006     1.996
    0.006     0.006     2.043

So the median is 0.132 -> 0.006 ms, about 22x, and the worst case
drops from 3.9 to 2.0 ms.

Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Thanks,
Xueyuan

>The first 3 patches are cleanups making later change simpler. The main
>change is in patch 4. Patch 5 extends existing proc-maps-race tearing
>test to verify smaps_rollup content.
>
>Changes since v1 [1]
>- removed helper functions which are not needed after per-VMA locks
>became unconditional in [2];
>- added a cover letter, per Lorenzo Stoakes and David Hildenbrand;
>- removed is_mmap_lock_contended() as it's no more needed after [2],
>per David Hildenbrand;
>- fixed typos, per Lorenzo Stoakes and David Hildenbrand;
>- refactored duplicate error checks, per Lorenzo Stoakes;
>- eliminated special case of start=0 in smap_gather_stats(),
>per Lorenzo Stoakes;
>- updated comments, per Lorenzo Stoakes;
>- moved original comment about 4 possible cases when mmap lock is
>dropped into patch 4 changelog;
>- added smaps_rollup testing into proc-maps-race test.
>
>[1] https://lore.kernel.org/all/20260606015729.1837935-1-surenb@google.com/
>[2] https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.com/
>
>Suren Baghdasaryan (5):
>  proc/task_mmu: remove unnecessary helpers
>  proc/task_mmu: remove unnecessary inlines in function definitions
>  proc/task_mmu: remove special-casing of smap_gather_stats() start
>    parameter
>  proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
>  selftests/proc: add /proc/pid/smaps_rollup tearing tests
>
> fs/proc/task_mmu.c                            | 280 +++++++-----------
> tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++++-
> 2 files changed, 291 insertions(+), 176 deletions(-)
>
>
>base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
>-- 
>2.55.0.979.g7e5102b832-goog
>
>

