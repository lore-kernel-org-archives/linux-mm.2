Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 058F9F357D5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0514D6B0088; Wed, 25 Feb 2026 02:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41596B008A; Wed, 25 Feb 2026 02:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEFD6B008C; Wed, 25 Feb 2026 02:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8F1C6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:31:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D9DE8B682
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:31:28 +0000 (UTC)
X-FDA: 84482158656.15.717C810
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6E73B40003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:31:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yf6uATsK;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772004686; a=rsa-sha256;
	cv=pass;
	b=NT2cb2rXWZRx+RAUc00byYyaSYWTR/rtz5DVkaj6/xib6Q66dZfztRHglyBOXvmzMSpV1Q
	hSwg1D18QP1d0rsCj5Qys+FoaxyXo2LM0IYpJBxnV49+is1EY97RqHiIRntccbFiVNrpSr
	LwpExA4YWZbhEY63CGS3tg+KA5E89W8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yf6uATsK;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
	b=0nd7rKCVlVi/7d2TmUHbLWoLLo6YnCkx15irss7kwB4wWgdVBm8+AUgOefH22Sd3OL23PH
	RWrQVgC3sSnBOrY9gXqQu7964KDshscI53DWP9/b2sO0IAcyrWPEroNzP8Cmum792A2Oez
	dzryJ0tXvXG82kgpt3HK7ZY9XiL9Nqc=
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-94dd01deb53so495970241.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772004685; cv=none;
        d=google.com; s=arc-20240605;
        b=Y6Y0r16SyOMuFjGZZBBFLVu/En/wSaTQUE5Vb4+l5H8bU8DuzoyIhm6A08/kNLRrMf
         b45fVISx1tMlNcuT+Lj++yEuD2stKDfkgOF5o2dVdHsKZj3pdaNJYIzG6Pe0rUy8n9T5
         zDOnZbnVqqbTMP2qsV/irvGtUaczuiU3+8fOraVVoSFZs6HUOg/6VAT/Ch32euhr2MC6
         j4dPiz9Uas1ZGjBMQAbfcQGwEIOTrNsPa/Urw+mMGo4HeqdPUYtgt7z6Gb0Lc2RqFLBg
         T2jg525IqB/rtJV5DzOUczfyW+J6DPlspfpIlPUytl7ULzcuSjcp4hHeVqRjLMgfWMnH
         C42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        fh=7rYowq3j91+3U4Riw341CT7jc8FiwyupCFCv2xcyxUw=;
        b=fW8WwAcnb3ujZO4AWpFoRiXVTgZPKQOULpqgm2NcN9Q10YHrk161y1IgqIDutl8o02
         uvxCLRA+gZNpaztrOpJoXVh4RhBl+A9t2xS/o/Tn/dkRN6KGMyLVju315sRUmgk+qhDG
         7Y+eQRSpe6qWXSRleEOWI8Bsm0hMK0xK85c/WlNJ8FpHKICIlrMjlOENSyBqfwyxI3A6
         HoZcBM3qnT2YeIBBuv9G2kyhe8+hHpGQ0hS7/JbXJJJGF6ZTDBwJsjnQVXKF1Kk1xMsZ
         8x5XoPMHF+Je5TnzhTqOfYbkEozZ2+ZPJ1XRXp7iGsXPRSuRBywVJCDHxhmAMhDY8mzr
         yHjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004685; x=1772609485; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        b=Yf6uATsKesiqGywtks6tOMzK7hVRbH4cSY0RADfT02TuQxlpk/dUvXny1B7ghdTmbV
         WnJKmyjhJ/f6fGb0KEqGFlXHTUkKbCJH/rjne31Hw3TCRRO+v1imaZ4HizWD+5Zwc2cs
         eayrLdsTQrdYMaA/UmeeEeVcDCBPxYQPkAXD4EXac5fWlOGvLNSNO0Syur1FlwShmJse
         qdPbD44kCUBKsxE3z5MgV61BN8sSAJwFSq2PSSdtUIgvvRWQ1VdvALySZAk91fC+ivz8
         E1i0nzAxU2CKu5LjJZTcOFWEpp/mQVSS92f1K0yejPtcPfV0aFvYy5Stus27VE1ShZdj
         6T1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004685; x=1772609485;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XX8b+rtVnqMMtNp/ESqgVDIfe5eqIi9YcNK6m86bxSc=;
        b=xM72W6av1vcYX5IgTH82P6NjUWJO5vI0oKYnJSLknXvFTTcXd6uTyzCa4rn7v+GW+u
         YBNvB1zYjGY7SGi8ifeMfEdKcEeqasIpzQiSIa4u3HXA7xZtJ5ThdknDIyI02LfgE9eO
         E5sOYWQgTdS6LEvWZ609beFMFIWCcIclfjSdYRGDDheectr7lzoDVUz6cIc5vc/ZDeEI
         sjo6ZEyeeZH5dSQvmzgDG+yJMTWCZN6LISjYxtz6+LV4r7q2ehSWvCK9uoGh32f4ZdRv
         hvfZxjy7QmytSfSWdyQOTTic8kaZTYGmZ4zEcRWcmYen5JqzP94vyMY0O6L+53Dg8awL
         7/uA==
