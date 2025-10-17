Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAD7CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3848E008B; Fri, 17 Oct 2025 09:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453188E0006; Fri, 17 Oct 2025 09:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BA88E008B; Fri, 17 Oct 2025 09:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EDBA8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:49:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B30984EE6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:23 +0000 (UTC)
X-FDA: 84007738206.14.AFDF428
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF423A0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:49:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=aHMO088W;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=idD2HlL0vFKE5rnC8/MP8Php6poHrYVbrmtbPmDryJQ=;
	b=mbfauJ3G82G7Zvw+oBJRxCVHf/Tguk4sJi7l8Wka0UO/Ehy1xXn7EvFY1wIeSNLrt4V+lq
	/rfAnZKYBdFwP7xUZFXMfWVILq/qudeYGogspKjwvwmMn0H8foCiCMDTz1y3/knYDzjRWh
	USnKaG4C9mG0NBBh6M5LtyzgnPul5RY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=aHMO088W;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708962; a=rsa-sha256;
	cv=none;
	b=TzCbg6q89cGxnF90M9zDVggtdIA+Iu1a1juWk+jX4H5ID0z0WVVg9S2M5V/RAezRvCn+y1
	7RuDJqVATb7agc7Zuj39nNStlY1GiClUQqKb+yszGcVIkuoWlYeFgNt9TITR6Fee1Juk7C
	xei5n0IVDpP0LAqVAKLLxr42lsnG4hc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F87D6434F;
	Fri, 17 Oct 2025 13:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C41C116B1;
	Fri, 17 Oct 2025 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708961;
	bh=BUcx/NkbYyvc5Qtn1O8K7X3e9yzc64amBlkf0+b9Whg=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=aHMO088Wjk56ZAlB3nbFbMSg8+vq1qb10SuU0dfqsZxNYH4SYDTpDwTupjBlfm6Rh
	 ifbX4aGHNpxaPFwLaxwtdiff+1xvo3kmicMbbb+VbXoH+hnTfL6c7iJXDW4KLAjSqY
	 hld0cnQetScWqCzBX2etwWrroIm3mXQtPUH3EVJc=
Subject: Patch "minmax: fix indentation of __cmp_once() and __clamp_once()" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	artur.paszkiewicz@intel.com, bp@alien8.de, brian.starkey@arm.com,
	bvanassche@acm.org, chao@kernel.org, christian.koenig@amd.com,
	clm@fb.com, coreteam@netfilter.org, daniel@ffwll.ch,
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
	jdike@addtoit.com, jejb@linux.ibm.com, jm@kvack.org, aloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, kadlec@netfilter.org,
	kbusch@kernel.org, keescook@chromium.org, kuba@kernel.org,
	kuznet@ms2.inr.ac.ru, linux-arm-kernel@lists.infradead.org,
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
	linux-staging@lists.linux.dev,
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
	sakari.ailus@linux.intel.c, om@kvack.org, sashal@kernel.org,
	sean@poorly.run, sergey.senozhatsky@gmail.com, snitzer@redhat.com,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	willy@infradead.org, x86@kernel.org, xiang@kernel.org,
	ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:30 +0200
In-Reply-To: <20251017090519.46992-11-farbere@amazon.com>
Message-ID: <2025101730-dizzy-onscreen-9320@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: 849gd8wyn7qy69h9skh6k8atspb3j8io
X-Rspamd-Queue-Id: EF423A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760708961-676453
X-HE-Meta: U2FsdGVkX1/rgaRCb28q6x6mQem9icu52eMb4PbDp2dHOscPHDiC+Id0zawNa6luxXAAZsmmvFm8zyY1Xoq+yb24l1yHxmr8u7W/SKYl7fw/trJkkc7StQgn+BOSCjw7sUA4d32kaqWpfm4pDW6ZMfLv/3e4vPzt899pNNULw/9e2w9kEErzJOrsjYdTWBithAYUplRlxYLT2OtfIX5l2DY7z/BIEHflMN/faDlT30tF+HnSPFcecSpPfOTbJ1sHv4auEzOU7IrKSH35Oj5FVpNj2xNEW0dP53nvCJtNDTPVSlM71Yugu6UW7E2assN0hleqH/OBnpFUfEMazMiOD61d7Z0MD0Vbfm39qZklEp71sPj5KSeYQXzP6OqWESgIhT4dyTGqjpbES24NISY2SzgnZJe6risrtSrmEI2EuP321KHqgoFqzsO74/L48QNYrpZvD8yxQXp8BPvVV7Lu/2CEMEXgz5OzMfj1kmevZ/cd332NbY60B0Olp8A2rk7zl7iSFN2vK2pLZEEevaVfMiM/uUAj6DVBN7Sr+ghdMD22Fy5HBqSMWrZe8o0vI6azCoi8RZKtKTpLsXhKVxmKNuxl6WywTBmrNzizNSeMBMXhEyVOzdUcokzlk37zJW7waabCuALdaUGlJ5DSpYlSKqw475PRSzlARi8rzhEjD1txqm5fwFO/CrDAFnbYvbDIun3xSKFb6R13odfcDyZMUDc57bnCbQXkj/7QrD0frT6wHxKa16JEOTrmaOxYNMg3zOzwQXr1lgEJ8llvuY0qaSC+cKUfbiZqPsg9tvDsVpCQo5tijfhJDRUHgXisSEwgzc0d8YpsP3/gBlip+bgqo7eNmjTdNHTCMmHkkRPvH1XiahT+Tjl6EWy0WFsvNZK5Xbvii+lvpEmKptXRvRsynGTz9Ypg9vaVaca3ofTI+h4rUMciNGAGnfszV51bQnDn8Scr8vAE4twJF2bZPS1
 4MYbkW1v
 FGknV7CHDL0fzrglkB9AtAOSBNQoBqqoRrjhhv6x2yORi0W8fl8tdTKT7lGRZHBlQSpfC4gItPiJ/3A7P2otx59vVahS32c+zIu5RxWZgCkaQHnIz3h4AHrIZ8e7EOqrieqhrbOfIoaligKEsNzixrTTXY7vo+X7+RHXm2XTjkjKeYcQwfqPXKQaJddyY4jNFvitCmg2ANtDAqKUr1X90Cyhu6DYLwmB/XwBvf+XaFFu1F7L3Ou++0/9/tD2yd1l3+tP0h28m6SFqfjxoJ6XL8j4L5rIRDWAO9Lc6PJdehL4ozX9xfSVChxP9+FSczSgEW1DKEJMnFFesZvbv9mkY9A6/QgNoJqr94HBQtgNElVBhsVTSiTXDwKbUse8v20i+px6gRLSj5GOAweBvbFZxixfXh0ntVsSRe2eLKBHvYxQqauw37rruLmJa6Zg/1tPiiHTfVkiZ3udwYN6P5/OGLH5UoL4NA+LsHQahqvA5Iqde8ECX+2OazKewlENIYQLrTslWiYyTLR52Wniqin8kAS7oj0JfEFN+h5CPgZSjBIDW8udZtB4u1FwFZb/h/rZ5c0QVovKe5qGXDOPDB1xpvxl63gbrwCe0etxaDHm+zRf3E9KdVGBRJSOX07ghhw2sYtfDFZdcd0FcHaaBT+zjAaofDQQAAwkKuskxwUU5eHqr3MgWHhWEx7l6m+LKl8WN5rKofwtugBQ4o407yBc0zwnsKcate4xJkXy0Uta2lICXB5Q2vCKyAKdP3w4DAFtuP1hGqsfT+YRke+/+cdVIZwet1bXPC3qNPCT0C48KhPhBR3RnTcKyq7ZkSk1469cjurPXqFmhy4oSyp82LOGCAYEVNRUHnwVLXEGkdEETqHdehu5CtuNb4vUVxs9RMeAU/MIQ0VqkyhWQaKUO8vcEHxyiyGpfyvSFFf88q9viC0wev+oH5FKoPzEuZpQReXh4N64xJwL8jFNYgTZLDS0YWQ+aYQ8Q
 lXJ7QlMM
 qECw2X7TB3BicNzf+fhdTMelawq/mD/mQb1v/QbIhhd52Zo594JKbU0mlPEIOclKrEZc83PKnUKKNIBS+iUZL9ytEizwKzMvEAyc74Y90rOhBmUxEOfPkaNcN1sVU5C7brsBDcsjNFJlVs2A4VIuAtIq84W4vimE3SDxhFz4xZrmBWfWRp2UI3js0G2klUf2rbyV1vBk9+7Iw4M3X762SbacSjDD9hqOw/dHh/2G0zUBnWUlOxVscpyHj7pFGa1P36JQ4Y/CfbqulExJGcyynvqGrlv3GmfjKJc3LJh0NXy+0VaDq1hA+FxTVIUiYAxj48jIWAUrVumS1noobjSXnMwnHJ+g5DHyaq8E0/NWNxHNt9v6pz2jMzozSoNvKgOjyAkKMFyasUE38YIWRcoiE7PS/04/34XjzAH4QGOhEUwB/lMs7fi1GiqtTGhrKU/gLi7Z9Od53XfkOZKHfhiLV2aDSCuERAS+Hf2B8PDhwKm36MEiPnu4ZHFqpIK8g9KGNEqioHn/ZtOzyEPKrsXDxq9K0oZmRH3szJ29qOZgAK16fljntV9KPWoEPwY9OIiB+kW5J/J34RJ0dmil7lVAHxHmUgIPPNxnK33bRvX6ylD7i4up+iHlz4anLlZ0CKEwF6TENImCz1dQCK2n8EJdc3sg7ZslQcX+lCWdF8qdoSQwu46lLVlvlCGBpQz1clO/6877xFlSnRMHjxMntmAl6w3Egt1qobmnuCXumwY2JxWuRAjC73vL1kkdtN2o2HRlo7/r7TsCvHG2u1+GsmFEbOKEKa17PcgxJjDGFY6TgDst1CQvWtYXWAPm30FdfgOJ1aFw6ojmJyI9aIuxXy5n0fq/NXypvIyM9ukXwKe++849xdUzDEfjgp7SKNN7gXKJcSqGbrC6CsiuGveDFPvDVGxqN6dGVh95a+wRkR74no71fahzpgTlUQlewBoohvXGPSHIrx8El28o5NTnjPr1aYi3ipErF
 1eb8QnWo
 56P3vbwv+AnKr5t2eQT0snbUkq/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix indentation of __cmp_once() and __clamp_once()

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:08:55 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:02 +0000
Subject: minmax: fix indentation of __cmp_once() and __clamp_once()
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20251017090519.46992-11-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,11 +35,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -49,16 +49,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\


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

