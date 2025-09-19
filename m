Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F190CCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F7E8E014B; Fri, 19 Sep 2025 06:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520A48E0053; Fri, 19 Sep 2025 06:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7BB8E014B; Fri, 19 Sep 2025 06:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 298708E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:33:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F037BBA5F5
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:33:47 +0000 (UTC)
X-FDA: 83905638894.04.C56E073
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C80F140002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:33:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Bjmh/uTL";
	spf=pass (imf23.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758278026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
	b=KHA8jFG8COnyLhnYMsKky7wVwUv6YiKIJycJ8gZjCquNO6U8/LdFifiTWixAHjhRfkTlZ7
	mMXsCId+E+jOboG3KhrG/4G6ItaMxa0Qk/4D+xUkPfvP46tT2I+Y8dkTY/CRpUZ3YA0gyx
	WGxJNXRZEst3xEnFWbEQ77KiATYTUdo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Bjmh/uTL";
	spf=pass (imf23.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758278026; a=rsa-sha256;
	cv=none;
	b=diWW8vzkWHHa11L23U+7KjinR4pauugmg3iTaFK/5iVDHAM6FKq6aYWsAfOPHQO0V4RUgO
	NhGPtc5b4xnaKLEB6rfc/DisZQr30dVAZfcwqpmy7Wrnpdggu2XKVYZX7RirnN0/vztuSG
	U0InG5b4jokQU76QZQEjk5WGC+gaQaI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758278025; x=1789814025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0dUe76w+6n5/NfsPbyefGVCom+xh3GGcFcV3Olhmks=;
  b=Bjmh/uTLD1ujHauPWciawLpapiqHlN3eMDt9MtNaRy9sxyCLjJtcCd8A
   ENxwHJxGZ/ZpC9tic/GJCAmIiTKwOyvhsqflQItVFby/i91nTDeKgvpTm
   eqWd/taah5NQ2DO3kq8I4RSYTKDRcOuhYaHz2UQ9EyMh/A/E3DQFOTGKl
   mWvMiZnL/9/IBkxtpJsILtjVVFAniQ14+egmWLeOu1vZ1bx/yoT/kZ4qw
   0N7aVrjVO3RyI+o3+L0zu3CdWLrSBRePdI14vA3K3E4W2wB+P/2F3379H
   WHjKQzPy8zxdsDn3gRg+8/LeHBNz8Oq5jg/miNo0jz37+BA+/ixHCjdfe
   g==;
X-CSE-ConnectionGUID: 3J59BZVfSaKQXIn1vsatCg==
X-CSE-MsgGUID: StLEOjOiRsC1c2knBKmbeg==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2265435"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:33:44 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:15647]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.36.68:2525] with esmtp (Farcaster)
 id 0e93ee90-d0f0-4845-9149-cd800fa96270; Fri, 19 Sep 2025 10:33:43 +0000 (UTC)
X-Farcaster-Flow-ID: 0e93ee90-d0f0-4845-9149-cd800fa96270
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:33:43 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:33:13 +0000
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
Subject: [PATCH 27/27 5.10.y] minmax.h: remove some #defines that are only expanded once
Date: Fri, 19 Sep 2025 10:17:27 +0000
Message-ID: <20250919101727.16152-28-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 91jr9gjco4doc8proik7hb65rmzpsw7a
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C80F140002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758278025-215446
X-HE-Meta: U2FsdGVkX1+zz/3ufyAStWz4jQF49G9QLZWOJgve3lE3HfoDRuTD8g2An9hQjOJV1DcYn5Uq4kuB7Z6LcUU9WrlVSGTj0YS3e48W2Bb8s/MX4ZltW68k7D0lDMvvOPSsm1YACz5uLxFItJeTZcCzJsZBRn+49Yay0OvnUWv20KL5vw1gQcX2PypGb4m8xxHcnlCQSt5v2qMhTKkrePC4N4YAneeWpyuzs4530NjNVGOIPdTiFusQylWs02EbhBtbYTQYsA9nkFNe6xCMDUI6BjFMZ1h/1Qe8e/XHZr8x5+mwdi14mryH8bKpbRrSfyD4csoiFpukCvnE9jMbZmkU8wVwcntomKASUxwq1gDn8JcsYXBLylEYsY/kF2PhM0N5LCSkrevA6lHopUV8X/fPHRKiCx8WM7YC6oIdsB38XdaZMcQgMz4vp8rBnnGVFzSHVpyYZwnMKq0K6tR1hJmdyk6cTeN1RViMKHmBiCrmLdwKu+3Pk3JpRUhlaiTBoqlzI68vvjYurAOm4bkXzRgnLMs7TLXKLAuX6ysdO4+bAef3cVfvD8a8BrkqZ2nYgLii0pAW4QtPRnZSqJQfVSxkA1cwpuEX8YJL905grlDH1h1uGG1baTjbYhsz1YAiwNPDJRMnRXoZ28LjW1ASMJ5wwgyrIPytpnGnzpSVqQrx3U0K3OGBfO9vbbb2kY89CxaM8PSHiYKxCNFT/iX6JRnvSWDxO2aZmcO/Rpbtp4RD5/la9nWa8vDIcmQoVeiAkLxlOfh6Sxrjg89Xp+oj/1oA4piC1nuPovIANoDkOd9DWvINOBtcUavSaQ3EmV4hfQB5sfB5B/4DPaziD5w+nVPmJO184hAL4lGGKpGv1oahY8GtwYftu7Uq+stmeHjtK5bMHfAfwmO1epG1ztBKLW/M9Y/dsASo6QBmgLdL8dsyVKGrD4eLYjPg1gRrcMeYHqzKT/TS2PPt8BmhoOuIRoG
 aO3AmB0x
 ECfVwG5fm/jHV/PHwPfNyL9Et2L7/uNEB+XJWqtRk/x3t2CC42PD9Vo8hYqOOd4UgBW/A2ZEMQJzJMlmuqHh8+oIA0HMYRAqJkGj/qmfyMGcCFIJJomR6o+iWSTfb+h5ZPPaHpKJS08MJki0Oorn2pNx0xE897bLO4mKoymnxVmp5lO6gVhDwzyGQ6w9C2g+csyWU2Cdjt0ehlQtFCjak0pjPyE50fG2jFMehe69slHK3wDJ2vXnJwx+vvRoSZDMwL3xmTy06amwNHAuBx/j0WW6AV/droJjVRYd9FmE9gy/CHtS7P0Q9wDw2NVY6xN26rn0Kspl3W70U32qKPXp03yM1gu6O4ci8LFZhbS6jvTqF7RQxgzL0MvQeKrWM914y/JT7S6KR3i0esVBwsreqg/iTtLsGMkEYIyzIGwQkSmRu+K7a8OYHmeBZzwn9OK8p24E4O2tG4hX9SZiDk3NY8SOKkgpPvoWoebH0AdYBuMZIZ3UNEIAwNt8+8aTDtJnLP2a9v36Spqyj3LIw+QGoizmuptIhrvVtt64pFaYzYyXhKTrLZmYixO8LB9qfQexk2Zi/yoFUiCwyk4gcncumFB6GRnpbqGxVnhJpzlWtHKFj98oqijRd9ttW03Nz+FLL+H2FOmEjrixcQflno73ybuh2TjuJoRFYeZ5edPYU1nQUBtvF9G/iEzZpAFkEuEx1xBn6OSpqvi2y1tX7nNEuD0UYa0SjJ93LDXYrLSmxII5+0SzCwVIuoIUxxKKnamT5C6VeiHJ8exlviBgjwW9N/tdRdAu8uPC9DHrTpBLHftPjDgTDVLsuUyN9RpAmYY1K/ZIxRRtgMEOvt3tsiqhD6VbRL5GMPqIRlMSnYaTp8qqimj2Hfwh8sW1+qp6ee7cWp5tA5FQM6RLP1NvPk0gGemMWjcgt1TsZ/S9uP82rUnik7SlptYa7Vvbly97WU/37SnDuhoalhi1PaU3s0XjbOpjOueCL
 xVdz4F1O
 cV9XqEQtAXAbEv6tTwcOktaQg4LEbCIO2h45e7An47rC7XujLrGv8hNFq+FyX+CR9vxfxkXgJhdKoSor0rg0qvbXWlY+N2LOcoCqTiLqsCPCrrihkKrXNhYcOTo5zMjhDt7b8V75qEC+GaKFbdCbP9DALFW2YHfVyuXF6C/ft9j6juvfXSanYPZ5PNzKdiW0G0bEMJNr3LTsCy/mRQ8EfHPJHp5s3uoYH7AUFMBWV0PAYSOI8e7am0O0fdYAAaDNJHLegB/+TdIrbFsrgxiplVhcrwnJOD8lMn/gc0A6jjKTtfis6Gg3AWyxUUabD1HJ2PblH8gi18QV1fXq/WJZ5wDa5P5say/vT9dtiiThtaOdqxgNfRABZfX/Y5JL4SuK085ixJRMMNeq5C81aWQSNRT7jYWnTXe/wRmOg9/C1bfBvzH9xoIz/H5rJx3LoZPtuNihfCm8UHCvnOjfhEGt88zvg2eDq+9ha8Q534Ce5Vyrr1srJnrcOaCQ5oBYI9SZ+CklJILWBA6dVWAFyK5gi0KY0aZlQjdbxMgb0RgiPzrWVbWewD58s9oKVJ4s9hLPzSTm9/0Dbj/6XQ5zWP44ocjf4BId8LqerwDcrEupEt7GAc9d/+dqxU1Cnx59N0bEw7EjE5fQZgbtLtIiAVTZbd4RjRnrfyBAbmCyeJEP9l7lCuxjZUV8KmF2Rdm1R5CCtaqZjukdcenIjWXKQ1+hA3dy+M0flCsuiojkJmtMp9zrh6hzaxAteJtYDArGpWEqRT6sJozFaCJRhHL8eLSZOBFBzZmsw8G4jKmyq5L28YtIBTCuBhyGWnA3lLt1/E31pG5GJij+cyP3lYho/zehTnLYO+ldZbmGPFMIyjaGuBp6b0i6H4PSiemEskbQPUR7Wkf2s91GiAqqH8pKNVkJ0OT9uTMKQQ3Jan0tNEmVtLNyDpXXW1KobXpTeOttb4Ncbko8SlSUJactfkHreH6Cugj5WELyG
 qXQxYFc0
 A6eQY6nP1KyFXE21JzEJEhX4XZxAYeo8H2ZB7tw2qtyRfirqHMN5KuWbal+WYO67nITm0WOQA/C3vd5sCh4y/lahgTea6OEDqawoGz3A6yQl+fdiiP9haFpOeypNQAP7QORCTtPppXBe61WoUTANlTHxckuEGli0JXAAAr7qRJepjrXTC48qgOmu/nta2s5cp4OeMbBe2ql65f5yroVR+tVtC38Hf8q7+F1TIRb08elNGOW/nJqUPiZnwHo5REuKZysBUmVhheDm2sHz8m6JnMRt6TthPD6c5SrpX7B6LOyKDAUML3wBc/Y/kFG2jmLkhn5Zjha+Fc+e6Kj6AoSr0xdXhMg53qJLefNEAoq5o7lTpq2asSiU6s4fHpOUHuGMyC6VbxHBYdZ2i1IhZY89j7wntYIHJDJVrYd/kX16RoMWHGOAs65knQFhYvVNVRpBGgTHKdO9uBvY1G0Ib4FPS8+Et6OImgCEh+G78pUjxdSJFFFY/I1uPpXZvKL5t2NAFneWblxcUlC3ZOC9jjjeHdkjpmRnRJsinZSSUf6S2ovTxQ0GytUcuFTLdpuD5G1CACMkuxKVIMCAwSGBJAKKsy6hwvscpAy4jm8+oYd2yhbHTkGejQQfIxE3qQ6b3+HCk1JCJ30hCcfD/ohBWli9Reogiy//ThWdCifnIwCL/0STdYInqBpQ6HNaD0g9I+XtnVk1F6X2B8BzR93krgt5QcFaohJelgFX9ckgssUHhPgf7pEXwxaK/wKbcqL8m0DVRZPPGOa/KUKp6FQJ4zo0h2DiuYZVkDwjvLSAKsRUkRO1nvZpE5oWatxqtdwZ2ysHD64nEFKp27eQiupyX8x1JzHwt3Yz/wfmal7av1VRJDVvtx0prEdg5Nk7CJnzFCCPhrWFMfks7Jbs/+mESQ+4z+FZ074qB0bS9tjOesuke5j7OvOjCA2HR+C5RB3DChlv7mKxQmVK6R2WIY84PrVxzyRbnTM+h
 aLzqxOEQ
 lgnmx0QtnqCPuvmvzzT4RySdMMtAJpA2a86Ns+gG8GmDYN6ToZKF1T7dbF6gTPrhvKtTjmxRCkZmDFBuVz8Ie16mmTuheTWMrtRGWZtM032uUieqiz51+8EzVhx9ZzNyXrxnqF/e3Hb+8TRmLOrlP0aXMCGErU26QtJwRtIEmufaeII6wimXxQK/u+NLP/AjBkrnAYkROgW9LkdwnC/nOdVM8YHCzTUNkPcrAs00Rnvnz5KJvvtPmgpd+h2iYELQxUMiAFiUGuE4w5ilmzw8hYnqCoOVnc1NDY0ybsmksauYqBuEr0hDA8CY5MJnqJ+QGUu9QWMh1/ZBOZrHVela/ZMFBO6VSVSGbMqxTwfdpRzIbId3of0tvy8XbGMe4Ljl8zZE5+gOxxp9oJlRHQWWSq0REET/Z5ZVJwA3GxYvkzO4FoyA/4WJmELO1lhDhphKLiFwZb+kqlWSFSE0ZPvd6DhIPfKZkkLyQbf3oEJrI9adnXAjDpOD3Z67bgs2+N8utnDEgqCRGJ94YYU26Mu9CgWE1pHdmMCeKFtO2eZkeLg64PUyxSevOAP7ATdxAVzss2Od27E6X0f/Qi1GVjNl2TFLKUux84sAGE4ixdTeR3JU2jZyYhoo6aeiXXJ1A31+maff30nAi47OXVdkMPyg4DYVx+LCwdQ64N4AF98XK4oapkJd3N2TiE6fOaeIL+i+CeH/Fmb1zHXikzflQaZ2OlQdn07DttJ12EFupZfHybNH8CpY6gcbUUzRGZcF64p+Q0i8G/NR4Pv0RXHi0poF1ZEtFaBLLAhY1IzQmNsj1B585i21tSQWnHgLDrbtHf3BZGWaW8ZPXMjlghUFWOMEeyE/mxBtrmfzBP8R/0+5pjK8NT38BEcc/BjubMiQngfA6nbgBeHskcEWeFRB/HexIiY6yXLjrWou80+LTJPneJg37Par6cAV8GakRCxhK2EfRPF1OdrhsnVG1aGwezQycWXbR5LsG
 hiHlsWdR
 2kfPUUZomOZ6lbFEhF/jdV7zh4Wib0qgJBzp1tk/wtHNiJXVChpLZGaf8Sg+2naAH+8mQ2MtV7o7LOQrkyM6eeorWKv2RFsHL75LxqRDMEZzEGkeUHqt0JICoSjGqMbUa392d82rTgm3DsB/JuVQiBmcf5Fhn3/FO02j0olNvJImtODfC7SMKDCHtkC/ARAM/qLNY+JZIwJcP8TRh1zM69Cc9TdXncmw20JOAPEntEhb5OQr+NVN37fF41iNxEkQXIZ0UoN4WLgn9hXf1mbm5ihO9mtPMP1J8UC0QUv92cXYIs6T/oPzDV/4DUAeKsHTxQevLv7RhXolCG/FFcOS8MNJ7CDlOqqPqufqXOnMiw1vyWbCANaDY/6zGa+zIViV6Z042JudLp9HNLNFJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 2b97aaf74ed534fb838d09867d09a3ca5d795208 ]

The bodies of __signed_type_use() and __unsigned_type_use() are much the
same size as their names - so put the bodies in the only line that expands
them.

Similarly __signed_type() is defined separately for 64bit and then used
exactly once just below.

Change the test for __signed_type from CONFIG_64BIT to one based on gcc
defined macros so that the code is valid if it gets used outside of a
kernel build.

Link: https://lkml.kernel.org/r/9386d1ebb8974fbabbed2635160c3975@AcuMS.aculab.com
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
 include/linux/minmax.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2bbdd5b5e07e..eaaf5c008e4d 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,8 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(ux) (2 + __is_nonneg(ux))
-#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
 #define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(ux) : __unsigned_type_use(ux))
+	(2 + __is_nonneg(ux)) : (1 + 2 * (sizeof(ux) < 4)))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -57,7 +55,7 @@
  * A cast is needed to avoid any warnings from values that aren't signed
  * integer types (in which case the result doesn't matter).
  *
- * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * On 64-bit any integer or pointer type can safely be cast to 'long long'.
  * But on 32-bit we need to avoid warnings about casting pointers to integers
  * of different sizes without truncating 64-bit values so 'long' or 'long long'
  * must be used depending on the size of the value.
@@ -66,12 +64,12 @@
  * them, but we do not use s128 types in the kernel (we do use 'u128',
  * but they are handled by the !is_signed_type() case).
  */
-#ifdef CONFIG_64BIT
-  #define __signed_type(ux) long
+#if __SIZEOF_POINTER__ == __SIZEOF_LONG_LONG__
+#define __is_nonneg(ux) statically_true((long long)(ux) >= 0)
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
+#define __is_nonneg(ux) statically_true( \
+	(typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L)))(ux) >= 0)
 #endif
-#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
 #define __types_ok(ux, uy) \
 	(__sign_use(ux) & __sign_use(uy))
-- 
2.47.3


