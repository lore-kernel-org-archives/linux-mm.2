Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06948CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D248E0037; Fri, 17 Oct 2025 09:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C3D8E0006; Fri, 17 Oct 2025 09:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4057B8E0037; Fri, 17 Oct 2025 09:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2827D8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:48:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B202C855CF
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:44 +0000 (UTC)
X-FDA: 84007736568.26.F887DB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21EDB1C0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:48:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=iGUYOZ0c;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760708923; a=rsa-sha256;
	cv=none;
	b=ENjb8tj/tQHdB3AxHbTecvao1Uvvxf9JCxmNqhSho83UNsAYxkwuxnydCLICCCLOnqjUIM
	VKxh+KRwWQtGz0EmjHgH0bqsx++xtaAdlz9+EcAQX/QZtJHqImZ57wrNLdPxuqEaXdHjq5
	blMguAYOu4imUffCTtk+FYk7DqbAb7Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=iGUYOZ0c;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760708923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=dBNzy2s/UN9Bshlvp35xCSZUDgDeSJP2leryAX7oGr8=;
	b=NmK1/Z6BHonfpqBstGe5Fdp84n/6HXcsHuOPC2WaR9M7KsIy6D//Pm+SknT+4weNMHeroB
	ANtYBfRkqQqnkBqcp6R32xxom1KT3i1U13sRPitf/TJgoKRU49nB9ZlEFoXBtwnnJtROwM
	vA/Lk8YutC66nweXEE9K/bfzf4DOg28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F5C46434F;
	Fri, 17 Oct 2025 13:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7136C19422;
	Fri, 17 Oct 2025 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760708922;
	bh=tgzAnA2OkjLe7htmZ7GtzRbBBQ/ZgR6eYFTdikkqqg0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=iGUYOZ0cHe2PutTEbIruDm2iopRb/fs6f5Gpyi63EqmMzO9ZGK6qAhJUExLl0GmvX
	 JiHKgUJJ4A74VVhDyYkqnfXyjrQagNYuVS+sD15S5vrB58bZmtXhZNOc9jM3PgMZHf
	 JOMNhgJZKz0/fhRMiIpBvOi0ErW3haguI/7b0Iz8=
