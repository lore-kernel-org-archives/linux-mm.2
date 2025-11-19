Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCF3CF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E821A6B0031; Wed, 19 Nov 2025 10:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59816B00A9; Wed, 19 Nov 2025 10:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F5A6B00AA; Wed, 19 Nov 2025 10:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2C266B0031
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15E3713B2AB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:02 +0000 (UTC)
X-FDA: 84127780044.19.8A71D82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5B4B120005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:44:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AeYttVC1;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+2RMibk5qCZlj/6zmvcs/X6W3gfpL9YpQv70ggfokw=;
	b=ae8pMXBXJqtQxWFhCLuSQ4qcIHnF50vUzWJvxTCMWYJwLMJHU2T5ch/vXRKjLc0fnuks7O
	xwGOG2P6mbtBvoobiss4rF3eLUjcvazoRZFE0ONCyzFFtotFqSx9ELl+ArnmOHofa7+hg8
	IwW9QV0Nh1OdvFfr4QcEHwPxwSSRV1A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AeYttVC1;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567099; a=rsa-sha256;
	cv=none;
	b=MeoXk2QrGrX/D5cSzdM8hVGe+1VHwKyyDTYknqPn20WTxC0a3Y5RbCPHZkvRw3AcaGsQKW
	c3Ue1Efaztn2PWWCVgxpSiGFZjleWl3Jmn2BX4wscDciP0sCBH3nRaRL9JIwP6RM1lOikl
	rW6sHH94v2ru8LYY8GkUQ2N12SFTVxY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763567099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+2RMibk5qCZlj/6zmvcs/X6W3gfpL9YpQv70ggfokw=;
	b=AeYttVC174L81fsSZCyrXbteruGobwH11N4VmTsj1LnLTBvGEfqKc5QUQdnF/cAOHKnku7
	VVFSf0XD48X+Q28ADTsihAeuFxwsvXdZfoJ0Vto3wS4n/5OX6w13FGA8Bti+B5MYKsq34z
	NFPKA4k39ov/fgx73H/KqrRffdW7j6s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-xiFIA2grPTyVK3Sukd8EfA-1; Wed, 19 Nov 2025 10:44:57 -0500
X-MC-Unique: xiFIA2grPTyVK3Sukd8EfA-1
X-Mimecast-MFC-AGG-ID: xiFIA2grPTyVK3Sukd8EfA_1763567096
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775d110fabso53013125e9.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:44:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567096; x=1764171896;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kk13dNEBENY1o2hkoOmhPMN6DaHaKFtT0pxiR0fZhjU=;
        b=RbsQNyuvgYfeXadzVW7OfPj4yg6kK3Mv3Z85Tm59RFJhWFQTv/KSkSMiTuho24Xdpu
         vtSYMCOA96UrvZfxXoChzKVdKt/aZM6lCKWtGXGvWInQdSz3Pon1H7Pn9cSxnuA46uHK
         1r5jbLCXbZHY5d46QhN/SUZQJ1jl4AZjQt+hlY4xN6n2pcoad7bJfZkTIcPlTflETGHE
         KT0uP1nuLWJMSmIN6k7v0ytVkBkEKj3TlTNxp0344jpouEdXnE0xWU9Uv/4EHqgYSbYN
         UlcVoloO3RcCKUdOyH+2ld7CuiARPLhWIIKn9ZOn3fXugKCAaPJFqOA2oNpQwAyNbHXK
         Xu+A==
X-Forwarded-Encrypted: i=1; AJvYcCUyJBHa1baZHIevNs5XA3mrtvHwwaSoCi3ECXGJggDOFLSqlINX06T0ympKPwmU1HbENCdb4JOPWw==@kvack.org
X-Gm-Message-State: AOJu0YykbZMFvN0tRQj4QB641E7bAijtzJxz2X2rJLsdSyWkM94N1uYv
	CKhH3+ootmpF5kgNuFU/w9B1YWQy3YWZb1+7sw11hWilJawJ6P9lZwxSdttwt84vhdSyaxzLxBG
	JJ4t1AKZygTkzfGQ4YATzuiCtDJ6Pp3J5D/4rJLTP6E1qY+fWXv/w
X-Gm-Gg: ASbGncuTfymXuOgACH9QLp+qoOaKJlv8MfPlV6Awmfap/y6jDBfMoPjwrEEXnloDkN3
	YiKIQFRXbVGvd1r+yoSs0BP1akNZeQV3dbPbI5h3hYcFOH8F0mpZu5fOV52LkRN3893LvpD0MID
	T9s8EEG5c2qTw+ohWQFpRkcmz+AHp+4vfGhTwNjccnJuXYxPxZ8+IqhcYkVM8hg7RNNvi0YY8UP
	0qBtLTw+fZovpPt1QH2Q1zW56b9WQdsYeybC+krnT0JH2pgtMHtAXSaN3L4CCqM8VAmi3o1jSXH
	+tlZ86LvoHVRP8evG1PHEQrL5JnMj5kQXtm2A6B1V8JGalxsUJCqWPh/UI6QOfvkbB1MQHA+DlM
	Qfx9+smjTyOYB8csFTUJy6fsDVgz4YMSCfP3sJibIeiFVldSwVQhFY09oXws4NexiuNXU/jo=
X-Received: by 2002:a05:600c:1d0e:b0:477:9cc3:7971 with SMTP id 5b1f17b1804b1-4779cc37a15mr119021015e9.20.1763567096269;
        Wed, 19 Nov 2025 07:44:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkP+NxoN8NdgRlSeWXCmLJ99Tn2hRpBffdqlJtKvc6mMNR3Hn0LkbgzbfrqY0lLueiMZLQiA==
X-Received: by 2002:a05:600c:1d0e:b0:477:9cc3:7971 with SMTP id 5b1f17b1804b1-4779cc37a15mr119020335e9.20.1763567095710;
        Wed, 19 Nov 2025 07:44:55 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b10260adsm53340155e9.7.2025.11.19.07.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:44:54 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Andy Lutomirski <luto@kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, rcu@vger.kernel.org,
 the arch/x86 maintainers <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>, "Paul
 E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Sami
 Tolvanen <samitolvanen@google.com>, "David S. Miller"
 <davem@davemloft.net>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel
 Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>,
 Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman
 <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro
 Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v7 29/31] x86/mm/pti: Implement a TLB flush
 immediately after a switch to kernel CR3
In-Reply-To: <65ae9404-5d7d-42a3-969e-7e2ceb56c433@app.fastmail.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-9-vschneid@redhat.com>
 <65ae9404-5d7d-42a3-969e-7e2ceb56c433@app.fastmail.com>
Date: Wed, 19 Nov 2025 16:44:53 +0100
Message-ID: <xhsmhecpukowa.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yRhimN83dsLxFDe7e0HSiVArGmFTACEvJ8dYvfj2ecg_1763567096
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5B4B120005
X-Stat-Signature: b6c6pwqjcipbsa7qjeoz79az3jypdwss
X-Rspam-User: 
X-HE-Tag: 1763567099-440250
X-HE-Meta: U2FsdGVkX1/VAyNGuHU5JFjq8TJbRtdoMxauTE+luwIFrc7S1u/sXDtKBdPjRyVdGHYHUXyVNXYds5TLjrN4n2u0Qem2x0Mi/DzY1LMnlFPdRo75dtpkJS6kdQ0Ix9uSqhVm4nqSVbbrDXgmmbbqh9VLD7h6FHkPjjA2OTuGSrn1xiL1bfZlok4PsDRjoOEe+gQIn5Qn8KLPA12h8wJwczDMTl0cflTsMB3nHPDquqrFwA86qF2erPhf0q/B0RI6J4j4SpmTTkc+GYZThnTBQUlYoZ/5DZCkAm5j6Y3Y9WzPpIQHx16xNIUCB7Kji2sD61KtZBAg6JSJnqI89LFyanlk+7UhgyakSg57zkIgBH13wzkLGCYCr8UlNESYGmpZcHnW2XUA4i9sXSR4tCMtsq0KbdtStWIiFefoxV70YxmYV8MrPiLUwjyUoxiXtLG/CkVd+uwjyN098QPJATA9oO91+FVfVZtpGA2XM6kZraYJIE9P56QL4izxE7RVdrZCcMQh8z/ULSGZhAdFRpaxEEV7AwisSJTzbzHdxePtAYLNksSAJJGz0fAi3b/K5MRbkHWs5jLvF5myBX1p+75paW5Jo9RMjAcpAIgCehFPj8hTCAvgaJJU8JfxeYywDkvhAhPjuKG+lQiGYgNmUGK3847OWej03fnzERy2phKkfjSb38M5dJB3V1l5dqberrAkA488BC2/qSlCabR436H92yHheSfej3GnddfFUTTUD6f7f3Z3MXLkMOSKFREhvcJxlRsWg0FIhbVhrGrOtRhfItSSxSPs9OWFgg4z6BBowGRxcvMoAL+A1+hB4YpxZvzMOQSaNVMtry647E2zlnk0M0NHZBZEP9ETg1b5aEx4lppGIm/bm40DDH71oqGT/yPtf8YU0KWBf3I1hoTygRiKoQjRsVNc82pCgyjut+inbsMuomRNc+kpwzpXTLdJJ4RCy9+/fVfSeCHUV4FR9yP
 8KRud7fQ
 GbzsqDKhVKKlF3g99ZTcJu6El6NDq/+Qjs4AfV6xhlx2akwOYroh/vqpRk8ucaklrme7Ik1LKKMtco1DQ4qSBFHbZUZ0n43vGePVksN5mAuSR2rxwJTk69URDsSPexOwqq0RebYj156vkBK2pb4+rMl1V3S1CmAo5XNzD4UlX1nDb+BSyr8pSrzy2NKczxqb9tsaYcvEQxmwN2Mxrz2S7//ZORK+pCwBr4UhtN80vixJCMu/JAKIyeXLPgvhm6D7AapVUWeJkR51agWD7Rn9iZ8AzLW3MnV8nmKX4LtY2Hg7mGClOSomXR/veh6El37dhmbqTm446TxbzCHvZ/ctDs283BVeDVQ0kyP6PvcSyT8zJoQtDVwWu1Xp/AXFxqVby80dvta2fV2JfsILH0kEgSSrn6jxyMnleAivLbnxniVRNBefpN1kF2PAZIYIWtZknLoCG8StESjpDEB4UJ0fiz2IieCnRZe8731AaA0/DJ7+uXIHOtKUCa8tNs+eAJjmSYiPtcKjSNjaQC0W05FNckrKJLq/0yWm3eVnkn8OF60ND+91/wb8WnTYLbTnwGY6T1/97TuPHw61fLo1mraFIGCTe1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/11/25 06:31, Andy Lutomirski wrote:
> On Fri, Nov 14, 2025, at 7:14 AM, Valentin Schneider wrote:
>> Deferring kernel range TLB flushes requires the guarantee that upon
>> entering the kernel, no stale entry may be accessed. The simplest way to
>> provide such a guarantee is to issue an unconditional flush upon switchi=
ng
>> to the kernel CR3, as this is the pivoting point where such stale entrie=
s
>> may be accessed.
>>
>
> Doing this together with the PTI CR3 switch has no actual benefit: MOV CR=
3 doesn=E2=80=99t flush global pages. And doing this in asm is pretty gross=
.  We don=E2=80=99t even get a free sync_core() out of it because INVPCID i=
s not documented as being serializing.
>
> Why can=E2=80=99t we do it in C?  What=E2=80=99s the actual risk?  In ord=
er to trip over a stale TLB entry, we would need to deference a pointer to =
newly allocated kernel virtual memory that was not valid prior to our entry=
 into user mode. I can imagine BPF doing this, but plain noinstr C in the e=
ntry path?  Especially noinstr C *that has RCU disabled*?  We already can=
=E2=80=99t follow an RCU pointer, and ISTM the only style of kernel code th=
at might do this would use RCU to protect the pointer, and we are already d=
oomed if we follow an RCU pointer to any sort of memory.
>

So v4 and earlier had the TLB flush faff done in C in the context_tracking =
entry
just like sync_core().

My biggest issue with it was that I couldn't figure out a way to instrument
memory accesses such that I would get an idea of where vmalloc'd accesses
happen - even with a hackish thing just to survey the landscape. So while I
agree with your reasoning wrt entry noinstr code, I don't have any way to
prove it.
That's unlike the text_poke sync_core() deferral for which I have all of
that nice objtool instrumentation.

Dave also pointed out that the whole stale entry flush deferral is a risky
move, and that the sanest thing would be to execute the deferred flush just
after switching to the kernel CR3.

See the thread surrounding:
  https://lore.kernel.org/lkml/20250114175143.81438-30-vschneid@redhat.com/

mainly Dave's reply and subthread:
  https://lore.kernel.org/lkml/352317e3-c7dc-43b4-b4cb-9644489318d0@intel.c=
om/

> We do need to watch out for NMI/MCE hitting before we flush.


