Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12DBC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DF66B0093; Mon, 14 Sep 2026 13:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94EE46B0095; Mon, 14 Sep 2026 13:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E8F6B0096; Mon, 14 Sep 2026 13:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 524316B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:10:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5C021A01B4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:10:43 +0000 (UTC)
X-FDA: 85213007166.28.C93D4C6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C54A40004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:10:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDgqOjNB;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789405842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s10O26OyymXqv9mIGwISr+cwCeJfHQLeL7WGGnIH+sE=;
	b=SeYzQhbFvdg/39oLsWjORfxlOA2DFbgxUSgMwHpVfUWdUYGYF6XGy1jeKgKdUBHmsZ3ZVY
	hSy0u6oUFXKO6/Ouzuhp0lxh7bbM8y82hgwT0Tlwi4yklXu3sYhjuUSZqyps8gkmXIsoxG
	tfItWPA3QHUEPen2y79WC91fvoOKVZY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDgqOjNB;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789405842;
	b=ZWO6hB7Rd8fUvkpoRrq/uwR3ikgH9BDICaUjMdHmUVENZU5tOqL4P5W3hIX9EHocuRxVla
	sVCsRUwVxChxy+1tYEXVxbIv3/ANYTOV8gSEs9w7HA3Hf0GGlGx9UIZh67VcaYWLUUIWr1
	NZsXIJNi0fLeXRd+XfmQTOLZn9Fe0fg=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso5018816a12.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789405840; x=1790010640; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s10O26OyymXqv9mIGwISr+cwCeJfHQLeL7WGGnIH+sE=;
        b=qDgqOjNB8O5Ri4kEI2sbqWvkSbxmM4nYM22ADFifuPdwR6zpbBuTwBimmSRk+rymts
         mpkZ6DW4MsB6N5kCtzl3B2hpImKhIr0awWS1CeMMg8A3bIrQJp+NMW7t132rg+9Uz7nQ
         ZzKXbFYR/wi+5+XRC3zKcsK0fXIRpTnUNAzcLcT/PoqN4sE59fxAq5gXg/fr2exv5P2P
         nYaEzPUDNMfeuTnGmNuYil2xWNhAa1gnB7Mx2HPfH/YelAu3GTFJc/aA0EeZ9X7N+zj4
         saTV+TloIN0x16mnTEoJgcJDOIYXOMk83ifGph6Ma0mnho/t+i3UJ2Ij57WiFkDik/Bw
         2BPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789405840; x=1790010640;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s10O26OyymXqv9mIGwISr+cwCeJfHQLeL7WGGnIH+sE=;
        b=yt/vXqxNkqHAP2lLlMamfSr0FTxnHud9zMKbJxz4FBHKmKz7Rx8DjH5UCEexQcmQM5
         CPfEwHetCebGan7Kv18ZZJ8bNJtao/9Px1vQ4Omxw4oxKVXKUHwgat5li4meU+qIy0I1
         nH44o5CTShOq9hrrMwYOyTWXQoc1nJuMqdhh+oqLVaCcUAS/Ygjk5nNIpJqValRK3EKh
         VcPnnfXA2PxVXeg39y0hI32vZi7U5C2DwMNXGT0o9KZnHRzVbNuyP6heDzTrGzC5yngT
         xDCIdJbd5asFJ0Adm0W3dX4NsOfNTk4FBPmGAQi1QDz0PP31PuXTZzuJOrmfj7qcs2cF
         cp/Q==
X-Forwarded-Encrypted: i=1; AKwUvByj5KA2D1HG9SYdFt568nGBl6XwV5egRnmHNqCWCAt7uQau5KZDpc70Q2yt+Zgjf1ekxRLLjuGMaA==@kvack.org
X-Gm-Message-State: AFuF++lG6iIOXJvh130I0LoEtOs0xBdqlBU30a1Q2UrkPKdzm1WKPfdJ
	BOrQXRE/a4Srh2By8w0nDTRLl87ZWNARW7bK0OtXiqSPxy1JdJhf6QzH
X-Gm-Gg: AYBFou0k4cCDOE0CzQYaHFoDxegovDNW6xGSt9djiHWedGlNU9YDUl879ugKmnIOaMK
	skzcTszQ4ia05n6D3XtpeB/WeiDGkrlE6ls5AHyQ2/dhOh+xJWx/j/JLbY4zP2LmvB5azmQwLIt
	F1xHKV0Z2NWjy2oFQ8uSI47F/YriFY/ufCZtmT9iQ6R1/qym/iWw7+pYLcdJk49sptCKSUtv1+y
	TyY4zwcHmN9EYYYj+8lZkvkxa4Dt/PmAalZspy5YCQ+ivNKhi0utMjIw3anq19LICPh2PToGM3M
	kt9F4eUdEG+U7gWQZwFI8Or5Vzl3ploqXAA+nimq4RxWlNI9Vt9K60doqh9lsecNXQNv7LwcVnH
	vCLGAjtbZx/eq63j4XsOKqq9f6YETDCxj8rzTxEeX/fYoaKLYjcHHp3l3RyhycBXMQFohS2gWJb
	qPnT6UUJLhX5fnykrPkdU6Q8F4NYlmEtcnbIcA
