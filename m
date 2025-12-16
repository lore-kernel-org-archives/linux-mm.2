Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C323DD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332A16B0005; Mon, 15 Dec 2025 22:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2CC6B0089; Mon, 15 Dec 2025 22:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF286B008A; Mon, 15 Dec 2025 22:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE886B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:12:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A318716041A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:12:28 +0000 (UTC)
X-FDA: 84223861176.30.F5FF1FB
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id C5BCC40006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:12:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBtrHBaq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765854746; a=rsa-sha256;
	cv=none;
	b=g3LvB9JspPNSEyNaLDC3A1TmauOMirMszLd0h2FQk0lyHFtdThrsPpwG773tTtwhWISv47
	faXaTOdnNXJp4oGZty1eP8GXzO3zyjIqpHSaGTsXPllgKY68oZLVWX1TIX3PTOsQprK1Bh
	yGotnkvG47VuSJDfHsYlbU0bbRDZovs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBtrHBaq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765854746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1XTKIE7lS6ISh9SSrfsgd7hwp0qO7clmkEC+ykt48o=;
	b=fXTFVS3XmgbvaY240SjZ4+mxkrFwevEKN/JqXJ607irarIJxntVUoKilk2IF6yDB/1WXWe
	uxtRlUJo2tt15yW3z8wScfGX7O1KjL1wxcLpuQp05WLubfNafAZK9MyXGcEWxSYSIAz+4e
	dZvGD3Oo1wu2B0iMZAV9e06IeN1g1PM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so4726578b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765854745; x=1766459545; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v1XTKIE7lS6ISh9SSrfsgd7hwp0qO7clmkEC+ykt48o=;
        b=NBtrHBaqfy09pJOFcBnfS77WwN8lRjDkVYebaFckA/rnQMrNbopytbVhFtLDTWNBsu
         G5QOPWNARAIxz/lbxv8VwgNn9AMH2AUUmk2japoylqfpi5dBehzJs7hcdiuaA1n2aNxT
         WkNQwxzab4ilPFmB/AvOqak9o7XhGIo4RDL33MViJdrYVSxm8ZKC/AE95A0Dvn3tIIGX
         imtTYqrYw3HDiei1Ec9wuZrSbtXHdq5JpELkvT52lGZEG5Zp6X3NI53Pvr7tKdcRbqXg
         +nBsEkmRE8y4PjcGtUMAei1ybqQPO+s4ernCCjT9O+8827LceEjErzh9+pLzU0iuCJ7p
         6G+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765854745; x=1766459545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v1XTKIE7lS6ISh9SSrfsgd7hwp0qO7clmkEC+ykt48o=;
        b=VfrJ7ssUnW1nOG2haLKSWEnp/gf6zT/tpgOXx6M84KCht8WgS3ismIDO7aincAzLs3
         tDfrfQwFWsCsn0gB8MOo/PPgMTTvSet+cPEnicLrE6/kyiIiVFQezn7OYcArUmnrSghE
         BOe6bzs34MDkmP92RBwiX5zq498qicT4/XhJK9dxppQgfC4BMMuXXBrTX4KIsowVLFXc
         1PaM00GOxb0d2aMBLAx7bbhNk+DWiQVyxDy58EzL7rOZBybWRoOQ2VrCv2/bi2fh6Hyq
         sUK8/s3osro3EZWTaXMMXjLHvZi2MhlXdx4rX7WVHaZnwSnmA2taKpkp5fKdX2uqByxW
         12Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXWjpDdCGwav2EbNQJ5rZF1tZxhcysX0+4UhlIFYcQjG+5ESP2N2tqIwdBOCnQMtdI7WjafxQIRrA==@kvack.org
X-Gm-Message-State: AOJu0Yy6e7ZKInOM6VFgD64O0hD1l7JskT8d9uKkNGKZYgOTspBtWwUF
	cAVJfSOYDZHKebq9p/bt5IqSYSC9T963zraHQH7sydXqqrzkrAqkLRta
