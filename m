Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DCDD5B160
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 01:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4936B0005; Sat, 13 Dec 2025 20:55:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885706B0007; Sat, 13 Dec 2025 20:55:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B146B0008; Sat, 13 Dec 2025 20:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67EDA6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 20:55:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D0DA5B0B5
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 01:55:40 +0000 (UTC)
X-FDA: 84216410040.09.E728186
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id C02CF18000A
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 01:55:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KC5JSIGY;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765677338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgtwyL2IOQsaRpXQUokhvGPgbhGzCSq0MlFT6kUkMw0=;
	b=hsZewmOQKiBoR3hIhXAUCTO3k+BBsp9jjedI1QcGcRGcxCS+Tv/iJTdzQO1LQXlNP/AWVe
	O98tNR2GvxZ+KGBxSie1GZB2zMqOjrXR0J0IjOL1ZRwvKl/XipJJNrw4fEHgMVOSzlETdk
	yoMzKnNEyW/V9AZobmxl5hiKUHK+N2Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KC5JSIGY;
	spf=pass (imf06.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765677338; a=rsa-sha256;
	cv=none;
	b=m2/lcwwZOU9b97UKFjjSYeCYboE+OO1d9JDZr6on1p1EMbzRLQbfjYf3dtk0xsRu+0xBKH
	/z8RG7kis13n61dIsRTb1Qo2zGdHRAzP1mLGhOLcb03R+x9rWfLPSQWYd2gJMJwD09nDOn
	hWFdKqbuFW2B4RvNURdZACuDW17/tpA=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0d06cfa93so18385ad.1
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 17:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765677337; x=1766282137; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QgtwyL2IOQsaRpXQUokhvGPgbhGzCSq0MlFT6kUkMw0=;
        b=KC5JSIGYGvSyOokenf+7KGHQVFwI6rGeRSYIQt6uzd3mLyyCMHuPibyjYETGR+ej33
         y8BTpy6Y+ngrLbUrrsnWSH73XH4tMvaRlE1QlStGaHad1RHvOCSd+5sMpu4VIabE3RI4
         T10Mfcx3Gv6HNHzg4K8mA1LzOB3bersIX1c6eN2GFgg1KOHKAXq3HbvUHWoSu0p7xqJ4
         ZtyIJuKMtgXsgVlOsCM7VSG8T2EQBsiQhhGTPZR2NSfCAMHl/3MA5zj8iGx/izpLuTMP
         zpqitGWbRFnI7oXefdoJRSGPez9iTsaCmXjAPc94r3Zm2Wfa0rk+KR87l17Cbjw/2aJW
         xiSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765677337; x=1766282137;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QgtwyL2IOQsaRpXQUokhvGPgbhGzCSq0MlFT6kUkMw0=;
        b=qt61gLMcVktJpeol8/IKE4th2JqMt5h918qrJEBPDKqJO4rKEo1ffYmiRhBt1y6nEu
         MusqympEwR0de66NB8BZz0009ES/U1VAXnV0x8yHXJZP2x0BhaRLk5iRD6RIdqSZBnHp
         O1pST7yHGtWPTK4A/YF5kaaJl820vvynielAD2pZ+cYK4JSDlZus7DrZiDffiZ+hsK05
         cbYoOlraXK1Od9E5fnd+Ht/SkK3R4ebxpj/tHtqrvqq+WYkXFQv11LCE/geal2kLUIow
         rtxVs7nfK6QI5GY9vAryBTPw3GY3EBWuzqRY3R5LblbXwTUU3bcWDCIYnpgk7b4KW8k+
         iFJw==
X-Forwarded-Encrypted: i=1; AJvYcCVa9U+2ZG5cMq+bwhL6BCuC9b9ZITmdTXUhPYcACu4j/o9i18fAbmdkFSye2j4fK2p2kcCTLuJ7LA==@kvack.org
X-Gm-Message-State: AOJu0Yw9hLT5BX4oR9mAeveLHtGaT6pioM6D0UKESa8pGOjpBv4whXFC
	T5GFsEZhZYjMPN88NQqGAMK8qvlC0Mg1aUbHBBeNAoWg1xOad+cQK64s/MLgtGoOSw==
X-Gm-Gg: AY/fxX6uq6zdXPqBg72+VWauwxM5XAUNKkrWmgxnzWB0D3G41GePZZzDgknsdYKiuxA
	KB+XSs2ffNUvvMSZsWcdvG+OkucMlm5K7/ogBO55yueWzAiFpbAxyqqBhOjq9W+EsX/abg4F9Qs
	M1od/N1dVav6JHbWDIWLwS/Xog6UHjQ56hlDwRz7uN33Vtapx4Kd1jDvUzVJfBMb1z0F8IzoyxX
	SC72sTAg5jiikKL3eCaFk5zhuDaKubVcbUrWtEjwLGSguphQdLX9EcB5U+ZyhUrYlzp04ybnWrg
	gLl7hpljoy4OuG4/lTQDmgW5obhwyXnKbsIHgoIiOMhx8aOkUrU2QmKth5xGbl9Wn9LHUSxVFSW
	TDesUYyV/JLTLNtP1H9GvR//PirmqlgCjgm/t7FWOTcVgmVs7lJdYU7ymzR9QmAW8I/BKtbous2
	0VRJtCNfkoQy6utNwi8wzIDpadT1me7t1d7pGsCLLagNAhMJ7Foxgk9pdr2SK5RmsR4TpQeukBR
	o5p8Tefvfssmm9D9f5qEJoHu4aT8R3htFrOf3g=
X-Google-Smtp-Source: AGHT+IFM6b0dYNyFOMBGuCZFF0FeXHFTlS/LG7X4aAopwttF35Wi88j7hDAibJ75vZtBwKctVMpYJg==
X-Received: by 2002:a17:902:e54f:b0:291:6858:ee60 with SMTP id d9443c01a7336-2a090572ebbmr2877745ad.4.1765677337122;
        Sat, 13 Dec 2025 17:55:37 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:ca83:e74:ec08:e2cc] ([2a00:79e0:2eb0:8:ca83:e74:ec08:e2cc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d81d2sm8664281a12.26.2025.12.13.17.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 17:55:35 -0800 (PST)
Date: Sat, 13 Dec 2025 17:55:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Michal Hocko <mhocko@suse.com>
cc: Yang Xin <yx.0xffff@gmail.com>, akpm@linux-foundation.org, 
    shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Yang Xin <redleaf@linux.alibaba.com>
Subject: Re: [PATCH] mm/oom_kill: add sysctl_oom_dump_stack to control kernel
 stack dumping on OOM
In-Reply-To: <aTsq4WPlrdrk6ztQ@tiehlicka>
Message-ID: <bf31a8f0-4e33-15bc-d3d5-6c81aae5b07a@google.com>
References: <20251211202433.4495-1-redleaf@linux.alibaba.com> <aTsq4WPlrdrk6ztQ@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C02CF18000A
X-Stat-Signature: f35ndnnnaorn1sujps69qbb97mhwcgyw
X-HE-Tag: 1765677338-104487
X-HE-Meta: U2FsdGVkX1/F8IyNTDZ4kUxRLSWoQhZK34cMxb3WTR/5vOwTN6cStUe3hhpwyT6RltnurrNyownDHqK8FPb0mPFvw5T6iiOmuYla+V7L+GajxObcBWdmYr6ZiXi4FFcB970UEAsmfxyEx8BSMvCcuyAdvMNhHgKIduOc+kl8N6UAqyj9TYREjiE4dWEDlD9DNdLqNEpmlyEnZJwyI9qi6GiM1/wl9Bz4CD30Tk4Q0Wekwet+/xqefOex547y9HAgRRsKd3K/ksE5rCOnkNxB4o1ixpuvu+CbDCEbx0j67A52FM/XMbPFQNNpjmUOXajJ1UyE2VNydwavR4DYRGdriqO8DlPs6dFTR1mTvYbfcK/LEomrQ40EcWVv0+LXb1MVHIR3Zq5Um1LoX+XxNbrBtFgO/xEz2B6sjcgaDrOqULHYQkcXj0b9rEs4TiUku99txo9MDB0GB8ttbP6ixxvqhaOCWfrJNATs/Xi78jtbPLLe4jcg1agAJK1SJSI+jFMNp9qt68ak1wbRjRtiMYWGcs7bN6WzqX5OUTAgzXvOB23VVHCnV1h3e9YYV53smgo4D3wQmD9WdA9RMuyAa9JYhwVYKAsqmjUi1MgbjXNv5izcJemyil4qtOhZKEW1rf48mmKZ7bUrQ+X/uFPsfA1BRSthvtyn0FZXEckusu58XStujsp1gZfPMn5/SBlmNmi7eQDJEhg+i/59aH79DJp5QYxBZjfNTQ9LsYkWgLXONyWzWvAhcVIlpDsBbBX2l/5yRmMjlj4RR3MPQtMZ2oVU3er9S8PZzuH7e5qO3owVbLGmWZ+qkznMt/A+l1fKUhrVM28TzXZNZ/zxgX3eXI1RT3lDLWJVCFxbapynlYDl+5wbksRkP9O7+pfRmbWdAb9aFfmdSUvw32VCIlibTHR1LvihH7IYl3LlRPOC7BwO/ZgKlLdNm8vFs/MkZktkobWmqtyqldH/z2DkCylSjVn
 j2L8LKW7
 mcoptu7U/6Cn88SJNYWnObVu4aNeBxfbjd7pXT3TgWTLGemp56xDVs9X0l0qt7U7m3rw0TDBKOO8Nf8wRfy+1wBllUldaQrM297Nsuv8jGeMG1YNttTkqZeZ4tU/kAkAnVwfVWkuEmXg12CCefVbXhGXWd5CE4/sbICfVQWbPvxdJuLrjjpnjAubljzsY1vaNqJCgNGmTF/KWKspjXYGzh/uymSYG+iXEbt/b6l6JwKmmxMU4V6ske3R2QyUit1xQBJ8J7Lzms/fk/pMycnqehqb7IYUK/MXT7ffG5PNDgCVsC+LD7SsYSVa9+5lCIZuw+70hsWIKwhMUt55zv4osJXQWS0Rb8qGdbrhWSRylmrBkGUJMb0z/TL6CgCKgdY+i0jlhUc/T6u+a2wYko7vDo/6LghIYx4bJRPATQt0yORwnCQq+AQ8JP7j4rBEYoTvR0vxVZIqcajApzSZWkMIfW5oHw8CH/9S6r6M10FCnohlkEPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025, Michal Hocko wrote:

> On Fri 12-12-25 04:24:33, Yang Xin wrote:
> >     Most OOM kills triggered by user-space processes produce kernel stack
> >     traces that are not helpful for diagnosing the root cause. These traces
> >     usually just show the page fault handler or system call entry.
> > 
> >     Furthermore, dump_stack() can be expensive. It often runs with
> >     interrupts disabled or holds the console lock for a long time,
> >     potentially causing system latencies and preventing the system from
> >     responding to other events.
> > 
> >     This patch adds a new sysctl vm.oom_dump_stack to control this
> >     behavior. Writing '0' to /proc/sys/vm/oom_dump_stack suppresses the
> >     kernel stack dump during OOM kills, while '1' (the default) preserves
> >     the existing behavior.
> 
> While I fundamentally do not object to ways to suppress stacks traces
> for OOM I would really like to hear more what kind of overhead we are
> talking about here (stack traces are reported for tracing and other low
> latency situations) and why does this matter for as cold of a path as
> OOM is.
> 
> Also we are getting way too many of these sysctls. Maybe it is time to
> look for a more customizable way to configure oom output that doesn't
> require sysctl per output feature.
> 

Strongly agree, I don't think this requires yet another sysctl.  It's also 
global, so it will affect all oom kills including the ones where you might 
find a stack to actually be really helpful to understand the issue.

