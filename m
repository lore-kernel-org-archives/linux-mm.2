Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF73CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C938E0006; Tue, 16 Sep 2025 17:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24998E0001; Tue, 16 Sep 2025 17:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14328E0006; Tue, 16 Sep 2025 17:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B30E68E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:23:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DDF114018C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:23:07 +0000 (UTC)
X-FDA: 83896388814.08.579B7F3
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9976C20008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:23:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wFpC6U7L;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/ZO0MqZiDI6fHTwbXd86RNAJbgLdrJ10yQLcCe1K2k=;
	b=lM2sYpML+UuIUNAlgU3qH0EVjsVihUx6v/7Fr+BuOh2drJ23RZsg8Tz4MSHda+eyEUjjw4
	rQlUanKffNmOlyyocmXrVN7xnY+uMTOfT69bwzkFzn8MPqSXv6blfGvhCGCiBr0+E0GsK+
	KtF3sAL6mg9TnLSew8tUcT70cVphCCg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wFpC6U7L;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057785; a=rsa-sha256;
	cv=none;
	b=zCv4tXAUd6Dn5robQONv7L1DqW8ko2/o0tryiGx5Q2sNpuWUREMUFwcKRedTuirM14zwY1
	sEBfbtHfoKQf6KBQIYnHCI86AioQ1VfqENw7akVQTtc3T6PPtf6b/o7NUgTklahmV7R8sk
	TmCUSGvD6aO22PAXkXY0E22NuC7mjWw=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96e1c82b01so3661073276.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758057784; x=1758662584; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/ZO0MqZiDI6fHTwbXd86RNAJbgLdrJ10yQLcCe1K2k=;
        b=wFpC6U7LzeQA4N5tRGAj+agI7szj7yzREPwfGXi4/K2LG3sHX85hz8LPPHBK0wsbK4
         zX0dded08lAAn0zZQyKsFBoxUl00LQgK5YsdJLGLe/t7mDcz6truWKAtJtyevYB9Nc1j
         f2N7HIzzu3mxPEc+en0Zfre1TMiaqqrxfH2ARKc8SHEOOwsDZe/SJOdhHMePciwBwYaD
         xxg7nHmSsO0CpO+Y672RrBzxZHpx+NZu7dQ9iAnwewMOI+HzVzwPiaIvrk442KT97Qfn
         PSDsJ00gsRt8oNJqs3QYCRFYPW2Vq8KxYVS9ZlotRPhn97PV4goRYRd7M+jz6W8emMVV
         LM0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758057784; x=1758662584;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/ZO0MqZiDI6fHTwbXd86RNAJbgLdrJ10yQLcCe1K2k=;
        b=N9VQ/UyShrr6dpvpfnNeOjpc5BaiKWpvg1bvhA1OLu2/Cic2wjDlOIHLNKCyZhcPWh
         6nh5fAkRgWhxHYU2vVR43ayf4sAVy378CrsS9wv4yKoKkh9zaGglE9VvDYi7/O/05O8K
         U2flvA/X6IWEPVMlVRQKrwk/VMw9T80ujrHlM/Qvg0OdtPvDu4FCnlpiU6V95MrMkR2Y
         3fkPa5YFxzfUuJGiIPlaiPulfwJvXs0EJj0/p+46OjSMWry/WysBpxhXrLN2VEzU+bKu
         KQLUWrxZS+/UBgVhFtaNQKybBTW69RWoX/oGcKQwyqz7/OH/Wk5C7b9VGvH86rDqNIkf
         QLZQ==
X-Gm-Message-State: AOJu0YwKT5M4OWfqWP1ETrsvWPa4JGJmpkPqXObE7Kx8FZHZYFM7kuJq
	6tXA6fYgRa19oegmARKzLaqklqFvrovbHQpPGg8tJ+d2uHIynsxQeEXARlop3Jk49w==
X-Gm-Gg: ASbGnctn/T0BMqevVZPQED1LWskP0F5ksVcOd0CewWwVIa7O3WiIT6kHdGFn1u6eHBP
	5Q5U89HoZRoCMYmxedgrVaW5Ccga27Hg62Yims0quxf99AnObSNvxAN/JjYJTVDqRSztHMZW/BG
	SL58qls87Px7lXdMV4irHOnz/Xw5Qh95UaLo48W2mnPM+arTEfiQgVEIvCsZRFIsF3A0JolTV7b
	zwK2ZMDkIIqFrPY+s1AFgqbn6mlnxmfC81xoEjtj9tjFxCyIx5v85YlmXU4T7uf916EuET58W1V
	OpsKIcd0k0ZXPPa+xOcMk+1xJtXpUHmMVSw7Z66Zhp9P3UXtRg5kzdbwx5MFYtwQ5u6NJvxs0cc
	Z5pV57uJjwFuF86vft7wxPDJ3kHRaJHa+mfo8Mj5RoQxtBHMc2bpxOeGi7m41t8abHIWrKLU8tL
	M6RzC0aSKA2tzQPw==
X-Google-Smtp-Source: AGHT+IF9km1aJwEt+1aGPxCzX4qDZv8bfQl194903OwDWSZ+8/On9Gh9pLdqJIZx54NMGgPjHY2hVg==
X-Received: by 2002:a05:6902:4203:b0:e90:6ed1:ec51 with SMTP id 3f1490d57ef6-ea3d9a34108mr13441041276.14.1758057784374;
        Tue, 16 Sep 2025 14:23:04 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea3f0fe5fcesm3633731276.29.2025.09.16.14.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 14:23:03 -0700 (PDT)
