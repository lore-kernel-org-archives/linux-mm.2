Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31C0C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB1A6B0088; Tue, 25 Aug 2026 09:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1A76B008A; Tue, 25 Aug 2026 09:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A026B008C; Tue, 25 Aug 2026 09:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498FE6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:08:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E398160411
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:08:49 +0000 (UTC)
X-FDA: 85139821578.06.7F21CF2
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9F171C000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:08:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663327;
	b=YyV7ceaBw/x7o52VwtlAYhlLeKTfYkMnYktVErjsb1FbRFpJs3RNfcfMLf/IJTah9DdbgV
	4goNWW3oizYjleI8WTJY+osVDSUPVVF2DGK1iXfQxA6i5hK0aDHlgmDdvWyZBMB3t/pBi4
	7mLIrAePXZHUjulzilr0heSZ5HCPMUg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gr9CZipV0q/jP+jZ1XPn6aJDIabSPnB8oh+yLn3oHj0=;
	b=WCLtqE9eTo2gjXv7KvTNBduYJkV33RYRy6P51McVZNHW5TQJjV6hJO3V7T0F2PRAl1Rvym
	IAE4oH9UfmeseGCnKrpoEn3fj7YZ4j5WCpAsPQseoUdL2+Ihotyye/YYChnC1Vo91aE9Z7
	VqLh4fAWDTS7SZdhwujmfFYRD1v88ZM=
X-AuditID: a67dfc5b-c2dff70000001609-dd-6a8d93dccb53
Date: Tue, 25 Aug 2026 22:08:43 +0900
From: Byungchul Park <byungchul@sk.com>
To: NeilBrown <neil@brown.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
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
	chuck.lever@oracle.com, okorniev@redhat.com, Dai.Ngo@oracle.com,
	tom@talpey.com, trondmy@kernel.org, anna@kernel.org,
	kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
	mark.rutland@arm.com, ada.coupriediaz@arm.com,
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
	miguel.ojeda.sandonis@gmail.com, bagasdotme@gmail.com,
	wsa+renesas@sang-engineering.com, dave.hansen@intel.com,
	geert@linux-m68k.org, ojeda@kernel.org, alex.gaynor@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
