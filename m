Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A74CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC5E8E0107; Fri, 19 Sep 2025 06:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2BF8E006B; Fri, 19 Sep 2025 06:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8C28E0107; Fri, 19 Sep 2025 06:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3DE8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:24:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60F7014063F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:24:26 +0000 (UTC)
X-FDA: 83905615332.10.02254B4
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05318180006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:24:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VKyu1eSp;
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Up26bfkjgG7bBpXTUDNOne3Gaz9xL27H6G5Ic5zP1jo=;
	b=YMcK+qxYMeHe35LEV0SPkVFyi0zv7Vc+35uvkczcpz7e2VhoZDK9hFyynnBkHxzPifjrCS
	kZsOQq/kPSAkXRfQx0Ofof+qL3mUAnVNhDx6al6UVio6FPJ3K4JV+UkqPbYGngluhtd78g
	M7vTnEnXYmQV/G9ZQ3d4X/HyNzzn2Ko=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VKyu1eSp;
	spf=pass (imf16.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277464; a=rsa-sha256;
	cv=none;
	b=TqnKe5fHpW8Z2wQmBvEd6cE3g4cxvhrLgjSv7W98maq3WdeV+YHclX7f+m0J5ix/p1Y8s+
	LdhJyBTniXGKmyCRfznEUVCz41UJjU2gykja/5Rnp2KI9EYNC9F4Xyy1uiUqtcqMqUhrLs
	gGx+W+enylBBjQUrdwIGYo0vGoNfptg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277464; x=1789813464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Up26bfkjgG7bBpXTUDNOne3Gaz9xL27H6G5Ic5zP1jo=;
  b=VKyu1eSp6PIFIEIDHbRkeA5t0A2XFC8OX8RJqkyc+J8NGunqxHT7WHru
   bSRo3xtZUP3zO3LPS6DdIzV/2WSWilO+vaJhmcX3u+X5F4iiZ2AwojvMe
   ZEFcD1OQ3xuSMgiNUCC3tVOQPz3vrRX0I4DWVT44JbNj/9F1/T0j+OY+L
   r20wGkKxADNcNnBf6P5Os5epmbZXfKz5Y3fWPVKaCjuxSLIYcYo2EaTjz
   pehK2MHY6+0aJO0+A6mgdQvsvQGm4fuiLLX8quGd7ZYBgFQdaIRG96g/b
   xWogetWrZ+mntDuvxDCFv7cfBBkaKG8wsipthFg6ksMZD2hWw82c5RVCl
   w==;
X-CSE-ConnectionGUID: VfUMBUH0R+udyi3y5h9lpA==
X-CSE-MsgGUID: fEXY14+oTR2Ji22+/AcC7g==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2371767"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:24:22 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:21608]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id 504dbbff-7d1b-49bf-9922-7914909fe636; Fri, 19 Sep 2025 10:24:22 +0000 (UTC)
X-Farcaster-Flow-ID: 504dbbff-7d1b-49bf-9922-7914909fe636
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:24:18 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:23:50 +0000
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
CC: <jonnyc@amazon.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH 11/27 5.10.y] minmax: relax check to allow comparison between unsigned arguments and signed constants
Date: Fri, 19 Sep 2025 10:17:11 +0000
Message-ID: <20250919101727.16152-12-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 05318180006
X-Stat-Signature: jrksc879g6jwcdbq51yw7hfjn4twkmjn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758277463-55761
X-HE-Meta: U2FsdGVkX18yrhIhBpSP+pSl1VS7szg9+O+b/9u9Vebr+tuUru2Irm4U9pvfd/48HMNFTcZZK421bdEADZt698XgebTVnTycn79Ud844PTMUw9DZFHbyg9s5TSRh66O64QHeTgSQ/LzA8Y0bQG7CH8g04DKE9z/H2bHFIyEfk/ADHY2Mkp75IUuaW8x/aBc2otTt8n8XcEFi3W85kzYgYHIQg5/5jx/TdMuRzT3V+6pXO9FB4d/OCzhe53dB5NP0uHny5LnOcYgreW7PWdW3VgDgwiISOm1OnIwKo+gxfjBXY4N6HOjiNI38J1V/VFHt2451LcmZIiBeT4g0vlGjwfOG2xrR9sBc3Jgf5kJJjHyb4bPfrYR3D8TY+Bh5GPCOlegeAsbC8h8K2kf2Up8CsJbu8OB/r+dOnFOabFRe6KK37rtr8g+MCR+GzkMloGTolwuFahxDDUnjoC1ivRaEzkl+ehWyGfeh5qffLxyXDCt3rJp7GwmuTbj8NyrrXAI+m3VNYciOMUfCdZYi3PrkGoyseyQOVkylYYgVs7S9ozgeM168hzw5n1K74S/dHNH1pwrP/tCp3hlIgy3npBVX0qOYBVN+GiAWWDCh+0xkmY47KTLCHafHodjfbftfOBr+4lmrfpSSW5exnPUbBXv+dQqaZX/LdOQYrX81sbzwS7qbisKJwWaiaLjpdrrLBCU3RqdVul8BuvSGlb5QNdzDg261do4UMj9fgLagQ6a0UG2RC1aeMmRgxsKPY5ibPIARV1gL5W0FczPhQatnw8NXpj4uN1FyZNm/msMzTexMmmxVghZ/4FLsQFW8pxISAPGBXg70wqAv4KcrLG8NYWUmzfmUHIFwZj41xcbhlPCRYNyfxwlD1x2lzCZ1dEA4fAuO2JXaQkZ7oV1plmblekldIl1vuoXT4a03n20Ex4Kpo6/dhPAiwHY4Fye6wXKq48bMBWSQVM7lb4AqzkqGg2h
 Cw1pJesJ
 9gg9ABl6LtoAadLN6mbGoqBj6QxavvR8K073z49cpxMVQbTHWhj8tcXkuXKYyIQ7lohVwreXDEpJ9IAhSaxM+dqxZYTn/jcyk7ejtGLGYvhgd9Gvrqpxl2AMVs5k2eW9W2cBODKuFE+YD1ao+2pgV4gNTdtIcv3qkCTfl8n30Q1lV0qtDR+ko/kOtTueKESKTMZIyN583X4z8QflohXvszUv9zvrTbfmk53frT0sNhl8yzIZd1wIjfwmHagRwBu5QfAnKnZUylngh1oS6u+uzTe8wfTPBO6zMCtj7e1jHb4bNUpOZHZ0bX9f5GGJX3fn0/HAuiUMoSr4NrjtmqdTqY+9EQRpSKx0pu55OG5E9vwmfkdyG6Af6le2FGYiUrHKWhI8+YN2HgXP0WDHvAFwADexLYbupa2haP9V4vWRwv3F3tLiAyPvJ2Ro3II70PyP2Oefg7Ghs8yD30m9J+Ex96mZngDoEayJ0St+jAUCcV8r9o1KUakYn8SpRX7jeqI2vpKeK5lejaGbYo/GUlQ/Q1O4gda1C5MJBvC/l2envwPRn/+lX2SDFAvfWiuJOI+nhIkjJCrdk/s8k9kr8USKjG411WyGnlhywON+tVIWtnoi3AgMkkKalj0vTNtSS9WLbI4ILbIiGyw3lGl0gYr5Q0r43mahNuWrruJ/yEk0HeRz6DwoOOt5tE5J/51LBd0WjJvVdSrN4a3eTsyKa9DmA5FRNf2Lk4irjR0WfbJbCyA2D4UnZrtW66PBENMSrRPqsVuH+4zAMA2ytfKFAQIb/D4lMTef/eqbwmLEj7+151GgS4meAIzNktU5ebc/holsw7Di61KeWZj/aQ1mXSlqZ46e/kdQtJGNaMva2mSE+Z7ye5bOpH0zOyDlvnuFIh8t5nOTsH9VGEZGz2qGJjN4D8t8m7ZHRaHjrQ7akedUDkZVZFWOOEmZt/IPFIOSaMrMIplWTH58D5+zIJxXfVIUf1fj0LTH0
 B2eVcRcc
 0+gMm+9fZVVjeh4l9loObORla5/Vx1b38NFtg2lUEKJy7sQdwyVVB9M6GLuC1KgzdS2raF95iS06KQXFkQzhKpJNDhDiyTJKM/ezPiy4jKFwK+as9B0614bECV/LHLUMIwETTw5hwRmosJJe03LL40KcysIn+CgH0kopTmKhIxpWxdLtKiN/meQOYQOZl0+ruySaTpq3UFjW8u+pMQx/q823VU6IIVuyWBtnPt3jqXDpjrIpsbJM4rawkU3+chdy3X+MH7T6M29q5wGbKrRIHFevM84gBrf+qnTrGpbb/J1IqVcAVW2f3GsAC9e0QMXDLBvRZXnLfC2dvtiKdq9+cvO1hwiKSxtYXWFegOebRGroOkRoMAIKcQKMCtw8iYHWAEGffd+eCxEKEpzbHV8mtpybGGdYT5gqoAUiwXYHkMJT4wErjqXi7eewE4oob8hKVpASyc6ROvTWuj62Rnkn/ZdLaIO+SjH262eYGSCcOHQ/mjMbKnGth/ceVz2epQg+nAeUXDZmgckppH4fFthQ+ADDpxezK65dM329O8n7sXKdgGoL/VF+c/I0crPt7+DoTICfXcpEBxXZPcH0/XyZoB42molGzd9U0T8FmDOPI88x7Q7ofD692ZuAHYCeAcHWtFQSARH3aNW/xTjjT7D5DITXqa6clUP3oCk/jdHqYTOBfs7j/ZLZtwFWW2hMWw1uvEfQ6eJyAHLca62l03IObD36Lw/BpaFUl9RIRCl6Ibuh+9XGNY4r2r9/5vX2cQ98RVMlt+b4t4bS5hmeYe2s/fj5rtMwyfQwmJqR4W0gx9l3BqkkaitVImVSPvXccEpv1u24c8P5Cf44B/iho5X4mFL5VTeI/AKT/0M02ocHnt9N86KHlicjOSo0DsDnJJ6wCQLDKWoaX2nFl2d4siiL8R/qvnqr9QYuxjWr3E805f+o4ZFUcUQMkY+4LPps3GBV2rmxW903kS72vb6HNIZkw7s9/HCgN
 qvR1nTg1
 2YZ3LkqSNBylzr2emylIkT/UM0lNNNjbhs6rT7W4fxX2qtGOPNwfgKPc2sA/QZs3aTTdZSwULK+dxk4QoASzeQg6tjR+oTamT3hfyS2/jBIzlm98HyUEEC5PKBaXMK/CytSJyps13J9gTW43v3ww7DOoH+qzVIseVLEEiBP3j2CrDErI4olFsk0k6nUrkaf0GSXCYRgHd87vk3lLuPsvI33V2yxMFtxLTub2PL9YRQpKgkWNvPkDNDgHdOO4NcjnqAK8S8RZ6OiVFGtXyHEmiryh3lF2FXXBHMHyCKI1EovxniMnu+GRMCILNED8sgS8mhRv0lxeq7Ct70W+W150B4OOlyLwmSIAD6PYX+QEUYzozrn7BlGkjOyDR27VAdQ+jgwkrXuGsMGmHVBlAusUywRxRW0VCAeRRN+9GZKBFZlbLDB3mIA87o0LNpX4jJFIjul1Yqy7IqNRzcM0DpI9XLLVNwrZ+ZGYVFR4hbgEQco+elbsSd8Q6qvZy+EJwOxFJ9iW6R9WzAsJPiDTcniIgjWqaUHjQLVg0y3Gjqg5ZaTESjkqIvQKcPPgdhHeAI0uNTpP14RxSEXN/OXR1ExNtgZzrAxjPzuzhGBU6wTFbal1mB+6SQvgTs2RqamL1kgnuR9zaU+rBMLS+zJVVpOcMwCs9vqT6dB85sCNNxGdELfdaZKLvXBdmBxcobYUwjNv7YrtpqJ9Nj8eerMAOYc2U+wIz3GtHXZBvdukWZEAI7NhsuigWCd3KpBnT14XMAib0GMqdBShAbZe8zzS3fn/vulAPQkAt1Z54KjsLFAjTCzPCcVcrpvLqUilwisXxtPZhcKm4aS27qGjBvYIYUi7CeVRKHhdV/2yPbHGb93bZdkdfjfYsRQY27Mch7PNKOnLVFu97BIF5xzpoHVbXs/copwxr9RBsK7xvJ5QNMrCGhjxmkrVpX22WWLk7WTTmBRodlXKCsErxB4XqN24nbwy14yh6ExLB
 TptOZbpY
 3rKGOl7Hy07JMi94noRyaxA34b2yCN/nIMQ8H5OqKJcYFGHCRnfKf/CAw/P6XHt6KLg2L57GQVNJ8o9OOV3jbppecSA6xCFhKVqMZr6gHsGhDvB6+fW6Dmhk1k4O+gSODlap3Ypm8b4IPJt8zjwJAeMXsTIyG+SkVDNaK/FrGnkkQ+a1bSZ1o/Iot4NiEQSMjeswPOBIJk4uh438Afp3yLkVIxxTq4v8wuMyXdhGASA9ZHEjepghqm5WnSZqB3qMk5opcs3XHoKR6k9DNB5Z03PQu61N9xdfGlsEdp90qBRAStMsKvFCvJsiyRi6H+4xVUntT19DDYJUfFArFBxlMd5I500ZqLcfyTi46xFYzrlUcb21cM+zF5AduW8ku7WSwVRPF2no+Y4DkeDq9nnNEgIBSaOQ7yXIMFIpxDdMHLyKBv7UbgQswPmolJpQzth6Zce8wBtzMW5SAZmFwRYQ7GW6LersZWomgRBVM6QzAohNCZKr9ChMKZ/7Ov3rA4by9tZwGykKZBqxYNV5aiIGD7hjakSzfynuJtjgBRd6SB2Y8cBmIpG5rs0LiUCxf42FWXyqKebPW+MeccPfGZv4vB5CXOwlL2xn1HM6k7A5zQolLlP4ZX69fy8tI/md6fjziPpC4xpsaruv515FJZeU4B/gYdeYh+gIoBP34naACA4yKyWEjgNUMw2qywgfV5KUs5ygUZgUtta6wHEgsjOO+MYKXzfHqYjHe3+vuMmRE/Wk+9L+0mvp5Z8TXQdBAnmI/8/jKNMADrxyvk1BvBSg0arwMB6OA1Z33b7kvurlU1MCc4IUdg1NMlmiph7VZ2IgABwM0V61rr3yktGgWwuNor6xZ6ai1YY5FKXGUD9YU204jpqYAohpCwGYAzMpVrlwSyDmYH3Ak2BvbKCRtp83Bl+AIf84NZ9OSIlIdFNXDh/ASXydefkWCQHrRIiTbuWlPeaX/O/0nJJugP+ODAgMshAR8qXD9
 IAcILn2p
 n753nZUo0RCrTp/mdVtqwYv96ygYQFYR0Y8bDtWmXvlyUThszcjFAURblSlRPCc/30bBDFHr7R/EA9qVSV2i+sT/L9egSBrsBBeAgqg3+B+sDI9q3l5C2DnCeyykbDhp3dk+wVmkH8qs8WbiQa+F0yx2no/dta2BWNtEaWJM5M/9WvYt/8gHOchmgqWv0CqaiXStqvdLlVUdCfFPb1MSrxh1NfycaJtf+ZgbBvxZCYQgzgwEmbMXFNrducWWQdP2c061hBhWQNiTkSxyZpbcDxzAsmoEjfxueE9udZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 867046cc7027703f60a46339ffde91a1970f2901 ]

