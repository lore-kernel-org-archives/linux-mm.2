Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A959C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656C56B0095; Tue, 25 Aug 2026 05:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62CFB6B0096; Tue, 25 Aug 2026 05:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543496B009B; Tue, 25 Aug 2026 05:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30EA96B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:08:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32DD9C0338
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:08:46 +0000 (UTC)
X-FDA: 85139216652.15.17D7E1B
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D43640009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:08:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFWHnpQ6;
	spf=pass (imf27.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmL6uYTyqVpHWhqeQHdsU9G6vcZFB8HJbWZWZuDYhJA=;
	b=ULQEC1Xqpaz1AjLdZ0TVOjabnHtqDp5ehKYNq00BFb9+Zs/kMTi1U+JHIVaQ4SWMDB8Tov
	mRz46yLwdrd4hezQd/NGM3SpUYH1SoCgmR1qsfizafF2/3QNJv7/drXYn61EooCJKpoyUe
	nxJHWomN8vuDZ+cLLKSRmF7AJP6aTeM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFWHnpQ6;
	spf=pass (imf27.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648924;
	b=ZGvWzE/wTVsfXzD3ooiUJ0mxGC2cyLoIXI5aOZegxllUbuaKNdp+/UYviBJEqDTmi7isUT
	JzGhRPEAh/xp/EIZNvig0Kqr2UXHN9LqoFPQYCNrpRjWkfH/wOOfeXEGC2vHML33b03gr0
	Qa1+4v1Jw0iXLpTwNvZXtkLYI5ElllQ=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso636423866b.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787648923; x=1788253723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GmL6uYTyqVpHWhqeQHdsU9G6vcZFB8HJbWZWZuDYhJA=;
        b=cFWHnpQ6TdkXvSVayF3V/v+HdM7zrs/CHgKtpSO1/uvNC8cCQii2DpSTVUZ5hRpUEO
         TX5Fuq1YigUtD4l1FW277x6+p7Xi7xO4QpEPb9nagSP2UjExYdtkbTSB1SHs74vUHKK7
         BipphzEgvvifJYGkLz0uwFMyuv7aBpIGaWWH48GY3JIdz2M+UoIhFjiINtp8ti2qbqIs
         okKUUgK1nVPazWQLJzuuEJtdmikjXNAqanxCvK4nrM47ZHWzhhLMvUq3PaHtA6WSVp4K
         6MTH0IYD4ucl3pBsFYgk9mNwJGfNOJKM89EeQQRWA1xVGd9nItvKIGzGzCj1Y/hsTOX1
         85Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787648923; x=1788253723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GmL6uYTyqVpHWhqeQHdsU9G6vcZFB8HJbWZWZuDYhJA=;
        b=YT0GQpJ3+2lzyZzVy9+WL69zGemQKXNxtJP3CEfmLCcxoGQfqlQ/4rgc2PmQI1UMXE
         I4IE2zqX0TglYZAqAAjGEt+lqHGPeQYH/I4xV7+uItedItB8ofrYxAjXceymnJ39YhQQ
         ovGmUxpZH+hJz1f/ywMmG7LUFopXvHdkuVLxOB94WO902ohvohsJNlv4cZuNhRt3sX+K
         ujMPJ+0mEkbBBF9Bc4CSyKWvmL3UlE1bEgrNSbAsiGLw4wdsupP7p+V2XmgHLwSdEoNQ
         FSxuk748xj2pYSNcN3Kn9f9oIoTXF6J5D9dPt2y4S6neJ80wiuuPhq8of3IVU/t+P7b2
         OmwA==
X-Forwarded-Encrypted: i=1; AHgh+Rrw/CHjtXqWsa6X2CuehICtJP3hCwwoNuNsxFQoenZsGgQa/3CgyD+bRbczcDe+tzGTYH+UDhsCpw==@kvack.org
X-Gm-Message-State: AFuF++nqNX7WGVz2GEpx+lTDttLm5Rt+5AJYwGWeWDDsAaIOCzeGuLv1
	ynvMg8ZWGhQJfE7Vsa9p06/D0UR8HyZr0OMnHCxCixKOsh3wdoZwc0yC
X-Gm-Gg: AR+sD10Do87VblOdwxnr2gV3tgkKUsbKo4ey4Fsz+oALluFgYtX9HGDM821nPw7i4Ne
	CHkUIzbC+HfPn8jkd2VGFplDdw/afit5xR68oUFJd1RUJve/YgTEDGa/vbJlVC3U1XCVYFN4Hnx
	B5SHtDPRZlcu7PEjg8TCYby4a5kAeSGSIT+YMIkVH9GijYELE7NYR/s0Am1VhK8NrLfxMpPtcN9
	z0nBhZ5M+lu9gDgdcT4A09IfKRoKLcOc7Xn7SAkKyxp0nDNmo4HGWpc4oDXq/PGQ5z5IQb3ulP8
	baz6n8BUyyrBWkW+VJpQTI7yQWWOr/AYrLSWU7xR3CD16sMoBgZw/nZLrCZOAlg6sop1u+ZWT2z
	+6vrujrPUgDGPnF4Db0ZO5knK7W/ewvIvn8M/QNsEd/2XsXUqiaZsYI4oXraBwDYflfaFSi4nah
	Vzo2CPB034pWScovWQlCq8jODmNTQ2IfWujbi5+WGEzlTGFAvo7bAzfdgRGstzkLUDb0CAfGTRy
	md9KrHIxxX7aIBtK05lVhMv4Dai5cDDdMK/GOsbFz/Cwa+0YyRj
X-Received: by 2002:a17:907:3e16:b0:c16:3074:657f with SMTP id a640c23a62f3a-c246a4ce3b8mr3646590466b.9.1787648922702;
        Tue, 25 Aug 2026 02:08:42 -0700 (PDT)
Received: from localhost.localdomain (46-138-191-2.dynamic.spd-mgts.ru. [46.138.191.2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59dd550bcsm13565742a12.0.2026.08.25.02.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 02:08:42 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting arbitrarily large entries
Date: Tue, 25 Aug 2026 12:08:27 +0300
Message-ID: <20260825090827.64550-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b682a12f-ac03-4032-851a-f4f7ced4ffa0@kernel.org>
References: <20251117224701.1279139-1-ackerleytng@google.com> <20260824194755.216000-1-iprintercanon@gmail.com> <aoyqIBz1EoY0R8qw@casper.infradead.org> <b682a12f-ac03-4032-851a-f4f7ced4ffa0@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eqy91s159zbpfhxazxs36gpkx41psgth
X-Rspamd-Queue-Id: 6D43640009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787648924-846778
X-HE-Meta: U2FsdGVkX18/OQXatSQv++EXiLlTTKZTU/aCsWSJ9Snq3q/fwnHp0LoI79OsjC/++GBOc6DPXZYU66hCMrmkCGskUVS6IM9Uac5kKzgloJuGUV02hqheOwBeNSwQo8Wjj9d9zFHfw94x1gMdAiYnyC6TnAZ1d8JvHfdrzBA6imrygq43rVPOvlj4+wlChuBjnglvH2vDz7o1WiCL9gLRbieHHEFnogdaZa8d4h4Yg+XIBorqrExNJZVSRYxSgjIcYxamKF3xqobMWz8yeDt5pILihRd/0PPcMugd9d7mFJSP3U3SZoKZvDsVUBbhwJASOgaZj7qdhpCjphoXzA3ZFRcwa1CT50+4NSUVgMwyzGeiTNXYhwkAVh6wm1JbkrxhJkp+LKd/7M76Kz6NC7hUOSAujC7u+TbHXENQtZxxoxAjZS4MaHqI5fDTO4tKQ/xajg9ZbWSvfkAfMw9IPhMmqXvLq0++6jWXKXKNlzmf6ff9iLrshLesXXdsO0xlR5PXhzbpUczwDhjStvfZ24Rz54tPzpfSjaWj7MDRWgCvJJu3QHWi7Nn0bdWIMOH6Lp9uo50yl+MFPW3n9qQSzzUZnX8AJPHZwhI3KLoOt6ymkzsUbc6HqCKulBy5+Qvio8WRWuh2Dxm5vG1czhipPNvctCMHUYvoZ6LeW/nLIxwjRB8YwFm8tNBlh5yJvN8z6BSo2c/SS1aV17EqUcWSVNWCQndmW844HH0lILWi798rRVZqhRZ1kv7j1Pa5g0ovACs8VyRqw0aeA/7jHeBL81FujOz5QGaEJT/l+WAeU7jiLce4odLlja4V7E7U3gZVfaVLCDQrd2xSn832qoIuB6y3g/kmLxgr5jU5edsw9S00Ec2/HlJ6j6uGIX989F2zS/RB8bRpUGZ3jpVrtpupaYlks+vRU6VTKOp+1nFIINPczqjpFbKcHdoihi5+wl3Kxk0kxQQh+mDM/UMSvSRM8RJ
 p21pRvoy
 wegp5NhtKsqflcelz2mhbdYlQ/4HkswDlnxUa+66rIemVLTq58frcQiVdmFajU327weVy1g6cL6A2pA3P8qZpfM3WojqHC89MOQePqe3TRejXZQoycfoNTOOiW2BzxGw3QHkc7xIlworOxgT1/zkGYI6nR9/8u6uO0x3spN/zjA5JTAVUKLusjpaDdwOEu1vq2GWckXSYnHuZSdPcmTMhbQKLPdqObwZQYnQRUrBQY9awTypiDQ1doCEzR4Kh+4eDBDCVM55NBE38WPMUsE8mgpXgAArIi/S7RNa/v9UNKlGszgSCXMc3k+CyWRMIZUOKWoKZC1olyNHrlIy3SgzZHVucvt9HgiHlD/NxLAu38+uEb9MslDXzdG3zoK2oN6u9D2obaO288EbBUmfqvNLnwnp0qpLAGLIO0hw6qaweFYCpDcZ0keEprtDBa5G3N5Oau0yZt8Wt7uLOSdmn80BAgyUD79ci+Fir25Yd9mZtTw9GWNSu3cCs6pTFWeYWEbCz1vQ1JBrn8sbulJOZkvFhOZMjMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 10:31:34AM +0200, David Hildenbrand (Arm) wrote:
> > IOW is this driven by a real need, or just some completionist thing?
>
> I heard some use cases using 512M THPs on arm64 to back VMs, but it's mostly
> anon pages, and not really ordinary pagecache.

No real need on my side. I took the pagemap.h comment and the selftest
skips as an invitation, and the one 64K user I can find on the list
(Meta, in Kiryl's collapse RFC) says mTHP is what they want. Dropping
the arm64 angle.

> But a buddy-like split is clearly preferable. (or avoiding splitting in the
> first place :) )

That path exists as xas_try_split(). What's left is the uniform split to
order 0 that __folio_split() still does through xas_split_alloc(), and
the only one asking for it past order 11 is guest_memfd. That's
Ackerley's call; if he wants the rebase I'll do the mechanical part.

Artem

