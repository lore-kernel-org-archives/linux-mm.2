Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF294CA0EFC
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 12:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2288E00A6; Fri, 22 Aug 2025 08:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1548E009D; Fri, 22 Aug 2025 08:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE3B8E00A6; Fri, 22 Aug 2025 08:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F18988E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:06:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 920BB14013B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:06:23 +0000 (UTC)
X-FDA: 83804265846.21.0200A66
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF64C1C000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:06:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=N1or8S1w;
	spf=pass (imf20.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755864381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccPu4bTJVH4YGNhd1S906YfRzpqLPlcWMDklK0KtHtk=;
	b=QUCatEtyuaqt5SIW6BJcDdigTZYLjlInfutE3vdJBKTf3M2w43wS9PQB81nVkN+QWwdy38
	J6xMHpLzpqVEtmNPFERfv/YF9HfBGc2Sh6A5nV1XFsBgs7/6rjLpUT85tRROB7Hdslpk82
	K4M5dI6muIINRbgVW9YR1Sgkq1EVJ0M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=N1or8S1w;
	spf=pass (imf20.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755864381; a=rsa-sha256;
	cv=none;
	b=Yy+3PiwnWT3FGCWnFr4N9spn8fVot3frB8dBvOB8kJDZA0KaE6fVesyO6XcxTrOSQrbpTL
	1Fn0nqe4cscr+cZcsGFKxc/Wu/GUPOJZjHKRtkAHTRxefuCnKGGksq2WMcZxBRjkqG0MK7
	QSg5+z+Yk+dGArMzEA9j9N9KGk1MMBg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ccPu4bTJVH4YGNhd1S906YfRzpqLPlcWMDklK0KtHtk=; b=N1or8S1wu8Iw+g1rx1tY+aHF+Y
	OzAyfUAzK8J2Z61/AEiyJ3Qk24qEEMGRAcZMNoCMxWGUI+CTgbX4i7JUQ0KnbKcB9nRGSsFNxEwJM
	3Aan6Zj4SGMOu4KtTD8+6UrIpJW3T0pIRUCJPsRGRrrohotkoktao3y22E35AB9Qgb9w7oaSp9Ge4
	Ibuj0BDOpw7fglFc9tC65j9f2iqNQA3l2JZo+9p8xIHB17VLqigEljZP3VvEO4tGeRlVD5vhgjxU8
	QVUTc8TjdG3G/jlvRiGzO5xlmDUm38alEBLzxfHR8J6okyKECwdU69yPqalxl5125kJeQbJqkhBii
	sxSTDzlg==;
Received: from [223.233.71.242] (helo=[192.168.1.8])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1upQX9-0005Vq-8O; Fri, 22 Aug 2025 14:06:15 +0200
Message-ID: <dfb52ed4-8f18-1489-e6b4-56180cfa5440@igalia.com>
Date: Fri, 22 Aug 2025 17:36:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v8 3/5] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, Bhupesh <bhupesh@igalia.com>,
 akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 kernel-dev@igalia.com, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, laoar.shao@gmail.com,
 pmladek@suse.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
 arnaldo.melo@gmail.com, alexei.starovoitov@gmail.com,
 andrii.nakryiko@gmail.com, mirq-linux@rere.qmqm.pl, peterz@infradead.org,
 willy@infradead.org, david@redhat.com, viro@zeniv.linux.org.uk,
 keescook@chromium.org, ebiederm@xmission.com, brauner@kernel.org,
 jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
 mgorman@suse.de
References: <20250821102152.323367-4-bhupesh@igalia.com>
 <202508221127.LiaxcbdW-lkp@intel.com>
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <202508221127.LiaxcbdW-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF64C1C000F
X-Stat-Signature: ps83qj5h5h5do91hpxcmgqatnezua9ki
X-Rspam-User: 
X-HE-Tag: 1755864381-809377
X-HE-Meta: U2FsdGVkX18HNi5rWhMR4jd3061Ioet5k47B5LiVVImqErDwo7IEW2kr9l9TS33WNcI9Gq6fSlwWl1c10Yl+Gid9cXHTn8ZQ8rM3PTYO95JTtQ1Fvpa7slKHXkOHZ6Q3VohcPkib2SJz1Y+BYktPIh2QO+ic2YN7lwmUsLdIynsaZCZuT0rMjDdOwhc951n2xXlfuF9TRqHCHYe38HXyC9wy4cCr1oQ6HCIRFNlFOpjvdEBiU5Zcb8SlAGHCmK2eoQuBvD4oBU5hGsvUpUJJhsizUZlaCU2G1B79uyZrhE/1N3AhOm2umpKg5LcKDjsxzdI7SmggngFwrTTIVu8RDLAG02biczW8aILlFuA7/wofbh9jaTE+J1No53jAlv8UmU1kZ/8I2v2LFs/vcYUGpR7witqb0xBxWVtE8Ny7GkqV6ISZB8Q4CEMsK9Q5Bmt4rtEGBmWUAINP+L2FxqwdKZkwgq3B/oaxNigTw7Lyi2q5RrTTVTyPVZOHj51lOOxxBdaA0fxTfReRTd8SVKMaXNxoqf7pCU2JiQVrAz788xtUGkEqrLxT1Nj+esQTwNUgWEjGtXKeKWRX3xo9aU8ZyTcYDO0X0aR6jvJXJsBhtgO4IlB1YopOyU37I5ftDfhV2LYXEkWbfsiYdDxIk5AkmppuqIsWdPZ36s+QBX87sROfSS+arRsyoZ5DvYFEos0IDPG+VjadU+ORERTTOOxkzsDp0fajQACGXGedyKMJOcDOSCE8rXg70Oh1KM7bDfPUSXK6qqzCgQfOXF2d8Pzj3h4fGx+MpOyBlQL3U6ad51QCLuUERf96MWVgb4pCE3JhRt37oZoTp4UiOiI/LPktrFeye+PIogYdsNlGEU5W/yPrVnuIdXJicKqx2dtg7HO5Kutq8c/AOffIPosat8lNoTf2pHtp2XDv0h5WwqGq9aYj+dI564aeW/hrsOevwhRZ85J3rNGNnAeNNPUMAVw
 P5Tza4HO
 vESx3TjQnEeSOZwKC63/No+raN6YA7wO2dn31HqqY3I6zXjQEVlUQsuUYDJVdjRhlIBKw8Oz3+zQZ7YCGeNxXKAgEbZlkQh+31fHyezw3S+aff7+z2kVEIQFl277lSRpnON7Or80oii/uyVMaZeok9XLh61SmqRRMuEtqNVrl8QcskwEFI4iEa6YPBeJXrzRXssdovdUQfOrO5AzP2dpWORmdFHhgEr1ashbxKa+ccXDcnC2PUN2WkucjTQjUiVHB5dp62YrwN1ZLnwcR1OHpT5H1j0aTI5M0aDocqF/c26+YtMyu3YtDEAsu6QS4d7zcbe5ZvQWI+Bg97QxbUXs738CYiWn3ssO65YcnNMHrw9gBrRVrqjXrL3aaivcSfEIeH/LFbO0jS05G3NiDfLVepjhhHY2q81HihlObWF+gHProXW8gXQYxHE2ZLF3OLIxKaBnVsn9ZEUleK6m//GQhmYDuG09ywmM3towbnn2/g6tDoLHKiFfCk+UJeboEoTOKgJgXA5OpUsDf6kSwF0iQ6Z76hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 9:29 AM, kernel test robot wrote:
> Hi Bhupesh,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 5303936d609e09665deda94eaedf26a0e5c3a087]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250821-182426
> base:   5303936d609e09665deda94eaedf26a0e5c3a087
> patch link:    https://lore.kernel.org/r/20250821102152.323367-4-bhupesh%40igalia.com
> patch subject: [PATCH v8 3/5] treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
> config: x86_64-buildonly-randconfig-001-20250822 (https://download.01.org/0day-ci/archive/20250822/202508221127.LiaxcbdW-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250822/202508221127.LiaxcbdW-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508221127.LiaxcbdW-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>>> drivers/gpu/drm/panthor/panthor_sched.c:3420:2: error: call to undeclared function 'get_task_comm'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      3420 |         get_task_comm(group->task_info.comm, task);
>           |         ^
>     drivers/gpu/drm/panthor/panthor_sched.c:3420:2: note: did you mean 'get_task_mm'?
>     include/linux/sched/mm.h:151:26: note: 'get_task_mm' declared here
>       151 | extern struct mm_struct *get_task_mm(struct task_struct *task);
>           |                          ^
>     1 error generated.
>
>
> vim +/get_task_comm +3420 drivers/gpu/drm/panthor/panthor_sched.c
>
> de85488138247d Boris Brezillon 2024-02-29  3414
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3415  static void group_init_task_info(struct panthor_group *group)
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3416  {
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3417  	struct task_struct *task = current->group_leader;
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3418
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3419  	group->task_info.pid = task->pid;
> 33b9cb6dcda252 Chia-I Wu       2025-07-17 @3420  	get_task_comm(group->task_info.comm, task);
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3421  }
> 33b9cb6dcda252 Chia-I Wu       2025-07-17  3422
>
Ok, let me check the same and fix it in v9.

Thanks.

