Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A41D606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=luKLl606
Received: by kanga.kvack.org (Postfix)
	id 9A1E16B05B7; Thu,  5 Nov 2026 12:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979556B05B8; Thu,  5 Nov 2026 12:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FBD6B05B9; Thu,  5 Nov 2026 12:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D96C6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:39:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6906C0BA7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:05 +0000 (UTC)
X-FDA: 85401776250.29.48C782B
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id E080E20013
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:39:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=luKLl606;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793900343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
	b=iu48kWsHJ/MJfLuuiKcA5gxjpXRxo4S0rdFLd0WYF/c9vm08xN6TQPgQxB9nUpz7/v631F
	KCf6UWDZSXGiGk64yz6yJmESnDvrM0//I+Pr3bKt4Zy5jwtcwtRU/Kvkht0vAg86dPThKi
	8E+j5utu1R7WzsvcI6B1S4F7WeyilIg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=luKLl606;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793900343;
	b=KSUxFHMiIq2J0Xc4T3i8LYkMcD1/FLA8tNYeFTnxJlm9QTP/DM3CP5r5BFAGLTuTRuD3t8
	d0LMLB7XbDCmq22LAlS3BIyegzxfHbLbbZ0aG4h6ms3ghUTbzrFBCp+aqpP80GKxNDtSxP
	Bc6jRPwdPdNpf7PoqxKJWXW5cqPtt18=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e46e449e8so1360344f8f.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 09:39:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793900342; cv=none;
        d=google.com; s=arc-20260327;
        b=NTQGCjUiZnMQj957cF1NgJC/RVg15sV+p4ll2VS35/CCkjynVeuVkjoxmRs2dC3VXc
         Mfo1weyQo8PlxT4wxpvElvcCrtMTT0/EzuhEq4uuqIGpghvnL01/982gIjm0+e1US1cX
         J2MfM7QmxaLTcCE8Ea55RXjD2qV5qETR6nmsFHhN5/cyJoNPUA/qRk4kB+iPRJ8S9u2d
         ZZjje+L9PP/7Hlt4rfKL6yl26NY8NQrxefCzG9nmXx4pJTePQoRC+l2xt3YKe59U0jx5
         KknDH4qFp1ltyRcdimHVu7Rkuk9/1l5gPyqNM+WNZXfB6gBDZVFvDI2V6818Rtgkg7ef
         lK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        fh=qDP0nxNEJuf3ZPIgD93pshyi2/V1p5pZYe+6iE2tR3A=;
        b=JvTAjhy4rkH4wnzKwYp5k4QDL6RmTnAMTmAmTeWEJsJMVV0qUqimaRVu71VBJ4Ezn9
         YMLxg+KHc0g+EkWjbW3nAyc7q4TNqHxSn6UbZPzIMgJZTDhek3HWyk6J8nlJ7QDkc6WE
         uvWC/UagrWSpbVZUmm3I+Zblex+Ix93TG9iOUw6zXkJOvUr9ykSZUq6WGUZc8XuMLMqA
         2eeTWwH8FMuwsfXRMP20y81S94JF4M3digNezKMeMkYUgRmujHFkR+F+zAdYwPNN8xQR
         oHWgaF08RyZ6dE7sqxfO006JbPvE7SFRuqZZL+mePa8w9cPiv5LNhjSGG3CHDN+ck/c+
         R6aA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900342; x=1794505142; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        b=luKLl606MDJ1iCa4GQcFzFziuaj+E/N7YxbXhPHfS6XAakmEII+TcJQ5D5U9Vs/y6V
         98pS0coclSyMJ/xKALW6nNRxgfZNPs03w94T3LnD/6cISyykUC8fISKbmvNJDN6454S9
         jnRF+j3ZhG8OOJMJNg3RioGTpfvfdlNpwv9y9OFTBn/IG37A2r0cSsNSeRiFX7gk++5i
         N/L99tWgBUaL7eZ6LZsMiKgcpd1rGoPx5ZgdJHT6E9sromkvdqge/DqicsTw4QrGTDf1
         7vFLUTS2tLs5DnFYrydhKtDwrd1YCOIOsuf5+mWGH4osNlgt30o/rM+JjteUAA5UKT0l
         kQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900342; x=1794505142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nqw4yirBXK57TsA0wfsU6JHIgj6p3RFArPkzpDymZNI=;
        b=o1Zf/v3rM9EsY/KDeeVVHXFKqf2w6lPsCgBj4wZ0e4e3p4yY/6NfER3RsGZjVZWVbS
         NoIoVfM2Umd8VeG4E4D/3F4IFRcX9I3xm3RgskDsogcyG/WTeSYBKbwGLPz6RLcjfKQO
         ttcCIikHV14iZE51E2m6hNA/GJo28Z8JvAF/4eS7fRSykUcDrx0OVA4mLfIV5r+v4Nli
         J45/CH8r60iA+PCk8ds7PzKfXMmVEurqm8OSPBY7YMJDLulHpBRuJYvuw7wNQHWN0gvl
         ScdDuvTc+5hVJpJSBo6zGBdxhsxpeappnFqMe9jw1EyFAax9ZNQEZ3ERkDb7MKFnaxXe
         Oy4Q==
