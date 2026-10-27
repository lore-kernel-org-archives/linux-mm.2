Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C329B606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=g0poesKL;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=wMaGvRgN
Received: by kanga.kvack.org (Postfix)
	id CC6506B0691; Tue, 27 Oct 2026 06:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76866B0693; Tue, 27 Oct 2026 06:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F3F6B0694; Tue, 27 Oct 2026 06:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDD16B0691
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:35:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C8C21C40CA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:35:45 +0000 (UTC)
X-FDA: 85368050250.28.A499791
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id D22CC1C000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:35:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=g0poesKL;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="w MaGvRg";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.141 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cD96WCdctpe4xqBu48fVzWQv2mdj+Q39Vw8+UuE9NOY=;
	b=YmLMHa1PvM9pSMlXbxfuWv48LmN6xItkMMI6oISw1pGdCSsaYOM5TXTDB3cM2jiTcQDM/N
	dnpMH7coMEIOLAUouJVuUjP3zYJ8GxFjlcZ65X0wWD4lEx7iGQUcP6wJweMxnfi7B2tKQX
	D0zgD5/bsJZ9yEqdw25b5eBx6F+UjWc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=g0poesKL;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="w MaGvRg";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.141 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097342;
	b=YFQZHNpRD9/NfVC8qUp92EGINF3EBoHBXrh22Awb+a5HVqcAnY9l9KgXP/SZvdsrrAR9rw
	rjjxY4RXxAhixJPdUwLiumva+yvNSap7aH4L+vDq9/WvX8xkwq2T6Y9xHF0aS4pg5eI/af
	g3yJ4HD92018MiiyilIPhT8J4mxKRHw=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id C4FE71302A94
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:35:41 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 27 Oct 2026 06:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793097324;
	 x=1793104524; bh=cD96WCdctpe4xqBu48fVzWQv2mdj+Q39Vw8+UuE9NOY=; b=
	g0poesKLuQGMaU7v25wYb164Iof879cLQ+jrS7Vw6CuhEsyJqwn7PFMO9TEgL555
	salmD3V/ClUhsKzYPi0e1twlBEQsUQgTWR1AZ4ucxcvSWh0tFF+QsAmR7kyrExiD
	rs8QFLT2d4K3gWpb7cbvYPqhV9WNtc7sDvVFrq/AeZGLbrsDceBV0QVq1catnKNP
	0vZraw8GdX+eRczyZn9JW2/ZNbjBM4QFUKd6YGV2yTzJi2ns5fiipJSmFKiJF3sN
	GoBWeR4K6FMeN3rQg7Q7I4UT9hD0E+qvVgrEVdMfqW0b8abtf0o6SMw5UbAH+FLg
	hVWbTZEFzS2/5wF4AlN9FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793097324; x=
	1793104524; bh=cD96WCdctpe4xqBu48fVzWQv2mdj+Q39Vw8+UuE9NOY=; b=w
	MaGvRgN74SqlQokg0yGoa0qHrxHvnpo1EgRYl+NAZ2HGjyf2DoHqc5uAKC9rWw6/
	vV5njRj3VAjVsozr2QciajWKilgp9EVdkzTxKpA/MsGbxExu52PceTGPRcPZsISB
	KpYKodw2SCDSr9uGfucfgcGE2SA0UG7iid20bXHmKysdvynyqnnRbJjpSNwQ33N1
	0pa9wUuAxjPIT/YsNOqCEmHDj7Qibp8Oyln4Wr2lT6g2YFOhW7GTB1NdlTnD6Y/N
	mqImDReIq39YA7WkoOuwESu2xsiCrgirovD+YpK1k72+skpa4xR6mPYjJvlLn92L
	+KFpP5vjxlM5S0xUcBdYw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793097324; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:GB0JNTa15lGPo2dlINR6e2IXMga6P2duXf5eZ41H+6XGjPo
	iZEawvqcwGYhN0i5Wb5MF5saSWrbzb7+9hVzh6IphGyg0dl4zOX3DvSA6VAV33BX
	4HfKamBAqRtqtGm09gwEuv1MhNd9jIdGWZmyYTDbpu9VLak6JVv++JqsWv7R1TX6
	jZrIa8WH+72lTZ2AlL2pJ0aUhcH4xFOaFj3fOa4KsjRiy+634yRTIkAqOI2gFuGW
	saiQdqZ49Ryql3sMvmry+t+HSpZmGhUHcnQX0rHxemQ4YKzLhwNG+6mzKCgVe+ZX
	7Uo/kkku2scaGLkENUZIC8lpAIB2vFHoryF0F6A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cKjetnoeFjJorNH+mroEPI71xZFnj0iEAx7opE2N30E=:+7cbM9Ly9xGwj1eAsvoI2B7rTf1bDojBouGfp8ZZDqA=;
