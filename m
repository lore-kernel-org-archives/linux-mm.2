Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B7BDD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D413A6B002E; Mon,  1 Dec 2025 11:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18966B002F; Mon,  1 Dec 2025 11:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2ED26B0030; Mon,  1 Dec 2025 11:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1EC86B002E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:43:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72DCB160232
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:43:46 +0000 (UTC)
X-FDA: 84171473652.02.D18240D
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BD8A180011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:43:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Rt+jdFZM;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764607424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6A3fijvZfqRg56x0MUZazWwowf3lKWT9LWRpRCUaoQ=;
	b=iLJ9D1Zzg1flnOcLfVpRQ1BxVQRf+DvrDtVmPhrI4XzuA919dJZS7OL+NpoumF1U828WT3
	HhLxe6GkpcO9cR+IINlkYTgdDF3yF2mTnRVhWyXc7InWwA8a0Tr5tGMY3DTj3ADaAgNEoM
	qBR5Ey6jH8Ww7ypWpO2fKM9WhwSP1A8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764607424; a=rsa-sha256;
	cv=none;
	b=XXkLXbRDZIUMAK3SppRypxKLkulEmecA+YVcipCE4f+Y220TDaTL+yl56HL5LDTwLpjvnh
	nGgpjmhMgU9YjaAjljVeUO605an02ersx7D3YCt2bzPoAiSQk8rqD/0lx/VIAmk5C++mAX
	WXSY9VUrUjqJa1IT8gA8nBDMnyn7HyI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Rt+jdFZM;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed7024c8c5so34994781cf.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 08:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764607423; x=1765212223; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W6A3fijvZfqRg56x0MUZazWwowf3lKWT9LWRpRCUaoQ=;
        b=Rt+jdFZMMVRZLj5GVUBnyRRWXfQDx7jk0lyjEhvJKFA6tRLafVA31sFqZ7KWZgooI2
         WRmgmyvBjYw7IuzVsT6kzhhjuSZJ7jd9TKM7Wvola5sfJ2h0kgjWqRODXeL34dv0hT6Z
         ItWJxl9cIYWaBGERqwkXXDjHZ7tCk0aZKyasgu6JggXz9aN/GXPEIelhZ5d8P3+htgYB
         DcxHKgEK2SAmsY/lWrFMDl4jPvuMEp2sXWkpLoRabsOeOXhOkY7zZ0dzqbF9/vVxQcQC
         sHSD7SOPtTsyFKZgOSuKFzbbEqQF6XEExfuX9bNB8cxjOR2am1uCC0vgSoOvnIOebO9L
         947w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764607423; x=1765212223;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6A3fijvZfqRg56x0MUZazWwowf3lKWT9LWRpRCUaoQ=;
        b=wGfV/mT8jdHQcl5wKIvPdpCg2jDItr1wfIDonDHPIhHeBWIYPJ9BVfA/hJ7u5ML4ME
         feg8aPdHKospPE7Ux24b9Y5e2PUacUH4tEg9Ea28VLLi/b4pAjCbZObY+YS97ncYX42J
         lFNywMCxS/+MZnvxxWQhJ5eLq7Solw71hOOz7iqA+3cGMjQh3SFuLzFtVHyUzR2Nb5NX
         xZKMym4OWBCEoAFD3h8Y8WSP+XVUQMpQ9jrg9wydok6NCl4N5pQ1LF5enLyK9IFJtefV
         0WmJAPoB0mmNg380XhtfP+bhRJelc5u7nFqHYZM9hsMgah0hKhDf94LE9u+ywCgh7j8A
         9HRg==
X-Forwarded-Encrypted: i=1; AJvYcCW12+vO72inzCkvA7+lkIFtbFh9A8cSkm9H15C0CVqS32u1p1GtAKVtCWH3lb/D1hnSh2lF0KibRw==@kvack.org
X-Gm-Message-State: AOJu0YzeXqvfdRij1BhKELQSUzYHmg9gKfl6snwXGi0ZXr/FZE2cU1+O
	ppTOv+vTf+l4Gj/PkToIKh+w2ROdpoDQr0YZpicZM/1OWefuoSbCYJfZBj3rwtldLMo=
