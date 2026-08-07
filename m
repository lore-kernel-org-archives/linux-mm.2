Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D4FC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584E56B007B; Fri,  7 Aug 2026 03:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534D86B0088; Fri,  7 Aug 2026 03:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424316B008A; Fri,  7 Aug 2026 03:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16F896B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:33:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85BF5160350
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:33:54 +0000 (UTC)
X-FDA: 85073659188.20.0DB24A6
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DF24A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:33:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8yTvrGV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786088032;
	b=EMeiQKu1uNBX6o5KBLZDIamwrNT+cejbxEMFHKU2O7QEAXoFplMZLw20muX7LTkeoSiIAV
	SbqUBWIubp9aOLSNSfHQiV1kqdmT5yqGDnWHCc0hA6dVnnctKM4EXJmz1Ie3iHU+7z65PQ
	K4nNRbO8kBeCe62QG5vln8YvyoyYnFA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8yTvrGV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786088032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zbS5qgQb6dtOPQJn038F7bIW35hHx/dHAh4uqp+OW0=;
	b=TUd0U3q6CN8RIUwybs5xGJ6/w87vAXP0JyKZRQTM1l2PGX1UPM4nJP7mAu1/kJ9EnyHzGs
	/h63JztL/Zy/d5BZ+Fbu51HaC5avBYyM6Bic/ufdKwrcxEoJYHzBbIbk08IzysbDPhzHIX
	iXuIWWew1i8GmdpOp79CgY9QB2wAd1Q=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1600d040e4so257973466b.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 00:33:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786088031; cv=none;
        d=google.com; s=arc-20260327;
        b=PY2R5VepyfgDHdY0Kl8f8YxObOK1jZLAf/9YkxGGVIlTrIV4TfStYk+d7OzX9xIacj
         4ODYm80kUvhkPGKFm6pxPHFzpZ8/stLAxYtPHZSQe2IXoBStd+vwFQZ2CqOhwtGGwPP+
         KeHYgaNLiZBEekzDN0/WQlmaN/IbJ7a3gq983HAv3bLeC1brw8oMPYQBCX3TLyhz11hq
         OPurx8V/v2Nttdc4tY0KFE77U1c3hVBcHPF1H757Fz1tQu4B/MA4HcbVP9pC2eT80THY
         GW1vKIDs1wkueXQIpTuHoA8l317Xsopbrzqsu6bzSI+wu7BXTPzMAezO6mrIYleKPhqu
         WYog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8zbS5qgQb6dtOPQJn038F7bIW35hHx/dHAh4uqp+OW0=;
        fh=I4HCy/FvPMt29BYM+O0ZxTFyVKEa8gojh9PfMOKTMo0=;
        b=AOTDJs5C9Zg/V6sky5/+0yayMnW8hyStmqzh0AGhegC6OxzKDittg3jhOgb4e+7l+x
         Y0Gpip3EJcT4DZ5jocqY40doUZk8BxYuDapYXaAzXomwG13qFajXNF/HiYrx2xoCOUou
         koknV+H7wt8bTPdj+f9/1lkXwSI5d9+VMnTZPnX0S2wIBwRo9ed73f8mnaDCPi+Y54j8
         /wG0Pv3pzxf9+oT2cU/SGW/sSIi+l+REOgNG2eL+3l0hd6Z2EPnAPgXgvHOmuWrGqasD
         02UlVdSH/fjtKBtTpz/toLH4F0jCPrM3mmwWeNAHeQfwJBedhfUU47LTqDWBEBvXE1cr
         8BjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786088031; x=1786692831; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8zbS5qgQb6dtOPQJn038F7bIW35hHx/dHAh4uqp+OW0=;
        b=W8yTvrGVDMXQVbGdWhboUacPYmpVvQULPXwxWFO1IPs9+w62Pg2A+u1AiXMA278fLX
         rU7eEjcwzeR5f5aAlaiAMaUK+laRboYU5m0wyydYhDmcojgQyT+m0ExiFeUeGfCMVTbx
         vYlEffuWadR1Zu1mWFrmMAG741svUGJrsRL1kP92UViVuBkP2rJ2/Ke781IKcf3rudZe
         VL0s8WqOmx0I3rw+KxuyVounbT1+QGOBaP0sRTgujEtralleVicWQv4YBpxxiQYeJMPf
         owxPbf8ipb9sYe0+eN439s9YZQ3uSa5T1SAivsraDg/dBhKy/jAzgDMip18kaBJs+O1H
         w8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786088031; x=1786692831;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zbS5qgQb6dtOPQJn038F7bIW35hHx/dHAh4uqp+OW0=;
        b=KPvj9UCQAFb84rSZETwPKz7DSAlOP6ufHCkwndL4v+z02th3bzN3oW73IpQhkvOezD
         2Pr9R9esLT9oqzBOHPjwqvj0QoxbhQLvQwvewNxCKIuSqlMEjtRnoHYORQ0XFtEM2I8d
         Rw76t1X/GHJoNtqLI9/xg13Wx+B8DfppHrLuRuUJS/AZVMjbvfzNl2a0hMgzifaLYHXB
         IdbszX0tcTHfj5mi+Ks0JlcgorqAz6gtbmRtkf2CP4skv4cgZ32/E7lDKBmA4ybXbIvE
         T79LuFFARmpzFqO8uA39xYo4W8Qlzsnkm3T2Wzt8vLa7CHXPGgJNMxFFjjZ4xRwkgOJd
         sarw==
