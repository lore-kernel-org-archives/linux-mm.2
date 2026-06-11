Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF6DCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F036B0005; Thu, 11 Jun 2026 05:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8BE6B0088; Thu, 11 Jun 2026 05:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEC56B008C; Thu, 11 Jun 2026 05:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82F476B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:23:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF62F4055E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:23:21 +0000 (UTC)
X-FDA: 84867093402.15.D75DC13
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8568E4000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:23:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZV4swvd0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781169797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UWn+/o1z8vjqgLMtj+iGKcEAIf/D00Y5lREVjVXChc=;
	b=lwquCZSu8BaIn2naFJ61dE33KzeVqs+dV2l5sms1IqIY+zw69xq8Fc+eoupRAcSWs3GlNp
	bBUh7nrhV2vRxFTB3LF6I6bP7fipt+/p5H8ArmMJOe5/02TK4VVtp0UuS/BTNTUmcNJ7/O
	y2cBIppld9Xl5KCxW+Mxdg4OGlFsato=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZV4swvd0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781169797;
	b=6eU3UBFc8QqZDttRpSvZxQ5BP1+qY1TzbmyH0O6Eum6q2MVLsu4vzef8yrKEKRr8tTgoBv
	w8hvq1rYa+FAQVRZvgkQSQHYUdgQNOggVICPoqO9MCrNYfEi3DEFs7mP+p8tAj0OXNxdvD
	Z1k1kS7UEkoYlVBiPrfLqRakO8Rq7EQ=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68f36e1663cso13887115a12.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781169796; x=1781774596; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7UWn+/o1z8vjqgLMtj+iGKcEAIf/D00Y5lREVjVXChc=;
        b=ZV4swvd0q7+aW2tusVpepGzxFJMAyV0OF6TF+TncP8SEeoec9STtNVtyQXsemyo2IL
         vHNYNyETT+Cwue5lecBXayjPQtNpbwACDGUyQF34Q/3my8radYE89PTXAfdL3s55sDKl
         GS5IcfUzXJiFO+RH5Isezln4F0ivW0GfSm6OUC9g+so3KkQIGRLUDJidfMJAGy3UggDP
         JsSuqtaeA7GWdcQFstFtAVh4bDmPrzZ2J21ZlwARZ0LU7b9H261Jz3+cjdSYRck3xQAD
         Sxdwrz0faf+VAQvtScx3GgUaDG9nOT7YqYusVJf+sJaCOb0DPu+HCMy6sc9Jm1TuAfNE
         RysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781169796; x=1781774596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7UWn+/o1z8vjqgLMtj+iGKcEAIf/D00Y5lREVjVXChc=;
        b=aDIU5fmP/UC9MhU8lEw+EQKk4/AKXx8jqi4fixUxCeactnJtL1XUybFRljcaYwq7mp
         s9G11BunMS28RzKOuEzpr/mr7qk4pp6hq5NOpMgrEtEcwCuO+69Zli/D48CIvaLvqUrd
         gyxoqKkioJaN2uoE/stiZFiQaa6qqfptPecwUijmqHyTqZfV8EPjNytpOr+oPkufLh0b
         /6wh0KP8QEBgTpkYccY96hulvGp+Ev9xE5tYrTVmAlRk9WGUiwt2U+L72lHFEnXl6Lb6
         9OH2QalEVWl0yCu4ROnLPIMIXATht1GvMXN1x6s9eKY+hmeNJIMgLjj7BejfaOfVtUzK
         mM+w==
X-Forwarded-Encrypted: i=1; AFNElJ9h2m4tbg4uAOFUz0UOIA2lfstPBJaMwXyZb9mDSHy8wTHR9WkFHXYgfUvWZxlTCGOzKElJM0qLYQ==@kvack.org
X-Gm-Message-State: AOJu0Yxv6N8NixvUPOuq/g41kEnMhqs68q7BJtqIGu7csnwsTXcfW8uA
	7WcxkRQupLOky/woGOzK6w21tWQiv8X9e4vYXyWKYc7vee0eWqP/r9/3
