Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9351CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA8C6B00CA; Sat, 16 Aug 2025 10:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BB86B00CB; Sat, 16 Aug 2025 10:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559A16B00CC; Sat, 16 Aug 2025 10:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED9C6B00CA
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:43:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9D7C16041E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:43:26 +0000 (UTC)
X-FDA: 83782888812.09.1FFA333
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7A8EA0006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:43:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eT7IKYRN;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755355405;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yklf0U5QFdhyrLX5rUnNnZYccDAUmCcCKkGNXA7e/fo=;
	b=r6u2rlglFxRSiz1eBsjX+8FKXnAWT9hX6dLrESSsEjju9LeGs/mnpTCRwcW5RuIw4cwv6h
	P+mkDzm8VRIX5IuIUVRywOu3RPhcP61/MlWoJ2YpqkvjID/sQqismOBwlfdJVtbGchwoCp
	GkZEY58Bd7FyHz7Qn81an9giK4D3aw0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eT7IKYRN;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755355405; a=rsa-sha256;
	cv=none;
	b=MAqsAELLEENMVN0H+fHIxxzEzuxvR0sxAW5dGPWf3XaYf7khmQkCD2TihnN12qItKjh7Q2
	r/bMDh5jRZ8bthnZnGvSYmL03DlKUskYGl/wS6kZNAPW1I+jTuZLGNUPBpT9imXXOdRztQ
	C2Crhgic/pVAm5RwSA5ujNebaXWNuA8=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so409613366b.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755355403; x=1755960203; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yklf0U5QFdhyrLX5rUnNnZYccDAUmCcCKkGNXA7e/fo=;
        b=eT7IKYRNhpqtPAhPLHyAe/KexH3mSYm7hI4S5MK8EL7V4xa0MRRk4be1Ge6oQzMCxo
         DUH02xiNdXvlFSkgt90CUBq+sf1z1udz4UukrrhWUU8BDhG3TN8q1T8C+t7CLqf6RQzo
         +94cdnwKruoLD63n76KlYjz5xCrA70jfJL1+5rNSrYoN0sD6saOR12Z92x9rdj1bTRXJ
         /yD9vYLLnJDlH4b31YbDt5ChaFYBle9YbSyjGnyvN0mkIIJs1MfgUdOF+xjk/s36raQI
         esU2Dn0CdRZ3pv2UeSo9++pFIKF7EeIhbRDOfS0CpPHMcU9g7KdX6heW9KJwHE7Kbp02
         DlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755355403; x=1755960203;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yklf0U5QFdhyrLX5rUnNnZYccDAUmCcCKkGNXA7e/fo=;
        b=fBQLBY7+WBvbNCIS3sbm1Quvf6eD4Ajrk4w9M+0h5TFUy0jaX28d6K+NYs0SoHpzoD
         cpuYhJoagg72MgseFpWrn0xQZwWpvALay4M5r9xjHblMSe8xqTuyWufSw5GdDR8lrbWd
         qt9ApprIkumaq45BIpfPdwNgmdM0dWRhBXHcc+Do7V6Nv/7vxmB1YebvGuuRUZtyCGqz
         ypSZVNtvTc9kQEVHS4iT6D4xh6nEPVho+dhEqdT8Rzf/BIT/rZ383/CA8+Us8FhSXUPl
         SCf8wj6HmOXqiQCWM3Y5qyRZmQCFwNusfxWmTCSQ0lJuloilIeSItEJ1aN9HzGOXlHfh
         VPQw==
X-Forwarded-Encrypted: i=1; AJvYcCV5wGa0ywExqlhmCHSWFh5cKLo6uLvt/3jp9b1ZLDU4JZCOArpEbmEzLtPIHot7oor4AXandutbcw==@kvack.org
X-Gm-Message-State: AOJu0Yymzn/hehFq7HLPm7Lc+De2FoHkNhDBCy8OlW8uBumYiGXXPvN4
	zrRieGZv8MCCVIF3xeN7EDPgnOjGa//ZuDeeA7KLhJxCfdggAfN6WkWh
