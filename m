Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F683C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448AA6B008C; Wed, 15 Jul 2026 13:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA5C6B0092; Wed, 15 Jul 2026 13:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB416B0093; Wed, 15 Jul 2026 13:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E77866B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:56:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 647BCC0222
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:56:12 +0000 (UTC)
X-FDA: 84991764984.17.88EDFF1
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7AABB40002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:56:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HsdCR8jL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
	b=4Nt0Wh3KfBxxGkGCocPA+GRU0F6V4oa/iSpTOfrR5kJPorjhSWfWGMxOTmtTyetvyMXUh/
	ryjGIirscjMnH5SVAcgq2gOibjw/e0YuJtM+cTAIaNtivJjoDf0Q/kenKxFZZ4jIKHVAWt
	fUa1PQXKYXZwofW1C1LYCA9eVfRJB4M=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HsdCR8jL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138170;
	b=GpTNfdJ04VkEYAgOHAtaX8eVX/vnYwVyk1Y88IY+khwDxPfXkPHJHpZrX8YxeQQzXtxb7s
	uKu/sY4oTfp2rlhoh3m6+Yt0fGS5YWa7NTKoQWIuLbE/LjasS6jEvYIVTY4WGBWeweLSBa
	9wTQmDBmSSsoVks0FKPUg/OthVroQDw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493c556ada3so5515e9.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784138169; cv=none;
        d=google.com; s=arc-20260327;
        b=lW9ZYLMpVInFKB+kTznSclkQuK+raYFhbjT7qrFlq97D/9E43KNg4lCIn4umXmbgK6
         cVZCEc0mvVw9DbVLLHdgUrQoZciMdcGU5NM2C/7wAxdV5TPUOtWqXygpd2NO0Yc1ZDhM
         Mkt3L4zVTUOktlH/Q8hoyW78DsjcjFFrBPLAbcuErZdNSon5ZgWE942H0wMpDScoLhnK
         xajHFZdkFWGdNAHLzuzgPfaHT0ufcko+RMmdTcgK2LYe1XM4osv79VkL1MHku7peSZKZ
         QJU2EyFqlb+vU7ZEhcLuQAtTQxgIhEfijFGub6C2ZtWrAMPnH8icaBzCcTduann2fYAt
         dN7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        fh=9gy1tYFiOEQcrNsEgEZ7wxveCY7C6WkxP6k3E5vPOZg=;
        b=IkpFBynAindFfTHb5tCJnA/ABMEQu2LopwiuEgA7zILvitd1YATRUz7aWsPvdydtJj
         Xu7X4N/SwNF8GL3HQhbtUgdbDu1aaPqs81G/GbZZkd/LBG7CJ59/X5evUbR7FYvWD3k4
         SQcklzO3xhcmDWBsjfgbxzyxOdPc92gslZDNzg2Dd1Lwy0YUwfSzXHr7CmwgfOuvSs4U
         uQUT7tlu7fOPBoIn6qzsDeMq4FDDsd5Wxhyftk05tiehrfMAlhCadehIogSvKdSxYUJ5
         +YXYemCpbH92RtiNBzINFCjbu/L43vBmsdypcRwzL1mBAvfXN2tVf5d0yUcvO/l/bi7q
         BeQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784138169; x=1784742969; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        b=HsdCR8jLYdp0iEVsoMLN5uXi5teDvVaB6bmuI5omXUDUDbzGkGouEREkwcP/MeUElc
         cDsI88IL0frSfrPMG5b0ooPag6y2HAgcAQfeMmGw2moYPrEjsPzGMjJIKFBViyoYGySB
         3uhd+6SjoYzT6N/A9zqzsaUWShcqlaRPxeu4GDY0PiC7Ol4g1FQv+pzMwPhh6ZwpzZC5
         /tDJ/JwvXAS8GhaXi5HmxfzoGm7p63NUvF6Eu3KmPD1tl8x68XI4cOK0aQDqbB7fnNET
         GTq2tA/c+KB6wD4VoKFTZll3w1WPCMLQsIVzDfSo4Al9dzT4pz7FXv2HtsOfLHfV9YTr
         z3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784138169; x=1784742969;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RuBIyMRxxSG5xOKfBj9RRTURzzjnDkJEBKCLyFmN4sQ=;
        b=TLq6x4lm2PYHD0Sj+9qMZwXGvDnvY4c5Z8yHtyaxlzgNC1VzIUT0KWYIlfP0oacymy
         qyLMNpO7fQ4+TtwbPuvQKd+VTIe3qV85spGJWgNIfE11vEcIAeNAi41BxGSHCMh7IAet
         DaH0OUwOHEwLyVkIOONypiKVzwQJuidgpxkopWfFHVvT3lIOem5sP/LyAjbvamd9ymol
         0S4yxgdbb67iG/HKYdxv4DRl7gbUFd3g+UrD046zujPKXxTR8+YccbeA6N7jRGDccP+8
         YZhGTCctx0yvZ5nIlNsjQCCtX8UOvBbAI+2ku7gk81vrBFVQVQiz6B0gGTwX0mOX1Aj+
         12EQ==
