Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E80CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 04:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA138E0035; Fri, 24 Oct 2025 00:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782198E0002; Fri, 24 Oct 2025 00:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696F58E0035; Fri, 24 Oct 2025 00:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 558D28E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:01:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D835E13C2F6
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:01:07 +0000 (UTC)
X-FDA: 84031657374.18.1801134
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6AA8140007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:01:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PwAiR4fM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761278465; a=rsa-sha256;
	cv=none;
	b=eNDCl4KD8CI4mnwQnI/MSAiqYo9TOrC1kr6O8UEE8QWiM9wp3fTUGWq38CWOmSIvI69YC/
	CHAUe1BUNq2kjlB8Sjk65/+zRTRfUSFCJjMZhVV+YgiWT46NvjlbRGjj3cDHUTZQginQZJ
	2eigu+AEk08CF1jAqDipw5tM/jVvCA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PwAiR4fM;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761278465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX+AGT1PAEb2wRzHRL+8B92/Z4uxx2bE66SuwJSj7jg=;
	b=4Za+4bWf4KH5O78T2qRwFOznJsvyJ0jHHXJ2TWEpHe4XH8TNpqwwGJTtM2NlXW5lYAVzGP
	dSQaWbjLf5bQgASZU2XfOmGIWTAhe2fVIBRx9VYxncQ8X8uSFlW1MrwScoC25UGDr/CVx1
	nhXttS7PqBqMWTjo5ofBdjys80aSKo4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c45c11be7so2783064a12.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761278464; x=1761883264; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bX+AGT1PAEb2wRzHRL+8B92/Z4uxx2bE66SuwJSj7jg=;
        b=PwAiR4fMqFr3AzxB+C/OVYcb46Zy3cBtm2N9HlsKdsQzxLe2X1KF0QyHYNPVqU83td
         5ev46x/9tdCO8QmrPQtdeklqJqB7rEiPdYw784EthWQ3AnpXs3ef+kDK6vI5t63jWI8w
         fo3+Dk+ROJiptAvBGbDelNoG+wiUHJA3vXLtCtf4UsvrvBC1dgo4T2+24ZSWw7YpkpWG
         MZujAdnR6KJLxPO3GadU3i/tQ6rmHw5E5lUi6k5oDGy1KA+a3qnl+m6Z2OWPg1kUxSuQ
         fRfUIA59XU+LyGDr9DmZsAx/G6SnalDV13/P+gS6M+cRWvoOugXIfrcWfNfUoo03Hvsr
         t90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761278464; x=1761883264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bX+AGT1PAEb2wRzHRL+8B92/Z4uxx2bE66SuwJSj7jg=;
        b=gKzfMr7aeY7QhtOg3042bh8NtrxxxNIbyuQBrJr5c+YxAgwXDileyS3fVetsVQrAIX
         AFvnj0IgIAP1LRWLvjWlt54TAz/hz+hiJ7jQTufCcaouon0lunm1J4q371nVNvuRT4ph
         q/h5Zx/jbY3MX7aO2q1yyh6dRzVPya5DHsOA/ah4KhqZ8KsdBW87ZwpRmCGjdln2p964
         RbxJLfh4Q82fQAsXmMrnPP1I9k0+3+klHSNYbYg++sCszOyYapP7fboJa+ahP2Wu0Hfj
         KoEuzeYJEPnjNa1/H+vlxuEj7/VJS1Ws2yy0OTMSzcnDUTRC/80+x4xkDOf5FoAiBdvh
         iX5g==
X-Forwarded-Encrypted: i=1; AJvYcCUMjobRIx/bj/UN6m3Vyqz4+1UHDPNd+6qzX77mWXPgHkNnHD3AkomOdTlzkk1EJ5R71u862fj5FQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2dfAXRjmRXJW+GtwaRBWufLuBUmssiFPEAphCRQ7e0ju0b7GH
	+9Z/u6WYbnkZ77bjSd+K1+QpcFcNEfQh7ST2fCYZyexLNwbrl9czyurzNs1zIKom6tHIJ6YGp4k
	O7xQ/WyFDyiJxG+a+k3btebLKl1Wj55s=
