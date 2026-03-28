Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5145510BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CFF6B008C; Fri, 27 Mar 2026 20:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD886B0095; Fri, 27 Mar 2026 20:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC8E6B0096; Fri, 27 Mar 2026 20:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68D286B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:29:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 025BB5F509
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:29:04 +0000 (UTC)
X-FDA: 84593587050.08.04146FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA5B2C0005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:29:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FnVncGxj;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774657742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVak1OQdFi+KSbDm2i0b5emN8NsmFfdL0DbczgHqixQ=;
	b=R2HpdUgFsCPar+//q9/YbsIPkSRH7Ke6x3F0WBSIrToHp6prcgQmGo1qRwGOdeYf8UUn5g
	M6KzN0sL3dhB+jpYw/roI4KXInoCkyXkZu5YRL03OHsFMrnlPW9LRKjrjy1jQMHGBlcKmo
	pstxorLHaMAlkzHEmxIgK7b3lgIZvxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774657742; a=rsa-sha256;
	cv=none;
	b=obhvnq2Ey2rQvW4Y9stbRitksronFiH42zGytMBFos/+dfdScQolElPZ4KvFF5dLLFkbNn
	NnxLklj4UxvbNIbns1PqaMvr8X7afmjv0PaL4K8SvN3IDHsVjVM4fZ02NOdiiQuG+LxAtZ
	7qiMsjRTZegoqpzpEwS9DSBXjJhYjP8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FnVncGxj;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774657742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pVak1OQdFi+KSbDm2i0b5emN8NsmFfdL0DbczgHqixQ=;
	b=FnVncGxjmlP/K9CEoi9U8iePkpgFbzrE5U4WmqmZmWzse2GdPA1Rv2v8nY7yQwJ0dntVII
	pMfBwk1wnfzTC1m0wcphY2gxg7FCbFHLF9LGxEDpbkSHSSHoYY2YmKSCjhqsMmwUEgjym4
	oDm9zlv+C7FR4+QA8JorzmhEsBSn+DI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-8FSlQ1YbNA2sK--rvM-B-Q-1; Fri, 27 Mar 2026 20:29:00 -0400
X-MC-Unique: 8FSlQ1YbNA2sK--rvM-B-Q-1
X-Mimecast-MFC-AGG-ID: 8FSlQ1YbNA2sK--rvM-B-Q_1774657740
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b23c909256so8168975ad.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774657739; x=1775262539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVak1OQdFi+KSbDm2i0b5emN8NsmFfdL0DbczgHqixQ=;
        b=nm/0pXtKl7s31U4Dc34YvJaHk9mM75GCO+oWI3TJ9sO9sXD7QiQFQY/sjO2Rg2r4X+
         DORaAK4ilVNL4eU9XOODRKe+M4W2Myij23boiOHs3V9j7ebNocW7stni+5DJ+7WRYj1Q
         awlu//Ny/S2i1ZKgpV88ewpclS760aHtnXVAHyNhULN2XwJvBimAZA4zO+MMpARUCLT/
         rzpC3NULDe3GajahMcZwrOyAaN2EEzWteLP4A9hZQmWXgWb+RJWSOF+JgoVY6/jEzfiP
         m1JBMNS2ek6by8rZ0ut9oMNTCCqqiJ3pnEMTGs28unvbth6fE1Ox2zLL4OMyaCmG4lnG
         WxYA==
X-Forwarded-Encrypted: i=1; AJvYcCU9KlKl83Ls+woTTRzHLzTkk7ocLOnXradGUMJ/JTfc0YLQ9TQIfva7F0rAfZ1qbYle2DPVspjjJw==@kvack.org
X-Gm-Message-State: AOJu0YzJnQ4TAvV40yryJZvf1GpVU3jWihYsBagJc8pGFPLaMP+AKGoJ
	TsDILp5W4+ts1QaY0auEqJGtJQDLUcVgpv4MN5RnwQSEkBaCgRm6Zq55RnJ88F7O0U+PaJ13bpr
	q5zsaSG6hmNQI5v2oeenf9HDst3TM5/xhkJ5bRAqaIqY2r9uYzFrI