Date: Tue, 16 Sep 2025 14:22:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kairui Song <ryncsn@gmail.com>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, 
    Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
    Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Ying Huang <ying.huang@linux.alibaba.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
    Yosry Ahmed <yosryahmed@google.com>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
    linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 00/15] mm, swap: introduce swap table as swap cache
 (phase I)
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
Message-ID: <99f57a96-611a-b6be-fe00-3ac785154d1c@google.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: bnz8kk1e7xabyhowhbimizmqi3m3j61k
X-Rspam-User: 
X-Rspamd-Queue-Id: 9976C20008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758057785-874633
X-HE-Meta: U2FsdGVkX19FGAUdErIuQCfi/pe3IJDPUQHvMmMhdOAsxDT26tigEaI6RnUviURwrwoS/1VDBsH+eQfiSzBltDQjNdUR1SRzEQjLHW/lqa+CJx1Nltsnn17YEk+6MA0POTsjA+y6ehqSdMXfzztCLUa3FbogNaARBOUCB++D71BRxRP7ukET5VV5ERh3uAm7zFRLN3FTiQ9OfObNf6alfxm496myEZ6j7yHGBvFqGNfCP+Ka28D7i5xcx7NGmd8AnRpBx70viORaxb6+KXZFUa99M1WzMiN322ZCnJflILXAc6A4YBKCihuY+Mq+/ntHIeUrrPERdQktFpDpyjN7795nJPUPNreKPQovwXg0mEsln/kbjvLyzwTrIDMNxBD5lkHCtX5cXqDP0Pf3vSUOAZQCrbrX82vGFV6pKUUoK5tOdWuvOKUj/sad3jnVaNpXZBpBAUyklMrXWqw6DZsT+DAvf7ygjFU5MdlUhpuIvH11k7P0XF4xAUKeLTVIfK/eUHEgbGGA2fXa3IrzdlKi9aFhJRVlMwGf1gfJaGXUFeP1Ey8xdy4MpD/14MSQH2zJAah6CoSps35hnD4QCMd8rUt8MMKnIxvEBa8Njyn3bR4/3aY1F0mKyeMmv3CsMwiqSWGlv2DRxTlOId+wCvI0QcbUeGy7pNWkJKwnzpSvfOZOmshI1yvqgRHWFnPTwN4rt7dFJXBB4nBnFLmwZe+nfhJvsoeZWYpUkkFhQODEeTETXAppzQVUBkn2sgAVdx7rsUxtsHkiofa2+XbEGYgzBf1t72PFWExllwcPI5kWvKsHHJZ3cs9HHE8hxYktd4oJXBIzyaemuV5Dw8iKBHCoBi6RoqCXsG/epc74UcDgGIFMyrQxteCdJhXfwSFyrfLTRoEqZjeT8RZu1eWbKHdKkJWBfu2USpilbBy48eCFrkJLmwmp8TUvP4KkqH7VqBWbaYlWqPXNoDpKaUXXHsn
 GcPWXAUx
 zml/VvYkHWN74eXhk8DVRUagUzI4PqHp0ED/EPUf1fiLMU3AiWfTqBKS7Qf8C9Jx6lQMRg3yqLOlPKX4ID5fEUjLUQRu5wjd3PhKRNl/0urXJNgnPT8RdZJDH1P3zQDPVZbRfXqUHwXHmCjUfuS74TTL//yX1apoqvZdLesvwHRv4AIuuNOGPFY//Bn4uvXCrTowGlRQ/12Fg9blWuhPhFnHs3HzFo7e7UMLGF66Gto+tWz+LakvUbuipLF/6M6i04JXB/AyA5NUI4DBouV765wYsR5XW8JA4+Rkxtg1K/3HtyIdkiKteRaAf3bAUc0G/73U26c5kAzloyGwUznymoPn4vY4uUNRiZuYW9eul1tQ6xTFiLIE8hzuBtFVZ4m1DiNmzrLiii7Ck5ukRktGcnmi9Tzt3SdO8wCtr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025, Kairui Song wrote:
> V4 changes:
> - Patch 14: fix potential cluster leak when attemp a sleep allocation of
>   swap table: Just remove the logic that check and return the percpu
>   cluster, it was trying to avoid fragmentation, which wasn't very
>   successfully and may not work at all if there are multiple devices.
>   The fragmentation is not a serious issue and given the chance of
>   hitting that race is extremely low, let's just ignore that [ Chris Meson ].

And in Patch 11 I can see that you've made an important fix to the
!folio_ref_freeze() block in __folio_migrate_mapping(): there had been a
swap_cluster_unlock(ci) which you've fixed to swap_cluster_unlock_irq(ci):
I was going to report that, with the WARNING and "BUG: sleeping function"s
it caused, but you're ahead of me.

Thanks also for fixing the shmem_replace_folio() locking and stats
update, which I'd noticed too (but never hit): looks good now.

Hugh

> - Patch 8 & 9: move some changes from Patch 9 to Patch 8 to avoid build
>   error, no code change. [ Baolin Wang ]
> - Patch 9: Fix locking section issue, should protect the shmem statistic
>   update with spin lock irq. Also fix an warn on condition.
> Link to V3:
> - https://lore.kernel.org/linux-mm/20250910160833.3464-1-ryncsn@gmail.com/

