Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4338CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE688E0130; Fri, 19 Sep 2025 06:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18EC58E006B; Fri, 19 Sep 2025 06:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056B08E0130; Fri, 19 Sep 2025 06:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E20428E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:27:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77B7158E6D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:27:18 +0000 (UTC)
X-FDA: 83905622556.03.03FAB2B
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3A63D120003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:27:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FFVETJ+x;
	spf=pass (imf29.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SfYhUHUdz2vUYRpmznvvnCmHBX3qlcufUWUmq1eJX8=;
	b=nAF0grXTKKGSzDLkqawJLLypK6JgvZv8Ar2xYVHxMteZWzigW2oWGlCSCTBCWWSoWQwMjD
	KyaczM9GqI0dr52/e4/jmol75FJxmfNdm+2x6TBDlSUf00q0flxGi07o8f6br5tTEJfefb
	bQw4SFh//CoQflzJAbEvBmPAUMnIwx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FFVETJ+x;
	spf=pass (imf29.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277636; a=rsa-sha256;
	cv=none;
	b=oTE73mHbnbbhNkYnegH6fghko6ICFct1Pxop96b6aWTDYm0FP4So+fYM7pe/DhI/5R5PG0
	2IAeklL0Y44Itv1G3S+xBce4RAlCQ3Qml7ndZpTxI4gnvOrYKXN7kZ7JyLybAZ1N6VTlwp
	I0hI26ZJbTdpF/s9Vksl/m6gv6lW0Ac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277636; x=1789813636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SfYhUHUdz2vUYRpmznvvnCmHBX3qlcufUWUmq1eJX8=;
  b=FFVETJ+xi5/POyUyJJXvdMhFydyR2c7++P686mqBA7NiK6YFVnZbM6NK
   VwVr358XzqauCB56mnMgXDYWdCAthoBXdezM0xYw1rzRwdVVBnO/p+hoK
   J+5AL7nJ1M6SafN/J29Rbf34Z0verIyZI3ZQx5P1m35dMX/PvdcL/cPt7
   M9prasf95pGf3JfzIe4hiUoPuiCgvYJFTUiIB+zo+esvP8ABvca+OBCjC
   1dOOTYLFyBhbJ0WtEzxYW0JtaeTMSr2vUmX9e4HMqzmJJfxqgRvb885Ln
   dGgPSkfWEFFXET98gHRu17hgrquCgwy8zZX4J161z6RA5p5l1sYBT+EjZ
   w==;
X-CSE-ConnectionGUID: z1cDqonPRyuUzbCuVhBWng==
X-CSE-MsgGUID: aV4dNxWqQgOj00cn9kOCjA==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2263980"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:27:14 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:2492]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.39.25:2525] with esmtp (Farcaster)
 id e89569ac-5733-47ab-abd5-44525f19a0db; Fri, 19 Sep 2025 10:27:14 +0000 (UTC)
X-Farcaster-Flow-ID: e89569ac-5733-47ab-abd5-44525f19a0db
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:27:13 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:26:46 +0000
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
CC: <jonnyc@amazon.com>
Subject: [PATCH 16/27 5.10.y] lib: zstd: drop local MIN/MAX macros in favor of generic ones
Date: Fri, 19 Sep 2025 10:17:16 +0000
Message-ID: <20250919101727.16152-17-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: npddc8t4j9mqrtgxyz9r4kturkzd6j91
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A63D120003
X-Rspamd-Server: rspam04
X-HE-Tag: 1758277636-733948
X-HE-Meta: U2FsdGVkX18sPjl8i6L1d5Wl4mM/rNSCjO+OEvqvHTzu31ya/l2DuNDLh77vJ7NFd+yNbb+LjOQijr/n9VmHxmptx9DR38N/DOiFoTF4hdhLy68Q4TLOOSpRIEAmEvp1DrMSpVvcVtlVrepWREopHIDuKrzdiQLNknruJiIEn/qyWhqCRTH2Rmm7hFuEsgzp42t/wcKlRZQwP/gn/NbQ25a09Xd0C16Tmd78rYilBztXOtLeO+/ZtFLtLKyoPkHth61neOQFjQZn2R6dSNn7CgX1nazqLPKmWnrh2Y6f21J7OTW9xyYYpIG9vTG/g8Kp/Rrqlwtb2q/qXuW4mTsMuRa3vO13egqgeSa/4ma4vmY9kkyWaUPFmjUyo8elfEAMfnHmRVq/X+0+PDFR2CLVK6hO94HMDSTcBtk/7VaPLTQNZxuD6gQfJDBLJ6zj6kiYTkG0UzZMF9wbo/UyldWzrlHx6yUCkSs27smYtkNdEaF3mSoNm87rgLQWtEzISYsm5CtPWSAcwWXEH7RFPK3uuJEiysoI0nZ8wylNKkoTW2844CoSKKBcU9Qxq4c0x2b0pzuZEvJBOxMDqQW9O5NUDFOreSgFSJqu7TltibXWyiyWtjrXlE7BSqVUmghMzuPNqox4+y/viVIcm5UNO3EKOU3Dd4Wbpxwfsh/ffX3zgbWsz9w3M7c/XDOI0vKn45/4GJYo9G4UjEYiyBw0uxeIq8d0tlr3W1qgL3wtCflVsxeDf56LHkhLHXBWAiP6/s+j1BAEAf9iBU5dA6Nd/Hxpj6JHaIAd6WKlE9PixUstmqJGZbcO7L/n4REZRAPafGdglsVgu7PgJmdABArMnqjYrh/SvWc4GskihlW7KratP5tx9X5qlnYIXP+4sPs2bauXXQSdgNH25K+WeBxligSgpcCJooRMn4NyxpjI+A8GkX+3lWQFzwW/XnmllY65bV7aRfz2c4N5392gJCCULt5
 +G/WROl5
 euVQ4lDP6W8dOmRSSUTMhpWVotmtbKRRkDpKe/F6hHffQkga4Jj6Q9p5p6EX7+O3KzLjHsrVfKgPAHEex3Tz3SCQst8ybYxvtHcGcYmQNZfr8PpAo1jMNcx92bWTvnheHJhxcOo4ShgG0uQcHKgqGYVTnh2AEPOkQJLuJmOhhgIKtF2KAbCmGnX+bHPr3Aeb9bU5Tyo1CP5bJowGX7JGYWaAdLyTg1beSHwDFmPJrZOcQX4T/eVKA3yNNMs2TwuVPv98+UmAfT3wWn5qTRNITZ0ftBeBj8kEq6fe04qAo7tWtEZ7RPEzl9jV0WB/aHHyza14wTXH5eoOMeXvSMUSfPqAhN1AMi6912+XTdXMPTv27SQNBUPml0fKfGtxwppn+7VLcKjFw8SrEy9KZdfI4xNSC9RayAH2yUSMjNmXU7ROWbsxLVlSiTmGRtVtHtGug2lb75i4IhQhHjMVCcuHphgkGFpZ8VEdhD73IlrjJ/knLbX1frSPPEptdcn6a5DnP6f3VK0HnrTfYDCKrZqHM/50oztV8sdnIT1UOqUAZtqQCvqJ3bgmKW/JvNTnca7yc+RsC0Zgy/OyVW1YZmX1dOe9YP3zFp0NSr78I74P9ezQ8l+YZqzkksKsbRsNCYstssFQTO//7EFoNDlBdNE1OKSGhW2tGL99SGpUwotNzn/O96pxm6C3bgKpSqlVhncl/RTaorIeKEPKpHU+st7CQeqD8Mm+gsXK5sq5yqFZfNWB0nE6dJ3+H9zFb1kYZW0cBMOtv9pR1M2R7eh4fCDL6dCWEd+l3a+2zQMOFPevwt/2OUS5BSwOrxKvsN/UY7Av/FxB5TNnDzEAy7z7pdmxtFe43n3X/cvD/egIUcvmdExP9FRmj12TI+zgmwNuDZR2MjiCfwn0KEz24eiwkFI63/cq+Fah9lDTvdN1Hx+TzOLt7GX5NtC/Udk7q5qTMg/dqtXl/AsXGoAQ6ccVyMCLPGDi28i/a
 n3wfcGsT
 Zsl7n2ael8jSPFuoTjUjoGueErviFS+pM+WBkneKK6h1LU0EVUMBrHi8VdUMKnKPOmu4vY3YmAeQUvgao0PsLwFcG6+XPZAk7BKl7LhgXi9b3fccnpPQHf+UgKybq9lfXqIgbAPOq3j3ZJjQOwiKB7qOByW5MyMngA6ehWvLkumc/sFp9UQmyzOLDmN/FiSHzu8svKFL4WJ4Q4fUepBiqVmwL2wjNswbV5Xz+A8sJ8wp1saBtD6t9vJSqrlSS+w6dh5kp1zvRXEAYrdcvSn144QvpMmi/R4Wb1ZxKjCk8ugO7+oO1b/Mnjr2sJc0wnyKwaEyP/4qMUKeqrfPtObXllLqrkbQv+knLJq4i7pmpCcSpVYFOjzJfKzNWlfo4DbyzuyFkiPsiL/Lo8pLJSsuthAGgmkBH6SfdA8QWSc88sIDR7jeu6+rNxr6zjDZrl1KhJl6MDit+wY0fDWdoqvM3HcsDQ2Xdprtwkcd54AtFPFVSFYvXKlpcZIJPgYEa+iAXoab4iAWnkTrM7JHK4L2Xy//U1qGlpYJcpHoerv5Y1qNv3GtriDBqX9myvAIynFFtyHSCkanZBXil4M8S632zj+DS9pOR+q+a+m62C0+9v4nvra5u3YCRtzrac/OP+uN3daiSql8CGmqFtXDz15pR2RTs2mCL+w9W0HgCn5pLZj5GDh1Ef+NVMYiqi6DrB8+TYDEWoPfXFg2qOr4P0PNihHbHic1FpaDeCPgcWtOwgxIWHIJzGdm/3mQauO8j5QMjF8jzCeL9ByyyVOguHbM+b6eGWEqbMT4+IZ8ROI2nL/u9dQTk+Fy6KFr12fMNCKFoPnnujDVlUlaEmKfcqKqTM/3WV6oORt3TTr9YVa2L1aSWHFk7REh3HlRq6WQpTSyvrxmC1j7l63ZqcP78UDNj+AXgyV4acUX3/3qVshbnavDvwjm65HbtJRfaTsyiE8aT1jUPSElrT1bLktPs/3BuInjYV/9A
 OOamc+ei
 XFsv3gOgiZogYVvSrpiKQGNloz5JuPMZ9RGY2qdwJKTSKcIdbpBRIArXeEXSm7RXn7jpTRyMYlcR4FNnV2CrEiitXQ+5Gw/lpjVnoM7jpuU8US83Oxd9svrQUJpSW3Br+xlmq6O+BJO9TSgUTnL7AwMDPfh/sTXSWnwwrnuPFXm5dMfU5lP5OU5bWpsXXFuRl5Xv5cUfwM8Ypa5DBP9uusLTsa5L0bgCKsFFvF/jMnvVVECzYc6IaAYHMEpEutrZluRv6kQ0izjhGGU2FUddPtDxhTWoOv7JphQr/5ssnwROiKlejp414bhg2Y4TClEP4KRjlrh9mPj4lepe3NcTXG43jwO4kbmAxEalAzb+q2mS/K0H/xrcLm42xQScr9C9dzCpnSVRwPmk3IgKM8yqtYHp3Z/d3O/pL3KE6+JkLSXiyC7kJ6HY+TA9VdSe1JcoWZDCAw/ZLVJrJqtSOJOWYv9vfTaNrxXOdkORs266R82hnYzrjRhRgjrn40ORm2ohHdJnGQiT1BriQETtOZQ4n8omO8B7cvlTiDI4FRn3YehZzVoWxX8r3ZvqutxD2n/sPgf70SoT2vs1JtTS1SLvwPbFRhEvqfX2HenQizPB3FKcv8MRBNqopZgvFhU2mykPagRfpazdAQkEEKgf3YaLP55v6SV+V09+c1QVj3bAoqAlo66nJs9roU53PAHXNX8Cz+hjxusZ2qiELESpiH8XPMoLQGbMcmiUj4ml29SyWHYQvdjh4/5efHtJXPgp88lX2xTxItr7B9pC0JVDD7OxLVILNN7xatLWuPpp/RpSel132oiv/dI53ovSyjXDYd7ubP96YBBXbavwnfWT0nLg7hrYwEth0f2Wv3Bmgwdd2sx073lZVrULZUxJXqc7jpBFnhiIeMm5WNIjlDmuTgQayGSF60WOWBskE/k8MqLobhhCgoM6F9rPRyBkrBLGkxWhvdHR+vvilxEeRTKFOIT+HLbF4RDxj
 xaV6Ulb3
 OUBUAC+B+tzo6e/hdtsqOzOJMunBJgxxBJeu9xULL3bUzJcaPA0dsu19nRJ+hOw07zo88M+aiEn4FBCOmUEg2DPazAXtqUo2Piq1/FdD+oXvbaTDyq04KBCI/AZBPWlQP8hsJsD4aJyxm1nVOrilGUIqrEct1Hop8WHjzFwGr+7syIdmgRJf6A5VHHlUVRZcvXAPxpkNMQQ5d+vlMz0CglApc7dXR56rhtgqx6bn9GkoszbYk8ia4VyfQROMj0ln5fFwUaFcNVrlWwasf/uiqR52iZl+QXZmBS4OsH1wpy2PlmASwTjpx5WNoeVeuyfHhKHZzQqhgssUoVj9rw0fJiSBuHIYSVzm/NPaP9hjog9PIktsbDLHaDPk4MWoC+hOFqDGACM3zEO18bkE/7szkndFGZdxQi3ukRA2KBaAhEleRfZ5gsQvp0Blu3STfkfbkNmKDNvA3/6FebIYf6KORIESSHURZK4sfmSPdu9RDw5oM6/xNNDtCWcRmem7O0QD1vFt0if48LIFbfwbEr6YuX2o7bBNvCRf2Yzby1h+T33PRrXJoHaBavb4pk9UHqg79208+RMdUqcfZ58q5I2kpHZgNONxp0lcU0rZeW4bWWhBcc45DzqUANq6D+g0PsTbrNTCkrdQ4z3v23QlzKJCmiHhl4ZNq8HLjXMyQn9UDxjctbv3X76Df/Q7jxrkMLaHbbxwjxpjYSqCodE1BLqGsZyJNEuWfA4nxCcJ958UBuXjIcpSxKFwaQaZXx6NnOYM77WZGxclAYjTXdGM1P0lywzFCa7FVNh3bwAjbxd+bGL25RpukH1LaHVAzDr+WBX3vw5whissoo32O1oGypVM68cPfPgdUnPYYMHhspILYcfyicJqpk+c6O7G+gs5LMjeQQqWLAx5Jz9TXltwiIzErfRVvJqHcHO21M9YpWlV6fgjs2/33DSdSc39zdC5zqOClhjvqyteDA+2Gdn0jGhN5XCnrHgbX
 K2rNw9PY
 dZ6Fj5Oih5H9gEE4an+ecti+/IWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the MIN() and MAX() macros from zstd_internal.h to avoid
duplicate definitions now that the generic MIN() and MAX() macros
are available globally.

This change continues commit 1a251f52cfdc ("minmax: make generic MIN()
and MAX() macros available everywhere") and is required for 5.10.y,
where these macros did not exist in zstd_internal.h when the upstream
change was made.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 lib/zstd/zstd_internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/zstd/zstd_internal.h b/lib/zstd/zstd_internal.h
index dac753397f86..927ed4e8c11c 100644
--- a/lib/zstd/zstd_internal.h
+++ b/lib/zstd/zstd_internal.h
@@ -36,8 +36,6 @@
 /*-*************************************
 *  shared macros
 ***************************************/
-#define MIN(a, b) ((a) < (b) ? (a) : (b))
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define CHECK_F(f)                       \
 	{                                \
 		size_t const errcod = f; \
-- 
2.47.3


