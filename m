Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88457CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D530D6B0088; Tue, 26 May 2026 05:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01276B008A; Tue, 26 May 2026 05:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16D36B008C; Tue, 26 May 2026 05:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B03CF6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:01:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 466D81A02E4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:01:07 +0000 (UTC)
X-FDA: 84808976574.23.8601F94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E21FC000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:01:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiPct5I3;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnrCbM2Qnlfg9PJg0zChR9cS1O62PROxyneyrD/ESZc=;
	b=TZJR8Ak7kRVf61DLEA3K2+LQsIDTnNUch4ni8APX+FRUK867X30i8fq9ES9YFH3US1dlPB
	IiXgu4hSfRhp21aorCbF7uR567MndYCOiQgSY2TJOrvs/lBleJtWkdI5zGRRV3DN0sSwE7
	dvfT1lqH0rn1w+pHY0uLvndyETLykOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786065; a=rsa-sha256;
	cv=none;
	b=ZgdCbhyuGVTG083F4zallCNbalwD8PDa+nR1xVFhgBTg7xE1yNFbF2P0FoylIFVLnT5p6m
	w1FAq+V619OuC3z2uAUv39EkWgqVhFseup3DHuJQpSG0/f5W/lHcfFpSFawPFHEYff4wZs
	tv3Gfrrz3DkK9JDXRUzgKx5C3jW8G3U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiPct5I3;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A3FF6008A;
	Tue, 26 May 2026 09:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285D81F000E9;
	Tue, 26 May 2026 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779786064;
	bh=wnrCbM2Qnlfg9PJg0zChR9cS1O62PROxyneyrD/ESZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GiPct5I3RIyKVnUeY4SIiCrdnUqsOgS6mDU9YSBJjHDd0gYwXI7rEld8XueXGIXhn
	 4VMIsiVV2x0xXRM+qlbp8J3K6njuhdYcF9IEpNRbQR5MAI0ZlYW3O878Rhrv1Kyr/Y
	 HK0dpDUzeYEvaGeOszozJUh7pm2LkN07u38CNlv7c+x+aKcYrCbxPF9bQ4mzd4g/Sj
	 Pq4YX7HRGJU+s0ogTWQtOaYeav00GrrtEnqGs1OmV1Shn2PnIK5mzFdBaih/eHYD+n
	 3ATVI0Kp776yWfk86RVYhy8Ar47qbqvpSE3ShiaDY+VAUwFW4LiNMzIG3znk70SwDP
	 Xn7irCtUvdfKg==
Date: Tue, 26 May 2026 11:01:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Calum Mackay <calum.mackay@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-mm@kvack.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, 
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH 1/3] tmpfs: simplify constructing "security.foo" xattr
 names
Message-ID: <20260526-ablief-demut-wehen-aef8446ef5c9@brauner>
References: <177945382308.2991556.1256192774754909984.b4-ty@b4>
 <5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dyu27gpxlrmawx5e"
