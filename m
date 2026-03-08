Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD89EA8543
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 19:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D1D6B0005; Sun,  8 Mar 2026 15:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4AA6B0089; Sun,  8 Mar 2026 15:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F72B6B008A; Sun,  8 Mar 2026 15:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1A96B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 15:20:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7B731A05C1
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 19:20:44 +0000 (UTC)
X-FDA: 84523862808.11.DAC540B
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2CF23140007
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 19:20:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MedgDsff;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772997643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6kmBzNS/25cHmBEwOEgUDbKXqaLe2GkCkxgRM0uJ1o=;
	b=BwDj/kX892iXw6Mq+3VMNhdXebBpAgoS7058yEFVd8x/TdnAdEzyr27T079uSOgvssMzMO
	9Gs4+BipPjP2UtGFgBoCn8595OrS9esAS1+PEg96Coox99IUGa6xglFm0OxoGWCljok3me
	XfbK5AEiv4wnbttSgeEbI9bTDJhPrYM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MedgDsff;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772997643; a=rsa-sha256;
	cv=none;
	b=ZJtSH8gz9AYEQTnYr5r2YlBG08DIxjGaQLYcQ6hN3SxJugVrh7YZi0eF01Wr/73py/V4cJ
	yHMnH4M8vHYWwkoP68TB0VjdoQhdSTjs3O/ERvwphpWw62nWLnkcnrt1b1xdi6ZkpQzOe3
	pyEg5jTf8VMZm72DoFgutb3/dL+g5sQ=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-509149ab7d7so5309611cf.2
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 12:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772997642; x=1773602442; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6kmBzNS/25cHmBEwOEgUDbKXqaLe2GkCkxgRM0uJ1o=;
        b=MedgDsffmNPVffnPeFdkAFbNCCE9P+zYFH00pt2IVzeA7WGjF/BV0ex+V0ypYMZCnM
         hyuAYFIjJxAG+3Ym6dRFs8eTOp1evISXERzePFF46iAZlvRyu11aGOaEloyQWYG8ByKt
         BzczEc8EuR8SHD0DMDB1eo5e+Sl4aIdRRFSGX7CRAqGSqWjtQ9Ugm4UGLXRjN9CO6lm4
         mGvxaqnOB5ZrZzpOYN5LOsYBqyx3bqRpug5cm5RPKGJ5SJ09X1YNLwJ38eB5XFx9t31H
         i7+UMBnsEUllVrh6oU1/yPgK0Yp+vv8m/g4zBEMtxY7HtJjCdEbFDWkVCzDbi/MQpuNP
         X2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772997642; x=1773602442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6kmBzNS/25cHmBEwOEgUDbKXqaLe2GkCkxgRM0uJ1o=;
        b=EsU+QBIjV8oIz+wTmT+a/1xK85RS5lLsR+7p2QiXtg6Jy3fTNIpHhsrSvdyZoRLZ3C
         NQK6keWvdN1+fHBQM60O/XrkYLCnoL4e1aMOgBSbNidARl2gVXINJgTawr41tXwXAUgb
         BXFI1mNwrrq5uck64pBZTTTVx2w20cGgs6K2lUQbp3sfIot39yIPW/ZDTSk7Qkn0YYLW
         UQkzrm2XXBRv/gaPFgywbzpPQNURl2jChSo2W5k9C1fmDm6wS4BRPCqTuDb4p7UhAYUL
         I6GXHnWQj9KHcykUizDUt4sD8GvtgDj2CFidE6bBSjTH4nrl68eayKnImZpOTv7S2cQy
         e9Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVEbFEYychQXXnQMmxL6x+4uyTxvcSTU/Wraq+AzTY2z/WNavWUQnGFXZWrGIWdCcy75RSKCa5cnQ==@kvack.org
X-Gm-Message-State: AOJu0YwvOP+OTRxrKUDAWqlAsc5Pxv+yZJItpqdC9ZWQkfzIW3uGfBH8
	3rGGCvr4pMLgOoVLD+r4u4olQbqaUvYdIy46AJ4q/rMOlNQXt4MwZiU5oDC1o9elNhU=
X-Gm-Gg: ATEYQzzW8K+OsimOSdQY/B2k5eVidOroBGGB2ao8EVN4ENtnKS2hBVxJt3PqLPcboNr
	a5Y+xFRIzqa9Vl+rgIzTDDsoz4dSvYBxaH8xzKiGaG3oHMrubOvcp1UKPnttb7P8ev9SF/wmi3y
	Kwagc+/lmpCdwsYLS9orCPf3Ssjt+XZ5zlKzsZWovL5y5YiReWukNMrGEeG8LtvHAgLqg8d6SiG
	lM1EiWv8nB5ctNidLh2b2VKvThj7As4Ke0JynoH0pjIYUPQGbfwTWXsdw0uXZqqBwJVEUctaBn4
	T1pYo0Dl50SEwQ/fBugS3IYQAKuPuihrMYDhjY/o0zaVVdh5igSgqXo22w99gqlimAKkJ5najq/
	yVx96tUfHQyogIZPWquCRHWL4ByAX+Ji07+IEdYlIaVPrqYiUdPUF1l0wN3Oz/d1FTfza/IM5Dg
	D4K0VF+Sn7UfA/9QL+KgfuIznbOiVEwQta/+LquF3jRjTejpVeOiLjbBRTZFCrn9bRhoDEuJtd9
	6rUFLUq0w==
