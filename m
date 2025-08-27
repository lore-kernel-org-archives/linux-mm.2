Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803A9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6C68E0002; Wed, 27 Aug 2025 14:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877388E0001; Wed, 27 Aug 2025 14:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766398E0002; Wed, 27 Aug 2025 14:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 620B28E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:28:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 008AA84F4F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:28:42 +0000 (UTC)
X-FDA: 83823373284.25.C39C295
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id A42C914000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:28:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=br5GY858;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41wqfGoUvCOSCwBnkrsV8Al8LdILnHJRjtaAseQQoqo=;
	b=Bjvs4tZ7h+Kc4E62nCqA5kMPjoURk2Abc1VqkdbpbQGMeVLJ3IZzDQSNHWus9CwtCv+j5z
	5+DcxIY5Vi4qYtsTA0Wz2K4oHYJ17QPb8HP5w1OcinZ0CRnha7EWIuvKYA4W+BIZTksmBy
	M2kL6/antb6QWro+OHko015YRiNp584=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=br5GY858;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319321; a=rsa-sha256;
	cv=none;
	b=fnfye7qut3K7DZOp+DWCnxAq1Lnq0M57dMxa9ANKmqItE7roY9CTHd+fcqZaqco2C+cLRn
	TvVLhs5SfWHaUAuu3lrxm80uHqmq67FR1AE7ixQ0GpsZ/kgYgmGvE1HM3uxHdlj42+Vyfk
	OLPahwJhWUS0DQp0KMu4EyDvodqVlhQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756319318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=41wqfGoUvCOSCwBnkrsV8Al8LdILnHJRjtaAseQQoqo=;
	b=br5GY858419c2v32Z6PeVsAhcd4ny8W0OEjE7Dz2x7cAsMc4ZJqVzZvOCCMyBwrVrq+YF8
	LxtKzhK/A0nyt058rLDOO4MiQNGNYNdOd9QpQpuCYwX7sheyCWlUSVTAg9zJcoXx62I2wk
	s52wIEOFyTcYY/DopaL8X/Ux9zKB0kU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>,  Kumar Kartikeya Dwivedi
 <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	(Alexei Starovoitov's message of "Tue, 26 Aug 2025 12:52:26 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
Date: Wed, 27 Aug 2025 11:28:29 -0700
Message-ID: <87cy8gty9e.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tqc4nof34gqfstns4rn9igmd7ww5rnk1
X-Rspam-User: 
X-Rspamd-Queue-Id: A42C914000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756319320-691824
X-HE-Meta: U2FsdGVkX1+OLMLV+YDKBqV3pe6pJ8Athyf7Fqdlq2oHhJ6U2jRg+wVq2TVJs7qWd1PnPUPlZXzWZ6DGhgvQ53E4ukXOfFrOSKj6vuqPOw2i6d3S7mij0+CGT44SMjXaDsqOmYFLCOWSFMkJ4Lyjp3dyNratOe2X0ZBPs9XZ9ZwT86r5dbY1gBqaTwYNxxHcwXlulMemlcBnk+56dSe96UUzh5YFLx/hDa98wC5J7A6cUEqBuoISv7RJgYaEPRpBcjL7gmtNIRZa6TIOy8PeRftAZrJ9ptK+aHdHigP50dmG6o5ZusqfsJAPrVUm/vszYQjieKqXA0o3DQnA9JDGtYIHtBMnSddxQ95aQmP4jztQJU8wIMlv9eCW66Gf8DEQ7h+VNmj3C7Thsp6jwiJi+1JI6AYYs4elzC8+RN305UUU/fmHbrhedVnQAWjnjpEI2vfAKHUScGUTA5NSKoF72ttPhdt4rU5iELiMi7v3MeADl0iD6Wel4MtYp1mWeKYSq0Hwir6mZRrF7zBMAqYIc9dRBM0OZOwGKPGOxuSW7laA4RBbKNSS9ASWdJW6oNuPOTjBXegk2YhRNs7fQmF6a1g+pd2cHc9F4VUDASkfcpukmkE6GFosjUJ6ocwrMkLw930HzgT2Ww0fhadXgRfp824MJbDCAxOsSxMz2WyLZNrE6gYWoXMZNiYNFZpgmcYl1ycfIas7QNvSkFF8ksaC+/ggmGwbebFBEcckO7OOtJAX4Gtp1FN/C9VW6wIB8e5TQ4hYUWUTgRGAWn81DF5ZzTJKSZ8gojv0P9vyPVA7iliJlJ3YG2wlvuUXI+aKTQTjywFPqNoaTH/N82NF2E00ENKDGx07ERXtdigB8FqjMeildFctFpqPEdF/uZtJE7/vA/P3LuNVG7OGNA5xHtMZrzBtiKaAk/LS6FQrjZBkqldB1baYLJ5s6aanNwDe7pUf/AOmQAQYhOfYyqyiSrM
 Ik6oDbuN
 m09RNOBftWL/PhCHEY+40iMDfGh/FcgxdRzLJH5V4U0VlzGGZrSZdBcuuRD18FoKCef5v2KKYgOLKDnGn+fHpMJX8gpTY1O6KfVAUZ6k3l1dKDUVAE0EbrM8p57rMk4TLa1G5iYb8e1O4RdowGgybGd3czY6UhDe96wjBaWt2mhj3JnAGtj0szELwrxDDAQRRQiUVg1CiIdjEKXY7le1MDItUzrtbqEg/R8VbsIILEPcHOghBf8oug9DPHqq7SN9EO24Y2wuab+HgrHRFRRbkXViYcdV85MtS+SifClWyNMg2b6O5HhwdBAbaDbD43DgmFVsIkrl50gcxKlSDcAj6XZxXYDA5WS4+4UZiXrVI+KYzurlQZGYIcqgMlEMrW+hUY5iEf0qcWYCwx6gyxF6aW3Ce/qQnEcFon+9+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Aug 26, 2025 at 11:01=E2=80=AFAM Martin KaFai Lau <martin.lau@lin=
ux.dev> wrote:
>>
>> On 8/25/25 10:00 AM, Roman Gushchin wrote:
>> > Martin KaFai Lau <martin.lau@linux.dev> writes:
>> >
>> >> On 8/20/25 5:24 PM, Roman Gushchin wrote:
>> >>>> How is it decided who gets to run before the other? Is it based on
>> >>>> order of attachment (which can be non-deterministic)?
>> >>> Yeah, now it's the order of attachment.
>> >>>
>> >>>> There was a lot of discussion on something similar for tc progs, and
>> >>>> we went with specific flags that capture partial ordering constrain=
ts
>> >>>> (instead of priorities that may collide).
>> >>>> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox=
.net
>> >>>> It would be nice if we can find a way of making this consistent.
>> >>
>> >> +1
>> >>
>> >> The cgroup bpf prog has recently added the mprog api support also. If
>> >> the simple order of attachment is not enough and needs to have
>> >> specific ordering, we should make the bpf struct_ops support the same
>> >> mprog api instead of asking each subsystem creating its own.
>> >>
>> >> fyi, another need for struct_ops ordering is to upgrade the
>> >> BPF_PROG_TYPE_SOCK_OPS api to struct_ops for easier extension in the
>> >> future. Slide 13 in
>> >> https://drive.google.com/file/d/1wjKZth6T0llLJ_ONPAL_6Q_jbxbAjByp/view
>> >
>> > Does it mean it's better now to keep it simple in the context of oom
>> > patches with the plan to later reuse the generic struct_ops
>> > infrastructure?
>> >
>> > Honestly, I believe that the simple order of attachment should be
>> > good enough for quite a while, so I'd not over-complicate this,
>> > unless it's not fixable later.
>>
>> I think the simple attachment ordering is fine. Presumably the current l=
ink list
>> in patch 1 can be replaced by the mprog in the future. Other experts can=
 chime
>> in if I have missed things.
>
> I don't think the proposed approach of:
> list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false) {
> is extensible without breaking things.
> Sooner or later people will want bpf-oom handlers to be per
> container, so we have to think upfront how to do it.
> I would start with one bpf-oom prog per memcg and extend with mprog later.
> Effectively placing 'struct bpf_oom_ops *' into oc->memcg,
> and having one global bpf_oom_ops when oc->memcg =3D=3D NULL.
> I'm sure other designs are possible, but lets make sure container scope
> is designed from the beginning.
> mprog-like multi prog behavior per container can be added later.

Sounds good to me, will implement something like this in the next version.

Thanks!