Content-Disposition: inline
In-Reply-To: <5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: rs9rcwu9gj9w3fpnqwn4reixjw6u5cx4
X-Rspamd-Queue-Id: 9E21FC000F
X-Rspam-User: 
X-HE-Tag: 1779786065-279280
X-HE-Meta: U2FsdGVkX18vPkOn6f5wSA6rBa/1WYGrIUH+PvLkpV1D2MQi0xd1ObVb0BF2m2xxSZSHaNXbj+X7+kDafyli58X0txRj07Lb8jZXByeuzNK1G2v9q/Lojs/gBPJ0AkKqlv874zT3ZpS5KX81JJBOWZzVexqvPL/qPAghwL7Fcma/U7ronWvcE65tFveK0qdiACOalKXuKj3rx1Zy8Iqath6hJGrzCiHmQiztZRxOf0Abow9qaQL9K0RgansiI5z72a9j/FFWx0qE56WKL/CRVQ14znWRrZv30bNlO0FCZr7JQfvXMGpBjIIrEvEhw/yZC3tcs67LR/rQAZ4lUSBk6ck5X3bHS3Q8hALsZ5zpTqTQGxet4l6KdlZna/tAurUqybMldLnKMyynp07nquDprXKpk7BFozxFua3WVCJZzUtPGHGBb0CnDo9SsQWOV5xWtstugz3zOH41HcTHmbvXMdVbLaXPlHsEefSrVCYTjmonoAXvJAt/5hyeAVR8fDLUYAEvTCrpoaavycJkOOwtCkWOCVWIPYKgVIneA50qVr071z6NJClETX4hVtwWo2KwwIKeT2LCOH/QaV9SEnH+qVar6V3EIZgRjI20JaDvVeTPD+mFTddRsnVTXP6wCvmEzWBZ56/d0qLRWv4aBxN8o+hIDsRa9saX4tODpXyt34rrKlKmGIYUJn6TChtqXGDn24RfxxmTf4AJdNpS3s1T2/U4yUwCKTefEhtyvEXc0azk5Le+Auz36EFf4EM1ERzznPfntowRV9kqE5JQjqSo1HDVnXf8XBQuTJJVeDHQoo77Sa2/WkF2RPTEZI+8kG7HU/b22KKmUuUZ88X3jaoiQzicZPPzlP+e1zevsgkUTwfx2MpxMIaCn8SzoPXN77q0wHHy0p51GjgXZIxQkxmB+gQpbvn8HG6N18hixtgfcFyqJdc5iOvm/wRi+t8PlKrWF0SlsIYEC31ObKQAa1c
 7GxwPUkw
 lOq/nI+JhCHrZBXSjgclgguRn2xyg7PswCf6q9JYmaVeT2WbQHWhqUBQPLzSfNgWPDDPELsPnf4e/yCf2tBg+9q0j8XFFGXEX4ikLAexmXB31rBaiH1H/SfoA48wv5wjHZ4l5W5Sny40mnOeaeFDcN9PQm33Vd4h5xqC0s6vDQYQEU+QJhlE8k9Z/7moVUsfR5IYXn0J6ggxf6YQAh6EplKFi4uxkMQL1NUYxUPm0BSfsCFYuhDf7uaX4za8LvYperzAmWJsYR6IMLWZppK4NW1C9SqdDC/n5Ab2mt0RhNBvlSBD2ee9ccBJmhziTYfvgcZ3PtPt5KhwJOw7yzG3HC3wN7t3hLWh2ZyHtXDgo2F9+E5QEObbzvPv+Tbb+QxjD6q+IonkURbC2QhfRp6cZIRjduYL4DhTGAg3NO6LKJrLt2IqRLAJg0irt+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--dyu27gpxlrmawx5e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, May 25, 2026 at 04:59:02AM +0100, Calum Mackay wrote:
> hi Christian, Miklos,
> 
> https://lore.kernel.org/all/177945382308.2991556.1256192774754909984.b4-ty@b4/
> 
> > Date: Fri, 22 May 2026 14:43:43 +0200> On Tue, 19 May 2026 10:13:21 +0200, Miklos Szeredi wrote:
> > > tmpfs: simplify constructing "security.foo" xattr names
> > 
> > Thanks, this looks great!
> > 
> > ---
> > 
> > Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.2.misc branch should appear in linux-next soon.
> > 
> > Please report any outstanding bugs that were missed during review in a
> > new review to the original patch series allowing us to drop it.
> > 
> > It's encouraged to provide Acked-bys and Reviewed-bys even though the
> > patch has now been applied. If possible patch trailers will be updated.
> > 
> > Note that commit hashes shown below are subject to change due to rebase,
> > trailer updates or similar. If in doubt, please check the listed branch.
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > branch: vfs-7.2.misc
> > 
> > [1/3] tmpfs: simplify constructing "security.foo" xattr names
> >       https://git.kernel.org/vfs/vfs/c/aba5853b137b
> > [2/3] simple_xattr: change interface to pass struct simple_xattrs **
> >       https://git.kernel.org/vfs/vfs/c/1cd9d2387c05
> > [3/3] simpe_xattr: use per-sb cache
> >       https://git.kernel.org/vfs/vfs/c/12e9e3cd03b5
> 
> 
> I have been doing some testing of Chuck's nfsd-testing tree, which includes
> some vfs changes.
> 
> The test systems are reliably crashing, in what looks like it might possibly
> be something related to these three patches.

