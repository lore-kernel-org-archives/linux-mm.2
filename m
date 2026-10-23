Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807AB606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKrt8z95
Received: by kanga.kvack.org (Postfix)
	id A3DD86B0BBB; Fri, 23 Oct 2026 13:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF116B0BBC; Fri, 23 Oct 2026 13:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B6B6B0BBD; Fri, 23 Oct 2026 13:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C08A6B0BBB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:45:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC2D91C2217
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:45:45 +0000 (UTC)
X-FDA: 85354618650.04.540D946
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C7D96160007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:45:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKrt8z95;
	spf=pass (imf08.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792777543;
	b=GUdNb96fCoAfFMwKKZw51K1pz+7jgMunXMRIx+qAPbyGNHwiwLDFmr9kAT12k7WOvj0PAX
	G1c2/ki0rMavH31qfhkZaeSzo67h+PSsuhRhfeRDHvYPDF5b1VEFHKcQupsSo6aHWTReSd
	Ws0v43AboLGZW7IbGHO7P7+IRuP2utA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MKrt8z95;
	spf=pass (imf08.hostedemail.com: domain of cel@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792777543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+K8VmVMqKOof2bN/ApBJbL1jV/83LdW4iTCquE9kKQw=;
	b=XiaOm96hYLl1jI0ZtsPHbX/GbFnWOLUWfXHj92D1BJquJQ/RH1rLQ3NH1kxrtYLS2PwVDH
	vF4mFBhSsny47DD2+uNigE6VDO3zfRs+gGykY7kdPzF/gAj+tiN6hbzu9x8HTUhvd3z6d1
	PGU2QuFZygLNgv9Z1IlriDPZ8B0ciqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F244A6020F;
	Fri, 23 Oct 2026 17:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F37B1F01828;
	Fri, 23 Oct 2026 17:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777542;
	bh=+K8VmVMqKOof2bN/ApBJbL1jV/83LdW4iTCquE9kKQw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MKrt8z95nduJMsZ46pem/LKNckFHs4IOKk0GiFUkc3kcey7f8+E15FB5XwT6Vw94A
	 ROw7OoY/0zcGxwSht62YfzAZPKY5kg+9qq+99CUpROhWdi68EVj1Oow08v1xWlk60w
	 rOyCjvc1N9sycWvglR7FXgBk3MQoeHL9wS4ZbjDg8lNW9hQ/E4xfuafur/6cixXsUK
	 3wk8bvH6TjHQ46YUyxGTiOCspzoTqaDpdqrPlO05KH7WJHHVQa2Gk1xHFiA69+5O1c
	 GTUI9mbf/OJD05Z4QeGfzXWSugs0/vBBSDlOJSJM8Yck8onToyGp2RC66pUFuzHAH9
	 rvh1MsNeZ+prw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id A82B9F40067;
	Fri, 23 Oct 2026 13:45:41 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 23 Oct 2026 13:45:41 -0400
X-ME-Sender: <xms:RZ3baiRgESbIfk8wp9J4GDntN9ZHLzKsIejKjhDrXylUTqZSc7OtIA>
    <xme:RZ3baikbhYbg9_KJmjqNbuHwj38uFWUCI2e8xlDBrTc3Im5t3Okte2kkFF2N884-h
    JmO15WeN1S5CFsTC_hXbiFczUcd5m4vWa_gQlRzGZJpLWX65XNR5yU>
X-ME-Proxy-Cause: dmFkZTGw9D+wWvKhDs5hJFHaE33hWLdp5MJJPRON22Zj+F2eCnb7T3BTPUqogEpOQrGpoU
    X53T4/KSX1qcP6T682bAHoWiDbSAvDlKrXjoqUAXHJ+X7DuUjowthh/75oLiGbHVGRrYvy
    Ovxp/qIK0TBACpUtpr9HPOhI/W2aQ0NGI72CDCLfYSyzrinyf2y5Gqt9WZXJirg/VcS2wT
    KyOdEZpnkBtl+peUqWtft1knu0XgIWpBIBcqUUnM3VtMFZcAeRnPDS9Gxo76KWvXUoNzCf
    +dUggxkUwUiEH4RQkmSeyVrhCYKPh8Ucvj6N6zYPK0vcUWmb3W2SiJCxsX5b/HNxc5KZsP
    9xHa/wLBKF8Pm7Hmru+7M0hW2UddErbUSA563BeoGzDDauHiqI1VMpsakrbLG7zeJKmGhZ
    59c/kcupFWVb//JPZAPvOQID0NUlNil8cywKpk8d07LqtLq3EvK9a4DVpp2RknuyHnVZk+
    TSoi+tRv/xUCqRV71Cesv/nC/VV7NoGe8xlYVKq7mbxfT80K4U5WlLP3TVWPr4WCnCwbYC
    g7V2SxXA4RaWKiweCOGD6TSOVF/MJQ+dqamZc7tLBcz09vNRR7UyYR+xdb7h3O8GmdSNsr
    BsPc8f3hwH/a5Ln1Hhp1tYUMJKBRmSg2BFXhm+zQj8nQ4ZFlsNITgmC5qhww
X-ME-Proxy: <xmx:RZ3banEdxmK5GIshwTV18B6HDRUCrQjQGipd6QkFV_2NDPHigXiZlQ>
    <xmx:RZ3bahBbpDx8lD1TeNgaYKt4j52Xvakw_Dqt3-AyFnLwcJ1aeh2P3Q>
    <xmx:RZ3batAIeciA0vfdxa-vLOKT4C0Nei_1GaGckaDgGvsrsuGL6l70lg>
    <xmx:RZ3bavOT-TZZgCJvN4KIld23RQQWCYjYGbtxo7kiHmSm0ousICc6JQ>
    <xmx:RZ3bahOeq4hd0P8PRPwhP2_dJRcQC3CEJ4Fu4AdiaOIuvO2BJXKZSJrM>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8303778273B; Fri, 23 Oct 2026 13:45:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AnedLfdbxVbc
Date: Fri, 23 Oct 2026 13:45:21 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Mike Snitzer" <snitzer@kernel.org>, "Jeff Layton" <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Jens Axboe" <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Jonathan Corbet" <corbet@lwn.net>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Message-Id: <36498551-15ee-4a55-9757-54aa8a07085a@app.fastmail.com>
In-Reply-To: <20261023024548.71123-2-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-2-snitzer@kernel.org>
Subject: Re: [PATCH v8 1/7] NFSD: cut a misaligned direct-mode WRITE at the mapping's
 smallest folio
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C7D96160007
X-Stat-Signature: 9h3grrpt6mjshyqas6e5u45d7eircpqh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792777543-107516
X-HE-Meta: U2FsdGVkX186xW9f1DzZIdOrKzBoNfLwYqUFIJB0zSZ8RX80hGItW7XzEuE/GjUXJTutFUT3vXAvAQ5vhGtUEjvkYG2ophV3pMp+1QvaABxVlPH4pBkm6aVAkPf5aoZLDSBMV73QqrqkkF03SxbClkVF/1QG+DTq2CZf0V72AZZGc4SfIyFH26rXskq4KUMKYFCKj/ms/Z1xNGyhx4IwUZ5PHjaRnyQayZupXIZQYMMV/N1uSjjK3if4JyibruJXjf6UDADmjtUmag9bnXgDf6qOhlUxvc0Sy2FwzJ8yMaW8Mwj89M/WkLx73AwopLPfGv+wwrI58Y3o+y4Xx/PYQap/sbLTS4M9IZkaZBsnWo4gXLTywRgDj2W6R8C8M83An4plmpUHndAStK0Zf80f0+o3sbSjmwYDyqGc1IQsTzcDMktN2VQ/Zv39+HNdCnWOVomf5Li3J+/uzbfT8RKY3Nz0og6EQqJmTQcUZJDyXEkm8rxkWxtqE7iUhDqV1QH0xa84lktffI6sT9WWnQWpZNnYdcZe0NoqofvUZhuHM8dJyx+zBNxqaDAR1P191sqJ598zPQvj1PcmovlHhaNY98H3ei0fJPqmwsc9iAqkPBJcFFDLa8IyiWMv2Dz7ob7scgtU9lPSGh6L38mZJmWamt5hJxs0lB+u/YZxcYHFYJiHAuY+edIH9wFvPZowMyhcu/7LQ3orgazYl1wcn5ebGYZ6mQJrCcnXv6e1znLaO1Zifx/tUPkk/E5Xa7NNz2y7csNf28EREcxPwJ8XxK5LpG6mw1qGxIzjeOsNdeSeQhDdWUoNquRZngE1iYdHlYXRPig0815pwJeF//XPJ8uJHk8xK5WoqtAzkaflZudThv60K0Q4jzjj6jZSxmZ1fYJMa4iQE2o5DQJRb8WQxGOVfNCXDS6277NQL80Ag3ZnyXsO35X3sRrP7ojHQcFsCOmEsRKfNbIF/2YadGknWRT
 8WHIZHeW
 PvaoB5ECqei8oxENDKHytzSDjfiFapZkQTSh8dm+6CnHNQyUjcDUfouMv94ZFR6Fb37u+yaIx4gxOzsG1dqY0uHIKJMMDs79iUEStZ4LXuVsA2dvW0M5zrbOTQwMHdFvB9Wz6CgqfnwbNlpLAIlyn88UEKX4bnJ5VyNVVzqnLF2x279LOalUbEW70nEn8wWWFsG/lJtbcY2jfRDdc9eXo5gNv1gwYE0Q2oVtNL/Te0K+TnZWS9BJNprDaPpgdWwD/l6vkPeftiRAnJuXFA7ZIfAseIlN5uYXlCGTa6c+tgim+ddtxk9Jjgny7kjmXxK8toGIQchdqNemm5Y6Y/bybbYAA8/jPwrwuNWum
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Thu, Oct 22, 2026, at 10:45 PM, Mike Snitzer wrote:
> nfsd_write_dio_iters_init() cuts a misaligned end of a direct-mode
> WRITE at a multiple of the larger of offset_align and PAGE_SIZE, so
> that the direct middle, which invalidates the page cache over its
> range, never shares a page with a buffered end.  But where the
> mapping's minimum folio order makes the smallest folio a block larger
> than a page, the page cache holds that block as one folio: an end cut
> on a page boundary inside a block leaves the middle and the buffered
> end in the same folio.  The middle's invalidation then drops the folio
> the end wrote, and whichever of the two neighbouring WRITEs comes second
> reads the block back.
>
> Cut a misaligned end at a multiple of the smallest folio the mapping
> allows as well.  Where that is a page, nothing changes.
>
> Fixes: 80728157d1bd ("NFSD: cut a misaligned direct-mode WRITE at page 
> boundaries")
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  fs/nfsd/vfs.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 9219f8eb386d..ade00dabef18 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1452,13 +1452,15 @@ nfsd_write_dio_iters_init(struct svc_rqst 
> *rqstp, struct svc_fh *fhp,
> 
>  	/*
>  	 * The direct middle invalidates the page cache over its range, so it
> -	 * must not share a page with a buffered end.  An aligned end needs no
> -	 * buffered segment; a misaligned one is cut on a page boundary even
> -	 * where the offset alignment is finer than a page.  A WRITE may end
> -	 * at OFFSET_MAX, so the prefix is sized as a distance rather than
> -	 * by rounding @offset up, which could wrap.
> +	 * must not share a folio with a buffered end.  An aligned end needs no
> +	 * buffered segment; a misaligned one is cut on a boundary of the
> +	 * smallest folio the mapping allows, a page or, where the block is
> +	 * larger, a block, even where the offset alignment is finer.  A WRITE
> +	 * may end at OFFSET_MAX, so the prefix is sized as a distance rather
> +	 * than by rounding @offset up, which could wrap.
>  	 */
> -	cut = max_t(u32, offset_align, PAGE_SIZE);
> +	cut = max3(offset_align, PAGE_SIZE,
> +		   mapping_min_folio_nrbytes(nf->nf_file->f_mapping));
>  	prefix_end = offset;
>  	if (!IS_ALIGNED(offset, offset_align))
>  		prefix_end += min_t(loff_t, cut - (offset & (cut - 1)), total);
> -- 
> 2.52.0

PAGE_SIZE looks dead in the max3(). mapping_min_folio_nrbytes() is always
at least PAGE_SIZE, so the cut is just max(offset_align, min folio). The
new commit message and comment both describe three independent bounds, but
the accurate statement is two: the DIO offset alignment and the mapping's
smallest folio.

Also I would like to keep the helper's unsigned long type instead of
narrowing to u32.

Post an updated version of the v7 patch so we can test and review that
as a single change. This will also archive that revision in the lore
archive. This will likely result in merge conflicts with subsequent
patches in the series. If those are just comment conflicts I can fix
those up when I apply the revised version.

Do not include the new revision of this patch in v9. v9 is now patches
destined for the MM tree(s) while this patch goes to NFSD.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)

