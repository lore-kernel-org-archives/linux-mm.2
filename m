Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC85ECCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 16:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31EB88E003B; Fri, 17 Oct 2025 12:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF2E8E001F; Fri, 17 Oct 2025 12:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1977C8E003B; Fri, 17 Oct 2025 12:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3A138E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:09:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4383B77AB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:09:53 +0000 (UTC)
X-FDA: 84008092266.14.FE89D8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11713A0019
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:09:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YtSviiKK;
	spf=pass (imf15.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760717392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nX+mtnNcQcWlv9JGlUu/KrtXpqebuR7wZinuAUmv6BM=;
	b=gXuzx+ZLuEaFDhRzng945R+d8aSLGKhbBVPV9BYSEwJELgCXgBRQcGE2eHBcAW5i6N8BIn
	MzZ+b5q3UHDkFFy0uozlEexcTQTEYqs2jilGYHOuEUzGDb+nBrM4f3upnPSMd67cdRAUVK
	nOBlndqcw3uVEOAHmZkEPKhugaZLaMk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YtSviiKK;
	spf=pass (imf15.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760717392; a=rsa-sha256;
	cv=none;
	b=n2MnKnr8cqMM09jvibKdwoAGMpThXR1XQpChBWjCIfC9NyIcXTicWHF0bbBi/+37tZz3C3
	aa+2Pg1a8JWvuerTcplWVD6af7Ku413ypfFwdzmt7Nd0LCQYWyyKZ2i28RVHgltm8zImHq
	Q/nw1/00w94R/ttXRXYvMhNJkQsR4Cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4990C60546;
	Fri, 17 Oct 2025 16:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE17C4CEE7;
	Fri, 17 Oct 2025 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760717391;
	bh=BOrYC+tXjLjRqJyXcD4crvrBNK2lkUpKkjfEmyc87bI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YtSviiKK7XhOypmn1B0JMTFJNg+aK9xkicr5kleBJoGLQsIHX6oRtRnPJgXbXWtLH
	 cVrvwZYIhcft0nkxK/ZQBpXxxHeWHw5/VEilYnGTD4lEZyzXP8wqDKjbklEc7PQZxX
	 jrw7mNWuagcjs3SnKes4mzFKMKH2tiSDMTY+zRgHS/b+KVlZKnLK4gb6spqja1+1F5
	 LtRKkkOtABvH8jmUIF+maywb5ma9DVPFdB4So5FQ7XdD3Y3FN97CNzQWMZICjSRgyi
	 XbXdYmBkEWUiq556ItdRa+tvmxGUk+V9ozsqtDgWFGhyHQtvMVM573eif+FMsCQ1J7
	 ilRe5q/VN9eDQ==
Date: Fri, 17 Oct 2025 17:09:24 +0100
From: Nathan Chancellor <nathan@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org,
	linux@armlinux.org.uk, jdike@addtoit.com, richard@nod.at,
	anton.ivanov@cambridgegreys.com, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	tony.luck@intel.com, qiuxu.zhuo@intel.com, mchehab@kernel.org,
	james.morse@arm.com, rric@kernel.org, harry.wentland@amd.com,
	sunpeng.li@amd.com, alexander.deucher@amd.com,
	christian.koenig@amd.com, airlied@linux.ie, daniel@ffwll.ch,
	evan.quan@amd.com, james.qian.wang@arm.com, liviu.dudau@arm.com,
	mihail.atanassov@arm.com, brian.starkey@arm.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, robdclark@gmail.com, sean@poorly.run,
	jdelvare@suse.com, linux@roeck-us.net, fery@cypress.com,
	dmitry.torokhov@gmail.com, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, rajur@chelsio.com, davem@davemloft.net,
	kuba@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
	joabreu@synopsys.com, mcoquelin.stm32@gmail.com, malattia@linux.it,
	hdegoede@redhat.com, mgross@linux.intel.com,
	intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	sakari.ailus@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, xiang@kernel.org, chao@kernel.org, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org, pmladek@suse.com,
	sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
	linux@rasmusvillemoes.dk, minchan@kernel.org, ngupta@vflare.org,
	akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
	yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, jmaloy@redhat.com, ying.xue@windriver.com,
	willy@infradead.org, sashal@kernel.org, ruanjinjie@huawei.com,
	David.Laight@aculab.com, herve.codina@bootlin.com, Jason@zx2c4.com,
	keescook@chromium.org, kbusch@kernel.org, bvanassche@acm.org,
	ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-edac@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-hwmon@vger.kernel.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-mm@kvack.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2 00/27 5.10.y] Backport minmax.h updates from v6.17-rc7
Message-ID: <20251017160924.GA2728735@ax162>
References: <20251017090519.46992-1-farbere@amazon.com>
 <2025101704-rumble-chatroom-60b5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025101704-rumble-chatroom-60b5@gregkh>
X-Stat-Signature: qp4n4rshs6zbwp8sch7qryw33brx1tfa
X-Rspamd-Queue-Id: 11713A0019
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760717391-378778
X-HE-Meta: U2FsdGVkX19v0Q2h9NX2v+h2MLuw3EaRrzB9+4ANPr7+weOUDWbp6ey5EEbcMtBTbudxTOE8aH90oaB3+P+x90WaeeFNEHAonOgTSSDzZWPPVzlaEPRH0N6IC0WmCB0fJ1UEaG+cIf/1EnetgWYEngXzSiwAl2+3S8EJruP9t2masIleIqQ7Ri43S4onZUBJPolI9JjSya5a/ZuJyppALjUNBFdMWjfEkRg6aAJ6xMOTGSpsx4ldo0ZHSJy27KXpgODKtp5ovH57MQcBAFArYf3ICs1XZVEBGFYKQ+fJsZq4V0oSpiXR45+ppn5VvR/vF67tlLwV6n2nRqMFygCCWPQg+W6zwze/nsOD6FvuYv6rravJPUOI8yO7zAM9oMV4GaiK2UGbpJbkCYWlKNsW3BuB5eAFZ+FBr+YHqAV3yiRCXAVnhUyhENHJc0/RQLEx6DU3W+q4W7SUjBPwzCCEB+8GECnZWXNWDyu/4G5AGwteVxaFl4FpjIY8lL5BIQPmMYdsNXkhk1Fqw48VMFtozf6sRPGpK6IwFf+0a/DtoimmK5/En+Onkh+ElYjj4o5CmsuyD0pjqGTXWUmkdnnrAiLNEZlyzKVPKDG8JWGxAe2nwYkCRKrqRS4pa0td2F0xbnhw2Cl5123oJY4M8PIIWbKuB646wcdXizpSqNj1Vu+MRftLwP+mtXt/sNCic+6bhH+ygBkD1iQxhwXkA8wo5KYZMn9RbCFxxryy9kn/vKd31OXmCqUyPtQuRRB2JFV4nmsElVn+N/txNQWCOWMDsakLb6svRcq5v1hWwW/b+i+Ldiz/rBnSSXz/KvGnFOkCec1wn+TYnWU4n0Zd6H9JYo63qmfYcQVcg0T3gOuImG9ofGTXQG8FR+Mo+sMPE/3kFGS5lZ8SIrng+EtG7dJOQPQNv6tI48Y3GUnQUodBIcvFfoQoULLLSXjaeDh54Nn24AtvuPdCDPJ1zpGYBSp
 LdhPlq46
 Yg7RNLSXry5RspEfdjGcG3qvGByXNhqcBI73700ANEpepf0Y9v8gSTNJtE2fC6pT99vfk4k6XnDSoYSJftwF/dt5noGxGYMSoLYHcPZfDMugQByZdoB1QuAlk8IcIcW/Y6a1q7BUGXJdXKRPuaHQM2HRnnjSFm4x+Gq200NpJMEFw9wy/AHfx+d63riBhciRcNXUU8ICmqC07IKXEw2paAro9eZTwMsoqxQmIb2qCqeMwEyCxxo/h283o7HBMetB+m0EiXK1ZsEeTxdUnFLkuQ/rSFKCb06nt7wciB9bHREBr6hI4ukNUjOY2Evi9Xm4CQ/VbHPjp1BpMyFKobWyLrJAnA/3BkFwT8bfB2t/diaP9LdndEkvZJhZ63Xv0sklrt+3SY8A2NrPHV1VCpIj9BWptHANL0pL0o/+bUs/6jtZZbKa6KeM+oCmRDrGO1z7uLl4M8UqRuXFnMeEHYS686cZd9KQHhNCUF6CJJiImVNP9f4cpYdeMFeFzJ2eQYks7Ita/KxTNnB8LDgOK0T9VrDC5jWRllGuLPuDCKXwJJysGIiYOnOlBguIqeB1bSmretgHLHQHuoC1Mpyuua6zuyKlNvqTHeyZdO0boVGHGL1+pzmb2vdTFeT1rRRxu/qow3fqacImGMMQT7HwhBCAJzqwhLk8FuT7M0CPXD5Zv7m5FDoubLuh0zFlUHRdhYfEjGLuWqul+WvoaEz73I07zfqPII1PV+Wr51cn18/sAbrddHJ8kYNZ9PDynZti+sXqF5BuDxUuNwzbtJEalfxTcUg8FlK6/gP+GqFkIKHeILrMMyNNUVG4paiTDdGc6mqbdxDbIykXH9Mnj0MOpltWX/T7dLFg6j8dG0ABlt7KKJFG2B0csCBxGXuW6xNMFfyQ1xnGm6kN5yJ1L5+YwtC2bN+aBQH+3zA05t2VUNk+tLz3QbIydd6yzgHZAk3vz/eMQf6jvRsxUlrysPwZT1OLWCiO1QQYK
 paX8KceA
 DIwf3W5x1meW0magtrHgwnPUMPczhAAvJHE0Gg9mR2SB5GnpTr8o7wCy0pRdG6MpF4mKjD7GN0EdKnelUCZRVggT9aIDAvcyNWCadSvbZDNiGdrf6vp2nGAmEbvEztqnfBNmrYmAjZiEqJ7VqFZlvaq0s9pnRsuq1IyyhnpbyRhsPVRpAiTAd5GLqFmJZXa95eTLOjvMZA94KQPqJexJmNQ62pOreFDzl+RRzFoeriLEnHWC/buKM+VEYa8xeNd3ENPqkyqjP2U8oEkD0mFPmMZtIPF5esNnQUVCvyu7+G5ohulm2xc0D5X/IrzewUh4hqtU1593M74YYLFkr7Y3MbXFX+QwMnUnwbmz98cf8baePkmawg8m92bFyBxeQXj3EdnxF3OSJxwPDaiNAw2iYc1Ba5Rq0tT74VMxfdOCx+MaEYlphyIe5g3rss/1kU2MSwuHjfqfuW97bk37xNE7gJT126sCma6lz5Fyyb79s8UcJNxhqQOW72cencRccU4iSBXjpxMsk6hBSMEe3R7qymmkNqQG1Z1S5e/kiEzDOS9XsDW3YAyDtZFj4vauc6bPTdroQVlUB6GaeAkVYfQnYa4elO1mBwbeLWtNmFoc1+4bCg5S4gj2+PCZzrLvieMXu8oNu2UN4G5dHM1T/n5bnyBDPOP3DdTDaKup/uoPQAGDQvCZsSSBJc6p2gWTLvUJWllZiw+Fq1hSomaX/zHi4pWlnwnlERUhKLHtTemUsFU9PVFQN4aHLjqIGoauz0yQz+SCIS/ZYv/T7MRLx0hMHk71gvJLlaWVYWilEIehCoOKhznDFSjhi8VFvdeHBOsNmY4CyGP4swU2ly4fihrdmv7/KbgONX4Ed9JduyXra3u+BOYKadqHvX5uNsYxrvNWC6DgHJnAOer2AiMXy+LPgs89FookqQGZi78Apw3ZTc2gwxmjLdjtau2TQ2HexRynHXOjUHUjeIfIwruuQdCeTr/Vm04Ys
 1KMpG2J7
 DiygV5V23EGKyWmbOsrjNPGGYmFAmnMyUu357Ti9iJCl37JgGtHlvLwJROW7m3jzCXjJwUh+cvl/tIp6g3ioonfXP1l/8eBQa+FIb7mXd8QS8M1ZDcpNHSuRW/3VWKWN5su0Nzun4ucZYCndfdqaWB0m6lDpV28IMb7TaREy1VeBki6ZefPj4HGZLacT03jGGc4C6JbGelE2wR0f3X//QUuk+BlcJdFVMkZ4s+Hk4ZBKtf/e5flE49yz0en/HgNFqF0SXZuA87exzpCIhSbF8JJBSj1KGqiD/rUMtlaFSnHVw7ejoQuuemHOuqLsfXZ92Irc8kVLR////2umKGm2Tonv6X0wwxLYhnSQp5+Bx6d2CfslMwagJ15u44ifBg0yUSg078q4A14fiPkOFe6yIHA62Nm8uhi4HlQElagFk9VbvD7+fSV++GXm2iua5CsbIoqKHLnxTu+8SeoZ9IsVyc80F4O61sATBxkrc66uMbq/WHTw4lkRJ6O5ItXM8Gga0qOwDYYUtVXrI4AkwZkj1VsCa/FiBZOTaU57MUr+Odm+3e8OPTn+wyr6PyBnX0n3OyFZnMbWEr6LwuYlKrAulVY2wgCsn+X+eHSCauxgtrnCbikgRlyEFyt8fNNTyPrlAIXn7grWTbm8o2fI6RaMbI7Z6INWMEkzN+nWsNTmE/QOqBBivWgz4eBYgX0f3yDJZPGX2C7AosVuQlnHgHWT9YPQSL7dwCV4/ShwLVOQKbwvpsuzYSCHhg7iDVCvN9g/uxA9sSUms9cnSHJrjjWRi5ggaW3Z3ejxXpZjZKcugrLD5ROi99PrkhZID0PSODE+hfN/6+WRrrndp4FlKJIQ74eHqVKYiJ7iumWlZgTyZb1lNE1LtXWvGHyEMTeJZsxuRy1fmn9FzmjPx1obGzUcs3XIqGG2IZ5NcWEZNDcuYuLxcyLMA5mlScCfjj9DRifQNRcUnuQo/YQEvXsgRZQOGhuTeWyfu
 SlKP6Pnq
 1H67QEhPg5yjfRLT2aCtBtkL7r+7FvJAJ+ztiLfL69SbQ0+ty24y+YqdzlRfx8xQjvL8+3i5/XfHLkNXOeWYUD+FETNc9S2RCq3gWOoyHEU4EQ86gC7/HKAf1TYj5qDr9tNitI5YR4Oq8QAA5uwJqItfci5C776O01s4dK3FliGynBpj612ngyo5n8Juo3QhH305yt3SQnKP4j1iYuUrtbiXGyr33/7Jgpvdtm7Bc6Bcv8Bk6DqJlw2OJy7wYdpqJy588jcah1bktiC4cERpgKRkxXc90O1TCe7lr+ciHEQzhXNjL0uVaLSn9V+3oJxMDegXQqVicON4oBlnCaribRHEmWi164xftOTdW+8AxM7S7RKCdhu/BJmvaclB0dsej7E93YYz+0W7nxopihY3f5LKXIhx1Gl1l+2GekbzYb2Xrte8Gut8+uFi4XC65c1cwLSQzKVh+U+hCpzdEexmoKNzrwhMuhxrOasDAvXZg0n2UxAAdksXnEHFedXRXLPas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 05:03:02PM +0200, Greg KH wrote:
> On Fri, Oct 17, 2025 at 09:04:52AM +0000, Eliav Farber wrote:
> > This series backports 27 patches to update minmax.h in the 5.10.y
> > branch, aligning it with v6.17-rc7.
> > 
> > The ultimate goal is to synchronize all long-term branches so that they
> > include the full set of minmax.h changes.
> > 
> > - 6.12.y has already been backported; the changes are included in
> >   v6.12.49.
> > - 6.6.y has already been backported; the changes are included in
> >   v6.6.109.
> > - 6.1.y has already been backported; the changes are currently in the
> >   6.1-stable tree.
> > - 5.15.y has already been backported; the changes are currently in the
> >   5.15-stable tree.
> 
> With this series applied, on an arm64 server, building 'allmodconfig', I
> get the following build error.
> 
> Oddly I don't see it on my x86 server, perhaps due to different compiler
> versions?
> 
> Any ideas?
> 
> thanks,
> 
> greg k-h
> 
> ------------------------
> 
> In function ‘rt2800_txpower_to_dev’,
>     inlined from ‘rt2800_config_channel’ at ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:4022:25:
> ./../include/linux/compiler_types.h:309:45: error: call to ‘__compiletime_assert_1168’ declared with attribute error: clamp() low limit -7 greater than high limit 15
>   309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |                                             ^
> ./../include/linux/compiler_types.h:290:25: note: in definition of macro ‘__compiletime_assert’
>   290 |                         prefix ## suffix();                             \
>       |                         ^~~~~~
> ./../include/linux/compiler_types.h:309:9: note: in expansion of macro ‘_compiletime_assert’
>   309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> ../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> ../include/linux/minmax.h:188:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>   188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
>       |         ^~~~~~~~~~~~~~~~
> ../include/linux/minmax.h:195:9: note: in expansion of macro ‘__clamp_once’
>   195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
>       |         ^~~~~~~~~~~~
> ../include/linux/minmax.h:218:36: note: in expansion of macro ‘__careful_clamp’
>   218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
>       |                                    ^~~~~~~~~~~~~~~
> ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3980:24: note: in expansion of macro ‘clamp_t’
>  3980 |                 return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
>       |                        ^~~~~~~

Missing commit 3bc753c06dd0 ("kbuild: treat char as always unsigned")?

Cheers,
Nathan

