Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE736C88E40
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1106B0095; Thu, 10 Sep 2026 13:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61E66B0096; Thu, 10 Sep 2026 13:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0F16B0098; Thu, 10 Sep 2026 13:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A35086B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:38:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 214DA8058D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:38:37 +0000 (UTC)
X-FDA: 85198562274.22.31A5367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93D7D14000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:38:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFytRu4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789061915;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUYxAj4HnarvzsP+eubGIWnHw0kdeifpIluNpTBfJ7Q=;
	b=WLk2RSO4H8thP6Qu0hczUXK08jigQgmkAOiTTiyNpoowjteH/WYLJJz9B27R+ePnJCKSbe
	PjzPJnB5fQvAwJTx7m2AqY4PUsF/uf5BH32NreszUNNbQ6hvarOa6EaA7rf4N6j7jM0Z0z
	jsVVvwSaQoID+f7yjHXS3DTrS3XBls0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789061915;
	b=TmEibb/mOatAOLC+SPEM50JY9fwUS4rXyuzt8lOvRx4Pj6e4bCZJCX/DoMzkE1IEW4EMir
	LoKxJjFyjBZgN+jKlXWIp5bIRxqrPkozAz+ELKSo2inhVXo/XX8bdjEjk9Qrxb2rugJwsG
	FVLbwefWl7udxeNzCUxn2IpRUteVDAg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFytRu4F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D860C60204;
	Thu, 10 Sep 2026 17:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D831F000FF;
	Thu, 10 Sep 2026 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789061914;
	bh=JUYxAj4HnarvzsP+eubGIWnHw0kdeifpIluNpTBfJ7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dFytRu4FsCW1KcbAT4M/jjQmFi0i9VtqGmHByi7GwG0edq2iIDIQVRlYkPd9JzHtE
	 IaFcYBc3AeTj2fNGpdmo98ROUVR8Bb2GtvSzQzqwce3MYnvD2OUM8B533QBPrrcVb0
	 g/0G5nZdOC36N5fWWS60rShMqaCSGCDhdgtiauoTIvWRH00VfmGpu2Jh2DxzPI0ki5
	 3Kw3gvHN6hr0/HkyaczumZcQodz39vd2c0V46qCHBXkFzcW7+Xmzx4CIhD0Sq5XLxu
	 GvwdvJHPmOmlusXQp3dWTVP3D/EuEVdyaHGmzDV6z7+a0Qp5ZoUHHHFwEUamGX9BY2
	 g4Rv+W4jQIiyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/1] liveupdate: luo_file: Add documentation for
 dependencies
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Alexander
 Graf" <graf@amazon.com>
Cc: tarunsahu@google.com, "open list" <linux-kernel@vger.kernel.org>, "David
 Matlack" <dmatlack@google.com>, kexec@lists.infradead.org,
 =?utf-8?b?b3BlbiBsaXN0OktFWEVDIEhBTkRPVkVSIChLSE8p?= <linux-mm@kvack.org>
In-Reply-To: <20260910173659.1945246-2-skhawaja@google.com>
References: <20260910173659.1945246-1-skhawaja@google.com>
 <20260910173659.1945246-2-skhawaja@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 17:38:33 +0000
Message-Id: <20260910173834.16D831F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93D7D14000C
X-Stat-Signature: mhtgten3r5wxhjm7p4rm77tmyodut1kg
X-HE-Tag: 1789061915-436287
X-HE-Meta: U2FsdGVkX1/ADhcfr4X7gtZufPPp9QGFu/KVFuvvw7YipmT6y79JXAbnCBeUgTFTQYB/NRCllvfGKbRBvC1NTG85YW9TqKKN8xpZ5eFLqRDsfIwY3SnGIkVXoFkLuCIHoEH3Z85wg5/o0o2a4O9xU43JMmuXmJ4TxPgH/5sONpLHyW45GgeiTATbkKgZ69/vUrmxWAf2tccum+l5hOnCZSi6heUwdpzwEwfngWf5eRg+tdowce4UBXBGAQr3jJl/qzuBkrb6sKR5avxNifBmUkmxTRms9CRjBeCHHtrc7ee18rO0wgdIrl8hHLCO7/RFkGB838tsKofVootK+/8Vl8W+FGspGSK9PLFCWjgE1ZiKxu6ueY6t5BXU9qenblbMZtTjc2AlitI58WnVDakiMzzqAEAIdfv2RbC8wJ1p77+na/UZ1yeGqKDjEaIsckjbR6lD5Y9N2CWH/802590mT+YsKd2lobA3V4li0nNYGNBD9TclYAhGav9tunNZ8kWYPWfQ1nnzhXzF7AlgJUN5kAmjrQgmu8gFUm276auSeoLnB7JIT/Jymgwcw62wy0n6JlzfULHMXANyTuQgUa8VJ/LnKOdBK72NtSTmcET21peBxHtVBvCgKJCPum/tHbPDp45e0SUDRu5H417jhh8FL0TUB7oGdkGZMJxIGdNGerLK4kc1Q/AzMk73gWvi2VBSoUJ9pEaaH4sAour/k6+trjBuE4vNZuvQSWEquJgtc9NescTdffRhqaVfysiLx8KbkY8LAEsPBVe2dfrFl8sJD4t9TgzFZJnjRpEKa7UCJo+BGO6bvGmQCxS8+N3iak2zmHgDt2SMievCbpOJcAhQA0kyCsQhBsB0Idrp9tqCK5c9aRsVSYgcoxUThTjW2EGssK3N+GDz+qAwZKMHG6lZNbzijk/lb9c/VFlI9UxOxQbUvlOwbfCiywlQwHNzGcHfWYNMWCs4VVDA3foZjfe
 EYaKcPKF
 o6dAiNZBOw+xrWyNPds+3GbXny7NIDN2ot30H+mYnBSKpNhpAouYmcKGlzsfe6Nx3yls5QFXf3aZU4xivofsE7SwjoZ0+vOsoa5Un+dVz6p/DHONEV9UyZIKHYDNhIwQ20Kcwf6EbhP+Vymm3gkQNHnm6QtlGvSWl9cb+ozYNhLem1ZdCwqVdiRrmpjrN16lCGBpUhdAsu72+KDOjIVDfhJ9u3IO1dXw7yBZbPTDCuoW+MsAi0hg7OQZShW1VUVAY9ElgJwIGXeY5tfknMMLsw4lpbNhaPHTJLAgBYgcDptANYtom6VSCOedtoU1xY2VQdYglkWam0FHpJ7fvGyRVG1toKsIsmpD1pOHJZG+6gqA7n3g6mwx1oGI0JdokuL/eN00piZmyivgU5XyTZ4SqYk7CYg2BRPH42cKF6iHV++uJRP8Xpo/sXP1OXlgXsIq65Ou3J72iPDCBDeGeMf7PI6otS+GQ9ymDjrmoJ51ghRiKUL+XKujUBscX0sZJTycVouIQAbOMwCIchtS1cYnZtlg7c2VMvXCsS0+DMkGQEKQYgjUxOZggeDP1pQ+hmZ6HEkeji4eInfE3sfnH6+lVPS1Nk/i+gWlTiQb/mS397maYun9weoNa1Fpe8ldv//ZNGpGKJY0xdipSfY9ll7Cugs6ajKzlPF3yoDC3NWbnd62IyMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add documentation for dependencies between FDs preserved by file
> handlers. This supplements the previously added
> liveupdate_get_token_outgoing() and liveupdate_get_file_incoming()
> internal APIs to allow file handlers to resolve dependencies.
>=20
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910173659.1945=
246-2-skhawaja@google.com?part=3D1


