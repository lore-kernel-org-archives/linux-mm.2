Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF43ECD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E7F6B03F6; Tue,  2 Jun 2026 04:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476B06B03FF; Tue,  2 Jun 2026 04:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3436B0401; Tue,  2 Jun 2026 04:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6B46B03F6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:05:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2CAC1C2192
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:05:11 +0000 (UTC)
X-FDA: 84834237222.02.B1447FC
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id B595F80015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:05:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZfKbkYjH;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780387510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+73prwKKyusKu0UeoZTCHGTOBel/fBfTSc0ORj8rmnQ=;
	b=MzlilsxU/uGZN+nsXthQma9heCg9adtvrN8jpM/CjuPIz09e2iynKtGRt/Z0dtBLDh4LIA
	wFFEVKNd/RkVUNGlK6+gs98ih3AuAaih/zRyQBSzUJo7BXbM76Tyh8B3/T2Y7XqnEx5FbX
	g/k6p/CYJ8WrdmLXNe6n21QqKleMb7s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZfKbkYjH;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780387510;
	b=7rsJ6k1arv9LQ1AbgDMf8/0s5tAesnBHBwByAvrIzsxJHR0UIaxo158qQPn0xBrj1GOCca
	F0FICmyJkzsG99fc6aobOaSUo61L5hrN7ci6UUSf/7648xr4yYo37S2ZjeCiqMYBeOf5SB
	foxnYRPnTqrZs/CPJiojy5UbLvGXeq0=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490a765d410so24754575e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780387508; x=1780992308; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+73prwKKyusKu0UeoZTCHGTOBel/fBfTSc0ORj8rmnQ=;
        b=ZfKbkYjHtdgiikl6T7x+QJIkTH8ijmHmNEkiMlb1x6xf+X54jCFVueic1/N+bzCUSz
         iHEzFdcBVBUOGuh5UeWI1IcqNBxpk+cliXTrVVqFyVKc+lA1zR6wSiyNutheAqqnmLbX
         +aKmSPCrifU1qYyqu1MpqETwmcdubc0mknhRow4KXEZKKWWmcIFMaR7+Ct7CmOxYTbWH
         Pm14eFTRwb7dLyrdYqDDJdDVw/+db9sV8I0esuwgJnV4YlCMpf549iaY/OkiKzkt6XvO
         hmMXPBrhXK6PVlLiH+uoEuTf2NJVHVp/Srva7C589pNLkNOuWZEz7tXlZGng44dkLYeF
         YllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780387508; x=1780992308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+73prwKKyusKu0UeoZTCHGTOBel/fBfTSc0ORj8rmnQ=;
        b=E3oZSvBYfHsSnem7TBcBU1KMfhvokHiJi9Zj3DjtA04MLrz/0F2IThrdTiuFUicHVd
         Jc2z+FdMeucyTUCJbCSm8Dw6n4XveRdf7L07stL8zLwY5ekOBfgdh23WP+HZyWb9nAbv
         YORAu/VLTbZRrNjMV1FBtoxaJ+WJEOHhe8ctu38JNkMMb7C1LhRzPx3GaTdKJJgJ/LAf
         ja51i5MHgfEnYE65+VmL/SLBhUIr5ZKi31JS1jp0giTNiykW6+pAbECpuc/O8wi8qaFf
         pnqFDoyW6+KUr561lTdYqaa08rL8mpaWqYQnZybeZMxDAKAiToJSH+D9x+pxxHz9wVsg
         GY+Q==
X-Forwarded-Encrypted: i=1; AFNElJ9tVEfUQmqCm22/gaadkjfHBk85dorBFgGR4DSqGcBzsN/mYNo+pDrBTtLNZk24j60i0eozgLFLTg==@kvack.org
X-Gm-Message-State: AOJu0Yy8YYwlwX5DzHpsHNXsDVqAuTg1oreK5ur7tLrK9HeGvCc4DF9y
	N0vDGSSto947Aqc78IKnVv6O5sgxTcvucQepAad3MJLaY4C5U8uKkAHyBkfvoy9B4L8=