Subject: Patch "minmax: allow min()/max()/clamp() if the arguments have the same signedness." has been added to the 5.10-stable tree
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
Date: Fri, 17 Oct 2025 15:48:28 +0200
In-Reply-To: <20251017090519.46992-10-farbere@amazon.com>
Message-ID: <2025101728-math-crafter-245a@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Stat-Signature: h3ua4rzquybtqeq1f77trdhn1tfwhjcy
X-Rspamd-Queue-Id: 21EDB1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760708922-360847
X-HE-Meta: U2FsdGVkX1/689x3upjWT7rrSXTEQmIdZHBNqS0gjXKu9MBwh7lOlFuRXBvcuSieMAYqlr7xPaOvenlAQ9bKr/VhoiyTuRKrBDfdeS41eqb3BdqZoNLCySPF6vqW8PQCUt10xLQJG5W2Aot/3kKGx1j163XV/IiBm+yg3FBQK21yRMOovIT9fUZ94w3XbwKMsxcMcbXXlfWEAEqmTi4deQ1XOtdY8Xv2LhCvFnsYxJbgR1cvsc5Bdl8TAQ4jXIgwCQ8w8OpxLIjL4CEmzKIbjgJhH25561yEpXR/Py0a96TwQOEE5ffUo4UPildmt2zq6FSwn8MGfESlMfrNz5vSU2mrZtQYEsFD4MIuwWnOZJQJKQABDoKIce3dfipqs2gZRZwBUELZGhhb0Ca0NYRHPwRGRfUF6IF/Pfs1QZ/l2NkO4JCAuTJEteXTalVfjEn4BulFu7BVbU1M8mKEcVXg6eu40BzJJYOCj10JslkpLobS03JN1E5HBQJT5ZkviJ/lEvzFopTKZ0F66DxKTfrPLkUrXgBka3OD+27X9u0CZ/RalkigYPOjwLZt2zFFG4mi1ULWzVCF3pz2wAR8IRZpvwa/ebKOdLcqb0TTPSfm0dig/2WjG/1TwPWaSYJKdxtqK2lf7S7638PZo+LXrzcAACPjLhd6227cX7z5Rp5H22k4/xZvZKEAjJMEyVCH0JjOpNraS147ot0kBaBmol5w2uSvM4X2FN2fyl9jzZd2Aai0U9auGdv7wZxqdd8xATFJ9Me7zO9IUNYniqcEW9+nuqXrKOwSLrIIjEkVwHSedNfrOWAYz6BVJ7mNlOoxyCHlLWdJTleav/c3xbLPuikMdk6gqYUH6H8NZ5JLQ0fAWX+A3c7csYoK/sSNv6za7SUMnB8IB5/x8RpOD7ZK7em6CaZHr0jjrp2aDcEeYGy/cSxIc7xwwR84B1Uq/W/qNdVP9WGvnWHFiUlg08SOAKQ
 RFMRqwQC
 VRtOifunNSHgavNpMCgiPwdYdz6Q3z6+wBsUd7PBJIIBdts9LgT1SO/VCSpIEy7xTCwel4ozA2cFKDVd4mx1i0YC2PM9roJwsjRbvNB/fi1bF+DiS+YQBFR8Z4l52G5cHz9HJtR+v56Tw7GTHyFabtH+/rKr2qRkSIx3qLU189sT6R0VUokHmwJb86wITb0lJDBFNiwAr/3Hf+8JCibsrvMOwpZC5gRtj5+mnMmZnJe/YuT8KQq/afibvOhXEY902PjHfRZSQ90SQiZCjP8nrV8I6IFgLOwhkMgv46/7Zj+BEgVTf3lzYuN4NcuQKDBFWYifyiv54AJimz+evJiIjI8nnfUcucI3RCvkMnlNFoX1xhNk1wiXwBxWGQZc5CSBQZ/vaX64Cdvl4FV2RvGazcw48mGHNwBcF4sZ4WG/GdPzVu2MdGYRL2H6CKXsCVA0L+0qt1579IDXS/+q7VoAeaIZxH7S+Oh5afJAt7u76RlSOQlSY5d5Wa2IsHYJTbRviVjIxuAXHqMuwnHXGdigj3RRI4eBqN7tiRmmkpuyd46yKa9OPXPUuwQb+XfwkMSyjZXOZI2NLk5WWx+gElmBdYU/ZXEJ/lnOGhqs/iQ89BQJPuZHPBD8qR1gBKHIJ8GMq/ni/MMlwAVWl51zpYSDNRrawWeQPJh//JJYj+ZUyq6h4fKOCvz0T5eiewNlbErHfy35C+S8bb0GIncdOdigo+VSMdKcNF9jgsn6bsmBZMmhwHOrIuscYz2ehcRnPj4GGj6YuyzoHqwxeVubg8Z72+zqVdR1JW4qy6NpGXBkSHyivNOrpTI7f31mUNumUUa1i/n0HUd7z3P4eXfm6QiaPMHprXRMgo8NR1OlRlnFTm29WgYsxDfgLdHaXUHg5Y1WffE1AIdI1odjBYxlIMb0T43xF0RTFFteYgw6bPaa+2FPnn+XnTdrve1Z5VWicX7UCU2sVJH4Enaod6fxqwwuphXAkjKZL
 MUiwgqv6
 N8LqvlPKnRFhGDHJVtZEBNvpyXLDUWeqwNGA7f2MZ8BDU1WMZd7++S53DgbjVyROHzj3vR4HFa3jSypbTAwgdA6BrzIrXpnXvTplTBq18AVbybSN5rIVg7kfqz+4+6HBKEj6z1omJv4B6GmBUr+tw9Gh88nYGu4qNQ7qEybG7QugFEu7D5Uuxq3Tp1JGHIGjNIhQAMnlXG2mEhXG2noCi/OxGW/vPiglF1XUOza+W6K/dY4FJqg9I74EPlpLslExpiskea4j/hqZtFehZHaFywglLvrrgz5vC4uz7IPJ19g9JXGdo4SpsPQWjMFiN2Qav0vCwKxGHJzJ0AfgJ8Nz2QbRVNaapiYzArwD3aXBa8osEUOYHRAnRPr3usuGSsbhAuj5FtpErSPtNVbQ36ET9KqHXCfU637nut7CzGlPihUJ6QDsbq2fOX+JuSxukfjbx446AppHWWotzRF2qpkm0OrMVM1jGlUmZ2fPduFpssnLxp7vJik4CmUTw9aH0fbuHB4Orl2hbXq6ggvE0akEbiZqqnpf5rEpcXiTxlLtGcQ8U5YMnGXWuY85gZ5+32Ps4Qk9jySlnKl5AGJAObHVcAGjnUp2dUajP3DP2h9l2bfuWqHJ9vRQ647+GhGfwszClMZywHBsGlxIdiMSGyCl2Y+jLmuXooOEB7UsRe5jmw9XaZvE2T0VhWG5cbN0lxNK/0hutORnuQz7c/RIx+O28lN0YNMwuX7zw1ZixMMENxrr6igJQ4wzieePh9M+38Opl7grnOF9Gop1rqDwmS1T0JCH6XJd3vFh0Z00BrPgWCZyYwiqxMBGxyoUgiGF/qq2IIi3kDrvqT3DOkKn81Ca6GptBEb2uhXnGupMCCEgyl+5u7S47viQp8ZK3Fwai3nt27LaqgN7goA0VBazmgznZgdgZ0AX7hhzFlnodpA5wFwV80nK5KDB9qZiYqpSWbq6mIHp6AZUyE4xqozOck+C0VHUPLo6n
 F8WiSvSN
 oz5pzUacGiWKwRVQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: allow min()/max()/clamp() if the arguments have the same signedness.

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-allow-min-max-clamp-if-the-arguments-have-the-same-signedness.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=378230090=farbere@amazon.com Fri Oct 17 11:08:35 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:05:01 +0000
Subject: minmax: allow min()/max()/clamp() if the arguments have the same signedness.
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20251017090519.46992-10-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit d03eba99f5bf7cbc6e2fdde3b6fa36954ad58e09 ]

