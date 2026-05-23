Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C3BCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 10:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47726B0092; Sat, 23 May 2026 06:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EBA6B0095; Sat, 23 May 2026 06:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34376B0096; Sat, 23 May 2026 06:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4FE6B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:31:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3040B40B39
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:31:06 +0000 (UTC)
X-FDA: 84798316932.26.B0745D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78592120009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 10:31:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFDM7ade;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779532264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32zkblvEReRXKUqpzQ/oX4QqJ1BPdQrr6JwVi3qqyLM=;
	b=ZdrtkS/tFtbZb+uTpBH1nkktHlPXZsV35pp9ytO/SITJp70YoXCsTqWmheu9mrmqqN8b2A
	x16Lcu3zmq9djLpSMg81YnyVW7P5P4yReIHe2c4pOXSvXGXSLxA1HxbpUp7qL2YRzhtr02
	gEGd8naA/Tzfzp4TtBWajQ5OILMjbxQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFDM7ade;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779532264; a=rsa-sha256;
	cv=none;
	b=SSd5OGuyZSVPC6mGlheEaLuJb4tZLkjTXbr+NHVrKSJJZ684G/2llg1zYSELyNTuSPw8U7
	0VueOQihh5B/WLQOPisLcIEhFRgyAqilcwIX1pmX9rvfa+XehHkz3jVBdCDjfQR4ZV34xT
	oEf8O9ityQXCWm7bptpfd/dBdysECz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AE8A4321B;
	Sat, 23 May 2026 10:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40931F000E9;
	Sat, 23 May 2026 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779532263;
	bh=32zkblvEReRXKUqpzQ/oX4QqJ1BPdQrr6JwVi3qqyLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OFDM7ade+kWvBD8c820tptMVqfza8ug42HGmqHNNFQr967U9YDve3fEBj0Xa3o9AA
	 Q5lQLs3LC5cmyq9wb/f4TakGS2jVBLROdrqspiV7AQYVCgHjfNvl2ynDrPxatzFrhT
	 Gph4q9Uxg5SUFllxRpiENqTPg1t1PbsCf7XRsuvuPxbuy3+mahWZtysxhMZ/DQ+ASI
	 VbmSq6qU5AcvbtbI4Ebryzfw1clWVvvYpNvVzzo07bLdFutZ3gfqN2wCJteQxHbKFP
	 I6WNkn3q+jtPgbHX62z7ejMEQl4WZkt/pCmo8j1vgH3X5bSFtTeEkws6K/+8GOlGIu
	 /DnmZqUpv0ZtA==
Date: Sat, 23 May 2026 13:30:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v3 14/16] Documentation/userfaultfd: document RWP working
 set tracking
