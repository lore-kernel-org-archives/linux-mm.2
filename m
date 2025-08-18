Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7678CA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478E58E0002; Sun, 17 Aug 2025 22:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450D58E0001; Sun, 17 Aug 2025 22:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E0A8E0002; Sun, 17 Aug 2025 22:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297098E0001
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:21:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0C3B160720
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:21:55 +0000 (UTC)
X-FDA: 83788277790.07.850DF93
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id F3BC910000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:21:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SQ/EYUfi";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755483714;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2VQ98bzsRDXPvAwzT0crPvEy6KznXXOPwFqZG4IBm8=;
	b=BxX0KnMTuIECoNW42jdXDztrzTDxzBro0etE22zoRkGwszBgJFd6ECKogLcAAvULHcH5fS
	gJIp+w2ZGr3O2Y6cV539ZpAd2RO7c+X7hiXpCIMVGrgg9CoMfk1UUR+kNBJLS5ftu7DRsV
	jpRIEuQUk83GpyObAxzEwf4eEOiaHw0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SQ/EYUfi";
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755483714; a=rsa-sha256;
	cv=none;
	b=A55PSIoxCQEFNhgndTlMRjdKnagakS/WQxIDY1GDIAkjWU+dXV1ONCTPd8A9YHALOg/8+w
	RuOygfMKrhHY+lm5FsZ5TgvGzAkkg2fm8CxYVTSz8rEQnnxT/tS7vHdMSbiV7JOPuI2FXE
	B6LXgFqUDpxEdQihBXQM3jMtlFMNoK0=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb7a16441so556827866b.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755483712; x=1756088512; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2VQ98bzsRDXPvAwzT0crPvEy6KznXXOPwFqZG4IBm8=;
        b=SQ/EYUfifKNIGRYiLKgjuf7wTZUO2Wc74+YUag2gP5uCUXI7Lr7VAWjAmzUNLZNa5v
         1zBKzOLAQzhALxFMkRm5DMuO0Jxm1n5kXIe9gxtuhhL2/4u551kKUudhytRG2Mp2hImx
         dFWeLyrcIMbVQNJtaYFlJfFaHMKhMkMbMURxGgQu4WMHNL/OqsWcCR04jdf/0a8PpTcB
         FnkPYkA1zRPtd7ozI7mRSMe9huYAZ8jTu5I4R8HyUV1fPsF2fSE/UsYnZSdO5bghUgSE
         W1aISlj82SoHlzJqLEUodfIHe8PCnJydczAHL7+HKtkfsCvxvo/TcC8E9+Aj+i4uxr1V
         A+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755483712; x=1756088512;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q2VQ98bzsRDXPvAwzT0crPvEy6KznXXOPwFqZG4IBm8=;
        b=Ukv8c8QLlyFlX7kjEzzqkjoMmkguSmJBO4AMdRMVx20VjCB8XMkvUIHSNwwXjTT8CZ
         fZiOtudExM3fqr8CzYKNCgB8zfGR8U1w7zfs5XltDODbE6YvbiGcHCLBXmsQg2p/qCQs
         ngY8hSOxtDoW7igIDVjNqirJoelJne63qRpM6dXwJfgn5dK+AJwXqBv+AqWR/XoixriU
         h2dUHsDbL97ukUyz7BD0TG7H2JgJJp+axWZh05AkP966M16Ac+40v9LIJZunlYR8Bfw7
         yOv+KH8emlAaf8N9I5RHIOwGK9e/QAE5UywSt6Y7KJeXdwgzg9rKUVbsSAkxL1G0Nb+B
         gDng==
X-Forwarded-Encrypted: i=1; AJvYcCV4hmSY40viF7hK4OlBIw1nQsml7BaoUxRTBmgWlfB9MHbytGRob7oX6JC899BknMFnpop9dfIYnw==@kvack.org
X-Gm-Message-State: AOJu0YwBID2jCl+8RUbvi3sMqthjWYF5efba+pN+0uS9/f2FjJwtMIwX
	2Dd25BmGTDYIf+MjQLgqBGKtO1k44kAPqBr2mmt0Jf5jzJ08XaWbuqHw
X-Gm-Gg: ASbGncvdrPJxJ8WLAVCFJ3VKZVaidgWOF5wIoq8VLm+AyZFKyU/B7yJCqEj4GBX51/W
	8a6p8BQWiW404UvPKxFx/KlsFlUjZN3LRnezyhFS2AFrlORudDrksRt0UeJvVBNcOpHRssGyj5s
	VquXlI+rS1VBH+qy3XMeM9+E84PvqxqU53meC5RL7cv/mP1tNT3WPyjNWuCggFSSXg5kTQS60ut
	kwANCKYmuzSQ7rrZHeHA2iTTj1q9hKAO4UUo+pfBn+LGysCZj60sEI64eW2Aouymw9NsDUEqIyw
	48VvnJvtL2bo3LEScsKI11TQwipem/Rrw9ejGNtBgedWYhhEUwGDJeNMRdgYCeghZTNnlNAR9XU
	1nr1VlWQ7Xl1USPMbrwbTwA==
X-Google-Smtp-Source: AGHT+IGCxA/VqcVLY0AVEKjx4rmARnHxZXfwdbsFkdMFUBCtf43iqxRJcpDlvvvotEKLAkQnR9l/yQ==
X-Received: by 2002:a17:907:1c09:b0:ad8:914b:7d0b with SMTP id a640c23a62f3a-afcdc206127mr929984466b.11.1755483712007;
        Sun, 17 Aug 2025 19:21:52 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd04fbebsm702038066b.115.2025.08.17.19.21.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 19:21:51 -0700 (PDT)
