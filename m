Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC746E66895
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32ED76B0088; Fri, 19 Dec 2025 16:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3176B0095; Fri, 19 Dec 2025 16:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194D96B0096; Fri, 19 Dec 2025 16:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 051AA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:34:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C11D9B8B85
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:34:25 +0000 (UTC)
X-FDA: 84237524490.16.3074A05
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf11.hostedemail.com (Postfix) with ESMTP id CED6C4000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:34:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9iUgYXh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180063; a=rsa-sha256;
	cv=none;
	b=3SIIwTl/kuSnMo26YVV4XfkJKJm300PpPjU/Ifyi85DyPZ7ysyJ02ScC8VtIXx75sgJIR/
	7zS92bTzU16nNQB4zU2ZuIim2Bl0MszIi5l558Gcc6oia8scD0VN3M2sar865HTFa6EkaL
	LHDfEP2j+I6dbfrxfGyHSUA8actYQEc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F9iUgYXh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t32XLNtILrSHOTsv1yzEwE7SsXS6lnNnHJdt9fn7tL4=;
	b=RV8MyE/B5lYemqS4GTJTj0pMMHaBSgB6ZmmQPUL0JuNs1ti4sm2mMaZbROT8V3i6W5V983
	xeUk3BMDJs7OaRZa3xgZxKC3Cr/bfRZP3bd7CcslDx1iLJL7PnNPOLWZjWhOPKxIXe4dRQ
	ZKaXTUqELl6cif277hAoxbxSfezqsOQ=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so1353829a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766180063; x=1766784863; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t32XLNtILrSHOTsv1yzEwE7SsXS6lnNnHJdt9fn7tL4=;
        b=F9iUgYXhy90e6P/fqsq+HoSttyDiIqCAKuBRBn1cWFINNu4HleTzc0kBU0RowZgg8j
         fYGpRQVSMZmQkn10r6j1J08caRGPaUpsO1pwC6GtOr4yDRGMn9YWeOWP15mvCE9F4mF7
         K0kQ+5k9nH4jnr/+1gtEgvDdiSftm7ba6XFb+JMTgCkU5eC9SDix4+z9hAUWfJxW+B5Y
         SXX6+bDu68eFBYQ0aJXIOGYyosMREQ6qb9/NsiE8wlIywKInGQxOreBOmWxyJIj/m7Ym
         x8FzRIvEisCEj98Ni5RciOrukb4EFZNxuqNnCR+EJ5SZVDGgkPul9ySjvKRjDHUqzrp4
         SWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766180063; x=1766784863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t32XLNtILrSHOTsv1yzEwE7SsXS6lnNnHJdt9fn7tL4=;
        b=uXhSFSnyLjmeWCCPD0tk/mskxwM2GyJQYBF4zFwfmfA1Ac25XFXjLG92GRa/KCoxNy
         2PjJwk55m6aHYwb2U+zAAuutWlkivU0UmROnAHBg7yBpa1cnGXPHb/Kp9+3DSege/Qbn
         bRPSSY+N1CnsFCpa6xsgt47NYqlsq4rfAGmmYmly3LZmb4dBIq38CqDO/SW84RGYSMF3
         yAADO0zZtY7q4l6Htk0Qg0XubJKfUqACmvMR7QpAP4XlYQpTsh2LEtM+iPjqR4M5ClOz
         fEKe7e4BqcvCUIR50RiAuEiuSYTdwQnNlO27yXJ332CHPyetkjwZrlreI9XpseAmzcPg
         bCZw==
X-Forwarded-Encrypted: i=1; AJvYcCU/cMom3n7g7UvixNTlrdlahcQ+W9Yqe3Zy2SssoieWppTHh6zOgnbdq68rUaf95d/kfeF5IgO/BQ==@kvack.org
X-Gm-Message-State: AOJu0YyhAZ4uELPKE/KRpDVDZ08Q4ICVkEMbjFRQNE7RgM5b/oA8hDTT
	IDTo5Lyqw3aoRhtOp8eXspE+hd7cRDpz9qlrId2UC72wm8DgNHRmmLxA
