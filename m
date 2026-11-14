Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA17606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mFAi7a1Z
Received: by kanga.kvack.org (Postfix)
	id F26766B05B1; Sat, 14 Nov 2026 14:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7486B05B2; Sat, 14 Nov 2026 14:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6616B05B4; Sat, 14 Nov 2026 14:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA7D16B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:15:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55637A8019
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:15:04 +0000 (UTC)
X-FDA: 85434677328.03.CC9DFF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6F8740003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:15:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFAi7a1Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794683702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxIGxW5mj4AmLJ2XSq7JP5/ux91S+vD9k4XlY+cOKHY=;
	b=T1aqGc4MucNbQk6iELMp7XRBYvlaVx61lvPXRS5PWLeSZBDJqgQgHbMwpCOPfZi6muJ38G
	3KehkCTINSLiAYIKG5yjnW5VlfDhafFJpa68XR8ahZorqmduGDyrusv4qJIJ2glBxCXde/
	FVnytITetJet6BwwfGIM3wPVW+16GWw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFAi7a1Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794683702;
	b=bOlhHyQN/ZBneKjotigjmyPV7Ql7BCS7BxD2q2vXqSFLPs5ZEubGlukEwvxIZSktH9dTnB
	jETSRawpwdMX6qvnoRWlhrnZwl6ZWr2rqf71PwrMhOFbnpT6MVCvdbtIL8B/r8fHTdbRSm
	f/Dfe3YFjikhPMGzINe2/MPzBdQ3jUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 149606025A;
	Sat, 14 Nov 2026 19:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0091F000C4;
	Sat, 14 Nov 2026 19:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794683701;
	bh=CxIGxW5mj4AmLJ2XSq7JP5/ux91S+vD9k4XlY+cOKHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mFAi7a1ZIpLa2CEvrTYh3I3O5I1TIHTIjjd0teQAm2AmtminmHpEFJ93Qsiz6UOGs
	 yoFFnNjmaH2Zojqx40I407yGLpWJv2+e8JFVAbW8Ew9QP57tKnMyxeLpi4BvttATT8
	 056bWkSqKSkSZALWEEFuKc/RndyWB8lUwHU8sffNQtMVDMEk5gRDExyUSRwGdO8Q9n
	 k126jyGSWGOqy1D3WfHipNroDgHU6EwzyuRV4BmTkoECcUEHym3wMN7g/8AGcNRKks
	 OZf9HC1bB33Z9kek0NAgJPlb1qHJxf3bD+0soLtHkhrnxe/+Cs4lLbwtnZN+y+tOZw
	 749qtvnOpRBGA==
