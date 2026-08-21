Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FEDC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957066B008C; Fri, 21 Aug 2026 14:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BBF6B009B; Fri, 21 Aug 2026 14:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5F96B009D; Fri, 21 Aug 2026 14:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E35C6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:34:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67C0780233
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:34:51 +0000 (UTC)
X-FDA: 85126127982.10.90D47DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D2BE44000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:34:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VE6JOs5Z;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787337289;
	b=FC+FV8ALOnjsojCPJ/Ay3BGgzOdR61XBRDBz4it48MUvLjYvv3yTEfiT1qtGDxFXARaJA5
	hzIC1dXGCycLca9GX70yc3Gpk1SMHl5SmpwY8FlhuiuolDutcpGw+Qcj6ecJQLsuf2zcx4
	+u+PnlzxhcocNtL4UW2qNmUeIiKYNAA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VE6JOs5Z;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787337289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMBCnKRxKdS8Q3i2Mwvd1NJnQGm8tP9hnWkr5qGiIIk=;
	b=etZLe1zUe2/Gcj6DsMZs/4PFgq0QZVdhJxOtxlWKv8Qij0KuViMdw/xrgvnXA+tbpuXENE
	PPJd//wC3UZm1iDf6CNkWF+ekrBDKzlq23QlebRm/iJZcixlq1dNaXuFxXX/TCoK7uGWj1
	ICmi9v4LFuhK8cxhrd+8WpfeN1NkHKQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 220C861126;
	Fri, 21 Aug 2026 18:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F3C1F000E9;
	Fri, 21 Aug 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787337288;
	bh=oMBCnKRxKdS8Q3i2Mwvd1NJnQGm8tP9hnWkr5qGiIIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VE6JOs5ZJj3dEjBzNPO4iPDfwuEjv0FsIv+vdc8KAnBGDN/QyXvPtzibDYbgCaNB+
	 0qKQDP7MVhwfGi4k8B3e5K3OgNolhxfJ4A6wZnnTYQFzqZrel/QFBM7QcLzRON1VA2
	 LazEpVjV6bJmbfnO2imsIZUM0mqHw4kD6blPmx+UpT1lUA2lqkJRbDWFZ5Umqd56/S
	 LlNgcQcce4ULiYlUhok3cGbtugaiJxEgWRfzd+HqDvXBBRk47VVPvUYd7I4Gq/4PJt
	 aWDJcrVOZbmLbUu5lbHdTfLcpSOkTNZmfg1nD1l0OAGtiGJgcy4cWISjaFOf0C7k4X
	 bmw4bpPl83HUA==
Date: Fri, 21 Aug 2026 19:34:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] proc: refactor /proc/$pid/mem to use struct as
 private_data
