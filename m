Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93530606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g/HGem5K
Received: by kanga.kvack.org (Postfix)
	id A11476B05C1; Fri,  6 Nov 2026 09:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E90F6B05C3; Fri,  6 Nov 2026 09:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905836B05C1; Fri,  6 Nov 2026 09:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69EAB6B05C1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:19:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E81E7160717
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:19:54 +0000 (UTC)
X-FDA: 85404903108.30.04730A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4AB614000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:19:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/HGem5K";
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGx2NwMDbqtPHMPNsh9EPN5476lLpafXJ5wg9iLlkU0=;
	b=3+QjH2mBRJNLXqrj7/n/wXDcVOAN2BVrT0KKT/vCKBk/K8/MjeAXK0rA3+iC+DtQMlEGlY
	XvCp2D9C9ifjl2nvPEwW/eCDBEqtGcQRM8TTMnhG4531cZZ5PhFPH+IITjBzQSNd4GkV/z
	nySvX+3IJSH2BV9jlZNM5Ytd8FwgvfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g/HGem5K";
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974793;
	b=YckOFlyK3dRyiJxIKcCGESS1KfBlgoX9dFU8TtNcqCRgfufvfFU57FryFao09CG/7CeX8o
	iGzUFXl+iaZjopiY4qldtROE+b/Wie7cTjLaWf6hxmBu1oPao2jyvnXtBOEnsKk+CH4fW0
	ZkSMaIPwkpoDFQk24eEMuVrHxvpdwtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81DE440B46;
	Fri,  6 Nov 2026 14:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6B71F0089F;
	Fri,  6 Nov 2026 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974792;
	bh=nGx2NwMDbqtPHMPNsh9EPN5476lLpafXJ5wg9iLlkU0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=g/HGem5KtJgc9W8TdrJwmhR17aQrSNJ/3WiUgE8cbYrwLqR+8CiOTS2uxScKtbGx1
	 2c6ZPsrzgjJk6QeVkM7SksMsqAMVHzIPtrjoCThNVLRzZkyXLs3fRlcuk/1ieJf6uA
	 XgkSZqPTiFHZAjJQx4O1D77vN3Kr4sy7gUnO1Av7IfWWeiZWgd+rsuGRaN35Jjvajm
	 JYPtGJ+oHjIv/8muL9XlSFCGAMWWSEVdAtfBIdf1rN+YqwnOkIcKs80n6KttGgm/cr
	 w8WDikVb8t/E8NiEJJ8ZwKg2/Bo1m50TCIzF1c/Frj+iJVc2sPClcjdQanVGjc44Nj
	 04wzD72CKNRcw==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Christian Brauner
 <brauner@kernel.org>,  David Hildenbrand <david@kernel.org>,  Hugh Dickins
 <hughd@google.com>,  Jonathan Corbet <corbet@lwn.net>,  "Liam R. Howlett"
 <liam@infradead.org>,  Lorenzo Stoakes <ljs@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Mike Rapoport <rppt@kernel.org>,  Randy Dunlap
 <rdunlap@infradead.org>,  Samiullah Khawaja <skhawaja@google.com>,  Shuah
 Khan <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/liveupdate: Add a test for
 preserving tmpfs files
