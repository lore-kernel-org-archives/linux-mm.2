Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B440CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755028E0041; Fri, 17 Oct 2025 04:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D83B8E0016; Fri, 17 Oct 2025 04:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1A68E0041; Fri, 17 Oct 2025 04:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C96A8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E03661A0511
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:28 +0000 (UTC)
X-FDA: 84006899256.01.72005CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 13E2320004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=h+wMG6Ng;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688987; a=rsa-sha256;
	cv=none;
	b=Cp0OIgvhdyYgTDl7aolpSpWOjJdrmljPSmPx+D9QORTpXHk+BOzNRd7Yxj9guhrc/l6uCe
	6x4DQDjSVuSfH8EELY3wfbVWXI4vfyT/aPUhtmRkitmooH/cRlXdYjUundOEvq2EXbQvV1
	kpetL2Nmc3ZIrwhUNocYiMifn65usdY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=h+wMG6Ng;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=C7RyBAHhVQ4o2EysBNWuU3Me8aZq0SKFP2lh3ql8pg0=;
	b=7NQVfiFjwsv8adWwiRAED3d0DTi769NrlsyFuZOdWpCHxS4UdYUNkWEfOwL6sXsx/MSGiV
	fumsPLw8RaPha17U0UVV6tkreTce3qyHHrUGgAQqwaqsV1Y3tdtFE/tfYw9q21MW8AiE4W
	VMvSIWGO1g4F70/5W2Lw/7DILjFO3yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D80B40B50;
	Fri, 17 Oct 2025 08:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C33C113D0;
	Fri, 17 Oct 2025 08:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688985;
	bh=DC++6T8cLtYDvUyiIc9K7pUvzOQT8Sf0YNowiJZekQk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=h+wMG6NgTxeDKbNQT1HhYDHtB2YTAp373Bcih4jENrFaZ8fKQbaNmnVgoyK6uIMg9
	 vJJllbxfnqlW+ThzcNPkVWrO5cJ2F7t5D+R0GEdfJn5jerPyIsSkWKGQH9WnQITcfo
	 FDzCLi1UmqcWh6G3Z4yEgFF1eLiHdKE9/vTvVx7k=
Subject: Patch "minmax: fix up min3() and max3() too" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, bp@alien8.de, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, farbere@amazon.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailm.kvack.org, an.stormreply.com@kvack.org,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mripard@kernel.org,
	ngupta@vflare.org, pablo@netfilter.org, peterz@infradead.org,
	pmladek@suse.com, qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com,
	richard@nod.at, robdclark@gmail.com, rostedt@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wens@csie.org, willy@infradead.org, x86@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:16:15 +0200
