Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3846BCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D928E000F; Wed, 24 Sep 2025 16:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E2C8E0001; Wed, 24 Sep 2025 16:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5628E000F; Wed, 24 Sep 2025 16:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68EB78E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:34:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 207A684CD2
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:34:47 +0000 (UTC)
X-FDA: 83925297414.02.3A70086
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id CAAD1100004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:34:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FXxN+j2W;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=AN3M8yXKULLrlP5zYldU9NG/pyVEhHpPCEqscLrXSN4nR/sas3bZC21RWyR6X+1jki7dSN
	1C3UJv9YQ91bUEDDSLpZ+nnZL5y5J4+JkHpt3m4BjPNjEi1Zg2c2AqcmSMzFbV8f5Ljopv
	vc+ws9Cg9K/VLQTDz4/O2hynYAIU7+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746085; a=rsa-sha256;
	cv=none;
	b=CAMHVjUha0C8pwiL2TnCUcwiCfRAbpgS3imTkkBYsm7wulKYPqJZuct46WUQMlM7Sql2Ob
	8PmjbEYctGubicV/pxBTEUcawnC8xVy6VjEPBwkZgLvjRxR4V2jC+Rsb68Rnx3DynAV8Fi
	Hsio8WSEmJuPMqHV98XcJhVFNoeAGFc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FXxN+j2W;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746084; x=1790282084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=FXxN+j2Wcz10AjhpN7XQe9DjhpXlq+DuIiGUwQn5ty62K241bZotq7uu
   GPD8bxhY+sWxAtntIv0eLWLB2ubkZu44NbdmxMuJhaYnFwDGHfEsKKPB+
   wl4zBq9JsqBhOviV6st0pNEQkuQFIQDuOx35a6gHVipm6q047Lh10fpAC
   p5U1pIbDGuCLmqRCqn7SwiCswqB+yPGEpwB2QWVPcnOwRRcJLvqumtRPD
   FD4GFJvLz5K5EJHZl2xrKrC3G44onjQIipyDmiD50HRLrcussfyYs8KX3
   Bwghj8tfjNGqROwxd317MCPKUUqY0z6JopyE55De5Ah6Zgh8FGcIrOook
   A==;
X-CSE-ConnectionGUID: m/+QKsm3SLCrrae6+K+wNw==
X-CSE-MsgGUID: e1iayThcQeCIi+HH03X8Qw==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2526216"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:34:43 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:24683]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.230:2525] with esmtp (Farcaster)
 id b6a810ee-396d-4837-b14d-0fa6ee2c8881; Wed, 24 Sep 2025 20:34:42 +0000 (UTC)
