Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D303CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCE490014B; Thu, 14 Aug 2025 07:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19488900023; Thu, 14 Aug 2025 07:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA6790014B; Thu, 14 Aug 2025 07:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEADF900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:51:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69D2F116D8D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:51:37 +0000 (UTC)
X-FDA: 83775198234.15.479FDFA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A3C32000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:51:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5p9hhdb;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755172295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VnTFOiEQ/KEA1BYExh4enVyNJmydSamaAd1v3h7zMU=;
	b=QXF92FPzJ0e4UByf30DdHhqYkw0IyaapD1T6YYatA+6Ce6XxTBgagSDNjTgDPUO+EGmiCB
	lEE4GeA1vFNFffqOehxJ74AV289CABl71gTX5e7h8kCxGQGZ7RkhfVpIPwXgbaKcVCcYQE
	r7+j2UqeO3w+l2dr67zdMuchfrFFoqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755172295; a=rsa-sha256;
	cv=none;
	b=dkGN1onk4ygtTY2z5mNhkiuahHXw1s0wBn2+tdhkn00Z42YVQFaAxppVF6152Lj1S4dHrT
	OATTvxf9tmhUO9aHPlgSg7+LLYv8PDOTAEoTNncd5ZuQLpNGFc5vzvOHtY6CDI3QQ8kWMy
	CYx2WGzc7WRzvhNn+suCN3t0qPok2X8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5p9hhdb;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0d231eso4558795e9.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755172294; x=1755777094; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6VnTFOiEQ/KEA1BYExh4enVyNJmydSamaAd1v3h7zMU=;
        b=E5p9hhdby26miwfiSmdm/onftAeQW3HgArtecr0NBE3DWL4CmfQJts53ZIzd7M36oC
         +RsB3/mKIGYL/mlboqVsGYxJlioyeC227uKa8krPLpK7ez2LYwTTKQAuS3s4QWy2LSpW
         PKPYFT6PRcIj0VVO6zcRgR4gcAdhZIaKe7hllb9PWCZhcUXC3w++X+I9N9EnPCjghhuD
         0+TFgx7RIH4X9jYrGyY4oPzYuRIfrSdOsVPaPBfbUNQeMNUAROVwxqAzmGMiD/aiFcd9
         r/KDHPFAu6u7QaVwGvpbJ46lRDMXLq6VopnQzWzvAL11VDSSLfmGSFHl3Uzt+1ZWllmp
         A2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755172294; x=1755777094;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6VnTFOiEQ/KEA1BYExh4enVyNJmydSamaAd1v3h7zMU=;
        b=VK3lZxPpFYVvBUT3t5bahvcb2rFUMdRkFo4IxWtnqGItzNZmQ5TgV0Cr6q073ItmNy
         84+mZjW/xZlTSF661sOUGS6mIgpV8tyVy4/+92hRVHq8eMIFzqAq4d0QuSl3FAxNqSLR
         ENFKFf4jvFHJwOEAK6TP4TZPGFZMtg3NA7j5pKSoOMFOXnjCdFIpgpI8BEpDerkSy81j
         7eQIYKWtNKeCwHFTi0wnmQf6EJ7SfbEemVeBgAyX5MI7q+c4vr3TwCO/C7krkNzyn/5q
         QaJLnx4UPEuqG2npfzvKOYcuzZMfk5UG1PJVDoCgoUZCZtnefGsBiVYexqCpKgPBzUi6
         TeXw==
X-Forwarded-Encrypted: i=1; AJvYcCVN3O4rAvonBkJfWb1W5f5aGbFoJYgWZYEC3tPahC9bajPtXtTdR9Bns33Zwb5DY5Z+UB2YiG1I7w==@kvack.org
X-Gm-Message-State: AOJu0YzA2HWrr32nUoAlPhJWLOaoVW0JYvyNJKSL2dc/xj37kcUzN5Uo
	4rb6ei0nC/rFOgzwowV9zuHUzUgapm0FLCS7cIAaDT/i8wp1zNY9EZE6
X-Gm-Gg: ASbGnctDATbGmd6+xb0O7IUN5Oykc/MMu/RvYu7Rcy/SauaznzBO5+pLC/ea46BbLWb
	1ylVIxW1bSBiiLg5748omkW7j+M+CdKA12fX32VRmjPEWk/Hcl4rsII0mBs7vzn1ink8bYLD/qt
	8sAQpv3fWwRkp8kb94cgDPWm/Qlmt3hmkLBvvcTYkuTyvEXX/R9FTDwj+SuyWk3cU2kSTOFa5Ht
	/z3A9v3PFFDpG+7LGsE2fX2OWupzWXFDmb3I/0dAFcimAjHrBwuEANUArXpTOpFdpJ9bUkDSkYL
	J/m20AIX/pvqaZEjNp4OHr1P0OVJN2Tvz5NKzJ1EeVbCMDKtz6nsD77EI2nwZ/jl9IkZLVWndaz
	ClLT+bb4VNdz4I1uVRPShbpS+KrhGZ36s3/WzimFvVFwqrYmsIIbzbbeO1CQ6aaS547FR5EMGlU
	exEzkP9A==
