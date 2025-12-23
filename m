Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3B8E6F08B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 12:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DCA6B0005; Tue, 23 Dec 2025 07:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1BC6B0089; Tue, 23 Dec 2025 07:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7934F6B008A; Tue, 23 Dec 2025 07:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66ED66B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:29:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6E72570BC
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:29:15 +0000 (UTC)
X-FDA: 84250665870.17.4DCD43D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5DD480004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:29:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FIIOg+3/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of dirk.behme@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=dirk.behme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766492953; a=rsa-sha256;
	cv=none;
	b=HZ3CRj0C0ou1kF1sSbp0+NDmuczW6PLCEFmJDMeKXfoqglDl3wWfi9GAMKS2VGhyBYOBn6
	JLYJpXEGoT72DgkOLaBDlYTGMAbIHQkweMu8b6nWsUm406Fkc+ZeoSyxOP5m9gKVa3rL2n
	xD85+DKV4au8xg1PHczHyOwdYFt14WM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FIIOg+3/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of dirk.behme@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=dirk.behme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766492953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5xTlcGpdeyQEFa92rXXck2wdXNlODn2lhJvH8AYtz8=;
	b=7PDwPfNOFNeS1dcPKKLwOkxWyVhMEkb/4HHVKUDJU6eRPGRQF7kri4ruFlYaWwuMGAyr+n
	JJ5poHQNEoJyZQWM37WKu7DJ92B6Fe1pLL82rhSpEyqEUnk/MFyiyeX20A+S+CFZVSjx20
	jvRJ96VwcZAeLkTvPz0aQZuOEEuiiLk=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7eff205947so704695466b.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766492952; x=1767097752; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5xTlcGpdeyQEFa92rXXck2wdXNlODn2lhJvH8AYtz8=;
        b=FIIOg+3/K9k+YRq8cJ7rfJxPtSvpYjljJV+dryOeE9FdNGxwDZjLGOE0+pPV/nYJJn
         XrsD7JE/Oj71049AH6pjgHqqkGG8BKzLBI8Ml0wZQBlBAnkFBbl3zkDuILW7IQnm97mf
         ScIl+KScNhHVFKiSRFjuHGjrVfJ8EaBVpanfwTvD+lCgipvvN+tFcOQ42ptcaxuZu2xR
         06H73RoLqjJOpu1je5AQK0+l8wyFZNcax+BsR7STu2/6W8YeAqN9RU/T6JyfESTK/1ht
         9nwa8Sf2JrceOpRevp5dVpDE/Oq9vex5nSNGMHwH00fuiBpLjLuQo9/3lXm910pMp50N
         kJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766492952; x=1767097752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5xTlcGpdeyQEFa92rXXck2wdXNlODn2lhJvH8AYtz8=;
        b=d5PCG0SLG0uZuhXtftF5+xXq42aAOktIQyuByznS2N6gqaRL3GipgprXK4e4QB8aS1
         GA6HKTzKtZeCTyFIGONCS6Mee2NR+zn0FUfQz2LA+XVzarUBVOuESDmIv6Y2J2YoChXA
         Q7RVeBXdsmeH0hz6kboaEj7nBQ3O/K/Mo/aDflwBqe4YRBtTbQ8P7shUuTh9izuJBO49
         BLBBmVaFFdNqgInOYr8X1YUps77/HezTcWPAw/C2jV1AuKoKLlK0Qpr7kaO2YLuD3sVf
         ++DQJBc3qhQGdgSnKEG8yc1KrJwONSCXmnaRk8APDs3/yVSRfHq9dzPrz/v4DJU34P8G
         SH0g==
X-Forwarded-Encrypted: i=1; AJvYcCXeWJGGBPcDy1GyWIC/pJBasT0tX95jQzipYKwnhkFudHTX0r1zdQsnLLg3wJycfPp28fmc2PbmNQ==@kvack.org
X-Gm-Message-State: AOJu0Yyt0lZxH0usUUnQK9D8rrGIldMLoFQk68nzuR79LfY6LcE2Dax7
	ZZFCZS1oXHIMHf3z8xbYVIt0WJt+xmUX/8iD6dMtru+flKC7A8k5+638
