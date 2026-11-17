Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962A2606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNPvbPjQ
Received: by kanga.kvack.org (Postfix)
	id 954046B05B2; Tue, 17 Nov 2026 13:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904046B05B3; Tue, 17 Nov 2026 13:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F61F6B05B5; Tue, 17 Nov 2026 13:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 577BC6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:11:08 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEB79A0565
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:11:07 +0000 (UTC)
X-FDA: 85445402574.17.B68C0C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E3D5220002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:11:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNPvbPjQ;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794939066;
	b=IXfd9UGmHTBVPo+NgQqHg4HQ9Rt9rqSEN35kqHS2UMc6qDsa6RhSzyMhAMaDgkFOnVHS44
	Sj8H7tay+ii2JEiew6NVi3NvuE8vb8MCx0tEjjXTJJPGwWHYDyqYn6b9TJaAjkC27yBEIB
	9uhXVFUnPSKHbZU3Xni8uNZ6Hnqn2t4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNPvbPjQ;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794939066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wou023xo6HuD+o/1Nqn/3NE6jQfuMxKHfvSxSNa7FgI=;
	b=5imBDPc1muSvmnjxSoNF8WeQbbqa7MVsIBe9cswPCJ4TCWtq2UakynBMlFYUsZ5nls6nDc
	So+baanPriB3FlayLnWUGhZWAoBVpLim9s/XmcALM77j4dGHpkoKREeybze5Yrkd0lrw8i
	sZt3DuIs4+CB+37bRIifpmAL0lgF/LM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71DE8459AA;
	Tue, 17 Nov 2026 18:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23721F000C5;
	Tue, 17 Nov 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794939064;
	bh=wou023xo6HuD+o/1Nqn/3NE6jQfuMxKHfvSxSNa7FgI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LNPvbPjQXT48619P7Pwp6j77+NT0YhCSIhqLA0K+AIwR73pxjr28jJLArSSEG5VCK
	 bBS8WDg7efMJe2q4i3yJYBXIggmGcLTDaUjlNNfiBjfITkt9UuQjCjtXDTxZfxWiiN
	 5ianJekY8++CQw6Rig2HUw2DlTlvdtyzaY7JFLB7yf0UHC7Je2W36XSHFOPd/MaJme
	 wA+Gi5nqZvTJTSB27MJ/KNIMgqPx+3U6pn+dm8CnKTrIn5BItmtxWpAX+q6QddxMkD
	 FKZxbjg2OC86An8lthtZ8Ul/x3ckscMHOvLAhZ7hyaVIcibUxZFPRyprJtkQhmStzj
	 oiXUswDTwb3Kw==
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Mani Tofigh <mt4022@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu
In-Reply-To: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
Message-Id: <20261117-kauffreudig-lebzeiten-kopfhaar-e89b7492e507@brauner>
Date: Tue, 17 Nov 2026 19:11:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3D5220002
X-Stat-Signature: 9deyxc9njoaq54jki1xdymziot7xbt9n
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794939065-253952
X-HE-Meta: U2FsdGVkX18wtfsgZhFIQxrW1PjepehEtGuHvzXq8qE4JkIqKPrI1Vxnl2jVFwdOSiJUdqLlUEQa340nS1Iz91vfhwf+xGBy78RipLuRkGJFCbpmxKfOJ/4/3Yg7mZ65Wi//TOJ41uTdSpXUQyXLxsa2fhVujSmqMagH05I4UfkaZq0EAgOjkQTfxvlyaOERfJD47hdbO0wRtyhYX5kOEZnka6OrIbquOSe/P7C0SJ/tq6jQ3Gcz2RysBIk4rZmNVP3PjQ2QpDGKs7cd1VtiONBmRntIVrqR0q7VLuD4PAU91+JEoIbmbGgoUiJzJzKHRrcLy/fHE1ojrNqK28VWWS+zbZYnGIUz97xisC3m9VjPOUiL3zw7wdNO4hD1TSeMx6r/L4CY79yVhpX7YmcomN8vgJrIfGvShSD4sK8iBZswD5OBFnkIqouEj9fVqEwAZ8Ry1dmk6dbuJjL4G8SvsHaOVIzrp7oBTxSepzLavWnDoJrHAheAeKCHwiPdAe2YogThgmEzjIN4BYsutYQT+1LhcdlHrllWRIl/CByrB+FYcH3FLfljjRiLlYckqpkxZnT9+m6p79nfmFW1nAzC1Hnesb/eUZH6mIygAGWrX+W8c58e6beyBVWBoQVRKCSkZYcUKuKeI16rsqd2lN4hAhG4qPDv1u4dI6WiefYFRmnRRm+J7gXFxLekT9uNp+9E+0GhZf8RaGG734lhGlrNhSibek14gEO/0oxkC9h9xp9N0JkHMbsQfWaw+UFSPQ8vSrV08etfmDJwR3KvmGGQUVoYiI+WIh9M+VGh4YX0Zpq4yGYjzl7DJxcsSkIag3xIhe0ZdZrGxLkMuqQOAlcIZihkeNuRRL5hH69mCn3aJ0kLo5NElub3dhDPV3yMglgknV6PrUyd6KxAJQ3gBkIl6fS8tLZ/JPnIrgsP5Y/q/DHNXPJCY80q4MiIPnJH2IM3JQ5e/Bj4PeN1kbVyb4E
 72xuC2fz
 4EMFkj/Y9IvahfQ3R4F7LSDh3csTZeE+0y4hLpa8z5jtsMR4P6GaNH8mOXUm+UpSrAtpGDoAKAWd1QkzFKVgjOqXUhBBSKC2X9d6xqRBm3oZoQ76YJBA4avQqGDcu7Dvqc6FMZ29TtXNc6uMmH75FqTS70b4S6M/pKfwk+cfu/MbE0AqBKwAuLf0mnip72goOM+gqneVHmI6fBff4gcaD7znFTXvTNC0tamlkw5jcokmOjoZQ/uvxIPLCTsCfnyGK1f10bZCqe/Z/5wyMojbTOpUQ8Q+8frDu2bZm6OjAlquWYLd9P/b84b+qFvQC+5fOMvpqGrEGKpiDct/s/WhEePWo6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 16:09:23 -0400, Mani Tofigh wrote:
> mm->owner is written with WRITE_ONCE() when ownership moves to another
> task, but mm_update_next_owner() reads it with a plain load.  The race
> is expected, so read it with READ_ONCE() to match the writer.
> 
>   [   14.915975] BUG: KCSAN: data-race in mm_update_next_owner / try_to_set_owner
> 
>   [   14.916154] write (marked) to 0xff11000004471b80 of 8 bytes by task 71 on cpu 0:
>   [   14.916204]  try_to_set_owner+0x100/0x140
>   [   14.916302]  mm_update_next_owner+0x177/0x300
>   ...
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

[1/1] exit: use READ_ONCE() to read mm->owner
      https://git.kernel.org/vfs/vfs/c/daa40a6bde22


