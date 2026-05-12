Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A94FCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A386B0005; Tue, 12 May 2026 14:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AAD6B008A; Tue, 12 May 2026 14:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760FE6B008C; Tue, 12 May 2026 14:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68D926B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:12:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30371C1463
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:12:11 +0000 (UTC)
X-FDA: 84759562062.04.CC1D8D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE7B4140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:12:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SAD/Vfth";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778609530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oV72g9CNCGHrjmsfjf2GXyoaDNFLjz38yX2bXr+Ix1c=;
	b=Dmjqt+IoDqRlhfEt+oziGZ2VIgfA+TFmOMQCkJAeiw06dxcMy0jIpCX23+6CQ2UmdC80FD
	wVUzZiElkAfzWCCosWcNLRnfZ5j8PoPBgSpPMS1VxKay2kSXTyOao0kDj6mjcCjrsdW8SE
	twjfu0JKAOsWe/prC0vFGoAckmWpLGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778609530; a=rsa-sha256;
	cv=none;
	b=Tn+JftagSMnrQ3z/6+0YrJ9zmMYM3E1ZqDdTlbod3Mqum9sb2KKRNrFvQXAYGteiYNFfhg
	dozxnKlNDra/I6JeirHF6w12+yMT+QTeLWo8o4e36d70+OVDXThNNFh8janZKEZ53PpSbF
	2F5TEjvdICrwaEEomat51A4dxRVD0Ho=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SAD/Vfth";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B69B543DDC;
	Tue, 12 May 2026 18:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE923C2BCB0;
	Tue, 12 May 2026 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778609528;
	bh=Tav04tYNGpLRuW3FuZzh0z5AH7SKPdJxNU7pq9Nvsqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAD/VfthTEM5OhJ5Be3jlSsW1RggYEqzlvT658DwOHjZSe+6wKiOsCPxUsj7kTOCJ
	 KKhiawiX8vXx4V2Rtm3GHd/dqAzI5GHL6CIrMCWKIoFnooNZGDl4zWpbRLZoSKSUkF
	 N0S861bSfOP84WiZwOh0t2teptBA7WyvhTf6c/t0ZJlMxfaJNCZWiAgTKnbf/I37Lc
	 HfRIIvfsWseBeVaZxoPlgQJ5XOvhvTVgd4RSTAy21FdTDg0nrV8uTaMyQZArInyS3g
	 0pW9GLSQjKxWBZGzVTy2RQoBztzaRL61wgt6oTc+nPmriRvGo9VBfZ2lMA88cBOwKL
	 M3Pa/EAJN9ECQ==
Date: Tue, 12 May 2026 21:11:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime
 sync/async toggle
