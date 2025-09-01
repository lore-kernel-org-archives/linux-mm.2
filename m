Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B18CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E6E8E0034; Mon,  1 Sep 2025 06:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006328E000B; Mon,  1 Sep 2025 06:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85318E0034; Mon,  1 Sep 2025 06:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D43238E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:58:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80AA285E8B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:58:57 +0000 (UTC)
X-FDA: 83840383914.16.8C305E5
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8DEA540010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:58:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i1AeLyII;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGzY2rJAtHroiO2Pc45fRLjqCEj4luqkO+iLLyoK8Z4=;
	b=mJtVxJ0O6IwANQME4jcKbNgwTMxU7/NBJdnXe7XGp55pbfqAFoF60irAj2Q4tHUqcJyBZO
	umkkyLNEujwjMBjso8XL0cJVZxVHiTmWT/0Cx74zgz3KNmvlkmRV3ZhK2UJNAQzOPValPJ
	RYhAztvlmfQRSzL28x9hTAyfrdo1mhk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i1AeLyII;
	spf=pass (imf01.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724335; a=rsa-sha256;
	cv=none;
	b=5PcVZkJRGli7kOb7WjniIX7iK57Z0jMQFYq3GLILVwhWmaBboZQ27iHphl9S5QuVvmiuPt
	/VFB+Hkh7ewHRGR0AXlb5rlfel/8OS+WF4zkU2+qERmHrXptTd5PDjY2EtRJurLqcy0a43
	HYc3FuNAuiENSTAP0BQV07Dwz2tpjLA=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso11818a12.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756724334; x=1757329134; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGzY2rJAtHroiO2Pc45fRLjqCEj4luqkO+iLLyoK8Z4=;
        b=i1AeLyIIcr7JxlThcbdZUdLV63y59LfiS2bRB72NOSkNxY1cyzdYcxQhUpot23xRWf
         Cp6TL8rcjeltyhxZ/HrAMkE0MwZz2AIpCnId9st5vwfmKseNbAaMJT1osPPTyermUR2t
         dQJFlP7pvJ2tg9KP7wFk/VPpkivRkz/P6F/sXamP7Ex1X5xtJJJ9Zgcu76x4/qaq7k9G
         pDI8EVa8HriogohqeMtaOcvxJ2JzjQ3l5fiRHOAU8UQzHVWzv0tkBm9tUzf3qWvekliT
         KJtz67DEwl5hAx3ujbnYkPfY3GzEnByhraIGEsuSdL5/rndF+4cshB2ivRfpd5luGHMm
         OHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724334; x=1757329134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bGzY2rJAtHroiO2Pc45fRLjqCEj4luqkO+iLLyoK8Z4=;
        b=TgFmGz++WOav7Q05ehVFXgpg1+cysUkPp8Pp5z3qYvX1h3VEc1FjwONZQfaHzaO3ry
         X3bVck0Ex8JVyIr9ssHsNERxd0O3KRD123TkZSP9w9itFBFfxkYFWyxFbSq58yxekjNz
         siN/YO6KU5U+o2ffG6LYKTFN2sMXdV/Lf5Q4CV+rFPexBy4TkoSnnqXVntrqOg0fU67l
         u4cudO4MspUuC110QL+ImSQHdsA9hfvAD6vz1SUyNjgsOsjWFpCqVLQNvFrZMGghbF4C
         Hly/QxZJp2orku5jeedCwWQtF1k3wwK07mXPCdZ5bNPZCU+CWSKGt5lmrcViX6x8Snd2
         c7rg==
X-Gm-Message-State: AOJu0YyVhFrdRH7ni9DbKLvni7Nu83FsRLrMd1xo7a3MpCTW4A/GYNAx
	QM5X5KLf5eg6Mf6gnCqBZ1QmcmaK7SQBgG221PcSpIWrAfHAK4pQmwGGV/oc3rrw0UEY14rzpXH
	rGZK1VpXlcS8f6pJWdvJzqG/8kN4SrKKKtcdAB7ys
X-Gm-Gg: ASbGncvSZrXIvHRb3p96wljQS7Kmeme8Z4cmLOPfYQlPfYUZXLNt/InYf2Zc7Z0Tb1O
	GKz2L6Ts0/Gwu3hJ/avr6hH0ygM2LneEx2lC+M9G39sOqGE7XIva7u9NSxB81DRzYHa74SFBOau
	4S+qJR7W4Z+3+OLfB3XQtlbmIvaaH7WEa1X7ShTn29aep+k+HXbY5rQEJUII1EdgWd3p2B20bAq
	dOO+voffSYIQLuCmECrGwi0PzqGITTIa/M8E4B6yQ==
X-Google-Smtp-Source: AGHT+IF0MF92OSwKaT8dc5btdbuZi/r8ljMshHpA2AY42cVUTtJEdepEWI6viiscm0IxrNVSYHmOclFXiQuAPZEGy/U=
X-Received: by 2002:a50:cdcb:0:b0:61c:b5f0:7ddb with SMTP id
 4fb4d7f45d1cf-61d21f857e2mr112703a12.6.1756724333786; Mon, 01 Sep 2025
 03:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
In-Reply-To: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
From: Jann Horn <jannh@google.com>
Date: Mon, 1 Sep 2025 12:58:17 +0200
X-Gm-Features: Ac12FXxH-Oq580f8g-P94YE4nrs0vUiHqAcrNQ9oEvque40YtjNbTm97qjqbxe4
Message-ID: <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com" <trix@redhat.com>, 
	"ndesaulniers@google.com" <ndesaulniers@google.com>, "nathan@kernel.org" <nathan@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DEA540010
X-Stat-Signature: yr3eb3pe53xyfe1driai51gbc98u6eus
X-Rspam-User: 
X-HE-Tag: 1756724335-336904
X-HE-Meta: U2FsdGVkX18947cSPTA66XW9z7ATdMi3v+XK76ObzsVhpeVdxvxHpaDSAgytDFaO/OzEPg9It+CpdnW5JrW+xDe0qYXtmd7SS1ZiRjTZkvCXGzPrmr2BfsD8BUpvQsBJLeT4poC0lpfxvl0TknjHP62OPLNIkcAqTEY8BFYvfn2linlsPXl6E5kLJRvjiAI+sLQuhVXY/ypILkBeVm+5KmOiO0ZGgqq8yELFHdKjW6hsd4YE1cV0fNCMkN/VKRyaOmf/w1+QELASup85QXxI4ND8cdCTAS15u/5tZlNFBPqbLHiTF7F4D1KQb00qrpIt0IOWdWu94kiI4oheoW9b034ONWAmpJi+6qrage+Kl8OQbrT8SqoJ324SZt9gnrLmLyjTkfwtgIdxZx0UfeJ9NQnUOPl0va9NWTcklLa2B4BA9GGEyDQfbbDBDCZpV/7UdHAWHmk/ibKIIzFyejI7IJqzGK5hfwTq/cg5aQqCx4J+MureKfY7Ra5Alljky61jHInqqk11kCIDnx4lYHCwZJDsijEPffUh6NAXFjXPJp8BI2P5DnBxKf2qTjKdGp+/lzfWuIeelaDIVq9lJ+DZ4EcfOQ7MLgEWiRA0AOZKS5RS63zdK6Koaow/nE7S6tRMjOq3q7gqsvOZ7ObA23NOalAElq3hUcsM/l3i5A2I025Qw1B9BBpxK4b1xnSv3d3FZ2AlPtu6/Ve10oKrhEIJNm8orhmg/xyDVAgi+JlC6IFlYdfZu4UFBmsp9LEdNZW3gwqW/RX4rCd5U2dR7SXVSuOo4HcWk0s4feIv9tS3v0RuM2aWypPXCwtFPfMCD09L3fHQ+WM+4cjqwNdHILaghXCSKT5Jkv3abvUuM6M5XszyinWHyGjKMWtH2U3Ntv2F6GXoFBQlIdherYSiOQ+P1U/aUmggm1ar0The3dtzicNYkHsDK7vHNJYROiwldN5fclBLf6YZ9IJNAyX0+J5
 /zVrIVCY
 0Z1gNK+2p2OBnolnBa2WOhSQdVZjRyytbvT//Gtsx8TzR4YE2stEUThPvAVHFstgXkwkzPz7Z1BghvrDxPgy2Kldr8gN6OjmFqVGSlABVqPt7wonQhqGmg2sBQHDHhOEnKJvxEZs5ihPymuLeX8547wM092P5YAKhYczC6bKWN86iTSEHYQslPszSTFMne/JZgH+MqCUPqig/U9R5jgPe48YDW9QilwnwzJRO5FsbgwZvZi5zwAiKDwlEQ54LjosLoooOK3PKM6bDYH64c96dOAhs8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On Fri, Aug 29, 2025 at 4:30=E2=80=AFPM Uschakow, Stanislav <suschako@amazo=
n.de> wrote:
> We have observed a huge latency increase using `fork()` after ingesting t=
he CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetlb: =
fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB of m=
emory with 196 cores, we identified mmapping of 1.2TB of shared memory and =
forking itself dozens or hundreds of times we see a increase of execution t=
imes of a factor of 4. The reproducer is at the end of the email.

Yeah, every 1G virtual address range you unshare on unmap will do an
extra synchronous IPI broadcast to all CPU cores, so it's not very
surprising that doing this would be a bit slow on a machine with 196
cores.

> My observation/assumption is:
>
> each child touches 100 random pages and despawns
> on each despawn `huge_pmd_unshare()` is called
> each call to `huge_pmd_unshare()` syncrhonizes all threads using `tlb_rem=
ove_table_sync_one()` leading to the regression

Yeah, makes sense that that'd be slow.

There are probably several ways this could be optimized - like maybe
changing tlb_remove_table_sync_one() to rely on the MM's cpumask
(though that would require thinking about whether this interacts with
remote MM access somehow), or batching the refcount drops for hugetlb
shared page tables through something like struct mmu_gather, or doing
something special for the unmap path, or changing the semantics of
hugetlb page tables such that they can never turn into normal page
tables again. However, I'm not planning to work on optimizing this.

