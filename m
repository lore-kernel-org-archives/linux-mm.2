Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384AEC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352796B0092; Tue,  8 Sep 2026 12:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329266B0096; Tue,  8 Sep 2026 12:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2417B6B0098; Tue,  8 Sep 2026 12:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC9B96B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:18:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83E71140741
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:18:59 +0000 (UTC)
X-FDA: 85191103998.09.C2A8CB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0F5620010
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:18:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0Di9Fan;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVJUfZRIhHanRgHO4bwYsGjNciskUqMKHVOfC/XbW84=;
	b=qoFC7xXFUDeYjicQWo8kHY1TFEnl9Xew2EXigdh7CvdPKzP894dj7mfaHZT8ewclx+ZaHz
	zu85vK8LqEoER6BcbBNiBCnVnv0Wc5+F0YBNuQGodED6dwK4sWEytW672CNWcvWT57bthF
	BIWhIenX7oo7L5c0SnMcz+K1EBT6p9w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0Di9Fan;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884338;
	b=Jlu2K1YaIlDY5m5pAkGji/+9XxCxgw2N5/4cVH+8s2f4EAHseql+lesU1OfKDkb3PGX6Qf
	LgsEnhYWY0ZoieTXJWitxLJP7SRIMOuj1diIi+2NOBn9kXutysoFe/EX1BegQSXAEs1tnL
	D2n1vpZpTVrkYmJfjTpk8zJ/TjhLja8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 994BD41605;
	Tue,  8 Sep 2026 16:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D071F00A3A;
	Tue,  8 Sep 2026 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788884336;
	bh=wVJUfZRIhHanRgHO4bwYsGjNciskUqMKHVOfC/XbW84=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=M0Di9FanjFgZXn5fUF3WVAoQT0IHgGUvttln0zHA3j+SwhvMih8Nxh75ZiqMsH9Kt
	 99UYoLmRxMY6hxL79xlDKjedw6D3hL9Mbeyz4CfL7s1PmO7F5/m8rCnMjjBosAr1EW
	 5yUhBDyOlSBLe6LU9FZ6Go6ORdwgewjjionbkLPbz4aORn07Ac1aEVJuVCNPi0NXZT
	 M4V8COecqUZ+oDJeRRIFZiViBXk0VHY44DvqQOSmdMdj5HZJGWQfvZmOjuqv3K2Xqi
	 dFwlzCQurqkXZ8cx4jnqARFjFCapVaMwtGA1Gq4JpEGUEPcLKDvOTjKGotHvtNW4SS
	 kMjGvvcq4d5Dw==
Content-Type: multipart/mixed; boundary="===============2920598840718806967=="
MIME-Version: 1.0
Message-Id: <4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org>
In-Reply-To: <20260908135302.74963-4-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-4-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v6 3/5] bpf: Add user memory access kfuncs for mm_struct
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  8 Sep 2026 16:18:55 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0F5620010
X-Stat-Signature: qyhq7yr54r88khpk7pfq98d77bzn83nc
X-Rspam-User: 
X-HE-Tag: 1788884337-322980
X-HE-Meta: U2FsdGVkX19wkBcEKqQBIyKHB47UNB+A8gjqUZQKIbff0HIB++px2D7kTlJ/UFfWhoxQ2dEZGY/Y+KhIAZgMik+/5dpCaPsLbeBwCMvmbKOpbdswZBaBbuA6eAo7MZL3dGDhhvpi09x9wWZz2GsnAnWWcKRRwqGFkLc9fourkU60ud87suFVyM09S6zBJgD6yly1lYThZlAbaqEgP8nAb8QHy8nsJBaR9JfwZosHY2cvxK1G0+B4VFj1LXl8swyus1EFx9Itf+xazZrTcZjZR2V0dpgHHMb4vQoPTp7tuyQHTHfcIMm4t6MkDK4uSprYz+24VH9r5KoEYFS5Vyrps5zZAvrC/1xTnAeJOOlGME/WXUMtccXqhUfpsGGUqsyMsW3g4VmM9ItY1ZCkMim9Lv2LAOFMGIRj9wM/qU4p2/JJdKYo2N4gH8Vax+N7lYvJyjlX9i96vScLpnNna5jj1+tJwOV7VbWV+F65LdmwjL0nCsy8ZUxrEyv3WjqUdBYCsCLXqiV8xn83xe37KZqsqD4uNqKMEykBQiUNb/ABz8zZnBvflhrDn8ydYVaek0PNFXAIyUCWzAbLeqI0kX90rPXVatu7rl5WppNMIF+A5Lbn/DQIR8cayh/u4L+FgFwdPTZ4HAXvdPNcGCspRMKdl+D8ks5wt0UdWsdOJJp6nOoUUU4Oy7z5MkiNeC6vWUALh98Ecv3qqAf7h2hXl0um9pLBt5Webskdh7crtuPRlPVPWt6TKpFQf3QnFZwU8USpQzKWn2l/6+hsWgKOPkv8sU5GAqQG9D5/r8ougJWU2R0LRQsJoPE4tEU9V8sdROrES/y75L6teKCFVaFsq0xWb1sO6a0/KoyBIDNcNiM0YfEx2wdNgfaxaEj9KDQseAsFPKx4qK+5CBwHL1v0zQncG5wxd1Lp9XrazScbrgspFaBjd30N1M6HaZRmrTic+lxDOWEYYGcvgdCQVndGra7
 BWBpjeze
 /Q7FykLyvABJqNXttGHFPdmnxNoGo/eumMzh1QUVfT4MfR4DFCygOH2KCqIAlM1uN+MP92rQ6hPu5WczSDrxTPLxfwpuxaqDrrLc3fOkOWxEKIMRIK5RmX1tFjA2kZD1CTaqt8pfgn1KWZ4i+AkbS6hIfGZ9S24lg3QWxLWnGeGyAcccVwbrNGdJwkvjen9+lBrbtvLMFfKYv94aQ05VvodPdnPZ6/Q04ciUMD8eb/D1tN1AlgVnUj8fZt4WE0vZZFOSTX8p7AtMGqnOwW2GC0+dV+sUZSKLAv6rltyM8vUcXaJt/g9ffRrKReZHh+1gHFP6XsE1+WrATICKH53bdqbNJR4Rl6dvjm7aKJkCIRaxzEPE+Wdws+BsMgukW9rA2C+rHk+c8Uixeq4Lq9tW9ISy23V3PVLBnxTGgq1TWDDQqbLMGwKht5AGCRdeAEzn/1gdzn0LmPc21J3qBSfXRWdkjrlNe90LcNBF91i4HcoTec031aNSJgBgsKLbie5x/FFdJVxoYXi1K7QQ6DN4ltua6opqVStl0MJpz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2920598840718806967==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index b3cc5c8fc875..3338bebdd86e 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -679,9 +679,44 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
