Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0440C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EBE6B008C; Wed, 29 Jul 2026 09:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD336B0092; Wed, 29 Jul 2026 09:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80546B0093; Wed, 29 Jul 2026 09:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4556B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:52:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33DFF1205DE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:56:59 +0000 (UTC)
X-FDA: 85041058158.04.28ED286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D445100006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:56:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzsMr9YP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785311817;
	b=T7B5o0Huzwnq1OwTi9uZ4ud3NvTY/bfvhg7WLCJ/5OavSAl/XQwIoTupJVqcFb1m/uBqKp
	Wy7eNV3encuux/rFTpTN1d+Ac2Y3aaBR7rgKDmSNiDObKD+tQ2IYxd8HM0+U1bD9SgB8K8
	b6MgVqDQpkoABoA72329S4y858a5HU8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzsMr9YP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785311817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gBMWCYK0NhtjdWG8m3a5e395PjwoFJBRWNEidKi0zM=;
	b=UAtN9LXMk1tG0NA6TIuGGxzzqcDM/hPWhrxmQyYNwm1xgyn+T7C0eGeqUY2Y7dEaeBI6Zj
	OlpuYBEnSC6AuDepghYFftV01cAI6UlsqMFlDtYRW/M6FNnF5jYlIyShgrCqProIiqjsAo
	XWA2wv/i1cRd84ocFVhK8JwEbD+ANjE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D93C60A66;
	Wed, 29 Jul 2026 07:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157E51F000E9;
	Wed, 29 Jul 2026 07:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785311816;
	bh=3gBMWCYK0NhtjdWG8m3a5e395PjwoFJBRWNEidKi0zM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LzsMr9YPpzfwRfoKTi7aoYG/YaZG6uUp2WIs0+EFHwgyofbET0ZxvnH1nudpOOv//
	 4yEI0H22nNWddc7Hvxr/Eqh6JWAV1pwUoAkYtugpiR2fLiJ0HemSCTbbF8dSuTvyso
	 xxX5qn7Ud1bvVsmymXigESsuPW77MFhjGOPjs3S3Br5rDYW8fd7IY+CjCZjM7QTu0T
	 g5oJPnu2HAtgNu1mUt9GOSE6w6nlqnmhF5x+NaOPE9RctP5QVyEsHOinZYf5ByY17O
	 fGWLni5/E7Gn2tJHDSorn520Yf2RVZitwg33+e9WWarxKekVDz3UkqOOWvhwULfRPR
	 zD092P97B7XCA==
