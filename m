Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35294CAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA358E0013; Wed, 24 Sep 2025 22:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B2A8E0001; Wed, 24 Sep 2025 22:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F618E0013; Wed, 24 Sep 2025 22:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 435FC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:15:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0AFF57CED
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:15:53 +0000 (UTC)
X-FDA: 83926156986.08.054D028
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id E15EA40006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:15:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FyZ34axP;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758766552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhiDq3oRyeWoJQl8iGmzUt9VH+oSe7KCtXZQhcEdjgY=;
	b=bp/l+Co1phCkltMK4hV5JjCbSdWRvGiMjEAHQQew7dnOWPp5k0x7AUtXbu/8eA0cfSwNpk
	9EXsQ6fGtEkGDD5tp/85UQl8FXCYdpYFdfLJ8RYVEw4LJEdmsKS++bxEHapibPf56DtpSp
	gKbhob3MYjI6sUVF4eZLCPMlssi/eHA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FyZ34axP;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758766552; a=rsa-sha256;
	cv=none;
	b=1ncKEGkc5Z/I6nypPu+ZDgmalsUDocwjjPH/0yo0B3Ou5y7EsM+2Y7l+O0zhyhDkVEu5EW
	gGXCkldCNxr9qiARNEevoZh0eB1aJAxKUSNB0ycUCrhEoE5yp0T9HYawz6QxXf0Tv13PIW
	uzJY+ui1ky4Osr0VPfM4EwiL5Xhnf2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758766551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhiDq3oRyeWoJQl8iGmzUt9VH+oSe7KCtXZQhcEdjgY=;
	b=FyZ34axPjCP3DwWyI3ge58+fGu7+zAOMRJbZL/4/K7dPI9QIwAZm2LTsdYq1/ZLucVnw7H
	RlXWiGYDUpd+Ivsixhiap7WwD6/DvMPhLLhJ7hzRnrxKx+9ONWnqtdSx0/HcUIeKN9ocXk
	+vjxX7qytmFoztnBvBFSMwlG+va8ddg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-FSD3UVg7PFynmdgqKiLj5g-1; Wed,
 24 Sep 2025 22:15:47 -0400
X-MC-Unique: FSD3UVg7PFynmdgqKiLj5g-1
X-Mimecast-MFC-AGG-ID: FSD3UVg7PFynmdgqKiLj5g_1758766546
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F220C19560B4;
	Thu, 25 Sep 2025 02:15:45 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C550E30001B5;
	Thu, 25 Sep 2025 02:15:44 +0000 (UTC)
