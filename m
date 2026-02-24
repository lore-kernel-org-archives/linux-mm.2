Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 094D7F357D5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508036B0088; Tue, 24 Feb 2026 12:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5536B0089; Tue, 24 Feb 2026 12:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7EC6B008A; Tue, 24 Feb 2026 12:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 285FB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:14:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAA62160261
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:14:20 +0000 (UTC)
X-FDA: 84479998680.12.A002C30
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7D02100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:14:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zLz1VF7j;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iV9JXKwF6DN/luq5wKSTJTfrqd6P8oh/6BAHuRty0wo=;
	b=KBgiUmWTTQHzpq9bQKklL4upDnTrSDWy2w/pee0LHFRTT6BAgridqnkpgSTutOPToNm7l1
	RAKAokIX1uH62+1neskp/V9VO3x/RRjjIC+w0HZzACZCtm3srEpf/T3vpWTpGx3mzieYzn
	jFV2/6PMj76HO2XD9xPHH5ybPLRhAAI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zLz1VF7j;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771953258; a=rsa-sha256;
	cv=pass;
	b=GNl/j0HcN+KivWn17dHl9+Hvr7Uoxnb5g6rqNP8MPvM2ilqncon/qJ//BMIzJ8NXdGbHYN
	b2DkRRkB0OQnajSgQwzFwjFVfjFILYvpvGbgaOHm/ODx2VOvfwK7V3RS4bLCMaOvk0kn5n
	HvvLsb+ZdIPHUvFPeBFvtvI3qUvWq4c=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5033b64256dso99711cf.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:14:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771953258; cv=none;
        d=google.com; s=arc-20240605;
        b=TTpb9rkHJ24drz5N1rDCcjdfftuxpEau5MLNjvqRlld9L2xKXBNWfRazQ1g0rt1uC9
         j3NZ8tjXOQstvi7EZ0G1/zbfPe/HwZ6UKtnBmseld/UuR/br8WG+Ij1y6+tpw1OIbvY+
         gloO0dttMzSLfJ1xvTSxIJcUrBsZe1vL+5yeiXQ4+S5w8VevvWLbLlowbVyQNPmPM7TB
         l0LpJ0lhyYSBaS0gFo6KF7C3jcw8cJVF/+O37d4tKYdN0jlgUtr89mchuDfpAKr0FNzG
         SxW5HuzFPa9VKA3bmtE532z65uIdjewXsp3+cHjJzeLOe9eC0RUSbioSCD+9vu6S+fxX
         3EQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iV9JXKwF6DN/luq5wKSTJTfrqd6P8oh/6BAHuRty0wo=;
        fh=Oj1N6zIKbcWEOZz1zFI6wvTe2cQxgnWNxltDTfrHt+Q=;
        b=FWjg5J56KddtGNB7oKtbWPzBUyc33mxnULy8DYx18xirYpjWXghpfOlOhEafC4sPQv
         obvJxb59NjkbGhqe8SR9Ml9J6y4f5B63hNre9Manmmjr8e6qTPKrEKDZhijv7gXEOLM1
         HzNtlf84b8OMFn1fo9SX/nAxixncMXGnvXM8dos/poYh3pKunsTOvh7Vz+bD2jBLHbHf
         5HXo9N7Xf3IQB5K4drwlxz3wDtty9AmVNDXBYoY7KSmEW8febXlHGO8SxfsUekNShBEB
         yveZQUexKqGBLln+lkl80PhFmrh6jFrSt0YIf/78T4TWusUaUsjzVKvW3Zns68zWe3Fp
         UnxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771953258; x=1772558058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iV9JXKwF6DN/luq5wKSTJTfrqd6P8oh/6BAHuRty0wo=;
        b=zLz1VF7jREaf6guc+k0xfHWASDuIxq51gLwC6amlhMtm+vNWgHt7+i7x1E9w0PlYdL
         YVgYgA1PCaCjjJFzFJ6Xkr2rRLqjsd1Uw0pYDc93PIZ8FsrbKgwQLXGo1IOciLuJArXT
         DEJLHd9v4tQN0YG5yjF4ERn9MunfC0Ucltjq14uU6lYMwhh5dnZVRr5pPet7GbEMIELm
         xFTyqN6Y2IXkACVOkt6FA0j3Ur5ZgnEoZMVFfS9mRxC+BnDf6gl/sMFIZzvBv6EfGIiF
         IA3yOGGxCPIcsPLSg7sWMazP3ebnKqm/K9MI+vMtA/SAWI9lHJ7KfwV4vJ6TyfG6UCTY
         GsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771953258; x=1772558058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iV9JXKwF6DN/luq5wKSTJTfrqd6P8oh/6BAHuRty0wo=;
        b=tB8U3RyHq/Jj/ORir+3ZyzdcK8u1OyyDtN6Qb33iLN5iOxZaTTZ9K6LvUal2vDaULX
         1OAfc74CUxNScbhVLy7zzc0bF1fnnpti3ntAcQyhE0s87SYKVuuWLx9Hy+dZZSZpfwr2
         BoI3SYfflvMAATPTA1iZ2hdGbqRCGBiOlYTDh4Bxz7wlQNiVefueFTdTFYx4gvfmtNi/
         AgID26uc9fIExTvsikAgNvMWOp+Bk+haw0i209V1thx8qXz8YnjeoaS46u7vjJQQLrcX
         HoCkVPKAttd9fWaxPeTSKfOYZI5E+Fu4cZCIpPITISMn3IsQ4kq9Pi5O1jnyZYzA0ohw
         f7dA==
