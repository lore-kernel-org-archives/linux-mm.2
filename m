Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC8CC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 22:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB846B00CB; Sat, 12 Sep 2026 18:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5226B00CC; Sat, 12 Sep 2026 18:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094176B00CD; Sat, 12 Sep 2026 18:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C95086B00CB
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:00:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 168DF16058A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:00:21 +0000 (UTC)
X-FDA: 85206479442.14.D87DB59
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40ED720008
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 22:00:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Cg/241nf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789250419;
	b=t6ar4vWkmJjNkGYLgTk8/cj79e9ch20pQXCQAKgKR32Chsd4UdPEtH28MnuSN8qkLs/7n8
	hUOrTKQl+PgCWpmPxZSkzVzbe+wkjxSd8ePrzkDJ5gE143FPDDDbQvDTcqFLz6wDWof6p4
	HeGa6PrZbbrITXJyosSkOVdtufI8mSs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Cg/241nf";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789250419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShFFlTNrkhtcTY1WEEF9s6hCAewZPx0n3fIe5hLvRZo=;
	b=Un87FemdWLXkFU1x1PNojdwsZXhyk7JNCzoqt1mnPIcGssfkdsT/msuZEDW8iIETXaHB2V
	d3hSUG7z+7NF1jX2es4k/z/iO6B9B+/vX7NPsZXSFNhnI+Bp+8eQNC4WyfbHTtGPMDWg9B
	8SFRS8sdG8Ym98nEsilw/pzlSFgCphU=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ce364488dso2525155e9.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789250418; x=1789855218; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ShFFlTNrkhtcTY1WEEF9s6hCAewZPx0n3fIe5hLvRZo=;
        b=Cg/241nfbHlO/dgzs37gi8zt6hUCiLA0h9nhSXwdHsFSQEUYyfj/SD1iZBQ53FvrVq
         Zdd5oE8FcvdopQJ5fxU/YH3Tq/C8EOZCep4idZXwtZDWTobJbET35siku5OtThf5HmyR
         d01PUciWUyxo/b1fwJLyZS/VDYE0jscc/85IbmjWDZPFQa7zB+IVr0gCG5bsN3uqcX3Y
         eumLg8Ml4eBpnHiM4sU/HN4TKFcZfA86rmPSqkm79sVBZrDClFvB2GzxAUToAKAmXCTs
         rGAf0BVkI2t+WO4xv52TRL19tWbo2fbv6jfkoWkP86LQ4Psosq96ZjD1HXiuv98f9/+I
         J+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789250418; x=1789855218;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ShFFlTNrkhtcTY1WEEF9s6hCAewZPx0n3fIe5hLvRZo=;
        b=p/5UOXQnlUN36FD4EvBsCwjv5l6CiRxw63bWQgudxUvL+0DfYKcN+YXqgqEkpN4+Zw
         Qrs2FHmPMpN32iP4g6Zn9Hybm2nvZak6sBZE/t42QsqQKo19hWfJpfH80qehbC5Oa8Va
         tKKXQjuNibgockQB1gnZHhJPNem3/iLan68OinH80QC8nGUn7CzDKmu2t5tq1emxKW1T
         00b4ypXoo4gNXuwggS/nloCzUY8+qxHV/+nK9USgI2hTGSgv6oUfBATRy39P7JEG+gGE
         zTiYnoP8bnsTiJtUfFRdtgKLsa2TjJ20nQQO6BadBmLX2Jd54y15eMr1ifm5LsQxGi43
         SOSA==
X-Forwarded-Encrypted: i=1; AKwUvByOZIQeiMm9/F6vr6xSPU5sI2yP0OY/bjsUvjH8Rb66pDObaoQJD6ppC2qwOM3Z46fALvpu4zJ+lw==@kvack.org
X-Gm-Message-State: AFuF++kx97PxuJhWlKjD4EbPLGEk44NlwPPIW2s82515MaM2vOtowwgX
	Mjo86u557XGsyAtb9j4Y1wqSYUJKJQy62+59pVxRqw1o5zEtXw1J0S4A3LwUFgTf/w==