X-Gm-Gg: AY/fxX5d2M9XTb7D8eIvDUfiHZOSdYlJwBW0VskWLi1NKeiuLb3hg8RPstxvxH3fvGU
	N74OBqEv8a2N7YQW8alpdlL9oinnJtv2GfLmS1KKU7O8C71yqA6GWZRiTQQlcVXw7Gc4qS9QNDj
	+L+omq1ACNrCK93wUchQ6dGUJMXcpdgdVSVfo57LtO7hcvouozBk4wDHSe5s8IMuuIeC+5KEUNq
	VDuV2iDGDRcX5ZHB+s6GYXXgCvG9/Yq+BBfSpXMyEU9YUxx0MHlIC9f2CJ3ZB+jvfr4x1CJdCUn
	Xk7s3XrD+antTmxzIMtSZ04F3wjghJgzTdfclqsZ1e64q8vrXAVI7vVFHjeqp0CV0xtKNggcnAe
	xjwhVYxXhXjgkFFIucUwjTMVP6I6u8gzCvUhz4joKz2VqWIc6gXwfHkQYhBBTWKTXCBSMxVqMjL
	zsDQzdqV63a0zZ3m9hiC0bDYpV8ioNMg/QAsnj1IR8juMCJy4dAW+MdBdfCVGlaUoBEZlZRi0VE
	b1estovG468bgBdeJq/pw0KrR7UWi0OqUMcoa70h4WrI+jkYSdYebcMILvLcnyS6W5uUrQG81go
	VsI=
X-Google-Smtp-Source: AGHT+IH/ZQYDLQv8GePcj2Vm99oLZ3hFWnPTlzcp7/sSDr5k1uCEDV2wgPs8dBIcnq4Eb4hflvIUSg==
X-Received: by 2002:a05:7300:b54b:b0:2b0:57ec:d1a1 with SMTP id 5a478bee46e88-2b05ec745e9mr4652797eec.25.1766180062475;
        Fri, 19 Dec 2025 13:34:22 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fe99410sm10155463eec.2.2025.12.19.13.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:34:21 -0800 (PST)
Message-ID: <0088cc8c-b395-4659-854f-a6cc5df626ed@gmail.com>
Date: Fri, 19 Dec 2025 14:34:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
 <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CED6C4000B
