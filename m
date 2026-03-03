Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6640FEDEBEC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71096B0005; Tue,  3 Mar 2026 14:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E876B0096; Tue,  3 Mar 2026 14:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47316B0098; Tue,  3 Mar 2026 14:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6E36B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:37:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 280978A9A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:37:29 +0000 (UTC)
X-FDA: 84505761018.23.9D08E31
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1575160003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:37:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=GTLuHGCS;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.219.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1T64qFnvXycVGrtrFxLUYBkPwWQdDHQpwifr7t+iMQI=;
	b=qLWY7CWZlSgsaJSZvYA3ivhBdFS70D0v7lKurXVjY+z8rf71wQt4VwCZqB0YE4sV4tKR42
	PHrrzCXkHeU0BN09TkVSPS9E352se69uUXZYtCBxwB+Yvd4vCXd8WitEStKDXJO1kHXCGu
	wX875u7FgsiasU9bHJAGu9tx79c6vr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566647; a=rsa-sha256;
	cv=none;
	b=d3TPRKAIlxfIESQkXrO1iTe7cLJOwAqMRdjkvGr0K+pmVn+ToXWFdBtxZuMpr1S+eBnevE
	PADIgel+FFQHQk5IySMJGHRHfTr/I8hKDEXYANiy3xVjMcEJlbRVEzpvUAdVnPSkyWYVvz
	hLPpuW0qIWT62WKtFmbbgAMfsSjTjz0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=GTLuHGCS;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.219.43 as permitted sender) smtp.mailfrom=axboe@kernel.dk
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89a133cdd4aso6881156d6.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772566646; x=1773171446; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1T64qFnvXycVGrtrFxLUYBkPwWQdDHQpwifr7t+iMQI=;
        b=GTLuHGCSHDGc0fh0QHvVYAU3s66vc0i2Et2o3+oqFDNC5yDzlNda4UzLaepWD5b5YT
         dpCR1orkpMtwZMZ49x4y9IbPYudrLLtR7wvzWAXvRYaQbumtRHLvqUH4iQeI/YKChaBz
         uUa+gCODCo3X85kiXRq8lv2M5+z4ZIfK+UIMK1vYKj3l5R6B08Q8dc2liFxzuFKHWLux
         9BVOG/hjrzGMqVyTU8KFTqxjOUD8SPOLkKFpBt7hXoN7tC/2jxQKZgklKnCr8dDuv19Q
         LprihaTdlMJRo4qf5PGABgSQPfSjVuSuh1TGRb/X/oCyAuuTYi6BiG92kMrFOgI3aJTV
         Qcsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566646; x=1773171446;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1T64qFnvXycVGrtrFxLUYBkPwWQdDHQpwifr7t+iMQI=;
        b=NjtbVWR8Pw2CqBqDIaNPUjIhl5cukeR1/KsYL/XYR7D4kR+fAbX2H3rYLh2PHTXhWU
         CfbfZWW6fjwN7EU6aNcTHnbhkLsAYEd73bbdV3qklEZfJ2Y+sYnLKJK208zDz276TkQm
         NzN8uYJESFewY8yZxLqQgtcUL3keAIESQRuQ5wQc7d6dFYjp+oYSEvJ8/xqWHk7oDNqQ
         WpvszTxikND66c/I0QTbKtxQqPET340U0yz92zoYYJ48NuszmH5K3TBHSLQFZ2GbUM3Q
         Wx5w3MObB2mWLVE5AVqS4xEJFokKZm4sJU4sgCBXl7O/VP+HmXcDGXQ7qwd4oqt2PLus
         Lthg==
X-Forwarded-Encrypted: i=1; AJvYcCWyjzAGBhrC2bt8SATLorZEVNwNvkIMXNExtfFxQygpYNXFyiItUmuejndL9XaxD7P6pb/N3y2Uww==@kvack.org
X-Gm-Message-State: AOJu0YxhUfI5QEQf5F5AWZ0mW0F9d06nQ/P5IaKGspKkGXlsgqnjme1c
	Ecm1DN2nsWKJxl0E36i+LCr41MuBv05mMUPL6ChFYk8XZwYBiDMSEnNwg4Yhs2dS3+Y=
X-Gm-Gg: ATEYQzzXIhxb59SYk3B1P7IxlY3Cm+nf2hIED0bpRoR1nxx17p3Lc4IQM3k+RZn9p+Q
	p+PxTMWVMEbK/3UgrBbL+5ITTj06bBA6yTTUTLtnMnC3D8DnzguDLg4MDNGgGgA2HY7LdOhN+Gb
	MP9C7p1TqxuABN4uyI70coUdoCfhjbwFy5I98SIJ0Qc8vVIEztWtKmdWHFJ05FdIdYfaAHezyvm
	iaCpwvVr1Aydw5o0HgeDoUINwUoqGoebjShjKMHQNdehpe4nBFThJmONI0qnEVpVgI+CW48lzxS
	D3TQJun6fQIP+eV7M6kwWBkcJzEg9AhHwQHPq30Jt1uxkNtK1QRa/c+SwLmI3pssXSELizAIayK
	RaSR8ewyc7In3iq1sKCYkZJTCZwz9d1es2hpSaQ8Zq604y29oNB0xWDm3I+iM/ZLtDgtlfi6/xD
	vJVR1mF85YNnPpmDWhl3jWEsidHUvbbta+Jwf4vi8vsEfQREeGqZFUqYLh5fEuoOET1n5BLKECK
	Nl5OevY
