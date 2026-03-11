Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CB61125820
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CD66B0005; Wed, 11 Mar 2026 10:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389F16B0089; Wed, 11 Mar 2026 10:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295206B008A; Wed, 11 Mar 2026 10:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0053E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:03:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6FDD160236
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:03:45 +0000 (UTC)
X-FDA: 84533950410.04.D6B8C7F
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2BFF160013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:03:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773237823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkAgNZHJ9JPdfVojz2Uvbc0Bs1V/TN/9xj0aLCnFPcE=;
	b=kA2Bc8gHrRPxuae5p50He7H7GlyjViOuQA8iEoP6VOq++1RJa+6KKrTrR+7dNobMe8NT46
	6UiWykLfWxBOXjKTtCFVhESU/B+PVc8p6Yrc7nIkUZZKE8QeaDpZneWm8i3llsXFY7achX
	pYgdIG9Iet8w/DqCJcLSbxfK5AXbCDs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773237823; a=rsa-sha256;
	cv=none;
	b=wvMdgb6KWPq84WqrMGdREP7J5zBUp9gk3iJDiZdszPZveoOxy10ZFzZLrjVp15eMh5PpzS
	gxJ+PZ277qGYp2HhRgsXhqw1/SRVaCcydhyDO/V4Su7QxX4vjbNQ7U/LX/ufZiUOqn8FiK
	jXtrvKXRRGV8/3B2YpiNpWUKOFMlrRQ=
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4324D139CEA;
	Wed, 11 Mar 2026 14:03:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 0CF3220025;
	Wed, 11 Mar 2026 14:03:20 +0000 (UTC)
Date: Wed, 11 Mar 2026 10:03:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL
 check
Message-ID: <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311141332.b611237d36b61b2409e66cb3@kernel.org>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	<20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de>
	<20260310100750.303af303@gandalf.local.home>
	<20260311141332.b611237d36b61b2409e66cb3@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+skqrXXDxm4il2tsYmj25H0/GTzSRdMUI=
X-HE-Meta: U2FsdGVkX1+aU4mY7bFvO8lRauP/vgjT20dobHa0QHVROVhTP6xZNvlHFy+HnthX7C3DUw86Ksayk8kipkioUde1pGRJffeDzlmGTmiRQAtxOhSsM3gHnZJQZGdgNXBABYZdeE7OsMEvCI5Ff4ZQbbyu3yXHRyZXg5AHof/AO0vcusmeqjpCWWhtLLOcuZIY7+tOVjT7VktVnLaFPp1jjRLc3JQ2sJ4jp/SiL4aHgDK/k//b9d34oAYT+AlJT32Fm0BFv3eObF3U3OAnj7CnGXu0MyQ+0edSgYKqKIiOybnUsF1fYSODF4X+zk3bqwV4HOqJnRMkZevrGktYEsiiqb8/qNY0d6MZ
X-Rspam-User: 
X-HE-Tag-Orig: 1773237800-364001
X-Rspamd-Queue-Id: B2BFF160013
X-Rspamd-Server: rspam08
X-Stat-Signature: nuspb4311zxcsumwpnqgxzr9x3o8jxm4
X-HE-Tag: 1773237823-516142
X-HE-Meta: U2FsdGVkX18iJMdOPo+EZ8zRxBDf6iD7BPEQzjglZprHxoo+fSAral0eS/rtqJ33/YE6phKeq3jrV6Bss5X9WTb2DcHSm5yDR/uswUu1g/ekPeWlxBVsLbqAeg8v4LjUqdpBXpFDq/XFhnBf1WkuoKyZEXdkFMx4HuF5JzEc2K2kdZqENCdrQxfsmYw/BUIOMAPAuDQup+1/OkTwXCjXUwCFBk3U1NHoDknJ0sMAdU2Ws76/H25b+s4Xs2RmJ3seFWS90pzszFOf+bCPtKlWHl2HaDmB20mrZOls4xJPfujyBMlxLJhLUSX0qujaTUajPzOdxP0aZRbMGKqSkOWjD+B6M8XyxiRIpBqHwWZgNtHvw31Km/vncvR2KrovQ8Y2gdSU/mOm8fvgzMY9y359T2Sz+abLMcJVH87kbd9Ph7GMRxXhfnV0IwR+4vSVSnaHtSNITjwoCAh+unijZbKPuJOZCBKEoWvAkjZlfYNu5QIQBerNjv588ceOUH2yIg40kFNEU4SZWG+r7ych47dNbO2hXSZemFh3Odlw/AXc06Y3xhvSvwkqqFDgl1ZL5GpkDcmEhPqC16vwBvBQYGsSGuOW7tGm4uDf7VjhQnUxsu+7aJAvYSR3VYGTu+yseaAjNrtzPKg+QhHIuY7zZOJo2ri5qqPvxUqSLwwLhdMjSod74J09mxZlJXCoAF7vP5W0w+JMqaiMMG5unv6TVdF7bfgIBGJG6qh3jW56/2+DaHElT0INbL/4o7ezQqRtQRpSDbAClQDF9JhIpGy2eqsl0BewKFfqOeTC4mSx1C/AdJQsDjZVERU+D5kiMJ5k70Nl8VEX8S81zPm4BQjfiGXKrIzKrcWG3E8DXDanPeq7/l4e8iUfRT9db3c9+3arnLEtM9RjB4WyZ7slUclixzGjNUDgwUtyBdIYf3Lvziu8emnPgTAyv9C0DgmOtdiFPoGb94VUFluV9u7iDTZsC4r
 uZ9jO9pX
 n6hVQDWUgsI5P7U0XD3GNCpcRCN9rNNFcuW2OIfcya5m4MWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 14:13:32 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> 
> node = rhashtable_walk_next(&iter);
> while (!IS_ERR_OR_NULL(node)) {
> 	fprobe_remove_node_in_module(mod, node, &alist);
> 	node = rhashtable_walk_next(&iter);
> }

But now you need to have a duplicate code in order to acquire "node"

I think the patch just makes the code worse.

-- Steve

