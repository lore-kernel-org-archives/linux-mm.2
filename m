Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89416EE0203
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AAD6B0088; Tue, 30 Dec 2025 15:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737D96B0089; Tue, 30 Dec 2025 15:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F736B008A; Tue, 30 Dec 2025 15:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A886B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:28:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5272B8317
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:28:06 +0000 (UTC)
X-FDA: 84277274172.10.0F6B22E
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBE491C000C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:28:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tL21e+gL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767126484; a=rsa-sha256;
	cv=none;
	b=uv2ZV8Vy1WUz3W/KNVBlM4FS2EdBXm1ECZCirD/g6f9ukEm8UPk4tWcqZAuhIiaregUsAi
	xcEnifikbJgUPt9uOG+TUc+JHgf3tFV/NaZDtyzbbwXeFdyXxLd7nBffoxr/SBbNym5OyQ
	WP+7E7qQGWXAk4QN5DpFg8DZkDWJ/nE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tL21e+gL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mattbobrowski@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767126484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztPE8iH50nMPfa6HL0qHJ1nqnsXkThvqgh3cI3Vnq7M=;
	b=na2M+Uw1rWqobqFLpd5DXaLUCrxRKEy8Y4mfyw1XD7vGMfb1HzTvnb1o9i0Ln1hYf77SN8
	ly22NHxYtIz6/4IrCDlzellfMo+KsZ9uwf2Tft3uVhehvCfe79TyMmfDoNw8ZB0kWv/U5I
	7aBTUBpO9HM2UMgtwW5EBkAjwk9v9Qs=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so2110587166b.3
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 12:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767126483; x=1767731283; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztPE8iH50nMPfa6HL0qHJ1nqnsXkThvqgh3cI3Vnq7M=;
        b=tL21e+gL2dqhKEkMtC+SFuS4uEU7MAgw17QW79OzSBI27iFRUBmUCESTZagADK62Jc
         TgDDvQamzhGxqWryhFLr4n08jXhrwqtuPALCum5Wi1I/Z5L4bCWJw+vygWbxwY/2JQs1
         j2Ilv+oMxHehLyfl5+b/qAGSqa81hbnESBu/dTW3Y0cNbr72FgvpMfeLlYACjWmBVoVL
         KYVDPbZryOtcYnpG0+W4P+7tSyD5cIRMnyIshskIQMXnsi7cX9TwRs5aLGa4RDFVsVcN
         gbk4OntDLD0W405yvTdoNewzDNXPnPxO9lR18hX6qQ3NMnMqRF6VCVhSI5yJqA1CWOuJ
         lmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767126483; x=1767731283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztPE8iH50nMPfa6HL0qHJ1nqnsXkThvqgh3cI3Vnq7M=;
        b=TVVhOR8l0752R4WHXPyraPLmUnu73S5yuD65nhe1JDv1WBpjO7F2/TbuRzfLZxocU0
         V/0SgNo2waX3M6h6zDN4H8IFv/OMNVz+Kl0f1GaoOXVsigEd9v9ZENNf5Y6SpH+18Afj
         8UC9iD/sa5Pf1EV8Y6EqeWgtgeRjCX/F7r8nVbYtChEid6lJHi868eaUT8WSQsBNUI/U
         WGx45hGeZtwY9hs6I1U0I+gQ/ENkfpu49y4p191V1XiJwJVsZeJO59RCCqUWl2FatiMn
         xSq8UvNxRPTvPsRNNDcNuvhBjzGkd3CpTvjv7xvWg+oXdNC5YqnDLVEhUjC1LqtIRzeF
         XOGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz6w+RKAClj3cH/0Iehjj8W/5ZBQwx29vhdZ8/bIURkn+ZI0fb+sTtu0keh2bRqNEFlasE4vPfdA==@kvack.org
X-Gm-Message-State: AOJu0YxolTqmCpMdyG6oG4Fj3Dyj/M9kjeV8UGPbH3WZ33dl/DCjPVsa
	SMB4rssCbeQXLeaokNjEk7465nZ39cfppDBB8QhR8kKf1bHyqfgV/itXGUowqQj4nw==
X-Gm-Gg: AY/fxX6UZMY3iRuWKFeiFe0itOe1YwiXd5vmVuGJ9THBW9Sd+xWywM7G5sFKFTjfCQs
	xEVlff1Wde6kn68KKUr5NAFLDFK2rWwBYpTcJFNGL/PKb9nh5VstdbanCQO8hTj3XY97Y7pIWAV
	QONAwDR9Fg0kUnUDukz4+/gNe7dZwSyzSlok8UJ+5AH4s0yhMtX/BiOLzerXf9oxShG16376/wq
	DYmJ0dSGhStbsGye0Ib6RdVXZeP8phgzic8FHLAN2TkLJeDBAToHgnnjsEIiq3PnaMzugcqMn4N
	24Mlxaj158qGEpRAtpL+7/nNl5BOissz65kOP3f4gqmIHF/U3LY7MAA2yBPZL9r56jKN6s7g6Ka
	/BkkzvrdRNQugHA0X1Q8uuXKjaKDCLVcwxZXk8pJd8UjwdgsLjOUcQTHm3ezdiSbGQvBAACvu0g
	qPh3vHv+HQkWK7yol7Mj++ZSGHHBXmGhb/VyKmhT0s/TC2jplamgFnDA==
X-Google-Smtp-Source: AGHT+IE6klKBBpPwYZcs6xdTSJ0fjAfHgeE3C/83ZK9N52lbmSSXdkT+x85Kgg+Uwb0dJJL5W7RgZA==
X-Received: by 2002:a17:906:7315:b0:b80:1b27:f2fd with SMTP id a640c23a62f3a-b80371da6f3mr3750815066b.54.1767126482937;
        Tue, 30 Dec 2025 12:28:02 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f0e8f1sm3731533366b.53.2025.12.30.12.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 12:28:02 -0800 (PST)
