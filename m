Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C57FCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9F68E0013; Mon,  1 Sep 2025 05:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43EF6B000C; Mon,  1 Sep 2025 05:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B458E0013; Mon,  1 Sep 2025 05:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9941A6B0007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:53:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D1971A0766
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:53:04 +0000 (UTC)
X-FDA: 83840217888.11.D245BB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF89A180009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:53:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AbmOWchu;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LvLVeYuHdeJH8AgS79Exqr4t4r6MVkWdGrUcZdBGdg=;
	b=pMp1EVxychBE0qphWrn7Edb7Fiw3AuEcQzpFlLAMekjn53L6IKF9U+/DQDY5zl6hoYngSP
	2ZhsfF0q4n4yF+pAYSHza3XyZaTPecgeivCUBBz70UYc/Ml+vUJ7W2w+uMHr7gko4LrqS8
	WmA2lKJ/1Ka7d/xGy3lkuCP9AvjZNdY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AbmOWchu;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720382; a=rsa-sha256;
	cv=none;
	b=v7hnXcXVyLqq+x8sq59ufuXOn/R4n75Wtbj6yWlGGoKaX0vyQPtZnL+rDYhGfzMD5M+MI7
	0PnuSFCLCGpzh37vZ5RotkuDhu4Hz+UAZLe0XhOnZXfLt1PZnks0WrW3oDSfN5pk/6XZ1i
	1eAbsc43X63LRwTdLjayAlVMa/laqLk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756720381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5LvLVeYuHdeJH8AgS79Exqr4t4r6MVkWdGrUcZdBGdg=;
	b=AbmOWchuXymSMpRMqMUvFzatTveXD6fbDZquI46cGthp9i6rPjGhBIuAu+tzj8qnh9a81T
	nuISfjoPOrTTP0H+v9jMy9ttAddRUndj3zTH++92erWSITUylh0BFFYLC4BMNzKXQa6Hu4
	jvQfGH89gYjSh/kK2kYvjYXbTBDXAcM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-DzlqnIJGOFCJiwzhQf7SGw-1; Mon, 01 Sep 2025 05:53:00 -0400
X-MC-Unique: DzlqnIJGOFCJiwzhQf7SGw-1
X-Mimecast-MFC-AGG-ID: DzlqnIJGOFCJiwzhQf7SGw_1756720379
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b828bed3fso9925565e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720379; x=1757325179;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5LvLVeYuHdeJH8AgS79Exqr4t4r6MVkWdGrUcZdBGdg=;
        b=a4u5nyky1oN7fEEWOUpzrCQY/BbCGVXJ+mD/US5hkqXa5ZoSycIfIjQim2HufR/WpF
         scYclAG1PMq/mNMcXYVt6d5uPs5xQdDuK2sqm4w9GPzW+qx34jb+1UUcadmP7A9aGqCv
         dPAfl1/0nrBqHB6jbEddQgj8Jo68ud2o9cdUDIC5zeHD4/maLyxlFUGJ9iSbYufkcgRm
         MZRzO8fF9aoOtTHD6YPI8XQZotuV02Jkg3cCEm2qxEMmXbT8YVU+p0PTuadHhWk3zTEU
         zY8ZtuZpqTnHnUTcOYWvuulYyGxLUWr6mTplypJuIKlbAboufUMPr6B/RNLAZcU5/hVi
         MB8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXnMCXa+SuIgEe9QDDIrulAIiPJ5dZxfm/ikD816Z10X0RUzYoIXI0s1pH5LiBHveNGLwciSjBiBQ==@kvack.org
X-Gm-Message-State: AOJu0YzhTJy+pTP9vOE9mbsUqTcIJhdADd68BiBfFNnzKk6QlHm1vZSO
	UZEs2ElpSI9WWvCxmFegWI98lh/fLunp3Tctt5hgJKwJMoEPcTPy8YApBp8yhwdxT7fSA2icBpb
	ERFjNgpYfdnrG1tW8Ee9nDCacPvXQnW7ZJbCb2BalKyodjwSmsbs8
X-Gm-Gg: ASbGncs6l8y7mdBLraPg+FjztgQjqVkTqQoIEEkqImKMB4/6n73DtG4SbQVK24hC/Mg
	BUm84j3bv6RGMeXVgFz+G5Gio+AecV0SXpVuySOqx5V2ftAPjyLQnHdFOQUvQWUi8eShs/xFzpm
	M08eeO6N/yueeGjxSKdFogPrQSa3CtZf3eFMGZlfHEJX8n7KLCdrJt3/J1q/uy/xIKMZDDAsIc8
	iWixGRmYBPwMA0jgTrvU6P2K8l/YBrfgWVvKOtrwO0LIqnhCCmgEPINMSF/BFA0RbwVdBMGE0pl
	P0VzG8NTtSYdIVlRoSlVq1WMKKrp34NHkX94aFHT/DKl3PjGrhyxK7ihBDZcXJymJ1MNlOyXhdF
	0AaCjVjsy9mUYnXWSrZqslkkFjkI0GjHs7ETPFsm++69R2M+WLqjFlCKnOIidLUnVEmQ=
X-Received: by 2002:a05:600c:4f87:b0:45b:8482:5ad4 with SMTP id 5b1f17b1804b1-45b855341femr56195555e9.13.1756720378788;
        Mon, 01 Sep 2025 02:52:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE11yXnXacBpUOwwJsY63Hrb03jEZbAs5yp+OA+dCPrZ6f84MMl4rXK6UnnGbKusCjKp/Wm9g==
