Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DB9606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PKdjYkAG
Received: by kanga.kvack.org (Postfix)
	id 71FF16B080C; Wed, 21 Oct 2026 20:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D04B6B080E; Wed, 21 Oct 2026 20:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59AF66B080F; Wed, 21 Oct 2026 20:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97E396B080C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:53:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED930A0596
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:53:19 +0000 (UTC)
X-FDA: 85348438518.29.A90FD09
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E115A0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:53:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKdjYkAG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of hanzhijian1991@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792630398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAnyIUkmbq6HJDHmZZfXywINd719pbGy8aLPkmBqx+Q=;
	b=CwZ4N8i/I6npbLwie3Y7tRLCKQnn4qool88+/nGE7C2LbDqQfXT5Z8qZwmXEwfLgDBRbqK
	adPhEapSGfvVXTIi1HRmww0nGdrn0KR9KfoU1q5g3VhFZYj2u9MkyHduphOaoGCIUhdXoC
	LWij8W0eBxDmu4zzYPj0sDCi8D48cOQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKdjYkAG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of hanzhijian1991@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792630398;
	b=lIGM/Vvy9sugg/yhj+YKz1+tF8p7qbxCk+KjG5P1m6TQF6k4DkFCJsr+ElZxQEhMaprGrB
	YDDDtpVNx2DW0FJGW72gDiRDPf9jbI2pzj6oHJqaqNU2xmON7tFj0I/WTtx2QF2bIw8Lxe
	rMZPGN5F2Tibg5oWA2o09bpK/LN9VfQ=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so458611a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792630397; x=1793235197; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nAnyIUkmbq6HJDHmZZfXywINd719pbGy8aLPkmBqx+Q=;
        b=PKdjYkAG/7Zhuzl5zMpvMe1GzJ4vHbWrEf+8hbEOqJawrzo89aG5J1XDKE/Oa4fuCH
         XFnIQfSFyjL1kVfQuDxoeojALtdCe4KM3k0py5TyFygnrUibR6XAf9JZdBFKQIxmbVVw
         GlHeiZN1XwsVmXH0oEOGW5FqSRYNXumVi8dPNLJGNZLPgK8Dg3wT50ru/4iXJ/LaLwC0
         7gLjUQv6lBDPcgu+F30QM4fE2jCs0zmr1RSJetO5UlH49ScE9mSZP3ScQMtFJdaZlWG1
         GJTcPl4K1xTTfUtaIf44ckc99Rj4O7Gm20IbayxDSPgP4zbkBMa/A2E5L+ehsdczSV6d
         J79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792630397; x=1793235197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nAnyIUkmbq6HJDHmZZfXywINd719pbGy8aLPkmBqx+Q=;
        b=p+pR15T3Bvzcw1YFZwvexxOdNLthYxhA9+5aMvitHeQuzEQXTjySNo4qcs1gELZ+xm
         wujRGJVXv7rf9ccELHc5VGH4/hQ5SdOmV5YrBh+Sfua5f0urgJqNSrgR8Mcy+YT4QgYs
         guxQsLA4Tsn8aV7qwZYSC/Uw4H6jXZUawPJqY/saBjL17ZTi4WnP/G/jUOp511kDw4ww
         kNIMMyHJos+CQfN3pSLgqSAoSvJwdx9ozAhrdAGF1K8A0QpmiJCWHuSczIx/Tf1YSMfQ
         IyKF6s2wh3P3QFovs+i//6gQc1FkAhV/vSqYY3V6HuxzmNHPVzCKPY9ktB4fnksXjstL
         mmLA==
X-Forwarded-Encrypted: i=1; AKwUvByKw5dvKPXRtW5RUa3uCz29Oae1p+RiQ1Z68K8OUqjelKnk0pC84LmfetGeFVZMsU2uE/exlOfuIA==@kvack.org
X-Gm-Message-State: AFq9FYLm109bJV5m969lRbR1A6gfkbadNy5Cy3kVUtJpdNdl10NQ1hZg
	3uv1VFq7xNGJpwymrvdKnDAykm+Hm9qlitk9lVtxlf4Fl9K0ty5jEjsS
