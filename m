Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2998606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UaihiTx9
Received: by kanga.kvack.org (Postfix)
	id DE1486B05B9; Sun, 15 Nov 2026 09:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91E76B05BA; Sun, 15 Nov 2026 09:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF206B05BB; Sun, 15 Nov 2026 09:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08E36B05B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:18:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 243F2160752
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:18:22 +0000 (UTC)
X-FDA: 85437558444.11.C1EA76A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69F65140009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:18:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaihiTx9;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794752300;
	b=7lzcR1E24a3EoKa6DlcvcBon1RtBy0ab3vV6tqYx2/4gPbZB8GIdJEd+RNSlanl7W1bJxj
	2WGBh1p1SJyZcHAX6+poudvzXPxM38YRgZ4xs/xqq/mANf2Dip3KZ/T95HYDi9dOWzQ2D9
	WTX4V2l4nkJt/+zvPxWhRgv9KZ/9blU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaihiTx9;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794752300;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSIEtI58igpSkC03ZSunkIyPCpxjJGmFBTOTFfPJaAY=;
	b=WYKdQmW5zmAXh2iPJO0ZaFvyd89JUrAOvRIpm+iajWBSNSAGl/lULEbAsaC5vlJznJ0zYu
	uMqlSXBOXeaxV6h45AOd9wLEsYxuPvFP926xc2641XR7WnDcxcR4IyP881weR3VRU5YrGP
	gDGdSQ62VOROTOFqYREWbI8aJT0EtYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DDC042A44;
	Sun, 15 Nov 2026 14:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F3D1F000C4;
	Sun, 15 Nov 2026 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794752299;
	bh=MSIEtI58igpSkC03ZSunkIyPCpxjJGmFBTOTFfPJaAY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UaihiTx9MzRiQl4ssjwIOWuOQnwxBHZWiEFSMT3+M8Jz80d6+8xpYG97TN/cTGs2G
	 WYdm8pz7zAar41etMr+831psVY9i+HgE4mS2PEAk+IHgbMmvkMxPN4RH+uU5/IuQ2S
	 XEbs+nvT7rwrdos5pyOiDoIfEf2D5tSLc0Nz5MxHuaTgfRTVsMw/KsI5H6+Jecp1dP
	 RMDGzaNZsZA7xji8eXBBpMQblnEMso3385xY0XFNQzxGG+SC+9BVmUaJYPz0O6cZZW
	 mNSJhbrLAt8QQDlU49fdieIvcteFG9royl2EDk+bVkmRTn+nqnHboYoAkpK2vEHZ3I
	 sLd+x2p9XfNLA==
Message-ID: <sashiko-outbox-215574@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/13] selftests/ftrace: add uprobe tests on overlayfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>
Cc: "Chris Down" <chris@chrisdown.name>, "Miklos Szeredi" <mszeredi@redhat.com>, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261115-work-ovl-d_real-v1-12-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-12-ca155efbcb2e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 14:18:18 +0000
X-Stat-Signature: ut9mses4mprjmmhkpo8z5xfm97k5nzdh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69F65140009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794752300-636485
X-HE-Meta: U2FsdGVkX1/EzLjvEg2Gc0kYVt4IYtwhjqtGUTPUpeRjRjEs0JzKg+zYVtaUFPyRfrkIR7DLZ+PRalraHzEzAeAneyG7uQP+/tkId7Ut4r2KvgCO9l+R7VIDl0TRZadnKVDKB2vg5/GImUFO4iOgJDcQKx3hBEHGXFmzJPSC8kfmFgKyU4DkLnkLeTv1GSOO3UoYFq58TfkcV3EyQ9RZtwUJ3GSIbv3F/KxuCflWwMtgf4L+sjGHp3expG++EvRt2tupLHklddTNw8sGzYSMQfvQ5EoVdDUCPY3XEOgqv/bYSSua/a6M/Rlxl9pCeNkhW7msCg3fUetuGo/yRHAWPlRkh9fv/eqWM+iV6xFdVvGbk0pjKNotGdFM1Ko1ILqRA0kbIQ0h0bvV7gIdDJpjEzaLyQSFQYe2bD73631d9O7Rfpyyr0UkKuyve6ba1/tkzHufnHAxnY+FM2/p052nmy8UiNT6HfgrkM7jNPt72N9gZkrC9QgVw4isnHoOLKv5BypLu7VhqWCT9+UQ5eaicN/D6gtNzG0NVT6bzDfhDm030PIahrI0XpXciAdsztolnrP4OXOlF+AAUeV3XfO1MTXcvRYUU0/4xNQWAQReyJ6z1y59B3qwmoIfO3lpweYtmU7X3I4rgciXdvBnwt/zBVKIjgAprSb0VqjFqcnXFxn5NO3kSrQt0PSO1Yt8CW+zk6qjf1pbG8zKG2Z7EEOYTpLzjbPj1WXCdjZyRy9EnFrxBEnJyDHVugw3KgF+eSt0F4cB0QlE9vFGRyp6DkT4nXq8fgyj6O00fYczi/KjCPVKxYmW1YBOqT8DMH3ZT7MQq3s0Vs778ZwEQ58tSopYotUkbNEiyRoB2d9UFkP9QEV33hy45kphMZhqmCSzIeTxIaAfvwHbZIIq/6/m8D5yJ0gtjZftTfL+7/rnkANkdiQWklm0321z7KQdAiSrZZHiqJdnb/lVot2ngoZd43U
 arfG4g7X
 Ag9oSTE3TZjO1L+mwRLVuQgD265I1Ob/s1KmKF46lwHvSbD4hgOdC2IRlRRKiKYkLwoR9i5sGS+0wnEKrd3tBfBFYSrk3DWVjCwFTqrqM4fJCS9yzYCWIMD7Em2rclgVfc0wMx6gnzs+lV0AMDXHipT2XACiSmODed7XYq6CNzj11EjRqvBLGce/bSoefbooMKXtOPe5q7Dzy24UTzo2VGUHzKXcbYRqz5YLqhUQZpYs8XIfhDVR3sb46KwZoIffClwy7Wf7bHkv2DQvQAAuVKnpOmHSFxbnCtWlVrykfWRH+JhmoUjHK+AV8ry0nx51pbuUZyrMPJLv6m9LTsmmnSjNP1D3GulKQTOsv6hv+Do/pwDgL82B3T5nAbUr9RmkG83uWTXZkmkbqyf2rUSjotfe663BbZ3l66ghxqFAC6vmsAFam/3swVKEUDvRIi6iB/1ZJ5R4HN0rYg+LOYxf1Y2QkE9zI6AE7s9FCtUdiYiPdkznXkc6IMa7S1meJrQr8ONyTSSUsjJ0wgVRwunFTgmWtqJshWIX7ZINgdpx5eZPIASQpnGSiJsPGmQUTh1Jq2kaR7sEbSVEACXsJN3FpWqbgYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests/ftrace: cleanup() in uprobe overlayfs test fails if
  event is enabled
