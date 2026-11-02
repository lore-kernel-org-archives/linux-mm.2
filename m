Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79325606A335
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 20:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fCxM4P/Z
Received: by kanga.kvack.org (Postfix)
	id 83F126B00EF; Mon,  2 Nov 2026 15:12:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F05A6B05B1; Mon,  2 Nov 2026 15:12:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692236B05B2; Mon,  2 Nov 2026 15:12:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3274A6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:12:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 898D7A0280
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:15 +0000 (UTC)
X-FDA: 85391275830.12.F2EC765
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C3311A000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=3")
ARC-Message-Signature: i=4; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793650332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjDOfNesHUvUYdnemATt3QpEnFnBaEWBJAu+ke/IeV8=;
	b=l6DRkO051q19JVuRMuCQNrtOEwE9+yivhRPNxg8UoEwYZ3Jrjb2OsYovkGiWvYn0d1bdEy
	8hSboTr8BWxw+NQi4tDmPnVU0Ev8YRRi4zpCJ45L9BJ8xlbzKt+YKWBV7E9gJ1ki/zDSXE
	I4s80PVq7dMJsrpXdmPtYygVmoaxX3E=
ARC-Seal: i=4; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793650332;
	b=z0nHboeA9wuDJEuzGl2SfiywEfL+rFnpS+jPQuKwSue61kDsl5XAj1uAL8nD9fzDud1D/Q
	fmcO/R3Ge0GTiTVyeYi4Yfy7eiYcT74A3lSxjfiZcGDmJbrLdo3tS+VtS+5m33ewM3RDMw
	kMe6SlCFKo96m7RkdJXzTlMatqIRUXs=
ARC-Authentication-Results: i=4;
	imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=3")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1044D12010C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:12 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1B47120260
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:11 +0000 (UTC)
X-FDA: 85391275662.02.400CF92
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22B501C0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:08 +0000 (UTC)
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793650329;
	b=4nCm7K/i6ohDideU3OzG2A34pdMuLKCDI/kD1TroaZMXfDjVeknKPH/dswgVS0OqYClexu
	N4jsjCayKw3gyDemcX2rTh027HkbZcQQlXKCmZ1YskbAphj7CrMZASKb8iQtzqkDUl6+vk
	yhmSM8yeJu6jfqdKy545bRvIcFRYLOg=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793650329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjDOfNesHUvUYdnemATt3QpEnFnBaEWBJAu+ke/IeV8=;
	b=fHJhnijFOzh2sSq6YFeSfTiA9IprjlN6CXJRMWC4pYrzEizPfObBlndTHslPtV7ZNe2hYj
	K/cpy3fcD/X38V7cEh294ARb3Phllibx5RGuBpMG1kf8qaAb1CqvkUkvyp5tN+TkiI3O6Y
	hRES+XUOHyVRTTL+C4BCyzRIQFznwZg=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7273DA6BE5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:08 +0000 (UTC)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 423FE1601E4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:08 +0000 (UTC)