X-Received: by 2002:ac8:5fd0:0:b0:4ee:1b0e:861d with SMTP id d75a77b69052e-508f46fafd3mr130582111cf.26.1772997642178;
        Sun, 08 Mar 2026 12:20:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-509101c6a55sm19141431cf.23.2026.03.08.12.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 12:20:41 -0700 (PDT)
Date: Sun, 8 Mar 2026 15:20:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
	apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com, yuanchu@google.com,
	ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aa3MBp0JhUN6zE8i@gourry-fedora-PF4VCD3F>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <87seabu8np.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87seabu8np.fsf@DESKTOP-5N7EMDA>
X-Rspamd-Queue-Id: 2CF23140007
X-Stat-Signature: sxjjodtmsmskc5kbcnupupdi7h65d4gc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772997643-927010
X-HE-Meta: U2FsdGVkX1/XmQbApDAE31iCedVt/9orwmQsoGStCjsCZwxDBlh0tIhYUGDq8M63YR1Fx7jrDBdsKpd1ZAt2iAEfnAh5nH88u5rYnnEd9ZEzU/dZyrIWV5ECgeiUh/wqLPZmUIyxKUr+HeB0w717NzJ776zkrNfs604K4W8aqlJXCkgLRqPfOM0sEf9m7aiGR+zScqDACG9pgdP3aDjsevtCgU1n1p2q6r5SSRiwYdPhVPxL/iAnpdbYvJQSBWD6yBEX53fO9A8RlCguMkoicDUG9GGe8PBga5vVlB2ZFjcbRDBhrM6j/Yax4EDe1hfr45Z78nitHZxIlKOkoI0Nw21tVOVorzrpD0OtZKeDiPGUQDoUdqCUIzfF6g0qoU1iqKFZCGD/WtrVuHMqIkSHHYgEsRVDaIRQIKyEJO5xPlV9YXQ506Qa2O+gJQyleS7FdcdnnbclccNx7IdDTAV6gsQQmKfxO9ZmlcWjK14FML/QP+d9NqzUDssk7h7zvMbMDyrUmeYilIDU4gG5Mo7fGWPFi8ff45Vsm78WTvqs2L+NBAmVnR6bm8r5XdYxcSHBwgoeAHEd/oGsS8y8PjXix5pzvUhust9wGCi8W50AgKmV4oHuUdMJ6ELusnSLO/PMnRAR6RUfaPDnQ1g1YhhEn53YeyKGas4oyqT0gJrEJmWcNYRNIDxixZLLpEWr4szNHjPMO3nIj3EppLYPJcUzJwckdwgzdLQhdRATbOlGnz6eHNxIsoKX1ttcGGuVO4t6S96JzIkbiLsrUU7Kg4OhHrgYCti+af6gVBI4WAYJCZAL/O3q0ZULTBIRKJvUxv0VTC84AlZNkBYUDqiQGUgS56lX8zqKgmJ5BqPzY3wJzA3OFyphipijR6tqYXXwYEjKHDDBcmU6095/KkS8Od0CZ6Elffe+C3ow6nmkrlpDu+6aZW2mie7U1PGjxWjn56PVYP0ceTlAQseICGjHq5q
 hsVOVBIO
 YzTVqDt2f6E5JrEuaP9xPns0orIi3xYSFHOaUCv39uKRoH4843MuZDXTCKh0HMfSAhMy+72ZPgwZAK1RTYBmYFDn7z88p4N61+HNw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 08:27:22PM +0800, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
> >
> >   hit
> >     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
> >     - for other policies, allocation succeeded on intended node
> >     - counted on the node of the allocation
> >   miss
> >     - allocation intended for other node, but happened on this one
> >     - counted on other node
> >   foreign
> >     - allocation intended on this node, but happened on other node
> >     - counted on this node
> >
> > Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> > in /proc/vmstat.
> 
> IMHO, it may be better to describe your workflow as an example to use
> the newly added statistics.  That can describe why we need them.  For
> example, what you have described in
> 
> https://lore.kernel.org/linux-mm/9ae80317-f005-474c-9da1-95462138f3c6@gmail.com/
> 
> > 1) Pressure/OOMs reported while system-wide memory is free.
> > 2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
> > down node(s) under pressure. They become available in
> > /sys/devices/system/node/nodeN/vmstat.
> > 3) Check per-policy allocation counters (this patch) on that node to
> > find what policy was driving it. Same readout at nodeN/vmstat.
> > 4) Now use /proc/*/numa_maps to identify tasks using the policy.
> 
> One question.  If we have to search /proc/*/numa_maps, why can't we
> find all necessary information via /proc/*/numa_maps?  For example,
> which VMA uses the most pages on the node?  Which policy is used in the
> VMA? ...
> 

I am a little confused by this too - consider:

7f85dca86000 interleave=0,1 file=[...] mapped=14 mapmax=5 N0=3 N1=10 ...

Is n0=3 and N1=10 because we did those allocations according to the
policy but got fallbacks, or is it that way because we did 7/7 and
then things got migrated due to pressure?

Do these counters let you capture that, or does it just make the numbers
even more meaningless?

The page allocator will happily fallback to other nodes - even when a
mempolicy is present - because mempolicy is more of a suggestion rather
than a rule (unlike cpusets).  So I'd like to understand how these
counters are intended to be used a little better.

~Gregory

