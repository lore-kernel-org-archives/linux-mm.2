Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A614CCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 19:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CF08E0068; Mon, 25 Aug 2025 15:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CE48E0038; Mon, 25 Aug 2025 15:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9154D8E0068; Mon, 25 Aug 2025 15:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 793118E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:21:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FEEE1A0533
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:21:36 +0000 (UTC)
X-FDA: 83816248992.06.E4BAD1B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17E1940005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:21:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ehTz4Jzx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756149694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4973FsADhzdVXNTFjytsdhgtYARkFQAq+eNa6ZCfdrA=;
	b=5XqoaAJhxC9FhmglnpEwWJhxmkSsU0xKkqqYyvhubm8YpM8XoDhETK6C8C588MKPtxHpMc
	omya5UmmEijkqcABXrAxKK1FpwDnd4eDfaMRJcxqvmVMZoXsaYP0XyHROM92bSvBNctA8n
	otIXRVrRN/jq0jMt3464ykuYDK8QRnE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ehTz4Jzx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756149694; a=rsa-sha256;
	cv=none;
	b=HFcOfKcnANqD8X4BkPz1pK6gy2UuQnq4VZuiQ7ziJXZYRwEo+VAYYigqduSFKmHSo4++gW
	R/Sf74Y+27XDPWv848wUAXdrZhILKlRXKjhtD7sudBqBLP+7WRZFJ7O+wvu7CQPgfh2RbV
	AVHr493TbQI5hCwn7hUPD9zyOHog5sQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756149693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4973FsADhzdVXNTFjytsdhgtYARkFQAq+eNa6ZCfdrA=;
	b=ehTz4JzxxqI74pvKkZzVAvcqFC1txxbhjNnrMZburw7cQ2/lhoL8/bcy6U4wj9BVsgBo9b
	C4dSBpiIiPqWUcqf9jvOkRWS+jpIClPjqUhbyO4TSurDQ+fNZYJraH8tG92icr0/pKnwU9
	pdl5wh1DN9dwxG8xEwFaCLq8KvOSMFw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-ntgzOzQ-MHaKOzrsCs2Zgw-1; Mon, 25 Aug 2025 15:21:31 -0400
X-MC-Unique: ntgzOzQ-MHaKOzrsCs2Zgw-1
X-Mimecast-MFC-AGG-ID: ntgzOzQ-MHaKOzrsCs2Zgw_1756149691
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3c380aa1ad1so2051718f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756149691; x=1756754491;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4973FsADhzdVXNTFjytsdhgtYARkFQAq+eNa6ZCfdrA=;
        b=WKHT4qVL453Tk5rWS1+oG8vUqy4zVK7VN+5uWfcABdWtX7uhGJiOpg6nmnmEpg7Xej
         5VX7Rhh5lQFYV0mRHLH4H4BEPT8HV2uWRbadS10ivLiA90iBtOVg4GK9tbrIxD65SYFL
         zB7g+8hC/8NoMFYI6UWkdzrb226IKIdzgBXZPq5pt2vkKmhSUZ212UAYtRYPQepQE70f
         MlRo9Gp505rXxCcHNFxWk6WpqELt5ZTpZVZVzd+noFCYDEWbMMSvBOxhrJ1LmtiuOATc
         X41xGNgOBHdFKGnLkcgUdBRkNd4huRjshQ/xAab32t2ReGOScgib+VqI+ah43ZG6C6nj
         uT6w==
X-Forwarded-Encrypted: i=1; AJvYcCUA1zi6FkFk0BCmDChDzjflBLBiL3W+pjXhgsHyc5mQ2FCNBo38wgrZhiEKdKX8cyd/gL8yrbRhMQ==@kvack.org
X-Gm-Message-State: AOJu0YwD7zrJxK6dJ0Vk5R/xCr2HTs8CdW0sTq5NPexuJcqhtHyxdwFj
	8rbFLuHnhAzUt34PjW6FJsfr+xEfmMoWS4PEL1nlRqKZS3SWdvpVRpEFwkVLoluyj1Xnw9aUwQE
	kFp2M/kECZqA81llZLFtdkjWmufF3kirFrWo2hCACYffTjpHUbgGB
X-Gm-Gg: ASbGnct/cmmmKieRLrf3DEsU8YyAJ9JYdzHrR8GbbJ3lkAgt9VL0V6X/SzQOH5v38jp
	lNOKSSReHWw6YISX/467iNtcDnA2cPM8e4Nq/eBvxAPkFLt+fyH6dtIr6wk2wO1DGtOHez/yaSB
	PIuqEPqDH7fsvWRZpAQynxIIKb4gKkUCkki8TG6b9zVGHpt9ee77luFiRza6MaTWcZcMBK74ucf
	POlh3tnxbAN/3BGe5wDpdWp8RXoGuLJPF1PrhkL2BZBLffknv3zSfR8pNoPH68FekR86Hxbhuu7
	TVMoljvE8qKA7OV1C2VF4KSxjPZ9qfusDLFWeLJaYtyQTDu9b+cgwmqqgD0+k82lobPiF2RrSLg
	7H1JmkJXoH2z5elZqRLBQFeg27F/E6x6BBOtJa2oIT0hzNOG83WUJzlKcYrRXwjHTUJM=
