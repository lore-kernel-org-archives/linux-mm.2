Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AC7E9A74C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8316B0088; Tue, 24 Mar 2026 05:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8766B0089; Tue, 24 Mar 2026 05:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098136B008A; Tue, 24 Mar 2026 05:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8E5C6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:30:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87901BF3DF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:30:35 +0000 (UTC)
X-FDA: 84580436430.26.D29B5FA
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78034180005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:30:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WMtGydRg;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774344633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ajwmYJq8KViAWBGL5Vpr4I/EZYIW0MO8WCMiXQHN/g=;
	b=CTgozG+oKYhQjX77MGHKk+noujxQj81ylwJarVA88EWQuG+QfV09WycguraB1e6ugA1fi2
	e8RzKJxH/yKKM98FlqX3PGdMxYVtww90S2I+AzW7ctYtTPwyhgY9vDEfd+xQfPFsRI2L2c
	PKCno3hBUUWfTkWyRPGBUl42lWAGBM8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WMtGydRg;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774344633; a=rsa-sha256;
	cv=pass;
	b=efyHHRVKwG+spIgLm9CwNFvRFxLoWC3NZop1Fey06we1bJik8WTwj6xkT5n0Bb9VMAvtwz
	qrOSav3QUr6UlQ2lfrLo+iccMBCxtu5DEcrfFJgXjV6LD6RZ6lHCxO6DaRJiLxbwfPy3uy
	fSkRHZoDhtzZHAlUPjDcgLRqRII9kuE=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9910707d82so33003866b.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774344632; cv=none;
        d=google.com; s=arc-20240605;
        b=aW4GQlYedRc+U9vaFUPRV33R7L8vm61rYfNCK+1m1hI89PVzwWPzogvoX9uU7/cfH4
         rR79g99sMgmNZ7DyXZAkuwPv2ecQf/W1GQUQHpQbrvd1rk9wHyxdrB46LRrfBNmL28ww
         QofavR4oq47hLIaj2xjnaO5Vz7cBo97qU0LxFlUd9LMxikerYhuxGJ6WzdAp5SvUrRun
         C46bNdl4bODQhlvhYroUcxwAwPGhwiGUhwLgAkP2yWzzQhGn4DBRfPnSTjq+cIO/cb2w
         aRfrs5jcqEf8eRsManl+6yEbo67tX/tyfcy/GQ+A1uWPzwRMgIabkyYLBhOfHKz2uSKM
         eJXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ajwmYJq8KViAWBGL5Vpr4I/EZYIW0MO8WCMiXQHN/g=;
        fh=pjwjyu2WOGMkJ3Ij5bySNRJPS99VhYpfdDm8p/8h/PA=;
        b=CVEyvr5T3jctktQSJ+/rCfpdNvsUGWoFa/NSHX5inBV08QKCoy+8bBtw/uW/1Oa5XS
         GWyAQT/55Zxmak47pEbq/2Qisb/dXmT9yfkkqDHzlG2glgr5/aid9opni6cPJubtSjNJ
         FtJ1LChuQpYR5+qAfU+rbwglDuZwNF/KN2A4KfABaAg7fcK+YLU3H9yhyOWz2aOBYJcs
         rmlAIYtAegtzygm9JiP9bKZzBcmih1xxUeTw0qgjmfdlcoCnEM3AulEZ83UXEdLmgDFF
         bgC456ljkFbk9AON+Z3bfZWKSaMqQyif4I+IFixkPeYlAEkeftUWwMmmA5Z/8N+ivYh2
         sADQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774344632; x=1774949432; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ajwmYJq8KViAWBGL5Vpr4I/EZYIW0MO8WCMiXQHN/g=;
        b=WMtGydRgaw+otwia8TMFRqIyKyu/iCDsDKzo+iemrAFcE9zmeSaoqyVRJl8GYds/6a
         eWgVcicGmSNk/9n7CKbtwclK7TmSOf38m1hZsYZiZA6gfPDKzQWA6vc2YjbEXW/jVTBm
         qmPd3DtuoZ3aS4+HkS1OXMXC6jW+MvZFcNkeyWA8nxT6Yxi8gZ0irXY9wMCUZTzqwcYb
         n/W3+C4fHf7+lEtniGlwX7mbpEjw+I8raoGx/okFEXIZTnzrSyG8fV7vg+bknRHXaIla
         3VuF17A+3z3nYJeclhzR/XCCCzfzYkxGWN0mMvAd3g+txUJh9zRBmiHtsoYWCqKhDqzD
         lM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774344632; x=1774949432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ajwmYJq8KViAWBGL5Vpr4I/EZYIW0MO8WCMiXQHN/g=;
        b=KekN70Qar9JgKM7hXjaJDy0vfTEddQaKAfa5/oFE8YydpBvXNckrP7pW6R07JB3BlD
         ZjjsK+u+r+UQWr1sBuCdSYrnb2Vwa+cIUzdQHAWxCpeHjI6h+DcxM1UQfeA+DQoQVWt8
         CCLC64PkI9p2iG99wvjGVyvXXuY/5gXbKjRucnNXl/xaSf+QdX0PKb0ncEY4gH92N1j7
         mxMNYYsZQQXxQ3hn5vnh8AUo3/CmMYD/zRl2WghEEYfSXgoJNd5QYkovvjDfzWn7OMUc
         Ew5uQYgN//qGrE4VzqM2p+E4uX8w+e+bMNIoyfXSCNXFZJooUYOpptbmUGje01gNMleA
         lYiw==
