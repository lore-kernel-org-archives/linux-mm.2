Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CB4606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=h+QEgR1f
Received: by kanga.kvack.org (Postfix)
	id 8311B6B05BB; Fri,  6 Nov 2026 12:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808D56B05BC; Fri,  6 Nov 2026 12:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FE06B05BD; Fri,  6 Nov 2026 12:45:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 444646B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:45:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C88BC4017C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:45:00 +0000 (UTC)
X-FDA: 85405419960.09.B61B309
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2163E40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:44:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=h+QEgR1f;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793987099;
	b=AHlncwYXo3d1L+Iq4FA20NVxMnuZtDNy+NggCk2pvEDcCu3p6TEguJ1495s3u6zVTGZGju
	m4oHZL/YgwMY6NLZfZc+acBrAsZU6ctnDOSRAF8bGIXM/cX3zADgJLpPJBnEBmIDz3SkSZ
	Aptv6/qQE3KCP/mVkzjWeZuisMzCzQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uoprF+BWZMjYQHafHnomTTQtakytGeDxHNxG458KU4=;
	b=IAX7cO/531eiO9cyxt0yEnEA77v5ScTOVAWT722EtQ+o7yQ6l11pziAKKgOsnviuOga3M8
	/jnf4vio3I5i4M/JlmXEJ/I0/V/6kiBwpH0hxLPqZ89D+2wVr+HnQazughJ2HD8j/HhubT
	k6aVQyDULc6fZOyArADTcwvFNjg4SsI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=h+QEgR1f;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1793986630;
	bh=j8vdMm0hGJoZSKbsDFe2MZRFIjAVfM8/OQPnYklq6tg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=h+QEgR1fn7lqdq2kynHMk2XnpoLTWXW5bsY2VXxfV9GkG5jZ4AhEH8GR10JNCbiDj
	 3xoqJFjQjHjwLbMFM8mfuZK//nunxaseFKqKl9vb14V8Mz5UD+po0IOIPmlCXcIraa
	 VEIfAm+GuiLZZrp4yWdus29GklEsu0kQ7lPE/VRQ=
Received: by gentwo.org (Postfix, from userid 1003)
	id 275D140257; Fri, 06 Nov 2026 09:37:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 24F52401FC;
	Fri, 06 Nov 2026 09:37:10 -0800 (PST)
Date: Fri, 6 Nov 2026 09:37:10 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch v6] mm: vmstat_kunit: add synthetic benchmark for mm
 stats
In-Reply-To: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
Message-ID: <2e88a1d0-3a36-cfd5-3e4b-79cf4c8aae0b@gentwo.org>
References: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 2163E40003
X-Stat-Signature: obgmusbznnzcawc58zdqt5dryoh3nhup
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793987098-39479
X-HE-Meta: U2FsdGVkX1+Aw3+mFCk14mTiIUun/iAp5iWWWRZv5BlIV5SHdnRfUdUR72K4WSBFsX4ZMjuCyP9ZJSzK87DElIrO5dvQqMpcvnSnkbMlSGYrL3WUf7faz+ztf9AQAViPm1aLdrckoV/Uq/Kq//GebvZS2O3ho++hcae5y4cOfqVc6Juzqg/cqPCamM+YyA80X+dR5zC5BozvAEdk+8wqr2d7OAmoe7xuEMabblt4YcLf7DFMpQQvNIMCp3E6LudTX1ktu25itQEA7Fz/sBDGbbIK19iqz12iWnjnzjEfIj4twH2TY3ZYgkNVzNyzBRsVRVmyUNuApzvUoiQm9AJ6Dz3GiJdZ0C4pKRfZalGhjU8vGwBUnDH6WAd3WcKGg629XJ+ItTf8Llk0OLjqOJ8xU0QFJi8cWGkWIQP5rCYihtqTUnFiVCSaC+HhTv3VYKhrJeljRarShslUmNIuvRgpMkYH4qQU6FwcwBnQUufRU1iNW7dHOREY9vn34GnEkaxMVyqp4zETTh5+XgJmmAGI/z5norlWoz9Mtwv/xVZLIDCWr445FRBEeoE9g0lFPuotIzyVll9ZvzlpWW8TowEU316SfkfRilSoQxHt5TBM3d3NKstC5F4doLu+gH2j5UB6aFBimZLieV4UR2OBOZNf/v7e6P16CnOSi9hC8+qMxscvV1eL/t5VPBldsjgpV7qH5YUosWGEjsu78DqP1Qz/RTq+vlL95MSbBAkbIk3kl4NoNhcClv3MdQS1KQHZn8Gk6AJe/L1+sXglp7N6naI6emrLWQToFoyPnxTCWtALdBdNhga2c1RqAbCt9Mwbhqpm+UJNeB3l/bBry+lF4JvpIhV1dlh9koreRngkDUuXQYzkcl0pdC8Fe769/AgMr9bJRUTo+yUF+zgXLQcXN991tnxa8OsJhUdmxAvhglAxN/2WmLnDecgO1gMymDzGjsGtU0x0Xjpu1EHbqfUhbCO
 +dfTp8r2
 31LpRpP+WyCEh0usxpTgZfdgVcuq3LjybFY5RqcD6o6okTqOjGroncCXo74B0bc+N/mFaYDB5S67WA79DL+4EXUEtoz9HD2TVTOxSeQd3verRJDYSUUMsM2KMgg3UFfWYSbt6i8hv79QQdRb7OoO2benP+hf7xvRje9I0n/qNCviH0Vmymjhg3hKUDDNmqqK6hASCKqeZw3l580fxg4gUmyJ9g8FQqfH9T2eUbJat3F34ryIH2RzHlHt1e/HfCW6Lr48e2P/3xdK62xVRnOddLx7Mlm0cyA592tog/5DhTZOEVtj6DMqq1SKYIpibsAtroD+Zm5Bq7qEc8fM8HSyE0cO60A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026, David Rientjes wrote:

> cause performance and scalability impact for users.  Google has carried
> these tests internally and kept them updated since Christoph posted them
> back in 2009 for this purpose.

Thank you. I have a couple of more for atomics, slab, tlbs etc that have
evolved over time and gathered specifics for the variuos platforms being
benchmarked and the issues that it was used to track down. I can dump that
stuff somehwere if there is an interest.

