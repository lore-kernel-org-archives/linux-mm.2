Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1773EEFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3346B0088; Tue, 24 Feb 2026 03:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4DD6B0089; Tue, 24 Feb 2026 03:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0DE6B008A; Tue, 24 Feb 2026 03:09:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35C836B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:09:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B60C91604BD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:09:28 +0000 (UTC)
X-FDA: 84478625616.09.9A95C51
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id BDD9E1C0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:09:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MzvLWtJN;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771920566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNPuP84vk79KL266z/45Fs7Uqy7CpD2+o8LZg3RRQ4E=;
	b=BgEAIC1BTScfupA7GN8uzuMm/J+3fvTfZ1JmEG4qjXr4pN1960Ywj4Rlssj2kueBZS9HyF
	adtqhWwbfK+LSOARzvqEox1Zq8W32pB0/9Bsc7tl48V+/9XIxC0mb6mHCB4hwY73N0Q4ol
	pS8vJ/oBpWthi0JuRx7hJiRcLM14CHU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MzvLWtJN;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771920566; a=rsa-sha256;
	cv=pass;
	b=woAq2JwF+Zm5vJtisMDmtYD5JTS5eMvoDgOTqBNaxex4/7YVC6oMxaPRbJ2xHrTkvlPBOG
	RvS1xofc11GaSvhBSCA0vP4e7BKBCQaq71ZpoP6kSCt35yzpzJ82TufP2Fl+tO77D1rYZ+
	Q2p831T0olyBqKiBQ4J6uHGqVHPUxUU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so724734566b.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:09:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771920565; cv=none;
        d=google.com; s=arc-20240605;
        b=KtCpxl7GgkbsjIHSOEMmmQMzTTBFJiidEbQLUm2u5OivKVKg+dU1eqyqwSLtAUo6zy
         hgrxB9es4544nCu1oHWahBVbraGh7WKW5jm7NGiU9g0MXWBPViDJl6i1Y3qF+L5P4WlW
         s6RYpx4RqPBrqaBix6YzYxjqoUhqn9ERvaOrx9H4MCFXnwTllO/nzsxfOZuKvXHbJQdw
         LWS1ppze6Pm4yahGb7GzZXrH2sIVhsdupzsO75v54LQkXy1OT5ruGNGX4zaP9jKY6+OS
         RiQ85s4FisASEkAEGsEkRALc6JSwfPoZb5z61LA+3uLVVwzuzq0LTfzcbEIrvCAoyeVk
         Llag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FNPuP84vk79KL266z/45Fs7Uqy7CpD2+o8LZg3RRQ4E=;
        fh=57WJiz5u58FJn9Ec59HSH00LmQmnVUgheehAal3BfIA=;
        b=LVcQyrxWiOBI2pIc4JqF2CWdtOYQpDhf1+tbFILynXU+VE9BdTHnm/6IOg6F2btd6L
         XpTq6LA0IOWtP2RcUilajZ/XV+izVg3pVJC4wyPj8th/n6oZeoSzIKILsm2w5IjnMC8E
         xrBhlfLbV6RVEX2fiVX+5+JmQMeJP/vO1OHV8KxPPfvavhRq9+1RVE381zmKKRAA+mxt
         Ghb/1Om5Y0TbAv65HuV86M9oCudBRFwY94XiWRgS6ii4FdC3D8aM5lBiLid7DhN111hO
         DD7g+4r7EIwVnCWeOYQ5TAASWP3lL4ipdybG4CIyLsru5Px9XMniOydKdz90thyRhdgz
         TyEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771920565; x=1772525365; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNPuP84vk79KL266z/45Fs7Uqy7CpD2+o8LZg3RRQ4E=;
        b=MzvLWtJNGNJ1Gxfa2ggLkrJd5Z/KzQ15osaPuKIpJuv8egMfYpKk0tNMns2nE9pgNM
         07PqkSmOmSE+nxrNcz1db6sQz/qa9/9f+80C+OAske1ugiSU3Da0wjStrvQH/clHZfai
         yFLhHcSEaJ9nUISfDMvlSmefUvRzTxhYZ5gVtutbYNX1O7lAJBxzi9ofW7dk6+fbwwPp
         rmhTGQB4ZiD3iRhzbHVx/cWpPjlU2Pe1reUI8z7ME8XwKhcEhVX5izTLj7IRgFkgi8/K
         V9csN+v92bQkWi6HfaUeWjsY4ofiwdjO2Ooef4gi9DgRc2GIlu92FHnQzcj24TVeeIHH
         CGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771920565; x=1772525365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FNPuP84vk79KL266z/45Fs7Uqy7CpD2+o8LZg3RRQ4E=;
        b=k3mxw77EpeCQfSG4RaU+oqdAsjwyC0rFF8QysvRGbNv7k0UAmSF6G1J3Wr5gYQf8SQ
         vTGNDAkHxmVpnhVELTMoqmIkcFihVScC7Bw6hhBnGwS0tsQiEH9H7GKveSwU60LPcJSf
         Av40yn7kiL+1ZiB4Kj2Ap5QhM7MY/LXZavNtwTsi09tKgmv+87+ZYQAIGBYKrnNkhdEI
         wTp6fuCpUyIDsg3LVqXvg+1UFdxxGbCivzYjDAMmtkffPe1h644mYxibE+i6FzzHnWPo
         832mZ6Zg1pp38xuoIuSgoTsRIzUHxRyxdgyCyTYRsWkDCI6+oxv9LFXS8f3IgQbP6uwq
         2MWg==