X-Forwarded-Encrypted: i=1; AHgh+RqSaYptbM4BoeuG702YC8iysPi3DCSmra1qEbAEGbYfaGrhrCmHt+MZT4uFOQ+OMV0Hq7x6YUoZNQ==@kvack.org
X-Gm-Message-State: AOJu0YyQFQV9wNEfKOEMTry2Cnxme9RkbWeOaooWxREsUWmM3vNUalAa
	Bx2/8yTFke4+wSBCif6oFpqlHrGeH36wXAEdr6XDHdbG78BIjcvlvWYYBb0Nigyolw2Qspgz2cp
	Saz92BUQXv5L3H5xTqjT0ISlGvRn7au40EEmvkvhD
X-Gm-Gg: AfdE7cl6EBBMS6rahdoy/Nv2+t2r6/Wed0K6T/80EtwIHypg6eN9b0pQXmnuv+cro/g
	Ls4apPIhMVxbADAHP3q18RnEPiIzg0C/fStmEXwCNyNJnM1X9d/W7jgz+GmNoTGdeFi0QQBUfvG
	gVMooKWgy72E69OapGCd/Qkn771wh5SfJieY3d+8OAReTXFaUJf5B0WmF/fEZMbLP1e7deSb9T7
	jITaJ2l0TMeVmPuNUBYh4FUYzM+8s2dz2HdrpPFLsV5yotUn+svA427lQY3WiAqyzKXc95vKqcX
	Buot/Kvb37c9sWE5b3bPpByUj3Dvn8KIUY+/2YmOfNtvmjMDR0HuFWcSWN2bJJ379BaPMg==
X-Received: by 2002:a05:600c:4ec6:b0:495:4069:b0de with SMTP id
 5b1f17b1804b1-495414230f0mr128295e9.9.1784138168394; Wed, 15 Jul 2026
 10:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260714121529.2237261-1-wangzicheng@honor.com>
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 15 Jul 2026 10:55:56 -0700
X-Gm-Features: AUfX_mzAYIm26JZUendtoZyWaKS-eWpz07CFW-u1bis9rmp-d5YT8fcNAcUgKUM
Message-ID: <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, weixugc@google.com, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, willy@infradead.org, 
	denghaojie@honor.com, baoquan.he@linux.dev, kaleshsingh@google.com, 
	tao.wangtao@honor.com, zhangji1@honor.com, wangzhen5@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AABB40002