Message-ID: <aoiXvKXQK__0cSWL@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-1-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-1-90cd2357ee05@google.com>
X-Rspamd-Queue-Id: D2BE44000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jsc4j4a85njyi6gmhjbd9fyn6onhehj3
X-HE-Tag: 1787337289-439746
X-HE-Meta: U2FsdGVkX1/OlTHHeeqFMfaOgb3GSc/XozM8QBbk2IxAm08/jmdRlsdMNDiqXCjxovI64tDjPm7zJRX2coTmPnkv2XZ+pnmCu2mBun3gI7JK7fbaML/cp9ohdkOpuNvD9lNSuFQnNGaunuc//W/aBTLPocGuvjOoABSQYbmm6O0Cmt2UgriczRqRARR3+0qtf8SHwUdHOP44heahNimn+gex8zq25RkEZjSvGsar0zuLpi25sTr8VxW1GJaQmtL6bCHkat3CfT+kO5LTAsUmJkiORuT1i9ZfdJJXXOwq0vY0a6l2q1cV2dmcABBbJDd1DusJ6l3v26dl8/6Ol7MLifZtl8LDnBsHbynezkpirAxgnKBX+QuETsYJcadu34v/kq5NzFiKOplNSaEG0mrJRtB/krpNU1LgmbcyFBBbtU3zW7E5UY3yyF3SWCGCvnBms+APXFuQa6fVQk6rfvwPNJciWJvOZnPN38XT2vi0ov23sGeSdcQ43Sj8CMZgGVmcTQuS00bnHWnwGifR82oLwIegzFzYcvy5xaAijv4RwpEpX75nkvVUjF+Vzyp082tpNyDoNV6TV2PNGf4IlDJJXbnysky89tKzQJGBnoYug9lhfeSdsr4+63LNJGyJE5X8a942vR9WiLP+z/9lYeCC+zZckb+kcbj/KZR8UJsMk7/V1nKRb9nwmlJpkKsxCDCdKIuXJvdx2GLX9Z1XwLQ+OMNLBC13PPh2y86CKh4bIg3VkTbSH4PHBW/DoXSzccxoEU1CdbwKVz8/6w4MjQMv+eF215LAT9cAkkEgvDPpmACLMsp3nlEhkF1/BkJWZVkIfVqug9CFYMFZpmi66raqI4yWSNT5PFViRDIZLl1W+tZU8UkC5PfExW2Qw49g+My1GzwADr9Dk1g/YcVx8WH9Kn76B+xS0YvAGK8IiDQkhklWzE1N2uW9YGtX1cdow+bniN/+LctwHBPH6nl3t+o
 FRSywUse
 pjJeah1+WTWg/OPe4Aap5Sztc5IgDtENq4aq+tTlfPN/H81OrIGGe/jZ2XRVWIdTDq9PhECLCogZwUCTJdZ67VEIht0Kf4paHKOvOW6sDU/cmC5jELANCQU3f0TyxCwEpW1/icclwQu42gXksLU7oXRlOPJ+SXAvrB+HoPPqOZs3+WjNcU8FSyuZhvofev10tHALem0owy5rpBdeT5teclAlrAISLDfjJhYistsuyuCHBqZVwVF1jPRxxqmZxXZXyO5AOqovP2CGpdmr3gVjBWr3M4ZELg5lvoZp64MCd5dLFWfR88wOD635WlgnDmp53ddSpL7wV97kQhnxp0i0YOtF/0nN0hiBg1+7TdPZbazNMFh86k1GODC9McA/DmEgYP/xdNRIjD4HKUP7GKMgNVFjQX2X9B2Ljx20rGngh7xl8tMT1fscgPmEi2CRI50o6rhijzA/lczqgF947jkKeEA+Z/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:51:05PM +0200, Jann Horn wrote:
> Refactor the handlers for proc_mem_operations to use the new struct
> mem_private as ->private_data, rather than directly storing an mm_struct*
> in ->private_data.
>
> This is in preparation for adding more state in mem_private in the next
> commit.
>
> Signed-off-by: Jann Horn <jannh@google.com>

You had me at helper struct Jann, you had me at helper struct :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/base.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 780f81259052..bec6197329dc 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -848,11 +848,24 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>  	return 0;
>  }
>
> +/* private_data for proc_mem_operations */
> +struct mem_private {
> +	struct mm_struct *mm;
> +};
> +
>  static int mem_open(struct inode *inode, struct file *file)
>  {
> +	struct mem_private *priv __free(kfree) = kmalloc_obj(struct mem_private);
> +
> +	if (!priv)
> +		return -ENOMEM;
>  	if (WARN_ON_ONCE(!(file->f_op->fop_flags & FOP_UNSIGNED_OFFSET)))
>  		return -EINVAL;
> -	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> +	if (IS_ERR_OR_NULL(priv->mm))
> +		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	file->private_data = no_free_ptr(priv);
> +	return 0;
>  }
>
>  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> @@ -880,7 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  static ssize_t mem_rw(struct file *file, char __user *buf,
>  			size_t count, loff_t *ppos, int write)
>  {
> -	struct mm_struct *mm = file->private_data;
> +	struct mem_private *priv = file->private_data;
> +	struct mm_struct *mm = priv->mm;
>  	unsigned long addr = *ppos;
>  	ssize_t copied;
>  	char *page;
> @@ -970,12 +984,21 @@ static int mem_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>
> +static int mem_release_with_private(struct inode *inode, struct file *file)
> +{
> +	struct mem_private *priv = file->private_data;
> +
> +	mmdrop(priv->mm);
> +	kfree(priv);
> +	return 0;
> +}

OK I see that we mm_grab() in proc_mem_open().

> +
>  static const struct file_operations proc_mem_operations = {
>  	.llseek		= mem_lseek,
>  	.read		= mem_read,
>  	.write		= mem_write,
>  	.open		= mem_open,
> -	.release	= mem_release,
> +	.release	= mem_release_with_private,
>  	.fop_flags	= FOP_UNSIGNED_OFFSET,
>  };
>
>
> --
> 2.55.0.737.g08866a6d13-goog
>

--
Cheers, Lorenzo

