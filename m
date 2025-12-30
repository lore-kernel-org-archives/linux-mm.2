Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1CE2E95A8C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 13:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41836B0005; Tue, 30 Dec 2025 08:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFB86B0089; Tue, 30 Dec 2025 08:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDB16B008A; Tue, 30 Dec 2025 08:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD70F6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:25:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76021953CC
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:25:10 +0000 (UTC)
X-FDA: 84276208380.11.B375A21
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40C35A0007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:25:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767101108; a=rsa-sha256;
	cv=none;
	b=iDJPNJLc3f5msMcuvP60Ezds5Xi507txl6IdqfRtNHBByzOzUNjvYFBw9X+JdNRhZaoZiV
	EYERCifJq5FgzwApM0MMv/sSXirsEoHjPIHxGWh5gxIkrfjdGfa/QJrclHeuA7PyFw64r7
	4XjMZ0SiSYmj1Mnmd+q/0b3j2KkPRTY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767101108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PXJDmpjXWca0v7gUPR7ngrX+Kf+HJ+gV7pJXFGSYVvo=;
	b=uMTk1Er9uPQo6eqPjjfLcdO7FxbQEbRxOkK0XiMVO9BjnEl9HzEGkviwaGaN9wLs33ytP+
	+imKHRCiepwxUigNEJmswtRkVTUCDdpc5lCLwNPVTwtt8z9wZMihyF/ThPLuvlxqWaEHXq
	kXGVqh/UXos2VuOyEoqqSSuLJ9lh6to=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dgYhT5MqKzYQtjp
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:24:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 869AC4056B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:24:58 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAniPim0lNpM+wYCA--.38240S2;
	Tue, 30 Dec 2025 21:24:56 +0800 (CST)
Message-ID: <31d3fdfa-799e-426b-bb64-42e06392f0b4@huaweicloud.com>
Date: Tue, 30 Dec 2025 21:24:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/3] Memory Controller eBPF support
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Zhu <hui.zhu@linux.dev>, jiayuan.chen@linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>, davem@davemloft.net,
 Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1767012332.git.zhuhui@kylinos.cn>
 <enlefo5mmoha2htsrvv76tdmj6yum4jan6hgym76adtpxuhvrp@aug6qh3ocde5>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <enlefo5mmoha2htsrvv76tdmj6yum4jan6hgym76adtpxuhvrp@aug6qh3ocde5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAniPim0lNpM+wYCA--.38240S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4kAFW7Zw4xJr18tryxXwb_yoW8tw17pF
	WkKFy8WFWkXw17tw4kZ39F9a1Iv395Gr43KFn3Jry7K3ZFqr12vr4Iyr4UuFZrZFnxtr10
	vryY9w4ku3Z0v3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 40C35A0007
