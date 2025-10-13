Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B286FCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2F18E000E; Mon, 13 Oct 2025 03:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19ABF8E0002; Mon, 13 Oct 2025 03:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B13F8E000E; Mon, 13 Oct 2025 03:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE44C8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:43:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92CD51A029E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:43:30 +0000 (UTC)
X-FDA: 83992300980.23.6007AA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DCC058000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:43:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnWR5DL6;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760341408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+J0WxrXg1veqOPRfMnbdI3zvVkI7SLqAUnTWDz+0eU=;
	b=KazoPvop+el4M/LThBiDZ4Rusa5otEYQCs/hKaMsOrAz3A6CYtX9tEzU0oQz+XvoSYk0cV
	PVMceAgCNGAOVbxiLsLaNXNCdpiZMlejY3QyObBmkl8NkCzHmQZkmi4WaDAVToQHy9nr+X
	N6EJno/qxa2zCDQOHLkdvr1ONjUnAP4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lnWR5DL6;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760341408; a=rsa-sha256;
	cv=none;
	b=artJtRT4e8keqJY9cb4tH3I9kPaHoQugqcO+LXccdHbqFG6Gz3CU4FyCbOxaMCInOqW/HU
	PCteFb02mQhDmFcn3M0EYfu8DQkG7mGgdGq3ageI8KwEiGG0+gXgheCso8E/8t8UXBT0T1
	uamj6Y09LS2Q0ixVU+duBK3eR1SYbY0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3947C60BFB;
	Mon, 13 Oct 2025 07:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EA0C4CEE7;
	Mon, 13 Oct 2025 07:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760341407;
	bh=pLU1IwgvICYpZ3g2TCq3YLekM3iXUDoDXJJmtP+sz6A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lnWR5DL6O1Ugwhb5lInDx7NsVnbuDNuDrNW1Qj3ABN/pQSdJlhF74Fm09Z3LeViRL
	 bE2zqG/e2w6dngZxYVFNJ/Q65clf+Hj8cZCyGC9elWh2sCrl/ssUDaqCcq/BnD22lG
	 5mscBQ6e6g6SgtiCsQkUqwOmjpRsjjA6bhuSVHlPWaGLahKdGSXhn8sQHQ6tCt72XF
	 Rk4AQ7XlVAvM3T4VF5GRomIr8nMHBfOdFFlk+shVbgSkMhmSHIzSoJlP+5yFt1UtH0
	 L4pKE/dxRF+YHRiKKH3Ri+AL6eYTysDFQCA7AbcfnAcPEZnlKNw7XpiM65yn9w2Kko
	 WZ3KtavIeGATg==
Message-ID: <90d26781-97c6-48ac-9f4f-4cd14567e657@kernel.org>
Date: Mon, 13 Oct 2025 16:43:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ocfs2: don't opencode filemap_fdatawrite_range in
 ocfs2_journal_submit_inode_data_buffers
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-4-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DCC058000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 44dq9pbciigmwhrbiz5g7jbcxbs3917i
X-HE-Tag: 1760341408-619051
X-HE-Meta: U2FsdGVkX1/lKJH1pEbZJi5rRumxBYmBUIdhDscgUcbNGrEubwz1A1Of6waZBsGwtdLG+G17OI5i7bfnQOQ5ush3MraMMPETr0XSUSOeyf9hgfUtuBJiis6HR5i63/MQmu1oXpjt4HieY936A0NK1dcJ0FXGoLIRbHzS6a5B+xEcw1NR8A/qG/WPR8DlUywzZqfGxqE2BCUTqlVRn6VvGW+ySPMqpP8unm5bPJlyqRILK8mY7+45bEeMZbXmo/Oo6gCCeFTQhpzxvHNqwtLx5Y+ucoN7D/QRD0VhIK+M/JrCzfGr061xefERqilce13mBZJwt3sGNESVswMogHhIHo0K1tZK6UX0jWE/58yEZ8KSu4j3kY+ufGSfwxaOEZi7R0dnHoPVxwtkvKNnB6qwboHfHJ9FC6grBv+4U7c5TI9VcsII3tedw9f/mIVZW1LcBDCHCYtLTMSEaVohENxhzmoGNqxp3lC8JcK/x3qsLCsNaEk1aeWZRVwjI3OznX1KpTza2n9dQYl1m00hsQ/BdVBx8hhHdmTVGy+W3u2a/C7b0kFOiAE+Hxim4RM4qWYxf7ApqA6zIzsdRQApTjZEmbN1hZH02n+KLok4n4bl5dLnvxUpVE169FhgBHIU5CFFCVdfjbSgjTORlPcIKmWU6mu30AthRVqWGde/OoC+D+img3tJtF4Y/FJumlKaRRUIX1CthGBA6f6A1EwB8vNNPG4Hr7YdybE1MeTH5pmL9FL9Y3HxN7bcHUCq11I3xVgynZ+QYX6K1Q0eM2auVNXcV0oNXinbBrLJiMQgtYjD/YZ32DdagAWcfkoysYi8vh8wIvJfEeeVf8xQdbpGH/086AdELyp0yPaJ1fuyiOEbmlEl0I283nivnmEwEriR8KfGrbcCJweVZJbz5rf77XtpaLNlCaGa3FOvCwPvBs7TD5J/gD6eb1lTa8NHrNN40MGfweCdvRbokYXe7ln7YUW
 PRQ15Est
 sHZBTZ278QZiNzbbfn7xAT+Ne6erCZHhr0ZEKdoixzlCdwtxlEfAZI6tGn0ZP1eCgHnrxFfP3wJWR+W5wTw/klk3Ck5PvujHJrlynb5Hp3Q5gYMU9BvoYyYXwa/yi8NHVHlmfMpmIGekcyO2TWZHWjzfkxb4202DBBjL3x7x6YqnbE0PqXCmS4WSZp7H7neUPnVdPtWNUb8DLo/PFmJtGB2eNFkzzFGooiKUbLYbHGgz4Fway/c8ucjX8O0wbWsxw5vgW47XJyryLhoH5PVMWbfRl+J0bJi612XN3kgf8IAAbECpMxD8uF2Jk1CvdG90or80WMpQZ6CWQO0XN7JhXMDsCw4Eft92qVya2v/EDg67H1XxrlMEEq3juHgYxxPnlnGMff0RFXJd1usA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.  There is a slight change in the conversion
> as nr_to_write is now set to LONG_MAX instead of double the number
> of the pages in the range.  LONG_MAX is the usual nr_to_write for
> WB_SYNC_ALL writeback, and the value expected by lower layers here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

