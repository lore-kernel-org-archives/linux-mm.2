Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDC2CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEC38E0026; Mon, 17 Nov 2025 06:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EEF8E0003; Mon, 17 Nov 2025 06:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94DB38E0026; Mon, 17 Nov 2025 06:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 749728E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:37:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E59E160D03
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:37:08 +0000 (UTC)
X-FDA: 84119897736.27.24E1F2B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11B2D20005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:37:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763379426; a=rsa-sha256;
	cv=none;
	b=2T2kBcwx8l+vNr++vzaRL4w+VVpQ5/4AUEKdaDE4yLk3WrSSdouDl6M7gw+s+VewrnHusZ
	1KpDQOtGxeczlAVQ/m1KADbKtTx4EK9cI4bx0FsRQqEwKGzrygSkN/Lpjjh77bDZe5P2Tb
	8jDAcBOIM+hGDeC03ws+rQhKEmsogGM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763379426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6AvuNyk2iRPuJNt/YHM3ZBe7To2VTJIma6hKC5kzM0=;
	b=Js7W23KXnrejfzhbdAhQAKuiWrWTbeBZurdzbwtMf1/BUBcUi1z+9nUN+lhfyVFiwC8Shu
	d13uOZQp6FZI57bayrZ+DTA0XIMi9DNZRL5qJTeLe0czeAKyWV3LqgH30vVs3nQScgf+FG
	HMLn8524ak905edaF1KfIxeHC78EqgA=
X-AuditID: a67dfc5b-c2dff70000001609-d6-691b08dbee9d
Message-ID: <98c0907c-0435-45d2-bd68-e97598b79d0e@sk.com>
Date: Mon, 17 Nov 2025 20:36:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, Davidlohr Bueso <dave@stgolabs.net>,
 Fan Ni <nifan.cxl@gmail.com>, Gregory Price <gourry@gourry.net>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, Wei Xu <weixugc@google.com>,
 Xuezheng Chu <xuezhengchu@huawei.com>,
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, damon@lists.linux.dev, Yunjeong Mun <yunjeong.mun@sk.com>
Subject: Re: [Linux Memory Hotness and Promotion] Notes from October 23, 2025
To: SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>
References: <20251114014255.72884-1-sj@kernel.org>
Content-Language: ko
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20251114014255.72884-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsXC9ZZnke4dDulMg44bzBZLJ75jtnjy/zer
	xeqbaxgtft49zm6xauE1NovjW+exW9xb85/V4u+2vYwWbUs2MlnM+dvFaHH46xsmi/fXPrJb
	fH/LbPH1Th+Txeyj99gd+D1aL/1l89g56y67x4JNpR7dbZfZPVqOvGX12LSqk81j06dJ7B4v
	Ns9k9OhtfsfmMXV2vUfv+ldsAdxRXDYpqTmZZalF+nYJXBlbt35lKfieUnGzexVbA+M2/y5G
	Tg4JAROJU4uns8LYP+e9YQKxeQUsJX63bGAGsVkEVCVez/rBAhEXlDg58wmYLSogL3H/1gx2
	EJtZoI9Fout2VhcjB4ewgK/E+wUOIGERAXeJ/YuugI0XEjCS2L7sPlS5iMTszjaw8WwCahJX
	Xk4CW8spYCxxaf0+NogaM4murV2MELa8xPa3c4DquYDOXMUucfhnHzPEzZISB1fcYJnAKDgL
	yXmzkOyYhWTWLCSzFjCyrGIUyswry03MzDHRy6jMy6zQS87P3cQIjMpltX+idzB+uhB8iFGA
	g1GJh/fBDclMIdbEsuLK3EOMEhzMSiK87T4SmUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jb6V
	pwgJpCeWpGanphakFsFkmTg4pRoY9Sance+Lr13PGBXp+zL97ZlLaU91t2sY/N7Q8ZLh8We7
	9yqfnFfnmb03lNho+zxr4X+T+35lVs8kLWbIh5lEC2U7pd2M9c25ky4gnWOzNfRhrtd/q2DB
	V/ozohcqN0hz7NQ61rdQ6vAOg4jjn65pV26LyuDm1D9wg5NrG/dndm03be/eh9+VWIozEg21
	mIuKEwFdiq2KxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsXCNUNLT/c2h3SmQUe3vsXSie+YLZ78/81q
	sfrmGkaLn3ePs1usWniNzeL41nnsFofnnmS1uLfmP6vF3217GS3almxkspjzt4vR4vDXN0wW
	7699ZLf4/pbZ4uudPiaL39tWsFnMPnqP3UHQo/XSXzaPnbPusnss2FTq0d12md2j5chbVo9N
	qzrZPDZ9msTu8WLzTEaP3uZ3bB7fbnt4LH7xgclj6ux6j971r9gCeKO4bFJSczLLUov07RK4
	MrZu/cpS8D2l4mb3KrYGxm3+XYycHBICJhI/571hArF5BSwlfrdsYAaxWQRUJV7P+sECEReU
	ODnzCZgtKiAvcf/WDHYQm1mgj0Wi63ZWFyMHh7CAr8T7BQ4gYREBd4n9i66wgthCAkYS25fd
	hyoXkZjd2QY2nk1ATeLKy0lgazkFjCUurd/HBlFjJtG1tYsRwpaX2P52DvMERr5ZSK6YhWTU
	LCQts5C0LGBkWcUokplXlpuYmWOqV5ydUZmXWaGXnJ+7iREYdctq/0zcwfjlsvshRgEORiUe
	Xg0JqUwh1sSy4srcQ4wSHMxKIrztPhKZQrwpiZVVqUX58UWlOanFhxilOViUxHm9wlMThATS
	E0tSs1NTC1KLYLJMHJxSDYxR762ne2sdy35zPPH7tXWl63h+5pvMW9DNvvLAjfmME6Lu5yfE
	VKuXSX7zWfVE84yNgOC0p0edvBSZEn+/dus6NHvT9nJNjyW/L+Z/8kw64nTxW+i8jVOnrdTe
	rH6x7eoE4cvmBzv27jFf26aSsdpPudGrIO+C3sEUr/eMOq+LP62/6CO9+8xKJZbijERDLeai
	4kQAVyAIsbYCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 11B2D20005
