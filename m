Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0656CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D308E0010; Wed, 22 Oct 2025 06:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0353D8E0002; Wed, 22 Oct 2025 06:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4A18E0010; Wed, 22 Oct 2025 06:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D71198E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:25:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C4361A0777
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:25:14 +0000 (UTC)
X-FDA: 84025367748.27.8DBA063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 004DAC0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:25:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEvjjIsd;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761128713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXarpYkg02huysi7LuOMkTKKW5xyTewHt2qrTCubVfs=;
	b=J0hWO9IQi8c7e0eQ3xN0sKzRpRpBUl55tTKDLpMZ8QvBitmtEkvLTzuhUcPyYxOSLIFBpg
	GLL+EOdlnUcO1FOgcyJYzcLct+H9maIa3rcaaj4ITXadoMeZNPLPJoJQ+thz3dX9iB2zdC
	ltmJXPeFWXiKKQvBCdGzErqITzrixLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761128713; a=rsa-sha256;
	cv=none;
	b=rTh/TRq5nCLnKTyvz3hO9jxdXLwL+R6hWPtbvvxjadP5+j/I+XOEr7p+btSELI7lUU0MSu
	k2e7Jk5S0GUN3+HbI2eNdH4PfM5sStNRfBDt++f9r0HaCb5RRwsGgHMplmgkzXM0zP2KTz
	vQWt203Ytxf0YuDckvtpZ9JyQqKyK1E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YEvjjIsd;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F33684375F;
	Wed, 22 Oct 2025 10:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECEC4CEE7;
	Wed, 22 Oct 2025 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761128711;
	bh=stbg9Z4GKktvhVbBWBaKTlXQZOrVQklo2RFMw2PVpgc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YEvjjIsdeQS+VXWfT62+1y6ZmLHQhBQdO5DzyWVgc/cNGTUnFYLgt7W0n49KP3x0I
	 2qnGRwrRfk8gzhpj6CpJaByqIkuiO4f5E5bie1iequdnJvG6CtJlhk0h+NrqEyKJ+M
	 aR84lskvYfWgFFArVhkhTFgmbo23eeMRV+feqgwkTaOyJuQmqK6HtBVupdmNG3ZAET
	 gi3+NqBHS6maLsdRH8d5jI8rglQ6sRQ+htHYMUSRoYP64KJ05EZSniF1vSbHIqmde8
	 M3EfvChB9r7SD6Ef3E+wnOYZOHDvvVu4xLs5mF2ZLndwj3DISKfdwXsH/CzJXrpwxe
	 dIxmE0xi3Oa4A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  jasonmiu@google.com,  dmatlack@google.com,  skhawaja@google.com
Subject: Re: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size
 to PAGE_SIZE
In-Reply-To: <20251021000852.2924827-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 20 Oct 2025 20:08:51 -0400")
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<20251021000852.2924827-3-pasha.tatashin@soleen.com>
Date: Wed, 22 Oct 2025 12:25:08 +0200
Message-ID: <mafs0qzuvfd2z.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Stat-Signature: rb8u8gk41m6j9r9azkj4qjwk4qaymecp
X-Rspam-User: 
X-Rspamd-Queue-Id: 004DAC0012
X-HE-Tag: 1761128712-660971
X-HE-Meta: U2FsdGVkX1/Aux05CrX4A4Q91dyhLhFX4zs3kj8iJq203ONaCmBpoRXu0h198Cj5GwvOSn/MrnD1a8R9/236HawRne1J9cZHXekSiAyUUBacZ9N9hfLLFXJFTu+7PETxF00csjCaRVwsXMN1GBcf3tqMI1T/ylDT5PizFVogGol6EmqX4S0s0Tao4THlTYpymT9yoADNcy1V7pXvk0dw7OZK8HJmeG5asGRTYyzD0nniYlyRP2hyCXJtu5shKyIReWHo86s1702ufEn7WZNDDi+MbFgpryCanwaeKUUZZP7uK/PZqa75RXRrxBpMghLCmfqPmPHVkht5Rs/xT2tjlsjT7+qlMKeC7qpgyiz4JHwjA3vdbCmg5uS52lTQkOocRNxZ1kGridQ7o5Qi5EhQJbOaHNGaEEsQW4VZURHKAdqwEs148+aDcChPKmxsM/DGO1NvUnCPfyWXMtHf7AYqwD0NkIsZtNaBUqjW0HD8Me1L5BSE+NFNf1dUBVyfNo8+qgEJ4gMujH/8R5AqZh93GwoLNuirSyLaCeuDgFadjleq1b0cgDbIhDqteu12eRwQyUyZ9/IG/YcNhsNIPcILR+lNiTY5pRfzFJZ3OIEXTSGMdAXIZ3V3/e6CNsEETKP8RjsQyAFcPoZAkMWR+1XK4+W2Z6LQbQJN5UgcsEGvIMq8F8E50MNc9XNKudm98I7kxt2GUCnyipWq5Jt6I0lSpePfkAfTdJunrLZ8UGhlrRZcYqtYwqFp/SIt9kXw9p7j7IfTdxWMUCjfy0qsz8MHC504aZCI9byqTgbhXyA9XR99o/ptD3XP3v156/WWMuaMQa8bSfC+jAp0pGpCrf/1Rb/0vYwxjFCWexUnbyX6MW3Q0ZT0UmI1InBoGrvSPC+zOv/6+PrqHYu4L+NtDT14jja04zhYalnlXXK7Y7M+YQ8TiQJAHJr40aZ5/f5yWGTESY6rhPOPRBAfyZoFfVC
 HuShBZqn
 W+sZiVE+umPVkxMuzHqU1aV88BI5zFXzOuPDXsx08BKP3IHwhScJnXTrExbq9pjELy6gswtCw2goNvukhQ0AhO73CNqv5AQLp9Tbthifk48QXqSYkF2Lsmdx5811DIE00nYciJg6ux+ECyf6p36bA7QX2n0nmgD9Jvn441++wIC+0nKQsM/EGViw+ImbzjVQLjJNQBBmWZ06tyGjrG2wEvMIzpuhW3K1s1Mr/5cRtyNCn9+iuDpKwHldfXp+LPc00Fe6PfygYJV/xS5g+DY09WT45G3+WxwRRvP5aA2BHGEr6Pco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20 2025, Pasha Tatashin wrote:

> KHO memory preservation metadata is preserved in 512 byte chunks which
> requires their allocation from slab allocator. Slabs are not safe to be
> used with KHO because of kfence, and because partial slabs may lead
> leaks to the next kernel. Change the size to be PAGE_SIZE.
>
> The kfence specifically may cause memory corruption, where it randomly
> provides slab objects that can be within the scratch area. The reason
> for that is that kfence allocates its objects prior to KHO scratch is
> marked as CMA region.
>
> While this change could potentially increase metadata overhead on
> systems with sparsely preserved memory, this is being mitigated by
> ongoing work to reduce sparseness during preservation via 1G guest
> pages. Furthermore, this change aligns with future work on a stateless
> KHO, which will also use page-sized bitmaps for its radix tree metadata.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

