Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B8DF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258DD6B00C3; Mon, 13 Apr 2026 15:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230626B00C4; Mon, 13 Apr 2026 15:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146B16B00C6; Mon, 13 Apr 2026 15:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEDDD6B00C3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:38:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C9AC1602ED
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:38:19 +0000 (UTC)
X-FDA: 84654543918.17.FB2B6F7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3068AC0018
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:38:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YmPtrkq8;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+Cg30G7JazeOMCJRrNEUInL5xwrDgCPHzG/fcerzOo=;
	b=UXHyZ+6gLCojRgFem7WDcEu3/JCaMEvvQ1Vp2vS8lQgpLZmQY3IEXFccw+M2wihhYS+stU
	yaklnO9IUJlurx3S5pVM/oYF4jk76bX2z/xHuYC8oTigDl+zJZQGkVk1SsXabS7OiLYuC0
	7fzE8PFV22oLsw4U68VpDgMyj9EF5HU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YmPtrkq8;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109097; a=rsa-sha256;
	cv=none;
	b=5nPVwgaLgBK7aQKHD3QiFjgM55eRisDEL/lhJMgaYJ7PPfIVT/v5aiFilLM+R4ehYbR0Ue
	rNLvwzRtOIWTpZpGcggtgFenScDDzcyaryeSgEBq2outzFcNLvlBE6Dw9b+GRTOqikCXh7
	4U0ZnTdcT14Ytwry8gOgSwUD+8mRy8A=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d6144877aso50987451cf.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776109096; x=1776713896; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+Cg30G7JazeOMCJRrNEUInL5xwrDgCPHzG/fcerzOo=;
        b=YmPtrkq85IIL8+g6J/jN1/BmhxsDvSN3r4qSp8r+9eGEwDnr/IP9gDaRfV3y0m0uTd
         Byav6ia8X8P0/u6mgCO9KHyXWWjmtqZF6La0mycV0RayFP/vFEH78zAWtj9OrK7vCIS/
         u0U0N1L1/E3P4q9SbxOSwgWeU0OCCvkj+A4Iazjfm9FQlHLSHoUDbGPkSoy+hihPfl7I
         KHRIe+PEVES59OoPthQ3br9JAuAAP0WZ3ExYzBv3U0AosTanw6Ux9EUr9/2tV4LOdfDd
         ZEcgcXzsKw16AE6uqlQIS9M73b6Aqo50SejAWDFGFOaivL069yP4jcjUd7gcofBcsF3q
         Sc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109096; x=1776713896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+Cg30G7JazeOMCJRrNEUInL5xwrDgCPHzG/fcerzOo=;
        b=ZMAdtOL0Qqaiszth6kCiNuvBEZ/B5RGVzQtSfZyCKADrtR9f6AvP/BvdEqIMe4Fz17
         1+JANWb687FFWb6BmySfzYvqY5rsFYROwnIUJX4CdKhAey+8wzNpttmLrcIQocO4+lkh
         5qWM5bUoxJKUMZ8yU843bUrQnNwytftObBcir1tR9FKyc2RXeONdiIrO4W+X9fb3ScqZ
         tX65q2GISON9JFxLUQ/u8NnU9emSDFhHUJvZu/6ytll5IY8ZzKToXrUJLS+DtqV9J0CU
         71ptBUx8TbIiaG+cDpXkp+X1bgoZsLmxKxjD5vwtrv9e1ccRkPLKMW6lzJGEpq9GnVHp
         Zkkw==
X-Forwarded-Encrypted: i=1; AFNElJ9OO6nf068Pp4YQKBJq0gbmZVxTQ6rr2YLp9Ph2Ivj1JBZv6HJvziiT+Ktr3A2jxWYspNKHXcFBbg==@kvack.org
X-Gm-Message-State: AOJu0YzHH9VXHhSta8QIv3LmtumKeyJGjpduAZrYUFOF89RurUbdrbnw
	8Xejt43w31RkgalRIfFtkwyByLPdl4sNoaR7xfmwn1CVIVvxPkqsvWLDaEOPPlh2xNE=
X-Gm-Gg: AeBDievdK3KBdJhuuR7xCAsSwAamDx5OI5Y9RgSQc/35rE9koQcR9GbvlrCXSrP0pPY
	EHe2uGbyK/+G4mgss0O+yrx7OkHg8DFoFrfuv27j6rCq04l5G9EELjypsChxAvgvKnZ1xaCjzHU
	8GoKZBW3vNH6hLCil7BbSvb8QqXHiOMbC9q0+DG/5tAYcurckgoqdPyXcLO8Ij06hSnHj8KIngU
	207eaJH1V4xJHwwNNEnkuCMDLFf0BsoR0b6xZkmKXDdtf8NYS66A5t87/s3mfPsiQX2mEmk28+f
	QrtTHr7P7fgiskOGHHWkjKB8iP5QyEdnjbwtlPVeDMvvdKbsACHk95fzdUqQV3eSZo9Rt7qBMBC
	7npNessZaEGXovYg86lxSOUcgmRL9mQAD5YmeXHgVxlS7hF2hdGAT1xLzECk/ofg71EYXk5vssD
	gSvUC9vmHywcwhGkPfc/SppU6m3i/uSDWQnyNUutPNQi4cpBR8g6x49OPyx/h2pExaYusrokbj4
	//i2qY5AmoteD8/ExYi7X9BGkH49AUr4g==
