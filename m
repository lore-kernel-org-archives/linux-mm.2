Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA89CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E19A8E001E; Tue,  2 Sep 2025 13:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091BE8E0014; Tue,  2 Sep 2025 13:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2788E001E; Tue,  2 Sep 2025 13:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D652B8E0014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:31:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78E651602F5
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:31:45 +0000 (UTC)
X-FDA: 83845002570.08.6577B27
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91EB71C000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:31:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqON5YJR;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xsrqc2vC8VESUbe3k7UKRQ6yvLNYP0SL9eBgq0WXcbI=;
	b=n1UI2ahVR7oPjls/o/cQrObly5zEfSuGkyC/RPB69ZSvkYx5oMeienIK70OQQHhSy2tQzL
	E+jpL8ITjHVmsYYYveBSsxHFPVfDoq396Fzo575cGcsIAD5qIVxxs/imqX6QTVvoKomkM0
	uASw4BTBItl6sW5hLfs5N3Xd7q9+hIs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqON5YJR;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834303; a=rsa-sha256;
	cv=none;
	b=rUkA5f9knxNsLwD39qXqmY2egb8NE3NP9+faMIJFFqOaQuqaD9Ep9LoMojDLFewfigMvtm
	5bzPcSLm+sMeskc21xQrvEvUdHVU4URkg7hO2tHeAjRXV6j4BmZBiFpZHgtziF465cvpaR
	8wrusK1W3mFzfZeC2Xv1+NK2wiFz7Pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756834301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xsrqc2vC8VESUbe3k7UKRQ6yvLNYP0SL9eBgq0WXcbI=;
	b=fqON5YJR9E0oOY9zChFa3RECMh+tJpKRTxbIJKC6PYarEHIcZ/QfF00nZEOrSZSvDKTvdc
	MVRKu4TLEfaFng6AOs31aFvFMefbLXePeDkmFJCO51pU+Pfe55/BscBU4Z5BnfwRfKFyrx
	9dZhuK6N4gU7tY2IGHXHeeJenShmVZA=
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
Date: Tue, 02 Sep 2025 10:31:33 -0700
Message-ID: <87iki0n4lm.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 91EB71C000D
X-Rspam-User: 
X-Stat-Signature: czcbnoiyhqrow1xz4ta89tp7n6xemrf3
X-Rspamd-Server: rspam09
X-HE-Tag: 1756834303-264435
X-HE-Meta: U2FsdGVkX1/l8Sg59kwWyqpwQF0ATm2le6nnCSZKbAiNyZ2skx108siF4PlSf7lPDYcKnUgit2usz4uqcw7G8dWFXggPPbU6fT5/cw21EYk3/9LGC2JnH+Qn1rqCxypVLZJY7NEmx8br3mSi3I8HYDPXTkANGeAEdv1zQsS+usnihRMEmziQ8+w8/OmdYq+qALfmKvnG5ZSRHPwcZXJTBM4p4j3CjrXnEBrymVU+0YNq46VHqAlajNTy9jrSMyybfYmJOfrjfyFSV342TBYhe5yo44FbhHg5+bIo04FTC24asmNOSSul8ghvg2Bp2uOepaIvU3VtQE9iXrCf/3aVR4/NEpTwhICyQBXOBhPfFwFMh1pBMpOd1/YytMsK4f++VjeLXe5AYnLs2k9j/OmtjBP95/VIIbLZc+6Rher9yIhZM+xlu4cTmhjuiKW7Xz2goV0svBo5OfgViX76nEG+/Zj8XQiyyDw2mGF3hi7qYoMnsnx+rCkTOJfSDzihaj57GpUjqlVS1GU0b8UYl+4TVT3wNQTugJFjONSKospSO1fp0hWECBmuATmKcepFFaCWZnk2LrChnFdG7gzte/okPxVCASoQ95mDKQlSZLDsoF6c9pSlcaWyTaTAYyidSK8YEiWAoEZC1he9KHHEqYQzrcbfKQPz16PlHz7+tjTLjS7PBtD/phxrs0TXIVZOVTQw7fxTj3MlVYK8BG/bXDGStxRswoHFL+HcnHZtdVvhWnOKztdLWZ+XcgII8pt2K709GefUu3czmRnSl9YYzPKgF3ekVi1tE/3C0W96QRZeDaetaCsIaqd5bM+fcEk4itd1wogtpuX7+iWxc+0aCk8a1PXXhGBLswQNSdF+hF4jOe8YTzPVssZXzCvwwNSD/mdyK9TEc+PnqZQdbCHV1REOCm6ZIR6qCIhNSH3QKuNDTKujLYRA1FjhbhjSm9Hpjdwh92Lur10wXiOG4Z5NZK7
 TxU6KiIY
 AWvuS10KXdaleqA2t/6rng/z1GIhRLlsz0IJCHPVkHga6vswXwn+rJXL2Lm9jCtUHFAfZTUIEspDtppfQ6mq4+2lq758OmGtbK5oCEhknjKU6rRra+jIbPi6080GfecwpUi/+UXsrl/ADsY2Q7Cyly8RLhruraibVjol2ih4NF25cslNaYToUWnHEGnezXJBNKMTk52A15ia7aWErPsK/7NG93jXRzdD72tllkJk4aNGRwmYfc7v9ISspCle30ebL/zHWYG3016WjpUUgjB1UBtzVotMou9eNitK0GyX7aSLVmuwDN4+dmgeTNIZsX9oSb4tObl6B0M01jtbBvvjyr0yyo2fDPeITaew0v7hW3rh6Q7Ufil+eYoywqD2FuNFo+WrTeJ3X/70Sep+55u4mWekHKg==
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

Btw, what's the right way to attach struct ops to a cgroup, if there is
one? Add a cgroup_id field to the struct and use it in the .reg()
callback? Or there is something better?

Thanks