X-Forwarded-Encrypted: i=1; AJvYcCVM2Jf0sQn2aoWyODlg949mfqMrvbcR4+mHv+SScWXn7gGai9iJLoFQERuv+PsKbjjhq7LrP3W5rw==@kvack.org
X-Gm-Message-State: AOJu0Yzxcjp06CtyHmQ8Q7AnLhvw7Yl+q65mOCNAkxfnwsCqTwIHx2s1
	rt2fAUyLDifeDVakgXUDIofoTk0rby0mi7XyxetAoxrjsbygf4iJQO2xABHY5avoPkEhLmYZ5ch
	+KWNPDg0tiV7m9Fkmib/MBRNnZDvqZZ3tJidpAyge
X-Gm-Gg: ATEYQzz/h6fQGyXPcqL9EANKxWOI2gU6pZXLtC410tjGr2EUQh3Sd4EUqgsmcZNqH2i
	JNu0jt7tsvIXBBTahXhtUNv1GvnxY9jWpU0IMQB+T6j3mzSomPCTiXGvsXq5qdk5HO/NgWai6uW
	3Fn7dy5lWs3G36haT8WEYiMN3iaXd1DLt940mzeZ6Pa7o6puQkzlxg0RSS7SED2qjWUww2LGCSh
	vgLrGFiNlmLZiHbLRSYQedtWrVHTxXvBRoRHZ6SX0vKNUgO7SQXxNk6KIsU4wOJwnuZC1L+lQTm
	Mq8GrNr4k/+gOz61o/nb8TpkYNey05HGAPISltKan8QzWtnplzGz0f04KlfDWOUOM/8Akg==
X-Received: by 2002:a05:6102:3e84:b0:5dd:89af:459b with SMTP id
 ada2fe7eead31-5ff05d62336mr520728137.7.1772004684941; Tue, 24 Feb 2026
 23:31:24 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 23:31:24 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 23:31:23 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com>
 <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org> <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 23:31:23 -0800
X-Gm-Features: AaiRm51zoZaexsL8AgLT-NSu-LX5kDXX-7Kv8iZiX_RuOJxbA-22InSuIouRjL8
Message-ID: <CAEvNRgFyRsqhv7CuuDARHTFSanzOHaudM6JMBLwxDwsrjTNCGQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gdft9pjujoib8u4ycondojbb71xpicpc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E73B40003
X-HE-Tag: 1772004686-575020
X-HE-Meta: U2FsdGVkX1/3pRqZHFLz8Yixcw62E73vAwEhLdzjxHrj//pRW95kXmLnp1yWZZZIBR2NRwyTO2hMPARaFg0KXJH37yagah0keXqhX+Dl/vWFAmla+EEScM4BqoRGOKiFvsMZPjlqOHWusIf6xEzVB8qYW/H34NEY1Dmr/hLrW3nnZhS/bxCT/KsNmjpb4FH+yW5ZTV8vucmYCobsZeFCtSWoRLf+8wm1DUtC4SByA6sFBBgKdVYhfrdfOQZU2QRyY0F6qKPB2ofeFSRRk0+dVJCxbRfgSYQB2WsOUHr8Q/iHAOwXZng72CcqOdrTMUtrvjmqDrB4C8g8bXQoMcN/RU0D7K4srvJ1px37AugPPsm6W9zB7gtruXWp4CrjMEB96vspwcgRkMbf2VG0S/V9ZVNbtGaSf2+TVTwZXc1QC9np12aK26Id4s341wdCvVwlghjOGuEl66VplT4A0QrtmElv3xj18n5ZOCuqoJh+q/R6R4iE4BGVCYI/PlqCfRM/cAHFueGL9wZhT/qQ3/ah0aNMuoeqNSjx7tsTigP57SaE9lmINMbr5A77jg7u5MIe676iQwApZFn+xNES7THZaA0ctmUmSzTge/rVW8tq1rmW3xEV6k84MHr8svxDPKWdExKc+BAvqqgUJTTaQ0yc6nZXr30nt2EP7CMohybXqDAME+9RLZ13aKPZ8kU0SM8ZXODZVsZtvGb/gYb2CVpN0WBl7QUjBFpVADQkxsb3Z2i17dtjE+cs5LMoppVe1n3NXS3WGacQF+x5G5hm8iJ8lrKbUidJxIhAlTYdD9U0whmDnc6rKLcn/qglVmOSh0IL4NoHUoj3sXnEL17tiiUOXu4BjslmClQM9GAyAwT929it+79+SLI4wheOgyaxIlYiO5nr2jslJMHLWH3ZjTVdJWFjSvXIyMtLmBWimZjwXV1KOeUxzrsQV3C/m0WVz9NmK7R/+JvQeWoH05rA4Uf
 seoSD6+a
 6Cud+FhmJgcRMMseTQ9c5mr3ybJJcYLQ0VcMGr3KQ48Tg1VuKevcamBAxiWXQPuW6sTnwKFyiPi15TGWhVUxFAQX+rrVom5MpRgu8Hgozi6762r6w9clbtJhBm0NoqzCvw8rUpLNrq8aEcxmH2PczC4q0UlBnAC9wsFlwrJrxGcZKIg1xGDnRoDAzdTYibvtthWX0/K7THPtDGfTOnOsDKo3Ar5bRUqcWftiZwskrin6IxPY1zq+CyilqFYHpojfoy6U16iULB+R2aTLUXncKUI+vWokGrqKfmp1SA94kDeJZ0GTr5f0RO+Ntpoi7L5aZgX/QytHC0Vk9KvP0o+HErkp/hXif5v1XajLI46Vb7KTZYUEkh7B+So/XAMe+77LviF2VjqGFWwy8kXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>