Date: Tue, 30 Dec 2025 20:27:58 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <aVQ1zvBE9csQYffT@google.com>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223044156.208250-4-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BBE491C000C
X-Stat-Signature: mwbr46ydnw4su95odje3me9oxcurmr4n
X-Rspam-User: 
X-HE-Tag: 1767126484-949885
X-HE-Meta: U2FsdGVkX1+I9KYFh93/n4wPxeyg0P7OVfeZaUAGUNmW9+VI52rgayS1pGYOGrnIYEnOue/1ZpZt/2marjkFtPLRIV9A0Q5AX42RIx4BMaMOtvimMo8/fgFvGo2UFIJ/LOBaNLVgB7BFiWNiTW7BZ7H177zFn7pnr26HAP0T2DG4cZTwLFG666lYlQJV/zYOPlyTB1H9k0pBNtiXtA++xDNHP8vwosc4o11erK7BAiuVsUr6Q33dEj7BoLtDeLnUbgAnWHhSZZyrZCxVR5WDPwmn4Eqri2/j5o3fj5O7Pre25QxitIAUf0eRUW15N/lBBz3zZhB48YoEIxrzQ5lODtem7L+JO5VfU7BWaK9pxfV9Kf2xm7c3sNQBNhAHT104yYv2jQ63pzUqorkbfDKHQy5/thsh3/v1o1fkCvQ6/5LIn9Kjes9QBbPRLAXiAA4O0W5Ycyo3FGuILwkUbwddWvtcKJk5skjAIRXx3F5nE2RNASG8GBu9Noy86BE7teuQvVyOXT7uLCVGPOQkyeibYtDQqkJq7q+bMia4MiDU9omu7CTt92a1NHkcXkT0CRwwlLwMgr0wnjze6VOAEzo88relv2bf3p+MvFzcfZC5k1h3t65ipmZVGXrb94Vrib/z6Wn4jn2jP99+pp62AAuYDvUR7TozbgwbN58V+hJMifUV97D12ZbeZGNnarzBUJDOfj+VcX24YeywpPKo4rNZiOc22ZnLQ4PyJGrHFVtST9TFo5QInm40FuklTYdSwf9N5YzCsCqKUmXw1MZHa8RPVg+244xECkSXoa7KajjpO4LmKrRJNmVdsTU6FaQAf9dWQzDRX4ZHczYx/dLuXEhc6snFxzQIfM59r6Z1XmPEJAsteHm1dUisI1Vf/BbC9JPkubvQV8F8rdyp4PuKIcaG9lI/r3jScowPXY8bMu3r0v4gJ/3hDHh6ztoazSkZNhrHjQh0Yar/kFEojt7cZQf
 NFCj7LA9
 KS8U3noLn8Jr0LQLVJQ3sO9eWaODRkWK0fxRDOYv7MZpOjt/yQQTBL/gFQ456/EXPvMByexQe63RE+K/9cNfD/Vuzn29Rf3TsgsBdabeVqh+IU9Yihai+j4QSVlCGhCgQ8tpZGWWfV5rKNNSqtT7QiPZW6x0Q1A1gMP3vQbZAg0zgDA1FOfy4yfq0ii/Tg1ov7/+oR+2ICjAHfdSOY97GI2r4LqE/AUkrkwb9qeyO9eOsRcHqsevjERbJdXFk1V3ZXupMKjO4VAi25ZDXXJf5o+rAmkw1LkZSRt4L/YufFm9ipAICdMc/s6yYZ4GS/KCqNQ+1Y+zxSyoqpkKpP86Fmcgum/zyGeVmgoZ+ellqc7yUUPXNMCsENd7tAdxJiyTCPl3p8MdShQRsC3xvN/DNxNP5/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
> Introduce a BPF kfunc to get a trusted pointer to the root memory
> cgroup. It's very handy to traverse the full memcg tree, e.g.
> for handling a system-wide OOM.
> 
> It's possible to obtain this pointer by traversing the memcg tree
> up from any known memcg, but it's sub-optimal and makes BPF programs
> more complex and less efficient.
> 
> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> however in reality it's not necessary to bump the corresponding
> reference counter - root memory cgroup is immortal, reference counting
> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 82eb95de77b7..187919eb2fe2 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -10,6 +10,25 @@
>  
>  __bpf_kfunc_start_defs();
>  
> +/**
> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
> + *
> + * The function has KF_ACQUIRE semantics, even though the root memory
> + * cgroup is never destroyed after being created and doesn't require
> + * reference counting. And it's perfectly safe to pass it to
> + * bpf_put_mem_cgroup()
> + *
> + * Return: A pointer to the root memory cgroup.
> + */
> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> +{
> +	if (mem_cgroup_disabled())
> +		return NULL;
> +
> +	/* css_get() is not needed */
> +	return root_mem_cgroup;
> +}
> +
>  /**
>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>   * @css: pointer to the css structure
> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)

I feel as though relying on KF_ACQUIRE semantics here is somewhat
odd. Users of this BPF kfunc will now be forced to call
bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it being
completely unnecessary.

Perhaps we should consider introducing a new KF bit/value which
essentially allows such BPF kfuncs to also have their returned
pointers implicitly marked as "trusted", similar to that of the legacy
RET_PTR_TO_BTF_ID_TRUSTED. What do you think? That way it obviates the
requirement to call into any backing KF_RELEASE BPF kfunc after the
fact.

