Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CADC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D1F6B0092; Tue, 11 Aug 2026 15:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03C26B0093; Tue, 11 Aug 2026 15:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4806B0095; Tue, 11 Aug 2026 15:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BA4D6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:13:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E96D4C01F1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:13:08 +0000 (UTC)
X-FDA: 85089936456.08.FEC1E14
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id D86C51C000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:13:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=P3W++ZrB;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786475587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13Kf+CzUR8iB8c2kAWJoRkeyyOq2EPKvK6cuZ7o6Qi8=;
	b=rFWk0XF5cZAyKqPR/VnEmvkNIFUkWImqbYtKD9hCoR2EijSy81OYxZMRNkEHLJONZ8ccjV
	08rBKZYDfpmIZSnzAd1zh1Wk+mvthdoSVkxFlfVwuCBTRgtBXqPgilLYF4s2jQGUgf9k+M
	PNGcLIqB756Lt82PhIwOVDZ0S7YXlaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786475587;
	b=0CkuLQH7xDK1fa3JM6qhlen90Zk/mjYg2VZ92GFNXC6DusF71Q/gGTs5w2a1od2UK/JqRB
	38U7KOdgKCEE8cev34ZTblPdaLXM4DItpQ8gsWqi8TpCCs4Is/kMw/mlaLel8y2jALQjY0
	0T4+69Ic03LlwBn1DcTCxxwioj6vPgA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=P3W++ZrB;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-529a1ee0e62so2349851cf.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786475586; x=1787080386; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=13Kf+CzUR8iB8c2kAWJoRkeyyOq2EPKvK6cuZ7o6Qi8=;
        b=P3W++ZrBZuyfOOCeGeAWlWSXy2kthF7w8cRxVlkH0dJfu10JBZi6FqBFrawOeexJSg
         kVbcoNPBo/MhblGMVzH2gEXyWCMfvNSIA7gzm0P6DRKRcBZhieDAjIA3A0L/NCeyHRUt
         uhYDUX3MqUUu1BbzxL/srvv3+q8oQo2+ciO3z1pEdgTYismvBSznOJ4yACCcEE7sOmHR
         QATKZhXzKxhlPsVIhDtpaGkFciKeFR49ATK7vmF4U1FpxTeIT4gcZNuaHk3vTi5FWLcL
         OFteGLIDTthoo9DIlLb7nQdUyY2OnVweatiM6DZ/Xf+a2JWF01ZZ9SupLORKVc0enSUV
         JjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786475586; x=1787080386;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=13Kf+CzUR8iB8c2kAWJoRkeyyOq2EPKvK6cuZ7o6Qi8=;
        b=LybTEKipLkZE1sUjZPBRnvENIogtjHvIIXL7esqgIfDxFUL+iQSU/pLcGz9/svMXdA
         +FoXX1gLRdkfkKV2xM2/FE80HxHcSuo0x2G8+an89U3j1eqGMe4kX+B04X64LbpNgDxV
         S7t9oGtM73hcO8dUrERCE4YYJbIhE6iRrh7h7SsRoy5vQTVwSdAVQRQe0aAkBscVMzkJ
         Bv4y/wMb02rxWOdupShVhTLcj4SLVMSrSZx0Q5TENO1BXXe4pcuEfCUH0YMZ8O9b+d99
         5l66ZDZjBNYG53bGSdAly3FA/x6Wp1Auo+xkdkIIZHSpEah+pxn5Q9IXd4KogeNRfE1a
         e8Uw==
X-Forwarded-Encrypted: i=1; AHgh+RqWcC//BdTwzdw6WYSY0sK83tupjpFw+O3yjWO0rjNham15AtqUo6TMX8E/a50m2Ao3G2lbrCIOGg==@kvack.org
X-Gm-Message-State: AOJu0YwQHS4lWChdd3XlnHKpl0/pNywoASvBGXXMr2E4/ch0YPHo5hqL
	rS/hMJ5isddQAvZspwkQeQLH1kaeirN/AxlZq3ydamKzvHAZ1XkE1Ik8WbqdP92j4cg=
X-Gm-Gg: AR+sD1002acreyEvoUtwIOjUWfQYEzrRBJeWGwmFEUOvBwRMY8bGOy2HnyCAPJFKbTz
	tH39RUJ1kOCTD44R8iX9+tYtOY8GeFQ4FWujRdM5Dlbba8WxO3pMsPoKugyU1u+SaqeeYTb7bkL
	zLKr3myhaHQsSqIc6iEVynxpxfmTon50Yy9zGWgBrh/KnOOizdXS7Lp4Ktd7FCP5OHnYaJ+kdSa
	lNqRzMQnTl8rM97LIjrhaFNYmmefgueFKwJQSGd0+I6REiv9CHvEql07S6/MVwoQZMDwOzGrx5+
	qQ7o6zHVNgQths3GJnkd/4mTQ0mMXdpySpqRbcq/ITGIGIwMiPmhYb5L9PO1GnoGRwLW0zXHyi6
	pS9VaW7YRe7VDsTi2jpTsLeLEwHlD36Ro9kUHMXzSGY0xeaA0673ox/1l+tBG0ce6qfPpit+kAz
	bHQpeSD5eDFhBt2IDD/yl3SGs1hzqa0OJSKjeWWEw9Zi1ywR6CStztNjyXZ9v1+8otyMTW+w==