>  	.arg3_type	= ARG_ANYTHING,
>  };
>
> +static int __bpf_copy_from_user_mm(void *dst, u32 size,
> +				   const void __user *user_ptr,
> +				   struct mm_struct *mm)
> +{
> +	int ret;
> +
> +	ret = access_remote_vm(mm, (unsigned long)user_ptr, dst, size, 0);

Does this drop the address-wrap guard on !CONFIG_MMU builds?

The refactor replaces access_process_vm() with access_remote_vm(). On
CONFIG_MMU these are equivalent, but on !CONFIG_MMU they differ.

The old path through access_process_vm() (mm/nommu.c) includes this guard:

  int access_process_vm(struct task_struct *tsk, unsigned long addr,
                        void *buf, int len, unsigned int gup_flags)
  {
          struct mm_struct *mm;

          if (addr + len < addr)      /* wrap guard */
                  return 0;
          mm = get_task_mm(tsk);
          ...
  }

The new path through access_remote_vm() (mm/nommu.c) has no guard:

  int access_remote_vm(struct mm_struct *mm, unsigned long addr,
                       void *buf, int len, unsigned int gup_flags)
  {
          return __access_remote_vm(mm, addr, buf, len, gup_flags);
  }

In __access_remote_vm, the length clamp uses the same wrapped addition:

  vma = find_vma(mm, addr);
  if (vma) {
          if (addr + len >= vma->vm_end)
                  len = vma->vm_end - addr;   /* skipped when wrapped */
          ...
          copy_from_user_page(vma, NULL, addr, buf, (void *) addr, len);

When addr + len wraps to a small value, the check is false, len stays
unclamped, and copy_from_user_page() (a plain memcpy on nommu) reads past
vma->vm_end and past the end of the address space, causing memory
disclosure or a bus fault.

This affects bpf_copy_from_user_task() (which previously had the guard),
and the two new kfuncs bpf_copy_from_user_mm() and
bpf_copy_from_user_mm_str(), since all three call __bpf_copy_from_user_mm().
The address comes directly from the BPF program with no validation on this
path.

The sibling string helper __bpf_copy_from_user_mm_str() does keep the
check via copy_remote_mm_str(), which calls __copy_remote_mm_str() in
mm/nommu.c and uses check_add_overflow(). Only the non-string path lost
it.

This also contradicts the changelog claim "No behavior change is intended
for the existing task-based interfaces" - on !CONFIG_MMU, the behavior of
bpf_copy_from_user_task() does change (a wrapping address previously
returned 0, now reaches the unclamped read).

> +	if (ret == size)
> +		return 0;
> +
> +	memset(dst, 0, size);
> +	/* Return -EFAULT for partial read */
> +	return ret < 0 ? ret : -EFAULT;
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34245694915
--===============2920598840718806967==--

