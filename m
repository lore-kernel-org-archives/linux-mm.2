Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3A2C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 03:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1426B008C; Mon, 24 Aug 2026 23:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882166B0092; Mon, 24 Aug 2026 23:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7245E6B0095; Mon, 24 Aug 2026 23:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47A086B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 23:42:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B095212030C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:42:27 +0000 (UTC)
X-FDA: 85138394334.22.AD66BD9
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF7604000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:42:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm3 header.b=nZITRrvU;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="i 2fKlB+";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.142 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787629345;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJ0oTTauqUSSV8YPrFKbEbgb4sKqhN11H0KEY9B/4wg=;
	b=mDcdruvIp++/V62bVanMKFEE6djEaronuSPUAGvmdi4Sv03fBfBQsbw9NsPGYwgppSHsta
	dsn00JK3GdgVJWUI1w+9AdouWTVOmK/cVco4SmzkQyvAyCnMkejQD9np27g1OLwHmYiShD
	x3yV+QnOEWQt8KJ/nqYbSw3HgKcHUVY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm3 header.b=nZITRrvU;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="i 2fKlB+";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 103.168.172.142 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787629345;
	b=bfHJPtrdKLL6wWfXcxp0Snh+km6+K7t2Zs+SnqVys23jKC5VGwr7ocs3bsA+UdVfPxM8Ww
	zQEdmNNGrYj9wmT3qCwXW+iaNbVz/T1QuwL95kLDXolrb9L+y96fcnq2TUn2gR5vJs5uSX
	ZzXvi1AZaKWMUGO03MdKKp++2iZKQJo=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 0BB24138007E;
	Mon, 24 Aug 2026 23:42:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 24 Aug 2026 23:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1787629345; x=1787636545; bh=rJ0oTTauqUSSV8YPrFKbEbgb4sKqhN11H0K
	EY9B/4wg=; b=nZITRrvUtxjGhQWPCc+YBA/V8pmBB+w5+Us3WUo2duB1QjCkwy6
	Od3rl1vmEN6CjWQXdI+LVF6d1iAm+4DrL9OTp9h1RlBs3D6V+/IauxLIjsjp+SfG
	atFjm0T7Pm4ShnLCs6fxOMS9oT8wFJ/xRL96sxFwCz7HRTrEmcjGs3p26a65johl
	/XjMblWc9YjjbkpPUP3nRCRfpsre50xt285l2uggtLvhBYFtsM3JycuIyW4a+KNk
	GW3fm3db4Gdc/7dpMJtmicl+ZxfEGpOTW50nG8n6uFKJFC0MOCFXObQkxDgMjqgh
	5+6GHD2x3e1S6f7vC+kPuUtWSJUDT4L0WbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787629345; x=
	1787636545; bh=rJ0oTTauqUSSV8YPrFKbEbgb4sKqhN11H0KEY9B/4wg=; b=i
	2fKlB+SBpWvud1Q4DZ5q/7SYH1e1RfTHq46U5CSVJYzUopKQLjojsJqfVY500Qr9
	Bkz4zrt+mFGB9IJAAurQ9cv+CcTXHtw/tRipD1i6+7Zo9+jYP1lZ+WYeLqJnZRxS
	UwKCNLkwSQ5ct7Nf0slQ8f3PVsWPGmL7Jez2+lyUWmqaQMvnZ67lODUp+yEyyQER
	IaGeJ6wXNzl10D45HXT+JwoDb+b+MZwQ4f+KXMpUa6U1Oj8yQYK7G7g8NfH+XIvM
	wJANlRDjImCSDrMW8WHjyrKKgmLQwyGe4c3gtYb9zCwiM979ImVN+aLGbVd02+3H
	clSESga4DCfuaEBZ2aerA==
X-ME-Sender: <xms:Gg-Navde2Nm-usag5Q-qSkMeNgfOUv8lr4P5rbWgPG0MEaMExL9bRw>
    <xme:Gg-NammFuGgk4hLw2b1WiBeXS09vpveIvJBgL5qFWeijFu5spu9zi_CFHlZsiflLu
    dgP5g-nt50AcWKBstOc4-fxK6bi5ZizMg-pj6ZpBC9YSTzXZEU>