X-ME-Sender: <xms:Yn7gauJPeu1PinbCI2gYx0_jlj2PnQL9uVqEmxziDToBSgj9D_xRbA>
    <xme:Yn7gag_jv3yDvc0KG6xNU0a3i3tsXlBRwgQXJ5nMfcMcUHLemzagppJ4LiVff77wd
    kWfJ0mG4Cc1YdeleyjjRgNmR8bhi_EzFH5DKuKtc6zsMLGUhHUiVHY>
X-ME-Proxy-Cause: dmFkZTFn5p5gNfTa2ln7Ur1M8HLGH3FByI3bMffV+IVuNBxFNqZT4qibdV0911N+HRUSXj
    K07q1nctC5A6CcFfeLY7jBaLOsZKNIqYeTCeDTItiSfcD8KPMq3RagWnzHGWxZYBxWAiCm
    A3VT2o0IozuPu/s7pvPmuxDhNCPVlHQtdJeKAQbZtM/B41WPfEm0WHEt7Z4VBmU7Awz3r2
    CW1Ic84f68hqkyPgXyGKcQw2wWDeenYkz/P7wEtiFmdUVM0amFmkVyW6og0RqG5tm89hZw
    aKjqOAwHgBmvujhKmrOmxUKnEU58c+GvStpS1gjFmbH3Cw9L2zocbcI2nShgNxT4DZbAQR
    wgaSkDdcdMc/d9G+mxaz1POpKC9kteRE12RXj5cBt5pww+0ny7yXHoqz13E7ttwMLwV2Zx
    irGvBcy8nzFHGZLzVSm2bc8v02AbCF8YXzUkvfzziFLvAHlSLPGQdoNZ9j8Z+n4FuXVzNX
    YX6+5h5244zwOTl9aQiqLa2ox4HvDWrM9qIOP1ddj/Qc6TrOohBTM5knyFzE2y92EKQkba
    jTOi3P5IOCM4Xz9GLVwUPx/34MQnZ46TWseR6J3W3XI63DkzQUPhI7lmU3qjmL7/C1LwgY
    Sem/AhqkedQIukr61kUqtibtpdY8TqVUBtJQynB3XFjVXPk3rqiMNJFlIJrQ
X-ME-Proxy: <xmx:Z37gapHvcVHvMaM3ipgnYUZzm2Ryqqq0XCp7NdxFgDjKT2zqjSy1vg>
    <xmx:Z37gapt5WD8JfcDqZC3gZOEaTUAl0efsI8damzFuxdzMc9AsHa6DBA>
    <xmx:Z37gao4LOQoh_k9Rjo00qqoo4baOxCcq29WjL83ZgQ6XABea2d3MPA>
    <xmx:Z37galm2wjPgXkNjyPJ3HOpQNs8U8c25nqH_wkaWl6-1QurrUIflow>
    <xmx:bH7gapzWCUwwKYEsxCX9776XutFUkBaJpOGzr7ZN12X60l-MCDK0DRme>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id A3C9932A0093; Tue, 27 Oct 2026 06:35:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AUJ1OXWu3nCJ
Date: Tue, 27 Oct 2026 11:33:08 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Thomas Gleixner" <tglx@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>, "Kees Cook" <kees@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Jim Mattson" <jmattson@google.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Pavel Begunkov" <asml.silence@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, "David Sterba" <dsterba@suse.com>,
 "Chris Mason" <mason@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <3c125ff6-5426-4f19-8e34-fb564d4b6387@app.fastmail.com>
