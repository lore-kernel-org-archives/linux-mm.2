Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DBFDCA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 17:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B15B6B0092; Sat,  3 Oct 2026 13:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462E36B0093; Sat,  3 Oct 2026 13:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377C86B0095; Sat,  3 Oct 2026 13:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8686B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 13:02:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 942321C3DCE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:02:34 +0000 (UTC)
X-FDA: 85281933828.16.61EFECD
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6E0A81C0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:02:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=oDxinKuH;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf18.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791046952;
	b=j87nvKNP0D2Zua/KcwRz4krox8lKlqpdci4hIX/T/ywvKCdVM7VaMm8PrBKA8o2Sbx3yXP
	HWsI4azBWLLwENZju1mQyLxbGJmVuy5otJUgS2IftFPxOnX26qQUMPpdIypP6/Ah5F384+
	3/i6NXiSw/EjaJ7wX7z9EymC4F6GtY8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=oDxinKuH;
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf18.hostedemail.com: domain of chris.bainbridge@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=chris.bainbridge@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791046952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kLoV5W1FHSMCnQXJR94hBtpM1Iv97CLc5Gk+9EMFE3c=;
	b=6k4sZ6p//vs+toTi2szWbpia5n59P7cZm/EQfvKeyh2/GBeopiijT8CQIl47mBCFoyp2oz
	2wPAyFS5rzhA4COT29MtiGLRGtk+I3wX5Edx4xrQTR26L0Cse0lZowt6YfPjKY9PDTTAaM
	hORWlThO+vU+Q1CSsRvZBdFAbPMd5YI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 80F493F193
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1791046950;
	bh=kLoV5W1FHSMCnQXJR94hBtpM1Iv97CLc5Gk+9EMFE3c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type;
	b=oDxinKuHjSwh31QA9ULq54Z0Ka3ICwf6Mm+tdVnkM2VCtxgbrTphDAaxTtj3bHKvh
	 78EgtWchmjblnTJmdW79O/x1M9TQ3JIbaHQH0vWmn4/rs8QPf19aJqM0y9HWHeLCFG
	 FCxDNLRmZFMyy+WcJMGl5Ex528DbAArYEXbX3TTAp3GuTRH6jQq6zlPomY8wFBKo7/
	 m4YNaGXO93hcs2fw4DtuZLeuPeCbAsYYUjAc/ILCXgnb+kGlkBOluIna7w2H+I3rEp
	 QVWSEhhGFiXJlsUZtU3ot3pjM0eWFL6rsAS6/vbSbqYTbXVwUhBtpBqdh+tCO8VYTM
	 ciIqkrOECxtRbx2ylA9aQfiM24gdlrdjS9YkmVOAO7h1GwHTPEssGD1TLBCTL7OVJR
	 YO9R1Fm08M3lNhY78i/ajFG3yAv+q7OyG1222rlbJ9XBa8I7LnSgZyWsf6KlHeAZVX
	 MiL5VN7es0oakI1vvnA3RKdzjCjC/Q7VS96sAMqomj6RUzs+SCWUYT1gbmr3cQj/Rp
	 OpgmeZOeIThCglW9H9qOTtacdLCct0I1HwkSFwB3e05sJ8EG0j3pq6LpKQRMGJwC5W
	 5oRfiii9TvMy47pN5PsZqMLXpOIGnQFRJyVdMlBdVsUSKqnQ5uIL2o+kC/slooAlKF
	 Qa/d0vr/A+83MXyjwjwRYyrM=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a01ba12198so6656905e9.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 10:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791046950; x=1791651750;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLoV5W1FHSMCnQXJR94hBtpM1Iv97CLc5Gk+9EMFE3c=;
        b=jVEAS+XSx8u3XI8hKIN0IWkh32JhuaUgzw5SeUe3q94fqre5kzzFef12/GdogpIs0y
         +qmVfwIlnkEioSJ6D+rOgI+V3bp1S/zRf5sNq898CmdmwmKHB3bQqUCOVzilWirNXgr8
         AXzeqZ4OWB036FTEmmYSrLSM9TjwyybD7wU8gdvpACSzJSR/XDFEOCU7m920QGVGQapW
         IMS9he9cION8POmQvaTvWAofwFjFOqrL9uuWZZL1EfBzHN5LTXWSwzTmaHT2GBxbgHkU
         2U9+ccHxpTRKBUHPNolzLBDFE4WW+6hGuV3Ak0zQ9xNsXjcg+AkzUkV7EMKOUpU3Y8j7
         q2Qw==
