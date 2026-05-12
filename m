Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB12BCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567D46B0088; Tue, 12 May 2026 03:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518886B008A; Tue, 12 May 2026 03:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EBB6B008C; Tue, 12 May 2026 03:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32ADB6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:19:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B943B1A039D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:19:07 +0000 (UTC)
X-FDA: 84757916334.07.5360AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE64440005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:19:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rzpOZbhS;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QE3ewrsfby/Z63hPdgzGnhMlX4OhV3m89/7+h7TDBU=;
	b=z7f+LQ/OUuRE/vGIiltKPc3fO7FQ1VTP/X0ku7Q19sAE0+3kmYs/euTjs2aiAyGm5HbwCM
	wzT6FJrqyqdd8TTTVlXOmbPmfBE750+WA/nC6nENnvzi6MpWsj91B81nMCbyuuYK46rq2W
	jhlw27+GkeYE6OWeKze5/bsUN6pvUHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570346; a=rsa-sha256;
	cv=none;
	b=2QWGQZL1RU2147Zsb1hjdXlx22rq0YoBk9aNM6RjIs3KxBjdfu0iyImvvvb1EpvKAoHK/j
	BxOwUDSYkGkNDMnsbvGOuTj3/TaDLjm4DfBAdsnLy5bjMNPVEv1+OyY4SEY5sXV2ecPxOt
	/1xpydnvJObrSh0OTEHz+IcF/w8WEAk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rzpOZbhS;
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09D1643881;
	Tue, 12 May 2026 07:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9397DC2BCB0;
	Tue, 12 May 2026 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570344;
	bh=d5SXioBPZwBUI6+SvSlauBL+rdn+SyAPRvBRa2uxfM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rzpOZbhShhQy53uHWdXI2cpciYpCJ920LLOVTxryHf9v8OKxdXcXv9PcbtWsHhvyX
	 AYph9XZFDOqDQwZsiKpkaAi5Tj4jgjyto4NZ8GZ1d1lrpRbMH6BEl1FmQDWqHh9aKt
	 wR9hASUhwEfR/x7muZ/iQU+ZY4Unac7EpcjljUYFspFcTRdnBtE6xUk0dzsWRcdpwK
	 N2xzyLJkDls7Vy9tVuzq9XXM2918R97/uSORI1dlwtkQ+yKrj8aK6cWW6NBweJ5PnN
	 m3/udQQng+yYpR0EBFqLsp20DKAl82altPlAL8TvQYjfsAOHgqXK+IqxQKVepy1L7g
	 Pst3cIKtZvjWQ==
Message-ID: <48752f6c-39ad-4409-9d41-646922a668cc@kernel.org>
Date: Tue, 12 May 2026 16:18:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE64440005
X-Rspam-User: 
X-Stat-Signature: dmcbzkz5q5jkrd3fuzohcjig4h4rsurq
X-HE-Tag: 1778570345-913633
X-HE-Meta: U2FsdGVkX182/UvOoKFbJjIouUvMNjuHzCFOIU04gtyw166/Ome0y9LkiTEgqXMQCGNzt1poRz873M6gENPfjgjJO3C+mqAW07s4co44zu06LadtJ4ZGKfh0MAC54IASy3lBVkzWefiGqGKXF8IaLP2xx4LbZnVW/nPfr9TFNyfu2tzsr6/XReP4MPMP48k8Rdg9/pZ9P2p/B38cPrgEEQFsLLCEz5PLJLp+LckTurZLu3Gl7wFr3rYeNHzYkGZbfy/0g/RXbaO3XGNmuzh2dPRk7hQnkDvS6Fbct1mLY4S4+/cR5xZBD0c+2yMEraHD5gNLo879JEcrz2T6GmWXDCEzlS4+g8EKdDIp0tOzYBQLUwIvMLCJEnvI7E8cCk4n2APa2j3hMQkIX4xBt4RzjnXrzdjplFZI4LJRGjI3DZh2IGIV4ZN2DmXwHyUNBxzd/jh36Y0c/WjetAp4aKGFnBdnW6i2ah7tzSNj5p//lT0VhEGhUMbphyFvHbm+IIJNkJbldnWeJFLgiDL0PO8wZybYtxxPhNbxkQy5C15VPA/NIVCgxMutkY/XVHN4bTrYB5APS/OXXBOsRH3TVdbbjr7i54v1qu8mFZXkBHDLpyrEQ6fCie1vFmGktBGM4u82GQccRYqeYVeTA0/M+LSO+gtpu2tbuV8hsRy2An9C3Z1Lt3gZdN37MfqPNpw3J1mBBzBe8nkW1dFLvV3nPm6BnkuPa1MkjUryJX2Oz0cWYse/qSG2CZnF0teZY0hfcYLDeOSjS96QDyOIIG11/r9+dhxI63tEBASVRrZWGTcm8ZwhfDjlMO8nC+23OWjg0UkWwKPDlJOgjNIcXvNOTu9PQCKbTqEwXnGHkiGzFlSKrKzGj3IoABC6Mn6ooUUBz9W6NByb8XtgLCVQ7HoZDD0OPSyT0gc7aea+l9UpkbjCYgvCzD1A5EzvEAu4i8kE+TsR6DqORIoD/08alw3lPzQ
 dOw+4Wg4
 1fUE8RaRbQLISSnsZjWBjgZFGeEMTiswzh+ZbnrzZbHRe0DMDBl1Ai4kU6nyT0LCJkj4MW/1IqPnrZFwqKKkUXge26lYkrPTyXItm8MHz2FKiu57lYtnqByVORNtvoftpIPigXJlOhm83gXEzYmPbweB4yuEQAyJ43TNDiuTfdxe1DCCq7rA1toysYD7pRDDDdltn3/qOJrlO3/U6qMIx97B6GD++kIcUXsIdEgnP/Nm8XUhSqdhmc6D0ZWJvMEgtfA7exNseP2LafKvARaEm5Na5UVYA7WCUMjda0wdC4DFJE3seoJ/OyZrhiuDgxxiksiTOO/XCVkcE9ZQ3f9jU3ic/BOAwOMw84zQOiX3AwGxjta35/NmZiEFqUtZ34li6ybD7eMXkcjYhwXQ7aX4XhacGQgslOBtMRb9SkWVeJo3P5YA2DakCIB0wHwPr3Z8nnDZwgRL3pNpsL+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Reflow setup_swap_extents so that the flag checking is not conditional on
> a swap_activate method.  This is currently a no-op because the swapoff
> code still checks the presence of a swap_deactivate method, but it
> simplifies adding a new check, and also makes the SWP_ACTIVATED flag
> more consistent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

