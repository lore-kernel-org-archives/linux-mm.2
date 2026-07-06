Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD632C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 02:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452F96B00A0; Sun,  5 Jul 2026 22:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCD06B00A1; Sun,  5 Jul 2026 22:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4D26B00A2; Sun,  5 Jul 2026 22:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7D056B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:03:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5357C1A0263
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:03:35 +0000 (UTC)
X-FDA: 84956705190.28.7882BAE
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C626140003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:03:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A5t2wwo5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783303413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VpbU2nD8Sf2VfGjQR5NkWq7+R61c2WqH91bcQarOxZE=;
	b=5PSwAIskK6bZO4vG2bMLT7dsapJag1rRSGNvS/9eG9d6lSRk0UDsHCwOcBwHHvXJypy4Em
	QMY3A6lNZivGHzBRuWWwMvoWGixxzgmHbOPs4IEj/pnINFdINplRwkRaMy4QINgZQAgT/3
	ZOrcxjyX1aXF9I2jM9BLTy0yhpuhwNg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A5t2wwo5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783303413;
	b=bCyPuGh8ZmtkOIn/uYsszfO6a3ZIB7Cwswj1Jh7bCUsd/IzGnvIfhW0uzDSGgodKgeuDJI
	nPlBzKCsVbERj9HS8bChxl/YAY96rCdEp5NV9swP3csxB36TmPUys+MslFoCn8nEFKICjR
	/ZawA1n/okr0CF4AJR2cExJxtWj3RLo=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso1151197a12.2
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 19:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783303412; x=1783908212; darn=kvack.org;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VpbU2nD8Sf2VfGjQR5NkWq7+R61c2WqH91bcQarOxZE=;
        b=A5t2wwo5sp3mPjhr2WEdYCJ2Si/sGnSvxSyRmra3aCsI6u8FgXgcmo9cD3STo+Z/m5
         BzCzGQsoZbiNulbIcsk3Ii+moKis/XY3K9yY3yk7t4TG2f997ZSje7K1rue80NwkBkvh
         8CAvMIUgcuQnB7s+U/p7NPspgzOYFS5I5fd5iPlPr85LbeJ6p0z3QI+CEM6d4ghY3LtK
         Nq8hQxWv8GL3nG79ycWgffCr9foShBL2LrwSgCxZPr6IKPtCwbRmCRR0d4qMxDwychXE
         jsbr4qPAkmxwWhdCpxxw5dlb1tCYhslSwAVIr4h2bpBpUMFZQE7+OxhVIYoz/CsRb6ui
         vfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783303412; x=1783908212;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VpbU2nD8Sf2VfGjQR5NkWq7+R61c2WqH91bcQarOxZE=;
        b=KYIgPYP/KujqCJpk0HL9SCaISWG2DxMoH9rWY+/lhnndBCGNP6vxucaQjtvjPudJnv
         IPx4mkiC7boZFLz6VoioDD7JZhD0RDJqwHNupACFI4SwuxDw5AL33zIUj2wxlqDwFfGd
         naTAxP9iE0tZWy9BPo/Xlypy9thHxqWQ9pGP7kEmadycN9+PM+DiKHSa6DnptC5JS+d2
         eoWsYCTSK1+bgICnE50HgiZDfRB8/xw8pqp9BMeJfbqo9VueMTPh+RkOfOtQ6ABZrEn1
         ImOuRAMewYaTsg62QJriDRyWzujJ3Fao9CaEia4ZJ0CzYkzVUudMjmLDZzES5xR1Osxu
         cMOw==
X-Forwarded-Encrypted: i=1; AHgh+RoXUANDZQa20JiljBD5BuUfxd+ULY9xvQccOhtyFeFi2I0BwhLPwdlvou8W45UcgIzIAu1vlEj6YQ==@kvack.org
X-Gm-Message-State: AOJu0Ywmvj+chb6n/a6nYijNq+XiKRp966RnbUTYHzO2sUXg3U9ifdGy
	7eexokWCHoxtCEz3ZcrvrF3qj3Zcg1IwZgGu6JZX3kqDtnc2Ypg+9u+R