X-Received: by 2002:a5d:64ce:0:b0:3b7:9ae0:2e5e with SMTP id ffacd0b85a97d-3c5da83c912mr7364292f8f.9.1756149690800;
        Mon, 25 Aug 2025 12:21:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjWNW6Xu5QSvFxBNL/CfYdsPBPx9ubozM5lZ0V7FvEndNA7Hp/scIrCJusDS+aryhQ7TGOyw==
X-Received: by 2002:a5d:64ce:0:b0:3b7:9ae0:2e5e with SMTP id ffacd0b85a97d-3c5da83c912mr7364272f8f.9.1756149690332;
        Mon, 25 Aug 2025 12:21:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ef55aabsm12458636f8f.23.2025.08.25.12.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 12:21:29 -0700 (PDT)
Message-ID: <c512ddc5-0d04-4af8-8b26-2c671e43a3f8@redhat.com>
Date: Mon, 25 Aug 2025 21:21:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: use calloc instead of malloc in
 pagemap_ioctl.c
To: I Viswanath <viswanathiyyappan@gmail.com>, shuah@kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
References: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xe-UyPbKp_P_01uOTektFzNamtbffR_urc3ywtfXWLQ_1756149691
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 17E1940005
X-Stat-Signature: 9qc1eeeytsofnnpghefjiqhbnf1i1upi
X-Rspam-User: 
X-HE-Tag: 1756149693-356045
X-HE-Meta: U2FsdGVkX18DI7XfP2rP+DLlMVm6HTbz/GJlNO5rifxsCrmJQshRfdbKmf5Kfm+LPoS5YefribP4w3XYPmIA9MPS8YX+HRTh75mNeQ6AyOUrmacFM6BarDOVNP5s6lABrfLcsGXpwH8/HDyoMy0gczSwH7fy8q5zQHZHsItUDbUdTMIq6HAUT4m8Q4gm9Qst/YcPZQ3Cs97h/4R4Y/ZoGv81SflKO6R65d5oflvPnwv0M53AWcpvFW0be02RlGbGjaoIdt+lJrQFZkoqn9W5BYS5iQdBoNP4yd1OU3zKVKuMdMJ71T/oHmND139EMugzKVY73TNHazHZ8MCSwQV5N5quxHIS4RBOd9ILjzSx+EIqe9TpHAH85jSB+by9AmzGmqckV7ssfpKwTGtRxnXGta1AqAkOeA+MH6NJnH+rzzHScgZwvDGR2deQ175XWDc+5SBjkItQ4tJ6wBdMwmIjuBlNDJhONUNuaESJnDJvX+tBbpdPdeUJxlcFJSCLpOWZTRIuHdNd/sYAYeVx/7Ah3imt2HwgXx9tSbJdmNVHBPuDxPGmphNrgvVFlJleNCHilZOwJ7dOHoK6oAfptF4h/b2Q11YbaZJSe9TQP1wBno+fymn0xLMi5F1VXSOgejNSJU1IodL9nXaqFpPSjPjjefY7kKLLWz72/Swvvvzj3t74WPMYyXWqjFW8T8QONeHwMMfR7/gPlK9zx0c6gnBqbC1X0BFrK7yRv999KaEYk1cDfh/8qMJvlQecLKR+JDYSiFbEMxYJhzVGdCzDJYxdBKwtQ7dGcPhCFgpfBhpWxqFfTmNfmZxGYGy8Z7B7IH8bYzJTlOHUtnMjk+mrXsUsU7trfEK5OufnNiJhUatbMmeDVFYAdZzlhgGk4k38MCkmEErCytmYJPn5BZPKP598nuvRxz445nPx+9YKermtkxclO6v7xUcO7iuIf3QOKOPwohnn2trc6MilAhIfN6B
 oqksEzDA
 RgbxC8iyKETQQYvgcIZNUCRew8zUOKvD6jcxuLmU5epjgmOJN5CUe2R4Wm3hQhhHP6y6UExzlQcvSi+uzsVN/skp7iJGHhva/2QFsRxHPKq0h5tVFf1vbs46XA3tQXRxChmAxhczd8XoCU/fuE1j34/0u9rRWGj3xWre+XoapphtMUxuHZtmRPWvOmv/QUPTkHx1rJ/h9zsRgpiXSJCh0Rp7++I4bb4A8ZwV4pPYVrJz2Fo8meazytRy/iqyHnUrev2LLFtXvk12U0l1vNZcmh1v+uI9JNoZTTjIsUqThFR5mxyCWAj6LlQZto870pElSFG6CLk89C02UqOYyjxS2QF0vcU+IPYazgXL/CYETfL4LiMKfNQySBv+yEfGDCvSqXUf0Kz7JITxDtAczQjHkY1bPm/CxXPgbTFFwUS6rVmikmPan4WY+sNSSR55sK2GuPPRkaZSBzmt2R08rGs9y08iEYVvgHSQGHpxdcqiO2uynKfMoZ+7zR0cOafH8gxeqrc8A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 19:06, I Viswanath wrote:
> As per Documentation/process/deprecated.rst, dynamic size calculations
> should not be performed in memory allocator arguments due to possible
> overflows.
> 
> Replaced malloc with calloc to avoid open-ended arithmetic
> and prevent possible overflows.
> 
> Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


