Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F35606A882
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTFSmfz6
Received: by kanga.kvack.org (Postfix)
	id 398516B05B0; Sun, 15 Nov 2026 16:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F516B05BA; Sun, 15 Nov 2026 16:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285ED6B05BB; Sun, 15 Nov 2026 16:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1686B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:00:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37C99120827
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:58 +0000 (UTC)
X-FDA: 85438572996.02.97C55A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 87C1FC0009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTFSmfz6;
	spf=pass (imf28.hostedemail.com: domain of wufan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=wufan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEm6igHXIFAAgEEuRJ/bqCUFcve2TkljyAexsixdkJo=;
	b=VhnzU5cZPIghqyVIIcfrLn400O/b4gtfrVR78rLvl0nY8Oyca8DFaywoDtdORH06qgKnsX
	LcG5kpHt0V6cjLXVkWh9yCps5fhYHlqXHo7Qxy3rsGNhWJkAFYEJ1Ti1p35CZj7pNuRY0Y
	qU//xRzXHv3G4pyNxEDM3CbRWV55ZnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776456;
	b=oKVontiVOBsS3m34TURNgOX8dbb/vMQIU6f9L2ks5hAwEYZfJWw1nkvST/SqpuW162qon/
	IYTsoI8usOa9Ha6BrgaERtxHUM6wOqtzM1zaaPS4O/DOk8Sk1YWbdYHH9WQcyij0wF5c98
	ag2Ukm6n0o7cmiC5So9M8Lowsyi7dJI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTFSmfz6;
	spf=pass (imf28.hostedemail.com: domain of wufan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=wufan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 233EB60F01;
	Sun, 15 Nov 2026 21:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B61F000C8;
	Sun, 15 Nov 2026 21:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776455;
	bh=lEm6igHXIFAAgEEuRJ/bqCUFcve2TkljyAexsixdkJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fTFSmfz62R/xzgkMpYRbTZzSO1fAaOTf4jflJ+BI1Scxj9kPgQQRUJh5ePp5hBeOu
	 +Bd9/jFgUX/Vr3SrSaL7NiWng2cleM7I5eVUET0CxCOxtD3z3JtobCtoEK1uZsrk9O
	 iAGU9e2NNbHTnHUUm1WhpTgrGJI9DxfNtXj3ZbOqcBeV+X0YOubFg16rMVAG4n816S
	 meAMgeXKPUTzQXxkWxbQZTL7zIU7+61yO8ddDum1vZdciy3700YyDsvoCC6X0U8Z75
	 isgWalRVkoXJWNKjU4wQOTcFTO3/feMNx7FHCW3f8rR417/NwmEPrn+s1XJbm2eRIP
	 zaZrd+FRk8kcA==
Message-ID: <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>
Date: Sun, 15 Nov 2026 13:00:55 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
To: Christian Brauner <brauner@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Content-Language: en-US
From: Fan Wu <wufan@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ia38bp46wc7kehh1b4jtmumi6cdq1b89
X-Rspamd-Queue-Id: 87C1FC0009
X-Rspam-User: 
X-HE-Tag: 1794776456-239737
X-HE-Meta: U2FsdGVkX1/YWiMFl/YY7ljSoXoSWFFr+ItOF6g1xlVdGY6UXGU+685a92aaJCh0UoXM+Kt5OqA6FF+ki7fILCfBtLITC9Zo+8t2A/hs+nugKbH1MADq15/rLLM9Yi1GfwyzqwDN7K4kBVYVf3m7a5odK9vaSmIAuuMTsk9zYL8sYbbG1LfrnHvkgKgTfxb7T+SfTr/muytYgCfcSJrucYFyhkIr250OUinNscRP6EXNSLwRQlyaB1ENk74wvQg7vp3ezrwxHyviAZbcqbCrxc/CBkrycQBvmbG9Rv5vlEu3O8TaSUDsV2cNtaWfHxLOup37BZy3LECeO4SJf4Zod/01r6Q0K5gw6yCui8P/+dNL04zmT7IAN3Jh6SllCv4oqTAIGG/M9i0TpUgd6f/42u7WPxibRBOpHXJaoDhVuvfPkB+l0xSm6i1AdLMogdcozguxSox3pdv+40IaxTMMGRoYmB/pxLGo+okcrjkoQtfP+VIaETS4USJos6lyvXVnQdt/4HiNTz1T7jJrmYPipXCfkGtr3oBcQa7MBNtdyfuIyMQL1x1NI32Xi65+qXyCKYUzG25bs2K9+nB7ZN9lihyPdq+h9GtnUcvWE2hbFLde8Sv/yXpEJF64p1aAqK9RHYYKTmvjS9GPyzFo0J6RUSeZoLUGc8g0C56aJg13r5VfyZaa5vx1AloAAg1d1Xc2y7nV13amQFXud0gj0xzy1Ckvg60YOielewbHl1T792rRARU/A1wezIzbcZa3GuZe9Ahp2kSl5VUyKPLOeMBNkep74+F7n2atZBpg10sFPVsfwYCPz97Q6LS5MXuFm/97/lhBO31JhLRocpxADo02iANEKh4r5L9/r/D/P/PKLj4yGzRAcZ7eMkvY7U4bpojEOLFWjzeZvCVkA/DgMQApY3Im9CLd8Vd34dKVf2aIZBRCzSiwbRPIRZ6lzpodl43hRty650EsoaXAeIVd0XY
 7FWLXaOm
 +qz0HhQa89ZsbZZsFsqoshTDN6SItTJXkwAkrsEiOfCzWebaG/hDW9kUfa2EFQPkPGvhJBXYUqlEx/3Y0rUH+MAtGSZd7nU7AltealVpPs1GiSS8GXjbRTb57P1813GzGz0IM55jnLukzyOLXzjVFEEZJJxXczMIor+R128N6HUNN5R37yiB+NN3VqsVc0vYkMjrzXWCaftznYDpVKqOhaTxGwLvbi3JNkOzyDpUHor4EaqODi6rhfS76mTBpEpDBdka1PMAc+jdpgOETdn9LwnbkgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/2026 6:01 AM, Christian Brauner wrote:

...

> 
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 4a7be96c84f03..3751963509df4 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
>  
>  	if (file) {
>  		build_ipe_sb_ctx(ctx, file);
> -		ino = d_real_inode(file->f_path.dentry);
> +		ino = d_real_data_inode(file->f_path.dentry);
> +		if (IS_ERR(ino)) {
> +			ctx->file_err = PTR_ERR(ino);
> +			return;
> +		}
>  		build_ipe_bdev_ctx(ctx, ino);
>  		build_ipe_inode_ctx(ctx, ino);


I think we only need to change this part like:

	/*
	 * If the real data inode cannot be resolved, leave the bdev
	 * and inode fields unset so the file is evaluated without
	 * dm-verity/fs-verity state.
	 */
	ino = d_real_data_inode(file->f_path.dentry);
	if (!IS_ERR(ino)) {
		build_ipe_bdev_ctx(ctx, ino);
		build_ipe_inode_ctx(ctx, ino);
	}


This also avoids the missing audit issue noted by the bpf bot, and we
don't need to add file_err to struct ipe_eval_ctx.

With the above change, feel free to add:

Acked-by: Fan Wu <wufan@kernel.org>

Fan

>  	}
> @@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>  		return 0;
>  	}
>  
> +	/*
> +	 * Without the inode hosting the data none of the properties of the
> +	 * file can be evaluated. Refuse it unless IPE is permissive.
> +	 */
> +	if (ctx->file_err) {
> +		rcu_read_unlock();
> +		return READ_ONCE(enforce) ? -EACCES : 0;
> +	}
> +
>  	if (ctx->op == IPE_OP_INVALID) {
>  		if (pol->parsed->global_default_action == IPE_ACTION_INVALID) {
>  			WARN(1, "no default rule set for unknown op, ALLOW it");
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index b26d1147d0708..58ca50987b2b5 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -42,6 +42,7 @@ struct ipe_eval_ctx {
>  	enum ipe_hook_type hook;
>  
>  	const struct file *file;
> +	int file_err;
>  	bool initramfs;
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
>  	const struct ipe_bdev *ipe_bdev;
> 