>>
>> [...snip...]
>>
>>>> Could we maybe have a
>>>> different callback (when the mapping is still guaranteed to be around)
>>>> from where we could update i_blocks on the freeing path?
>>>
>>> Do you mean that we should add a new callback to struct
>>> address_space_operations?
>>
>> If that avoids having to implement truncation completely ourselves, that might be one
>> option we could discuss, yes.
>>
>> Something like:
>>
>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>> index 7c753148af88..94f8bb81f017 100644
>> --- a/Documentation/filesystems/vfs.rst
>> +++ b/Documentation/filesystems/vfs.rst
>> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>>                 sector_t (*bmap)(struct address_space *, sector_t);
>>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>>                 bool (*release_folio)(struct folio *, gfp_t);
>> +               void (*remove_folio)(struct folio *folio);
>>                 void (*free_folio)(struct folio *);
>>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
>> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>>         its release_folio will need to ensure this.  Possibly it can
>>         clear the uptodate flag if it cannot free private data yet.
>>
>> +``remove_folio``
>> +       remove_folio is called just before the folio is removed from the
>> +       page cache in order to allow the cleanup of properties (e.g.,
>> +       accounting) that needs the address_space mapping.
>> +
>>  ``free_folio``
>>         free_folio is called once the folio is no longer visible in the
>>         page cache in order to allow the cleanup of any private data.
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 8b3dd145b25e..f7f6930977a1 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -422,6 +422,7 @@ struct address_space_operations {
>>         sector_t (*bmap)(struct address_space *, sector_t);
>>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>>         bool (*release_folio)(struct folio *, gfp_t);
>> +       void (*remove_folio)(struct folio *folio);
>>         void (*free_folio)(struct folio *folio);
>>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>>         /*
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 6cd7974d4ada..5a810eaacab2 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>>  void filemap_remove_folio(struct folio *folio)
>>  {
>>         struct address_space *mapping = folio->mapping;
>> +       void (*remove_folio)(struct folio *);
>>
>>         BUG_ON(!folio_test_locked(folio));
>> +
>> +       remove_folio = mapping->a_ops->remove_folio;
>> +       if (unlikely(remove_folio))
>> +               remove_folio(folio);
>> +
>>         spin_lock(&mapping->host->i_lock);
>>         xa_lock_irq(&mapping->i_pages);
>>         __filemap_remove_folio(folio, NULL);
>>
>
> Thanks for this suggestion, I'll try this out and send another revision.
>
>>
>> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
>> might be more controversial.
>>

I'm not sure which lock you were referring to, I hope it's not the
inode's i_lock? Why is calling the callback under lock frowned upon?

I found .remove_folio also had to be called from
delete_from_page_cache_batch() for it to work. Then I saw that both of
those functions already use filemap_unaccount_folio(), and after all,
like you said, guest_memfd will be using this callback for accounting,
so in RFC v2 [1] I used .unaccount_folio instead, and it is called under
the inode's i_lock from filemap_unaccount_folio().

[1] https://lore.kernel.org/all/20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com/T/

>> For accounting you need the above might be good enough, but I am not sure for how many
>> other use cases there might be.
>>
>> --
>> Cheers,
>>
>> David

