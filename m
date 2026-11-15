Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDE7606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nGe2UgZo
Received: by kanga.kvack.org (Postfix)
	id 842E06B05B1; Sun, 15 Nov 2026 11:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4616B05B2; Sun, 15 Nov 2026 11:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2C86B05B3; Sun, 15 Nov 2026 11:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4306F6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4645807F1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:21 +0000 (UTC)
X-FDA: 85437933882.23.C354834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12AA7140005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGe2UgZo;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761240;
	b=FePjaAfeUlG9dzn/WPzSAeHr75Rhyooq3F7xYY8RMEVhMcyNwe7ljcxQB3jhKMEDjLhC77
	w/skf2H+N2sQbMXlb+3W+Hx+jSwcoX8Rgr2ZYlrGASRMCNZMIn12y+FHr+32PjANP+kz0w
	MrQJcuKCqkigeADzYA0x+2cYn7rCeL4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGe2UgZo;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0CXD2Q0vq8EUnqNsJucecTNroHhX6cpMIMF7MvuMF4=;
	b=Iw9j+lXORzLI8amXmlqKY1s3ZXKoKoojhZBlgJtdso7lrnTbaZD/jrjQ1RAxZQsYEhHbtR
	zPulViLLPW8SiKn5NjSIC2hdg2tH2sHBmCHJfzU3yCzXinv5kfgZlw+nHPm/0S1zG6/95x
	HmWANx2+czLd/VDbG1Eu9TUCnR69thc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9085C60CF9;
	Sun, 15 Nov 2026 16:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E132D1F000C4;
	Sun, 15 Nov 2026 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761239;
	bh=O0CXD2Q0vq8EUnqNsJucecTNroHhX6cpMIMF7MvuMF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nGe2UgZoUOmA3S/ON2JhhoZQi2srS+OAi047A29Tr+inj0K4aIT9uF2FvkHZlHVD2
	 K4PbTQOjAMdjivEfvGGzkGgy0ZZFaARp24RYM81F0ih51XPwviSjNPX/s9DjdTAAZv
	 OSTItUiAakuZy6npOTbJd/b9lf5tbItFnqlWWrtblbLKTTis3YKQrlRQls6PNhvcU5
	 b+7pVDmng4RXL3WM7UAxuwbg1+lTowDt7gmZuldEcQ6Gn/hbiPMaWSz9meLZQJv7WW
	 aLjmP5i4lwu9ioC1X7mxlp4XJPA0iwoBjXRHDVbgmfRVrOTdWx4tISMLhrVWdEt5JW
	 T38w4U5aqKnbg==
Message-ID: <sashiko-outbox-215654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/mremap: enforce the driver's page size on resize and
 move
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org
Cc: linux-mm@kvack.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de
In-Reply-To: <20261115004700194_SpQtdnE3JL6bzx51l-a5@zte.com.cn>
References: <20261115004700194_SpQtdnE3JL6bzx51l-a5@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 16:47:18 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12AA7140005
X-Stat-Signature: 6jnypujgusnbwjm6gozpke9etf8dsesj
X-Rspam-User: 
X-HE-Tag: 1794761239-744926
X-HE-Meta: U2FsdGVkX19uTp9AMxIujVzt8/BbOBPUOpSUYRTSgf2Vls5X7RW6LioVbQ3GUEz1yAw9RFhjvrBC+UdwYjonVCQsMtVMMFglm3t03/WepWeFI0pIvdyR5uMy5a8PUnSDijxBqHjghHAlaghuf/hhAdVpGoa66WViBHIseVna3R78jHelOoJ8zbM5OspyY2jjY74o99p8aAKfz59qq1bKvHZrCXytSLIlDzzOyAkiNswfBclheayFum04MtJghG+cTW+D1T6ArcMgfRyum7ICI1N1xyZ38V1tmNllP1IWAxY7q+N+dXSzSzJZN5sOptMmt2gsAicK9QIqHyxtqsIo5/poRyycTEPJrGmfUtk88U0GeL+QWp8fD9bpoBrjEGtRAgJOE6ghFA0awEWUJ0usfREbhB8LytNumXZVoUaeFeubfKl1+SC7pSmWM9xXgw8E+ZkDNhh6hWG76QqNKManjtRTJMB/nZhSZiVs5og73YUdCOQID+vqSEuRlEqpxmqasIRZ9+dLZRkSfy7gcTIiYQslHfSnQSUFERVCZSVSWqdb5YXOht9X86hiQtyx4hkrDbUrNoNtYioSyhB8JKfwXLaUDCkFnbiXV7teApWq7fK8DlK6ZIUNj3qG5EckNpS2NY2jon1ekUv0vOCmVTVvFGQURLxadXe4REPYhHe7Y7yxKlq9SgKATFbFopLDvqf+qGicpxnVdkNhLLFfCXzfLw2TlNeFSUJShlvRt/U7IpnQimUkVMpIKjDNOVovI+ewv1Rpf+B6inYtxOqWh04e1MmtlywWKI5QuyXPlGahFTcZ3+Yz3LsKjozJUCgQ/V20NSA39VpzyO8EHsfbu7P0eiKdK7aFaYzrQ1zCQNMbGz6uR8vCgrtc16QzI73DwYQjCuO7rwDN2yrcrUHuYKp/Z4+k/6j0/W7n5xJxabJaAquforQLGZdOWAunWYaAbPjoiHgmGD/h5rastJpaX7s
 +dZ/R8na
 n1E/A4NcP7dGsHjxkqn8QZpNTGPPwc2dS6l0i6jGMal9llarhQcl8FFKfIE4ladV8BHdjmKjIL+IKkoYCwiLX37/nfTFhnJjryOfFPweqXiHVtjf7SuwSRrlk3nan+u1aIxkVNJwLs3Od3aP+pF+pix3fMOGg+hdowaDAuxdugEypdDaKdkm4ehZMxNRNDdLUSGR1mkdmQU7HtAvqEtRH+f988BnzS0cDtKVBRbpzJh4SadgPlZp9MronYt2TIDzHa0H77EajvrlShOwfRYEvLWVMPPzMi4AKUQ5s4ojuLEWT+a/UwP0i4T43zTclkd+gU9NDMGwJGXub2IYOsdzEdBsw3/vcCRuPdyRHVQB6XG8RPkhYNAHYjNC2Hc9YLzEAhYChvNQ8hXNifuCpotuhVjOpi+G/lCrCq0f4RaghrdzEHDzLc40FvkzLk6C8fK8xdQ1jATHxxCqgPSOeXXuwu/ByAh2WbkwmGhlSk+itaKwDzSEyi7ycAglobOt8Gy9IVQPhovVB5GdGfgrwru2RBxuMDkKaAgYgTCNCzyWJaaPyxzqNIhP1b0xHc/CeLmyFAb+hNwSXSAwsdCbDOqPK9eJq4X1lfvsMWA86QlJQXiSw4/Vh5KCDG9EtbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/mremap: move_vma() checks alignment after mremap_to()
  unmaps and shrinks
