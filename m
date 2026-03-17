Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 301E2F33806
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 07:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCE06B0088; Tue, 17 Mar 2026 03:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894AB6B0089; Tue, 17 Mar 2026 03:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ADF26B008A; Tue, 17 Mar 2026 03:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69F2E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:32:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34780593E2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:32:13 +0000 (UTC)
X-FDA: 84554736546.06.50BF7B7
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 151B0C000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:32:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=dmClfS+Y;
	spf=pass (imf22.hostedemail.com: domain of adam.bratschikaye@dfinity.org designates 209.85.208.180 as permitted sender) smtp.mailfrom=adam.bratschikaye@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773732731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rsh6oTvwvWHqaFGsPw06IxhO9DVzxPM89iEh6c4TMU=;
	b=Ftn+EK8r/FFDBVkj+LHxa+FC/s0kNBOUFUV43Qks+/NzpvZToeMZgwBIijzr6QaDAalEM4
	sTX6C1OUni85QP0WQZ8gqJqG5ADpWFa3vYnTnMtJebHd5/vndvEeOf7I9vEDDdpBEoOelN
	0TVNinWp/u7jgwGgV8GyH60r21c9deg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=dmClfS+Y;
	spf=pass (imf22.hostedemail.com: domain of adam.bratschikaye@dfinity.org designates 209.85.208.180 as permitted sender) smtp.mailfrom=adam.bratschikaye@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773732731; a=rsa-sha256;
	cv=pass;
	b=N48W63PnGKt6k5Ug20Gru7i6FrcFtI2/n4F2hPjrAyZJS142DXqcgTYynsqIpnGlchPNr5
	PDhTJwde1O2L5JR7kSDJuYYb0D8W1dqZJOx4R+Vx+j/EUzE28dO/H/eIU2oVZ+cEK1tzRp
	KDZnHwuMChYX10ftgG6bKxIIR8TCKEU=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38a01c80c34so44956701fa.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:32:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773732729; cv=none;
        d=google.com; s=arc-20240605;
        b=Kh0n/Z2JP1OkTfhEayNbGTP1dqka+WFXhjzZ/yFu+W+Z7nJFJXcRn/5d6JfcIyWnvb
         nsT6YYo6oYjzEWd9hveWWgEQv4NxF2s+BuxrVQTden1bvtBR7fV25rUir7XVrtsWTEyx
         LbxstMPOCzNLvV1cF9xI9YKDRNGa9eNNQp0pF/gyTljNwCJ7IGnuI0bxQrXG+bxgWSYm
         wQzMjTOZ0F7ruN+HvRS5DcodGEieyH3d1HlOYct2puWzssuHXFnqxnOWCXotNV6dOKGF
         SQq4gPhZEwIQoZJRns0qe1rSGClTflJoQIrE7Ax3COP8uaFQfqPm6BZKvKC69SYa3BRH
         HaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8rsh6oTvwvWHqaFGsPw06IxhO9DVzxPM89iEh6c4TMU=;
        fh=in9frdxQ6FSVHezQV3zbzvMXBaZRcbc958O6u8LAeeU=;
        b=NjOe/Tx6fxYOEO/uyWY9JqNFWEXph/+uhSeaD7b7C1RnqPi+2KJfToFsqSqJoyLKXw
         h9frSnlfy2xjMrFABVnNxRtGwMxNek20+pW05CFwL/xN88wdBsw3sfIGLVemSGfQvpLW
         9OEngM1nvO5TEkKul4aG6zofbF30AdsiUj8GWG8J9aposkdjNd65qQWw1usG7Ux1LJBw
         pnObnQP5X17gCyaCwob2WyFwL+CzKLyE1ljZ92a8MADtUFVSnvatawmdU45QWbhk/G4l
         cMmXHA+pUqE3Gai1GySHXrUTlXoexX5b4L9WFEKw6ioaW+g2m/yNSyOcHgYBX186XxuB
         rgBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1773732729; x=1774337529; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8rsh6oTvwvWHqaFGsPw06IxhO9DVzxPM89iEh6c4TMU=;
        b=dmClfS+YnDlfFa1fsxqCbMq2T1joTdaIP/gOk22V1oNQO7AfbzZ4Gu/HzrKLNpRUsu
         gkqB9j0JOmqjIvJdeWRSnUef3ZT5JNuPH0kTLt34ND3Jef4pZCHZbb5+6el/15TYzU/w
         IAIhOMP3WJPg+ufuRc/cWDYF6rrQX5HHnrdXHEXBM13t+afvphvsN0pC2mQGDOf9M7Kj
         8J/q6qw4Wwxr22Dbz2M16/NMm0jsCGmqwstOvTePSRE4uMciv3Dru+JRCUaUTBnFLOx8
         ND6oei+wGvZTUVwBgw4TUroJ2L4whzAXDmF37XLYcqycS6JhWVfMyLa8iV0bmzhxc/b1
         yjUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773732729; x=1774337529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rsh6oTvwvWHqaFGsPw06IxhO9DVzxPM89iEh6c4TMU=;
        b=F+PaI/1yqOjKSYiCEUW31q+II2uxePijn4tgpbwAy8P2YoX6NARDbkj8E5f+cBLIXj
         3g9OX2wpZ28RsUWqPvApQVBmQACKB6iUtM8xqmry3TUchF4jgw0lpg0ZTyWKxnlMgvXn
         ///1BA8iTaQZQWssUdaQXMqV0Qx6a8pF0pQ4pBKRia+Sv2EK5AeoDRDGsGbp0HPKtDAT
         RoT0WlO8daxHEsF4rN4iktm+rKgD984GcKFnnbQQALb3b7vEDaDK1ZECV/P4etDoGWg1
         UrA+Aqt/MmHOqz789ysHJblLrPs63REKBHnR9ZucYpb5wnUQHI7tbArMd6EhMZ2GQ5Hl
         nAYg==
