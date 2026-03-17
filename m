Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC14F33824
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917EC6B0088; Tue, 17 Mar 2026 05:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF4C6B0089; Tue, 17 Mar 2026 05:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D296B0095; Tue, 17 Mar 2026 05:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED186B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:52:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2032213B41B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:52:48 +0000 (UTC)
X-FDA: 84555090816.17.8676F62
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf18.hostedemail.com (Postfix) with ESMTP id B80721C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:52:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPGRxQiS6e/Sc68B7xJTdGZrM+xBjLXfMOVAjc0YD78=;
	b=ja3aJxP+iJTXqWKruKqB4yp59on6FFDdywupZNCAFVCQVeAv2JtHyzZwqmg5dLC5yGrsJt
	npovaxsromwKOPBPhMjbObQm0XnQ43HwIsa2E5V/WAXiNjxo5KplbkaVEcg+bQ2Ngp2iNE
	LnyzH5CKyI3nFtNMfv3NnXF/n7hqyDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773741166; a=rsa-sha256;
	cv=none;
	b=3mhvHhCxgbqH4O/Se7hiQm/KP+Hy/wOiv2IqfirGlH6H1ZHvwlrSQsDBvPi4+weAcwYLuj
	XUkGrKUwdRJlr2Fbj0CYu+wJ/4yna0+pGu7iS35qXK0EqColP8PMMNwhCfCnaYeHvyvlNx
	m+3UcD7dDaEAGOYn+nUQwHUv+h+e7KM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-9d-69b9246bd355
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	harry.yoo@oracle.com,
	lsf-pc@lists.linux-foundation.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce socket-aware weighted interleave
Date: Tue, 17 Mar 2026 18:50:03 +0900
Message-ID: <20260317095226.269-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <abgNTMDM5xhRsWFU@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsXC9ZZnkW62ys5Mgz1PuCzmrF/DZnH38QU2
	i103QiymT73AaHHiZiObxeqbaxgtnm/9xWjx8+5xdov7y56xWOx/+pzFYtXCa2wWx7fOY7fY
	3vCA3eL8rFMsFpd3zWGzuLfmP6vFyVkrWSz2vd7LbPGtT9rifp+DxZH125ksJl9awGYxu7GP
	0eLWhGNMFqvXZFjMPnqP3UHKY+esu+weCzaVenS3XWb3aDnyltVj8Z6XTB6bVnWyeWz6NInd
	48SM3yweOx9aeky+sZzRo7f5HZvHx6e3WDymzq73WL/lKovHmQVH2D0+b5ILEIjisklJzcks
	Sy3St0vgypg9JaPgDW/FvRtPmRoYe7m7GDk5JARMJBp33GaDsfftWMTcxcjBwSagJHFsbwyI
	KSKgKtF2xR2kglngF6vE8qPGILawQIbEhOX/wapZgEr6Z8SDhHkFjCW27PnJBDFQU2Ldxlss
	IDangJnEx09zwBYJCfBIvNqwnxGiXlDi5MwnLBDj5SWat84GGskF1PuXXWL3gTPsEIMkJQ6u
	uMEygZF/FpKeWUh6FjAyrWIUyswry03MzDHRy6jMy6zQS87P3cQIjOJltX+idzB+uhB8iFGA
	g1GJh/cG645MIdbEsuLK3EOMEhzMSiK8y45syxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa/St
	PEVIID2xJDU7NbUgtQgmy8TBKdXAmHXr90N+fmY20zXmE9q/MLoqM+53m/N/sug238hqb6dv
	5jcfnLsU46ArIca9Z0XwVc30Neo3tR2mXzF0tY7daNQwc0nqjJ1bov7MjM2yV6h5dO7O8o0z
	Fq0+U7ak8faEO/mJLhc5jG6Enuk1CThSK9jAsMuGjXPD6a8L1Dje3v3ELDypg3H6OSWW4oxE
	Qy3mouJEALA5+eHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsXCNUM9RjdLZWemQfNZU4s569ewWdx9fIHN
	YteNEItzU2azWUyfeoHR4sTNRjaL1TfXMFo83/qL0eLn3ePsFveXPWOx+PzsNbPF/qfPWSxW
	LbzGZnF86zx2i8NzT7JabG94wG5xftYpFovLu+awWdxb85/V4uSslSwW+17vZbb41idtcb/P
	weLQteesFkfWb2eymHxpAZvF7MY+RotbE44xWaxek2Hxe9sKoNDRe+wO8h47Z91l91iwqdSj
	u+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NJj8o3ljB69ze/YPD4+vcXi8e22
	h8fiFx+YPKbOrvdYv+UqS4BQFJdNSmpOZllqkb5dAlfG7CkZBW94K+7deMrUwNjL3cXIySEh
	YCKxb8ci5i5GDg42ASWJY3tjQEwRAVWJtivuIBXMAr9YJZYfNQaxhQUyJCYs/w9WzQJU0j8j
	HiTMK2AssWXPTyaIgZoS6zbeYgGxOQXMJD5+msMGYgsJ8Ei82rCfEaJeUOLkzCcsEOPlJZq3
	zmaewMgzC0lqFpLUAkamVYwimXlluYmZOaZ6xdkZlXmZFXrJ+bmbGIERu6z2z8QdjF8uux9i
	FOBgVOLhvcG6I1OINbGsuDL3EKMEB7OSCO+yI9syhXhTEiurUovy44tKc1KLDzFKc7AoifN6
	hacmCAmkJ5akZqemFqQWwWSZODilGhgVjBKfpdwO+PNw/+rNLp/Ujj1zfSW5SplLwr7pw9ng
	gqUBfjKrGs4x6Gqvm8H441zO6fefbX+dn3PPtWj77eOzDyek8+p6XTu59MvXicahZU9lHXhv
	pLrf3anevqDNv+iH2+IPPnfnCFgd5Xl+Rs9TLNFgcevVI3GOzEfChHXduJ9nd3M+vNujxFKc
	kWioxVxUnAgA6K8H3dQCAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B80721C0005
