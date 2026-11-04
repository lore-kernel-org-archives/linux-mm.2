Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D4F606D80B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dc1yalhF
Received: by kanga.kvack.org (Postfix)
	id B070B6B05B4; Wed,  4 Nov 2026 11:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF616B05BD; Wed,  4 Nov 2026 11:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5A96B05BE; Wed,  4 Nov 2026 11:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73DB16B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:41:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E90CA160701
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:41:44 +0000 (UTC)
X-FDA: 85398002928.29.136FBBB
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10878100004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:41:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dc1yalhF;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku2UnsviuHOTDYdvHM/Ud8HrJciSPINrWDXnS5vQ5OI=;
	b=fyw6SFN3A60/E9p/eu1szxoz3rGAL0pTE+54zOwzGfm1P2BW7lLL4/OK6bo+fARDuuxUKC
	ugBGW6QSByK6ne9nemn8lccvuyCOIrs3YmHDuVu1fZGJg7uyfDXQ9pe0QwVo60eL1Aoh1+
	DYACvTKvhfYkeNFCjeCvMmjGeIebBYw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Dc1yalhF;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793810503;
	b=gHR05eKIJ89bNP2//78CAJeZ3FEeGSfjhX74rfrL95k9An1Oj7UfqLcIUFpDbnxOd1iNkY
	ZSjPt+yZeUWvakHKmtF34kYgnTkm9xq3IoqDXwxwKXUeOi0sTx64FmjzlQ/oroCq+EtaXX
	DgkWnsS5c9mHdEW5ro11tGzgZx8Awls=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4b467581b98so6808415e9.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:41:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793810502; cv=none;
        d=google.com; s=arc-20260327;
        b=dqO3B1/DcJMn8ga4H4WAQ4w2iX57FebAULnokPKPL3RvIVvYjFHi/+jB5LSJZZZ8sq
         TxJHNkd40jgMJjs3TyVh3iimqY/63jAA7rFizAL+ajQAQRGOWoalAf5phXS7R0PU5NyP
         ad7Brzjdk24jEcjBPiaFwiPqWWHv5DplSFK9KGDzOGmM8wIXdMaov9xxmAMRgl6qgJlq
         KhED2Z5J7VgOyWfFvHACQk8Xc7fpzFrF5KikYMD7HcvJ4HTGQryOHRk6W44HUqwliPeq
         A9YQLAv93YVoRk82w03v5aXcEMsyKqxYyvOFVY9D6gdkkSpUvsQ5aSJgFm1jdHxg6YfH
         6h1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ku2UnsviuHOTDYdvHM/Ud8HrJciSPINrWDXnS5vQ5OI=;
        fh=KzM5OLLOx16Xlm3RuNqoRIhIfIaVM7kEZmYhn/AhuU8=;
        b=IH21nJ9xNqJtZoLxPj5fBpmm7rzZOEqso2yFmdIPmJkG5MU+Cctg0LJzDUU8dL2mFh
         lST/DqHzJDmoVMpSM0yp695adEsmnf6WGYXIWyCBeMxbJcIsEBrVAvWzf9fwrLkCgpg6
         3zMonQpjPTQpwD02oESOJwoUkosM8YyIZPLZ/KIcRaKLsnGeFOzsuIiXFjVMglLkmzG6
         T3rcpI+kQjEuOQgYWjMpbPwpnYTiN/QjnS5lW8YMj76ByoPCixx8Wueesj5MZkTV3crI
         AOxatqGRWmpsssrPb/X7HOGijgKzJIbCaO5rxdN63k6G47tUmpxKOa2MyAyVgIGNhjmH
         vx8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810502; x=1794415302; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ku2UnsviuHOTDYdvHM/Ud8HrJciSPINrWDXnS5vQ5OI=;
        b=Dc1yalhF0WuOw8r6Mt9/+Edhm0viNUkplT0BDlTyvjTHtK/tAJuWn8FkRmKqK/O8fr
         oH68U1+33UWpQk83dpXzUe6nypw/m2W59ugmQ91/arZ8QCdiUGvBqhdTWZZCeAFahvLM
         /kMif6skgwG3D+GgYeC6KtphkWFj81reMFWUicHCANuIjYfCiXHY4VcwfDVsRrasuCY/
         m9MjSYvuBY2McRO8gyydaYBFiyaQ6HUOLR8BL7k+XiivZMzNtsnRuhLdW2GVs+Nl3cZY
         Y09v9/22SNLkezn8THQfBS76p/usUtk/B13YSjBxscX9I5IUu/hF0GpqZ8/2A5W1kovh
         7fYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810502; x=1794415302;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ku2UnsviuHOTDYdvHM/Ud8HrJciSPINrWDXnS5vQ5OI=;
        b=e84JHEeI174qWYZ7Womz2RW+riV9w1oUNfNJhW/ll1LgRh1Q78/fGIovT7vtC9g2l9
         0v5YM70Fux8hLdjnDePPZfKiROKYF4dO3HD3iFPMDcS5AIEms0sP5H1dBC8hFpxfpcCY
         1+3nJxfNBe2rRtyAGnJGkGBzbrtMn2YYEyAxbDzHlQn8zqXaW/mbr+/lulqWXvXmzvde
         tNcUqbuyxjNmcVCWRXa5R6glGn1wexyDwG93jQa716rBR7Ad9eUtIdjVrqXdtIoSeJBg
         MNKY9qIO3pw96W2w/FG5v0vAtDJgsHmULTvmpRqohnCzNtoNAdMr8l0GUbmbEYcMm0+8
         cSaw==
