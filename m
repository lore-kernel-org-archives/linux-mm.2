Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FBACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4548E013E; Fri, 19 Sep 2025 06:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4C28E006B; Fri, 19 Sep 2025 06:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C718E013E; Fri, 19 Sep 2025 06:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9AF8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:29:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36DCC140623
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:29:02 +0000 (UTC)
X-FDA: 83905626924.02.A1396C4
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9364120003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:28:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J97I2joT;
	spf=pass (imf29.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqrnOqDkNbMqZtkMy5YftCQnn6xMaPqvu+kQgm+8STI=;
	b=zBhwoSa/aaP0WRR11JWMWDUw8tZpFauQAvPyx9dxQNuzCwmz4AWAYTz3uBQ+DgGvCGcIDm
	xWIO6GW2TN1rHfe5uP/De3/1CoHx92f31U1XGHtutqskaIlIb4q1FCEsMMJYodpkmDfWDq
	utm7BOPulz7H/WcacqXNS8Bi6UUZL3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277740; a=rsa-sha256;
	cv=none;
	b=ddHXwVXn0DyMkI31oDaX5t549jV8Sg9ks5NZQC+1VBVAk+0WgTd7YECaM6sY7Z/tAW8Nt2
	uyuokJrd5TJJTsqVMkfXPlUgO1IvdoP50sCjUzQFzM2x1QPTWSwsp2o/8u5xEXOoF/xWIz
	FjM3FTBf6FrmSd/wGMuwtqhGMa0MCdQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=J97I2joT;
	spf=pass (imf29.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277740; x=1789813740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sqrnOqDkNbMqZtkMy5YftCQnn6xMaPqvu+kQgm+8STI=;
  b=J97I2joTGIVMTFnFdf08mDWTSNFN1g9wAIA6G4qhwrs0ov4rhljgG1z9
   LOEwheewkcq+J4+bSIBS2/SkwPsKRhlhOyD8szJElIGbjApsHO5sr1O7j
   mkI18x6JKdXPu/BsXA+FBOFOF2miIMzrkvK4fbSmrWwtY+iyNZqkO6yg9
   pigXYlS0tVak0E0BJTZIGfjWF4jcE8HPQDCJbN6piRyjOMxvKE6+MEREF
   S05a+qo2yizelUH4EJ2PJc46kEOaoIWSe5GRcS5HAYlnz7++f+pOGUQO0
   wWF+GcW7nsw1rXeAxTf2X5co/DrvG6eUZyHPVbEn2Du03UpqNixZgLL0V
   Q==;
X-CSE-ConnectionGUID: cqb/KGiVTKKXhKRgaf9MbA==
X-CSE-MsgGUID: j4y7YaztQQ+LyE99nrzytw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2267986"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:28:58 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:17725]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id 6445704f-2691-46f2-aa5a-c41a274ddef7; Fri, 19 Sep 2025 10:28:58 +0000 (UTC)
X-Farcaster-Flow-ID: 6445704f-2691-46f2-aa5a-c41a274ddef7
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:28:54 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:28:25 +0000
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
CC: <jonnyc@amazon.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Arnd
 Bergmann" <arnd@kernel.org>, David Laight <David.Laight@aculab.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>
Subject: [PATCH 19/27 5.10.y] minmax: improve macro expansion and type checking
Date: Fri, 19 Sep 2025 10:17:19 +0000
Message-ID: <20250919101727.16152-20-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9364120003
X-Stat-Signature: 8h7jhi4quzaghbi7648qdyesyip8wa5t
X-Rspam-User: 
X-HE-Tag: 1758277739-168321
X-HE-Meta: U2FsdGVkX199xNygFnbtxFjF8PgxrjWUrJlfhp3zWvNxDFIlapi5Aw96GuQLr9FtLFhJX2YuTD5bNGYX1GPgxoSZJCbkwgBdludlStsP4djGjsa5qE8ltbyAlGvJ97t9iLGaUdSibTZV+abDB0PHB5tdzvy98TPDJnlqVxc/iNTWiJlmMWbzW7GSOgru7Yw9kJ1JYgr1786Qz8H4wijD1JZPaS9Yl/wfDTIJpOasBDqrvbM2BxQkFLyt4WoaalYRfUlk1D5w6a/cLT1bNA+/h1ehkxmgj2XJipUj/x2IwXiHzMP8hnmzhvGFYI4ZYbe4Zomi1GBWQKWRtxyDU3sbrAXE33r2RBCG9d+loOIiITNtGwIPtKm5LS1nuBQUsiK4LFcxwDReF5ysxLJAHc1ac+gIXevXzx8Ku4xTa6RukS2F9U2kEvCzpCz7rNFjZljHmYr8m3dcLHP2rOMvFAa+zC0RH+IMx1mcB7rqDsXcxKcN6a1uGDQn2OszYChhd1jW0NawTwEtfMclYu37sCJ33FXPfwHXIbG+R2k+qSTCwtWPAaPipXwW6hFQ0x4HiOr1Kz5cDjl0rJfZP4/S5MO3Q9r6OtXHWVgfEx9rkKzty9V/ByCSFu09OX5+ljQ02/TAKvOCK6Qh4kgJW8Nldoz9/PX1Q82vK4WPG7GxZGiuur1d9gahEV6ZPUh+0v2mHdB96U4yi0WBmzIvd+Tw1FAcZPWsn++Wz1AwN29jQkkMmcuZ/rzqOjB31jOjh4z1EHbGcLBzJABscSEHcGM1XnCgtu0q8ZL+AekFkcZkDKgyFfwY69S1e2vDEdP+txIW3SU+jiQpsvndqyCxvAyv46AnbmRlQZ173Y8pP1wMZkxBKUIdCRf+c5oQ8+r69x911Huby9y/6GlNX1a0fNV99MmyBzP+S/lWNVJm/3lZcX8PoqvtZydiQGZ8VIVa+O1zvgw5j4IR59D72PQ3mDzl9fu
 +bVbAMN+
 dxbYEouWCl/ccTy3taa2H4sP1QF8lHxsiYUdrpNgVOLH25Xfy5xfFkEjuUnB+EU6rweJC95eEhx1X0rfZJRNgVzgqVqJykajK/MPUpPCYO7dKn5tS9ncJOYquhOGcUJa4fORSVc7cONpQrwlz4rudzb+ETmg8XWYbAQzT6kEdtEeqx+PtNeLG/SA12WCw5IzDl/hTlYSPPz/iqWRoEB3Nu5wu68d8pwW+OmgSkyBap3SAzIJxv4b2eR7hy4o273Q77YwlERBBC2GdappZ+gKBAzrNnzv3aLFo/6Em5LUb2krTxAvktalQi/XCYbJM0iB6IN7WpFbAHuGxdxRbfCtiQEGeF7WZmHkgNSJ+20fk1H+YmBZCmPP+FudVkJiVfPuzWZtrh5E6oLnw31G6GBNLU9DMJzvp9MbMZSeOskex2Ozp45Kq8KB1N4AZx3IKnWpflemhXBaL2f5cM9Mz4jp4o+WFdX6O1O5mHgpOheH65ZVu9+KRnWPVeUkNoiwxAjgVa3czHRVZ0eENYNQMGs1CcUWd40r8cDTmCnqjuMu3FcpYAeGYTadl/MTIf80rm5MEg0ZPE2Ga3bkBsRhRhVYmen2DYnTBArNmagTfwsnaaXt4p7L2hsoEnYgo9nK4YDUGFL/bzuv4ZjRZTZSi39WI3/HMwII9kjg/UZ1mNPlNFYd/wryfgtOWHsg/NpYUy7MAA3ZvfYeILZmxEk0Qz9IqJTC2+dEdaKlVeVAMsLmN6Eat1evFNvDLAPIEW/3fslJXw1V5+Z9ptVKpzF64Wrxl1fvoZwPKmILNg+Jn5TmXIzSqaLtBkxLY6VNJO9swm4i/kipo4KoqG7VCtRjy0mmhVFuDwyMU+4B5B+SoADS0njww1blOWXQRslqL1UbC318f8YXdpmVobKPMFn6wW6RHUeaK9tqSU47AwH4yZ/fvJUm8JLjrMkmmyH9c+7h35q8xaZ8oiJ6GNNSUvWMt3Bc1twAVUx1+
 LNXR3puf
 OfRM8hNPVukRU2f0O3Qgsg9VupFYFoQrYtGO+nvL7Yq1ZHXONwDCfOex8/kgMhASE07KVpv74/2t3sPwq3QDOzj1rUPp4IqBgSLmiDt5RzVc/dfT/zPs5sN1fh3y3oqddA4y0gsmjoilRIAgeYVYGZE0iuPnEcpVTEjw9KPiNjoc8sLl0EAMIuJ3Hb5hMLPd6yEaOcIdnrSqKVnqFhv5n1hyA0twl4FsgRE921JvRleDVZTTcsLis0OIRNrfAgbUNjwzDpyBXzVccpSn9YdqLKq7VnHNspR4AqM6thpbaYxLm/A/OKms2I0OXMuIy9rgQP5feJQl8+GN0vNCSc5aXZK3j86PNfy7ZldOuOCePAr6ME/EiHq1510e1Pw6wQdpTNCmawUSqs83MQarjLa9iNK8tVScRTBFoGIk41VHeJscAxFr9N331BdoHKUI+wt4pfwQjFiaHnQd70yR7lJhJwqPx0owhMDNWaaG0i5CgTIZoWcGv5j6+ObVriZxcdY9wdAQWIEx0bFlJC2PufoLJNNAeR92mUHjprsmLICrUp5D58z2IiawEoTJmY4v6jE2K2CpieEYa5Elnh2c0VqoA8/99MpH9n1GhQFfwoWxhz6Zc9uJ6NJj5mtITiwmFa8XNDwWlkmjdH2IjAsvtoZ4V3p9MAK0GPpETRMeXhPZNK9P0jDlWtgnWRJkbtFHZTiMVmMmQcHKHyDTsTk4NAONTvuhzClNBNQSP6GedDOGGn/Xn6C6cA/d7ToeYavzPVJj3+SwC9Hpm6vSb02A1gcRrzK81Ic9lWTx8sTW/Frx5nbJUz9IDR97FRvopy8q9trUyOIoBV5ArWoL6q/JThNaPiIyDgMr8KB62v+pphTFYbasohY4ncGWTiy6x4FYxtnSqGBW/vUzFFwttglo+qoemGcResmsRu/0I14n411mfqfHM3OXRCAtaLmX8SqnIpX69OsLzxX5Ex6KrQx7TOhtTqrrotNn0
 TcwKZ1bW
 SjoMTqNd43TSWICloBX6dJyTwZntikbZXT6pg6faT9S6j1wKXSei4NYiiRI0AwnLsXqrvQ+Kr/qqpXGUc2Vic6WmmckDCgSY7DRAUlpQTWqtLmV5EpMPgEhjSp6QMJRNkFs/GdCH/tXHNbX2wfiYIn4Xd1rDNyZclmfFvOK3C1py1Yp6pM4B1A2Ds41EDkEBe82aWIhlLMVpQRBaBzPAhZ3MeIuSG3ree0HoWuoBBfO6rydnD/9RA6zzt4Ya1m7JkGoRu3s4u83b3dAJuMUf9uopkIW5kjMZ77scamDMS83fDRzwDFUbuocc6UwxvsCoRDlaEEzBnzqFNLCp6cmLIvqvxvKs3cN9bfh65R8F25ht2p6EuFhrPZd1b71A+ImbrGDktJ3EMo0Mb1zU7m96isQaY2fdIcXxcLrw6nnLSHW+d7NW6XZOvNGtFzWI8UstG9xos8ONYkHKZPn3lIwwxFTeMVNuCvQVn6yrPSuNXTwmHl6Qvkt/N7yJE0hYKyKfTOgD3K6LZYSNENO+5O2uJxwoKAmKO4YP9ww5hnfPR/P9KT7+XtnTFGVjI1fgmf/1glTocs/pf96FWN7leh9YqMnh8lmiSZ51DXYKisAq3T5vlrqw0NuCtVORyFxAO+liGlQeb0LUkfvb7jhQy7wJX5M+h83fzLEmxBv4ovDnKvBRoSIUVoEnCFMIK57AUIeE9a/kKOtOW9kh9loXk3p6cU2AgzN5bsHHyXuBhXGhBrJdhTCzsvY6seVrbi21QI2g9mACNp4bstRQcd95m93eXGMIN3MdeCCj6LWNR+EYFIPatDmoW2tyvdZBSLE+pLMitIKDO7b4LYl+mx1KB9mgE/UZiLzXRfKdOZXg+dWW6X+FohFnXX1KLdcAKXOIGlzSsD4Aj9jGnKeuv9C3b8XZScNp9jraDDBgQuH1BhCzcZgzfxgS+TI8FJRbi6FK+6PevcNoVsw0kD23K+qL3jUA4XPrdNo6R
 btky4Q3N
 Rdd42E49rUVLomtaBu5KnsI8k6t4s9VM3WReWPXwYnCbheQgT67zYUkCg0mqm0jFq7QC5Vy2rZXG9t5tDqsAl3zn7uPVw6Tg+FlcDsmh4uK2RCSiCLN8HVLt8EEDrQh3rlMFhaDddEInIS7quTS0UXMfeqpBmKEXS6YqkTLd6xkjc/QEwx7y3Efvh9cBeC5ELA7XsWmgCZCmr88TfU5rxRTyGXMuxILuCvcIm4PigVjd06YGSX2LmvlS2oTdwID7ZtIG9Ei5yCRe++SwR7AOQI9zqiTY00ADIFF3nfITE9ttNkCTmpg8pGii3oEOzD0vuHpB84L64asERQPUJnrnTSqmXaChgIg3pPZWAb+a7+QCgwhpIFDnL2YO94wiiXqBkYmSx8QELCQ0RfvjhB8KGlsRHS35YYdLe7YZNK0No/i3EMUSi93HyocMDsCVRZt4mLu3VyOk1sz6Y92/FZwfc/qzCtttLHNuTDy1X5Sxk/k1kBug6Iojgsg193N/novicEKxJHfi52StTzkwk6IpFnp6ey12n/w+I8DhGb7gCurIwOPFL5eI49WNPslcJ14P5i5H8SWfj1HHAjvkmeVbtYlQdTx1ZBVotBFyj8pwTNa0ONcVfOlq2o3a1dc/AcCi/nXoLpYWOoRq9+HDPoV/C9RWMkudvPXAgfCFlxD9/Dc9PrNO5rl8rMVyjlmiY2Dvc9av3bGrJAzhTCkwmgGcWK+xkX/SiZHIrMjCryWDOGaQ11fqhY+SMwhMxImP4NN8ApmigkbIbGlcQnBAfsgtiQxB85ztfWNx1e49JLCVUpfrMy5tDh+klnE2Rip5ZeyfT2Mirk+uh+j3nWaKsYeFNRRXsBJ6E66nz1tGljn1vXE+721q1bE43YwMgVdtPENQ9dohdrT4U9lO92IItuc0oY+JqXmhX0Nmeawh4eGUGa9ck4lAMstCrJLC/q2A7EaQImBAPX38kjIx/rOzJTJ7H4loB2+F3
 FG+g88GV
 sbxO03HjyPCvBZLK0qY8Sg9dimjDG9/Cjy3lAG2tthb2bG9xeusRCeDWM6cfqKsBfvukpaHZlJ4wUmogRR/LtCBzedOmIRJqom3FMyPHqIYezNrR/sAP3JATVKsitrn9+ImxfpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 22f5468731491e53356ba7c028f0fdea20b18e2c ]

This clarifies the rules for min()/max()/clamp() type checking and makes
them a much more efficient macro expansion.

In particular, we now look at the type and range of the inputs to see
whether they work together, generating a mask of acceptable comparisons,
and then just verifying that the inputs have a shared case:

 - an expression with a signed type can be used for
    (1) signed comparisons
    (2) unsigned comparisons if it is statically known to have a
        non-negative value

 - an expression with an unsigned type can be used for
    (3) unsigned comparison
    (4) signed comparisons if the type is smaller than 'int' and thus
        the C integer promotion rules will make it signed anyway

Here rule (1) and (3) are obvious, and rule (2) is important in order to
allow obvious trivial constants to be used together with unsigned
values.

Rule (4) is not necessarily a good idea, but matches what we used to do,
and we have extant cases of this situation in the kernel.  Notably with
bcachefs having an expression like

	min(bch2_bucket_sectors_dirty(a), ca->mi.bucket_size)

where bch2_bucket_sectors_dirty() returns an 's64', and
'ca->mi.bucket_size' is of type 'u16'.

Technically that bcachefs comparison is clearly sensible on a C type
level, because the 'u16' will go through the normal C integer promotion,
and become 'int', and then we're comparing two signed values and
everything looks sane.

However, it's not entirely clear that a 'min(s64,u16)' operation makes a
lot of conceptual sense, and it's possible that we will remove rule (4).
After all, the _reason_ we have these complicated type checks is exactly
that the C type promotion rules are not very intuitive.

But at least for now the rule is in place for backwards compatibility.

Also note that rule (2) existed before, but is hugely relaxed by this
commit.  It used to be true only for the simplest compile-time
non-negative integer constants.  The new macro model will allow cases
where the compiler can trivially see that an expression is non-negative
even if it isn't necessarily a constant.

For example, the amdgpu driver does

	min_t(size_t, sizeof(fru_info->serial), pia[addr] & 0x3F));

