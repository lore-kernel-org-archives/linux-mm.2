Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FC0CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E7C6B0092; Thu, 25 Jun 2026 04:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A9B6B0093; Thu, 25 Jun 2026 04:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6366B0095; Thu, 25 Jun 2026 04:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E363D6B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:47:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D9381C6098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:05 +0000 (UTC)
X-FDA: 84917805210.07.371ED42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D867F14000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:47:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rt1nA1hb;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377223;
	b=kxDmtPmklugwOzRMEwrNcy25wlurvepXsO85at3SziHGC7VcqFYEw/znVPMufmOMwo0RPn
	vScFpUbgyKdj4waM/31f0mP8G8nltOTCY9K0/YYXAIItdCN9dsKv3pwGoZv9aJ6VoD66Tf
	N/zL+hK+FeLEVpNT01x0sR06wb7mUS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2YH28j0QnPN78vgNQFlgnUUGL/7VumVKZvS/nv5GSA=;
	b=U1ocmEYaqtB34tMRJi8457aqRsTl2T2KB2KCjM42x2lMHvuqZYDAT9RgbBobT+xKrcPgIn
	gRf/xOIA8LotuUYNc/hWsN1CuUOKxe0N+2f+QxoQ56EhJbpepLtbrkNUdNdfrVyT1jf1Ff
	0yh6LVHCWMePePp5aKTltpdFl9TydDI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rt1nA1hb;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71F096021A;
	Thu, 25 Jun 2026 08:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AB01F00A3D;
	Thu, 25 Jun 2026 08:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782377223;
	bh=n2YH28j0QnPN78vgNQFlgnUUGL/7VumVKZvS/nv5GSA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Rt1nA1hbrm2BJSKb0sT+g/l03+LcVTfr/wfZ2IpUkwHcN5k+zcv9VxQ2dp4VubVbt
	 xH5fCsXGpQ76NW+TKTZ0aN1nxAfrTsAGuKCHurejpWlbRCDWGYs4Ik/iVz5udJKSeY
	 /ipC2wBFIaJfxu6aVThVJFCSm16RYmrBgiGWqVELqrNK8xfrkO/hLTNEGZ1h2IdBLs
	 VqqYpk0WgsrtYd0Q+ev/H44OGqgAiF13tS8Eqxp29EtHo/sRLHklon3C4zzCrOSdsO
	 vGLJIpmouWhpWeMAkXxeKkBnt77I05zhsBDGlf+zUE5OX9/boVrl93qBg38WgudU9B
	 FFdhxvll+ZWeQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/6] mm: remove unnecessary empty range check in
 early_calculate_totalpages()
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20260621145919.1453-6-ekffu200098@gmail.com>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
 <20260621145919.1453-6-ekffu200098@gmail.com>
Date: Thu, 25 Jun 2026 11:46:51 +0300
Message-Id: <178237721126.146960.7847213574193950166.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: D867F14000A
X-Stat-Signature: xd7iuapkxnoqdmcpoxtpp441ybwu9fxg
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782377223-499226
X-HE-Meta: U2FsdGVkX19IF9U+z84cpA23Zu4pGJDGGzseAp9ZLTPqbFFdrz7muWtIjJvlTiGWp7aoyI3XyJwTr9VUKRoM6+vH+7QA1GYAp/yZeZxAU5C0zcI7zrZpVubIOdaVanVP76Jb6MGT9GcUJ2gzQS6gmNMkLP7bEFfkeIGW2sMKyQzkWkqK9HDyRqNv3yrCtufODZJ1Di8EmROuKd62jvHnkanA2E8xv8dIp58+Dxf17SNNXsVRVIR3Zvh2gOAloCQtbRuCgbpgQP6aIN7vHaQ1Dmf0wI7j1bNOk5eKk9MIPwaUg9jgHIata3Mt5yW0VWIMul/kxqVJ6eod6sCtxsoYq0cVAIjozlCRXnqGgTokbRB5VfAYwGJWz0U8y3HLESZUk+SODZPbVEqEGwj5jREfmH6iYRxHTzrZ5SU2s/zu4n1Ut/Y8bMr4szqTPaakG5kdr0AoeS9LvAm0Aup2q5xiRiAbVK1BqMcd7YEwQbhwQ+MbBthb8OtL4klxi6U70bISmixKt0F/Z/W2qbdfOaRsp4LfJbVO+SgsuPI87/rYkQR11LbOCCblYTG6AeKtCgBtTAg8jd66uU70b03fjEJ3MWALSzgKNWpau6t/h7y1UJdfGk/YunPZeLtq6sk7Ji8h32ewETdgfeSZbjB+AcTyCvFgGnGMXRjvK5b+cNf6R5fA7G6hLWEnSjuQN7V/ypvUpvRcG4F6uk3vpXcN8vLDwUs2Kn6RURI6465Y1OhF+bUBMkaZW7rtt59DUovAJL4uSiflMQFJLXjv+GeFqgpKiAi/CzFAXYfyEeULcUDrhg5XeXxwkN7rQHfoVUbNzj3dL8I3JhZD4zaZfSaHRdoSRFRj996qMW4YTTiNyahSU5bZeaN5sZ4fNpYWPYUJFzkIdm/8Hn7pptB3YTF6js2wxDWPPl7v0SfSatM/mUgAwQywoMBNByt9UD1ING/+iN+1F5SS3NqQoQCBPy3Lgsf
 rAn6JA4G
 VYpdeVUnURBMWjz44blccA9P6JhJNGdUs0CqTCmT386dWs95OMekypFuhWZZw2D1DoGYlr/hDGAubfLLnOXX7bQjU5JA4N7/+zlST17iby+nnoVO2GZnqtXxXOrzblbBxjW+Pc6iTdR+Vijo1iN3ScJqzySwrIfkzWSycXAe/j+bKURfEpVx+lOb6XyNYd+Uij5PCOckjXctJLn2gJ+RKKDzGfPGhw0ZjCiD1cQGvSLTCS3uhBCy7eEknJtUACHJ4Wg1PvhkGUTQlA1VdYIGfCcv/5uXWMUQ1SV5SfjF2caWYj8d8FgWI2i+EyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Jun 2026 23:59:15 +0900, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> early_calculate_totalpages() iterates the memory ranges with
> for_each_mem_pfn_range() and calls node_set_state(nid, N_MEMORY) only when
> end_pfn - start_pfn is non-zero. for_each_mem_pfn_range() never returns an
> empty range, so start_pfn < end_pfn always.
> 
> Therefore the check is unnecessary, so remove it.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


