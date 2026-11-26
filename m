Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC4C606A680
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S5NN8pm9
Received: by kanga.kvack.org (Postfix)
	id 8322F6B05B2; Thu, 26 Nov 2026 15:41:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809616B05B3; Thu, 26 Nov 2026 15:41:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F1E6B05B4; Thu, 26 Nov 2026 15:41:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 426106B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:41:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3589A5C0D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:40:59 +0000 (UTC)
X-FDA: 85478439438.04.41066A0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id D6C2F80004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:40:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S5NN8pm9;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795725657;
	b=YYTFoqih/F4zFHCEb48bxGvm21HUeHt2j0AQh/YoKdOj+GWLR1gKlxC/wGvjKkppVkIrKn
	C3NEuSh6YH7J0z+LRQIovSrz9DwhEvcOgRS9jgFaAi3i3/6ZRWiSDUgaQwE5I7cpUvnc5D
	oj8jzoXOb71KwqfjQ7MorVn9AJXkTmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795725657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhLI3luhSnY5QjC9WSQKZtTBj+4qzkm0fNGEEgLeI6U=;
	b=Kbc/bh7CnKKVF1jTGZpzZb5ajEu3Apyd/0XKx1+zoLK+lSMLJFHEkrRqgnZe4ltQReq5RL
	1NCGVR/RXmDM7w/mXP+FaaEMoc5q+h0gr3sQR4qealzM9CjEPOBKMOAjijoZSYsWguVgA/
	lf1SNFB/YP4xOVTlVK8cNre55wTA2P4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S5NN8pm9;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f07a960666so51154225ad.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795725657; x=1796330457; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vhLI3luhSnY5QjC9WSQKZtTBj+4qzkm0fNGEEgLeI6U=;
        b=S5NN8pm9pfHVGXVgLwWS1TxVbPG5rVJUnteIyau+enOevkIYEX+nUo6y1Dihsb7LcI
         aX3yk2w2rS8ngGx9WD4lG9Zl6UMpkZvDGsLnGwYtoP2vfMk8jl+4WBr3DJ+cV49nVp9y
         BhXYon4YWzkQsxlD3g2u5h9jmOJPtf6ENaFbv/q8Y9sWt/gsWA0NYlt7fFRx07vgMmLh
         m/JKzbmUsIMe5WaiYRpTKvPPApXCMWiRwHa1MtulAPIZ6hWP4O0vSZSM1a4YcmxbapNH
         uMUgfbJJrTOEwfzd8u7ilT6tel/7omhQFY1ClAXHA+EzKJ13tVdxDBryjpGdAc+M7mDc
         Omsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795725657; x=1796330457;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vhLI3luhSnY5QjC9WSQKZtTBj+4qzkm0fNGEEgLeI6U=;
        b=hTCw2IZ41B4Rqeo2THJxJyk/z6iMY5ULVMbeQLbkK/q+/PTXdOXODy6MEKjpTDT8pa
         kQdojFKgQRyUV0sNwhxamRnkZ7xY/1KtgYNHYR+/mYgj6hidS5mwu47dQ8c2dDUJ1U2R
         c+Qoib0TiF423N0dv1QEMUforMhp24e42zGMkzqqXTsbgtB/+LFHC/O0ui12vjgzsuJF
         AIRfMNSEasVV0JGTpbvc7d/z4CYAIGy5ApJIztszW7yXlkE6yObIT4Fe9h3Vaqj4ij1B
         zGWCw8H2qBLmF3Qjv7I2wWWS2OxC6gmz2TDaHqRuBa83zNSt8S6iLNdqNg4HE+w5OpNZ
         ad4A==
X-Forwarded-Encrypted: i=1; AL+hErFrX5ygVA9PaiqKuPewy6EVqY89cUFwMn8o7Y3otOoPR8JHI97wJhiIUyoqOujt1FHiDznDt5W4Rg==@kvack.org
X-Gm-Message-State: APuU4Z8nObrVOv6AQiL0HcpyvKd+923EaPMItzuLDNfAzZmV6s/YfT8q
	FOwBPkCX69Ofxg0ZqStHF+MGymmk/tzA+0Xv4HM0Fqasb45GQ6+7u/87