- [Medium] mm/mremap: vrm_can_expand_in_place() causes -ENOMEM on
  unaligned expand
- [Low] mm/mremap: duplicated subject line at the start of commit
  message body
--

commit 0a9d27ac6fbd8948362259538484e3729c9ccd36
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/mremap: enforce the driver's page size on resize and move

This commit validates vma_kernel_pagesize() alignment of VMA boundaries
when moving or expanding a mapping in mremap().

> mm/mremap: enforce the driver's page size on resize and move
>
> mm/mremap: enforce the driver's page size on resize and move

[Severity: Low]
This isn't a bug, but the subject line is duplicated at the start of the
commit message body.

> diff --git a/mm/mremap.c b/mm/mremap.c
> index fff0465f5e061..8a0a406bd78d4 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1406,6 +1406,17 @@ static unsigned long move_vma(struct vma_remap_str=
uct *vrm)
>  	unsigned long hiwater_vm;
>  	int err;
> =20
> +	/*
> +	 * A driver can impose a page size larger than PAGE_SIZE through
> +	 * vm_ops->pagesize(); device-dax exposes dev_dax->align this way and
> +	 * rejects any VMA whose start or end is not a multiple of it.  The
> +	 * destination VMA spans [new_addr, new_addr + new_len), so do not
> +	 * create it with a boundary the driver would reject.
> +	 */
> +	if ((vrm->new_addr | vrm->new_len) &
> +	    (vma_kernel_pagesize(vrm->vma) - 1))
> +		return -EINVAL;
> +
>  	err =3D prep_move_vma(vrm);
>  	if (err)
>  		return err;

[Severity: Medium]
Does checking vrm->new_addr and vrm->new_len in move_vma() run too late
when called from mremap_to()?

Before calling move_vma(), mremap_to() unmaps the destination range when
MREMAP_FIXED is set and shrinks the source VMA when MREMAP_SHRINK is set:

mm/mremap.c:mremap_to() {
	if (vrm->flags & MREMAP_FIXED) {
		...
		err =3D do_munmap(mm, vrm->new_addr, vrm->new_len,
				vrm->uf_unmap_early);
		...
	}

	if (vrm->remap_type =3D=3D MREMAP_SHRINK) {
		err =3D shrink_vma(vrm, /* drop_lock=3D */false);
		...
	}
	...
	return move_vma(vrm);
}

If a caller passes a PAGE_SIZE-aligned new_addr or new_len that is not
aligned to vma_kernel_pagesize(vrm->vma), mremap() destroys mappings in
[new_addr, new_addr + new_len) and/or shrinks the source VMA before
failing with -EINVAL.

> @@ -1577,6 +1588,16 @@ static bool vrm_can_expand_in_place(struct vma_rem=
ap_struct *vrm)
>  	if (!vma_expandable(vrm->vma, vrm->delta))
>  		return false;
> =20
> +	/*
> +	 * Growing in place only moves the end of the VMA.  A driver page
> +	 * size larger than PAGE_SIZE requires the new end to stay aligned;
> +	 * otherwise let the caller try a move, where move_vma() validates
> +	 * the destination instead.
> +	 */
> +	if ((vrm->vma->vm_end + vrm->delta) &
> +	    (vma_kernel_pagesize(vrm->vma) - 1))
> +		return false;
> +
>  	return true;
>  }

[Severity: Medium]
Does returning false from vrm_can_expand_in_place() cause expand_vma() to
return -ENOMEM instead of -EINVAL on an unaligned expansion?

When vrm_can_expand_in_place() returns false and MREMAP_MAYMOVE is not
set, expand_vma() immediately returns -ENOMEM even though virtual address
space is available in place and the failure is an invalid size alignment.
Even when MREMAP_MAYMOVE is set, because suffix_bytes =3D=3D vrm->old_len h=
ere
and vrm->vma->vm_start is already aligned to vma_kernel_pagesize(vrm->vma),
an unaligned vrm->vma->vm_end + vrm->delta (=3D vrm->addr + vrm->new_len)
means either vrm->new_len is unaligned or vrm->addr is an unaligned split
point, so the fallback move can never succeed and may also fail with
-ENOMEM in vrm_set_new_addr() or check_map_count_against_split().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115004700194_S=
pQtdnE3JL6bzx51l-a5@zte.com.cn?part=3D1

