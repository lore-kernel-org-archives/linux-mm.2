Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A078CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED2C8E0086; Fri, 17 Oct 2025 09:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C448E0006; Fri, 17 Oct 2025 09:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B088E0086; Fri, 17 Oct 2025 09:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 443AA8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6C208542F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:04 +0000 (UTC)
X-FDA: 84007737408.03.FCD3B4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 39D88140003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=sGHlqpNC;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=U8uI3irMc21KXnyDZVuPJT0aSh0IRadWAJ6vHMjtRig=;
	b=VaV2V33ZT6Dw4VC8cd5h2ETo9IKIm8k2P6rJAl9lY5wRA447vTSt0v5grWJdb2c0yVrPkA
	8CvgMlJzH6bnEoBHk6SrTfsx8seEr233uWr29yDwK8hTAP5i5C8yeqUoD+ki0sb+GxszhM
	HdT/uBvoXT8bsDLc13i9dK0LKJzBKj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708943; a=rsa-sha256;
	cv=none;
	b=mvvJtDOQ2Jr51ONjvvMWTg6HHUB87eookUzPXDSo18MWCW8Fb4FbItm0qVSuXe/qWCE//r
	1/5kOfhk6O/UFN+EASnFCcVbBR0nzrhE7MxYCl0o5cb9h+k7hhc2g0VvAHPt4xZgJ9EyQK
	oAJJjbAzagyUYuoL0XJNCmnxZVFNWvE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=sGHlqpNC;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9800764376;
	Fri, 17 Oct 2025 13:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27ADC4CEF9;
	Fri, 17 Oct 2025 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708942;
	bh=ywoIoTQPJihrdgM5VHryYn1SAz5PWHvRXI+LMWpHDzA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=sGHlqpNCTaWpThOhLkiPmT+5JamWTA9ZTHhjaKQMzLaWaFL09I2VbBdpSyowlJ8kf
	 NjHTI/QszjDCGnSUt32YkQ74ZFu/vm95iTbAPjIi+HtvG5rARduNTerfBnXNj4QLSj
	 W0lj/N9be/EBqLOVsfkr0FsBCmxE5i6i+jObqRow=
Subject: Patch "minmax: fix header inclusions" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	artur.paszkiewicz@intel.com, bp@alien8.de, brian.starkey@arm.com,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	evan.quan@amd.com, farbere@amazon.com, fery@cypress.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jdike@addtoit.com,
	jejb@linux.ibm.com, jmaloy@redhat.com, joabreu@synopsys.com,
	josef@toxicpanda.com, kadlec@netfilter.org, kbusch@kernel.org,
	keescook@chromium.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
	linux-arm-kernel@lists.infradead.org, linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
	ngupta@vflare.org, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	sakari.ailus@linux.intel.com, sashal@kernel.org, sean@poorly.run,
	serge@kvack.org, y.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	tytso@mit.edu, tzimmermann@suse.de, willy@infradead.org,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:29 +0200
