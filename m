Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39F8CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 14:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A458E003F; Thu,  9 Oct 2025 10:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41A08E001A; Thu,  9 Oct 2025 10:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57DF8E003F; Thu,  9 Oct 2025 10:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93BC88E001A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:41:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 170C95BCB5
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:41:58 +0000 (UTC)
X-FDA: 83978840316.10.BA66600
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F3BA18000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:41:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l9EzCAos;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760020916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5fH3ttKU7y+blOL+SyOyeselah91xmMAP+YR9bbmUk=;
	b=k4YpUhxmYmrM16lh3kDICp+h4V9gP8BCxXhtNR6qC2XQQ8yvMys/5h+XZbRulbmPqK0brI
	hE/51SMKNvRtctPtIvpzqWerY6KABDPmhIi/Fc9CtLdXVT9UCqX9+hsWemLK8JSRMV5IDR
	LRUZTLcgJNzdWRo0esi6wjXujG2y0Vc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760020916; a=rsa-sha256;
	cv=none;
	b=Z9HP5cCQYbtvoMEhLi5YzFvq9usGe7+JNoPfF2dbvItDP2KlLM1LrfKh66VCnuxnocJFoZ
	HYqNzN3W9qy1svbaJ+XUgnTDK+yQw27/vyH3d7cfoF1dlqYgoSTYkW/GrKWxxoFXmyTbO0
	HE29UrGJes3URV2jokPSalXWHJL+UP4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l9EzCAos;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d71bcac45so11372717b3.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 07:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760020915; x=1760625715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i5fH3ttKU7y+blOL+SyOyeselah91xmMAP+YR9bbmUk=;
        b=l9EzCAosCW0PAmXWjB0ljTsPl+r1RtGbDuL4LTpVQqQOnTFERRbLAYjeAGkkz2KJvC
         DeRjEsgJpvkOuF3bk9XZBokJfIjnJmwmfSZXxPcibj7hywEdA3fAvVronpXEuGpkj4Bg
         t2RVm9VorxVk9zfRZW+0i0iGe/BemsPZpty4nekBpwdbMK1Rysa546qOGuYmzBxnBTCP
         qJVCbEN9UG4sGB9cBOoHM1WtEWzc2AbQNiW2zygpzSYp1eXRA+AZcIsgUOIS9SntV03p
         xUg2V49EZYMOqz9ldPkA0VVTfo4x1bnwuFdcZyhxpSv+B2ul+bQZbfWo965iOP7a0Qfk
         7BNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760020915; x=1760625715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i5fH3ttKU7y+blOL+SyOyeselah91xmMAP+YR9bbmUk=;
        b=ko+Ub73tyqyBWhOY5Hvs9rG2oTfbl9ByfK/wXL1E0mSIDMW210ldo+vKxLAbRwwIIz
         SD4cyz2YRXrmeswB86QNjhfk5tI971XrCwW1jZaHtrAHSUG20aXGTJdrwvirfSwnCfkp
         PvB90yG0MaZRnUEQWr7k0awR0CbQLioWkmzdxuA3BBHxn4zWlNdvFgnALIs9XjBMGqYw
         ZPktj2QWlg96rdXhzs8k0nAsjMAlVIDkPWKDpGTGb6PF7PD3u4DEYjJ3F7rUp9C34sVx
         JBQyyOamk8Fq1JfAnmG9Rt8MbSPn2jDmVvAfp00BOlIf7eN4c0LMASfD0zSttjUDrury
         jsAA==
X-Forwarded-Encrypted: i=1; AJvYcCVto7bPSIcFku0e0Z1kIXIzm54kEhQwGIO3RJnKo/kF/uNv1atvNu8l595qXn/Dxq5Hm2O/YMcK6A==@kvack.org
X-Gm-Message-State: AOJu0YwjL20thSpEuCtwhEmx9Gv7SuAL5wt4d5iBq7dSLkXpo/n6DgVo
	t9+c6g+ZDpp7aEqQJgsJrRWC6y4NOpdwaHAIGTOfYXf+2nAUqhSWVIF8
X-Gm-Gg: ASbGncubg1OjLjcjKUhhux5B53Vj012K9ORypFoaJVaXlIenHL4Ige2PQloKIS8eiVE
	QseJd2800xz0HcvElyp56spP613njshxH3ituRj45eOYGnXoVzKNnqxGZHcne/HoDfeJSv2Ju58
	xwIjBocSrMvYGQlTWPNN0ulFZLQfkCX/WA19/wjlQLgjHCBJqPLT73lsKbiCgg9MvU/87bJxAJm
	pIjmchslMWP1iX+AqlFddN+ZpC8RawfT1S2WCTwTE1PLnxeXqie6+mea1y/RTBW/y2kVAcy3ePw
	e5WvzMTbfCndZ4QR2tNLWB25bfLfAML6EV3dVIkB6LbfJsOMMyrUeiGeWgNc27i0Qfqy8r7RZLH
	SYBfrD0SaOOmon/Q/GLm531YBM/5T16qSXOdeIOAbWsSgFCAvNWdFcghLWu0opShs7lPW2FqQIY
	vP3Xbup75YDXF/NfJGfk3ZG0Md
