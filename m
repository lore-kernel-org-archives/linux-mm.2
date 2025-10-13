Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4B5CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E258E0022; Mon, 13 Oct 2025 04:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65788E0002; Mon, 13 Oct 2025 04:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1FC8E0022; Mon, 13 Oct 2025 04:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97CBA8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:19:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46ABCB7EC5
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:19:09 +0000 (UTC)
X-FDA: 83992390818.23.FD04B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AE0716000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:19:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a98t5npJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ughf36Tebh8tRi2naNgzgYAeZFLBdoKgUmvbnrM4Nas=;
	b=trpw1fQrXWPCaRyC2iT54Cqic/m0U5uVM4M4nJ3oGIn/WUObNYKhxeyuvL3iww9i02/tFn
	OPxaqHuyDLhMwGGx6THoTJRYmVMxJ6EmWJlSlF17onILrIV/ZWXiA6HzDIAkgbPn+gpzXR
	HkfoKRIU9ejvVWF5nJOUwyilI7jXRRM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a98t5npJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343547; a=rsa-sha256;
	cv=none;
	b=ahpFmK98of4CW4jX9Ho44ClGsNgeBy4sQI3FlAwY/57gCSwaDW8NUDi7JhBxKdsdzNIikq
	gD5Chkos4EnfqS1B8W3Esspa7+LhjZOK736SY3Va2eLBwUOpY2qbdmdMRdeKKrQF0c6TEZ
	NZ9f4+/4SKtX4nsN8YxMK6XZPNaqrtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58BE84580E;
	Mon, 13 Oct 2025 08:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A26C4CEFE;
	Mon, 13 Oct 2025 08:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760343546;
	bh=ljQ4j9Pz6Hncku4QWYc6uskMl5cg5GjeIdqG3a1O4kI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a98t5npJJxA0RJV0qsmNA99531rbeFhI9GCV5Nhm8c3l8Se+sNXDDv4NaKtx8qXjx
	 mYVxDcykicQUWeTF/7HfZFk91uHV3VGoOtjkAyFpmHYPwg3ldZ63R2pu2Z2VhlyFqv
	 isgTahZdLMc7pBZzsN8e0+q7JVVIkQqjansZ++RQ+tcwm3SnnKjHk/mdNkPM+3YOxw
	 uhKKLFud+BtR7TYveS6u94Jl/qVItX1ZfGqjGMnJVUYTvqJhFTdXkNHWugrL628awG
	 eVmkEfNY7U6eHRhr30I+EKehBZIoit3IG1lZhOvcYrwAOE9sAQqTNgFaQplwImdWkt
	 s8JSCF07WNolg==
Message-ID: <74ddf437-0d59-4008-85ea-da6f0f6c0c9c@kernel.org>
Date: Mon, 13 Oct 2025 17:19:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] btrfs: push struct writeback_control into
 start_delalloc_inodes
To: Daniel Vacek <neelx@suse.com>
Cc: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-6-hch@lst.de>
 <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
 <CAPjX3FdRvkie6XMvAjSXb4=8bcjeg1qNjYVT5KOBUDrc+H=nDQ@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CAPjX3FdRvkie6XMvAjSXb4=8bcjeg1qNjYVT5KOBUDrc+H=nDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AE0716000A
