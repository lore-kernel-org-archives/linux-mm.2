Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB0CCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C931C8E0093; Fri, 17 Oct 2025 09:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AE98E0092; Fri, 17 Oct 2025 09:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B809E8E0093; Fri, 17 Oct 2025 09:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A58438E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EE6D139877
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:53 +0000 (UTC)
X-FDA: 84007739466.01.F3A85E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E49C8A000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=O6H3nYZu;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=mc1Z2x7kFL0ZXjEiguVPj6RVeojrQqjIJTgEHoUdZ6w=;
	b=7/HhUQMMtwoIwGSeexgLvJFUOdy8OqxuISOJmnmjiPw7YT7dAQqxMoYlWEU0p2T8VksC2B
	r7soKJ863JN+jK9K3f8fvfhirmv8EebZkJK1WUup4+0gA+/hjeFkBP8l6ZhJvrDPpBpZD4
	wmhcKq6Ga4TdjnwU2xWFOwd+9UKvS/I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=O6H3nYZu;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708991; a=rsa-sha256;
	cv=none;
	b=jdxPtViqV9atH+0XD/P4J6D4kc9VJ7HJtlIyZab4q5SAjEf+mGGNEYC1GbeBSHc0Y4deOT
	gTW/1Xmx5/vCEksE5cS6rxQ2nanei8K/Kv1BK6r8giTFqHTA1ZJ6WY2Aijv+GSBzCiSlm8
	EMdlOeKr09dLY5oeV75JIRMWnn70W3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34ED660361;
	Fri, 17 Oct 2025 13:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40A6C4CEE7;
	Fri, 17 Oct 2025 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708990;
	bh=2AL82Tx8Rdq/52T3TJ4cC7XpFGFqeD4+6tAruhybAuU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=O6H3nYZuSN2+aZUpkC78xIr7fqsasj3G0l1TIeCUvJHvo60qGySNg+ebN2C3yhiqg
	 daTJSwJ4ba7/zdJlZiA+50vstfQ2kFouA1hOO2Sg9KMppX2ApJ8y/c+89w2KXGSkUT
	 Anm8AcLYfmLUNPO89SY3LtuVi1KYI6WFjoDzVk08=
Subject: Patch "minmax.h: remove some #defines that are only expanded once" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@kernel.org, artur.paszkiewicz@intel.com, axboe@kernel.dk,
	bp@alien8.de, brian.starkey@arm.com, bvanassche@acm.org,
	chao@kernel.org, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, dan.carpenter@linaro.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsterba@suse.com, dushistov@mail.ru, evan.quan@amd.com,
	farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hch@infradead.org, hdegoede@redhat.com, herve.codina@bootlin.com,
	hpa@zytor.com, intel-linux-scu@intel.com, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	jdike@addtoit.com, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	lorenzo.stoakes@oracle.com, luc.vanoostenryck@gmail.com,
	luto@kernel.org, maarten.lankhorst@linux.intel.com,
	malattia@linux.it, martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mjguzik@gmail.com, mripard@kernel.org, nathan@kernel.org,
	ndesaulniers@google.com, ngupta@vflare.org, pablo@netfilter.org,
	pedro.falcato@gmail.com, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chels.kvack.org, io.com@kvack.org, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sashal@kernel.org, sean@poorly.run, sergey.senozhatsky@gmail.com,
	snitzer@redhat.com, sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:33 +0200