X-Gm-Message-State: APuU4Z9PrKLvR1KIRAO8T+On7eJmH6LYFjxxn85hbEKZ8WvLLC3IwZlt
	gs4e7sChWVuwpB05xd6uUG8TVXju7xgeIb6Lze5yxaaPTGvdsWYjD1D5Xd8uIn62auLpwuJ4O5W
	stWZjFehqGrJpnn3Qizw+VFKqh0oIOe0=
X-Gm-Gg: AYBFou1zxt0q0eTAmbpa0V72RbLFxDobEyr8wlOLTx1EE5qyuiIjCTiCJz2qvXvoOAi
	rBpipuhr4Yzu/JK/DqPsi5Gk9Y26fkOYI6Y+0ptOBGEdQAguj6A4aC96EiB3ahW1gyeWJ/wH1no
	Zagex8MPw/WV9HOvG9PtVgWVZDpdpi/+pLhgXfhoGSCM1kTAs664OawvrPThqzuGE0RDzaDp7l8
	kFLUNxQK2Y3aGVdtUB4oVyKapaWJd5kl73GLn3+FEnvxV44Ate3EPUTvtUrFbVXyc/sDgfINJrE
	Hp1y3BGCrTXN0GQZjNhnFeli3567X+dvwHplUFAe2CNpVTzmXuuRke8YFuZxUGuwCYHTEKm1bPo
	LbcpdSUp+/nC9KTAMxkWT5nGWWCKqBmsMHcIHtIoYcZfUNRcvO9OtKNhoWvxhD8RP6bBNZEcr2w
	NrA/OH+RD3F1wPEHBLV9ojdmb8ZYMqva/G0dwViKlcu8VgD4TRbmhO
X-Received: by 2002:a05:600c:64c5:b0:4a2:150f:1613 with SMTP id
 5b1f17b1804b1-4ac17a367edmr385395375e9.7.1793810501682; Wed, 04 Nov 2026
 08:41:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com> <20261104-swap-hibernation-slots-v4-3-0ba9393609e1@tencent.com>
