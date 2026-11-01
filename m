Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AE8606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvIAQjUJ
Received: by kanga.kvack.org (Postfix)
	id 355056B05B2; Sun,  1 Nov 2026 03:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306C26B05B3; Sun,  1 Nov 2026 03:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EB26B05B4; Sun,  1 Nov 2026 03:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2EFF6B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:26:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8468B40A06
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:26:19 +0000 (UTC)
X-FDA: 85385868078.13.26789AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DAB30120002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:26:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvIAQjUJ;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793521578;
	b=SeNNfuUbxAuhg9myP4MnlB/b/FK4AXv43DN5ZnhYPmL3+NUiJWX1M2bK9BlTl4iC+ZUK+a
	193gs1x9q8EqhoaRtK8ubU/WKJTAGIt/sVDYKEZcERYunXsZny8SEx09cHmlT7L2PTPuuU
	O/06KxWu9yZsrKqrvFKyPxDEiaxta8Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvIAQjUJ;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793521578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNsJBBBgsxOmM1zuQK6aYuVr+p7Ctuqp4i+1aNHodeQ=;
	b=6guiHJvoyBTn/V/aBtHFrkqemgyLflW8+348zv0xizOs2SotI9l4MC97/bK4Cc9z/Eybcl
	59Ps5iUMb2rsribj0rvve65tOmDahPaKckZ6Jle60VxDdR6q9Uh6HjujWmNTFbAcYUHbIY
	BBQfriSzYeTdsocY7/AO7ccWRGWkuvY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13689408BF;
	Sun,  1 Nov 2026 08:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFC61F000C1;
	Sun,  1 Nov 2026 08:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793521577;
	bh=KNsJBBBgsxOmM1zuQK6aYuVr+p7Ctuqp4i+1aNHodeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kvIAQjUJHsI2zMo7gCLMkjddDhJaogUsYHfyK6mHjWnhUcES37ve1U4Ic7IntD1U+
	 nTBKCw0GRaIlUlxkfIWAbPLhLL4E1tFR7FSouSxfzbgcf1kyHwjZQZ5dI81SqJARPU
	 MRFf1k+zG7GrX9S8aNvONy+Otf6y9QlbVM5m9Edqg7NhKfsoL5150rljpLjmWyg6oE
	 dstM+toHdhCMY4PI6FwbIR1rTcmH4CGZA4Kd4c94+YOAds5JGP9YFtDLjWul0wgKf0
	 Ur5vkZpRkyaLhfGCGiMI3E+su8K9kwua03lApNoIh9tBl8gQ2VGTLr8gDFqS+GWX+q
	 sDa92PtrmDtMA==
Date: Sun, 1 Nov 2026 10:26:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: store the child's new uffd context in
 the wait queue entry
Message-ID: <aub3o-i3h2OVcWM-@kernel.org>
References: <20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: DAB30120002
X-Stat-Signature: gqmhgg9t7ah8df6qjiwyfk7gab5nhqk9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793521577-491865
X-HE-Meta: U2FsdGVkX1+LoA6sTltt/7Qpi013mTyoajWITGl7aZdkmacQf5VFy9GuJyeNoRBEX4cV/X8s8RrU49eIuFSL0I3HRkMGLNU3VWHH2I4itGbZgrONW2oi7utA+Sam6U8q7JbOREgBo9JdGA9SQdHjl1cCDVBoqt0ASYQgA0DpklNO7lhslc9A9VttgYvgHbZVAlm9XAPkOiYpFSRSFh0cTEgM9B+F7TaXuf8zbPjETlzLhJg0GR3MYOAHcSq+z9gdElAQr2KbmAXoXQgwCRnzrS/KW8T4hcNpTQ8k91KTc45f9WJM2G7L7PmlgLdLO7Ai2XflLs1r3jV5DJx7EKjyFEbhVf7ukeRJgAhGQhrDOEqpoa6IFk/KNZeXd6+ZPhmsP2C+tJmZWQyVmKItdrgnwODkrwXgxFFdr9+lz4PiJK0CGrKUtQ2jozPTRjDt4UmVrc2OjHufIKbKQ7gF1EKVQhety8fY/HWBjb6CqNM0pqJkUsc4erUSfam6qEfFUJ8PfCZSRnmLqBd9by3Oe3HSSE6/ue5kW99TZhXIZCKpDuND1YOUe2WeCnHCW5aawh9THGKoSyyhhNjISKrH2kW50MGvwkONxUS734nMhdCMHUHNiD4AYKxFNqRpxby5hcqXrwAE3t4pPX2Dta8mS11pBB+lPjzOBBOVpWyCek1GvxoyPVZNvZD6dDMBSlts+I5xHBrnrmCw94To+TjDv23MiaByLgu14/h6L2JFflWQ0wGxGNIaCg4FONEyWSGwABNNpggFDRWU69uvZ36donBYMG65+3IP6bFT/mWXDLh5uR66MQ/qN/n7Agwr29s781iA/rHQpj1wn/+LBj0YfcaEjbs1UXKMUDE79OcKBqRDTRkOtVacx3ZkaZYjQ0mpjyOLID1dmxqfEQje5Zs7OM9s9RJ7ryoMW0A7GyfT4rLl5mroAEyLipjOV818Nk6fyzKJM0A78s3eeb4eWlWgL2p
 0KprMjy7
 TJKnayewBdjco1mWLZG/MAmfq4YKBwm039ux/2qEuqOzpXsNUFFOPHH9Mbv1q+7hlQ1hL6zRs1fk4GnxuxIXQC2kODRsljyt9744ONUPi6aGFL+01kXJR0ISxdi8E21R5Vy4kylf2qwgdcPeCjO4olC4F/zO3NjU1DWECbKSmUZPw96Imf95307mvG0k3ULHAyXRxL0duak0yVLOARGKodr+mlWQbSX+75C2fXSyGMOCzBclxFXF9/I5VimJCHJh6tSW4zWVF6pyHNSuwuTBhM++PAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 11:47:48AM -0400, Tal Zussman wrote:
> A UFFD_EVENT_FORK message cannot carry the child's fd when it is queued,
> because the fd has to be installed in the fd table of whichever task
> reads the event. The forking task has to hand the reader the new context
> itself. It does that by casting the child's userfaultfd_ctx pointer into
> the arg.reserved.reserved1 field of the UAPI struct uffd_msg, which the
> readers cast back.
> 
> That temporarily puts a kernel pointer in a struct that is copied to
> userspace, and results in ugly casts when passing the uffd context
> around. While resolve_userfault_fork() currently zeroes reserved1 before
> it is exposed to userspace, this unnecessarily risks leaking a kernel
> pointer to userspace if future modifications are buggy.
> 
> Store the fork_ctx pointer in struct userfaultfd_wait_queue instead,
> which is kernel-internal and passed around anyway. The casts and the
> zeroing go away, at the (negligible) cost of 8 more bytes on the
> stack.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)

-- 
Sincerely yours,
Mike.

