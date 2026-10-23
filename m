Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B61606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bzV04p+d
Received: by kanga.kvack.org (Postfix)
	id 8B6B86B0BAC; Fri, 23 Oct 2026 13:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DAC6B0BAE; Fri, 23 Oct 2026 13:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E716B0BAF; Fri, 23 Oct 2026 13:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A63E6B0BAC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:24:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFB48A01B3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:24:36 +0000 (UTC)
X-FDA: 85354565352.30.EB35AA8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id D31F9120006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:24:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bzV04p+d;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
	b=VpmwdXOax6VUNfyjYhOxdedBozjZdDe0lr5E4X4FastVcM8xgMdTVhHO5a7Sm+dLDxXARp
	j7/pxORYEkCnp7REEIXlUis2aGY+hJ85OAgB+N9G3ZNtEKN6be3pIjsx/2KOF3mTtzLE9N
	6fphYcD4MqwGBW+ueaWbcTyELlADkdc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792776274;
	b=WrnRY3Jk7Gb2dLJ9box+7tJQa52L4tDbJbZWKaUIkbqIElFWLRCOC5wulPdd5nFq6a33t0
	I9zm1oHNKXJFLgQjyww1ptu1KwoX74ZXw6GBJkLbBe0znVIblolZbl6hChSWrlFCBbAiEV
	a3pxOPo8mHigr+J0/0oHaIMgo3+DiX4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bzV04p+d;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48c4649b35bso1182288f8f.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792776273; cv=none;
        d=google.com; s=arc-20260327;
        b=obUdugN6S29+bhnhUE7ZgyC2bDOywB8ohjTJNeq0rIh7GUCTuiUgDvo7afb9Jn/Gp3
         YC5jE3i+cNqqA7oymkc+jllubV9CEAotHMs8FMsg1WddX3rjqZ4Yvxb8U5ZkRB7yCjMg
         CZoOuwXYycmDYCAVdHx2YY3JWMZifbUfI1AyZfnRkTeMCu1lA9BbZL2O2smK4cH6TiMV
         a5jW+4PezDK7xAT53bPuqp1R9iwOzg/c+LZxDwPDepXnngGse6X7RtKCSQ+qoR1epVTf
         cmgis3KYxhYTtnLrTu14S4Sndk9iEspx94QUpqfcS1+HEIveGrgOfM2RZU0OYT6HcnO4
         0CSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        fh=/r5IKBn2CJOVUkW/hN69fO8O2UIJUC0SG+5cmIbV/DI=;
        b=elTo8NFTRbP4Y292kAynhBG4ZonET/tl5UZ8fHyYka72sBLkO96C0qvOivWx2ZgVMF
         oOPWeCqZcTTZSl1iCNwZ+g0iyqET/EWtHdakhUwXzmh4xycpyLgQIBKZ8mVKb9n07dgR
         c7qAiR65kdM65xrgjFAYBzLr8fOW0IRGBgH1zxXfkuTIXfg1e5kYlW2hAUTFb0dZG2io
         IHIQPIJ2zaQbzn3vXYG8H+2VzZggTqI8iN6rpFs8VmBUNXHp/+v8X9r1IDHKLkPe8Ehc
         CpVK2NKdHOipc7u3jjYpYd1bOnj4UM8f176BX9gyEMYtKfFhqPOSieLaQPaZiao12ED7
         G+6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792776273; x=1793381073; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        b=bzV04p+dkbFTZIyMWFKuDrOqvqhK5oIQtvoBIn9dJV23MpOlyDp4JeyUaTdFAjoFdM
         rVWP1CAjCd/MYegZ3E57RE2ruMPNgKMGWPJ4xmeZ+VQPaK2fXhS+mdMbggjc2K/ywqxm
         A8SkJ8FTXoJR6+xIZcHXZF8hfsTYUon237HpVNO20OBAYarO5tjG+UWgRnJEm4jGk4/F
         n+DLNa0kMxq3+JLdj07F/7vEZeMrDO5thSQTL74HFrFe8dG06r0kVJj8BlhR5T/qWnTN
         Nq4gSfOB53gx5Uzyv89cAEN2JbHpilqihUblbdT+sXmDIo8oLIdG8MLtpqaV3RmlOdry
         LQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776273; x=1793381073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        b=A4HyFzyHFlSOFnvBTs5hJfn3ZIiqO95tPQMNzDOrvqID/WnemMhzwXUhDzPXRUt29/
         +2wtl/QO7FV8r8wXELUj4iDVQnrkVsivbb6uIidVVbMfh5m3RQRdDQ1yZqbcyJaLHcg8
         Xg/weQhgmLsTisXdXuPPQJV4N5lrGra7FMmwaL3DetXPXovER9SG4fpuGT35cmZyxZVl
         12ZBR+e8YwJ0pqZRkGUcs3hTNDz3WLGNMNBbARlQQY2i9pazGSAkk93jj3GM0cvP0upS
         uNYIHq3/dUVvd94EuyyL/Y2ujzAFv9DRhn8Ek6nGbBiNhfgid3B00tmQgfJFKP0dq6f3
         cZ3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzar/NR3EsNpyj/vCRAiHBTEYXFwF3RiFzGtPsnvSZ7dHJXIvVAjAAdFqRU1TYjC8t49Rf1TtQq2w==@kvack.org