X-Received: by 2002:a05:6402:4615:b0:6a6:4004:4ae6 with SMTP id 4fb4d7f45d1cf-6a9f62132bcmr2007106a12.5.1789405840183;
        Mon, 14 Sep 2026 10:10:40 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b5920f4asm4474021a12.16.2026.09.14.10.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 10:10:39 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 14 Sep 2026 19:10:37 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
Message-ID: <aqgqjRJ8qpYmx04v@milan>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C54A40004
X-Stat-Signature: wmghw4f3j933xrw9zhuq1t7d8ztatacw
X-Rspam-User: 
X-HE-Tag: 1789405841-889565
X-HE-Meta: U2FsdGVkX1/gcKp1rip/AavlkqV2M+il0VXkog4fmLfGbnC4P3F5Po3s2qAy3ReC//v5YwDBIQi7lR6eKJleJcpDT0ydSYhwhHUlFjk2QPByt5DVah2UQP0miqnPhNMF3yiYIS2/Vn/vOYSP2iisRQ+VY304dSZPejK6sDPABiwQtwFKd6bDOqRNYEbcKekisPPI+k2QtfiThwizLbTOCiCtph6ngN0cLur1aCpU768WznZeqLo5d8TZy3O8Th460IBwwc3X/TAVC/EC8euxVZulpecQFA6EvZjv37ZJzsrY+pPrUtIdmHDEaMt/Tbkv9lGW7xZONTMt/jNKHPWIeAAZ12a0TfB4qdwlnSBwLmgR9sqtwORk+c4Y09m1Te+7l/LR7A6M4fzkLhYH7L9mON61vt5hbpAgFeBWrbAFr8qxj0ms6Asm8kE4bqhtqyJ7yOfq3DVsU9c0XCClzhZwbgdvqhR4l+85tO/RTnldS78jddw4IDkjyhfTr6PZnUf4aT/0W722iLbQ8C85ysy6bzmrLK2GskSo2pvmCwBDvlFqZHORKDKPjSi3wpAwpL7JsygPFxJa6WnmNuTkWMbrMPx+pPZKRg4p2Ig0PFHQmFs+mBUWhPMCvf5X3Tss8Wzi7mo9BxKy6MbRlCMB6nf/ePnKwMFYrcREP+FMWee8oHgZPIpriLidiBbyDZN+5XPF3zcyoVV/XGkeNsbmasr4/lFu8zvR7T6+fpDidosVxIamqRxzRUTp6Om/KVgP0LM8Ev/ZsJ3fqN812KaLOMMZif3a2543qR+QPkIKpNf/5XEA7Chlq+bPVkrMMJ5U42AdJX+QwYPwj173uwmyzG2V5KWIR20cPFtZL8VtRKfB23oesqyIaL/omlLviLPpEK+lVq+V8syP43a3KqCgzJnGGRpVsAtl9+QmLPjCPbjzReDBy+fpxRwiInE6BgoCfgswIVhEJUa3BzKGdKen39Q
 joYPwcWF
 hiljRznFdI86dss/n4IcSvzund/8rRbQKRtzqsItyTtFg7NSB1pUJ+cCYrUqWC5DslTxyf7F8tvlnlLHw6ZzcGWcPQdbkHLD/54+nSkLV5VWzNGpqVqQCaMsAkPKG5SBxEDXGXrziRacJl50L15l44gbR/MxO64FJBoDd+iGPYGm7oszvdXolSDRTQrfl7LMN5V1GF6sOjM3A2fWQ9uiAYzdVZir/hPe3o7V9cU7BnKyaSaFiSV2eXCo/yq0zrdkgbR09Q9BN/D1BPfkht4Qafkndq2DhEUaeTJvc/zWg6OamESrqH7mPX1KSKXC37xprUEcheTsFYglar8a2oSoFGVoQQO27EuBaQdKdfD/Smg/gs/mJXw87pOSti9dJpvqvZ8OgFJKZ/gGpalaz7NQbXRxZ2Xt9tA6POVG2i1P7BCdm++sxVqARN6b+35/BCHKCXXNNsoFbHsoebkDaIzrgp/1DnkzTBHv7FkwCRGawCWMZfoAkOjm6HCe4Pag/YpCurqcA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:34:02AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Extract the busy vmap area iteration into show_busy_info, mirroring
> the existing show_purge_info pattern.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 797933ba9451..7638845377f5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
>  	}
>  }
>  
> -static int vmalloc_info_show(struct seq_file *m, void *p)
> +static void show_busy_info(struct seq_file *m)
>  {
>  	struct vmap_node *vn;
>  	struct vmap_area *va;
>  	struct vm_struct *v;
> -	unsigned int *counters;
> +	unsigned int *counters = NULL;
>
Is setting counters setting to NULL odd here?

Other than that, LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