X-Stat-Signature: wp7g76kkunbznbdo4g5censj1bwdzcca
X-HE-Tag: 1784138170-982969
X-HE-Meta: U2FsdGVkX1+mn338QGnqo9yZeg8v6Bx/XVUW3FU1X9eSXm8FWpYSye451+47QXyE6U2dFJeuqsr/UWtVYiCYot6spNMedsD6SrFr9mr0N/WO4n1Z7e9MWiVXilzKHDZ0iUADbrVCEZ90raVhC9uRFKTqkDC8o8Pf0Xdx6wl6Wuhm+xh6WS7QSus4qfV6NWrJ+AZ/EaqXoDNJ3qA4Np4qzACVN0dx3v6zhDJT6O2PbsQWI4pnJ5meo22yGXB570MptAFC+eQ5kL74RfCgxjBkc/b79eGMjuS6hgoLMzsRPRjYpBCF0fGEgxLUEMMBqepOScZIgaQsHRonMF9cU7j9vLZux6OzO5xZZM3rCDq9K5+YNLEv+rg8FW92Qem5qAqHoNHEG4rLbDAwphDhOthKIyvsNzg8FXwy9f/uai+DjUvX0Q2K2eAqyrsDn+OvOHLMmatBjqwZI0T3rPdkqQHrgkr3Z71AxmteDZe3lmqcU+0fZ1hasEHo1idl+jApRV68OOP0BpXX1Mj9DhHqqM6lxPW/9+11oPodUL7U9NEexLgp8RITMwFAQMKd5VTj8nvYJfF2JabInxMO6NhO7KNlPgcBZ+i1xxc0J6SIlxlYVb+fe6zsvp4fb1hJ1A0jp1I6KnkZb/XXIFzPWqXn4qUMuQp0aYzXwSw5VMo0L8kgtzkBHBCeXPlhhESC7FNkBiBii3ShDDC+mjd4cza2spFOeAgFxYfkV60xLAhL7p6VgpPlaKOqJGDQe4VVecTguPRhHNBMm14gKVeXuxfZWeYVIVQPuZu7jwizSqZ45eFjpjUZUQSqjzxMb3UDm+eqSHHFSFY9gW1sLxV+SYPv542ynAbxIL69Pkjl2trHD9slJYWNWnSbpC4luFDG3vxc4S6m4qy7ue5DBvqrZxQ7uFs4fsHvTB/3Ln+tOYuwgyO6iE7Z42BQdZRvTiB1kanfoFJZAI2Qsn12ka7QdB4FL41
 l1rk1912
 eWh9q/wObOkPOUOsEzS/IqaKE8OX4kAUpTFs9W7S5DR8EMMGtwlwA1F2CX5bpwH9rS4m0U6sidog5IsIEvuxOw/E8e7xuZBdr6np21fG7JLHnq3KU5Es9nrKpfcXAUJ5bjss/QToJFpZKFIjenEbvnfaBe5lTdRNCVvRkzAcQSxWeGswYEPf+MRFcnFUdFE4jtF5pDPHmPKuCtIaIcilQOlxdJaCwp6o6h/wNKlzvGrnrD/6MV0eC67/ROcfgSF1rlCHNYsbgSTkMrqU93x2VP2HRr7v1/hIC4W4eoW/PHhlRBtG6CVh/+l9WyJ6jEz5TetTm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 5:15=E2=80=AFAM Zicheng Wang <wangzicheng@honor.com=
> wrote:
> The benefit is workload-dependent: file-cache-bound servers gain from
> aging, anon-bound servers do not, so no kernel default is correct for
> all.  The kernel also cannot know when to age: on Android the right
> moment is the foreground-to-background transition, when the app's pages
> are cold but their PTE accessed bits are still accurate from foreground
> execution, a framework concept.

When an app transitions and becomes cached, we attempt to reclaim its
entire workingset. We basically cat memory.current > memory.reclaim
and freeze the cgroup.
https://cs.android.com/android/platform/superproject/+/android-latest-relea=
se:system/core/libprocessgroup/task_profiles.cpp;drc=3D65bd7ab941a709bf0498=
71406981022b988e1721;l=3D706

File / anon balance vs hotness and generational placement doesn't
matter in that scenario because we want to get rid of all of it. So I
don't really understand how you'd want to use an aging knob.

