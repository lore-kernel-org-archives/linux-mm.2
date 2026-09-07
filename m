Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC1FC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7736B0095; Mon,  7 Sep 2026 08:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8016B0096; Mon,  7 Sep 2026 08:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570CD6B00AA; Mon,  7 Sep 2026 08:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 381576B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:29:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A253E160149
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:29:15 +0000 (UTC)
X-FDA: 85186896270.04.BDC0F15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EBBE32000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:29:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SamNaLe7;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkDAwsqxGaceGfRmb6vtMU2HC0ErrGFG0sZSl2jCjh0=;
	b=8YRdKybCLYsfmuRi66F/hivBjAXfvXqyiHPiq2DOm/Z3sv3539jdQNaJ4a+lNz1qwfma9c
	31l92zVlHZyUD3tO5aVihiUElpBHoMtpkMLO/o4+sR8OLaMmvVGOFbhPXGRqMesI51CVQc
	W/LiX9Y3h9iHgFxRbBMkvd3sSzdZkUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SamNaLe7;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784154;
	b=otlnYArt1KygMteDaPFoeeA7uM3O/HobwBW9CIpvv5rCdV78vjhIibAd4yAyCMZTWo/BoB
	0isT2pshXsDRuAXU4Ay3i5HMeNz0+7RE2vFs6CA6X7jjb6yKYqqS49y2qH6BoSCLBVHIcZ
	YyGqGB4DVLVLKCGJXxowwiVhX/PIsPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29700414A3;
	Mon,  7 Sep 2026 12:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD31F00A3A;
	Mon,  7 Sep 2026 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784153;
	bh=MkDAwsqxGaceGfRmb6vtMU2HC0ErrGFG0sZSl2jCjh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SamNaLe7XhM1e5/SCg2UgqFLGHgOX0ZA7pci54ayVgh1r8Aa55xnUGKXJAcXwXy5D
	 tqGvIh/XnRv4Hr7k9h41IgEicJAdSCkZVXyjftuoH4uK+RSIEmBmOSABpe0xrbDE8b
	 3qACI5xnCV9khLFq/VQhNPw5VtMvpDBkiIkCOQCN/Elv0GLgSAuqtU4KGpTPp8RW5X
	 zcnz0ltm0IOaEnc8QEzYn8HP8eCs9CXs8E95BdP4T9MhQUB1AdMw6MTRom0KD24wt7
	 nH4p7Uiva5uk0ptmQENNZ5ZMEh3OjS8AY1UoxR/HBNIh9NVkIDTyLYc1wUMeE/XfiY
	 RYaMoruOloQsA==
Date: Mon, 7 Sep 2026 13:28:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Ye Liu <liuye@kylinos.cn>, 
	Justin Suess <utilityemal77@gmail.com>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack3000@gmail.com>, 
	mhocko@suse.com, peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, 
	rostedt@goodmis.org, jpoimboe@kernel.org, oleg@redhat.com, tglx@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	rafael@kernel.org, sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org, pmladek@suse.com, 
	longman@redhat.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, 
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, mark.rutland@arm.com, 
	Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 8/8] security/landlock: convert thread iterator to
 for_each_thread_rculock
