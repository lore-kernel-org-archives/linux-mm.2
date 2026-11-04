Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EE8606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=R8lxcv0q
Received: by kanga.kvack.org (Postfix)
	id 495676B05B7; Tue,  3 Nov 2026 19:44:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E1E6B05B8; Tue,  3 Nov 2026 19:44:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DE16B05B9; Tue,  3 Nov 2026 19:44:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F222D6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:44:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90A881C3DAD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:44:00 +0000 (UTC)
X-FDA: 85395589440.20.854A498
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9788DC0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:43:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8lxcv0q;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793753038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jCvTwZL8MS+SjFAQ29LXN2yWrpb5Y2gngTvzYEqhZ4=;
	b=W0jO/XSLPDClpTEeZItR82vu+j+XZjR2awVX+YIS/sghSs/RvMS5uDatpD4eQ2jQxOrKcG
	bESs4tiYLmvSC6e1u4aQJ23HZe9wLTOtBXSo0q5ESwCRpIavieEnd2sbZYO8Kll6RDOSrD
	0rfAfJuq3jsXyanQVRDRp9ZOj3sSDHU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793753038;
	b=3vttsrj+xUAc5LkQOE/cK7GtVLEPakCX6CsES60m+xoM5slZUCrTCfNcfTlnzxgZqqpsl+
	oIQB3JTJnQhDm3nMzPKZXuick4Cw2ZDH+x4nXCRL16nsgPZlyMiYUOsQKqsE/ciNXTks+f
	rxn+WDbqL2vju62/HOAJB738lnxHP/s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R8lxcv0q;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-7cc1cf48a39so28009137.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 16:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793753038; x=1794357838; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1jCvTwZL8MS+SjFAQ29LXN2yWrpb5Y2gngTvzYEqhZ4=;
        b=R8lxcv0qnT5L2IWsBNGlXSPGB0NqfNUFv8Qglcr9B24q3OdFiTzYtwysiJ+LqnmmRK
         zzDg6ar2+aecAW4km3V1CsXOss/xcZq0GCkaivxQ1CIXSCYJD1D8l1nDaCK2qurtEm7O
         SueZ3oH84hsnoZdcWiGII+BK+/WDSURw5Tfy9WExziiKKVK5hJ/bbpIYzfISWoSMAwM8
         Q4mmvzDOdGj0ihIGC1oyYoGhtKfqwufSqNf0C8s94Yul3gAhTznj8qsBevi7FigYfatY
         CpTXA5qn1gk0buar6LKdlKQ8uRvGOO7rp6AkTAg9OSbH4ZALWrUHS8AF1thCHXgb/4RP
         lY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753038; x=1794357838;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jCvTwZL8MS+SjFAQ29LXN2yWrpb5Y2gngTvzYEqhZ4=;
        b=M8rb1QlCaUpICsOzsgmBDKXCBix3Y3kUzn8/q40dBX2ewZ/1r2MMH49SABXX2B4y8u
         cNqnA5CBBRjTWWUK0loG4eAgXL9m+BUiJc6JGoSXvWgQ+epO3V/m2gGCbuHvlinWxP0J
         Mv/bUwPgqNec7vZbbzUOykIi+zzPXOOJAJO/wGRpu1LVTWFBHrYOAJybPPKb4URMeA+C
         UlG4Muk2lrOo5ljluJhumFOCXtwoMTIu0BZW2OgP4wupjeBbr+VDywV8/tqd8dilmamG
         68sr/5LMtisWU5wvVAx8tayaGVJ3ESKzYXam5JuFCzxMLej2ARFuoVCoV8H3SiwWggw9
         BraA==
X-Forwarded-Encrypted: i=1; AKwUvBxwoNyH75Y9qJ65H7Vq3IjH/O92yREJ493aQkvQ87ua3IkxZiX1nX3j1Q62hQXx8nVVVco85cGFeQ==@kvack.org
X-Gm-Message-State: APuU4Z+90WKzEZ/JZycjokhRb+tMy0IEwNQ3xLnl/Xv3Lcut8n8gBFzb
	LOfpEK3SBTjzUW80NMY5KHBP6dlnzxSpaFqHY3UWwicyr1z4SdmAvX2BHq28/cYtNyo=
