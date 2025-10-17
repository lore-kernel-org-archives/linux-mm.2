Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7E6CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B55B8E0044; Fri, 17 Oct 2025 04:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811BD8E0016; Fri, 17 Oct 2025 04:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA9A8E0044; Fri, 17 Oct 2025 04:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 549D38E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:16:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A71D59D81
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:37 +0000 (UTC)
X-FDA: 84006899634.05.FA66404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 81872120004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:16:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=CttVRc1y;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760688995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=91TQHyFYCQbrN4bXNxgNhn3a3bEHec0Yb0ilf19zAZA=;
	b=y5UAMyOvg614uVUeNCdzdNQJXxMxTsg8himBHUnxdRa1TH1gepmfGFheLzS/Pjvqg4v1uD
	wolHuKx+Y3Jtu25zrZgywNvheW4rYHGF5E7HUpRdON9QnAuWeYs8MTL04DQXM8SyeGnXVQ
	kMvPExlvTAiOM+o9Z6IetbIBtTtD0S0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=CttVRc1y;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760688995; a=rsa-sha256;
	cv=none;
	b=eplK9Rd+hrJZwEayDlpeKJNP/JimNo+/dgbkKWTNZajXJvG/oKey5HP/O42leYahe7DaLC
	701FzMnvpAEbaWM3kJZBchIvo8hDToP0iAlHBaoKkSVE+RBcPAA1woZeMQJr7Rn7Z8uGgx
	j70U47kVzlfJ3yQKZSCw5t5yWeaUefY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D0CE64292;
	Fri, 17 Oct 2025 08:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BEBC116C6;
	Fri, 17 Oct 2025 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760688994;
	bh=J1A3kJKtxXJU5+qG59YHiJrFi0j/jDz6VHUFIRyFNoE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=CttVRc1yveXr9lc2UWU0I8fRR/KeBSd2uPJQte47y2nJ4erJIFqjSyrTCPLui7VHQ
	 +BZrae0APgXM12XExxSj7nAUy9fkm2xvafZhCnOiUkZFD1A+VFcaYJurbhvFe7SpS5
	 jpnekBgkmutL0rA7B0GgD45+e9ms5oC90DqM5IKw=
