Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DFBC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EED6B00A5; Tue,  8 Sep 2026 02:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816776B00A9; Tue,  8 Sep 2026 02:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752EA6B00AB; Tue,  8 Sep 2026 02:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCCD6B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:59:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA95C1C20CE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:59:23 +0000 (UTC)
X-FDA: 85189693806.17.0FF7271
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf15.hostedemail.com (Postfix) with ESMTP id C099FA0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:59:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ntZ5KkZo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788850762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfNYm1uiseu4qTpQSsXJ4D+JYuSRcCGppQvoQ4b5vpo=;
	b=a9G3UfaDG846ZOntUs2xNn8/bsMCU94vlGKeIdXjldoG7EeaImMXZeH6krTn/I2Dyp32Cz
	SGf2OciOEt7JIhvkSLdGEX1XB23YSNC4Y59f6b5CSBxhX0rik706zf0nK+7Oz5trhNDG1X
	/KMTti3p2aGM620SrwIW10vcLja/RqU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ntZ5KkZo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788850762;
	b=UWdk36twuOtU5HuuiYZjt6MFOIgdWPmDIK6Ni0rk4Aio25J4tgY6PqGUREtdiw6Y/E/Ix+
	8O5W1DncG7S29Bi3dXVyRyVHCjaUa66htVhxy2jnslE4rMJge4UUFXS/g/lvOgWuIHKcML
	26/ATpESAH3+hVPh86eJgYpIE0ALhoA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/cMB1daxP3CSTnSwp/1Uz+ebWze90XSmIaF608egzq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788850758; v=1; x=1789455558;
 b=ntZ5KkZoNZa7UGrUHbwDL8jfssBjQ4M7w54aXSu1+oFDFYMUx/7PjxtlhC9GDHEYHIwAhJJH
 ah9pqe4HGA13/I6dMME3GW3ImH2pledE+RXYuAzK3NA1MpLWfMr98hH9+Msu0LgrtYbTbiBZeDY
 /RRNmHmJwu8BxIeJJ6pKGjW8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id cb524ca6967486f1;
	Tue, 08 Sep 2026 06:59:18 +0000
X-Mizu-Trace-ID: cb524ca6967486f1
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 14:59:12 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
	ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
Message-ID: <ap-yQOH0pni-mfdf@fedora>
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
 <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
 <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c3kf7exo69njwgsziatinqoxftaa68ej
X-Rspamd-Queue-Id: C099FA0002
X-HE-Tag: 1788850759-819966
X-HE-Meta: U2FsdGVkX19BRlfsPs8pr7Tn2Wt9cnpe4VzCP9TtJ+yMIzSxXo9YzcTjktkZO22QPT1jgvGmfbZZ/5AMH4Hg6Lt3fAtbuVqtlxcN7SKf6O8mU8gE+KbwFP/DTt61YzjFCz+01cLT/zaa1yo/ubkhpevTLUOkqtr8dpyQdNu5XTw7y3Gkr9ebHc74Rue1VAx/jxsmo93qgHor8ueIt744T+B2fPtGZcEFY7kH5Bw1i3Du3Edfm1+Y7icvyGg+kSWmQAZ7XInSO8wa2U5vm90EBKfj2mDuXJfL80SU/2WUUtEpastNj0Qifx7u3KUeJr2cgMOkAQ44wyLjXsOVihVjhJ4PTvO5y/BghfCz8NJF+yKhAqU/rXB9YZwYJD2iWM3wzaBzNAPs3xkz5+roUteeF0Fnp3iLYqkD+dHJU6i6idm7cnbbtRYA9CUXrVtFAe5ce5viqeeY5XzNLGzs9SZH85vq0enBjAHHRYpKcVKKUoVVw4gOI0dTEwKCGIZAqgxJ1gtPg/FT9edyRczUppjL97gJlh/k+gG9bpOskgKfiCkkX3wj+hjlpvyW7Ag/lz89zD23CbB7kp/GQa5L6R9G74BxJgPhIUGflINR5PH81I4bgaA5hUVeAEZhJa0ONsn2vT3My3ez/GW4UJ3UJJNAI1o34D2bdX51D7CKggoaiCDMuHFFmq9+RQNWv+dlFKdpwDYfxvptID+sxpt6XpkrojFxyIRVIBNvugJ3E3TqD3SJN4MgwMvRRX2NKZ2wFXesCHMZP9qN6rjsG20l+iPVEjQYteBe6zCZDxFx1xjndPkl6goJTjizoWlAWjZtd3X3ewcrOi2n0/6Z2g8+gY3g1Ok4uMSalRed8/I2KZAgbMUPmC9miOCJTvCopUiAeBl6eYNnAisdB+mLXZ4sJINoHWOPDmIsRcswM6FDyeFhs3AyvJLkwWu9WsG3GvFVEeHiJphHiDLAbrxnDug/Irl
 Ka0wVdwx
 ysIZAiaL6E73gAs5DHbkDrT8rbSVTmJKby/W+3kSZ4FD0+c3srLWXYsB/XqHP4BS6NVo5pKEOvWbxYGWEsL9EjJz4gyuLfoErK74lzt3Txelv0CFr0xi5geYn60KrY6sNlhBDs4WUJDQNi4N06IB9TBpbKbkt/JRx7Ry23s2AIBQWYG/zfV9DtJe19rdIuHNLl/jGvXLckjWmY3T0dMCulS2CWVDYuVZhKGSBLyVz3RUqAcFX/7J9TAIf95Z97F3yK/6kMDlBW9rsI/wVy4B/jQBf6hBNb8Et8ko3LJxVLeoFDuLS1bry8+KI1YOr8DGfvwja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/26 at 12:01pm, Baolin Wang wrote:
> 
> 
> On 9/8/26 11:03 AM, Baolin Wang wrote:
> > 
> > 
> > On 9/8/26 10:34 AM, Barry Song wrote:
> > > On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > 
> > > > Hi Baolin,
> > > > 
> > > > On 09/07/26 at 11:25am, Baolin Wang wrote:
> > > > ......snip...
> > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > index 40d3f1b48a74..42c0a09938ab 100644
> > > > > --- a/mm/vmscan.c
> > > > > +++ b/mm/vmscan.c
> > > > 
> > > > Well, this seems to be based on Andrew's mm-new branch. I usually track
> > > > mm-unstable branch. Maybe the subject should be marked as below?
> > > > [PATCH mm-new] mm: mglru: clear the reference counter for rejected
> > 
> > ACK.
> > 
> > > > 
> > > > > @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned
> > > > > long nr_to_scan, struct lruvec *lruvec,
> > > > >                }
> > > > > 
> > > > >                /* don't add rejected folios to the oldest generation */
> > > > > -             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > min_seq[type]) {
> > > > > -                     folio_set_lru_refs(folio, 0);
> > > > > +             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > min_seq[type])
> > > > >                        folio_set_active(folio);
> > > > > -             }
> > > > > +
> > > > > +             /* See the comments on LRU_REFS_FLAGS */
> > > > > +             folio_set_lru_refs(folio, 0);
> > > > 
> > > > This looks like a great catch, while the code change could bring issue.
> > > > 
> > > > Because move_folios_to_lru() relies on folios' flags to decide their new
> > > > generation. You just cleared it before move_folios_to_lru(). This is no
> > > > problem for rejected folios that are determined to be put into the
> > > > oldest generation. But for those rejected folios that are determined to
> > > > be promoted, this could be wrong. E.g currently gen window is 4, and a
> > > > folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
> > > > is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
> > > > referenced bit, this causes it being put into the oldest generation in
> > > > move_folios_to_lru(), this is not expected.
> > 
> > Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs
> > to be reconsidered regarding whether it should rely on PG_referenced
> > [1].
> > 
> > For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios
> > either. Before commit 6cbdd9726fb5, if rejected folios did not have
> > PG_active set by shrink_folio_list(), evict_folios() would set PG_active
> > on these rejected folios.
> > 
> > [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1-
> > baohua@kernel.org/
> > 
> > > The original code looks quite weird. It even prioritizes folios
> > > that won't be promoted by `PG_active`. Do we need to change all
> > > the cases just to call `PG_active`?

I would agree if we can. While I have one concern. A rejected folio that
should have gone into the oldest generation is now being promoted to the
2nd newest generation. In the original code, referenced folio is only
being promoted to the next gen. I even think this is not a bug, but Yu
Zhao intentionally did it: the coldest folio is moved to 2nd newest gen,
referenced folio (hot folio) is moved to new gen but carries the referenced
bit. Both of them seems to be treated somewhat equally.

To me, I would rather move both of them to the next gen, while keep their
refs untouched.

> > 
> > Yes. Regarding this concern, I plan to change back to the original
> > behavior:
> > 
> >      /* See the comments on LRU_REFS_FLAGS */
> >      folio_set_lru_refs(folio, 0);
> > 
> >      /* don't add rejected folios to the oldest generation */
> >      if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> >          folio_set_active(folio);
> > 
> > What do you think?
> 
> Just FYI, after above changes, the performance improvement on zram is no
> longer obvious either. I think this also answers Kairui's earlier question
> about why I saw a performance improvement (which seems related to commit
> 6cbdd9726fb5). Also, there is no obvious performance regression either.

Hi Baolin,

Not sure if it's convenient to do a little more testing in your side.
E.g rejected folios are moved to next gen, but not clearing their flags.
Then we can at least know which one is more efficient on yout testing
platform.

coldest folio      referenced folio
---------------------------------------------
max_gen -1         next gen + referenced kept
max_gen -1         max_gen -1
next_gen           next gen + referenced kept       

Thanks
Baoquan