X-Forwarded-Encrypted: i=1; AJvYcCUQ1qbRu23rlg9hvvtzm3B+73nJxT2rGI2isSNdPqrvkVmlUOeiUR8DvEl9N8yImmXpn9UfCB+9ng==@kvack.org
X-Gm-Message-State: AOJu0YyHNYtussLmkuPrXv6qNYOqM5+V8Od0mjsE+1ASe+m5t7aJVt8f
	G2Nyb/bv5IW2UHUFwOsO7OOxbQF1dGglgoFMepSk3L8uh4t/9tPEeKEGEtRF6azUScpej0JvZkL
	qXmyloyySJTePv00s8xtfOU91P9PwauzqtNx6/M/6EQ==
X-Gm-Gg: ATEYQzx6ySTlzhiueswIVrgbipmdjbG+9YmuqKWQr01eKnaoIph1nUCL9ehQ560cKcC
	M0DSHeWFQ0xP/XIN/IcwRok5xKNMBlxUd3/ANNyyrDK5mjcLYfPhl7payDACEI5zuwQB/Tdnp+i
	zas7KLCpPC4D9+OGcd9PehMP+hF3PeOlesHo3Epy3HhtuNZOdeuxnh1o1nXgmkhzhmkPHdEvRhJ
	GP6oE/pk4+sRyYsuIexXBmodRv1b/G6++s1L6jzggZV3D4cUXXHJYHF9B8KMwdAjIFw7UTdjdjP
	z8reYyVzlo1X3dkja7RB1Xcx6DrZEpy/R6QsvA0uRhuwqbjC6ObApoIBKsBVQH7dZm/jT50tMSK
	jGhakwrpEaOAdCMrCnA==
X-Received: by 2002:a2e:a44a:0:b0:38a:87bc:1a17 with SMTP id
 38308e7fff4ca-38a8966f739mr39278351fa.13.1773732729015; Tue, 17 Mar 2026
 00:32:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260313114037.3593642-1-ziy@nvidia.com> <EC71CE3C-08D9-48FE-95CB-B6A43B4BDB9C@nvidia.com>
In-Reply-To: <EC71CE3C-08D9-48FE-95CB-B6A43B4BDB9C@nvidia.com>
From: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Date: Tue, 17 Mar 2026 08:31:57 +0100
X-Gm-Features: AaiRm504dZViD7hqCg2k-u2YHFFQqbiH0S47_h1Ehq5i5K0MI7wK9iOBPdrjZQw
Message-ID: <CAON2GcE-1t7pbunFwtymxEiz1f5osT2CSEGw35Lv=7UaWFkZzg@mail.gmail.com>
Subject: Re: [External Sender] Re: [PATCH] selftests/mm: add folio_split() and
 filemap_get_entry() race test
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, 
	Eero Kelly <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 151B0C000B
