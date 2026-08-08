Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAD2C5AD44
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 21:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488806B00E0; Sat,  8 Aug 2026 17:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EDB6B00E1; Sat,  8 Aug 2026 17:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301506B00E2; Sat,  8 Aug 2026 17:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE8966B00E0
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 17:55:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45B9D40466
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:55:48 +0000 (UTC)
X-FDA: 85079459976.03.A33C707
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 864E8A0003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 21:55:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvzGuDIE;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786226146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIBD10vb1DwFw6PnsMzh3QUfgDMJOzsEKlxhhdBqW4Y=;
	b=Gy4RCT4dEIEaGPBrPMtWYUVOFWrYQjxClviMFpWzB5x3bJYOyILNDtF/rwQ6sO9vGsokur
	ryfv7QTeq211kfTKN12Tr3ljgGWLUbry+M+93PQj/fSGsXThL6jnz/ooCKyiiE0dA3BW3B
	zH/uD/7e1RwQwavLU8tbQJG611Ud/ms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786226146;
	b=QQTD1uPMkzYhauBt0NrMNc3EUAwMl/GzInClUAm/G26gpo8vx9N/WJAzlOkhQbvKPRddh6
	3sHLVr2xbQXjBfqAOiRgAPKsjffAxmHtasJGVNaan+GF+VQb9kMsmb8MzAC8eQfuW9R1Xw
	15aeVV3NdvC6VYCxdn5loKWD8gQT5ZM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvzGuDIE;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3811f512167so999471a91.3
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 14:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786226145; x=1786830945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NIBD10vb1DwFw6PnsMzh3QUfgDMJOzsEKlxhhdBqW4Y=;
        b=bvzGuDIED2ezeohw/38bJvhvIqhzzEWm0hGxZH0Wx0qLds/F1rutqwE8heOv/cVJEQ
         pUkn+jUZZqVu7+ACR/kcI56GuGldlVkU1+cOSrQoyfiF0bFEYwZ7/MwaxEGYc+RjqWO1
         /S45YMFHhLC7eGlw/gRl8Cnm/zZ0OWi+F72x/q8NSNEMpsadAAuF17KUE5g1pixNQMCT
         WoxKh4IKjOKMAzGnSrx2SXu2fdgLy3/xOyTmuUtB/M9ueL23vb19iSew4BBLPR9uET2F
         bAkMUp+9BerAsxRlssE7EY2unwi6qdLwZGTmb4xn4hx/dARZFPnLmGEi9CCSXY0A1oSm
         rJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786226145; x=1786830945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NIBD10vb1DwFw6PnsMzh3QUfgDMJOzsEKlxhhdBqW4Y=;
        b=lZlupAn8EthXh5pEphNzN82ImdOJ+y+NM71PFk4LNIDclIuugTF/pv6qTy/23uFU7I
         iOo/Icttuhnoj4V1s1OQ9E99uFGJDJqysCjgcnGcsSMzw4jp4TAntvpzu1DS2kJRE2af
         Dv1b0kZMdUcVFGKzr1Yvxh/Cw4CMfE6NVPQWTYMEC9vA48Ftxda8C6D77FmMkyR8qefQ
         GBylgfVvto4eh9zG5N6b3GrNr952FMc8hQ38MoPwxWrKDp77mRnCwrSwkpjASG1El4Sp
         EUKju9nkSyUeSGNL1C0S7tkqjtw4hS8zYYenijEdA0QAa5htnanl+xcMTrhW8HVXzKSm
         UIdQ==
X-Forwarded-Encrypted: i=1; AHgh+Roho8miYFBQv2vMGVFHpN5AMYs0JyE8jxN+4t23LibYCXnkJNjPDk//5Vp84eddu2NG/koZlQ3c2Q==@kvack.org
X-Gm-Message-State: AOJu0YxfxqrtV23PUHt7mJYu68CMzqR47HCdLRwjnxGGC8kg/SYQKIZC
	gnG/CBfyyj1ZKs8l+cRA+g+SKCzb8m8soVOEPxj947Ak8ppMjHAjtQQB
