Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BAAF44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0AA6B009F; Fri, 10 Apr 2026 08:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491556B00A5; Fri, 10 Apr 2026 08:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A74E6B00A6; Fri, 10 Apr 2026 08:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2C76B009F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:32:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD2231B8183
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:32:47 +0000 (UTC)
X-FDA: 84642585174.23.C0D8177
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id B23DF10000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:32:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JR9+HmIb;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775824365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfYHIgwT/+XibyAqqKvJ/BcCMPjxG42mmRmKZ+baYyU=;
	b=K5fyK/BsUZQKRg1/6MjAdys/6vgQ/5ISc+4emUgxRndt7kIh0JW/EQ2+Q6t44Nlfa3f70b
	Z987roHNJQSE3DOPZ9y7xBcdWaEq4T+TLoduiCDxEPU0MFTCeEncj4YznHkS1DAHWdJ0SB
	vVlAsys5a37VWWlXNNRFcpJGVA6PkOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775824365; a=rsa-sha256;
	cv=none;
	b=wk2z+uK3yk0pghV3V8i+YJxduQZ/756R7DRa0aXLDaIlAlpxE2KkGtO+wNCKyOyXv/aQxz
	auRLPttqizRn67qLyTcRPkLqjciBDLEN+iTn1Mqch/R/nurZJrZ73IV1vflqhDYYRxSZz1
	Hf1bYEfnL9N5lsFHp7/OmN2bj7Ze8mw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JR9+HmIb;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d572f7437so1376229f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775824364; x=1776429164; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfYHIgwT/+XibyAqqKvJ/BcCMPjxG42mmRmKZ+baYyU=;
        b=JR9+HmIbgd1i9lldEjFjwpkmX4ohPOCCqlOpbvwUv7Ah3/LeP2rGmWUKtozLtYNmew
         LvgP9d/araJxVm5dOGzkpsYMIGTNP95+4+MaPGqF0vLDxuPvMHwri/aiq6DSDyHcEvzS
         FSKOSD+UZWWYxtRb7OgXH6haIgeuSTl0FMkrJJ1fCQRJAj+To1+VNEzEe+W/xq0yqgxS
         EGv755wpQU97nRAJo87WWH6BoFipv5wgyNbRz5HwGA9VWvo+29livYD0oBnB2pNQCEuK
         UsNKyWkTZ8ec/Em4p3rjEvhc80MlRkgl2kQsVnYXlt2u7eBV4d6s9QJ1lrygHCkHWAAR
         3tiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775824364; x=1776429164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vfYHIgwT/+XibyAqqKvJ/BcCMPjxG42mmRmKZ+baYyU=;
        b=IFxNZxdP63CciXdYMF7HnB5qjd8Ys2rbgR9kwORZ83sb3LFwy7HCNGkgSxo28GJjw3
         1XdouyeMRtxRS2iWsXyU6hKkTrB3PFwoArjfrPk9Jds3kQ9Lr9hRG7igyQ/pdtFqn85J
         D8U6sIrBRroAf9eotPCD/xF9Xkd4Tud1cqEXqeBVZyxmZaFGrA/R1v3W2jdiHPxiQtQj
         u5jnNoeS9QeLFpxAR+KIG2ygUN9Uu7B77HcvKVJdu/DJaBG061OebxTh7MuGLL+1uJzf
         nNqZ54QgrEqGq3OR1kgahgvmV9Nd0yZmUoq5EJbbASsuvgdx/p6fp/glg1k11ufe+JGg
         Fq1A==
X-Forwarded-Encrypted: i=1; AJvYcCW3qC2FM5aFT0balBY7cK8KwdOnJzZr+EyAXIdTrQo1UCNigbdLmW2TGy3/snDBZ0TWxETE9qa+SQ==@kvack.org
X-Gm-Message-State: AOJu0YzRsxsVmhxWaUCRaxRmJLuCBrYoarh5sbt13bj4tphgIxYA+rxA
	dO4Cjb6/P2ZHWj2XBkTkG+RiXjOlld2wx2m9RtjlGyMTIlj/eYVHiNPLUuVkntU3OEE=