The appended patch should fix it.

--dyu27gpxlrmawx5e
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-kernfs-link-kn-to-its-parent-before-the-LSM-init-hoo.patch"

From 6358bc199a5be450bd11dd7607918dcad4030b86 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 26 May 2026 10:57:06 +0200
Subject: [PATCH] kernfs: link kn to its parent before the LSM init hook

After commit 12e9e3cd03b5 ("simpe_xattr: use per-sb cache"),
kernfs_xattr_set() and kernfs_xattr_get() compute the cache via
kernfs_root(kn) before any other check.  kernfs_root(kn) walks
kn->__parent first and falls back to kn->dir.root, both of which are
NULL on a freshly kmem_cache_zalloc()'d kn. kn->__parent was being set
in kernfs_new_node() after __kernfs_new_node() returned, and kn->dir.root
is set even later by kernfs_create_dir_ns() / kernfs_create_empty_dir().

The LSM kernfs_init_security hook is invoked from inside
__kernfs_new_node(), before either field has been initialized.
selinux_kernfs_init_security() ends with kernfs_xattr_set(kn,
XATTR_NAME_SELINUX, ...).  kernfs_root(kn) then returns NULL, and
&((struct kernfs_root *)NULL)->xa_cache evaluates to
offsetof(struct kernfs_root, xa_cache) which faults:

  BUG: kernel NULL pointer dereference, address: 00000000000000e0
  RIP: 0010:simple_xattr_set+0x27/0x8b0
  Call Trace:
   kernfs_xattr_set+0x63/0xb0
   selinux_kernfs_init_security+0x13b/0x270
   security_kernfs_init_security+0x36/0xc0
   __kernfs_new_node+0x182/0x290
   kernfs_new_node+0x80/0xc0
   kernfs_create_dir_ns+0x2b/0xa0
   cgroup_create+0x116/0x380
   cgroup_mkdir+0x7c/0x1a0

Reproduces deterministically at PID 1 (systemd) on an SELinux-enabled
distro. The first cgroup mkdir under /sys/fs/cgroup with a labelled
parent panics the kernel.

The LSM hook's contract is that the kn_dir argument is the parent of
the new kn, so kn->__parent should already point at kn_dir when the
hook runs.  Move kernfs_get(parent) and rcu_assign_pointer of
kn->__parent from kernfs_new_node() into __kernfs_new_node() right
before the security hook, and unwind the parent reference on the
err_out4 path.  kernfs_root(kn) then takes its parent branch during
the hook and returns parent->dir.root, which is the correct root.

This also closes the same-shape latent bug in kernfs_xattr_get() (which
today is hidden only by kernfs_iattrs_noalloc() returning NULL on a
fresh kn).

Fixes: 12e9e3cd03b5 ("simpe_xattr: use per-sb cache")
Reported-by: Calum Mackay <calum.mackay@oracle.com>
Closes: https://lore.kernel.org/all/5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com/
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/kernfs/dir.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 8ba2f2f3da9e..6d47b8469642 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -698,6 +698,9 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	}
 
 	if (parent) {
+		kernfs_get(parent);
+		rcu_assign_pointer(kn->__parent, parent);
+
 		ret = security_kernfs_init_security(parent, kn);
 		if (ret)
 			goto err_out4;
@@ -706,6 +709,8 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	return kn;
 
  err_out4:
+	RCU_INIT_POINTER(kn->__parent, NULL);
+	kernfs_put(parent);
 	if (kn->iattr) {
 		simple_xattrs_free(&root->xa_cache, &kn->iattr->xattrs, NULL);
 		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
@@ -742,10 +747,6 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 
 	kn = __kernfs_new_node(kernfs_root(parent), parent,
 			       name, mode, uid, gid, flags);
-	if (kn) {
-		kernfs_get(parent);
-		rcu_assign_pointer(kn->__parent, parent);
-	}
 	return kn;
 }
 
-- 
2.47.3


--dyu27gpxlrmawx5e--

