Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF44CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 00:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D498F8E0045; Wed, 20 Aug 2025 20:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8758E0008; Wed, 20 Aug 2025 20:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F258E0045; Wed, 20 Aug 2025 20:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFCE58E0008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:37:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A9DAB6C9E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:37:29 +0000 (UTC)
X-FDA: 83798901018.23.8A3CA6C
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9C091C0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:37:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hDjBdqY8;
	spf=pass (imf22.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755736647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaWiycjbp+an5S1lmP1IBUI4ltkMoLxdO+qHmbgyWx4=;
	b=lbtdkQcE/OZGTHY/xrus8S2FSBolulc4RfF+YBZw7mgeOloMrq7DRTBdlmVGH/U6ynTauI
	OD9n0FIoEnbsBumqy7+GorhUAYb/yimve9hxN17asJ6DRzAQN13hxV4LI7z5+9gtUPGTZd
	OAM5xwgReU/JfaJiV05X/9oeO9FjQlo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hDjBdqY8;
	spf=pass (imf22.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755736647; a=rsa-sha256;
	cv=none;
	b=nEnUdobCytfDe9CTXT8ZFhY572qY2knBwO/vFeLYBoeP03t9Aul904UTiyoKiOwlJjmDXh
	mFphH5A8YlxJsW+Kmq+8Ya8/TsHGvj6Xe1CnXQfguXFOmMfQ+1UCT993UlA9oTvVGqqr1L
	PgCQcaKKFRwfLgC8/ZRek/jx1zkyn5E=
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-61868d83059so2609888a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755736646; x=1756341446; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AaWiycjbp+an5S1lmP1IBUI4ltkMoLxdO+qHmbgyWx4=;
        b=hDjBdqY8vT6+omS23mOYQBJCpjPi7lmLppEGVMaxZdkuJgSQ+gihBjRcA21sOru01/
         acf6TnK1S2d04h4A01iN2kit2nYZtC1SfFOtSxEL9s7JnhiJSq74jfZN6/hKO2r2yGsM
         t0et6ePqZ7TTNPV8SKAgx3mKDAzD/c0JYIdq83EMDiwdOOi5H0WTm3/D8SRFwXHjWTPq
         1QapsPq6wPS0paNY1W+MDepWNbekfgPTF8N9xA8F2q3P39Kc4TmA8fsMnzelM2Kte8LY
         k88xacGuew3znyJcUPh5r2bx56/zugwt9UCODAJJaxihzGLeBlQeTUE3nR2LJsdSP0ij
         vqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755736646; x=1756341446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AaWiycjbp+an5S1lmP1IBUI4ltkMoLxdO+qHmbgyWx4=;
        b=T7OxdKW1ST50bryIg8V8yGotxzUcoY0deEGRgV/n1Ceg4ihMPccUpBIhVmcjpH52Sk
         n4DDWSPVBriRM1f4mjJazZmLzRG4y3MYrhYj9c+RkthJpdTiz+V/k59s4KAiPlnvGXkv
         I1MH7VXVROSxKL5Gh9RZAtGlP4mxGz37B8s5ZhRVy6jS3/FKBMLjHU0i6fresziGTg9P
         uMZZT6k+QAv6xoD3oB8gbhqgnwJ5bcPDYxyLbmQ1tQHw5vkK2oWw/7UzVmI91nBfMkB3
         9GmU4etISY8mPrKZioEwMYbVkIEV0NJdyVUx5NAj/8hj9lg/forZx9++pQ0Auz4aIlaa
         8nVA==
X-Gm-Message-State: AOJu0YwZlt/dcZOCmp1tB5qWIhSwgcYCfsB6Xc295HlUgFiptAReQGy/
	Vh1lc3j+eCjxlnmF5b15I5z8PqGxS8Q5T2sy0ZpdSPa7smgm04sms4PDJLyuUYxT9+mbu607H0J
	0r6pa8eWoUtpM1gbvTN47xGexRKkMiyk=
X-Gm-Gg: ASbGncvd3QaZmvX1xlUW5wJWTNBv8geLjPzSU993SfH7qQgPWPD1MYWSP/4GCaJSwTo
	6FmZhOLkQLwRgJbZo/N06SNN+Y6uREMHstRYUoXGiDSmPQECcIGCLHibdnKnbCkUfyYT5BxDipk
	vZ1i2ydxsZpXEd8lu4PAO9HzNuI+RhS3mdQHU0D1FvFcTCRyd8sNw/IRJwVCGYaefYwTxhzrfd0
	mbDhggR
X-Google-Smtp-Source: AGHT+IGFlizhcX6BWM8Ymib52+AagzmPrdgnHqTZI6F1VDgVgHX1/2aLpO6P4WQH2SSBMG0HMdptOuNIG/DHifm5BLc=
X-Received: by 2002:a17:907:2d22:b0:af9:3f99:1422 with SMTP id
 a640c23a62f3a-afe0b00fef7mr38375966b.5.1755736645809; Wed, 20 Aug 2025
 17:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev>
In-Reply-To: <87ms7tldwo.fsf@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Thu, 21 Aug 2025 02:36:49 +0200
X-Gm-Features: Ac12FXzsMSgLK-MYBBqTfMM353IQRheSoWImI4AVOKJlla4jC56TBdVvPSNUhKo
Message-ID: <CAP01T76xFkhsQKCtCynnHR4t6KyciQ4=VW2jhF8mcZEVBjsF1w@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wyjs8jrquxx3own5gy9h9dmmfjaw5xuq
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C091C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755736647-326630
X-HE-Meta: U2FsdGVkX1976wnIfym82zj5Vr3ShdtNkND6VQnfXvesVia9saujdF4V9nLa9mK8EWI+KiMhm2By6CQbp9BUIAZL6IfWGhP1x2p0w49UhSBljz7i7P93FHHv5OPqIhxr2OeWjvsJv7sj1Ee2DqUQOTQr7xjVL8vZB4xGb2/pppYOUNB5KpIMrW2Tc/DIc2yiimEChmzhv2kBLv0HShnIUN9QiVY76kgvtAjsySHvl9rw0BVn8zK1M89J7YPMiQUz+xfRuvY2+d4zkP29dGaftJyOeOGs+IKbJe7snGeSfjJUxK6F+cRsJSujneJu0Ai5G76xP46UeCHzXt8YTCUJylHW788PFJGX3+8XaTUhOK4WOdnew/Hs0KU/PdCOu/VGipKTa0r/SCLdeJdTsHw13rQHDIGcRuHIukqqfQZBPUnOPGwgwHZ0x68qd1MzkYGqQCCOYuxo4lmiDHUDFg5yF0a/VKVB1n+1iNNwA5AvEpw/55IQtFMOHOM0LflAJAUpOc41xBB2FP7VEs0VZGC5HjWK4VW7ek9GrNq0zyqT9Fbl751Y6XFuVfA2xVsR2HNrJFDqbuOnN2JBgvPFE9uhT5mcrH+maVHNPuavEu5GEUTKC4JIIAqR3UKaUouleuDs65Gv+dirtGY56BnsRhJI333Fx6BdKoKAPiQZU+n86gYjcoBmmzaegnOzXE9z6XQG7Q7kj/44cNWg+VFCwSUER25zZQh/IuDPjf2uKM66y+0HyYp5yUDfa3YLKtgBDAJGs2w8uJWfmnWeLZQ43rzotFmwZrWBPuG8o6uEsCF3oH9SfbkjoIeG21CFHAOduGuMPbwLKeGpcUTHkXxwPqiIkHOVTF6KPq9v7xVbSfKAZbqhEysE/7jFJxaMhT+/Zocwbq+tVUVq++YVnNOPCExsTODqZ3MYG1Fodpn1UrHN+rzBS/ued1RfkaUPeCfMzy3wMD9cq1qAIxoDfmymqlm
 aKQFMxBD
 n8yVnXS+95v8qLJkKH1pu0ROgutttZ79rc6IwXeFwn0oCqnc/tHMDuXdoKX+O2TrT/9NFkN8B9kCMozUWSC+L3fO/a6DT0P+aLpe/bg2vWZh6dwfyj/61zhyQjeZ00wuFUS0GqE3RfTXKR3u5oIqVlUiv7WBR3JUhhmcfNq9Cmz4Z2hyVcWzNu+lOEG6I35pyAUb81xfLEHFMp2Xjb7JGIJ97GNTaTa1TwwWll1AQmTvpqEhhqiKuQksddWqlQiEcez3+0Oc+VV4vhBxuwKmkhwuoVBUAE5qUI+PnTs1ZHJYdSC7CnXRhIWojNrvQqIxI3CX1d1fIJm+1xMFn0cN1UQH9HJ6SfeiRlgJW5F7DjBJoPoLBsmJ6Rd8ezdT18ZJqz6ioWGX3C6m8l5lezOjILWHc59RVt2YBe32TXtm0ZnWUWR9xc6hUj7ewTqatrmaSy/f8lkbcr6aqMkp9Tl3tCi34L7iCzRkltWUhVxCGcNdOai+RsekV3+DD12beodsWMvVh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 at 02:25, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >>
> >> Introduce a bpf struct ops for implementing custom OOM handling policies.
> >>
> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> which expected to return 1 if it was able to free some memory and 0
> >> otherwise.
> >>
> >> In the latter case it's guaranteed that the in-kernel OOM killer will
> >> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> >> field of the oom_control structure, which is expected to be set by
> >> kfuncs suitable for releasing memory. It's a safety mechanism which
> >> prevents a bpf program to claim forward progress without actually
> >> releasing memory. The callback program is sleepable to enable using
> >> iterators, e.g. cgroup iterators.
> >>
> >> The callback receives struct oom_control as an argument, so it can
> >> easily filter out OOM's it doesn't want to handle, e.g. global vs
> >> memcg OOM's.
> >>
> >> The callback is executed just before the kernel victim task selection
> >> algorithm, so all heuristics and sysctls like panic on oom,
> >> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> >> are respected.
> >>
> >> The struct ops also has the name field, which allows to define a
> >> custom name for the implemented policy. It's printed in the OOM report
> >> in the oom_policy=<policy> format. "default" is printed if bpf is not
> >> used or policy name is not specified.
> >>
> >> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
> >>                oom_policy=bpf_test_policy
> >> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> >> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> >> [  112.698167] Call Trace:
> >> [  112.698177]  <TASK>
> >> [  112.698182]  dump_stack_lvl+0x4d/0x70
> >> [  112.698192]  dump_header+0x59/0x1c6
> >> [  112.698199]  oom_kill_process.cold+0x8/0xef
> >> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> >> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
> >> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> >> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> >> [  112.698250]  out_of_memory+0xab/0x5c0
> >> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> >> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> >> [  112.698288]  charge_memcg+0x2f/0xc0
> >> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> >> [  112.698299]  do_anonymous_page+0x40f/0xa50
> >> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> >> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> [  112.698335]  handle_mm_fault+0xe6/0x370
> >> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> >> [  112.698354]  exc_page_fault+0x75/0x1d0
> >> [  112.698363]  asm_exc_page_fault+0x26/0x30
> >> [  112.698366] RIP: 0033:0x7fa97236db00
> >>
> >> It's possible to load multiple bpf struct programs. In the case of
> >> oom, they will be executed one by one in the same order they been
> >> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> >> - an indication that the memory was freed. This allows to have
> >> multiple bpf programs to focus on different types of OOM's - e.g.
> >> one program can only handle memcg OOM's in one memory cgroup.
> >> But the filtering is done in bpf - so it's fully flexible.
> >
> > I think a natural question here is ordering. Is this ability to have
> > multiple OOM programs critical right now?
>
> Good question. Initially I had only supported a single bpf policy.
> But then I realized that likely people would want to have different
> policies handling different parts of the cgroup tree.
> E.g. a global policy and several policies handling OOMs only
> in some memory cgroups.
> So having just a single policy is likely a no go.

If the ordering is more to facilitate scoping, would it then be better
to support attaching the policy to specific memcg/cgroup?
There is then one global policy if need be (by attaching to root), but
descendants can have their own which takes precedence, if it doesn't
act, we walk up the hierarchy and find the next handler in the parent
cgroup etc. all the way to the root until one of them returns 1.

>
> [...]

