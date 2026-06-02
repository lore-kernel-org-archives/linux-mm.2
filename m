Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE97DCD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F72B6B0005; Tue,  2 Jun 2026 11:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8AC6B0088; Tue,  2 Jun 2026 11:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8B36B008C; Tue,  2 Jun 2026 11:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB7866B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:54:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B09BC3096
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:54:45 +0000 (UTC)
X-FDA: 84835420530.27.86C7B4B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7ED4F40007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:54:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D98TR4O2;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780415683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1R1Ix/hNP2c7DmSyPCrvcGynZL8Qs5aPHoY+LWWhkG4=;
	b=hPPXx7H/GN7obylNjtfUBUOYNirwfq9S9tyx2dr0zclwaNoyrE120vZ9nTozKJCh2tg+xG
	N1wCPt98SNAhO2G1P9QUdc1JVxAQyJQe/ETxstDiETOyIj2J6TbbPW0PlSzgG/7zIpmFE/
	XiPMQfCuKQY7BOqyTEGJfQ2r7XoO2A4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D98TR4O2;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780415683;
	b=BaJ8yl5GNstFr9EdxRhs81I9XSy8f3eOyP8T+JLFKrojOM5ExWa7ba2Su7AsrK5ahl26Fx
	g+8z35IQSVgplDZdrfcoy67Kfpcwhe9JLVqZmlFF7pGlGMDJQpv4ctxEXb5f6iGA2DuJvU
	TNi7XdBl/i/nrd5s3DCsdtOU2ikAdgU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4906869f0cbso109340615e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 08:54:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780415682; cv=none;
        d=google.com; s=arc-20240605;
        b=ZpgHXZ0T1rt4GUvgrffyYtuE8Ah6HHGbaE/3uHL5bKnMsQQc1uWVE4qz7zHfpG5a0m
         E0D3Xqrztopw9AHX+zKkYXip5RHdsGdnv9Sq7E4bDr1UHhEwH+Uw68QBz9l2qZdxd3T1
         4wcAKSqfw7BNQcJiRXQU5B6QEC5Vss0XYOG42PMWXqO2FpgI0mkBhqIfyjx0hVhhU2gI
         UC0UHEfIFHHDaMIlePMP0O0E7+RPNYiBPAjCIyQJ+VKdhyUbJ/PiXg4DgLDZpPCTd2w8
         RLxV++3AsKWQYFcdV0Ie6LCEwm5qwNCk49iQEXCG8Zsc99dfG8oB4lz8x+G7khGbl65Q
         Do7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1R1Ix/hNP2c7DmSyPCrvcGynZL8Qs5aPHoY+LWWhkG4=;
        fh=DIY2ZymRaWQLhaldLq/aI/jlinziwQK+MSH0N9Fr1rQ=;
        b=LQWR/r31TzMw9H38lgQjNyx3NOg4vvtL/aEbTD55LmJPM0fyVAiQwheNzprBlnKEJN
         e084tO3ptGFqEc69NIq9dDBno51ZJR8CSjp0gpYz44F3eKpdQWFfHxAdsWBNXwe1cEDS
         U5AiILvCCandkfM3uCB1FDGVTnUixBn0tvuzqB6r4XkPwMpLytj07vZBhhmzSq8r0kzN
         2ElGqm0enWMP3uaHWjJN40Xa7tOzQZH4R9wdP5QGnjj020JBu3QORFQO6ZcE5HvYnR3S
         t37vZ5IkVYQ0wY2jg8eb1XMarqhFJnVV8xuwK44qMzuGsv0tZkC56W4dx8h9DO7m1K9C
         u7IQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780415682; x=1781020482; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1R1Ix/hNP2c7DmSyPCrvcGynZL8Qs5aPHoY+LWWhkG4=;
        b=D98TR4O2dfnuG0X1dihxfc+90fBTmX+iUfRrCQgYMBQE6lPsvdaD/qnZxS424MCYxO
         fOKtN3NJLn7ov92sPX2xy5Ee+OiGNGNuFlbyL9p/cqXPgk0jPOfjaLKkiP8SoEp461z7
         hMzWJMoX46rtVYCdsOrNgKO0pk10avM2ev9dsOwkV24WWwD7mx5KlrhPzXKTKBOE41kL
         R69htVV66be9V7P12MUwqbnXTvMdq4+yv2D1JyQPjszteEuR2BtMg1B8ZPuEAdMMQwYt
         p5BoiNYU46EQ2XfX1GanAYqrCIq3JzoI/GS/jJBQvT/sD67FUU7V4YWTZchC05Q6rk9c
         Rd8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780415682; x=1781020482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1R1Ix/hNP2c7DmSyPCrvcGynZL8Qs5aPHoY+LWWhkG4=;
        b=s2vQ8bk5oO8yrE7Sc8TQxCfaAZCaAoYdr13+it/svvzZ0Xn47NBhT+rorDzOaf+MvL
         7+U53MTqUEp14W++WUSChWTelBYGbUbWiIMJTfLK3A7bqTNhHgHvmrRpj3+yXwYEYNAf
         DenrPp79EoUd6v/J2yjAd1jzfj727bVaCKjfA7EXaQuebdJp5QgaqGZNZc4p7BTKAOGt
         teI4yFUbYQ9xMf9vkjBJmmXjZki4LtR/5bUlNs+1IRIRtlmhwBdFxmM7HEmZAU5yuJ3B
         goNSzVWy2KgBJXPbNGhPdwzj4eCz9ZqFS7IktFbzfjN+wqx3UnYyFFByi6lR8gm9xlPH
         vHZw==
