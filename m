Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4597E60A2630
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TI13Vqoc
Received: by kanga.kvack.org (Postfix)
	id 670B06B04F2; Tue, 20 Oct 2026 11:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6219E6B04F4; Tue, 20 Oct 2026 11:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FEA6B04F5; Tue, 20 Oct 2026 11:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C43A6B04F2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:07:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B4DD16022C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:07:49 +0000 (UTC)
X-FDA: 85343334258.26.20A4207
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id B4FE81A0011
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:07:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TI13Vqoc;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNdGNCXkUfPvd4c5ZdXNPNix8cXInUecIS67qAo+lDI=;
	b=jKXjfadvbB3WqW5R7XzajaOW9tG1WUrmt8EsQWq8YTSJsgc5Opke2sFlXhmpcYOoBGQdj+
	ONi5PTJVHhtAgvRkfYWnhRqYAOvHwVsN3WWTmvH2Gn+izdtYtXaQB5P7ze5t26exqxsmFG
	Hh5wwcJBGES/FxD+/zh8WFhN4hsXkow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508867;
	b=WIRbV3EKrEjv1QdG3Ctbeh5kFVzmic0aLDfhMllp7Ed9ZJnj2mh9OZ7KCcCcdnqeH2b6zz
	AUt6QEIqPFA1hZx15BfZKjHhr7EoNMh+pTdVGxCOHb3+1UGJE4rHCsh4D9qGKj+QfEAP+R
	fMUw1crWAf1Ek/uehAzCVbywluQr/gw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TI13Vqoc;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1e3098ee2so28820715e9.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792508866; x=1793113666; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TNdGNCXkUfPvd4c5ZdXNPNix8cXInUecIS67qAo+lDI=;
        b=TI13VqocYjtBzq5j7/XV6vLOkFeX84tpYFo2QasmszIU/LOe9yE/7nKmrF6YIq3nLW
         pc69i1pFHzEEjX0XNN1PvqQmC91TCtea5mywW+KZpL4L07219FebCyGJ4C9HR0DV/cAF
         8W2n/l7fwVK+Y6svyBMZBNgYdb+haYFAgAQYVsJW1SU+Y+6iAZHByVZES8fqSChgIEGh
         iQ2RKkmbSVE7Tq6XeHX3VfCWOT31CzDt+1pgmyO+lDxPu6YeJnI9Hp8XFil5QfMX4rZj
         mL4NfwmYoeN+8D3F01/MxMj7BzE0Ba7jHUyHK63exLFUes9pgSncq/w3eSW9t01hTvbf
         BDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792508866; x=1793113666;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TNdGNCXkUfPvd4c5ZdXNPNix8cXInUecIS67qAo+lDI=;
        b=ESc9C2LK7c7SNgN9gRgUSCj1cI0TVLGj10OoYecRjfnm37FmNXdJND5dcLAc4w2hw1
         03GdbLJMjUT6HTyLhhh39R1d5K3QaJ/IlWMC9KZfK/VC7Mu2+YrzLq0B9f8d2AVBdZ8V
         3YF1edvz7/SD9d/W+tJg/0mWCgVu92VnZXTOIZK9k8fIVuR0sjimcR3YPHnK9T15TFsO
         wua8mXkOq88se+qY1fEHGuEFEb3x8lWoOkPNeb2CbCmiCV4kgu9iJWyHRmQuQSVyt9vY
         wdNT2/I1jprLNs7OtmRNtn+8vxqd3tIhbsTmC7Jo7KY/qXtKxoI/p7PfcPUF3kbk1kAQ
         iWgQ==
X-Forwarded-Encrypted: i=1; AKwUvBwP8N4KM6zf4paG5QUHmC7nWZ2rVZhgs47AsK57I5rwIGxx5LHWjpsA4o7Y9DFuYQgq8/BnDsQgHw==@kvack.org
X-Gm-Message-State: AFq9FYL8IJ4vGI5ltYXhrJvy0VqBVCyXtWDDSLx0MjIK6bPK+S7iSl2V
	N27WLYZMMHcsDNmf3/NH0Ulf4wZsEQiwOXeYrfDt7t8TdB2ODzDsNNBC9R2cdWX0LQ==
X-Gm-Gg: AYBFou2sMUjU2HQ4QYpTQGic0X46tvBdnm0PD/Rxi8ZXGav28MvOGHQFnpEa5AqJhcU
	LCSw5AhvdPoUq/vKDk4/Zf/4Ky0+PeobwN82dXmPFJiytxBVNYTdd3DefeUzCHFABEIyL+cxKsn
	aVdk7Z3oXBCWuQiw82wI5AX3nfE++N2SKhG0Q6UMzAVAydVve0WnYnFmmkPSKgLKfrioY4zxM0/
	DzxJVDn3V/HTfgTkdzQijYhrdY+ycJLG4Bqr6lL4cSVTwTWVfTjrpNJfLCA2387s4rIFzqaQVlv
	CLf3cDNljwdujhI0aNiid+AEFzzUKv3Hv0t7ZYWa1l81eJhyeNnyz46Y67tGi8S/Nw8HMlpumPN
	6PWnd9NfGc3D3/r5AAjhv8M5sWlCq7u0ZeoRqFyGCW+ZdEaq7vVhtHWhNO4+fFFhr/0yu74mcwZ
	T4GS9n1vJbc8nE05QLbxTIe8sA1/m9vs1270yj9JjlGtOKPKQWJzag7oYjsaKLmgevv05DRl3lA
	ohTZZdhcNnHS/YK/jTVedLzlHzYZ1p1v7zOu7IVF6rTV4ccY4Q6hNU=
