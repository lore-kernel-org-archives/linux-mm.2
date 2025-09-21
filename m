Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51E1CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 21:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E753F8E0002; Sun, 21 Sep 2025 17:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25CF8E0001; Sun, 21 Sep 2025 17:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED118E0002; Sun, 21 Sep 2025 17:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6E868E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 17:37:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69CB8C03DE
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 21:37:18 +0000 (UTC)
X-FDA: 83914568556.13.F9E6156
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1CBC7C0002
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 21:37:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DloIHZ8+;
	spf=pass (imf10.hostedemail.com: domain of "prvs=352318b7f=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=352318b7f=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758490636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/nAd4kDSjaQjN1Dv16qY5ce7rfWNGwV0jiO1W97n90=;
	b=RFtDFRMk6cSPPRebgdfSbvfSpaPyazxNXSnt1xetrbS6j5ATO2dWONmnT4QvfWr6ExaADp
	THvVSrnGRHHHqvaAWsAJrdhK8EO/pNtyZj6FTbntXHgc+eGAji0d9FA6LEXE7prPuUdoN3
	3wJs8yWLQibNQn2H4E0Pb3+u/JqRmO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758490636; a=rsa-sha256;
	cv=none;
	b=jPWUYw3//1P9I5YdQNwO26+C12B1/fYtAMbtDPnfEz2t6UUFN4Wz/r9bNUQOxr7Kr4L9kb
	Afr6HC93vZlrZLjoC6sd5LI+GpfuLMM6e3tLh+7mk6U4Yq4lUnAM0ZkuFRHs/GRPUC/3va
	Pvlrd+bbRuXgW7AuuX4ms+EzyNqonuw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DloIHZ8+;
	spf=pass (imf10.hostedemail.com: domain of "prvs=352318b7f=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=352318b7f=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758490636; x=1790026636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w/nAd4kDSjaQjN1Dv16qY5ce7rfWNGwV0jiO1W97n90=;
  b=DloIHZ8+V6p8a6qTlJp349Vd/bxZs0ajxBJ01p1C0PPouse4pEpQK0LW
   AmnaaAfWQwwjZcrK9VsfO534Ipf77GLYCgI/dchs6g1Jyr8/YgYM4/fUA
   YhA8TupSW0JM0b5RdyNG9HQ9li5phLQUIoz7t+TEjdt6f5x+5PrImVTNP
   bGGptgDXWjn3wSUw8hLtEvpXXquAjIW31s16POTbTXyXsN5hsyaNXOSNO
   HdrYQlEQIjK59KxSi6ijYSft2shfkjOySxbX/SRteH0EkP1JWtkeDOvU5
   uvMzaxRWg63niaMFk0aKfU5G64KeAVVA2y91yqWnLG8M9ddiYi+PtWzzO
   Q==;
X-CSE-ConnectionGUID: IkzWuETbT12a0z9pqWbBLQ==
X-CSE-MsgGUID: PRMHOoNlThOyMzCGXOQDbw==
X-IronPort-AV: E=Sophos;i="6.18,283,1751241600"; 
   d="scan'208";a="2450586"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 21:37:06 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:22107]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.26:2525] with esmtp (Farcaster)
 id e11f0e39-22b8-46a0-839c-05efcff8dbe9; Sun, 21 Sep 2025 21:37:06 +0000 (UTC)
