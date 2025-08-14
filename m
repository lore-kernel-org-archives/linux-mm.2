Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2C9CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2F89001D9; Thu, 14 Aug 2025 16:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A939001D5; Thu, 14 Aug 2025 16:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7F89001D9; Thu, 14 Aug 2025 16:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC0E9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:11:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6BC51DDDDB
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:11:19 +0000 (UTC)
X-FDA: 83776457478.07.DB4B64B
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 04B4340004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:11:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CyQzAFC7;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqQpJ45auHuyENf7Xrb4hjMMbZo4/kym1zJWi/LJlxc=;
	b=BZh/GyIJlcr6HfiKWY1BeWAMJGorFHN/SXQD+zb4BmM4ORb/YixDo/AX/WOygyffB5yM7q
	yDqePPPDW3LRS0Ru1apZDWzBvTvDt/82oEUdRgCMkJD7jgxaAPna0J3G0BSjo1EQwUQPLr
	xXS8/bbJ0KrlXWLt7D/I/jFirHFi/hs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CyQzAFC7;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202278; a=rsa-sha256;
	cv=none;
	b=5KN1euyKOx1vImY5HFnMQT0fWL9nYZ2bHEcieS40mFHxMXzy9WToqQ1eGDWI2VjRq3jbfS
	mxBBO2U92YXt910a7BnF5KGMO0nQsG5tHnJLYh/PJfA79PkoNLkv25JkqhnwKerVu1B3zV
	YPJRlnndAc48I1rG4LmlGYmpq0V919g=
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e931c71df7aso1367227276.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755202277; x=1755807077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqQpJ45auHuyENf7Xrb4hjMMbZo4/kym1zJWi/LJlxc=;
        b=CyQzAFC7BjWMGh6wAjPq7vU9CKc0iQS3CE80+GoPBSV/1JKMmivJATgxXB7lrfkN0g
         JAI1T4XnQIYICe1SQU8VfPh+9NoxWF2T512mK5+hDiPNZ+1dkddI+agOUyzWx4VNd9ge
         1Iqs5LgB8/jfB992KbKb2DoO/wX+8Bn3q01KYFbhdRWfFCZ2XAB2w3pr7OI6T1+Nmdsp
         q9uQ0s6UigSfU3NzInhGLkOIPSsOk4pR+NgFI/itFSEmzdJ/c06sJ900XtB39dS+DUIy
         gqIsSjwUqb77H+Dyk4g7tqSLnH9GmHXUW74GXFaG3slXxjZHjbTFt9DgIbM+MHruK0L0
         XjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202277; x=1755807077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uqQpJ45auHuyENf7Xrb4hjMMbZo4/kym1zJWi/LJlxc=;
        b=LrkESlelFk3HsCyz70BHaoy7G7BsfWSCOOTVr05pi23SO5oDkcMgAQ/I6GdBdxTtha
         SgjTLe456+gGtbckoTWFM/PGqz6DoD7N3Jk7VzGGeNvd+8TTxIo2kjR7IZXNg3Ny5NiO
         8nOPpzJxPbb/mh1sh6+uzAgkPlZVgjmSOpBOzV6+odw0Y9ynIO8xGCGeD4etApXOHWD/
         ti2MwzxMMbvGYmrbed3x9HbslkhrS25+tDVIOQC0kFdjPzaWKNw4rJ/QivxBye3daPlp
         7xrtfCSm5M/HGz3pO/iRRVL0/E+UAT+nj3obaYfzMEkLmzl1iC7M1UuJVw/lFUuxqHmr
         BYaA==
X-Forwarded-Encrypted: i=1; AJvYcCU1nJc8A9s5bBTuoXwFdz8dwci4B7jpZ3Lnl0KgH1QTRVgMb0Pd24tHKm7vsOISDy5R/bkmEk38MQ==@kvack.org
X-Gm-Message-State: AOJu0YzTAbjGFCngpk3Jj45x4zGPzcJTULh1JM7tJ9JslTYmzLVnE3le
	ilwdnNGsDEPKqmT8uFhgj1kNh3Wdjq4Yjq+1rmTt29PGxB0iNVMNkDa7
X-Gm-Gg: ASbGncuo3VG+Q58TPJDq7xGiDFI3teemU+6rJGjzXlOTtRoIlg77Brcm92xjvA+T4Bh
	WBYpTxx+xOaxDqTxln53HC9PE/bNTYmxc50oqUGYFzDcJG/PKC7U1ydeJNKPGAUPD+fgRP8DzwE
	TnMfg1YRZ5eoZg4PDfi/RCwwaLm5tm2Iy8p0/AVYNcQshAgGhyB2ygjU41XSEbVCQYICGVwTFMK
	0Sy4JzXbtdIkgiqG8n39Dz4ikd9rJuoqmYo4dbca+LDq0bJBESduEzAYZ9MMJfE41H9j1H6wjZn
	eQUSS0XVkWVyW+igxzT1OHt9pzb6aFvUlMfhaUm+lWcbi/723YMzZtQHS8lSLaQ10H6DwNe/xQ4
	CRmxs9NRPzoJy4e20Rwaz
X-Google-Smtp-Source: AGHT+IGZ4r+yBtbQRfO+KcqX023xsx4kj8P3ukZFnSPGCzjXMXe4Xf7eM+FXEVmJxWIT8IPWpDPdRA==
X-Received: by 2002:a05:6902:3485:b0:e8e:1e32:c2ac with SMTP id 3f1490d57ef6-e931e163b31mr5382666276.16.1755202276774;
        Thu, 14 Aug 2025 13:11:16 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e931d447899sm879567276.9.2025.08.14.13.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 13:11:16 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC 1/1] Add memory allocation info for cgroup oom
