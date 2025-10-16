Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDDBCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E718E000B; Thu, 16 Oct 2025 03:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEC78E0002; Thu, 16 Oct 2025 03:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FA68E000B; Thu, 16 Oct 2025 03:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60A8A8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:59:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0452785D15
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:59:49 +0000 (UTC)
X-FDA: 84003228540.17.9AACC30
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf19.hostedemail.com (Postfix) with ESMTP id D671F1A0013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:59:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=zjoVnsXq;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e YaxV+0";
	spf=pass (imf19.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760601588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsmN9Z3FJYObp60BofhTavDFXwdg3R8bCLb5lDfrp7M=;
	b=YOzTSQfu9x/zibLUldLhi2StsKRQ/FwMO00cU7KMKRP3YXq7ZLUiNZUsX49PBUEyHriaZ6
	xid2r9AlOqtg5zLo+xN4rOfRYBN8JsP7jr6TKPC6jZpA6k9sLABPXrlU6Ym7meRzg2AMdH
	pwIVkEJxAmL7StEZzgQT942Eh5acL5A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=zjoVnsXq;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e YaxV+0";
	spf=pass (imf19.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760601588; a=rsa-sha256;
	cv=none;
	b=XAQU+efqXafa+TpUZRpMqUdXrV3klHImNqMf7d/SDCBRBTph6sQ1XxsDzjdN09tHsKd047
	D24yFL+Bs+a7aOtad+Qt0b2/sqShA/J9XsVZzsflDdZt8w9dubzNLDl4/QmBCZ18/X1glq
	F2uKi5A0d6VMKYDuSFzGReveqLbeJxs=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id C4DDB1300638;
	Thu, 16 Oct 2025 03:59:45 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Thu, 16 Oct 2025 03:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1760601585;
	 x=1760608785; bh=gsmN9Z3FJYObp60BofhTavDFXwdg3R8bCLb5lDfrp7M=; b=
	zjoVnsXqZ+yPdMiSKoBt/sycXUhVJXYHDXfdCZX7rUPNZ8Ra+jDBVs1GdrQTImXi
	osHWvkwSSbmoQQX5xXB34f1uqSIafpMFsQSs7kE8pjSTwdVaFvMItOoS4hnK+7zj
	iqktI1QOJt1IQqxV8hGIyRQmXRnE6e7PX8SUbaBRWYxrmtUdYffGosu+w6p4vCF7
	s9cfSSWz9xSb0clMcDCeP2EH0ntEyI2GTVjkqgQJ2r7dMoQlvCWsF0Nyv2TAh1QL
	6CK+he+Y0O2e8M+0zYqJ3Wvk5XHb9kUmsy8FEn80nKShyuWcLBGisiONfrRyVyhl
	cEiwZ0s/IpnOuFMGoAlNMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760601585; x=
	1760608785; bh=gsmN9Z3FJYObp60BofhTavDFXwdg3R8bCLb5lDfrp7M=; b=e
	YaxV+0VtPSHyf0CyecZzlDvBNM3ckBVvtHkAQ65SHwSf+7Yu2UfI8KkUjS4AyRja
	sV5rcFfeaSlU3NJM+kz4Spzlgr05zNrz12RYr/fwLOWoc+tZfcIhXDUiPpOWLRz+
	lUM31itCANeZ5OS+zg5tDHTuYee8yfEuU7G4B8P6/CqjhzgWF6g87cJ0lIrD/jxu
	H1VE0B9ZnZYspsEjsosjF60DByuk9OCDp1otHTk3pUqhmxSeV/Zxl4V+Yuu2jMUJ
	rXjoUIYr1abVnpV2r21tVfr8+plhIm7qzvU5nt0uvTH7rbae41rhv6qimap9WRIY
	Ez4guQtD4od9aItkZAaPQ==
X-ME-Sender: <xms:7aXwaOSbMZnWs0SRf6HBqvAdlJERv26b9FjxIaKww7N1FusVKvgtsw>
    <xme:7aXwaOkL7RU_CbzqAtYTj7y1qukmjqSM6-yoM0pdsmISl2AWS6NiDwJ4N2cvihIzP
    IxeGlXiI9K2--AbeUh_H_pF4GFG2SJsK8cRrzUQbIJz5nj91j3taxo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdehjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohephedtpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgpdhrtghpth
    htoheprghnughirdhshhihthhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrnhgu
    rhhiiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghnnhgrsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrshhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgr
    uhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheptghlrhhkfihllhhmsheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:7aXwaAUTjpjw6r0oxiNvkglwW5pVhkSy0AeAW4wfF2OVUJkKD3MLTA>
    <xmx:7aXwaL2gD5C6KZQaCJKwh1wbE9hKPtsLZXDLbqi-S5OER1ASSQKXoQ>
    <xmx:7aXwaJG9VEsPH6cTPpr-xCIF4JNmz2BTNf3RXNeoWTtfWoNs-spOAQ>
    <xmx:7aXwaMDcbF6nGy-8s3le8LhXxUNCc1ElHPQHKBbIJzDH8Nf4m1XjjQ>
    <xmx:8aXwaGsp9IExbTi465Z1IOSncJh1UQ-25zaKyPyndCFjbwUMRaaHbQnJ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C2CC7700063; Thu, 16 Oct 2025 03:59:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: Aghr8S2aY07B
Date: Thu, 16 Oct 2025 09:59:11 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Byungchul Park" <byungchul@sk.com>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Damien Le Moal" <damien.lemoal@opensource.wdc.com>,
 linux-ide@vger.kernel.org, "Andreas Dilger" <adilger.kernel@dilger.ca>,
 linux-ext4@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>, "Will Deacon" <will@kernel.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Joel Fernandes" <joel@joelfernandes.org>,
 "Sasha Levin" <sashal@kernel.org>,
 "Daniel Vetter" <daniel.vetter@ffwll.ch>, duyuyang@gmail.com,
 "Johannes Berg" <johannes.berg@intel.com>, "Tejun Heo" <tj@kernel.org>,
 "Theodore Ts'o" <tytso@mit.edu>, "Matthew Wilcox" <willy@infradead.org>,
 "Dave Chinner" <david@fromorbit.com>,
 "Amir Goldstein" <amir73il@gmail.com>, kernel-team@lge.com,
 linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Minchan Kim" <minchan@kernel.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, vdavydov.dev@gmail.com,
 "SeongJae Park" <sj@kernel.org>, jglisse@redhat.com,
 "Dennis Zhou" <dennis@kernel.org>, "Christoph Lameter" <cl@linux.com>,
 "Pekka Enberg" <penberg@kernel.org>,
 "David Rientjes" <rientjes@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, ngupta@vflare.org,
 linux-block@vger.kernel.org, "Josef Bacik" <josef@toxicpanda.com>,
 linux-fsdevel@vger.kernel.org, "Jan Kara" <jack@suse.cz>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Christoph Hellwig" <hch@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, dri-devel@lists.freedesktop.org,
 rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
 hamohammed.sa@gmail.com, harry.yoo@oracle.com, chris.p.wilson@intel.com,
 "Gwan-gyeong Mun" <gwan-gyeong.mun@intel.com>,
 max.byungchul.park@gmail.com, "Boqun Feng" <boqun.feng@gmail.com>,
 "Waiman Long" <longman@redhat.com>, yunseong.kim@ericsson.com,
 ysk@kzalloc.com, "Yeoreum Yun" <yeoreum.yun@arm.com>,
 Netdev <netdev@vger.kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, her0gyugyu@gmail.com,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Andy Lutomirski" <luto@kernel.org>,
 "Sumit Semwal" <sumit.semwal@linaro.org>, gustavo@padovan.org,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Andi Shyti" <andi.shyti@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Luis Chamberlain" <mcgrof@kernel.org>,
 "Petr Pavlu" <petr.pavlu@suse.com>, da.gomez@kernel.org,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Frederic Weisbecker" <frederic@kernel.org>, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, "Josh Triplett" <josh@joshtriplett.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Lai Jiangshan" <jiangshanlai@gmail.com>, qiang.zhang@linux.dev,
 "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Dietmar Eggemann" <dietmar.eggemann@arm.com>,
 "Benjamin Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
 "Valentin Schneider" <vschneid@redhat.com>,
 "Chuck Lever" <chuck.lever@oracle.com>, neil@brown.name,
 okorniev@redhat.com, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, trondmy@kernel.org,
 "Anna Schumaker" <anna@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, "Kefeng Wang" <wangkefeng.wang@huawei.com>,
 "Mark Brown" <broonie@kernel.org>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "David Woodhouse" <dwmw@amazon.co.uk>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Alexei Starovoitov" <ast@kernel.org>, "Zi Yan" <ziy@nvidia.com>,
 "Yu Zhao" <yuzhao@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, usamaarif642@gmail.com,
 joel.granados@kernel.org, "Wei Yang" <richard.weiyang@gmail.com>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 tim.c.chen@linux.intel.com, linux <linux@treblig.org>,
 "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
 lillian@star-ark.net, "Huacai Chen" <chenhuacai@kernel.org>,
 francesco@valla.it, guoweikang.kernel@gmail.com, link@vivo.com,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 "Oleg Nesterov" <oleg@redhat.com>, "Mateusz Guzik" <mjguzik@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-modules@vger.kernel.org, rcu <rcu@vger.kernel.org>,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev
Message-Id: <6241800d-9456-4d5f-b55d-611e33f2c446@app.fastmail.com>
In-Reply-To: <20251016004640.GB2948@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-2-byungchul@sk.com>
 <2025100230-grafted-alias-22a2@gregkh>
 <63034035-03e4-4184-afce-7e1a897a90e9@efficios.com>
 <3bbe14af-ccdc-4c78-a7ca-d4ed39fa6b5d@app.fastmail.com>
 <20251016004640.GB2948@system.software.com>
Subject: Re: [PATCH v17 01/47] llist: move llist_{head,node} definition to types.h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3hznsckwrw5snh6n1tfo94z481f4ebhj
X-Rspamd-Queue-Id: D671F1A0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760601587-238344
X-HE-Meta: U2FsdGVkX18Z7YqALBnHBeZ14ityPO5YSztr3ea2iqps1PKlnYbkvypJPKMwL7WyDeGqi+yIB+dkHqrU55H85LOkgFYV65k3KmXO1IW6zXabGfaTgzEZD9x9hWfiZGAOMgox9YhBYxjppMQQVVCKk5GcnsQtCTZn0zI4f0FCexdBMotGzpI1IbyMVDn3Hist/XEjJOdLZ30BhU0ow6Qfp1dQNDRciAhSw0tETArfE2jPMroGKiWMeOHUuY/MV6crsyI60+h+F5n3ZNU8kvVhE/QZ3mcfPtcd5462MEv5vDj7/Sw//tep+ujHqHy8dY0VwG/zGUG5VtnjUNItCID80+yfvRkjo21tjGh/W6LHe4uAJboSl7bCycBcNpE8WbCQqIZfd18jepe9JuQRqcHCc0DiGJlvY1i1aUHjH0SeEnF4uv6cQ4yxkA8AyTy03Zlknbxijl+VwM7ibcYPsB7vpE1lB4SKYa8faZwdP1vrJQcVXFgk6ZdsW9GVWZUzSHznAkgBfli3nnz5nDE6JVJRqIkgWf4iFrNQWKB5VtPkfgfl+N/v/igtgTnsbqoGZ5hLbZUhfo2BlSLSXUV9Wcl+I9Qfz3JLTsXP6wu1GhttWTywbGZoqyQs/l1R2Pdry/qtsk7AyUd3hgR4qphH1vfH7rTrHHyJFVDTuuG0oGeExQPsU4Y4/+KLC9tf53pSsTozgQfJeK7uRDdvvS2+CS4NB62RNIzKnRqrQlUPjKoygfIfKK62ZnuMN6ofknZnoowkUadnsJ+LjxpKZyZP8QTs2MUechHnaMutkePPSb9f5EXVkCp1KZyz++qMHnEgQVYwtv8u8bHF5akTyqOBtWC+5Fb96CyVyKGa6hR2P5u3bhqmhsYSnKv3ym0xUVa88GOLF3zmbpRN3m9rIVVbBxqxRPVXL7yuhLa1Zva3MdWLaHqIdLCmH+U5UWhorlWCzXQR0oRnsuTdzcqsP4VBGaQ
 esuBywR+
 OJFhFSRG94ZR0BVMEybfIut/kdoeOl2f3gNV91BDBMBfjthXHt7TYRGmAK+03ozWrusP9HdRQz6vIfrbucGRTg8iuW2fiV+fJZP2CYSNkNJPsn0t6c2XT0ldDuUfxdFkp33yGXJcDboYbaWvnB7TBoP92UJiKSEUDnF6lv4+J8R+Gm/kjqMRuWexPtOi4hvKef6A81Q1JT7S+KhJYHvDBPhApV0N+pu8mjgAY+G8ZVw2VR8LTqFTWxqp+e7w2MefzmAUoYpS5XkPyPWdVSAwd4W7P69qqnchMnFAIGvZNTPEtraypETOXTI8gdMYE1yEgIarAb3JCU7VMzZfu/rzqBK0p8EdIoxTjcC+bDGw4QpnrDee0WSNovY2PgA8ns10jHdPQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025, at 02:46, Byungchul Park wrote:
> On Fri, Oct 03, 2025 at 01:19:33AM +0200, Arnd Bergmann wrote:
>> On Thu, Oct 2, 2025, at 15:53, Mathieu Desnoyers wrote:
>> > On 2025-10-02 04:24, Greg KH wrote:
>> >> On Thu, Oct 02, 2025 at 05:12:01PM +0900, Byungchul Park wrote:

>> Maybe a shared linux/list_types.h would work, to specifically
>
> I found a way to resolve my issue, but I thought it's good idea
> regardless of my issue and took a quick look.  However, it seems like
> there's an overwhelming amount of work since it might require to replace
> all the existing include <linux/types.h> for use of list things with the
> new one :-).

I don't think it's that bad, since almost every header ends up
including linux/list.h indirectly at the moment.

A little bit of scripting to find the headers that reference
'struct list_head' but don't also include linux/list.h reveals
this relatively short set that would need to include the new
header:

> include/keys/asymmetric-parser.h
> include/linux/dynamic_debug.h
> include/linux/genalloc.h
> include/linux/gpio/machine.h
> include/linux/hiddev.h
> include/linux/iio/iio-opaque.h
> include/linux/iio/sysfs.h
> include/linux/input/touch-overlay.h
> include/linux/irq_poll.h
> include/linux/iscsi_boot_sysfs.h
> include/linux/kcore.h
> include/linux/kcsan-checks.h
> include/linux/kcsan.h
> include/linux/lockdep_types.h
> include/linux/logic_pio.h
> include/linux/maple.h
> include/linux/mfd/iqs62x.h
> include/linux/mlx5/macsec.h
> include/linux/mount.h
> include/linux/mtd/map.h
> include/linux/mtd/nand-qpic-common.h
> include/linux/mtd/partitions.h
> include/linux/mutex_types.h
> include/linux/nfs_fs_i.h
> include/linux/of_iommu.h
> include/linux/parport_pc.h
> include/linux/pinctrl/pinctrl.h
> include/linux/plist_types.h
> include/linux/pm_wakeup.h
> include/linux/reboot-mode.h
> include/linux/shm.h
> include/linux/smpboot.h
> include/linux/sunrpc/xprtmultipath.h
> include/linux/usb/audio.h
> include/linux/workqueue_types.h
> include/linux/zpool.h
> include/net/bluetooth/hci_sync.h
> include/net/bluetooth/l2cap.h
> include/net/bluetooth/rfcomm.h
> include/net/dcbnl.h
> include/sound/i2c.h
> include/sound/soc-jack.h
> include/target/iscsi/iscsi_transport.h
> include/video/udlfb.h

A lot of these don't have any #include statements at all,
which indicates that they expect to only be included in
places where the dependencies are already visible.

      Arnd

