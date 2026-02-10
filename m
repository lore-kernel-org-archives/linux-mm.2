Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9520EB26E9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288206B009B; Tue, 10 Feb 2026 11:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253846B009D; Tue, 10 Feb 2026 11:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180AF6B009E; Tue, 10 Feb 2026 11:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 066DD6B009B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:49:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D293656E72
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:49:24 +0000 (UTC)
X-FDA: 84429132648.07.38B395B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4638040019
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:49:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9vIlW6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770742163; a=rsa-sha256;
	cv=none;
	b=w0JqeeED4UA8KoMn31nXRUhV8I+P64l3GLmjAFINeM00/9/VSFmSTZE1fQvMjFfk7a2GE6
	syTLX/gk+Uw5n+mBQ2ZX9Ha1Gc3NymtTrVxiuPa5PPmJlOoorTNwb8mHZLKLmWsh7+QMPG
	iuKAzJja7RUKn3n8qrekJJAz2OFyZko=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9vIlW6H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi8iDKUVdHGqjf9CfxkOJPviVYER9yqHzUtpOvNOdJY=;
	b=G5FHvhLiw/RPSMq/Hp0V63m7GxdTMsUiN5smUyX45tkZqAp+trMBd4wE87Z0iurA5OJF27
	C0AGseStsVbanFEhD0CHjIG52/nnyM6QDXyzCHUe6qlcirQW8uGRMvctqpAppGNZ58uIKz
	vItna5ih+M4xC9VscqFqUIuDjHvDH7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C38F560130;
	Tue, 10 Feb 2026 16:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27058C116C6;
	Tue, 10 Feb 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770742162;
	bh=qiunUbsKEW7gX0zCCMDrQrvoSAJfNHBqrIU7Es8yzS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R9vIlW6HRyYc4jDn6t3F8VDRwTUXJ6L2WxDYx1nGhK3O2j9faUFEVV+RmNw8Y/hYC
	 5HBGHZA7wdLvjS5SbrLzXnbp/DtZbySJdS4J3u+0GRASNNkAOC/cm4fUPgTJVkEDjN
	 TPZZ5BQdL2F8iVKa+RauLwA/aem/K7ZIhZjjvUwZF1GdwqMFkN/DSImphRoNkR+GKx
	 1LUKL4FM7KR1OJW0viBvkQjPqAvmZTwiTa/4GZRt+zX9eKE1fRujNwnCeMAulHHkSB
	 UG2R/q+s3UN2fi3q2bxBuuiWxUHeXIVQVt/NbWCSuSwqSGK/gs1lC+FEkQ0sFwx7wm
	 TRv0HUkZflnWA==
Date: Tue, 10 Feb 2026 17:49:17 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v3 11/12] xarray, radix-tree: enable sheaf support for
 kmem_cache
Message-ID: <aYrsR5VYH9JHeIoZ@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-11-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-11-f777c65b8ae2@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4638040019
X-Stat-Signature: ufa33nxmsadjz81cgq5isqj4z3ym9mts
X-HE-Tag: 1770742163-780449
X-HE-Meta: U2FsdGVkX1/buGZbwhZWIcyhpGQQhIAXlrdpVT4ikEq3I8x6hZMKnI5G0T5lHc0uHDuCcFcs54KVNre2Q+AI2WXOL/mHT1gsHtoMGglJkqcOP/ZxVSMZ+um3ksD0UKlqg+7OBPz1l/FLK/wXjJ6OzeTh4F8Gg4EsqRgooaTtnoI3JreGJ+jCllrklJ214tsB3e9sA06XFE4Hb3oPBmd5Xx78yJNcYo8NBHLBOQsjof4sOmXyjeX5E4nb3CsPqHvkLU0GziM/Q9olk1NHxi8QHvnk2olwJbvvRWan7rppr7nL8STtAuhkiVGZb7iJQY8VaoA8z6COVx9hIsA688yFlqc4DQlycnDOLv55RHNU5ihv8w0eTJOPvDRS+QlkBR23j1NINugP82FsOdsz0vYy89LRnzcYzaBoUBDT8TzUxZkYjj6w6rsy6Y4UAZIVS6Uf5VGUtK8Qo9nP/7DS3+PVfOGdhR6cPJHG82vAD4o66griUGOuL6zqG6forTWHKavCGQsd3SpNsgbPuO/BN/tWXEXcnVjyes101PgAyZEvB7I2WTzl4Foj2Mgtx0G4qjjQ02yEZPkWq6ByhiiWbA1p716MZGZ2C/fGx0RISfCF9ymulUBqjM3tRY/clxJ6T8EBCDKMKu1Hn+eRzJfJ6pcs0pVB68WTE+bueFlRtXtaMA8Oclwa7dlRCor9a30UzDH4C3GRY7RYLcDS8C7vTBLtWRjpkfqTcDvcw6+Vz6kv6+nnZOdygXDtOVUc1E56tWiXnK+LrWDP66p8ljx13wETMogk9jnjaXKdRXhRznZPbNO342Es6jqJvi22qcB11Nz8Oq1AyYRbS4DeMUBqhchc9fTKHJarCqvgC16pUyGCXTiLV+NgmiT7vxcMjnrQHISeCxM/OuUJZ0kxyNrx0E1eDYfK5RghW8OZct0TmdZTUWZlW6gQaIx+6xRt1WojdNBf2rGXxCxzklr+eK09e1q
 UBhvXGMJ
 Z8L5uqUc1YbjBbSo2XRUak1J6UF2VlK3NiGmiyswwMt2Tt0KOwivZMeRNTZFIjsR4vgQVChCgemGlm/k9dYeXf0Fqp60SacnoNTle7UIlHR4t9A0xFttPgy3Tmx8ZwR54ZV09WMYpjnXp77sE4GvuKhozlYDK9KD9Y7Ixn277YNCkRsnHU4Ys80RJYCgr4eD6Q2+LhwkrUwSrwmYhMILLhtzlU2B+dWltFMX6gqQjaJyG/5LXarTl281zKxaWkk+fl9WpwIqUrQsbdL33bj3WsLHZFiEYOHDGd6aI1mZWdQfeiOSswoQWW05rT03qEmVfBGxTnJ7J47pOe7HY0B+th7G88aazDadHPpOBJrfJtA/iRpPLQBwRhz/8KSJtaFT7QkCEAEudMY9vww2GawZX56Ikkh/1OhdgNSqrDOvlQ+zjY+VWY+R1ImFX+WKSZ+ZMuZRUvYwxJY6BrIY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 15:38, Andreas Hindborg wrote:
> The rust null block driver plans to rely on preloading xarray nodes from
> the radix_tree_node_cachep kmem_cache.
> 
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  lib/radix-tree.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 976b9bd02a1b5..1cf0012b15ade 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -1598,10 +1598,16 @@ void __init radix_tree_init(void)
>  	BUILD_BUG_ON(RADIX_TREE_MAX_TAGS + __GFP_BITS_SHIFT > 32);
>  	BUILD_BUG_ON(ROOT_IS_IDR & ~GFP_ZONEMASK);
>  	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
> -	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
> -			sizeof(struct radix_tree_node), 0,
> -			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
> -			radix_tree_node_ctor);
> +
> +	struct kmem_cache_args args = {
> +		.ctor = radix_tree_node_ctor,
> +		.sheaf_capacity = 64,
> +	};

Is the sheaf_capacity matching the number of slots in an XArray node? If so,
this should be bindings::XA_CHUNK_SIZE.

