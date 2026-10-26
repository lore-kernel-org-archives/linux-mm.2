Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5F2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GvM6xBSV
Received: by kanga.kvack.org (Postfix)
	id 77DD46B05B2; Mon, 26 Oct 2026 14:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755386B05B3; Mon, 26 Oct 2026 14:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B006B05B4; Mon, 26 Oct 2026 14:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 371506B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:44:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 102961C3FBC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:44:26 +0000 (UTC)
X-FDA: 85365652932.23.6747F4A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 048D640009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:44:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GvM6xBSV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793040264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46y44saD8P5rxD+OY5cJ+zq51H1Duo7SHt2Bubu77+E=;
	b=OlA7t2F5VMbutUPyaaSBTIs/UbYbPSsibdzgu15yqYUS5C2BGpmbkIH+Wfrhkg86ILrJKI
	9LYpIrO0xYAWwE/YZSPHLN32OOxKhgMW3Ak6aAG8LxMMlhwQ4SanTLnmjRSzRtWuD39o44
	5B4w5QgpLyIKpPAoT4PT4lz1QfviR3M=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GvM6xBSV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793040264;
	b=S3m9ll+eRuhifGhipQMfL796He8/6I0JSlgpEHz87HCxrI56R14O1N9reKLf+KamNmW8z8
	poxY13FiEAa2eux5upqvmo1g5ze+OWPMuro9DYX/IsU6kwRTN/9IpfsYe+ncipJyg4uELm
	Bxn16GKdfH2iAQtNImTRE5wy1xvzna4=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso17107595e9.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793040262; cv=none;
        d=google.com; s=arc-20260327;
        b=TDsYYuux5RyJI0erLMtH3zOO/rdVL+5hlZkrJEf8g5D9IXTtzuump0UOUsLS61kxiU
         RexKwrG1HJpJ0dewAdVZfQ6QamyBqJnnebdRWlbX2KRec8HMasKenIUg27ouyztSGgOP
         N3hlGtFaU0tCuWrNBpkH23ZTtJxCVVB9h9HMKsUPYt6vjd9PMGNtgJswzUby6ORtbtDJ
         w8cQwjPVHtV9sHVqJR1vxEKDAxjrefrubUjbbQBfxlXuKQ+sb2q84aHhA2eyrdVQrPeR
         FYlx/ou0XTwVALbr61jlLqMmMP0wJa30n9KdzckXs29+r9Vqn4rkF1qSaLXSz9TMMJzE
         MSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=46y44saD8P5rxD+OY5cJ+zq51H1Duo7SHt2Bubu77+E=;
        fh=z6S7bA2gdUm5PSRSD2X1NxJseULjy9V1se+2zLL/Jqg=;
        b=VMBkTMPGUsdNhAf0+A++qP2CuHi1hQHLV/bc9BPq4JZSDA3UoVu9KUHJDwtHD7/D+M
         aifgs7D2wb6ebYcFzmt3VsuncrAgHb2+VoPG99JE2HAfmF5ZelUWSFl8cVkanC824iF6
         QwnWlJIUOjo2owjkFaming0LCvKn8y/msTHtpzdSwRpQOsOCzcKVPna7mQqPlwuh+hyp
         P2pefxCB+Q5GQsM0nqxO85RDU4NqkLoLMkPEdosvI7Uy9GPrS+jIeG+jolcwBxMu6pYm
         yLkRcKYJVhuH7sp8g9Y+Rhq4QAaatmhwNb9D1TxraL9S4kcn9gCl8fh5OI3DZhoKnwg8
         BNKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793040262; x=1793645062; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=46y44saD8P5rxD+OY5cJ+zq51H1Duo7SHt2Bubu77+E=;
        b=GvM6xBSVq/1zsVMzYJNeKvyR2path3droYzIinC0kuQ/Q8ATi0BBYTcNhANWBg1eWx
         soMLrRMG/tIA4eRiJ4D9fqKNFhLQ2/iUAlvhIk+KYk7O3/Z4D074Bj52evPVgM3xnkgR
         gSiC+l09XreyPVOme5iJZAhkuNgJuim1cnGBAwf/Yz9GR7akSxZRC/BENVxcvL+bJKPs
         lCFKsnK3pF4YFfqcy6G3158QBCNWmCmnEFA5px7j6/JbUW9XTNLO4VurPyxuweR/QjfI
         Qd+pNKBCyTToM6gLG3SkZ35ZEGB3UcIHyfOC8F5or59L96MOSvl41brShReWen0EK4hf
         7+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793040262; x=1793645062;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=46y44saD8P5rxD+OY5cJ+zq51H1Duo7SHt2Bubu77+E=;
        b=zyqdqeew/zWz+2p7YWYDNoQyXwLAar55wRhoIkb2EGpl1jbVGwgw5zHBmgSGYLBKx8
         Xj/RqxkYStadJgZRnZpmhbOk4Jz7JLONHUP9FCBiwV56b/AQs+pTF1AnJ3tp++VG/DPJ
         fch7pxWRvdMz/IV8cujmXi96vaqTggIj+qDO1pgpH6t3Z8Wq9A+w25Xzo7tWfJvSxEE1
         ylDhfROXh+woSyu7px8bwjLKNwWzewFWtp0mpoI4cjeczGp7soEY47nK0TYgexin61S2
         vibDzgO5oO3vtgMqG7OYvDsL4iky49ylhHaz4ZKnWlyFYxwsrFWuY4jVyEdKytrkwTU8
         85GQ==