Date: Sat, 14 Nov 2026 19:14:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Oscar Alejandro =?utf-8?Q?S=C3=A1nchez?= Lucero <aleszlucero@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: document missing struct members
Message-ID: <aviy0N13YR5R-60T@gremlin>
References: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6F8740003
X-Stat-Signature: iisza5tkum73mrb4on5df6fmik6rphcm
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794683702-250628
X-HE-Meta: U2FsdGVkX1/vsy3EsEUR55TGgqVmz0Ke+s1lfwiTyn5b49R8quWcwV9EHmk2CvjZuC0ROWUXtRjajFz3qrI28g1IJEhoXaRMIUc2sMOARky/QsT6iNEdWA0UmkdqNng3bKuGj5Rl8eNMHLUpXx5l6PWRn3p/g5uY801U0RlQtKMULbDd/AvhbwajmpAWkFP3shIpQMNTEXdicmdi/APJaHz8APTSN7yIRQEx5ozEmKh/4H9R9lOaOOip5YWYelCc+4oa+N5jU54roaM3SdgacqdtW1sChjVlqwTLMF1Y+mCWB8TtMCrdlcPscNbdOlIKlcnAyX3/ENC2FVlTdU6PO/4XGAZAXQaAAqxKdqMbSFMXNyfhcCcTatRCz1ofystpIOVNQPK92nan66yjDILi923b1uwF2lV5iVAknCtcTkBUKJ/ki3QaBCsn8sNqKaZRr3v67DRx1wqX88LIJYiMXWTeklx8rEHYSKRhpPc9Iq9gO4m+iV/nPGJx0S0vyhHxTPXshvuMADnxdHOJ1wodqGZwcVnAQOfsC9lqx8pzT0NRbfxk6EdrStBN6pAA1yColO/StEkqy+Dae9w8yBOTk6A+wn+WmCj5u5t0idBMu5EgBrDOzYsbpgE0U5PTZF5cy8wy5x3725bGTg6ybfRPKZyZeg3IKaHfE2OfK9tVaghMoXqiS4i2rC3Z1GgLaEE9nyoIQhG3YEkHxV0K9xYC7PJmPOwoXsH57A0GPZsptmZcYb3X9y3Nk+8Zd4OV6sN9nMq8A/VyGLeuEV1b58jyqE+5mAbMvwaVlqzM+Nzq11lfakDPaHmla/GVpQUF7KIC3Y1exeUa+b7NlHhlPUfKijfh2fZczquWrfeaaHMN+/YuzhRMJp2Y+3NdCTYNqzS2DDxS3nZI1BLTbYboUmd80jpSAUOtHvikOM5ErUTC1TnoDJLBokLaAVpUAuUlWmhX29pHRr3cdAy8PHZAjpH
 GYx+cc2x
 ZL+zSlL3hknjsvfuHYr13M55glnitXyVS0NuCM4H+lCcBXrIhsHGk98H7l9Twc9nnC5YPw4yo8m7PauGEyLuUTpXZoYyl7p0P9Q1nZddGe55FKw1YPTiZ//yb1rTwwDtqkq2jmBS4HBv6BQN+4QJ6zBBTz5RWCWoKrYW7bjtohZaYCmvqnIXbl0aKfbKh/Rdc0CB3Ifqjlit3Tk6C3Z9bIX3cCrjzhze4IE3/K5SJPQ+olGiZNZyifhsq/vlHTo5jf72skRXvjyMrnRhQ4+I6h/KuaQSrcOoL90kJI+abvjnN6f3iQN1X/QcYE+GutlI/Z72y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 06:44:07PM -0600, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
> for @ptep, @pudp, @pmdp, and @vma in struct folio_walk. Also fix @pte,
> @pud, and @pmd descriptions to state they hold entry values, not pointers.
>
> Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>

Looks sensible to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagewalk.h | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01b..978714d5e32f 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -63,6 +63,8 @@ enum page_walk_lock {
>   *                      install. If allocations fail, the walk is aborted. This
>   *                      operation is only available for userland memory. Not
>   *                      usable for hugetlb ranges.
> + * @walk_lock:          locking requirement during the page walk (see
> + *                      enum page_walk_lock).
>   *
>   * p?d_entry callbacks are called even if those levels are folded on a
>   * particular architecture/configuration.
> @@ -161,10 +163,14 @@ enum folio_walk_level {
>   * struct folio_walk - folio_walk_start() / folio_walk_end() data
>   * @page:	exact folio page referenced (if applicable)
>   * @level:	page table level identifying the entry type
> - * @pte:	pointer to the page table entry (FW_LEVEL_PTE).
> - * @pmd:	pointer to the page table entry (FW_LEVEL_PMD).
> - * @pud:	pointer to the page table entry (FW_LEVEL_PUD).
> - * @ptl:	pointer to the page table lock.
> + * @ptep:	pointer to the page table entry (FW_LEVEL_PTE).
> + * @pudp:	pointer to the page table entry (FW_LEVEL_PUD).
> + * @pmdp:	pointer to the page table entry (FW_LEVEL_PMD).
> + * @pte:	page table entry value (FW_LEVEL_PTE).
> + * @pud:	page table entry value (FW_LEVEL_PUD).
> + * @pmd:	page table entry value (FW_LEVEL_PMD).
> + * @vma:	pointer to the VMA (for internal use only).
> + * @ptl:	pointer to the page table lock (for internal use only).
>   *
>   * (see folio_walk_start() documentation for more details)
>   */
>
> ---
> base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
> change-id: 20261112-pagewalk-doc-d4f0de5c03c2
>
> Best regards,
> --
> Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
>

--
Cheers, Lorenzo

