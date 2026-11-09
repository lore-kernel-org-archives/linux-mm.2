Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7BE606D815
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=paXZoEcf
Received: by kanga.kvack.org (Postfix)
	id A92E06B05BB; Mon,  9 Nov 2026 05:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43486B05BD; Mon,  9 Nov 2026 05:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959BF6B05DE; Mon,  9 Nov 2026 05:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A23F6B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:07:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E9FA40646
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:07:24 +0000 (UTC)
X-FDA: 85415153208.11.85C226C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id B2B3B1C000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:07:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=paXZoEcf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCv0Nnsjb1CATtKd+NoK/9Eh7t2jtA8IE/DMvxos3og=;
	b=emLaHgSMKLcwliAkc3oYJN3HhI+l7uIbWdHu117NyFEh6ked08L6h919KWAia8ViNo79eb
	gbsx6aOI8JQ/mPJjkThVCs2xTmUNPpUqYIoZoEefYtHffF8oGkSVjJCio6VZWHT//HNSvs
	paIftFR7+ZBXhsnzbV8i/Ty4TOu38KM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=paXZoEcf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218842;
	b=ZcokeF002lUixZkFBrM5JRcxdzESYWWHsURts7xPbD1sKcpiBiq0pP0A+hjbbmOBDLojsP
	AufFYImqNgwQ2Hdf/czk6Eud0B67BYgaGYF67YE/DC6VpG6K0TAuDD6RDjE983ne2Q5b6D
	Ps8NHywU0s6Zb82sEleXLZtjnAW9Ue0=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so6683805e9.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 02:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794218841; x=1794823641; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BCv0Nnsjb1CATtKd+NoK/9Eh7t2jtA8IE/DMvxos3og=;
        b=paXZoEcfZUzMb/FaG1UjpRZrY1jLhQLdKmdGGPTI8Ocno2xQRTljwM7ZUn6/tc4XoE
         gqZiCZ1fgUN2EP82vlWsCcBO/vtLwobvQqVeUVNdHfl4eWk8UFuhQpMb9ZnNT5/Wp6eb
         uhLbdcOV8uPogWVlDfDuh0BTvMGIrxzDbGeFWGk7Od+4aZmBHKeVlvYsKr7rT/Ye96tW
         80i3Paid9zV5BwGUh7m2CvjFDPiDCbX8UaKlakV6TJkuFKeTnnWftxWoD/xMQyuLzIay
         Z0AvrGtQawtoOi0XgG2MG050LOMXSlWhltj+A4Zu/RHFNOWI3xxTLAb9F2x3y4CzSAkD
         rjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218841; x=1794823641;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BCv0Nnsjb1CATtKd+NoK/9Eh7t2jtA8IE/DMvxos3og=;
        b=uMz/KX0M1t8bfUQQLw4E6KII2lA65Z8ArjIAtQcD1NYWn2kOGkeXCoPlD6uM/cK6PH
         hlkUknB5y8lh8/jYxIs+SZpKAV39StxusOGlOggI+B1dshd4aw17TLdraRIoetBvQTaz
         acbi/hrqJ9RvHqlcya2YdPhCpvjz/RJxVVWx7yBLm14a7sWZH80XQMqGHeAo09L5+yuN
         761gv7F+UdLKtKjrVWwfW9Y6FAeM+t/x2chVdSx88ahRxJCYg02ydDQ69cstJYrtupOT
         F5lNBT0ZOdS/5HX+EakQvto8Uvyb8+3yrFsnyjvkg3O4j3d3MA1mRhoBYBUvAyIEdhRO
         wPDA==
X-Gm-Message-State: APuU4Z/yjrYyYHUzJNm+Ql1UXxMf9SUAACzEZa+10T4PoXXp5gNdLrYC
	ldxrl0hF4smfo3j5vO4bNv/D/0SX+RruC1buTK4ZLPN5fPrG9n3z0UYf
X-Gm-Gg: AYBFou15Qp5J+0dKUS3Qsp6Lc7TlxNsJvgM3dSHjbniMQkPW6CbfL9RxRDZ7j8J1fqF
	G8LHcX2S+R0OAFsvVAGjpaTcLcTtic3dwZvGiBFIJD469UkCDANISK1EaJwgg3wa76dtsQCilb6
	1iKf0r1HC/fH06cD1PSRRB6vH3L1Dypufag479DhPYql2wEgcchn317z/fSUxTNCSyGsYKq7np7
	d4gmP5Z6MeEyDzF4ewpWQ6RT/N/4NXglklCrGNbnEvXAtQxzB0frgUKzq8Tul74hdcRlPT9JIAr
	k3pWrHkvcyxtiUfuKN2Nder+jxmFGaDYqeBpvb5uQEQwD3p+1UfvJER5hMr9J+xQ2Qt8rdyjIXK
	alvYNWOfBn0p26ELlOFa4wi1AJRx1t8pS3YoMQFNwldfGfFKdgKtWR22DlJ8bvF5xhDIqoh3KoX
	7UkRneYcJnuJQjACvUFYBgB3drU3QrxJPNBd4/xXyynUc6ujCjMmtjLOrvV5KHKZsADd41qyGN6
	mHEQZuGaF8FlIlHPBeoR4fi6ri/Ekfc1hAyls+j/7UYqf5vbl5w+4y5o/BBtjLqwP2A+S0TvmKx
	jZhM6d1BJSEzoa5g9jZgGCc=