In-Reply-To: <20251017090519.46992-9-farbere@amazon.com>
Message-ID: <2025101729-anyhow-embargo-b20b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam01
X-Stat-Signature: 4miz3nuhdz8ss41x4cpr1a9zzu6thsox
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D88140003
X-HE-Tag: 1760708943-214950
X-HE-Meta: U2FsdGVkX1+jMKLg9dS+gpfyY5Hfca/dpzjocDse7+7FmL1uikabN/OfmQF7Nz5UntetA8jJpE3Zt/iM5TYJUPlaZWxF+r/aqEfFZmP2Xue47cDsFjovUPYY/wynHlca3maoWGOMnvknQkXwnLVzq+EoaXyOO7IEEuV1N9c1QF3xpME3qj88VYPxoW23gevpgCv6rd/huPQYInsBDHIZBo8Z2glRxi2IeIwhfoMC4OYGCW89DjATcmjpkJ6Um/iJYtVTcBfDqvblD4hRqYl6rMUf6QAzJI3290UJ+IcAs1LkL49rXbxn+4rj3bfEEP8gK2RWL1dxh9+aNwdwjrjJGMo73ohN4dsnpDs8kzicJAlb6TZFgVLplmKoYbU6CiqjkKD9JuHPtIlk/ppUbWI+WqzEKp6KsJhvN4Ej9hPBdIp1aWo99a8+LBhBBe+Ziqzzo9KaQsXpZPHkKGKfub+lvLG9pW0EmibSkaLGXvefM6yGgt0Imyzrk4N02fmoP8OmCrkzSkOJPk2OdEm+1gyMQfnSxnYS3I7nTlCG1Ff8/nuM87T8IqY1PzOHauo5cQd2FIH6MTyL7ZSR547AjkvKbV3d+XlLcjLwQWsFA6SLOuYI82uk4CRF4VdS39+Ba3UQhYcDtn/PcBnOoP86MCf30ACw3eY/kFEsqH1P3ZRmx92+PpBXHZP4yi5wsJjpqZCzkUyS9Id9Z5SUxGoz8g2Fi8kpYWmX/MT2TPXb5L48c9/t/2DlknydvZ5THWxwBCwEE1gNComfX2Fmv94S3pxN7PMSdcHg8j/VvZRNjrChBRP+VLsQEuI/N/Gb6oatIwceQ//61AnN+pNUtDZyf7sd/B+2dv/HPNHH0/4+hsk2s9xAa077aYM+eG08Hv09IDsADh/nlq/xNl1iGP1JkRgDfmLCdUMRgb2N3mSvmOjKoKZBvPEPKPkqqD9jUXcNZBEEbIf5X6gxAvAmgKca/5R
 W4NWOza8
 wkem65o9Dy9NwcQQMNY6LU+9iR5+wByy0wL8mpzBrutsM1XKoseK8Pavxgfw1MxBIpNKsydZy824yZxBftbtctleDKoNXZwz2DjoQ+p3lxEhg4RjMh7mU0PKGjES8YSTUWWgkGEcqyKMuZuTWnrUVrY9Mnwgbor06tSZyxZ2Y6IwycQsSJJlb2naDSlsi/g0+mUVHgP0cYjZLQrWcawLzFsOIkC4LiCCknhtXz9Owm7YVv531xMegMptklNNXIvRELdGgprSYgDP98GFCAaWNcyHFluikf1Suugwqsp3T++BmQ9Jmmn201Sy93XhbnUUUlADJvlqEMk5O3BBdp1CPBVoz7chYlIeky9dzm5MpwV1X55kN3+4/lnXz+xnd5lSADH91ar+yA8aSJWizZo4QExkvf43XWmlG0ilDWBFfQXXOzsswhPBuQiXI+YsrsDJxQzA3XFHTv0i2OMHqXVt8/PcNsABN51X44MH8WpE2mIQUwYP/Z7JsEAJIThu2QP+Cv4D/FMDHUb0RUq0zTRBqV5uQ5yXTCSm+MLNkNJCnQ4eiee0LZM1FBt38nrAAd6UxLym11kmv5OInK1dtZKRjhC0xAKdfEtIG0wNhHQYr9wF7qCAm3EE7/eOE5hIK7R6Eb38CyfpQWsPINe2OlKtlzcAtamEV30pD0iyuI8sfP/keP1v3SVZYWCI3vxIMN7Z4wIYk7CMuUbkjEBppQlZJXztnctryRk8skyyJEYbCzyG4xX0N9d9XTX/CyLXESy50xCHs5ml8Xk0yHlvxsUqyVi+61dKFzEPiJ+/Wc81USFbenQhsTobwmzqxunhCfWOJCzC2oWw3V4mtkTo+QtzTQO3sas3HtVsgAOkZbru1r5sOBYrNH3HNf3VKzqfCVijUsLIJDEtRrXieAH5Tv8COB/BCb5eQCXMQHYxBNvXtuhzy+s5bhwPRPfS+RB2sZjLZYTjwp+lYsB6t3rtT9BxS7MpAyHpI
 RmrDllgT
 vIZDDXcWid2r3odgyHetNjiRCew1bop9OsW5feW5yctHXGXiEn3fWvlZukcgkL2ayWH3PF3fN9FRncPQCn5I9kHcDA0Dj+QCh429Qy1hjoxphzKdmGyPItrMBJLRs6ZdnxwSgCIDkkUXhSOjDdnHbKsS8iAYBPGo0evtKIzoCwLZrMTqWoUJKw2YLyXa6ofGlppdUkVdvjJn+ABBBQTCD+wxzj/QbobiN9O+h+lh1ddga+sqWRlwukWLQeT1tRpFtU3flCzkKhsA7WU1QNj1oHWhaFH0RurSPF5gI6YIxZM2SyKBvDFuGQreGKN/3rlUpdG2r/cRpoaujUd11ZY3V6M9ynwtalP6Q1wtqlT6smJhLb+juiiKpgDOdtbTX2tCn3agUhNY2flFpKQF9Y6sRnakHeC7DQVd0EPAPelRCe2K2lqz1rgOq0+aUsxZQr4hYHgheSYxsl4Bh4NvP1TVsJsqM4CtEQAZXD1uL0Q8IHUTdFrO3CvkCahmA0jt8NmXfCM9zfIHSD9O6tHeD15pE54H+u6cpWt25Z5loHjUpEcGhRkyxjEsJG/XbYCG3adtIVyv2wtKWpyFmBFDU7ubTuRpnOhwvLdkF7QZa9a6+OiFou+qH8cY1+UcurAjp3rF0StNie0XoCacjsE9b7Ql+QK4XYlQ9PLlUqXKl5Wrk+dp8BPO0dMw3AYu7ui7neezE8CiVk4OCHsC9Tjt0ONwk3NwcYrp0K9A5vxVKAiCgaPNmSvL8cIRbt6MWG383cu48ZUD9+UwBFFhEcbzUPR5beS7h+q36of912ksibIE8UpIoP+PbNRnfaUPxaBF+H5TsvIOkw9DZQBfU6dvsrriHFsjbytzz5Jn7dCIxV8TQvQk371x2ZOOVIWY94yKWUIBg8nYdDATMBeA8edW3UM5SBPuGSb3Pe6fUqg2yIaGUZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix header inclusions

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-header-inclusions.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:08:16 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:00 +0000
Subject: minmax: fix header inclusions
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Message-ID: <20251017090519.46992-9-farbere@amazon.com>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b ]

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,7 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
-#include <linux/compiler_types.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
 


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