X-Forwarded-Encrypted: i=1; AJvYcCX+2e5/vEE3mfaeSBlwzKvnOFuJD8cxl5OZq8vYB3mnp9HJeGvKYzsxL1MBFvx4KdJaImqCRnMgcw==@kvack.org
X-Gm-Message-State: AOJu0YxNoOR286lXXN34jzl3EUmEdZeXD2jGoXCy8k0ksqlS5BKJ7sLb
	vCIyrzmbI5IdCqc9gPabghqzrvZA2yGPYiBtYflZILM9F1FCOLf5f6IqWABGRPPsCZH1PYWpCj5
	Dd5mgT4ZOQEZ69Q73N4IbjkzrAyoWafo=
X-Gm-Gg: ATEYQzynzyYW9F+ZYdBD8hFfx8MjKkLinR0cr0XK3T4zKq5pVBDsUT5pHikHFCXeDhV
	7j7FMGoWI4c3wra2MrXluABHZSjYrPeLfx8cuuNCxrVnMz6tj93f7vU5KjRzgvkB22djb31qWcv
	R6+FfBRxYnpT4vJ0D9zGd38aSBppLvxCS0spk3PJba6BkAzzjgwpf+hAbwHYU9IHzY8X90Cq4fa
	OKEbWkqTwpZEZA4OoR7atnpaBjFJkSQuSrpYpvLjCIKErrCffJ7WPcOGcN7+sCW/T68RrveJRAk
	+O5pFaVV0ZjkCejdTeTm00+k+Ob5Nwdx7c1CMzkGi8dMt+PcWG0=
X-Received: by 2002:a17:907:9407:b0:b98:6c41:a758 with SMTP id
 a640c23a62f3a-b986c41b5c2mr470778466b.19.1774344631433; Tue, 24 Mar 2026
 02:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com> <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
 <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com>
 <0427249d-c6c7-477a-aeff-e007198fcf45@huaweicloud.com> <CAMgjq7CGhMsf4qWrW5O-s2AP7BwpbpPahEFkd-u3Q9jGFGCeZQ@mail.gmail.com>
 <ecf00130-ad30-41f1-81bb-cc9e1d360c52@huaweicloud.com>