X-Forwarded-Encrypted: i=1; AKwUvBxBKC4xNU4bZa/+Lq0hi2ehiT6YM43vFbg3HMexdv++ElGm/JbDegjSGDnuyxpyv5gGoitgcHZkQg==@kvack.org
X-Gm-Message-State: AFuF++ktuDwrYwyBHOvMRSrry30vOOoYQPwgKzsa5I57PMALSvcuT5Pi
	X1KV/q86IHcHZ1POTp+B/lurDlgO3h6s8NKIvvyFEF0qFAsDgw0Gdj5rIZ+AzrAGFuOB+fC69RP
	EXP3Gwo2g6JUfFj9BB3hYE/puXD6C1hM6KgAjg3lFWUrDl3kRaOe3ZE7AT4FysjfrD6ZF
X-Gm-Gg: AYBFou3EXwKztdQFGF/nJiZ/6uK09DA8Xjj+iGnt+vY4ZBMa6+M6g+rLeigxikR5bsZ
	bQ07/hEWx8sIYh4NTmLFhTdOo5JUEvMBuaV1MYovS356M/QPjdR4Ar/lRGJdp18yxIlOsXyU7iY
	XLfcb1bn9drq3egueipsb2AoP0tXfCLrBoDNz8PS7Rl79dwptbg2EuglxRyY4IzQUtXdaeYNLPy
	OwXS3JewqqudgHzt38RRIABCdEs1TU79wiIaQI4DlmyDmo8KHf8OdcmhnBD/EQwOmFREhrGHh1b
	w5ceVcc/ReHEP1VLuzVMA15m2fTYyMDI2mMALjpVYKiay+4uJBq6PF9ZHreZWZppiIBO9uxvc0U
	AVFvNWfk=
X-Received: by 2002:a05:600c:3e19:b0:49b:8f5e:51fb with SMTP id 5b1f17b1804b1-4a027534b98mr106170585e9.3.1791046950097;
        Sat, 03 Oct 2026 10:02:30 -0700 (PDT)
X-Received: by 2002:a05:600c:3e19:b0:49b:8f5e:51fb with SMTP id 5b1f17b1804b1-4a027534b98mr106170055e9.3.1791046949625;
        Sat, 03 Oct 2026 10:02:29 -0700 (PDT)
