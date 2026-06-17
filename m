Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E52CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551CE6B008A; Wed, 17 Jun 2026 02:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DE46B008C; Wed, 17 Jun 2026 02:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417C46B0092; Wed, 17 Jun 2026 02:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16F896B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:10:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 879041C1CDC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:10:24 +0000 (UTC)
X-FDA: 84888379968.28.948010A
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EB5D4000C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:10:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RrVODa4I;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781676622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00zCxIJF6+oPAz4r/V9ZifNMpH6SjkiBAAesMrF/bTI=;
	b=XeFYtptmKevH8aYT84shtOF6p/OY10T1evKVhwSkBTzly1QrD3AfZasiv8zNR+C19x3l3e
	ME4TTXgdxtypebr/R0bua0gnzU1N83YKNkQJgc9qoxqoNPyGWgSCd3BC7PSq5v6Uv4oboH
	6N653v58JGwAf+TRPfh5+wHjCy1c4JI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RrVODa4I;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781676622;
	b=5tCLRUVIpfYj3K2dST7AHcAffNR5/2ebebPDC7f7w23d0LPerJmjw/FDJNTIVPXVMUMY3i
	oXVGCe2mX5XFrPNNLUybLgmYeghoaZ1Vkb2lwL33J6JsmACQdjjLOdxcWTU/3905kltev6
	AQtEzlOFA8d59YwUG2fZ2cNOsOGWfmQ=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842358aaf36so2135641b3a.2
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1781676621; x=1782281421; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=00zCxIJF6+oPAz4r/V9ZifNMpH6SjkiBAAesMrF/bTI=;
        b=RrVODa4IBwMY4oMRehNXtPWWk4WFvwoHbkx+64DJF5v1z2Ruvq2GGMs3UkHaOFEhF+
         O/LcSF5nU3zUhLtpNl3oneEctbSclfGnKhEK2JAPD3SEIWJkrE+JbgNOVN/MYI3FoExh
         hpdQ27dvDWII0eiiC6F4qhDzkn4N/unHPJaco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781676621; x=1782281421;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=00zCxIJF6+oPAz4r/V9ZifNMpH6SjkiBAAesMrF/bTI=;
        b=ZDZaMWu116im85A+PKBCSDMQqhag4FnBkDSyyFzQiW1ES7tDHTbnrw16tm24cTec92
         jtq3l/paYal1MYYj/uYJ5rFb03nQc0Vatdixa7eFs17DPOZYtLosgvg05k/OB7LCj+rV
         Ho3UpwMTFtSN/5oCfPHFUyPlMlDX16/cA7ousXvQdKblySmA8vrp3wzDRpsztxRGYpar
         gtAS6xx7VWS7r5ytRGHhSXKb9rcTaijOImSGLpC9c6WUtPhXolHW9e25fncgzwFjBaSI
         XH7K8ZpA0pMOYUbZT+vEgVq4JVVp2ZIk7Om8D9qxmHZ4iLIeSXaP68NvFxP9i1Jmwicw
         5WvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9dBMqpcqTqfExyFyOyRbsNHWnpQxHtF6Uz7XVu5LPT1Mnk+e88EqCTAAMcDmhNIW5iMMd66lzbFw==@kvack.org
X-Gm-Message-State: AOJu0YyJf8L311L8xjevdbHAvxFwazdAV7RKLETbotzu6HxKpso8UOjS
	w08uztFPIEWOWlxpu67XYTIlnBNSRqRbXOw4Ma8iZOJZby0RjLAt9iGsq37VtA0vJg==
X-Gm-Gg: Acq92OHHDQy7MbixjD8Qm9HAMAQvv2bi6kf7SV6e2y0R3NmCUEwABbkU7tICJ8WwBTX
	ZRrYiRWVKMZ36A3gGA6LljL1ndxtoKCp5GEGGTTmXN2+ks0hqdfStcB5ZWxbbo73mKmXHk5mrF4
	6mndK4zKjhjWBQH9oLg3nGeBNZk4t3ttjp8tYNYe6w2zAx7taUMbpMN3xpgL30ksVIGc5zIw1oa
	GJj0UnDIEpcfepX5lbeGMHfjhW1NWu8XsGE0ggJ28Yhotj1l9zCTb6dpfWPJrjx0zzbg5XTridm
	ZLTxF2Mw3GUa5yUdJjg4oY5knf2rj0CxnMWBC/sLljaK0AXxuS1nrA2MT+cl/HhTLNlU6BY+xkc
	tibFHkFMWtIcY0Wb5MYIDXrxcpyHOtKdNfXzeH7mSLFFejSa5hv1hL1u7gjTM6VkMWzMYopPB8o
	YFDK2ROpdMFEqE8V5QELhEPtnT7GO9S5ETJs8VkOiW5Lbr6oa6YN4U
