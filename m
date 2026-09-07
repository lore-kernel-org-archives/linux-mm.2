Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35B1C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5906B0092; Mon,  7 Sep 2026 11:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096EC6B0093; Mon,  7 Sep 2026 11:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7816B0095; Mon,  7 Sep 2026 11:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5EE16B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:42:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D8D6401C1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:28 +0000 (UTC)
X-FDA: 85187383176.27.06A8130
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7EC494000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:42:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NrZWf/zN";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788795746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsM2t2muwC2t6tub3Lkt0Nmc2lGDELjoRCFL/zUluw0=;
	b=k/GKX149ZgnXARlfv8s+9iyLoNTgvzIRdW16r5hlSQZnspPshGzu6ywsxLZ+QP9oMnp8Go
	Sb5cAM/R7iUD89EeZJJQY0VCSTm5JjIVjSkp4PVcO5PsBjbzVVDecColrx1Q8EVAmHKW7q
	WM9jY0GTTeLfja6v0A4fddrpU3pI1wQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NrZWf/zN";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788795746;
	b=O1zwQQxFQuvS6rBbOWRv2BQEE+QYco1df6akH+shvVkBAQonfc4meTCjDsy3Muy7eW792t
	bp6GvVYH7dAbtH0wGx8sL+W6rO6AfuAj2N4guJ/hz7ZtFg56bLYawFfAvVnl/8G3QO16CJ
	n6C68Tv9tg5gyXd4tc22GE3+G8GX//g=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9399daa3d43so127961685a.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788795746; x=1789400546; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UsM2t2muwC2t6tub3Lkt0Nmc2lGDELjoRCFL/zUluw0=;
        b=NrZWf/zNCqSd3kq1m5LNaRTkOUK/PKhF/UX0osjSWKdGkSyJQb1LyuN0T1YSI8tkoE
         iM5AKjG7CyFekYDyzaPdL4+AGZ9pp6yvv7Z1lo8kU7+EXCBy4gy8RxV2jTOYhSgNx7Kr
         zVKG5Z7nfgYkv6cD4uDOieB3dktVomZw/6X6todg81JSJU3g337qB7hRRooWO3ztM2Gc
         c0IfxDvZfcv2v6NN3o2A1pIaGgFAwIyiNgee04dzPJixI9rkxH5eXyzZlhRxqLV+Tur2
         NaUwOaAA1rIEjdiWOx5JR22FdMfJperVgIqPTBY3qiKuWX5FMza5p3iIMn1rODIE6RtK
         Ybaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788795746; x=1789400546;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UsM2t2muwC2t6tub3Lkt0Nmc2lGDELjoRCFL/zUluw0=;
        b=eTrN1zzQolg+/xjcCyO3Jr9wCojBLl2JJ6wzw58ou/TRB3lt6inSKMMQgnviRo4KcO
         /4F8CStv3Gmz/e7jmSk4INAExf9xP/RvQzWR+dmqaPqwweXrv9sLuVJTdARm+a+s1pEG
         RKus0lci4aEYzMRB2QqcNb5V7HREezTQCp6GahegVSY7SNjN2sGvW96Y1x40fRktCUut
         lq9WLzDdWvYysSOlXtUOFKo9TACH7Xg6XI1pNrEYEfK6o0Al/oFZu2KpV3RyWXkvQTli
         5LAUbIpDfMPBNjAz3KNA+UcUk49RT4HJ7eBPBSYfETcbyTZHXlIc80k07TvTJ8XFcEnh
         rpSw==
X-Forwarded-Encrypted: i=1; AKwUvByUXPEJlb+e7qugsJAnHSbQR1nL/T1FOeypiMHMAlr3twk9+qe/zNP+vZxL+QLhqNRYOgioncskRA==@kvack.org
X-Gm-Message-State: AFuF++nCgqt621KPF+ZMvZJ8phgf4yxrGgPKn2Q7yuaQ5M6NmXE8474z
	vC8M412CY3rlUykl3KaMjD0CvzqAaJ2ewi8VABmYMCMp3Ntfbb800GnNyjGXTwT8cwo=
X-Gm-Gg: AYBFou2Z54SLNecKl23kZw9s52jfXvHbq03qTE2SVbaqv8w9NTSoB0FWB+zQmLYV78H
	vQL5j7HxYbSojJ9hg2Q+hbeNJEzOfRTegkdUl+zjiq969t5fW8Lg0D4MN0eZCfeoVsUs7rmhwZ5
	G99ZwQ+4/zZ1chluzC+Vy/FsK/FSZWpQc+qbbF8uHvDY2f9YWkAqkpu1FCi+qS7oq5lZZxugoSX
	/P0NH/m2TSgPKlB+m7nPKUDBIKi/SRt3bvj7DepydlSuNcvWxSMbNx8eGpvLe5gIhqk4UdnxwvC
	ytON4ZsuY/KkriLv16BipWNtSo+UIOL17k9fRCK4emPar4T+WuCKyGUke8eKSu/27jkIE7iEExJ
	StZjI9K8B2WSNu+RfBRxK8sE+Vq3brWnfcQwEEUw48IoSn/TnO/MsF94cprhF/ykHt0sAuiy6id
	mG2KknY9mfs7zw+hmXLl+1lwfNHNZZbWxiDDNxHpVjaUSMmogQA2wRWMj5HfY0wdpwYPCHOP86i
	YL2jBP6DZWSaS4d68vPr8Nz77YaqmI9MGUMjJPnnPyc
X-Received: by 2002:a05:620a:aa14:b0:939:6c2a:24fd with SMTP id af79cd13be357-9398031b73emr2041569285a.9.1788795745703;
        Mon, 07 Sep 2026 08:42:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040646d64sm95118286d6.14.2026.09.07.08.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:42:25 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:42:22 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Oleg Nesterov <oleg@redhat.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Marco Elver <elver@google.com>, Ye Liu <liuye@kylinos.cn>, 
	Tejun Heo <tj@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Yi Tao <escape@linux.alibaba.com>, 
	Michal Hocko <mhocko@suse.com>, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, rafael@kernel.org, 
	gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org, rientjes@google.com, 
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, 
	boqun@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org, 
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 1/8] sched: introduce for_each_process_rculock and
 for_each_thread_rculock
Message-ID: <ap7bPSbO7UvFSwPf@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-2-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-2-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: eh798a9cu98ehzs34s5rn4uew7ubz74x
X-Rspamd-Queue-Id: 7EC494000C
X-HE-Tag: 1788795746-994810
X-HE-Meta: U2FsdGVkX19jaEXCWVIGwzqK0ludRWUiigwTD7l9kzTnuwotIWg6IKLKhjKuvM7S5HTd5GpQBiETde6rwVTsLw2YoGpSPsiRHn8pcZIvATlD4nb3iH3a6aA3TSJH2XfIt0TzxUgXLH1VVepum1GBhNE+Q+B1wgd4i0aP2Mqigbqs4o84gZssQwGwJeZlCyZJmCXlYZQ8NTLOCsNBEZxG2THRG4vU98qbsSNCZjWE/q/qNb8qZMQH2pUE9AYf39BJt8Ih6Yi7Ania62QXdUIT9/0Mdcxp8H9HgcHgqh3RY6CE+BwFoIvr9klv9ODI8Ft/uYQswa1jp9TKDvLq84Qg0nZwx5xgDHh/BDwzANGBnFixK76YkSLJfeOrQUmsLWABjG40g6wtBquSe1TgnMZb8Mhp6imJ3I1xvHJG7meZ17E6KMyn826Ca+LMD32wnENhSOfp7ECbRGsN42RyJQKkyW2/fVBoBXvz7dbKzZcGyUv7vwZoFN8l7n7mpM0C3k206wyqOO6x3CxrCWZEQHrX0WhbChU5JfqowYqWyeZQB8cvmBJKSqc8yjPanvzG9p9zUKN1BHa9vbsmjfPwt8M+FFAVR9AFXXyHPa/XvhA/QQINDkaW2TTWbV2hC4dDH8USpB/31toGcCO7lIB+Il6aStPJiIsCzrCnZzr6eT5a7OWO79rD+P8yUvNZl/sGPyuvOcg+BKYbwjXyGVp5JrGf9M+ORnBTXKkbmV9sI8m3tN5sAXO2drceoJCdOlRA3GHoudMiS0inwiKFZTs0TlL6meBOtTQpwnlW2DSkCvvyX8JapgkyNn7Nd349ncpo+B5taO3VIEhrP8Ec4BUq9IXwCZaXu25uy7PDFxiARf2uL+pqVGSmRxN2BdXHNq7zkDU0j+q81mKMf8BTzT/83iTX3c6lYp7wf/qB7j4VXblTeC9Jm+IzomU801ErSo1MC6wBzDpYljDgWUm6JjFm915
 H1DlB7i/
 GOLH5sZoayX97SKAVS6U/Avv+c0xuP/7SpcAamcxykbsLTJQ87SxC4lGxpYeqT7s3R3HKHfJ9F+2XNC6ZuQm/hG+3FO41RqeGkuHaz+ZeuCLZcNfoHGKgfEzdyNG1eH75JpkcynEQUvk0/O00Ze0ftalmQJI9Oi/fkqvNywvRfGq9fz6yzWeUScM+CHGRKZ8xL7PAFonj/uLN/qQEeVDeaxzGopwS2OlgkYzqsdQU8X4IdGt8VjPe3+8j8fdh4/uCMJeIEsQYMTUbSnX2c/Xk13rynBU/LtFcGy/HEhgHAq5257vNt/AYVBi40mQchf6AhhFHXk3imDFyAJUCgOzPnxT/PlvHi/Pg8coiTWUsWXXflSXLBxgmAJ3yKy18Gk/EYGFEbk1Df7z2y3FlyqSKSCHXAoBAYjQCRbuFo+UOmNrQdelDDfE3le1ilo66eeESx7OJAP2mc3bQ5WHUtxFw4G6IebgYy850EHRUECngmk0d0TtMD3lUbMiGi1a5pz1jzJovqwASiBPQ8w6GCCqhks44xAlYFu2p3cYrkzYiQMDXgZTRvciEiStkRBM2crjbtBnZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:27PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Introduce for_each_process_rculock(), for_each_thread_rculock() and
> for_each_process_thread_rculock() macros that acquire the RCU read
> lock before the iteration starts and release it when the loop is left,
> so that the RCU read-side critical section is scoped to the loop body
> instead of an externally managed rcu_read_lock()/rcu_read_unlock()
> pair.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Lorenzo already picked up the nits, this is really nice otherwise.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