X-Google-Smtp-Source: AGHT+IHthldMbcpzDbaJ1GGbyBIqgCUgRr8Aa4x6eTmOxq4YHMkcIGai32HHy+wWjTZMm4tR/4WApw==
X-Received: by 2002:a05:600c:1390:b0:459:db5a:b0b9 with SMTP id 5b1f17b1804b1-45a1b67a215mr16749815e9.28.1755172293482;
        Thu, 14 Aug 2025 04:51:33 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:8979])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3abeb2sm50579340f8f.11.2025.08.14.04.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 04:51:32 -0700 (PDT)
Message-ID: <4d23ba51-e8d8-41bc-8d46-a7bccb4c3c20@gmail.com>
Date: Thu, 14 Aug 2025 12:51:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Mark Brown <broonie@kernel.org>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <1ff24f1b-7ba2-4595-b3f6-3eb93ea5a40d@gmail.com>
 <a8b0eb8d-442e-4cfc-ab79-3c6bc6a86ff0@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <a8b0eb8d-442e-4cfc-ab79-3c6bc6a86ff0@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A3C32000A
X-Stat-Signature: zu8rob4hguy8q5dpgaoaejaeq5iyn367
X-HE-Tag: 1755172295-88630
X-HE-Meta: U2FsdGVkX1+ZEcYJmUZ3FOFnHff9wS3XNq5CcyI1iTi1HeuVzxZWZieFk9xRin5G/r0C/MyUdkw+niTEWFYpmoga95r7d5/srmCyJb+0aWnR/Ts0FyXcbrlwgqD17RNO8MKB6ysTFCqayutcmwBx64T5F9zL89A1Q+DDhtymc7DX2X5FB7xqIfrYBm1xZFnawDuAyiU9qMWsxKREXFu989qHBKMu/ul2DA1qf0aszlnbgB0PSz8m2d42AZ/HWVG8lm3izV7jpkQhPt3AMgoVdgXAb5JTpuBRqDE8ohLfgWQ5DIyGOws73Xqcjvq78Zgh2NvFVhy6Z6ASLOA9Ju5pv68GRwhdjOnGK/8TB1JnEqiZ4XVAmEiEsn4pxar7330XoBt+mCDaABEPRyC44scvDT+Bez0/sryRYtdq1MOyuAeJ00Vup+uTuFVYCOGPBEHD80vjPypVZPGOH13yfunuiNJzpJLUxhAh+S0TxGpEKlCYX3JOLCqczSDqL2GiNdWlqwJ+aS6HChbWcQq88rlRriqTEfAXb+VAAE2vabSFeiH49HOc/RfGKV+iCw03qw5y6LsVplkEQ5svtxjUllPYHQDg2XN9KiAXWmDPxfnNQSHncF4Ctx+RmYnAWqEn+vkKqv3MV3jqAsdqqDGdQion0v2I1dm/2ALaDPnQFxYkzNUYtCkZzW8Ni3AJ9wg04TGcillPXaby84U+9IFrOUbXQpUY7WLv7y005JRr7Bbt6WAmE4Aqv56aXqr5Vc8kJ4NSRdzvEhDjjnT5TSUD4h0s9H3FtJ218CqzTTBmDZhmF3Ov/VSYwnHfq/LiWKv7C0t8JJ5HaNwX7diZKaUj4CosKcvX43N0mpErA7+G/ny3z00sD0X5CEjPrOZtK+e8PZz+AXsZb9WtooiaMEVj8pKYqb79jyNGbx/4oXakZxMxLXNHdIYrelDsSuzdbKSnt04eLspwTd6KPEQjzYIKkA4
 xYdKP0yb
 eq+oQa7AcmBOwRgc8ZM3UfcMYEJnJOpM3SGoBvcAJqLxM0qurMN4ZLQe7iHssicBFM0XaEZgZ7tc4Pl/58A80u2IpSEe2VBo1ublhNiQYlyam20EswanwJ+TMqCJNJtQQme8Q+XoTXymFXmuWfgxsDbvSKUAjPqtJyBVj9T9PZ/33QUcIJi6hTj+Ts3CSPcJXUPRxosQLrLmyoNiKvJaL/wkORNRjap/jA75IsWV1JSLMRnGyxT/u35l+x3RUteIOcRiFQE0kDdmd0MJ0m0LdYxml9qSJ4KyhMSSULsM1i5wykwaFTWdyqyDGxy1/05H8fXndAGlfFElPfuIctk/KqXjy3+3DeORzOY6NdmbHMvruTc5IhFJJq+Tk7N7fAVS6WsQN8v8kgORBn4jQkKi6TenfJW2mZFacL235d1efIoKJR9Qu7kX1dKco9lC6EpzAVSbiHTovmrAuuQv8CRMDB05oj7lGzTaWdEPJMQmqCLYKU16TzHwByfsDzb5lbrJAxyNa2o2uAEAV6ZZZyS7XgCcclqKI772Hr59HXfNkxPNss74cSgii5NvTleGm0lVtNUUg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> 
> Why would you move things around though? Think it's fine as-is, if something on
> setup fails then all tests should fail.

If its a "test" itself and not a check, I think its better if it belongs in TEST_F and
not FIXTURE_SETUP.
But yeah this is ofcourse going to be the first test, so if it fails the entire thing
is marked as a failure and we dont proceed.

> 
> Cheers, Lorenzo


