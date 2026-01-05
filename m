Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E8ACD0405
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B975E6B008A; Mon,  5 Jan 2026 16:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D486B0093; Mon,  5 Jan 2026 16:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50AB6B0095; Mon,  5 Jan 2026 16:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95C466B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:13:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F76316028E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:13:03 +0000 (UTC)
X-FDA: 84299160246.28.1396D8C
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43C4780004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:13:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zk0JUzDC;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767647581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wy0rfqLocl5LRnKZvhpmvFGN8u5rpxOR4ei0DdvG6rU=;
	b=PmrZFGLAbItUmt2udNTDncB6eDhn+Phukh+LjoI+aHrckkpTLZFo3P4gpGR7upeWTlQL1F
	0Hi2OjWjIXfBIf+TbXGH17/3JMwMFwVDPptot+hPeAyLSQm2OLDurYsSex8nYZx+Wr09LF
	g51N5vQYmtRFepbV0mEq7xdprq9OmMs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zk0JUzDC;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767647581; a=rsa-sha256;
	cv=pass;
	b=4hZVkEy9CR/Wbh5bpTKvyzghAQyG2W4+kS7Nilt8jdtSJZwibmR8v6QRPcqiYGzkjHJCq3
	ex/aTFnsyDa54VCupbt5EyU/gGVvxEGUeVmQcIPltaL3E8It7dVZBmqSEVEGesOsvfIxoh
	1kRKFdLfRn3LStiCZ6kPcEPp3GoWt0E=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso111521cf.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:13:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767647580; cv=none;
        d=google.com; s=arc-20240605;
        b=atDN0Eb35p18aQ9q3o41JTr8+3vJqOOMUwc57+2gxTbPE/1onLrviifRUS7QXD68L0
         w3PhdKIPKjnYTKGZykbNxqz6CENQcvNZmi8vhfKkYq/AStFkXlLY6M0tMAuc5v3gCagY
         Y/ztWHQofuC7shmk7ygiu4dM//ov1Sf9ejcHnPeua0pCt6YJP2yoJWauDEZOU6rqqlhl
         LG1yQmpudhSrwvwaKkd5C8jJ4PQOUVB8Xxw1F4bqK34Q28+IFp8Y55HYcGpnUd6iI+Oj
         3lOWqcGDr7mp4sSuEvoZlgXIMRAwenQ57pt60lT1jVO2YcL8LbbcJq7SzVc/wEv9T8dN
         JFmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wy0rfqLocl5LRnKZvhpmvFGN8u5rpxOR4ei0DdvG6rU=;
        fh=/8WrZpPfsRiQ8myO8OOFzswv0oxR9UJoXETkwbnt+pg=;
        b=Enc23eEenK2dAa1MoYAdlIjsocxIGdPkV5bjLngsVaFvlfh3SUn0dalcwJ8S0M8eSl
         VmXj9vPJDRpeWAfOsRFe/6I4SFNDG3jgPF87lBAZHv8Bx965jFzNizyAPid7zqeUePVX
         rt5jpJ0t69+xWtMY2LHbdvESdfHntl1XuTMJ1ORgd1d+scpPMz7E4jypGo3Nrt3+s/Kd
         zqeZsTt1NeKj9cnmD+W9BC1X1VjAEwpLR2IWRgiolhU5ZNatrf89CHgIHo2Qk8HUCCKm
         i+l5N2ORgbOT8nN8SWiINfbjei7J3tq9qAH6Sm3/UxpVhnh6BtAOZz01VwtLGbfKM6Cu
         XPKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767647580; x=1768252380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wy0rfqLocl5LRnKZvhpmvFGN8u5rpxOR4ei0DdvG6rU=;
        b=zk0JUzDCAmn7QlHU0jmPNxEpmrnDg0PLJgQ09ocGHtAuI8tUFvJaBiIoBC2C7xW4aM
         ii3iYJCqsi6a280Q39KwWFKCk+wmTqS7/rm0FxzLlgq0H1kXXZZfDxDHC3zs2lpyXO7J
         4EvbTmvQxc3sPawNFc0dKSZo6xRFTvzSEEPoADTVrvi5KD4Vwl0bKW7mYncbYBoMEJud
         EANpO99ocZSA+wm4omrfNF+7xqZMpKWBuTHv5DsdldWpSDdiCyCz5H+OyW/1VaZrBJvq
         OLiQHf71fUQJUvUG76/l/tWSzAYnFUd8IzeoKOiLaeb8NJHAmMjHtoDI6UyL/TRKzhW2
         dPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647580; x=1768252380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wy0rfqLocl5LRnKZvhpmvFGN8u5rpxOR4ei0DdvG6rU=;
        b=irJqTduTEyJ+RIkw8CPTPaKgXi4TTc+e9ttnaPWegM1yeLiY2u13foxNB285bMAoBa
         SqQZ4dTWj9GKKhAr/OScyug4Lj4tqi1ft6Rs8Mgeb6fZvzPJOOuNegOvtrpG2Lml+lue
         /Nj7NNBhEKwje4FPECSeQKmO0YVR1PEPkoD2n8kh2F9Kxm2TMpXvhFb0FHfqEeYalzDo
         p1ZsZZE24Fm7ivzWGQ6oIA+Zj9Snv1TxDC18Z06COKQe6MimT+p98gbW4c/TR9xRnfSm
         jgRCaPz/WpMu6MOaWP0F1rL9A6kpG/qGGZb10UEqT4Uv/XF9fLSaWElnPEu0WG2t9uQZ
         tHkA==
