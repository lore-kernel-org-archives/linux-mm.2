Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B2ADCD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB296B008A; Mon,  8 Jun 2026 15:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2C16B008C; Mon,  8 Jun 2026 15:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9105F6B0092; Mon,  8 Jun 2026 15:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 848026B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:57:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 290361402BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:57:01 +0000 (UTC)
X-FDA: 84857803842.16.6B78E98
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id E99C4100009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:56:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ISANHzh2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780948619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVZLJPHs13SSR5fmi8AOTKgZXJVh2W22uKCUkrkg5k0=;
	b=bDD/c1n2V6/D2TqXrBbidaZvkUFjK2bNIPS4Xw7pfhSGQEby/rNG1ZfgJkq3Bo7WIlimw9
	nq17mUSk1zBOQ/cQCe3JFbI4VbTB3KiljrC4Obr2mRwjfGfZ9nv2l9Z0KOmWR7GnTstzuO
	jz2Yo3YwY1o5qM9Be2rY49oIUyJAI88=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ISANHzh2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780948619;
	b=Vng0KI1GMDEFX/kOegQ3tcWQPCtVnU3h+nnaPDgJNv4NiFqCGQXL8iqiAZ/DpimnfOJ7Kt
	m3yVJzSwk6iJmyKuBvXRvcneVgcXAXSlbnBlM0G4JpG5n61CY5QcH9G/u+TfeI7SK/wulj
	Nz4vOUd+phzf34CJfznvBoTaeUtoGS0=
Date: Mon, 8 Jun 2026 12:56:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780948616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rVZLJPHs13SSR5fmi8AOTKgZXJVh2W22uKCUkrkg5k0=;
	b=ISANHzh2i2w9IKO2C1ZMXVcF/bhPbrT+jKQtlWO/Pm3e3bxxite4bnt4/OMfCdvGMdgZHp
	+J0oHE2t12l8jxcoe38BWB2fAhdaYOZ17UcZjlEKzbVFHycPFiC/tJdN6DFR+aEKpSgJ3p
	xYv3bQwgqMcbllYTeGCrfR7irhmA36s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead
 on cgroup v2
Message-ID: <aicdqucZVqAUfh7N@linux.dev>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <aib11jSWosT6635u@linux.dev>
 <750406a5-1819-4ca6-81d8-5a1d82e0644b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <750406a5-1819-4ca6-81d8-5a1d82e0644b@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ig99d8e6zihfedwarcjzfmnicsn1bghw
X-Rspamd-Queue-Id: E99C4100009
X-HE-Tag: 1780948618-400601
X-HE-Meta: U2FsdGVkX19/iaNd/nI/DEJ80wnRVpNqkQy7sFtZJIEnenrEfLgWDrio93Nb2+Au6jO1S6j1RztMU8VNVcd3FmqZBGv+i89OAANaxchq2YLL0bJHIwm5o48qy8yeEyH04ZAifuIsUTDhX4SUMXBWtKVQio9KMIyO7j+F/ZIhYUaPK4E5DIWHmOULRjSzJX80xQ/ZeyDEeU8yQeHrqSgnefH64D/gwKWMnmH+0DrULj+4aWkZ3aYkdTS5EZlWcxdm9mblUFRLVrFyPlWk8ahjxZ7CpxQk2BuUqzQZc0XYaHqwtND00+HiZJx1v03z3/OJvUMD3YjY3VFUve5R4/k/FOLeHutQcyDEQfsSL/mGeKtZGTEJwcNXE+wpGkVAnAb5Cx5HIOSYB9he5/+MBUfJGMhX/9pPJSXQh24KZavaayhKBrJrIM5FanMKg2To4Y6Rj50Z5kifvdjRcbKAHs8zPjV7FP6C0tDmScCm2+/fWpSM1RH0269fl9fP83V216nSw42JxMwFLpdY8ETweCgU1eY3qsTyk5D3htUDwCgh0blmrMtoylOgvcGPr3fPvLvYlKZS7QKRgljULHflcfyKwWB1EphyP4paNP0KFQyVCPfmbYxv/hVxByNRCtCfDJX1uoBKhPQDBYky+pAic9TlV0fMNguyGBLqkNsX7ItLLNxgE2bTIIiN92Pi0/FIQkXqhQ7QRjum02XDmPvd8L7DEkVPzavKkzs09yeX2yxKn+hY3L0BV6wyZtpVUN+9pU5PWK2F/6p/Md7z+RsgoR8pLrIMyf4lfXFpHWXDhPzIi2z63GSOqJb5JA/J9+yP2szIfxVNITIQjWinAqaqJR3972e+mLQOge9jHfvwj2KvkQUjLB+vjs6BQ8wD5GvcLnQlGd1PrAm5kPw5vRy+dw+iZWDRdXhaEW1tX1W+TV/52xWKrjxH8lO5ZHNBtTFif+uL4xse+rYutmxoKLyAzyI
 g53poQXR
 iklK1/KPcck7ngJwD4xADVOXUfGIPCnSXDwkZkUclDEZb4RNRDrACV4lUNfZBAZ+vi6E/YOXiIEeMGfcWqdMGFXHoadJlh4As9RQa9iZvbmNkMYrXc8fm8U7b/Oc/een3Tvgco2P/nB9u6KlGm9G4K1nfGdTe2YiF3fdaAgv2w4yIGP7K5/OUMRcE5rhhYt9TUJ+b89jrPe2fO4Ihca8fcogEIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 07:49:45PM +0100, Usama Arif wrote:
> 
> 
> > 
> > For this, I am wondering if we should just go ahead and work towards making
> > vmpressure memcg-v1 only unless we foresee a lot of or complex work is needed
> > for that and only then patch 2 makes sense.
> > 
> 
> I think there might be a transition needed? Because vmpressure and PSI
> do not work out to be the same and people might notice a regression with
> increased memory usage or a hit in networking performance and might want to
> opt out? A solution might be to switch socket pressure to PSI while
> keeping vmpressure around gated by a defconfig. And then in a few releases
> remove it completely for cgroup v2 if no one complaints. If we go down that
> path, we would need patch 2 for the medium term.

Yeah the reasoning that PSI is not an exact replacement for vmpressure makes
sense and it will take couple of iterations to transition v2 (networking) away
from vmpressure. Can you please update your commit message with this and about
the midterm or transition plan.

I assume eventually we will just have vmpressure-v1.c file which will be behind
MEMCG_V1 flag, correct?

