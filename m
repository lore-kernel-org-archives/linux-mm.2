Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB01606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vc7k1Xmg
Received: by kanga.kvack.org (Postfix)
	id 3A8806B0704; Thu, 19 Nov 2026 23:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3800E6B0713; Thu, 19 Nov 2026 23:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295796B0715; Thu, 19 Nov 2026 23:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 064B26B0704
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:38:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 907D7A0D48
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:34 +0000 (UTC)
X-FDA: 85454241348.09.F41FF84
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C719A000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vc7k1Xmg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149512;
	b=TyYiyncR8TiC3sM0MSAIsluKprazX8zRyxhCEi5McnbEuxr5O0k1WQpNSHS7kaC5VIq5Q4
	UkeZ9DxU/S4jIVvBeCIzbJxETk5jGTAHH/RKuEqCtOwC5u2EwxktDafLDBQAzHDGygR7s0
	FDO7/yAWl32CIPizBWl4qPWFybRbQzI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hl0NS9xIz/VEzasBJ1gUTAY2JjbXt21ub1Y2yiyz37I=;
	b=WwMo2AEQNmUOa8L9jeNZEJ/qDW2PkUhV5wMnXpIAJuvRjayZvz5uSUAMfl/RWdYofLVeq1
	3ZXDjKSibCHojSJKJXJS4VM6UEMg+q6kpBpwrUUuzi0Hovpni91HP9dvR2Q1DG19B+0HKL
	SlA/a41T0Bp6ZdpTNlQdEBvITOHfOT0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vc7k1Xmg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/6TrAmMwTcVMqm7Op4XEd5vSUCQWQ6dLWxvUtJgJkIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149511; v=1; x=1795754311;
 b=vc7k1XmgK4o4VOUQnhmsBSo7q22dZWqU8NygkRNxAKHkM056bunPPoveIbh+nsrbbHlpyv3o
 ylwuK7De2dyEUWq5GuBCWjlHd2a38n3DzBHU3PQ8P7gUO36hwex1ouPwulyFRHmkn8k+GkllScT
 gZO5AWvYUpTqiHrAnsYSm3XE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 816ab858cdbf625b;
	Fri, 20 Nov 2026 04:38:31 +0000