Message-ID: <20260825130843.GB23086@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxiGfb8zjU0+i4uvuujsYmY8MZSF58eykGw/vsQYtrnFxC2ORqot
	K2iKMNliApEyQFBWrI42cpJaTkX5KGO1LnJ0c8AsjTCaARMmdYR21Y5WwSIrJWb8u/Lcd97r
	eZKXI2UOZhOnzjit1GYoNHJGQkl8a2v3jJWXpr39Ur8fRvI6KSgUK2jQ2ZcoMOQhMHpMLFTV
	tjEwe/kJAy8G75NQMzlOQmDmIQLb3QkE02XtJDwI+hkYGphFMDQbJqBJPAhXZhgwWB0EDFwb
	o2Cq3shCeDIeRHcfgsJbQQrEv0ZoqCmoo2CieYmGXNMzGpyd/TS4mpwU9N/9hYI/Bi+yYP59
	iIDJh6M0tA0OkFD+jwfB9aCfBVdnNQGe4QICGqosCPSeAAvtd3QIBk2/0VBQ10rAA7cDQe+N
	DgJueHpIeGy8SkBP0EtAm2ggYURfxcCCJbLQ1AUfC7qSeRaahiKXhwsZMOVdQNDe94yFm08t
	DOT9+yeC/LF34OpcPMw1NTJgXRxBYOqbYJOShObKZiTMmc+Rgq4sQj1ePymY+72MsBAcZoSf
	QtWU8GstFuqKFgjBbhxnhWoxS8jv9dHCtdszhCA2FjGCGNCzQs2Lv8kPtx2RvJuq1Kizldq4
	91IkKlOIO1X2yZlGn5vIRfNJxSiGw3wC9nv11Ct+suhkl5nit2PH844oM/xbeHR0nlzm9fxW
	3GpzE8VIwpF8xxYsfvs8GsTyidg2dp5ZZikPOOAropdLMv4igceN9eRKsA7fq3gUtZGRV8OV
	rsici/BmbHnJrYy34nPtpmg9hj+Ir9y/FK2/xr+JO3/4OSrGfCgGux45yJWtN+Ku+lGqDK0z
	rlIYVymM/yuMqxTViGpEMnVGdrpCrUnYq8rJUJ/Ze+xkuogiX/r62fBnP6KA81A34jkkXyt1
	fleaJqMV2Zk56d0Ic6R8vfSbs8VpMmmqIudrpfbkF9osjTKzG23mKPkG6b7QV6ky/oTitPJL
	pfKUUvsqJbiYTbkooffEpRZnQIg15Ex+fvSN2ypLJbd9o8v+vVdntltv5WtaySy3WZqQGKpA
	ixumSkqmu+y7h607k+98ZNHtUaVMnx94vC1xAVtLu1rinvrZ5I9LX9+hNx/OWpN//NCRnpsl
	tgNbGtbExiXZ7n2Q8n6KNLnl8qcNgeGjQcOOuV3lB5bkVKZKEb+T1GYq/gNEurVYzgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xbVRiHPeee3t42a72rKHfMgNaoCQtzJhpfM7eQ+WE3LiNmmZnZB7fq
	rlIKHWknDhxxpdZ1bEiptmwtm8ikLIAyyj8RqwRiBQfSbuLAURmmMhkgyIBBoeAti5EvJ895
	f7/z5P1wGErlpBMYrf6YYNBrMtW0nMjTtptThj4pythWXCwDq+UDGBoOS+BXUzuBuVkrgbK6
	Whqi7hYpWL3nJdB1o4BA4KsaBMNzVgT3ltwUWFpXCUTtfinMLt6UgsOEYNXnR+AM2ikYCHxP
	QW2jCcPdKys0jHfOIHCMhGkoHTMRmPKcReAadUth7IfdMDncJoHV0G0MN+YnEHjCKxjC7acQ
	RJ06+KyiQXzunKZhqbePglJHAMHnIyEKZsZuIWj0/47gdlMEge9yAQ1/2poouB5Wwi9zUzR0
	O87QMBksw/D3FRrKC3wSCPaMI7jgtiMY/c2HwXypjgbnBS+B1lvfSCE4voxhyGnHUOPdC8Oe
	UQJXbRVY3Fls1ceDu9SMxeMvDI4v23BqJeLvWT4mfHVDM+Yt16I0X3uxFvFLETviZyvNFG+x
	idfOiSmK/7DhPb7y6gTNR+b6ad43X074nyo4/ovTEcyX9Kbwra6Q9NXUg/KXjgiZ2hzB8MzO
	w/J09zyTbdt/vHpyEJ9Ei6mFSMZw7HPcdDQgjTFhn+TaFlrWmGaf5gYGFqkYx7FJXH3jIC5E
	coZiWxI576mFteAh9gWucegMHWMFC9zM5GlJrKRiizEXcl2m7gcbue7zYRJjSrQuX7wmzhmR
	N3NVK8z9cRJnbnKv1WXsXq6079O1+sPsE1x784/YhpSudSbXOpPrf5NrnakckWoUp9XnZGm0
	mc9vNerSc/Xa41vfOprlReJv9eQvl3yNZq/v7kAsg9QbFIGSogyVRJNjzM3qQBxDqeMU7+cX
	ZqgURzS5eYLh6CHDu5mCsQNtZog6XvHKAeGwin1Hc0zQCUK2YPgvxYws4STaePbx1e0nkvvq
	lGTnluSqbW/W1fs3PSD/qHn+Jpu4y1H5dsW56mxmT970iQe/9ZOR77p69qf8HB/sTwvdDd+R
	6V+sUVaZFp6a8LxRFBl87TGlfMelpNeJRfpI/R8vb4rb4Uo4t6W3/E5iXuejXVUFG3Rpuw4c
	PLTPqevv3NPe0/2PtSxfTYzpmmeTKYNR8y/0oS8sqQMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9F171C000D