Subject: Patch "minmax.h: add whitespace around operators and after commas" has been added to the 5.15-stable tree
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
Date: Fri, 17 Oct 2025 10:16:17 +0200
In-Reply-To: <20251008152946.29285-14-farbere@amazon.com>
Message-ID: <2025101717-emphases-vertical-891c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: 1pdgrcicjgywwcqhguxp5jtiyjzimr74
X-Rspamd-Queue-Id: 81872120004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760688995-482052
X-HE-Meta: U2FsdGVkX1/k0oui+3uhEndruFt/Vgx9WDWP1g8KdEmt+CJJb8Sq+VEf5kF4Rha00GhJ4W6pZ5uB/erqraABRype8fIaKMfzQOUmqRnvDWSTzWfG6PHoMDUZZeDmQM8FPpcqzzniP14tl7+gJykhzwl2HAcQ2Vm5nfbyKWLmi2jQp9dhM/jY+MiAGZKk8bpfTx7arOg3FFQV5HO5o4V4+eulJY3xpZMFdtW48MGZkMrKPX9CDXuE+qLkREgqbuYmQ9OICcdP5exDNH8lnF9cac2EyWA1xwikDe/heKWfGvtJCJF26eDa9Gp98qKXUNadCxRcbmmuk0BqPLe8ZN1BNP4gGmhTubAxk4krtzMHZvKRSNHkHk5j3QZb8yuUW8io7RYrBCffSV/jtEAqaf42fGrKy3Ss96vkyOek/qEqhVjbq4Qu/dcsiH7DH7QlhzTdn7dI40EwK92u+rtFQWb/fRN8RWQwcYiCrXg+3VxBb/cPd8Z08JjDRv7NXBrFa1FPGZ6iHeLOGbYfibKrOPxwoynKgdhxjb4cA7of6ExMkF5PXz+sl7v3R+R+wWG2mpaGkPbRBqHO5vI9T0w1tS6sk7z/xhKB6R2HV2ucDRrDBDnxx1IaFol6SmWvMZUR3lG+lY0uwLHhM73T15aTO8pNh3WspQBdm0gIPuohWNXp3LgRaeb+xA7XiN8oFCCFTvFIbDh9KqxEgrcQsvUpksijl2Xq4nl8JP3galju7Q+n8fv2WGQSXtltCFJbj99rCwo5fSOZRR/Ec4QY1w+/dVXPlWuvCrZek651n2Ua1bcmBo5NKyMQMvz+/xGmhQmlXhOdZWSy1oq0JrMzr+YolH+eCm4mtyhJ4o/Ggtreko4L/wJYvd4lILgE7RXe/BIeLLTUg7wor44iJ89zv5asKljIbu6Hxyq5CKSAKOuuQnB9ygD5A0R1C3/mAqU0nYMso2Ruh+Ngvqn9iCIxf64WfxV
 iO0+bITY
 Ej569zgdKQYb+YHBieBg6J2l9xCnofdB+hhMzeEMcZStKdN+QgkGHmozdnV/zNsCsxHi89exkYApMCIYtxg9pneepqYonJKIYJV0R8NC7rsxTDFM32s5JDovP9+/OXvtZHDpvhsLs/VdPV48aoUIqr9Lg7cVLt90qarH8lPgdqEoIu6mUnW45xtCfXxQvH1VTik4m5NzpfEawssI2vKhk+2R9SWf+RPYh1TfDd9iYnQQWAwH9AoPxtyGXGh+a39W5ppR+T99d29sQjjgN970BGAS/OjERPJijStunvlaZJeqJLgl1ssVYOc7MvLWVIpScKbGOeufEufrZ5k78HQQXr0SKa9yXBcQsdDG+CZbsm2eu/MY4C5NGcMKYsXT1GZf+SzzJqtBZqmMr4VaRFuyj/7Yp8VBCXOl4wgMMirtfi/P4B5zImGiAEqgo6JdHRFZdvPPbck2vK5ZUI95h7b3g/6iW6O+SEWKL3vsUlUPwRJCWwniidUB4UjXSyGTGGd1dCbcTfhkOEi3uMgnt5SFQ26wGSwuZ5BiCb3BDVc4K0mbm1RyFN2yWOT3gjZyd4Fy3alNreQ+n6BdZ7bwu1ZfDk6DiDKZgF2nMSEsw33ZszeIbDZWxPs4vC50KHDpxWLifrTOK7IP0PCbAOt4kwoc7I41ec8VyoSXTAnDiPlBzqTtxUMXv7af21NFbyIPwLP1ZC+7k0ag+RSs4McQ0nAyZsbIyUNfuBBBh1sKMHaNzQoLgwnjEo96rutfEqHfI+hR9BnqJnXDWQCJN0Kzi6f2IjdPxElClSAnQ3jzzoTG3nZ2s1ovRNfdr3HRzbzcLhKmUIBePzeYf0treo/TeY1siXq3Ffc9OXcqgxWD1ffK50MtsydtY03M3pcqP4ylOoXpO/SDrgFbh5fR/yADC+7FHZZ141ecFFkmpRPO7BqTBpL2KKKDsLPUbyobSnwFnVR9RgRglqmHs2byFz+cdu1qhs2IHD8U4
 g5m3/Hnb
 ziMKSZojMN0NHaV9R05GZM/M2fE6MkgnOAv/eIpz5LYyXITnJceFfvKCW3a9EYRaBb2R4t3Jm1sJvfHWO+qLrEjxbFN2Am67HrFL+QEv5DfSuPyJ6tN9rBH3SBIpxz9/bRp0ls1jKX567ZrZECAX4U45fe07TprybuzO7FhMOeMHwg6S32jcROiJsTy9XTWfy4nC637hJadGt92ePOszcVDAPtK5kvmEomqCxIvpFtcqQBMxHFrrhdqHF8Os0iYklaEVjunzZZDUNQahCtK/a+hP+kReG9fPCVECqowaenExbPmt0jK/yNG9O68htHXVZzn7YoXFp4bSHY1CG+bw6FZvZgQeGZQ3IprHN3mhliK/TVcOuRykeTJ8/6JlwZ+BEAXpEM5qcgFfEMInIIQZkGvdY7MM8sYLStuGQiUy/Ni+sG5OCUmd8uj+TFzWWwcbR4blMnqNjzOryNK8I2mpICdEaunGQMDwdscShz6E5m/+5LCO6AFV0t9Bx0wnMo/zJCW0ZB3/X2HK2NWVoiko+uuLN7h3l5SANH1nLrKP/mu/GEDEIDZV8eJsx9iHUYB67IOF+0CayQBkg2P5nyBZ1a6rami7dvbD4Va9KSXCP0RhodUEPDAS75X1UzaDCWNigs3/q0T9BSMw+o4zOz3BjCPUvdBZR4S69pWcpx6AEYFczXzdDagAeC4SuU2wvSVq9RG/YgKMNXm78uHk56wszsKVuk1Zpj/ad876XA/HB9I7tw625QIkB52uYk0dQSiMQNi9Bz/SpRgMtflbXX7FeVBunSG0y8mLGywyS8FaPanPml1agFErHrL2ZTYR1QnW0jKqAQSlII0uIkVbwXoUg28oNM9k2V/KPyPgrhyGyWsPLpF9toTRiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: add whitespace around operators and after commas

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-add-whitespace-around-operators-and-after-commas.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=36971892a=farbere@amazon.com Wed Oct  8 17:34:05 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 8 Oct 2025 15:29:38 +0000
Subject: minmax.h: add whitespace around operators and after commas
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>, <rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari
 .ailus@l
 inux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <fre
 edreno@l
 ists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro Falcato" <pedro.falcato@gmail.com>
Message-ID: <20251008152946.29285-14-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

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
 
@@ -326,9 +326,9 @@ static inline bool in_range32(u32 val, u
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

