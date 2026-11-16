Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADE1606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DYUObZ8p
Received: by kanga.kvack.org (Postfix)
	id ACE896B05B1; Mon, 16 Nov 2026 16:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F0F6B05B2; Mon, 16 Nov 2026 16:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D246B05B3; Mon, 16 Nov 2026 16:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 717876B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:55:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1385E1C2AD5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:55:13 +0000 (UTC)
X-FDA: 85442338506.22.CEE5E9C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19375140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:55:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DYUObZ8p;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794866111;
	b=o2DBv1Cl2q647nbvS3xZDz6x/hcEaRjBHHFcDQQHkfrUmplgmsXPt4E+Nf4Hm1ePp1RXIZ
	/5IwHDLLnsJ+AmdCA00AKFSok1kQD+5I6wYxUBSt6FbdxJx6WdVH5R3Jeyx3cVWKMOWEAl
	inJMpbkVP2uaLJx3ewX2w13gbcGbn+8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DYUObZ8p;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794866111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8vq/8+11uEzF73ROpgv5xIjXzTVcQX1lcqgJ4otboU=;
	b=8GfB7Nu4Me2Uu28Gzkm5w+6eyOr5VWHkl12n7xhH/ZGXrQCBp0zsh6Um2heaOijJeHuMi2
	uWROAo/Wi/qtH1RQkkcEO3K6DKBPYEIXgYBfAoVjYoZzhUAq7HjxsRTdgx6exC1+zCmSBZ
	EW/gCq+m8Zhqot+CTvZpd1nqEV9n/WI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb61185057so17040415e9.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794866109; x=1795470909; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z8vq/8+11uEzF73ROpgv5xIjXzTVcQX1lcqgJ4otboU=;
        b=DYUObZ8p0giVPkFfBNPdaXN9pgDRN4jXvqn5IKLMoW0/l+tSizV+PqWCFd9Ynd8yLt
         jS6dgZ2q76yyW5CAaJ2JCpA0OKXS5ggUTYiWVs7v/MsrEYDeEQcvUkzUyI1nN18V6Woz
         gbhn4q0e7+J3Z15pp/W39aNAmSznTZTHhog6+2VphkTK0zP11r8++325g8d9toKXPiGo
         h2iva89yxH2/sTlZ2uczSdSPw0r/8QYNuGL9yjBRXoHBVkdkAd1R6oM+tLrrSEqRaNGo
         fPwxuZpORrqZenT8+zvLasrYxX5KHVDy+wJtOlDuW8OJRq+VO4d8BmMlhLw+hgA8MytH
         Jqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794866109; x=1795470909;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8vq/8+11uEzF73ROpgv5xIjXzTVcQX1lcqgJ4otboU=;
        b=ynrn4fpk5/ivYhaIZk08L17IzZSRAF4kPPkVqhos2GsR+fPcU+xBRVqDzetftNF5kz
         yj5vp+M7ZXrHPIRmV0HZHNkzlv0WF5zTSvf2+HT9hfPiilCAeQEK5JgJRPVjg6l/i5IE
         NkKueiQYc7CVKQ/RAUBVsOVSinb4JcjHHV2wcd10Y4na8nhxbrzMK+t2CNT14MV5nqn6
         WRio+8ErIZWqk6G1OCN3edacResbXur4+Ax8vrlV15eobfYY1xBHbNKP0TQqN9E7aLJ0
         0/MFIGfHD/waL4RIaHJ5SIdC6Z33LcHaCV73Oq+XmI6XPHIIFVnHqzUEhOyk4/zJc9Fx
         lWkQ==
X-Forwarded-Encrypted: i=1; AL+hErFnopfMVELrJl13ykB02uJlYG/vBQPFNwkHHoedIVcGpVwSyUIgtco/cO+SQSiShtHugJ+AYay83g==@kvack.org
X-Gm-Message-State: APuU4Z84m+YyYBRkamPWO3QIkmw2tiodNWaFT2pFbphq2adNnJQvXBw4
	tCGMkd6yNvjyxmCPczFG6QMj7O6PBSeK13pR1J8jqMN4/eHQX82EEp2+
X-Gm-Gg: AYBFou0tNSmM1bvyIyFjAX8oZRcMOLZeL4I6znWuSM8fl6r+FHwHkapC6xk8cT2FeDf
	Q9NsY85VJ+sa3Jrn3Qo7WP5kscEv3tz2gqRxXyzpMRG3EC/nGO0rRr2zn1h5AFLsSz6G1HpTHKk
	2P4iCOo0cfii6EvYMdkIuPFpFGjzqBZTuH5J8IPRyzh2I8+4YLnQEhALmkKsesQY5XwVGojBi3G
	rU2v3dPftX/5W7Ek0F2tnI8fJqmFeilCGwdfS9DsplXakeg9q+CmnKfrBneLzI0smVHziKMWuNL
	xQVFSWVHITsXO2lX+orQrKxrzCtYYwaP2t1ZRQ8fPjIqx+QzagviskNehwgfLNC6fBBgU9qJDWZ
	r2HtrX7zwjUMncOoN+nsppcQCVDkyRH63txEvD3dWa1I2lVuKKgsdEjHSob2sCnEDZ7ogYHz92+
	6d5j17RmSosKViaqB+Q4l+fXNi9FJy7G9xJfpDvNwa2HnLglUvOlsUxb6gCIAkD1mjrpNalno3h
	s99zQfDz/TOlE2UFn6BAOf40HxJ/SIa9r9UBqPFLvWebpV1QkQEgjY2dxTtvOtf7RiFJgZfMMU6
	/se/2Nf1nzs5ijRVmLZEzBg7
