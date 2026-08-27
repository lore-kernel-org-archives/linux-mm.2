Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B79BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F03F6B0092; Thu, 27 Aug 2026 04:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1806B0095; Thu, 27 Aug 2026 04:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492D06B0096; Thu, 27 Aug 2026 04:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 209896B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:49:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91EE11A036B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:49:34 +0000 (UTC)
X-FDA: 85146425868.24.C7E1153
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id B79BB80012
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:49:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="UVb/vYs7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787820572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1qjuH7DPdLHxaMJrgal+nSqcPVjkvrEhw9rBC64WAk=;
	b=NPc8dDDfxMlElkMZmSezSHp2JDC1lFpddGp/8geSJsDJAFQylHt9bq9QE8qN5Y2KtN6+MB
	iB2DHMzQQS0HpGYU4rz0I86+bqgUsokXtQc7oe20rPyFKIO74usw1DgYhBT9wUoxGxALgG
	CXWGG+BFDelkC5hWKGIdn5kU8EDcCS0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="UVb/vYs7";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787820572;
	b=kNw04XAkLlgu447GLMSWUf5EYMqBPQ5UAcmqVg9Q99IqtAiNwbN9nTHr93LjLQMl3c3Hc9
	1knScmYsFY96bYVihBlEe/M1t1N3kSnmYjBWcBPhEbD8qkxFY1jltFrKG+UGawayLlQihk
	mzGXy+LAfj/A8auiU5CfTtL588hLopw=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81e6f0b4610so19910847b3.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787820572; x=1788425372; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r1qjuH7DPdLHxaMJrgal+nSqcPVjkvrEhw9rBC64WAk=;
        b=UVb/vYs7MfUafFsCfLqw9fOybtLAK9lS8jbr1dvuWsGN45b59by+xLeRPEy4tQtQ1f
         UxMVp7jSi03LlyOKze1Y4ZyW8k7IVuLIasVYy6jRpi3Cuvh+u6pfwRISr6qIGs5Kg4l2
         qtRY09X1y2adP2T1heGrrebR/YYlZG+nAbyngKqMAFyfg/U+tBqXwb1njoEIVHyK9fvt
         QqalEdNeHk7pfVdUuUbIi6LQ2xTwU8FZqieXxeVf6FBv+If4QtiQAMszB2ysGA3MlzNj
         wDXc6lo2AFRDxU8Z7fSNvzO3EP2ujfQTYZwGHthVSZySFDGzTMh/5W919ffm8tv8EZR4
         /eZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787820572; x=1788425372;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r1qjuH7DPdLHxaMJrgal+nSqcPVjkvrEhw9rBC64WAk=;
        b=L+G6ahFQR1gidoyRQa9+ih/4ABwq9uSjV9TQ0atOCnHrzeBigL/U021ZaXyZYYOmwI
         5NJ2BoPo12O62LawEGGsNLvKTg1pyWRkfh86ZHaFPvyUksv2luhMnT/N02k3nXNubk+I
         /G/Zuws83haTYGwSkCBpAzI8o3cQW/tu842GRrPt7xa4/vJcME0xNWFV0Qmg7uiUZ6lF
         fchodeWt/0SFoxLcP8LK4i8vWO0rUrmWZar2kQmWRi3zEu9YJGJdBuL6/0nPWbCx/ltJ
         scaRFfmiqOkdNCDH9dr5rMqU6jLn/1Nk6CvF3u8OJL68duwWDUkkD9UBn09HpX9xwLUW
         Fo6g==
X-Forwarded-Encrypted: i=1; AHgh+Rp6XXlErc48tIi03Z/wTcFOvYOEexrc9eEPt/C/7qFSzJu3xJBLIqrJC4NBNn9J88yEO7AmEtXxkw==@kvack.org
X-Gm-Message-State: AFuF++mZMyGyptw2BHQL8ZipJL5y+iina0rbSr4WqeS1s3HpyYQraUSj
	Wh0nhJPxik/6DbwBj1cXi4htEwBLPpjzVoVxx2SWrmHKceG72qUP35tWATjiGa+0qA==
