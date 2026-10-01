Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9D36CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2AE6B008C; Thu,  1 Oct 2026 07:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CABA6B0092; Thu,  1 Oct 2026 07:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9EF6B0093; Thu,  1 Oct 2026 07:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5668A6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:55:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C251380385
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:55:06 +0000 (UTC)
X-FDA: 85273901412.17.7810E5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1EBE740007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:55:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVCBDOK3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790855705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUAi0n/sFGjsoDFX+Uxvih/avWET3Jejf0xqGsJw/4Q=;
	b=j8vKABHvuwBmXxpVodH/qPtnLGi26qUSn5El0b7oh4VxgzTleWRn3PzoIFat+w0NA93ota
	SaAkKcXTZMFg68W7CoGx/M6mXyoe5fZE/s2VduyNt97W83ZH+anuiIByKBjr9ANuqC7V1V
	RMIBLB/lT7nPtJbdycNmWzljpQny5uA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZVCBDOK3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790855705;
	b=2k2AwqKXNoNd353rp2BElV67ZS72Y0lqfpF4WiG4GG2Nz2Iq5B1VoJvdhvHIfdRaWncJpK
	z0fcyyV/IctfNEZc2wYo3pmWuYNrgBqsgoVCE/6nb/YJz6860WMo3OKNwkpKM4dlHn51+i
	9CCtk+6Er30t57x9zZH2CYbt5U+Op9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA101601E4;
	Thu,  1 Oct 2026 11:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A8F1F000FF;
	Thu,  1 Oct 2026 11:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855704;
	bh=rUAi0n/sFGjsoDFX+Uxvih/avWET3Jejf0xqGsJw/4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZVCBDOK31CqNfjz8WrdjvxSo7vEkXTFpiZNcf6y2UpSuuhsETtZ6iSyUnN0Gx66lr
	 x3T9K4HC3f4TiqTrL6O/LZb5j7aZlgSTaHsP32QDSqLQOyKqnknKrFPKuDxBwkVpzv
	 x6GTQIMKL92VV2q90LTf2vCbBycVTzflHONMLZ0BjXCm6ZoxRNvqvpNkkW6g8/HtFk
	 6J/P6DqYgUfZ2gZi4BaajiuFKIn6Bh4nzHfw7qDnA4SyqsR8FJUFioNY2PuTopauaD
	 dfq7h5EZXgL8fjYirKGwheX3F2MF11zeIfcepTgLYif0WNhGE1MWNVIoduUU7z5t6G
	 gse+9UCLeKQOw==
Message-ID: <66643a71-efcd-4bfb-98e9-2e71766e0357@kernel.org>
Date: Thu, 1 Oct 2026 13:54:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 5/9] selftests/mm: mremap_test: fail on data
 corruption
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-6-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-6-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1EBE740007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7xw4kwc56cfqb7x34m8td8z53khuxyww
X-HE-Tag: 1790855704-785714
X-HE-Meta: U2FsdGVkX1+unIUA5w69O4LY4ThUPti6p325x1cP0zkvn7vfQlPSvgT++TCb6eb8KH7ezRQbTSChbPhKX1jiH+bx+gb61kCsgQtjNJjmxDc4Q7Bm5R/NzbTLXw0NtTLan61y4pmpzVuirOzcXlgXbZRSm0lDv5MaIr/pS2bDGLhje37zMmFYWpbJ87kJZ30HUR9pqxUw0NMBr/d8QjgnaP5q6gzbxS7crpfgX+QN6vzw7IJfs2o2mUWQDR5ZznbwvKtwqRmac8CDoTphpmBfRVisOhwDgt+AkVDPjVB7co+EgiHRVPJI4QTGaaej/Kugq5KjSwqDTkHP7rVorHfCIRnTK7emj/4pu2R6O+B25KrJ2Ot+sf8Lo7n89QFO6aNQ+w7xQhRc7jVTTUag+HXGqG6hRb1qQPxy48Ibzr2EHDllM5gnGWtEleoNL1AgLxhPvcXxEH1XmQlaosgVW97skslISn3OGwKAXaFP4xHXxJD6c5/FVLEMXv+Ej1Snf2Q2aYZyemC90yTzAmRsRsS5Ub3JpqnjLeJml4cZpP+CNYyjcKD6u5h21IP9uEhIHGYIaQ+K8gQ6GVX+bDd28dU8STTsuiovf9oyp+O0/tMWgyPsGc461T/g9vIkG9R1dPaIQcBOBkFJoynZor9w4MXs5Dh5uHSls4yvLA1NvLKEiMHjA/USaGAqfGJAh6hAVQVNqVen/QRkXMu1SnNyzw0EXhHfF/maeO0/LTcyYQ7uDoye6Cmn243yKUHrpPbyVxpU+HZUiT35UTGrmUT3Exrk6tVsFN8p3c1Mj+DNjSoKil3x+Qy+JiLC1ONJGAF1uzXuA6AlncOfN4RASUTU99LtxBbNtpvwbA/HcbHO56QiYJJ9miT8wxOp6zWu0xnutCkKY7oivlLq/rcC7EqOWdfPWEQAimqHHZqatY+i30wRukylxq89uXhc6u7Dksd6hodlGALPv7E8BOIyM2x5O+Z
 HrmKtPEj
 onMAagU/gHhbcgGsCGAY64pY/En/YRgWfnYwzD6i0grUxQfaJoZfIyR+GPx6NUnXzSlAJEPOz0vnYra8DU7OxRqQ3njT4UGAX6BUN/WvppVWnw/jK3mAjSAK7E1OU0EeLxTUFqhXDp/kDD0lAZmx+5tZRJvzTFO+GsqcBY8TEgsfspXxFGrRtuZA/7geVH/8tPkgZTyA1F3JRr5vTi8wqbnBgAAswLRfWWh8fTMnYjP/uJ40bd7dyWyUkfJ3TJg0gvBfXgQt2hgkiSnjbTt4HYwEBdt5xilzTDZYp7qSda5Z7KFFdsCGAY0muh5dZnnVd38I0MpcQQI7Q3vTrPZEYYqKX45GXhHLKfFuhU0d77Ptaoub5mqoJHOg6+raGoLPvUpaNEfqZPTox5xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> In mremap_move_multiple_vmas_split(), if data is corrupted
> after mremap, the control jumps to cleanup without marking
> the test as failed.
> 
> Set success to false before moving to cleanup.
> 
> Fixes: 7d6597dfef11 ("tools/testing/selftests: explicitly test split multi VMA mremap move")
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

