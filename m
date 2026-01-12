Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BABD2503F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512416B0088; Mon, 12 Jan 2026 03:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9866B0089; Mon, 12 Jan 2026 03:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBFA6B008A; Mon, 12 Jan 2026 03:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0836B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:06:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D9EAB997F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:06:32 +0000 (UTC)
X-FDA: 84322579824.27.FE4BA83
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf30.hostedemail.com (Postfix) with ESMTP id A913B80004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:06:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dWW+mhbs;
	spf=pass (imf30.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768205190; a=rsa-sha256;
	cv=none;
	b=XmLX+Y9YAkr4H5TvrEF+/lIZRuiWCLQDPCrjbLLQjY36E69WciSXDHU26cLyU7iDoySWe7
	YeIBvAT4JdWICvVStW4pUMtDlq9RLM68pEp8tqSHqG66+Uo7ve8k01/uVdgR4dI051QGec
	t0j7qurtDDpP5Ux9dilCrUy3AGStouA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dWW+mhbs;
	spf=pass (imf30.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.67 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768205190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=t8PUPcy9Vx/NIi8mBIxFa8+hlU13NeAgzjfUJ+zZxDg=;
	b=VMFtVHmF6YO/UCbuteNicBAlcOg4H6VlpTKEpDOKY3/1Fi33K2PEf7j78LTU/+8NCpCzgY
	lCOrnL72hslmlrLGjHhkmluPPCHYbQDboQceMGERsSKG+/ZDkhEgNcRsP1DsPzIAM87bgN
	+YElGMr+1MweHLvy/0yMQ4yTyMI7OUQ=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso55412505e9.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768205189; x=1768809989; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8PUPcy9Vx/NIi8mBIxFa8+hlU13NeAgzjfUJ+zZxDg=;
        b=dWW+mhbsHNOgTeuFEoJtAan56O7GclVM7KESX5wsfZsi2oYPKsoC8wB2WOZ2/fqtdC
         6naUuFj+A87VEs55/yD4/6DzZnwt3hb0u95ea+5EpeW3ebqXM05DYJrpxEd+xS9sr8S3
         fE0+I+K1WE3JzH26ki03jxuh+QLaqXMdLnlUUKN6dPJG7Zo4S489YlDcjA3u2h6OG4bl
         fCDie865IxBz3lm8+g0f4fmFXAWFE2Vf7fFmThsZAUBHXX9MrEUTjeKh4kE+DFfndRT7
         1s7vXJnPY6tFlLvNw7bsymHN7MgsZKYLp5LvDLTY9LtekKP+WWw2c30qhg3RYiYtqpqD
         rvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768205189; x=1768809989;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8PUPcy9Vx/NIi8mBIxFa8+hlU13NeAgzjfUJ+zZxDg=;
        b=q2pjVp72mouDn4TDBPT74TPcbixByFfTnG3wlkz9AgCgveE/Jj9Qn+MppANxKYYH8U
         M6SR8l6DkGhjmTQGOLNQBGYHsrlQI7TYCy7IcTJfx3WaCHhjHFa6Cx1byTixeyq1oH2d
         51+7tdJSFf/pirWEeHDz9Sr+/afTnEePd7k0hRlC5CCsNWcf0kscGOXeQcTIHxtPcvxP
         MiGMNG4nAn2+UC5QvhEzlYWFjjQw5/XRjEn4r7c8cDfdEHJWLcfKibMmRjyQXzTLM0QS
         i7ImQCLLxWRmJQtMVs33xpmBy6iM1EuiZyItd1zWW83iUy0uA87oMk43yiYD/LiWcP0S
         wxcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw2XtP6VAYS7+FsvAPjainwaqmIDtQ1gdl7de48eK/UxFtU2tC8uiTDCpoycVxYG6dB1tzGrFRbw==@kvack.org
X-Gm-Message-State: AOJu0YyWzPMu+i1XYgPwoRVl2XKZvLyPQbHQMjM6RQsT5tZsaYYab1uY
	oMtqSuXNoQJp/LzY9tv4EiSAYVYA4XsUC2hc1honNyzPxZvqoPhLJEhzBsu/5xlX0fk=
X-Gm-Gg: AY/fxX5H8LYGPbrigJcA3gic59EvToBlCT0mORd8xdppogqQEOzfqgF9sBttwC8f60r
	iGVeIfpAPvNfvx4man0oR073qYFgFsqxBFOsM+MAMpb7MeQ5UoBUqsHLnWv+WxPhQ9LFl/02Yvx
	Zest6QQayLrAvx+P+ezvt6mwe5s7j+VwcCrPNcx2jfR4OeO+ixJFw+3mPcsEHYx+btbTf04GEMk
	cL57weGes8VQwax6HBtLd6l+pZM66vGv7O1NHg08FqKJl4RvOV6vCPydc+1MGgydk6uzKBjCjVK
	nhETKaU8zI/Wq7JIimEEPkN2k4+RqlN8A4uRkh2pJ+vU1BVsuW4AGMJs8pLyaotfVqL9iyTuilo
	dUIaUbMuf3fM/292FrZizcWHEHtnEPxUhEA2osaPtL2DNEBkFme3EsDT8IZmV9MLpHZTDaL/pl9
	oktJvV8LxivjlIgmjXlgThXTVL5D0=
X-Google-Smtp-Source: AGHT+IGeRnmYl434IC1Vj01KSlKheCmNT2gQvic9wVyQ16EjldEmsOfiFUGIG4TtGQB0W4+/K+PIqg==
X-Received: by 2002:a05:600c:c4a5:b0:477:95a0:fe95 with SMTP id 5b1f17b1804b1-47d84b347ebmr203991545e9.24.1768205188859;
        Mon, 12 Jan 2026 00:06:28 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dadcfsm36714370f8f.3.2026.01.12.00.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:06:28 -0800 (PST)
Date: Mon, 12 Jan 2026 11:06:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
Message-ID: <202601120452.VufCnz2j-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
X-Stat-Signature: 88j9t4q7rbjqxuaf8mem4afta1br99ro
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A913B80004
X-Rspam-User: 
X-HE-Tag: 1768205190-458103
X-HE-Meta: U2FsdGVkX1+Y85z/EZqOcq4zn7SAklMojvSQXIaAanlzVUZiEEF5Z+fXBh8v0k8EAYgHIo+Hl0e05kUr8HgPSyrQnisLNtR5IWJf4b65GnVy0clULEbM/N3DQ4UNG80GBgOz4BZwvqYd20kQIMo/FaMCFf3YtA4FyhMEd03m9E0JshxATcrYc3AAp7DxH2fT8fBnaBHi7g/xLvdB2mUdMuloCXaJFWppRJlql0k4TYakfU1sQSH24KMOiMrCJv1E5SkbIhcPZmHK97AEtlhvzkoT1stAeZ52BVYpNgmsvtEWugmqoJnZ1j/YmU0FEsk6Ozw3+1xDBjOQUzR8VLHdvuLksGP2hzfWICGfN5BAND4G/uN9OIFk9o304Zn+9xqvWlOt80qZoHpMO9fKUrWdNJEW2T73LSO8hdx8pIa5Jpm01NqrpWC0T5EsZ3ZlE0LnpsZf9ifxSh4ZswctuZQdZEoP/IkMqjGsC3dVcuBXeEHBsQmTOp9Uhx1HFUieW4FwKDS+FOM3/NWhP7qYEzs39pIpGGzyDm0airLVvb/9GtwrQZzNd9c/53qYHcI25Bmr64ZnIfN+WHcf+Y9t4KqB7p1tSr205/MT8an8Zx5+Qc9uEnxprr92IVH11viQXMQsWVJrIvonezyT3tl2zLFrI7QrhqAmH3+ETW3MQRKmYJE4gCbYmsyHg1pkdrBUSii1yv8wKv6Y4Mz3+9hIUGuRJ05mMlHrYMGn8hFTSUOBqMvcTdjrr1gQzw88pFWvGk6IT2Guy4Ns618Z/uyRMs3cgp28ph8sXCUNNqf9dnwxaIdrmZc7OP3XNoE2QlW2VeXk+h8ozOolhLakX2YgE772aMx9j1GR7BUW78gQXeWtBEbkwdhdio0mY7rxCqioQKy70Y2XybWT1QnnFA4ABXQYAAO3AbUaY1R5J+PydnbBK7jQXCAGmCW25Tihn7hvzgxaNLAAlG98C2km4h7NSlp
 zFnKSiSq
 jK66LPINkKeEYl2oR1C4wvWMOtcC1Bw+R6ghcdXNvluyKOIOSjmgFKiHOyd1R7KDcdriwEOMowb/rwwbS539DNs47Nx7dfh2wpddeBatuPPJ9lD2TkLVtMPW9k4rXnFpoe67nVh+FWDA7oAUrYhXsQf4VuNBBF+Wy5flChigXvWB3HJkAAkjRwIuxx7kLd9trLS1URCv65uAUnAtImf3ScY8+5Hk4ycziTMIR2LIAd8DoRuS8GyTKf50NxhDoLvUdoWXUwlcerp5uAmXYo6ASxCdp29u/ScOmECVDWOsHzkfVO9orh3gP0WfzIIdeGiATQKFzNSkFDw9/mdAeZpb7+IASPgV0LHIvUIug4+uK039tQrGD7zfXGrjhK3wikxGUe5OGotzsrUpMDKcaaakDCSfG90DTj0hI1Vf0J9tD9U5YjV8Y0Trc6rCAjCvom4o+O7Ov1oEFqCpP5t5HIZGuSF8gCGjx4xBehpoRCLykAu6VNCL/RDlyWS931UUlIXWAznHyz37Ck+pVsBTz+Vzxmu+VZRMryYx4NKaAcv3c5BdzFXjZmmw/olN7EcEN4PQFw6DDzycHODI13tINRWebS0IeOIBdma2xJBQpJ0x+HWkqfhK6rNZJvVsPs3l9KOIybTc1C4geVLpNz5ZkhaMqPlpEidtLMPD1v0AfIXIXeSEYFTZTNZJLlQGp+w4rx+cXgUwW7ZjGiAPQ1ia696TWjnq4dnZPap/Gqyw2h6dIGk8uvnWubu74zfrEkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mathieu-Desnoyers/lib-Introduce-hierarchical-per-cpu-counters/20260111-231206
base:   next-20260109
patch link:    https://lore.kernel.org/r/20260111150249.1222944-4-mathieu.desnoyers%40efficios.com
patch subject: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
config: s390-randconfig-r071-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120452.VufCnz2j-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.3.0
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601120452.VufCnz2j-lkp@intel.com/

smatch warnings:
mm/oom_kill.c:392 oom_evaluate_task() error: uninitialized symbol 'points_min'.

vim +/points_min +392 mm/oom_kill.c

7c5f64f84483bd1 Vladimir Davydov  2016-10-07  322  static int oom_evaluate_task(struct task_struct *task, void *arg)
462607ecc519b19 David Rientjes    2012-07-31  323  {
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  324  	struct oom_control *oc = arg;
72456781289a6ed Mathieu Desnoyers 2026-01-11  325  	unsigned long accuracy_under = 0, accuracy_over = 0;
72456781289a6ed Mathieu Desnoyers 2026-01-11  326  	long points, points_min, points_max;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  327  
ac311a14c682dcd Shakeel Butt      2019-07-11  328  	if (oom_unkillable_task(task))
ac311a14c682dcd Shakeel Butt      2019-07-11  329  		goto next;
ac311a14c682dcd Shakeel Butt      2019-07-11  330  
ac311a14c682dcd Shakeel Butt      2019-07-11  331  	/* p may not have freeable memory in nodemask */
ac311a14c682dcd Shakeel Butt      2019-07-11  332  	if (!is_memcg_oom(oc) && !oom_cpuset_eligible(task, oc))
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  333  		goto next;
462607ecc519b19 David Rientjes    2012-07-31  334  
462607ecc519b19 David Rientjes    2012-07-31  335  	/*
462607ecc519b19 David Rientjes    2012-07-31  336  	 * This task already has access to memory reserves and is being killed.
a373966d1f64c04 Michal Hocko      2016-07-28  337  	 * Don't allow any other task to have access to the reserves unless
862e3073b3eed13 Michal Hocko      2016-10-07  338  	 * the task has MMF_OOM_SKIP because chances that it would release
a373966d1f64c04 Michal Hocko      2016-07-28  339  	 * any memory is quite low.
462607ecc519b19 David Rientjes    2012-07-31  340  	 */
862e3073b3eed13 Michal Hocko      2016-10-07  341  	if (!is_sysrq_oom(oc) && tsk_is_oom_victim(task)) {
12e423ba4eaed7b Lorenzo Stoakes   2025-08-12  342  		if (mm_flags_test(MMF_OOM_SKIP, task->signal->oom_mm))
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  343  			goto next;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  344  		goto abort;
a373966d1f64c04 Michal Hocko      2016-07-28  345  	}
462607ecc519b19 David Rientjes    2012-07-31  346  
e1e12d2f3104be8 David Rientjes    2012-12-11  347  	/*
e1e12d2f3104be8 David Rientjes    2012-12-11  348  	 * If task is allocating a lot of memory and has been marked to be
e1e12d2f3104be8 David Rientjes    2012-12-11  349  	 * killed first if it triggers an oom, then select it.
e1e12d2f3104be8 David Rientjes    2012-12-11  350  	 */
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  351  	if (oom_task_origin(task)) {
9066e5cfb73cdbc Yafang Shao       2020-08-11  352  		points = LONG_MAX;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  353  		goto select;

points_min is uninitialized.

7c5f64f84483bd1 Vladimir Davydov  2016-10-07  354  	}
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  355  
72456781289a6ed Mathieu Desnoyers 2026-01-11  356  	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
72456781289a6ed Mathieu Desnoyers 2026-01-11  357  	if (points != LONG_MIN) {
72456781289a6ed Mathieu Desnoyers 2026-01-11  358  		percpu_counter_tree_approximate_min_max_range(points,
72456781289a6ed Mathieu Desnoyers 2026-01-11  359  				accuracy_under, accuracy_over,
72456781289a6ed Mathieu Desnoyers 2026-01-11  360  				&points_min, &points_max);
72456781289a6ed Mathieu Desnoyers 2026-01-11  361  	}
72456781289a6ed Mathieu Desnoyers 2026-01-11  362  	if (oc->approximate) {
72456781289a6ed Mathieu Desnoyers 2026-01-11  363  		/*
72456781289a6ed Mathieu Desnoyers 2026-01-11  364  		 * Keep the process which has the highest minimum
72456781289a6ed Mathieu Desnoyers 2026-01-11  365  		 * possible points value based on approximation.
72456781289a6ed Mathieu Desnoyers 2026-01-11  366  		 */
72456781289a6ed Mathieu Desnoyers 2026-01-11  367  		if (points == LONG_MIN || points_min < oc->chosen_points)
72456781289a6ed Mathieu Desnoyers 2026-01-11  368  			goto next;
72456781289a6ed Mathieu Desnoyers 2026-01-11  369  	} else {
72456781289a6ed Mathieu Desnoyers 2026-01-11  370  		/*
72456781289a6ed Mathieu Desnoyers 2026-01-11  371  		 * Eliminate processes which are certainly below the
72456781289a6ed Mathieu Desnoyers 2026-01-11  372  		 * chosen points minimum possible value with an
72456781289a6ed Mathieu Desnoyers 2026-01-11  373  		 * approximation.
72456781289a6ed Mathieu Desnoyers 2026-01-11  374  		 */
72456781289a6ed Mathieu Desnoyers 2026-01-11  375  		if (points == LONG_MIN || (long)(points_max - oc->chosen_points) < 0)
72456781289a6ed Mathieu Desnoyers 2026-01-11  376  			goto next;
72456781289a6ed Mathieu Desnoyers 2026-01-11  377  
72456781289a6ed Mathieu Desnoyers 2026-01-11  378  		if (oc->nr_precise < max_precise_badness_sums) {
72456781289a6ed Mathieu Desnoyers 2026-01-11  379  			oc->nr_precise++;
72456781289a6ed Mathieu Desnoyers 2026-01-11  380  			/* Precise evaluation. */
72456781289a6ed Mathieu Desnoyers 2026-01-11  381  			points_min = points_max = points = oom_badness(task, oc->totalpages, false, NULL, NULL);
72456781289a6ed Mathieu Desnoyers 2026-01-11  382  			if (points == LONG_MIN || (long)(points - oc->chosen_points) < 0)
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  383  				goto next;
72456781289a6ed Mathieu Desnoyers 2026-01-11  384  		}
72456781289a6ed Mathieu Desnoyers 2026-01-11  385  	}
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  386  
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  387  select:
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  388  	if (oc->chosen)
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  389  		put_task_struct(oc->chosen);
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  390  	get_task_struct(task);
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  391  	oc->chosen = task;
72456781289a6ed Mathieu Desnoyers 2026-01-11 @392  	oc->chosen_points = points_min;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  393  next:
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  394  	return 0;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  395  abort:
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  396  	if (oc->chosen)
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  397  		put_task_struct(oc->chosen);
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  398  	oc->chosen = (void *)-1UL;
7c5f64f84483bd1 Vladimir Davydov  2016-10-07  399  	return 1;
462607ecc519b19 David Rientjes    2012-07-31  400  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


