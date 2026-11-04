Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA4A606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TcOpgZef
Received: by kanga.kvack.org (Postfix)
	id BC1C86B05B4; Wed,  4 Nov 2026 09:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72F36B05B5; Wed,  4 Nov 2026 09:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62616B05B6; Wed,  4 Nov 2026 09:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5F96B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:32:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C9E014073E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:12 +0000 (UTC)
X-FDA: 85397676504.06.DF8DDC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70370C0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TcOpgZef;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793802730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ensURHApHSqZx6uOyzhFmn+kTScsXcNRPyYQC1uz1CU=;
	b=iXDVttxcX7M7SIb9pnA3f0xppO6zOlI1RNrSVseJ8XbV/suYD2vj3XIQUxfCVB+3oK0yjm
	zZ2Wq+gycM2h9s6gxqaYfBBrioVMTOXWKruuxltyleTx5UYhwe8h2n5T0rt38Jcf4iclcz
	2Efb+RiwNImO2eeQOLUCiSd8rWA8S1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793802730;
	b=4c77aZwRupSwPTHHX8Z7P7Z9Oa+ABDkQDztK59vbxsl/toqMDpqTN6/cNNAlUpZxcco3kF
	ZFmvQy4wth6zWD711eW5lQD8Wq0PsUina9KFxCVl5tvoI5uOaJ5Hmd+mQVsPe+XjnIN9LR
	VHIf2uutMb5JFaSaPZiv9LlzayQp7hA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TcOpgZef;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6032E6022E;
	Wed,  4 Nov 2026 14:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753631F000C1;
	Wed,  4 Nov 2026 14:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802729;
	bh=ensURHApHSqZx6uOyzhFmn+kTScsXcNRPyYQC1uz1CU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TcOpgZefoJQDj0LMKZN2iBGkvhXFOXPKKWcv/EELG3wUHGxyUFmCRM1ItUL21vHPU
	 NL30EdFERhZSC/XY5znlGdQMZm3hLLB8tDKOgM7sntuTcodKpH25Nl4e8MahputugX
	 iGMxROzfrdCI5MWnXSfHTdb6BnKnjgcxrpA7aF11iws3kFyfpO2J9N2x0jW5LvDTHw
	 1Las9U1zCRWFyJBh+l9Tz6tJ6e3xFAroBm5WNtxAiFB2PQC4jsJo5mfffKhohxhdco
	 VgFwwZhMbiGRqPCJ/D1rhtDZiR9/MTBL0jU1idXwszX9SprqNES9MFPDmEX9CyJneA
	 hXNHIUwLK6FZw==
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
Subject: Re: [PATCH v3 05/10] liveupdate: Don't WARN if tracking a retrieved
 file fails