In-Reply-To: <auu02-iDbVaEL-4v@google.com> (David Matlack's message of "Wed, 4
	Nov 2026 22:42:35 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-11-dmatlack@google.com>
	<2vxz1p90jzx4.fsf@kernel.org> <auuJM8c-bE43NP54@google.com>
	<auu02-iDbVaEL-4v@google.com>
Date: Fri, 06 Nov 2026 15:19:47 +0100
Message-ID: <2vxzjymqhwjg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: pitre78uhmgxb8rgk94ssnshkifhfdpa
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4AB614000D
X-HE-Tag: 1793974793-674951
X-HE-Meta: U2FsdGVkX19bR0ilUO3DazfuZl0W5LQTzpsCqTc7JVAigku8LiWNaTRVR242QQOupyl+GdwvZI6vIDyaqj6xjXNgFVsxA9e+vKIBInMYuIlT8l1T1Pg0AWQqQiPKN8LuDVM72vp/xQbe5PgRuFeuQrSlYizlszIVvAzVsDYIMIrMQ6NSC5lZRet/KFFiTQOcANufygB0x3wvEc+w0qCnVz8OS7fbvYOldXMr0JRNqDQ+TYvFWs7QCrFwzKgp5km++T4RYS5u256kq6rLSHrWiO6eDCO5uIBtweK8rUWx9U5bLwEkqtNgxdpBUpzfB2G0HfsHKvpxkgssSiKk4mfK5Rvx09ArTg3UwgqENP7qJZPfJ99FNVXplmBEY4dadN4KpX4B1Gj9pKTPpQUf3dQWe7QBgmrWie1xaYqEN2+gIjaUSH4KZIYbf956D45XrTRnZLOtkhWgFTBX7H9CvWoByAvvwUhxBGAASIgsnNa5oD5/r03TinBbfTEz4ZS4vBjBD1pA/LytkRv+7CQRcwjCo3uqFSGeekLJa+YoRIQ8m+zP1rifh4LD2KyxScLu1BRBK2PaEcFq2ER8fWaF0UIzUWkpx1bblxmbF1oQVVVWK/gVo+AD7N4c3GpIgoBRT+yA9I03+H5ZMQxemj7sCIZtj8/6aUoYyRfNe2K1u8mKHvcRjMR0qYdxSMxNMH7LQ3tg1NmnHbHmtB9e/w45n7IHvw/HpNeYcaMchUqywGM1JxlTjQspRV0gbYW6nlHAtpRkVjLoQnpAZ50WjW369+OLQ4kADRP5mfIA7ACfaepPi/geRdOuqiYXc/gyp6dxN2LsFFMjofa4hL7tTmawxztHQSVL6HF/6o1RTaWj6BB8a4qCw5TzwnwthPGFckZsMhXRhn8txbJNNa4jc/tk5m//HCaaHncS7UfVp2HkIc8298VDXZg4bLXCOo/Hm1oZsBpgDU85lPeO8Z6ofgUbyhR
 6Qrdb41V
 x6C9hYU106/UKOuztwhjstgYHYHs8yjKpK0NeGURKlWAhd4mKyigQB5PXYAfrQKeHq15ajpL/lxxY0mF47UZljKP0cQhQ80fj4K+cc+fCZMkfabcNSek6p0KzvzvnBSotrInjn55sdDD0jyoeuuV5RVKXEEYwOfX7t2+sBIsDs6MO+bibxlV8VjHNeoh8/QgP6s6MD5rZa3Kjok70toaV8eM9VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, David Matlack wrote:

> On 2026-11-04 02:37 PM, Pasha Tatashin wrote:
>> On 11-04 17:59, Pratyush Yadav wrote:
>> > On Tue, Nov 03 2026, David Matlack wrote:
>> > [...]
>> > 
>> > Umm, no way I am reading all this...
>> > 
>> > LLMs are great at generating tests, and I'm not saying there is no value
>> > in this. It is just that this massive code dump is unreviewable by
>> > humans. It is also unfair to the human reviewer because it took many
>> > orders of magnitude less effort to _write_ them with an LLM.
>> > 
>> > What do you all reckon we should do about this? Trust the LLM to get the
>> > testing right? Do we give up human maintenance of tests entirely? Do we
>> > do fault injection to test the tests themselves?
>> > 
>> > Or do we make the tests smaller and more human reviewable?
>> 
>> We need good test coverage, but I believe we can break this patch down 
>> into smaller changes where tested features are incrementally added.
>
> Agreed that it needs to be easier to review, but I'd like to keep the
> coverage. Here's what I have in mind for v4:
>
>  - Move the preserve-side checks that don't need a kexec into
>    liveupdate.c, like Pasha suggested in his earlier reply: which files
>    can be preserved (permissions, read-only and append-only files), the
>    frozen size while preserved, and unpreserve. Those then run with the
>    regular kselftests instead of only in vmtest.sh.
>
>  - Split the rest of luo_tmpfs into several smaller commits that add the
>    tested features incrementally, e.g. one for the test infrastructure
>    and basic retrieve, one for the open() flags and creation checks, and
>    one for block accounting. That makes the series longer, but each
>    commit is a few hundred lines and can be reviewed on its own.
>
> It will still be long, but I think having the test coverage is worth it.

Agreed.

>
> Does that sound reasonable?

Sounds good. But I think practically speaking, it is not possible to
review the tests as carefully as the main changes. I think I'll rely
more on my LLM for those.

-- 
Regards,
Pratyush Yadav

