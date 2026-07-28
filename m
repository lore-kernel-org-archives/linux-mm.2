Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2D7C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBC66B007B; Tue, 28 Jul 2026 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C4F6B008A; Tue, 28 Jul 2026 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56236B008C; Tue, 28 Jul 2026 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5406B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:52:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09A21A02D7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:52:35 +0000 (UTC)
X-FDA: 85037418270.24.85E807E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D97120003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:52:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKhPtadK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785225153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9I7doRQ50LJFSJkgpIw2Zo/j+BnPeznOVrz2AUXZ7h8=;
	b=QX/IsMY7Ys40Dn+N0rqyCr/HTrs2tRYATxXsw2RwQITkx++yBoy7WJ6aRb1nFk+O19mwMP
	HITcBo9Sw6OE4YpiA+7jlFZ6mr+f2JHErw5qKowij4DoWoX138RTGdygJiiTJujBzGD+D9
	RRMpvGNluK/c7oxXMDW68BKkUITNp4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785225153;
	b=y6Gd1d0RSt8UupHWpECzfGpoqlM6gPsbDtAsBbRkFWTKFpDPj4bx59Nmr0uauuxv1jwy2Z
	FqeG4vH9KsoHTvO1GMmNRe68iOmXNfm0FgHcAKsYUle1KtJWrLKY1ACrzUvN7yc0kpYmQx
	tiJj0xIv1RozUNf5yi0LEEmfKCtE5uw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKhPtadK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78F9160A67;
	Tue, 28 Jul 2026 07:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458361F00A3D;
	Tue, 28 Jul 2026 07:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785225152;
	bh=9I7doRQ50LJFSJkgpIw2Zo/j+BnPeznOVrz2AUXZ7h8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=EKhPtadKqwOEbrU+DMrvlzP78ttDtRR9ftkpQUYpFs/6cpT89x+VLGtC+BWercwBa
	 S1lYw1nT7ezjlf38Ac47cUmSrmi9oKGcV1jmb3rD+Pl4VKONyjCaTAcZ+lmEBu0Dg6
	 N1eBpYbNNBXlw6fpM+Azb6G3X64AZHoOrG6tH4JtU3j3VYpA7Op6GquG/HY0y404GB
	 K/u+60+jJVzu3+Z7iuAJQ7QJWQY/GMavxtwgDd94R1Q9x+SlXNjEPgfCKx01I7g8+k
	 9MnpoDYBbyfeRtTjOMFxA2/qmZRa5pYd47zBTj8T6xO56KQEsaXIuzsh8cV3dgwmkm
	 4ey8PL1VyN+Ng==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount
 idmap
From: Christian Brauner <brauner@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260625153853.913949-1-pfalcato@suse.de>
References: <20260625153853.913949-1-pfalcato@suse.de>
Date: Tue, 28 Jul 2026 09:52:26 +0200
Message-Id: <20260728-kreieren-innehalten-anbot-d92ce2dd10bd@brauner>
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=1304; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WttfTXpFo1FK6v30KTdbJN4UNpvV3D74uM9OxSIcvko=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlxO85a+KsaL7zn7SOm2fc9b67jGs5Jhi3NWozZ+WbV
 9kwzeXpKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEj6J0aG1Z0+DpHFc9ccSU9d
 /X7bFKE30/NDL6X9ThR14M0wZjX+wfA/81ppZyRTzrwVPdHZpksED5yJnWtWrrTvwY600LQdTIH
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 4D97120003
X-Stat-Signature: owbbiq54wgg1t9ancexkmnz1zroxy18n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785225153-628618
X-HE-Meta: U2FsdGVkX1+7ibTLvFS86NPGkk5SGvkdRB3uQjDI2Icj2MmWE74ePr3/U34q0KbQEWCjaE9xfcOJEsaXodkd2+2xg1SKJHNfOQztrW1uNBQNXigjMfMSVRm6zJaq0HClTCZMmVJ8iz0/TPPBL1uRPxJ6vS8QWoseI4Wh63HJ2AtwNFzdOVM+hjHIYA3l7P7fQje90sIMJyCsLvySYObMBNHTdomRCfRNO6APqbtl7hwechaK4AAktptBwiBtVoCUKcMnR0jjI49P913CgOXT0xDxqkQjXGpuLDIAFqE2sH1mgg4kJeVdTPZy7N3jsN9CbejpaMzLyuDTS6lUIEC+WhhUFTTikqBX3x22uAw4cmGcOaHXOvu/2tY6tgcGmWiQzeWWOFkO15E38+Uj/H6dNbhNR63X+Hg+2LFDPz7nLNzzYP5jeC3vLMP0q1n4E3ET3P5AMM/1bRKVW1BX0Lv9eRkEZVA/jrdQLBWimCGIjw9GFRSF00sVbHBkFxk049T732IVGdcqDjxTAgovSl+Sye6BGTkczwgKc7S1llJqJ07mZFwXrwij/Jq9ETSaFa5EHGh9e9OMDMbAXfsaOj5m0Hz4Pau31zryd1hgn0d/6YVtmZTaehPQ1ml+9UhEfhnR9oHXWcQnKomh1j7kziAhrTMSUaRz697iyagH1Gz97kUC/fOMtcyi8EEWnxsBH8jInWT6Yh1uQXDC+KaFKvdLg/fYwdO2ak6goW5nv/eOPBMjtb9Ok0NJCJ6APShjS5SFBHgHczNTv22UpKNECfHWTeygiI2jsCMiSM9+OR4Oi3wbNhDfNHaOMACTFs5zDLlrzJ8Eyx69jamXahcySOOjUwccLTIR18MIQ3L5CR48ABz/ILCNznXozV5D4DyKiMeWy0k0SSUxOcZWGqCewkcxCTptJO8Bne1oBqYzSlfLm+Y1Lvc16MCcHgFJODur7Px3G/QZ9PYiRAxPX9q8w6y
 GgugsxHM
 XPqmDL6i2Slq25k9CdwggCT40wDUCb0+nPh/tFsKv9F7vslrI0/RtsRQZtvn7L9Y1XlAHO6dMF+mo/bMZrdMIyDiLqQweJZUxm/HyytJW1U1fXqlJogGKEK6U8XZNBxFW6nFlADYbSYwji8+lzej31Uf0Vy1bCLc8B6QfKKQdm9TbeEXMDF2v/NUI/LR4qgtQkRqx9tAAJwyvVvZpKH2GtRuWyX08ohV7/7ep+bsGrVhllTG5Tby95bM+eI1NJh0NKvDoKU7GgHEclYSUg18P0hrHcJf56AItBLHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Ever since idmapped mounts were introduced, inode ownership checks
> (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> done against the nop_mnt_idmap, which completely ignores the file's mount's
> idmap. This results in odd edgecases like:
> 
> 1) mount/bind-mount with an idmap userA:userB:1
> 2) userB runs an owner_or_capable() check on file that is owned by userA
> on-disk/in-memory, but owned by userB after idmap translation
> 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> 
> In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> idmap internally, but it does not need to be the case on e.g a 0444 file
> where even the owner itself doesn't have permissions to write to it.
> 
> Since this is clearly not trivial to get right, introduce a
> file_owner_or_capable() that can carry the correct semantics, and switch
> the various users in mm to it.
> 
> The issue was found by manual code inspection & an off-list discussion with
> Jan Kara.
> 
> Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Did that go in?

-- 


