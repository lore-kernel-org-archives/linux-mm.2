Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 922A6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08158E001B; Tue, 21 Oct 2025 11:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0008E0002; Tue, 21 Oct 2025 11:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEB38E001B; Tue, 21 Oct 2025 11:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC79D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:37:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8719A11A888
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:37:55 +0000 (UTC)
X-FDA: 84022526910.01.17100F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3710A40018
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:37:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHn9QZNA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061073; a=rsa-sha256;
	cv=none;
	b=JhXWkkZIwq7uzB+Ltwlr0pjYbwPRNSPgcOZT15Nz9gH8IjGcLqREG3Jdp/r1W17ZI3F6aM
	bXdqydkwChTmgC5duu10dsYhMPjSMyvTEx2nJrlYA87Koz6losaxqJrxxYyAocMUadTFuq
	07idezAoDttOOHiQKvPCSJxwcP+VAZ8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHn9QZNA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/7c5A5jjBJdHFU5IeWULrzoKt5LxZ5pQlNBoEOn3xM=;
	b=Gax99nuyKLEJ16zxvBJrpiYy92/Em2fwG5qBf2z1sPaR0eR02xW2Czm49qo46LoElT3Hj0
	SOvlwXD0zSBrOM7S5lKYrBLgKkhAchGXBlZbUIcrYsYW5ZxJEUItafgAlns4s5SAPIIVnJ
	VP1vQ3j5xM/dDUUja2Nj4hA9Lg1JJeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761061072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E/7c5A5jjBJdHFU5IeWULrzoKt5LxZ5pQlNBoEOn3xM=;
	b=MHn9QZNAYF1pyXm5ov60r9gLdAhWTAc4/LoLaIVsIyF6V/dTp1Sz2DR2gwYEpQlkHqhrJF
	GZsdvxwfnwDil3fR2NCz0YCHlor5yLsXgf3LDZa9DQJ85UbypzFRnLrun/cjW8VHeL3gcR
	Cs8OyKOTJwjyLZcNHpaVMPmtnKZTteM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-ZDnCBfRpNOyYdJ__J4ALrA-1; Tue, 21 Oct 2025 11:37:51 -0400
X-MC-Unique: ZDnCBfRpNOyYdJ__J4ALrA-1
X-Mimecast-MFC-AGG-ID: ZDnCBfRpNOyYdJ__J4ALrA_1761061070
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so2991965f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061070; x=1761665870;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E/7c5A5jjBJdHFU5IeWULrzoKt5LxZ5pQlNBoEOn3xM=;
        b=uTVb/J/USjDEz9SqxFt3NwlyrHlaQWgOMILcULc0jupRInjAa57n2dgKq7dBfDj0J0
         EzZ86tUAJDvcQP5xA7YFVH5+nkZh8aKUTgqw7CwlS/ixKV5Xu9I6s2Phy3ruHgA+t7U9
         NUb/3iKKcDFZ1FYMdMQfddiovcRs/DTtzw6ORDxmYtz+p5siVf6dBDSUwyHTe/u0AHvP
         YyueYyngE3OwzaDwNlNxC5p/9v9H3xwhfXUzby9p4MR9bzKCgI7DXfKhbRu2N8MbDfI7
         TFWLOoA3oHJ9oWinc1os+u6LCG2UkaPvPzzMxiPC9XezY6/iipuGfMvZ0qLvC9KkQeSM
         0eTw==
X-Forwarded-Encrypted: i=1; AJvYcCX56qmCh16ogEmiYcBOdlYrG9ZWUs4VeL0uidWTSDzIQGg+UCxhgywm9tUd8Kk2TZ/cTj112Zy0GA==@kvack.org
X-Gm-Message-State: AOJu0YwnwGFkMUurDC13qow5xENkN/FNTZHL/gS1XJHIWcTCuLvZ4I+r
	I3kmElBIP7i9p1eXtcUNDfBzbk9wKPUGQb3zFTNJC2CbRRgbXl3Ta7Is17j4Qgnuz02PiHTGH5t
	AYCqohc4e2q5z6OHmP1lq6AlW9mkPo27ylG04IgEzGU3CRxGw79HfwrGhROE3
X-Gm-Gg: ASbGncuFeZxJ9fkb9AzCtZDH9pZHJ1i+KPPeD9AgAHs1X1iC/TOumUXWdNk2jMR6KHw
	qZKDFHPQY9gT27JCoQvYOuU63ckhk8yGGOMMzuI5hDJ5RNeKHCX452txjnDQv1RYHHGrB5jDoHo
	Oujh7c1e81FhWw3ZdiltgA3yNOSGWr26eJm6kWbH77MOU0IR9caspc9kK6m9aKTE3nZlpWc3Tix
	5QkesIivy5/tNZfg55l6Nh1JKX5QZpWs0mzMhpQZOZH82mecjdPfFYcxU4Yf/t7gd/GdqxQBm9f
	5w6E0JyXKGvU3VFIM4s1pvcYuqsDJJvzCo47afJ2ISoceSreM98vAzYHT9RMUvlvOvnhsdZYTJk
	tVQp1NbhRVnJyjo8lf+3hknfGCS2EEBprSDLlY1rhMpzKCbPHq5WNnWDAJpgof0Hnj0iAygDiEg
	6Jo6H0SEihq60E/sdO8CMuAiOEWQ0=
X-Received: by 2002:a05:6000:2dc7:b0:428:4354:aa36 with SMTP id ffacd0b85a97d-4284354abd1mr6785966f8f.58.1761061069822;
        Tue, 21 Oct 2025 08:37:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV8Htnc2zerYOltHWq7nqPdBH+VgpCEEL3l5nIU7iiXfnT5bpNfFWhrGmLn4T4UZuxhmt8jQ==