X-Gm-Gg: Acq92OGt0NFz71LDBSc2Aw3sAtSPmAh6p+kzp34s4XhQRiCJ51f/Z0yUs2pXVhgra1T
	7C7TFj/JIje9dvENd2SOivdr0tzWXH7bRQ3Zpvn8dQlm81av94o1NBfodm1ym+VO6S5hWgIJa+b
	ziBqfoJcnu61lmXvNunUmVrIEX/MTJ7ebr3EPFQCUhSo7bAQQSmmW4eKIYCt8dutRWTu7+DvyfE
	/JHWxJf/wcAk5vbuOnMqKdzpRllhMYAddybkF+AzLbQ5fbIvPO1v9Ka8y3WLnmqpml+SwS94QWx
	TacphP8JBt4Gabpi2IGz04llEl77bi6AAidquH8tqHzdJfmKTsWAM9oB7qqoxquFFE/JqutcpKP
	kaQQDrQHjGtdfc720R/dpHg5ElYNlBWPDvD5poayWPzovZo02g8ozPY3ZAD6+bPulOmFiwom+fB
	m+O4FFB6iWiGMfOLw8/Ak8IDc4HFz4NbeqjNMhTZuZ1yqtkzE=
X-Received: by 2002:a05:600c:8582:b0:488:b187:3c with SMTP id 5b1f17b1804b1-490a29399fcmr211068615e9.14.1780387508166;
        Tue, 02 Jun 2026 01:05:08 -0700 (PDT)
Received: from localhost (109-81-85-133.rct.o2.cz. [109.81.85.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef3587072sm32018554f8f.34.2026.06.02.01.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:05:07 -0700 (PDT)
Date: Tue, 2 Jun 2026 10:05:06 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, Dennis Zhou <dennis@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org,
	tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ah6OsuRRVLRBp3NV@tiehlicka>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
 <ahld5va1b9w8j659@pedro-suse.lan>
 <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
 <ahrm4x2ubbjs4An1@palisades.local>
 <e315d2a9-5069-4a8d-a0b5-7c0033ee46ba@linux.dev>
 <ah2pD468y1LCIe3G@tiehlicka>
 <7e913ba8-fa91-4916-a871-66de7c80cd29@linux.dev>
 <536ea40b-8501-4a81-84c7-de5f12f4eaf3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <536ea40b-8501-4a81-84c7-de5f12f4eaf3@kernel.org>
X-Rspamd-Queue-Id: B595F80015
X-Stat-Signature: sok6oiz98sozdkkxnewzxhkwomyinbpq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780387509-522911
X-HE-Meta: U2FsdGVkX1+YpR5gBWbDlUD06htpkEvtBXhO/SxGFhnD2pz2iG06FiX3nqcA//GRibkegQb0nt035PGHiQWVrfPaH0Q4Iq05Cp79NbyjnmtOxrHBzDh4FEr+1LNElPl94TF6zku6jn0bfGIpmqjp83oILjm0Ysu1tAYIFsXaFrGSJakgJGVNSyAQyvpTCRZKbcLQDtDR5a0GRmdO56Fte3OrKNgVl6ap3CIcUeqvPhU0tZfJeP5G5MpYxytANRbD5XmoPqeFuuHqvfEnIxc98pOozZOERk6zEKPi8z+1qPVof98wu5xRQhkjFKJDopSHXOWLIvGpy7W3U7kAomMrhX+8qvVkTYHHhz9upZWRo915Pu26k5vOP4Gih+DrE++Mvv8wNv04Gc97sTx9BQp6tV2JBef4vO4FfiREZjyRs3N9J6Ii3VvzMVyxx0ZWV+dblP98Xe+6WkcqzW+LNrR27DEMO8aMlSd3g/ZavgxWNHcUiIpNjAB/JBR0CUzt5B9hRfEksN1gzLXmhStwaVFWVy0kct33x+pp7o5uNa8ILeCiONunQIPmGgPRcNRcgjUylp1/uZnk3d8h97TuFjfeZb2MujbNvRJcRWRv8TC9w7vr3q6cJs3pFxEIPAh6v9bvHStCkk/fxrFjXSwBlu4k3q99bA3q1se1DqG1fKOM4zrcS6jpg9r9eOuMED1/fatnxSZOZWn5nFFprzTOO4q3lR2sEpYZQGTT8oioGyecr5bZ7fltez+D8/gnx3Mdr/wJlKfqTPzvUD6qQhxDGv2VO/nC3aVqFh3FfjXkfJjjEZ/jEBwnePK98DaDamSCRA+5bLi4XwjZtg/V1X8XR7VRl6iRaj82BMcArZ2+kyr6ua30d5Isnp1RgaqaxiFX1gLrJHdrMPnlPQdWXAqPEvp1heiVeLEXl0DX4J840AE5mKVIQP4EGs4/Jh3gBvL/3BFejO8HkDTj1yXIs+ejmyJ
 +Aa5ZOxC
 o5arjmDWaYroZB1910RiZgHCEdViVkPiuSwWyVi/GHWUVbvDVkMVToxcPtPa7MuXpyez1jGRllu/+4vUQzVyvSlnxzJpqoFSx2JPssK+GRMzd5Rau5Q43prgQRKMqfD+gMXJlRZqndpGSRhK4oMf4OZgo+eeA6ApZvCXDcpKOz4TyIRf08cTNNwMk2tVfFGKJuKw2JpxChfEwM7f332TxbbPsYEAEirBGQ6ExT4lJI+uLeDFb6rVzt4V2AZW8H8mQFaPSpdvt8Dqehqz0sQWQk3b07vhyABZZeuLUreqZ/Bl4dZbI3Yc69YEDkueF9ecrblHlP6viXVPv5//Bl46dw1oGpBsDbhVZplzmI6i+0NuG6ViakWJ8Cbl78SC2U1r+5Yhp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 02-06-26 09:16:24, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 05:03, Kaitao Cheng wrote:
> > 
> > 
> > 在 2026/6/1 23:45, Michal Hocko 写道:
> >> On Mon 01-06-26 10:27:53, Kaitao Cheng wrote:
> >>> However, if we revert 9a5b183941b, it seems that all of these issues would
> >>> be resolved. The only downside is that the failure rate of pcpu_alloc_noprof()
> >>> allocations may increase, which might be acceptable.
> >> 
> >> That has practical impact on some versions of iscsid which do not have
> >> PR_SET_IO_FLUSHER. And maybe some more so I would rather not revert
> >> based on a theoretical concerns which I believe is the case here. 
> >> 
> > 
> > Based on the previous discussion, I think we have a way to address most
> > of the concurrency issues around percpu allocation.
> > 
> > However, there still seems to be one remaining case that I do not yet
> > have a good way to solve. For example:
> > 
> > Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> > pcpu_alloc_mutex. Since the internal allocation is not constrained by
> > NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> > creating a dependency like:
> > 
> > pcpu_alloc_mutex -> fs_reclaim -> FS lock
> > At the same time, Thread B may already hold an FS lock and then call
> > pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> > pcpu_alloc_mutex and block, creating the reverse dependency:
> > 
> > FS lock -> pcpu_alloc_mutex
> > This can still form a potential deadlock cycle.
> > 
> > Does anyone have a good suggestion for how to handle this remaining case?
> > Or should we simply treat all GFP_KERNEL/GFP_NOFS allocation behavior in
> > pcpu_alloc_noprof() as GFP_NOIO?
> > 
> > If there is no clear solution for now, would it be acceptable to first
> > fix some of the issues introduced by commit 9a5b183941b, and leave this
> > remaining case as a pre-existing historical issue to be handled separately
> > later?
> 
> We don't need to solve any issues that are only theoretical and based on
> scenarios that nobody sane should be doing, i.e. Pedro already pointed out
> "As in no reclaim path should be insane^W daring enough to do pcpu allocations?"

Yes, but you do not need to do a pcp allocation from the reclaim path to
hit the deadlock. All you need is a NOFS pcp allocation - e.g. one done
from NOFS scope. Then you have fs lock <-> pcpu_alloc_mutex dependency
and a potential deadlock. It is hard to know whether we have any of
those in the kernel but I know for a fact (9a5b183941b) that there are
scoped NOIO allocations so I wouldn't be suprised if the same was the
case for NOFS. Not only that having NOIO is a weaker reclaim context.

> Elsewhere Pedro said "The proper way of fixing this would probably be to
> release pcpu_alloc_mutex (or not have it in the first place!) while you're
> allocating memory."

I do agree with this. Back then when I was dealing with the NOIO issue
I've tried to look at the lock and drop it but it was not really
straightforward. Maybe my lack of close understanding of the pcp
allocator was an obstacle there. So if there is a path forward like that
then it would certainly be the best.

-- 
Michal Hocko
SUSE Labs

