Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C57C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18576B00A0; Wed,  2 Sep 2026 06:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF846B00A1; Wed,  2 Sep 2026 06:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A317F6B00A2; Wed,  2 Sep 2026 06:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 810D86B00A0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:17:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20F9114016D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:17:05 +0000 (UTC)
X-FDA: 85168419210.01.6A0A438
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F311100007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:17:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CU3ytxJI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788344221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htKc8hs4ZStXVA1Cy8EA/kBreVsodNRZqCypYZ+gXxw=;
	b=r0FQIO/8va/p4MF0SxGWO96k3eNSERwVlgCLIuaaa9x1vnfnYzmuvAHOc+5XoCE+sucJnN
	7vpdeUeI2Aj20us5mHit7SeTVuHtpx8ViY8YEeWTMqQ0hvhRcH/H4BlUVKqr6NVajmyTty
	A8RLk7mAPr+4sgHVZnBCKS1B5H23/mU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788344221;
	b=d6YgdJ26Lvp7C3UkkQ1V+kJDBdeqP8tcZFie0PE6E1mSUJn+82NpgN4WTBFJZ7MmQ4M4x7
	MYmvvbdAItGsluWhaqtqHkrNQR1+IjVcIZ+wcl7iStbLRkQW/qtIBRFxPEes+0zjNLqlUv
	TI9+zzexAQIMGVIwQS0peLdj3h/fjo4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CU3ytxJI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bOFmxMxZ2G90TQ5a51Gad1RBA6G3ru642cr75z4F2CA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788344216; v=1; x=1788949016;
 b=CU3ytxJIrI9sGj1xrKkl99nNiN7qo/kkz6CvoDr5t3F5yNOPwM4InwhL8p2nbzlo4LzxNfol
 WvQJJrjqDDkMNj8v8aNEVawSvCMFySRC0EbNioS8zjoHm5doxq8sn1CVcUvyjVlAYcLm8kJSgf5
 dLTkMjKLyB/N+oIDSlIf8acw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id aa574cb511f2c5a6;
	Wed, 02 Sep 2026 10:16:56 +0000
X-Mizu-Trace-ID: aa574cb511f2c5a6
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 18:16:42 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in
 isolate_folios()
Message-ID: <apf3ivSCu9kQfM9F@fedora>
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-3-baohua@kernel.org>
 <apfZQE1X6zGAsBb_@fedora>
 <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F311100007
X-Stat-Signature: c4qn5rdjedcujgrcagpb3bo9i17ubfpk
X-Rspam-User: 
X-HE-Tag: 1788344220-475168
X-HE-Meta: U2FsdGVkX1/UEWzaM915Jvq9CWqLlJ7Oj0zQeR6JbY+kt3hU+kHLmrC2IDZOYKoIgo12JTXDMPPE3qI11KsXtYoO50hUOwbzPJ+W1Weg8cHQvE8IEJnEjTxgQ3/0GqfpNU0HvGoTXevJQuONRVsyv34BaHe3s0xVaWfu3FS77u9DtDE6G14bcS2dPhDNAql+QxZP6vKEcTmF8u3pVMdCQdi6FkT8TXHHbQms9WD7bz6CVLjhQqMl5EFpYslKGdPDDquWmWTfmgLYr6ZCOOPke8K6c8K4wXHrf86b/YUSIJCO3nO48VBoAh9bnmN+AdxjxUp4ztNQc9ufDNbNu8GnPNhiFTIapzBNlR/ngurmSSQ9e3gY/HzP7wEJJMuwj9I7bEzZV64nS0YCzLrxQpd6QIlfg2m0gLpMJjTSyfVQubfTwymVSk5CVqDvu/pEeNI7zRIsj12jGZRSGBLlGft0brYpadBNcCtz0c1HXJa9FfGKf5zTa9Tm+6UgOplP3/ejtLt+NSIFr/BcRJUUPN3VTvRqghm1CFtMY7A8ce7+Fbs1VGlwvBQ6oNj26hojB6NVc7FlX+LDj1ePYbAvD73H33c8drgmA4vzwPmAcFeSwzi5whszK1S1gxVYEvK6HZGFJWWZmrn72Akp4ztD/G2jMxjNTKjbOqvM++4hLMjVe16g/s4aKqhq0Igqpkvt3D3N+Cqq+s/x/nPkudmd0+0C6YE3wvsyALE+ZoDbJAI78fBU/hKui4KT20C6DACyN9QrIks+NgHIrSZAZ/WH3Go7FHipjI93eOZCG422gVIfuF/aacGnEIbG3pp1/3vBcqWdoee3041k1ENmeCxdDbPrerszSOnFQMd27A8XlrtJJSxaJWXoRFV8nWtP3sv2ePcj3UgYlqaxbZVUxuO/HKVOvvwboHPpG5jO3SBclTty3QyslPk2kXiyENUN1n7CLWzrcTZ1J9ml3Mk1CDApH56
 VMv4IcWm
 4nhzVjh+/46CwWBfoDP8r2EiIczCsxXniU3fIvreVPxTuFPLIRqxeGMvDo7Q4psZFkYCR4ad79VhIBbEb8DEsPdnyoP5EDftBSutRojaNssk42syX0NGDEHSE4EQECt6qFtAKCPRXa4Pln8bZ3bb/QyRKxpNm3dTdaYJD3KEvKHl0+Tk1oKO72zoRABEuxppNxYNTRPU7s7WIqrxO6Gog8XynYgmJEIZfqlq621PMXHO8Oa5r2i/d5FcIOteoKQzq2uKMBiDs1yAX4pVrqxTlM5cy5Rs/RPzibdDdZlDCNnkqXH5dvSQcprCCh0LLsCjX3r7apaBspeKFhzrZXnLCteniVNfRL/cAnWgyucNtlaxDiCMrqQ87PZW3AQncSX06tSxXkEYqwY5EDzBHa91FD+KGTpMgsHLp/jWfdEcTEQEjCFfJiXYhDbwL4W9xGbfDIttB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 05:20pm, Barry Song wrote:
> On Wed, Sep 2, 2026 at 4:07 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Hi Barry,
> >
> > On 08/29/26 at 03:42pm, Barry Song (Xiaomi) wrote:
> > > The existing mainline code retries the same type once in a rather
> > > subtle way. `for_each_evictable_type()` may provide one more iteration,
> > > allowing the same type to be retried if we scanned some folios but
> > > failed to isolate any due to protections, promotions, or races. This
> > > patch makes the retry behavior explicit.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/vmscan.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 35a233623368..718f59ffc688 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4852,6 +4852,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> > >       bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
> > >       int type = get_type_to_scan(lruvec, swappiness);
> > >       int total_scanned = 0, scanned, tier;
> > > +     bool tried = false;
> > >
> > >  retry:
> > >       tier = get_tier_idx(lruvec, type);
> > > @@ -4871,9 +4872,18 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> > >        */
> > >       if (!scanned && type_fallback_allowed) {
> > >               type = !type;
> > > +             tried = true;
> > >               type_fallback_allowed = false;
> > >               goto retry;
> > >       }
> > > +     /*
> > > +      * We scanned some folios but failed to isolate any due to promotions,
> > > +      * protections, or races. Retry once to avoid a larger loop.
> > > +      */
> > > +     if (scanned && !tried) {
> > > +             tried = true;
> > > +             goto retry;
> >
> > Seems patch 1 and 2 makes not minor difference than mainline kernel on
> > behaviour.
> >
> > 1, if swappiness is 0 because no swap, it will run two times if
> > (scanned != 0). This is not corner case, but usually seen on some
> > systems w/o swap device. The 2nd no gain run could decrease efficiency.
> >
> > static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
> > {
> >         ...
> >
> >         if (!sc->may_swap)
> >                 return 0;
> >         ...
> > }
> 
> Yep. For swappiness 0 and 201, this patch slightly changes the
> behavior, as I mentioned in the cover letter:
> "
>  There is a slight functional change for 0 and 201: with the existing
>  code, there is no chance to retry for these values because
>  `for_each_evictable_type()` only iterates once. After this patch, 0 and
>  201 have behavior that is more consistent with the 1-200 range.
> "
> I did this intentionally, as it makes the behavior more consistent with
> the 1-200 range, where we retry the same type once to avoid having a
> larger outer loop.
> 
> >
> > 2, for swappiness (0, 200), the behavious is minor changed.
> 
> I guess you actually mean swappiness (1, 200)?
> 
> >
> > Mark one scan_folios() result as one of:
> >       iso     *isolated > 0
> >       empty   scanned == 0 && !*isolated
> >       busy    scanned > 0  && !*isolated
> >
> > mainline:  T(busy) -> T(empty)         -> return   (2 scans, no fallback)
> > v2:        T(busy) -> T(empty) -> !T(...)        (a 3rd scan_folios())
> >
> > Maybe we can go like below:
> 
> Yes, you're right. For swappiness (1, 200), I didn't realize there was
> this slight change.
> 
> >
> > static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >                           struct scan_control *sc, int swappiness,
> >                           struct list_head *list, int *isolated,
> >                           int *isolate_type, int *isolate_scanned)
> >         ...
> >
> >       for (attempt = 0; attempt < 2; attempt++) {
> >               int scanned = scan_folios(nr_to_scan, lruvec, sc, type,
> >                                         get_tier_idx(lruvec, type), list, isolated);
> >
> >               total_scanned += scanned;
> >               if (*isolated) {
> >                       *isolate_type = type;
> >                       *isolate_scanned = scanned;
> >                       return total_scanned;
> >               }
> >               if (attempt)                /* already retried / fell back once */
> >                       break;
> 
> This `if (attempt) break` makes the loop look rather strange,
> especially for a loop with a maximum of 2 iterations, where we break
> when `attempt` reaches 1 :-)
> 
> What about just changing one line?

Hi Barry,

Agreed on the one-line change for the (1, 200) case - I traced it and it
now matches mainline exactly (no extra third scan). I personally prefer
the for (attempt = 0... ) style because I feel that makes logic clearer,
while everybody truly has different code taste, LOL, just a weak opinion. 

For 0/201: my concern is that on no-swap systems (swappiness 0 is
file-only), the same-type retry when the first scan is busy may be a
no-gain run if the file generation is dominated by protected/ineligible
folios - the retry re-scans the same sort results. But if you see a case
where the retry does isolate folios on the second pass for single-type
reclaim, keeping it for consistency is defensible. Do you have such a
case, or should we drop the retry for 0/201?

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bf2786c7247d..ba7adf36e69f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4939,7 +4939,7 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>          * We are running out of the current reclaim type. Fall back to
>          * the other type if allowed.
>          */
> -       if (!scanned && type_fallback_allowed) {
> +       if (!scanned && !tried && type_fallback_allowed) {
>                 type = !type;
>                 tried = true;
>                 type_fallback_allowed = false;
> 
> >               if (scanned)
> >                       continue;           /* retry the same type once */
> >               if (single_type)
> >                       break;              /* no fallback for 0 / anon-only */
> >               type = !type;               /* empty: fall back to the other type */
> >       }
> >
> >       return total_scanned;
> > }
> >
> > This preserves mainline for 1..200 exactly, keeps the intended 0/201
> 
> I guess you mean removing the same-type retry for swappiness 0/201,
> rather than keeping it?

You are right, it was a slip of the tongue.