X-Gm-Gg: AYBFou1pJ9od0D4eZD0HwpLSeHcucR4CrmumnRccsDJ+1kLmeCu/hz3HF505NpeYb/K
	Z4drr2j3o/LDovJYh2FU2o8+3Rlf801ywN1WrrLBPk39lULyZmgyBAhwKGXJ6Q5L/V8XFEV24FW
	or9KNYeButL4EGbQIQooWVkQUeeqeoZUXaFHDhlDOaiBCtaoRoTeBJ1kLDjVKyNjX+aG4gGe4dJ
	Gdv4qPSsrrkL+WSj36aU0ZGUAyEjBnOlC5sy7zjDK58akjys/84P5c1YpdRW+GsEmNBEXgp4SOk
	TneEaJhR3CD/2pcTD6K5b1oZVNqKbouv5YQIeoBQdwJaK7vUJ4tTWTuu7X3SlRpa8w3k3xEOaVQ
	Mv6KT0ZR24VpBt4Gfp9urpk4iSfa0iw/7CofYNnUd88ohie9KGio8FfuwUKqlxlW8QmUJfsWldP
	ZxZtGXbEsKxeGOW1yaJr7/GNOrT2CDnU0HMV0YDWosmsduEFrTrO5owQ5vuQG1YHo9GnM84+Knx
	mQ2sLJKis3UQipJIggBoOwBq2YI4uFRufIcatNSQBaz/C/KU1k1B4yYEHuw2icTOPE8Cjx820c6
	FJ6oI0kHwrV0mm8FHB87gdD/okTT1YMSAlthDqX0ffjo
X-Received: by 2002:a17:90b:548e:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3ad86f23619mr2983726a91.57.1792630396853;
        Wed, 21 Oct 2026 17:53:16 -0700 (PDT)
