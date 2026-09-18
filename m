Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575FCC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5427D6B008C; Thu, 17 Sep 2026 23:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC426B0092; Thu, 17 Sep 2026 23:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401D36B0093; Thu, 17 Sep 2026 23:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAD66B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:53:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E5F640589
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:53:39 +0000 (UTC)
X-FDA: 85225513758.22.2BE8EF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AACA840004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:53:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=faMWUe+E;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyjeJYQAoIT6JPqi52GByedAXFRsvGfuaaVIMzoH39U=;
	b=wg1O1ajWBMNkO2J/00MmzLkbMzAgbo2wsLHTxW9oBjbDTaDSxBd/43JQs1vSb9SKcxR6qe
	r5c1BuWl/n75iIAkSzldYyOf4KaG9RDci1HFTZmAHpUIpZAkPW37WxXq1v65qTOEtdD5Q9
	/lUt8jdYhhX2/tjt1TN3sQipXpayAaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703617;
	b=jmWQyPog1bUBNU1QTvYqcjUNqZM7jdUbNw6+xStNGI0v+QoQ3uVHQEQMIaNLOg0S6BA0Wz
	f2/dSOlmzV+YcMTR4i9uWJGD+vtkhROb6NNLSDv1P8diAPi0m4Uh4Ugu4v7LkC5uABiC/g
	q/XqAssyULfJ/vMQtn0nHeqDsddj7WI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=faMWUe+E;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDE51600AA;
	Fri, 18 Sep 2026 03:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D4C1F000FF;
	Fri, 18 Sep 2026 03:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789703616;
	bh=NyjeJYQAoIT6JPqi52GByedAXFRsvGfuaaVIMzoH39U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=faMWUe+E92wqRxtkbgaWMXRYwf6KR2EqEIoqeW2C5x8Tk7PKPPibffuWfOOMaOnRJ
	 mpr69blAKOn6oTolFU0h1fttVhImQOrJ+9OHLp6NW6w63EYu7M7joHbQ+8dYkv9PAo
	 J6YjQQJYozXesL/9g+YQJEr51aieL7Rd2UoPU2X8=
Date: Thu, 17 Sep 2026 20:53:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>,
 Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham
 <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com,
 jthoughton@google.com, rientjes@google.com, vannapurve@google.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
Message-Id: <20260917205334.9ac84d529c686983ef420567@linux-foundation.org>
In-Reply-To: <CAEvNRgExZM4ixMfrF_FMw2CTn6JqRX8s=cy0_-x5ypLxvQQuMQ@mail.gmail.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
	<20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
	<CAEvNRgExZM4ixMfrF_FMw2CTn6JqRX8s=cy0_-x5ypLxvQQuMQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hm3834abmdbnw4sm8e5cpxouhgzysgn7
X-Rspamd-Queue-Id: AACA840004
X-HE-Tag: 1789703617-511356
X-HE-Meta: U2FsdGVkX1/Lazf3fYd/8OI5m1XDLVYJq5IqvCo/K7LtNjMJcIR1VnU+nSpROydjZIfwecrudc7TPcXWa3i0IMDZQ5SjhJ+Xzyw1OnYt2e16NuZPtQTAzJr0rfGMOGoeBdA1Pn1mvO7vp1sYANCrYlopolZuIPEL3jkkCoHOL4V6NUcouFBFFW7eZ6NdJDfQCQinJ9JrPa0cmnsTfLlaNtk0N610/dRli27+QMAsTtzqDC3D8B8aCs70wXtnXgsmMy/k9wpLQvM+bom/shNZNTDr7HQYSWZ2WMNRlKfMPZS89b/fXU+Wl1DwjbzvKKcGY4FNj7+b9Y5bvUJg/rnWEXAszw2+DacJR0gr7yF7FRc/xxMOwHslQlmJ6IoicdDuyRL9ofh7WhWYmBJ3GhsUuREJ1o0QvpSyGibzg65r9JeNUx2XtlgjX5DJgwNqQi5rmrDqncaFAJf5be/PYTIfAC0iL8tvae1fppYJ//xC8F/yV61bMecMcl5rdigAThg1xP5ZlitsR4sDzKJeZZiYoHPfivGxh9LArlQw/Ny5MmsOJEiS6Ow9XDT0iDLrWCOFZRqCdRCn5Ka1OAz2O3KLn/HMguVGfHmVh54hpPgBJtic4tfrYdnwhsM9DEO+VeBluBJOYPIoItAAfUvBQzQ1VgjVewhSTZPC3eSt9seZm7VF9gSc084wBgDs6Yomu936P6QsCKuVVAX7eaSla64TlhiDdqxhoT/2J6LF0Y1Ml8V6KsA+2NSuMZWOhclxUpZqFbmJviux5++pTEaAagiuW9vU4KbZbr/nSjvNTRl4wgrPEL/iTTuzl+xjTbfh6KHbrPrAke6G3C1FLg4DWoNJm/cAUp0WwsUDrnY9v/d3U4jqyJEaslEJoObB6kGRStv75H+m+77q0i7ZBhn+xsMnqa+RYNvOKcg0oVURUZQFiNcyhLa+JmrDIFOBDd7IQCV2PIS8XZp90SEc/Z28BwK
 x7MgLqO0
 RLy8+NtAnOSazv9NJb3Vbebc0CxNxrKoxY0a8IKzRd2dIvmrgLeEnJZdX2vqbAKcB2e4T57Ki1yU+aBlq22rbNMklWK3LJzumfhbW0KWGMVGubQtT641all6tHCJwndzpSFEheAmw/BkrE72nUjyS1je7I0+3UhDoOIYajBvvEUVmfbC84ozpnc2j51TExGYfsGf2YAGLFq6zSCRa5s5tdnLoxWcqPFWsD80ZaCc8xsTcg4srbFxF6Sl75j3FPKd08gQWlpkNoKk2KHt3TC71BHHLWF01mj4wXOHQV1jG7HqPEoh2DSjqVqLfBWP2VPNNy4MwIcObpkbUYkO/s/sYzV0SEZ4QMqu83ihCQjrYOugpkc1qycQEqVcz/Hi3dbGkh4jsEpS9T2/hueXVE3eqVGwj3z5pW1QXwft9cQhepHiBX4+x0Udp1u7IiWxJymGb8nzzhciCuRMNIx+MTjwfkg+l+LM16vETouSwfji3PcTLfUqZYbT5J7PL65uRI8QDWO0Mt/ZaAjDdYE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 20:05:33 -0700 Ackerley Tng <ackerleytng@google.com> wrote:

> > Ho hum, complicated.  Let's at least slap a Fixes: on [4/4].  My
> > trillion-dollar sidekick suggests a9e443086489 ("hugetlb: disable
> > region_add file_region coalescing").
> >
> 
> Your trillion-dollar sidekick got the right patch but the wrong hash :)
> 
> Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")

Well, I only feed it $100/mo.

> I'll also reply to the last patch with the above. If there are no
> further revisions required, could you please add the above tag in for
> me?

Shall try to remember to to that.  Whack me if you see the
"added-to-mm" email and I forgot.

> > Our other little friend is talking to us:
> > 	https://sashiko.dev/#/patchset/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com
> >
> > I'd like to queue this up promptly because it fixes things.  But let's
> > seek additional review input and argue with Sashiko before taking that
> > step.
> 
> I'll copy Sashiko's comments onto this patch series in replies. :)

Great, thanks.