Date: Thu, 14 Aug 2025 13:11:08 -0700
Message-ID: <20250814201114.1921580-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <790da5ffebf18a5a1211ad8dbe4e5b4a19871408.1755190013.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04B4340004
X-Stat-Signature: g8a3fcje798cyayrjzdzbwfen47teqzc
X-Rspam-User: 
X-HE-Tag: 1755202277-972670
X-HE-Meta: U2FsdGVkX18j853munxsW55cUSK/hn/cCRJXQE0lOaXwFXxIpYcrWOGyJI1JAUI5ZiFHZdn+BeIWSfbhYdCFjZZEYNx6LKp7M6B0l8ywnfR22Rbk7Vwx6GzY8PNLhYRD9Od9FAuuSjmUqSl7wOfegakCl0EYA7tEG2yZKr1Z1JcOLha6V45FDf7d7NYxZrDvlihkJiM4pzOWUyEQ6jojZ/DYWf5ZZKK1RgFTXHjDJECV2JygQ8e+oZzb4NMYUbtaLype94DIMDP4y4cqWaN/5GOQbx1k7YWxTF10aI499tuHOllvQCPGRKfkMNoDiDMvhU4Okc1PIjXWh+RQ4mPY5OsCkyTSAOXTIjgIq4Vo2fthRbG/ngrLcZnX5LgH6dtkltLfDG6/AfyB4udloAzP4Mts6+EEGRQ5RS2fIO498ws1EANv3kHBS6wEWQnfLzJ1mavXXKVEZhJG0gPKIEyuf0z0Tv+DwXykda9gfW8JTY0Sz0bpSm9bIaujLX9A5OvC5mNG9y+Lje7u1RGkQDo+KjVIkb+kukhN66/njncZRYCPF1o7lByGnxVNNuvW7aMv2c5Df4zDVH9cb+HXmbclFX4Z2Bt0Bs+VjIrclyG+TExGeskXe0C3GpA3JRiq2hxQuaE6AZ1cLNAVkKzmD4rH5kaZVhr6LTozY5t/AbepTORIt6BWo6ficycCOWnRlUtCXMvNKglWWugoBqauC0qZlK7hj10tyv4j7/NzLVfl3hUqFvA3WzmHqQAzU5X57X5SqCn1zH4CaVde0Wh2VAWvfcXJcqPouZGc96GSx+4HL9LwFrNoytAfU/4/3dx6jLUlD4HUTmJ1zzmUNLyIxLv1OLsjWFBbZqnEopYZ9vd3JqxAe55KI0/XVblusPhGMSj9Lw3txZ+WB6ATdhPt9hMVhXIv0uo9RLnhJ9XQ6S9B9rnARytHDNDKJRNpWRlbSIdqJoMZSHhsGqi4DH+PaBd
 0HBbfDTO
 LWnum0q44cDtzUP8tktRSGPVFY9m+Pr2Dalx7bRZloPxs5yEwJCKxKNjRe1GUTlv50/HggM5jv3u4KIkYeG6imYwhDkCq7Cb4K1j/X15puiFV1XVzRfmv04MAQWdPy/71jF0uAYQ6Tth4ex4gfgzLc9YNlEapVGI0KLl9XEgu2Lp+oEZQFmX/SjgCXNRVtvcfkmtSoEZs3UsU+Dvp9xdyIIZ8GNETZ9APh3j+KLDD+lGpZ5vRphEKdhge/DGf2LR9uaAyeMLRdeCGZVOQPl+kJ4ysr4HqlAAop1oy3yzbPJxAoSHYVXu/PpSYWyvud5wXZCHXe0GuZQzEPK7v0u2sJnhyzWWQBV0V9vB42QdHRKDQ+GDpA8I85Jsr1kjwYAf3bgz4J5Agvjq1DW+aPrG4tiRK9m2aBfIomGUoEpvTRjKHchkAb0YfZOA4bb9VrOppK7+soriEZVzDysvCyyFbphg/5tdaYE7BdsqUaH672cLnLQlysdtTLXsT4Rq2LZBlykR5KqOJxVK/vta+Cy0QtTLA1H/zBihyiJ+H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 10:11:57 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> Enable show_mem for the cgroup oom case. We will have memory allocation 
> information in such case for the machine.

Hi Pan,

Thank you for your patch! This makes sense to me. As for your concerns from the
cover letter on whether this is too much information: personally I don't think
so, but perhaps other developers will have different opinions?

I just have a few comments / nits.

> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/oom_kill.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 17650f0b516e..3ca224028396 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -465,8 +465,10 @@ static void dump_header(struct oom_control *oc)
>  		pr_warn("COMPACTION is disabled!!!\n");
>  
>  	dump_stack();
> -	if (is_memcg_oom(oc))
> +	if (is_memcg_oom(oc)) {
>  		mem_cgroup_print_oom_meminfo(oc->memcg);
> +		show_mem();

Below, there is a direct call to __show_mem, which limits node and zone
filtering. I am wondering whether it would make sense to also call __show_mem
with the same arguments? show_mem() is just a wrapper around __show_mem with
default parameters (i.e. not filtering out nodes, not filtering out
zones).

If you think this makes sense, we can even take it out of the if-else statement
and call it unconditionally. But this is just my opinion, please feel free to
keep the unfiltered call if you believe that fits better in here.

> +	}

NIT: Should this closing brace be on the same line as the following else
statement, as per the kernel style guide [1]

>  	else {
>  		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
>  		if (should_dump_unreclaim_slab())
> -- 
> 2.47.3

Thanks again Pan, I hope you have a great day!
Joshua

[1] https://docs.kernel.org/process/coding-style.html

Sent using hkml (https://github.com/sjp38/hackermail)

