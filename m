Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51868CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 16:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1910D6B0088; Sun,  7 Jun 2026 12:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142B46B008A; Sun,  7 Jun 2026 12:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0305B6B008C; Sun,  7 Jun 2026 12:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E51626B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:04:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 892FF407D0
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:04:55 +0000 (UTC)
X-FDA: 84853590150.09.4AB7E36
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6D0DC0006
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:04:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J0+CGTxk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780848293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eK8MSldLeofL6fbYcJNtrJmeIPFDwpepphNpG1jidfI=;
	b=GTsvBOQrLjZKCDo8HiVuBvQwFnt6kRatlh9EN+Fa1wuyO36sp0fKBPQZJp9HkqqQiN/pz1
	dB9EjC2EIm4jPZO837zs7evATjbFY/mIA5r9S7JAv8zBQ6LhZxTVUXcFQxp4ud7sWx44jm
	ioXtwvQEswyXXU091rFmYX4PGIEdvcQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J0+CGTxk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780848293;
	b=wzRotkM48pqOUZYn7niuym7e/MxLhq8kpx4dJo0GyOfK2opDx/DW7iXtR17v3f2Q6VMfIv
	WfyVqoDnUT+ix+Gjg3f+FijLH0jgIhnR+yvGQ2twPLjOaVfiIwW5Ubz5M/Im0yTsWaCzx6
	fBOKgFLMuYV6+fz1jBfcUFKpiTqWxkM=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45fd464d51fso1868198f8f.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780848292; x=1781453092; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eK8MSldLeofL6fbYcJNtrJmeIPFDwpepphNpG1jidfI=;
        b=J0+CGTxkyLS1nKMegCyIdjxmlO3UdSvBOwmlD9vPdTx64uXWTwOJ0W5etIMyTNZiKm
         B7bJgcJ/aF5nw6nn7mSbf3JSdIuvz733YphXQwb6ilRJD6dh5FxbbED+ZX4nHavg21fS
         26zLtJ9/08nn48xqpZB6QSZ1CMzcavFfqD3nkMmOTGqJjQV6xEGKPZDlLO/c7U/5zG0p
         KaPuyHh0g9HuK/QVdYUeChybtDKCYLCTGtmT4Ngk761LG74QvL//n/LqpvRtayAM7qt/
         daWEg9hb1km5fWTItzw0cXpDkFQ14khvQazN6eCYi+7qO2h3mh6nF5e6DSiIM+0bzMEm
         YgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780848292; x=1781453092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eK8MSldLeofL6fbYcJNtrJmeIPFDwpepphNpG1jidfI=;
        b=KUPGIRXNuhykLuSoof01fzbCxA4bLba2GQMSi+1PcJpjoCFb2z267y8B5alYqPVHg2
         DqPJiyYHDFCH3nOjfOLuJmS7/22dWUIIL5AHHm/j4bdnohLhTN08VlrNDjQAd9jO7VHx
         +fKTwfz18BDOhjdNWDbjdFux5NgVk8hlT5QbJrYoMjrUA1BgIpkoGFE6TdgACIM6rWaO
         8hspNhR53xIlxNtWzi2b3VvksiNhoaLpw0S0eyHQNgVfG+WRfrqVdFyjatY96tBYsKR3
         JUfCpn76bXPGLzHffq5b0qy3uXOckci0Y+96Azh7CfhCl76wU2L/rzE4yTRgRwoTTecN
         3mzw==
X-Forwarded-Encrypted: i=1; AFNElJ9O1le6ymFF79Da65/puoc4nn1ITHbXjb+R2sA0lJ/GjOJMTukgXlL6a8AQTRbqoi6JdtAHC4PuTA==@kvack.org
X-Gm-Message-State: AOJu0YyeCPsU+pGFJyewYTWiIqlFO34BLeqwhXI5wKyMAv6YruDxxq3e
	HU165dV5epzVVsAeI1Zl16QJtG8ZqGR5nEXZaDMyUwVyxnuFhhErWOHC
X-Gm-Gg: Acq92OHJJj2XTShNvCbhBJ0iz8oxk/FVzcFRn7cCSojuiTjyfe1z/wAz+nkJoFqfHfb
	z6AQrm+TBWgfRXVkHSbETHzb9vmE63gKc4JqoplEX+GOdvLds0dEBXY1rs632XZOrIT6MkiTpH9
	est18/RMk9rYVMNsgodPdIDC3hcTPl6+l21GxZAGXEHByXZaCon2Qqd6gZMMiUC6o5wnPSrWpoC
	hoXMRbiaIYneRcvuHIBqPccUViFF6MAatgJMOKGTQKXSBoXWLr5uSuLopltRm3ElD+cprPAXhf9
	c11CuphBWTXfFOQgustVvJEVRI8fbdlMyiLriFGGjBe2+exF0keIbu1P3agHEf28n36Ygw7sRdq
	dvkfzob0wPLf5Qcz4rIzW5Rp0jJtbHhoF9+BeAkKcXzjQIrLBvLCUrQXFsiYcEd2umYN2vVLKna
	z07CL6VYIXmIVOYzKDJICx6/5YPgYQ7lbVhYHJR1FC2DqHi7wOzwBThJcefD418e6/7+/c6cDIE
	/MSyhGrv93pnJhDaGxEJrsYN+0S0eKw7QXPN96ROZoL
