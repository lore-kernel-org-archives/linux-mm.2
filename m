Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF23AF8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD5D6B0095; Thu, 16 Apr 2026 05:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4E66B0096; Thu, 16 Apr 2026 05:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5116B6B0099; Thu, 16 Apr 2026 05:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 445566B0095
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:44:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D74D113BA27
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:44:42 +0000 (UTC)
X-FDA: 84663934404.21.E6C9ACF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44ECF4000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:44:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRqcfWwL;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776332681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGHi20IGPNHy1AHrlIZiCtpLfLIBsbJrblbmwXTvkOE=;
	b=02sZL3L3VQ9oW8Da9p5KbRF7TYlSXVXRjIE6MKL7SLGgng1Nd1Ihe4zM4fI3fH2KFfrSXp
	6v/1XyjcI0/nS7RsO3esyJjRVhhGUCPWmPPeAGtJeDKZwou273xlg8JFrPK/wAAgkj7pLl
	2i00WhSkEq4zNkwvF7zxMCGJb/6K6zU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRqcfWwL;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776332681; a=rsa-sha256;
	cv=none;
	b=X3m78fKDcvIWrpUo4t/mwQjcdQvUBg6lBAkdY+gF1ILo53W/aQcL0l8t/RktJ4pV28ipUU
	W74acTM2e3Nm7smVnVcG0lJlnAZgLSfM9AOuuHnvEy4VP+l5WK7KxS0qCl5H/PoKei7sNI
	Eb+Kdht6dIdchh56O8XVtf0cBCiE7TM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB81860127;
	Thu, 16 Apr 2026 09:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06BEC2BCAF;
	Thu, 16 Apr 2026 09:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776332680;
	bh=C1B6Q/ycpGRJxXWmx7rnSJOiJwKESH8P+kjhI/iqoEM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QRqcfWwLVlutzlJWcd4eblfxvkeYGV3iLBwKV95VWeFGk2J41HWv4baV+wFuw4VbB
	 pnt11u4k1tgYEBQv00NE1n70jfhHkmLi7ly6ZBfmLZEXbOT/xXPeUJIJ/aFIpsR0F/
	 ztICVLr2g32F9wQLjAPXTLUVtyWJoUMcixvJgNX6Ge4fVGm1ivQ/0IQLJj9D4pQMNQ
	 8n5ITpCgXMWKaYP+nkS0oawBOljImKzPm+ca7tAw6+CXV3sXltbHCrVPwY7qScXKJN
	 Cb8+ZcVoGXuTIsl7tyT4BB7yFrtEcYbeVtfG7CqIHc7kGlQnU1Q/TiGI4Toa16ICvr
	 AGbXCe5xaD+sg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chenghao Duan <duanchenghao@kylinos.cn>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memfd_luo: report error when restoring a folio fails
 mid-loop
In-Reply-To: <20260415052300.362539-1-devnexen@gmail.com> (David Carlier's
	message of "Wed, 15 Apr 2026 06:23:00 +0100")
References: <20260415052300.362539-1-devnexen@gmail.com>
Date: Thu, 16 Apr 2026 09:44:37 +0000
Message-ID: <2vxzik9r6xyy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44ECF4000D
X-Stat-Signature: fyad46deo5tje5kwxdcdckh4351yeuyz
X-Rspam-User: 
X-HE-Tag: 1776332681-627241
X-HE-Meta: U2FsdGVkX1+LjudCIT+TlH7/W7sb6HJ9G4SJanZgt6qRakZduecd56HSOmxGz9j6EdBcZd7rpb/jawMyRT7Iqn/0CEeXbvUNLN+9aIt6oTsk8pKHljcSoGW03TbR1uHf0cnnnLab4fwgVyQD/e/y5M0FMdVCpf99wGiCfkDhJ0CmAshXQFCqONa//1/InfCjF8WNLxnx9cltIbd0aKpyDFCwJHvvRZeUS5F5DyrPa5eIrV8i8oGtSOKr8vFxED8OVycPmp7X9QTwHBD7E0ZSGgZFFfub3h9gwBKtlrm1+5qBBGmPcukRtjJ+XciYxYVIfGAcSry9vIdEkvo4e9AZN8HBncY1weTOPnS+P4+lJibTSYvWt3NJ6NIMhz1JECPAN5qkEsL8hjvwpFrBpClt4U9TPKf9UV1inKs/Did5QFEcHFhjrgd23Zpl9xKJ1BlodTNs3AXZTmrSiRyT8kZ7i4Op5N0oxRTqMepI4q8FKoQ/n57lefKnG+Zdg9Hr9gLp7Xtg6jOItzupTaWjOqH8mBwr/SAnDSfUqjWRTZlC4gKf9jmYSIxaHokNX4MSnt89Gu+vPKsQNdmyqx0A9a8K4uDfBg/W88hE8sdFGpEAaNsMLZLXiS2Ikh+0X2cq+VV9dYEu7sj8u6YpF3BeZxv3yrx5AwM4TNrP53DANLLf/roD543cVUC/VMLI7MBHKRqdu+9QmCzZoADOdWUTTojL5WmajzX2DSrF121R28UzrPaZasI6rk1l+SdzChfWW5AFI6n7jzSGmpqJM8mDnO3DGDTQzQMZGaKJg3OuBQdMNvdunykOyCXlfNTpWRBz7DTlxF0UoCf6nyLevEcn1d7tx/tCawdte29y7Xer4MGm8ZeGHtPmdaY4AROfWotSkdI2YtVeopcCJKCOlyH0AxfkOPGEURmYerXEax2elReYr7xPwtpYk9pIsuERV9S/aqchdVl97W6b3jzPS+UTyyE
 GkxP81wr
 upnF6DmdqS1OvDQuJ7qCGNkIkrsHIAyZKZxIKBImWIfl1pKWiQlK3PQMGDnNnCOVPsbf/ZkRmmsiejBeI4Qp5qVhcUKyyuS054bQg1A6QF9FAJU5U54DvBst2f0Bdf5e/Vq1tkaHYkSxJAvo9673lkiIj2srfbtRFxDjkY0yhXvt/aE3DpaKdWPIW9eMAi89JBoUG6heEAGnP6MtTjkslFvRAyYALFjVkE7s3fymq4m9ZgOA9y1LiMK/0mx3nkgHRKKnY8kAK/frzqbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15 2026, David Carlier wrote:

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
> Set err to -EIO in the kho_restore_folio() failure branch so the error
> is propagated to the caller.
>
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Please add these when applying:

Cc: stable@vger.kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")

[...]

-- 
Regards,
Pratyush Yadav

