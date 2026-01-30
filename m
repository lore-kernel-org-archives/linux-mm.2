Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4F6E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 20:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FAE6B0088; Fri, 30 Jan 2026 15:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD806B0089; Fri, 30 Jan 2026 15:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF4A6B008A; Fri, 30 Jan 2026 15:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7E96B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:42:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A594BD4CDC
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:42:46 +0000 (UTC)
X-FDA: 84389803932.08.D232357
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 17E03140008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:42:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Eq0Qcprm;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769805765; a=rsa-sha256;
	cv=none;
	b=sd1b7I6UTKUixsGhPl05dndceHUj0eRGloN+Dd2BmfHq6MkD4G9wkoujA+BbEGPc3lPvlF
	WgLL/XUKlx6SRtW6SURNFk6VihTE8RYkzo15L2bcDvY2XiGKG3c9pZV5qHpBUdouTVW4DG
	qNgZywBxEciBHZqRHPaT68Y/EymHl4c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Eq0Qcprm;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769805765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgKTnkNigYfv0jMJ70ij5YJ9esHgeLHkOxGWSwjW0Vs=;
	b=DKgMHnusvLdXRF7SA7E1ub9dN6Ed3QOXMIRkPEfYvIylX8f/sYDvlS08plKjs96l1WJhdk
	0mR4zLpzGIZsK7obZgw1+7LZG+45WIqkPtZccGTk/K8ZzlRjBuPisD2vewIXkUz1nSoPxm
	nW33Lld7/XpZ57KdrVNUigsRTO3heEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 112B16001A;
	Fri, 30 Jan 2026 20:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B72C19425;
	Fri, 30 Jan 2026 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769805763;
	bh=5acVyiSSuCssIejlmfrh3fKAQZQppVE8lkLKa/y831c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Eq0Qcprms6/VkX+1256ZermHOg9SVd9qJhZc/I2iSMGx1+gw4cDc1F1K5Yosp7q/H
	 3m0Myxl9bT91huvQKHOGjXcEtB6kFJsn9/9j1XulQEgeE4iTWFtr3rpIkSD5TqVZvO
	 u8rU/YevMArmLiQrUcLmlqxZflJ8N289o4xipYK4=
Date: Fri, 30 Jan 2026 12:42:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Andrii Nakryiko <andrii@kernel.org>,
 linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com,
 shakeel.butt@linux.dev,
 syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
Message-Id: <20260130124242.dbb7946b3592ffddac7c316a@linux-foundation.org>
In-Reply-To: <CAEf4BzZthAONGByqvk3pHRT3GaA8=fNbz+d1V1CY1N8sHEcsjA@mail.gmail.com>
References: <20260129215340.3742283-1-andrii@kernel.org>
	<202601301121.zr5U6ixA-lkp@intel.com>
	<CAEf4BzZthAONGByqvk3pHRT3GaA8=fNbz+d1V1CY1N8sHEcsjA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 17E03140008
