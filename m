Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C8EC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5244F6B0088; Sun, 30 Aug 2026 03:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D50B6B008A; Sun, 30 Aug 2026 03:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4F56B008C; Sun, 30 Aug 2026 03:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC276B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:02:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F9E640259
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:02:35 +0000 (UTC)
X-FDA: 85157042670.27.B9A392C
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6818B40004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:02:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBnXHfQ4;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788073353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYkJEKp+0xkpp63D2jQrcQVdFNMc/UVNBuo1GXnZ9xo=;
	b=8QLh3Etp+xH2mebtNr+l9mMH4sQz1ip4CCHiYRKWTYxy7heXPBFcNFFZgAOV5LCG78X0U+
	ynwMkLNdOPeQeBPXYnzo51darpY5lJE5+xU4up893/Oe0rR3wQLpzq1s64wdFmB7kkbAef
	q1snHjIiobWL4IUHC8+TUJ1hqflUN38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788073353;
	b=mO0vS7N1zWCCy6NM58ohvMn+usTd0waCDXBsSH0JxOqVWD6xy3ocxblz6vTHlo6+BH/wpA
	Wahgkc4uHGKcG9vdv45ZWUAp85SLuCHxsR7aHw2SE3HxcqVCQEgjIQ26J5Jx+O0atJ86X+
	YAHFDFCDBf4+Sc49Pk9NeyIpZ9mvTYI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBnXHfQ4;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso26167195ad.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788073352; x=1788678152; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JYkJEKp+0xkpp63D2jQrcQVdFNMc/UVNBuo1GXnZ9xo=;
        b=EBnXHfQ41zHIKi3hRHTHdpzYOje2ADXr53zAkYEqUYoIDyZGeLXoxx6GN3GH68jjjO
         aNrx4UGENgQhdEpZgxi4hGRFyShe217a5tFkEn/9viFzEiYynQOAbEozs5CQcBMTFAks
         QhR2KI5+ogLCqF/T3QPWRwMR+kDBzyVNIZ9dBpSGcYC2pR5SjrIpsBF4Ka9pXMSzarqb
         s/9zpwPXaxwGFNdFh6oQmko6smYgMRaIbjX5iZu72stpW2Hv3mBI+fel9e2GIG/lmg1M
         yDlWRJXTkDQlPg48OYCtHIlbpdxR28VO+mdocJamAKsWfB+eRr2AiRdVvr+T3HElAmGB
         klGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788073352; x=1788678152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JYkJEKp+0xkpp63D2jQrcQVdFNMc/UVNBuo1GXnZ9xo=;
        b=I4kyC/TojOXqMUiC4JyPSBgu0eU1oB5Z177pqEKqqcI7kbpYsArsk4EbUtTqfmpZIa
         xo5GFbt7X9/gSOjmzUru4AAbBJT6wNVkRa6aadrxtjaT5qusxa6lCds/BS85HusZgakF
         d8LkleGHZhK+lUw/Q998YlFdD1NwF01UzzsgQdEFNOvf9+eSJMFdp1UM5dLZ7x3ImBZ5
         erqvsWdOoWbUnElHve4KMZfwJ8+niCZ9zj/C1O7W5VnG4bSeJXXn+QRBgYaOadOYIhMD
         qegsfOB4pn8oEd05lsdaBmjw/TbUQfozkG+v5WeLFTGBxUL/Orhb5jniPmDjIb/nc8cH
         fEVA==
X-Forwarded-Encrypted: i=1; AKwUvBzijv/8gl3Jaj62k39CwX41Taxc//9QJGsqnB0rdEoBZN08CjXFe05FmXWN8OOUvB513cwlTUggcg==@kvack.org
X-Gm-Message-State: AFuF++n1riH9d69anOyCudEeUhbz0CYrGgKBvL137d1M9nePniXqYifj
	rUm7i0qiXKBT14h147TQTmGMMnqyQxUQwPEJEsymQJaX8d0YSdTDCWpM
X-Gm-Gg: AYBFou3HxrkZfLBM7vt5UU1ObGTgmvGaAcPnMXwYzqysW4YlqgN3BtI8QmIR31eLyDL
	bHP/ADCxtPsnm+DlFG9bTa0tPitsibWTa05DvJvv0i6fY9eOiybQmRDZmmounYGVuROIVjrF95X
	nyHrwnqDSZ9sIEXb5zlAgGcadODFSUzpDEQDTgdJjcTpjyxct3eCQgQ0HVfLfJh/uRb+K8TVWFL
	X5nzU6r/ee4z6IVrbcIDZjuKOfJM27qXlgMItTAUxFPlOpTJESIjC1Z0Qq6+UPmOy/ydoybdxOv
	N1Uq6ZGWhY9M3JNuNPd8MdpUEi9A3fZLwQ3n6aYrL4wJKGWEGbDlD0Okc0beE2iKGOqdcm66tR8
	pmd5KSMYepcw6oyKVjB3DkQkGAMB1bCRVRmzvHb9MKER2YtDFRO1P0s6FYFxfb9raVWohryqRBf
	gPWSGf/2pIx3kIh6ZVGQ4khhukAp6SEHP6PV7ftjREaEoZQyxZHCZcWC08dBa7yag47T/ZOw6q1
	7HhbQz1gFaF0fwmi1GxIdx1mFX+Hw==
