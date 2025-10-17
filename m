Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDAECCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9C98E0046; Fri, 17 Oct 2025 04:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79FA8E0016; Fri, 17 Oct 2025 04:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69AA8E0046; Fri, 17 Oct 2025 04:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C02FA8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5977B1405A5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:44 +0000 (UTC)
X-FDA: 84006899928.19.AD0E6D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DF52140013
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=oI1Uhe5G;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760689002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=7HhQZJS/85YvQfKAOxac8KbDp140fxc0dyteV+jJ6Fo=;
	b=dnZOSfuJcTW0b2PEmAd2qwNJ0SoXTJW7KmwhLJ27IYBenAPm32PN6QDa6QnDtYMCersgpx
	DXAWbrXO9dOZ3VgVLeOnFnNLMdY4rTkuzLPdBfMPUrizgjgiBQoV5+4aPez3fT5bBu14fg
	cjxUQy2ZyJ8fIQTq1Br6aWL4dzmXfSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760689002; a=rsa-sha256;
	cv=none;
	b=vKi22px9XTb1l3lw+tMY8ia++3B1k+Y7RzUsRYH4uMBXqpgB4WY0ZMJNY01Y/YETHw0qkY
	mFGRuCZeKY2mcuYLP93vkTURe4vRasUrwdIuAARfTnEEpJLvz1yLOWG5fX8heab7kYLhnY
	hb4UDMbzvDfJsA5U3zWntVyaG1FYdN8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=oI1Uhe5G;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2FAF44E74;
	Fri, 17 Oct 2025 08:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A940BC116D0;
	Fri, 17 Oct 2025 08:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760689001;
	bh=ryQ7jxwSw2w3aaAlLPF5d10VsAZTn5w59tW8dCtaV+A=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=oI1Uhe5Gb6YdVXsuOSPri6sGvkN0hOF//tRQdxDqsG7LG542/fQIwKcM66NlYcyQf
	 3XL4CpTWmiyyjRcdhjEegDtjR9J0IOzLK7sBBNNwumDgxWDjrpIqO+I8ls9XSLUR9r
	 /eWjs5MGwAyXc6jkPyPyqjuN1YhjO3Dc0h1h5A5U=
Subject: Patch "minmax.h: reduce the #define expansion of min(), max() and clamp()" has been added to the 5.15-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, axboe@kernel.dk, bp@alien8.de, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsahern@kernel.org, dsterba@suse.com, dushistov@mail.ru,
	farbere@amazon.com, freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, hch@infradead.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	josef@toxicpanda.com, kadlec@netfilter.org,
	krzysztof.kozlowski@canonical.com, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.o,
	rg@kvack.org, linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@rasmusvillemoes.dk, linux@roeck-us.net,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, maz@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	minchan@kernel.org, mingo@redhat.com, mjguzik@gmail.com,
	mripard@kernel.org, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, quic_akhilpo@quicinc.com, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@redhat.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, wens@csie.org,
	willy@infradead.org, x86@kern.kvack.org, el.org@kvack.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 10:16:18 +0200
