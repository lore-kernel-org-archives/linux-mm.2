Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8D6606A889
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=L8lfDTMU
Received: by kanga.kvack.org (Postfix)
	id 06AEA6B05CF; Sat, 14 Nov 2026 15:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36606B05D1; Sat, 14 Nov 2026 15:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB07B6B05D2; Sat, 14 Nov 2026 15:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B03F86B05CF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:06:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 258A4A03EE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:06:04 +0000 (UTC)
X-FDA: 85434805848.24.5768472
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4AFA716000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:06:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=L8lfDTMU;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	b=zDkzrpRlfQBw0YO6H1yBZht2LWjvFw9dx2pWoCTcvhgMvC9lR+zfQp1305ffss7ar1Wndr
	hwdKcuC4+ejAE4UKkR6mgqvGL1je0+qyxk6qAXvk/pIpA38jH61YiYLGhxu9Cynqa/teRU
	cfMUYX4JOT+D9mt8yfovKXIgrDFOzdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686762;
	b=2nCkaunvO4JhyYXd6AbqVAm298lFPxvgm26rmItMEDxr957Z+TztbZKqY4AmTwjV2f3d+1
	bEQBFxVjhJjKuQ+lA5lwGcX/KGYsZUxC/H4Y8QmeckzaxoWqNNxPiWvssK1m1LzHjp8ANE
	rZ1RAcYkAB6Rwfcb8HPMqsg6sw/p0eY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=L8lfDTMU;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdb628232d2so2076438a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=L8lfDTMU6Gtp3cQtIwANS2qtRtos+eig8oT8CP1hnaIgiUYjBVddYXZSf9QVW2CeS8
         4FMv0q44ve0T6GCvPvLoUQWqohdyfE4ULUDVxK+vXRz0Sb68S40wfXyJQyus6hWYD9AR
         OUAhpgBou4QHt4q7tlDP7ulzgNUDH1Xhd8Uek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=GCbKMqLxRk6IRsZxCnebvEEApxwMZIv2wnfF834/yH4Sdd/5o7cK2A/wNPXqAVQCLH
         iBQD0gXeIpNFxTiN6l0NY0AvbSTiDP7NNuDVBhMgTLHm4+2vHV4hIWlb/H5g5oWJt/xU
         qhbqFZYMcJJvKsWe9qlG5wQECZ58nigl7ts8Yv3we9QRq31pofUD/lUK+tS4ixX19Ryo
         GZ4k8yjZL6iuXWdL7z2+kIg8NPaI7lJ9sjSXXnquJDvrJDN59PspS5ZVaUdRD5uJ43gr
         gNjFE2LsIf5ghEIj5Fc4HPoI8d9xWOlgW7FzHa6DvHvRet1pTuPdAuldocAYyeD+O6+l
         71Gw==
X-Forwarded-Encrypted: i=1; AL+hErH+OmT5igwPCbttjb0NJuwVNgLtu+XKtnNmtnpLK0Diwh1DVFNcVJ4GlhlbyBAeVELwGi7megaX0w==@kvack.org
X-Gm-Message-State: APuU4Z99CuNQ1WIdCnroxa55j7VQau+akD6w3lMJLYV/p1r222zPqck+
	bKLLVPB/w72uVR6MwBXDkaO7lBDkRz9GI9btjiPM3GbOYvv3VYqeJ9dEWawvPaYcGko=
