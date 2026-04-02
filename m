Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7330AD6AB10
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 22:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A276B0088; Thu,  2 Apr 2026 18:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F36F6B0089; Thu,  2 Apr 2026 18:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB2A6B008A; Thu,  2 Apr 2026 18:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 461C86B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:59:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D75EBC0320
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:59:49 +0000 (UTC)
X-FDA: 84615134898.15.EEE8006
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD6F3A0006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:59:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwKqUIy+;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwKqUIy+;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775170788; a=rsa-sha256;
	cv=none;
	b=5v9iWbqBcjLVt9KbNgmM3d/uHPXD+Nh1WAr1hlYJixJ8ZsqlfV2iYgYC6iXlmbxmYtmdUc
	KxkGluX7f3k77ye9J73PlAQCUQibRqi5lTRipfHqySLRojAkRu0OMKTO9JXhRZ/f1jxjcd
	XGY5Ov86JtF3RU+tCRtAc88G0/S1mTc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775170788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fj2n4+8RSNNQ4hFLwQ+MAKeriInu9l52XyRzVTdRk4g=;
	b=MQlgYPDoKDdpmbrU6zb9P2VVSyWxrZUfs6+sjVYGTFVrbwDGk+SFOAnFSeE9fGAjx+u+R+
	mYhi70D9ilhyx7LczFwL/aLWs7vsYfJ/RzhsEiWEX2XXo3NudwcmtsiZWq6jytOS9EIMfL
	1AYcSw0/R4lDqaLYFvJLtZyCT5qvxmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F37144188
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F345C4AF09
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775170786;
	bh=IXDLZwK84g+fmOCQUi8HrcFpz1Mj1YwHZ8ufqEh25JI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fwKqUIy+l9jYewAdMPjvnSntgcGBNuKO25THt417NTTh0sm5Lpiny+ryuYyImBkYB
	 88CBPrqALZDbKaeverR0rjT4m2hNtyPnUDO4zYMtBpWDpiEmtVwyUzjWnCxFqangEq
	 CWBbgRPqyoTz8d0857d0lZAXOPFw2XcjIGivnRCGcr2wyu9gZRYBOg6M7oLjyCpVS0
	 E5Cx9pNXJxS+CYXxCpEaf7Ph8bH9HGLH7aldu98ANlWQm+btS0895xll8UPkJJc+Sv
	 MC8XXedSvq0+ezT1GCgJH1ceyyQTAOjV5gwtorlxEZcZpFuytUw9n/wI5dZQV1qOnZ
	 jTzpGqR+xrLyA==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89cc797547fso15945916d6.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 15:59:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVxI6tkIYxmNW9CqxGwWbnDrgWJGSxwB4YqtD21n4a4WfJTgaUn9wRALIzVemdo1nMORGx3fRQJmQ==@kvack.org
X-Gm-Message-State: AOJu0YwjmijFxUfQAgCGe54HGFW/A1cTtkQnQJRRf1hUcmx6sp2iRBdH
	mX0Bkf/goLN08fVuyxMC+nqKgL3WHP7YQvnMOPqAAF3vMtBs0tbI/8P+qINkRMZmpUAHZ/EtOfg
	hS2X0Yo4e9Ye1VFk1xXe3q4zrKhG+pTU=
X-Received: by 2002:a05:6214:390a:b0:89c:c5cc:4bf4 with SMTP id
 6a1803df08f44-8a7025b4c78mr18671826d6.16.1775170785688; Thu, 02 Apr 2026
 15:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 06:59:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x15neqzYW1qruNUSeFjJuQokkPxrCJ_D55VSYZ6-bYNQ@mail.gmail.com>
