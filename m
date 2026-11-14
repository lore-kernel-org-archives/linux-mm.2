Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EEF6606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgrOE5rg
Received: by kanga.kvack.org (Postfix)
	id A14846B00EF; Sat, 14 Nov 2026 10:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C51A6B05B0; Sat, 14 Nov 2026 10:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DAB96B05B1; Sat, 14 Nov 2026 10:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2EF6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:02:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 093A2140443
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:02:44 +0000 (UTC)
X-FDA: 85434041448.02.F9DC526
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56A9C1C0010
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:02:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgrOE5rg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668562;
	b=JJWspgLJuRqfYIMmRUvYM2jkdODjSyvL1kSAA0uBYn+bqvm9qmuwuZvWVHycA3FAd4gZ7a
	YEp+n+237w4pZVqiLezTuyI8K4aqMvMfhSxVqbfreffTPmfauOwjycvZEUzhIrDV2Z102D
	jruAA7g+QsNZrhTiK6OnHQHdWZ8ouhU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6hrqjHPPwHb0KIz9b8G1qhIpEHHHS1kn6GbRTl0/iY=;
	b=pheCSqsZxd7JIUnDbr+bg8yQHHp68mxQTF9rwP+4gYD8HDAYY8VoFvsfSaNRAVAtaXqhrU
	XWHihybfjd45Z3l7D8Dp57PmIono8h/rTwo0aEGGzZlC4WVX4xEg2dwpl4PBgo2cjfrVzP
	gW/zVaJErvvzrZQuJfCwrIPTWKAZwyc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgrOE5rg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF08A623AF;
	Sat, 14 Nov 2026 15:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955EA1F000C4;
	Sat, 14 Nov 2026 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794668560;
	bh=P6hrqjHPPwHb0KIz9b8G1qhIpEHHHS1kn6GbRTl0/iY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kgrOE5rgqghq6MR3bT4G7mm1czhKXfLj/5AYYI8pzXeLU7HPFB/uMf+dSB09wKMko
	 N1VzNbEEfZEKZl3Nr9gNrJT60zPdowcoyQyleGjlI70+W51xkqz8q8b/Ghs22NI2VV
	 N0EOaWeK7fL6EmzBRcFULexAPIF8/tZRqbP62lzspyt34ZAqRMgM1TyCdGyaPi6Qye
	 SYXd9h4P1g+5TN15NI0fBoHHFJCVIQoL3ggMZ8bGHiSFyAafG9Qz9b/t4kNdMWnu+F
	 fdinh4yg2ZwZzZzzR79qf/pb+ZlZlUD+x8+t3vrk6Trsn1+ouTFmN2zvFPOXMJRIxU
	 UTo9nINgo0P/A==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com
In-Reply-To: <20261113192642.2618878-1-gourry@gourry.net>
References: <20261113192642.2618878-1-gourry@gourry.net>
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no
 memory
Message-Id: <179466855730.4344.6857220443096829454.b4-ty@b4>
Date: Sat, 14 Nov 2026 16:02:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 56A9C1C0010
X-Rspamd-Server: rspam12
X-Stat-Signature: gy8555rhz8gafis5te453pniyhr6tpuh
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794668562-392128
X-HE-Meta: U2FsdGVkX18mvc6rowLR4sRGwhgMeXBowBga7nixLMgYs1mtqxqp4y30P9fTNJtzMNlRqezMxBKN+myxbJRaLtFht1wKdcMnWOrFo3e198QK4ika4XWnvYPLWOpnmS7rUb7QVC1CU9h4DMii7/SEFKcULiaPI0jWE5m/heT53mXy95iqREavM8HqO8I2tl3bsFBMJWb6cwQttSkwzN3wo3VJ5LWf+zB6sUJXwpZyoO01asu6zUXuyv8DJs/TWx2pH0zzKrHYByUbn+sPm2knQ3ionpL6L8r1EHKQGe7aDnG7zxbNiXkgfsW+1VsrYtFI0uEVOJ+pAFksw7SWEXyieDAAOqKwgVVRJpn2phIurmul9utRXdQQ+q0QFs2Cl1VdtvvXyr/nAL1tnvMJE5+nETf5cVxW2x907gIrWHbSzut7900ZFg1kD/FcZ4iLa95EQT5lh6g4XD5BLR15pZv/Uu7tz7GkzLU8yWtoVA2qIkK4cGfAquGepGEu5FHXafkq1HUDewrdOQzr8NnoK/QxzKZ5FVuvnxigpCs2MNjR6p67AOlJ2P0OtH+MtEWBD+8Za/nSu4Mac3ilMJCPodaJ26r0j9UVIgeoBOJeIgnxsivTBcBYBz05uKl5LcM0M64CB+7ZoVc16fPRwiPZ2ZNHAroDiRrslHTI1SR/JhJ74T/rrCV7WxNSjQrQag0nnAaJrwwvpSoI6+Z3Fa3IZIvzFb9TFRoKjNY+YY0cqoUps3C5xhpZFaT4EYBYkwn0qq67fKXyedO9+KHNd8xdvyzHme4SazLyh8wHxeUyIXI5yXNUE7kemNXGSA6r0vRCcXB8dyAmo7ywDOnyoKS0yvA31or97h9CuFbOiV6hBaj0+fuTQILepVswazCC6/toUZq3VWwcNLQd8UAaiYY0qxS20gAbDQ9/ECtRDTkKsnzB+ia2Gpa9x/RPR8H3/LmDtK9fSUhstZxOpBxQiExhr0x
 QAJQQ8fh
 F7tixnLu3xivztGNsc5Z02m1c8vuAf13XLrlULp7dKTcGXJR/IoBGPTwbeg7Hu6mwS53u4kOyDCNZobJuuKEcshheeQC5q08bMiH/agoc6U6y5JIPM/TMtmdLDrzPIzWUkAGBtJrC4FdqfKIEe//GCBYWeG9K+bxTrxpluMuqqFv0TfPdpRKW2TMrQgjuqgVLQVQG9hu/0mwglmXcKRMys88aYluv5sPX5ftV5Ej1+v+u2kr1ZPCK4uWq4wdtZapAHpQLdc5z4U5ae1iwDWBZzj97yUpk/cHfuoIZO8KT08LtK9JGeGANexOuF34gjgl8q6XPf4toxoEcoCpsRNUK12wtfIMm/G2F8KhMnPLyXOyY05q71MA6XbeJwSq7uGiB17+BHtJxq3EiDIUvUmIiTDaIrPXQmmFa1snrdlmcN7Fq6YMn2IwD5fSne58oYQtH6WxoCERYYKj3mzKAMFalydQ4Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 14:26:42 -0500, Gregory Price (Meta) wrote:
> apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
> it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
> 
> On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
> is removed, so offlining all memory on the nodes a bind policy names
> leaves it with none. The policy is then treated as movable-only, and
> movable allocations are restricted to nodes without memory.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: mempolicy-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/mempolicy: ignore a bind policy whose nodes have no memory
      https://git.kernel.org/mm/core/c/528dc8e1

-- 
Cheers,

David


