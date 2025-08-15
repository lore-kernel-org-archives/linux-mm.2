Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CABCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DC38E0218; Fri, 15 Aug 2025 18:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF57E8E020B; Fri, 15 Aug 2025 18:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39B38E0218; Fri, 15 Aug 2025 18:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A15228E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:38:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B12E82DC6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:38:22 +0000 (UTC)
X-FDA: 83780456844.09.CA27307
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E55820002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:38:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVqF0em7;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755297500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBZaJvJQJ6GhZW61HPhuipHGxQ8yw3zcFiiKvPE9QaI=;
	b=N2Bm3axmEovUV95F3DS5ygKjp/rAheGv8sIjD0frvin1v+UPneKho6I1ltA6FrIZzfRqMC
	ukaQEZfkS8Rv2bRahr4+iZRTLVF86tNxqiRuobjZKMAPG9FG0IJQ+0POXytym9i0riHdyI
	mrM2WaTqjjkXK8toPrqB4OodpYzAfdM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZVqF0em7;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755297500; a=rsa-sha256;
	cv=none;
	b=NaVRL95l6OvyR6kI+zHPKqJ7xl/8dqYSMJW4ooGM1u21DwveqJWT6p5z/XMGi0yNI8WCqK
	SdM9giptBz4Ro5hauQacyWmC3DfhV0Goh9g4UISchwgyu39DI7S7YxLDbgcwBw/rHKJQaa
	/J6kpL+jWwDXIMS3jW/7uAMpf5ObMyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB64561164
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E7EC4CEF0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755297499;
	bh=c1qsvMQG96pzBwCVQ6DQN2WgwR3ejEwlyfyjNUhq1vo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZVqF0em7dKgoDIQDN98KAre5pp776726gARLfwMEUHS/VPlTDAe1JNAf+EVtRfDe+
	 gLP4EnJn5+hwASM146DKl+BpHAzMgXHp5tsNgFe4EIaL7CE0wp3keUweON/j8jOlDu
	 RWOe7Vry9AP4iYnQpHVsMPPLXiG8YWoCdDmxDYGHLLNWWrU/2T3UDsbq0pommEpUFd
	 e8sfw8bmkyIHrgtXFXpREjlhyTMaf/oeeGGt5VwWKLOvs7GGmd/JJCEGrQN71yg+bc
	 TZjptqJb0JUxTUyNv+rfH/KVu0ajuADNsil/Hc2F/+7xTz4fGYW5dDywHt4FdKDU+u
	 WWi6NrYB4p9+Q==
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459fc675d11so9345e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:38:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUeNj71H+ovV5X7tfDgnPVRk9g119qzgoZtv1HazB2V8PiUUoM2PCHAZEYK6NkuGubxOl6GLEPxUQ==@kvack.org
X-Gm-Message-State: AOJu0YxKifbCB/XwyPk8qIn+7vjbwtfr/EifahF9KUT1nORCt2RmGIXJ
	Ogwjiizqmy9zpHo5b6ZTD4WuB3iHvGkvgxa2wfE7wx8pIPDvQ5cNddKDiZZOzTeb7WFMj5Y5YwK
	aAcOzzWMkD10FMEdkRCiqm92nsq7CHCD4ATdUSSMM
X-Google-Smtp-Source: AGHT+IE2tthVbAPeYRpJUIRaQnADPFL/TZXfZagadCXDYlDKYMDA92nIonbGrC6wnNlCfUJKohX+2h24RryranZcrwo=
X-Received: by 2002:a05:600d:c:b0:45a:207a:eb7c with SMTP id
 5b1f17b1804b1-45a26768932mr354405e9.0.1755297497747; Fri, 15 Aug 2025
 15:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <2f75a76c-bdc1-6ca7-4438-21554831ec56@google.com>