In-Reply-To: <20251008152946.29285-13-farbere@amazon.com>
Message-ID: <2025101715-idealize-morphing-d39f@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: yzsn8cgtzo3jep47aecck76qt1k8mfd7
X-Rspamd-Queue-Id: 13E2320004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760688986-913295
X-HE-Meta: U2FsdGVkX19v4DwcVM4NtabUYkRzW0vAfu901n4p0w8krr2HR6EqQ3cAU6X1mFPvRL6zSia6uXYuLjf3rIv8vKjNerLL5i9oIF2IwAP9NggtlSrS4K3RaTEr5CQhKGm4l5HY/PHsiFz/0+CdL7Ndimz0b/80AcTJ67ISvgRf7argsJo/mMuwiwKgzSYKpAzdAhcyyvfqFMoMqNqq3dtOoV2AuJxmMOM0soneKrV3YdLqgKdlIdshZqfvRbJjaTWN2G+/+zONTOudLYV/lXIzFWIL90BP9ANaGO4PyD5FruCou0iRHbJh4yscT0qaQjZ5PL534yH/l4FiWnA7d7T5j8rHIQKgowBdg823fPkKCYQBpbrGjTMnKOLK2AM1GMdpkbYWlt3BSrKP00R8UQjBK4907mKdFiR9mL4qLNADFbIfhvQY7xFyftBmh5kEIizNHNmctDo2M5gUDjAieelGuxFjkR+dxqvZgrwRyG+INAguii9/gh6j3C4yCroThmA55lhoanDTOn0vnPFjlFSRpWVP2HK0j6dx15aXs4riL7nXUUoYKWLEnClFVTnpRRG6HQORl75CQkQULj6o/VIACTynRpMV/5wyrX9VRYwfYiodVZSQXJueAZmmG0NSIPwZ4LYIud7DP+cQ/9l7QD520wjNPI6BV0qyWUZFLG71DaSF+3FqkdGwzkmmit3CZD0vOvqAiB6ACZJOsLKQBI91DP67rImQduY4Zb0OZq10xteK7YHGIurvuTW+50bQreMz2pP/bV+Db5arP0ZKKqqotowakp+6fi87dzdW9bB/DNfuY93Upv3LYyGvtWeQ+xNJehLHwx+sYWxXEZ6L6v1mrTA61HDpU33fHMcs77zibAc0bp/GlF+AAX/Cy/qqRxfmDRhJDyej+J96eGZvkOCbXDrucdPPUg4FaSwOCOnii7GkhkEwp42cwTl4yC3+Ec2MbURtPiRgptnbvDlzltS
 AnzlfiJ5
 1XvUOwx+bAxNrHdhCReklINSSqhx4v5Lkvg3qjyeUrVpvDtUL9/yRVdBtv1pmuMoKBsxsPr8dsuqIO0eVC25c2fyb/jA16srziz92aTSrJsDkId16bd1sZXLnb2l1LVDsJrzOnIgncR+Xq1s6ogHNhMom/rP8uK9ISbC/ErpCYkqbev27cXCyLu4ipOjohdBWpjucJ5+W/5mLg+b9RRvKJAr4YIaa2ddFq6xP9vWxSd1Pt6uB8XEWgf1yROhTrocMuw75bMqE30fJ3ckj9Z2OoJe1fCmwWwmjiHx8eaThbyb/EfojscmUr2tqY5LJS7mIzG4faMwlTZXWco3Z97QDOhz80Re/28HAp0xQxhkxnig6IbaD4VARJn58PLcoXiAVM1vx4lYg7UXoIhmJlLbUkKmZSVs1su/+PcUeOQKgU6vUB7u4cF+aKzY2PpW4VwYyPbhgVGdw61NgaiHx2tybl0cHP/iDfhZM8+aNnDUs+4P8TfAnzaqn3uM/Kce6u8SRX1de5Pion1aWUxwPYlEdztt1rbl/6ysSyH3nXbC8LS/eteCdMZKOn4h8V1O3ZypPkiEjsWaoHtnkRSOL23w3DR6JTSwGzhGfTjPWonFwVB46HyztvOuU2oW/rRaY9GA4LvArGa/tgd2ECX20Hhn3A9v0OokdxV1cw/gNwwrglxxGjEpO7c7QQPjFJosEJaMpF/MZWICpGstbltcY1O9dpuArVdV46lCYgzucp0cN4k0m394xoZJr+SGGkPdz9MynBnFw250/FFP+8n+PKRAxw5lIHQiliVAzxsC2Lmevqq2hlA0Ty25fBxH+3T+Ao/oIDaJq/HBM9YpsH+ixSjqmLLHLGjlSnioe21xiYl8t7hvws1BGw2sWQLnZsnn0TSoWoi57L1n2z1S6s5+yanDantMH5LtA6Q1yibesk6xXnInQXhLxTH6k/WF3XFl6lKvIpQllGGSYLnp0Iku0CrRKid5jQkYW
 Jz3NjunG
 bHgC/vJ6HhzwmY3z/103FFY3HYkP9xeBmp9KMZ1Fo2kUyiaffcbVoucd47uXQQNk/D8PRNg49hzBewYRjLnOl9zqPFZuGCE6epX3Bqf5u6pNZClniqrtOcqw89E2LQWTcOQqSd58spNunS0ESbCviT5arX+0u0FXiMTUAOwX3+pGVh8QaY87oEctxg435U06031/GfFFKAcaFKKuurvWRI69X1q7gaj6Rq4hjNdS6u5wOZ2uIkN5Ri5yZ6APtZX39g64yNx/IFgnWOdd0VAOFZeiiwSNIA+1mV9xnaN3imbsldssF9F9fYt2WSf2NyS4arp3CTE5yB1dVRNYvoW088raJZXyA7+iQVmOaDXAy48eLIOgI0lBAHcjSEeFuj2Znc6Uct6hYsIwbHBhWpX9UCcjKVmyd7AXZFLY/NQb7DMjYTM7hYln/fC1x4I118s8NPEvZRkmiLfzcHqUdGUSUPOfpFRwjbKjYW+wXK4cf3ArmsbP9OctnBsdrqLYlDjY/i6j9g2gtgWkSC2ZYVFyfI4nw9BX4ixBkmHLG+pHPPS7uNV8mrj2NTHGpPYyaJhrMWn2+ybj70f797QM7RxNtTS98f1l7DzpgKYfq/tezwZ+WY2BlGy0TiACPEhOFedyTmVxJOvxyAKLJ6s729qTo0i1GKAqdv8unmp+NGnNzczbIjbHQgYf8YzJcGkiJu3tp5I0rg5FvEnzq3GGlzCCE9tao2/N1dvMLAJFIbJjidszl3E0JRwxc3+JZ8g4GiMf6uq1wJE3XsmR8r0j7UkovciSTyVVJ/pBKSHNpEMev+1dFfAD042/rgE9VdF2IPGulocfKZ1dFcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix up min3() and max3() too

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-up-min3-and-max3-too.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:33:52 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:37 +0000
Subject: minmax: fix up min3() and max3() too
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Message-ID: <20251008152946.29285-13-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

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


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.15/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.15/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.15/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.15/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.15/minmax-add-in_range-macro.patch
queue-5.15/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.15/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.15/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.15/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.15/minmax-simplify-min-max-clamp-implementation.patch
queue-5.15/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.15/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.15/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.15/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.15/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.15/minmax-fix-up-min3-and-max3-too.patch
queue-5.15/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.15/minmax-introduce-min-max-_array.patch
queue-5.15/minmax.h-update-some-comments.patch