X-Forwarded-Encrypted: i=1; AHgh+RorRzIQiKHQoFbnIjNps9WrjNSOT50PJXY9fuKP9dot6gtQAaNAg2UjF6cjcbu2LCcpDpMLWC1CVQ==@kvack.org
X-Gm-Message-State: AOJu0YxrOMdupN67NZQM8rzO/k9IgF8UJsfxoJm8pVxzURgmiWJdHBJc
	MOHJaQsA6AhSNqOvdWbpnIqkwNnIeirzNyxiKm83Peym1rWPEdogBa84eRSwYtjq6ZLe10Q+Mck
	c5jTgRdNHJGLm35X4xNCQm7Kmydtu/ms=
X-Gm-Gg: AR+sD11RcH5X166RNsqHEvaptjKOs7M7VQYddLrc7v2IO6Fx8SAkwv7dpHbIzGNhHpt
	3JVoFsP/lg36Hd93zI+0UIo3SKfKJIRmD/l0hPFqANlgzxiQpLSeL0FisPfrAwj8aFx7tidLooO
	cB+VsU/mh/gkFYD2haI7Ebl0hhVIeq5lvKlsEdyoYF7g5r+qX+GD4uiTNUKUa/owzeXAV+9qxZ2
	Y8Pa4IC7JJ1ZoIA4JRX6MkcR7tmGec01fJwuXgFfY6N1iW3YYomzvhUesZ6en3UkhO7ObDdCC2s
	PeP4cBBDRgkticEvvVp4KrSaxN+K1Y2/YcIncb2CokssumYmngRjm+WU/YUlkhCzqln1Xez/zga
	Qjw==
X-Received: by 2002:a17:907:7b88:b0:c12:677c:795f with SMTP id
 a640c23a62f3a-c206355c0cemr526756766b.7.1786088030668; Fri, 07 Aug 2026
 00:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260806193228.458685-1-youngjun.park@lge.com> <20260806193228.458685-3-youngjun.park@lge.com>
