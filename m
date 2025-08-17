Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EFFCA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 03:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACE66B03B7; Sat, 16 Aug 2025 23:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F626B03B8; Sat, 16 Aug 2025 23:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8624F6B03B9; Sat, 16 Aug 2025 23:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 721FA6B03B7
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 23:27:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C22FDB8BAF
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:11 +0000 (UTC)
X-FDA: 83784813462.07.52B318D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 250A81C0005
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wqrf+7E6;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755401230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=u7KWmbntLbeXGgQXLcgoO+YJUySXMZ/3VPi0OWYp2Lo=;
	b=LfwwaVDT/jkFhUEe5AnBE0xfhSnrIfTQpez6Gn8KqBuasZ8eKN8kG0ox+A8NUGZAxJ2L5w
	25ix5Tad5x9FZihQyAjsMGSUEAG4bS0n0n/3haV+Tnt0UNtmNlU8GE0IesXcqFa0XCLj/M
	2UX4+yEhgwDPOV78mogEva3eSGbk/zQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wqrf+7E6;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755401230; a=rsa-sha256;
	cv=none;
	b=JFwaKunHYvjatWsEaGmFh5aj7rTXHREysO9x+De80Y9vb0uCKshMmaBCq5sjw3A5lLOA4m
	u11bbeaK7cZYcAuK79fFdGizHOYnAcaxxhbM7YhB62dSDlIRkrLtm/WX7FYV1nwVvpr3dv
	Ho8vIhKVLLzfZhcilVVwdbKmOx+2v7M=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so4132943a12.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 20:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755401228; x=1756006028; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u7KWmbntLbeXGgQXLcgoO+YJUySXMZ/3VPi0OWYp2Lo=;
        b=Wqrf+7E6mVnu4GZFk+6P1g//17DbcaOoTH+2EfRDuzO09iD9cpA7C9ttmKxpipP7sQ
         Q8CcAS95ofkBjKF4+G+ES5pNZSHx9I5SNB9KwRxIJQ+wk5NchKGzSH22Yrp9hQDmCtsh
         lZpaDj6Awucv59hVOFY5njx9iLRcHfW1tiuRDz8lEIL0FcgYjOTl7cxE1FPNz7m3hX7m
         ZqcgDmLQ+kAeFvovWKCgPbIzbTCqrQXQcP30At4RHJ4DVYrOfvxkou88kaN0RGZ6H4Vn
         F/nITpjCfOlzxAQNFsfkdF/fAcO9bg5n1pt1FsiBhwO9URTrGJVZ7UxYxLEmz3JtDRFY
         /0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755401228; x=1756006028;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7KWmbntLbeXGgQXLcgoO+YJUySXMZ/3VPi0OWYp2Lo=;
        b=KqCulPo7nYyZWnJvN770DcklaSC+yRDS639Zn4dnXSv2QuMb0YoPmFUqgFZTEuSJcF
         fJh6Jb52AwTkHNK722wPBZNAr8/KOKoFK6hVQYPryRmpFSDDKC0VPo35ZY3yk6E4+ba5
         tsxrXWhUhuTpDcIdypCs+1vGkNXD+o13SQA6ZG7oC34vh7sQlYw+WDEq3JGL1reWbA+6
         ES7u50qs8OswdvfNstr4Qk0fXG1V2TkvbaM5l845EpOvBJxSiMcl4z+hKiMuv8iWJS9U
         HM3aSy20SJu344KH754Z5mbxSS7H1bVSoQSYh9P1K3DPArHzE19EMBkT/D2YUNRjYncL
         tQFQ==
X-Gm-Message-State: AOJu0YwfiNYA8fKPbkSw2TeFtPOxahhWkKEDy7vRItnvz4c5OYDDaa+E
	AgVbeZFCP5IUxfrpq1D2IkFwo/QLgjApiigUTwRlOX2qM3M4BCi2FSOA
X-Gm-Gg: ASbGncu+Y/OKjN9I0tSD49NZQClTbJgfUGtC811xo8YYFjyR95OAEc647u6Jyuuofu7
	3XvZDFTNOkKopdVQZQCQEe05JcQYdfHwwG1f/j2Mhyn0Hf59RLA7JpHDe7jWC6wLVFOUZLu6Fm9
	S8Xfv2pggd2bc6xOZDLgEaDx01B6Li65TpRbPxRVCjVEQ11ZVoheI23b5Et0UQbizZyYVnqPcit
	jNz34dVcCDxOJgXigWbg65lNczqOqVYkyVhkiGOPOcuVRI6gC+nUDpD6lYokR5cHzUTGVh426DO
	3DzZPRnGewa8agJ458KfTjMXGterG7jF7rJBY7bc1yOVA/GyPATwbBHHN7A7X3kIXxU+xsZDEqy
	r40MkKHv0kL0H/kahrckqXg==
