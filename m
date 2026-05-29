Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84FEBCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA1D6B00E5; Fri, 29 May 2026 11:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992806B00EF; Fri, 29 May 2026 11:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A74D6B00F1; Fri, 29 May 2026 11:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78D496B00E5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:40:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A1B1C0A5B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:40:52 +0000 (UTC)
X-FDA: 84820870344.01.5F1DF8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 56B7F18000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:40:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUNwOBtd;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780069250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAYoCu/RXfyftNoJ6VS8vSHQtBSJuT1PmOIzykcmtbQ=;
	b=UK4/hOoQHIFb3iy2fRCXt4c84XOz2Ie7XiNWxW/BHG986ZrSIuaYKEUqPr9O2RnxgQAk+Z
	I6IsXCJ3lIJrBHXBeFncXotpFSG+kGNwW3WXCSJ59CkKMDug6YyHCJQJC+wK2j4/0486LX
	4iuYLDolxAWD20bw03DD+j7tny22tUI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUNwOBtd;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780069250; a=rsa-sha256;
	cv=none;
	b=JW0delGN9V98IrcDHBbGQ/g6Z31ujL1JE1DCKoXKRoPMdeVwkINjrTcM9rqQZJUnRsVWQu
	1Pu9+28zGchlRnDhORJMS0egxHv8uNN7a0XoeBJlmIrXXTJcMz2s5qsyeeJI47fZbEgryg
	jZ4uC+SG0Ojn5+t1oyPRSgdUKdBeccY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D9B44550;
	Fri, 29 May 2026 15:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC151F00893;
	Fri, 29 May 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780069248;
	bh=hAYoCu/RXfyftNoJ6VS8vSHQtBSJuT1PmOIzykcmtbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QUNwOBtdHlaVN6zntNCHNfsn9Ya0qsXlEmh52j+bxLKsBC7DIzIhnvBoM/3IgCcca
	 SCvz/Xu9OuvcHaAxbRg085ySDA5hW8nz97lugGsuVBxcKgxO0GYiYRmxvcuKmWaXGe
	 /yCDUypGwkcF+2Nio/qTMTlS5VxsGSXdcEvsi7O20rDRUhEG6P6txj3YadQLjzqxAa
	 SWQqIOHjkCz1TNbdHPsMERpiVQQKHfxRiuXjUNscx6ltv+N2VO6QzSyvNZP+YDsMHV
	 XYgxVmHVu1BvYKm/VTdcnV+jNFcB1EB0mOjWOr7ioAP8W/elBicMpuRwJrXVyYr5Uj
	 Y3d3AMnr7Thcw==
Date: Fri, 29 May 2026 16:40:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Barry Song <baohua@kernel.org>, wangtao <tao.wangtao@honor.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahmzXSN_sQYmq2Jp@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <87qzmu2r0t.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzmu2r0t.fsf@trenco.lwn.net>
X-Stat-Signature: 68t1t4d3tdn5sssjj4d6iy14hahi5q53
X-Rspamd-Queue-Id: 56B7F18000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780069250-355399
X-HE-Meta: U2FsdGVkX1/oxC+szHe4yDr2YNwX52WmQV0ZorHKsP37QAPbk5TnF1pqWztOXa2X3PX2qNUd0EAZiqp3n5p3CvhIFv2iw/A8XktbuuD7X+zU0rg3fA35SWQnCOhghLvo9UaFSCExAzXHKspnHeT0a9N0eEG+6xfRtPT/SMzpdVebUxrKPNpuh02Nrf/OKoVkHAp2JTm+jgz8oQB+d7/u/0zSrY/fTDXX+IxU646yFT4IkNEfMSbrZh6WH38tMgJEtXWid5NX6W0MEyj40bw8OuJwfWWZsWFkysR/Lh+eO2/0mKvKhxZX/jKAQ/Ak6q+vn5VHTT6jKPuBSDc1BfNUMvGyChMMzd7+zcgThpzTro5xaQKmAbGEuKckLRFRWw//6+w0dnhF99x/ra/P6Oq3AMQrdVKuhgaZ9W2Ia1a7HlVF9z2i0JeiDbpxQGL/5BmNCYBHUsSTViNgk+HFrjTkuwyFWXvViCkNQVM5F+0eZ0SOzlTu+HXYK8sLp/xqTNGLxiKmikiF5wG9zDrXoWgyJ1rBZFq1EmZCPRjjT8hmCeAmVFsBuBfdVD7L8zdv2+4XPyBtF/whsmzv0VAEEDVWz/jozAsAQ89zZBjN5dVkHaHs2oUHijK3BfhIhD6UNbKUgaZ5euiatCwInwyIeRZwcCeNa3hXF7h4Vs6i0OCc4RQZrZeYX8SzhcNnqLh2qlHY5rZUxWHozqBcUfwYe6ktcAdH2l7h5vhU7ELix5srpjNeQ2jX3DY8RMgSj+FgC1o4J36d4cPvkYENkQ4ElA+rmGkb9LLERZ24JpkKiJn4YaZ3GJH7d8u1zyrIytEh8RaSdMkoadkSZ6w0PMXmT/a3RKiyCdCf46S80U29DQHRCoI0pPuc1QNM+SwpXK/q6KS/LYNqQgUNZwrHDzW+FUhnxbutm++Dbw/imDgO3/yuAfaRZxWdQWSf72Xyc56k2oYmWIbAz9gA1kST8VQl7AW
 pLGU0qGi
 FZjqKhhVpRagzUvuM3FGof5cCcH/XkYf21W2brusAyY8N4SUQSNLxDK8esRnPQfYH3HNpTE7bj8WLllo6nacRT86xt+ygtAXS5jKbZ7J7pt4IAu7N8DMD2+6jheb1yxyNo0h3xrdYo247kzYrS+zr+fcsw4BLT1mPymnGPkC4d9R7U87LAuZuvkvCZHJgskPq7TnpPam5RASxIrPwf/UuDC4aJNq79kIxvxSuQFzbjRxRvy2lvGnI1IoWLDvJo6M2bIiJsA99Gc1VBiEeBTieJQlymKjpYCmKF0mjIASGMrGRZ6y+bJjfuiMaYhoBbRZGx6qb/11JQhniALxBcvL9R6KCqbK0uApLNmXHvITIOiWw83c8gBr9uI6HYIQX6EN+irB5RsQ5Uw8svmeXUT/95zgerL4lG3ptyFpy8WCvSRk85to5z7CzN3syaoS/rR+U3S3pQc8e1TFNqgV2bTzSDt1g2D+zJJaYHlzmNIP4bYjM1Mn7s0uIyz9auQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 09:07:30AM -0600, Jonathan Corbet wrote:
> Barry Song <baohua@kernel.org> writes:
>
> > After coming back from Zagreb, I kept trying to find one or
> > two full days to read Lorenzo's code and slides carefully and
> > write a blog about them. Unfortunately, I have been completely
> > busy with other work. Sigh... we always seem to have too many
> > non-upstream tasks.
> >
> > If possible, I'd really appreciate it if you could take a
> > deep dive into it and write a detailed blog post. I'd be
> > very eager to read it and better understand the overall design.
> > Otherwise, I'll try to find some time next week or later to
> > go through it myself.
>
> It's still somewhat superficial, but in case it's helpful:
>
>   https://lwn.net/Articles/1072378/
>

I found it to be great as usual :)

> jon

Cheers, Lorenzo

