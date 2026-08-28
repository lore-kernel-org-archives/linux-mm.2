Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAC6C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DFE6B0088; Thu, 27 Aug 2026 21:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BE66B008A; Thu, 27 Aug 2026 21:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F8B6B008C; Thu, 27 Aug 2026 21:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD5AE6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:10:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6307512022E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:10:49 +0000 (UTC)
X-FDA: 85148898618.19.F36E5E5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 929D01C0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:10:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="Vh/OmPnJ";
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf18.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787879447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2FIz9UYX+IlSwKp5E5JXDBaBYS18bmjz6r6fwuVCck=;
	b=6ixp7IfGO5cAWuWjLSkCqHHVj8yxrm7LU0fwsvjc4J2ADjSDFGOp0008ZaYtgHJQG7nTmY
	czhss1X2cuAWdLt6+qdXEQLZ0XYB7uZfCr4dZ3+IIX+NYvveg/TTfJAvcdT/LPbyiog97H
	e4Y0mmTWSmhAh1u6QC3UeJIMv28wqSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="Vh/OmPnJ";
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf18.hostedemail.com: domain of paul@paul-moore.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787879447;
	b=8CfMMUQqv4c0Y5MDsts3qJPHFFzIDvUEicmXzquHlYNzbfFNuD5EqOgMr2CNvc4Ko61Ojb
	TmC2a7c+K2I2icDB4xRzkBhKBoKLfC7TVxYtqmzxJURqUjYnALcSqifjhow/64XNeXvwJ+
	1fIMhCBySPgh27List5YI9n9al+KPnE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52f1a320162so3609961cf.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1787879447; x=1788484247; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F2FIz9UYX+IlSwKp5E5JXDBaBYS18bmjz6r6fwuVCck=;
        b=Vh/OmPnJRG0oFh/mJnYh6FERtbX9GD9+Gg1LpwXaumwbatdIdu4B2ZW6xuHNb67fwD
         Y9NS5ByIJchfqdqbWCJV6ttpR2L9ubg2nmlc0f5jcIvJAaHyGXGHLuLrWjg78Ax5RkEt
         lFBpJAlCOSbEPbNO2BO3u/OElcpAQrP0JQuTaOtgx00IgdCxEzlqELUu1BHGnGl28wVP
         zJuwVQ/x/zTq6HWyR3kdum4AeXhKlbLWfG2A3kG8AB9RkV/HrhqHN41grBjPBu/JV5XU
         Nn3epSheZ1r/P6SBd1qNepoejqRpunMC0q3Uh7KskFJfhTgFJqAxQBx2uI+z71IgW/PZ
         UvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787879447; x=1788484247;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F2FIz9UYX+IlSwKp5E5JXDBaBYS18bmjz6r6fwuVCck=;
        b=QjoJfBmhU99NHKaUuE2X6jDHY1MG1U4rNnpRPN1ENoeo9yoZKrPzkLXRyOjbmlBcLT
         c0F1xSyE63BRxe0EGe8Sy59VE9gaum9wjQsCfIx70XpanY4MJfBxdgpBSh0oqV20I6yL
         oioRnLEiBW2IlikVEcIlNmRHld9BI1pznbaVepJbbXkpdJn28WB4WhXESQLLW6QPrkOm
         wVc9tQhbsksdhyMwtPlM8noD4MopTL6hptYyggY79iQafAfTljtljUVkq2tmz+ZQXdez
         EUXRegVlVMFb7olO0mND3qYB+gklIVxKEPK05cTJoqAY50Tj39cmPe/dh08RipC6YLtu
         n/dQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTWdC+5veU5biZ/79ujDwmoaeFTOrKgZ6tEvhk8Wmb3k4JdHEOAHhk2pNw6PBFxMxdhsAlV0uyYQ==@kvack.org
X-Gm-Message-State: AFuF++mRwLmoiZgyZeEsUCnRV9D74WlU7SSYECEHvCattWVHKGBqBbkm
	/h8ikew0K5S+pDpcyaTM41pkDyBNGOZShKKUYjt+iIqpLWsMrcew61QrN3AFZS6MmQ==
X-Gm-Gg: AR+sD11/jTpNRNSgnhgO3mOLfX6VizNRKpCBN38nPo72t9re7aR6byOJPws1robmIh9
	CyUY/+UrHQHbzGAuXFfvWqATw/t9XHPx+SL9sIQxwh8wHsZVzg4JW7VqfF5/O4mnKEdqbJfH0iN
	ghEMgP0/AVYoe2gCOyravQ84DbkT3rPE4kJmWbVG3nPY5kJQ2lFvQKAOqj5KvJsE2uxCHeKWjUl
	6tT6wEDLhT4ffqHytlJPzoKUBTxFvXfU+H4IBbJ3couNgqN0zCZg9Pwghuw0Weg47dPs4NtVFul
	UD/V0lbxRSBfSQqq9cukZnxJcM8+hnsXazn9VASbzXWF8z8K9Mt67AQZSsxpITJi0Ouo8fUNZEf
	VY3HEsRU3n3ky3b10Q/vVEPblQGRxBvKa9UXa6nJ8u3mS9RQORVUYnJNhim/EzyAJiglOXHiW8f
	mrWfgsotemk9aVXeOPBdD98n0ygUT4nvrAnpEJbsJ8QT1aAMkK9ajuUKOUt+2q8zsOqqU+JPFGC
	TXROBtSFlbHU7v9OgX9L13nFw17lIISdA==