The type-check in min()/max() is there to stop unexpected results if a
negative value gets converted to a large unsigned value.  However it also
rejects 'unsigned int' v 'unsigned long' compares which are common and
never problematc.

Replace the 'same type' check with a 'same signedness' check.

The new test isn't itself a compile time error, so use static_assert() to
report the error and give a meaningful error message.

Due to the way builtin_choose_expr() works detecting the error in the
'non-constant' side (where static_assert() can be used) also detects
errors when the arguments are constant.

Link: https://lkml.kernel.org/r/fe7e6c542e094bfca655abcd323c1c98@AcuMS.aculab.com
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
 include/linux/minmax.h |   62 ++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -12,9 +12,8 @@
  *
  * - avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform strict type-checking (to generate warnings instead of
- *   nasty runtime surprises). See the "unnecessary" pointer comparison
- *   in __typecheck().
+ * - perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
  * - retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
@@ -22,23 +21,30 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-#define __no_side_effects(x, y) \
-		(__is_constexpr(x) && __is_constexpr(y))
+/* is_signed_type() isn't a constexpr for pointer types */
+#define __is_signed(x) 								\
+	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
+		is_signed_type(typeof(x)), 0)
 
-#define __safe_cmp(x, y) \
-		(__typecheck(x, y) && __no_side_effects(x, y))
+#define __types_ok(x, y) \
+	(__is_signed(x) == __is_signed(y))
 
-#define __cmp(x, y, op)	((x) op (y) ? (x) : (y))
+#define __cmp_op_min <
+#define __cmp_op_max >
 
-#define __cmp_once(x, y, unique_x, unique_y, op) ({	\
+#define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
+
+#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
 		typeof(x) unique_x = (x);		\
 		typeof(y) unique_y = (y);		\
-		__cmp(unique_x, unique_y, op); })
-
-#define __careful_cmp(x, y, op) \
-	__builtin_choose_expr(__safe_cmp(x, y), \
-		__cmp(x, y, op), \
-		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
+		static_assert(__types_ok(x, y),		\
+			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+		__cmp(op, unique_x, unique_y); })
+
+#define __careful_cmp(op, x, y)					\
+	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
+		__cmp(op, x, y),				\
+		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -47,17 +53,15 @@
 		typeof(val) unique_val = (val);				\
 		typeof(lo) unique_lo = (lo);				\
 		typeof(hi) unique_hi = (hi);				\
+		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+				(lo) <= (hi), true),					\
+			"clamp() low limit " #lo " greater than high limit " #hi);	\
+		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
 		__clamp(unique_val, unique_lo, unique_hi); })
 
-#define __clamp_input_check(lo, hi)					\
-        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
-                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
-
 #define __careful_clamp(val, lo, hi) ({					\
-	__clamp_input_check(lo, hi) +					\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
-			      __typecheck(hi, lo) && __is_constexpr(val) && \
-			      __is_constexpr(lo) && __is_constexpr(hi),	\
+	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
 		__clamp(val, lo, hi),					\
 		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
 			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
@@ -67,14 +71,14 @@
  * @x: first value
  * @y: second value
  */
-#define min(x, y)	__careful_cmp(x, y, <)
+#define min(x, y)	__careful_cmp(min, x, y)
 
 /**
  * max - return maximum of two values of the same or compatible types
  * @x: first value
  * @y: second value
  */
-#define max(x, y)	__careful_cmp(x, y, >)
+#define max(x, y)	__careful_cmp(max, x, y)
 
 /**
  * umin - return minimum of two non-negative values
@@ -83,7 +87,7 @@
  * @y: second value
  */
 #define umin(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, <)
+	__careful_cmp(min, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * umax - return maximum of two non-negative values
@@ -91,7 +95,7 @@
  * @y: second value
  */
 #define umax(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, >)
+	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * min3 - return minimum of three values
@@ -143,7 +147,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp((type)(x), (type)(y), <)
+#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -151,7 +155,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
+#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
  * Do not check the array parameter using __must_be_array().


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

