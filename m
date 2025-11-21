Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1008CFA759
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232966B0088; Fri, 21 Nov 2025 04:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A826B008A; Fri, 21 Nov 2025 04:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121306B0092; Fri, 21 Nov 2025 04:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE3EE6B0088
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:15:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 951F9130084
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:15:11 +0000 (UTC)
X-FDA: 84134055222.24.5697F97
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 92E301C0013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:15:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhTusjyi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763716509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgUhDhZ/Z2c/sdO8+MQy4XIdM7cZuKBXtLrKcPdb/cI=;
	b=Zw/UR5aXFq9JYXfF/EZyABYfPmwfMu2Bu1fsW+ns386WpI2Kn0o3VsWeVZoRbfdBoVOtRZ
	ZFLue5LGX/eOjI1K6Jn/XxS425gWtDxtCqeBrgzs1ERemq3rx45jd/FprWkWfql7ZMpygn
	SGN/XVyG/ht7wlFSBGXdHEJNLDuklAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763716509; a=rsa-sha256;
	cv=none;
	b=1wGVjcd7XqPrvCJxtxQjnjoUujQnlBSOUBX8x2F9praNDrYQ25HtzX29Q7zG+A9DJg3aaC
	7PPPR9jlkXwjXfezvvIRPrmvYDj6MuylcbpcFdLM1+5HY9ua4BXezU8ZjcdXH3OjoKjhz1
	ZnrjR4CkFhyUvfH4cNeRT3p/EwOi3Qg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhTusjyi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47778b23f64so10116925e9.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763716508; x=1764321308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgUhDhZ/Z2c/sdO8+MQy4XIdM7cZuKBXtLrKcPdb/cI=;
        b=PhTusjyisrsjlKSCV+xChgxnnHyl+t8N2q2Zu5IohUmTkd1INHoXeXVyYg9LeP1AWZ
         cMeTDMVOdOSmpB93pEzlki7Gtg4nIv8KtJh7b4W/7JYVyj3+Khz3hL7ymkEwuruXtmNu
         CsLg90yAxLS9/fIsrlho4+OHy9+0kpYhMGvuy7wy7MYfuRiM/IcRrGTPQlqL8mVbgY2U
         OJBDdzX+hlSNcKoEXHHM+0uEpfKpR/om4SA5ZWADXQ5KQZkaukbDSMT2vJS13kGpU+UX
         e6nM2Qj+KFXRuJAmfj81IZ6d+iMhUkEGqtL/qGykCFgzAabNElhMHVP3XRALSjr8r99M
         5YuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763716508; x=1764321308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bgUhDhZ/Z2c/sdO8+MQy4XIdM7cZuKBXtLrKcPdb/cI=;
        b=iEHESbKWi+5X+Gdh5vVTNAqefTjE/x3xWgSeRvfcWF/MHL75OGtL2uyls3Z6kT76vI
         8RfpHhHCPnTJXuC4SYmIPf/zGUGQ1+HYI3De/nsflWuS6BLn2YZIsxyvm2O2DR0mzxUN
         gRQc9UoJAn7OavjFHI2lqiKWyP+DU5azbOMwLcfi1Pc9FSr477ky9VUNgf2c2Fzl+JL8
         fXQ9J7JVt0D7pIUM3TMWCWFyaSOzBMg5JHFNI3uEjtnEUVtlY9Rs2EjLKkerdABbDLt2
         gHmn4R00tymGWhiM5kQFRXL6G9Bj9+hT8U9Lc/oOzWrzefjWXTaeUeE6B7kIMWngnSe5
         WUPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU98xpibKfWbAQIHcnNNpBkkkm8YWUCWVIyccdD7zrHHo4/vXEGEOwadrrOhu2QtF9BZiHS5YAJlw==@kvack.org
X-Gm-Message-State: AOJu0YxGfXRuIr2dylNsbZPYG7w6Yfbt+31pgTUPvXAGoZyZH+1RdY47
	zDToeMVwLdzWjXhlQtnIRj0ubE3eGtcbBq40mSn3WbVMHpVz1meKFqBj
X-Gm-Gg: ASbGnctJnuKXCn9bf6F4oPlgE2ByCyLdWDLfyJVMjfF3Vf4NuIeNWwxMTmY3cyHpWvg
	mB79l2SAbFwdm69MacxujCah6JPsHMuK0Imdq7VAdTqQQt3PBpdq1Kmk1SSXc7h4M9mB/GIm7Oh
	P4aRAHJmXamH7YAJO/GREU2EZvL4EIQaRprRVPiIET3Tyo97zwjFbT9mTSZrHZ+UT0o1lDtbAHZ
	+or8oALeZmWiyGhSS+RPZtxDbLM6ULkJo3i8EzcFG3Uj2NDUS0MISmFohFo+Lw2Cvutf/rceURb
	/DLZfkmCxujLTR3P2RGgnz3Tx80L7LBr3zYNLkc4g22IWvCVoiuvwR4Yd5nMjFCislvoSp06DkB
	GzIQp+q9UG26rB5Rg6k3iJD93VobpOuXfMjO0DEZ6ZcqRyYd94lkehVNOTY+Wgm1k6W9sXL9MXG
	IqfCH83EWLuH43uRpdT5JVH5hjxBwZxMFJZsmCeyTlgZ+qFnJ681s+
