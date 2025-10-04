Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31C0CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 16:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99DC8E0006; Sat,  4 Oct 2025 12:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71368E0002; Sat,  4 Oct 2025 12:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86EC8E0006; Sat,  4 Oct 2025 12:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B93588E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 12:39:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D83B1DC26A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 16:39:51 +0000 (UTC)
X-FDA: 83960993382.19.4AADF83
Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	by imf05.hostedemail.com (Postfix) with ESMTP id DEAA410000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 16:39:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sang-engineering.com header.s=k1 header.b=PNedKPiX;
	spf=pass (imf05.hostedemail.com: domain of wsa+renesas@sang-engineering.com designates 194.117.254.33 as permitted sender) smtp.mailfrom=wsa+renesas@sang-engineering.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759595989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYWXAVcToZjL216N14wevIUTr5XEGs+BI72TKUQOPN8=;
	b=punp035iXOxY01iN5Ir4mr7jdCneWd2rZ9l4O4lnYBdhg3NWll9VHAeKjZ1iwdKDQb6SIn
	km73HK7JvW2mVuSnzjaRdDgJbhNHR1ZEKlXbvkpjg25Qf1XAXGS9TEs0LimXLY84WT8bnN
	NHbhn68x/Lk3iTC/6Eyq9sPUvgoBpCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759595989; a=rsa-sha256;
	cv=none;
	b=aJF/+67LZbPAXWENlZMfPfS+IqDW3Y5BF4LlZ4j8qyPCjtnNi85uYdFD7IUGSto7raL8OV
	LcnCH2Vnq8UxIHm5fD/pormJPQDOu5OkipJfcqLa7xaEGySlWB88oLR69iD8inS7t2XnAH
	7iPk0uPq+ddEmL6yzabulwslfkj7AqI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sang-engineering.com header.s=k1 header.b=PNedKPiX;
	spf=pass (imf05.hostedemail.com: domain of wsa+renesas@sang-engineering.com designates 194.117.254.33 as permitted sender) smtp.mailfrom=wsa+renesas@sang-engineering.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=oYWX
	AVcToZjL216N14wevIUTr5XEGs+BI72TKUQOPN8=; b=PNedKPiX4oCj4bpedhVz
	E+/1zG4RS6etGvHx7daU2DUWMNccTF0z1BMx94C/uGTZ5muouJ1sCi+Rrrn+I0yb
	QX0tCQTPUifcb+5NvLnilNYtzPuaMC9afpJzRPyfpW8YSMz2Kk2sAGveGofpt2/U
	FgjEfDef1ztsgRt/i/fhnznfm7TM0Tf+A/tZDrAPd+4jSPssQfBLtqCfRE58HIfm
	D8PcLW9fA6b0Ln4SDcQwSOwdrXhoroqBaJXPWi2lQd/dVTkvYzyJpOcaiTLwaahq
	J+U+4x2W131yohhie5t+CaEw/7wpjC2Zja7YEDIcma8nk3Y5vfr5rBO/vRmlQllV
	Rw==
Received: (qmail 1087916 invoked from network); 4 Oct 2025 18:39:44 +0200
Received: by mail.zeus03.de with UTF8SMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 4 Oct 2025 18:39:44 +0200
X-UD-Smtp-Session: l3s3148p1@ZNCL3VdA3IqSRnW9
Date: Sat, 4 Oct 2025 18:39:43 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
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
Subject: Re: [PATCH v17 35/47] i2c: rename wait_for_completion callback to
 wait_for_completion_cb
