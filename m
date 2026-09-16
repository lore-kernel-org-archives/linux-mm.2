Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6310EC982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512E76B0096; Wed, 16 Sep 2026 11:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C186B0099; Wed, 16 Sep 2026 11:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CED6B009D; Wed, 16 Sep 2026 11:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA8A6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:12:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 942C0140757
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:12:57 +0000 (UTC)
X-FDA: 85219967994.17.D872A0A
Received: from mail-wm2-f5.google.com (mail-wm2-f5.google.com [74.125.225.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id B8A8340015
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:12:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMJsGwYC;
	spf=pass (imf27.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.133 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiyXCBgsYQLbIjno9HOYcORcmeh+vcq7qFmr7RtjHrY=;
	b=tegbcbkEfzIALxlT7ERMO5MajkkQIrKj4neISbgsPW0/64Mlcw2D/SV3mqNA6U0MKXhHzz
	mEYWdu6prjojvAO50tmFCH51B7VE55aikbLEd7H4PeLqImff1lUCBkIrGOVfjhKFPUCt9P
	n3JBC7ESaOYCCyUGXEjCyV+MVKEgJqQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMJsGwYC;
	spf=pass (imf27.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.133 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571575;
	b=gEYx3dRUc//mS6mmayUsFKYw7bNi6qkVH5WrCd17lqNgD2apXtkdVzyLaMD7uQy6KmSgBm
	HvaapUrjtIkPQ0XsAcFRqTahSAvfwNmmoDlzlqteSbSex9DCo+emmhgGEUvPfotN6R4EMO
	yX+EOyLbp10jyU0EyEXJK548QjvrGxQ=
Received: by mail-wm2-f5.google.com with SMTP id 5b1f17b1804b1-49e667e3c45so12069085e9.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789571574; x=1790176374; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NiyXCBgsYQLbIjno9HOYcORcmeh+vcq7qFmr7RtjHrY=;
        b=NMJsGwYCNyUyicBADJrW/JdmrqZ/jFDGbWGtNb4VE6YdQWlVjfcvrL6im4JAXpfW02
         p3gMBD/+3Ni7TZIz/Ib752l1mthyAk/MY+7WS2zgxpvIIv60otZp8ze8H3jt+67LFXrz
         XDWYOui1b3PUXyCmz4/+XBrMl6E25t9RuZo76hUcf9Fmd8cDLBlyG8vQmiYw9v/uNnV9
         JZaFSW3Keml+QDF4bfBG3A1hs+G6BqfUjNuwDGqul11KWiD6Sc2tPFIS+1MNk3Co1fcl
         0Rx1/HVSLaCCZXj7W7Jf2Dg+/03Agz3HkigqWeieCPHWoCMp8wDXTf7zXSIXfzh4s1OZ
         vkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789571574; x=1790176374;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NiyXCBgsYQLbIjno9HOYcORcmeh+vcq7qFmr7RtjHrY=;
        b=FnD3pUg1L3r6uWK4g6gf8A5iFFb7OhsWl39gLeF1fzh9zG0Dd5D0u4wB2mBX/6LbQu
         TUmoV0pytxJboX7QgNa5bgzTOQOdyefeK+BTRdfnERUbt32FQETbDblZ7wwCauu1vJgZ
         Hg6YDXs8FiIpmrg5KfPQjAaDQSeDUBGtXooSDi66NtawguZS382l9uRoL3Kqc3AwoNMf
         AUCCs6CClULNUMDXQy8fOpfRDcJPp1JlVaXp34IfOWgjK3sd/GKlCR7UJ+iOzJqibWiC
         CkFVo6S4yp6mxlnAIL6NaHPF9r5bemhundXgqIuQ/EMj0jFpj/vGLgDZ5GjQ4P9B+SVb
         R4Dg==
X-Forwarded-Encrypted: i=1; AKwUvByXkfonxpAjtgkCk0WNqetohAKEXXSuCoTE3iox1njcRt/QfY8I2wD+czuVcD7BAyil1IpLu3LgZg==@kvack.org
X-Gm-Message-State: AFuF++nIZdoB01WuiKVc5S4YvMt0YNjMoec4kQfL8zywYpkolHq8NeKq
	EfFc43yRYKf2dqESk63zDkEiOOk/MdyiFGm56kCrMFCL26Ej/+DuelEU
X-Gm-Gg: AYBFou2QEGnun+mgOxSM85B04jSbkVNEe+PEltFc+S+F34C64eR0xUUtYNNpzy28bib
	rOPsPjG9LW84JEvfgWq3J2+oGkq8aSQQVooWSL+5Gj+ASN0dbMYJ7Jb62s/QnR+RfpsIx74/i0H
	eo8I8XYLQcKj7cIj+Qjpi+54g+BFkUUK2KlQW36CXbsnFRbWCgsZx9di8mLUVzXO51XEltnsRMx
	dS3feMpA/sK7kBFXNhlxRsDroX8LFl3z7u+4jMXsDR9uiXITh9zbAkzijPVqsFvfKkwaUPTkf20
	DJcE9YqlAjKeLqFkUL7k8FhedjyDo8qX5H46p3nBQjzO3BesajtfHAWltGjCwwb6q6ft9lU1aDs
	qFA2prjr0InlgLvVwvfvOJIxhr33g6oOWrJ+jpb8k0lc7Wt/cAlmAQIvI0aUkcXN0bOETYltsKR
	DjEDz8HNycAUj3dCWj7UAcUQyOrERiAz2eH8HqFoH4YG3e3aj3fsAeQ5z2P8xA4rlVp/HV9H5X+
	cfS8maPqw4NSep8+Dp+RHtj3naZmju9vbwvfoZzey8On7jeAmERmu4y5ylHZkVDJxrAOWGX+PLO
	Ez3HCfxY/k+dliGm/lcL14hZW0kvF/S+LCueRg==
X-Received: by 2002:a05:6000:468b:b0:487:afe:c154 with SMTP id ffacd0b85a97d-4870d03e721mr2779653f8f.40.1789571573885;
        Wed, 16 Sep 2026 08:12:53 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27a41sm7320342f8f.18.2026.09.16.08.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 08:12:53 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 17:12:52 +0200
Message-Id: <DLGU6EUUD8HP.3SFNWRU1728IJ@gmail.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Eduard Zingerman"
 <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan" <shuah@kernel.org>,
 "Barry Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, "Hui Zhu"
 <zhuhui@kylinos.cn>, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH bpf-next v11 1/2] mm/bpf: Add bpf_proactive_reclaim
 kfunc
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Hui Zhu" <hui.zhu@linux.dev>
X-Mailer: aerc 0.21.0
References: <cover.1789475073.git.zhuhui@kylinos.cn>
 <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
 <aql_rkQMtlLmMstC@linux.dev>
In-Reply-To: <aql_rkQMtlLmMstC@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8A8340015
X-Stat-Signature: rht78j9q7m4npdf5ths7o31ixjtih3fj
X-Rspam-User: 
X-HE-Tag: 1789571575-622906
X-HE-Meta: U2FsdGVkX1/WpRhCjvsKSA+4AI2CovdwiQRbQAM8alfS8ioOgV3S7PJoSeNwUnMRifJ5FMRNsr/pEYBokPkg82nJ7at2+GbXO8SOaRKwq2j4Jy72632tFBH1PiRRBsX8w9P/gjhmYIfN3AcxJFGvOzSTzXpFAfGIDTSVQC+8HnY837EBKkqXJlVojKVLrV13JeIUv4Nt/hBlIHVc1Uc/KWjZItyZtku3d5YLVlreAX+jL08y7uFAqxOm4hTecOiJPN9U2TpHQgpVq7f4MyybR3uIzVWv+WAB0pIYQamoR9G27cD/R/ozCr5NcZp3Dd8DTy1IDiNRc+dfQc8XZ2/2qUcHCNywAz8k/Ut1QS9EU6DaM74rmDxXjPTYblAyIK66+1NF4hpYQvqqc/quktWYRyivF7AA93zJP8FSP7ygRezAFiVkZivC4uI46MOT5KHZipMfB3vcLP7NyXupGtCoXjUORntwYpUv1grS3USFEBBo1J4jBsgM8+87EH9znqLcOnQK9x2A+lKOVWEfQLRQW3GHwKPl8zkOtZeIgri1OCBmr9+H3I8nrASHnvvN/AFZc8VHjtLIhhmexAh7Mf+9f6yKdexI/ONhaXKVt31uWqjrHce4TuXXrS9VUr/MMwyArZgjsodDTaTrT11M5vxxzNDzqpcNVD4ack2Bomz3ZzIZZ/b/8r4pguGKfcgEyL/nvGW3nhdMXBYF7KNgJXwBwR4QrqPyJkaO/wTphz+lifN2JsEoyTtE4MacuIwWRKHfj4o0M7j49qYGk8/i87W4hMF3mcRYN+QVs++7etSY17nNhOOdUybbqjPUVG2UuaHgBNINU8CCDwCUW7uHRy1SszaGR//ojWNQqE6GyWsTv7IAxoLpIBV0XgVwnClYZcmGoSNnM+odFUdNdNyK4FTtbfvBF8Ho67yqQeNi8SJV5IZ7NticJzKAFXe/M22QfAbJ5MPcRORt1SmWuOFSWbG
 Vde7ev9i
 4VYAOLS0k3ZbxODGLMdj9CpKqqHRWiRYomIU/VvnMnXn+wu8KT52tkbUrdAQSb/xKMbZNigU386BO4cuPR7KozrF3L7mcuHoSWXMHPF3dAdr3LfS4iHOEVH6csbtGPQs2Hq35prDkJbhJ9IYPQi4dznFeh1lWF7J7Q4LduC56pmQBs6OwAkWD07cZpfQ9c5PdY6kWfdymigav5Ea9zb443S+mY0dOVBcmMzNxfGfhGPi3C0cJir3o/mA5UmV3Be6ZIxG1BIqNhBB8R8p5jpICu+YZZhs63FgWlMUCHi8SKThENu8QD7o46vremOEmUjTCcnE8407Vi4slPcqPJSbtj4r+WoFGllVl16p1RHUkKs+sRYfZZ2Pkyq5nLNjxYikK9nTkg3lgQHdh57o9dZ8LD8iqZ8D3H3pYjBEjFmiGAv0ckOE2a8QJUEsAPi9jKcNiO6iPii69e5sp8CQq1OFmcVowpuO/lZhZzEnKP5j6VYVUZkot1oxHgi9hHv3qjQUZ2oeStzequb+wm2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 15, 2026 at 7:26 PM CEST, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 08:29:35PM +0800, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> BPF programs can observe memory pressure on a cgroup, e.g. refault
>> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
>> triggering reclaim requires writing to memory.reclaim, which BPF
>> cannot do.
>>
>> Add bpf_proactive_reclaim(), a sleepable kfunc performing one
>> proactive reclaim pass on a memcg, like a write to memory.reclaim
>> but without retrying until the target is reached, so that when and
>> how hard to reclaim is BPF policy rather than hard-coded thresholds.
>> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
>> as high_work_func() does for memory.high; reclaiming more is left to
>> the program, which can call the kfunc once per bpf_wq callback and
>> stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
>> other sleepable programs may run with filesystem locks held, on
>> which the reclaim path could deadlock via filesystem shrinkers.
>>
>> Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
>> macros to an enum so that they are emitted into BTF and usable from
>> BPF programs via vmlinux.h.
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Hi Andrew and David,

This looks good to me (from BPF side) and Shakeel, Hui might respin once mo=
re to
address some of the selftest concerns.

After that, any objections to taking this through bpf-next?

Thanks

