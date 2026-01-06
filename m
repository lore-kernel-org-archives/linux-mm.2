Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D9FC47BFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CD46B008A; Tue,  6 Jan 2026 09:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6008D6B0093; Tue,  6 Jan 2026 09:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8706B0095; Tue,  6 Jan 2026 09:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39F916B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:24:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5F791380FE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:24:13 +0000 (UTC)
X-FDA: 84301758786.16.3ADA407
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC8C1180007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:24:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OEnKdqgo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767709452; a=rsa-sha256;
	cv=none;
	b=o7KNXqlkhN/VJloiCh+9o/xWFdhO96YEMdoemHme6jq3Lw2Q6FyrE/gClbEwHQarRoebR5
	2fVMpjzrd/HZ4zJs23ueNivrFLlTtrW7aG3HcL7M0tLup0LoLwRkVz2GLYkvkmfqqr9js7
	sxq09Gj/mTQzd20OLSagncLCh8x0WWE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=OEnKdqgo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767709452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKFtmrwYJffjJ5vAfa993qtRrR2MOeXl2weKUw1hfgg=;
	b=zFJKqd1JUPO9wpKcmLfaLaNLOROTGQIsXf73GCY+eIFgxlHoyJ9y5lucsOvPk1YNDkuWsp
	B4JfGGwPp/uk2yQQS3g6bXz4jxPN2CK46fk5Hqk0Y1CnaH8Z3K7qIKp26ZCjzs7QU12GgH
	VbmSnABvEE70pVYJTmw0BWbFcSG/4RI=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8bb6a27d407so84673185a.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 06:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767709451; x=1768314251; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gKFtmrwYJffjJ5vAfa993qtRrR2MOeXl2weKUw1hfgg=;
        b=OEnKdqgoxAXxo/OE9QtxnM/TwiY9GzVlw8oR6FPsskbfNo7olWjVEqI8fpVLJQXh8z
         CFM8mwv9inOb1OCQ+5l0heaV/dmhfqTlo8gUsaSvHrvwk82huIx1NLWtT29g98DrXbi3
         yHwUiuAvEpT62gtmeLUwKVpiqkaY43grdYpljcllwRGakMWIqphsopewNVghHsg8kj4Y
         WSzE2BAGJnInu71BKvj7RRgEvS+ipj+mgAcbIBlLvs1+dXTjoMTvDXcczZ0MwjsW9yiM
         XY3/cUHEDDOQeZtN/J+NfdADF7yZyUgGvbfxlTYYS18x6ycPfynUT+//N11tYjpTGNsm
         sVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767709451; x=1768314251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKFtmrwYJffjJ5vAfa993qtRrR2MOeXl2weKUw1hfgg=;
        b=BVFwWd/4NVfFJI3o039ioIm798Trnupy4f2Vvsnq2qq/9pbznSPf8NKxV1p9Yz6euS
         sSSP6JvV0KDrACkHqmfXhWKKRaYyoNm8bhi1NWgt/3JYawq2gSM5xuP5K7HPCzxEAM2d
         k0gcAhYTPb6q3iWFrEjPoxdd6LmMoKiXR9AvKgvVClUdKFWSSsmhd7DMaFAlgHKVGSr2
         8znTZf+UoSMrVNT8tInnZjydwXg8rAgwYPKE4pO8vCgBbDKjiwygr5AGioIfUUaZEFRE
         RzkEqFIuy54Ia3EIRFnRavq5iCmYvSlh3XOGIK9Iemk5gQlDResCOYxX6F1diDFKKYpi
         RAPw==
X-Gm-Message-State: AOJu0YxP2TQznWZzWzQ6Zysfrcc1socf9QQLL6ys3T0IQntW5wrJXuif
	W8/fbzP21i6X4wg8SMl9b0m6jofH13SHbfat123rEJCjd7Psk/xb9/A7ix8LEXGMz7I=
X-Gm-Gg: AY/fxX4s2XsLP5yUcSoXR4M8NsUNecn63fEy9CJSLG6RDg5T3O5xp+b8K3kJfHAEbY4
	NhSPNqVN8i2AuMFwSlwOuNKTihgRqozpvTeQmYwQT+rPZvn3M3K9K8SH/Jo8ozRxgX4EUtMwdcO
	g/STvCel1X9e7xPDTGIIeStBILa6spVcaWwGzM9wClZ9CQ09phfXDcxA3mzt3MgDmVLUNjMjh3d
	NFdvvIBEUjByxqS0UrIHfpeLwoC94FwhMObHX9eWN90ZTf9jbQWnIz+drEa/+ipEdz1mg1FqTS9
	o3JNfDWg2oAhtNmVrE+h8d4+1ZtwF686f7JcZBmeFzdPwYKRVGdudLGErXUuWSXZITNHkbp57f2
	M24RmcD4NHXeNw+zz1hxKvIngh4ZwjcBtA6CDE/UICdndWIwge9zshYjX0OwfsDnUxHl5rzTF0V
	P2BGZ+flNy1AlNIO/h/V7hnZTn3HPa0gjgoix76kInr/Nn38rRCx2GLC7iMySgzeA0dSLQ8Q==
