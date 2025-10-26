Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB857CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2734B8000C; Sun, 26 Oct 2025 18:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B7F8000A; Sun, 26 Oct 2025 18:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160F38000C; Sun, 26 Oct 2025 18:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 028138000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:29:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E6EC12A361
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:29:27 +0000 (UTC)
X-FDA: 84041707974.10.0C82E19
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id BCA91100003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:29:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=szklzdl3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3w6D-aAgKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3w6D-aAgKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761517765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66iqL1wQDJrMjUMimUYRUQT7RhtIF8bdulrGmkclbmU=;
	b=QWqJeGK/vK9LeYrcoAPVvXncX4K1kTJEArcm93RbRhtyB9ctUKhnoGPDN9a5tWQX0Nxt5+
	PefTjRFG+mh42lrX4lzgGPQ8gJWJEhVjovKbw5yCzdpy9hFtFhp/+YIAuJdFIr7ers6nej
	Z5UxWotTTTGi0vgfxipnh30a0idzVQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761517765; a=rsa-sha256;
	cv=none;
	b=PiZ7HRcdIdeJg/H6NUvhB/PtG49G/TnJX+/LqCueu0+2FwJ0leVOJUvLQQRTz9EBbWyJHj
	w5sAz4Vkfk6HwFIOGFqveV+88bk1GKzaIuU7Dfjjwj3PcpPi54j50vuF4Ff8+2ewDw1192
	2tRdhxBVK2lloZVOhZjn6VOIsMIWj1k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=szklzdl3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3w6D-aAgKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3w6D-aAgKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-63c588cb6d5so261947a12.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761517764; x=1762122564; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=66iqL1wQDJrMjUMimUYRUQT7RhtIF8bdulrGmkclbmU=;
        b=szklzdl3md/mikuFV8bd2jq44d93L78LZDpGRBlYOdO0rhQUeu+1aCAInxirTkhZEY
         jrCgNSL5WpJdS+rBfs+VPGFRUloZVJol7PC8PcXgijlByh9Sp5fGD3KDJtx/M6QOk2hf
         3sGBrgqlfUhF5A/zZCKxlAXuIevGtIR7IZR6xpeVIO1lWgOquzGWWKjA7yanJe9rtFj/
         w7Zf+ddSsHoYl+JCtQ7C+CLx9MZyhTMAPsx0DcPRE0GueTAmFY3C/K2R7gNU87Fd7u1B
         eCUVYCD0ZvG8wtRn6sv99YuPpDCh8WWGhVAFVIZ+MahQYt9JTDh7bKdKAubWMRcotJzw
         16LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761517764; x=1762122564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66iqL1wQDJrMjUMimUYRUQT7RhtIF8bdulrGmkclbmU=;
        b=G1qNEBC5ZLE0tJ/FixZddav4iPu9SXTFmtfxJgUpzfe3Pscxk4R07iZkKX1fGV9kYn
         EcYUUEmJ/9xl5JL0EWExp/cefdjfVBQs2t0UhNBAAjX0ZpYxrYv3O2sbcwOMDOu8ANJV
         fQTqSyXJfGVy9frqemenhCvAfoK5oGcK3hec1OJIb3Wm3EZEM69OnVIY2NKcDSZuvhtd
         u6xTOOgn2DTeY6CUhAyccgjnRBZq5fqRGbS+3fam6gzUMrqikfwKaY608FGiTdrk5ilC
         SnW7lvMmukeL7ooepWSMwkZZsXkEr1ZwZNxkNOZffK8lxErGeluUr8FOdeAUXGatTqj9
         V5QA==
X-Forwarded-Encrypted: i=1; AJvYcCVu1UiEsf4Ef3sAMj4cRkRtDijdXMVq4hsvagu1ghvbwBf6Ii0JEqnyjKPnen8AhL0pGNuRrUCUfw==@kvack.org
X-Gm-Message-State: AOJu0YwXMsqCt/G5f6U4GTj0OeGuAHg4NIQAjy1ADuppH/XFtRYftHYD
	SpT9eMgWqXrQQCOuS5vRCPMDWWxS6XOrOqTRf7tzDzB11Mtapd/FBCAMCtz30jYH1m4zHjS3yVp
	1TupancBhIm6B6g==
X-Google-Smtp-Source: AGHT+IEFiLJX44hMWNXHZC3Aih1gij7lk8DQBXxxJ2bwgJL5TDkN/S5/hEJ472CJdxkQKTEOJdcGAy+su2hzzQ==
X-Received: from edf6.prod.google.com ([2002:a05:6402:21c6:b0:639:c8c6:de62])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:26d1:b0:63e:14c2:2818 with SMTP id 4fb4d7f45d1cf-63e14c22f06mr15645925a12.17.1761517763982;
 Sun, 26 Oct 2025 15:29:23 -0700 (PDT)