X-FDA: 85391275536.11.91B2EF0
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id E62404000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:05 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793650325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjDOfNesHUvUYdnemATt3QpEnFnBaEWBJAu+ke/IeV8=;
	b=5GrQ9ZauymPkfrE4Du9W+FdGQgZlcNCJjVe9Qij0hqMVWl7QDWGPHnotJu/z0X95lq8Tzz
	WWrQFztFQH0/tg0O9F/SGGmSOt+YdFSxuT2v+0awY5EmUeMOlxrunwSf2pklH0lD/V7Ev2
	AmvvFesnojB/iDsfCiF7jYG7iunAxuU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793650325;
	b=ekURkyf+TKU8vGrxv5D/MmdXcr9QH5dip3N6GHskksR+i2hFf7FAZhRa+8cufcRGmfR8yb
	HCUfyAsfCf/f1uURPNPcjT2nPrQX2cHphqp3whElfJA2CCjM3hQi8miHp7xulqMg3fNcpd
	efMPorL0aw6eb9ertMEjxj7F8lUN1qg=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D4CE1601E4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:05 +0000 (UTC)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BDC080196
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:05 +0000 (UTC)
X-FDA: 85391275410.23.54305A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7634440005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:03 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793650323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjDOfNesHUvUYdnemATt3QpEnFnBaEWBJAu+ke/IeV8=;
	b=3lWgPxbLxnekwdEE4W/FJbeT9CMW1bCkUPAVW8M+oHVWoU43j2m1LZPPF1QsFRhJZ0Mp1c
	qIMZMUqm5i35SE+tB/vwiJjjcYbxmuGH02NhNpPGiATr+hicQ7g0C7kFiNF2w1UdiDxqbk
	4EW386VHK81aaStcTF9+SVDqZUEBYlw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793650323;
	b=Xw8Hg3wZHig/aFtBS2p0YwQ4cB4C06fueTWf8uqnktTCPJtqFtTehPFdKVP/MpLoxwhExH
	WEYbZGqxHEfJBO1uRMQ3+LycfqDMGC38AcvTJTdm3r/EtTL3h5e8b/e2HOx6R7zbmYLsH/
	Rz1TivLs/Zjb/8kQIAAHogxnsuvicD8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fCxM4P/Z";
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54B6B602C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2261F00A25
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793650322;
	bh=BjDOfNesHUvUYdnemATt3QpEnFnBaEWBJAu+ke/IeV8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fCxM4P/Z77JCfIGz5fMLuOcLnuT1agPgyAWc6xu2TroXoThnXAKIo865OA4e3Atv3
	 Xkbwhl0CojTtI2yoq5c7Ln2KnHGFmGHgwzv6SP3jZiYjGo05bpiahvSpZvouEqDM1B
	 rvqYc/e+G6siNDWSVM6h3lJqavfaFQiVLKyFwINS1Vkb13+CyUgFRYin3AIZAZzbOD
	 mWQknHNoyjII2fneg/H+qwzDuHAE6uAHVcoEayLt2p2bHySptfg8+s2a1IeQepo9V2
	 sE1VX0Fqw64Kk1PPou/Tb3RUpSk/a3yHnCuZLrY9FbX08LvaQsS19YXd7j9hMua/Fd
	 wH3o5lWXSGCVA==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93ece7a73b9so461127385a.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 12:12:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByJh6nAMZj/nG6+kIkFwNiaWf6SLkc6uFhHX27dTD+PJIzrckIMFnT5oAa26zhsjtalBF+qsb9F4A==@kvack.org
X-Gm-Message-State: AFq9FYLf7e2T1q9z4DsIWz1b4Ty54AAeaOzitin/CM3drTday9bSXAgV
	Twd1OhaXyVgIDKYNJjNjXsJd1IP84uoCm1ldSSTxWWDO2520tvR/UrU04obog4nodsTR7fqp+Jl
	I1IvyNvpBSFXtH9W2vXqcv9by2MIAd7M=
X-Received: by 2002:a05:620a:2614:b0:93f:baf:279e with SMTP id
 af79cd13be357-94421588032mr1947387285a.8.1793650320775; Mon, 02 Nov 2026
 12:12:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
 <20261031055838.60138-1-lance.yang@linux.dev> <a704d458-ad60-43bf-a0ce-3b128b218d88@kernel.org>
