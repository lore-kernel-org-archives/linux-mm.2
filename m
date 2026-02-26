Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA48BFD4603
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3BC6B0089; Wed, 25 Feb 2026 20:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09ABA6B008C; Wed, 25 Feb 2026 20:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEBC6B0093; Wed, 25 Feb 2026 20:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8DD66B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:38:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68D361A0384
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:38:46 +0000 (UTC)
X-FDA: 84484898652.20.96CAE04
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 732E740006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:38:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=alfh4g7z;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuUfKqLF8pxHEU0+4gJWx2JSltGDNKQcxuvzq6VPwys=;
	b=SmBVPpAH36V7N+5DNA+JpPK28/P2rJWqapI0FE9yH+Fb/7UgCP3o9wHk/eWLDETyCnbqx4
	bsilCNDpyrZmHJa8KJB34EQkMTePCyLRK/xH+GuAZSKZDcdYq8jqI5drXc3SjPDypYWl6W
	Ltza+xHuRb//y0TsXLD/bhaOXtWm8uQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772069924; a=rsa-sha256;
	cv=pass;
	b=jQSjz0lnjxJ6VjQaU+AY3+G2tA6zSQi6ULWGv6jWPxVOdBk0JdHMx2LMSsG/h/uTRaKRy8
	WWG18rSYOmLc3sdiYMyWu6XupDKSxgjN1RaeDnwqRrKAeh9+DcneTe/YXg7nZHhXy1AsAQ
	nmONyTa9OuCo0KJ1pAXaMcXzrluEQV4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=alfh4g7z;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q1C2Lk1688116
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=RuUf
	KqLF8pxHEU0+4gJWx2JSltGDNKQcxuvzq6VPwys=; b=alfh4g7zGnrSJ3TqRJyt
	V5VcP7SDepx8NVi9vJhDyy8L5Ls5WE/RWZYhX4Ye5zukU4YSUajOuvw1hNA49SLE
	5MCVRYtKvCE10uV6CF70YwJulwzlLq4K9ukFkzKdcXeI/Bi4+EtJZkspWAQ/UxiS
	UAuXF8AJf0DZPpM47meX39PRepgBYuUes92asCRQQlWsHQzL/m7InreMTYXDR9TW
	g9tmlQQeJIjnOJXInA+ga3C6te0MJzR7Zh/RoLFz0L+iV9g1io5ESlZXDEXLNu3F
	RFDI77ScZHeVnIcmjYeOTWjiKdR4Xi3ro4xpWY03zOhgiOVRG1S+fz6senjXOYFF
	qg==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4cj116ebrq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:38:41 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7985951fa83so6618657b3.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:38:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772069921; cv=none;
        d=google.com; s=arc-20240605;
        b=bA19XNm3Vwwo+eG+NFY5tiv+eFUQOJwvoNTzO9fJDXLcY2xjMZm8rk6KEFeyidH0Pz
         nJFdV+aHLX0QXftQLKDCmh6bWtigAfL2Dq6fB49G31msFsRImDHyaoiuUWbCI4ex1iyk
         7rSFAbn9W+dRB5nnW+WnkjqSXf+hp1PUnj/iMDuscwVOZ/MJrOwXbqIo55ut5qv+tAIX
         mN0PXTQtl5YsAZUXAg6dfSviuMIJxaG0EP/B/m+/CpVnEbREc6gSnig/oqSy1W3EwX7B
         G1NW3mbcCG+kncScRWAcv+xQRD9cjoary7imC96WrGpV/DvHINyBM1nG4c7jnUHTyQ/i
         LCIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=RuUfKqLF8pxHEU0+4gJWx2JSltGDNKQcxuvzq6VPwys=;
        fh=prHoKedh3RcAWxG0MfUxxFM5gWwdB2fo3/9cXAO8M5Y=;
        b=FnLDZ2rcRbxN2RYmiJtFxY4nB/FQw8a9+QT+uj0XX93s8IwgWf4Ern58XXAF1La1gR
         EyMwovZAc0XBQv7+JEdwAdRsfSbasMDfqlELz0Aty2QGTMCgqDN+hIu585YWtbrVqUOq
         SaYfjnHpfGrDI5TM+4TWmsRkCpT7HUCcruYCJlmIHTNaX+dlmTd/lMiQDd2RtCs8upZZ
         9cgPvKZeukOdyJi20ZpRC+i+93ExP24+Eo6qyTlsdAJFBqYh0KRBN6xRiMxSCGqPR02J
         qTWRAQJeVRZMBjwpMkIeCSPKTuSGUdQ3ST2+ak+6CMTub7djdd18LoRmSWgar22pTE0g
         zAXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772069921; x=1772674721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RuUfKqLF8pxHEU0+4gJWx2JSltGDNKQcxuvzq6VPwys=;
        b=txJVtiOBTQptRe4bGFfkPYiibC1I0SKH19fZucTlnX2MQXuH2ZLN0E0Hprxi8G1M7N
         AeELdzldOqbx9ty2GiUJLSCsO90JPY+MYROgOh8WNjZ8CH4d6ymM1EI6A2wTExVfybKK
         xAwFA0XFLZ5gI33/9rFxqdNdC5tUo8S2YSLGUkjLFYbVqYvc1CxjU1UlTAvX9Q38xAiv
         bV6NXo//fwG+1P/AgiwAIWuKGBSSYv9A3btbDKmT2QHX1XvM8KHrTU1xdEQku3e6Mxoz
         ka4rGNhlpmxcULFiOMPqtx2ucGOVpIikJf1gsWCC6IDAPzCjwKm3/K8A/C5HOZhhUfYt
         6yzw==
