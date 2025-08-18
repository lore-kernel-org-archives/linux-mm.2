Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527E9CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C938E003F; Mon, 18 Aug 2025 08:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C743E8E000D; Mon, 18 Aug 2025 08:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B631D8E003F; Mon, 18 Aug 2025 08:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4A308E000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:54:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43A7E138CD6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:54:37 +0000 (UTC)
X-FDA: 83789872194.10.9F922FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9592160008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:54:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGhAOf4s;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755521674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSfQdikloqcDL9542CPxmBCkUvXeLc4c3xxgRGWoAUo=;
	b=mIAZLR3vxe2+ZKEpo5U1sW8ePaocDmtlVetcMqMaBYsxa4yMlXClytKp9SaKVmU/4zpZZX
	G1RIVZuvKdg2eSbbQpwQFG4z/a9lew4TtDXdxEGk4c1g67+Gq73Z32BeVPTAxbdSYHbQNV
	eBJUorLXYo4FER3rbkf2MA2y8LAfEI4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGhAOf4s;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755521674; a=rsa-sha256;
	cv=none;
	b=wbf5BW01kZr1jiHXj+y524fYemCBlN+wNkh4geZYiyphECRxEZQNWyps8R+F+dMSigoak9
	nPWBR0eADLyZ0vwbRqvRR1ZiyzDJ5kIJlg0+wXyMS0BLSKMlb4xN8A9YWHq3ErsKtc9Ppr
	SAfVgIuyJlLdTbOEi3yH0USBQlK5plk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755521674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BSfQdikloqcDL9542CPxmBCkUvXeLc4c3xxgRGWoAUo=;
	b=iGhAOf4szbTkosY1M+gX3MsIOcf9Jx+wrGdrEBkyPdVgOuyhsGqa48pTAcrVudVDpOW5m9
	qDYhE+P9o4iXGcd2vmDmDh9VYlP7uHRxImlHbSmB4m0TUq795ZurSwG6U+IJbQcl/t7iJY
	jBLT7L61bE72v1EFD3c4HhaJN23GKzg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-abdDFQaqNgWMNUhS_8MSng-1; Mon, 18 Aug 2025 08:54:32 -0400
X-MC-Unique: abdDFQaqNgWMNUhS_8MSng-1
X-Mimecast-MFC-AGG-ID: abdDFQaqNgWMNUhS_8MSng_1755521672
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc5c2820so1378406f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:54:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755521672; x=1756126472;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BSfQdikloqcDL9542CPxmBCkUvXeLc4c3xxgRGWoAUo=;
        b=Okgrrc6ThGg97NtyvYSIq1IGeflwIai8u0jB6uTHV7/bGZRLDp9VRkXRRLM8G4fX+5
         y2bHNqy8RPt8wwgNaoWVVTnEyA0NtI8r/QXytNd4ESjPLTltWEZh2e19nzLMlfSDUUlA
         qT/jPWdCeUz3BTqdoX+dZmxxD1QG8yuBpUFAm0A75wEBIinrw5Kudei5KGLBqPhli35P
         dEYfylxefYhe8kx2E/pyIKe+KZKoSsfIhOtJmh63wdDS0lncVSgBaiOtwn9oCp7Kr/Bk
         OblkXgpmZlD+Ba1Uq3bp6XfoorXEPBTJpMRpj/Aeanxq5EodKGdTFxuVyokRXkN1t7Oe
         nVXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDaG0vaDPVnVyKwy/ZZdBnQdqjIcHDOu5rBgnMg+oMRDVY9mqIOGkcmkdhyQ0UmYsL6XorNZcgUQ==@kvack.org
X-Gm-Message-State: AOJu0YwjKPqflKzZ6X3nrkvxC0Jb+xZfZdI2QKSKJPhuEppetiAcCQeq
	zzCDCOmwEf2mttI077T+YJAWt9yVUKcgUn/etot05+MlpHp7F2BPy2xR+QMjEw7ZEVVdmUu2j8Q
	9sT2uO5Gd59AGPzIMTNvH3azdWE6Uav9x3PS7efkEIzthqUokxyzF