In-Reply-To: <20251017090519.46992-28-farbere@amazon.com>
Message-ID: <2025101733-volatile-vertical-2f0d@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E49C8A000A
X-Stat-Signature: 5xyygwu1zwcunrh6kaeosyaxipeecit9
X-Rspam-User: 
X-HE-Tag: 1760708991-705810
X-HE-Meta: U2FsdGVkX19whH83Ut0xitGaZP6AQZ9qT3cM/IJ7106eG3eWED3asS5XzaulPykCwKCFdHZ0XQNNII9vS2725HBz/C9G04bqhBzFocbQCvcGHQPI4idjSODzMpXXqYpEZrq02Zx+RM/6FX4n7QWOK4uiRUvs5gwCQGcASztVvhhlUC3bnSvrgf9IPEoGGSjRNx90gW1SCjGc4WDUo/KQyJRTCyguKEjKuUY8Lfrxv8Xy8WgUk4gV5YWM3xQC4ZfgFhjDLIWvQVAKs1ota6HHzaAq4nVTkl+igWJvDUjTb0X9QtWHId7TMhJCLvoNPN1nbbKGF89SXXDnn/nfpVNllQF1arsemwjWUxJ7dmugrYy8DWck6CbunnAM8LPBL+56Awi8oOCRINqTVfacKQXz6sphSibBh2LBNFwntPndjV6Jlw6am/MxeRqFefc+nu0HRm7M9g7k68phntjZk9YQ03SnEa6dWXGIttSJCjOZ+Q/GxpeuNk0rtIcbjyTBkonKjbLcHNL0ojFbn7gBHCuLvhOOy5Df0ILtae9qYfwK+aoIZxWy/ZzMc84Wq3Ngd3grJqVCVX7oFberOqhdfACFpG8XembvwltLOed30GpV2VkgQOdYHKn6XTwpFhzj9W/S1UVgbFkRQvU8zTEG9pUohgZDFhkpJQJqANCUOQSHigA3TlGDwXABN16SeUyoL1u7FwW3Vs9qz2Ef1w0oicSaYvwoQiEsUAiEXDUqgWfw748ckjG8t2zxJ8E3CLhsT0okXO+0OqVfht3wUxrBmYJLWJfFglk8xAdR5Co56V1Qr8dz6G7o64z9ngy1TIe1ejdERWdQTnRMYkydHDGW/v3/lDhkICK7kU7917yDK2KBjCi4+x0qdijvVnQRo0tiLr3LPo645zpK86CxJpe4kYPUt8JRR9i6x+f1TPR8m+rbYm/sETyIvM4mRZTduXHfWXLkrwBACbgEF8un/1sT0W+
 a0PNhNmI
 HW43veK85LgwCFVYLoxc3JdTXSHOVGUrqrjRAMezpYi6YrO2EfLARwAFUtlJQAJNK0S/DTTycWAXdS2jI55M22q3rFTkS2kI+dDxTsgFqH0FGc5GHcrlBIVLUDXIP114DD9DitjUDN8lz/0M02oBnxB6DJgVKw4Kffbqb6QCfmwO2R+lzQ4cEpejuSzmrFin7a2+pvOu4B72Kvy1TSUFfpRq82HhPfE2x3sVtmE0WhEQhT9oUQtCLS2XY3ElmakOs1BG5A6qhQCOlHwGk2hdO1vdfcXmpfbkcOE6wNc+vpYKYmpa8L/QAIzCvWuHSp913nAKCRdjHNKQQHY1vYw2SqL37FPAiKsJ375ygotbexZ/kz1vTF7zru9ycL7KCiGz01TQ2J8sDo0PyJ8C5i3Ald8MdCtAkg1MNo8IQ2ioU5Dzx0tyN/JkWqQsL40yGL6RidA80PA9qgNyeJN6vjLm7V5dFof0TzibA1o982IdcJtyOfDR/d9bczTjL16GeUW/WIbg6jaOy2DdrzmJpo4ZV1Iu9k5jidi27gEyDa4NMxD7uo1UsNYQrbo6QcZ+29pqVpJtz0qMiCjfOE7pzQ6u651l0xe7vlMMnVqrHbAU5kDu3TWplxtHj6vtsTQB+qzYfqAkq7gtNqYm2CjVPzG2Vw7gyZyrVHX3mUZ6og9MWh94m0W9jLz05tCt+FJAozyx91Jx4BWUdKqzPhHEATwAyW1DMNpV7AY312T6TwYYk6IiIZmNQt03gIQdAAgEzGeXTusc9YejD8eSltembs78u/FKjg0lUt/XoHZzx/xeJHHQ+J9HCutVv9kG1XEYZw0NreK9ITxR+QaRPHJFzXC0cG5cxAWjOkMn8qveRQGBPbCUjTQSLPl9fvxEItXnPslEN5lLmhubL5+CNJhcUMFI2RP//o68IeMYf2frz9ye/Qs1aOOlebNv7gdoQkf3dCyuOPRH4syI4TttmIMXGbxMB/FxqDbUi
 HeqzTNNO
 ZS9ML6Q+cNCuEpN0lU89MYE8xFYrsusrVB8golDrOWdqe8leXXZJfQrjk+2cXF5De+acrRvC1rXYrsFq2NYeh/kJGAQ3+2E56W9+7xgyJPGpIPmByoY7CL+ln3MVszvMCfJuGbdH60pFUXqWT0UEjghCslnUdlgKfMEjXTDU2iHs8NaSSq8k+ouip+r5iR3XcTgvB6G7q3MP32sD0frZ+cUIsNHc4VW63O4P+IuYPK3opjdhuaixhy2UVLOQi4nQ189zBVwEsW2y30FfHjYuBSyTGPM/twSokJoi6UyiZEqQrpxupjmN8EC9cbO/Rf3eqSOZqgw2WUUWcqtwBlgEPWAQ0Hutb2j98eKMbSLbIoQjbCxLOBowqv3Ff4FCsZES+0thj1CDBnLZFVO0gUMNEopSgrlr4K0OmJj/EOeoUqi0AzklxslnPWNpc1WXxU3x67HE+sRwO/v8WLVOn01636Y6qijsY1wEG3gxtNa0a1MSAn7MD+HB09Hw5lS55v+hyEvjlKz0wj+bVaTw+2RoW+PXMRn2TMyRdSoMMCX94UyAEjYGRi8sN1532/kTPWGBt9ulMYKVCL5zZwO6STVQpt6SE47zBA9fbNr3+K7OVXHatQfeQB+ehiKyYafAkwZXxV4CmH9MThdGCCD8I38nD69BeGEEAiflOJuk7dnPp9cmMBkwKXxnxXwe0kqbxUUeBewCgEwX8BVEPykOXSlKuZEQz+DKR2WCcTiWILRtGqMfpOR+332kUL5LN2lCzF9mCw9kMypvHVOG0+7ZKVpAO4qllE41YhouvJ9+Ng2cdiklGMdRAPAxwIcDADhQnvI32jnqOWbFWEIQssaVLeLtTUGYTNryReaRKyX6kZJLL62IFBfBV4JLBg4FxVCD4Pmjtq+65kQNgXj321w6BYJElEyLpYCh3QXw3zXsX00rtK+tHuiwVyFVU3F60t45Oj4rLf5Ru/KdYCi/diNfg7DCSrE26urLB
 r4Lj30X+
 IANrTIp2tC54Xgl/KNqb6u5rc8bK3ZzPww7m74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax.h: remove some #defines that are only expanded once

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax.h-remove-some-defines-that-are-only-expanded-once.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:14:00 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:19 +0000
Subject: minmax.h: remove some #defines that are only expanded once
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Message-ID: <20251017090519.46992-28-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

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


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-5.10/minmax-allow-comparisons-of-int-against-unsigned-char-short.patch
queue-5.10/minmax-add-a-few-more-min_t-max_t-users.patch
queue-5.10/minmax-improve-macro-expansion-and-type-checking.patch
queue-5.10/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-5.10/minmax.h-simplify-the-variants-of-clamp.patch
queue-5.10/minmax-add-in_range-macro.patch
queue-5.10/minmax.h-move-all-the-clamp-definitions-after-the-min-max-ones.patch
queue-5.10/minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
queue-5.10/minmax-don-t-use-max-in-situations-that-want-a-c-constant-expression.patch
queue-5.10/minmax.h-remove-some-defines-that-are-only-expanded-once.patch
queue-5.10/minmax.h-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
queue-5.10/minmax-simplify-min-max-clamp-implementation.patch
queue-5.10/minmax-deduplicate-__unconst_integer_typeof.patch
queue-5.10/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-5.10/minmax.h-add-whitespace-around-operators-and-after-commas.patch
queue-5.10/minmax-sanity-check-constant-bounds-when-clamping.patch
queue-5.10/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-5.10/minmax-make-generic-min-and-max-macros-available-everywhere.patch
queue-5.10/minmax-fix-up-min3-and-max3-too.patch
queue-5.10/minmax.h-reduce-the-define-expansion-of-min-max-and-clamp.patch
queue-5.10/minmax-fix-header-inclusions.patch
queue-5.10/minmax-introduce-min-max-_array.patch
queue-5.10/btrfs-remove-duplicated-in_range-macro.patch
queue-5.10/overflow-tracing-define-the-is_signed_type-macro-once.patch
queue-5.10/minmax-relax-check-to-allow-comparison-between-unsigned-arguments-and-signed-constants.patch
queue-5.10/minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch
queue-5.10/minmax.h-update-some-comments.patch