X-Forwarded-Encrypted: i=1; AJvYcCUJIhjBqHKLNdo+a3VjDnsU+yB7rJTWqUY1JlLlAWrN4YDaMxdvLQlt0DRprsiGeLClAR7bsL4m4w==@kvack.org
X-Gm-Message-State: AOJu0YwsHN3/BCpW52hKxU+rwgIam6+/fRmpNXrWTfKLaWCR9VJs7AQy
	ekrR3xhXMzjxwKSXhuu9MJ9L2Uja1c+FzQD2jbjIGI3pGt9WweeiW0Fa7APpFAPRpxgIVElQSbR
	S7Bjtw/wnNCWVcbQni5SRt/LmYwACm3F3SiQvEM4VdPkitF74ZBSNQ5jq5dI7pJD0heT6gwQ9Zc
	Gk3pi3EGf7MWOB1ufS/QF/HMg=
X-Gm-Gg: ATEYQzxu6MBKSEgBhNqTARA1XhfVHeET8qlugJoxed2aTUNPLHMWVCmwBoc4DHGFZJ0
	CAn3U8wruzrZQdLKXTi5d0dDT88Rkv7CGzPs3/DiuatvWk7LG0ZPUfJQayiaxtZpFZRTlSMJjKd
	n7GYj6yJtuVio6+ZraXBpRhOSQWg+LjIGx2PcP+o/jDjssd91mKDkXsat+Gkv5e6yImMHjhputJ
	gb+mw==
X-Received: by 2002:a05:690c:4a05:b0:797:d268:b587 with SMTP id 00721157ae682-79876c862f0mr5591317b3.29.1772069921007;
        Wed, 25 Feb 2026 17:38:41 -0800 (PST)
X-Received: by 2002:a05:690c:4a05:b0:797:d268:b587 with SMTP id
 00721157ae682-79876c862f0mr5591057b3.29.1772069920550; Wed, 25 Feb 2026
 17:38:40 -0800 (PST)
