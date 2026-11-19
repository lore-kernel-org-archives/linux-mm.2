Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8E3606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ciq6flFz
Received: by kanga.kvack.org (Postfix)
	id D0A4A6B05B5; Thu, 19 Nov 2026 02:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2316B05B6; Thu, 19 Nov 2026 02:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8036B05B7; Thu, 19 Nov 2026 02:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83A586B05B5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:48:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02B7D1C3EBB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:48:54 +0000 (UTC)
X-FDA: 85451092230.01.B36BDC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46B7920006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:48:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ciq6flFz;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795074533;
	b=lXyD2+IMrV+aWNpsfkMwqU286pJOVyT2RYw3wzWYBsP93FALChS5FjcwL66MDLIe1lCHnp
	HbvX7eyoz3inZGFhGfcRsTzNs32vfTWRH4v3cKvY+jSly3oJkPhu9j/ufTKCnW4jHwJCD1
	lPbMHlDJzPAwwwa0ubwiRBbowbwKLSs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795074533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmEEuBhQEJvXv8kkt6xrkH1QI8J0H1ekkc6D5vAoRVM=;
	b=pXjGnXyeFoLFb7p3eC8C4ngyQn/1aLLMEi8ab1WnAS0YRfJPeWg4KZR4vEXtZ1WsQ639pe
	MXeEGZkAUa8OI2qujNbB0bUHXwyPHDAva3DeIbVLmO5kUyJ7QXo/DyGqRQTmJ2cte7TUPY
	A63Gz4ah+VnO9zPFlwqAhs1XS//IgCw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ciq6flFz;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D582D611AB;
	Thu, 19 Nov 2026 07:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD601F000C4;
	Thu, 19 Nov 2026 07:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795074532;
	bh=fmEEuBhQEJvXv8kkt6xrkH1QI8J0H1ekkc6D5vAoRVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ciq6flFzwdeRLc7uUxncc+kZ3xdYzvcYlSCy71E8AlS0DHPOb6uW/8SBI1HGGRttH
	 SOABX52VWPvnCy5v6k0R5k4qGvsaEFBNUJWIcPDBN8t6J8YbfVookkAwHhlIkH9YDT
	 CE4CqGKkZaXYpASzRCAT7gier5sdUp628xa/ozuqXaKWmdPoWkSVZps45eMMGtzgEC
	 BOH8Rk6VPSUbjglXKZJGAAxqBo+1NOEwGJI1zxo8A1v57gGRuDBbz63a3dL45IVy5F
	 P+ymYgGewPwP9ifIm30BWsXR2VpP8dZifC2l93ECd1VHXIm6VPFFLGKtC1Fvc697wP
	 1Brt7TJfTvo2w==
Message-ID: <8f2a0f78-6f76-4a5e-a6c9-b36638addc78@kernel.org>
Date: Thu, 19 Nov 2026 08:48:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/gup: add memfd_pin_folios_supported() helper
To: Jiahao Xu <xujiahao@cmss.chinamobile.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Samiullah Khawaja <skhawaja@google.com>,
 syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