In-Reply-To: <20261103010216.3447716-6-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:11 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-6-dmatlack@google.com>
Date: Wed, 04 Nov 2026 15:32:04 +0100
Message-ID: <2vxzmrrok6qj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: eatcjahg8tnzrcracxrtoh8nrzeiqn44
X-Rspamd-Queue-Id: 70370C0003
X-Rspam-User: 
X-HE-Tag: 1793802730-214774
X-HE-Meta: U2FsdGVkX1/KDo4xLy1AYiM1iS+kUp4lmsSoHSh+tj/Obr/Iupr4y88IP1famvoAj8w7yO5vFmfmaz+rslfLeNiX4MX4qJ0wak0HvQeHYRwjIbjZRmvPh69+yZnFgiyh7MY5BH2Tgy/++fMa2o2SbEzrwXY6bcVNmC5AWTQaxN0jfT0/eWOHT4IJUGQv84Gj6Y5NH+fAUPTCSD7BT5mZLO0AP2KcOa0kMqb0ao1LKk3N08Md7BI8TRiKM32dPA2ODqzEQmGHRSQ7/GC7gR0/2zCCzq9ouofLsjoK9Mqd5pCRJ3R/QnZa4ZKBdU2dotT7+C8MMIsYVi9Fct6Rf9YwX0ETfCnJwbtGp9DCZA1UdETQDiFeJ40bdUjRR1v8V+ALUcz37Cl4u9lxzmqFkd/hCHs3QhYpccg6OHoIm3xzQd6Vj2TAyxzOVFNU5VjnyoCgypTBnZmswKRnyqrWbx7wbZuHnmQcZD9dt89jHDViKp9IjjwLE5VppXPkUX5uFWtcv5HhmGcnvVe8GLPSUSaBpDn1N93ji1T41H52suz8P+nKi5wY3IUDC9C0LnGVHAaixf9WE2Umd1nC6qqcVT4bX8Akj4zu5Kpva6dLymJ/8+6BKIoZ+9ip3sMUHDKL/SUZCj7TGZX5PscMyGVi05ZNgMuSQthGWlXHCsadlvUWvf6trEz0T7ybOALTdiv5ze0omTJigaupe/4+ps4hC9aUBdYrrvSoEbTB9O90uwM2sgnYiYWdvwlyNNk6M/ltksmQ0+8ZI+nIyv86EVO2/FQ/WusyFrLv9Re6i5KdWTMdEJWRA0n7bcfuVOZBb2r0tVQaZA3tsuXoWKPA6UxjgotO1aCgZeIehueEa5WmCkDckiVA8BP2MCEOj38NsQ0IcB45iqj3dwv0JzpZBYgnFrm8tNT7w37LD2fH6rEzUFhzWKqT1UE8L7i36h1RqsQ7DKlu/LIS6epCwV3lwApzyL0
 Xm2Qj00O
 cpPuwN5lg1GC5tBsVDeLdFug8bCLHSJIO5YcRDaIi5X42IogwnYWz1BJgrB6jghmxCxDDf5fKAtb0HGDLvY9vtot59PLxVa2HGzC/wvnboPSo7YDd/A0qLbyd/rQAeIn9chNBln2sS2oQMmuLBuEwitfuPs370fBLEuyDxcgdbGLmnxf4aoD66OfhAh9GDpX56iS7CFErj5987sll6OtzgL0/Rh2GFtBZCrIcWfshZ3L49gec2O1ABveLPneo1qN5r6Mx8VyPT5bMadyVEZf2gmYojimayFEfTgyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> Handle a failure to add a retrieved file to luo_preserved_files instead
> of triggering a WARN_ON(). Make the failure permanent, and keep the file
> until the file set is finished, like any other retrieved file.
>
> xa_insert() can fail with -ENOMEM, and userspace can trigger that with
> LIVEUPDATE_SESSION_RETRIEVE_FD, so warning about it lets userspace crash
> systems with panic_on_warn.
>
> The handler has already consumed the preserved state when this happens,
> so the retrieve can't be retried. Keeping the file ensures that its
> resources are not released before the file set is finished. Finishing
> the file set then erases the file from luo_preserved_files, which does
> nothing for a file that was never added.
>
> Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
> Signed-off-by: David Matlack <dmatlack@google.com>
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 908ae124ea5e..5a82e45b9062 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -684,14 +684,25 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
>  		return err;
>  	}
>  
> +	err = xa_insert(&luo_preserved_files,
> +			luo_get_id(luo_file->fh, args.file), args.file,
> +			GFP_KERNEL);
> +	if (err) {

I think you should do a WARN_ON_ONCE(err == -EBUSY) here. Because if
someone can somehow retrieve the same file twice, something really bad
has happened and must be reported.

> +		/*
> +		 * The handler has consumed the preserved state, so the retrieve
> +		 * can't be retried. Keep the file until the file set is
> +		 * finished, so that its resources are released at the same
> +		 * time as those of other retrieved files.
> +		 */
> +		luo_file->file = args.file;
> +		luo_file->retrieve_status = err;
> +		return err;
> +	}
> +
>  	luo_file->file = args.file;
>  	/* Get reference so we can keep this file in LUO until finish */
>  	get_file(luo_file->file);
>  
> -	WARN_ON(xa_insert(&luo_preserved_files,
> -			  luo_get_id(luo_file->fh, luo_file->file),
> -			  luo_file->file, GFP_KERNEL));
> -
>  	*filep = luo_file->file;
>  	luo_file->retrieve_status = 1;

-- 
Regards,
Pratyush Yadav