Message-ID: <ahGB2yVi_fmtNuAd@kernel.org>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-15-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522133857.552279-15-kirill@shutemov.name>
X-Stat-Signature: tm7taqfa9qgkyeaigbnrijsugq6g7erg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78592120009
X-HE-Tag: 1779532264-300107
X-HE-Meta: U2FsdGVkX1/npPW4XwS2epp+0EVXQ7w9ALI3Wqo1fykxaGg253iWWTvUFaAMowsbMEqbwkyUq4XKONQHb9LH3PhZ3KRaye9UT3MwIBnnvA0uVtWMs6R2LQNX2aDGg1uF7RuTQSlUIHf1P+J5GXz+w3ww+XXQlFoTkK733PmSVCWNl6tbUWHgbOYlZMgAmp0Go+8a0S1tjlnj4ePkJhmWAjRA9lcH+NnQpbRxr6ERhw6DRlEFbOx4e7f2s5ahhbpM407Oiub1taEtfaaPgm3RU7TyNicve+OwmcGMhs/XaTy3T7nn+rCAzhK5iVgTeDfQsUm8QeF0Qpfytml0fCmMPzylOzUkDvXMo/Fwayjcg0dh7kvAyUBrkWFKdDj4ZQJDovRItqni+B/fFAWqO0RQTVgrCRCRZpZOXmRY1F5wrdsQ065DSniBihSOgYYuks3U/suBO1367Pa/LY0zTMuzOBmcpOCHJ8civ5rYnpj3I2U85SJTSaq4qaE++RW/UuAAcbJFS1Q+yB8+UHA3jp+BzC8tvPua/bbcpztttNgp1aqLgsbcaEyqsg3l1TRxZYjm1Udglfcp/B5oXmCe07T2DuFIWf0+/Y75tzmaX5lRgWNm08aCqduEpA0AZJYZlpWrAHWTKTQuUmiTCTrbRCgEzGrg10nreARSKHRnNFTkq+vZOm7IP2UJRv/qSwMMQFnB1cvbnt6Oj713ocgK8mGYpFLOSLtIDAbveL6x2TchT8Wf2N4dkiM3XqQsF2OhrDKGwVh08qS38NOtQBscvogWAG5LEIcymwxEp1SuNlxNk9lA4aHjnDJ83AqrwSte2NB+VosydDDhAhL6fid06dmM1IlU4aveElag1cz5OFJyiCzV26O3Lk5Unemsn/dBvujv9BWJUe9xVXrTq0s5k9kJzITzB8dTetmMO0I9UGOQED6ALBJTPGG/4jd/ZKY6Kd27bAF+wacNzEK8Y67HGO9
 b5nqpabU
 aczmHngDixgZU71UVr72C6mziiMCNIUa5+gIOWOyOJCIa5TEVmvMM5HGIbzi5CBjfG+xatZT+1vQ8QzWBv6KwoAt9UQ9FYpa8GAgvg1DE/KWoT7YhdyLMn9kAEAPv6/3UBUkdsvt/bU/CA5fgt6tLZOcn1jTqpilcRCzx0P+/d3sal+ffCGRtn+lFNvNwGsa4fC0q5kT+lUsdhqEKzr3meHXE9fSyzJ2Z+RAIF8m81fZaYAFMVowuyeMcjxxu5xz4GN5AW3nl0Nf/w7l/V52TbQOiOorxRi5wU96DgPoKl6ea81o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:38:55PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Add an admin-guide section covering UFFDIO_REGISTER_MODE_RWP:
> 
>   - sync and async fault models;
>   - UFFDIO_RWPROTECT semantics;
>   - UFFD_FEATURE_RWP_ASYNC;
>   - UFFDIO_SET_MODE runtime mode flips.
> 
> It also covers typical VMM working-set-tracking workflow from detection
> loop through sync-mode eviction and back to async.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with some nits below

> ---
>  Documentation/admin-guide/mm/userfaultfd.rst | 226 ++++++++++++++++++-
>  1 file changed, 220 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
> index 1e533639fd50..cb5d0e0c9fff 100644
> --- a/Documentation/admin-guide/mm/userfaultfd.rst
> +++ b/Documentation/admin-guide/mm/userfaultfd.rst

...

>  The user app can collect the "written/dirty" status by looking up the
> -uffd-wp bit for the pages being interested in /proc/pagemap.
> +uffd bit for the pages being interested in /proc/pagemap.

It's pre-existing, but "being interested" sounds weird to me
Maybe let's change "being interested" to "of interest" or "the app is
interested in".

> -The page will not be under track of uffd-wp async mode until the page is
> +The page will not be under track of userfaultfd-wp async mode until the page is

Here as well I'd s/will not be under track of/will not be tracked by/

>  explicitly write-protected by ``ioctl(UFFDIO_WRITEPROTECT)`` with the mode
>  flag ``UFFDIO_WRITEPROTECT_MODE_WP`` set.  Trying to resolve a page fault
>  that was tracked by async mode userfaultfd-wp is invalid.
> @@ -307,6 +307,220 @@ transparent to the guest, we want that same address range to act as if it was
>  still poisoned, even though it's on a new physical host which ostensibly
>  doesn't have a memory error in the exact same spot.
>  
> +Read-Write Protection
> +---------------------

...

> +**Setup:**
> +
> +1. Open a userfaultfd and enable ``UFFD_FEATURE_RWP`` via ``UFFDIO_API``.
> +   Optionally request ``UFFD_FEATURE_RWP_ASYNC`` as well — it requires
> +   ``UFFD_FEATURE_RWP`` to be set in the same ``UFFDIO_API`` call.
> +
> +2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_RWP``
> +   (and ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
> +   fetched back from storage).

I'd make it

  2. Register the guest memory range with ``UFFDIO_REGISTER_MODE_RWP``.
     Add ``UFFDIO_REGISTER_MODE_MISSING`` if evicted pages will need to be
     fetched back from storage.


-- 
Sincerely yours,
Mike.

