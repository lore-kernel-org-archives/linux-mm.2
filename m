Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66110CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDF76B0088; Mon, 25 May 2026 05:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F236B008C; Mon, 25 May 2026 05:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684856B0093; Mon, 25 May 2026 05:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 574416B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:20:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF27F1A01B7
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:20:28 +0000 (UTC)
X-FDA: 84805396536.15.160F37F
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9EC1B1A0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:20:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779700827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X1qPYCzAk8xtDd9gO6FlhvwHDJo8UlRAZy58F7EbhLs=;
	b=m2nH9o2SG6cj3boZNpbL6L28f1aI+E8KkyodKkeP/KB/2Kp4fPtM1gZ54MeVear8pPpWqu
	OIDsyZGWI00Pz4cugSwINlDUibRa3rN+GvPAnfvDQcOXCPW9Den4ZG9xZFG5NpJ6Dp8wLq
	SgafoTPLTFGm9aDB7O0LXdl7Rq3LIDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779700827; a=rsa-sha256;
	cv=none;
	b=qFm1DCVuiAKKuR9TDucLkLpe5g5Kczsh95YltVZDOApJxa6VZ3c8UvFW9iB6ahGWJhHGRo
	BARWtmj8N6mB6M3adi716jamntXCiPm9GF5s4xjfAq0SWJ/6YbnNnOKIVsUoC3wMN/s0Gi
	69ZeLWQCirHUs5K2LsoLxc/JCAhLNxA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of zengheng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=zengheng@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gP9Lk3CxMzYQtm9
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:19:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1FA254058C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:20:19 +0800 (CST)
Received: from [10.174.179.37] (unknown [10.174.179.37])
	by APP4 (Coremail) with SMTP id gCh0CgCXX1tOFBRqJtpJDg--.2213S3;
	Mon, 25 May 2026 17:20:16 +0800 (CST)
Message-ID: <f5b7460a-5719-bdb2-c53b-413468857f57@huaweicloud.com>
Date: Mon, 25 May 2026 17:20:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] arm64: tlb: Flush walk cache when unsharing PMD tables
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 akpm@linux-foundation.org, npiggin@gmail.com, aneesh.kumar@kernel.org,
 peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, zengheng4@huawei.com, sunnanyong@huawei.com,
 blingxue@tencent.com
References: <20260521073011.4121277-1-zengheng@huaweicloud.com>
 <177944657885.252010.9796978866224637120.b4-ty@arm.com>
From: Zeng Heng <zengheng@huaweicloud.com>
In-Reply-To: <177944657885.252010.9796978866224637120.b4-ty@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXX1tOFBRqJtpJDg--.2213S3
X-Coremail-Antispam: 1UD129KBjvdXoWrury7ur13Cr4kKFyUJw1fJFb_yoWDKrX_XF
	WDA34Duws8Jw4UGa9IyrsrJr9Yga1jqF98Ar15ZayfAF9xXa93JrZ2gw4fCa15WaykWFZ2
	kwn5Z3Wagr4IkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUba8YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_JFC_Wr1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI
	1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: p2hqwxhhqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EC1B1A0003
X-Stat-Signature: 8df4yobdreqy4zi5wp5r6p7xb1eaz9gd
X-Rspamd-Server: rspam06
X-HE-Tag: 1779700824-375555
X-HE-Meta: U2FsdGVkX19DmXrbPnbcZhgY7Szar8ZtRKe9Ws6xlU3Bs8E3zM4YuUpnZvooIR+UD7yvsaOTUmU+E3iz1OFB412V6sX61ZWPbKMtIbZ12zCPTsjpgUWunXzGdKUxJj8Erfj0XT7bAAcDHo3+Xg4s/JwMHX/YlFH+enh9Dp0hI2z6et/2aXnokuuTgsiCffXu5kS0+Okab3PNOo8afqSpy3IQthvEEbebI2drPZqB3Mag2/G7thrLWXKMkMh+ORHXY3Htjwi+AaM9+mpAif4NrzPLYI03bDxn+EDYU5G3ZlnxRs+xd/akhwxz2VFwVpgU+PEUghtiHbljsCr8o76rjIQeQa2xNcyEJLpHzMRnybpbVv30/b3MyqGS/rcQNRzXBmUyq3Oo+YyCgWl+vMiZWW8vZ/vBlXxLu4R17hSiJRa6M8dGaYakyaAXv2rOyHZxKk6k8Ne3mdu4OA51dHXhB7tS5muDKy/uokFRfzqUzHIdB8vc2Y/JyYHvNcrQeRtXbRxJZZY7hO7u2kq96WnPIcffSl2QnAPx3DztbrWDgCjT0g9pkoSMElOjhV823YQc4UR0W1UeABAVPzpMj+TcE08uU2bH3dhfbtxqotWXCMS0x4B+sYW+ljDvst/4EOtN+3TCgOb+ahuRh0EbBYfKG3O6k3a4qyYvJ3BFqGUdGf1WEaU+c+4qFeR2J/95mOxZ7bUDvYtK08tZaI0Mqkd0UeYJRgMTo/GRIq2rr1Va1WSeu3HnNCPwSOw7lNgvpwoqhcnskwd6DFQ1XDHTrfq+5DZOMeG6Ev2HPtPf0w3ynr8MVEAtEgRbKvqHY/RJUBwW+OcvAZ8KTglxfAAqhiS+l3aONstSeU7FXqimhwQsM6qb7H98MFFmN142DkzDoXfFPERpZ9lN+Il65zw/vUaN7E/8XTWIJaf23xfcZ1q3yCf/ZlDhWEQjsV8luhKWZytmMCXvmgcyxb/k6y41Sg5
 jy+DJ1F/
 c5zTwb913wSP8FUqcirgQrFCNUwMiclVRiGODViub4NoNWTxiKXCP7Ht0M5aZ+WzR6XPN3f4xt5JdVgoRr818Lr2ctf8+0ky+JasUACgFM97c+EekFAMTzCT/9rp9GAVXO6nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Catalin,


On 2026/5/22 18:42, Catalin Marinas wrote:
> On Thu, 21 May 2026 15:30:11 +0800, Zeng Heng wrote:
>> When huge_pmd_unshare() is called to unshare a PMD table, the
>> tlb_unshare_pmd_ptdesc() function sets tlb->unshared_tables=true
>> but the aarch64 tlb_flush() only checked tlb->freed_tables to
>> determine whether to use TLBF_NONE (vae1is, invalidates walk
>> cache) or TLBF_NOWALKCACHE (vale1is, leaf-only).
>>
>> This caused the stale PMD page table entry to remain in the walk cache
>> after unshare, potentially leading to incorrect page table walks.
>>
>> [...]
> Applied to arm64 (for-next/fixes), thanks!
>
> [1/1] arm64: tlb: Flush walk cache when unsharing PMD tables
>        https://git.kernel.org/arm64/c/c2ff4764e03e

This original issue was reported by our customer, who also participated
in the root cause analysis and resolution.

Could you please help add the below tags:

Co-developed-by: Xue Xiaowei <blingxue@tencent.com>
Signed-off-by: Xue Xiaowei <blingxue@tencent.com>

Thank you in advance.


Best regards,
Zeng Heng


