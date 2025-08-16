Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB82ECA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 08:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C308E0012; Sat, 16 Aug 2025 04:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBC28E000F; Sat, 16 Aug 2025 04:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3EF8E0012; Sat, 16 Aug 2025 04:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 159B58E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:57:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B311D58CCC
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:57:58 +0000 (UTC)
X-FDA: 83782018236.09.94DB8DB
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id B02FE120010
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:57:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVi0+K8e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755334676; a=rsa-sha256;
	cv=none;
	b=gYpFttl4hKALanGvrBPzAHd5SADlLNp+fFhqq2Q3lQrQoC5YbSDgnyu05obHQlWBTV7PmU
	oi9nQor+cSbhnJ9P9gmStZ7nE1r1tVr9X5L6PSa63jtJ9AHQDJEpf0LKT9kmsaKp+GufAt
	MbcZGsbHyR65wYblv453CNY7FqSUEXI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVi0+K8e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755334676;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbTDbRBxjCpKOxae+f7o+xabI9Ae8x2mNceDuZpxrXs=;
	b=c82d1Rz/ldgn/ZqtRWY30D/nHZ/deQEW/wlnMiIdavhSmWZFI8epb55XCeScYIpYHTQU5L
	+PAYmIizCyCySIjkq0+TMULA1GwDe6pJXSoXU23Z+3fuznxN/ms+VWP91ivHMH8zs4AblV
	lZ5Zgp9kWJItVu6pwdxw6b0SDBld+js=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b70abdfso3796122a12.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755334675; x=1755939475; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbTDbRBxjCpKOxae+f7o+xabI9Ae8x2mNceDuZpxrXs=;
        b=mVi0+K8eqvyT2L/tMceeUF/AXVTI+pQzTL8z1OGBCfmBK2Vuy1/y8r4d6d6VdWH+XX
         Ww528YDW6tyv3/MyGe+ibqI2Llx5cDlpcWiUiI+MX3CGDQkxvhyWyTc2u+FO9QBWHvU/
         4dKaYOuk9CsxyrITy/ftnJdNZzhr9JCiCPYv+T/2Pgk8MErJ2ZLdCcc2wDy+FmXVNQrX
         HPH4yvxJahy/QoQOqtlP9ej4Q46MNY0ck7wDsTLmZpjAodzE9AhEOgqyGZJdrn9nquAx
         JYNXKIVmQ7es6XOG69lGCMjLFsnlPkegafS7Vf/zUAccye1ja8QzEf+4joYeNZE5DRIF
         2RbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755334675; x=1755939475;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sbTDbRBxjCpKOxae+f7o+xabI9Ae8x2mNceDuZpxrXs=;
        b=Z1V3p3I9FH6TmhKrUV8vAgyy9OmWBvg8HHUb56ruiVFd5cV7mUUCq+5aIqC02JDKfp
         pClifjLk9vuRlElrFnagIXqsNHTm5vwXPqkDZovi+EPdJSY4iohqSSi334T76A7MPUF8
         TLaAdeWDQqfQcVeFJPj9TTSdC+BlqUaIIW9xRBkcOyUp8HZPTskJMQmE+0+i5O1zNRl+
         bzLaO/u+Z9evXrJUUoVb6eXg6sfqNkHIc6rsVY1FaqsrA7j3O1bGvtDuYqkqrFOKoFo2
         3fBLsqdJxbeiaDLZ4pSU2ng/s/QWP1Z8Os39JZxTIdpon/FYJYPMmoCMBqRyCDs6Fq/n
         dzqA==
X-Forwarded-Encrypted: i=1; AJvYcCWSTU0AKeetBbsD6zyZgo0sznnPxeqMDcmPVAtwflArypax0lq1X9Zh1hb/rTxbys9VIArmnbhm5A==@kvack.org
X-Gm-Message-State: AOJu0YzB8DCHMde+tTWLPfIi7qy7k6ExL9NCX7EnJc9wc+DQbFJnYiyF
	8EwQfARgAmaA4Yj3B/twVzWCZfz99l7nqykU0KkDBufb71t3qcbDCo0d
X-Gm-Gg: ASbGnctsyjZDWK2SN1u+iZNXvYKuVEfK6MRGxIjXTYYX/u9vkk0HLICAlVvb2CX1TX4
	+0AmDhgLCTJVlxlBuyhcuRRGHKCEaf+LXKROd1GboaXMRVAWB9UdGBd7mGpoC/WcKXnWH3H4/iS
	5td4Pd5bJpbOMMlmYjiKoQJFT4XO4//mAdV8NNHu89V7nTQ4h3CYbzS0GlMnFgTbttsZDoCfkYW
	wHanUkxakUViKCtn3OU+ktFsnDi78PlUb6Ux9wvZD7XKKUr/TpJEeUZp+MFgAm3sKI3HnUzZLmK
	oN3hVI/98B1SmWDdEM8DR7b2zoh/IrB0GYFfhHeSMIa8fnjNmBMfIKm5k6CaKZyi7vsgLejTt0H
	IWUD9adZPdehk468m6Z2ISw==
X-Google-Smtp-Source: AGHT+IHJknqX8ig7QEwJ3CAPEcqW64Sga324j0AibDwU9lvoa4bPwXJczA//FBz+xwZt5LsXGJVodg==
X-Received: by 2002:a05:6402:2113:b0:618:1250:ac5e with SMTP id 4fb4d7f45d1cf-618b054dc5amr4521025a12.19.1755334674804;
        Sat, 16 Aug 2025 01:57:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af9d3107sm2983822a12.1.2025.08.16.01.57.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 01:57:54 -0700 (PDT)
