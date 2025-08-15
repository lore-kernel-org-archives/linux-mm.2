Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC83BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC818E01D8; Fri, 15 Aug 2025 02:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E968E0002; Fri, 15 Aug 2025 02:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055FC8E01D8; Fri, 15 Aug 2025 02:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E39FA8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:20:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67EC41180FB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:20:59 +0000 (UTC)
X-FDA: 83777993838.12.D434E50
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E6E240002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:20:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gINOpAoa;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755238857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rR24//5Cm6vPMiW1pUvuDPyIFf9QUDVrJzX55PqcQY=;
	b=s235PE1tn8nALu7UQhs8b/17oyE9RBZbGBfTlPItT01UaAtz+1hCu1I1LZABNiBhc01q4k
	T78wmWljBfT//Nd0By8udFGLP9JbTSpNhiyJuths1+WGNfeh9HXzax5cicpn5OxW2opjSs
	thvsHzPGk4yuV6qK+inHhZzr3XTpSJw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gINOpAoa;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755238857; a=rsa-sha256;
	cv=none;
	b=7J5i9+PXQswZYEd2q4MSmhUhDlzTqhtlz/uLBJL/mAJhpVhZ3zDFyBvmqagDuxv3iv7zYv
	IlHuLhi8GkviEhEV06qXq/ThqxjQPnZviDrY53+RIkw6//Uu2lirPJ5II6A5UB0VxEsK70
	YHriRTp49AztzAGiMyaCFWq9bE1qGv4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2445818eb6eso13810465ad.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1755238856; x=1755843656; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/rR24//5Cm6vPMiW1pUvuDPyIFf9QUDVrJzX55PqcQY=;
        b=gINOpAoaXX3Hb/KJ8cWCWwKiXsLip6A9uGWzNakb6jY3b3NSRHYglhTdPnTCnB4o4W
         P8lg5Yz2AIDO9NoAvHWGrNZcTpi0QJawDosdTFLC7RfLJUOs8PbAZGlCXOHrzSDk/d3q
         P17IGFZpp/pGSHBABNk7H07AY7ipQkuR7dnME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755238856; x=1755843656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rR24//5Cm6vPMiW1pUvuDPyIFf9QUDVrJzX55PqcQY=;
        b=Sg3P5o88eUUxtTgGxl4DNqBwCw3DQJHtE4q2rvpM1tkRlvunFMiduWlwwwSslVC4iy
         BsAiZvory+MlT0O7/ZIJELXsIW46gyQz3Gy5paFMN8Slw0aymO7Absd+eKCJRRFd9qXc
         lNAdIHPsuvum12614C4W/Z+rD656QsOdnVq5dfmq8Nr6eAnRwH96e6zlbzFvHkn3W5bz
         yTYE0/P1PmhEPyhzw3tLatUTqlj8SK6up3LSaQM4otHA43XpXY79OCmqMJ38Xso6oLNP
         a59JIMQmbJcKG9jSowaNLyNnJYgAw12AW7w/jHiOH1xinn2WJE3iCKySChAgatnKgoNG
         bMLA==
X-Forwarded-Encrypted: i=1; AJvYcCUKVB6BLIPXWzLMk2oCiO2m+Pn8o9cmrcaILrdSGNXIZTloNJS8b82FnLOZdvvRNHUmJ4tq7IuU2g==@kvack.org
X-Gm-Message-State: AOJu0YyRCD26TB8pmrMJZZfhl5BA2A51fPiU+YXDGel8eDm5QzoFzWVV
	pb8JpTw6EKfoexl2WWgvSDk5xooUcEMq+hTbTICn2uw9iOWm5Si92IfzIYCAKCHNjQ==
X-Gm-Gg: ASbGncsr6t9NexysimNYs9Ns8bVjJKDeG3WldADPoFqFpc2A/nNwsf+VNQKH2CPoLhv
	i/Ig0YKxIlJsVbuObrF2u6Ac6MOINAgcOQ0wxB7Olq+OQ6fdLSFdB0rmGfqLP3VaR8MzIT6lMon
	BB46GWzSaEh2Ap0o+kUvgiVEYXvndunm1q14kPhwR2sD1ltpShqMpdVDH4e+KPsV4UaFTOWZZwe
	FISQ7BL4LmwH/UYXChEK+jw11e/OaS3S8HMVbl6llcDLX+RCPsH27jxJ0tsXONexLgA8QzS1XE8
	O+2cOdRMx1b88Q2w+uMjFnC/ec8taLogmm1ZvVQ9JZMSSNVEEBlZcM8QlEPe/LbmWr0L+1JKMU7
	jZkeRN88d6AAjAMNtYAoKkn9Z
X-Google-Smtp-Source: AGHT+IEYKXi8lWkNB18A5d01PalWbEiDPkniHD9LNzszKhC3ppcK5xRYDEJqm3s1E8UkeX5BahX4Lg==
X-Received: by 2002:a17:903:b07:b0:23d:fa76:5c3b with SMTP id d9443c01a7336-2446d745130mr16515475ad.22.1755238856391;
        Thu, 14 Aug 2025 23:20:56 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:df07:bcb4:bd69:d61])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d50f6f6sm6675165ad.92.2025.08.14.23.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 23:20:55 -0700 (PDT)
