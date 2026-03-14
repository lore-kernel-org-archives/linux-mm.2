Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D77107BCF1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 03:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D7B6B0089; Fri, 13 Mar 2026 23:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720DD6B008A; Fri, 13 Mar 2026 23:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602F66B008C; Fri, 13 Mar 2026 23:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4686B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:48:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19D27B9A60
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:48:11 +0000 (UTC)
X-FDA: 84543285582.19.9AA4517
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E89F140004
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:48:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=bnkcnqTm;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773460089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DV0t/dqzSE156GqkAAZgS45ZhHgnhgFYawmC6jkXx0o=;
	b=h5fhhGq7tDQqbLjQnmLY33EwY5gEOItmsUz6ofoVRpviDO5IzaPLc4kW1lnfJxzqiqMleZ
	nF+NslR2sbkwjsbAOsyfQyJ3KhpwJFTP1dy6yYdTOZBBB1EvWHnNzsXW4XmuNKG0j/zeAN
	4qfqww1FFoGOzhwZyWo0zQq9TxPVLf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773460089; a=rsa-sha256;
	cv=none;
	b=UJLab/3/WlVPTpDjnZQMR3n7ejFwygJFTEhJCq9kQPgWLTXIwCWdamqJItlo4MOdC3msMH
	PZWwU9xvZqtPkmYCKTqUt5BTY9T7VURPwMd5+JWyEGFE99RnhZYfrorDGzSEL19daTtNZt
	Hal+BonPjI5QrKBQLtr1a2PRNOuQ1Jc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=bnkcnqTm;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae4e538abdso31710175ad.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773460088; x=1774064888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DV0t/dqzSE156GqkAAZgS45ZhHgnhgFYawmC6jkXx0o=;
        b=bnkcnqTmia0afhIZ+ti4ynIZk55NSRVPA+Vp7xczg5qMODesjo4TZC98DuuRBmDBLW
         ToeccRnq0/PFqt6NsklRskuLJLPj96BYjGJaQSqJOXhar9cQIp3wAHp/+Ub9REbtBSgd
         +Wr27+9Cc0uoP4soA3vsNE0vQEvxm2ZB8F3YZSCbV5eYKh4z8Aq0rNlBCY6oVEme34ne
         4Phd1eLuwjrmg7JUK113e/ApcZ8PqikziYiyZFcSgfIxWiRdKW1WFpY8OlfkYfhZKskD
         OzZZgUjNtbYNbmpxgd8IQoNz49axloElRG/gBEBPCmUb25QEW3UfOrMPQPSdxdAyGZCW
         ozoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773460088; x=1774064888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DV0t/dqzSE156GqkAAZgS45ZhHgnhgFYawmC6jkXx0o=;
        b=GSUY2BWWaMUDZhxr1eaWguqB1Tt/Gnh1ZvdrEO47EH8tWCrbOCZ3Ih+t0cNsB5K3Sv
         wvNZVfbKjC6A0nRBIK+WGSvG+1bQI+fuUJcseiLDpPRj/ywVB17d24TSTysNF3ZWfbNH
         uFdBJUFQiUwze7rJhpQdYCkwHmEjzGGeElZMw/3cOxiaYQLnuUEIMQssMGnShNGAQKmd
         gbPRuulmGZLIEoIZ+qtSNvBYbZ2X1VoObcrNpxSxE9QYK3N0dZ9lrquoqMeS8Y9XjF/f
         o6Jx/saXsX5ABYfEf4zXHoDtD0kdHez17TFuZa/5qNZEqgsQW+Ah7OlzuJLw19FLTGzt
         o+FQ==
X-Forwarded-Encrypted: i=1; AJvYcCVisVMCLD3bZnMHDWZo4d8uTJ31D28PuaTtU8xipFNvAevYa9SiUgVHlR+u+FJ5MZ60QENMl/c1IQ==@kvack.org
X-Gm-Message-State: AOJu0YyGXuzd5acxZDgX7/l0ddc5OkePYV79hjWBEHvWrEa0xVEZoGMs
	kbNy67woZhlNFmaEW++NlVavjJPIYP9BtPoI8+3UO9O34wsRHhLxiYAdTiIBbHGd9YM=
