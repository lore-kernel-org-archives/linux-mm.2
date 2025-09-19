Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BB5CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5718E0146; Fri, 19 Sep 2025 06:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985738E006B; Fri, 19 Sep 2025 06:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D408E0146; Fri, 19 Sep 2025 06:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7132F8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:30:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3244F86326
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:30:23 +0000 (UTC)
X-FDA: 83905630326.18.799AA2D
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE43410000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:30:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OpfwvAA3;
	spf=pass (imf05.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
	b=lCp/u/kIZ/TJRHffaVGUMPeCqCeWu+MfHbtdkoV06/35tUxMC4ZRzJ60ecxp12UUMRfXRn
	3q8JS6j96CvKJqcSqAlD+aFr+zSmf8lo4Um8WQDwBHEb0+QcDNPmv6JBf871DW+w4j9iyK
	0OpCehCmVXo6gzi1tsv8G+jg0AeGMrQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OpfwvAA3;
	spf=pass (imf05.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277821; a=rsa-sha256;
	cv=none;
	b=dnQnmO9k4oHtsPk49iDUDkxRsFnZUmbmd5MqnMv8FsPhf744K6wfTOmTdg3bReJAB5AhNi
	1yMWOAKhaSAv2oZ8G0FcW6I0zYJ7k1AeZ9vjnUOWuPSkgj9zg9yCdtz1mxS3dEiiXd5HIg
	Q26Sa+PGU2PlYXta+k23DeHL3AY3/CM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277821; x=1789813821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdmfzjzF46YfqPKnSMGZyjhQcZN9I6u6dSg4k1vq8LU=;
  b=OpfwvAA3SVVwId6ienOttCtFWxcIK4Vz/ABDggHdPaFkDANTmTaOXTNg
   uPFJI8A7SExSX6i00TBLV2MhSTzPxeE0crJdRf8jmZ52CmOlHeIySp4vI
   4kpvMFJGctyNbDbXp3Kh1M8I4v13yAkz5R+KRC1/6H1HFJu2zzMU6Zuea
   bl9/AMWqpQvauTgHXdYmDmrvQRAaxNaRssGcuMp2lT9afMr/+E29Q0a2t
   eTCh6nMkzQwtUjRHQ5kTgTVLfxNQ2iO0QbKTw7ktXkOW0T4y2L6qHbWFc
   qP7X6bbY3m33SzbYcqqnbxn3BrQytQ0Lyr5qN5lZD14ABEGxH4IVYjqWr
   Q==;
X-CSE-ConnectionGUID: xQ9t9LUTTciZfuTekGyqww==
X-CSE-MsgGUID: e8DOXKTASOKOk2sit3Enug==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2367886"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:30:19 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:17295]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id 55de2836-92c1-4f5f-b400-1a6b812231c2; Fri, 19 Sep 2025 10:30:19 +0000 (UTC)
X-Farcaster-Flow-ID: 55de2836-92c1-4f5f-b400-1a6b812231c2
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:30:18 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:29:48 +0000
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
Subject: [PATCH 21/27 5.10.y] minmax.h: add whitespace around operators and after commas
Date: Fri, 19 Sep 2025 10:17:21 +0000
Message-ID: <20250919101727.16152-22-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC001.ant.amazon.com (10.13.139.213) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE43410000A
X-Stat-Signature: 7941mrbebsyxca53s4oqpfe4b4pd3638
X-HE-Tag: 1758277820-657598
X-HE-Meta: U2FsdGVkX19JP9HGr8EjICfu38r/vK6vQpmXi2Dm4b2j7xma0a8EpUt3AQps1roV4Ea75c7Rj/PRU+KMPfiFa/lEs2Sme/R6tf8K+J+IJBtoUOBS6bwoI+Ouy8Ro75k8hEracoEt9+11hfvFCxkrXJuULAMc/CE9alAvKk371VMCiQ0iJb1XEeWVtRxD6Y2rjAR5s2f9gwxEV/JB6MliiIAE3C4nnt+6hUB+N28wzD4MC77InkUZ5JJkmIaCy5FowYCtoXPHrhgrnA/XaASoVDpfHoybGFiFUiMrye1G5YUmqXEGGUR9blTfvnQ3QT6WQfKJyW/PGYkr2xWxrBPgp92dBlGbf9NvjZH/YWaQzuT8nVaSFmr7VboHGqcjdCbJt7GfJ1/KaMPdP28h70VRANWkc35Sqil8oofrY60D1r8g6B2ipGO/nIw/euhqQ6UjsQPEbGwdB3T5RRWekAvQzhyERVgavJGauYUdHlPQuM9Nq8MZ0mFNVUHYmOMT6r8ZGclqvBJ/Vaoevc4ZRIaSl3E+RIZIx5TIn8goRjiczukzgDo66z3GmLgn/anytLWM6dHxpcM2zwZV6TCqgAj7Jft9LOL7jHTu2WJgod44DM7Ou3XYgraeWa4qR38DbU85iusQSzXIBiGVSg6BJ4qCqUfdtsq8eREYclR/hvUBaaBt7SfketKXbH1NHLvAeVbkKkNDmOWp1A6ZDgvZnuIPU+GDRAMngMKct4I2BrGkvqGvt7E34cSKl0cIVhlDGrVSCmG7qhejjVOSocFunj8CjyBirhbwvRQM8lKFDqrAUxk3/TKKwbUg9DYzamLPmqDcr76cOo6zNsA/q3rHfYGgb/lUuz9SfK/fkqQaoXp9+5nGSsJA8OeWcfmklPc5j4LFQFu/8hzZmX+fhFBhqOxLgYt3IvVTXVthUwz7fpE2ArLga5+FNDswylgtkJ2U8NevP59xScfl8dTt0fc5QUl
 4nw23jig
 QHMamEV8jVt1RxAtEUbR9+NGZ8uQSkPTzduZP+Ve3WvawhIFFMLykWEqUCif7nkrXSVXVjK+T27MPuayY/BYJBuGS877A8NNuBJwgUGXF+PKXsBX/EQQzMiFpPDGB1YzC4YDuwerQItES36dNqv546GRuUwlS0YgJL9vVy4ULPjo5NhQY/zX8boioVOq0VmoNVxTEy+RiXXSmZAMVKsZcnuBryvt4GeJ1U5UWCe8khbs8b9CpLE/l6AShFG/GYLnMzoqFQL1qu+bpXa7alBXdYUU5A+Sh2LuoJyT12BkEi7U+nXb/znf+UklTH47cfciwG1B6CBeVOMnxTO3vajier0WMvuLQRVRUjAki5uAY93FMQCB8z4/Z/+7iK8Q94dFYdeh1RTAzz6zcrNxoC3EnCg4rrmppSwkUUwE5DbN2LVYttqFgG5heLakvOY/IrwJaUj2f51CnHzuWwVSFGw6VAV+aDFt23grCUTrnD9S53HAjE+x1RM11Y3YOuXmtfGuioHyzarvQxVwmees1wcpAqO0MDM03OfhCwCeGFORO7exyli0kLnhg82XPQxvXJeGZbWdGPvOqgSWVRRWN43F1I36tYXZOAjp+AsNGLRisifsk044Fp7muMiipAc19HwS1CDTdd357JLvFPPqTUvWzAK6McjCtMlI/RzkRV5dbMnpBZeH7mShthR+MUUKa6Kf8uyE2ldrbypWiu5CT/G2oag5zOFGCR1L+q4L+4nRUqJ2NE+eQIrejmC/xVhQShmy085IIMzsGsbi0IqoNzrJ9Hj+IjbUjiL3kU5pa06vGHvdDimswtqjOFgOVMcsii73dJF+sVCIUzNZlc8ePoKQvFMQ8JxoixuJ1xndsyCUfwHfj383b4nyTIg2vp6AwQM+qbbBTvMqYd0Fksg9MKGyLHsbZnvA8tJydrtxGJZ1usjZTKx1bGtzfLfqKhRXaGjvroJbYJSmPz5Xa4BA8dVjHZYtH+HFC
 ONCKteqm
 vQp5W3HOkb7f4phUuOnvctimLDnC+fcPee3KilWVkZpoUlhCldJDq94rbcBceJx6tzl5nxYQYG/0JzUoigjVWoV5aOln69jNMUvsLD+iuJ5URxMx7fptFKapRA+vh1UglLKVsSyMdu3fqlMe1N5inZ6UkYQZtQa+KlSge91CA09DviX8tOv2XUw2OB9z77n6gBYHxhqqwbbCUmOv/jRf/0VRZgls8WBf5SGqIo9c1/0h3OT42FG8ipra8wU9p+LLL3F3Y0aA8X+JBG/fX3k+y/dNmljpdgiVlSJrFNZbrIraPMAK4mS2i/NwlS6fIEDf5XKUQuZ9TE+pSGesF2AKgLZq453ir4keC5eZIsMAZLcYTLjbyVtA5oyZ9RPuMF+pfyTAEPuLqngs9LZt7RyIx3x+KaR2nCo2nSB9duIKPYXIVTJisvC4BJyzK3J2OqHsOF15y2rUWINYbu/cwqr2bfcWJW16tOKJiZcW0443vA8WGd4Vgj2/uTM/Jk8GHPAU1Zow+ebNIwLrRzjYd30GAus0lqPTYyoqtk+gzG2qmXJufeQ7fu9liXvEXNrY+00ciDlb74VciJgfwF+10kT82TBc6aoyG8yiVFyDrxXGxjO7wN86TVvIALO1VbQcJXlYzcKQXGgcryALBbiAZZGl+E4piWk16dVjJeT0mhH303f1nttcIw9YKZghV5kmID3c0k7y3GXixR+1qXF5q9o2QD+TG3W12swF0htRMmrXP6U0BiNkOBpmZ6a80VhCBv1MdM6nLXttYVBXzOPt9iXlVor0Nhcih+RKcyU1w8mBqv+s1Cod72OSh5rEkQkfgAsIwu/LxCdF/rA0lXEfqkLrxC+nt44pCCe2hQjSthIGFkd0czx57iVveJDCPa/3DIhJ8/Jxbk1xoazojc6eepwGd7FfP43/fp5SCcsP7SiAQPI0OwQy//PHwwHIUSugZ5rg8rAqJ9VWg58d64L6pIXLCba2TiPju
 VHooeIPz
 ZZweRpChnNrvTd4pYDcHPgRQkGuP3aC/isc6dRbkxN3T//Fz7CoIhJLQUNfPDJr9YcxQUmcjc3HrGcXU3fYEEZc4YfQTemdMW618ikFl56D/aGgFphaafEOG5+sR4JE4VcbMsZPEjG+qQzpms6kmE2dpDokOw+vcidUtPTx6zjiglVRPOtfBYlHbuKG5jK4wj+eCkIH+sj+BmkB0I+jd8kw8myIRmfkfw/TFUsD7stVPWHCHN3jeF1mTb64rLzWtBmEkPcYUYIyGUWUuz6NDW1HeMgpJkfnfrAylZp0MnxJ3JTxPGi2QACYNLPMXgyFXOu2oCC6qnse2uQcCqtQuyXTImBcpyuFGUV5X1f/TocLTYRrP5JBQ5KrfZ5LKiNyU0vups5gc4sYJHx96fpf7wvEw5ymxbrmL56PQ8KhDKr+O9F9fR6ENq+qUfAaUVp24nXsfHfO87ZTCIY8ATIvLsC5doyQZrf3U1ORF2XEtUd+YuxiWr+A2Dy0T3ExM+n46vZrDXxCkr5mI6XmwxPs5xUX9dPSL8gQ0OezxyQ7qmlcGQOa+QGJ8AhGf9dzmlowlE0KTqUEgWbvD/NFXNQArDAbTYZBBqV8XSeOfUyIFfw1eUmv30sUUZjv3GlEX+VTillQ9lEN7s60+QayVISt7s0n14xGrlamDoEjIAmtGoyuOHaDkk9Wn67Sfa3a+UjMxq7ICqBmThYRK80XdUHHkz9YRItReH9kPYer2bgt7gqOE/3Wz/5csqmE7hDBA6pzgaLvpaEwIHMXW/l3zXhm3gmZApYygbRqZz/k0u51EoRXBxB5TPG46SgFDfNfLgRGnNs4zJILVIyeoUDvEuvZwKv5S360Z0HUbkZm48RtImporLyU9IeeXwtmLO52yywpVMotWey9niOmpfpvFONbs4d0fZw7jx3YrtEUESzNyea29jZbrvCGyUGtO1jFqF7Rdjp8nj71z8EM8g+bW0s0OrbiwHB9VF
 83fK+d9M
 5QY7jPN0Pw5NOjzsgK7yP3+3pZezc1SeW6x9MQ//FmacI6q1W2VN1/TPjA6hSsRQAmy6USpfB2wXzL9mGHHzCCvaq5un3NacBKxnKBlAhgVdrvIdcUec6HTvq6omI7vB5V0YIFjLOhZdGGvV7vmHZLNjz8vqLlvxhOqpQ3Q12nNcJOMEuDdglyZ3w3IFA4ZnR1sIJoj8yaDRgO1a8lZbCrXaechaAosh8gl0Vnm2dqmy0ftrfLXhHkcyrQudLDT/O0A2q7Y0hLb++Lc07trtwoSuLmO47ycpztN/dqKsiAfb61jz/al8RV6NlkN8BR3nSfduxKQ6xHCpNNSG5WNwEUNeWuVpPnS2i0+K27beFV9QjlAGG/SZqsRAK89B+nYRh12iwevhdSbtVhoXNX/at63igpXc5VoXRe9p01s9j8J62peU8ffnlpcdWU3OVEDpllaMDZIpmWUcjczHC2Q7x7BiWXs6K9Y9xl2ph5aoaCtfTZ2IQmYhOYx8uhYKVe6XO+m9YwP8f9wdo1HUnEsWjVZeB5L0cucwlDRRleUDE/Doizn6GTdcEQf/UYjRB+c9whw1cAqM/bkyan79umHfZZT6SlA1lEr345Lu6XNQ1a4dGE0AybejTb7F4AcIPP9S14AlsgCMucCGPNYCiGcRq9GXnV0IPxZJra4KjX3tUfrvYYVEO7SK7tN0yMcfvMkyX6ft1A4EL5M1+RKD7/RL0unq2puje7TddB3zw3St5niMYn7NrpXSy4TxPAEKkunbgVhXhtb57d5b9wPQCpUD3DPLAOp3HdiXr6CT5v9RcmnKnNdTQWr7lwxYgWNgc4HbPa/9bs5cchNwGUxi/gA3/NP0/7WbPKf/Yxbq5GCf5ZsBY/Up+mun4m+v+JLBF5mBn0MAI8qwOfFL2tFjoaCal4mASAR0SCBzPAqJklKobtn4WxdDqydeiFOIlHB2yvai4JSKvGl78ijZB58SJK9NZSgd0WU8i
 Gy/57Y9U
 He8pTyVYWo630cFNk5cS7slHaoVQRg1PqmiDETDVG1+mO7G5qtKF0v4UGaj8JShuidmImIFyNLn3XAquGa95GBKzBkbHpz/HflprsmsURY2a1ifv7XiO70zlq5PQbZ1WHgFoPwe37pFj8Cc63bHIxBdTLOrX1SQtxxA7MMNjpQQ7yoMjuXZNPIIaCoBMhhbF91dR07G5J3EFpdn0mrr2MbilDPSCVaxPs3TPXNi4whoYyM/oTn1pE03hyTu9Ph3fKKaBoHv+/8T6QtYJfKcz7wMtFqlEqVbYH7eJ8CKQHwmpNvSlpqj3BjEcDJ2m6r2DTZietVWQdPGiDIk4p3MV2vQo6VX+LnbyA/MgnLNDwu5+I2Cd58J/FK8phvpeHrPceYx1xOJo8lmH66r6u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 71ee9b16251ea4bf7c1fe222517c82bdb3220acc ]

Patch series "minmax.h: Cleanups and minor optimisations".

Some tidyups and minor changes to minmax.h.

This patch (of 7):

Link: https://lkml.kernel.org/r/c50365d214e04f9ba256d417c8bebbc0@AcuMS.aculab.com
Link: https://lkml.kernel.org/r/f04b2e1310244f62826267346fde0553@AcuMS.aculab.com
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
 include/linux/minmax.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 98008dd92153..51b0d988e322 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -51,10 +51,10 @@
  * only need to be careful to not cause warnings for
  * pointer use.
  */
-#define __signed_type_use(x,ux) (2+__is_nonneg(x,ux))
-#define __unsigned_type_use(x,ux) (1+2*(sizeof(ux)<4))
-#define __sign_use(x,ux) (is_signed_type(typeof(ux))? \
-	__signed_type_use(x,ux):__unsigned_type_use(x,ux))
+#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
+#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
  * To avoid warnings about casting pointers to integers
