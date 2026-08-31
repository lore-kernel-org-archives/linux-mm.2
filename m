Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5063CC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C3B6B0095; Mon, 31 Aug 2026 11:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3726B0096; Mon, 31 Aug 2026 11:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521316B0098; Mon, 31 Aug 2026 11:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39F006B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:30:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C50F5A0148
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:45 +0000 (UTC)
X-FDA: 85161952050.16.B43D24E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E07EF40007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fq5pNrnY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OBsLN1/MgB2D0J47N/jZjwD4E0kqsORlAyBJqrdre0=;
	b=f8/LNqvbBdZ5CEDQkWSx4zmKXXU/fFb58cNhw5IRpJBvEqHaVQmGizjbkcYIwkj3i9WyE5
	pzqK/w9D4iqKRISGJGFv40ZpwK4tXOTpnMuXM1ROpSrGT8DM/UXq+jO0UYWzWfUJh7Kxfx
	Bc3mPlPheETCgm0zi1htC8ExI+oAu/M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fq5pNrnY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190244;
	b=EyVReIJLC7+0zOZoFnzTFvL+ybeof9BkfRrM0ng/s0QbH83RDd6L8fe7PvW5uHoOBgdKGT
	5bU+1CwRNeYLvWZ1lOhDPow3kttgzIcORQS6m7l4NL0Epygu/uTlAeiKXOTsDtaQ/1ebNU
	rqWrKQdVmj+RGpF5xef0KT5MXMLQyEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39E6A431DE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1071F00A3D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788190242;
	bh=3OBsLN1/MgB2D0J47N/jZjwD4E0kqsORlAyBJqrdre0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fq5pNrnYFYD0qFPWzc/bZ1MQJVXy6T9gI2dETak49dwXfzYIlPzxI/DldPsOHWQjy
	 r+tqD6uN30nIf5F3BZTVV04Tj3u2eEleo2pEiNNfZ96MLm67hrRX9Ii31BKB04NJ0/
	 roRSfscVu1clNZ4hOrdvYtOVI2hjlRTvoBcu5QHSv2e7hOsgcyAgOB3bAJ2nFtX3Xf
	 Ljv4O2RlSXPecBMTMaWNYlS+V2Dsn9Us426APPnlLJuk41TA7lbW8voJGGIVGYgqwt
	 UwdcbkPFo4i/PBDSywUWRe6/C8zTyJyYttRkKmQpC9lQMgwBPSiYNEL6lddGiLtRMS
	 R4NmkOOryXoBQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15e2dab83eso90958666b.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:30:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrYtzWjmkWBEfXGTK7EMmmQv5f56RvV5fU9g0pAcVC51aPSWFWWIc+erYEJLtXx0HRAaqdN/sA3lg==@kvack.org
X-Gm-Message-State: AFuF++l8LMcASCXZIOIUdV7W7WobMSxqxpkcBIzLTt/ZsixzB4KG0TzT
	cz614neUQpOjqUZ29VAwYoN2xySyxn1O9gAWe1ctjpJW/s5MsMmH8aKQRPt2gniiCiFZIO/3F8X
	FjPkIkihTuhwjHjyFfIeveloTKP82FAg=
X-Received: by 2002:a17:906:730e:b0:c25:254:292e with SMTP id
 a640c23a62f3a-c25567a9274mr1687801166b.0.1788190241053; Mon, 31 Aug 2026
 08:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-4-wujianyue000@gmail.com>