X-Gm-Gg: AYBFou18qzZQ0LtIjJLv61MeEmqajHDbg6C2dXfLhCwkzgXs9AmSI8JH1+a6jHkCkKc
	eiOwVO4mVZWaMwXglNWsdpLEle3cnGzKFtwC4irBGBhq97DPKXu9eZwLD7e+FUsrOx5SuVMSEPO
	9CeSiKfjgIMvrKnxDEEHPURaZp9MGOYjj+RG/xDcxeQFdYrVqojLKCc6BrS+lAtnELbPuXXQbBp
	uNwaNvPuI1j2S19k7PnvXewh32QFe0AXeixFjLjzZRXIC2AjgiEQgYo5vHfGltwn/ot80ZXskDv
	ZiU3hPhpdR49r6JmBug8WOnmWp7+5BwuESwHi7mqEGfimFtIuVMwGfdyHAj+qmg3zYPPePc2G09
	4dfY8YI3mXK2AfWKgRvxvlhUv2jMf/zs8ERdmnjSwhYP73OIozwgobZhVFQhXij2O3G6mZd6oru
	Xn1V00OcTF+32Rr01W5fttw1JfLRqUWgNIgpbyjJAO0Tkn1GqlRR7RT/NdBK2OKvvHdpszJ9nFv
	/7r3PmVUMUsacxPzg7ac77j7EGlMnp/Nfqn/832AnVSv0KKiAF9R4QvsPF+Qnk/1xw8pk8puort
	47o8ZBdHyipXe8uJ7bcejtZYctGFAs6/GsagNVWfm1Zjd7PAPMPxESfRTgj64b2Bjz9poRmyQyU
	/MPHaHmXnTm5qgv2J6Gqs1GdjXj7lSdEB4+UAwloj0lSkB26psgoS1q7vhtfejH4OjckfYhkFYS
	/hw7PiGIx3QZtXLMXIkbF46r88dy/7vDbpnA9UITWBeoWpXXA3npkubsza
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 8dqgj4yegr6mq7ke3dw565qn4tw4k4q4
X-Rspamd-Queue-Id: 4AFA716000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794686762-624438
X-HE-Meta: U2FsdGVkX185c0HRX9sHPlz0P00WyKSgDlzhGalsS8aMxCe+vLdQbkmwL2Sc1JeygiwoWf4HXZyJN+3mO7L/4vj7i3KoJ4r7zMoGoOYMylVX/1mmHhlZk/6EDglJ+nziMbK/kgyKIcfnA2TLNbyEgFyttEl4n3VXPOjnlu/g5QCf7hZajwgO0qf7xxtYHYV1Qz7JB6+zZSiDIf19oAgUrxEnuDejL0pc1X1X90YfSfoDPBXLim8jxiYqlkp7aG33BdEQ6U+RyFj0U7/MfMP84r/QzY2251fq2JUYig1Ty4ox0bamkA7dEuiPn+DeXFwFNULu2hjVYVpaAcGJSdESTcpWv1KSjIyQ7yvPGregGSP7jOFrlSyMeeDvJUyDxYWSMftcqNsY7ZbjKqUDgTeRuZg/opRwTIjpT0+MYnBuDwjz31Iy8EQj9rE9DZJVe4fEmVQWXs/lFc1zZJKfs4eqW5FPxGCfAvF2hpahgl1nGPdD+dFkal96v6qILjvfrnVLP2CMjSMco1A+oR00OMRHWzxUxZMGabj04ZQ7y60Kze1U+w+0kf0rxb7hXCw8CPXCw7MHPFnw6ygnLDj/xOiiPXdMJwXjYoePVpDJxY88ZlMovNyekCOQ1yTuqCvexmUdGAIsdp8IoAy5SlwddBpNNXe6NpzjdVxATrBgVTgS4d+0UdMl7/dhmuiQJu1cpK0CqLZvS3BM3PQux8cwwduaGd9bwOfaSil2vBVlo5vYWkLFdUquMRi8g5l1nrsQRbq0axk+Qm/AMlLj+X5Z8YP9hbB6yhqwnPM+U/Pa3XBwDRus5ozNQCuu3Apsn9F2jhsPEoJ7GzdKxPG8pe40kde4IYWRyiNTq5VuzPvU18g03ZHgiNGEmjA0ntUL8m7vPHPoGHpFTXizxVkPGwh2xmGLQ5ZUclHDvS0CL1yQJOeGp0twkfu/ZrLTgse3SwgR0R9uhBVC+bTjZhmzcSwX8ZF
 viQtfRzD
 RM1pb2i+mH8tIwU9s/IdwawIjgAzUAG5wuH/nwCzyKCTwPJiWxADeCzXjb3k/EmLzfuHpjVbD1sL9vtDeAXdnjCsG7CbnY6dfqC2SpYdctQOjQkob5P5zG5ImM6SF8GzZ4XrliwVYqBEXwnzRQoR/QuTLN4oKSoIsplXDxQYcYK/3f6YFSwcpCcxsyShp7kd9fk43H4h8ilWIITNUCPHtQPzS10dhU0J6QhPPyH4z+5vARzAcqnfLeO84mAYjVLKeSCOAVTH+x+ZF59mwlsQGN8QVUx2TQwRGcAY6PqgP6OFT7briFOuXETBM7MvdIa0WqNm4MwKwx/snIvlC9sH1Yjk2ZIOoCkocaReelfmbIEoT9DNPflTfPCS9Olt90SdnyAsm65+wRLpuPLblHO4cZ8FiYVD3cKyY2bXQsqpW/0Qzet/5GMuSt3r+tksU8nTIh8zKkel8LBe3WEk5ySuNQcMWlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris

