Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29377FE5204
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467846B0005; Fri, 24 Apr 2026 06:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418DE6B008A; Fri, 24 Apr 2026 06:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EAE6B008C; Fri, 24 Apr 2026 06:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 219DD6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:45:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D26C40649
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:45:00 +0000 (UTC)
X-FDA: 84693116760.05.8C8EBBE
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9EE52160008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:44:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mgvxQqMW;
	spf=pass (imf08.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777027499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4r5qaoRQ0C2q76b70PzPUZTpnQKjEqFPlRif++uBHcY=;
	b=MvMxJyvWcg1h3yhnyOVsEcirwEf/0zUQMZu1W6J1a4TVC+k1D9B87W/W78Vu79gAKTkUE7
	nKP+q295s7NVCDJeA0Qk5qw4peMvfdU+USO5OPK3eeJk1e1A1YIotjUZS8NFVYMBG122XL
	ZqmIDBt3iyxQaZCRm7tpcgM5SA27Ivk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mgvxQqMW;
	spf=pass (imf08.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777027499; a=rsa-sha256;
	cv=none;
	b=3BVjqf5aVrB4LHlXkbAtI2nLzr5i+5Dk1xt8SqaCY1K3V/tXrvDQ0V7fiIFafe8T4P2Q0z
	+J1+2RU5+205G8pe1CVppL6+vB9cSyGX5j29AznzWKsijlaefevG8yELBuFfi/WfOLc2/n
	C5CIIBd/w84IhPFPwn5Ow3QcXfftNSM=
Message-ID: <7ef32f94-f6e0-4274-8e95-078d8be78fc3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777027496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4r5qaoRQ0C2q76b70PzPUZTpnQKjEqFPlRif++uBHcY=;
	b=mgvxQqMWPT+CHsCAH686lSTRPdDuYWYcu1qesC/hCrK+Pnc7/IqVDtPH2UslGrWIuNwOcb
	ea0+hq+UC7AqUPI069ZZ3wOVnsN01pFpPSwyS7qg3xIv9qg3bxSYlIPZ4M7aiGP0hKJZN4
	g+FtK7MayqCqcqXhLnXlTbA6e+XH1k8=
Date: Fri, 24 Apr 2026 12:44:51 +0200
MIME-Version: 1.0
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org,
 tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
 <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <1pg5tdo2.ritesh.list@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <1pg5tdo2.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ag8apuh1s98nk64pbzeigjz8zuo38kqj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EE52160008
X-HE-Tag: 1777027498-314860
X-HE-Meta: U2FsdGVkX18lM8++eYzrJMsfSqg9t1f8B37uIyNnQKH3kZqhqhl823/e0nEF3b/znx3hMym7BhqY/stNFXo6Ae1nzv1xKIUIud3kS1SP2+7egYTLgvu4TE4OR/s04qTx1BsKuVdzghWnf2CFkz85aJ/D4hNSSAa/GAuNa1OT6Pj/6s3v8nyFJComo6z4N/JOkobkvwLa24UVdF211R+AhbAiXn99GDg/ZDRT5XZfJFptKJ4ckjsjFwCPow9y1KI/Eap3VPFCKbHND4EmYw3McpeR+yRCX8T9UOQKESUhRQjgwPxuweo9cFuu2wz70/VqBlNbf0x02EKEfYILGMMyZzPa5vBBzb64T/WtETG8zyOHekPf2MMJYZc1zD7bA3tCgP/n1YaohzQ3T48K1+pD78l9J3amqbXxYbWUnPv6SYAcbSfSFlJGHyWDoD//SoI7ClD6BAzRehztxo8QnLRx9h/R6YyOA/cBP+ERRaYyU+hZHm4q+lQmjhWTCukQQZACTl8midmY5NrDGzHh7w06fv4GG11JInzU4qsbfHFAwBRMKVssc95MIs2JXc3/lgokqZcMyxeQj5pqXWGG4m8m2w4fBydnD1uNtJt7j9IN7CLwti73BSC5a0J1LCmKdEbApSrG2m86h0m6R0FVo7Ehq8Tbd+TVOwtHuhW2ycEvSrDlNLPV07XAZcnQZnEKxSBPs17zLdirI/VRNDHqeGgaOC1qXLDZ9HwzDB8V5cpBTnaN0pHcvKK5Nk4maRioV4evaSzQOcA1v3Opw1FHMHBpIPwLoEmKQXsWOIoz5AnlTakv6A0ryVpWNqJD9UoP9++49ga5Ujr7CO4XdlM/+xoTybWy3MQ9Rj5OVP1NGgewUxPjBzeIZRzAoEYD8s1lNXjaVTI1OLIIQd1Tu3j5psorX1xdRxpoSefw4nxo98XXVEPOakDqC4KfM6KUArSTHWOZGKiLx1ZQDrGUpiUkI00
 hyUKbYI0
 sTw0R+8alZK0XiRf+nlqpivqU3k3rcsS/iSH46824CmdOg6tiFXDeo5gi3dUBtkwC9ABg165tSE/xIzMGMkN7jzBoPp135MICcp7Z8HpNrZgRoUI3kLIAeQMzynCFkbFZYAufVcGPArU90m5JXFX/FB9mDrsRT2PDNRTvufIBPSufYZE85sS3RqtW202BApXtloupakcAXgh5TLxcYtbuIQ9Om51FiohoMoYWXsyC8PjMYu33nihPN8w5pKCxG+uUPVzkNxzgDoFe69+oanlDJq/G2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Ohk, just noticed your reply, after sending a response...
> 
> Thinking it again, I agree we should just always ftruncate it back to
> the original file_size. Because we might have changed to file size while
> testing the writethrough support.
> 
> Thanks for fixing it! This fix looks right to me.
> 
> ~# git diff
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index c9901f65..720bca83 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2095,7 +2095,7 @@ test_writethrough_io(void)
>                 return 0;
>         }
> 
> -       if (ftruncate(fd, 0) != 0) {
> +       if (ftruncate(fd, file_size) != 0) {
>                 perror("test_writethrough_io: failed to ftruncate to 0\n");
>                 exit(132);
>         }
> 

Yes, this fixes it. I knew it was some issue with fsx itself.

--
Pankaj

