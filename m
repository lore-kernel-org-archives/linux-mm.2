Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DA4CDB473
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 02:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764F18E0006; Thu, 13 Nov 2025 21:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C438E0002; Thu, 13 Nov 2025 21:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679948E0006; Thu, 13 Nov 2025 21:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 539E48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:23:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0F6612D1EB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:23:58 +0000 (UTC)
X-FDA: 84107617356.24.7138B84
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7007120004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:23:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jzeM2aDD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763087037; a=rsa-sha256;
	cv=none;
	b=sg7vkzb0IgZMDBNdUfdVifFeENQKwbD856O5+h76t6MY9n8f7mnnyXq9z0lQW1I+IeYyXd
	GWj+hno2zzS2eLwpuVjsBe788mwPMTVh9VhTd2WEzRaIa9fh3XTG6tZK/yfp5zV158ekPz
	LX2plZtlv6Cdj99ddcZKLyZ+1Fm8PT4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jzeM2aDD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763087037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUjyrKGTpAMxafgaVgeOC05GENR0/pzqji5IeCIQKgw=;
	b=43yyOjkWUEpPSmieNFnWO9wO7bBMPMjYLx/Rt/pXJCGwib08WV4Dr8EkWuaPuqmazgoqnc
	KxFG8WgSZdbKAb1opxKpBX4WsE82cIklf83ZcqDwejsBLwRv+YlJ7hOvUt7GoW0SZx9+ln
	DGT0SwqZePCMs3sd6fLFL6S+cWlHrac=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763087034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XUjyrKGTpAMxafgaVgeOC05GENR0/pzqji5IeCIQKgw=;
	b=jzeM2aDD3dtYstJyPJT2s7mVcdSPwYOdCaMcrnkQ5S9LD9TsCsGs1O4cNjttXGfNTho5WN
	zfZ1VTqaXyL3hAKeOXztLL7cz0dKeFpnHA/BQM6PEsoN8Fap242+ZxlF0aUURfPK68SEhk
	/cgnE0+uwJUZ/iUglY7UxqXIVmP5MyI=
Date: Fri, 14 Nov 2025 02:23:50 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <42fca12aec282a64d3b5bd471124a1e94048afc4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Michal Hocko" <mhocko@suse.com>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@redhat.com>, "Qi Zheng" <zhengqi.arch@bytedance.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <jbqwxqsqvjqo664s275hcub5wgnjencvqgisiniflylp2fpxz5@imttckfazi7u>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
 <aRWswVgIaAqJEvQB@tiehlicka>
 <jbqwxqsqvjqo664s275hcub5wgnjencvqgisiniflylp2fpxz5@imttckfazi7u>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7007120004
