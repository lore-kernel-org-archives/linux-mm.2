Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AE8CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B666B0005; Mon, 18 May 2026 19:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC366B0088; Mon, 18 May 2026 19:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3A56B008C; Mon, 18 May 2026 19:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6906B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:35:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE254140809
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:35:56 +0000 (UTC)
X-FDA: 84782150712.28.7D20F6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4DDB54000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:35:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HO2zsGaM;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSYf/5by7CSZvk31CpnT4CEOl9ZSbdictre/en4oKUY=;
	b=11aVBP46GJ2GWSyJQVbY1AnZz2jfvRFIFmj1ikcRyieaQ3kPxjA3tsaQ2PI6mt19tpYqx3
	6vMAEeELc+0BnEP0c+jbvGn93vSbgzVpOy0hVH3LG7Xs7m+9nFP+OYTbCy+64rDTm8m6tZ
	8DpfSn9QoELbUDTBdTqWCfvvX1UoncE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HO2zsGaM;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147355; a=rsa-sha256;
	cv=none;
	b=PIqX6VDgZsqdX8rVQl56BrVtw9468MG+BH3/clpyIgWhVyq1EpDPPgkkRugQy/kEBkqZRF
	i3rgtZehHm1UyuNpsWws0WxiYA8Ud2Rcl5V+T4Ycq3GPGpfWmJz10P93jTt1hK6c4LkwfT
	c5EAk7b2pe78vGldKAiIXNJuFiKdN9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AFFB60123;
	Mon, 18 May 2026 23:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDA3C2BCB7;
	Mon, 18 May 2026 23:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779147354;
	bh=gVNHBOq1KiP8XHHPybiQcYnWomlkLg2qUtgXy+sjkWo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HO2zsGaMh+GlLpkSfYucUJmMiqmfPY7fejujsFrV1jhvFJXerI3iPl6LQri4+JRX7
	 ci76BMZG4gFP5Sf8BKyq12aG+0uTCIR+teHm7k+h/9hikvjY/pddVYcUb/hHCQ/kA2
	 OohZR+6aE89crWVGuVU4ArFCRp4A/CeHjvRgZxXg=
Date: Mon, 18 May 2026 16:35:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>, david@kernel.org,
 ljs@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
Message-Id: <20260518163553.447a45c54a3d419b9bb916ca@linux-foundation.org>
In-Reply-To: <20260515092211.qkmaxcofxwfdexld@master>
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
	<20260515092211.qkmaxcofxwfdexld@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DDB54000D
