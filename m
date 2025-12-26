Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9288E8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 19:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9A46B0005; Fri, 26 Dec 2025 14:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D016B0089; Fri, 26 Dec 2025 14:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955516B008A; Fri, 26 Dec 2025 14:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81FC36B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 14:32:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FA4CB7FCB
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 19:32:32 +0000 (UTC)
X-FDA: 84262618944.12.5FECBE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B6A7140013
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 19:32:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sqm7d53k;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766777549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exrylgbBHUfG9Ezs8wURYm14g4G1+zNQOsDbopt4dSY=;
	b=PeMZzbg1ycGnJQ+TSFnTc1JQ4nfW/kXzXsPvTvkm4RJnmmzG67jQQpwC/sd4v7GBVObN9/
	ossiS14ZBeJK7H7rmBCMK640nvV50IvNnd0HVXjaqHCv60YamCguliKGNw0DU8c7on2UKP
	LKrcVxg3MOhjKpQFFH1+Z8oCo01iPXc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sqm7d53k;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766777549; a=rsa-sha256;
	cv=none;
	b=NmLdZGtwcey1qSnbq2964su6iRDytvxyAD29WUC3qnmKt4s6bnOTrgP4YN6CuZ60Opeslt
	bcU1ZLQKKJqjQYkDJbUMOAI5DdFIN0DU7atzs0s1+/5nZMEHieFC+zL/Az6I7Jt7fGVSdS
	mD3tB+MMHEST3FZBnvUjYt+U7UwG9QE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766777548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exrylgbBHUfG9Ezs8wURYm14g4G1+zNQOsDbopt4dSY=;
	b=Sqm7d53kmLVHp6SDbXDIqP41bMS1o2Ww05vO9R2HbV0ghrrovdlokqWwCjE3uvJN7shG1E
	7+a/dn+EkLRXYJfmrh1vMx8OYqYauRxtwvJNdXveyuMndPdVusqGfLgMC9qxogYeDY98gk
	5rn63escA23vNtlabCsCnPmeVxE42+E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-vexmhbjyOEa6FSpXA0OTkg-1; Fri, 26 Dec 2025 14:32:27 -0500
X-MC-Unique: vexmhbjyOEa6FSpXA0OTkg-1
X-Mimecast-MFC-AGG-ID: vexmhbjyOEa6FSpXA0OTkg_1766777547
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee0c1c57bcso271871971cf.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 11:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766777547; x=1767382347;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exrylgbBHUfG9Ezs8wURYm14g4G1+zNQOsDbopt4dSY=;
        b=KVvPjv4YkDPDsHUO+JpNJbt0Ny7H9ky7Vl9XIGdStH5UUVMyccmnusgA5qV8mmnsQa
         YzIINuwvQcVX8FysJhdmrmm9i0wvdYfM3On6eTJWePVg5K9Gx2rNFwQ8pWFE7J5W6PSj
         krrvInYB50gKHPSatTtlfzDAl/YqYJgIonpbQzycBHGn3Q17/fojbAwnI1Elik4lsAxY
         17mx1D0ds6kOrKoVxztYn9BHl7L5Gj8hge5KLV8BIaaUBvethx4B6fu2TEC2tpwQ6piN
         fIXbd2i2/hqX8g6YrVDe/0TliE+PJRNOkPi8f7jW1w5hKT2Qp56YPhwlPPZ65+DS2ilu
         XoqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmQR7erHbSa6syMmpGIy7LJ7BXMEq3p9OZG+psEhJi1jhzyJMct/khC82tYT9p9klL8QKffzIJ1Q==@kvack.org
X-Gm-Message-State: AOJu0YzTXY0IV63UmR6zTXZW04uiZBe5/pw+ZIGWcoOMFcCPGZrAoANS
	//dFm2Vkve1NzSjm6+rE6qjg3vibBkNPPUoHgoyOJhva/VrQryY09AkFvTb+DwQroZ0c+44i5WC
	lnFFpNXQfh3tBs+VYRAKNNozi+Jt+FczeQb8W9cVjovebCUQ7IQuM
X-Gm-Gg: AY/fxX5imCgbgHG2GW3YZYMo6p8K+cs1faarDaMPBS4F897aK2Z34nE1Tv8S4LwtVoU
	7dKxWMgDJoCDICDQUJe9gaVN/J54WintfK3YPpUNlVjYLTjHIvsh12YhqUkQNJmNZ7FhDc5uMjJ
	1/EYeJpfsp8QA44wgR+E8yD6j6y+q9AcOuMLS1t5C18tNom7kZfuF4A096GyenEnNS3C/HUmGgP
	CRB7dEV2WhVzemyfJ02kiIaIfjQ3KRunKb46vAsZmOp2R5JUwsEBor/178ISs12pxe41y1SoXrX
	IEwhv9kDn1zNTs/KP4/F5HOkV/69rGakGTOwcullSxiAcVKAVwBdVMD+Y4PHxrHaa1kMsLT2ifr
	cqx6rriRs0Mr4B5bUByRwAZwguEGPyTDXe99nD+Yb0WQW4nhGbUFf2xi+
X-Received: by 2002:ac8:7f92:0:b0:4ee:24e8:c9ae with SMTP id d75a77b69052e-4f4abd80862mr370555311cf.53.1766777547176;
        Fri, 26 Dec 2025 11:32:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrrgKjEllT+0HCpBK+Top+NtVALAkZu7cvx+lq0ZkwXiENCiRd2VvX3Yv+fGt1maICEZ/q4g==