Message-ID: <ap6t3Dyf-tLJ4Yfw@gremlin>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-9-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907081334.1152889-9-ye.liu@linux.dev>
X-Stat-Signature: 73ar1xgfhowdc1bkg5qp1xr448sbrmjj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBBE32000B
X-Rspam-User: 
X-HE-Tag: 1788784153-192959
X-HE-Meta: U2FsdGVkX18A6k7oFKDP3/M1JjJ5q9vazEwYu/jbpqVoizSLAwCZE1xgUWIeOeJwuaDjiKsKhMPbxY1Ad1HLkv9abOXYIZbZl/qy9P+eKi1hUAnlCzWEbbXD31rn0geg74VU6UMBjzXmm79GjlnWHkhTfPknyWOA2EoeoNBHVk7dBVddiFO/vdKIw1x8bRItbLlVArWC93DqUPRsCCBIcsB29g2jyW3OrjRw9ULsvF+xWk9WZoAiWYhfIndjt9GYoIagBR6tobsvE+nnnPPvWTs4IGufS3tix4UsW7nKDTOKGjBR84UAeEdgHwRARMrkhqnNYCeLdK/A2tAjw1jMAlpS7JSdC538SDEfmC0UOu8VRv2aHptwj/rSlzSSVLLSMkFGiguQhJgGuP6pAHxG52YXQwXhY6Q6lisNnHAUWE8uA62kBWIgSm5oxsTWZ/SrJ495buQHuJjrYXEabnYUhaP7GmPiTlMq4YE2v1mpLK3LcJC+4a4DHrovedxwT3OZWIXiGo6dF3fHgSmU3ifJwFGJMZNIHbu2I+8S5MvIwwGJtwqf+bE7T5+CcIkpbUW7UXPusU+EdNeSbezlpZ6FpLLoMDkthzAaOihd/GgGaGyN0abJ0A4j7Va8kN7u42Yvq55p2Cp4Y6ty8o+085a3Cv/2av/Ac3HGxxFFXxxpc6nZfDcgClIGFKF2H0Lb4dmdobaPXXb2RDQpyRlUVbKP9ZmHBCDqX/3xhIbYdMc3zUXywr150XMecwFwz+BG7VRu2Bab1fstovUHmtjsuNz9O8rbBGRMhOUO4EV3xxI9Xio43wQDeZ2RLF+z2XbcJ+t4+RaN0SOjU+0511Vfo/HIJnQeL+D5sRMYzHS902AMC5OftxzBwrByZDLyKDSwBBtD6oZzVnsGRv9zL98MAR6D2jA/Bk0i1v0TRWKveggwodv2nmqangi6t8p2g6JU6yTiCgPRf1tAnQNJuUYHFQy
 JPMxUvIz
 GR1xgi6LQw3WmvhP/uQvJH+2mADJ4LU+aoNydR49Y+VGkdqVMcOYlMHjXrQO62GRFQyK1xeKy/oYW0/hpOzzg9+UWo98j3egy9Qdzmvt8vMmlDMBnw2V2iXQu8+3WcsOc8y87nMkVDOdwW+xccDCuS953RTEJP/jc5J8twnvPZ8qk2eqpMsmAZqkZI7hBB7S/RMPcVDhbbAyxWAnO3yMlyNd0Z6VVnx1tsiDwDE0Lg7gQFWcEiSCbbmYfAG8d1r4wyazzAJSF+1BiTB+BVvMxyHdWPkc45+bK/F3HSgAr28pyZ70CxKa/Md8HjJKjGxY8b3VtK4C6utkPyxamU0uL4COWC7uG+fJ5gqDUPdqN4g5oGs/fyN0dbyWPMoDhrJJIV3A5MVrkxhqCFP1UpRtUoaKq4dd9boEwrRaFDb+4866qXABmPLiPMofwAjpmDgIjoevC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:34PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Replace guard(rcu)() + for_each_thread() with for_each_thread_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
>
> No functional change.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Reviewed-by: Justin Suess <utilityemal77@gmail.com>
> Reviewed-by: Günther Noack <gnoack3000@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes in v2:
>   - Rename *_rcu to *_rculock
>  security/landlock/tsync.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/security/landlock/tsync.c b/security/landlock/tsync.c
> index 0b71e158c3f5..a578af640aad 100644
> --- a/security/landlock/tsync.c
> +++ b/security/landlock/tsync.c
> @@ -335,9 +335,7 @@ static size_t count_additional_threads(const struct tsync_works *works)
>
>  	caller = current;
>
> -	guard(rcu)();

OK looked at the file and confirmed the function exits just after the below
section so fine :)

> -
> -	for_each_thread(caller, thread) {
> +	for_each_thread_rculock(caller, thread) {
>  		/* Skip current, since it is initiating the sync. */
>  		if (thread == caller)
>  			continue;
> @@ -376,9 +374,7 @@ static bool schedule_task_work(struct tsync_works *works,
>
>  	caller = current;
>
> -	guard(rcu)();

Similar here.

> -
> -	for_each_thread(caller, thread) {
> +	for_each_thread_rculock(caller, thread) {
>  		/* Skip current, since it is initiating the sync. */
>  		if (thread == caller)
>  			continue;
> --
> 2.25.1
>

--
Cheers, Lorenzo