X-Received: by 2002:a05:600c:1f96:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4bb55a4eb97mr252720535e9.12.1794866109317;
        Mon, 16 Nov 2026 13:55:09 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78346f4asm17391425e9.0.2026.11.16.13.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 13:55:08 -0800 (PST)
Message-ID: <08c0c631-64d6-4703-adbc-88fa1dfbe3c5@gmail.com>
Date: Mon, 16 Nov 2026 22:55:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Documentation/userfaultfd: document RWP behavior when
 the PTE is dropped
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20261116101004.15322-1-azpijr@gmail.com>
 <avsu-yTSPKtZn_Ez@shutemov.name>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <avsu-yTSPKtZn_Ez@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bmq193hxfxyxnqen67zak4fwdkewx7dw
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19375140005
X-HE-Tag: 1794866110-544608
X-HE-Meta: U2FsdGVkX1+PRs9E7WGVASr5he8ZnuDG3WTz8tKuGupjG1FtndlD6u9aFGVFrxWsyWuR7naQKqeNi6ahVAECoMpcNyWnkjQK0hA28AeTzdUf5UgZ0SYAczA9SGdnLjZemlMtxrnGUm8vgZGyNxAQmweWNw1m6ZreisqZhzN8UaSx6oS5BIK7WxsKcXZoLE4qt4V84KjN7fcVxorBucbTQEPwfRehWYZ5+5RE0JDlI57kDTQnJ5zzhNNXQ15WNEPe2zvqU8Ad8PnB7coIEIAp/W+Nb3UUYm8dueEN4MSeGHwqvoa0H5d1GTu2pDb+EwhKl6z4WixFNQDQoTjyOUNXc7dHaXUxPPbn8t5+he1iYklPfcX7J0WEaXG8RtoA0NmzWMIFSq2+EWT3S8+vumhJWuIHRI+DIQtWb+gu3z8fm6CLX/mHD5aG7cE73AozfjF3UA23ylgmH5iAqyQdJYO8CfdEv0GNHpi8DuwG8ePWdzzO/CZxMeIhfH6SSmYl6J64H+HSIF2l/gOtKMtFd+dAH5FzFr18a0ximN9hvhQs3++lpJFJZpE/PBWJSjag0HKvtAMHCkDDKFi402XsoMaMRxW+iiqBTP4GXANUWfZ/D/eFMXL3UwG5mXpXaAuiBBSknXKsl3qNhEMQsZ1ghoOifs5gTZ8oD6TaIhx53/SvJm+3zanDmGZj5nq6oQxaUAVassq/LFn+nSnmT1I3xFaNqhsVsQMNeFvcWIi82CSQSCny03nsUCokH+fajNEyE1o+4t8LNhtM0xcjLn3T01+NV7Ls1nb8/LkVSWmbp3/GwlebTaYdj9zCTHPnHjv8xJmWbLGarJf0AwbSmDEX4Bm+NtTBS9IiJ5/o1ICRHakVLInEsEkSjzod0QoGQ8hyqUOr0ygc7843If0Y1T6yfOgxCifqXg+MzWLSxZqvm4QkF+sgnub8tXRqIa9FPNPrvl4cORDGvwVsxMVwyJ7kWSv
 PA/IhVZ8
 gHXKUlWB9avgA+b/9HZtR3LqY9QexurTiG23aeF8ydytblL7OPuym3FH0MnROycwhbiWty7hMM/uMjOsuX+jo25V5/8QdjDC6Pv/VtKdfXtOE88dnkOSqNAwBDmO/K+f+NFAdjHnqoq+hlqr6AtGh+u1yTUc84GHCPRSNtETc4g4JyioWdd5g485rvMcbIh1IK+oBSBve1UpJe8q3Y9ZPCUFnHrrxKJJTf1wQWtbfkc/mla04kSMLaWMKyTtaiG2OTJtJsUhvm2AFbCiYjRDH2OtPgrf2WDa3NAOI8lzG29/9/XH89H2VHO2ssFcEIa/QmugPUMxnVQc3mrmYQ0m+ZZpq2b/zvCnaqyCpm2DyiZyRMYF0/05ZCQucTFSzj7qqMNZ3OQ+6tB+Xf/3Do4b+THjIINGZjZMo4+uTlpnRDth15whXyf1XSgDrgp5e5L+Ci7Lfk662iPCcHP6ElZ11F30n7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 5:28 PM, Kiryl Shutsemau (Meta) wrote:
> On Mon, Nov 16, 2026 at 11:09:56AM +0100, Jose A. Perez de Azpillaga wrote:
>> +The registration is fixed, but the tracking mode is not: a context that
>> +switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below does,
>> +needs the sync registration. This has a cost in async mode, because minor
>> +faults are always synchronous: an access that takes a minor fault blocks
>> +until the handler resolves it, even while RWP faults are resolved by the
>> +kernel.
> 
> Nitpick, and my fault: I said in v1 that the registration is fixed. It
> is not. UFFDIO_REGISTER on an already registered range with the same
> context can add or drop MISSING and MINOR; only dropping WP or RWP needs
> an unregister first. So the cost in async mode is optional: the VMM can
> add MINOR before it switches to sync and drop it after it switches back.
> 
> Maybe something like:
> 
>   The registration does not follow the tracking mode: a context that
>   switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below
>   does, needs ``UFFDIO_REGISTER_MODE_MINOR`` while it is in sync mode.
>   Minor faults are always synchronous, so keeping it registered makes
>   them block in async mode as well. Re-registering the range to add
>   ``UFFDIO_REGISTER_MODE_MINOR`` before switching to sync, and to drop
>   it after switching back, avoids that.
> 
> The example can stay as it is.
> 
> Otherwise:
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 

thanks :)

will change that. anyway, I'll give some time for the others in case
they want to share something ;)

-- 
cheers,
jose a. p-a

