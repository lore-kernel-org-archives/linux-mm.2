Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14552FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB916B0088; Tue, 28 Apr 2026 09:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C236B0093; Tue, 28 Apr 2026 09:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181FA6B0096; Tue, 28 Apr 2026 09:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B06F6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:17:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAC751B70BA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:17:52 +0000 (UTC)
X-FDA: 84708017184.28.70B2295
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D846E4000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:17:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NZDFjlHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777382271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8F8yXPJ0+SLjM+TX2bWnlEIcvGVtWbsupfNzBMMrPI=;
	b=U9oWzVhkt7y9wponDoTAzNUjCjLP7qNe5ju8LZPd5Xc//MnQ1SfMkuMe+QHzGI/FKP8DOt
	datwcOlO4lESr80n3K+bLCtE1kpocctZEMV5OdBFcZdA2gInq1gcgdMIgqC4OXNjgKuQoD
	KKg1pzkuZ9ylOmN4YO7r1wA4E74sH3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777382271; a=rsa-sha256;
	cv=none;
	b=JzeozNECK+BXeHjy7CE2glE5iFu53TOFT9xO0t9DVR6X59psQBh5c+eHHRpiJ5ZoJ9ytFU
	Yx5oIobngifwYYwZCkZAbAvjaANv7ujx2bXBUwwJ4ALpyrXqMnZQ29ZKoXfRwLAp7pbAjE
	8gLszY2zpgHq78jTpK5QOQlO9wG++F8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NZDFjlHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC2FC418A8;
	Tue, 28 Apr 2026 13:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54FBC2BCAF;
	Tue, 28 Apr 2026 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777382269;
	bh=j7W4Lag3NMPGnMlenY7U9QO4iWJOmsZNlOYsBLwPqv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZDFjlHMaBDS1MgYD2hOPFYv+kXcWoyvZWl9WvlsKjYU+TKWCGLrS7AUFw1fJ/iB6
	 yIvhVwMr/Gdx6SYAxYPBV5waFKMw7JodoXFnNzcdyH5uyfa07mJbIOjYgPN9vxCUZe
	 q3BJLOmXklyBRSGRT8HTPmcOT38AEnB6AjNxbEKIPHWAGytUnVTOZMJ2A6fik7zHFS
	 TWF7XMpIkLTWyIcPEZlRhicqfBKKHcXTuBlUP/2HxLRbaxpS5J2B9OFHWUw3Tw1XX2
	 sMzDwUrsdbNKjgc9vo9Ojd7rt4F3YVZfVMgjUnwMtfQYavZecBrlwLu6AEE/Bf+kT/
	 pzaOPMNvXGBsQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Chenghao Duan <duanchenghao@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memfd_luo: report error when restoring a folio fails mid-loop
Date: Tue, 28 Apr 2026 16:17:30 +0300
Message-ID: <177738223128.1904167.17845735617011162282.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415052300.362539-1-devnexen@gmail.com>
References: <20260415052300.362539-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D846E4000D
X-Stat-Signature: rg15wxqbzy83zt3wuqyek1akpmepg9e6
X-Rspam-User: 
X-HE-Tag: 1777382270-746816
X-HE-Meta: U2FsdGVkX18vIdFISLixUYU0ALKkiUmhCNJWbHjA4obg94dfxOHQrRU12AMXhmpUnhOSewQNxltOuPFw6V4icv3bhLxg5BdSeItQtqly6jLmy/r2IoPiNwx++duB6sSlAz13BwHX1Kg3hp4aN/tZdqWoKShgnI47dHdk44bjuxZXGOeNzNKZXL60b5+aNf9exs0zzHzkrs02PVRMHIQ6AW0BDlrFf70bVw9wKd3+DbU13l3Auzo/5MGKyljOz4p0A1Ih4wws+L/eVkkbv1/dZC7ztIAR1DqV3vUh9RnkRTXglPxeFxiI2/F9htMiSta02fOT7g5u/Clk4fQoRfhGnrIWecAy0xVA+vpkr650eo9imnXvtwR97c58jodFdzoPyrwGqh/t5SX9eG8aDJjw1ZWXyK4KKACf9G+vJ6/GvZFGIvQIk8RFjOk0H0M4B5xX6j7LzaEIYarm1/hcWqv3652FPXE81kuO/JVUTEJ+K1+H/cIZDxn59tHcZg1BX/LJ2/G3ZFt1bim4cfYPg0qcrocr13j8+apFW2jTUOw9eXamd1UjIJPxGLuWzrIHXlf+D1ahKdau7r7ThFP02Y/bBFK2P7dGyCAsbHCnG7jdCq2UP79Xp1p34StvosMFsHqI/aarTqiIvoQkSNySDSNzJYiNdTRUBESUR3QsWtZjLLw9iqF2y/bBrgkCSwOBgUmyemjTC5fOclFZ+OisADkSYIZwKDvC+01w+DrMRxL3wzwFra6UZE2guPYPe4iILD8vopoETnPtYIJ0F2MTvXX5lBP1tpVcUjJ8KfX17ElXvTdKhx6uu/On0EDoGLWNrJxM2WquQioupzEm+7LI8ZSg0x/7JqMxZxFm0WPTgIXTL4G2nrD4hygf5cYbEG7cqyZcC69r2heLgUK/c6Vpq3DqZeTZ/gpVp/SiGe5XSY4pm/EfrAAyaitfaKiMoUabMAkuLKCYvkibu82eAllr8p5
 blArEYW0
 9I+YZPc/CrRP5hL2Zpw19lwq4i7hCc5KGAdzCea8GKkuR+/SQ+o3lwqdlDpnIwBBrMoEolLPCqrQI8tLHfPTiNNV5ZOJrI99in41TXXeZcFxJu6NsxGTwL1GEWGArE210gPVnAjCHVEVdxq1v2jCH2/lU+Mmpe1HnJ8CECtUu9thjYiQz88xhvanGW/pXXd81tghsQtUJjOm+ND7q9PaxFDo4bDKECc4Vf+W+GyLwj4DrZNu4a0GMGHqvl8xT4iI23LyJnCQwKq0WiYMZ2F87daIJI6z//57+i3EO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 15 Apr 2026 06:23:00 +0100, David Carlier wrote:
> memfd_luo_retrieve_folios() initialises err to -EIO, but the per-iteration
> calls to mem_cgroup_charge(), shmem_add_to_page_cache() and
> shmem_inode_acct_blocks() reuse and overwrite err.  Once any iteration
> completes successfully, err becomes zero.
> 
> If a later iteration's kho_restore_folio() returns NULL, the failure path
> jumps to put_folios without resetting err, so the function returns 0.
> The caller memfd_luo_retrieve() then takes the success path, sets
> args->file and reports the restore as successful, leaving userspace with
> a partially populated memfd and no indication that anything went wrong.
> 
> [...]

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] mm/memfd_luo: report error when restoring a folio fails mid-loop
      commit: 0fb1daf0b78d0e23b63b6b65de56d4a3fd83bc14

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.