Message-ID: <b78f734a-440d-4fad-bba8-df77894c5aa0@kernel.org>
Date: Wed, 29 Jul 2026 09:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
To: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\ Liam R . Howlett \\" <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260728204636.20998-2-jakovnovak30@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728204636.20998-2-jakovnovak30@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D445100006
X-Stat-Signature: tnf57g1jdohmbwwit3tgw6fdpnzkurf3
X-Rspam-User: 
X-HE-Tag: 1785311817-715605
X-HE-Meta: U2FsdGVkX18MZ1g/MqIr6fDl5Ctk12w3pW8qqz8lzu0xtrTK39g/sw/Qvo1xmFapHZEGqRCjk9Mi2/fLL8QDDHVRaeEBvbzHgpiObkftp0p+729DcpNr5UawHbp/UgVoVXvl1WUHTCbDLOmEbOh8QFzHPzkJg8uoXo9d5pwtjfzSC30TAeojcxgbLsAsFItiHjsCsGrXLdtIhviJxIGKkSFqYfx2lDMgcnvr+5O6vqKoRikPnrtIjldWnVjgf/NoL4etwexvesasuKY4QYOlwL9hV2iOM214A0YGXhCpTCrV6S6DQjB6dLFKP2Owtnjrf1w8HK2cyucOqxkmhw9yiMVDrhwZ3Fy7q2nfDvCVXGOXVeqCJ9rWDCx/MF9KBmgptLvcz+FjXgdCwKintPCUCM+NIdw5f0lKka0ICHp48GxgbE8Q3PdUabYtX/SVzC0az6POSujuC08i1w5cuEHUVfdQ5E8vOIE5lNkw6CzkgVYL0nwno7dR4htrAugnA433Pigf3VTQhXQgfsPsFDBweDQS9u4pX45ZjnDXUPj5abjRFDNjYFXJn2lI0DL8y4Vr5njZ/gAaOifI73B+yt7XHsWhGuLTYfKV54sqF1/J2riJA17AV287iBOazWq9IKW56w1eKoG0GlvITf3R4k6fiMsV+1DWSRtNe/90Duidrgd60e33bZOoqCrQny1CzDlrznAYuCwdpHxbOQLmnN0B+NFekxD07mg7ain8aqqV08Iyc/JvTRCSe0Y2CykBubsJ+m2LcifxZx4jLP377dnc3O2PZLXMxJwHXlZ/omqGN7EYV+I7suoUtpeax58qnV3BJLZ8Ig4pvwLv7XoVuiTfNb7vRCr0TIMRZg2lJqLvKPEbW9tMoqRN9qlPkiH4oUgPjhSdUVj9LfMxm0i746ytAFQ0CYRhaRgprI7YlpKQ1ApWYSC0YWv2nd83apSPhmmrasEkI+4kosQ2HgaLiWc
 eNIhxpHA
 Yi88day4C5R3rfaqffzVkvcf1N0EvS+1UtcstOvdwgz5CwE+eLe0izzhk6z0k7/Trez4cRIghDMVrR1V4KLqZvqB3OybbrlWGTbXPySz6Ds65oo2+JRUn7VAGAS6IkHwipnUxsfe+5H5fh911o+P8y14TH8sMgCkVE0GQL4i/21RcE2Eqc8wlm+7DCCtlP79scfE7pv0eHZdUEFBR4hNHQ6WFGRSpflWj/GGjwVDABflWKXtk+yGa7qSjlxV4l5r0OMQg71fv69nBpIe7DF/dhuFD4SvmAsBLSjUcC0ekh1xXhJemLAbyWt0c0VrAXbsjPJBVTg67n3mSN2fEWaRF1TQcm+XuZt5w3ay2YwARXQsOn67mrM7c6jng6uaQ5Bt1izQkwPhISxqwHqCLVSiSgp552oEdFHhiSf1n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 22:46, Jakov Novak wrote:
> Currently, khugepaged locks the khugepaged_mutex in two functions:
> start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> mutex_lock/mutex_unlock usage in these functions and replace it with the
> guard macro. This makes the code more readable (removing a goto statement)
> and makes it harder to introduce bugs in the future.
> No functional changes introduced.
> 
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
>   - Added #include <linux/cleanup.h> to the includes at the top of the file
>   - Moved err declaration to the scope where it's used in
>     start_stop_khugepaged
>   - Made default case return 0 instead of err in start_stop_khugepaged
> 
>  mm/khugepaged.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..7890bd3e2a9d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -23,6 +23,7 @@
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
>  #include <linux/backing-dev.h>
> +#include <linux/cleanup.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -3111,18 +3112,17 @@ void set_recommended_min_free_kbytes(void)
>  
>  int start_stop_khugepaged(void)
>  {
> -	int err = 0;
> -
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
>  							"khugepaged");
>  		if (IS_ERR(khugepaged_thread)) {
> +			int err;
>  			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
>  			err = PTR_ERR(khugepaged_thread);
>  			khugepaged_thread = NULL;
> -			goto fail;
> +			return err;
>  		}

While at it, can we just do

struct task_struct *new_thread = kthread_run...

if (IS_ERR(new_thread)) {
	pr_err("khugepaged: kthread_run(khugepaged) failed\n");
	return PTR_ERR(new_thread);
}
khugepaged_thread = new_thread;

?

Avoid the suboptimal err variable and temporarily assigning error values to the
global variable.

-- 
Cheers,

David

