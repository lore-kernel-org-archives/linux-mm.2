Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A060606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kcsVYwZN
Received: by kanga.kvack.org (Postfix)
	id 1D52C6B00EF; Thu, 19 Nov 2026 00:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185FE6B05B0; Thu, 19 Nov 2026 00:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09CF76B05B1; Thu, 19 Nov 2026 00:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D75CB6B00EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:54:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EEBFC092F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:54:57 +0000 (UTC)
X-FDA: 85450805034.16.94A04A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71D1D40006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:54:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kcsVYwZN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795067695;
	b=bMM/x5XLg6ciOSrj6Kbd/TDixyLJPw79DaPeNNv1+8zSKNr22LjpiSpqVE3dLweVHwOn87
	7QQl4oylcCEw3eZoTsn05oKlwhUas/BFz0C+ITaftZIsnVFpZl4p2i2Fn36jF/dhTmJerJ
	orTcS13tKjBU5q053kkikheg6JfX4yk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795067695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFfnlyC81sGzZtiO2N+3qRscXbxSDBZT3Ouo++SYFZg=;
	b=poG20ljLjRF/9uEvfZOoLP8oM1j1qZoRfQYfMYtK7XkJ7DImGjRN1qlqHbece7Pe5Rv8BD
	E+xq8n6FirDt+9eqhnqrhCzGoGgvwTUYVg3B+W8eUegeMyOzICS0MpKjaiOI+rJu+GAcJ1
	4l+TEB5fuOtHGQk3509XNnhwISIw6vQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kcsVYwZN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E50D147092;
	Thu, 19 Nov 2026 05:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9DE1F000C4;
	Thu, 19 Nov 2026 05:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795067693;
	bh=zFfnlyC81sGzZtiO2N+3qRscXbxSDBZT3Ouo++SYFZg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kcsVYwZNsGJrHyzeQz88vuyxBsb+6xOlt7YzUT5ObKKo8DXRRD9FG9sZ1OQoQOe+6
	 szu04sTc6GD6yOnD4Rph3/Dv7nQ+tkrOF/YpU/nYzlyiuLfYjb8oDgMSQIObQ324Ra
	 BNrXE5LTUAbJ5zQRQk09Ucg+TA352U0X5BJW9tMU=
Date: Wed, 18 Nov 2026 21:54:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Subject: Re: [PATCH mm-unstable v2 1/1] fs/proc/task_mmu: avoid spurious
 seq_file warning on interrupted VMA lookup
Message-Id: <20261118215452.388e62261c6ad4c56a95f2f2@linux-foundation.org>
In-Reply-To: <20261118103421.776-1-adrianhuang0701@gmail.com>
References: <20261118103421.776-1-adrianhuang0701@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 71D1D40006
X-Stat-Signature: ys3wnobcwr18or6kiqq17kwib87xhemw
X-HE-Tag: 1795067695-645661
X-HE-Meta: U2FsdGVkX1+woqXtwGuU6asf1OC32qf5uI+Oo1gb7DlkiVx/IlHeGeKAKpG+t+geZbDUpEX+ez3MfHlrPqamMtpedyobGYCyU44bBBrnN8mYSblbJElT22ssdR/yQntifo2veVm7t0Y6ev3jJHHPPxT3LMhu2FJDGadQwQ529sDZ/Jk5Ii1AQaztvyTdQqHQlQKMkgOIW3hUrFEpOr20iUZvtSX3e4YjsBWStZLpJQvqfsWvbiPcQoUjr/tY53rboeVdrV029lRfRlrk2oiLThoWA2pGr6tPKM1sVsVy6k92svHIVC2FahVRz2H1Jvs2xlI2COMenOlXBBsQjI4yxMSaM+b5fkPK+qHtKs4xnOnazVzpP5BKcaWaRgdkfYmoe20k/ZU0Yj8iMVwa1uXSIKs9vYqv8pCEG6FAnFgtYnFHQIHy/oV/Dui+WywZu2xlKYBrGAV119vGDX++Sq/+nduORySTDwoNXV4CgfhiO3bLOKQgLI5P4uufcdWnArlayutyxu28WS3U5Z92cJmMBa5gZ5oDgcTVw28dt4NnVvIO98O/sOT4c6lITvEkKugW3+9WhjjzHSBzFP+ZSf7GERlmD8rypHABdC2yq98hNrSORosIl/xbuGIou5T/bWY5BnCw6OodjbJUN1xMj66MmuzvVHVz3AFXeyGrmznm1fzUBDDpzchEgwm55rGd9njpJh4vinfxkTpuplwuvDhHXi7p/LswN+tNKnWknFlwHYYTJFbOST2dHy7/nFUwysfDASiKNALJAtEXPTPDbErMlap8nnQAvKHG8oBybn2xonOX18tc9OFxSMd7Sfgqt33YoaoyWT//j5Q7Ege961+DtxdKIRFTPD2/X9vMMPbvIySjD4AHzp3iD8Q2/oCa6NS7MKf1KwjEKfK7FL3sapyTZ2IFjJQ0KjcEFH6OpSh6d4VpXOE6U5CX3LjbY9rMmfuovX6TDJ9dw4pyvziaROy
 mTdREp6y
 7GNkB/aKDB3ebYN7fTBGsWVmPzj/LXpF65nbvScHQIUQFg3sSKE2UjZvLejbEwoXaKet7ci7IYUvDtCIxBIWRAl2JfDsntWr9mFyJmsGXB2+SUlXExLOM2mEuOTRPRZR4ypcbGxNs3AftcZ2vPcxKu3T/1GTD/1O7kpWkrYv22spJgCYaMxLKlAXBcsxMUrr7cTI+Jx3sGFoQ0Mbo8mJ1AQH+/EhOtdNbXpkFJJ36G85/tSHP5SNRP+7pRpd3N6RvsVrLtjJgG/5P0y526aTQB0l//FLW0ndCEmD0gPdyeu+0ZCkDhg40lYOaZosu3J4sftIvAdsFYkWn9DApK8pxTHZdkP3rdSlSrDb0AF0FyLJFAXnxpC64na3BJ8dNuBCzgFZpjjp5z6VipAFFm+gyDqzx4NDdjfgiL18bs6sZMs7W4RNYePB79esp7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 18:34:21 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> per-vma lock") introduced the possibility of returning -EINTR from
> proc_get_vma() when a fatal signal interrupts mmap_read_lock_killable().
> 
> The issue can be reproduced using stress-ng's VMA stressor, which reads
> /proc/self/maps while concurrently modifying VMAs and periodically
> terminates child processes with SIGKILL. The reproduced command is:
> 
>   # stress-ng --vma 0 -t 60
> 
> When the VMA lookup is interrupted, proc_get_vma() returns an error
> pointer without advancing the position index. Consequently,
> seq_read_iter() emits the following rate-limited informational message:
> 
>   seq_file: buggy .next function m_next did not update position index

Thanks.  That's just bad behavior.

> Save the current position in priv->last_pos before checking the VMA
> lookup result, allowing it to be reused by both successful and error
> paths. Advance the position index when returning an error to avoid
> the spurious warning, while preserving the original error handling.

So I'll add a cc:stable to this, target the next merge window.


