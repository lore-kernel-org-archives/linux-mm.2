Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC82FD8779
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C6D6B00BB; Tue, 17 Mar 2026 20:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844076B00BD; Tue, 17 Mar 2026 20:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780746B00BE; Tue, 17 Mar 2026 20:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66D9C6B00BB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:23:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D16A71B7C44
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:23:14 +0000 (UTC)
X-FDA: 84557284308.27.16839B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C24A20002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:23:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GwXgaV/D";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773793393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oVu9ksQNj/e5JgdTWpYKPNwUPUtNRXv9Wg/HKvtX4I=;
	b=dLJ8QLzJTHEfftXPoyQ58QZBnn9ZbAVgDsZ40U2bJa32EuUIgeOco9L0T2JP/49D6qbbPa
	Ju4EgrslBQmV4UAk7KjCCQT/mkT54RxJTy08G1LwWPqexU/RGTrFeSk9EDtUql9ZvskOqz
	/BDPc9FJ4fELLpZaLboCZ+l6csdxG7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773793393; a=rsa-sha256;
	cv=none;
	b=lHzL2ecYhmyX+r7cBbpN05yLb/M+BhVSmncJMX6AmsP35QWT3vPSIiPStSSsuUqo9dZ996
	gGFQbcMaL5nRnKTHLMuRtk+eJ94CuLtDRrX/yb8aEKShTQ5xSaQnobsesU5But+Lkhaq4W
	YOvjwSY6ePaSadw1FdrWXaGhcPqw948=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="GwXgaV/D";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5D8B42AFD;
	Wed, 18 Mar 2026 00:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCB3C4CEF7;
	Wed, 18 Mar 2026 00:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773793391;
	bh=7txtIWm0nG5xhM6ymroYqRbe51RMny5/Qco9N396igY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GwXgaV/DzwK5YTkMorJ91BlomO7YkdU7t7HMqUgBB8kNUQOK4IuavJVA/BGelsYLh
	 TviRFPmuC83Z35byGY68gc21sS1Gm64Blj9+oAsKgS75n8AdQom6UDI7pv15WESJV6
	 yCWgltJXZrVCtL6Gn3QbjdeclLWiilEBnVYLObIo=
Date: Tue, 17 Mar 2026 17:23:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, Michal Clapinski
 <mclapinski@google.com>, Evangelos Petrongonas <epetron@amazon.de>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-Id: <20260317172310.b99ca4afcd0e7f1c380c2798@linux-foundation.org>
In-Reply-To: <20260318000817.130248-1-sj@kernel.org>
References: <abniW3D8wbGQcB5T@fedora>
	<20260318000817.130248-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7juq3k3badbpozmib85jz7fkbzs5r91x
X-Rspamd-Queue-Id: 0C24A20002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773793392-908276
X-HE-Meta: U2FsdGVkX19ImF4mYfnv+QY2m0mH+Lb7l24o1FkW44C0+D/p+lgABYFK6gM9IO8o5GxrVY7JSosxMZqW1mAS0B0w9h/Mq0Cz5ORy0+6zj32dcB5hJbdeauwtKnKI+5bMxKyo8g87nVIWyqQxWuhUoqKuvGiNgyHTQLhzVoGVu9Bs+thcg7WZ8jx3Usl0Fy4RBI355xyROpx2xdI4EcgoU+XJIlw8OZ8M1q+BwqlJvnt+QqO+LQCm7N+MZRtA1kA4kGxR3K7ZP/RykKLU0ElqKb9S0trcdEbQoprg9pBHQfMi6fkZCcuKaRt+YDjYsFDHoKp/q9Oj3n51gdGGDiXluJLbcWIai+wIAxI3wpENpGDG9wts1lWaSJ8BTWTs1eecHAPWfrr5gBclzK5m17UyljqZGc+gBS6ePy8MZwzyyjXPizWcyTb3dtyB2VCfZPrJdihyvc1rFodDPZ2zurlzowcflurMPGM2aTvfv1iCgrTqmPzMXJE7mmxfolTiLJPzjrL6Yl8PemJQdzm5JB75DyxbYPt8EWEaHMl1TPbxOTosvIJsmQoCjJtDBpGihIBZSGe0t9zzOwozBTwWVBbbFmws8fxJgaKmn3PJ79YLUK9iExF4fRPzJEprQHkVgMAYto3cr+/uEqLT1ycO5MA3Cz0EV6bSyBJpQyhW8l/+Zvnf2oj7+OuXBOnWWBlIQwUzsg8lx/IHi43YhWk8LqvDweY0dOZtesBuiHExcakzg6hhjED4i4a+SpYPoXF89GbxQuknu9BTtTsc3nMs3IvnHORcu9HuTwvYlMYw7iJc47QAPSLCoNGOk+5kIJoJeGACSXCaP9jbpWTopMXn2miuSzRH9x6mrqxFR//6t64GrmsxOK8WOlKLGVd7P8UQbnL1mmLOF/BJK58LjBEjseiWuhNBNM8bdqwxAVI0ELUI4Gb2/46keBc40qFtftMpvbCQscecM6GtfJTnVO1djX7
 FOh6gqGg
 H4fI7MW27dj/KVeAAWCdmDJP0DptxuS7UORGNjX5PR+nBRxdBpVpd7dilYMocpfqCA1rOa6NbwDYq2NT4iPl71n/FDi1oV67w/VjfSj5AQN76vc3Lu0aQ0gOF9OlEHt++WOE+/mQgYB7xaFD2eI5QH/JAIigvFbbkZlJPhZ3zgrJLsDNWKuLzcM2mcLpPAyM+j6kTFGZHMS7ngke2Hwd6cjmCL/7UjJtVOSYuk9C4Dcin/THNNFfFujy0Mb4M+5w24iFmlupBfazCpXMg6Mu/sA06WwOzEjAAMo4m3dv0FBqY7FZ6su4kPifSP5bh2GqSAAHSvzBNyQPfHT/WsiFA9oTZJ9ZJtNAGbC3+cwlcArxR5Z2c9agx0cjyWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 17:08:15 -0700 SeongJae Park <sj@kernel.org> wrote:

> >  error: ‘MIGRATE_CMA’ undeclared (first use in this function); did you mean ‘MIGRATE_SYNC’?
> >   557 |                 migratetype = MIGRATE_CMA;
> >       |                               ^~~~~~~~~~~
> >       |                               MIGRATE_SYNC
> > 
> > >From what I can tell, MIGRATE_CMA is only defined if CONFIG_CMA is
> > enabled (for x86 defconfig its disabled).
> 
> I also got the same issue, and was about to report.

Thanks.  I dropped this series and repushed.