X-Gm-Gg: ASbGncsl/xGhrhgzwJ/TjSEjlZLFjPEptuqHhP4IEL7JKeW1REFczcD/eTgkzNDS5FM
	mClzDm5ECAKn9CFJs65JxthCr6R2XhqFVJ2YEYNO1a4WtQZcgvZQ1Wkvzhl4y0nMnqX7uUJVM82
	G4zhfEyYzlGfOrwZ/IBbSmPzYMEFBw8bKoOG0bvF7rzlP+lcppQHp1aPhL1EM5QXgEjQkQx0G6o
	xbUbmeKA86jlpLpz6pwVkeCmSaXUjjWgtoJN9gKb+MhEetAQl8FKGha9vXlyzkOg/4WpGeY6aql
	+5rfA5ha7fwcosaQGk91xyidCeRS5lnCG0Qu38ofzfiCwP6FiqCdJWUPJdnGJqsGzSmGTCzsQ8j
	O9znQgofVN4JQSweKnnhKrMo9nk/MP23BKQiZWQUwdgKgGsvuK8C1dSKmshkL3F6s
X-Received: by 2002:a05:6000:2002:b0:3b8:d79a:6a35 with SMTP id ffacd0b85a97d-3bb66e16f8amr9053936f8f.20.1755521671608;
        Mon, 18 Aug 2025 05:54:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoBXhfwxqv95/4yHVjpurPEyJagTWHd/HzfhJfFuUekvtXBYgU5MmLe7RX24srAW0Lf5onsA==
X-Received: by 2002:a05:6000:2002:b0:3b8:d79a:6a35 with SMTP id ffacd0b85a97d-3bb66e16f8amr9053910f8f.20.1755521671102;
        Mon, 18 Aug 2025 05:54:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758463sm12795586f8f.4.2025.08.18.05.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 05:54:30 -0700 (PDT)
Message-ID: <6bd5ffe2-8f28-497e-9092-085e5d1cbc1f@redhat.com>
Date: Mon, 18 Aug 2025 14:54:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
To: Harry Yoo <harry.yoo@oracle.com>,
 syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>,
 Peter Xu <peterx@redhat.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
 Ryan Roberts <ryan.roberts@arm.com>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
