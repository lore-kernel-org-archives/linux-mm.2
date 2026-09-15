Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63476C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625876B008C; Tue, 15 Sep 2026 09:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7406B0093; Tue, 15 Sep 2026 09:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECC16B0095; Tue, 15 Sep 2026 09:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4DA6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:45:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6905AC041A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:45:40 +0000 (UTC)
X-FDA: 85216119240.24.A9F4E34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C4B541C0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:45:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hi5BOtIE;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479938;
	b=ih2uFlpDwTOeSiROiX9b+4qgjcHMSwVwWXeRHuenvHggXS75M7tu+u+njLGDB6v/cmJ7H2
	6XD26M/hxkb1CsBR4iHm3zblSWb+3kbTOtgg0aR6VA2CjxaUfQ3E4ZwcwRi1irryvKdgWL
	lbCLAHAsoftOdLv4nUKttNM+rccd2J8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hi5BOtIE;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479938;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiVbNpqvcTpST0O0QqLXW+ZXyZ4rqHD9AsZUlFhTaN8=;
	b=lZbyg2RDYjNTzKCcccEvzqYt/zWyOviMmAdtAg33VgVVaYe0fzMBktlVtBHsZ9PJbsiPhZ
	ITCzYcFaRzpa02v8Xzf8+Gshd3UMcjoocBLcOzP9sMSyQerGOmjn2SnsMDUDLxqVQkAfXy
	Fmlov/2dUm0Gd+WoOi+XoyfkjsKCeTo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E593340255;
	Tue, 15 Sep 2026 13:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FC91F00899;
	Tue, 15 Sep 2026 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479937;
	bh=OiVbNpqvcTpST0O0QqLXW+ZXyZ4rqHD9AsZUlFhTaN8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hi5BOtIEVU4s+3yGSkPz0/SAa3xuZHvLVpvUfNAH5splg6V68ueCIPFYP3/mpMulN
	 u8P69p91iUJ0DvXufSdZIKn2jcj8/nL90UaX8qWkXmwhffYxBPcX8v6xabJdCHM9uS
	 z0APFIvOBx9ALorAcSTdPK39S6JJt/J+ryBC6YOeWFlhtPrN383awNLaA4SMyFizpA
	 wG92L0Er3GzqiyFFLxmr4DbvFLuVKocAtwi+g/N7XmJ66fdv9ER3gV7xBJROmIeGXh
	 yELnMJVm02pPNLmgfAN6ykp/nJhDspGneThMYtTcbY6FFghJT0/8X1s3mAGVJErlu4
	 R0Rnq9hJzvg2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range
 is poisoned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Morton" <akpm@linux-foundation.org>, hannes@cmpxchg.or, "Borislav
 Petkov" <bp@alien8.de>, "Danilo Krummrich" <dakr@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, x86@kernel.org, kas@kernel.org, "Suren
 Baghdasaryan" <surenb@google.com>, "Zi Yan" <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Rafael
 J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Breno
 Leitao" <leitao@debian.org>, "Michal Hocko" <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ingo
 Molnar" <mingo@redhat.com>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, harry@kernel.org, rmikey@meta.com, kernel-team@meta.com, driver-core@lists.linux.dev, riel@surriel.com
