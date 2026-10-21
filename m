Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBF8606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EReoPclS
Received: by kanga.kvack.org (Postfix)
	id EA1496B07C7; Wed, 21 Oct 2026 17:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A8C6B07C8; Wed, 21 Oct 2026 17:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61A66B07C9; Wed, 21 Oct 2026 17:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEE706B07C7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:48:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 256418065D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:48:02 +0000 (UTC)
X-FDA: 85347971604.04.AEC86ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3176FC0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:48:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EReoPclS;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792619280;
	b=pUOqdiiGbaZM/tCNmfWnBHBdM/QWnXj7hGR3LmGe1UcEoN0Ck0MqGWW6zrxZvquqpB+VNO
	zOrX24gm37BKUXQ2CMWXNAi/xFhy6IYzn+DCZAVkOqFNPzmG3hnFXhKHwS+rStZ/YUzu4i
	D/kJBWYMohxzA6JB73W5ri5jTbPWm1I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EReoPclS;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792619280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNlfmBmtfiESOniOkWbpwP2+Kbv356q2HSZrSlUKiAI=;
	b=fi4K9wmtravlqWhMr4gGKJVMjXCYxTlFNSLQCXXdJGgPe1un8Eqx7bSt+ZMBR0RnbtxsH9
	3ozi15G6MnoP27UntHDYZy5ku+fWQvpdVPuuy04I8GQiAPwQeQCxhnYyo3+IZwIg08HKIw
	5Vj6cgWKYaJx8izZ9pZyu/XsUBa47Gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C15B43EA4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215611F000C3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619279;
	bh=lNlfmBmtfiESOniOkWbpwP2+Kbv356q2HSZrSlUKiAI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EReoPclS6CGlBuqPgcg18O5SMm3/5LhGzjWMr6HSGDtx4kfjBAAnYXMpGDcL/OreR
	 O/CXbo9BVRGQTpBiJtTktJhZ64QXVsP2XWUjq1xN7okV7FdWm4gJUc5P+CMlZldkdO
	 OkxVk+07qGBPF6Tbwe8dJ+ID1E9kb8eToCOvAES40Tu9+yumt5dcz5h+3s2KNngjlq
	 tHL1rLFAbWABCd2KvIpvlu2veqGIdoQ1q9Hg/MvQWPV38nT1iSkN7IvHb7QZuEWh7y
	 GFYIwPbiqAvuAl0oahBTBS6gv4qEE6UqbxArSiwa44c2/eUTlXkalQHQKTh3Jv+ZWS
	 20X3q5oYDj7jw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c40f29667e6so191938566b.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:47:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwwKfecvL810plU7MGvPVOUS61MdDyOS5OTUO+FzI0EMW8wWrfp/VfEFDKXUuqsCWYPNyH1J+ipXQ==@kvack.org
X-Gm-Message-State: AFq9FYLbdV/SjdPRfHH7i8P2cHSsOj3BjRDPIvhSdfVmq1hUwNH9CORn
	Tu4/BNEodsjyp7dvfzbC9eHK8ZufDK0FzRVaOw7+/HMqd/wv0+1/B0mPweBQxpKzD7+4oVroUiF
	F9rqxUrh8+Gkl9cOppPgK+V9Hl8LPu48=
X-Received: by 2002:a17:907:9608:b0:c28:599b:7782 with SMTP id
 a640c23a62f3a-c467959800cmr282913866b.21.1792619278019; Wed, 21 Oct 2026
 14:47:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com> <20261021205626.3286270-3-suseendranb@google.com>