@@ -74,15 +74,15 @@
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
 #else
-  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux)>4,1LL,1L))
+  #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x,ux) statically_true((__signed_type(ux))(x)>=0)
+#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
 
-#define __types_ok(x,y,ux,uy) \
-	(__sign_use(x,ux) & __sign_use(y,uy))
+#define __types_ok(x, y, ux, uy) \
+	(__sign_use(x, ux) & __sign_use(y, uy))
 
-#define __types_ok3(x,y,z,ux,uy,uz) \
-	(__sign_use(x,ux) & __sign_use(y,uy) & __sign_use(z,uz))
+#define __types_ok3(x, y, z, ux, uy, uz) \
+	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -97,7 +97,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x,y,ux,uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -114,7 +114,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val,lo,hi,uval,ulo,uhi),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -154,7 +154,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
@@ -326,9 +326,9 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
-#define MIN(a,b) __cmp(min,a,b)
-#define MAX(a,b) __cmp(max,a,b)
-#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
-#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+#define MIN(a, b) __cmp(min, a, b)
+#define MAX(a, b) __cmp(max, a, b)
+#define MIN_T(type, a, b) __cmp(min, (type)(a), (type)(b))
+#define MAX_T(type, a, b) __cmp(max, (type)(a), (type)(b))
 
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


