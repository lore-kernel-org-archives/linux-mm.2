Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8350AC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8506B0088; Fri, 28 Aug 2026 04:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809E36B008A; Fri, 28 Aug 2026 04:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAF56B008C; Fri, 28 Aug 2026 04:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 409236B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:04:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9CE0A02AA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:04:55 +0000 (UTC)
X-FDA: 85149942150.17.F21E12D
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C15D14000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:04:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJd5Geqm;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787904294;
	b=1TZG/a+QRyKNgYyCjycRr+DSx81dGp8WbblAKVi+1BWHH9pYJaEUluEy3nOjzeWG5uFchj
	y9Zw6iSsVXQftZbmwB+kBuzvD90DfwcmqQFgIHmjajNfmUPwUk4vpQvODjg2BuAR6TGQKC
	8N/cx6lvK05ISOv8b6k79gpG+CiHJwk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJd5Geqm;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787904294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cziOTKmVhxUE52ibRD2kF7eNQJ4Wv/wGrdlgF7Hd+bw=;
	b=SKXRX3d7CCzBANfoM9UB6pKOV5+ZL/MKO8zgUfr2JNhJuxUH9uNmcSgQQKwHc4UVOY6oD/
	kEJ8ZFCKKjVqNe5yrNcU1EFEbypLZqXO8nlmWMWxymQ2YvTjhMQttQZln6DZ8ZJMGdfYOx
	txg0fALiam6rTfQjKsxG3AzdFpSMIqE=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7dbcb505578so8215277b3.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787904293; x=1788509093; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cziOTKmVhxUE52ibRD2kF7eNQJ4Wv/wGrdlgF7Hd+bw=;
        b=VJd5Geqmz/Uz9I7xPSJ+zoZEsLf1gLUBL6sSPWAPBmk+tXQNSDz+OgQ1fxbM35JvjE
         jw45DTZ4wlN3zgVdgK/3GaJapuxVxEJ3h1+2lMJpmqDJDjXvkNtCWRk9Rwz/vOkfqQDU
         S7CT8PXODkX/1p03u3jMm8VbS8qis2v1+Eo1w0v76mLFfL7vbFXr//A2Oj34D7N65n2C
         wjvAkicMtyOCbNogg0DvlteTv4Y8t+XRxL8X6NKXBhJLevY/gib3iRUjC9WE+wXMqmCt
         bI54TMJ+b9V3wBeZOLVKlv3JYNGGOTLFryvgTPaCFBjjMOHiY+1U0VxM46Y0ACxUlrew
         FjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787904293; x=1788509093;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cziOTKmVhxUE52ibRD2kF7eNQJ4Wv/wGrdlgF7Hd+bw=;
        b=OBlGB8RQ1ei67lCsASkJ85x9CEf/c4kPnIueOHX7ekATp0UoMlD25hZX4Pyp5Y4D5j
         KVH9N9cmLrKVhWqWSgarx+1GVxVMHFSLQ6w7DFtFekVCAeFMeqLN9vKfq/DI0wBBWKgn
         Xsz2E+f4/Y/w5zzIsvf7znxa+wVwKjq1WVLJs1oTXaqYcYwIoP9eOEf0Sq6m+pYILbPX
         SxST7V20I29z68nR/0CTOt3V/cupj5bt/S9jHmoiTCn/6EqB0QaEWKrlNnxsjhCSBcG7
         bD+W1uFpXNdUZb5WJf9Guo4NDutHsnZham+UD1NEQ0wmtoJL8RwJTF1Xn2oBP4yCYRzy
         yJ4A==
X-Forwarded-Encrypted: i=1; AHgh+RoziNt4LbTRpUE1NiR17HRHfZIS9xTbInKORBGHSfX/zR7w27hTmNWTmrS8VRQUk46wCT8UvJg8TQ==@kvack.org
X-Gm-Message-State: AFuF++mTru4bwPE2csxQCg/KBZcaN7D/1qSFQmm0gV5eh3cJw80EX7KM
	8KiSTQ2/5B9Uudi1smAhKRJBN0nDrY8G2DtZ6o+f7Wg95AIQNX070jh8rCpkGrtLKg==
