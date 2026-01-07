Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8F4CF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A83E6B0092; Tue,  6 Jan 2026 21:17:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256426B0093; Tue,  6 Jan 2026 21:17:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162386B0095; Tue,  6 Jan 2026 21:17:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00D556B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:17:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E0E113C871
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:17:46 +0000 (UTC)
X-FDA: 84303556932.23.9FE19D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0D46160006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:17:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hVQzAGd+;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752264; a=rsa-sha256;
	cv=none;
	b=CQXtJQ54fG27fy4Eo/eZJ4gYPD2sUasOMWafBWqOfKirJe62QcOdMkqO7JnGKpBUVKQTz5
	uIw40Hu1P8ws63SWx4nuKnEx7ycy44DyE9tS2mAG40zOAUCdSYgmZbV43WiRD+TfDLBv/I
	iNSBpn5nDP4BhbEJXkEoACNkrIxEZSs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hVQzAGd+;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOX+cCcVr09UHnqGqAByqo0v5FoGu9rYrltX7GD5GYc=;
	b=iJczWdwZkjRHkZZt8y0RkS6LvHRcxPm9kqBJPkpU5xbuXp+0hmIUvvFj7CWcDJwPayOsF9
	yzIDy97P5IgSpDFUcYQ+/y2wCKNJtEDXCijSqOnsp/gmgAiFNDLxqRiG2u4FYkwUr1JvGg
	8zCicpM95rydY5Kfecqkjn7I4Qck1as=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 631E5439AC;
	Wed,  7 Jan 2026 02:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11308C116C6;
	Wed,  7 Jan 2026 02:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767752263;
	bh=iQrU/hmOjEOvQYI5LD85WfwqJMg0nJSQ639lZOkOb4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hVQzAGd+H2ptGMJHZz8I8iIbYdQ7PNqIM/RsVFPYwaknc0NvNCXK9M5Vxp3viN7Ks
	 6PsLuVVIXuO4tm18SH3HVPtEVbSn2vYQ5xGcJ/OcGUiSnKQhdOLkQW+132VARgRZWG
	 HhIyB5eFmhSwcFXnwBbDngqr7rTC366kZALWTBCQ=
Date: Tue, 6 Jan 2026 18:17:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org,
 rostedt@goodmis.org
Subject: Re: build error on CONFIG_MEMCG=n
 "error: invalid use of undefined type 'struct mem_cgroup'"
Message-Id: <20260106181742.5d55894e50139fd7d64f6dcd@linux-foundation.org>
In-Reply-To: <aV29Xj2wo786xVn1@hyeyoo>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-2-tballasi@linux.microsoft.com>
	<aV29Xj2wo786xVn1@hyeyoo>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0D46160006
X-Stat-Signature: dpgmoccsjzrm5qgpzcjmamy3nfuifobn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767752264-168835
X-HE-Meta: U2FsdGVkX19WcmIBAUFdkhkg6FipPuLnGRw7nKUvbKKGx7pgBxIr9+LlOR98VfJ6GPf2nPw2oSukMGK8nZUx/B4093+bGV984smMmMotyIWhku55zxNP+zwbAXJtkn3x4O+cYmUamlE71bfz6Exzp+9Ao5TgGa8+RpsJoggV8wu6lUPT6/cB0JqxnLuZ7EJyN69AZ9zDXf0zDDD2E5t4/iL9qavfPR6TaXGitA9VG6Wt714bqMHcVlFpPcoyxQTL8MC+2KQoBjM8qwzbeoncTaGBKnhBWAA4wEOcvq3gTrnoas+WnKNi8hMhoi7RUVLwyydv5YVrV3PM6zANJnN4xMRrQo6yTN6KMlJH2kVoQ41QE6778AHQ50oFuqFngqwD32Mf52KozoUBpuZU2DUtZUD65agvpc7KSSgsCK3MOu7GqHiRdfBlgdmkvv2kR/chHOJ2c+XTCgQFkCf0gDourROMJP9hwvgA3aijWoSC42HFpqw+0J1k3bC09Irv35CdNqxoEXfATzYxz7mofTjwiPUV8QO+Ic7VOVwy8MU6kOYhgF0dD9JeVZh0/2NfF9PuWLdR83fqfheAD8hdhy4wzoRwO5cveGJPvc7EnzG0Y0AI1yPms7skT26R3/zpUSgAInW+zq4mfLapQjdLRzSoALsGByNEN0nW3SR+59dq83wXZPxUAddf8ta6yYu93L3c/Lm1H6KPMtd7DzjUqrueo/kKYKmBo98l764/UCKNFdMOkl4n73jeHkXlsYAemC7StUXD9NktTOSyVbNz/QkuFtarOcdSOgLtGeXOEq/RodsAYF+q0IKk7NdiiRvWeFltLN90BDunndNjmcVRYtvaAVGU7Qi78w1yiVfl2hrSENoSl+eSMO45w9Q+NlSH4HeCg65/3t6h2W9V+QDfpQjYOrJ3E1Kp+ffSj7mkRZq7ENiTh0QYzCOgDDCVi/g4lUu9n8QneosrMx15qb+o9+E
 BdwQcPnY
 ZqNQp/5IkqEm3Jx5rRrScvC9khOl4vNCV25BPxK+rG62hgHu2wvbbEOG/vmk+UdGWXQ2u00Jh5Fg/yhJfQ8ZnVe4trgG4rYJT6xMOszIvO5nRN0l9q1xeZU5N9Je1HkZ0adjyDKFBTfAh6Ao76cE/fNVZQQbQMEtvOJOpFnz/2PXYfLjsxgFuyyUkQ2MmMqLMbuOwF8Q/ONNcz0z/xGiriqK9yYAMdKP3mOAvEbGB1U4Sg2ohcXKw4qYxHxlDMeqgh0kXvWCVvapNA5Fiirx3BCKaY4U5j6VgQbE4sZMDngGEKChSevgcbQZZmPrpugAnPJUp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Jan 2026 10:56:46 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> > --- a/include/trace/events/vmscan.h
> > +++ b/include/trace/events/vmscan.h
> > @@ -208,31 +215,34 @@ TRACE_EVENT(mm_shrink_slab_start,
> >  	TP_fast_assign(
> >  		__entry->shr = shr;
> >  		__entry->shrink = shr->scan_objects;
> > -		__entry->nid = sc->nid;
> >  		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
> >  		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
> >  		__entry->cache_items = cache_items;
> >  		__entry->delta = delta;
> >  		__entry->total_scan = total_scan;
> >  		__entry->priority = priority;
> > +		__entry->nid = sc->nid;
> > +		__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
> 
> Hi Thomas, this is breaking CONFIG_MEMCG=n builds.

yup, thanks, that series has been removed from mm.git.