X-Rspam-User: 
X-Stat-Signature: sguas9rzw75s3dhkdhp6u8ojwcxaob1a
X-HE-Tag: 1779147355-402904
X-HE-Meta: U2FsdGVkX1/HdhhZ+At4dj1TauxIKG0pvngeTE9mJgxbrHEWR1XbFwUb3ioYdh7aw//hOQAFPvRbn7smbM8pVe/NhlFyZDGgmawmtejhqlewOhKHYgLY6q//QaUV/ffSy/mA8/EWnChVEZqjsI39wD2VJAd+jYDCH2OOVb3Vl1arSW179ftDt7ARikCmSdSoyT6zD7YqRgU4aL9x5PsjbFl6CsjmxBq/wb5Bohi2PQKQDw+Ek5LaHqdmg4f1x/zdd5Bjy6rVq93lYpAuYGyQFkXLgC9BtYq3fARQ3gAtvPRvkzcrbeJ9kRfZNhCOtEUDtN0JeBYkV+02XXt/Nzp8NAwUFLMDwo3WZr3032xdAK49H9q3fEIErZyPU6L+z4PBGVUwc8w3CVwlPdfBvwt0WFMcn1fJJSAkGl6Y08XtMuCEKZAucTsfTev/+cNGIuy7SH+w8zlPTVmCbpsViemk/UUbFkuVsOTeQffmvGVHDXcQCIdrO4xQoiorQWygljFDl14hwDPWNfxmFLTeiavS80WfixcO2Sws+mxpEraUZgxXmDR3jV9IsmExfZ8fyTUdCWfGd4YTT31pBCj4vQhQoyPdwz8EPnapK9YEEFjCog6o6M+sduHG1l/SpG23QySSXShTe0waIel1vNyOznSeYwnl8qaXeEGSu7d9Y686Pm64PelCuhyo+J/feXpiNukKEXa9gIxvtgHmlRUdeB+S7q5Y9N2Q+cOnJFTZrFmYVp3XrB5CRounjGxE3pL+Cyz2NhQpidqsuhBYImRiMFKeV4nLZQ7a6T/md4B3QJzgFmfQ/EE+ry7REjAVbA+Q2lgWEtm6oqca26E2hOgsakVRhAwJ/6CmCe/szlelRifHTgz5J6xMo9+Qme2U/UWsjHcn6u/fJ3pFecbwy9XG5X64KKdptLOi2/WKTxyTT/pZIW10q84fU0fxX9OLSP9vb5i4PNRKYPF9WU8yplplPUM
 RlM7d7r+
 EnKua8L/j6Y8H6EEUU48H3drJOaiItq9EaaROt54rsAA0wXylqmPIz2fnz86kd75fHQzJiCFR/SxxNMvQ7dcuUxYlBrNPxwmheXmtGhopovbXCXUL0FzBkM2x8qEk/mF+lWCnXGza4AV9haJeAhBXdcXYE6/xIOuixQbA1WYG0TjkTtiO15uxCtkVTJCeOs6xrv9wEe0lLreVEtU/g20BSkodLD/FOIgrViQ0vVaCcwXwk0+5IbjIWU6GPrGoM5Qp7Jxj786LPBwq0sqvCjWgJHySRYLkjQLhzAUgn1X2KW9etruw4TBEMyEhJfzG7IZF3jh7d9DJE/FNR3zo0vzrEVMuZqO81u/nY2TTciS+HhEmKs0nHw1epmZEVMPR34sspr5nHF39+9c80+8XITYqJoyZfxYfgzpqUFzL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 09:22:11 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> On Tue, May 12, 2026 at 01:19:24PM +0530, Vineet Agarwal wrote:
> >create_pagecache_thp_and_fd() fills the backing file for the
> >pagecache THP tests using repeated write() calls, but the return
> >value is never checked.
> >
> >If a write fails or completes only partially, the test may continue
> >with an incompletely initialized file and produce misleading results.
> >
> >Check the result of write() and fail the test if the expected number
> >of bytes was not written.
> >
> >Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> >---
> > tools/testing/selftests/mm/split_huge_page_test.c | 13 ++++++++++---
> > 1 file changed, 10 insertions(+), 3 deletions(-)
> >
> >diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> >index 500d07c4938b..eab69b0f59a0 100644
> >--- a/tools/testing/selftests/mm/split_huge_page_test.c
> >+++ b/tools/testing/selftests/mm/split_huge_page_test.c
> >@@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
> > 	assert(fd_size % sizeof(buf) == 0);
> > 	for (i = 0; i < sizeof(buf); i++)
> > 		buf[i] = (unsigned char)i;
> >-	for (i = 0; i < fd_size; i += sizeof(buf))
> >-		write(*fd, buf, sizeof(buf));
> >-
> >+	for (i = 0; i < fd_size; i += sizeof(buf)) {
> >+		ssize_t written;
> >+
> >+		written = write(*fd, buf, sizeof(buf));
> >+		if (written != sizeof(buf)) {
> >+			ksft_perror("write testfile");
> >+			close(*fd);
> >+			goto err_out_unlink;
> 
> Maybe we can "goto err_out_close" and remove the close() here?

AI review suggested the same:
	https://sashiko.dev/#/patchset/20260512074924.27721-1-agarwal.vineet2006%40gmail.com

And it complained about the handling of short writes in the added code.

> Apart from this, I found on error writing to /proc/sys/vm/drop_caches in below,
> it just goto err_out_unlink, which left fd open.

Not understanding - cab you please describe more completely?

> How about fix that at the same time.
> 
> Generally, the change look good.
> 