X-Received: by 2002:a05:622a:6118:b0:52f:64c4:8094 with SMTP id d75a77b69052e-52fb965d4a1mr42496571cf.39.1787879446638;
        Thu, 27 Aug 2026 18:10:46 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe7f9bafsm2634591cf.19.2026.08.27.18.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 18:10:45 -0700 (PDT)
Date: Thu, 27 Aug 2026 21:10:44 -0400
Message-ID: <82929c994076d95f99560ecc67f6cfce@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260827_1122/pstg-lib:20260827_1501/pstg-pwork:20260827_1122
From: Paul Moore <paul@paul-moore.com>
To: Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if  PROC_MEM_FORCE_ALWAYS)
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
In-Reply-To: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
X-Stat-Signature: basooz6dwxjpj6191k9washndhocqod7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 929D01C0002
X-Rspam-User: 
X-HE-Tag: 1787879447-571224
X-HE-Meta: U2FsdGVkX19DvWeVDjEhAExru9kkqiT3AcgzJMY3SAut5xLztQjFq3H96OFJUHYi7dgslf9rl9nQ1YA57MKgPSbRvph003CfZrG8ChrvaKgTf6INDD5qXsFcHy3oBYqvqgiKOyTtaVEyIWIqiyBU2vq09pkXmaLDv14fSHitaaLPK6Izz4ZF+wFRRloyI8fTlFLJgv0cAdimlGutAHF1hf4G/YzdsdVfCunFbrUvojHxsuGSAFNw8ocRerFH0rb4alBBu7DGbMpeb3Ra4R9NflzQArAaiiqVQdFuV2FVdlEeHK+wFF92tf2jbK0GLV8o9bxo1jFw2jpWsS62ky5/HDAvHjS63hP2ujvKGmGuov5lhBd4RH1xho9svqKwrCpmNi9LbZbvVlvBs/2k+crQHvD1SxCkHPMrlLK8M29nfRAJvEZ5Y5evGayIMFkeXA3MEZ9P1CIzwiRrV65ZiqjuCPuw6yKSOM4ryn6HMySFRIlkeD3hmz6/u9XDtcBLjhI3WBV9EqBbNOFSp/XPiSJhyzSfPsZxt8DnGP9yGLcCLNlbNhGlWGJyqlxK8/+jegZ8dZFXWrhTOyT1h3WwI91xdeGA8E7FX3tqsqvPg4va7K+ENF+Iy2XQxBAmJR6TCk8cseVr+Zk28BcsPTmwKau33G4yJimWVRmJzemss9nTe02FYJ+KvxH+g9YB5zlLU42CY+dATRJ5d2xT7j9bXBpUDVXET/vN87RDqH6cFUzWtg1WLNx0lIhq95mpLy4dgYy6tXcPbAfqiHuEF8GKPLcqOJxKw7+MJ0Whw6UCnsuQQagsDGChVmXFAHBuaxk90SBkOECTsKVLT6W2fZRKwGnP6K0TBUq8jv0mLVeTDDok1w6FbAwVHWnH6EkkMsCEZ91nER6/mpzQEV7nyijOA/t5iPwsYOQkxPhyOj6nEBG1qDDwGELw9Jn9fl0SVPChLjnMJQmVRRph1FYAbBbGSC4
 9Rge7goG
 huVUhBWjYpy/vx/SaHKhUkp2/9m1BLgqTFNN/Iyly05mSNUiYBo1fTMnuDJ+W6zGfjFV0yhks0B5kz9K51HVIRu0bZkkP/U6jMFQUPdwGx9dFOcPccVXnf3brVf+9qwbj+vUj+7BkwKZocIfWd1Hw+14445HRGPCnkezIxf07hS1XXtnXgIFaq+FMry9mSONRzUfqET+VtwgfyDwLX1fVBnAPdQX7JQHcLb9Cx6uUvfgNeyvjAP2i08afbA0vLa1+etKrjfZy/yPNQovDLZJhL4ANUvIIcBH7d/+1XRPi5N7/SBFUIR3eY+miEjcgUOVgLYJJkaMVuHUvBdvPzF0TqiYB1HZ1OBXplpTUJPZ0n8scnOw86eDmtj/RNlT4bgn/zHJPXMnNf+lLKxPHVAPjCcxTnZU77Ofon09JUN53xdzggFZ+0F4caAExqe8LnpQ7GvJYKWVkvmyPSX1zRy5SfJgjoKUzoIANqKobj4gbGzw6okpJqVxmmtPFP9MzASuwBB+6SVpP/NJ8zcwkg06NoWr8Uickeq8E669mIK4j5YRyTiZwINaXQDJ44/P0GjJrtkHNXL4bPS5ca+VGzzIPjiXmTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
