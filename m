Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF213CC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8629C6B009F; Thu, 15 Oct 2026 00:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AA26B00A0; Thu, 15 Oct 2026 00:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778116B00A1; Thu, 15 Oct 2026 00:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44E506B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:48:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFBB2404CE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:48:21 +0000 (UTC)
X-FDA: 85323629202.06.57D46E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2144A0007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:48:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGDqoKhF;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HMD5RchpGYsY0pRtaAyq/WdqXxarGhJNj4S4UKCbr4=;
	b=RcqWLNsShdq0qu/RWX2g5QUTJcKE6TZKlvSkzhyCxmNRQ3oeP6lGg5Xst7lA3AZ50zvW+v
	wI59LIBiKskeJ+XsLecrAFXnOdfXcR5nnx68i9SolrB296+R19yZN13vge0s//6ZSH3TZ8
	GTBopT19srCHRxNCeZAx7GMZjP+7UyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039699;
	b=y9zd2csHkWwWhHmLX+Eybkesm8L57tKl39gYhz4OPfsZJeWG53zoTGWSnkqJtj1ux6Ztoz
	SghbOON4JNEXLbOJ6VnuzYEhsi+Tq1+k8nC6/rcxTZhR/aD6LK/Dr0y9TjshrTbkl992yc
	xnLflRImtobOSlwIPdPkRZ3Kw0tGbUM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGDqoKhF;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4179843912;
	Thu, 15 Oct 2026 04:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245AA1F000C5;
	Thu, 15 Oct 2026 04:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792039698;
	bh=6HMD5RchpGYsY0pRtaAyq/WdqXxarGhJNj4S4UKCbr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UGDqoKhFmdLWTU9OhCOSgo50nsXn0YVZhp/FbpZFeGwBctn7pug8HGkZTqeWCHxKm
	 xa1D3TEmpneVhIx2+Tero6MKORL1GupO/dubvGXy1VoKjMwzvK2MvSD2b2QdTPCoJo
	 HMlkkrZpOYmWT7HaUxU40aj2i2v5oNxrJMIoLOIBX1nEryVdK6Prp0OqWTT8+zstpv
	 Oy5z+HqMzwBby7BZ/BQAKoG5/ufi3sd0q2ELjLDilfW/yu7twZrn0CojcTU+1260Yw
	 SukxQDVaUQbjhVWRDBClFV/eYpYEJoP9aBsyZEIVVDVbENaEcTvTp0yiJRGwsy0/pi
	 +DECelzbkKd4A==
Date: Wed, 14 Oct 2026 21:48:17 -0700
From: Kees Cook <kees@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Paul Burton <paulburton@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf: return the real error when program headers
 cannot be loaded
Message-ID: <202610142140.D483AE26DF@keescook>
References: <20261014-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v1-1-f39c74d55e42@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v1-1-f39c74d55e42@virtuozzo.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2144A0007
X-Stat-Signature: jucwrhzpiazngwc8t1ym775h63t7d1py
X-HE-Tag: 1792039698-917267
X-HE-Meta: U2FsdGVkX1/QspEiInqQyY9mBssuOuYk0CIkpw8tg1zAJ5uLIeRFZYtbU7WUIApkg880T9ohS58OyjN+ROudwb0taLqOn3dEUtiXhLi9Ki7aA5LjJsnHVVyAKYN5vrFs7u9EBbm8+zlrPp3BLf0jqVEWuyQPvh8/2lmAt6YtQSL8iuJmGLySaKOEMf67tp0Emj3Im6e8SISRr/85UMRDDJpFkVjnDbHTiJBDoyTWPd/e5iO3yU1iBrnPJBZlaKhVf556qpjdPeL7GDQ7x6PgUUejvFnv8jSoxtYYwCDH370ktuJluHdizxeiojCNDWs0NfvMuNcGb2Yl7t7US+dSlZQRrU0aALHZeJqOQgnzfggCd+s9qSXxnyS5BfsHajTOq4hKIwE+Yw7RopSrhyWQ8rmXR9yko5v/HrjZ/uKddutMlpu9DvSxOnVjr7gChF6Nduwo1fEbECziAV7VkdiyPr7uqpJ38nwgEsNTZ65ky21T5QDJ1dYq8PgE6m77DvFu5qjmuJULLPsgZoCF6A8fuIYADqZCjmKy6vI6agMO3nAJ8u2l4Tvr1//1UmV++Xcef5ahmIhyWSUK7GIzfUg7RKxEgapzdaXI0jUUoyKT/lfcMMx1MisTJ4+7/YNgZla+6tGkId+5VlZK+7uL2VbYN60iagfI5ZUVRlp6pesGRQNjufMrSVjPUVn7FQiXrVJDUp2DV/Zes0HuHy83vbIsjukPc1SiIWdxAHM6NjftKhi4ACnUVTtcS+XFpXUEuBJMoDcQkZHVG9ApfbU4375OvWspOB3TGN3qVNAiNHGAkigF78jQutBj8BC7IqrF4B0Sv7odGWN3ifTSbCbjUJPWAhk61cY0x5YAuwiP5CIS11QwMTCGND0azDzXPnukuAM/ihlO6/3KUuZCkR5n45TsdoZU8RmQt1IOyqGZv0jUr0tnlpM2H3LKbsD1qmz7C8cJvR+AOXkmfYeOtCdNF8q
 trBcdsO+
 un1Xp9wkzgdBsdmtM107CGHDQ/R3sgRdyiVMCHx3ellv0nFx4Sh0qC5kyOzSX/Jdv21+TPzGIszDzPMmZyBT/G+fkCqFF9DllIdpJsacwpmKybq50OtnXQcHmLa14j2tr88dMBspiu+h2ZhD1Mt0BTPKcoCPixwJ1tHUZYSYgegNxuu5CmFufLPaDV/u2HyAMrixAPH3upinENWfDleeoielrKYC8ouHyT0DFHJrH9BLCEZn4RrA+Np3PhJzoCHNI2ROnTjAAJV4M+4G88HNcduFPuSuu/hlsforKYsYLYppI/5wheaXVLgK0rvJMnnlIFZ7dNTW1I7L71XCssvxrRGCzKFhNjksT7lXJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 02:30:33PM +0200, Konstantin Khorenko wrote:
> Problem
> =======
> 
> load_elf_phdrs() returns NULL on any failure, and load_elf_binary()
> turns that into a fixed error: -ENOEXEC for the executable, -ELIBBAD
> for its interpreter. The real cause is lost:
> 
>   cause                                  really      execve() returns
>   -------------------------------------  ----------  ----------------
>   bad e_phentsize, e_phnum 0 or too big  bad file    ENOEXEC (right)
>   file ends before the header table      bad file    ENOEXEC (right)
>   kmalloc() of the table fails           ENOMEM      ENOEXEC (wrong)
>   kernel_read() fails                    EIO/ENOMEM  ENOEXEC (wrong)
> 
> For the interpreter every row gives ELIBBAD.
> 
> Consequences
> ============
> 
> ENOEXEC says the file is not an executable, which is a property of the
> file, not a transient failure:
> 
> - glibc's execvp() and execlp() take ENOEXEC as "not a binary" and run
>   the ELF file with /bin/sh, which reports a binary it cannot execute
>   instead of the ENOMEM or EIO.
> - search_binary_handler() tries the next binary format instead of
>   returning the error.

Isn't that what we want? If one handler can't load it, move on to find
one that does.

> - For the interpreter the caller gets ELIBBAD, "Accessing a corrupted
>   shared library", about an ld.so that is fine.
> - A caller that would retry on ENOMEM or report EIO gives up on the
>   file instead.
> 
> When it happens
> ===============
> 
> - The allocation fails under fault injection. Since commit
>   8030790477e8 ("binfmt_elf: remove the 4k limitation of program header
>   size") the table may be up to 64K; above 32K that is an order-4
>   allocation on 4K-page kernels, which can fail on a fragmented system.

I would not want to risk changing established userspace error message
interactions to make fault injection happy.

> - The read fails with an I/O error, or with -ENOMEM when the page cache
>   cannot take the pages.

This is kind of a bad failure case -- I don't think the "right" error
code is going to help much there. ;)

> 
> Where it came from
> ==================
> 
> - Until commit 6a8d38945cf4 ("binfmt_elf: Hoist ELF program header
>   loading to a function") load_elf_binary() returned -ENOMEM and the
>   read error. That commit documented an ERR_PTR return but returned
>   NULL; commit cfc46ca4fdca later fixed the comment, not the code.
> - Commit a9d9ef133f44 ("binfmt_elf: load interpreter program headers
>   earlier") gave the interpreter's headers the same NULL check, and with
>   it -ELIBBAD.

So it's been like this for 12 years? :)

> [...]
>   kernel                errors returned by execve()
>   7.3-rc7               ENOMEM 17, ENOEXEC 1, ELIBBAD 1, E2BIG 2
>   7.3-rc7 + this patch  ENOMEM 19, E2BIG 2

... so there are _fewer_ distinct failure codes with the patch?

> +	/*
> +	 * Read in the program headers. A read that fails part way returns
> +	 * what it got, so read on to see the error or the end of the file.
> +	 */
> +	pos = elf_ex->e_phoff;
> +	for (done = 0; done < size; done += rv) {
> +		rv = kernel_read(elf_file, (char *)elf_phdata + done,
> +				 size - done, &pos);
> +		if (rv <= 0) {
> +			kfree(elf_phdata);
> +			return ERR_PTR(rv ? rv : -ENOEXEC);
> +		}
>  	}

This is a behavioral change mixed into the errno handling change to
support partial reads??

I could be convinced that errnos need to be fixed, but the rationale
here doesn't really make me think it's worth potential disruption to
userspace. I'd need a pretty comprehensive survey of what would change
there and then a clean patch that made zero other behavior changes...

-Kees

-- 
Kees Cook