X-ME-Received: <xmr:Gg-Nat_JQ_w_F6jWM44XpleuBL6IzAMQDJbZk9W4zO02LXgRLJL0N_e8_mkbRzJlNVViXi8ka_hZZDPDWBDK5XMpU0u97rY>
X-ME-Proxy-Cause: dmFkZTGAYKKC/opulm/8vN1Pgo3asbuTyz6PzixwG0v2vNyg3v4NaUYL6GcL+dZq4gFy/i
    iUI6IZttRvbp59MYWeAeR9ywajwoEVC/szTNNz4g5RWilAriWV9/6iACKnkefi0Xhka8ao
    UI3wIZg37/v3uedC0JIC4liLFj+4wza2xL9MLC2hJqF8TRlk/vKNVDTEZBAmzjnpJ9Ml8I
    5iKfDAIjNBIsPRXlRJmQO/GxM52tDp4MH6k1h4YLsvZ4+eLPTX6HVMRWl7kV15NubEgjn5
    AOX/iV0DZoSSut8p3lT4vfzjnQ8vEu6SUzCQWqmWO17gc0q3YHwvKukMn2Jlw6OSBo39M4
    kp2c0I58cDLCIs8+pOuxlOaG9oDQXUq/dDRSL3VnDMojcLwC7R+1UVGwM9qZvYa7Xs90Z6
    AYna48qAPi/du6tHtGe9BEaTqDNVGp1aqwebSjpsC2ModsDqa9WM4VSQ0/0+pvNyIS6FrV
    ytGapxE/eBv413TmuD1tDDZr63FPme2bRmO1uIcvcJaZy0zsGgJ75xaLJb1TaWS4e4tCP2
    kUhBDjDH+bcV7bINMKq96WD1HDhh6mSovIqT6cEeBtnDlfZGx+RAiPA1VVV7JWAYktB9iN
    Y/pMAMGvdPZ7fJVM1EBoCPRZddDsklrerz9cFnPjihjjr9174sV2sILEoZrw
X-ME-Proxy: <xmx:Gg-NalubECiEGqnpBIMXfrvPavhWvY7Lg6urBXuqIe0ygNNYu2DD1Q>
    <xmx:Gg-NaoAH6XiRaTgo6XZ-CO_OY5Y8erO18iTKrmzHISotHVvYHg6Luw>
    <xmx:Gg-NanChCkA9x2FDaiSO6iQAh1f3_IpDurOSNfWVtYCEhfk_1rg9vQ>
    <xmx:Gg-NajPWmintf1CRv95G0G7XeeVwpE53q8WgvepVBCeWJ4MZT8sQvg>
    <xmx:IQ-NaqkzmXf-SjwABxUsJdluph06cGOFumGsbCOVtUKNRMcwiO1f9Lg2>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 23:41:38 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Matthew Wilcox" <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Byungchul Park" <byungchul@sk.com>, linux-kernel@vger.kernel.org,
 max.byungchul.park@gmail.com, kernel_team@skhynix.com,
 torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, david@fromorbit.com, amir73il@gmail.com,
 gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
 hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
 jglisse@redhat.com, dennis@kernel.org, cl@linux.com, penberg@kernel.org,
 rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 hch@infradead.org, djwong@kernel.org, dri-devel@lists.freedesktop.org,
 rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
 hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com,
 gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
 petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
 paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
 mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
 qiang.zhang@linux.dev, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, chuck.lever@oracle.com, okorniev@redhat.com,
 Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org, anna@kernel.org,
 kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
 mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
 broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
 shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
 yuzhao@google.com, baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
In-reply-to: <ao0AieB7zg5FKD39@casper.infradead.org>
References: <20260706061928.66713-1-byungchul@sk.com>
  <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
  <20260821042143.GA40890@system.software.com>
  <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
  <178730572084.2852630.7732425311008244683@noble.neil.brown.name>
  <3d58eb3c-7a9d-4183-907b-46172664631c@kernel.org>
  <178761465493.3510150.12380729360578969391@noble.neil.brown.name>
  <ao0AieB7zg5FKD39@casper.infradead.org>