References: <689bb893.050a0220.7f033.013a.GAE@google.com>
 <aJyDAX8bHZCp93Dq@hyeyoo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aJyDAX8bHZCp93Dq@hyeyoo>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: 8x9veQaY1k0pSkkzanLTuGc4JxznKyW-vZudn56OY1s_1755521672
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9592160008
X-Stat-Signature: nd1787nkbcqfrizn839m376h7keh7u7t
X-Rspam-User: 
X-HE-Tag: 1755521674-821502
X-HE-Meta: U2FsdGVkX19iZqHmZg3CUM6ydNoku5Ojc+zOPQ69Cdz3Jw2E5Iui8C8RPzvBcxViLruVp5+rw56E76ej63yipdPvubGJLNTibG5Se3uUnGMrEgnNuC+CJ43OBOyrD4dtiEkekk0fTnFecfbCYrAIokjbzury5E17dDLQoSLw6ito9QgAesnvoA/7Hiu+59YxjtV6jTByHIJ9Ujo6pOyPCO3CrBIYdRvvCt0++dDgLnuMqO1Ds3UYvdVH0CO0FrBZhnYlJ4Vd/rNoW/qRssK3X0DQXSTY1A+GIAAlheL2QMcrE1au4vrzRuVUV6N4HPqggnCws1ABSRv4CJFUnnkxzZZfj+SSKTLEBAPg5RsR5P/izlfv7GXIBYEdVbrzBHHCEdDzwVZzEm9eLmhsZH2i41rspLeEkxyU1S7JGnStvvPDfA57YKVwQIIaYp5e7yueA93Qu9NN9p7DXSRM8XwTmmZdJOOc4rE/5/Fv8qY0UlYMxQW+4A/nPyBWaiy8rGIlalgrU04xsf/MOgCprqVYthQbHMNMAhwHdPNvY0lIBbzihz/5mfXEUAMlkGpbsj2ZQ6I450b9VL1bGuNsj6kW6nNJyQV1j5Y1tUbTP5hPI2dCi/CZXvqVLZolhhamrryw5tcAQxdby8uOmdYUitM15bphwLTeJUeapxDTwzwS8rJCohGVb7eUfwmQKmzgwNOqW2pr7uwEJDhs8SusSQyvSVXzUf/lWw2Iu8E4z0K2ELv+ESuZ5W/ZyIw4XrsBEjIM0sujPpxZiKBaZSG2ngWZ410iegXu/ZN5beoc7yDxORrYH5urKCyHH3RBYoPYJGlbOPSOCx1LpqDSS0Lk7UJ+GCqNtqAE30pwyIAoPOZtG2gXmnhL1Afl5aFeN58GhDiWM68egnLGj0L2FDin9gE2UkabaG5GdfkUhZJb68J2vtRi7RYxtt/uL7xuiL1a5VTRNFLYbvnp6uIVtEUcVMq
 vcuV1UKq
 pNcEySkIlMHkE3eFl8ZN5gkIj8Bm70wF1rR3kHRbl8ZIQ7IfybusumNtVJaTJr76FukbZWhVc3tJELvgtoYBnurRKbkOOv4DqwNwRTPibOiL60NSilTTWq8RiAHrhNITtIqckwZyK8smIrkhjUiKVYbSbg/vIToZhPpEBAtrMmAJom48reLwhvEpqTisYUJQ+fKxqaTp9LD5B11EBhUkXtVWKrWFhbZJk3cbzi40DKSIif/sH7jZx12lbIFEVrbgmJc0kaBefvSkUMtCGUilYWiHZ4uDDGSbAQH0ZjHVDoB+BIq6FJeHYy5EjrwqYQljgSVjmi06tfnkt5pSDVyVTT0Dzbl2YMsE+giVNyoLwrNv19r/0xT+JfSzRkSPaig9uEMnNapjYndDtne4DguJI7yb3hr/CaZ9peO6BOJrDfkcSQqtWKegJAkEAON2rx8kWPazNv2DQj8CE72/mp/5oF6UXDcF1dNPY+zBWLdsx62UJP+doU1EfEOmdUq5TSkbTwpyNo33PHdqKGEAYrf023Y7SowAKBsEKu7WaeW+qQ5jQYgKV0lWqcGSR38rmn08KQOlLngh850swpmk78FLFuw5URPBZgcJPy5pIGhXSbwGTrHTFCROxZZfknfujk0Acbaj9G42LtoD1zsvMBZHJF3NUiP0yjpWoK1wrgYx5++giPMeTwJwzlEJMq4GqmumYUT8dhSKCKAfXOOXgAwm4/Kl2eT1rThTjfMTFoGL94fDXLtAS+uyQAeM0Q/S9UBEL3ywp1xv37zRpXKJe0r95UIWh7VR2haxoF6d982p/iBy+iHIDQe0suWRmqPI19Bw5s4I2TmWpxOy4EWjw35iLZlli28ygiDdTJQAfP98frOx4fVt/yCn1AGvXbdVrY0HAq6yYjBTrmt56YKpNHVRW1+HQtr8/pTqwm75JNuULFjWbFUUmg3lILD1EMyIDlTom5bmp/JCTqd9UTUB6b9p/MO3c2smd
 4SVyhUFV
 nnFNowUfkRReQpTPqhCtbLJ7tHDYPCl6P+t9EMEXV6QQ/DAHoFVPZFuAwIcjRvnvssB6kXtVTJBxS/zBxmbdawf+rM5fT74onhN+JFzADlo00YW45NqqseKw0u24eBg6cHU8EYSJfWgwvdfrt4wj17I973wvfB9K4yEVwnww8tE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.08.25 14:20, Harry Yoo wrote:
> On Tue, Aug 12, 2025 at 02:56:35PM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    53e760d89498 Merge tag 'nfsd-6.17-1' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=165fe9a2580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=f9319a42cfb3bf57
>> dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14172842580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b04c34580000
>>
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-53e760d8.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/584b4139c7e3/vmlinux-53e760d8.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/4d2474607300/bzImage-53e760d8.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
> 
> [Cc'ing Ryan, Mikołaj, David and Peter]
> 
> I was able to reliably reproduce this (with the reproducer provided
> by syzbot) and performed bisection.
> 
> The first bad commit is 0cef0bb836e mm: clear uffd-wp PTE/PMD state on
> mremap(), which was introduced in v6.13.
> 


Okay, so we're hitting the

	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
		return false;

in move_normal_pmd().

Given that the reproducer involves allocation fault injection during move_page_tables(),
I assume we run into this warning when we are trying to restore our previous state,
so when we call move_page_tables() the
second time from copy_vma_and_data().

Something when moving stuff back after a failed PTE table allocation is broken.


Ah, maybe I know what happens.

When we move the first time, we check "vma_has_uffd_without_event_remap(orig_vma)"
and see that "yes, this thing has uffd" and decide to move PTE level

When we move back, we check "vma_has_uffd_without_event_remap(new_vma)" and see
that "no, this thing does not have uffd" and decide to move PMD level.

But the original PTE table is still there ...

As a side-note: It's confusing to call vma_has_uffd_without_event_remap() to make
a decision during mremap to handle WP, when WP might not even be active.
We should likely slap in a uffd-wp check on the VMA as a follow-up cleanup.

#syz test

diff --git a/mm/mremap.c b/mm/mremap.c
index 33b642076205d..a9730f4373b77 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -323,6 +323,26 @@ static inline bool arch_supports_page_table_move(void)
  }
  #endif
  
+static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
+{
+	/*
+	 * If we are moving VMAs that have uffd-wp registered but with
+	 * remap events disabled (new VMA will not be registered with uffd), we
+	 * need to ensure that the uffd-wp state is cleared from all pgtables.
+	 * This means recursing into lower page tables in move_page_tables().
+	 *
+	 * We setup the uffd-wp context on the new VMA after moving the page
+	 * tables succeeded, so checking the old VMA looks reasonable. However,
+	 * when we have to recover from a failed page table move attempt, we
+	 * get called with inverse VMAs. Recursing into lower page tables during
+	 * the original move but not during the recovery move will cause
+	 * trouble, because we run into already-existing page tables during
+	 * the recovery phase. Consequently, check both VMAs.
+	 */
+	return !vma_has_uffd_without_event_remap(pmc->old) &&
+	       !vma_has_uffd_without_event_remap(pmc->new);
+}
+
  #ifdef CONFIG_HAVE_MOVE_PMD
  static bool move_normal_pmd(struct pagetable_move_control *pmc,
  			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -335,6 +355,8 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
  
  	if (!arch_supports_page_table_move())
  		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
  	/*
  	 * The destination pmd shouldn't be established, free_pgtables()
  	 * should have released it.
@@ -361,15 +383,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
  	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
  		return false;
  
-	/* If this pmd belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
  	/*
  	 * We don't have to worry about the ordering of src and dst
  	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -418,6 +431,8 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
  
  	if (!arch_supports_page_table_move())
  		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
  	/*
  	 * The destination pud shouldn't be established, free_pgtables()
  	 * should have released it.
@@ -425,15 +440,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
  	if (WARN_ON_ONCE(!pud_none(*new_pud)))
  		return false;
  
-	/* If this pud belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
  	/*
  	 * We don't have to worry about the ordering of src and dst
  	 * ptlocks because exclusive mmap_lock prevents deadlock.
-- 
2.50.1

-- 
Cheers

David / dhildenb


