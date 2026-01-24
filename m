Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F57D778BF
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 00:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379CF6B0566; Fri, 23 Jan 2026 19:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351976B0568; Fri, 23 Jan 2026 19:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25ED26B0569; Fri, 23 Jan 2026 19:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4DB6B0566
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:47:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1590551FE
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:08:01 +0000 (UTC)
X-FDA: 84364919562.22.A31F5FD
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id DCD971C0008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:07:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fj9BXE1T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769213279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
	b=t1KO5PPNWMWL0BtTa9KTi5EF9ZnELxvQmW+mWNG8bhr9mJ4omrx3ftYn7Cu9/WiFFpOojy
	Uu6Ag7zso/b25wWMICHx41EAJDhitFzubEgyDOFuSkw6MTtagxSbEocAULQL0ELsKnRxwB
	6x5ioAjZhm8qqM6SARMVbYt8/gBdaQc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769213279; a=rsa-sha256;
	cv=pass;
	b=3ESWGc8BNe1u4O4uJ1iCqpJshqNNp/k8RgHnbdCuRrTyoi6rDzylnBdDg6VQdht/0uMEgY
	tMW1EvFJOqwaauzxr7LkuBr3loJfkGN/EoJFbEgCzv482E6tvQrDnZjqV4dPpVYfWEeacV
	AdxhG17trY7gw1mP3h2OGXWHgX5LbjM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fj9BXE1T;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ef5c04151dso858256137.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769213279; cv=none;
        d=google.com; s=arc-20240605;
        b=DLpdHoWpDBrn4jJW8b9Qk5ctPkUivUCJ6vLAIT3s6IpETNxZYqnoFJ+LoxGAAiW72I
         4zy2whlqfapN5aTcC7fGfR1Wbjot1yfMPefviEaW08Slh008OLq83VPN5yixRJj58Ybo
         Td8pt63EOov1uPN9mDn4G67A5aC8Qn4GSZoV7aXmhYq4uIZjtP85etOSEHezLl36ZsGb
         Xg90HLsBDhoSBHiOnFwttcX7EwaYdL+KrNSv0MyfSEX6aSerbBdoe14jtyHqsS2IF5uN
         j+EJ9hu45fUHqFZ6hemSOVE0pU4/hINcGdW3ZZieixu7GqxTDjhIa8++KXoycOvknOuc
         9LYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        fh=tXuXG6vwQDrzafLx8+OgiV+WnXtaXVmTdYXKQ7Z3hiY=;
        b=DWVIeuqLPRT9cB6KTev+tOk3p6OHJGJ+8td8VehtwCmrITvwyofxo0zIOtlX7gDJ5W
         8i0qXGgFapLc5qBervcRGMAtVsxLk/1vcV8MIJJ6Law0L0VkS30Y+UKOjRsuE7TQrScc
         LARmbYXyiQMGC9i+6VttJvMEkwA7VEf97DMNWEZaOPJvr8UwsQdksqOcN1TOugfTDKvH
         JjfOULiN1SvXfrnWCUf3FBKGqlwLSBz8Nj6PlRfVzHQyRVn5uyzdkCtETydsDyg1U7/y
         HjiivKvhJl294Erj9WR6jWD/uz8nSwF0ne12RPC8QLoILB+tBLaFMj+LDDIJZgvtE6fN
         trJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769213279; x=1769818079; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        b=fj9BXE1Tob4KsD4cES82GAMGQ5EFUj7OUEyXMBblzYKRuuUARuqnrM3BpuvGh3mV4E
         k+d13yUMe99XR2WF/7E/3FUz/ZV5GNIUsfBs4yV0OnJWMsJgcaGiKXfV2oRoLH+ScHE7
         1Fl5OPcKhSqSHMyIqsE5IuMXFlhmvxm/K+R5wYsDml/L9NNnk2oKCB178uwQvJygMTSp
         NeH0Vv60MWzJMmwN0/04mUiQigSY9Yx1yAe+mfBXtrkeKbkuDx9BHMs4Jwb/+LdmYkcZ
         fQY0+D0zl4UdOvItUQk+1ySYylxSI8f87fZ+/lWJINXaoJ5gVrXxkJeZ5s2hrwm6W6wi
         mtow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769213279; x=1769818079;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DNHlYn4p0TppVAhoBNqhHlPga7XxHNgUsUOejXrb08=;
        b=cUtMIVzAdBX8skZW0hV0rfjUmxDaVKTXT4bcJzRblJnEmG1+CIPbeaN2z8U7hssPnR
         I6IOJTQQlcxit0jq8OB5EXGEe/bgBznpOnpTQFUfzlW2N9g/UFi36y/tUxa+klW37TCB
         uyZQBP6mhbir1kkLoV54viItVSqXvotTwdjeN8GP+pxJMuBPOh5coPt9zjc4qO5etimL
         OxFkDIBScphhWy8DTvam8m+kjl7//ceWtkhshRj3ReoR4q70grS+/MHzGGN+d0y6FRm2
         OaBuKhkPPR9Jv2hEaNMnyVTFMFHgENRGpZ/WrbbdXPcPJ+SVHL7qYCbzUcuzLiKd5jH2
         1E6A==
