Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5BB109C05D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3E76B0088; Wed, 25 Mar 2026 16:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554906B0089; Wed, 25 Mar 2026 16:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A606B008A; Wed, 25 Mar 2026 16:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 323716B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:20:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE8DC5AA09
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:20:10 +0000 (UTC)
X-FDA: 84585702180.13.33D5C08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D71B0A0010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:20:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GU+v1K7X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774470009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ud/a4VrTwynXK/05Gf0eaEr7OxpOMbbBVL2hTtoZTbc=;
	b=I1Hv0lWXHZVLtoIIYy+iOaY+82yaynzLaRTKaG5nYINL6HJocyWZ3vfAypt70SbPmYaDe5
	+wihTExK/YZiygxz+zkstWsjkMMImI55kLUVc+n7nfN7NlQXqm966xdhcALY7Es/PhTAGQ
	5csh3V0xiJbzLob2H3WRGkdEOeV7OQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774470009; a=rsa-sha256;
	cv=none;
	b=I1nbyH+C9gg5mjrkWRm6pj1Awu3Y3YHizvvgF99TqybJFSPeGPrYUeBUvvMGf3D6BAiTe1
	vwkwWnT4yotLVJvRncY83csnncH/JUBRlOXWEPOqzn6VuuFRr78ocBb9gyW5W/vU6A7d6a
	hFoq8qy5I1q5NjsSfPesvCnjoa1r/aY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GU+v1K7X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB37B4442C;
	Wed, 25 Mar 2026 20:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FD9C4CEF7;
	Wed, 25 Mar 2026 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774470007;
	bh=m2Fl41u9xLJTkmSNH5fjQam5qUXk4fYiC6RqiBkltaI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GU+v1K7XSxXX4E0yHH4tMzTYTOXjlrFI9KahS6lpnxCCUeiTcf8ArJuVLOxCdyXvU
	 C0cEb4VlNmH8ejylJDPRcNn1sXYQwDEwZ1J99U0jrmVzN79RUGBmalzZl9Q46R6mwR
	 IikMJprq4RaB7nTU5tFXRZIjTPC6wqEe9YIZSkjgLxxMsYY/fiKhAhT815DSCEBHs7
	 jTmPHaKWKbddIS8Py883wleUllgGi44zHsC7Q3/g2Me9bH9vGqtCM9r0oC+uLTE0DD
	 Rpa97eC+VEs4r+K8weLuQiKcb8nNglKntRrDUeFeL4s2SCO21lPuj4JG2Wgv7Jf/oP
	 ZvqhaVC6dCfqg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
In-Reply-To: <20260325182026.467307-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 25 Mar 2026 18:20:25 +0000")
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
	<20260325182026.467307-2-pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 20:20:03 +0000
