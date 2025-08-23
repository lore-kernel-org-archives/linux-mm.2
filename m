Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3904ACA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 08:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DAF6B00BF; Sat, 23 Aug 2025 04:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF8C6B00C0; Sat, 23 Aug 2025 04:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3616B00C1; Sat, 23 Aug 2025 04:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B78A16B00BF
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 04:08:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B5FF1184A5
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:08:42 +0000 (UTC)
X-FDA: 83807295684.22.A9D184A
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5AE9E100007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:08:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QhHAaw3u;
	spf=pass (imf14.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755936520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5D7eeNdQSiGOasqKX/gQg+YtICOsftnZGJhgOnqSco=;
	b=KWMfWgtIShdm43t1sDoP2/+ojzsKPUJr80kO0IkCA2r2OCd1Ay/kRIJlYnVhwiNq40blHA
	6GInGiYrpteXfJsiWkT4LPvubAVBgRiykxBeGAumqgbBKsUIh8aIqIONbqBGsoTxkmgENR
	hrtPgdHfDpKTgzKQT+ey2Q+aApNeiEs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QhHAaw3u;
	spf=pass (imf14.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755936520; a=rsa-sha256;
	cv=none;
	b=HEOnU2m/a0XilpJtSucW6Dbd6pFYeNGUvcvtrchis5hFNaPb7NX9wJ2EzDenANe5Dq3Vkr
	7tWSfCMpyBYY1MSCrwNwzZAEUZH/PdwsRGwO0HThxMbbMOwJe/GXvXWcP+rfXgFJz2wTz4
	jNEI8mmjg83kGqDlswgz/rU4a/ph32s=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3c6ed2ec758so123260f8f.1
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755936519; x=1756541319; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5D7eeNdQSiGOasqKX/gQg+YtICOsftnZGJhgOnqSco=;
        b=QhHAaw3uQk76CtqQH5bzcDr5QlsWXuQwFHu8cS3VjRObBt6TJjw9nSBmeulhGGAktr
         N+U1LGsEuwgzrS7WNf5FB/bT1Sw6WOxjEY/dKTrPjUiQDGIyJ+BayJBgZuo2/UGxYEBx
         5fM9RGMqXJ+GrGuqhjzYnFBnwusqC7INycWdi2rrWvqQ1KQ3JBgrQh6X+I09GTprUjPf
         gljEOsCtiV3k0ubQRtxjZI7srPYhV19gV8h4u+NdNxZmKWRYp9jaTunL0zigcrwknr1K
         gFjhxX3EdAIW2/daJd+HfQ3Wb4h56GEwIn16HyXB//6DZUQYZ8Sp7Ifxd9r14v1agKBd
         YIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755936519; x=1756541319;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5D7eeNdQSiGOasqKX/gQg+YtICOsftnZGJhgOnqSco=;
        b=ORx5siM/9DmAA/r/gFq1ya0KzZxZ2Zjn1UV1HeED6f5XVIGhqdN0USSfRGgqbtVdQb
         +6e0lGvJv3ycO5TqkvmEuvzR7b70zIPSwROLtS5vqXR0z2ykNLfvU0wNVVDPfZVPJZ8G
         rVpEy2lIx9DcKaHuGAkNzJZt6k/+qctBPqpGc44TEzEHlZwNWPSRQWS3tojsN3GCr6g2
         5FdjHTPx66U902R6pfTVm0KMUXzoGqCznlJoPLy6NNtcSBirGz7mfkaWbahecBTzhNeC
         IvjBxGeWcT2CtMjiXdZ4yzxbxZX4oaccgwRjVjdpT2Ozbe83frxOqorTfUbGl26oJCRQ
         UYzA==
X-Forwarded-Encrypted: i=1; AJvYcCVRHKhpanOz+jxlOwvjUJ88Le1lhO+b2Qyovjm2yBsMvgll+FZjRJGG6nwLytTvnHApRQ+gGofpYQ==@kvack.org
X-Gm-Message-State: AOJu0Yxo72ZxGlvANE+2A1eDT6N/4mwI0ORtAshy23trri6YGkldFrO0
	16IFNM7Y0/tyqOkOHYZ/xVKdfLwNRKNXmZna8BwcF+76f0uX1qh36EMZ
X-Gm-Gg: ASbGnctrFkCWYb+q6/JLCB9ZkqoxT4OpR3eByk/FHzG+riUskLT3MGBlpLNFnQRZ0gi
	S5y5FJ8dvhzBYefKJFOD2t9gThV8KPgTncWhYumnWVQj/M26wTs+ItlMJGOH3uilmaRbz1TjbSc
	cByGRTVEnzSuxq2Q00SqXWrZQzZZ3oBqe4lWSLJSvDjNBnYW0/+XSpld0Gj2MmaDTfCcNOR8RW+
	i1CoBd4vHWo8Cqr/Htp0CNX3guwMq5BPcG52Dtd7Dn7BHMOjRGwmVAw+KOmE3jqxc78FLzjldlW
	EPjaQ3WkxKTnOC9jRmgNcOpbcrkGLdDYzkLA+2rACV3nt+vGBkZfCfq0pRmpO5ycaB/WIL1zkJz
	u8/AsjYgVVv7/q5Clro93QpdJgBWkB6zz2uYu5epT513nCwcS6rv1
X-Google-Smtp-Source: AGHT+IEv8VRJb23jt4k+0hi/sSmMwmxJXBH4vxmaxMRWzlSs87Du3ko2O/AtvHKpOGNtNV9nguhH2Q==
X-Received: by 2002:a05:600c:45c6:b0:456:2137:5662 with SMTP id 5b1f17b1804b1-45b517df7c3mr25336325e9.7.1755936518408;
        Sat, 23 Aug 2025 01:08:38 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7117d5977sm2616715f8f.51.2025.08.23.01.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Aug 2025 01:08:38 -0700 (PDT)
Message-ID: <76a95839-00b1-43b8-af78-af4da8a2941c@gmail.com>
Date: Sat, 23 Aug 2025 12:08:33 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: sunjunchao@bytedance.com
Cc: axboe@kernel.dk, brauner@kernel.org, cgroups@vger.kernel.org,
 hannes@cmpxchg.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org,
 viro@zeniv.linux.org.uk
References: <CAHSKhtebXWE5m0RcesWe_w2z1Gpqt1n5X0wuE9oD1tX6VxztUg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <CAHSKhtebXWE5m0RcesWe_w2z1Gpqt1n5X0wuE9oD1tX6VxztUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5AE9E100007
X-Stat-Signature: xmbx6khx4b3afurb9ww4dyf3rjr68six
X-Rspam-User: 
X-HE-Tag: 1755936520-112524
X-HE-Meta: U2FsdGVkX1+U/HzMWNEsyIKgCZxc+52GVm6/wWKr2YCvembf9f4iGmiOvBt9s+Kqk7B9JGCbrIq3GS94fNuG41C/t2giaautx48ScHHUOY88lKc5ZngAheUBxx3OHoz3U0Itx+HZZSxVBuIcyRvVBcDKDJ56GmdSARkfcnC7ibhW/Bp0LQsVCJW/qyma8mjIYdkOlne91tmtzFbjkCJP1htFXWIaOGGk2h80t7EcdanXWw0CqUzg5zqenBgWme5FPUMSA76dKrVzL/hCUNfmoCyF8PKiX3jPiM/NbPFP1TXa6EX+MIQxOoftRRAWXFRes6EC2mIM2gz3yAbaStzB7N0vAyRRfcvj8RFNaNMPoYuq6hFjmAhZsHCw58og/HhJ7Mlq8sbWPCO6KB0JbdG5YN/VayOxLOvFhmPQiXf22MXEkO324CMGoirKa7IlAoJKpHVXi7MuuL3CSV1HonHjOwRU/RwP4nTr8f0uacysefSOpzJSYvdCGdlww/Be/k9+ksC87QiUbQaYYeXyVnVU4ixrqBZYF6BCTHon69z+4rpMITyQRkOYKN90jLyx/0w5kOFERZM+f//4jq4c55msPSP626EnoGb4ANLTGJkAOpAo2Ey9omWL12BJf/fmO+336nTeB9ocjVrGJq2fl9GA5hzJsDO3hHi/wbu1D1DZw9adHYbl8qIJw/MdRliuT7SJ5VaMCDFVEicQAF9zprdK3E6ZgoOINQdNKqU5pM9YdJu0gqZsAPpU3n3x0ewSUNl73ZDFf9++S/DzMn0waJghngPsnkbekz5+7MdntAZeUoeyIAR//aDZsJXQHz+DJzpE+qgkh1ctkIlWw7h43xpFx9WgVJk1UBf8pjCIQCg/aqytqTIjMC56Xwoto8Poc5hZd8kzwRgD9FWloFF+zJTC/V1ge/QoylLxDwF5DH1jrpvWJm3TlkoZ3RNrpxCXiO0WzMS7SHHB4cPS6P/qBQX
 H7KYTQbj
 LlxdcO7Sg+Ax7seci8IUESaH7paOF7wlp5pYhKV9EFw/lVuode63rCy1HJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi there. Can we fix this by allowing callers to set work->done = NULL 
when no completion is desired?
The already-existing "if (done)" check in finish_writeback_work() 
already provides the necessary protection, so the change is purely 
mechanical.



On 8/23/2025 10:18 AM, Julian Sun wrote:
> Hi,
> 
> On Sat, Aug 23, 2025 at 1:56 AM Tejun Heo <tj@kernel.org> wrote:
>> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun 
> wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t waitq; > 
>  > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_t 
> itself already allows overriding the wakeup function. > Please look for 
> init_wait_func() usages in the tree. Hopefully, that should > contain 
> the changes within memcg.
> Well... Yes, I checked this function before, but it can't do the same
> thing as in the previous email. There are some differences—please
> check the code in the last email.
> 
> First, let's clarify: the key point here is that if we want to remove
> wb_wait_for_completion() and avoid self-freeing, we must not access
> "done" in finish_writeback_work(), otherwise it will cause a UAF.
> However, init_wait_func() can't achieve this. Of course, I also admit
> that the method in the previous email seems a bit odd.
> 
> To summarize again, the root causes of the problem here are:
> 1. When memcg is released, it calls wb_wait_for_completion() to
> prevent UAF, which is completely unnecessary—cgwb_frn only needs to
> issue wb work and no need to wait writeback finished.
> 2. The current finish_writeback_work() will definitely dereference
> "done", which may lead to UAF.
> 
> Essentially, cgwb_frn introduces a new scenario where no wake-up is
> needed. Therefore, we just need to make finish_writeback_work() not
> dereference "done" and not wake up the waiting thread. However, this
> cannot keep the modifications within memcg...
> 
> Please correct me if my understanding is incorrect.
>> > Thanks. > > -- > tejun
> 
> Thanks,
> -- 
> Julian Sun <sunjunchao@bytedance.com>
> 


> Hi,
> 
> On Sat, Aug 23, 2025 at 1:56 AM Tejun Heo <tj@kernel.org> wrote:
>> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun 
> wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t waitq; > 
>  > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_t 
> itself already allows overriding the wakeup function. > Please look for 
> init_wait_func() usages in the tree. Hopefully, that should > contain 
> the changes within memcg.
> Well... Yes, I checked this function before, but it can't do the same
> thing as in the previous email. There are some differences—please
> check the code in the last email.
> 
> First, let's clarify: the key point here is that if we want to remove
> wb_wait_for_completion() and avoid self-freeing, we must not access
> "done" in finish_writeback_work(), otherwise it will cause a UAF.
> However, init_wait_func() can't achieve this. Of course, I also admit
> that the method in the previous email seems a bit odd.
> 
> To summarize again, the root causes of the problem here are:
> 1. When memcg is released, it calls wb_wait_for_completion() to
> prevent UAF, which is completely unnecessary—cgwb_frn only needs to
> issue wb work and no need to wait writeback finished.
> 2. The current finish_writeback_work() will definitely dereference
> "done", which may lead to UAF.
> 
> Essentially, cgwb_frn introduces a new scenario where no wake-up is
> needed. Therefore, we just need to make finish_writeback_work() not
> dereference "done" and not wake up the waiting thread. However, this
> cannot keep the modifications within memcg...
> 
> Please correct me if my understanding is incorrect.
>> > Thanks. > > -- > tejun
> 
> Thanks,
> -- 
> Julian Sun <sunjunchao@bytedance.com>
> 



