Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A288ACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165506B0088; Tue, 12 May 2026 03:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CD06B0092; Tue, 12 May 2026 03:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0539B6B0093; Tue, 12 May 2026 03:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8DA86B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:37:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81D38C1AC2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:37:05 +0000 (UTC)
X-FDA: 84757961610.28.A69EC54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCF182000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:37:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6zwxl4K;
	spf=pass (imf13.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w12lu7nseUQxZUHBdqD28dHw2n8tKEPk3ZHzgNt0uFg=;
	b=Xpa2Mix2vZcQ65UhYCzyqcE0LZnLZ1nGy2BETWX+C6MX0KIDgntJaSq6UJqH9xLqqsL3ri
	Z3KINWJ8tz/FZY5aJDKkih1zEfx1OE5MspX27LiI1o10A9j73GLspHO5S9dRclq9XLcfxx
	fux9oIiEXO8BlOU1ZrMxn9m/XBfO0xg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6zwxl4K;
	spf=pass (imf13.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571423; a=rsa-sha256;
	cv=none;
	b=4fsNtPD90GFEvhi+VCfvwHNJxj+3ddBMUW2Xd5X/HFcAHCoHKSE3N1dY9EHVOGxTHY3cb2
	rInOnLiOMvRAUq3F8q5DHBKI8gA0vTd8niVZADU4GuHZhrA9ps010cctTkcTcJBvvUYyVi
	V9By8xF5dfSOa8OLO5YfS9gsWPyu8kw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49F0060103;
	Tue, 12 May 2026 07:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8939CC2BCB0;
	Tue, 12 May 2026 07:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571423;
	bh=bzanpAxEPPJIoNF8P3OMFoiwVgRrhSjMj0dl8KCwj2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k6zwxl4KfffulQWkSQ/v1DaJteq+3tZVRQwppay1B0fSQw+n/Up8vr10OmjPy01oZ
	 S9RbJ2oBP2l1fSUFTx2f2rjJdBSErkAnfKc3t1TUv+Mu3oSLC1iyL/GU/gfjeqQ/nw
	 7lqxmqLEbpmy0GIolmLaSccs+DOcojFy8BT23/XpKOM0EX5Apejzh34zCu8A/q5iOx
	 6FMe55PI21UUcouy3PLDDTJmU2cygCtArcW5fCFdj4DYZEjPbpGPfE2WnH/lo8MMDP
	 Sy1+6j5/OR8RfSxsobzgeZEWhoXRA36sq61Xw/fBIWWXBSV/z2L3QPA1yFLoLjn0wr
	 cU6GrRMFxCkHQ==
Message-ID: <f2ef2baa-0527-4905-aa4b-b88ab38a51d7@kernel.org>
Date: Tue, 12 May 2026 16:36:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] swap: move struct swap_extent to swapfile.c
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
 <20260512053625.2950900-12-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BCF182000D
X-Rspam-User: 
X-Stat-Signature: yh7imtpmsqq6be3k5okhkabri9ndzb88
X-HE-Tag: 1778571423-99318
X-HE-Meta: U2FsdGVkX19XtCsiHNMcDnKy+lCevnLUNM7QWs+krWBV2k4mfyVlyj25XLa215kMmzhKF0W6eN6MzYtMXBfX1p2VRxlT/RbZh+77npOBu37PfhzuSGMTYjvpXTJhc/a1M9hTP61dd50xsCuhl0E4VciNPoPdzcSK6U2OV4QiBiOsbHO0L8wd/IE/654Fr6faO61zPfd4l3RORZag4CrkpxsPqbAWTz4Tfta7UkGZQGEuyRMC9L/GhJtDbVnkqbb4YzrfNUD36bVf3rqTja6D5Q1TRxcINVzXlZhqeanew3Xbej4qCzRXKghOHBjTHDaMlvcyL66f2GThvZLgjBMz/22J4Eb/JxfiRafmbjMSwaHlROs587tLqUnx9YNByFEo+i2R1rHOGoqBr5DbO/r9ECKKocjndtPDE7y8LTvXZQ+OnVAosxLDZRAB2NAnmk35ylCpk1HAblVk9FL+19fjH9bUszJ9/8A62Bk9h9H4Zn/iophBjyDnH+Qk5+Mxm2giv5Wx4B79RWpeg+V7JEESvG/EC2ylSk7Nq8nhVnavdYgNf76BUn9PHGy/lZgrGxGpGXdyLUQzBSDft9JwBjCsFrnrEkuKmYq2XenuoGOqOgNNf1g7q7Ze6bZC1rF5w62Arnr+gNh9EnEYlabusIYtUC+c37U5Cqv8XOBSBxGT8gDPDW2jXxqAfRzcl1nNUYh6fYc7pLcr33W+iEFMeIwIkj8ybZaG34TjSPhAT7EpA3jXHzOyPnqdxzrjk1e5LzQJJzvqXL8LD4HtW+dde2QybcCmI4hj9OBFKitJm3sAbQX87DRtFNOBGgzWZjasQ4IV/6ADAme0KXMI9dhePMS0ezJICvbR1SUPpbjBkk/ZMtB4TYsbSrIq6isJKoaIGMGVvcINkMcNUH/Ci5XHd751lSwq1MtEsz85bYHvxpvYrhcKMuofokwKhqJJVEALwIwDQdl25OJ1ed6+OHW5zel
 1XLjOPnd
 xjoRYQpTXuBQ/YOvc5rTBSNtu+u9+T2F1EFIBeKg4YhGk3Dg1bTI4dGyjImjA8pooYLK3Zl9Y88mopogjmvr7uW5EuzERbYsFET/4T5Quj00N92sQeboQU0h/Vn/HRuMmkXKSUXqqhWNC5w1Sxxqer5qBZnbIW76eiuneEJ/tm6m5XQaqDUPMPaI6aMowDiC+yS4c3hnkZ0izAjgsaGusVzIeIcVQHNCiUzGvDlVq6SFHZBjfyqaqaINGnWMW/Pz43xWMqQj2Af495cb9vvwmhQ1AT636BPME8I3EZHMbp8yTxwBuZ7mqLVcObW7eXwkgDrF5RsgdjqnrbKl83IR9Q3Yv51BrVkaywAUJbMFtacTouDMJ5sc9ecL2ZSTToyD09LDLn1IyqyIsA7m74LCMihgPV3iaKe/U0x5MZoK2pXGzlr2ZaE1y33YSJ0Z6tiCy9vEWgWjVbhG52ndMBiAzlJOlYjzMELCV3VS9lsy+a8v/EdwJaRZCAw6YNjG26rmxHKGUkWtbMdyrfX2FP3nHUNrhRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> struct swap_extent is only used inside of mm/swapfile.c, so move it
> there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