X-Gm-Gg: ASbGncsMsIF2HQI19d0lInD1ah8s03rNu0j0XfXZeNQw6YLAz7bgpPwRCFBQY3DWvnj
	IQKBSXGK5Eoyh8vHB+OgBPv3+jX22K44jMSeHqU0WDRWgRc29W5uDxHxHUHsSG67XDRWL7+mBBW
	38BieI9zinwCWcRMV5W1B+kP+p+mLSqSphcf/nJux8OV5DplzrVRd2TN3WUseDnPYALOOQ8vri/
	xm9o7DVYicqt53jbTFF5g9Yje2P/9RupmDmj4yAAZuZVME4uQ8sPuzoyAc=
X-Google-Smtp-Source: AGHT+IHncX413Zw579qxe0Qf5NgqYwOEtK2z/nG3SfbdqAmW/ND46AejAhP+66pY1PNOOUa4grOi1M19bZwDtf3Z0pg=
X-Received: by 2002:a05:6402:1449:b0:63c:2d72:56e3 with SMTP id
 4fb4d7f45d1cf-63e6007c37cmr933871a12.23.1761278463985; Thu, 23 Oct 2025
 21:01:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
 <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
 <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
 <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com> <aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T330>
In-Reply-To: <aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Oct 2025 12:00:27 +0800
X-Gm-Features: AWmQ_bkc9YwuZtUhzw52MpHd91KHJZxGIdtGa9Ii8w-Tgx94sUw-dZLiUembJcI
Message-ID: <CAMgjq7CELW_s5ok-2NHSFzK3SQKQKHB3VRLGnFaGGxe5c-eCvA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6m8aws7bs6z7beygqpm3qfurg1aqrwza
X-Rspamd-Queue-Id: D6AA8140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761278465-960686
X-HE-Meta: U2FsdGVkX1+B33aRwvOS+747hLzquHWYgcruapwmqWFEA7DoxnUN5wYlI0EHdzyzYY5VjTW0PvSNo3hNsmZoK6X/gjwPQp1yTh0vefQGeyAPosucycOZug7g0SwNsMq0yhm3TAV9iiepq2H/5d3bHmT7DWx+DS27PyV6MzBYrkqjpL2Rrz6R8KmrzrOGPp2mrBhXWPcy9Oauy6vomppigPKTJG5sbRexM8V8clsbcWWVUKZjU80yQJgKTwYmaJa0TJpJTa31/FEvXiMtSYHMl66nEPwHGPEIVdkaNRQx95uescVS4z9SWE54ttKPKjZKWFlveV/v7h/7oPbcPXwSOFev9tCBj73IBre4lu8T/Ow8ek1oZNgJjhu1/PWMe1Zj21u/+duyhEAHiO19N2JqCp9+64EsZWV+6hqZN6KTNCDxH/5XzShpZrRkNhKFzCAqp8vJdTZ4Ft9pfn8LMEeX4pFCrtDJStcxY3rI5pgKk9/GoG4sNB87wFkvF8b6aGPLNSa25qjGaYlGLK8CR0pCpx6uQZvg1W33jRNEph1zF2Gc5p5IeHjAI699k3LKX06XctokGgp29j0TP1jpSwdsoYwLfMY5zbE14eFkfaTjW26H/WIfOuWd0J2ILvpduitaQ/WPPDcGlgj+EK7XXvpW8aQygMpXPUJF9gRP4ryQjPtUO3NgbylkGWRqebr006pP+pAD014B3MOi0fIbJJ7d5FSJmPxx+mIi8hvWePjRG4DFFJzdwezCcEDF7PWFLZ3zA5EgR1QW/hLgBNJgnNMSqy3246s3vWtosucJ4338Sar9c++NZOTZFCLYUmCUsljJWnHrFmvjAT/VHu6pNql5KSnn/88S0RVuqVzHIQmr3KLWXHhyD7wN1iAkHjyQg3o6J/lsD9zcqBd6esvlSo+DZ73cPKh2BbHdGeSgEP6FGqTEbpi2t1FmGhBmETuDqaiL4kTM+MKgZsauU+Z8f5v
 a3IXvBui
 lQ5OsSNCpGdpHwKJgBpDABc3UUqnMFg5QAhJb72Y0wbSqAe08ddicxq9RIj3UPM0pU2yWzC/ZRZQCZ+X5ejJrSbHz5c8+AQAPRdCgakR6hFeiT0SM9xDeENc+0zwFWfr+cHsHkrFSkYbgLL8EadwB8BKbkU/jYiRmjRRnKXW/UzHbvZQPyhVLzsB6G6+HcW7aOfnXeF5tekJYRl1Iylksl7I6dMYdooxSCMvqzdGM/gPwb/R1cLIM4gOMYckJTF3rfxcyx2ZasiT8NMKWcO1LhmUTV+Tg3GjsLOKOIoFuF3hZ1YtGUW0HSXv4+Qb53JqDTMmzgVZsuVRCe+SOsoN7VPfKv8YidDxWmsm7Zkw12OuNFMavIiBZb77nLnyvnEQJB/Ek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 3:34=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> > > Thanks, I was composing a reply on this and just saw your new comment=
