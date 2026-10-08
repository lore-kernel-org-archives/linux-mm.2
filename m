Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD91CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176AF6B008A; Thu,  8 Oct 2026 11:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127C26B008C; Thu,  8 Oct 2026 11:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DF96B0092; Thu,  8 Oct 2026 11:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D14446B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:45:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41D02C02EC
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:45:58 +0000 (UTC)
X-FDA: 85299884796.27.5F9A765
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 465F9100005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:45:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrIh4yf9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791474356;
	b=BAUvWKrQDIS82rIdTJy7RvBViNvn5npbZ1oQYU2aaq88YXpievT+sWzKyWRw0bNOrernkb
	Jo7nslpf53dyzo3IONZtPn5DgmRjiyQTTvwjvz/BqwCBUAdwqOFVSZ8c/s9QB1lQSjd50x
	dnVhlIDgePTPpV6Y19Wj4TaVdWLdIiM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrIh4yf9;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791474356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMnHgdALhTIdH335SS1JWqGcsAemorh3HiZSx2sD/OE=;
	b=O3naQYF+E8bYuOF0VSoTEfPyrqTE/sWQZcvzsvunKVX+ellicWEqWK9nqmWnaw5OPFM7xQ
	Ft3bS1davEwzlmPMYoj5DMEFMDvZV4Aggseb/qXnfg7FQKRnzxoGsnWKuXxW01EwJu4lZX
	2CE1Vo1jav3Zp8VOsFN1Kx0Dujjw73E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FE9A44512
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5773F1F0089B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791474355;
	bh=RMnHgdALhTIdH335SS1JWqGcsAemorh3HiZSx2sD/OE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lrIh4yf92LgskJW6M2gmVwbxqg1gKrETOrjuH7gAwHETn02NnFkGag1WxWSWjIN53
	 FdSxRgEBV7J8yKwOVJwYNBokYkXIAClJ8UUFhNfwtj8w8JPXmq6GmK44zvBOz1v1X0
	 QwXn0BvGLuOl5xYt0rfqXgtt/lBTzQGT9GEGP/XfO77f3/XUjzxlJzP2u6k4wbJdpU
	 oNgda12bKpdtgJu3OwqHHNG86maZUIpQtaCeMx9zT3So+YVZuEKY+nzP0gnbzRNyYX
	 0YOtqBfJcBrSPQdbu/78q3rM4oI89cG9CxzNHLIb7/c3UfalPabcrrKyWGM36RveE5
	 CafQ7DMKN1F6Q==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e027da22eso219057985a.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 08:45:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwue0Iho/A7envPNsHLVdC2cKg8tOMawZhZ1+AoA7bsYmLpPsZDj+IUELOS+94sc3iHspdRcG2s/A==@kvack.org
X-Gm-Message-State: AFuF++l+2rwdckFWvBsEnp74EYc3/piwC+6BRjLannko0eepFJL71g9W
	6u3U2bXDLwbFqUoq+296zSsmYGnf4IYiRUFwk+MovUMbDSWchktEVgk17BQ0Y+fpGZixziXBd1o
	iyeKYXnO0bEpokToQk90QxAK7+zSxCBo=
X-Received: by 2002:a05:620a:6291:b0:93e:9808:8d78 with SMTP id
 af79cd13be357-93e9b89cc16mr1090696085a.82.1791474354476; Thu, 08 Oct 2026
 08:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789096175.git.zhuhui@kylinos.cn> <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
In-Reply-To: <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Thu, 8 Oct 2026 23:45:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wcheb6SU+rLvytyYKTpgM+KJX7EkVdyHtrte+SZ8y+PQ@mail.gmail.com>
X-Gm-Features: AclHuK-9KNuqZwVP5bNEpa-Kkkx_AVc7sgo9C18bZtSYiBs0_n5VK9YJs40_Qi0
Message-ID: <CAGsJ_4wcheb6SU+rLvytyYKTpgM+KJX7EkVdyHtrte+SZ8y+PQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm: workingset: use lruvec_page_state_local() to
 count lru pages
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 465F9100005
X-Stat-Signature: cg61zye1yybwk9hzzngot3muod8hwjdo
X-HE-Tag: 1791474356-978066
X-HE-Meta: U2FsdGVkX1/fTWovvqyGQhWcHkwl1TkeC/8L/QnMIP9geihwRTxzjCZILl+nwGHeDwzw8+FehuCTcNk3Iy9xlgMXixOg+npTF5/hvBU2j+YjeXo0hrHRu6XRdszku/dkH9N8b6VjAFgYD4ev6CH4fedVy0SYMyN05gsjhaUd1lAB+2u49LisKZkpEj5q9UAiqjjCzcjHFhZnPhyxkbljac8w3XFCTYowLqulDiKGu41SZujPO7qDmOjrxItAPIcsf5zX79wr5qquqLOXPkyhC1J0L1IsBch6VZoN9FDvb+Ho1MGrnx5jPmrq2sKfcodB4G7zXJdAcYrvEy6MWfjMVY/nfPo1pInkMifyvTTbYeRh+vVIXQjLJabauZluYfG6w3LKKD3G+l1rwMNayAsMzZlbpAX8KViV/1RYAM6A7qpHuzjpPt76CqaNGsphKAPRGrzIMDZ832IB4UM537snUB68Ex/XbbuoZkyQ3wgtFv6/d2j0uhvkjXTEUgEh1IAO15orzM8DpdA75S3inHdGSrdbeuyMsHnwBOPIE1W2dV2dxmS+o+XsivcnBPFOAGLjiQiffLbJG2LEDNACZ9CHyPtFa1sRNF7yym/aDPf/Mzj5qD8xfH9XU8IELqZuw7Q3NNTpc0ZSm77o+wol3MJRDPF3u5LHkw9tn4oS1UbV6UDzcknC3v20I5hxhxNKCxYxnNOGmPF6by1FEVZKrYOtR1pnj4zGBJMOET3CeGM0sKXGM5jniSJ0i1QbeDxWbWYjs61gkovNjWKXfrOOM31pJA3IsMzby42IaLJmD/6x/+ybpOvOBFYRnvuNJCTAOIhy6jwyhDwXzWNUnCGEPgK1QTyzosWN8E3NKxPKOnYp1Jgoqarn/xKnEg9S/dKYbFJANWhZlt9ENLSovpHBoQCRC5f+dlapPp3XfPzUzKJEnB/rVPG5WKrwlVpyhelA0W+zgdWgmM4sCOO+tmFCPWW
 1T8LIArP
 FwyywVr2FsT/wEKIzlanKo5YTrP7q3nT9XU6MVtP5wJdR4CXt6XVfeEMH030odjqxYhqmVxbLPeH2L9a0SNwYap0SqSzIFfBSqs4p9DMqKj4NhjRlfgW1c43ttGqGyKn4lHiZLtl3qz5I46c1A43+lo+c/poNHFIlRSW678z2dkqSKaw5No7FlQFzVdBJlC3T0w+P5V6RqdwmNjzO9GWETpxr0aPNIijUcSYYQ9Bgkqmxy+sTFvExuV2jIpiauRi3mymTvRfcHAvo8T038tcH/YUTdRtFDt7Ug58JEZMknJkN7mINDLb4cMglelng0ADHH5f3EiMmW6h9p1gUCljB+Kv613xCRT5wE8+5R7oEgImxEhKK8Rl9kRKVIbEpBEZ3Sm66XXJJxjD+gpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 4:01=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budge=
t
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as the=
y
> are created, losing thrashing protection.
>
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the preceding patch that
> redirects dying-memcg stat updates for all hierarchies.
>
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the nu=
mber of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

