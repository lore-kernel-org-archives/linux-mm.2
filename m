Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DCBC5AD2C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862736B0005; Fri, 20 Feb 2026 17:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8159E6B0089; Fri, 20 Feb 2026 17:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1D66B008A; Fri, 20 Feb 2026 17:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3B76B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:13:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E39741B5163
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:13:06 +0000 (UTC)
X-FDA: 84466236372.20.C207015
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 33E0140005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:13:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jOOPAu97;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771625585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zyPiiUIonG0J4/IO7tKRIyLRn2Q4TANm9RvHjFiYDZQ=;
	b=Ma+iTfSpWZg/WkI8IOV93Fy7DTglziBdZfi+jBlQ+NPhxSOG0hYEGRi3P0iNNgqmQwgNSt
	ZgTN3/Mz+/Fi91gLvtV728IVVHfGNNo7UtNCYb30ehXC02er3/OxVik9MEdzHQtBwoR9Tw
	tWNYNQqQqJeIW6JcuK2jEM/8ien2ZWk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jOOPAu97;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771625585; a=rsa-sha256;
	cv=pass;
	b=HXK6i80AyL6iEgcWgE/LGWd+Ls9NiHGEBRl2ZwwUBadqvQ26QTJRQinKy17wWquAJXnROZ
	HUK/8jNu+C083V654e8rB11Yc+nvoewfwBW6N7cbeJTr9LVqcfWhPC2LDfaWL4xfwUQG5L
	4jJh92VGttWKZ2waQEk9IZVdmLjrH2w=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89549b2f538so11770586d6.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:13:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771625584; cv=none;
        d=google.com; s=arc-20240605;
        b=OGyw5HmrZO5p/bCB9fPMZH0HsWizjawSgKTkMv1ohl0Sim3S0zh3sKyk3HecMmSNH4
         nrOaiMuwIrS9NbGQBu8qCf2I2kOKuEe6Zwqp7/CKcpfuKq4qe+xKCc9S/sjK9O8tOTa/
         eev/JjysFcCRE+fanX/ovK/YPHhzNniqXZDOvRgu17KN9fywsGYP0E4UOCHzXSNtxjuw
         0bgw1AR72XScvY+z9+Ws+vBZrUHq4I5ZNb+4AiimEb374nI/6pmXLns0rqWbuBZWxxOA
         69VZhQE2OKD9I5qtba+jj/ziQDC8XFm9QGZbk7TVTLk5lyBG3lCizJAwc2PtpXOssLhF
         AqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zyPiiUIonG0J4/IO7tKRIyLRn2Q4TANm9RvHjFiYDZQ=;
        fh=a2e90hYT/wg/31axltpZG13lSIlv0gqlIhKdEaoGmhI=;
        b=V/3wbObcEK7PqCyiSlO9L5c12fLhYFycdk1G5soNQ8BR/xPpviuQyDuksBWGXNUJ8z
         cBEyBCfhBpXLpWla/0pWPUcippC9R+cmyPx0dJopChkjGji0Tn0U9PqmZLWXgDEztuAj
         Cskk+IG3tSsgzKiDG0GC+sZPGwbZnS28ebCWPm9xLsliWjOaEzieLAK70ItxV7YVKSq+
         OsQBjbg3ieXXi3mKoCzmqdxlTOq0iNugZuYkWBiLmLb6UWJjTvOx3m0fksjEkHMrwroN
         u2iCpfNUnZ7Y0SL427MTpzGUiNwBq0sMspECyV0Tt5Ojbi/h4ICOo6Qdi14ORDj9gg3D
         51jQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771625584; x=1772230384; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zyPiiUIonG0J4/IO7tKRIyLRn2Q4TANm9RvHjFiYDZQ=;
        b=jOOPAu97jAEg+bGPbytROCpxGNwSmzBVWq8O35xhHCkfvxCdPaqFrWGeQJ1cX+avNL
         apwlWd/lwxeur5Il7p7AB9UvnTswMdFomcLiXWojf65/yM9z7OeqdkT6pSm1VXtCxWzc
         vUWWl7LIl9dsvIx2/6HU8pnAnwvHyhOpprNQ4JLAcJ2mRF7gqIGAqjlKtNkmLUcxlGt+
         bNN4QzRmeTX5vMtBrwsYkXvtZlP4svoAswdlh0lbTNTPTXHMRtaYay4+f+64CkEmTCrq
         5ibOlFnhUxUbJszRaJY9kk5Y3h5TfBECPxGp6MZbxf7JWc55hT7QrA9YMf9HZ8cayrzW
         Zlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771625584; x=1772230384;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyPiiUIonG0J4/IO7tKRIyLRn2Q4TANm9RvHjFiYDZQ=;
        b=rjpNQV4yVtVpAXY3eHG9e9jIxD/fHtKjU3BzziO7MlU+Vg0/FMmSDc5Huj160snY9J
         WPyjFBTNprtvFAbpb6tTJoflHIyv6mNTy4+7PvcHlCMUDCmYro5DUCLX/z5pQUjYR9K9
         WO+B2eEetIVEDlq3KmXsxXO00IpM4pkujkDitQRJ7x0sdwfLepCoalHt34vn7j99GsRk
         0uY9jXAmPL9KBhzX22xmCeKYuIM2VzE9xvnsK1RV1chSYTAFzrdJYjpGt2I8bFmD1teD
         CEkKe7T2EvOQsT2YC56/eu8osLZvZNtbA+4cm//VUXejndz1nLdB6P/Lc9xWSDTo8xtb
         6vWg==
