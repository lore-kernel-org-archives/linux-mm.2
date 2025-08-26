Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446B4CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 22:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7216B018F; Tue, 26 Aug 2025 18:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EE36B0193; Tue, 26 Aug 2025 18:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5036B0194; Tue, 26 Aug 2025 18:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5E86B018F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:07:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0FFA1188D8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:07:21 +0000 (UTC)
X-FDA: 83820295482.09.F23A348
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6FC631A0010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:07:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nPDCk5gq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756246040; a=rsa-sha256;
	cv=none;
	b=n6RHLBbkE+v4UutCm0IbFv0dqt6ziOuTCSHstG81R3KQgnbgDVwIHivLf0U7z7weBLjiQL
	qtnbq0gV1RSD7twINrUf+74S4WgaffXyTL+WkhScyRIUs+jTby7lUE022H/Lrtj3hScu2N
	sJlRJF4SdOYFOEqvyZzbVIk2w7Ke8uQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nPDCk5gq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756246040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLa6+7NbVgGFyg+MtulrSbyq42ubo4I0J2fY36o73dc=;
	b=Qgrf7cGv2lwsRVa0uKIpPJNzWbCG8NhrL3tHqTuJPxVFnpQOqSYyCzbMA9JWLVoAWYghc+
	cmEvAcUEBScloM3OT+wNRtKN77xDegU4M2/vIX203Q+9dMqedOFQSFzlgsS9PgP8MunGIR
	C3Mz4v2rFE5VxOsWa+2fQDpTgn4eWmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72ABB60229;
	Tue, 26 Aug 2025 22:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8474C4CEF1;
	Tue, 26 Aug 2025 22:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756246039;
	bh=nLa6+7NbVgGFyg+MtulrSbyq42ubo4I0J2fY36o73dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nPDCk5gqNQzfqnFd7KQSt3kdyPzBFbVu+g5BvBkV/5qCRV4WeBS7LqyZCE4qAyc81
	 rbRKHRRBXNNF10Lwobj2NrWWO99PD8o46Qo3PQhjjQEN94hSLj/QQqfXORBBqCHlWx
	 IXy1UbVsH7LFaGJPrDiTCa2q9PH+xVxdW8NFljoI0nZqqcqGQgQyfH2uJic/RSSS/b
	 WFjEwNkHcThXUaG1IWF0ThsrhFXUMMLfQn5Cj8W/IYveF74hTUan1yxmxIoHwLm0QN
	 6kNf1ZTX/dd3Gvm6mWaFM9KyCsr6vPRinqUJH9GkIAPUSKIdoMQrYvSJ69VmT6nZ+l
	 upf8jJrS8MD3A==
Date: Tue, 26 Aug 2025 22:07:17 +0000
From: Minchan Kim <minchan@kernel.org>
To: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com,
	liumartin@google.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] zram: refactor writeback helpers
Message-ID: <aK4wFZzd3cwbGFIL@google.com>
References: <20250731064949.1690732-1-richardycc@google.com>
 <20250731064949.1690732-2-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731064949.1690732-2-richardycc@google.com>
X-Rspamd-Queue-Id: 6FC631A0010
X-Stat-Signature: 8nwc84s8j795831hcphbkktxkcoheb5o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756246040-410391
X-HE-Meta: U2FsdGVkX1+fRTTScDYmvoxv+lHigpEDHpAK1CsBcNe3oVAfC5TYO72Z9F3TZKgqAI1m8JY9j1WxF8+EOOesG4PYFi/erNMAXzocIHQ7pcUCw2i0+1DoXISVbxRB4xQuTtTzyE0kP4wQJ9FyNdDTfY4tpJ+DvoFWYL/9YmWyulSRb22Ly/DbkjG0CnaSXBFx+TLMb4/bdSpFr1SoFTQegKK+MsDTPuS2hxFOl9n4D6P2fVk6bRqodBkrsHKsVLSiqPRaR04/isIXBcylmXN78Blk11N95pT5WOknsMeeGHwpL0GKL1IkC78upiHcUxoAHjA1FNLjvzitAFkjyX6W1mjMui7z+4xFBC6fIQEiRnzjd/sJoB9tdl1sIibzqrYC3ck3DZ3qtP10JHBVbDQB9z2sHh4D6i0z4X++cc+NfkXw/Zv3/lVJJ9elsO0QLJ1CED4oc+Zk+yFn3SCSAaKclmkW0wWzsfVJCMxUQRC4p2H3W0FDXnJvKvRmqyxdujkDmKnwQ7DCQLuuB6i5MHOx9bU+WZkIGdJnUgdpEDX1ipRsERjEoAS2v3hSQBuUnJ2iZA8RS6DkaXddJ9/GU6d3tRxHBGNjp9fUMZ20YhnNvJFTGywoJKLcvk4hTHsskbwbG0acdAxOxe/O+tD8wSkGZYk066iUEValNT2+p85l905aCJbFgFn/hfr5Gp6AQjhZusn5ixMbbU4U6oJhimNkCJ4e+V4VUWSp4tTbgS8Mn8MRiMI1JWJNnI7tv8VmAGCd8MtuJbxZpWS/8lcQ62TH2SFmoTsSb1zZYHiAqJnwl/HBSu7yTFLtprSzRk83jX7BsQjspE2RIiX4jRn5FAsD/29QvPNuFcDP8CW+Bl5iWjQcCzE4svYakFhddyikJ2/k2gkdeFWrkqY/o/3MgsEeDMTa0+LdeTqHRuGhJCH044lw4Om/SHSndGTHAingHBiQf0hPMJbHMS5TfRbxkfD
 2gIStvkK
 dJWgqWkcgjSS10QC4mYu4J5iDkwqNbKh5dy+5Ym4wGy4IGOky3QcmS6OMuK8L1cBy6Gr04mhtYWkKWhkEY0YxHq+NoBd7qUX2m5iC3txFAJEAJj4rG+h3WaH0YGPijudNFAVCxglhJ2zgsJrqVMPxE2V/IfXz113htGWkHWwOe1z58MeM6UwLU8GVz/8nhSNVmU2pgkaY5ljuJpOCb915lokHC5/fdB/1w1lQn0+232aqprw6+06nKebIGz6b88q5pXK9jGonn/EdYYwAcCdim2E7b1q2PwHfD+9DYyzlEr4kYrkD1ZmtY2nfzoTy2h744GRv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 06:49:47AM +0000, Richard Chang wrote:
> Move writeback-related functions and data structures from zram_drv.[ch]
> to a new zram_wb.[ch] file. This is a pure refactoring patch with no
> functional changes, preparing the ground for the upcoming asynchronous
> writeback implementation.

Can we also move zram_writeback_slots and scan_slots_for_writeback(iow,
all the writeback related to sutff) into zram_wb.ch?

