Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BCFCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A5F8E0007; Fri, 26 Sep 2025 10:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B078E0001; Fri, 26 Sep 2025 10:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860B48E0007; Fri, 26 Sep 2025 10:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70CB78E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:54:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D7DF11AA92
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:54:58 +0000 (UTC)
X-FDA: 83931698676.30.61C9E6A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CA5D1C0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:54:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dBtvT3kZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758898496; a=rsa-sha256;
	cv=none;
	b=SukZJndAHymVWLbNBBTWkjMg8PU8z/b+VvLa7qPltwxaFUXLjGTEoPplfX5BmzBpz3qAfZ
	Qt2SlirvG9n0TqBHEZCZfOyfWrEk9/L+x2zuSHekMt7MOi4b5HhU9dX7tgri4teVYAJixj
	CihDg8jHP3iylTOEOseVBYpU6/W2Jjs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dBtvT3kZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758898496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY05iPvOa2qw1XDOJIPHyncKPIyxi1vtKF/LrunZtR4=;
	b=dTwzJTUEV8C7YlgCD6HcE/7APQEwZ78WiizMYYFltS9L8Byh0SLecNPDyly4qu3T5XsYt2
	q8SJlxPKoXbrUI1Vg1xe5FrVLq46En+0ruu2iaT0zwFIKqGX+GOVcnMcMf81G6mKHJUuyg
	MzPZAjM6YxeheTh87yHjihMDBaJxNWc=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e1cc6299cso22143025e9.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758898494; x=1759503294; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BY05iPvOa2qw1XDOJIPHyncKPIyxi1vtKF/LrunZtR4=;
        b=dBtvT3kZr37LUjpt7LRsuvgjSC0gGWo9EGS5TWil1kBGiUmvuhXE/kVdIYsvHPiBmc
         6Ob49Jq3J+7atXHr+3fLXiP6V2pd2FfFqPUcO69L3EZMVLFAZj/aIbCV8KndYfEYsMxE
         +90bVkLOQADkE4c6dkZAabdPKvePYL/cw83NDcgztNbSMwUaxa/nnBV3w7PhmA3IQj7y
         wIol0HnuRjDTo8pbCni15nZWz4jD3XZ1qIe6+Z0Z1rgcOFnP28okWBBQcHl2dWoU28a7
         wFZOXjFMkVOF7kV79Vy+mR9f0jHsg+GiC9rlvRoeV8FqNPgnsorEivfS3UqrJWOICv5l
         SXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758898494; x=1759503294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BY05iPvOa2qw1XDOJIPHyncKPIyxi1vtKF/LrunZtR4=;
        b=emY76plTBr7VIDU8/XSrdg0ZBwdSHt6h6z9cvajRleckhc06ml/RYkudBTEvOrau2w
         c+hHP8N3x55D4y6T2eSOF5kIgzd85iHWiBoUClxESseOIzJqztVl+ZdGqPkbaXSK4Wdy
         pGUBczTvl1/ZenSwIyTQ1gdbQgy0M7qQyzKsfpvGQWFG8/OXLWqBa3UpdgQLSboffGJ1
         5dT5WM8FP6hZBVvWnTuW64gRH5r4rhBBqUWaonP40ZgJWHhJfNUs6TQMGmvgFmSBk0iG
         Xml5ZhLam9eJ0ecpBICl4wQ21CYJc0jPTzxCg4zs/H3Wry/+kAlQixvKVhBAbiXr3ExF
         TMzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyiS4hRyLd9CVrGu5/SON7GXRYOuNZL2Zqe2bBZ1IynVLcvmvEjqaABRh9Z832aSh5YG5QTAr3+Q==@kvack.org
X-Gm-Message-State: AOJu0YzL/nvI8VYIrfnNWKjKIM56wz5Mc7neiPz0f7IAPqhyCfAI3PQD
	vKMGjYVTbgvPG8OUfsd+SyT7GuFhwZdZ4JltWYEHeoCY8T/wdIy1lxa2
X-Gm-Gg: ASbGncvQ6rxpb/uxa3MN9V9aDFY2+DQxn556Vjm7zDFqcKv7XsohLOB9MEB0AdtPXoq
	Dkrj1/y+rrT9pVNKSjOtnh/TO3aMnW9CX+aKkVZVhCWEpaKx2GsWjVKgFLKqlTrD155/CGFxCla
	Znk6/Y6ZOlhqZQdzVr/F4oXVi6iJkWp/YLcHusF4/CrdvwXDJnYiwIbG6Zsc01FbNwHBclyoyAn
	ylnZw39u+8VhIJIUGbaK0jCz5gnOZHRHMOtYjCy9qDWHTYGrPDqIJ0BhZ2R01YX7ABprW4EbBhi
	JXMBXpAWDVjO8EF5uYfS68dTBQSdTe0tyUXsnHbhh+jj8x8ztXpSaHwlEi18ZqRVyNqQT6wdpHU
	gCZ1QJzmJmkeKX8F6DtslCCJI6OQDJmSmb3pjDsnld/trNqFKHkvdei3HO5hWZKaxJb2mHOkCc+
	p/ek8bCTY7JCvBOhDLZc0arISsFvRUvzvhRA==