Date: Thu, 25 Sep 2025 10:15:40 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	YoungJun Park <youngjun.park@lge.com>,
	Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNSlzHmwWWZhPK8K@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <CACePvbXz-JQoC40rLzxQe+dvXe9B59sz5kt0eWDUZosRmh3d8A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbXz-JQoC40rLzxQe+dvXe9B59sz5kt0eWDUZosRmh3d8A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vc6nR_KpdOzlXKOc1MXlOT27v3zkOxDZO9CN3jukQxA_1758766546
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E15EA40006
X-Stat-Signature: onhsdj7w3aq1iumjkfks1phrnn1eihsf
X-HE-Tag: 1758766551-343157
X-HE-Meta: U2FsdGVkX18wGmCc+jFuSUiIgq3Rr6YrbXS5DQIhnwQCWcsXgDyyQuJkXrQqRQBcapNkFiOdzjObbLJtJhU/F/OG84c7H+0dwNnqFX122ItaSiWg3+UCs1h5CduAsDbXym1ml4aDyR6CTpvm34TrBtwksOii4/38jcyLjJoF2TQh3eT8pSr4JFiaxNZuLyYJp86l+YoWDo0/AY89FRaiy1sn2PSHIvPQT0QlNmUDY0HTsMGO7uJfDieqi7hy4B9ZHsl52ADCXjAIpgog+dzDaj4WqfgMLECSZlbup9GOcvfbCqAbyBG/tmcc1qtl5c7u+t8JihJzQE4ICBQYlvF/ro4qE7TZC8fHCEyjU0Xh7vwSmGH9lNNKamggapWWsr9Gvm8Aj4LoH+4C/E/FU6LBGjhxDIB/bdx/71Jcxx0pm/TEsU0X+c4w15ciX3LHtElr+GvaE/sk7Y6c1wnGt9ziz4t/S7DY++vRwFoOj9tQbm66rXMF1iKITrQA8JclH1AEtQGXgT85NCaN0s6M689xkuc0giGF+QLdczxaGjwubJQ5ophwx9DbV/mjYI19/XuD0Vetdrg8qTwJNTAtPTgEZ00yxWh/xywc6y0Po7FyhghobGjMddLHtCeZm2hciryBtP5Q98UKmI75OG4WRwJdf0c7x01RlR8jMMZP6alc9viuqP2UudrTTiUv0aZCkM4/+/DYJu/DaL957bWkg284w878IzFb9W1zAfGz6afYOFvoCupdfwG9NQfQAtihkFy93EXECSUUYum3jWm1pgrOM+7xEApMuE3eGCK+k2aOd627Nq/DVrGpT7doi22scXQ/G6vpFnngKiu06JSH0OP0OGMx1Wdqss19PL0Q+UR371YmnDQWC5qHG+GmQ3uM0cw8i0ihXHAGUqIK0MuaW/jVw9hVCJYzVWPPVeeCyZZfXciCn1CGlBZim9DrTMVaxWl8emqeLasy4wB8tsTreib
 TTU2+LTW
 qEtli2kyqBrtBH0GXUkLlQ15d/TBN3uNqn17UzZP1GRhmUTcqWRD42QF0Ke/FddDiyQkHrs3zammneexx3ll4TI26qJMYA7xOcEgsrneknpooVp5rtbSzWLAdWApnFu+tsYoc9FOkrxA15QnBY/OrL2RDvVV5JIrszRC4TPk4FbmJE3R7gHkgtM5WDPx2dZ6X/zO6tUMyjDhHSpdn8gJILzDLv0s/8pKoAu92qaOHrT3SMSfEga28WsYCJQ+uaa3Asm/4/B830Za2RBgmuTYoTQLA+qwFyrE96GKkiwwDWyqEhdbziepb2osAq4CD1QilE2XmZ5+8SuJxaAcSPl6bJDbQx92UGT8xkKP/1jlYegWdoTveD874MvOoctNW6qPM5VaJFnP8X1rff9cBXlzjTnGv+JfnpJt4zACizE2SCBk9qANGUuq5RHduro/yR1MUwYacvUMHRSWTAfUDh+ZE7eh8yfo0XHb7+F5sZCNTrjZ36MnQ0dP6GDYbjx9R48VufTnXT4PIWMgOkMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/24/25 at 09:06am, Chris Li wrote:
> On Wed, Sep 24, 2025 at 8:54 AM Chris Li <chrisl@kernel.org> wrote:
> >
> > Hi Baoquan,
> >
> > Very exciting numbers. I have always suspected the per node priority
> > is not doing much contribution in the new swap allocator world. I did
> > not expect it to have negative contributions.
> >
> > On Wed, Sep 24, 2025 at 2:18 AM Baoquan He <bhe@redhat.com> wrote:
> > >
> > > Currently, on system with multiple swap devices, swap allocation will
> > > select one swap device according to priority. The swap device with the
> > > highest priority will be chosen to allocate firstly.
> > >
> > > People can specify a priority from 0 to 32767 when swapon a swap device,
> > > or the system will set it from -2 then downwards by default. Meanwhile,
> > > on NUMA system, the swap device with node_id will be considered first
> > > on that NUMA node of the node_id.
> >
> > That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
> > device according to numa node")
> 
> BTW, I noticed you did not CC Aaron Lu who introduced  a2468cc9bfdf. I
> CC him here and give him a chance to test it in his environment to
> defend his patch. Please CC him on the next version if his email does
> not bounce.

Sure, definitely we should CC Aaron. Thanks a lot for noticing.


