Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE9ACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6497E8E000C; Thu,  2 Oct 2025 18:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621448E0002; Thu,  2 Oct 2025 18:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536AF8E000C; Thu,  2 Oct 2025 18:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E07F8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:43:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E422013B480
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:43:27 +0000 (UTC)
X-FDA: 83954652054.28.F07D1BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4E25A40005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:43:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OjEaa7D/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759445006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXIMoVEiv80qVkZ92Wb707Wf8z9ErtcRIVbnWmZryBM=;
	b=DlFHiIxq+H1JhBTUrrh2JIB2wqhul1L5cvvGorI94NaiH1ECls+UWK/4oeXQ0DbAKnnxlN
	U9y/OHTBcWUPY96uBQZqER7+YtXmYL6G7dvW1+qk2lv2TWODHUzqkd8w2zeLY9oCdIDBIP
	AycYM0Mtjmf+HikNU96TULNJ/3dbZqA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OjEaa7D/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759445006; a=rsa-sha256;
	cv=none;
	b=CGG8Xxa9vp6HGT8TIzQiNpdFaSeHa6rvnNvji/OVz24d8Sv/Z2AXHcBwXQA/oLihKUxv3K
	guD3hNGNgXqRmp9/bf+1d80y8rHch7Cd2yoa+TgUIG82Nm18v9cjFLgV2CHk+d/ofZeD8K
	+vVzSYIg6wTnO2+4fVbj8gGdDqso4CY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDCD340A90;
	Thu,  2 Oct 2025 22:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B433C4CEF4;
	Thu,  2 Oct 2025 22:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759445004;
	bh=xgulY8EEmp4F1qL8A6kHHyk1dn3V0wGV5VjKu/RbI9E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OjEaa7D/jdzc49Xrd0qFcYZNJwUcwdZEnG0bWo/Fh+DU7oM/sJAransWSTc6+OekF
	 AgO1qU9XgkL04IY/B5dEa0+nbdyWYS1TTSBSrlXKU5bA1oqAaqdt0f+gp9dJmnYK22
	 NUZf4LdRyVGRbUJDVq4JMMNjbZHqIvEYZyLYH6tg=
Date: Thu, 2 Oct 2025 15:43:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
Message-Id: <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
In-Reply-To: <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
References: <202510030449.VfSaAjvd-lkp@intel.com>
	<20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
	<CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
	<20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
	<CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E25A40005
X-Stat-Signature: i5e36pr5kqetbk1t8ga13ip1qgq4pebs
X-HE-Tag: 1759445006-796568
X-HE-Meta: U2FsdGVkX19f4Yt5Ynh0hWFzA9XqFrIfLrhO8SsGW2YBr1zt7hXm65aF3W85wCePFIbF3EdOonWb4jIk5CMUjOt2afBHg6w5pRLn/5HP4DRZBOiskI53ZEeFevTnbKKpu1ejrk3zt/AEVENWWqB2xNGYm9y7yEnxuPJpOp7z1aF2atzNhIrdLHGMBvm1KBRns7P4+JFue4QprR3Eq0E8dJ0uAN1mKheyZPxdKvRDbgUuXNfdJBHZ+/HdVXfIoWTyEjopQC2+ih+wABQYl0dx9SV+5zAu8qzcAiaB+QOZb0v45Zguxh43bN/xM73bJ7p30Ue5FpBrx4x0yLG2pgxjgForCw1QCGQEX2MZegotRDRrFNDfN8qSsuZ3Rld7KT6rqfQw2QTcORDWgbztQ7RywjAUw8pdatjbgM4//ot14n2WpjTISWUmIRAJFiG0MF7RKjV9p/Gce2jAfsz/jdj5mmfAi8GeK7jjepASli882bsz3AZc1e7ASiHVHndBgqiUjWmWOml5OK/n8pV9Luh8Sc6IaDFTyedJ28qEybeksH3WD2ygCVx7d/4ILeo04XtGk8mGkNbJoOzH+Hu1k2li3VQSpNE+6Eg/cfTorSSowHjKTeGCzVAu7TxsFXOm/oZsaI4nNBZuE/fQCAap/CM/TVgPeXiMfh++pmI1C4BgT62xEXIlOhP/85wxyzWK2s7bP2giuWGo1pjBzT1gUu/OJTjwqgPpb6INbwIJYTwqRGVwWV+Rl+AApEohCooLjQn7FfyaPRecdLVV99yEAdz6Y3ixlZtTJgOFxdTdCWvcW+hpHymr3DTC9FDGm4+CPdfbQsf3G9OYSKtsdvWtqZzDUVISdJdZMrxT1wbPTf45yJ3lzjgN3DJbbEfD3m9pN5tEMXIbkGmY2sinDpOTw6P+pjQsyfeFcRuvs9Yf9M4rQhIpahVurV6iB+hvSiTmjTnJf2qhvVHvFvlWr9qpdWf
 LRSV/fTc
 EVtCDL8U62jKUyRxnPar8NjvTJjMsL8WeieznUO5xq8EVMqgZ6xW4fLy3b3vk9R3svAm2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 00:39:16 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Fri, Oct 3, 2025 at 12:27 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Sorry, this is rather annoying.  Rust is breaking the build for a very
> > simple patch.  Many developers aren't rust-enabled and probably aren't
> > even able to test a fix - my attempt to get a rust build setup working
> > didn't end happily.
> >
> > Jakub's patch fixes a kernel crash and needs to be merged into mainline
> > and -stable reasonably soon.  But that is now blocked until someone who
> > knows how to fix this error and how to test it gets down and does those
> > things.
> >
> > Jakub's patch is present in current linux-next.  Can someone please
> > send us a fix?
> 
> I am not sure I follow -- the diff I gave you should work.

It would be nice if someone were to test it!

> If you have a branch you want me to test and/or give you a formal
> patch on top of that or similar, I can do that.

Thanks.  As mentioned, today's linux-next is where the problem is being
observed.

I'm queueing the below as a fixup against Jakub's original.  This should
appear in tomorrow's linux-next.  Or the day after - it's a timezone
thing.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
Date: Thu Oct  2 03:37:47 PM PDT 2025

Rust bindgen wasn't able to handle the BIT() macro.  Add a helper (from
Miguel) to fix this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jakub Acs <acsjakub@amazon.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/bindings/bindings_helper.h |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise-fix
+++ a/rust/bindings/bindings_helper.h
@@ -99,3 +99,4 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
_


