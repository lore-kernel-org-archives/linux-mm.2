Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE30CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401748E0062; Fri, 17 Oct 2025 05:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1CC8E0016; Fri, 17 Oct 2025 05:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A6E8E0062; Fri, 17 Oct 2025 05:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10D648E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:09:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9D0213B5F4
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:02 +0000 (UTC)
X-FDA: 84007031724.11.1447F82
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id B6B1320007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QFkhcavV;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M14+Hrw3+0xfvL7LtAKdftp5KA5xdtXGebEkX3FEMMU=;
	b=U/NZ1+r3ERS0NzTeOTXEk5SKiqKIAn7ViEdjq4Vho1pNsmd5eUaKCp0Oovgt1rb4kmDgM6
	ma7jCLOZWrzrXeqcM6dez5Ag8P0MVO3+//PtzdlYifdh5g+T3/8ecDh545G7W0oQJLta0t
	LWPBqLM9DVQjNvNO5f1V9oc/OQO67NE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692140; a=rsa-sha256;
	cv=none;
	b=5zt6Mx6QYI+E11863OIGi5D+Kaj796bfnNBOn2O//EteWFZKoz5xdIl/KV+ASeZ50OhwR+
	mAvN91O+Mh8E5rPY1Ukndx7tHIzcewByQux7nPwGqM7vSj2ZwuTPSkVaEjh8Hxp6Jj/bZL
	70PhlUiOPmeokS+o7Fnp+61xtZYY7JQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QFkhcavV;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692140; x=1792228140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M14+Hrw3+0xfvL7LtAKdftp5KA5xdtXGebEkX3FEMMU=;
  b=QFkhcavVhWr5RxpI3q3MW4PV4N44tOmIKJE4iFfPTF3d3XLBDwMIx9qe
   aDGcu4iFvvx0Dmr5Z2JFR0GSVEINrsNSQG1ihxmxTRGEitkKsZHl1fIsk
   dp19zt6YkRoKxNeHSrxxLQttno9eY3dXcp+vIO3q7u4HOHm9+u8ygo3EY
   7IYUAyq3rT1Sj6oc1bNou/LRW31c7NKnMrFU2ZXQiTPiM0O7KifwzNRw5
   hOS6sy3Ie5hsyYLFv+2JKdXNSmHsLVAj3Rb1ZIdooE5kIF6reMNac6o7J
   MN3HdO85C+SS1uQCxf2prDiaG/XwoJM5GEt8kiOr4NL9QuQrkvWBrIRFi
   g==;
X-CSE-ConnectionGUID: TBZJv6geT3iQADNt+rwklw==
X-CSE-MsgGUID: yHuVWYCBSRGy3/ljdqeQsg==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5070261"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:08:55 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:30812]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.150:2525] with esmtp (Farcaster)
 id 3a32b82d-fd92-4e0c-94d9-173d12ce557b; Fri, 17 Oct 2025 09:08:55 +0000 (UTC)
