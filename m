Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31526CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 20:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007A58E001E; Sat,  1 Nov 2025 16:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9D38E0015; Sat,  1 Nov 2025 16:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10AE8E001E; Sat,  1 Nov 2025 16:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEDE18E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 16:56:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53AE9C070E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 20:56:00 +0000 (UTC)
X-FDA: 84063245280.11.1FB80D8
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6BC1540006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 20:55:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762030558; a=rsa-sha256;
	cv=none;
	b=6zuqO2oiB3L7diuXpGB8gbsrM7eJbSL/BoyD1bNS/xG/0Vjxzd42XO3zQR8Q9KhesfRdbF
	f2XTlutNzq2uCefCrDGRiiz+vWziuERfci3HzXWTTU4BmCTk4s1PVV2tPVAk0xgABttJK4
	yM6/6u4c/b0lVIgY7psBYNFUyHfn3qE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762030558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AfDgklileJj3lr14BrRrB1s/Af42yLvNvHqicgRovmo=;
	b=rFUZxeOPgJm7jlO0+zNB1hn2s3SZnWswa81ATnOrIDdMWfjPULVMf+Q893tC6ilGwNmGGa
	I1WD+FrTJ2LX6f2jZi6xGECWzm91IZHEt4cXTTsObhOm0UNzEK7RHr+G9L9fiHYId7tQFZ
	ILYF6+KuhQuPYxYnovCAIpCpnb/+wRw=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-891208f6185so306155685a.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 13:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762030557; x=1762635357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AfDgklileJj3lr14BrRrB1s/Af42yLvNvHqicgRovmo=;
        b=cWHVKAQSRoaKirGQMxoa7lJPDbTI6M+0hKqgj5x/sBeDKOXlLvrMZaZTq6qTOYeX+S
         eXiN4D7hEBopFg7imkRXEqYj3T7bv62qsLmfQl32LseVPU36xpfA5AetTIHf7yc1qwDk
         SiFQgnuYHx45EKHqUP+dqanaUvKjaeDc9gSdmVtvy6rcZXaz6JqFAZ8iXbu0er2Um7yU
         AJXYBHIRGDp1N+UWWrFr8+mmXJfmCleEJH7R4i8sfHjwulC430P/KtcYkqJwmGUynb3Z
         kxL6E/BJr+QZsuWyovTmoC18GvVvQlQ6UYMxVn4+T60fZNzozq1ZoETeXAYGjsq8Uivi
         nIDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCkb6HmMvhFqEXi8eTM0AUJHLnUuBgZHZM7wMI10OP1m/VKxNP+iRUxTMEqJsWubEho2oCYqN1tQ==@kvack.org
X-Gm-Message-State: AOJu0YwjjipoY/0G7NGnvpwblwI/KUf41SwmTSTwYOWDBtZCM/k2UsLE
	oFC4/0390a2ttb3M7ZAVNi6+Nveixv/JCsdIPTwtXxZKiBkFkZhI3tPR4P0C8vPHbWx9gXeTrBA
	WZUxOGDEZCJKtqTUJZXhsTHQPHRV5gjQ=
X-Gm-Gg: ASbGncts3z7Bz2px5AFzSeRc4H00ARAf1BGHdZ06ZfmPPPc04oQXWD99oI4TDpyr0Iv
	fKtpYMi5K+fmqtOlqCrwWLeV3xaEK6rnsgkM0BSeloPZCALCpNY1ot2GCszfUq1BPvl9X4vraRG
	s+H7n5M+KhenrZ7d/r+ep1kbRlMoSYeFO45NXjyiDOREy6cKnXFIOpzTv8Le3gQNSY57UCiZk2N
	/tl/7cZPdh50U/pqzm2cR6M2zOXStsfGEVnDLt1nZxqBoWCL/FLjIgetPFiLDze3dKPIgWmYuU0
	h5IXfJDUWvdWSOXTRPYcI1snrak=
X-Google-Smtp-Source: AGHT+IGzPG5lX5aThng9k33S/kxhaAbv+L6NkZ2ZX1H0R/5NzYaAyJgIDthESW+zfDOjVlnDwvYfpphnupgwWMk59Ik=
X-Received: by 2002:a05:620a:3916:b0:8a2:71d1:30e1 with SMTP id
 af79cd13be357-8ab9afd09e8mr944399985a.58.1762030557342; Sat, 01 Nov 2025
 13:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251101134158.69908-1-youngjun.park@lge.com>
