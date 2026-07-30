Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6339C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47206B0088; Thu, 30 Jul 2026 12:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F77A6B008A; Thu, 30 Jul 2026 12:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E64D6B008C; Thu, 30 Jul 2026 12:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 625446B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:03:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD737401FD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:03:57 +0000 (UTC)
X-FDA: 85045914114.21.7FCCCF9
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id A86964000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:03:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dLxheRz0;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785427436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcFIQq4zwEGh6eHDSNhDw7+n/lhtQGiDqeuI6khw0pY=;
	b=QclZLrRXzrhxO7wVpzTYDBvHgtlbHlehW+2weVQ+V6vaiDT6sCp51AF9ArHS7kH4OrvHHn
	rvxBWrFfK9W/MhpL9r6rcIfND962BSFfX+VOxaWuIbS+eMZEc/IsM4GVxOckrIdgPK+3PQ
	LvQQpnfxtVBes+aBy1AdM+hBW1+uBas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785427436;
	b=oFAe0gBIsafQCkHZknOwSrOPDjypDXKBDGmAkCwE1vZBCmORjyvPJm51jdNWnIEaGjdNfe
	lvfINsFAOKujvGLTDIgp/ZL0uetC8WbFCcEYoHXj5fXUrWhmZJnlKBEBnpp7+25VSnm162
	H99b5YEIZiGPQA8N74x9r6mee42ZKug=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dLxheRz0;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e55b62640so1089885a.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785427434; x=1786032234; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcFIQq4zwEGh6eHDSNhDw7+n/lhtQGiDqeuI6khw0pY=;
        b=dLxheRz0MQOLErVLevWlBKRCD6GiHY7Gu+RhAe8m8CVKDcPyJjG9CPrQ1upe6vPRIr
         /bJFs+/sQwenhpQEYEov7BAVZ4v1CbRB3UL7UCbehE4PPa/SpWPdCYxLn4TT+jwofu2p
         BOun4XGKDlIM6hTA4+TPWjBYtvQ5cTCr7TQolIZa6+Hqd9OLxt9ncVn3VsnlIQMryUin
         oTyd+yhEhSoFvBmLizTG3piRbVdvU4We/TXypZJRRZu5L17sganfkujYQTi2Yt+iR9CL
         61fslLiaboL2ha26Jx+K7BiXOHIBf8bmS/YwSKR/OnmMIfneaHnUNV7LMLtrNxcwGGOZ
         t+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427434; x=1786032234;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcFIQq4zwEGh6eHDSNhDw7+n/lhtQGiDqeuI6khw0pY=;
        b=C7iV+LZDtfPks7WaJ7rZhVw7jEl/vT4BdrNDpW/l4vcb+GEbhL9xiwtj5/mKVwY41r
         sXXt0/WUy9mis444UDB3q4Ga9V8z/hf/4us8nFORk/XrAykF513OXeTxzPwWJqEMC8pz
         T33DAtL+U+6RNvvCTCue3AuMdV9d5Imbt+sn4JssFn6mscNEbkQCLUITE9q50Zit01SG
         Nbn0Q5IWo67UwZ9isPG3aWWhQi3kg8UBvCK22toz90E3YJuuQGw339v1NTRO53YCd1Ed
         CCMHttHBk21+uHqSr3aO0pUn6hc+TXlYIsFn9e0AAPe61NMZ65/xv3Ha4/1WZHbTXzkU
         aVJA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9pfFUjpotXVfzOFtWUqUlnZ80AvAQ2kFlv54aHkI6ZMOS/IdRBYKvqeA3lfHAAwZov/Lr3ldmHg==@kvack.org
X-Gm-Message-State: AOJu0YzPby3fxWFCKOrdvfxYgQxlEkg1yssgcxxA7VE+0nueQNtbYM6F
	PdSmRY/UdCy/jz8T8SbYTt1cQ3EiF/ErfaxjOccQdvVCLSTSiW8LDhO/eG1Y70DzLEM=
X-Gm-Gg: AR+sD13SJnRsGsCpQPtHZi8btlyRBbXDMf+PoEdCgd9oD3CWUtx253TytqCVfEEPSSE
	SSPBWRYyabtSJ1W0iBFp+q0jX2Y2kE7tqbBAqf8y6CwlKm6snxBTQmHmooj53cd2LdYU1dH6jIN
	WJn1ChXDyJF5GHdM3AIcmKOAc+t2mFnovCM3jRN2VyheZ+vCWPh0xaq+s5x1wLWuHeKp9xn2wAX
	fGL5h7y7YTWj3AN4JOc1aUSdD9KPCwYVFn5VEbPqOHJNpxNKmkec1a5kx8u5fECBrVdEXtpD11T
	cEC1vA2KnicTWxtDF67hldYIh1p59Bc1ndwzggnHvzIbdcZ0Mh23NFWFiMOeGXQOPTCbnRXqnGS
	d4Zo/+NkY7WmDC0SExVkhRcO+7r5URe950dxVxhFSSo0FSNHkmNsPZ/z+75VItp/PJuwrqM+0hA
	pZFVzrDlyDP8Mcku51ogIHLfw4hEESXSSdkx2k7gBSJfxb8ZdRDfZxRiLLBqQ=
X-Received: by 2002:a05:620a:4105:b0:930:84d0:fd3b with SMTP id af79cd13be357-93485f9aca9mr384901185a.7.1785427434538;
        Thu, 30 Jul 2026 09:03:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm438877585a.7.2026.07.30.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:03:53 -0700 (PDT)
