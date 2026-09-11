Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1535DC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F49A6B0095; Fri, 11 Sep 2026 14:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5BA6B0096; Fri, 11 Sep 2026 14:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB23C6B0098; Fri, 11 Sep 2026 14:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4D936B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:26:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2679816030C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:57 +0000 (UTC)
X-FDA: 85202312874.05.F6EC7C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 98FB320009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:26:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RZbb/QQN";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789151215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ0O0JaLtVP+XxR8QGsN0vFEwgtrJIgdHqxaxpf//gs=;
	b=DKgFseRzGjCEtM0RdsnCtdw1LhtfBT/2sWpNWokJqUr7XR1A8mnY7sdaCVEbZYqnOTEmIR
	E7Qddey5FAgiLc7G0neDFrtjW7/3cZSwosZ8ranFonJltrkjm2YqeOk64Tbozpt2d8KcYV
	eYhNhYC5sjXwAOOzvzRLjuWnj93Od8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789151215;
	b=3OzTOaWrfY0Vu11agnUAA++iVy8RrtJKmu+RVfPdyc0AZJWqal1b/DAViV3+8TggEPFKdL
	pftIaYcftuvAjL5XIHgSFyU+SgnYeW6gg6/TKNTqzS9eh+FjJ59Y5U2IExmdK4I3I8Kb0o
	rbpmEZogFl3g1abS4YP7VewIUviLy/Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RZbb/QQN";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D4E260202;
	Fri, 11 Sep 2026 18:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29791F000FF;
	Fri, 11 Sep 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789151214;
	bh=YJ0O0JaLtVP+XxR8QGsN0vFEwgtrJIgdHqxaxpf//gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZbb/QQNX947GjiHM/rvFaywRPpzDljnISz8So1ljEZ/W8YoDwh9lmfhKxMaOMllH
	 f1jlg/Wwwwt18W5lDeTYH/n3A7Gd7uFOvx+37M0qlmGQOxoW72W9dV4EcO5YSCnhdy
	 fsphlPKbsHtFVb1lVgLvymKWotj/WXeBweyF9/lEiTnKySR/AgEFuvA/JSYOr2fwYJ
	 8L1X8UJhd0OxFGuB1KiOr+6TIYDYA7FdE6cTZTIwZl92pXwKfiL7cjlLcLhpJuzfkO
	 LzHutFm+dtFAQ0Db8AKfLt35gLgngcMPJisdPRfBWmsDj598nFYBxdENzGOtasOwYc
	 upxzEE+ORsLrQ==