References: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pfkknj783gd1kq67x91z64gp1k9sdpge
X-Rspamd-Queue-Id: 46B7920006
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795074533-36115
X-HE-Meta: U2FsdGVkX18T93WJBHKgfIIUuOUsRrUzqXwcSJcPVW2uE9XwaXUo0tmW3yO/e7/PLt/8hnnTA7SbEPoY0dPQqUCDINIChkUtb0o1rX86jdCWSKKLMqgZO6tXmbeXkMISl/U5CIMSyfEqYiL0hYilceQgPyvkEYii8uwdM3S85XZHp8CouSDIFBqlySZmozDxLZm27uksAIbz/qoJ7DyVpX6tMKPafVfepyhii7DJEouEiSbALIZOS9l0YqlYNBvW9BzjStZVmJPHA6iA/BSESh6UBT0gjf47vIIMESlp9Da+Qpf75Y6SrZZBpQGDBAjqfsvchMaklQJ80NNPfocV6huVcpZL88gManNniSTUeDXp0igLkOlDqADkfyDV91bSmkgpjbKVt8DM/blFUQ+6QVeU4o0Y98PBNOuScK8+scnOP4zECNHKVmgyDl8zqoO4mstE25D1z59SoscVYNo/XcL+53L1P0eT3uvU9NIbrSg+M6vpWpGtwu6Ncc8+Vcbure4+QWP53yGxtCX9m7le57Or4uBBDUe9cRC1VKWyhsj6pbud3rzQOiDwx1Yr6C3d9gVQlx4LwXcOMKY9r3MxnjTC5EYcMFawhTd5C7jz0oQ6O0Hq0pZQ/Iok1SM8a93MG1DxKpQ51zkvMlhemDAtpysIAEFR5y2XVsENZfnhIQcEcT+pRRhbDFjXyU8DtOEO7+uFEr0e/SqxlZ6g5edDRH/n0KV3QeKbujJmtjOmSvCQfE9Fc/Ms2jx5ysylUxAaOufEP8ODUdaoLV3zI5YHGpZB3suleIe4F/ZRAJ50KnKjHuw3vLMwU8QC0jAxFBNNszvzA64EQVPhT4JY5a+Md3L36KOAdmHflMyBeZBTbc6vuPx8zctfqTJWw36s1cwiFrrCk/Gx7x0mCDWr4czn61Rl7kl2khQZYL5nFht/bpO749p5VMbn8xCv558PCmnFbBw2o87K7E83cBfSFXk
 Ry3qxOqI
 84VsD0vPsuXmPZYtHGBi+CKKWcMwHK1XicIWtCQC2avNyuCXykOYK+WOis155yvejP9F3jbdGjlxvgD7GePyfD49YftCqRJInK6Vzu5aFl9cw6PIM3+Z5fflt97Pz04MWY+VnKvkQBnVBu21jgjEyd32i7PvomXS69QFylX8ByydIZKrr0cgBNJai4YexI9JJ1Vlsd7LNaEQDSBqA94FaSsvWJOPgjRLL3krIx7+qir7KC4sTljBpDu5OBnZ1FrmpDvkAMrXLb7NVapFXQ+/MRJF66QR0iwKQxqYMaEONl157y1bf/ZSHt1jScFYHEEL8CXIDYnE440HahvNJbhNvSZ/HIL+gaV5pOEZzi5VsFhGzEIl3/saG2iJ75HJLTINyIAF20lvtwrSxClj4XodOl1qECfCzb3Ucnkv3KejtdJu4U0Xf0Tqrpjh+OOsYyLqAwXgh03MIubXo3RBlpyyH0OV5k7Kn4tdSKhfAJ5UKGzRgQF0f5yFuEMf7QCZE3DjoaqsDuWhmJmQsTAPeTkcwNP9HkPlZuDiGNJHg9DwXuxWQXoZkssy2FXnacL3SM40eAg2YBs/BL8MJsrrQSGsr5jfFvYXE6/z9t9N94WJDbDac/x4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 03:44, Jiahao Xu wrote:
> memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
> that inline with shmem_file() and is_file_hugepages().  A caller that has
> to know up front whether a file may be handed to memfd_pin_folios()
> cannot use those predicates: since d3710111839d ("mm/shmem: make
> shmem_file() check the file's inode") shmem_file() is an out-of-line
> function in mm/shmem.c which is not exported, so modules cannot call it,
> and is_file_hugepages() on its own is not the same question.
> 
> Provide the check as an exported helper next to memfd_pin_folios() and
> use it inside memfd_pin_folios() itself, so that a single place decides
> which files may be pinned.
> 
> Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
> ---
>  include/linux/mm.h |  1 +
>  mm/gup.c           | 18 +++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 040cff643..e401edc93 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3600,6 +3600,7 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
>  		      struct folio **folios, unsigned int max_folios,
>  		      pgoff_t *offset);
> +bool memfd_pin_folios_supported(struct file *file);
>  int folio_add_pins(struct folio *folio, unsigned int pins);
>  
>  int get_user_pages_fast(unsigned long start, int nr_pages,
> diff --git a/mm/gup.c b/mm/gup.c
> index 7605da0e0..90ac51207 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3449,6 +3449,22 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  }
>  EXPORT_SYMBOL(pin_user_pages_unlocked);
>  
> +/**
> + * memfd_pin_folios_supported() - check if memfd_pin_folios() can pin a file
> + * @file: the file to check
> + *
> + * memfd_pin_folios() only accepts files backed by shmem or by hugetlb, so
> + * callers that have to validate a file before pinning it, or before taking a
> + * reference to it, can use this helper instead of duplicating the check.
> + *
> + * Return: true if @file may be passed to memfd_pin_folios().
> + */
> +bool memfd_pin_folios_supported(struct file *file)
> +{
> +	return shmem_file(file) || is_file_hugepages(file);

It's odd that you would be asking an interface specific for "memfd" whether some
random file would be supported. It's in the name: memfd.

I think the better question is: "is this a memfd". or "is this compatible with
memfd thingies" ?

file_is_memfd -- but we accept also other files, there are not strictly memfds

Hm.

file_is_memfd_compatible ?

Maybe there are better suggestions.

-- 
Cheers,

David

