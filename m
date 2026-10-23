Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339CE606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GTM8p8ia
Received: by kanga.kvack.org (Postfix)
	id 572AC6B0B05; Fri, 23 Oct 2026 03:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523946B0B06; Fri, 23 Oct 2026 03:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4398D6B0B07; Fri, 23 Oct 2026 03:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBBE6B0B05
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:13:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2B4B1A01AD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:13:20 +0000 (UTC)
X-FDA: 85353024960.07.A27565D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id C769840002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:13:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GTM8p8ia;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792739598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNgOedYkG+DZgIJoTAqem0cgXoeI7a/tKZ3psjHCVOM=;
	b=KCpMvB5a0W/zwXWiSRD1MdBlYeNQPaAx3ncjMglnl1WxsfT4sZYT/RYvk4CwR/igOc5rI+
	stGa7Ku9BUaoB5B4h5yRX1xmj41n1Gn5P/zTR5LiaOC0mLxfnoF71ME6WkljAp7fgMaT0/
	sh2KEcRLGm1dfbjaTg7FKwbQdDgJn44=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GTM8p8ia;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792739598;
	b=v0FiTlwAaKmr1UYYPWUzELaHyBmqDhcRPeT1emoLMeUITWIEIEluU1eTiXbygcdiWSjROB
	Q3TXc8gH7KGldvdQG7tZslFG83jI9f4S1niSJ+sgw4E6M0HgN51dmZ/Bp+Tgv6yOvsFwyK
	I1Nw2wfsm0y3ZbHcHahm9cDNWUlBPIc=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49d05d51553so3504485e9.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792739597; x=1793344397; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XNgOedYkG+DZgIJoTAqem0cgXoeI7a/tKZ3psjHCVOM=;
        b=GTM8p8iaYlycH46vFFXgRLKYCR7KsuvgSCkNXsOGe9/K2Oz5u9eekaLITXrkaGtlzj
         SHCEpx26Ysm8iBKn4miGCzDIkvud5v4F1ifqKoaXNyV7cvFDG2PAvzDNgkMY991kFHC6
         o+NMZxoxRomg1qjJ0DrWPubHerMEEbhJ5vIxKNz3ezb9bN9X19FF9od0yXBCcwG6HmzY
         ibkswKXdo07VzNMQi9jJfh9P+1a6QwPey0RAmNogohcFkScdFmQI1Q0Cxqkb7FjoW4A6
         psvSt/y6MFA5X157aERU5gUVEW1GQ2JJ6gpdGdW7zJco21+eK2q0F4a36Pzr+DtfCJ1v
         Lm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739597; x=1793344397;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XNgOedYkG+DZgIJoTAqem0cgXoeI7a/tKZ3psjHCVOM=;
        b=F4PmYWQ2fv8nrlh8H0YUpCjCriCW8ptPIDtEc8oJU8OWXykipKxf0jRC0HSMPuSiK7
         KNwGUw5sQe9Llp78IsJkjoi7VfVQ1wHAQxWFC3vE0WjqOQXEtMTwk+vmwAjddGFlOvzU
         SPdqrno5WvwS3oRu16EwPATDFojw9TReJX1+HZZ5M4bSbidzws5vhfm9kVMS9WEj38Zx
         xnEAEd8fARhZjCiim3aNaPNSZcrwLeV/stVAx88hZVv5DaXTggU+TNxxdS3JsvwlsWr+
         B3Yix7UCn1MkjGdBK8dutMv1MDfphEErIjbrpV/1wjCIMbs9AxFmjuiOU2H7YcLeD0/E
         ihqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwuy8dQXgHv1C8nO86xBfhtPqXnOIagVu6j2I4LcN15VjWq69E284NCor3RazRynBjloUsIOXvrqA==@kvack.org
X-Gm-Message-State: AFq9FYJoKO9Bl99+JHqiYYN8brQNQEr2+7PALm1lOGxkR32WkanM6ZT/
	HCYM7hrzi7A5Mfu9B5JPrlIEjF6Wqv6hifq9n/lGd7H0Htf9hXq9fWvy
