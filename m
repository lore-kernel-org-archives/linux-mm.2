Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17901CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CFB66B00B8; Mon, 19 Oct 2026 02:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6A86B0142; Mon, 19 Oct 2026 02:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F257F6B0151; Mon, 19 Oct 2026 02:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3EFA6B00B8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:51:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69CB71C3EB8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:51:05 +0000 (UTC)
X-FDA: 85338453690.03.E7431A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BED41100008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:51:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK8yiVz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392663;
	b=p+3+e9QQQCV3vEPwrML6FC7wk8mSFm0BVxDh0KtZEZHOnuSGRWPmEGrI/frNCNaIo3XVX9
	KHlFo+/fkl/YjcmqBHkiwBIO/H61G8Z5GVXNlL/VYiHNhNtOJ+Tui8lR8KBQxbZ8nn1sL5
	JEbtQyK6VNKavsoXlW749Ra8df5cnz0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eK8yiVz2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392663;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjzT6/G5Js5JKbN1AJPuPZCzSlx44rEhWlt25v9LylM=;
	b=qIb8QuTbr+w3buj9T2hp7WfAf9Kz3JZnI9DgVuF/Hnzgs25NMiWtfH25OxDUiDV97qTx20
	OMuA15JPD8ZSrNNU+mSpw+Gk6UF0cNVlPeol2cMcQj8OmbTQcGyskODPD/QSFT9rI4oYxg
	YsosiL0mg7duu+G4F+n9ES2hrEHPdlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A88594065B;
	Mon, 19 Oct 2026 06:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573FB1F000C4;
	Mon, 19 Oct 2026 06:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792392662;
	bh=UjzT6/G5Js5JKbN1AJPuPZCzSlx44rEhWlt25v9LylM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eK8yiVz22bc3c7SLLyS4ovWUifFP80iUT34W24jfl3flLu3r+DUOoSGOdHM3r8cfQ
	 dElja2Br5dHs3rZnAsGIlEVghloNop1DvS7fL3+ybPjzCLAygrc8asQNOyp3PfeAkU
	 GtWQUqWXIE6RNsXw+0QPmnuv9Yd+m4bWwuTS1Fs2nc5xdORyHIKhIqfznFngdEaL9a
	 PqfIyxpMltt5g2QMwtIUvmr+10H13A9rgoMoh07ljf1KWceVg4ve0id0yocgTZ6+vh
	 m5eZOxuKwmaeL8QPwJpG7EoX88bNvZ/vF1VBlgXPCLLqrOBmMkMQ/0NXqzXiH2Zwfq
	 fNHlwptS4YfpA==
Message-ID: <sashiko-outbox-176703@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 bpf-next 5/5] selftests/bpf: add tests for the
 numab kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yafang Shao" <laoar.shao@gmail.com>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261019064157.29885-6-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-6-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 06:51:00 +0000
X-Rspamd-Queue-Id: BED41100008
X-Stat-Signature: ha3h3brg65oge3ptp3ecd1qqsmz9a3zt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792392663-922788
X-HE-Meta: U2FsdGVkX1/9NdHWfIQOpqlYlKFqP+4WoIBufC1brsXmArH2zJCYn89PV8Bt4QXCx5LGDrZcyZ0Yks4GAV7lTgrwLUDDhpR4/R44NYpEhFnWalPCTqOp2JISGtKTIkOkFd7fjjUAvtPzGm9hGZAE2HFAL3bZzct4XDsc2JHK02hDAA2mFHbz7L5RouTBFLAc5u83I1A7nIIyWpCs/IURahnsQGwsHWqSSGtHyCG7TW2bJ662KpkAetfTxTmY8RecMZ6lpxFVOnFfJ24JpTk8XJbWynr/6qZ1zhhXG/StkuecLFiKxN+XrBIx93htCujIAFa4Gz1VXWhjcS3tukI0bdP9wBC5JmfjbwmdzFRUjj9xAW3cIDbYUnhjMdrvRjzkIoQKUlPysTQiySD/TqYqaIMLlToHcF6ttKc5P6S2mTHxZ1aqwL6zDQu9wYQKUqYMFkaAZgSF3rc1d6uSZ/5VNv9R6XN4phtDwYDZnjj+N38mF5y/wC+N2gL3FrDyA20HeePA43zrPAw4cn0KF3GG4U1tWNIdTT46LB11H93OK6c4UKsVsvJuzYdHEgEnBnkSkY2+GOETEiSdbV8IVRk46t+x9+KawDCQi9EYbn6vznIIwHkLJiLyuhf46OGBKF+/eYgZklBkcQXwefsMmnyqmBcFXiv+57YdYsBfZlIyo3kxtiB8PayVbmKu8KIFn6LZbe0FXJfIwR3xOcnbw4pFiOQTu+QT0CKreTL2Hu9ORqjV3CA3cyKVuPweYdVsLFBHnZwWhSB9Dm/CSq1+zMPKgeAR2EHuYdOb51FcqZziUm0FhSB0cSZBdSWc+ZAbQlVCVEnu9CcxLd5tEldPBN4PVVeoFC9TpTHf70PuYD99FolwUcKclliMCQt4+pcMa0ofw77LmWc0iOZvEfX+ev53+yuwuA1YmfnZcajIToGyJYLse6NI30czsG/+Ubh5Yoq+7Yqvi1ZUeXClYCvL5tT
 9mWWWdSB
 Bhm5tci3O1IvOMFAen4HUTaQuHktN94Gbhxt7eKUEBhLEvMgKfDq1HODmWbNDoH0lDUMeCXQWzdf+x9guOBxO65Fuw0BS8C0FCUoK2JmP2pv/AqaLlb6lDOI/66K20XzWgFAcfmYFWiRdhtNnSoQcHjzShKpS9kmnWjQeNIU9zKdC2Vf2XLe91eu1oHIHFsr696vjQfclypKOep7aaIzJG6z3rYUiuiNWlp/Xrmw1sW7dEnq5aw6zNu4c0lCYgi8+49dHLsiAD8632InarudOH2dKw3NSwRNjZEtbFyu2lV3XXYI3/e6bruT+2jPbck43e3nbO1gmK7RFhUTMV6KTbiKYhpyVGkHAMsIVOKA1/kSoXvhLnBMfpxT/Du2cjJxx9g+Ol404adh14Uuxsyv2Vsf7oEjhtzT3h1k3G+N+ZpfCoIvJyFjsr/Bqh+BOjd2BDuop/gYuZQMmxe9MCXeAD58vk3kFKoSbQma4eAee7UiVi4PEZTOxwE+HDHzDL8Ps9uR+BatCIdwoOlUDMX7UXTtPfa/jxeAsVk4O2F/A2DuiGp8WFvR6c28eOXotks1MjhnP7fol8yXZQLw5PsYrJfPX0aFeKfRa79hIDDdCGN20kS5ONyOVEBu78zLFtBJaGrxuLtwVk0ejREeeoFptuvmebr4P/xM0Vpf6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/bpf: missing kfunc BTF skip check in test_bpf_numab()
