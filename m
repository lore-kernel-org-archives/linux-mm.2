Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E3E606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=F2haETcQ
Received: by kanga.kvack.org (Postfix)
	id A38FB6B05B1; Tue, 17 Nov 2026 01:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9D06B05B2; Tue, 17 Nov 2026 01:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8996B05B3; Tue, 17 Nov 2026 01:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6446B6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:39:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F403CA7D79
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:39:49 +0000 (UTC)
X-FDA: 85443660498.20.601CB61
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57474160003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:39:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F2haETcQ;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794897588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vyyeb7T7qeUDSVNFDSYs8COzLLUJ9wy6TmVNkRmGH10=;
	b=KpCRZElIt8aTS9q5Ct9Kr+nwoG/ZbN5cPL7pp/ba0Uet2WxCiz2Puw7c84GdJENRCpta03
	Oh++o2npw+hjUr6Ky4SVP9ZHlKLHEHPh5DIvLTsycxSg809wnDi/fy3BELE4CPTY5DdGmh
	x5DXyKqaq8g5OLsFdnHd/m05ai76Mw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794897588;
	b=ltGveou8s+tGZfpwuLgtU4AGmNTINjKyopFuEL8rwG9rVgRWF32e1cHUdtAg6+sffkUw2s
	ZJgpWCf062IYcNHwPtXxZoB9aED1iTchC4TDezYxzLrEV48yYNSGJ3DlVOwu7BRu36OX9t
	ADCNSR127chKLJlymvEUMxoKSVg9T4k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F2haETcQ;
	spf=pass (imf08.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Vyyeb7T7qeUDSVNFDSYs8COzLLUJ9wy6TmVNkRmGH10=;
	b=F2haETcQ46YGD322PYEjUhEVyENsxdG1FCM9hRUWF3f+Rdn3di0ztZoNSf38nMmzHwO4z6y/N
	CMBfyq/FYspNp/0tZEGtfMYwGbxeLt3PGhTVAuJl/N/WMxICMEB65MAWPy9+F2nYNTok0HJdF4X
	XVxl/OfaJvbD0TayyAcyPDA=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jTFSP3f8sz1T4Fv;
	Tue, 17 Nov 2026 14:39:01 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 92A2640561;
	Tue, 17 Nov 2026 14:39:39 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 14:39:37 +0800
Message-ID: <80ff9aea-3a5c-4c92-b713-99c249564008@huawei.com>
Date: Tue, 17 Nov 2026 14:39:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
To: "Serge E. Hallyn" <serge@hallyn.com>, "Andrew G. Morgan"
	<morgan@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, <kees@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <mingo@redhat.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <shuah@kernel.org>, <brauner@kernel.org>,
	<alexjlzheng@tencent.com>, <jannh@google.com>, <jaime.saguillo@gmail.com>,
	<elver@google.com>, <blbllhy@gmail.com>, <bvanassche@acm.org>,
	<pjw@kernel.org>, <broonie@kernel.org>, <debug@rivosinc.com>,
	<tglx@kernel.org>, <aleksey.oladko@virtuozzo.com>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com>
 <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
 <avHfxe++P4WLUQxf@hallyn.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <avHfxe++P4WLUQxf@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: 8i3ayq1j3cagjty11ij5m9m9bnkp3mfs
X-Rspam-User: 
X-Rspamd-Queue-Id: 57474160003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794897586-470719
X-HE-Meta: U2FsdGVkX1+Sapqn/hrt4hw5LZZpQFW7pXcQmm+7Qb1DGc4Q8195uJ8EKBfOqD2ni9W8M8pjcfotdgaAyMoN2OtrW+iSDxEzhgatPZlyI3VBRtMScrBMlix9bOpOvt6R3A5vr1QjQ/gWTYnd5yBNz6GLZ7F8cKm6J/xQsbIIctvn7NrZZKj1OUOPt1ioSyGLwlDuEs1lqwyD9XY34pnjzkStKULm5h5MxtajK/wRikRchaCo/Xm6J+mZu/pkQ0dEXq1/m/EDIk8ol2CSm+r0PRVUEMeGFE4L4d7Bj1kaEfzxhBNl8+Zuq/9sJXZoToIfXD482pPYkpvSL8fVVATyNgbSsizvVSGM2c8sok6nt/zww8FRI/0n9sP1Ll/1jFhYajI33vuQo7zeFt8IhwvhoMPnrTSTkxJggxy+Ulksd+LKamLjLB1Y5lI3B0Cun/ZM9fSTluhGILaVCETCjYB9IvLSpKW69WSi3ZbCkBxbIawjbUDJufufo40Xi/eivMkCEUjai3j3kIVlpksVCr8gGKQD2z1NVsGECSStvzjJy8HjsZui/J5qRtOLf0IpWKWvd0IlQ9yhfUMTdZ4iPpV7WqWg1j+0A1dFSirQFSCOHyOJkUyHwHimUB3TGpeKV/eRURdciY+u+wqpzJMCvogG9eVbLdk1jsGyqpZH0WjHrCP+8PWStCnQtgzp3xSBxL08i+XdgGW4rwl/BKQlb5A036cmm63q5G0N8VSA2V1CyMTy389orl370aNdDNwv9kEx+Y3ayOWTMQ+l8a5VPiOVrhqWG7PG6RjeoQSv89gyFFwxYw/ifnhN6YD9xS9yABgnHHVqPmkCB/ItTiexAh7DhxhUf1Q8T+cgjPKiDnFEFYJI0/qxQnbEj+m3xBho+yiJnlF/BTc80LLW6S/UqIwoJXOrQqZoV+oEHsdDPtr1mI5yj/Ht3NLBGTX+qkITGLtkVU5zQ/TlTg+6F3Pcjfo
 3Jf5kntr
 J8P0AdUjcw4WQLNXjd7V+d2TXIa23oaZFC1zKKCSIlQgzOe4CCkS8m/T+QDvGD7wbtw6FTs0DqN3mHPd94bVsUvAbH/NiEs/I7uoHL5D6Wh0ChuTfZl2Z0RuewGpmaQxeY0Gcsj0e93Hk0NHWC5vT593hHRYMlchloXXUxZrRIBRRzxDdfZPDHmUYoxktumA2W42gvP+g28RtPPlcG0VZwXiz3iLie5fIXRyU47cGvpulD3RnYLllla2ZL4891x3HQjgWMCyIHC77yyzV9xXbmwidftQV7ceo0Enupn0HUigzqnGZn9/d/Cvjb3EStifd6eNnSk33XIcFm1PV3fGAdYTc2xgqeqC7AMgEJJYtM0Ug9iM+Rz+8kMxBdeBr1vAkaq06ww2QWnCZUJf0wNVUgjTI36bYr76E/n1CYfDkks5gitigmQeDfh04Y3mqiLrkHmWC90o+dyOI2KKUsV+Q1kr4a9HCTcmXI1u9M9t736gA3iOa+H7u8NtSERizuldojtr3rzedkWzch7XGK3HJm6mRthPhfGLfX1K2hDv5msINp94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/9 22:59, Serge E. Hallyn 写道:
> Hi Jinjie,
> 
> how do you feel about adding something like a thread | process flag?

Hi Serge, Andrew,

Sorry for replying so late.

I think this sounds good for me, similar to seccomp's
SECCOMP_FILTER_FLAG_TSYNC: by default only the calling thread's bounding
set is trimmed (so a later fork() inherits it while the rest of the
process is untouched), and PR_CAPBSET_DROP_PROCESS applies it to the
whole thread group.

Is it similar to the following code?


#define PR_CAPBSET_DROP_MASK          <n>
#define PR_CAPBSET_DROP_THREAD         0
#define PR_CAPBSET_DROP_PROCESS        1

User space use as below:

	prctl(PR_CAPBSET_DROP_MASK, lo, hi, PR_CAPBSET_DROP_THREAD, 0);
	prctl(PR_CAPBSET_DROP_MASK, lo, hi, PR_CAPBSET_DROP_PROCESS, 0);

# cap_task_prctl()
case PR_CAPBSET_DROP_MASK:
        switch (arg4) {
        case PR_CAPBSET_DROP_THREAD:
                return cap_prctl_drop_mask(arg2, arg3, false);

        case PR_CAPBSET_DROP_PROCESS:
                return cap_prctl_drop_mask(arg2, arg3, true);

        default:
                return -EINVAL;
        }

static int cap_bset_drop_thread(kernel_cap_t mask)
{
        struct cred *new = prepare_creds();

        if (!new)
                return -ENOMEM;

        new->cap_bset = cap_drop(new->cap_bset, mask);
        return commit_creds(new);
}

Best regards,
Jinjie

> 
> On Wed, Oct 21, 2026 at 07:42:43AM -0700, Andrew G. Morgan wrote:
>> There are a number of situations where existing code wants to
>> (temporarily) affect the capabilities of a single thread, so a
>> subsequent fork() starts with those without affecting the parent
>> process as a whole. I've been wondering if this code could be
>> structured to allow an argument of the prctl() to indicate if the call
>> is "whole process" or "just this thread" scoped?
>>
>> Cheers
>>
>> Andrew
>>
>> On Wed, Oct 21, 2026 at 7:36 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>>
>>> On Tue, Sep 29, 2026 at 09:01:59PM +0800, Jinjie Ruan wrote:
>>>> PR_CAPBSET_DROP only affects the calling thread. Process-wide capability
>>>> dropping requires user space to loop over every thread and every
>>>> capability, which is highly expensive. For instance, long-lived
>>>> multi-threaded processes (like gVisor's sentry) spend milliseconds
>>>> trimming the bounding set because the runtime has to coordinate
>>>> and signal every thread.
>>>>
>>>> Add PR_CAPBSET_DROP_MASK, an opt-in prctl that removes a set of
>>>> capabilities from the entire thread group's bounding set in a single call.
>>>> The capabilities are specified via a 64-bit mask across arg2 (low 32 bits)
>>>> and arg3 (high 32 bits).
>>>>
>>>> The drop is recorded in a per-thread-group mask,
>>>> signal_struct::cap_bset_pending, under sighand->siglock. This pending drop
>>>> is dynamically folded into the bounding set in critical paths:
>>>> cap_capset(), PR_CAPBSET_READ(), and cap_bprm_creds_from_file().
>>>> Running, concurrently created, or future threads within the group will
>>>> all immediately observe the drop. A forked child inherits this mask
>>>> in cap_bset_drop_fork() under siglock to close the race window
>>>> against clone().
>>>>
>>>> The operation is drop-only, so concurrent callers commute and a single
>>>> atomic OR is the linearization point.  It performs no per-thread allocation
>>>> and only the caller's replacement cred can fail, reported synchronously as
>>>> -ENOMEM before anything changes.
>>>>
>>>> In an arm64 KVM guest, trimming 41 capabilities of a multi-threaded Go
>>>> process takes ~8.5-23.6ms with the per-thread PR_CAPBSET_DROP loop and
>>>> ~11-14us with PR_CAPBSET_DROP_MASK, independent of the thread count.
>>>>
>>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>>
>>> Interesting idea, storing it in the sighand.
>>>
>>> Oleg, do you see any issues with that part of this?
>>>
>>> Overall, this seems ok to me.  That is, I think it addresses all the
>>> concerns I had with the previous version.
>>>
>>>> ---
>>>>  fs/proc/array.c              |  3 +-
>>>>  include/linux/capability.h   |  5 ++
>>>>  include/linux/sched/signal.h |  8 ++++
>>>>  include/uapi/linux/prctl.h   |  1 +
>>>>  kernel/fork.c                |  1 +
>>>>  security/commoncap.c         | 91 ++++++++++++++++++++++++++++++++++--
>>>>  6 files changed, 105 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>>>> index f6f75d206762..f1cde26d079c 100644
>>>> --- a/fs/proc/array.c
>>>> +++ b/fs/proc/array.c
>>>> @@ -63,6 +63,7 @@
>>>>  #include <linux/tty.h>
>>>>  #include <linux/string.h>
>>>>  #include <linux/mman.h>
>>>> +#include <linux/capability.h>
>>>>  #include <linux/sched/mm.h>
>>>>  #include <linux/sched/numa_balancing.h>
>>>>  #include <linux/sched/task_stack.h>
>>>> @@ -318,7 +319,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>>>>       cap_inheritable = cred->cap_inheritable;
>>>>       cap_permitted   = cred->cap_permitted;
>>>>       cap_effective   = cred->cap_effective;
>>>> -     cap_bset        = cred->cap_bset;
>>>> +     cap_bset        = cap_bset_effective(p, cred);
>>>>       cap_ambient     = cred->cap_ambient;
>>>>       rcu_read_unlock();
>>>>
>>>> diff --git a/include/linux/capability.h b/include/linux/capability.h
>>>> index 7921a0b3b04a..6413c7fedb69 100644
>>>> --- a/include/linux/capability.h
>>>> +++ b/include/linux/capability.h
>>>> @@ -38,6 +38,7 @@ struct file;
>>>>  struct inode;
>>>>  struct dentry;
>>>>  struct task_struct;
>>>> +struct cred;
>>>>  struct user_namespace;
>>>>  struct mnt_idmap;
>>>>
>>>> @@ -197,6 +198,10 @@ bool capable_wrt_inode_uidgid(struct mnt_idmap *idmap,
>>>>                             const struct inode *inode, int cap);
>>>>  extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
>>>>  extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
>>>> +extern kernel_cap_t cap_bset_effective(const struct task_struct *task,
>>>> +                                    const struct cred *cred);
>>>> +extern void cap_bset_drop_fork(struct task_struct *p);
>>>> +
>>>>  static inline bool perfmon_capable(void)
>>>>  {
>>>>       return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
>>>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
>>>> index d45a5476b97d..bda6f18b65b9 100644
>>>> --- a/include/linux/sched/signal.h
>>>> +++ b/include/linux/sched/signal.h
>>>> @@ -98,6 +98,14 @@ struct signal_struct {
>>>>       int                     quick_threads;
>>>>       struct list_head        thread_head;
>>>>
>>>> +     /*
>>>> +      * Capabilities being removed from the bounding set of every thread in
>>>> +      * this group by PR_CAPBSET_DROP_MASK.  Read on capability-transition
>>>> +      * paths without sighand->siglock, hence atomic64 (a 64-bit value would
>>>> +      * otherwise tear on 32-bit).
>>>> +      */
>>>> +     atomic64_t              cap_bset_pending;
>>>> +
>>>>       wait_queue_head_t       wait_chldexit;  /* for wait4() */
>>>>
>>>>       /* current thread group signal load-balancing target: */
>>>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>>>> index b6ec6f693719..85ac71897070 100644
>>>> --- a/include/uapi/linux/prctl.h
>>>> +++ b/include/uapi/linux/prctl.h
>>>> @@ -70,6 +70,7 @@
>>>>  /* Get/set the capability bounding set (as per security/commoncap.c) */
>>>>  #define PR_CAPBSET_READ 23
>>>>  #define PR_CAPBSET_DROP 24
>>>> +#define PR_CAPBSET_DROP_MASK 82
>>>>
>>>>  /* Get/set the process' ability to use the timestamp counter instruction */
>>>>  #define PR_GET_TSC 25
>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>> index 5ef413368912..bf671a85d39d 100644
>>>> --- a/kernel/fork.c
>>>> +++ b/kernel/fork.c
>>>> @@ -2504,6 +2504,7 @@ __latent_entropy struct task_struct *copy_process(
>>>>        * before holding sighand lock.
>>>>        */
>>>>       copy_seccomp(p);
>>>> +     cap_bset_drop_fork(p);
>>>>
>>>>       if (clone_flags & CLONE_NNP)
>>>>               task_set_no_new_privs(p);
>>>> diff --git a/security/commoncap.c b/security/commoncap.c
>>>> index 3399535808fe..3bec15d43731 100644
>>>> --- a/security/commoncap.c
>>>> +++ b/security/commoncap.c
>>>> @@ -3,6 +3,7 @@
>>>>   */
>>>>
>>>>  #include <linux/capability.h>
>>>> +#include <linux/cred.h>
>>>>  #include <linux/audit.h>
>>>>  #include <linux/init.h>
>>>>  #include <linux/kernel.h>
>>>> @@ -19,6 +20,7 @@
>>>>  #include <linux/hugetlb.h>
>>>>  #include <linux/mount.h>
>>>>  #include <linux/sched.h>
>>>> +#include <linux/sched/signal.h>
>>>>  #include <linux/prctl.h>
>>>>  #include <linux/securebits.h>
>>>>  #include <linux/user_namespace.h>
>>>> @@ -30,6 +32,25 @@
>>>>  #define CREATE_TRACE_POINTS
>>>>  #include <trace/events/capability.h>
>>>>
>>>> +/**
>>>> + * Effective bounding set of @cred in @task's thread group
>>>> + * @task: task whose thread group's pending drop applies
>>>> + * @cred: credentials to read the bounding set from
>>>> + *
>>>> + * A drop recorded by PR_CAPBSET_DROP_MASK is authoritative on the thread group
>>>> + * and may not have been materialized into every thread's cred yet, so the
>>>> + * effective bounding set is the cred's own set minus the group's pending drop.
>>>> + */
>>>> +kernel_cap_t cap_bset_effective(const struct task_struct *task,
>>>> +                             const struct cred *cred)
>>>> +{
>>>> +     kernel_cap_t pending = {
>>>> +             .val = atomic64_read(&task->signal->cap_bset_pending),
>>>> +     };
>>>> +
>>>> +     return cap_drop(cred->cap_bset, pending);
>>>> +}
>>>> +
>>>>  /*
>>>>   * If a non-root user executes a setuid-root binary in
>>>>   * !secure(SECURE_NOROOT) mode, then we raise capabilities.
>>>> @@ -284,8 +305,8 @@ int cap_capset(struct cred *new,
>>>>
>>>>       if (!cap_issubset(*inheritable,
>>>>                         cap_combine(old->cap_inheritable,
>>>> -                                   old->cap_bset)))
>>>>               /* no new pI capabilities outside bounding set */
>>>> +                                   cap_bset_effective(current, old))))
>>>>               return -EPERM;
>>>>
>>>>       /* verify restrictions on target's new Permitted set */
>>>> @@ -849,7 +870,7 @@ static void handle_privileged_root(struct linux_binprm *bprm, bool has_fcap,
>>>>        */
>>>>       if (__is_eff(root_uid, new) || __is_real(root_uid, new)) {
>>>>               /* pP' = (cap_bset & ~0) | (pI & ~0) */
>>>> -             new->cap_permitted = cap_combine(old->cap_bset,
>>>> +             new->cap_permitted = cap_combine(new->cap_bset,
>>>>                                                old->cap_inheritable);
>>>>       }
>>>>       /*
>>>> @@ -925,6 +946,8 @@ int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file)
>>>>       int ret;
>>>>       kuid_t root_uid;
>>>>
>>>> +     new->cap_bset = cap_bset_effective(current, new);
>>>> +
>>>>       if (WARN_ON(!cap_ambient_invariant_ok(old)))
>>>>               return -EPERM;
>>>>
>>>> @@ -1283,6 +1306,63 @@ static int cap_prctl_drop(unsigned long cap)
>>>>       return commit_creds(new);
>>>>  }
>>>>
>>>> +static int cap_bset_drop_process(kernel_cap_t mask)
>>>> +{
>>>> +     kernel_cap_t pending;
>>>> +     struct cred *new;
>>>> +
>>>> +     new = prepare_creds();
>>>> +     if (!new)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     /*
>>>> +      * Record the drop before committing the caller's cred, so that a
>>>> +      * thread created from now on is guaranteed to observe it.  Apply the
>>>> +      * current union, not just this call's mask, to the caller's cred.
>>>> +      */
>>>> +     spin_lock_irq(&current->sighand->siglock);
>>>> +     atomic64_or(mask.val, &current->signal->cap_bset_pending);
>>>> +     pending.val = atomic64_read(&current->signal->cap_bset_pending);
>>>> +     spin_unlock_irq(&current->sighand->siglock);
>>>> +
>>>> +     new->cap_bset = cap_drop(new->cap_bset, pending);
>>>> +     commit_creds(new);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Propagate a pending process-wide bounding-set drop to @p, a task being
>>>> + * created by the current thread.  Threads sharing the group read
>>>> + * current->signal->cap_bset_pending directly; a forked child gets its own
>>>> + * signal_struct and must carry the mask itself.  Called under
>>>> + * current->sighand->siglock, which serializes it with cap_bset_drop_process().
>>>> + */
>>>> +void cap_bset_drop_fork(struct task_struct *p)
>>>> +{
>>>> +     kernel_cap_t mask = {
>>>> +             .val = atomic64_read(&current->signal->cap_bset_pending),
>>>> +     };
>>>> +
>>>> +     if (cap_isclear(mask) || p->signal == current->signal)
>>>> +             return;
>>>> +
>>>> +     atomic64_or(mask.val, &p->signal->cap_bset_pending);
>>>> +}
>>>> +
>>>> +static int cap_prctl_drop_mask(unsigned long low, unsigned long high)
>>>> +{
>>>> +     kernel_cap_t mask = mk_kernel_cap((u32)low, (u32)high);
>>>> +
>>>> +     if (cap_isclear(mask))
>>>> +             return 0;
>>>> +
>>>> +     if (!ns_capable(current_user_ns(), CAP_SETPCAP))
>>>> +             return -EPERM;
>>>> +
>>>> +     return cap_bset_drop_process(mask);
>>>> +}
>>>> +
>>>>  /**
>>>>   * cap_task_prctl - Implement process control functions for this security module
>>>>   * @option: The process control function requested
>>>> @@ -1308,11 +1388,16 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>>>>       case PR_CAPBSET_READ:
>>>>               if (!cap_valid(arg2))
>>>>                       return -EINVAL;
>>>> -             return !!cap_raised(old->cap_bset, arg2);
>>>> +             return !!cap_raised(cap_bset_effective(current, old), arg2);
>>>>
>>>>       case PR_CAPBSET_DROP:
>>>>               return cap_prctl_drop(arg2);
>>>>
>>>> +     case PR_CAPBSET_DROP_MASK:
>>>> +             if (arg4 || arg5)
>>>> +                     return -EINVAL;
>>>> +             return cap_prctl_drop_mask(arg2, arg3);
>>>> +
>>>>       /*
>>>>        * The next four prctl's remain to assist with transitioning a
>>>>        * system from legacy UID=0 based privilege (when filesystem
>>>> --
>>>> 2.34.1