X-Google-Smtp-Source: AGHT+IGqFFmC+Cy2NqOyJP+LD7dMPGuUhV9SUXViPCq/6VcXBmrQx9sKWYrmdnhPjCKTFT3HR+9l3A==
X-Received: by 2002:a05:600c:3ba3:b0:477:aed0:f403 with SMTP id 5b1f17b1804b1-477c110d91dmr12313975e9.8.1763716507701;
        Fri, 21 Nov 2025 01:15:07 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf36d1fasm31719435e9.7.2025.11.21.01.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:15:06 -0800 (PST)
Date: Fri, 21 Nov 2025 09:15:04 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Mike Rapoport
 <rppt@kernel.org>, Tejun Heo <tj@kernel.org>, Yuanchu Xie
 <yuanchu@google.com>
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
Message-ID: <20251121091504.41ada607@pumpkin>
In-Reply-To: <20251120234522.GB3532564@google.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-40-david.laight.linux@gmail.com>
	<7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
	<20251120095946.2da34be9@pumpkin>
	<20251120234522.GB3532564@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7sxhqcyfdgjs9eyofru3peyz6ni8y1zh
X-Rspam-User: 
X-Rspamd-Queue-Id: 92E301C0013
X-Rspamd-Server: rspam10
X-HE-Tag: 1763716509-695744
X-HE-Meta: U2FsdGVkX1+6ce5m9dXhjuAXOz/GQOqJ/bg5ZjePqy5cy5uASBW/+OcWFm6Fjfo9Xzo2i/xXBHR80/q6VXn7CND2d514WIPlReO69N5AIWaZlRNasAjpGnvg1D1r5e/ZAzaeiPTJygNdvSpbAuHQ6L43oDzXKNRMBH2Aro8ueH0H4YIRIGQhjTaMMDgxvhjtp3NaB7GL3Fb1Hdj3JNuBW9LquVjDnXJcAfEi0YFFc+Y6idFJ1navV1qDTayXVQw/mk+IAx8hfvE4mMV6wg6L1YMh5b6xjgouFPCxYkqYI825rNt150HGmz8X2dgDYz9vFjiJCU/BxOLEOFFLt6/Od0mt1qZIzoIdZzGielg5yG8FYWa5F1JJPJQF0eANU36usxnLi0JQ/qfYw9ZKtzw1Uh2T3gykJgsOQriDgA9TFnD8F7yeM5A3UUF08HahzHkIY2PpzKcdWZo7bxSEY2b1zORx35uNDm29FiSuM7OdbahlBtAqIcW6vGbVgtY/+AZsUWclJtg0TIJutRGToPbUVz2DQovKsLahrLk8GIWoM5d7v2dBTnho1aDh42K9F5p4E1CRp9z8Ip9r0AXsim5Kb6oWne9++fnqG5QI0RIg6nT4Q78ClyPpX2iWbsVhaUJKA68wvBHds69wO3yJPDwLfH6CTbN+5Z20lOCgJCIivf/Qe+YPb9F1nIRAFX3um2EApo/AWg4h7iqiUsRDD23lmQzXzOoACwCDNlWM+WC+csGazTgI9e+kMDJGiUArGtwSc6hK3b8GDBqgwCLorryWSqS2/jQ+dpLIguhhmYtzVyacPEz2dNIw/daTGr26JFnbqiG3+FW8LIk+3AdYEN7RxspnY8VqfChdLeDuN0S1pqxIPWznxWUGdYDTkoqwG35ssAdj5ypj/6tCoFrLOGDEsu3zZ3+ip/ef/Zy9CyIblc47+Rz/qvwzEi4HNl3fmit+Vo3jkDbkkIJtKPTM7gM
 993c+1Yf
 hxOZ01oCl97wmJkwopdXK7WQ5/GLT7P9FVHpf0K6YEm2suKaobd/aG0GXclYDwFVsFw7wsPr6Mr+VhpOb94arS5CAeGoITP5siz74EVhURd9i0BiYbWgVIgFmMK/9ro0RmvXfuBFrXh0Qxt8T18VDXqZccvFai7pkbSMWM+KdVUrn/Xv3YCRxwUPbaAR+dRAOE01hgdT2DrAH/c0dM+kDHKSqtB4T8dpkKZajve0LxltUgxkNOxQ/jhsKS+mNXAYEAKQsvKBGjEEPZ2dLWPwyUqWARMq7gaA7wKN/YDJgqDo656003Hn6PHXExfOy0GmVpRto8QpZOiQIC/pjBoQnfqpOlRuqhtyKrVOcps3LwKiDtNSUXL3YVS++iH+OqEyxYBOupKz1qABQbU73t8PbLDpog8RqV0i88nsdA29XLXK69SR0LUap7cScy70Z/GwmBpLcF0xDlnSeLTsL+32lc2magh1af8uLPJf/fP/co+S01pDl9fpTX2deC3Rn+XQcMAgCCS1b738X7H9ocT5CN/YEXdZUtSLnl+NKrfrkk5heRJfva0x3jZpilcbxGR2Kk6ONFVg94q4TfNpvjE2N3IFnXlHDqKRk4nQyUse9OzdUAqu3jYNIdI/sbkHQTsmjnWuvv60ZsbbulPxuDQFaJASJBMln/iQj/a4q8A1LQ+grAgEoNjS9ql6UAxYt81Qw43jA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 23:45:22 +0000
