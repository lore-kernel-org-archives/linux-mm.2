Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18648606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h59TxSKg
Received: by kanga.kvack.org (Postfix)
	id 2337A6B05DD; Tue, 10 Nov 2026 07:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E45D6B05DE; Tue, 10 Nov 2026 07:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3506B05E0; Tue, 10 Nov 2026 07:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD2806B05DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:14:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D21FF40599
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:14:33 +0000 (UTC)
X-FDA: 85419102426.24.B6FDAC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D8EC81A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:14:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h59TxSKg;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iP7ihblxE57Xx8rjE7fq3FQri1E1LvdLUGQwTbaBM2w=;
	b=rLShPNpfRaVtv/VinM7EJEZV7+Atvsba7XdextLIvo+l1d6KvPvy+3PDzJR+meXGY/HbA8
	c/Jg0MJvCmEU25DbQW3BCHxBWzf/0Rz7fTANZheWDolmlLrbiFiCOvWdCrhf9bZ/rrqnNv
	MysTBmJgm41pMcIUzYGt/+DIgLzwZNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312872;
	b=GMJR3gD8Hl5mroSsT+dVz9Qoe1l4KuybJmVriAizCCAyZk/uJXoWJZeRFZshHKVmFAOMD+
	xOPqFNbKR5SDWT2+gdSG6T5Xy/09kJ7NU84X3y+acjf+DzItR4KKC3MOA0HloS7IUoxAaw
	LsFW+Wzhc7e2snR6/JTnZEMzDp26KUk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h59TxSKg;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EBFE438F5;
	Tue, 10 Nov 2026 12:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCD01F0089F;
	Tue, 10 Nov 2026 12:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312870;
	bh=iP7ihblxE57Xx8rjE7fq3FQri1E1LvdLUGQwTbaBM2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h59TxSKgYe2/VoBpO0baOnnr3D83jpQ5WXLWbAx2he/b2QF6AJXbKiqq60hlTriLC
	 Sr6a8YHooXOmYUA8RFOWfDlwU1VjCsbEdfU5lPzu4ehNTGP4f93Z30j3qLe07bhS9F
	 vDYfsTIa4c0KFuGk3ZR8i/L04j/2OraibdA9Kmyf2e401f2SMoidPZnwMRXw/fMRHq
	 TOdDJjfFwkC/n+WZTMZv8bhzl83SiFn4GkLuEeMlXlyJxiPvs5KZ4/jcLcJdghEVGE
	 Udxn9/+NZuw8mWQE9Fk1atDRHQysraPQvYRqJHnpxFq9PttYfyy9gCfQG74NSMN0ng
	 NMBfDVPANl5dw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7494D198003A;
	Tue, 10 Nov 2026 07:14:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 10 Nov 2026 07:14:27 -0500
X-ME-Sender: <xms:nArzanSpIIwG51tsHxoNjg4cx6XZb8fKe9mFQiaStEaiiWGXacBybg>
    <xme:nArzakaVN84v7aVb-PegN2kbNzRsB3CRvMureoDByD8I5xamajVLlGpz647xE3fm3
    51B8K8DIgvq8gUblQ1_wtJPjuOKxEnDGaUv3u-nc8ErEhpB3-Hwsxog>
X-ME-Received: <xmr:nArzanTpMal-hQi5JzOJnpszvHZD8_1RlukXgFm8HSGeIx7gjB6EKJdzoew>
X-ME-Proxy-Cause: dmFkZTGpbVzkrelYKxT3HOk2p4weC4oCcSZPW/rpHgt9mwOOujexV3ntOnbLy9kT90zWH2
    X4R/Pc7He9zKvvIIHknrJ6jmRqd+GEiC5OJ1/9zKSazJXODPTmBjL5gTrOW05ZhonWrI0U
    H7BGU8fq4gRtYPJHKGaPFUfd+hhqfZs0WJnuKaF+0z1+xy9ewLL2avPysZ0hBftBGgc1ji
    WNjIvzjtJS6O1t8aThrFrTYaX6K2a/nHsjYlaSHjs0ddkvqo5ZzGQQwxlvpOQpp6n9RdMq
    LUyGL1B9cM4bURzCmIX/QZAKp+9nxEgKsjUMOYTJUoyJO1N1eTM0iZVOZQxVws8ePh1gf5
    u3NT1w0HRepOqC6jxxdIbkR0OIlfn08JNCqChvaiOat1qs/Hvs4BeuDHJ+03E4GxBLn7AO
    9iaWFSdMmsDwlTfkeYfju8yOlYi22QNnwJ+V7OmWCOi9D2Qgdp7rMn0ILlObukPllx8sp6
    sgtZnaDrpNVkntf/YPmW6nW2IwRTwVszcOKhtCnGhQn68O5yLhgSQvPSdVi/TWcO5aJME1
    AEY2vAPdhKIz5yKKlYXlb4TNn/LlK8U8Y7KG9HvGrQdaItlAJAEARWVtXQQmQULCTORKOG
    tQUdCQhsBV3Keoy0kZLDn2YA5jCy79U1wRJL8S9SH4wnTl0B20/HB6fTGrIw
