Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDEDC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682A66B0151; Tue, 18 Aug 2026 02:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633C76B0152; Tue, 18 Aug 2026 02:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522936B0153; Tue, 18 Aug 2026 02:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33DD66B0151
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:01:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98F41A3704
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:01:54 +0000 (UTC)
X-FDA: 85113344148.20.D731F36
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35E571C0005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:01:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf20.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787032913;
	b=PShH0YtxbkU+pf/A9Sm4xgk1XBMqLi2zz8AyChnTChUGNH7uNQOTBYIsJyTRjMGHJGdD2V
	xO4huyfL8SNBNFAltxGL3aI9GGlqASOKO+zumDuWxephBh8ChRp2+kOQS2dKNcppq+7LJv
	/QclqT4rePvlTXKGxuS+B3LyZXg2qq4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf20.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787032913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HgewIRpkemtGNOuhpM62yzSblJpWdOMvsCDjbtIDozc=;
	b=em6jB8V8I0wFsAWgWQB/6L3gYzgfoZtSTkT6KuRXqvhXDneviyqxYd0soVcHvfGUB8n6tI
	RQP//XbtUUAJaNq99IoXZcHcswLbRmh+BasUYvdcOxQEthO45/4D8NKZo8LO8Ug2S231gI
	I8RM2qA/t5LjKs05XDOku232GHY9VjM=
X-AuditID: a67dfc5b-c2dff70000001609-b0-6a83f54c0ffb
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Tue, 18 Aug 2026 15:01:42 +0900
Message-ID: <20260818060145.1890-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260817045225.1807518-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXC9ZZnka7P1+YsgzUtMhZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MpraTzMVTOet2Nou
	1sC4jauLkYNDQsBE4s0JlS5GTjDz2Z/DbCBhNgEliWN7Y0DCIgKaEidaJzGD2MwCB1gldnbF
	gdjCAkESXdOfM4LYLAKqEv1fNoPV8AKNmbFgKiPESE2JdRtvsYDYnAL2Ek9PTGYCsYUEeCRe
	bdjPCFEvKHFy5hMWiPnyEs1bZwPN4QLq/cgucfjNZBaIQZISB1fcYJnAyD8LSc8sJD0LGJlW
	MQpl5pXlJmbmmOhlVOZlVugl5+duYgRG6bLaP9E7GD9dCD7EKMDBqMTDu+NDU5YQa2JZcWXu
	IUYJDmYlEd6Pk4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeY2+lacICaQnlqRmp6YWpBbBZJk4
	OKUaGB1szc0vrmxX8+Ovd5PW/HzNt7g2TVRrwgcPjqpLVqwqPaXvMvb7/r6e++N1XM4JXYub
	E/MLXdo2cNjICzfF1LRyHL3h8GvC9krBR+KeJfqhy9YK+vQdkf5TJbWg9vGkL27HnhVI3k9o
	V2uMqw6dvuZoVYxZ2LKzEwQmJRQ//SK+VljhycRrSizFGYmGWsxFxYkATuQ3sc4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsXCNUM9Rtfna3OWwdETvBZz1q9hs7j7+AKb
	xa4bIRbnpsxmszhxs5HNYvXNNYwWz7f+YrT4efc4u8X1WysZLT4/e81ssf/pcxaLB02rmCyO
	b53HbnF47klWi3WnDrFZnJ91isXi8q45bBb31vxntXjz2M3iW5+0xf0+B4uVP/6wWhy69pzV
	4sj67UwWky8tYLPoeHmfxeLWhGNMFqvXZFj83raCzWL20XvsDnIeO2fdZfdYsKnUo7vtMrvH
	5hVaHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NLjxeaZjB69ze/YPL7d9vBY/OIDk8fU2fUe
	67dcZfH4vEkuQCCKyyYlNSezLLVI3y6BK6Op/TRTwXTeiq3tYg2M27i6GDk5JARMJJ79OczW
	xcjBwSagJHFsbwxIWERAU+JE6yRmEJtZ4ACrxM6uOBBbWCBIomv6c0YQm0VAVaL/y2awGl6g
	MTMWTGWEGKkpsW7jLRYQm1PAXuLpiclMILaQAI/Eqw37GSHqBSVOznzCAjFfXqJ562zmCYw8
	s5CkZiFJLWBkWsUokplXlpuYmWOqV5ydUZmXWaGXnJ+7iREYpctq/0zcwfjlsvshRgEORiUe
	3h0fmrKEWBPLiitzDzFKcDArifB+nAwU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzusVnpogJJCe
	WJKanZpakFoEk2Xi4JRqYBRkNbLNOectwD5H+MJBh/U6i7z3We/0uJ30Y0Wo0+r0RxuUcwRy
	mzn/NPkfCF78xL7ZtnH3lubZ0yIWNn35wVx+N3R/TOb/Y8d+P9oboBfuw+qwtvFGh3ri5FqR
	BuHTk88Khuq+Vojpl/MNYLHXn3FIVSxQ/pXIDtkpxtsmzm4SiImS8Ji2UYmlOCPRUIu5qDgR
	AKUhhf7OAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 35E571C0005
