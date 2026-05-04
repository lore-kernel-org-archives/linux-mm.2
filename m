Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB31CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC936B0092; Mon,  4 May 2026 03:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8D076B0093; Mon,  4 May 2026 03:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA33D6B0095; Mon,  4 May 2026 03:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6AD06B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:59:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E29A02DA
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:59:48 +0000 (UTC)
X-FDA: 84728988456.20.77FBDFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E636EC0008
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:59:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xp0I8n21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a48jOUPz7lxJq2XxF0vY9r44Z05P+JTHRHKeKNn1zXw=;
	b=1cFTEiknF0QwVGjDFgoGpHycOOp0awE7pTj3t+Y8I9jxHmh61eNBGWgAzx/CGQJC4oYEsI
	WEsr9eVg2Xq0W3Ll+I8GB+m5wnIjam/hNBJVjWPYOvDNAtTOtPEP+wk9Xku7z0n+s7AcSq
	OLiYk64nXAx9/IyIasi5cXZcq3Qz34M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881586; a=rsa-sha256;
	cv=none;
	b=zCMiVaq/Wa/bj96yLvG0vnVtMKGGeW2quATlfi1e1vpBPDJHWeXjtbVcS+Y6sxPp0NNzdR
	6LUKdVqFkglpGbRTVuig5j3E4Eg+QCqb62MRVb33QJDh9WP7ydE1aUQ5oLaJrAt3oR5iwn
	oQeEfp3RCtddhBFMF4jN5redOXaMX4I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xp0I8n21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C1C3600C3;
	Mon,  4 May 2026 07:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5E5C2BCB8;
	Mon,  4 May 2026 07:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881586;
	bh=Z0FyTKWUyHMmgU1F1HDPTlLvaTh3LvI2R4javIhne/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xp0I8n21lr/oh/1fyZjtCkraLJGJfkjbkamlq8icE+MNyykgTJm8mK+cCtsG9Su31
	 IViW5lB/u491Dwd9UKoLItqOts9bb6WPZiBaU5iYUt9GM/pzIUVM/LKy1qhY0Qk4ql
	 NjrmnqCF0tcZewXQenlKO9rbPWp/hz0JwbRnvR3Hld4yuKTmzTvLfzbsq6U0//I1KJ
	 Eh7jhQCsOwYfCsb8rLFpnQu+VHhIHUPz5hVPXpNSXi0VjZLBOKtHBAFVHYKeXdxoPg
	 dzU7ijHO8/ZH2GCO0gLWnU/O7U+Cu682DdgAbvCSPM+Eb/XUbP5RSLtcc0VnOwr3pE
	 FgRwhLWt7Kp0w==
Date: Mon, 4 May 2026 09:59:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 03/14] mm: rename uffd-wp PTE accessors to uffd
Message-ID: <afhR6VvypoFQqDzL@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-4-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-4-kas@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E636EC0008
X-Stat-Signature: 4a3z6gn1gue6ckm4iayb786rkht9zezk
X-Rspam-User: 
X-HE-Tag: 1777881586-267529
X-HE-Meta: U2FsdGVkX1+nGTNbP59sG+71gVL5pFZaks+SysA5QRGQFO64/HbWnp8b9MmOhX/5z2MEW7HumKiLfoI5p7TItkJ6l6/iVFQjEQ+PR8OeMsBHcjTnHl/4L0YRkk0/CV7bGNaaeGBqXEfQM28hzKFdHvX1oyvLtIVSqWzWtobO2RophxK8HMRKBYy3uhYhjAv1BRfEGnN6rbGpwqiNCjCvyFe2a+uJnlasUKAx0d+G12YIsnZDU7LeQyc2yWakFlQo6p+y68uF+5gbDKHTnoLHPHUXkakndt2WXbMrIbg6w4viqBLzAe+T9IhN3cfFmj4dWb7Dz2w1GG7D7kE+3/Wrp/N4Au5BhmjppFgdVe/2XOo5NM2EXNK0N/gYAJoOTk5gElG4REp7w3L2iwmHxMrQn7+BupKft+B0t+U1Nqeo+SYFScVb9h/OagqivQ4DMMzwp0B6XebZW3W8faYgQwn5rZ1carbvoQ3OLCuEWcLAqOOWW3lr23pH9r+1gotO8NoWySZHnlZ4ROZzvxKMwmscUO0MmL9ZazbSsfKraRRj1aRgMDaFuqc0HUxsn4nVsR8MK+1MjLjKa836zarTxQ7FLSibyrCxlCml+Utv1VtanynLCpMvNOCyB2n7AbZM98sdDcUWoG7IgxHXaymY4PKyYrYTkQ9CIeeZOVD9iyYHfq4Ldc1Q3l7pJvAsnFAFf0/S4fBOQkp3hoflFhlFXB0Cq0+7Wb9Rrw+DZ4V6i0SqEDl3kXrO8g//kCCgGhdLl2iGWvRTjwVLPP1D1w8X918UawCM8qYcxjN0xus9hLvL10EuBeUdKn5TpmKDZ90gElm26RjfHkVhuI6+zHpF84bFIBmt1eL6yJ3faEMTA+k06/nLOE4rq8vPgb5CSFJfVgrI2MeRBbYJIQmJbDzlsMFDu/CQPlWRYlIBGQZLz8NiwsI81gCPxx99uzEeOKc5i6TNoDSr9MiDVFpANaegibt
 RNDdNMHA
 1pV0AtZq5vQO9iVZdBNsUUKnRN4NF86to3dgjX18QdvlflCW2IhJhxGwMeUuOWNkYeh5leGFuJ7obU6iq+IQlbidT5K7lWHbaL8S9EdQE+8J2Sin6VQkrFvOuFn3vEXkFvgWCs5AaqcQEJvHM1POsejeBx8Huahx+RSZntAXincO/dRpxzkiSFo5pRKQAYcI7ynXRG2bZW6+0XkEginHlwONGPNA31kcfyzYJLNuNRbElOCLkZFWD0paBHsIC7iqIlrGW75lrKPJ/B/oQ2tiVNbQpo1ytH4AOv54pOfrG7wzZXLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 12:45:51PM +0100, Kiryl Shutsemau (Meta) wrote:
> Userfaultfd RWP will reuse the uffd-wp PTE bit to mark access-tracking
> PTEs, alongside the write-protected ones it already marks. The bit's
> meaning now depends on the VMA flag (WP or RWP), not on its name.
> 
> Rename the kernel-internal names that describe the bit:
> 
>   - pte/pmd/huge_pte accessors (and swap variants)
>   - pgtable_supports_uffd() capability query
>   - SCAN_PTE_UFFD khugepaged enum
> 
> The ftrace string emitted by mm_khugepaged_scan_pmd for this enum is
> kept as "pte_uffd_wp" so existing trace-based tooling keeps matching.
> 
> Pure mechanical rename -- no behavior change.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

