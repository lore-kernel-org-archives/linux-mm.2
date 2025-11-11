Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36988CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DEC38E0015; Tue, 11 Nov 2025 04:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F308E0002; Tue, 11 Nov 2025 04:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DB78E0015; Tue, 11 Nov 2025 04:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF648E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:11:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED052140451
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:11:53 +0000 (UTC)
X-FDA: 84097758906.19.E04B01D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1295114000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:11:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="bgo/iHaZ";
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMAn9oTbF3Zv6YZXMFgD9SCNTI8yFt+ADFGBD5EQzqY=;
	b=byYPOb2mqQp3PcwA/2Drx9n4T2urkhQNvyuJ3j9MFWEFwp2UyFUrhuQkd6RfODrFzfw+kM
	vw3Po/UyLIyFfs0PuPAsFbXw6HAITUKm7OnPll4j+OXYTxnNwp+Me2RBiRHFWe4LArmwHV
	N3MhBevq4W8StUUlFjUSIltVF5LTaaw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="bgo/iHaZ";
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852312; a=rsa-sha256;
	cv=none;
	b=0MqofldvYF3jwf9vSqyHjOQmIxZpFbldb/7Z0HMpCKwzoT+4I3RYzolHKUKL43o46dcOAJ
	6XHPB4cyhVKi1PSwX9bmcUWplD6owMQIqQ2eo3T0ZhHWl0yYgZgB+13HXFYOP+U5svpL6s
	bi3nmhwefqYxAgs1mzauldrnxqyQfmA=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4edb029249aso19882821cf.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762852311; x=1763457111; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMAn9oTbF3Zv6YZXMFgD9SCNTI8yFt+ADFGBD5EQzqY=;
        b=bgo/iHaZ84/IXk2eAmHay2VFiR9/8EOsSA8thYRniaAOSOfUc+2tO2tBW8fuWGRJr5
         2+SJbDdiXYVVgkSaKu61soV0HOoCQdEGIrq3XesBNCQyD+A7BfBYmd/MKAxZotxYrk+L
         QBXq8xP6awgHC+fOuRrlJbvlR+itfg5pXhlsmkgeDyQ8/8qOUlfEIgMKbQdDS2n7d1Af
         7aczfaNRry3GbT3b0kAZQFYVqYfjq9euGENEmecDJbUXmnpYSY5+GD3/wLKy/FrYmuJV
         vB3oaMv4UTWv2cC6LnPyM/Z6F8Dof48GVgdL4Zp9VkvyGGLfjSAVaFr9KQQY6yZnUdLB
         crsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762852311; x=1763457111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMAn9oTbF3Zv6YZXMFgD9SCNTI8yFt+ADFGBD5EQzqY=;
        b=Vq6W3w9QeBqRxgEmOniOMcYn5LHrNEy3M2jzOJGUuGs+pv7Duu3iY9TQyjV38LdxOf
         SAt/ofB7GMlDurZMm1/QXSqgWx8nlI9EDCpGSlhpvY/DlzjQmhSH+9PAQRHbXLs1Z3bL
         DUjijmQ5xkY70ZzYdHnsQaTYDsckMwdWmWNMBaFrYC0RTYsqKUak2ri9L533XYISqpRM
         iitCG8k5AZap9daDL6+G5NqWH74P396qadhMWuGO9MKkN2N/68JuUOjoe/cT/Yh/9FWi
         3bX4sPrXHRurjWmScwuUPAP636Mnri+F+XJo6N5Hnl1cT0fiFgaFmBqEjX/KOVq/j746
         blOg==
X-Forwarded-Encrypted: i=1; AJvYcCXgWL0Bxr/32uUXvVNDr+ruMAKJebhhZxf2GwdiT7h6aBhxUWLs0nebWrzBzuTkAmM5kR9ryNmviA==@kvack.org
X-Gm-Message-State: AOJu0Yy91UK+VtT4vlEzqROAX5dN1pjVVFNO5la5tPDU/2hNoB8pdHUu
	9Sy0vqoZmlBqR/tPDL6LZL0KlKm9FPEwIvB+WWcrTMeoXM3JOd8cmqaR3djXGhsUxlf9PRL5Gi6
	38EQZvCLHx9GkzR5UzkFUeddcXQiQxy/xnn86gB0+
X-Gm-Gg: ASbGncsZyba+T4Gjv9rR91odRys4s+2nq6xz/TtJZ5lgRHwKFIb4xQ0Vb71bkJmF/TN
	W3LxlTMbJeL7VIPBjyRdljuvST+FmmihLSBuAhT1EvERpC8diCqM93B2XBBx7w8lO5smPHXgIuY
	7QJ5Jr4gqTSJ1vvcF9Ht7kJYUjV1gv6ZAHFRRcuTyyEgx9wh7GrekG0nZx9wwdcy/5/9Mzk4Nt9
	veGZ3Z+M3o/RksRb3MM6cDdUE4yayjOSUj7lKj2yfar5WT6Q5+TryhT1q5GuMgBNNRwveAZiXwV
	3d5QTzhsC3ES2SAX3bSZ8O4w592juy+2Q4US
