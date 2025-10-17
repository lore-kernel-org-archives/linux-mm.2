Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB67CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA6A8E0091; Fri, 17 Oct 2025 09:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391198E0006; Fri, 17 Oct 2025 09:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281968E0091; Fri, 17 Oct 2025 09:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1056E8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C349D1401C1
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:45 +0000 (UTC)
X-FDA: 84007739130.27.79AF9C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2B1080002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=piKF3E5N;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708984; a=rsa-sha256;
	cv=none;
	b=LYIJSNCp/7z8CPodDTlURaii5ZF+seqPF7zZlWU742BG1+S4Oy7aagxm4kwLlBCi2SOMSJ
	zeU+1Gsh89Jh236ailiHilzqIBxH9Po8g8UpQ7ViAC0rBaRIC93YV+RyWYUZNgJ+14Gzdv
	d9uBvE1XpxczbdKPO+hge7y95wxpyYY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=piKF3E5N;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=LCCTFhOpm5ZTT7S3/peueBw8Hng5N/dbi0f4vcLE3r8=;
	b=7q0MRvDyipuHoqB81zdyBJAM9Hg7QoFR1eC+Y866d+Iey15WyetAfWS3gmwruYft8wF720
	ejEJsPKV0rD1jdueYDKoVwOjUcXHq3cdhf3eA8rJ81o6NoSSrXAcs0UYmH/kgj1386pIFd
	QGu1VZD1vTvlbUqKEHPx5srqMc5B/zM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB8AD4B441;
	Fri, 17 Oct 2025 13:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8400BC4CEFE;
	Fri, 17 Oct 2025 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708982;
	bh=d0Lj/2AqY2X8XCUF/V0nGmJ12l2I6aL9uJ3UcdWXAAw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=piKF3E5NOTogSiG2bqw2AlRUUhPn2MnFQmyQHase3t8PHdRy01JpU7J8csTljlN9F
	 5qredvA7i+PtSPOuoAMsl1ERDx3Dlklt7HoMccXcSz/XoUvVeSZLbpH/bAmYz43xbs
	 kfvHuE512+fNJMnD/OXpj2N15LN/T8LVhVLi4nJ0=
Subject: Patch "minmax.h: move all the clamp() definitions after the min/max() ones" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, artur.paszkiewicz@intel.com, axboe@kernel.dk,
	bp@alien8.de, brian.starkey@arm.com, bvanassche@acm.org,
	chao@kernel.org, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsterba@suse.com, dushistov@mail.ru, evan.quan@amd.com,
	farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hch@infradead.org, hdegoede@redhat.com, herve.codina@bootlin.com,
	hpa@zytor.com, intel-linux-scu@intel.com, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	jdike@addtoit.com, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mjguzik@gmail.com, mripard@kernel.org, nathan@kernel.org,
	ndesaulniers@google.com, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chels.kvack.org, io.com@kvack.org, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:32 +0200