> 
> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> good opportunity to block a process from overwriting read-only code in its
> own address space through FOLL_FORCE writes via /proc/self/mem.
> The security_ptrace_access_check() LSM hook is bypassed when a process
> opens /proc/self/mem because this is considered "introspection".
> 
> This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> that a process cannot create executable anonymous pages.
> 
> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> accesses are only possible when the LSM allows ptrace() attachment; but it
> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> environments running lots of third-party code, such as Android.
> 
> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> such "introspective" accesses.
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/proc/base.c                |  9 +++++++++
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/security.h      |  6 ++++++
>  security/security.c           | 20 ++++++++++++++++++++
>  4 files changed, 36 insertions(+)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bec6197329dc..dc6fdcb47b79 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>  /* private_data for proc_mem_operations */
>  struct mem_private {
>  	struct mm_struct *mm;
> +	/*
> +	 * Was the ptrace access check on open bypassed because the opener used
> +	 * the same MM (introspection)?
> +	 */
> +	bool opened_by_owner;
>  };
>  
>  static int mem_open(struct inode *inode, struct file *file)
> @@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct file *file)
>  	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
>  	if (IS_ERR_OR_NULL(priv->mm))
>  		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	priv->opened_by_owner = priv->mm == current->mm;
>  	file->private_data = no_free_ptr(priv);
>  	return 0;
>  }
>  
>  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  {
> +	struct mem_private *priv = file->private_data;
>  	struct task_struct *task;
>  	bool ptrace_active = false;
>  
> @@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  		}
>  		return ptrace_active;
>  	default:
> +		if (priv->opened_by_owner)
> +			return security_mem_foll_force_opened_by_owner(file->f_cred) == 0;
>  		return true;
>  	}
>  }

First things first, we've got to shorten that hook name :)  What do you
think of security_proc_mem_foll_force()?

Beyond that, we really try to avoid making LSM hook calls conditional.  It
can limit what an LSM can enforce, it tends to be a bit more fragile, and
it adds some unnecessary work in the case where CONFIG_SECURITY is
disabled.  I would suggest passing 'opened_by_owner' flag as a second
parameter to the LSM hook and calling the hook unconditionally in the
default switch case as a replacement for the 'return true;' statement.  I
understand it may seem a bit odd, but we try to make the LSM interface as
generic as possible with respect to different models and this is one way
we do that.  It also ensures we don't have to process the 'opened_by_owner'
check in that case where the LSM is disabled.

> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..50e3f0abc676 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
>  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
>  	 unsigned int mode)
>  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> +LSM_HOOK(int, 0, mem_foll_force_opened_by_owner, const struct cred *subject)

See the default/disabled return value discussion below.

>  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
>  	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..74eb876054b0 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
>  				  const struct cred *to, const struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>  int security_ptrace_traceme(struct task_struct *parent);
> +int security_mem_foll_force_opened_by_owner(const struct cred *subject);
>  int security_capget(const struct task_struct *target,
>  		    kernel_cap_t *effective,
>  		    kernel_cap_t *inheritable,
> @@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
>  	return cap_ptrace_traceme(parent);
>  }
>  
> +static inline int security_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	return 0;
> +}

With proc_mem_foll_force() currently returning true/1 in this case,
shouldn't the LSM hook return true/1 when disabled?

>  static inline int security_capget(const struct task_struct *target,
>  				   kernel_cap_t *effective,
>  				   kernel_cap_t *inheritable,
> diff --git a/security/security.c b/security/security.c
> index 71aea8fdf014..fff26ff65e07 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -595,6 +595,26 @@ int security_ptrace_traceme(struct task_struct *parent)
>  	return call_int_hook(ptrace_traceme, parent);
>  }
>  
> +/**
> + * security_mem_foll_force_opened_by_owner() - Check if introspective FOLL_FORCE is allowed
> + * @subject: credentials of the process accessing its own memory
> + *
> + * Check if FOLL_FORCE is allowed for accessing process memory through
> + * /proc/$pid/mem in the case where the opener's MM was the same as the target
> + * MM, meaning the security_ptrace_access_check() hook was bypassed on open().
> + * (current->mm does not matter for this; for example, if write() is called on
> + * an FD that was received from another process which obtained it with
> + * open("/proc/self/mem"), this hook still runs.)
> + *
> + * This is only used when the system is configured with PROC_MEM_FORCE_ALWAYS.
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	return call_int_hook(mem_foll_force_opened_by_owner, subject);
> +}

Please don't forget to change the LSM callback name when you are changing
the LSM hook name.

--
paul-moore.com