X-Rspam-User: 
X-Stat-Signature: uouupkk5qcijdd8rfgecbodmcscmesgs
X-Rspamd-Server: rspam06
X-HE-Tag: 1787032911-640136
X-HE-Meta: U2FsdGVkX19ElOHJoHAxOwrSwLhwRQDCGE3x9arwz9EIUYLUCj+ZNce0sUE5kv5J9a1L7DG0w9hacHfgRFrPfZNIkUu2Ln8dQOvQZDZrpj3HIwjR9reuz30gnWmgrXOXblZ0AEedE1lVENtqZiV0QIkOsMxK6KaOZu5FIoh/s06vyLauzix7JF8WucWry4YUA6qO9naDOmrHfhLgmD94f3NKh2Pz1qji8G2qPdTD0n48F3S/UC71W111z5KLgEKQdYhK4dXVqYwke771UAoaNFtYWRmlI2D5gB1uZ2SGGb48CHn6C0sBV7/yD85hhe2jttVDhBaBoW0NIMqu1KIoEYVAysnynEvy4LJ+l42cGtf2Fen54JvizdbGnJfqlsknW274kvAmDYxsTVwHfABKYl/XO7VMdPIXofJYkMefE5XUNlcNE99CsqY1IeiOfxhIqONklkw7nM/YjnWKOq+QF6NbXU43rTLbH1EcdFlf/YDP38v2SjTofANuIFrb5EO8yDPaa2EyIZ4RZ7TSHCtPZP9O+YTwOQ4dZA66B2jilbCA1FkHYBXS+wZpw5cbLdfbchXdYxotQKJMZQxEbBovwS5bAEPItrXtm57tuMdurV/+XiDvnU+jWg2qij9B1ewbplkGvgrexVEYgBGAd4r6Dkoltpxo0Oh+uo/SSYk73rMf6iIH6z9xKJXB7a9vqpTldKydb4iKj/te/dq6YiHdT1cNN6HmS3ZDD2pQylt/ruvm4La3uU+PBl5TnC7ixCDaKasAYk5wVNc5XDz9qXJey+R2xgDHDzGw1U88xjus+6MffjkmEC8OQmJorJmgkxzmPUm1dBXT6g/yIfSYLWMH36GTMm8kHqTLtbQ1fGH5rSxCLp+52NvNwDigM0W8v8JaEp+7ssn86cYEmXvV0BdNEWtDRr2+O1sMro6lLXYeDu/DCteiO4WZtI9vQF5QE/jWwENQjGSescXXIk7EfeQ
 zd88TRls
 PR0WaOfwMPhhEmmKE3Q6+GY7I7b+AoJYVY3hk6JBCApc7gUc4CB7PvggACZK1s3wja1+6+oEndczClSJU2m9ql/5BXxkeW0ouCFQafJUUQQKn9AMl88auRFu1qp8GHoJbokvnIJowymknf5jot0nE+ZuIWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026 21:52:24 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Joshua,

Thanks for your feedback.

> On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:
>
> > I think you are over-complicating the explanation and that's making it
> > hard for folks to reason about this.
> >
> > My best understanding here is for multi-socket systems, weighted
> > interleave as-designed is inherently sub-optimal for scaled workloads
> > that utilize multi-socket ("package") memory resources (DRAM, CXL...)
>
> I was thinking about this and I think Gregory is right here.

I agree. From now on I will keep my explanations focused on the key
points.

> I wonder how much of the framing around this series can be preserved /
> simplified if we just say "prevent tasks from allocating memory
> cross-socket".

I think this is a good suggestion. Even if it is not this exact
wording, I will look for a shorter and better description that
includes your idea.

> I also wonder if instead of limiting this to weighted interleave,
> this can sit on top of other mpols and just nodemasks against
> cross-socket nodes.

It does not have to apply only to weighted interleave. Patch 2 simply
groups NUMA nodes by the package they belong to. So the same grouping
can also be used for interleave, not just weighted interleave. I have
not applied it to interleave because I could not find a clear use
case for it yet.

> I am also out on vacation this week : -)
> I'll take a closer look along with the code next week as well.

Thank you. I look forward to your comments.

Thanks again for your time and review.

Rakie Kim

