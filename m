Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D956B606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t09R15EB
Received: by kanga.kvack.org (Postfix)
	id E668E6B05BC; Wed, 28 Oct 2026 04:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E1C6B05BD; Wed, 28 Oct 2026 04:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55346B05BE; Wed, 28 Oct 2026 04:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A43346B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:13:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D4CCC0BE9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:13:27 +0000 (UTC)
X-FDA: 85371320454.16.5EEBF02
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FD9E100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:13:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t09R15EB;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAVWs/NDsyGnOu1pGDZ7YW8QusqcbylNwmGlYdt/fqM=;
	b=qEJx04+AfDS/olbfyqJtlozxuhjMHcPru+zcSvja+KlaSeEHsaxcxvZlnlqRFnl6I2s+f3
	SA2bYEKCEbV2pPnYSYI4UaLTfx7eGHH9qM7eAzA/wUAZjSKodiPbrU5K1L/sfeeEH3UDur
	k/t6C2U4khZeq3genlqkGOvnUyXGDSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175205;
	b=u07m/6/uOSeNmLU71tUBsDlnLc78QbY+2tVrm1n4gcyfAGEC79g5eMucqKUgGBGpDCDvbW
	GIDgeoQXcyX1gk7x1/1C2QsV8r88UPCHjMDvDFBH8K+6ceDiri7Bbtxa5d1fUtRG1pFd8s
	+UY9WszGme2eEvB05DrLCfMedhxiYAg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=t09R15EB;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so3007205e9.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793175204; x=1793780004; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SAVWs/NDsyGnOu1pGDZ7YW8QusqcbylNwmGlYdt/fqM=;
        b=t09R15EB0njgMz8BBOcT1ZgOFqb1ZxB6QW4OSdmMeaBSwQWc+hLAaPzVceT/E6qbSk
         gCOfFHklVUu54tIAZZfALIXz6PlSSAnizly1w7aoozBBer09yQab7MHvhX7wnnIXuQVQ
         Ux3s9mO2vzyeWr8Od9HRlJ6VKGrZccX1sAcwzoktxsDlz2KCRqep1Epeh+ADTlZVSmxv
         44nPhF7epcywUPrCrzOemoH0t+dgZepL3zy3qZ1IPNI+MXFkhjwlzVmHEd1l/P/2J5qS
         WQY6puAygSjm+USIzDhBO+IapMx7b6NRz6aD7PoqDeQ9517aCHGCAfarRYBBsMscIFFq
         q+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793175204; x=1793780004;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SAVWs/NDsyGnOu1pGDZ7YW8QusqcbylNwmGlYdt/fqM=;
        b=hciuzZbIYmscjE1P12bpLY1iZrTTKIgc33omDBot8PKAxfhvyUd0dLAh6NesOC8+2y
         rkY1sEyJIq+MIOW0wxbQp4tYJoruV3RsDYfSDV0Kf3595FMo4awoy2i1y2ksKiiZJoJJ
         si5BUaQA9wKNDzCZreIM7ddMsu9u7JrVzDRBky/zrVXmH1QdQwXnLpTaU9zV9631zYEv
         ePkQVKNkUsNK+I5EZhbQ5EI80IHmHKaHs6RygRgixLKAuW4lfMPqe/6oyrhZylGwKXcw
         BTblsVFewAjpWd8a3mzKes0x/6lt+/eMDiyH2u2dU9HGm/SHvyxEgtbjyudcYrOtHGPl
         GXZA==
X-Gm-Message-State: AFq9FYJ2HqG3+T++9G2mneFEAkndo46XSIhCNKsig3ti3JgPwxBmsJ7Y
	dggo3UzlVny3f0/GZrrqe9mV0FLUhRLAQpxMkg7gzsG1nXMDOxS/VJE1
X-Gm-Gg: AYBFou2VEnlCD10w+jxyyjbTTsVDnUui7Bnxk4HVeDTkbvOTR7RFmdWQQ+2RagNlv71
	+vD/qczlTnp2wb5E2L6uqx+TZk3yK2Qe4r4xWMjX2BnZDysqGeR1Jula7BdwvWRzlA44otvzFyZ
	M7sw+xxpWCitVyeMCECF5BpYAZHl+eBBG4AEgyaXYLNoGwcYFF042kkiKtvhIefZLFUrF+0wGP+
	1tQpg9KzbR5LIUwwzPj49LfvjUw+/prtLpqKarnWsRLd06EzsMID+owVHGD0Y40AkYhGxsmSbOB
	BLzBwKGyMTkg/GgM9J9ww05Ku2HJyXoRzkbww7tzyP4ruh7ygwkyJMW1iDyhdzvuPZcCKT3Wfg1
	NIqipVyrDc8nFO5kdb4hPMEWjmr8GsRTIEjOD9oHtcBgUNTgQA3/bxg1dzvbatXJvF5FHd80zYv
	oA2hU8DiAs4vsjonUlD4Tw3dgYZ7m/mrLaf4YdrPA00MFTFrih5LXQjbV4ZzLriHbqjWUbD42Jd
	d/q6otXS0Nv099e2nM0CnIWzzr+7qPEP4Y5C5V81L3RsU2qlBHnYQfOLp0xOqBNqJ1CNGPbwt6i
	3AkmLObZrVnunIwqm0GQRGTaZWE3OCbKMwrWDJTJX5ydpw==
X-Received: by 2002:a05:600c:c117:b0:4a1:e69d:90e8 with SMTP id 5b1f17b1804b1-4a9672030cbmr23856025e9.22.1793175203701;
        Wed, 28 Oct 2026 01:13:23 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a97cebf858sm30046085e9.12.2026.10.28.01.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 01:13:23 -0700 (PDT)
