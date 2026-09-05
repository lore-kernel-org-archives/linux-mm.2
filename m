Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1909EC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D726B008A; Sat,  5 Sep 2026 06:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE3F6B008C; Sat,  5 Sep 2026 06:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B045E6B0092; Sat,  5 Sep 2026 06:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3C26B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:42:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2D841C041F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:42:50 +0000 (UTC)
X-FDA: 85179370500.27.3F05ED3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0ECF720002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:42:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKmpDGQ0;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788604969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLJWFNXuPNNNHTLThsNU83PHBMIGxroyjlrmOn0TnyQ=;
	b=ZA5p/DMuA1jssTHNatUMSs8bWdc7FYQDYYK1nHhmde3kIo/IuI3zOKNhF4v2dYSTmgvEgy
	O6KbiE9QkH62jj4BRnTvy16RNm8yNrGlFywHzKsIwiHgO/SpZcTXksN2FYVwpWdyv4NdAG
	MLPqAcGk0N0DhDUga5eoUxZaTeSG9XQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKmpDGQ0;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788604969;
	b=TuLPTEH1Sr2rYQl6Kqw9brVqOfHxxaGtG84icY8/7MVVJ3RB2IxsYvKfBfSIYx8Zh552O/
	Vh56yJBTrLQrqyElp1Swc7TgOzby5s4NhGgPqD9GnfLnWn0HQv8Xfgw1BnyLr6RiAddWhi
	sfBb1AM5OxBDNtWAI2JA6ouDJgpdUPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED43B4478E
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D911F00A3D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788604967;
	bh=rLJWFNXuPNNNHTLThsNU83PHBMIGxroyjlrmOn0TnyQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IKmpDGQ0el4Idbgrsf83+Czj0k3aEanbwJfSsuvjxQZxp6e/k8sk3OA5z3KpcZJJ6
	 Fck4hPBvPB1Jxz5ABQcNA41TBXv5cVpcV6iMtSoFZ8MFkFiu5zoIHPRb11O0bzncNB
	 9PQsi0G4qk56XSSheLR66QFt9lRNqLg/hMUl1DiKRRR4vrRjmUZuQ6yFKPfw7UHTxx
	 vUV4nG87nbIlbZqHmOExdAxh82ZOpa+hS4y6eojZkYVpwkacqwFl83cWsB0QXSZsLd
	 0MIkRnKvEUqa60tnTxqyXa8pFlnzmqD19pXfb36Iec4E2mk12w/3CEvUfw1Lm+K/gz
	 xbG2Pez972Idw==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e99ef0902so161120185a.2
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 03:42:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByR8bMLDMkNa0fWagciNov9gP6Vm2A2ZXiDr3Mj81YlBwBRK/ditJmgA5Yj09J62Cu780HcP2DLrw==@kvack.org
X-Gm-Message-State: AFuF++nhcx8yRFJEwlqLCOZ7WlDxMuyq0pEomD9sgn3YPKkYhz4/oVGn
	PL8XxUvwz00+3EGvepnOWSaPtBbmsmTGJHIw13W/FLsiHKT5fG1zJpYrau4xNdz4dzN+ekUGUTV
	eZhXqdEikXNmPhCf7zhVfIfXAz0bn0Fw=
X-Received: by 2002:a05:620a:4e86:b0:939:6dea:ce77 with SMTP id
 af79cd13be357-939804a804dmr849282485a.45.1788604966952; Sat, 05 Sep 2026
 03:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-6-dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-6-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 5 Sep 2026 18:42:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
