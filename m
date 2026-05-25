Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252C9CD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFF06B0096; Sun, 24 May 2026 22:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C70C6B0098; Sun, 24 May 2026 22:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDA96B0099; Sun, 24 May 2026 22:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3446B0096
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:20:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 321F21C0C39
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:20:48 +0000 (UTC)
X-FDA: 84804338976.22.4BB2A0F
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A77620002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:20:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rOKWbLPw;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779675646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EESnugD7SmRVXa8thBSsJKhJxM/G/3ZcLrzcvVSCzY=;
	b=fcMm56WITclLN2HlQQ4eVEBCm48bHQgFrUnaHAKoMoxKbTyj+49ciDA1uHek89TpkKvkLn
	Ekjqz6iJC4dpM+ekOM7BQLVcBRmb+VI+DLGramAwhuT74TeztleJu2OkV2CFyLg9A72aR5
	HKs1yQ8mG4poDrdfqOT77cTYFBlVAQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rOKWbLPw;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779675646; a=rsa-sha256;
	cv=none;
	b=yioGPKE3pihl9npToMDFhxqbtlJRNfrsQuTXHNLz1AtwoWEeHa49k/Kf3uLl3UqSAeP77N
	yllhvQelUc3bn82D4jBs0fYw16Xf9Pg68JTqG3AL8mIPMFpf55E9Tkib/bNnXd/7y3ZERJ
	UBQZ2OEXDgDPV3QxF2QSouBWQ6lBfFM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50e5bea4045so71331771cf.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779675645; x=1780280445; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8EESnugD7SmRVXa8thBSsJKhJxM/G/3ZcLrzcvVSCzY=;
        b=rOKWbLPwmTp7McUW9l/RhrnyxDArEXk4FStV/D8apI+9ip7tevbHc6kcDw/mokegnB
         aTSoyJvf4IDHwsHQ0PIp89SNPLSOx44y7uoxtPouaAlQBZ+XTSdF1BjKzZdE44POFGV/
         j4ifBpaaHIQM2U8ds9gKVNhirQ802RI1xi/DMqp8gXtpnAqZYw6dHGLO5/JnwOPPNScK
         ShrSRRpAceNvGtMrmnJRUrwYAKugZrrf/Hp0FCPAF7mtn7bTrreniNwcicZeS2XR058e
         TTSlT+huMtunbTjIG/AXWBUKuGzJ87N/sgZpYAI7m/jyywc7zMDMDu4/hJwlUSGvC7bR
         uiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779675645; x=1780280445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8EESnugD7SmRVXa8thBSsJKhJxM/G/3ZcLrzcvVSCzY=;
        b=F4gYj+CkaBo0LB2g+ijWxbppCPkuPVmVIPXGPB1yKRpOL0hwyO7oGk2PSqce4I9aEo
         ICY+kPOYuHqTkcWU4oU1VTMvsj6bo0W6ivXG2ukP0V8gdN1gF8W5G49N7lBPMORnxw9q
         /HGvvPhPZy2ehbwQyEbEp/RxY+bxBSdSxfgtBYjTwi9IVGcMtnx5+ojru4cU5Xu4KGSE
         k9/N77Yz1dThhW3XUv4+qDH1AJlwk33spV71cyV7r1ZWlzfjWQ7bQyP9xboYG1vhXdK+
         Kg4vz0+8q8GN2oX8R9fXOAtuxF5wMWKHNFuOoUIno4cslaQCIy8MYoGHAfxutaVVdTpE
         0yOw==
X-Forwarded-Encrypted: i=1; AFNElJ+U/5rUJKAyri4CQF0Ak59OI0PZtc/aMt05W1MHjX480abMGRKvP9sRjC3k04zpB45+NSbIBW6zWQ==@kvack.org
X-Gm-Message-State: AOJu0YzuX7Evgv33SfI8bTnJXCyIpkPtxp6nk2eKq/rtLvgT3VTZd58Z
	plp+cEVX+OCcCHM/oXlqwysGY4ccPzyipmxcAve2AT2AR6EaMflhgBGUG7+aQW+bb2Y=
X-Gm-Gg: Acq92OH3fixPf+bB/OGVgUTI0DJLkXszhjedOs/lOD0FiUIXNS/ufLnkVOoOf86XYyT
	yosa6CZYTcyfFtqOTc2POA1YSPph7NHJ3H9zbVGQGqX6XgzM/a/2+njczw+Hu+XnzqYCMi8Py85
	tRazFFxvCfb0GtllhvS2LLRXfgjGSkOsbu4u+F8FtoesfRRDZeU0aQfzdWmg/o0U5mdtZngP60m
	IMotfpecfsDmAEqZo/Aqi954zHkli0+AmBZTrKjnBFKrFK7jg848pP5mJRKLExM3KdIgDc9l6Ll
	3GY6fAmPOUilACqpkQGyHcLTl0Bxsr7Eifi6F55U4Pjv29Je/EzwZrgikwWWKrSnDiTv1pwfObR
	oYHh8u+nmXZoRlgLQEnTdg51ArJe3ungjsxgSmxMzaN3dh0AErKKSY20jECuDIl5XGm/SM2U6Mj
	nPq6jUZAd+y5xzLHBHvaqxBh4KAndVxhqt1TPWHq7M2LxEfpXmhXVzqkyFgRr0L0nMBQmgQSlcG
	Fpv06kjatug