In-Reply-To: <20261104-swap-hibernation-slots-v4-3-0ba9393609e1@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 09:41:29 -0700
X-Gm-Features: AclHuK-TAkBJYjCRFl11en6u7op_vk6E20BwjEFAr3odRFFXaGm9rD6s17cs0UU
Message-ID: <CAKEwX=PMnYYBfODbQZJCz0jSPSHy7Y3CkKeDWzxKe3VsROBDeQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Jianyue Wu <wujianyue000@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h1wo63dcmn9b4ii6urqb3y1y5pymj4d9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 10878100004
X-HE-Tag: 1793810502-913278
X-HE-Meta: U2FsdGVkX194E0+eFE1/iYYhgFRNR3yCLNnJAAc7PZW//LfYKPNIGn17cMo9737t7NiKLBh9FQvGeGZpMZbElwKySyqGR1kA8V5pEvIWYb24SWT/fBVKSTiahnKoR6maeXYCyp2DuC//puZ8oCaD/+oT2m46/S8iV2gagcUWs/XQntNlmQTkjzmdVGm0tPWSB1UzBu89ixJqIHgQ4s5V3DsF6JdGl9qnhAQIkZ+gXb/dsjgSBP/EAOa5B2uZiz/4TcRODswwKkD25dhsKvvIpcigsCXbD6qM/8xr18RI4m9fFhh6IaEbykRXNboQ0xdu/XxIsx7KapktVQv29Q26tQV3IWQA7mxKbpaCD+pYwyCtgRshRXc/9HrYon0sAOZMP/ztUJ0/aR+yO2++tvAvq8o1eroInnr2mTk8AU92o7z2g8hTKJy15iG+JEEA+X8xttLO1BQm2DCkgebp7TM2B6vLdIh4WAq7hDioX+pnxcSoF5mwUMC+yggp5IB6MuKrmLOU+eNRNxzeS//QXBCvU5UZf4CKuGrt345VbR0dvo53NeP6TR7Hp7vVANjXupFEtYL3Pl9Upl9x1qIJubmGnVGqmfqwDr5vssfb/mu7tolpAPtkCECZNObr+kx3wov5XYv9X9OSVWRsS8R2hJ/F0rfUJktToncvllA3fJ/BVTLwrH8SEzvpW4/jizP/U/4RBo/A4ZMICoI5KIHyJY2BsCURmfpe667AmU0esh/Bav6xRfHWKKGGPR8XnmQu9O+zxXySt6Zdostsy6jUL0OYiru3uuim9Fl0RCAZJoB0ABeMaFqvd4R5lDBSJNUnAk37zTNNsurX7FuCzPOzgYKrwjnrKdwTdiJaIaYU24VYRP5VbSQELoDYgqaCUWAfQQN+L7DCelPWKhauHIRuIrpuHZRpqqT0rWGJINt19Fsp7jU15RmkM1f43iv/eBjd5Ra2NsgkDnBdaK3FbMAQZN2
 BEzhvqp8
 gqApwafa2rfk9D4O7eT8HGz2/0AetlMJj3rI33MJBDKBB3h7UTZjc+CqkM7SjgfeY/VOxWT6ANjrd3TCxmXoJFrMCqsM2TXz98cj0Fog85yGKIM9PzEYS+Kaxf8L4p71PP9srfYK5lrLouo8KOYRC8uCtxuAiI+pVKuVgG99CqD6PiGBN4bcNPWX3nU4BsIIXVWG0m2A6kXDkpU1uwisr8JpZctS/5IlWOxzM0nnSjq3o3WRziNtgLkJN1YteZzNzI6Ntzgf4QV+dvDHwnmCn6uRJXA+IsDaETb7fd46LCqoOa4N5m/30+w//j2DoPfOUKK6mipTiQhuoPtfZy2z0hxeaomz7po2dMHundF4u7J5ZUB0cgwaSpAVaC6sOTcZjpwKpfsQOJhHXb18IMeLmXA9TkoUcw+eFWAmIBORORcEgDeKdaYih0ZJiHf3DpZj/v8jglSaCVTggHB2vAi6OpGcfhukkXNdx+ZbKtB3/e7VIZ0z6rzc2WESWQFk8ySOtmHN9s32DOYJHggdS9wDdiwwfqaifDa1PO+iA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:25=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Youngjun Park <youngjun.park@lge.com>
>
> Both are there for a folio that readahead might have put on the slot.  A
> hibernation entry is not a shadow and has no swap count, so the swap cach=
e
> turns it away and no such folio can exist.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