X-Google-Smtp-Source: AGHT+IGJSwqoQuFYtwut/GSunHlbpgz+UchKDD+A+mimo1XFZik/IcNM0hD34iJY6+QugyEnsKPPBw==
X-Received: by 2002:a05:690e:428e:20b0:636:1844:119 with SMTP id 956f58d0204a3-63ccb82530bmr6320760d50.3.1760020915011;
        Thu, 09 Oct 2025 07:41:55 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:44::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cd9516074sm922826d50.4.2025.10.09.07.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 07:41:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC] [PATCH] mm/page_alloc: pcp->batch tuning
Date: Thu,  9 Oct 2025 07:41:51 -0700
Message-ID: <20251009144152.909709-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87ms60wzni.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: steqsf4pni5abr4q9pf4g4gebya4fddo
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F3BA18000B
X-HE-Tag: 1760020916-715127
X-HE-Meta: U2FsdGVkX18w3QAL48bIVEpCy6pNoxSO8RunwCN1kiBPwP26d9JANBmISXJFi2AxVoh2lOtclRfyoLZDpk2fW7Lm89MKYBLvKQhoWk1+L4A/16cZbSLYWPDr1BZBi/JRD2ZrNXmM6oaO/YZd8qg3wpgp9RJOeFNkxqsMjov55LjIDwzLCdriZ+RYqjdAGBGtdOU6Y/wFFuNPGz0HKTYoPdN4bhJ+8A2wOx3AYl9cB9He1AKuuEiT//Gjf1KVIcWkqRlOwRMIUPt+5WpFCJML1QN3lfPHNY3E7BdgQf2zVR2AK2Qxn62nNYoHGn0d2GcqdNx2HSuwl64esJlBH1oW661mpemr8/D873zWap6xPLIEfA5zTBsNMhpG7tIzHQwOgsqRzg0g5GXINMrnr7Aw3hICDE/oqcFyDFiEE4mcIfZA01wnR5n2dutBRvoi/bcMC3iICe3TAy70xsalrRNR5Uu8qx9Rg/avWf+4nhZE4w6mMvfAAK8z0wBx+r+YqA7iNWPSoc/9pSrTcGKpx16Rb1PA8W2HUh91wdWGRh3SCig2iup9HUXMjZWl8VfiGyu/3akFM6VvakcfaEqy9+DPbhymGI4G/YrPnd90jprD6enHsqxvIBQyaf7I1sw/YHI7VDpYF8QooVVeCwaybRlFgc5RjF3S3f919x2D0VO30k/OumsvGbC1DZQVqUli9v5jrC7QICj9Hlo++/Vljpl7nfB4I28jnGXMNDdCkDC2D7HOYuHkmBkf1nQTgpsGnNEEo2A9unV3zlsrGj+QEXYOaVM+F9fmBh5sXdfkGTSg5vw5+rjO9LWLSpHjh1oWFi6rALOtTyWq08RsUeay+It549OYi6X9GZC1XCkbWYvFx1zm0wehgqIdvpzi8e6s8lchRyVMzT6WPdOzPvTvA26ydvNhnNd42EVViB5Dps6RE9bPIhulgvzq7+hORK/UduVwrjJCaRQJJ7/80mJObJM
 9IAw8Bi4
 BIXQfl52MRIPQwRN1vI+jCbh/y4dRqI+7jEx17vlUVi4lJ5efVr2gTpIpr1JsPPkQ+IXsYsVGbydG4IljRFVo13ZsJVlwfUW6tGaHavAkE3dWCpiYVtzIMpA6/uoRMCFcU37ZiDpEYZVfrKC4T7LzFPCkd6Rthy6YQo+4uFnLzGh9fKCLnW8h5UHJzd0C0IGUzdwKTcEYcJHFyIgdZ7CGwI4Nshx5Ao7jNcqECyVjyM6m54bcn1se7ZL41iTxQxy5fmW/p7qz65uUdoLCcR3udcgUyCTYbpVkEI5ZAbDO09Vnb2tSa3rfIE1nPe8bl33Qj1p1xUubaK79TFx3ANMr7m+rs+zZhcJoO2kXUAzDGilTdDzYR/69of2MjKn3BQlCCSLfrjI6VOIEAxwJ2x+OXd3/L84S1qfcxKN4l3R1eLy+QL68tk/4I2uhqKJ13ObJOqRbckjRfUHsPN1T9jkJnLTE0VmL0jZ8/k8AYeJbVlTXYQtqh9O5A6BbRDpZwemoWW4ox5SSYHs57fhDV1XoPVzZMq0qwY73ZUWCJg78hsVWKS//mV1yi80jslbsxvLOfBy7aCYZzt0p+4aOvD2ShSbNxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 09 Oct 2025 10:57:05 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Hi, Joshua,
