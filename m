Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66DD606A888
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MmvF84R0
Received: by kanga.kvack.org (Postfix)
	id D8FC76B05B2; Thu, 12 Nov 2026 08:21:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67956B05B5; Thu, 12 Nov 2026 08:21:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4B36B05B8; Thu, 12 Nov 2026 08:21:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA8216B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:21:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 509931C3C3C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:21:07 +0000 (UTC)
X-FDA: 85426527774.26.A90775D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9A2BE2000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:21:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmvF84R0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TVb8qDZ4KT/CTu1G3B1wlWvG0RXp8XP3qjnuNYzjOg=;
	b=LqvSU/hLWEivtelDljpi1HpkANxSsT2wJnwfJu0JG6xuuv7nym+yozOBX2/DLWZj+KAZ4z
	GP4FbXi8e9JDJOwZNPl8HC5I3laiNUtYyCcMcfzg+wkaQvhsHGUlflvKfHdUSDEYmrxGID
	ESw7GMknoqOKQX2yGfmsecNXsqYFtQQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmvF84R0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489665;
	b=b3CyIY339V+WKL+1EMtT5ONXKGAr0a5iPtJ8/+b9GD0PDMtBspqxMIDATo0Co+SGbXJRdL
	FXfql759cDdEqmBQdPFc2nrXlnwhKOo5sllTzfnThjfTz1soB3A+I4rBfIxMNceU7W0WHN
	QfadXMaEgKXUNozRd9o4aGW4ajfc+J0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8F5742DD6;
	Thu, 12 Nov 2026 13:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D581F00A05;
	Thu, 12 Nov 2026 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794489664;
	bh=2TVb8qDZ4KT/CTu1G3B1wlWvG0RXp8XP3qjnuNYzjOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MmvF84R0gtLndw24gzSFT3ub5yJmtlvjtQewwlBkOj3aPXQTksQ4drEzrc46OvL/z
	 wo9GRa3UsS1F1xzmaEOQVjwk+tWBf2XT/7mCHBb8HSswe2CPaa8KtfXoHjL9Y0GbyO
	 1efF5XqnKzznSG9DEGEO7OMYE2iaaSETCJ8OFamxUwQlBUJWVpDt1tjvUs4hkM1QL2
	 IWFg+ih4NX2foIqjeWjsniqTNNlHAD8H5+koYNsWz+ArokDl49tjta/Dn88XnGLkGJ
	 3S6OKico8mJafJNwprIMppBt+ZwOOYREUSFE9sMr0CwvZQk9NrRSiDsIISSMrUCwF/
	 4a2UthzwC3fuQ==
Date: Thu, 12 Nov 2026 14:20:58 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261112-besorgen-nobel-handschuhe-fb3373259b5f@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
 <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
 <20261110-kargheit-impfen-pausieren-881763d28b19@brauner>
 <za33axmgzmuzsj3zmfeh43fkphtcsqtkhhrauwuvs7aiftelgp@dzl6z322st5f>
 <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261112-wohncontainer-saurier-wonnen-91f30c3b3ae2@brauner>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A2BE2000A
