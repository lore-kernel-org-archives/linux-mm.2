Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6E3606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eERIy1vE
Received: by kanga.kvack.org (Postfix)
	id 26C226B05B2; Fri, 27 Nov 2026 15:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C2A6B05B3; Fri, 27 Nov 2026 15:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4D36B05B4; Fri, 27 Nov 2026 15:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81FAD6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:44:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09CA6C0500
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:44:32 +0000 (UTC)
X-FDA: 85482077184.10.286F484
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DB4018000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:44:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eERIy1vE;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795812270;
	b=3mGp2l2fSp6WAwgs7GrQwKyDmA2q+AkWYYUVVut53wDda6L80uWQzOYRjn9GDLjmhOPnkN
	AyQve1ngi+NbDr7C1VGG1VtbKwm2Q5UxhmEDUShCeGlQZcnjSkOvifi/hbm1Py1Vhf6P3g
	y21ak6eedLarn8WgGJrn5wzDJp1X6jI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795812270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/swzqNGNmYuC5KRwnzcnyJMdoU0gvWeuJZ2tEFBhOE=;
	b=4oyWTdF4l+O40GYlHfXOoz0XSuw8J2Ojj/r5IN3x9QVhm6gXIDSQcsBPy9UDU9bsTPiI2x
	rqjQluDlkOw3sjehw7Q9dpxClv5dCim7gLKDNeVhTwONSX2hi3R29tF8tbHA57bh2TD8+q
	mfoa6bfSSf9YAjO1xBOnB2HHqgx29rM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eERIy1vE;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A84E760F84;
	Fri, 27 Nov 2026 20:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7726B1F00897;
	Fri, 27 Nov 2026 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795812269;
	bh=o/swzqNGNmYuC5KRwnzcnyJMdoU0gvWeuJZ2tEFBhOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eERIy1vEAuHl7drCdBRsEp5kZq16eNRHi1Znb68bBftcZHzAw3uhQEIJObhIhPoKg
	 ViohHCGLbOKq8ealKgmimbgzfyTgnn0ujE6pn3m+JFgudk6oiJxdc6iuNzdAUjb1kM
	 VcSsHAxTsSDD/x54/W9vByspOjC8tmnC+uPdrwFc=
Date: Fri, 27 Nov 2026 12:44:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, David Rheinsberg
 <david@readahead.eu>, Hugh Dickins <hughd@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, David
 Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, Alex Shi
 <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pedro Falcato
 <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, Rik van Riel
 <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?=
 <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell
 <sfr@canb.auug.org.au>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 codalist@coda.cs.cmu.edu, linux-mm@kvack.org, Andrei Vagin
 <avagin@gmail.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason
 <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: never point a file's f_mapping at a
 container's mapping
Message-Id: <20261127124428.f1f66c6244d3e5c2811f56de@linux-foundation.org>
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
	<20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3DB4018000F