X-Gm-Message-State: AOJu0YxuLSiS83m3UKAx9ABupCOYaArizDUQrLSCQzPBjq7eOwthk5T2
	dyY5oBKpgVurgnLMQn9kz+lWchJEZrcn2+BXKXd2tsfuZWRghJR/D6yI9YQ8EclAR8/bzbYtwam
	t60OObdBE22klsJb6VW9ccLHE/+O07so=
X-Gm-Gg: AZuq6aIquWQzVCLRF7eEcLT7CCs1fOmQ4622NhTD9XPzxoRtm8sYEzKlf3QiwZZdBsf
	dxnYk9ns8jO0aMgUZz9VSQO7BCyNvk7KXvZtZLfMbJtfitigA/t9LSI6O/ilnpJMdALbC3L5tyQ
	F27FjN+/8M3lsJ3hZumYvPIxi3Yo/YOARAg+sU52OkipDVkR8VCD/KfO/ru/GT+WzRIlTBKou7u
	/FHqTzRV8MB4HoxbDPXCS/LMX5cPmZrBoabWGEzSsTq0gIisSpn0fFD8tZ/ygcFWy3OvDR79ljU
	rrjkBSu3EsteIc+iFfSpjLuC2HBtHbDuNCBzI9HT
X-Received: by 2002:a17:907:e105:b0:b8e:92e:d316 with SMTP id
 a640c23a62f3a-b9081bfed88mr370513066b.56.1771920564862; Tue, 24 Feb 2026
 00:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-6-104795d19815@tencent.com> <aZ0oXHNMe7_3P9OT@linux.dev>