X-Rspamd-Server: rspam07
X-Stat-Signature: bzt7qn3hy3oo6fq4yftc5gebs8ddxrt7
X-Rspam-User: 
X-HE-Tag: 1763379423-3764
X-HE-Meta: U2FsdGVkX18a9mugmm3+Aku6kp5z6pQF/uRc6y80nx5hvF9cCQgw1jpMclGHLaWNH7rYmek1o/oWPkQZQ4exIWLP5TKpjMDYlgxd6wuemQ7WMweTprZqFwZ9U1SJYEtq17JpsFIrDSTebL0FCBl+fWfmP0Z7BlOJR0KfwKTOJvXsJoUjR6TD/O4GPRJd+csUAWracIzQ3jyao+gK4q39x/VpqtcYLgxsuHHYY+x90YDVVMPC/F0CVmkH7iwKt9FUHtrh5/5zQYP3esYiV+PZg5/gfcYULbjEuOVrK8qko8kOZJ98SymEhmMWTbqBH8iGqT7fXN5AlFA6178XaaJrvM58hCqrw6AS8U+HgM7k1lL4Nl2ZFiMo8jrKzBtyRd+4sqg5uYCZUI2yQkdxNi6tHO483wch2DWgnACgW+X4K4Ex/KGbikdsRTrmjGBzQpDUlP2fftwpW7N5BmSzPGvSIL4GPGO9RzdnNWpiK4uKByTP0g5p7tKucElOZ0doEZ3wbl8uyUs6cAFg1b88B0wUdmufH4r4DATmICg1utGN1fhjpl46vpZLq6e9zdP+Vk4HbQjSOVq61ZAWSzRrnGOHb+aOfK7JFs3lw+XL5pV30x6yMCh0u9pKIutMCPHqJjAiCPEzUSjFnyCbbqupayGGXJtvrVAiprY61prlepM6bD//jX3Rv8gr6bfz1GtiZ2uaevQ33Yq3kMgmrUBWcKJg54YXTRMVAFOuhadhZ5b3/Sjw7lkYPkwYG3Ahnq8hv/R45EF1H0AQgX0Guxoac0E5qrYe3nVwpircis0fZhDjJbH/cnI3kvxMXLXwxrX97ombn0JT3dWOUTeI/h/kjhesTLGLvHydunFchwVZO8EjMJQQbINuH1M1OHyPEhdK1a9cXD+5I7V0NhS/x2infMDcOe8QgL3jmeqdH2V1BULEblFXwI1PUzkUvjvfUfWKB0EdhUYsxoZ8uZ+N4aT/N+1
 Q+xz11it
 2lkcXvW1fYIKLTPaIuUjQ1t77ypS7dDLCvYRInZfFxBAhX7VcEhVjbzCZeh5Tu3+PIeZuL6107Y85JTs/m44wXImhnKluIjgECvDO893/B4QtjHV9Qx4BP5SSPK1ZIx+M85SkLHwKCGWUVA1uaC3veHq3yAG9k9K4DlGwpIwy1FtVw7hDguSVHZ+hEXbZ4lpj121jyUkNUF6hlhg0D3DV8gNAw3JeJAmoxO1TmbqZRPtSb3ktrjPK26ObzNY5WMEJ3kl/TmlEZcrpqathSPiXd7ozUxIz4MaZ1pjarCSlB1argEOwq4LRzvVOKDPP9zkVuZ05YktoWG7CcYTH8shh5YzhIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ, David, Ravi and all,