Date: Fri, 11 Sep 2026 19:26:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
Message-ID: <aqRF4YB7Ijk9PmRM@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234737.1340642-6-surenb@google.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qoko3c7ce6frj85u53hbo7pa5a1cend9
X-Rspamd-Queue-Id: 98FB320009
X-HE-Tag: 1789151215-813464
X-HE-Meta: U2FsdGVkX1/6/lUCXDacUO0YrPDQ8vGYCJfzH6Wru0XQkrMBf5DXAvCvh6BSMAK/q4HLP+j8TrA44DDDGYFXC6tnyET75c6tf81cOrb0TXQWxnRI22kHEznPxgQaScv6VlS1ydsUb6+ICJpxk9Gz84vAsmmLy+giarkVJ5oszgEu8h2uQksyRkhfgbH1g1T7jbFcBabtmZtP+eYyXayzQ09/yVWQ24AiiGVpBwjGIdO++sUXBE+AI6n6/uK/KK+FfiPRq39YX1seTekCBvo8BFD0ihPmIlPQw47QfS82kE7q3zhycIO5EuCRi2w2CPGrziwDWmmSKLDeMeRcAfc5dX0ORZ0BAQmMwxmMM9OrYSzPJ4HjfJ7nAQsEXr/lyILScW8IoW+DjWjo4mfQNBnxWzNgZcvt0vbQUppR+iVIRlYKN0i+/9l1/uPmaqo7G1YeBRFkHbh+CmGyoel8MsRo1KegbLN+hWzBfNmTN53M43s1eBrZSkCw9B2w1jltSepJiShmnNf2RWPnmopwzSVfh1YGJrOCUPUW49JfXDdEMPIG6wV2VHRSt17/QEPJqB01Z9wT20HSnj1JAIcdYhjhpKkjWqT2OuLhFVLGkwFTO10xKNRUiYfjEYsJNIIOL0xxkyEl+mG+N+Fe2nABg4A4aYVIinSkkS6/xOtJNSPHnMrz8FmWF4NY6HSj7SZ6Yw/ja7BmXsTE+HRrBG6PAD0fy2hDTyCBFqVhuAXys2W30X+ViQTbwdxt/qEBAJhD1Y/P4+qgzZqHJVubKc+EJ7lhPYJNQaB6HY1jdoBneHYAtruollVQlkre6WGVN+2kZe4gzlEJ7lqtUyrtQ9uU2OPt6JruX1nNWt3ZV9Kn9Hg+PlCL4pep7Tv6V5TX8zwoYcXVqbk+S0y1QsXfmrJi7br+0NECx8ykNgNMHVeAwWm2Bb1AVWesHA8ahN0mQB9HrOvFB6M0308E4c6Gt0/VNoD
 RBh0yYSs
 GvXAC7dhREMLggoCJYdJkFaKFCKj+Se57c6PYhW9IIj6giMegdjI6tCkGcCF6yauaaZg3LW/3W7jSdkYlF55TlPuu8NzezdGZ600SevfAub/d0DuFViVShmkUvQZSZ3j6+mPFnc/BNKje7ILWEoB7UNXGcNM2E4uUn11USGHgRcX7+272ItMm3pqMRZFQz4Np2aEUnvOTxUJKQIaAPVl1oAKnASXSJnvT2k9q33j6axftsLK3CLGGsv8YjsGYBj5ctGuClf89Oawafd8D/XdCcJO7cU6Bhp3whreB1bbctwHtwPgvUI14pEbdN9JK00UE9ztl/kOrRUTZrfTkSt9pt8WuRKRmTo07qgQZQJxPVgVcUhN1ur7HI+7S6x91FHypLmKwuEqsdBtBNEWDgrR7E1otN/YmKMSsN905fctfesJsr50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> proc_get_vma() returning gate VMA at the end is desirable for the its
> current m_start/m_next callers, as they need to report a gate VMA at the
> end of the address space. This behavior is very specific to these callers
> and makes proc_get_vma() hard to use for other purposes.
>
> Move this usage-specific behavior into the callers themselves so that
> proc_get_vma() returns either a valid VMA, an error or a NULL when no
> more VMAs are available. This makes it more generic, simpler and usable
> in the later patches.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Yes, very good change, thanks!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index ecce7ce116cb..9a3c996c1d61 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>  		 * found the extended vma with the same vm_start.
>  		 */
>  		*ppos = vma->vm_end;
> -	} else {
> -		*ppos = SENTINEL_VMA_GATE;
> -		vma = get_gate_vma(priv->lock_ctx.mm);

Yeah this is just so confusing as-was.

>  	}
>
>  	return vma;
> @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  {
>  	struct proc_maps_private *priv = m->private;
>  	struct proc_maps_locking_ctx *lock_ctx;
> +	struct vm_area_struct *vma;
>  	loff_t last_addr = *ppos;
>  	struct mm_struct *mm;
>
> @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	if (last_addr == SENTINEL_VMA_GATE)
>  		return get_gate_vma(mm);
>
> -	return proc_get_vma(m, ppos);
> +	vma = proc_get_vma(m, ppos);
> +	if (vma)
> +		return vma;
> +
> +	/* Return gate VMA at the end */
> +	*ppos = SENTINEL_VMA_GATE;
> +	return get_gate_vma(mm);
>  }
>
>  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
>  {
> +	struct proc_maps_private *priv = m->private;
> +	struct vm_area_struct *vma;
> +
>  	if (*ppos == SENTINEL_VMA_GATE) {
>  		*ppos = SENTINEL_VMA_END;
>  		return NULL;
>  	}
> -	return proc_get_vma(m, ppos);
> +	vma = proc_get_vma(m, ppos);
> +	if (vma)
> +		return vma;

OK so I guess the logic is, iterate through every VMA, then once you run out,
report the gate VMA. Makes sense.

> +
> +	/* Return gate VMA at the end */
> +	*ppos = SENTINEL_VMA_GATE;
> +	return get_gate_vma(priv->lock_ctx.mm);
>  }
>
>  static void m_stop(struct seq_file *m, void *v)
> --
> 2.55.0.1007.g17ff1f9808-goog
>

--
Cheers, Lorenzo