Allow (for example) min(unsigned_var, 20).

The opposite min(signed_var, 20u) is still errored.

Since a comparison between signed and unsigned never makes the unsigned
value negative it is only necessary to adjust the __types_ok() test.

Link: https://lkml.kernel.org/r/633b64e2f39e46bb8234809c5595b8c7@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 842c1db62ffe..2ec559284a9f 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -10,13 +10,18 @@
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
- * - avoid multiple evaluations of the arguments (so side-effects like
+ * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform signed v unsigned type-checking (to generate compile
- *   errors instead of nasty runtime surprises).
- * - retain result as a constant expressions when called with only
+ * - Retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
+ * - Perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
+ * - Unsigned char/short are always promoted to signed int and can be
+ *   compared against signed or unsigned arguments.
+ * - Unsigned arguments can be compared against non-negative signed constants.
+ * - Comparison of a signed argument against an unsigned constant fails
+ *   even if the constant is below __INT_MAX__ and could be cast to int.
  */
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
@@ -26,9 +31,14 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) 			\
-	(__is_signed(x) == __is_signed(y) ||	\
-		__is_signed((x) + 0) == __is_signed((y) + 0))
+/* True for a non-negative signed int constant */
+#define __is_noneg_int(x)	\
+	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+
+#define __types_ok(x, y) 					\
+	(__is_signed(x) == __is_signed(y) ||			\
+		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
+		__is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
-- 
2.47.3


