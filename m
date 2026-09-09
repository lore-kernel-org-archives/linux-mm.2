Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FE9C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7BA6B008A; Wed,  9 Sep 2026 13:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FF46B0093; Wed,  9 Sep 2026 13:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF84D6B0098; Wed,  9 Sep 2026 13:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA16C6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:47:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0E2E1402C4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:47:17 +0000 (UTC)
X-FDA: 85194955314.29.545B952
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAB0480003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:47:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A87fhsl3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788976035;
	b=kgQfA2fgbZ8vnGOcM1WOmpqAcqEPngDmLe4unjQFQDq0XcQl9+iYce+TfHIfBxJoTe1oek
	8f4sX8bFGU3A5aDEtJOOFGH+b2lZSIK5Vnz29GiNkpdUBS3b7mmtXVOOxd/zD80TRigg+Y
	H0uVBM7ZbCuHQ0o+vHeFuV2OIy6szgU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A87fhsl3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
	b=CH1BjxVslI6ofqLnqFN9MWIkh6RERddT6/K8XI1Toe/KofjqDRmMRokvYBGS749tsnJOpg
	djhU2EfrltIH6ygtNMR5KtYY6NBqJsKbGKC2bhN86t+VzHo2AwG8dzW+WC3DlWde/I2gYA
	JyZEaUopprzRmUZ4tuz95OoNVvGmuLI=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48586861639so52452f8f.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788976034; cv=none;
        d=google.com; s=arc-20260327;
        b=lp41uMwwOt+D1u9vq+FNpz3svi2RqAxHLoAGYIf7NyWkaVl9u2+DjW4N5yz0D1qnk1
         QzyISVXG10n9sM2xbf/l7Z+VD61eHlbI0AwL7TSBieXApWuF6eiBPX5AhbdttUXEiTom
         ZH8n1qPXnkMQ3qcTLevjMMeNdPugvIdakS2PKDyipDiXs13T03xLjWD2tcmdJgYATg7/
         r5CS1XII+xnj+umWKP5YqtA/r+AmC9bshWZOPZbVyW7Jl2byzrIb+3fK88T8Qo45n4CE
         2dHlvY4Ho58vEYojXDpwU0d+4bt+rS2NDfdjkzmoo93jBuHImSvHN7pTdO86+WIa4hdO
         GNkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        fh=Mtp214gM6JLO7+jL8vzbHCCMB+AwenrU5fn9kYJjsMk=;
        b=DvvcPp4HjuJq1j0sTJ4sEnRVFmHlgfdHprEsx7kz0c8XT9KqeEeciE40PEap7ovROk
         /eajHfn/U8D68+YZxSkUHc6ChIkYqx77/SBht9LSCQeYsJSrE4VYuqCyGVqDdCey/eG5
         Ww1gS+rh37pMPB3RgwsnVCYKQ9aw0vzWx5JTzzJn5Ly7+PR7Y1+yhA3fhzexYQG5SoWi
         AghXzgPoMHLU1gAPYnmypSHqKzTVPLg9xDzF3HshdOxkqxV6jg+0pcHH1dp4UzUCUI6y
         Pj5h8Vurt7qDNP5qNAfs12WQ3nVB3VRQbyIZkHMC8E8yU17AXf1svYNBJIwhzzJscl8k
         4Qxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788976034; x=1789580834; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        b=A87fhsl30dHnzfZ4sBa0Hi465dY7UsSPvGoO/AxGuCGBbXk+YmOG2Dq+oj4c4vB+p9
         /VH6uIHbgr3OsIIxx4COQWVEHCwrTyUQ2gOSrVChmJxAq+sHK9YcTiQ8oRG1feG2H+uv
         L8p9B34pcipbDqqYG3ua9jvpxTmFhFNRn6PtwJbLddLGndQO4Y/Ub0objoX2JdZilJyu
         Hg2wsiT3SputzHyOz+yBvgB/yLGuBZ7hdSOnsgmEBEHQuqkeGkssajNAxA9I3Wy8LReo
         W3D4ASuRt+0Blrq2O6GxVr74D7alLN5T2L9Ol6wbtforIaplKlsNqSTiaTWlkSi3Gn7d
         Iznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976034; x=1789580834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        b=l7ZKHI36/QI7rRHAZ2TdftCeJMNE+Vs6gE799qqHk8wNQkR8bziMHYFaYMNW+BG7EW
         Hn5j+3SyZR1v5K6R+/M1YvCu5PmPjhsoYaaKwzByz30Dflaoj8H/cRU/uBKvpPxM7wbH
         82AlP3I7irVZpHoTVYXoKjZh8xiFnyiCAC/MXHLLtwITLVutEwTbfMRiBR4iJdYOPP66
         7vFNMikzs3HTXnga1o9BfqWdsvEU6B7BsQilBe8CkTcJueFlxJCBnHluSValnJz9nveX
         Cvrez7kmPd+Di2z9gD8ApIdFfdTSEGucCG67hClnaq/AkmPNRQS9URFwaI5gXZYVxKiy
         76Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxGtU0+QAAw0QvGjD4GXk4DU1TRS/UrwvTW/iII4zbam7BKj4qPcmP48KErhanCL0HtgMm31xhSaA==@kvack.org
