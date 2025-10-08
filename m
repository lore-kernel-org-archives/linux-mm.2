Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13EDCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8308E0036; Wed,  8 Oct 2025 11:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8338E0002; Wed,  8 Oct 2025 11:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270D88E0036; Wed,  8 Oct 2025 11:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10FBA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:33:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FDE811A94B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:33:55 +0000 (UTC)
X-FDA: 83975342430.06.060924F
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2700D14000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:33:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CIsLHFA6;
	spf=pass (imf23.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=rYcTVUbRKZU2jo2vq4/7658Ng9ucQDQwqO/aRF9As/snoXa1MEl5UczOI5B7gcdgpfRYlC
	D9Keg1+l6YAylxo4iris2S+maISBOWvEae9EVSxIYvlV2Ta2chXEyZQum7Lr9YoGoSXj8P
	I/5Aoj0RAS2rq2jHDmSHNJiJ+JkERzg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CIsLHFA6;
	spf=pass (imf23.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937633; a=rsa-sha256;
	cv=none;
	b=fZ7C73ldCiq8NsleOOcSDqJMlUucZZFVFSJoZmvJJVf+E/ol/LkARgRnh4AQLJiyJwPTIX
	VYOSoOnTJwpJ0w066B4kLHqRpkqmoQh391wSIoDgl5gl0Ee6xXRHoXPetbUndSQ65eGV2B
	PkHtNZieVoy31zK+YRZeFkxZgLB9Uhw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937633; x=1791473633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=CIsLHFA6qEF92uzVsiOvwXzA6MNKck42NrU4g8IBAhbR6wneZC/7yjTY
   GfSU7RQLfk30qf/XKwRzhq0NRx50PwI1I0+e62874iGkZkvYzGwMwdjU3
   uq4c+P8ks7XSGHlHA3Zy0Jvqdp4+5O6+kx5wYiEsdJ+Me6R7kAJtqnrd2
   M4Ou8lEmCLPRYIJJwZsWvy1lPZbKMIMpA987JRnkVcj8yE9k8j4uAdK6V
   yyqvVVm/tQyaeF/aCphObHPkdiFPJHCaE4LkgQgzBsVRd5qVpG0vUK9Z2
   eKG/VUT/Ah3sAgmKW3d5HVJ/mTx4WwAvLREfUTjK1hqZj2oOY/MnZcOmT
   w==;
X-CSE-ConnectionGUID: HeQ81hJlQRq/8IVch3IyJw==
X-CSE-MsgGUID: 5Exl1sTYTEing268rYU4Ig==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="4533344"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:33:50 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.7.35:65265]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.171:2525] with esmtp (Farcaster)
 id c78ccf7c-b90d-4f48-b1a8-610633d84b7c; Wed, 8 Oct 2025 15:33:50 +0000 (UTC)