X-Gm-Gg: AYBFou2UT6OGAn+nAO03tv/pxbGGuYhjTNKGm5i2ayW2NY+3Po+0ecR2sjyGgdSL7Fo
	rr85KJJxSguaZFzpauC1DClRP1gPnBzYmjEUnnxB+9YcNRacuU5n4oRdUX34bW2vU6RYE8oRilV
	k3hBzUptlpge+wfk+CMRtIblEQbefM6jfHsct5sqBhyC4EYoauCXIntB54KvrAnofx7XT1d7Z2F
	2U05e0Cq4bSA2iVAVzkMs3WHfdX/N1poImxSmOYL4N9x2vlmDpVdorJbgY21W3R+1b7mqBCxhT+
	MnHLx/F/c0gKWIczCKzOTIIz2wXsL6CJCc67UDptOI1e+GIiN7h+6ogm+VveMYikCcVwkot0PPu
	ffFhOM9deUpgNjCSCC4yi04pIandE6owbS2nNg8+R8rPGgdjwwBxUCu/SJK0GdzN0Sl/9LxGr10
	A+cY3/QK95aQB/7ysaI8DExHIUYTvDkQ17hhb+dxfiiD6E168cnlYQ8wt5FcuczYcrmCTaPwpeB
	QBi1ahvce58vnCuZA83ijhmnEfBVjPls2fgzIHJGZ8psb7Kb7DQ49SEo/qflgTBB2af189cEdel
	Y9qf0PDS7MDby5dShO+xioLfdKltU++BlOL/odHCciiS8b7aS1pcWt+MNrW8B3eq5YEgrK/tpMy
	N+bF35voPFekge2mLKXQ3E8V5BoFqnlD0sGMBvLRO7LBR
X-Received: by 2002:a05:6102:358a:b0:7c3:a6f0:99cb with SMTP id ada2fe7eead31-7d072719913mr4878960137.33.1793753037717;
        Tue, 03 Nov 2026 16:43:57 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d26fef4ed3sm527432137.11.2026.11.03.16.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:43:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 10/10] selftests/liveupdate: Add a test for
 preserving tmpfs files
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261103010216.3447716-11-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-11-dmatlack@google.com>
Date: Tue, 03 Nov 2026 19:43:45 -0500
Message-Id: <179375302575.727293.18102345692701869647.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3188;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=1Sz+eMhTI1TOTbxgSk7ZOC8CrCJdIfx3Ze9Zg3ES4c8=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq6n/FzIqSwYCXrxsnr7zksMS5TfAEmFOQUj9PS
 7XxUL7XYFyJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaup/xQAKCRC7dyhM23N6
 3nTOEACAI6TfigjjQvteQKuwVbfhXqGx6bxoozDfCeoenFpsOHHU2tRSPDHrF2LinhmG2pyX3Q8
 IdNQ59F6clZBMmDb/eOe07rYUzfUWj1TUdh5D/SLuP13olwOUmaakHONOrG2Uaporgy7rW/JvCo
 H2L7Jk9k9ONnqREnNjgeAzTwu/zmxI3kBLYcpoEe4e/qloHN2LAqn6iVZB5b6I/duQg+0sSKEgp
 qF4OBNh/aIA1foatwzOu597LOjO9yQGRV3iBJJYo51P6K86O3J78ymlKWGJLCLMOMPk2DZUnR8M
 jLp931wUPz3YeNyDlYE5pYInd4W0IpRLQkJs6piLRVQ/conGIWbGkL4KSSoQd/2jep3AT+iLZxT
 nQX3w7DUGKtNX41lNlBN5hBRLIL7IBK7aadPhrKz90SJNGH9ZPSeFVaGtwJRjGCWrPppwaO06yR
 VysyPyy9uNhOKJSHmwBYeXEJddw81NZYJIjeslUtu59vWS+R+q3usDK/yK5jNy6E0h6vvuwyhuI
 gmJeftNu95dEGsoOiTdU/+eZlCgissKpCpGEEx1LCEbcoV5iULkM6cczYHziRUNy4WEnse6TYs5
 JiM5brFJchE2M/+FwTTI00ZLZVJRSQ+PZmsg6nEdtwTUZDUhsHCd0cXftsjhObL8a8SsH7szZ7X
 ktyDeGGGs1LNQ6Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam06
