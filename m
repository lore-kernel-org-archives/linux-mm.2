Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EF3CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93146B008A; Wed, 13 May 2026 02:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AFA6B008C; Wed, 13 May 2026 02:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9546B0092; Wed, 13 May 2026 02:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC3D36B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:47:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4685140754
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:47:20 +0000 (UTC)
X-FDA: 84761465040.28.C74438B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 488DE140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:47:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JBSWE+N+;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778654838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2g2BIMhP1pLlqkrEASLiC7ivBcGm/mtdCu11mEtx0Q=;
	b=8lvAC8ACrQ1/n52ekqHiNjCnAtFws8CxZ3TPCWSW746nEMzat3EQZ26vFe/vcc/KJl4oaV
	sJbl0G3qFXLnbXCEC7rIbzsS0DEelGvMIcN53rAbp2cqfuatGRviZ/U7eqsigA2zAyL36o
	E4AeKl39F2bwZdhRvjybuDVZw9IyHQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778654838; a=rsa-sha256;
	cv=none;
	b=roygVsu5GuoIb4LBTXEntqSR1yT1JCh+Wp45DPhfWpzWQQIP/cs0N0VgE2LwYUoEUqJLJh
	rfbeC27gjMFUADl3EyA5ldghWr33Izg05YaxrQ6bBPlgNzBtXXrsACa9emkd6wA5Bllso2
	qPQ36d12IPCtSSvD2waHb7M6imjKZ+k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JBSWE+N+;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so67376015e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 23:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778654837; x=1779259637; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f2g2BIMhP1pLlqkrEASLiC7ivBcGm/mtdCu11mEtx0Q=;
        b=JBSWE+N+hLYmcI4aFv87BsW33DnO39OkPqCANRk6H2i4VqY3437Aj6ReJsdtp0mr+C
         EjXgI2TdjX/+mLVP7UeaPyBfnDTvItspKClDnLx1Ac8iv5wmRJoyM/FN4N5Y8mubMwoS
         OVsougTs0E3Yn2v9knoCCK6qyP7+AbnrgITGpzPN3qOLmkODagpAB2kokU1RAfZJNEKM
         9BjRmRofxSsmfxaTW51Oa+YGaCz0Gxy68Hm48ac1N3XIUg1oTdWo8+VstZTcTKhyJ0Eb
         DSiYhjs9pQJZH9qgSXPT28KUD/shy6nGAhMhHzJ+gSfqZ8lm1oJq1+preKSW1HAeIsJm
         +nKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778654837; x=1779259637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2g2BIMhP1pLlqkrEASLiC7ivBcGm/mtdCu11mEtx0Q=;
        b=ggzQ3aZXlB03rZIiezJs71IFmI9L5tLhdtPoB512+eoi9NHNfHkMLio+edVuCbBj89
         EArbEAw67372oyW/5sMyAujbdVmEZcpVQtmtVptTYNBG3L1cYBFuWPjzoFWzbf/a/OIT
         28NCGrI1CRDeczzbM1eo6jGfIVPW1nCVzzOp8ezSuky9l/46xuQQZEmso9f8hnIs0tY3
         eXjcmlw48DJ9HOlKfPbQOa39SIZomTBI6Y4ZZu4gRSkjbEbKIusizcn4AJk/l1kETT2E
         iGw2wAWkUHZcKRJQiOBPw8jDj7E88s0ucjkFhUL8R3xq/zi5A8wDKmF5085l8VMLNJpx
         s8pg==
X-Forwarded-Encrypted: i=1; AFNElJ/w5vdkH3N6vHJFN9PqIj70Qrr4Jv8X8mx2NeiFoTCRx5EkAxOn70HeqjZ5wyKRguuY9qDjN1kLUg==@kvack.org
X-Gm-Message-State: AOJu0YzEscF5fxUNQfNjsSaam+gDFwm2Gs2Ihp73amch6fkQCICzMLPW
	D2oc7P0ZoAzA+qx0ohcBeroCd0qrOQi53XBESE4YTwYcTpYVsj3j2/LDMJiz3rJbHko=
X-Gm-Gg: Acq92OEkNJ4U2z9vhv7Se//g/FQZnwQRZvigpDokuzBADppJnl0qiymDbaos9XmRHW9
	6Olb7EPfvEx/peF2P8eod2mE6ce03MSgpy8Y9IVvPUBywIoR+lf/AIQI+wnURt9MY9gu+LRGEf5
	WtjwJ3jzCZVnaYwOnpc7FDjCZ/yzw4j+jJ6kCz0kTYetBJ2cb+6lEYr7E1G2j3TE3ipYb5IQKgC
	uW2rVGXqEgStdJsZZoPdAhL1K7tU5N8EDEM5g3RyLaFTDgAGlC/XB3XczuNaejVj0zgcwYN2LAG
	3eOIxFmQoTebSMCKD5jEBFaHAlrEuGwHtn4Mely1tXYczfALrSBcvSm4yXDWGRoj68KBuk5qES6
	kGZelxD+b2rnns7Sqb3ok0Ngb2XvGBk1RH0EpbpH16Rjt7VBpKOwSCHaVW6g4/SPDmKPIYI1u4N
	GzyihEjSCVw/GOQh481KNOJsIZSl0KQpP2e99V
