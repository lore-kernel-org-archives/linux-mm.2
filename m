Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE10606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bc2Z88ul
Received: by kanga.kvack.org (Postfix)
	id D89C46B0200; Wed, 21 Oct 2026 04:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A796B0201; Wed, 21 Oct 2026 04:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C496E6B0202; Wed, 21 Oct 2026 04:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A32116B0200
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:56:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7D9EA7D76
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:55:59 +0000 (UTC)
X-FDA: 85346026038.25.F8BC914
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB14280006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:55:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bc2Z88ul;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792572957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBfmRD+HTUM5tLd6gOgOmsCqpMWEseYJOLoe2SuJ4F0=;
	b=pgdjzYSVareH9TvzFSyuMDG7Z13CpznhpC7pvXVbA40sYqLPiOK0SAl04uVyr3raJ64+Y6
	ID/pwewbhwyKaJWNvjIG8gQjt3+GiyM094Rj74wvNELM8jfvE0/TQLQw2xjilh4DjFTY4q
	69SacshuT/xjm7W0tpj0zPGwshuySAM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bc2Z88ul;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792572957;
	b=Uere0bQPO0i5zHr4jh38d4M0Si1RHJdXoi3x9VPB/vqt99c4Ab+JEtfrk4DZAOEIKEHSvf
	Wfg5Eu5hedVZhMQXuPHR73d/iH2ZNlv50ZMCI3lQNcg/WaH8gUDJeclVUz2yJg7xafKcEE
	zaWgnUKL6WYUWUuRMOcfa89PSDTKx+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 306CD43AFB;
	Wed, 21 Oct 2026 08:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAA41F000C9;
	Wed, 21 Oct 2026 08:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792572956;
	bh=kBfmRD+HTUM5tLd6gOgOmsCqpMWEseYJOLoe2SuJ4F0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bc2Z88ul+Wdi6ex8pvF8klzjJkZsyRycNpC+fqEvZwhpSTog+Ws2CFQaP7yf81qtW
	 MlF5pKgAruT5Om3ovBjx44c0A70egnsrKIO5PXmJriv5wruyxcu1ATvCF4uo7MVz46
	 Dy+zxHutfuPBzrqPb0FoGLtDlaOcoUyHjJskAGpEDsJ5UJznKmNWRagAV4Jv0O2yWl
	 7ppdJbz9WyJH42i9yzbxnzJ5mGb9feE5OT1f8UZC+Un/U2hU9fL8BfMjSAtVpw6d3P
	 rZqVPie6kTOAcEB0CN+suPI8nN6r1XWueiS4WFG8NI50i35KImYKUN3ykMhzYnGVoI
	 DmmVcaxMgVkKg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7613E1980050;
	Wed, 21 Oct 2026 04:55:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 21 Oct 2026 04:55:54 -0400
X-ME-Sender: <xms:F37YaojVWrsR83031gVvpnRvGNk3M7OQ1i3nUtjEzGX-YPIOqn8LaQ>
    <xme:F37YahfiUUY-rLQahuAvVVp5w7RN08Az6vZm-EFeLqSvV14sox0ci1ARP_Jboml1W
    _bYBoANT1M0V4wDtgzP51clRTAyk2pt91gpFeuQvhxg01ryFCp_FWnw>
X-ME-Received: <xmr:F37Yalgx8LUjo11qIaCHCUxkODdZMuxBbjSrKJdpCTGR_Gisu8Eoo1tNlsE>
X-ME-Proxy-Cause: dmFkZTEBD829IPSJldAEeV8g8TjtY4+wpWNFDE0//6V1zbMXwfqkzjCBJM7vp2VnYyE6BQ
    cTG8ugeY95ZXs8su3YTJNRFD11qFtvPEio1QgBsUIQ5MzQ5NIRzzqPV+LhiBOZzB0IJOEv
    Is/kA+k7tTRpZsr4rhd2iYJlPa0vuel/YvFTzqFS7o8miy9srjNIAq5rA5ZhmXr1sADhki
    1PTJLYfs7YUNH9EZd0xT8DRRkGoeaROyYcl+3dMeasHllZRtdvYyk4Fbo+movVzd29ywrI
    xYfvHgmBtENvnnIcfdcD+ZXF33LQbfElVQbTvW9VoPNNtmzzsLfi0bbZ0ZnXfMF5I+C0VP
    VHCICwVqm0BmTISx2nQVYmvAVLhuJk0im+xr9PddCYXwiSGbxyjonOBq7evO49Rso05MmK
    IrT+nF21YP9Qm3+s1G4YASJaEqnQnpvRSA44fptB+MZOkV+hoA5xekZKOtzWHBSKt89pOT
    Qel+zTlMzKw0gcXBBOJC6YO8g+Al53ByXP+SV2kmUk3aaJdE4eVFmc541llE/QOdi7ESlN
    hc+SFGehm1l6OTHDB1JFCrOkD1oiOGIdkZhPHZovdo5EhMGShA+pfe3bb5sKVkGSl6/wYm
    CJNmydURXKNowlpHRLaTOldiFULdXb8VwADQNQ2bUihguy531D770kU++SPw
