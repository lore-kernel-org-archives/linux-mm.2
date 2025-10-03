Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0782ECAC5B8
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 00:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4AC8E0006; Thu,  2 Oct 2025 20:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BB38E0001; Thu,  2 Oct 2025 20:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8A78E0006; Thu,  2 Oct 2025 20:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A42C8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3ACF87C34
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:52:41 +0000 (UTC)
X-FDA: 83954977722.01.F1C1BA7
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DAD040002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:52:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759452760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYSVJExYSwczYy1IS3dqG08cJsJFpglWvVd0xBczeNQ=;
	b=GyOoEJO3QZ4zxFIWpm6Y81PWvK/QXMx9L4IjrdFCzsGrOcWhQ7VW6cQMqAUv0jGMypb6ar
	l7ZnqydV8Bhp6BRe629ieAxIzMAEqaRDmxCgjMzOhUP8kx82JZT8bNm7loWLtL6KxPI5AE
	VoNAwaSxhdPWd861SGmqsV4BbRrq8iI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759452760; a=rsa-sha256;
	cv=none;
	b=PoatnEjYP4121h/0UnICk/xDtMdnxBNrNIYlhBa3jZzj3Fj4/UNlJFR20plgqos1WEx+rS
	PcjpzRhW+p/yC5jI5XclKI/hPlC9k54I2YsVa9aHGBf8iQZe9Jt9JsLRUnRl6CR/VeVoeb
	rdk+F9wyicKVUeMWqx0noHq8w8k7TZk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c2dff70000001609-70-68df1e53a707
Date: Fri, 3 Oct 2025 09:52:30 +0900
From: Byungchul Park <byungchul@sk.com>
To: Hillf Danton <hdanton@sina.com>, ysk@kzalloc.com
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251003005230.GB75385@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
 <20251003004828.GA75385@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003004828.GA75385@system.software.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsXC9ZZnkW6w3P0Mg697zS3mrF/DZvF1/S9m
	iwM/n7NYXN41h83i3pr/rBZfVq9ic2Dz2PRpErvHwt8vmD1OzPjN4vF+31U2j0kv3D0+b5IL
	YIvisklJzcksSy3St0vgyjgxbTJ7QRdrxbbGLvYGxh/MXYycHBICJhIHvvxggrEv93SC2SwC
	KhIrdu5lBLHZBNQlbtz4CVYvAlTzZcsxMJtZYBKjxM71hSC2sEC4xPT2cywgNq+AhcTsA1eB
	5nBxCAn0M0p8+rKaFSIhKHFy5hMWiGYtiRv/XgIVcQDZ0hLL/3GAhDkFLCUm/7sHtldUQFni
	wLbjYHMkBFawSczfeQHqaEmJgytusExgFJiFZOwsJGNnIYxdwMi8ilEoM68sNzEzx0QvozIv
	s0IvOT93EyMwtJfV/onewfjpQvAhRgEORiUeXo+CexlCrIllxZW5hxglOJiVRHgTVtzJEOJN
	SaysSi3Kjy8qzUktPsQozcGiJM5r9K08RUggPbEkNTs1tSC1CCbLxMEp1cAYd+MIo534pZ3B
	G094393dYcSg+tS55uWk71lP+14lG34SzeM3FH+78NEOt3pVm9NXon7FZwV6RU//936LWvhi
	pu1SdoLr2ew//pb2c9D8w1wRvbFEqmHyvy7BLx/FNnxN8lzAkpVQxH1UU+9Bz8H8oLWLGLeZ
	WodZ/LtmsWLi+9q4uvep2iuUWIozEg21mIuKEwGGbsp0aQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsXC5WfdrBssdz/DYN9aLYs569ewWXxd/4vZ
	4sDP5ywWh+eeZLW4vGsOm8W9Nf9ZLb6sXsXmwO6x6dMkdo+Fv18we5yY8ZvF4/2+q2wek164
	eyx+8YHJ4/MmuQD2KC6blNSczLLUIn27BK6ME9Mmsxd0sVZsa+xib2D8wdzFyMkhIWAicbmn
	kwnEZhFQkVixcy8jiM0moC5x48ZPsBoRoJovW46B2cwCkxgldq4vBLGFBcIlprefYwGxeQUs
	JGYfuAo0h4tDSKCfUeLTl9WsEAlBiZMzn7BANGtJ3Pj3EqiIA8iWllj+jwMkzClgKTH53z2w
	vaICyhIHth1nmsDIOwtJ9ywk3bMQuhcwMq9iFMnMK8tNzMwx1SvOzqjMy6zQS87P3cQIDNRl
	tX8m7mD8ctn9EKMAB6MSD69Hwb0MIdbEsuLK3EOMEhzMSiK8CSvuZAjxpiRWVqUW5ccXleak
	Fh9ilOZgURLn9QpPTRASSE8sSc1OTS1ILYLJMnFwSjUwLlt+hmt5wvG2r0HfFMOt2m6r5Ua3
	RoXFNUzhDFkpnTRbin3id03hrb9WH1c8dILZMvLh8aKdn8zyqmfv39PS2LR+XzDnk7+n2uad
	vnwqVmFas1aC6FnPsmcbinpv8N+fHJ/M8HuedobfdqWnwStCovgrZi4xO5ZYXKE7y/Ts49nr
	V0R/+dDrqMRSnJFoqMVcVJwIAHatfuZQAgAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 9DAD040002
