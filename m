Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7326BCD342C
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD8C6B008C; Mon,  4 May 2026 06:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6957D6B0092; Mon,  4 May 2026 06:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D21C6B0093; Mon,  4 May 2026 06:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4A56B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:02:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E704C18E7
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:02:26 +0000 (UTC)
X-FDA: 84729297492.11.A9AEA7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4000720005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:02:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FkW9waxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777888944; a=rsa-sha256;
	cv=none;
	b=0W8+5bWDI2VPvArCBI237twoq/K8K9nqXiVLTHLAnzzsGPO+QhMKYV348mc3f5a5T0MizL
	LJUP+oLpeIMNLf5ZsxtAqurxjx7oOqD0HeCtfwpCCm+VKq/iSp3/AwyQgHUjUIiUqYuyLK
	J1POWXp5UJ7rqNnavZRBzV2e1TtXqP4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FkW9waxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777888944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8w/fli8iBSEJz5Qd6147amWUKbkBlnAkACJsWd7BL/4=;
	b=WjPORrdQj01ifzjtvkulkXzpMNlB0jrGMaLD6EMj17iSeVg+MqVKtc2rNtaoSjYaNs5p6R
	EZMFEvMXvs0wAETtVHOo3q1NSxsnlqNidD689mI8KqlqXJZ4LBSYzPtph8XdzF4uQ+uMkA
	OdPCJjcjnTrKHSivi1s2ZBcW4MF8jfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FB696012A;
	Mon,  4 May 2026 10:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22609C2BCB8;
	Mon,  4 May 2026 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777888943;
	bh=THYvosUkdqfwgMoRB0QrlS3pb9ErZrxzd4Pl66atKwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FkW9waxe2TcYXihGs9SsNNhKObqew6LP7I7GomrxaAMImW/m/7Erzpv5hzZI1Qzim
	 VOTMu5cuJAqouQrsnP5U/uqJU/ZPWZLU29kViZfDzw6EQrjZv1jKt7OtsUDtdo+T82
	 6dKtN67hB1H+KsPD7jIuQFZHReJ0hHeS9So+6ZK0+9PRQc0Yd/9Fo1lcCynM0CXYGS
	 WGjqMZUTBS298Bdy5/5g1AQSLSENq8CyDFx63wnghFAGopqEifCwu54+JQPmRIn1Y9
	 4ayFokDlENVKkBXNgSFjbr7ebXnvmlT+3z7kQoop5OuP5fxCIkj4npIG3LRkqPDcmG
	 1+ShqJ+HE9K3g==
Date: Mon, 4 May 2026 12:02:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: shuah@kernel.org, akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH v4] selftests/mm: ksm-functional-tests: fix partial write
 handling
Message-ID: <afhuqM3CUcCAdEXr@kernel.org>
References: <20260504081638.683223-1-agarwal.vineet2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504081638.683223-1-agarwal.vineet2006@gmail.com>
X-Stat-Signature: ttnof6why5rcwub57r1eimxemjfakcsp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4000720005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777888944-374798
X-HE-Meta: U2FsdGVkX1/VEikcEypj1vNxLKvVKNYm+ekKx4iWHt8rCMOmaU6FIR6MOjfP5iPbXb+WQx0wk/oGij0eQBLztGvbA3PNFHU+rnwvzixDqXBEVMTaHSkcU3fRrrgbfCdCAdY/Gx9DFC7Deu7OIYQF+sZoiCUrrwu/Mq8jROiQKBTShRX12X7kcONC+LWsFGaZIVyDMMXiLdHRjUPVH8dYHblXA8kqgm9FJyr5Z3315NCEbdb5r17ZuzeUHRpfKapb15Awq4iNekwIHBsnSSFLpQ2Q79q48ff9eKm6xfap5OuSJ2TFJ5QFCmkwbxe65358P13wIahFT+hpskmrGYIgyb3f4wokGQ7MsQgsS5QBaX9eIdJRLeg7jBqzA/zgBQnmyg9locRSn4DYXDnZJckfg9aTKeV7l+ac/eEcH3G5gH8KvXD0sJUflqi5t2GyJqnJNpa7Ifb5XodFgoW6vWWPdJc1h1c0+0d5UqMvNxF/uDHyt1rVyI+aoTmfrKWI/i58NtSqPZM8pNuw6M0iI6Iur2At9N+YTkYpMJp0/5l9HV5gQKmYbbKP8BAV24FTjqNMJ3VWFKkOdtrmKOeexeZJaiuIifC6YjUvISeUyaUYqFv/AxLfDvdz+cOtSi8rB77YXc5VtlgKXI9aGo+tzBysTlc1v1GNPmRw139H2MA3qKZi1hMOOM2voIi0OWd5iCIi86ziLMsqIGBhs7eEkYxTjxNVmOIqkgk8xwFQwAgVDjgu3W8mQbvuNbFMXET+sPHQ8y2kVk3SUSPStqzeP16RVci0UJIpBnMZxKRw2QTxycuHamg8C27ud73v4zMZqj2Qpyei8iPumiMnvC5Ah3gO4mTp1jievOyNWqQEiKkanzaNnR1+dAuimXdEKlLwoY6IO2cN0eH4Qbm52hB4NcF3SSJ4KY9c/xJ6YjUH6Qn0SwR8ZNaKBgki1QsmC1L+MQ/87wVmum7Z6kIf6dMCTSv
 zJTD3p4V
 lzXqZa4tAunqslQodOymBaXeSJa9sLv7DxtFkh7VuPpjvFYI5wTGRr+91B+k+pVACxf0eDFvVOJs/6RT6AGpVptOfsDfV/GUhRghsAkZMbfZO2UhRTCDj85pH8c7iSIYbuE0iB8TOOJ5no1Z2FC+sQyvJ6QFZFmkSp89uGvr25x2XEj7/3NtAJOHAz4sQEJ5AZ2JlGQ0JGHuydcTpp+7vOlkv0rYmK4BIPAXN0O105on9VDSGgyb+WPhJhLUr8e7nf79ybUTzfmRQ/IijEOcizluhMpdDi8nddoXK9U7RRqtxcfKXGgYC0DtK9jcZGA57X7LY7LvtmLZB3YHAUPie6Pj/2PJBaaclRMIEXaN7WatvGl80MPHJU2NTGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 01:43:13PM +0530, Vineet Agarwal wrote:
> Update write() checks to properly detect and handle partial writes.
> 
> Previously, the write() calls used <= 0 to detect failure. This
> condition is never true for partial writes (ret > 0 but ret < len),
> so partial writes were silently treated as success.
> 
> Fix this by verifying that write() returns the full expected length
> and treating any mismatch as failure.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> 
> Changes in v4:
> - Simplify write() checks as suggested by Mike Rapoport
> - Remove temporary variables and use direct comparisons
> - Use a single len variable
> ---
>  .../selftests/mm/ksm_functional_tests.c       | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