X-Gm-Features: AcwNN1XGWvWBuJ0T_PK_fgXIydvvLgvH261yKhl-AABkpvYtbUiBkK5uOF9e0oI
Message-ID: <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7yf98n9g57whxy7xxrg5w4d4zxrcios4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0ECF720002
X-Rspam-User: 
X-HE-Tag: 1788604968-518937
X-HE-Meta: U2FsdGVkX19xeFSeArukSN/BRqDaxs23NU+ZCDIlVQ/7tDFW6jSG1Loduy0oF0/wukocy2/WFYPIHjwfpzz+93cRqKMzbHhBVUdWmnpcA5saRHYc7zkBMwsuFA5ZbGjP1mHbnY8G/0y3RMUyCVDjdESf65/sWboBlVbRyT1RWDO4ktyF/7nJPJDTVjdjsopPup9RQtueacCV/uuuVwLZzHTtSTM9jFGhz94bjp6hQJ1IHA+jj/iROHM+AMZeLGpwgN7y0nvksO89Fts7VooLnweevzFv6b9E04GXw+BzebRGcXMx5OX0JlWp+0nHUz5EzXXsE4GKHmaV19sQIJwKP16YbmQRhC5j2BCs++J/ur2Mt1iZasvt/sjor+p1XHutp4yAoGQApMI/r5g1+AIdxOVVTNCiBdWlPSV9RHTqlOV7+yp6bNNDRJpeutzNrQrBw6/kgMSOe9tW9GEQUh6VQQugSlAkR/Kg3yQ/dKTx/OVzZoRkAKsp3rsKJ575bH4+yGNVOa7p+0MSCWXo8kNjH6A4dcu52YiirXvGj5yQuSSjbN/61i8XgZvdbUQrozqUchDuyx13YCEodkpbnMO1SQrolzxifZUQhi7n/VOn2vWnPNbUvjQ8cpDRu7yelSWvQSt/9CSXJRvECpKY9HQIAscEDTnk2ylvC2RQZNrk7L2VpR24/eP1SaHBqx3kl60SH83bGiFamkg5zNGWrnC90jasr3SjUp8cb8bQffy4BfzKNDSL13iV1wmJO3DQaXKhJxn0BhwtiuylhwNuJYiN65BRGrIhfCz21hZxDCCPlTi1KfxBZKHXaimfKwdLFY63sqM/QWHaPf55BomPapJ3XFrzkL8YJZf/CMfLmGfxBbJY2QTIR90sRyBFUs4vgB5L5DWRF0iZIrvuBVX1tFAzfqa5cIRUabBkjMAQN2vYbUuaiyz7DU4omipSKuPqQupAiOmwDjMCPboFrqse+8G
 81nC0Y5q
 064Uy+TJ5yjRkf5pvTTz+sbq8z8yTDRqL879SjeoNojg8qGbvHM64VrKFqPBCGdgIQMCMUYjr0NqBfv2VIVvFxO3Q0/l4zu2Vzvbm5gEulb7oZvTHGSitO059ZlxEj9eXsUSVJbUK/R5rGyS4FqMQpW9Ha/RCRgF843zAVuPYMnCEmIsOLYlMbbdLZErjI6ghSbJ7MykGjk60c8caTcfcHf8Rrku0vOmwcVEP943D8K6xwqLVrMzeJinKSM54x/IE95VJysxpdsGEbnQTeD80wiqRNjGHro+I6+I5IPsptpSuZaiyTomrAb5o2CPvD9Wsq4gNKPJ3fGZ186To4UFXP+OlYDEFcqqh8qeBz4nHzEEXrpWHTz3yeqDGQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:44=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> In preparation for adding a helper to set softleaf ptes in one go,
> generalize the swap entry helpers shifting the swap offset by delta,
> for softleaves.
>
> Note that the soft-dirty bit, exclusive bit and uffd bit preservation
> will still work for non-swap softleaves, since a softleaf entry is
> constructed out of a type and offset, and those bits are ahead of
> the soft-dirty, exclusive and uffd bits.
>
> For example, for a migration entry, pte_swp_exclusive() will return
> false, as the exclusivity is encoded in the type itself
> (SOFTLEAF_MIGRATION_READ_EXCLUSIVE).

I don't quite understand why you mention this. Is anyone calling
`pte_swp_exclusive()` on a migration entry? Shouldn't it only be called
when `softleaf_is_swap()` is true?

>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/internal.h | 29 +++++++++++++++--------------
>  mm/memory.c   |  4 ++--
>  2 files changed, 17 insertions(+), 16 deletions(-)
>
[...]
>
>  /**
> @@ -523,7 +524,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
>   */
>  static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pt=
e)
>  {

We might find a user for this in the future, in which case we might
want to rename `swap_pte_batch()` to `swap_softleaf_batch()`?

> -       pte_t expected_pte =3D pte_next_swp_offset(pte);
> +       pte_t expected_pte =3D pte_next_softleaf_offset(pte);

Best Regards
Barry