X-Gm-Gg: AYBFou038+7gi4SOOCkLtfYOIlbHPSp9VIBFm0blH30zK92HbhQUBgs6dF7fxXhagfu
	zsjD/UpUwqE3i4al17OrDlMhFzAB15YplEOjp9g4FwdDVGnCghbluymMttZIwl5sNIEvUwNwwMs
	pYTGMqc0Sz4pYkx8nRLJYw1mLhNh1PV4lH6rPj6UDKxCB+UbZgA9JRWLb0Nl0Mdsgf3aJrqt5Mh
	x1VGfRz3lP47LdJsbElyyK+QugPCIj8S2jHB0LkssY5qq28plFTXAgxNLSxTNAp5oGeDqxqQMB7
	Y22CPxfZKku2OhcPPeFRugUq17+hB7UBKRpKR98tG+zBWkSZtPJUXSABMZ03rbbKxrrdMy8fl7H
	4RlsAjmByz132LdkyY9J8zmipAb0SASZNtjm7YOizpXXzkGiCy5tyCdKqIQ5/0D0bvw/4yYIT1B
	YSwTaaj/C/kn1HHPNnSk4jYDXH0hKtqhp6V/qZVei8W/Qr7FlUy0kEnUL5K9d+Vxbuz5+1sKadk
	GIxGWWUMUJSZhGyTwfI
X-Received: by 2002:a05:600c:3115:b0:49d:1e79:35d6 with SMTP id 5b1f17b1804b1-49e61094b9bmr117724205e9.14.1789250416975;
        Sat, 12 Sep 2026 15:00:16 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e64221639sm67265195e9.4.2026.09.12.15.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 15:00:16 -0700 (PDT)
Date: Sat, 12 Sep 2026 14:59:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 05/26] mm/fbatch: lru_add_del_folio()+folio_add_lru()
 after clear_lru()
In-Reply-To: <af864862-90f9-4b16-a06e-1c189c4c4d6b@kernel.org>
Message-ID: <5c943056-cf6b-788f-aa45-b7c0da28ecf2@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <b2e312f3-6909-5496-195f-ab71b45970ac@google.com> <af864862-90f9-4b16-a06e-1c189c4c4d6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40ED720008
X-Stat-Signature: k1jpsebwrgp1g6hncx4x3ndwzfi94ku8
X-HE-Tag: 1789250419-243046
X-HE-Meta: U2FsdGVkX1/C7FbYa0d5EkNIQjqRukHiQCaeXGnTuCCD6EuXzDd0Yx6oofo3gLPQ17/pyww9aq9nOM4HDprbG+E4V7Gmdvo7xCsPrUzreKpV+u12M+1wljyIGs5uMMymCCZ/xLwODh8x6XL6tYY9JMAbNd3rJbijktqaUZf8OMTdy/2yjKxlTv58y1HmnZB4q2g9+pEUZxrfB+RIkHRA8eccQYehwLZK0uo0tmVcb2iwJ96eJ79XhRakyo7iuYuF9qvoT9qbClBi8ONa26t4Ef5SKpDiJNGuNROC5SxOi+xDJk59yNlB1Okkg1K5KMyV//iB251VZD8q5mhj+kyLQjU8nsq4kJUJSM01rhCadxOMkERe0pv0+zygKj9g6Ds5JR33MwwpNADWp9nD3xX1RF9eo73CXWlZTAP2/0XDdxeqs635sxqisRUiHDX+RmbbR2xU3S7frPP1eBbCRfMw3qnsYDuuDaVfCkgnyKkDZHL7VHACvfZiC7X5XksNuhONzIJk18EihA/KoOBizvfwFos2BB0MmdgJi4PwFh9JsfXGP/056e54VgDsP8ZRb/bYa8c7IdhNWACSsFn+SmGPqGLxkaDUO3Qx9+kOIYA7JSuGPC1V+spS95w4UOxsc5GBJePoK79YYqCQOohnwTdlvsxbv8ejUcdR3Qnj7ot3Bw5TFAQZVxFLcOEPR58/uCZr5BA3bbejCykfVNB1YmArLfJlrALc86r/8fONnSceCqs55j9Gw58Ls6S5kXt06dG2cTYY9b63z5DCtxZtFwm5+10e59GjLF1jZwk2LNfuM9ogq7vmDUT1kT7psa2QdTGRQ8+ZVLyu5kkz4tB5/YivUHuvzWn45k3Y/dpIj0k7Fifu0k0QLfDn0FYsRA1eQk7iPLG2CeJsjhV3s6C7FJt+mDoxbWiJvujgd9+Gh0BY3GJX2VqIQLGHaKfSL7pYn12LjF6xAp12NC01+odNXVq
 +1dTu8TO
 VOkQrAB7CrKADSK4kJjO4WzfTMBLDL2CTOPQ2n4VnC9J5uJh7/EFy3BbfFPwoUoozW8a4znKctUu5jjNCfKWfDQZlDjJgRv06rZFmcTS0amknLFGd41MlafCYpPUoG/WaqDrlm+KaoMqKqD8NO56K21ZyaTpdfSxzL3Fc0I4sL7DXevU3sBxQuL2cm29kXnfH7capKPdWeeqeKqZWQATSiStzq09eUuB/+r9MyKCeIKWee7aAh+rbUIVi9C+/t7cy0k/wBwb1giNwOk8J+Bl+nqG4Fz7fHmx7wNQjaaWGRi0+YufQ7GZass+yv2r2tCc6FwR27D0rRu9tSfd1s3Uk+Dn5DAdjpEX3rOOuCFIrHUzY/1NiRfaSZcTJ0iirT4FKPbeyobb5rIodB8jtNiYhoSWJHxziK/vRKrh9ovA8EoCP0+FNX9pT7QFFBkqY4psrrd6hMNN76NkuAtpLe7J37c6ReVW6ldC42N5Qd6YsNVoyfzs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026, Vlastimil Babka (SUSE) wrote:
> On 9/9/26 11:51, Hugh Dickins wrote:
> > Most callers of folio_test_clear_lru() then proceed to remove the folio
> > from its lru, and add it back at the end when they're done (if still in
> > use). But isolate_migratepages_block() and check_move_unevictable_pages()
> > sometimes decide against, and release immediately with a folio_set_lru().
> > 
> > Which usually works fine: but there's now a small chance that while they
> > held the folio with lru bit cleared, an lru_add fbatch drain came along,
> > and had to skip that folio because its lru bit was transiently cleared
> > (previously, the lru_add fbatch drain relied on finding lru bit never yet
> > set). This risks leaving that folio off lru, unreclaimable until freed.
> 
> So this makes the previous patch a somewhat bisection hazard? I guess it's
> acceptable given it's not fatal.

Not what I would call a bisection hazard. Yes, the preceding patch
is not perfect, but more reviewable that way, and then come corrections
to edge cases best considered by themselves. Nobody bisecting unrelated
issues would get held up by this gap, and it won't crash any bisections.

> 
> > Fix such cases by trying lru_add_del_folio() (which only takes action and
> > returns true if the folio was on an lru_add fbatch), then folio_add_lru()
> 
> Oh ok, that's one detail I didn't realize on the previous patch, and
> explains the name of the function. But it's still IMHO confusing.
> 
> > if it succeeded: invalidating the old fbatch slot, appending in a new one.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> 
> In general, LGTM.
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

> 
> Nit below:

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f11491ee9ed5..4e8d5cc34f07 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -8093,17 +8093,19 @@ void check_move_unevictable_folios(struct folio_batch *fbatch)
> >  			folio_clear_unevictable(folio);
> >  			lruvec_add_folio(lruvec, folio);
> >  			pgrescued += nr_pages;
> > +		} else if (lru_add_del_folio(folio)) {
> > +			lruvec_unlock_irq(lruvec);
> > +			folio_add_lru(folio);
> > +			lruvec = NULL;
> >  		}
> > -		folio_set_lru(folio);
> > +		if (lruvec)
> > +			folio_set_lru(folio);
> >  	}
> >  
> > -	if (lruvec) {
> > -		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
> > -		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
> > +	if (lruvec)
> >  		lruvec_unlock_irq(lruvec);
> > -	} else if (pgscanned) {
> > -		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
> > -	}
> > +	count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
> > +	count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
> 
> AFAIU this is done because we can no longer rule out that !lruvec means
> pgrescued is 0.
> But we can still distinguish the cheaper __count_vm_events vs
> count_vm_events? Probably all the same on x86, but I hear on arm64 this_cpu*
> ops have a cost worth proposing rather elaborate schemes to deal with...

Yes, it was just looking a bit baroque to still be deciding whether to
use the __count or the count there. Could be done of course, and with
"if (pgrescued)" and "if (pgscanned)"; but I haven't noticed anywhere
else in the source where we go to such lengths to use __count versus
count, and I don't think this is on anyone's hotpath (IIRC this is
just SHM_UNLOCK).

Now you've got me worried, no, fractionally worried, about Shakeel's
recent __count to count fix to NR_MLOCK.

I am much more familiar with x86, and have noticed the recent tussles
over improving arm64 this_cpus, so that confirms you're right; but I'd
look for juicier low-hanging fruit than this, if we're going to
embark on an "if (x) __count() else count()" spree.

Hugh