X-Forwarded-Encrypted: i=1; AKwUvByunSUFHWyOcUf3dyXr+DQ2xHygjp8bfJVyOuj0/9MxXkg+YqzSrtQF5BWSd3Y/GBzNz12/V1EISw==@kvack.org
X-Gm-Message-State: AFq9FYLW2RegQOz7vEvRVNYiZPFsSdNJFJkeNtorxcBbWAOXcGbRZAtQ
	N58wSDWmVbFyCBYBqf1JZsZnPZAQqMk+a6QSuOcxG7Sd8p652kF0HrxBY9kMAk43dY/6F6REI+u
	rAjyq6apdMrljvY0bmrvAASqe4HSf9GQ=
X-Gm-Gg: AYBFou3hlEDBNjHfzKP8qtgCe9vL/GCCpveRZ2nh+ugezfZwoXpWGyuci05zYomhgoE
	sVFTm0j29zXB0UvLGYfwQbmoZXQa2I1DjXPsEzV5wSE06uEjxdFASZw5rUSJONPq9rmDOnnjplJ
	zKsXvY5GkHurdBM7XyT7YA3RVHa0ebMXPSfdehcHtG1pIzi7t8jJgOuVCG0B4cDU3i6YoLj138i
	bKZFn9gnEalCPHIspXnKN9MQ6tfrJCzgRoP+GG9VsXdS8i5ELnL5+V/yYVF2vRDTV6hsLon3e7z
	F/8SR6RAvR5VijRRdxASPG8yXp7lPPKdlS9SgERkI1f1z4spKVW43fAPed1dfH/3OhFjqfC/zgO
	KuiIibBxXw6/K6+3Kejxm3VovZJZMCqEdPZMZ6vl8o9C7SGvv9Z6g977yXj6c4t2FxsdP26MkFq
	Tm9OVTTxNTiQNaF0eF4mXN7ScMK5IxkCmsOawXu6hsD/3WeG/pCwlE
X-Received: by 2002:a5d:5e8d:0:b0:48e:6f:19b9 with SMTP id ffacd0b85a97d-48e3eb83497mr12334198f8f.23.1793040262329;
 Mon, 26 Oct 2026 11:44:22 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org> <at9hs0Unq0EOg2M2@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <at9hs0Unq0EOg2M2@pedro-suse.tail5790ac.ts.net>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 26 Oct 2026 11:44:10 -0700
