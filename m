Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC84EC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B48C6B00B1; Thu, 23 Jul 2026 00:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CBA6B00B3; Thu, 23 Jul 2026 00:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8F06B00B4; Thu, 23 Jul 2026 00:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638786B00B1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:13:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D18C4140390
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:13:58 +0000 (UTC)
X-FDA: 85018723356.04.E3293D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3861FC0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:13:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhZSE7yH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784780037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55r2jdYA/SkKLM/8vqOGXlubvKDhhxQcpWdG8gkoyKk=;
	b=kuShVBv4FOMPJlo51+WN8ecD1WLAJy6wU6qN1+Tw0IknPaarU3/hoY8TQ7IHsm1ZwVC5hf
	oBMkkpRnIPJXKQrYTQngXzbHowEuBlM0RSHUZAY0V8NOaPeBlxPspi7C+rKtkz5bT4saPl
	gY89xJv9YEnoqvApwFwnXKKdhUmRVcA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhZSE7yH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784780037;
	b=Vvv6lN457UwbiggvwWcEGGwqY9oQ41pBprDzcRMLYxDxdIwxVfNnxHyWbTQfHn8Do/KECN
	QBR0glw4S7Yirui/Go8tHGHLZGhoKYcNkgyhHYyItCBsB7l7EJSR4HO/X0icnssfli2W85
	pghJXV1wpxb7p5BrtTV/sS0cTCp8ABs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0CFF41828;
	Thu, 23 Jul 2026 04:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20801F00A3A;
	Thu, 23 Jul 2026 04:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784780035;
	bh=55r2jdYA/SkKLM/8vqOGXlubvKDhhxQcpWdG8gkoyKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BhZSE7yHUgDomiz+2djVk4t5uNNsaCugIoUpoce9e9H8F6//1g/jLEnqX8j1Gsq/u
	 OxDz7p3JmYGF330nkzQpFP0oTqkefx2WBNIb6/3LHwvhyGG4HaCUUq6u1+TEgGm0r3
	 OZ7xHz8OrFWyC6t4dJ2NgazgQVfCvfQihdn7O3WzBjEQfPTJw6TuiTlvjw4FwK9EU4
	 jRugM9iw8m292gycZGlixtzxnqiXQ8ytxLH3GHtH90kL9IxguXbi2COuJrm3YmQ0nK
	 s9ume+GNfTh9v2PgyzINhjxuC0ycvXiDJDOWQM3T/E4JZ2FofYoyh1y2OjbJa69DlE
	 gBv6NdK/lhIPA==
Date: Wed, 22 Jul 2026 21:13:53 -0700
From: Kees Cook <kees@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me,
	stable@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
Message-ID: <202607222110.D5AB43796@keescook>
References: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3861FC0002
X-Rspam-User: 
X-Stat-Signature: iakuzm9jqd8ofxe8eeskjcfyq5bgwoum
X-HE-Tag: 1784780037-788286
X-HE-Meta: U2FsdGVkX18avEEswsdIotLMrDxwvYz3CPd3x3E3EEiOZ+0ENNEX7TNSsjI1eLfP2AiSx39BSYPAjhIEucTYWD8xT1DovdKLfKuKAMRF7TFb0IjchLvISf5bUD2SkrKYBB+loNNZsr4qUWEMObj5g2twzmb5dBIJG6KYrelbfEgIvWVJ7pB6ZSd7CypMFcpKKQa+xwzRvTwJFc78hkXla0RCfFqxIoFIvRcwwmLqF06bXj+NmplSDZShszXp/HC/5FuRPB9y2KFsjaLwRUF/+fvypy2qkQ//EljepUwlvXySGZmraF4VcpYj7BWArmQD5H+vaN5cZaWGUO9YUmI2fE/lbiLgri6KB2glbrhAbL+3P67+PLrtZYlzAQOVhc5gf82mPsLL+mjYB8mLLiQBp1sm9BwtaRI5CifRxY4z3zUcqg/EGAVy6NGFAgsa8V00DnfF6edW4m071SfUO5iXJnGNnlZXJ3NfRD37vUhjH8MKJycvEerDE8Pm6qTdOWvNcQeP6DrszNv6NI9eOlqQbGiETNRCLRE1RUzkn0F9QHQk1ic0yeKolDvbRyZL/X2ovqhvfl0VpXueDko32pVHnFOyUVBj61cE7cCJ62+cpzxA9rinZk1nKBi0RYE5KCzj+GHLbuxg9sBuoJlqhDWHgqz//oRdO0WYsiE+H1GeApoNo+lELoS9Xk+akgirX7mNpCIYmWc47Dc+ubhLJsEi2SCp+RM5mOO4CGa8SWq5olffPiFLnr73D/SwBYZXGWAJyuPrvimKi4/QuAJXYjLXgldUzePq+gfa3y+EZJzfr7a7Ad+a8YIIPMFynWG06jfryZ/DdiBlyllCNsX6nOZLj23D2bVWVG3TUfu8yyiPz4E/SBz7/nWjIcIGyuktf8/KNwlqyZOO/M1LU2i/MuX3SBSKmxsm3yP69PAiRD7uTKxVbm9nZbch0uw4F9aHAwFeMfBXNJh7zvlWdEc5EJx
 1q3zmX61
 5SdSdgICjQntJN/Yj2VBSqTYm1K+xKstysZ0jA/+lUCfKn75hEAjAdc9JJhlLYA1vwVuos6c+YcY9KW5rm3ddsYHZb5dRfCOmyiV8VpH+pu+xRslbw6NsKx0gEuCiXlAqJkHominrzMy6nZbI+jNHHL7NYJZkoCkacz261Tp2/6l5borTB6WJsE3KTFhWo31xivHyrIbKtysBdpXphi9RSHlwb0g1yXNB3fqUnVT0rYDMHnosSPs9KwWCEihYHobGOiuaXEI6e4Vh3046mFnnmlrwzM90mUpWgE7ccvXAyhQFLmf+HabTCq5BNBcDwK8TOtuXoI+SbdIc6jRDLNrhf+1nU7X2p/g6o0tyPln4opWXR69i41oIXuAL44hPAvE1FWFjWHJmnHZfP3ZgE62h6ZkjNP4W5RXZoDVx05szQvxWv2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 01:20:45PM +0200, Christian Brauner wrote:
> The program header scan handles PT_INTERP from a switch nested in the
> scan loop, so its break leaves the switch and not the loop. A binary
> carrying more than one PT_INTERP runs the case again and overwrites both
> interpreter_name and interpreter. The previous name allocation leaks and
> so does the previous interpreter reference, along with the write denial
> open_exec() took on it. The denial is never released, so the file stays
> unwritable for as long as the system runs.
> 
> An unprivileged caller reaches this with a crafted binary and repeats it
> at will. binfmt_elf stops at the first PT_INTERP. Do the same here.

binfmt_elf ignores all the other PT_INTERPs, which is what you've done
here too, but I wonder if it might be reasonable to refuse to load such
a binary?

> 
> The flaw dates back to the driver's introduction in the pre-git history
> tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
> binary format driver").
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_elf_fdpic.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 7e3108489c83..fe0b5c5ed2bc 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -231,6 +231,10 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>  	for (i = 0; i < exec_params.hdr.e_phnum; i++, phdr++) {
>  		switch (phdr->p_type) {
>  		case PT_INTERP:
> +			/* elf ABI allows only one interpreter */
> +			if (interpreter_name)
> +				continue;
> +
>  			retval = -ENOMEM;
>  			if (phdr->p_filesz > PATH_MAX)
>  				goto error;
> -- 
> 2.53.0
> 

-- 
Kees Cook

