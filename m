Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C29CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B4B6B0260; Fri,  8 May 2026 15:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB986B0261; Fri,  8 May 2026 15:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9E86B0266; Fri,  8 May 2026 15:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC12E6B0260
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:32:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C5CF1C0A84
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:32:35 +0000 (UTC)
X-FDA: 84745249470.01.C38CD65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A77CDC0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:32:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNCDjxZc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778268753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoXL00boMWSJPiFPuWJL08xIJ8152/4OdYJYDlYhQew=;
	b=SHdKhaHbO1Oy1P0oLJbHLW9gCJInP2nDzMPeIxEfcRPn4Y66tTBRme9nLnoPHIXiwqabD9
	uEzMuAA7gVy93VXXSk68/kKsfhI7WoURY64dc7j+OZU1noSzp8EIHC4FKLUbvDhY3SiMER
	dyliKs9MR1yNo2wUUhuoByB+slne1T0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778268753; a=rsa-sha256;
	cv=none;
	b=oeWO/ciZ7jRICxJkDwhqCFyU4lYmj8F+SXWrJtjqYQ18x3vZglLrk/tGQcP2N4jVFdDAwY
	/82RF50E4+Yftf+lKQ1QvSJ7Gc2wtQMXed2ZyN3q/IoWGL9pMO6BN2NbGppqxOmw9fTK17
	waFXiI0OWL3TgsaYOh18xIf53Flkh40=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DNCDjxZc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AAF943D17;
	Fri,  8 May 2026 19:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D301C2BCB0;
	Fri,  8 May 2026 19:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778268752;
	bh=mf3xIXdCzeOhP9frGFps0vjsjTjlmNGDQAPmsKzCUKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DNCDjxZcWWH8QxOBe9VogEAa6lyUYHy+XWyKY4sJLh8AjB0g9eRDd3q25RxM3yf8/
	 HpKOx2KY4FR4iWM3x71bFYY+FptpZQHI2/TFTqra49WqaM/mFfEju5124z9daB6KZ0
	 cXmxg1IZqDr6GGpivA/7b1e/NviqYKFR8LJdO5YvTbJJ2hgozCPOuUS7iYJnf6Uq02
	 WJlNTnc1VElzA3tu8x2M4Slvd+ZnyWT2JlnX7qd2jarhHLBWvXXUs1MIwiWWft+CmZ
	 2110p64TIXwwUon+NTkaPJrIYrWwrzjJp1T217slHRQm/dIT1tAW7YB43ExMmTBbq8
	 rXK4tRcveNvQw==
Message-ID: <b6717dee-486b-4c61-8ec8-0e4269959469@kernel.org>
Date: Fri, 8 May 2026 21:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: use pattern matching in .gitignore
To: Yosry Ahmed <yosry@kernel.org>, pratmal@google.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260505152228.124065-1-pratmal@google.com>
 <CAO9r8zMWmk3HdJOW=DbtCoZrTjjFJ-ErAwOvG=8qG9bL00Xwyw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAO9r8zMWmk3HdJOW=DbtCoZrTjjFJ-ErAwOvG=8qG9bL00Xwyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A77CDC0002
X-Rspamd-Server: rspam04
X-Stat-Signature: b96p4ckjbnk3yxf96hte94hjdohci66g
X-HE-Tag: 1778268753-663705
X-HE-Meta: U2FsdGVkX1+7Gk0kxmdbZeRpHJ79GQ0OiXgZGaqi2/icI0jnR6k3agTZ39h3Ilk23y8PZCPRc7Y0X/T1JFWEn0j4PTpxYGJbZsREQRtKGjsRKQRCKsecZYog7lIskDEAXBDMssHJY2LsKt2qgZfdV3Z+m/sCKB30Phwg8SEx/sqSvhU6TRgA5qiZjUXENPRLVAFIrJxL6YnXRC8k5YCdHUkGbs1IFCQQEWc9aey+PNmN1HuWtD7hrckMlKMTTBksCyj4HooqZlaDkzem/BPmb3hpjOtMpgO2/M/GAtLuNsfZ+igfr0z49VKfS3eGSPZf9Mpxgy0AE0w4xVcI7naSXI5nrc4AxLeylZ6GuKjDDboPMU9/eyxR7+LCuEPeFkEMhMakkLqliZtWLDEWVFb6F7PFJRoqNsJDRyICblXl/CA9FJqy02Sz61LgpAnG2ZQK3N68Crrxgo6RwisqrZPsd5yc1PC3vimvjtWaIepRdATxt42Uqfl88BJqtGqIv0SClc1iRTf49McssuW0nWHzExxbfOm4J9D+mYuuPzJC0ZiIjRGzlFnFwIkqP0qD2krtOlGbZX5EwWh8c6VDbkPldKDm2hJR9YmlJ80o25/LDryjn2rjETrDpfwT9gto3FUzEELRQgGKnq0vOADK5tfZMT+SqAgTkAhxaMuYuxY56FwhMtGF3oGe4U8ajvwT680ZVZwRGuKSP3LTlni4SGAXNFu4F1uYY/+a9IalUjCeUd+3M+yh+6r6+yJrdX/ySAJRJSdSROZ/3JhYAghxnCagOH7RSt3vcVDivxXnCYqS3oJIQGh45lBB/zl3bd61K5FyIJw+pt8SQCRhmDhAIVqe7qUxQ4775qOuekWLFZgY1SbdSEWgWAMqdqZuR6ej6DJIZoqqC48LNpXStdcM25w0raBrmmKsn31Da20Fk5uC0trIRabNj9VsNi2QLNTNnqAzRCDQfjlPxP5H3cFeE7Q
 BQoIemSF
 6c/eQHHlK58gt5fgnBwhUmyUhu4HZ4tkMhbfr7QE+Uue2UWnDiMbQog9J9EdL9+eOGqqxi2gTfJpMlHJW4rVasgEUYO35dwY8aIfLCwYYuAIiD2lwwIIHxW6bQcHK+ULa83Q+jozXkRN1ou/p/Z5OkbRcGMKjowo0SYxKO4WrcejoMY32dtVEZ44artZ4/4uz7HSfsw3Jr75wWOOXt1tDEhsI4+OjvFiTuKmGPw8miS77WB3PVwP5cyqVp1p4mQ2v4IvU0JH1RRrMvBhB7BkaZmviFuv5Le8dcK/nm4opS/CPK9GXeAPrblUmwyTzpUxVIs0+614ne7D9e5+Lln47XtQY+0V2yE2t6JH5NXqSOD88Cqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 20:34, Yosry Ahmed wrote:
> On Tue, May 5, 2026 at 8:22 AM <pratmal@google.com> wrote:
>>
>> From: Pratyush Mallick <pratmal@google.com>
>>
>> The current .gitignore hardcodes each generated test binary by name,
>> requiring updates every time a new test is added.
>>
>> Switch to the patten-matching approach similar to KVM:selftests.
>> Ignore everything by default and then allow source extensions (.c, .h, .sh)
>> and tracked non-source files.
>>
>> To avoid un-ignoring the generated headers, rename local_config.h to
>> local_config.h_gen.
>>
>> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
>> Reviewed-by: David Hildenbrand <david@kernel.org>
> 
> I think these need to be sorted out (as I mentioned privately).
> 
> Also, we probably need to split this into two patches: one renaming
> local_config.h and one updating .gitignore.

Yeah we could, but no strong opinion from my side.

-- 
Cheers,

David

