Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910F9C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 11:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93556B00B6; Mon, 27 Jul 2026 07:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DDA6B00BA; Mon, 27 Jul 2026 07:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E49C6B00BB; Mon, 27 Jul 2026 07:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69FE86B00B6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:07:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E04431C0E83
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:07:07 +0000 (UTC)
X-FDA: 85034279694.28.7B2B8A7
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id E1866C000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:07:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OcOOkRHO;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785150426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5w7z4b4ItZfAnGdR2d5efYiK4hIf2c6dkxv9txYXXIc=;
	b=HIQra0RGoIlQvaJEQP6Kv1rI9muLFxEJ3it65uRoR9Lh4uyHiNqy/5BDrZDVfgIPcgzDae
	oXG3cSEK73T/3cyBcSDWSyEQAfyjbsKP8VKo+0dCLg/XM6DzFNyBNoRIa2VlYVOu15v/Qb
	J4J4ul0LTgxU7TalYuUBIx5+0S1XE2U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785150426;
	b=OWMS/0I5t3dObHTmFbKdWcNw+8qGgNxpz3H2Xo+eiJEHsVf+U1jWdNFdLjJ0WiE3kd/S48
	rlGNCeE2XpbOFB0b9cbDBO2XzXfr1MpHCSIZLBYuQNY8hQT9igfO0oYb68vwrooK67b9/U
	+dKOCysPtvewbdCIcBggn8v+kHdubUg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OcOOkRHO;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1551259f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785150424; x=1785755224; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5w7z4b4ItZfAnGdR2d5efYiK4hIf2c6dkxv9txYXXIc=;
        b=OcOOkRHO9bbgqGA/B3wSNj2mBavYSSX1Lew4iKALtmymxAruuSDh84hPHZM3K6vCPt
         Qyrxz1HEohKb/5cCowt6nf693BaTK54uAe3Zj4W8P2uI2ghD1iNnq7sBqfeU20BA/7IN
         x2+JWyUV88p6aWy0Fo50yaDiguBaUGVvqfHK2BSy/LAa+lPxUxcP2GD/GJY0M72TOn1E
         XSKBNaORCD6BbFtMciqfzTcRZBATB21Ucv5/Khol7kX+geU8xAWltVlCdJ5D0G4iQDwU
         UTI3BA0Vc2mGEzYjjKkVaA7DhzT8AKxjf5G0QAaIuIXbNrENAbxRe6eyAbvK1dUyRkHG
         gSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785150424; x=1785755224;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5w7z4b4ItZfAnGdR2d5efYiK4hIf2c6dkxv9txYXXIc=;
        b=PFR8cxq8qPZSW9VOSVZJ4LeP7VFCt8t0lr88plcD9/aXL9puDLdtRiZngQH1xTZ2Qd
         kcNp7Iai2C++AOVOAhNQzCpLhtrf6cGlLC7U3F6dpAyzjr2s1u/QrIiT/rmSvUP3gnIL
         N5G38YRhTdEJSBsVgwF0OkzePeJW7dYUFXOWCDSxyAZBtjyZLeh3N4apLPG1i7nGONoM
         h7xuc+uMF7G0EA02NJJzukXROybmiLqtW2CMht7nYaLCTSSLZU4ADGnwjLp7uPZHUcJd
         HhtLiGOf5Iamwdqx+dlJMNYXBkF6RXo6hnj84uYYE5+3SYuN8HrfGxGm84kgRjOZSu+x
         6OuA==
X-Forwarded-Encrypted: i=1; AHgh+RpATq1X/ofCRmbb/3Yll+9dVVfjKGBaiJcbIoYlfUskC87UmMPKYh55FRUzU7h/UErwKH2cXc5Kiw==@kvack.org
X-Gm-Message-State: AOJu0Yw84PVZu3H+M2LrXVT+drD3+g8HX2cdJFbENwwyZuYj4TG3wt+f
	yNxnYt1zQ6ghojfa2FNmMUfPVfdf52QmX6yoYKwrhTdzF55O97jZByGxPEmVmmbxfqs=
X-Gm-Gg: AR+sD13dIqA5YL57twJoAyQ1+USGP6PqOk1RYznEZGZZ100G+gxulNo/7ZWXQgnQDWC
	IgJP+XgwVNtPJWZopmqSrmL6xOZehbD3/KXFqBGvKWIrlkr6Du5x0JzhpA0s33yMiejvBgUkX3y
	/Thj1JSjrMmV3/AoJuA4y04b7R3ZKGZfLvoHJBwh5soFpQ0l5yx7RyYWr8B/S9E63H5qbOwLNpU
	K1guul5qAS1yCIq5KR8OaPTBfKrkL+58mDwoKDzrqMUSjdXvhefoCmPJllFClN0hgq5wtA4HhhD
	MvV9Q+E4c33Ag3gCHuFOj8uit7+UA58+4yT+0DhY00mS0jV9p33Rmmwm61F9XSPT3yuYMIe4d4r
	kq4BebxxsSuGFs3DzlJvWI1pPvH2y3AnhfaurC2gaoMVY9Sa46HHDIyzuFvGnFrRwJi6YuREszU
	k77Q6VonCCfA==
X-Received: by 2002:a05:6000:3109:b0:47f:8ce7:8684 with SMTP id ffacd0b85a97d-47f9fc9d4b8mr10289593f8f.6.1785150424336;
        Mon, 27 Jul 2026 04:07:04 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c531afsm52462450f8f.24.2026.07.27.04.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 04:07:04 -0700 (PDT)
