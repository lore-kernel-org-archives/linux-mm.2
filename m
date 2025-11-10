Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1C2CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887878E000B; Mon, 10 Nov 2025 09:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F188E0002; Mon, 10 Nov 2025 09:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7744F8E000B; Mon, 10 Nov 2025 09:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6412A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:00:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06D7013C368
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:00:39 +0000 (UTC)
X-FDA: 84094857798.14.A3DE5D7
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id D46694001B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:00:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJ1ovIM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762783236; a=rsa-sha256;
	cv=none;
	b=vnSWblcBV2SXWOx4UP8t+XTSTBqBJHZmoduA7EpJQg50gIo50HYj3LNuAlXLK+TThDptiR
	iaWkQ74SajxCE7Eu2WQckP6R4yPiIa//huFqPs/+tT1wazuSX5TduulwWVERfNjWJS3VFp
	Ng3YYIABxpABIfhi4r+mZd5+s8Ln/eQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJ1ovIM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762783236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4l3M70pV0c14d1SIvE9JX7nk/ZPCIDubtc+GHmzBoAE=;
	b=dNZrC98zEyoh8kSyTyFArhH7WHygZWyl1P9NlMt+hP9RFJ8HnPWpKm1qB9lQKa+2bT20qY
	vQKHoz7IDStFP9D+/5JcMYqso/ocG3HT5mGsfEQLUCtc4SHcXODssYnEDCjzgVMSoVZbo+
	wvDBIvqJ9H64VD7z+PNlq5v/uLMzdkI=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477632d9326so23517255e9.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762783235; x=1763388035; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4l3M70pV0c14d1SIvE9JX7nk/ZPCIDubtc+GHmzBoAE=;
        b=gJ1ovIM+zOjlpChufO4g/clBPGJJPnHNAroGFPt6Uq1FEZ6+md4EYGC9FX5oPaKIbx
         +QeakivxhbcTng7Lcb7BNb+teQHwjbBXSBS2reKxtodnI3Z5MfCJ0VnHeGQrBXsyZbq8
         0h3/HUGv/wTMLY1To0/IGYj5QrQPuTxYtzZ9cbrUpk7y7NOIG/jcyVoqbBoWeC+ZSkO6
         waXNNOiFd7ycIjQnARfVOdHkDMhRxwlII3HteJa/EC94efsnaFfprUQm64tcY1Ne76PX
         TlGrvnejAzXgFhtTJg/EUOLwcZK/Ufjx3okGyy70PqOncYkUfbJZuJBbeazR9NPKV+b0
         Dntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762783235; x=1763388035;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4l3M70pV0c14d1SIvE9JX7nk/ZPCIDubtc+GHmzBoAE=;
        b=c4Og7626jQ5VYOqylRqaDoYddGvxzI9oW6XkhxAdUogsQMtFHyk3MISJLA2lKzaIWS
         yRcyKldoMeBlVOI12yuzZId6jkPEPKM+ISopS/pjIY6tqkvdWDcR/7C0r0yUE325DWQn
         enJcaFuYXsUINtkVW6ADhm5oKv5V2OmRk0YTjZnyQkbiceGIBxfVLQkD8hSO9glfYW3u
         /SAZF3x4iOCpPgNOI0OLJAUhB04sD7X+CEvQ6vPPIE4TBIqRXR2x19kpOZbq9tOcsrXI
         pl5lNYHjqxIdqdnl4iNlYVM8HULjMQwVQf60oM7MG2XdIEeHH28ThD5jv28BRJD7kzK7
         LIVw==
X-Forwarded-Encrypted: i=1; AJvYcCUTh9Pu9iaRgzWqZ5AWO/ytQsZLy9KjZFKrU2dRe3dJWFR+cFuZ4mVupPHDuL9v8kvPaFUvZSgwLA==@kvack.org
X-Gm-Message-State: AOJu0YzsWqf/NZlQI7CqDmYFMoUXmTdymamKQ0yzbFUPRg0ixmLNF7AH
	4rXDLn1fpkqN1TJjDHVf1vSMXp2/ppeHokAwLNiPQEEmydK/wy0ipx3R