In-Reply-To: <ecf00130-ad30-41f1-81bb-cc9e1d360c52@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Mar 2026 17:29:55 +0800
X-Gm-Features: AQROBzCNdrsNXDPDtXXQ7Z1rCCDfPCoW9dENwZcAOr9iVzHW8wc9rLfQAxbOZ9o
Message-ID: <CAMgjq7CQnGyBX4Mf4O3bQQL06zJLkdTD8KLYfec6y8RRfUp3dQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: uks7rk74cj47xpow3tbd8wdo9gzpthok
X-Rspamd-Queue-Id: 78034180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774344633-340886
X-HE-Meta: U2FsdGVkX19Pb2nid1obA/nKVxo57LpH43u5+58kO8JjjZL8/Qo5KKZUCnZhFprOiorm1W/3r0QiNTdQN1Pu14k1GfrqMXzoKllStc+45gC78MrzyLosuDRUi4UPLte0G8F4aS9dX57qD0pjfb8XONTeUICu+FEPHo6rpJk3ChAoEnnt1TplNpZJ+ul3NKYaACibdUPOP5UzWIR+kHJSUw6dHqjpV7SWQIWHIQc3dl3ox1PDtt55Xer4ezINNCdkD/UZvhdok3csG7ED9zaGADdKolDB4I5qshJBcLJxiW1vtABfoVFSV251lPN+/2pzoEYLIheLIyh42QmxsdLV2skO6MGD97IN3e0Gq8KCztnHlFAVnOo4/WNgibRqh7Ohv3BKoeuC0BVh61vNYBoi49oz3YbuaAO9qlsvVidbeTAZAMrkDGKgUqhQYrkePyPuG8g8YLuWLzsBZEyIXUieopVA1AHHxCzKBpMQLC0BxLGQSDM+7kNlg2JG2kKgzGNdPZPMtz9fNp5l8RK/W4SVvUStk4TpHQq5zs/hq72JBfGBJekniwXdfhbxKUwUj0kxMCDKHnhsstqNkP+A6CuPFbBM+QAnCoMS5tvxNSQpeUcMpYMnPYCsg8AULSuLRmKDE07N2uoxHfRK+753qLcX9vgkTxbK4WnIRkyIeXITGhAcG0kydaeqgBzZgHnopd0fAccU85e7WiXx9I27GSq/6V7gc9v9kjF+4KR9PEwPlf5gLiyZtMPY5sRJM5tcg4/8IHvuTHGJDPUWsWwxBlZKxYwbi3vFJi/w/0XKb0GoNBzNNuzBFkphjZGMl7soUilyhqJttTZ6qMxnCmZR+xGnfegqy2AnCwyeUN7saG39EB1qcMtykbXM56IV2kfa5WNcu3H8ZsOeYY6zzT0GFpFxghhjGJYaSSe7BuFMyck5jLPl7oy9tjJsuec46by5bKZXuO77soZuB9QIfmLPJRS
 l3EWRkLk
 XRspBmBunlYoyljbkCiQD7/VKKO8LpxCwGW/a4oZVcXa7FW0LtcJj/OhfNu0hThW2X/et21oTCaS2ZCF/K3+CtKNJSLX6bQKtKosQc4LnqMFeh/wqWlJaiyFsNdaOqEee0yNH63uBr/EbzuWmjgP/bTQkIMGbkHwV1SESenUiSuR/9cVZGrthWf2d2uFnH65mapcDeETHZ6D+G744JmlHR9CO5Ps8Gk290tIy6uy8eIzNs19oJy7GWEwPpLjVRJ8IWreQ5GUbPttIDiomCE9wopNa95UwPCz28Wm8+UrwGPngrt/wDmQbu6wUSeedgTufjhIk9D9UK9oWwM1Upv8bIBjmq+G8gIFKxBtqK2Iq/C5b5Vcy9y6PCEGc0+ppGQCEs/JBa2/VeMuVK0CyW+SFjvkZvItt4d6DNXFmnZt8fzPH3+nCxkNO2EmNl8qKK6+6tqPMNMPJqvFjAZxM7WehTagXiXEhov5Mj4epKq9+RCn1sJxOAW31DqpP1ZDdzclzIYlDTnVFhqt8OHsMmSPgwZPdN5ZXZifkEAZzpbv0l9UekfMhQCG9fCjn0AMa9ze365PZGhRytLW9xYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 5:10=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
> On 2026/3/24 16:05, Kairui Song wrote:
> > Hi Ridong,
> >
> > Ahh yes, as you pointed out, the explicit should_run_aging kind of
> > guards the evict_folio. That's not everything, besides, previously
> > isolate_folios may return 0 if there is no folio isolated. But now it
> > always return the number of folios being scanned, unless there are
> > only two genes left and hit the force protection, which also makes the
> > judge here can be dropped.
> >
> > But not invoking evict_folios if aging is needed is an existing
> > behavior, that commit (patch 3) didn't change it, just made it cleaner
> > so we can see it well.
> >
>
> Thanks for the explanation.
>
> Would it be better to combine this change with patch 3, rather than addin=
g to
> the commit message?
>
> --
> Best regards,
> Ridong
>

Hi Ridong, thanks for the suggestion.

Patch 3 is already a bit complex I think, so I split this out as a
separate patch so the review might be easier. Maybe I can try to merge
them later if they still look confusing in V2.