X-Gm-Gg: AfdE7clvoiL0lRFClwG0afYyh/KVzYUNpbjLRs01sj6gLRujULkU2zO3A1veHca9lZC
	7od2vqA1jzS7imfBLVcDEDOLBivriEAYKWj3tngb8dhFQCrYNTsO6rE6/HZeV3Dmy+am83Z8j6/
	0W/B906UxAC8SJJ/kqJvc+jMzrfEnkOzHT4cXkfyOq83YMEFi1BDHPkd8UOsKNQhj/u6MDGg1Ui
	KREK1T77K7zmZUdL79oI37jeJ9LbKRg+4UbV7VONzoN700DOA48ZtJr304K665rKsrOOIGXXn7h
	YKiQd3DDBgV1L1e5Z7KOlqQo/LRvcpkou+cJKL/wnTBlMIZLIHgPA6lZycOvFGo/OT4jI57GKys
	nspF5hzFzQhO7JP4BIVWYwzTUXEUByPwV+uEX7WI5u4UWu3XW325aEoAuKG/0Dpdyeuzk5yd4r5
	Hdr0qZllXiR0u87W7ksX8h8+sPajuhX+acAB97dvrUJ73K5KUak7TCoEzAIpY/JeEjH1/kfcsSO
	1hwAm5gcDJ6
X-Received: by 2002:a05:6300:2287:b0:3bf:a941:8932 with SMTP id adf61e73a8af0-3c03e1f54bfmr8834888637.19.1783303412412;
        Sun, 05 Jul 2026 19:03:32 -0700 (PDT)
Received: from mars.local.gmail.com ([240a:61:3285:c322:28fc:365:cb6f:6417])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e921d28d9sm5082966a12.24.2026.07.05.19.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 19:03:31 -0700 (PDT)
Date: Mon, 06 Jul 2026 11:03:27 +0900
Message-ID: <m2qzlgub68.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: add sysctl_max_map_count() check for do_mmap()
In-Reply-To: <20260705174443.08a11649b8e1c9e58e8cae22@linux-foundation.org>
References: <20260702012830.667205-1-thehajime@gmail.com>
	<20260705151512.5edabd9bb5d11cb6f1c6309f@linux-foundation.org>
	<m2se5xt1ft.wl-thehajime@gmail.com>
	<20260705174443.08a11649b8e1c9e58e8cae22@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 99jacyhks6s7kxns6rdy7jo9nbbp4ppm