X-Gm-Gg: AR+sD12KR5EKhE2EI5PzBtwGFxevAUbDF0y7u7XBny46kprHE5imXFNrK5FLibFrzLS
	N63LIfLoS6tmH99o5lX/flEsrd1tN6QS3KhC0HFwvrP+GOt6SWaIxRfcmJoX93AHSX8aQgZDp2K
	Q54kzWv0fNcTw0jPJ2iaJRjjmF1hboLdSJPEVOTo1f4salklVm4FD9M5RUGyJb3zPnPNUkoGHiv
	bFgsWveJyxPTYoUmIv5pgtLoSBpMY75pM2eDksKwHrl8+Pz+E+1WKiU3BBhHhXezhSyA2am3gkf
	QMt5s82tXZj7P1+fc8eGKiSNcR1aitEMhA860Z+yTPjJpbrfsSwtRfS8BEUm88oWIOBYjpHImu7
	RD99vbtDTa5s6moq6ztjbMZNix73kbQ2pbjRdPaY3fNXf1qHdsbrOfc2vj1qu3I2tWoahFAYput
	2XwIZ8BAb6Flo9Q5xEJ0rtdC2f5OJZfmvZTtOqrbZdK9kjw5GoWXld0Sip6EixZDfssEuhXDidH
	oDp5E0urTar/b+uUndx/AwnZ+S3o2T5XfCBtuAXim1YkXYb
X-Received: by 2002:a05:690c:ec9:b0:85b:35f6:bc5d with SMTP id 00721157ae682-85b35f6bdb2mr18592327b3.13.1787820571154;
        Thu, 27 Aug 2026 01:49:31 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b5cccdd31sm6315477b3.18.2026.08.27.01.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 01:49:29 -0700 (PDT)
Date: Thu, 27 Aug 2026 01:49:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, David Hildenbrand <david@kernel.org>, 
    JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>, 
    Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
    Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
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
Subject: Re: [PATCH 20/25] s390/fbatch: no lru_add_drain_all() in
 s390_wiggle_split_folio()
In-Reply-To: <20260826155722.0198d3ce@p-imbrenda>
Message-ID: <2319f670-fe0b-f032-c0dc-486cbec0f3e1@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <7bf68e7b-f88c-6ca9-39ab-e9fedab0c8be@google.com> <20260826155722.0198d3ce@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9sqrintgmtinm46n856wym549azkxd7o
X-Rspamd-Queue-Id: B79BB80012
X-HE-Tag: 1787820572-765471
X-HE-Meta: U2FsdGVkX18JJebAJCCDe48r6BBvyc1ckPDr+ZzIpZ1LRLItUjE8lu1Epr8jFCvhin0+ZY0f0yq0I32XNpP5gsjZdCDOvfuXFfwN3nsw+zQRzQAJKmNxxjv305tEbaqoZcDnEQlGG28LRzkqavjREWUCH3HvVi0mr/1yJ8gfVsysJY0Mk6r6SZKU2EC1XWR8ScIHX+TRd/98+TPsWsR3f6XpDHbmWyBnu1kyjWFjBCQm4xuf5D3afxeXKKvMy1XLbM/fehH9UqbJoSAYProsvamcWSNEbYhF9heQ7PfpTgqwYCX/TP35i+i8qii23n93q3iD9bJVc+wIi+/ts6Z3Bv6ata2+XMTCm2W1g45FekjWEl4ypvUAEwZcXI492t746T6lt2MXs7+rrug+H2Ag7W0RM+x60lVDQvBj1mLTKYONPSyOAKlJF8q9f6NE+aoox3T3s7q7boYfcGyIeOwR6BLRoU1Px4+XgNTn5LsKUlcrMO48iSWAv2uUT9zeaFRbPEM6R7ylS1E5w8VQB42bDfC11MnBw8+caIr0oIXgxw0PhyYs/dDPAoL3m6e4h32N2ysFedgupzf54M8IOFznqUSVyrdW2p/rJPVtDl84AX3fX5TWiZMlOnHhpQLX8YIAxxjQHr73OezonF0b0HTO4fg+v6HrG2W1dk8lLgBBuq7TkK48BynmsU64JSxaw6Qn4DbZHiwlwYkxQIMCck6cWnapIyhlctZ++Q6DIRkVSJO/o3B0WSxwCzO4/FzOw0uvzquufUjkGOx22hZHNT9bO9M8u8SYwxeBniM7euMNy2D1i57ne3yGUFvVbnoMtIkkO990UupjQXQok69LT/J0q7K51vepNYmG57td+l7pwd4O3HEfFbHB7M/AnEAj+Ij9WjIy2dKPzrsIKXwI4zOfjjTDk+wUenuP45VZPARKGrqzfwUNq8asl6IziG04JMaYf3u1kOh5RfdrqbCQM4i
 AzkXiMtf
 WI4vlwVbU4d0vUiht6QMic4lfGtzAtv2Jtg3xZ+yA9LbAAiphpouBaJjemX84xP0P5zSi8LirCoIGbGP3AIBAiA71eN+1DWkin9ulzA/clEfR6egxPI8g6fCSdo05EMtCYPvJYTwKuC24vno43GG1R654+FBEhKeKIMxlWVeTFlCpHK0A3Vy27wOOc8WyDXRSdZTSoToa07Pqbkz9nK7br+Pm6PI/mfbd4XvqBylLpMBf8P2wKlFNu07edDe1PCZdxjvECXju0w5CHelXUtKzuR36WTWgiC9wQdDXarT9K0RN622OvDqh8n7sKFh/lbb4YoDyinC/2bTRx8sxi0tlm+RnAu5U0AoakLD/04TJtZzYM8SeeqFc+xS0DmltEuG0OZ4yUtm6pmC3NBkTiWZsga73hVvj9Wp91xdtuvCwjNMVRL3ZYXAkJBU61g8P2cRn7iM/xPN7ptUvXb03RxdY5Pcz5caSeFXHIrmk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026, Claudio Imbrenda wrote:
> On Mon, 24 Aug 2026 07:39:12 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > s390_wiggle_split_folio() has no good reason to lru_add_drain_all(),
> > now that the per-cpu fbatch references are gone.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> >  arch/s390/kernel/uv.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> > index dc14ebc0105b..120a467026a5 100644
> > --- a/arch/s390/kernel/uv.c
> > +++ b/arch/s390/kernel/uv.c
> > @@ -364,7 +364,6 @@ int s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio)
> >  
> >  	lockdep_assert_not_held(&mm->mmap_lock);
> >  	folio_wait_writeback(folio);
> > -	lru_add_drain_all();
> >  
> >  	if (!folio_test_large(folio))
> >  		return 0;
> 
> This is black magic for me, I am not sure I fully understand all the
> details, but what's the new purpose of lru_add_drain_all() ?
> 
> will we have a guarantee that no stray references to mapped folios will
> ever remain?
> 
> Any unexpected reference (i.e. not due to mappings, see
> expected_folio_refs()) will cause a protected guest to hang.

I most certanly don't know s390 or that code well enough to guarantee
you that no stray references to mapped folios can remain there. What I
can guarantee is that no references, of the kind which lru_add_drain_all()
used to be needed to remove, can exist there: so there will no longer
be any point in s390 (or others) calling it for that reason, to help
split_folio() to succeed.

You wonder then, what lru_add_drain_all()'s new purpose is, why it
still exists at all? I did hope to remove it completely, but found
two usages that I could not argue against: one is in user-forced page
reclaim (two memcg interfaces and a sysfs interface), where it's
still desirable to push folios on to the immediately reclaimable LRUs,
rather than leave any on the per-cpu fbatches preceding those LRUs;
the other is in memory hotremove, where it will be necessary to erase
stray addresses, through which a subsequent folio_try_get() might have
accessed a struct folio which (I imagine) might have been freed.

Yes, your split_folio() may still occasionally fail, because of
transient references and folio_try_get()s on that folio; but that's
so before and after the changes. And there is (in my mind anyway) an
open question of whether "folio_try_get() blips" will be visible a
little more than before.

Hmm, looking again at s390_wiggle_split_folio(), it seems rather
odd that it was doing an lru_add_drain_all() at all: because any
large (hence splittable) folios have themselves been immediately
flushed from the per-cpu fbatches, not left queued up there. Maybe
there was an earlier time when mm did not enforce that; and Barry
is currently looking to relax that, so the limitation intended for
pmd-sized folios is no longer forced on the smallest large folios.

If Barry's relaxation goes in before my drainage changes, then
there is value in that s390 lru_add_drain_all() in the interim.

Hugh