X-Gm-Message-State: AOJu0YwKIFkDchQINyZfK5Z6zMfuCpGSqAyuAT9WrGnsPHwlkPX6iRJd
	CBY/sTv7FG96z4nbO9W1b0BHUqSBGqSeiW7Rg79VkyTaGSHa/RR7el/a2sj8o6l5Z+MoC4/x9FN
	TQonSq+wFXfX+nT74RNk1DgiKjoyN3FqMpFSk
X-Gm-Gg: AZuq6aLt0v8Z3tkCGuQSsVS+TYPKn+HSX14SW6EVo02pJunwSCbV/8CUXCVJP3cgZQg
	QKfmwC4EK8sRq/FFLYlizkDF5+nR9edaCoG+bFa1xdcZSAjjsexW5ZzKBxXHznv2RwOpi3GzvuO
	kdfdO03K8I13rrbrJO7ZMhlV6+oBnmZvW94To2EF9TrdO0oQ6IR9hAKi+DmzLXny5yEZPFUgFSq
	tRtFHscGdjxxyBIVcYdjiUJ3eCvL4mT3p6/eOe2oLF32IZBEbi4jEOZiVa4GryOb7dEFlXbF+Cy
	Rop9iABeFIGlCCne
X-Received: by 2002:a05:622a:20e:b0:506:4141:48b0 with SMTP id
 d75a77b69052e-5070bbd0485mr18768151cf.18.1771625583915; Fri, 20 Feb 2026
 14:13:03 -0800 (PST)
MIME-Version: 1.0
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 21 Feb 2026 06:12:52 +0800
X-Gm-Features: AaiRm51TbDrFOBURQeyDctpb5vzHROnbo-eMmhYOTaoqae55kruD9AUfX6jLJJs
Message-ID: <CAGsJ_4wFMm4WBM8pi-+wmgsUAu-+W2gC0wNR_UrdecY3-+5uhQ@mail.gmail.com>
Subject: [LSM/MM/BPF TOPIC] Do not hold mmap_lock following folio_lock failure
 in page faults
