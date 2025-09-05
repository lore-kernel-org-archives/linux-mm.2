Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D06CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919EF6B000E; Fri,  5 Sep 2025 15:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3556B0011; Fri,  5 Sep 2025 15:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7444A8E0020; Fri,  5 Sep 2025 15:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A73C6B000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C6AD1DCE08
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:06 +0000 (UTC)
X-FDA: 83856149412.20.620C314
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AC7D1C000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JldCxGcT;
	spf=pass (imf20.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+kpXVupuNFcf3FddTJg7lxWfMT+iAwMf9hSE3P7sk8=;
	b=6uITUEzUPd78aZ5Z2Zv12pTM+e7tp+1lqWMEeCdx/5fZrvbTG1hSBzP6Lg8Uv/nbj6fl3X
	p4cYcidMLaSIX2RJN/3KaPtlzpzsj8ruHXkqo0v8Y0tHBE++aWKnlCcLY0SDYyQ0H5HwXC
	M4fuSrZl0rmz1SvdhluipKKM+9rRMSg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JldCxGcT;
	spf=pass (imf20.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099704; a=rsa-sha256;
	cv=none;
	b=0HhYJ9HLqtUfE1nn/LsvrnA681U6WqMZEluBSvpWA1aOl+ZMN0S3ZZK6fXCKPxVkBmBO9h
	hugQeaTUByafWf+4LBMC9nkdGPkTJZpxl016mqHmHgNGdZYoxqtYXlW9wmZWFGrODldH41
	sh0YDNX24nKnun8fmmdGQxHaH5IsuRo=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24cca557085so225ad.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757099703; x=1757704503; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s+kpXVupuNFcf3FddTJg7lxWfMT+iAwMf9hSE3P7sk8=;
        b=JldCxGcTZ9mWUzmIEXMeIjUL3zP+E4cvoIrTw36kg7gwPKz4mkxsOYXk1Yz8SkeANj
         Qi1XkTAHJHNaS0sw4Zy2xv5/5Qlt3zB5D/3+LtK1D/S6nV82kdtbfb5tVeLj+vllfBev
         CA7jGTc2/PYtO8xIcBywqDtS1SXLFLK7Vp662EKWovbcU5R7Lp0Nem8SWCjDLu/PUzkS
         D0QgXuFnjZna1tYxl67y/lTH+neej+WkqFkdNVL4D1UxHRF+8DfFMpanmtC1H405xl6V
         mzy+UAfiHMD34FJa9TjXPwRa+hK/Tb87/PwhoTDQpDOtAxi1nRWPQJTug00C0BsmtJOG
         SS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099703; x=1757704503;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s+kpXVupuNFcf3FddTJg7lxWfMT+iAwMf9hSE3P7sk8=;
        b=rI9fQOrKaXF4SLdcWC6kEICcSeoqzP10SAmih1gWUGquAU1m58DE19nXhQyU+K3CWb
         h9s8mf5jIEq2tkTJh0Pv+oh5sTAOF5jfmanNWQJWAfBUXde1y9VCeR9/f3btLRe/u7RO
         NXx8dBN3mIWUyhPt16T+dZXXF9kcVegCsqsQPh0mFmdg2KhdjGbJlrhHTR+iy4nQ4XAm
         pCt38fbEb7ulPa9nWimDxE8MEyB2Ykyz/sTIV5BXVP29yV99r4+zfXVp0xsdTh+mCAoT
         FaaCRIJ+uWKa/ANENrSbsBgvqxwrYLK7NRWeu3pdPpy8kf7GPTTkaiCK1PnT1QZu/WOo
         crUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLpTrC6lF/bA2hpsw360lU7iEJXEnJE/OAj9mnkb/gJ8uO9FRn6aBb7jzT8gHiAJyYhVtiL0e4Lw==@kvack.org
X-Gm-Message-State: AOJu0YxKUIiE5RyeTcwtNvrjOfujwjaxc33be93XI06VkgsO0ZRfmkjc
	rT/50aXJ6YsO/toqwr7UT42kH8w1PG+0GAtEOKfGUH5MPfOP7VZHPkkRcryxgXuiOw==
X-Gm-Gg: ASbGncuTs8OmskEaDH4Z+BXbaccldwDZ+17OHRs1uIoephxnok1GilJbKDRQndsavYG
	uB8JXZzBQqjEJXEEH1Yk8q1YxOUJR1izEbLdcdKrekCekAGbCRZG3j+V8hvTvwQRGueoJ+csjru
	8QhHJjF+PMv9JpWZ9szAidHniorFV2MDrxH7FdH+Loh00qNIl5W8DJSUKYMzviWeSWHNeEyRnQX
	6edab+WvuGgRJQIngJpaMyCkKOt886/2mnmPeJlyb/+rJGaRWeeYiEH6x9x33+AuYXKUEg8oO9T
	EMJtuTH3kZQkWZa+tbv73WUuuHgv6+8Yn98bOroeZZpceAlA/GWT3f46qrLQQB13O+Z0b+/fgu5
	byQame9Zu/V4eKBI1YXc6NzrC/nNrDY2z4rMsrO+tetiSMfuSObNWh9cDZQooWLvWMf9EOlWnDj
	PImg==
X-Google-Smtp-Source: AGHT+IGrTZAo1Pwzq4wGeEHaAM4ResrlO4dBNEf3yV/+ZqHKlvh6siKtNSeJxQFtJyxYZtMnaM2DbA==
X-Received: by 2002:a17:902:f682:b0:24b:131c:48b4 with SMTP id d9443c01a7336-2511e4303c0mr369745ad.5.1757099702858;
        Fri, 05 Sep 2025 12:15:02 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a090c77sm22449850b3a.0.2025.09.05.12.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 12:15:02 -0700 (PDT)
Date: Fri, 5 Sep 2025 19:14:57 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <aLs2sV72B98i3i1Q@google.com>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
 <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3AC7D1C000F
X-Stat-Signature: dztpkabehqcifgydwmetknof3wh9w5pa
X-Rspam-User: 
X-HE-Tag: 1757099704-89004
X-HE-Meta: U2FsdGVkX18qHGgeWyVAZ8yiQ4VASpKZKoDV+TeH/2Jnkw1gnuz8iZem0anflCyrsjiv2noVC4QzrLjd8Sy2M/+CV0FMnoohrhCp+ADfiQOckqVBMwT84FkPF8FEq82epKHSwWuFevFkPBaBO1wAUOX60Ce+k3qT8F1PrcfXM+lC29agrYMjB6OGpieDAT3OmtCOYXX1Gv+TKCOThPPhOZAaV+YNYRGT/ln/ydJYOPuWrbag+7ppW1ebIKRuWFdzFQ45hKtixNodnxEWe9yag2n4Up5Q67YjOD0FiGqX5FGbHwK+PTCrsMHvfqVSTdP/zcZ6/ogN1SHChtSGC0PiiI1tsvcHUqdRDOpFrxgOL+ILJG/+YIwU7GDC7Lx9BzOvj8z06kVGKf4Vr40wBWCI5hISKkzHp5pWML+s8us/4Endq9MaBZeZaYCuVGBUU9uuIm+3uY4vUuNsoZQroqL4V+lU2kQXigGXuY1v5cvV401dk7aQOmvLpH27+I1tzpz0vwwRXSvGVJ1TWgMEjvuYtadqmDsd1pmJXPE4HddKU3rFuEz0BhJs4ivcADyDCpJnBvk/yZlQ+dWB7s9YmzRA2KOdVELeHexNbVHd4hniwK2265AZWbTw7Sa+TaovSouHI4Zm1Lq5bvIESjJ8bAvTMJY0T7O8CthjN+qCX6vW2+jnmzJg1mY+1ZulSYGlj8s2fXbn13Rqr6hubCypLY2m4UnTHsuiRi2krns6kJjcHPWAiyVYbP4/znqYsbTEkYl/JIEsHIuv6dpPuWzOOnSUfXsDvYfpgvCTGUty49ezMuGw3ec3v7ihkUQOWxRaA1avsDm7VSrwJXESsBsyptwDfeoGl0fVkOOY+Z2c/d8caALw9x0qCnTN10/M/fPR4F8KrsMPAgM3F0AsIxK+E4b8JHQKAGx4qNYx/o6eoWhs1qgfEcEVqz25IQNhf0DlvEO0YH0oEDfJnWt46U8k9MZ
 TXLItImV
 J/ZfQ4Mq78cn/X5CSvYsh9nr59OqtyWpxDjM79Ync3iPt+/O5UmZpYtWWTOQUzZRZ9fp8bxIkb+8DlHAVXNufvB2YqwIdwJH2PX7p2Zw4FDjbzYAE7KtLVNlAiGkQmMoIefBztHkLA2zN9vPWnnyZcprT3WvWCoz0iWjGrGbKseAu88PpDi3VdA2+YUESqV/dsOKhEPbgr5G+RDc/Uqd87PIr/2OrVF2nDCZk1yNpwF8dYBwscyO/HPHjtn/FgMMISvnjFOnbqUG7gQBJxiPmIE46IJwJKoOHoio+ZNNTHDUi+6lnkaHzMSn5JJAw8WGjLCN+ST3x3pyvDVFkg1/HLjFBDlxefEDDedlrBffDnjXk2N7R5SKfiN0BpkY4PRiQkMoO2W2sCb3sAS0mosuoVIdGos/Epm9wJBC5UNkNxrvqR7+0A65g5SnpijTnl00ltdV5gMvzYZBtF7UbsTh8nZdvYUfHYDXK0cCgsDHBwuH3IoM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 10:31:07AM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> > > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > > bpf_hrtimer and bpf_work, to skip memcg accounting.
> > 
> > This is a short term workaround that we shouldn't take.
> > Long term bpf_mem_alloc() will use kmalloc_nolock() and
> > memcg accounting that was already made to work from any context
> > except that the path of memcg_memory_event() wasn't converted.
> > 
> > Shakeel,
> > 
> > Any suggestions how memcg_memory_event()->cgroup_file_notify()
> > can be fixed?
> > Can we just trylock and skip the event?
> 
> Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
> chains? If yes, then we can change memcg_memory_event() to skip calls to
> cgroup_file_notify() if spinning is not allowed.

I tried the below diff, but unfortunately __bpf_async_init() calls
bpf_map_kmalloc_node() with GFP_ATOMIC, so gfpflags_allow_spinning()
would return true.  I'll try the trylock-and-skip approach.

Thanks,
Peilin Ye

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2350,11 +2350,12 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
        if (unlikely(task_in_memcg_oom(current)))
                goto nomem;
 
-       if (!gfpflags_allow_blocking(gfp_mask))
+       if (!gfpflags_allow_blocking(gfp_mask)) {
                goto nomem;
-
-       memcg_memory_event(mem_over_limit, MEMCG_MAX);
-       raised_max_event = true;
+       } else if (gfpflags_allow_spinning(gfp_mask)) {
+               memcg_memory_event(mem_over_limit, MEMCG_MAX);
+               raised_max_event = true;
+       }
 
        psi_memstall_enter(&pflags);
        nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2419,7 +2420,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
         * If the allocation has to be enforced, don't forget to raise
         * a MEMCG_MAX event.
         */
-       if (!raised_max_event)
+       if (!raised_max_event && gfpflags_allow_spinning(gfp_mask))
                memcg_memory_event(mem_over_limit, MEMCG_MAX);
 
        /*


