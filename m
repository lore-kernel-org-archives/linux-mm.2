Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B004CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85736B00AF; Tue, 19 Aug 2025 07:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E066B0119; Tue, 19 Aug 2025 07:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8886F6B011A; Tue, 19 Aug 2025 07:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 732816B00AF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:33:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2249358F91
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:33:52 +0000 (UTC)
X-FDA: 83793297504.08.C3AA091
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 40F6720007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:33:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZiKkdPpW;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603230; a=rsa-sha256;
	cv=none;
	b=geaDYmUjSlTaHaq3/J4vyMBFtjqHLQpLxnJGnJnLNnT+ucor9Vw/seDqKlClQBIJOGQ1T6
	eCyonrxewkTZAp8avXdpKYojdx4HqpGJBX5+AkgtXmhi66Z9wBSszY4PqT9YwGZhOB5Zfm
	BG+UxWFDZ30h+MPwq7bXw8ENALrIG+k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZiKkdPpW;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LE8KPxqLGvnqGcrCFM6DCzdu/oxztkK6aiFoXUkpgIY=;
	b=WONLdidA7VITPu1fHK8eCbhRrZ1B/+8m3iRTXs+y9lPh1F5fW6ROhlSgcranw+c9afNXMN
	yQ+i5vRQ1+aZ2kEYrf/jIdWuyCkAJve7IHskFoA2ciYLQBR8vQPGFpOJf0GXTb2RamYl27
	46lHVrn/Xy0jxi+yOJZAnw8XtKFVCfU=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e9f7c46edbso21733985a.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755603229; x=1756208029; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LE8KPxqLGvnqGcrCFM6DCzdu/oxztkK6aiFoXUkpgIY=;
        b=ZiKkdPpWshF+Xhyjw76oJtR+3CI9LoDgr9Nvop/isYAXi+zZQ4F7Qv3mao4KeKYgd+
         RdXog5Y2nhWgx2Mw6V0eOlzybPKTjmpWXiQsTUgQb1iwL4RspFuVPaLr0COnb2+jAeym
         5KJf7Yl7S4DI6xyjHv6HdDpSXY8sV7z6H2UijRcw8YTNrnDhX9nBkq7FG9UYTHvcPGck
         SA7TI89TqsFTZwzt9hOX8McBRs8dE3MChXuTrtJAweg6qKWUxcU/wTGI9bCjcBJPEypM
         9usjM9IYwekBRQyo30aFWcjaLvP1oRdJMx1jpetdiRpiQX3m9ME6l9QrKONtb3jPYS2P
         sZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755603229; x=1756208029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LE8KPxqLGvnqGcrCFM6DCzdu/oxztkK6aiFoXUkpgIY=;
        b=salV3Gd4O50EbUllgbcZn0xIqWMiVou+80NvfcRFyScHxOKjoYsVFZwWT9Va+XPREC
         8oRiPecOBohWitI9IA6m7/WoZSPzFtKzPmcVIqdfQn5fvZQ9Y34H6JKhJcgcasI7rNjQ
         utdaG5H7jyaXWtbxTiAP41HRuC0ocJLV4JLPxLcPzTdnbbZ3e0WLaC2c5s867Ia2+sOE
         yPYCnHCx/gvRJSfjyzF8L+PJfkw57zHeF9V25WagYzq4lMSE07SobLCvP/J+e94UFJld
         4ty0WqK3KVrIDZhHbPhmKgXl49hDRvNUJOQ8ddc02U8DGnWev3gAEo8Ro5GsxglVdbqZ
         nOkg==
X-Forwarded-Encrypted: i=1; AJvYcCWA4e5IsadfHJ2nDLttAr+vnjWTkHxTTPhrZCBjHrXy/yJV7M/MHcn9PUjh80Z0AGUgfgvC+AuqDQ==@kvack.org
X-Gm-Message-State: AOJu0YwIJ1N7zz8cp4ha6kIjDtAE7t89SMqoXjCYE9ypgVL+h4B359kO
	tAAsagrKfd16BXzUu+vIE4N7gm8VeGhMHYLEWdVLvGffdUQLomScnGWDHyU4qd5DdNBdlFhAk8m
	FTHPXNXToAjNvPrYAlCG2Elasngye6Gs=
X-Gm-Gg: ASbGncsQBrVDHMIJRd9lRlR/hR8m7rrc/TxLiEHks8m9mneaAtVwBPdmYcqaLF7pRIl
	007FCFTxi2FvA983rDDX/vVTPDHpxHk8vkI4jpYnm0j9opbopkJq/7Jqkfvabjix3fiHAxWqyRr
	EIOi5AU9V2RFnGfFeNUGqwCJLCQzXmByAYjZQWtVN1TxgdO8riHDvT033Bg+C9id5KA85IT2fJh
	Xxk3PKL