Date: Mon, 27 Jul 2026 13:07:02 +0200
From: Michal Hocko <mhocko@suse.com>
To: Barry Song <baohua@kernel.org>
Cc: Ridong <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Zhongkun He <hezhongkun.hzk@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
Message-ID: <amc71mHxPno66RtF@tiehlicka>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev>
 <amcUqfpjE9lnXkn_@tiehlicka>
 <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
X-Stat-Signature: joekimsgaq6tqcktmsir3jrq4ttua7oc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1866C000B
X-HE-Tag: 1785150425-590238
X-HE-Meta: U2FsdGVkX1+NcVQ1VUqkzzp0do4oG3eeapWjXo83NgULu8XO1U4XL9yflTaNJ2mWrD+j24IustbDDkS2/eDCUPO75hgN2xBufgYKIRLot2ogWpLMlVqfkfnWkYR1/PHxZ860a/TYPTLa8c+PPimR8EzM+bwPwn1DsEge6jNbzZ3wHKxvROMIwIcHoTEVO5J7q5oGpoSBhlUkqS3XAIfwAFNTvHdctYJeJKmFg2rfJI3hCkeH1qM1HYTt+vTDrVUrhkAiTn5mLITbs23APhuJnO2BsGpBM3amVO7UshkPsFNLSqF/3Gq1t15amoZiKJW6nsvKUbFUiXCnCFpkmGJ5ewTAxH/ZH0VetvWTaKvAesPOrX5npLSiFXDZabdCPu/C9lh/KtkbodY83dEdM6QEZSrKcYnp64DIh/hbccGladEefahOICAB6UniasL3vDC82zRIF+1qrVlknPW+mXW0uKlals8lkiMTQmGpFgJxByz+YVk7pn1yuSTBcnOQqLIDeb5Dz+aDHdLjLptVoF/gWcK5Qk32BRH8IlEpb8+LtGbYl/Va7tp9rwuiRUTq0ItriMPt4bE2JyrakwNOVQ9xOSSMqds4P5Q17Ss+0Lb4aGW/r4whvEtivQDB1d91ifjI8wqbHCJZ+Sd4ORzFv5DlkH8SEgquY1fWqMwZdb5+FB3tvzfbBcaMYUxyhKQvxgnUqSqzmeW33kC91CTDwqhzPUZTFzIi2N29exwEbvGao0jWB46kfDTNmC8fDRB6Z1qCaOWOHyOxBRFGShs4PS5GR2rtL+gaw+GTtLJs3hGBLBvam3hcS1dYBdFRPa3AfaJKC3Jfcs67d+ikIiuwGpcFiQAU2k7ecYs0vQPwMt4N+3YUlSXSgNnKfBhWWw+1C8Y4thNG5aJSfS6/yA1807OyMpGVFSAhxZGG5ZElE//5h8W6Fikc3s9EmD3WcxSdKhntwXhs1Won79DnLNN8G0a
 EMiC0pFm
 lQNO/Ip6FYk3sZPZ1oAm3Wb8WMhzyCD4WF0IbdOt8dNbOic+ysqDGjLc9vw6B376bN7SxFK+Ol9UvCrdS04HigIXO2wHVl1GzFtl78aKWer2oZFcA5y4nG9gyQ7YtCtJGIRoiQ6BZ7a/ObldNXR1LZFf32/DshHgklfb086gxe7oWQwBNQw7kxnL30GP3j9+JtiSDi6PhU5vkv/FvHeRmSrH/hmBzYAuJk4PMD1nzFe3R7J3wRD0/OO1uBk9tEWLiNXMCG5FFIT8ZsjsmeWSuB7iTYbZKvlxJM/7IxsBhiLMnnEvbPBaZmdAM4X/N13To8Lj+dPo5OzRelD8F/lRyx/VSSdBG8X6lLr3b1Uk2zM6e6swn+9V5Zuj4fm7xNlz7j/+3SSfdMw19J3+Y0T0WEO6eHpkPIZdhGSs6bNHqP0FpRE3zG2rN42c1J+0POnxn97dxYaabA55kEeT5v1Mqg1W4FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-07-26 18:56:07, Barry Song wrote:
> On Mon, Jul 27, 2026 at 4:19 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 24-07-26 11:34:32, Ridong wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > >
> > > As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> > > the reclaim logic is expected to reclaim anonymous pages exclusively.
> > > However, due to the current ordering of checks in get_scan_count(),
> > > file pages may still be evicted if can_reclaim_anon_pages() returns
> > > false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> >
> > But if can_reclaim_anon_pages tells us that anonymous pages are not
> > reclaimable then it makes no sense to try that, no? What do you expect
> > to see? An OOM killer?
> 
> This is proactive reclaim rather than direct reclaim, and
> SWAPPINESS_ANON_ONLY is only supported for proactive reclaim. It
> therefore cannot invoke the OOM killer.
> 
> If I understand correctly, this is exactly the issue this patch is
> trying to address. Instead of falling back to reclaiming file folios,
> it returns "bash: echo: write error: Resource temporarily unavailable".

My bad. I have misread the changelog and even missed the WARN_ON for
!pr-oactive reclaim path.

Failing pro-active makes sense.

-- 
Michal Hocko
SUSE Labs

