Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2B4606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e9gkR6BK
Received: by kanga.kvack.org (Postfix)
	id 268A06B05B2; Wed, 28 Oct 2026 03:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219A76B05B3; Wed, 28 Oct 2026 03:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E18F6B05B4; Wed, 28 Oct 2026 03:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7D316B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:38:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B8631C448D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:38:46 +0000 (UTC)
X-FDA: 85371233052.01.8058662
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 73890100009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:38:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e9gkR6BK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793173124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
	b=UDlcY6SK5XDNSR2Q0Dz8nbI8pemFc9Jp6b+tWMA2LPOL+UeueXovUoGhEdj9ASfDHF4ZjO
	JHYKxG1N3TdhghvGA/kkVOshZ7Hv9VG3H19oylTXlZiwz4V7ZX34gIr9Ph/cK4LRKNr7pX
	iwjcy9Xq6BbWrI85I88nxinwj7ft98A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e9gkR6BK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793173124;
	b=Pf0iicDkFc045nzX9X36e2kaBdodi7/pwoDNGZShVdjmSYia8zERXktGkf/2fQECpZRejt
	z7IkRK5gzylahtbBygxTDzENJxo3wjFzpj72LG9H1nmXPpZTIK3gVt/JJllldv+WynPD/C
	ZN94wXKoKuBvQPBzeD4tC7NQxKtTkro=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c49c32650adso33721666b.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:38:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793173123; cv=none;
        d=google.com; s=arc-20260327;
        b=ejYo1qvO51kI00s2QHKDtj4qWbZInL4P3K1Cm083qvtlf5CIM1kBytq+TN+Vy0UaPG
         FBc2Jx+xmS/usWx4VKzRLahDxbSiftPsCS8R/vJomMADL3sbVtJbzlWwO0BSxmZC7GWc
         sSgz7ayZ+xocRppXDqWzkAgxsipaO4YgcehpaCW0Cnef4kFz72o3vZ/TLe098zirfDMs
         7w/N83BVFbQBukKhlbKee/hOpWWZm2yoAqJJSSRsq1xJ0OOREwBGHve8UpToduX/+6QM
         OtVwCyvo/UgkSMX7011RtqlR5zuPYsN/cXy1g6Mes0vYFdPeCuGsg7hD78Eo+Mn8J/UA
         +7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        fh=xxJNrNd2062Lu18NlZdk0MXCToC1tdIlsYRJ2tShmlM=;
        b=o0xV3nh8F18U69m+JEt6ZeztF7ioZpKwWKbbBgu8T4W7yCOLTdbtCFlhatsU2RNbHR
         DpV9NvpM1iJDg8cxjxo09NAANIL17Li8LyvVc/ic6usKmzER23uO4Z7Kb+AH/7zqP1t/
         AeYBh9YirtVk0h5GRfqL573UzE/KtipcGUDl/TgZTp9yyui+RHspPX+Vl9l8r4LNyN5/
         TLdkPKHCNchDL+Cmss/Ytgac4ETop6olRX6vKWSttKSUKq7Ntt6spAjCO5qc3Jy71M3/
         sQNod+BgUej1CczV9A9zmlYQNyGdC2l9xlw3L+hhGPVbYHxIDX5H58kEI3P3hUGhXUyX
         sHFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793173123; x=1793777923; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        b=e9gkR6BKlRwetCCPjHdEwLN4wUHCwzbt1ixCAP7oKT41yktfn4QeBQOL4SC9jPqkDI
         TdtSTmtJDkfMb1oXuLrgX2iDBBATYt6vk59NmqTz2ndy9Abufxhsvj71A7VZUKnRQiDb
         SJ6ynOSMQYIQDRnnhUjKCuM1MuCND77QKkehSH7hKP5snldUDLsUydkM6TGCJqKROn8+
         hHkVAjIqygfG1N7HfohdG7+yUY0uWjSdGTeJFTNN9bmXD5Up/QYkEhpTNGr08N1eOLDA
         RYjtCyZ8uT3oSjnuxTXPbiYjsiG52HHASnJnbFwraXw8qsFFVgJqQN/IKTvGRmLUQV6r
         xJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793173123; x=1793777923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z7MG1enuoki8MLFbTcKPNbIF1r1YUl7PKsWNYhZD0wk=;
        b=2oKveiQvVwpDFAiXhCCAOZAs8sy9YaROgyKkfDJrMl3w6+B3a+sydRgDL23PIHWR3q
         VYkuZHoVwotvQ6EP2/gyNxQr/QmlM5mkNqLFUCaybztkvrYwwrQFdYE/ujLxiD3bFNgb
         7JkuVbewpxU7+mAkl7vE4o7DE8AMqWb+s+oOVWvQvMxQDQa/A6ZGhiDRG4rISKENLWk/
         Q9oBcY+EYE4Yo7dQwGiupfQfFR8ECKH7u1+0wQiHplFGPL5uQQH5CpgtVKqOmjeOAvYd
         kLNUafu7BlB47j9NQLjpWu6iNiXyqztlArjXea8IIfNSIfv3rEIpryYXUBAj7XB5Iqrg
         /rfg==