X-Gm-Gg: AY/fxX6pRbJA0lJvWC26pwYVYlp8+T24e34uMNyBudbWwzBtM5b1RnsyA5juPMuIkst
	RpQcMNkBEMM+2mmuLeWjQMyKOL9AjPPCgcogsoCykk695dZPd3uffFL4L5k6Hx7dgzkZ95ugsLx
	2Pu5h6LfoXk10ospsHsotzaRKfeAWKOyF/IfSvb4BCGy+zvEGviMBqLu0N6zMhIJwJGsWmUKsjN
	ww1KlQEjmab7tOPcaC9QVoHKJqcY725L6FtX+yw9pq6RmtzRlcWDTKbnfFULPUDtERoGsDa4zfl
	XoiECNvmjlITCW4DvKAwedBpNrSVJt59gj4Fh8JrSXhcHK4MOqzoLYJMKfB1afCugh1pUW+YaJT
	m9KWQ5mD4kXrB4PzUFM+KQS+1RtI1Nmmhn69co0g0laWDZRiXqdDcJCcdWX2aasYfI3PILIZ+PX
	dMdMA=
X-Google-Smtp-Source: AGHT+IF0tz0zYbc0FACU6KRTQzZw3IhUO2xklXRdt4pY23/rn5onAkq4lgOwW+t2ZMZ15thjO9SINg==
X-Received: by 2002:a05:6a00:288e:b0:7e8:43f5:bd2c with SMTP id d2e1a72fcca58-7f669c8add9mr10107967b3a.65.1765854745459;
        Mon, 15 Dec 2025 19:12:25 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c585cde0sm13791160b3a.69.2025.12.15.19.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 19:12:24 -0800 (PST)
Date: Tue, 16 Dec 2025 11:12:21 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com,
	syzbot+fdba5cca73fee92c69d6@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/readahead: read min folio constraints under
 invalidate lock
Message-ID: <aUDOCPDa-FURkeob@ndev>
References: <20251215141936.1045907-1-wangjinchao600@gmail.com>
 <aUAZn1ituYtbCEdd@casper.infradead.org>
 <aUC32PJZWFayGO-X@ndev>
 <aUDG_vVdM03PyVYs@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUDG_vVdM03PyVYs@casper.infradead.org>