X-Gm-Gg: AR+sD11B8LF2OtEEe9VfdkNoaXKmHIBpN1AwNPmsIyWEVyrtz99xpN0grN1rYJK81QN
	Tb2Sn3CEYVfas886Hgs6nzTJeAGSOWbOF3H4pCGvebh1VwolKCd54yzMiuBUtmdnh3l8EQQl2RN
	T+W9lQ7HvX/m+9N3FcvUIx+Avk/GmJ6WwBhgGgeqSZRH6k76jQ2GrHezDUr13kXaEXteQDWgL16
	qYBrCOcLt5q6+9EzaLVp3fXiltQxTO0S0Q1QFdkLbzxcDVXDjdUuVPtHHa+uddAcLf/IsQSuIZl
	8Bi151skRGKskhOIMr80gM4Mh4xGb65WpfblnunwJmvQCsC9dRdl2IZ126Sv3NJvcLVnich0bp+
	EQhx48/zp9Cz5eAXZ/yxMNq0W+HoPzxX85hxy0ofPqYl6TnFBqvAj0Q8D6NzdCaw72QQ7V77Ik1
	5Khsjtz84ZVuMAUrVOoXs4q+lSNOg/z5iReYEKrgHNnl9yQwbuvDIpIK2acC5I/Ht4yCmPLYDHi
	k6mUdgi3YyESOyotKAofOQkOj0v+xWK/obhbCMgJpUaMH5x
X-Received: by 2002:a05:690c:4f89:b0:80d:15a3:7b1c with SMTP id 00721157ae682-85d68a8ebdamr19896027b3.4.1787904292453;
        Fri, 28 Aug 2026 01:04:52 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e5e181d7asm3395277b3.4.2026.08.28.01.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:04:51 -0700 (PDT)
Date: Fri, 28 Aug 2026 01:04:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
In-Reply-To: <apAaWsWPV9QEeVwn@thinkstation>
Message-ID: <3b8d9cc4-d6f9-6bd6-f774-34cfca9c48c9@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <e0887417-85a7-453e-e733-561dc11db08f@google.com> <apAaWsWPV9QEeVwn@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C15D14000C
X-Stat-Signature: 7gmicwbkd1jm3rqroe9kkktgygxmw3b3
X-Rspam-User: 
X-HE-Tag: 1787904293-482536
X-HE-Meta: U2FsdGVkX1/Pxo+js7FM/ok9AyuqyDr+64+4JHHr1sFn5eTdQGTUGPMQmJCx+wHG9IRyIuSGetnWQIaAp1jq4ZyUs7C79UH26URzwWwlhX3p4hB1w+oRihJ6rFzAVOSOVKXfksKw8+yYxUlGRbrNfhNeJ/Q5Ls0XmUqhDL7mXxpEhMQJXp3yPzcPo972Kusy6aZCk79le1AfVYrZlETqhZF1oGJc6Q0gPRtw43bsp6JGactKJyKvAbzWe64jQBAtqdKuP6MEfcrKe7sJ1WSfQ9JYf342ppbI8f57XulTmWLYHd4Z5oIEFMoVemb3bUZRhM808qizM/VE+P336HcO8kHr9FonaddRPzpaGnIiMHWsxIjDH7FQyd57nYXWz3oYeTy5l0sdJl5b7FhdBymHriNr1XUgHg/NxJIpAV1nOyTTcqU3FcdJTsTIEFdJu5niiBWgzXpJH0xkwbjo6dMrBltQnIpZkZUq+Lzja5j6p2e1QkddZx4WYxrPWUi9qmuzUx2SMmvLR598+ngXWBcfP3sdDKeTzF+D/kztPWVMDJ+OURh8czIrdgUvfTY8dfN7rYAAtLKSbE4nenVSnrYAqV0VfrIChnfpRx0t4Z3M3FxCwE05uacUPGqh3hEGqgV6z5Mgt3l4hQkoYHyfdhijhfTGf9huTfWNaDf4X217T30QYujr2Q5LvPU8neEjE+uoC8+0CXZpox6a1YylTXHn5oZ5VJllUKuj3VfpPYQYeWKJOjE+zsLVi8xAFL+Z8bxdpSqKutUftUiOwDqQKtFSjPvpBmGM+PDRXhnapZKbs1ZU54HzoANBV3+tFUSMvQtjL7sOM7kovSlcJ8laHEWlpeUEwGtbG8DnePa/lDHMJteVqGPKtCk9EyOlO9q00rrHXXbxRz0C1GYKv0+C9qR5f4M73QC8pg4m2XVpDwfRk4ApVEJgvOidAZbqJqC5mFc8ZNPgyecnez2vZ/Rahmx
 WkJfiPXL
 9MJ3/obpFsPCxbCQGsx2PSo9sA06hoCzlg/2BE+ayk6GmHsEbbw2c8vCyJLusbsuY/Q4zkPI9BnouPflxJ55bEo4+8o4BIFlHqsnIU1ys+GeJz6+WPFL8nNRutXq0WL3GugzuVIKVtnuIrVByXFYVG1i32tO57zjfX/K2PUhjYqnXsWZfG65A/DkpA6WXxaImeXsuDFlCql6vvnpm0Fjay7NhSIUNZ5TWr8w0nDFBZmlUkW5ZCQafQ+m5LRYP5y0lQe8vISSCG7nTfRauBS+3i+/PSIrYOWvQdqDbvu38vIJhHBTyDE6OnicxFFwB2AzooCyHWToN5Y6yddwUhYXoEWIlfd14LdFwCQz2S58Lb8f5op+sckXid/s+sHxa4PYBP8k3+FLYGD1pEaZVqc5due7eXHbTsfQN2jRs+nU1tn4W4nhZYgE45WFsqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 07:01:20AM -0700, Hugh Dickins wrote:
> > Treat folios on a per-cpu fbatch as if they were already on the lruvec:
> > with PG_lru set, without holding an extra reference. This will enable
> > the removal of most lru_add_drain() and lru_add_drain_all() calls soon.
> > 
> > Recognize such a folio by 0x02 set in the folio->lru.next pointer by
> > folio_add_lru().
> 
> Hm. pfmemalloc (__GFP_MEMALLOC) thingy already claims the bit. Is it
> safe because such memory is never on LRU?
> 
> Are pfmemalloc and PG_lru mutually exclusive?
> 
> Do we want to be explicit about this? Like, folio/page_is_pfmemalloc()
> shouldn't return true for PG_lru folios/pages or something.

Gosh, thanks so much for pointing that out: I was completely ignorant
of the the pfmemalloc use, and a bit (bit 1!) shocked to learn of it
(why wouldn't they just reuse a pageflag, I wonder? but doesn't matter).

Anyway, as you've rightly guessed, it's not a problem at all: these
mm/folio.c and mm/mlock.c per-cpu fbatches are entirely for folios;
and if any pfmemalloced page ever get used for a folio (dunno) and
put on an fbatch for LRU, then of course its use of lru.next is
immediately overwritten (first by what this patch writes in lru_next,
then later by the lru.next pointer for whatever LRU it goes on to -
just as before this patch).

If you were to tell me that some subsystem uses PG_lru for some
other purpose, then I would have to get more worried; but we can
be fairly sure that's not so, since mm/compaction.c for one relies
on konwing it's free to  play with PG_lru folios.

Whether a folio is ever allocated with __GFP_MEMALLOC, I'm not
certain (haven't looked), but there is no need to exclude that:
it simply would not retain that page_is_pfmemalloc() info across
folio_add_lru().

Does stable_page_flags() present page_is_pfmemalloc() as a KPF
flag?  No, it does not, so no problem there either.

This certainly deserves a comment somewhere, but not a problem.

Thanks!
Hugh

p.s. Only in replying do I come to realize that I don't actually
need that bit myself now (we could just put one magic value there).
It comes from all along when I believed it important to be able to
distinguish expected from unexpected entries, then suddenly realized
that actually they want identical treatment, so no need to distinguish.
The lru_add entry pointer is still kept in lru_next, but only to help
in debug. But I would like to go on this way, using the bit, for now:
partly because I'm wary of well-intentioned last-minute changes,
partly because I'm not certain a reason to distinguish won't emerge.