Message-ID: <6c73ec1a-4dc4-4c18-aaf4-e85ca73f64a4@gmail.com>
Date: Wed, 28 Oct 2026 09:13:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com>
 <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-2-cbb36b014322@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-2-cbb36b014322@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4FD9E100003
X-Stat-Signature: us4prr87kso91n8mi491etdd6wgkg8ak
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793175205-759468
X-HE-Meta: U2FsdGVkX1+J98QqXL1MV6WD6NdFIkC1qxmv1QmILkor1LWVWhWKrEUhToRQ3eBrcfR1/cMhrmdjHdEK1ZtRaF6hG/i+HpyUxdbY8TvbXJ0TxvTxLRrDlCNKBMRzrdZp6dY9brS1Vr4kZfbQA6y9BLbqPNhHk4A/Jo8jGjDu9fRX/3ZZK2tafDbwHKo4b0N0gcC99Z0nIwKRrqfI4tXQg5S59S/ItaGscKE/sAHOT/5g2HM8s+syeTO2YsFJiG+d+a5mjTTsYcPiBzAQutH5HneKr6+zWuV5y2Lt+NC2P2TAc9Sk6RJd5JwvsXSdhFO/8y4zMRXUGN8vXVeYmmaZ82n4Vt1jvRbfk4XhHBi/WbjftlxEs9QdlMW8QzmF0NHj1xuLbxvP/JBV06qFfVecQ/IWssWKchmKcnLfRKyB0O5U7ZxYwmW7pN/vVJ7ya3tS7X7Pnj/QSjtXJ0wKtSHU/KMRZnt0fhvGDuZN3ggzjZZZC55gI85zl/q8YffsjkG1kZ9TTC4Jx0/xltILtVTV2dTVW0OuQeO/EI1KvMlifPbvevCwt0gMjqUhcxDo7zH5w43Zaz24jlkMlBd5YI8uz7W1rOUSPleo/iJiTmhsbKiyzWYYMgxPGQ62AuyLLBV+TJWZ/VvjkS3mb6DYNybRdBaNPbmlTJZyBeIOegZ7tfI1sG9021JwsCaxKAdH4zYfBcP1WlPH8say5NPvt0gG5O/c7g3WxQrY2j1k75r/OYlUH4a/LpkZNSzRRb3jSEkKsKJ4xKCTGQsYf7/KkZ8ddIRA6/wvzan5EBRYXzsDiRyyVgDNTmng36FNducpePLPitCIm4H5CGBHWjuMZGRX7p34CfHZ3HWfJMVM9nmnOVTRahADsjFI26IvWol4E/ShN2ChKCSGPXLMDDvo+OFUalCxm+dWa3tPh0jkuZ7I4mW5BrMNlHe7WaB0g6P0GzAx45RVbu14PakdZFrcW+D
 j/nJNQWy
 XNG7oKP9NZ528mQvRD7Thv5gdrYnpdiL25X5q6CKjJoW0nFvd6S2Y9rKY4+lLSPY+2Y8spBf4cEb3IsBvgVQX/tpsu2GjDDPq79a75iWXZxxlLWAWBZ5dru2TvjG0Rw/NDzvYTgyT9fsONKaRm9oulvcapE/LIp3urh1cOBGDd4cjZ16I0PMwhcNrYb/cl7yR8/O+8/8gEgFM67mXhWx4LoEF1gZ6kHB+sfHVQZqDQIRorkM6VqrFB0S1LKiTUdHl030tcx9pyNRUQzdSkqnEfeWb9BxfC+q+G/TWL6XQnuojqls8/uA+UfhvLX4e/qUM6dAuw+hJTBJbb0AWb9snP06mcw0d47iZi+61S8EggoOPTuucDzXP1E/gbLVSuTBBNKku0RMgXQsHxppor6rlRe67MN5SDN1gi/hk/cXG99H+vlGdPBzPcQCdnGXBnwqW6kdWHw0OhfHMKyox05hhnJtYeqzWF5gw2bhDBXWXD79Jrp2OPFucKTatIyRdYRCriwQ8JsMG3W+m1gwabIIWYaqg/MNubNMgPdXTUKhf5UA83EyVm0sWM7gakqqhVn2humF/4Ny1LGVOBts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/17/26 5:07 PM, Qiliang Yuan wrote:
> run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
> for the pagecache folio split cases of split_huge_page_test, since
> tmpfs does not give them large pagecache folios.
> 
> It only does so when xfs already shows up in /proc/filesystems. When
> xfs is built as a module that is not loaded yet, the check fails, no
> XFS is created, "khugepaged all:file" is reported as skipped and every
> pagecache folio split case of split_huge_page_test is skipped with "No
> large pagecache folio generated".
> 
> Load xfs with load_module() when it is not registered yet, so that it
> is unloaded again once the script is done. "run_vmtests.sh -t thp" with
> xfs built as a module and not loaded:
> 
>                                    before    after
>   skipped tests                         1        0
>   skipped split_huge_page_test cases   43        0
>   xfs loaded after the run             no       no
> 
> Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 56f5416681da7..ba77fae5df4f2 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -428,7 +428,7 @@ CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then
> -	if grep xfs /proc/filesystems &>/dev/null; then
> +	if grep -q xfs /proc/filesystems || load_module xfs; then

doesn't this also match selinuxfs? with SELinux on, xfs is still loaded
after the run. would grep -qw be enough?

also, needs a rebase, 6593a15af108 ("selftests/mm: skip khugepaged file
tests if mkfs.xfs is unavailable") reworked these lines.

-- 
cheers,
jose a. p-a

