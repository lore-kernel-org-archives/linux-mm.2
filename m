Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189A3C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 00:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DA66B0376; Sun, 16 Aug 2026 20:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9357F6B037B; Sun, 16 Aug 2026 20:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B1D6B037C; Sun, 16 Aug 2026 20:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7DB6B0376
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:46:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9159214061E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:46:22 +0000 (UTC)
X-FDA: 85108920204.30.8313929
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8EEB140004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:46:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhiV9pah;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786927580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1adrpR3QLynHsYFALPxmo4Zb1MnnrvFb0B1zDnSkG3k=;
	b=j++E3pqkOeT7hylN6wxek1/hwjTZ690qPM88bMPW9T4PdtZRyIkKgVQ00yQezLUQCEc6Qh
	CY6lxl+8lFPuNq7nM0wfN0ZVbvKCZmpvbXVOjbmNCnTYYST1sAtPBMptj4s5VwYYTpRizD
	sg+kk5CxwiKfnsWjx6CaYNjdB8Ro8tQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhiV9pah;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786927580;
	b=O0iU1+RzjgJ6Qg4BrnQEpM7nGfsvcD95I8ohpPN0tutTflxRMITjoJF9qAKAmf+JZywRnS
	0qqf0KpWv31J/EYji6HBs4yr8p1Obs8vNgy2leVnjnYIPlsX9Fe487ERd4wNaLyR82Gqns
	2vJaZINYH+OjW0mC6WhXyUJMMs+IW9M=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52b6543169fso18635831cf.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 17:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786927580; x=1787532380; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1adrpR3QLynHsYFALPxmo4Zb1MnnrvFb0B1zDnSkG3k=;
        b=jhiV9pahPuwbpw5YbXfskojSpEGAMZzzu6L+nl1cBE9PNk2yMI6reOPJ12XSJzlpPv
         9L5UIV0S1XBh6tFoXGikEV4aoYG+IPMU4G1GW+WUss8fLYcmdS6yGWcJcDQcAs8F03rG
         hCzNp0z0d2dRs8rIr5lorWwYjwuSEU5KZ5z5CgnuaG6ZKo4eeAd5hdu6Sqsn8CqAuJV0
         Ycr6EQiysf0ZBn4J22Q8U/Ej35GJzBhg6B59bWJZmwOJcrP46JkqXkzbL56PF+EokOBi
         rz2nQzF26uVC210A3m+PgyneO+tDT/PEU/XbY7eZJZILO8gpOu9mxfDOpjhxynSLBPCl
         dRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786927580; x=1787532380;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1adrpR3QLynHsYFALPxmo4Zb1MnnrvFb0B1zDnSkG3k=;
        b=cqZVR80X54X7+BLUwt2ciyb6bneni7qd69TEwHcYM8Qjsy8NmIhXvfqyy33jPBuPpc
         /tdRIycQriWL3clgVZRhzhfuXeqZyhHoBh36xS6DsJwqnypOvmlU10isG0CAKfNb8wfn
         ROYmw3w3CjI6z5XnnPwFkoYiQw9MbZc7s+0jcoZdZzkiJNpblaDXiMhRHXpWkfM1h8Oq
         S5Lnrd0Oy186tNOgHXF2cmMkOJu6uPRJFv/Hr0gXqzTBpsl+GYQixhzZ1UD1h9PeVwPU
         NwEGcA6N1sy7pkRs7xooLC3OE617DBMW3kGCjzjoKU+fPLUbaxxzmO/NmjPdE2ytteHx
         zDPA==
X-Forwarded-Encrypted: i=1; AHgh+RrU165Zgs+XLcqzRNZBf06+kqGAcOPhf9hNkMDLe2gS0GocITuqhvitRR8oidmYjkmDu8u9+qNmHw==@kvack.org
X-Gm-Message-State: AOJu0YwlfkpXg0xKa1DNNP4c2yCPvgp3YzOS+ovKQWbnp0XRrfHnMmWs
	tVy12Uezthi6xhm6mssHDmhKUsgLDb5lCJzAAJ3+mmOO7xpiurkp4y0uxPBVrzPskJs=
X-Gm-Gg: AR+sD11t2RPJJG0d1tV2tQURKhARfisWqZlcg43uifyRZrAa6DHDE1dwN6EQSrYFxXc
	gUAhVDrTyLNpg1wtyLuIO4XCTlOtJT71iH9XoPJp2SY+4XfOL3+iJFtxxQp1dtI+HyhA4/aN40N
	S7EIiTiZPwJ1nr5ZT7NScARIPuYRt667QpLcz1Qn5X0PCWXgL6NQjA41JjQx7uKjlJqenBS08UP
	hrZTty7Rlniuy7PbJGkKI1tWqGTpxiRpsqelYYCRby6TBvqGJId17KP3LelKf3UXOiB55jtxXKc
	7FNVAEmTE53pygnLbuE0LShVuxiZQzy+6BSOaOk/xOeosdUU7D1diK8lqsMnCoAHCJ2iXFsjwHq
	JQ5phmrQansQTXizEA592VW1xFfXjjcOKXP69e0DQ8813z9h6hCpKoGfefQgtI0nMFCxAeYBKU0
	zoOyAYEtaoxnq7s6Kajn5GxWarWdsSxfWd6VVfgH9mirSLSmzneAIU5B0kX7MYz4OK1LzqskkQh
	+0lOSJV/+29vqUwU7DPObO9VVmf9BxWvtJHjHmXLBNC+ZmWr73jMzA=
