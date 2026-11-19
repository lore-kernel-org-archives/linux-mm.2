Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376D3606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PTOj49WR
Received: by kanga.kvack.org (Postfix)
	id 266546B05F9; Wed, 18 Nov 2026 21:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217876B0631; Wed, 18 Nov 2026 21:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1069F6B0633; Wed, 18 Nov 2026 21:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6C0D6B05F9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:45:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1FA8408EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:45:41 +0000 (UTC)
X-FDA: 85450328082.03.A802B83
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9430720007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:45:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PTOj49WR;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795056339;
	b=m2g7M0vUeCSJVO2t1aQWB03p/077R0h0tED8m5PeCpadpByAdLQlAaYNpOPygm5LfEOnnC
	F7SV7gGqTIK6iHH+b/VyhXKuMEWf8N7pqteHNUX71P4xp1EAxaynwZIIJ/55cb67uyPnzQ
	qss40bRAL+76I7rYlvNWKHZz1l85v28=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PTOj49WR;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795056339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
	b=jDWbZ6UlmRRWFo9MSNgTZ5nNRlHDoOMGlgS55T3++Zhpm7t4u54QLKPQMlfwCSv0ol9S/7
	X0bE9u2yikoXt1elRtKd/FSSXbb8OmPdKGbtBBXiJemqoGfEqjAz7XVwDdxMNESWV4rXm8
	McjkazYmhC4IGGfUo6pdjohTLfbdBYw=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-921159376efso18382656d6.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795056339; cv=none;
        d=google.com; s=arc-20260327;
        b=oo0MHly7mpJV41skU+NC5KRApkjm+CEGFkHS1EuvnQVel5cmSHO+Ubd1t9oKWAZ2xk
         bFXBoTyTP09Eu4Pw/P8uqMfb7jNsXN481iwvaxIE6lGkH/aNTro2kKDzzEwUNgAfWxSq
         T7HFMYy1zJf6Z1MPHmc0XoEB+m2r1538lpuP4X7u/0HOcMG+gnYogkOon8rjh5VjeJZr
         NSWECHqnCe/C3VOu/XQQeZviDRBIXifim2KCLoJEyN9BGOwjc3zsfltuA1fw62BtJKUk
         cxOaITtb0Tu3tK3ZSRsTWsnF5AUxxQyk7WPeBZ0RgXKHWFsy48Tfv3gQ1j6V8AxtPgKc
         GObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        fh=rtD2tRXdQQdtUehzi2ZvqM8R6u6m8qOtVzTaudNkImE=;
        b=ZkkPm8hgWDGXhRQ6lOwhPlUGHVzQfn4sdtL8YSLNQiNAA0xC1RHM01X+Iou3E/aNBB
         AtpK1tVo83DbYdscnsh9E8MuriWwyLfJn5hCVfKaVVeQCWoJLdVQ4g4jRtvxCYporuuk
         bCHiSF1ABGb2BZFclpxvfy33fNfixK66KiC5k2O32L/zSL6rjHdkyV6piyJOXdxSMfyu
         D6fg4hLnHCMGSjqJ7qwx7hg5XVPXoS4Sf4CQSz/2k8Ld8/HSAxTuFRrb0yR14vy8NCn8
         NXRFfPjkNLZsgXYR+STUjEIMR1ad1omuirsTYGW+OyY5Gt1ZH2Um+gM4ZdmFgKF/PGKr
         YQEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795056339; x=1795661139; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        b=PTOj49WRAJrDms367RdG0kQ2TjHjIWOOA7va+R0sgt+YvVo6xmfO6kQKAgIuYOs9Vw
         RX9CWxhEWCgqeS1lz7KTFai6rCyZzheIEPlE9glEtCR6wFdCsIkBM7k7LCTHNTDWbeuc
         KTzVEIq8evPwonwD9gLJXq6zeuqEw3O4NB9VDIJ5bQn2eX/UWg+fmeL54p0QZWrvWEPN
         aHmGRFvHGLQeev6zsUIRWeSUqIwUri1+7xg+6eNLKeXZPCJcfOq6DPRYMJlJI9XyVuYk
         UzocL2o7zSgK73SABqjnBWrSH1Vimfl/kMHw/Cn5prBZgamp0ZvYUhAFR4DLT/F2o9lf
         ta3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795056339; x=1795661139;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nHE4K0vpamVM1it9uzuLpZzTtHZ4wN8e10RDqi3C1Ys=;
        b=0AsztgNx7z3sQ9/ly6Fr2gQSHZpwSVtFntgCJ4z3I6njKvXWmZ+GEZm7ojSUnkq+Cc
         t4XIBPo6GzPy43FPf/SG9K+lZob7YY1uLJM8etT5gNS8gBPZI0zTarqGemcmRMjeg3fn
         WjMi5ckvFI5FZ0XKuLZ6R0BNt5gdhBifFPVAkpnlNNZVXcLP1Z3fYq4ro6wSXC5pINie
         GDMpIkbNzLm1BCdxc0Sj5ABVMWOWxGghQHBlq9APQPGc26Xb3HlasueCvt/Xf+OgBF/4
         ofEqqXFFy3pcrwyaHNySZUpfuL7V2Dt4HBrrun2U/K86wh3RsLgZSLz4EKkCTCg9VqnP
         1xHA==
