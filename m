Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF00A606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ3H3g6M
Received: by kanga.kvack.org (Postfix)
	id DA3796B05B0; Sat,  7 Nov 2026 05:58:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DBE6B05B1; Sat,  7 Nov 2026 05:58:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBA06B05B2; Sat,  7 Nov 2026 05:58:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98D536B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:58:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2579F1602EF
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:58:15 +0000 (UTC)
X-FDA: 85408023750.07.C329237
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8011A80003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:58:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ3H3g6M;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794049093;
	b=zGiHVI+zwYZw4V7mTN2ooIiD2VI5Yb3R3vqMsEP/twMIgBHPbQ9qz6SFnMTyPwNooPAiCn
	RCPldSb7aR6Skz4/G/x9eNt3Bk/c2OBtW+FXEEac7qxCGgQ+9oc5UKuSo6GTYm4aYACQPm
	DfymYYr5HobTSq921sz8YEYn8D2N33M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ3H3g6M;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShVD0/lFnfCk9+NOZh/vGjWFTDGdc/JlM5VbuhQviNc=;
	b=y/CVDdX8aLbBsHrYsDz2YbqaCpRLfbxCGQIuaWNIfWg4Rc7uXXRxwHlDIzp4LufPUMZ726
	Urk47OiPN2YjTLOZJSn4tuYJEBkWhGRjEZF6xjYJUAZqKIT593uBIbWnSqG287k+BW7Ec5
	ZcmmV0eGtd11H5738fD7/2w+d9WhtsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18B6860F4D;
	Sat,  7 Nov 2026 10:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4831F0089F;
	Sat,  7 Nov 2026 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794049092;
	bh=ShVD0/lFnfCk9+NOZh/vGjWFTDGdc/JlM5VbuhQviNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQ3H3g6MXx4JGlDF6JwT31Va+JkSFnKMBVWKYAd5bJSjzveCS+TEwtfvgYXLFNpUt
	 Xre38xeRz3BfrZ2v3DJtfGLBzu0t9kZzfzKedtLshaYxyXFbJMioYAtJ433HDOdiYJ
	 NqFGK6QGXqKxzBSecaWejwzkphBsLWBB7CLxaFw5VFPiQeuLz3FSHouMZl0IOZLhNL
	 xX1+o3OL1mVqwYl7zx+6I5exqVjgITeQ2crXF5hlKNQM8YfYlsJVm9x1B6GCPN8VsH
	 N1b6xgrAACbxLqvhAA0sTqWKFLSxixgaXFAlqK3NPYQtJ1Igp1e+QnBri8fESMuYCE
	 e7cUotrSiRDJQ==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mukesh Pilaniya <mpilaniy@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix restore order for NUMA-split preservations
Date: Sat,  7 Nov 2026 12:58:00 +0200
Message-ID: <179404894583.1473879.11936948088388939869.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105-kho-numa-v1-1-e807879644cc@redhat.com>
References: <20261105-kho-numa-v1-1-e807879644cc@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8011A80003
X-Stat-Signature: ayyzohgq39cb68ii711wj4k4ay3kryci
X-Rspam-User: 
X-HE-Tag: 1794049093-478282
X-HE-Meta: U2FsdGVkX1993omCILPYqwsBwN+SmQhNKpxU1qHJ8LbizW8h+AgjtWCo2fHVF+WJ1Mf+5zRUrnrfFn5cJXo7pUkpksvgaT2WFf44H0nQwREksMoggY5Zivo6TStX1bYX/Kct90UVckPQ4T5HbGbyRQSX1MZYGwLeqZcp7PYMuFLAIMMkbe2QYNUkEGhchfGTyDOX7rLOKGc8IcAMn+/LyTVTvwq6cfe+qUS5Hn1fYxvEvY69HX5bOas075D6Llzr4PPzDFQL7NcCTomi6gMgNS1zlE+ncKUmeIG5h/Fb+TCiErkYyklpDYgwql2PaQIC4nGxeQrSSfcfv4rApQuk4tuEyCHO6v9YtmY31kMC/qhz41TYEPT6/C8It/bRJY6aFLyWB2tpYEW5Q0ERfOe46QSu4OUexMDDuiXAhNaB9i0A3mMEI/Hpp+4qtH/STqEExXWx+aWEnkLwz98wo7ntNSDOq1TKp4839MpRB/w41JWDocsqFBSQF2gHvzfrHD/+DFZTCmw0NRSHaR/nKkJyVn5nKiX7DerekppYc7bDpXLwYWoC8juRbBhEZCtKE17J5YGJDJSFyePPkakxphDZPbetFx6USmBbRiZJQ03yHN0+I2yuh0FdkN01AVtVKQ6ZPzH3z7hSzoio+iH4Am2fnUXNEGQUDwd1nNmVH6B+P/K3b/i5gsqoYNsXYn8co1Hx4Gn0wwZlkXtw8Uew/1AKGzHP9LmHPJl6/0qoVUjukclBzl2G99emnnLctFQTgJXhAK8vtddp5fFtuAQ4zDJqOJYUy/o9kblXUJojzqnWipl5DfiwEDT7bzU1rMSWhxo0p8d0PX8ca7dt7Isq9m1l4Ofkd7IRGrMuV2qUKuOnG07mANVAysc9KDP+CGiRiSXabRb9QzAzlAy6hU8j6kmAGrfLAaXTj4AGvtOyPpMuhD/Jb+UF/MhRI+eAHAN/nPd51BoPX4BSlJ2A3B0oxvY
 dWFg3/av
 fPLJNG7lUtDpkPJtEtm8Kc+r9LIqhvIRKbH0/H4NbGFaQznkO+dXkapyda8j3LCkRB6LCSk/L7zniHzGKmdpkEnj3sX6yGRFpQibIOQSp/exOiCirq8mbp8L5EVYD6L94mibCA5Qr+vzJqb9av5z5kokGNNFCRB2hacjn6Bd9EQ7iHJpmL6F7mPp25PBaYiTpdVkWpNUGEuPnpyJYGAXQm/3QZ5HTAwNpHl5N3yD01zJUEDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 05 Nov 2026 18:51:33 +0530, Mukesh Pilaniya wrote:
> kho_preserve_pages() uses __kho_preserve_pages_order() to reduce the
> order of a preservation so that it does not span multiple NUMA nodes.
> kho_restore_pages() does not use that helper; it recomputes the order
> from the pfn alignment and the remaining length only.
> 
> When a preservation was split at a NUMA boundary, restore picks a larger
> order than preserve did and jumps over the next key. Those pages never
> get restored: they stay memblock-reserved and keep the KHOP magic in
> page->private, while kho_restore_pages() returns success for the pages
> that were restored. The consumer has no way to notice that part of its
> buffer was not restored.
> 
> [...]

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/1] kho: fix restore order for NUMA-split preservations
      commit: 825c63a0056cbc94cc57779e83440ffb9c5103f8

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.


