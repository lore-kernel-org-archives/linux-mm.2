Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0DFBC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776066B0088; Fri,  4 Sep 2026 14:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726436B008A; Fri,  4 Sep 2026 14:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617286B008C; Fri,  4 Sep 2026 14:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1F76B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:37:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B23871201B7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:37:13 +0000 (UTC)
X-FDA: 85176937146.01.BE9BC18
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 951F320008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:37:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=C+3s+b+7;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788547031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYrVETvRvxY5BVpkhPjtzdiUc0wbZQ7Wsx0WTj7855w=;
	b=PtkbxXAd+ms4Sc0v3EiU4OoPywpytLcIkepU1xIpLW3DJoLlcY/D36hen2u3sr5OZ7bLEJ
	nDpcssqgbf1rNJGWysRox/u3xKMvePSs+0/dsSD+M+s0ITIX9Vn9w4VfzWoP1KshzNw7wQ
	ykEPHq8odfZ4ntyqaRfGKrgKwFj6l8c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788547031;
	b=JWSF3e9sI+1DmP/9HJrW76aKUwLTnGmu/BkjzWIIAZbUURJg0rPf9QDs2QLGPxerqwPvhj
	YGmeqGtIsHSYDp4HdTca+33qhWi/4cSNay5u3WA5AsPd2tzi7zUQ6WutyEO154MgZJSaxB
	mQUK/uvqaENK0ttOXJ2Ln51SF3zrv3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=C+3s+b+7;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66c7127a73dso2017369d50.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788547030; x=1789151830; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EYrVETvRvxY5BVpkhPjtzdiUc0wbZQ7Wsx0WTj7855w=;
        b=C+3s+b+73djlDmFizFqxNL3L8NVIpzuZHxfmHzOjinZKvxlY/gznhfy3vXCSLS7Ill
         yfB/4NxpAQw50TFbpW7Zzd5qLfM9gSnQjxQSG/XJqqf0XnW/829wfWpKV6RjVPLDA0vV
         xZ/tf1A0nYVS4B7Je1oTSJvLe1b5OouZyGD5MBJPu5Xwrce1chPlf/WVBZvXX5VFmisU
         7lHl6z87MhfN0+De1zlQ2TkMjolcE52VQcmRQXZuhPkmVDEu8DJ0zcjwmY4V+TvVuSSV
         TwN7DLtOYc6AWXnOg0k4UYMFh9T4I4BLQBSppiEJuKu5R76Vcuv+7wPefvAeqaPSogLW
         aQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788547030; x=1789151830;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EYrVETvRvxY5BVpkhPjtzdiUc0wbZQ7Wsx0WTj7855w=;
        b=Cs7AsXpP4AquhOHgKL5LJqNS5/nkoWU3Ai4hX4hI2RSl1cFBJ8CXNVDUFA9OZkUMKw
         A2+N1K2vKxnxjB8dwnh98g5xMh7QON2OahNxv87KTs8SCAkFL0rknpw50WFCxcojOi7h
         o2RcWzL+mTQ4GgyyL3NOyRYnPUxhkBBFoEFj2NUmUq8OaAuMWhWF4V/dKr0+aAa8+PwS
         jlB4fraQh4ZOERRoxDfhvVEXKsIgylYWVP1wIiMVJaF/xtpYPu9muEskfqHM9xqVSYBl
         BFTltaODncuvosx8GgTFMM/Jlm7dPnmdgjNzrz1sVrAduxe0jru8vKDXDGq+F/3hMQdi
         SQsQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyxfMS961qo36RvksgFUonvJjRYUs7e/C6q0z3Q8+loA6jNmEjLJQ7ug25V/VU/Iel5Elx4gs0mg==@kvack.org
X-Gm-Message-State: AFuF++nFZApsUJ1CB7BZQYjleGeCBYHT7Cz8kFy90yF9JgbRlo5sm5Pe
	6ybDjzLblzPFiNUEFrtq1kOMXRrzCnC1ChPmCtrfmd3vOWr2GcImPmutUsP8a9dD7g0=
X-Gm-Gg: AYBFou1TAJzPOg6PZlwHKz0yG+jTKapebzAYSc8tXbBEoLNc8DvEz4gNJWocX4qENE+
	FW01xh3gVr/iuES98X8khV8Q4C56j3/er8N68I8WGmBugsFkb6OWbXCcgTFepMiMbceShUoVCgk
	QpUzkyyMoGPUTA9PvoZNUXsNjXXsljopiJeK/qKW0S+XLJoaMNet6a/HaIJDDK0am06vXYOyuMg
	Sz0s8cCjDunbtSh2JHyYf7BEyxwkx5CNxftzxX49WyyG4kxspFc6gWwcL+M4/fa7hMUOraQL9aZ
	FABi1Qew13sIBgbaiaz1OPsDeguUUcRtsSE4sCAkk4oh/n/IQCt8iLqew0aLvRO8BuFnSrXwXKV
	uQ/HXmto1HhJimzzUgEWemE364xwXDGdttj2P5hT2T2ZFSRIBYbPIKtWFMfdFD+8kb/Qdxe0RzD
	6+JQIiImfEeAm0VHgfN8ISAiiDPCvmt8SB8V7mVky9/xOrfOlUtjoJpipi1de/
