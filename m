Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82156606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzRYE13j
Received: by kanga.kvack.org (Postfix)
	id A0D636B00EF; Tue, 10 Nov 2026 15:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5286B05B0; Tue, 10 Nov 2026 15:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921D56B05B1; Tue, 10 Nov 2026 15:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2036B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:46:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 029C0140766
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:46:06 +0000 (UTC)
X-FDA: 85420391574.27.E47EFD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 649A120004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:46:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzRYE13j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMRPONQOYjAF9HKKBayLjA2YuezRW4mL6HNg3dL1nlo=;
	b=qZwcRDs+iO/EwMqaU1eDDkgosHcLQ1cDB0gjikHhrmkYiZJqDuBDnqsfbXP+WlBz0e+7kx
	BByJdQ7eGmssLyBY8pv79NDrNJ+RQ7Se9O3AYWYaEI10GfzpTEb9LR5KlLylt6ZUCvxpQH
	i+HtvJ9rw2XazDih/4plK8G2Gut+OpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343565;
	b=PaABUixmrV9wyvtWyjKkXeJGRw7ktmMITrgEoA8E9hQ81WewJ8/msIUlLWj1CtPsvOLYm0
	38WF2D5v66lkDjqi3jZvb90n9WBg1GC2pblRBkdJVlKRTp3R6UyiguyM/sEvsPBnhwVb6V
	fjlg8W79sbGqKMV/8i/W1djVq3XaHYU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzRYE13j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3045618CA;
	Tue, 10 Nov 2026 20:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D441F008AB;
	Tue, 10 Nov 2026 20:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343564;
	bh=rMRPONQOYjAF9HKKBayLjA2YuezRW4mL6HNg3dL1nlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HzRYE13jB8RdQv3aSy711gVTQF5aN3kmny3Bm+Tqd6DGpMnW/UdmBhwvuV3tDKwWA
	 qBQkdAe99fCfyY4HwhHW6vpWLb11tiX1rqZm0gqSH24JDOLS4Qw49hrn6RKPLTZ5tX
	 8yK911/kTi5YKMv0Zeg0t9hinxeSS095ez81rveTvDj3lhZIp5MNrpZ0TzLVXjAROD
	 H+8sIgKlcwqIAFUbaPlcIA/mKF9hJXlPwet/3tzJzqABID/FKMqpm7AOyUBYjWme3C
	 0bNu78jINjA9S3ckBH6UNePnv8GkZJATc2s+TTg1AYJLjtNo7jNr7qgY8y7Qdi6pm5
	 ugUx9cOxV5vJQ==
Date: Tue, 10 Nov 2026 21:45:52 +0100
From: Gao Xiang <xiang@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
Message-ID: <avOCgJPOwRdsIxgd@MacBookPro.fritz.box>
Mail-Followup-To: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
X-Stat-Signature: utbuxajx5eiktz8usfsghzgyh8agsoia
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 649A120004
X-HE-Tag: 1794343565-763499
X-HE-Meta: U2FsdGVkX1+MAXs9XoXR9SoK9fiRvB0Fjnmb0Wt92HxBKGk9sOdc2Ef/g/aXPfuBvUzIvZclwsBEjapAEE7mKXDK9v971qPtTNlZKBYfBGSukeJ7YQ4PZzLKryZ7Nwt5M1LWW5TrXRIov5khKUSQ+H5kvihjhG0F6mEJX3/522FuE6OKUJab3EPAgZZuQ+YtsY2b97wY2CRfmQiLwfB+0DuyYTyDXzMilv6pWrX/cbxB1zbild1SuIeYil8Nm8QTiXNhi/gtI7cPkZj4D3k45n/9ehyDBYCznB9xlXNj4vYroIXqMqHFzuyyQGpaRt4EtfosZlOt63rRnE2vQvuyzCbQqlge6qfTCkZKHGbQB4OQVHu2c5zTjnAgeTS7HZGluCtJ9gaekn5+2cAkpdt+p6A/vS68vzZvdqVp2nYoBr3rXkfe4rYZ7gG7FzJGbv9pbVB8DFv8wKL5pFBarDKLiQnYRYzAqd5ZBEQzio53fMbTc6UvmaaVjXND6He3C/usB+sXickoay2tmzdOvbSOmml7qafGQ+/quF3Kt2xLWsXZoRh6tYFPwaoUMQKs9JxpmIAP0YS+GQIV5nFj4tUc3Qt54yvXPjqNtOoHyCMMIihskj5GCaOv31w5lvsBBTPq0B3FoNvJ/XNt3CvkzTvLXOL+c1qMDtgpSc9UwL84z6d0P6AMcHxJz47J+vrG0s+fVhTunQKN7eKGVQ/gWEJEBZr7qH81pCUOKKDdIdnpSG7MgJ2sCDiPh3Lr/+/YdGlOFGeA5VjTaSt2nxUieh0zA32Bk7+44gybeKvzHJ9pl0B+OIyd5Ol6zUgfJ5xVAUt5JNba66OCAeFszu5LDprqNUPuMw4bIdrNOOxkI6pdqpvKYYKigGg86QmlY1zZFQF6n4Ohdj3KMrRe7KRRlNPfcfatLl7IDXP1CBnW45b8aQEGXxT4/8pR2qEKlOCNPfNbYkKxVt1//4VgcQfMdNI
 1gnJnXYo
 ySS+nLNmfIQNxGZP/8UVoKH51tluF0OANyDcwQ3HFYM+YLMg3Ph+Y+kpDhRE+ZPUuC9v9thXkSVGJ6UZoIzoOmHT4c4o5JoOVTyTV5HOmO881+3x+tBmHYw0TTyvqwD6Y77DDjFd2ByoGT0xkeHm+0psADGmYY+Mq/EK2Kj5BN+5mOcbGEH6cEoJ4LOpAug+k5UIBYmc+8icYgvGF3NYgcM9ur6vLCxpEaBd7tYtCKUG/poVTRdQR1b10ZB4ZZRA76ohaDXNVjMSHdp5edUZN7EBbrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:56AM +0100, Christian Brauner wrote:
> File-backed mounts take any regular file as the image and the same goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