X-Gm-Gg: AZFdTZdvbM4pHnQvuBEnevst4AjHvBVOR661tvH5/jYFtgUSrm91q3nx79NzOGMAwlf
	HRk9m8yfOjA4gDM+LfT9D5XizGJQX/oRCb/Tc3bMILQGzd3LrxFfnwTQXiKRGMr+62rBpe/qMlE
	iOnh4Y34yw5ei+JmSlKla1RSKZaADiIxXShrdqSZIfeFdix/onK8oE6UY8zFJM1IumCitNt6XK6
	c7k+rf36B+lF5AFTsdxcl4E/Tbl+9t33Bv5fH5BTEn0tY+GEvSaWXIt4komFfbzItcfypQaFlWx
	n2CRglWwfSmclz7UgS/SQfarGWVXiSIoVyXoZRfkfvXXqe7zO1HUhD/slpTluX28Z4xRp/s1FJY
	ws/hJt0RY1GdBbdeSARLfqBkhFvEkyVhK0Z0nQWy1DxZgPP/6yvea/462EEevioISoixhq2TFPd
	PWVwCg7R0dMpupbyKOOPDXr9S7zPFq7/gTbQSEHCiGNHq9RtMHlT8ls5JUGWZviURQcqS4KQoBK
	nzP8f8wDn0AQ0Ge8XEdApoW30Tnoag22vUQO1wBgaSRVjEtLqROIOo0U3Z+TaAdV8wzOpQWOvaZ
	ullOwGatbKWLeR68SPFV72JAq2lvrzFyXkJsPfy/8HVvaPYSVb5ghmfXnuMmQgVbVSidUJIUVfF
	J7Xb3HKRRXNd7t8gkJcwuA81j6+yofpD4GEg=
X-Received: by 2002:a17:902:f603:b0:2e9:8505:5471 with SMTP id d9443c01a7336-2f03ef44affmr240191085ad.7.1795725656537;
        Thu, 26 Nov 2026 12:40:56 -0800 (PST)
