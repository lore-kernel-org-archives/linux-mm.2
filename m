Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A72606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DU1+xN0S
Received: by kanga.kvack.org (Postfix)
	id 859446B05BA; Thu,  5 Nov 2026 11:28:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809FA6B05BB; Thu,  5 Nov 2026 11:28:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7475B6B05BC; Thu,  5 Nov 2026 11:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5197D6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:28:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68FF0160B09
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:28:17 +0000 (UTC)
X-FDA: 85401597834.16.50F7BAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B898CC0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:28:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DU1+xN0S;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViB22PhtdvJTfgTdmabUFEVSK81diP/Lp6lp+HQ1/dw=;
	b=KRwjGqyz+MM819tH+x9N5SFNrLZCbLt53awocThEUkWJTeAkE4+lNY6V4ENbXbpbUiQq6C
	6Yfj3BsOUYeSJL/nsIE4cDKt7G5vOgMATPbQOdXZu4eNv/Wc7x9baNZ3OreD03VyD5EgfW
	g0l922eUHYUrj6xLQZ6vTwOkwwjOS60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793896095;
	b=WXCRm6lZnwK8V9cnmWR7A8VuEFMbPvpa/kH9Dqf/QXc54Fg8MqTqEwWaxcHP7xugmtAGYz
	hbl2jll9vZOCF8G7W7hJgmO1j3hCda6gU66ml/u2pkuw3iDNPqLz6AbvWZiOU0XXanC3tH
	HVTcXQmZjRXRpUimR4pAb9mhWJ0WZGs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DU1+xN0S;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D932740878;
	Thu,  5 Nov 2026 16:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01A41F000C1;
	Thu,  5 Nov 2026 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896094;
	bh=ViB22PhtdvJTfgTdmabUFEVSK81diP/Lp6lp+HQ1/dw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DU1+xN0S4hrSiUhuKCm59PhPJnAjG4puGZJ6oHeW/NZRdyZD5qCWNJ5bGwiwhCUid
	 H2TyEhWt8+dbHek4dDNgQKSXtdYHs1xDDW1ffnJV/KheipdrkILjy+9dyDtAHiu+6K
	 l+2A98R2q/yak6sHZzXw9eW2UOrPRSrlSQb9RDVH7JAmzTCJeXEtVJuKgdqWbQIg4H
	 +MfMxVklxgvK7x4ELR2J3DfRKRF6z1jRm6e6LCAaoquzBk2PXXZPKKlLUa04Iq0oz5
	 G3sP0IKD5Nm8OmVj+VvXv+wC99IFu7aW+qFZ9Vve5m6XCIumQjXTIF1GHLhieDyd5c
	 whB9slWb6TIsQ==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Andrea Parri <parri.andrea@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261026180619.4147910-1-parri.andrea@gmail.com>
References: <20261026180619.4147910-1-parri.andrea@gmail.com>
Subject: Re: [PATCH] iov_iter: take an unsigned long segment count in
 import_iovec()
Message-Id: <20261105-fixkosten-firma-regress-e73044c88ac5@brauner>
Date: Thu, 05 Nov 2026 17:28:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1
X-Stat-Signature: btyj5j3rpmutzdz7oumw9jb78ya8z1jz
X-Rspamd-Queue-Id: B898CC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793896095-343563
X-HE-Meta: U2FsdGVkX1/lB4o+Pxo1gyYTKrJCm5CjK34waKO39q8Mw8U7MCTwFJIeQ06BzkupzgtO4//CEtBnahGLL1hUp30jJKZj7uMgp7q9gns0jkS5zWTiXKv/aBIZPWcPGiE4Z/uhPq3qohg/BcvLCQf0iEgUvjisHB482yw6Q+Su/pbyTCvcyZ5cyDkYN8pZn/4Sf2aZbshA24g4bWJUvALfyqMWXusDscUIg83N2dyOAnauPj6Aq25+PXGSWoRioBiFXsDrvRMDl4w4ACIIR3B9JthS9E9HvPZzQEaWhzq4Zlt1YynIuHHfpb37ctwSQLEkhAlg5lHhuDlWIpb2LfUYu+fX5ynqJTMwTKxqNbpnfKh+VeG/+iNH/PJgCoRuMm1Yh+bONKAbEmKuVk2IJyus2e9f6UYKtpsKKphWdpLrjY1I+N4CKyo/M+UPXFrlWRV1FCVXtBrX1SJDsQxzPIkeMrb7Y0BF9YLHdv+NywHjdwWEvlHmD6k6nfkA/vzJTQ1RopntnoTFdESv819/CxeHBfjlmvSpIg/cRycwPupcPZ3AYeGoQ9v1jLYzaewri9zJigSnR4iIcK3SvVLWHTddJZ6dKYwdsrYUCpQoCDqsgDmTyxIh2M2INppZWf1UQH7cD1J2Xo/LucGP9Kdcmt/fuHpB8RPUTzbFbb0cqFB6D6yRMj+2qVtcQ6P/INInSgs87RL67yHSesQkSWNnua7ip+EZdhGTCI40RYVbJQrpIQ77lUfe+gFYxZszNuDxAFgOmyIW71bP8qcCksdfyMu5q08ZdjKxCUYhb0J2nlJTFSdKk2UBvIoybkSh0XBXrt4YJgP61fVr0A5Q/1WjZFeTK2Yq43HVnrLhGWKLgE6kTs1X6F02OLmSFhzdDx5yvOrlfVDLCuF1e8nDcy0qvy2CTQSGPL+pdKh9FT3LWvpya0Tep6P7Ki9cUb7Y/oqOOYwx3OjaJVImnJcwoQlDpDe
 Um9dhR8T
 6vGn0uYjzPym7lbIbhLJtqTC7sY7zZ0m54P1oTCPhvFMDju45FqJAij4rqQtqYRppjw1Amh9ub2gwEUIu1JEg5r2pFEn0uuqrUgVdFEMADO4+XK36hmigYAVh2hK9iAZ/LKv2Ku49kUVjqUxm7HbqP6Qeq6zM942i3kj8CZyNPb7emBO8lhoDyg8GTBr1Ivmg+je9iwv6olvzm3h1EdZEIdlz0Ifv70DvMdTRcCvMdKtkpjnvxwoYhsV5JNyv/R81MbQsZZQlTxwxvc6g+IZS3Ycg0bLbfjiAjXgf7Z1wtCt/rjditVUJOv7Y8hbAHtDRymgVaf6/f4W2GH6XVnWyOKBXEMxNSQseELLdxTWGseBYQd6PJO86qUIERNmg2zgFsgUwN9Ca7RdWPQFi7YH5DNpLL2UyMzQuEYy4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 19:06:18 +0100, Andrea Parri wrote:
> readv(), writev() and their positional variants, process_vm_readv(),
> process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
> the btrfs encoded I/O ioctls all take a full-width segment count, and
> all of them hand it to import_iovec() or __import_iovec().  Those take
> an unsigned int count, so on 64-bit kernels the upper 32 bits are
> dropped before iovec_from_user() checks the count against UIO_MAXIOV.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iov_iter: take an unsigned long segment count in import_iovec()
      https://git.kernel.org/vfs/vfs/c/7a15349d271b