X-Farcaster-Flow-ID: e11f0e39-22b8-46a0-839c-05efcff8dbe9
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Sun, 21 Sep 2025 21:37:03 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Sun, 21 Sep 2025 21:37:02 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.2562.020; Sun, 21 Sep 2025 21:37:02 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "jdike@addtoit.com"
	<jdike@addtoit.com>, "richard@nod.at" <richard@nod.at>,
	"anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "qiuxu.zhuo@intel.com"
	<qiuxu.zhuo@intel.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "rric@kernel.org"
	<rric@kernel.org>, "harry.wentland@amd.com" <harry.wentland@amd.com>,
	"sunpeng.li@amd.com" <sunpeng.li@amd.com>, "alexander.deucher@amd.com"
	<alexander.deucher@amd.com>, "christian.koenig@amd.com"
	<christian.koenig@amd.com>, "airlied@linux.ie" <airlied@linux.ie>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>, "evan.quan@amd.com" <evan.quan@amd.com>,
	"james.qian.wang@arm.com" <james.qian.wang@arm.com>, "liviu.dudau@arm.com"
	<liviu.dudau@arm.com>, "mihail.atanassov@arm.com" <mihail.atanassov@arm.com>,
	"brian.starkey@arm.com" <brian.starkey@arm.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "robdclark@gmail.com" <robdclark@gmail.com>,
	"sean@poorly.run" <sean@poorly.run>, "jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, "fery@cypress.com"
	<fery@cypress.com>, "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "rajur@chelsio.com"
	<rajur@chelsio.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "peppe.cavallaro@st.com"
	<peppe.cavallaro@st.com>, "alexandre.torgue@st.com"
	<alexandre.torgue@st.com>, "joabreu@synopsys.com" <joabreu@synopsys.com>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>, "malattia@linux.it"
	<malattia@linux.it>, "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mgross@linux.intel.com" <mgross@linux.intel.com>,
	"intel-linux-scu@intel.com" <intel-linux-scu@intel.com>,
	"artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "sakari.ailus@linux.intel.com"
	<sakari.ailus@linux.intel.com>, "clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "dsterba@suse.com"
	<dsterba@suse.com>, "jack@suse.com" <jack@suse.com>, "tytso@mit.edu"
	<tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>, "luc.vanoostenryck@gmail.com"
	<luc.vanoostenryck@gmail.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"pmladek@suse.com" <pmladek@suse.com>, "sergey.senozhatsky@gmail.com"
	<sergey.senozhatsky@gmail.com>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "linux@rasmusvillemoes.dk"
	<linux@rasmusvillemoes.dk>, "minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>, "pablo@netfilter.org"
	<pablo@netfilter.org>, "kadlec@netfilter.org" <kadlec@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>, "jmaloy@redhat.com" <jmaloy@redhat.com>,
	"ying.xue@windriver.com" <ying.xue@windriver.com>, "willy@infradead.org"
	<willy@infradead.org>, "sashal@kernel.org" <sashal@kernel.org>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>, "David.Laight@aculab.com"
	<David.Laight@aculab.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "Jason@zx2c4.com" <Jason@zx2c4.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "keescook@chromium.org"
	<keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "freedreno@lists.freedesktop.org"
	<freedreno@lists.freedesktop.org>, "linux-hwmon@vger.kernel.org"
	<linux-hwmon@vger.kernel.org>, "linux-input@vger.kernel.org"
	<linux-input@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "Chocron, Jonathan" <jonnyc@amazon.com>
Subject: RE: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Thread-Topic: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Thread-Index: AQHcKz/dRIfBoG9yrEaIjS9Ywn6sYg==
Date: Sun, 21 Sep 2025 21:37:02 +0000
Message-ID: <4f497306c58240a88c0bb001786c3ad2@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
 <2025092136-unelected-skirt-d91d@gregkh>