In-Reply-To: <20260806193228.458685-3-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 7 Aug 2026 15:33:13 +0800
X-Gm-Features: AUfX_mxmI0O9m5f4iiwrDj8E6jP-_P6en6OaHqBxThiD5cPeogYLqSEVcwiYcRI
Message-ID: <CAMgjq7DuLQ93ieakdh6P_rxjeDZS2nq0uaJWPJmw=28LujMOxg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/swap: scan by cluster in find_next_to_unuse()
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9DF24A000B
X-Stat-Signature: ncbt9gh5rfibt7qiae6bwqxjiyq551wz
X-Rspam-User: 
X-HE-Tag: 1786088032-247136
X-HE-Meta: U2FsdGVkX1+/TUbbuYmNAKjrzm57UVGTiP2Mgejm4eFMUZg1ku8ntpCGYsq/kI8SEdSIuVg3L2K7QiQt2dugBmqPfcF0l8P8sWUq1yIJjFn+18HcZYHNAu0JAI9UPVJSxPpWPkvKGc7gB2zIPIEWtt9NyjE1CF+DPTc1+lUmrLJvO6a7Oe6pfUpd0ANC8RaLP16oi53sXocDUzfq5P+mpL7EkMcV5CdqF8t651kszwtD0lTF8TcpRYbQOxPakOaDkWuprdtwbQzWt3/FvWFJ7hCHJDAgPxFJu3H/q9HUMcWV/pdMDJrS2dhdCoLguge1KOEORAd0nsieFHPYxB0wi26DVSPfhWTpNfaXVxBF3ExRJFAMYam2ag8BUI/ye7gXIPQbc+OPHPNJKuYbuNAot09RIYSjdJI80HS1pFq2TEA1Mhle56Fkq6PL9RphtpiPjg7ZSo4HA3XW4lm+lYIi9scX37uR1GU8lvaaBMEj8H8XIPfRhcYiDBdFJLRZmuq4R7gBjQP0QiVdizH/xNDZfUOl0jziJnrqk89WJiUGrphCakMpks6r0kMy5XgjeOQwCjuHUcORhOK25FWr5M6PAoHx9EGKdJcI9v3vkukFqUjoWxhN6abAiSZRshtyboMxYRXD4aJkrQuelmUH7uhjC2aUWkFpLaLKBXcrWB3rp8JWDCc+dx7Wns5obtP1PMStYS3jf/CCvjwRsgSvNOQLVCG1h6UkJ276RidvEpSulix30dnMWiWR35qGVM+Y+wzCA/pkK+YiqhhMXgfuhFGQ3GwycDHmxCKP/kpXbU8Ut3pzQGPYL7CYSLhuGaIYoxww5LyrpX7NxWknUX/NK9eDcd53V5kSCcLY8rUj1VX5WyJy2rjdx5lqYnYx73orjcjiYn2BU+lgSG1CqN/SUraqNrmPNUeXWxBF3YeVznN4+FXS8TO1ff/jUXYNB8FjrEUchyeGz+4l3KExeMNFlGq
 Jsr8TglQ
 0f6vA6E5DPm7Dpwt43uNWD1miT4lQFK8oe07ODkpZzX3bZQFPa3Ykj8qC+ivzueB3gYmvqhgfei+DLBK2zytRAexyDn2jj0uS5HKOB29cbiXaX/QF7M8W2b9LLokQBZPhJayjRCWUVkGwt6Z6Lm5vUDku0ymd7OVsuCpimH0vWOAt0DICnpmhUyiJwBymC7K0vTp0DcLevqGF9WJ8l2wFNAcqQ7hbJr+Mhi1Lm8imAy8v092Mabvi3mhybQ8nYR1m6Vzi2eoKawth0AQEex7EdXbQfI4jThfLrAv1pWe+eGQ/QpcWeKl5L6eir4PQGi7tAoaN/gEwaV3wr/5XNcXHrjEvMSHLyCL1Vjs1NSXlvDseomLGkusKhxUPHZn6/LEzobROMlkQ2xvs/UymB4+49JdrFX48dmat/YTVQhc17EmlpbTSuJhxXlxQJYDgT7/jqyXvB8lyVRJ9c4p+iG272+RZ2Ymwys8Sf9URlWJCGG6fiUNHb8blZwJWInELXPNGlm0t8i3xaWbS2C0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 3:47=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
> restarts that walk on each retry, so the cost scales with the size of
> the device rather than with the few slots the shmem and mmlist passes
> could not free.  It has caused stalls before.
>
> The flat walk predates the swap table.  Slot state now lives in a per
> cluster table, and wait_for_allocation() stops all allocation before
> try_to_unuse() runs, so a cluster that holds no slot in use stays that
> way.  Skip such a cluster instead of reading all of its entries.
>
> Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
> answered those stalls with a cond_resched() every 256 offsets.  A walk
> bounded by one cluster no longer needs that counter.  The loop now runs
> at most SWAPFILE_CLUSTER times before it returns or reschedules, the
> same bound swap_reclaim_full_clusters() already scans between
> cond_resched() calls.
>
> The scan end is clamped to si->max, so the walk stops there rather than
> running into the masked tail of the last cluster.
>
> ci->count is read without ci->lock, so READ_ONCE() marks the read for
> KCSAN.  Allocation is already stopped, so the count can only drop, and a
> slot stops being counted only after its folio has left the swap cache.
> An empty cluster therefore holds nothing for try_to_unuse() to act on.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/swapfile.c | 43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
>

Looks good.

Acked-by: Kairui Song <kasong@tencent.com>