X-Google-Smtp-Source: AGHT+IGMO4IFrkX9A1M1kgyKKyomZ/Tm009TfQhyVAXfXHBjJcxasAIany0LY092XpBTY+2rtwysZA==
X-Received: by 2002:a05:620a:4808:b0:8b2:e3d1:f7e0 with SMTP id af79cd13be357-8c37ead0b5cmr435049585a.0.1767709449546;
        Tue, 06 Jan 2026 06:24:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4b917dsm178740585a.17.2026.01.06.06.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:24:09 -0800 (PST)
Date: Tue, 6 Jan 2026 09:23:34 -0500
From: Gregory Price <gourry@gourry.net>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v6] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aV0a5pYLNV61WJGk@gourry-fedora-PF4VCD3F>
References: <20260105050203.328095-1-bingjiao@google.com>
 <20260106075703.1420072-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075703.1420072-1-bingjiao@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC8C1180007
X-Stat-Signature: wddxkjkaj56ks5s5pi6bf9fzb9m3dw16
X-Rspam-User: 
X-HE-Tag: 1767709451-978835
X-HE-Meta: U2FsdGVkX19kDwQz2bNejN82xhDr7zu+YJBcYiXzJjMqYSlqhdJTw1p6T68HbhhU+dL/4eNe1Uej1MACXR6QyLy381Mr0jMzgk1tsBbYhL6OLWX/Fjfn7ECceoZJuvxe41oK1pAIx4wEt8IACg6YOKvxxxV1LBNRbsFO19fuyz0dmCSrtbX1TQH+p/5mkR0pLDPyHyHXHOASbDyfoAFBi6kDGGpzCAayMZrnmr8J+iXVEL7LO6mGAl1DauteZl6LyU3TQrf6qT3x5xeYMxrFqDChFY899MFB8MIz++Sd13ofZuEdjWRFzj9+4nJ5cGl4HM1NsoX6t8F6GiWJtIT1yuviwEnLp+gmOYQStLwQNh9uX9xYMq/Q+30/YhjiPOQpFxdWyfp9tEK/FKQ2rj/IbP7pCjFWi3d8Kqu5Z77bRadzMLAotkKlmrGTFTwkqJSEQ6o5l/SmfDkYbCesI/fbxYvgTh3Snk/81jTnFNwMbcaPV/yqmL1GBAEgmV818He8Q0FurMkMTj19UlNiOItI6hWsJ5uSr99GMKqPeclh2pWxFE/jlMKo7i7VDf5uarYdVEYWNecyGDI6iE6eQuBSeHaKV0Brqre2TZN3mXjuHDmPrsPmT0XxEYOgYoBHMDZH5byUpyiHb25pLzj77BDnvu6FSfBNn2hpTsWHWxjDmbBVrGq+OuvDQvxBmn1bMqsNL2+Dt+XkQlFRuiz09to1d7HDTviQgaY91x+B9Y4CeM30xjws017lkPUo3gg7yVTtQwvVO6tV1aVRM/n+ZJ9uT3LSBmD3po6trzmR7t5GjPoL4MuJOMe50DxmyI2BOFA4ufOOgNXQv9lQ43n6XCcHRJcnl7q7FJ0myum8rNoSBRbRzhZCUyqVhTv/nlLv5ZXJZYkiZoKklyJuKOpJb3Mb/cgWRIqQ1/S/Hide1uC7LdASiRQFVlggQHYkO69Bx+mh7NMpO/K0EZFb23hITkf
 S3VjU6Ga
 5RVdfkdqe/koetTWX6GMvtfYTXIR2qHvPUM/S9oWnl78iF5iLfISqtaGrS1TPVHtwVK0FLaXnuCnBnFA7rKubrxTKB4d9437LO1moKAA63N1+Wnbn4qPhTf3kxQZ3SLGrKokgzIyvN67nJUBymbHY704Tmi5kcMTsC3Qfc5KVAmuPWbPyE8gxZCUUV6/esBahR3cvo1FEt1m/ZEvODiiai4mQEwZyHXNuc4Co4/nOD6nl6V1d4/UBWd+3ruADdxrznpkFK/HzSZA5rcLY5cPTYJewCXseC8g8Ap3M6ELgqgUyxLtG/iZ5ZlSwD8kdoSTA92VdNg4Cxr70MaQorGMneESlsxzbnwrlbzvB0epJETEvFCP7VfP/UWKAMy6AzDdpUnNCRFBRX9uV6w1CqkIJVaxcAxMg13NEC5WdxGk5iI3HU2hQ6PxUHn99+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 07:56:54AM +0000, Bing Jiao wrote:
> 
> Bug 1 reproduction:
>   Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>   nodes 2-3 are far-tier memory. All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Should respect node 0-2 limit.
>     # Observation: Node 3 shows significant allocation (MemFree drops)
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
> 
> Bug 2 reproduction:
>   Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>   node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>   All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Pages are demoted to Nodes 4-5
>     # Observation: No pages are demoted before oom.
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bing Jiao <bingjiao@google.com>

This looks ok now, haven't tested it myself yet, but looks good.

Thank you for the fix.

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