X-Gm-Features: AQROBzC7p7DrgbgfadFJxYkl_0pYUZb6i6iGCRKZdri3dpJ85b9LLITktIQQfm0
Message-ID: <CAGsJ_4x15neqzYW1qruNUSeFjJuQokkPxrCJ_D55VSYZ6-bYNQ@mail.gmail.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	"T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD6F3A0006
X-Stat-Signature: 317xrzy49ftszmbh1hk6wh4to4gegmfx
X-Rspam-User: 
X-HE-Tag: 1775170787-501405
X-HE-Meta: U2FsdGVkX1+LlmvtyoAB07s/EN54hzB2FTEIm1UZzGBqvXkjNZlxHCPUyI6o0phnQW2zNW+5Le/CfiWE7HQJGk8iYgGZMIA+bSPmOLgo0ByeGCyaAwy49hARoelSmdJOYyRYeua6x7GC/mLGcB++/muSr9xPp9X2yBSdNW9COZfpNkO6Qf+HFQLARH3LsLIK7MNRtpym+A0BCch/55EpzsFWfdxPg7C4KMfxiC+G7ARd9IHLFCeW10vRpE/VPE4SXCo7c3g05TcCWBThoA7iXz6Y41C8kbuTw/0LdZFPxbgxr+oz5V9+Z/YdMGRl/yT4A08gSNp4voyQo1CZcYZu+EAWRKNqm+VFwa53COGZ/rP7b7Y7UAqyv6q882uilI99z7XXpgPSN97JVB6UK3B2gYIsperud8yR4B5fyz/zEApAe1eowv2CkZGM4q/p8qYu4rRQm7g7O7932hjaFIFvdSZOr5VvE1xKshkj9tllpYeHM9P51UpHJV+BcWEbl5TidlilcdvIb8CtG+fy4gdPHMqoHWtiWtlbiG4taz63cXbP+J66ODKWX2PDbO5Pbty5SuJos7djmi8tbTm4ovAWE4oEbBZAqIe2i0/U3JSPOEbQbKztv8oJDusTy/YCpBhrRMCJtuJI3EC/1bBmhA68yOevGkunUrgtmgQXPDdbp/6aaN36zksipIH/v/xIzMo6Jnkb+mplt1NztwQlF+3u4xkUsA/S6dtblbtqmcAksiny+gouYPTzYkalC+hC25NXHh/C6mBPtzFURfSrnUH5B3MiywEesAgMQHfL4eQXFJDnhfp4imEv5ST8nx0vpsMJ2zA2XCDWGPAkJXcAfxe29iq03lXqLd3yn5Uft5Tcktf/p4/04qwclgSNKvFkKy+WhidLG8RKcPxCHZH/zyJUAHn4ZBleiRkhh+mgAzULlaO2pkImNVP7AYC1CWS0petas+AQoHCmb7dn9MN2/HU
 RQW76vTp
 jJDaM/sfIMn5oebtGpifVcxJf52ZJVECo5PgJaT2WQE47srF4Y7JpBKE1mWlwaEBV1L7T/SDsHIBHFBKQ9YnwQkk1kP6kPiXzgRWcOjCX2LwLnUAnFylHCUWxzFa7QGEO12udsC4HYgqbvDb+fv8GpGVzHft568W1bDK2lABUJ7XI6SeZl0PtI8A4pjhZD2GutFnZY7/lGCS5TfesMVu90he5eg+YvrBiW9y/mdlejiipOsJC/5yb4/+TkFHSEt65MwCCM8/sHeA/gjwOF661tAuwww4wmNa3n9IICVs88Mr9zCT+/sT8y0smqbArw6j5kzmyV1nnqlfIqByrtnmgzp/5KJ4YUIHJOBCd9QbHWYeIFzM7tF3t7szLfi8LQTLoU+g9/DDerCef+OlLrP2x7wTOuNQX8WwsoATuvUB2AI4CIkCasiblmAsaFSDKHvZX4sHMJiriGgrBeoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:18=E2=80=AFAM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Android systems usually use memory.reclaim interface to implement user
> space memory management which expects that the requested reclaim target
> and actually reclaimed amount memory are not diverging by too much. With
> the current MGRLU implementation there is, however, no bail out when the
> reclaim target is reached and this could lead to an excessive reclaim
> that scales with the reclaim hierarchy size.For example, we can get a
> nr_reclaimed=3D394/nr_to_reclaim=3D32 proactive reclaim under a common 1-=
N
> cgroup hierarchy.
> This defect arised from the goal of keeping fairness among memcgs that
> is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
> bail out when the nr_reclaimed achieved.

I think we need some clarification here. Does the code

nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_scan);

still serve a purpose, or has it become less useful after your patch?

>
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> Patchv2,v3: update commit message
> ---
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..10f1e7d716ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruve=
c, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> -       /* don't abort memcg reclaim to ensure fairness */
> -       if (!root_reclaim(sc))
> -               return false;
> -
>         if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->=
order)))
>                 return true;
>

Thanks
Barry

