Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B766C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBFE6B00A1; Tue, 25 Aug 2026 08:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D5E6B00A7; Tue, 25 Aug 2026 08:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055286B00A9; Tue, 25 Aug 2026 08:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9C2A6B00A1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:13:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FECB1403E4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:13:30 +0000 (UTC)
X-FDA: 85139682180.03.5CE59DA
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FBF2140003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:13:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DuwGKF71j3RrUfPSw5BRzHnAWG/JDt2iihqHl7/ivg=;
	b=A1QHvHCAeg0mIxDOpZGlvOADLxgB32w8cnagxoX3cfn16ywYBdygG+ob4ZfHZ+jwPwr6X5
	D9Qm4HwnWo5r+fkXa/vYgTa3jl+sYFrgSXh3omNeqO889cEDrRG+W8Dz9qzEuz3yZ/SkhR
	6y3OpwQqRP6b9TUF9FfWR7Gslcd+OMI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660008;
	b=ou8GsiZKExmDjwFq0HZ9mjpTLWhdjo5j05VH7ClCW8xvjS/6Feyfo5pNfI8RBW+rGFqGa0
	ashj1U2YFQ0Ih8+asFozFXV5a0hVBKZPe/7X42jyecQ+tC7Zf2KScAaOvh5CxD4ELBI0+w
	GB/TmHykwfpLoRhppOyw/2g+QmYQ+6s=
X-AuditID: a67dfc5b-c45ff70000001609-66-6a8d86e2f8a5
Date: Tue, 25 Aug 2026 21:13:22 +0900
From: Byungchul Park <byungchul@sk.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
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
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
	lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
	tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
Message-ID: <20260825121322.GA23086@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0ybVRiHPd+9dV0+KsrZcM5UUbPJxbnEN0aXSTT54hJjdCZGzVgnn1Is
	sLUbjs0pg5UUxgwru0g7WBnXUdxYR10tNDoc7diKUIimItCMYauWuogClrJhCzHyz8mT8/7y
	e96cHI6UO5i1nCp/r6jJV6oVjJSShlfVp94uO5ab4RlIhFH/JA13TVdY0FtraPDP6BHMRU0k
	/B35mYVFpwvBKa+BhL867jEQ9nfRsDgWJCDaP0BC/a0xEjpd4wiCtnkEztYSBn6pspEwPLka
	zCVOGryeEIJakwFBYMRJQGnDRQa8oQUC/M0BCm5WnSMg0tzGgqdhlAJT/zANLkuQhQvhARr6
	xn+kIRQwMOB3l9HQXhkgQe+YocA5shFq6kYZcNknCBh2nGFgvH2RhmLTHA1DlkEKLgZ9BFzu
	95AwePwYDdV/BBD8dHqKheaZOywEfigjwGV+CDqOGFkoa7xEQFNrmIagsZaA72amCKgeMjMw
	39KLQFcZYcHipeDkgp6Bo7pTFOivzcZex9LGbH1JmNN9Tgm6obuM0F7XjgRdVexoujnFCM5Z
	MyXcOIeFxvJ5Qjjenyp8bRxjBbN1n3C5dYPQ0P0bIVjbyhnBOm1ghfror+TrinekL2SLalWh
	qEnfslOac3h6++7Tj+932PxkMTr8cAXiOMxvxu4raRVIsoTD33xJxJniU/C13lImzgz/JPb5
	ImScE/kMHLxeEstIOZK3PIJP+N1sfPAA/xzuHD3KxDtlPODrkTXxjJz3IBxuWS6S8Qm4r2aS
	ijMZK12oGyLjeZJPxi33uOXr9bjUZlpySfgteMR2Zqn+Qf4x/O1X7iUv5mcluLs8SiwvvQZf
	bfVRVSjBuEJhXKEw/q8wrlCYEdWG5Kr8wjylSr05LacoX7U/7f2CPCuK/ejmQwvv2tH04Js9
	iOeQYpVs52uVuXJaWagtyutBmCMVibKDhypy5bJsZdEBUVOQpdmnFrU9KJmjFEmyTbMfZ8v5
	D5V7xY9Ecbeo+W9KcJK1xSgjuic5K5Tq7Es5b/iz6dJbm9DG7trVnx3IzAzwXV88cX/9P4nV
	jjdSz+5yNbpe/P68r/p2kna9/ZXnn+3NfHqROvnerj2BdUlHBmSdngveSbv1k1s3pOu2TtgL
	Jh49MXa14+DbT7nmd3zw+313Xv5UapjIUqdPpfQ0hJj0Dsmr7oRtXTsUCkqbo3xmA6nRKv8F
	QULAa80DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxbZRTHfZ7n9umlsctd7cbdZmasW1iW7C2ReXSGqF96NZkuZkpijKOR
	u1HKy2wnDnUZpdbVMSdrbAktTMStW1bGECiOLc2QSQcDwptzDAoF7UBCEYeUhXdvtxj5cvI/
	5/zP75wPhyUqB13P6rOOiMYsXYaGKhjFm3ss237/8uv0neHoFrBZj0MwFJbBb+YGBqLTNgZK
	rlRQWHT/JAdbdbEMmu/mM9BZ6UUQitoQPJx3E7DWLzOwaA/IYXq2Xw4OM4JlfwCBs8tOoLfz
	BoGKWjOGf6qWKIzfnELgGA5TKBozMzDpOYXANeKWw1iTFiZC12WwPDCK4e5MBIEnvIQh3HAC
	waLTAN+V10jjzr8pzLd3EChydCL4fniAwNTYEILawCCCUd8cAv/FfAr3C30EesKr4NfoJIUW
	RwGFia4SDH9VUSjL98ugq20cQanbjmCkz4/B8sMVCs7Sagbqh67JoWt8AUPQacfgrd4LIc8I
	A62F5Vi6WXL9GA/uIguWwp8YHJev41c8SHhoPc0Il2rqsGDtXqRCxdkKJMzP2ZEwfd5CBGuh
	lN6MTBLhi5pPhPOtESrMRe9QwT9Txgi3y3nh3FdzWDjTvk2odw3I9736nuLlVDFDnyMadySl
	KNLMU/sPF206es0XInnI/PRJFMfy3PN8z43LOKYZbjP/S5OFxjTlEvje3lkS02puJz/anC95
	FCzhvBv5b0O35LHGU9wLfG2wQBpgWSUHfPPsuphHxbUhfuLCY5CSW823FIeZmCYSdOFsN4n5
	CbeBv7DEPi4/w1t87ke74rgkvs9X8gi/hnuOb6i7hQvRKtcKkmsFyfU/ybWCVIaYS0itz8rJ
	1OkzErebDGm5Wfqj2z/MzqxG0rN6ji2cuYqme7SNiGOR5kll2jun0lUyXY4pN7MR8SzRqJWf
	HTuZrlKm6nI/FY3ZB4wfZ4imRrSBZTTxyjeSxRQVd0h3RDSI4mHR+F8Xs3Hr89ATDbuzK5Pb
	f276aIipTeHeUree02SXvuY9UWC6c7vyj6RgYgLZMd4hnt61721D1drXg5tn8o7vTh38QBb0
	NiUm39ubu/9FXHwxsGbw3lDbg2cPft4iFrwUGL5qflC21r6Rvrunv3FhXbnNrXp/a117h1aj
	jnRCt+wb7f2+eK0hoT+iYUxpul1bidGk+xf0qtPwqAMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 8FBF2140003
