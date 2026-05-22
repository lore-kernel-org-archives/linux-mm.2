Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8D5CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997046B0095; Fri, 22 May 2026 08:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E456B0096; Fri, 22 May 2026 08:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABA96B0098; Fri, 22 May 2026 08:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB406B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:44:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19731C2662
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:44:13 +0000 (UTC)
X-FDA: 84795023586.15.C28D10A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5EFFC80005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:44:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVvolVah;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779453851; a=rsa-sha256;
	cv=none;
	b=ojJuEA0xeJxwPnOJftxTzgjRmfB+zAWVQBvVyeHp0JUbgPhyh0Sr7cWwO8WfFnGm4GD86T
	68ramu9LChbZ9fLrlFCayilN5ZljFm9pqU7+tMwjo9tRSCNk2imEPopwuC7XOnSEOzY0LM
	0t8sVRSH329ZprH/gt1WpbE86/JKfgk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVvolVah;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779453851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0Qd4kCzcdahkGKiDbTYgBLTZeAVdJQBjmYLYQ/bOBo=;
	b=z1oHZvIFR2J6wtEwf0JZq9OU/eDqY7hMLMNzNEHA3LScoq7VXHt4BWdYVtG6VJFO51GrMq
	j5n5qNOTZ6XR8RpzCI9D+p0IuPcfU+BWAkA4nJqurZQppAKOJmomCSjqYyKCxdfvYddZCS
	fq9Y8KFWna9irD2Pni6E5I3ZHegUi7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C19A860138;
	Fri, 22 May 2026 12:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AE01F00A3E;
	Fri, 22 May 2026 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779453850;
	bh=W0Qd4kCzcdahkGKiDbTYgBLTZeAVdJQBjmYLYQ/bOBo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HVvolVahl0LCA3BgpBk9uL4ztcewbhvBM8P4AIz/tjfB5p/1lNdN7Gyg8es077TAo
	 Jio0B/oSOEJybGoQJZcwgfBwzbDX1oOM+2vSWAolBWcTdhI6dI686hWzQQQOeiF1st
	 5lH650AqIpbXkXdZL/zPnM6yY71AB/NJ4XbzRkBGaGbSF6rUUNYsxsHcu/eLmnaRNp
	 6cMu3fh4w7gq68AFfHM+TKLrcaJpI+Ii6VXUdoaWjdCvA1gpKwCB3UbX8nv7jCSbxy
	 qFE2xp5bMkm20AEKu6LyXFbhoXFp1FMrHrgTQZLej/Pa0N7EG135PUnjocVvvmlAsj
	 NGS2yLmZQF3uA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20260519081324.979769-1-mszeredi@redhat.com>
References: <20260519081324.979769-1-mszeredi@redhat.com>
Subject: Re: [PATCH 1/3] tmpfs: simplify constructing "security.foo" xattr
 names
Message-Id: <177945382308.2991556.1256192774754909984.b4-ty@b4>
Date: Fri, 22 May 2026 14:43:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1146; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OkWiNpV0PrDScl0wgw6JJtVvWGS2GjuALDAAMIEVDlA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJ+M8o3CQW0dEc+EEkRZStP5f5sfV6i0ivh6aa9+3dm
 3+xSoR3lLIwiHExyIopsji0m4TLLeep2GyUqQEzh5UJZAgDF6cATOT4Job/Tn3rJrBG7193but2
 WZ9Pj4Scf39TE2IWO/ufSe6ThZn8ekaGw56aWvzZwV0CVs7/XQP2XrAvNGH0k9jKkR6wMWx3VDQ
 zAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EFFC80005
X-Rspamd-Server: rspam03
X-Stat-Signature: x5kd79uqz6m8frekxzd7fej4xmxdpuso
X-HE-Tag: 1779453851-6694
X-HE-Meta: U2FsdGVkX1+T7Hv3P6aafNqDkH60pePpX48LSCOhg6hr58AYLzf9P56GA5KnR0bf3qopkDS61hC2NDYDz5BYKLyTj4yqrucKvzNNvei6i2iw2jzWWsljEsC20R1JxTOfPU/KvsnrhWxlcdfk5qGckpPPcm9VbTDN+wfrDqLdvzhVToONTeat/UXUq77vNsU6q54Z85/hUmZ+aKbYimqfeGZR/NGXoRYkPGJ9ImPsH1KPAwio+ranQPnDzp1Wro0y1lxe1IB5qmGshNCZAKGTpfLvJLpBpsmRFDISE2Y2vx6B5kzmNr0eN2suhWnAuZ/OFHYNahWT7nJzCa9E0lWfFt7IimbQbc/lwpdspr3bizOLfPvNP9K4LJeupQUGa9Jyh0E+/bvuZJ87QEFWzJnqRPudbIm6CqK3JOSJVoOhiqjwSBkbOF+O2yN54W2wUyC+CEi1zuBK45gihQaTlXWkRd2Gba/C8boBC7G+Uy9+pCDhAztTapIn8Gj1t4nfQcLMX9VDT0eDTUSQF13ZjlM17USuXTdz5Wdz0te8UpDRrzrtqQcpMXMAt0GjDA8TclUiCXNE6ge1VdAbuYc9fcQbtlO4I4hkHytm+sTEQOOXRwHZ8FbOspkuoXK2ZCVQXXYdEds5EmSWfbBdtJoMHl2A/PgFW5ipqpgrM31bDd5G1s0t16SjvQ//pt9dPaSMmfbdStMZV7aUQ9na11oM+sMJ7JhcwNZLrGmD9maBmskSPdkpML+dd9TQnpzAXazXB89yEjpoA1JWaMSN3xMWDKJKs5DpeyokFYULUmJqMmfhDUfG39lrGwI4zzXCUWKu34ax3QJEcc2WLssuz9PdFFK1pf58xMKy+MDEYfie1tc5TaYhwGHT/Tqpbq0E13gVmqEngx93uwxpU0S5WegAR60GJTKwNCtErByu0yTWBBqAjNVbezNeOhQOIFKdNM8JtCOLV24c/yk8Thfz50UXB8+
 C4QE1l/1
 3d5l60ckwcKmmwVmm9MinAXK1YOQMgh4GnGpkEK3XroNu0ZmB+xBdbOdbj8gtclDKbNrPyCGA3EJjWGjuX6rp3MhI1JYAnpCzvjAqKxqeSc042QibPAgytwW5tfGpwVsxGMc4OuoImy0FrhM18PLygaBd2NPXrP1cMouOEuzyyyi5vcGTWDuKaxI7ShYfRThdMr8hSUV4jJhqacfyHtr0YK7Yd2XoxSk+rgT4gj1JEbzVWfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 10:13:21 +0200, Miklos Szeredi wrote:
> tmpfs: simplify constructing "security.foo" xattr names

Thanks, this looks great!

---

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/3] tmpfs: simplify constructing "security.foo" xattr names
      https://git.kernel.org/vfs/vfs/c/aba5853b137b
[2/3] simple_xattr: change interface to pass struct simple_xattrs **
      https://git.kernel.org/vfs/vfs/c/1cd9d2387c05
[3/3] simpe_xattr: use per-sb cache
      https://git.kernel.org/vfs/vfs/c/12e9e3cd03b5