Message-ID: <agNtbg6wv_kjQlb7@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <e8f142c530b715c6d45475230c4e35a1cfd8dbd4.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f142c530b715c6d45475230c4e35a1cfd8dbd4.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE7B4140009
X-Stat-Signature: ffce1dt8f4xnmdmfkaf79bg5eo3wft9a
X-Rspam-User: 
X-HE-Tag: 1778609529-331533
X-HE-Meta: U2FsdGVkX1/QVSXqg9ZpKPtcQaWB2mrwj30QGc7fX+kLoOOLTrMnfbcsiqVvU3Sr4RsR1rnvd9bcTz1CRrMcITELFH/2Mt+/cDgxFPbdUxgre9bd+CeRcrqTQW1LiafcmWShjb8/SvuzJeLmGXo7JXVMjFQLrgrMw31C+sbZLDVGBrt/PRjB3e6V0sjhK3RHskP9ToAfYuRP5FSK9XRWMGy0MWsRdcsBaCZgqr9u3PFZW8uGn+vTnxDrlK4wZRbqEjNqz0EsJT6FmyzA4ARcqi8odXu1f62Q6zkrN+AGtkcpyxLXLcC+z2jITyLnSziI2IVCyqXTat8UgQCxIqP6VM5QOEaCfMQwmry2ETTZ3TtaZRmw1f0OUhxNvxIbAID6trMNMUH5yZGbWXoLcvDkigbW7Q+Ik6WYNO6JbtIQuOydEhLvd/xb2x5x/IRftaQiCSZ+2jkDTEkYnYAPco6c9IxwXO82uFAnoq3J1Hl4W9LzTW+oWQYcK6Jmr87aQapQjtOa3ZuzxJr4R3eNTbdyNsA+HqAWUzEiCB/GsIELpVZihmbNZK+pBixoQVGZWXBKD9j8IGzAAwy3B16zZLUle/mIbl2xQUdTzabT5yU8wX/HGT9s+C46HkOYCUwjXS/V3q5kIQZSlWZlK90uBU+l+zYQLRkZ94n53BmkYD9bz9jnbPioTzn1A1CLTTgfwTAfTWXy/5Y96Wr8SswVH7am6bLUw+WygkEDmZCl0LdQlKSgh2HAf54oiRmK5HuIqs251xRG6S4qch1SmeoadYTlkIuvddEewXdmku3j3As9ce7K4YhFK3BLtuAXbd0K6dZazz1Lxh0jGRPxyMIt3K+GszGk6sl7i6ih2Zmmle3TCn+c5/SdsSqVYHBxxXEsNAQr72O9pfYsOz/VQ8i02bNYyAtmxeyxtA5sFsRiN7sk0zfZ+g9P4MrA9uvVzFI3dTgmZz0BGVHStCLmrNzRcWx
 SfWdnmrL
 BcSyaRisub8AinYTnf47YKI/l0KO8sjGN/GjELCnNFFjLyCueXTbyzKUGcg0ifIwVarOdHPP/Gfg0Fc9Z+oiU9O1avjcY0/HqR0JpUn+vl3FQ4o/w+2TUSeI61lfzGCZhrKGUfkpHraoZ6CEt/b3BmsVrslb8Ly5c+Wcjf27fNOVPg76QzsIK3ZqenufQBIHO9Xnl/19Ow8w40njJO9RvjmiQxP6glUcXYgQtSYcUsQbu8gcI5QQWSEoJHcHOhfU0ITicZt/cJN5c76dl7PKEkNfTT5XhSDDlOsm/niyFLWeBdOAQFlBzVDl0/LjRhfba2vUJtYWrU+7KWVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:24PM +0100, Kiryl Shutsemau (Meta) wrote:
> Add an ioctl to toggle async mode at runtime without re-registering
> the userfaultfd. This allows a VMM to switch between sync and async
> RWP modes on-the-fly -- for example, starting in async mode for
> working set scanning, then switching to sync mode to intercept faults
> during page eviction.
> 
> UFFDIO_SET_MODE takes an enable/disable bitmask of UFFD_FEATURE_*
> flags. Only UFFD_FEATURE_RWP_ASYNC is toggleable today; the ioctl
> rejects any other bit with -EINVAL. Enabling RWP_ASYNC also requires
> RWP to have been negotiated at UFFDIO_API time, mirroring the
> UFFDIO_API invariant.
> 
> Fault-path readers of ctx->features run under mmap_read_lock or a
> per-VMA lock; the RMW takes mmap_write_lock and calls
> vma_start_write() on every UFFD-armed VMA, so those readers are fully
> excluded. userfaultfd_show_fdinfo(), however, reads ctx->features
> without any lock, so the RMW is written as a single WRITE_ONCE and
> fdinfo reads it with READ_ONCE. That keeps the lockless observer from
> seeing a mid-RMW intermediate and removes the audit burden when new
> toggleable bits are added later.
> 
> When switching to async, pending sync waiters are woken so they retry
> and auto-resolve under the new mode.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/userfaultfd.c                 | 150 +++++++++++++++++++++++++------
>  include/uapi/linux/userfaultfd.h |  14 +++
>  2 files changed, 136 insertions(+), 28 deletions(-)

-- 
Sincerely yours,
Mike.

