Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF4FC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4116C6B0088; Mon, 21 Sep 2026 11:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C14F6B00B2; Mon, 21 Sep 2026 11:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BF86B00B5; Mon, 21 Sep 2026 11:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB54F6B0088
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:49:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 891121C15C4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:49:04 +0000 (UTC)
X-FDA: 85238203008.22.E349C20
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1BB4C000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:49:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b8Hh+L0c;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790005742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s9qiYogYW6WNzZt1dtpYbULGoaZUSl75Lwvowk+5Ug=;
	b=wTZHMwEKgMC3aeOEwBRLYYqUAf+wjCe7Q/4ygDnwr8/ZeF7gIA0RN6/S3QnCs3/U0EVsJ2
	91suZIbfAdAzZlsQUO6J4K9ntawQam8Yj3Wnpcyd1GZto1OigOs2Nh/sUmxVyuOitKp8b0
	81sh+gp/CczmkVDehdvhIfzWltW5NEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790005742;
	b=j6Fi9oywDWBRQSX4887NA2bJ23HlCIY9G46dfP5JSSuivt/oi6lmw8KpZkx1LKOklr5xZs
	erBhZx6QAucrWLVy5JeBgkqhUCsoQfNVrivI+zwbxjF1PeuZw24QzfsIBqEImyavvtpmQq
	r9Q/uHYLd5jGt8cKwpYY6tXR+yxRTsA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b8Hh+L0c;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-5308fc4b716so18456631cf.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790005742; x=1790610542; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/s9qiYogYW6WNzZt1dtpYbULGoaZUSl75Lwvowk+5Ug=;
        b=b8Hh+L0cs+X/olqoqBVe+cCDrvxQXVasg1B+c7vbpRkuqbSg6B2wXWOprZ9DZpi7T8
         h1TKO7P4/AghU7I5EHOA7NcKGbgD2ljnQzKiDk1GczbfEz6WJrcX6mfRl66xKIQNnoDG
         WwGFDklVR6UG7/bAupq7TUzkDywrMKoOL+CysHjHubzsl+QDBl9MGEn/dmQhv3o57LmZ
         WmBuNXvuTr656leWJgdBmXogULSfczfxaQa6mruU7V563NalhVarMOFsiysveivNC8lv
         gWwEKYS7jHeQMN+k4lX2258teOEufPX++l95uexIg60nACOh/eyIxIIRMmfywpIWIqHQ
         pxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790005742; x=1790610542;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/s9qiYogYW6WNzZt1dtpYbULGoaZUSl75Lwvowk+5Ug=;
        b=GlqlrSJ8/O+niVyydzHI7LwKiUjOSeE66A9LUsIOP/q8ccBPHgSclgAzSpb+0gmgiv
         fuHeXLHRgK5cZKej4pM+v9XYPx0xCujvrYHsA/V+j9TnRnEOV54XTkWNwn3isSQCwhDy
         jQhZ4htewxyz16h+VfOgtBJ9zZ20B/hFq6hncyLA0t1yomo/lnFIW9t4DQMWiOmXebr1
         GKmahllG+ppWv+9AoVM/ABUfdjJdWAWqCkL6C70NzjufXot/CeGSRAIr8T5UjK/rAxTk
         EfhNs30uHWvkP4J8ur784nQH9okkqyWCbopEkbI4GLWS6vhqwBmvJCUXxkp6HoZrP91o
         GelQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZ0+39SWSji0rztP55w5y3fH14YDvmqgPOJgLlg4ilgWj/c7YlEAay75oKuWXU8EoDUPWZ1/ULZw==@kvack.org
X-Gm-Message-State: AFuF++neZUrKFXiarVsL2tsL1RImbLhIDhvebgH2qJFQb05fiG2VEI31
	QuCaIJNOgkVkU/ygwLv2BNgnwRMhE2LvBA7WBgAy3tDyF0KWVebQaHWg8n52m3ZzixY=
X-Gm-Gg: AYBFou3nRHxOmxGYlRMC0eeXg0PeVH6LRfLhIgAGdQyRldouBXlFP7gB2AzViOf8ws3
	lKGj4EKZ50Qgwl7DVrr39XA7mhrDH1W8eGFo+rKbbmRg5tysNAxzCfC+mKsRfN7SIdFYhnrRWMq
	RAr8iCpVbJyStncDqprA8Ly0jJxNJeK4PgcaXrr3LG6vUl3iXKuqmK05/FZIZU8PHKKA7JKQCdt
	Izprtcm3cUB7+ZO7yeIelnyHZMflmmdHg7FGVy/2Xy22dZKkWCY0yY+o4d0Djvxz8/qIrlV6tjt
	qpYPsB3vE9fndlSs7Fi8vaEcJ+ii0a1oI/+4PdJqaT+VAkJvseO7n1QaJxJ1dzNI9gouIsIByWg
	WeWJbYGPlzFiYyvI4TiJiz0Aw6+kGQlf/qirxF9fCjZ3nuOWCKutd5ocwt8cVcsr8EPnakNsZHG
	kear9IB2Qv/R/4lhrR00bpGnqnIi/H8RVFrr79r6Ba4NJKASG9leX4sJBwJghBTh0OifngLHQt9
	IZqAN8Jbns=
X-Received: by 2002:ac8:5a8b:0:b0:532:a5f4:df25 with SMTP id d75a77b69052e-532d8e4f628mr13379251cf.57.1790005741711;
        Mon, 21 Sep 2026 08:49:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([50.193.156.113])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae512550sm66992481cf.1.2026.09.21.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 08:49:01 -0700 (PDT)
