Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B999CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72076B0005; Wed, 10 Jun 2026 23:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48D06B0088; Wed, 10 Jun 2026 23:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F206B008C; Wed, 10 Jun 2026 23:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A60B66B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:07:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3515AA0433
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:07:19 +0000 (UTC)
X-FDA: 84866145798.09.139F765
Received: from outbound.st.icloud.com (p-east2-cluster3-host7-snip4-10.eps.apple.com [57.103.77.241])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58BAD4000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:07:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=XGk4vt68;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.77.241 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR9rA9esu0iliN5yGWr1FPqyih4JUKJfymIwDR+FUJ4=;
	b=QOvfYfTfV7fetqdyQ1I6wcbOtGoXfJ/AWGWEx/PcVWQ203HMMEgoAkuK0lk5FcnnBZsR93
	z6V+rxM3nYhv81qXPWhDxL4zGnh+9uCYJA3hY6JQyaQ4aHljhcogFhFAigpxuYrPowVhrl
	Jy79mczqbbdZlFKLaXC4kCX0Nd62e0o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=XGk4vt68;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.77.241 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147237;
	b=DaF+CmzI8aSvfaAA3Qm3pGTKJTEPKylLCjnvQnf8tnMPJyHG9aNa2kN4LgLIyLH1/y07p7
	XS656UvNK0n1DoE1g0+1tX5MZ/TXAvycIh+tK1wnL4cuBd2ddSZqtvB3EMWVH8qtsV48N+
	zeLJmuSCCTUaG48NhToYB0QJUdXdS6Q=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-11 (Postfix) with ESMTPS id 854E11800A39;
	Thu, 11 Jun 2026 03:07:13 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1LHVwEWRxBDUkdXwdLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAFhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWgJaM346TB1UWQZZYS9wOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1781147236; x=1783739236; bh=DR9rA9esu0iliN5yGWr1FPqyih4JUKJfymIwDR+FUJ4=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=XGk4vt68WHaRepxVfYxkj6sPFUhRhLZyQXEpfQJRsi4Jj3nexxh91QZGg3jzOcFu2RtJu25ZUgFc8DJsfq3cEuM6em0i+vSm+ef0vPa3pCLnn3C0cgtb9/M1QoxiT6uFFGM2wMBC/f1L7CM6xLSSsD5hA2upnMCz11cnUF3CCDumNBdeuEu74ciYCph0l4uANV+7G7p761e9n+pLWePhC1fWNmtRBW3LAWpNzBpURBM7rTpYr/j7ak6NHeGsF7xTcsMU7JD3yB2XQZhNYeWVgRBlBh0kOnLCImmnB1EquR/D6fH/8WpM1oDn+1W9dxQPX+AkU2cU9v0ede3aHb+pEQ==
