Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34480C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 11:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D413C6B008C; Sat, 19 Sep 2026 07:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18976B0092; Sat, 19 Sep 2026 07:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E5F6B0093; Sat, 19 Sep 2026 07:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A75226B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:19:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC443C023E
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:19:00 +0000 (UTC)
X-FDA: 85230264840.17.2903B81
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1431B180006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:18:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lob1DCfK;
	spf=pass (imf16.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789816739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZJnRQH7738x3rysqogynlQS2Yscli2NgI3HJoxKRb0=;
	b=YHOFEMI75zyYoixu1a3z+42g7H9REO1YEbMEJaD9ypJTgMK5Jtu98x9LiWjklj1uP6hWk/
	I8QrNtOomvZ6c9JOQl2ITQaZX8ejxOa+eGQxv6JDtAp4smbfQ8perZ6gdug2xuhybTUvpY
	Fh8ZTdd9arB969YC5dLAiLaV12UirvU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lob1DCfK;
	spf=pass (imf16.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789816739;
	b=IRXjJwwGK+yCvE2hnlPSyuDVbRPHloarpmREBNuL8vmLSxps27Tf3Ca3UftFyzoPtZ4Dnj
	ntzr/w19Z5DyGxbEsKUwQ7PXuQ5IcCSE4HOll6XBlc/XzOf4uaxIQUDdMaVSEoewXOa7MW
	mnMvCZgnRnYYGZJ5mQLzRAdTLDy2iUQ=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccda24a3so1260748a91.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789816738; x=1790421538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xZJnRQH7738x3rysqogynlQS2Yscli2NgI3HJoxKRb0=;
        b=Lob1DCfKR6aIO3N8XCPQyfg4PzzudTPeb/xQkqRaydSS3S0npM4jmUNUa6Ss3QH/7a
         HgVi98QKhyegut2TgZ3twPzDOsw3qcQEeisEFz33dyZYY3ZEp/1UoEyR9w6uYzOFvtDe
         DSY6vObL7bnZz08TFLZhn7HdcYQ7C5V+9bxAfGhtfh672OG0cVtQgO0/PO+fXw93UkpP
         qcV1c7Lln4KG/pAE7jKKAmm/hKgn+nxR31EcEY2bgk3rDr5dr+QzvQPFk1QMawpwJG5q
         yBq83DlGCFyqfUt1scCak7Sgh3U+/0QXxE8MUrgTdeUDoTEpgwb0F/KMwnSpaKWBbIL1
         RzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789816738; x=1790421538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZJnRQH7738x3rysqogynlQS2Yscli2NgI3HJoxKRb0=;
        b=ocW4jzkT/Rujy+Asw3Vzs60YLJiu7+cjfl0ogFl33HOGfHe0IrxEVum5Yk8CJVdjee
         FfZ9CFo2N1YQ6iuDoIGf3XyKGGtUkQcpKns0K8qRLOtTri5jnX1+3Q07S7DfWrgoiofo
         hPH4WokaKVU7SXIWf+PeAETAzLPtzhnTwRAP35JXD3lF7HFJkQys03DkpydaIFmzxbCR
         o/17gcAK4vfRNB/s74wcntX2dpO35+aYFdTj6vh44B3i3Fs+iLH9XtwLuUimqRQVWNIY
         zadJUmEvX0bCYPES8j0PwocpswcURcdnGcMl13MOHThhwO1DTP8mKhOCtZEr27LI5paX
         BvVQ==
X-Forwarded-Encrypted: i=1; AKwUvBzsfIxQOah/p250OmRyHICGYy9xRk9iUkJWJCy1nlgdS1ta2uEXb1DzxYURHpAzjCjIF0aGhnCLqQ==@kvack.org
X-Gm-Message-State: AFuF++lmDqkmnCrLLUuwW3tYL7C6MPLn3uV5wYCEwclI4TTAPqkQ5ZFU
	OZG0aTGoKHtUMHzeZldsHeE9hCA1RW5ZlPpmyHGY/6kgZ6QmXmdzUA2aOC4ajeWG
X-Gm-Gg: AYBFou2JDFQHAwDK87BpdSW8TjcimzC+Oo8B5/tCh6H3kQBQWESHb1r8k8TljFJYQ71
	HOoWmMJ0yeW5c86lEAbQ0NLYQEDRyzsNypL7djnRQHday5O3aRjnHV2M44vaEuxsfIg6HX9L/u5
	z8r3vPV35F33eJTJ0mfiTK2kPPqTsHoPLuxRBTPNP/Rs0GTpOLxY6o2Gysedv/z87E1RHmX6h5E
	6exTU33YRLemY9Rmko0VsToker/oGODMpCJGuHQwz5EaSOEArU4mmgSzNuZJLrD2ye4Kp/4/0Ub
	+tZoz1rn3g9+lkxivXtgQi7zDX6DACDBd3yGM0iKGgBHN5VYnn3LGaa51qRG2bGgEtv/6lHNxsl
	sgre27UFMnKrVyuReu6RTK8t1V6xXbHAyaytgGm1mvM5kns1FVvkKEeUBJgwRsNL5yyKZaemDCM
	EOh5aG4cQxoJ9lQNqBN9o9nJGfiP7g7WnZBH9OR8kW+bkq/gYcxnJjv3wUkvzLuu4PHO8iviL29
	mjVnn/Ruz1aPGJJtVuLV+KfDdm067AqMryTpu6skYa8V6WTrHMRHDsBwQyPS6vr/I9Hl3J1Z172
	mmAMZ2ItVLbCu8aOImC6EfrOoQ==
X-Received: by 2002:a17:90b:4fcf:b0:39e:6c68:1550 with SMTP id 98e67ed59e1d1-39e6c6832d7mr4987578a91.24.1789816738012;
        Sat, 19 Sep 2026 04:18:58 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02738654csm2153372a91.3.2026.09.19.04.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 04:18:57 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 19:18:51 +0800
Message-ID: <20260919111851.678-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <0c0c19d0-997a-4c8d-a103-2b3d153f4e32@kernel.org>
References: <0c0c19d0-997a-4c8d-a103-2b3d153f4e32@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1431B180006
X-Stat-Signature: 3der8mj4j8sram7qdqfkd6yo7zustr68
X-Rspam-User: 
X-HE-Tag: 1789816738-359903
X-HE-Meta: U2FsdGVkX19B6LMa8WZUKHR6qcp8AwOW9DVeX5nLPBL2IPSZ1RucTlCXuqGfJKOlHZPQld3l7S8KHq4Iy8e16z5am5C+xnlXcoU+kDsY4wORdOyEs2M1Lx0xUFXXxeu0f3mid94BwbJS/6m5yVljFM8C7bHzhuC/o182Myf4kNeVFnkKla/0YrCAeSnrL+VMQStwvR1c5ewuGybLYwR/7rpJcCAJMnpeb5a+aEbY3/as/LKCdQengh3jAdTkMxEfWhfh/9TwRkxRsnZiJ9erZhC4YhEOWxq7aDo83O0ExrxPkOKyYD+gY4BNNJFmUH+PwwI/M2Fo4pDJGrPymX2+GThdn2U7Q2xPXKiwtGFuO+7LwOIAKJJvvXJ7dasVlg8Po+XGc6e+CZefPYy7N100o6znlsW52o1MgvCg8TzfOrWD6pdu6AeNVoMFWF1SZZazdgOVt9p5Z+K4G6N4TgKh692XxU8O9R/BdFq1nXHlDYUfZvZ4RRKKOwJoLxXdkAGMjiLM2tNoN2yrNeWvl8y/KVp5nUMnH2GhdTw+8cNkyiFxI6BNxKQnk6v82IgRnY8ehnTY16lSgiWB6YDNmGB9/DN11d9aY8D1WMJShYduebRY7wpjuxo0rntOGOc3ts5f51jatc+4npUCQgh4Fjh1yGnOzxDpgykqxjFGoFysyUKkHst3QU7gwfa4etmAYSVooHFUVJi1qzoea4RrsRyAK4N74t/B5JVLV9Urxm108mnWwfrfQxpyuphww5rF8jzvqsaHKiSNbglDO2EfDRPj7y2Uq/d7/4vLxk13NDlsxJDn1blIf3V97zHB+hKqFQ4SHbIMzYYOBXE+/RRpyKcCRuFm87mnu+kXh/xsr5T6pt3W2O0IMpjtHEV6GlIn+IYI6Yf/wbDaTFt1xmKb/UuaysugjUz6mwNa0P9gKJuhueh6QPzNUX3yVr37uVoVZFH23mjHaRRwdeLNz1OWDKb
 W2zioL85
 RQJWz4Cd1HRWmI/zDGgW6wbt6EQN/Wb8MansMwvy/vdU/v2qQrqgE7eME+gB6JPyb+/sOueBVCgWEPqxfjeVrHbhIf3KqHHU3PhtAig3i3nQvDuhMupemYNLa6/DYrQ984EWf4yU38ItYNVYa8TiMpJe0ZOeYTk3qZaSlMM5u9Jma5W/8ZpzmjMTAzzknYkXGytvIEGz500rtyB19hSKexpQ11ePyLajeeJd5sf8dcOMFxFU9h70XHjNKAQ6+hKvGtJNOS+BBzpbPDzVqINXSs/kyLbX2qB0ucKVqoTPMq4O2TLc6NuKF+pMiB4yDvePeypffFCZoi5jmEua2jmfGfwdom/73xSe6EfuneForfECClNkgzgp3qP2xxGVWbH4rFnkY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 12:10:56 +0200, David Hildenbrand (Arm) wrote:
> Are you measuring the worst-case latency of a single write fault or only the
> average over all writes?

The single fault.  Each store is timed by itself (clock_gettime()
before and after), and the latency numbers come from a pattern where
every store takes one of these faults (one store per folio), so there
is nothing else in the average.  The tables show the median of those
faults; I also have p99 and max (i7-12700KF, in a VM, us):

                     v7.3-rc3+              patched
                     p50   p99   max        p50        p99        max
  64K, 1 fault      0.42  0.57  25-26      0.71-0.74  0.96-1.10  28-60
  2M, 1 fault       0.50  0.67  0.7-1.2    10.0-10.2  12.2-15.8  13-22

max is the slowest store of a run, median over 15 runs.  The 25 us on
the base kernel are interrupts; the VM has those on both sides.  The
2M row is the worst case by construction, every one of those faults
walks all 512 PTEs.