X-Stat-Signature: 4nn494mfrwci9bbxpufujctrdikhtj6w
X-Rspam-User:
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795812270-64690
X-HE-Meta: U2FsdGVkX18r6wCdPHRZ8yZLRMz1DYT2cpCH2ZymEsy5O5PHFvQvRcJWt6YisdqIBQKxxr3FkOLc44wNIMUXxoqV+pFc6HbfQU1s6JvHXuxyt9ELSPuPBdqTbuuqQIzYtF/h+7cUniaj31o0vb/6/eaifKArJR3C5zI3+UGLWH7MoCw/gYUFcwBeMFipkLCETXe+zMZuAWXtKG2pDYkvUfpzjEy2cNgQaLqnpml0cDtPsEAJ8zBpwPSmncGnJNz+FUdvLYEs9yb8VMYHniUOda3QPPUEi0Nlw0kTzQWCy0Ma2v7AUHGt909+KjC/JvKtLkwB0N1F/et6Dyp/zLlvtxn5XpxYWotnUuhV9MLS0Mn0A3R5Ias3/b6wBTXEYXsLiTOdfFSxLXsOwBL9LKZxjEpaokkoiKrnpAwxvElf0LpYa+YWyMpT3+/pVO40gbjvaD0/g3fs3W0iJgxXDroC1HB+H8v+7HjJlAi6PE55k0xd/uylPCMYuPW9xXg0wxGqrrJflQJweFSu44GxDJCpvBtnBkVmc+w2TrHxBbod+eBu6V74M+Md1FzsN2pt3zIqTvZFTL1KgFcR8OpSxOvxu8+iFOSAOlo2mN50x75UXRXqqCNtCGhZ1/lH2+bzU35CiMucxV9ZO1pfeP9BprAiIfJH/C1ERbvju7JUh5Cewi29JeypE8N5R0zjkD8SPCkUUuA7t9pCNEVjYm3WBK/rmTopezihekutsbO50grHfXKpACh8KwOca+RoiJWalZL/eHz6Bp+R7HwKe6AqZ/YQaFR4iOgOODMiPKhl2jnKdJPo59s4KYoLRIpod8YG9/OOeI1X1v7Afa6fXruaUCsyiH0S+Wn2bAhxp9M5AvHuqt42rrtZNj3Cq9eCEqTg1R1US5V6ggIJKqPig3cLhiCkm1ZoYubdjeElNipoDVa+cVwhQI21aHieRlW///mc6uV5sU7QI39JFu8trG7PU8X
 aZvHhYzR
 oxxmSJknQxOUJOgpGU7mrJwiT+P+6TTdCzxo3dpXoHRdllT98YzNkaNLR/iJGjX1iV409UOBUSRXYTpUCH7G6zu72sEKbx0Pbzqb84S1pjToksjvkHf7XViZoSGsszO/G29uH3b6oHKWP8BlpQsM1V4PjhVsryGGD7ws2z6iZ48gkD1QdL7B6XuxZtCadiMTYiuXHR4aUPPBALDG6podZf5C436DLlSa8VPE54e+nskDuGPOiNOb8fWsM8Rj+eLn1+dE0babHGPmsu2+FVExRiCZRbf7Og+CSz1f/zsbcZS6SIfgufVRJXgya9I3yBWcSW+B3dYg2RxQSmSCDfJnMPeLyLxizlczqgOdk+Ryt41k+NmmxvZOArGXrlf8IyWUgUjM4+o2xjUtBipC0FMnXGa/k2WXKgEcGQMlogJkEaO/XKktpmQBkTYs5dB8W0B1xDWL2NMKeBO3mcmqKPQoYLRoqIAQYz5Oq7S/kiQsaAkeaja5frvWxif5+Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 19:45:40 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Coda file systems stack differently from other stacked file systems.
> 
> On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
> the Coda file's f_mapping for the mapping of the container file. This
> causes two problems.
> 
> Firstly, the container file may not remain pinned, at which point this may
> result in a dangling reference in coda_file->f_mapping, and so a
> use-after-free in mmap() or lseek().
> 
> This can happen when you open the same inode across two files, mmap()'ing
> in one, which assigns the i_mapping, and open()'ing another, which assigns
> that i_mapping to the file's f_mapping, if the cache manager gave the two
> files different containers. Each file pins only its own container.

Yeah, I hit this while getting
tools/testing/selftests/mm/memory-failure.c to work on all Linux
filesystems.

> --- a/fs/coda/file.c
> +++ b/fs/coda/file.c
> @@ -182,7 +182,6 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
>  
>  	cii = ITOC(coda_inode);
>  	spin_lock(&cii->c_lock);
> -	coda_file->f_mapping = host_file->f_mapping;
>  	if (coda_inode->i_mapping == &coda_inode->i_data)
>  		coda_inode->i_mapping = host_inode->i_mapping;
>  

I had this change.

> @@ -248,6 +247,19 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
>  
>  	host_file->f_flags |= coda_file->f_flags & (O_APPEND | O_SYNC);
>  
> +	/*
> +	 * On mmap coda_inode->i_mapping is updated to point at the mapping of
> +	 * the mmap()'d file's container, and do_dentry_open() propagates that
> +	 * to coda_file->f_mapping.
> +	 *
> +	 * However coda_file's container may differ, in which case the lifetime
> +	 * of that mapping may not match that of coda_file.
> +	 *
> +	 * To avoid a dangling pointer, reassign the mapping to the canonical
> +	 * one.
> +	 */
> +	coda_file->f_mapping = &coda_inode->i_data;
> +
>  	cfi->cfi_magic = CODA_MAGIC;
>  	cfi->cfi_mapcount = 0;
>  	cfi->cfi_container = host_file;

But not this one.

Is it truly needed, or is it a future-safe defensive thing?

If the latter, Tested-by-me:.  If the former, Mostly-tested-by:me. 
Either way, Acked-by:me.


It's always seemed a big wart that file->f_mapping even exists.  We
should get that via file->f_inode->i_mapping!  But you-know-what tells
me that "/dev/mem sets the opened file's f_mapping to the shared
I/O-memory mapping; /proc/bus/pci does the same.  Their f_inode still
identifies the device or proc entry" so sigh.


