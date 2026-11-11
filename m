Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CC6606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i4NvVlap
Received: by kanga.kvack.org (Postfix)
	id 3F91E6B05B1; Tue, 10 Nov 2026 22:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9C26B05B3; Tue, 10 Nov 2026 22:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298016B05B5; Tue, 10 Nov 2026 22:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 055F56B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:46:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89A001401D9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:46:13 +0000 (UTC)
X-FDA: 85421450226.20.B368ADC
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E8DB40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:46:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i4NvVlap;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794368771;
	b=ho4I2g9oOpcbDh4hnVKqPuKF45kbUp5ulPdxOBx9yasPNMquwiZ3wTI8AWqrsXEyPhGeXq
	2GZ3wUFGVg+nzfCXzKrjSD5lUn8UGqLZEP4gGsYOyVbExwiMGCCzTbalM0Dn8TyKkB0h6d
	allA4KCLZq+8GO/sOd6qcnasGeOv2Bw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i4NvVlap;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794368771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
	b=WC2NyWnMZxgg5w9Fl8wgSwkGkHs+DXPDcnGrujNKUofkPJt49I+4XBbFmjOgx4YcSXjQD2
	ZOqffBFFAYJopCbQssqFxu/JtWekdG/5YpE6SFe+ephGeEMKOnTGwpr6FUMiB9umqqrgCn
	mqmCaORnme9BOqNh55YtCoPVCk7a0oM=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67c58f18765so1048814d50.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794368770; cv=none;
        d=google.com; s=arc-20260327;
        b=ZrWba5+6mqxvZRvsg7lbQwXIsoXgquclDLPpMw3lmYDbLJJUpC4aQ8iZl9wuF3SYA8
         wm6dnxbtqcj2II5XPvMAQBWmGEUNxq4wisS7Y+yjk2g9/eroeqzzMY9GjIqYeOmYRDe2
         8nbScdmMP8YkQHdb+Gk8LcfE8G02w5FU+AVi3ahRRSN/Lz6PcsuTGpqH0h/A+KGpBlN+
         bpFuFxivL346ex02B+8cfnfkHuy6YEdXdkyblMscpg5YWCE5UR+mfMcb4vlNbSuRQMlm
         nPmr7DiE9VykHFTw1EkR0LsCsMjoNACXqQDsGgIyciR+WNOrgO85znL+1TvvjJPt5gli
         UMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        fh=lFrScrjda/7xSC7t7p5XjYb36GVp2+1jXzw8fTWVUU8=;
        b=TCag8Wm/zjXBpblF5RYf3foKxoUUnN8xd9rdkC0MhFGVhxrZuK0ynfoxhPquQjpXMC
         yswni3UWCqCv4NYB+XvSGB/n0CTwbdrlh2EE9pSOR8DjZMADielSR6m3UoVoUUhhKil2
         sfpEPkMnpjS8BtvSo3e6kzqzwWQbHQB2P0fNNGeVE/brQHJVR3Ei/yJBZheiuCan7BBT
         7ZyJ5AnfsYylEnGiTbRnKxAfITIw84UP5BVFb4w2e7ECYc8l6HOgoSqhFaM486lS7GaZ
         dQiirB5lwVdO0p/PRmeIWKTx949l2YIcY47GDM46SJm6VRqFOxgs0FyYI+1FaAqSxtE1
         5tcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794368770; x=1794973570; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        b=i4NvVlapJZsMvqawvMfAYM4QDHHIFzylW+Lh+XA66fIc5qcH/nOg10Zk9O5tR1cV+v
         Ujn4p17xphOIEPi7sExQ61fC2HryTW1ZbfmkiSNiABizDs52Lfepty7UAxtiGMtpuMCV
         nvrdWaWLYivq0r9+49t5Q0SCwchnhP312YXGYdDr12edPrcb1RfdSAZNDsfsDusGSQII
         UxXgHYTHqHBuvWAVbVq2086GoKlOCOlACHa6yMuB96V27pvUMR9pq3zHOZbGZvlHcVne
         Rq+48wNQSszWgjt8YFgVM689FN++FJdZBjmkSb0bTk007K6RjsmYToh7krL0VqCN2+u8
         z/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794368770; x=1794973570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXpnzG8jc2yYtoFLBv7ZARt98Mz5wOXGm+EBvSjKUfM=;
        b=rckvf83UNbyeoRft+n9kUXFNjDTh5tQB6KPxw7xZmknfwVeBKYYeO2KZsHcQZLmtt7
         Eh5WVPoPYcY7uV+pzIwVM0oHKOjhYgP0vw1wKCJtsBAKU+eN75DGkKvI8/Vr85H0nP+E
         DdJkxqHt22i4F9/bE/KO8bexb2VCwjQcFRtdKMq2FLBzn625thjxIlIcdMbpeTA2eUdz
         RV4qJT6DjA26z7piRThGYL0TcvgUFxzOfta9qavsWJJzvNjwJh5EPoQ6InefYgM807ON
         TMj1jmROMhw0yQ4gdkM6jvwtKH9r12Z9EIpfst/p6jR1tMPQs4Rco2h3C2LzEE8NnthC
         Akig==