Eric Biggers <ebiggers@kernel.org> wrote:

> On Thu, Nov 20, 2025 at 09:59:46AM +0000, David Laight wrote:
> > On Thu, 20 Nov 2025 10:20:41 +0100
> > "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> >   
> > > On 11/19/25 23:41, david.laight.linux@gmail.com wrote:  
> > > > From: David Laight <david.laight.linux@gmail.com>
> > > > 
> > > > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > > > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > > > and so cannot discard significant bits.    
> > > 
> > > I thought using min() was frowned upon and we were supposed to use 
> > > min_t() instead to make it clear which type we want to use.  
> > 
> > I'm not sure that was ever true.
> > min_t() is just an accident waiting to happen.
> > (and I found a few of them, the worst are in sched/fair.c)
> > 
> > Most of the min_t() are there because of the rather overzealous type
> > check that used to be in min().
> > But even then it would really be better to explicitly cast one of the
> > parameters to min(), so min_t(T, a, b) => min(a, (T)b).
> > Then it becomes rather more obvious that min_t(u8, x->m_u8, expr)
> > is going mask off the high bits of 'expr'.
> >   
> > > Do I misremember or have things changed?
> > > 
> > > Wasn't there a checkpatch warning that states exactly that?  
> > 
> > There is one that suggests min_t() - it ought to be nuked.
> > The real fix is to backtrack the types so there isn't an error.
> > min_t() ought to be a 'last resort' and a single cast is better.
> > 
> > With the relaxed checks in min() most of the min_t() can just
> > be replaced by min(), even this is ok:
> > 	int len = fun();
> > 	if (len < 0)
> > 		return;
> > 	count = min(len, sizeof(T));
> > 
> > I did look at the history of min() and min_t().
> > IIRC some of the networking code had a real function min() with
> > 'unsigned int' arguments.
> > This was moved to a common header, changed to a #define and had
> > a type added - so min(T, a, b).
> > Pretty much immediately that was renamed min_t() and min() added
> > that accepted any type - but checked the types of 'a' and 'b'
> > exactly matched.
> > Code was then changed (over the years) to use min(), but in many
> > cases the types didn't quite match - so min_t() was used a lot.
> > 
> > I keep spotting new commits that pass too small a type to min_t().
> > So this is the start of a '5 year' campaign to nuke min_t() (et al).  
> 
> Yes, checkpatch suggests min_t() or max_t() if you cast an argument to
> min() or max().  Grep for "typecasts on min/max could be min_t/max_t" in
> scripts/checkpatch.pl.

IMHO that is a really bad suggestion (and always has been).
In reality min(a, (T)b) is less likely to be buggy than min_t(T, a, b).
Someone will notice that (u16)long_var is likely to be buggy but min_t()
is expected to 'do something magic'.

There are a log of examples of 'T_var = min_t(T, T_var, b)' which really
needed (typeof (b))T_var rather than (T)b
and T_var = min_t(T, a, b) which just doesn't need a cast at all.


> 
> And historically you could not pass different types to min() and max(),
> which is why people use min_t() and max_t().  It looks like you fixed
> that a couple years ago in
> https://lore.kernel.org/all/b97faef60ad24922b530241c5d7c933c@AcuMS.aculab.com/,
> which is great!

I wrote that, and then Linus redid it to avoid some very long lines
from nested expansion (with some tree-wide patches that only he could do).

>  It just takes some time for the whole community to get
> the message.  Also, it seems that checkpatch is in need of an update.
> 
> Doing these conversions looks good to me, but unfortunately this is
> probably the type of thing that shouldn't be a single kernel-wide patch
> series.  They should be sent out per-subsystem.

In effect it is a list of separate patches, one per subsystem.
They just have a common 0/n wrapper.
I wanted to link them together, I guess I could have put a bit more
text in the common commit message I pasted into all the commits.

I didn't post the change to minmax.h (apart from a summary in 0/44)
because I hadn't even tried to build a 32bit kernel nevery mind
an allmodconfig or allyesconfig one.

I spent all yesterday trying to build allyesconfig...

	David

> 
> I suggest also putting a sentence in the commit message that mentions
> that min() and max() have been updated to accept arguments with
> different types.  (Seeing as historically that wasn't true.)  I suggest
> also being extra clear about when each change is a cleanup vs a fix. 
> 
> - Eric


