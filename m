Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99360CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC04C6B0005; Mon, 25 May 2026 12:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96F06B0088; Mon, 25 May 2026 12:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACF66B008A; Mon, 25 May 2026 12:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC0486B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:11:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 910511607E8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:11:26 +0000 (UTC)
X-FDA: 84806432172.10.36A71C4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6185E1C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:11:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ayzj3SuW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybhCdnVg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ayzj3SuW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybhCdnVg;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xgxRxiNUE5HU3devEoTx0VBvfHiB2nKkiOSuA+w4as=;
	b=7LtRYYn1jgkjJeLN1TQBXdFv8pF9f/VHjZqt2FKnHh46EB6aaHRJvp065QMUrZreGXLOvg
	RzIFPEyg91tiHYBgokXKI1VQy+IpZ068E8IxQfrIchnxvrXRa6dKlHAE9l9ivW91MpJsmn
	nT80AGEB6TA9qyFTF/F0mfqe/hbJ6g8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ayzj3SuW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybhCdnVg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ayzj3SuW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybhCdnVg;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725484; a=rsa-sha256;
	cv=none;
	b=bmbK8hF560O60AZY6d69OEGkeFUH7ghyNV1YwYjrARBGslDhzL25l+mc7hBwP5QKlphqa2
	Fqv/HLeU5VY1nWqGLyUQw7ks+yn937G0nfLSBbsHW3NY2SBQ2SsOf7CqRq1Xjk7wAWnNSO
	2wKwwhifQKwl82+2kICuTt2A4SOqcmY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2E946ACCF;
	Mon, 25 May 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xgxRxiNUE5HU3devEoTx0VBvfHiB2nKkiOSuA+w4as=;
	b=ayzj3SuW52JzShVb2ROdtIG77ZdXnfvhnX42TgopSeq4xMSLtbN4yUekMMiGqi881CZWbi
	q2eiQevwCSeUVdySddJX2OScFR20uy/5Lhyq9DcFbOTFad0TgFrPrtVvNBEHAHWxFqqX9t
	YOwKp6KauNDumYmtzlQLt9RGLmS5t8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xgxRxiNUE5HU3devEoTx0VBvfHiB2nKkiOSuA+w4as=;
	b=ybhCdnVgVvfZWZ9Oo/GQyCY3fcO2TqFHEA4ZwghQ+1OSufjLnFSQo+nI8a9cfUeFPKeCWK
	LTm7dS5TDFNRFfAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xgxRxiNUE5HU3devEoTx0VBvfHiB2nKkiOSuA+w4as=;
	b=ayzj3SuW52JzShVb2ROdtIG77ZdXnfvhnX42TgopSeq4xMSLtbN4yUekMMiGqi881CZWbi
	q2eiQevwCSeUVdySddJX2OScFR20uy/5Lhyq9DcFbOTFad0TgFrPrtVvNBEHAHWxFqqX9t
	YOwKp6KauNDumYmtzlQLt9RGLmS5t8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725483;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6xgxRxiNUE5HU3devEoTx0VBvfHiB2nKkiOSuA+w4as=;
	b=ybhCdnVgVvfZWZ9Oo/GQyCY3fcO2TqFHEA4ZwghQ+1OSufjLnFSQo+nI8a9cfUeFPKeCWK
	LTm7dS5TDFNRFfAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8BAC59D1E;
	Mon, 25 May 2026 16:11:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id taj1MKp0FGrJGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:11:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EB747A08D7; Mon, 25 May 2026 18:11:21 +0200 (CEST)