Received: from localhost ([153.61.198.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1a74sm110470815ad.12.2026.11.26.12.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 12:40:56 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 20:40:55 +0000
Message-Id: <DN5FM9P3X2P0.2IFD5DFBRELP1@gmail.com>
Cc: "Harry Yoo" <harry@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <bpf@vger.kernel.org>, <andrii@kernel.org>,
 <eddyz87@gmail.com>, <memxor@gmail.com>, <daniel@iogearbox.net>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, "Clark Williams"
 <clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 <linux-rt-devel@lists.linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Hao Li" <hao.li@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, <linux-mm@kvack.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Will Deacon" <will@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 1/4] bpf: Add call for selecting kmalloc or
 kmalloc_nolock at call time
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Peter Zijlstra"
 <peterz@infradead.org>
In-Reply-To: <aecebb39-47c9-4b0f-a076-ac0ddc7724d9@kernel.org>
References: <20261124060357.11700-1-emil@etsalapatis.com> <20261124060357.11700-2-emil@etsalapatis.com> <DN38HGVL8JHQ.2ZVZQCKFXVA9T@gmail.com> <awWRZ9xCzWLnj_R6@thinkstation> <20261125140902.GE2668804@noisy.programming.kicks-ass.net> <DN4QLI2XAGO1.2DDIFJ49PNRPS@gmail.com> <20261126094403.GA49833@noisy.programming.kicks-ass.net> <aecebb39-47c9-4b0f-a076-ac0ddc7724d9@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6C2F80004
X-Stat-Signature: eezkjdz7f18a3atskoekzm7fb5fnkyxx
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795725657-467034
X-HE-Meta: U2FsdGVkX1/aGEAwdj+82F7arJ+6GC5aOdZx3r2zP042M/xVxRYvFKxoZIr7kzhGXdKP7zu3yyHQDoPzpKwNxxRqeReRieCCcL5rMsMeZZwR3RSOJWkSttcYwu3Y0LxzlEswJuHVNjpGW+gAFS+6PwtzTxfJibCTHJN88VnzLWnk1KCcY6gbaSErqmwKqodnvXSDBenv9chiza2uQgkA4q+MIkFpMN3MOu3zjmr52y09vEgZJ3pkHFAOjaIOyreD2V4H/FYFbY64RrQQc69p5OzrZnppvbGSdOvCPcWlRFZLk7DoNcUW0nFL9W5A3zAJ65ke+Yz8iAa1k45NRaLfGQhwQJuPtqd59vNibDyTJ8pbAs6qeo2maPAZ7TLrtIofGyDzvMw64hg/2TUo4uXuA86tGPiDLpZwq3iy3fAwpcmggDtIjTdTXTr61+q8+sh4fmu5mitPTRykiXTKiu9F1jZFZx4zZn2EQ4Q5ekwn+t/fHLjlxQIQQI04P8ByNfImxcYf0ExhDdI5eaTcy16Y1NajYTHhZzb143f5eudl/5+yTFSDF+ctFDfxoUytkDdnREZQI7YHzol4tyE0qPX5gJIknhXwcVlrcupljyl9bcV/66GsdYYbam0+xiIIdpSuew6NlJcz6Ax3mxzkeTbT7Ets2E79OOiGkohyK0LGAJdTXWJjrN6nrxzqW/uGgH5Gp3VgqSaTR9eTq+CG13xBN7904igh4q/buhYQfFCbFTZYbPWJeEQ3Z0PWXbiavNJCyzyB9ZiIHfu3D619JqNz1nsxE/Ih9XNGVgZVnIwrL8r8gaS2AynaFmpzNt4JaBWcj3SYzP4VGwt0BmdkjXi8emO5swr6H8GPagjj4I+micKH9y/Tf8mbrTWLva8VpCW2TudZMunu7s+ZMGbG7fPQ495bzglIE5lzTPL7qYyBa9GR/OjNnzTweuNWZKYkc82luBqQl+qaXepMHF+5Fcp
 sWL11KSm
 +ECJb9DMHAoL51iXBy5YL0VwqqD3zRzT7NxGq04mMimT8gb/MtCtdad70AqOyQ69mQjEa15EzJZsB5GwS2rPnVo1XwESnCZVv1WYv0XtMQSgLgKVwQfA6OpEWLayBapESH4mIdbSAf0+rL2UG0PSFld/LyVAnJdnxXP8r9Nr6ukGXbcLBbgymtahj7mFQYyWXa10Y/cgH415FaP/Z1hWvFGHLOFRyAF1C5AmcimeWp1B8+Jyo2m2mj+nugWI9/elteemYom77Fdue1hFomwL25/rHnuGx7SQ3qsYiSFOXjV1OR/MNF162iUCFMYOEOxpJ4Ho6T+ajp1sX5UBX6aPzvK8OfUeDMlUp5aNBccH0GbWIKmSvO0mhpd8IeD1IM0b8lI9bME3YpD59+nYcPGjveDUV11Xq/qvwcasbsJFcrgsDIwkAyTMAsMZ7AYLM7QWWjDSWUmMn9uapxOIZRqJtn6IS7FMc6JQzvI5J0lUAB+luID6SSJLfc4UynQjLifMQfFtXyTkRt06EGnsi2AluX06pGbwC8BBgolO3AqiWSg1hOypD/dFXT2N3mHybWOmcsm3FfWg1naGT5sXQIxA7+uUt8Ex58fOaDqCBrTc+NxxGi0TGLDeUNkyFRiRmLR9iQaQ+6xrFIJty76CP36tLjMbZUKxgV8e14x3DXLtPtPwnp8nq1+mu0pdDgBwFG7E6qlzFrEL3U1x/0hF8TzZe45JYzbh/4b0jT2Zek8hdpPzoC8XQiFPyLu+SBRzDM79y7avKHo5a/z01Pk1yH/KeLPDh4cKTI6Y3bPY0oK3+qttWBl0ibvdGnobn5hhZ4g3gvtqnrMY86z40l7ht5p6bsNFTqyFRbVCx/VhsZT4XLUbP/Ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 01:46 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> This is all just way too complicated and shaky, sorry to say it.

Which part?
I don't see any new concepts of failure modes vs existing code.