X-Gm-Gg: Acq92OFXtLyM/hBM946Lvw/BqWzJ9ItmxjykZuyhlubyHnLup8zFFdI++C3pz4++r8F
	M89418cdcFlRT8IQTRvD7ZDc69R8rLcHOSpJtBZ43Mx5UzSqvce8QN87Hvgs3HnPXhUEIQDIIQE
	jOSQEs7QMRe8zUNMKYv7dTPqhhNK4JJ2iJYCZKMigLdsxbHM8eTelMdQQWHIOdtV8LnPAhN2Pfo
	PvZ9TE1nD4ZyGtC2KpF68+kCt9yJSeRb9EJJnhgo2EPv94vkzvdS0oY8LlJW4oaGcI0ZvOiggfm
	kKVuCxV6FxpXTm8dFUKdI+uXjU/ebnaXNKY1+mzCvVeGVv0RUXvzE3lnIkV63cmiwdSWxuy2UWF
	3UfaqFWQQwQwDaLiZfyD8wEd01PTXLwhH3Smwdoe8EthdB8qxq/je5iIpJ7m8wayKqDJ8tEJzeQ
	VUp6jw0HyZH9l/FGL1HVbDVnKVSq/ssFnnsj6bdRvM1OFvW75zylFx4s3rYEPV4Oz2g/xZMpvpX
	tm8B5xPr4QLkzchryH0jI9oVcYqurBmVzI=
X-Received: by 2002:a17:907:d048:b0:bfa:6dc1:3c64 with SMTP id a640c23a62f3a-bfc85c82bbbmr78034866b.13.1781169795458;
        Thu, 11 Jun 2026 02:23:15 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfcb53ca055sm36691266b.38.2026.06.11.02.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:23:14 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:23:13 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, Luka Bai <lukafocus@icloud.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <20260611092313.7d4knb2irt2rtswu@wrangler>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
 <aigktfOjYwxhzEhb@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aigktfOjYwxhzEhb@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8568E4000C