X-Received: by 2002:ad4:5d4b:0:b0:899:b42f:9de8 with SMTP id 6a1803df08f44-899d1dde739mr255048006d6.27.1772566645798;
        Tue, 03 Mar 2026 11:37:25 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a0fbdbcb0sm17369666d6.45.2026.03.03.11.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 11:37:25 -0800 (PST)
Message-ID: <63dc40dd-3a52-4e72-af47-c59d12b4f379@kernel.dk>
Date: Tue, 3 Mar 2026 12:37:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>,
 roman.gushchin@linux.dev
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <aab0AFAgAzBi4jO6@linux.dev>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aab0AFAgAzBi4jO6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1575160003
X-Stat-Signature: jh8p1totapyg44jz5p6dmk8ujxyghhp7
X-Rspam-User: 
X-HE-Tag: 1772566646-855186
X-HE-Meta: U2FsdGVkX1+OfN1CmQPX8qtBeXscLnrdMCXFHAi81FxiFTgLs4yeC15Hgfg7j4BPkFQlw5zYZin8hmdQSB1DjGnPb+JZxCPCJOqHLBep1egTdbAJ1051aBgTK8mm4B/UPKau/tV43tZ8YpcE3V5ue7dBXLYkCVrlJFo3cq25b8T3ETwNCs2/dGZ0M8kDA3TucJMHhDR3K2vDGE/9Rp7G62ZUOEnNwqyLf9d8pv1d6ZDrp3AK7c+Trv0dv6vDAjnpo0UdMQKlNOICtT2yUDM/VbyfGB4CBUZMRac8gqFpD6ahcgav7uuwYOUoH3Ndm4jXKGSmHzOZWwvTu15fwnf6ge979Q3EFwTEPzQqUt+QbII1ozE/qLfyDBegB2puzRRD9MzSTIhtYlaZjCYGTJc5/HDlnNBD4GJZwa13NinfvqeeWsUQE0Tjnz++NRwduuiNLigMGi+Wi8wLvqWeLg/94x+rbrR3xV6wYphc94STD2L0j0cOVHMR7RCQnNKEhhpUTT293qQGucUJU8Fwt3MVHWH2zUe3gTCHBVTQWkao4lP7eukeHFnDhoiiX9VGern+7wJV7sv1SHzGrySDz6jBwjJ32BqQmyA2Kvuu3DlB8TITrXnAfLXMR7tm4b6/xlwCMDrwcHzAPJwy5jPrR7itVwRjL7wFwVQ5OfiRev46S6nuRA06W1kfzwg27tvmgZ+O0HSJFEBUJZ5CmNshlWKNRASpqsYgML0y8tEm+GjAZourOD+jXE/L0M1dLnQlEo0u/YbjM2WXJAwmH48bJFu8mIX63W5Df7+kF+EbqbhlMtPVMdjQ2StjR2iJ1fBb9x5Qn/RA+fYpj7f6xUbB+d2UaDTCMRitjYNhQ4Vmj7vr2o9dno9Y/IeVkynR3iJtxCGyOFwzQ9esyEbrzi64AK73mmZnKtQQA/wiDhaayDrGVNjSjiYW9WwGLNuAPoeYsu97eI7AHb83jcOfetYEQRH
 8ZpNTiyH
 j+RgU6NcXYaekunK+eOWypsYEaWoUAb84LvBKftwKh40OglYBK3YrprRTSVk9/xC0rb2EpeAPSozYOeAk5VHu0Yg1bOX+ATxaRMuuA3AcxeKrsU2XvKhaz5tmJVDGOdBsVkcQ+f3TUNlqqF/mCuURk6DrjbJWn+YxZnQpwax4fWzs8W3PN400ydUFLlSYJFB1R+tWc66IhdXFtVOLzlnG9MpgxMZWzjj9+WiSdV4waffJHXoMd6uc2AqBoVL9CTzzR5pQXY4rBNs1v5GGc2tmKWTk+WvNTUOMlWcybkNQaPt0lTm4iYvhBImcYmVfWk89/25VFu3d29jf6Zl5B945RSLt+eElkPzur+gImKD8zg0Kj9VMJVOZjOiLU7t1ZSzywexkW+rBd9+Ny8+5FSIyOAPurHf34A0rjX5A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 7:59 AM, Shakeel Butt wrote:
> Hi Matt,
> 
> Thanks for the report and one request I have is to avoid cover letter
> for a single patch to avoid partitioning the discussion.

No - cover letters are ALWAYS fine.

-- 
Jens Axboe

