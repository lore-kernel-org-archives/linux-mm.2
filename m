Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8236C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610546B008C; Thu, 30 Jul 2026 03:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1586B0093; Thu, 30 Jul 2026 03:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6916B0095; Thu, 30 Jul 2026 03:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 245C86B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:22:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D09C1208DD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:22:07 +0000 (UTC)
X-FDA: 85044599094.27.3E9BE78
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB44CA0008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:22:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N73DFTM1;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785396125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jymGRglk5IKRXFWpkqtuU5ryhW9BPX+UWnQa9G+nknE=;
	b=t0UkCOV/GarpUGl2ChoWr+XzahQ+fZbLS6bv0yWv2nQlfS2GD6eU31LqPHVxumc5JgmHKr
	XRv5Ke5A87qgJj3HTCKTSizNs2gTH1I97DEn/q5TLeNuAXBJj+uN29YnZv7670qohBkDyR
	b+AurP6LX92Zvl81ZqmUWZp3hmWnNx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785396125;
	b=LNCTV1R0HQaW2PbW/HenqjSKXxWopNn7QFwOZ86GAF7vYDMN3FuMxCAcdmXuCm9x4JjYE1
	d/aHqXxHEdIseDzk8eSeMswO/OUp+fnYb5jkx2El6zn3ZX4bEspmksUHy+gAhmwaFwJfDA
	Zdtaox1WJ93HnORn7YNQ8i2dha7p888=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N73DFTM1;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso1531512a91.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785396125; x=1786000925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jymGRglk5IKRXFWpkqtuU5ryhW9BPX+UWnQa9G+nknE=;
        b=N73DFTM109CdwIrtWRCW2PcDWcbcTFxxnRgTk9mI9sGnqGLG72PPpEGG6cyRe/hE7t
         zY8LvOdTjXw+ygWgsjlaSYf1/r6Ph4lssqqcjHKM3j6f+LldHb+TAeggGVNwpcLwiznc
         Rs+a2ZW6Ury2PKFKRVbFbAOOaIHnEEWx1ZYa9NMVXFWn3ZuWPzVdpPTFJanXaHZYNQzZ
         ZbxmT+b0DHFaW7yr1vtWpMxBqIQoCdaZb6FMov+eV1V9PVazzrcoS8IXCOQjqL4u8kam
         ZTP3opJTmN65nM6EwjlQ+ywwS+a5HVlpod1OUp/JPzIrBQ+Mj6T4/OFHwoqlMYM97adk
         oleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785396125; x=1786000925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jymGRglk5IKRXFWpkqtuU5ryhW9BPX+UWnQa9G+nknE=;
        b=UzWT/txsVSRc+4LavggJ9R7npZXqqqgWzkhRjTVCdDZfT03M8iVz5vJq+NqdlQic0w
         lXB3YPIPRn5qMHQfHjP0VtMgLJcICcsxKFu6iBFsBor9DFjZJvYOYhS/Jzu0HFsw+1UN
         YrNjTxwCWyEQnx0BidfMGaVNnghIk7SybVJFcUpBjV6Qeakmd82d7ja1UYTG4SKjhJs9
         8yLIzPykTNnc9a9FayIBv0TKzl2hwVxctYMh/QftHLTYQCDOn9RLsFxVytTE3ghzA035
         LsCmHLgNE/+kFbijEf3jdsSS4kF1Td4H1INGZ6BLk7Oo6AK+SG3vz0L+vZea7/oyoO5F
         YKCA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8ai1qcF9voXrzM1dFDkCCtiVQ21Q6yUS52PHxx9W0W4VbSCVOJTzHGhBhzLQIXtVN/Um7RsrnEA==@kvack.org
X-Gm-Message-State: AOJu0YyJF1LCcHzjcUrA3seCnW5SXfAN6kPETL8hObTzTd5SZ60BiM5n
	8DAi1b8TExHl5+2o9Tzm81XoUkW1L+jD1TWk8B6kap1BCwavRbualuIn
X-Gm-Gg: AR+sD13kJaXnX85lDxc7XX93MnzIn2T+jMAj0Ha6UdbbKjm0agNBnr121rAqF9GJjiN
	5V8/11fBigcW/DYdzToUJesZuhGNsWWu9bHHIhFMCeNhU7WBW/BjCc9T0bJWTkKDnp6/M+8xz6x
	GjHLxJeENLynX94uJ5dzcxTv4TDSSBjhISx1enHiojssMwk3WM8MFRLF6sU/YDVZkDOFongtmhX
	5kZ8vLqoUQCbe3nWwbMw7/8/c0R/aIGgU1OtF+80u8V+q2xu8u2FkX0/vXEPG+Ke3cVQlUw8jur
	UpefNpVZUjXINC4q8K+574dRuEex644trqOQvRSmdGmhvt2l9qrGeo0M2LPxmZbCWM7IGoIfFRE
	duYC9oH5R76XmWnXSmyfkXjJ4JILyM4ENbbwE6aMTU/W4d82eM2uW3DVIdKGcyusTn0otNUGgxL
	Obm2twM+STpenzULj0tNlQKfukNX67lOpGHIL86Vue3bvqEj+W6/rpwWZdq6xBAor8/qvVgm9eb
	3UfJFwRyVZgbg==