X-Forwarded-Encrypted: i=1; AJvYcCWMiehZN4/SnlnOXHXbCSxbgGpeQjDcbfxh9FAy4C941Y/jR58usFfj+GNoGJZZaM4p+rTXgsWMXw==@kvack.org
X-Gm-Message-State: AOJu0YzxFS+D0ojcmvFvHqmZb4WIhmhfx5T0lWV3sJZ2xutglmMhACB+
	0sT08j5gIBJMR4BIUykoz3VGYzVaKlG+/jzG9c9nr0JpgNPmcedVZKQMXhpQsKci3pgcjfKYS1f
	4+h8QrjOlwPbd7qRqexL6tpryrh3AJtOphoWeJi5p
X-Gm-Gg: AZuq6aISLmok4cjHTVhf0+xSyXS2Z/JeL0dpcjjCipKy7TVgVt8EMWUZ7VGIjhJDzXC
	dsY8XTfTxSbMqrXi07No0H2hutFvxdMKucOqz1VjY8cTdfZ+jM2D/uEe+OU/7K6VTcjIUFjGIIu
	oqZsW8OOgQ3EzHid+pT18M6ZYOm/xbAVxy8z/8yPjoTouc1VEdFk15X2SpQS8tDulVRCEx7C48H
	ruf+dOWi7sHrARFc0tORkRfvEQQ+4rvDIR9MPDo4VkPFfrf1N5ODyF8fD9YOiy8gfFlRP8X3GYc
	at31SSB4EVuDbrxwj+mhRQoXzA==
X-Received: by 2002:a05:6102:374b:b0:5f5:30e4:c8cd with SMTP id
 ada2fe7eead31-5f55874acd1mr847220137.42.1769213278639; Fri, 23 Jan 2026
 16:07:58 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Jan 2026 16:07:57 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Jan 2026 16:07:57 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
References: <cover.1747264138.git.ackerleytng@google.com>
MIME-Version: 1.0
Date: Fri, 23 Jan 2026 16:07:57 -0800
X-Gm-Features: AZwV_QiZSx8uXBlkjUzf-XEIBRHwTGQ0-9_ksNxOa1FVccYAoX0KqqZc1VcdbW4
Message-ID: <CAEvNRgFmq8DP_=V7mrY8qza3i9h4-Bn0OWt72iDj6mELu+BiZg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: david@kernel.org, fvdl@google.com, ira.weiny@intel.com, 
	jthoughton@google.com, michael.roth@amd.com, pankaj.gupta@amd.com, 
	rick.p.edgecombe@intel.com, seanjc@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DCD971C0008