X-Rspamd-Server: rspam03
X-Stat-Signature: w6xkoemwo6ty8645idr6qu7xign9c1if
X-HE-Tag: 1760343547-717022
X-HE-Meta: U2FsdGVkX18tu7BJE6VI0Hk9ReRoAVZkQxH79f5Rvj42Z0S+nYcScnjcE8wpS0Q+XlVOXJ75mFvGhDdULFa7efQDfrXVSxBQCzuXbu0d3hUzIVYI4HoiPc1fsIEuBKCwX5y84WE/YFV8PE97HHTjaf70u7gjdmZWMccS/2ds5JDknNqFKtm0naWfMrLWAEVne/exmxKb7yh4qPnN3dQqpDPFA0V49OzGNTMUFk7ZcSxjM+uSGam2xLsm85UEofM9BTq+Q8XAEDwYpZJ70qiqdIRE8kCvPp3Kd2yI/u6O8izRDXxhaKrX7WlFe6nAz1OUuhkaRwSGPTD8xsJeaJIJvK/jFm7fiNHfN3G10F7Ki35eta7xULkffxrlllmU2D+FiAKwTGwttAoq8l6CVSs40jtQagWEc59iuTuc6VoGhif2LWMF9FEVPLB3agKCxCHjBeNxSTTxrz9Y3Y7aDN0X5I2hoiUk8sKLQJ5DXwNHCzXRV24zfuDirNLSpWqi8xXduhsiuSbEefcKXF4PWElDSx1XDrlZgmQqYhKFLWIVxdATuVU10h73eXFWhT+d5ZK4qporRGHlQDAngOhEX5FZd3aK4Y1ozjURjjGLZjvI56bUVIPpa022izK6fGW1M6I26OM6RdSUbtbLKgMMQqJhI/ADHprx/EaC9Qd+8FIwdUEfHGxr7OV88BMgylmHmkiZzpkRymmlWhWUaYBODuy7zFpwpbsMdMLJkREhKivCYYmQQU9seQgLP5aSwS0ITcy4JN/Mz1vTe0vnploVosIkbl09TwKIqHjnxhCThBPFpJfXByWTX4a6xWqLZWaZAXg5AZ3hIA4i2p48gWgm6Baxhez4COnvEEjLbDtLcpYgat7LJFZ0oNST+FHNkcE1QIXLhww5LVuAmAdVsnF0kDa5ZPB3pbsNeE0+VLQZCrTkkYtd2kkx6oCPFzaIlyrXUFqt0fSaCpiJ7dhT+tktuJI
 wtsDzK4C
 m280UXZxCgXOe/Szf0Wka7BezXVIzy7lkbc/4OnCjYxzQ+c0uXlZ7CxH4OEa9Ta1ldQpOAWjMOlVNhkxP76uWrQiiWzGuQbEuQIxTRDGM8GDYqQsG2GvVCgJm1pNFLOPS+mnYpre0YfV8UQHrlFvx41kmTNAFp6l+NcUjbmykAJhiICZ0QQ+RWqVtXdbg2Q8XNhVRZ1SRi9KpmABss8befua1i8kt2BBLG6DgGv6G4+0sIJW9jQMqk1GjxDawkhFIUjfZ3xIEgNfmQwff17PjfndxKbo0+b3ZjErybbGUj4pNPRrFo+bbZLHXY8sSA2blWiqO4QCNZubG22TCyoo6TiU9GcJcsWyxHlf0Pir1dP3Ymdg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 17:15, Daniel Vacek wrote:
> On Mon, 13 Oct 2025 at 09:56, Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> On 2025/10/13 11:58, Christoph Hellwig wrote:
>>> In preparation for changing the filemap_fdatawrite_wbc API to not expose
>>> the writeback_control to the callers, push the wbc declaration next to
>>> the filemap_fdatawrite_wbc call and just pass thr nr_to_write value to
>>
>> s/thr/the
>>
>>> start_delalloc_inodes.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> ...
>>
>>> @@ -8831,9 +8821,10 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
>>>                              &fs_info->delalloc_roots);
>>>               spin_unlock(&fs_info->delalloc_root_lock);
>>>
>>> -             ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
>>> +             ret = start_delalloc_inodes(root, nr_to_write, false,
>>> +                             in_reclaim_context);
>>>               btrfs_put_root(root);
>>> -             if (ret < 0 || wbc.nr_to_write <= 0)
>>> +             if (ret < 0 || nr <= 0)
>>
>> Before this change, wbc.nr_to_write will indicate what's remaining, not what you
>> asked for. So I think you need a change like you did in start_delalloc_inodes(),
>> no ?
> 
> I understand nr is updated to what's remaining using the nr_to_write
> pointer in start_delalloc_inodes(). Right?

Oh! Yes, nr_to_write points to nr... Sorry about the noise.

So Reviewed-by: Damien Le Moal <dlemoal@kernel.org>



-- 
Damien Le Moal
Western Digital Research

