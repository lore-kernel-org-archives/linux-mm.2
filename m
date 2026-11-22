Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B520606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yxs9eT9X
Received: by kanga.kvack.org (Postfix)
	id 294A36B05B5; Sun, 22 Nov 2026 11:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D3C6B05B6; Sun, 22 Nov 2026 11:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA296B05B7; Sun, 22 Nov 2026 11:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE50A6B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:03:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77711140717
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:03:04 +0000 (UTC)
X-FDA: 85463223888.17.AA9EB6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2F70180012
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:03:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yxs9eT9X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363382;
	b=bk/Q4kK4EgJ3ziP5+hdcXCKD7VqDNpDFeJmTo0vJlXC3m0LFjeWvxWfg+URNB9X8gMK1xb
	2XHUSzCqOL7RnicooqOwvr1qQcrsFycx3jObAwb8eAdQmxmqRClX3StgPIvAF5luyst85D
	uGiteg6k5zcXgzOoSPSTx+QDb6KuQg4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWrFVk6jgK3PVLqBM+zS8clEjvR/O2D2al0UZuWHR8k=;
	b=QDqBhoiQVJLGm3yRgit1BzHjngS8e7PJXxOKRk7sOtzoV3S1dm+uC1kGn/XNTuGRqyOQIY
	oIypJ77Xf5JPVgJVfqDjcV6FYoQ3TOD3G3rBNkqH5KsuBK/YnItRvKeZ2s6xlhPEZwSc+V
	2xwRX8fePVuOx5MdQRkfHOKNVilgVSY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yxs9eT9X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B8A16020C;
	Sun, 22 Nov 2026 16:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF4D1F000CA;
	Sun, 22 Nov 2026 16:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363382;
	bh=pWrFVk6jgK3PVLqBM+zS8clEjvR/O2D2al0UZuWHR8k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Yxs9eT9XTC+S/5am2omSG12K+MahuUn2IgzI1Wv2tYqr9H8Tzg1YoK5asUHr4rc2c
	 G6DogWsTg/YRXrVb9WspE52ukHQVmGgjYKS4zc/AWGpu6MdNWxLC/vH8k6KOYtLdkV
	 hGfleRdqUJ/6yLce1Ac9kaFrX+AGZsyEGAVEVwwzu+nQAZqsaJQqVxLM5FHXtSIjN4
	 B6gIaVLhNtctOiEgek95gzk43jUMOZgMWRYiVuQ4r0XHbJSbY6oaX70oTc6Ia87kCh
	 VVC31cxiOcPU3R31J4BVuT+ky6N1meB9/QSmawXajdjK59GB7GIYS22Fabl69Q1hPz
	 iiYV/axftZjVw==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
 Arnd Bergmann <arnd@kernel.org>
Cc: larips <larips950@gmail.com>, stable@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261120185248.823415-1-arnd@kernel.org>
References: <20261120185248.823415-1-arnd@kernel.org>
Subject: Re: [PATCH 1/2] [v3] mm/mempolicy: fix copy_nodes_to_user() for
 odd inputs