X-Gm-Gg: AY/fxX6iYUxJehjLOb73BcSXf0wg5Vxsx+ajGUJdckjR3SF08lKYSG8TmTZFGmIiVGV
	vnwez1C+pgd8Tw4cUlu5MXmGWPidrgcMNBVEp0ukJCyMhL3C3demD50divg8EWXmykw32ovHKwI
	tb2+Ff0pnjrill7qF373QE6aUTkEiNpWuxSRBj7MGd6Yv3lpWYjHBVUtaP2WqmazlsTS+v5wSav
	aNLWb6ulsa21O58w0IJssrEIxlLahKnu4DFRiXXHTZuhTwX/7Irtp3SI41R1n9bfoDt6Vfe1LbH
	+81vkdf0xZR1/QgUk02/3ypkQZo+X3glh/03Ypwp4QlBAAh1mN5ZBfWTHrCxH0MY4TXn086x0FE
	EnQG3kDY8b2GEjtkD9bPBxA2VxXF1/AYZuWiKC/AUx7fFQ0L1zBgE1kvqhATWLzeu2m0XDfl2pO
	W2KYQQzl5Ypf7FvbTh+ZmC+ZN5f4ICA0G0N5LjUI1thynAQrQb8KIHktzAHMh//uaUnXYRtlEYa
	NnT7s1GQctfo3HyPxY9kQfB12ROLPA7nQmqPf2SSrPOOw==
X-Google-Smtp-Source: AGHT+IFQKu463Ws0DeQGqtqtFbIzklz16SbCW/WpuT8pw8rwR8527OOqWdhaQqGG2VyTUZbhKeJ8Ag==
X-Received: by 2002:a17:907:6d0f:b0:b72:d001:7653 with SMTP id a640c23a62f3a-b8036f0f183mr1343019266b.19.1766492951664;
        Tue, 23 Dec 2025 04:29:11 -0800 (PST)
