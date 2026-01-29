Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B048D46C16
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABEEF6B0088; Wed, 28 Jan 2026 22:22:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C656B0089; Wed, 28 Jan 2026 22:22:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E4A6B008A; Wed, 28 Jan 2026 22:22:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83EBD6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:22:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D91201B155F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:21:59 +0000 (UTC)
X-FDA: 84383552358.06.FEC2B46
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C19340005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:21:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eifTeQz9;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769656918;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGsU9GobbaGgoU5iMsb2Tj/ECBvPozp242GaUSp9zUU=;
	b=O05tCY+wLlNSyvqz4j1enI+ZAYn3/rXcEag/VAvDaZ3AUp2BBu9mPDlK87RaHMeZqjxpsb
	zGe4uex0YMNhlGEY0g1uErUvJNNT3LveLAd+TjP3iulhZghGudfSqeak7dagmyR7dr28w+
	mAvLWAoB0DxWYwEcbG/NcKwM85WabmM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=eifTeQz9;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769656918; a=rsa-sha256;
	cv=none;
	b=VLhwgNDeWy9lPpBAofXu3/sPCBeL13+P0f/s8NZNuqsmhHXHLzAAw4S+9ADulnKGqo971x
	iLN/z4tcU/nnEnA9718zD0/Pc05D2SSyelcD0XvVKjgCCz1a7O9x2hOJ1bSjSxvZeM/8ED
	rTO+6twD0k6zd1miEXDjwmFfEnMCFRI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=BGsU9GobbaGgoU5iMsb2Tj/ECBvPozp242GaUSp9zUU=; b=eifTeQz9MUGgKqDQsKzmHBzB2j
	+CtwHru4Xvc8D5sL9AdjDiqJWwNUFLA4+enSb3HA8EGGjQ/KpTmT7gakB7E0zhfXtSQ15zpP5lBBg
	e6odg/oBWcZoX5HZCZc2eYHerpWACeqgAgw7ymX0/SYyrZbo9XVT/WadmSYd1IjR3qee35vapbO3p
	gJkrrQD+C4GjLabtBWnvoQ+eYIrU3CzT0XUAwBsyq/vYVwiKdr0hgb0eOuEsdsjQ5NMnVRQwtSI9G
	c+nAwH3W7Gnm3mac+MbhcepOrQ8lFKBi3dX17MkNJavZ/NQqs1fFtM/bhJVq1XDSm3DzyYjCgs6Ro
	NcMMDueg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlId5-0000000HVLd-0y2U;
	Thu, 29 Jan 2026 03:23:35 +0000
Date: Thu, 29 Jan 2026 03:23:35 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Samuel Wu <wusamuel@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260129032335.GT3183987@ZenIV>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh>
 <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 8p6oi9npp4gtq4j4yo4rm347p5b45yey