X-Received: by 2002:a05:690e:250d:10b0:66f:8d5a:e091 with SMTP id 956f58d0204a3-66fb59585bdmr525152d50.13.1788547029035;
        Fri, 04 Sep 2026 11:37:09 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714a979199sm24242077b3.29.2026.09.04.11.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:37:08 -0700 (PDT)
Date: Fri, 4 Sep 2026 14:37:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Stevens <stevensd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <20260904183707.GF6641@cmpxchg.org>
References: <20260904173145.2028377-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904173145.2028377-1-stevensd@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 951F320008
X-Stat-Signature: kyskpwi5p4jxuuomr94y7z3ti9kjab6z
X-HE-Tag: 1788547031-856658
X-HE-Meta: U2FsdGVkX1/5dDFOxuFeBISYZGQmn5KDfrXG2SnfcvfKzvRx7wVpaSyprCwnWs73bzequi6aeT0ZcgONFd2hz9jVevoXmHf3QU7QHCt4h9rNkQYdVnFybAVQ1tiQ2Yjp+vptXxew7Glxbb0ZT5Yc0REplOWY6yzmRo9HTXCDwDv7/JQzn4OsdzsAbi80l0uzMM6P53dMmW4i+za/y5r/8ckBNAJGAcSQ3azN8j18BV/dXzAGF+Lku5eGGUMS0p9hcvzA7H+wBaQjnIZ6MVdHfnlngqDKOkXHkmKnUzp9FAwcuxSW1gAbVXNbMm5xBVO94T4fLp8HRBANRAVRHpjXizyp4VwFu1bTAZa2sX4FFy2vagEWinyMGaYv1TXXsTlVqBKuHVSWyg7WvIfHIgsYPXBea4FhVNs7yqMfIgPhmFFll/62ozNq5ngijlzcphroiK7hJcLbbotARYpRRB860cS+UHTWdnys/KopmDMpSg9VYwiq3+n0anDPu4SE6NULvrEmdQJVCTE0XphDg+pJ3MTRB+gtUaDwWu8CoTA1PO1P8fxivgzPsbQFscA/xSx3X+DfSy/ktcfImLLnGdKvth9QFTtL46QNWxjfCAH+mTjqF9YwT2B4u2VeWEN7KaKFHPHI2kCRWVJP6He9xRIsrnvxc7m8OcJMERxZqp0B88y9CwQHX70HZkJcZJxquAvtS+WxbJLMbzAQrW5oVvYHT2ZtmmscLazYm6ycaUjKVvV2YEeWnpPFl1ZkCHppg2MqghoEMyEktlKhjQzIcQBHHoDS/1oy5Hz4kGDLnO3tCTEHXd1MN4FUBTD28jVaeqlM683EgdaO8oNwxsVCfl3l0vLqRKGACQcHCXBsbutWqtkssIM0pXVwD1mHaQQd8K9K1RO6LC3lfK01o6v4+lG1+VjOcyGNGwAvAcV+Mja7kBbRpehlNVOtZD2FxsMMLe11K4KzLkB9RdJbgEaK5Ce
 81eBan23
 7+IcGhCVaZNS0XbeQ82Ww9SMK1OqF0C8wmD4uGsvbPSANryAr8eMhFykiQJxe5Nf5jn1MW0Gef1ApChYeJXSdxwFpiBRxiNSRTOR3C3q7vQZ0RYj65wcZoQbk8YwFqY+fK/WTSX9CMtSbAwuPRm+u7wQeCiyM9G7oDhmYsi//jjx5E81xaYtRme4dyjEl23hEsZS1Py1Vs32HRjQILF2TpQAYGuKb006Wngx9NTfWA8GTge1Dhf9Ec2wBXooXuz+hv+yNsQPwKEulD6mslOZYEgcw6W8wLp/k/bZyFaBQ54396KsgW0bEvyM+n+RPhi5Tea1+kusCPdaw46/yvHE97PjL76sBxn0W6uAAlVEog/PHI3z5GTSHAdyQevfFplVQxOvIV1xqWYYA+cq5oRAY1bzdjnKN7HOP6HdWRnzZ3bkqjWM03PLTtazNe+6uC76rSfXEYf0A+x0824ZmM8NT9LD+r0NBMT5OZ6T2jZ3zfp1rwrUaJ6TPqIflIUowfqRFFP4Fub3jw4XJ+1Biw3ugWY6PggcLVCZfaslO+YrzSArk0OY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Stevens <stevensd@google.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

