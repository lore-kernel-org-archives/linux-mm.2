Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E313FCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 06:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACF06B008C; Tue, 13 Oct 2026 02:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E596B0092; Tue, 13 Oct 2026 02:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773EC6B0095; Tue, 13 Oct 2026 02:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 512296B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:18:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C804640A83
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:18:24 +0000 (UTC)
X-FDA: 85316598528.08.D801875
Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0B5F180002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:18:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VJD2Xkb5;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791872303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVwfPO4nIYZQkXXXgH90mKfe/K6nCZD+DaShjgg2k+Q=;
	b=LWOIKmvhieL2P3o6+8czrqaTvnIvdr76SxpXSlSlIpaBHYXADJWKPqIS3KGPrFl/GbMLKU
	Dykng0kVpuq03oDkNSzV59WIR8ZbY8H2APgU+n48i6v5Vz6WvGaH9vIHF9kRxW5Jus8lqH
	JZ3QHHEaz/8NI7zRDwtgLhpPzKu2kro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791872303;
	b=GLhKwNOOoI/O+Ji2NSI/gI5OVHOu3lf8ToRkwUndZttBVrVmklO4+o8NpDqI0hOr4PHuRc
	HnO2IqKygSqmKrMr96+ddpGaymzCfsyP2QX/jNjQu2Ai3prB9HPQfpt4jNaMf5A4F3qiIR
	vtwPPqW7WjdC70fijtdIHrlLIzRRM2g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VJD2Xkb5;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.230 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sILqVf6vf2c7wxEo7EF7BwyGO93H6KbwkBm9lngJlDI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791872301; v=1; x=1792477101;
 b=VJD2Xkb5iPjNVTQQT86PnpZrSqwCJhrf3AyrLsUtmueIyYhYVwYwhrBhlRWiRZQQRu/kbim/
 DtYFw+AUOX0BmvSFsDkHALXLVg78FKmexZsLhkRVfApS3wsL5+uD8wh5qB0SNW8Fm70pqD5c2Uw
 EsJ8rxIH3D9SlRNLocVw0rxM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da02f3bab437fe5c;
	Tue, 13 Oct 2026 06:18:21 +0000
X-Mizu-Trace-ID: da02f3bab437fe5c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
Date: Tue, 13 Oct 2026 14:18:01 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDF08D88-7AD8-4697-A1EE-F20BB1F83AF6@linux.dev>
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0B5F180002
X-Rspam-User: 
X-Stat-Signature: snawq1bhkxzg3nauf5rr3uzjw5zg798d
X-HE-Tag: 1791872302-969769
X-HE-Meta: U2FsdGVkX1+Gqvm/7+L2FYgugv15Lv6vbGTDWhG0pxmvojL2rgrBfjkt4d1jWyqfseO/2HEECI6dJLwDWqapGMzICTDX8gaXHBQUjvt2oEn6DRPcf4PEH+P7COupx5BwvyL7b8yk7xd7Vqbo/LcUGPcAtlmfwhqVzEqytex4vDwuvbtx1aYT+Barp593FKDESDXSd/esRGs59yMXA/Mxr8hIgYTyFrPO0hK8+A0l5wXkEtkqBnNyB5Lx1OjjehYUT6XDpv5S3dhXZPDbayL/KcRvz4HRb9w4hNppkB6PzythOZOJRAmTRv0fyzv/IBB47Ea8eBKiGf+v6pin5dSfsatXH4yaLWUH+1+LywPuNnk6gnGoCNK18lhT7844bSvwy5ODlKpylhRFGA6jgPxaPDLoc+ltrmwhKeYwK4LyPwZ0IwIKfmF57QcmOsK3PsYOrUsDn3Vh8ebKNFUkzP+xl5Mgn75g0+1fKNrdgkd/iplnUztUo1y2JbI4WGpUkBOaaCX1C3GEAeBKkIDDPr48Lrd8Rd0YCuotEWZCNTHVwYisgGllu+r6WXah6kTxdjln7xUv4h6Qed4CYR7Q+/X6ROJ0asxFPLTCR84O5CPplHlsMaIqX6Mdfbei8kskFHVBa7lmkufuOBTC8GLQi4TUiKJDJcZlhpGokqNryYheeNdlsh7fLyQeowbMv/b+Esrjdfw54UarLELUGfa1Pr7ds8cik3J+myku+jivUXeDo9Tj1OmnlSV8XUPUsUpTTPuVSb0r9Nbcz20kVdXipSbqnpgvKl6Th2SAT8oedR7Xpu2xhJbN3ASNnTuJaq9D9CpVfQAzHLceANR+KKEwSF+9Cad+OE3+UR2fd3lVKx5UsVfiqFwe6NYTSfRd6dvz1wXpgcrwRWem3xBOIaAM9gMaQsKRzJTbDf01lTXR+4mqR4EbK3wUNdy8aRhYIVzE4LrguILL1kmrBDfYN4bH+KO
 EHNDPBJF
 KyC2ZHg3m+KHv7MNI2Yu1IWidPdSlUWlhbEku0WlCMtXnynG6TVaM7Za0NsP7xsVUYbpGdWhP+x8vz5tViqnK5ho5W+ToVhJjXqTNmm+HOwOvIOeNabGM8qDDSyARibzhk+ucO6tfwy2Z0KOQr3VgNVZeTmAVsUsHJewDUPMewrq3ezxfYG8uMqvjPxHnid815DzUOjVjCDzUNMt2xwRnKneY0GnbaxtfZIgh/VIwDtLeSZwTM+ZO4LRqNrb/nQhfyDVT+Q2zGJV8Xb6h6MXprneylLlaBGohELAGgFgPpeQHZ8ECFaV78xuV2pCwQ/bKtu5kTiXXY/rLAEKl6SlXZOD14HYfvyV+FRSR/LrARXQikvCKrvofTj5mzAiCqJu2NZRMamlz02mSh88wBWuAVO25OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 03:02, Konstantin Khorenko =
