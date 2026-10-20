Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9C3606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f70NTLHk
Received: by kanga.kvack.org (Postfix)
	id 8B96D6B0407; Tue, 20 Oct 2026 01:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890936B0408; Tue, 20 Oct 2026 01:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDD56B0409; Tue, 20 Oct 2026 01:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0A86B0407
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:43:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3A28A0904
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:43:18 +0000 (UTC)
X-FDA: 85341911676.17.3EEFF90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E468AC0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:43:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f70NTLHk;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792474997;
	b=rkFAGFGzJ5/W/pu503N6AXeSha12qbXt4ZZU9JLlcUMqKsEOkzQaE+OAXvB5BwqSxEeLiR
	AHrhkV3DDtPICvMSqV9//+ARkxhkIDRZDNzNXtq4GKldjhHUZ2cwQ7rNZJsC+kOyVJWVSc
	DxXbmcrXQUvjyyp7TJn7o2VI7EMfxIQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f70NTLHk;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792474997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOWQDPzVYwtb3Y9VfuAlKkFOXg9wIgroexj3Hv2c5PU=;
	b=HfEjd+qPvBp4YG4EPxqMBlkuiiQvm7hMO3ED72dhtRtdbeeeaC90qTWkW6thTjB1aRJmVQ
	/BayhqXYriwWCdcTQvljjZMlRiQ7cqKD7umGI7rkaVXgqsVZX4aMc8uHhF5Y0HtKts+5S6
	fYCgvTJ8bon8AIW/Qfu0xHfPQ+pWzWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25F404450E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0845F1F000CE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792474996;
	bh=TOWQDPzVYwtb3Y9VfuAlKkFOXg9wIgroexj3Hv2c5PU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f70NTLHkDVN55vhVr0fufzuQdr+cLQ81mv0DoqgITqT95jr0aTO2WywORcIWEJloh
	 /GSB/0/0drt21A+Lb8Bc6sOfL96QsepyOsAZomCvIaCJqm2MNx9KlYhAhD7kKePisK
	 UA6Go+IV5NOkHcAToxd/yNIhcMwJ2PJZ+OSvG2KtmYS645eCpzleIMKPT8I03nrbPJ
	 m517j4DX4cyslRWGnWrn/3tGvbmwkIi3VfJNJ1ZLjimLOCdH0vxojYbs3mBph81q8i
	 OTKIKc1+5hSapk/o7eqREIT+qlRXorRSwc4nwd3UeuKZcnw2j6/Rw4ta4zlnxth2+4
	 5r2lyaTkp6D1w==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f3c895a0eso152717285a.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:43:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZSNecUK6S9ZQVkq/VkPrB+/pZj7dgAU9jq2TIBHZh0Fu43fEv3u4nu0tsvl90HZK39/bZvattIA==@kvack.org
X-Gm-Message-State: AFq9FYIaslKuB2gS2co3gQ263lfOvYUB0Tztaag8GekxtPky3oug979a
	jdUt0SqNDsfA75A7taIUNm/vggVbp8qqx+99NFupIuOmVxu7USatseAW/B8H5RtfgMGiVPRYDNb
	6WraQh+Tt1wrKmdxC7E8ocBHBsk7aqMc=
X-Received: by 2002:a05:620a:294d:b0:93e:9508:8360 with SMTP id
 af79cd13be357-93f29ceeefemr1685050085a.27.1792474995360; Mon, 19 Oct 2026
 22:43:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
