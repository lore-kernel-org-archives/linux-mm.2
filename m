Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596E5CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85088E007E; Wed, 29 Oct 2025 10:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B353B8E0045; Wed, 29 Oct 2025 10:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72358E007E; Wed, 29 Oct 2025 10:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0478E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:55:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3816F140817
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:55:29 +0000 (UTC)
X-FDA: 84051450378.03.D590D3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 78A718000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:55:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biOKv4m7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkIncgflb7jwVpf+E8ZFUui48GLLLzv5E6dZdLJsuk8=;
	b=S1OmukwfReMn+UUYFPiDDkz63jct0j3vm+bRY24EIdgYTncgfVtHTgwnoXyxypAz+xmT7z
	kdvQAy1/ikprTwvCsBzMxVCvv82To41feOdAX+GIxR+kTUNXglwbONO2PExcjICqE0jCdR
	FEYC7dQ71N1eiS/ZGQIikHjr8vMUlbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749727; a=rsa-sha256;
	cv=none;
	b=e8b8RFnJftCx9Lbx8IZ5slM9okcbo64xZQkSW9PQArX9gpxmuckKOPbbup6mCbi0jqEy3/
	rBit9ddVWgBpNRhrHespt9OAd+cNNhoVmtVvejoslCGvh8dn7kgulyJPWWEa2t6pB2fGfz
	X1Y0hsWcmntII6rCIMGvZG2n/1gCXA4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biOKv4m7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB6496035D;
	Wed, 29 Oct 2025 14:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ED5C4CEF7;
	Wed, 29 Oct 2025 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761749726;
	bh=Tf3oyzfvHzEyA7ChKDcF+F1C9VdlPPMCKrZKRQ2B/Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biOKv4m7wm5QgfmYIY19pFWU37OsKh6W28igBr/pVfCzRSMugFui6y+Mg2XEeeIKg
	 XEUpW7JPqP0enoOY9wyo4NNkXQYp1uB+ySk9FGSfpRObWuv+D0rWkvtkSaktIBBJKG
	 ZqzP09NHDixfOKfkrHxvrptyvDq9ZWfKzzgRcQGwAjYhFTGaWZq7qGk7RL7eyi4bLQ
	 y/RQTj2xFUTYylf94XlffqMFgx9LhLoD2Pmla0NNXeqHt4vJLazKsSRx/PUPnn1A9h
	 i6zbxYi5W78KqZyT5E7WZ5NRpfCt63PPEYekAC+VHDphOILKgdYA2dKTpW7LXXh4du
	 sOmJN72vR5pqw==
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: allow file systems to increase the minimum writeback chunk size v2
Date: Wed, 29 Oct 2025 15:55:17 +0100
Message-ID: <20251029-heilung-amulett-1b15f6b0b9ef@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1554; i=brauner@kernel.org; h=from:subject:message-id; bh=Tf3oyzfvHzEyA7ChKDcF+F1C9VdlPPMCKrZKRQ2B/Rs=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQyaV2/s8reN6vaXC+/4+oitkvnE2LZXovULT5eKxX67 I1C0r+ijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlMzGZk+NM048DH59lhr3Qv rsz69DV/wrrCycV9ZtNN/xa2ffU+eZjhf4w1j1nr3Z3b3/2b3aykcpuTWXSvxoXmyQf99UMvZt6 YzQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: cbzuqys16to6ssbxxgwjq9a1pxi3b1id
X-Rspam-User: 
X-Rspamd-Queue-Id: 78A718000C
X-HE-Tag: 1761749727-499763
X-HE-Meta: U2FsdGVkX1+4CK77i/YoeNEuF2boUcK7ncarOuGuOnSY5kRxtaEMgg5SRZauq4fQ+fKkMBYLmucfvGU1nk5sssEEhIFWGaESw/XwzmsqbV8a+D7rams4lGxWYseJ/mma6+RjiydoiMfx+FS1bisy1pJP3DAW7IMuWRnIAZfDKuzuzDls7uo5KZ0cq6s+fC6sTaruJfjZSbS9cA3W6M+2mGn2yiSFtUIGeEbeFV6OjI8Nz5f2VF3IFgKd51MNeEUB6stkPyOLuYhIidVE46jyeoiptq3Kd+YMQyRxMbCLFu8OnPf8jVSHKhOZDV1WBU8dX2o2PfgWUy/Z/5xakiGSgv3GUHygMw/f8MIkc+HxkQ+uXtcgkmQWCOcqmdRwSvuIAjPvV4Gk3LTO5lsQzz1Qyw+TS4oTaKhQgSiXsGcOK6iG52MHM4TAhmYvJC5Xj5M+DN1wO4TBoeCmMGESuVz70DjMTFxr3ZDg+YpsB3IwOeq/Vo5P44t8W4XtHQ7UxMV/YKXL8ge8rQRHnPwjpSW+oBZglW4S2XaS98DUh+qUCv8Ut9ms/YZsrdw4coP0sbl/jT9KRv//6qr3edXNwj2BKgmBHK08kBbKqnaBg7GlwgR2Uvif9kPLIF6taoumgjMeYnoISkYUrfvWsfRliE7c2rtbk6sEsqP0kzATmVUdp4CH0+zPL8fe/F47ZLALjlN9il0bhj1nX0cIkPlZXf8gzTLKsifNka/esEIXk4CgcNUlpDl4Fdw7fniyTb/j3z9CSFW5Kj7LMpuPeOPA1fzSN8k50Egv4tDOJXcScaYGH0iPF7gK2Jfl4cLjPBQFFern0Fm9E5eSRzpjJb/yRg2dbQkHxlEGJBoPwamPzZ1WWWSxIHJ4liLcQaWxGyoULga8ao5UckHaZZBmDNTj+SOTqa4K30x6a8YdKTF4cRIlZ0t/A20TOEgvFZj/IxSaWzVTb8DPEnIscbKDpBsfsF5
 FmYBEbbI
 g9Hclzh01TkP8PZDL1dfYZ5UK0cEPCrrEHETjlIfbQgeUMhGT0TL71/UiEpQB1FXoaKUyCWbTZGDQLZj6fhfHBHV4yLyAqopYuVhISnI1hE/RTZdXtuJl2DCSwoREbClLywMPFWIdP74VAelhp7OCgxEUK7rTqMNHHzdiJjzBZRhL5MRG5E0/jzqS1HJxH5uzVtox4+f1XbQnVlQRPyNKyBGoQIs4tm3Eagx4FFx0xMW2r3UBfxZw353uaI+HbbZxT6qfP9V3RWTuJQlOxsmT0zN9qYUcnbx2FDt1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 05:45:46 +0200, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size, and set it to the zone size for zoned XFS.
> 
> [...]

Applied to the vfs-6.19.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-6.19.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.19.writeback

[1/3] writeback: cleanup writeback_chunk_size
      https://git.kernel.org/vfs/vfs/c/151d0922bf63
[2/3] writeback: allow the file system to override MIN_WRITEBACK_PAGES
      https://git.kernel.org/vfs/vfs/c/90db4d4441f5
[3/3] xfs: set s_min_writeback_pages for zoned file systems
      https://git.kernel.org/vfs/vfs/c/015a54407782

