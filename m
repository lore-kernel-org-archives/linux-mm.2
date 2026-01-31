Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2A7D46C1D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434796B0088; Fri, 30 Jan 2026 20:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7C06B0089; Fri, 30 Jan 2026 20:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7256B008A; Fri, 30 Jan 2026 20:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18F216B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:16:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6BE7D4DF4
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:16:44 +0000 (UTC)
X-FDA: 84390494328.24.2843A11
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3245914000B
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:16:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XqfXg1dJ;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769822203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hGbcJX/zGCic8102G9qCIKZXSgkfeWlTMil/4Iaml4=;
	b=eDUB/XhWhA1NFXTogHR7a4TJeXzsgJYJloh4B7BQZz02MhwxbZ+lIjpHGNmz2MLad0snbf
	gP1bzDOOCm9Jg5oAUIfhpn6tkbG6+xOLKCy8SHdghsWLRlvJl3lns5z5gwaUm9IjYT2gnd
	jI3xOR2DXbfbQahwok5IT5bL3cWnHhk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XqfXg1dJ;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769822203; a=rsa-sha256;
	cv=none;
	b=aXZmRASEzUOLbv6rNps3lql1rJDAC78WPi92ToSyEMQaYDOHqyoVTFCD6pi1vQkCzmIuAz
	QsBp7Xm7LRTdsJLnOgmCZBt7+gURFwG1DUAxNXDcUWFi57byF12dhN1zDcl0tj6yMrWgSH
	5JPq6r5hQkcgFS8w0T28X7P/d3RfFLo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4hGbcJX/zGCic8102G9qCIKZXSgkfeWlTMil/4Iaml4=; b=XqfXg1dJojWAta23wVrVGw8AbM
	T4YFUEpAGNRy8GVl2crq0/yviLHSn1RwjY7OLNXFUr7MBlJZLFlel+DfkeASAyFuazuY5gYbkZg3C
	r1X86wcMyDCgxj5D/ys/gdAHSFU7r5iSYp0zd049hk3wpBrFCur24CjExKXdOvqJN9VuHv/iRjxzx
	kX5RrybEcEtWMX2qA0ottyCV7wKy8E6VDoLBwHqezT7iyteAdLuRpPADA5DDr5S896BrFSnJfOEmd
	6JvaRmn5kwFYAVnGs71LXmLojX97iH8OqHMoKkN+pTlZ5RhbqGi9BrBSkACYzFfu78y9HaeWVKLwd
	KJWr0I9A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlzd9-0000000DGbm-14ID;
	Sat, 31 Jan 2026 01:18:31 +0000
Date: Sat, 31 Jan 2026 01:18:31 +0000
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
Message-ID: <20260131011831.GZ3183987@ZenIV>
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV>
 <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
 <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ntzfabfyg8bmt7zkuwy4jhn5bbnfuhe5
X-Rspamd-Queue-Id: 3245914000B
X-Rspam-User: 
X-HE-Tag: 1769822202-565465
X-HE-Meta: U2FsdGVkX192LOh93BmbeOUP9Hcmmi53nn000QLPcDrygfl7nMXNK2h+IyXh7HkmNNZVjkn551zSQEVxMEeglw3W9yNIXGHtiXxfV7czU3TGoAGHIdIqVUWApGmD8W0D9XhuCHlDqoQ/JdwTEEgPvtOHVxXNG9gtN/bre90gtnc85/jj5URMKpvT/Ky2m9wm/3bpdQQ4qMiRbCfyFTvQsDOikbM/5vskrRDZkD3zhcpR1wN+GCEIS92SJ0Me4blspQOTOCUZLDmOIODQHHYnOTl4ayq59pl9nLu/lRdKdeW+ddzODuGNpFfOfSsVCd3yxld08NVUW3le3WxpTu6+miFm/RY8mBAuIRIShjF2VG+a739dkfJYIRelCtif/LAI5+XTsnxTIAmnnpcOy0OnOYkcr0GPcTxUzOFAMlF+qt3oH7r+DHatolt8wdzIDCfmdzOX3JsM6K5OYWqEIh1FqM1nrRiRvAkkESTxz1cxvLr+1ozVLMZVoRAZzr988rGwpSIsRB0Ony6tdiqKtTaIcMO89jizx+L801Oda72sLda4OBdP5dl2mHKnZp9wjONyruTGLjX/VZuQh5ouNBUAk37G02Vt0icVzWNhNx8SPQJaA9rJHRYuEEN7W+t9DDIn6GCwlikdXpBMmaek4Kq4cQmPDgNzU0qY3gFVYZlrrLwfEj94TTUrio7yS2XoR4ID26MFcPumHUnYQkwf/VFo7kMDfDMQ+4SnNxSbl77CRWVfSjOjFd9p0eRkDjcuGvgDZj7WZ46MCaXCNbRzxeO1mF2FVM+q0cQcT+ZoWktrEO7cb8WSPdai/0mmZhhy8NrL1YO3fTIA6JFPBJ3Zu9YFWXaVNRld1lTOQVwX+ZPkGGErYsZkx4S1N42c1BWV/F17VUeB9C9GPzUQm9mz0Olrm78sw22C5//g7QtPRkvDKeIE4XwsoYCFvLp0Fn+poqP1ZhCd5clTd5112rMriL2
 kxbvQ5sB
 Z+1vEvE0mz2XAghSogpxyAezGy4LiO+Ge3Jui33bVh71HtYGWpV/3DMDYgsZi059T5A8JuwrzNO8sTFNDWqW42sJt+c66sYFjZv4QAxEWNvmbQjDHN8d4AP3pT0+ZTZF4JSFu3GOvQsZ6xSlGZKZ7ys1BUY6I92pL9INV6Mk0Z0liWyf00ik+hg6IvkW1/6hohmYW+YhioVLfUhzydooD/xl4S+BmYjXx4Zzqitf6LAjIGmJqxhLv6jCytHnple+CfcdBAvXeYX3fm9DZBTMgYlO7Ejd5OHKMvnKFo/41KLWKkqgv0z+xTdBfPraH6erkzpoMw7fqpbCrKsfbQsjNIdAtpuAUiyULobguDsTNWmm2CHFFpFcZot/bw0XGWJ/FuAKcw+oA7RU3dT9UKJ2JqBY0W3JqbaYVbY491VPNpl8gvLQB/WH/VvTLGbFKE68nMOHt7q8kKTem4S1uOUWwrDAKHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 05:05:34PM -0800, Samuel Wu wrote:

> > How lovely...  Could you slap
> >         WARN_ON(ret == -EAGAIN);
> > right before that
> >         if (ret < 0)
> >                 return ret;
> 
> Surprisingly ret == 0 every time, so no difference in dmesg logs with
> this addition.

What the hell?  Other than that mutex_lock(), the only change in there
is the order of store to file->private_data and call of ffs_data_opened();
that struct file pointer is not visible to anyone at that point...

Wait, it also brings ffs_data_reset() on that transition under ffs->mutex...
For a quick check: does
git fetch git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-wsamuel2
git switch --detach FETCH_HEAD
demonstrate the same breakage?

