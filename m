Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1708C606A8A0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SzV35JsA
Received: by kanga.kvack.org (Postfix)
	id 14AED6B05B3; Mon, 16 Nov 2026 10:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122766B05B7; Mon, 16 Nov 2026 10:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0139B6B05B8; Mon, 16 Nov 2026 10:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC89D6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:53:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 485BF8018A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:53:48 +0000 (UTC)
X-FDA: 85441427736.30.2D98773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6A40180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:53:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzV35JsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2CywPaM2g5NnzDzlfr6I6R7FLOYJMsUt5HyR2scrh4=;
	b=409ysTnFvmmFCo+vuhqjbv8tvfkRMWgpB+hy8QTPQnXqgms+uFNunEzh+QLqubFmsqo+Rq
	VxKt1ms0OwTqT4qDdVOoaKlMNKNDaqpsir7Wh5pvR6sPMOost6S0cgiWb+EaqDLZZ8kSY+
	vZwIULFg2xqyned24vKvJ15qrd7rB94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzV35JsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844426;
	b=Vf/FXrJr3S43xso1etEZuB9rjyAhKZ3LkIoG8lwt+e4JWEycqvJAIge6nafJUqg2O7UJ5Q
	FLG7hhLMxcRLtd2adGK3UnrE5k9y1Bdee1HEm5F8o3TPXnZmdETsf4ohi/l/M3O/IRR08T
	PLvljMP5VrwPT33KYV73pEQQOw/dWAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE2BE4095A;
	Mon, 16 Nov 2026 15:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A121F000CB;
	Mon, 16 Nov 2026 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844425;
	bh=x2CywPaM2g5NnzDzlfr6I6R7FLOYJMsUt5HyR2scrh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SzV35JsA+V+Ay/JlfmbHyw8TEEwCyti8oclHTHE0imgrx97/hONEw5501VK69skOH
	 S8XE5M/0vSh2Le4bJxxpU6BliIEOnJvYj9szavM6P2TnHcYhQ4G4zWhfrmKxaxkvoc
	 qRuA3BuhR6lNq1ZaH+PcS/4mJ3EXf4wm3u1xfPJLOqtVrT8EOTs3u2HtEVGYsMqJth
	 TPRPpfh1LBiLdGk1gH5bImnktX7qWe0L3mU1th0caeewo08ajPZ2b1+BQYUXKd88Wt
	 qb7aXa2Nd4bH8fsJ915ni+G+I9OYFjTGkwMxvbAvTtZMaxx4KiKAxuGNUj70cP9Fg+
	 wxhCyQFw7A+XQ==
Date: Mon, 16 Nov 2026 15:53:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Paul Moore <paul@paul-moore.com>, Kees Cook <kees@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Ben Segall <bsegall@google.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Juri Lelli <juri.lelli@redhat.com>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Ketan Bhardwaj <ketan@armoriq.io>, bpf@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/6] security: introduce Kernel Assurance Plane
Message-ID: <avsm6Xg4SFUmF822@gremlin>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6A40180004
X-Stat-Signature: oh9nt3ygjumksabr34jnwmrxsjtdr3p5
X-Rspam-User: 
X-HE-Tag: 1794844426-416652
X-HE-Meta: U2FsdGVkX1/jLHBEkbnohHn/K94PphmNi/QgnqLNTDdrHTdFuBFSDBQYqA6ldct9BmeMhaq1GsSkNJD2kpgUcJvrvUmY3IRE8YYATlpsEj9aa5rUD6CauQbRFbqj5vO69a2brTEW5zP7xQ9DZdvTmfNMZbTOtT3/8WaEETRYOHJfqmhbg+f05WdBGD++0LV4KtxsA5lOTACJZO7uIAzYLVk8SiybeKj5dBf4dODVe+sQYyl6S4h3BUAB+M6eFkfDcHl3MmseWN4ixWfiwGJ7vAkizjNDpRPJa7QEcLWTANY1jLabmTt2oqZlcYIPAhO1w+dvlCkqccpxmnolyB1+m8cYJa9RqSgLbcXFQyPsoo89syrCTHxSrTlmCEecD+mZ7mpHImETJEpyPxUwGV8tyuZGzbJ4E7bD2E4FVIN8WhYyC4njzFRMSRrpNoPUQWLJoI7aZi+bvO2dgrhQIlAofoUnVPA/+qG38gyBF2qwVi64pbFNaCtYhexIPO8Cznop9z9j2IDvwtIZ3NeV/+jWifLTmGxTNs7oqJUDabBMYJR2fATXG5znJF+dwH9ZAY2irhnWANqKBp6Jy5gMg34zD4dwZ7sh0djA3Pbfx8cYhwyoCWS+P6rWH8EVNKGiRU4/gFkT+HbFIh8vYL7vbBGwavsuxBc4dgXTS3U40GBEU0zGmTSUpG/j50DiGDv5MPAozA8ew1wqXgr+tJqojznY/ZHN8EcG/lcYwmrWp/neVvw0YcTtwsjCP/AVTakP99BU8cnBgE71e4esv13pN9fZ2Z02rNFWoaZsny4fnsFjKOGrqatYPPVOd5RHGdf3hgSzUVjMmo7ZNP9T0GlhSYLzqk1GWigLl5ql/9T4kScJtpoP6BjmyiaTTKCkNiFbYGeIJqFpdy3wB/om8aVEf1vRalSJ+HRNn+19D318W0s6xyRf6EJ1lI/4uhQAA70m6yK+hAL3k9eclAfdsi1LGX0
 dBGApGBu
 xC+eVmEX3pClr9GPBHN6frYjzOVDINZU5Z7ymaPDXYnrUfxqRz6XJtxLGagDl972RSc6FNfQ5FWCsOFm+2lL7dCLcBRBv+Go4h7dBlo3srnPTP1fJWWwEcemR+HjMacVvjdT7yLptHSIr8St7b7VOUz2RQTogPJ8K1oJFfhSb2TFXmt/UQiwxo8+xNtFwv+0HPlHxpRhjq/UO8oAgMDgcAJ5ypdNxwCBYeaooH0VwFeZsYxo4FQy/ANClAJoaXZ+Mg1j2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

No comment on the series, but please please please put a diffstat on the cover
letter so people can see at a glance what's changed :)

--
Cheers, Lorenzo