To: lsf-pc@lists.linux-foundation.org
Cc: Linux-MM <linux-mm@kvack.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Oven <liyangouwen1@oppo.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3tmyrmpnqoi81g7t735zq3b9o3zdmz3t
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 33E0140005
X-HE-Tag: 1771625585-12397
X-HE-Meta: U2FsdGVkX1/eULUiYGy9xC0eLk4jPtcpZyC/1BQ8jCVSLs2F04mHdFrsalcFrwB0W4EV0E2AXlbaH+qmRvgPkDgh0AR/NmAC28DFlUcbedxSqX/eetKUeZC8Btm1LHBgH5olwYv13bVpbH9WzZnQosx1BzO25lMxySY8PCW1CCrbaNZDU6g5Cg2q7DTMwLxeLENe5yUMcJ2LGBuqJOur+lVlOniHjA43/yE+0ySRKNy/t7FMGdTW9FUBrFPGdfk38LPZZE/f5ydOD+AgjHnA9fZVBcwS6reZwZNQYNnHwv7+dLPfnmaOh3XUiMSaedygYF5dU/qg8qRMWpxTTy4tTIkLt16UmUGb00LwlkZse8dvhZSMif0vD1hBooNf0RSbn2pm0/pWH6z/kWisiKKE5qKqOyJa0NNyK8bE9rf/B7FjCQpBjdR+fIS8+n1bxZfRdXn6mlNq3ikksN7V2PquOwjULiUb/xrLUmo/Dx8p7tFJQzKTK4gIZ1l6HvFzkpT7BKcXAgvV0FnF9IaXRbhIyiVtuyvHL2p3k2NTbdmbRvagh5B9CYIZiRSp2/dy7T1M654PxJCcSETG2xyxqWyrvhTJm1PzHPlT1fY3EFFPb3UnigkNN1+8hDDEvZpk2v2/Dq4hAp9Hx/aT2dqIjgmORq1zISvY5shMN5I0lxgjLgLFO6pEnN/z/lWLAZBIhQTBagxr72uqasKkRxKCcBsAViZ+M606gg0aX6kwkdXgv0t1dXUXzrvM/I69vr0QPw6S5tqOtD9zao8tBsk7ZdbW78C/+d97XW0+Onr0ckKfq6/Aj/w/1zxeGxXl96kWyyouWoW4mGZTi2WCNp6C25lF7Vnrr2Wi051Y5FYdP6EkgFFJZc8PDO8XMJR71fJyHRUvJcXIvD8bxR/6cbvciB8kZtzNFDvd/nej5mAOqq/S0/233NgSnQpkA0EAeeCNlKbN8uXknzOEjfOFCRQh5XT
 OyDTmKIl
 DafghmiOimU12FMUiA7/+ebcRf3uamUhUFizL9Pk9pa4AsOfSpY5+9s4kCca2PfFV6qJgsQ9Y1TcmNAVvO1AH48XVlkqYG1wnaYEFkRGrVH4AA7Z5o+CymSl7G7gcR6p4q9Q1PN9DhUDhOIZFNHKmFMrKiRUAIUvvAmx4PgHqcK6Ui8GzqlVXoMV0nxJaamTDqIWLys3nITRkBMBuEWON9mpd7LA00+8HYSdccNANuTWTpHwnSUFt5p8QaK/HNmEEBZcENdv/L3HFw9HNT/aaUrkvyX3DhfTeqv/PxSgvrNuIDvdA922izEJNkzzPoZqayMi8f/GT3tJc6Gb8geC19sK35602Xi6Q0M88KooKrkR6tMK+5X64gZxB+bLufCDadzA5IoDxwqwblX1ARnvyxn9zRRB5wBmAdz5RVpc3tVA8go4M3ZAsqUZgq4L0fG9p5+bsHEaWzRpWlHMjGDA+NheXmdAXi6WSRMypMTMpypZseOMb9L1QQ3fafYGrgHkv3JlDID3n36l4piC+Vxy1LB3TomAE/HIBDYideiWB5x+ZVNBYy0HOQTJoNjM91WKLDP7f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, page faults use per-VMA locks whenever possible.
However, when a page fault encounters an I/O read (e.g., in
filemap_fault() or do_swap_page()), the handler releases the
per-VMA lock and requests a retry after failing to acquire
folio_lock. On the retry, the fault handler always acquires
the mmap_lock in read mode unconditionally.

This can occur frequently and may sometimes cause UI jank due
to mmap_lock contention. A proposal suggests using the
per-VMA lock in the page fault retry path instead of taking
mmap_lock [1]. Oven reported that this can significantly
improve performance by reducing mmap_lock wait time [2].

Matthew appears to suggest removing the page fault retry
entirely and instead waiting for I/O while holding the
per-VMA lock, noting that folios under I/O read may be
reclaimed by the LRU under severe memory pressure and
with thousands of threads. As a result, folios might be
reallocated, causing the page fault to repeatedly re-enter [3].
However, holding the per-VMA lock during I/O wait raises
some concerns: writers could experience long delays.

On the other hand, retrying with the per-VMA lock may reduce
mmap_lock contention, potentially shortening page fault retry
time and giving the LRU fewer opportunities to reclaim folios
waiting for I/O. By the time of the LSF/MM/BPF discussion, I
may have already created similar cases and collected
additional data.

Another potential optimization is to remove the page fault retry
without risking long I/O waits blocking writers. This occurs when
folio_lock fails but the folio is already up-to-date. In this case,
a parallel page fault may simply wait for the simultaneous PF to
complete the PTE mapping.

I would appreciate feedback from LSF/MM/BPF on approaches
to eliminate mmap_lock acquisition in page faults triggered
by folio_lock failure, for both I/O wait and PTE-mapping
wait cases, for mainline inclusion.

[1] https://lore.kernel.org/linux-mm/20251127011438.6918-1-21cnbao@gmail.com/
[2] https://lore.kernel.org/linux-mm/cccf352a-1a68-430d-83fa-a14bb5e37464@oppo.com/
[3] https://lore.kernel.org/linux-mm/aSip2mWX13sqPW_l@casper.infradead.org/

Thanks
Barry

