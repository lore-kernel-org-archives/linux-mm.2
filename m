Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F7BCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475568E0014; Fri,  5 Sep 2025 09:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425768E0003; Fri,  5 Sep 2025 09:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314A68E0014; Fri,  5 Sep 2025 09:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 210708E0003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:56:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF8E2118BD1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:56:54 +0000 (UTC)
X-FDA: 83855347548.11.F86AFCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 091FF1C0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:56:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDh3QCZs;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757080613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq1VwmYPIFqwq1cstMX0CZx8nozQQ5V0/967/UbxTaU=;
	b=jXR3gT8/ShVI4PVlc2gIlSSjFcQG00ZKwFLNbq6IX93zbvbzUz+Rt9e9163I9NLktjg0Ku
	3FbJf+IebLGShNDPf8LexbFx0lzZxuFL6hGAhZmgn5JINVcCJR+dU/BkKWN9NRVI8nVEnr
	n7gMM1kr2XFn3shW3MRzSZ+CVIHyBuA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hDh3QCZs;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757080613; a=rsa-sha256;
	cv=none;
	b=OQ64KwHT4wLQjR4k9+87kZwKAmyU29EnmWxzzY7UvpBynytD+ii2R/K2t98DCBVOlRTS/K
	FKrT/49Gz5mCuH4yh4GRrqext5RmMve6ZF7jw/TCacs4Syg4Bmcoj6TLR3idMlVJL4i8fP
	gAMAXr8I1f5TRzixgtmAOvgozwzddnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60ACF60280;
	Fri,  5 Sep 2025 13:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CD5C4CEF1;
	Fri,  5 Sep 2025 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757080612;
	bh=1hGzZmdSJuzP6spOIHTVvRRo8NvllbiyNgNqPn97QRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDh3QCZsHal0nfKVKiKhtfcfsqwRmVQVOYhj+FFcwmyIIXx8vo4av1o20+NpQ6S5D
	 0IJiWYqaGqwgT9w5qluI13urzk17W3xfoqse3h1Yxafcd6Kh9r4K/oYz6FiVG8zQ8p
	 gCxAyG5otPef4WWbi95PY3Enc6ZTE+D4D0COGQNF6jTOSECS5P/nUbVpKoydV1/RjM
	 irEjFYHWw0GI+yOejyTiHxwOgkQr1JNRKqGZfriwOMIvm0s9RMdYq3PXSBbQemKkSH
	 P8NnUtlyV6Z69age1VkFMIujuaDqEMGuYa79i6460y+dKoc6OeiVgVs8dzQTD7pzoV
	 SYCkBkdyUU/FQ==
From: Christian Brauner <brauner@kernel.org>
To: Haiyue Wang <haiyuewa@163.com>
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fuse: virtio_fs: fix page fault for DAX page address
Date: Fri,  5 Sep 2025 15:56:40 +0200
Message-ID: <20250905-einsicht-berglandschaft-8d4c6a189aa1@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904120339.972-1-haiyuewa@163.com>
References: <20250904120339.972-1-haiyuewa@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1266; i=brauner@kernel.org; h=from:subject:message-id; bh=1hGzZmdSJuzP6spOIHTVvRRo8NvllbiyNgNqPn97QRA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTseiOnflv19CROG+fp5+tSaqyOm4bWPmmcZqKT9frB9 ftGLpW/OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbykIHhv9vPR7cv2HZzfUir 2+J//smsrxuFvwso53J1WJbxi+894svwVzbcZNZBgY2lNUX/dmj07njYWqIvocRwlWFjQ+TK3D2 Z3AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 091FF1C0005
X-Stat-Signature: fs3cmmt87sr6s7j3b3qr55fabtfrou44
X-Rspam-User: 
X-HE-Tag: 1757080612-112815
X-HE-Meta: U2FsdGVkX18wX49DDVAdfq/M7j0zAUnR/OK4guRI75RSzAuQtZ9N8pF/oLUlZ+G7nBZ6CsgOcvmyyFWSPQHvNKdB7pnxi+2YpLtZmDKjjoa5lR7fz/8U5Qnd+3qIR1o7G1249Xo0n6+q2AcMLOXnML57T73t7WvoWRn4M8xrV/xun/kWdSfC3oTSgJtFTvUY5tMUHDSA/MRgW+7EiklwhJBV2NwfNorG40Rv6Q/JPa7HXtWLVTRqEOozzQ//2k6cSoQdwRq8D6bpJNb/UR1hm3KFUp2nejkbDnSj95Ng7wYrtlt8PHgzh0Us2ucugdcXcbYryP9TVZOoaN7aNkNG2aep3oA/MNOveDs2520VMu3XB+JUouiNPRjEJp9wr/R85r9/GS1zkattuok8bMLJ9173nga3rN4rUOVCxWXM7jEzZ/ipqG/OqwA51Fi0Pv53zcuar9XXOWj4vCvjL700gUxfFtkNszRrvdaCzBPrek2bHLqw1lbUQAwr9s8yGC6Bo7hF+jNnAQWkZ+WP7+dOpQ/k81k1PGBJmSGDhyL6G1m0CW6v477978mdxxAJjjogtiCwsxSZVjHzBojOjRmJYZvTK3apovumBDbGVn3cIzzYiR952HkSLCxWmoCX/4MYRtVovAawHHL7a3ZE9rn71bSsvK/2skB8ME/r4SBO3ciN60qoSh0iSTjMIF562appEI/SFLqpxhp3u0UnhQNXtIfH0nJFqFaxLh5xIZJku+RwgRlui9eLaGySRkgT9BIcRpXmekux7lFRnFxhVxKv+9KuY93g6KDr+0mtK+E2yDy51w2ilavAUs7ShyQUBjissZuQ2aRYdq3S30c+5+2rJ3sjj5maci3lTaECrjekOSbLXIOltSVXfAgYgbubz/Gh/4tXKrvVsCXR82YHnCUmzqOO+6t1OAFaU5w/+5t/lAotnkaya4fpbfwVxTq8/rKqs1pMkoe6S+VfbXw/Sxu
 Y5lHOGhT
 qCTaKie+w0NT6RURQVyD/nTPYHIrs/JmwrwnN/LkMoUbzTJJ2Efh+Ox8U3ytoSWw/HJ9rZdR9uuCFVn0+Ioi26069vyDwxuDtHrXbtDHxOfbxagtvu0jvyF4zNraOpCUr9apQwiT7j1jzgzqDPM7J1NOY7HHY43asoMw81pCleA6BUFyxAorw8e4lUghASY1L/Kox/4KE1xIq1luGZGNrFbg87ttW9auPdOLErBHSdfm/q61FJJpW9I1lBbcZM4VWgMBWe7DCAI9LCB4Tz1Jcm9Ds1ieiYwGBj/wgMH9XeKmec2CAKCjQWcjPJOtbfFVcjWlTM7svqpQaMuL90Y6KhpIlMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 04 Sep 2025 20:01:19 +0800, Haiyue Wang wrote:
> The commit ced17ee32a99 ("Revert "virtio: reject shm region if length is zero"")
> exposes the following DAX page fault bug (this fix the failure that getting shm
> region alway returns false because of zero length):
> 
> The commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality") handles
> the DAX physical page address incorrectly: the removed macro 'phys_to_pfn_t()'
> should be replaced with 'PHYS_PFN()'.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fuse: virtio_fs: fix page fault for DAX page address
      https://git.kernel.org/vfs/vfs/c/e1bf212d0604