Date: Mon, 18 Aug 2025 02:21:51 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Giant Sand Fans <rampxxxx@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"donettom@linux.ibm.com" <donettom@linux.ibm.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
Message-ID: <20250818022151.c2haj2njkmsgbuak@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-5-aboorvad@linux.ibm.com>
 <20250816143129.u2rdwpwvfhsdptvx@master>
 <CABPJ0vja95qLmJA3uRa3MhCfDX3GoLJ6MHu881Z=sZuVdBbbEg@mail.gmail.com>
 <fb4d74b9-a92a-4040-8d3a-09c72db3f35a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb4d74b9-a92a-4040-8d3a-09c72db3f35a@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: rajqb8kxokuqiwn8fm36ea74jp51k9zp
X-Rspam-User: 
X-Rspamd-Queue-Id: F3BC910000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755483713-835519
X-HE-Meta: U2FsdGVkX1+LdVymZgQog5ynD8i3kJfxWFck/RdYp2a4VZjOAEVLs09ypRrWe5WmGQIZrXUd3SVSTAo6CT1aIy4LGcipvwnxgEG9G6kPDMpQUliyt1EJN6L9b5BSIZusfU/RbNUnKCPnX3nqIjWmiHplEADGcpZ+MDBvxlVxUdSQu5BNC9CgkXBxyMwKUQSYptvYhGO5savBTGrG+lF9hVD/tgxaBiSnG8bjBFuuMDRGHAgXZVeqZdfA2QYdYH+RrRp3/0RG1zumuMHAHK2fy+E+dZaNIC1oau6ZBJc/EON4Ml//dsve9lp5RJykJJgCCKZJEZqLNbJWL5+1LzMoSc11DH1Du9msZelv/W8qgN8DhkpCQCvCqK6geYHf67ObosRBRlz5yE/lJqv4SJNOW85KlhHGpQCVvUUWVJ+elfizEtdegpmUk4LW1CzRjH/QD42MKjx46k2vlGWXq0i2Ep7Yrfa2XVVLlA1W6q9Ht772w6V3nRPgaWsqHuMUzZmhVbJuPafefQSQNBCVTKhO8An2c4KDa8N7XpUeK5alVotAuNZuDcBGOMIzoSmkJPI9S6K/jr52SOA1sOiceZnX33kihzQOiYDKIBr4doEJCWfpVmZS9yq+L2tBeQpk40BAJWWkzS+ax3kDe6sXwIyH22F+XBLMDVu7k70a1gmSRleuz+dV81sp0OIKY0ssFnx1lhj8K6wmLZN5uKC2hXOfozZ2g+htIsfgeeu04At3En2Lo9oEzWtRGMYb+qhSQDi11hgtakQcAY47LaKwrhYtQIdqEE981Ps4pm+8RRGb8Toc7lbxNamkCr9BZKNKRk2hD1BujKJ0DUG/A0nRu16huxVDifrJMEQlt8pPGOHD3qFMUCXsn1KT5NAQ9o9MZjJKs6x0O2YfpCr/mjUFvzY5wkv69EnLKZPVKeuRjmxmy8EfIYbMBIryVCBXnH22ZEsxywWDkU61Ob0GgQ7CxnF
 +5pakSKn
 rjeM7uFacUAEXUEKeOl+ZTH8JUfeNBnVFkcR0lfYUqqMGvop5hXWCSeDH7qd8MaaxPpTUmHvwbYydSwjak3iy9xTmlQ4sNhnH5fvuiUOWDVLBHNFmlvQuoxrm751BiCV30zulzY/86R4sNryq8NlDQUKIsXqyh9AwpR+8xqlR3h2jvo3A9fLlfQYqqn5x2eZG6Xd4i1Cn6r6SNe4CH0B9de5vCxdqjneOJcWNX5I9VchskeWRpqAMTzJHLKbVaFp9bl8ATHIsprKsmeqmDNcdJpCUaXnkNop6MCfovlmI9ZBdEm3/mdXL5AJgucDdk7ESVm4++KqI0+NS8efMQ5ZQrPsADB34YGBFSnOHdUa7DECwyI9RRksDR1l8zEiZV17zurT2A7DJmVho8rHbczVD0wm5ozhvSqkJFAE/zkWQ8cGdqj8a0jCOEqS6D976m8e6MH5l5Xp1ibBTQtguiOIL2bHmtm6GoMAlqLc00Gu68pRk9vLo96MDI2EKIA49LOW8tzXnTehbpiTqAJN7Vs0Eq2MeIGUYrG6tQqGbxdGx6PKUvUbzB8jshw8Kjtm6FjcUU/cz3a8MTR+d5IxH0Vc6uJ7mVuil4TqyqjmJoqO1snTHGVL27KJvtuaz0i+YqL4dK+bjKySOwbISXtikNvCW23ibYekK1yRyOAy3aij9yjTOs2neEqroH3tW0ELo98gKn7jcfZnncB9TEuKh2uf4LGaSHWO6wwaoa3H83w/BLXvhwlyQKYIFv47LyqHOYQa8oWW0LCUlAt8um475J1uB4RGxRPdcW658aAYI44/LNFfeEnuXJacnXPnS9jBYVs4xkdSA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 10:07:01AM +0200, David Hildenbrand wrote:
[...]
>> 
>> Is it possible to have some defines here instead plain numbers?
>> Thanks
>
>I assume we should look into using kselftest_harness as a separate effort, so
>we can avoid this manual test calculation completely. I'm afraid even using
>defines will not make this significntly more readable.
>

Agree

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