X-Received: by 2002:a05:600c:4f87:b0:45b:8482:5ad4 with SMTP id 5b1f17b1804b1-45b855341femr56195345e9.13.1756720378403;
        Mon, 01 Sep 2025 02:52:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e887fdcsm150682805e9.13.2025.09.01.02.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 02:52:57 -0700 (PDT)
Message-ID: <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com>
Date: Mon, 1 Sep 2025 11:52:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
 <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: buFi0gIfV6bC4rDqZrhDtibumkCznxKeWS2mpETejQw_1756720379
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF89A180009
X-Stat-Signature: 6ky7t9rjuts5k1sp7mqnp3euoamrwn5b
X-Rspam-User: 
X-HE-Tag: 1756720381-29590
X-HE-Meta: U2FsdGVkX19jzYVSiaOHnLr4Lg6MDpC5gi6Krhu438P7c/gaTOauNV6X/57mzv7Tef24++7ti6P27qParMbfDUXArihU7haogrtU//JXrCTXGqPwcdUtA+wRr4Cu0fa1veBp94KOIa+Va63XKZyZ/OdvyfGgt2rOQycBn8NifaTD34ceURAjamnRP/n47OIgPwehTAEqz9IVDxMoV6idS8banVQDui0vTNHD8iODoZnHZq8uEjY6Mq6buyNR3DJP6pKBXxJKuaUjXBVhN953+fWu1lPWIcgvntRr0+hhMAlbA8CagFhJwQNE3C0Mw6bYbcOlRJMz7DDZAbLnOFpvvlfV46xeXMgKqytGD2XpJMfB1uKizxsU5y1P+1rMNp00QNEPof8IlenIWNDPkWKlQ7YSeq30gFx0aB6pNSbJmAaYe2PP0OCP1Tj+tgRCjKVoc5smVrm29UWlHyeuzO0DPZnTTk9WkcfSF+larpxNNNttIGPlqezg9Bvu4CvbHy50RQ/NKqvm47fXUTQewvRJQQnrNw65ekjVxkElU5IVgw7YCBTcKBdJZ+JNwOLPCDC1+9nsuGLxyBAQx7ufW+4JnMGDz3LKmapeZrSH370qPs9UuhO8lrAMm1ZHT/PwRt+O5zZeBdXU+IAuOUn0drh43XRd1Qsqxc1PM+SnpIOQHRMA6LR7hrTsHyghA69gkKgh3ZKxOso+jNl0aHT505NQcd5zFPuh6OBeLheCl8yeqB44mCoLODA3mH7Spt/MW8jnEEMSthkiOzbbmw0YDOdhbpfyLwIVwclBc14iHonEaplu0++Y4v2tY/dRKC8VoCBIaUwhLkX+WAxu4xiFEE8JxO8vqLspBuLdk3sg39pPTv2hx/rpZjpyjvC1oc5LjtY6R+5l7uSkpO+NjHfnFqadnOTL3/w9oukvs682tf8EG+S/mJaPLUB+Mw2MLqX8NbPBEgA4fTZhE2l+x1XZDH9
 z5ZX1XS9
 3WJjnoM+ISEVdEIBoETrbWxjg7J9pPNzO7xzy2F4OrIBBVaCUGna678WwfqZd4AcdE5Kx+S/c9rK8cPIyMOauxopyi/1TS/T0rB2IJpDDu/NfyDGhmzxouoex1Z3Tb07128ZSae4O43ngBadb4YdGVD1onQhahQ/SaevPxoWEBc56XCAReP5NeFoMjiVUJwyzfW6g4Odu3qYdwRIPR9f0/qRQysu4b4KpyC0Mz8i8bQtIzd2toDDGKIQkRsAYiKRqEYdKnceW3dX4uQinkrJKcC3ssrWuoqqJdl7nYm4T3rwH6RRzSSo/MImQRZR53Zsoqo8LYr2o0JpVwkCCzdRpcfywUDe/PArQvik78MLhsrY2q5ABP+MbVB/NLrfRtCXtpBV90/xF71d9kfJxktFgDsIQA2GVdGrJTzm6+tEkgkkuF08a1lKiyqgMO/3XESN88F020YqkGugS0YIjkxLSlcrKymanQtu2VQw6PPVZCrbbGX5rAVKnSnpgd3TXEevPDjbtihfGnxGggkGBwlP0aKKhkO79bFtwpVM0lK7nZzQMpeJ0pHqjHcBq5hvFeE4DdbUV7zIjOagfrBv9mhj3fvG40u+ky1TKriDh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 11:48, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 11:41 AM David Hildenbrand <david@redhat.com> wrote:
>> There is an important distinction between garbage and a reasonable patch
>> description.
> 
> It's still not clear to me where you draw the line (it's opinion, no
> objective truth; to me, every redundant piece of text is effectively
> garbage because it steals my time) - but you asked me to get busy
> instead of arguing with you.

I'm sorry, I have no time to argue about the basics of writing a patch 
description. I even proposed a simple example of what we (multiple 
reviewers) would expect as a bare minimum.

If that's not good enough, I don't know what would be.

-- 
Cheers

David / dhildenb


