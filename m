Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA850CCD183
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 12:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F608E0005; Sun, 19 Oct 2025 08:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337468E0002; Sun, 19 Oct 2025 08:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2743A8E0005; Sun, 19 Oct 2025 08:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16FDD8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:38:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A22BF11A8B6
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 12:38:32 +0000 (UTC)
X-FDA: 84014817264.04.5E26C7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31A2BA000B
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 12:38:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=nPSmMhj3;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760877511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikD2kzN+q0cZ+A+hpvPS0b6qB0klIxQK1wnjtsaF4E4=;
	b=3IlF3jh1M/xuYjI3ZEeli36O0LZSalGXAPY7GHVjphAwzid7799s8Q+5Y2b0oPNKQO2YND
	g15a8/Qo2/eIWnHjsSJQIRKXEHBBgfGeKt7S5VA68Fi9LKbs6/ZSOufRg5lyQovJrgA5NI
	pVMecw0JXnY7NG5hT48CVso928b/7jI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=nPSmMhj3;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760877511; a=rsa-sha256;
	cv=none;
	b=fAAkH5g1PNvjjjALgslgWWZVdSgkzG2oiTCrmYmau7IbrRGgnLdnRxKo/Zpp8eM0MZ/J2E
	+VYYOvk+rkdtVe+gcw2JpFDJpbbFLrhyS4piWDv+RfahHIyygxlI9DIF1T/S+DgmN0lI/W
	aOjqRFtXlKnRSmKoIOyFvQO/VVpPNk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7170461223;
	Sun, 19 Oct 2025 12:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2363C4CEE7;
	Sun, 19 Oct 2025 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760877510;
	bh=oGwiDB09ge0ciPiwd9WRh3Y/M8CeD9dHfclvYoY7FBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nPSmMhj3TEXZoJrVWpARUkUyuGqk5lSFTPPoq1ZLeK3fCa9fne3RGlMO8KN1UE5lj
	 ujRuOzzKq00FxR8F6wzbmtZQ/5O3ZNw8lG3lB3NfHxm+YwEDzwS2JsXmf0Ca6p4Frl
	 ca5FOfnjYZ+gRAebgpsYtYTlOl8nww3/qAlyQSN0=
Date: Sun, 19 Oct 2025 14:38:26 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
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
Message-ID: <2025101905-matter-freezable-39e5@gregkh>
References: <20251017090519.46992-1-farbere@amazon.com>
 <2025101704-rumble-chatroom-60b5@gregkh>
 <20251017160924.GA2728735@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251017160924.GA2728735@ax162>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31A2BA000B
