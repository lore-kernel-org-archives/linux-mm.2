Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7BBCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6016B0092; Wed, 17 Jun 2026 02:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E2E6B0093; Wed, 17 Jun 2026 02:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB916B0095; Wed, 17 Jun 2026 02:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 133FA6B0092
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:19:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E6241C4377
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:19:06 +0000 (UTC)
X-FDA: 84888401892.30.2D7F97A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id C92561C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:19:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781677145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRQa+CR7eiUizhu5Dvaaf1xar7QGhnlZ8xtDH/rehEw=;
	b=f5q/Gio2xcoO+NRHHJhpVGfx1gNlIiCyKD1Uf/3PyJNeVldyorr9IWyOAB4/+aI2P/bO/l
	pY5x+Nwe0lGVEbJj/r2qQmKQSZoQrY0F9n3TMf/rdDKh1aFX5L/JDxC2Ok2w3mQwkWJi4z
	otgoMfWeLVd669Gs2e3tpCy4IryZsCs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781677145;
	b=hAYNxFf8S5Srk4Q9RDNjbjULfCj2WZIeocb/lK9tDuF0Ox7QrVE6bIVpVcIs36NjFPGFbp
	0RPSTXvYA/Hrr4Ehcx+k1y5+6esCP0R0+LF0Mxwn/ZS1eGkH08z4QlMeWi3YF5q9nxMjXm
	MeyXh4cfIdlpqwxbFZ/bQjBDR66ntaY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B25768AFE; Wed, 17 Jun 2026 08:19:01 +0200 (CEST)
Date: Wed, 17 Jun 2026 08:19:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Message-ID: <20260617061901.GB19844@lst.de>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com> <20260616123646.GB21024@lst.de> <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com> <ajIYFtADxQDq8q1P@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajIYFtADxQDq8q1P@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C92561C0003
X-Stat-Signature: 6t8qnfchxiyjtqprf38oaft586fu87xa
X-Rspam-User: 
X-HE-Tag: 1781677144-151747
X-HE-Meta: U2FsdGVkX19PdNEnWMRH+6GAiMLN8EQ/4DOvBXhN6QU5pTY5aGoNFPfRMcbjL1XZld53PzjQjI9fngWsQJ9AerZHZVDP8yCiCflPoDe6/jzxAoZfIbLhrqvbFuRrXTg7JZhVfcOozR6KVPN/M9FcWP7V2MulrlVHXHKyvV3e+8uLebmsHyvMr9IlnOVyh6TKmnK+WG1N0N0o6ZQSfWExOtC3xbxvXft0sI7fcTMLjzJ4//t3YdKATm3RbkO4/reNJZLAxKKX2MAaf20Z596ziLYrkqxvYWxmQLPvawk5RGEhmV8+gLVjpAWTJBnTPVcJlypO0uZTcyPWKaudnz320U7nizi/Ym0rjT2sG1Jx3LvujRF2TjH1/hogM2gBltUtC+MlqFpOLy0TRJKSP/cvMRpz1dcy+KQr1Wq6PnZYzWbHg/M4WNDeC9EhyddF2hr2SpVXiVVqHODgzKRNiqf7VtUrEYk7yAiYrGLsgqBSdd5C5ESobHzgDUZkC1K38QY5l5lrRFwwksAVI44Lw6jBn0p/BhRXJyBIeksUpqp3gkHh/BMuyZSzyaxsJm8p5Nj6hA1LFHV8wiPOAHMjguqSr2u43X6UsbfHhvMjC05vgFboYL8+fOLfr2i8aFk0aW+YSIH3L1gXFROtBqVmKcQqkpIISR7T3kSr5TW+M+vXN4avccJWE2JAnN5qohS3Qq2Fe+Hfe7Ayo1nGJQJfNLzCcpNThjvQExX2JLuVeqsGoX+tbBUFoh/MzTw7SPJ6AprKm9TCt61AKD0M/YE/qUpD6Z4E7OEariQ81VvcvO3Fiv+hz3s+EZAWnXd/rJRG69XsJwzyBEyKzXr3p0R6+iU2nNvyxKZeQ9FOUBLop7FwflUEm7XhfAx0Uvq5Ci9eZdHKMytZKTKlodLy5HzBiC3DSNMZ2FcWI86y8TSjaWCq4nJEXf/+I3/gTZFVxD+pt/0P6gYfXgEnnUSZ5oqPOpa
 b/U/fHTs
 0XTl7jm0HbpMzDY/VORqdAa+tXK2T1Wd2IdSSgi3/Svs5Hrr2PwqzkuCmoTfSUDO3J+rzhNrGCVBlfqC+bAUqA75EnDtOdF646eeZKOC3LTW68AiUpn9jCaNwfb96OuPO4CQy0fov2Qm/FLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 12:46:53PM +0900, Sergey Senozhatsky wrote:
> Those are fantastic questions, thank you for asking them.
> Can we elaborate on zram being a "legacy interface"?

Compression is functionality that fundamentally belongs into the core
swap code, not a virtual block device.  Between the backing store
less zswap and the virtual swap layer, the core swap code is not getting
to the point where don't need to rely on hacks like a compressing
ramdisk.