X-Gm-Features: AclHuK8AArvz4X8t1WY3GQA4kuy3-FUfTY-4j5HzxhSUW6GQg7l6zLPND04oXb8
Message-ID: <CAKEwX=Nkd5057Yze+9jbk+VQ+b7i-5x4EorQCyK94qWetOb_1A@mail.gmail.com>
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Stevens <stevensd@chromium.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 048D640009
X-Rspam-User: 
X-Stat-Signature: dubaf8pzbz53jyjqpde8q3gnygnfe1db
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793040263-523485
X-HE-Meta: U2FsdGVkX18W1Wax60dJnwfFgZ4MybbvytGPQUpoAQy5OsVFGEPnekruO1kHNv+luAhjxKP0uRFIu5IarArGCXTVvl2B2fTPkhaigCaXPSjXAEUsxWyB0mnCLvyu/UziltjCc4mzhZuSzmT1aUIVmqJPBR1iU4Q3B/u2UzYG3eDmAj5ygs0Bwh2sU/Rr+RSh2o3TMfNBV8X9zKaT8BcDqQBoF5rMmDK6x7V57KV15zJij+mmKflSe4WUbbhs0058/f2SzHiHJ8IRu4dML90i5q/zDqITg+3tUfu+3WIWVnWobh9DB3cC5X35yJgkxwMGcYsBJCuj8IfZDYcBGFc+NZuf4kDeftEOome+y3s72mWPRqIByvAqcVvfIXVuRY0o4sLOEOZXrG+ymmDZU1Az/7ZzKbjkim4qRcS23zD+logKnp5IuYGPAkSfEe8NPh0LeoIOqOqmsX/MkN0squI0nWgHB8uG5Sf7yNL2XwRP/Oznhl2U89RC/HcwELhAiOaHjfZ7uRLPK0Y+a0zVOTclw+ivKbdrNp3TNgF6O7qehFqThYlWC6Oz/sFtiF6w0RhHAQrIDZoF7ZKUzgOjHtJjAU8xdKu1R1vWhpNukpMr4IBQR8uOAXuPD2yl1+BylMjWleea5crqH0WOAAFOgbZWhOI2xVvKAc+lg813Te+yI9GGUnHJvy7KA+x7TLK0iC1oHSNrNU/N7Ha3mrWV4ndkHKe0rmx06SomORuO/vO8DqZJcQCp4t+FOG8RPefIIV/14s++izDH4bq6OPj0oe0BP9wf6IkXC1OhVRmnofA3n/r0Hipea005pxKr45IcXNi6UWhWaF+tUsKWPiqXyQuFCJXoAAmDELhAtC5MR3F8/Fkq+5ufE2HpNdyejjiHgcp8iJsuvO9capFD84A9dL04MqKAZ6yH1Vk97PSMYLUFpiGt3nLBzAdOCxINSfk0CUOVP4AfMXGgatdaWZQ4GZz
 naJGXOB3
 NvPBzs5PGkkIp/qLdRHvvBGhY679+kvDB43sJC5Boq5WAPgu8KolFObdPjOFnYH3bm71cf5RIsjCSKu7kVjOiM3NWCf+FHfok2LWNXP7OdFCgbt5Toy0NYeBMslpdK8BDk7dkaD/M8SUdeYkimwWVnZlUJcv7pRGZfip1eyBpjKr5YbXGcoreilekCmtRqBprPq90JafTdyqwuL4KIehYI9KLHR644fcfY42SQ4u3nDbTMTt5SoMWPlcRgnAm7TFxhQaDZW7dcJiFqUCRRabbmvdp+N1/0UCuMnMRCfHf0bM81KZ7e0QXOCNH/DV+QRSRfWaylGUFgFWsPyWVk6m/493FMyIVP1226AViqDcSMjCpQD4PpJWSDaoI2j6oKHnrdv+BnJlUOjckR+WXW5y4YKsyvCzFmtiDzCuYWlfUk/2xON2HcVY9MBqGTKb7svua28QNI6gNrLPwIjYqK5nI5YT40Z+6fuFAsJH5dpa/OnPiCow0EHyiF/Ww6RrknhFBMAPxne9S8R77F6gEgB4+nWAHwf3OyPd7Gbs7muzA+0W0nC156Qsn+/VNI9YdfzUhbRvY9UemAJJe4Dqe0H5ybck5jPxPwXmuJNMf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 8:14=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Mon, Oct 26, 2026 at 10:40:39AM +0100, David Hildenbrand (Arm) wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Once shmem_writeout() has moved the folio from the page cache to the
> > swap cache, the folio lock no longer keeps the inode alive: truncation
> > and eviction find a swap entry, free it and do not wait for anybody.
> > That did not matter as long as swap_writeout() was the last thing the
> > function did.  But since it puts the folio back when swap_writeout()
> > returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
> > afterwards:
> >
> >   reclaim                               last close of an unlinked file
> >   shmem_writeout()
> >     shmem_delete_from_page_cache()
> >     swap_writeout()
> >       zswap_store() fails               shmem_evict_inode()
> >       writeback is disabled               shmem_truncate_range()
> >       return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
> >                                         destroy_inode()
> >                                         ... RCU grace period, freed
> >     shmem_add_to_page_cache(mapping)
> >       xas_lock_irq()            <- use after free
> >
> > swap_writeout() behaves that way if zswap is enabled, cannot take the
> > folio and the memcg or one of its ancestors has memory.zswap.writeback
> > set to 0.
> >
> > shmem_unuse() already added infrastructure to deal with that.
> > Reuse info->stop_eviction to protect the inode during writeout. Increme=
nt
> > it before removing the folio from the page cache, and decrement it afte=
r
> > swap_writeout() and any attempted reinsertion and inode accounting.
> > In shmem_evict_inode(), wait for the counter to reach zero even if
> > swapoff has already removed the inode from the swap list. Add some help=
ers
> > to make the code easier to digest.
> >
> > Fix generated by an LLM and sent by Josef Bacik in private.
> >
> > Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() r=
eactivates")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > [ david: code cleanups; improve description ]
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> I've been looking at this for a while trying to get a smoother fix, but:
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
>
> Things I looked at:
> 1) Could we just drop this logic? No, it's fairly recent and seems to hav=
e
> impact on zswap setups with no writeback.
>
> 2) Could we reorder swap_writeout with removing the folio from the page c=
ache?
> Perhaps, but it would be a larger change. I'm not sure if the logic all w=
orks out,
> but you could possibly have a:
>
> error =3D swap_writeout(...);
> if (error !=3D AOP_WRITEPAGE_ACTIVATE) {
>         shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swa=
p));

Hmmm, say the backend is zswap. On successful zswap_store(), we drop
the folio's lock (in swap_writeout()) before returning.

Would it still be safe to delete from page cache with the folio
unlocked? :/ Seems dangerous - without the folio locked all bets are
off.

(analogously, filemap_remove_folio() even explicitly bug-out if
folio's lock is not held).

Maybe we there is line of reasoning to prove that this is safe that
I'm missing, but it just seems rather shaky/untested...

