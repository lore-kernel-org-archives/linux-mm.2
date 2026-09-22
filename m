Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04957C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D136B00A1; Tue, 22 Sep 2026 02:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1046B00A2; Tue, 22 Sep 2026 02:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DA46B00A9; Tue, 22 Sep 2026 02:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 930086B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:45:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90F22A5FA5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:45:23 +0000 (UTC)
X-FDA: 85240461726.07.BCCF2B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EF2001C0005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:45:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmGJvweB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmGJvweB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790059522;
	b=f2/sg2Kqhlk+KtCPc39iw0BssTejr7IdsJYzm4D+GOEqhsUfRbYi7KYehx9QR82xxtmWOg
	7HTX50c37RGy+CYn6r2LUTAfnq5mE5vuOv+VXSfyu5v87fC6xh4jJ2GQHMvV+piBK3QBQ3
	Hf1ZM6g488H2gvoXITqtl6qt4HraGuk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790059521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoPyg2SIrsoK+SSMxG1vwxO63HiOF3XndXbQAp8ZbRQ=;
	b=Mwo7shOPnD2qFjz/KTPpkxuyscI0dX8ZNAkptSWZpQV6zB5+cAG1WDWNOy9Ln3dk8TGGva
	4LjHMitdbwMBn/UMS9h3TXKWIjf8f8aLv608x6giE+kqwp6VyWKKVFiE8L4QRKpx/YpCAi
	ZecmtkgsaZ7LPxIxYArsK+rJijODaqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A37C4600CB;
	Tue, 22 Sep 2026 06:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4A61F000FF;
	Tue, 22 Sep 2026 06:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059520;
	bh=hoPyg2SIrsoK+SSMxG1vwxO63HiOF3XndXbQAp8ZbRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UmGJvweBVxOynT7j+Gqjjm2LzYYprQN0fcyy6PM9Jb1M08HBX8oMVvM6eHS45dDk3
	 YjiexvypK1R1hGq/kuQSDFAG4oeJgoFBGJtrXuYY/NWABpZApQbkYA1ZbbC1Fp2T7P
	 Q59fw5+po2bmBQe6TXHUj338flIIT+uy6m8J1XRKZO2gnHmfybPWWHmlh+3/div+SU
	 KLaKZlxuuiZPzRp0TA8rNzI3KYp6G79u6WQgWyCgrE2TtlKTxOvNAmclkO2AuPTKdH
	 aEU+6Mf1PMJk+q7/hsNEgmBB+MXoZTBzNy8T3Pniths2Z0BM2B8wXHGfNsgKv0SE23
	 76fF0DV6A8x2w==
Date: Tue, 22 Sep 2026 09:45:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, surenb@google.com,
	aarcange@redhat.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-ID: <arIj-DZ3BtxMEzLB@kernel.org>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
 <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EF2001C0005