On 11/14/2025 10:42 AM, SeongJae Park wrote:
> 
> Cc-ing HMSDK developers and DAMON mailing list.

Thanks for sharing with us.

AFAIU, the discussion is about whether to use bandwidth information as a metric
for page migration in addition to page temperature information.

In general, I think this makes sense in theory but would like to find if there
are some practical workloads that can get benefits from this work.

I've left some comments below.

> On Sun, 2 Nov 2025 16:41:19 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
>> Hi everybody,
>>
>> Here are the notes from the last Linux Memory Hotness and Promotion call
>> that happened on Thursday, October 9.  Thanks to everybody who was
>> involved!
>>
>> These notes are intended to bring people up to speed who could not attend
>> the call as well as keep the conversation going in between meetings.
> 
> I was unable to join the call due to a conflict.  This note is very helpful.
> Thank you for taking and sharing this note, David!

I also see that this summary is very helpful. Thanks very much David!

BTW, could anyone please add me and Yunjeong in the cc list? I was aware of this
meeting but couldn't be able to join because the meeting time is right after
midnight here in Korea. (1:30am)

If anyone add us in the cc list, then we will try to follow the discussion based
on the summary.

>>
>> ----->o-----
>> Ravi Jonnalagadda presented dynamic interleaving slides, co-developed with
>> Bijan Tabatabai, discussing the current approach of promoting all hot
>> pages into DRAM tier and demoting all cold pages.  If the bandwidth
>> utilization is high, it will saturate the top tier even though there is
>> bandwidth available on the lower tier.  The preference was to demote cold
>> pages when under-utilizing memory in the top tier and then interleave hot
>> pages to maximize bandwidth utilization.  For Ravi's experimentation, this
>> has been 3/4 of maximum write bandwidth for the top tier.  If this
>> threshold is not reached, memory is demoted.

I also think that this sounds right.

> I had a grateful chance to discuss about above in more detail with Ravi.
> Sharing my detailed thoughts here, too.
> 
> I agree to the concern.  I also heard similar concerns for general
> latency-aware memory tiering approaches from multiple people in the past.
> 
> The memory capacity extension solution of HMSDK [1], which is developed by SK
> Hynix, is one good example.  To my understanding (please correct me if I'm
> wrong), HMSDK is providing separate solutions for bandwidth and capacity
> expansions.  The user should first understand whether their workload is
> bandwidth-hungry or capacity-hungry, and select a proper solution.  I suspect
> the concern from Ravi was one of the reasons.

Yeah, your understanding is correct in HMSDK cases.

> I also recently developed a DAMON-based memory tiering approach [2] that
> implementing the main idea of TPP [3]: promoting and demoting hot and cold
> pages aiming a level of the faster node's space utilization.  I didn't see the
> bandwidth issue from my simple tests of it, but I think the very same problem
> can be applied to both DAMON-based approach and the original TPP
> implementation.
> 
>>
>> Ravi suggested adaptive interleaving of memory to optimize both bandwidth
>> and capacity utilization.  He suggested an approach of a migrator in
>> kernel space and a calibrator in userspace.  The calibrator would monitor
>> system bandwidth utilization and, using different weights, determine the
>> optimal weights for interleaving the hot pages for the highest bandwidth.

