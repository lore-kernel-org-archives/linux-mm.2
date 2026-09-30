Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389F2CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1078A6B0088; Wed, 30 Sep 2026 05:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9546B008A; Wed, 30 Sep 2026 05:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE95E6B008C; Wed, 30 Sep 2026 05:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA18C6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:31:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35C3F16058D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:31:11 +0000 (UTC)
X-FDA: 85269909942.10.6DF1E74
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6435B40007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:31:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z673PXni;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790760669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgtcnl4WXcrgn3Aln9NYMl8B1C4EpatLEtDCvkQ8/Kg=;
	b=zdEGWzJTiPIx7Y1/3GpAm7q7Eczn+WVssDlRvYzBFEtshhuxY4Cbyb1M0wHlwr2Rpwt5ze
	xLhsrTl1ocewkaGhGOdy3A4775i63/ZoGdZU5sXEoEP1V5S/LZ9+AK9/Pzy1JChSNaV0Ez
	agaDprK9c6lhJX8Kj4hpXtMS/Sb8OMQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z673PXni;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790760669;
	b=CCxvNBzWdD+sdqgmXDje+bhD3rVC64aG8niye15ES7fToDFkaRESlyBGLnUhjHxURJULGE
	n0aXvetFw2CEF9qWoSaeRis/RVWQoOjlUVy1MFIy4zdv9g00f8c4tpG3/BDVAuNfrWHsj+
	I4g2Hmrhd88M4Dqrv6mN2fonBLOyk5I=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c4f4daso261930f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790760668; x=1791365468; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xgtcnl4WXcrgn3Aln9NYMl8B1C4EpatLEtDCvkQ8/Kg=;
        b=Z673PXniYCmkJb1Y6+lYDL+hSG7gsJmNLBDbbR6sAJBffDiHnEOfN728mkSjO/pOJ6
         ktUkjUFODjCvW5ZCBZKMO35L+uLxFeB5WpkvMGht/XY7OScrZpwBEHbjm3YP/0/9qnWy
         El9+RBhxB/MOfC7J+qjp8vxFxc+YrdgIbTZF8YGcjLHPQZUR/Pj7hlmuG+YGQT95cZZg
         LG2agM/thRId7XpBxgMCLw52ONtW95oTrCvZjWDz/C8f0C8a+StRtcE5q3UOzw6U/5Di
         th+5TfpMOsqFQcIIRg9ue7i7ctSao40H9pzLKwy6kAzaz8JawWfg1ZjpkifZnhaO+PKr
         5MIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790760668; x=1791365468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xgtcnl4WXcrgn3Aln9NYMl8B1C4EpatLEtDCvkQ8/Kg=;
        b=PtCVt9ZgNeH8WkXfm1nmuQ7EKaZAqboooZ/jUibdnpeR8ECGY0Xn/Okzn9aFsIR+lU
         jJLj55WTLGJ07q+RuXhLzEdp7rc8ZdxgtdsjY0E88fS+HbJ2No7mS2kgclnPJEEWT5ng
         Ktz1pFBU9qCp1m7sUoeAsjyGC9lODW3w1Hieg4swaw5HB2y1COC/ZMGtzN2SIkKvOU5x
         7qPITW5lGpFsa/2liC2xtoTOSJdNJq4mDpGRJ/YY1ykqANsIefOFoe5hGt+I9BCmiB7d
         zqRBOhPX1Iabu4PVjxKz5TOujPycpGOWlLtVEki9w0TKHt+osVaFUXzYCR+WEcBhR67m
         FWuQ==
X-Forwarded-Encrypted: i=1; AKwUvByGzzzaqmcHyH2q3s7bQqQd2dLSF9cD9X69doK0wNdqTJr442j6mqd2dpDs2Kfzd5Ua/S9Sxc3erQ==@kvack.org
X-Gm-Message-State: AFq9FYIsufRhRpNOn+cwUkPsVxEAW7iAQ6CZtbKa/cXyBwIxHVR1Q8qJ
	UsToIM+8ReFzU30tYtkkS/BpgDT21HJXcwkDjgLNPbtmydze6XXx5E8/