X-Stat-Signature: mhue4w48ns3x4mto3ysicki4mh8frwtp
X-Rspamd-Server: rspam01
X-HE-Tag: 1790059521-453430
X-HE-Meta: U2FsdGVkX18h0Ptfk8WZljjNdskXkbZeab5Wv9DJiZ3XTMfF0ITh1OfMeD4cx4xw9kwlkYiEJUnNILTdW8hCcPmU/98yH1QkrjxkcI+Cjzl7qDFb6CD08vY15zqPk1go/0AqM7EphFdl+jhvpoLB2eyG+szoYhiL5lMdENj6S8AsP+gu8IlTwAy8Ck34N4ciZxXSas8uAjZFA8X68Lqmj+LtXVkca7T6LJoKbujURUDgiCU1Z2gh+GapirsGmWMzrBR0QnOyzmV13t+0j24iIm8qhQkPhCRT640FhbFwqQ9V3Ozsg6etn9JdGDpbpCX/XY86/XKe6rFWijrViOn+K19sYZ6paTdxAwC93m+hgoNhIwUn2oP2hHzqkv+tmY+pWZMq4Qy/niEF1mbdOc735+u1TaVdU5qp5oQt+I71+HVlMN/GJ3KM8FZbzzr8Q6sIWFZ6ye50MEL31sLPdpvwHjFBRtpMMpRYghcZcX6VYiH0I0BiHc0II6wDL7+VsbD+7hlU3WFFMKfpy5HGGysgy69ud2Y+o+h/E0W9ShgJ5uRiq2uD8nLh+S7/KJ1+/RnhIbc8bafq9dE6BHg1CXhFXS50BqRyNgkWSr6QdEaxMK78DUXd0/du8sU0Q/OjEJKmB3+GYqKksaFESqIKrDzaGjtbxz0P6YU11sSXoXbtvRi0xK9aberaKqmWnuXrEWp29IWDSVmMmUwz1NteFnLVO9/sei6qXpWxqLzCgdCuxOUfxnsr4At0uxkqej0yEgWrujakrh28MrG7pEYORyjX6ETFLBLnrW4p8sTbSujK1MsRx2efzmayfX4INjj4U+M0pLqYmuL43pl/EErmkUYJzA0OAo2WNh9abLeXHYUYM5QU9bQGOEWGMBDWZdgStW8PTaMFsTM7Dvl0HDK0psdOBD8Zy1oaVzDKhJPVzLZVFq/D0Ew5rOwOJYLcckB1jc30Ayegl0f8wVdOScpa63y
 rsR00gbb
 7flwpTQnNPqXsaD7Igw/eETMw/RwiRP7KzDyuUkPqaVZtJWdrBPMNg5FKQBrM3WnPDk0ooQpBNyPExOXhGZa7Yvqxzo0WgtVMuy9sPiqXN+r7nko8MummwvG9dpmLakOwA5dx04A8GhR6BGZYh2of4yphG3NHsrb/ZOPHq53hkvHHvcDFtMIsrmUQXyBSn5ZXSL0IpsQ1UtQuHl1SviDEqdnxEQtH8sARgLkDA6yQN59zYrWer5zVfRdOSr5Yb154eQcDLoP6HiGyV6yoistfmXMUG2WrMoBT4Y1mcKXQi1Pz7P6c309kgKMmoVFl701oDwdrx96Okl+6FxrdQDMwSWfdhXoKcytZ8kvzSkooO5oAXohHfJecTheRaYgScaunzgOSSTGRVJCc/oUflQl+MYugLWvupM5LXWTNjOdIWmCciWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Sep 19, 2026 at 09:46:29AM +0900, Donggeun Yoo wrote:
> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on the source lands in a
> destination VMA that was never registered for write protection.  It is
> then permanent: the bit is dropped only by change_protection() under
> MM_CP_UFFD_{WP,RWP}_RESOLVE, which uffd_wp_range(), mrwprotect_range()
> and userfaultfd_clear_vma() issue only for a VMA registered in that
> mode.  pagemap reports the page as uffd-tracked, and MADV_COLLAPSE
> refuses the range while the bit is set, because collapse_scan_pmd() is
> strict about uffd on swap entries.
> 
> move_present_ptes() and move_zeropage_pte() build the destination PTE
> from dst_vma->vm_page_prot and arm RWP only when dst_vma asks for it, so
> the destination's own registration decides the result.  move_swap_pte()
> copies the source PTE instead and only ever sets the bit, never clears
> it, so one UFFDIO_MOVE behaves differently depending on whether the page
> happened to be resident.
> 
> Clear the uffd bit on the moved swap entry unless the destination is
> RWP-registered, as copy_nonpresent_pte() does where it installs a PTE
> into a destination that may not be armed.  A WP-registered destination
> stops inheriting the bit as well, which is already what it gets when the
> moved page is resident.

This is a hard-to-read wall of text :(

Tell your LLM to better split it into paragraph, not to list every involved
function and in general make it more to the point.
 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  mm/userfaultfd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 74f04c323c50..6495666c596b 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1452,6 +1452,8 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>  	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
>  	if (userfaultfd_rwp(dst_vma))
>  		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> +	else
> +		orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
>  	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
>  	double_pt_unlock(dst_ptl, src_ptl);
>  
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