X-Stat-Signature: darwr9hbusdab3bn7a395exo9tjdbafw
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794489665-903727
X-HE-Meta: U2FsdGVkX18Vw7ScuzYgTB/YsL7nUOayvIGmWj5UDzIRfnd7a87UyQacHP77Oa95Bo/M70+BuSulgn9d8y8sUIwD99rjreD3z2g0wRA5SncapGomwe7jspbfzvYEtWjeSzAENq7C4E8t8bSB9FmYxFFesOUf0ZxF/Jphcm3NLzYajb+uYrh1ltn70PYchJM4ewgCVcGL+k6KEJC/HTDErfSzKLlcpQMTkoj1KckJlXsvTvu84YGHFXXlylT12dzbwXUaLbYDDcjy3VJf/ytSp+PwXeZ1xf9Cqg16i5W1YlvQX3PnrCt8Jn7BRmUlXKoSPLf1wgDYk6XTr6huG+bUf2++K6ZlHcO54IZHhvM6InJzwByI+v8JlbX9cRilfGuae4sRfvOkT9R/ZOj1yMkY3inzzskggauxyhouXB1He4gINsy622BmFs53Suqf8Yd6QKFYSNiADd/R/OGeMQ5RB4tKR3ljENzbVQMqv7HAlYnNpHW4NWwrcsRSQootzkxpR7wpU3t96fBRQzIr0xmdlV4fXXAthBH1NGcrGCmaB8ED1vFAi7alQlrMX57A/zX+Targ8BTT7y/VmFVfrlREWk2D/6/KBXR6NWjvm9VpBhJz2OOnSNwG3dskbyVXQ/Mbn85pJNtnFYQ1D/50bL101UTuvYQcUMIyZobRuYDnVUZMmql2igEeLKY9ktWUQ8b/3LkEXEAKiAwBXxpa/2auDXbN7vhn8C+oBmQ3mD+tMQ1ioXD3ZYEdTg6sgcDu3WSlA0nKOKf6JMklpEzLnoOunRhPxWi6IKbcb6rK8KPVMjikal0VYx72bJicPLOwTtZY1aU1+8LGirziuwlxhbdhYZC1O7G9a+kXvJD8ANZSyEaKWXhFQd+XOwz9ml88iVahVYKct5bV2LjpkKKOuMHhNExyP/ZIKSkmU2aPRtKpO1kFK97qgW/ZPN7ykXtTuUvdwL2yUU8ygvpenYhP/GQ
 iIVIp8jK
 /AITyi0CbfEHOvsL6uSHImjc32bx8KK0t6BW3aVv5CftuEgKGh8QzmwGscPg6UVuL8Y2H0lhDNVYKvf47/GWXoLWVVTYYf++kq6iQZSgRaQUoNF3//GwtccdpldlLIN2Oyh3A9B3EWkk/ELPhXigZAs6+/ZOzFgo5GguRW2RJWyP/SjCcIcqIypR+PRtzge6FaqZEV9ZSeSCT8UiRzWTjH6kcbEoN1OroloylbQOAuEH0mUXWmhcPIi/J5D1vLrbbFSkIeJYwK0qGhyYsHJPByVRGlnvAcJweHS5zTMzMJDlEomBFJ1n6WObAC6VkVyZgocHHtVE4NaelOVMo0so68pxA5ER5yJRlsgOhLd0Lk6YJLS0mgKBVisiws5Qz5CRhy82WRA0ydLH7RnZCeASYRaRgGKoJ7lEFD7qFRMMYto8A8U0SdqlYzrK9QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:01:34PM +0100, Christian Brauner wrote:
> Fwiw, this leaks the inode's anonymous tlocks. They're from TxLock which
> is shared by all jfs mounts. txLock() also sets mp->lid and pinned the
> metapages with metapage_nohomeok().
>
> So the helper would have to tear all of that down like txAbort() does
> and drop the pins. Doable, I guess not sure if this belongs into the
> series.

So ok, I tried to do this in a vm. With jfs.nTxLock=256 three rounds of
error + umount leaked 163 tlocks and the next writer on a fresh jfs hung
in txBeginAnon().

I think txAbort() might be the wrong model. It only drops the pin when
mp->lsn is set and doesn't free linelocks. So this would need a helper
modelled on txUnlock().

Fwiw, the BUG_ON() also triggers without this series. The error sets
SB_RDONLY, sync_filesystem() bails at umount and nothing commits the
anonymous tlocks. This series fixes that as a side effect because
sync_filesystem() keeps running.

> All the check
> does is make syncfs() return without writing anything and make unmount
> drop whatever the flusher hasn't gotten to yet. Which might be the goal
> you're after?

I tried that too on fat and ext2. With the check and an umount right
after the error new files are gone on both. If the flusher ran first
nothing is lost. That's exactly what happens without this series. If
writeback is allowed to finish nothing is lost either way.

Skipping these superblocks in the flusher is no better. ext4
effectively does that in its emergency state (ext4_writepages() bails)
and the stuck dirty pages throttle everyone else from testing. with 1.4G
stuck on ext4 a dd to ext2 on another disk crawled at ~1MB/s until ext4
was unmounted (cf. [1]).

[1]: https://lore.kernel.org/r/ZEnb7KuOWmu5P+V9@ovpn-8-24.pek2.redhat.com