<khorenko@virtuozzo.com> wrote:
>=20
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
> two, plus the one-word bitmap of shrinkers with objects charged to the
> cgroup. That word takes the unit just past the power of two, to 520
> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half =
of
> it is padding.
>=20
> The units are allocated when the cgroup goes online and freed when it =
is
> freed, so a dying cgroup keeps them until the last reference to it is
> gone. Their number is the number of memory cgroups, times the NUMA
> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
> the peak number of memcg-aware shrinkers registered at once, and every
> superblock registers one, so a host that mounts many filesystems and
> runs many cgroups carries the padding as unreclaimable slab, and keeps
> paying it for new cgroups after the mounts are gone.
>=20
> Let a unit cover one id less than a word holds. The bitmap still fits
> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
> 64-bit, the memory taken by units halves, for about one unit more in
> BITS_PER_LONG.
> round_up() in expand_shrinker_info() needs a power-of-two step and
> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
> modulos and multiplications that do not care. Assert the unit size at
> build time, since the layout depends on it.
>=20
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> include/linux/shrinker.h | 9 ++++++++-
> mm/shrinker.c            | 2 +-
> 2 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a9..c250ab68d346c 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -7,7 +7,11 @@
> #include <linux/refcount.h>
> #include <linux/completion.h>
>=20
> -#define SHRINKER_UNIT_BITS BITS_PER_LONG
> +/*
> + * One id less than a word holds, so that nr_deferred[] and the map =
word add
> + * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc =
slot.
> + */
> +#define SHRINKER_UNIT_BITS (BITS_PER_LONG - 1)
>=20
> /*
>  * Bitmap and deferred work of shrinker::id corresponding to =
memcg-aware
> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
> DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
> };
>=20
> +static_assert(!(sizeof(struct shrinker_info_unit) &
> + 		(sizeof(struct shrinker_info_unit) - 1)));

This assertion is not straightforward. I'd like to use =
is_power_of_two().
Like:

  BUILD_BUG_ON(!is_power_of_2(sizeof(struct shrinker_info_unit)));

Muchun,
Thanks.

> +
> struct shrinker_info {
> struct rcu_head rcu;
> int map_nr_max;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..a9418072a509e 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -159,7 +159,7 @@ static int expand_one_shrinker_info(struct =
mem_cgroup *memcg, int new_size,
> static int expand_shrinker_info(int new_id)
> {
> 	int ret =3D 0;
> - 	int new_nr_max =3D round_up(new_id + 1, SHRINKER_UNIT_BITS);
> + 	int new_nr_max =3D roundup(new_id + 1, SHRINKER_UNIT_BITS);
> 	int new_size, old_size =3D 0;
> 	struct mem_cgroup *memcg;
>=20
>=20
> --=20
> 2.43.0
>=20