X-Stat-Signature: omdxbcj7ojkef7pdz57oxzn3m5jy3pbf
X-HE-Tag: 1787663326-805506
X-HE-Meta: U2FsdGVkX190gFtLSiOthNTYtYtIgRljHP6J7sUrdEAcFeyJY5xfkLjluAUt3qEv7/aTcHA03j89Mx4pvRI037SrytaLGIp1krDeKjmfiS6QeLYj4/zxPUkAPnYViE8K6Rk5Ov9vTeNANI9V8q8P/TEE0FWgIvINxqZ1dATSEXtP4oubFUPwh58RwG1vSV73UMysg28Yo+83qCfstp9CMvhVpTv6c5JHKwYca8KImk1eCIRbTQeIZK3wpFAgy8KURRLp3zcVp7dlrPvK0pc3wxcbBWCcFv15OKQAmTKUz3aUdIo1tvqQkHTr3zUsuDW0hu0fXvAR81BT3yf2V0eSbLd2vqCHVWZzmM65Dx577OFBOTL1VltP8BJT0+Jsc+xzvLNhX/PzOu6o7W0nWm3fE2kyxriaiG2fxWsSXvmQH95ZS6Qv/1jqEQeoDzM+XyN2BcC1Hv7Hvvx3i/DVHHTmUhlENAqBeXxdwyi2T2P65aud5q5198uFVB/itj2/4Z97GKrieRdItLSWUYdvyAcPfKxoI7tQ3EWX2WIxBnhBmTO/92YEJn8EfuHQxLgsOzn8Jwmh/nP2QBKt/Ksd6E5ZD10RI0neQLFtvNLCfZNIZOdL2IGpE2AepArjQUaVROfDrzbXCkCN7aFwOFH072eiYpqVEMG6ZaOPJTZAzXbALCev9F2308bLMxNkaJ0jVvWtMmLRltPnlMaPq9rLE4nF9TI64nUfxSPZZXypV1kZn44OL025FxddzKjgJgl4aV1T6B2vAgueSyWx293in6L6AiwF+GVv0FZVYQpGja6z4/Sr0Jz9iVD2C6TV0kl84452RN3g+0M2930APtn604E26S+z2iqC1uyD/WJIY0ZyUGNzvamsSL7X3sBCLXZ7UU8oUkn0RD9Cpk8dpzrgAW3ZYts3mQIQPZdXKqW+XTcylNHd64gK0pSRM2lXEx1Pj3s/2yDIhyORsEs25ERym0M
 kIC56NJ8
 taVdbzHg2+JMHI5hscHfck2B90kQyHBKeTY22dhGV5mbKvU4f007zut0aCOuGuFb6Y0KZA2g/XyGZwCurjK1w8QeIOtxcQfgT1qQUTRu4I1dnqEwLhy0Cz/XIC1gcGIQ8UydXOXWMvlbUhSqvJVDfNOHtvCnME0x8/x+uzGrEUmQzzd8SaezEQe8QC2zAgOxeTtOWG+VvoOE03iU4htwHvbwpuWtvHHSrBLswQ6h8xwAN32loXc7XOoyv0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 07:48:40PM +1000, NeilBrown wrote:
> On Fri, 21 Aug 2026, David Hildenbrand (Arm) wrote:
> > [...]
> >
> > > Exactly.  That's why we use classification e.g. lock class - DEPT also
> > > makes use of the concept.
> > >
> > > DEPT doesn't use a full map in each page but uses a minimum space for a
> > > timestamp in each to track when each starts to wait so as to use the
> > > recorded timestamp when the event occurs e.g. folio_unlock().
> >
> > Thanks for that information!
> >
> > >
> > >> Given that lockdep is a debug feature, and we will at some point allocate struct
> > >> folio separately, I assume we could just squeeze a "struct lockdep_map" in there
> > >> in such debug configs and the world would not collapse.
> > >
> > > That's a good news for lockdep.  (And even for DEPT :)
> >
> > He :) Where do you currently store the additional per-page information?
> 
> lockdep doesn't need to store per-page information.  Possibly DEPT
> doesn't either.

Class can be stored in global map, but DEPT needs to keep a timestamp
in each page to track when a potential-wait e.g. folio_lock() has been
started and to refer to the information on its event e.g. folio_unlock().

> lockdep needs one lockdep_map for each lock class.  It would make sense
> for all folio locks to use the same global lockdep_map.

Exactly.  Only considering classes, you are right.