X-Forwarded-Encrypted: i=1; AKwUvBzgdqXg/r63MIbCPVbX/ldADUkCmHo/L+IQeuWpxrwZBwyb6C8bkJ6wMPzIjtiYg/i+G5KhYekh9g==@kvack.org
X-Gm-Message-State: APuU4Z/Npj9WV1x1AXs+3AIks+th6PLWHGQZCOZ9mkT2XcOZJ5omUfQd
	OrPufYDB0VhQ0uFOSIIZ4Pnm0kBqBqLegv7no3yq1rFdaEZLAg5A9XeVT1F2C5wde6SIvCRILVm
	eqjDGlS3Dxy6DBb/sbP1Sesfg+2Tk/1c=
X-Gm-Gg: AYBFou20T2ce38atkC8Y271auKXD8qCkiruRWevO7mIKSUy1kj1IJW2/VOiJI60NODZ
	eyq/M4puN+eeuPbGI36eUp0XfcC5Rywg1NsZPtnS1cLQpX2Jdj7dENssjBHDjeXF7+pQvt6TgHJ
	2y812ROic6JYtFbuWgoK3sctoTF3elvkwR15u7L9JZ0BD4y2KWaH5YaotwmGb/Kr0Vk7AKJqJPS
	/HXxaVShNRN52QKpap2kGtE9EuCWyTV5XaaYBO6eQWP+N0pP/rwwkRG5NV8RVOrtsYQfwhBE0us
	8ukDAp1/ag/45Y02HQzQUFW0l0hpKRmBy6rj9H6MdefH9sw9bhTFLu1fHFCS8frOgdI7m0B3ik6
	n8sTRGUPCl+JUsEJccZuGUYsuQHQc/z4E0YgOziRiA2UOge0dYuUKJwYrcDLx9nsAzvYuQusjOF
	3/okmDB+dIDIwoysBGuynvi348+SCA/428LpXb4tn+kRM86r6Xpa9d
X-Received: by 2002:a05:6000:5c9:b0:48e:75f:477d with SMTP id
 ffacd0b85a97d-49273e5b2eemr704427f8f.7.1793900342253; Thu, 05 Nov 2026
 09:39:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com> <20261102225030.2743129-2-joannelkoong@gmail.com>