X-Gm-Message-State: APuU4Z+6a6FZwtzbVy5aUYHLkRVWcjBP1ceE1TFVIKmcv26gHHCSPZEq
	kD+NQC3DtXf1o2NjoRtxQt9eVYR1VLhNvzO9liiDCHTiNDVRhwB9DUgkv8FaOnZfv+ADCEkLp40
	RAM5aNHIeS2onTycVujmxuYdHSTOUKlw=
X-Gm-Gg: AZFdTZdoxfzvtcOb8bJqnGSF09p64Lk89Ae7YwIQczpBVhTGE0XMaz1hNT0hgWsowFB
	Z4u9RbqC8e2jZ65P4mQUWEZlAsl+bEAqkNOoA8IV9Hx915n8XbhjmePd1qEBrPgncXp35f28N/k
	wsK6CvGNYiDUlYQ347T9fPWt10aMrjZQ27/VDztQVTqJssjnuqO9Klzmq6FRFu7Wyxs+JRCBf3Y
	j4/IjlqYpEydNW2y3awtlxS6QsEOl8m35AEX/C1vck8QYfMsfO8fj909fuZ8hR/IBrH3LLIrF9Z
	4vaqrpnoKDoBkzzL4EQ/yPrhkHx4e5lMLk0Q68rqMl+nKVbszc679hM0XoeQbXBbbVVjZ6Q6lNT
	cSul4Y1wdrC+NHAThCz6NugPrpXY6SLZYaHsC
X-Received: by 2002:a05:6214:4509:b0:91e:93bd:17d4 with SMTP id
 6a1803df08f44-92114f234d9mr68688036d6.31.1795056338595; Wed, 18 Nov 2026
 18:45:38 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 18 Nov 2026 18:45:38 -0800
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 18 Nov 2026 18:44:56 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 18 Nov 2026 18:43:28 -0800
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Wed, 18 Nov 2026 18:42:52 -0800
From: lianux.mm@gmail.com
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
Date: Wed, 18 Nov 2026 18:45:38 -0800
X-Gm-Features: Aa3M54oczcrQgnIKIdlWRyAqAv-8pL4r_8Eu0gOG26vA4iWYOD9SKwZ3124B0Ic
Message-ID: <CAD1ZK4Zo_qQf5aJkVLtoc-LXM9XbyZd2Vy6rFvK_fih-6FE_EA@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in lru_gen_folio_seq()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	muchun.song@linux.dev, qi.zheng@linux.dev, ying.huang@linux.alibaba.com, 
	chrisl@kernel.org, baoquan.he@linux.dev, nico.pache@linux.dev, 
	usama.arif@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, vbabka@kernel.org, surenb@google.com, nphamcs@gmail.com, 
	youngjun.park@lge.com, ziy@nvidia.com, gourry@gourry.net, willy@infradead.org, 
	baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, hughd@google.com, sj@kernel.org, rientjes@google.com, 
	yuzhao@google.com, vernon2gm@gmail.com, wangzicheng@honor.com, 
	chenridong@xiaomi.com, tz2294@columbia.edu, ryncsn@gmail.com, 
	liuxiang.277@bytedance.com, ehab.ababneh@intel.com, 
	zhaozhengzhuo@uniontech.com, joannelkoong@gmail.com, kunwu.chan@gmail.com, 
	hui.zhu@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9430720007
