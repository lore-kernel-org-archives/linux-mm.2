Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF0CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171F38E0147; Fri, 19 Sep 2025 06:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1226A8E006B; Fri, 19 Sep 2025 06:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C5B8E0147; Fri, 19 Sep 2025 06:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD4EC8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:31:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E7E6160622
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:31:02 +0000 (UTC)
X-FDA: 83905631964.12.2B44854
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B0CA20008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:30:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kuQ4pejF;
	spf=pass (imf13.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=rJDL2rr4mYlYBviYSewxN/x3mRQr1adFqe4hgHahNs4e19tFSohSOgrMP85dtK3uVZgE9B
	Fi1RTBqdxNUKbHWCZLfenyYe/1nMFven53diWFw0Vci06Wy9t0+At8e+DQ71w325A6pMXS
	T6AKY6D68LOS6IiCYo4gSNJSN64gKVw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kuQ4pejF;
	spf=pass (imf13.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277860; a=rsa-sha256;
	cv=none;
	b=JBWaFNi7++1D+/DdWDkOpzcNhcKFcCBL+AIex+uttgC0OSFyo50VYuD8G197M8t3i5k+js
	BJaLFXKavMoJYAwizB0QxIB9ECrlLAvLFN5e2G/onvaKZyQlGraFmk6s8ZXdpv1jcLCS9f
	9iFYd+6FB54+LwlbNtBdKPEAAq3D91E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277860; x=1789813860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=kuQ4pejFDhpOwF1yQyxXV+YLrMgLs4pMzVdyPWwgyTNpDXG+XVHG8yGB
   v7QWbaLFKqQQD8X9fLAbOR49t+0EL4to0oO0cZ+RAQmz29gHQyCZVSePD
   WN0vDZpD5/SjQoGnuB/+2kmeUs+dfj3ibg405IC53gL/aP6YejbhdWgjx
   +mb0nr5h/G1dG5hQOLf6W69Na+hKRQjeNVBKaQdii9z6AQwp8EqQXAJA4
   jWcpfqfw7azTgvNSoLsJJyU1pF8SEOCPaWiQWBDWpmi+VVVbgT4SuBqNB
   FMrc7SBCmj+uYdbXCVw62P13Ei1cRKsMzhd3bm01XkhWiwAanIM4WhCtr
   A==;
X-CSE-ConnectionGUID: 84db8Rn2REO41Gd+36dyqw==
X-CSE-MsgGUID: 5haEWmmnR/a9oLzBFFYksg==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2256665"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:30:58 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:10146]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 11fa9bd4-f8b9-455d-948e-95865f7b3639; Fri, 19 Sep 2025 10:30:58 +0000 (UTC)
X-Farcaster-Flow-ID: 11fa9bd4-f8b9-455d-948e-95865f7b3639
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:30:47 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:30:18 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <bvanassche@acm.org>,
	<keescook@chromium.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<stable@vger.kernel.org>
CC: <jonnyc@amazon.com>, Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe
	<axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Mateusz
 Guzik" <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH 22/27 5.10.y] minmax.h: update some comments
Date: Fri, 19 Sep 2025 10:17:22 +0000
Message-ID: <20250919101727.16152-23-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B0CA20008
X-Stat-Signature: 8aaknytttz3i9nwud646kn1edoqag1tt
X-HE-Tag: 1758277859-749929
X-HE-Meta: U2FsdGVkX1+Ze0ApPuBWw9lx/w33c9iHhfX3ZXBxw3kkn+5ZLNL/O4NNuHBuzqHMEvGd8RjUWkU+3Rrx4jfLz5VvsRU+GdOopM6dUbHDBQdsZT4vZNejtu4LDSy4rZBppO9EjiT8qTx4cG74POvzoXaoAVJ4HDg0OBWn/bdVDCMkAcsXG7a7eI9cNJfe4WHxW7oqHQtf3jIH544KdxS1ludHqfQ68l1Fax9N+/eFAAgxWqFFdNCYNd8FQkgTfzcbTQOIDJ1aEIjKnpJhnvLb/5qpe/USKA9VLfLomqYOGSppCigrOQOmo7mJe5+kras1/XbMeCSqjHvcIZLQkXpQOy9xMpbKN4Y+sBOAO2k5vtXlIHzCNhCbUASsvV/T3z05b11lq3lJ4y1G5m+Ey1AY4V/eAt2sNoVGYJkB6ct8TmmbdbzBe2HI6ati3hx1r58/fnqonJTlvHBEYxLYHmOEPr5DKGrukATLrVUhj8zJAwA+QOPJzht7sxKXjtj+JbD1YVp8h11sz83gpmP24NlnWoskAjnicRZ5p6RoWgK2QurWOslLpkZJ0YjnVm02BLqLdqCbsDnwxLX03dCBSxHJNUxsbPA0ny7hjNduWuhBqIvFvh+LlQ8plbZlTtJRYfziiRjjphzWTx/UrCEY9s261MgrFzkfm1ybx/bzNeanfOAF4V5+YwTOpODIHVnUjTu89M0i8uJg+7lWQFCDIGtV0BBVarXo+n2YoOMNexEmE09zm8qpBqV3jmK5Pi3RNRXGSbHLZWO4/tVWchDz/Hw3UAX4ZserqmIzFwqAfd2yxCkEeCefFoFLDfG98qUXCilNsAB7eZURrycveAT0Fqo5+5eL+rdXlIp3wsrDocXyjpMNyQEdghOdzF5KjUnqNvDHdvmQd9nVPDX9Wishn+/FGzLxs4CPmuqr0p6y9UehBpTJhJLJ6kiZhleIzDWbdFufUb9hsKpcSdQe2Wsng2S
 uxVbdyHx
 XEz6A5yYo+in4cFL8ow4Q3zXsgi4zWAf5wPBgZxahbgvl4mmH68PaYOLz/4rZ+fTSOC6zgkBsKhrIQ9zYVjjw0As09Q9HVcifP7W6OVrnoH2l39ruykWXtorP3xrDBCd44HroFU6GNE8TKt4rYl7X0fPQlqU3X+4nwAVVqWOk1R16q+eo1U/hsBQlDy8iG9XZ/QPURhFtv2r9Pbuv9QmER7yOAHjNPe42rZ7xiVITRWmog6FVo6QLjEgK6fvr8rNGQOe75HZH4+d6VNfVSwYYZquUxgNVxfg2XMU5nalhxG/OgEo3uvt+Y6D5q9GiYrAy2isHpUQMsG4wl77C3UAG6wWnQfHBkX7ddslkv7sAj2uZJvLL6Vp5GDLYnIf0myReByk6v0R+ac78HlKfQySS4BIjnWa/L57+glsfOACUPL97zwqByLT11zp1lTg29xXlXouVhvq5+lY22zjEh5oPzggknwio/fQvI3QIj7L1KGe7sWhRjvlB9jDSGGD8ymWP68AGGz1cCokkYIyIsU6dYoKkU1fg9D89X3SInP0jQfWSGrNq4R7F46QhGaVOb9FYyx29ookcVFhmaKrfDQliKK8adzkqvABkeWlprYbeuAqqjzagGDEyDHJtwFPpd1u5PYkBGX5+PMvoXViWgHStdP+65rE+4LFq1waHcAubIQpMfVNaqj4bwOj/MVtKtLGu5KO/e+15hP1dm+JL2EeYTf9VT1pyXh54KnJz522Lenso3hWbqpcLhBB8zsGx6RWPEE1N+yA4aZxN6TwLFD8lnqsAOIqwAhYnAKW9FVZ1SBGtp6n2nC7nyTaAYQDuQs6TQ+si5BBix7vK7zSoA6Hmx7DjIiaTbt8efBHNjetiw1Aljh3CLEL8YUWjHRnVCdVgLm4wyZ6QwaPRRF+OelYq9MlDgfQsZqp5OuonGz4GokNWmAE5zvCV3AEtP/F2QMjbOtWDio5CFAF8Qnrnj7PJcseTmdx/
 6GKKDtHz
 U4bdi1wxhQtMgQJYzhuH3SRqbpS0qHQ/Z0gz+EzgyQVMKGfdfiWsAZJ1P3EHPcC6rOe0hmj8tJ/S68JU1jLHsSZXCVBoCozq3bKItX7uqAkfgmex7u2YWV6ppnxo12on60Fyz2JrgWBtWUwiVCnG+FBeb/VSHAZaTpVFCsb9D+r1CwQLqoBL4PwCXm1h8CeHZwUJgtPp3gBb0cFBUX+Gnk8VoAFKd5aS/nFhUHXqmlefyAf/Q2Nu3KskVTat1ZKtYGpSB1/6/Msb0O+8Y2XsddGY4TwNRrHDlcMQYs1XNe9sXVCV3koNuEjnuS8l1fcypj+4laVV9RRWfF5Y3UMrPzggs8UUXva0btXcNziECNer3Eld64a6PAUB5hgl3l/GabfuYHvjCxB4dhwr14dpuxA6Dm9wXZ3/O865fNJrAj9BrodHtTIGQJ4dRZPIO97iilKEjDXqASOUiDpzf6psMCC/TPr8Yb5GlzxCNKT83BvPXgFaThqMfg0b38ACYAPBaqJb/tGzkBIDcBLAESa9HBvgRAfSai16+EUxd8avYPWMCD70wvyOqAHtvWob7pNWzg6/KFJjAR6HNjRuDTi7icalsPsZLDNVv0g+MKRHfGWRgwLldPM/zeeS4l6RrqgCUb0KZpVUgIkyqSs6UqDEb2uAlqTGM6SrV4O6XpSEyvOo3mfxBx4Z0FR8TdiXSAjwpL/3DtKI3cJCLbnFeWZq1JmGB2b3P0SALHsLJzUVG7v0ArXIoGf4XaudgX/ZzKAfHwbukREj+mMn7fapAY6EqK6uPgvFwswNvP9lKn+ZDnhEIQj52AhLnSY16e3NZvp8h4/OG9A6OcHru+WVtZye+mNC964MVFcpVeyRQJx7WsCLwG7KNzG/ZWmpL6bqQkH59aYXiowAtFb19DXyXkKfk4zjewDFMvfm1fIBk9+aNlc+yUeavi2hf2VPG//xzzgjrPRY0lKExaTmxsTUac5EiywXn9zKc
 /5aiUVio
 W+EUp9OfAwgiNS7jV4tnPA8HFSZ4Fi5cwz1rsYrYHz+YTLE+XBFCFi7mZAjXy7o1EGurEunGV7kCkx0IF4oc2l1zIYjzF7yl98C6bXNUSL04PeIUMvIjA9qMWMb2EUJ/3ODkGEa/dxuikm5B9RsiFKjXS4Z+NQxUyTJhWxLsRJQ9OchMYAxnTsScwX0sEgB+7UwDqyJuxmRr8l5+wryVeNsxFh8TD8SxDvcFOIsa5ePhnoF1BUodug1M+1WzbrnmuUijmqyFdoUpePGgysLc1uxJU8gnE+GUcB4OZsMEkQv+ArSjT4Uma8YW3DfebgKupXWELTQv8TbN7Gn5fwt0XBNmRD/QzCrlgrdwXtR+0I78ktOjkSvjCMa5oBGGjYmPvC4T3DD4vLw/FTuZgoVwFQwsYXVCtzY+JYusdfEdefksRL3EzuTDbFSI0B51w2j2KDkNctQskG2usu+Hvcr4AizvONMIJHg/KPOd54UJeCWZz7H3rBT4EUSO7QGHXccDcEyognL4JbdQMULFI0ztol0CDVpPv+JMpUt2qm8+VBP+Z2EZQRwSmrFlSxHs7hS+glI81ihfw5dWTgP8xBTT1YIoREQ+4ujm34J/WkuOAdttKBMa/Kp/ZJX4YtWfroquHEg2FMZl6d+cXhTj0dav8jPAl2BSK5P/F9gxeUC8HBQSvY4cDP2klLoFOj4yTW9M69oJH/9ZSl4HbiYQ8Figt8wb8l4sARSzx4C42ygcwIdMDkh2tQIsg05OdBt3VbQc5zFmEzHzcYigzMAFBROYnilCDcokQnrbwDGz6k8vA1SNSMyJnmqHtjfhMT4GM8sanDVrPzCCXlIlrGKEWhdDzD3fMWroBBt/tlhraRZ54E3BqJnE9LeyOINDsf4hGWxbGjNBYOeF/qxaZ/2TVCS7HhIV+RLaOvuCLlFLW7uUnBzs0Rvc2xnD/5qF4/31KuCJsCIQSQU343zj4VWWLye5fKFHzIIjI
 38pgDtTU
 kCxzZj2yPHDS2FhDDFoHmDI+T9weGS7qSN1LSd0HyqSv/FN27XoJYXDC/gIrLUutgt3FrBMS/QRtCmmb2vNgAPfu83M98VKlENzukgKbcIlvpZn4F3wWtP046vx4Xkd1sH+1I9KU+nKl4lOxg3Tki0TH+D2YPHpM2gZdq05fw63Giv9oaH4N0cByiKXxYj7jEtxyAj+4wkW5Dad8vMcnyjStrg9jZ8dmr7hcNAHB+6n1OPCuFCo5Hb7ZRIcQSNbxLPFCsdtp5korMoPpauiivYP7ahd0N9GhYPE9XHI7qgrqx44PqkNOF45WLjRwCvc4n5g/hrxe7oh9fbFd1KIeAmKhKTfEMCLWSbpI8SxD6fI2uDmAtHnNlNA2Golm1seiemyDDEe4XJKdJRV4JhY/5/BUiMXF59if4pc5Y8qQ85Uz8qCthMFZwPXGFNmnl2Tt9Rr0nYodKgE4TMFWRTvksYmNahO13fkAuE3oBUjyYijtvhYwVd4ENCS4CyIN92AL6V405kiRLQk7Y55tcgr1OwqsxMGcx46XpMxw5thrULXWzwl2y5XlHwyG/8x7JrNa9UBvPZhhfK1baYzHEl7Um4b+metuWtLeBcKvjxz8E6DLUdzUOHHAVf+tHrkNA9iOQeS1i8XsJ0oX83i+uKvBWxBg4l3dg/FojC9iOTN/gwX/ec/EGhL/N0dxs/uVeIYrhEqNDnuSdz+VRkq4zNxOvhxoWD79DITwTUMFapxEtX2ExFRMSDvvAL7gM03f21ihG8HVuKUYP84XCW5uNhrcI3KPMbLgFspPfLazxKO8igz2IMloLjZ1AR3kENjKh+HCd3Rl0un32rSXyCYs3d4t1apDQLYJkv+q8OXNMpmSUv2sEXVTMieZZQe7905mpf/HMsL0kEjs30mb5dfa30F9iwWcXAtAavYBrwcOLb8qmH/jLdKoVmxEKM7EEyaDXXfI4kGUUBAjAyev9FWKAtb5NZcO5Qo3a
 vPZdZx/4
 ddaoS6gz5XjQSiG3rcExkAfw5UHKWrfBVIh6w/fuZd7RC2E85GYvVl+T807CKpnrTVHroJNFk8Ws+pkrJilE54G44vP6cPiLlcHvKavtkBDRovPAjRNp2WEBu+enXp0Bpca7ni52h1eNMxipcU8UU0jyONy2by/0+LKeHpN/qHqscyhdyE/LGEGE38rFG1mKeTFLivm7pgItcF6wJaqrdLyBAqWnYlij3wpqDBYyI9sfl4Llw9pUb/NYQIzTuA8LJz1KKS4pO4PiEfQu74Iz4OQRGOvL71VtUn2qH8kx9a4D+aTqV8Tzb4O4fcgF/iV/NhsaInzXIcBfHb/9s4CSAG/Ypc80OwtZQxACNbpiTnUaJF0H/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10666e99204818ef45c702469488353b5bb09ec7 ]

- Change three to several.
- Remove the comment about retaining constant expressions, no longer true.
- Realign to nearer 80 columns and break on major punctiation.
- Add a leading comment to the block before __signed_type() and __is_nonneg()
  Otherwise the block explaining the cast is a bit 'floating'.
  Reword the rest of that comment to improve readability.

Link: https://lkml.kernel.org/r/85b050c81c1d4076aeb91a6cded45fee@AcuMS.aculab.com
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
---
 include/linux/minmax.h | 53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 51b0d988e322..24e4b372649a 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 
 /*
- * min()/max()/clamp() macros must accomplish three things:
+ * min()/max()/clamp() macros must accomplish several things:
  *
  * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - Retain result as a constant expressions when called with only
- *   constant expressions (to avoid tripping VLA warnings in stack
- *   allocation usage).
  * - Perform signed v unsigned type-checking (to generate compile
  *   errors instead of nasty runtime surprises).
  * - Unsigned char/short are always promoted to signed int and can be
@@ -31,25 +28,23 @@
  *   bit #0 set if ok for unsigned comparisons
  *   bit #1 set if ok for signed comparisons
  *
- * In particular, statically non-negative signed integer
- * expressions are ok for both.
+ * In particular, statically non-negative signed integer expressions
+ * are ok for both.
  *
- * NOTE! Unsigned types smaller than 'int' are implicitly
- * converted to 'int' in expressions, and are accepted for
- * signed conversions for now. This is debatable.
+ * NOTE! Unsigned types smaller than 'int' are implicitly converted to 'int'
+ * in expressions, and are accepted for signed conversions for now.
+ * This is debatable.
  *
- * Note that 'x' is the original expression, and 'ux' is
- * the unique variable that contains the value.
+ * Note that 'x' is the original expression, and 'ux' is the unique variable
+ * that contains the value.
  *
- * We use 'ux' for pure type checking, and 'x' for when
- * we need to look at the value (but without evaluating
- * it for side effects! Careful to only ever evaluate it
- * with sizeof() or __builtin_constant_p() etc).
+ * We use 'ux' for pure type checking, and 'x' for when we need to look at the
+ * value (but without evaluating it for side effects!
+ * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
  *
- * Pointers end up being checked by the normal C type
- * rules at the actual comparison, and these expressions
- * only need to be careful to not cause warnings for
- * pointer use.
+ * Pointers end up being checked by the normal C type rules at the actual
+ * comparison, and these expressions only need to be careful to not cause
+ * warnings for pointer use.
  */
 #define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
 #define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
@@ -57,19 +52,19 @@
 	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
- * To avoid warnings about casting pointers to integers
- * of different sizes, we need that special sign type.
+ * Check whether a signed value is always non-negative.
  *
- * On 64-bit we can just always use 'long', since any
- * integer or pointer type can just be cast to that.
+ * A cast is needed to avoid any warnings from values that aren't signed
+ * integer types (in which case the result doesn't matter).
  *
- * This does not work for 128-bit signed integers since
- * the cast would truncate them, but we do not use s128
- * types in the kernel (we do use 'u128', but they will
- * be handled by the !is_signed_type() case).
+ * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * But on 32-bit we need to avoid warnings about casting pointers to integers
+ * of different sizes without truncating 64-bit values so 'long' or 'long long'
+ * must be used depending on the size of the value.
  *
- * NOTE! The cast is there only to avoid any warnings
- * from when values that aren't signed integer types.
+ * This does not work for 128-bit signed integers since the cast would truncate
+ * them, but we do not use s128 types in the kernel (we do use 'u128',
+ * but they are handled by the !is_signed_type() case).
  */
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
-- 
2.47.3