In-Reply-To: <20251101134158.69908-1-youngjun.park@lge.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 2 Nov 2025 04:55:46 +0800
X-Gm-Features: AWmQ_bl76Rp_bNve1Wn4skNzo75T-04LnBcw0Ef9vvWWi_6R1ItrxVzNuLbQsFE
Message-ID: <CAGsJ_4xJnVC-0zccgnB9NZUU15_oO=eqn1wrh8REkqdGjjsJVw@mail.gmail.com>
Subject: Re: [PATCH] mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: h86cm9fmgbfaujhxczi8c5jaurom5qqd
X-Rspamd-Queue-Id: 6BC1540006
X-Rspamd-Server: rspam09
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1762030558-806989
X-HE-Meta: U2FsdGVkX1+ZbFrskm2OY6MAbh0/rU4hfuBKJTNeYvoPXpVNRJ0mkPe6rBK89aUaRYK7XSXiw5OkvVNRQRkEjN3i8Nw7VP0Yl5JcHIk71kUHZHEDN45NZjAzdCqC/Bsqwt3Dun4tlMnl6a3iCP4ZC7g6/XBMVCyGAsScvRfA71jr4ebs4ClK+AXSh2ld3VfmEOWuafq0RFBakNFFlxaYJX1ukQ8nQ+B//UWnNWcluzvjQLkyfbkYKPi/bdTGK4F9QES3XNwLTGov9Dia1Vp7W63d+hj3q8LXormn5V7i+BucpCd4mlqsUpqQS1PTthQxqFcWb5mx4xwNOm2+7+oqbuLonSukY9oxb9IORjHnCsAirokU3kFoIVCCA6vOzF0Z7Y2Bkwoq2FNK9V5MGsYI8aiX0qkYjquz56GvKqzCPYDJWYnPON22IzrHOxex5pQ0aa/V6294tdFwHH5YOnj7DThNjmOLn1juPkkBDNXim2FTMZUd8JWHQ29BHKijJeNeR/SX2ifilDT0QAOA2bMuTHqrkLUFVmmUj/NSJviiWpqNC8Oef0MfkSvnnlTA9eLFyExvcMZxbQ07Y6UIUx6UNeJmQ84smZ2kH2RA3TDPJt2lhfP9wMppneuv8lyBG9StqB/nHwtdLVcAxSUyxxOhPhjK5JU0u3B2UhhGPDUicRO7c+OCOTPOBqZdPhzuFM9sxXqitiIeJolHqhCIDqeFHtSw2vjQuMusZDbJpvekOnDpZ8SfpY/lgcg5/peXbV8cY8Ok9dKfPr64Uw3nFE6UOm91uT7BfqXVBFN+V7lT9OLm9Do5XK9neKdj1H7PmYgC16DXrlakov0d2MhUntosmYlOdMVimlzbVibrD7FgUNhdv+TXzcMTEi0ZV6KN76dBR4LlR24tPE6KuzAyj5v4fAZXpjgyu4Kj+jSRKUVZ0xPsGS6NhHXuoa+4u+lIOq4rHXU8SexLS7kxQghUtno
 XYqWWEow
 in0FYouNZlolSAnFRUYe+mUIDAXvm5aMTkem7wdE5Kq1RZjodu+8itLi26P+8P1dZUgzwFy/50Cq9vglc68wYucqdVOK+I1kU9HjU0qfuZqjokqvtzwP2ql87WA9LeLzYuprc6BXgS24qeZ9z64mX1s4Eg/Sx7ZYqKyvkDQ647UFDfAQRMfRMON6ue1+ZndotfehdIJqR5H6hisIX5P092u4OAXqidl+RAZfDCEgPi+peNa00FpTpIx1IBpz6+LpQPMNuhFsIs7tCa2S4yfCldN93m6Y6h/MHtW4vwRHcTwgljIsJN3Lpb2+80fOn8/cXAVZ0xN8RfnDJJwWwiXbtQI0YJGsg4pMO21BchGcfBhfXSOtxEKTp/MU1ZYvdVKQSx0nF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 1, 2025 at 9:42=E2=80=AFPM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> After commit 4f78252da887, nr_swap_pages is decremented in
> swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> causes double-decrementing.
>
> Remove the duplicate decrement.
>
> Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from=
 folio_alloc_swap() to swap_range_alloc()")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

As Chris mentioned, we need to add Cc: stable@vger.kernel.org.

Otherwise,
Reviewed-by: Barry Song <baohua@kernel.org>