X-Gm-Gg: AR+sD10kGLHY44xeiFk14Lz7tnq3U0zQR+67prWKd+jRWSU/o9jVz02upTY41YGUuPZ
	viyZh0eM4/DLpcGSRQInYz7btXAfaeo9mTXQ0eBH1uJC0Srgy8AqhncqM5Md3JJPJKkmWuGqd7z
	jEY/hF3H6yceUId5hRGK96UunGOT4SWh50XIHBCJDv5fVBPjVEpMpxi14Joc9G3ZJeEWrEYpHfl
	OOSoNb/lLk5Emb3SMdi9smWNen6hTXw/0FtRI27RUgSyv23WGlcA6/4zJNLwEA2VZpB7JCUO7Hw
	ri4u6gfMBlV4hvfeNkOyvWL5fpJmrURmomIhD+mQ4pTbL9uXdGzPPzlg5Qf3h2l3fCBgUt/9Njx
	OMXCIp1gNe5fYaoRuKtl6j+SINgTrKFknc2JD2B1d1aptlKYiqnH6zcMXP+xtzSyihAZv+gz3rf
	4Pn+JNk0FV14GhIy+c4zsTepOt4zXK/AdhoGIrbqGmHir1XjYN1JjFk+mVh7vaeSXpeTFNI0HKI
	SN59HLNUDBX1Ks5iJrESc7WNfw=
X-Received: by 2002:a17:90b:3c06:b0:38d:e658:595a with SMTP id 98e67ed59e1d1-3903c54f1fdmr31877205a91.2.1786226145253;
        Sat, 08 Aug 2026 14:55:45 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:935:f4a7:6f5c:e816:9aba:2090])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be8a9220sm25317320eec.7.2026.08.08.14.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 14:55:44 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Sun,  9 Aug 2026 05:55:54 +0800
Message-ID: <20260808215554.6045-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807140739.91238-1-sj@kernel.org>
References: <20260807140739.91238-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 864E8A0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r6ryou7amac5zen8emq6oo5oabhzrz6w
X-HE-Tag: 1786226146-651906
X-HE-Meta: U2FsdGVkX1/3VdfX75H0V+jZUO4YOdHnybAP0UTuoVo0CUJ0/SZNemcZ0bQFQ+g0Jfu6DWjQBCtZmIqBa+q5KLwWH3P7DIw/vnr6jQ4HqHjWMRzo3axiCTk1OjESw+42uJjNKaxoKxe9K8eNLzBJnPORw1Z2zGNTH72H1QYM0W+LdHv1Mp196eGpYxUrWzLzk6gdPnObKSQDwC7HPzbGUdKUCsqYZauvwEWva0ZXOwpVPp9xr2SMjKWtUaIr8yNvoTD+JdfNondsACFhBaSh0KDViejRAx7gnW3bvX6chqowS25gOmnzlWPZYwJxwQE2zsANSbFmB16VIhs4ZjSBh010Gzp1zmAeznxS+UohWMGLMhutpA8aegvCBFUFqlzQOsUuXn4HFBeT64o7A+emTjNkBcs9J/soMcx8p18kPO3dt/P/Bgtw8ZrQQgcVDWTtBI+a28rMvg8e9wYO7nD/Oegc52vmvkj1nErFibYyFovnOeKKcNpkQWl8fE6m5ZZZPp5URrEAXd73EBCxVwegizEZHkbnbr5rglXfykrS90pQWHRZt0bnanzSfoCzaZNjANOtVSiK3sUklS5n8KQsp2wMuEQKibDkCvjTnkM8phqyHtBWgQ6jjR1F7id0bPPl12GN5nIvsc1P3dzF+WEh1hpvXVwvMooEjKsaMyzdagtwmerhVS+lLW6KN19HKY3asSt/3yFse2tEEIwQdwIe0mtXy6W9W8qsEgaMSkjt/lmSSb0PvOyuc9HKf5Afzmzf//G7W9Wnor8fxucKqWfEGJOhWjDKHCpAPeQl7hgAwvlDWqSqbeNmf/Lx2N1J9g90sDGqVIMsHqLBAOld0lRQCSXeZ0anXin4HFmzstZKEfhqz//TAYT+hBAXjb4DqxVjm4XOZYpV3JD165pQfjBbxwoRyFw0Cm4/+7n0wHUyZAkIuya0bST0imhfHrGdQmVLhuG8alvyxcTYRoadKr8
 mSMGfska
 tIlJa6ehooXzFOzk86OYyEHvpqhVp/eIWTt1CcrCpq+OSEguajZjTWJjvlbdEpYSJLBkNT5BfhGEGwSiAWP0h9IyMph3pBQmuWESeLvV+9+3QirmvuyVfOMkJIhuf3uHqebiPZBh6QNXwQ4B+fkiBrKFGy6CN4axPuc2Mes1z5jSyUhqyc36GZKANjykrFKbvFoWl5gOZNysTU0lPXfnElpn6YBdM9nr/+iYJ2kDFgqPTqU/Vob3zTpq0CqcpbCJhzdfPiRarZIsbCM107pvbHssMCW0YUlFrVPcIieIf4xBZKD/uPXmVDhnVW4CK0y7KxrbpeKpNkTcLQjMondGq1wQ0yNNvZAlAzH4kxR9MAOJ0j0HXlnhSBMRCQZeP1fjqlnwXFTNv0WiCCHJLVMyixUPL6FYcwTgIEPxZs1UQmHEUKvy8tUFuN1GnonJttAe6QZGo69ivEH6tPho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Fri,  7 Aug 2026 07:07:39 -0700 SJ Park <sj@kernel.org> wrote:

> This is an intended implementation.
> 
> When all schemes are deactivated by watermarks, DAMON stops monitoring.  It was
> implemented in the way because we didn't want DAMON consumes system resource in
> the case.  But, later it turned out DAMON's resource consumption is really
> negligible.  Rather, it is turned out that it makes DAMON runs with stale
> history when it is activated again.  Particularly, regions have 'age' and their
> start/end addresses that was emerged before the deactivation.  Those are
> meaningless and could even cause wrong DAMOS decisions.
> 
> We don't want that anymore.  For a case the user really want DAMON completely
> stops, we introduced 'pause'.  For max_nr_snapshot-based deactivation, we don't
> intend to completely stop DAMON.
> 
> Maybe the documentation can be updated to further clarify this.

Wait, according to the documentation and the code, DAMON will still stop
monitoring when all schemes is deactivated.

    static int kdamond_wait_activation(struct damon_ctx *ctx)
    {
        /* ... */
        while (!kdamond_need_stop(ctx)) {
            damon_for_each_scheme(s, ctx) {
                wait_time = damos_wmark_wait_us(s);
                if (!init_wait_time || wait_time < min_wait_time) {
                    init_wait_time = true;
                    min_wait_time = wait_time;
                }
            }
            if (!min_wait_time)
                return 0;

            kdamond_usleep(min_wait_time);
            /* ... */
        }
        return -EBUSY;
    }

    DAMOS allows users to offload such works using three watermarks.  It
    allows the users to configure the metric of their interest, and
    three watermark values, namely high, middle, and low.  If the value
    of the metric becomes above the high watermark or below the low
    watermark, the scheme is deactivated.  If the metric becomes below
    the mid watermark but above the low watermark, the scheme is
    activated.  __If all schemes are deactivated by the watermarks, the
    monitoring is also deactivated__.  In this case, the DAMON worker
    thread only periodically checks the watermarks and therefore incurs
    nearly zero overhead.

Should this be changed to monitoring will not stop?

Also this patch (0002) add a new function named damos_is_deactivated(),
it checks both wmarks.activated and max_nr_snapshot conditions, and I
replace the wmarks.activated-only with this new function.

I am sorry if my commit message has caused you any misunderstanding.

Best regards,
Rui Yan

