Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCA7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 03:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AA06B008C; Sun, 12 Jul 2026 23:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B476B0092; Sun, 12 Jul 2026 23:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514346B0093; Sun, 12 Jul 2026 23:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 266886B008C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 23:36:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A55621C42A5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:36:34 +0000 (UTC)
X-FDA: 84982341108.17.3FC9901
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00B21160003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:36:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783913793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/GffAlUcCSrSd14mbqBzM7Xv8Op1n9xpNKkp6zLvb70=;
	b=5BysfVMlE5mQ3FmHbEkGFd6AM0aKRcin6Rshr4IC8GLRD323NZPLl7ScHETPgOwJl8XMHQ
	h6yXvXTjfbrcwIi+bdwZuPTTR3oBSp/9yH3oEbs9FnKr4KgYijGs5dWFASoJGg9a1zaBeM
	jKUzWwfBK80tqFIT6YsZ0FNZ0Qpqm9w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783913793;
	b=Y3sxg4hKMFFSZzEtPDnvf8V7Przm5/+961/Xvr7DSQ/220AoqP1m6xl8PLhYjyLcYe2gqy
	81KmfY2S+oIhfUf9iY5I5XyFN9yBt/zOCMtgsu2fDHswTlB7Yw9FmraDs3YqSf8NTZ+xjY
	zY9WPzAcNSFhwdeS2tR+1eRXcCHun1g=
X-AuditID: a67dfc5b-c2dff70000001609-f8-6a545d3cfdb0
Date: Mon, 13 Jul 2026 12:36:23 +0900
From: Byungchul Park <byungchul@sk.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, linux-kernel@vger.kernel.org,
	max.byungchul.park@gmail.com, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com, longman@redhat.com, yunseong.kim@ericsson.com,
	ysk@kzalloc.com, yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	neilb@ownmail.net, bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com, dave.hansen@intel.com,
	geert@linux-m68k.org, ojeda@kernel.org, alex.gaynor@gmail.com,
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org,
	aliceryhl@google.com, tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 39/40] rust: completion: Add __rust_helper to
 rust_helper_wait_for_completion()