X-Google-Smtp-Source: AGHT+IH+IyV5M3UDNVO30prt5PPyyx1n6sQAkg8H+r/cXESUVZ9Sxny0Upk5iwgOz2Gyh93ucwAfPrYSF2wYVT/cQJo=
X-Received: by 2002:ac8:7f84:0:b0:4d3:1b4f:dda1 with SMTP id
 d75a77b69052e-4eda4ff2f1fmr126391511cf.61.1762852310737; Tue, 11 Nov 2025
 01:11:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <f533bb094a566242ec196afbde222796c6d6c084.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <f533bb094a566242ec196afbde222796c6d6c084.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:11:14 +0100
X-Gm-Features: AWmQ_bnrR-pK5Rc9D-XEScjrYr9MOeawukkWZRpWJ1yHRGagV2Ym8rHVDa4nqXc
Message-ID: <CAG_fn=X-FB6vVtDC8WhQzF7cNePS5AtmC4W1-YfTce+5jOc+wA@mail.gmail.com>
Subject: Re: [PATCH v6 11/18] x86/kasan: KASAN raw shadow memory PTE init
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1295114000A
X-Stat-Signature: azgwxsifkcxxn7g3wqgpz8d1d393bkdd
X-Rspam-User: 
X-HE-Tag: 1762852311-824152
X-HE-Meta: U2FsdGVkX18aGH/rpFwGpNF3KcLnZLOjj38BpBazyp5QUkb+3z/LZmf7xWMYwpDdmee8/3hOvel8eWJUUvBStmrf0/na+u0XiGFs6pkxEBxkBDShqU+2bWfnMQz3FKdByGXjSkmrW16obtfIlxd8cuBcX1CS5QwDOpjKN6Cb38NlJfXxH1s9M+0uNb1yQ5k+sWnh7Dxf9vaPUWLRdxSWGh1+b0vcICgee0iI3uQQhJyjWc2dQiYDUH3wjpJROxB5vptQuAvYAA5MyY1v6/oy0VRUSV9NhjxS+lWPo1S7kj86yV+nq3l7/QzezwGpAgLnbDmYoNAP/NDEOWjIvh4Za/839UsM8P7D2r+Ku8JETdCzCQJ/n/5+0EaAupblIcIsAB0fEuN+G0JQ5eQv5CoXyC3kQRDb6nF7bS5QxW2m/3P2yuMKkpykA1kQMOsVVYsh1dHxoEPcYSmpYR3U+UJWbB9owdgAGt8sdsA2b3wmqxKPXkH2hPRpiX0KVt+a7mHvnPUYZOMhryLKvMobo23GFICSBRQecXqGww1V2MhbGsZfXJlPmz7S33iiRfv8pDEL8HAyfzkmCV54E0j7XGVRX90sn7VfxOwVHqtYYcZarBw5INhcswNnaNBUkatlwEYh03FthLvt8euLWi9glH59w83+JQsM7DmkBIT4IVJSQiRWf15BP0380VgSqqfsc7zYvwBrlFJ7V35OHqcc6bvTEUNgFqObGlB8W0+NJDJV+sobxC/JLzRpTl6Qcg0P2j7nxDDMAd8JpZ1hL+C34fu+nbTIbUelMK/tVoIEuQIeBOlpcOnPTqrSIvcXf7chD3qzK9+Cp5YrOMGHdAXBTulYleaIgyFxctY4yjRSToJPwx/Z/0QW5lb2pKryFGyos4Is/jIFa8TmL5WL7ditidAxwMKl4ogKjsEu7JFa4e8BMUYK/3p7GqKM/fyI9msrZtOJBx9OBxDZ3w+bgBzF++a
 ABf5Bfux
 mEKcXh6rb5gjO9lj1CtAR9W/uHIGi+8VbgJYC7cJO476rGajY+nXrrvD5gumADLBiJvjGuQRlS/GpRrDm/kSQIs/2dE6MJGlvcwA7W6v+4lzzDNbxF9Rl9rZyANdB50BeCF2u/d0rZ0u4zvdmnJ9kVwyfbY8rqqxjywmovWNPNUijeyTeIJOiQ3t/zLTpZ5rRBbWE7FqsYNqe0TGp2xHMHpGNutbkUJxEivy5jF/jOop6wI/koUgI9n/TeMccetQcDX/LWeMq6bRVCNh0vW+8uMDVQ48HPHyMKU8DUgLu+NEWUz0fZHsTig6cQkBMz9mRCHHYBSNuDpOe0YaWgtzP1UpJhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:07=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> In KASAN's generic mode the default value in shadow memory is zero.
> During initialization of shadow memory pages they are allocated and
> zeroed.
>
> In KASAN's tag-based mode the default tag for the arm64 architecture is
> 0xFE which corresponds to any memory that should not be accessed. On x86
> (where tags are 4-bit wide instead of 8-bit wide) that tag is 0xE so
> during the initializations all the bytes in shadow memory pages should
> be filled with it.
>
> Use memblock_alloc_try_nid_raw() instead of memblock_alloc_try_nid() to
> avoid zeroing out the memory so it can be set with the KASAN invalid
> tag.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