X-Gm-Gg: AYBFou3yFUiuCxxR1xiFSgq5g7geyl6QRVvgTS8pXiwveIpzcTMoA25NcgSKNZzH/w2
	GTPqjwMosCvK+iqY/33/fOFd48xg0MVcVjuwD4ntEp8h3iDZ1PzUQdxZcILxASiYkq4pOPuIawG
	rrRlI9bhB0jNIVMrYwVW8djoX4xiJ1RUELvlH65+iWNCmbQdNXo/wkLRco9qWTVXsJ6DMis6ZYE
	DDKua0i2/KRr7hIXq1ekLZLl1MsvR3HNFvZfiF8nyB8iIW0Dg5IiU6TzTtRSmp/JI66RufNO0jJ
	ECzSQD0GsKCxes0L5NZAM6Vk2ga56Ytmda3l1Jjzx9Uniy1xYtH3SnHLOHL1+VjaKjfQnyrjU3J
	sfmsw31OrwTsOuYhWQd6onFTp8XaiZmIYTQAS/YiIl/x9phtwcxc6e5RiyogNmKxwLPhFlW4BdG
	+Ek115AXjmL9ERHpvQYvthxYT+vi29I3u03uNemhZ9qBgCwaUja+1yoUD7JXk=
X-Received: by 2002:a05:6000:1788:b0:488:8ad2:e169 with SMTP id ffacd0b85a97d-48b0255cce1mr1561308f8f.56.1790760667532;
        Wed, 30 Sep 2026 02:31:07 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b029edea4sm2197049f8f.22.2026.09.30.02.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 02:31:07 -0700 (PDT)
Date: Wed, 30 Sep 2026 11:31:04 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
Message-ID: <arzVaC2IYkqSb0_U@gmail.com>
References: <20260930064308.58159-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930064308.58159-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6435B40007
X-Rspam-User: 
X-Stat-Signature: 9an7r1dgt4a8un8y9hzrrfbksweyxtoc
X-HE-Tag: 1790760669-953008
X-HE-Meta: U2FsdGVkX19o++1RC1Bge0m4AEY1OpP1oPeDvcTfVxbHT7Q3nNeCOMecwuiIRY8s/Gd6680Ixi0vpVbK+2Rfw/qXW/IRBwl+ISuP2JS6qDWZUeija5MtFOb18vLYFilmYc3cUC+oicDAI30fuJUDWr+LZtioJObEEXphhuRI/Lhq/9pqkcqtFBAGK16zTvRrS6GGaScEMQofSs4B11/9PNQvbg7ct4ooW20jNZ0XYXbMujDePf3pfSf1V4e+Uc28Q99jIGYdt8PWWgTm7wIYyYVsLlQfEECvksaicizwvnGomJfd6pYBpAJqoOkNapmZhY02S/ksCcFZrcT6z8DXCiIyqFuYRZNWPWEYppJlZrdHOJtwJmD33UeWc9kUXm1cFfUEUQTOFeN0fW7Cpxw3bcm7AWTTZ5HqNasUvj6xViyG+Ju0fKNJs9lRZSxhj6esLWv97t+27IX4LBIigwqb9RuZIrOrnS9h4FOI0k2f9qOVgpBmJNNZVcvZoY1zHw/GSxiwSPPNMaSHe4b82bvvJkG4oMxoUhbh5g1eXtQtPF8iUno8Tt4ZRPf7+VkYUc2ZiINkuK2M7cfaTup6xp4Q4LzF6LsBS8uNsOEwIHelr4JmV/ydTmTyxPGa8jMqQPMDJyPwO0I5+zJa1l0HmaGt2J8/EQ1Lk2mEaAHCN7mVqo0P2xybtVZX1YwHQaXs/7vCsRbVgNdoW7Chs1Z5aDhjSqfq0oak3PpfmFYb/4it8hs/3QBPGr6rOCNYb/CWN/QtPtErtoG1Lm6TjqomQC6aWq0dxX1tQaZzP4SsVc5SPJXBo56YHPfM2MohCcbISdWII6rHGB7Uhz0g7HssomRLFaUCpZfGOZM1ILgjwtTNA8IUzGa3hl6wcMPRHEK6FQPOqqh7zWkiQorskoEzbJIaNAntC8RxFtjOkXA8B1rqYzR2iO6nMfz2GWUs3gtEvBYkvhO+9yFdpfgQ+n6vI/9
 78rEan7r
 z0bFFOJcTSFCxlmS/yTZCkJ/+Mu/VH8i7CoP2JrOgSsxuXCM92ub0ZbG8KNjoDgrIEPWNvwR2o1qOlTRAdj1gwrg0j2HcytsBOQyDQhb3uKinla+XOW9Onm7php+Ufv/QTgQwE69UXevjjrhDzXC5U0Ir+vle2p28yx26PGmANjdhEB1ka541h1/G8CRV6h1Io5fote1SEgptqpyyjnJg+ZsrsF4h53qHX3KctZNoHVZvOWRPvrXr7+8bsASv9z4Llhv0FF6fPcmU/nIgVdFRQl4oqp1/TF19W+vmIXSSVOqEXYP9lRN7xnvWuf/JcV3+pcv2oXVbFfKpEixocVlSmiQ/JUMWSRYkf+ibO9hdIBmX5eYqqc7wClxJYMEO+k9aMYt9h3EgZJ8GOUoHvMxzcoKEK5oR0Bcai52bYDDHQWpbmWPOecfgdW/Z0sxkpB+Gqos1jm3YAPz5MRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:43:08PM +0800, Li Zhe wrote:
> huge_pmd_share() always takes i_mmap_rwsem for read before looking for a
> shareable PMD page table.
>
> That is unsafe for callers that already hold the same mapping lock for
> write.  In particular, move_hugetlb_page_tables() takes i_mmap_rwsem for
> write to prevent truncation races, then calls huge_pte_alloc() for the
> destination address.  If the destination PUD is empty and PMD sharing is
> possible, huge_pte_alloc() can call huge_pmd_share(), which then tries to
> take the same rwsem for read and can deadlock on itself.
>
> PMD sharing is only an optimization.  If the read side of i_mmap_rwsem
> cannot be acquired immediately, fall back to allocating a private PMD
> table instead of blocking in the sharing path.
>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cea25773a6c95..75631101a6807 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6995,7 +6995,15 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>  	pte_t *spte = NULL;
>  	pte_t *pte;
>
> -	i_mmap_lock_read(mapping);
> +	/*
> +	 * Some callers already hold i_mmap_rwsem for write, for example
> +	 * move_hugetlb_page_tables(). PMD sharing is only an optimization, so
> +	 * fall back to a private PMD table instead of blocking on the same
> +	 * rwsem in read mode.
> +	 */
> +	if (!i_mmap_trylock_read(mapping))
> +		goto alloc;

try deadlock is not a fallback here. both callers already hold the write
lock, and that is enough for the walk, so sharing is never attempted on
these paths.

hugetlb_change_protection() does thr same thing on the uffd-wp path and
is not in the changelog.

and no Fixes tag either. does this want Cc: stable?

>  	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
>  		if (svma == vma)
>  			continue;
> @@ -7024,8 +7032,10 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>  	}
>  	spin_unlock(&mm->page_table_lock);
>  out:
> -	pte = (pte_t *)pmd_alloc(mm, pud, addr);
>  	i_mmap_unlock_read(mapping);
> +
> +alloc:
> +	pte = (pte_t *)pmd_alloc(mm, pud, addr);
>  	return pte;
>  }
>
> --
> 2.20.1
>

--
cheers,
jose a. p-a

