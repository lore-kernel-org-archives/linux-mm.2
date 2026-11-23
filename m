Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF85606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TtwzRAZC
Received: by kanga.kvack.org (Postfix)
	id E2F396B05CE; Mon, 23 Nov 2026 12:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05AF6B05CF; Mon, 23 Nov 2026 12:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD54D6B05D0; Mon, 23 Nov 2026 12:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9BF66B05CE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54D1B160955
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:46 +0000 (UTC)
X-FDA: 85467093852.28.417E43A
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id 331F8C0010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TtwzRAZC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455524;
	b=Z9uBbBupPOFrxNdKqI2lEajlrPmAOQ0bDDo7H2ZFjhOONUs6y8FcUSK3Mq5oGkNyTMhkfk
	agCnnH4ntpYh0xVI24M60a+G6sP1OE1f6d6mwnYSbS07tzEGAacsuuE05ibhlZyH5f6Sfn
	S3sz3ODQPAdC9LPBEHuSKhw0PHXwCDA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ON4hm5xX/TESJ2KwEmSXnqTeTKDgHlHTMudm7RJl7Pg=;
	b=klojQNXWOzWPwK6VRZsxqyb2AH/IkkUqsDm4QUGCr5gEbCQPNvS+5wGBFQoQZSvQ7EKdbb
	aiG+zVVo/2ERPtzrrPzyFIQHJbbxeMHHVMeBZ5Lh8oQ8B8my/ERWJ1QHnAD2mQETkm2V9t
	yK2XtX0TyKnuvGnB9NxvkR1rSVpuam4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TtwzRAZC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1376521eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455523; x=1796060323; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ON4hm5xX/TESJ2KwEmSXnqTeTKDgHlHTMudm7RJl7Pg=;
        b=TtwzRAZCdCEFAHLpH+qQLinye75M4CIJfbQ9RQAZozeuLuT802HoUCtf1m/FFInYmo
         ICK5KxbVSxscbdvypxCoM02c4GOXcycKxSRDm1X6Gmtno3i0hf26njhqmB7R5O56kBRH
         tU6EPtBK4q5oclZ1wWnSbyHz9XmYmHKVt9o/9WY2l6R12KiqsuzaC8qksaG6uisQYDpz
         AB/bF/u6PNrpAXhKOIplhDuN9raTHRofPjDRdkwvxJa9BwaZSCGG/nSYCR4fc5hxtIxa
         ST4GBsN9dLycRrq63uJGfarduNaQ2vsMk5q36o/Xqsd2PfOJn68P9LYMQvkJ0zxanabI
         hONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455523; x=1796060323;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ON4hm5xX/TESJ2KwEmSXnqTeTKDgHlHTMudm7RJl7Pg=;
        b=Gb5egkCeHC2rQjGszu4TtewOYj2RlOTAK0q+8INnEBUngZ5NdImIkqISu37TVDamLW
         mMJ/Ago8xKekyZMcX7dq/QfJ4r43I9g8+n3v5aBgJ2UbKMg20aZDRSB+itPVAcOrgyN4
         ZMPuJxOf8sHHEVCNtpNsnapXbmRQBCyW+v0y0Q0BrbSsUqgJ6+Um4AAf4iYKl4cgU593
         BK9JCHQZkhbmtKjeeYR+dQu964i08wrj9CoaKOr4REIoVD2ebNyr7XPtscq+j5mBeVPK
         +zoJx5+F8RWfVmqhrEuG7bVm3U2E7pttnM3V+t3tQ8uOhK9kqBpj3GON9bhA2jO8IKcA
         VVng==
X-Forwarded-Encrypted: i=1; AL+hErFQPGKDX7yC9OeVKJn+q1FRMJTrHGj3wMSiYyqmfCoPX+ICJ/qX6FcoIn0MuXzq9r+O+wrqSz7nRg==@kvack.org
X-Gm-Message-State: APuU4Z/EUK/ZTzivdjfYiY0+yKvd1csb6W9iSV3drJ2EpwS0j9XRNVI3
	5eAllkvdBWTMw7YjaDzzM4bGVmFvgNsP1GgnvOQBhm2qtFdw2gB3Y17/
X-Gm-Gg: AZFdTZdrEmjMawUuiw5CZCaWzdJNo1yigKxwuihBePPWVLFATx+z8yTxOvMhBW7mudJ
	Ow7pfgOqPNrJaFZguBcrYEBBH+TzMR8L+5Lm7irX/1rsSI7sOR2tTZFrgn/+dmePXlvuE0aYPyU
	kA0wKGY37p7QfpxCR9+RRtUEryk+/u/2dgoyKy6y1nXGUNMk8Kz+MeAPzqZJ43Epgd3QiX6BxfM
	A4BZH8mHwxJyJ6uAVrPK29GWiQ0A4TLm3J72ibuLl7VbABY/jl93oi6GIzZMIajYeaz0YrqoK8x
	PHCQqC5p4aEeS4Q+jCSGsDQeJFZvZSER5Ph9mrc2MWdMQcVLexd8Oh8RcSsBYjWal7+XwsjPf/4
	wUGnTa1ck6cl6Kq0UtXmgHfmMlmiEiup5+yocX8JzYn5IbVhrbZBcKrv54nnwg2iL2/yGJNNteD
	ap92JiKPB3m1q44Rc1Li5a/FlKH0P/pewtFswSfrPzmaAwXMIXrZYOFz7GTuSlFSZGjFXWslK2x
	VYGcFWqoOICnrSM/g/p7Olbb9FuAiLCg/rGaCpxcqLncI+/rW/EiIuiB0UFDgfV4MTucE+dFZ0k
	aE1ZukEpmcS9zrfZ8GvxgJEPS1fhWSV5mkW/oW1GT2sHus+vQzWGq6znaLF3+Y01OEGg6qcJhw3
	pZ4yh58ZeNwCi++KjQwPQ8RnKdX8W2TxglEGJqwjLMsNhtkVPn9T7jCh4ZIelDA==