Message-Id: <179536337870.3554.2407408081823588964.b4-ty@b4>
Date: Sun, 22 Nov 2026 17:02:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 7h96yfmzqqhxpfu86aqu1bd3186hey33
X-Rspam-User:
X-Rspamd-Queue-Id: C2F70180012
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795363382-939053
X-HE-Meta: U2FsdGVkX19wwpRPcFG7GYMufXoZzpPzewi30y8phR34ebMbZxRqy67+LzxpSWSokCiG3HRf6pl5IZLLyEpdWEgjNUkgqmgWDQljajy58g7DnsDREwZJ+G4Oiz6O/Gz51moBTHeqHWru9gdJqoQrD9cJ5Jtj5AY7Np9Wos0L+tqd7I2mmIU4x13nkbDcHkmYknuGaCebzBIPW0v6kDkcb/UVRxOToPDgSe+AQRgjXHwwg9QKwwDo1Jcby8TXEn6Ud2MjloXZMWovWSnwtuxzrCgsDlfQoTD7C7CDi7HT0wjJ8Lej6sV4oURGEdVE6vifGw4lw6lFsQJzv5zg7rFnClR5EgFMsdMHKGv2Rr5pMo79vuExuIIr/hlo0YghfGISPWM2PwyMQuJ/QPvpy1Cjv4xA8ddtbT7Ri/Vs/qeo+IYOoi8J6CbM2O9qg5RGxj//i2DyPx2ex3S7fG21qckw7c/c+/0Q78voiqkL0f11SMMqH7RvmzWKjf1sZViHCV9TELKtf8HkJVLLgi98LUaLfd91r16PCoFNIgLcv/dEtulson0W9NNIcFJPZmVRHca0ae+nOXKv90QNk9BdL4X/t72fuE9golgldIjFAjEpd2b8jcg6LEEggvf5Bm7EWG38uikTba6UPcctEXNsvLl3hwFHIJbNV/K+1dBpgoUs3W+AEzb06mvvRRnyyAMnZAOXBMiuQF39tYExo9inWrBM9tmbvg70eaqnBCb0v+ErXLJ4kRXHxFVJAzAIORowTjg/tSfWM+/z+CVR+sdqlYbe98oeXEBMX6Z4NOJ+4uIJNZ1stouG54faiGK/eQc5Mszp9RBhu+qm8vvcw0dG/1cfJMNjq+JTdxM0rKcPwbxc38bsPdkcmPyJNiS6X0D/eDXVsE088mY+PdQ4b1sW060CsjYnpjN/1bSzjKWandu7yC1Du9MmmWOSMT1FDwlyyTQg9pXe0qfIzwZe/lrMNXp
 kjOJetOF
 oxs4LVH7YMazEa7oyJHGlK5o+C2hAleAgXlaYNxdInuoVQIHN5Oaj7BzC5dfbawkCJVWm33m+ZEfFrJ/U6gx8y+H06vEudk8pZAb9gxCKYZ2tqZph5sP1LE/ZwW0tlSTeOA8okeJNb+EGrxXLn1+damYjaGzjWQqvxT430gi0Lte/Riw/BV/C6R/ECz207/umaAi8GHQV3VVgwfYIQKMt9VrL9d/yhfBI5k2oSRzzbf0g8sVYlTbJmZNljGzuZXZrvsuBnkm/roo6tiR7cRtmgIM6XenKQKFOq9CRtc5kS23DVhJKQcA3xFsjmnDs4f2CXfifX+swqP31EY7DC38mrINrf9cFrp6j19HWldnliIxH+cK8UHRdUR/OxwFWEYnC578lGZtYk0+duBi2hkRO99IPlDCJX1M+TniZwJjRjIysK/p3bLg/p4IN8B4l/f229OkTdF01kTFqqiZXL5SJmiZvRuuOsCnEoNcLV07K4Zlxhgyl/nTJ1I6yB9sVqD9UCHp/MgyYrHMsG8zVecK2lMgGEV7ng4Gpk6eKofh5RB/92zVUKSMB2g9gf4Mgy7v/1FfbPgrgXJrOtWWrkQ0/G9/25A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 19:52:12 +0100, Arnd Bergmann wrote:
> copy_nodes_to_user() is broken for compat userspace in three
> distinct ways:
> 
>  - Passing a power-of-two size plus 1 as most normal userspace
>    does can end up calling compat_put_bitmap() with the wrong
>    size, copying an extra 32-bit word from the stack into
>    userspace and overflowing both arrays as compat_put_bitmap()
>    expects the actual number of bits, not the number plus 1.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: mempolicy-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
      https://git.kernel.org/mm/core/c/50d3f729
[2/2] mm/mempolicy: replace copy_nodes_to_user() interface with put_nodes()
      https://git.kernel.org/mm/core/c/995fcdf5

-- 
Cheers,

David


