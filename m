Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15293C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 07:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2346B009D; Fri, 21 Aug 2026 03:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A7D6B009F; Fri, 21 Aug 2026 03:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC74A6B00A0; Fri, 21 Aug 2026 03:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD18A6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:08:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55EE3403C5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:08:06 +0000 (UTC)
X-FDA: 85124397372.10.2398362
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74196180008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:08:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiVrnef4;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787296084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6eWK3XohsaBy46zqwlhVQqgk9CePHdb3HHhpB7HiA3U=;
	b=z41w3AQ6B/X0J66BU6AVzfAuoabSuLh+1fr4z46ONHW/LrpFJhLKlO9GflYAyVaatJMbE4
	SshO4zr7GUfbnY1S8MCM98lre8zHH7NRUy2ZSYLQdizEQFyQ3hr8fvA05RfmJUJEjTw/re
	OJVh0adpO7UueL/amMDGk8KgA7gk5z0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiVrnef4;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787296084;
	b=4Esz312l4Z2zmv/KSKiAFc4+SZqfgna9rvqV5sN4cHJdOoQogDJYvFQC1P4nfrZ7FOkrLI
	kKD1c1pVmADu6kpmPb2+VImzgDQUjCOnKotENKZWqsYZsPycDJsyfqq88iQXwTLbU8yYXz
	Orxh53S8iZl6V/z6fFTYksXNqU56sgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57A7043D0C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9AE1F00A3E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787296083;
	bh=6eWK3XohsaBy46zqwlhVQqgk9CePHdb3HHhpB7HiA3U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TiVrnef4lkaqsNpj1EmQFQDTACSsTyuYd/JQFjtn4ohee/Jx1i5r9uyX5bgYzoQzM
	 dIoAcTfc1j6xldNao9IfsF147+OekXK3DLnZaLrhiSHzasPSOZqfomb9P0QkU+jTpD
	 MtfN4Kzg6bhcmZx5Z2Ps5KfmwWULY/icQRMJv+/H+aQMojHTD6+Lmi5fy/+mWUF1ct
	 jyYW2Y/+AqZdccBeJ+Qf7uMYZ108NKDhpgSUcIh2zJd/0hllfIQUjDPepyG/Zn7MZM
	 SaPYIrDaSaSYN+AacWuPawghUZ+MWF4sWf56yvaGJkB4eE10SbebsRg2EmENQJmuLU
	 i5gHkoLnhUDpA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e6a434cabso34474285a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:08:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqx11ZJlOifx8vm54KhVP7E4V3LGgajYpR6BzscscaPMVi7TVunSQ9XhGAJzyhWRBIYafravObfHw==@kvack.org
X-Gm-Message-State: AOJu0YwahdxZnxZhZsVzxvFH0D4UjC4TiFLiKyRZhJeANLt+iXHK6VRL
	CikMIpFRF+ghkUIBkzyquFceKBHfkvyFd82bJM3afn9RFigcZy5OF6DF2KIa/Kijg5m4t3RQHOv
	ERNFr6+oTOuzviiXfMdGZ0Ao0QoZZgww=
X-Received: by 2002:a05:620a:870e:20b0:936:cae5:8b38 with SMTP id
 af79cd13be357-937394e8f87mr254558085a.10.1787296082621; Fri, 21 Aug 2026
 00:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260821064057.4081-1-enlin.mu@linux.dev>