X-Received: by 2002:ac8:5f10:0:b0:528:1478:e1fc with SMTP id d75a77b69052e-52d854a4899mr216242221cf.34.1786927579795;
        Sun, 16 Aug 2026 17:46:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db612c2bfsm1249061cf.11.2026.08.16.17.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 17:46:19 -0700 (PDT)
Date: Sun, 16 Aug 2026 20:46:16 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net, 
	jic23@kernel.org, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, 
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: <an0t0mP9JB8f4ILK@fedora>
 <20260813062351.1856-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813062351.1856-1-rakie.kim@sk.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8EEB140004
X-Stat-Signature: hruhnf5fjuca8k4k1hx5a15s7niih85x
X-Rspam-User: 
X-HE-Tag: 1786927580-189194
X-HE-Meta: U2FsdGVkX1+vZIdUHHNkhDaFrtmUhqZmzyM2qVx1P5LlD3OoZJ7CEf6qjRvb/unk7/HxfmvVmyTh2tQUK+kKE+wSJSzMsGuJN2XQltF16R2SpSMbDrDmoRLL5nz54EslYd+CEJI9D16XOxIXXkc35tPduM7M33Qi6G6rzLwCtUqZGL5NETBpxdJknrAzoP70sIDQiTUktxoQUO7fkQd+7ki2QL2QyNCqI1XDnzGig+u4R5cuI+toMODswvtlE67Y/zXgfweqRwBMf7Vw1a9LcfrWhfr9Jv/P15a1J+KF9WcviNQUomYAjqacFVfAKm0tq0Xox3tk1kxOK4bPaIu5+B4SIgGH6GgqoDHGn/Pjjx9JRCLl/KvogWjVplCPVicBP59IODYRe+F0dnX6fStd4Vb3Q3BKPDlM0pw7splbO0fAUA2Ue0NpLjPwzeik/nKzjFu37rFto/l7pPZH4YbFtnWDSfI232l1ORI8mRRgIZ2FlnKEEYo8JZN23PudZOFRFiiKT1g2HHH6k8pQyKz2zAzgoqTu/VTsKp6y23/qevLnB13L2mlaGwqg1q8toON+I6Vkk8SuaaN+PTwn1MKPP0Hsw8lVdgf7TCP5NasVckdr/a0U7dpUvPG4q/d/64jEG1kS+yjmA04GmmWN+EgT60jSfjkUofjZe8DxHQUXhRN9jHlg5wG3toMY6OlDZSTR4UcKamRXH1n8gqm/a30oiZ77RZ+Zz+gbvFd4wrogP/fCGklIQujYTL4kKlBDQKQd1ea7lVkZbxjZVFzBQGxKoMiDfuxjT8cy+y7n9qqK0zBGQGto3g1kQP4D91e7mU0Ja+K7kw3wQne5Ira5O55vI0l5qZ5tUv9Dhhn7xBQoUXAtBip1CUc2UR5KvnUhElJ+/1JuUIbDXR9q/HLOIqr14sQdIYH665iFgJyaDPoPlLfDikMU5XgdYnDevjXI/ndgWv4U4FIxxCpAtDr3xk2
 8AIKb2bh
 kiRc/901yeBzuS6h/jM44TmcNSfa+f6cC/mIbAbWCt1KFv6aPZwhfe7cgBQ5DHQV55EDzgitWS6nnFn9yuJclRxk4MHWgNhDk7uP/5YWEMUKmEmGaYoq7r/Ir7JGxsXdQvJWCMJIF1tvs29wWsnM+3oA94vLPDs/b2U/1BC8iNUiFQ2m0FhkJdv7o1Sf4GnLKJ/yo2FgfvJEnvx9xtFzEyt8ZXRISUPm2EKAJ/XkJ6+YTCmGb6yZoqD09zYzQAzQdFi0AnL4grof18+1movXCxy/WBAficpEw62taJeZDJuflroQYhn9Q3LKPo9qQgRAJave8JBZkbOVw4RqY6TjDNaFuzcXaEiTboXOXPVN+RwOYvZMsQLceQXuwrXkUzZAT+50UFiz75VHiFWohV5f5GdqZ+JPqQOnbehgGkJDPf1pwTinlArW4Zjd/GDLTJXgOOsAxzsrlIqLI9CfyBas13UPbWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:23:48PM +0900, Rakie Kim wrote:
> On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> The cpuset.mems = 0,2 you describe is the node set of package 0, so
> the tasks in that cgroup use node0 and node2 wherever they run.
> 

I think you are over-complicating the explanation and that's making it
hard for folks to reason about this.

My best understanding here is for multi-socket systems, weighted
interleave as-designed is inherently sub-optimal for scaled workloads
that utilize multi-socket ("package") memory resources (DRAM, CXL...)

I think there is also an assumption that total memory utilization is
less than the total capacity - otherwise some of the assumptions here
break, but that comes with the general weighted interleave story.

I'm getting back from vacation, I will take a closer look this week.

~Gregory

