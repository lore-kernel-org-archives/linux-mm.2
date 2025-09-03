Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7538FCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955168E0003; Wed,  3 Sep 2025 08:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CEE8E0001; Wed,  3 Sep 2025 08:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A168E0003; Wed,  3 Sep 2025 08:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72BED8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:27:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FB7B1DDB8F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:27:51 +0000 (UTC)
X-FDA: 83847865542.19.25D07DE
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2EA1A18000F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:27:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X6EfIC5w;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756902469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ow89xrjnsbNKNS24LObxWfvrCfFy+ufBe9CUqvS3aF4=;
	b=YCti1IpL+Nj9sQMTIPMnyzYK0v5nHR1jQddyXmEZic/+AL3yBHFq1kPWZjComu4gpQQFwY
	gl0fMVYy5cpuqr6h3F4yYGPHRq8JtreUf1PX9PRTG3FcHpOcILHussbvV2SaWHO/3uW2Hy
	2FRGqDkqzP3Lh2sF8h4PThBJBljCzi4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=X6EfIC5w;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756902469; a=rsa-sha256;
	cv=none;
	b=TWlIkjnrGvBcQI0oSpP+hqXJ2Vlc+Dm1v+tvatz+8hjTuIS3Pr6W3pTPEm1j+7lOSSePvk
	PI2oFe9PF3qBb8Lv+lXQb8QDdqXuGOsKrQZ5e50YLYIfUsUNLdfKCUB9wBeNhES7T0PibW
	/Bc4mziO5M0hFczFV5W8tQehodukB8g=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso4137504f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756902467; x=1757507267; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ow89xrjnsbNKNS24LObxWfvrCfFy+ufBe9CUqvS3aF4=;
        b=X6EfIC5w3saJ/uxQD+XYXLGbx7OKdSVecqROalUroA6uIEff6Gguy84RQ/PKhKAg5f
         1dxfU6DXscwAWMapnuwXswFYrkirkZI/lCIhKqNsEH9cHONh8PwZTbOD4+kZaz+9ZnsE
         ZuZfP1S6K010HW3a7DyIj36Tp4yFWbcQU0pshGAnyLY+wxjuI52rRDI8fQD2wOG17FW5
         liahxSm8N1NWoPgh6NvtQUNt4iFsKRAM0I0Pv6XulkUYCwv45O3f7XctfUtsTyoC7rI3
         PKZsfy8Gk9gnNaoGTT733YcEGHUDl5kxQFsJbx934VEfcfCwk05E+CjIhgZP04GciyfK
         ZrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756902467; x=1757507267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ow89xrjnsbNKNS24LObxWfvrCfFy+ufBe9CUqvS3aF4=;
        b=u2r3O4I5E/ewFaTjtDdgjSUF34y8cmnOmjnP8+rD6W+xWUNER/B7VqQMnGX3U62kZ7
         8QXvP0pMwj+UuFvwl9g6tZQk7gGQctxsKNt6+sQVNiOX8w2iqt5bZuyLy0S2TsEvnS4T
         u17tO/Ia2M6xQunSN3mxr2Nwzj+SbHFYo5TXr/IReaiVEjW4L3IFJgQwVgWrZhqR7G4e
         1HJbfCKnnsxbfcCAibngLTz24383PvLWSBs+YIpD67VfUzBOEygp4C/zKoyhaIvK5mAl
         wzQ0CvpEgrIKeeXc3R2EBrP4Y0jopCu2XSB0qoryUrBz6UAh+DbW6PUkrPJKiywDEe8G
         XEHw==
X-Forwarded-Encrypted: i=1; AJvYcCU8g+903jC2G/JngmB+NaEcs+x5rdlR9xbJ2qULB0u4dF5HZDdZF/UyTCS35pZL8AZFWaE+UkxOFg==@kvack.org
X-Gm-Message-State: AOJu0Yxx1/ZF8s7/3s7h12CQ3c/usxeNHuR1BGYICydA+xcYUvNh9uFC
	fV9QC84WCzJob9duRPv8OHVq6gbwBchInutDcfVEHmqEh9N+UuEkZe8QP/it4DLXG/Q=
X-Gm-Gg: ASbGncuh1SsRWyoIskal1hScTnoO+Pla94BH7yjLHSVp0abz2BDDJoEm3q5OA88w0Kz
	ea18hQHDi6sEpwe2JeofuzxChWiV7KVe3EYVhGhwimh5vXt9937ppQ06dCr4HKuabmVWYhTjpL8
	1bC/HG4NFtgQLAKuaKTsTytQEzCqUMEzc9OUi2GIfDfwv69KTKVt2RKHNJljk+AWp6BKYjs2DHY
	Yl7JbAjGHc3VgHdlLK32cWarU86Faxc75hdI9u7WNMlqxiB/q4BQjrZJH/7rIWAqwvKoPioq3n6
	CA/dXiENRpIHf3bk5ezj5VlJlc4Wro2zXFF29cX/DKsTPgf4jXHTR59YkAxNdOk3vwwC0aKFxgH
	IycUtHB92VcDfRANqmsumKo4Bn23w1GAmUDMvtFC8E+QLXQ==
