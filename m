Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B10CED63B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 12:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3961D6B0023; Tue, 18 Nov 2025 07:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36EC06B0024; Tue, 18 Nov 2025 07:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAC56B00A2; Tue, 18 Nov 2025 07:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18BD46B0023
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:56:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B630213B2C1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:56:06 +0000 (UTC)
X-FDA: 84123725532.22.E2FCE46
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95D6A180008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:56:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=G9T+jZSG;
	spf=none (imf16.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763470565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUndLiRuj8VVDQpGylc0ouZ9CH3E0910nA/n2o+vuEo=;
	b=OmyjycYmf2b/SJgjhmlmu11a2wqlBAxh58W9RQ/pqpPMYS4UWO/Ywq/DIbMS4kHRaHh+Vl
	8bEAIE+hSd8YoGdW01YhALPZbo1inIoiplKlqxVQuPGp/r2QCah7+xxEGzg20r/jiKqTDU
	9a0jp1TKZjUZdsxjJYNyig4kVaotJjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763470565; a=rsa-sha256;
	cv=none;
	b=XaEzhQ/S70+fgNwdrcWwlvrXNEw0Gol7rZnbG5YzQsZZlaXYpP9Eqj+vXdsxNbFVOIO6nb
	FuRgXfUa5f7rQCKpRxindlPwKTMd3xECLDR2QAHWO7OoYuuNGnunSqs6K7eXHzIX59WfS6
	EACBMoFySLsRJ2yFDs+qDI6nvKVp7ak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=G9T+jZSG;
	spf=none (imf16.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZUndLiRuj8VVDQpGylc0ouZ9CH3E0910nA/n2o+vuEo=; b=G9T+jZSGmN2RpYit1OqCM6L1Is
	EnIgIp4P+aq7z2k/XbFrerQkkzdPKcMkX6oD1q+p6/UaSVDsYLWJHQrilJ4HyeK5jUS3ptbpOncmq
	F5mXJmRmVnKx9Y646K6Iv9vOh29j8bxtXwemJAS1hvnslqoYIE/b/4l9OrvlBDcW9ogTelDKZtA72
	7ZkOoRu0tbJ4AygUZ4GIVWaBYDPhzhAL5NmIBwJ2kOFWuzQ1eBsaCZSPB+w7jTajQzGdGDU0oB78D
	ry/+M8SiSBIlI8y6GyD4fdfnRBxeZYkMRBlzx83EVzFgtKLSsA3tTctQHzb0aa7znpoRuFOlvWy3s
	xNzus25A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLLFZ-00000000RiH-0tvq;
	Tue, 18 Nov 2025 12:56:01 +0000
Date: Tue, 18 Nov 2025 04:56:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRxs4djsaELyeBf9@infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <aRv-jfh0WkVZLd_d@infradead.org>
 <aRxr5l-usmPvenbM@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRxr5l-usmPvenbM@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 95D6A180008
X-Stat-Signature: s7jbtahmopxmr6qook6t7udcqzx97sk1
X-HE-Tag: 1763470564-948152
X-HE-Meta: U2FsdGVkX1893LtJ1qkzb4rFirKk/Isa7TIdF/gYEdGUoPKrYZ0lWlP8NpJE3FvySTDJUoUurQ7t7vg4oNCcGT8G81r0PsL5Ac8VZqLL9RY8RdbjwJ7H0M3hWQrfM+mTfYDohe/CJAsD1/gVez/3IDbLBCwbN1EAm4qvXCJ5SIRzqe0sLWt8o5mamRqZTY5hcqUxlKbRDaQ0uBZYVxkaib1m4pRAuHcmy5pDHafuEe2rf6aMxPZfzDNxjU+6VMSC7CKjwIs2AAGj3oxtRprUMsRfjl+mrmlN22FwHj/Ajx6buxpNjEFN/pBDQoA7xmE0Y/KisoTySzl3UVfUvl4OsfYxrYe0cpGZBLBDbB9Tj/jpDbcH6Kzh/wWsXYafix+Zjhk8C1/2DGOhvfrESE5f7IPKnH0wZPavGioSQtP5cdFX+H53VPHSJMwl0TcJD9GrRubDEAlkBiskLn5Nyx37/Bx4q+xVLhNDeyngWhJRCGlFyr0WCjLLEalV2J255RXl1VTUOg1XaAuM25teMFEURqcyu7+jOugokM0HGmiLdKVsmvu0aSIcScunhu5UEklxYdR6eSICxAR8vF/48gKJr4wAk8l4jR/4TExsO7sz10l7Frp/dICekXySsIi6857NIaW00xVwIbzJZ2hRsJvwX9c7ezOTZC6RD2gEQ9454g6lpkBHw9wovfBbKtJeBA2ohQw1DDQqNzgayIBtyZqjujdSlC0TB9l2CkjoKX46VKFLWhytHaVowXLjdsztjCzly0+qXbTBlezdnkYYNX1LZyaCJcBXMklvR8nkf8/yWnnnAvXOza4XkHmf0TFHGpr6wBHPld6cRv8FKIZ9mu1fL6CU3v9y3Wt7jqPIajbcv0E9psv6SU1RGV74qOiJSCZQcfBr1H2mEvFlxBI8aiWIB/u/2u7ijXIodQnUI4ayky0P1leMv9MIDxHprATtoT+VpVZ687R+VQiNHm+pcwa
 nB91/2v9
 p6OkWapH79vW4vFcra2CYbX2UP44vLLPvOhYpJKZ1w9WAtnfp3g9p+hVeuN/p4ZKBZFTL2OyQquADaydJBvBPAN2C+77eOhigcxKsAQinh9GlBss4sg/otfk97swRN9F7mWRDcyNCFct+rhNcqgP2bejFaVrkPj1ZQe4RPhZx1OpsiiTDrha/Dw5ru76E9UksV3Vimkkw9ardQVcddW1Tl6jz9mzj/hOwKjlrWIAtf41Nv9p9Sp9JDnv3jJBpI//EVzayFtEh0hYK1MM42WQ5j2WQdjI4bfv34ZL7w9tS3j0OUKyMcJzmd7vHyv2qVuDRAa7SXYhYlOzucZ/7bclNSuTHQgRTy6EfHB07SrtUim3bWfkvFLnNBMpePlBvCQos+cqUAXinYXmhQo564ffgjGJC6B24AeZA3fkhm8eCARwex5g0m+CZyjpxyxSSJis8LQ5BRMft28rPdQr7m/0GSLGHcTBT5TqcFxY1VnojMc5jycxNq9q5ciHEd2M57px8VfAu2/TDjLp9cp5eKQvQaOf0hoNSJMA93YU8506MMFs7vrW80ZmZo6T/hAEV+KggaPdOrbVxAkV4EcgS6UraPUPqtaI1dK7K9O55dl6sYzx2DFj8NEqPoPTcXmGRDJQ1B/bOvPJ/+mjMP1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 12:51:50PM +0000, Matthew Wilcox wrote:
> Please read the rest of the thread; this code can be called in contexts
> that can't block.  That was why I proposed the kiocb_read() refactoring
> that I would expect you to have an opinion on.

Doing file reads from context that can't block is just broken.  Let's
just kill the code before it causes more harm.