X-Stat-Signature: e8x7f5ihfe6bktizmkrwd9oee75dbah9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759452759-591850
X-HE-Meta: U2FsdGVkX18s/yfV7ZJXW9f30knDdScvIGZbV5lBJcMySqGFhNnSVoOak/bSdNSaOsmlRtihLFi7dR3ddCE7Lz44vK8Roe4rD6aUCDstbE616D24qOTPcVtQv3qEzJS0X1IAChlyobZ499rl5SM/zOIJwctJi1QhoJvAU1kt3a9HOyR8BKWu4qRqMZpkHaDzyoAbRNB4S2H1IxtHKBLjn4m7TycQ3bbiTCcQaCO0KBr7iwEY74zL1LwqWqiik/Ab4JxW1JZyM8hXwkd4PqVJcalb+chB8skYugUQyAQnLpdpDXetT0htVb2Il73a5ecLR5yh/7vo/uDPo52jEfcInr4A8LhHaRoV34TpPTaTUkQaPv2FaPpLdjxgoVu/7EDWnHAH+tSQQT66C+edZ/xSl71esoUURdeiAb7CH2/HkQPHk53yjY2K5h72VBMe2aNFqZt0kpWc8LdraL0Hydyqp74+ON+xdP62MWpscN37+196tqyDXQXyqbgtTcHnekOnk8neK+m/vv1XcegmpaZxm9NPE1+XAG6W88CnCYcgWYixstBHo2+ITyS4M/l5c3LBUWNZ1Tnr8ZNAeVXAs4sOHSNmKtNlnSq8Agt0vMsTdzRlKSF4VhOlH3UZXf77y2rbTZf/gA+K+WW78JTyFVca5nAJCi3EmHWZH7kLU9tRpoh4jOhooZ0WvyXGpjqzFv6NsvAzA8FTtAkscEKkgAId/iPLyY8r1NANFQWhRY/ZNAN0OxjqKAco1AILlZQIIfVnx/La3FzW0FwDyUQggTCBlQMdNWtv/eJikknBUKEt9UOYc/9l0EP9El6DypVXY7N1/dU+/xtrFSyU4xGDoPSVlAxdFvEZYzsLhMFwppA6p3zmG68rlpsApAij1PORr62c65owfrB8yeGDv4gVUVcwTx80l0wtPtS7tf9iByusyBVKSLxwc2g0NdaEfZXBGqyKHcTbyFpsMGSDUe2rYZ7
 yXxvxVpW
 MbFzDvUBcXm6YpVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 09:48:28AM +0900, Byungchul Park wrote:
> On Fri, Oct 03, 2025 at 06:02:10AM +0800, Hillf Danton wrote:
> > On Thu, 2 Oct 2025 13:38:59 +0200 David Hildenbrand wrote:
> > >
> > > If it's a real issue, I wonder if a trylock on the writeback path could
> > > be an option.
> > >
> > Given Thanks to Yunseong for reporting the issue, testing, and confirming if
> > this patch can resolve the issue, could you share your reproducer with
> > reviewers Byungchul?
> 
> Sure.  Yunseong told me it's 100% reproducable.  Yunseong, can you help
> him reproduce the issue, please?

+to ysk@kzalloc.com

> 
> 	Byungchul