X-Gm-Gg: AYBFou0/qKs1nExwBxZ7DoKhJJNgciZVlMb95a4T4qra6urvpxdrFqkA7eaMr0f/cQO
	ffZplaZVrvV9XP2NHlpJg8j2IHROn+D/e5kL/dsCLuSonNXuL3TJdsILRAL1Ezmj284VavdMLd3
	Sc0F+dBVKFBUlEa4YpRfrAFwE2HYrlUMuVcm4vqQP+UsT0sZN8Yi7W0SYmqJMqRL9rBlNeyAbJh
	HpX6xJ2a3m8SPZ/dVUt6iZd/L0/dQQ10LmzGZ68YzvrdyvLaiBKJ3ph140u2Q515jZ1y5fwJh37
	ojI472L9z/m848ieav4cnwxausvarSR5kSuRfg7vKYt/ZrYaA3vKzTh0nPBP3KOffni0gD1XSfg
	CcXj7UdSpdb/ku2XYtRa/5Jz6pvXrkWKw7CnDFYxc0xHW3JBE5VYUV8+wTyzPnukIpMutI1BOAd
	557su4EESanEyCvfdZjVuPK95se4ekLSC2Pmed1ltrKzD1vvTrLxsdXlkQ6XSRpyNlKHt/O2QFE
	0KctGsdYoqy0wIs7uKwhbt7kjf0
X-Received: by 2002:a05:600c:1c05:b0:4a1:6c79:fd31 with SMTP id 5b1f17b1804b1-4a211c9e009mr24676825e9.12.1792739596914;
        Fri, 23 Oct 2026 00:13:16 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2103622f0sm54943425e9.6.2026.10.23.00.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:13:16 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 23 Oct 2026 09:13:13 +0200
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
Subject: Re: [PATCH bpf-next 3/9] uprobes/x86: Finish an unoptimization which
 failed half-way
Message-ID: <atsJCamloi-SWUGh@krava>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-4-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022015712.1297331-4-alexei.starovoitov@gmail.com>
X-Rspamd-Queue-Id: C769840002
X-Stat-Signature: ejjof964ro7r81f3q58psfkwnx7xfmte
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792739598-889526
X-HE-Meta: U2FsdGVkX186GkQq6hEUeC+W6mJWpfFOgHttJAP+OqeM3DZxMARud+v7/B38iHvL6A4v9s7tG4u7NsCBQNaibqvzJ1ln6DFASI4ZZul8dh21J20ynMLCb2wPUTKzTxXfoNX1GRriVX2bHMQrGgNVao91InR8b/EAhA6LLil5hJ92zZk9VIAdCkq9rAHb4VZaTMD+cUkpAU/HHA04OX5GhNN6Cofiw9K9Dr0rmvKTtTDvYjp7/gcspz+mQCuTKrNy7l+H/DAbmRafBAcgcyDxzJ+cg/y21ke/UErMVoEc43Yg0dApBnIlcnDXYkViwoN7HH9YasOUepPhUbTjKzfg3V09Z4ssFFO/eXZm6IdvTC0KjSTLbTVXX/buACXpBzbCiLWoXU5IyrOrFMPhbUARyYf4rinswOzRgskdP4raxrde5siO7SYvdbSmwSCslk4V4kaP3odoHkEPaM4p0f3J2tOuA+EyH5DrxQJMFPO7eKet1xq0Pkt/XLTBHKtJfQQANK05kXycQ71bCd8waTt4FNTHWkF5ZFxXWZ74mG0t9Vp4lt8MLloJRyW12Pu7/DnpVX0YyNQSaSZNnfIfLUInba2BBnZfxkb7rOiCTakIwnmY82mBrRInT9k5Hrax1Ovn0vu9jeQMMYwbNMxq/9zggFktc3TlGp/w8u2ibO2pDAIGTBZjy1FNcHdgOkKpSQCYjq4E03PHLicDAamMHM7lVvSZ1fbanfPCXDO3XUX1JAaYReGSG2Dgtvrogoq8lTiHDvwg9W6L8KzaCMtA71/+IjO6em98ARzKLq5R13mFKr0nPuntmVdOCmLikwS/dJMHS3CKHAWU9+aBVBV6G2HC534gOLPNkPPSd9LUcZuHxW/WgIHBKZyJqhkjwvCm+H6eMcLhXJGYccf2NRhxCOr9VU/lb/d55lkPVECuAW59KZlMerwLiJCGr6QvKFizW/YfSsLHJzhLY5gFErNokTb
 XnVwK0su
 RiSviNH1BPBTXIZuJKB+lBF8NHwKkk9p45COeRtWToEDfLJb+SgYTYl/7Rbl/OyxghZkm6fMl5gLAoj/mbOJXucXqy/2Ona22NRHWOn2TE0CLwkCsn4N6Cult25nxq+FTA/SihoRtR2z60faTulPOaM/7PVvz9el4YjoYZotAQR9LHRu5o30Y98H5nLv/UbZ0azTu/vcYsA0VHHNmcxv9DIeddqJ4j4rEaFqfkjkDZzxtL4IYuiQps38Zc9HQ16+PtsTAXvCm+DWPyWN0K4n+hn8bpEgTKB3CjXc9FQ59vLo49oqs346vfvXKi4A50snW9Olk+B6U0e+etIpkFWCRepsJgMDTpz+CGm9m0fhBugRDrml/lQZXup5ukK7KG71WzA63WCEjz+MgBznRFaBTR2oqMU0ftQxzkuuCPVcf/MsgJmlGbI0ILmWZzQvYwYzNim0thiBnUtcKoY+daWeCmTjI0UVf0kVZ9rQA7DGRNSfFh+HgxGTD2uF+eeoAgCXedgLmiIpwaMUTEBBSQ5R6bFMFUlxrtiW7yJmFSEtF8NkdukE/FoTvM7L+2BD3tVrMldNO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 01:57:06AM +0000, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> int3_update_unoptimize() restores optimized nop10 in three writes:
> 
>   48 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%rsp; call tramp
>   cc 8d 64 24 80 e8 d0 d1 d2 d3    1. trap new entries
>   cc 2e 0f 1f 84 e8 d0 d1 d2 d3    2. restore bytes 1..4
>   66 2e 0f 1f 84 e8 d0 d1 d2 d3    3. restore byte 0
> 
> uprobe_write() can fail with -ENOMEM, or with -EINTR when the task is being
> killed. When the 2nd write fails the result of the 1st one stays. Byte 0 is
> a breakpoint and it works. But the next set_orig_insn() doesn't find lea in
> byte 0, takes it for a plain breakpoint and restores one byte:
> 
>   66 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%sp; call tramp
> 
> Nothing recognizes these bytes anymore. The process keeps the call into
> uprobe trampoline, which can be unmapped already.
> 
> Teach is_optimized() to recognize the half-way state, and let the 1st write
> of int3_update_unoptimize() skip what is already done.
> 
> The failure wasn't reproduced, but the state can be made by hand. Attach to
> nop10, call it to get it optimized, write 0xcc over byte 0, detach.
> 
> "uprobes: Don't sleep on mmap_lock under dup_mmap_sem" needs this. There
> fork() removes the breakpoint from its mm. When fork() is killed in
> the middle register_for_each_vma() removes it for the second time.
> 
> Fixes: 554ba38456da ("uprobes/x86: Move optimized uprobe from nop5 to nop10")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

nice, great there's simple fix for that

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka


> ---
>  arch/x86/kernel/uprobes.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 65a2de82ecd2..62bbe41c6466 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -896,6 +896,9 @@ static int verify_insn(struct page *page, unsigned long vaddr, uprobe_opcode_t *
>  	case EXPECT_OPTIMIZED:
>  		if (is_opt_insns(&old_opcode[0]))
>  			return 1;
> +		/* An earlier attempt got this far and failed, nothing to write. */
> +		if (is_swbp_opt_insns(&old_opcode[0]))
> +			return 0;
>  		break;
>  	case EXPECT_SWBP_OPTIMIZED:
>  		if (is_swbp_opt_insns(&old_opcode[0]))
> @@ -1109,6 +1112,17 @@ static bool __is_optimized(struct mm_struct *mm, uprobe_opcode_t *insn, unsigned
>  		s32 raddr;
>  	} *call = (struct __arch_relative_insn *)(insn + LEA_INSN_SIZE);
>  
> +	/*
> +	 * INT3 followed by the rest of the optimized instructions is what is
> +	 * left if int3_update_optimize() or int3_update_unoptimize() failed
> +	 * half-way. It works as a breakpoint, but to restore the original
> +	 * instruction it has to be unoptimized like a completely optimized one.
> +	 * The same has to be done if a debugger has put its INT3 on top of an
> +	 * optimized uprobe. The trampoline can be gone already, so do not look
> +	 * at the target of the call.
> +	 */
> +	if (is_swbp_opt_insns(insn))
> +		return true;
>  	if (!is_opt_insns(insn))
>  		return false;
>  	return __in_uprobe_trampoline(mm, vaddr + OPT_INSN_SIZE + call->raddr);
> -- 
> 2.55.0
> 