X-Stat-Signature: jeuidmeycnehzd6ha69djr8m6fngf4qu
X-HE-Tag: 1773741165-760142
X-HE-Meta: U2FsdGVkX18m41iLCCVdkYpA5NAlhQSgH02Q8311ZdMfH0OmgnFltVyUett9Mc5W0KpmcSfD+AJyLseapvcLIB3/kPTHvRPy1H0Ii56pdEck5XI3sRW6hnSf7jYKHMfdpFCptgK3MBcsLfDnNejjVDNiq7KZu8B+fMxI2nn/4DbB6Q3ezOerovBHZvE4rYTfNM8EaJ9UX16wx3iTEGEwORrg3QOMAyHAPQwctIEIBKPfgWeo7z5yV8QLmPR/CQ7GrJDdEogCEVGE4CzbcwCyl6bKZ0g77CnXMCbNWaIs9QWckj7g40tAIQBEzthSiALySH9nVht9X2zxpyF4agXxpu8+C2TJDB38RYsxa1lyn+e46QdP2L9WxLJ2HluHX0KzhVNCtHLg5kHOGzs5p73PztN8nTswStw9H0g9q0d6C5iOw1lmES70swTnQF49Oealyo9DGC/w2HwTpsxMM6lXj0z36fMk4xTHF0imw7IUjTn5aUgBqrU1XK7Soiph1lOP1yoBOYwJSBSazLymY9gz9EyfUEL+56XjcejkAcEQC/e1uZvNdxpU/0JmXBTUEpBr+N42AdAsER5BfEkId9R7deVzxQWOVgeMboXdmJmQLIKNZHVOgzSEoFGa11KVCjvRVnQyiOPyJU9u5hD8uS5Qt0DxHcD8Yw8DUHc2V/b45I66SoW9FXAaTqO+m00wi9tMLlBfLEgzHsamVeKcSZEH/XrFxyzPuulJFazroVMDSSqZKi0dOR7qOrJqqkBKPqKvYNJGP4fABtQBonLtlO4poBmyV6HM98s75ZUUCIn6HMKuq3QQK4IEKcUzCvBBfDdLT/WmRnl+/R0wVpOV1KIOYlTe1ErDrJSzP2QOkig6JywfzEr0xfVOW5w8AZBPYb9EP3TTnetbYQIoUHj32HvYpuXFHrPVdHcU91G8hsb6mWcxE7N7snnd7zNfMkQvB9WL97+4CBP9RV36eNWWsi0
 5Sotmkgv
 tNw0uVcEro2hnJGyUCLS4WeMnrAqCFwv+Wkd2lKw4wk0gmmIfpcrLu2puA7uEMZbKrvo1fSmadebhOfTWBZwXDZPsJ3TcYZGwO6Y5NlcSDLVUAoG9wvuIjoQwbBNnCzCg0yeS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 10:01:48 -0400 Gregory Price <gourry@gourry.net> wrote:
> On Mon, Mar 16, 2026 at 02:12:48PM +0900, Rakie Kim wrote:
> > This patch series is an RFC to propose and discuss the overall design
> > and concept of a socket-aware weighted interleave mechanism. As there
> > are areas requiring further refinement, the primary goal at this stage
> > is to gather feedback on the architectural approach rather than focusing
> > on fine-grained implementation details.
> > 
> 
> I gave this a brief browse this morning, and I rather like this
> approach, more-so than the original proposals for socket-awareness
> that encoded the weights in a 2-dimensional array.

Hello Gregory,

Thanks for your review and feedback. I also think this approach is
much better than the previous 2-dimensional array idea. Since this
is still an early draft, I hope this code will be developed into a
better design through community discussions.

> 
> I think this would be a great discussion at LSF, and I wonder if
> something like memory-package could be used for more purposes than just
> weighted interleave.
> 
> ~Gregory

I and Honggyu Kim are actually preparing to propose this exact topic
for the upcoming LSF/MM/BPF summit. However, I accidentally missed
adding lsf-pc@lists.linux-foundation.org to the CC list. I will
re-post or forward this to the LSF PC list soon.

You are exactly right about the memory-package. When I first designed
it, I wanted to use it for memory tiering and other areas, not just
for weighted interleave. For now, weighted interleave is the only
implemented use case, but I hope to keep improving it so it can be
used in other subsystems as well.

Thanks again for your time and review.

Rakie Kim


