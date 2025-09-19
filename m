Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5BBCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3F88E0148; Fri, 19 Sep 2025 06:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654CC8E006B; Fri, 19 Sep 2025 06:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C2C8E0148; Fri, 19 Sep 2025 06:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6BC8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:31:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0B8259EB1
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:31:43 +0000 (UTC)
X-FDA: 83905633686.09.83A5A2A
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9572110000C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:31:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SuYs8fCt;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=TcPS6jVBxVK+ljLQrrbJKB1a9L+SezNkwfZJepX5QAyCOeQ8d2qoovmpcuB3oYMpoCMQu9
	G+8qkL7unqBKACorqPgoQKaYehnehTWMfmjhzkBGmvNmSQpoy6trDf5HS/wxm52BPyyBmk
	gjVxahy9PS3n8saRGBOO3OlF4576tuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277901; a=rsa-sha256;
	cv=none;
	b=1Y6dx1OEgl69oiFwLyfUWV0xH8q3097/G1Vb+pQpekCC6EXN9GoqekBKJy6oTCL8fwrXBM
	JvXjvy2JnpRB5Lgs0rrt4FAxoZ64SEo/nEBIWwhLvviwW3bbzBwMO9ubrzLQWjvOAGlM2q
	sviF27TBhiDSyR56zhksu5ij360fRLg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SuYs8fCt;
	spf=pass (imf14.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277901; x=1789813901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=SuYs8fCtOl80QrzSx83TjapQ1vTY/2ost+bGfTY5YtTeJf8vlGH5YUQx
   zC77Ew4vKvhiIi4Z3bH9Lz3b0KfuSoEsSvzKsspPeci/U28DBfVQiQdwK
   XF3ZsX+hqYTA766nIb02jDgWtYo8jVtezHo/QHbp1G6y8oZwFr9K9PXGo
   xKzq5Oqw6dl2rNdiX8z4ssTZ/cmX2ui6iAz7+zvKsyrtn4R4SYaQjptT2
   rM14PeNCCZMdbXhclPNVVk8PEm2Paxac47PRx9t5EbbHDbwv266tb5yej
   ko5A8lYxG50dA+gVUABy3nTjTxkCs7RRXE/wI2bLW1oxphUJQQZc0TJxZ
   g==;
X-CSE-ConnectionGUID: 8Pp/EmR4RQygikMBQFhZlQ==
X-CSE-MsgGUID: WuVtpOtuTJ2jmO13teAdLA==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2370054"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:31:40 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:18808]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.64:2525] with esmtp (Farcaster)
 id d47f6ac5-bc7f-4413-97d7-06064cc021cf; Fri, 19 Sep 2025 10:31:39 +0000 (UTC)
X-Farcaster-Flow-ID: d47f6ac5-bc7f-4413-97d7-06064cc021cf
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:31:17 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:30:47 +0000
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
Subject: [PATCH 23/27 5.10.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Fri, 19 Sep 2025 10:17:23 +0000
Message-ID: <20250919101727.16152-24-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9572110000C
X-Stat-Signature: x7otzny9gqzck7h3nbeqc5tpc678o61s
X-Rspam-User: 
X-HE-Tag: 1758277901-302127
X-HE-Meta: U2FsdGVkX1802AWVtn7j97sHwiXB8QgSqzFroYE4Vnsux9WezcpkpuL/Z/30snhY2xvbJ+sbXVKLVaM3MDWy8dd0YV2SorGm7BA3vB/ZU1FeF4ZNB65yZuVF7RzLmPa9ngQVMEvNtZfiIe2wfhN9mK0pq+z0BJ0UEnVaB99gGK7PV5BPOYPNBpJ1NDVG5Nh69dy6KADNt+svIvsrS8NtQ3tRa6FfuOxPupX/I5SxCMQYl6UyNdBjSmjA7rhKeV9k1Rx782sdk+c8ovSNNRcwolNdkTHB7Td1w9l8XYj6chOBh6aXbWe4QuIvuk82gBLCQPI5OD+XgruXHISnm/46SmKf26n/cLET5NERmQBBz0EVHzGA9dGGQ3QXRhfIinTnBchnUBZnQWzJqLOFnl12I/gfVnm79QSlJvWbUa5h/kNh9RUh29I7dUtzFT21SyVioEqbCExARMixJwlIlTex8+QpLck157CdZsb0qSKiLNTB66Drf7iiA/HJvQ26MNFUosNyTWsf+9kmdq4Cax8cIO3VLhtxQj4mjui59dOy8RdwVOflkI+uibHV3pB6AevKkV0humr2tfcMkYRuxk1fXzcUfaK080Nr15QT6GgdgaV/k6ayS1X2RB8Vf1U9SfY2NbXTpGfr/vi5m8l8kC4D+csl5+BwJUdCjzOFgKofOXwr0j3UqoFsIlpRwive9djhMa+0ytcfkxAf99axii0GYTZfUYlw5EYoxQgRJtNZ89wfoiWloS3uSJ+mcLq+g6u1sEKzpMJSc6jPKcoiaXD8PhImuIaygp6fL1wBk3qZJLQ2Ik5bFgPlIMcqJ573MK/97mxXAVY520qOPLf3HdvUcWjTl0OAkbC15v64R26DSNmsnoEkOG3qLa+EY4ljOvypP0vGEW2BGeyhDBo50M1tJxjXtFRThEVyPmGPeNAu0+49qq3W62h84aljOZdiSgNDFmC8Ulxjxd+PAohNE9T
 f3WBoCv6
 vNjLGYZdBEjP4eoFTKqe3WqyjXRAfB5eWd6/PF+WaZZGPdcywosyTmVRDtcvWqcOHI9+LbrY0iCcWyzK2rbsB4C8Jfi78/slfBZptTaSLjmWc/0I4dPsTtJO3uCsXWRD1kBO4zA9Hu0+LqLY/feXG8JQSynKtCqRy0geLh8OAFC3a3iBKS5wnuNuSfA1DiU07xnU/O67vd2wFGSmdSAvSMW2Mam7R4vhq+8w8YbPMRfRZnybQ53OJINsXLFe/JWFDoLd53D3RZH7li2J2cAwMoAE8qkIHUEgMs5r71uHddwxtMu/czqaTw5Oz32kuGJTceSPYCeN7/xtVgxdu/cgScwz4oswRoIzoEzyuwUV/JJrnRKiLK17gWOzHqRhOFBS2kwg07HzydXfhK7q+dVsOrcvkyHpasCNqGATAN2GBkKrCyeyyNkraHtn5piTadc8fDcuN8RFqg/estfo4ZYMwqmPO51BtAa095NgErKwACfthSfumtg3dAX5Pce7l7ajSXd2kEPdls1olWfeiucW1I5JLC5BvYCXfCNuQRJHSkCU7k9DHA+7sJ4s6bCgGJPBzP+kXXhKSuPZW+EKjxYyeGvMVll9L1PTxrv2zSZaWkG33OxWCSntWV9Kl54SfS0RQ2byiRtqD5tEWlbyFeIyf7csHJKdnPnhWZqTEIRQsn/RDL1RtlVpArdb3r2FF42d5AN14423/L3LSppev2+BXI2R2O0SUO2a+7Bxm3t85Dasg7pFKzv0R3e4U+GWvVrm2kipiCSI2NAcIRsynfbi375m2s4NZMzOi8s6IYaretRd+bfRJjnvQJQvImxrQdbRFQ9useIZ8Nt6IyR3xw6M4+L16DwiQpUQemBvG17KtTdUIfJNik36KvRfBNXhFfwy6jjB52sPHu9rxZ415DA48J3gFLXNCl5LaLAyA1Mq+D36o2WUMQUmDTLP6kDBThJ0UZ2/F9i8C4WlIoGyaHFI7IIUmED7U
 mP2+zA8H
 BvRr6QLxyedKXa4O7s+A+PlZ75v0KGhevMhtSTbct0SnOg3t0LKiLAlefTMoVqEDJy598thMGDWQKObJ9eARqHBCJTCkmMiwmdcZJ+mf4pQWxAki8ajAbB2Gj8BRk8wPB2jtBnacvDdp0jKqsVqOIIQrio2Pif521a1eWe3dxta8WLJPv4u7G4I1g7EKuTNXdo5bYdK418IqPQFw1Z5N8TJwSui3cZNRPisE+EA94YkC4tM3bbhQJ+lJPRxma792BkXFWLChV/aEHnOtAqLpvQ6O4caQU2SjqWV3znNUIae4oLJ32Z1Oe9VXXXz5xmaGYmrLsn9ZXHE6CTlSoKcOJut9NIU7a3oeK2gnHjhDMAFEv243PDtOKNd895g6TgnY6PQfjLCilid5+NkRKCAllktO5OEFWp/m0vHAyK/usS13OgHxxft5fW4yBvuQiFozId4qU0yE3hyaoPPPzK8HN+KElfl2FX6ePKxKpQklFfZ0bQpkq+MXL7VC8HGxQL72iSxU6Utg6GZqhl2GoBn7OP5oyCxaEDHbbWv0yeih14qR3oowFwYu4N+FSgXLBFdEPhB3B/8KYRGTewNnE0vjPbUofk3NMIFv6E6YN2hgyzHanBVYXdNgL3OWjGBuxSiCNzuOmiMGl6dBQjrIbCWRVHkQtFHqw1JO0iDgobS21R/XcDt0v0o8iIxHrVIncoIn/WBRHQkbJqMcJ0pFpTuNuh9+TWsypgt8Eugm2LVMVSk1277yiAvmVb8XLOPaQxI3Hp1eb7j7/s6hJwpwhORlqSJG71n7Mmf8o7kPPQBbCwnBcypqREl844vYs5hXH97VazaFN6ZnadS4n/UQPWKHXjPoHlMOB4UWE7/1zUBJMgPM0sWClLp88EBbHbXGsVgK+Z/sx6iYUWNSt1zHVnyGmdfV9Q4xSwGPe2JRHSeFB1EtwdfzkONgE/Ig3DKtOLyAWYfsZpniWtc9W5INKx7dlNdhSyvsp
 jEpxjjtP
 5LfDHZdEKTQGvZKFGipbSHMGidufkC86EtabokZ3ZuX0HiOWBW189mm5Tz1VH4thtmXQuCSVoaTpz/KNdfkQ7lRx50/8qr6FHQESVAkH0RlWTxzRnZMraVDWIjMQTPSPjGvgbVLiidlLcL+X3TG8EBpDRXJxptQ8Gn2WwPe03CWT14fO6C1Q0GEUmxwDr5nHTQByCknBvqB5+fkLv3PqaYMun0OB19mjN9XO0rlH0FGsOItXB6g1NbONqQ5f4f/Rk6R+uenEFVgi2TCWe4Wo4v1mLJzHxleFYuV35CT9LgGqmXlBs6l0uQz6QH0SsAgxqhnAO9xhVhWjtM62vso3Jd25aChBnynKdfAoS0YxVHhunO42yEFxOtrGgFeu/mae8DroJta/U38tUyw6Er5GUPUkUEcR6hZr7vWv8DxOUsN/Hv0UlYR8cuUlQ9P1Pp5HHcwJkrZyF5MYEaRPAtH37Y2Hx6Yc9Sn87jnyJ2KMRaa8X/l+hrUbDepe81eJKIXgrO8B2PUgt1GcNFNZZa2HzO1u1f+KI4P9BEVHdR1FudiaUSQeuUTIe2eavXT04lA59HfepNNtlJx+14xHRVBjLu6NY28y15UIYHGsU37zUmL79vsKzqxA0OoCwqdve76sAdIKrm2LUeLmlOK9qSUui0UP6tL94YX/3M1vxlmbPblzBqMDaZ8bPtC2OZQcmxFYnhNuQ5x4/3/Eb93yMTDvba/J/AvrdGxMbJ6R77QkpIkkJy/bNWVWMwv3qbwHiz2JX6yd+NUPLwkDTe8Eu7TTvK9WqbeH0pZ4SkS4tpMuJderVUalwZ9INo3f7leptEEbq3PGfWWrqnAhnqm5fBRnrskpIGEz6+DhXr94cgRvWjLXkwziieZ46eC4XOU3cNk736JW2BdL6BhEwGRbFfl+8BudWJOKZlUh9GU8rDShje4jlEndLjrY5zDvfZDKLXMmMrA7sYWLy0quNBSxumts0YK4ziyOB
 aYOusvee
 TEj5SCOiM6b9kMrVKUQZnYyD910vL3EceTm9ajm257/9fN3YKur91qsugmsw2G3ULr8Q84v/X/YdeUZqGvT6BddstaX+JLTF3ozHF7v1FJZQgbujhHes42C9X3chvPjpcUHEhEpVwxfXiYcMGqXuCI6qK6moiM3Ch9wv7eVaIGhUd0fJ2XW/YftLxCvGSPtnZZlMyhhwNf2R8QDY67nu8ZuI+KRuF6viFNSy+q5B6rx0g0+AsaWtzW/zmQ0CyKaTAAb5qsvuxOuybtLu73rXLgMrkdoaPyN7UUk3pMM/92kNykgeUVc9Fs5rVhuHOadz162gyVyYJsEzCE4HSrXv/NyRKkdkupCvh2yrg+mneUQkMP4C1lP8TbJiyAwCcdjEP9OlzIzNK9SO58XnWPBHPgx4EO7s5RhBFsb+lKcDAHW0WIorxFXncz/wAZoksASEV+rM/u/qSqFKnXeMF1u2u7+tTb8Qx2lrxQYnbxxSPJwhPi4skoCb2t7yVLZ20v7CFEzA1y0TRJ5F4GzTzh3dgydvoVxdy/FLYgkM6BKibUvOgRhEqhhf0eBbZGlvcb+NwoTZHDr21aDriYRxIZpCt2RazrRdjh1kkQs8Oj6u7MRN+fiSjJaHfcaNbq9FOHrAegBnnKFql0qnN1UFRuCxwBORFy5rnvtPWwabjep09S27r2xlKUmp0cw8aT/N7u/f1nmfxdjQRijdI6bhrLaYcyon55bJFFczkNN8VCCQqA3SQfhulFoyGVRxF4riEEPGlqfvW+adaxvwmOqoGOCCrbmjNOqRctTPqXlfJGoVKmM/OKKr+uF1ZDzWNWtM/bJwpKW4z4yi0S+a1fraCBT6oK5S0TPoGXYaMjP7d2f1W/H3NL5tD/XUBgNWwzxGcQN6PdOmd12HRYFCL5Y69XJpl1gEILbJ1YeBB1haoARq7cafbEvwyeWiir6QDptUSrMdFGXNCIt3nvpjjt+lCIHE3QCu+tNs4
 hevYtFm6
 qZpH++THkDwebMl6hV/cEI0S2vKa2hw1qHjGc9RcbuPv+sFe/lZ9MgJLpZgTyWVjWJtETkySzcxxmXJhXD0IoPTrQd7zIG/AiFSiXo/L09+XbuaoazAVMIhYyQa8tDekYPgflnfWSThESm0QEnLQsFkWtlifnAG9A/maqSjw+V5nKD6/ZXwVuT7CUm0wkfvDnT3P9jSKBoS9oJGao4jpUMTp2zJ951u35nzkNfXYpbiNAgMi66Drkmgx4AwL8CKIy1ykuB3X22b4/akPpQ4VVBsY1DOAjJgrMS9UzwtBhF/05q1lXA3PR+1vUz4nK6ZyAs0EDN+FwPwTFSzoRpP6PVXyGjFaj9MuNzI0955dzgdAEvd070KV0GbAGOlDog0qRyfvGAVDNwF0w7k9Zo48xBRyWyZDScYYbmVbh+dps07BC/Tbj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 24e4b372649a..6f7ea669d305 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
-- 
2.47.3