X-Stat-Signature: kqsbqyteqcuftqaix6w3hxzefgmcj9h3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787660007-699583
X-HE-Meta: U2FsdGVkX18z3ZcgP6vDvEdAQXttYqoVSEOInSCC12TImHzLds6BUSOcrSItKrDZchdJ5mMoxXtAV1g3rkKjxy9SxuXkvaRIWeyrP/kpK//Yk+ChxGdZ4So/f6WGQhLiu4880ySef0le4KnJfiUqX92ozKIhiYXQ4MkCBflNkt8FdlQ0acLR1xqurupMGgfArwU/gP0r/rvQQoMZapU9ytc+Rfa6N9Prodpw0dPUyluy8NoM7hWaOBBE+zlU+VsJYEu2xC+44/OSU20Y5Gyh+rD5gzsLpTP5tadw2bZaIQERNHw0HgDZ54+XfJYiNeRA/t6fW2mlYN2rj9/V/St1bvpbzupXmWg/mMs5+JA8uLzByqRjgUmctkP9YRDaUIb3qiHHa87jNsqg/oC2QiQwouVDZOekcSuYn3Sq/mbLqoV0W3sOp0ffxFMO70BnnD61sMOh6zAwLm9kP+Ni2uni/xb6JXtj0sCO77TrnaYf0V1o6w2QG62T1+KJ9VFCy4Qabn3C7iHfeHnY6uw0rjolcu1rdF4le8rELFAuiDwMdKHpvGGtczTpUmM31+BNzmsRsnvI1Adt2677oN/KkvBT6TQbnefGxPYFwD5ITLuI9b4rkBAJ9NfxOXVQ2smucZJ+8BEx0F0F9os4r0QHwh3yCRzc82WPeKlhbtFTFdK6QrOF2sG8EHh+CNtOmzaEUy3N8dm/wWqKJklLwWTgRZgo9oBEyHi01Xd/PJ++s81oq4bPaDEykWuiJJC7z0Rf+Pocj8/00LV6J+7cgAmoYV8Ntg/qlSHJzTMXjJuiSnuihn0/s4oKUiwttWxlxP0hO7mvzAV1PZgjGOlMHjb2juDfw0UZC1fPevOh+jF2tFNCXLvnEvyCs9Y4/U3va4SN52izNFtAkuTa5FX4ToF7BmgyAQdZmnP/h+4AoGxRN9URs2xrQRlMEHlirmLafC5rJGlp6v6FQiDcsBZL1eM6JM+
 lGbD8tbK
 Rfw1r0SYdoJAhkbiVBsRgh4aDt0Vp8ZMyerJFu7/Ml4mFCzjLVt6NeM2LxbkKE1m+KLWB941oIXNIjz1t3V1z8bGc+fL0ro1gvqCWToEyCPbBWTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 09:56:05AM +0200, David Hildenbrand (Arm) wrote:

[...]

> >>> Q. Why not build DEPT into lockdep?
> >>>
> >>> A. Lockdep is stable, battle-tested code. I chose separation because
> >>>    while DEPT borrows BFS and hashing ideas, the wait/event model
> >>>    requires rebuilding from scratch. Lockdep was designed for lock
> >>>    acquisition order — retrofitting it would risk its stability.
> >>
> >> Why can't this just be some configurable extension to lockdep
> >> (CONFIG_LOCKDEP_XYZ) until the feature is stable and can unconditionally be
> >> enabled along with it?
> >
> > Answered?
> 
> Not quite. I don't understand why this must be a completely separate machinery,
> even if, conceptually, it would do more than traditional lockdep.
> 
> Is it either DEPT or LOCKDEP in current configurations? Can both run at the same
> time?

Yes.

> >
> >> I don't quite buy the "would risk its stability" argument. A lot of stuff we do
> >> "risks stability", every day :)
> >
> > That's awsome anyway :)
> >
> >> Is there another good reason (incompatible with X, dangerous with Y, cinfusing
> >> Z) why this really must be a separate thing?
> >
> > Roughly:
> >
> >    1. Similar or less effort is needed for the new one - retrofitting
> >       lockdep is not easy and big changes are required since the
> >       reusable parts are not that big.
> >
> >    2. Even though you didn't agree, retrofitting it would risk its
> >       stability.
> 
> Well, I don't buy the stability argument, really :)
> 
> Retrofitting effort for lockdep is an interesting point, though. Lockdep
> maintainers would have to make the call here regarding direction and feasibility.
> 
> [...]
> 
> >> But I am not a locking maintainer. I think there was plenty of discussion in the
> >> past, so I might just be raising points that were already discussed in the past,
> >> but I really just read some random pieces of earlier discussions. (ideally
> >> previous discussions would be summarized here)
> >>
> >> Long story short: we are now in v19 and I think there was pushback in the past.
> >> Did the opinion of locking maintainers change, or is there a way forward to
> >> integrate this in a way that would make locking maintainers accept this?
> >
> > One of locking maintainers who I met in an LPC told me that he agrees
> > with the direction of DEPT and supports DEPT, not officially tho.
> 
> Hm.
> 
> >
> > What he and other people are concerning w.r.t DEPT the most is, false
> > positives, which is the most important issue for now.
> 
> Thanks for highlighting that. What's the main reason for false positives? Is it
> something conceptual that is mostly impossible to solve, or rather just
> implementation work to cover all edge cases?

It's because of lack of annotations for proper classification.  As Willy
mentioned, different call paths for various usages should be annotated
with different classes throughout the kernel.

> > At the same time, I think the most important thing is to make DEPT
> > useful in practice especially with folio locks involved.  Actually, I'm
> > planning to share DEPT's true reports periodically to LKML and work with
> > people who believe DEPT can make things better.
> >
> > Any advices will be welcome.  Thanks for your opinions.
> 
> I think we must come to some conclusion on how to proceed with DEPT. I see the
> following options:
> 
> (1) Don't merge it and carry it OOT. Shame if it delivers real value.
> 
> (2) Merge it (after proper review and acks from relevant maintainers ;) ),
>     keeping it entirely separate from lockdep.
> 
> (3) Integrate it with lockdep on a high level, giving us a single locking
>     dependency checker, but mostly letting dept have a separate implementation.
>     Look into possible merging afterwards.
> 
> (4) Retrofit and extend lockdep to really have one mechanism.
> 
> As the saying goes, it's hard to teach old dogs new tricks, but in the end
> taking care of two dogs is likely harder than only a single dog? :)

Or it's better to train a unmatured hunting dog than to teach a pet dog,
how to hunt, for better hunting, even though the pet dog might
eventually become able to.

> I tend to favor (4) (or 3 with possible future work to achieve 4), but I am not
> a locking maintainer, so really they have to voice what to do.

Right.  However, thanks for your opinion.

> I do see value in DEPT (even if the folio lock might be handled differently).

Thanks!

	Byungchul
> 
> --
> Cheers,
> 
> David