Message-ID: <20260713033623.GA79338@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <20260706061928.66713-40-byungchul@sk.com>
 <CANiq72kEo=bGcHNaSA9JZhv4iuE+YDvu0kN+Z7aopVp3=2C+Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72kEo=bGcHNaSA9JZhv4iuE+YDvu0kN+Z7aopVp3=2C+Wg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xTVxyGd+499/ZSrbl0MI82maG4mGhwwzHzM9mIMVlyk2WJ032Zi9Fm
	3IxiKaxFEKaxTKv1D4huZeMWWaGOoVZtWpwTZDJ0aAOMWh3rnLWgiCOIxD8tAaldW7KMb0+e
	c877vh8ORysvsIs5rb5ENOg1OjUrx/Lx+U1Z723+uOAt11kVWMy74U5omIHwcwuG+nNOFizu
	Ogau//kVhlDYgmDyhY0G88UYhuixbhlYKxEEfJdpcLZWUvDM9ZIF69AwC9KITQbjoXYGYsGH
	FERrt8H3TR4WGoeCNDwdHURwc3gB3ApPsOC1HmLhsYuFG71jCEZud1Cwx3GOhdrjbgw3xmYo
	OO3+EELNIxhs3/5DgfVMOwVTzadkYOu7ycC9FkkGM0PZELMXQfCIFcPZ8X4GvHcHGAhd28fA
	BdOgDNx//YbAfT/uGvedwFDXcIeFSx1eDJbo8/iWtnoWDrvOM3DXGWPAZJtkwNfZw4D/tA+D
	VzqJob/tDANDgwEGPH29NESqVeA7WsVAoOYBWpsnTJqrsWD2R1nB2eBEwovpY0gw18TpyqMJ
	WtjrKRN+6HnECtPhP1ihI2LHwokD05RwUQrKhL2/3JYJdvd2wdOyXHBcGqXWZ22Sv5sn6rSl
	ouHN3K3y/MpYNV1swzvu1bmRCTnog4jjCJ9D7FVbDqKUJFp7qlGCMf8Gsfiv4wSz/DISCEzR
	CU7jV5GBnva4l3M0b32dNE3UJx+8ymvJw5qO5CUFD+TBVCzplfxJRKSxtbM+lXjrhpOhdDx0
	psGf3EDzKvLjS25WLyF7ztuSMSn8R8TR2ccmOJ3PJJ0/XaMSvYR/nEKavu5mZkcvIr+2BHAN
	SpXmVEhzKqT/K6Q5FXaETyGlVl9aqNHqclbml+u1O1Z+VlToRvHv3Lxr5tOf0VPfxi7Ec0g9
	X+EybixQMppSY3lhFyIcrU5TZKviSpGnKa8QDUVbDNt1orELqTisXqhYFSnLU/Kfa0rEbaJY
	LBr+O6W4lMUmtAneL3M9UQVzoummdb3H/0512D758vB3R7T++zsvL6vYmXsr3dK4prW/YmlV
	iU8vbthsOLqgMNiqymhsWypkr2jI3Nq36Kp2Te7qgRUbVBnrJ6s4xZPy13Sv7P+9hWROByOR
	rHmezrRvMlaH5aPdxWFf7RfkHX5Xwf51Sz6Q3hYzkRob8zXZy2mDUfMvWsBm3MoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHPffenl6a1VwRw4lkc3bqlhl1bmKeRLJp/MDN3qJjZsuWRTq5
	WWsBsVUmJoqldtbNNKWm7WgrMBhVsUNWsA6hGYGIVUbkZUNUEFgqjoGACJjyVi81y/hy8j+/
	839+eT4clo6145WsOvOQoM1UpiuwjJF9vM2wIemrT/e/FR5ZByZjLnT3hiTQqa9nYHLCxID7
	shfDnOuqFEy+AgkE7+Qx0FpxCUHvpAnBsxkXDcaaCANz1iYpTITvS8GmRxAJNCGwt1lp6Gr9
	nQZvtZ6Cp5XzGIYaxxHY+kMYHIN6BkY9ZxA4B1xSGLyeDI97ayUQ6XlEwZ2pYQSe0DwFofpT
	CObsGigqqRLH7WMYZlpu0+CwtSL4qb+HhvHBPgTVTQ8QBC7kYXhouUJDR2gp/Dk5iuGm7QcM
	j9vcFIxUYijOC0ig7Y8hBOdcVgQD9wIUGEovY7Cf8zFQ03dNCm1DsxR0260UXPJ9BL2eAQaa
	LSWUuK7Y+jUeXA4DJR7/UGD7pZaCsKdcur0M8c+MZoYvr/JTvLF9DvPeQi/iZ6atiJ8oM9C8
	0SJeG4dHaf5k1bd8WfMw5qcn/8J8YKqY4W+VEP7n09MUn9+yga9x9kh37fhClpQmpKuzBe2m
	d1NlKn3ETGe5mCN/F/jQCVRKf49iWMJtIbZmM1rIDLeWmNqDzELG3Oukqysc7cRxb5PO5lqR
	y1ias71CSkbd0YHlnJo8sgSiJTkH5GE4EuWx3EVEnEPbX/Bl5GZBKCqlRelsYbvYZ8WcQM7P
	sy/wKmK44opqYrjdpLS+BS/kFdxrpN5/g7Kgpc5FJucik/N/k3ORqRgx5ShOnZmdoVSnJ27U
	aVQ5meojG/cdyPAh8bd6js3m/4YmOpIbEMcixUvySl3K/liJMluXk9GACEsr4uSbE0QkT1Pm
	HBW0B/ZqD6cLugaUwDKKePn7nwmpsdw3ykOCRhCyBO1/rxQbs/IECn4i+NHaiuu55j1nD75x
	xvDBj/1POnFa4a01n+s0I1/Ghf9d0mcz5j5ReOMTHRcHXnWM95UuyavcYZ66sDfl6tfF608X
	jfEpLTfcSauPyxP9yp1jsxXBdzSdyVtXn7x/+7vhuvOkruNe1ofBs1t1iZ6RIr9K1Z2ldj/N
	r3j5vWXCg7sKRqdSbn6T1uqUzwG4/G81qQMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00B21160003
