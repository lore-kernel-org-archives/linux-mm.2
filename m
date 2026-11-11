Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA168606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FSczxfpD
Received: by kanga.kvack.org (Postfix)
	id C01176B05B1; Wed, 11 Nov 2026 11:47:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7F76B05B2; Wed, 11 Nov 2026 11:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE6D6B05B3; Wed, 11 Nov 2026 11:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 848C86B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:47:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E6E916026C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:47:46 +0000 (UTC)
X-FDA: 85423419732.12.999BD03
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 48F632000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:47:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FSczxfpD;
	spf=pass (imf13.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794415664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
	b=PLPAp+cFYCY8mwktbMXequ7aZsfK19dTejyiC79X3SHtK1ZqeqcUFPe83e6wvQK99gAeej
	tEJaapRPsIBJ/TFT5HCqk9sA6C3DKQpL5C/EpRhc8z4tuhk5tTRQp5+zt4F1m2upIDqPDI
	suprGO6zgqA/q30kUpFBfsLFm17r4Ew=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FSczxfpD;
	spf=pass (imf13.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794415664;
	b=Ofp/sT1Yc3oG/RmJHW2uJdj6SN54lwZxb6HlIuEhiqjO90w4NsNnmS0TV00DsVLeYMgnx2
	87OiA6HKLw5q3+Nm4ytdfwH3O3EKLya75S2V9kq+hJoFZblb83vYGDk/hpbRdmQP8hM16C
	d3HLkOZ3NKIOcPEEpU8THb8dp34e2+Q=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so252055e9.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794415663; x=1795020463; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
        b=FSczxfpD9w8CxT2/DvHlIqaxluYExEx/ka+5yILkSsqjXs71Oi+7Ks0K7k3Y5Ju4Bc
         XO2MKU4KpLLiV53ufnYFvlwzM1mYDmxz7TeDu7PH/hPaN0aW/sOZQOHZOn/D+FrNo+xD
         oP0h6zUF+C3BKL+niMP2KBOrkBf7fUe3cTGkQwl2CQPozwzUbJez2H3z+aBxx1rK5SWq
         nAQz8R0nt+h28bTvvvYPLRKYdOx4nlqoimo9AuroK5KipwtQOMZ6jCmcRAi2Z+PYWhqa
         BJaP3UZXwHB62C0Qte+axFX0t6pa8BCo/5QbQjuy+4qRELg2nw45bzLVIj3IJqpsexsl
         3/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415663; x=1795020463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
        b=D52oWYLdmFUNsdIfU2KIQysBI0d/uVnoQSE60NlGcqMLbgF7MylBW0y2N3AdFC4rCE
         LsfqTIWuB8/3gpFt0IkPx6Ooj9rgwAe4brLj0BDRr3q78iZqIfQmH/90nFG6q7o7tS1E
         8dPUDhI7hVBFLCYaAoooQNWvh0pDy2Kjq+wPbNmI6cmQQwmxxpPNB7m/o55LTwY53OYu
         OsO+o8Sgo89RqiN+sD3vVl6UaJD79gOSpyAcxHbRQ6csXN9qSeSHJhixuijwGOrl1gGE
         igWesEUPATHyynSaih/kXLWBwyR5s0S9gTmW0zXkxEzJ+uOBw8Yi8wKCzBsM6pbTi5LS
         IVwg==
X-Forwarded-Encrypted: i=1; AL+hErGy1b29wWCvIslzQJGsyxpHEZ2nbXXejxogn+9omF/UOiwUX/0OyR8XqJGBhcvOx27h1+mfCMmtyw==@kvack.org
X-Gm-Message-State: APuU4Z/g6fGzTBTzvBsTq+vFDeGLXCG2ZH9DDUYjh5JfVnqN0+TO2kWJ
	jnmR0+1MaMn37cfJq6HI3tWkVuaIYtC/bx1B317gRzgrAr6cQ1ub3rVn6LFM+vULsQ==
X-Gm-Gg: AYBFou2Qhu8HCNZbUx8sCDNyyt3MnG4w3vKPqC2BPf/Ew7zxuv+UPcGSzR92n/bWsib
	WRrXDehpTEQCKrjyhr7UYKa4Zi6AlQgFE05N72zXk//d/K3zyd9lDJWwag3GyTB0ubr5l3ggkMT
	HmhsdnFBsFC7pdSW1DitQd/p1FwANVy/zZw3ilXR65uEifwLDsfNs3gNCMMUb3rYERlGNXaqo7R
	idMd3Rpwc891g9T948CQbXzEDdknyRGvXCZ4OF/eZUugLPHz77NdwZrJIs2P66uLoTRBwpj+MAZ
	JMZ1sOg1sHrVsoAaRzFz9DQX4wRJ61VvyHPhmPJfJjKZpYWFah3Pjl78KS9R7SMyT7B8rJyijpP
	qNMxjpIDbY5VZrFByFd0FLZhn4RerAklZMHwhSnVGubyOxpE8mWLjQOxD4u6Ni4gDTnrmBYXeoF
	tFNF6dMqsg1NYLtF4v1dBCYfFTpUcFcQrGTzlkAza01EmKmebYjQdK19oabZyz6l4dulk57M18L
	zSHMFq/s0a/QiDPiosjmsK+yRZc9C5aXvD27d0HqbN+kYeS4SH4dXUvmpNbRrGrvohZ39xvf6V+
	IUGZ16FFXDxWV6wo3hZCxmp0TWhNPNxN/nEQ6nwBGo/gXMym/BfbQvY/l5rayOtWew==
X-Received: by 2002:a05:600c:3f07:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4bb4e27994emr1100895e9.6.1794415662004;
        Wed, 11 Nov 2026 08:47:42 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cd06fsm11724877f8f.40.2026.11.11.08.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 08:47:41 -0800 (PST)
Date: Wed, 11 Nov 2026 16:47:38 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, mhiramat@kernel.org, jgg@ziepe.ca,
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
	will@kernel.org, linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com, robin.murphy@arm.com,
	mason@kernel.org, aesteve@redhat.com, tjmercier@google.com,
	harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
Message-ID: <avScKhR22kFOQ1z4@google.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106131829.3228926-5-cui.tao@linux.dev>
X-Stat-Signature: 5jcdqnt4psh37c7e1g8npy7ph69bunuj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 48F632000B
X-HE-Tag: 1794415664-487073
X-HE-Meta: U2FsdGVkX19Zr7MqrpZQpAnpi8rqfYZCKPa6425DCR0aQaNLIj40gWO+27k16Tcaozk5Xyny/px4rO8wFRtFR5S6cWtyJFrJctDsn2P90NV8mbsdG4TVh9NrKDRJdRBwbadPcYA4wWXieZ/mLEQP/3Rrgf/PW678x2GM5L7LmNq92ugaOTMs9DvA/K9+Flumk9f/ZCbybux7fF/lJbafyEZRZp+vsrBzVULbg41+MrvQDWvtCf/MyzaIFyG04xmit3RaD2LI3qmsHhiWLV7Sb5a6IDIL00TxvmLhJTZj8+1jQ4whSrlRkI5NsQENnlsA1VpsGQQ7mZO8nJFV+gxG7qZOBvy7WqZ4yqBUycKy5YbebcBpsqSKzOByILyH9KdF0VBHI3zP01rZS90BN11mb/E1AbdyXyvwu953UW8bOvBxNdcuavQ1sfZBU6PMb/5Cp5++38aBg5O+EBWB99X0txU2UIgpM9799XQdkik0wxNUl8/l306kpVh9ahfPYAC3WMLCGUPJr4NCbTbsCMCbV/MK7deIVn3iX5oAkUoSArxxpt+JaTpO5gBVMSXE0PoRGPglsuq4/x7N6l+NXS0rFgNxfw70nxtzAw/7k/60fcCf7nXc3H0jwaYfV5DQd0eHYOHNQEE9icqDzKWGFGNa6Do0k2DG8MY4HGYCpPiC5xs0dsInQutehKW+0TkBIkN8QCtA3KoqNTXpxXTjN/atEH4msyUG8yQlbgnHMh7oCrS/6QriqEFPDw3sn/QXrqoBQMnIeKLvFffAe0mclC/Sehq7//LWYrme2Y65V+UeVFgAYIKSY5pZrpZGeMKcjOE21GNnccvyOakb6xAN9JGyROe0HJAsMyfLBbCORKZF/Z7E7IKyh+YD4ziNJclzEwXU99dnALcsRv4syq1IViZjY0Sc9im1fKvKurgkhZIgSgbtk0Uiq/HDqV3ECyie3j2oSXkAmWpM6I2ksazWAFE
 mEeK0Z7V
 c/3rMMY1ESZN5ywD/kJYY9zDZKms+lsoaYitNL827ay1O9LKSERkC6cdv2d6GtCf9BuYvu+e+43WnA8zuM67WfEBkYgWBbPmkVP/3bGKwAChY6q4mR7pK80hiTcwWxSKsddXSiV/j99LWLPMd1Mfc+C+5MZ62R1i70U1wRDhmRbxoAzLUHGEUnxrWTwIN6wdtJGK2nXCi5LvUQ+dWLK8dr4Wahd93M2JcsmPwVV1chgDAzOiRtewMXYlHpjSkIhPG1eKyVIXRNHlc5ChqXhJsLJkioc/yKre4ultUa/MJT4LGTWN/GPBQjX3n7dQHh7lqBEMgat6c5WmLKBCuYD7SHXlrykimdI/rnmgkhOjHjaOWhmyHx2iHGMEBi+x0FNlYibMhXaZfIKd/ZYlgCfJRqkxW6FE+ltjNNLRP1NW7jafbDOG1mC/LuJVTn6IonC4oR8cUiU2qmyy6YbnP9GkyULfP8uiORKmO6vA5TLI4FoANuUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:18:26PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Creating an instance immediately allocates two full sets of per-cpu
> ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
> on the default config, plus the trace_array and its name.  None of it
> is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
> while user_events in the same directory accounts everything it
> allocates.
> 
> Instance creation is currently gated by tracefs file permissions
> alone, so a
> rootful container with the host tracefs bound in can create instances
> until the host runs out of memory.  Charge the ring buffer pages and
> the trace_array metadata to the creating cgroup.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  kernel/trace/ring_buffer.c | 8 +++++++-
>  kernel/trace/trace.c       | 6 +++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 1fd28a72e6ee..676c059c112c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>  	 * gracefully without invoking oom-killer and the system is not
>  	 * destabilized.
>  	 */
> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
> +	/*
> +	 * The subbuffers are charged to the memcg of whoever caused the
> +	 * allocation: the creator of a trace instance, or root at boot for
> +	 * the global trace.
> +	 */
> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
> +		  __GFP_ACCOUNT;
>  
>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>  	if (!page)

Hum, by default tracefs is root only. 

And even if made accessible to other users: 

  1. The life span of a trace instance is not tied to the caller.
  2. The ring buffer is shared by multiple users.

Overall I am not convinced charging the creator makes much sense.

Eventually a few allocations for iterators could be GFP_ACCOUNT.

-- 
Vincent

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e8c4efa8107b..04b60b9cc4f5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -8693,11 +8693,11 @@ trace_array_create_systems(const char *name, const char *systems,
>  	int ret;
>  
>  	ret = -ENOMEM;
> -	tr = kzalloc_obj(*tr);
> +	tr = kzalloc_obj(*tr, GFP_KERNEL_ACCOUNT);
>  	if (!tr)
>  		return ERR_PTR(ret);
>  
> -	tr->name = kstrdup(name, GFP_KERNEL);
> +	tr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
>  	if (!tr->name)
>  		goto out_free_tr;
>  
> @@ -8708,7 +8708,7 @@ trace_array_create_systems(const char *name, const char *systems,
>  		goto out_free_tr;
>  
>  	if (systems) {
> -		tr->system_names = kstrdup_const(systems, GFP_KERNEL);
> +		tr->system_names = kstrdup_const(systems, GFP_KERNEL_ACCOUNT);
>  		if (!tr->system_names)
>  			goto out_free_tr;
>  	}
> -- 
> 2.43.0
> 