Received: from localhost (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-11 (Postfix) with ESMTPSA id 75ACA1801110;
	Thu, 11 Jun 2026 03:07:12 +0000 (UTC)
Date: Thu, 11 Jun 2026 11:07:08 +0800
From: Luka Bai <lukafocus@icloud.com>
To: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <aiomXLJueg412S_I@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCLwS=3CY48oFDMUsHEkBkJzLWQJke41PMQE65k2DdR-g@mail.gmail.com>
X-Proofpoint-ORIG-GUID: bhYhe1uJ6zWTASMBdTQ8OBD52VK6XAjb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAyNyBTYWx0ZWRfX4A8og/zL713X
 i3EeZzM4ik700V+dOigjF4cL6L+ZNQ/Sw5z1ZtKrWFOIgQhs2HNg4u7j/4MBqZGmqqMHSkyDGYg
 5SF2Cr4jJeW+tTWsbHIi61FvSMK+OQrwSgWaYcNqHYROnVmxNJusMjs241S9rw+a1BDhy3k3HIa
 9RZC3ZJ3HEBLQGnZVaM5pIUdhymA3f+ocFEZbFKb3YK92+yldQ5w+gSLODfQEYWKz5RmF+OmA70
 C0hTqHBAQ9aU3Ekiz7h4fwITr5XTtB6+FJKJjqZ9kdIQMS+MSO/PjsFrXP6aavrEtdiDTJSQyXD
 bSFkQHus01EypXkV1504ZeNnh7wgl4J8eN1FPTwzl5ThlIjbUlEgwFbnJ2kfVQ=
X-Proofpoint-GUID: bhYhe1uJ6zWTASMBdTQ8OBD52VK6XAjb
X-Authority-Info-Out: v=2.4 cv=D7ZK6/Rj c=1 sm=1 tr=0 ts=6a2a2663
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=2zQBIblTwxlO62FqpO4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58BAD4000C
X-Stat-Signature: q3jp9fq45mis7j1d955d1mufa8qtqjxj
X-HE-Tag: 1781147237-98733
X-HE-Meta: U2FsdGVkX19tefBI8vPRJLK0d1SXgin0VLuy0pN719+TYW5+KkeMVJU/ykO8DyZucqYr8mr6lLPMFwMsgivyxKzwe86TcOgOO7czn1ylhBaZW4VvQynDG+nOIYy19wReETDF1uS6BCZx2tPYdFOsKyWfog/cyJevSXf6wpFfQT5ycOGmEHT3kzIsa3tjvtyf9+xf1WWTQcNsZ3gvVretyuXT/mhdzT8+P9nBm+U8+MvcURKwE51bfp0OpQL/as26Q82u5vFJE10XeDE4pYAmCYij1bg/N8H39QoUXhYK7ida3coAo7FP6rGhs9uOHR39GoDAUKG/t0JoD2OUDuenzCLW4KJCoJmQUOLMB+ECi1poBqiP00atY6XMdHVXX7ayW5olLVgoXdEpoOrCFdeoACX7ZJDQtL9T/b4B1w2PBm7ldomvBefxZgCvxsGlrW9bpbc6Vzh2VoW9ZYwSegeTV1dqWlS/B4EpBdjDjM3XfOQc2WieI38DHv85i1Tl1NNKat2yC8K3DK833FUlcMPamElK1p7E2DeLHxQePaB40d+AqwzqawCXrJiNLA9IJ8w336e8T9dJRSfOYH8/2hyTZdNCFRCjKRe1bwuzQ8cPHeMump5cxGSwvqQLfY4x6teoYdEDld7yREgTRFF41Pe34jgR4L6TRZJPBngbiMgg8DHDT5Yqwkcp3g/PjFvGqzZ2BKi/KorYc2/NAFCQOoDHC2O+toQ4cETf51n3ic1WiMfw5UZKX6r0amMWqfNtj9Jq1WyFpkY2MBQhIOUKUB2dnZzOfZ3mLWzk8RqGIgpSfwvh2BGfrx9y1KIiTbb+JA57FF4l/Stmz49EiLvJo0P2UbD0zPO0vlIH16h9eoW5xr4P7D3VKRkKTGyhSCeMUlmbyfiVcinXITDZDwjMz+YiXV0d9EBFKJDe1alv2pWyCw0P7RREujXJG6QHOGmTp5hErJ9kq5pQaNFFTGO2ltQ
 SGK7To2T
 aei+PQQ49rqW9b4QooNX9chsIEi/S0jpkz2pNomGSfTryNeoYnFWaX8VPMVhcQ/1d/fyPxpHaBNeZZ3F9MYtdmgt3Qkh9WAwjMwVX8F4Vz2oafAcpeSPf85Rr6uVKPezRp5ybLeviB+L1obxiLu/RTwrZN2CR9fuYFMU36f1XOOe+B3TErHDE9hTa9+x7fxl9QM8grGOLvVgpuugJXnbPZuzw9ZZazwu0p16MUdZNQMtoZ8HSj7eJLvt/XO7lV6Xs7BQF6I1GpVsazxKOTDtej09X+p+C/38EAXOghQNSBk6IUUboG3gUKDtUtYpyEn1hwvqb62hZGINcEqKwmW8Xt5q+v3uajnBi33cj/SE9NNd/PwW6v4kdGyWQEqHV7U56cFmTHNpNWUPoUn3YyDH7TtJm8bTtL8mIustYoY6C2Y/qvOa0ONGvGxH8g6/rOl28sl5mm7DhqXDEjFlrr24xFnGTg+01aCOehvtsry31cC2bjYrt5E/tnLB/Xyl/plF7/uulbUTB4VCqr/vhc9CECVq4kJxJQ75lSFPg7KBkh7B8B00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Tue, Jun 09, 2026 at 04:17:45AM -0600，Nico Pache 写道：

Hi Nico,

Thanks for the reply. :)

