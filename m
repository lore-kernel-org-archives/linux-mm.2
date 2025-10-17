Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69787CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E568E0097; Fri, 17 Oct 2025 09:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6618E0092; Fri, 17 Oct 2025 09:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5438E0097; Fri, 17 Oct 2025 09:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0528E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:50:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68A141DA6D5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:08 +0000 (UTC)
X-FDA: 84007740096.25.EB3A401
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93936C0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:50:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GnSRlmd0;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760709006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=8qH74T/unu+vyyxcXmOmm9hgYi9a+jF2BcueMkCbFM0=;
	b=M0Z2zYDknWrFbamM79cTi+CJk6j5VLMZ5zcJ+38NrKeyYV1LMHQon2RzWwNcfEAHU2NfYE
	rfggyEVl/WCkPm5YRoTkMUFYQ1X8tdi5e7kCSIV0JGttN+A5lWTtLyZabfFuml2jEzBfpX
	RkNdwHIRcOLhHfHfEoZgl+eFq+pQ5+s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GnSRlmd0;
	spf=pass (imf10.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760709006; a=rsa-sha256;
	cv=none;
	b=2mG4VNvAlTJqHtdaoBGyFlPpbTYucSSIXbfC2jcDqeWf4Ooa84lpnDHAKCFLoMz+XQfI8E
	CWIqD4NjUnufpkWvSjCmUlrmhDpLlgUWUtJaBKqZO81iCe1H21BoMLgLn4s2dHc1uamjLi
	r7oTgzqt1kUe8pDH/ifkvwNyxcVb4so=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92B854B415;
	Fri, 17 Oct 2025 13:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428C7C4CEF9;
	Fri, 17 Oct 2025 13:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760709005;
	bh=dmLSOb2GYlnT9o1IkzmIVv/9ztWuUVzDp82QHtRSSS8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=GnSRlmd0RtwXk/OVucv97XC2fxDtarMsik6x8upmP4o2u+cekk7MY6s05aPjBeFFp
	 h/4X3h3X9WtLvRI9Scrx2awB4Y6i95XAs6CRIzzTr+coAWKcQM5/+HnmipPa1yqZxv
	 YFKLIh7u92D3jKwiQ9EUaSnbdBWSj8l3R2t2eUwk=
Subject: Patch "overflow, tracing: Define the is_signed_type() macro once" has been added to the 5.10-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@linux.ie,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@st.com, amd-gfx@lists.freedesktop.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	arnd@arndb.de, artur.paszkiewicz@intel.com, bp@alien8.de,
	brian.starkey@arm.com, bvanassche@acm.org, chao@kernel.org,
	christian.koenig@amd.com, clm@fb.com, coreteam@netfilter.org,
	dan.j.williams@intel.com, daniel@ffwll.ch,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsterba@suse.com, dushistov@mail.ru,
	edumazet@google.com, evan.quan@amd.com, farbere@amazon.com,
	fery@cypress.com, freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, harry.wentland@amd.com,
	hdegoede@redhat.com, herve.codina@bootlin.com, hpa@zytor.com,
	intel-linux-scu@intel.com, isabbasso@riseup.net, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	j@kvack.org, dike@addtoit.com, jejb@linux.ibm.com, jmaloy@redhat.com,
	joabreu@synopsys.com, josef@toxicpanda.com, jpoimboe@kernel.org,
	kadlec@netfilter.org, kbusch@kernel.org, keescook@chromium.org,
	kuba@kernel.org, kuznet@ms2.inr.ac.ru,
	linux-arm-kernel@lists.infradead.org, linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-um@lists.infradead.org, linux@armlinux.org.uk,
	linux@rasmusvillemoes.dk, linux@roeck-us.net, liviu.dudau@arm.com,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	martin.petersen@oracle.com, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mgross@linux.intel.com,
	mhiramat@kernel.org, mihail.atanassov@arm.com, minchan@kernel.org,
	mingo@redhat.com, mripard@kernel.org, nathan@kernel.org,
	ndesaulniers@google.com, ngupta@vflare.org, pablo@netfilter.org,
	peppe.cavallaro@st.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, rajur@chelsio.com, richard@nod.at,
	robdclark@gmail.com, rosted@kvack.org, t@goodmis.org,
	rric@kernel.org, ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	sander@svanheule.net, sashal@kernel.org, sean@poorly.run,
	sergey.senozhatsky@gmail.com, snitzer@redhat.com, sunpeng.li@amd.com,
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
	tony.luck@intel.com, tytso@mit.edu, tzimmermann@suse.de,
	vbabka@suse.cz,
	whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com,
	willy@infradead.org,
	wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com,
	x86@kernel.org, xiang@kernel.org, ying.xue@windriver.com,
	yoshfuji@linux-ipv6.org, yury.norov@gmail.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 17 Oct 2025 15:48:34 +0200
In-Reply-To: <20251017090519.46992-2-farbere@amazon.com>
Message-ID: <2025101734-uncertain-tragedy-c5de@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Stat-Signature: akrnf3hz31cez1rxso8xm8tg4nmmqmgx
X-Rspamd-Queue-Id: 93936C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760709006-800282
X-HE-Meta: U2FsdGVkX1/zk1MhOBU1kScc2NpOCZai4yh/OMFtDg6zbPcUX3rDe7WhCXgMX0hk0JnBe/7fA0YkpdVGs9HVbHQAQNknxLdJeVcPWRzwyf9y2vd+EhdUEgU0nL/oIZLAa+ovjm4rzHr/caztvEz2YYQYfno03ayzJHjsoE0kc7QVx8Nf6vtHXE04tC5J/WemPyK4zm787hm8fYmRRJQmFSSkhqU2R3N1Lmoz+hJMXMlrrJGzNWtRa7MH9ZVZVpMWznbit9+DRAEVRSw5hQF7qQMW02Qph394fkd9ro/1TkujGeidxk93/UuuBHBM+vTavMmbdVmPYJ24oIws4mzjOwSw/GCf0kCLf/ZmwDCfMu4LYJg+oUzPO/V0FWnKl/p4x2cW7JXurc5yEZeGx3NINek3IbcCxslDIhDadKIR3+TouAgY5BTtiCUyk7seFHbB7nVCiDgAN2vOtCUGKO2Pkkf6J6vuwFMOJQQFrOI6nQm3DAcvZTFdQf6ixE3kB4GlNP5SgAulXXh+Nl+twHIP1xtu1Ewhqg4dyL17UXpRcAXEZPaIOZaH0kuz1FCy4/WfshZ7ry4B/L69C5IBuchVMntl59RpPSZc8VUOxXnMH5VAAIzv/1UyBPDLzc8kE3/dCxSvTZYSAFiaBF8IEv71caqwYyZXQDRqGcCK0UMQa6Lk+NdePohdS0AfXhZ6CWI7VFedtSy8hHcFSZtJiUTGBxTPx0WscxC+l8rqqUyx5aMTkO3uWD95MSKYIzI53VSPU00rbQMLBNWTUlHOK7j64YCqsjqgmMdxdy7RI7kQA73SEdwMCKRAytM8KugGTfFF6i5peYI2qQ0VeYivHLpdmfd+1BtRSivCvixcMaNF/J//UYEQi0uGGBw4B87wAZC9X97O4GXZf7CVwl1IrSxZ8C5IxKqv5/I/t6D90ohlnExmYnmuFeDyLY8FGGluoXb3cQ6htJLoc8T9hExvUU3
 MyE/yOXX
 +V7uspkyrB44GbyNeYSS9pvF713TRZUoICs4H3YoxbHI01avkcnMDvGlIszeErv980J+eeWiTukM35bBlNCawjOR81UdGT8kzag6LEzypGm9050chGy3EkWS77VKtLRzanaHjG/1VNeD1Y/RJQne1s3djUk4LUsvcEYHlGBp2r2cV784HTImBuwJNQA8wNi2+WHRAqwGNAu1bnscL9J2x3j0QGxL7BLZu/3HfbV2ZoS/QyZ8mIvdwOMQ9UQ0iRPAU9QGDRlbsjhTR1spgjVFCB2ihYiWiS51uABXb7vz2uMN4QJ3Ki+bJM8jZFOFKMb2P5i15QWrj0HYpn31OU8m/CVwRsijGTpmAvD6kvstlIex2SbFt5r1Z++KGNfXd9hscMHhrhdwMPcarZ1kT2p7pVTG58TyH22j0y35EiUGDhztUCxvHxyfUbxTxlX4mhwIFkvo/Wcbf4Klew7mWYtkgEtOuXMxZlHR1Jcd6FfRt66ENZvUDWv7I0y9M14WlpaJh/EBtXk8x2QozwQutp14IMwEx15DEzl7PQhbOpQ3I4FoA4jjpVN2aO1tFoLL7ImmMqXr2dQFdxzN3qSVgLVMOp0DD+pY0ER2bbwjekgy4ehEHPkWZtXUsqkSsEr+QszjmB29vWDhqF/Ym48Vkrsu0FNlt3NYw/JgjBNIAdqQvRR2a7rZHnwpHlj44lVpryCzApeRQoIyvD6Aip6DhREBh9K+ZeEpjKlYtr1mHYYkjtydTGodB2dJrjACkCQpizqfclzseTH96/9IQLSQv/NoJRYN7W+1gFukTcA5Ip7x0v7T3HbtUgAhLpyOJaauU6tJCAttX1HCBjhzbrZwkQ+ZZ2+HCjPcsimQQc+/oYonp+v96TEXIuHunq9TB2Cu1OnhFlwWUmOdrSJinfB/hvEreG0vbBVISCYtsjbnhMLI52p+LqCiNukhfEGM71JxjtDXre/KLL/ZWidjKxSgicXun4pgyMn0U
 pJf5ITej
 3fW83CK9Jem/UAbqZRUM2/MtlLhaCseycneHNnESl+K7xwHxhUk+haVi+6GIsUlo4ZqxDWcvdlxhkU4B4oTg9k1O9/s1egS7bA8R6WtJMAplW8aEBJghJiUvZxPgMHxGOOIqKNVqjJI68uYEb5Cles7NPku9veco5CGD/2kUYYSFnrSCXCe3KcQxWMlIFACyFy4uJHQMGCIlMW3XPPX2IsIE/SV/f9bn+Wvw2EkUIYljlMwa3F0I+fGAjX0DmhkiENtPbR3nE1cFN2+gSAwNNSzd/y9ZIFT/AGI5IF3jCsUI6wYOeIjxrsLOTBIo/GoqjyM7vOvbEMvEiwRhv/plW9Gv3UdzGDGL3jbfaXy3KJfmN3gKk6VAy9SDHeSSP0Ci5p7pfNgVShUbRiS6+MWQthjJlqQoUZyUU2jnIu54BbmxU4entu7NNJPjRQ+GDkQ3JCSHCqDZnk0XUaXPEGJBBPylydEdGhlQoY97BmvIkPVQx6VToi9HeJels9ZBOD6Nl9Mlac1sYAOqkue3MeZhzyCGhjEFUF5vfxhlMXafsOPq9HiiXqYLqtDAouNMYV8XOMcxsPtzfBh5ptSXzOP0QY0pwoDzFfTL3RcxyKwfRsR+wo2Z4yWSBJkUNrT+J7IVHnGQ3cmv8Sk/xh/tLonQKZna0CxzwqAL8FLtgYPvHpGBYiPmqAlqFoB5AXUCnvrgNRL/B/5YQYubOf1eQhX9jYb4fgZ56tVd3L7DEUmTPiMM126ojYFuDJO+RBu5tnpPQqyf5b9FIsjkUKLFl3b5f8lce3bU4NfMwyKtuDoEcCVgJxqPUUvvtvxBfGiYPkxt2g1YWKeyo5UPSyLXX4ZGczPuOoBV9NN1RCQDrP2JRzOZ/AMuc7HVGT3sRtQPc5mDCwVCei5QRyt/KW8WSiM/Xqq2n/pEpovl7gzuDkam6i8BhiDcg+W/IybmHfPCsCzAokpctSubaJMNNcYoWiWMHdtdQXC02
 9KbGmpss
 fFTS+s/o+vBfX4CKWksM025G8PVGOC+soJ1yZo6tyqc3gxaDp77VhKvGZL1VqV7w018UscdG4KSNvjGi5YobWWiNGn88az6vlNwUM08aogFID5fkLKwHoB7A2imSow6ZEvqAlwxC6tV0t/RAwdXFURtSvPwrA5O52Bxfx5FaepG1J+yrPmEqiAEuacpiliaobiLXvebejI6azelffF2Kw7jphq/lvaFjPDKtnRwqRQNUIYL3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    overflow, tracing: Define the is_signed_type() macro once

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     overflow-tracing-define-the-is_signed_type-macro-once.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34939-greg=kroah.com@lists.linux.dev Fri Oct 17 11:09:40 2025
From: Eliav Farber <farbere@amazon.com>
Date: Fri, 17 Oct 2025 09:04:53 +0000
Subject: overflow, tracing: Define the is_signed_type() macro once
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>, <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>, <dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>, <rajur
 @chelsio
 .com>, <davem@davemloft.net>, <kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>, <chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>, <sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <willy@infradead.org>, <farbere@amaz
 on.com>,
  <sashal@kernel.org>, <ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>, <kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>, <ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-dis
 cussion@
 lists.sourceforge.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Dan Williams <dan.j.williams@intel.com>, Eric Dumazet <edumazet@google.com>, Isabella Basso <isabbasso@riseup.net>, Josh Poimboeuf <jpoimboe@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Sander Vanheule <sander@svanheule.net>, Vlastimil Babka <vbabka@suse.cz>, Yury Norov <yury.norov@gmail.com>
Message-ID: <20251017090519.46992-2-farbere@amazon.com>

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]

There are two definitions of the is_signed_type() macro: one in
<linux/overflow.h> and a second definition in <linux/trace_events.h>.

As suggested by Linus Torvalds, move the definition of the
is_signed_type() macro into the <linux/compiler.h> header file. Change
the definition of the is_signed_type() macro to make sure that it does
not trigger any sparse warnings with future versions of sparse for
bitwise types. See also:
https://lore.kernel.org/all/CAHk-=whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220826162116.1050972-3-bvanassche@acm.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler.h     |    6 ++++++
 include/linux/overflow.h     |    1 -
 include/linux/trace_events.h |    2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -246,6 +246,12 @@ static inline void *offset_to_ptr(const
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
 /*
+ * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
+ * bool and also pointer types.
+ */
+#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -29,7 +29,6 @@
  * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
  * credit to Christian Biere.
  */
-#define is_signed_type(type)       (((type)(-1)) < (type)1)
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -700,8 +700,6 @@ extern int trace_add_event_call(struct t
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < (type)1)
-
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
 int trace_array_set_clr_event(struct trace_array *tr, const char *system,


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