X-Received: by 2002:a05:622a:82:b0:50d:8210:eea6 with SMTP id d75a77b69052e-50dd5a97fddmr224412971cf.1.1776109095971;
        Mon, 13 Apr 2026 12:38:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dd564c160sm95841161cf.30.2026.04.13.12.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:38:15 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:38:13 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
 <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3068AC0018
X-Stat-Signature: untwx954mank4sj88inrkz3h3zqueyyu
X-Rspam-User: 
X-HE-Tag: 1776109096-298071
X-HE-Meta: U2FsdGVkX18uicKeLvm4YeJ6YGwOj1gquxk/Aa1CF1ZMC9ozphYChkRPtlM2sF8315gOGEzlYrPJBJwa9d6zoGzvqAzXYQRy9FXPaeA+rx0LqbnBRLcpsOaHAP+T5IDcXeADQrMouiIUnnuNtkBU9uuljY3OlhsKxlZjFtXarIRJAwb8AXqPx6NGFKG/HD98dJ8jTajc+8zNerTRVTsslQVm1Hdsl3+Skh3MMl00F4z5uXctA9Epa687s2wz/dzOgtJjQk+33XO37jVxIJRxyc7v+mIe9NvrmEyjM9AAXArQCgt+1P1AbPR351PZXYSgqmOdl/SyJap4Tdhc5Bfz71cwnukc3Jma3UEfuo9+cNR5MYXJfeM0lcY2WOfo0nvYZCNeeJHT5T5b8dE5+RijHTDg7Yj61AqO2cKBMWH0ly83tRIKE1mdBjp3k9CJ8k/YE8TyEbGim6uVlBW8ft7l883zxVOTxml1KFqdx5iAFP8YDVKq4yI+AtujBRTTrYDZVQl9sW7wTDzTM6CaToF/n+a29O5JgtU6K0Y22AO0lQSelBwstpPVUJnnPg9xTTs1qAgARjzUmMMcwzfKdGPUSAwDFlHd7A+jr0BAsG5luvE0ebk09qcdc5C26+iNWXA0AFUkJDzAgdElfH+lmZyIhrGaDzCn3Frm2Kyv/mx9MXxIA1kGvJQSLbke+kJ8/Ke9QVXIRXPhrQgmVgpXTwzQMIMjNjPOXF3hDenIZwHX3lnVFvRrRBalMmRkUh+DywYFcK6KsBV3Xm9gtaN2dn7AZnv/aTBuiTUv4wLe+ME6eZYKowcfjgwYe82dW30gJRduMQ7FMl3zw7f366NaoZ4L/u4bROERq0DNk/1Ewbm8R7KlbLPm96M9M7Nr7d6uLWc9iAKUdswRSj803zmtidzm7A2/bRjH4+4zX/5HUXCJQPAGTnAFkndolrxRJlAxgGlxSv9st6zPQoeDDOStkZ2
 atj3qXoK
 XWLGvz40L+MD58oYeIUsI8ngiKXd1QfRg/UwzifMbP7H72Flozxwg4fn30eG6VGK+AGRSv3M2UW0iAAoMLfGEuE+NpHt1UDt+5DMExTAM8t4CXlv5XeOi9xCEk8fwd+cK19VPLLW0pIp3317tM9E4Wk397ez7MGAD2nYMgM3g3zwBnY3VkjxK9uLVu0AOZ9zYzRgxiE1PBPQ6RmNqyTTumVKBWmkmnfgSgt8/h130MWlmqedizZDhRPpZXwgmcFk6bhMRCGmGU+ZeM2v/FSS00H9pEbVpZtES6saV+bTp3jwTiYQ63ALEuGPjHTv6hmsgEtEBX+URhe+S7tA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:47:01PM +0200, David Hildenbrand (Arm) wrote:
> 
> So, really only user space can try offlining the memory after requested
> onlining succeeded.
> 
> I don't think any udev rules do that? The usually only request to
> online, which should be fine.
> 

In the offline case the block will cease to exist after offlin/remove
returns, so what should happen is the race on offline just fails and
the stale object cleans itself up on the way out after failure.

Userland temporarily sees a stale memory block but can't do anything
with it because sync'd on hotplug lock.

> So if a user does that manually, good for him. We just have to make sure
> that stuff keeps working as expected.
> 

Yeah the only catch is if a user does something dumb like

    cat block/state -> online_movable
    echo offline > block/state
    echo online > block/state

But like... don't do that :]

Udev won't ever offline-online-race like this, so it's not a real issue.

> Or am I missing a case?
> 

So yeah, I'm fairly confident this just works.

> 
> I'll note that offline_and_remove_memory() can take a long time/forever
> to succeed. User space can abort it by sending a critical signal.
> 
> For example, if you do
> 
> $ echo "unplugged" > magic_device_file
> 
> And it hangs, user space can kill the "echo" command, sending a fatal
> signal and making offline_and_remove_memory() fail.
> 
> The question is, if you want to do your best to revert the other offline
> operations and try re-adding/onlining what you already offlined.
> 
> offline_and_remove_memory() handles that much nicer internally, as it
> tries to revert offlining, and only removes once everything was offlined.
> 
> I think I raised it previously, but you could add a
> offline_and_remove_memory_ranges() that consumes multiple ranges, and
> would do this for you under a single lock_device_hotplug().
> 

I don't think this is a very large lift, just a slightly larger hotplug
locking scope.  But then - the per-range thing in this set should just
work, so let me know if it's worth the extra churn.

~Gregory