X-Rspamd-Queue-Id: 5C19340005
X-Rspam-User: 
X-HE-Tag: 1769656916-24187
X-HE-Meta: U2FsdGVkX19BhxtTpZempnTopcKkS6FJRPUmv0b+JQc5YRy0GZSqjVNxW1BormlgJyxZlpssZ/mQsGOiLMkiNbjCh0wS/G3qBSg++Tjhcv5x49yqMQVctTAWTcStZ7EHXMTZDhQx76zrXO3bBAywmPfpdl6QkF1CyjOS/agzHuSVsZAwBErzTM8jMmMtLSdTSp5Emju5yF/v1VPyg2q8APuf3MSGmdqnjyAdO/Jl5nZiXhqkDeMu/cC4gfCrESSnTgYoVci8OWus/wMwXxUb5dm3uT9IVZjO3ZEBaLxWuj3jRVmgqeBLblGCAvnvJSfQ3gw59rmKeGtpAaOgBCxCpLFmo30ut26BH+/dnJdq4OemP+QygUMXFjp4i05bCblPXUzX2gWXXxW+cCcithqke8+vv4etJD/A4ET5oICVjvi9UVpp4muTnCVIWUlCgOArlWMf2GCZUm1gozE6KjzbvxM4dDy0kdGA1BtZ6mqxjnecezoekh8J3jKtDSjbTzA+X7kydZjLUbwgAqRe63rc0+IwoResk8AbqAelOe+XgDckKg9aeXMdJclfplvb+rnG9rCz0AsvzLgzzIpwgc6oYGIh6s99j6e/SxmXA5R+rY/k8W63caVGSU7kfA7q3NmJ1OwdttYsltvK9mq5oXu8bS2zPsR+1hU5nJVNLK1q1nZJeiyU+Kx4DkdGmsld+nE6jywMEPabvnSIwk9TeAmM03WmtljkfKugQZxMmhVNOXhEtw3e/vl+j2g5FNSs3n1oJOwrivIqAfpvD3VoLKsjrMCP290SZv3ow/2SwYoz3L7RgOgX4Frn55AhnADJHHYKgcVMG7UgwvBpP/2Ch53fAAl6CCQYCUTXHvdQd8ns9bIcfLD6suVzcxapHrbdPWeU43W+BLpkpfETgkFd2qy/gXPzYbExm6bY+dNeCVV7dCDNGFJ46xDHQ5Z8fp210/L3xeuC/a6UiIfUPBE7juz
 Ghr3Avt6
 +R53b0LOunmrp4IGlSNTd/LLC4eMM6iyEr923MZxrDOW9NQS1kLHl6rnRnEN/KsGYmqrql3IP2+MBAV4xSrU+XcpIgt+jzOk3tSbYK2sqKFhp1e8HsjGLYLgAgJcWwMTewe+gu4LZ5EmoN1wHH/fvELfT3so2Yyt0AD/Bn6brVUH7+JjeWzN80/aeQbPeT5ftZBOwt1SsaoQu/Ff/4Y1U4gHqx3F6DOc4J5u90q0ZPd2EU6J04Ik57yiYYInhlPMGssZfWhlcBIJFoHOGBZrnPJwH3NG1HSbOZVNAoAmX1shcigiDo29STLZbX3FFy/KprR3ms5/By9F+gXUlQqoX7Fr6dvPtjXe0m7fRAKFeJQkwr/s52YqXlxW+68ztuBQEZ/3fcw/eMa/A4xx+PtVZIP/VP6CVR7nRAo3loVoAcyeU0nn93LNDgWQKeGAQJYXX3SxmmnO9elfESxp6DP0zUICHWdf4KTaLNURoH4qtkwzkh9mKleeoEaJTOlt/sfl+zePokcY+BOgggd63dJ50C7ZFyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 04:58:57PM -0800, Samuel Wu wrote:
> On Tue, Jan 27, 2026 at 8:58 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > Very interesting...  Does 1544775687f0 (parent of e5bf5ee26663)
> > demonstrate that behaviour?
> 
> Reverting only 1544775687f0 (functionfs: need to cancel ->reset_work
> in ->kill_sb()) does not fix the issue. With 6.19-rc7 as baseline, the
> simplest working recipe at the moment is with 6ca67378d0e7,
> c7747fafaba0, and e5bf5ee26663 reverted.

Sorry, I hadn't been clear enough: if you do
git switch --detach 1544775687f0 
and build the resulting tree, does the breakage reproduce?  What I want
to do is to split e5bf5ee26663 into smaller steps and see which one
introduces the breakage, but the starting point would be verify that
there's no breakage prior to that.


PS: v6.19-rc7 contains fc45aee66223 ("get rid of kill_litter_super()"),
and reverting 6ca67378d0e7 ("convert functionfs") would reintroduce
the call of that function in ffs_fs_kill_sb(), so the resulting tree
won't even build on any configs with functionfs enabledd; are you sure
that you'd been testing v6.19-rc7 + reverts of just these 3 commits?

