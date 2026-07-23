Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157BCC531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D286B009E; Thu, 23 Jul 2026 11:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04756B009F; Thu, 23 Jul 2026 11:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCC26B00A2; Thu, 23 Jul 2026 11:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 917D46B009E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:16:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1491DC0551
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:16:12 +0000 (UTC)
X-FDA: 85020392184.20.A8330C9
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 40274180004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:16:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lyZnXOp3;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7dX3fQLU+MQfWobvf+BU2EOiXlvtWcP5jxjjttRSJQ=;
	b=rX/DQzjk6l9aq0rFrKVu6wLcS/8V9XPhnTCuYpp+dipqIJ1AJ/ioWL8Hfg5M4INzoMNvm6
	r3Sq2ggMMJ9OfGMg+no3Adec+YRZZ3NIUi8Em0cq8KV9TZ4HK6nVai5PepSze80hUgyL3u
	jzT6lH8nPRjXmZLlL/SF5j1OQS3u8uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819770;
	b=G/BrvRF9j8MAOCMTTha9C+rpkDjOGXfPNvJVy/hvejxr3wB4ayh9mc10b71/v6uUn0hEkd
	GWZB9r4fKII4HMoktcwb0itKK6ooVoQYy2LHEamwc8vgP0nLvmRmGMX11JdjlIiGPCfyFE
	K353NAb29J1Rv3T+YhyOutHzNqDzu5E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lyZnXOp3;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cecc8a3dbfso1367955ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784819769; x=1785424569; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q7dX3fQLU+MQfWobvf+BU2EOiXlvtWcP5jxjjttRSJQ=;
        b=lyZnXOp33/THTZtvzHqi6JBAqnEFHROJWO66Q/8J41q5BIRXMK/E+AtYtQMIX/HS3I
         BdD2YvaO+uuPtaGA5mVfcdvJVPp2EXfvwpsQa3hbk1Wiufkf58ydxnAtMvMoYMZ7fpPS
         7Z5D6+Vb3hNWSJ2yZ+c0B08bI2192yjHOHZfWt96QAYcVixhkZLMhK6k4XFWsZ/fb8kr
         psgZzlxSFeSYbFOLbJIOLTF/pKxaHD+JAhOo3ny8b5nlpo7xFzIUcxlOwtU9ts2igOhN
         eHl+zEfmyf5av506wVBs+Euzt/QMshi8chKhNxD4Eax9LD79hjDzdBnRBKlZCiPUfwdH
         YGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819769; x=1785424569;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7dX3fQLU+MQfWobvf+BU2EOiXlvtWcP5jxjjttRSJQ=;
        b=WYkHLGxz4mtfhAn2q6CrvaH0nh89XZ8iXwq1KyJy8I7SLW6Eo+tTV7+izPnlUPc04s
         xu1/FyQUjS0px5Z0PCXD+YJ2slELspQfMfNqqHuxNRT8SNVn4TalS8GlDvuedT63pQ88
         r55C5yS5vfAUlpZ6smVtzo8aWeKNPeffete89y59+tj+hpYbvP6kIXFolLel+Tiktj/t
         IvXSiRUoOGw5lztC2bgCfGtTYEnqxzUhmBqPEhQrv5MxVXQh2RscBw1WLepMFOS87dTC
         z56WHCz2D05SMtNfxe0Bi8JtF5DDIuJMZr31XrG1IWiipTSK2SJ2DjDzYCVBgSvJx9eG
         Fwlw==
X-Forwarded-Encrypted: i=1; AHgh+RoQHdEMPH+7zLe0avTPfh1poxiKAb1JVK9Sp7use2ZACR00EXH/mTtMET+5Ayg22uqn67N+F6BOjg==@kvack.org
X-Gm-Message-State: AOJu0YzZ2pTD2nK9e61JL1OXo76kZIdE9/+SCm58HN4u0ZT09H7pOkIc
	4amEp2qmbZLW6xGMBeEQ0SYltYQESN73Z3gpMKBAlVpS442ReFN+V6kx
X-Gm-Gg: AR+sD10fAZvoKdWV8bPOL1Ii9WDcbMrEpjHNISqtMo9Fpm15X8fr5631WQ0IFqLAxuC
	uXPAXpAwVwk3Tc7gvJ9v28Shhosuasljq6QxhOcki3uCWKrIflDCrO3gLOD+xFkg2YbF/QL9vH1
	1KRKyOZoYIrs0FT/Qb2UjRS/FjaFUFoKWzkL+G73wpdZmnOpspY0tZk1ygAEkau5XVSgEIDa+EW
	2emBflepFSbF2d5hukwYeHB8MOe55UXkfUKmwuRtWrUBPoxnVNjEdGYFljA6vunP4Gd0IdQyIuk
	taezNZQyH6V5epx/VO7CYY+6niQfocZKKXg0YxySnKP1tcPtplh6JQrg3CrvnODJRzp6vhLdMT4
	yIWQNhuvnTrFJ+15e7sFiwQlP2AqZyTk6v/Nc3jJA2cAlJiMQz97HbHreFEVBG/LfdVTMxFG1pJ
	Hhk4UcGx90W3cDpi0gQiUXNoeCkI/NnhSwKfzQaOW9vew64NtIJEddzwcIodo2ODZ3ZpyUfMvH1
	jeFWya502Ui/l8=
X-Received: by 2002:a17:903:1a84:b0:2cc:d6de:d58e with SMTP id d9443c01a7336-2cfbd0a553amr478115ad.4.1784819768864;
        Thu, 23 Jul 2026 08:16:08 -0700 (PDT)