X-Forwarded-Encrypted: i=1; AJvYcCUUgnW+zZNOvJpbv0vsqZfdeauuhCd+qtmFMMME/wHgzfyLgRwJ2rcPjrGoKmM8he0rAzsiKouPKQ==@kvack.org
X-Gm-Message-State: AOJu0YxBna+kKNGea4nPkBv8k/embklQ6NI9PtnnnDPtJRlOjDWSHmjg
	UnnRAh3AJAYlSVlZaNy3kIiDWXaU9ovEoBI5Ow6sy6hvBDb6pPa+u8YUhRokMRUSQzXZg+DGbQl
	krCze+CBZ8S1LwOG4umTHVv4SJN1kRQqrIo5o8ToX
X-Gm-Gg: AY/fxX4GooTXTb3ZrGOTCVd0NeWd31ifwVamESXY/GGgO31Bj3OHRFkpL+eTf5IhlpI
	mr1449mzT2U+ZzSxmbCGKbodUeffO+SwnNNOcA+kODCtgKJbo3ZAOa+zJXrsyXdiL27dxYgEdmI
	8OCIHeCri5uBhmJecssg4MDAaglex9omDjna2NsvqzdUkP2reX68W/JJLjlP6dRoAuTQAC1NPK5
	4/9TGrjOdZ7g8yBmXIiib/0xjYCItqTu45QWbfjJ7S69U4JuNM/mgUiaSwmxLmP+9F0ew==
X-Google-Smtp-Source: AGHT+IGzpibo1ZScse5sPB4Ed7lcX49Lp0eWmi1ZbnX4rr0YAKplACuQ2HG6NjdvcjGIfYZC8HrD0zRH9xHZLjyLFI0=
X-Received: by 2002:a05:622a:40f:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4ffa855602dmr2181721cf.8.1767647579825; Mon, 05 Jan 2026
 13:12:59 -0800 (PST)
MIME-Version: 1.0
References: <20251216064349.74501-1-00107082@163.com>
In-Reply-To: <20251216064349.74501-1-00107082@163.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 5 Jan 2026 13:12:48 -0800
X-Gm-Features: AQt7F2q1bDLCLPWwFGVXixMvXyHparDTjWBNpZuH9l8Q7bO_vsde5bRVZW-fCXE
Message-ID: <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag along callchain
To: David Wang <00107082@163.com>
Cc: kent.overstreet@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	pasha.tatashin@soleen.com, souravpanda@google.com, vbabka@suse.cz, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: 1o9d97135qyxzxaza15wn9u8uffcjfzx
X-Rspam-User: 
X-Rspamd-Queue-Id: 43C4780004
X-HE-Tag: 1767647581-428097
X-HE-Meta: U2FsdGVkX1+w8rKit6l7VBkmGToliTSfo9tWBjrdvAYZ0xgoDE8+xd041+e26Zu/LmQykTE/HAjdpNUcE4omfkFqlNFex3aCxQN/hREV4Pavyi92yLq/GeLzzupu8DyZ2RGN8DcjKLKlng6y7ABB7/6i+SHmIK4jr5cLH6/Gi8qAldEqdFsrVqkXZtPHJ+t+oMcYiaBnpwPf3SkhFjdOYMZTbhx8a2+JWjJlhA/8UyCgRvT78uDNdy9ccuYzqcP/aJQYYlJ7O0N+B1dCh3NIL162rZ1zBXORflbtTok24eylWhGOjcyOl9I5oqL67w4d7kTkiCS1QYzkUCrtGkw/k04V+OHQKMNdt1DDduRZzdfVsLytOh1VMXOhRWfuUzhvSGWJ//rlb6I4O2s1Styx6q4wfIK0hsTLyWnJH1YRFriih8r5SLaVJWTWm3XdwMDeTxjU30cdFXFMuHNk6VvWtfSJzOWl3S7pE8R8IYgwXLqjm6bSuxu+SeBXyTroAG7RYgMTy++ugd7qJ9InZTUeqmuOeLou0E1OxrsSC3aNzXpA9zlMY+GgPjI826X6RUW551kgLuLb4s/6zNXfXpkZ0Mza56wLgIqsbpgWIXdCOtZqU3NLLEE+zOFe950+UUecfbbcOndVnqivDajmfDKS6mBxtJxRuiWiKd7fpR0iIMPjwLjteViYENZZQEPuovTV9syDorgXWo3Sq/mDOh3ml6s7oEsFjzKRCUqnCPGzps0pvpupMMVOrkMTr7UntSjTwlp/Sx8jFRLONAmWoKjKpvJgTMDy7G2WTEPFaw3XfXkgwW+Tm05zjupf1/6jCQ5bEYSljk41IzG4tRoDg1gJt9jY39e8S08dKdi03BeunciBHCUBCdD0ylJ0POjUhJOuixTmjd9Vw6ZDJyGuqtGRsxc1E5l4hExmHyf/tasXvlyDyqMMpW7jDs/HF7T1DKs2NvpqUKZpepGTWWS2WZG
 j0+CUxXB
 qULBv6gMXvdYbx/3xlV/4BIbC7cgDQeJAWa3t+VDdmL1Q1CJadTqepQ/Hawkt6bI9jX188MKQS5fxy1BwxGA45krp3Rj5TxSsS2Ookr+7Yy5gNtgwqCvAS4CbbOkSo1dvTZShR0UKmtuzR7BjeL2VMUl8nRrFisUaHBOK0Cphr5W5WyBuYMyKpx7JoUNyta1wuYuSdcuu/mTxc/BfUXjZM4Xtla31bslgn5YV7/bFknOXvtHATu8R5yTBkqZUfFUb9BMbxaz84XpNEF9P8+MPt1fC1UyoGbVsY0iXEOe8ZJzIC5BufcBQSwhwMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:44=E2=80=AFPM David Wang <00107082@163.com> wrot=