Date: Mon, 21 Sep 2026 11:48:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Rik van Riel <riel@surriel.com>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arFP7YNzB1RMUKuc@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <f3af5902412b9ff1c1a37211eeeb9c0ffc22f814.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3af5902412b9ff1c1a37211eeeb9c0ffc22f814.camel@surriel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1BB4C000A
X-Stat-Signature: 6sty7xe5z9dra964nqz74p77mt1zae5f
X-Rspam-User: 
X-HE-Tag: 1790005742-384843
X-HE-Meta: U2FsdGVkX1+d+Jxb5drQQsR0g0b3Tu02NohWwjyE0CNmokM4/TfOJUW9W24FQbgolkAICZuwD+PIuanecGAPuG8d4U70mtbfRYBpMTnQBIP9547wqKA7OduL54KWsWRBUGfIlyYdRcc30jI9AHsqjdUJVWn5OFC/4J4TNC6sa26ijQTwA9X7kDkQA5ijjdagrIGfuaPixqtity6bRQQPB0bnJuCwy4DAv4tT0rtGB1tz9YPbHmMFCjclmQb5XUYNnDxDw6s43FuK7PUaY4RuiF9dkhjSnNUWWM0QDC/a3Hqz/u6eNkHLW0RKDpx+ol9u5C+qnm+6jGkkwwQRp7qhoW/5kCV99vrbdKfLPIhs3AM2ujMns0p/OZaTVqSV8nyquLDLtnsu9aJ2mGOf9DxFnHRDdegBPRplqTki6CRFir4yO2c42UPcPU91ItiwcwWU++wcqnGzed2lyRQ1pxvEykrLEg5BUCzgekrIqwgHGZUeMookDdjPVsssCRA8y09pJyLlHZ8BdNh7w7i9CSQTHwy4WrLazv2frxGjFePN9VM/rUs+8Jusde7kN7MoB9heeMpaXnoWaAGSEe4wbKHEIT9gIH1i+c9fLj17q4R6ZkD94PWz550FQrcRrLGT3dmnO7flzJbkiucBPYQauLzYJDwNrOKIhUTUzHEqIW3dm8lsHbRKpS6LtP9Fqoy/mPxDTssz+1E+P6Dsvk0KY/e/tSivXFh2L0tGV9z04rlYVZJuV/0cXK6BRAQqX+RwirFNm5I4V/ARS8nqBb73Czn0MwIPvVCnpggGXAGCGTAOsDp/ZWcrGBhwpCIEtTRu4jWWwyr0EP6X2pP430T8+3STt03Pe+5/7Zez33ubtgI3O7x5Ji1WrfRhghoEBM7IvB6u71R0WEvWMWC3XHrD5wTH5GuKq8in5sqVN7Ff1m3Wy+4DyNEXOSP3FSJgNZ31JfC3pxZY630SWe9XWWC8YJE
 vc+kHAtt
 obA12ElMQPxw2wzBkmXLedCnWfo/cw50OoQCHl/zrnYorBbQ3SBiyr+cjPwLKc3xAbdj31/LTajrX35hawQAA0hJekGRcjd4rZOtGLXd7IO2MIJnbHDnAMp+ie/SH5X3W9YlccwmqkrWnuEUvOg919QSNvbF/AkEvLTDU5zzR6rWkxiwpUuDRAP1nlXD8V1xtCjWM6tbYEGAuovkmsJs4tjy1RdThei2GfXGb3uEANB/my8ZGWaJ68mDMvVqGf+FlB+wl6X1S5TQE2Uw0VgS3QhysWgrPhfyLQneiXVw3Wqaj6hbhwmjjevoiG7h/EXsq++xbheGfl5AvtQlP66pXWRbVw/qTlKuo5CXDtKQJQ4lHgOvknLYs3yhz6gJy/ki6ZiHee+AV3PzDKWQFhBNuJEtvpbLGwEsqsqzFNL4pNxPhlYgEl9FiQVosSelQEXMqqq8HDkPU4q9Yi0yNtavMvHWY4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:27:53AM -0400, Rik van Riel wrote:
> On Mon, 2026-09-21 at 09:27 -0400, Gregory Price wrote:
> > 
> > In short:
> > 
> >   memory.swap   = logical swap       - workload/SLO limit
> >   memory.pswap  = physical swap      - storage limit
> >   memory.zswap  = compressed memory  - RAM limit
> > 
> > This would preserve the existing memory.swap semantics while allowing
> > both backing resources to be constrained independently.
> > 
> My first thought was "this is confusing", but
> after a minute I realized that most users will 
> never set those options to anything other than 
> "0" or "max", and the few who do only need to
> touch one of them.
> 

In practice, at most two (zswap + pswap) with swap=max.

There's not much of a reason to set swap to anything other
than max if you already have zswap and pswap limits.

But for existing users where they're using it as an SLO
signal, they could continue getting the existing behavior
by just using swap.max.

That said:

I'm not convinced this is actually required, because the swap
counter was never an SLO mechanism - it is a physical swap
provisioning mechanism.  If it's being used as an SLO mechanism,
those users have misinterpreted its documented meaning.

memory.min / memory.low already provide you this logical limit
mechanism - so I would argue the parties that want such a split
(rather than treating zswap / swap *as* the split) need to prove
their use case cannot be supported by existing counters.

~Gregory