In-Reply-To: <aZ0oXHNMe7_3P9OT@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 16:08:48 +0800
X-Gm-Features: AaiRm516C6c119n55RhFty8hjIzFAw2otJUtAgUiNrhV_yc3b5XfX7wnRNLLbjo
Message-ID: <CAMgjq7CRpM7no85OxMpDNAW=kCOr5i5CmKeJGd6VY8yYu6sEYA@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] memcg, swap: reparent the swap entry on swapin
 if swapout cgroup is dead
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDD9E1C0005
X-Stat-Signature: au3jhrtpg9eecgoi6o1gcfuq5is3z34a
X-Rspam-User: 
X-HE-Tag: 1771920566-321173
X-HE-Meta: U2FsdGVkX1+hOebmXrJwUKJhjfX/mZBgV3wsqcE3V6WAy4OJWZXtBGIR9bDZL6PL9587n2msYJPRx4lO7qkF01M1jkrup2LoMUwFCMejlhyCMyVwaciLOGmEGf2UFtIhD34ySpRrHfMnsGfRxaGciaz+F0/H9+SnLys9J4Ib9S7nh4Nluo+R8CJMfeDeLUfM+nvy2+q46R5rAObX87ZxcF6uHPrZRToTYUoGhIvaOVaFf71jctFMyA78gvtIspiZQEumc45bUK3vDA/DzviUL6imfZfq0V0Zd96ouZdlHpBE2JfMna8vLUyqIXfeO7sQ0UczQ2dR4dCFpCBLs4IsfO6B5X+IEykeWpRjJMcjOextWRY99/I2XJNLbyUbPXdpxFH9Tv5biA6pUXzo8UFVw6sNTnDWAJZK9wLgLdhfbPKNzJfneztXTwWJASIYgMrYu08MvS/IQvIckNyKdTa8uTES0ntNkSbDYI/klpdfOMH79cWqbib2+yXb/fkWuwCg4ptnxMzUett8CVm+9d3dn6/Mk8uI8LXgaUl31sM5WitWz0fcautioJ/2jcS5vmEdEwb0swWHpbOh0KvOZzFDqPDMSGfk7LhogVTZ+Rh2megvLxipSp179GUhfxKWYbPGdMswaThb6Rv0YHg8RI2JdDzdEgUD/FnalYxGyjRUIdXe2QNVGOEMqxmiXUHEuaolJH0gd+psjtI6nLBNHYM97ZuR/pmu8pI4F2rna/OMrPtkacYmS/B0FJ8n426tPCWjaJlycxWpWgnRbJHRPnRtvx8iqoB6XDK/kC1Q3BhNDtX63TQE/Eo8QrHMExp/G9EyxYf+EUh2f8Za1+T39aGxQUIK3pPD/dtryAYnSbTwKKDZEENe4Yos0HQQH9JE35EibWJLWt6BkTFYi/QRABO6BqtHNkwOIvNhrVAxnARUZdEzzTiuPWYjk8CTlKEF4UnK30IIB8YeBnpLd/SIiZz
 vkBKHa26
 zXpaRJ/LNVpff4MTMNwupl1Cqr88/DI2w6OfffCUX74/1Gb3ZJ+IBy7X/dIf/FtOfnK3VArzdDpuiVrKPE019fKnI97QTK8FSk+IMCqOGf3wNvLtdx3hNmmqT9oaD2sso4Rha3NKJC+E7fkcvtfxCd2UsQMBbaTS4UTUc24N2onwm2ck9327nxWZVRzhX4Bs7PZH8BEWL1MntOtK3j2YzDrq9viEy9Si3ETmL7cg4F3ZhUPr+RNbIf5MnflP72+qx5m+DMoMz+l40BNwDi5hJH+CLIycxyeQCY30j8YWQ0qGM8CeO9dCA5X7Myu1TazkTmPtQ0ZWnMstabiv16e8YwNs0CoG2JKThO2S/dGHQ7UBm6aodGbcQhI9R4hGa/JHgu0pQj2DeSfbBxAXImmevzLR56VirrUpdgU2pSssShysz/0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:44=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Feb 20, 2026 at 07:42:07AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > As a result this will always charge the swapin folio into the dead
> > cgroup's parent cgroup, and ensure folio->swap belongs to folio_memcg.
>
> I directly jump to this patch and the opening statement is confusing. Ple=
ase
> make the commit message self contained.
>
> > This only affects some uncommon behavior if we move the process between
> > memcg.
> >
> > When a process that previously swapped some memory is moved to another
> > cgroup, and the cgroup where the swap occurred is dead, folios for
> > swap in of old swap entries will be charged into the new cgroup.
> > Combined with the lazy freeing of swap cache, this leads to a strange
> > situation where the folio->swap entry belongs to a cgroup that is not
> > folio->memcg.
>
> Why is this an issue (i.e. folio->swap's cgroup different from
> folio->memcg)?

It's an issue for this series, if we want to track the folio->swap
using folio->memcg to avoid an external array to record folio->swap's
memcgid.

>
> >
> > Swapin from dead zombie memcg might be rare in practise, cgroups are
> > offlined only after the workload in it is gone, which requires zapping
> > the page table first, and releases all swap entries. Shmem is
> > a bit different, but shmem always has swap count =3D=3D 1, and force
> > releases the swap cache. So, for shmem charging into the new memcg and
> > release entry does look more sensible.
>
> Is this behavior same for all types of memory backed by shmem (i.e. MAP_S=
HARED,
> memfd etc)? What about cow anon memory shared between parent and child
> processes?

It's the same. If the memcg is dead and a swap entry's memcgid record
points to the dead memcg, then whoever reads this swap entry recharges
the swapin folio.