In-Reply-To: <a704d458-ad60-43bf-a0ce-3b128b218d88@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 04:11:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wjGjDoFPz3qWHqW8WTv31AkR_zrY14ON0dLbTZNsohWQ@mail.gmail.com>
X-Gm-Features: AclHuK_rJzE5Yay_lHuYFvz2Gw1cEWyIS737R4EkfHxGw2G6SeGPSgpipiW_eIU
Message-ID: <CAGsJ_4wjGjDoFPz3qWHqW8WTv31AkR_zrY14ON0dLbTZNsohWQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, muchun.song@linux.dev, kasong@tencent.com, 
	ridong.chen@linux.dev, sj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	kees@kernel.org, peterz@infradead.org, jannh@google.com, pfalcato@suse.de, 
	hughd@google.com, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, riel@surriel.com, 
	harry@kernel.org, apopple@nvidia.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, jhubbard@nvidia.com, peterx@redhat.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	osalvador@suse.de, minchan@kernel.org, xu.xin@linux.dev, 
	chengming.zhou@linux.dev, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, youngjun.park@lge.com, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	jgg@ziepe.ca, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, josef@toxicpanda.com, 
	stable@vger.kernel.org, usama.anjum@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX1+O4HQiVZ51HMqbFKf5L1iW4DxJmaQ9vyZi9/xcudyzwTzwjt9/b6mpcvOwJzn50dpjQuSMm4Ffc0xWTFo9j0rkVWRyABUkqRjle3j+iheDnU1piZJXfUzqvMTPgCUIS1z7vMMJOYVmw0C5ae7obwDbp2cOuAA+2cN3hVu17sxs9YzyufmVucXgxWyK8wgkbV82i+HGxEuvYOtvt6aM4PjJNWPIYtpZvJyQfJXwWQSzi6nt66tso5zTHBL6kLSAToUXbhmnsIWBnliQBxHuGdMWgpQKVHFvMs0RCXpP3Xg8aIVfpWHquVT5NQRpJUbptxs9f52J7DBx/QuB6pQMA1ElFkbMj/L3vK4x/784lMSpLhtwwqe44XrOXmsAT+vO2xfVis4K5tQ+hcywV8yl7M4JQmefqvXReU+gnUxMQ0KVWmSd95bhpvXqMt41dLKck5226NR6+eAv+yMrINyynhtc41MAf4sb7+UiKJgG4F+BmwSFq0UOShWWPpHRolODp4YtJKKnmgPMs9plh2RDjrF9su+0hL4APeWMRUnkjVtlRmPIzPcP37QoByG8fcim7IX3SBQwicD1tT8KDZHeO5a56RN5lxxYvTdMesP9/oRX6Tk3hgfbcVsP4p5onT5axJgwahYSty8WNeF/W/gaHBS0QyJgfmuG9swStOzAqulKPfDvlgy8wDJs88BHYLgenkYxg7TYrUzbHXxFNqz6bTD2KG3PbUqKUHqhNbxMbsxZ57vJ/BI74LvW3SHlvZSEhOFj1gnClSBUqY/k7SXmc2j7fv92J4ije5Qsbh88mj7c5NyVB21yvjUMDLO6wDhO4YIAKHFSiAwujbMlycWh90uFKvzHXw/9lZ2nKM0zB7mKDJdaBU4mHFt2Gojp1sv3IPm9yLhn3c09sll56EtTAxl7AQRBjSDO8mRLWyqNb5ziL4eIErnKtbL+vy0+Uma7GluzWo26z4F
 BMGK8mI9
 wZxoRmXtarn1vi4+6QlO4Pk9rEFpwRTm34DkUki6IcZQkk7iu2tRh2cgGhJalBsxqPFys7z3+eB799xBPc9X9HsoyRys03VdP+GLv9kIlu9PyAthQA8+FxirTIVL9HXw/lzPMhlgd1CGe/Eukg3O5D7jG5FJoCQ44l3L6eqrd6MguDecw+0kO2vfIIXiEV9nDGfocQyFMemkKIufKvkLuXBwf4pQjY/IoNresCWsLasmd/97cIvGiWB3cz0Bjh9KcnPscyMnsFZN4J9XbtdEXF2vAawnzX2xauUIOzj1+eqjSo0w/62NzunAqMpdwSzqPuCrLAv7UYJrd/Vbw3fwXjWoqFMz7zlGtHOxlDkNu7xsLpnjes4qk2kBgU3uKKZTk7Uye