X-Received: by 2002:ac8:7f92:0:b0:4ee:24e8:c9ae with SMTP id d75a77b69052e-4f4abd80862mr370555061cf.53.1766777546776;
        Fri, 26 Dec 2025 11:32:26 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d997aeff4sm186021866d6.29.2025.12.26.11.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 11:32:26 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <24a480ec-c7b3-4e0d-9895-f9c2ad88dc47@redhat.com>
Date: Fri, 26 Dec 2025 14:32:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 gourry@gourry.net, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 tj@kernel.org, mkoutny@suse.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, chenridong@huaweicloud.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TbNXDWpIXSm166BRVEHaam14u4Qzn3-pCF8MUSobKFc_1766777547
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B6A7140013
X-Stat-Signature: u9dcjzsy96c6jxnpfczi778hzngqdjcb
X-Rspam-User: 
X-HE-Tag: 1766777549-289944
X-HE-Meta: U2FsdGVkX19xuVCfGMhaas6auQ16RziAY+N9uUJln12V96B2mem3VNfbiw6nSKTbHcJRHcwpEteXMi/WuyXBl6sApN74o4jdHUN0NfeQHrawOMoATRs82PYPY+tTc0n74xISLSvS013KiCj5FKbLd6ZfwG7b6gCXkvcbR/pGmwo3plIgPHTyScchkfoVywZQQ38f5Ytx6hc4fQDRBqPJHI7cL+WROshKbGiozsKVsdUTpz+s2VBGGP4VilmAHtPng4gD/ED5iSHsPWQiZCU0gMVG6bKL7R9JqrmQSJnf7bdADNEFD+xLONbbMj052Gf0fP3ZlBWmFsAQqH8KhbzGU/YY3ZUmKZyqGiDvHxTf9PThvwnfIcuYEbFmPB6y02nRrTSyS8qdpSjXHlDi2Zv4DfHdro84jjDCP1bt9s2Tcn/RIU0BOHCpx9MdP5MRvuJqOD5cot9cyxdcSUDmB3QPAmAX4y6i8TEs/8Jc3s6/XpSSsc9AIjOyYqSC8WUBXdA/d62PzHpNzzPXpLTZsXFRWTLZzY1mRIv+eG1Xig7krgwW3nlyLs0wIgF7qelIZPmbJbfW7Z0ME/BAMzFocbrWnCW+1YMmehb1Lrf6zoBWpLvtIDn57xK9hBq3bGJ/dmO8vW9LiY+ZYSWPcfCz7BRrhPpvjso6CJiDI3byHzmbFY4lBLPoF2CH8Dy68Nywh0oPJX1/T6DYKjBW4B2ucHKFSddw5Yq1h1h/CkXrXD89hZeDdQmC6a4BF3PERNFmxRAUdqxbUWj2lOJbHylqGZ/F4hq6JkDuD6kmdBU37wRrS+07z1/W5r02PfYAnc2pRWGx6HnSO5Ap4nvE4bFV04u3cJGPhPdTetyS1AEz0yeIGxnASjjUR2buHIy0OTSwtq1FFxNyA4F1QPCH3FpnV/tgPjbADlIlaX8uGJ8KyHeW0/mBq8goqsKc2wFKlQk7vpv1Ax9q2ZvyxzKiFffQtvE
 MDktl57/
 BKVP1qg1dXuvpouznxbetURsyZwO+V03kwfQl7vXHrCamleTsGhra+ppn6cupixnqwRDLmWrJCg6G1p1ClWrtpu4zxff65thoXZE4vgtATV1DvmuqDfBom2qQ1t/O84+zvsronmsIIjYutuzQUWYpdvxEg2l1RoY+F52fGClFPljM1M8+4PSHa0rCO1L4a0V8KJZOZTsu6S8bxkIX56JP7cGtoyFJyDJGQkG8nG1MHAStvmnxRUL0qtIZxY5rSYIpq+CJv9Om/PuuGKc/r2/uUOES6tVkqWOWS74l5fUMlRBI1B7hxmzbbqEBWbjPqZ6gXzuCd8VqS4DhgCdzTtXXEuPqW6gL7yy8vFAD9Ik2Sk0ksPGURsBIDldq0nxUazzHYcjKWxoIy4dC/zbzguxeGw4+KU6Si6xGY3Zn0zRjS+FindEUoTjr3wb46pqOagFp9j17RaqaRU2EgagxB5Ll5dPA7XBqj2zkxnw1csfUfimCYrsS4znNxTvF3KqJPTw2dWDPzkYvWMQloMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/23/25 4:19 PM, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.
>
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However:
>
>    1. It does not apply this check in demote_folio_list(), which leads
>       to situations where pages are demoted to nodes that are
>       explicitly excluded from the task's cpuset.mems.
>
>    2. It checks only the nodes in the immediate next demotion hierarchy
>       and does not check all allowed demotion targets in can_demote().
>       This can cause pages to never be demoted if the nodes in the next
>       demotion hierarchy are not set in mems_effective.
>
> These bugs break resource isolation provided by cpuset.mems.
> This is visible from userspace because pages can either fail to be
> demoted entirely or are demoted to nodes that are not allowed
> in multi-tier memory systems.
>
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets. Also update can_demote()
> and demote_folio_list() accordingly.
>
> Reproduct Bug 1:

"Reproduct" is not an English word. Use either "Reproduce" or 
"Reproduction".

Cheers,
Longman


