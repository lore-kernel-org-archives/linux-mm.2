Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0121125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D2D6B00A7; Wed, 11 Mar 2026 15:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F53F6B00A9; Wed, 11 Mar 2026 15:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8076B00AA; Wed, 11 Mar 2026 15:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFB056B00A7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:58:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC836140364
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:58:42 +0000 (UTC)
X-FDA: 84534844884.13.C074328
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A83B51C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:58:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gbmo+/SB";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImSkJ7xkTjdav/L/PiQH4poS9iuqrl3IfoU8cVx2bg0=;
	b=frkvXBQrHH/dJcQiEToP1tOQW9GV8Mv0p+RiGlwRbdaC7XBI90KeeH7PaekCgzrGg5Z8w2
	AQWcP8iYt6N3q+kcXlM9g0/573I6VFUWW/n/WyQufQZonWv/lHbnHcKW3TsEzsuqkv2lRE
	be1LUdKxMTk5QHagsxgu0Z5PuWISGWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773259120; a=rsa-sha256;
	cv=none;
	b=B5aMc7rH0tB96lDH0bfBdnH1mSOc5TzYv2FCOuMUAVKEFgYGcolWpSB3Jc4haIEMrEWGNW
	zfLkdx2zs9H/yGPa/tqZ53jnhi0kdo/RWnTMHLOxUVFtGnZCRMAsHunTdrCydce4/xTt3W
	faX0W2dPYOMR6DtDU3pS8d0bxWqmviM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gbmo+/SB";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8589E443B9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6215CC2BCAF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773259119;
	bh=ImSkJ7xkTjdav/L/PiQH4poS9iuqrl3IfoU8cVx2bg0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gbmo+/SB14wGCVRbhreKWsjXFZWF89q7L3eA0r7SNW/QhNRLaAlfVl098zRKprNr8
	 wKcwlaEmqciNNySPCaabANUkIj4cXhZ4ygTeGzKnqrIrwyxZzg43PDOfT+x68nN9FS
	 4yHGroRTtBomLkKQmgmOYd5lNmzy023TqmDWon/hQiw49KPqlRwKW5CnhhfBs9XHa6
	 cXZKD00WxKYYXsZ2XxpGcor3tjROt+UvAmXSaqMeWytE68fWd6GOCBUX68Bz+tePLO
	 GxkvTgcbEKtIrO2VWw1tD7ng2pvXr7If8284lJT7v6daWSlpK+zTHgDpMgYP//5tM5
	 njP12v07R9/uQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9431300833so33295066b.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:58:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXFsVFOhA2wopVMYlUtuok7hpKNMq32B4Q6cbE89ARM5aVKrky7gr17ZX691ou4/lPygAN35gfzuQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4vHxOYEC7y+M3AhZEEXfoGJN+bzEz8rJ2CNlrzKua6IeNKOIt
	eXT8xouGRljhdazNvm+jppcea/LdJgcPyCQyH/brSW/7RHho33OX7oavGdKw2hYKwrvnoZfc6VD
	s9IOM3TpbTGLpISjfEz4Ng6/DocbcIVY=
X-Received: by 2002:a17:906:6a12:b0:b90:b85b:b2cb with SMTP id
 a640c23a62f3a-b972e20aa8bmr214644566b.26.1773259118178; Wed, 11 Mar 2026
 12:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-3-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-3-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Mar 2026 12:58:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNiWgQN422YiCmdi+n581u1hqfBdVhmGfxfNSwO03Se1A@mail.gmail.com>
X-Gm-Features: AaiRm51LhTskVxaUh9RnNMYxeFYc009-EQc-lVFgrb6ZXOh-jKndV_92XSsoGj4
Message-ID: <CAO9r8zNiWgQN422YiCmdi+n581u1hqfBdVhmGfxfNSwO03Se1A@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm/zsmalloc: Make all obj_idx unsigned ints
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A83B51C0009
X-Stat-Signature: g3699o61ns8pjn19w1gtmwnyfrqwyrhp
X-Rspam-User: 
X-HE-Tag: 1773259120-688138
X-HE-Meta: U2FsdGVkX1+5XDq70DxmzVWpzArrpcNFhik7b3pV18fH8Uy76xm4sijDXGslXhJViR5KAcc65TXIEqkg5MCVN9AgAGQgrrU0tcylGbyr9C5OUDgjFEhSUlCYQAtHXVRC2xp2009hi8EZ2Cv0YPokVzp9Sq/owU1xiuyTXmh5bZiJ3w4E8zEaLGgd3yvn4hJrSSq2IlATMuRKQ0v6CR/XEr1Sqyg2xps0dix8kddk+ATa+WXmWlAyVZ/oYibfMjaIrSnebWVvZsgL+Zxpln9qYF8Zn24xWILs5N4ei1lIactOoW+Zt7348rAuG0YdCs169ichGLgjDbRLuSuKaZiP8A/OUmCejhmIwxlCge706YSNhMSH8cTXCK8LETAQEO2YWFx2n3+JkfRwd4puXbInrpHMVf+xaHd5KbBBt8AMBsBFWnmt532EAFz3mzPzAAtilBympFFNGa5liBSeaqJ0x54z8NaNmfDS+KsTIHWLnZU+e8p2LqmJav5ja6k8x4LXrwL0zLtI//+ls+qxBxcbt85TEmueTsIIW+sgGR0N8+IjdiJbFEb3s54ZvX1sqcOlZNp3E7tRs3uZ8r5H7LeufviTDcZO1azsDxLrLyYLzZiH9lqMYPCp9NhMRpjvVQNbJn0sfTLTUvK9ByC2922zcSUohjtFgyTDcg+zqI8e3hHsjkQLcV37aIH8U912udERtVYOifzioz/kfpCgMZhcScHR3UtEu/ehS9jpBKyuENS8Q5zbWvtS54h+mivqTa5ThLLJlNCC9EhLTUr501+rCwCITOenMghgFeArs3cP54WTL0Qv05d+MQKFPkQuNNFZuRSh0rjR1yNa/3goUSXl5z24BlJEKdT6Xks2+JRF+JbqvWjgn2k8X6ilbBDg/6PtZof2eswhWeXpXg1ZC+AmPHYiT3/9OIQmw4k5cG8RJwEeO4XurO897kaBalR+/84VOv+9GQpPcEVQppQgxp0
 eTOms4kV
 2nflVrQG8btUl89vgNrHeleRfi14kaRk/iaylFk2/53U8puv4/Sv2IO0rorLgvdXG3D/0Cn5eWdLaDiaBwM4wZuHZBBmmGypEQhHk3eyxP1zMSioctlu3AUhBWvd3CsB7jYcm8pLFT8rexZqgSeCircoIZhjVSvLUQhmOsGWs6RW1hWtnuPHPsAdEW7Pv8E4I3tOHPLQ2JqPej6MJWazG9mQbE6cUZgoNgP3nBAxX9m9jfROTuPhICaENJDwIxgzAXZjOlg9Nmdb+67TYKreLcf7eQb/tjvaxzRYxaXIl32gVuH7BkP/LxbP/vI8eCe95j2CemsD4fd8ZDQUNsZs9DXn41ZnLV+raqaczGub5H50t9bRRwIv065CwPrvD4vhSFbTX8aoeFNgC4SOtv2bnjPmDJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:52=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> object indices, which describe the location of an object in a zspage,
> cannot be negative. To reflect this most helpers calculate and return
> these values as unsigned ints.
>
> Convert find_alloced_obj, the only function that calculates obj_idx as
> a signed int, to use an unsigned int as well.
>
> No functional change intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

