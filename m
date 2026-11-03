Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F6C606A33E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=igHBwi8Y
Received: by kanga.kvack.org (Postfix)
	id 607066B05B4; Tue,  3 Nov 2026 15:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6126B05B5; Tue,  3 Nov 2026 15:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F45C6B05B6; Tue,  3 Nov 2026 15:00:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2206B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:00:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C94F40548
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:00:19 +0000 (UTC)
X-FDA: 85394874558.01.93A8181
Received: from mail-oo2-f10.google.com (mail-oo2-f10.google.com [74.125.231.138])
	by imf26.hostedemail.com (Postfix) with ESMTP id 68EE0140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:00:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=igHBwi8Y;
	spf=pass (imf26.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.138 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793736017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RhPyP7MgK6kNq3ZvHFMegrhlLTeSt9fpqnn/iAW3AM=;
	b=K+6LKcZ/M5TDqzAupsLxk9lNZ01y0tPJsZPqR7iw4/CXeE5daYhURSB4JWzwZBfMLbbU8g
	TA3+kEMzCrzh/MZhGvb/2an7oFukPET2rGMczwwU4R7xhDLKYXY/g/DHcHb4ecrJwDbScV
	Bnvny//ptSL/gvKxjg91BCVLw2bsz6M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793736017;
	b=uiHA2641AKg92W5LzFHCG86lkk2BuTf4g/Ije5u9kuQ92LcMe8M7OhuO+vanU0/hwx+SRi
	EkOJKL2tiD7Sh56k5jvcOsyE5faF6MRujqve06gBf2FG3qQKRVRMz3GTEDPiHcUfhhWRBi
	3JzKbCmwKabV4n/0qvf6lOuzE5lM49Y=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=igHBwi8Y;
	spf=pass (imf26.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.138 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f10.google.com with SMTP id 46e09a7af769-85e1040ca0dso640137a34.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 12:00:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793736016; cv=none;
        d=google.com; s=arc-20260327;
        b=HNK9ELlPhd9+FKmFEQNp7ocFG+eU1QAS4475FGbCNIKJKNe6Ctgswsmp95/YPCVxEm
         onvXI646KbWHGHBWb+BXCIvooy0BkhlZN3gY0pajPLctC84NqxC4ZrP4/bIi6sl7uuKJ
         PStJn7hSMUnylUN2VhaE2o/CPa3S0My6Cf4AANNJ0SS4m1fjthRPWhtQCyrgTrpNZYtR
         7+j4oCmJz7w2txDB1fJNlOt0MAhdUUSR6sRHAplk55YM9k9216RBlJ75gRG3KN5BlO/c
         bzmMFngCSI+yv+x1poc1Zf4rTEoqnWefA+4e0jmeTLdkD+Se12MidQwqFtvhhEYg/MEQ
         aMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1RhPyP7MgK6kNq3ZvHFMegrhlLTeSt9fpqnn/iAW3AM=;
        fh=u2+10SaUwKzOJR6bj6fyEBMCiSMuj01/aU8ZOUMns1U=;
        b=Z4Ckkf89/dkxM7U1aGVkNKtQ5/nM1UiPhvsTpF81jZmQJ/sQ9j7OnGQAHSwFlccRxM
         jKDZTsrNUj6nTCYWvhDc/2o2rw4XWODnef52CKm13sf9xQa7i3w0jUoVgVgwRu+3k/4+
         BZYidMU8KYJZytyXAHWy3m8R5ptmNihslp/pvbquzg/3NnAzkELUPlvWjAZU3NR3PE83
         Sq7Ck8OVnGwyApTbrKa9jt9Gw0CZZ9Ew946b/qxITcGvi/2VuVIAyz0Z8jLTvownmFBP
         /IOTEyC144+3Y6HyIjg4xX5p5nArYFtgXPmBJXXQNbcbqvOXXz5RRSdPpukHWE98wyV3
         TzqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793736016; x=1794340816; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1RhPyP7MgK6kNq3ZvHFMegrhlLTeSt9fpqnn/iAW3AM=;
        b=igHBwi8YAGL3/eZ8WVTYfdmpMVQwavSKTsj4YIF1oOq5MsUrEGRQsT1Cf1611gz8bz
         6JVMPgxjO+l/vEYx5S5x80hP7AEo8ZXKf7PyAQCqWd3oeR5Ay3X5GD9ucTco1W0o7y5c
         ksh0WAz+b24KjzhMosXPaG0xwOs3GL7ZCLeRimH3BdzFC6ndbY0rr6fACNnH4knU07F7
         /o7UH+4neQshLtXgw9h/cbVLaWsuinPXkR6vyL33RwcLWKuCqqkURqny/kWNF3jXOZuf
         q0a3n94LO0KJM64nWb1+OFnw5rIMPLYeCBM5SelCTIQFrHZOwDKQWVwwzxGsHcnVQ2z7
         K18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793736016; x=1794340816;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1RhPyP7MgK6kNq3ZvHFMegrhlLTeSt9fpqnn/iAW3AM=;
        b=rauk2qr+mKyyuFIW9rCGqy3JiJWeSy/gfL+b4ep4sBsj8Yh5lOyiF6HM2MH8gRA1dm
         bMufWYOk2kXQwgDPHGYLjE/EY92mQZ9xqF/4Vg3RbgRsgvcGg1IKjhLpwMX3hC8BWghn
         vtIYi4ss0ydAT3lllHOXF+xaIyaetdTGSXMeMWNTppw+zVX44OpNIBIMWhxQTzRtnsmP
         +H+a0jlo3xfB8gotHYiD5T7nuc9yvbwsqqXvPbrx8SbaeSaK8xABN4bbQYd4bFwuF5SW
         zgQ6QoXrY0CcGHuFGSZW32EGHFHnoGE5XC5qNNnnWQ4JgcyfYFJFb84oCNSEuI8zhp3m
         71vQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5kSOt8EWQS5v8Jmie2SLupu9J0kiYEd4LZh+XoT4aR1tkB/BeXU8DDqS0zANvb5CqJ0G3UALg9w==@kvack.org
X-Gm-Message-State: APuU4Z/iNv6b81A9w/SnnVVicoTEk4X5n34WfoBuKB3OVXLrZSpcQJiQ
	o4mNzgt8+lhakDuBrzAnFh/3fmQkBHx6cYnh7zMSDunrKZthv6ISp/3jfXH3Y36mIwGrUWfW/fu
	rlBgnw4uEMLrBQQS6mjfeYPifZiAEBVw=
X-Gm-Gg: AYBFou3yITkxd8nkUzF69QSQ1e2MZqOtpCSdmmESM1C21OByt+685jCGzjhvPDlVJrs
	FQY0rkk+u61d2ygdjXWh5H3tvpsRQgxImhD/ri+294PNg8NWH6+YKqO1NU5PaBr2oFZuBzBl7Qf
	HO01aN4hdvaMctz/p+E3RBpmyq3pnaqCqzCyAPTRbLG7WteowEUYva9C0JQTSTjH0z2N83JRorC
	CtHmMZUTBTfMd5c8l6WO9dTH2DrFDqmAyFpW+JSNydXxXMA6e56tvana3iR9i0MWiH5pm6XEJzz
	Jlr13Qjv/hGNNJ18c0B7fiPaePih/2LVyohm+KRcPqD5/oH2E8H/i9W9Q4hZGmBuaXnNjOfLzeM
	NGYV0N4BoJyRDl2G0ppRK4nj1opI/rtSbE0JLZnNzfcb3KwnjUFSvliVduYToocv8ynmLxEmoKS
	3N5Tfmbw0tkp2fqdUP6Fllakze9BgiWgDbT+5TUkeSRvDy+KGtdA==
X-Received: by 2002:a05:6808:1989:b0:4d5:2b09:a6a7 with SMTP id
 5614622812f47-5640df62911mr8844212b6e.65.1793736016272; Tue, 03 Nov 2026
 12:00:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027171753.1485-1-dennylin0707@gmail.com> <1bf7784c-49ee-4f18-b1fb-205dc064f40f@kernel.org>
 <CAGEkeHcwUEQ0tAXZ5npAhPp1OPMqkmZcNPTU1OnRuNTrwkDJMQ@mail.gmail.com> <675cfc9a-48ab-446d-9fd0-a1937dfeb0f4@kernel.org>
In-Reply-To: <675cfc9a-48ab-446d-9fd0-a1937dfeb0f4@kernel.org>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 3 Nov 2026 12:00:01 -0800
X-Gm-Features: AclHuK-BJ0yjRgrJipuFochA2hXCTEwqPffiASuKtCyUP3wwqOB-H0RMLhHi6Og
Message-ID: <CAGEkeHey0fjkgqbrxyW=9JNX1KuD+OWzzEUwi-37ehD+07SR=w@mail.gmail.com>
Subject: Re: [PATCH] shmem: skip empty unmap ranges when punching holes
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ju5g7s7w7ttaibjodywn1bntjyi7q51s
X-Rspamd-Queue-Id: 68EE0140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793736017-181717
X-HE-Meta: U2FsdGVkX18VCOdxdPmnjhC5YwwykwleR/nLuk9tLcCvLSo6nP8Y39rwrSSh9Nb2qYfMhHs04PFcQmSelPTOSXBlNU05W5JoswekGDXR21DZS5MsfXilYt99tm/7oIk27Lo2xZQRG4bMpnw3acV4k4wS+5V/lRNomV8K+m8tqJ+ESeFw/S0DO0BB1AOF2QBh6VNgR6BY17kfvFaEGQOih3ZvwLqOF2toRXjuPLIY8yYayJswi9ioBCBm4fF+sconJktZ6HOq7M+eT5Kg5dPTaql5atUpuxN67qrcsjpsJTEWUrXaxQKMqbNP1RZJlLjHrXGaWthtBfmlLoOgbdjTxnqBTisuDEw5rAqh0x3IfWfWHUnoT/W3CEqRrG9W1eckZeCsfJo8lLxa16q3ByB6cNstpmm0fe67TMJK7OuebnfR3tTWzEvJPuyFWJX09KsDsSU1uC5KcbGeseyDAkm3h3uwBQU7hbvrmNy8/pUWzUrzixTorKZkJdev8StPxots7Ot+rP6XNKwOs/YIzdHBPHMVI+pBgb/D1TB1eHok0CsTV567ZSxybntSi4BGgYw9dUBm5/XoU7wi+PIaOpF42hY+HxuOzqaPS19gAMNdT8i//bbQDuyckbbMb3U0Yz0JdHJm8mUT8HjpAUKIixwTLm20tiKTlcDieOcBYgz/bSgh1ZHf04odCV8lZ0Jr6zUHO9EDqFAm2rZXVBhRrBk96YkyCSKC13Dy+mui6DSSirSJRmEgn+CGq6bXAuoQZWXxVwSsyVrhisSpM/vdK1a6oJHQN77nEX4ARlv1Xp2dfhWSFfY55J+xj367MIHQBHc4Z/x0mHvREvAoKlyMzkT3vksrYMJvLpAWnGgRWP8PHZ7cYTgUMzENelrX2bmQZBRHMwFSisqVRmeWVpGdnVoaEOpt7Myg6Dg7+Xf6Phtl3GP4jDHXFuQoNVzCV4fB4n/oEHuJyPsW2uRJ5GLsy08
 QJSTjsJb
 OYdtGrbaoV00QHFLA74fvq9VK9OpUimbFAavLN0GVqRZw3t9JRECHHssGjntb7huaK//Fy6kK1/v3pFdZD4JFLJZivbvx1zctWuZvXntuzjTBGRb51AD3PTAS/1uFDVUsZSOPYz/eimVcTkmAuY6lLZad9EWFEH67PG2LmmPm51Asflqggi4L65YIEb8e/wBVq0snxqSU/xsCt8Dv/Qw5eEeJxJHs++8IAr0nuPrAuEA796Mqp8xppiOfi6XNnaudD8RMY2kJcCgYqpXl0H4EgXUU6c184zDZTeJ44YnIMNeeccUH5nIOx/PT4DICAbTTJdUv8p/EtEK2WAdi/+ph37MIMw/mxLvuWWGUgK3VMdPOs6XG7DXaW21MoM8n0AJzMR4oRsethZ+rs+YucWay7AFfgNJEd+XNjQw50idqRgNO6GI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> To be clear, I was asking whether we could do
>
>         if ((u64)(unmap_end) >= (u64)unmap_start)

Sorry, I misunderstood your suggestion.

With offset = 0 and len = 1, unmap_end is -1 and unmap_start is 0.
Casting -1 to u64 makes this comparison true, so it still passes
a zero length to unmap_mapping_range(), meaning unmap to EOF.

The +1 turns -1 into 0 before the cast, so the submitted check
becomes 0 > 0 and skips the empty range.

Thanks,
Hungyu