X-Forwarded-Encrypted: i=1; AJvYcCUe5zRLlTrPLg1VkSRr4q9g8iRmQ2zeXVMA+txLEtjmjfqYqo1YMqDGi7fjwkpighP6Z/Tj0B8kPg==@kvack.org
X-Gm-Message-State: AOJu0YzG3mbeWRdPj3MuaWvKYGQco11tm3YDT83Rt2RgijbiEmktTwNE
	bqSoRYKMe0nJGBat6Tfg2+PMV3spAye+piQ6JI74Gsxp9fCj/nbzQf5euhNkOyEx22p1Y5uv8l+
	ycIVp46yDQsqUpizPikF/Mjp39AVpz0DmbIWAPtZ0
X-Gm-Gg: AZuq6aKDaftMqyW7uS+Ggvunft1i/beRbKfcReJ8xD7VYtkxxUAJn0lyiWf2mRygqiW
	jFZv+lKbVsouN9FUCVsv7c4zzoamWRTNbKcROgUOyfP/fdS5YU7xN+vmKB4fZDYivwj4ai2zJqj
	voaxLAyaXWBZUbPTn/vISD+IwIU3EheJgmuVZZpOzfebMS6PFPCk6wJp3Vf8X02kYyaVttagAQt
	8aQLvWvrvjZwQShEQ8NRVZJF8JNv47SM0poUpLX7NSW+zmn3VVZ86YdmbFMO/Mq/Dk8GHIbhYPx
	q9mcCT4LkOPMBB3RXm4VTxoq8F+tCMze7uhRTA==
X-Received: by 2002:a05:622a:1388:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-5072df24aa0mr12804131cf.13.1771953257296; Tue, 24 Feb 2026
 09:14:17 -0800 (PST)
MIME-Version: 1.0
References: <CAGsJ_4wFMm4WBM8pi-+wmgsUAu-+W2gC0wNR_UrdecY3-+5uhQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wFMm4WBM8pi-+wmgsUAu-+W2gC0wNR_UrdecY3-+5uhQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 09:14:06 -0800
X-Gm-Features: AaiRm535-1TOdY-89IZk5QJd5DsS9Imz4WczG0t-XE6yqUS4wmuVb7kgV2IxVJk
Message-ID: <CAJuCfpH7XEDbuAg75wTr25nLM04a8doMf5hHQZVFcpMqyok6Hg@mail.gmail.com>
Subject: Re: [LSM/MM/BPF TOPIC] Do not hold mmap_lock following folio_lock
 failure in page faults
