Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCF0606AA75
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 10:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j+2By2C7
Received: by kanga.kvack.org (Postfix)
	id 4626D6B05BD; Tue, 10 Nov 2026 05:14:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A586B05BE; Tue, 10 Nov 2026 05:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355066B05BF; Tue, 10 Nov 2026 05:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1170C6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:14:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70335A84AF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:41 +0000 (UTC)
X-FDA: 85418800362.25.0F0D063
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D12E40003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:14:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j+2By2C7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794305679;
	b=J34bGtrCisZeBW+gNwOdsEWazPbnQGrmYa5zrU/ETVFIzffYCjRPlIVc0g61DY/Jpgd3us
	KDHYdMmfyc0oX8zF9BbAJs4CRnJmU74bNgGDVtrnjimxJ0JzF5w3aZZgHTgdmxD60Bz/uB
	DZJ7v29Ajly2lum61DyijFQNR7R6H7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794305679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	b=Cu0rXXO8+zaBo8TpKJNOwtVQyczM3k06S8XdxWqLB+ixbDRldd8aFeiv/6twF2nn7hjeg4
	gr5vKVLEgMtwxGQUoHE6Qu8J7+LE7sMCnZChh003RsbnvJkpMszx7ZYK25ZlYOiWVrz5pI
	Rt/KNyvCnLeILZiGo/nBeJ2xYDzmyig=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j+2By2C7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso2304491a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=j+2By2C7RGZUc6L+OIT+TeVkI9LZYaFCulcig/11334ulNB2qKzk2ReSDwdy0m1nf1
         e0ezEjyCHYY+67Cm7hl1IaQjxshXwW/aKQ23CLFFsGsD994mnCIMFMI+TfnQxV+KRnxG
         +U+NxDQ5ajT+LRJf+bL3w2n7SkLmKv3EAjTvZKvCrJhm7IV0xtzcvm7LqXRHThmzc7wP
         hFGZog8WdK0lzaT+EsR+mpYkJq66Lv2FlLeLau02h1tY0MFsswTCMc3s6WY0cZ7GR+TF
         aKKoECQ1NSgK38SmWOE6f8CpfkWgbzr3FLKrQD2XAkovTGSGuuEkRZMaZs76vTAfXpHe
         iQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=LLHO76oIWg8tET55aoQzWCyibVy110vk9uU7Dlaz4QXUi5fVE8xS7jToLlO38Ajeqv
         C30VM9i2djqhTo4jKuyET2BDKe7mFqMieiWydI3rEfDn+mY8gQlPtW5zOLkQO6bAuHS7
         Yi9gB5CxIEZyWu1eqxDZ79O/pCUeYfhuwpIiOE0/oSIUcf2vO6pEDBgpLaZAmJhAO41R
         FGXGTvM2Bi+9c8bNphKwEvzTaS0c0YzqUFuLV85H02hX6l6EeIquj9SKuvhMvs84tISG
         bnyFn+ZSL5eXMb2gwoI0Jm9DG/ZQ7jhgKvOIXHmixeLcrNZneMW7KnAYFK6KbPnsTjXb
         qPAA==
X-Forwarded-Encrypted: i=1; AL+hErEA6tWfKVIaSWB8rxuNyUVquX2OAl2YJ4w7AVsniDAXrcdCUfbC5Snqg0OzhW2BDuHYrxgLKm58TQ==@kvack.org
X-Gm-Message-State: APuU4Z8JOsrjihnAZi3NVI1V0pA1FKjNdTuBapPc2wnsU+z2xJRpJYMG
	yI5jLb9MW+uOxdr2aYzJ7fj5uajpBUiWOlKEmK1xeQUTYf9uuB2K9Jk1
