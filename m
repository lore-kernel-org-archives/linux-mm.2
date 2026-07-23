Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D617FC4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCC46B00A0; Wed, 22 Jul 2026 23:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A50F6B00A1; Wed, 22 Jul 2026 23:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594106B00A2; Wed, 22 Jul 2026 23:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6886B00A0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D6F14039A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:44 +0000 (UTC)
X-FDA: 85018669848.03.1D0A5AD
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B05B180007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fM3ZGNFO;
	spf=pass (imf24.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1PEBsBmBuzQnOjcMzNDPNdLnwh3q1jmxZTOFvMDrVc=;
	b=XJZ9Hy72KIA8rPIwD6G2QGqfNL6f0ZUiD8pjg6PA3/D+ntRipHj6KEa4KjpHeCSxFQzqHv
	pMCHcxV4B245L1ebj3MJ3A0qq6cOnxMhii9ePq1e3WKeE4jiD2wGQL2FOyLPSXHaM8zh5I
	ZGpP9uVwBSWuOreau29RiK0PQaXq0Mg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fM3ZGNFO;
	spf=pass (imf24.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778762;
	b=Xw900uK5N22ClxxFna6lge+yJEv3xnY8KpO5bnxsAzM7NhhPqTRBWZNIMJLN8YVX9Z6bbu
	RU5UMlZW1or27rihxBrpjaPmoGBlI7ylJGFvhc8tMLIn9b2edRcjGOUUfShZUVRXexcgdt
	0Qzmfz4UBqw6p25Y5Shhj/ppomE7BS0=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso175820a91.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778761; x=1785383561; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S1PEBsBmBuzQnOjcMzNDPNdLnwh3q1jmxZTOFvMDrVc=;
        b=fM3ZGNFOFykW9DdnJpbPV3NV2K8Mz7TgIEliZ4NxnkXUgY/oVYMEuxw3sm1d4COyIL
         Py7T8+ORrO62tN3iWD16Bi2bKAJEZNZCMlK5VZ/bB6z9v/Af0tUNDUVICPdh4TBeCMeR
         8tGvyRij9M2/K6MeQywpAAyn9xBYsSLi0hbijihlvUAW0fP+PhkvtJCF6dO7qPFEiRM2
         LPoliS1zgg8PUjQEto7Nk+u6uRrqY7rHqHBEKWfIgcizOiNdhWCXm/sWELIxeHX+P720
         UEDxbtlAcfYqKb+EGubFlM+9G2PoluTHIbfGYGveJhwA87lqOXNcazxDJgW/WupBddHT
         90HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778761; x=1785383561;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1PEBsBmBuzQnOjcMzNDPNdLnwh3q1jmxZTOFvMDrVc=;
        b=fmbGMZaCcIWXyZxCIuF5OKn+crb/J560+BT3c1uqItgeTIPLas4dhcwgdYWb1c83e5
         ZWH6XewzGCsM0PsqoqLtxCrhgqt2h9dyuVOijOqOe8BM23I+LaGpXBmXxtmJN++BeGfj
         ds+XXyUWNPTxV9YYDB5ZeU4a5e53vBI8RuCuLvFZ9eqAbnWtbJ+dedBwNn2tL33toOUo
         SmDCWgiwwEwIoOxfKhjGZU8bl0Fx9ffiH28Iks5cFoZbyNtqG0nBXQrL6rJ8Y+0Q8GOz
         g8s1Au+/lXATqUOFkFGWHjN6M20j7SIrayCgSoSRQp7eviC1ifvUkCT3o51GGbbxvgCw
         bAjw==
X-Forwarded-Encrypted: i=1; AHgh+RpETvtc6a6qAwFi+HnbyjhM1dh3VAlOv9xSCwGmwhqwtHLsK8BLueSeCG3T2IcsIaM5pZtk9rQm0w==@kvack.org
X-Gm-Message-State: AOJu0YwbHSdFCJEg/uift/Qk0KVvmkyYLBWTlGQLyT3VsZRwg1bSxs6i
	0Y7qXAQx1xeBup9jZrHXldegkz/GkK/ATL8mnSnA+6KBeFL8VR8Magy/
X-Gm-Gg: AR+sD10cI2HcRrF1cnFdGsgIAqDfWF7BqX0Ek2QWhZ72kHw3kvcab7jJNyJcYFaH3lr
	wKuXRU4ecApcTxwqw4fBTfLQJbQDHXoCUFcGaJ0xHtQp7tCZbuTO1Pg8Tfr5M9tw6pz55cQBUbo
	T2Au5m0lywjlrCRJoGGQtldqqvQoooxGlmtjj3nmHV9fNshsHs8ZCkfUqZnB0ZjpTC1eYmkxMUr
	/zzSBOTJ1c2qmIOozYwYYSztiWX96XTySsnwb7hQysFwdA0wsXAtRvsJJBlnbodHKzFPOVgPh91
	XdhMoQEXdHNJzaRbr3Ze5Vxy519xY0BLQDnKI9uvMyrEAk86iLJCok8NotY6QcFkgpAj8SDtTVU
	X3wD54rI804pvZJ2HQjKM1rbmlgbFTB+7eqYI1dPp86J3H2cR3Czbhj1k2AObojgfZ3DLrbdKwF
	vpeXOT6A==
X-Received: by 2002:a17:90b:3cc4:b0:38d:b36e:9813 with SMTP id 98e67ed59e1d1-38ec642941emr1497129a91.11.1784778761575;
        Wed, 22 Jul 2026 20:52:41 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:41 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/21] exec: release the replaced file with
 do_close_execat()
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-6-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-6-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872732.254289.8598325015704574885.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B05B180007
X-Stat-Signature: 9omcpqesgoc4k3c5cqdxiuxzpn5agusq
X-HE-Tag: 1784778762-574281
X-HE-Meta: U2FsdGVkX1/2c3UfaNX6vrI2ZhSS5yRtJ9Mt6mkmbmK/V4zOphD2jZb0ipzyb2m6Jef6NalDoDTWrLc/IPt3OK5o+wVc1Uw2AdwfZzC/cwvOJx1ldp6fM5HCjC40DwUHi9OO4UF4yEz12RRNR8YMPgY+ddmaiPl15py81o8DhYlGikuGMjUqJvOD5f7raUFUs/OV/lZn6nlFGX7XQmtmpsd3zSye792f7QYy+ZziWJ7xkb8+KZD6nLt5UW43qS6l1DFib5sMym3NcLKs8hincmW6nPGQeEErk0mHOHee65Kq/x0tgJ2nRQzdQLbsl1Zn4jORa06i0YnaaBxfC0Whw23BHfedErhIB1U711M35M2JZvkBuCMyktmmb4b00pP/C/DgJWDT6TBLoHMAHyy/kHBP+HvOy8F1Em0j5viZ1lWWbdl0t59wnbZ8HzIhrBeCbfQeQM8DRbXtuXaBEv4oMOmtbB0to+tDPEAV9SPp6xZCx/YjBwPzvrFOubVjSSI67SwnopuYjM9QI9rvKfd0lsqc1nwEQaXqS7rxkQbZEUMS+17kPuf2kzE6KrthWx8rvdWaESs7KDLajXZIYBkkfsX3ValTNacAuUeWgrGPdfjrbvpvv2UpwpSJfEoHQ5tOpCoJqwdJSpENAnfx9bNjjpax8M/44wmuagOG8bTy/KW1EBJDlDsI0afrbO+3s80lIOzXr99J5D35ULpLVELzMLVjaVS4BSxR3xqu2ur0NlgH7pXLGmmoNwKEkf1iWpUU0Nw46WcOz+jM+ZuP3lueR1B4fqjqWDUH6I/xkM625bI5fvvSc1nRDQIsrTZik+/id/nnBA8B0XyBj3Ki2DCO/8O5kAJz1RvEetgmHv/io3Hw1G6pH/XvV20GqMrx/mL98wFf8DZo8x7H3fs01q4D+zg0TiVyfpW3j1ANbYXetEjzWrBjOhRHam+YqVQ7Y202GVUakCH5zVtLkx2QOsI
 yP8bIBcT
 hkRfWPnd4bAYWm2qXNFuyKy0L6JLZaJ8ayphQbVgZmmv0S9qOir+cS2M7AU7Mhfa98f1i38bwtftxjwtIwTUey2T0RZjGDqNY1dhXIC4c6epnSa9Bqz9bTjnClVcRNw4x/NZuIi5RybfiBDZb2MQUjATPZkOiZnzGTTJ96ZwVwrqqbVdPbnLbrJf0uhXAC/DDzFQK869RfElX22PfCmvtr7K3owZS5n9eqYKsS0BRifeE/ScnBpKZ8z6oX6/+z1dET+3hRj5ZdK/737c71//IIara7Vl+IXa58t7BNj6jtXQKP++RV13ZXnRnphnF1LFJu+xQ0SahEWLGmbqpcajAojM2oe7WLXbFRQdyIDtn1qF3L1QApjIb/i5Ci5mhYiVjtWFWiDMuqWv0sgrol81D/ikD+qv2b+j3O8ptoppZhsdVhX3OnUcSpR7p59jkvuyYTBuXrAgVFaKTSsoV7PO5E8+VlWHBzFP3SCWS48e3LRwSZsssz1HIoI+BJyuqwBXgbbGLqu+YNJy9/CnANPA2E5SZrOm/Hu5gA5TtAQWi5oOnJPJ+BCzJ9eQ8wVFyJw0oM/On
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

# Add your code comments below. There is no need to trim or delete
# any existing content -- just insert your comments under the relevant
# lines of code. Lines starting with "> " are quoted diff context and
# lines starting with "| " are comments from other reviewers.
# The final email will be reformatted automatically to include only
# the sections that have your comments.
#
> When the format search stages an interpreter exec_binprm() swaps it
> in and releases the file it replaces. Dropping the write denial the
> open took is done manually ahead of both release paths. The one path
> that keeps the file silently relies on it not being called.
> 
> Let's just use do_close_execat() on the two paths that release the file
> and drop the denial explicitly on the one that does not.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 41e1684d9..061e0f9fb 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1735,15 +1735,17 @@ static int exec_binprm(struct linux_binprm *bprm)
>  		bprm->file = bprm->interpreter;
>  		bprm->interpreter = NULL;
>  
> -		exe_file_allow_write_access(exec);
>  		if (unlikely(bprm->have_execfd)) {
>  			if (bprm->executable) {
> -				fput(exec);
> +				do_close_execat(exec);
>  				return -ENOEXEC;
>  			}
> +			/* Only the reference is kept, for AT_EXECFD. */
> +			exe_file_allow_write_access(exec);
>  			bprm->executable = exec;
> -		} else
> -			fput(exec);
> +		} else {
> +			do_close_execat(exec);
> +		}
>  	}
>  
>  	audit_bprm(bprm);

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