X-Google-Smtp-Source: AGHT+IHP7AvP95cDuz1oKXtouBgiB+1zSwnea+kSTjGWrEhHxsS7Ly0bT2odjaHfGCwlt9g6a8siFEX8QjU853O+P/Q=
X-Received: by 2002:a05:620a:472a:b0:7e8:71b:96ac with SMTP id
 af79cd13be357-7e9f442a1camr228046485a.11.1755603229147; Tue, 19 Aug 2025
 04:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250818055510.968-1-laoar.shao@gmail.com> <36c97fc6-eaa9-44dd-a52f-0b6bf5a001d9@gmail.com>
 <CALOAHbAQ=51mfszBN+Bvb9z+ZDyTBuCW_s0EKi+5rDghFvRZzg@mail.gmail.com> <a24d632d-4b11-4c88-9ed0-26fa12a0fce4@gmail.com>
In-Reply-To: <a24d632d-4b11-4c88-9ed0-26fa12a0fce4@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 Aug 2025 19:33:12 +0800
X-Gm-Features: Ac12FXw_UblIdxEg390DBWAF0j7IE39u3YBW_XLxywfHkQQXh4zP9W5l1I0XRPY
Message-ID: <CALOAHbA9tUVarpOnMVMViwY+1uYOFRuD6A0fDPqeqhS=LdJmhw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 mm-new 0/5] mm, bpf: BPF based THP order selection
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40F6720007
X-Stat-Signature: oko6hybxosjpeyjht81kyzkqcxosnudu
X-Rspam-User: 
X-HE-Tag: 1755603230-390387
X-HE-Meta: U2FsdGVkX18EH52H/4HtSbTEC7XAry8595EwoTKS6YmMgXgg5S8DJbwDBBuW2OHPH698sgbiYFyY1mn7c6YFUnz5KQRtS+tZnfQIpjGJiKEfKnzrUJqzI4V3Y1QH2KRd8hE5MvKf+0i6JMfaFVl7SyojHlTmSL++z6Cm5qtqU6Cflf/9CAB/PXhsbZmI102fcGtSGMaulv4nLX+7Y5KsS8vbaNpk7r2080jeEhjbtHrGBs9JwyX7qt/MdrCtgWEyT7SHH/87pP7AXxx7gG/JkeHC/CUGSO4t6JcSjkeMqdOa6WH8EXxpQPW9OVwMecXL1A1tjXfi1Dep2GgowANoryc89PJQE61bB45V+TIa8QO1eZB4Dc8/49c6PLURwWk6wuHJrazdUSzqW+jtfMV5kpvWNGaIw5ZeoQU0qNXk4VDQHpVt6kCUlh99iublMld9rVAMOpdcuyrsOZ0D8mGc5DnRQXTPzNGMnWlOl9hpywXlAQOMfFqjXMsuZwe0QdbZEcUkW29lIMXFERnpaK3cu8jS6t1LKlMnxfNSFwzNGJ5urjQAo9wyovhr+7SvHHm+vt85wTD8ZdzE/plFD2NVZUSV5PkTu/mQg3sINbFm9G58oMU3rGEY6QAD+fC/rjyZhTWunscIo7u9XAYv7lJCg+zrwxwnyoSAmlYe7weyPlGR7+hi4QM3v2JGv7LTFZOlI3KNp2CVMN89jzxmZQG18LIUH/vQSbhyFnemoqb+yPLPjCJzLSuY4oSgid6Wt0I01tbiQL5+tmhe2iBRHK6Bz0trXvEQxErPxaZPkJmdqn9vETFAb3/9VU1LFBnYxPY6pg8R1A7MEid76klWsWPuhx8pfMuviJcZOBQULI0Dn0smfXZI05WmmRQLuXc0B9qCRfHk2NKnJKwirUCtYeDXDrkPigRu6WfFpOaBNX0ubtxYy7rfa8L/KnGV7o0a7As9s1E+wo5tt3dPApmATJq
 lSmg/p2m
 Twpa0JWEZRcsyaNokxnVU3hLRpwFrTRiKLtOgF1zPAbkwmX5hc8VOezt0pKmK4dSO3vx5Jw4li6+yjtY+SUxiZ5a+ZNy21hMw/G4jUVusJ8kr2uxRXIcnylxW+ZxGZw7T3k+Ir9SKn1El6sgqJU4DH9Ow4GQaHlP+WJpUxmyMFEZUnSSau8Q/+5BIU5DF/GVo4RaKRWr9qQAI5QfVOXn0QxgKTZWJgwuDoCjW5g0uVQXmeBMPww3dBE7+NMHFZk3+MmDXp+zGH2CJAUvTdoRXaJg/+nAJaEQMIJOKhStM5KdsnOApGLAQ2b6h9qAz2mh8b2Yt9xQLm6YBfeq/51tbI3PEqEImtaT9uE/vrMauMsDu6ccf+OvpDEZJtarpB6L26G2Yd5vCcHuTAIUsS7S+WgOKDtC+Zto96Qtm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:44=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 19/08/2025 03:41, Yafang Shao wrote:
> > On Mon, Aug 18, 2025 at 10:35=E2=80=AFPM Usama Arif <usamaarif642@gmail=
.com> wrote:
> >>
> >>
> >>
> >> On 18/08/2025 06:55, Yafang Shao wrote:
> >>> Background
> >>> ----------
> >>>
> >>> Our production servers consistently configure THP to "never" due to
> >>> historical incidents caused by its behavior. Key issues include:
> >>> - Increased Memory Consumption
> >>>   THP significantly raises overall memory usage, reducing available m=
emory
> >>>   for workloads.
> >>>
> >>> - Latency Spikes
> >>>   Random latency spikes occur due to frequent memory compaction trigg=
ered
> >>>   by THP.
> >>>
> >>> - Lack of Fine-Grained Control
> >>>   THP tuning is globally configured, making it unsuitable for contain=
erized
> >>>   environments. When multiple workloads share a host, enabling THP wi=
thout
> >>>   per-workload control leads to unpredictable behavior.
> >>>
> >>> Due to these issues, administrators avoid switching to madvise or alw=
ays
> >>> modes=E2=80=94unless per-workload THP control is implemented.
> >>>
> >>> To address this, we propose BPF-based THP policy for flexible adjustm=
ent.
> >>> Additionally, as David mentioned [0], this mechanism can also serve a=
s a
> >>> policy prototyping tool (test policies via BPF before upstreaming the=
m).
> >>
> >> Hi Yafang,
> >>
> >> A few points:
> >>
> >> The link [0] is mentioned a couple of times in the coverletter, but it=
 doesnt seem
> >> to be anywhere in the coverletter.
> >
> > Oops, my bad.
> >
> >>
> >> I am probably missing something over here, but the current version won=
't accomplish
> >> the usecase you have described at the start of the coverletter and are=
 aiming for, right?
> >> i.e. THP global policy "never", but get hugepages on an madvise or alw=
ays basis.
> >
> > In "never" mode, THP allocation is entirely disabled (except via
> > MADV_COLLAPSE). However, we can achieve the same behavior=E2=80=94and
> > more=E2=80=94using a BPF program, even in "madvise" or "always" mode. I=
nstead
> > of introducing a new THP mode, we dynamically enforce policy via BPF.
> >
> > Deployment Steps in our production servers:
> >
> > 1. Initial Setup:
> > - Set THP mode to "never" (disabling THP by default).
> > - Attach the BPF program and pin the BPF maps and links.
> > - Pinning ensures persistence (like a kernel module), preventing
> > disruption under system pressure.
> > - A THP whitelist map tracks allowed cgroups (initially empty =E2=86=92=
 no THP
> > allocations).
> >
> > 2. Enable THP Control:
> > - Switch THP mode to "always" or "madvise" (BPF now governs actual allo=
cations).
>
>
> Ah ok, so I was missing this part. With this solution you will still have=
 to change
> the system policy to madvise or always, and then basically disable THP fo=
r everyone apart
> from the cgroups that want it?

Right.

>
> >
> > 3. Dynamic Management:
> > - To permit THP for a cgroup, add its ID to the whitelist map.
> > - To revoke permission, remove the cgroup ID from the map.
> > - The BPF program can be updated live (policy adjustments require no
> > task interruption).
> >
> >> I think there was a new THP mode introduced in some earlier revision w=
here you can switch to it
> >> from "never" and then you can use bpf programs with it, but its not in=
 this revision?
> >> It might be useful to add your specific usecase as a selftest.
> >>
> >> Do we have some numbers on what the overhead of calling the bpf progra=
m is in the
> >> pagefault path as its a critical path?
> >
> > In our current implementation, THP allocation occurs during the page
> > fault path. As such, I have not yet evaluated performance for this
> > specific case.
> > The overhead is expected to be workload-dependent, primarily influenced=
 by:
> > - Memory availability: The presence (or absence) of higher-order free p=
ages
> > - System pressure: Contention for memory compaction, NUMA balancing,
> > or direct reclaim
> >
>
> Yes, I think might be worth seeing if perf indicates that you are spendin=
g more time
> in __handle_mm_fault with this series + bpf program attached compared to =
without?

I will test it.

--=20
Regards
Yafang

