Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD200CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 10:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5948E0006; Mon,  6 Oct 2025 06:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176748E0002; Mon,  6 Oct 2025 06:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064AB8E0006; Mon,  6 Oct 2025 06:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E26F68E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:47:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3977C140582
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:47:52 +0000 (UTC)
X-FDA: 83967363984.10.CC94456
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FF7D8000F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:47:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E597mMN/";
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759747670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nqu8YNaVpvLUtvwTbrdobGNSP1VPHVqHjVywccQvOag=;
	b=rjAuEUcVKLMEleu6E//6ppmV03bkIajMIUDL1xHLy0OgAD+iZRPs1QYUTwFKSTSUOsZ0Gd
	RrA2W8HJ1/IUNE/6g0DDy/ivWNOod9OpooKfJvI+y0eCoB5MnK7P+zU9Q9Tjgm1UgWS5vx
	dyASKO7mbwjDhqSEAhNjw2fMgRFuBA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759747670; a=rsa-sha256;
	cv=none;
	b=2kpQ2uGXqh5OPz8GY4Vw8gtcAtJECEvmixtGThuH559/rSU3/ZRXeUunjwrlUo4upP6e5J
	qCFJE0kqolNMLJ6t67wpnO1YO1eKFNeybT2LiRZyt77xO3QInzHJUIX5rwoFIKiJUL4nF7
	L0pgzI1cbSM1Irt4/zvaTfXiIYK0w/A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E597mMN/";
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F5B860454;
	Mon,  6 Oct 2025 10:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDD7C4CEF5;
	Mon,  6 Oct 2025 10:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759747669;
	bh=FX1Lzu7+bvM9e8qmukvbO1hpPMzmlxgfp1qFo7AK/EQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E597mMN/x7YVkjNX1Bc0G8W7GHt89kk8u2seksXgi5q2H3Gw9DqBry/MoIgd7Hl/f
	 QcuYuZ/DwxfZxXg04LwRoNwgtiAl8T7SsOstK7UXK8SyqkUmffohAckrwzORjzcTe+
	 /i/1SV3Pn0pttPu3dXePy8Hlmyjuwx9fL801o6Qw=
Date: Mon, 6 Oct 2025 12:47:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, tony.luck@intel.com, qiuxu.zhuo@intel.com,
	james.morse@arm.com, rric@kernel.org, airlied@linux.ie,
	daniel@ffwll.ch, maarten.lankhorst@linux.intel.com,
	mripard@kernel.org, tzimmermann@suse.de, robdclark@gmail.com,
	sean@poorly.run, jdelvare@suse.com, linux@roeck-us.net,
	linus.walleij@linaro.org, dmitry.torokhov@gmail.com, maz@kernel.org,
	wens@csie.org, jernej.skrabec@gmail.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, davem@davemloft.net,
	kuba@kernel.org, mcoquelin.stm32@gmail.com,
	krzysztof.kozlowski@canonical.com, malattia@linux.it,
	hdegoede@redhat.com, mgross@linux.intel.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, sakari.ailus@linux.intel.com,
	clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org, pmladek@suse.com,
	senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
	linux@rasmusvillemoes.dk, minchan@kernel.org, ngupta@vflare.org,
	akpm@linux-foundation.org, yoshfuji@linux-ipv6.org,
	dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, jmaloy@redhat.com, ying.xue@windriver.com,
	shuah@kernel.org, willy@infradead.org, sashal@kernel.org,
	quic_akhilpo@quicinc.com, ruanjinjie@huawei.com,
	David.Laight@aculab.com, herve.codina@bootlin.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
	linux-sunxi@lists.linux.dev, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-sparse@vger.kernel.org,
	linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net,
	linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v2 07/19 5.15.y] minmax: simplify and clarify
 min_t()/max_t() implementation
Message-ID: <2025100648-capable-register-101b@gregkh>
References: <20251003130006.41681-1-farbere@amazon.com>
 <20251003130006.41681-8-farbere@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251003130006.41681-8-farbere@amazon.com>
