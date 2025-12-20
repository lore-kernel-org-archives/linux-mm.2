Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D4DD637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00FC86B0089; Sat, 20 Dec 2025 00:21:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C9F6B008A; Sat, 20 Dec 2025 00:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E770C6B008C; Sat, 20 Dec 2025 00:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7F106B0089
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:21:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71B081372A8
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:21:47 +0000 (UTC)
X-FDA: 84238702254.19.E3A6AC7
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CC7D80008
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:21:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sT6+aEOB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766208105; a=rsa-sha256;
	cv=none;
	b=oL4KynwbfGnvBsS0jwy6xd6WuMCEcXnsYddA2M0aKiaDLwf3Z8lkMQWUjGeG/nO/2A4DlX
	IQv5/tvpNsT9jsQ1mI2Y242Ic5ZXdXc3Ezq3rpHJCQYja1tDjXzkc88pWozXkudUEembwv
	4GXNKHHDcDvaFvMgfdmx109RCKT+BAo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sT6+aEOB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766208105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=souUkGn3xil7wv4noOJluLBfspbrG8JUK1OG0jc5tDQ=;
	b=IlpkhcmJYCL8iBEo2HEun3zR4m6a8DEtwUTTKUL9DiN8qRpZcILxxA8Cw+2AgDSKsJLifi
	//D3qodutVhr8hf4hB7Ex9mvUHsYNrdr5jOaLbbP76RUx12LFk5yvSegorhJrts0AoVjUC
	iuVgSTrECXk6909ouESUq2HJ+uyXkW0=
Date: Fri, 19 Dec 2025 21:21:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766208098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=souUkGn3xil7wv4noOJluLBfspbrG8JUK1OG0jc5tDQ=;
	b=sT6+aEOBs+eEyAGqMW9JXOhT+7sbFm0WwvObsIrrqBh4a9WVh+pvCR1BseK/sXTSQgY6iZ
	i2vVOs633gKhK8N0cFFvKBM9zJbeur+yAoWwuW7+zFjPArCD68XJgkXzlM5PMvrHxOmHuA
	fobiR4hXIz8Rm3S7oCsbF52LzEnI+S4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v2 3/7] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <he4iziqotq6ecucq5ipqukwnetonwyzl2gm5ej7ii3ltjc3lue@xpqxrvcblquj>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-4-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220041250.372179-4-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CC7D80008
X-Rspamd-Server: rspam10
X-Stat-Signature: cudjwo6mkcn9empyy5kx4xtm46pnw5px
X-HE-Tag: 1766208105-81952
X-HE-Meta: U2FsdGVkX18sVkNrV8NJWwLnSd4ZpuSb01XQFDP4QPBiX4yYz8EBo6W82JWauzG9NMRPiTydgpchQfeIWAP1HNyp3zzktYaovA0cB4WiDJYnhFFvWq05O+i17XtMLoryaPtAjoHwRSx9EhcGKTWeobQhDbBQMVSjYLCpocpngkFjn6xcl2x5UUJ0Y8zsBW7iJAqBTE++2xDRCM870GGSy/IFp0SbQwIsEr4wu2KmLWcDZ284qo1/vAesNkqNPPLnb++TBL8P/nadTHqKffRiZJFBXsrBRfoTnfsIe/Y750w9SDyeUkzEMgMrwDJf+kT+e/V5IDtFZP+NWBnxIela6k2T0LhLxGpRlMWnJhbLibwVHOCuHotOuCkMRtJnlhRBNyo7EBuRlcQalfuvjlBnDf/apWDSinkwvpS5pOHgpR3MDabh7odlfZiuzrySWcmSATklmY/++Q2rVVg3Mc3hRFFPo7+m9/xBTKW8FsYuGb5zZFYP4zLTxdj21DeYRf/370gJNEZOATjL/tokYTQkPKf1j9VGYoNZvXTB6Alm6aQjscsqB7Ur7TJk8nAmkSr3egfQY6VzYEazd/OEUvpZNyvBYdb9yKpu/lY0/UDRA+/+09+2H3dWDet+zRHy2k1Ew/6uzqNVOTmqhAMgsqP839Z8p8wDSE3zHJ/OuvtSHdPwhIsCfxtXsh42yXGmrupShuHwL6tw3GarfY1Jys4i+DmJGqCRl/pgHR8E7zTs65LoWqMeNZr3L2mc6XRcHexQQhRkVGFXVvpV4u+0flJQJE5f83zxEMHMwl4jYew2MzK7ULfqtAsIW9TI/J07Ioz/EJSLdSC5v5mLCdw4p3MxR/KMsuZNNr8F422hqx7DTAGkiGPQl0xRxWGsAnDpYeaBCZQizL/+oNW6ahwRAr+I800lv8u7kOQuyA87wFHHPHAxJhSVT+Qge+YlRtxf9Dgkt+db+CPmoeqAQCMLQAY
 KV0XQxZR
 B9KfaaMfmxwBXuEvYD3R6ZAsUkCtTD69cK87qBtgl7C6aFiDqiun+r0bG9KqQNkd4xfwene8ubaZwSJS726lYzPeiT8Dky3LqJ1FmeS4qOpwqkzoXlS3Dtt/ixS/SRXGQHSLEG+5ZyWT/uOpu5gEVpSk45VRYanuBt0NmSOi8qqXDQyyJPNTtmO4HLOxKE3fEhCkNVfCd8YGOAIFjGFz1uOAVjiVSq5QDykNVJHwxaM3uWMA6T3CXNAVXR+d8lh0/UPjq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:12:46PM -0800, Roman Gushchin wrote:
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

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