Received: from debian.lan ([155.117.85.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f312763sm35276065ad.61.2026.07.23.08.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:16:08 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: youngjun.park@lge.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 23 Jul 2026 23:15:47 +0800
Message-ID: <20260723151547.377588-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
References: <al+alXxG/8XRCM3y@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40274180004
X-Stat-Signature: g4m5g95tm6ei8nh75mwfobfj8iykbdoi
X-HE-Tag: 1784819770-640223
X-HE-Meta: U2FsdGVkX1+U+12vyZJAPkax05NTDfB1YE50QkGKtp7ndIKe97QNegCOPHsBA75scTHoVD51pW8YgkJ1ZG1Hjg0r8K9k2Li8LgJSTddCVvSG95xMfjz/2/qOGStNcO/e42lkD2F36PGMKZZpZmQIW1loqtBLpJeRIj2BEE8pik88L3bG8Xjoi/3LDRAZaD8W2walKT7vBoyHQiFMRK3qe2OoUMYFDRoj1F7mGeapy/X+8eNoKWdzDhmqfd5P+sKSezBexlkbOQdJ/wBiCebAWeaEg9LW1qkawZuHX/IW3XJ0yX64RnkmGEXC/ZJgISPzsrJx1oyIuBiuzgk4+rLWTPavfGYTuy+Ufthc+srE+8C2XyFKArajbGZOSF8x16IiBONuPoABr3HDoFcgbszgStAkyfQKy9Oj686QY1cu4mgAcT6AMaYJiA9S+p7Sq08GJyWU/M/0frO9rBXHgZQblODYGma33V7kLaiVOZyg+aDxJTQIakcJl3i1j95vV9i8ogCiUPKG8wViVE8J6p0dFEfZcYTYjXyLQI/zZlJ60MsqgfAQti0Qd4jcmGdxEKL5z8F/dv+lcfnUvhRYJoXc+5sIFiZT9Ip0/98bo6kLJAckUWzhZfWP2h8orcCmdS5Pl6vLpKcW2S/D3KS1PoRiV8y4lj0Lisfjfy9yU3R4REsVfoRgWlX17W6+lUb3lceWqGotNmYuNvbD0qvc5XXB4Q5pmRgUMlxLf0HzklnS+2z4ghjFTUgv3ga+XXpinOEsSuubD85PAeWT0b5lNQEv7RkviFFyN4NEj62UTZcRL+g+2VM34571PZQlLciotPGFfN5cLyiBJ97DIsQg+weHS/ykqlzw0VqrLdDek0ft2Dw0WPsxGTod4pFkUbxfJSW7S6/OWsot+Bmj7YK59z4w7T5pPl68CKNZW84jkZ8VJYVgch4mR8uWEp1HuQq5Nx0PQ4uy/bD/gtSLc+CWqk5
 xMofSRS8
 dUiWC9P7yNe9NnhgvTTvitfquiJGt186axBUQt0RMWinXi/jqlnWRgWUTTST6MmJeZeXT0ZlZzh7x/F6BqXaD86ZWPzrgzNvaunZhv+xYEM81uja/RBa/Hc8LyTNqkodWpTpUVIcq+Oll3ujTOSFEOueyJJUUwP+8vVyTJ4ERzYHHCY3Ers3B9gQz1/Edpv8LGpN3Ildk/nafZWEzxiAXs6hruU3IgMr5av6Qwj139iqh7fSVHVw0Jsd6vOgk9q/U8pYVYVcMya14FXYNZ/kSoxEoV6z564A4oSLilX5KH5UhntyEbF0ODn6bavWKA2zvzo0Cp2lGwUnNW6gq+NLibrSANty0TV9EneCJteMDfbGtDHwYaJw1Xc+PHvRjpTITtUvR3VNGumAF++0DhmeOVNJtP8MsmrJBY2zpZPbT4VEWtC5/6uTGY9Ye+yeGoqg3yG8e6tK7MAmEBVChHPHuMob96IAJ+xqKrmt4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 22, 2026 at 01:13:09AM +0900, Youngjun Park wrote:
>On Fri, Jul 17, 2026 at 08:25:12PM +0800, Xueyuan Chen wrote:
>...
>>  	local_lock(&percpu_swap_cluster.lock);
>>  	if (!swap_alloc_fast(folio))
>> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>>  	}
>>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>> -	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
>> +	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
>> +						&nr_swap_pages))) {
>>  		swap_cache_del_folio(folio);
>
>IMHO,
>If we get here the allocation succeeded and only the charge failed, so
>we already know global swap space exists.
>(And also swap_cache_del_folio right above even puts the slots back, 
>so nr_swap_pages goes up again)
>
>Could we just take the margin and decide -E2BIG or -ENOMEM from that?
>
>Youngjun
>

Thank you for the review, Youngjun. You're right.

When the memcg charge fails at this point, the swap slot allocation has
already succeeded. After swap_cache_del_folio() releases those slots,
re-reading the global free swap count may also include the slots that
were just returned, so it is not useful for classifying the charge
failure.

I changed the charge failure path to use the remaining memcg margin
alone:

	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
						&swap_margin))) {
		swap_cache_del_folio(folio);
		return order && swap_margin > 0 ? -E2BIG : -ENOMEM;
	}

The global free swap count is now considered separately when classifying
swap allocation failures and the early rejection paths.

Thanks for catching this. I will include the change in the next version.

Thanks
Xueyuan