X-Stat-Signature: zy6ixw6tjd8k9os4hxbcf3midygrd8xp
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9788DC0005
X-Rspam-User: 
X-HE-Tag: 1793753038-412166
X-HE-Meta: U2FsdGVkX1/7uIzd9OJFw7TsR/alaL5/IMNggmusRmy3b0KUFnnDNTzY2dQW55/9gUX70XPXH0S1rh3g07c5Q5anKGx6mz7JVPsuzTY4wBzlpnF6hV/J85IEByBaLS7uN52m8kCsJB4Mt4GXyV/JuGRBX01/CNpiDgmnaHV52OD1qmwJV6klyrDKL3hVyYY4DAiWGMD0CYVh56S4C5si3ZbCgGWFzvqVENIRAjkzphUouEodY/L1EO+EIE5tIMmCt400r4+VRQ1KoUzfrUYLi8qAXMYAufOsRPvOxgsH/62iCd9M/FZKiqMo4XQc6rcL0KEiqlK0TWH8YMXEl9SZanXL6/976UH5BwQShC83m3bTukggfCA74svYm5st2TAObN5mloRahVVy46IcCFogtraOfXTQR5KX/7u7hG94E3sJVIyCg97IqWG9xYqwGu4zRkZgV1gas0XHInom/BSXNwLa1Xr1tgP5U1LeX4nuC8OV+X9kiKz+nl7cWhK9jXMe/2XQCtqBE5effohuI44X/k7DaQJk72trJ7UXII6AD76KpEYufj33mktzWhbD6IGx9nz0dce8Ewb323/FO6qIuyKRQuGo5b5LAPGCTI2Nli1VpxbrTSwOrHDcvpXFU6iXN5BhQgUF+g6fNB/5+Xq29ergOVtcrRSHLGQ/HdM3fa1NQbKIDCqQNZDVXzYlUrUkTsqQAtaS7mPoyLcitWmRjLodGkTfKaTi9a8zQJ/wuRGir67IqhepWx/9alZWuu8xCHnFHsFOWAq2Km3+s5RjqJ3+BmL1cnOtPSBCRynf2y7mvlKp5hgcEezpYtdfrpZ1S4jO0U0hWeCFSFBZ4a6FT45jrhdkC0QZR29kLBnDlKNceJL5EQnNMNLJFFHWp8nreNK+YTpnizBtvsMnjx7islyLDlBbDia0ih9ZWH1VAWyhGMqMdaDwY5qqpB0TBgVom9xg5/qgcHXNqlBLPYL
 j5be6pcp
 bK0TyjZFBMDo79SLd81yUURY5XNprt4R3wzoRMXjkLGS3cOIEeJD8b30l7XS8ZAt9OMRAKklG6kWLtbHpcZMK5zPtRg7A9hGFx9o/dZy4K1NT6pq1nH1FPm6FTla44Y68ZvWEix1qH8uJ+W+ImJG5d/HWbu1ot1EoOS0aqauue7kCEYP/Twe5csHL7QP29exqT03IflzW7y2T6me/fh8bXV61beDGhBtK+jFQ3WxCP5I29caFSvm4kP3+MAPxFj36WlzJFAQOcSo36rdTjb6hoO6JnDxLcU2NrzPi7QaoiGJWn9JpUlhEJVCk3AN9ll3b38ieauj6k/Htt43S9K9p3C6R2rADvORNxMbeYOlSaIbWco1zGQq3KUzvJgu0sG5R1AYwBeDkvzFBrnnpQKFdZvq1qZnnWJs0+K3nXfZpGAn6GBU1dD474b7c/XOiP/eca1al
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Add luo_tmpfs, a kexec test for preserving tmpfs files and memfds, and
> for retrieving tmpfs files onto a tmpfs mount with struct
> liveupdate_shmem_retrieve_arg.
> 
> Stage 1 preserves the source files of each test case. Stage 2 runs
> each test case in its own directory, with its own tmpfs mounts, so that
> block usage can be checked exactly with statfs() and st_blocks. The test
> cases cover:
> 
>  - The restored file: contents, size, position, seals and holes, for
>    linked and unlinked source files.
> 
>  - Creating the file: it is created like with open(O_TMPFILE), with the
>    requested mode minus the umask, owned by the caller, and not linked
>    until userspace links it, unless it asked for O_EXCL. Also O_RDONLY
>    and O_WRONLY files, other open() flags such as O_APPEND, O_NONBLOCK
>    and O_CLOEXEC, read-only mounts, and directories that the caller
>    can't write to.
> 
>  - Preserving files that can't be written to: a binary while it is
>    executed, through a read-only fd, files on read-only mounts and
>    superblocks, and immutable files, including sparse ones, whose holes
>    are filled. Preserving someone else's file that the caller can't
>    write to fails, and so does preserving a file through a write-only
>    fd or an append-only file.
> 
>  - Executing restored binaries: a restored binary can be executed
>    before the session is finished if it was retrieved with O_RDONLY, but
>    not if it was retrieved for writing, since LUO keeps the file open
>    until then. These test cases execute copies of the test binary.
> 
>  - Block accounting: the file fits a mount of exactly its size, and a
>    large folio that extends past the end of the file is charged in full.
>    Running out of space, or hitting the memcg limit, fails permanently,
>    and leaves nothing charged to the mount or the memcg. The session can
>    still be finished.
> 
>  - memfds: they are only retrieved as memfds, with their seals, and
>    files from tmpfs mounts only onto a tmpfs mount.
> 
>  - Interactions with LUO: invalid arguments, which can be retried,
>    retrieving a token twice, and outgoing sessions.
> 
> Also check that the size of a preserved file is frozen, and that the
> test doesn't trigger kernel warnings.
> 
> Enable CONFIG_TRANSPARENT_HUGEPAGE for the large folio test cases,
> CONFIG_MEMCG for the memcg test case and CONFIG_TMPFS_XATTR for
> FS_IOC_SETFLAGS. Those test cases are skipped without them.
> 
> tmpfs quotas are not tested, since the test runs as root, which is not
> subject to quota limits.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261103010216.3447716-11-dmatlack@google.com

Overall, I like the series. As a follow-up, it would also be nice to add 
non-kexec tests to liveupdate.c covering preserve/unpreserve/freeze and 
restrictions on various tmpfs files without rebooting. 
While that won't test retrieval, liveupdate.c runs as part 
of regular kselftest by pretty much everyone, unlike the much heavier 
vmtest.sh run.

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