To: Barry Song <21cnbao@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux-MM <linux-mm@kvack.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Oven <liyangouwen1@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7D02100003
X-Stat-Signature: zh5c4orhfi3ih4hd5n4z3mfqq8zd95h4
X-HE-Tag: 1771953258-545471
X-HE-Meta: U2FsdGVkX19CCdNlpofGg6eH++/7jjxlMI9LmHeEBbCTogUDh9XS0oQwgZpeRpLSq7fCUUGTw+8TnUpbZRpGlVXL/RTaEnWaIlKweVLuv4pkm3Alnsjdti4EuIB0uQ1Lj+GAK0cSeNIjVmxPJOFl2+9yb2rAXVc9D0VEtyQm30Rybd2yogofaQbn+gyAECs/SHer1clZsrpFPLs5DpAqj4HH67gVAp9fFIJvAKoeVOruQtHQw0VvcTEXj15QijU23Il4iG4dgXGzQDaJqQtEO+b/5fXzO1ywOf/DqgaZY8SxRtwLFUgPoWo/o6RlAhp3OGKp2MtOFu8OSR/6lOb2zth6AOIma8TgYm3B9s9NucD+gkEVSyc5hk85e8oZSUbF5qOS+rVn6+FhGmd5zEI8bgtZhGH0JOcGaHZJnIAdNpbzxSQHCHaYl5wEQjKGE5dLwkcaYI25G8fd6wIT/pUBbPwdrcZjOQvTPBkbB3LGW6Gvuj0o/f27BdL6p1mjsbSl6VddgI0iVux4xpvRl1pVuv9RNqzu5iLaJNpWvSabFxCBsRZ+pbCGEOgMZFkvqqkW6QVmBXTQTyF+HALKFsXPJAoCEiSFis8KHQerp1YccborKC76pXop7Qs5AedQd5mn1zrcIvJVRybBxdFQHyuuYTlgyrABlR+XTpj6uIFi+Z3BNuHRoIPt4+QdCR7oJKzmZLGDPHgQMy4vYQYW7bau0TNOh2xJgk+uyXT8+TYtigdSy8GTVgZQ1bd/hrgfJHcljZ6LDvFGzLbBCK0bKAtz46vMyUSNrwReNeVE1BwpletRdC5hxnX8oVWdA+K/OCNHge8FkZ9rp4x+QuOuYPyH5bi9RsEUSb2xesieFMW2I3gjxIJTW1m6lfsPOnvev3+5Nhoao9xdItlE/hF3bgkEWgasPWc7iiRRkkUh7Td6Yumd5LIATGgJ7OdI0uidE4YR+bA0yMjVlPgLteLiSr7
 CA5Hry7Q
 9eEQpmm5nZERnmJZIH5xv7nDEyqFmKU+slfKc3S3ifWDg5Ut1UaJNKamDriy7f8EcFpwajKNxtx534h9xdyxH9HNZXWBGU3wC9iAwRGHFj4CMgk3w3YzCXEvncW8m8UnH7s90L4ZjRp/Q3qqMMQ++7Gq6IDd2+/VqGXiO/YRQAPNolQK5yV00H4GOffjIPoathBi2TQCM+YySDV0I/sT95nDtsMbag5J2Sa8XWTycIP6NtljDQxLgZ3x5xaoyRF/CxFHAhxfrED6QE0KghsOCzhx654XNt4+rm6/3qbAng+ktVh5yClwGSt5SorGNS4kRBlfCUc0Y372/VyJW32RYXovqV940TsPJXwAr35TaDD6X/Nnj+J/b/7sEYxJuwtFM2hzYNz/XoBxRqzQwPXvXs+ALDDIS+7pJgcfg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 2:13=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> Currently, page faults use per-VMA locks whenever possible.
> However, when a page fault encounters an I/O read (e.g., in
> filemap_fault() or do_swap_page()), the handler releases the
> per-VMA lock and requests a retry after failing to acquire
> folio_lock. On the retry, the fault handler always acquires
> the mmap_lock in read mode unconditionally.
>
> This can occur frequently and may sometimes cause UI jank due
> to mmap_lock contention. A proposal suggests using the
> per-VMA lock in the page fault retry path instead of taking
> mmap_lock [1]. Oven reported that this can significantly
> improve performance by reducing mmap_lock wait time [2].
>
> Matthew appears to suggest removing the page fault retry
> entirely and instead waiting for I/O while holding the
> per-VMA lock, noting that folios under I/O read may be
> reclaimed by the LRU under severe memory pressure and
> with thousands of threads. As a result, folios might be
> reallocated, causing the page fault to repeatedly re-enter [3].
> However, holding the per-VMA lock during I/O wait raises
> some concerns: writers could experience long delays.
>
> On the other hand, retrying with the per-VMA lock may reduce
> mmap_lock contention, potentially shortening page fault retry
> time and giving the LRU fewer opportunities to reclaim folios
> waiting for I/O. By the time of the LSF/MM/BPF discussion, I
> may have already created similar cases and collected
> additional data.
>
> Another potential optimization is to remove the page fault retry
> without risking long I/O waits blocking writers. This occurs when
> folio_lock fails but the folio is already up-to-date. In this case,
> a parallel page fault may simply wait for the simultaneous PF to
> complete the PTE mapping.
>
> I would appreciate feedback from LSF/MM/BPF on approaches
> to eliminate mmap_lock acquisition in page faults triggered
> by folio_lock failure, for both I/O wait and PTE-mapping
> wait cases, for mainline inclusion.

Would love to participate in this discussion. Hope Barry can attend in
person this time :)

>
> [1] https://lore.kernel.org/linux-mm/20251127011438.6918-1-21cnbao@gmail.=
com/
> [2] https://lore.kernel.org/linux-mm/cccf352a-1a68-430d-83fa-a14bb5e37464=
@oppo.com/
> [3] https://lore.kernel.org/linux-mm/aSip2mWX13sqPW_l@casper.infradead.or=
g/
>
> Thanks
> Barry