Received: from hanzj-mi.. (ec2-99-79-140-187.ca-central-1.compute.amazonaws.com. [99.79.140.187])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4896c4dsm1605274a91.7.2026.10.21.17.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 17:53:16 -0700 (PDT)
From: Zhijian Han <hanzhijian1991@gmail.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Nico Pache <nico.pache@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: khugepaged selftest: intermittent collapse_full(madvise:anon) failure and low-memory false failures on arm64 64K
Date: Thu, 22 Oct 2026 08:53:03 +0800
Message-ID: <20261022005303.750032-1-hanzhijian1991@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261020024116.2949892-1-hanzhijian1991@gmail.com>
References: <20261020024116.2949892-1-hanzhijian1991@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E115A0003
X-Stat-Signature: 4t9cqbnxazw89h9cyt1mabixhj5xgb99
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792630398-993562
X-HE-Meta: U2FsdGVkX18oFX+scg92Jzzm/bmL3JOvfzx8Dx7gASnCHDDApqJyNS4d7TkUqZrC8dNS4yvGrqRrHN+4XhVMchahG3+ojB2vUXA29hzrMsSN+DapA4m+ROHDjEtnpXEZKqAp45VWExu2Z/n17lVJpVgHVW3aP6k/+hi86ebLn2XfmNwtbS4X03B0ki3uBpOcloShOKI4KFepMMf1xFMer6FBGwwYzYcC3UAffJc4NmS9sUGEUjfpSXHtRW4xuMlVXscPxF0Q1ArNRB9vc3qb7jDW8snmwIN6walZXgejkOpS2opE2aAU+JPOqcxJCLfDT+nSS/EGdc3baoeyU39dFbc0VGndEzL6QWGM9lVrlChzF/mdjd92rkgAvQX/fJI0nDB6R2RF7nFbkB5VsUmsxX1NlKUlciX3m7EVfWobXyhtgNYEOW0kCMbXsCcL5eLiZlRH1/TmuDYQK9E+FyTP5abcJhzpXoAoGfw3Sh6fSae1k4A0TiG7d3MuiKz4qSBE87f3PhZt4+0guYdAtmie2GTkp5cCraQ63dGKVPA4ne+XYIqP8TXBJ8wVNiOtm96wCVHzqzrHoBxiXVF10TF36JwVocFjxeDTYLl4M/L4yr+nZKQMLGKs9g3Z4gzfvCq4DlBQCKVXaOI4JeJ9FetAkVo8rYhQUQQRTjnFwhes+GxodHYoJtqf+nbcRU1jnqvQZm/KO37f44deVH/LSaN3RZZZsKYn0YVonkHmov2L/C5MrpZceZ+8dAcm4X29hycyDxDp4XnRRf+bRWYM3mAysGpGe5NojpiCVVeEb34N2LoN2JfTH4qH+H0AzgkFGCk0+xm7NVKeonryBXUEmPadBubgIV4RPrYQMZIs8SMpEvn7Ain+4tkzvir2AyO2VdXHwBURa5TMKZ3x4xVwpnogmrqcdA44zQmO0MeeAyZP5p75QDsbdIXWWGLOA5YZQYpWNKjWpQTSi5OTgLwr5Nx
 rrcbRtAT
 0rSYz+7Js5FwIiwVHGgvejocSPApcjPW1+wE6f44e2W1i37N8YcXljSnwIovazNdOFvkhuQ5ckbkJ0uHEnV4sMb0rQmO+oriV/anmqloiXbTjbs32dy4VJSaT8HtjpJ+P6YnlUVW5+t0MSCzeYPxUCSn+wVcxhwP1cL5qYwtO9RJHB07vpUzjrX64nSrjoyDcqy5SQRA2sm4t/IClz1NxYMvmoOPXcI0+WlNO7MV+B2pX4wIK7BtYgGr54SaJambSy2UiXbNcJVZlKiZLI7nxeDCl3/pBW8792HkXhf8W2kVmpg1pPnHw0cm+X3KglrNpTmUVGDac1QEPkZkifdmy2m+YbJd00gp4i+6gBsbRIMY6P30UZVEIs4g26hjTo/UbiM3VM952wQFEqs9UhtgdxRphJ2aZnccPfLsqfkKWmIxpcbrhEU8B6u8JOb1pkaRKX0m146v5uQTUKJ5AXaLCNlPug1ppFlx+1qy+VsXxmDQYAnorBVJhSTfFyBmqSGDvH/DrldBNyQ99COlyJtosDPH7KkD1NIBb0FyQDtRABVMQxznqhkpZR9y66w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kiryl,

Thanks — instrumented as suggested: errno + thp_collapse_alloc_failed
printed on failure, then 30 full runs on the same setup (QEMU arm64 64K,
6G, linux-next 20261019). The failure reproduced 11/30 times and the
data does not point at allocation:

  6x EAGAIN, 5x EINVAL, 0x ENOMEM
  thp_collapse_alloc_failed=0 in every failing run

Per madvise_collapse_errno(), EAGAIN maps to transient page states
(SCAN_PAGE_LOCK/PAGE_LRU/PAGE_DIRTY_OR_WRITEBACK/...) and EINVAL to
"intrinsic" scan results — neither is the allocation-failure path,
which would have shown ENOMEM and a bump in the counter.

One thing that stands out: madvise_collapse_retry() retries EAGAIN only
once, so two consecutive EAGAINs fail the case even though the errno
table documents EAGAIN as "trying again might succeed". Could the test
retry harder on EAGAIN (loop with a short sleep), or is the single retry
deliberate to expose genuine kernel-side transients?

For the EINVAL cases I would need kernel-side detail on which scan
result is being hit; happy to run instrumented (tracefs or a debug
counter) if you point me at the right knob.

Full 30-run logs and the instrumentation diff available on request.

Understood and agreed on the low-memory guard — dropped.

Assisted-by: LLM (QEMU test harness and instrumentation)

-- 
Zhijian Han

