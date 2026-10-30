Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37544606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i3nYnyC7
Received: by kanga.kvack.org (Postfix)
	id 5DAB26B00EF; Fri, 30 Oct 2026 09:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2966B05B1; Fri, 30 Oct 2026 09:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC016B05B2; Fri, 30 Oct 2026 09:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 294C06B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:07:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C37501606CC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:07:41 +0000 (UTC)
X-FDA: 85379319522.22.DBE25EE
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED72FA0010
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:07:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i3nYnyC7;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365659;
	b=pft3tp9dw/dAyBqxW8iNgWyxSWTyvJMdHWylQnkcAToo0Tp+9loRDnXeJR7H+nSme/Z9Nv
	TFt7FIEa43yiemPO91NotftRElpUkaG6/z2S9TFW45hQxXHC+PrqQJ/JR3TlM//caOO8f2
	UQGBTsrhOYU3j0sEGWWdZGdy0c6W+Os=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i3nYnyC7;
	spf=pass (imf25.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CXkmd/O2aNTlZ+qEZ1HRRpRXyJoN5I797iFBoYREzI=;
	b=2A5Q/noDBuPofAMkjtRcWI4Btg0SzhLNx5ANzQ8Sv6YSccwaepIPYhqhFBWw6Z0zueHlLV
	rAb2cXJ36B6MSUMeCBQesPcKuYN+OxI7hJ84cXysyu/rQZmzfQ20IOCxunkXKsCPMLwSQ+
	NZXGrdLJ/KXfwYDhURybNtfWXgg202Y=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48dfaa3fa12so1074583f8f.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793365658; x=1793970458; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2CXkmd/O2aNTlZ+qEZ1HRRpRXyJoN5I797iFBoYREzI=;
        b=i3nYnyC7DsK8TJoFxJRS5TV9MvqnwG1oMkQEjd28OvF9hKyNmKVHqLAHc2nbNssuxX
         j7hlNV2xuJxms/K0oGregop+6oPBAVbLrPGGu38URWx5gcnHUjIcDSzgA8SYfvWUzMiE
         pbpxfoNyRYoN7EoaxAiklW26wqzqYOTo5GS+l2VRYIb1/AdTne2WQQtpOwSN/ohp56/Y
         Pho+KUlg4xi6sbJghaxCJo+SkO56AprFHGkYomJQ6bhMfHeUWhA5ergkmCw6c5T+seVb
         qP5LJy0L+rsmSWeX2jlj8dqVBNbR0HCDZza/b9dy2nhI0r/jJQewVm2U/3b6JauSIQgE
         DbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365658; x=1793970458;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2CXkmd/O2aNTlZ+qEZ1HRRpRXyJoN5I797iFBoYREzI=;
        b=RhFgXlQpl8goydTM9dkrbivBpE2nqYxB0wC52C6VZzNIVqZF0w/93Izl9ugOc66njA
         GEP9B9e8hf4N2ZqpMZKw/T+4ROfFJ22+QcjBbX02cj3UbkBcDx86N5StVCzyD3q7lrl/
         OxrhxY0e4QGaFgCcVTEhWgBIfbC4TYtJ0kNTeIwSII3eS6n9Q6KqkcNxS5OB5QyoX4+v
         FfjA2sKla3dcNVJvDeSUol1unDjMCyYcxhZuOSvML8iARgY2I+2e0M64xV23G1nmLcl+
         07MczEspOk+5D3LgFM5oI6jsny8RY5ycsBm1tbeUBt+fIDxXxh4tb9MlQwZzRRkbY+Bp
         3KtA==
X-Forwarded-Encrypted: i=1; AKwUvBy4QC6LxSZzX1wtaLl6exrPXV9OyWQhyLxBaM05/SJiCrU1/fZ3+rPcwWnu//MStJvKzEtTWc4HLA==@kvack.org
X-Gm-Message-State: AFq9FYIMfhPPRDJQTov+0sDEbIyVeL5rWXheg4YaO5ww7Ea16VRSEcdt
	8hH0V3x/vXnpHzFB48RpoLx7/zNO8MR+v6Uoh1g+o22U4cg01T7Qq7J+
X-Gm-Gg: AYBFou0pu3mL6wGs/gu+aj/kTd1TcRwgENodONo+ybk5QXRaj6Ju0L3MAxLsdOQPiVY
	iKyXPevkP6RhNGxgZQyVfZlDLNCm9V+XnAVXTUTVXKKIjd5wFBab1ILhGLgvCCQWXJ6OlTchLFc
	kK+nwSV1FPjKXtGMHAVGIpVJ8UNKSceyX+OI3mW6zoDFqQBuH1N57mil5/cFenL7L0ey5CW0yjj
	eGXzJQmKJr58LLefUJ569OKyIxitwuaZcOmKDXg6tEbCx+Zxia3GJcn6X8YcSDPo/5ofNMBrO0V
	H0bgxUhDhFp5DUWCscZQ3H5WYE4lA2U19Sx1kTJlOPLEZ7pQgRsqTgXjudwt+UkJtAlfag/wgLF
	3EjyPci3KnW34u5QEPmbud/EM/aM4imAG1oylrsLuxIR/cgcZDGp8TRquRJxINOUwUONuvPzb0h
	NCIhC8rzK/3vBKo9IKQl3hlSn5w0MgRsnZT1+/1EoJxCcdPYXsodNtmWJycRTgZhFEkGh5+9hw1
	oyaSAgCA0B47QlwLllwXnaSoRinh1n/SCb9DMMGTYacUhvI44ZgJWcYcS6VZ/clQ/HSnqEFNrcK
	2A==
X-Received: by 2002:a05:6000:4910:b0:48c:69b3:6114 with SMTP id ffacd0b85a97d-48e6494c24fmr14608261f8f.3.1793365658172;
        Fri, 30 Oct 2026 06:07:38 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b789c6sm3482083f8f.26.2026.10.30.06.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:07:37 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 14:07:35 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next 2/8] bpf: Add user memory kfuncs