X-Stat-Signature: k4pkmj8b5gerqec1wqab93foiuwgezby
X-HE-Tag: 1783913791-822882
X-HE-Meta: U2FsdGVkX1/hUCwO18ghaPwyinn1sMuvEoCtMG6aOC8DQdAJqtLse84+vzchRWAPE75ZhS+LI3EsubD3TeZ87ybDqPJ7LKOhafaSWwh7M3Wg+Xzn/vwgDMSoQ8uFA9IEkANCjqZRB3v63sS1ejcAp9RMatPjY2xMn2zC8zJdUOY9e2e+VNjdX+oaUFeLYzDg9oo+6ku6UhjCt3KNfUx785gwKS5WWUef2i+60/lo4MBtd0KiEmfIObf2Ds5AL0B58H0fDeVFsuZv2WGyTPUcDBOa4LuLYxA8GPoLXacIRXBsqFjyXBf+/c4uWeMy40WR7w+DLyremiQgAqw939F8C+CnZzwCR8gOXqO1trpLhH3zcdgAF6yOJ732gZnAR8r4FcqalB6Mp/2U+hiJZ3Tw/kPPEQHG8X8PtZxpEAE9wclVzQdk8Htn8f2fXS+qzscFnpw2xPcMG8yb+TVEhD/TVFMlDz6A1RmvrhjkfuCAnB1uHwnn6OLDj/+uDInSFG7wQLkac5SBpcdE+EmdnPTqU4z2/7Lyy2nVHXrn29yyLIpNTH3TRtSxefDJsKmRrjolKJI+J72Hc+vk7qHh8YZSTY9iUrF9yp4IVZalasOSPD3oI0FqQFuMtj6POs8KH7bZgqEpB/20j3TpGNbnXClhI9lylPdwq2I/yjLP/gqDeQ1+dxNc+wOkhvjvIPtE6eJ8oyA9luLI5agWOVwW32YZ+EayWlbUfQgEadVJBD+KemBFDYQRCfHo+xttmQSmrAQ6vLR2/xrr5FTEH9+B2Vu98l/n53SwqNd9EKPl7Lgt0bKClRT9hzwJTXBn3VlwOCzqIHoK/4xY96tcNH5gKtlvJw5Uakb9+nlWnplA5/xF6N6GawTOOR9g6bbHhoReaF+U6iSc9xmPtPZuqSQ2VT+QlslJ43IzwPkeoeVyHKXI/6QOXHTt/JxRQV009QATqRms8rrdOTXZFZhA6nQoFfs
 xiTI6HVf
 gQjn9iYVuunsp3uQigD5iWIanrKzeZUOAIidu6aJAVEiaVXgTcK5DRjMP3B28pg3H9K1IF51pPjhSGHf9Fr+3SiuPf59ixCsDE/x9VIqP6RcSrzoxNYn2j5U6HPwtL1+Sn/lapqYHPqRxotP2yyEt8dd+RsNNHfymcXmi+XYbhXBb68++yLSHza+nLnGgyfJ2p6lPJWoBq0wbHVsYBhPlbqWNMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 02:13:05PM +0200, Miguel Ojeda wrote:
> On Mon, Jul 6, 2026 at 8:22 AM Byungchul Park <byungchul@sk.com> wrote:
> >
> > This is needed to inline these helpers into Rust code, which is required
> > for DEPT to play with wait_for_completion().
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> 
> Apart from what Gary said -- why did you need to do this in a separate
> patch in the same series?

Not necessary.  I will make them into one patch.  Thanks.

	Byungchul
> 
> Cheers,
> Miguel

