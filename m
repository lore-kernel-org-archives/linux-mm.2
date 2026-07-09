Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993B8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900E76B0092; Thu,  9 Jul 2026 05:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1EF6B0093; Thu,  9 Jul 2026 05:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2EF6B0095; Thu,  9 Jul 2026 05:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 566726B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:15:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C66151403B3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:15:32 +0000 (UTC)
X-FDA: 84968680104.15.28C2090
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCF72A000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:15:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Jwgkampe;
	spf=pass (imf15.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783588531;
	b=mtxtlXCU+AOHiZzA3GdGCrJXLOHgH8D92wWXnp0qAsf7YEWK7zGy81y3ZH6dtYJvwPaUH/
	4uBiMrHQyjojnEXitfYJ3i+h+mGeISTRtsFyY+A6ZztDoS1iY3rEO1HBRup0azKxwX/DqV
	Il1v5gbvnxA4rCKrJ6iFmhwDr/Y9pws=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Jwgkampe;
	spf=pass (imf15.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783588531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Xo8vReeYi/VtYuebsK0R479nywgN1CS8NCBcmTm2So=;
	b=3xN1wkhU5VVwnB3l7jnVt/GQS0Gvj5Ji4kv9+58EqN+A5tpvRadudxEryJ2gfHYyRySWTk
	UekwKhXYKf6+Cqp9XJl8l6nrqeGj9lSJNTmFySOoRIYzBU12WKepKcdG55NfJ9yM5xs96c
	MM30YUuC2//EadJ5oUbdnFOP8OSacPw=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47df6a5202bso285872f8f.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 02:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783588529; x=1784193329; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Xo8vReeYi/VtYuebsK0R479nywgN1CS8NCBcmTm2So=;
        b=JwgkampenVwX3CNVv6j6cOlj9IDjQthYfbmBPna3wVdhELWRkfd5kd2DHTKoUecW/x
         l1FuWvXP8wkPOvoMBUR+zI6Mbr3qVsdodjlGmE1/ceMfF2VqmVpqA2eo8z+a6IOfZKcB
         6vaTCAiAjhWv6DQdJRttEdMJow6uY+SOOcf1TvlaHad4me1Lf2siuORipn+6mytO+ipF
         O6DB3op4aLMlNcHaY5iHGJqKbgEI+PXy48sLBXhcNR8APC4pyJFKbRBNHvUnlMLWCaz6
         qTmVSyi5zh5nBtY9n8o4nbQMoYbgtWXfSmtBJTOKH6YPfBxMLe3RvVfDp7uUNsiqK7Dx
         J42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783588529; x=1784193329;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Xo8vReeYi/VtYuebsK0R479nywgN1CS8NCBcmTm2So=;
        b=dtvCeG5OrQR1rcPQoEjZ9W9+kVYilNcmSAlRF/D2nTpIT7oKIhsiw21Wm97r8nVnI1
         9/4ry8zVmiXUP++jpOnGJ9SnX9VEnZutCXH64dhKljzzhPQVyH5f5KpkwvVRUwCYhDfL
         igICh4Bk1MtJN49OYMYvUN2klvi3xnniYf311Wi8fpF0MaZZ5dZJNie2ofxHQJkYeTPW
         yxT3cSjTCug0kop7393OJCT0PlZ161GEVgpJBvd4OSdvo/KY29uqAEhxnIAMAw239UWC
         Jwy+7AWWsE3yNniK/8UoDrg091uanA77p5GegGgyXWp028eWcmB9QgpEz2hoZLIcaDQM
         oGew==
X-Forwarded-Encrypted: i=1; AHgh+RpigNazlOeeJVjcHXEW/hX+xgeX0BqHsc3XJMZngDKjZxTqnleJ2rn0dzpn4R+jqgPMopE0bmAFAA==@kvack.org
X-Gm-Message-State: AOJu0YwOdHB869i5hXWkd8uu+llbhubM/Sqv+ySOrQQzaI3FB3ZTZEvm
	xicg97y4d4kvW+loYQh/KZYNFeKM2l8/PSnxUOQQQKYwmt7flRg3c9OUaTF8el04NcU=
X-Gm-Gg: AfdE7clXhiwinZPC+8hROfNEHGe5mJ8mUzu9l2xxzaXjL88aUfB7au7kLKkvNgjB/Tn
	IgbE5z+vBM9SDjr2jgWaElYZcenzC/+RUoBg5dsvBgSrNaE1LJMdDDjsaFQyafHO20RIPq4ARft
	VkofExH+K8iT9OEJ050LEHIMbREJ9pWhNRtu/USr9zHxWlM1cbVjcLnTj6rXShrgUp3HLRTwEs6
	1NGOL2TJVzM312hlD9wNbTl2AWl2QrNGTJw/qBKCJeF2qegSqYDsuBO8lcCqk7MHJ0C0lqkKerP
	IzJf/CLPrGr6UQqNU/F5zQQwIl3sqoUp+YDamJKOXMn0W29pv9vNX/kI5SAcHnLbtuJodo3/tdb
	Qqjifgs1upSTQzHPqiIiaByb8TVwnfVjYK2YPbrn9uZLksCvW8kxrPkfVYRbyDonEmbYtjxCkI+
	reSmhdBrHD5a79xaA=
X-Received: by 2002:a5d:5f51:0:b0:474:57f0:49f8 with SMTP id ffacd0b85a97d-47df07a988fmr6128868f8f.4.1783588529359;
        Thu, 09 Jul 2026 02:15:29 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960816sm48024686f8f.29.2026.07.09.02.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 02:15:29 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:15:27 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak9mrw37kTORZXmc@pathway.suse.cz>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCF72A000B
X-Stat-Signature: 7b83rnu6znkf1z38a6ujxuyfim97g77p
X-HE-Tag: 1783588530-22304
X-HE-Meta: U2FsdGVkX19yLzxHCnJEGL15H2mxOH9f4sp4EdYJj5+BoRFAjwfMiNwRKbq/cbXQ1ic3s0O+SyCMid046UvlHUHmYj9WXxMUK7BmMS4FN8RbRCPlI1T+qF8JULzRv68z8nI9Q0i5fcsCI3Lr8PraA6uTqvSu/cfDVE127pLSex/GEL/e3FOOwKOIKOaheeASV4S6fr9JRDq9mZey40xImQgLek5RBuOx/p2kBaH0glRSOvjiJHIoZXB5oj/P86ChcE/iZ/drL28JKQXfJ+9wIezVgYaRRniWori6mepse61ozMHQP+hjiWN3Wbad4kiGyRhJn3wM+yXz4ZTmZ/NcMMiAcHPQuHeLgRt821gnB/PtgAKQYlFX4hBdRW0CGNhgUs2N5IezG0Emj1mDWu72GkZ3pEi5CylrgokcKqHnhp6KNL5mFjYuC+wZNi3vcs5N2F0UeuGu+6TV2heEwJdRnNZB4JKQiDT1n9WTeNq0wrLCjjpj6mBxiFv5YVTAxQOUJSiat9qlwgZX6Y2+Jp8WycNwa8lAtMJp+djUxz1tScQk/Y0ayeSi4082c8Oih/y8Np1xjiKw5hDhf/6E2M0EVSbglGGxFgZtsu9y6tIjZlYR6Ow31FaZul9PIYgnPRb53G+0EPudCM1+YG2+k0V2Cg+ESRchGRzWsiSkoyPLJeAThRByOO7ynFA6YS8rVLDEw1uDf2q8OISMFiWrbs8dv24ruD3PEXJVHrMKDqiyPDVZYl+k9oY5clYa/6GbdGMU6qOEmEzAcore1YF/vHLD7mrkm/rqONRoLL8tx3sXugEfDpYK201gc+bBcqw/eC0iLL5cFU89tGqGLiBugdvWKAof/1iwvTMjNVvq3lyUEHs3YDKBqlLLd740eNegxb9wF5MxKjuyA8sYNHF6Zi8dyOavhvFs8IRja9r1lU+kBiUM7BsITqJLa4SMmpv14yWBaeWNiCY1mlnbcdgxcKc
 VKFmFgRV
 vtSFs/yvkJpDlGrQTbtHDcXk2n/haOLhAIjKfTd4q1c18g4NlDaBtIYe3K4NWdbKVnrnftuyrnBcRk7eJTLslZ3eyGg6yy2pDqGBAXRluVNSe1wQsPiyY6lBZwDQ8eRo/zFV7/JKPaEi7r8nUb/uLekn1nEidEbnKZfzr70ZUbOlKNkXzhnHB7kY9ORiya10hCkxmG0Gw7qdR3G9svmX/v6Q8yWHitUui1GIzRPaYFg9JJJ4h7jXfX7unEhcr39JqIYQCg9vVnSFvXeXiQwcQvFTkOCuJul1TfuMGBVJIcLhOXXql+C8ISjtdRauLNracJwy9KmzF/kod0I3OA6bmSRBMqHrJkPAtkR0fo5FaFCPP/cTPyEUj5wNGY8RsSOMzikuAHgtf2wcpMObkKyJVrviIWZv+PKnwKKMEOmfTxesMbkIty6iBn07bsZ6Hs0N7vjp4aDPzilO79bCJSzvPUhwXzaRL0JB8gx+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 2026-07-09 10:40:43, Andy Shevchenko wrote:
> +Petr, wondering your opinion about code dedup (see below).
> 
> On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
> > From: "David Hildenbrand (Arm)" <david@kernel.org>
> > 
> > Bad page map reporting currently stores page table entry values in an
> > unsigned long long and prints them with fixed 64-bit-oriented format
> > strings. This is inconsistent across call sites and does not work well for
> > architectures where page table entry values are not naturally represented
> > as 64-bit values, such as 32-bit or 128-bit entries.
> > 
> > Introduce a common helper to convert raw page table entry values into a
> > fixed-width hexadecimal string based on the actual entry size. Use it for
> > bad page map reporting and for dumping the page table walk in
> > __print_bad_page_map_pgtable().
> > 
> > Pass page table entry values to the reporting path as raw bytes together
> > with their size, instead of forcing them through an unsigned long long.
> > It keeps the printed output consistent and avoids truncation or misleading
> > formatting for non-64-bit page table entries.
> 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> 
> FWIW, you may move these to be after...
> 
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> ... this cutter line with the same effect on the email. The bonus is that
> it will eliminate the huge noise and churn in the commit message.
> Note, many maintainers switched to this schema (especially those, who use
> `b4` tool, which allows to handle this nicely).
> 
> ...
> 
> > +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> > +{
> > +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> > +		snprintf(buf, buf_size, "overflow");
> > +		return;
> > +	}
> > +
> > +	switch (entry_size) {
> > +	case sizeof(u32):
> > +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> > +		break;
> > +	case sizeof(u64):
> > +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> > +		break;
> > +#if defined(__SIZEOF_INT128__)
> > +	case sizeof(u128):
> > +		snprintf(buf, buf_size, "%016llx%016llx",
> > +			 (unsigned long long)(*(const u128 *)entry >> 64),
> > +			 (unsigned long long)*(const u128 *)entry);
> > +		break;
> > +#endif
> > +	default:
> > +		snprintf(buf, buf_size, "unsupported");
> > +		break;
> > +	}
> > +}
> > +
> > +#define ptval_to_str(buf, val)								\
> > +	do {										\
> > +		auto __val = (val);							\
> > +											\
> > +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
> > +	} while (0)
> > +
> > +#if defined(__SIZEOF_INT128__)
> > +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> > +#else
> > +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
> > +#endif
> 
> The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
> using something from there instead? (Yes, it might require some functions to be wrapped
> or dropped from static.)

Honestly, I can't see any reasonable way to deduplicate the code.

Most of the magic in the above macros are in the value/buffer size
detection. I do not see anything similar in vsprintf.c. The sizes
are handled another way there.

Also the internal API used in vsprintf.c is a bit tricky because
the buffer size is passed via *end pointer and it counts the printed
characters even behind the *end pointer.

But maybe you had something particular in mind.

Best Regards,
Petr