X-HE-Tag-Orig: 1793650323-939436
X-HE-Meta: U2FsdGVkX1/GOhBizWW9pAjwCO3hgd66L80SyhjQL3Sue1nPds2qm8mcNd1oc5xWn//vkdrS0Hgn0qKSCbLhN1vVYMHXyvuHSXCmjcorR4+BzqewEYc8q69S8wjikOG4FuaQU9tXqLRXz6Qxzzc5c/9ri3I2OdwbfLR8k8eWl1ryqaTNcgtEGSnLMqh6LvGHKDdH070K3ORDI94qeByJZZmAKCyge1Kf8Gc5XhZFLwzIYf01eLhtN05wdT2X3OYr3XLV691ghKPlui1pseNcSZ8emqY9QsIE/0Hk7hFQwf46KOBt+NvDI4kO+EtBTSmM05VA0ZxGcHH8xzE87OzlOKjgsxEkfT0nNvCCxt2oQnoZriKh/owCbvvMKRxTC79mSZQADZY1wJ2ycdBdGqaTvsFD+TNDiqEuAenUQoInWQqHF1+uHKkL1YVasl0zquJfV+xgyzXAsmcmCcpjlJGSw+aUEt0v8X+rGwBfRHcJf1U0P3OP6n2hL2WMWGI4Kr5pmev0HLBHbRqzclwunhcdYfAPagW8TF4c7UBdkRC3gam4StIVY3fbnRvHSjZPTq3f3mEFeaMJyUio2kOC4nI56BcCgvdnsSEdlBNtKf+uxzH0p4S2RaY0SPDMh1/RACCIKDBZS8YpdyaTdw2zs2lPyjF8HSK3/LWj5phom5kf8LO/Rja3N5ojrO+pavoO+KtGd7tJL6fE7AzO6YNzZVd3fqieF8+OakV23hhbnedeinIOfXeL+mYqsqZe7D1W02Flfztko227j3t8Wsug+wtnxI8pnLJYM9jGWmnKU38vxqCm/wNcCNDrENiNRrXNrfJdAVouuC+9453hbZjcICpPDtElcUYA2ilegL55mzRXcY97hSaSH50tfNmaDQQ/o8m66wi/whpCDGreztKuEqH1QE0FfGKHUGJgF2L+CT40biwyOGOlCOwpFYYqtiEtV5BEQVWi2pJpl/6r4D3PyEd
 YbUAGOGW
 31ZhTw7lJTjTa45pr9fkBLtKSGpRh+hTUIIbNrDlhMdIGbK9Keo4d+oKO635X+p2w64IN/3fX7Zs2L2IDqS8S4R8Obl23FWFjoxhZOi4lmlSFOYgsEA4MaQ7St7QNX1Fm8KidsB3seRLgEOznwnu5eAlczS433Bcj6a6d5egKQtTw+8ICsnHd7kXjso39iexPx9kWz4bTkaOX6M0R0X0Zy0d5INwPN1WlGoskUlsR4hrE73Nfnbv6XZ1gYXFz84GHbRYP3ddeq5ZYah8eaNl+OBYLxhQW5Nqh33rLJjNCL9G7FsOoGQXsDWgmSRJfHPgS56XnRarqIknMOPfp6hdk0E4zYA==
