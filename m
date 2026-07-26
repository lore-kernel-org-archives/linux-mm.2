Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8452EC531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 09:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC616B007B; Sun, 26 Jul 2026 05:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86776B0088; Sun, 26 Jul 2026 05:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E866B008A; Sun, 26 Jul 2026 05:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1E46B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 05:47:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F217380490
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 09:47:04 +0000 (UTC)
X-FDA: 85030449168.04.76D7231
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4263A80002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 09:47:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UOcugSjQ;
	spf=pass (imf02.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785059223;
	b=zTQKjOlhIrnz2AHfPQ9FOdtKgqNzrSF3hn5cIH+mjcVXPPlVqohxFhQYYg8yL3EOAR6VrG
	nVdQOZw7KDsmn+esnPAK+gg0LaYexnKUEkGb8hjpmrPNMYeAHSh1oWWbmQ710m/n7IqZrZ
	gMiAWTiOfYamNQDnU145C5lIolmfPkc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UOcugSjQ;
	spf=pass (imf02.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785059223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGTNSNOhln5X4OCPRtTEj9R34uYX6rw/604aiiTGhzE=;
	b=RN4E//lEEdLhX45/DyZqHNHgzdAN3sMjwVIOmNhdrk8sdNHuLvtG/PhjRPBWz9aiqM+zVw
	/Xc7YHowJwYiYqcqCxJevhNLLGYH93f8eDBl5gvbKH88pMaFl541ZtujQV7YPgqHBFQ81L
	hyYDf8JOK3ubhfiCv+8c2BkpXG0E3C4=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39ee96f8047so13622761fa.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785059221; x=1785664021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zGTNSNOhln5X4OCPRtTEj9R34uYX6rw/604aiiTGhzE=;
        b=UOcugSjQrl++dUZDU0TNWw3KD9uHJrpUn5DvxlALe0QP8IpziN6ce6TdpAenRWqWVk
         k0LDhf3JkQ6CLAAZEcxbCFMEYAw9y5OulNYcCHF0hpLA03N/x2mpbDjqCEkoWNXtmLsB
         wmTK4GpueARWl9N2R/EGrESCpnpnKi4GRQ9PNZfWWazI+6QNmHllas5nWYaFXuc/XtnR
         iPdB8YeSM7DiauE69QHbBZougw+PftkZIv0C7otxqy5HUkVVO9iBR+G7ZUOtgOfxsBhx
         ysjWHl8RmRTmid87dj7Q1GZX+z7x6Qq/9Beis9GqaL90JN3bKaQFKOLqfAGz2il3iLv5
         g0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785059221; x=1785664021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zGTNSNOhln5X4OCPRtTEj9R34uYX6rw/604aiiTGhzE=;
        b=iKqUyj0P6jWjSJPY5BnRx5CGdh0r5ctVfhRMS+bASAaDnQaiWjBYpPgDM/xSgKTvFv
         7djw95huj5QpqOCa6v9FZzA9sNZa7sOECaYcbZx8YMY9gElqVin8iRbvSmc6tWCUULvQ
         qAwa10cook0r/N+Uzg6PEL+yip+/SP2zcAZBkdUVRxOT0u4YsYMicI6TDhil2qh7MIQb
         iH0W6jP6HJSwYmlxRG4JeWKZ9cZpyk1ud03Lpl2w8Y0V514rvH/Y3atj7cqwuiuP/moi
         kiU64a/UWgzPvhisKZyPOFnx9pyyT8hrf1fMrrvU01ogQkM6x4E3H8jrlhfw7Wvdy1fr
         6pgQ==
X-Gm-Message-State: AOJu0YzSH7P1/MJNi/AjcoKStphpNCIJJ+beAaxfX1n0XgKoBiSZynqf
	EJBVgadwI8OO4uttsxkV3TxYSjQaek8fBHYoeewWmyIkXKcoOlXPevpd
X-Gm-Gg: AR+sD11WMfwrKEPXYcuaNgmtbVRjFFGk3iwqLCjfGtKptwCaEUdAuVuOAyqNAtrk5gq
	/a+MVxRYbvPBQ1U8ODuM8nBBrCQIMBKc0OhTl9uxAdTgHuxhL8B/RftnTGyTq/hyGcKF1Wk2+R1
	3GWpNlepc1LQcebLU2m7F9KG2lXSeaBFN2zZJeyZRp+E0p4fwVYWaXMWGcn767kwP+R5cAcZYOs
	DwnGIsvLU6LWnsY59qw1EUxPohAmGg9F01p0zyV1GSPEHYztcxm16MoN5xpCD5kYoTtqGPAz3so
	j/5MQy12lSUTa6rVaD8kkIr9+JqSqP5TL/M+ZVT6H3NP3pEuZneRO3E+1/BRRWJmXXYuCkfbg3y
	rn7WWoHwIrjsZ9WyFVH6I3kNYbF4karwsYycU//c3nbY7f5wysoPGQpjCiMGsoTWwPb8v4/5qhf
	owe7p4v9vz62N49tH/Nnkf/NCNdc7eK77yqsD9biSTiPZBoJhhOjn2VYysFZwWvZSKTduOzYZhU
	FAK
X-Received: by 2002:a05:6512:1244:b0:5b2:aa3b:deee with SMTP id 2adb3069b0e04-5b2c1b54a62mr878564e87.35.1785059221326;
        Sun, 26 Jul 2026 02:47:01 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f22236390sm7723271fa.25.2026.07.26.02.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 02:47:00 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	urezki@gmail.com,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmalloc: fix 32-bit truncation of the area size in vread_iter()
Date: Sun, 26 Jul 2026 12:46:37 +0300
Message-ID: <20260726094637.3210-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725144834.76cd9aa557e72aa02688948f@linux-foundation.org>
References: <20260725132201.88279-1-iprintercanon@gmail.com> <20260725144834.76cd9aa557e72aa02688948f@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4263A80002
X-Stat-Signature: 649js4y78c4yrha5rqrsdqm1tuarc8kk
X-Rspam-User: 
X-HE-Tag: 1785059223-832807
X-HE-Meta: U2FsdGVkX1/htmcu4lJkQwqRjvH0PrnTmAHX3z7DVATbUGIuFVlG6zm+rghyFLsipFX3RR2BSMMm+yCbCtSDTC0muBlR+SPIQ6qzNokyTmbjSZ+Exqj3dd70VNxhBshJ1CzwrF2PzelJT4k2I2zPz2wEf44gO8mvCXNrpKLADpxxAz7RY7w4WfKomVgFP9xYSKoQXLXqw358VVXULbUL5x+bJuCTzoIfj8Je/4Yrb+JnZsyN+iduoN1hxG0BuHlV0AY/zsn0EmNF67si97sInmonXNxlaVDt2AeLsU5VfZDeYLDLQhUwODZVYercSOJPMkbRXZMDC5xQeWIRSVOyYaXXFYsnLQl4fsyL9XtEMIMIZhc8z1Y8WyqQARCL6GgpQhUow+LBxWDy9JpgcsPEMLjY6MAb86ALSxpTjIvTXTTdsa7Q2B7upxmZ3TIVJhsur/n5UcdN3lPEOzXjpG1WIqmbj0rQcLIWHCeCCTrpy7EMRbCFyGGWXzgLVcp4L28oKV+9JpmLNjz4OwDoXRZlBmzMSpXIDYxsmlksi8EepTBQC6hy+eJE6nGacpHiR6ZQLSyx06MIXKRyynNgKszfN33J72RKDCipAfOLtYSxORtJwkJv5+/wKit01cB7Cvu8NnPdYGFj1phTmV5PtrF/x1yhDSu9o65tXPsBQ20VeU5Ii6IDwHS+bkF3eCe7SY33oRGhME0Isqq6J4zJWytIUN2JSUaXuLygMPgMMTqh5hD9PrqEpGjiC8XaLSysbRqxNvVLm5PqSeGR7EufCYvhtw/nQIbdv09EmnmfeM2S88fSdP/TyhFlfXj5cBa79ASJVo7XcFcJbT+etz45TSAtSGw7/SwqVN/cXanueVeU3copX0qs28MtwottFAIHCpzbYMdcHrUZrv/DUg1uX7pJHPowUHNPm0pdrg5WqwfcQbrvgexgHFPEdi1VO5PoeUxj3ExNl6xcklWcA+pTWeM
 KToXVQ1h
 md2+QaLb+4dp6YCp+EygBMSuJaNl1XTFKFBrL/87XPGZLQovyf6cB+axcsGdNbJrm+/0pbCk7h7NRgHdnGJbAHh8cm8nWoK+exHNqs4lIf7DBH4D1aEErsIl9mlt+JhzC+EWrbuXLaY3fjVUqTDPbU3DayfX+GY06n2AQ1VObeYqys/36t2Jrc+Ou+jRWdyjv+fU3m+rsElev38gfGw12iYlK6+pAMg7DF9OF1m69KnpTtu8bic3h17cFyNX/06q4/Ce2O2ulHJy09gAoKSqq1ZC/23jluxQJC+ZIGQA3iSgKKK7WXG0B4nwhPB57pOIHoRy4LJXeu+jGM1nvvwY6Su8dIopF1oQxEa9npB/+3JDk42j9iM4Xkc7Lq9EoWEfsZ1Hy8VQJ8+E0VkZDZvO2zuskYmWbVs9+/KwYtoIxpbyGPCfCkhaVn70nzCu886+4RBRg6Cl1v4+O/LTXZscccHSMSqwhKsVonfHgakVtgHI6jupi2hbDiQbf7ksj078BGRxjrI3tO7E5RayH/FS2wxci2u9ag7W+Va4xdA+/aR3pTPt7C+0GsTegoc8MHXqiTTW9G4ySKtz6Yfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Jul 2026 14:48:34 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I wonder how much of this stuff would go away if we were to make
> vm_struct.nr_pages an unsigned long?  It's already using 64 bits in the
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=n case.

All the casts, and it's free.

sizeof(struct vm_struct) is 72 today either way. As unsigned long it
stays 72 with HUGE_VMALLOC=n, the 4 byte hole before phys_addr takes it,
and goes to 80 with =y where page_order and nr_pages share a slot. Both
land in kmalloc-96, which is what __get_vm_area_node() allocates from, so
nothing really grows.

That kills both casts here plus the four in vrealloc_node_align_noprof(),
as long as new_nr_pages and old_nr_pages get widened with it. Nothing
outside mm/vmalloc.c needs touching.

It doesn't get all the narrowing though: vm_area_alloc_pages() still
takes and returns unsigned int, nr_small_pages is its own local off size,
"pages=%d" wants %lu, and show_numa_info() uses one unsigned int for both
the page index and the node id.

I'd rather not fold that in here, 1/2 is the kcore regression and the bit
worth backporting. I'll send the widening on top with all of the above in
it.

As for the findings: the vrealloc truncation is 4418, which is 2/2 here,
and there's nothing else narrow left in that function.

nr_small_pages is real but needs more than 16 TiB of RAM, since
__vmalloc_node_range_noprof() checks size >> PAGE_SHIFT against
totalram_pages() first, and I couldn't find a caller allocating that much
in one go. Fixing it alone buys nothing while the other counts are 32
bit, so it goes in the widening patch.

The __GFP_ZERO one I don't think is a bug. The shrink path zeroes when
want_init_on_free() or want_init_on_alloc() is set, and the kerneldoc
already requires callers passing __GFP_ZERO to pass it on every call.

Thanks,
Artem

