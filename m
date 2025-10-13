Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB97CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543C38E0007; Mon, 13 Oct 2025 03:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B278E0002; Mon, 13 Oct 2025 03:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A418E0007; Mon, 13 Oct 2025 03:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6FB8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:42:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBCB31A02CE
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:42:34 +0000 (UTC)
X-FDA: 83992298628.20.6C482E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 33BF740004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:42:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZ5eg06e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760341353; a=rsa-sha256;
	cv=none;
	b=v2ZqeDBxeWptALB8q77Xml1FfZGQHBsiFZHLVfX6f9KR9PMlyRAqa4nK/JzlJ3D8YFOD4b
	Xau4vectabKvuHBe2tNgUdSNMFosdmYD5rPfWzD0TIj2mCStRPccCfRQicEM1CbPqIsgDH
	w3xvCngBz94GNIbEcWOQQa3DrvBRB0o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZ5eg06e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760341353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/04k12wRWiK9frGle9V+OT1Cl+gSGkskLavjV0fiUoQ=;
	b=cvndF50qFaLsTnjtlkbc5maHLLbGHJVngjOMH2C6C/OWK28iapD+gSIhr6zKzp/zkZ7fts
	WqbZuOz+ayuCA1rP14gn8SHUAv/iO+bAO7XO1lON10U30g8ENiAkurw8x1nggBKsvrxYQM
	cCxwsG9Ac4Dqt5BH5mDj6vOz5sX76u4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C08060B51;
	Mon, 13 Oct 2025 07:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B319CC4CEE7;
	Mon, 13 Oct 2025 07:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760341352;
	bh=98uNYnRqcVdtyKijP43iNr9FBYNN1buUB0s6rxs7Jnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SZ5eg06eGhWCDln8zwWXVDi++rSzVsHgAzWQJp6ZN6j1s72t724fV2Jbt/DoD4/7a
	 lzXCYqRFefu97LfS0v6l7l6RNbjUdksNgGIFVCwXCqmnBLTCzAuPu2jsND1qCnheSU
	 5WvUZoBYTtf+4hn9pSm37g9eScUL/M8svS4SRwjVFz0odn/HOFPYo+EQ9uTGkE0A3Y
	 t8lC4ps3+kZ+rjKfDGchS64/XB0CnIm4l5cAXgqyDnOGPQV/PEg8HibmPCecq80TYA
	 jShbsfAa3bAHekN7SMuo/X0dgr/3gIkq2mzIt9VcRrdCC14ERZA4Q1iuF9y9GfIYsH
	 oUreoxYxkdAVg==
Message-ID: <8efa955a-21c4-42b9-a734-a06a46fd51c7@kernel.org>
Date: Mon, 13 Oct 2025 16:42:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] 9p: don't opencode filemap_fdatawrite_range in
 v9fs_mmap_vm_close
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
 <20251013025808.4111128-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 33BF740004
X-Stat-Signature: ofrckxqqtuoyim6mdntp79rzgdhjiyih
X-HE-Tag: 1760341353-231040
X-HE-Meta: U2FsdGVkX1/gp5AOCGaBIUxNUrueyRwz/8C3Wfo1R2mBLMpE1IbhMi9Zote+dardnilfal5k8Uqdu7OdHLRETHFx3QNlnC59qmtX5RhheRKZCwE8wCABKJpOHRXadNpuRcTQ9tYpJWPrhI+SonQPzXpkuKvlqKqkdLKSH0OY9IVs/GB8EKd6NJGtGOjv16SZKP6Am0Lb5L3DScw8qrfHNBgARHe9b6P6OQokO+HRvjfbAEBYS+BGE+xbc5YodNP25CA+WmBKb2YnH2KNiMHQN0mcTzH+fz52AEsnLAeUc4aRo3Z+fEx3ow4NpyHEDgPgSyWoUlxxg6pAAM8ACLzzkmRtshpAfkJZSOkFpmTc3BIc8pj8j6P+1NBkjq3OrZP8xmPTyYh/WJaYLNVgcOV70O5QUrkU8ySKYZvyIn0eYAer4gvRgv5+3WoNlY1Fg3m3eA9rZSwIpow634JpRVRFSQ5GcAqGnQATy9dKUBgtu+ukXeBTAagd8z+PST+qNv9MxOMquMIci5uJlyC/RWqbzs0ONsJGNOnAnxcsddUab+XuBNrMuwqXvAp8CNtGEqOtA7vuH8w/KfxzXMjaUOIm/RnsiklEVbDtxpPL6LGUlRcm6sPEUfTrCdVpHq4vNhA8B6jvPyraIfudIAvAsrrLA4uVyMuy8dZrU6D5zj1NMOkTao9WaLbHaOPyni2mXv/odVZtmioOlGGulkxcjtv0mq3lKoysdF1bXI6147lgj/Ok6+N3B8j4gQIVKeUePsvHv3WCniojdjIVmyWv5M/Y8M+5uFRtgbkgfJTI+FweMPlJ4XGKeKqOvg3OStkL1rDLKaIv3O7nEQ0RChJECHKFfoYBzliAzFuqAtsHxqd0mGZlKrS967rkm49R4qkw4RV8H6iZr5eg29BYWvRW6rKppnQI7cZZXMbj/krbRrCrC5UwoVMuUliM5mxCf+u9fSoWbMRbie8rXdJIiTMOnaq
 2jP6F+z+
 B3vVYqP4mk07jsn7yD2KgO4E7yAB7TcGRXM4wtcA+AyzuFKxNRdIzQmrUMZGIpywM7cgtJ9Gmh34/O1romm9DsV01TPjW7f3XzpYrcc/b02u2axk9Irv400o+xUx3aipVUXnkD2DOFRZMBXd+udGQyb0R82qUeWsum2FGhaYcPUSeXWwboNs1nztIP44pXcQoDuValjsvJnne9daf3KEA8bz7ZW8CZ/kP5Bjt/1CeYEF9aNduh12ctU4Hu+nOmnmVTm5XFbtoC7EeX9A+gw3zOo9v9joxCpOOKr3LEF8Ci1nRnhqakWGmo8h98jHEiRemaEK3i7ji5V0DfP2NB4x0xyeh5kgghGApRNnQBUM968c9xut0mP0v1aAgiNrysWOw/pb3eiQaxNgLuaJ6pOl9pPhHO76BWfkXezMbER+zZXcm9opjsk1OgMwH8XI7BP7G3eTMfmaDSKTuR4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

