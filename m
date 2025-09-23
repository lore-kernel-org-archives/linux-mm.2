Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09982CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 14:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477388E000B; Tue, 23 Sep 2025 10:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4273F8E0001; Tue, 23 Sep 2025 10:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE5C8E000B; Tue, 23 Sep 2025 10:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18D218E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:17:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D218DC0171
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:17:51 +0000 (UTC)
X-FDA: 83920718742.24.CC851E8
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id D64C020010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:17:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y9ygLdD5;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758637070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5q5N3nLYy9yP+B4kwAaZrbrxG23b0NBI/IKB6m71lg=;
	b=4bzLzvno1FKwpi19HmzUA99zQ5VpqtpgjxglINBCGkhkM+ralAe0i+1xFYycXztpSgzc2D
	sYfiwPP6RkRnOLYsspAZJbkdtd1h/M/R6KKUvNBPNpYItuB4WihdLxppq/V1koHiegLXTJ
	1a5pH4wzZayU3BkSXtNmTb5z+NXXKOE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y9ygLdD5;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758637070; a=rsa-sha256;
	cv=none;
	b=xgZf7eqDaTDkpa5bVMgkRxFSDAZBoUHjnk5gORZfjYeyiUpXKzl11ZlXYQa2ehVFgVoJuE
	T08qwBQA8TXRw5/f5a6R8FkaiXJbA/edq5kfjtco0pQ3XFpTas6461yU4GYlTMtq9cBmyh
	eb67So3K/SRsOb0IlJ6cZs9ykeExWL4=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b07d4d24d09so954546266b.2
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758637068; x=1759241868; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5q5N3nLYy9yP+B4kwAaZrbrxG23b0NBI/IKB6m71lg=;
        b=Y9ygLdD5pHmkJaLCk6XEsEcKNIIeDBSzAf/x99OdFt4goXJ54WgV+nR8lFDrZ5vBqm
         1eJDmzo6rVK76CAqEEwzXaAkIZvo6karoqZ2tY11/MtHBBeLrwOvY1Ib6Kv6WRALHVg1
         fCKE6lEbaSThSb/V8HEMmmtxvNi3tLZsYODvFXs3m21aZsIxOJIe0EBJv/nkZhRPry5/
         jBv6vY6hbb2vpjWAiGLUwORjmg52VsUATXC1dH+03qN1WLyW0kYmRtds58QFNuMo8LU4
         4ZZJU82twfpQxdWfeltJda4p4MsIHgWCSgnWzQkvB5eKgvDO1CGbVjh5X7LEF3OgEm4P
         1t0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758637068; x=1759241868;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5q5N3nLYy9yP+B4kwAaZrbrxG23b0NBI/IKB6m71lg=;
        b=wOHdMJx5UPZOVNolst/h/OkejjGU7QVBoe8bd604bXMvng8PT9twlMq2OOamrq7uGB
         J3GeuDzaWbIAJwb6SjF/4ZVRDRbuXMsdMMuoSMusrSAp0c5UifQPS4bEdkLB+7HjE1x2
         UVDKUc5P/Sa0ZJmVXE6UrE0OFTa7Po03kSaxe3+jaQ1PTScvgdCYQCGcAYNO95YYwAqL
         gam8TNq4r3fI7IbzZe6OxfZUvmpFyjVNCExwcpte0c3TG2PIsjsQZlw7Qv1AytZA1iAe
         SrMwBXpU+dr31tNTLX8DbztUiAb2xZ4KczfoLBeJZAIJULXnCjZ7duxXKSly8vyLNLRl
         BTqw==
X-Forwarded-Encrypted: i=1; AJvYcCUGHXt6yWEChwDvj2J0m4qinbogHpJDAQYTwT3LY/1J7/O/2A8xENhnOf+qVcRX1h5kJWUtUIC7Jw==@kvack.org
X-Gm-Message-State: AOJu0YxGVT4Cktt4emX3wczVXptkJuB9kPafTSV7xgphDRz8ui1Tj5Py
	OyjzuhRT6J+g0/EuHQTUAlUKwoZ2wnWhsUhIzC4Q7uR8zS6cJjUszx1bdSk5VPxW0v8=