X-HE-Tag-Orig: 1793650325-671015
X-HE-Meta: U2FsdGVkX19/NlDmj6za3yot52EUkMELvRk+K/zR/92Tphi2DGBQse7yO9FsHffOAi/xFXwkCdGnOFoR0NOHJtPBT5BPnEHVpWtTmlU7lU6tamSRePG/wbaNLEZBYLTFHHiT3iIXbWrkZ0PtTHAl9iMPBPBnxKFvHQVV6G3bvPLOLAqdWgrcWeGHulYylVH4snpFr7VfBjzkXL+JDbWitWhXpM/GzT21qOFN18Rsgf6E9pKYugH7T0jQkUBkw/qtd1LwY5vRrXAhN0ILU42CuONrT0JVh3/3S+JJ8WrodtS1SIeezn6qanOYl81SJZtjqrCVff6Q72ZcMfPfo3pSsWmKV9wAXejDK91D2y8tvohIePm7cY+b3wMIrQXb/94YuRr9Z+xUVq5MU2MQWUcZ6AagDcz6G4C/lsf+GxN/Tl5lcYjEuhSrNsIp2zGhatBCG395O4Bt4gAbXJfv9+Bd1F5lwcs55cqVGBHeb0TVJeNzdzWbUdPW7Tp5kB8cBC020B5eU3SWv24Mznr9rh4aPDSjkMrB68v9oxQCkCAB6hNP7GGa1+ImdgQtX5DFrbeUK1SbV6l9ck4kz7GFsucZ/R4djgNQguRIk2vMVKaa/kLbbjjMNTZzJQpyJP3fWcMyZpx2c0a357NFC/jwqgdOKxuPu2RxAu64qg0sS7K4IRknqk4Lw+dZIwzgUen2UFAikKGV5TOFtCbvSCUJSuvSKJ4XrcnsaN0eW36vLzUr6SaYW0ZO8WBVxb96b0ZDHoeCkXTbKR750cNJMgJtnUDSI69DNlPq/x9nMJ2moliZDX5SHtR0AAUYGvM1NYoLCxCBHcf8EcVSmMzF/kzZIrqoBAnNMsnRQkPNBt5Oq+gT27UstS4e32bUqpjfgeKOp16A94c6pUfPNGjY+B//MnunKrIyZyWPjUR5VGGV+3HB2HHOhPdODxim+f3X/fLb9Sbwd932OG3agkAotPgVXSG
 PipobgNb
 R8giXWeKVOABKQWmwelCN7HzXfBME2hp4qeUMk4KIZ/b+WPTVxJFUsIpb8sKb3hImgDMZesO3Ci4cg19DyefBBdggi/5IzwXsSyz1RExUSer/D56Il9TE3krPOMnH1wawJJB2vyG44DlCMNJR75QVMNylIa1gKqcdKPEwxaCauw5D3rcJczoX5vOdmg8QAwManCvjPl59vtUGhr7oY54wu8hhDw618tA093qnlSVpmwRsfAYcCfN5DehOQD3PChTg6A1UhFKubqtheHSi1DPOXJmQjdPK1LlcJx7duW/3f/EMy6GLW4gvbweVgvccUcBk1qDa11Ex4F4Kgk8ek3IsmGQ7PZwUdx0x/cpV
