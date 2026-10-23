Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5998E606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b0b+bJ6F
Received: by kanga.kvack.org (Postfix)
	id 720A76B0B06; Fri, 23 Oct 2026 03:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F82E6B0B07; Fri, 23 Oct 2026 03:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FE56B0B08; Fri, 23 Oct 2026 03:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 389126B0B06
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:13:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D612AA7B2F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:13:27 +0000 (UTC)
X-FDA: 85353025254.04.75471B1
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1536D1C0004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:13:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0b+bJ6F;
	spf=pass (imf20.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792739606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wq7uJPFcmgA9r58RX9y8WD41guFgFXDdj9tzjsOmuN4=;
	b=XwFQIdfNPHYNDVsXeARE4T5n664sweOmhvfoFOW2kepYD7N4OggCDe4I6Why3QdzxF7sbp
	YMI0HhEmz228n1IqjE4DqXZYpj79Q5PKP/wBfeV67szl9D/iHiptpvCTjD59iP/eCWmB6Y
	8szxBWQg01aynr/9czovaDAqLn4rWL8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0b+bJ6F;
	spf=pass (imf20.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792739606;
	b=7MOzmbTSnJfDD88ikot9so881c2S3E0WPV2+fCPGrY3aW/JcxWqZgvntYaqiPX8ZMIXY6J
	hp0LtGoFHT/51WSrNdnIQeW3JnqLr/Em3UTqKCRPvDX0rgEuRdw7F+qZWzAUi7kdWP8LSg
	itiZsfVhF6kwBBqrOgItTZS8EwCrDJ8=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e00eee27dso302029f8f.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792739604; x=1793344404; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wq7uJPFcmgA9r58RX9y8WD41guFgFXDdj9tzjsOmuN4=;
        b=b0b+bJ6FEDxn+6K/AjkE/aSA4bxdFJoWDp6138i+PsCl1Bv8ArLW+/q95uYb9ex5Qi
         8HFcrQK3aXgT1oJPOPVzjHvQrofOE95UzJr8Mu4wogVXKI2D7psm3F3gUMLp3xTozs3a
         rQOh9WWJyzjxIz3VRq1bdlW7eKhUSsgDikyluaaHhY2k/bFD1PV7Z5fUKRIh+EIoWIs7
         pJwWko4iBpPtIk/XW13w944Wc+BGP5p/KxvrI1XxDYW9HnRQKqVpX9Rr6TpqYtztDhmP
         0rcMNLHboenlLghs6UwGafElYisvLDSr0FVH6VL6MXt/K6nYVe9HQXFfbLPeSS6vgAHU
         gEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739604; x=1793344404;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wq7uJPFcmgA9r58RX9y8WD41guFgFXDdj9tzjsOmuN4=;
        b=wNUk+DxsyJli3rj9jpzukGkUKwSaV5Un/n6yfCq6v5ORo+SZESqRopRq0yT+fN0P4p
         7q1GhatoRF3RKOmiZ/L5hh7DWpiAnqbsVysWj2y+m1reu6QeMxG1EWx9jjyNWwltnWxl
         yh6BIhDNSoJ/gHMUtWMqmATErZSvPorMIn+6ft+Mkg4zgAeSnezNh9WBObX8xMziffFt
         GUqRlgdWu8FKCjPqnXOG7EwcsDIBMKWb/LD+E4S4QYx2iLcwpdtn9aKi2MwfRVWpcprR
         31lePTzYjsXPSSxiYm6mNSq+BMNYhkuf9yjT6j0ysuOo0CmMAJCvMIm/23IJnKzH/yoD
         9oYA==
X-Forwarded-Encrypted: i=1; AKwUvByTLotKYRhuogpkL77Hy7GbA181EPHLizZ/Bn2R4d4REdS33wukTaGzzLGVM3KwarAzewuRP10OUw==@kvack.org
X-Gm-Message-State: AFq9FYKvzO9FjEdS+cPcX/QcG7ce3N4kQF9vriexwvPfZK9aTEhlG5yr
	qW3iFZ7jRevtx0uGjoSgfAWkZDNrIKID/G9IVC8kYS7oF6oQdjAscj1Q
X-Gm-Gg: AYBFou0AIqxvrtbbMsdHFd6FlCJkCjNqFHkqbJAXp6A2JuCghpkJnVWCYwSv3hc+/XO
	qP1Ju9J6KYaAQo7Srj8OHFBd7xWpgMTY3bz7Z+Nud49BkYY5qeCbTudMCytsitPa+dmE0u/hZvd
	1XdUUiw2JRKX8MFU/s1PLkPtjVogM5Zr0NRnZ9upg4gKrVdJINcps5xPXIQ7TxbFXnsB86CTKxM
	cfKef1YoFF3okXA/U5DpRdx5CxpohRWaFlBUmT6f9IKRYy8uxHtt68xBSKmcitVetunRDm5us0h
	5LHCIUN3VaLbyoNwYEeD+UvZujdJuqKGTMdi7cTJdnJp3ZHZBg1WEDXocqXtGV9hC7L/QGslwZ7
	rEA3Ak+8daavBxEpwgNo+RloW0hu7UjZyR8UrBgX2aDs8MjnBa/MZFwl8K0rIAcvJ17UOiDL+xi
	mHWkN7n+MuA6il1/YNRF6P659/UE7VrygNSdPTT8M9fEO6jBlwwrsZ5W0rtXtdo4ow6hvXqMMXD
	QbCGSQNlgwm4saNmpu6mg4Ik//L
X-Received: by 2002:a5d:5d03:0:b0:48e:3b48:6f1 with SMTP id ffacd0b85a97d-48e3b480974mr340715f8f.54.1792739604164;
        Fri, 23 Oct 2026 00:13:24 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38025d76sm3155877f8f.13.2026.10.23.00.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:13:23 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 23 Oct 2026 09:13:21 +0200
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com,
	peterz@infradead.org, mhiramat@kernel.org,
	akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
	surenb@google.com, david@kernel.org, vbabka@kernel.org,
	jannh@google.com, hughd@google.com, kees@kernel.org,
	mingo@redhat.com, tglx@kernel.org, x86@kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized
 probe can't be written
Message-ID: <atsJEWXk04C4oz4R@krava>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1536D1C0004
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9q915x4bdhsuywgbkhuje9kbuss1gfj4
X-HE-Tag: 1792739605-922551
X-HE-Meta: U2FsdGVkX19CpFfJD2yK9EQKIlg0lh5+h8ikho+gtokR2FQYwC34WVNYERozTmMJaoInxPI/MQT8prhS0j3bPUCK7GpYqxcOQW2/tARuUU7SNJEy6tkfsmL+vqRGmHdLvFUqPnzqjk0Ma0zRLlXpvB2qc09wia9rIB81HCcNJrukga6SSBS6SVC6qBZjGNaMWWetNNB4kqS5guM/ZQNE7eZeZH8hjWJlvkHx5mQSh8vcx0ollUautJKxFZfgab5tz/+QEsmeTitL1M5fKoVNB5MxkiAFrMJARvYOKKvt0eX94WvAlTgkLhomNf+mjaryMuLYo6aXQAKJnD9bkTT9vimhTeJj2AhdN4Qh2Jqz8mMQ2RyOzw2S+8TIcUJ2hNry8grown+PbNSF+81rlyRJBUvcXvcPr8A7DSEHw2YogQ9jXrKzkJnl3V7l2Ze5nOvSsM5mEMa5wFk8sNVo7evCT0Y53qTsMbVlGOrnpOw7o+/PivcRF03SU7zxfOBq95CAGG6Slw3eDSMS25ywSBA46HZ6jDZZn/AoYxsxyEpboHLpOaE/hmvCE0ZmCruEEeMGYwa4AERMbATpkSAHvsMBOd3jVYotPcr1yFWNvGxqzFU5G77We+aWnYOpjr60bmxXEETgtV5Gae9Bh8qiekm0mxHCXxC2PfyJQHHvzqqpTXG8YlhM9rzHwP/3WPJ56nLI5UAvpNB1rUALu2AMgVU38oxW/4xcrenU1r45TE53AqpAx5xF3mGPsJRkHz0u9VRQXRfPTh6vBFtxWNCXSM+s1e6AxPfy4EqnUUEVvU7ataimLA0TYfi+ZXL68Rh85gXNftFLAAtvyMgYBYZSs0jqLTsR9A3tT3C0hjoPhh292LA3L9QZO5jRY0zZy8DPIdV6FXCsbx01Slscf29RKNXmb7Vi3IU8Nu93iryGqGdciLnqQqU5l0drCBA7x1OOn/4Qxs4U7beX73lAkjA3B+o
 5R4lc6dh
 cSu61mv3HJOd8g4x+355kL8/4KKn+4nr7LeSZ77uQMzvxkPcnOHCPpYNQmxf/dk9hP/BXgztBxxR0n7d7sxePpXwyGNOTqv/ZrWeOryPmsQ77WCWJo/yGvRmDaxgJSxpFdVX7eJxSImIIvu8IRtJviHEkVqaVeM5Z+U7D9PtdiLnkTZKA1CAMqpHJbbRVcEt78pu47KfWuFUe//+d+sGslgEsmPDwrP/fzJ23LssUxUDUEUn4eCsHz5RpOSI+l9B7jYH5UbTDnj8n2krMcXYMBnpi/Wy3CX/VSAmGM1C7s1j7KMRbdx5HsYjTSKqhgQ85EVdpwSFerdTszxwq35K+gFyuyKx6XnSQ57tmWJFI9X989WFQuH0nlmQKrRHOq7PfVj7pNZ6nTDOU0xHJrigIGXagvZhP7yCDVqAjLsnxnebUALDAl7ZN/eIRQiBlES/cPHDJjPdM1jr2ezoqQ0EduOnViNdzKNkD/MGB3UVNKAWFUsjy9svg4XuECz2cMHT+vM2EANU0eWae6T1U1DgG/F8DHzEhoHfQ61rHNlPXrXUNpIC5xoNnT4RdJFoAx7/ovhsz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 01:57:07AM +0000, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> __arch_uprobe_optimize() and set_orig_insn() do WARN_ON_ONCE() when
> uprobe_write() fails, and user space can make it fail:
> - -EINTR from get_user_pages_remote() when current is being killed.
> - -ENOMEM when COW can't be broken, since memcg is at its limit.
> - -EINVAL from __update_ref_ctr() when the process cleared the semaphore
>   of SDT probe.
> 
> Kill the processes that call probed nop10. It warns in 8 of 8 runs:
> 
>   WARNING: arch/x86/kernel/uprobes.c:1186 at arch_uprobe_optimize+0x291/0x3a0
>    uprobe_notify_resume+0x1c3/0x4c0
>    exit_to_user_mode_loop+0x63/0x4e0
>    exc_int3+0x1f3/0x250
> 
> The next patch calls set_orig_insn() from fork(). Kill the processes that
> fork and keep mmap_lock busy, while a trace event on nop10 is enabled and
> disabled. The kernel with the next two patches and without this one warns
> in 3 of 3 runs. The whole series in 0 of 3:
> 
>   WARNING: arch/x86/kernel/uprobes.c:1161 at set_orig_insn+0x161/0x170
>    register_one_mm+0x154/0x180
>    uprobe_dup_mmap+0x61/0xb0
>    dup_mmap+0x149/0x9f0
> 
> The callers handle the error. arch_uprobe_optimize() marks uprobe as not
> optimizable and byte 0 stays a breakpoint. set_orig_insn() returns
> the error. Drop both WARNs.
> 
> This depends on the previous patch. Without it WARN was the only sign of
> the bytes that set_orig_insn() cannot restore. Hence no Fixes tag.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka


> ---
>  arch/x86/kernel/uprobes.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 62bbe41c6466..33c35bf07801 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -1170,11 +1170,8 @@ int set_orig_insn(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
>  		int ret = is_optimized(vma->vm_mm, vaddr);
>  		if (ret < 0)
>  			return ret;
> -		if (ret) {
> -			ret = swbp_unoptimize(auprobe, vma, vaddr);
> -			WARN_ON_ONCE(ret);
> -			return ret;
> -		}
> +		if (ret)
> +			return swbp_unoptimize(auprobe, vma, vaddr);
>  	}
>  	return uprobe_write_opcode(auprobe, vma, vaddr, *(uprobe_opcode_t *)&auprobe->insn,
>  				   false /* is_register */);
> @@ -1197,7 +1194,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
>  	if (IS_ERR(tramp))
>  		return PTR_ERR(tramp);
>  	ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
> -	if (WARN_ON_ONCE(ret) && new_mapping)
> +	if (ret && new_mapping)
>  		WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
>  	return ret;
>  }
> -- 
> 2.55.0
> 