X-Gm-Message-State: AFuF++nq/ZJ/W+roBYZAXtB4Oqg2aESUAsNSMt6fSbESPshhc5hpYc+/
	rcLVpQtmYJbu9hqKYfOcIdLfb9NvdWRxmWtP0ZdCj5aoCjrKgccYw11k0g5rWXc47SJg2OB+EJH
	/e5Gctg8MkqvhFLC7d2Oql5YdchI8P4w=
X-Gm-Gg: AYBFou2lDdW7XvpNEqG3WirLMERIrWykemFqAFIKonO4NA0YqqdArG2ii/a1Q5p/AAZ
	eWkeEt719DCmlg2LYYiIEAH+97kYWeLrOOCEDRVSeLK1PZyh70KYLE2b5H6mVTfUeHhZNV3RSut
	jaF9x/U4nrnIwkICMsN3h4QxRDpxdMeibGvcYZbuFgq68y9mKhxb/mEdksjCzPDwcmLDH5LGhec
	qo9FdbI6Fn9RZS+VRDPhop/UB0+lBnj2e34D6UYKMHRkGrCqsoOYAJeBWkmf+3UdH16rj11apoB
	ponpYxCD4wGH06IqMsJbFoooQomHlfmJJRnetm8u6bfkP0HM+u1FJtxjr+5acrDShgUuCreCAd3
	6yQcIZMMuzPw=
X-Received: by 2002:a05:6000:470f:b0:484:4779:bcd6 with SMTP id
 ffacd0b85a97d-486e0f6c735mr589913f8f.15.1788976033902; Wed, 09 Sep 2026
 10:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
