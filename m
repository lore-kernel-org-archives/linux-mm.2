Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10276CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C036B0088; Tue, 12 May 2026 03:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534176B0092; Tue, 12 May 2026 03:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471A66B0093; Tue, 12 May 2026 03:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 365676B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:36:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9AE58BB50
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:36:14 +0000 (UTC)
X-FDA: 84757959468.20.85A9AF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2E69CC0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:36:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DwiA25kb;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PO4GLuGZmYeFCQwMZxbvC9v4c7bCR31DC49QgbGVV8=;
	b=m6jPEIv6faQewBOoclkUoU48B02Bp04/QaAIQYmvE6pqla/kbPB8pfdRQJU4bKpy9IV08e
	VUvY5YoZGkP8h6yzQF9uHZq4Mjf8xQhL1QiUJ07Vb+x0JfX4qw1fOq6k29ixnwOjDUG//o
	oboZR6Hot5ppy7F57R9vSrPLb99WhXg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DwiA25kb;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571373; a=rsa-sha256;
	cv=none;
	b=pi9+xMlXMI2qAx9MDPVMQTPBk3HF7ex3Cs682yFRggm00cTjERR6urBZunQVQawv6R2jNq
	kYbHJvqd8naUMunWqo8l914IT9Jg5nyKFYv9UJZ2HzY93+iTroLzivsA62F3hSem6K2/ba
	5VPIrweYVrDYYAecp2+TsrRLwU3vtQU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97E5E6001A;
	Tue, 12 May 2026 07:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB31C2BCB0;
	Tue, 12 May 2026 07:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571372;
	bh=xfvW1wpEEpdnJkpRrdMoCWaP4d2q5LDk8OL7iCWt7D8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DwiA25kbq/Td3a9MvR3WH58od1Vae6OW7xTi9Au6t+Zxak+ySYwcyXatBRk/nSr+C
	 XiF1aj5t8J/zauFcxSSUJ4UMlZliBxyUBhEOn4t4A0EasYiB9DFsanXEeNirLMMncf
	 /tYXyyBXROFd6YoiJbNa/pMDtPmAKbffUNntnCRP6f59o/WOMTGj5H/hCXhkFoD2s2
	 Gw32M5q4A/mv9h6b32INXyOm2qVf1in/c/G3Mjf1sRDBup+Qe7hjxeBcAsBOS1xK9T
	 QuVhHaZJQauyufFxTordqNNUGfqZO/Is1q930JMRcuGAk8Ge+3gpSB7gtvX7VpFoci
	 iJpVyB+/LUR3Q==
Message-ID: <5eb5cfd6-5062-40b7-ac4f-ef8f13e0a145@kernel.org>
Date: Tue, 12 May 2026 16:36:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
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
 <20260512053625.2950900-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6ci464b7qjih9gtmy3m9r81utudck49w
X-Rspamd-Queue-Id: 2E69CC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778571373-880160
X-HE-Meta: U2FsdGVkX1/rO//L6arMOi1Bb6CRDz+PVKZSuhJWdDosvLZs8ca8aKO1HxiCc6Ohz2o28z46sua526gPtpi0Ny8E2Ww31fs7+z9qYpP7HbXArxF9qZxedzpmbVpvdxsu9UozfBH6gNGJ1RYt2cxFrkWvUP55e60U0h4WxP3M0ZjAQH1Ii267An2QT5Q8TGc94o2DPzFVfrSV4QKg6XTz+dJIu2XMq6YVca6C7lBcy6VxACxKXMjjE6rGHL+M8zz6GgcLsGdeysueP5RJ3bujZ15psfyzFf2kLA63Qjl6d1JW59kg+D9EXee/H5uAhmJeVfndgDLBQdpF5QEOijgWBPY6J2Nlux3WuI3dLJSQ5sKx2EBOdqRtIsuLIjnjGffzSndL6WYF8GIQrJRyunWAJAk5PwAvgFm3T/HTkLrM1wfxwRHP0TunDRudgW9PZPX/dkOLdNNFSvZ9aWbR/okn1nrLZhlkOYn3xmAkKA726qEwt+gt7j33iEOihRHZ4xXFhOxMpnTYLWhaZY9FUt/H02lxP4qsLviJw7tlaBkaesN9ZJQH7DHcu9mRvFDkgF9W1l4sohHu7s03OQ1WLQhXimqYTtWIBpLf0vP2Le4LlpMscMmnZanouTHIqwlimNya/KpXta7CPKN3TuDhLLFI50pimbb7XNdQPIS6MSuQq2bAYJNsMk/sPaty1jAJgNAEd21FAe88FYwrUFdyGPIHK+++ZtHFORceFrP3p40gE/RKCE0sSImQhOdSfcblTROXhGxFCOoa5QolopJjk1mm3H8RCDog9kr3gTJFmGjFkbG9Nb+BqjV8RXIMFojt3seYqpLtM1UpIWGdRrFpimWN5dC8qYyafOMPbb+idpB1c9fqiu/azf9PGZdIwxgx9y5/nJ3XT0U4ncki5kRkom5xjOS++uNvspDqMhQ1+9Pc8d3c0eyAmZgPmb20WRfDLNNyoWgHkyq0JA1/UtSqEkE
 beXO155P
 uuib2BOQYDakPeF7J1k/eKH44o/3XGMeIJbAKZaSFRdPQuYdmtPXEj8gOGBvGzum0tnigyk57QrBG+gpFDh9yLIbKTuM5/4SU6qd0YCLbd2j2HvS0K5rGkZm1jqeUjbNo+EfwazGIojYsU8fAgohgSArsbobBbx/FtFwkl/MV2Fc1iu4tGK0UN0I4+WWagcZPcfmPoQfJm0lJyq+aMqdxDoU6cjP5S/4ikDgGcr8DmAxkXMUylgxLfLT3gHlDTh5T+aFaEP0wBP+vEXi8h9bJPgZ6lgpyU+gEttdefZtSr0pkPWhWOIluHeGGSzRHrakr48plT3fhdzw2ehCRt2mmEY2BhLUEp4oNRmRC05irpCWsh2V10zXT++fxsoZjille2nVhtS5kYmwglD6a85KM6NqdElJSJZNijz7cALLsO+ZtBoZDIzi5+1Ed643YOZbdlPJY65e4yAPpr7BKPjjnPZpY0HGNo8cekF5G9LLAfCtJq5JA+bP09t9V9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Add a helper abstracting away the low-level details of enabling
> fs_ops-based swapping.  This prepares for taking swap_info_struct
> private.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