X-Stat-Signature: 3d1nt3ye7z7epch4mgzpnz4c1z1b8ddp
X-HE-Tag: 1769805764-480612
X-HE-Meta: U2FsdGVkX1+TQehjyHW5oSHdrJjPiKPbYKaxPPaSODykQWNCAIAFxgNUDddCVgsiQ7xpJNl65VLdp2GWD2EDFTSK46YgRgyZntrRzT0s0QKd8Q6jiFNTyp5kOQc7H+/Rir5lvUlYHH8I7qPgf8Mb4GhNpgfYYlVCFvWo8kbzAIKexZfhnwKPBzFqZYFUXliSkDsRRKTk88BxW3l5B1Bsw0WaaO+Hyq0LjfdgjOm2wC1P1hwZAt9l/+YT1IVZicnR0CWD88DOdsvJuOaM2P0vrOEs4SMXrWRBbqpP7LiQa9BlOR8XwYQgRjoSLtPcRW3ujMhSFoxxggwyhdO4Qs3bOTldAqInqajFRVRVHo8fnARBnbi4P2S/F57w2lxrIiEigeC2ZNNWdTUlzK6HQiO7IcNAk64/6prb2FqwrJ3vY2DjOID1mt6/2+liFgJ7HrP5dCiysBu+pJ6gGmiQOe1vsCYWL10OPajeGWGtonkaVLmI5nBmNIttW4zNHUTG+xv/oeqqa13bKqAtpz/usGOhOejxUa+9n/zTqaR5iZNTfe9AM9BYlVJG+IPyv8SfPnhItSmsqsM2nSw9EUob+I3mdVMlVfWYVqgE9txGcBOrsXA9uqq31+Ci4tE2ET/rVxtfKFbgwoIUmABQsFm4kAgtam02WkNvoleGKBvBvR0JvSvMbkO5ZKmMvZh82g0DFvJN5BjeR8LBLYoaS0AiZmUmA/ZChh8ADjWojsm/Sy622kuCyt4lYkVwph5iYCQxu5M7bI4eiENFg6pnAZtCyhnMlYJy65/ygQrd1JUsZJ2zkJvcLIxxKd32hYJEzkT/NyfKSg16kASM08wQ/1cz+zaLYA++eUtAPLCWZmgxfN/wdV7pdujH2g4dfJ+eUPk5g+ELdP+PUMLWVKdjE8WHsr6UXHL6WGYaYOeX9Z5mbnDxFEmVhx6SWfTwF7WzagUXR82YRlp0f8mhrc9ZLzlIHI8
 TrFDV86u
 KRFb5qa74pRY+F3fIFkQWmUEoX9crGZpdxpXNfQwMGK8xRmwFZzA8/uLi9S2ZLXDMQ2snRw7DzI8YNNG4JSDj2KhT7O+cpMxeiv7GPWEoMBd3dz3CKKY4KYoaBlcFLhLDu1MBfOzqL8E5Tef3xH5ce4Yb9CAL0/Bslmni9dP1dnrObgpuKEPo2sSKRfPN1VaqbiATfw3Uol+r6KRZBvlDEK+s3pc5c/E40r1mRDhoMyo7jCLuhRz5jWLgFLO0ENeGQlAcpMkXdVr2NnMPJv0ht7FP4uMEvbmHbXdcAUo0my+vzE9uk8/N+eDEvV9SEsSBrCJWkKiC8g3Pov5psyiJvLq0tK7+8lpeaSWWnxB62OlBnI7ZoKwrgZkQoPYdY+ODo6adv0ff2GCZyJquJoNNmo5cMPHESYkasGbH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 12:11:31 -0800 Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601301121.zr5U6ixA-lkp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> Warning: lib/buildid.c:348 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
> >     * Parse build ID of ELF file
> 
> So AI tells me to be a proper kernel-doc comment this should have been:
> 
> * build_id_parse_file() - Parse build ID of ELF file
> 
> Andrew, should I send v3 or you can just patch it up in-place? Thanks!

No probs.

The preceding two functions are trying to be kerneldoc but failed.  How
about this?


--- a/lib/buildid.c~procfs-avoid-fetching-build-id-while-holding-vma-lock-fix
+++ a/lib/buildid.c
@@ -315,8 +315,8 @@ out:
 	return ret;
 }
 
-/*
- * Parse build ID of ELF file mapped to vma
+/**
+ * build_id_parse_nofault() - Parse build ID of ELF file mapped to vma
  * @vma:      vma object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
@@ -334,8 +334,8 @@ int build_id_parse_nofault(struct vm_are
 	return __build_id_parse(vma->vm_file, build_id, size, false /* !may_fault */);
 }
 
-/*
- * Parse build ID of ELF file mapped to VMA
+/**
+ * build_id_parse() - Parse build ID of ELF file mapped to VMA
  * @vma:      vma object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
@@ -354,7 +354,7 @@ int build_id_parse(struct vm_area_struct
 }
 
 /**
- * Parse build ID of ELF file
+ * build_id_parse_file() - Parse build ID of ELF file
  * @file:      file object
  * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
  * @size:     returns actual build id size in case of success
_