X-Google-Smtp-Source: AGHT+IHU4yMyqQulSlJlrYj9+G4ULF7MakFGi0tAtaV3rKdWzPVcIYjLJfUJpv+mJdgP3MWvAdEV0Q==
X-Received: by 2002:a05:6000:1788:b0:3df:c5e3:55f4 with SMTP id ffacd0b85a97d-3dfc5e35d8cmr342968f8f.6.1756902467402;
        Wed, 03 Sep 2025 05:27:47 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45c6faad9cfsm44331935e9.0.2025.09.03.05.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 05:27:46 -0700 (PDT)
Date: Wed, 3 Sep 2025 14:27:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [PATCH v7 1/2] mm/oom_kill: Thaw victim on a per-process basis
 instead of per-thread
Message-ID: <aLg0QZQ5kXNJgDMF@tiehlicka>
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903092729.10611-2-zhongjinji@honor.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2EA1A18000F
X-Stat-Signature: 9bhurdzgk6ftackxyd8hjyzaudkg9ezz
X-Rspam-User: 
X-HE-Tag: 1756902468-702467
X-HE-Meta: U2FsdGVkX1+LfSttFn7N5jN/MZEFQTVwI1gDhWPqj6G4aaJcF49g5/ajv7I00xCMy22An+onYjtmZ3LROfCRjKVl8w3lO67LRY90iZYSTOhyNm1SzF0sGAoFPHASncDhHxSJbaOCu4lWGx3RB1q3uT9qHc2WypfHBTOnhu54QVofVvGAOC+yhqzLcyz0gC2EWEkOrUV8H47nHDHH+RX2NyG3GD6ralWmiYvc6QUeBoLER5xradGaGt3SocjszERWLMz5mLe9RQV9brf3HdYBhJ5Ft7vtNR60BdcCAFc9ZlKH2Rb9UdOYFEqBW4Dvw6Up77Jw9z3WzIUamVvIeMmvlHBelox/eplO7BDgu1YunqHxRIQP/WoXhhOoJvZyouHxXXlEHpyU2QfHPS8r3TkfB+d2UAZQYDBYqsuA9Lq0qa7p/TWoCM+48jdVWHO6DN+6X3/As1Dh6Sft0ZkCmbdIKjowGQ2HScgyKjuEIKJlSjUlar1vvgdXn7MYjmncoWzLf4tPlQX4PQDaNw3s6eiwx8PZE5COvyWdyORJG3zG6w0mmxWZ65OahoStMP3HxnGcDeFVDSwHUWeHonlRmK+nftIU7vffJE0LW27AtZMkG8c1F0ibv9EOxoqhjmzSIJvj8hd46bqtL/gOidXIpcXcNdtKrvJ2SkmHNKDdCSoDdHIvlfvEuVEuWQgIWSDASios+83AfpLikzPDq0Liigp9J6iHD9jb43KDbL9r2G06qCVqwdtFGbAAoVUOV5I5dDbhOLpJMN9Sf1vdB8cyVsQrEhCfXl/vQo4PSZS1D5k3s2LZxHBIkx/XiP55kCI1YxAJuMTyapSlP83A7qCJ3Tl6aahlBUYq1tWhURqVDvM45MyT1Yo+2dt8oROYiv6LXzzIN5JmPadz57y16SkPu2XaDxjorUTfLmrLHEnLslmm/TqG9mkZrOIyzYRTfzPSCcHQslErKVhUYwcZyX6H6lC
 aYS2dzPj
 p0TZbdYozmPqnwwofgRHjzo48RTv8rgBdJGLYfG0VGgd3U5C06FNoroskpRMFfjXj8vA1ZHi4Tl9zqDR4nPdh4Y9eAd+8D2sxjTzJ7g/Q/+1BAx2jBLvYaye9+TOOnEswOdUPH2zPhK344sR2kFZnwg2SLp3nY+lVnko5UupQUJv/0oLvOecVIDiN4H8z3aC7TDrWdKoHH4cY+U292PREnNT1kswtvB0aVWzT4/3vp1xlGZqGpUAglpwzXGL2DmM9vYX9/YmdJUINSW+MUdr0NIgqIvdR5yALPKUwxVsN5DkRKhZyW3xns7D7Gj7/dQelROG4MYBCsiUzrt/SCz7vncfdXQUvM3sNpBhnqwJguuJagiPTIjO7P2fHRijSlPrYO6aj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-09-25 17:27:28, zhongjinji wrote:
> OOM killer is a mechanism that selects and kills processes when the system
> runs out of memory to reclaim resources and keep the system stable.
> However, the oom victim cannot terminate on its own when it is frozen,
> because __thaw_task() only thaws one thread of the victim, while
> the other threads remain in the frozen state.
> 
> This change will thaw the entire victim process when OOM occurs,
> ensuring that the oom victim can terminate on its own.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> ---
>  mm/oom_kill.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..3caaafc896d4 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -747,6 +747,19 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
>  }
>  #endif /* CONFIG_MMU */
>  
> +static void thaw_oom_process(struct task_struct *tsk)
> +{
> +	struct task_struct *t;
> +
> +	/* protects against  __exit_signal() */
> +	read_lock(&tasklist_lock);
> +	for_each_thread(tsk, t) {
> +		set_tsk_thread_flag(t, TIF_MEMDIE);
> +		__thaw_task(t);
> +	}
> +	read_unlock(&tasklist_lock);
> +}
> +

Sorry, I was probably not clear enough. I meant thaw_process should live
in the freezer proper kernel/freezer.c and oom should be just user.
Please make sure that freezer maintainers are involved and approve the
change.

-- 
Michal Hocko
SUSE Labs