> Each specific lock is known to lockdep as a task which holds the lock, a
> lockdep_map which represents the class of locks, and subclass number
> which allows a given task to hold multiple locks of the same class
> providing it declare (e.g. with spin_lock_nested() etc).

Right, lockdep works that way.

> > >> Doing that today (one "struct lockdep_map" in each "struct page") wouldn't work
> > >> as mm_zero_struct_page() would not expect such large "struct page". But
> > >> conceptually, for a debug kernel with a special CONFIG_LOCKDEP_PAGE_LOCK, maybe
> > >> that would already be ok and we could just do that (and optimize it as we
> > >> allocate folios separately).
> > >
> > > Sounds great.
> > >
> > >> Not that it's ideal, but for a debug feature to at least check PG_lock, probably
> > >> an easier way to achieve it than some completely new infrastructure.
> > >
> > > I understand what you are going to tell.
> > >
> > > However, it's worth noting that lockdep tracks dependencies basically
> > > based on **lock acqusition orders** in the system.  To make it track
> > > even rwlock and general synchronization mechanism as well, lockdep has
> > > no choice but to get more complicated.
> >
> > Well, yes, sure :)
> >
> > >
> > > Focusing on only the dependency checking, the most parts of lockdep are
> > > for the tricky things, so the reusable parts are not that big.
> > >
> > >> Now, Willy said "locking rules don't really apply to individual folios", I
> > >> wonder if that could just help to also let lockdep check PG_lock with less
> > >> metadata? (didn't fully wrap my head around the implications)
> > >
> > > That's what DEPT did and what brought external wgen introduced in DEPT.
> > > I was considering the exactly same thing :)
> > >
> > > Again, lockdep that tracks lock acquisition orders can't do that.
> > >
> > >> [1]
> > >> https://lore.kernel.org/all/aR3WHf9QZ_dizNun@casper.infradead.org/?utm_source=chatgpt.com
> > >>
> > >>
> > >> It's your guiding example, that's why I mention it. You do mention other wait
> > >> cases here, I don't know anything about them, but for folios it's really just
> > >> "we used a single bit so far" AFAIKs.
> > >
> > > It doesn't matter whether it's implemented using bit or not.  folio lock
> > > is quite special since it's allowed to be released other than the
> > > acquisition context that makes lockdep impossible to track them.
> >
> > Does that really make lockdep *impossible* to track them? IOW, there is no way
> > to extend lockdep to support lock release in different context?
> 
> Yes and no....
> 
> lockdep has no knowledge of control flows moving across threads in the
> way that I assume DEPT does.  But it should be possible to tell it.
> 
> If you have some code that takes a lock and then hands it off to
> another thread, at the hand-off point you call
>    lock_map_release(&the_lock_map)
> 
> This says "no task owns this lock any more".
> 
> maybe you put the folio which is locked on a queue or an lru or
> whatever.
> 
> There is no way to say "that queue owns this lock".  Maybe that could
> usefully be added - assuming coherent semantics can be designed.

It's certainly useful to track who owns the lock, but the essence, when
it comes to deadlock detection, lies elsewhere.  DEPT is based on the
essence, that is, a deadlock comes from waits that are never awakened.