X-Stat-Signature: nc4duc56x39a1ixtej3c5ru6zhyo5bcc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769213279-17844
X-HE-Meta: U2FsdGVkX1/3pZay0gXBt2P0YTCvvWYtTaafwRxKOgsTV+HyOYQbLiRUHu+zgvGFmGzK9ETJ+bVEewukkIS2rQVo9g2s7O4QEcN/M/XuGPhVW4yECP6l+VdJyUQ4a1K8niqFaoGhVNp+ILGG20oFbt+OR14EAhMpnjXO+d13M/l2QEL1HemKVpHAUXG4a6yp+IfvI3PaRgrPoVbFKS9yCktQzR/VCzwoPW++H8RVlLiTihWxhGV9aPa7uhlcMBXzM20PylbhTTmr5BmYMLHvxmKCFgMuajSjcniAzGeeOa+ezoZgyRZ/U86yFSSFxLy5iWQ+C7g/QhuCwjWr4FsD4RtYnIviqCgBdPBRqfCHKLG4JHuqgpL+Ah+DZb/QPb1FkhfyU8kx6VCJwnRbdiJW3L10hhrVVFBU+zT47pXKcMXUvL5ymzg0DoMNILIaIdd1QB0mXRg22FPpU3WlGrd6ZYhcy1xj87/1eV2LXCjKpvyE8UVeL3H8pwdxsest8tSOaBjVgUseQehzmiozPfAbFHSmKwSVhVk8bI2UXEF5ba2suJpFU/eRWQtAbQFSL6VdO0atZcpYdyQjMHxI+cL8PXdRVdYEhtAJCfWEGuoD7rl2PDq8QgdWUoEWl8yDHPaFGq/yCIGk2HqJYTAiRZO+DcNFj79Hr6ZO8HGBG+h4e3Ug2MdyPUKmMMJok59ppm+5wc2XGbQPY4DL6UfRxL1PV8XN4JtUdClb665v1tJoZU1W54nmjVzfssruFBiHDmqI0gkOhSOjLQQxc5wKbuiFxcgG164366TJrJ5ikKSk87u+R6mRKyHCS1Uxy1SfGp8q1GgEiNEGlRWsleQtB8tG1RSSQrLchReCfHXNNLfBSI6F3VaakTivwNUcTWVAmEOs9Q3Rfa0iNRCUuLRlnRpiGt0GlrytIIkvEzGlbVLN/Bwwz73oH0MTZthjTkP4N4nK9ZZ2YaLfbqDHZEZPtu0
 Kbooh6+P
 m+BWR+4kAhO8x/1PmambNw8QzNBuH5D9I361bPTIRMYGrxjh6gMw4jcvk7DFtDJ7Z+sNqvQaH824NWlFXBUz5hkkwLp5ONyY7t+T3WiOI/SYJ9GmKq3Yd0hqChL9pdThW7Yb357OIVj+dp6YsGFOKiFnIP721cu0Q/u22QXEbMb0i0HzekYPjyl7qSSaNfOvy+ZTGEvZzjj6Y0qippJNwryvzv6hiLKXwXMm/Ayk5XFqN9nYthe+HmriSuBZCPghpWdOrUCpO/YSYLNvRNCnd6CegCTfRNLkamqI9KoDEzi0Fe3pgebpfW98qxLMyH4rKzC5SgtAMGmBpiFR8w+qrXsxVQkBJzXcYsV5w22br8PA/vmCg3EeYtnid0nn5T2OMRtfxwPchRgd/FgJJim0ZPoGKWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

Re-using this thread to collect discussions related to guest_memfd
HugeTLB support, also trimmed cc list.

Here's the latest public version Vishal and I have:

  https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25

On the guest_memfd call on 2026-01-22, Michael found another bug to do
with multiple threads trying to allocate within the same huge page at
the same time.

The fix we're using to make progress is to use hugetlb_fault_mutex_lock.

unsigned int gmem_hugetlb_mapping_index_lock(struct address_space *mapping,
					     pgoff_t index, u8 page_order)
{
	pgoff_t index_floor = round_down(index, 1ULL << page_order);

	return hugetlb_fault_mutex_lock(mapping, index_floor);
}

void gmem_hugetlb_mapping_index_unlock(unsigned int hash)
{
	hugetlb_fault_mutex_unlock(hash);
}

and then

static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
{
        ... declarations ...

	if (gmem_is_hugetlb(gi->flags))
		lock_id = gmem_hugetlb_mapping_index_lock(mapping, index, gi->page_order);

        ... and this right at the end ...

	if (gmem_is_hugetlb(gi->flags))
		gmem_hugetlb_mapping_index_unlock(lock_id);
}

Yan also found some bugs (thanks!) and there's a discussion at [*].

[*] https://lore.kernel.org/all/CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com/