X-Received: by 2002:a05:6000:2dc7:b0:428:4354:aa36 with SMTP id ffacd0b85a97d-4284354abd1mr6785942f8f.58.1761061069356;
        Tue, 21 Oct 2025 08:37:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a6c5sm21478704f8f.28.2025.10.21.08.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:37:48 -0700 (PDT)
Message-ID: <79f01115-3c9e-4316-92d5-bd050eeb3b76@redhat.com>
Date: Tue, 21 Oct 2025 17:37:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 14/23] mm/balloon_compaction: move internal helpers to
 memory_compaction.c
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-15-david@redhat.com>
 <C2893E27-CA03-4416-9444-62929A740691@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <C2893E27-CA03-4416-9444-62929A740691@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xpejHsBIieDmDSkmiqKsJV_bQs34Zjt0Rss0nbZkGws_1761061070
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ew8xz4mg6yigxxechikz4osa93jgdssn
X-Rspamd-Queue-Id: 3710A40018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761061072-654571
X-HE-Meta: U2FsdGVkX19/iv3E7u8vuJbDzEBLUqWOtL6gYljTWSarNfbpitxfxK4R4mLgI1euKOVaRolzLFb7U6Q6zVyoC3uaoKrCfd52RebPDB5tLyCRy/Wt8FAaMqqdPMhHCJ0mLpYCPz5HggMBngyRFLw1XnVzZDML8rsJRgquaPHqY436GH9w3hkZAkVu4vnXknSjdopHqiVyQxVyqvZDpNYFshuk9dV+Ll2uXSLSxsDs4vQDp107rdr0P4uzxYOrHhKuqvLsnw3B73Ncr2pyORts0vLIAlD2oREIZdOj9fpjuXez/ql8AvTE3s0YXqTC3cY9Bp2gf3kE0GF5OIB7v9XJue/Q5If3j7kcubrTcY2pRR1dTmbfIohfMUg5hH6pxWNW/HFZCOeJ3ehyf9ZnnwEXulWVufK3fplB8ajVCxx6ioleh2MGsWYPom9H+Zld5fqrclUtNqXvM/IGgzlh7q2r5yBbDwGnI/lHZqe+tYajzOc2rOlgq7+I/GZK1qIINmd6JjM1Luvb6rD02r1QQ1pdpCwPes3BvkA8Q4Zb80aXBL8IuzzblJthTv2cKj2RDXzchpU4jL/O0TK5r5WstQUv/Exnz9UNhOMW8y5sxMyefZ6TyUPISPkTqTLJFY0kJ6jnWg7HJ3C3pr4vjQ9mwx3APkbBr7wozvsabicqgRCwH7Y1CHn32ZQjUHR+euvDfPAFnJqBXUtBPSfCV/tMD2yxlAkzsPymMqKFLmZEQmVqd9Q9Hiy+UwbbbIA1rKsRnfhGm7rd5/N4Qv1jbPHk/frjPGqBa5K6IAlGldZ+dyTK9eGMgiHSceTlgJMuoKEGPGYJggW5WNnYSwMrIpk6h93a9/9dI+FD3fisOynp6VLsSRQxX5DtVw/obIwxxmdk6Dsz/CCFOAdFw000Pg4v4bwviuMEP9WIND6zNJCQgktahNopE5H0/aK5Sh9u0uG2/9svL6r9M4WCKBZvaXZTq5j
 +SbW4Yo/
 d8nBo07LY9NB4Kf3hAFbf1YX0qYNp0rfnsyAzCAHUemPQld//phz5IaYYJQbYq67jRUsp8m1VGXu8Q0ohdLSENrn4qISjY05YXzt2S4dg+WgijWHZP9iCMsbV8q/DDu/+e1lXOfqvx4chplK3s2dMG7D/MM+pW9dovaDqiRwfZvUgbeyhUc3jBnJR1EvSQsV3VE4KGZ7jQJbBbU2JqyWzXaGD80RUPu3uks9CWA2dpiKrfdBNk+ckN5s7heFbXsuo2Ce5Fii0139afb5uvkAtEUvgwF3qMuAlKLfsUrmjWnYmsDSGuxqPGw3ahMK1SX3VnXPHgetLxAVaqcQrxeUHBcyh4D0FMheDUFF6e3oWmopKIPbgeUYt0IVM7PSoN3m8L9h+Pa9Qs9UIwaeLgaPOd/1huZQQPe0mzW7h2lcT0j4j1jeapxHvp+8f2QBu5QviMlsweDLR+hEeOngwNvLvQGM5wQyNMWR6+BbHqsiixNyWdu61mzqq8DAJ8iehtwxTb7qLP4lssvLBve481Z5stmOZibYUBY/5zVdML+cWHr+GGeIPZHIzf3lvaSq6DYZXN1N+ofT/LJ6Mq7aysr+/sfPjAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 17:36, Zi Yan wrote:
> On 21 Oct 2025, at 8:59, David Hildenbrand wrote:
> 
>> Let's move the helpers that are not required by drivers anymore.
>>
>> While at it, drop the doc of balloon_page_device() as it is trivial.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/balloon_compaction.h | 44 ------------------------------
>>   mm/balloon_compaction.c            | 38 ++++++++++++++++++++++++++
>>   2 files changed, 38 insertions(+), 44 deletions(-)
>>
> 
> In the email subject, s/memory_compaction/balloon_compaction/

Indeed, thanks!

-- 
Cheers

David / dhildenb