> 
> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > On Wed, 8 Oct 2025 08:34:21 -0700 Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > Hello Dave, thank you for your feedback!
> >
> >> First of all, I do agree that the comment should go away or get fixed up.
> >> 
> >> But...
> >> 
> >> On 10/6/25 07:54, Joshua Hahn wrote:
> >> > This leaves us with a /= 4 with no corresponding *= 4 anywhere, which
> >> > leaves pcp->batch mistuned from the original intent when it was
> >> > introduced. This is made worse by the fact that pcp lists are generally
> >> > larger today than they were in 2013, meaning batch sizes should have
> >> > increased, not decreased.
> >> 
> >> pcp->batch and pcp->high do very different things. pcp->high is a limit
> >> on the amount of memory that can be tied up. pcp->batch balances
> >> throughput with latency. I'm not sure I buy the idea that a higher
> >> pcp->high means we should necessarily do larger batches.
> >
> > I agree with your observation that a higher pcp->high doesn't mean we should
> > do larger batches. I think what I was trying to get at here was that if
> > pcp lists are bigger, some other values might want to scale.
> >
> > For instance, in nr_pcp_free, pcp->batch is used to determine how many
> > pages should be left in the pcplist (and the rest be freed). Should this
> > value scale with a bigger pcp? (This is not a rhetorical question, I really
> > do want to understand what the implications are here).
> >
> > Another thing that I would like to note is that pcp->high is actually at
> > least in part a function of pcp->batch. In decay_pcp_high, we set
> >
> > pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX), ...)
> >
> > So here, it seems like a higher batch value would actually lead to a much
> > lower pcp->high instead. This actually seems actively harmful to the system.

Hi Ying, thank you for your feedback, as always!

> Batch here is used to control the latency to free the pages from PCP to
> buddy.  Larger batch will lead to larger latency, however it helps to
> reduce the size of PCP more quickly when it becomes idle.  So, we need
> to balance here.

Yes, this makes sense to me. I think one thing that I overlooked when I
initially submitted this patch was that even though the pcp size may have
grown in recent times, the tolerance for the latency associated with freeing
it may have not.

> > So I'll do a take two of this patch and take your advice below and instead
> > of getting rid of the /= 4, just fold it in (or add a better explanation)
> > as to why we do this. Another candidate place to do this seems to be
> > where we do the rounddown_pow_of_two.
> >
> >> So I dunno... f someone wanted to alter the initial batch size, they'd
> >> ideally repeat some of Ying's experiments from: 52166607ecc9 ("mm:
> >> restrict the pcp batch scale factor to avoid too long latency").
> >
> > I ran a few very naive and quick tests on kernel builds, and it seems like
> > for larger machines (1TB memory, 316 processors), this leads to a very
> > significant speedup in system time during a kernel compilation (~10%).
> >
> > But for smaller machines (250G memory, 176 processors) and (62G memory and 36
> > processors), this leads to quite a regression (~5%).
> >
> > So maybe the answer is that this should actually be defined by the machine's
> > size. In zone_batchsize, we set the value of the batch to: 
> >
> > min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE)
> >
> > But maybe it makes sense to let this value grow bigger for larger machines? If
> > anything, I think that the experiment results above do show that batch size does
> > have an impact on the performance, and the effect can either be positive or
> > negative based on the machine's size. I can run some more experiments to 
> > see if there's an opportunity to better tune pcp->batch.
> 
> In fact, we do have some mechanism to scale batch size dynamically
> already, via pcp->alloc_factor and pcp->free_count.
> 
> You could further tune them.  Per my understanding, it should be a
> balance between throughput and latency.

Sounds good with me! I can try to do some tuning to change alloc_factor
and free_count, or see how they currently behave in the system to see if it
is already providing a good balance of throughput and latency.

> >> Better yet, just absorb the /=4 into the two existing batch assignments.
> >> It will probably compile to exactly the same code and have no functional
> >> changes and get rid of the comment.
> >> 
> >> Wouldn't this compile to the same thing?
> >> 
> >>         batch = zone->managed_pages / 4096;
> >>         if (batch * PAGE_SIZE > 128 * 1024)
> >>                 batch = (128 * 1024) / PAGE_SIZE;
> >
> > But for now, this seems good to me. I'll get rid of the confusing comment,
> > and try to fold in the batch value and leave a new comment leaving this
> > as an explanation. 
> >
> > Thank you for your thoughtful review, Dave. I hope you have a great day!
> > Joshua
> 
> ---
> Best Regards,
> Huang, Ying

Thank you, Ying. For now, I'll just submit a new version of this patch that
doesn't drop the /= 4, but just fold it into the lines below so that there
is no more confusion about the comment.

I hope you have a great day!
Joshua

