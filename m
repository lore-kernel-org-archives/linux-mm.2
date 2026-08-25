Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86184C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594EB6B0088; Tue, 25 Aug 2026 15:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6E96B008A; Tue, 25 Aug 2026 15:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3970A6B008C; Tue, 25 Aug 2026 15:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12A516B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:36:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EC3C1C07A9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:36:38 +0000 (UTC)
X-FDA: 85140798876.07.CCE3421
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7932F1C000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:36:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NaSUskY/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787686596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
	b=xTdCegTLhvhN6gNzNJ9SDChNUKgMDp8kCetzelZFDoCEK/8kKParQNnBAo+wIQClpIXY8B
	epfjlhhdP5iTw1b7g/3yDg2+GNl5tS/QUPo/m4b1X/25WI9UB/1NqsrIvqZUU+SEJXlJl9
	Fk8vca4PPc5KbN2PMAxb79kY6r27GC8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NaSUskY/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787686596;
	b=SbEA8X5cDFuNQsAoxjm+Y2K30O7lzXTqzbMWWobQY3wQR0PzCnFpop9dV3Zm0eBPWdFnD1
	hfvW0LB32HUYt2EQe4lT+wGTU+GQNtqMxA3vlgGBHpUF+wzmzzlqkcdRr9QoXgqDuoaDMZ
	V207vYb+7n3kOmeBl7iio1lMjqu7L4Q=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d3b440b97aso1795ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:36:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787686595; cv=none;
        d=google.com; s=arc-20260327;
        b=eGveezTJsXyjqXiSqY8Te6ryIp7oOCFgxiRHW04/axSQvaqwV5sohPD9BqI31TMRkq
         JbQcI01jzeptxKb2XEsQCkPeddZR/pa4u0rX88xDF8KgipNyFTE654sxd+bEiKSVNURL
         EVgEQ8/DSzjhQ1lAEPWK+LPj01U5tsZ5w2WgBf/Viw74hEVSpxwepx3u+sNNVtssUcZK
         4USgrXQzd67GfzEoqHKLLh1TDw3TfhdXU3bAKvZOhilPYA3ija2Qmq8DRkr9IquNkfqU
         yvRz2n3j8ovEwr0a0lf0IjMDkNlapLkRrQ0KEw3MmaNBkWmVLlL3y06ss1YcF2DdXIi2
         QU2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        fh=7guXM0fiblnAk2Bhc4xBNqQNZJHnKpCLGRALTaCTrf4=;
        b=e5XDaU9aLmk0bV75czUURwTRD9h5Hb+t/W6HAtB5TmHXsqQ6U8tYevxRA8LAH3xYHj
         MObck93ckW/vA7ALdVvNKhee6ld74DnMXCZoGW3iAlhB5rzY3lPDsv/xMEHuos/nnAI5
         upmhY0SyhR38s8hIyHCLTMBRaAZ4AsavHIWyMlg/Cty/ELxyOBSU8wHLe9+RYoTPklhJ
         7SkNM803ntYS4I/kwfXCUD9ykJTjfEp+GpgJWiAPFKSJ/AUs6Ql0bTYNCuiucLMKwTi8
         3dS4bCv8juSXgIiKSrgLTvaCYvbnvq335l3F6k/26cj025RKVu30sXNK9CvXSTw2Dtg8
         uQwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787686595; x=1788291395; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=NaSUskY/ofClIw6PvJmGNi3FCkHYAHaqhdpkeZYUD7deOmaDbyJRu3EQ6XBQo6F2MU
         f7GyojKBji/qhfv2hnj9c9w0SaYiaoksukDqgDquZDannAT+WWs/JzF5yB0nMrxvOdxF
         NA3xJVPtdB0XmLTuJxJ/GPKt+D0BpBaMINetHpnKewo7qlaWx5uaLkM5BEXCE7jp0zhI
         +wMLharR1zsFTp6iw3S0+74g7zrhJV++7ULmrCTeWKhohuDPaqeUvXGe3MBjtwV2EMom
         5skHSbQzkfyK7gUCUIMn8J/krqMOg1YPFMWtOBxJRJHywh64W9ch9U+nGrZNf46bbUSL
         QxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787686595; x=1788291395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=oSWYL+Nus8lbU3mCXq7z7oQT/mOY4PUlCniqEGKx2uEyAE3b1EoNvPQ6B5VlSLAIZH
         RPHREyfuA7xauKXT/mj+FsjsGRiAJAlFrXG3zqX/+J/K2vMBi9hjdpE3mD+eYz2BWyeB
         PLkyCMh7XiNXVH5bsTNkNMhS6KQB0J5L1lg49b4NxB3Ix7bKVovHQYP9e5YMnNOvYNRJ
         aXd4Rlgx4ywKgFR5NXNKwrTakleb063qjZm2tDl7YSd0OdTtuNqLCfvdmDPF3o0RIc1a
         Tdmk+m9cp9sWYDFRXGN2y2C7J02ZJ+PcKrFHFxX6GII+5ibj/oNxqnxm+LSPVB5P3Kqv
         BYvA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2hiOq+FeM+x+xN1YrEDn8FcXtqaZrQGHWjPd+0Tp3syt+1pY/ACPbkFcp3Y6uGyXIAwYLXS2DQQ==@kvack.org
X-Gm-Message-State: AFuF++kYr7LSyl7l93V9Og8AXAM8s7FObdSVMz3jjLWGJvhMPg2LhY7D
	AUNlu4BSKxbcrZBtHvkMInbpeT/QiLRaIXxpI0J/j641YXmC1kAMvFQHXo5aMZ+ua9DmjhllpWH
	0sJi/FNDierA781lt4PsvQK2Tud/L2bGJpz+pj605