Date: Tue, 25 Aug 2026 13:41:35 +1000
Message-id: <178762929532.3510150.18274428053274599221@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: AF7604000A
X-Rspamd-Server: rspam07
X-Stat-Signature: pbaruc4szj749syr1qfzbdrpomg6grs8
X-HE-Tag: 1787629345-845793
X-HE-Meta: U2FsdGVkX18TMx2RpXAA3p/fNZfghCUg3STGMdMLmxGY6EkjEoch11Bhf9hqpYsyRUVOTpQgA1W0IR3e2tfu5EiPfqpXIrbjS6gl4JqQtJgz2RLi43myB5i9Hi4FcNkkgGKrlzrNglH8TVTOjnx6q3bkZsJzMIkuKo5kzCq0XrmQ7hftcXZM3yTn6de5nQ/bUykLk9yTrLjyMylJfLm9HjixIJj0HVOFZEHh89hCfffwfTGzDaiOI02ZQ6KjkFcpgInVBXa/fwoVAovxneEhe/5ZnXCpIYxqmFwMv/LBMIt2gy1SKkHx4prFvMKPhfSX1wtLAEsqyZtGE73GJ5jJlbi8ZpTnLdusVCaEOuEKHPZdO4WPoTjkKkhIBoTYqwAdqmMfuzbBcJj9kA4Z1LdCGFo2GO8AvUSK+/QfQNUfyEisw9WWMXQtv1thXNXQ9bhkrc0LnhCbPYpiqzY1WW42BpBQ7tElZUeRREk6xkOV2/VCAACdlcao9XagAlIVd+0MCDrKENKKGyA//7bREJFTVK4frUGOxZ87s4WsVldSDBLT2U058+oYFgAcOD6GahytcgtIlCb39WKIO8xmESCrW2QN3dafA27W3nPmj6TOu8Co06TIN6zjNZCBHw76JD81JIzaCi4c8yimwBluW5n3wibVdaO2vbIgWjGFJirWbXI7xVLbF0C+MiTdEBeSZTeZGhgNECP3WEUznpF04WAvPujI0UXFrpHQJElkUULcA58uOHlmjUjl2I+8CKMDf+WzdOq3yDjFbpUEXwQs4TlvukTjbsNhuLCZOuXZ5QEK/V7oeErgZxaJDWrghEuK8VAELnRpTg6Fr2u/jrM72NrH0lLAC4h8J0N2JBrdlGzIaKGGuzQH0D2Lft1SHzXGAxOrNg446tDs8FCGDCgXJa0DethIta+K6M+//18Zt/CYgRK/tghYU3mUGETw0a7shG0KifPBzjRSrQMDShEtRkU
 +6ElP7Hz
 V4DiDs+HigZOBt8jj/F/eBtk0Vw6BvwXzLvn6cqb7i7PGSTO3sU/TjZRyrvJg8PbkqRU49YcAvajwHF+Kj8N5isetRQ7kx3cz71Gw2jjw9yPnqOgZAyw+eENHuF8mBq6XL2HGvhU/aaZIF1MT3mF8xKUZnk6BeS8XreKQLyZ/zPURsOCPtACwgli3DvNRp4rFXHy+UtKdowtn61NSIRI0zMsASHThOLhR+MZ0gIzd2Gj46PCP+NKLTSWR5CDaGgIS1ODkZzwNDAxefgCB+SksuZPjVBOyY+I884UdlGJE94NgMODSMO5/TDq/IUzv6u9bAeIN8z4cBjVBfsS7oqjCuBbWdqqPyGMihhzrsJwHfgDuVC0gE7uiDbev5ij75j8LxESYz3shVrKsL2I+ciOO0puZ43MU+jBBJrDGr8tTbCfaPqlOT40w/YVnIGZDYyp6za0dFaeCLI3tNtgujhTs8yL4BvVN5w9z7uBldFh6Ol8rgEL0YHjsBMsd/VU2TgpX/RQL1QKRYsAilK9KpYtwA99XCwlmBRDNErDQ+TIupxtMo90JN+jOHynM+2tdcrlFYmS4AzJ+fhnkrToyvedRgK4iHyCKFDIaoDV8rAX5L5JZXXLSKYD/d+zbXDWG+aIB3DJdH8MXE3RAMDPd60Mns5Dj1Iow6qu1bwTZNMC8g70q8+jCe3v9wdr43HJB+9gKSoV2YeJwe76b9VYnqjsyHof9N5mo7UvS+ZwhTW9f6CuhY6zeUuE3sZ3OWFYV3UnBsxHG55D/VJVdSAECE+WeE+vbB41mHCd8TSbIpW1bdXFMjmzeg2hdQnBkJo+CHeGsmcXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026, Matthew Wilcox wrote:
> On Tue, Aug 25, 2026 at 09:37:34AM +1000, NeilBrown wrote:
> > > For readahead, I think that queues / lru are not involved. We submit th=
e I/O,
> > > and once the I/O is done, we unlock the folio from interrupt context.
> >=20
> > "submit the I/O" means "attach the page to a "struct bio" (or similar)
> > and attach the struct bio to a transmit queue for the device (or
> > similar).  So there really is a queue.
> >=20
> > >=20
> > > end_buffer_async_read() / iomap_finish_folio_read() end up calling
> > > folio_end_read(), where we do the magic
> > >=20
> > > 	folio_wake_bit(folio, PG_locked);
> >=20
> > Exactly where the lock ownership should be reclaimed is not immediately
> > clear to me.  bio_endio() might be early enough but there are probably
> > better points.
> >=20
> > A small difficulty here is that a bio has multiple folios and they are
> > all locked.  I cannot see that lockdep has a concept of holding an
> > arbitrarily large set of related locks.
> > We could just tell lockdep=20
> >   "I have some folios locked"=20
> > or maybe enhance lockdep to allow
> >   "I have N folios locked"
> > or even
> >   "I have N folios in address-space A with the highest offset being O".
> >=20
> > This would allow lockdep to check the validity of locking another folio
> > - only allowed if the address space is the same and the offset is larger
> > than the previous largest.
>=20
> It's more complex than that; see my other emails on the subject.

It always is more complex that you think, isn't it...

though I found
 https://lore.kernel.org/all/akvueAxPl8aoLvMR@casper.infradead.org/

and think that you are saying the same thing as me, though I'm probably
not saying it as clearly.
To say what I think you were saying, but with possibly different words:

  We don't want to tell lockdep that we are locking a "folio".  The
  particular folio is irrelevant.  Rather we want to tell lockdep that
  we are locking something at a particular offset of some array of
  folios.

The vfs_lock_two_folios example is much like lock_two_nondirectories().
We use the subclass mechanism to tell lockdep "trust me, this is OK".

>=20
> I think we need the ability for lockdep to call a function which says "I
> hold this lock, is that lock OK to acquire".  But the devil is in the
> details.

I doubt we need arbitrary callbacks.  lockdep doesn't try to prove the
locking is correct, it just tries to prove that the information we have
given it is consistent.  So if you say:

  spin_lock(some_lock);
  spin_lock_nested(other_lock, 1);

and later say

  spin_lock(other_lock);
  spin_lock_nested(some_lock, 1);

lockdep will say "fine, that look good", while you or I would say "hang
on, that looks weird".

Similarly for folios we just need to decide what information we want to
give lockdep, and how it should manipulate that information.

I think that locks on ranges of an address-space is the sort of
abstraction that would be most useful.  But if you thought a different
abstraction would be more useful I would certainly be open to that.

As an aside, d_walk() needs to lock a dentry, then lock a child while
holding the parent lock, then drop the original lock and move down the
tree. i.e. it wants an arbitrarily lock sequence of overlapping locks.
lockdep doesn't have any direct way to express this.  It has subclasses
so that it is OK to lock the child while holding a lock on the parent,
but there is a smallish limit to the number of subclasses.
So d_walk() tells lockdep it is dropping the subclass lock on a dentry,
then taking (try_lock) a primary lock on the same dentry.  This is a
"white lie" that leaves lockdep with almost full knowledge but without
confusing it.
This example highlights the idea that lockdep doesn't need to know
exactly what is going on, it just needs to know about the stuff we
want it to check.


Thanks,
NeilBrown