X-Forwarded-Encrypted: i=1; AFNElJ9/Gf18sbjgrz0gtdCrmn86IagxAltuTfS0PGeG/7c1uKEiOSjwivJ1xXmFdhjAgdAuctY/QbP17A==@kvack.org
X-Gm-Message-State: AOJu0Yy4pZMwMbg97cx8YVAfnDN5ON+ZJYex8HAPiOgjup+Aryil2159
	5L8RvrlUlGtu16/dxcJ0aJKyg+pkCVjwaxGus++RKdQjZ9IFs1cnpF0YP/QWFHuPQseLWPvewd5
	z3/HxaH8GsiZGa2hSF4JoV9gCPzM6EAo=
X-Gm-Gg: Acq92OEu60RYt9Qt08+m1kRV2GpuB7HgUPrdjw6DK+FQ94nMtFv7CVtXH2JZMNkWmh1
	6869vNwwwkvh7usHQaALcfQDG1Y7oWixKAdYbYOt6tZwaaHIhxQHEuFwIPkb0tZOuGn1XshfOcT
	w/pG+EHnsn/v/S6gCuLV+cBSQgOeY1883O+vvis8o/eFPSk5twHRkAuZoP6OtyXcg+axvixdVSt
	PZmUm+eTY54vETAVfr839U74Kox5R5lerWQbvizuf/CG9MQTGL+tlfj1eZsqaeBfWf6ZtUvVnRK
	LAXSYKhSSogOSYAL8u0TXYuXFzNuwUqf3bnQBiKfqoeDmL36p61FvAOT4QFq
X-Received: by 2002:a05:600c:3f0d:b0:490:6e11:c303 with SMTP id
 5b1f17b1804b1-490b50800dcmr5883175e9.13.1780415681566; Tue, 02 Jun 2026
 08:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
 <CAKEwX=NNNf0KCZC0ph7VRW0gjnbXd4W5NKEaHM4XzPdN03Ek3A@mail.gmail.com> <CAMgjq7CT0ccCnzmpRGjTGPnNEn4eK==5A-OFbr3+p465dQMH4A@mail.gmail.com>
In-Reply-To: <CAMgjq7CT0ccCnzmpRGjTGPnNEn4eK==5A-OFbr3+p465dQMH4A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 2 Jun 2026 08:54:29 -0700
X-Gm-Features: AVHnY4JuNWTHfiBCJhA05cKPBhtFvToyOb40WTAxv5a1N06Szobh-7Laznmn538
Message-ID: <CAKEwX=M3WAkSY=Zd35dEuQ6V3ZiNR02bKAN_DnCgVr69w9=0sQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7ED4F40007
X-Stat-Signature: 4oda4ucq4igka93de6na35iapwocneen
X-Rspam-User: 
X-HE-Tag: 1780415683-113698
X-HE-Meta: U2FsdGVkX18sgt46zGlfPZiAsgLBH6L9bjLlEKNfNLok0u8XbTCF4sj5VgOw3pHnvkgcTyiIuSri5rW00yCMKY5E3ZAya+/hiKmMefvu28kUFysw2pe948KYOBoSF0z/RKHiUtJvjJCqGi07+O2F6YXK7trGwBwo7ykJbGoa/xOAEUcF9jmRex/pyC68FZmxsyhLkGonryoJ4sGs74+PZJE5OgHK+9EFaP13bFpQdMFAhzcYeIDmJJABjNnNPXiFn2zW17eC85WobAZQGtzX3R6FTi7gBtB648ORegiRuyiXc18P8RVy6iQKKZeAvAiy/lyrMgHGgsCTgwuIEUdOCHlayFaz56BSQR4zRejIW0Erzh4B75VJOXZthv4dJzHdbJPnHS9Ku2j5zV3TzjOeSHI+SqLXPO3ZudZn02VUb1i8WkVfcd1SXOrMAZVzdld6+mL36pmequYmc4H4QIM9HlNgGZPWiNSTpdYTLJGdz5UxAIKIsHIU1255MdTbCB9xXLS3QcQxHS9nb3TK9wtkoHnvmyhu8d9v4QOCORZwOhUALxYU/2gFQkuIoIv+qH8b4W/SYNDvIHLhzvHxMlWr3NkoHK0rKHS9zzdm+3olwcnjGjW6lIuk32/J2oPWJ8r6hMNEvNNwGT7/7NLAZ7uL2vuMYDPqzMpSrYYEL/aRJOl+yZ3dcJrjvXugMT+uxkf/dRzYbmA8femRdCFD4Hf6YyiuEyHeQKnuiDd6oEI6RIggD8xwUajkKYFHRloLwO8WHCazdUlbMsO1fh+3r8icRPFhgHO4SIYew3Ek58OXY6/WwASPQ63IirU0u+gP/RluoO+kllZ+HxsskbOk57mUvBwQV3Gj3kwcmO15PLJ1UdJXf03pwL6hCWwXqDn4Dj2EgHPjq1qnv5TR469ixmImPyVHsKBx2aV/JElMq8ZQgNEz6xtgJe92nWqyWLDKroz56ghIZD2yxhj04Mz3E7p
 BovpMgXp
 1S+YrKIns3sBDvRZjaWkCVsRV7HQILW5HrF2KdWi4eU6jhcPGr+PRhwa3EDOuyzeI4Bzy6eTcFPJmQmiQEAeV3hqvoiCsIC14AlHkfLpNaNrnQo4Ca/bjVsp+m9cJLMkF5vXF13+ONmjFyO4JPk1KmwhrG3vH+8G81r06IdA0OBIFiA5YCr7GsYSO8LyCID3IxtjtQ2ZFZ4IWlFw5sgPIUbRlpTfR/KGSJ1LTo7hGw//jsOiwuRaWW7OjVQiXzmy28IhIZD95kfQXJD6rai+nszOG9GzsJHOMJyjCEN4pbZuBRrEdxjteUgC4at+RMQIPIg625titRaSfgx1bVotEpaG1SAs9hbSc6bFhTb+QVNSbQmVsb9j1uJXQKxdO5zaA15jcjtquUrMatbcOd+8WS2VD5kPPw4ctie5AklMQihb11NTExeZTYEFIspT0a4xIDtU7rLYUXHKxc4ylstGCTIsj8vqGQ6WIpW5o099buyKa8LNw9IJyGb12GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 10:49=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Jun 2, 2026 at 12:22=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Jun 1, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > >
> > > > On Thu, May 28, 2026 at 02:29:24PM +0800, Nhat Pham wrote:
> > > > > III. Follow-ups:
> > > > >
> > > > > In no particular order (and most of which can be done as follow-u=
p
> > > > > patch series rather than shoving everything in the initial landin=
g):
> > > > >
> > > > > - More thorough stress testing is very much needed.
> > > > >
> > > > > - Performance benchmarks to make sure I don't accidentally regres=
s
> > > > >   the vswap-less case, and that the vswap's case performance is
> > > > >   good. I suspect I will have to port a lot of the
> > > > >   optimizations I implemented in v6 over here - some of the
> > > > >   inefficiencies are inherent in any swap virtualization, and
> > > > >   would require the same fix (for e.g the MRU cluster caching
> > > > >   for faster cluster lookup - see [8] and [9]).
> > > >
> > > > This could be imporved by per-si percpu cluster. Both YoungJun's
> > > > tiering and Baoquan's previous swap ops mentioned this is needed,
> > > > and now vswap also need that. If the vswap is also a si, then it wi=
ll
> > > > make use of this too.
> >
> > Oh and the MRU cluster caching I mentioned here is not the allocation
> > caching. It's the lookup caching, basically to avoid doing the
> > xa_load() to look up clusters for consecutive swap operations on the
> > same vswap cluster (which is the common case with vswap). For v6, it
> > massively reduces this indirection lookup overhead. Performance-wise
> > it's an absolute winner, just more complexity (because I need to
> > handle reference counting carefully).
>
> Ah alright, that's interesting. And I think we can keep things simple
> to start, since sensitive users is stil able tol use plain device this
> way.

Of course. I'm hoping vswap-on-zswap will not be too terrible at a
start. We can then optimize for the swapfile backend case later.

>
> BTW maintaining MRU is also an overhead, I'm not sure if the lookup
> pattern always follows that?

Yeah I had to be a bit careful in v6 to make sure the cache (and cache
invalidation) happens at the right time. I've had this idea for awhile
- there's a reason why I waited until v6 to implement it :)

For instance, when physical swap allocator runs out of slot for a
cluster, we try to reclaim the swap-cache-only slots. That involves
taking the rmap back to vswap layer, to check swap cache and swap
count. This is a very random pattern, so it does not benefit from this
lookup cache, and in fact invalidates the cache :) So I had to add
some hint to avoid going back to the vswap layer to check for
swap-cache-only state.

>
> > I also just realized we'll induce the indirection overhead on
> > allocation here too, even if the cached cluster still have slots for
> > allocation, because we look up the cluster (which is basically free
> > for static swap device, but not free for vswap devices). Might need to
> > take care of that to maintain vswap performance (but it will then
> > diverge from your existing code...).
>
> That part should be indeed coverable by the si->percpu cluster though, I =
think.

Yeah agree - we just need to be a bit craftier with it. The
fundamental problem is in the current model, we're only storing offset
and si, then look up cluster based on that. But for dynamic vswap,
that look up takes the xa_load().

Once we move to per-si per-cpu cluster, then I think it becomes ok to
store the cluster pointer directly, correct?

The reference counting needs to be carefully handled though. I think
in my old vss design I did something fairly silly - just hold a
reference to it while it's in cache, then add CPU offlining handler to
clean up. Not the end of the world I suppose, but maybe there's a
smarter scheme.