I also think that monitoring bandwidth makes sense.  We recently released a
tool called bwprof for bandwidth recording and monitoring based on intel pcm.
https://github.com/skhynix/hmsdk/blob/hmsdk-v4.0/tools/bwprof/bwprof.cc

This tool can be slightly changed to monitor bandwidth and write it to some
sysfs interface knobs for this purpose.

>> If bandwidth saturation is not hit, only cold pages get demoted.  The
>> migrator reads the target interleave ratio and rearrange the hot pages
>> from the calibrator and demotes cold pages to the target node.  Currently
>> this uses DAMOS policies, Migrate_hot and Migrate_cold.
> 
> This implementation makes sense to me, especially if the aimed use case is for
> specific virtual address spaces.

I think the current issues of adaptive weighted interleave are as follows.
1. The adaptive interleaving only works for virtual address mode.
2. It scans the entire pages and redistributes them based on the given weight
    ratios so it limits the general usage as of now.

> Nevertheless, if a physical address space
> based version is also an option, I think there could be yet another way to
> achive the goal (optimizing both bandwidth and capacity).

3. As mentioned above, having physical address mode is needed, but it makes
    scanning the entire physical address space and redistribute them and it
    might require too much overhead in practice.

> My idea is tweaking TPP idea a little bit: migrate pages among NUMA nodees
> aiming a level of both space and bandwidth utilization of the faster (e.g.,
> DRAM) node.  In more detail, do the hot pages promotion and cold pages
> demotions for the target level of faster node space utilization, same to the
> original TPP idea.  But, stop the hot page promotions if the memory bandwidth
> consumption of the faster node exceeds a level.  In the case, instead, start
> demoting _hot_ pages until the memory bandwidth consumption on the faster node
> decreases below the limit level.

I also think this approach is more practical because it doesn't scan and
redistribute the entire pages while lowering bandwidth pressure for the fast
tier node.

> I think this idea could easily be prototyped by extending the
> DAMON-based TPP implementation [2].  Let me briefly explain the prototyping
> idea assuming the readers are familiar with the DAMON-based TPP implementation.
> If you are not familiar with, please feel free to ask questions to me, or refer
> to the cover letter [2] of the patch series.
> 
> First, add another DAMOS quota goal for the hot pages promotion scheme.  The
> goal will aim to achieve a high level memory bandwidth consumption of the
> faster node.  The target level will be reasonably high but not too high to keep
> head room remained.  So the hot pages promotion scheme will be activated at the
> beginning, promote hot pages, make the faster node's space and bandwidth
> utilization increase.  But if the memory bandwidth consumption of the faster
> node surpasses the target leevel as a result of the hot pages promotion or the
> workload's access pattern change, the hot pages promotion scheme will be less
> aggressive and eventually stop.
> 
> Second, add another DAMOS scheme to the faster node access monitoring DAMON
> context.  The new scheme does hot pages demotion with a quota goal that aim to
> make unused (free, or available) memory bandwidth of the faster node a headroom
> level.  This scheme will do nothing at the beginning of the system since the
> faster node may have available (unused) memory bandwidth more than the headroom
> level.  This scheme will start the hot pages demotion once the faster node's
> available memory bandwidth becomes less than the desired headroom level, due to
> increased loads or the hot pages promotion.  And once the unused memory
> bandwidth of the faster node becomes higher than the head room level as a
> result of the hot pages demotion or access pattern change, the hot pages
> demotion will be deactivated again.
> 
> For example, a change like below can be made to the simple DAMON-based TPP
> implementation [4].
> 
> diff --git a/scripts/mem_tier.sh b/scripts/mem_tier.sh
> index 9e685751..83757fa9 100644
> --- a/scripts/mem_tier.sh
> +++ b/scripts/mem_tier.sh
> @@ -30,16 +30,25 @@ fi
>   "$damo_bin" module stat write enabled N
>   "$damo_bin" start \
>          --numa_node 0 --monitoring_intervals_goal 4% 3 5ms 10s \
> +               `# demote cold pages for faster node headroom space` \
>                  --damos_action migrate_cold 1 --damos_access_rate 0% 0% \
>                  --damos_apply_interval 1s \
>                  --damos_quota_interval 1s --damos_quota_space 200MB \
>                  --damos_quota_goal node_mem_free_bp 0.5% 0 \
>                  --damos_filter reject young \
> +               `# demote hot pages for faster node headroom bandwidth` \
> +               --damos_action migrate_hot 1 --damos_access_rate 5% max \
> +                       --damos_apply_interval 1s \
> +                       --damos_quota_interval 1s --damos_quota_space 200MB \
> +                       --damos_quota_goal node_membw_free_bp 5% 0 \
> +                       --damos_filter allow young \
>          --numa_node 1 --monitoring_intervals_goal 4% 3 5ms 10s \
> +               `# promote hot pages for faster node space/bandwidth high utilization` \
>                  --damos_action migrate_hot 0 --damos_access_rate 5% max \
>                  --damos_apply_interval 1s \
>                  --damos_quota_interval 1s --damos_quota_space 200MB \
>                  --damos_quota_goal node_mem_used_bp 99.7% 0 \
> +               --damos_quota_goal node_membw_used_bp 95% 0 \
>                  --damos_filter allow young \
> -               --damos_nr_quota_goals 1 1 --damos_nr_filters 1 1 \
> -       --nr_targets 1 1 --nr_schemes 1 1 --nr_ctxs 1 1
> +               --damos_nr_quota_goals 1 1 2 --damos_nr_filters 1 1 1 \
> +       --nr_targets 1 1 --nr_schemes 2 1 --nr_ctxs 1 1
> 
> "node_membw_free_bp" and "node_membw_used_bp" are _imaginary_ DAMOS quota goal
> metrics representing the available (unused) or consuming level of memory
> bandiwdth of a given NUMA node.  Those are imaginery ones that arenot supported
> on DAMON of today.  If this idea makes sense, we may develop the support of the
> metrics.

