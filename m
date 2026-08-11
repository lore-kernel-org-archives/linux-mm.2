Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7734C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C026B0092; Tue, 11 Aug 2026 05:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13966B0093; Tue, 11 Aug 2026 05:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B5E6B0095; Tue, 11 Aug 2026 05:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5AFA6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:23:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A9BD1A02DB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:24 +0000 (UTC)
X-FDA: 85088450328.15.DEF39A3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 503974000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EbtKTIPx;
	spf=pass (imf27.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786440202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fo9j8kdnZ3d1Cb7R3JXH4+6v4YrCB+a7W8evI8c2Q1U=;
	b=vv2/xdIMnwDF3u8MiiFQ47DyoOx1ZwLhBNEqBCC8rj7KoIQsEKbse+ajbiz//y7wsXnCS0
	g6VnaRhQZTQtpkHkgvX/wciAc6oSai9lQuky4Gmlwec8Ul666ENOBpkyFYd6iN5vkyFfYD
	txRhLvTmvnXZ9iy8iqJ5JpEKDOnNM4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EbtKTIPx;
	spf=pass (imf27.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786440202;
	b=KWHOjFg0ExqBlUNc7Ygizl85hn3OsiFNlmy/fxYurrqP49XRtTMyjUMDjiH61vgSy4O0Mk
	zEHr3U4TWDpCu1LFP6BKybSNbYNtmQbadOoNoHq/b7sTCeiomkd1WagVQlls14jAJo6oMw
	KhTdjtUyonJ5UJJJba6+gx8QkWQVUzw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fo
	9j8kdnZ3d1Cb7R3JXH4+6v4YrCB+a7W8evI8c2Q1U=; b=EbtKTIPxIWSGrnDo9o
	rLyi9otRSvWLd4uSSBTkMpjsQuXJq9/WSDYQRGxt9rcXTl6Oqz/f3TIH7ifqyeVF
	5bkyNRy3ToVrnoH5eOThDU4ykIlo1z7Tc9G+vK0hiudifoT1gwNpHTVuWiol5XkR
	EcziWewFP3XaFau8tqxifYL6M=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnRqbR6Xpq5jVXPA--.54025S2;
	Tue, 11 Aug 2026 17:22:27 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: brauner@kernel.org
Cc: akpm@linux-foundation.org,
	alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	chuck.lever@oracle.com,
	corbet@lwn.net,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	juri.lelli@redhat.com,
	keescook@chromium.org,
	kuba@kernel.org,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Tue, 11 Aug 2026 17:22:24 +0800
Message-Id: <20260811092224.2068821-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
References: <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnRqbR6Xpq5jVXPA--.54025S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRC_MVUUUUU
X-Originating-IP: [124.77.128.89]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC5xPn8Wp66dPLgwAA3A
X-Stat-Signature: yp49jwgno146mjqf3yh684dou81g3fge
X-Rspamd-Queue-Id: 503974000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786440200-39441
X-HE-Meta: U2FsdGVkX19XqQGGTLIgGCiKKr1DVKPmCsDBtdV+i2IQ88SPqcwjk9MAqwmH81j3O/QibHFEETpLa3VPfsSFbzeNTCTt7YzqSy+pvlVyQPFOLn3is93jmlgpsnZScpPxdkvlgRchYRh1D1t09rFSky3ZEMi4uah+nwF4X9BnhkrElB5z/2YaweyiEPTDXOkTNLV7qG0JlZq6nl1fCXT+F8SFTPgeFrX/9ZJEUjZsL7ccQyQf6QWGY3OYVFd36wfO9F49uQbcrY85cTNeZrKVeszLh4Wj9ObGauNHUyjPGDg6iPQRAmSHSb369SvQ7vNtKPGEDNZqw5Md371tVgEKf75bAPvcl6Pjug6/L+/L2NdLTE+dVhoGxwHJarIHYxW9O6gztrGgGzBDYnQY7wwqFspsGnuiDc216F0fiParXM6ncfTEsSYCdawR4wtF/dcxSm0CxGK1IVg2sQR7zpv3/kHNSOwBmSHxolVPFYLu+9fgs+WIqy4O7f7b7trdOFkKEN7slMV5n5iN12rNSJYe0H//9grkF9R/Aub2RRcP9ibE8Z0smDg9/hc4/pPQw20Kky4K8xl5Cz4wF75dmGWPisnT0EU44IofFxjU2io8Ruk1V8S3t6uwDXmIav/f+0bhag3o3YEVW77yIdqvc2W66SwSmBSR/Zxevx5cFoTM3JOLQQ52XfRhm0v5hAXim4ZiUXz4U/XCvu3jAZ5kSe8wB6wSJskX4DJ8fnmM5T33yHOem3xVm4bo1awtg2997I7Y2da0GgQRbVxCJvjZz/0saAYQcZLfRqXYtH3NUgNUK26YnrEksHuW1CTGW2l2EUgoCoL6Ba2xvb5gbzdc8Gnt1HNbtjd2lDuMheO8ACvs4+XHcM2VgEujsfPmvbLWLJBCPbobLv26AQ3Dwvd5HiA2c3Fyo5xFG6nbgj63+rOlEV6eO+8kBv2ut9YKeSJ5TaBhESlP868S59rLKyh+WJL
 gnFvc1Vs
 7DNiTQxHRDEBqW16AakBf2Z1fZArZQYb3OGdNKHCGD2HpnbytM9Nt2p5PONY/hof/5zezjo5mt8WqVsAmipTX67j+jjdsXBt/ckICsf/5U5pJ+uDGNzZjihAzbsC2BlDUthJs+xcwIk/BZW9oOken7Hnqy0qASIxREsb1tKATeKghwzbFnS69pazcJFcl8pb7v0gkBnC/i3pyTR7JT0EfPZ4XKEVXbPUowGtYvBVr8viAmRD+wWbiROXwvPlQzsmTt+aWO4WZloX+GB3bDRQzDeCx7f5uYXtOIQBMTu6zbH83DNyc9IgKo0/4RjPf9OlcrJ4W86ZBRzeTiYBnvvhTQ7uAR07kMnsXoqNiW6sNVhuhfJu8UCXNWUJ0XzMaIiL/dNFXz/sOKb5jSPyzZ9IKHVOmkZFCsZKXiy1dtXIRll117FpeqJHbTzvdq7qRITfDCy05rh7UtKV2FhfCtdF0D+1f5gzYySSIAgNTKPEoBFnxNFj+MWUBGMjDy08n/gVPilx1xvU7chrjBA2HHT2Id52O7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 11:09:47 +0200 Christian Brauner <brauner@kernel.org> wrote:

> Fwiw, I still refuse this patch for the reasons I mentioned in the
> various other postings of this...

Yes, I know. I updated several versions because we found some obvious errors.
Perhaps there are others like me who have the same needs and can benefit from
this patch. If there are no new special circumstances, I will not update any
related content regarding this patch anymore. Sorry for that.

Thanks
Xin Zhao


