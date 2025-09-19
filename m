Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB243CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228898E0122; Fri, 19 Sep 2025 06:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1278E006B; Fri, 19 Sep 2025 06:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051A38E0122; Fri, 19 Sep 2025 06:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E285D8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:25:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B65AD599E7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:25:06 +0000 (UTC)
X-FDA: 83905617012.15.33AEBAB
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69FAF1A000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:25:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dfmUzvAc;
	spf=pass (imf19.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
	b=upKqkKyrrn58JY0sdJt0jdCUkIb9VVmddANW6NiAepA/WHG7S8DCLeTXTNmpObtg5RV+2m
	du/zQM4kpdluqBTx2NK1/ahfoqTb+J9VpKq//mtz/uuZHcjSl5yZtxhXxHSOGK1CB2Rj8Q
	SiztXjc/AZ7vFyAkdXdGV9IsGtTgVvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277504; a=rsa-sha256;
	cv=none;
	b=0OOAHeC/ygRlaOiBJfke1GpKyzVw+v9G+typ4S594V9SPVat8c6w4V6237nAjUQoXLpkyQ
	bxeTGaXpjCxGdttY6yV3F4onOhrsgj10mT4RaF9rTZPbEt4/AZegThleStOFNbZt8BD34A
	JKuQkyVqcGwos8jl3dl8vxgPHRlTWWk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dfmUzvAc;
	spf=pass (imf19.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277504; x=1789813504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
  b=dfmUzvAcDJzv0R6BIgqB5qQLBVIs9iomSXUvB9yJcmdqdt+MLyPQjJ68
   fWcf3KVYNmrvgQArTxZRpFwqqo45Id9lVARa70EiEW7DN0zZcNkfI2xSt
   rdYsx5vdEtta7EjEmqx+PffkUvd5hpPKv8yjSr1MsAgQFnC1qKG2M+nSm
   eNfavR64W6epcY+mA1r6EYdwYbJQBWlS0jMRqSLvYJLENwFM4sh0W8fj+
   0inXJV8FXmLl3EMam5RlrVDv1O8Y8TP+3/hxLGKiBotKjVlcfiblIhPK0
   UOSxNhEjvnckzlQhZdkO2uXB0+hasdRjMI7r0cmayy/VdqoXoPIFCwalk
   g==;
X-CSE-ConnectionGUID: KANou9z1RuCe6Vq68KMQTw==
X-CSE-MsgGUID: TbLofDk1S/CNyVlnEY1GAw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2369395"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:25:03 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:30717]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id 083ec295-c61b-4097-9a92-62dae0cb35b4; Fri, 19 Sep 2025 10:25:02 +0000 (UTC)
X-Farcaster-Flow-ID: 083ec295-c61b-4097-9a92-62dae0cb35b4
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:25:02 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:24:33 +0000
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
CC: <jonnyc@amazon.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight
	<David.Laight@aculab.com>
Subject: [PATCH 12/27 5.10.y] minmax: avoid overly complicated constant expressions in VM code
Date: Fri, 19 Sep 2025 10:17:12 +0000
Message-ID: <20250919101727.16152-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 8equ8rdk83it9kd5fhr5pk1jy8au7fg4
X-Rspamd-Queue-Id: 69FAF1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758277504-40254
X-HE-Meta: U2FsdGVkX1/ZdI9JZwz9t6RDVJKrNH4lu0QWNJpd6SxA/usbnqZCKVzr3WvHcgAK0tcYvuygLsiyGUAEc5/A3KnPt8hSJzjK/GPasJQYTzoQu39Zl1fWuCI1Srg6paRgD9Scfc2bgageXap2XFnZvfKF+tP9VMSyqq7wJmr0eUClw46K5854Rz+xngt3ikBMxbJ4aczXByJ2qbFgosnf5L9r22omfMcR7oOrobW6M0zXPP0jsMs13WghjX4zkwl2C9tgrDUs3UwAxKUYG5h0bEQI1PIqer2x4H4Ly+W5elkkuIPLvstZ+LLH77vStPYCionO53IjxSDK5qKa3vcHUzTuciWz3ddifvr0q8H8sFASNYXTOnWT/dfkp+MUcw6GvE+UeIxLZUc9GXcJ75+CzNWRQ+l49RDTb1GI2IHCEkU03pwMn/hiWApNQZmHIJJgldAIYt+8PRtk3SuLxDx8uI2GgW3J22bMF4quf+LTSgzv30jhitoZcXvvLUBlOZwC/fxJNlrXk9aZci5WBqGSX5I2qn0CuQe9jVeQWEtaCtesjAYHWmBbPhedK50r82NXkirSKrKWLst/qtxINK/umSxVbX+eZxThelw1CzbqPdROwQIiSUd7s6D33Tk/uhwUUDdaejGZyXbT5HskQORVheCVx5CDprQG6gPxtYoFG8EqRYJIjqwjHqdofjSyCa5b9arGS7YN8bIIKsvvjiPtnM1uemI2ZbiXspasu1x5L1wTIb3WjppmvWMuP4FtNXygEnTp15wZn98Y0X0Tcqa2EmbVUMARPFJu8sXfeaN3MXNzO8R33w2bHLUARGUJ/jm+/5wniFLC6YD9aS+2ILy08XDbina0Q5yybxYp9nUOhLnF2Tiv7z42It78l8BkmRqEwhoO0h0MeLFSlTbT1/ZZGqTWmWc9b4Xpo2kcVUagLfY98XQOqlaDrn6md70rKovVMflevyzdB12NxYkWWVu
 +e9fQqW9
 pFl2jR9jkjmFAZUApyFv2skefB5mMlhzqDxrOV7mOcbJ0QRfAfKEGx8xFxXgmxM7+bpZUISDIYuYqIWvbSAIMsn1xri2CtWcszwit2A960Wa/ks2EdhZ7th0rCipKw01OitYtwHgpl8yql1Ycgm1hh1CXR7K/cHcUaFlZJWbEOSJY1BEHLs918cWbayJnE4Sj9K2T+4i6PmjwQ0PDlBQVQZc1eeD9zJ3jdDQiFhJGy1pfpoSBzGxv2Kyo3lgyLdU/CqNTdIYxZOzGzzp5qwPnZfmlrNYA2jt59sg8VePxnZEYgxR0xusJZFR0dVAmBWVbH5qyoVL2TxnqpiUhW6ia9g5lOSrvwo5aDNwPgIKXdY46+4Zeox8A5BpwyOOHiYqSK4lKN2KzXK/3jqRs+5le3YSxaBCg695krHNl6fy/j4kXqoiLFJO3PXaQbg12VwRmeuaQe+Tx5JbgYcm9WA9gclsh8dQEYyjmugZVnaOUVcY9uSLAsg7Dm/GZOnxk1+GD/K9uhvldVbIE/zNEdjft9l6hDl08q7DW9mDa7GUYBw1eaqk0Qy4ILgeeI3ZLwXU74W636J3C2O0SZDsRkFxLz05AvJYcX2wBgZKbPnuKj+BKPtFL1MA2NkPiVqyJv6Q8B6KDlLYIFLpFCP/UrPzH0Zdf1tFzkngNXFcTwlBkN0kxfIbioL3umgDHvxOXQM/i5gBQYEPv6abSxCNo1DoTXxGY9UJNlRyLO7+D9H53cDOSC8CekHkmSX9L1PCPoOdjHPJDEt/ecMCyFeD2lDeHkh4mkc/tOelRKLC7PY8LbLwd7zxG0fJRcsdwprOz3qPz4MUl6Bbll+Mxmvyk+tMgSlR18Uz7oL9ipFDiKotHOQGLXgGDvO6JcJX7tgaGYhuzPyYQ7Bk/Xplh/PCOMMQ7/FhrMdP77rxByl8eejlwNh0OlqqG4+/zVUfHAAOG1CV+UAq0y1zMCTy4SzQLRCJatP7XxGSY
 ZdOc2vwN
 rE8z7C9Y6tXePKam+s8jUzxCD43xw8tSeSx0sOGQFwfgyjgpcR7mP4h82z9v5K//5P5eTFxmO0dRNEOk7/Bd5LFBmdKNa2coTH3dQsygTzHkGmDHXwg4e+pQpbRELKbHmSWZe1/phjMZBNMySwl98/8yRQcYtkfdyJimM9G/AgRmBd7V80lW+HeTaWolgGi6CblZ/j4fYC8Vq2YkqQ5RgadqHPHMC3TK7sn86WazuGaY2dtLQ7z4qy+Eaw1LWXKpw6PGYnLKS1L3zgBYn9XV8jgk8XzPGEYWmQePDBFd28Nb+eR00ZxVWR+Dpm597iRiEH9/c1ybWe3o076ZLgrIKbLmlkjdN84Sjq1pA9eR+Ak49eDPj/v2qsegCGSyc4BSkLayzL7u8jncTB7z9QsTIBBgSUhJt2mDFy1CzK34wnaYMD1L4y/chPvvjCeNvzXqJ/UKsDzHZS6eSk8PWemH3VCiM2jYlzyuRMYpxQNDvClCdZH37zygDkMLaKWiKRN+Z9y7kGAImkp9D1shdkH6kDFOaElEZpYf1ro5Ch5QPMolGx2KX2AwKfhxQ28rizi0R/XcxAVWWLBAf5ZgNCtdZxYb3x9BcDL6xIh6KPV+JU5VrvPgIXpdKb98iP9Aal4Na6IKfuVRMSxR0pDJH5PO95cfwgQtbffSxsFqNgHFPD7B8q8UwdZTkkOJGpci9d4laUBsja3h0evARl0LYAqfVjViplr1Y6vdlvYggU5njln5NbEiMcCj+RBhlJKokpMTVWTnSyrAJ6shRuipRwPOKglr7z7TIRTuxAc+Fos/aiZAyDghsj6vLoViWGknkzEU+oNeQ3posi0KOOjEmDcGxM9C6dMAfRL0kPg/2z6LtGPDyZgDCsyQcPF1lCMMscdbAgGj6KvYMr9HUZrgylFUfYGV/YteULyiLwwQp9A5HA/AJ0yDrpnZyp9C/L3chpLUcMskiTNddkP0zMutxEPKCfJ7Vq7qV
 0OgUOdqB
 lnyV/WT5RjYpBXuu6U7sEQEm+aiNWOQOIONf3RxBFlK2Y0/Q+uylqVungzwy+eIJ3qb/q9+Nabm9S+tiw3EXadVpG28cvJDeB0x/hijEJZOPbNDWzjga4iH0mFZPPhdwl/axYWxxQMKpAJ2ribSDgjYEfAMp445p4VWo6FhFjh3tXG0UTuzhmS7SFksmi+9sWddj+EDGFQenEQO+VzJPT5PFesVpuZPqiuK6BSZC+A9W6tCJbbeQW9PcXFAHIGwi8RPRDleP+dIuUD1F4gFJUMpGgXRsfx3qeSpoXOdY1C3GSAEiJmNKb2UPOM06yxlfcapU64+Nk8pTgQtzl1bpZv9y/MISGxpydJSVHcI6esJNICEvLiMPAh8pfjtcXiuvWZ2WyCdNvVsgZhROBnZhuqQ+xtvcwE97xJBfTSoUWnA7lJ07rVJmXLxloTZqR7B7Hxi5sP9Y5uqSfZS0EXDoFIhMFQDjYcX0p5m4aZ0jC4Rmdttp74rqWMlwJcJ9d48uMqCLncdTBKQYE84/ySF9M7As++hy43uEInbH2qq37PTrWlJIAlIishR371gq8OI4+NLGt+f6Su7S4cNAFhrtuTj0tDQNRPCgjSbaKxlHdxzOntQtCLg+ujSOg7DR5nR5WDPO0Hsx/1pQSLo590V+5uo3EDNtdZ+sM3raPz9Nw/PbIXEQYbFUZR9bc18lV+5goIsoivaTL+CWKaHofGIOR1N05/bBy9FjGTuhXs05J58Mi9k6/d+OUPj16AkQ82q3ho4HbSUgvUqCjOGVov1pE4zLY5WHNzaWo6F+hAL6RIzqwB5EzI1rLg6eoZwJ9pxoM6A9eiA0f8Z6dR2plNnxHf94EU4xWWo/04Dh5gotJuEwCVLBoLCx2HC+cyleON0ahSdfbetgae3ogrB4DfhEk/Is12+H19OrYVUS92cu0Cm6dNP93Q5Qid/rut53eKq9E7LLsOdP0oJ2UdQ2kdLBgUQjekTii
 7m1KtWDz
 Yrec9/1a/FGSEyGk56gQKZq2Ki40RL9R18eyJCcL8HaEuvTbKE6bPczTRstBH6wLCEpdz8QZaQM+J9xdDgSnfs8ShekxC/gR3paEUvw8GxqwN7o1AbvX3DBGXzi4dCzugG3Aopl2ABTdCiH/laIK0UnefBrrRJtFDEOXRT5ew+EDXmIvaf8YF4poPIdslG/Cp+ySvfmE8GZ4VHH7f3v4HTqDpjeN0yUHd03NOhmFpymNAst8ZfWmRl/2hg3GFIZic7p7p//ayhzTDPVGPLCZuk3ovTCfwibVEYKQnlgO4qGXKikrv5BaQPf8mnwvKMmE8RPLejF4g88wBD+XA2C3PFAQEPr07DENnyhca173AqPbaPvR0JaZOeYtWT9D+RSTqFF2qhv8pOClnp+NmX3qCa3SND23qJ42IXrHG0gCE0LO/g+Z4fqhqJWJOlUT1ucaksoa6lfl/eRiV75dNd+vBMvw0G2SmWfXIzM2svZjK+pjSGx6QLm+gmJHOfOjl/5qwd+KLBWE5F24f3f8sPfNMJrzOai0CW0sR/WwLxfB1MOkK9TFC2DJP20dD6WvOOK2naWHmhgaxnyTnI74GIFx9LDHnLhJ3A+RcEIqAWcODdEe+kI+TOTQwm2x0i133LblM8W68iu5us7NYIuwIi/HRoGCRUFfMU9cpMxP6bfuXQwWSXxIX0u5WBWljBk9yKrBFjNbERqpXe67raMFkx0ECyxNH5vU7srMXI5cRlDgyKU1m2VugmWR2S1QUiuDRqFW/JnKZ5ajZfMrqFWhB3KkhtPNAM/ogVRG3h8freCqhZRqMLwhdIL1/yZp6j6Go/dICnlSzF+Hbi4+9OdBKHFhxTenZRfYIAfDmqv4xDkjSiI3aw0MqRXyaNkF80g1V5Xe1hc1+jHrUR8exgw+Dt1PHkz+RbwElgJP+UNHPMJG4A5N6SA4lJbYscctTSXyXPTBkO5SgTZ/18oQ4ekehUVmiXsMudMXs
 4RItVkRV
 9H/t/rOGV7zaAYB2aIIz8HlQ+5XUSoN6OpYa1XYZpVsdC1LlL39b05ZXROd1P5GzaUUYbWXhQpjhnc8/g+PhISx/TgAavyYmc4CXqP1Ofw9BiYBU4I5eebn5ngMV444e3pBEhkh9sRE4s6ixv4YAXaUlgk6bIZ1IKm+gFqjYmxFatZ1bL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2ec559284a9f..a7ef65f78933 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


