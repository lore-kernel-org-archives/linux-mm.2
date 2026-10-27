Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A88C606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jLPqgKVf
Received: by kanga.kvack.org (Postfix)
	id 7A9C56B05EB; Tue, 27 Oct 2026 14:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75B696B05EC; Tue, 27 Oct 2026 14:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649AE6B05ED; Tue, 27 Oct 2026 14:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40D496B05EB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:17:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C43B41A0AB0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:17:14 +0000 (UTC)
X-FDA: 85369213188.23.4B1002B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 558E8140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:17:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLPqgKVf;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793125033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=BQlG+dpy8YjBQ/Jf8HDAX4aO1LrQ0VKAd1X1FNGlEsc=;
	b=zjUtfUNsWbGWMXh/yTz2NK5Uq7j9ANDEEa2fhjGo4+u7l9uYB9VNgn3g4V4lnVnMJHeQOe
	O9W7WzJwhpLBcAplIGwATeyIl2sMob/Ki+Gq6omA/wnCnsJKFCd6ywiNZnMGnfBRW+DF7m
	+T7L5oU9340IqdH/pSg/TFKIRmxQPTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793125033;
	b=IFa203a/42rz2UKiQDrJJowjeEmIeuYPztJL32B/fAVBVQcnWrsrHy6oWrToneSARkYlxr
	xuhV0gT8FjvxCXwMvpKqQCCtJu8e20TIFG2HC61GL/XMV7Sj49eJEtDXgXQSzl9Op+kw2G
	OU5MAfv3Jk1t3vRtWMwvf8ErrgOTtsU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLPqgKVf;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EAD760136;
	Tue, 27 Oct 2026 18:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6511F031E5;
	Tue, 27 Oct 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793125032;
	bh=BQlG+dpy8YjBQ/Jf8HDAX4aO1LrQ0VKAd1X1FNGlEsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jLPqgKVfOPVsDgLwoMZ16UseK8OHOo8JpJwNW/YVi0kw3fyQlEsd/UVg32FMZs3OW
	 r4P5KEJCPIj/KOyDQJDreVJVPyrB9ZKlgbeWThq5yAcHYydcr3eWO39CsPMsWs4YzX
	 ty8ec6TIzned9CARBFQmSPik48yQoBZn5DuK+GyZh73+m/oGiaCpMUsswuEpUy1+/B
	 23Ww8KgzPaUGxYKedH2WJ6EK08iuAw/pGCySpsh73GwcFgXbpCs1fGhaD+DjqHzW4p
	 yCNW05kom5Kf5o1qvD3E9oL7GPtzdiHaTHg/5xmtSzKc2wlh09rM45Nyjj1+dO0iMI
	 u+HyATTnHHaaA==
Date: Tue, 27 Oct 2026 08:17:11 -1000
Message-ID: <769e80ffa618327ac03c13c4657e7229@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 KP Singh <kpsingh@kernel.org>, Tao Chen <chen.dylane@linux.dev>,
 Mykyta Yatsenko <yatsenko@meta.com>, Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung <ameryhung@gmail.com>,
 Tobias Klauser <tklauser@distanz.ch>, Eyal Birger <eyal.birger@gmail.com>,
 Rong Tao <rongtao@cestc.cn>, Hao Luo <haoluo@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
 Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min protection
In-Reply-To: <cover.1793086858.git.zhuhui@kylinos.cn>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 558E8140002
X-Stat-Signature: er4kcsdoqxuco3eojaekmf1zwd1xqfnq
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793125033-670731
X-HE-Meta: U2FsdGVkX19j+foOHkQGdefVGTn8bs1CZ0cNMeGj79CCOBc3sB5YXs5pFUgJob08V++UoCk3regkke584O5peBuy9sxn+7RmyhTDZ9GyfY6ST9j9S4/jEky4JbrWepo9+IZV1gaqtL7kTTzHqGOCmOtJ4N+dV/q2ASWv5GrK90qFjY8ES7q45UZiKEKWh0cgQIXr6M1YY4ERLMXsjcO/z08ilwWZuWHzVta3kdrWhwxKpnbwj4r+pzSchBTkSQ8wzAqiIuPK1+pH/0o4kf75RJRJq61o7nvbr9+GURi/Ig7mfb+MOr7r1v6bExLC40g5WXO78eJEwZD/vOiVQxAhtaPyGqfz5fmcQB+knLa5NTjcQtIfmq6CLKiUpxHXly4h5T5w1iQSRxJ9HKgMJ5OgktmTbxEPoWoryt2hKcQF52jSN1z5xnVnYGE2IzOJwQWuqH0zzFMphamoa9m2ksWkjQDRxUG1zbcjq/ADZipT+/l6+RuRBBG4jDPrwfYKIKuU3AD8kn9E0paJYvby46sgJzJU9JG0KWXgFzdR9PudR9247wr+4kUd+MCOahiQS3LemcEeNUwiQSM9mnWi8gkPZPR4XyryrEY2m3c37Vw1Spumohm2Kh7IuLdu3w8IsXtADKLI40dUSyWqPPXDLvTP9PPjF3zTy/pCiuykc4hMSo/QGc/kgpKqWGVCZb4yDds4ivThRy1OBqHpgh4srZunvwDaMy7w8rM9QP3z4CAt9wcJO4LQZtIT24huEH+9VDs6Uf3heAK7UxRRK8hULyEVu6mUz2ati6xkm1kp8xdCS4kVbnw1d2VMEi7EYY9ZQ3Xbhm6sfgpkwLvGeAlMol1UFDd1u5iZ6xYDzzQLC3rZe9+V6A0Veb5ZEfdbVpLNToaZHfl1FGHsGIRVcfxMdIWVTHTAZ7gAL40Uzy+NTHtz4Q6703ZcyH1I13ksf3mRaurmW/KIHH0Whzybgwlxsne
 qPKDfYFa
 EYb2tf7hSu0YDLNup4fcZAj+pQ664FheeahkJ9oNSETCrwVzCo/nw6JPi/68mRFi3IwNEeYZsF+pztARMvVIHXC54p9/2AeLUCJKQt8fl6LqgQXEYYjGMRbAVl7rPXcKRZuRVorinAkbbUzxYiiwmrrKQfZFKyd1byGRkY+tf8PzTRvPP/3ovXOJDQSI/HC+aqI2bkzcas/aowwFC1cpqq4sgxqWuoisEky+LnRVKqUbkzXcvInfbLGGZiVsNxq0oGDK4PeVVXA6aTc+6M4k7rzfotxwPo0BknEHl7VfwQ96F0FJcE+CVsbzdn80Ky1F0vP2OAtiMJWZ3nVQKZC9u98lywReXkgVFPgJpBgROsBpJtr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hello, Hui.

On Tue, Oct 27, 2026 at 05:11:58PM +0800, Hui Zhu wrote:
> Why it matters: memory.low and memory.min protect a cgroup by a fixed
> threshold and have no idea whether it is using the memory.  A
> high-priority cgroup that holds a large working set and then goes idle
> keeps suppressing reclaim on its siblings, and that memory is wasted.
> A policy program sees the real activity - page faults, charges - and
> can grant or withdraw protection as it changes.

This doesn't justify the changes. Why can't the same be achieved by
adjusting memory.low and memory.min from userspace? The arguments made
so far are neither convincing nor proven.

Thanks.

--
tejun

