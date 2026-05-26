Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84359CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04D66B008C; Mon, 25 May 2026 23:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5A06B0093; Mon, 25 May 2026 23:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D096B0095; Mon, 25 May 2026 23:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 977436B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:06:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 581CC8CDE9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:26 +0000 (UTC)
X-FDA: 84808082772.27.273C90A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1849180002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=miAoSySF;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779764784; a=rsa-sha256;
	cv=none;
	b=BA8frouXuBpXc4qEaMOtNNy0ZVbY38hkFScFGPirExZDj1DSniaeGrd64z6awz4SnhO4ik
	BU1t/sben+4soQslzj/zFXMOPCYc2hotec5JQtxgyrX2JyGfZUA1jwsGTqylBfZMoe/UIo
	WTeluVLCm30yqwGgfkDg6iqKdxV1T7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=miAoSySF;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779764784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuCwAibjo4il47YSW70WARwryK18pod4qEuZtgh/MWA=;
	b=IWO7KSh+NBM/BGvXV3QXUryIoPPtjtkhpaLjb1cDCi3XgOe0hSEhwTqrmAAOlQN5Fa9LTi
	4HQHk82MrRA3glOud8/RmmqdINmS+ywM8x6iYJhK8taWUsyaKehjZGupEKSQmwGOSBEcPU
	1JJ78nTO5RxzBGdyUAYXZa5z/+dTUIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5318D600AB;
	Tue, 26 May 2026 03:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A3C1F00A3C;
	Tue, 26 May 2026 03:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779764784;
	bh=PuCwAibjo4il47YSW70WARwryK18pod4qEuZtgh/MWA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=miAoSySF8EVzWhz9imT+sy+M1nNqxZMYQ/mRAuANUa7IRGhkoFUFvGaCHhfy6O4kc
	 3pHnFJX0uT4iyiCvjjscyxM6wUC0etmm7CntOOJNa7Cl5W1rcAqpumZi6zMF1aJM77
	 TBZ3IDrPj7i/SJ169dsorvg6uvpic5KuK3HJWYGJQLQiQjizT8l9CoXzSEdwjqfaJn
	 xQzSxTlVYAc8bdOLuBFjyrPhT9aDHdPBJsSWwH00pMYSkFnvzZSI52CVtd5cS6bocN
	 GP0+7TfEA+jzNj+xVOo5MacobpWF5zod7rvHE7YxvEaH+kWMlcZ9wzAc1TgljLAsVo
	 X4o5dXXHEV1oQ==
Content-Type: multipart/mixed; boundary="===============0436309527624145819=="
MIME-Version: 1.0
Message-Id: <975872964206d12a299b9d3e938e6e312db4e96bb23f748d97dd6c05d6aee2b1@mail.kernel.org>
In-Reply-To: <b3af3d0f9a925f79a6e4e7218e8ce84dfbeb5254.1779760876.git.zhuhui@kylinos.cn>
References: <b3af3d0f9a925f79a6e4e7218e8ce84dfbeb5254.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 10/11] selftests/bpf: Add selftest for memcg async reclaim via BPF
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:06:23 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: D1849180002
X-Rspamd-Server: rspam03
X-Stat-Signature: 8mbjawhaxsyfp8zgsx1r8a5693or4sst
X-HE-Tag: 1779764784-492905
X-HE-Meta: U2FsdGVkX19nu8NwMsoCVvRR5NJpdiBHGw9GD/r4hfejwtEdGZyNOp0Ht0kKovQgylVkP7Z/8oHS0osCNZAwlWpXWKR/CVj1du698euMdU6JjAZJWgyUBoNQ9TjrjgM2pomFceMHO+xv5nUq3bzQ+Nrlr/K3fpW0j+esYrAfdiI0+ndf2TXWR6DkssWieKZNGnNjTa6oInEsUTWDx2HQEx9/KnNYE6bgIBjnfvsJpV6ly0aZnge9uO5kUPDAHgSzL05dTX6ITPWHiXqaTE3Q2PQ19tzMfFqcKGt2yLyOE8LYnO5X3TkW7dghr7nFPWw7le6bDeuFyZKQfMft3RKxsVZTHaDXLUjuTKOLQMdFLy1xarBRptE6Edq39PoKffsRFQHa421bk70Niss6i4moMbrt18YZ5yPLLaqnlpyhpFv3rNry8bJIhwfZX3BfLqWnskBHhMH3/+xyvqf2g/h9BFYXS/TbdEn7Xvd6/0cPMsCspbjC1G7/EqoOxDjkhr1yK/7hFyGINVG/p+GQPOqZYUktA4FhbvJVk0TLS+gD/XUTy+Zi7KEJrjeBcw/FmG3nmcvO1PDl9hVYR3UzVsQOXf9XpKDbzE+S0yf1x8oelHRSNYjKdFqmKOjZ/Kc8cmlpxjdTSe45B+GwDz2yz4q/9afILfFM9jzcsZKwS4FpA7tGdHp027o6clpK6hR84CocVRxL9bKLWjhkG5nvHjCk7xPrk6ySq4EYsO4O30vr2uAznpUfiQEHdvmY91/DM7vK2Dwo9MujkZLZppkw2T3LSra+NAJYkVbjiVfTnj1LKz9CjL+UlVqINzph1pfrFbErm0NJiuLGM4wkE76GV9pBbN+7EgvohrbETaNo6aSjgj7V6UGcgPEGiUIy39iMGoLAljpZPP8ed0q3QjXrXMA25I+ECkMglelhtgElmFgFesARVchyLw+R+hIcyeL9+xYc+PyfrlhF0Co1gsaOBZn
 yDXfQVtN
 HbCYaZI6fyEa7aSQtDgJFreCkkAUjtRfLSyW3IWE7DwxkONpHNpVNcmm1zbZjLNfJ6LbZMVhTccFRRnNQ8fKPU3G6Mrp7PYkbtty6l86+1Z8XOg6Pb1tJks7NlfwRR37yJh7gbqAxLxmEFjofiAw/vVlRDUp9zZscJixv/luQns7Ibl+zvdDTXnTBMOO2uoNduxFm4oIo7GvsLophuD7YqOM/L3fLqFSRL39A6uacUUjgBkATntGKhdg9HHUIzkRaFBZ41nNj4O2wqElWuoVA1BwldSEzgKzC8WHe5aVjamJA4GvTizyldoBD9bnQ0wCHR60XCEGJ8/3y5XfLG1eEmVHdS20mkMhwxyJXAsEiy3TAk3iu0AGA9/2tQYa/d7hHjYPu5jW2FvyMJCnROl1StQzPBP1k4PtIh28qq6wouRFHTwhNknSSbHTtgY8nKVSqvdLgk6xAmpJ+eWeT26sES/XOy2iV+5xL7ROSntvvzWGZfAtTULDB3LUaLBAJVzxU/8pPjGrAdJl6QY+FdJaWvFIVCN/cfs1nkWLByTDt0gXJGLfDu03j/GId39e/1+ANjFliuKErE2ybuxiBLJZk5Z2AgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0436309527624145819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/MAINTAINERS b/MAINTAINERS
> index c9b3dfe2498b..29de8e2fe55d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6576,7 +6576,9 @@ F:	mm/memcontrol-v1.h

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..bf25967c911c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> @@ -0,0 +1,333 @@

[ ... ]

> +void test_memcg_async_reclaim(void)
> +{
> +	u64 cgroup_id, old_max, new_max;
> +	int cgroup_fd, ret;
> +	struct memcg_async_reclaim *skel;
> +	struct bpf_link *link = NULL;
> +	char data_file1[] = "/tmp/test_data_1_XXXXXX";
> +	char data_file2[] = "/tmp/test_data_2_XXXXXX";

Can skel be dereferenced if it isn't initialized? The skel variable is
declared without initialization to NULL, while link is explicitly
initialized to NULL. If control reaches the cleanup block without
memcg_async_reclaim__open_and_load() succeeding, skel remains
uninitialized:

> +cleanup:
> +	bpf_link__destroy(link);
> +	memcg_async_reclaim__detach(skel);
> +	memcg_async_reclaim__destroy(skel);

The generated detach and destroy helpers will dereference skel through
obj->skeleton. Other tests in prog_tests/ check if (skel) before calling
detach/destroy to handle this case safely.

This was raised by XIAO WU in v6 review
(https://lore.kernel.org/all/20260423171516.00004adc@gmail.com/) in the
context of memcg_ops hierarchies test, but the same pattern appears in
this new async_reclaim test added in v7.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============0436309527624145819==--