X-Rspamd-Server: rspam03
X-Stat-Signature: ot6oqwjurrxuqb58kjr8kbektucjf1xi
X-Rspam-User: 
X-HE-Tag: 1766180063-450996
X-HE-Meta: U2FsdGVkX19heaQ6etZi/uB1EHsG7iIRosIX+TDPLWFLb/qi51uTjh2c7U8QrFPNc7QZYpdlfP0clH90rb0Dl0GkhoSPDxFGRm56CXWho6Xy5UCitss9T/2TBqQdRoiEYq3b+G/9mAQJfcPj95+dpG8pKFZri42TMsgXM76e/CC5B4BZ1Q8AoR39TNjt1QVu0VSMrfHMwPt3SRuiMEbkDb5tJLj+gMlfwSaM0h+qYbA5s5aBysY6EpHXkCXnGZ6ieSVd3/uZLC0ruGuSbxLlrx1FVdM2O9Fu3KO03ij5YvxPJJbYg4q8MMc8XA9vMCd7rT5CqAY98we5KcUBIhvJerGAZdfBgcuAOboHVu7c9/ZrHiMeGWJOoyBMJaN9OT2Ecxuh8dfmheUqbol/BWCVuG08orjyFqGR5b4CSh0ivgVmGP/cx4hx4KrgIHWR5NU6IJWPsp7sX5MXiTj3lKrgyL0AN7b0m1tnE6/USL0U5xGRHz26Zcf705ORcfb9j1CD/imRcWOrKpD1lEv5q2Hts6Qfd8K3ggvkuLd+e0F0jYL7ZF7ZjKIm6KyAQw0SKS2vcGLUvdq3+tJU5FEG9xG7kvHvlGzzXbZw+5GZksLFWZEKwEwxh+loXk7UCZTXVMcqpTEwzkicqPYHsxAOA0MrUqYBN0Tpa1BVMhcAW7d+K495oPeqGPlLa9xnW+aJxlOv3GIs9tz75QL0pYzw/Io/y3j+xuX2LaZ91ml9K8zb9Wps86AyWNM0LAk1NIdpQDhOgV1Rx6QfWu6r7sw4hJ692tE1J7vGzErx13Ez4FpYKUEYRconKI46PiVnXAw6jOChkGGQXATaUiTY/038e8RxGBPLm8UAPV4YYa99RXG3FUBZ/Y84Yt4MI574avzMMkq3COgeIpyjTUHTSEDwkAuw3ZPU38wBOecP50pQzUrM5zvW/sJZCLqgpaClteTDh9+snQxxSg4CENTJiF4JBy8
 kIKCpLLL
 +/MjWLgOQmz/UPoBVSth2UtQHnkHsn82fY9P/iGd2pDI93S1NXQZ56L+acp3YPZaAmL2/6QxDT4P2B2L5AzStChJfAfrWN/enTx2Ns47FM++IiBPvCOT2gdWsv0ixcripymoREwghUjDFU6m1d5rEFgv9lgGYCTaKZmI1/M7QcU8a43rMjM/ccKVKnTaDRPA0+e5FpJMrxYgpWEsziU/AnsG3Jm+gKquh56BbOd2dV0darJKPiDwzbVvHROLa5sAwiiX8h2Cu+E48Gu/Ji7NvmSj2+nv/+U2de43Mrduqbgd4PDtKvv/g3YGqF4nZ5UC1bZNMalSgdIaOsycyo2iSiD9UTGU0pDA3uqM/huGrORUFNhBaZMskj2nwdseqjQlNZ+1OQRWm8L7D0gDfjqorw8kX6jjD3j+xFblalnGmYpBcDO1jiNmXIru+fxK08VC4IU99ot3as253k5xC+1VRNRL9DhEICinf2xFCceg5PSOtkxZc11+LB4qaJd2tVV8PEEFWvMl2GYI4nTMpyLktmkz0bDMo313J5fYejbSQncbkk5BoM94O1tJj6u3g0pdjnx1GpsqSV/110efbyywFl1ASXPy7G/HB4h4Ix30EUgW3rdmXvvladtMlfLhJ9hiI3OKoO2zZSTmXSOZvc8hry9TIDBOPfH7I+HOoNGHGoG1F1BX3FD0QX5w3frFmT8aX7J3Cq++ihzQOlX86Lm2mRugZAsOwreyrOCGrsRq/E2ISr2GweDqrHiGbL5XMYOxBSGj4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 2:02 PM, Marco Elver wrote:
> On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 12/19/25 7:39 AM, Marco Elver wrote:
>>> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
>>> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
>>
>> Given the "one change per patch" rule, shouldn't the annotation fixes
>> for rwlock operations be moved into a separate patch?
>>
>>> -typedef struct {
>>> +context_lock_struct(rwlock) {
>>>        arch_rwlock_t raw_lock;
>>>    #ifdef CONFIG_DEBUG_SPINLOCK
>>>        unsigned int magic, owner_cpu;
>>> @@ -31,7 +31,8 @@ typedef struct {
>>>    #ifdef CONFIG_DEBUG_LOCK_ALLOC
>>>        struct lockdep_map dep_map;
>>>    #endif
>>> -} rwlock_t;
>>> +};
>>> +typedef struct rwlock rwlock_t;
>>
>> This change introduces a new globally visible "struct rwlock". Although
>> I haven't found any existing "struct rwlock" definitions, maybe it's a
>> good idea to use a more unique name instead.
> 
> This doesn't actually introduce a new globally visible "struct
> rwlock", it's already the case before.
> An inlined struct definition in a typedef is available by its struct
> name, so this is not introducing a new name
> (https://godbolt.org/z/Y1jf66e1M).

Please take another look. The godbolt example follows the pattern
"typedef struct name { ... } name_t;". The "name" part is missing from
the rwlock_t definition. This is why I wrote that the above code
introduces a new global struct name.

Bart.