> Somewhere else some other task takes responsibility for that folio and
> the lock.  maybe it dequeues a page, or maybe an lru callback gives the
> locked page to some code.
> That code then calls
>    lock_map_acquire_try(&the_lock_map)
> 
> This says "this task is now holding this lock" (or more accurately "now
> holding a lock of this class").
> Note the "_try" - that says that the task didn't have to wait for the
> lock, it just got it for free, which in fact it did.
> 
> Now if that task takes some other lock, lockdep will see a dependency
> between the page lock and the new lock, and will accept or reject it as
> you would expect.

It's an interesting approach if your goal is to track the owenership,
but if the goal is for tracking dependencies.. well.. I'm not sure.

	Byungchul

> So you definitely *can* send lock dependency information between tasks
> with lockdep.  I have only tried it in extremely simple cases where a
> single object is being locked by one task and unlocked by another - no
> queues or lists.
> There may be - and probably are - more complexities involved with
> locking folios and passing them around.  Maybe it is so complex that you
> need all the support that DEPT provides.  But I'd like to see a coherent
> explanation of how the functionality offered by DEPT is clearly better.
> 
> NeilBrown
> 
> >
> > I guess there is a way, but the question is at which price (I seriously have no
> > idea, maybe this was already discussed and people have a pointer for me).
> >
> > >
> > >> [...]
> > >>
> > >>>
> > >>> Q. Why not build DEPT into lockdep?
> > >>>
> > >>> A. Lockdep is stable, battle-tested code. I chose separation because
> > >>>    while DEPT borrows BFS and hashing ideas, the wait/event model
> > >>>    requires rebuilding from scratch. Lockdep was designed for lock
> > >>>    acquisition order — retrofitting it would risk its stability.
> > >>
> > >> Why can't this just be some configurable extension to lockdep
> > >> (CONFIG_LOCKDEP_XYZ) until the feature is stable and can unconditionally be
> > >> enabled along with it?
> > >
> > > Answered?
> >
> > Not quite. I don't understand why this must be a completely separate machinery,
> > even if, conceptually, it would do more than traditional lockdep.
> >
> > Is it either DEPT or LOCKDEP in current configurations? Can both run at the same
> > time?
> >
> > >
> > >> I don't quite buy the "would risk its stability" argument. A lot of stuff we do
> > >> "risks stability", every day :)
> > >
> > > That's awsome anyway :)
> > >
> > >> Is there another good reason (incompatible with X, dangerous with Y, cinfusing
> > >> Z) why this really must be a separate thing?
> > >
> > > Roughly:
> > >
> > >    1. Similar or less effort is needed for the new one - retrofitting
> > >       lockdep is not easy and big changes are required since the
> > >       reusable parts are not that big.
> > >
> > >    2. Even though you didn't agree, retrofitting it would risk its
> > >       stability.
> >
> > Well, I don't buy the stability argument, really :)
> >
> > Retrofitting effort for lockdep is an interesting point, though. Lockdep
> > maintainers would have to make the call here regarding direction and feasibility.
> >
> > [...]
> >
> > >> But I am not a locking maintainer. I think there was plenty of discussion in the
> > >> past, so I might just be raising points that were already discussed in the past,
> > >> but I really just read some random pieces of earlier discussions. (ideally
> > >> previous discussions would be summarized here)
> > >>
> > >> Long story short: we are now in v19 and I think there was pushback in the past.
> > >> Did the opinion of locking maintainers change, or is there a way forward to
> > >> integrate this in a way that would make locking maintainers accept this?
> > >
> > > One of locking maintainers who I met in an LPC told me that he agrees
> > > with the direction of DEPT and supports DEPT, not officially tho.
> >
> > Hm.
> >
> > >
> > > What he and other people are concerning w.r.t DEPT the most is, false
> > > positives, which is the most important issue for now.
> >
> > Thanks for highlighting that. What's the main reason for false positives? Is it
> > something conceptual that is mostly impossible to solve, or rather just
> > implementation work to cover all edge cases?
> >
> > >
> > > At the same time, I think the most important thing is to make DEPT
> > > useful in practice especially with folio locks involved.  Actually, I'm
> > > planning to share DEPT's true reports periodically to LKML and work with
> > > people who believe DEPT can make things better.
> > >
> > > Any advices will be welcome.  Thanks for your opinions.
> >
> > I think we must come to some conclusion on how to proceed with DEPT. I see the
> > following options:
> >
> > (1) Don't merge it and carry it OOT. Shame if it delivers real value.
> >
> > (2) Merge it (after proper review and acks from relevant maintainers ;) ),
> >     keeping it entirely separate from lockdep.
> >
> > (3) Integrate it with lockdep on a high level, giving us a single locking
> >     dependency checker, but mostly letting dept have a separate implementation.
> >     Look into possible merging afterwards.
> >
> > (4) Retrofit and extend lockdep to really have one mechanism.
> >
> > As the saying goes, it's hard to teach old dogs new tricks, but in the end
> > taking care of two dogs is likely harder than only a single dog? :)
> >
> > I tend to favor (4) (or 3 with possible future work to achieve 4), but I am not
> > a locking maintainer, so really they have to voice what to do.
> >
> > I do see value in DEPT (even if the folio lock might be handled differently).
> >
> > --
> > Cheers,
> >
> > David
> >
> 