In-Reply-To: <20260821064057.4081-1-enlin.mu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 21 Aug 2026 15:07:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xvO4R343WB9eZvUYb9sZ=fsjpZgzxi15s9s7gWY6dOzw@mail.gmail.com>
X-Gm-Features: AcwNN1UFABamyfftXuNiCs0vy4_OP40UOCxGME-2moH4sJ8yH4rLnl7kQCV6VqY
Message-ID: <CAGsJ_4xvO4R343WB9eZvUYb9sZ=fsjpZgzxi15s9s7gWY6dOzw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmscan: fix comment logic in balance_pgdat
To: Enlin Mu <enlin.mu@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	enlin.mu@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74196180008
X-Stat-Signature: ni767y7ararta9nk5iej6mfr76w5azfp
X-Rspam-User: 
X-HE-Tag: 1787296084-462863
X-HE-Meta: U2FsdGVkX19OhJOt7p1IrFtlxHFHCwS+MhUCwxddSUlT/jVftw5qKqsjP76XdDb39YNdPncY+5Cy1AHNjtSJmBIcqmYrJnhQfSgN3uhLZibngGeErkzwmIQvWRyJICCuDRpXh/RDaNhfHYtcF2iV+i4YMtX5BoqwvXZCNNZiXp2FUh95MzJ56Orv+AePLA79Q2SSb/JwQ1FO49lbF3HeHqKaSbBehuUOrsrdx4WYlDbV/krZ4lmXRmO5c+EILIqq34InsNo2Tmte23iFRwplSKf8VSFrrWzsqSurmiuL9ADitjVrZbL2kpjXzv6h625mcfLQvUQ/dgz+FtOwqa5Qem/5OVGox8XgFo5Y+1yB1zYoZxrZH//FKtGryYcGGyfgUuzL2ZFVvYWUIib8fuuSvyiFyvz/czDw3Mu6K4cXwY/nkJ9eVoVYX3+nz+Gi6TUjBsP1ca02NL3gorIr9Kf0ocbkXpGPskryJJmeG0LSNjfREZ/NIMH1Ndmdb27b4Ph/4nmqDjK847Zsym5lUL5esCeev8a6CueJeghAYz/5CTVyMpPtiTW9zPmQGDrz5fYUGlkHFnXZ8rCyBNvDCGWeJCZSDku7uzsJ8bkkz0e1Yly+r9h9yRltViRCVZkJyxOhaUM7sPSYuP60wkdA1+ltp42ossfHOoDsxlSJ26wZWd6qmpQwgFm4YBH37H63R41gF50C22hG1tG2HHDWcHlrWKt6qZiuRdqYI9y7pNQVumtJheOPdOxra/jgPpnmxyvLlBHC1Hhx9RG/gK9xH7pn22vaZ9/0l1CeR0uJuQI4nrA6+mPpP+ou8XhUKfk36za6ZctXsmO3kqLjn6yJmKpmSe+M53wbR683UrtoWhd/XLaLNIUzlwsIkadoAGrST9w0Pr7Jlv4zJm7hT0aUVltWcG7gpQqGOe9Xzz40OGZVkjgyLhcsEMTC3erzk3GV6aARIKjfLF51jrw7szUuI2z
 alAvN6WU
 ewv03XMHvzjRAcmRTju+d/9RKAXgfAsmvaUxkTgHFmAnOm5ea6Z4caCeiTCPiIxzLBxENl56EV/BvjCFs3tlcQp+Chj1cXlJSwmCLppkfQufjxdqkz4niYAE8TByVbgFlB1NPaT4PhlyWHUC384lC4jltkJKNB4CQI/9d3bYcJyKhonAEXdgBvIpCyMYydh91TiGJ6rSyC9Z8Jh3lWNX3V6OF7vASuBpfaUTyPL0I0oZv3qtGIGAkuhU6oNZ5gqBnWL9/IQuszlym8sL897B7a+hmPh+mgyw0tTTD23oedc+97PYMRyPE2iMmoSl6Vf9iLwLtc+bc6GluQ3VqVRsq33TBQNkU/bS4hSdPpQakGH2eGZ/tOh38+DCZavM64ArtbSCaGrUSzikniWmhqIQOjphVYj73Up9IU6f8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:41=E2=80=AFPM Enlin Mu <enlin.mu@linux.dev> wrote=
:
>
> In balance_pgdat(), when the low watermark is met, processes sleeping on
> pfmemalloc_wait are woken up because they are able to safely make forward
> progress.
>
> However, the comment incorrectly states "they should not be able",
> which contradicts the actual code behavior. Fix this typo to accurately
> reflect the logic.
>
> No functional changes are introduced.
>
> Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
> Signed-off-by: Enlin Mu <enlin.mu@linux.dev>

Thanks to Johannes for pointing out the "not" and "now" issues in v1.

I followed Johannes's comments. I also feel that the patch looks good.

Reviewed-by: Barry Song <baohua@kernel.org>