In-Reply-To: <20261020023548.3242028-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 13:43:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wnuQhyCkMq1Dub8HgB+uYAjy+LkgBxCRJG_kZiwAxA8w@mail.gmail.com>
X-Gm-Features: AclHuK9hXCsPI_k_chn3M7rnq88MHnuONOxS0xCnvuuODST2TZzqbko9HA9tBaQ
Message-ID: <CAGsJ_4wnuQhyCkMq1Dub8HgB+uYAjy+LkgBxCRJG_kZiwAxA8w@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E468AC0004
X-Stat-Signature: 6t4htyzj51zahtkwgkoa8a47czbihmur
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792474996-785948
X-HE-Meta: U2FsdGVkX18QXF8NKJ1MH/GXc1v3gAZHByTiTObkLINhAaremo8FrJmKTC5pkQdvX9XPLc+yr7jZDRA2G4eIZWap41cI0sdheuurcVnZgfeVffLipwl5I6bKtsX16VJdYPlBHk/CauJUiiWPGtTR/vx1rPJB4WbAkMFJKvBPbvCbVyigaC/Uu48DLTzPxMs3UBxtRDoZMTnXZnpY5S/5A4Kf/IA6D9uhEM5RetWnVyYZp8zdvE5PB/E9wSUWGj5W/m5zSlTKQCCaFZMCjnPLloED22MWoHJXHk/OYp+vP0AsJHHqn7rV4ijuRsjfNN8oJ6HXZrdLKPB74JOrRDwCKC0jaT4VWxmxrztr/qSte/bRXovQdDcHK5vLFBXLT2FTtAje6K/QVrLdbCyWYrOIivxjYD2LobRFnpEt5hiTiHz9mGMivfGZd8LuQUAX4CREKRpMAy0iL82adrgpebmFs21BC87eNR6PTASRsCMi0zhvobmf8MEYE7rPYozhlUbE/FtkvYcdDcH0HHKbW9mQGCWaALpLnUzzO/pxly2qotUTwOnwwN6LK5WZwAmGFi7aXWjO3gkQAaHj3O24PmCmjuq5YG25d/kBhJrdn258VwklVJFevJStQhjzcdxyRLFcM2kQjBPlcWiYHKVNutKxy/PMG85VNK+o0YBX3YNfOwDpdKXo30DWbN326DgoeR3fbhmkUdwHcMqnaJk5V+BObxaWTz4ucS/UayVGgSjGcKAIllxcHRhd0yiAP2XDbQKjv1MEk1ApS7fgpwJYvwmWU3SSSa5L7OMWdpkC+odQIvqSxpZoqAB7Yfd5Fnau7zgPw/3PIZBEqBGdUS7g04QRgTLwhX0Cao1QYv9Dq6YNtPdFvFR/kkW6/m5agM83C69dviHXlRYWooB1XRr09MnKfKQ3akMMVXW72s/iyUwPyVGZrrAX5rv+3D07vSruLcK49DAn7MUsRy4Vtme13Na
 bYpF0i58
 nAf9DE5y1appSh3vTqe/a91cd4VMpSgA1Y7BsL0oLCg4hg5a8i6ajlDnrjRErBHkXejL9fgoSv8AT3WGzIiofltKSp8VNAJ/zDVlzQCqwI2fZJcySJVkA+ab2tz9j9cd1zlNNpOhOBDiMXxErrkoqKeM58+eDKfQ4ZkrYhex3uT1YilFu4i3HHvB05Km5DfEpnuBWODOz2EhGa8S173qa4iYGiM8gtOSWlVt9Yht/EWwwpk1VJLFnufv7VXYPz/EjsJxEH8LyTqT4/muivAx78LElxLn79R8F3SxAO1kVWFvFkDWSuOO74cMZ2tsZ66z8BHLYrgmpX8RBleXHN2P8k7yLuZEUujW90zhW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:36=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a
> folio should be added to, but stores it in a variable named "gen".
> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> confusing.
>
> The comment table above the code also no longer matches it. It only
> covers the PG_active and the final branch, leaving out the reclaiming
> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> although lru_gen_folio_seq() never looks at it.
>
> Rename the local variable to "age", redraw the table so that each
> branch maps to the age and seq it produces, and note that the result
> is clamped to min_seq[type].
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Hi Ridong,

The cleanup might be right, but this part is changing rapidly
with Kairui's MGLRU-FG series. Maybe we should wait until
that series lands and then see if this cleanup is still needed?

Best Regards
Barry