X-ME-Proxy: <xmx:F37YanNp8iZN7MgTJnXmEO6YgONTNgwcdzR7Lu91iWqMbktXcr4HRA>
    <xmx:F37Yapmwr0fJV5Ayegmk3VllttZe5TyWEKW3_tzsUHCVOlnjFKFOgA>
    <xmx:F37YameuTO_lVWqrg6KFFAbgZKzU66sgfRSXVk7jlI8Gy_qS0o9ctg>
    <xmx:F37YajuxDEhv9S9oaw20FiWHqZQrDhGlZJbJspcnqW7M3Mqn-JmyAw>
    <xmx:GH7YagAfGGfDD_kD5-HU6L1DbNvJxou9v2XGXi5OXt9Ou0SkxkuroWhh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 04:55:51 -0400 (EDT)
Date: Wed, 21 Oct 2026 09:55:50 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, samarth.colleges@gmail.com, 
	akpm@linux-foundation.org, xu.xin@linux.dev, chengming.zhou@linux.dev, peterx@redhat.com, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
Message-ID: <ath8JTlITYcXsyLg@thinkstation>
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
 <20261020055518.36087-1-lance.yang@linux.dev>
 <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
 <f6bdf823-be42-4184-87d2-fc7c128f4786@linux.dev>
 <68f17ee7-d272-4475-8a59-645442e2c210@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f17ee7-d272-4475-8a59-645442e2c210@kernel.org>
X-Rspamd-Queue-Id: AB14280006
X-Rspam-User: 
X-Stat-Signature: ftgozp3m4madzi7ftgycad8xpd8cg4mq
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792572957-811452
X-HE-Meta: U2FsdGVkX18ct0+8+pXv9i5zYk7Yzm0iqIRIGWNIcWhivYRX2M+d8/GYkR//HXiFz8aMJAxKJJbzVpWPYpOAdRyTxoO5O2/euF37g93aYFjZMjKsCf2InPLrHku0JZuuZyvqKYHfxkairZgsG28pfP12SXcde20mXqcxsHJcgVp9hTYj76lQUW8NpBNibONOImG5qYsUI3yur1rXpO5mw4lkX0d6qqFTXjfRuTfSAHP/DjkWvcti1VAQJa1g3G6u7dgfuEQJAAWXRryw5IUhOs6Qt95RrD+/vLgKEYZn5O2hUR3q3jSoNPcVyn5WKIqMsQirjnwypvzOOenhaQgLx5zzeKLW9dG+PfKtP2hMtFKM7yiw08/IEQ/FMxTPOu+UYcVqFfcKdYufdqraJfQbvyfUe894kFQ06v54s5luZP1Z01/GwHJLptIvwQMXDHJzncRka/cbJEFRkoWIGcnRHpxFFfzaTq8tkef1uFAEX+gOohawg92gGUOB2fmxrI50nf44sWCRDBntP/kY8l5q+w8p0mcgXnX9H731mdEQnytomdEX9r2JamIxwJzn869A54J+mxyqc+KCLRoOATKNk8eUA5D20EoIKgqM6OazdcIdUllwZw0og7qD8i4B58biL+UnUsUHUcyeK9HVIW/40U3qilmTwhTZDiJWhirexgMoPVjHAIjuYFYfc+kO5DcaindlQkjHOctgW56inyOg1ZqmD/y2tfPKK9gxAFMWFX3HtgaEylPVMO940NJdTRRPyF+LMlJNvTwzqRNPrIc1HRF5pyIzTeDsRyx+nRSdW2KSOvF9hAPhnOTeuoDmj5+hSBrkZ1uQkR6B0exatBw4k+gGig7oiqMGdVLwC4QlYYX8PuuQMNgA2CxPbRNqDICrA8x21KkcJxcL3pOc3siRK651qZaetWbMkcBRmXzkM12h5UTkJ4AWhffUmqy8t2Y9GDlFUQcs8pe44sL0vIi
 SINrqPH4
 PV0hEqVegnOYxcBRJUysPdY8xI1OjcCpqtlud6MaAS84NFUsgsYPCTSyJfGKbfN9GAUh+6/zHD81NnjCxlwR791B+HALECFHKT0o41aL2vWCsU2p60bfbzZe26bM0atN48ex+3ZYQ8m6VtFViDP35+DIdoEJwl8DgVEkLKCY2CkpxNs89HJ/cHunNeoZSEjf+vrGs0eDRxxakarc+mqOf77cYE6IdpIyjiwKyHccY+F4HGzYUGbDmFEJmskN9MnpzbU06bPvDEjBEMhZ/CogM4c6GsaeWrln9xTgxEtPsDrrMJTlkX927A74z52bVEhUqo6Ln0IwtW7r5wxv6NPVQt1dHNnQrP0lU5zz5NMk0Bm0Z2keHdfbGmSIHOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) wrote:
> > +1. Did it ever actually work there :) Why not just skip them and
> > call it a day :D
> 
> I think QEMU just always sets MADV_MERGABLE and later activates uffd. So that
> needs some care to not disable them. So let's rather try to get it fixed properly.
> 
> Can you send out proper patches? Thanks!

+1.

Lance's direction is right. Unsharing is not an access: do_wp_page()
already skips the uffd-wp fault on FAULT_FLAG_UNSHARE, and RWP should do
the same.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