> On Sat, May 30, 2026 at 10:33 PM Luka Bai <lukafocus@icloud.com> wrote:
> 
> Hi Luka,
> 
> I haven't reviewed the code yet, but the overall concept is
> interesting (it should probably be a RFC first though, but that's
> fine).
> 

Sorry for the RFC mistake that I made. I didn't know the difference between
an RFC submission and a normal one. I'll use the correct type from now on.
Thanks for reminding me :)

> I had future plans for something similar as part of the thp=auto work;
> however that requires significant thought and investigation into how
> we can properly gather hints for collapse/split THP candidates. From
> my perspective we'd want a more global structure/system outside of
> khugepaged, that would directly call khugepaged (and others like
> split, etc). It would also tie into the allocator so that at fault
> time it could leverage the hints to make better decisions. My fear
> with this series is that making a decision now might complicate future
> work by adding complexity we may eventually want to remove for a
> better solution.
> 
> If you have the chance perhaps you can lead a discussion on your
> proposal at the biweekly MM alignment session.
> 
> +David Rientjes as he leads those discussions. We could use that time
> to layout a plan for what needs to be done for this work, and for the
> work surrounding thp=auto as I beleive they will be interdependent :)

That is a great idea! I also believe that we should improve THP in all sorts
of places like page allocation to use THP more precisely and more easily,
considering the fraction problem that is common when the machine runs. After
all, our goal is to maximize the benifit that THP can give by optimizing all
the routes :). Actually I've prepared another patchset that gives THP the
ability to be reserved based on migratetype so that we can reduce the fraction
of THP folios, and was considering discussing it with the upstream. But I
guess I'll postpone it after the reconstruction of THP code base as proposed by
Lorenzo :). I'm very interested in these discussions about the THP hints or
auto and reconstructions. Maybe we can use the THP cabal meeting mentioned by
Lorenzo for the discussion? Any approach is fine for me. Thanks. :)

> 
> Cheers,
> -- Nico
> 
> >
> > Signed-off-by: Luka Bai <lukabai@tencent.com>
> > ---
> > Luka Bai (5):
> >       mm/khugepaged: add framework for khugepaged collapse hint
> >       mm/khugepaged: use slab cache instead of normal kmalloc
> >       mm/khugepaged: add deduplication when adding new collapse hint
> >       mm/khugepaged: add accounting for successful hint or non-hint collapse
> >       mm/khugepaged: add khugepaged collapse hint in mglru reference checking
> >
> >  include/linux/huge_mm.h    |   2 +
> >  include/linux/khugepaged.h |  20 ++
> >  include/linux/mmzone.h     |  17 +-
> >  mm/huge_memory.c           |   4 +
> >  mm/khugepaged.c            | 460 ++++++++++++++++++++++++++++++++++++++++++++-
> >  mm/rmap.c                  |  27 ++-
> >  mm/vmscan.c                |  33 +++-
> >  7 files changed, 549 insertions(+), 14 deletions(-)
> > ---
> > base-commit: e1af79f3291a268adf4e149e1faba3052743e898
> > change-id: 20260530-thp_collapse_hint-ec92bd943797
> >
> > Best regards,
> > --
> > Luka Bai <lukabai@tencent.com>
> >
>

Best regards,
Luka