X-Received: by 2002:a05:600c:3488:b0:4a1:dbb7:bb44 with SMTP id 5b1f17b1804b1-4a1dbb7bc9emr176208875e9.5.1792508865680;
        Tue, 20 Oct 2026 08:07:45 -0700 (PDT)
Received: from elver.google.com (124.100.205.35.bc.googleusercontent.com. [35.205.100.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d1e8ebsm73417245e9.3.2026.10.20.08.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:07:44 -0700 (PDT)
Date: Tue, 20 Oct 2026 15:07:40 +0000
From: Marco Elver <elver@google.com>
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 00/11] stackdepot: reduce memory use for
 persistent stack records with a trie
Message-ID: <ateDvB145CN_R7CA@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4FE81A0011
X-Stat-Signature: hw7sfwqjrmafxxq16zbpz8tmmcyf78ua
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792508867-44989
X-HE-Meta: U2FsdGVkX1+M5RbTPtrx790bu99yVPH+nfSaIPowBNbjs/VZK0hH9oQ7AaTRKAdFdNpej6MPheeO8zovM/eN5DWpIZbLqizndnhJoAOyDQrgMsTqJpkaKyp6Zo5qgXwc3MWBj/w+uUE3Tp+6VswBVmmFY3JrcCEPNgtR14hBMbN1ILvzfTkY7fvt7hN2CZV6LxaRR54fk36scyhFRUC8fLFoV4C6PjM6mTW2YCLudnNxteE2CqCCgRa4KcgHL4kSfRxezFTD09O7n8HrRMWt6rIiHVKUVpE0WbQbfHDwdbJR7xVpcHqsBhTGSx7wgn7W68Wx4FgRNLoQ6b50WieuRITzZvgH0RG3uZI4gorGSrTvRtP035i4VshNU8ebr6hX79xsPKGYCQztfnoCeOwv0GX4DNASNdMyFzsipCow93ppxFsqRwb397ncEVtWgWCGIkwDzjg3gfNfBLpXe5Ossi/OJ7ps+GvIMQf5aFDmeCKVyRHBaZfsAlysJ0/zXG7sYgeSfz8dfkrI10fo7NsroBQfxfZL2IF2SUr9mc/ZLqJhgINRd9XIM4Vo8TiSY9KpPxfGAr/1DfRrWHFym0VAAP1dpAc59G680yqXAoS0L7X1qnxt/UXRFGKM7nesbGhpKiV3ObIazRkmKhLRtOXRYGaLGhf6Rmj94+2n9UPZh2XnHuK4FgFt3S69Zb6HE3FtAS++afZWxhjb1jYaIidyPgU/MZ5niNuXFKkbRE/GI+VN5vlN98gr10413EkRRkN928sGvwL9doCMQ4CT3IxXgpTG20XLzFWnEauYPqU2pMa7+2TriRARsKBiliQku72YxIfYm3iDfi1Y+qIw/y0gaXR/vGJjix3k4tpSPnKKlFgMslwzMotVwH+hqeAzTUiyctylcZCGVX51r12FNd1od5rg1TBqlTX39P+ugby3VF+MDLHKDZLcf6gALYuk02Zfpq52iTKIIlICQMbUIi8
 t+CZwJRa
 irfnNI2WpY46/eiuFkNJv9cuaZVTgsQWAc+tLYhJZxRNJUpk4F3V6jO0rMGHTey8rE4xT/AaXrd9B/wtGY6zk/6fE2L9QVpyQAtWB59OSmoy3N49zyH73thXpfR3UCHFEKDV7IC1hiK63jy2BjOfqzCZJAt7EtKTEKfDD54tIohdGMHYxI4v3Qtjq7JRCUMelASTFlUIcABAzaK9e2Uh24mB29aLm6ls0eL8dL1w8BqtC1uMiOq0H0QVkNaZcobbAdmR52TxOL+/DEex5FNUXfnegW3OHn5u6ximtD1kVwSIfZmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> Hi,
> 
> This series reduces the memory used by persistent stack depot records by
> sharing common frame prefixes in a path-compressed trie.
> 
> Cloudflare runs KASAN on pre-production servers so allocation and free
> stack traces are available when diagnosing memory-safety bugs. On some of
> these servers, stack depot exhausted its pool budget even after we raised
> stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
> persistent trace returns no handle and a later KASAN report can lose the
> history needed to explain the bug.
> 
> With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
> Doubling the limit again would allow 1 GiB, but it would not change the
> linear growth: the hash backend shares identical complete traces, while
> two traces that differ by one frame are still stored independently.
> 
> The trie is opt-in and disabled by default.

Have you measured how much of the memory reduction comes simply from
storing 32-bit compressed frames (patch 9) directly inside the existing
hash-backed struct stack_record? That alone cuts frame storage by
~40-45% across *all* callers (including page_owner and KASAN aux stacks)
with O(1) lookups and none of the trie/bitmap/RCU complexity. If prefix
sharing is still needed on top of that, deduplicating fixed-size (e.g.
4- or 8-frame) immutable segments from caller to callee in the existing
hash table (chained via parent_handle) would avoid mutable child arrays,
RCU retirement, and the bitmap allocator entirely.