X-Gm-Message-State: AFq9FYJh8SfwF5JXKcFYlzCVOrR/dj0O4b2lrQkmB+Om6dFiMIFXZjQW
	sH7ke0ijFyqybmsU43hRH93bzDOz6vFg7yCrMnVWya1kcdT9N+SPMGay8W9rvq27NVQG/girDN7
	SCyPlvPCj7jzFKQpqlpU5kyCZVm+x6Do=
X-Gm-Gg: AYBFou2TZBayVX+/IV+YJP1eZ4Fb56BlYTvR9aabqcWfLwLGn54++NEMTmJIFrTFRC+
	TcTAKtwg0kgZpkil1OrlUojRtKBkQYpr7Gjv4zQYRWt/fRlDB4akD71pKgxPb+T9iI4U5SjZYzy
	PwBfbz7xEQNNLNNX9qo68Zmb1pYMQ4vlRhPlP1q8zEy5P9rKXYBEufIOMCNqIbLBNJYPj0oLFs1
	2PIyjTPxRqjyJ6fN/tUf70XN8c/MmFJ6PhbZLewATgL/tkXYxxNR3YbpuhaZogDceafWaRdZep/
	PitzkWYg+FwGKw2QNiIF/y4sRRpI1NpnUdBr7as5FBHyPG0GNuUF3KwLD9xJW/FL8nR9QcNjoUi
	+JGSotG2Ls26LXsU9LFPzm97RNHxNjRKsIB54ZFTmJfrKUtuJ3FfPxY0YiNkv8EO4oZU4Odd4Fj
	0Jj+U0NzLy7BXQIBs1nZR0VZAyxX5i3Vm36wYsLyV6Sl46vstE5dB7X0Tbq7a/yLShp4fLyW/AH
	Q==
X-Received: by 2002:a05:6000:40dc:b0:48d:f5ba:fb02 with SMTP id
 ffacd0b85a97d-48e385cb0cemr4762440f8f.49.1792776273056; Fri, 23 Oct 2026
 10:24:33 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