X-Received: by 2002:a05:6a00:2906:b0:835:6388:655d with SMTP id d2e1a72fcca58-8452445abfamr2457086b3a.14.1781676621348;
        Tue, 16 Jun 2026 23:10:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:20ef:efdb:f2c9:836f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm14338791b3a.47.2026.06.16.23.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 23:10:20 -0700 (PDT)
Date: Wed, 17 Jun 2026 15:10:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Jianyue Wu <wujianyue000@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Youngjun Park <youngjun.park@lge.com>, 
	Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Message-ID: <ajI52zahhZIY0kir@google.com>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260616123646.GB21024@lst.de>
 <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
 <ajIYFtADxQDq8q1P@google.com>
 <CAJxJ_jiM_-a52EOm896FXkdH+wRxjSHJx+MW6b-ewNLVkp4uSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJxJ_jiM_-a52EOm896FXkdH+wRxjSHJx+MW6b-ewNLVkp4uSw@mail.gmail.com>
X-Rspamd-Queue-Id: 8EB5D4000C
X-Rspam-User: 
X-Stat-Signature: dobshy3iosm6k3iqn353q7pmodz3pixr
X-Rspamd-Server: rspam09
X-HE-Tag: 1781676622-890025
X-HE-Meta: U2FsdGVkX194PnkU6iJ1RtRteBwCL0HM0EzmXFDAu2LOxFaB0nEChiO0Y8kqFwmEUcq5gm5gmY8cpdXrTCo41ALC/UntQPa3jLmQXocBOOfm/OpCuo88ft84OKwNFHKXdeVu3pgW802r+BYSZq4DpB3xHv8jgQ8CEV3r/AsADCzsKQXZPQh5NUq47519g/ynILlZDZ/bFr/nnk+j/VYXScO69M3Ty7TbeoeYEjZzxW8XOlAbPTcNwy8IopZ2L6vaH2KlruP2pEsloFQ3vWcfmLLLhW8yRZe9cz/t1+AAJdAiUwwVkyDQou75CagYjW6me5TZf0U6TdRH8ERZHQnkNSYG5E28GPqgd381dZV+9UGlNX34xqaKSGGQC/ww0V/srFVlZEybTI6FddWEc7I9Qb59DNzXcUfyAfVkiiBuLx+w3zL4MAqWIhlJ3CyWhe82ggkfM57THSKX1hi8jeITJbsnMCb3wDXLhwEnAjwjUARdZArfXpFHelCv3L012v77AXOH3m0Mwz9CZjbzO7PHGvdxBEt4o9gwFELI4yBccU3pjnWTWvZCblDioboQVVCuGa3gJHmrMqhIGijjMVIExhjawvqyJuTJyw1WA/usUiSknlaCvbjsBZ+QtYswKmZEdhUw6u/dpJeOyIpsa8OH9UNgjRKlV+hZjyRcjvYwml11zx943dSovNyrfeM/gyajm4tG8wxUY3HI2gU/GXn5L+j6A1VmlAosomLKv4YkoH9D1XI3bm6XKpP9jk43TmEOQI15L558RHb5mBxqL+UAmUB33dSptKIIw+1TqV1A6DkHVZLQKNvNl1HA3kXMgQwtGnNlF/xoMjpGB0VAbDm/DlR6Rl25Dy/AWwMDcD8zVI3GX8jFob5z5/BzR+z6HnvE6VYGaxpoALFbwHaz7p8ES+i3JJ/VMU53aS95x1W0mLxk22jgN/ruGzx1kfN8c7h6nZ8QV0ABS+FsC1Fu5V9
 2iWHtxDH
 vc+1fA7wgxopthL7SMfHbFFhvIM65p6ox1qmmcbC05ObTMHIDxc92XYkDoDjKW8AU9ld41MtLS2P84BIwCj5PuRR12nw0g4v4ulO4evypT83mW4P9xe37aBoKzqdId114MtwLhxVUqvr8evYyHx0XTIpjUlNaOMdIWwi+ZEXL/ofPf+q3+bvjtgxayeysrZ0+nm+Iv+uETA5Al/jutLaaCVAJkECiugq+2yRV3SDdr3pwxHaLuz8XMC3EYdp5dkzeVTmgqUfe8PpnEBzAcYX6/x4v89bGg+86cBjBJJKNSwpTmHhA34lk3rrJ55KcBtA5Wyo/jxLTqRA7mnObGOZZz4UiIVZnmhspojWNEWxDdd6Y0yXr/8VBJKATWtTKxR42WdJeWsvfQUt445RWhuF0GvkOXMXXR5/NEPrw9PHAeoALhZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On (26/06/17 13:44), Jianyue Wu wrote:
> Hello Sergey,
> 
> On Wed, Jun 17, 2026 at 11:46 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> > Can we elaborate on zram being a "legacy interface"?
> My previous wording was ambiguous. Actually I didn't mean it is a
> legacy interface.

Oh, your wording wasn't ambiguous.  I simply forgot to direct my
previous email to Christoph.