Date: Sat, 16 Aug 2025 08:57:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 1/2] selftests/mm: put general ksm operation into
 vm_util
Message-ID: <20250816085753.n2zxaxilg5ghcljd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
 <20250726025223.350-2-richard.weiyang@gmail.com>
 <20250815064717.hlkehch75t6blj6e@master>
 <20250816001811.7f85b64fe8c748dcd6d47c27@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816001811.7f85b64fe8c748dcd6d47c27@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B02FE120010
X-Stat-Signature: qjqt4j6pezxi9g5juzx38o6rynccrygi
X-HE-Tag: 1755334676-892285
X-HE-Meta: U2FsdGVkX1/aJyvdhQQDC+A6WMRNkVCH8TxeUBWTRwfJmyfYvIB4htUNBZtBEJPh/q8otVJpdo+MZ44uqoSI16ugy9NLLUcsmOZB/ZXlLfrfxNITBDJHDxCRl1txjXU/IbR8pCX+r6ZBF9K25Vu6XNK6rVja97SpMEtNJHGSMGTWzmXLQqL9kpCZzF4OZ9vIiJ+vlQ+NICUCsYEMtaXxHrjjvaAyxfPkutj/8LcbMfeagmhP0jHDlmWmBsqt9NO5WmKO9hyQ3sVIbzgUhicX8GiHITlS4BE3xEcNRHY063MdJ4viksuq5wIwoVvmnC7h3Doex2hluSi1jNvAbIiyCP4RZIQvcRaL5j6SeclkkUP/3CPXljtcxupaLZND5E0IPCk5jQf9wclTOWsGRw/2Sb1fee8rgj1EyjgjCEdY8hELohPIl57vWT/gUD37sUehNrMN6gU+6wYwGqEYkQrZg/4mY9h3/du1cPisI5uwBxWbszFW1VbpqxpDUUSnYWcA1os3EmBwTvjnVdFrwzRP+0soFaMqfPXfBpwP1BXA5gDt5kse4hFQ1dH3ErHt/aDSPD8+3iWbm6B0wNewZu6ExGJij+JH2iZPScvWg/p/Kk9cxyw3b/UHwaCzBMn0JFPBY+q3QYWdn9XF6QRQCM8dcu0nO9uTvoQQnNR1Je8QnkGVRFFA9UygJx4WY8FoOrwze/z+aK7CgYgCehCTjZ+rtyoX8Y1kNgP1CLp+6OEx3aTNF9iea9ScSTBb1MgqlXYqSTynvpbN3eOSIiE6Uhft2hHsme4BKZ6bM4UFBIRXpX+j0T03AZEsBVcuJr44wc3+oKjtgUiWUY0v8Saa7BEwJwrtR2YsBvDYKbJ5S5sDSeUK8d9oIt5GbB4VBhTnwToPRsoLt5kpcr0/iSRnAIn+wsmj/p0/fmN2ZK8NOABCSO8f55HZ9S36L93PrE58dDlZS7Kn5J5v6GOAeuFb9ww
 GwUtrEgo
 s/IxK9uZN7BSfSVUv4KTyQS3S+ptXnaSpY9AtWvq93WbP9w4A+Ii6Cr3boYYGVK0UBaDFFIESEZ5QC7Nyv4EeA48wNzYe+QlYQ2nWu1MTHSzUR3rUhXxYPNGtqUlb4ipYrxrbFbd+gtgYk9JPrpGPY+jijw/WHNitT8sr58UGcVB+ilCdAqad/YAU1+KCAyg03snbQsJy84i+jsXKxiZBM8HFYwzdcvYYKYWz3pNPZxiV+7n4b8kN8rrZ8J+SHjZ9zz0RIHce0Ka/hch2gVPPAPVBfpudS5fmSgoeYtRknRMOVaSC4kEjW/NEQq1WWoHZ8WPdgHxvWkSq8gmwa3pr/u4ET4gZQzRXvS4YFDNMOyTfAhNKfSFA5+cRKhi0Bqu/SxGai1hEFRT8j+PdH+BYMYSHMthFm8a8zl7T0JM1+zrq11p5zIUFXdrhvxUdBQj1LCBCEPQYU3jFFNlEzsT1d9afuu4xrAgrizvH4OtvixLYnQsOCGsvFHSLD0dUkKEVhRNlcis0ROSO/GbyOgDT8jyMyjB4llDrspojP/XnK11W0fWwiuON1nJl0RW4jdNATHBb7MMBzsh1HD0/D5ZtIbKfFBMKsPdxWn9lzcR8uGJz396vI/NUSqs3ppFNiqbqn1CGp2w6OCPVsIIDugoESdqessj5gValVvzNlEN+5RzFKvYrpk05QgJAof1QHs6XB9ALFBzX1zyBBKQgXLclmfkgUpY62bhtfRtvabB/fqE89UC2SXMkLZCAYGGNiHohz7GBOO5c63kvXpcI+i4G6rfU/EbFeR3jciuuyZjJDsB2H2FksOgSVTACCGLXlAitY2Jf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 12:18:11AM -0700, Andrew Morton wrote:
>On Fri, 15 Aug 2025 06:47:17 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> Ping...
>
>Pong.  https://lkml.kernel.org/r/20250728020930.w7sv5eccp4kcizts@master
>indicates that we're awaiting v2?

That is a trivial error handling issue. I just want to point it out ahead and
wait for other comments.

In case this is misleading, I am sorry for that.

If a v3 is preferred, I will resend it.

-- 
Wei Yang
Help you, Help me