Date: Sun, 26 Oct 2025 22:29:23 +0000
In-Reply-To: <20251025114801.GWaPy48dhlZ_EVoqKi@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com> <20251025114801.GWaPy48dhlZ_EVoqKi@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DDSLXKU87HTE.G0XUZ5BG5M8K@google.com>
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BCA91100003
X-Rspamd-Server: rspam02
X-Stat-Signature: 6ywe4enmhwron45adigo9nbmjtdt1c7k
X-HE-Tag: 1761517765-542342
X-HE-Meta: U2FsdGVkX1+mbYQy5aqXLFmZcPgkq2cwlMAmA6yM/SUizTumQaR3ZfOPoF2oKIsR0/7SvGo2CsOjvMVdBkSJHgHDZrGHiitw9u0qjddyr+ICGtRYe5FJHHaOQkM+V0KkitIlyu8mJ7UUsm8ZAUBBfCq4NQcTOopXo5sU/BK9O+yC/gvw4F1SOFVXdEx31Zyw4csIWgT0CbFnCMMCKIwWtHKyVFVbWKxBPmBsqPWNX7mDquOLNJaGVFfs9JYhS5ASepjm0xn+rkml1lq7Vsfrx2NCWY+KXHwmjTnhnG/uLF7yWC8GHTsnTCp5AdHOvtVcc/eA+r3dCIKExBUb6tVj/NTENFnDkb9jXIsci7EK9MHxqYjkwdRFH1KUyl8acR+DI/ROr63mmsn4zVzNg7XUn3IdnOPN9YCAPfLk454/Q55VJJwiZ3OkfaCc2ovAUP6HcLSi1IGb83QdCAJW/mV6C0w95nLaUhB+4EzykvpE5kkW1gDalRKOpSr65KpnD7hNH0oY9HYkL/ldMxOzDDiW6RGGe9l/wmuc18/fJCLqLjPz9yKAjwX7hwaEn+LWg+q6rVkvi2qhsZ51FPJwnU/kWWwCyLGakgRNXNkv0rycfH1eknjLKR5oK+hYAnB1AXhCNT89LQLoR8yRi3B1diuLkCxOonZbH2fhlklSFJgvq88W8x1yuIYzE18MQ8Kxh5OYUZz0gZiHzx/0++eHRNRogOppsE+BAzonhwALGPfKF1LW62+R30OadufxedVjWvOoO6kfeqsYXWRhzyyHc/DZjFx4dgK3At9IhbdZkKhYF5uZ6IIVnSxsHSLx/15eTBkO7AMLh9idy6w833E8OadWxU2kBC1koU6kXTcjETecR0ayGqsoWHW7+zG3SJTPkBU2/MQcODnHT5o+YmNi4elx9zFfHB3UBnhAsQ1745Zzr6DzgwHmtzKc75M4bwvSFSyNIwVGdQHqcwPfmKwKWp/
 8ertw4Ey
 Ghdqc8kuDg7oosSUzkSOnMhxoQ5rNrQu6rtjPeiWoFDESiFDucsfh/xQ5VyK3xNoBF3yp6MSinEKzwrBEDUZDOqfm8V672+EyJ8nkFiJX2VYJrk+t3ChEWyZqHnp9omMbUQehS3f2sZzi85Z5ytPCPoXggTFQeu7K0nZv15/o+KvM37PjwtOe3nMYah4AesDZT/1RdxQA0B6ljX7BN8CILCuwcK9gfwNeBaoljttgj7/9t0rv4KQ/HcpX/FS2FGAaKvGkN+p4sG+scS2K5hwEn4yxECt6LydwBsU7uTXxhaXdsxkSOS62mBAjgcS/4QOLvwxkhseMd1gDhUE9pARvfYQ5H1M2OE54BMzfSR66P0nfu+dkDzXB7uTC8FSVGXJuf57KF+Xo4gyiyKtu2BhGX5rVPzY5XkIKUn5bsSqAKJP9aOiBgL5c/+l2dOX2W/2RxdLnp6Vmxh1o582FR71wR8nZ7aM57a567gkdDCWcmZNav3ce5vWQV1NRTwbo3XOnkUuDHgfQ6ZnM/J+y/CF/DakNoHBWsgwVzebe87ng03R1RYQrsg8O74n68kve+8RWO4reAL3SgscJKxbF0+oM8mV7T3D79eV3iSUwpErBdoONEw1j8azPw6he0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Oct 25, 2025 at 11:48 AM UTC, Borislav Petkov wrote:
> On Wed, Sep 24, 2025 at 02:59:38PM +0000, Brendan Jackman wrote:
>> +static unsigned long __meminit
>> +__kernel_physical_mapping_init(unsigned long paddr_start,
>> +			       unsigned long paddr_end,
>> +			       unsigned long page_size_mask,
>> +			       pgprot_t prot, bool init)
>> +{
>> +	bool pgd_changed;
>
> I have to say, that pgd_changed is yuck but I don't have a better idea and
> this has happened a long time ago anyway.
>
> How about you have the caller pass in false:
>
> 	bool pgd_changed = false;
>
> and then callee sets it to true when it does so?

Sure.

Per Dave's feedback I am still slightly hopeful I can find a way to
come in and refactor this code so that it's gets cleaner for you guys
and then ASI becomes a natural addition. So far I don't come up with
anything in init_64.c but I'm still planning to stare at set_memory.c a
while longer and see if anything comes to mind. So maybe we'll be able
to reduce the yuck factor a bit.

>> +	unsigned long paddr_last;
>
> The tip-tree preferred ordering of variable declarations at the
> beginning of a function is reverse fir tree order::
>
> 	struct long_struct_name *descriptive_name;
> 	unsigned long foo, bar;
> 	unsigned int tmp;
> 	int ret;
>
> The above is faster to parse than the reverse ordering::
>
> 	int ret;
> 	unsigned int tmp;
> 	unsigned long foo, bar;
> 	struct long_struct_name *descriptive_name;
>
> And even more so than random ordering::
>
> 	unsigned long foo, bar;
> 	int ret;
> 	struct long_struct_name *descriptive_name;
> 	unsigned int tmp;

Ack

>> +
>> +	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
>> +				   prot, init, &pgd_changed);
>> +	if (pgd_changed)
>> +		sync_global_pgds((unsigned long)__va(paddr_start),
>> +				 (unsigned long)__va(paddr_end) - 1);
>> +
>> +	return paddr_last;
>> +}
>>  
>>  /*
>>   * Create page table mapping for the physical memory for specific physical
>> 
>> -- 
>> 2.50.1
>> 