- [Low] selftests/ftrace: uprobe overlayfs test misses tmpfs xattr skip
  and configs
--

commit cdef3f0121f6552797f32e8a89d02391a6081a77
Author: Christian Brauner <brauner@kernel.org>

selftests/ftrace: add uprobe tests on overlayfs

This commit adds an ftrace selftest that exercises creating and firing upro=
be
events on overlayfs metacopy files backed by a data-only layer.

> diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_up=
robe_overlayfs.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remo=
ve_uprobe_overlayfs.tc
> new file mode 100644
> index 0000000000000..a4351e6a3b181
> --- /dev/null
> +++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe_ov=
erlayfs.tc
> @@ -0,0 +1,92 @@
[ ... ]
> +cleanup() {
> +  echo > uprobe_events
> +  umount $OVL/merged 2> /dev/null || :
> +  umount $OVL 2> /dev/null || :
> +}
> +trap cleanup EXIT

[Severity: Low]
Does cleanup() fail to remove myevent and unmount the filesystems if the te=
st
exits while myevent is enabled?

ftracetest runs test scripts under set -e.  If executing $OVL/merged/sh fai=
ls
between enabling and disabling events/uprobes/myevent/enable, the EXIT trap
runs while myevent is still enabled.  Truncating uprobe_events then returns
-EBUSY from trace_uprobe_is_busy() and aborts cleanup() under set -e before
the umount commands run, leaving the uprobe registered and the overlayfs and
tmpfs mounts leaked.  Writing 0 to events/enable at the start of cleanup()
would avoid this.

> +
> +mkdir $OVL/lower $OVL/data $OVL/merged
> +
> +# A metacopy file whose data lives in the data-only layer.
> +REALBIN=3D`readlink -f /bin/sh`
> +cp $REALBIN $OVL/data/sh
> +truncate -s `stat -c %s $REALBIN` $OVL/lower/sh
> +chmod 755 $OVL/lower/sh
> +setfattr -n trusted.overlay.metacopy $OVL/lower/sh
> +setfattr -n trusted.overlay.redirect -v /sh $OVL/lower/sh

[Severity: Low]
Will this test fail instead of skipping with exit_unsupported when
CONFIG_TMPFS_XATTR is disabled?

tmpfs only supports trusted.* xattrs when CONFIG_TMPFS_XATTR is enabled, wh=
ich
defaults to n and is not selected by CONFIG_OVERLAY_FS.  Without it, setfat=
tr
on $OVL/lower/sh fails with EOPNOTSUPP and aborts the script under set -e.
Also, should CONFIG_OVERLAY_FS=3Dy and CONFIG_TMPFS_XATTR=3Dy be added to
tools/testing/selftests/ftrace/config?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-work-ovl-d=
_real-v1-0-ca155efbcb2e@kernel.org?part=3D12

