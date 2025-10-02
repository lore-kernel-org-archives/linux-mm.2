Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B49CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 23:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120DB8E0005; Thu,  2 Oct 2025 19:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8DF8E0001; Thu,  2 Oct 2025 19:20:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28D38E0005; Thu,  2 Oct 2025 19:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1E498E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:20:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8809913AF7E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:20:13 +0000 (UTC)
X-FDA: 83954744706.25.8A3DDFF
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6767C1C0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:20:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=UlZXQBIH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k l+kmDG";
	spf=pass (imf20.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759447211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8eLJoj9XRO384G/VvXT2HeFOAWEdoc6vPNt14uKR73A=;
	b=I7LcuOG2D98SZKAegK/bbjKKbygaKLkjr7sQOgZIgJgPWZZsqHqEb85iRG0ZzEpBmEHMpD
	wLhiADE+AJ/ysBqAeiUnmwKSHUR7MqzwxW/CjN7HKtjCvI6fjseBvQ0J2T0LS9+WWJwMaC
	K2BUw930qJINT06sm3x1txZJUNPZedo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759447211; a=rsa-sha256;
	cv=none;
	b=SRkIAR5rImq0l0/Q6nhO9C9WvY5LUb0SW/PvsP8ecB/pg56T/UGuITCNE09y2qHVWs9U8I
	zn2S52HLCjmU+MXzDTFV5cZ9NwkJD/mCRP6nfjLNy+1Ed3eqLKXhK+d7iwa94GqD0uT5Ic
	YoNUVOgrL9dLMa/8gSaJFy2K+lVjlWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=UlZXQBIH;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k l+kmDG";
	spf=pass (imf20.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 5EDC31300340;
	Thu,  2 Oct 2025 19:20:09 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Thu, 02 Oct 2025 19:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1759447209;
	 x=1759454409; bh=8eLJoj9XRO384G/VvXT2HeFOAWEdoc6vPNt14uKR73A=; b=
	UlZXQBIHPI3UaJe+qvjb/0azu1Oe5qtfVSOgfR9F74ejhfdVcoLT5yCscAFxGXg8
	pwym4mpSChHvERlZa3eyvyx08BV44zMw3YGN0tM+vPnhSUz76Sq/1sLgdMvN//1t
	MgHWqimhr0AzYrwUzdnliiWe0Dm9Z34Ogn+/sldz60VOggZ3d7nAO9W0sjAS+ODa
	YJDWUIJqUD3rBGsCWCRyC9s7i9AA9pS/qByHexvhH8G1gQsu2dD8k1LeI24HGUWh
	/03Dje8K6N7L4VyDIt3NIojzwr6tdgIOBwfeBK5umF7roU56mWwwY3FulE7R0j2n
	QUpOkKf5lBp7bdgkzhLbPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1759447209; x=
	1759454409; bh=8eLJoj9XRO384G/VvXT2HeFOAWEdoc6vPNt14uKR73A=; b=k
	l+kmDGOAq1pzbEHRrFdHT4SzQqoXwOUYgPQJ4+NVqkkjCIeSBkcTaOjzyNQXiU9s
	kMqLYKmFJfJ1GhIbhxhYCfqcOfowqa+yTq9mxHLKEsS8XBm9IzjFZHCtziGw5fXF
	/e+dklx/ViB8axzcHlNMLJclo8C99PYXc2Y8o1NY1WJNGSubZUdsdyXNaDrhoA0g
	zVXRaYA88qe9f8W0wqgGFPKtmrNF7KyZiJeUaP1Vi6aGzrn8qKUG/UijUtJdVNwN
	GpBKBpnC0UfKe5ILDs82D43oLROPvOxFZGXqV2x70DKb4kZSvCPb5uAwEn3OsKMW
	+CWkwvFhQPYEzWSK3QiWA==
X-ME-Sender: <xms:pwjfaMVOef4mhN6E6mNkhBnCtV5OvG6xakRRLaAjp23f9AkJh31dag>
    <xme:pwjfaLZblqXr3U6Tog_yZBWRfYWrQojGAEIWdpJwRtSk4N0FF9lkdhdjaP3Wg5DXA
    WqDpffa-89lqJTG-sF0jfrUp4thRaqdyxsRPTVhJ50p_zjB0ej2BlMn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekjeefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeehtddpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepjhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrghdprhgtphhtth
    hopegrnhguihdrshhhhihtiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghnughr
    ihhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrnhhnrgeskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheprghstheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghrrghu
    nhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegtlhhrkhiflhhlmhhssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:pwjfaFLmuZHi-oAOjNqsoWX5trpVXddbCghSckyhf9eLMfReNDI2PA>
    <xmx:pwjfaO2cCCpMN0LkDZJO2HEuTpjEbV8vQegShpmUeBqXiSwuuxK5bA>
    <xmx:pwjfaFymskEJ8c1lx2ABkTnXjL-0WwOhRyDnyS9u95DEhNh3ANnhnA>
    <xmx:pwjfaOxfyNrnoXNiZ8GUS0u0xAgssBIdPeWkQB3SnXzueR4-hEPyPw>
    <xmx:qQjfaKoVwtXti0-_XNDa7X4jWYPd2zpFEHU4haBui7asxErybcWxQfeU>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 38369700065; Thu,  2 Oct 2025 19:20:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: Aghr8S2aY07B
Date: Fri, 03 Oct 2025 01:19:33 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Byungchul Park" <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
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
Message-Id: <3bbe14af-ccdc-4c78-a7ca-d4ed39fa6b5d@app.fastmail.com>
In-Reply-To: <63034035-03e4-4184-afce-7e1a897a90e9@efficios.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-2-byungchul@sk.com>
 <2025100230-grafted-alias-22a2@gregkh>
 <63034035-03e4-4184-afce-7e1a897a90e9@efficios.com>
Subject: Re: [PATCH v17 01/47] llist: move llist_{head,node} definition to types.h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6767C1C0004
X-Stat-Signature: cna8e3x63moro31zyne1yy8nwfn78ntt
X-Rspam-User: 
X-HE-Tag: 1759447211-733158
X-HE-Meta: U2FsdGVkX1+caADf+jBEKRPLqPw+rFJ+KDhB5aDBiD24VkdFJBIK3FiXwMcpe2A7B7MjnJ9TxcbAh8cbNwH8HuX3yTehlZj5MyAIHZ0kljYlxWhE4QmQpEXd3RRxq00mz4FvnnO63g5PF0iXkLyYf/fVDta3EJI9YFdoAPlSRUrpDJKXO+59LozKmOM5kwEHlyGYYI+gMZip0fMk4HQDgBgZMP1J8avCcCNHquJxbWb4AEV/froCowDNV3kQjs6BChOZ2IPQOSGQzzbKmSfFvb8PPymsoQ0laiMibbyPDRTOD2pZRm5v5GgODVR3YMdIYSxWeBwfSP/QIeyzlcvNJNtwFwU68+ktSWFUowkZbtxAHSqNjz9CmkNbn6uM9xmk+TkgaNGi/5/biaLxfoFjQgD6fDwYGc2BhemmhmFUA1QvdJL5RFQQZxcqd5bzPHLSWrYr0mfowMBuHE5mKbtkVxBfySjZ83tBGYNyoLUQhneaMllN7ePrDxEazFDh5mIDzS3UzdNLPMNwAZksE+YF/8fBDZB4L4vDQVsD3Y+BHR3/nQXh38xeG9pPbT1GoQeDJzKDyiZfKSM6by/IyW2P/hWqrq1oXGjyFvDbfCZmKsGTGqtGfsSHYtNzjSDeQ5fsZlomYTUm9vJFwjbTlOPlDYLPTdZq5KXHckGcC4RaaxOPAn0l9ezCPomyOBs0uh491ysJ3ke9VcLOkYVeNGiP1iHfSgzvq0Sey/0MuwG9BtzLi0VyxPo8rkxatFD4X+TyRMSZYhH5Zaw7/+Pc4hGE3aZ5yj32b1+QJTUvQHO5Ubq9Hvs1OmUbLUrqqc2Q9KMrAOF1HZd3aKOGUiIz+mFqBeElvA5iVCnl6sxhA0q5kd0utA64zxnkMs9Xh2Ly7SWnhnuMRg9FDwu9/LQsWEg1UX7T8QMQkqlHyKzWvyw+gK8OOLlNwjocVdkKL8nRTfHS85I0YNQ5aNO4D9RXXTp
 lfafa8AJ
 9VIVnEp0sCJczxjup4sxte2y4w5JeR/zafTNPE5Fip78JMlkBMfb2+gphKQf1Zfbt4NOx7HN9XpBA2Ase0cimiOcWv+wTV8LYJBtR+O86TcwyE14MN7UrQgagVHrNC9SXcq1fwtFgXnrTd3nugSbpdFIr1JxrCnWMJUTSAR8Uqyy/l4pBTsHcouzOWrSgL30aIHFweLjswE0VQiVNhIvjVbTaOfd2qFYEYIVg6lxzUK0Ot+MPLcgQqiQiURDfjrL8jyB4s4z+vj5hKjm9BJLFQtAQmHsAcuLOhz1NJeNUdB9BB0Ejqn34lZ8JmxTk649DtK3ctAWb+g4x5SY244glYkEdvJigA/oHjrOA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025, at 15:53, Mathieu Desnoyers wrote:
> On 2025-10-02 04:24, Greg KH wrote:
>> On Thu, Oct 02, 2025 at 05:12:01PM +0900, Byungchul Park wrote:
>>> llist_head and llist_node can be used by some other header files.  For
>>> example, dept for tracking dependencies uses llist in its header.  To
>>> avoid header dependency, move them to types.h.
>> 
>> If you need llist in your code, then include llist.h.  Don't force all
>> types.h users to do so as there is not a dependency in types.h for
>> llist.h.
>> 
>> This patch shouldn't be needed as you are hiding "header dependency" for
>> other files.
>
> I agree that moving this into a catch-all types.h is not what we should
> aim for.
>
> However, it's a good practice to move the type declarations to a
> separate header file, so code that only cares about type and not
> implementation of static inline functions can include just that.
>
> Perhaps we can move struct llist_head and struct llist_node to a new
> include/linux/llist_types.h instead ?

We have around a dozen types of linked lists, and the most common
two of them are currently defined in linux/types.h, while the
rest of them are each defined in the same header as the inteface
definition.

Duplicating each of those headers by splitting out the trivial
type definition doesn't quite seem right either, as we'd end
up with even more headers that have to be included indirectly
in each compilation unit.

Maybe a shared linux/list_types.h would work, to specifically
contain all the list_head variants that are meant to be included
in larger structures?

    Arnd