Message-ID: <aOFNz2mKXCXUImwO@shikoro>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-36-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-36-byungchul@sk.com>
X-Stat-Signature: zysfbpoqju98k7a8hshufuia36fmbhrw
X-Rspamd-Queue-Id: DEAA410000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759595988-599836
X-HE-Meta: U2FsdGVkX1+HW3KAo9mlWdUxOfWGTXAGj6hEx6yDne2faNQrXfHhMP6DKS7OJucOHXRgu5TZb73UCETwNhoco2WcSXxYKkJQxQd9ejNmuA2kvL2zcggryJxDgr5fyIf9lA0NQDP1cH3VRf91ZyP9J38EZvgjszWxzhkReVwaDEkZVL+9sfEHdU29tK/eQ9xfwiUfjYyarhPdE3917lpmecdLyUICKK4A562y2UTJFO49PnTFZ/tcT6cTq8HiqkcLEtt4MvOcAlEu5pvyiiX9FbKrm3ktkjftLPcD1bEzdoCsBi1avjhNHdNdW0KRq9buU0+wiFrfXf9af9DBjP9Es8B8x/YX6acc7R3LEKZnuRSTLMhvE9g/E0ViRFwEnpdW0kH6+X+C54jNRU2QTd/HSU1Sw2dFd2Ycz4JxxVH/uE8/iSvH/FZhZj3EuunnZxB74fblUzqFRMQGU6AwsT4NUS+jDK7YHXPc6Ewpg4FPFQtGTHfYuQq51kqGjh+Y7BkuoLjz7DGCjyptn6iqske1h2M8hvPNWhua1p95vqPsvT8O/y5ZwmCWa0CTQAPGKA45B6Fxvpa/2PBRxKq8s9A5+65eT/CYhyi13sHqFwBcl4rx2SpFdOivuoyQ/W6gJlFlKmtoMj//PHXU+M/SxEvC/NdI7xDUkLpqguunPDiOBWYR6xzilug1B8XZWmuWxff1mvIlN6X6xAIx/hrKJidAy5kDxF8QQzQybRjIPIb3ygHRo7fJEi1uR6yVyY+SKW1ksJSzGxYyQ2027d+DWtTqapSLNKgAprD6qgSO9q+MtbKfI6xFAmIPPJBDxP7xQXt7FPAc/kTaK9nNXoQtcCudzzP5Gk3fvwpGJyJQU0fNQdNGCeKuvymhxhlI4vFhXgvYuRlh5DhIOrHnSu8wzCthPFX5O0Osr8EiIpevmPlA246igOvIEgfPxJCsrTpdkYjGrxCoMYxwjvkLdf03IGJ
 Ax3NkGt6
 qMjWd1IeSmf4I4TBx9DEb70KcyzBfb8Ognm6iGnw3S0SfTigJVU83hHJVlT29J8Hmj25uTnxjQbpo6FSzKy9/9V7H38u4E8vmZYUuB6HdXBxqWC6B1rA4Bxk6I1plbdMahbiGICgqVNL/x3riRyCZHYdAi94lmqPAFhdKUVnOIJET+kpyK3RyRiOUxwz+PJzxvnAUva2qN+qYPJDTXLNb2jHuD1ITZcEEFeyjSo8OwqLK2uaKOOdid033+YMFqSWUrYfJknJ9iTaxcgxuPmhujA8eM9Xj9VKinJrlcQHMJoEgw/Ki41/eHCv6tXmqQfbaOEujw3PXVMJ02iQN9V728Hicy2qKNVSt/5625RC7k8sr3D3/igDBCxDCYWu4xCaX5qooN9qWexnL0QiMLf41d8Td589iVO/5veIvZGFplyikg+ZCSV9wGi0ZUwKyFj64YCxTQ2QUWuJya9o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 05:12:35PM +0900, Byungchul Park wrote:
> Functionally no change.  This patch is a preparation for DEPT(DEPendency
> Tracker) to track dependencies related to a scheduler API,
> wait_for_completion().
> 
> Unfortunately, struct i2c_algo_pca_data has a callback member named
> wait_for_completion, that is the same as the scheduler API, which makes
> it hard to change the scheduler API to a macro form because of the
> ambiguity.
> 
> Add a postfix _cb to the callback member to remove the ambiguity.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>

This patch seems reasonable in any case. I'll pick it, so you have one
dependency less. Good luck with the series!

Applied to for-next, thanks!