.
> > > I agree with this.
> >
> > Hmm, it turns out modifying V1 to handle non-order 0 allocation
> > failure also has some minor issues. Every mTHP SWAP allocation failure
> > will have a slight higher overhead due to the discard check. V1 is
> > fine since it only checks discard for order 0, and order 0 alloc
> > failure is uncommon and usually means OOM already.
>
> Looking at the original proposed patch.
>
>  +      spin_lock(&swap_avail_lock);
>  +      plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail=
_lists[nid]) {
>  +              spin_unlock(&swap_avail_lock);
>  +              if (get_swap_device_info(si)) {
>  +                      if (si->flags & SWP_PAGE_DISCARD)
>  +                              ret =3D swap_do_scheduled_discard(si);
>  +                      put_swap_device(si);
>  +              }
>  +              if (ret)
>  +                      break;
>
> if ret is true and we break,
> wouldn=E2=80=99t that cause spin_unlock to run without the lock being hel=
d?

Thanks for catching this! Right, I need to return directly instead of
break. I've fixed that.

>
>  +              spin_lock(&swap_avail_lock);
>  +      }
>  +      spin_unlock(&swap_avail_lock); <- unlocked without lock grab.
>  +
>  +      return ret;
>  +}
>
> > I'm not saying V1 is the final solution, but I think maybe we can just
> > keep V1 as it is? That's easier for a stable backport too, and this is
> > doing far better than what it was like. The sync discard was added in
> > 2013 and the later added percpu cluster at the same year never treated
> > it carefully. And the discard during allocation after recent swap
> > allocator rework has been kind of broken for a while.
> >
> > To optimize it further in a clean way, we have to reverse the
> > allocator's handling order of the plist and fast / slow path. Current
> > order is local_lock -> fast -> slow (plist).
> > We can walk the plist first, then do the fast / slow path: plist (or
> > maybe something faster than plist but handles the priority) ->
> > local_lock -> fast -> slow (bonus: this is more friendly to RT kernels
>
> I think the idea is good, but when approaching it that way,
> I am curious about rotation handling.
>
> In the current code, rotation is always done when traversing the plist in=
 the slow path.
> If we traverse the plist first, how should rotation be handled?

That's a very good question, things always get tricky when it comes to
the details...

> 1. Do a naive rotation at plist traversal time.
> (But then fast path might allocate from an si we didn=E2=80=99t select.)
> 2. Rotate when allocating in the slow path.
> (But between releasing swap_avail_lock, we might access an si that wasn=
=E2=80=99t rotated.)
>
> Both cases could break rotation behavior =E2=80=94 what do you think?

I think cluster level rotating is better, it prevents things from
going too fragmented and spreads the workload between devices in a
helpful way, but just my guess.

We can change the rotation behavior if the test shows some other
strategy is better.

Maybe we'll need something with a better design, like a alloc counter
for rotation. And if we look at the plist before the fast path we may
need to do some optimization for the plist lock too...