X-Mizu-Trace-ID: 816ab858cdbf625b
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:38:30 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <727a9b752cf9ad3658ae8a29a3302f40660c988a@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 17/18] mm/swap: skip reader rotation for
 single-device priority rings
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <799821479a3c820a041d0765fbb70a75598e641f.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <799821479a3c820a041d0765fbb70a75598e641f.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User:
X-Stat-Signature: yw81wmmzne1h986ugxfz3zyeehz1433i
X-Rspamd-Queue-Id: 8C719A000B
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795149512-333329
X-HE-Meta: U2FsdGVkX19MwXDjtX5yOocGusl3BR2YWEbNbSQL/n6YWddflpSuvjAwfVOaP8HoXjXlMjNAwH2sNgFJRsD/DnvBNthMSDlaW9wUpbZffcPoV3gt0P4evK87o7Zeec/UTQxy8i6Qq5icmKV6QdLKroPLTRTHC5g44hlgiuKPvbGp4mJLx38Pkix9ZKM628SBLq805613E1OvKiDO7GF49oHw+IRR8lC4nTVmxbOmNQN9/1dTZMwQHebjT8QFSoxbVZGucZ/eBygBVqjcW5KAmsG2sOPrb/sjAL6ZO2DhDy4rRfKElJd6UsGw4GVI5tOFjk36tsoQX2of3lZ5KL5G/2Yk2l+MXRdV4wxYhBg+p0erdDhDDJW0PSi67t5HzOM+yi8zJV3ygsm0ogfUpiG6yW2VTkRoY/WL1hC9iHRRJJN0LyOHKc3GMIIf53PUOKK7ZcPZ9y0ZIZ/zywcU/LqklOSAUG9/VrP8pZUwZHRApkQa3Skw6fz9XZWY2zTO69xrznCV+v9B2tK3M9VIaWeHcz2VAG9F0vI/0pc/5NZsZ44m+vyh/jsEWFXwe/ibtucLlQxjYsWWox/kuqwtrgFiOaYQH+xDJDViQrxpXqOFFsyBYHjOG+PiWPE7LRUkt8vAG2gTjIV3LE0805nKUBR4jE1glofZ1ysTzPKVQ71iwRArVyNYF9rsRYZyu9Uv1ylDLbU+PWPR9SjeD15TyQsuWuFLgRZukY6OZc468oa59KX23uS8Ta5eGFZFMi3B3Bnwa3e2Z1RQKdAwAuOQkUGleFAkh6oWghH42eNfbxPDcmpGUppW0Zg8PXh4OmqCW8S4hlgshRWfGC+TENrZBbofYpmEb2SMqcxDh08Q8iadHmrti9iHP/Iu37QOICtEtkF+OQNZlzqBSdohiIBG7DIm6bu/gldEkTyF/1g7RHTspAPLe50L/wniXF/UMny1u9hQ6CTPo1hIsJL0d4bulGH
 abJG/8ez
 MLmztGJTo6Yy6X57k1wLrv8pk4iuvGpiXLzBO+4GtCwJuHMTiG6ccspOTq2uAbPKfSsvN59o2/8Gp6vLhgXPAimWxi/C8cDnisBog7tGeFi7bM5tNzENroxIK7um8xmZ0uMWxPtxBBWlVCZTtBkgHXdYIOhD+6yHgHuEKlpgH7MJ4V9LCoHbu4ZLvgA7SLmTJPY8XHlAChMOYnO2Rggol4oOtoViJeo2fc7KfS5t3FcVSb9UV1a5tLBe4pHPiwDmNcQ7/o2EEM+3dpbW84HFdNVNOrVBvn0GodM6punyiS629tpTe0TdJXOnTeRKre35wLsnwG+E+99uYC4GlwR2Kow9v/lg5umq7w/VqggGE4LVUJ49Nu9Bc2PLJNzpCpEHqWCgk9kmdf2YBORKWDqgD3sMrJ7DYMJTqv2+TKmoG+9AbT4XOuLzKowsxMb7jgL1IHtkHa6SSzh/AQBOkL1dNloMxf4aHnYj423/a/DA353LGsxxQbQa3rc7kVEHEFGpCYNmmTVgpZfq1J8viabJjrWJgQzwTMIz6eSSurHRWghs+rIJmr3Rmotpl/9SVKMeIL8iO5yVmsZivPqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20A priority ring with one device cannot benefit from rotating its star=
ting
> offset or maintaining a quota. Read its only entry directly while the
> caller continues to hold the topology read lock and migration protectio=
n.
>=20
>=20Consume the cursor attempt and check the full/disabled pointer tag th=
rough
> the common path. A masked singleton therefore terminates or falls throu=
gh
> with the same bounded behavior as a multi-device ring. Keep the existin=
g
> large-folio same-priority failure boundary.
>=20
>=20This removes reader-local state updates for the common single-device =
case
> without bypassing device lifetime or availability checks.
>=20
>=20Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 616339c5ae5b..0c192844b121 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -334,6 +334,11 @@ swap_queue_get_device(long nr_alloc, struct swap_q=
ueue_cursor *cursor)
>=20=20
>=20 /* Consume masked peers too, so every walk remains bounded. */
>  nr_iter =3D cursor->nr_iter++;
> + if (ring->size =3D=3D 1) {
> + si =3D READ_ONCE(ring->dev[0]);
> + goto check_device;
> + }
> +
>  local_lock(&swap_queue_readers->lock);
>  ri =3D this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
>  /*
> @@ -363,6 +368,7 @@ swap_queue_get_device(long nr_alloc, struct swap_qu=
eue_cursor *cursor)
>  si =3D READ_ONCE(ring->dev[dev_idx]);
>  local_unlock(&swap_queue_readers->lock);
>=20=20
>=20+check_device:
>  if (swap_device_masked(si))
>  return ERR_PTR(-EBUSY);
>