In-Reply-To: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 10:24:20 -0700
X-Gm-Features: AclHuK90U31JbVkPlQ2JhTCxhfOcbXN8AAPY12NmqFk3jj-EPn44-86VqmxU4HI
Message-ID: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D31F9120006
X-Stat-Signature: n56wh4ut8di47pc4e13y97ojpuh7ah1f
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792776274-769921
X-HE-Meta: U2FsdGVkX19AoVKWt6ONhiiHkvURREF7jjryAuJXsydQFGaOK01OATit6tNEV0lP6cYZUZdaB0qlxuXFxfPf9FUW+KOjnE2mxKp2VQMVHgQXfkWlPmn6whKSl4ujcZZnKj5nPBe722ue8FhAaNmoIK0XLnTiivYQX6usJJsIsqR0yP0qh6sAQVBx+3MjCJij4b4EcyNnvuw24GxZGG4J4jEUdPBOg/28XIflJ6oJ3oYwsjIUYZovcsrzaOi8G/Es2DS5QW5w0YMJdttMdvdtq5S0UqsVHbiv3CIDxad4fEF+qTcnKkTIAHEcYESz7QMJnc4UXUWz9+s/DdAgcNMfr83toGSBRu/Ng5TCOF6ySIXqn7pbDNuy/fjvAeG+TU2fgPsNEf1rXIx2SFqbVEGJjhghJ3wyTQj4d4Y6ROoxZ6AzPnXbY0jouQQZeWaaryIPmli+u3qohhPBY9a9EeWcJn6UJ4p4gP37U1WHmVMEtSSuCHcjvPKOtmHg353tlxrcocDemw+ZhSND2V8VowN8+BEbcbrIwc/DGOJWx5mfnm42b2ZkoWNiBa6HG++/3Wzog+pIg6TsuH1FJrmD91iz/9jOPtougGR4QZRsJ0OHnriskYTi6uQREPOw7XTuBCwPu2AHWf3PjQQkPXIlNCVQ+sE1IR63xZ4bpK4ZnnqKRu0McJ5BYCAHtPHzby6N+XnoMsWxis8DYFD+GijVIitTaR/uVkT/Sa0hM1OyFjlyckSdxIClj/269ZOAuHbyVMg5zLmEZxyjRDH7UEjIEiKUq8qm+xGv7oV5lhkuppzwOywPOMbOSKGO+c0zb6/Y4xhRiQ8CQD0+Y/NJfsgM7sB+BWVUtPp+C5Y43LN31EOOfJxliQPmfdWMm485pmCSaOOSIh7v5ym5SUBZfNWXEjEdkvoYjNUykjgvDHR2k1pTJsHK6uhO4XpS93M63MfSklEP/NXahLNoXqwN5GslGvh
 qxrKrpc7
 0y4JfA9sT322UfzeEwIJYfiAHJLj/KXRTn3z6qRPZwyT8FzdlBpgpdjLDzJZbykMGZZVkeg7+19f/FEVKL6QvE9BcAb3TnZedmtIawTMhaxMtA2dgdwFiIwukxbW814jN0DUlgzEGXyzXG3r4PEysf9i5jhyyr79piUtiRtoG7VQvCOcJI3yittiffI6vTZiACIfYOrhOSjuTvG9/ec5i09QtjHdOAKBtj9CtXImSFdOtCf+52nZpc48lKhP8/SJDaEAA+851fsth6nBBLIHIxQl1IcGAWIjsQS0TnM4W+McQV/3bJ7eviSkTIlB4bDqhkCOArtdGzqJAC4gqRjm/q8FE5HAD+JZOhC+oAbTNYW6MQuNbqpol1KkWzTtllwOLPTSSNn3ArSnyLWM/VoX7GVjEYyVMJm+fJBGiqSXFMhytc1dFYxs86mt+AiXNFopMWuHeIeYpgb3JCjW9tyGPlplrp32uEw4LRldeccUAqvBW8FBZ8rWsovwHHPUa7n39hhAudX3HXRa0jIS4CtZgeVRB/Nz6lTsaepYa7yEnDCsQZQcxAFu5JDhYa3IIOGz7ed7I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/19/26 14:24, Nhat Pham wrote:
> >
> > I'm traveling this week, so it's a bit tricky. I cannot make Thursday m=
orning.
> >
> > On Thursday I'll be traveling back from Cambridge. But hang on.
> >
> > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30a=
m - 2am.
> >
> > I could just naturally join that day.
> >
> > So one day later would work for me.
>
> Would that be too rushed for you? :)
>
> For everyone's convenience, this would be the time slot:
>
> PDT: Thu Oct 22, 5:00 PM
> EDT: Thu Oct 22, 8:00 PM
> Europe: Fri Oct 23, 2:00 AM
> China: Fri Oct 23, 8:00 AM

Hi folks,

Thanks everyone for attending - I didn=E2=80=99t realize swap was so well l=
oved :)

I took the liberty to summarize the points being discussed - please let
me know if I missed anything or misunderstood any points:

* Swapfile sizing: Kernel kept swap slots after read faults to save IOs
if these pages are swapped out again, and thus needed swap occupancy
(and hence static size) for a heuristics to trigger reclaim of these
swap-cache-only swap slots. However, this is not useful for fast
compressed backend, and zswap invalidates its compressed copy on page
fault anyway. Vswap does not need this heuristics because it just
frees up the swap slots eagerly on page fault for in-memory backends,
and rely on the existing slot reclaimer for physical swap backends.

* Logical footprint limits and charging: cgroupv1 allows logical memory
footprint limits (unique page tables). Cgroupv2 controls physical
memory and swap resources separately instead. While virtual swap
entries continue to count towards memsw, cgroupv2 counts only the
actual resources they consumed - post-compression size in
memory.current, and nothing in memory.swap.current. While cgroupv1
continues to be supported in its current state, a cgroupv2 transition
will present a problem for memsw users that still needs to be worked
out in some form of overcommit control.

* Swapoff: this was brought up as a request, but we ran out of time
before we could discuss the motivations and use cases behind them.
Folks interested, could you explain as a follow-up?

* VM_SPARSE v.s xarray: no performance difference between vswap v.s
part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a wi=
n
for xswap, according to Baoquan=E2=80=99s testing.

Let us keep the communication line open and coordinate on the next
steps.