X-Gm-Gg: ASbGncsAHIJcDWdDCGBa1txgwsbwkSQInjgc8Q/Faoxay0uRPm96+sq0z9aJWK5jB2S
	jUoWSoD2BPnG4C955i/PqMcIK1TOTk93zqAg1fcNNYiRKp9MEoMrqpo2ftfv0hjegU4R8vGAz1c
	dJcvHQtQ8z81U89+V9fk7xVnN6MmDf9jVjj8rSeKtixqLy012z+rgnt/lHLvK/0WCWBvTi6Z8sE
	zfo8536nqRIxZvrHDKCZfzK6215SFISeAtPzGwKxu+zw3C5SaxZANzrOUw0z/STZdw23pWebC4M
	HW4/1ukSvMBDH/bG+4dcFgFJiPYd9fZ20IB5wAW7YskKv02EuhIbEy1IvwAgczKKbuK8lMxSPW0
	9HukiERfweL5P0jIPxhS11klEBCUazyQLCQ==
X-Google-Smtp-Source: AGHT+IHv8Ydnb9rIz0+NFvQxdeTcfROor571HxVvcaI2WdRaXpfHr1+DeTmXjRTVXNKfWFeK2MsapA==
X-Received: by 2002:a17:907:707:b0:b24:6396:c643 with SMTP id a640c23a62f3a-b3028427c9amr256596166b.23.1758637068030;
        Tue, 23 Sep 2025 07:17:48 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b2aaeea5a1csm621323266b.95.2025.09.23.07.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 07:17:47 -0700 (PDT)
Date: Tue, 23 Sep 2025 16:17:46 +0200
From: Michal Hocko <mhocko@suse.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, david@redhat.com,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= linux-next v3
 0/6] memcg: Support per-memcg KSM metrics
Message-ID: <aNKsCm-SUaxtq2Cl@tiehlicka>
References: <aNEG5W0qLPKKflQA@tiehlicka>
 <20250922173158997VPIUgFcs8UoazWb_JQIc9@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250922173158997VPIUgFcs8UoazWb_JQIc9@zte.com.cn>
X-Rspamd-Queue-Id: D64C020010
X-Stat-Signature: w1rcayircp9b7fcb3zr41o5j7con89nc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758637069-211837
X-HE-Meta: U2FsdGVkX1/NTnfMp3wOKtlipZpcpsn0U9E+6Rs3IbsdhNxIrR8/WDIGEXO/jHPzGmjwUmy1zy3yhgPBNF3J5f1EOO2uCFBQhBSTyRlmKX0xnSBk7jhgtXPg80JtfWt6jeoSzfNS7zUZWuVvZnm7RUFUagplJH+KAiFm2zEeDRRso/RFQR+ooOI4jEmO5cZB7le1OE5EmY9Owv5stTnya1uDE2jSCVQMJdDhJ9a0D0syJpLrGn+gZV5OnYCPM5wHf5V2cB5rnekNsUSS90uk1gxXxsQNpUs2Pw6UWZcTZevqc/TQYhKh6KJrTTF0XtkKs7LbVjMao5eTztJ+i3WePE5mOsgN55vifwXcuTAsy6p/4d287KVNDuCokTggKfLNo63jtRUoFj7XFiE9a5N6xRg1iMeF3fmhIh532MdpMc63yUp8Iodn8PtvDOmo3CEaicW9HifbG64MEdZNevrCkp64sL1WToK+cUd6CktLEViRxLxGvpK9kQ9ebb1i9jaiJQmChrnT8YbOK0/CybBkYGgrSWQalmUsUy51g//AOloibGWMGd8T7ZBin38C9HIKWMhzBJmd+rG1efTy0s2eH16q8R+6fJYtammICGB8cjXzN3lWTBTyiCOJddXNk1uXybwPQI0ZjVTo+oePooNDGu0ewPgz5l2wmsoEqLJvOvfUxFjgdujzLdxLyolkBB6FlcgbSmEsCbY74v15yYM+yG5dHjThPTEnbsEaXxsgYBuVApOSFN7cUigOGTCL2Ru9bKSaLMjJR5bjOlP5C+XgbKgjA3MTAgbA0xf3mNTJZnZrmIi/GBS3i4vCzMGYMGaFgTI24pjRXeUFrPlrmhnQYPcyw6mAgmAskLQaDKhmbPnhJEC5RSQ+4+LOoUzlaaDC3WvGyM0fw70psG3ML9yLvwksdLIVE74yMSS3vHKxgF4/FczOsRPpSBhoZwfjPUGsXjdODqdyOnWmOHxrOt3
 eQIkba+0
 n7mqwm8D8LlAZAFxkByd2FPgcZiA1N7u5d9ZfXpxpmyjTd+Sw+6zBZmfccTBAtjmi/fZDJmzEOoCbeidzFXNj67d4FZ/kjX04ANWQfZZXLrAFS0qB/vWirfSm1F6kvCCYdZumtd76Y7WYFtodpoy0/m4bqXCz7Nxf0sv9TjKgWm4+H0S9ArPexoXDP6d+/SDal/6w3AQEM/9J8HAx0mLqGLQ3OfrE4/iEpXD1lh95FWuZbv9h9Bph/ye7c6kYayeHHl2rDASNzIjk8KP20xhuekFOdk4Wb0i4WRSI1Jx2NZDOZnZZEXAFYHd6W6gAEG3AN7uRf0GBZl1ON7UfWs71iliXgHX7+5e5V11PSbCiJYOdtSRyU+KG8kAUl3CnZeVSpi6qo2KemTUVRXmNPWfFay7H4ha8sKvaTBd40nH4DYbJDSjh6WDeCkBnKb+Q0MXLbJhOtsFFxihlTg9IFbNdqZCpfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 22-09-25 17:31:58, xu.xin16@zte.com.cn wrote:
> > > From: xu xin <xu.xin16@zte.com.cn>
> > > 
> > > v2->v3:
> > > ------
> > > Some fixes of compilation error due to missed inclusion of header or missed
> > > function definition on some kernel config.
> > > https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
> > > https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
> > > 
> > > v1->v2:
> > > ------
> > > According to Shakeel's suggestion, expose these metric item into memory.stat
> > > instead of a new interface.
> > > https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/
> > > 
> > > Background
> > > ==========
> > > 
> > > With the enablement of container-level KSM (e.g., via prctl [1]), there is
> > > a growing demand for container-level observability of KSM behavior. However,
> > > current cgroup implementations lack support for exposing KSM-related metrics.
> > 
> > Could you be more specific why this is needed and what it will be used
> > for?
> 
> Yes. Some Linux application developers or vendors are eager to deploy container-level
> KSM feature in containers (docker, containerd or runc and so on). They have found
> significant memory savings without needing to modify application source code as
> before—for example, by adding prctl to enable KSM in the container’s startup
> program. Processes within the container can inherit KSM attributes via fork,
> allowing the entire container to have KSM enabled.  
> 
> However, in practice, not all containers benefit from KSM’s memory savings. Some
> containers may have few identical pages but incur additional memory overhead due
> to excessive ksm_rmap_items generation from KSM scanning. Therefore, we need to
> provide a container-level KSM monitoring method, enabling users to adjust their
> strategies based on actual KSM merging performance.

So what is the strategy here? You watch the runtime behavior and then
disable KSM based on previous run? I do not think this could be changed
during the runtime, rigtht? So it would only work for the next run and
that would rely that the workload is consistent in that over re-runs
right?

I am not really convinced TBH, but not as much as to NAK this. What
concerns me a bit is that these per memcg stats are slightly different
from global ones without a very good explanation (or maybe I have just
not understood it properly).

Also the usecase sounds a bit shaky as it doesn't really give admins
great control other than a hope that a new execution of the container
will behave consistently with previous runs. I thought the whole concept
of per process KSM is based on "we know our userspace benefits" rather
than "let's try and see". 

All in all I worry this will turn out not really used in the end and we
will have yet another counters to maintain without real users.

-- 
Michal Hocko
SUSE Labs