X-Received: by 2002:a17:902:ce88:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2d74dca2281mr283760995ad.2.1788073352062;
        Sun, 30 Aug 2026 00:02:32 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598c3da2sm20434765ad.82.2026.08.30.00.02.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:02:31 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Sun, 30 Aug 2026 15:01:53 +0800
Message-ID: <20260830070211.77958-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-3-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-3-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kcfihgch81tzqk5ohzq7544199h9qiq9
X-Rspamd-Queue-Id: 6818B40004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788073353-573177
X-HE-Meta: U2FsdGVkX1+3lDLyyJp2tyu/MzG4AWgnCn6ZjmBwpcqYTTlQnSeD+rq8Gb/s4HgL/3waezv/xAt4j7dhyVmbjAeOhwrZsRqJ+RLeOC02jwYEvPH5PsLHnC3uHICcqTdZ2xpio31wgWwiP5fha2ZVQf56zozwlAk/rXpORm8QUY36b6h4QrbqOfqm2tDUL3NGXEgx1bp+2JA+8plUTVRWDP7ZANpAWfHCHLSFOVL6JKFWyqfOpTMY8Ru2Q/9nlb9Q5tEVo1RGQsmyfiLCqSfgmj7cxfvlDnlFN8YTTlRsSwzra46OTcnhxCgJEee+rpFFhHw7Wd8sKXZpyU+zGFUcsAV09O3lsAh2birSoZYjcj33sTfx6MwaMOFHdoQesL9UlBBvUm9yzP2cOAkfp+SpkflXkyVzhx3IoQyyMD7/1YXa6jVBCuAuDKsD2vARlzHSnBZ0Ao8UaXzewhx7PvH0gyEnKFGymnbsi8lDkKPkH9fbE0eM3rfjHYcoPsZjsI72YJBbsyqGJ8mKJ1zQMslIRNBGcQUjY7uT8zh0mPJf7Nii2vyEvXyccDh82sne4HNBILN4w48Asd8tyUD1O/7xDLV9pgS4Vdzxm87XG3JJ/bkZFMQpMEcOZ0BkPwPRfoFEo9u7FCjCUbmnSJQlMADkcMy+SrDvUEiRtaXNLsDob0APdkAWJACdmsaVTOwXInP3L83NNJ7D/QCPliDwxZDAAzz18kkuiX28pS06zqUrCsbIA8FUF2T3WCApw7zBhwRA2tXxGVT8pvhrN7P+TuqNech4PZ2DFXrF+5HWAU1RtBNFFP5USlth/H0Qszrpxy/r/iz/yyIfrCcr+hqK3EyRi1FFPtgdTQgrWXnFipYg57oAD0lwOWSIiBmXeEXpx5NP8XEGVYohStWD+qLe+3W/clgpJuaDQjXXbYdMHLVVtYvWpOLEMEcd5H58QOEh2lqZ9aLZGwJBOgosLAaL0zt
 cIzDkWiw
 IILuSu/F2WLX1HtgJHO39G5iy1WqSUSPinBPGHwCbs5W2BkFhburTzox8sevSMzKw0qmQYOUoCVHqommfPD5dr2FlnWdVe3GwVNmswKRNc50kZdhQapQWv5ZIS7Xo3dpiaM0MltdGfbhXcQXQAVQrrULtlaatc3IDgAQTWizORXD6wTpVVVjGX0MASoo+/YWca8Sa4GWYNzGybpGseAZNf64rnZ1r3SxpkZlh6cJSiN4El1RqIesZ4pvvqEc818QVHCsOc1IWQIfBSzhqE0iS2hVSVCrdayJZAIEqdD8DqO/inLSMtdGuMcanatFGooEfYjHQfatP/YqlHMcw1WfLiha0f+NdV6N75JZyTDxV2kvUTLfvSYqyoAFzC5uRKm2f/5ncKkbR63TbBep4EEGecF6d8S1EStXJUU1DdR/kw2qOn3IlDTUjorrYT9fVI9nOG/+Axf4nV9UFOfdysxIxzzS6WeLlEVzCsfiPtBdbLSkSpO96s+LAETHs/sajOPBQWykNQ7DpJ5QVdGjvdw2etKIfva87YlYXHDEdPMmBOU5N/kpWleXY/R1TSkeqBcF8nvL/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Instead, accumulate the size changes and update lrugen->nr_pages in a
> batch after scanning the entire oldest generation, or when the scan
> stops because remaining reaches zero.

I have reviewed this patch and the related discussion. The accounting logic
and the break-to-flush control flow make sense to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