Date: Fri, 15 Aug 2025 15:20:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Suleiman Souhlal <suleiman@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: mm: swapin read-ahead and zram
Message-ID: <dr2ndbnav6ynrxjixfjjsbe4jr66a3niplzpxcbbt3ztjimwzh@l47amo3k5jt5>
References: <7ftwasufn2w3bgesfbp66vlchhpiuctxkhdxp24y5nzzgz2oip@pi4kdyqkl5ss>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ftwasufn2w3bgesfbp66vlchhpiuctxkhdxp24y5nzzgz2oip@pi4kdyqkl5ss>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E6E240002
X-Stat-Signature: trqyici5tpf7fptgxstf3j7xfgot1wbj
X-Rspam-User: 
X-HE-Tag: 1755238857-848068
X-HE-Meta: U2FsdGVkX1892bUFaMisVIGzNFQgng8GEmhuNhp9I5oHsmj1EetwoHRJQx2sZ1LS9sirZ4JA3eJWcHyQj63Vd+3K4YSKqAwavLNetHwbEhNsW0XuQLHqZPhN8ycAT9qw3u5GFklGjXtHz1jbB+Pv9oEA6N0hcapueL3ycqosOTSM1s3r8xH+yWDbvxGvUnTzQrlznkV33AwBqhykBxtOKDKDb/YUIGrHy3Rqn6jk6+LNV3+sxjk3+6dUVlGHSkBlzovJeq42A2yrRSGd1bpn34Obl4rN4DywhwD8fWJS9DgM52Q9erlUJKbx1dDVJvdPYC6hKLPrsM1NPRy92TcKDcoyUazjVupIc/p4G74rhDSbiUICGpMBBDP1HZuWxU5CbL/IcJ9kNm4cTpolZdSTCcPx727znCgCAM1GwXUvACQfDOYYVYMDwvbb2ZnyGUW3AKybaEmQ3vP7Vw96OIdG4l5gMD4L/JGQaO8y/eNoPJJvnVkHwImr4A4iEoxP0PAE171gANUVAWPTCYxihkD38/7yQRX0dktaVUSsg2AzyETKZvcchfGSA0cX4zfttGaWlDODeJjDhi9S+57TD9jHtWXsTNetGsqTsWbBzVQej46hA1Kwwv+mlisE3DPPSUlRF+lwxsP8K9fIjlF58PALeRLgc9N16w8KUeOHh9WB2bwsV0BiJfnADWcqjKXinJThsuKTKZ1yBNQjU7QUvt/jOf9B8ZWhNulXIg4EdxfXwxPwIZhm1D5PDYed6ip75srC8CDKGNpIAGvo9bun2/YyQoJZqQ5CuisDhKCen4p0RYT8xj8hJ3X43OxIbAKyzgV9j1Grd/jMEQ+IvL7/L64wxmEmtg7rjF69V7gnARg3dtS8Z6ArkzceDAT7aLC6Mu56l5ArcpsKsStNzwHx5UBhNKoBwiaceRW60l1fIx7YAtB7zOtZlQ6+ROEeVFu/R8pYRgBfMlipRozOCWseKSm
 B5ACWzHD
 DswHk/KwHyssFeimfgici51uwqOYfGNBL8s0rpsDx1TfTlbkdJ/iXuRhX4E0CNxNl13+V/6B0swtC11fwyvrK/XOsiZVNAKNQcll4YGi/exc5AacvWL9L/eoZwgMb02T4A0YhKKH5sgPU+hCMrhG5S5su/ZY/be+sZYhhpXKwthm0/p+Zhsk1G/Aj+2oWqlAy+/vaReSeq1r6K77r0JquGj9TxOZ4c+0hEfIcr/dxikuGuE1niKW+BlFbw+l4CH7UfoJR9xNgH17ZIkjyjkB4N0QDdY6yrPKmV9+Nzd/rxziy9FwwsgqRbCihz+P+1k85Y/wB4j2/BUmLh9CnxXi1cisYHX9ghkZEDrz19wff8uHGZ3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/08/15 14:51), Sergey Senozhatsky wrote:
[..]
> For instance, notice how entry 1615265 is read, decompressed, then
> presumably evicted from the memory, and read/decompressed again
> soon after, almost immediately.  Also notice how that entry 1615265
> has already went through this cycle 189 times.  It's not entirely
> clear why this happens.
> 
> As far as I can tell, it seems that these extra zram reads are coming from
> the swapin read-ahead:
>  handle_mm_fault
>   do_swap_page
>    swapin_readahead
>     swap_read_folio
>      submit_bio_wait
>       submit_bio_noacct_nocheck
>        __submit_bio
>         zram_submit_bio
>          zram_read_page
>           zram_read_from_zspool

Sorry, I need to correct myself here, it seems that read-ahead win is 1
pretty much all the time in swap_vma_readahead(), so that's probably not
read-ahead after all.