I think this makes sense.

> But even before the metrics are implemented, we could prototype this for early
> proof of concepts by setting the DAMOS quota goals using the user_input goal
> metric [5] and run a user-space program that measures the memory bandwidth of
> the faster node and feeds it to DAMON using the DAMON sysfs interface.
> 
> Implementing both the memory bandwidth/space utilization monitoring and the
> quota auto-tuning logic on user-space, and directly adjusting the quotas of
> DAMOS schemes instead of using the quota goals could also be an option.
> 
> I have no plan to implement the "node_membw_{free,used}_bp" quota goal metrics
> or do the user_input based prototyping at the moment.  But, as always, if you
> watn the features and/or willing to step up for development of the features, I
> will be happy to help.
> 
> [...]
>> Ravi suggested hotness information need not be used exclusively for
>> promotion and that there is an advantage seen in rearranging hot pages
>> based on weights.  He also suggested a standard subsystem that can provide
>> bandwidth information would be very useful (including sources such as IBS,
>> PEBS, and PMU sources).
> 
> If we decide to implement the above per-node memory bandwidth based DAMOS quota
> goal metrics, I think this standard subsystem could also be useful for the
> implementation.

As I mentioned at the top of this mail, I think this work makes sense in theory
but would like to find some practical workloads that can get benefits from this
work.  It would be grateful if someone can share practical use cases in large
scale memory systems.

Thanks,
Honggyu

> FYI, users can _estimate_ memory bandwidth of the system or workloads from
> DAMON's monitoring results snapshot.  For example, if DAMON is seeing a 1 GiB
> memory region that is consistently being accessed about 10 times per second, we
> can estimate it is consuming 10 GiB/s memory bandwidth.
> 
> DAMON user-space tool provides this estimated bandwidth per monitoring results
> snapshot with 'damo report access' command.  DAMON_STAT module, which is
> recently developed for providing system wide high level data access pattern in
> an easy way, also provides this _estimated_ memory bandwidth usage.
> 
> [1] https://events.linuxfoundation.org/open-source-summit-korea/program/schedule/
> [2] https://lore.kernel.org/all/20250420194030.75838-1-sj@kernel.org/
> [3] https://symbioticlab.org/publications/files/tpp:asplos23/tpp-asplos23.pdf
> [4] https://github.com/damonitor/damo/blob/v3.0.4/scripts/mem_tier.sh
> [5] https://docs.kernel.org/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
> 
> 
> Thanks,
> SJ
> 
> [...]
> 