X-Received: by 2002:a05:622a:5c08:b0:516:e833:64f2 with SMTP id d75a77b69052e-516e83367b9mr99483851cf.12.1779675645547;
        Sun, 24 May 2026 19:20:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8c91f26sm80087331cf.18.2026.05.24.19.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:20:45 -0700 (PDT)
Date: Sun, 24 May 2026 22:20:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mempolicy: kernel_migrate_pages: simplify the
 usage of put_task_struct()
Message-ID: <ahOx-76r0JvTZHL_@gourry-fedora-PF4VCD3F>
References: <ahMt6xyUNnacZU8-@redhat.com>
 <ahMuF6FC6TIOZ-iZ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahMuF6FC6TIOZ-iZ@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A77620002
X-Stat-Signature: gm845apxtr6k8yionbe9ax4wnon3gr7i
X-HE-Tag: 1779675646-903286
X-HE-Meta: U2FsdGVkX19FLhV8sFNcxise/9Lsq27nw+GyzSFjCz1Rl3gbp1gZ3ZiFDtGH2IvtfZKFiZUv4A1+CMgWOVxou0XnLEEw7xmShbChReB5HmG92a1w0vRyM5QkZ/O2Ihh1ByLK1YUnmU7wNXVVxz7VameKMTlcfTTeCTn4s9JHU4fgzsR79Guv00pmaSXbAhwXDOrmya+FhL/Y9nEAv0NG/1DONfQmj3a1tTgh7y/e50sbo3IIG4zl0Zbn399oSFkxNl3x9ogDy5uYMhq9lmXwfVkiTbhr6tchurKX0v6hfS5fqGZcEZzk3We8C6UC+TOe859cVaju1vjq29ZZ7qVXxjwnK9dHHwOKpnXQwGpjuB/ceAL50q0udkJ/BbOilv48oXkc6IMtZ2WAwQjzL53swedxANYj244i6vdcW6MA+PIdCwH0bnK90uK2lKR6uvYo4AM9Uxg9aLHYGEG7yawn8trdwMyCOWLctWvK4lc2gbDDwG99WhC8xZciPo2EfrG3pfhpW2IM54YkYXe8gp3XK0tgZNinCCEC8UfbGt7pOCkFXM7Ld3wqXMZHicaEHA39wtV+N+CsydiNc+HHSlbW3d9cVbyRtT5lcrT6BFePQ/kKCLtaxQQoDOvJkGAxs4vJVpBbdrCwfBDvOVxO/aR6+FA00gUS2lNOpGdSSMSUXIndFQyxaJIgWf7w7gj94St4JqaoMJo+XVBPwJus7i1XzWIX/AGC19NIjzvI8J4+bxm4MuYU7Vi9OVXNYPSEsVC2GrhbzWd/yTSc/42LAbkEAL1LEjoMuTChbSsuhC5ya/w/97Hs+Nv+Y7NHHO0pnlBkJsBBoHOfjVkiuH12y2eiobtix9ml5buyOJsiMnfWOPr78jTgXWx/C36v2cVCkflDWSVYttE74ARA2fCXrjeOj3gmJmaQtuMnk1AiNrGOudYTljBQDFBviQdrxmiu/dlQchrsg45qEn6eeZar1gs
 HokTqaqB
 nU7b5a59rfAU8zc8nibsLZr+1jFZEn0ZipeqasJa7AysY0/CO0sHPElNjEr22yith11moiQwxHtcb46zjp4MnBE6M+pHO0NtdgztaUXDcdh6fwmQS6vJqFlMvMJsGPd3mDjPsaMJAA/BXM9qzvIxMjObRiqes2P7sQVOl/8j4J/qrslzwYgnL7KxoHVtYix0n5gz7KaQBUVlnzWiO5/LcSV3e3Cc7w+3LY1Oym35OGJUbFH07wlYiVeI14SOP/swLO+ze5b8ldn1IOSreizo1rOx8xXukYb98WfZ/L1q+alLEtzzjYEN5s3LoOQYlnv+oAI4yYXYuwNmgmhNfO7nLPKwymRg35i8+IjdWe1uGQCQ7kXg0njBsujHlQCeVVp5mJOZIPAWlIo0Y/eMz/kPUeoMCJMeWktHU7p9+Q+RW08Fwi7BLVhHMTNVLhh4U25rVyXQmGLZv+3RPFlkJqJIikftx69y0nnHy+4C9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24, 2026 at 06:57:59PM +0200, Oleg Nesterov wrote:
> kernel_migrate_pages() calls put_task_struct() twice; this complicates the
> code. Move put_task_struct() to the unified exit path. This also allows us
> to move the "out_put" label up and avoid another goto.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  mm/mempolicy.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59..4326dff16aa6 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1922,25 +1922,20 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
>  		goto out_put;
>  
>  	mm = get_task_mm(task);
> -	put_task_struct(task);
> -

Hm, I was a little trigger-happy on that review, I just realized that
this increases the scope in which there is a task reference held (i.e.
we're now holding a reference across do_migrate_pages())

I don't *think* that's an issue, but it might we worth looking at the
changelog to see if this was done intentionally.

>  	if (!mm) {
>  		err = -EINVAL;
> -		goto out;
> +		goto out_put;
>  	}
>  
>  	err = do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
>  
>  	mmput(mm);
> +out_put:
> +	put_task_struct(task);
>  out:
>  	NODEMASK_SCRATCH_FREE(scratch);
> -
>  	return err;
> -
> -out_put:
> -	put_task_struct(task);
> -	goto out;
>  }
>  
>  SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
> -- 
> 2.52.0
> 

