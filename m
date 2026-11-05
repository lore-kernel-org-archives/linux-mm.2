Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC7E606CFA3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kuAc3Ioi
Received: by kanga.kvack.org (Postfix)
	id 599AB6B05B2; Thu,  5 Nov 2026 10:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533F96B05B4; Thu,  5 Nov 2026 10:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422216B05B7; Thu,  5 Nov 2026 10:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0696B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:54:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8010C0A77
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:54:49 +0000 (UTC)
X-FDA: 85401513498.13.6268011
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 044EF120008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:54:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuAc3Ioi;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793894088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylOj/sHLM/J8LsUi+7lfY/iGOYIA2kXtXExHrYGKdI0=;
	b=muWOyh4ndcNN4RWf/guST41+CPX7kcTuguDSI8oRGVYDNOOKspsIt5lE/5PUx9k4vonGNo
	WJS0j902lkKYhXD68F0L89Tz2wALsncWkF1lDJARu8mfECWmjwB85N/G1C6C9Vjjts46cB
	ySHdC0ymQZinPjocNjD7U0l0zOQD9oQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kuAc3Ioi;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793894088;
	b=gLWEycTPnFhJeLC82WoS3HXfd5pz5XabhsxpVAMQC3QZ+vPmiP0FWmT6m8MV9x2SypgYVV
	XCfurDzYS6cFpnuoxU4l83vMYy3Jr6TcJ3vY2qr52VJU9Pr/N/pDMTEWgRdFbhZbMQ3aVN
	LDnwfNUiujITcJXPqksAWZD1FBsqcgs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F8456020A;
	Thu,  5 Nov 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE21F00A1A;
	Thu,  5 Nov 2026 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894087;
	bh=ylOj/sHLM/J8LsUi+7lfY/iGOYIA2kXtXExHrYGKdI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kuAc3Ioi/qwDnV15Z9C4aP62dVQFe+TuOpqiRxJnyC2rmCo8+4hvpGzigjEUGeqhk
	 6Eh3nbCcJ7Emyc/isrygR+z6bKIlNdRis4XZL+B1xH+CDudtI85iXDi0oS3JNC4LHx
	 IMAav9xQFTEPeAqSXBCDu2pYUOXk3lZNIhaMtTX85QMSn/exiSdUJqWmTXkMSFMJQK
	 vBGT+NotVD+sufMIYZwu+fxhaUXXO8Y1+A6Q+JAANLI6boLtY9IYKV7kiliy8G3757
	 ZZzfsyn1nJgUops01v1xFiARUCYU6dGtbAACrHrSrsjrS1EvgLgX5dQveajOdg9EZK
	 w0M6+vFfb3/tQ==
Message-ID: <bc91b6e5-ae31-4403-aee9-34b60ac83631@kernel.org>
Date: Thu, 5 Nov 2026 16:54:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
 <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-1-8bd88551f9be@virtuozzo.com>
 <26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org>
 <cfd786eb-4ae5-4dcc-a9f2-3eb4b7e7962c@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cfd786eb-4ae5-4dcc-a9f2-3eb4b7e7962c@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rj4dfzpikgi4csr4b1bg8u3uod8hgjc9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 044EF120008
X-HE-Tag: 1793894087-868484
X-HE-Meta: U2FsdGVkX1/6kqaQka9jMwETameT2E4t7JV0nlEhOH7cbu2lFtkzyKt95QcIXWA5gIdx5vkiwK0mGXSBgHCBzgytAcvCEYvFjKGEggds5q4tGNct70sv/WdWjH/yHW+/lrstkEacX7zQrEMcW8iPq0ICvsLuAu+9bq2OgWzfOSxdqKw6yeqb0F6DR/o4oDQUrfa9ZQx6t1fzkn1Vfg2/svGHOfB8tB7nXtiggh3n+tNg4QSjPlRRf6p/+/oaLrXvZlcoxsifST7mCWDEHFCIYpBAyYTHlS4vvti/NwrIPvw/DqpfxtvdQo8BSBv3Tjv8c9RE6nv66RcboJjGcPn9itG5U6MDQ1kdYPXvjU8LEzKLbkuaNTxQf700/TvpJ846o/6oEH0MaDEQ4Y1wH9Qd014lwW1FijCyqYzslHfVibK6BGmJrztV/vQXhXKZgj6OmD0Ntpk70zDLtdl+blQEJ06U1cSqwIkjFZ6g8pVianOR92xudSSKTralIXIfSDYjzDpOkd6nL1ODCZ/0wRkDZUpCqFV6rB+e8w9kw2jFuRKw3lLrfRfw0dlYx/8x2qQSvbJJF/IWfl+1ePND5QI1bQZFeb1f57Ayt6+D28T3k2wMlIr3WGv6q4XPpb+ZpAXqfBHGsXL3sHVAPNE5IR5hfHm4tWc0BiyUR+Yd9GWTG/yaL9pAAE9tLoCS2nX4G7zoqv7YmgmT5beFaNOv+26IBOZ6ua/v2vKnbLpmO8Mcagh2IarOcLA6F9Qw9pIAvayJflrMG3qAd0Va/KwL0Mt8NTY9jgtw7q/O1LpY1UPOohNXPk3jPjF5U/m1agRJZvl3nfTUDEXZqz4hxET9jsweiDX2w/erl2ITUwRmEa4GRhej+MpsBOuiWTqm9WkaiBcmjOw0J8DKdHPkqY173GVfqu9UJT8+GJuo6cigNLXZx+yIooaXhCAkYw9RV8JqFBPLXMM5mTHMAgPdXgvVvB9
 klqhxKjp
 ujE1H0DZ2mjz+OWWojVs0UyKP8Yr1/Crmbgds5ajpZ0LlRaDPtG804hve/Bbm4Hmv7h0ZFYq3rgG/mueL+2+UOdOO8J3z2/2BcHmdwQK30QpSLJYdS4ZSCUWEZU5vnydbaVAzRu55bbB5FPwsvKveseYFNQIoeAWJs7ZWqtO5Y520H6n+ASPQqrQ5YikRFVYoXcfL+DZ2+CLPdOw62X8O1wTKoALsHa1FtXREJrzvd5KXxVtsl4ScVcg/HKRtG5/uld6xFcqAxRF91GwcusGtXXKdH/kzUa9XfWasMkKKxxcuXy1Zwy8oiw3m8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 15:19, Konstantin Khorenko wrote:
>> Introducing folio_dup_file_rmap_pud() is better. But please see how I move
>> the comment and how passing mm+vma to the helper is not really reasonable.
> 
> Thanks, agreed on both. v2 will pass only the VMAs, with the mms taken
> from them as in your patch, drop src_mm from copy_pud_range() and move
> the TODO next to the rmap duplication. folio_dup_file_rmap_pud() stays.
> 
> Could v2 then replace your 01/36, so you can drop it from your series?

I dropped my version already, so please resend and I'll queue that one.

-- 
Cheers,

David