MIME-Version: 1.0
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu> <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
In-Reply-To: <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 20:38:29 -0500
X-Gm-Features: AaiRm52vdi5fnXqygcUgGP7ud7f8lrEjfwNIkhY8m1jYwEYqu5-B1oSLrvjdDbU
Message-ID: <CAKha_srSdS46FM8K-RKaiinP0y6kx_MhxnHjZ0KKP1NOAL+STA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Jens Axboe <axboe@kernel.dk>
Cc: "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Bob Copeland <me@bobcopeland.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        linux-karma-devel@lists.sourceforge.net, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDAxMiBTYWx0ZWRfX7/Bxtj3NFpmg
 VRPMzylPHoaE9bhzksUd4Ec8YwOLearJzX25hBhUa2eUE9bw/vvxSydoWHq/CGmhhPjoVwfEtPd
 /I2AMl5U/+k7th7RrbZNtRST/p9X9z3bg2P+4BPNOksQNAvDoGJLPMgrq3/EuPFU8rCYCDtI436
 XEsbSqdjPot/zHGXOViCCl3tXChDST1UP1N+ezZztJ6Hzw+6d8gXIr1vVYTVoB/4MF/I/xrJsuB
 Ht8GzMvPjF8trVHJAk1rHBseJosXW9FJ8484b+VM+1fR6EFT0LhMmLiI5Zkx/TeNkem46PEGSCb
 WSTmMjmaSvzTVFT0iD+sarNPNepG8uHqcy618r+rc6RGW1m4q8V7nRlCxHBDtulvd9+/8UKLxzn
 5IBz/tbjiOruoGzwaQUd45kF7l6yoQ21pM3ZUfN7OdN1FBVZcp2U9ZObyMu+cdVLDIPE3NevjF5
 VIhWb46yo1ExzsIUfDA==
X-Authority-Analysis: v=2.4 cv=cYjfb3DM c=1 sm=1 tr=0 ts=699fa422 cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=79PYxaXUQd1wl-QFWJnA:22 a=Sm8IU_2CoLCVsS0ef1cA:9 a=QEXdDO2ut3YA:10
 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-GUID: rDm9amTOIWKyuQAd3nwqQZGTr3DvcU8N
X-Proofpoint-ORIG-GUID: rDm9amTOIWKyuQAd3nwqQZGTr3DvcU8N
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=10
 impostorscore=10 adultscore=0 bulkscore=10 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260012
X-Rspamd-Queue-Id: 732E740006
X-Stat-Signature: 4r71dryu1kfodgtqrz9g6bcqra93uy7z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772069923-293041
X-HE-Meta: U2FsdGVkX1+B/epDSttpNm5gpRmuPTQ93HIPKZQ9m+whhIf3S+YpzbWXy6meQfm1870n4q5neubKvWxeEM175pr78ZUehG7c5XHVCn5hSf7FlkQgOoMVkuFAwmrBbbdjSvuXqi5j9lKpPBWGNgpwwmIU9t+iLn9Amrpg/UBSR9wd4F+3yqXKHU1D/vJrNLPa+wy5Upl3DaYVfXwcmCmGK+2zizlePwJ8EHv5Hl+Un8dnteKTCSh4uNU3cj0uwTRAgQZ8y9FIxr9kuqip9eX6ROe5dVn5VBxpAKVAoHuRaQf8PSqNkSgK3Q9kbMTeGUjLdxmX713dyyclnYycka15dQA/PE3UW6NsJ3B1aDMKIpLomFsutMmbJIM4TVz8e3q4UfFsEbWusmoOttC1XYIOVa9CvTjAzIqaFsTt4vPOTj9OnLBJCPSKXaymnJ4+mIftpfPf+Q5mfS9LoyxX0xjQEak5I4xy4lCGxPsaxvSA+USIrF7o9Qtsf79NMW/0Ob8SJr/mLTl6rOjGF39NdR9ssiyGf2V9n7o3caWMT4uxLBo66akyZvd+Z5fxw36d1A6IseEw51iE53FdaijpEQi+4R+84s5/wxIpbUec1+SB9IwIbRIiLD9b8SRzBh0q719t5Vc2K3IiHdrXiLQdkp3kjv/Rq45v6JJ+VGxSEFRyhvrDYQlhKMn7/REtz7cmCTHGiwdG3ovTtED2nTCMEttuSD49Q6hxMJ7dYMxUGAxowE+wk1AXTqZA8GYw7FeIF+4dhJx/mMm70+qXs1gtz8PigZac5kwEs55mhbqjLS7qkP0UZzytbzQYmp8pfSe27GftyGdUKzm5/KiCdS02nXJ00/baoGuShnWuPgJ1zDL3d1c2XafAL5hq7IsuJuUGRxk9torKqAjsL3BbCWcU7OQQ5Y/TkgEKLxADOmYW4QLJl1kqYnHTM24R4EQXTOViNIjJDZjVRnSd1g965p4Qu0o
 j/cyp9B+
 Tio721ALLkxi+4Z7Q8Cg0K7xK3SFxwqRKZLe/vPGcdm0XUrJaprkRqzTdgZwyF351bIpliGAee9Vboc0bjISIqwEZkwCJkr1X0EjGnv/JFGujB3XFHbPIB9Uo0+x5kF62/EhD/vS9zpvCCcfyoAXzL8Fc2BJCeVwD7p4ZGdD10i3nIyL3fEV3Hg1GUC6ehtpee3cBAK63/yb2ZayZsNXSga3WfMU8KdC7UdnIvc9S37YNJ6xBBnVYxQtN0D1YawXBx8Y1s0gGQe+yiY/TnuPaqlGKfLJIZdvEyN5oQhUnrMB0LOMGDLc7Is5DsFa2xBzl8gLOqF+TmA6evKY8ipfr6/hnzEy5oEwRhuBNgZoCycW/ef4/bS+PJfFGRbhU7zmZ+cQ9WRg1kLFmYPZxeCSjv1UKyT8e1azNK9xsE6587Lz4i75jNC+gpVKoGPQhbLb7SsryrcaHimq6EwUypllvdTVExDe8XYwR8DayKU8z3WiyTa0jE3wm1Una/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 5:52=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/25/26 3:40 PM, Tal Zussman wrote:
> > folio_end_dropbehind() is called from folio_end_writeback(), which can
> > run in IRQ context through buffer_head completion.
> >
> > Previously, when folio_end_dropbehind() detected !in_task(), it skipped
> > the invalidation entirely. This meant that folios marked for dropbehind
> > via RWF_DONTCACHE would remain in the page cache after writeback when
> > completed from IRQ context, defeating the purpose of using it.
> >
> > Fix this by deferring the dropbehind invalidation to a work item.  When
> > folio_end_dropbehind() is called from IRQ context, the folio is added t=
o
> > a global folio_batch and the work item is scheduled. The worker drains
> > the batch, locking each folio and calling filemap_end_dropbehind(), and
> > re-drains if new folios arrived while processing.
> >
> > This unblocks enabling RWF_UNCACHED for block devices and other
> > buffer_head-based I/O.
> >
> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> > ---
> >  mm/filemap.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++----
> >  1 file changed, 79 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ebd75684cb0a..6263f35c5d13 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1085,6 +1085,8 @@ static const struct ctl_table filemap_sysctl_tabl=
e[] =3D {
> >   }
> >  };
> >
> > +static void __init dropbehind_init(void);
> > +
> >  void __init pagecache_init(void)
> >  {
> >   int i;
> > @@ -1092,6 +1094,7 @@ void __init pagecache_init(void)
> >   for (i =3D 0; i < PAGE_WAIT_TABLE_SIZE; i++)
> >   init_waitqueue_head(&folio_wait_table[i]);
> >
> > + dropbehind_init();
> >   page_writeback_init();
> >   register_sysctl_init("vm", filemap_sysctl_table);
> >  }
> > @@ -1613,23 +1616,94 @@ static void filemap_end_dropbehind(struct folio=
 *folio)
