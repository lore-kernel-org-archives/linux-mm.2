Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77BFEA3C22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E17E6B008C; Thu,  9 Apr 2026 06:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8D26B0093; Thu,  9 Apr 2026 06:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F62C6B0095; Thu,  9 Apr 2026 06:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 049286B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:14:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC25E140746
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:14:00 +0000 (UTC)
X-FDA: 84638606640.14.E3D2FA7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0BC340010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:13:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Os4bzlJi
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775729639; a=rsa-sha256;
	cv=none;
	b=eKEIvZkZgj14I3qOqGpfzwgu2/yEzNeWylLBkl3m9kEMBBy6xgBx+CHIEfC1fXpLFjatWg
	sPcQCzZKU6bKamXliFIA+ZwbgJOYdtEGeJcode3uFUqQD22+9kBl7470R2ZkAs/qzLj+FB
	9wkaV1CAuw1QgJ3cSChvXvucR4Fr/Dk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775729639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzWgWPTYOUXksm2yrkcRcT+jT0HPJKIhnfcAUSbpY+U=;
	b=LV5zKLNJG42ty99FMOzlh0NmP3EawhUuqfKKmMIrVu0lGOucJ8k+MXsLyNaq3GTlg9NlES
	eoxe5vFLjBEj5XwN6d5SPYJ6S9MoDKkgJKWG6YyK+g4Aw4r92DCnlLId6IhJjWDseHLaoy
	gc7/uiFKEzjaO0w9LRM8PQyZGPxlDgk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Os4bzlJi;
	spf=none (imf07.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FzWgWPTYOUXksm2yrkcRcT+jT0HPJKIhnfcAUSbpY+U=; b=Os4bzlJi9bj/d529D/CNPg2+mG
	57BpudCqnG69DUWP3fHaIAFLnOgZi0lzTjI/xDZf1ptRBTLOHX4krCZjLPuKjaKRQIC/Mrq4pLT68
	KB1dXUJDOYIswsUI51ySf+3kG1IaQuUe4F+mGKI0YunJQt76F/+xqpuC6ewFl9hwGnbXVQ62ceTWE
	vUkwxjaU5gX9mfD7gC8eVnjYubM5nz7NfokII2vTefdvU3ehednwVYgbwn3ATc0MH4DHuWZMEvVT0
	8eF71tXDvzj7ZTfjtnZcYugLaKQ3aV8KiQabvi4Hwo/O7GeopnRZNn5AKZU2z6Z9+PuhAtbqFdx/U
	5HHciUHg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAmOT-0097x9-2S;
	Thu, 09 Apr 2026 10:13:50 +0000
Date: Thu, 9 Apr 2026 03:13:43 -0700
From: Breno Leitao <leitao@debian.org>
To: akpm@linux-foundation.org, mclapinski@google.com
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>, 
	kernel-team@meta.com, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, puranjay@kernel.org, asml.silence@gmail.com
Subject: Re: [PATCH v8 5/6] kho: kexec-metadata: track previous kernel chain
Message-ID: <add4SuufMiHo8Mpm@gmail.com>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
 <20260309-kho-v8-5-c3abcf4ac750@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-kho-v8-5-c3abcf4ac750@debian.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0BC340010
X-Stat-Signature: eegsoywidfwmhmxau7qowi1wkchn7r5x
X-HE-Tag: 1775729638-298523
X-HE-Meta: U2FsdGVkX19CGBvFYL797AluXNeWu373jCncqfwbGMtE+VmNUuE3/gpPYHs1JeTrlhikEGRrePMhcFY2JtRwjj19Q46/muQykpxR6+GOCULqeTt1dx9qtAGLKnLVhKuDnzJDWaQ9sbRXv0qw11yADVU/MS9T6zOA8YdB3dTw19zi5HEQN0/1OAnl7G8rzecYGLwp4lkAF/hWheM0x9FSJ2Gvt4xHdPtQMY9/bz1wSxH8queKy8bA9wt5y2+/7cCWjvQ6/ELM1vDCqENf8/SLyCkAPT4MhWS6sOg1lvnXoRsCtkcb1+3BCx4pAj6fB5CGf5AdA++oXL1BvtuF5d9qcyXZE8nG/E+qg+kEDbYrvJ3lyCBYboVn3Vm3Eagp8oQrqpiE0D/CGrXBvoMOjzqlidvpWQUxueftg/MyQAQNc+j8nFMjR1h2oy2wy6TolcCCBMeOahzGVEbBO1Tz3PEZ8kLyjsCa59hIiTLWXBDpDvLnvgsyfdjJDBYWCQZ9o5ZIvNYzwsDGGOgaek1KHOzfJsn1qj82dOOi4lKiltd5l4nbmI/bEC6UnhMvj8EEmBUJJ+oe+9Wapm+i6KQsSbq81B9KjaleNcKudejC+kNw9gYPlCniIoE7MBDmfZXyXcu2hLq7YvJTLv+IKhvG4thlELIroKSz1daVYPYx4ZDs4DyALyzeRLWxYz2d/3/cDbrHlkNQZPBvSWrgblVVdTE9n3Cv770ZRObXe4ocgDN4SC72svXdUKC9pIULoPA0buDzrWcS2f5JcpuuyV0P4krabjkMTB2tXyez8lMh0vFnWOf+M70J5BTUw37z5PgztxTqV7gK20hoc6aRyVd+UyZGdYbSv0rTemsxdFUP/SQMfA/IpsoMk7ru4jb2LSl7FjnXj2GxCDN/gsx7RN6K7j3JuQygOwhYIkVZMMeDdp3ikKg3D/Btkby7R0oQlMHE4vdqi0D2ubNKmPXtU34t7yK
 +9fcuQpP
 hHzXRrYh9nKXjy+g4sDKgfpGyRgJkdVeJl08Wf4zNKo3BtQobLg5pnlRsSJ2s6CCg85jQNlINRSjZLhgJNDvPRQLCvVjwOMlQPbADIblA9JQkHbLdLZ05hDox98ssi4v7W7FqUw5ehnqR+lVDvgBNvMbkTZSK4D4WdhPfsPp3kN7i+/SZ0XYNbBHJTgSAHk4FZQ9rQcQwdCTQsOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

On Mon, Mar 09, 2026 at 06:41:48AM -0700, Breno Leitao wrote:
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 1f22705d5d246..7bac80e9a29a4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1441,6 +1512,10 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> +	err = kho_kexec_metadata_init(fdt);
> +	if (err)
> +		goto err_free_fdt;
> +
>  	for (int i = 0; i < kho_scratch_cnt; i++) {
>  		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;

I discovered an issue while testing this code on the current linux-next:
the kho_kexec_metadata_init() call is now unreachable due to recent
changes.

My original patch was based on commit 5c9e55fecf93658 ("Add linux-next
specific files for 20260312"), which included commit d7176a010afce8
("kho: fix deferred init of kho scratch"). However, that commit has since
been rebased/reworked in linux-next, and the code flow has changed.

I'll send a follow-up patch to correct the placement.

For reference, the intended code structure should be:

  static __init int kho_init(void) {
	  ....
          err = kho_out_fdt_setup();
          if (err)
                  goto err_free_fdt;

          err = kho_kexec_metadata_init(fdt);
          if (err)
                  goto err_free_fdt;


Currently in linux-next, it looks like:

          err = kho_out_fdt_setup();
          if (err)
                  goto err_free_fdt;

          if (fdt) {					    |
                  kho_in_debugfs_init(&kho_in.dbg, fdt);    |  -> This code was moved by d7176a010afce8, but, not anymore
                  return 0; 				    |
          }						    |

          err = kho_kexec_metadata_init(fdt);               |  -> This code is now unreachable
          if (err)
                  goto err_free_fdt;


I will send the fix for it soon, and we can carry on the discussion
there.

Thanks,
--breno