X-Stat-Signature: 6bthmpkf9qwzugtuie7tp158por9hasi
X-Rspamd-Queue-Id: 7FF7D8000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759747670-605484
X-HE-Meta: U2FsdGVkX18GGsUxjR+p+OG4SSAnDSRks7EzDChA7kjiYP/FbQE0gl9xvgDyr/QOOMRmVdf7cB4liNNBvc2T3+2E9flLQPKYb4do0a6CLbj2Cw08GTW7Qo/rnTgam/RQHRk9Hc41UWbAjF2maIwXiW6sfYA2UWy0Dl+LBmyZRmgVnkR6dCqptBGOCkxpLqolpCEXDEqU+1iRuLifnnTE99n2+ICPnmdu6OGEfrTGPBXCzYxx9N3jQgSCSzBlC9m6kO/aPQNttq8+ugqbDiNjyE0BZHpC73J/p+bQfDFQfmxiPCgj0VVxI299lhL0OzIFCYOeAibf7riiWgMyCrufTVKADANzmGzlQg5enS7+jtzLDmbla3Ol3mcxZ/gE2H9I08q8+MrHfl7+1cDOusQBZDg0nfJ0DmITL5gjhwUryZsa2fXofxyf03gpw4WAsHLp47IGwCz0XUDojxoWELJSa9iGqPc9AO+5ChYOMyMoLNfrkPYGxyHd9CwLIfvbo9yPeVjwY1vgpxi9Ino/DJYF6TJOdjbvCW9KxyVPaiH6bCFlSngNlD4lakXeeC6BseDesHK+Md9HxawGsk3+JybZ15e1A/avNpxuHVNF/8qdUiA7EGB6ZOR/GOHWjUp8djAGocnUU4sOM5lLDor4gLFary3zW3cX+Wwd7/C2yJRXlkqoJeUevQ20H+kQPVgRq+lhwy0kODJ1p9wES5UBK7OQsupmS4zx1PGch4gKC4JbXgm/2+TBZh6WLmbrlyWtBJOBuhq73b6HQKUIvFQL3sgYAlpzLhOiMjetr5DYfXT+D4ddjm/zJr/Ko/xys/XkvCCwcwtR1eaV7xQqer3bIEcJJtQ8D2VHCq8pY4V2PdfjbIo5e/Fsa389rcBc+QHbRS9va2jjwGvf+8cTDqG0B54kMEsnFbMsVRQmdcJ648ZDho/onjLET5+oyaHiFTw/855VMr13uq1kJJvzo8e/9VO
 7gBqrTUd
 ZheLSY39RxYW6grhFD8+fM8oEnYRe49amyky7jhQYIsd7jn8Kg92nB/SBtd67xAd4QFxYpeRxPb9fFheYxGAfp+hKZ1b01ftDOsJflCa2nLgfBJW/rtotCmidz77FfTPs2byKQo7XOVIelbEV6Fpgmx2arQjepqqH3oEDdI1PbP//5JgwT6fbvPzUDt5wLy1c+omdLz1powPgeiWLD3uD7NiLliw0R/GcyYN4qSaF8v5agbxT22RHZbnYrO0x1O3Hq5jZzDM96KDEsWOP2grb+V0wyewc2W+jsC4qKRhR0XIgiqM6ingycWHF6k+3AJvGxzg2QW1OytWyar0D85V25BcxL7oc+9bgM+ZtxltDQ2zQyhOy8yqEYZfWPqd2CXM80A8ADRVeRYF8aBoHrtI56dquYx0lDEriIrDeySZ89BiTOMfp88tGWr1nFQPzhM0GATNaYf5XEE9QTEHLMEEYEZvLQlp35PZZ0Hom3LpYgObJRaKxpDUPHk9P7IGjXGt0YbH2iUi4dRjneQ+aubc0JHzsbrMG0Vtl48Svj7W2OMKDBaAUUK8ug48ofNvV2OImyrB/qzDMzDgSKoRO/N+zoRW+8RjFg3p6cbIjejUYZKhnjQoLPPlFIWZ+XOvFZ0jHnLsS4q3KieJtIMwjd4xm/5/5K9CxcqlHiFAc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 12:59:54PM +0000, Eliav Farber wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> [ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]
> 
> This simplifies the min_t() and max_t() macros by no longer making them
> work in the context of a C constant expression.
> 
> That means that you can no longer use them for static initializers or
> for array sizes in type definitions, but there were only a couple of
> such uses, and all of them were converted (famous last words) to use
> MIN_T/MAX_T instead.
> 
> Cc: David Laight <David.Laight@aculab.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eliav Farber <farbere@amazon.com>

Eliav, your testing infrastructure needs some work, this patch breaks
the build on this kernel tree:

In file included from ./include/linux/kernel.h:16,
                 from ./include/linux/list.h:9,
                 from ./include/linux/wait.h:7,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from fs/erofs/internal.h:10,
                 from fs/erofs/zdata.h:9,
                 from fs/erofs/zdata.c:6:
fs/erofs/zdata.c: In function ‘z_erofs_decompress_pcluster’:
fs/erofs/zdata.h:185:61: error: ISO C90 forbids variable length array ‘pages_onstack’ [-Werror=vla]
  185 |         min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page *), 96U)
      |                                                             ^~~~
./include/linux/minmax.h:49:23: note: in definition of macro ‘__cmp_once_unique’
   49 |         ({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
      |                       ^
./include/linux/minmax.h:164:27: note: in expansion of macro ‘__cmp_once’
  164 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
      |                           ^~~~~~~~~~
fs/erofs/zdata.h:185:9: note: in expansion of macro ‘min_t’
  185 |         min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page *), 96U)
      |         ^~~~~
fs/erofs/zdata.c:847:36: note: in expansion of macro ‘Z_EROFS_VMAP_ONSTACK_PAGES’
  847 |         struct page *pages_onstack[Z_EROFS_VMAP_ONSTACK_PAGES];
      |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors


I'll drop this whole series, please do a bit more testing before sending
out a new version.

thanks,

greg k-h

