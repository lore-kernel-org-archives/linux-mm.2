Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D5FCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 01:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5BC8E0010; Fri,  7 Nov 2025 20:55:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096F58E0006; Fri,  7 Nov 2025 20:55:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7A78E0010; Fri,  7 Nov 2025 20:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D20BA8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:54:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D05414064A
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:54:59 +0000 (UTC)
X-FDA: 84085771518.09.B6B8215
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4C74180010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:54:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jVpGfIeY;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762566897;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0ZmaZCDwiHMLTx2bSrUVe6Saq+o65+OA8UrkrTQnt4=;
	b=jaWI3oAnhFg38A9vtO+RnIEJ2PWtI/V+42XS9cPwXJxIbgkBXblH6lBNvq21jo/1yJhUys
	fT0d/AVMBGgAls5XeQwLLHHF2HR87tJuJ2SeXrqwwa4OKm+8VGoFmY1aFWgvrbDHRvAsdf
	p5WPyKU0t7sTkNIhOeadYZava9dX1oA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762566897; a=rsa-sha256;
	cv=none;
	b=XO1T5m33qBbZubewfUKEFMZvKy29J7+EjIUvZRu9N5kZIWU9P7y1dRqgkhcDiMY/8GQrwq
	bm5NupNKc+2hi88lkiJYmsBeVj11iep71/5QJLUXda9B2144P3fL70S5dQ3Mqc0mxhiKxs
	v0/8AvY7708UhUxz5Lh28DN+krfylys=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jVpGfIeY;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso1632821a12.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 17:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762566896; x=1763171696; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0ZmaZCDwiHMLTx2bSrUVe6Saq+o65+OA8UrkrTQnt4=;
        b=jVpGfIeYBC9szhFxgqX9gS8qECNfFLl+jJJYhmbaoHHvyklFsM+MT4AWtkJm/YuKy3
         M3jWyCbZp9SBuftM8+MJcqR0WsFOFSK1K1AXjG5Sp3xalg5J9YHTxNhJ7J2sDn38ZvTX
         YpPiqclLe3K6VDqYgbSDtEDT455hZhv9lvMpDqwn3QrEw4D+8cDNazacsTz8g/4BSoLm
         +pVBzXDnPFm618EVMaeM6u4Kpcn7DDOyuIHHpWePl2NwoyKtwGLlDr0mBU+NmYpWt5Of
         x2uJG0HbMIViT51jSlXx20IKKNvWRscCKkkZMLggMVn097Tjo3kUf62t31ARVnAKnGMz
         HzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762566896; x=1763171696;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G0ZmaZCDwiHMLTx2bSrUVe6Saq+o65+OA8UrkrTQnt4=;
        b=BdtDSn+jtGwkxtW0Z631WRyyqFsNV8151gy0y9RE9ju6LIBz/oK7UO785n5MiP79Ap
         hLOnM/1h9qOMXl/hJ9a4hJDZDhjKp5+wI7mDyhffJrkxwqPpUX+By13kvScEjco5jFpA
         7KkztOqc9sCHsxDcXVEqXv1o1xrkct5Qt1rAt/VRBf3JqoIUfzAICd7tmNXujIQ/p2nX
         2qEAMnJSRI/A2lYV+2nUPrHVvLj19cRrB3FumiCmrQB+C8mJyit/AWN3W1jNTjgh3A9w
         U4ZX6wDcfNUOLAK6OC65CvD6llldJT9v1iwPBi70vsvXv0/WecuQS14vE8IPzutka1R6
         JTpw==
X-Forwarded-Encrypted: i=1; AJvYcCVNLgFvDEoVBj/VySFRW8ooRmR7Tw0AsBpCLjCjkHxA+ZvOGPIoOmE/bHWyVIU1eVGQ8ff7S9xOhA==@kvack.org
X-Gm-Message-State: AOJu0YwtdDW7Qrg8/VH7nAuf5lLldhl3jxQPunN3RUW6/7coiDgp3ihK
	MilApERGMtoiPHed74TQWU2yKL5QxRVuvbJhaD30+iZuLXXjy9rm9RCk
X-Gm-Gg: ASbGncudriD85k8yiz6AqmX6PHWUobEhT6WJV5BbDiSWSgUXqxdiMnASzyoPLCL1+fz
	kUItk5qDiPFL6bLGuoomadE10zM/Fi+feHTW6wlo5rKQhEg10b4TP8oIeyuOGAL2Ec2H9SIf8MS
	oLovwbOoPdhYAnMlZlLQ2eEeZr+fcOp/fBWAbTEHZhWqoz/wLq3rw2G/4wSNhlDde3ZFPkq2rmf
	06opeMihiK/oXyy24pJu2Nb//ekKVlfylS2f6fyGfg9PfXVixQrvCZ2cmZbtwa/StVyW4VV+8RA
	apZWF+lgAPwNXLK4+QhuvmzpDQmOTLbyY9hWemQXH+ZuDOqfXbqGxvuprpobCy4E/bh6ON/w6hw
	talpMK+ltp9HRnxjGi7rGv0SQ95fcL4X/NwoB9+2GO0Ce5OSnjHNWXXVaRHOu+XIyTB58kZJ2IZ
	bDnFyBekYfyc7smaCd2ziR