Date: Thu, 30 Jul 2026 12:03:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Finkel <davidf@vimeo.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds'
 watermark
Message-ID: <amt140aXu5tYZxln@cmpxchg.org>
References: <20260730115314.1069089-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730115314.1069089-1-ridong.chen@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A86964000E
X-Stat-Signature: dkpbqxsg5rrunrd474chbqztte8qigsz
X-Rspam-User: 
X-HE-Tag: 1785427435-138377
X-HE-Meta: U2FsdGVkX1/ZueExSPoYMeMDkbU2/79xM+QsFPgMQTjVnNkuITpuKoehZ0y2Ix6+eVhqOTW43XQV4y9DOXoj4lwrYSaTABva3JbwGwDNq7f8emppIMZB5PCgoGOtXQM1+JW865dOCTcV2ItbhvLWKq8cM7asb0TEhoIPkHAnqrHStEPSbABMIGP7SrshL3CYVOUfmwo/tC/HDNvs8es6bFp7KcClb/zpL+0HOPqov1tG/3V9GPgVq1zaaR5b5wui2ymYH7tGDRAQVd4aEZ28MKivq1ipnlBRHwsEmpv0iYPvE93gqok0gbPg/D1NTtrZlT63dauGwSeNovmR1eJjEe1haAqaz77LqMxcW2KnivT8QIbLeiUP6n5aFeyDB1Bvb8oU3Y8Fs2R7KpMW/gVbHCKG3ovxC6nPeMH8QAobX83TxMDbDGEZVQf+H/3rYzZrT8wJG53FC1zl8GtFKuIvBFbHP70rwp3dbuoR9wDW7eTcGof0MEphtPOsd0dBPWFIKJXg2vn1A9ozSmiluAMNCPMPAG7eq2YQbK3wmlfefGFtR4zsI41esgvETptefhcu7DVAnSYb8iWWInomwksXF2OmqrIL4iAwAOBUmHrYPIuGrOZzEBvAglBU/O+KQeZKyotuZq7UKjV5TmVBR+mBoomPvhN5shVMWExvpnCr6TJrx6WPRlCP6GtiFYdphbg4UnOqr3tdQW1NmFvwuo8Fs97LdmsmpMxBBsd8aduUAotph2poFQ7YxVw5aHnf6+2/2dqN1uv5xABYaSnlI1QKUuPHRizz8Q+p1GD+Dk3BlOZDBXhgmQhYLpMSVxVNeIJL2oTsN5wMbC6+1GJJyAOcx2BEn7+v1LgzmtkeAQXDplwh3Cs/WLLDwhFZXYMOAeAbEiAJXOBUycoC+LEmwX3gZtDr8eZfFztWwdW3Gy8zDfOxcB+UBPbRMnQr2sw0mSj7fZM5K4nsFjCvF6k6krA
 KcAZ4Xxy
 YLYDCoxn0p5QBAxOD6qoMUWvho9BrL+kKGZZWvKqQXSKx/ICi04NCUQqNSeBRXccdrFfCc7Cgx42V4PGZMDn999PuO1ChMXywRr4qtnfALS4mlVfbHIQ+JysaFzEbOwRfX33TSiYuaarh6nnzt3g1blhE84wBa3zx4inHgN/gsF3ltiR750x9rfqPDtFi+k77QbXzuxCfADGFIuEoSubmFrTDUpjWaahvzj2hzjYGQnCdiZTEABpqDTxL3qHUgGpGrJxbbqMTx6VtnAJOl00P3NrZ1wSdhfmCii7FpFFgPV9ZgohvpVgLTG61AkYPzL+dNviVre17EFelfVTN1s5jmQkNtRfAIbFXYlztWfIZV/rECcQSI8+u/VlNGmNc4QZqc4EUVHZpcPu5OEs+eu/cJQPIF4lauiOs115r6a+WjMGgaaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:53:14PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/memcontrol.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 60145aadfc5e..881e7c459c64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  			  loff_t off, struct page_counter *pc,
>  			  struct list_head *watchers)
>  {
> -	unsigned long usage;
> +	unsigned long usage, old_watermark;
>  	struct cgroup_of_peak *peer_ctx;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	struct cgroup_of_peak *ofp = of_peak(of);
> @@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  	spin_lock(&memcg->peaks_lock);
>  
>  	usage = page_counter_read(pc);
> +	old_watermark = READ_ONCE(pc->local_watermark);
>  	WRITE_ONCE(pc->local_watermark, usage);
>  
>  	list_for_each_entry(peer_ctx, watchers, list)
> -		if (usage > peer_ctx->value)
> -			WRITE_ONCE(peer_ctx->value, usage);
> +		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
> +			WRITE_ONCE(peer_ctx->value, old_watermark);

Ah, because B was previously reporting the higher local_watermark, and
its peer_ctx->value was actually low. Fixing it to current usage is
wrong in that case. It must remember local_watermark.

What about if usage is bigger than old_watermark? Then we don't update
the peer_ctx just yet. local_watermark is updated and propagated into
the peers on the next reset. I guess it's correct, but it's kind of
tricky to follow.

Would it be easier to understand if we mirrored the max() from
peak_show() here?

	usage = page_counter_read(pc);
	local_watermark = READ_ONCE(pc->local_watermark);
	WRITE_ONCE(pc->local_watermark, usage);

	peer_watermark = max(usage, local_watermark);
	list_for_each_entry(...)
		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
			WRITE_ONCE(peer_ctx->value, peer_watermark);

This code hurts my head. No strong feelings either way ;)