X-Gm-Gg: ASbGncvFe0qfftC1ERnyo7zJhCaM6wld+i/YCbC6w8XAV5BOi9tbxpUVISuS7KLoRZD
	5lQYqnM4ue3KPV2FbvoKu1b/X4RqmXzLmBSjSznvvyNbLJF/rVQVmX2frADEWDZeHozrmEZelCL
	nqBeKPgQKay0F2s7YqDWFM3VMlb+ememCtKK4zbGc9X2/F/BQPJDp1fKvJtpH2KwxE8KB8WFtlT
	eEBelUuFrTsQmb4Gf55v9UkBcKelcwzNxCiBezXced6/Vhaz9eLgn8Cpv4g7Z4We4+y4j8nxDAi
	IPxjcpQNvXXmUJQMHS9cc8Et0tqFPvma2SdbZJ+Qq1gUayFMR+/7dppMd2x3xXc+fDx4Ht1YDC/
	JTjIPpedII0pyG89YyJARVgZBb2glDGxJIBZUKMnCHzDHLPb1DxVcRlfW5inJN09G9erklhZnmh
	N7/SJosZSVlvV2l3eFFEIYsIKZSRn63IdfkwhZSvLzBllZci5YItf2KvebaMBJKJQA5irjTico8
	nhP7Z1pifcsKCqnJQiRyFnwWIcLWI4YVBZxSlxeeXPnITCj4RiUhaSrtF5z
X-Google-Smtp-Source: AGHT+IF4UYzYuQ5gtNvkLSNSf73n/ZiCTwtuvYmTJtVCw6+PSGNCr+TyxhYSZT5k12Csb6f4YHcj2Q==
X-Received: by 2002:a05:600c:a6a6:b0:477:79cf:89d4 with SMTP id 5b1f17b1804b1-47779cf8b43mr33422025e9.31.1762783234986;
        Mon, 10 Nov 2025 06:00:34 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cdc33c8sm318303885e9.2.2025.11.10.06.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 06:00:34 -0800 (PST)
Message-ID: <9b622374-778a-4459-aca9-4eb406a58516@gmail.com>
Date: Mon, 10 Nov 2025 15:00:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
To: Matthew Wilcox <willy@infradead.org>, Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <aRHs3pA2kOr_uD3k@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D46694001B
X-Stat-Signature: cyco1ko5ntfdguo6w1bt64sf53qyb1x8
X-HE-Tag: 1762783236-492478
X-HE-Meta: U2FsdGVkX1+lWQM/5dLHfwyfPR2HHrL8Iui2k53u1zNl2q8pcJaZWABi/h8LjB12OEX9mecqjrRqAGR6hhGvwyL1w+TDNldB566agigD/deTDOYQ3MCBSaZioKZkuQi2avwmDWRrMHutTrKBZrsdyb9UecXhVJ8s519WpjQ0Fa91/G/U2+Fg64+vXESc9bOOnh945H8dBYYbNdiQOwm8rCwaeS2zgG+rL7ZDxL2m0i27WQu3EM8UlrEm4pew6LXPZbjrG4GITGRrfYGEN5i+d/cyIs2W4iwh8/8gG1naOqkGW3aBVj6hewi2c0bN0DsKxd95vajOECCszyWlknQGz2JaBAiMc+HmZ5xvM48E81uFDI2t/F12aH02HsCJF71it73t1Gn9JuLqsK51zbGCaF9MXdX9Xek1mGqevyoTxFh2xRs7d/WtIY55F9aYyT325POaTXJzwDiwckwQ8EMjaiQwuKFGQd53tF5Dla76IEVTj8K1LF7vPyNZs7hxVWu5kU8Jz+7C6zCQX872Nt7Q2w3dLUxBd/1iruHSv8qjgTzyDyNOux9s5WYFOfHLgbcUJ6XLvqX728y8sZj2Y35XOUMNsYxEAJWC/suQKj81JVLQXVifHgsi3OoOdO4QLdQkWn7CAOizUNjX+A6nDOTzV1F7Tps+AcUEO2nKrt6R0Ye8qo/BSQt1QPOiGdaXFQixYJ/ATdqvOAVxeZZAj1TXp9cFdkzpeAaCpY7lDinDEo0EYSs5OZFb9yo+gVbq1ZnJqDRYQ5v94mJLWJw9xEmwjQoacSgqgOBg+shegTnT4Pi5BRzEuGi7QvF+xwSZEXOZc9ynLYFUta1OdFM54bmCqHUtQ+czueMTUAigjd85S43tzd7T05xej0bvG+L0UOo+mh9FPVZwezR9zEY6MX9GvE0G4lhI0dWBwvHsZuXlg3x3BAzCwe5czCGoaQzGgphlj1+J+RCipOgiDLnnn/Y
 fxxIm21b
 6FuBSfjdqmnYchs/UkEm+m3/XoAoizAWW5d7IH+YItLmRkHIZDMQswb8fOXED/XFhcanSLwjKfj6lwdd+Nfvrs5AAPS2r5z0WLGdWCfTwdtGrjDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 14:47, Matthew Wilcox wrote:
> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes. The
> 
> That explanation derails my brain entirely.  Text isn't writable!  How
> can the pages be dirty and file-backed text?

Files are writable :)