Message-ID: <2vxzikajacgc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D71B0A0010
X-Stat-Signature: bhup3qfy1hnimddu1bipozgt7d8bxdqe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774470008-703948
X-HE-Meta: U2FsdGVkX1/jRyezVnOf64ngYb9t0q4neQlpJlNWO7zjSeZ2Yd3D9kMtYfPcvl2+ZGRrCoriUSez8yp7I/Q3JvqsNi9NhjdQqE6oSoIQetMYtGwgqac8a5g3Ypo13FXUsBCsaJ3tBfoE/O+L9FrxpsS3skmHqn3XyDg9oz+Zx1Ey/4fi/cO6eYwb6txJpr4ZNFRqy6fmKiHsdNS60gE5qJylppe9SztoLESjhXeFipYKdfnSQKRWUWP67oofFF3dbN9KZgBMD+bW8OIWmh7UMmA1gEv9wTofecvnv+tm06HVTWSISNcjtnHuSsG9Bl1/0tyT9OQ/WvjNkcZvh6YR5qaezLeY+UViVtp4T+HN6u34o24KmYRnTQVMtPZsxPjFayAduUBIIFCcHksuW5pisM1EUyQrr8raydi25JCDgIwdesLW3fDUkRy8yUGEj96gnaWb4N2qn4kVqkr5kF/Onpzwe2I3AknhAfRYkSYexsmKc4AGDh1yHOUVS7SAdCaTZr+40nLEb9A+ComHfXj/bizJQ8oanfvMFLKpnTLqllP9huL2ynuN+uWsL/llXeJ6G5jbwg8uIA0vkIXL6qUkMYUJAQnbgyWnQXsOcEyonDHr5HplYJhJMnzygzMFX/UjJO+1h9pnzPJnYMIbbTxvZ4VAZNApiZQO3DhBdPzmW7tHuOcKEtFzOWxKgPJU6yuP8FRpnEk4ZQiynszX4klj9J0z6LG2hCOkFYHyiqgxkBIts/krYJIAootbICo4FSVVbIoqc1bz5bzT6jiwataFPuK7A6XmXPBxa0CYqLtPawMUIoif0/KChbMD1m5auKOH1U0OqZ2Ll0S4sMbZTE/+A3tnson/nx71MOSAhyG/I71bjC6J58HDpbweK0Uym7FarLlFVq9P2G7xTSn2NjPmt1IFb4zXy6ZCpM2haHv0uMu6aAmcT0ZVSPL+CnKV8pQoVd2Y88MtwEW42Ou2/rS
 8O5Vpj+0
 hVUpvCh/01p9EpqKMQ2mR9zpl3JlH2U2WwfEm6/NwiXdpjOajUyvJp7s18TUtb6IsYYmpaLc0Qms+vilWVNbQE7tbZYiwlMZgeMZR39+uk2qj3xBHnjr1AWKa/e2jRB1GCglGRqz5ZNTIQ7zHjzddc93dZgvsr9N2Ov1rp7gKGKFMvndZNIvgFxRLs4UJxSVVVxhKq8gFPwua8kvSEy35xrWcm4Ph5V4JqzhDB2jGs+JYLgAEs7APfgi+kHrILiIzLmWS0NFYS6ifRaGTH97+pLuvjFpHJtipwDSPeaDcHeE+vy/KxpcN2VdTEuZIcgyHu+erhQp2HADXcooN0pXHniR0kM8aZ/I3mUYadwpyLdcFAIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Wed, Mar 25 2026, Pasha Tatashin wrote:

> Currently, LUO does not prevent the same file from being managed twice
> across different active sessions.
>
> Use a global xarray luo_preserved_files to keep track of file
> pointers being preserved by LUO. Update luo_preserve_file() to check and
> insert the file pointer into this xarray when it is preserved, and
> erase it in luo_file_unpreserve_files() when it is released.
>
> This ensures that the same file (struct file) cannot be managed by
> multiple sessions. If another session attempts to preserve an already
> managed file, it will now fail with -EBUSY.
>
> Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

For memfd and hugetlb at least, we serialize the _inode_ not the file.
The inode has the contents that we care to preserve.

So if two FDs point to the same inode, this will break. You can do this
by first creating a memfd and then by opening "/proc/self/fd/<fd>". Then
you would be able to trigger the preservation twice, causing all sorts
of problems. Same on the retrieve side.

So I think you should be storing the inode here.

Except... IOMMUFD and VFIO seem to be using different things for the
state that needs to be preserved. I don't know either of the subsystems
that well but from a quick look, I see that
iommufd_liveupdate_preserve() [0] calls iommufd_ctx_from_file() (which
stores the ictx in file->private_data) and does most of the preservation
operations on the ictx.

Similarly, vfio_pci_liveupdate_preserve() [1] calls
vfio_device_from_file(), which also uses file->private_data.

So, there seems to be no single way to get the "target object" that can
tell us whether it is already serialized or not. For memfd and hugetlb
it is the inode, for IOMMUFD it is the iommufd_ctx and for VFIO it is
the vfio_device.

So unless I am missing something, I don't think this approach will work.
As much as I hate to suggest it, I think we need to move this check to
each caller so they can find out the object they need to serialize and
check if it already is.

[0] https://github.com/samikhawaja/linux/blob/iommu/phase1-v1/drivers/iommu/iommufd/liveupdate.c#L210
[1] https://github.com/dmatlack/linux/blob/liveupdate/vfio/cdev/v3/drivers/vfio/pci/vfio_pci_liveupdate.c#L145

[...]

-- 
Regards,
Pratyush Yadav

