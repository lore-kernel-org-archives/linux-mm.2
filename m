Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA0CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4938E00B7; Fri, 19 Sep 2025 06:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA5A8E006B; Fri, 19 Sep 2025 06:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0818E00B7; Fri, 19 Sep 2025 06:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9738E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:21:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBAF61DFA39
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:21:25 +0000 (UTC)
X-FDA: 83905607730.06.024D281
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87C58A000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:21:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HTcznYKl;
	spf=pass (imf15.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAlxXvtF6wZ1RF0/zktk6f5ZtKHAgPghtBG8hJeCJz4=;
	b=QYVpO7Tv4EtyV/UTu+qb2eCePw3G8E2gAvhBgsVbL4iDLCkUC7Moy2mdl+nHBG7od+9cHr
	IaV0Sa/7LQQal2fe9LP1ShHRMyMMMtkB2bUw+UQtD/gJIVFJn86xB77ZaZnOXcpH+iWAYT
	uQNPvj7HrxflB8ZWVeFUCR5ZaFJFw2w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=HTcznYKl;
	spf=pass (imf15.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277283; a=rsa-sha256;
	cv=none;
	b=odYuSFVFd4ilwGi6CNfV1m++2hxPg9yUfOhKyZcEif9+jXu2vIJXUIZZNTkEQEGWnj3ElZ
	mAohnjRlv9gYyh1zD4vkewUL5OcOCwO9abCrQTVAacFBFXxo+mkkYkTdklGn3uxEvcSw8n
	zl9qrsj+moj2ahmb1zTVBALsYGJ/lWI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277283; x=1789813283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAlxXvtF6wZ1RF0/zktk6f5ZtKHAgPghtBG8hJeCJz4=;
  b=HTcznYKllAdl/WPI4o6ItJYSFw5SxC9F1Im7IwpSY2/rTdo/a6lAJvK1
   vxBSPyYUYqNxCdBKknxdjsvbvsdkUXW0dVFMPqikG8OiPxe9cP5gK0NdY
   PoDwTuWSrLza5t6C1tnIXzQeW4Ymw4bbSXdErgpzC5tgbu666/Dtoxj73
   dOt+seLsMFwrbf+l6uMm5oCcPFpcmb/OAoybSRD/y5FKRMAGKTi2eVrMc
   rwkPKH8oIYOXEG2kBPTUzMJn3q28LCv0+CdcSot49S0revl9WUWc1LyGW
   EcJfwcjpAkPAqZazHCRwUGv0Jsmqs1s1aa2gQpQuFmSRT8KT63h3ubQ1q
   Q==;
X-CSE-ConnectionGUID: 9PQmffjpTFKSiqWLn5sVCw==
X-CSE-MsgGUID: 0Ga1lrCYS1OZrMj5GbzyPw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2262984"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:21:13 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:24821]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id 2ca2afb6-28f8-48e1-be6d-282feb564393; Fri, 19 Sep 2025 10:21:13 +0000 (UTC)
X-Farcaster-Flow-ID: 2ca2afb6-28f8-48e1-be6d-282feb564393
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:21:00 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:20:32 +0000
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
CC: <jonnyc@amazon.com>, Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 05/27 5.10.y] minmax: Introduce {min,max}_array()
Date: Fri, 19 Sep 2025 10:17:05 +0000
Message-ID: <20250919101727.16152-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA004.ant.amazon.com (10.13.139.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: xe1ft9pgaa6uiju9einomaze7dns6ntk
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C58A000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758277283-330196
X-HE-Meta: U2FsdGVkX19qIEH53giahk9ihP+9RRcjQ9o81olTporzdbTtf3xe5ilw87AsDXGELypf0xKfIb5ohpVqqVQYQus8rJ+hwkGabxiGcEmhapY701IWPvvrab7dSkMBn6pLtCCPIiJH+NFvA4gvtIjA0vjx3SmqnVD0DE9Uvz2KYrQ0ExW8m/nbjeKJFK1wCvF75IADjKsYMYYS1UvI+6Ri0XYM3q3PZGk/th6UoL9QPY6qJO3vTLIxzunBvGwbC2SY3+zar1cRuZDCEwrat9Kas/A/qZIWcCvQ/QJe0q68oOO7Q8a/0500Ky3JKdmxVnhVFhVnENSGQEorkf9WHL8aZkjXUlGT+yN/lMI5nEnTO8dm7xI6zJ4tNkSaJR+eXCEnDz9KjfrgouZL8gnG2Z0iq2adim7uKYoifrnMgAyYuqHQlNB3XT74odRmv+nRkVHEmy71coylgFe28rbjybJZpoPQFVA2bpqkUAUEu9vGN3b8Z+IollNL2tkfOTnDUYiWPm4PDGG2k95oD5yjO6sjxrbawFBO09p+ma72NbMw607i9h4pU87gw+jIiXxscawZpoH6uHLWiVGBQeEM2e0x2KyxIaEPCbju2mfQZgHvdIxG/F12VWxA02UJQBtdsJBTtQVEawKF9FjekKTxtC/lSwvnX0GXRcMchTn+Iy4/JBiw//Skh0LikfOB0Llq7RqeIad4vzF1WWnMz604bG4kPs/5OAcxP+CZU4dV5jtFNp/8hAM1md9kH7FI4IugOD2sOwbsGc2Qy3BZnINEXdnVz/0Pz4eGQrC5Lso43dAm/ObiG4m2U63H8ICrg3EDsfcRiIpjN15lTiuxamBOQucepay/FWoVOhnzWXhF/ukqgztj9d31DuIwQo8DILeXTbGSgCoCo3JTPoXOeD6CpQZ9Q7p8LsH4HmzCMPCEVKJgZYpl1AU+yaM9odQTBUb/Vwo5/nMc8RrmGM7MPMW8nB5
 TfLgkNqG
 Y4XDmb+V+LCtfznLdtKRx/NH8KLic4UlDmPrwqh1omiLTF26IEv4ZnbIE3hWNSx0b+bRdmubhTyY8wTLhBT64FGgy+39qq8ZIm4J+//MqCL+Jfyf0898wffLw4DxdK2p8e3A1IIYHyBmA1eJduip4vWZtnaLb9BHwZSoaM8mlz1oKZqhpGwWeWHIxF/cSpmARexMxGwkfS7Nnpqf5GJYPDt7ufLvy5Zf5b0ht4QKvO5aT6OEUdqC4BPi/FtNQRepd4FapDV73tEPQ6NsH9X/qHx0a8882gN+4W0CsYZhAGAvQsE56hFibja34r277YETuswkiaGwiXaKGXdEkQYV+V/a6Mv53uZrij8YVorxSajYIcm7LBfPuMeR7Bfu4sj78h9Nd/Np8YPwLuh/0XvsY0QfL3QjLyYNcD05XV0eFkfSzCZRQVJqqLXYDprL0Js7KwQECv1kWai8YOwO7siyZpw8De4kif2x2ixsd4+U/CEWhbTFQxDF/HJZ7RdGyaudwujL0NIDhFcWzW7adyQgm6d+zW7iRO2e3gmeWizHiOYIfvnBc2jQi22uyaJu8uRMqtDOft8HrV2xAWUJTgjlGwqn8wPVyzsYqVd8tTaNHyQmxCyao6uHEyXF81h/UouXJO8strdjDyN2P/tCxBiGBzzLsD5Mb0VRG8pBUIxTkFwJvhA3tnogkC3zK49VP8QWUPPx0AEzekAXyYwzOzAoem/hsluTJSVF1IrQZX//5dewhp2sBQ8A5sn0W66jNWveVWiv5qwMYVntK0yvXwyTpNSaevuVXtYxECGmdrkRHw5+Spo263cxiAN1NBaG32HekjQx/UjuzzoryeZqeTZHc4LisQV/qASjt3WkDAMmIkCcwlu1ulkbPUdLZMbAuuZpxxcx210gXgLukdkgevCTftNEXZrEoRRXKyhmT/1vWj1UqLL4N461fHPO9iVd06DqYp2lnV87fZ2IIv2/4ZvAMdZ5M5S6o
 BazJ87Ri
 A8lYINtuHHHYH7y+3+B9/x9Msz0lXD0/6fR6rECK8Pv0AGwIFWOnST5HWEt4eEWzq7XlGNkdgCXCesLsSVsH3QRgcf+GYFPZEV2ySzqx5Z3d/Qh8if8jXz8sIJQPo77grEUH3upYhSI91v1AsiCofsbd6Vw+gnXlTXCzQkpyZYGoBM/Ccwdt2jFYFfsNwghG8xwhm0PV6lUp/UREyEHrXnInsZL0TJZmW1uiiDPw6mQmngElNfNcRrj+F6wMni5dB0fP6DltbpFPNdcG15+Pbmc/bt/cbzMJoPxKQwtkBPLFK5fU6wg6s5RhdY+sWJhSY1UjWEj80OpHxmnhxe7VCdSMH3y5kziVPAW12ByGkAaKsXChJJ1/28w1SsRGkzPD2dyXK9Pidy6AuBT8yKazGQIpohoILiRbNfngRWw583TETzpZF3JHsiJ1eAstnbpzRURXGpV4+eTMMX63+DiNfznEn9u62Fsor0u5kAUT2ZdfmI9gWbij/M+8E8Jh04lckw7GsPEfFnxr/T4jXg44DspiAq0+SUS0qCvGj0thr9/Re4mOKHzfLOqVtJWO2hfLtUarOG7SQbzt9W5ck4x0suceCV3HPsRq2vPxAnlCWjeVtsduUsmtP4mBEtweuQAW0d1TcwAM5Bx+s2VmDoReyUYVZm8hkotomp14e8ccJSz48l5vMFPD3f38NI/IeON6JCamWa9TWN4AsZWBq97Bth8V9aSwA5rSiYJAQwWPQAEZv3Awme3f+y2XrJiolKJaWQnfRHXY8YO0pT0S3MfdjjheyHskLcETKDBFd5OQ2mqWoobZS+Fje05v8FZk36L0lOotHRfVdb8PyUxFcGUfkPDBMFfhmDuQ6jo5LW0ms5Xd+E9+dmtx0CzciLYUJK3119juoiptV1KpbAtYA1KUIX0RLL9jWq795quUULzVHLe2Y2xKp4KLK1LY2RPOn6lq6pA6MSiwgLWx8bYU287w4NCJc9U3N
 5rPhE7g1
 MBnJ4VE6vgYttVMPrrtTjGiCTtKHHAK8Qaael45IiS0BsQe7YbjiiLXe0HGMG4vy0rklpM2s9rE14A3NGceA20K5+8QaSBBezxLZ5s6VrT4ND+pBBnd0V9Db8BHIMu9n3wSR6yLJelvjkmr1x3BmrZgbu5a+U+5I4T1cin2BW+5Ef/Bovo6mDZAH6LQOFn3fyqxncurdlBOo6wyPt4/3QixWKt9c/Kaf4wquDGjqx88/uPYMBj0B3bBRZFD57sKFXrG3JFfrZfGi1gaeodqP6p1uhkYbSIIADBfgg7tGCqkk1QIWaE9TXfivDuubB3I6/PwOxR+A+Ta0OoDfjviA2RBDPTXp5M0hT1oJBl6yMhC1hnFgmv9ckX4bzhxyak5qGrke4ZK/dbI5krIeJiOmt8Q+8FElTGOzn7s2VfSu4ojt+I+zWt8k3pyHPa8Xv06N+QPlpH+brfCcTg0Q9iPoRgkAqzUPXRNmS8jMoDtqkfa4rjPtr0NMvmpApMrH17b22yRd11U7zr/kPnXIB7Uikcvi6aV9w7bXguSx19Bn5hGrJI0cjnYRqonqQFQ+pvSgOpi9Xs6NAKhjRt38bIaIfQ7OfJitPnrQYof3H9/GwBEWBGY2hQRtTWENNHI8R6DWJ5MrNFAgsZ78X6NCMcC+oMRGY8/HeOwJgwIsEbe3ZxisL0gyNz51Ip5eXgif213ABxKAD/CO99k+eGKuxGEe9hIDF4gc4VxEAy2yiP6w9wK42UgQZwdQt3xQj8YAZfc6qFUA5uSdF7jjv/2qs1YlSqGwPEWhkVOn4BwTdW24ChHW1BknHCLOXrceBN3V6HeCB5Tx5Ix294EoVgwiKiD25PMvfNrTmA934F+babSIVzIRG3/hvPt7ONaYVLZCT5tScq1B6YaSVkxcvf1c2Aj5F404aqe7iYaPBPTzUzpOOS1DIco/pVjQrf3iNGwxOXon22NchWJyOpsuD9hf1r4GHKNYBO0ht
 zxohoVjQ
 fHswEEhh/fn/DpUp2buI5ntObfqSOBllwalDwmyByHGhihfj114fJ3/PZvoqIfcG7/5Dx1mo+l55geZOiwsXoWc1AV13UqZKBqyonmZBaI+II0E+jr68Ccr35i05VgDlbi3KzzE1V6wbult3FUH1OW3O6qBJ2daUsSkkOTWVEHnjDOIZWJZC5LZe9pdjdAagt1FF8AoMXOvipFNjNkU8dD6hQOx3bD39J+dAIBFiNPQiK8YK3+tUZWApsIO6NbFL+ALjZKP4lRsH86TVNfQ4uHVR4+S+4gNqu5Cy2GzPFGkekprkjif/UVE/0pAPWnbFkFtfxPnSLh9FTIyTZk3GeoM+cgyLE2ybwMgeOIzesjt6X5rOakSoNlZds5qxR4vHXjLKBtyjXhJn83I1HVgdQRztduMFUir0EtGprDnEMQeTC4eVJl77Eso7Lcmi5Ex/8Fdidst6Ipq0IdMDaSANP/SP30MnJTnk8UmhARpMe+58weaGM+AdDkaeirDjcQWg3r0Ie5qxXSMS6gB+biDAdmOCJpwnQMby9xLJAU6gXTx39iiyG/podO2QMmqAvHfFJ7DTwEK5PrfBnegJntd4ugJkdz0W69hzjYhz6cOc7GLpWGlqLC0OGBEUhh+T6j+hDccMyIxvAMlEBGd47MQK7c+Fb4RBZwqpz0M5qiDPu4jT10XPgP5eyT+vVmrPMi73PBfDF0SHp3bD+VBqug0HoyjwFoufCrRn/m7e6iGzlTJaNyr6TNSjn1eRWUArEOPd/SQAbTy0PA+z80mMUdxE51fJe2yU4rYAVnK+fKa2rj35ahdYOHEpHxuUdnQVGgs/0c2O8QgP3tSZIPIuPZmyvblykJ2+w7AEWzIrVftnYzHfF89+zesuDZgHri0cJa4KCeKyXe/9wxS9rR6cPBK7RbQMFHpZo0sqhYHTw6sq9mmDab7uDrYeGr13YZFMuXa1PmJ91rL3mY0M5XdZM4WdsVdrU+6Cv
 BpwV9bCS
 1Che+8CkkFWn+FzA8GdQTAopGg085v1boJzSL0dLqFSqxgUPTsbd+On+73i0NJK+BZp/uAwGAZco0QtFpefkunuCNSDQVFF0pHj3YPOfBRmsy1UtTHjmj80tBaoYq+Uo6nHN35vE/I/grp2yp3yyead2kSdtEnBRaT8f7okZ2T2PV0/3nAqquBZAr4mVA6v8T034pMbGUJ+hHfGtAUcUlEB6E4cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 7affadcb2a29..0e89c78810f6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -151,6 +151,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
-- 
2.47.3