X-Stat-Signature: bsyre9k543jaqbt41ta6i7dagsy67b3q
X-HE-Tag: 1763087036-789973
X-HE-Meta: U2FsdGVkX1+RVzXlUlowZYSI397yrI9p/Bfzpq9Do5XaUeHMKpgONY/YUi0snW8hUL09h+5nCz0ACNobpFjvhLp/8HIsFweST7vmj9pPFk4g5IrCwu7V+rgqlBPojG7e5Pirta18iOxrxzfAEj43i+weq2LKhWrQwsSo5daxZW0mnFu/n+Ix2phel6xkmLx/5k5OVDVWKelcAd6OHeXYZbHH3JFVKyjD3tEV4yK3Op6YZXPb5CwEqoTuBZzcrSTeMw2N6Dbv4elfQd6moxNts2f3PA3zBd8LWufksMByAtUOAZt/5WjauqQM7ixWNoM3gPw1Gd+6kJF1KuNi4ywgb5eBFUsT2k28ArxulnqDgUIMgN8aCC1vnUnT/GB3joj1wTwmaUvEo4eE8OWwPKhe+y0abPttrcjX9NPcoJQX+58wSiT/rRAcnv2GaPwd8Rre9EBnKpkUyRLkQdZ1z0JfJL7Gpm8dzWeI92i2Q3B5/DYiwIBcW16kF+PyE6eS92K80F2+zz9xqfVU0tJ2KDkv2c4QbpvDQobYzd2YfUGaXjy/T3RGgFkSMEtdfnkWTfUE1b5byrVvzmJ/cY0+y1As8iCarm+2auuf7kPsfVasO0tHzjAj1GJib+bQveOjcvDHISTaO31fiTi44Gb9om04DWa1WWjEpAkmOgtfCDTePXXxlg1R9IloiSOfOgJSzGDiZ/ooJLG7wCRTz4JknguvcUJaaCocmH8smsXqRcKc6fsuqMgTQhogDl5Uy378TYeTiA1vJDcgR5YMlsC/88nJO3tK+SEbFU8BTF5NEIduAX+EFjmwD9N+/6S0nAxZbFqEnE7LkYPeAZyuk0n1x6F6mEzt4W9EriWFFkVJztDsGLGVAZLdOtnuXpbd/EHggVU4hTppZT66n0vnb8bh2HpISucI0NCDWgJ4NPbVVBkvRcGe6318yoIlR7vH3SitUFyEP+JDffiehFtBF5sieRs
 iBgE9p0N
 NTIdCk/rLFcelpf8/EKBkrx75Jjz61kDz+4wSbQ+lZpWFvVWf2ExrX5ZJHBcUW48WdLlcziyAJ5DYdYaxMm6EEi15gLNLp6kP7NsbSJPSqPMFMkLTg5do/uIlp4v06eW8JBOn1K89VW6jGOyRLI+wZVt9/qZThNaqOEzTvsIIQJ23WSaIjkpKcVT1ZRo9OSYv7I+D7mCSb/GkaGsDB34qnbt7qMrthVJiOOYLjIeH67GypjKm44Bd7sIUHZcViCC7+GHE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025/11/14 03:28, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.b=
utt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E =
> wrote:


>=20
>=20On Thu, Nov 13, 2025 at 11:02:41AM +0100, Michal Hocko wrote:
>=20
>=20>=20
>=20> In general I think not incrementing the failure for boosted kswapd
> >  iteration is right. If this issue (high protection causing kswap
> >  failures) happen on non-boosted case, I am not sure what should be r=
ight
> >  behavior i.e. allocators doing direct reclaim potentially below low
> >  protection or allowing kswapd to reclaim below low. For min, it is v=
ery
> >  clear that direct reclaimer has to reclaim as they may have to trigg=
er
> >  oom-kill. For low protection, I am not sure.
> >=20=20
>=20>  Our current documention gives us some room for interpretation. I a=
m
> >  wondering whether we need to change the existing implemnetation thou=
gh.
> >  If kswapd is not able to make progress then we surely have direct
> >  reclaim happening. So I would only change this if we had examples of
> >  properly/sensibly configured systems where kswapd low limit breach c=
ould
> >  help to reuduce stalls (improve performance) while the end result fr=
om
> >  the amount of reclaimed memory would be same/very similar.
> >=20
>=20Yes, I think any change here will need much more brainstorming and
> experimentation. There are definitely corner cases which the right
> solution might not be in kernel. One such case I was thinking about is
> unbalanced (memory) numa node where I don't think kswapd of that node
> should do anything because of the disconnect between numa memory usage
> and memcg limits. On such cases either numa balancing or
> promotion/demotion systems under discussion would be more appropriate.
> Anyways this is orthogonal.

Can I ask for a link or some keywords to search the mailing list regardin=
g the NUMA
imbalance you mentioned?=20

I'm=20not sure if it's similar to a problem I encountered before. We have=
 a system
with 2 nodes and swap is disabled. After running for a while, we found th=
at anonymous
pages occupied over 99% of one node. When kswapd on that node runs, it co=
ntinuously tries
to reclaim the 1% file pages. However, these file pages are mostly code p=
ages and are hot,
leading to frenzied refaults, which eventually causes sustained high read=
 I/O load on the disk.