X-ME-Proxy: <xmx:nArzak63XRT07vEmPmWdj3UQk19LRBHMl5JrY5kevBf3xCYTpbZ34g>
    <xmx:nArzaiT_kk--095o0kgnoe_C38SrCC57yVH7d8pyGoRFenBerbO_5w>
    <xmx:nArzamTn6p9WWzTEKKy5ym9NJMOSo0Usfg-Cs0u9knPk_yDjYCeNgg>
    <xmx:nArzaoNTDpTG50M4xFTa42zG1GDWh9eEqtpP7nfOAgtsLCIUoCitng>
    <xmx:nQrzav1UKN_6PhSRRpxLt3yvag5XAx38k6QE3cFnxbcCpC6V8RwR5kkj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 07:14:20 -0500 (EST)
Date: Tue, 10 Nov 2026 12:14:18 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avMKVYORkTQfdVB9@thinkstation>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1k3kpgn4k4ttjzki8bse6xs89o8ssu1s
X-Rspamd-Queue-Id: D8EC81A0006
X-Rspam-User: 
X-HE-Tag: 1794312871-146266
X-HE-Meta: U2FsdGVkX19aTq7v618JZupMXHUyde7crW7WufENlLpUjuua4dawQI9MA7Am7D4P+ASinXX+TmO3oiIQxBIQc+ExaIKvXvsljp+2P+daJNFcMiD3vDlceToH7/DL19NBRzn63b4WrgfQFGpR167Xqd80h1dgBAxSsj2m9+LvRQeOMUxfPF+lb9nvw+WufHlHozKTIeL99Z3zpI49Uo601uhQ25vfZVaPCwpZtLRw3DegNt/p2+4KBl6MDtrjGh6D7ni09+bsXbrsnE74egmMO/SEMZxdiMNibiRcu65ItQzQeSMTA46grD5UchcIHxd/NYQ3B2qrei/f3aK4mi2NLAX32ABPcn875b5z/9vKb5NcQCZcHiiePsTmhZk81833hspxhcXcUHAH0ipCq7Ds86Jq0YdHYeddg9OKkgTUq/5186NYGOXgNHANYcKTE66+J2YwbS0ya7XzgIV3J1u3Im9fEEvdHkiatJP8zOI2R+vsXo1pGV4kw6edPPOUTUMscqJ2aSaaZYMnxOMwf1kQfvtwrf3a04DGnoUBCIefCmaP/P93jNC5AriX41WoQtl4+U/SHrapb3yE5L51Hk2/W3EDQWxSMKZ00IxvMqQrQ+W+dDFUm3qFLUA/3cDJ0ozxEzAR22DJcbDhhZH1kLWXkBYAu1pmqdheuRpUvidsiVqDVWoh+/z9ESBPGaDMRaSLbk+Fmc8CBJAmuYxbOb549KAlhqdJZDDa2L6Odw+C6Rv/VcPSZyk5/1bC1kXuqu9B5ESYDmgeeMytGW8lQHqqnq47yXzaO4ESNlQiZFWM64mumCBKSWsuXFK4IeCQVDa/Sa/9OQmLKyudgyk6cGaZf821Gjt4/smp8xUENLfxqcpZb9RDGr/TJ0Zj0N/XmGESgvCKtnsgKCT0RW627kjR9H9/NG+JcGUpoV8K1R7cwgRAOlFGaaQutrpncsd4obd+pnRNGxph3EiaRj6VXVL
 hoNvZygJ
 FL+UiQH9Idyj3FmhQBA4TDKajliMT9NHWuxiSxLlxObO48TKJK1kZ/lagVclh9swA2vX2jxaf8bdj8pRRRAcMOBqOai/CCR0ajxb/J/JvfE+I2dP3A8/9DgVUXcP5lfUyvSgOumsd4iLJIndgXy2VRLKkPnCo8NCMk9LVsc3/FEsSisH0kWwS4Bes6/1ruaKFlt8MAyKsTQ7kByFMcmlMPIE/pINOz/cTAgjCB2ctpjLnko5iPWgxRrnIRQzob2Eq2Q6CdTzqzNVSA6M88r6ipEtHgD5r8TxGMPNiIi8K7ZSxuMBnlsQCrgNdLTAgDwF41Hq9LE8Z3bovUXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:03:06PM +0000, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.

Oh. Sorry to hear this.

Thank you for you job.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