> >   * If folio was marked as dropbehind, then pages should be dropped whe=
n writeback
> >   * completes. Do that now. If we fail, it's likely because of a big fo=
lio -
> >   * just reset dropbehind for that case and latter completions should i=
nvalidate.
> > + *
> > + * When called from IRQ context (e.g. buffer_head completion), we cann=
ot lock
> > + * the folio and invalidate. Defer to a workqueue so that callers like
> > + * end_buffer_async_write() that complete in IRQ context still get the=
ir folios
> > + * pruned.
> >   */
> > +static DEFINE_SPINLOCK(dropbehind_lock);
> > +static struct folio_batch dropbehind_fbatch;
> > +static struct work_struct dropbehind_work;
> > +
> > +static void dropbehind_work_fn(struct work_struct *w)
> > +{
> > + struct folio_batch fbatch;
> > +
> > +again:
> > + spin_lock_irq(&dropbehind_lock);
> > + fbatch =3D dropbehind_fbatch;
> > + folio_batch_reinit(&dropbehind_fbatch);
> > + spin_unlock_irq(&dropbehind_lock);
> > +
> > + for (int i =3D 0; i < folio_batch_count(&fbatch); i++) {
> > + struct folio *folio =3D fbatch.folios[i];
> > +
> > + if (folio_trylock(folio)) {
> > + filemap_end_dropbehind(folio);
> > + folio_unlock(folio);
> > + }
> > + folio_put(folio);
> > + }
> > +
> > + /* Drain folios that were added while we were processing. */
> > + spin_lock_irq(&dropbehind_lock);
> > + if (folio_batch_count(&dropbehind_fbatch)) {
> > + spin_unlock_irq(&dropbehind_lock);
> > + goto again;
> > + }
> > + spin_unlock_irq(&dropbehind_lock);
> > +}
> > +
> > +static void __init dropbehind_init(void)
> > +{
> > + folio_batch_init(&dropbehind_fbatch);
> > + INIT_WORK(&dropbehind_work, dropbehind_work_fn);
> > +}
> > +
> > +static void folio_end_dropbehind_irq(struct folio *folio)
> > +{
> > + unsigned long flags;
> > +
> > + spin_lock_irqsave(&dropbehind_lock, flags);
> > +
> > + /* If there is no space in the folio_batch, skip the invalidation. */
> > + if (!folio_batch_space(&dropbehind_fbatch)) {
> > + spin_unlock_irqrestore(&dropbehind_lock, flags);
> > + return;
> > + }
> > +
> > + folio_get(folio);
> > + folio_batch_add(&dropbehind_fbatch, folio);
> > + spin_unlock_irqrestore(&dropbehind_lock, flags);
> > +
> > + schedule_work(&dropbehind_work);
> > +}
>
> How well does this scale? I did a patch basically the same as this, but
> not using a folio batch though. But the main sticking point was
> dropbehind_lock contention, to the point where I left it alone and
> thought "ok maybe we just do this when we're done with the awful
> buffer_head stuff". What happens if you have N threads doing IO at the
> same time to N block devices? I suspect it'll look absolutely terrible,
> as each thread will be banging on that dropbehind_lock.
>
> One solution could potentially be to use per-cpu lists for this. If you
> have N threads working on separate block devices, they will tend to be
> sticky to their CPU anyway.
>
> tldr - I don't believe the above will work well enough to scale
> appropriately.
>
> Let me know if you want me to test this on my big box, it's got a bunch
> of drives and CPUs to match.
>
> I did a patch exactly matching this, youc an probably find it

Yep, that makes sense. I think a per-cpu folio_batch, spinlock, and
work_struct would solve this (assuming that's what you meant by per-cpu lis=
ts)
and would be simple enough to implement. I can put that together and send i=
t
tomorrow. I'll see if I can find your patch too.

Any testing you can do on that version would be very appreciated! I'm
unfortunately disk-limited for the moment...

> >  void folio_end_dropbehind(struct folio *folio)
> >  {
> >   if (!folio_test_dropbehind(folio))
> >   return;
> >
> >   /*
> > - * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> > - * but can happen if normal writeback just happens to find dirty folio=
s
> > - * that were created as part of uncached writeback, and that writeback
> > - * would otherwise not need non-IRQ handling. Just skip the
> > - * invalidation in that case.
> > + * Hitting !in_task() can happen for IO completed from IRQ contexts or
> > + * if normal writeback just happens to find dirty folios that were
> > + * created as part of uncached writeback, and that writeback would
> > + * otherwise not need non-IRQ handling.
> >   */
> >   if (in_task() && folio_trylock(folio)) {
> >   filemap_end_dropbehind(folio);
> >   folio_unlock(folio);
> > + return;
> >   }
> > +
> > + /*
> > + * In IRQ context we cannot lock the folio or call into the
> > + * invalidation path. Defer to a workqueue. This happens for
> > + * buffer_head-based writeback which runs from bio IRQ context.
> > + */
> > + if (!in_task())
> > + folio_end_dropbehind_irq(folio);
> >  }
>
> Ideally we'd have the caller be responsible for this, rather than put it
> inside folio_end_dropbehind().
>
> --
> Jens Axboe