X-Farcaster-Flow-ID: c78ccf7c-b90d-4f48-b1a8-610633d84b7c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:33:49 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:33:36 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
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
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v3 12/19 5.15.y] minmax: fix up min3() and max3() too
Date: Wed, 8 Oct 2025 15:29:37 +0000
Message-ID: <20251008152946.29285-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2700D14000A
X-Stat-Signature: e1tidsqyt41ofj833f9fuepcymhej7ub
X-Rspam-User: 
X-HE-Tag: 1759937632-531799
X-HE-Meta: U2FsdGVkX19/FGGMFyY2QXqPZalF3/w1La3mslaKOM48LKCUQx2UYzqaLkPmVOUYPFcYIhSOiAX5pBQunZ3ejq0ELGSiRs/EjfLss6IehfX/M1xDK0zikMY8KUn/epJgYXMuF2ZKx1/U3xeX5vRH2vXPvdCkeVH8LnSRosnMmGna6zWzC62cNHtAlVbY0RBoZNtRoUiFdTRswJgqrOpIFMTgke0Xl0ONY3QkLEMWtruT5O0WWemLdNHMbrDVLMgmoRAZytfhsKen4LW83CfUexzaQ6fF0shIETs8myn0JWsDmHhJfv4kF0v6TU2gsb8HRLESxhRD48dwN5IBoMJ/VYH7wML8Zr8Kn+zmTt8SsqKM6NiKBX8QVV9k8bu8rCQ5bODF624rdfdGLMs3dn/LJBrYRDkdA24cTFvg08HZal6oG/zvVE6wlvpebJZFK9J+V+mvRFe3DjMm13JHCm9q5DBeg7i2L8Wv7PHHbxxV2naYsLaSHxryYVLmquHYc3zXHvGoV1iamupbk862DjUHncqpQU/xuFbg7BgDMjSPxGe0TR5p1HpT6YiS25yJ12+GYCK9oJFqOzkYhoTmzfFkGqdxeikMfcwQuJRLcf1hHECy1GWu9HALY3jjEgKPxYOeIPGa/F1FHYMTP+MPQ1Z+qyY2kUuKCE+SZPNQRQvq8lsOLl0MKyZ3sv4goqmLeNcp07P8Caz8xUyWYhKPqCLzh5ISyUu5JVMldS3SWSgKuwk4RKBzIrU7tqPsUpwU8PcgPWzdOPz33NSr4o2uFauc0QFZX7aDRWhxJkdb4irtF+f41BKlUmgKiOWqE4DLKNRwKbbH3xCzPceMtDVcZc5iyMJ4GilgECW9JLOaqXiqxHL91AaBSfuf0Rph4WuWLGeu8SHC9KgXIpS+0hXpDanDAlKMy3zbtNXXZLoXIXMO96gpLIiiu5x7BvXeDvUF1PKYsDUJDAtr125g/Dpzm4o
 kvoPVImk
 FCmXDTyjbG64iPODiERtyP7oqzo2uOonhW+yN8Yo4mnyYzhufJyFGrjrV6iimYiZtjSVTgQqJG6xP/QYV5N5/eR0BkvbzbX7eMVKXUzjUi9Pg/HmkH/tONWLHTwjo3bPcnzdPuagQ6yce6aWQALJE6hwnLpZ8SUrv87Fc0mxEWZtuwXDn6hlmRzn0v2aQP1JNM7g6yfCAooLBqhJz4ouaOQeaPetRk3kkLKEosinfs0lWbkBSQGrBGhQlNWuu3iMz04VwXN/bTe1UiPO7ghwnptd4V0k4r1ZPjoN9V3+yLrDyb96FnKg/Xi/amR9PvHNixWFpbQcDdK0ZoCq9kUw5DX9P72qWL1xg4vtgnmDDmWxqfFzep+vA+ozvs0N2HbmqZfY/rOT2HaE1T6xPy5ZgaCD5ik4cOhm3LOeB4gPwRZHR3E3Pgpge3KkqpSeJlna7yUOqE7FzrVsvv1bx/GflCQKmk5ouqxIYKVDHI5hFU/5Q8PmX+qfulfoCqLN0bjiX4M/Q0Kx4UBdA3cWgUid0/mKJ7VLd5rOYrGvGvsB43E/Hk5c5xnMPZfLimpZBAyUYYI5vc8fAgI+UZfi+07tg9MAg+dU2+U4P7009IyqZy8rKdMdNx+h0aqPHXWF62BU6tEHBKJI+8rUQTkRDTcH6razjt+cf27OKHt7hFzBpDA+CujlKFjzb5cUwNjKpaK3VFmzM51zWsQZVxwInxQfBdj3hteBnBn/EtZDpgEqBLJKt3LXwk7ozpfJKwhbDVzljP3ztCEOyrv4QiNJPnIHe/v0qLrPR4oXByXMJQEY1N3HDUaF0hftV33pyKKY8d1gYx/bBBD8b37/lxPc/BSaeOixqRJCZHP/nVuxZK17zZ3+rsXIFxD5ccC5XN6MEaxb6EwVT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 41da6f85a407..98008dd92153 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
2.47.3