Message-ID: <auSWl0wLpYO8RjHz@krava>
References: <20261029212551.56964-3-jolsa@kernel.org>
 <571f32a410a85199bc9bcecfe07a9a9b6ef425b2052643e64031dd246c13691e@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571f32a410a85199bc9bcecfe07a9a9b6ef425b2052643e64031dd246c13691e@mail.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: ED72FA0010
X-Stat-Signature: g4ba3n9ap5dfhufi5c48rxxoftqyojsa
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793365659-56462
X-HE-Meta: U2FsdGVkX1/GTd9KOQukHIfT7W/nTXZ/LiokfpOLR8eYL8amzvhgghnT1QnP8SsfAMNTL5Rk4ovX/mfSi8vaQCpKAUUdLgB4nWfLH0rbNJpwytcq150UNiDXThw9nJD5dNpCPTn1Y03wPeRd7tgwOOGqQyuyoHY4+QlsXkqQ51cuuW3ceWvy2AY5EdNW86UkWJIlA+jTTXsWIQN5AzcjWE2OR+CIlKAKKPgYKFZEiPa1OVrSv81nn0bWGV8RTnPwuM8+i+ohRbNvNTDIveUgpe2AvZI/+UmxIuU+RDZjozAn7gz9+025xr6LbGB1MMQZFsrf2utBFl85PYCXnbMQLY4TkLRHyIMst46k6JgUgKVv9ntRUngRztF978q0sXTV+KjKHbUyxBFyyhq1Qo1+GyUeg9zTmCNVjmTPM02PD08cr987CiX0IYLVnV6TB86/NJBzekYRE47VU68dIoM/h8iVzdKKjt09VzZq9Vr28v5vMvjVgUOPc4y+4ubwzQyU9L/TAAXZOz9LI1hknqIi7suoIiglDdXY+eBBBf4JOZNGvKEw56uBAlfPU8DFWK7Oryhaic8FHjWYZhUvUuFluWJbig1e59W9Pe1hLY6hI3vNZGPTWyz93u/wXmE4m8v8x8zP4EaT8JzBL6S5uvWCxb5L/LkilPIaR8OduJHShBS62JxwnORbXRtUbvkrapLvswebC9ED0y0QWunC8uBBaXwFVWkaGExK9OaOyAW+zGFazIPWmXKzaXZ8DRt3D74NP/agcrbXxU17pni5ETEF1HsZH0KMC/a08iqtmCQui5N9Kq3c3y594m29KKJnKpIao0XoIf+jX40FLyvMCs/zcbCoGpyQAXuLppex8bsyGQb56Upf8bIp8AwEDctoYy4Pp5c5701WrWYbnQdWDBHt66ptg0paBfeJGlXL5LYe5clqXYrqOAh9kvS4RauT8GfgXDR0sHqlR33TW9b76Jj
 ShPVc2LV
 BafkGa3LLVRzF3j/5NivSCQ95uq4/q/l94UriYiCcXuZ3G9pRkV9nxqM+O4+0OaShWzqqcdQglIJ5JIBDwKLKdeKdTwxiSqzOl8R8JLjQnqn6AxHAjNUCtCiqfoSDb3zCUMrFRYEwFG34C5RLsRrXTq1/JfJx4HQ0EIoUWsYlAuABRE5MBqnqlTkyClRsbBWGnJHZFYjC5GENCwQ4cjn+TmuT830X+NbwtW7wP2B/+ls16Uilj+FuFRbdl1KOKBMhdr/91fuHSgUJk6l1YMJwNrU3V+oJamtIvhP4blPS8rVjJYaJVPcayPMIfYbkDJlGgTMOk0TfW0cMfmhME0ZZoML1COfEiPHPdfF2bzUbBxHbyuys8W0WYEC5FVRV0xQG1nWnweUUKSNI6MopksWAwkegPmdbcLzx2K+f9QVafwmaEl9TZ1Khqsl6kCDw4ZH/4ivCl4y1RlGh1Uw14jPMWeYW+RBeMKRzQ6BTwqDHGfo+5Kj576i4ycTQUER0lbFFdj13dlYkBLUTDlPxRrCThjtilVWE/zTlgLDIchPsjgkt9ThKGUYgq21x7lZwH6qJWPx21Z2+rFw6Dy40T+wSetDQecliCScAp8mQj1Adl8Fhd6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:12:12PM +0000, bot+bpf-ci@kernel.org wrote:

SNIP

> arch_validate_prot() in arch/powerpc/include/asm/mman.h rejects:
> 
> - any bit outside PROT_READ|PROT_WRITE|PROT_EXEC|PROT_SEM|PROT_SAO
> - PROT_SAO when !cpu_has_feature(CPU_FTR_SAO), for example on Power10
> - PROT_SAO in a guest without CONFIG_PPC_PROT_SAO_LPAR
> 
> vm_mmap() -> vm_mmap_pgoff() -> do_mmap() never calls arch_validate_prot().
> Instead do_mmap() -> calc_vm_prot_bits() -> arch_calc_vm_prot_bits() sets
> VM_SAO for PROT_SAO without any check, and vm_get_page_prot() then adds
> _PAGE_SAO to the page table entries.
> 
> So a program can create strong-access-ordering mappings that the architecture
> code deliberately refuses.  The Kconfig help for PPC_PROT_SAO_LPAR warns that
> using them may cause issues when migrating a guest from a host that supports
> strong access ordering to one that does not.
> 
> Would it make sense to validate prot with arch_validate_prot(), or to
> restrict it to PROT_READ|PROT_WRITE|PROT_EXEC?

arch_validate_prot seems ok to me

jirka

