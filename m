Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E5C0CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989058E0035; Thu,  2 Oct 2025 04:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A1C8E0003; Thu,  2 Oct 2025 04:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828B88E0035; Thu,  2 Oct 2025 04:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CADC8E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:24:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 253A0C039D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:24:54 +0000 (UTC)
X-FDA: 83952488508.15.864D7A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71EF9100014
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:24:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=i5+HKGpb;
	spf=pass (imf05.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759393492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03kPmqkL6R0pTNGRa4j3+2XI77gPNS4i4nkDiyOd2Kw=;
	b=tONo7RvjO34wkLGrX/zCB4JaK0vsheogaYrOPRhseKLZFnKDXqLeIjSYo7ZB9pkPNhF+p0
	YJBhKMVJEZJ8bQ81Y9VX4WUk3vs7S5+OnLq11GCwVh6D+PvK3lMIBaF9aeMfSXsnc1Jn6e
	W5RBy0OgQYO+9pNyP/wpfDB6kzvabKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759393492; a=rsa-sha256;
	cv=none;
	b=PodnK0ee8qg0XvZ6+JfiQReZjuay9BoDuJesf076vsCeNgAaeSx1YPcs4RHU9Fi5EfhZSc
	r6tKbTRAPJmzXX5zkQiDzSQkuLHUHDSIPndjOPvOlVx2ovqp5tzMSCpDMJlFDlJibq9hc3
	1MD5q+lKlPgoxVmXW0+I0dPmXUrUsZg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=i5+HKGpb;
	spf=pass (imf05.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C8D043E43;
	Thu,  2 Oct 2025 08:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A32C4CEF4;
	Thu,  2 Oct 2025 08:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759393491;
	bh=EGta/OBizNM09PGf6rEuH2ZEVwPb5dGKC+KMXznpC2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5+HKGpbYKH37uF6UEmHuZtFQv6O5ZG1HxMQr8kvde7omSAD+zel/Z4+s6JwdJrZv
	 Ur3S6DldaheLi+GEdKKHX1ZJ+iRyil+oU4pwd+w36q87VybbM/v+qrAgAFV69+RNbv
	 WsN8AOHH246elLsfI0Z+lVr0mIU6QpnW71c2yL1s=
Date: Thu, 2 Oct 2025 10:24:41 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, kernel-team@lge.com, linux-mm@kvack.org,
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
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
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
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 01/47] llist: move llist_{head,node} definition to
 types.h
Message-ID: <2025100230-grafted-alias-22a2@gregkh>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-2-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-2-byungchul@sk.com>
X-Stat-Signature: tmdrkxio9h3ba1nm3u79bpw8augo4enr
X-Rspam-User: 
X-Rspamd-Queue-Id: 71EF9100014
X-Rspamd-Server: rspam10
X-HE-Tag: 1759393492-248220
X-HE-Meta: U2FsdGVkX19HnMvfHOcdQt8KQlbnATpOTshOANu7RXkdNO43VUP2d2ghwWDcxhmVefV92NW1YAkOcCTxh+CElCVszLstK+4S0ksBksaPpNMNqJ/FW9eN5eqobv37qiOVUaAVDF98xPA5DWRaZ99JqT2rARD4CPJt0sbjeziFplUZvoLPcs2iR3bEU3i8LPDoZRhcnA19Cr4J/g9T9eCPXKcjc8NqLr2ekIQRvGHBIBzRsnAZa8N1beofs9d8/el+E1EspVKt4HwnGAU1eOOJAv/A1OcBJ9Ubc8ufg/q677Ut1qkwmaWfudFrisDXNWAYQER9lC4yGrJkb4uswYQWi8sTgPpqhac3HwaAayb+0XjZdbpdZAfqOjiXCtomIajhhphZLbYMjGPPw4IaAzcYNzMBaSF0dfQ3VYDx6zjldnoq5RdT0OqXpZs4ZdNwXrbNGq+0ERvnIAPlNYMuTpXKUNaFmGYvf7hxjWrbnugZ2I0MCjdsojpa/ZZFiySyDt/tSQPGwF25wQQGW7dsqSYi0EH+IxglIruv6MzEyid1EoPZmGGaikoosX4NBpIXo/5XS48EkA4n+3Y8bFKU8jxOpMCAQPe7kShQuv41RXKn20//6gAOPEjeyXTbno8R+j36OvFVXAHVw1laKMrF8ylE2GDzBZC6taB3Eq+pCrJnPDsQn4H/XpIcw1gfSXwC2G+dNH91Wx0Tk/EGLSVO1F4+gEkw59UUn3M7tFFmXZrddNYs46iBjnp5whY0ckl5Q9+cfGw7ibp2AlcgwuxJFAfGiwt5zmTGZmf4WlGaGBAQsOftymrtoMMb/mcRiM+x7d8lLUFpjEA4/wQxXpDmoQM2QTfY6tqzM92CDH9eSF42RuefM8rL1f64ADVcpBcCCskuDQ+HKxhKu/e2iIyDj+SfXTefSke2prbWqxK6V4QXjnILhp1uILooCLQEISsTjG9nKmzkBCZvny97o8o1G4z
 TgsoFB+b
 eI9ikeNPgTEhuprRx/rgV+zNLtcXg46daMjnOadI60lbRUUZJKhGPqOqaTNr9LpCHr1NdzCuAzHCTiTd9gjoGcGE2iwwSfaBmGdzhBeCCuDxEP4D3KAuZmpCShEMFncogUfmkd46b8/WDJnqIfQwG5Z/XQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 05:12:01PM +0900, Byungchul Park wrote:
> llist_head and llist_node can be used by some other header files.  For
> example, dept for tracking dependencies uses llist in its header.  To
> avoid header dependency, move them to types.h.

If you need llist in your code, then include llist.h.  Don't force all
types.h users to do so as there is not a dependency in types.h for
llist.h.

This patch shouldn't be needed as you are hiding "header dependency" for
other files.

thanks,

greg k-h

