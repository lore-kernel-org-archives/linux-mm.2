Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEDBCDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977B56B0088; Tue, 23 Jun 2026 08:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928846B008A; Tue, 23 Jun 2026 08:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817556B008C; Tue, 23 Jun 2026 08:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2F16B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:26:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9204C1C1A28
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:26:17 +0000 (UTC)
X-FDA: 84911099994.25.43EBFD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8A481C0010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:26:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3mI0J1V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782217576;
	b=FSd3sFn8DMB18VO9u3UBT3tUe8iZBQANJy06cTdsL648m4szAFVHWVNPoUyvdZwv+JYcjJ
	WJb6h5YcWsUozbUU0ArUPFxubyzq6oSuSidCHbFwEO9tyIuYcPtL8nC+xhuwOOYKP1Lq/H
	v7D4O8yQ/673ReCSrz2UXJU0oHXfDb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782217576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcjq+2Qi4hTz9gKpcoKUN1BL+JOY7raiZGGeg9KpcvI=;
	b=BpIqmABJIw3YlZZpsdd+Lvo7UMlyPYMvHp0UdXtf9fB9dvAArUMr3BiQ55rOTMtV/XBHm9
	6yhgdVrZsce76uQcrNkY+eKmGnmcBXBs2IYROYvKtuPZWRjynTzkDsBkpCU/xcgluUdO5u
	Y1PTMBLKf/2IUwTNBfBCS6ZfgGqiDBI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b3mI0J1V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18B89401B5;
	Tue, 23 Jun 2026 12:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8527B1F00A3A;
	Tue, 23 Jun 2026 12:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782217575;
	bh=rcjq+2Qi4hTz9gKpcoKUN1BL+JOY7raiZGGeg9KpcvI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=b3mI0J1Vj5tnmd4HneMBGK3p59ITz1VieMW/bOYNqdxbOLqd8N2r5t+cjcSOrLyya
	 7jzMOUt1wqTPFDP89MqfmDtptnYY8qAei+XgbfUfs2t7s1C2fonAzHq4yxEixK5mGM
	 xSaxJZn7aNqNDusQt5TDinrbc7WnHUeXMWYp6r+9oqTkrjij931bCW7OIhlSWp3z6p
	 dNfzE7OhdfPAhZ2Wb53TNmSQI0nLlpvURc4pJuE7MrWKlMvWMwd6EqyQaf4RPQPera
	 yd4+3OBz/pJwEe9uWowBQcO+lCEjkdyPEie9BNHK6RPPB83+o7DyX26Xsj4t5DSDk7
	 VjP42yWJXnxjg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
In-Reply-To: <20260623105201.3724592-3-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 23 Jun 2026 10:52:00 +0000")
References: <20260623105201.3724592-1-tarunsahu@google.com>
	<20260623105201.3724592-3-tarunsahu@google.com>
Date: Tue, 23 Jun 2026 14:26:12 +0200
Message-ID: <2vxzy0g5moij.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E8A481C0010
X-Rspam-User: 
X-Stat-Signature: 3b779z84zkudo3b6tdfjfddqh4864puj
X-HE-Tag: 1782217575-178238
X-HE-Meta: U2FsdGVkX18lWSPSUruO5BNvQHfJPgnZXPCfDL9KPyrEcyG98K4Tx502pSKX6LoeHS5DwChjC/Z8gxUbKt7RxDEHI0er/aNUiAFJzsGc5R/6PF4pfb5mpMcuRN+TTEfLwjEYo4e6SJLeE+py3bCcHhlOpgWI6GctiXDTugF5fZX1Q3BUg2adT1LCmGkz+5BPLECRNSDUuilfBORaPGlX4Jt380DBotjmmT9eCM+FZ8agMG6Rb5jWoPuIuLQXcjktyaB7z/duPLW3148gkELXAP+gztnJ0p1SEOTQSgkW1p91YHE8Vs+GMPk61lICHJCP4ei7XhUCjuHZRgPvIf27W6T5OtJlL55yeVTA5XsXcyOb3h/2xJtvVAMaamGOVb0VDmtTl/0XkZ50ujgkGGxM9v2Qdq9Wi30n2EH5ib/tYa8+K65Xd7FnvX+RndO/qJH41iHXmkDme7ad5y/GjG0I7XPELCW5c82TpOpc8kZjeZmbqae319vQogzFtj4FX9eFjzbIyHKm51JdtBq77OoIXGfT9mbzyiYJcGR4MZqsrrYiCGDuz5U/v/ZEAERe7BpoZE3XLTxq1LBM16/f6PfwoPUOGAvgTP6R6QAX6WT5VsV+oCeSGDjOdR/avnCI7N6SvCMDYWAv9Etwy4u7tcasutOpBb6D+nwgteM7fOBoEJSLeGZ22QXShCLuucK7Ky5Z/2oK3vGSktr7jLPGapIdu1SNBL4LKVzdMsVZ6uus+hBeSkHAV5RureWn+fQsy6pfdjDFUiwjjHd9iFc4TDSDDaQfdCc7YEaCD1NXYDVVdI/d4HO21DRtUs6iGBahpjKf4QGkew91QGyZXD8/tLtV5fXtAtqz5PdadqKVsV1famG38amIKZBdVEvXBEo6EOgx+ZduPqqbPeO1bdMiAqOHaUt0V2enZ0jFtsGga7NxqJO647XNrF/e6geojSe5p4gYXMh+mOw2JiSdLs8phKG
 qaNUenzO
 MUZ21DgbeLcBPJpjP5m3q1rmRl1+W+cyuBZh3T48SZKdqVqvay1xRkF5We+L2vgZf3rvZ0DsdwHs//hWdibausSNrRWaFiXRJhq9KfiuOvnuaApdyXvbmJusNxtkHKyqk57hFTbh2FUUIFHSN5cQp1c2ZRU1ExWhByV+T7BBnMgI9jtHCUpGMaji+5R4S0YH4kGFNloFgKm14o3MqH6dNLhwzcHAAlN/abK4Zu2Sx1fC+xa/pYZph+HVDOLOEtJHbTqSHJOgShMrtgKEa5Se341piVTaT3hXMycqV0nNZejNAKGhX46dMrCZ2hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23 2026, Tarun Sahu wrote:

> Adding KHOSER_COPY_PTR to copy one serializeable pointer to
> another. It basically allows copy of phys val of the
> serializeable pointer.
>
> It ignores the typecheck if any of the argument is of void *
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

