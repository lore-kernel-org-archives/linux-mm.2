Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EB1C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7124F6B0098; Tue, 22 Sep 2026 10:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA656B009B; Tue, 22 Sep 2026 10:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627F66B009D; Tue, 22 Sep 2026 10:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44C846B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:57:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2BEE1A04D0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:57:04 +0000 (UTC)
X-FDA: 85241700768.01.208F9F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CED921C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:57:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ3petdS;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790089022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPkW4aVoe/0NbA4NwEjKqNu/gW6+hIbN3gcfVZFJ3bA=;
	b=wy/meAxWMs2hUN5q3zpp5w4MqLLKJNem3t67lAVnLmWNwC5Szv+JCuJFP172cYrFNl9tUt
	HXZ/s8VlrkuEw0g7DgjuzboSoF/sHUIbAtq6u36vOaLUG520gbv0xnlO0TQVFSA5meM8BJ
	IuWQUNFUDbL4tGHyBml1l1kZKx6inRk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ3petdS;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790089022;
	b=V27qGLImwhZmWiEiPRkrtvdZ1EG1Va5HjrcNMVifHSVwJlfgGuKerhTnKUNK4cUuKHqdF4
	JCXFQNsNh5Fo9mBNS2xxvL7u+IakgWlhQIM2bJ/D51eUufC2mIS6dlsm6QJIsz/nf1qfJi
	XAe1u4qrn67the1PlDMJKD87f4AfuBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF07443E36
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E741F008AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089021;
	bh=QPkW4aVoe/0NbA4NwEjKqNu/gW6+hIbN3gcfVZFJ3bA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OZ3petdS1ATge4HT06+k2y7RJHAjBFMjVP7z3R/p0Uo+tSKVuUZvsbO3n7LtIlIzu
	 89u4qNvPmfBAKcTOj1SnaeBkm0gOaxU4b4Ut7MzKFb7E+VSoaSBDr5nQR4UlhwxQ++
	 V1P7C69acDsfmnfEmkeAgPQ/XD5zJ7ZTG9IsTMygQ6MrUs/a/JSyDWF+TBSBxR03cn
	 6uq0ogZvfkTgrikMkOePeoSvwP/9Dj7ERNm6fUxGeainRq/aiuoAbBkH3cYTPhEW0a
	 69VVDiWNMqAhSjksvRm4UZxBF+NOCuW8tZpDYE82xkXjO/no7AUZ55K1EW9hYXD9gH
	 T57gXXDljA2eg==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672c2880f58so1192522d50.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:57:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzDFUIpC/xsLDxFyIfomPwg//Vc9KAcQEO+q5FcVrdJxqghzrhx+M2S8V+ucGwv4a0ujnVnF/bdog==@kvack.org
X-Gm-Message-State: AFuF++mwbXzOKIyGK+CzuvqB4P4PKGmLd+KcA/Etiu+z6uVhmyZiKhRX
	E2HlTcz7sLYEc2X6VJM8oMSwexu99nKqGmscupblKxSamz7/dFWJL5is9LrhYpgiQ1rxYD64Dyu
	rz/MF0XK2xgxPZp4U5+lm5ni1K0OBh1nnizEMYa3VQw==
X-Received: by 2002:a05:690e:454e:20b0:66f:c1be:a65c with SMTP id
 956f58d0204a3-6717fdcfd37mr3462183d50.78.1790089020967; Tue, 22 Sep 2026
 07:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <arKRdaNEaKvFOtMg@linux.dev>
In-Reply-To: <arKRdaNEaKvFOtMg@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 04:56:48 -1000
X-Gmail-Original-Message-ID: <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
X-Gm-Features: AcwNN1WXZFPYF0mNrLqLpQPBa1zvff82T2VNW1CuKAu09epCVErwfyw7KrXxM2s
Message-ID: <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CED921C0004
X-Stat-Signature: ptjanrbhkbpt5xzc8fiwaj1npyr4m9dx
X-HE-Tag: 1790089022-733495
X-HE-Meta: U2FsdGVkX18znbO5sRpZsTFir1+13WPG+D1rsosKotCqXm8simYrBBkHT7QRArHZi/SOIjLru7m+49ruPm7Jy5cssYRMSgCl620BRM2aZSs00JZYCYvzQMT64NMRG5DkvMKCrc337Yv0vn9EtMm1mf++i8na3w0ebGl3Jlo9tYjH+C985UD+whe0I+hQRZuxafPrhfw/UmibgVvjUZW82QvCmiiu36pGamLrKVlfpI+kmt+S0S3le1TzVi0ZvYkw4mL0IW3Y3CW6F3IGbcZ4nPF+4TMNu2n+n9yr+vMMnYV8E+8x1wkh+R2RqlRlHKURb5Aa6w3ev70B5nt0J9iRzdJqjVQMWELfwd//aZRHWBlrGkDId2GEH1grP4LWil2kWnw8s98pf/CzjU2eh+RLap1KuoPSDROq8kbUEvf7jkaaW1W3OJo/NCqE751FYC6bztLEkSM/BGAL7cqxvAspOtISZomUCO5jNIiu07KM8xUxgPnashKEluLn1YxuUeIJSSTuofTNR+IJAqjQk+keHuIRYriT9U/v3dTTnJGzqD7AQjNtGdVV8de8E9y92KkqQWyRoQI7soYejBD7+pIHfniyeE9U/HLnv+Aa0CEA1nzEhje/HifuKF6MIPN71x17t1Lia7RLFguBmy5oLvCp0wYGHRWoFemW9jomuZowuC52FqDxrhtVsd7N9dYntANydATsEHKRpYLVzD0RGiVhK0kpW/ASKGAE6ECEXk0wf2ZNId4ZQ7jAZY8AL9s0nFv2XKRTAUR51GNzzTJtQInE3dd3KoliiB8sj5wm9XoHdKLTin0ffPdius4DT6tdRycRr/K3KFkBu5lKjR+spR94dNexD3znVunIPJxD9Puj0krG3dVOgSPeqwZd4iRgo0pI5V2hCstZOZ48NeAp5Lyl5dVBw7C4BIT3I3rfA6ACqQUAYgoeUUOIA1jJkwzZoIlSaMN6v9y4/irsSUhtm1b
 vaGSWYFP
 AHsq96GnKlU09/OxNpQONeRDf86XaG2CVoI9nUSIvuw6s0R0/mNDN2/EJpOA806Rqn6okt80njTuRaDVrX4/xiz+p09A+dQQKXw3XGstY+7MCAuBNAGwmHdrd/dtlxffZikV73kmUTnbAGWtojkAyq06FL8b2u9IY8d3juv+3n84zsgkPqg52EZUSgGrd2y7uJd9kT2F5th4zfAZQAQc5yt9z9DkiJM+udRpX7AqifIrSB3guXd4lFpBzTQZFqMBe+YUKwkrwMnH19aoeUt95tYL5hDXbvewjyy4wv81/X0IVEPKPz5Kc6BQVDTbnr5TfiQ0Sld5z8enx8S4pnNbhX096fIgm+GwRQ4w+sMz3CVX6qyEYyQ5bv218M2NZ77+fNB4Azrta+atbqeMhfa69qyDaWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 4:43=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> People can speak for themselves and suggest other time slots. You do not =
speak
> for anyone but yourself here. At this point this is derailing the convers=
ation.
>

I am expressing my opinion, freedom of speech. As you can see in the
previous discussion, Baoquan wasn't able to join that time slot. He is
a major shareholder in XSwap. I worry that alignment vswap vs xswap
without Baoquan is ineffective. That is my opinion.

Chris