X-Gm-Gg: ATEYQzwH4x+H/1k202bagFKTqip2nwBk4ZtnymrSBXvn1CLZnHOylmrrsP4XH1LWQc6
	rkKohcaBcrGuEv7uF3t3hfzHZifyB0D4Lfaok49CnuKyATdeNns2yN4as9m+5ooWP5s9vdMgznO
	mPyvILZ5wqF1dwmzGuQEyZ4iUadu+vlGu5x0XqWLaqJEiSVkq1hXO4F1qVcp8/3FQ7XWx24DOae
	LqXf2ceDN9yNwYCSJ2YPWGoEfLNtX1W6itDn9c1onHAumukYzhjoN0O1dOCMwVRVjVJG4HcC3iM
	TKDMV/th3SsiQRCLJbbdEQvZYO01yfSzGSqrkUKuDC0OEdPySN6Wy60SLAD2Gj2lTy7sPsGvWy4
	oCpvs4t3sQVXQq3ETeg==
X-Received: by 2002:a17:903:3c30:b0:2b2:43ca:3486 with SMTP id d9443c01a7336-2b243ca38b7mr2412965ad.46.1774657739500;
        Fri, 27 Mar 2026 17:28:59 -0700 (PDT)
X-Received: by 2002:a17:903:3c30:b0:2b2:43ca:3486 with SMTP id d9443c01a7336-2b243ca38b7mr2412725ad.46.1774657739017;
        Fri, 27 Mar 2026 17:28:59 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242642956sm5490615ad.6.2026.03.27.17.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 17:28:57 -0700 (PDT)
Date: Sat, 28 Mar 2026 08:28:55 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <accgxwDzIyk3_fEL@redhat.com>
References: <20260327120305.58653-1-liwang@redhat.com>
 <20260327121350.858a127fa49ed6e1eb4a40a7@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260327121350.858a127fa49ed6e1eb4a40a7@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KBRrM7N1wEAFeikdNbBPHsJGrj8ELGoQI4-G-ifsyTg_1774657740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: AA5B2C0005
X-Stat-Signature: gyty5cnxp1d1zmtqfzu38sd5s3ybw7tz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774657742-849629
X-HE-Meta: U2FsdGVkX1+ixzpNJ5Lw/6m+p85agf7zvnWlP0OTt/ix/cT+SMwkXriJr0+CKxBg6sNlOhgWSoYRkYjhMrDshsUWfQO++s1T89NQxlhgKEo6bE8bi1P3POE8eCes2/W4GSOdg3CWAyRsuqq/P16QwOKHO+qhR6Fl1uAXa/msvXjARtsRB7AIkV/z4Rxn7IGlw/SPb5ELxflvVPArSrxJzr381m8d+w7aaor1UmJdgjdQZdjMEtiCPWGWgt80i1E5Y/HZpvdm31K/Fh/E+3XuyeSzauzbC6pRw2fX9InWz5w75xdCP3+Kc7IZnqDNgAjzcwrzon2rBHjFCY58VF2Cf+z6Q/KpUq8iXZmLh0eDIxHHGuI6xm6Zfk72ewLV5zNJKhW/sf1GmKFplOKQDFcruwSlKEjgqt+/qM9YumhIa5S7feu71dwUfTW6Eh3C8kjvS8KsMx70i7kwn0TYE6ckRngmGHf7mPGMZk3Xr1KPHBAqYoxi1kgMoxUl7RfB9K2I5d+0uNbA7wbGoSjofU3cY54CLMvAp7f+vpsingbHAhT9FP/Vb3oNsBjW/hfYOFpfG/79IdbO3VR0St1zeGVKbeRivAJ3kVikXhlwj0hvv2382s25f+xo3ua9qmjiR/dlByKe5Lg65jSvLXLregyqYdWGpXvn6fl++EVhFctE2/5/DRGIWXVNUQlD6e7nhhyjMuywXw15Ad8DRYQhdIaTp1ilAfReDtcWsk2NpGuTNG4pvCRb03JcVUtUQtHhGoAPu3yZZhJRTN4RlyhJJ6FFyrLIc3ca7OohhjGZpiivvkmWWyWfRJBV7me2vUOvX6tJs0azbBOHi1i6mVQZwWErfYFr4Sp7qGWaHJGvu/HM24xoZurG+6g96QIBg8Do3gHdU5NV8SlD2s2lX+TtKdRLdFhI+ghzhT4X/5DWmqhF0EMFNAzBcghCAY9e8dwr1zuLazRuHENIi3+B2seIum1
 eWwja8Hb
 j850JY7JSQVmWI30SkTp1BpGf1vvoeSx0Y3pziS6naKmUJwaKg7YTOJux3tKR4Ljkl7Pj5ti8CfgCDKj6RI+NCFg9isJekXrwJLStLhVnc3ngj1G2L34nHnZwxLKLR7Uvla6jzBmpS+Ev6ciWgUBg6eA8+w82qhoZddYPBh45PODoC4Z/WEkYftNkYjGfycD6tSZE4vOPbwdn38A90ZIFvtKEz5GIdRLjshjaXMXZyXZ6ig5FceYPXYVPWbtcUrGz1Hqt/YkGbzAUOOEX3yNvHaS661gd1zKzK4cv5OGoUJUgh2fuvFMgEZ1/wTZYz60VHDgEU9ZAmGNHTX8WVjk5PAl1mHp9UQPV1vz6GfTYcajNhpl7kWoPP3vS8FkYiyawBtQ+0IkGW7cJMVglEpfj2ExjgGqeHV7QwNSt0NFKDCoz/9Ilm97GouecJghKLpBXECPPRe0UcdeWsYWoXE7v+Mbq89UNJ5EVdGsHvhod9FQYHPi5p9wiIhdiIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 12:13:50PM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 20:03:05 +0800 Li Wang <liwang@redhat.com> wrote:
> 
> > hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> > hugepages used as DIO user buffers are correctly unpinned at completion.
> > 
> > However, on filesystems with a logical block size larger than half the
> > page size (e.g., 4K-sector block devices), these unaligned DIO writes
> > are rejected with -EINVAL, causing the test to fail unexpectedly.
> > 
> > Add get_dio_alignment() to query the filesystem's required DIO alignment
> > via statx(STATX_DIOALIGN) and pass it to run_dio_using_hugetlb(). Skip
> > individual test cases whose write length is not a multiple of the
> > alignment, so that aligned cases are still tested.
> > 
> > === Reproduce Steps ===
> > 
> >   # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
> >   # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
> >   # mkfs.xfs /dev/loop0
> >   # mkdir -p /mnt/dio_test
> >   # mount /dev/loop0 /mnt/dio_test
> > 
> >   // Modify test to open /mnt/dio_test and rebuild it:
> >   -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> >   +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> > 
> >   # getconf PAGESIZE
> >   4096
> > 
> >   # echo 100 >/proc/sys/vm/nr_hugepages
> > 
> >   # ./hugetlb_dio
> >   TAP version 13
> >   1..4
> >   # No. Free pages before allocation : 100
> >   # No. Free pages after munmap : 100
> >   ok 1 free huge pages from 0-12288
> >   Bail out! Error writing to file
> >   : Invalid argument (22)
> >   # Planned tests != run tests (4 != 1)
> >   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > ...
> >
> >     v2:
> >     	- Pass dio_align as a parameter to run_dio_using_hugetlb()
> >     	  instead of generally page_size/2 alignment check.
> > 
> 
> Whee, AI review has decided that pre glibc-2.36 is a problem (last time
> it was pre-2.37).

Ok, will handle this build issue with old glibc.

> And it's forgotten the previous fs-doesnt-support-DIO issues.  Did you
> alter that?

[Sorry, forgot to mention in change logs]

Yes, I added O_DIRECT flag back to the first open(). Then it'd skip into
a failure on filesystems that doesn't support O_DIRECT.

Also, statx on FS doesn't support DIO will set stx_dio_offset_align to 0,
which may led a division by zero issue, I added a zero check.

	} else if ((stx.stx_mask & STATX_DIOALIGN) &&
			stx.stx_dio_offset_align) {


> The get_dio_alignment-before-ksft_print_header thing seems legit.

+1

And, before sending v3, I would leave this patch for more days to
see if others comment.

-- 
Regards,
Li Wang