e:
>
> When tracking memory allocation for some specific function,
> picking the first codetag is more desired, because there
> is no need to track down all allocation sites in the call
> graph and change them to _noprof version, which is quite
> inflexible when the call graph is complex.
>
> For example, consider a simple graph:
>
> A ---> B ---> C =3D=3D=3D> D
>        E ---> C
>
> =3D=3D=3D> means a call with codetag
> ---> means a call without codetag
>
> To profiling memory allocation for A, the call graph needs
> to be changed to
> A =3D=3D=3D> B ---> C ---> D
>        E =3D=3D=3D> C
> Three call sites needs to be changed.
>
> But if pick the first codetag, only one change is needed.
> A =3D=3D=3D> B ---> C =3D=3D=3D> D
>        E ---> C
>
> The drawback is some accounting for C is splited to A,
> making the number not accurate for C. (But the overall
> accounting is still the same.)
>
> This is useful when debug memory problems, not meant for
> production usage though.

Hi David,
Sorry for the delay. Do you have specific examples when allocation
needs to be accounted at the highest level?
Our usual approach is that we account allocation at the lowest
"allocator" level and if that allocator uses lowel level allocators it
should use _noprof versions so that allocation is still done at the
right level. I would like to keep that simple approach but if there
are cases when that's not enough, I would like to know more about them
before trying to address them.
Thanks,
Suren.

>
> Signed-off-by: David Wang <00107082@163.com>
> ---
>  include/linux/sched.h |  6 ++++++
>  lib/Kconfig.debug     | 12 ++++++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d395f2810fac..4a4f7000737e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2288,14 +2288,20 @@ extern void sched_set_stop_task(int cpu, struct t=
ask_struct *stop);
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  static __always_inline struct alloc_tag *alloc_tag_save(struct alloc_tag=
 *tag)
>  {
> +#ifdef CONFIG_MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
> +       if (current->alloc_tag)
> +               return current->alloc_tag;
> +#endif
>         swap(current->alloc_tag, tag);
>         return tag;
>  }
>
>  static __always_inline void alloc_tag_restore(struct alloc_tag *tag, str=
uct alloc_tag *old)
>  {
> +#ifndef CONFIG_MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>         WARN(current->alloc_tag !=3D tag, "current->alloc_tag was changed=
:\n");
> +#endif
>  #endif
>         current->alloc_tag =3D old;
>  }
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ba36939fda79..6e6f3a12033a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1038,6 +1038,18 @@ config MEM_ALLOC_PROFILING_DEBUG
>           Adds warnings with helpful error messages for memory allocation
>           profiling.
>
> +config MEM_ALLOC_PROFILING_PICK_FIRST_CODETAG
> +       bool "Use the first tag along the call chain"
> +       default n
> +       depends on MEM_ALLOC_PROFILING
> +       select MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
> +       help
> +         Make memory allocation profiling store counters to the first
> +         codetag along the call chain. This help profiling memory alloca=
tion
> +         for specific function by simply adding codetag to the function,
> +         without clearup all the codetag down the callchain.
> +         It is used for debug purpose.
> +
>  source "lib/Kconfig.kasan"
>  source "lib/Kconfig.kfence"
>  source "lib/Kconfig.kmsan"
> --
> 2.47.3
>