In-Reply-To: <2025092136-unelected-skirt-d91d@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.85.143.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CBC7C0002
X-Stat-Signature: no6jiw73t47qxp96hsiamho8kupz45ec
X-Rspam-User: 
X-HE-Tag: 1758490635-742642
X-HE-Meta: U2FsdGVkX188+auzY2bHxf1PBnabqjIb0KVavh+9D2n70oeLNEDNFNZVlR8GAImuIkH9UKo3O7k/WsCWNfCpRipOUWr/3IYufcWS0Tb6zmIHXZt0iDjh3mUOygmqcFDBXyI5iHG6DuR7u7b5JKPvgIi3UpcspSOs0c5TsLNfhc6MxxZnQPA6hB4zq9Jkzvmt1HOHU65w0POQdl6wuE3/0/zqp9YKOEpCx1X/UbCJGRD3X6H3HsVvckkHrfxdfKc5ygoCjRzxlCQENXiCE1eeepv/boZugi7DIkHDHGN0DyqvlvskQQillzOcS2cpOqurCG5B2HQ0DFHlg1La2kuSNmPwvPZnT6nlcwG+EmdKPBNhjmRgMEsMhKuJKzNwvK14LFpUJqbID69p02DaAUn/Qc6qKWkat77zsd0Q5zRCjAj2JgykXuXbNdtj8UjLdojUrTQoB4WwuZ5BHnB7t+2kNC1ZGG/lwjCBoqefNtvJDNH7jDwJCY+MnXhiS8oGa3T3z+D1/CSEhwc25HH7NB6o6XUKcCsrY4/DZkYMySdn8HxZjeMSGtWhKgjzxJLphUYnEWPBsSqPe0whRjbhcIwEcBqnSFa6E8kKDEEuOj2WOnal81bAjpTuB9JrrqXC6dCzYbAzIp7+nZPQLCf4lMqIM2A11ibn2OPP4DlRCFqkllpZXP/C2ix7ndLqwQpC9883Z3VFyddHw98e9FcbvI44/GgD+vFHIO6VyZai2bIyCkWo+C1T7KX/pDQaSScnqbUzpxujvV1tv4RTF0f/dFjWDSGaEZmVfRQcv261IzmWKnEaQVjul16ZneX5C1YBmYEgmlAaFW/a+tgSCRnWl1AUz7BhYfWJy6R+1Tf983oZHOswTl+hlmDx397abQCSejAuRTLmK7ketxVH6HMvFCFT8k7XiVEITcqbJPdELJ2A8rxY5YUgGBHNBbjvZw5BlLHilXOaTZN7RQ96fVWIFEc
 kow+lWGz
 pLWLbuGo8GH7TQ5QVIjdxcy4n8LTCOaFFUhbxDIEi2HuZF6YxMJChgLSgWhvEhyQs+Ak8pYxT/rNYRq6Z1qLcJ3i2+ULw8CbmUdm16VM7VbFDSg8LREl/GbRUayrxVtu1RnZAq4v0KSZNHlf1HoDU7g32MlCu9DH/fe6j4rMEJwKB1YpUlcdZCtGKF40plnE6AcHGMCpHAZWiDIHVimrkfkBD768oUBNFa8B5dd0AJhfCmJcRg/E7jxQy9KBrR4kxbQMIV+dRTbODamTClOMarfmwrq9Hz2hijBCmHE5YTqzycH+MDEfz+DBrtisPn1AY1U3PiXsr1QbtFX+8/cC+KZ5qmuNcMs/A7JFZJYWdCvk7oCLp1UccWtT5Zi4LyPC3+zArH8HeMxV3lnJVcm43HmalpklRCw04tlAIVEfQqaLyIJTmjgy6EYPMR38lDrdkjoi8N5onaTH0uuKkAbBUJuuJCbC2NYhNxYnsPoIT0NbmlfMGUIFa8pSJLJE6DgOXBPumZ3nSnbMxUmQInXwdBrzRDlPDwVWT8vob+Hk4GYxXQA+v9YNYTJ5Ai4nCv/ufLN0pZWF68wzdqnp3IjpLgjXgg7hjJm6ed87I8d6xMbZGHSv4w3hyDl6cig90xT5yWbP2yicnc8dXDThV1rHp+kLb0d//ig4/k9gdmjEqVkMzpn0Q1bJ0b6AsnIGmKIT4AfaJag3NUYnFhdQ+mdZOYd53MGyePcOtR/wm/ykhxSwW4E6bW4t1qxibZ2lAveTFnEB84Z60BfXmHDSR/swdcUWRhi25UiZ4PtipqjcFM8gbgoUDgBdEgmJX1pMcvDAxeLJwjEkPMKthKbZFRbox5bBtllE0ES3rQVT2PRuASItKLeN/4BZ5zKZUdCSFm6ZQvBwU9DL844K/sl98DBibjHkD2rYpg3Gef9XkF+z05PxUfjs84Kw0YnrmPmDxWfGz2X+hxd4M+HjXswriN3g+IL+YEpR6
 KQgEi+VR
 Dv57RvGs2MPgUT3o36VdCzTkmZeBgDn60pgdft/PfTGX7FgVYezOxsAl47QaZndn5Jcpn9FUj3EMisuQa7yulxz1hhlQ1q7lrNW2nU4ptE0WtF5rmOupe+XbnQiP+AXET9IsIL5hhmmfATucELjMewFoPvM3ouDpAzdpPNbkq++z1IyCki2etI6/xfjvJud6zAvC45c58gNnyvtzNvpLijm2UFMu6IDnEN+sGUvelplmm5znPtKtK23DwvV9YGH72/ObPocHA2HjUhcYjjLlcju7ZoE8BgutQl8MAO0IzYKi+CkLIOPs/1XdMl4mLMO1lcQn9kvPiJjkghHBJu4WoFWe6scuVITz9iHsnv219OhhtgA8Gz4wrpkkFMB8G53bBv2yVyH2MvzwxRVLw4soJ7/GwGEo3VzPuJ+eNG7SKRvSF4TLKZ+VlFmbya3lMbApVqoh+TMPdO860ueaMCTTLMbr7E8HlfobTzoEqpZT8GcQFGaey1Zh5nc8FXnsSS4CLL9b/K2tL3aS00m6cx16bF1liMXz5sItIPSUS28fH4IyXmEoSzsI0qxG4UgLU5TbPRn4u+S+UnRyEa8ApaH21CFJXAhssEGvYAepLq5Otz3zJ6Wt/1lkOw4VPrWNVmVugJGfTWQemdQTwOLE4dRxpI+vwPgmyQCxyHlW4h6g9ID75bNv/Wvp7XHuiGUvKFfSLbnwmjgoWjIlE7+OHpwQO0Ucos6qy9dO+sFQ4foEA+hDSNYEu+YMzYIX4nm1WS5oCNC4wWmaHDY85YnG9MLDnQMAVvFTRJEIFcLkxcqwbjX1kGGl9qVv7iosbYU2J9E42r+GPTckIDeQRPS6ivZcsfuxWWLSjPpFmDYhzK4xYbku4zuopVB8SjNfXB5H2RBGi2w8dPmeWLBNW/iI1nKheOHCThWebXg5IKZ+TZLSDbQqyO0p60RWDm19OkafTvVp0Q3goGYnRm8/jkkrIt8sVCxPFIjM1
 JpihLgtT
 zZ4Qk7jRyrABbp2lY9fo3xLWbrDp5JcLJXnDiV1RPw94slFettRDcB3xGjSIpGJ+FQ2XCq0UYeW1WKN5wuH7RTqGICPBSdZZnrE/JRnfFn8+vhg3Rq5F/xdmmSQO0dMomNYVoyf6tQViy67m5MFLrm0FPEKEZH8dq0ZTIIFDXakbgytxaLBwBVr6ojFRl5WEW3Abra++SPtjtQasUP9XF8U4u4rzd+tYus4Jg8vikRxFTitBochuHrmh+ZPe23tgibKNsnhDehlPHVC1CQPiHZrEa3sIcCHL19tcU4EvB1U4ej5E/FvIDVJZ9Is8cJRQBrGvxufMFlmEFnQCyRsru52vE/SVvTNbpR2Z4wjU0Fq16yVbXnORUA+eIaa5MypBK8OyuGJGa6LrgpTSvuMNAxy+wwg6v5DRz1bg7r9D8GvOj5lXXP+44qjc5sePYslQihW1WUcLoSlOMQtsUXzzM7Z9nrsMt80oIGq5BRa3DP87dwr72pPrcjzXXbBl7zHAvGsRBum+FXMsDQMk3qlHmBc9jSJp0VsDqQvpJgoCtqn+aG6OoKHgzTWJnB+NplyPBdKsVpSqTFMZHfSvV7gaO+VRFez7R1JCpzEGYi6w5afL/sczDPbtm2x0kwQ/pWUu8Srmpu6a9QCNxGC4Bw+V5PjtHyuntLNF3RB9t4fuCkR0lKtx/m0LDD7MrYgIO4sh4JHhujZh571N3ZWInfY+Ny30D6rIgxgOQgw90/+iF0hkK7IiJNCLVaVkp6FLF2qydgkDuRh7kZ1jNJWCq+YXpxmatHB/wjSrXwbqVCdAU1Pgi0J+yhUGktym8f8XyOQiDlN7BlFxyoh+3PNaS9TaaKIc8odyETxGNBRe935oo7I9zlulVcMF8YRfh6EqezI0iz37FA9/eNpyOIIod/1epEnVl6OXWvTyDXAY8NjvP7npvXnqlRMA/U/EfHm0Umu8O/W4CSFI6tYuVDK1pIjYfczmHWF8v
 1w3Vl+TA
 5aalUec0YHCn99YdbTIdUyhvynuP3J03Nm0n21/IgwbkUHP0BVX9c6WM/BhbnVndjlpCYAjh6SBhMrf7UDY4OfncHpJWtwQwY/ALm6mRQXueCTherlSC0+9hNe3V1ziWjG+q/Cqhm6Un888aatK1jF2imDZHHwggpghmrCxVBN/NorXiKcJoljT8yvisPgtpaTtmLIlifbbY6sSD26v7PdIyV3ZYH4FXh3O34UZ/0ZRb778rWAQkmIyjxnU3K/cnuXQe7dmMY1nFiXYS1/HXI1UVc6yBXmNfrDxTbtKhWP66abCZWozQbLYLIBx2LgiMeX++8RWZ2sxxQFMR9gUKYLlPhakG26HUN1mF4Tgrwehl7osSY64worcWihn8h3laHh9adaDnAqHZ0tuDlHTrtdYe9tQC8ue7VHpGkIyBRvwEutciN6WZ/bl+KOC3tUxYqCri9YS6/34In9fEAfB/2ur70T9YKAFi2lMsfiDZ1vUeHyX/NGYGugWflkj3rZ+3vWCSFKiqkQhB4V3mQ0yKZGw9207zymHpzvvEuryY+hsi2/w9BEEssS5AEcHmGb4JDq8FOQG4rf2Tiim5WPblgkUj4aVSdv+b015hXVuM1siNfXdYov6c03eR70AHMjKuH0SzgTbVYzyIgCi2FsdqAMd4bVQpRTGh4LK62v/kAwwphThJ3tWCk6QcXyepjeEKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Sep 19, 2025 at 10:17:00AM +0000, Eliav Farber wrote:
> > This series includes a total of 27 patches, to align minmax.h of
> > v5.15.y with v6.17-rc6.
> >
> > The set consists of 24 commits that directly update minmax.h:
> > 1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() macro
> >    once")
>
> But this isn't in 5.15.y, so how is this syncing things up?
>
> I'm all for this, but I got confused here, at the first commit :)

It's a typo.
It should be 5.10.y and not 5.15.y.

> Some of these are also only in newer kernels, which, as you know, is
> generally a bad thing (i.e. I can't take patches only for older
> kernels.)
>
> I want these changes, as they are great, but can you perhaps provide
> patch series for newer kernels first so that I can then take these?

So you'd first like first to align 6.16 with 6.17, then 6.15 with 6.16,
then 6.12 with 6.15, then 6.6 with 6.12, and so on until we eventually
align 5.10 and even 5.4?

---
Regards, Eliav