X-Gm-Gg: ASbGncsGOKBi1LQ4EArT6dTADBvp5d30UtZa+lTjdnOnvhyf2JpCknFVzaIZfLafytc
	ZcgoxlYy6uxsIR8YjzmyFV++mEAe/CequCAbfeCbUBUPOBPu1RdnItndahmqIHaDAgebn+eNzEA
	EmCboVXfLnfRDVzGiN0i1wpv2S9AqY9hkXsyu3wWSJH4OLGLJZv4Kzkgqqaa6W1Gp7Vd2DsMOIN
	f4pu3TbD2gSfZCHkOotbdDDZJeB36stqrwJrx7KMrQHFJlFS2F6qWEJhAhyZproOC7MgXTzVf/A
	Q8v5durNaVjegaJlj6xWfmy70BFLB37mVHvtWSduw9F2RlavRamabto/baMT2NodUlhYfDLNUUb
	bgKftGNKIPqdpWPxNG3G3hRGsqVrPsyRhpbaotGu0dFZ94E0019EMgQ7iCpIiQ9+tv2SyE1PU99
	xEVdKl1tKrBw==
X-Google-Smtp-Source: AGHT+IFL5Gt3eXeZB/NaqJ6KrE/7BeAcxNBW82wvFuHKT1wVq74KiJ5+vkjNBzMAeSnRSDqxnyXvvw==
X-Received: by 2002:a05:622a:44a:b0:4ed:b94c:774a with SMTP id d75a77b69052e-4ee58841e9bmr606786671cf.5.1764607422936;
        Mon, 01 Dec 2025 08:43:42 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2f9a3b5sm77523881cf.1.2025.12.01.08.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 08:43:42 -0800 (PST)
Date: Mon, 1 Dec 2025 11:43:38 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251201164338.GA430226@cmpxchg.org>
References: <20251124193258.GB476776@cmpxchg.org>
 <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org>
 <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BD8A180011
X-Stat-Signature: um96o867jeohykszbed64iywsijpgc1e
X-HE-Tag: 1764607424-892839
X-HE-Meta: U2FsdGVkX1/Njurihm2kL0giXFfh8i0iEPGDTZgVPkRFWCiq/ujY5CCccfLtMQ1X1yO40acNGT+4EP3koc1S+YCl0e+fvPWrtZs9ZzPX1Z9Lo3kyyjTJup9yjw1F4+H3TXlix50NVCGtTzC3wtJsnkSwJxuneKWO6steyDF6nTyFWeI4noDDmOpu1lN5Tbfeyt9cfWaQPW7kix38o9mItZNZYyz3LSfhHCQ79JOtVYpKtBULG0yvxayaADmzbCCvVpoFew+iW8bdl3P6Yfgop9/mDdPV6vm+cRdArNMTX/Yl3mhBfpWIQa6vMKbwIJs7nKuw8a8CCX/7Xq2yqi06pm7vSz8kIAcKjrZTdSt3YpUFsuc8bOKD67YqrVd6I92kJGx+ugu6V30VhXU7K/kiSMk5mwBKxm7toz7uorZDcjoA0I6vakbAl0qk/LPtXvXGUdxJt2/UtorIv2ajc+sgpq04sg5ZXnAdfbe7Pid1UxXno+NehUIIqZudDiY6hNYChDHFeKennYRn7eAVcqbTuRhAs1Ldgnn+rrDdD4XARI+OEm+DEK9zVKq7Uou7cFMSk6MPsLe359dYSgSZFOXPVK+3WeJrYh3Oms/s5/HQAnpUmf2OtUbShW8WaxWmbixOkbzDJ9/ORUAwHA3rvt1LMRB66nAh2IKAFLvhu/i/afbTe7wx14SHBJVeZFckk0YWe1d6LZuUaACRHdVxkkTRJfBYEWWBinNR0CJh2nLscfevxQ6TzMNMHvUh7YoJ2Tw9xst3U3XHqnorsocGeMJ1Ta1JV74374HruTaqeizMgKjyoeAfoKRMVtajB3OC7NLlJgVPaqfH6NXRT95Rhw9Iui8EVb7XT77lI4r/9rxLKxexXW/mcye9r58Lc+dCyoK5xsllYteXzLk6XUbB1DlN0oD26ntJ64KzdpNmD5aKQJJRwhspv0LM4TTO2YgpHgdMMqMWcNUh2rls4FgfPWe
 9bM9vgL4
 LHAdLR7FPjAF9fBY1x5ZVm7QJioH4hproRYWVfG77Z+cwFR+UVwXELkNCQsGAci8OVsYXALDbfrTpDj7IjITpikXqW5OJ3KWEyK0jvEkAJrks5cNVL8nVvkQLKJ4GcP/5bxwICuWydAQdlyEGbyyDtI6Lh1UkHnCyb7LXE/vOi+L/jYNqhDQ5N9jey3gh/p4ruvmaNp0DKfQn2s7YR92aXTBNeyzYsay7hyrnnecAr/l6Hht700pLofQUjiWXDtGlphTG+KXPLgiLVx6jiakNVCgCIRnyjR8YMQH5iLCM3Q1ZKF6mCo9yMj38C5AiHR7NTH0u8SYQcLfkDoi9o9N0LpTFxK0p39zdzpxUsD1u6f2jD3CGxvpWv/UmJW+3JyW7gWaa2tJiHXU9Ydt9ltFp/qUxa6fBWkkHcdBqOAZivZW2Xw0m44CWJNVOyFPAjBA6C+W3iq67jSa2JcPDC5o80w/gMQ0bXRytbeJAsUGt6fjpztptkuLK9gSvSbd+KiH8k1vmUKMB1vC0AQUq/uW+1fIhUHBQKGULfNob9EoJJwlfC/kjQKGY0z54jt8vmwzOA0XfUtaOXq2xLMZYD/3GR+qv3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 12:38:38AM +0400, Chris Li wrote:
> On Sat, Nov 29, 2025 at 12:46 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Thu, Nov 27, 2025 at 11:10 AM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > On Thu, Nov 27, 2025 at 6:28 AM Rik van Riel <riel@surriel.com> wrote:
> > > >
> > > > Sorry, I am talking about upstream.
> > >
> > > So far I have not had a pleasant upstream experience when submitting
> > > this particular patch to upstream.
> > >
> > > > I really appreciate anybody participating in Linux
> > > > kernel development. Linux is good because different
> > > > people bring different perspectives to the table.
> > >
> > > Of course everybody is welcome. However, NACK without technical
> > > justification is very bad for upstream development. I can't imagine
> > > what a new hacker would think after going through what I have gone
> > > through for this patch. He/she will likely quit contributing upstream.
> > > This is not the kind of welcome we want.
> > >
> > > Nhat needs to be able to technically justify his NACK as a maintainer.
> > > Sorry there is no other way to sugar coat it.
> >
> > I am NOT the only zswap maintainer who expresses concerns. Other
> > people also have their misgivings, so I have let them speak and not
> > put words in their mouths.
> 
> You did not mention the fact that both two NACK from zswap maintainers
> are from the same company. I assume you have some kind of team sync.
> There is a term for that, called "person acting in concert".

For the benefit of anybody following this from the sidelines, the
third zswap maintainer also expressed concerns about Chris's proposal
upthread. He works for the same company as Chris.

The reality is that Chris is failing to convince others of his design
direction, and is now obviously resorting to manipulation and hominem
attacks.

During the course of this thread, Chris has asked for "a little faith"
that his idea will work for all stated requirements, without deeming
it necessary to explain how.

When probed on technical details, he stated that he doesn't like to
plan that far ahead, and prefers having somebody else iron out the
implementation details. He also referred to high-level slides from his
LSFMM '24 session - which was received thusly[1]:

  Matthew Wilcox agreed, warning Li that he was setting himself up for "a world of pain".

  Jan Kara said that existing filesystem designs are not suited to this task

  Hildenbrand said that this plan was introducing too much complexity

His first response to criticism was to invoke his <4 week status of
swap maintainer.

Meanwhile, the design direction that Chris is construing as a single
company conspiracy is anything but. The collaborative origins of these
patches are well documented. Chris was CC'd on those RFCs. He notably
did not engage in them. He is now lying about the narrative and
choosing to attack these patches in bad faith and out of context.

This pattern of behavior gives me low confidence that Chris is able to
collaborate and compromise on a design that works for all users.

And while Chris has been quite vocal and opinionated in mailing list
discussions, his actual code contributions to the kernel do not
instill confidence that he can solve this problem by himself, either.

[1] https://lwn.net/Articles/974587/