In-Reply-To: <20261021205626.3286270-3-suseendranb@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 21 Oct 2026 14:47:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
X-Gm-Features: AclHuK-8jo-f_F6DT-y6k_PMr4phWvWZnvu-2n_VUIdKUsZEm6R5LdMzF9aUhcU
Message-ID: <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3176FC0004
X-Stat-Signature: 6inkzf5n588sy33gcpycro8r8fyyjxdc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792619280-971116
X-HE-Meta: U2FsdGVkX189yfc3UYgUfKU3F3N9WOxG437SOMGz/3F8TRAuA4QPVC+8WNQc3PWdfe4djsZiQnmLxAF5ZR0jPHz6HwJW/4IYAeK3n4X7fw56iwOC/OI2R5Ewk7UYD3Dcy6zS0ccPxk1et2p5VkyN4D4whh2RiSVauIcuS51OVLHiiMcR2MiCJvFCCgDftTvLxc1uuEK4JA9aJV8TkUFvAChprzvP4Dicpg2XCIEgbxyxMfnHQ4GNB/V7Q/tvtdrsUQkAAQoMIE9JK14jWCZBYVJGl/LOdL1m4K9mgSL2lt55SbiinYXh6g8dYcZOM8dDPPZDmRsKpjJhPf9BESEtE5Qe9E718apPKQrOK9mO7zRacfI1prXgO+hd7guHHWr8OFmquKy8O+GCEqSMb277uNM5znHbhIgPJTg6BIQQegnOhs1EvN168OEGx39nI2OEHXoDl/5falf620XF03TunyOHPqd+yjiVOcyKR+77+JI+25HpE542OA2u73wk89jMnlqB3nykFb1A/pUzDuLuM3oIRw3AO9nL1PxIX7MkaeWXNbcZ+YcnVUsWjYKWYRk38PfUJqkB0QMvWCvXIBUuq8zmsiw41PawIiXn1uYVxazrPvFLv97CPweOwgGxSA7hlQSXInA4pEEe7MEuEnYRoEvwI7pITgtGyOpJfNS+qa0bDJdCuyjGhEJ7UmM+Gyr3FisOhBgfG8jiHcWIOiFx6it2VfHkA8PpHIhJlI57qlExSdDtooOg08e6Vb7Ss46ZuCyASW7f5BRRWMVqscFgDP73K35pSRokW/tiCmLoQlYzeZ/p5I5FJyYEb+82raJXpw8ofxv4haIKWWAzwWmIpmAKUCAzRveNIUjaQ59aYbtu8cfSwEAVd5Qz08p+KOg2oNAdersQ8rwxfiF0sgK2w6UGkyoVcoWac342YfwSztsbJVZlNq8sIez1USubQlhOtlbIFGvDh3s37WiUQw0
 dbsw95nw
 2JTEtkisuAxIUaukBC1dBmtNha+zaFd4HPAzbegByKRCEM+YDUZck0eVW2+U4RI3cAe2v6Q83XiGC5LARPe2DnS+8422wP4X2eU1tH2QRSGHOjth3e9xp82m0th0siZHzWF7bG1THuQpueWYz3KltkDrDDqpMost9WixZTel1EzG/XsjMeBTqtolLkSaAEmHP9uz3hXAiGYWBI+R8PC1qxgzsaORHEC+zG9hyCtvCTuh8q/ryfmSNp6BAFN9QBbAbuYbpjPlI/aBkbSl5EvlppDH++hciXYFMGSWK+Y1NVzwwDzTbS+lE25mGIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 1:57=E2=80=AFPM Suseendran Bhaskaran
<suseendranb@google.com> wrote:
>
> Commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
> as-is") and commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> compression buffer to a single page") updated zswap_compress() to pass a
> PAGE_SIZE destination buffer to crypto_acomp_compress() (so
> incompressible pages typically overflow the PAGE_SIZE buffer due to
> compressor metadata overhead) and check:
>
>     if (comp_ret || !dlen || dlen >=3D PAGE_SIZE)
>
> Because crypto_acomp_compress() previously returned -EINVAL on
> destination buffer overflow, this check conflated destination buffer
> overflow (incompressible page) with unexpected compressor failures and
> did not set comp_ret =3D -ENOSPC when rejecting incompressible pages,
> resulting in two user-facing issues:
>
> 1. When zswap writeback is disabled (e.g. memory.zswap.writeback =3D 0),
>    zswap_compress() sets 'comp_ret =3D comp_ret ? comp_ret : -EINVAL' and
>    jumps to unlock. Whether the compressor fails on destination overflow
>    with -EINVAL or succeeds with dlen =3D=3D PAGE_SIZE, comp_ret becomes
>    -EINVAL. Consequently, incompressible pages are misaccounted in
>    debugfs under reject_compress_fail instead of reject_compress_poor
>    (leaving reject_compress_poor stuck at 0 and triggering false
>    compressor failure alerts on normal incompressible workloads).

Hmm IIUC this is completely fixed by patch 1, so it doesn't belong here, ri=
ght?

>
> 2. When zswap writeback is enabled, any non-zero comp_ret (such as
>    -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
>    accelerator error) is treated identically to an incompressible page:
>    comp_ret is cleared to 0 and the raw page is stored uncompressed in
>    zsmalloc. This silently masks genuine compressor failures
>    (reject_compress_fail is never incremented) and miscounts pages that
>    encountered a compressor error under stored_incompressible_pages.

Storing pages in zswap when compression fails to avoid LRU inversion
was intentional in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
compression failed page as-is"). Unless we think this needs to be
changed, I think all we really need to do is make sure we account
debugfs correctly for -ENOSPC vs other error codes? Or am I missing
something?

>
> Update zswap_compress() to treat only comp_ret =3D=3D -ENOSPC or
> (!comp_ret && dlen >=3D PAGE_SIZE) as an incompressible page (storing it
> uncompressed in zswap when writeback is enabled to preserve LRU order,
> or rejecting it with comp_ret =3D -ENOSPC when writeback is disabled so
> zswap_reject_compress_poor is incremented), while jumping to unlock on
> unexpected compressor errors (comp_ret || !dlen) so
> zswap_reject_compress_fail is properly incremented.
>
> Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page =
as-is")
> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> ---
>  mm/zswap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e..5f2a941fcaf1 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>          * only adds metadata overhead.  swap_writeout() will put the pag=
e back
>          * to the active LRU list in the case.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +       if (comp_ret =3D=3D -ENOSPC || (!comp_ret && dlen >=3D PAGE_SIZE)=
) {
>                 rcu_read_lock();
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         rcu_read_unlock();
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +                       comp_ret =3D -ENOSPC;
>                         goto unlock;
>                 }
>                 rcu_read_unlock();
> @@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>                 dlen =3D PAGE_SIZE;
>                 dst =3D kmap_local_page(page);
>                 mapped =3D true;
> +       } else if (comp_ret || !dlen) {
> +               comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +               goto unlock;
>         }
>
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> --
> 2.56.0.218.g1ec904b173-goog
>