In-Reply-To: <20251008152946.29285-16-farbere@amazon.com>
Message-ID: <2025101718-perjurer-eraser-608c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DF52140013
X-Rspamd-Server: rspam02
X-Stat-Signature: uoec1uxbnhxje9ji7xmjyh5bscza6kgd
X-HE-Tag: 1760689002-976002
X-HE-Meta: U2FsdGVkX1/HJIBvUyYxKo7/iWdJ+2CXkUqOlZUKfwx2/LUsocAn8YhHXuiMB21TlUTS3wrwuzPcG/yiYdtDU26K3tKe9GkyT2avTg87A4w1S37m9TEF59SBwysX2+v3sfmruKicnnLCIqcHyJC/KVDY+HZkDVS10qgtsHJNw3xb36u0zRNYuA+hNkY4rm4uyCCt72TbO3SJ/95BY+cTvczHv3/95Er5wYRvRHNreabw/LcL+dJ21qMEV0a/pWRXx8tpkzU18HAbpCaojeaha/GsfULNmamEF9KZse3/EldA5JaCLC8+6g5HiT/fHMwP6BkRrqSaD/1L0hjvUD0z5W85k8KFgxTPbbpPenMDoMsMR9jPKVckb3OA29I7/F4ZyYi9Fw+J5dVe2lGgiJ53s5+Gu3eXw+OPwCOAvQrbfxdFocOAB78SBuhR4FbPWyB1GQ/yNa09HjYE1hje0yEZ0gKgEs883llBjRv+iL8QX/qNUTYkRPri3quL3Hd1gyyjGW/msx4IcY/0rbVjBxw79Qc84G1GV7ocYfR5NS2JuIe1Q0PA4faei42eODA86YgskHhvCr0i0gybOR7lncCE/oDTrrVLVaASL7I3QIxoLCoevdvxhTp/PyAvJSr5+9NQsYxr+XprxsvNj/uhXAeYXnw0sFHvPUvHEPd7oYqfgo6CM7bCPh1Et4ZAcZw7AKWyDESP6kjno/OIFnNhbpWScVIK6r8o/salqkIngbcKeqDQUCpM4v06G8bs3KIiTYDIsnZXyFa5zjeYaCoPg7+y4nvhthzuwNz/73DUKj+H+wm1phbpNYO0mBEBAVPuRIbHscpYIq6mgu0M4uOQif78Js44yTTJ8zihj5xpQMSSshfXKvuTOoiPYKm+aWo0eGGn4/bcAv5h0GlOgKwW2B26CQ3dx1jKQtpCLVvg7/KR+LyeH0+4nO50IPwsOhYi5c2cE/gQVZOUXNoP/SqndCx
 W8yXV2UZ
 Vrtb1UWMXqUWwPsN/62G/vAnHtNBOgnJs55D+w+k25X8yNBjwWOUXoOpZnxb7ffAfohu+WnYqDk+z73Cx/MmijBSY2IW90qfrTIy/1hrgwWkaL2LvGikKXlJIrPCzUqUqh9CbJ269jSMPObwQ4MDYVUgQHWMLnWLEzBllvKpdH2mhOTOZa6W4HVtCyyoCJfqYLOHsg+3e4MaGnqaPYN5bQE+b7eIJuJT0aFioD9HsOc0KG84KHqRK9DQR6UG2c/JKWm55slsPtAavW1ROn1+ACTc1xkWx5vk1qcFQoBSF3ZJHepQ1KPkZvr7R6wzXiSpBEgjHQo9nLS1sUqVm+CbodnzUfJgEm4rzWwqqXKS3aTuXq35p90Gmm7FJWtwhrWOseOKWqyyGoMcrFXsbcwtobVxRppbCQ7kMAHYkvk+CZx4L8ZZMuDQ4z6dFy5GuvvmWl6d1VVtyR7RiYTdAN3ocW7VxKdqj+wOFsuPnWh4KWPCxMJgBZUqWR3zNAT6wgO0qWo8SxvIqyw9PY9ELNCdjBqjnaui6Bkfc5Ymu7ug3P2iafxQrjFfx67IOF1x4Bfq//NdZyIlsayEEh0Ga5cTKiwk+1hEoYQqWPTUKe3dtU/VFuhF+WjQ05NESAgVZmZrbpSFkTJLENQlfCGxbRbJCXPq+t5lFUgUpdw4eV4QmwyYQ41fXs3zbIAXVsDFNf9boq4SXlQ860Hdx+RIi2EVmLpcg5UltxicgPfcAQu+4qDGo7PxnchzCYZfewdRDNjToaHrrtvWPBR29njt0McPXdiTNPLPEUDbs3NnlUo1PHPpFiz5DxyqjVoymt/3xHI3gknaBs7MeX2EO7W/3GBJnXhxrP5Lxbe4LMvlUp3blIymv6Tc1kRG5GUwXxEwLKDMID3z9oXHAlBzHYW6Wf1T4iIVDD8U14ZooHbr1pB6mKqMQC1GdJewygc1EBTJFqVj4sBT0DrVssceD1+/LaEwtAod+THRA
 wKL07Z5v
 yqzrW1ruBCqgItrP3N3NC8Nvf1fPLQeCHocCFlh052QDbN51gEfo3YQNRs+Q36PF9aGCJ+woVQ5ZK6Spab2IopbnmUIfeR0aeXiBpFrgX40SoSfyPoPvj0Uf3IRnwjQfBi6ERvMqbY7fsTxlajNB2qa42YiVx0QzUH0NumAfeG4vWP9Cd9zbD0j/aC+8sclwBiqrCDHGGt/5zCdpHFYm/yDSVDM1yiQhR9ib5jYcPivmBg1YDfb6uYW3pu4VMvcepBHfnfytkKU/WfbXc3Qx53KbAZJIGOTbsmOs1yu8zTZS+21vtwWR1Z3pl1tFGleHQX0Pydux8LmAjyOvymY46ACOMFytWM1IL+JLDMleNsDt7uPKGqewnL8tCn4y+7e3FbBeW1S4OLKiUzx811zhnWM5Z3JtbC72kg55K/RI+6I4IENYKj45VPcyOelMViP4JZE/dCJ9zS+oi3VL8KX6Ms/JiPnm4tvxmJE9aBigBFoR48BNtzNv3kPXg35TZkFrlMzXGshrtvd8+KX4NxM8g/9sfsJ0hEc4+gmRZuZAAjBsC+oiPbFgQrH+mZs/1DJIJW1oNbn54uGWEAcK8Gh8ICSGQGv1qm7JSKi9uAdRusl7+Rzr3KO88yTphZdsGo8CNJFRlxWG5WkowQKd1xOZcXDs/XkgnR0eeanVXaakeiUWnZCPxmN6ovymzsSyeVNX8FtJzCBMd6JKi+l+02JNWk5087+oeNI5ZcsMlyC5TxNMjlhezJGQT34rwcXYP1UzKqN4Jzdd+/QCrwCh2pLAYsvtwOKBStY/UwMmye7qvwuUz49+HEqnCVdnK2FSBeruhcAwwESpRDPV6vmsHh3FcQ4j9YmwoFZs3XuvzdvqS+Vd++dZT03uwIK/jDz8nF+R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: reduce the #define expansion of min(), max() and clamp()

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:34:31 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:40 +0000
Subject: minmax.h: reduce the #define expansion of min(), max() and clamp()
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro Falcato" <pedro.falcato@gmail.com>
Message-ID: <20251008152946.29285-16-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

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

