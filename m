Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2939CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0634D8E0008; Wed, 24 Sep 2025 16:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D038E0001; Wed, 24 Sep 2025 16:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6EB8E0008; Wed, 24 Sep 2025 16:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDC168E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:29:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64424848E1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:29:37 +0000 (UTC)
X-FDA: 83925284394.25.4D5FC9E
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E1B5C000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:29:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JhLiDano;
	spf=pass (imf22.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDg7SD6B5zXfPo/0otGsE/Jt9SBkXdy2klVdQymbH7Y=;
	b=NIokiKlc5eaE3nv/ShllmsvTyDcgmUW/IkW/v3fX/bml4ZdBIc4HF6JGXJzhBdv2XaT05n
	p1qQ7IpXqNhL8upbEf9qvfxWqv1a121Z50FFljGM0LXfV3AYFzseMxvzGBE9gwaFH1dtM6
	iHWxZxz/QZM2mgINUihXboCDQNAfgMI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JhLiDano;
	spf=pass (imf22.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745775; a=rsa-sha256;
	cv=none;
	b=f72gk4NEGQxPEzPwdNoRdzXSuiEwU1lRruUmGJ/XIxGBV4kzAPwKsIPA5HRQKIpDMDy02T
	zrWgacvdeZHvn7dvvI3ZKyzpcBlGJ3MGElMfKnVaTchI8cINTgUEzY+eEJRx8k+St6QJaV
	MNxTFdy5erBR85RxkFK2dVWYJKOx8PY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745775; x=1790281775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QDg7SD6B5zXfPo/0otGsE/Jt9SBkXdy2klVdQymbH7Y=;
  b=JhLiDanol+Qm5Crz7Kh2NSfgGHduDe4nQFg2QALReAAFncpk1PrU17dF
   HajD3KsJNDHaWlSCwHgWFjJDFNfmXk3Pav7lYqqUFlZ6s/FtZPWA8QSlf
   5GEMCaD0bPLPxTlcvK+8vPzTJzrEFvA/ESQl5Zqh1Bvxt4i2kujJOHBOC
   j1raZTPt6gSI+RAYXZXmNkkmQ7nirjng8mulJ9O3lH24V1J1MVd9F2d/r
   TabepQPkCBIS49Kahb6X+GYT93ACyA4/8c2ACChWnsfvOCHzTflXXTbBl
   Tq8eWWn7s6et3K44SOcunh+Y7dPZvuaaqy7Lec/PDnPNAkJuX5iHPAI8K
   Q==;
X-CSE-ConnectionGUID: ZS4O28C3Tt2Fp93FAH1pYw==
X-CSE-MsgGUID: pLwL/ZQARnSLbZ4Xwbf/GA==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2525209"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:29:33 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:8877]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.2.208:2525] with esmtp (Farcaster)
 id 5301ed30-7dc2-4db7-9258-0fe6167c67c7; Wed, 24 Sep 2025 20:29:33 +0000 (UTC)
X-Farcaster-Flow-ID: 5301ed30-7dc2-4db7-9258-0fe6167c67c7
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:29:13 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:28:38 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 08/19 v6.1.y] minmax: add a few more MIN_T/MAX_T users
Date: Wed, 24 Sep 2025 20:23:09 +0000
Message-ID: <20250924202320.32333-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2E1B5C000E
X-Stat-Signature: 81js8bqfodadtcoij9siagoyopinim7f
X-HE-Tag: 1758745774-639133
X-HE-Meta: U2FsdGVkX1/cI3cSTqW4LzwFVzdJt+Awzy2wjj5DIsouAZ5maJm+za6heNmO001SeR+l85vS+4iHm5uDoE1vbz4hcsq1tt+dM+VaXtACnBSCzF2/zVjD3AN3m0XExMg6Z8g+GcTvnCIVL6qg9vGbkPH9qIAis0WGXsjqUSe60uKleA5Mvm3IdaS2w+JjK7GIBM9XQI6T82wasUAVGXVfkHvhtneVlW6OubR/ygBaYcUDvH2bzYkpi13756vi/IhW1QEg/ARwFACqyFYORChJ34ZzLusfjLQQGtHX5M57mSy84DmkkM5Zu1voQfydqvl6R60W4MKl34L/lIDpObl7HlXw1shLJTPNaKuxoj+bZLhVBa4kgrjeI4jFuz2tTLqLz6acIGOZFoQL4HNjUGx34wLtvz1HDQ/RjT3bN1bavoJLmK7oV3PCxEyzAy2Non0SoffnlmrJ8sCoQIS76SpBiqU3/Fk24baaDlh6mv37bvWygZyWiiiVmIsH4+3adpPHRcthF8KiyWHiXQGUMPWemkzYz9N+NEXP8O8M/wKC0re/klyU3GNjfr8cu0FQXii3RrRvVS5Y3US0sFDM46KqWCNnd1AfUEV9L6CAXJAyjX8DpGKuQ6C3OW16VN1gib6yZtc29fCYkfM5UyLwVGxcvyRZHgQ/ykJO3lmRorGpbpdDZXz+qyNLKHXWdrTgdRM9oBAzXDT5+/cEdFJ+PxY7aq1pUpWG5lwwFa7HIFJmPa8EvoVeGP5AHimXm2yxW98jw0//txA+DhKCN1mbcYRI1kvwpMvuzMEky1IK4NPpS4vLi5QqIA1E8uPfD36y4knIqeNRkczoG4I4lAm3xKhpTTYh0C8D7n44+qEt8k7x23f9xl2ROKcmjGuJVykXn2hFOXa8BC3wOmZs7XHElsunikOxPc9/zoOafqRSMEr/aAq3jsXWoNRB0PrMNO52WeHRegomD62ye/PE4IPG2K2
 F/7eYoOS
 gwgSgH9nfhZDE0Ff05ju6O1nepHmDgh4vvq7Hw9KFaBe8NlROHRTP1PPeB6cCM61lslRPdmHsETUznucV/H4Iz1GSpIBbAYUuoRF1hXDoOwIQ6621j/BVlrkiEApl2vtH+O1pScpH4VPYM+L3HLtFyHmJzWWpG1l8Go+9QaJ+Ik0RXs2VIAqY18bpY3NQ1Hy2hI0R0N0duotvxq5ssJS2WnZjpdOpqpND8F/eRIyiQw9aSR9oxOaC4acWEw09FCQ5aY1jxgKGsq6MZHOGCDo09AmObQ97PAZH8L+gbeDg+7rKxJEGj31MnrAjS6DLb8up8a9A0OgEbQ8b0K8/tzkkNCaBJUKPkgAJ5x2si3TTgcme7lF1J2wUFtagUtKZw0cJlGzBhEG1V23B/fNTHBUoPD3Ss5/IiNqK2snVo81ASjUg+Y3/i6FlfcHPB0JGudUSOLxzbFD3vkhObpnzTDzcEK+iSffPRWgkCDa6gLpNv4Ly1uyb2t59VDF4e3EfmMZmv6qRoo8lhjujfsVtil6UwRIvHrwQQvCX2n6Cp+p1fg5Pp9SPWeQEGdDFhjw+lVWOCmariLYhhzrHAHhi+R+UANF/+qCB90QyDiF8eTUI7ZCuH+c4JNVL4cKDC7nH/SB4TFdgWcytDVQpUGm85Szw3wRVczQS4I6dF28J8nR3XZ97IuVjTRynbtpcOxs9xA9y5OZgdHUgDaNpXQULS08/jtfFZB05JhJ1va9VM9Qio/3Zp+yrJaWS4cxXDuuUmdWT+V9EWuItjNjMb6e2XjDmmukdoqlqHC46RJ9yymrxHmuh9EfWXy7xVtKPinw4g+np23p1uoSe0Nim8OWBrTAoaj2HqXXJtMB3hAmgoDoK21Xo5cNEjyGLV0G7cUgPEYTVcicVxOaEQ+ZYXwQ6S769icOA12joxXzyfXOkXkrRPUqHoJs2PlJOMa79TrqHrHNpVHKi4lmqj+c7Imsuxd+20/2I1YxM
 Pbdl473Y
 0BOpiuSdoFth/1d/ab9h5WZuNxLeEg4cBCPti3NqczFLXRcwn8u39On2nILaRIDDC/iAeftg6R/S8BKrE7lklLo3dNc08r87AJ+joXbKOTJgRPCXluMm1W2qCQBe9n4y+koNdUph1HYKp2doYi9aO108kB/rkWwpmaMtWJ7InMIrvgmg2hAw43mh5lnQ3WeB9rOYvOs1CKnharWA+4u5433Qzm2qP7+KXKNgkPp8GJvBjFeAYVpIJ7b1YteMYAnHmXGWoM1Pi28wgJZMYckMWpUYbvdjOimGWwzkiVkuTTzIcWNz0KPChUWpmH8bc4iPtpNhnllpMD2e+uBGXzaRW4Ev1B9ApKg/Jlx/7YKxKGLGhDlD4rBBL89qr2/RZZ7LmiRnY32b0OUD2+Eh4LfiztpysPB2jSJEAD1g4bBl2k2q+2+wJTiRuPcGHde7TWpksnzhx89MyZd7Y897v7pZAH5i43M/dOl7ANweO7bwxRQ1eVVVgHVRz9FxdIt+p5koobzfuaecF21bZztXhw6lvYL/+Alsim/SEh8eaEACPd1ryc0EnR88xhId216pnXu527WicnXx20cBY9jNvOALjqe2cbmzoiF0EMsMM9T7dGxASYdlOImYUojkHmlpRjCfDieSJWJbGET+1WRpUDAv+lDqmY1h35A0disw1ITEJnimzekbJnteFPtO46GZF+nLo9WVtQyT9qGAqxdeqAg3OGoAGFPYZSsB1RsjS/oxpGDmjX1rRAlMI9yyPZd8fXPRzN2QIO09Id2SrgzKCAF7mPVaf45DOYgH/lvABKNnYBJ3044JtA8D6iRxqQukgXSqpEQcRGHkLEz/zTg595IDyRNrO5wbfjl9JU2V92fmQ1052Uygt9aximTonxps/1/9VHToxjPeoUluO4DQtAVdI0k8n3D6W9KyG7s84YUWxwc2CC77zOr//vN5T8ty9aM8dCITStiV3ev0FkBbq/ViFgAqLaLH4
 W2GphiZ0
 xD3qyWOJLkRc//d4G7+WWhVS/npt3zvxP3ISx1hP9jBHnA5iUDp2HXdX88QUY5RG5rOuif7YndUrppXaiCFIltGmipyI+iZQXAceqNd8V2PKhhsPU7Nhh/OgxXZO/cCjFY2MSo7KfQFq7mQEaiF8Y+N3M0g1imBoP8Q7gccHE8R991/oBua95xlt5QBz5Z4TM9F3fbDWSprXOFlEt46QrsLR04JloMnJeaY5ReqOOTSNKVJxT/7VXb15yOwJuCWYWHRpavr/IH+7DFoyCI8yXxjtMDJQ7dx3HrtFcCScKdeFhU9nBGtJ8IE0U4+zAvX7hsD78LjWyrI+c+SEvfr9oyRJO3KkaGKszVjrmSJKpas/Ye0qA5z2PAuEfpK775mQ40qVW4vcGDZ4mab8F40JoEaHgNBWIRoFeN9OYXjRoQs2IIuixmDLtVu7H1Qd1YzUBU0s2ikL5ttNfBhiPZB7lPpNftdDer3hsOffhrJesrtgVKm7k5zHngud4dMfQWRco3FOiPGcef4uzYdkVbbNjeWyRQ5LJUo0mGSeNple81Lfz6/obGCn+CDuh/1Fnzo+mXMqzFvsP5TLcdMZjg/nku5Y/8kzfsk1S6503nmQ5OqC5IjEBB6yxnc5slUVcbKYAG2WyAz1AIRpkFKNMx59kRSw03yWf79ZbbWUvrzXV9BO93D540ponir//xMO6gRIhnE2jflbs/jsNogdRlk9t5fPnw8RznRQpkoTZMFkPLEB07WpwoRtDN608+WN11sGyvQBlLIU9e7olwESYs4gV3QywJg2omjlrc3caW/j+1c6AeI+c98DFnaU8t8XSnTZZ1DTAEnGpn+/HC0oO+XkkNPIKaSxUt6gRmo4q7GneLoZ7U9a+SqlH5ZaCHXYZr53tyHhDr+7KkAWpiJXEIChahLfucyTdfqjaT4RwbZsxTJ6Pkk4hvSGhadJRONHrN0KZyE3QQAZhRD6VyHwewSGoMsZ790Ab
 5sQZ2Ip6
 fQiB2/KG7Pgu7gW8NjudW56gOInWX+Djoxqx+QR/XGQ0IiSDCgCIkVyW8cvl4Z2UF5f2oqvc3vYiby1hlBo3bLOG22Pr9JLDaKaeA6WdCJwO7Mh+m33TOu5o4AsG8Q/kfQo1YDbeqIc0nkI0OCIzV/54H2YS0scWhifuvIhx1CF/qpDhfXg+W1009V0n4zo3w52HFFl+OtqF1c/DZwzEjuCVMwtqVJgvp6XdNAURkhQY/+r4bB73yjmIDPxNx/070ZRgidqjo81rnQZMgI4p968A1qtPqWOWynrmPnv/HuHwR2p5ez6sH9iJNYhQ4/j8tnVbYtF09kYJvStM+T2FhDQsWSsS00Ab1t+BPBOKiK2UhafQYnn5YNhI7xbeEXTwUbCHAuatH4RcDRwP+WI3iwkT0t0j52BOpftS6zozgkmJzyNhckdLFfHqFhi+tOP5LpTrcS8hX7xeLBfv4heZcd/ds5Nqks+xH3yIcT6C+rpx6S8DL2dTPfcmRRl9RHQK7Z8xN1Z/EqOz9Tv4eUofIL8YtmYUduPKguEY/EBfaa93Wy0wWDOpC7bReZb6eZBWfDcFi3Q6i1nlMbOuz2LjqYzwcUjAZOq+yjn/pb8SvBoNHSiwzBJPjEtTgC/Y6M9j2Fuet0MDnMwfozak6SufUHtjfeOGAXTEFhuaNm0k9S+E1AAgv/26KWu6bv5cLStly47/O/lxlmjJWt9rv5ySPkNMHTr6/NJ/kPyGVzr+YR5pZBGVmz3O8P59Ia4KOt4+5oeso32FaZMmy+PpiSlnz6HqIFYK9L0nj5UEirJhgr5C77jQkQ/touiK1cPJRl4hghHysJk02yaWcI8kH+hBBXgw7Aa2NbbmZ9jZRFBV+Sh2u9Ekzx/iCoK4kO5cFsxZM155m5+ROG5Gd012Crvfq7b20VqJHNwHjFJLSidIVbp4UJCkOC9T6YJQDnqBG1FuLZf/fM8/xNFq3n9RunjsPNn2/MSdg
 gIt8mUE6
 ajdVTbCChg2NYoqDVMqJeRcJPQp8sLLUlYJCUnbTlZtBh+/aIGnKkzI4rilofFAG+nfQP3XSiR7FYVMd2dCDvbnIGVosbPp1P6ytZznOUAeUkjKY3URD2/yiXhTUsZwX761hy9Wy7cRedHVRcFlDAFf7lmuwLX1VMXgJNzWI7ykkzk2jjrYw7Kr3QahfPsM84jpkkww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/x86/mm/pgtable.c                             | 2 +-
 drivers/edac/sb_edac.c                            | 4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  | 2 +-
 drivers/md/dm-integrity.c                         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 net/ipv4/proc.c                                   | 2 +-
 net/ipv6/proc.c                                   | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 77ee0012f849..a84d3d82824a 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 8e39370fdb5c..f0de7b18a53f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] = {
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index d021497841b8..3969dc548cff 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -532,7 +532,7 @@ int drm_plane_create_color_properties(struct drm_plane *plane,
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index efd0732a8c10..a201019babe4 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2618,7 +2618,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned int write_start
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 948e35c405a8..be84aed47160 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2827,7 +2827,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 1f52c5f2d347..234b2e56be4f 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index e20b3705c2d2..5e01863be039 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 
-- 
2.47.3