X-Received: by 2002:a05:600c:1910:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48fc9a09cb7mr27643115e9.10.1778654836793;
        Tue, 12 May 2026 23:47:16 -0700 (PDT)
Received: from localhost (109-81-93-105.rct.o2.cz. [109.81.93.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce38328esm22796985e9.13.2026.05.12.23.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 23:47:16 -0700 (PDT)
Date: Wed, 13 May 2026 08:47:15 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	timmurray@google.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <agQec_L2TXtaXOEo@tiehlicka>
References: <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
 <afHeXY-yeTwmURWh@tiehlicka>
 <4a612d63-2838-40f5-ab67-79bf35dd3a56@kernel.org>
 <afIZQOtaBabeHtCc@tiehlicka>
 <b2d9fe2b-abb0-49d1-8056-ac93aa232bbb@kernel.org>
 <7g5g57jbll5joujbwjb4osqhdwqd4yzc54wmoi7ftx4a4chuax@xtxyljtqaodp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7g5g57jbll5joujbwjb4osqhdwqd4yzc54wmoi7ftx4a4chuax@xtxyljtqaodp>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 488DE140002
X-Stat-Signature: mj7wis53j781kdph4wydx1xo8j73hiyn
X-Rspam-User: 
X-HE-Tag: 1778654838-360137
X-HE-Meta: U2FsdGVkX1/UVZjd/b8QNz7w9UQWKYhEvdhMdSPA6KY+MAPahmtP/g8xRVbrSsUULJjkdTbwbRLtqR5yIdIb1oLfyLa9iK9nIy40rERy9Zi4Ilqd56wcGx3bCdNwmQGdHdEOr8u3g+eTcQM26jM3cdtY9/yYbgTmGCQSm4uvFUqTi0WtEMWu2XxKWwHRQt+HL/mjQsjX9Guv4xMKx5ABFlLWdXEIskx/61u36AVONCrTbasnQf9I3zL5tEwzEpVUTs8FCo43kbtkJ0N4JzmFupsL4gVolI6co1pALVvI2SqVLm+b+2Ekf+Lt81oTsOTFz7p9HbgNkHXELi4z0qEtAqi0TS6f07k4MviRx7WZIitWqCryo++yWsEZKydSzuO/GxHyhLMByaKOKZali5DzTKmagA0ZF9KKkCQ0YENONYtEli1eJqWNELrBYPhNyw6ZZgJfGajaXatg4oHxqP0gyr6jVbw/5J0QW/XVwjk+FQ7bNMwvCZgTlz7eyaIz5URuuWEre1T5woyaRlHRwb4+ErkYxNVm5KqmPVUuDh2/4iyuXVdKsbnZmnlMYHVgH1dZkWVJZTrOqI6Sf+Api8svKmN3wVHjuK2F5luMudJR8AX03yq8eCkNeqeyE9kU+ZRIXuNg1sqTfiN6Nic3AMP1+ICSv+Z2rG9ldCdzk9X81huqOkTlrsJiEAOIHcrjMTDZAzgR98+e2yVc97+CcIUKUGRkq9ZF77kF+2cl/UY7RKU7b3WAmzw4hNtxYf0Sm7NCVWACPTGilIyzBmNUKq09cv/BcSBj2TSlNom5OIqfoTm93O/HhxeZrgN5zlGuSA685vVklGrX5czXSV0c2wmS3FOwd1WEcjpr1/diGeJMDaKICTiVz0iUQd3+LKoP+S/cyr7l0ibDXlH5IUtfedaTN/3ELcSN6C6LY+Z5r5lxX7N2WXo7HJpwDlrYKo0+qObg3/H7cvTbHo+jmzdF0EQ
 YGtDk6EP
 lA+XY1tXuiBMXZNBN5vW2DR8r1dxDNf3Jp+AbFFduQNgeamYG4Qt0cYFTNHrUSR5sdqpSXHSuH58qRr+gdxZQASvpStIIDqkL2Ph/dgy2sPqGNipC8GWapp5VVxkgKWR+g4Lv07I6RQa2BhYsaVxBQGeGSWCM1MgpUQTnwD2X+UyghZh11fnCG/oNIQT6K16At7xZSBg9AMxE8Q+ujnfRyG2t2w6y74FdQaWuDwLH1mZNVrATKEFL71NzLEl7+JjY6QWlGHZ7TZFhsjEtCasEBJ3+ntx2Y6IAlrA0YEoQNpr5TbwGFro7d+T8rO184nqCSb+dyg6EMKdXkcoAzDeOJ58usYys2JmWXeAGQ4Eg5G8CElo8/joyJYPpLqR02a2vEbnheyo2NEi4fJwOqKOHo+oNvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 08-05-26 22:57:31, Liam R. Howlett wrote:
> We can safely drop the flag now if you want to, because everything has
> to deal with an empty vma tree anyways - a race can occur between a call
> to unmap everything and the task seg faulting.

Let's just drop it if it doesn't sever any real need anymore.
-- 
Michal Hocko
SUSE Labs