X-Received: by 2002:a17:90b:388a:b0:37e:9e9:6ffc with SMTP id 98e67ed59e1d1-38f9bea7cbemr1361270a91.25.1785396124727;
        Thu, 30 Jul 2026 00:22:04 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b960ceasm539089a91.6.2026.07.30.00.22.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 30 Jul 2026 00:22:04 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org
Subject: Re: [RFC PATCH v2 1/5] mm: mglru: avoid scanning empty generations in scan_folios()
Date: Thu, 30 Jul 2026 15:21:57 +0800
Message-ID: <20260730072157.17263-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAGsJ_4x22FfT2HkPPFaaEXck_BNbW-xmJNeyhQvpWYwYVspgVQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DB44CA0008
X-Stat-Signature: qurhyku9oha6zz8hi4fejpcoyxyzqm45
X-HE-Tag: 1785396125-438306
X-HE-Meta: U2FsdGVkX1957YnkbLGvJA/MsRPz9i7MMdHm620FLUsCJYh6Fto4HP+1OPBqTOjrfYe9NXFPtzkpZqXMVgds90wJ/WWL5Ql0jnX0IHJS+bhvmtXS6+xmtnx+s7j2ZYoHUAVRaoM1edMAoBGCXKmmihjicEUlFtpFCYpwJVT+nIc+zpRFZmSigSw/0Emc/FWaYHSQ1ijWXU2bbBR8wOfWcTZ8DZZsOBSYX2LwZ6rgov0huZeUWSWMNly5tXDHf1UtHdXrC1ELN3SIcuMeIPnt2pDnFtBSsIF8yQC6NCVVqQF6dCgBfOASm1CYP4496t1h4qNN5/12tXtI7tsfq3Z8R5p8AsNwgf3/7jyPqpqDZj8U1Y46L3HVCJeD22gLShCuIkk9Nfv063a6cAkoZOdJ38xVfmJztzfKKCOHnEjFgkpT4KrJJc2HpJj91iwJmGIiC90kDwAUOfXBZ8u/v45KfpwNHRSSOwgp/x8QvGpKDkiI1y3/ZNDo60WiYBbIgnxGCvwpSoactB9Rb0wTbkcLdbeaIdNdSN3NthtS0sxS0w3c+lERgulCBLED+v/KyyQoYLRwxbFtLlpeJhrTyMdK+owxNV7zNyWPBbCSoF6XwdOVQ8o22lnRmdCvXnZO08VYGzSG2j8MCMr1N1J/xpqVc7LTS8ggZ7/1nvZP0Q0A+vYEaut8b2E810KHv27JJQwo22PIcyuHAyaUOiXVzfngY9RaXqZRyQvhIVJVLiLLJclZJqtsJ49ffAYypLtWks87OqC4bU78B6ezaSCsBoFDKw9d1+bU1GvjfDqmZbtOLfH7Zg3tk6d1CX7Ttg6Kivn+GTOVLNZ8Af5hnDY3WZtW2glzhPft1hKoI7j2Ev7TMxzT0rh3LfjiOzRXEA/1p2W+hwfPqjSLt0k/yPy8HWyx9qMJJ5TsE2W7iPxAuAS548yPrzPMsz2uLoTY6dGcvM84CChRu6Rc8Dvu7DrYFpw
 YJXLS7jd
 0OUdQxndduNEsaPPq8cn8G71kvRehcqFnFPIpWL5KSYwd9fHlsal4NVN0KDyoqBl0yVjpuR4dyLd8r8/uB5vTsxoFwtiPLBRdK+cT6dTm4s9Sd1vS5WYGx5L3IEwB/E0YNuEcRFBupA5cqGnKoWoflHGGbkaFnJp8zpnRlQs5ynr+6rFq5zafACOZanVhYcuNDfSBNr/Nw/JTeUgNmR1dAJp3/MvLayXgwaDjkLrGMoj2qngB1uzULvCRye5mtEQ3wzp0Drw4Zx9S1p8YxzIkCF+Z9zswUb40tpV+UkVNgf9rv6Q0iPlG0k2G4YjHLJ7GnDVtyra4NH+LA9Iv2NoKL9kN5znHlgCJrYt6ld6rr21R3KXq10nyWY9WKQjjkZNnBZQeXzS6fOEoQu4JuDEpDtSl9t6yzL1X/S29NLfhO6RDx/ITVeJQXsQSo8DQytQUl60Ob2d+CD48jhEIXDlqH2hanSIdn2wnb4Qd8YwmCnlFzEBkkM9B2A44nBTUU7lzY6We
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

That makes sense. I agree that this rare corner case does not justify
the added complexity for now, so please feel free to leave it out of v3.

I'll test v3, with a particular focus on the generation-imbalance aging
behavior in 4/5, and report back with the results.

Thanks,
Lian