X-Rspamd-Queue-Id: 8C626140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783303413-241531
X-HE-Meta: U2FsdGVkX1+xeiJ3yAxRTP9aMzrsP9pX5zQrxoLnnMgPxCfgbKN63rVNwjzrFeTE8MoE/Ulvp7OgtSZFfFZf/NUWDxUyE+q1ZlYVDYPzS46K7idyoZnkMRe40qb/VLtwxhka15WZ2OhNyLIOS3xUGUbz4zR+kmWh8q+cyD9Q0cetQF9JBAMdQv5HmZr2NRHqFhoOaR+GsPVfi/f9nXY722NLEgD+F06LtyV4LoLruClKLcAVdDE2DeZegRCYo6TisaOXoo/dWnSve9s36c6ztrrj/ruzl0Qpp4GQreDlRW+pAPH1SfPksl8lQmz801vY/wJs/SNcNbHjLCyzwV1HVoOkreKMT3bBat410DiiCR+OxJWZlmIlanAkEzxEVzjAiY74bmYN764wCGf++23EcH+D7jCx/3QGyGxp5s9iXXwnVKSzM6vjmzuC1+BYfr/8Q8vJb5CYQzZxUdOmU5Xi8OsAjCPJGUbdZGKh8txW05ycWMXCrnLdGe5thiXgZPRTce9uvM2EPq3Rvz2J3d+B4WciTw8/5foXuQ8b9Z1bQ3VL80cDX3JXblXOr6QsJvj/VGNIsnJWJXQxEQ9CiXWRfi9qKjp33yDrib+WBOnXlD5q1O8UCO/9w0zsV0Q7tYCSlkpYGWo8QS8CRbGdiHm8BPs1uMHa/1zMIjZ0BZgTdwflBxaEp0/i6IqypFVVJfpnRYNS6bmTuSYumiefCisIu+X4cMQ6UI/2ONOrTUFnlRPf3kEHpZMfbt8cjDU15IStdj+5tST8ywwEiPbdSxQbRpERCvaWy+r6N3LW08ION42Xl0nvKORspXM9Atutxtns+/FfPI4pFAOTKRsiUeKr6EWg07f0o5KArwOfaHfLgU/ZdhIeJREtoh32pSxFRenSnK4mNIw/yLFFCrQEEk+J4fwKw5XLiQBxRRNpiko27WtpA2iHk0f0hIDfJ7DE95Fb1trh2Bp92ZDgWm+h5/0
 dQxvoOiX
 zCQar9M42+RpL9m06wvEoNB7SJF6g0EputBUj/o/IaTv/WO2h8mmgT0aLjzobUTEzd2XEfcWbcCoUyLEUBHZaK7RHcJ0PmmD9yMPbDXt7eZQBiCzBBRIgEvg8FE//xk01UET/YM/+CBnzO/zzXv4FUSk4NAR3F1DrFesECqReErcyRRpXzseLfORJdzLshA8Pz8oReSXS9z0T5Gnhyc6dNKwpozbV9GPw+thvgk9Q1ifXSnMT6l22Ib1lmAuIqCTpyIyVMIhDbxFhiWFu7t0JQBotS1ig/L6ZZ590/VdyeXR6vRHSZAUfGZDEvjmEj9Jt3WxyKE6lvpgZ+6odVMS5BsYL6eNcyBbP+BYn+/4j6YuQVOCSELS/u4Ro7Q+M5BOdhm8Km6XwyegHhGUL6itk0vkwBxgu+M8kNixPYXIYO66vsRPuFhB7Ktb92eYxt7+9vaTVbmnpBk2tjuCJbk1aP+purpvh4QV/lUJLs9pwF8jZmAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 06 Jul 2026 09:44:43 +0900,
Andrew Morton wrote:
> > 
> > I will follow up with another patch for the issue detected here.
> 
> Great, thanks.
> 
> > btw, I found (and sashiko also detected) several typos for this
> > particular patch.  Can I send v2 patch with the additional fix, or do
> > you prefer that I'll only send the additional patch ?
> 
> Ah.  Well.  Confession.  I actually quietly fed your changelog through
> Gemini to fix up a few things, resulting in
> 
> : The sysctl variable vm.max_map_count (sysctl_max_map_count) is not exposed
> : under !MMU configurations, but its default value (DEFAULT_MAX_MAP_COUNT)
> : is still used as a allocation limit.  Currently, this limit is enforced
> : when a VMA entry is split into two chunks (split_vma()), but it is not
> : checked during initial allocation (do_mmap()).  As a result, if a user
> : requests a large number of memory allocations, the system will continue
> : allocating until it hits an Out-Of-Memory (OOM) condition.
> : 
> : This commit introduces a check at the beginning of do_mmap() in nommu.c to
> : prevent this situation.
> : 
> : This issue was detected using the Linux Test Project (LTP) test linked
> : below.

thanks, this is perfect.

> I did this "quietly" because it feels a bit rude telling people that
> their English isn't great ;)
> 
> Lots of non-English speakers appear to be using LLMs on their
> changelogs nowadays and as long as they double-check the result, I
> think it's working very well!

thanks for handling this and a kind way to fix my mistakes.
yes, the AI era.

I will send a follow up patch for the additional issue.

-- Hajime