In-Reply-To: <2f75a76c-bdc1-6ca7-4438-21554831ec56@google.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 15:38:06 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNEeQ14p-VpgRvTJ0YiXLHbc4Y8wSrOOMsnug8oP_bOHg@mail.gmail.com>
X-Gm-Features: Ac12FXzIQqOjNJhb-gjOaL6Nux9YI0GUqFop_i3tfHE5EMefJpuCak10WYPZD2g
Message-ID: <CAF8kJuNEeQ14p-VpgRvTJ0YiXLHbc4Y8wSrOOMsnug8oP_bOHg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Hugh Dickins <hughd@google.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f5zcmrjwdqbj5eze1na8zuuyurye9m4r
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E55820002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755297500-698617
X-HE-Meta: U2FsdGVkX1/C4NS6CBjDIxw6q9LkjdNUz83GqchbpfXu34FtSqU2LiyrR5qna9j2H0LfdS7gP1DVAHUfRJfVjdBkTw+ObH68jpw1RaYEToymJo7yjP9f69j3VSP9lfkWaSoflBUKZCZC3yGtPqpku61MTI47iVh+b+YEdT+ENVPqFDRwRrpygurAut2yrrT5fvQIH/DxhXj2TmSf9FSexbXZvQxo0RERsogUULlTK5JGcx50X+lac4+bNo+ozJfoqvJCjjcIjW8POU2OAwmBQujuRee3MFFaXfqrNCrnLxjNRaeSsq7gZ6PU7PDnQM2hQWOV/qMWmv2GMyR10kyS/NERYBEtxJDFLmboO7JViTrBRlLXJu+xTW3adfeSC4WKz+lAwJF41Q9E0tkrLxeNQ2z4GejSVqG4vhhopjxVMvsSncr9qd8d50JjzkowdvAnJFHkLcI5Czu4yTRjFySZz0GpXOXJFeR7/fat3S0NVZfliq8ANusXPNycAPQkUrvZYg/hx5lactEM31qdHOTnArdhP6QgKTxIlok1vIA+H3AK3qlEBK19tsp3SpeJmwz9wgJ4/+GXlY4q1Q3Fcg5UfZa/TVGb124uURxD29Uum3qQb70HKS5Vihv+VbTVFiMO4FUzhfLYMDuS+Kh9NTS0cWingh/I4Qv5IqAELtAlNeoZYg438+Z5uRJCWbNYqKDXZ+dDBpogasfvNTlesVf2KeiPDCDKPjbBaZH2ADWPqbKSmGxiCYIwiJbH9exfj2hzSviJzpImh96nPcRFB21cgnqndOwcv1CXv5YALDxOcNQrjgaPolQhKgHAmsel9xn4n9mj8rlI+Do46T+mODKQU8wPm2GMVTFV2i1nq8HokiTkIr2KQQ4cfkoCWuSaRQL7WPp69JiLQe5xYqqrukNc3a9/uVVbbWt2A6zm9k8N5HFWPc2+Qp7Bl5KXL55uHZHiMy9mZZDaouFi3+g5Uvd
 jUI9UILJ
 daPsbIFRmfkg3unLYa0YCFFGO9RdSFcgOp3Hq0tAWb9sVWv6tvuzbToLQSutlvyRp7To8hCzNp6zZK+H5/nEpWiBj/MUVb7M7fJn0n0/S13/+fcIX1zrJbg5M3S3L/kWPrXI3Pm2d2/Rcwvon+EUJTBkzI6JDrkd1PVRXI7u3pAekhz8bqW4XHkBP0kEtKKxRNHeJ+TXKZT9f+FBQiHrgEIpbz/PDCSaXZOb3TK6dGtvKe4elq2cs/CamHuaYGEEFeLrdCebNhnb0TVsnlwDFimYQkNh/v6HPSoaxkRN4mzb7xlnENXdhxMoO+BPn5jihPboOjrbSwYkwuI5rGs2POHxbexCtPC3QcbBQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 11:58=E2=80=AFAM Hugh Dickins <hughd@google.com> wr=
ote:
>
> On Wed, 13 Aug 2025, Chris Li wrote:
> >
> > I know Hugh has some idea to store incompressible pages in the swap
> > cache as well. Hugh?
>
> No, I don't have any idea or plan to store incompressible pages in the
> swap cache myself.  But yes, incompressible pages could well be "stored"
> in the swap cache.

Sorry Hugh, I don't mean to assign you more work. Just brainstorming.
Yes it could. The pros will be no swap fault. The cons is breaking the
zswap LRU ordering.

Chris