X-Gm-Gg: ATEYQzxZTjRl5fv3Ad+6gXeUOUDw+zRs420G2TAqMBZwSA8aew+Ar7TWXs2ZsrVKYys
	roo292o2e1Ow21wnfPjNd50m55YDpFOI8WUV/Zh2FZABbECkDtrGlUAD0XUodMog39FP2pF2Qao
	DJvw1x3hbkczFDgV0zw6Sa+vfxEkErkgicIzwhgWqvJYQlwdTmAgZRvn0LS7a+YkdzKyr51HOy/
	TodcbmYbiFqhVyVsqQKKm8NEooQvdFmVm9NThA+xD11+vOs2EmIvAFZKGmmNLy9CMoefBaetgVk
	Am1yPx/tRVTfjg4RYeF4SF3GoJ57uFllw+VdA1NqFJp4wYoCvatDdOaVCcSc3QuWaSmbb7gSotx
	/aiQ26jvcErNWCgp22y9BbD/QNzMXpuMviHiLsjngb5TAuM8eNS8cZUM23Gg51FaCq2JVIfCdpO
	S9
X-Received: by 2002:a17:902:e74a:b0:2ae:cefd:18d6 with SMTP id d9443c01a7336-2aecefd216bmr50709525ad.2.1773460088122;
        Fri, 13 Mar 2026 20:48:08 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece838d3fsm50446025ad.77.2026.03.13.20.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 20:48:07 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH 4/4] mm: align file-backed mmap to exec folio order in thp_get_unmapped_area
Date: Sat, 14 Mar 2026 11:47:44 +0800
Message-ID: <20260314034745.168715-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310145406.3073394-5-usama.arif@linux.dev>
References: <20260310145406.3073394-5-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pcpteij7m19nqsjijdinmnsnji7s8zs6
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E89F140004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773460089-437088
X-HE-Meta: U2FsdGVkX18lDAhZQDBqMq6EbGTLfYhhD2zheldQ0mUtdvYL9+f0PmRMizm2HsG/XqjzZVv7OGhYfTR5BjMTZpAPBoJWHpQh2gj3Jv5ydMDLJ0ol9gHZEA09eiKeUIF6UbcbLesTeooRFM3YRRfCUFAeRLXhKHsmpaKTa+dxnRcAnK44NEZKM21r2SHR7A8TzknoJG6+64rEgyO3o2xWpvO11kB1E1xwEAYPzgRMrZ/J9cPkwUqNo4e6ukQcstrUBsn9AkZS9tWGPVRPZ98pChKB6zf+u4eNZ5fqclKkfKlx0q0CLdSOOffqL6p2bwNLu6bdFfyJvAV66yc4aXyQWyePzDopWBWTDuC83QFNyjWXXijbnya5WGolteD/az8x3rPTtL8pExdVnpF72z0Yqez0UGYo3QVHt5HWGTKsnS0LRFLQ3LCaL/+BR9nchqWGmqAIIATArNoxoF47+20M/PH6MOkm6rq3M4Iox1FS07sdl1Ky/Qxc7j+u17Rih3Icx3OTNzqdXeMzVMP4yhJ1DvG4tJOY8INtYSbGnzE+5lS1z82DPTzXxAJOJF7prLR8yCZ106v5vGhp9VJxuMgrpbfVBMytYXYoM8kqNryo73oLkCAkL1t3wDIi8ulJOQCvMXVmliZJtO/a9Fj1UKWyymg0EsIIgl69FSavlgyd8++FsInQUYnEK/X5EJcVunpoeQS3WxVMD5ms1VdM8XX3KitPyMCpmuUty/GAqtTJVoVqJEge6wGLot9h0rJspujaWEchSQaWWtpZJjgS+e1zkoapsDYrfZFpzBuYwGHlLFVhFpmVVO1pA+6P2ri92O+J/aiA13ocvcWdmxFGzOSH0ZrbcpPgOqms8kjiwQNPtBePrgwQ6KYGC09982LoIewoEhYfiCabHpAs82wDTP91BJOc1lNnjIUA7gwPQZk0pmI+/zilhuMje7KQbRFAGQsWDqQyxphFCnkzsIJtc7X
 LgWGmInK
 DDeXX8x/+wnhTuib91YLM/Q/XSmPjX0iejMSF52Yt0tKCp2sPVAc8h+E8aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +	if (exec_folio_order()) {
> +		unsigned long folio_size = PAGE_SIZE << exec_folio_order();
> +
> +		ret = __thp_get_unmapped_area(filp, addr, len, off, flags,
> +					      folio_size, vm_flags);
> +		if (ret)
> +			return ret;
> +	}
> +

I noticed that even when the code segment of a user-space shared library
satisfies PMD_SIZE (32MB), it still doesn’t end up at a PMD-aligned virtual
address. This might be the fallback you mentioned. Adjusting p_align in the
ld.so ELF loader does work, though it also avoids extremely large PMD_SIZE
values (capped at ≤32M).

It would probably be better to skip the PMD_SIZE == folio_sz case here,
so we don’t end up calling __thp_get_unmapped_area() twice with the same
parameters.

Thanks,
Rui

