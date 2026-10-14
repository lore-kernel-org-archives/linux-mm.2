Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6EECC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7796B008A; Wed, 14 Oct 2026 15:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FC66B008C; Wed, 14 Oct 2026 15:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21486B0092; Wed, 14 Oct 2026 15:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC8696B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:54:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50D911607DB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:54:20 +0000 (UTC)
X-FDA: 85322283480.26.B98219B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A6B1F80007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:54:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5s4qmCr;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792007658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOJVABY0IvwuLtUWnjxpl472DCTwt9A3UmESRE0DpRw=;
	b=X7D7lTBiF2jyozXV6ZzoQkh9dkLZo5znJofEI5f8NEAdBteAkRitwHbEBl+PKNjYDAb2EY
	KSft72GTI9Xfdun4CfRd25/EUXzZH7eWv402ChZSiIiOFyOyTBeirYLcnS5/uJrgOi27+p
	W4qI6M16LTZaEDhqVRE1WM28o+uG7R8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l5s4qmCr;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792007658;
	b=4ioIRXEUcd9nqq7UmT6RNKX1l7vLYv95TroXQXuZZNyDU9mNzB37OQjws16GdP32cbQKMi
	qvRZR2u84rVLtWOfiVpTjNgmobihzTMa/Szf7aFy0p3zdofQdFntohKvyvR978s2x2GiuV
	168ZKRkkOIO9iFEWsPwi5JUZTSPa+5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E4A843B1F;
	Wed, 14 Oct 2026 19:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD71A1F000C4;
	Wed, 14 Oct 2026 19:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792007656;
	bh=GOJVABY0IvwuLtUWnjxpl472DCTwt9A3UmESRE0DpRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5s4qmCrX8HZiY94A0AOUdfYCOTj+NBZ7bTxuqXD6YMP5G22pg4OY+JD1CNj8S1Ah
	 JS8ZH36xCjJwhT2pchAEQJ+4OozFHNw4cZRZR8Tez6midV/Utnc0N0eFIuYJP7H1Fp
	 G2woX7jKWWNkVcz4y10Fg82SrlSFssjtgV5VoK4NKc86EZ2Xwg291m5Za4Kh9Exw0g
	 oTuzuDnvXv/KqTTuGPZOro03vjDrLkxMNUiFPv0q0/oKJfvblslWvRF4dPZHoBE0iR
	 JBuLCVTUp+zVkrd7g8ZfEVi7YeUzOBou3sylmun2AveSWN/e/xfDWInTrXxE5sItCj
	 fz6iLNYWFfUSg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Imre Kaloz <kaloz@kernel.org>
Cc: kernel-team@meta.com,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2] mm/slab: sample slab_state once in kmem_cache_destroy()
Date: Wed, 14 Oct 2026 20:54:05 +0100
Message-ID: <179200759984.3589452.3981388920201754777.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014150844.8536-1-kaloz@kernel.org>
References: <20261014150844.8536-1-kaloz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6B1F80007
X-Rspam-User: 
X-Stat-Signature: naj1s4dyhqmzq1gxmpjjew11szzfpcq6
X-HE-Tag: 1792007658-746061
X-HE-Meta: U2FsdGVkX18t27yWegsk1tT4F+HijcKDG1dZD0PP+O9y741eQauZPTSJB8CgTtgpzSZmtoFXCXxJ4pkGz5rjsNtGsEox2VSuRkJLwMz1pKpIes3dXXlmzddWsUZuoxnAJTda3Pb0g3r1C9CD9C+HuMzP8rdradIDfE66LPnM3ldXXPv7svDoGNnVAvD4TgjYrmyIz9Fv75M8C1PUS4xZjkzGNlcdTmS/Xp8rdFhmSlZ+p9ZFvIHKlRgrEGqErAX1ZPIrCduUSPEfvWI/hFk+yMdn+oW2We3yg8CasDEURost1tVm3oHP6s0K+pUhDb+SFP0pGodRYATFLVOsvFumU1ippPi9QUaZfiD5aQm8ODwukrrYYMSUfoPm7NbvFLoZlKNrCfQbN7Ngp3gLPyGWTV2HQ9bVtxVl5aprDp64qAqczH4rvAmjfvh2yFVNaoFb6XUiAiH2ugkLjXSGtBCZxqRNt8XVzKGWBi3w8VNzcT/e3fIBCryaEx60oF4yZ0m9spE8Ua/ZNr4Wj3WlB93yhyOeo51LXflmv8n873Njf3wyyMcB9Ww3KfnONuTRLYCK6pfQp9T91zIeIDhDwyeRWXSudjjubvgX6qsg9FXtBzTS0p4k+zgBJ7Ro00tn6AD3cnBCH6eWQlgz5a4etkVlnJRUEh2BorrtaqHZz12C/9Drlko+BrZSaCYH75VdejOMYeyT+gewdzeP0nHhfxCCugeEdwGTt73/JBZbyfv68TIWOttxMPhFL9QLN+eUg98iHLFwZ7FFQ53jjMFA1TRF6wIG96oYUyfEA6JnU+BSr7cb/ClTJOoafrHdJVSM323h+ub9d6L7co6FpvdLjewCORw6gnqsfl/HAv6Kb7R+TRgB8QDREctf/gm4jo01zP3nD/qpSf9cYlpvpd/IEhSphYYxaxHyH/j6KrrRt1zu2YyE6sqBU/0lO9MCeyhDqmjFKG6pVsBV0MNI4end9Nm
 mXL3BLOD
 fGZCUQC/v6nXRaeXntajErQKTf7GI8twtc8cV4uKyAh3v1px1qh69Y58KLsELbV1Hj0jy7v2d+iE7gN+glfmXQ6Nn6f7/Vg0ecp2ySB7Cxcbczz/Ek/VwILysPC2iINp6LzZ/KLe70XyrR0QkRMaGXGYr/rnPihzW2lirzTMu6wfSOuH66rJZ/z01YwDLWktWzWASGJTNLnjBpoNoX6hM+4SOwqMX16/ohEEKYkiih/NRNHkVw0tvlq4tdePUDmRrYioPOei7YhRisQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 17:08:43 +0200, Imre Kaloz wrote:
> kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
> has dropped slab_mutex and unlinked the cache, and for a
> SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
> before that test it sets slab_state to FULL but skips the unlinked cache,
> which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
> on a kobject that was never initialized:
> 
> [...]

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slab: sample slab_state once in kmem_cache_destroy()
      commit: 6d9bc3d860e64e2c5dbfd7531954df9ea8c388aa

-- 
Cheers,
Harry / Hyeonggon


