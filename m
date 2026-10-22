Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6A3606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ims99RF8
Received: by kanga.kvack.org (Postfix)
	id AC2856B0809; Wed, 21 Oct 2026 20:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99FF6B080A; Wed, 21 Oct 2026 20:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6996B080B; Wed, 21 Oct 2026 20:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72A9C6B0809
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:49:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6008A8380
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:49:32 +0000 (UTC)
X-FDA: 85348428984.28.85902DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 568F4C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:49:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ims99RF8;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792630171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=On0IRKe4yglB4frXH+Fm+UPqKv05FYubzJr21eeqbEY=;
	b=C/QfZcnb7djirQjbbpYqw0kF8RP8LV/gd00InVgNnyMxisjoAy8dEBFMQFfJgfqGDD/f2R
	Jn8yQAopj/NkKT11RwOhqo9LkZQGLAmuhIB4Wfq9tbyxyElCAq67okfV774oiEeOJH4Xfi
	PuOpAzbhzYy7IpQYAqyuwfHPos8Cnfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792630171;
	b=QOOXmUtBaeeaLp9/imLm+Fb76oqD18vpbGjyjNn/A2CIWXR/oCmY+ySmOZpMRStvOfVdjY
	lV3kAiGu5VpQ/7t4DRdPWrDwM2GvziICsyeiMGfrwwlAiaoQvtDtdyIup8kfETH7hjPGZ8
	sU6PmU3QYHTxULCBR/4T5wz+Ccmcd2A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ims99RF8;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7ED960098;
	Thu, 22 Oct 2026 00:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FC21F000C1;
	Thu, 22 Oct 2026 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792630170;
	bh=On0IRKe4yglB4frXH+Fm+UPqKv05FYubzJr21eeqbEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ims99RF8i4IDGm1oTGxJrMH5zr1ZW4XM3gKTQ2zuJkTsYRMCRAmbnmOOy5KCmHAdE
	 fmKWfL22/F8VA5uUXpce5YVAPjvfVsBVIezCe/BL0UkdG1crTGeS1nqGYqq7MZWu3j
	 MkXgt484iA/T44oPBenCy56oRH4E48fuz4Z+IxjCa0LBk8r2cIX76kK/nXUIe2cNkS
	 3S05V4AK4sVvc1yToG4DrpU5Dph4uwFivW77fgW2Fa+ZfgxvTeluhQjWlc8PaPhU9r
	 5i2KpASFzOoVFDiMDQTG2LQ2SrfH/DNULyhkELMrwEG/lLTH9C93+woLWY5Hv3zoAE
	 R9Q5wroMqR0sw==
Message-ID: <sashiko-outbox-180837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] tools/mm: rewrite show_page_info.py with modular
 design and new features
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Stephen Brennan" <stephen.s.brennan@oracle.com>, linux-mm@kvack.org, "Ye
 Liu" <liuye@kylinos.cn>