Received: from px13 ([2a06:5902:822:4600:184c:5422:d333:cf3f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a02752aeb3sm192763715e9.0.2026.10.03.10.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 10:02:29 -0700 (PDT)
Date: Sat, 3 Oct 2026 18:02:27 +0100
From: Chris Bainbridge <chris.bainbridge@canonical.com>
To: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Miu <jasonmiu@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Subject: [BUG] KHO handover hangs when memmap reserves PMEM
Message-ID: <asE0R_f2r2TL-3Sy@px13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Stat-Signature: druo3yqgcz3hzq64dsafsi8rhjztfiia
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E0A81C0009
X-HE-Tag: 1791046952-811906
X-HE-Meta: U2FsdGVkX1+rWzP9nqZRbkzeo1g1GK2csRrU06YGqLD0Zi6qdpqp6X1hdcYFTclNUVD53hUyAgEJLl2Id7fQaoies46ha4isqutIy1vKtFCVvwLY9YtkRicionlwdw9nJoDgMLNxMX6rutWGHmHUP4mitF0ya1KaLhkr3eE4emIJgt6bHM2SPtbpp9tRvrWyJv16f8jQ2Vs7QUGpitf9FioRwqL735+hMIwxYFfa1NobH32Es8o955LCWNUUIu4LZakzyNJX+w+hraGFRpUHqSwDhaE9bGkj5bUU9cS0ueUfE7Y0l2v1pcqZV75PF/hDRBziY1FXBgdK9J13K9mj/VKj93Unq18ppfOyYfkrONRUIgLJ/oO+qJNlPPKR58xsEIY7urKP+O2Y87P0CNGdbM4YtkawPKfBvULA/hHcqDLUT+2id729akkjUphJpp1zhVMg+5lMiZ/N5DibhrZmZbHh5cc2L7EOglmlrqVi4jG+/hdTWQ/PtKtKBkqNq1ZAUXjsr126sXLru8LCFNT5ecfPNYQ+dOMDOaNF23XZH/pYVms0X8rHWhgUZ1SeOoWfEm+vriKR+22l8VWTkK7ctjF9uMQjwbh18krtkQE4Dt0i0cawa2r2lT0M/d8cB7V/c31WDTaV2NPu7plTaVZYSBnOkSkOBEpC99Ue1E4QUJtQGttXmkClGptW8ZgaqhrX4W68wxZMllmKWaF4+PhR05jb3HLJExT4y9Rb25tzczX2RRVv6ISyli7Dl0XhHszI/rtUXLinBUJ7FOamXSzoYHp1vDlbYHAPa8xJz1HPavBlR60G3JRoWYxUXSgo646THkcuRgJznRjVSATtjsIhRLS5d0qG1PaCPJsvnlcehxXDpdgiN/05EGa7WPhMNfZhtDa/WQeEuQDK9HC0ag6BHSuStSMahkbHnvvWzC49LXR6rAUyotZ47lFkD/7fzx2NnFseQpI1MNvXx8xA4o0
 tKftKgbs
 pyGdD9fNKSSCLX3brl5VxHy5165Fm5rHCdxm9W/+t51XIxKRS4p+oQ7gy6hZ4M3tBzuM5qF1SoocVxWIqLah5QtTES1tQPZIyoQQjYZCzCr+46mDe2/PhLNEmvyqO1VqbPoJYkz5Io3Hsbx+XWUJyTb5uBaH3Semdp1ZF+RhKrDc6p/gL8SpwAKltHlzDBtejKI/72CLmIKj1eU8fFC30cDFAFlgigEGfYXvqgWGgi1dPmfThlE+a2kUkeeTs9pdUCNB77kT1HofF8Cb0sVKMBUURlD3Ln+swuFcusCVQ0vKOyLMJA3al76eQpX2qJbB9UuEhU9AI5Tbc41nMM5cqM+VbSS0tlbWzJIGf5WqQn4q8NWYSLo1tUsI/mxyLDSKQy3oKStN0nYIt2mU7MItadHAFsUoED8HSFoJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I am reporting a regression in KHO handover.

In the most recent Ubuntu 26.10 beta mini-ISO releases (2026-09-18 onwards),
the first kernel reserves RAM for the downloaded ISO with a memmap directive
such as memmap=<size>!4G, then kexecs a second kernel. On affected kernels, the
first kernel reaches "kexec_core: Starting new kernel", but the second kernel
produces no further output and QEMU spins at 100% CPU. On unaffected kernels,
the second kernel starts and finds /dev/pmem0 with the expected "Persistent
Memory (legacy)" range in /proc/iomem.

A source bisect identified 3f2ad90060f6 ("kho: adopt radix tree for preserved
memory tracking") as the first bad commit; reverting it at the bisected
revision restored the handover. The regression appears related to KHO metadata
being accessed after the receiving kernel's memmap directive changes how the
metadata's physical range is mapped.

#regzbot introduced: 3f2ad90060f6

I have an AI-generated candidate fix that changes 22 files. I have not attached
or published it: although the AI did extensive verification on both x64 and
arm64, I cannot review or explain the complete change, so I am not submitting
it as a fix. If one of you thinks an unreviewed candidate would be useful for
further analysis, please let me know.

