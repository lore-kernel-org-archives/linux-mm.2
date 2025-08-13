Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD55C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E747D9000CE; Wed, 13 Aug 2025 16:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2551900088; Wed, 13 Aug 2025 16:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65B29000CE; Wed, 13 Aug 2025 16:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE9CA900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:04:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A37982994
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:04:22 +0000 (UTC)
X-FDA: 83772811164.19.A45ABEC
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 91A992000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:04:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zf+ZunsX;
	spf=pass (imf03.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755115460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzHK0GVXrkNcQiUS+Baq2ibSrjcKTe7n1BFVnpn3tlw=;
	b=PS1XTPNyhrhngR5L+FxiZpH0Wrr/XKQzzlI47DhNKOAkqEUXbIfiRphE5Fw+s8bnnvsLLp
	cCXDXSkSYt6Wp1wLYBYcmx5Y/r4hkTa+qmkHwsZp0GbAVvgQ/Z5slRyWArLLujM/VpYp5s
	sfobWHLfE7pKWxUE6mjX3rMh9CQ96DU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zf+ZunsX;
	spf=pass (imf03.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755115460; a=rsa-sha256;
	cv=none;
	b=ooXMh8Z5LIwcJPKRGASmNqoxdS0kphJ5C7pVnceCpyqIeiO67ihuTuFpkzIy2CReo2Z9KI
	qK1/v2m3zfEelZR3nNsvJhvH6YW07woQ00bjpAr4ZBSRaBz1O9NApzMjvpVbj+T7eHcSQI
	kLl9Z7GuRiXKLxWBjqGQqHHf2jDj3I4=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso71081cf.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755115460; x=1755720260; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzHK0GVXrkNcQiUS+Baq2ibSrjcKTe7n1BFVnpn3tlw=;
        b=Zf+ZunsX9SdjSKQwwALbbNJ4SNXTrX2+i4kOT8S7uzpeQ4pbuhwZwFYR72U/otDBnc
         6OxAmZ9yz6K2UrpixjmtTRRyCaAdO5TQqx20IQPMfHOgOvOU1hmPS7uORb78sKOyQE9g
         qPTsjRfmbMTqBsZhO4nXOdiwM2iA5+BnHAd8JvbUvlnMfVGOm94pvW3gLwx3KV5/BkYh
         m+cToPY3XE+2DkrNzLjbRcIISf8ITgwXHjyHsYc/5qycBBqCQ0JVo8SKea8nBm3H04TO
         9h5kDB4WlHYYzILqewCoztAeGE76AzhP2zLoVXCOTvFuEUKDPvf1gCRz+Fsdt0aZsp+E
         Ckeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755115460; x=1755720260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzHK0GVXrkNcQiUS+Baq2ibSrjcKTe7n1BFVnpn3tlw=;
        b=tydmZxNXHJq63vtC3pWWDVjxMv8ezsUr9LyqnISFT12oTGRW5aagJNJIt8cfYuWI6T
         QhIPURN06TIPJZlAN5nfX8ysYJ0/+BKA7omeoflENRCmVva49+uD/GExYPsyE76kE+pP
         RXHs1SLJduG5e88KgB9h+Np+tXBLoQGC9GoZd6AupU8OiB0emMVF56xRvumrzLfmcwvT
         GwDkvgKBZasTX4mXxsU2hAixyTRhsXWRIyqEMNxpCegqfX4RegPSeRdFbgoJH4wfBtPx
         8NiR5ShSN+aBwYhYswPo+dBLjKUFd0piKKneUb0Q6FibBGsXiemOP8f+GV6rAheG4og6
         Tj+w==
X-Forwarded-Encrypted: i=1; AJvYcCX67TBmzR/87n/Z73qHZ+8Xuyinh9hhgUsBR1ntPm3L9l21hP3ruRR1yHLSeR+nQEHYr4FqesGfXw==@kvack.org
X-Gm-Message-State: AOJu0YxjKhomvYo8QdKfIgYvFq9fm12Ol4GIDTjhWvGB11MD8bWxp8k/
	rwx7zc09aUrLX15mlpig3A/ORRAakDjLic/pCFb/FQE2vrrTbO7QCMPTBI1VtVgV79OH7HNUaJX
	UY8Ajkpe4T/Q7cMFsk0JAykJpzkQZSh8htxR3pZ4T
X-Gm-Gg: ASbGncvqHVoO3Xfk4quzoqqY/j6UY8uVorv2uxJ/1EsdTkCH+cM2ET8Z/zGrZ5vZjrM
	9gXYTYkdcVwSz53rVuaU6agv+e779qD8ktUCgykRDhq8LrCxtVI0Vr78wAX7Ut1n+hnPOG2YxW5
	cWt2OzCGsrLPLOyijyP7nuU47ZzSbVY8c+M3TdKIgWa+1KvAzfstSKPWbegSuSKDgnLxUXONJDs
	GODHOce/thb7h9zqbMyRhJkkYj8fVfI6v3484XGRlg1sCHJIfeCyf7IzQ==
X-Google-Smtp-Source: AGHT+IFof5TuMH8+QhHgnXvaTzUr+RXbKEgLUg6pHegzVmMLcAkHrJb3iKJN2OJZj3lXKhEok4WUK44KsW8CKKXI35Y=
X-Received: by 2002:a05:622a:1493:b0:4ae:d28f:b259 with SMTP id
 d75a77b69052e-4b10bc95c73mr132051cf.1.1755115459254; Wed, 13 Aug 2025
 13:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250808072106.153449-1-fffsqian@163.com> <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
 <20250811214053.857168fd35e70e73dee1583d@linux-foundation.org>
In-Reply-To: <20250811214053.857168fd35e70e73dee1583d@linux-foundation.org>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 13 Aug 2025 13:03:42 -0700
X-Gm-Features: Ac12FXwkRQpdACiVxjXO0NFixyErDF24g59J38UDJEGj7evt80jGZnffIUaV1vU
Message-ID: <CAJHvVchDq-p77VbzO53nNxMTZ-5okMp1SUSQfw_VD3f75fFgAQ@mail.gmail.com>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Qingshuang Fu <fffsqian@163.com>, hannes@cmpxchg.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qingshuang Fu <fuqingshuang@kylinos.cn>, Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 91A992000A
X-Rspam-User: 
X-Stat-Signature: jng5gjpp78ropz8sh5yroptjqtz7d5dk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755115460-187505
X-HE-Meta: U2FsdGVkX1+bbpyQxtn1DBj0AReW6ZGlAaCb1O3t4dbmOPtAbMKYESPtsIjKo+tikQnMv8tcgWi7cvGu6czYsQjyK0XSne0XYbbv8sN+WpWXNRUvUPscGvztrwHAetGbz4UONBH1X38RoeGNyGr9sN16D+xfFhhAqN673DrGXg9aZ+bACvvAKChOHo7fiWeRh9HL2+HeMNbvG2qaUxDLtWeKPUugpUsjvmSyAjrqetdr8JfeBYXDSwolByGR+k2FAuLGMj9IRv0JHjqx63Rj1BErK6ccqMtk7ut1j+wAKCBB3A0hj/JeBfeyWEDlbaRMNTLq02PXSWqqngE8ffMrHP/HpEZ9exwqDO7tXO34+UtmHBIcLSHgepx0jiq7BA3kEkRDBdWrTyhrFM9qIpVCAmV3V+WlqUQJbko7+4VnFnB4oI6pDVfqprtkVFXH6wWeWDDSL18RYCPZTmcYrWCprjfX5z+Z/s3nVEGeL2UReyB6w4+tO/yh97fOdUR4SKyjFSW2p0nj8R5BFAHyk1Wmqi+dkyIF8lcstHuFDhRpTLfwKxvu4t0woq6u5EaOHoY3itVSeU3HWJlkWYKU0ixbsYbsDAexyvWb03u2Jlxl5PE/PvgXRPRMtWOwAjS0f5+cDaqDhm7M5IoTyMM7CpX1hg3kD27eXQiDbK2a6dNTiw4mYAV6xgiXNUrcvYWMoaOxMTZU48q4ikjwq0nFQ9Qi/NPO9Ng9TCUxuwr6OA5H/xCK3V4wMPtP9ANrHoeFMWHP73YnAglK7tmKciGo0UHzEOjPNfOx7kgUsuptnJ8smBRiGyOHQ3lHj3Bvs00r+fqFOJ/EFYF0yjpGTpz02JAEI5nGyPwT4hVYYIxBS81wGf3uEIqsVjsyk9HsMztYJtAzOyuR5ymh2wmCSSQVnOyRPgCM0TjRQn5FtW9UNAv3uL9bkCty++HXV+/xguk4JsYg6v5SUeeZvlvvUHgM6N0
 ZUuHGeUy
 wKrNuP/kQO+Z1WxN3Pw30MFurxaWRdx9KOgpTKM4BlBby1QrXF2Y2gEGXmB2So7amRhvQY4KUPAARDLCSiRjVrpudiwnamG27UBFG5iyyVb7JvAlboW+0dZGXUe4auWQWWwgOTQ+2asehkOwLoh/LPf1NEKS9f1AMMx2P8q/o11Y61L5d1HZhLyatGnGu27J1WSUNu9Oh7Xt7mfGBPcyggjCxC2VDypJIlt49VzRUZ0RaWDmlDVgnafWSS0NIhTddaZf/eP9uWh32QgDhFaY/iKE0Bu6hS91Y5YNmzJ16Ple4tdr/w/eIOejKOdx5VlgOLQwE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 9:40=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 8 Aug 2025 09:35:19 +0200 David Hildenbrand <david@redhat.com> wr=
ote:
>
> > >
> > > Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1=
)
> > > is int,but MAX_CR_TIERS is an unsigned type, directly using
> > > the min function for comparison will result in an error:
> > > from mm/vmscan.c:15:
> > > mm/vmscan.c: In function =E2=80=98read_ctrl_pos=E2=80=99:
> > > ./include/linux/build_bug.h:78:41: error: static assertion failed:
> > > "min(tier, 4U - 1) signedness error, fix types or
> > > consider umin() before min_t()"
> > > And MAX_CR_TIERS is a macro definition defined as 4U,
> > > so min_t can be used to convert it to int type before
> > > performing the minimum value operation.
> > >
> >
> > Please use empty lines to make the description easier to read. Also, I
> > think you can simplify this heavily.
> >
> > We should add
> >
> > Fixes: 37a260870f2c ("mm/mglru: rework type selection")
>
> I'm not liking read_ctrl_pos() much.
>
> Local variable `i' has the rottenest possible name.  In this case it is
> a "tier", so let's call it that.  And its type should be unsigned.
>
> But an incoming arg has that name.  Probably inappropriately.  I'm
> suspecting that something like base_tier or start_tier would be more
> descriptive.  Hard to tell, because read_ctrl_pos() forgot to get
> documented.  And this arg should have unsigned type also.

I agree a more thorough rework to be consistent with types / make the
ctrl_pos helpers more readable would be better. As is, given David's
point about not being able to reproduce this without fiddling with
compiler flags, I wouldn't be in favor of taking this.

>
>
> (cc mglru maintainers, who have yet to reveal themselves in MAINTAINERS)

Sorry for that, I took a look at adding myself and Yuanchu, but it
wasn't clear how to represent MGLRU in MAINTAINERS, because there
isn't a mglru.c, it's bolted on to several existing files with
existing maintainers. Should us two just be appended to the list of
folks for vmscan.c, or?

