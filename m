Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332E4606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PbW4Dq0f
Received: by kanga.kvack.org (Postfix)
	id 37D216B05C3; Mon, 23 Nov 2026 10:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355BF6B05C4; Mon, 23 Nov 2026 10:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2456B6B05C5; Mon, 23 Nov 2026 10:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F063F6B05C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:10:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90B1C1C436E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:10:09 +0000 (UTC)
X-FDA: 85466719338.07.6E8662B
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A55340008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:10:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PbW4Dq0f;
	spf=pass (imf12.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lylin1023@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446607;
	b=hpm7dSdIZvo8itBz4Vth0abywdf23aqbbdFLSAbXFwx0kQXA8Iz8/+cYSk+2p52DpZTvpq
	wVQTJat5PLW2nqm5tnA+JXsKOKxRuIPQooBLMtA9rw00xQxBPjHSl0B6ArqyzdENuDHTkl
	sFLXye8bYimuhcilxyBUnH/BueXK8tQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dz52cAd06DhrS+w2eA1gjA1iPlJT/ApD0Ocp67pISs8=;
	b=6vaBadLnbFWNeJQVaeDCfDJn27RIixGFHvMi1VWvb3pCZAtSi7MbzCjk0YN5aOBRMWZsdC
	7fMBVVojBAXd3vJltf05bPULIkTaIMBFFfs8n/qQcdDjSVOd7ftYW2V/R1Q9OnZWn586ci
	ohrNe3Ayik4xMHsumW3Nie/C8ytK0TQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PbW4Dq0f;
	spf=pass (imf12.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lylin1023@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8c4cc85a315so2535676b3a.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795446606; x=1796051406; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dz52cAd06DhrS+w2eA1gjA1iPlJT/ApD0Ocp67pISs8=;
        b=PbW4Dq0fLHTdzpayNlJ9oDAf27eCf0RGOWqZLkBb4ZVsfPN9Tafc4F/h3AronR77+t
         YHr5ub+itsFRR+FuaPljrQOQqEXFgx88Q4cLfAXSfbBZUieaFSAAhVO22K9OtnvkQ3pp
         4cqj7aRMtMJodc00Lc5hQGUzdd+eZ1gh9G85mHnirCMnuQIiGjA9qiZOAvJ1i1gg+0UW
         Fqhn7/B0aeVP70AL7uPY4ezx+WGZqZC6oxuniVKc9crdXo/7g3T0A1zxs84heFGPQgbZ
         k157Z8AjSwcUJxR4cMpUD05m42arS+x/Oq0bIVDkHiyLR5NJBijIaiPXH4wxUZr3QBf2
         M32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446606; x=1796051406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dz52cAd06DhrS+w2eA1gjA1iPlJT/ApD0Ocp67pISs8=;
        b=sBFo0BENP38a0qIbSIxXrH/ErxPyKZUFNElBdh3YCpL3t+lwzp2nOF9/1aaf2lMYNo
         nAGiXbHeKkSNlKL1lMg77hnSjzYh0XUSOBIeNS66EM34ILKAp5nQylvM7nlry3aUKSiF
         swx9S5eNDL1+ETn9Kj1wn7vXCh1uSR3u6wyy+kyiOY4Y8gJofG4T3OYLhsWgNisNSBH4
         BMImlxcH2tPoHtAO2cegYwA2j/MdtmkFHwiWtcgKcvJJyHcM8g+zOsSfOW5UXuwtKDJr
         o0uAJ70Ccwvy3Yg3Sw7Z1HRNyBW2HKy23TU+/Gor0pk5G3EL4tB5dGGn4z8xzXpU4qk5
         fWFg==
X-Forwarded-Encrypted: i=1; AL+hErHvLgDF0p1vxasKFxHUGzFrpVHXPnwmpN88trjXTJtOaachavlr5bk+q6Y+w36uKS8blqmNSFWsPg==@kvack.org
X-Gm-Message-State: APuU4Z/kGe1YU2XWWx7/W3IplmU10A/SZaZzvzvg3hq4Univ8pd0KSUU
	FFPj/PruRxjrBCkRp9HV/Rj+rvgM7mQtpuXTIR3wKuyYfSr8fkHdFMl2
X-Gm-Gg: AZFdTZfNo4K3U8dqWXhp2FpIv0ih/ENl9mGqU5zv5ZqVoBolzJrvzt+D5dAqmXIUS1C
	9G1dh8w7HCifLnNJazIoUmDQmJ80jLpTkeAYMXMqvfFez5fv4pCr/pWARRZJ1xwVbAqioiCPptl
	eagpjiHBvyBbKJ1lMQoih2/hNNmMoBAox5TBxIVwSZqi2E/Mn6JPPEqGXmk97rN9D3gPRjwrY61
	vf9tuU5BrH98U1pFM0ht3KtUPsa0gwiPabnfPBWdkcPQNs9+Po99VnRJI4IljR7r5xce7POtuka
	M+bac4qPZ82a1qARmTH56G6SVHFXwPC4E3dJwszeB+OClFDqI6aPI9Ln4miPx+MtcCYdz44YjUG
	Uj/iCxDhSLYnRoOIb7nMqdm4o+QyfKlxtS9zUbG6ZD/rFYXIG6r4fz4cGNhb6DuU4dJkei0SkOk
	HkvgzV5iAYlYM7Qn2D4d4jiccIyKoou3hbIICWBHKN/eqDtFvrm/q/0S60Wl6nmuLFAHhhQfcDZ
	5I2DE48Cfvjo0Ts60zayjEfQWNMzLcgCFh7o2ZrXK5epEClsyDQBIL9KzDqEfUi+ieX2IQJdR6G
	MYxVNhyavzML6eDSrl92d7gxnRn3N54uJxmzejBCGX63FJYyU6hUsIO1T99BHQ0OReoJ9mWdWuj
	mv6uH7iKRHwfuVOHK
X-Received: by 2002:a05:6a00:928a:b0:89e:6bef:70f9 with SMTP id d2e1a72fcca58-8c87bfa8116mr10077691b3a.27.1795446606284;
        Mon, 23 Nov 2026 07:10:06 -0800 (PST)
Received: from localhost (218-35-178-218.cm.dynamic.apol.com.tw. [218.35.178.218])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c86d821637sm5956464b3a.0.2026.11.23.07.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:10:05 -0800 (PST)
From: Kurt Lin <lylin1023@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Song Hu <husong@kylinos.cn>,
	Mina Almasry <almasrymina@google.com>,
	David Hildenbrand <david@kernel.org>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation scenarios
Date: Mon, 23 Nov 2026 23:09:58 +0800
Message-ID: <20261123150958.2212229-1-lylin1023@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <apqBn7tWDHQeMrzB@kernel.org>
References: <apqBn7tWDHQeMrzB@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3mrytqdw4ptgxx6f585mh74uubiwock4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A55340008
X-HE-Tag: 1795446607-832329
X-HE-Meta: U2FsdGVkX19FV96N43/cVeDVWk72vHzFjOHnCgID61RStaqNdiI5XonzE4t+jvfqTXtLiOXeIi3pDUmmpihuHU2Y11CpPCJs1PZlGzcaeqYYb28+oNSm1aUyp+jD4Y7q+WC0Sh5iZqIZN1fceZnz0I+Aj+852Ss6yopFNPcBjnwdjLK8+TII9vENQygK2zX3VE6Yo6IK2HxjJMgnEFEn0hegk3zf0MydUxtS35uMM6gD6rMKvYh1LyBIIy7Ic+lG3RmNje34V2HZhbKN9INh9kURjNKOJ6Y3e72fAaumQYgF3TwKkF0sP7+U9/HkUrTJ5zJvb4ik6MgOqNHxRUnBWpl3XdHyUAwrJSnjm8PASSMCG8Z57e39QKMNE/gxhCo4hX256MfxRtwsHPfE7wsYbHBcOXWgyOfD2Z3cyJLvU/BuzowkEeFn7XGmsEH9NT8mFcCUykfI8m2XxcQaUoYDPiSNRD7PeUrgKH2f78GQ0Vp3ixQv8M4fxkZaQi4X8SVY8hHjBIXJWANcYsWVYuRn4Pj4YhQW9Ii03hHgqYR3Wk2z3fwf0EU3hhxxrg9n1rdtNMhAPBuGwUbs/VM1Hc4n7jirr7LCLuf7eDE5dawBXBDTQSWCdOw4UhJuHYCqi1qH5blZ879sadsC+J6icJ/PR6/9u2sXjanxihaX8q5wdB20qtfj1faw80GVEgsQaLuIHrtydfOZ5E6EpD9AfqemrzQETagi57HtI3hPohwDiLOxwz9jn2lq6RDz0/84lKfBnl31HAJWD48slnpZIEWg/to9LAKSeblly+JdOU9hhSb6gqzBCYgy7+Qg8wDTMOHihb1NU6LwSaVTJJp13XDJwM9lmW8L9GHquvsEup7wIjLKcbll/wobplC63n5apQkQTnIssmhtmqqMw6nDR4qWEFcuL1aR5W4tYyQsYTChGq4xFJbvmGbIa5kFGNcTaUDkwVkwyWFmkbTG5TwDotJ
 XWdFIWXL
 8NAb09IMFpnx2wmTHW49C9ysmOZi/5GIl6Z7DXHCj9ogUlGHy+S9imEdkFPklx6L3ppNj2Ri9MWtrGkpOpda82sJfMYNBhJj9hcgzecnT6Zwfi+PRJO7TyrYWkH8y3pNgn9iOdkImhzSjq14as6CHnRubO8JLzko+bpEmFixgR6uiip7C6UpUDFPcOqFNeccSmZyopXLk5WF9c6yY0xSXRQc6RklXZNM/7PIWQzBdnWRmGDFVzAFRrv1F+cm4m5aem6IlmpBzzpD0je88fHLTIaI/llQyqE461VE1Tu116ZMibduIp6FmPuYqMOUOZPr4uAcivddein6mHKbS/Z8erImbT0GUgD/nomNRjtLGL8MVdKzZza2SqUNOkOb71JY10QUhOZoQHdR+JZSCfITx+TSbXj0l8UIaY2uojH/IMLksX24rNhugiL1NJMpajMplCA861SjNpw6bOE56tiY1irEExW41/WK1kKNTi7hXYdXgfNE6kRJJRflgiuHYAYspSEI/Vtmfg3GY6WtAviBPzcWsD2CrOiVgCQJsKIXPJOu790BD1OO+m0/6curWU6lJqQGgwm2+/Cr4L/XnPSzyvtAfz88A8o77Ic3Quh/jAVSX5fYDbFLZHz0vmZmrBjfF9rEMRstDXo/t6bETzmBgvjvp03WdIr9dLnl48gXBa0svUAlwKK8VyVvFGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Sep 04, 2026 at 11:30:23AM +0300, Mike Rapoport wrote:
> And this code breaks our CI e.g:
>
> https://github.com/linux-mm/linux-mm/actions/runs/33040981840/job/98414290236

The hugetlb category in that run hit its 300 s timeout inside
charge_reserved_hugetlb.sh.

With the stray 'continue' gone, the "more than reservation" and "more
than cgroup limit" cases run. They expect the write to fail, but
write_hugetlbfs_and_get_usage() still waits for the full reservation,
so most of these cases spend 60 s in wait_for_file_value() before
moving on. The CI log shows this: hugetlb.2MB.rsvd.current stays at 0
for 60 polls in three cases, and the run is killed during the fourth.

Skipping the wait when a failure is expected, on top of this patch:

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -252,7 +252,7 @@ function write_hugetlbfs_and_get_usage() {
       "$cgroup" "$path" "$method" "$private" "$reserve"
     local write_result=$?
 
-    if [[ "$reserve" != "-n" ]]; then
+    if [[ "$reserve" != "-n" ]] && [[ "$expect_failure" != 1 ]]; then
       wait_for_hugetlb_memory_to_get_reserved "$cgroup" "$size"
     fi
   fi

takes the script from over 600 s to 64 s in a virtme-ng guest, with
all 56 cases passing (only 28 ran before), and run_vmtests.sh -t
hugetlb to 83 s.

Song, would you like to fold this into a v2, or should I send it as a
separate patch?

I found and tested this with the help of an AI coding assistant.