X-Received: by 2002:a05:6000:2994:10b0:460:3233:f991 with SMTP id ffacd0b85a97d-4603233f9e2mr13227043f8f.40.1780848291905;
        Sun, 07 Jun 2026 09:04:51 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcbe3sm41826482f8f.8.2026.06.07.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 09:04:51 -0700 (PDT)
Date: Sun, 7 Jun 2026 17:04:49 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs/mm/slab: document cache isolation with
 SLAB_NO_MERGE
Message-ID: <aiWWoUuQyADfIA7I@fedora>
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
 <20260607070645.9559-1-med08elkadiri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607070645.9559-1-med08elkadiri@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6D0DC0006
X-Stat-Signature: hbugdeyxy4xc3byurpuaqgc1tm53s7eb
X-Rspam-User: 
X-HE-Tag: 1780848293-442826
X-HE-Meta: U2FsdGVkX19y/3WYRIkTVjapaA5sjohLbPWlab+gck0us6VTIUmhHgW+IBXtIk5ipGlCoUKWZ6v7bXpvHFeq84Y6/GKgQxvUB6LwKfcaUBtfserhuZbwQZKq7DuKPSk+u/UDnOo95HzHRlPo/Nr5ktXcV36Qs5pux8dSgIUxTKEGBlcZyQYu66+9NHfwLK09BW5kQyJ0MLdJh0SIOoNYfhM64hTpSagIzeCxZJ5MgymOZzTxkGXEVfpgR0nVwuynOBSqgvwMnPsSsTkdasz50bKf4J/QEZ8WwhxCQA7yoT5U7cYWRuaaQkfHwBS+gOuRGa+fAQKU1jnLcCsXh34BSSEopb/kf5MEpwi4EXkNTHWHC6rJG/BsRlaisyWQeHDgecsVrmMzXHTzyhrvsv7rfDhWk/yE6sirpgzJ55EKP4hc7fWTeuJHioe+MVaLH4r/DmJ7Bb6NU3aVGOGHkEzz4eb6YkHPfQkbZNl/LsVa/Xpkbfc3o5I0J3pyd1xur8k36MMdq8h1uSX0W69E8A8Hn95VIvA7bPEDBy0jukiIzNAvJvsK8sp0XZrPXtTHtpYMWreM3ufr4J2foFYuubYT72lPnzGZ+APn5wT0zOZl5MOqb7hmgfCykIRmeVpiaIYc4bSdkobKXEdLWlCFCvt7eCn2ZghO4L6C530Cedys5CdhrY+BjNVdKTBDGVuhZvUDp+8ZGAs99nmqGdoHzG/FzgYhS9QrB/bDvtaSUVab7xQAo8cy1qwT46uXMaNNYE/TBHHzFMRxBYNq3oiSDy5NTxQMexDSwCjbpMxDQJmo7jqdICsOhWDnqhpRRJ9/93zRM/XMaYM3HuBfGyRaFFdtNJNa8BgIXUj2B5aJFb2i1nPRto5x06KCdrpXHxMNhHoJMTWTunihds2K6wEISCYh/dq/2wAhpVlmHnRhZBMFkfVNAzrbVSE1J88URenngdH3hivQ3KCzrctfyybK4tM
 mm2MpNPe
 sjmOkBAhWar+300VXj6KDjf20i8rwii+q0wlltCITXa1Amk/pdWjUm3li8VCvv6Q3Hv78QTnJzGR1eXX9c7EiL0k+uuZYAPGFtv7n+G9NO72JRKe9ls9/XYntkSsVCjNLADNvMyl2tKOcREijblfRPtWFXs8/L0TL+hln/5u+5WFXKAiWlsZeX6YnCNLCT/THyRPEU27u4HSDEplkIBzK8QseQraLXgU/gqJpRga7vFYIZ14dkF+PS9Ktv8/15E/reuoMEYQJ7RHSdkmYwykjblvosg6Sl+VunBGi6K0BliHz2j+8io1l739Q2XixLe/W5oMdGj+fFJ8X/OpfVWX0UiQWSGcbZtAXr3sUMvb4M+Wd7biHRWzhm+TkRvhh98ew/H0csl+wNIsoVUzwCBiUxvs6LlcdF86M9/b43dbWjc4vIkTVTKRQO83mML/DFqSv7so97SB7Uzad6d4F2z05yC8QzHIu5ybe1RE8oLey81MQ/rdeGgjgs+4PmwZh1wciOunOyi9AxaQqsZxdKYEheQt5upbQs6EKaL8q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 08:06:45AM +0100, Mohammed EL Kadiri wrote:
> Add documentation to slab.rst explaining when and how to use
> SLAB_NO_MERGE to protect security-critical slab caches from
> cross-cache heap exploitation.

Thanks for helping improve the documentation. I haven't looked at the
patch, but have some comments in regards to the process.

We prefer to send new iterations of patches as separate threads,
with the exception being small fixes/cleanups.

Also, I'd recommend waiting a bit longer between versions to let the
maintainers comment since getting documentation is pretty particular.

