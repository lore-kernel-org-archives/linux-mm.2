Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36604CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950028E000B; Sun,  2 Nov 2025 03:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928A08E0002; Sun,  2 Nov 2025 03:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E438E000B; Sun,  2 Nov 2025 03:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 706A88E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:26:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17D655B93B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:26:43 +0000 (UTC)
X-FDA: 84064985886.14.52A5DD7
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id B84F31C0007
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:26:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762072001; a=rsa-sha256;
	cv=none;
	b=DjhNiuJaRjzFmhM4w+5ExvQmKR8wmP9BrpOLsFZBqgWElE0VNr0AgWKeNh4MsIr8AlD1eM
	y5lgvt57xPoy7PqMnP5mPjO27ZD4OXKbrhYRRCVOXDc/Fv8jQ50TAMrQTv2lIxjJrDBFd/
	GWDucYrCt7Y/ZCGxON/J2sGpkOP2FyI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf20.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762072001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hgWx3Jtu53m31vDjdsn2KpsECVBBN3TADGCCsBWR04s=;
	b=pemdEkw0CF73VDqdsZLEIPRYmGktDyjOruyZyYXtU2ByEOepmVmgnyTduBw/udwedrTzqY
	LhLvmCdBAmtIGH4Uz8jo+sqr0zmkqHOo54vVhPI48FwUe6enDgBaDotkvd4jhRMlXsmh3K
	hJlC6dqL3xt6HY3QPij0u5nKy+9PNKE=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 2 Nov 2025 17:26:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 2 Nov 2025 17:26:37 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH] mm: swap: remove duplicate nr_swap_pages decrement in
 get_swap_page_of_type()
Message-ID: <aQcVvSMxHtvYZCa9@yjaykim-PowerEdge-T330>
References: <20251101134158.69908-1-youngjun.park@lge.com>
 <CACePvbV=Br5yiaXOdyC43Dz+6eUV6GfyxqCsGPG0e6kggT84ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbV=Br5yiaXOdyC43Dz+6eUV6GfyxqCsGPG0e6kggT84ig@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B84F31C0007
X-Stat-Signature: mi45i6zehc7cd6xwje9837n9kjo46crm
X-HE-Tag: 1762072000-169957
X-HE-Meta: U2FsdGVkX1/dEUH7+4JWWLVXH080ENpSpzORLFzqKSuQur9l8pevhh1zT3u4iN/Dxsdtp5967nieYSeBFNIT9vEWJTGD+Yw8Blw4ZO2wixwN6fDop08cg/rsRtfZ42NPhKelEkcRjL0Nfr5k3ZOv482nxnIM9wKyHStACG2KWM3KQjSTkYnuupSwGIqQmB0P1T9A4k9yHSuEtVZhzbFjQ1NQVo1piR1URNK7kzsGRagQD1VWCeaAsXzyERhTPyUYqo82rotG755FrNOnRTFCISqvIHDQ/KFMkufCj2qhodpj7D/ozOJ1+2AbxX3ND1olSVwZLs6qTQ1qE56OicW+LJ7GxyFn/UYw+IUMXpbGOSsAUjjLujLhKCCPnzkU6KHE+ES4uk++C3eaEJHAPf7UfhejNZpLypbOAdbrB6fc14c7iaZupVcF9wy3DB8Rs8dwGaYao6VvHqKhNvkOknjn3eLGOfSjmjkhgBRjJiJOZNgFDcRr9Z4dVlCPyK3DAWnq94scYRgaG9BJKg/7sn0BTZHrtKUga7sXzWx+9/GWNlGCgRJxHtNhypx0UBDzt8iV76XNZcb/hSdbiUEboPEsA/Ptdy3P5w6r91/oNUrh4bJxzqadtX+6akhSQKYY2LN87hahBS2do8s7m926E/jK9udy3mjvFUBGTg1LNl9PZveddl1ZcpqJWjfiK/Jv4kIxFWkMTR9IxOOsBIOy0sdJbI53y8XOFndMXX4il9O6GPQuNTIpcNYB09eY6ET73kVB4rx8WyoZYg3f29ZMXhafxX716FVr9OHpvsR/X34RAo7wZMz0kBXcmMtwddLFCL6IDbkzJOnFtKB66CVSqqFnf+nyToRCV47JlcZt3rq+YKhWgPZ2eLZhqOZ4pNCnlXD+MQmbzDFWdiyI3J5UpLBJ+ZuwpiXrf6S3gmlBDMYSH3yFeDEjWMjWJFCOkat7rpggRGXql4p4m9GK93w91V2
 FvP+IO6k
 PIBLXvT2jnCAMpk9btWpljaALfF88VoRkf/aXTML0elJ2e2zMHB1+Hn0zG/K4JWnwPjsJ7s0CGBSUU3QRhgxQeAFRhrzQR53gu/KHiyE1zxCgxlMw3+2BqnLlVMWObJtr/webMpqaaoe43YG7StsWmWpMF5NpJU4vSxO+2+/oi31dC6FsQFqFerNLQUt5pGu+FzWdG8VuIG7v09CDAEpzrsAU116VzGxSHxvTYkMEhQFDBesQpHZ5DqAhcU2TcaUgK44T2eNiZxbvak0vi8LA2ZJ8KAKSHnac8FcPmaGluRxSpOacJLvsE/1UfJMwdPluU5qPb0Z8mq5AdQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 12:12:44PM -0700, Chris Li wrote:
> On Sat, Nov 1, 2025 at 6:42 AM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > After commit 4f78252da887, nr_swap_pages is decremented in
> > swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> > swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> > causes double-decrementing.
> >
> > Remove the duplicate decrement.
> 
> Acked-by: Chris Li <chrisl@kernel.org>
> 
> Thanks for the good catch. Indeed there is duplication, but only
> affects the hibernation usage of swap as far as I can tell.
> This bug is in v6.17-rc1 upwards including v6.17 as well. You might
> want to add the stable tag:
> 
> Cc: stable@vger.kernel.org # v6.17-rc1

I add the Cc tag on v2 patch
Thank you for review

Best Regards,
Youngjun Park