X-Google-Smtp-Source: AGHT+IHIiddSEu+wysTOHBi56pygCoW9L5b0zALdBiwavrT7lbYTKyqMPJ9MZ/TteKkZT+m6fL4zsA==
X-Received: by 2002:a05:6402:440a:b0:615:979c:e89f with SMTP id 4fb4d7f45d1cf-618b053a729mr7024474a12.8.1755401228259;
        Sat, 16 Aug 2025 20:27:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af89e28bsm4367961a12.0.2025.08.16.20.27.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 20:27:07 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm/rmap: small cleanup for __folio_remove_rmap()
Date: Sun, 17 Aug 2025 03:26:45 +0000
Message-Id: <20250817032647.29147-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 250A81C0005
X-Stat-Signature: buwjuim4tncezkzgk7mmzdgfjf6ozajt
X-Rspam-User: 
X-HE-Tag: 1755401229-557482
X-HE-Meta: U2FsdGVkX1/Ogv3ibGngF+UqXwCmvjgXmZ1pShrRVMplykAKyJqP3fS5mmZafctY4AsRsE9W4M0nJEBwyBxqzhyWsSr3BdQfP1FoKrtgkVIRbTHINmnYhxfL9tIOLLQDkUm4UQ2Z8zNpdFSBaD3Fh8d38tHScpUJNgRtozPty22AJnjCDpTQ/MX5hpAEOo//O1KeAj9MpO0rvkyPeEttI7rS7fFAdnvnsIaDuWJmJyI/0X/1jvy1FeT+Hw3eNRRV5fT4gryguCPbmYgkFJTzNpTlX9UeGG0x/kGkQuLpDlkQ6IAsfJax61LUt56QEXoNcd7ju7eV2VRSb5w1ZpxUOvYpWwly47Gba7QMa3JZKIAerb/Z9d+1te26sAPWOKU/dVcLR+kH5od9OZeaSm6QKh42iQ6EwkTJpgZqNEjolbTnYKLIVkbkCDCcMZrbwdOXdlSAts2/uTuTTzWPu3wH5C4pEWSgGQ4CeE+rYrUGXJiasZ1Z4seYBVmHVYjXiMh5qLUE3H3eyy+toTN3K5C+mOFMXdV3EuD5eSxswm0B8LuraFeKGv7XV0IddUsqxZqOl9W2F5s7/Hh9E+6zu0r3Oeo2T5X5a7RJxZ6stbcRuI4oybOuF013YOAV5pLgl5nqxclsptonsed0pCi9/qa9QVGuk8OE672xVdRcv20STR1X+zllxD43ENa9X1qGd8ZMoINwbE0ar0bHWGII8q39me64b1/k1t46BtubrPzxbenfCK6gNm5D1frKSJr/xeqe8TI5SDW+xXu1yFsTE3iXqxwZ9UqohAXkYWjCpuMIcqZjJRHWoQQCynSOQhWV3LhE4IZhoND0LJQYmTd+IzEDxYJuMS9qtMYgPGofCnPMho9r0tyIUTdCLMr/4d4/+nDnksRReuWFvxPdPEOudNaEUdyP1a95N+Dwy1vJaRP35xMdfCNqL23BFD4HmXPyi74y35gfMkAxAV2cAsp/mmU
 1dZroWZC
 W8TDcNt2Srsv65MqpapHnrqOMNjGwdQMSnZmcC119VRLx3G9371w6USU51EJHCPKaqXWn5QSYUmymuZWKILUtwVgz0PrsbBUITiFOxHmlNzFTSnkp3L9YjThZ5PYOkttWs6tdVqEYyOzTaQjTPiHn+Hz4KjdtZEI+xT9VK8bHDZGOco8CHLO5kKlKjBVfM8vkwMo6xHHM+9S/10Mo7KrOsbwfJzUUvu1Lu6hhKN9Bq7Q9I544G1NAJBml0RngQz0EKpDvP/bT/I1Q0nyOX8YwFIZ4w6cA1mdUb2hM6gfbvuEaUQGMZ7U57mosXydKyrQ2NAw/iDXEdZFV5ay0jbdYQhlWFCRcJrCy95aPXTLZP57IGj1/v7yiJDpMl3gamg/dgxHtle/JpocNVAOiVHYmJGzHgOylGIYr6ArhHfU66K54gSbRugcb7Gp1B9+xUJvWwlCaKMS/rXPTFRi2iI0fUq4pztxpwNxQEZ5/lvawsshugGpiV66IN2xcDeSnSf9uZzj0dPGokO7lAQdKWskIe4ntfLpO1haSlV8c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During code reading, I found some small places where we can improve based on
the knowledge we already have.

Patch 1 remove a mask of on nr, since we are in an if branch conditional which
implies the upper bits are already clear.
Patch 2 use folio_large_nr_pages() to get the nr since we know this is a large
folio.

v2:
  * remove patch 2
  * adjust patch 1 changelog
  * adjust cover letter description

Wei Yang (2):
  mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
  mm/rmap: use folio_large_nr_pages() when we are sure it is a large
    folio

 mm/rmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1