Received: from ?IPV6:2003:df:bf2d:e300:d174:1f34:13cc:be92? (p200300dfbf2de300d1741f3413ccbe92.dip0.t-ipconnect.de. [2003:df:bf2d:e300:d174:1f34:13cc:be92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b90f5400bsm13550782a12.4.2025.12.23.04.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Dec 2025 04:29:11 -0800 (PST)
Message-ID: <46e188a4-4b74-4206-ba18-f107f45bb98d@gmail.com>
Date: Tue, 23 Dec 2025 13:29:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rust: page: Simplify overflow check using
 checked_add()
To: Gary Guo <gary@garyguo.net>, Kari Argillander <kari.argillander@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Dirk Behme <dirk.behme@de.bosch.com>,
 Alexandre Courbot <acourbot@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
 <20251223115726.621bfa38.gary@garyguo.net>
Content-Language: en-US
From: Dirk Behme <dirk.behme@gmail.com>
In-Reply-To: <20251223115726.621bfa38.gary@garyguo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B5DD480004
X-Rspamd-Server: rspam10
X-Stat-Signature: 9z754k97iuar9cdkrhnfayjmte1jgy6i
X-HE-Tag: 1766492953-684265
X-HE-Meta: U2FsdGVkX18JqJMTzf0yUU1hAr5kJYFddYUQWiI/+EpAECAWWchVhkC2sR5xlMyxx8d3IXXCPhJYgxTxcBsWcqiAX01ajFbta7ZL79Uedieo/UrH/O09y4Vtz6zOgeD92I7xmcQyXsw/28VEujEopL4d0yJQ+ik9fasTiZGnemGNd8vrfDgyTOEKvcQeVk5OrlWHm+T/JJYjMTKMu9mT2WuIAE0Ud7OG5IXppy2JCzW0+ByWMdb/SyV8ZLZVacMgqZL6fUuEKAN2Q41WfeH91EufBsR3Gtc4GNIoSquGY5nIgVuCRqx7RO465/U0RlPvli6EE2vPAnhhc3RabQCe2jgqxdeg7kuhl7syfZpNq71Px2IKqHu9o9oUJPU1BUY3a/6ggucjeDZQJpe2mlhp4uhICiRxWKrt3KOBQqfFE4WCeWd0rXTc5Blh7r7+p9ywMsiGW+I0kgXNjb0tD0nOF6A7kXKRFq3iR1aMIieK3qW8ysZ+lbBZaxai3AdpATJv0+3OH7Sdar25msDHk8BPKnLRZGROfOrebYQUVn/Znd0eu/rjMRYP59F6WFrnHzI0O8GMGjYpx9uSObpRjfWoiGjP4UrsuBwmRtIA8vnPVnoXEVVpNIFs8iJ8xZdl0F9K0fxv2zyZPcuN6r1Dt6fm5CEKX7tKZpwetzSoymYiJT7nW8b4vYlGzyjHl/37qRVUjMR5OVz2qqgdcou7dp5M0c3V0DYqW2wlUwVlr1bVxdsyqTeW5e+6qOzkscdqPDhPH3Q1q01Lx4tcNAeVhDJWYrKc2Rx9m6Z71GyKvVD/Vs9xRDqYtHWRwaoW/YlyPW6HhZIHlqTTXEvIR+trB7lNaJqmAhwZ2qwxRVs0U6SEQzJEjUWAxmCSxlggCgKHCwSYF5etQgJkUW5KyCza3qVSm9QKLXo1oYemBBogpNpJW4Ie9jSpYn71/735eOeUvv+wny0bla4tTk3fuPXUiLZ
 5H8l4N1L
 NaAGwo+51GPEaOD4jOSicB4HriFjV2KV8j3lSZShGV3KNhzd/V67l+/afUAfxoILICVYYCe9CGqZwZO4SEia2dSqD00kzouSYMxv+Og5kYpsp8svaC4s9mrAc9RNqNhnL9+UoXEVYkIE968h00oT1HKyNKpcg0ocO5eIbey+uOUbyjkbBKrUHga4per+NDK3RLAlj3oeDYyFjt1Z3nVYpGWzc4JKIdaK9XGeUDiqkXe7tXWxjcHl6+ZdXvOE+yJDEOKtiMc4bgX0SkTp8msaXEFmAMS0npMsqqy+pNhdyDWW52gG+tQM13noBdy9Vy1xlfclZUWIfxfZT+cItmQFL1kLuUnQiD7JsKm71bmUn5E4ZP9xnzRtAeYHVa5z+zqYeByJcp+6YcVI4+gt/GJR0hDJDuhyish2HY6ZqSkauRbpB/YgPemhAReiPKowIrAB5OH3rFyyrmQp49QUzVaDTyZqtfly2gqQHN6xrWF5LMGTcgbUhWIq3r9Eq8ovEzehXrr2WMzn5kehzxDtitAG713wJMMjLNeWrV2AD+wwzXjuIojoZWF3iV02JmenaK9RK9moPCX85KMB2kQ3oXWs3HozzBqNMbRAceD87Skr7ucBRqLst7KwPJT91J+vslIWwjy2CD5VyLBBHpg50rfBigzm8Nf+szot6L1VWaP+Vkr2BO4aJlp6jJMMnlb+sw3m6ekQFzfzaDWe0k8hHZ+sHpnSQTZuPQpmKUy1hs8LgbBOmF4xh8+aNv/8Ffg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.12.25 12:57, Gary Guo wrote:
> On Tue, 23 Dec 2025 12:06:17 +0200
> Kari Argillander <kari.argillander@gmail.com> wrote:
> 
>> Replace the explicit bounds comparisons with a single checked_add()-based
>> range check. This avoids redundant comparisons, makes the overflow case
>> explicit, and results in simpler generated code (checked with godbolt
>> for x86).
>>
>> No functional change intended.
>>
>> Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
>> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
>> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
>> ---
>> Changes in v2:
>> - Added MSVR todo (Dirk Behme)
>> - Link to v1: https://lore.kernel.org/r/20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com
>> ---
>>  rust/kernel/page.rs | 19 +++++++++----------
>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>> index 432fc0297d4a..cd2af7e4c357 100644
>> --- a/rust/kernel/page.rs
>> +++ b/rust/kernel/page.rs
>> @@ -239,17 +239,16 @@ fn with_pointer_into_page<T>(
>>          len: usize,
>>          f: impl FnOnce(*mut u8) -> Result<T>,
>>      ) -> Result<T> {
>> -        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
>> -
>> -        if bounds_ok {
>> -            self.with_page_mapped(move |page_addr| {
>> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
>> -                // result in a pointer that is in bounds or one off the end of the page.
>> -                f(unsafe { page_addr.add(off) })
>> -            })
>> -        } else {
>> -            Err(EINVAL)
>> +        // TODO: Replace `map_or` with `is_none_or` once the MSRV is >= 1.82.
> 
> I was about to suggest just enable the feature gate, but turns out it was
> only added in 1.81. That's a fast one to stabilize!


With Alexandre's `matches!` proposal I was thinking that we could drop
the TODO comment and we won't need to touch this file again once MSRV
is >= 1.82. Opinions?

Cheers

Dirk


> Reviewed-by: Gary Guo <gary@garyguo.net>
> 
> Best,
> Gary
> 
>> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
>> +            return Err(EINVAL);
>>          }
>> +
>> +        self.with_page_mapped(move |page_addr| {
>> +            // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
>> +            // result in a pointer that is in bounds or one off the end of the page.
>> +            f(unsafe { page_addr.add(off) })
>> +        })
>>      }
>>  
>>      /// Maps the page and reads from it into the given buffer.
>>
>> ---
>> base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
>> change-id: 20251219-rust-page-check-819ccc39c53a
>>
>> Best regards,
> 
> 


