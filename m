Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13379606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 04:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1063F6B00EF; Wed, 11 Nov 2026 23:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B76D6B05B0; Wed, 11 Nov 2026 23:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7F66B05B1; Wed, 11 Nov 2026 23:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFAB06B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:00:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54B92A0472
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:00:22 +0000 (UTC)
X-FDA: 85425114684.12.DB8BF7A
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf14.hostedemail.com (Postfix) with ESMTP id 910C3100004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:00:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794456019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KNv41jA8q+1vr1ybXb+ci7oKXbVrazZL7oRggdFyj4o=;
	b=O1dpb8tbl1cBkzAw1goRgQIwOxsQZcHr9YZkiQd+uLDSqU/e8JNVVBNsyMq5sMgM+CfALL
	Qb2ZhTMMvVleqt68omuXTy6DWanNNlyZl5tJndFA0gUBHG2fxVdiFTFSMNf1Ziw3b+mvJT
	rqv3M7RJ5BoEZ4nqGyJ5C7MC4FTSVr8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794456019;
	b=fW+w+nyKFNAzmsyaf5VbmhWHvMgJ65iUY49tFrbv1+/zUUZeVEffjmc3Bj9FZQ2rGPRV/0
	GWx0gi8Cr41ZlkCkVabIRmooNF4amN87oCU+iCxe0BD5NxUmNLDDosl9GVZuovu+SqYnmp
	+8xOL1jXN1F2q5ZTDwXJOPAJMtIeWpo=
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8AxX9PLOfVqpsoeAA--.23129S3;
	Thu, 12 Nov 2026 12:00:11 +0800 (CST)
Received: from [127.0.0.1] (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJBx5czIOfVq6uEzAA--.13029S2;
	Thu, 12 Nov 2026 12:00:09 +0800 (CST)
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
To: Huacai Chen <chenhuacai@loongson.cn>,
 Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <1c59d1d6-6ed2-f84e-49ce-2d1baeac6834@loongson.cn>
Date: Thu, 12 Nov 2026 12:00:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261111092421.3771992-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qMiowJBx5czIOfVq6uEzAA--.13029S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7GF45Jw47GrWxGrWfAr1kJFc_yoW3Xwc_KF
	4S9rWUCrW0vrsxG3ZFga1UZF17Z3409a1kW347trW3Xwnrt348Jrs7K3Z3Zw43KryxJrZ5
	Jan3Wr1avwn8AosvyTuYvTs0mTUanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbfkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUc0eHDUUUU
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 910C3100004
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ok3fhxde1nws5h6n1a88x9nqkey1r7ck
X-HE-Tag: 1794456017-292677
X-HE-Meta: U2FsdGVkX19fDi9Crdaltog8MymNjE+P+hyHfTSuhLTvQk7sKB7YyK6dHcC4X/Q5HawFjwpByIIzmvfwsEhQ1rihn7NCbFpdF5JBCXAlXTcJ06zR2ylmTmyO+RPTXDKIW2oqh8GwMYa7ak7bjg+5+XVojBk2SKMtwkLkQ3V9kZINz2we4e/8+EJCEdMSW0T/xrT5fkeOtR7YBJeXhiE5t8qd10jajFYcZezXOeVz7nvLDYu3FZ6nnKR6UH5f00cdcFvGo/lXFCShGfMQXUTj5KTKd55Kub3IhZ+VtfaD+D+gfJ1Qk3m3/ANo9cdiYumGgoEEr+ZDZUdKG2EtgXJIXLhkeEneLi8moz+MjJ6eNcJ77bKzftccae+VpII7vJzq9MFKjPNSa2p1+5+jgAnueTbV3Bh5b60VTeAM9/7vuXLtBIHHpGlp7G1Vd0Nj4RhNF5HSNyLv7YeMbPX9FK13uJhQ+BqNi4Svdlv1zMQnkTeaVM18bfC4G1bepeQ6SokEyAyhVLIH0OaZHJcxgUcUxrXSaPogbCRbgNuS54e958El/a1NKaxb6o+niXJlVdivzhJMnROfGUR123+SueFactJnivGRN26o3AKw/t6SbA32PsfOl1cgH9ukjpG3lj6ficr0YOSyd5HFb3K4q2MkSGf8POOIc+R1caVJFaTApU4k85YV9Wf2sT+mAPmxouZUcU5/rXAHZC7VELew5u9f4tIzOQZnnnBx+CydZ9rc2P+I1xcQuIMiJGwAoE/c5COPm+xJvJEM8uXDJs2Y61MCCzBG57dulPwDMn+j37keKhphqMeINdoYB9Dq4YRSJKkzpntrbkj78dlMRrp2l2m2PnQtA3Bj4ZHAfOunk1eL3/fVrnjWPjsGPSznXrgW/myytOlswyyy87GjyD0fGqRFzKioUwnUyHBywXTg1ysoC5vfCpVdSlxKg8NV/ormpPusMmvT4nf7JaY9vDLpEcz
 UxC3wa4h
 xmMJlNQVRD8CyPIJ2o4KZwuRDNOVxq+3c46XClYKDTBec/6J1ZMYv/ASuUzsvQecunRFDDs6tfilQLyjBpYx7oxyn7cBCOF9dPsdOLl+Gk/d7RUc5fbnG6+8Fz1xGX+wRV++hySYC4gttrvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 5:24 PM, Huacai Chen wrote:
> When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> calls to smp_processor_id() in preemptible contexts trigger some false
> positive "BUG: using smp_processor_id() in preemptible" warnings, which
> are harmless noise because the process always executes on CPU 0 and CPU
> migration is impossible.

...

> Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Hi all,

Just for reference, here is the related LoongArch patch that
fixes the specific callers in cacheinfo and local TLB flush:

LoongArch: Fix preemptible warnings in cacheinfo and local TLB flush
https://lore.kernel.org/loongarch/20261111113738.862-1-yangtiezhu@loongson.cn/T/#u

Thanks,
Tiezhu