In-Reply-To: <20260830114731.8322-4-wujianyue000@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 31 Aug 2026 08:30:29 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMR2+QqJRHnp2YiobA+p2VZKYcj+XFJQPfgdJt=vDT1VA@mail.gmail.com>
X-Gm-Features: AcwNN1XToK7V_Z8zp2ZtlR_wmIi7rQGDkJiHpbBdZy3zGKhWkS6aFkmEagMkGdQ
Message-ID: <CAO9r8zMR2+QqJRHnp2YiobA+p2VZKYcj+XFJQPfgdJt=vDT1VA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 3/3] mm/zswap: reference the pool by index to
 shrink struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n3uqqx3tnhb73na4s5hpi1z69551d9ws
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E07EF40007
X-Rspam-User: 
X-HE-Tag: 1788190243-674752
X-HE-Meta: U2FsdGVkX18usxIIdcjr3/biv1b8SGaTUhjh6EIEIaRzNn2eBer2KKnpAjF5cHu4ETfwOHsXiP7lE2j04mmlQeBkHzU7ZJ65x3+JSGsamUL9qWnNkC5DpywrTgGoR+XRPbQvklZ6eH7bgcaYNZ+oFtf5EKviYKxSbh5E2kSf+tr4zPpZaetBCdExXVrTpauFpTaLKSJ/wKYNedmaSjSsYj951ahunfbNmivAU0zMq0hf9lISnP/YEo8Cr+S3OAjz47JLYYBvWSiBfA6fJA+sUkWa6CU5SSqir2uhLdmmXptXzPMwftOHIvjQb8Q9CLl/NKY3M1mLh1phT85JdeNG6FE2xNdyQe/naDp9IYMwYneRUFBasrVJCEU4YtQkamC9+eVqV8hiMJqX3VLBse68MJpr7gjE8rq1fUg3Kbq76dVj4PnK58bXNjk86Bdh0haGz9LOAlttjkRVE/eL2mkGwrvuimPF5lxRAaan8RUDK1ayyN3bOmAskE4+x7ai6+zAXuK8DX7npSnILvfe1/adSdSFigs+k13YshIPxeMoog1M6zsa7ysAqk7ADZLHl0pyJBRpFXbQoa6+IyEF7MPfu3LaUbh1W44Xy+devkjhfIMQy7N4aPEvjHAvGUu/Olv5rVGVl6cowWjkepibh/O/7gQO9ZhAG5cdPhNLg4Mib+mCAwM2TNrdhk9RfO4VO+IsSHcLV2z4hS7unFVtqs5npiuo7ZQ/6bsEVK92xmYk8kIboxigfYTPvD1eNWfG6yeRRyEYIWuZ3EQlivJMJWNiCNMjhHhpa2EpqoIvREKqVULzaNJG44D56C/+0BAj78sd/uGgPVUqaHWtrebIuzmXtBciKj5S8a5WDqPDbUehiN20OsZIUme/yix8U35TWPnz2lA+vpIGH48ANTM6O1ei+YJn/hVjHVGO6x491fAZWfifnvJb0OaIXwSUOz2oTaMnk7YDztEorLO7xNRfh9H
 AhOnGIqc
 YNMWnKu7s7OZQuZo5oDGai7qVODoJjG94W56Ti486Wh8TDo6/936eZ4vkJivG5NTFDam452aoF66I7U/QqA7JZIT4GP7go3GGf6VVIeLSWF+ZhbYXWxjUo6NZzL6CrZZuo3ACSYIyz4qrxXeqogRICGU1zXc1ots9oDTrp5s824EDGLZaCRwsujc3o7VDUW6My6gM6kaRV0GyqpLoQoZsKqV3hRwjE1fo9Ar873NHIL2FSBdEmi7lwdQr406Lkx7cBoM7pHcd05ytx5ae8ewm3X2N9c69jWS71OtnGMWyYFwTNDUD38uaxtaQKNK1LxW6EcXRwxeGgIfkR+HynRj0qHbvQtrgc325feKb40huVpgyYSbfDEJ+Qi8zZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 4:48=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> struct zswap_entry is one allocation per stored page, so its size is
> pure overhead. It currently embeds an 8-byte pool pointer, even though
> the live pools now sit in a small fixed array indexed by a u8 slot
> number.
>
> Replace the per-entry pool pointer with that u8 slot index and resolve
> it through the fixed pool array. A live entry holds a reference to its
> pool, so the slot cannot be reused under it. The lookup therefore needs
> no RCU read-side section or zswap_pools_lock.
>
> The u8 fits in the padding after the bool referenced field, shrinking
> the entry from 56 to 48 bytes on x86_64. This raises objs_per_slab from
> 73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
> zswap.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