X-Stat-Signature: zmhe3ssrhagu6zqengucrip3c8f9q33r
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795056339-309625
X-HE-Meta: U2FsdGVkX18cAcwdM8Cl048l6osG+VyGjOi13WnMSC5JgmmgfQCmanr3gEb+Kl/HwLFh4iwNQ1qSFt0dXA7YD79kV1C3gxeDwLDv5p1DQeS0ojYoqxRuLVF/41LBEV8RE3vsLmI3bz/YFAbm2RNfC15PCaZWiFCOJ6ZWJ5g3ZcY4lsTy0UN4eqi1kdrMHBZKtitHBh271eLo2IcjWuccHkZgQVdddq44YjAyuwfNtJ+MB7FQjfESMezeJx1x4fMZT8oJz7+DUrTAkphn9wivUSaFzUVClYHQOfzLC6gvtY3qw1oFLcecf+t7NFSnxNOpc3wT1qq0Wk+CQ7znWUqeexQECrRMH2R7FUWVtECQMRcCj2ZIaiA9kPFmArOMFJMmiLhzaRNANt59tPwUsBMMucvHhDT9N228nbwGLVh/r8V8ghid56K5V2gSn8PdjO5IBPQpxSfgwm1Wm0WIYRnuCEqkl7a8vM7SfVsUOLJWaLyP3g+3yFXCD69H4MBMUaxcXws92vXWaqK0GMVMTNGgfE8VbKEb+syaJIZXaetYPIcuf5vjsFFqp0sB+uzJRUTVUJ0Bl5SJ5Jjvz05LZIywmXOnvd36Lm4MfFti6S7Qv4qcNxgDnRpdMX+JNOZfPEJEcc3JV9m8oj+G9M1XJAfYet4LXvcXKBuar8xqbqDthzl8axaIg39ViTUWzX7ohFLydfWOA7Yl0UAyAAYngysDEkpJjzwhmWFJvsARY+Cf0e5v8lsLeKjb+DvuqYug9mIwmwgLdkpaz68Qdc4bbTTH/hQ+MrqmX0FlkGwFGd7v4Awgd4mRfzziWEQwQqz6P3IReYODXtjPmqns5g8If6M5p9SjjQEuIRR1GaWzcexxokDFOB6c76NNZKUsIgx+X4LdbZWZnKwFETcAaGOWUkE2UUipar6H2GzLOEDz85uyadNum++80fEXoqvsevVRSnSKbjLlH65Pxw+BFeOA7yd
 HI9YZMWU
 yzDN/P5R02jDgy24vRDXRG91T9RBqzIoiocyRxDxZ9oka0OhPvScbdX3wSqnbW7eGG+VCMI5xTRwyj84Va9DQ1bZohyn/C1g4QxXgD30CZLa9jfL/kQn26+d11bCa/qEnunqRciQOQHD8exwVVi4Bqc5C2hoQrUMiuxvPVlEjlbfMERuGennF68neGScVoauK/ZIjwDuNt5VYIM5+3Q8mYbG143Op/v8DWe1y/x1Ks9YfkoUMb8/zIu7nCw4TGB1lj/3T+NFyuBhU15xhy9geV356N/u5szja/f2v59T611ItCTX58U5ochzCBe0mOgz/g/h4KbG/AuFj9G6rXDLCsJPNz8EuvIQsufNIWWGfmdfTnTaJ1vWvB34299R+mgrchD0maX4Rcw5sZD4CUlxttY+1m870wlr3mn7ObW4qxtgbnvZvr/o0FNCIdIGwxrZkALHjOa37edQbsiB0Q929zb/vGP2eMKawGyQF06X7CZJGFesG6x8Pxh6yYYDnxdIKvOwHeVDf4mlEhW3Y8bOGHJAdlPYeWOHACzbGdsZLP2IH1FzGxM0oZB1RU5kyJTUVhNmc6HwiYm5QW6b5PUawuIzwJbLUSFeUB51nrojw3Bd/TyCH4j8A4sWm6HpGF6tjzRIrFHy4pYWSQBM33wrOLKdEGTkiEafhOnVE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