X-Gm-Gg: AR+sD11WfbHQtGWzcffpW3HXZNZnwHW/uKGgoNtTcc5/iNzM0DdkdCYDeDOVYjjjzcD
	DV8ftA+aNRWyetc0Y9/Cz4ZqrZCEIrH6qILdd1JCq1dw2Ceg8C5xRW9RxRCnZK4yBOXPiiVYynX
	A+Vj7WwrxY+3SjmGw4AUPIDGWGwSzZyLI2OVmDJVrt8t9EKBlwbCYJmt58WPMXAi0n+xXwsv9+y
	EAHK1Y+78hiul1sh43+T6YZx3I/513Ph2ywBFDwdDBTGiIXt0WiuBtE4qgyvSy/aKoFva5hLcZL
	C+sZHIsVEod64sHjKwa33l/ov0xK8otUdcJu90/YCq6kHT50RRWAf4KSVh3kZRQ5xrRGNi2a+la
	2yABnc42NtrwlCx9e5MUqVlkK9dOOAA==
X-Received: by 2002:a17:903:1212:b0:2ca:4bb4:4bd with SMTP id
 d9443c01a7336-2d707b56b7emr797585ad.5.1787686594656; Tue, 25 Aug 2026
 12:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 21:35:57 +0200
X-Gm-Features: AcwNN1XEivO2VIW62cWvikMmNl_P5W9RRd7WplSlKAdk_NVsBbnZnmYpBAZkAzg
Message-ID: <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: afwgeiy94ohb88o9ggb6xcqado1ikwre
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7932F1C000C
X-Rspam-User: 
X-HE-Tag: 1787686596-343179
X-HE-Meta: U2FsdGVkX18/EHYKoo8ItFvy3zVWq2aIdPyspYQx9VC5mY3S79QkHbg8AuQlx9oH5st9/PocXcuOkclDey0bQcWQSJ3SpWcl3m8yyi+ZqadzCQdayXi9MRn2WG01DqRFcst30a9auqbVl9oEl+NTo1vAlPgEw4yRKcV2lv/SnLo8rLscvc+L5cgCMn56IhKji+BkBJivwg+VIbyPYT1ysSDh/0okiL9IacE66DNLLF8BiEpoEtPZZ4FO2280NuzydL67JGfIZewTv1Em7yzKjTT0WU7ZwNUIN/Jrdid2SNAObWe7PI1nTsE8sPNESyQM+JPIO/7EzGMbdWZFvNwCKckrpMFxoSAF4WS6cUFMXZbvAKjGf1Ge9VKnF5AkFPx/bheVuJdC6i/0vX6KWZpsoFmghOohM8u87ht6qB4xApWAUlC91d1UNDTRco21QxuYbtomEntuAthOIv8DTrAg2WtaoT817ngOinQdFgqymk40CaARgzn7VLfR6iNJyTXwP8Jy64hgYoaDRmC3VkXaBIH3MFFoh8fIoguuaUiuhn5uNboVrhRE7YvRKlFtJmgUhRWDjRUY4jldLTYbbkIwahtJQ4CVNiUHchB+WVCYGemXtyFirXugq8Rg+4UQz9ruu/i4VJAr70fm1Eai38bMPfRtV6uOhJfler2St1mKaVlkL7yWHZQ8rQKVeGSsSRnmZBs2G3Fuq5rpjRe4oEy4Jz6k/q6fFlFHOlYBoxrlpuGzLiLHEPDN3d5iPeldk1HvGTBaSHeQb9XypNc7RlJRVwssm1t1QVhluERi6hhod7gccP7O0rKKCJnf71sxdAO13Hkcxfq0TLb/GZ/kvQ/yx8I3nYlD3j1aZeyDCTBH755jmZAc99FEV/OXkuBmoGBwmjVJCj7Ih/uI6OvQ5IqeeGM4QYGB5yQRNaINf/7utCbI9zBm+ccCyA1UnpkMAVZNINwy1Qo/c1GCrziMJu+
 y6JIgMuV
 8iZDEl1msueNpPNDiE5ZrNjzfRZhFW3CGYoEWPR4vpcNpmkZFsLhyn5C0dIuL2xDJC7NFnRVmtg2ANsG0eh9o0TsPBjbbjGDTl/gF1Tu5j1xZ7SbQW8ZgYpiXF2lD5X5YnlSKh93faQiLktc9psEgUaIDnn84OPzzvX4okvYV9frj3+3QifqU7/fMeEAdLn7Fvggq0rtRKIvtX5l31cG+9nqy7/RSwJSTT8E9NB/KFNw+8N4absMbN0tFoy2EFZ4c5Yf4P7TVTfa6zHSg3j31lA6Wks60HYX+zApPErGqveheqoyzM8xCPCaitLx2vIgNHb1zGvNfSW6oUVH63w6UvsDeDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 9:08=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on=
.
>
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
>
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
>
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.

We currently have get_user_pages*() and pin_user_pages*(), where only
the pin_*() version is properly usable for write access, right? And
dropping such pins should always go through unpin_*() helpers?

Could we strictly ban using get_user_pages*() for write access, and
use the unpin_*() helpers to somehow enforce that folios are always
dirtied on unpin? I guess the problem with that is that we have no
state that tracks whether the pin was read-only, and finding free bits
in struct page to keep track of this is hard?

> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>
> My proposal is this:
>
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.

I don't understand this part of the MM/VFS machinery well - would this
mean that a long-term pin of a dirty pagecache folio could cause an
unbounded number of disk writes in regular intervals, even if nothing
actually writes into the folio? I'm guessing that could be bad for
cheap flash storage, but maybe this is in the category of "yes that
would be bad but it would be userspace's fault".

