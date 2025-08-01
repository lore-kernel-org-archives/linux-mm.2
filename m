Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB8FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC066B008C; Fri,  1 Aug 2025 05:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75D46B0092; Fri,  1 Aug 2025 05:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D266B0093; Fri,  1 Aug 2025 05:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A26DF6B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:09:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44694C1382
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:09:20 +0000 (UTC)
X-FDA: 83727614880.02.06CB220
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD1CD10000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:09:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mcXugp8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GoN+ii0L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mcXugp8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GoN+ii0L;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754039358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nWfWjsRxa4zZXPCyYoVYdfMMPMyCon5WH9IIv4kj0w=;
	b=OxeXhlrvHGuN6m8xrJUSuRFErrm9OC/jjRMYXabXYrl4lAwDjcfCZ+RTSd9qW3Ne7BJZjd
	DXE2wcVrUrSBV7VsobvV3njreRYfaQDa8q+7xsXOM2oFG94N3GnE5zPIZL+45rO48vD1Ag
	KjitjcPALcgQWiplfzl4uDotH6UWF+o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mcXugp8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GoN+ii0L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mcXugp8Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GoN+ii0L;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754039358; a=rsa-sha256;
	cv=none;
	b=L3XOIRrH9T3PN/6YzMyXYBPGz7a+VU6tebXGSR4fLasnJX04N730hhLJ/yOueBbtrFFHfY
	WafrIzm6/VAKoS/1+r9GRE1VqzZlh2r4qN4FLf9lMrCywc9waSCEwY4VOkJofCamlWAwWM
	4pT+2VPXdEGzStiEm0e8O/s04/H1u+s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 585461F80E;
	Fri,  1 Aug 2025 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754039356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/nWfWjsRxa4zZXPCyYoVYdfMMPMyCon5WH9IIv4kj0w=;
	b=mcXugp8Q8keXtokLcOzWbt23XCBEIXNuByQw/W92gdUFVaZfgJpBh70Eoe7Z98ARcbzlV7
	RIASGKX55MQE1gZbgSRUsJb5A20ba8OJMtY9Aje18CdQXNg0mITM1Jdh+eKsmX03hROiq6
	sf5wvJDaUrPmcXFbWPaKGAaICAzgXVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754039356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/nWfWjsRxa4zZXPCyYoVYdfMMPMyCon5WH9IIv4kj0w=;
	b=GoN+ii0LAIUXDdF2VnCqC8K9Y4IoJE48bhgepE7XLdJNGSDThAg3LlncyE7T6K2Rh2x/RQ
	8hrzpjydIZWjeVCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754039356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/nWfWjsRxa4zZXPCyYoVYdfMMPMyCon5WH9IIv4kj0w=;
	b=mcXugp8Q8keXtokLcOzWbt23XCBEIXNuByQw/W92gdUFVaZfgJpBh70Eoe7Z98ARcbzlV7
	RIASGKX55MQE1gZbgSRUsJb5A20ba8OJMtY9Aje18CdQXNg0mITM1Jdh+eKsmX03hROiq6
	sf5wvJDaUrPmcXFbWPaKGAaICAzgXVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754039356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/nWfWjsRxa4zZXPCyYoVYdfMMPMyCon5WH9IIv4kj0w=;
	b=GoN+ii0LAIUXDdF2VnCqC8K9Y4IoJE48bhgepE7XLdJNGSDThAg3LlncyE7T6K2Rh2x/RQ
	8hrzpjydIZWjeVCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 359FC13876;
	Fri,  1 Aug 2025 09:09:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VQvHDDyEjGiMNAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 09:09:16 +0000
