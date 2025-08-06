Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78292C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05E56B0093; Wed,  6 Aug 2025 11:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6706B0095; Wed,  6 Aug 2025 11:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5596B0096; Wed,  6 Aug 2025 11:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F9E6B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:03:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7758514064F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:03:23 +0000 (UTC)
X-FDA: 83746651086.06.23FEAC3
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E67510000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:03:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WogelTFH;
	spf=pass (imf05.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754492601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFu0pWsfcILZb8LZ/l3Tb7SolyPesNFvt5mBj5bdVrg=;
	b=06YZ0wDQU+gxoMEhNcT3SAvlHf6JLY1fYgavEkkYPKUIU+d/1fiAvfDMO792/Jtgg2SWU8
	hiL9tJzuXDfN2ATJI/OagfxAF6qEXg/dKMP3PdDZCjib8CIyrKhPOzvY2STu/SFQFE6g3K
	/U9w+Hc7/kQ7tsi3/Ue7BzCFg9857rg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754492601; a=rsa-sha256;
	cv=none;
	b=7eq0e6/TwK8uknbQsV6qiSnJXwstkbWfgTzYYoTQsv8OnNdPYqDW4QD7801OoQuKzlHQSd
	NO8snf+u/AU5A0jjAaEM6WXs/NQRfDLUVdr3N1zQUQowSIIPpGyCio8rQHGODdt4c7gWxZ
	ionE8cKLBVugRK9nmV9ab3B7juIwJk8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WogelTFH;
	spf=pass (imf05.hostedemail.com: domain of ujwal.kundur@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ujwal.kundur@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-615460d9897so8075045a12.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754492600; x=1755097400; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iFu0pWsfcILZb8LZ/l3Tb7SolyPesNFvt5mBj5bdVrg=;
        b=WogelTFHdItQqQJlY32wZ38ZY2/wlOkMkRUCaX06AKJL5t8LAMu0cn8mxZDzNRe/8V
         Bx9GAeI7WPYHOTSJh6uLHLI8MqRa+zSV9MRR48WnPDg8lFAPEahJ5EXZpAy1dzBYGe3a
         tw/j4qqXNMuzpYM/7PyTU8ElBlWs64gK6s1q3HyMMtjwq2zQSGeYjeRZJMBW53Uz51Oi
         Wqa1F2+OpaLTrJwKNljQqZnIM13jif1Nmnx4pLVEeJ2fD5R7LH+tNeqscsL11poC8Ybi
         GZSuULlq8ozJrtMVk+Ww6y8xfdFTyzS1cTtdqSdXKxpO3fTkp4HgWs5vNMJzZZBtrO8P
         xPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754492600; x=1755097400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iFu0pWsfcILZb8LZ/l3Tb7SolyPesNFvt5mBj5bdVrg=;
        b=iQDt0t02McoZsfPYBFjGrzryoO+C817h/mh7uq4i63W2YH9GZzmgWuNXrSKdR0fkhN
         1d+oznEhzPg/qN3MCBtWX3WaEzEG49bgDylHUEbc2XWq8OrQP3edsV2vcSMuVDreEbjh
         iq8WzLCqPb04BUz2boszH2isqbeee0DXQNTw9HOM8+V2kNhcI9P0W+LSWabFkON+V3x+
         FwvOWE0elAXwE8HgaTaYjc1T+zzCo72a18Jbwa4C6KMxSo15YvCxDReCqSKGh1GBTjm7
         HtvTaA4DfvYGE4I6JoccA0Mzds6deFGM46//3Q1uFTt8iGk9Sm+oosxPuyuOJ9gvkSEa
         k9Sw==
X-Forwarded-Encrypted: i=1; AJvYcCX3cziK+zaHB4O7q3UVEkT9h+gTpJefz+u/S3MZAZaGYVPcpCaFrnEdrXcnnqZxcSLEBgdHgRZSkA==@kvack.org
X-Gm-Message-State: AOJu0YwWKWGl4pJ0APbogg06NDbfbKOQ9w0Zpcnh8C0bdGrZ+fcv13SB
	yDjjM6o9erXVJ2HXNOCRpjGSoFz7sURWji2+6hWBDBZUuXrsrL4OLx+g6HUvlYxpUwkSpC+rmnK
	wHd4z4ijml49oYiJtbmY9H6CIhphCbQ==
X-Gm-Gg: ASbGncuvMne6ikipN8829kACQHaiDxTW61OnOSb4MfEPCHtsZgzjnLmgGi5zhWYdyO8
	T3EtMVuosMXFa0c6QSwRyOamvrnLEQkt21hMG4aTqxz1TcsItuzWAXly3UvYpl3St5DA3jlhtc9
	uYRCoLEO0RITg7+rNGYonmATcjnvE5sM+Olkld/dyAq2QAAuhIFi7fQyD8Khi6iHjdRnbSMLcVW
	fFT+tO3
X-Google-Smtp-Source: AGHT+IEZYVBGGdm7ifa/677lkbqiMDvUOGxIoRGGZKM7VIEDoaDXaXHDOKNKwB3i6BTpzO0ipF/19F6/rdK3/B66Aac=
X-Received: by 2002:a17:907:1c0c:b0:af9:61b1:e180 with SMTP id
 a640c23a62f3a-af99042fb75mr332188266b.41.1754492599426; Wed, 06 Aug 2025
 08:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250501163827.2598-1-ujwal.kundur@gmail.com> <20250702152057.4067-1-ujwal.kundur@gmail.com>
 <aGf_W_ZgIf63dmAz@x1.local> <CALkFLLJua-LeS+S5GpiXORA-3wNSR0DTzbh2bvU=Vg-Uzd2VFA@mail.gmail.com>
In-Reply-To: <CALkFLLJua-LeS+S5GpiXORA-3wNSR0DTzbh2bvU=Vg-Uzd2VFA@mail.gmail.com>
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Date: Wed, 6 Aug 2025 20:33:06 +0530
X-Gm-Features: Ac12FXyBN9EIPVNc1w1eJK7DrGiyYTVGlwIjmM8qS18Y2yez0bBv1aehsTuPYTs
Message-ID: <CALkFLLLoXfTNtigbcyD4RdJfY+b5Rh5-5Zta1QM9dBQxZd19cQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] selftests/mm/uffd: Refactor non-composite global
 vars into struct
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, jackmanb@google.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6E67510000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bmw5ijtujm8c7nqr7w3i9omznw89wu7g
X-HE-Tag: 1754492601-676271
X-HE-Meta: U2FsdGVkX1+BgfZbWqWwv1xM9oYKZVEbTBHI6SbKl500iW7bAJ/gI40GcgeO0ZwUJn+5Kd96VhxstQK/x+L0nW+qNaRVxqUP1KbuaXSoB5AQaBt8GfjRkLOCdvKtIJJtvoGcQF8PuxtBRuDPO7vMKjuJNydUPg38UsmwVoKS2XpmoaNcmEJ/8MvNd1BxB+vk/RyWgvLdwNfIUXVCqSLe/cweVOmXEuLSWff+nC+KWIWqMgkIvfUxV6kgvL3HTKjIBucE7e9OnV7eLuY+biK2Iyx+SCJj45D1hXu/dNsMMIT9s/DRRoLkCcZWkSHToawJdw/4Tn0+EShagzsxY/BR+clGfRUA5wbgrbbgID+3RQXRNafqkoQmOa2x97di8Pva0APYtP6Y6CsetkYFTbBs7zl9OkB5iftX6vMULWPSQhTbVbR04/phD8Q3XZ8B4YbKyXulsX3jbN9GYaN/BmR63+7MfxFSJlBBBreQb/tB4WsRvBUsGnYRdjJdesOB/lCjs2mQhxu5nVR1MZzYyjAYJbrpgJ48JZB8RtvJ2oXw192+wWnTW5lAHYoRRD6uB8TkNadxfF8KhXIeCtFmGa8k46/OX01ROfamlOoAE7qF8IS7gZZO7YQf8kVxrhSUtS4drl1fYxN6QFuBJQ33nMyYr+89TR/4HXROMCaS7ZUUggRp9DEzDVW7fgwAQWIyN5AYrGluVGRuxjtapZYiYSt5y65LGaKmf8j4x2M0pb7KCu8EshMAbiwPCi6wMqmn0K+MpRLstcMLtr19nr5XRw7YbNjcEBiWclV8fIscucOmbonfTCZ1YOR4xV9mS6W1vBr/5RO1bAEwrVzrH3rG83z7JZK/S+SPyruHN0rlXGfjWx34WRSSxwYORr9dLeaa1BuI7pOMFVbmuL3yH/j8VekWuP8gFXjTq3HQOlZwi49PqAXXFSBnCXAOQvRsyh5PGCtGqT2U+Q4Y2l2oQ18P1PS
 VCa2B9ee
 JAu0MO5GRTBDr/1JEWJ7I5siTiXHDzh5riJ2jyMbCMjV4EUOtF3E+bby2C2G9CfgP5CEBLJCpUd3mL5Kg7O7latJWFsdHXOECMiSnwf5GNkfmcTtwzyL3pHZSdbd1Tg9OoYi6T6tlt6hE2K5leRxRNe0UgJ3QREa8NSRYhDyjc3W03AXzdeI8Qo/QFILXnlem08B9zRJ6ImNGgMBkiKohEXVd4/LvEPcrChbjs2ch8wKHQZMbab683toe4sv6+geBgEFSbT/FBq3HGOTqbOHn9vQBORIToC2gq6HOp6KuB9yCW5eArGVwdExAmnaunBAY6HDcHSK0DoYIP8IRzemm+SQZgSjhfbQm8OKpf4JQCkaZper8UUfCDUV1LwGX4YJU3Wrx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ping -- please let me know if there's anything else I must address.
I've ensured v6 still applies on mm-new.

Thanks,
Ujwal