X-Forwarded-Encrypted: i=1; AKwUvByo43h6YG1oYrxYzc/isomN0rdxEiM2zKWgqaGNiLR9XvE0ODzU+ae5GF8Dz6APnl1pbEBeUQa8uQ==@kvack.org
X-Gm-Message-State: AFq9FYI93UVZLtQAh9E/3r3WJE3vdrSGJ/ICP7wkGxSOHB1+zTEwJTPu
	sxSXB9xD6eauxRBfCV31L73E/dtm0vdqDupE1hM7ijbT/OfHeWtRSSlxRdWuRN9ADRpbOTNTyaS
	zGC/VlJpOHf2oZpQAYbKWPuZrzhxc3o4=
X-Gm-Gg: AYBFou1bGKl2ZY5O9AEAq13D0B5KEzL+62BzmgzYLCjxBG+SoFFEjOaKQyISwMiNi/E
	cb8aWLSKsYdEY0tjwh/C+5T64lP5T72Kwj1+9SwxnR5/m6gFKUAj7pfJ8CDWUFlDdfx+kWIvYq+
	ImzEXSAoSt+OwsHODxXi09rk8euZfhwx7yGX3dgnnlgXBtUI5SMDnb+JCnvL+BL/MMTRwvB9680
	ISpF7LmKgTMAsKIPOm9YK6io4w7HgLQ/qxKxNuftsKL+AOT74KWrKa31ipX32rz5Ab+KutHnTVr
	6zUphfuw+3r9c8L62xK8YfbBvSxqehPigpf4wLIvjbC0xY+UGP7dQOHlki9nci/ZUB/ZbG3Bj8s
	UQtOWL32cX/wf7ld25M3qn1XckxIh/CJp4qEiFoVyv5wMAhms+gNmV4CQ+3sZ4HSJdWW3Tk2pqO
	hKb4INzZXTFz5mbJI=