Message-ID: <a58759b9-2847-4ffc-914b-c96336385c81@suse.cz>
Date: Fri, 1 Aug 2025 11:09:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: change vma_start_read() to drop RCU lock on
 failure
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250731151919.212829-1-surenb@google.com>
 <20250731151919.212829-2-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250731151919.212829-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 47utnwy58a5xftp6d6xo6bhjabxzaf7o
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD1CD10000B
X-Rspam-User: 
X-HE-Tag: 1754039357-183325
X-HE-Meta: U2FsdGVkX18iQFveZqS2uB7QDkUFnLCk/I4z4zXuGecl7t/JwHRX3kRjOXpjcUFBoKrXaKq/8vHl/+V9GIiqpFjSMnTszFPhgH3SLvIc91zD45R9Aq2+oO1JFwqMH+hP4Mocj9wb60bfjJ0FO15dmPy69GiCxaBEcJLkLm5O8brn9VDwCo9AGq7/ztkDF+Cbh4j/2Bj9/GbuAQuJIcao1Uo1lDiGbE/VYF6CeRdazGG4sBYOOWC25N6mKXo+b6kWaiXTgHKEvvmg0Tm3vpxh+aJKvQzh4ANYH3KtwgAJI+RdO/lujZRnnUlq0axulq6F83TQB1wAxfVfIjwdlQtHJbG4duMlDK5o9bVFF24NOKKIs3aqMjVvY1C0bzF6xVk6EVntJ/eDZ9lkeVkkNYSmKUwnv7K9za7P8CA8juZBsi6pVDEa4bZObn+qVJ9DRFmotY2hUQX7lkHnRg8rD/9U8wYZVgUSwW7WZXCGj5jGM2DX8Uq4XlEktRLn3dlbhNhXgTnBORmfe3gNfIfxa/LR9yUQkwhnFEyO481/b19AP6tNxmmXoY1ZvxXHbAshgEfLYpiGtV1JzZQKb2AEzGuvNqyKzeYvYiqcsyUxlMw2y+GB4bU4WVMsa6H/ZfYbemZMFJYnMyl+jyr48xvsoywFwmiNBUhpINQYtv4V8ar6MFLgFAyQzIdQbGZHSroVeO+OaX33kmtS7KO3gP3ZZyCsTY4rriDbTztl5CBQK7GMN64y99gvajGQ3ITPumr5vOVxpODEvSObpP0YllWMwrWyf0aW4kiKpdvVqzDlbDCjuSYXXlAFGtUvahOox0W4zolHEYS5iZnL3uFR3N1zYPnNkZamv6xARIS2cPwc7pilSRBN4K9pg2pZPkscOtSKZR7tAtn3y1MEQ07NMZX2TvWnGE4iCrZe87+5Gjkthz/SD56qQWeKPi4OXUcEy6P3iP1Jg5FlTRYbzawiGc5aCq+
 sUEUiB3/
 VZMfeE8pSuYkLYRVjK9ACUG9wg6ktcL/Y7XDi8wRjXHAsc1TLK6X0QIs7lWxnx98IDK6XP0CUtrKWpQAPuEOhwLTA9NgjSxXiOZ0iCILsPXpPHm1A2gLrl9q3gLkEOm6DxkB5zNySy98Lh0ZmwzRBeqUfA1iWJ7dnbB19bx3rfA6N/NGLbGVgzUYkvckB8WszsEk7JPx3x7njsgcOmgeJHpbbuVvO3I6jnRpbw5SHZiJzv4q5pzUsYeKy1xfhP+eij7aMUV3lOgpRIs771QDxd7/8jgls0Gdr21In9K2beYTuNTCVDJmqA2qTvCp1szybQKGF86+PF/erPRQGVjOZWmuQwMv8IRy5pQFwh+YTyhuFGSOXigikAtGrAMnMTwR/rgpyOExoijGvlao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 17:19, Suren Baghdasaryan wrote:
> vma_start_read() can drop and reacquire RCU lock in certain failure
> cases. It's not apparent that the RCU session started by the caller of
> this function might be interrupted when vma_start_read() fails to lock
> the vma. This might become a source of subtle bugs and to prevent that
> we change the locking rules for vma_start_read() to drop RCU read lock
> upon failure. This way it's more obvious that RCU-protected objects are
> unsafe after vma locking fails.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>

IIRC you considered it yourself, I just convinced you to try :)

> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

I thought we didn't need the drop rcu lock for -EAGAIN, but that would just
made it more complex for little gain, so this looks good to me.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Nit:

> @@ -223,11 +227,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	MA_STATE(mas, &mm->mm_mt, address, address);
>  	struct vm_area_struct *vma;
>  
> -	rcu_read_lock();
>  retry:
> +	rcu_read_lock();
>  	vma = mas_walk(&mas);
> -	if (!vma)
> +	if (!vma) {
> +		rcu_read_unlock();
>  		goto inval;
> +	}
>  
>  	vma = vma_start_read(mm, vma);
>  	if (IS_ERR_OR_NULL(vma)) {
> @@ -241,6 +247,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  		/* Failed to lock the VMA */
>  		goto inval;
>  	}
> +
> +	rcu_read_unlock();

Would it make sense to put this under the comment below?

> +
>  	/*
>  	 * At this point, we have a stable reference to a VMA: The VMA is
>  	 * locked and we know it hasn't already been isolated.

Give it continues like this:

         * From here on, we can access the VMA without worrying about which

         * fields are accessible for RCU readers.

> @@ -249,16 +258,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	 */
>  
>  	/* Check if the vma we locked is the right one. */
> -	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
> -		goto inval_end_read;
> +	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
> +		vma_end_read(vma);
> +		goto inval;
> +	}
>  
> -	rcu_read_unlock();
>  	return vma;
>  
> -inval_end_read:
> -	vma_end_read(vma);
>  inval:
> -	rcu_read_unlock();
>  	count_vm_vma_lock_event(VMA_LOCK_ABORT);
>  	return NULL;
>  }