In-Reply-To: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 10:47:02 -0700
X-Gm-Features: AcwNN1UaR9pHD2h6-LXbXZDQ7w46sDfAFt5QkIQi55ban0K1e2MIGYElY-fudaA
Message-ID: <CAKEwX=NYoMH8pTKeCvA=XHFmmNVMeDz3mxbhp5q6-PxSTJ5wOg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAB0480003
X-Stat-Signature: hnspxwdn1rnqgwj3pfyx43m9uzaxhnn9
X-HE-Tag: 1788976035-518833
X-HE-Meta: U2FsdGVkX18Mq43XDuPec6DUpT+v450QBtRGSVAyKUEVH5UX8wjGeJ9rZWFbCCboIKJKQzKMve6+jdUiyNSBwJbLvYMKo0BJYe3eBalE0+oiPisAc4P+7tR4he7ChJA1LNbzLL0idaNdm1mb5oea0pN1G0tX+l6xecxcoQwT44wWkzSXgyvZlXIV+ApQfn7WhundnmCWoCl2O4zeHu/htZLzfJtA9+GiXqXVCGgIeBHDgZRJ/3VMUPCmBE915bdvjl+vIYNJotVvdqfqBSvFKPldcuc0kBIydXV0pNNGlHgFtFWmpyasC6lFcZ18hKbbC1z9tFSzr3GkDiemKHlzsumssvhued/rfb5xlUimjZdK3PtibLJfZTREFbI26bSlG9BR11SzLa0b+I3ZYKY04R44rrl9YntUTfhvZpeinmkwfFuE0HekbsUNk+YbiRzjZRcHAnPJTRCIoJS2afPaeU5aN1Rvq5UdRIrHmttMLqy2+JnY1MMFLGB0bjhTt87F866mlv5ZdBcrqTZxGCpJF/WCZwFMUg/XTMaPvceW7mZUmdKjpF5Ry9sFT/rtWVh5shFT+kImxtaz7s40FdPZW4pBg9M3xHw+C5aO3cJ3+BMc1gBwDT5lylWTJ26vKnb0JYVEc/+5V1gSN7DssPHEIaH3RHJnd6m+iDfF8B8mSx0qBuP8guSxwK84E/VihkAx3RE4I/u3ZnTLah0WqMzOYaB7voISDwrVB+2Mt5AQ1cUbjNAjM8ybYWw7KM3LzuuvPPVPtyyFmN5B95iMUVbhJPML6gJ718Y306XcV8G4o9bYiOCgOEc6/Tdj5foLIGe4ejUzKjJOxWmdrCdNCk+1a0vk/JksmYlfYmxTTusdHccyn2AU2A52HK9dRD9oWCaAAoJEA6T8AHHg58GejKrep5g/7jydjkqVn+USkfUTyyggg0ZPcJ2fGG2aqPgzHTD79HpsrZL6mnM8zuqlGIQ
 vXPwdrtr
 TlamB91nN6tQOLD2Y/AUJA4BpyPbpj2sbjEtbeAxbqJJ5ddjBK5/sVCxk1jpo//zQEzeWxvxIBOswEWtw+uJqZFj0JFfKolydhUFxTVXES38u84Wk322+Rh2CdR5sQhv/V1j3E5s9e9Hw50daQg0yQ0k/3AVAXZ4p1H1DwV63BGPnziLn+Nt0qaEclQ8IDONsSqT0wHKswFBSXdA5ejzWTxLYBPfTSgmkevoJqBN2i1y1tZDOzke2+kYBbBAoIBBBzU+0oYSRSjlGMPOjbPhZXoJYlCEAtn5iWsmP5AKBXbtjKkfM4HXCF5JkxVAhsqnPuqynI/SXB39j+TvxyG7CQO05reLGPAITuaxFnCgrQ8z+VOQ99knKv0z2M+U6teI7jZSzcY4Et+zr15vSe8j/Ar3eRN5fkFUdNdym8DgqGAxZShg3JKII4a07EkPRUKgbYN5yAbPLjXW24rp3rWq0y06PFGrVnuUNlCqg4799WIFmaKjb0ihBqWvvzDwC4oYv9MWxj1VygMrGBqD1rFHK1JDoLkLbHWzxSEwIDeiRJBwqvLzzTTYNpv6J21i//wbX7g8n3aMJCssYfiIhR9Mi8RuLVZIPJXnhtXdI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 9:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > Where I've ended up is that unbounded growth is a real concern. On a
> > > host with no memcg limit (root cgroup, and most desktop and embedded
> > > setups), an unlimited pool means usage can keep growing, with no
> > > admin visible ceiling at all. I'm not attached to xswap's percent of =
RAM
> > > knob specifically, but I do think some kind of bound makes sense.
> >
> > Swap space is just process virtual address space, no?
> >
> > Swap entries already have one or more page table entries pointing to
> > them, which in turn are managed by trees of vm_area_structs. That
> > means rlimits apply, overcommit protection applies, and OOM killer
> > attribution works as well (oom_badness()).
>
> I tested this theory. I spinned up a process, and let it spam 0-filled
> memory + swap these pages out continually.
>
> As you predicted, oom-killer picked it up eventually. The host was
> (and is) intact otherwise :)

Oh digging through dmesg - I did find something quite interesting:

[12462.749663] ------------[ cut here ]------------
[12462.749670] refcount_t: saturated; leaking memory.
[12462.749817] ------------[ cut here ]------------
[12462.759267] WARNING: lib/refcount.c:19 at
refcount_warn_saturate+0x1b/0x70, CPU#17: zeroleak/76075
[12462.759276] refcount_t: underflow; use-after-free.
[12462.777208] Modules linked in: sch_fq(E) tcp_diag(E) inet_diag(E)
act_gact(E) cls_bpf(E)
[12462.786790] WARNING: lib/refcount.c:28 at
refcount_warn_saturate+0x42/0x70, CPU#25: dmesg/76074

Seems like it managed to oversaturate mem_cgroup_private_id:

struct mem_cgroup_private_id {
    int id;
    refcount_t ref;
};

We should either fix mem_cgroup_private_id to use 64-bit refererence
count here, or hardcap the swap usage to below the saturation point of
refcount_t ref. I'm leaning towards the former in the long run.

This is sort of an argument for handling all of this transparently
though - expecting users to know what the cap should be based on a
myriad of architectural and arcane implementation details (which can
change arbitrarily in the future) is very unreasonable.