X-Rspamd-Server: rspam08
X-Stat-Signature: tni8cte4x7ajn4xuegjeh9tzdrwn1ryn
X-HE-Tag: 1773732730-157587
X-HE-Meta: U2FsdGVkX195cwpwzZEfSSldRtA6+nElpuPwhugwWJM39cBpBFohJFamG8gBqxsB3nFuv5BotvxYIpEuzKfbMjLifOCoBb9CRfS9m86AMAuNfJ3FMego5nlJAFtjGdA2YFmH2VzSRd/IeoXO2WfNsLJstHpjtMI6fxEcrK91q/OKECBB8L8rftknZXN0RTPww9MHJ7wRXlkBqhR/Y03rs5TIvBSVz2TGkXpHJNrPAbmefwwF0QrzZ4d/IEQwSHSSYaknSEhxkJ+nGE/aVo/l4GywbfBohWYbd7r5YiZ6VJITVeXQAKvkywF4yH5E/m4hiXvYtDkEKjq7fvv3dSXR0x3klGkJx8S3vuxhPkzGi2DBSsG3/gcmDDRav7vv8jfyeEnDlqBfMsi6cjnhO3ZDyJnooLuOPMpFHZR3a28SxHLho00yhVK9K7ea4bQkilxpXqcr+KeWNljsyMmX3RqD6cAZMP6G6X5bz4FcjBQdp9cZhmEd8TOIpsFAIubu/jkk68zKJEhKGygvuqJoxwmD3g9hSzO/ewtF1qKWhsD9PKkB3RjvWZ6zGHU3mLy6mgZUnta/00Gfn/BA7EOp30rV0sLnasJgwLQVqTl7x6DnlpnemO0yGNf1ny6rRVDbdh9WZbD0/RcReXV4Cm9ISgYkVW2Tcr8qo2F9vNWX2IuPnQvlPAGOMMNZT5rzBH5X5imOqy8cPjkn3oGuDkrWlVSTS6ctKE+Y6meTkDyd33CGNEeist6Nl/yV6lp3tNtA8/UtZlK6HL1QcPwTuh024Osa+z/G1RYiawdHczJIUzv6dpUAr7OSxbG/4UyIS4jeREIs5CwU5+e0bs16w0aTeMzYeUdEwZFYggSYHXxGlHYmP18ksxdg9St08clXhS6JZQcseIMbDY+wMRjT+knTlpL5wcovC3btTpOsOy1jzwsgSP659YNUOHewdmja4pRG74O4dDtFCSAx+hqSVZlOn7l
 a+rDa2f+
 cP8MFTUx4Gxi6XssBjbOwA+hkIhFNLZ6OA8naqvw+bxxNVGpnIgad/JfWMe4E2e9uNbhgCn9NawrY3BIWVtbLkHG4EGskA2AGJKNqmYpVA4SiCr2ReuJMg6mJpcUwyTNCb0hSn58Pa/gnJhh6jn3KyKcXmsqrHACT6/eN6KT/tGKiNKe8S+OlQcxTZpffhqL+ZCMga/1b9+5ff0bti5TP79r9QaAsKC8+2g8L2JrPk0ghcq3HC22Iqo2u/uM+x8aO8h0wcTjJgVijASlWechOWpqAD4jpt5aKtojPURAjoi1FWJBqa7lvjYlcyFIa5yvHs0ErQiK4ByuIVYzU0lYceAqJ46ueIlLxneyW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Mar 2026, at 7:40, Zi Yan wrote:
> The added folio_split_race_test is a modified C port of the race condition
> test from [1]. The test creates shmem huge pages shared by both a parent
> and a child processes, where the parent process punches holes in the shmem
> to cause folio_split() in the kernel and the child process reads the shmem
> in 16 threads to cause filemap_get_entry() in the kernel.

Note that the fork isn't actually necessary to reproduce the issue. I
had it working as
well with the reading and punching in the same process, but just with
two separate
mappings. Not that it makes much of a difference - just in case you
wanted to simplify
the test.

On 14 Mar 2026, at 18:27, Andrew Morton wrote:
> I couldn't immediately find any licensing info there.  Bas and Adam,
> please advise?

GPL-2.0 license is fine by me.

> And sending your Signed-off-by's would be appropriate.

No problem:

Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>

Thanks,
Adam