X-Received: by 2002:a05:7301:6408:b0:36a:270:ce76 with SMTP id 5a478bee46e88-38570f2b27dmr13093027eec.33.1795455522859;
        Mon, 23 Nov 2026 09:38:42 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:38:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 24/27] selftests/damon/sysfs.sh: add basic tests for
 admin/reports/
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256510.4.17741169185712698444.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Shuah Khan <shuah@kernel.org>
In-Reply-To: <20261121210013.130397-25-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-25-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: eukju5hici6i8rcs8mzm8kkk4c79rtqm
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 331F8C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1795455524-185939
X-HE-Meta: U2FsdGVkX1/FzU+z7j659y1SjyFcnq15vJVIJIbKSt8gW1HPx0/wJLDWvtvZZc3Akzh4FhVTIiIqHyPGRbSDomyD53Bs/DRsXiCkn/lCLokfhTKweerZXGnrwFJmK6yEX8JApJbznNQ6MqoyFzMj8C87jak+/ppW7LXJqwmcPiG0c83Z8A9hVZV89smbrs7ZRxO6JftsX290jxpf5lepKQ4f0V9/x4h7xAHB0w05y1rjexzxOmjv92YN69y5VsWWKsZ9cH4GJPeQUYpc2hYqQ9+nIbfgmxrXTrzQzBSQdFExmDG2TANkb0Y4/1RW5BVHpIFb9xqT7wrn7TF5O1YjcXCym47b8JzUdEyJpAZYDNv3Ep+hbtXBXw/zM+BXMwT50+Y/kBpGNbtydvQYy5uDwrn1bsNMc0pSDbCrrbp4Aco6yrFghE/7yQ+erOnt6Htvg/V+S6D//jCq3Q1BvXObCyFt31RODbjEquzWYBkKp4WAwtVdxA6+nGUap3/QU96GdDXKYXbO/f0coohehODl25fSxqe0/t1ggDs01tQlbdUXQt3GJy354uHjMaqFVfzLAd41VsHgOOphKF8OkmgdxOLjziKXS13Te010+dSTY/BYrJwrLDbhau9OQacFN0mgj9MnQkrPYAxINh8lcMq/yjuhLK3HL6U4ojqvv2iUgaGG6NAv+yWj7Yeo0xj+kFlVNWgTiHLdTus8puqAOke57yjMLwy1lCRgA4r/wyGC+jFW4l+ybES+wlUg19jXLsZQaTUD3eZQzy1/D1CLnCUeNir/hcZCutzUqqzl2FvzhpqX7yJa1DsDiwXNW5Da4loG5j4+3ONJCr0l5qNZ6zWAwffG9K0/tNJmi+zkF7EgmVQR1tHs5iVIkkpDXmjhlIfBagzy3t6IDpVMpeLW1bwTBK2M6RF2BwZdtkWxaDRVaozYY03QShknMH/3VpL2meXHrH27AOQEHovcTG4upyR
 hqaygcjB
 qfkmdwiwhRDaGkqZdrJc+dUdzq1WSjunz/VbqxS7tgRBIH1AVqJOIxR1KD6omYNEM9Li+5iHHOAsX45XURGDV/n4X5MVQ+FxaI9wiC9ug9MBMZ4xsptoYkxoxve7/jEPXy80ttUSjgoxhM0dxv9/vGZ9d7VcgcX09XQFysJoXa/8yW1uR2ytYdV1nPhK3OX6hwjTR3xoeKkjdG9TLnKBUEf99x7QOR7CLR0Fk2MVSD3ASL96gR5f2bwDslTZ++Riv4Go7FlDV/eLkRbqGEpNT/y2rDzWRBu+C6dE3TB/l/0x4LAc5r4SVnO7cRKeGe3XcpJ2ad3of5GioA6Sw5YFGLNOjz43jHmA53xu3ODlPzqAo0j4iRAlz4AEcbRSGPJtxCmgOqFsf1DrOvijVJWC0YRFLiJFkf9eXoWtfpCuPAU7tHzfh8zkbcF86NE0pqycLV9JjkmcP4j2TysBhCbzM2Nh9dB2qvAApncvw5RMNdBJlGSL60aJAKRvPhJ9C4yRU5JvhlkBOQWEdD/AyQIZNc6mE6LctU227P3V7X3+/ut37bVYrHc9GBCiFQM/ptTmUK9vnDoqqE2E+QKMaJfy46CIjjJO7P8IxB1jOwpNIqtJn+HbqoPrYrvKC8GHlbJ1a/YGLo3/0CAgDZJm3umxWZ06lV4fTR+o2WF9PF95gXwbphA2wJyrNbxrednLuHUg035SM78DCelh3frN6F0Gu3kN9yCZLda+FkyKQVFutVDadc4aUHXJz+6GiWTHkcdlyBoAb9i8jEjYF8GvGObAf3DculTcxQQuHSoruYNccMQ2rwA5YIOkVEBC3oUWiannevPkM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:08 -0800 SJ Park wrote:

> Update sysfs.sh DAMON selftest to cover basic file operations for the
> sysfs files under the admin/reports/ directory.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