X-Google-Smtp-Source: AGHT+IETDq1IeCw5XplonpY1pcN21ELAuNqusNEyhCeZTqp1tHeSu1woXZrdQ1IgGv97Z7tZaS+umg==
X-Received: by 2002:a05:6402:46dc:b0:640:37df:e798 with SMTP id 4fb4d7f45d1cf-64146c0cbe0mr3504024a12.1.1762566896182;
        Fri, 07 Nov 2025 17:54:56 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f813eb6sm5496824a12.14.2025.11.07.17.54.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Nov 2025 17:54:55 -0800 (PST)
Date: Sat, 8 Nov 2025 01:54:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 03/15] khugepaged: generalize
 hugepage_vma_revalidate for mTHP support
Message-ID: <20251108015455.qc244lvt2pep4t5f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-4-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4C74180010
X-Stat-Signature: hjwjieomfjc54ueoajqagb6te39b7uxd
X-Rspam-User: 
X-HE-Tag: 1762566897-739735
X-HE-Meta: U2FsdGVkX18N88pElk2pVQLpIkYKe/kCB7kO1WUz9G6iCaBQGm1s3FUC/y1YzoKdZ71pF1jHl0yuILKACXLRfUoC/w/cuRqciNPrnWDb0ankO5CSGOFulqSbsdROcd6mRxR2sfWC7sb1Yw+nrpv5BJYT71/Ot/pi01oyiP5bU2WdHH6yQTi9TsHi/KXywhRUBxrQ4lHPfMBRqSyAXkQlhEibr1HMFocWpVuvnh6MwyYk7QzLYtT4Lbw/iWE5bKehDncEb1JeSc6yL/WhWusVMI/8/EjymcyFDzpbb3gPvmoS21MYQkN6nlH82rM0UcIZYCI8tGkrIL+RvsxqxY1rQh3Lr65oz2960bV0IPzbLeCJ4pXeopHact4uAUNqgjMXPw0Qarqq6V0FrhegpRcyBMzKaLtaZJvKGCawFZmWiGowYD98fKPyTZrQ1CHN5iyV4eQ2mgcloaBT554KEGnSxn9q4cUFS/Yk6KSuXczjcWFZHMx/u8gSmwEYlieagZSxs9JHDR4WXzUn+K6P2btdfxDMezsAqCHDRs3p49xVntDB+mti9MP4z8KoJFoHeiN10bdB5bwbU5GAjvcutLxMpsJdfl3Ia0gDNtDLWcn9+wg6h81kXqkFRS7dbiLzz4ahSqV7G8XlO3utZuN22RXvFvUPWb8dPm8RM8V+IXbnaK9lJ5EwMOeD4m6WZrz6bGIbg3kQ8JKkrkiB6NW9xivQ3wBxtj9orheGUz5XsHqqfko3Sz42N5op9Jipsb1W7m3cDWYTTQxweUz8F3pOSteMHrP8maNoTOFjnWZXJtU7SQcYMXRu68hobG1J7Nu5fEUQYVl+wH5pbR00whL/AF1ew38VajthdylWFnJvIfsXLvbHiSNpMJopw9b1w143oOY76iz8jjz6C6/UpK+3jmnvG43uJy7uGCFQDrOfaCDMO4tlT4vicwmsdakeurHSBX7WP+TymRaGbOWWfMnxsy9
 opsfX3KV
 OSDy5PFJW7v+OV6rdpK68i5IeoJXNZq6FmPb17yWVq6YwqgF97w0yywLb00G50JC3qjouIpD7287pA2gTGSSL4SzTSr65So+mLH07VQHBWDjQZBMrrHnlKOeU/v8/bKRYJwo3X+jhMvg4yYYs1XtKh3LZm/MDm0BCQjC4vwdbJuqGCXJPXL7KD5YfF4rKbuA3GRsgx9l4uCqbkMjGsLIwyClSQv99Q+Z6Oq6zLxSXcWPQ8D6Nik6P9wKj5uCZkoT/ioAY5vRJurkKoNO8OtftNDh0SdI37jRydDQLvzwpLp0Jv90ZWwTNxxJmihfmLpSfZfB5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:05PM -0600, Nico Pache wrote:
>For khugepaged to support different mTHP orders, we must generalize this
>to check if the PMD is not shared by another VMA and that the order is
>enabled.
>
>No functional change in this patch. Also correct a comment about the
>functionality of the revalidation.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Co-developed-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