In-Reply-To: <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D22CC1C000B
X-Rspam-User: 
X-Stat-Signature: 5nepmikapjq5demszyh7mwerbk3tfspm
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793097342-268748
X-HE-Meta: U2FsdGVkX19hortWVFDLEo4U4V0FXB4Q08jHnXI3I+MUPxkSZ5YMLLhtCW6uM/vnHsBu9qxT9IYvJf8nEsVA4lK68tjW8vp7SYGsOWNEs2dhvKD6c6AaYAvaCughjfP5ib0X1hagd7hR132YEvmXzPtt/NgXOloLRaoa1VilpkSyyL2vabIVNDkqCjdRWscJ9+l8OqRSoU1QPmwLYuXxF4Wwojw0LwMhFFo+sVXdKqhPO/dYe/p4BOlMostr4XWnGFqaYPIZe7T5HiNgbTq2TxrDOOYJULgOknpoI63qgDnXS61ciFQqZzUcQRCuskNWXALEUddD+yV4I4PIULTR/jE23Xsev7qJNhgESO5li3T0t0cWGlGcC0LJBvLG3mnjKbCe7zQXWlOzJM5YH7aiqgjI/VQlv08sQ6PLIcM6pVkynxCgG3z9G8ZSNsEggB6VliJQOeGLKteUpu8DyG7fWODRbdVhqjkP0UFtV9RspI4WS2Hu4kcRpTq7l+95JEAMaW8Uf8f4eTf1lOACI8VrZ3RuqCUzrwkuBNF/ui09gGKbVMjWUDLRfvJn/uTor50CzDcozxfuy7EVX8PZrkWEAV8VCgi0QwCVoSfUn4BEMuKA8AEqtkl0EfGAyvdL93Ke958XRPlMC7FVH97XTr0dgktaBodcHk8UZq6u5iwtgPDq/9OaJH6TMyL/qf8Lk1f/0PEP/qeyP8VopRtrkKdMz+NrQJGjpScxgKd6pQCup3Dyp/vWUC8EJ8gDOMI5YKIfs9brF/TjuVY4d9HkvyUKnFZYmYfblxoiRDCPEB5Kpox9svr0SMbQOtsZ2G10jJFgiWxsi6/TVpGYxmjPqjCc285u+XfrhTph5JbCRXPTZJH/t4TxcoR4rfCn+PffKjFEtZo7PVNcxZ7y8VEk7TD3gx9I2gS0pK1bYuW6DjLI6VnYSraOL8OrAoZASJcZC61EK20Ku2y8UbF2K4o/Nat
 5ienLHRU
 88wbDUtrGcONph16PZ7jxJPlywdROKhq0rubzGdiHgnuKa5oW03rKFRXOItCTtllHiiG6ogmUe4WZA0aoVazUe7/JRzqZnbglH4fKVhqvWSm1YbxaWsz/As8YPeY041XGxTsXgbQw4RaT9YTBWdfjQsrYXGRkmpbBe4BC2OyUwTbrfFpsYp3fArG4xCeR7oZrBCaltL89yQxk8IlGPSiAxiRE+EurHtF8RVeiAjuzaClbHGUuV55utKXPchuDANIB4fHTsCNExKrOLyjK6VAAWR6YlPNmr94K6VGdKqVmSM6Vomo6i3MHqeupfBKSaQTl6zUg+bhaasUvBPsY9O1JIEKpkLwA6+ySzKcyVcwb6fxbO3UCvxxoBhwxx23hQ/XIc1lyxPYyBanxSE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026, at 01:12, Arnd Bergmann wrote:
>
> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> the current process is only set in user_access_begin() and would
> not point to any task here. Without ttbr0_pan, it should be
> covered by cpu_set_reserved_ttbr0() turning off all user space access
> for kernel threads.

correction: for non-sw_ttbr0_pan, enter_lazy_tlb() does nothing
on arm64, so it is the same as x86 and the others.

     Arnd