Date: Mon, 25 May 2026 18:11:21 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/17] proc: replace __get_free_page() with kmalloc()
Message-ID: <hf7onlvom5jb4pmec2mlsjm4snzt34ghakzks44e2nixeg2d43@whbf3sswolhm>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-2-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-2-275e36a83f0e@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6185E1C0007
X-Stat-Signature: 4wnxjemjtjugt6gu1q4j3qeh7hqy1exe
X-HE-Tag: 1779725484-777582
X-HE-Meta: U2FsdGVkX19BP6Fv3diR23vNhq8Ioul5wlB8n4fGq7dk6Hj0RocJVrQJXv8u4zcxpyaYuTpVv119eMK/VYfV9hdAFbbfdRykOAh+qrnwc9aEov3fEXu31pLAFeyX37uC86UaLe01PWRaLKiEpqz6JAFDpS8vfHzT6P5CcS3bXMU4M4r5atlGTdf2YJ1MwKFoUqZJAQBPvZeAIk3bsLkLLIfM8kFUlBEFje/h90CWR5b05PIIr61ykwLhjf8zjGS2fZcbWg9gnoyua1UEJCkIlPHAzXjCOfOPmhRETe/+YFSyVD3Dx5n08RPeHfVley1joMn+8hHG1LtZ9CvCVeohpiS/L0UjOr/PVkzodq2qUZS3a4mlFoGZ3mdqNj1ZIHSSmACL1e2eSW1JEt5zi2DadTlcYIom5QvOJtPwuqkn8UZxrarIf7YSzsYpZff75VVe7sCBSJHd0oNujPGCQQfhPMh5rNzY2D1JvqryCPEdUOa8ST9+ZwwSIUwFUOKcyljDeuHvt9EgtjnCmBceET94hLPFbfNmHp/9yCWEvOfcoxuOg+gn4RwM1EI4f/H/xhL2rGwaJpt1BGXSE+k5rMc70DQo6yqqaCmG6FnS8iJeyfKTrojsE+ulEFy/Sf5b/DsfF4qqMWmM4/1+NBbErnhyvxOz4us9tOiJ/yErobCJ+JxNuCDmefLgVdJPNXcZAebtxeji2AW7u3am/AvKfVG5Pe1dj0u37DY7g8FPCo0sBZYOieDoxw9/EoNR3Q4KirCFSQ40yoXKVyr4DCVmhqT3ZsaUhSbnXA+YnwVSKusEKS7IEF8zKfyABNghdrOLjv0luel+xraIH3loQ2uRbpVjqsmq4OO0sYw1Rd3JAk7nZMLcgykjMqs1Qfd/FrsU6g54YUTflCF3YgVQGFTFZytjOIq0eB3h9LKVpy7mqfY/PYFvtAu20qA10+taUF4RgdzZ8GkqkAzjB3/szqVhdDY
 AA8kzDop
 pcHeEFigkhemMeDMuJZCIgFJEopsiQF1zJjsnhoTJnIJ6vkNKnsvqZYKCqSqM7xeok5F9sMFc1Xq1jou7dAAek+ULkfETQQXfPfnKoeev8NsKuF4vUup3fTyemgYeZVReYwG066SOfEJzbuP7FW5ageSC44lyYGpwuPyNi51MKjFExY4o2i89x/GkfZjLopKQlr6xQeVki20JB1nBjZn4WfWkI0p/sxiug/uouM3Eejuf6ElEqQAOQaoTikr8r3kdk19o9y5fthkafRAJh77ia1i61naR6+ltMz/+tvZkUfu5uS5a1ufU+yXIH1QJdZD52kyNGH2fCVrPrgrnX22iq/lOcCV+1sLZ/UO7zIDoibDk1tXmsKra/t0Ib/QtUcOlpXYiZhbrPQMmRL2X+ZlqZkIRZq0ZNZ2Koen25c6YANylNs+kB38Kz45p9TlcVtrGxDldfRzv875OV0IblzoW6TFz8aysRMfuwcGdBLU+V7Tpgx/0PTasHNEqXacBTcUsr69vR1vO/E1fTus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:14, Mike Rapoport (Microsoft) wrote:
> A few functions in fs/proc/base.c use __get_free_page() to allocate a
> temporary buffer.
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/base.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index d9acfa89c894..e129dc509b79 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -261,7 +261,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
>  	if (pos >= PAGE_SIZE)
>  		return 0;
>  
> -	page = (char *)__get_free_page(GFP_KERNEL);
> +	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -284,7 +284,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
>  			ret = len;
>  		}
>  	}
> -	free_page((unsigned long)page);
> +	kfree(page);
>  	return ret;
>  }
>  
> @@ -347,7 +347,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
>  	if (count > arg_end - pos)
>  		count = arg_end - pos;
>  
> -	page = (char *)__get_free_page(GFP_KERNEL);
> +	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -371,7 +371,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
>  		count -= got;
>  	}
>  
> -	free_page((unsigned long)page);
> +	kfree(page);
>  	return len;
>  }
>  
> @@ -908,7 +908,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
>  	if (!mm)
>  		return 0;
>  
> -	page = (char *)__get_free_page(GFP_KERNEL);
> +	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -949,7 +949,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
>  
>  	mmput(mm);
>  free:
> -	free_page((unsigned long) page);
> +	kfree(page);
>  	return copied;
>  }
>  
> @@ -1016,7 +1016,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
>  	if (!mm || !mm->env_end)
>  		return 0;
>  
> -	page = (char *)__get_free_page(GFP_KERNEL);
> +	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -1062,7 +1062,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
>  	mmput(mm);
>  
>  free:
> -	free_page((unsigned long) page);
> +	kfree(page);
>  	return ret;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

