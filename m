Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB974CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5AF6B00A4; Tue, 19 Aug 2025 19:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D726B00A5; Tue, 19 Aug 2025 19:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA2E6B00A6; Tue, 19 Aug 2025 19:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB41A6B00A4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:31:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82EFB116A83
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:31:59 +0000 (UTC)
X-FDA: 83795107158.10.1079A67
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E82C14000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:31:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LTRdl8Q8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755646318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTcaclbQ96B+bDuBdiEL8ARlJKH5hHL3AxN4AB69H20=;
	b=pZF/PKd5Kdl0ypbbmmsrFEwyLxBmaaC+E5MU/AD6SH6n3VFGNpjiygR9E0x6A7in9L/CaO
	aF6mN2A+l3q2gxh9TDaOH19+vpwsl9+hv6s7rUl/7Wgw2qVJBKIlbBecA0FtWE1rk79ZY0
	QRflvwXAtq5p05Gzsij6sXgXsS4smsA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LTRdl8Q8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755646318; a=rsa-sha256;
	cv=none;
	b=ywbtjkErDLpkP1SM0886I/EWO1Xetsj9lzgDG0rIDaRv4b4uudOB+R7q1/QDlLJj/ArRwN
	L3V+kTN/0fqIdexkXURs+rFNtPY1npn8FHaCL38tlM+Cw5c408wh9uTIdX92Kv9MjTeqD+
	8h+7lytlm4swtKC4yviMmg97/k0yTnI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755646315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTcaclbQ96B+bDuBdiEL8ARlJKH5hHL3AxN4AB69H20=;
	b=LTRdl8Q8BJzAwYcj49uLQDdPuiA4IbEhrwThhy3zCP+J/PfKqPZxPiKjiXbPvT1KZYtAZD
	ZHryLZDWX1GYdOQAh9ymUnZudKtpRCEv9aeYuUCTdc+SWe+Z90XJSSdbQK7kVmg8OPjtBz
	cLwcYOtaXcz9h0M0vfYrwMunlb4GRUQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/14] sched: psi: implement psi trigger handling
 using bpf
In-Reply-To: <87tt23vt8u.fsf@linux.dev> (Roman Gushchin's message of "Tue, 19
	Aug 2025 15:31:13 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-13-roman.gushchin@linux.dev>
	<CAJuCfpHUDSJ_yLEqtfmU0rykUGYM6tXR+rgVv1i3QjJz+2JU1A@mail.gmail.com>
	<87tt23vt8u.fsf@linux.dev>
Date: Tue, 19 Aug 2025 16:31:43 -0700
Message-ID: <87cy8qx50g.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E82C14000A
X-Stat-Signature: ywzgz5tnub9nqrdjjkcts83t37zr9bu3
X-Rspam-User: 
X-HE-Tag: 1755646317-613462
X-HE-Meta: U2FsdGVkX19VXYichG/8GLy0E+vuHtbsJ3wW5feOFDKqSZOn510nh4qo4WuBVJT4WHWo9T+5snUyBNozPpScv9DhsMbbn8r3JPG4poq5wmmJmhMyf7UQXzfidAS4WWw5rHfZQD8/TSlq8Gkyxsurazk8rJyIeNA4f+8xwU+lyTeldXfsXT6GM8z1N0iYWWsimFtlwO306v9Hr/OlRMXaMzOJt6ilbHtCIa4hXvOWtFsxGursn++GP42nNitAlICVkRTbjj1xBjVJcnv2ppC8RuD8PQa9n7DRK+3YBtcom4k3/dHKM9U9O0syvGqQs7GgYvpKKvqLGU7iwJzGEB17OndCJPiEtfCguOZuo9sgy2n5YSos8z/7g1SkDp2km1Iz4u0qtYe3mQUeuxF7rZmuxze3VnkCNTm/QrKXvhQr4ZSI63Q3UA2lYdwgmHESzPfi5+w1z6+bbV8LOomSMzx7hdY845Wr34opsr7hda6BdAZU609OiWmCFVGq2asWoA4SemKrgJC5hZIDNZ5mPHI4wF3t3kUHorQLoyAuTcd5yhHDrwICccgVIFLZURYG9cOy1Wml5ZpyrSVFtnHWeeIIFrtGwweqswMLUpxdQMnbadJg0sgGi+ff6PV+ayVyzwlH/M/S9UTIUe4SB2Kh0sen8JNXIHI+4kVVh1bXS+KoO7r6Dk8k2wEDNHldjOW2CpM1Gxtl+vxe6aBe4N0uMRcdd1aAE59NG48Ko7GxgYXCCk2ow+QnXf/CEkTLGj3TozCdhbSjuZx4bqqcNK9QAJ34mh0iYbpswmRZ1+oRbvZwo8DvhiN9iGBxy5kZnwwRu7bOCYcqANOTJrFBkTb9WJO3aFZRNf5ROHZUnFli1nvP1Gb0FGaB8oKd8GiDSPbGfZvg4Z58JooDsFvkjiZztDsk7ytf0fY8pfZyUN2Ic0Z6ZnQZ+YhvYwEcUC1BO0G2uX3J3LL5ehWNKACq6+3IsyH
 JsDdaTQz
 TsZfJjX8mfGfQfkd8UIMGUv+CF2hkJW3Mf4jz416DF20Q0Ma8oKwfIAnR/iWzLR1xVnSRHFe3HDhoO/nemZX5QX42hLCyfnQ2xLleRCSfxsKUO38rWjKrhP+FTL6fXndtU93nbryo5/tmfueebieCzlYXT5WZVmQzatDBMoDTM7B8MBEe1b3xwqFMKeC7tQ6kDPauK6m8uQh4iq1PZqRPpyhI27KCT2pPbcPSrLiVJ4LOHbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roman Gushchin <roman.gushchin@linux.dev> writes:

> Suren Baghdasaryan <surenb@google.com> writes:
>
>> On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
>> <roman.gushchin@linux.dev> wrote:
>
>>
>>> +
>>> +       /* Cgroup Id */
>>> +       u64 cgroup_id;
>>
>> This cgroup_id field is weird. It's not initialized and not used here,
>> then it gets initialized in the next patch and used in the last patch
>> from a selftest. This is quite confusing. Also logically I don't think
>> a cgroup attribute really belongs to psi_trigger... Can we at least
>> move it into bpf_psi where it might fit a bit better?
>
> I can't move it to bpf_psi, because a single bpf_psi might own multiple
> triggers with different cgroup_id's.
> For sure I can move it to the next patch, if it's preferred.
>
> If you really don't like it here, other option is to replace it with
> a new bpf helper (kfunc) which calculates the cgroup_id by walking the
> trigger->group->cgroup->cgroup_id path each time.

Actually there is no easy path from psi_group to cgroup, so there is
no such option available, unfortunately. Or we need a back-link from
the psi_group to cgroup.

