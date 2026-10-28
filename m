Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400A6606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqSt6JSp
Received: by kanga.kvack.org (Postfix)
	id 625FC6B05B9; Wed, 28 Oct 2026 10:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D69D6B05BA; Wed, 28 Oct 2026 10:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC7E6B05BB; Wed, 28 Oct 2026 10:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F09D6B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:46:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE884120113
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:46:33 +0000 (UTC)
X-FDA: 85372311066.23.FF8FD4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02ADA40004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:46:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqSt6JSp;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198792;
	b=5Ek1PQegs70FQKW1VXwr75EcuggoxHbsv2TI8on7s2NfNtJ2AZzQIfFo5CN5k+CIesWJaf
	CW78AUIad7ePFMC9ju5jyqQOLY2QCxdYt2P79uGgMLhx19azFrcdZiZ/MfEKJfKjb023vC
	zW/tya7QZ93KJID3EGNgWjE6K2JoknI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqSt6JSp;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BmiWFD+AIfcKHrCYW2fJHXVTBL4UVTz8KwvZjgPr3A=;
	b=5kVeI5TXTc4A0DK/9ETsodR1qmuIY1ecQ1jHTE0Qpa2su8Hme+nGK81UM6oxUkAWUWCdXG
	Dz2NilbrjOA5DFgFmMxnu+MyiuI59P3+1ohcielJ637Wc2k/MmiNcVXRvbv0utn1Dr3q9q
	EFnthvS/RSOnCtmrBdZQXHEn9Vg+azk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DB1C43AEB;
	Wed, 28 Oct 2026 14:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4741F01825;
	Wed, 28 Oct 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793198791;
	bh=/BmiWFD+AIfcKHrCYW2fJHXVTBL4UVTz8KwvZjgPr3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MqSt6JSpwGVWhxl0hOVTwcwqyqfM7zbgydUleSZjs/v3QY8wthj63Nc/1A+eqgKMd
	 j4c2OtHgHkCvUrO3y64hfl64zYscEyYw2YkTKhELSenR+WECUg62ZoAGdE9Y7EXVvM
	 CXNwSaDrjQ7NVKXl7p5bW171soHKRYJ1FG1U0nV5p73fMU/3JXd/+w0xPGlSd2jhW1
	 QKGCOL8VjxYnbm2ZuSTiNdqMIMsy+pYOcRy/o9oQegNdWE+R+K3yanqgz48ILRj/qz
	 SLQBZcZq37wYHgRkPknekebTDKy0vKW+wKYZhpb4ppTaBV03/7uxn+POQwIlAk7biS
	 +nR+3p7SCCi6A==
Date: Wed, 28 Oct 2026 15:46:23 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/3] mm/hugetlb_cma: fix incorrect hugetlb_cma_size
 assignment on malformed input
Message-ID: <auIKvwTBF1-jeThh@localhost.localdomain>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-2-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028113319.38544-2-kaitao.cheng@linux.dev>
X-Stat-Signature: dwarjzhfdasdxxfc64ko1x1jpq9oxt7e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 02ADA40004
X-Rspam-User: 
X-HE-Tag: 1793198791-24912
X-HE-Meta: U2FsdGVkX1+GrQmVulofs1156HynDGdmeJ4C3eEfgE4faAcrHQjHHAf6m/FCUXM6B9GMlr9SZ3c6kQN6YEJjHB+4V1DlJVkdFmmgccys3FGwcTNvBomSxs85s4N+/Z9fk/K+/zemKMB0XsE5+PBcAFJStVgU0f0lL6HV1Mmjy8I5k2CtemmH0bQtb1ITVqyWKa5wm9fUKwxwV12lqNh9Ql2mgux0VqvttON2QZa7lFM52MxRmB/Nf6RgfcWxJgjQ+ZKacNYHZCJyMkZzdwgypglr5vjBiSRod8k4NVbYLEBVQqS+zrWdThSPw7zQpGTF1AE3AhxD8HECbhJMx+lDDmO/jgtivF8nOn5imHy2G/chuZv5dc0a27Y5eLLljaRr9SbYGUXOp7FbKMZEP0UDl+JvGjrwQkORKs5iJna1+5T7ugYZaQLtVpfbP984b+uOwY2u0lr7D7C+Kc1d8VB0lHijj+Fdv5ikQ0nEGB5AXxh8AaxmPfzWjvxENAuBMsHzRHMFHWM0FuHn85eDNDv6LdGFZh7+Rv2ZkZCzvBN5y+3adkXmk000obCG8BNlLDHheXGSZ3dJ1KM3DDGGHODUqmzxCxnKn32yDxbS6RzHxB+4jhbjyXqtiKty97SJf/OLmY48/QURr6yP1viDRvsT4lrajDA9OyF5qYuVcTGQwdBcpXTd9IgiEuHrSPpf+G5578UEPgH6Ds8J7mMIwpdnX80Nu/ue3EyI2DcHunYNp/0O+r5wN7mePHuOwmWAJfwXyNPLTc6f8Imngs0W5ti0GX9brazywi++mUgaAphKalcJ1tvKjyeePX6TtCK32b/p0VY/78QSxqnF206b9nNr1ZXcewROunKrlVg94Ntt8TLZqjftipjRNgq5XPV/wRGsWhIxcYot+5mbHF7v5gLvfB893uuhsy1z7Sqp/qsLRcMdgxv5AvEOsDCuQZOjNwUv4XL3SVh8LIGJvfaxWfn
 WIexIz8U
 EG+e/DhBeipfNsiVposzmWx3NFqhQwu50bG00KzHgYfn543dZDvZok0pmtcISBGdUnlyrueeSwKFDW1k9bfMXs/k1KOCDO9LMhSlkkxSF/+I3ohrzawRqu7/bRgFENLD8SgEAV03lw9PUwGB/kFXZRD5aWdQ0++elrKBCbcRpVC1dheEsUeorz2N4nND24Wzk7PdYAdJ+tA4Tjk0cWGlZhY3uI/WvPSC2k85RJzxg/FQfi+mm+WOnMN8Ji+0AHQvSgYnhGNkgactUbDDdg9cvoc5MCuuBGLUzIZOcKcCzxETNHk9tDJFlnAgBHIUkUhD/A+IqzuJlDV7Ef1qHnOvwpQfYLDaa0H5ir1QWdHcoh5eS4TZG0tLF+E+KJWB6DsAnv7YS9SpuR8LPxf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 07:33:17PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> When hugetlb_cma contains a global size after node-specific entries,
> cmdline_parse_hugetlb_cma() enters the global branch and reparses the
> original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
> initial node ID as a one-byte global size and clears the 2 GiB reservation
> recorded for node 1.
> 
> Global and node-specific formats cannot be mixed. Return -EINVAL when a
> global entry follows a node-specific entry, before updating any settings.
> This preserves the valid prefix, so the example retains node 1's 2 GiB
> reservation and reports the malformed option.
> 
> Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
> Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> ---
>  mm/hugetlb_cma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index 95fd2d190f0d..8e6b20341fc4 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -167,6 +167,9 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
>  		} else {
>  			char *next;
>  
> +			if (s != p)
> +				return -EINVAL;
> +
>  			tmp = memparse(p, &next);
>  			if (*next == '%') {
>  				if (tmp > 100) {
> -- 
> 2.53.0
> 

-- 
Oscar Salvador
SUSE Labs