X-Gm-Gg: AeBDiete5hpaNOS3yYae3JkyXnYWCsvloHkiwh8jWCM0ZJ0T2XOQUVTPIOiNr+4HSon
	83ON4p8NkOmcUkBVTj32RVZqapBRAGJlN3KPpfMRGCXZXZSY/A9r1UdKZuEP731yhxXBaH6cEpH
	QwAMejmTD6GmHX94ZKbtiBJFfA+hJI5kg3fd4mZgQB0luYV8p3Ynlio//55YVb60Rg/fzqRlPQ3
	+nmRUXNjuewwYu4iPumBztl/ORQfmziY8RB9SRoC1TX0mWzC0zJKNYkMTsLExKnY2tth5K7vfzx
	x2KobYAuj4Sydx7P4oB4aLWHxKj4SrAqiFDVv3++gDipOMuh4ZT0ebDEa3E1VWGEnBWONS8Tc0n
	edEQOjHF2dJ+lyBAWNFLWGLOvujstz0yC/Sv+YXHRrJ6Hy/Pgkx59lLkZ4xhhFk0Pc8esLy+V8d
	jTyVcHE3krCKuMbKgi7jazp2tx0ToVy1IQeQ==
X-Received: by 2002:a05:6000:2010:b0:43c:fb48:6856 with SMTP id ffacd0b85a97d-43d6428a35fmr4505424f8f.13.1775824363866;
        Fri, 10 Apr 2026 05:32:43 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63deb904sm7831977f8f.9.2026.04.10.05.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 05:32:43 -0700 (PDT)
Date: Fri, 10 Apr 2026 14:32:42 +0200
From: Michal Hocko <mhocko@suse.com>
To: Cao Ruichuang <create0818@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: reject invalid stat_interval values
Message-ID: <adjt6vjOxYY3Gb7W@tiehlicka>
References: <20260410112554.23165-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410112554.23165-1-create0818@163.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 9ub7bkpsyidtmxty4qgkj6ooopdrhcco
X-Rspamd-Queue-Id: B23DF10000A
X-Rspam-User: 
X-HE-Tag: 1775824365-712166
X-HE-Meta: U2FsdGVkX1+hJFkcjhjlGaPA2XmttLUrztVdoTgIRBCHjjxYTa0BPsOD6IBkxlJUzyFTUp+tykKcjk6yU0/jYnV8BaruBplGwvcBkUX6EjTCDfL5zGppcYgOuOcDdyZmxUujtvwsl5xNVtaKnB7WSt6+fcyZv2XqHH5zqn6LxwoHiNz01Wlj+upAFQDmXIcOUR2pOlXYxIAglpxO9eF3khjnEkKgHZM9NJFuLdz0E++tbYfRZCplu6TTnt3HvwWN0WWwrkI2GzeVg+h9uTStOV/3RGOXd4mFG7u0Pc0wLTu9TykFt8+1GQIQQiwgJ2hYAj0YnhD1RfzleKm8oJwZ5P/5iUINHp/t4KSlvHlB4ILjieYblFUuDGDflcSgR9FztCz5dH4wKV2SUw/hEMDwmkeVxGtegk8u5j+6kUY37MeDfX556Ie4d2ld28rplwqhyCqDv9dU6AG5hq+lVaZRzggGQL+zujAbZZsJVacXbGCBLK0XJ+Px0IyqbMYfY6Oe1jrZremaBMguWG/YpHy/Zv/0GQ4bGBmqvKJmafPh8XrVREIDJ3AdwpN7PYjzQ9JNKJhkvwHy/VLWm/hf9di8AUL2S4qQ1TLu8DGSeflbzQZFNySzaNElcnOqvMXF229ALVZi1WvOo+TmlThmMbGGSlczuiKvlSXpcdDnYfmLiAAAwZBr+tsCbGgxd1otSEufPuH3rSxDr6Wo8djD/olejOM0exCSvPWlqJ9Blzu1fcp8QAxgvrbtGIQczoSrXnf/kRviOO7L0e+x+ipE5YjImsT/u/QEBkow8cCt6Fy8uSEYMVEOfzz1JhpwNadWLmp9sk6T8d3GrFiPI7D4vzJqqS4L2H4egskndmdxTBGyk2USEO+VRIGm7XQwkRuAcdEjKTF0Uo9c0D/DXl3sKMD1TMeKhX8qsxUgdossxraHmik6gljLp10zfvFVteQxDAwMU/Zdtzd/bOA/4OPXj0k
 JOhrpfi1
 ED9OabfHOqEA7gOI856sL13VXted/5QqvqdrVOFmU451CsNNSwe2g6PFO7lOKvT2vwZ3c8iilua+qn+u38FfQlguJgmtB8YCaGBSI8DJU0xwTrIcr8K36z+01cUZ+U5cIDoL5dom7DQs7zT5eeCiDfS3KtrKP3jCtOrKyi8ioVPh/cLhdv+ylau3/uWTpawDl0uqDdXNvonW+ivuSmIoxln6zghWm5Y5Mv4eLiUX97sI7syoxIjwKAgROYZPJ3oCVrKUoaeyCmy28nR5fSjVj3/m/9rQCqZMZE64PwywSW/GKQ7z6vP3u610YwWy9OTOQFn8Z0s5kxcfDTdX6msDXlstPaaSStoHKNpWH7bcLDCbnjxHlM9GsqDXHbD9q1FJpr8pNozLwsscNlBcl5vHk/JWRneOsVsbBRzPlm2lLww3Qy7dToHRRlFvEOem6FNmQ6dl/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 19:25:54, Cao Ruichuang wrote:
> vm.stat_interval is exposed in seconds, but proc_dointvec_jiffies()
> currently accepts zero and negative values. In the current tree,
> writing 0 succeeds and leaves /proc/sys/vm/stat_interval at 0.
> 
> vmstat_update() uses the stored jiffy interval directly when it
> requeues its delayed work, so a zero interval can drive excessive
> kworker CPU usage. Negative values are not meaningful either.
> 
> Switch vm.stat_interval to a small custom sysctl handler that keeps
> the existing seconds-based userspace ABI while rejecting values below
> 1 and capping the upper bound at INT_MAX / HZ.

This is admin only interface and we usually trust them to know what they
are doing. The same applies here. There are many interface behaving this
way. Is there any specific reason why we should treat this one
differently or are you suggesting to change this approach and sanitize
all of them? Changing just this one in isolation is IMHO not worth it.

> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=220226
> Signed-off-by: Cao Ruichuang <create0818@163.com>
> ---
>  mm/vmstat.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 86b14b0f77b..f48d3bdad64 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1964,6 +1964,7 @@ static const struct seq_operations vmstat_op = {
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
>  static int sysctl_stat_interval __read_mostly = HZ;
> +static const int sysctl_stat_interval_max = INT_MAX / HZ;
>  static int vmstat_late_init_done;
>  
>  #ifdef CONFIG_PROC_FS
> @@ -1972,6 +1973,26 @@ static void refresh_vm_stats(struct work_struct *work)
>  	refresh_cpu_vm_stats(true);
>  }
>  
> +static int vmstat_stat_interval_handler(const struct ctl_table *table, int write,
> +					void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int interval = sysctl_stat_interval / HZ;
> +	const struct ctl_table tmp = {
> +		.data	= &interval,
> +		.maxlen	= sizeof(interval),
> +		.mode	= table->mode,
> +		.extra1	= SYSCTL_ONE,
> +		.extra2	= (void *)&sysctl_stat_interval_max,
> +	};
> +	int ret;
> +
> +	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +	if (!ret && write)
> +		sysctl_stat_interval = interval * HZ;
> +
> +	return ret;
> +}
> +
>  static int vmstat_refresh(const struct ctl_table *table, int write,
>  		   void *buffer, size_t *lenp, loff_t *ppos)
>  {
> @@ -2236,7 +2257,7 @@ static const struct ctl_table vmstat_table[] = {
>  		.data		= &sysctl_stat_interval,
>  		.maxlen		= sizeof(sysctl_stat_interval),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_jiffies,
> +		.proc_handler	= vmstat_stat_interval_handler,
>  	},
>  	{
>  		.procname	= "stat_refresh",
> -- 
> 2.39.5 (Apple Git-154)

-- 
Michal Hocko
SUSE Labs

