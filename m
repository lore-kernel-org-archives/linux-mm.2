Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95649108B8E3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B046B009F; Fri, 20 Mar 2026 05:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBF66B00A0; Fri, 20 Mar 2026 05:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE24A6B00A1; Fri, 20 Mar 2026 05:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD646B009F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:48:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00D5285C34
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:48:16 +0000 (UTC)
X-FDA: 84565965834.13.2A1D186
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 31C9A4000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:48:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pzKf1S2f;
	spf=pass (imf17.hostedemail.com: domain of 33Re9aQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33Re9aQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZMrv952vvmsTG9WcEZJ06sxzhgy6LZj415wabLP5nA=;
	b=GZzWiMTQUaVI8eKgw7c7wQ/qafrtDqHW+OhnNjVTe5BAeq7eiV1m0nCMxxodPordbhPirB
	OHYkZUOFEfvHEq18dHtyZK7HDV9QUzyF4U6zXZ02su0q5zKBphDdrDe3cfHqFcSdYUGE2N
	lNC2qcKVLc8PVdNDz2y13hoMngS7a+A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pzKf1S2f;
	spf=pass (imf17.hostedemail.com: domain of 33Re9aQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33Re9aQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000095; a=rsa-sha256;
	cv=none;
	b=rnPtr++KhL30XGmSMcEK8FjdmHbkfUtqFgdw7cG8hOZx7SO95ZFdGVYrpsTUL3By/D3VDg
	bJsX2JKz9Q7+esKw0SnRN+B3IaNuFOmkgUXcVQFzxvucNf7kS6OhPKKvT+F/5RZYNd8vra
	IG46mjla5LGsgEBKY+dL4RV6H1ObNWw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fc42c83aso11863145e9.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774000094; x=1774604894; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZMrv952vvmsTG9WcEZJ06sxzhgy6LZj415wabLP5nA=;
        b=pzKf1S2fdLxcZtMRXWdO+AXUuawntuGMfHakqVm/PpIvQno3T0kEaAe7454R3uxPfK
         ioJWnRV34wOlLrIQYg4Dicd9jqbU0jAGSCDdrpNVzXYfq2U+fBzdpj2dn3pDaIyZ/Wvx
         hDy26emgcJygY0tYfoYR+DL6f1bBWm9RdYegIzAeSyVdFwpjLpPEtmrPevEm5bDxF5LV
         PqklVuWX7iuHmzo+Ocs61hsUXsdFDWlHdG5XWvegttsD/FGw2bEZ3lcrO+qGws+J7Tpc
         rueo+wuN3mIkptVZh7eSo8fTm4kDrhnOFEqc2J7VaTrhsru8nHvZ9m0506+jpHp+5vud
         YgSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774000094; x=1774604894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZMrv952vvmsTG9WcEZJ06sxzhgy6LZj415wabLP5nA=;
        b=F5fAoIJjSdPQ5/UWxtQlZnYnazyNFE3wdw7tWL9JpRpccDf1Gpc4X51dOSjwP/Gdvs
         OIVANxGRWZtkjzt+gihZyKQwsnWZP4Ctzsf/W7+wPiAnON5VnuPN/YqvuL8mkmFF73cl
         j3b94B5ovCKFQkwqY6fL8w8va8Zt8N7dj9HG1/E5vWz482RkHVmLTOr4adNLDHXH44z6
         8WYiXAuimHipTZGRDVkEkiWSQ6a1TIf/Qxw9wzXkoAPLctzKEm4Vp/6jqk6kHJ+9vlGM
         N5n7O+IGvZxMV0eYwXV3Z8WdoDhivEPeiou+UKU7GaUBvgikpp8WE4OHz/o+eW89ovYJ
         hWYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmxBbnHp1NhF8uTCkK6DpH1Jw0qbtsgpTcEYB1quiru3h+HxkzN5UfSzhIxmHIILEw4Ncacr/rew==@kvack.org
X-Gm-Message-State: AOJu0Yz+3TWtvN1Ub5yTmusEnyg6OdIuu2U9uzSXbpO7YFkyDpddhYCf
	qKzi2br9+lxya3eHPW6Ak05mAXLPPpgEOCju/0SbZ2mRVkKGjQW8MptIoFab53t0AFiEJPdvoTo
	t4z5K9ww6aieE4A==
X-Received: from wmlz10.prod.google.com ([2002:a05:600c:220a:b0:485:32b2:6b8d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b18:b0:485:3dfc:57d with SMTP id 5b1f17b1804b1-486ff01ca8dmr31517965e9.30.1774000093379;
 Fri, 20 Mar 2026 02:48:13 -0700 (PDT)
Date: Fri, 20 Mar 2026 09:48:12 +0000
In-Reply-To: <abxs9k__wWWLL2hb@casper.infradead.org>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com> <abwqq28hWXMLqa5P@casper.infradead.org>
 <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com> <abxs9k__wWWLL2hb@casper.infradead.org>
X-Mailer: aerc 0.21.0
Message-ID: <DH7IJRSKJFFH.36UW4MCZXCYWC@google.com>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Matthew Wilcox <willy@infradead.org>, Brendan Jackman <jackmanb@google.com>, <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 31C9A4000B
X-Rspamd-Server: rspam08
X-Stat-Signature: w7u8qht7nbfup9wb5k346m7gjp3pbgu1
X-HE-Tag: 1774000094-862494
X-HE-Meta: U2FsdGVkX1+JXoWLZCB4hZ9a2REdlEX9jK/nT99zcCbCjbfveELSjC7X63Am5r/TeNJAayCO9+adQ+x3llARzGXgbtpHY57W41y1PGGjIJL8UuARNLQff3ULBXG5SwTg56O0u1O21V6YrU5QGly7AWpjXpYiNZa4jRTrKWZQm1obpEXDoHFCBX6lMuX187WGQlIQJd88jVwtGrJ+BTnNH65QmFO/q18oq+BTuWeghX/IAkZMb1KEYG8MVMPKYnkKttCWk0rDX95VVBiGf75MR8yL9bzjBnrw/aX/8vCJJD1aH8FFsDy+hyiXrmaOQ1gZIJH8pfmRguefjL5njaru/Iq5Mm5T/mbwuRdUlSBmA0+MLMnBK1rIp6UYng2QcVt/CFZjRgnxWMrH21CfGZ0K+TJBnSkaCsFi8+W52js+eZIOHUs9QNfWMBo3DhPQqvTEJnS7OMlnhRsGIyB8Xz1d3R90T6X+B3F6JzCC0pqBRgS+YXqut/VgQEZB9pOIQ4mEPtxpen6NtLrksuMi578y+mNhlLFfWsnN4d9cU8+2pxrkQ1pXxrnwlbwk5UE7TgAjAVZsxQVz4gnf9V4ANvzHnwz3BhcMv3B2r6oxVu1O1MXwA5Qjf7H8NxecbzA8VDJdrC2vZ1QFbsRx/85HMvrVgM27Lp8cUBn8UwDPMuQk/OCFyusfrYwVXGMemR53IEJJWJd2cH+fEKkny38/XAwp4O0PlHJjEI58T4/DqbPVr9MAir37WlzHhbBzK8U4mbwuT+/3ePJCmi0RLS2yFbClITfbgVoQ5GNzBFvCfbA6Zw1F1k6PJYQrdx5ChkpjK2GPfEjmrWBBjwQuhEitmVoiiyUFqAzptc+xJezvZBvX4DZNsDkRxKGxjyKawY9/WL4COVTQJRUdDITLLjUYvM7rYpppdcL2xc/Ls4i3xd0H/td1iIcA7V8v8TexCmtq1FvkpWH1odawKvUh4s3TW1j
 OMwz0S9s
 L7GYCEV6Xuye7CKnazSphfBLTkd091xbhiZHWy4pdf25xHZt+WC5SA5EXKaBneh8ad/OWYkhpjqcG9JPxw9Fkb7ra3Z4fKIn8Mw1TqKIjtdaIM+V8OtbbrK0WFVF9PNEH1zKycXYpBbSVj7oos5SXhWkBR1ovIXFtDnBGkhOFW1QxwZpFeNRl1zndZglMVVCd4zX2yHAQ8p18dW2OaRmzQCl22jspI9bP013WcpJ74553N1+BrYgb+5q6YiUn9ItEgLtN+r73HDhR8SbsXT0tB+fmybTEfxCd52TuYc1cM2j3UQ6DXtYkjd38igiwe3JmK04z1NqIG5rPenE/u21bnn/ZPG50ikoJ4yiKm3YU+V16XSZ1YDYaOAb7MvDLFRuBcXKkliCum8AqkLGFVoWcr9oFDdOVq0E9yBmmkVVAjRjugQuva2jCErM5ZDOAm8E+LKly6qmfMQib1vuO98lBJGRDM/X0M72Q3FIaFCwNbM8UQwzBviga2zJ7Q5YuftjXdg0z43FsJUjiU1c6RchtAf2EytFIebgEoXALRL6r0BPsYxKmGDxKHxSMEAOs4qYHpzH/Qc35Zkdo9i7qg7/9nwYTonSPoXzbqvbpEo6dxXnGNF+nqkybnugseA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Mar 19, 2026 at 9:39 PM UTC, Matthew Wilcox wrote:
> On Thu, Mar 19, 2026 at 06:40:59PM +0000, Brendan Jackman wrote:
>> I will paste the diff at the bottom. I _think_ all the problematic
>> expansions are downstream of struct xarray, but it's quite likely my
>> sense for problematic struct expansions is weak.
>
> Urgh, no, it's not all xarray.  There's one in address_space which we're
> trying to shrink, not grow.  

Oh sorry I just assumed that one was xa_flags.

> There's one in struct sock too.

Huh, I suspect I am embarassing myself with this question, but why are
we sensitive to the size of struct sock? It's currently 784 bytes in my
build. Are the adjacent fields very hot, and we need to look up the GFP
flags from hot paths?

> I don't think this idea is worth it.  There are other projects of greater
> or lesser churniess which will give us some flags back.  For example,
> we could finish the GFP_NOFS and GFP_NOIO removal.  We could finish the
> radix_tree -> XArray removal and get back three bits.  That's five bits
> without even starting new projects, just finishing old ones.

Anyway, this also makes sense. But, Vlastimil, I guess you had an
ulterior motive for this suggestion?