X-Farcaster-Flow-ID: b6a810ee-396d-4837-b14d-0fa6ee2c8881
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:34:42 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:34:06 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH 16/19 v6.1.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Wed, 24 Sep 2025 20:23:17 +0000
Message-ID: <20250924202320.32333-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAAD1100004
X-Stat-Signature: rhkajn83sjqj847j6n3xzog5cocfzqih
X-Rspam-User: 
X-HE-Tag: 1758746084-309227
X-HE-Meta: U2FsdGVkX19mmdnZk0DPr7S9HtT2bR7/G+y0JjVXlZghNVOV0IYvtchDfiCYDlhuc9jq0RtM0zkiUuql37Qa1s63o+Pd+I4Gs6D1GXk2/Lxd0Qeqs1Kn2yMCokkK4VObabRAF6UiID2JykbbtrEFFpmSvdkZzLPmhJotqBpPRAw88iosFLPVy4Q7AWgNUC3r0mnHLlg4/U0pdLGcTC/kea5JJowNbYMMF/2hrqSD4LNdBJOEcPNjGyifgIwfPSDqT4nCAjcOhmCZdJYX0YqoWK4IPk9fABlt8fhRw/0RtoFAbSA63ZKnNfhG31lhVjH/8VJ8C0MpuzlLhv4uCVl6d4T8YU4s4nKxnWOB47/hUgaN7GiAjUC2ty09cyRtWKyAh0bZF/sYUEYY5CAiJkx/sX5/6YWPYXl+rOPAfPqNGoyrMlduizI99Ce2qzFCyTFKh5Q/Bii2S+C7ecQ9o1vAfKTp8MIQ8A+XU+3DgXOzkOR27GVTZjyPdb9moQZNcOhhnlp1IneRQb9SpbkZlXvFZY9xfGbzX/Uza2OiJu8GipV1kjVaRiemoeO3nTmpetPntaMVvLE3xiJzccM6cpiDiw1kq2THaRzEZ00KXhQQLAuzxsSIFFU/OwDOnnRyGgQEUu7pnH3LsIbKxmzkvnKVvIer6InfH3Pa7ioxTkzQBgtNdJX11DlZtmLuueUwC8SPLYPg2yHuOFrF8iDm6aUgKBWLgSfDGzkT3FRPgqpBUdXpv+RubnBqEUOTAFiJiCh5ClXxhOS19tRWppCaszvtCe4epGlZ/88/yUruqt+9dpK2TdXO3bYxd1veQ6njmdyAO7fA7UvAfWE9E6KMiwOUzNNrnGN+tXmgGTapZ3BnnV6PQNMw3awS0jZaAg1ThZ7LHABnyUDR3pA+/NE4KW2UDJvaCgocfjEakGJ8Ya8Rcbl6JipGDyXCXycUr4V0A6hjq2HvPuuNYCqClegoSY8
 S/tuDiUG
 433POf4Y2RpxHcgYF+n8k2MZIOxpFi+q6HUG2KITyvXhZVOcRKIIPLawHilNzgAw4dFS0WrVH4BhjL+Akpw6UUe6ZGvbptsX0QCAWzYk/TO2q/mkk1PZ0UgsdGNOXcmRFb576cI7oaVpuod+XTi4iPk7nKqMxYVuZYVaesg0GLOV1gPFwLRI2jhdlcJA7tfd2ZxE3omIRbt3eAD/W6L+w7UeTddQC7l1hOGmnOcuG8JkRXJnJkPVagqw9WYSA1KT3D96Mv5U33xaT9V2ahrrpP+uHMdiuWdSFZiEjDyeT+14pq9+z2jIe4/FWgALR9H3WY2OplX8kSSUmIzybqP8Ylckv6ZxAxQS5Cw6pw6/h8D9GBObJo6DYMcsxaQbr3yx5GD2pj/k/0n37ZGlR+/sGA4zeFcguwbcmGsg/7uycZNrvJOJIvqVh1uHalL+0vzr6wLOqI0avEu9PbG0C5JPmGHttcdixsMxrB0O/3sWjzNilnpj0hlAZ9yGio7oQnRuj46If2AKVnGrD1GqfLvIzQ8HZUYpPMVdlVNoA7WhBMgGfrKpgPBGg3jnfMh9U6J0MBYd4fl9Rz5lWcN9LggCPgIXnfzcEmV7mPG0mUc5RTAEXhV9AincABUr3KL/eUSdHR9NKNiM634ojyDzbObmIaMQMyc1h0AaS9GnGnacm6n/9tFZqev2t49p5UgaMG10uA4QjYqmvkSEv0sGpvVkJUhK+DbUWXNm6gG5e2OWFwfKADyPSFpNH9+pWJQ52zTlh1vT9tC9mzlZi0tOK+2WtsIjd9oUKi71wTSu7G4f/o01G/X98VfPVKrrxm5d/P09LOhYuFHixH3o2GfNKY4JWduJDeHu3C0bTJ7CXpNqJcGdStw7cm33Ovzid6wmu6e2HfORxjEPR0EGw4K8vjniT3MGTYc0Z0GDIMu07E9u91SOtxXCshwQIFNymWPs6VNkwzvfAO8cMaY8coEFeSllwoQF+T5Np
 B7ftIJV4
 fyO6FMl8JB7NxnIrrB/OGqjmKu4KqsSJU8Qge2aVnhYBW5b1EtGDDVx/lIVn/cYBcxjGRVuAVMopcmPbMW9ZbfDWiFUNz6UDWxsatdzT2qHIoEflI1Epc6W5BOP+hrONI/q5+sQflnnFKoluY1hdinyeCPbIDY3HuQTG9k4Xi36byn9KAcuBpf5WmoJyM7pd7P11Yhwh/Bs8Ypf8wVID3nVghpL33hWtKl5WptZKZkwBFE0uGl7O2/CUXXC7FcHKZRCT1GgasizVRewaw4SYjMKaQ0caoRbyWVr2DAoIYm3OdPbfTxV/+FmUXw3In+0XXVNGw7gUJyI7dUzC1GT01+6LMaL14lW+Qt5iN0dqHGy1MxfmFlVLb1gw8ui+iYYkhLtLH/HAsQrSBD7rF9KHw9+Hho3tSQUe8Pkm49xtajyfcmTR6qe56qCnVi8U5CWlb2xUWurtTPThydYs4oJKJng8o+fVnASoxlKbaGRpS3VvPJuQo8RSBezW7/Y8s1Xf7/ezcFcfLEtN5CNqb6rL7qFrR26Ey0legXRxvrsfEuGgmDjMj7/o/FvXvwDoAUl6hA4x5fO7T87QEQ4JhelQlKSK8WHscAuR60wgtoUos6qZcdWRT9Kb75XeOfdeWGADLow+A0hKVxpf/GBd8DJjcAZuGdSSjHmHKQtyvDosqNNfb3uectxnDd29AUQrB3CIVq8BeNJ6jLxboAXN7eOVa5GfcmWv/S77MPw5nKN8USu1PVgOT8EETFmvnabMX6J8vU0Bqw2s03ugC2O/8xYIKI6XPUxhR8l84OB4s2wPdxZa0T9tYSYlzD0PPqJWLHOP1oq5PfZavmalP4/VB3HchmN5p5lMYroZM+38N/50N9xBkLw3NVv5jNtKHLWdPSJlfDbG/MmVwOTln9Mw+7WrEOeOjkwLVIp69wZy+Z/1y4V1rhiYEZMR0Hjk7sFp/4W5dzrmoag/McP2eDh0q90P4L8dMr6ma
 TVE4Nuqf
 VojUpd35DHL5966/lwWglV7HuVGKvQuNO3syAO/ztoAcik0qQonrZKUjt6yQAgh2wGGRqxqv2j9uMRoaiWUVxGSxDvDQm0R+eF2IXqaR6tWY1memQXeVeXUboccI5e2JNAwS9NT3y2D0GVHUTiij8U5Kr9TteGRrmoEJdv4jiFQwGLI1ONelrAgpqBKa7tJcd0im66s4CobzDQmVzaSf0ZTS/ocWNTMp7kfCQz2n23PT0s8HsBTfdpt+pXfR/phVVyURevcmimeA9HZsWp0ohGRrTKzaLORBGARP/dM7qYKrmZT2j17hiy9T/rjrbIkTkoMrAtfQDUNC/XkfU7seaudTzGNbH+acoIp9Jko2mNZ6wHGbww13B3fMpn8jezRWIkrNm1bV1hFYaSiphDOTV1vFyI+77in+hj7ZbAlYG4f6+SVrWWjKNExvQzWMNb/Q9CF7SqfDLbtUH/QPvhIUe+IVD818ApKRBVTJoq4sAPefWK3jwkmELGRS/U8pP2TwSgiRzupPkXTS5dXIIpfzFQtHUiSghXa4x3cgU0f03ud4hHcyHnDEfyamAjCjbW5nzlwDdexS1v6efbYTdNphn5dBMDkLVvr1gqbss19SCgUw8c0sr/ZczOjGUtbxgLp76fxXDgShEfU3T/OAE2qji0Sd8FbsMnNZM9Dw1dRLNpknbYMVdCwbVAFGtIRFn/UIUjXDOVUP2g42UfkbL3J4thyHwF4VJp+igvuL4CbQRcd8ehIZXojHMBHTBEeF+YKKmRGnaul1vdf5vYdQIIAYpPJvXih3khr8cr2Wp+5qxQljwRQxqBOLpqnms1wjWPto5Iw3j0SY+uW31K60RwnPjGxVIxJkbK1mXmgPKVlnasHvHKBfr1a3Auf0mbXCmyuybAW4O+lubSBzfs8wnYLkdmKvS80wCHd+tQGlcZ8cs4RiHQqP0UDc9sxCYu+ppik2Xw5RmAhY/xpqfjJMgsaUfaXHO8dLE
 W/h2abxV
 f6gvl52FplU4fUFIaC+U5Cgy/XQYGtmbjma9I7WatFZMUw4FSJYk290sqpplBC/kqUsbMYdDmPvId6AOL83c8QBpVNqGiBWp/DWMby0iMl3uY4SVlJi/KUirhpWN64XNNmPWNoZlqXcHTphDm6OHnVUnV5fHTbe4PFIZl20D9MG8YMKGlZUKGnb1w87CWKfxX3NpyLSXSx4hyVY4mAG+dCAF1hfFUOUHYgwahdIsMZVDcZ0Q2Mr8U6T1GC92JRYneU/g4WFeIQh9AvszliYE+wvvMGLbtEBU1knRiEHwwnCHBlaDYPglBOaXSP5renwLyxThwVBAcZzdFPShjOZDxLt7CjvOJ4ZLUw6hBQSxrYNXH2KZF5YgGNRexSKO4QaPboBbUqUK2os0IpkabXWW6Vs/9MFfsgU+WO82P8pc3o2ZyZViNb3O32Il1cVQiWWPtOI9cu5M2xXK/iuQa/s4xm/GQ6/KATTD2D+4mRP6i7XIg7MCGymOgQsfN4fgLUIeGdST+mnZ1LLD5zF64CMvxFDYYWx899epdanPl1Whxr1LyZYuMrtFXnIdkvDz+/JgHb099U24muDKdJdlpIxHvO6cWTue1KPpX3LDzQ2pTS/pvOybzHIOtqPof8+Jx6599xjWM/3cBmhchDr4DP3LsHJRh2A/i1QK9Qx/vmjxceCpGGsqOmc6xJ8QsZLLqFaGm4fm0C5cseRYr526M2Qqz3sroWi9e5mHjNu6n5Ph2xs9T+YZheDqU4p4DjjaxBIbdzJhKDo06aUHMDSy6OgiH1fmKQfU2ZO6qZrORrvLaQko9zIKENfRsIPslwrbvhFC1Jih/YJxaIP+TPQF7ybUhd2zxEwk/SKqnoTeDYFdABTmHGo+rGJiF5BHeKz/DT5uJp2GtSBjaLJMcMWaapMZ8ALeEW1MNFUUrzqPQ+XaaXsiTTNRfU2i3viD/WFXoPxE0oSaMZxLyqvSeOdgdeNo7nKiVCRea
 7NET1CeT
 pvEQeLq6dhIh0sVMWmRcBdXPXSmU4mhEalK9tDmiJTXqY2rNpD77Dlmo398uZsYbwgk/1mkjdoEm2fODpAmVZTDIoaygKG4RPDdT28Nv0GguqmOxkV4Uwcgkc+txSL0l0KAB2S8VbVS5MWlb2p3kkVXTATK5q0U1XnbS3GjoRpzINffGD15esxtkeb2nloKH4gYTJwOn03bqElDitPCxzBxOhWpqmNMPbLiZRJNS33uUFInoJHe8dpyQNwP9jeBbXjAyy97tPdyPyr1fCkk43GdYOpMLlTa3PkROjmJQLFRSRi0qFcMIw1WdWdyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
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
 include/linux/minmax.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 6f7ea669d305..91aa1b90c1bb 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
-- 
2.47.3


