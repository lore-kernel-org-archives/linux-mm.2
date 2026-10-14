Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E261DC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D636B008C; Wed, 14 Oct 2026 14:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE42F6B0092; Wed, 14 Oct 2026 14:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA756B0095; Wed, 14 Oct 2026 14:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5A56B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:09:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25C751A0689
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:09:00 +0000 (UTC)
X-FDA: 85322018040.26.1EA3031
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96EDA180003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:08:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=monCtWUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792001338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJDX7p+COi8qSZ2TAns/+c4C3bCMkstG1AQhV+nfC7E=;
	b=lCbVG+SJXJP8ZZ8f+57WyJCPhqXuNJAMrc6FNf5nx/xL5YBU2PO0MlKrPbYAhiErRdNPdZ
	KLVC5ICifI9chPtWUFzLnYytwT6OdjtUXGfMKytS0muebfNWf9sdGo69bjU8b0C72ufvL/
	Sxt5RIXnNafguKJXYrcCRQI56pUKOqs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=monCtWUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792001338;
	b=lc5yfoua01L4jDmmYqZLvgsImJ8k2IEFoZzfgajinTkMYN4tAoILIKVaHeW+Db5/G9mP0w
	h4tlaWPMgWhU0qLAPL6M/uvN6K+JbpesbyhcLE7OxSnwcybD7VKFhUZWzB2eV6LIYAO8Ea
	KSCM54S4vLVU1g1mJmIu7t47I6tvCQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21EEE60098;
	Wed, 14 Oct 2026 18:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC421F000C4;
	Wed, 14 Oct 2026 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792001337;
	bh=YJDX7p+COi8qSZ2TAns/+c4C3bCMkstG1AQhV+nfC7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=monCtWUTJM1JJiTY5ehe5iAz7kdm0NJXj6mTFYuhtNHYYqFs6snOCEPtsgac7O5JM
	 eU2EP8c4Qc4cYC/+iTk2K+vuYSNqZ48bMmFXHuSY0hE03eDFhhhvLDe3pnCVvqkHv3
	 Xb299Pvzs05SekBEymV81B+hy8fxlN0S1OjKT+iPpJWjHiPCNwbkNmDCScsGEJ+VW5
	 NRtHtCRlc56Ek4lKzCMxVq2po9Y6NuLPnCixpsVmkzePzWXcUgz4EmMnYV4EbmiaRz
	 PIMXXvg64pVoV2DLt22JcRl6/8ZbICTupKhmxWp+GmVvXhTe42yXmLySdJNo7H3MHI
	 bYTxCfrmecq2g==
Date: Wed, 14 Oct 2026 19:08:55 +0100
From: Harry Yoo <harry@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <as_FLaXgZu01g8zq@thinkstation>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
X-Rspamd-Queue-Id: 96EDA180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 89s9uw7ytjmqbws5jh571bfhscxmo8o6
X-HE-Tag: 1792001338-387578
X-HE-Meta: U2FsdGVkX1/cFnh/iJ3jCft3ETIhmZeL8LvS8XYwomw6m4tKDrYFNOt2f9xhVoCJKYsqHxTtd7SqNx0bCA1Nfi3QfELrJIbCRFAHJFkGdMYKjK1O4Nmst6HK2ucMfwcoWr1ew5/aFUxI9TZ4wwYPMduP146Sdvox+D3JDaz8H4bey1PdseqWE1Q6bc0xEjRaNAOOn9Q6Cpbs7uyMQ+oWVz0NbE2kG0iiB8V9Wgei75PmJqqDPwGdnFu234mMaOwIA6PJZmWP6f9ft0Xalx65jkHnnWgIAndSl8zXJkG65zMPzCTgsOqyb7B+OrMqIYAFXMdRJJYlfNq8nwdCNlotcTR/43OSXR+dq36dMjR6hUaWn0DTlg2shwtTEHgg0A3G/xbWbUrXeFaCGuJlF0IsPy/Fj9OsD6pMdPRf135yFHeNUR641iTt8RjY8+g+btopr+O/iQcWMpdbjglFf8gSFRSPjIT/ysXYX1YiAEzyAHr0iTvuQUFU8JQ2wXETK2XNcv+C2Cs31wQmjGU4hIJxdvqHa24zpFueU/N8UaxUDd8oqVPHQel067LhNYv3PvKjnS+Taw+gdmu24ML+B6hcEiMSLJm/wo/mwpU/jAy5kgTl2yccQS+Iy4U3yeT1UTj2mOV80YGhyHER035qTBxuRUYlO0bq+q+p0iBS0WiAX3hf+Qw5V+Zab+23DVeGlqQfvqJd8Hrtjx8uy292D7vfIqBVwNiXgW989FxB5RfqX/k9Ws+v1KHkgxtFqT+4qO6pZ2md+SoV36O3eUI73DhQqUMHaI44JHi11/UCvoRWoODpIT9XTSFIFLvur55OJDrKNd6r/aXq5gzdLjUIKhBOuBTRIx/vRkvkvXa4GGBRihbdXZABzmejBd0sgnWkBblXfc/GB34AC3Sll2Uel6Sgt6QaZFzopyVV6G5KgcIvJVa+iJPC+HbQqKBEaQL5gb+99FQC0QfjXc8UOT78bth
 AFqtxpmo
 uBNGwDytcfYz77f/Rzob8Q5D7NpBsb9chk0LNt76CR9lRv+2r9T5GjPd+8Hke2ITGfajt2iacp0nXMbkk6FeLTz8uRDaeNuJooveMLFj6xJ1oz181Iv/n6bnMfcvU1awx+nL+tXR4m3uIwD4DdrRZH0uQjEwDMROkXZTSWgLxG8mTTaumNH/B85/3vC6AMj5b6rUBgICv82X2b13a+yWXnbtLDxLkZBGlMPx4Q0kZFdCcB4vwymYbs6+kZ5VHiybm6oGkh8kYD69BIStgyqOPG0NXAyz/6wRYoEmq9kogsRyAks8pkDiLDoWo+LmTLlq6ETLaiiRmvoiW6ezra+TDa//UNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

