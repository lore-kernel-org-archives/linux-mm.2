Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B2F4CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E968C8E0014; Wed, 17 Sep 2025 06:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47418E0001; Wed, 17 Sep 2025 06:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E918E0014; Wed, 17 Sep 2025 06:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9E138E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:53:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64F8186CE6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:53:05 +0000 (UTC)
X-FDA: 83898429930.10.67AD73B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE690C0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:53:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLACplWG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758106383; a=rsa-sha256;
	cv=none;
	b=0sQKxPYEFFB+VwQczY3I7cL07c2fd3J77RUg3kaS63Rz2lVyN0AFw5VI7MoSWpjtlGBcZq
	rqkazy0r3i+85jMqfSQ6Mng3bwAbMzp2NN7JzT4g0qldLc6FL+9dtf944/M1lLGzuIAjxr
	eNv9iTa8YTwdTxMFfQfl/MfPxq6doeU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eLACplWG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758106383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6j8Nz2GipAO+d9sYeGusBaesKR+rSO74MbWDuoA0aU=;
	b=U91w2q4iNHeeqS26v7zSx85nhols9a/91GEq/5uplNWvxmO8ck2i2IM8wm4t8nBZIYmnAW
	/6c+gjIxjeSTZFyVP2AEEcLhCrLN4EknmpLMfJlmmHdm8r12JK6Ud/1qjJtzc+d6m2hcnH
	uMev4qu277ZpYaMRfMqywk8mfMv8YdM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758106382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h6j8Nz2GipAO+d9sYeGusBaesKR+rSO74MbWDuoA0aU=;
	b=eLACplWGZx9fYwh8begQctOB+Du/go/jn8rvuy6IL1krRnmojb7zDBQMAdlM7IlLQ3b7Jf
	Z6Wdg4Ww6DGDn59YJqJFyedCARoSfKXd5x7BQyrry4LYbdVUJ1H5w6Cew1ulLwkJJfHzNG
	GqOHPmrTi+qUNhQpFpyca3oa6w8Dd/M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-HoQaA6uZPtOjDZhtD-KdMg-1; Wed, 17 Sep 2025 06:52:59 -0400
X-MC-Unique: HoQaA6uZPtOjDZhtD-KdMg-1
X-Mimecast-MFC-AGG-ID: HoQaA6uZPtOjDZhtD-KdMg_1758106378
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb612d362so40584285e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758106378; x=1758711178;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6j8Nz2GipAO+d9sYeGusBaesKR+rSO74MbWDuoA0aU=;
        b=Z3H2nK53KS/vNolKfLtaAK3AwYvY8x+xMumuXGOeU/F6MRbNQi9aVJRJGfc1391L82
         2QMw/5TTgogo6yJUErEIa0P2G1ZlHIW82EDQS729mHRvDfI5qwxCVHx9teVWg0ul4T0H
         8arGbk075x7AWAkw6NCDk+7fcRcVtysn/OwqX67PnPGQqX3wnJHw5QFX1Vf0QCfKxXVi
         32VgzPuhw20nNFa3PwPVAitJ7AoheLq9U8PE7KzJQ2OD768cXdG8Jlh+X5zfpSjcaF/F
         R5/WXUosZCnfQqXtXbZsHT0Rzx/TSZxrgVtZY/mQY8JurUzHbOi5ftHqqyGVJg9xv+OI
         Kl7A==
X-Forwarded-Encrypted: i=1; AJvYcCUzxgfzmIvWezU6xySxq2J/p02tHwBiRD0VAY75U9JI7+yTk6A2EcOJ4eexteCI4iYp2JYGtLOUfQ==@kvack.org
X-Gm-Message-State: AOJu0YyMeTsuKEQarCUxfKOpolUdv0I7xw94bPJxBpqYuE5kv6Wmgx2M
	Yejnwp3sMIouAxjfIzHE3OLOCgGk3IN0/LEKVYhW5K9aE2MuBC08lQnAUEcVZprRzxGNODe2Rvr
	VziuGj8o72kWZivbPHSQu5KOmyV+3LHV18xCGMWiy6/mWCGhwnY0h
X-Gm-Gg: ASbGncsfhci6PWUPiohsh4JD1Inu5yBtmk7BenHRZDRa04unVI7JmimC9OipWWQXMIu
	P5VHWvoMO1cWBpTIh8yF/+B6uv3w+faEPTCE8dhHCYwklT+Y/SYP5nWh+upID0CtRqhYHOKuyKY
	JGwrzukcDpYFM+u5C2p9AxAjqRwZCNUqD4P0YyT3AnlJS+/BmoVZgJW78AP6fiLQ1XM9ZC24h2d
	kLbx9e15mvVwKB+WgPaIOxReYY2J7e2YAImUH1z8COY1ncSX3OYe/qw9gcGTwKYRFI54tbCcdNz
	/fz3URbJ9p9eP6vRAZtphi1Ohe072OevDPURUzN+9b5nx48Xy5rQ7mwTOp14/TwBY0TXS38TR5V
	jLtwhAd+qMrfQ6XElNKPtQst2aC+hcvl/pQGsJ8Y7z+T9k9rokYovCjhL8zJ8Vjt2
X-Received: by 2002:a05:600c:3b09:b0:45f:2d2a:e323 with SMTP id 5b1f17b1804b1-461fc6674f9mr17283965e9.0.1758106377756;
        Wed, 17 Sep 2025 03:52:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESkIdDmkpsYOdBEK8Vy0LYg2yM7axrrebxRGyM0x90xAENdINMOVuiRGc5rue0jgcFRLjsmA==