In-Reply-To: <20261102225030.2743129-2-joannelkoong@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 10:38:51 -0700
X-Gm-Features: AclHuK-snOd3ku1r5RN2yfgSJS1XUyMqGhPauQIZ7tv5ax41vh5WTgomz0EDQZ0
Message-ID: <CAKEwX=MBdWEuKZhi_g3Rq42ytwmn7h3DbVhHHmPjOtVfAKceTA@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, shakeel.butt@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, chengming.zhou@linux.dev, sj@kernel.org, 
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E080E20013
X-Stat-Signature: c4qmsxjuq77qf9tfrawau9kbyzfa5p1w
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793900343-874507
X-HE-Meta: U2FsdGVkX19sU6oj2FjgpM0Y6JC+a6jY+AH2CItaF578aPkSkI1tWfy1j7LMYm+9/XIv55MgpBdEACsDet2IM129Jcegjo/386mtPP9/e1sPCSA3n4S9KQlLMQ+eHa/S07xAW/p4pydaKv9ugmOscm8E+93vl+yV1BRZEk9LfutIFkPRvhPVhLkiFYtFgIYR7oV2kjsWJRhrGoGIJIEaUPKOC3oVPwQ96g97KlbB9HFwOYxFsHMdD+/VCumM5S+7qJbxzc8gva32rS5idn5CQCmWBXFusfcReJNEkuImIgj1IMzLYrUC2uFWW9loWB0ylUSC8+MrOPCx4u/I9cvU2rQvdZwI5G0/wvXryeVTNBr83dWpia5zal3Y0h9wq5kO6NJGKD/ZxFk3b8DMcJgFDwq9RcH0wjb/mpJZno1XhMP8kY8zQSBPUvHzUWrkVh41z7G5RREllkEFWHMEcthkZGOrdqxU0q4HMBFoFJqVPPydIifQBgKCqFR5eEDhFbdJy5iKLGhwl9tGUnZ2AWnyQ6n7n3LyN6N4yZf5wjLRlfMbB8WJpFsscDTpRxUkZnhSvmRYP7PubgbgYInVunlmnIii3qAxiMxrP6yqBuCTuWF+6EBc6ejGJoX9oLsxKxPL3iFzXKpeppCi4Zrpp7p1yeRbj8fgZKPo/KypKKALGG87Ff7QsgPGJktWej9X5jkord4Ips5y/9ocalBmwu/HXltpZIbNiGhmYorzexl5VQmKFekf1j6FGHAU/48BadyDoZ6HvD0ix7jmu1KbrowYpUV1k2AElJaDvMRbyG8mN32wlBSyTgaUh6EWgTpK/oe3isXGsmpA5po1EXZC3s7BaUKVvasm2n9nDI6VvWk1UZ6nkQk9onScEUaGrAe2KBsq5MwCrnvYSt0H5XrtsdFvtIGb8Q0cuWjd1WSt/KPuDxKEHzP+YOj09dthckRPWH0eXIHUVX4dFhhJuxBHfVc
 +w1dsPEc
 jIaEBg8Rrc2tWzkG3pOWi7QP+vf2hFBKl3gO9SqltF4EGIlPDV6DVZOx905IjZsUlqUrQaMArKbsQrk+EN7QeAblxA1W6PEGGZLuQeoYJ+NO9Xuc31t7y9dDUUgMD2DjTCWJqzYz1mcN0Bw9kVAmdw8azF2uBxANxdnwfN8kQRDYYh18iTq1cQa/4wWgL3xSyr+NDLZl3NVXB3dHPys3Pk3YJ6diXOi0b/eWnrT0oz6arjrpq0IVOdbmQmRm5DxeHXPG73B7SMIsyXSWvWwmw5dR/vKKtJ2r+WNEPm/OM5hiV3yhjW79kL5UnX8UapjIAl1WBwYyQJtl+IthURZS/v906BX+Afj1MGM679d8eyO5h9zV0w3oLY+nR6MDwE+IHg4wv1UZTcWfdAMVz8UPc2TfWIWY/njA/MjoM66FDARuj9Eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 3:51=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
>
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
>
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
>
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.
>
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