--

commit 07e4c14213f29b11a7ce19b88e46e524dc48e78d
Author: Yafang Shao <laoar.shao@gmail.com>

selftests/bpf: add tests for the numab kfuncs

This commit adds BPF selftests exercising the bpf_numab_set_mode() and
bpf_numab_get_mode() kfuncs across set/get roundtrips, mode validation,
invalid cgroup IDs, and cgroup hierarchy combinations.

> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab.c b/tools/t=
esting/selftests/bpf/prog_tests/bpf_numab.c
> new file mode 100644
> index 0000000000000..7ce4b8153c42f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
> @@ -0,0 +1,227 @@
[ ... ]
> +static void test_set_get(void)
> +{
> +	struct bpf_numab *skel;
> +	int cgroup_fd;
> +	u64 cgid;
> +
> +	cgroup_fd =3D test__join_cgroup(CGROUP_PATH);
> +	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> +		return;
> +
> +	skel =3D bpf_numab__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "open_and_load"))
> +		goto cleanup;
[ ... ]
> +void test_bpf_numab(void)
> +{
> +	if (test__start_subtest("set_get"))
> +		test_set_get();
> +	if (test__start_subtest("invalid_mode"))
> +		test_invalid_mode();
> +	if (test__start_subtest("bad_cgid"))
> +		test_bad_cgid();
> +	if (test__start_subtest("hierarchy"))
> +		test_hierarchy();
> +}

[Severity: Medium]
What happens when test_bpf_numab() runs on a kernel built without
CONFIG_BPF_NUMAB=3Dy (for example when CONFIG_NUMA_BALANCING is disabled or=
 on
non-x86_64 selftest configs where CONFIG_NUMA_BALANCING is not enabled)?

Because tools/testing/selftests/bpf/progs/bpf_numab.c declares
bpf_numab_set_mode and bpf_numab_get_mode as strong __ksym externs:

    extern int bpf_numab_set_mode(u64 cgid, s64 mode) __ksym;
    extern s64 bpf_numab_get_mode(u64 cgid) __ksym;

calling test_bpf_numab() -> test_set_get() -> bpf_numab__open_and_load()
(as well as test_invalid_mode(), test_bad_cgid(), and test_hierarchy())
fails in bpf_object__resolve_ksym_func_btf_id() with -ESRCH and trips
ASSERT_OK_PTR(skel, "open_and_load").

Should test_bpf_numab() check vmlinux BTF for bpf_numab_set_mode and
bpf_numab_get_mode via btf__find_by_name_kind(..., BTF_KIND_FUNC) and call
test__skip() when the kfuncs are not present?

> diff --git a/tools/testing/selftests/bpf/progs/bpf_numab.c b/tools/testin=
g/selftests/bpf/progs/bpf_numab.c
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019064157.2988=
5-1-laoar.shao@gmail.com?part=3D5