X-Stat-Signature: yc45abt8cyqkqe5yufkbezqptdz4s9io
X-Rspam-User: 
X-HE-Tag: 1760877511-82420
X-HE-Meta: U2FsdGVkX18E2x+QmGIIFcIKKHtABvitpYEmVHcFRkUywQM1EuyStSey68rD+jxsApmm450JrtV47e9600A4LOTAoyKaILbO5aEkLhz2ubJQ14R2q8v4PHVK11fIXQJ/izWiVHxTlOWBIhBqM4yR3vu9dh5Ri44nwq4a+ofiAj69rhgmxktvnV5I5BaOnwq1Ky4H3HV0nEwV6YRzR9j0rfit59L8Pag6U7coE/KA5QAwyRNYJXFxiaNBNyLptxmA8sjWoFseOlQa9ZNtOHhkzDzRdLvZ6c/2v/Pt88GpwZa0wk2MKc5FNchnqGgPmw59ifz1Q7+TmoHKhaAPGL8348WTFX2mErtL7y2+bxXpiTaXfteT5U0Yyhu/HZFDtdls0lVaDQ0PtY2M5rjJiJseaalpjfjWIbSHV0DaTyqylLHNTmE6Mh7hndWLI0Y7FYnRXa/AwB3Qrz4tyRgEKTl9s3qM6VZvbCjlGSr8tIMxanh/pA9IL0Ifwv16pDOaDT73J6rJ4IzQ66tHvVkFqOvsillafrJFsrBfcFoE9DNjMifB4DR3Q6qWWELRRV/sE4xP6m0GOgKISaDCiwJZsz1oO8sWLxBOXc+Bpg2lvQs9WK2cK+g2mUie2Zk+65v28ATvakLNW0+M4fV3CiR++069IeCAUdS5ubnMKbV5dmqHCYIYaz7df/GNtPsvQjlvBP5hD2ajM+flm72ly28F6GhMKTiw1coIv+X1YA8ChLXSgBywYb8Xf/bCKvkxbM5kTdyhhuji45aPeBF7zExNlOFk/Nf4WDPWCDBx8mXKakjT2Z/q5mLjQeD4r48AAGWgjmIBGAr0f97jBnTn5bUXq6d1GtjtI1mjNXbie+bdjODDSpE+JAbl6zNWiI5Dbew5CLLdT4tAlApA2XoN5dibAegX1vK+gyrtmrHKuKbvCdZQozq0Q+NfPsg8vyxBbvsHWIionkJt239NaD0FzImnkz8
 9fmz4tPq
 EksW1BxLW7OKTMX+ynUVZMJobpna/y8lUr1neAiZzW9NW9SPortSv0AsF5UeDB+3GmdAEC94kAI9npXPJFFC93IiIq6YKVRgrEHnQ10gXLPfkMQEIvlAR7jR3Bsd6UdvKDORid+zf8bqKLxkHTj0GCPAJoc8V4qY01DJY+ZxxzXlamteDdL8seNa0mFNRZJ/X/SGLF6C4G/YjZlyNcvMdjdLFOWQTFT79G2Mf1Zjagw+6RmK+mVGfKiy4MvwRrK8Heutgmtx0ZciaSejv1Doex77+o2xn2GMlFCZEl1Yskr6i14sMqmET2GkHAdi03xIRjCXmfiKrKMP28I/VPa94j7jbu/AosdC4qP7bEzlAWJCQ91g+pllwdqIKcDwcuyOXviFX6PK1ZtVwpsIMPaS+aEm2aMNHzal97fhQpv6j4If0jmpRaf+d8UJdRXKrLmIxB67P0rZKtkuC5QJmOTlRNIn5iR5RE7HJki72bU2Ow+Z2TbJ5aHnxBw+HzFEf7Qu3H3wKbMHgFclH/qu5lGy1kI2v0LOwiOj6wBZh8voTJ9VztBlVbem0VscDn/QA4KSqOntORXUSgw9xbytgNuNXNc/8YMDPOLnbVtLxX0B2OkiO+ZLT9f/+qmx6IWkwniC/CU1kp8rcQa8eYcCu/je4R/sar4H6dli4rXKbyCHQQ0BuSNz+Lm2A24poYOYwzIbngCmYTSHZQt+Nqmr9lpUakL1AShR8nI2cTgzVuUtb+dfIPxVBZXRyUqu4eDOpj8Cs+FHRciSM8Sk2w7n36vhGWOI5ZCgz/021xu57CZnAliCyV7iZwyMOysHzj7NCPFssJeTLlwAP4w6avYFbGBAvn0s0PiiMAMUI6zYt7ajvgGRyaQO2DvFvKwy5TpJ2O8o8o/21203iaWGk8zX7jYrMx+otPNMxuxWynyEfQThTt4nPdBhojjzv+HITHy4pwVRmnPgebeJzF8Zw2r21hs4QCQgRRu6m
 GkHG6ScF
 Gbhsjql9GZp+ETzKXy4748iQjNvfnEBIK5vzx7fNyLkxh1/zKDM4v8pM82lzkCoPUiJFehgNuRpBEzWP1lYSf4zCDxw3jcPYRbqUpEaiQl+p9pz6hXZUb1mvdh5JuVfxyBtp1EE/vihOgxRYq3OhwTvecaMT6YAGt0k2LcouJ/0mi01gA7cOkMVt5/pST5lmG11xmCqJfxZ7xqQKQvDUoeVpWjDj14kDymN+R0KaYhcfbxZoQqppB3fJdYBHHSdW1gvQLw4eNdMFnGSKDZXMP01HgOFLwYT/0EkKMTtnsJ8BkwAwRxfmC6er0ZhMleTML9Tr0bcwkMNhTtAgZU/iPwrUBrJbzoXCFvffezxh3thLpUXyN3krxsE14EpAUJhVyxpkFrKpYzEhGmv1fBDgLrEhtkuIrVYjxSa4LH872EjtKnS6i7TYqfIplDd1OJXddZHTAH1pPtFaDVIlvrCLFVabEvhXvW8ZZWpidKo4VySwXhUzadJbWj6uat9FPxiBEEa6mHCcEBYLeN+I2xDOh+cEljqW9f6L4dJEMqEsvacBx4J/3bWxEpoFNp/62HtbE/mSVPbYC4N4ajMUSqDqr16waOklLmpvaY7MgRNAPvYJbtONQVngRsbfNOgSeHBCho54fXRTEOpgeTyaTNmuCLw1tE7hZ473vfetE+I9U8ZzVUWQ+i9754jzEqMko5J05ToVrimoCnZBF36l1C70FD3c+riucP6kXMcOeo8UPNFJPkQjfLhe8i6ktYKY6862T8r47NQ3KcuclsqglZwqDxqQ0HV+zl18kNLV5Up9Dk2UMXvZwS/3WWartk976EdLXW5WN/9/NSLTCRKnjCv7AbiytiT6qALSSOYspkBbLaRw8XJmbP8THRxvjUwVgZw5fNTuw8Yv/nOTexNiIrrZGmIBKXFNz3yQMzbQDQhz6C3ZVSYPUPSFzL1ZJpr/HdeZBnXeHblnUdlGEQOiNShp6JS1PCG7D
 sNGY/RRP
 oD9lY+Kaxy1TcuIEjMGMXp+MkMiscy1Kz0c7ubgDT11bw9e64rOISHVn5aeuc1tq85kI3Buko8xGbzNolluNFzo/4aQsHXuzZCNRnfGbguEwxyfyd2vD//5rGPJumZ0nnuTGt8O67JjgbxVTaykc6+tFaojDuymKX30bJu3CNZbCg/mvWwi78pI4n7TTCQewrkK1EbmwUKvU7tVZRsDQrQzMNgMWBm1L/kLiWyvWE2diKFx39eOkdGbzbueCGdTK1yHLyqjPujvyKTP+hz57yS2nwk/HLauMP+jTI/0eZJYolxxtza0FhGQjT6pW6qaamT9r3EDsU2ieGR/6G+hrl5Lyovln8XMUF3P0/dod6J1pBHnPFrnCaX5e4z1frIk5Qt4o/IZPnjNhjxOvwTuE3KafkX3E37HqUv2ACLyPeAtGjH/aIinamrB+TqUf5YlEe2LoPtYMgv6xUyQg9CPCv2LDHqCm/bjsev8+CYPCKqxQbed5lyRsxDZ6Q5L1PpoPrHZNeNOsZtVbgcHeW9mFzqi9A14frTU/AF1b+iOLB5BZau5DL3bgABZ/Bkw+BU+65wKeqrwoH7BrVNH6G+Wn5duZxjfKR3WGVUVesb51iHQm3ZOKRgft1I+BfbA9CpBJeTrQ3AgqF4tPqvFvqLK/hQack5aqJJq9h/wnVTFGf2Dg7jbDZCQRfoBGhrXMDkMnNsJX3Hc8KQqk5rX5YQdtJ6RVo0bc/awv1DLPjfzqy/kHgwgYwlqFTkadqF/mcQKUCn7L1TtF0kwUWbes7pvgsVYFIfP7l2qUPDFqOeYhcPclxLpT83sTJHd3w5AuWbk5AAK+IMusHVjk9j9qlnEKokqIHPfVZvjMHrGqIvD3Ytb8+7LYqdlblyCcrGYJynsy8FygR6RmmQhIxQqt7qJA6TihfJ3hmH0k/30dmUZR4a4hxKiA5IGeNF8nOupj8BpwhsekR0VgOgNkPEwMmhd6rYf7AEKSw
 kBfXh9lv
 kOYbbBDJCriKElsbYn6rs336bfe7pbCjn9vhwXXLessPHO/0Q7VhSuGRyU1lKed1afLeaisxsAdO7qI5rwn/wmt5aJDEVqFsINzLpyRplNuXyO9p8OzlDN5DVTl/D+8QPB+saAyKV4GnbIcGQQIX4+n55h3eIBBAK+aOESjhRPbndxTCP5b+t6edE2CjMf2EziSOJ0rk3Zh5TeY9RAuvSFJ5DZq/psA2K27Olm4kh/2aKEaY4bOJKh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 05:09:24PM +0100, Nathan Chancellor wrote:
> On Fri, Oct 17, 2025 at 05:03:02PM +0200, Greg KH wrote:
> > On Fri, Oct 17, 2025 at 09:04:52AM +0000, Eliav Farber wrote:
> > > This series backports 27 patches to update minmax.h in the 5.10.y
> > > branch, aligning it with v6.17-rc7.
> > > 
> > > The ultimate goal is to synchronize all long-term branches so that they
> > > include the full set of minmax.h changes.
> > > 
> > > - 6.12.y has already been backported; the changes are included in
> > >   v6.12.49.
> > > - 6.6.y has already been backported; the changes are included in
> > >   v6.6.109.
> > > - 6.1.y has already been backported; the changes are currently in the
> > >   6.1-stable tree.
> > > - 5.15.y has already been backported; the changes are currently in the
> > >   5.15-stable tree.
> > 
> > With this series applied, on an arm64 server, building 'allmodconfig', I
> > get the following build error.
> > 
> > Oddly I don't see it on my x86 server, perhaps due to different compiler
> > versions?
> > 
> > Any ideas?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------------
> > 
> > In function ‘rt2800_txpower_to_dev’,
> >     inlined from ‘rt2800_config_channel’ at ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:4022:25:
> > ./../include/linux/compiler_types.h:309:45: error: call to ‘__compiletime_assert_1168’ declared with attribute error: clamp() low limit -7 greater than high limit 15
> >   309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >       |                                             ^
> > ./../include/linux/compiler_types.h:290:25: note: in definition of macro ‘__compiletime_assert’
> >   290 |                         prefix ## suffix();                             \
> >       |                         ^~~~~~
> > ./../include/linux/compiler_types.h:309:9: note: in expansion of macro ‘_compiletime_assert’
> >   309 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >       |         ^~~~~~~~~~~~~~~~~~~
> > ../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
> >    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >       |                                     ^~~~~~~~~~~~~~~~~~
> > ../include/linux/minmax.h:188:9: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
> >   188 |         BUILD_BUG_ON_MSG(statically_true(ulo > uhi),                            \
> >       |         ^~~~~~~~~~~~~~~~
> > ../include/linux/minmax.h:195:9: note: in expansion of macro ‘__clamp_once’
> >   195 |         __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
> >       |         ^~~~~~~~~~~~
> > ../include/linux/minmax.h:218:36: note: in expansion of macro ‘__careful_clamp’
> >   218 | #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
> >       |                                    ^~~~~~~~~~~~~~~
> > ../drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3980:24: note: in expansion of macro ‘clamp_t’
> >  3980 |                 return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
> >       |                        ^~~~~~~
> 
> Missing commit 3bc753c06dd0 ("kbuild: treat char as always unsigned")?

That's going to be messy to backport, it's not even in 6.1.y, so let's
leave that alone if at all possible.

thanks,

greg k-h