because our old 'min()' macro would see that 'pia[addr] & 0x3F' is of
type 'int' and clearly not a C constant expression, so doing a 'min()'
with a 'size_t' is a signedness violation.

Our new 'min()' macro still sees that 'pia[addr] & 0x3F' is of type
'int', but is smart enough to also see that it is clearly non-negative,
and thus would allow that case without any complaints.

Cc: Arnd Bergmann <arnd@kernel.org>
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/compiler.h |  9 +++++
 include/linux/minmax.h   | 74 ++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 004a030d5ad2..28b21e372751 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -251,6 +251,15 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define is_signed_type(type) (((type)(-1)) < (__force type)1)
 
+/*
+ * Useful shorthand for "is this condition known at compile-time?"
+ *
+ * Note that the condition may involve non-constant values,
+ * but the compiler may know enough about the details of the
+ * values to determine that the condition is statically true.
+ */
+#define statically_true(x) (__builtin_constant_p(x) && (x))
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index e3e4353df983..41da6f85a407 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,19 +26,63 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-/* is_signed_type() isn't a constexpr for pointer types */
-#define __is_signed(x) 								\
-	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
-		is_signed_type(typeof(x)), 0)
+/*
+ * __sign_use for integer expressions:
+ *   bit #0 set if ok for unsigned comparisons
+ *   bit #1 set if ok for signed comparisons
+ *
+ * In particular, statically non-negative signed integer
+ * expressions are ok for both.
+ *
+ * NOTE! Unsigned types smaller than 'int' are implicitly
+ * converted to 'int' in expressions, and are accepted for
+ * signed conversions for now. This is debatable.
+ *
+ * Note that 'x' is the original expression, and 'ux' is
+ * the unique variable that contains the value.
+ *
+ * We use 'ux' for pure type checking, and 'x' for when
+ * we need to look at the value (but without evaluating
+ * it for side effects! Careful to only ever evaluate it
+ * with sizeof() or __builtin_constant_p() etc).
+ *
+ * Pointers end up being checked by the normal C type
+ * rules at the actual comparison, and these expressions
+ * only need to be careful to not cause warnings for
+ * pointer use.
+ */
+#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
+#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
+#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
+	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+
+/*
+ * To avoid warnings about casting pointers to integers
+ * of different sizes, we need that special sign type.
+ *
+ * On 64-bit we can just always use 'long', since any
+ * integer or pointer type can just be cast to that.
+ *
+ * This does not work for 128-bit signed integers since
+ * the cast would truncate them, but we do not use s128
+ * types in the kernel (we do use 'u128', but they will
+ * be handled by the !is_signed_type() case).
+ *
+ * NOTE! The cast is there only to avoid any warnings
+ * from when values that aren't signed integer types.
+ */
+#ifdef CONFIG_64BIT
+  #define __signed_type(ux) long
+#else
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+#endif
+#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
 
-/* True for a non-negative signed int constant */
-#define __is_noneg_int(x)	\
-	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+#define __types_ok(x,y,ux,uy) \
+	(__sign_use(x,ux) & __sign_use(y,uy))
 
-#define __types_ok(x, y, ux, uy) 				\
-	(__is_signed(ux) == __is_signed(uy) ||			\
-	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
-	 __is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok3(x,y,z,ux,uy,uz) \
+	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -53,8 +97,8 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	static_assert(__types_ok(x, y, ux, uy),		\
-		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
 #define __careful_cmp(op, x, y) \
@@ -70,8 +114,8 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
 #define __careful_clamp(val, lo, hi) \
-- 
2.47.3