X-Gm-Gg: ASbGnctYrMfjAIPDbkMZyUIbTvg8ueNZNSIDUTM96yC5Mx7tPPRyizc8GUHrxRIVkHu
	XYWERZUNm+3hjeBsHAdYx/JcNta6R3kCIj0evtY3rALeg0YI4fV1Otdb+BElVZlqw1v6KvvdPCZ
	/4c3aco+E7Pg6N0eV+oaHjxzFIjcuiZRJHdFEQYlzXojUck8F1bNkFSEzSu7EJu82g+zbvV9ciN
	ENGCpzJMsvnZpgZVzUPl1Q6Z975lpmvwRAtLLvsEC5GBtFT9TfP5f+sdyMWDhn+g5tnlHWPVC1B
	uzGF8feUjF6rVn3HuhvdHqMUr5vU8bzsXldVjzOz2jXwk7ZclQ1fOjywFLq9xuSgQ4sfhCl3xPu
	YvtxwfAByhnJ96iN1qTIDNA==
X-Google-Smtp-Source: AGHT+IEGqVbAIDII1mY1gCF9jBAvWgrpMrhi6faWvY2jr8e0MUYDYVLLmVWONSAn0yE+VDd8vjzzzw==
X-Received: by 2002:a17:906:6a0f:b0:ad8:85df:865b with SMTP id a640c23a62f3a-afcdc288daemr532008566b.33.1755355403259;
        Sat, 16 Aug 2025 07:43:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53f5fsm393726666b.2.2025.08.16.07.43.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:43:22 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:43:22 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 5/7] selftests/mm: fix child process exit codes in
 ksm_functional_tests
Message-ID: <20250816144322.nh7qwwfiuhnjp76g@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-6-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-6-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: D7A8EA0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hw7enhja68ybc9khk1q6oc9mrrhb5psz
X-HE-Tag: 1755355404-242810
X-HE-Meta: U2FsdGVkX18/+ai+OijAthDY3ZeLWqdqmFUVWJN9Vewc0MeCHOP+McWhsIHMvuP0ibXz0ygPQOe5eT2szdMDr6TSqdNMFpJLY1KEdY1z+O3BMjjlQgSMSOOMQT1uN28iAfsX+rDul0JfbWm9qyrBTojxKhqFAV9VxVtmGaQA+VZZb+2MhK+JOLoEkKOTeOFXdDuZjNT/XJSWlDh0GQ/VqZ+oyFep+K6nHjKqTEZTuI+ZGdY60MQov8DuGixnRqm7ksf2XhR9zM/zKP+nVz/+Kz4vS92kW4vdR/wD1+i1dD534wmfCdifj9S4J7IgS8DVjHg9IqjfXjGGrqGmhQgL/A4JFZzgxsRN+2fM5tnY81ufz/lMmKgJVyJ2vx40XK4NOMxiZ6jjeaCr9umo8Wey660FgCUj5jBtBqXH6W+n30Srg5nUqxYooeE89kqjq8I0YFWuNAwTp450pUWgx61pzYHmrFvoG2bksmwR2tW+Lpvl8ZBb6SFkPhIQrtqgYtBGxFk97vgl0mx9bmhxpmu8vQfvZ5rHNlM68p2RFoMTdoavnk8o2GE/e2h+KPm6N6H+84BnIfunJKSycGjODpcJcP0kNpWhMNi0qIU5kzUfx1PMRDKdcxl5oEeML4oWdyxH8hxA4JZ2xrh+RCtRY1WyNNgqh7oiDYEtKiOcfM5BFHq8giF1e7l2DuFby9J0o92Dq6bdU4guWVqjakZp0jkaIPJro6meCnPfqIAWONr5f9KRtr7jbSZvTLO5oRPnBmtJakfDnrVerBYwUr4924ekdn1Nv24HN1FEthcsB/KRd004Pn5nDWxtdUepP3GtWrQ7c8Pg6MnxBa9jFKCF4BKZvBPuL+z4bFcfbANE/e/MjmAdMzWOnhZ+B1T017sSKP5/CNI8b7WChQx1w3m3jYAdl2dxUSPDWbzm37SJUseyjPYWicbVkxXWpoXSYRbtNIHIu5PNVgS1206/c7Sp2KV
 GZzveyuH
 mvYa1sHggYOT5tetUvtMYdbpgwNXNqH8mHZjvxDcqubVDVSWrm8P83qWjcH62n4bWMljs6YY22FlD4+nJDF4P4Hm5Kng5AGWxwTKp/d0Z0mcAU4ufLrb3r/JvItJ/LZDAqy3G5nBjYlgQjHzclzmSmcwO4InnSm/NsWhuKL3QvXtwCwc5BXhzgG1V2IEeGZ5gF1Wl4UyG5zdkpcHA+JmAwPrLd0yZinWK7ZYYPwZiBwrB4gBBTTlg8OfJQPPcJAqLpTvFZ8fQaWLaYeBOpfsiCehSSDYNfQamic7uSLbuXxsRz1kjLUVvcOI/cRU5HtBzCoSpZg+lbFVxAE3VXP9bNP8tpRNfPTngW02RfvlPoSJvaBV5bCNiPAE3G40IixB5l7WhVgkIfMOXiMtX5XTDjWwSn2LBSImE5M+yVqOl58WYOJtymhvzQ3dSr3E/J4ihYEp0nJXFcSlhX+z7lxNUiZe6PmvsAb34hMY2+a2+9uxkENLDsULbKneDie9Hcze7Viqd4obcJtZY8lUpk6vT2JfO3Nc6piCLXGdqh5biVcqtSa6zgHooC6k85iWMPv1bQq6caDZZPhMEWy5HKHMdEMtq2j0BCAkqoq4Kr+SetrSRgZSQjvInxyYmOsPafxtInj4KtaS5UDzOrwjXggBLzR1yicU9ozCcoqLhvxYDnyHFlvEo1kUreCoebmWf0onT3f2y9eQqHZJ+X9qI33jZYj1bCagb9LTg7caCjFDoTtXZDH3FJrsNMaV/ogf54qsJHqyyarrqp8+cozJEdMUzdYSyQ+qVD66ZpzURw5W43V6c1P7I0+oywIJkX8nHsPA9Y+KQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:11AM +0530, Aboorva Devarajan wrote:
>In ksm_functional_tests, test_child_ksm() returned negative values to
>indicate errors.  However, when passed to exit(), these were interpreted
>as large unsigned values (e.g, -2 became 254), leading to incorrect
>handling in the parent process.  As a result, some tests appeared to be
>skipped or silently failed.

This is because "the least significant 8 bits" is returned to parent, right?

>
>This patch changes test_child_ksm() to return positive error codes (1, 2,
>3) and updates test_child_ksm_err() to interpret them correctly.
>Additionally, test_prctl_fork_exec() now uses exit(4) after a failed
>execv() to clearly signal exec failures.  This ensures the parent
>accurately detects and reports child process failures.
>
>--------------
>Before patch:
>--------------
>- [RUN] test_unmerge
>ok 1 Pages were unmerged
>...
>- [RUN] test_prctl_fork
>- No pages got merged
>- [RUN] test_prctl_fork_exec
>ok 7 PR_SET_MEMORY_MERGE value is inherited
>...
>Bail out! 1 out of 8 tests failed
>- Planned tests != run tests (9 != 8)
>- Totals: pass:7 fail:1 xfail:0 xpass:0 skip:0 error:0
>
>--------------
>After patch:
>--------------
>- [RUN] test_unmerge
>ok 1 Pages were unmerged
>...
>- [RUN] test_prctl_fork
>- No pages got merged
>not ok 7 Merge in child failed
>- [RUN] test_prctl_fork_exec
>ok 8 PR_SET_MEMORY_MERGE value is inherited
>...
>Bail out! 2 out of 9 tests failed
>- Totals: pass:7 fail:2 xfail:0 xpass:0 skip:0 error:0
>
>Fixes: 6c47de3be3a0 ("selftest/mm: ksm_functional_tests: extend test case for ksm fork/exec")
>Co-developed-by: Donet Tom <donettom@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>

If so:

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Thanks, I am afraid to make the same mistake if you don't point out.

-- 
Wei Yang
Help you, Help me