X-Google-Smtp-Source: AGHT+IH6XAUFoxCMg08arme1K9l+Tyhl3fwi9t5NToKIciERmlCjEeowzXgbzR1NtvHV+IE4Iod1mg==
X-Received: by 2002:a05:600c:3b10:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-46e3299a5aamr71003245e9.7.1758898494406;
        Fri, 26 Sep 2025 07:54:54 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm119224235e9.13.2025.09.26.07.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 07:54:53 -0700 (PDT)
Message-ID: <4b8817a4-5b17-4fa1-bc07-1808b495b8b8@gmail.com>
Date: Fri, 26 Sep 2025 15:54:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 03/12] mm: thp: remove vm_flags parameter from
 thp_vma_allowable_order()
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-4-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-4-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CA5D1C0004
X-Stat-Signature: 7o1xhck5owadpoccibd1ede6s7d119zk
X-Rspam-User: 
X-HE-Tag: 1758898495-400010
X-HE-Meta: U2FsdGVkX19oQI8RIt4NOOQC8IFkTYOPGuPOX58el588k6rEk2yo5Ls81MBOxgg9tgZmINT1UVwm6FvNqUNR6MGV7n2mLztiTx9CvNHB7Y5XRmLu3d5oAtPNj8EMmE1SuYuc63Ij3iBOMQ2iNpYec8v3fLIPbshjmOq3eq2cRkAaJr7Ew4d8fQReIh4mZamfnCKtQb5ruBScN/FmvPIDeC1b/1ywVsdgRzr+L9n+fzZ9dHbRhCatqgReI9VpMkMyBq9c1lx45+eK90GA7ojSAXMtTFcWSCixLtkfTVcVe8r/EF/UEiys36qKH6tY0187qEZ+BccM0WVbb0Pb6pkjO9CTkACvcjdeD6sUEM9u6WKfjlPGNmD4HR+c9FofjpqIKpanX5ruf2bsBhJh84hWp+Wnol0FIimNzAl5MPC4l9BcIdhKXG227fAvZaQTqt23xp57eYKFjss4LBzj68qf9kxgPRx1oszepqnj10rifEc5VE2V/4m+1qoOmnhv9Zkvx0jUjLE31YSKiG+SWGmesCkE0/KC/XzvrDZtqsNj5mCTChIDWXOFfhRzvtZeyh2BPb97uyqxzEAfIcIIFXPdMYXxS5zNeucaPJFDRovvFAeXKLs8of2WnEwpfmg4bnQGjTHtVICDCb/1bA5kzdFG7HMGbsB13n2NPiUn2ILXWwi4E0AosSXM8aTtHT+iAHAupHichLxLABpdbM9hKIwxXgRL/Syklv33FoylPSONOBf4QMr2+RTgDe534f41sLlBx62W32zv0viIW7uStiL+GwU3fcFYHWXoUtzUi8r4/vMlPOnk/0BJPJWwZLS6ODWOLQzv1H4WkcBODDZYsZVI6INVFXxaGnCp+KPUY3cwr2ugqd1BpH7cYYYW16FTzt6bPh7sukwdvbouisv9UAhFtYzYg+ZsRgq/onowKrHMw5RJpSi9IIR9GTSrvD5Hdj139yXBvxgMO3sIEZPVrGL
 GRERbdYI
 f7KQT6u2ZrTrr1sQ0KYVQZcfRiJ8VWyJ8n2EyStaHJI5W1NpIGB/kwe2kAkI33KcujzcI7G3s1K+GVSpmXBxBtW+Ws+8o4nWd2iUvbFg/JEkZTcb2BmJnSVfvf9wxcAEX/5NaClZ6/+E5JRkXMYutaJ2jOmZjgkIw6mssNj8aGupqRyHUMkXJNw1uMvg/jTdCYQ6Cxx84neXEwFz3szs8ckV/UaCqwAg9QNIDF3THVWDmRVXgFL3ev/dmtPJjG9P+M02nCzUrVRNtt52bdSHkhCyIvhnHPiYa4aEvk0SxlQPK/OHwLFKkMJYDhR2vZHk/jWSe+6r/BeKmwgPPTJo+mnG7z38J+GLZfB7vDOIax7Fx4XXfBhWKNa0yKdwDeN5jwlMwccyWzZ2qxCxC0i6RTn+NPrtUJ9IlNLPGpioGEszcILxwh1lzCWaPbrL7L7sDZTgQ+DV1u+k6ZBxZ/WQ7rioO+Zpx0V8mrRchhJ247TeJB9fRCQw2tqd9Ndw1tGK2QvTQtqv0GWUfoC4AOffnO9Moscu9tb91kBHqwJmPNE7ENIpB4YXcM6/LCvZNPjpnOJANTcjetzwQoIimy6T5lXQbZ+KWmf/LYnspLSoQIu2GrMdHuy7tGOTPuKHP+jz6TArL3aLMAIoRanY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> Because all calls to thp_vma_allowable_order() pass vma->vm_flags as the
> vma_flags argument, we can remove the parameter and have the function
> access vma->vm_flags directly.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  fs/proc/task_mmu.c      |  3 +--
>  include/linux/huge_mm.h | 16 ++++++++--------
>  mm/huge_memory.c        |  4 ++--
>  mm/khugepaged.c         | 10 +++++-----
>  mm/memory.c             | 11 +++++------
>  mm/shmem.c              |  2 +-
>  6 files changed, 22 insertions(+), 24 deletions(-)
> 

Acked-by: Usama Arif <usamaarif642@gmail.com>