X-Stat-Signature: xug3mrh1xp4o4jo8w5c6fxk6yerd4j7i
X-HE-Tag: 1781169797-399768
X-HE-Meta: U2FsdGVkX1/+LNnGsv+iI5y/JsDM8mE5C9VeBOUcK+gYPnSt5jMWHM/O9C9pj+nsWhfX9TeKdBdEZn3Dj38lHo+jhDIyBVpAsYiL71PN5PykYB+EMJFkaIX9jfyGf6ikIJwlOzNUmmL/1tVoC+FzjOMOLGXO2E5f4GTvsHQCs/26j4fgqteVbhXUMyOBGasA6VbmwGJPYvTj13hRdyEpPz6Si6T+HmqFydWnO6XHbLeOUCZGgzPolVovk0pU8zCWBrhEq4DOVSsW2Z+2MMe+KHX0tcnmlES78zPqhWeuIgYAjlEn796LV2InRcu8F4O3FQU5rTthpAdJCA3o3rNke0cztqcrsRCca7WYNMWUIl9AFwHwBI7DyRd3Btm9sAGaP5bxRV4aWMJ6iWiz0FrQKtXzJT2Ncpdzy76iYp9gH/FQk9KbkAHwPOFg3OCqVx5IEsoHxnz+x9Z2BjyhrdWv4eMtwONcd5yUm2Vo36HCNCzZDc+BG/WQL31bqAgJouTZL1lulJj8fVGgfJsytvWdd39Pi3rGOco3uy+OBwEq3yCOLUs4m+END2RtKzGYeVi1CE/4TsjzMTY7Cq157/gQ/f7K/yoDlb63l967BbrqC3cPuF/Ku/ekenCURIm/3djrKDB1LrpNqhsgZE+qq2VHlB/gPJlWWZwzLrU7jjnVRH3ToKsv7fCn3TIB5PBA1JP4P8bMra0wJnJ3bjb3v0ghmUGd5xPUmTA4VCRSJO6/eLD+DEYBbIsGG9n0+8KlqJTZniTPa3SEaNtdTVF6ddTJzbnZ6mS6JHGfHb6ZsSu9QYDIqMAqjo8s8ArpaP7oH+vMgahzdEf9tmBT6/voqGi8Kk/DLkJ2SPSsngxfH4gJDYd02xsAnGxTg9HzZxlyKxoHnrCR3lS9Os+BXd4td5RB4AL5yADgnCyQBXx622AXAdQuV6/vV8uK1hMWhjusjbTFHXiZMENwUc9dzHIT927
 U4zoI4PT
 UmziQUzm9bqEc0dksrk6KHZ5SpmGv14t9qADLtW+QrSrIcM6xDRWMfhJlLYLaxgoKqu4m6+u92m2p4gadM/Es6HVC1i/lE7kPVxh4uhe6ELKTap4rnS6AguEpyd9X3Gif7SGpHEN/Rljh3oJM+XRTrtCPc/6EEiR21c24E8fwNpp8jwVL+gZWI1JqdzcBFwt8GCR3sNLslJ4y3ONI4K6FvlCAm6FFnItHWzavL8VbdHtoWh3wzc7UrSyCbfTpxSSgSJ007gqAlq2PHWz8Y8b1stZ2kHFoKacWB6aI9ZfcGiu2+JSI/4+S+QZspACCVhXI1mFbtd4n8+G6TDTyiQly/f+pA5P4c17JEoLMzfZznaqTmuoWyPELQwKCOtXQ/+1PIVDpiOMzKUU/Wo9B+LKlNQHGfaYvkmDcbdlxGLeAp+lMgLLSO4ha2Mf/yhT4nKmfxyIVq3/NCP99+Kj3+ukaEhthKhDDe9sjKF0rrkJKpRlaIezj/OTmBtHk9RONRf0OivZH0Qf7rxm9w3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 03:44:21PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 09, 2026 at 04:17:45AM -0600, Nico Pache wrote:
> > I had future plans for something similar as part of the thp=auto work;
> > however that requires significant thought and investigation into how
> > we can properly gather hints for collapse/split THP candidates. From
> > my perspective we'd want a more global structure/system outside of
> > khugepaged, that would directly call khugepaged (and others like
> > split, etc). It would also tie into the allocator so that at fault
> > time it could leverage the hints to make better decisions. My fear
> > with this series is that making a decision now might complicate future
> > work by adding complexity we may eventually want to remove for a
> > better solution.
> 
> I know this is future planning stuff, but I want to point out that we need
> to see significant rework of the THP code base before accepting any further
> major changes.
> 
> >
> > If you have the chance perhaps you can lead a discussion on your
> > proposal at the biweekly MM alignment session.
> >
> > +David Rientjes as he leads those discussions. We could use that time
> > to layout a plan for what needs to be done for this work, and for the
> > work surrounding thp=auto as I beleive they will be interdependent :)
> 
> We prefer to discuss THP topics in the THP cabal meeting, which both THP
> maintainers regularly attend :) having separate sessions we might not be aware
> of isn't really helpful.

Hi Lorenzo,

How to participate in the THP cabal meetings? Is there any public link
to join? I'm working recently on anti-fragmentation, which is kind of relevant...

Thanks
> And 'THP auto' is a broad topic rather than a new feature. I don't think it
> should be seen as a topic 'owned' by anybody, but rather something that we
> as a community should discuss.
> 
> Series that appear from nowhere trying to implement significant changes
> along those lines without community disucssion will not be hugely
> appreciated :)
> 
> Thanks, Lorenzo

-- 
~karim