X-Forwarded-Encrypted: i=1; AL+hErHMwqqsdNmibwRC+XnYzqNoopj2bE0B1g598XYisrh+lKfHiZqzAljtAOtR1L6hluAUMs8Sz6vOWw==@kvack.org
X-Gm-Message-State: APuU4Z8P+r51QJ5Vf5aoBwVaMiYkqbGLWmvctkqgxrZs/adqLUhj6Kny
	mbxYgcLJ6jYZ3BVY21sL5vhEsjRWIOugOQkbkb5nn2h38ruzLp1JZqMkOZySd/TlsIbc19X0Wyc
	JfcPFWANug6S5MmDpu26myKG6X+BLlao=
X-Gm-Gg: AYBFou1x59I8rqO0EQyZcCaXzTyzAJr32HlCotuNYDRFyc+VmGU3tLte+SXFCA6oLyH
	ybKyD62x8epvxA40D9aH97JfQgky0kVgz7AbbvVHhVmgbZDUA6GagW2l9vA9LCsQQBRxQY+TPsi
	YTg3cHmDG97BORCPp6e+fQPFumxkp9akokscW1owmHH+thdU5+KnU0tnNMVg4xNWrSegGhFgNMr
	dovIVFtlRyC45HSWVk61Lq/ip86SPtvnZinOvW+F/FQAkFbBXbEKBdzaThyvazFJei8JEismExK
	WPo/bGAqfJAJ/NVEHEzPb6GWxnf+tPSNlpBlQlh9/l50yDQHMfExcBmwWS4y1K5RFH/MnV/2eTD
	CHva5nFcXsEqbYsXP7bXaIS5dGuPaSHlzlsIDlTz4whaeNeTC4+GAtTIROnOVIw4LUIs=
X-Received: by 2002:a05:690c:f04:b0:8b1:567c:e7ae with SMTP id
 00721157ae682-8b3a8114a85mr9107737b3.47.1794368770490; Tue, 10 Nov 2026
 19:46:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110032913.71974-1-laoar.shao@gmail.com> <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
In-Reply-To: <3296ff1ecad6573e1719cb205d9128f7@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 11 Nov 2026 11:45:33 +0800
X-Gm-Features: AclHuK_EYuNKM1uN4O291ubvtl6N0s-HDZmJBzZexNtlBKQbnavU5QXTx2HKC3E
Message-ID: <CALOAHbDqE5qD7y5_A25wxWR603QcGnSVFFoBe6iZ4TH7t4a_Sw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing
 mode selection
To: Tejun Heo <tj@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, 
	ziy@nvidia.com, mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 65k76pwuptpqakn4uc18f5qc17ydr5wx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E8DB40006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794368771-312174
X-HE-Meta: U2FsdGVkX19BAxwqdLf2BHqzh9Jmjh97XC5UWWu+/9VmHD1ALuI2pDo/AtlEnEIsCksQgIeMOFLmPmPB5VoPmw1wCGZA2bhovbnEMturZ42iGiyEwSLkzanUjqzc45qvduCMIOLFdjpFPVstLdxfxFbIlcLYKCy6cXt1YT6AR0/hEFNf9afMZbVcaRcr7JXVlZsnGyUWmAtM5/yf9SCpLMcua3GwmnE8zxo7qHP8vuWcwDSn02m+7vGsaJQyYUy6p3QtrURHOQ50+Fka7c8qDwXpfSlDwg/ZbUBs5xxdfNLJlszBfnH67EEgR6InEORcySZQLAoSzZYklqnOvEmK/V7SvLlX60KDstXb42DIdiTgue6uYbEgUUYW3KPWNl1yyIOdlZz5jOl184kTsS4iLKuwNjT9g/nbfHme2+NPMJSQUcxBT4L4+GebQX0GCaADpB1kVcXqsIqAmu/YUM2fDHWUmFYz40pxHleN4ejBvvcTFptkvhb+c9+29yRj3B0rNS61ulWbvaBZ6SXCXcsc1sPGZZMeoR+avzKoQfSN6uBmBRChCqU6K/wNaBbxYpNSNBqKpLIANURR4H73QJHivjtT/Wj4IVPEMeHckTLHULw+HT2W3X/4c1swOGhT7dJg8bi9hKL3txdhU73YcLkdl8AWMOvGSoLfuMBMcBNiiv86kkb1okMDFDZxzxcGuqpp98qMdocSgul2LPq6gvSLRNmqwOJBWsrMvyzf3zsLJ+9gEYVkQt9kdSrV2ilJb11U78f5opumAx/X/0bydBdZiazheaAMRQKoT9PpGAHek6CFTsPS7e+rNHqC16A4CcQtbWxyIXGZqh7t+cuK0G9IRawfougc6mhcUIhY0kz7UWdoZQKRPy7hHNy5FgMern7w3UoX0Lssu+d/CTDdgRqipNiKvuO0IiddtAGClDyc3BsG3gd8K2kevomTrdSXP58d6cQSpLru1Pa9xG2iX06
 tZOrUfOG
 3+IZ4chCCBVmkTuqcXx8GZ4TP258byb9gsKPOEivIRAmISgETVJ/FyOSzqqMlIt/ypB+pj4V5HZbskLMbj1PBv/PSXS1cCO0c82IYM8mL38r+J4BlO7z5NehnRCI2kJ7QWMZ6HWPuAs+3eeIl5c1pCcTRO1iAZ5xKg56in51n+ruDOeMlqNn1hZ3GNZ5DO5DfgecLvrGAoclo1mxjyCmQCKAEM3iyB4zlMRgxhPMz/WlgmdGL1fw81hMMVM3np//uX1GDesMZ4TI6Bczj66HxLDGLWlI1DN+TGW7ojC8U0p4EfitTfX2A8qFkwm/QyG4l1DdA8gwhVwSrl1iWwNuCjWYr8O/b4EG+fOnkWnieybQSz/fuU0abVbm3fJPuieXXS5uHTDZCJScUzT3H0qrIegP5aFkDWWD2o5wLFmqU1hh9OVk70H57ZjsPYJQynTcMd/nb6jCGwmCJc80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 2:45=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Yafang.
>
> I'm not going to engage further in this series until the situation
> changes.
>
> LLMs have made it much cheaper to produce plausible-looking patchsets
> for new features. That makes it easy to keep sending iterations of a
> feature which touches code that the submitter doesn't really understand
> or hasn't thought through in depth. The reviewer ends up doing much of
> the developer's work while the submitter sits between the reviewer and
> whatever the LLM produces. I think this series is an example of that.

Thanks, and I'm sorry for the time this has taken.

>
> Some examples from v4:
>
> - A folio belongs to a memcg and that memcg decides the policies around
>   it. That's how memcg works for every other memory policy, and tasks
>   belong to a memcg too. The series still splits NUMA balancing into a
>   task side and a folio side with different semantics. DISABLED applies
>   to tasks but not to their memory, and the two sides combine the
>   hierarchy differently.
>
>   On v3, I asked why. v4 moves the storage into memcg and keeps the
>   split, but doesn't give a high-level reason why NUMA balancing should
>   work differently from how memcg handles every other memory policy.
>   More generally, the major design decisions come without the reasoning
>   behind them, and asking didn't produce it. Each iteration only barely
>   updates what was pointed out in the previous one.

The task/folio split was my attempt to avoid defining a single owner
for shared folios. That was not a principled design choice.

Shared page-cache accounting in memcg is not a clean ownership model:
pages can remain charged to a memcg after the tasks that used them
have moved on or exited. That limitation is real, but it does not
justify giving tasks and folios different policy semantics, and I
don't currently have a defensible model for the split.

>
> - numab_memcg_mode() walks up to the root memcg and recombines the
>   requests on every call. The callers include every load-balancing
>   candidate in can_migrate_task(), every task migration, every NUMA hint
>   fault and every page migration including compaction. This happens
>   whenever any cgroup has a mode set, although the result changes only
>   when a mode is set or a memcg goes offline.

You're right: the ancestor walk is not an optional optimization. It is
on hot paths, and leaving it for follow-up measurements is not
acceptable.

>
> - numab_memcg_active() reads css->flags once and the comment says that
>   this makes the three state bits describe the same moment. However,
>   nothing synchronizes those flags with the mode. In the lookups, the
>   check is redundant anyway because offlining a memcg or disabling its
>   controller already clears the mode.

For numab_memcg_active(): the technical point is that the check is
only needed where the memcg does not come from a task/folio.

In the task/folio lookups, the memcg is tied to the object being
examined, So the active check is indeed redundant there, and I'll
remove it.

bpf_numab_get_mode() is different: it resolves an arbitrary cgroup id.
There is no task/folio context that pins the policy. So I use
numab_memcg_active() there to skip an unusable memcg and continue with
its parent.

I agree the check should not be in the task/folio lookups.

>
> A developer could cost reviewers time before too, but each round took
> the developer much more effort in comparison. That kept the effort
> balanced between developer and reviewer in a sustainable way, and it
> made sure that the developer learned and improved while working through
> each iteration. LLMs broke that balance.
>
> I don't know what the right solution is, but at this point shepherding
> patchsets like this doesn't make sense for me.

Anyway thanks for taking time into it.


--
Regards
Yafang