X-Farcaster-Flow-ID: 3a32b82d-fd92-4e0c-94d9-173d12ce557b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:08:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:08:39 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
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
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
CC: Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH v2 11/27 5.10.y] minmax: allow comparisons of 'int' against 'unsigned char/short'
Date: Fri, 17 Oct 2025 09:05:03 +0000
Message-ID: <20251017090519.46992-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Stat-Signature: nuauf5kd1sbf39jtou5oipozrrq4zfmq
X-Rspam-User: 
X-Rspamd-Queue-Id: B6B1320007
X-HE-Tag: 1760692140-451025
X-HE-Meta: U2FsdGVkX19qTXdgWE6VeAHODkzbtRgXn8UfiIEGgjGMOf51pbwoNy0mPyf91+L3spnjc1Z22GCoF9/vtre/dJ1xCE8xwKzA229l44vnsuM6czw+jOZVUudCGLH9/6t4VGzPR3LXKYhd5bXOP5gPTyIuhfo4r6Y+mX97M9LCYaNE4Q1ZnyajOpkvC23mtv2+GVOyi9Wd1q9OYpGHCoRBeRpi4xjuLMZu04fwTVY59HUVrlZ6PBKBsvFjpq3KU4KXHFlGCfjN1Vj8G4OU6WZfd+Li60Xv+qtzMpBOKwDPZfnP4KQay6jqS8bxVG6o5+l2CcSKDT08e4Au1pylNeooKInrdxGGu72bB8cqzQwDlnblDbC+PmSLH/0iGcwKha+8qlTnFxxlWHae71OIX7PGYuTVAiRJ5apuJN5Y0fpthPINriR1rB0glH610gbnQplFtevqo5CLb0grh8wBiTd+CILdkit9lJyDAjHrm286JL7xYgnBt5FbOajt7HbEVJDExBdsu4ekzAkK+noZC8Hpo9U4C1Uy150pC4O/JJ1w1v17hpeew02KsCP/Ohm0mIn6Hzv9Zm6IP/LyI9cmHfYFGFg8LVZF4G3OD9mRNTVurpgo/h2rODn+f7IGHkuaby5o35FnV3FvnkCnr9Bb9MzCUdIHQcYIEKv1JNboAMjPFf5jG0IkgulAbE5jCpFj0W0KX5Xirh4k5z/u2B/X30meRHi4BMW3wuNbPFy6k50V/YnePWn6Z91VvHRp/iOKBkuCz6cHrY0v6VoH3xAQd+T3B/Biug+CC2A5YT8gkQYVfodwAvpiKUrHmecewi4gyyuRk8UaUFSzb30aUOI0AimREBQq2jqjSNHwl/5PPXGZKx8sZNDcCFNxy2BryP4eOSWyMpsqQs0NVvlYzkmO7fR80LgOjZj/vovbH3o2p+Ns36i+mD44rlxNwKGoLsMO4c6xk4oTJtJ4PChWHNOLYcd
 3geYgK2K
 u1aSAD+7C0d5ZJce3fyNCDLai7e7DK3MRWR4Z7x5LF2hp7zHOEZszApHIXhShqc4R24qLOMzREcTuoA4b7QWdgeTVMrMDX/jKyKp0bGExHIODZiwxIB609oC/Iv3bqhnnj29gze/sCMU0x0KQWJhpErQK61NPX9w8Be29K9V86VlPN6q/LtWMK1SDx8/enMFygS/ZfA/G3/eivFEKUgUGzRAgA3lTvBlPZsevq7Xmg0Nlf/8yDXmsez/LkkEIb01/8AtBObtVSGVn7ZasF6pPMJUtHvKmKAMdY1gSQlCU3HJ8Qk9TFpFl+Oj1CzXfarzDd5J+FDFH8pcXDvdUGzInk6055FG+eAikPzJ+xahTS8CKLImdgavEezaJMXZ0Jv5VIh7FY3+0YYMDW2W784CKEdDlFB/eCvs5HxvPPSTSWdyOkYsCW+6IdOfc7Eu1dbPI4ODazn3GYahmhT0GINFxmM47B5jcvaOoVsAF1OUMC8xMK/xV2HgLOTz1mp8SSaHhyB/dNIdsIfeviBaWrOZXmEzWotoZ2IQTtjaNgelD/PB0o9q/aNuIyVqOoIwvQVUSERntrYF+ilVdnq/Eh3bc6UsafU4YrCswpcWuft7xYX1ynIcO77QiM9s0lV5/SYJz3/S1NlsJY9t6RTV1VVrmo2Nt/Ezhqy+wu4Yup15tRvUmS1bnjFtiTnZ/WTpzmdQIsCFBcpwywDyrmztVTW4xU/oKYa+wgIsDJ7oKuT2Eokvq+v7h4RJdZfvuD+Pjmfy506Q525LmtJEVLDlKcIMefVvfsCNEuVBl+yTG2kWxfxw2stkZTCZO6md5eS+KAZdUGj1pUDVdAKPxr8vM1QB2xtFa458JF+CUQqBwmRHKmqDtqyrHBEtgzq1ZDD/zEnoo4iXEonV458QCiPkqfbDMsvcWdGIjDvKmrZNZPdINgrdBoZQjLuRLu3i+3N2tgKVoteSjRvE6LvC5gmY8RyALD2ZF5Zs2
 EUyO2nCx
 gjEPPaUhkouyKEch/I54z8qCMtql37OTWhnjE7PWNRSwdSESWKRyB9PSyyPFwPcmkzMEuAeXs8tgXxsUNJF9MrIwixTcQtw8T2fJwZAy3iZzsRAVZo8k50NK88G+vM0hWpO99MgzIGacq8fgQr0TAXmMa/s5u0KmOs2GS5q5MU31dnzl0Q75NXGUpEe6pOBxVZXKDtAqL2nfehukCaFBcr3XzmzNnjMzu/2DD4hkfqv6ZYa/kxAx3TCbUggNG6XEklzXTXGHNWJYjITStdeDU8+dWVnleJ5LgI+LEbzExcueG11/iwz/jlOEqkLvnFyb26nFgucopY9b3WTuO5y2CPPcz6dG3ibh+Mw1jl3Pm4IU50oPHiQCOFaaZEZ3Jh1DANUKppZmxtOwOfUfD/nV7/GrLSRF811XahINIdpND3Q5TQt3Wv3P5jgrBl16/LZICsSFxsd7nlNz+Jj4sfUWcdDEWVgUUJZuxhyB5rl5B4l2vnSLSfZvpnihnUTpM+qWuW7Wp7POH0BQS5t6wK/2fjW6JPrLaSfGhfP2EeqO5d9Y5yjTOWNoEQz/7dx67sFzR/OAUMrhX+188b1+iUzBYddp7TQU6WDnDYyRXKySotEyxrDdAGBbnWsEN9ld7NiCyOD8PsWMW0OGStY5htWBF3lxM7vppH2gBToQmKUVIUQjk24n8yu0f4hl91YrshjSsPyst3hRKrwcQZRqrUcZsNtExBe5sNB+/WyYzSbV7Q/8CmYDsRZeVbMkIsNS6rhZtv7JrdWd3s5zFUaxV4G8bKmCH+YkLhC//MT3AScszAcpZ974xeg5XDbPq6R6gj/fsy3BZf0thaGGhzzwTqNgMuRXdCfWKsO2uwvJm/JoLauSCf6vTYrOjWIgzsSxQXAWb5Y0ATeXqd4XaNjM2x6Yv1VEeqXNJRFgzApI+2Fd8LQpNVnmq827jWfs8jQpR2bSMKaMFuke4zj8aR5zyB4SZuvtsNM37
 ZrsyOF78
 S8Sf41FI2nFKrSAJAlpg9KKSCZZYkYgLxIaoS2BAIMA3y4hAXyRQZLqIvRWrl+46w/q4LGCVtRMBhLaSOVaBy5RlehcPrw0Wv++Z1CIudL/Ab6IqbqyI3uMvUk37TNYWMY3jDfoqLwsFHX0xHcnSqcIPPqtwmJiEPNpPBcEeySllBPdjz89uLfklMKVnymALgcabjfk5QdrdXDvHdig20EKW/iem+m7lsAPyKq+0Mt79dVlQ9W4P1dwwn6dXn2h7tYCt/nctQ6r4/jw20u+U9SleybQA85Wp+fpNaXX9LgiBIvD8vvUT5ab8POqFUN+xrJuam8XIivysqf/rbvbnaWif6f1AAvnMcU6KnGcAykv2GMr2DBVAkaP+IdLkK+c3MyM8BnL7raUNGErSad9BKdq43IfImQ/WLMukdoEWfgoCzMdJlCATcFPlAR/lGZ2a6vAisnSKk99hO8wRZDYy6giLcFSfkyaCAeyeqIVxkyDtRohetwUQiNpasrtIwGR1To0INTonGRa4ustLhXtU6RsVd7x3FBDeUllcmlct/M61RlHh3R8LINCIMoM1dAV1bzy/rEIqV+x9OE3x21NPIISJaXcS2KCyUkkP5Xc+6P/LHA1wuGfojc4cV7WbE3sXzasQpWoEiORFhmP72KZ8OLF8mOG1q8dnz/4SbTXiZHcnX0Gi1HDgWcahp1UoFgOdkR+m4NMPyGb8Nzlk04Qi8eVfdqmN0FVj44AqE460q5ZqimvDijgAdLcvuSI0BpFZ9H6rj0DYYwxK8Bv//DDXg4IhG6vgmmpTbxivvUVrdnht9NItdyt52hygt10CFXhxi2aWjatYZF7CEfujyRpYqU5b1GCAXhMFkNjtFTTMLIAZAXGHvuU7FZhkff7c4i19clFGOmAPDX5SFUsVLwhJ4E4dVfWToC0qLu77xKhP7+63Ba2kIK7AN07f0cpDP6iz/MkMVoRWBVzgGTmp9OXMMyWLonD3+
 oB69bFqd
 IrBhG7gmLlwkHOSQ6y7b7y/wzaJYeWwacWt6q9uO4HxJFay1ux+L+wCw6fgIxPa1f8cIIKIMO+k0v6qZRxrhwzA7YtcQ3O7ChfkihRVM9XW9/BL1oWqrNPQSYBASInxsgE8NQ8yCO+RYmX2gCo4PzaWJ828Enm3QlxpwySjEXVXgO+OU7B457zOi0oQkIleHd6DwX6rg77Z9oPBIAIxwM8ALpuO0nd0FDnA1pTf8Wedo3pnx3Wf/Zyn5a+B00J84biK6DYPrY8EVGM6GpUOi6vln+F3OJCT9WNw2yYNd8p7SfKsKVWLl6xnYD+hKRGmhxE+Ds0oWQ9Bv79530HRzVS3ebiTBxp8Si4ffmWYNaFt44DIvrarFU72ic+Z7f0UOyE8iZFH0cqQUfVSzTx0DIeGLucwpW0l9rQZRCIGvxxregQ+SQ6EW+9Aw5HkryV1ncUj88+/Z02jp8DOBVuqyFilN1tspAmm9oH3Y4p9j0CE/nWWlavfJiBXaen1Kp+4Bro9BCQ8rqCrBBz+H2dIJDBlDcp19BFJJM7Hu+yYSqKHiRaAZu7ccocgD6Pkds9M9A8U6sWyzRc8U8SAe1DF7W3gLEU7I1Byi24RknaNwcQZhUfJ6IDkZ5GsIDdprH1DkGWMOu21YRVZv/otJwV7cMzD3Ox7GrCI5X9S9bqVpUbrGvvNDYyQSmEbOznYPzw91KqFsrInvRVOpENrWvhTNBM6OBppFNxpQjQJi0gJgHUz0SrJRnPQVImqQ1/r/NV3eNyRt82kp4pksuPQ5xKVtxKdvRK/XLvlG7TBUVysVKjsI5CImmtKL+MRLK/KfNRQPhZ5V8UB8DLvQ74PtWi6Chq1mWuba5nhT7cJr8K65pVwHMpAo+TBdxmUX0P31WNpxGzs34gG+13JlXdzE5lCE0LnWDS2kcSyqF24N2A2evsk8I2LwkRd6XG4tgCq48sRz7zRwKNtrWXmm5BfLaPLWjY5qf6VuX
 eJMFrQ28
 0umGIXzy0350vku3CuC697qRuPZlFRc3HCD5lpNC52yd7Dac+lED/j5grsRAFdRR/16634MsPtGPTgt0sWBeCciZFabQJI7g0+x+gdJA4jIs1K24Z2LUNn4d0bBfcXg/xFH/Ghz0ubwFC5vyQYre7oQes/bA5AoEIl/hbgcC4bAAEgyPZ+xNCrtjGLTVtXRjLRZBQM5ZACMpUak4H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 4ead534fba42fc4fd41163297528d2aa731cd121 ]

Since 'unsigned char/short' get promoted to 'signed int' it is safe to
compare them against an 'int' value.

Link: https://lkml.kernel.org/r/8732ef5f809c47c28a7be47c938b28d4@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index c0e738eacefa..842c1db62ffe 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,8 +26,9 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) \
-	(__is_signed(x) == __is_signed(y))
+#define __types_ok(x, y) 			\
+	(__is_signed(x) == __is_signed(y) ||	\
+		__is_signed((x) + 0) == __is_signed((y) + 0))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
-- 
2.47.3


