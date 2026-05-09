Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A82CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981F86B02DB; Fri,  8 May 2026 21:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933826B02DD; Fri,  8 May 2026 21:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848496B02DE; Fri,  8 May 2026 21:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 721B06B02DB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:12:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20ED11C03E5
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:12:42 +0000 (UTC)
X-FDA: 84746106564.18.F20A0B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 732288000A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:12:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4vmlxFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778289160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXRgxZuqldin+coq8E4lCs88Ya8eYjAEL4mzQnpBaeg=;
	b=0xPEzuTgvDRbRPV1T04fHLut1mfH4xL4rdUvIFSIrphAz4raEutq4cPQM7ef9E/sald4W6
	BG5HqDIFporDqFfXPnh3zy2Bd+XDlA3lH8tCrQzjfW+H3zNnbYWMwsgy/t8nM6REOLne9h
	iH19YWMsYbpraxBBw76hSpVcBuxi/74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778289160; a=rsa-sha256;
	cv=none;
	b=mn0OSr/KEechrEXbTbroOl7k4dN9/6V+hdiD0sd8CCeakmhTCIevb0fVc5Rz5fEdoMwlbn
	u/WJPT8lLFZTfduYyzfwOHsQyd+NjwIT30cutmUT+jguIZEzuriHSONTPzz95Oad3ap+bH
	0m5gE1s6/v749cTaEj7JIRa3EWwCRm4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4vmlxFM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F4DD406B4;
	Sat,  9 May 2026 01:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC431C2BCB0;
	Sat,  9 May 2026 01:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778289159;
	bh=kw3a93BK6oGJYyqPf/v69k/u6NWHBp/FJ/7E2klmPyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4vmlxFMDAcY359r7++wlYWGtA8bNsPmHvG9pE0x7YHmdY3r9A80WJjWGgptbkqFi
	 GVr/frk30wLS5wz7D9/eF7q4LiqFCxstBkavqYCz9FwshKLfQWATLMA9qhQPOlHp6x
	 Y9wDRdDY+a2ArUsaU8lm7WX5ENX5pWSgewNpOpB+gylOytW2dahNiRfa1nOmXbNJtV
	 wCI7ibC39BTXM2wvj0Bn82bMeDRiKKYd/AMO+h2s4VhI2L8NeHZcqWWPDPJ9uKcS1X
	 kmV59+JLVIM+8h5IEC+2onnjD57Z/HC9VqyiXqVYWTTzUVwkQ4Qgv9tP/cqE4QAQtA
	 gdJKj3oMMP9xw==
From: SeongJae Park <sj@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mseal: use min/max in mseal_apply
Date: Fri,  8 May 2026 18:12:34 -0700
Message-ID: <20260509011235.84970-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260503115915.18680-3-thorsten.blum@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 732288000A
X-Stat-Signature: 1iwpi9xfbkb7k6a6t44zqm968xit617u
X-Rspam-User: 
X-HE-Tag: 1778289160-628540
X-HE-Meta: U2FsdGVkX1904drZKD/She/MCjYNsVFDKwwPMpuN6nx2x01iK11RuCjc9liWJrsDnVs68ZJ/UL6NR2ftA+JjcNjWgTycIy6N9UVXbsfDA4umoW1JEDnte92gcxp8OjAJaRUxi8+lu1/Jvt9GPjzkcsvjt5mjvynVpm5cw2Q2DeDYtjzviWf5aDaNb0DHYgs8UmhwnsCxWgvmBXq+gUo1o9+AjcWBXc6mviK6t6c3KgqpGMnMuQenLyQ3qlyZpbNWJ3w8C8y1JzHOTqSH08BpCRol2XiQlG56gfTFkeYibsTZmvEYZLsiPMV03F/CxWtIpxAI8NgrRCpTiwegtQb1ZGy29zasns8CVSAPje8W/+6bdKm6kOONIMOZpPIYMsktWglxJdVcQ7jWPy/6bwTzNFPAB9Osm4mdPKHBZp45Nah7t489GQ1FlgzqWjhn3TZFQTPQ19Z0Qdmr75glLziY8MhJbjWJop3US1GN34swwiDQnm2zh9S3vXCrV3qiIKX6Z65KlSRTpcZTw6rHFRq64zITH9R0qv0/zehDp6bGDka5AbormIwSD19qw44Z5r/DEzIW7Zd9e4MmIaYVrDpx/oJpP1QYsrIgMbUUwH79qFaitGjFLVF+bpigIOWJ4LbANNuXGxovgKB8GQAQSbPpEZ88LdaWkOeSkXqzvx6gRTUJZdwlH+URy3SFHhTLhcKdA/kbxj4Y7K49xw5TQJlS9dzHY1sQ7V/zTokMNTBuJvE6JbeKv9GTXQVRaCgbjU8WaGSc3YFpyq9n1n4DJfbpQkipXJ9ZJIsw0NXpmZQgoTJr+nS9U7ElLtuSmEl89tXffqkoZWqL0eKDjxigw2NOsSoNjQyZZ8460c7a10hZMg0FMHtTkXk5ufFIRFOg5AvJwEKOD/c4NQIOni7JY951qXNmv8+eiD97dIaJ2rW6uzpuULcRhZTL1rODld05Ph7wBZgxmgnTz5fFvrMOs7I
 DEprur2Q
 OgubEujcUE4o0d8+qqe3oO2yEj9pnYjp3/n0EkeaaTZjmUMj4llQyn9ZuUc4R4eGXKDTyWD+0iihhx3BNw01hLSfUhXplKccBQ+VAipYmd+AqpmYKHlJk2lodnLNRBr0tqmvLEDJTKVg4vozXwmJ5B6LhKXeZB6OOvu6AeN1b8rxqowRSvmYtG0RnwdQwEM/uPxnjdq5tYAqDFBljm/Etvlg352zAtPE5nSsyoi5RyeVR25qhSAfHVtcLtu2Qw9lFggPWzRy648tu7WUEqsLHMNdxYUw797vaYi84SIHdl/HJ5HLswvrOkcaURuAbpLHm7PtR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  3 May 2026 13:59:16 +0200 Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Use the type-checked min()/max() macros instead of MIN()/MAX(), which
> are supposed to be used "for obvious constants only".
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