X-Received: by 2002:a05:600c:3b09:b0:45f:2d2a:e323 with SMTP id 5b1f17b1804b1-461fc6674f9mr17283645e9.0.1758106377323;
        Wed, 17 Sep 2025 03:52:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613d33633bsm32518195e9.11.2025.09.17.03.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:52:56 -0700 (PDT)
Message-ID: <ad019c14-5211-4261-bfb8-c4e0dd3b2535@redhat.com>
Date: Wed, 17 Sep 2025 12:52:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-2-kaleshsingh@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915163838.631445-2-kaleshsingh@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k6zdRJP21dAtXt_LBB7BYCAxV5Z9KyBoaaneG7fAsYI_1758106378
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE690C0002
X-Stat-Signature: fixknj5wdxq5anq83cpgrfmc9xxjrem9
X-Rspam-User: 
X-HE-Tag: 1758106382-402052
X-HE-Meta: U2FsdGVkX19GRTvkRoZOlZ6Cgh+2qDrefwI0TavEOPGGgkU6AfuZxJLeIsKPBabbcTP3b0u+QTN/SHYXhV7qktM/Esq6wAg2uH6JcNmRbfon05ZB8j7aAeCLsWIV7s191u/jU+a9qPL+9lTPQX6htvMVa4M4ApfoCYONJmi+PuegVpDkU7TGQQUZhxFfEo/70uoc4y5xcCrwwGWVpkl7INz6tJ+PHkdDz6A6Xx8WGnnNhpLdWVUIRwicdfnK8uuPC6YVE6hDkMh/x2cBJ1sMKfVwlTPSWdAM2X3cc2giugpWgEAxE/cRj4O6nhACppanJSbIyy4TugZpF7/d08XSJG+dbfNQyMcOBNXPCV4vcHDiC452jks3M0Huf6p7P3bXLAdX5aui+5HCFl14ZUWpq++H6hrPR8bQMxw5cWIkATP65BXXpI4HCUU4s6N6vwirdaiC1kG/HFU08GkweDjtPYLHpDHP/6zsuHXpOl/LymjoZ6r0AzfOERLbcC1Rl6LemE8F7MFYM62uoaQWkN/snEAdvJBgifilUlSrpxCQ6+XqJ7OpR2+6ztrvDlbV1ZdkCme1CeOUoHTxDOgrPsBjSKBQjOImXGJHyHLVPnFc0jQh1aj4tj1lNtj9xt+nTZ+OeA43WQ5V3TfwFuyh7jMmDNdjkYdbJjmC7GAZ906z2Q0+9+qPaZEEmU0yrRBYLa9BY0Ce2fCCexotkhkUG5iuTTl+bWZaO/qhRpH9jzJ/MJJfI6k/rt3oH2r7o7G5Bwon6VtMbbT2n9rYvItjLiiTPXoiSkSq/6yEk24yc1uIjvACyd5+X5UDKdFuyyoIBobCxwSxNZHkYh9dV21n3awXxRz4W/MV7r1DsSQirplww/sceITonjOy4dALyVuJDAjOCLyqx31Y8/K4cor+Of7xZvSOzelfeOwJjH5AsgjKOgdRxfBq3oNJybNO1/vN+vqfEDmNsT8ZerZEMW6PREO
 G9si18QQ
 Jo7845dA5HzDtMG/vlUxdW02RNHlXKboV3HfTVoSyvKNxvr8TctpylLlOcP1jgokJBD/LZKYIHQD/4LgW2A7/YGnuaPD0iAMvgC1bPFasu36AeYBMZqWQEAGjhtzveLcrI9E/Nzzr1F25URy5xlSaTE8qB9XhRES5gBRfZi9zxZGA4dfw6iuQGyC31gmcExS4ypaU7WawPaWTF76wWWl/IPNJwo5ucFLlqdNFbuIpJG4HbAhFuZsOMSyluW4qAOojycrYtjQvlIscJBH7Vw+6/QY6sTrCPj0o73WuW5+PJz//gGnWnhA49Okh70u4Rz5kVWL7Zg8JuQGSfnoEwQiyCBS8jQ3C1vFu32csiC3eO/+neIpsaYZKMIdyN8df9OG6F62P5uApOZG2fcCXCneTx7cbtDv8c53n/R06ymJrjPdONLQkLpA7OdXiWMnOvllIWhwLaruDtMKsKwllMeBoyPVdN6Q825hrAnopPtvt0xoA1V6+WE3exBI8ab9GFJhwKYnfFcfqcKIfnajSs93XwYT0+8SZTn+3COpSYV1G+MQYJSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 18:36, Kalesh Singh wrote:
> The VMA count limit check in do_mmap() and do_brk_flags() uses a
> strict inequality (>), which allows a process's VMA count to exceed
> the configured sysctl_max_map_count limit by one.
> 
> A process with mm->map_count == sysctl_max_map_count will incorrectly
> pass this check and then exceed the limit upon allocation of a new VMA
> when its map_count is incremented.
> 
> Other VMA allocation paths, such as split_vma(), already use the
> correct, inclusive (>=) comparison.
> 
> Fix this bug by changing the comparison to be inclusive in do_mmap()
> and do_brk_flags(), bringing them in line with the correct behavior
> of other allocation paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


