Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA5010ED676
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C736B0092; Fri, 27 Mar 2026 09:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A142C6B0095; Fri, 27 Mar 2026 09:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950C66B0098; Fri, 27 Mar 2026 09:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89C5A6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:05:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 986365E9D5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:05:41 +0000 (UTC)
X-FDA: 84591864882.14.921C7F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1BFB40014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:05:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3MyAhxJ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774616739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpia0tbRLSbb/6PfKMmdnmi2ZNpu87IQqJrkSr3zp4M=;
	b=Pulvh9XgHnmC+wQNVrewp1iEaPywFYHUfznQ9PUcRs+e39NxThajJTFoBr4CFYbzLfcB7m
	dNNMpJjRzHdmWi1EYVFYWx/fmb201o/K40jbuze2LxKvnti1vjvcUB/cVT8R0SJ+fzqn/c
	pz7RuPuZw3PUmPxdRYZHJnz6s6wqUH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774616739; a=rsa-sha256;
	cv=none;
	b=Cl4KSw1FTHrDkiTv0t9ut14woVZbkSVGdXMNxGVZZ3fMIA2fSA/MJZwsCbpVEPF1EW3yRc
	p5WkQjc1MczE7zHGg/TdmKFrxRIDiy+VDFOK26WUOc/oVHOYrpIUs9f+9TtUkiF2un2ez+
	dz8GXIY/+v2lYHqkSp7cs1OgEelYN28=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r3MyAhxJ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D32BA42B75;
	Fri, 27 Mar 2026 13:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1F2C19423;
	Fri, 27 Mar 2026 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616738;
	bh=ESd8XmCxuShsE/KtPdm5tiY/5sKpCpx8qvZ4REVh3I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r3MyAhxJLKeSjQ+ral4sSIkopkB1pfJzJjj6TP8/N/Bv2YFjtGQR/CiMmUMEVB1MC
	 XhSN7XVUDHJfQ3tFHCL+kfGnqrpGG3a+iqixzPmFVlT7lQZ2nMJnXYeXWUp9+MDjzw
	 RQ1bU/74oszj4mKKm158d5PNzIYQ3kKiIUPxcSrLEmoXNJb0Tmr+71J38cT0W52qz8
	 cfKSnbPx5brs5xBW+gzd8tW8clkK55F0GnPWCWB0CeKS1QwMuqpbKnOkY/mQPmi3+E
	 X3Cf1PUT7d5gBY+t/dzAUGFrVySbQquU1v5s47EgDEnKKGPepTA1peQHscmN9JCDFq
	 Lf20YgBuxs+FQ==
Date: Fri, 27 Mar 2026 13:05:36 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 08/10] fs/btrfs: remove a comment referring to
 READ_ONLY_THP_FOR_FS
Message-ID: <5a77eb28-cf8a-4e6d-ac5e-a059198a676f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-9-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-9-ziy@nvidia.com>
X-Rspamd-Queue-Id: D1BFB40014
X-Stat-Signature: poya8kj5py76ycfdc7nrdtt5q9wg3jj3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774616739-393681
X-HE-Meta: U2FsdGVkX1/a+/fSCFu4q3tpYJ2n0IABvK24rlHHYYl0XhZOfMwMN4RRRj6jpMshQUsHB+y7yP+EVei9ot4eqD7FFlihL1om/92hP0AEdTBnCJG3ypHEFRX+oP0ClhRF2YJbPgVNZqWlbSSk4UopLtrIGyPZoKuUzqJ/BG/+mxQg6gqxifLwr4T1rXUWwC2+2ZifP/61ZJWy/+0NefFUENxdn9R3mmoNSvhJKuBCn+OvLOjJFFzIEhxaATuCmrk/YVl971OJCA1UW5cc9Ns6+rZccenFikjU3Jt+L3CTqu8lDYiheIDe0mSdsAGrr5/jcTAV3X6AH9dhoHGYXpfSUfOSuE2j7Ea/GYreqkbRUvMERkDqT+vRITTqwN7Ee6YW4yiBDkQ95/R3lU7TpIGYK4Gq9Z37GryCWjX1QO2X3jqy4C8g2iwO+uFenRVdSATzlLgAinr0dSIr51Jbcc9p49dExcwjQbRT0IrSpUzm/NrDDL+Yr3MUo/Vu9O+bJlWnEOb1QZemSZQi/dGXFhNOpGxOFGc24c5tQP+EzWdjMuEZBFs6P7p0I0gTWP7hl4v2NfM3O3EU/gVNDkHgCafA5vrHHe5JMewayRZW9s3d8RRb+QY94KHT2pRvq4AfFY+4eevcEZ6ieFLroJdVaXw3sRbHm3EXoV7bfs1AZsI7CvSjOOryzvAJYm2KmIR5JoUyc1TZxyERVjASVlcbfJ7JhsAdEuOoJlEZ7EOyOwO5nAseRehs0yOZCtVX3MsjMc/f+1R1HCVDvvS6UmXsPZRI+piwFcKTKmye4DKPzTZKgBbKCs+gRhsDuQVqYQ5S2SK2kz6n2eDOYJNWq5ezUuORHcxhVPvVJu3kgbHG8/O0N+npvQcaChs0cE1EfXln4I6FaEhxrNFh3aCpvmQNzB7mgXd4c/k0itv/mYhu/0SWBu3b5tB5IkZdntpmlq+umOEFszyFpqb5BxzuRC6N/JW
 sLzg4/Aj
 q8qLZ0IH4FLkE0X9TYdVjEMiT9j8uIhlX8+UJd61x/fvcNWIlqOKZowggzO+8iyiW3d9NasTZp36G0Gki7mCOZ+c/XkRswAfpA/BaT+qt/4oFjRras8tasjCXYKsQ+IuMxh+R6+It4eWjrPvV4eANeykdHOnBABfkV+PIaZJHbcCnEt+aS2+7wx+psY7nu0eEZxlJ2rBF+MDTTMJ3DMA44GQTmqAN2AJpbAZUePpl4r4wLZgDJetuQQFaOdxQ8Ia7q8urfnqrx4LdPZXcldK5OY6SvGSbyuaOvHcfPvL0wT8BXqToQs84w3fmAXoLh5qfvKV6hdm1q4cVmxVqFrgXl7e9lEszd/wpQX1LnRGALkJb9P7TTPHr59d+4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:53PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related comment.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Sterba <dsterba@suse.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/btrfs/defrag.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7e2db5d3a4d4..a8d49d9ca981 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
>  		return folio;
>
>  	/*
> -	 * Since we can defragment files opened read-only, we can encounter
> -	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
> -	 *
>  	 * The IO for such large folios is not fully tested, thus return
>  	 * an error to reject such folios unless it's an experimental build.
>  	 *
> --
> 2.43.0
>