X-Received: by 2002:a05:622a:c9:b0:51c:2135:b00a with SMTP id d75a77b69052e-52d5870ba14mr49521511cf.40.1786475585541;
        Tue, 11 Aug 2026 12:13:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3ee5d5sm5634726d6.47.2026.08.11.12.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 12:13:04 -0700 (PDT)
Date: Tue, 11 Aug 2026 15:13:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
Message-ID: <ant0P8xsljuhpV9N@cmpxchg.org>
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-2-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172156.356053-2-pfalcato@suse.de>
X-Rspam-User: 
X-Stat-Signature: nf75e9nsz3r9emazwjp5yigagkpuxeqh
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D86C51C000E
X-HE-Tag: 1786475586-658958
X-HE-Meta: U2FsdGVkX1+z/Y/8eA/L6BDH7dz1ig9RcTdnCpLe1ilBkwEjW5J4LfgAZRObRIqBs5vblfQwtgMeua2mCwUgOaq8zL0OsRMMa9BwIyYlPX1vom62StLwKkG1exAxbwSCzubXFvm9jEIPM9CIABcymUjjFxNdsgUSnZKH9QV2yNMRLEDR7yY7FlCCRbrDG5raG8LKg0tyE0exvCK8uPuTG7Hy/aPEL54m2yyYc6bmj++clj+v9Uw6QugMETKJnF1ZMxAdFmAQxgQTPLWsFGXVqkv0gSrEO9B19+QmHwjBr4WerM4WCO4YBnjc8v6u6z9TNEZIimrUEpmaYKTX/SXc9cHugrLvC+BAYFkjBUeDiLDEHAeKG8hRA+Gi6/fe8a012Jfgb1nY1Wnn+ZzhKlJ/Uziv6x64gMd+vy8D6o7mLELj1LtIfYDmeWzbJrRMtydOZHRMV3TRLgW65RKxUDwkCHsUOIQhVLoN1eTLKcThZPo8QCXS9oMpcdpkwjR7l7xdTAkMWOCD9WuIobaH9Cg3Vdg4X8oWCjRe0HompH4qd3DYUXfrmlBSOrzAni34KcEL/X9IyKfL6oKNZ79Y8mIOFrru5/+9viNa+5SwGh/wffVXND3LZ5WXuLLNH8msVV9eHvL4OGQ41vUYLg0vG37iKDHAQu/DCr/Ksdcxr5yzzk+yJZDWbGneJ5V8bFGq90tVYg9RpZYNbfCB2YcN/eDl3WbQ0ezDbqgt14AqX4H3cJAJnXORWLRH2XQb+okp5k+rDdfwwvqR+iL0g6T4ClsFURLlcEOJrWKIete8G/Xnbkx+9qF7tsv9Mso/rVOP2hKeBjRTNeBHTC9M/A2fOFwqkZozMAxh+hbK2YkGLQS9fSLGNXwJ9jrvn/wfrTPr6pHIZL2RIbYWLgFBQFbhaiCP5pOFd7pNPdtqsSlP/70UVGdG3IW60D/q5r3bpESiNRYqyl3HQbGGOchBmX2gNJ4
 qxJcHf9O
 2rSRWI2KtHfn4WD1h5vSHF2ZXIla5/VQ3gxQ4NM/VBN4ZkVRKIL/q6xyyM+t9HWA8KIHvTj+sJz7NtdNx3pDIHYyCzBGMgPLHM8PizVvuIku6A9e80jOR2R2TCN9iyBKN7RyxeZlTLOZJpWajdSckfzDQ3akzo9ajScQtS+enZhkj+UCoqKWyTDMK/BpMmwowsbiBLS45GEju5AZnwDNmIUw3MpJJvnyZnsaNP3HzZ0v5xYXPLX5/MMWHFadHsFo/js/0S7Pi/4EItlYLgS2Bn9GbZd5nmzwKwgfG8SZVc8hWkiSJAkNibHxmIzKeDpnc7UX15zpj2Meoued1NsKATjv65K8aaaLPVskBVDjlRQ5hxYWIf3o78LBsya7s+iXqB8S5Zj8bMO9Zut4ivn9QXmBDgRlM/fiuUwroda7w7yZal+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:21:55PM +0100, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
> 
> Do so. The only functional difference should be that the new logs will
> read something like:
> 
> KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

