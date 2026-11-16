Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D650606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhEMPzkS
Received: by kanga.kvack.org (Postfix)
	id 906706B05B1; Mon, 16 Nov 2026 08:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD6F6B05B3; Mon, 16 Nov 2026 08:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81ACB6B05B4; Mon, 16 Nov 2026 08:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0B96B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:21:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E678F1408E0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:20:59 +0000 (UTC)
X-FDA: 85441042638.24.27A0E66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 435CB4000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:20:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhEMPzkS;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794835258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zwp/b2OseRP/BP0MRnYEMv10Xx5652k/ysAi77DyTUk=;
	b=gCUT+/pNVbUA6Rf4fTHriEsd5dkfa2Dr/IPUSluC2u1TYu5+V+BpUk+X7swKzbsStvzoEN
	9qk0Tlixwo2fXu+q8M7cXjgejVQlhbSNpu0qFE0+ctKt8aoRBy+s/df9n+wyEF2PLzQC9T
	5llkwpG++6J4/IG+fmieOA9vrXxLIY4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhEMPzkS;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794835258;
	b=NwPYZUly4eeUtqzAYXrKjM9Zq2Fk6rXmOS86lU1d1Gvdgc3MWgTUOSOx394YYL+gdt6558
	qAbjPg/6eljQaMeZD6EH7B4Zo0hFMCAP7PSxUxqu2AGcDf1bO/NQ8ayZI7cn8sZWWHL4Vi
	WQJmlQ7goMBi1oJ8N4AtRtOvlghMLA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06B4A62A16;
	Mon, 16 Nov 2026 13:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287C11F000C4;
	Mon, 16 Nov 2026 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835256;
	bh=Zwp/b2OseRP/BP0MRnYEMv10Xx5652k/ysAi77DyTUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MhEMPzkS8ELyUuZJvWfSoeeWuf7By4IL/aj2kb/a2OV4l4EgVqKXjiioyUz2RieNk
	 XgpnwYQk+l7IQUQIb2TJG9rqwlNZZd2t4tSSz2FIOFgSK4qv3MUw+KnfbEysg8x4iS
	 RMX98jFDrMhGiTX7izqJwsUslncHgd0fLN7Yyo0X4gX89YKFy614i608nuofc5428F
	 SfK4Vb1AO45G7cvMjjgv1ixrvwKqD7DXpAnyYbrMZDnbnAmpR0a9mRVyF+s9eImB9m
	 jgQn4Dmx1KWjFDTc0G8bS5OCGFot8PkE1fqYZHJngkkRDFtxZNJw9/svWtFGNRWRiW
	 sc42i9H1mtjtg==
Date: Mon, 16 Nov 2026 14:20:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org
Cc: jannh@google.com, mason@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
	ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, amir73il@gmail.com, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org, chris@chrisdown.name, ast@kernel.org, andrii@kernel.org, 
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com, 
	yonghong.song@linux.dev, ihor.solodrai@linux.dev
Subject: Re: [PATCH RFC v3 38/44] nvmet: refuse files on pseudo filesystems
 as namespace backing files
Message-ID: <20261116-geplagt-gemein-zufrieden-72c3817de2c6@brauner>
References: <20261116-work-loop-pseudo-v3-38-8cbbea1cf34f@kernel.org>
 <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cb28f09c85a473a23f14c9bd6ef135950197c9fbf966c1f7055d791977d29286@mail.kernel.org>
X-Stat-Signature: e4394obx3ww9n5ghfpsmyep4w6wzi9y6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 435CB4000A
X-HE-Tag: 1794835258-203320
X-HE-Meta: U2FsdGVkX189yC4Orc1isgJgQTUKK4Ki0fwJ/Pq/Jk5XRnHexrST3d8cM1sHyuAa0T411wyS/Suj1aIA9NkbwhWdvjq/8F8XwDxnm8JFVJe8TdG6k0/b6ArIeyVY6rkPzHXvZVLCQ1pT89aqMkPclZMEIhMovtVhKPG3zivG7wC41vh0XULAqhYa8McABkENfy51677lR730sB271gSv2wb/oEzuUKgLUvPhIPsew9aLHdl0wpmfOL80VWsHdteOgSZBBBVlTZO3dtfKcXgHXdQVfnqi4ATArRlTG3LT6jWpU/pS1UJFTiAbGHwk4xX9RncRisCbf4SXVdqfE01eEz+mUSjP5xE8OaaLpKp3HRjqTnCY0vM5AprnCwsWF9p0VkZRcLzQa4kQX/b3+pfZyjFnxld3VFRlgebSzzRUy+/qW/MmY+p9OGDsiHX6aXfigE5Ctg7nAttL5oPk5YDJLpJRXJSSIL+DI6vbcWObLUUylAFZCPxERpmoLSnDI/5F30CwvN57vgsyijZkk3DHj6INDSVz4PxGEkMf6Q8YAahhc1GKALojgdDX+P2qxEytMnn6YrJmj2tsFeD18f8wKkD+m/U+0uym9OedSWJYpVA+8UhWp7fq1mWPvsz4CDyqFhL4UBcGooocXIOnU7HHCvkOb6QvBQAClrIZkqYPGgpQ5VNG+UrVE0Dl8LDBePkKKpF37/wXkgHkWTnn+mdrSe3J15JQyLotkkrHKJ6rM53MB/Z17KoylSEbmLUtX3rQ4iRfRxM/g4x5hnXL8518qiQe27vhZLCu8Zo7p6tYVHpmBDDRx5YZAgHwuxIb3WZ+8mHzfgR1z4Nh2dLdxfxCdCAUhNvn/fmenjTg0mGTpfITa4DA29v7BKf8oaPLHLpJAqfxHA7g4sCkPx0rdYV4geRvidExDJUv1EoozACOOeB3QNGLmnExooXs+nE8ALaH8c3N1re+LL4yopwLbuG
 V8ZNGQoX
 ekPRW8a+k8/VKUmSZeaNeTP+k3vWQbPWww0b9JxoRvj6ScYUd4pnr296oFNq6/dZZ3e+wTUOjeHfTyGVV2k6fe9zR2QpB+hRzoU/sfsVMdDYSWYP4flJlr1QRK06v/A2hn3ldIW8HhPSJdMfBFizCc4ctTR+PxPgGz/kfLvpHDDSVIYGnlXLGxStV0UbABI6CqfDx5vMX7icH3/7Rqv61nkab1fHPM8SPlizeP6XK0blnmFJODgNfRq5CPjUgWTb4JEvx63dTqZp3MXItcmYtPfMog3wyEoDXdtMI6E5W72rzBMk1JV0XW7MIdNIZcVlLE/mowgHm3JE1WTBLX3sru3Hp/XqqF77/48WhnLV37mOhnNY/zD/yvF5DrX/twSCMsR21PgzPt75t4HVE76ZTSzMuwcRrD+h3C8vj2NJyALYioYTi9SID/dQP+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:00:14PM +0000, bot+bpf-ci@kernel.org wrote:
> Is a prerequisite patch adding d_real_data_inode() missing from the series?

No. d_real_data_inode() comes from "fs: let d_real() fail" which is in
the base-commit of this series (vfs-7.5.lookup). This was applied to
bpf-next instead.

