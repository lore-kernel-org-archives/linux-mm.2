Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F228606A337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bABADEyK
Received: by kanga.kvack.org (Postfix)
	id 6AB306B00EF; Wed,  4 Nov 2026 09:25:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BF36B05B1; Wed,  4 Nov 2026 09:25:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574D96B05B2; Wed,  4 Nov 2026 09:25:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3816B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:25:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C378116076E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:15 +0000 (UTC)
X-FDA: 85397658990.23.D16132F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31E40A000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:25:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bABADEyK;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793802314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZW6BR9vwrayTNKI8W7w9kReBz4l5H0o0D9sCFw8bAc=;
	b=nBcLrxMh9fXjSvlEIEsKKHogK/ReFtJXLeHZRcaK/xHnHwZR9kgWczzmHiW80vFAUwJINZ
	phsZdY+ZmF+mDMnyYVIvM0aO7xpGnGLPSXAvUrYQtIJo4EtPJUm9DICFoJQrmhlR14KB9K
	0QIah0o+VKGigHFTTSAj+B9SKyiOPVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793802314;
	b=4T6TD0Rk0egdddQUMujoC2AaiM0Sc2vBnckH0aCMEP5CVTy32b7sDzLWebue1Hv28HkiKc
	ItAMVEQleyONWUPmWHsv6hstzvXaTdqzCtpBLX2HL6SDgN+7ePYXiU50QiEyP2mqjX9NL9
	Zlb13xLh8Ivkio4NGvmmObBWo9s/b5g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bABADEyK;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58D0C43C9D;
	Wed,  4 Nov 2026 14:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BA41F00A16;
	Wed,  4 Nov 2026 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802313;
	bh=tZW6BR9vwrayTNKI8W7w9kReBz4l5H0o0D9sCFw8bAc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bABADEyKkYq/reQcFV5A5OykrD/wWoqqHZBgx0Szo9PbBI5tzJy/dZXWQvg2Znfqm
	 cflloeK9kR25Chxa9tAsmFgj+p+k0cCGvh3/9RCbOAIRfiMoBg7EGjsH3X9JOYfr0+
	 yB+9+dDSJ1ZQI3jInQk7zdTkXpXVaU8vJWJe0H7ejwtozZVFoDQhacUZ4b493LVl7I
	 xURyeQf86+6Ec2VztQ7g4gywOAqevw/7/AmnYzAf7L6+eI8HtmQldkvLL1NwOMI1l4
	 47C2WZk92rcr8F55j+CCG0lHXt8qLf0kk/seS/g7cjgwDMFgFgN/hka9xRHjt8LFvK
	 6ctdlGadIMgMA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 04/10] mm: Rename memfd_luo to shmem_luo
In-Reply-To: <20261103010216.3447716-5-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:10 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-5-dmatlack@google.com>
Date: Wed, 04 Nov 2026 15:25:08 +0100
Message-ID: <2vxzqzh0k723.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: f38fy1keqbzx3wm6xb66bpnuiscekwgc
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 31E40A000B
X-Rspam-User: 
X-HE-Tag: 1793802314-860327
X-HE-Meta: U2FsdGVkX1/qacxihKOEn68U7R/K+oZwFGRXgYoUdMa5SwlCZ/Ph0kzme+4GjYzrU8IeYotuKYm/PTLsVX2ZRLYXHL5kIR6/be1IbbvOBw9AwGNxEksC6NNgQwkil1kotaZHb5JUYVetyrRiz0xCpiPBymx3d0WMpido0+fQU7JODnkew54JASn9evjhHzozIDBYvNqd/pCIZ/R9S6EFSxXLZv3ppkbqch7GWrOXmiH3xHxk4tyjLhNczlgRrxUo/S0bieG+D2A+EAP2RWmcIpii24dOZg0TTaWBCTlvDV5BG4VjauRKrZgsOGkynl1wTqvBCYtGUFg+Nf5ZnLR6QLh6qRMFYEKl77aE0P9sFiNcG25Gaw1PBxzsPU6FIvyDQl4jZVL8uqeltcc/AICwlvcjwmubqRvB1/BGkDzcrucdOHpm6WaCRxOfRASL1PJIIh+0lDExZEknPlGKCmw6I5x5OP4U/iZyM5Eg4R1nS8py7ESJoJIQoC+LS85oS99Sy0s78Ntp4jQqppQAZW9vHVCCQHVfMJZ4AWJupG6HyozMYM6g2o62hi517ktWn14kr1DGP2wwhNKUo8QkYasElZ2zInPxJAkAnjq0Lh28RJ0Z1rxRswoPOi+d9KCnIKcFFdsDcaB/BZP+N7yH2ZuWz3C2FjJMAQgEgdGLeHnVIPkiYtyny8DFrpFqQJlKbiGwgDZVs1G2sMvgqMVRzDL+vCavKbGiO4gwZuoluoynmSpCF55gC9abwvTe9lQcVMf8V53vvsFFWAu552Wtl1IpWm8plsKqFTwXre9O8gVFfwH3k+PdlHpimeBqFU0G9w5avLpGRU8aY5lUlXWlVNsAi1pDeIYqRAC7dskp9clAqZwtb7ec2Bs48SB6Xs4clTtlI5ikQhDzApIfkvv+cWLCkzHut5lXAqES3HGxGtUG4zPq9IsduDqelM7Egw4+AfkteZZTADbbO2JjEGsBq4w
 DC1cVLGo
 /J5CvEwFK+kPQRmVGnqtuMct5WIv4lJesriquvLMBxHUMK7mtOqX0+lqHK85V+d6IPHmhxcGvmtgvQvZaT+Q4GTcpOYcVrRDOtRxYgguhakniwNfMv+4vF/UGCGePh4JG+C/cv5PvSwMtnqmPzvcPxKoIwXvzXGZ8r/5lX2e5LjdIDVNbXBRSoRE5r+/DhSwV1bEXUnybrYoVs/QGRmRblLVpaioX42D/9WpxkITIRDuind/x+SajmVwV/flver7j/elZdk6fvzsgi0hymg6jExfaF22o5lERssPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> Rename the memfd Live Update file handler from memfd_luo to shmem_luo,
> including the source file, its KHO ABI header, its documentation and its
> Kconfig option (CONFIG_LIVEUPDATE_MEMFD to CONFIG_LIVEUPDATE_SHMEM).
>
> The handler preserves shmem files. Today those are memfds, but following
> commits extend it to other files on tmpfs mounts, for which the memfd
> name is confusing. Preserving memfds created with MFD_HUGETLB, which are
> hugetlbfs files, will need a separate handler, so naming the handler
> after the filesystem that backs the files also avoids having to rename
> it again then.
>
> Don't change the compatible string of the handler, "memfd-v2". It is
> matched against the preserved state from the previous kernel, so
> changing it would break live updates from kernels that use the old
> name. The serialized format doesn't change either.
>
> Also clarify in the documentation that memfd means a memfd created
> without MFD_HUGETLB, and name the ABI documentation after the handler.
>
> No functional change intended.
>
[...]
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index f50daee8eff0..9a1c49e2e0c4 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -69,7 +69,7 @@ config LIVEUPDATE
>  
>  	  If unsure, say N.
>  
> -config LIVEUPDATE_MEMFD
> +config LIVEUPDATE_SHMEM

Update the description too?

LGTM otherwise.

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>

>  	bool "Live update support for memfd"
>  	depends on LIVEUPDATE
>  	depends on MEMFD_CREATE
[...]

-- 
Regards,
Pratyush Yadav