X-Received: by 2002:a05:600c:46cb:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4b94d762ec2mr69628225e9.1.1794218840912;
        Mon, 09 Nov 2026 02:07:20 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4959783f1d6sm8829668f8f.46.2026.11.09.02.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 02:07:20 -0800 (PST)
Message-ID: <bb6fa14e-0a98-4b31-899d-0b1c883d0608@gmail.com>
Date: Mon, 9 Nov 2026 11:07:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
 <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
 <8d23b1eb-72aa-479d-9486-dbfd86d8414c@kernel.org>
 <43fc45ff-8636-4961-a80a-29844c15d7a1@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <43fc45ff-8636-4961-a80a-29844c15d7a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2B3B1C000D
X-Stat-Signature: 1i5qgf84u74wo7uqiz85cqpja9maiwgx
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794218842-349862
X-HE-Meta: U2FsdGVkX18voN1D3ZqRN9EcN7523uHrVfl+kKQMWU+xLHbBqmxrp7/GADsDjbhcg+tlb/cx3T/iX204xWVVk+PqZSBYvLv9SDTp73TGq8kzPGN+L91bvVC+OQWfgrQBONndt96ZTX7/q/HT3ptf9zUJJVZa2gYZTxiGrZHgZiWnJ+F8iXYUby+HiDIiqzL7sq0k9Gin79gNR7TcF4Z0teYJ/W4sffKhOeALQL23bsB4d/IkzqSoOLmWQHYODQxCnMqJyW/mOEjvVMy0ReXJgGSwZxOGd/pgKVy+f/ZHEPpPgmBqg4owKtEvOnS9a36atUfkTf9uq73lRkXZvN+K2ICTtOr0JtcoHxSH2LSqQF6FMIMBxHZluGKVtjUcvRn0GrbW/P/5trQmp3CdBWfBaWgD9P56ggACoz0phlpmR5YqJ50U7RRINs5MGNOL6YJ9Hw/5CLU+waVdlIL5nKm/Et9bZs1/N90QLeczkYtE1rWNzLPnC/9tMM8sUpmeh7NOciEQ1CIDagmii8gQPtTdyib7L7fVgCFCJZadSMIcZsmWO7HCZ+uGImSa/uoS8pZXsH1KX4pMMUcfR3y1BVonqpt9ihDK5+rGaSSV6obwHorU9+xUE+B3AmYEPbSIBl7dxj92PEBWVSBHZrtPhKdyPUGWY0dWPb3y+d413huN2rjTJ4MaGB0nsWQXNkftf2tsgZS+NbUBASEln8zY9CNqnq5iTLYTW9Ev9QRHuBcpnWPacbsnHOWdUXY3b9lyjR3pbP6EDYyITQtLHpGCRbzQcvKHjj+iLQ6fxptSaWJOkK1RoVapzgIySpuU9rSgAFQR/kR7PZj6UFti9c0uHayK++NsRAFi/SFh8XJ/niqTBeadnxqdmMzsylX7r7SVSAIlRmglQ2QGeMryaPAv9okmtNG+oHPHnRaQBJB6lJ1XEg/da/xlJRf+8VYryITRT9hD3ffC5S7BE0Fd/VbFgSU
 PUTIv/fK
 ThmA/T+3fmADJgcXbyb0H8DXNpxTlQGuGnBEIl07jkwxR3ZleS92rgn0+6G68wvjT17qBEm7AKr3D2Rdoc0SYmHyUxbXgNgB9xADXM7gleZlNPJVmY+AMc1aEk0G+lMz3G6F+nsl2fq2mnEiOemjMiJ4bijWkWgUGSqx5ALliTkd1o1GoB99fuyvI8OmvdyLfkHat6CBO/Hz+G5FjTzwPsCslDCfX+FXEyMB9Yis2FJduM/cWs6rbItJW63wdYUcC2RL6oGBbNdN6+ggpNBrs44ed8Jkawe3NEdHTJ7JhlQMXeikDB2WybNUG0ft6Nk/4SSEBB+ir/JsBdRan3Uc9X3eq+Ydt6SVY+bNhOfYemz3Q1YIgPdTZljoqOnLPROFATW/vNi8GR1UQeFsqYQIuT2GH+Xeyt32yHQGMl+FHJameUFC/NzPajM+D1pPRUrIjGEkGG7rT7PIRSJWmQC1C4R6qUov8GcapVBV2QNzI5289hxj8nUv9lOxc1ei+YrUcgvtl8PcjZhLG//n+/8PUIMmCeP67OmvoXnYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 10:49 AM, David Hildenbrand (Arm) wrote:
> On 11/9/26 10:30, David Hildenbrand (Arm) wrote:
>> On 11/9/26 09:57, Jose A. Perez de Azpillaga wrote:
>>> On 11/7/26 11:23 PM, David Hildenbrand (Arm) wrote:
>>>> Similar to mapping pagecache folios into page tables, let's reject
>>>> additional references when splicing folios into a pipe if the refcount
>>>> is at its limit, similar to how we handle it during GUP.
>>>>
>>>> This will prevent more cases of possible folio refcount overflows with
>>>> large pagecache folios.
>>>>
>>>> Let's keep it simple and check in the two callers of
>>>> splice_folio_into_pipe(). Return -EOVERFLOW if the limit prevents any
>>>> progress, so do_splice_read() can fall back to copy_splice_read() when
>>>> read_iter is available. This keeps sendfile() and other splice users
>>>> working when ordinary reads would still succeed.
>>>>
>>>> Also fall back to copying in FUSE when taking another reference through
>>>> fuse_ref_folio() would exceed the limit.
>>>>
>>>> Also check in try_get_page() to cover pipe-buffer duplication by tee()
>>>> and partial pipe-to-pipe splicing.
>>>>
>>>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>>>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>>>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>>> ---
>>>>  fs/fuse/dev.c      |  5 +++--
>>>>  fs/splice.c        |  8 +++++++-
>>>>  include/linux/mm.h |  9 ++++++---
>>>>  mm/filemap.c       | 11 ++++++++---
>>>>  mm/shmem.c         |  4 ++++
>>>>  5 files changed, 28 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>>>> index 3641abb90d6bb..4f6b7b42bfd3e 100644
>>>> --- a/fs/fuse/dev.c
>>>> +++ b/fs/fuse/dev.c
>>>> @@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>>>>  		if (cs->write && cs->pipebufs && folio) {
>>>>  			/*
>>>>  			 * Can't control lifetime of pipe buffers, so always
>>>> -			 * copy user pages.
>>>> +			 * copy user pages. Also copy folios at their refcount limit.
>>>>  			 */
>>>> -			if (cs->req->args->user_pages) {
>>>> +			if (cs->req->args->user_pages ||
>>>> +			    unlikely(folio_ref_count_over_limit(folio))) {
>>>>  				err = fuse_copy_fill(cs);
>>>>  				if (err)
>>>>  					return err;
>>>> diff --git a/fs/splice.c b/fs/splice.c
>>>> index e6d43329ed3f0..df73a4e65118b 100644
>>>> --- a/fs/splice.c
>>>> +++ b/fs/splice.c
>>>> @@ -956,6 +956,7 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>>>>  			      unsigned int flags)
>>>>  {
>>>>  	unsigned int p_space;
>>>> +	ssize_t ret;
>>>>  
>>>>  	if (unlikely(!(in->f_mode & FMODE_READ)))
>>>>  		return -EBADF;
>>>> @@ -977,7 +978,12 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>>>>  	 */
>>>>  	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
>>>>  		return copy_splice_read(in, ppos, pipe, len, flags);
>>>> -	return in->f_op->splice_read(in, ppos, pipe, len, flags);
>>>> +	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
>>>> +
>>>> +	/* Fallback to copying when hitting folio refcount limits. */
>>>> +	if (unlikely(ret == -EOVERFLOW) && in->f_op->read_iter)
>>>> +		ret = copy_splice_read(in, ppos, pipe, len, flags);
>>>
>>> here it can't tell where the -EOVERFLOW came from, if another file
>>> returns -EOVERFLOW (i.e. tty_fops uses copy_splice_read, and
>>> n_hdlc_tty_read() returns -EOVERFLOW after dropping the frame), it now
>>> gets a second read.
>>
>>
>> That's what claude told me during review, and when asked whether that actually
>> happened in practice it said no ;)
>>
>> So is that actually a problem?
> 
> Double checked, claude managed to confuse itself.
> 
> n_hdlc_tty_read() can indeed return -EOVERFLOW.
> 
> I should just have let splice keep failing, dealing with copy fallback starts to
> get annoying.
> 
> I guess switching to -ETOOMANYREFS should work (and might be a better fitting error)

I agree with that :)

-- 
cheers,
jose a. p-a