In-Reply-To: <20261021-show_page_info_refactor-v2-1-c28d1173b336@linux.dev>
References: <20261021-show_page_info_refactor-v2-1-c28d1173b336@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 00:49:29 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 568F4C0004
X-Stat-Signature: k1zyh7i5whekyk93kysysm6n7bpmsoym
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792630171-407458
X-HE-Meta: U2FsdGVkX1/Y+43X/ei4rL1XcrBpf9Mqea0R2BvMgxep70atsRvhb/lWpRY9irp53I/5mAJc95zQO2JWpjZWUwWmNeLoq9jAf3ksRgin23xpwLznmh+apk+4R4sL5yGwNUoMZ9LlKoVHRJ7bAZw724V52XIKo78lCrkLuEamyAkVWXWlZG2WaT67vtaSgZ06HdrrEbV4ZPSolLyN1R0okY5mA1P1XEPGKbXdc+3X1JYM98QRcW+AxlPk6/zAmo0pvsxfBsUa8pNELsWuwl7vvu+wj4a2tlKo0LBef/xhGtZwEZn9NThVdfJ+BqD3OBFo62qGfEmDtBS36EaQw41xWv1zUVPFjuP6jJZF0+VMQm/TQ7E7iJbZE+YLrWeHKxJncHAZXd2bI66cZ6s3MoKLk5Z3RCQ7GiwzTXhT0nLwSSTj+qPJYSywcLrZYiQQuvbWkp8AK66yO78Hoz5pbaJkcdypBXXKkvGVoE8pFfUi5qr/MBrgr7S2LPDfYeibXnOnbIcK+Nq9Dhm57o+yJmCaccVHplpH+Y6iisDtQEfNnA35Sy9eXi8Gnp+YLyz2WDfq9xXRs0J0OqD+1ELC7lmMX760dHRkZDcsB1D19QYrauSvf4IhojconPTufepkdq9LqHb0raMQh1bqESPM6q2utiFTlCLabqAYKuEoYCB345rrHJD0otpAHDUwc96+6eEK+qUDjnDr1UG0eX8zND/TCBE4Jql7OCKk+ZMJ/tGlzGwO2FEtx/lq710CIKfqCvz8CrcYglM6nqb/u32i+9tPYfDFZ7ahrPrrF4P5j8fCj3FpzBP8jp3aQUgCWuKbheyaS+zvoO1ynHpEI2szzcFlYxMamFZxuvd7K8phD4GYxPn2BNhpoz5YZDzPOdVehN83rpbZc1RMmhFJE7+LONlUIxDYMzZrgmXkJLUxuHgCJJm7vnGfjrjXE3MfNHZAu6FlPQ0nRfo0ZU8lCxCZ+xv
 6blXTYI5
 kd4Qbna1jlxIZFSIW/hvxfXQwZGlPj/lRQzcL/G8tvUlKBRafT6sl6vpq8AupRsetisuZg0rQcZ17wg2aDyVNXN1YKd9cOYr1aKDRPVk3LWO3xGlu+PlGZjR7tyZXjKI2V4Tw1zEz7Vql0AAePZTiHXqBWqrrKPFuMDdOV9YBzX7GZRg1n6b762chZlZIb96jfKAXSpORnpSJw0umgN7codLziaZKYaHHq44ZqJlGtSSYm77AVrYmRJ06kjzgk5xgqAcTIcDdkmiPPe5+EsgBTnlsjFCcujZZoMNWdbfsgtAE4LqSpfIGIiqQ6EDGEnGPZTVPwlifCGNMwrqiooRMOZJ+LT70wJtCfNjSh6iomhugfvtjZRt+PvmKVG8fqGPHqirkxMDgzmxiCtdstFfDx2vtU05YOdYdfWPhxqR38eNXV6xeme2G3iCec8+jAwv9Z57XZEI9hijH3Si7SxCAJtrorlMnYjsGdV7Siyh/V8e46asHxcZ0U5742Wt7zHJ4YAwSG9utqFB5YeXUv4k4/1a3ywg5cNRo70WqNSkdG66WBAd/tnfo8gZYfA3Jk0bMQbgM3q4aXYOMiQS1Qtrm5GZWrl5dY6jHUry4fQrsvdUwgyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tools/mm: _compound_fields() queries compound order on tail page=
 instead of head
--

commit 559aca0f2b19f1194e73dadf4d12451f4bc08a7d
Author: Ye Liu <liuye@kylinos.cn>

tools/mm: rewrite show_page_info.py with modular design and new features

This commit rewrites tools/mm/show_page_info.py into a modular
field-collector design, adds new input modes and page debugging fields, and
fixes field access issues for slab, memcg, and compound pages.

> diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
> index c46d8ea283d7d..638fc669b694a 100644
> --- a/tools/mm/show_page_info.py
> +++ b/tools/mm/show_page_info.py

[ ... ]

> +def _compound_fields(page, head, fields):
> +    """Collect compound page fields."""
> +    if not PageCompound(page):
> +        return
> +    fields["Compound Order"] =3D compound_order(page).value_()
> +    offset =3D page_to_pfn(page).value_() - page_to_pfn(head).value_()
> +    fields["Folio Page Index"] =3D f"{offset}/{compound_nr(page).value_(=
)}"
> +    if head.value_() !=3D page.value_():
> +        fields["Head Page"] =3D hex(head.value_())

[Severity: Medium]
When show_page_state() calls _compound_fields() in
tools/mm/show_page_info.py for a tail page of a compound page, should
compound_order() and compound_nr() be called on head instead of page?

Both the kernel's compound_order() in include/linux/mm.h and drgn's
compound_order() check whether PG_head is set on the page passed to them
and return 0 for tail pages:

include/linux/mm.h:compound_order() {
	const struct folio *folio =3D (struct folio *)page;

	if (!test_bit(PG_head, &folio->flags.f))
		return 0;
	return folio_large_order(folio);
}

Because compound_nr() computes 1 << compound_order(), passing a tail page
causes _compound_fields() to report Compound Order as 0 and Folio Page
Index as <offset>/1 instead of using the compound head's order and page
count.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-show_page_=
info_refactor-v2-1-c28d1173b336@linux.dev?part=3D1