X-Gm-Gg: AYBFou1TxB5vVs/y1Cp8udk7J8MTCGmaM0OZyTBDRi2s2FQyRZ/toQD2d8vQk2pkDzT
	a+FfOmQleA1mFte4gPj3E+2kYrjXYfwSLDWLk/SJZAcZPtvyK+uTLAJ+AlQPi539jhaUmcsTxs+
	5pZWLHFYJfnPZX6SNNuiz4kQWUJc4wee8H16QEQ/rAEeWOY2X0rQyjm4CAtLu/QQT35aFIYEqrf
	VkCefwZudlqodrwg8iy/34ALPHb8IXxB0gD1p/KVXM9eJLySltk3rXFpOp7ZEnvkdu2lbaRq1/2
	ihnHr3jf4sW/RGTMT+rVa1XhiaVoOhOfem5yPiMrTbGYwuQfBxgepRdoCdMb8l7ZsGIrzXXxKWr
	/4ZabOGAxX+QyidAaLFzskfdALMAq8cnQo+RPfPFUsJ1sjPTxV0iXTyp0Vf563yUAi3yHSGvS+H
	orhFag0PSF+IojiKuj/fhxA1SvULnJZ4mWx0sQLDPqszE44gNUBwAXDjybf4TZHuUWWX1oCDClm
	uUOtxCV1GB/fddDrDuB0A++A0oIPkL54bP018YBvDkNey/UE2DXiusZ6qMS7QygGZCRTZMTL57K
	wF0008J/YqkXIpBSdg/LCQhM0WhttBvPXmUWS7PWA2xRCdmRxSBiZ9/Atl1An+wus5eWz3E3OMc
	IYnYOQuQiV3Vm
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
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
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Rspamd-Queue-Id: 9D12E40003
X-Rspamd-Server: rspam12
X-Stat-Signature: 71xwcorjfkc3yjsinouzc3w3wt9n1pk1
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794305679-767070
X-HE-Meta: U2FsdGVkX194CKC7mj3lzvPsR/xvzn9SBKIOQePa11iMQstwiKH0dKJogmjEJPHVTMiMDLiadhCtXYCkwPLUOP2P5sOOe94RJWw+4q9ONqd3hLEG8zw0iMD52IVC7vRVQ1Rxw5VeQGYrybvT+Dsb71E2NscPOOlaxBvjLiFIst8ck8o4eYnLPJ6HNtuNFCO0xuEl3A0wZvAD8oNo5hMH/2vKOvZcTHYwrn9asrxs5fOV27uisPo+BUGfpD2j9waN2nPuL1ANvN32COz8d0/X6Tda+kYvCKqVS9QNy/7sT7PyDgH8z7EuXqCSw3Y//5MQs/E7T7w6cg+mhcwNfZPtMDwHKhEUyWdn/dJnDdHT2Fu7TorqR1Z+tdXuwpdHnjbkTsYRI7nNp5ovGA10r2jUd6wKP8yMdiymOe8LgWhm4C8OwnR8oqYRtFK+OuzbxsIwg98Cjfy3+DUi97tczGDL1xYyBnpVvN9bhEQjXvv7aBwsmynbksqrg7yDzowmjthYIlaw99j6KlPln0JeXrN89WfDr9Ihrk+1dDOypAIkUv0bT2CbWEg3OJ3qqg58uaaa3EkXJ9+9reIxBiK3bTGCe9bfPFLrgWhnQWV8qBWEGw2VXh9mlSRGoB9y8LVQPS0bwjdxfdvXwBO0uvZ90oBzevVYf7qP97tYtRP+O0rDwmnbWbg816LZiO67DatKVMPysVBOiG8V1ehagS1UWs/NQu2rCk87hwySZT3g0kwHsXmrM11TjyIvn0au9YXh1UDjNwv8CCHgju5/2WzGwBznlnfDdOWinBlqajWKa4fAJnJF6lVJ0JbL6ycFV4F21R2M/ki1mLBO5HAjl4nZKrLZ3r1STFTJi8YyGHPwvx7V6OzFDhN3F7xBbWli7bv78bWVOE2EL4lgRc8BsYwOcQXGIG1nkbrUj6d5g9uvElUj1HNuA4vqL5Kd09VwHq+RTwjRFyoOvgMNSXFkAXWcE7U
 ltx4LdML
 m+UaBtpzSGYsowR6FZGfcR/4Flur3jCumoeaL756eMAnJ2aygwnGxP23YjMUKyr2WenRYbL2IPyaMMgl42HxC/1+bgxn5frj6qVl0/UCKpLTbrnj4EFZxCMf8HIr0ldHYQxG0K1aVZ3RaQwyoobs39/4neXkn/Pl+qOxZO/ZC0Afhds6a1ul3uv1VqeIjveRK/py6CEb0e3/xXgyLZkjMbdeBnDmbpXCwUNQSSNgukfZ7vix80lzKvppNOa29FZHRK89ahzcZzqhZQOKrH6BKliZL3oMZtFzuq2k/WE+L1/VnXZ3lQXENNOR9M1L9szQWU1lu3J/y0DR/4DbRUwR+GCkL/Qfa+7aNsDam8K2XiMMzWjN2RfHJzGodWz/RMWlZ+X4og16O7pPfQna8Xs3pNIrvd/DEm3Z9VZ0TeH9wVY13hNoXSt2Ftqt2oZQdRWkbLACb+6aAijG9MqEMKG993f8RXqY5G4RlXmdhb5WTd7mZD6kmN3fiKjuzb644S/+5PfuuQxakF61h5lPPck7uiNunJLdmAlTaQmlBo/g3w/bhI442ta2ZmZGXHgS0vQcdN/GBF0M1Aj8fSAsaLjxjCV0X1RRDxSxE4JVrSo4GhcoV3H3pX6YpVEXuoBrzKtXmqOznNNHcqKoNP+yRTyL5i/3OobvtUiNR6qOP+X18WjUU97jBVU+C28ZDcpR0wF8sSkoa5kE8D5nPodRoItww4jEKug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