X-Stat-Signature: nto713y1795ndkq3kq83ke7hjfyfnmmi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767101104-489344
X-HE-Meta: U2FsdGVkX19nc1a2bWcI7O74+bbiqrYjZjy+I9Sv4J/duDOq2Mf1RQDRh5HbvRf37QyoIdY17I9gDrRYdOM7Eg9+shG9NaLI33+j+7ek/HpKs5igw929rKOmacDUlk1/oKVSFpPy5WBc3TaUrn2U1x+QhGbhS+2km4w9tcNyKvW+UTpc08rMszKK0u1DPwmHFQwSXpApXvb0utDi7/gkpf2RCAJ3GkgEUdC5EXrzZadfJkb4lkqhNQHj6tXliC1YErElDdduVlJ3Bh5SaFClqEkJTVMANsraOpDCv4vswbvrCBlntOcl+3YPilXCkb7ry3cDbSFPwLVCI8KIijMRwgkncjEYnvWUF6p6sJZpyMUeYyLW9OzV/VexNY/7IxlZt0lFwspaCABFN3z7CoaJpBX79BuOTmd6oaC3zqA93C56AwVCQ7GpbFg5iUGXtzH7yAqbO0so1Go19qINXkv3MN4o80mmkhgXg19CAgWhBfV8Mx4585olzGtx1wfVtTozT7UM4zLFX/Z3IzSh0JKilukR3BiWS2kmUI60stx7TEne6xPiw/ZYwQqk0GTLtRXxGxJ9Wt6p5abEH/gnUddSy2hb8oAOttyJewgPyBA6CQVewuQcCm+/q1I4dAz7gClHn2qeo3ClrRa1tUq339Il9sJiXE8jXSzP7QjMb45+9jN6ACLtj8L6AmhmJFADCJyisLHzTQv04Shk5SlmXCCDnkta/Sp711Qbi+eC40z9S11pTlqjvm7v3VV+IkIyjoXHCjvipnw7peMC0AjhAbzL/ifOPWlrJHFe2GsmIS7bijR/sl7Bh8X5XJkVCpsd4JMKwpO5Zfdo71aE9+E2amjoBNTXdtLPGknV11fn31CMzo5BePu6wYVgaQxFoyIhN4l/DZng6fXB//0V68oEA0/sHn3aDat1cSXlHtCFGG3TyvK3d7LjEMzTof+fKGCgeCvn3qjkc9EgXjGG13j1esR
 RzBCGXl4
 Dyr+kBvAiXu+cbD3WHgbGUH05+frTnDDw9c06M4n7Z5Gm/9h+YMCAOz5o3lW1f+RwrDX4ICpPPEblH2XUK6Wt1rNv4y+IQ9AW0CKZpqbW9s08q082QyO0xGLOsYviw/NKKwuAjIgPLOo2bXL464R3j9qlsSiC8xfDaJsF2NS8yZpwU011UDCI/haK6h+Z7qXvyfPwaPwhzZHgFllbyp7ledbOkKUY7H/PzisRO3L6mcvUkNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/30 17:49, Michal Koutný wrote:
> Hi Hui.
> 
> On Tue, Dec 30, 2025 at 11:01:58AM +0800, Hui Zhu <hui.zhu@linux.dev> wrote:
>> This allows administrators to suppress low-priority cgroups' memory
>> usage based on custom policies implemented in BPF programs.
> 
> BTW memory.low was conceived as a work-conserving mechanism for
> prioritization of different workloads. Have you tried that? No need to
> go directly to (high) limits. (<- Main question, below are some
> secondary implementation questions/remarks.)
> 
> ...
>> This series introduces a BPF hook that allows reporting
>> additional "pages over high" for specific cgroups, effectively
>> increasing memory pressure and throttling for lower-priority
>> workloads when higher-priority cgroups need resources.
> 
> Have you considered hooking into calculate_high_delay() instead? (That
> function has undergone some evolution so it'd seem like the candidate
> for BPFication.)
> 

+1

This issue[1] might be resolved by hooking into calculate_high_delay().

[1] https://lore.kernel.org/cgroups/4txrfjc5lqkmydmsesfq3l5drmzdio6pkmtfb64sk3ld6bwkhs@w4dkn76s4dbo/T/#t

> ...
>> 3. Cgroup hierarchy management (inheritance during online/offline)
> 
> I see you're copying the program upon memcg creation.
> Configuration copies aren't such a good way to properly handle
> hierarchical behavior.
> I wonder if this could follow the more generic pattern of how BPF progs
> are evaluated in hierarchies, see BPF_F_ALLOW_OVERRIDE and
> BPF_F_ALLOW_MULTI.
> 
> 
>> Example Results
> ...
>> Results show the low-priority cgroup (/sys/fs/cgroup/low) was
>> significantly throttled:
>> - High-priority cgroup: 21,033,377 bogo ops at 347,825 ops/s
>> - Low-priority cgroup: 11,568 bogo ops at 177 ops/s
>>
>> The stress-ng process in the low-priority cgroup experienced a
>> ~99.9% slowdown in memory operations compared to the
>> high-priority cgroup, demonstrating effective priority
>> enforcement through BPF-controlled memory pressure.
> 
> As a demonstrator, it'd be good to compare this with a baseline without
> any extra progs, e.g. show that high-prio performed better and low-prio
> wasn't throttled for nothing.
> 
> Thanks,
> Michal

-- 
Best regards,
Ridong