X-Rspamd-Queue-Id: C5BCC40006
X-Rspamd-Server: rspam03
X-Stat-Signature: 34eory139qfttb6kzqt8p3zzehnq9i7p
X-Rspam-User: 
X-HE-Tag: 1765854746-49142
X-HE-Meta: U2FsdGVkX19LdTYx7rXtn/BDgD5GN+eidXtorZD8VF8+iwxK3qhkAMSHuyF9EXpidtc/GBLnLF+RqtqmcHJrin/4Zgs/BY8ScAFJSmlRuCgIYQEEq1zajKJ31AANh3qZNVwYkrMjSaNTCmPCGEnK7LifxvTrk5pcnVSjkHbk/fESoCYfnLBYYh8d+Kk822VMk11iASjKbHUY5uyqa83ar0hVkeH46UlJKMVAxleaFj+MuCS5Y5urnhbnX0ueCnMo43al7ZvyWJW964s7mQzDhcBMfQUa6uQoUptTy/PRrln8TGHL/qEmsJ78Dyj+c8muV3Btcf529XzpJvvlKWnJ6NdE3XjR9OPFiJbxvjjzLQGCPCw0e7f1X+vpdKQA/gb50PvEb4zlFJbk/rb8RmdzePPIUVoFGyiTpoxxoat38DVBPD7PRs/KzDMYll7rCbZjgwHjvZnenpWvWlRc+ZvghVCU5FEpAVVYbN2oRZXm9rgnBUHqjKHzyzgjgCD5C3T+wxyxeiFAISuKE+8Yj03Mo5ASh/S/w8GRlll2uLumoF2fgP4ZCR9sM+nm8IARra4dexe+eJaBRoWMFc6zFOBRRVGkk0dIGQ6zfyneC0Prii8Y6T92Q/Ei31oMRSOAfciRTVYL1F6AozkyRvNvyraeRtHMlANAw4t+rpltTBXcsEPvA90lSdBdpKDGacmCuiW3gyv09OEnemAv1FOFD1Qkb5Aen6E4XQ3mgmFnSW6or2guKwgvA3w4MHrAuyHlTBndpFFhxNEvN4CFQnope0N7ngNj89RolFGN1OUDPkEYB4JET4ogbLQR2lfZs7YoFBbeFVB5vs5FWHWGF2YAbWHEE/JV1/nO7nEuHzIDcVA777NTMzm+tGPaxWD1wH126Cd/14c6kuYUb8LdYruKvOlKQSTpoUjyrgKTDv57OY8qxFP57vJ6/CDkemSiMNxVHzKVAn59qnamG8OyMYBy9H1
 Dzv2SgYB
 Ii4MaCTPW9eL+55ogVUDZqhs4M33RQ8fXFPL5vGcXhjMegYd1RDOwcK2tt+oy2r/kaepot4ucLM802fhgmfJprKzcuil/t+18auk0ctLG974z7IylkakucAA/Q5W2fV1vv/QnGuOv3rIpq7WBBro/GF7FPufXZwNaHyVBSzsisbQ2ptmKTJu6pueLzFSKuxhPpoWNO1gUmauy1KqIyKVt5aFpnF5KKrqglbqri83kjxpU/SYGKlr/Vs1KUOCMjBbwTrmz+o5xT/v8wkySb6wIm/7bDLFQjKyMOTajsoWquHbCrxd3EwDgECDtIfDn32FfnLNmpgI8kMYL/qMiFKPoVZ2oQkdQbmW5icvl5Jstz06vx+sFPyfeL2vur43qVqSvY96M/jnhM/Y7EJG+qTcrS/3OiK/0XNBOZ42YJqSwGvcvBeQJdHVO+Bq2TeuSiWeZ8gjczNqeXoD7tKZhGaoGFxRSulCF8/nCivMb9oZTl5PBLq4QwtkybWiUsoFooep0NHcuvIFjtDtr9JvrJIcSAOrFKkUCRMK6oNyktGYFK+mkdidvPNN3yLHRU3P58xUjDY6BUKypU1dSetbL+eRIV9uZotnsBgTTWHI57n7ldzAl2acKyXqi50ex778oXVUKH1tl387rGOLoX5Tvy1egBz/KtoEN6p0aGCw5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 02:42:06AM +0000, Matthew Wilcox wrote:
> On Tue, Dec 16, 2025 at 09:37:51AM +0800, Jinchao Wang wrote:
> > On Mon, Dec 15, 2025 at 02:22:23PM +0000, Matthew Wilcox wrote:
> > > On Mon, Dec 15, 2025 at 10:19:00PM +0800, Jinchao Wang wrote:
> > > > page_cache_ra_order() and page_cache_ra_unbounded() read mapping minimum folio
> > > > constraints before taking the invalidate lock, allowing concurrent changes to
> > > > violate page cache invariants.
> > > > 
> > > > Move the lookups under filemap_invalidate_lock_shared() to ensure readahead
> > > > allocations respect the mapping constraints.
> > > 
> > > Why are the mapping folio size constraints being changed?  They're
> > > supposed to be set at inode instantiation and then never changed.
> > 
> > They can change after instantiation for block devices. In the syzbot repro:
> >   blkdev_ioctl() -> blkdev_bszset() -> set_blocksize() ->
> >   mapping_set_folio_min_order()
> 
> Oh, this is just syzbot doing stupid things.  We should probably make
> blkdev_bszset() fail if somebody else has an fd open.

Thanks, that makes sense.
Tightening blkdev_bszset() would avoid the race entirely.
This change is meant as a defensive fix to prevent BUGs.