X-Received: by 2002:a17:907:d90:b0:c40:aa04:18d0 with SMTP id
 a640c23a62f3a-c49bdf0b830mr127577966b.17.1793173122715; Wed, 28 Oct 2026
 00:38:42 -0700 (PDT)
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
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com> <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
In-Reply-To: <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 15:38:06 +0800
X-Gm-Features: AclHuK-mX8ixSikBppmP8XVxk2jjNDTFYKjV7_1Dyl2RLvPqe5fDdGLjEWtahao
Message-ID: <CAMgjq7BQ-K-ZDmP_ZW-2+t+OQWWKEZP4ynoNk5C7NaWq+PP3Eg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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
X-Rspamd-Queue-Id: 73890100009
X-Stat-Signature: cqp8n4a83xructytjo7ewbudccus9auf
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793173124-355266
X-HE-Meta: U2FsdGVkX1+rDLtM8hMToRr429eRN1m6NblyAr4E5QOWEv5N73kurcSprHQs5ZfkXpnuFGvkEeTfmZZHHU6sXFtBtw9qrfa5Y/Rmldh4ylQnMbwKVfzCqnQMIcAhn4iIDMVJN+tfz3ZJf3mc01CAF8OtHJbkRKOpjpCHlmj3No7v8KGXzc/5aH5ij69Gc9wIMMCguCmsq37I4ZXKygcqF1/f3GoRC1XSNsMYnuY7DSljDBNFSnfrxFZf9TQqqkVHmtPAYdMnlYbM+vMbkvaPiog8+eoKjbsxo2Kb+yNeeQ5RPdQkwJCKNg6p4dXrWwHQLx+UgjitzdXsNqc9ubnPOZWvCdeN+GmInLYT5qlEA17O9NAR/r4VK7BZXvxugLQHGH8lgRS8BZU3GFOPPqYfiEDTtPpgtxe/9refpzh1YLr5LtVisEIiaMuJViza2OtmGAA0bL6qEz/iCTnO/vnlgnG7tdmqXdSEfit6hRatLZfsWPJdxgnrAN20SmOykt460XG2ntln0smBuUcLhne11cyM/nrFz4gyxBUIb9mzSQysOi0sTi0NVNrvpsBwOyzyTA2sFcOL0CPOE48ZVD5b0NqAUdgHwisdRaiY+nmoIPFwwSNzJzh7VVjWCPD3XVCJ5QrqnLxO/qUAyx0mpqOiLHP1H23kNCarBke/vBf4pUNTMCGIuU9CLdgUu1NHW5qRa8YJNTkxfBlyxRmV8AVP1hNxfPnAn9Aq/i69llv5kd7K8Hz7RnIBSJyBmikXwTUxgvoem4yeuhrtWglAJzuAHN93FHEq7aSr56yEcRlHEeRPHJ9tcVrRiYV42G76zR51yyQkAC3ffsazB4M5jSducencEfZWa0g9oI8sOhtOY5lLWf2xZgNlEphYyNVDSCiB0dnblainez4LaDM1jxks2F2cIMby4IWWLpxKMaNvkwvrWd3EzuK8gaok+cAzia8e3s3VQgD1eshyawR/Cn9
 K3+PwZHN
 KK+VH2RJlHvxnG+71P0ulbz8alHEVEC3TJO5mtAbDHbc15tLjQ15SkImkcFAFYMR/kPP9BcGGqzKffJybt4BguCYkLz7ReRugHcpdbVfdpVeX3pMngsKAjKceffw+RnqLzfWC08iYUUJzs9BnKowu49zFS4maOnPvRqsbFaXW7ZcLrVx4LDKw0tBaesyy9PMVl+YjaEKhS9GYTqtj/H2OgC0KrrVxBOSU3buEe9Sy/v5oPAiybLVXrqVVWSPdj6M1Xq/ZQPktCTg+oSLsCtIR4qdiH8f9+fnXwq8oQgim/R5i3+8ssoLicrLIFSsr7pODr6YOe61YRDsbmsZu3RExnKm7YBkX97zT8sXCzpV3MaGkrXXKogykQbHC9ta5sKyCTrFXxGTXM2Gb6+WCoJiPBpGS2dJVzIIkfD+zsMIi3oUUy9Uoh3FHRn3YQxZAR3CCyDGylWDcl71ZJIoFIKin7RTZMqRnLxp0FZ/FrtD7K41vLyAU1x+WLqmaqsKQEMvbT6zK9fggktoltT8rTVa8ajtUKYel3pDl9Y3rW0o+g+1dVCu/YhSydY2Yf9lJHvOYngcBV0GPyrbYlupCkjohQU6yiO1yuPS/N7vpfrsK26ZqRSCeHTBSpOVHvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:59=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Sun, 2026-10-25 at 12:21 +0800, Kairui Song wrote:
> > Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > In my mind, we have vswap sitting as kind
> > > > > of a swap VFS between the rest of the system
> > > > > and the swap devices:
> > > > >
> > > > > +-------+     +------------+
> > > > > > vswap |-----| swap cache |
> > > > > +---+---+     +------------+
> > > > >     |
> > > > >     +----------+-----------+
> > > > >     |          |           |
> > > > > +---+---+  +---+---+   +---+---+
> > > > > > swap  |  | zswap |   | zram  |
> > > > > > file  |  |       |   |       |
> > > > > +-------+  +-------+   +-------+
> > > > >
> >
> > > However, having swapoff remove all data from the swap
> > > cache, after mapping the memory back into userspace
> > > page tables, seems like it would be fairly easy to do.
> > >
> > > Does that meet the needs of your use case?
> >
> > Right, it's nothing hard, as long as we don't add mandatory new
> > layers. For very high bandwidth swap devices, a mandatory indirection
> > layer is pure overhead.
>
> Don't we need a swap cache lookup regardless, to
> make sure the data we want to swap into the
> process is not already present in memory?
>
> At that point, it shouldn't matter whether we
> get the backing swap location from the swap
> cache lookup data structure, or from the
> page tables?
>
> We have the page table lookup, and the swap
> cache lookup. That is two lookups, regardless
> of whether there is indirection, or not.
>
> Am I missing something?

It involves more than just the swap cache. It includes book keeping in
cgroup accounting, statistics, allocation, device info reading, etc..
And swap cache is blazing fast nowadays so that isn't the problem
here.

We used to need to bypass the swap cache for similar reason, but we no
longer do that since the swap cache is flatten now:
https://lore.kernel.org/linux-mm/20251125-swap-table-p2-v3-7-33f54f707a5c@t=
encent.com/

Other parts I mentioned do not have zero overhead so keeping the layer
thin seems like the best approach.