In-Reply-To: <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:45:35 +0000
Message-Id: <20260915134535.C3FC91F00899@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4B541C0006
X-Rspam-User: 
X-Stat-Signature: kgpcfbmtquno8pxudnox9y9h4nkhafs8
X-HE-Tag: 1789479938-365525
X-HE-Meta: U2FsdGVkX18RsabDjJRXQFfQMU2I1KtMrqCFELMNnbRn07OGArtsmyHWJfT8rD1F77XN4aLh1XzxiQNVLHTrqrr0s9pSRf1amb/lQt67Vh7xjWLk1N1aF/FK609Dup6TD6UCEdm3uYOKaO6sUxejtKRt9QftopIkp0c2+jAK6IOxvoMy3Ra393s9+VX46H/5rhMyp1fuT2wp7jOrjanXoVYhtnMd9SXz7H8zMrNvMUj4CVaIz5Jbe+uyPhiALQe4vJ0f4J4FtZx5NK9UMC7O0Gk63+tBRmdA2zYYJ6tK07Di69XIYfaW/VtRublg/ht0LVODtxvK08jnF/O+7IQ6DXAuZyfRFWCJXNvltClSI3ECqPPgC5SoN2bzXVM6GTBHhs5bfTt/rxThGa4LW6aSojKpyx7ZFUn4QgQVkjtQe7JYmfqSYAVNwbBpDiDYw93uKCoBBan8MRoVbDjYzBJUq7xTjC5fxvl02Z407ZND2SivhWnof+KQf59taNVGzbN4NVY+LatDwPmmWsCVXiWeUOwcc5r25fQ9vFhZrGGi7zMuAc5oQastCG1ku5RiOWS4KE18Bb5I36TdzUCR7o4mRrMve2zsf6d6Jtu2mYAkqc9WB82lGrKvuc8uaJ56cGXznQP9L67g6u6HQcRTPTtm7ms7fYwM2ra017SZq3IgZKZX8cMvZUce1bnynwufY4Mag/BTNiohtPlEqky0I0iyJmG2FJ5/q5dw+5tKrJtkPP69oWkT5vEThzuMZea6rwPsXjubaJ7cToVnG+Sy019UWLVcwDkKhaUdrCKUqngAAIMrqzYTYvhS8yd9SLySqGEcq1N2TQazoJnkxDm4OAmJ9vgvvBmjfdd83jhh7Yp+aw8mWX5CFT4uMSQS8c/Yd5ln2Ea8YgKiyRwjw5z4UJxhFtHQo5oYDLgyll0GJVRNG7EqfCaoLRvxYPPW2I33lYOx1QgSDhOxPGQo7D+pIsu
 lIklg09O
 Mf74/0JUYyB6bfJXb3bKPEQgvp1UFywkYiQGgs1IqAxvaxTX5g5i5QMJyD9LFYv//8oUbrDizzieEQ17Z3NZr992SHZm8BT1ArPnaa2QzQ4ptP6J2GFx6qIx3OOpYAqDOWqbCxXIyoqDXcGTVYlha1TgEtIxYdXo+hKSS8LIuJNc4COtp9/oFJtwQjsX190vyDZta9VbSuixEJGNZCSQPJZVEzuCR2jghZVpp/UW/RrOLAbi/c6e8zauJEMqtlCA7wIH34zMfrfI+01rseSls2j6O6gsryZ3UtVZw0fIFm4METQ8xbvvRo9HS+xBv8WpaHr6DrCwD2PIVEVQ7npKoKsgJ5eB2uOWf1vP8gfsKY3paupAi/6rhVA6Ao1keSmMHs0P9jOM+vv1VfXDCefxie4jdKzM2WitpwBCbTpUWIBkAcrkp+cKmPlD/ngzNxDoYL6QCvJBOeFj9kJECiDkfDBxGK2xxnMVv+DH84/a5ZfH46T5PPAPxMlVEm64m9fWcUBVhmbCbt7l0flP4wevCk41Og2veGqr1JJU1mwDtw0owALZzZ3Gt6g720dKaKs6ntozEXq7MFPwtpBPtFU+WWJeyvkyvuDaOEgmOhYwbnvJ/hXaIh3Uc2If1inrawY48It4+D2jPXIEQxIY01kVUEadLm042GRx84p/h16F0zZH2clI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The bitmap an earlier kernel filled in gets in this one through EFI,
> but nothing reads it back yet.
>=20
> Introduce range_contains_poisoned_memory(), which the page allocator
> will use to ask about a block before handing it out.
>=20
> Signed-off-by: Breno Leitao <leitao@debian.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D6