X-Rspamd-Server: rspam06
X-Stat-Signature: ozth13rt1q3qdkuxjkgzduxrirzume3f
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag-Orig: 1793650328-108202
X-Rspamd-Queue-Id: 7C3311A000A
X-Rspam-User: 
X-HE-Tag: 1793650332-185840
X-HE-Meta: U2FsdGVkX1+O7g4BPSMa1m0KAzVQpf1/fzf8XikT9GD8psLD4cwCQFmqZPDRK1aSu29CZGhHL6Qu9qzFIdVsiEBNQrR3dGNJ/Xq2sJlJpflofThkNxeMbQA57Ft+MM+6SBMXZd42Q5klXDPjCGJzWJghRF82r/heWyHwQALaGPWWnPeXJqIMhOF3dp7AB93CuSGDnRIM1tJ0Qwz1kyArAmVS9r3DjfyT6RBpkHRAM34RZ0qYvYCgsY+kAe15BhNSphQg2e+/JFPT8dVSEZTqeCdZHzJuIf4rs5via7H6ZK2QReTVdzgdEHz8RBbjTjm7PbSvkQbKbiIif7B1eQDYTNjbf6T5HUhrxnwY51qqwJMwxeFV9bjrrpeBQ0K6mi4K7rdqqfzKaLXOcG4xHXPyGmF0N2CAj3ZAb1M+97VXNKILZnYvNloAdIMnLZqPPToDZSZc+z6U+6nYkhyC5TEB6xrOe84da5pDo20GiRd5exGfV9/RXX1Z2dlc0WYdRdbTpb5YivimGQIhfgD3yexuOI9wBQ6Lbw9VKnafUSp5XYqvayXgJRF1xTskGGAYPuYj7SAwO9i8QoI1wlUAS+iVO89YFfv39yOKC2unG2JgcHlwCu8YNNcvFQg3Q/MvfnCYe+qebQS0GeV8R9CbBR8vxYQWV/uMfqI40OT+K3jTcloh9hHYLMlHLDxOZwCZh57gqNJhleU3vGGm1BdwdfkcOnBkvqbf5MQgMwfB3n8wIsDEF8FZ22peNI0Sw5EHTSrUSbYSFkGeTLSCtTu4Bz+cATnv6Qs81ahFF233lRiiFKmEvqxp94otg3YMDTM0agAk8yQdAufDc5MC8JH0K76t7HmGYey1VWZXdBszIWBt5yAa3qZii4L0Y83ZSO90vROF8hUB8osHHWB6p1qEPlmoRXovNiHbipuc1c2/zB3DHYc7VdV7il39b03PYaWqtquxNTQQrsP+fnjmIBYV5qt
 tdNRbfus
 70kt4/Fm5mBOgbDA5F262/B252+Pq0/hMMnyYHazbXEtBUQ3K/kB87gWYnqg4ISSoVcqHxPv0PxESkzFbTa3v6ogSK0bduGKal00O3NqB3z6sXxysdRwKSsHvUPsHyOjhueqeqFz9cdH2o9aoWAd7CxMQb0YMEF5QVsDPNzOkZrymuvdUxndZplGEByl/fJQebZ8WuadpMzCNuL6Fwvgz8PZHHGEyuny3YcaL8XB7V0T4boYvFZGFl6bmoytzXp4Q++EMB31pIN17L6jGcmD9MiY6TkH/HgeG+DXEUz9irqMY1DiyJn1gj98lzR+ohkHbE4wSCW/K1hrCzwyWROq2W6CbI6L5EK4jYF0Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 5:42=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/31/26 06:58, Lance Yang wrote:
> >
> > On Sat, Oct 31, 2026 at 09:46:37AM +0800, Muchun Song wrote:
> >>
> >>
> >>>
> >>>
> >>>
> >>> Agreed. FWIW, I think Barry Song and Kairui Song would be good candid=
ates
> >>> for the maintainer role.
> >>
> >> +1
> >>
> >> It would be great if they could take this over.
> >
> > +1 from me too ;)
> >
> > They both have been really active on MGLRU and doing great work for qui=
te
> > a while. No doubt they'll continue to do so :D
>
> Fully agreed, we really need some people familiar with this code to help
> maintain it, and Kairu and Barry have most experience on this.

Thanks to Ridong, Muchun, Lance, and David for all the
kind words. Your encouragement is truly inspiring!

>
> Just a note that I also don't want to pressure into such a role (which co=
mes
> with responsibility).

It would be a great pleasure to work for the MGLRU
community.

Over the past few months, we've seen many active
contributors join the MGLRU effort. It feels like MGLRU
has never been this popular. I'm really glad to see the
community growing.

I may have missed someone, but besides Kairui and me, I'd
like to mention Baoquan, Baolin, Hui Zhu, Ridong, Kunwu,
Maxim, T.J., Siddharth, Xiang Liu, Bingfang Guo, Shakeel,
Zicheng, and many others.

It's great to see so many people contributing to MGLRU!

Best,
Barry