In-Reply-To: <20251017090519.46992-26-farbere@amazon.com>
Message-ID: <2025101732-maximize-compound-46ca@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: sotkfbcgzzgmckjtmmu45qae537tfspa
X-Rspamd-Queue-Id: F2B1080002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760708983-868258
X-HE-Meta: U2FsdGVkX193CzHtPFJMWEF/m0TYRhHFR1yidlicPcswBy7DX63KKXmjTCJBgWFSa6Ct+e/IA9L6In8WwwGW9+SltyC51YM9DYZbl3VZGps5VUoWjK6IzxQ7GjFdpA+FNlF10DBjf9oT+63xEW8adyLgCdJsvScOT6HVjSNTWxOQu3eNMxSAoF5Czxa1ucmonWpQhaIsFqqCavbny+HANk0ub37iAT75aTN6Of3MoRXlrFNAfxQqzq/IAc3D+lfmMX5hR+rWM7HJcdoBeTpB7vr5y9GGCP3D7G9WlfOhwEXHYWovHCGDqe4QCP9ztM+WAkafHAMWNck8m4sxOOHD6FAIF5tmFtjOgft5vEHtUM+RkeSKH74/gPo7yCAlhuFmUjMQx6dY7MUiWnBrEC+xsPcBPtsHpW6gkwymzGaTtTXZO1oasqtlPlQRBtPLS+jeV3fWVOcy9O4ro4BUr0+apX4BUsrg4HbhzCqTdTTh2Qv73oKIMIrOOrjq/VRI0WcRRRRSNNn6F7lANVDP+xcsHQvXyjF02u3N1dB+QE9dyjr4B9jDNg6s3U7x8RypeQ1WuCsiiedmGXsQFZmAfu3cVmmkkC4lx83hyJqjBCW8iC3bd/GLe7X0xeqE/mygpPAnCr6OZFwhXi51/aJoNeg4vAmbheE/MdD4fHR6hIwz1cgQArvqPhWryogB7/KBokNIdXbAl6N5BSyo8SVqw5wCKLn8KxQdzPkhG6oEFroqacniq6K16QP5PS1cXaI/uLNW4cnuqDyp7aZh40hQFVIvZ0TzNoxdmJRzM32fJy2oDAN9Bvg45v01nMeKfQfddI8t+J5lVzEs2CbUdPP7V0ftbV4M4wH1YgRo05mVg3nVlgeJP/8wrja0OtSkw8DbBP3bf1KLXwUDjPVXAWIt7kMtHGDUO67M/lGNoLzxCzUjV/aWi1T93MOQC58ES/dQ/uWPz1cAYh7XwKVU72mvnu3
 Pk/NGX2X
 lDGBmQiYxRdjbiy5cQCAy4nQkmsJn8+Moe03GjZQxjcFuuhtkev8oUOLon97wCXlFy6c9Cl2T5pnkFGGeT9HCfktdIBpBJQk2UaNb71GVOhFCEgePRR1oEanybjYPeuo+EAdruYEPjOtSQfkKAP3qsWQEopuzvUkDyI3OfMpa6ivvk7a2LtxbPhUS+69vXFB7+ko95t+GhzpgT0YSku3zKPFvo4QEpwHdlrOlBSR14Yvp9ngGxXoSJFVqHbMkAZPgEBX4Cxn1ps1PX+jM8kAGnMxlGgl9ZOA7F6immTnlUEo/kK7/bXhXxWCauzga95Qdu5qu4giJEhchqj3dBRD+Iopq7pYx8Bn4h2AewQ5LVKrynm9tanXMyluDlvcK+xQMdBHP9VMdTz3EPHlAGbbd05uaeNdkjZVkypkuqpjf5Y5YWxK48VuGz4DNMl4yjcBhzYEQ0cKooaKKvWrVlHvGhx2F6RjRB/rvaeJS+UMoENyQbIipcMRzHpuZ2R5kusJKpALY1AVVJXLbA5EiF7yrRYHcWX3BOlnY/KOyuJ/cT2OHxqHWnV/T2TPWJSVYT8CrnXKxg58rvvjoagHfJC4NgensATaKetNWPcrgfWlZ5ZrsGTkI8jzRrE9oh71hllCv9Zm+hAX/VjJG5drkiKz1vKoX73jpK4qCy+OKT5wATQVPD5v46dT/7wLVYbCXeNi7aItN0/o2SVXV4353/kR9YwOp5KWD+bEhv0XLfbRR40wJciLHS17WwQ6FX3P5vgWoTK7hzstk2j+ADc6CyKvPEhzxvFFkheVF9FMXWMssLYYDoXTX46sDKRnE7WXg77edKtPXubSd1KpAbrcZKLsTtBy1cz+SAe+mcgbHcbMkJFS1yb728+GZrq1rqBq7bQe8Zw925YA/WCeUifLQcpQz9Bx1Nv6amiVlKZUh8nsO0RzRsigs5k3eiql2of7xXOHj9QQxbRjww04FuAD2z6+EPVQJNHNG
 xkGrQWNv
 i+U/VwTp47Wi0FuhrUCT8ZDt8u7SwwUyZSkUNO063QT6Fk/9O8iiMdt/2CWF4iQ/AAhK2/CHUIHv3vVXbXg/RMTSI77NTO1VnWwhbNXfTh4lfhYpukiySZRAfcdtPilZePvxtyrNYkHF3nrS/o83eeT36ZRstPD5yJMEhJwe2V/McFKsWsQ4PmieOsnPu+eSipxZ5NL6J1rKG3I9YFtl+/SExMDYb64D0sjBcRfCSqWcW34OuCnnDN8gZRjLdij6pt63tUh+HgIpO01BRI6P86um3wzVoO72P2EbmCSjNi3geYSCfDLdBcqAEATkdCKPStYPGAqOi1l9iz+WC6MvwC4tZPV8bWEIBE8RGVvmr4aUljDypSW1qHuXpw7x5MXBlE8kV6HdgTZwkbynropNpenKQha0ZyCIBZh+B5nIiuafUzgyfsK8/ZG+VJOwn2xI3vwbwuo2flancaLGxnchcEJ/Vd58f2bhkJg4UsNYor4K09D0yBXk1m2hEFvZbMinSDIeWnGQNO38vDeIUlVSX2LghivVGTKPtvhghqJpwaNuzcCS5zcxBaUiLOn4JOp8SV83UqhLAuMc9KuK2TDMrvlmKURmpKy64KC3uPqHqCqAujMeP+axW+/rgYSPaEIciimMMu78he9D8keTlvUP0nFBTrVJZcn+B0VDRsZIysYyXl+SZs95SMjPMsjV1u2R+43WInqtuK9Z/neXZPF2tBlZvn/ii7V+FIGCs9CRatrr3REL5n0SAEd99wLSB6281fyDK512unbOemSAq4p/ODC4vM3dPdGPPIY+i3dYVzSIsXy26OxTD0hcHj5gum+uU4XsPFv+e749PMNedCsQrl1SjdiqIWOgHHrmWMJiesrWBprmsb3IetPlBrlJhKackBt4nhRTqmhsG5BWNpYeEgwaV+sV6n/UFIQYVW7qgVZW8/MAzKWGWMzw3wwLQh57MQGnXsvUK77SIc0g1NmvdcnfUdtxb
 Cpm9Eqjg
 eGmFjT6etj7F0J3g+8NOjmL8CaB69KUqFulOO4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: move all the clamp() definitions after the min/max() ones

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:13:38 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:17 +0000
Subject: minmax.h: move all the clamp() definitions after the min/max() ones
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-26-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |  109 ++++++++++++++++++++++---------------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -171,6 +155,22 @@
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
+/**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
  * @y: value2
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.10/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
queue-5.10/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.10/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.10/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.10/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.10/minmax-add-in_range-macro.patch
queue-5.10/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.10/minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
queue-5.10/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.10/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.10/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.10/minmax-simplify-min-max-clamp-implementation.patch
queue-5.10/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.10/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.10/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.10/minmax-sanity-check-constant-bounds-when-clamping.patch
queue-5.10/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.10/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.10/minmax-fix-up-min3-and-max3-too.patch
queue-5.10/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.10/minmax-fix-header-inclusions.patch
queue-5.10/minmax-introduce-min-max-_array.patch
queue-5.10/btrfs-remove-duplicated-in_range-macro.patch
queue-5.10/overflow-tracing-define-the-is_signed_type-macro-once.patch
queue-5.10/minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
queue-5.10/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
queue-5.10/minmax.h-update-some-comments.patch

