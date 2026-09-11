Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4ADEC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 23:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F196B0092; Fri, 11 Sep 2026 19:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9596B0093; Fri, 11 Sep 2026 19:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4808B6B0095; Fri, 11 Sep 2026 19:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1BA6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:24:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E10D1A03D3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:24:12 +0000 (UTC)
X-FDA: 85203061944.18.8F0D6AA
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A02A40002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:24:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cpjhJl2h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cpjhJl2h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789169050;
	b=EAxDrJnYtvS6n7N55+tvr0XYyBzzJy3X7FzXrrrBZAPUm+TwchGinI5rlI4OQzWVqIlDIe
	n+hBMTigLYBD9cVwJJvoqyapQRnHmC245SOc8rffXoPzmk7IAayNW5IJoJWXwmj8batZWC
	htHN2lTAr9VvGuBBCTadnM4R29EmqH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789169050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLYK1uyd6czX8B16m6xbBDxNBXBkc9fwokq20u5lm6s=;
	b=K6gqL0v3jgs4WTkXPQuZLmmBf8PqNASCQ8D5xytEKlL+HAJ3h3DEHeXAAoiPUi+3y+wl3L
	HTz0qI9EThBMbrb26MUMnCyWyWBNoncqjNpFHw6nIAJZ9fvZ8k1Wfttbz/wRmW51FJFcSn
	r8IMrv14N01u7qfyYIMM7fDe9ioW08Y=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d6ff3aca06so11055ad.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789169049; x=1789773849; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wLYK1uyd6czX8B16m6xbBDxNBXBkc9fwokq20u5lm6s=;
        b=cpjhJl2hu6v+rJjz5HFbXo9pQTAPm8ND6pAEDOxOxsM2dUkhpxcQrfi9Ts7r5sE3DC
         t9yKfGmg8JBw8AABEbbT3oFmpwGmWXUQB4FDB7RRt6oWXrag7H1Z08J8TfK6Tt9H+HI2
         BsWmodPGu18QxXfKpmQH49qwDqSgptT7CvCuipy3I1X7agzPRoDateftgfR8Bv3jb5z6
         pLg/3Clcq4wZreM6JJw1QyCTjZ44NwJqPqyffTkqwn4S1ZFuukV9j1YzcIIhsAcJ8+Ni
         iHXdRHMIUFSMHUAAvw88BT3X8327wuOwBtC5vMcGmpwWu0MEIvvanURpGgJywuyGvcZ2
         T0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789169049; x=1789773849;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wLYK1uyd6czX8B16m6xbBDxNBXBkc9fwokq20u5lm6s=;
        b=gA+XpqcJaKq77B2nKvZ9OKdyrzhgDPDNgXXj1GRn/2qNEZtDg1nVnyJcwZ+tGT+5PA
         Ty0mjl5FnhKrGQBPpgxsr9rkgTiA4az2qDYBOVUXPwsPZb0NVbN3AT3DAqu8NjlzrVYn
         H+PfppbhsVUybR4RxAQEdqo/FVAj9TUSNI5YAglX2Jkxj5Mu6Cf1LIWi+TG5c3HJCu9I
         cCpKNuub222O9IuXRpmMuO1A9RXr5G6lCCgkDHT6Dy3FBepBc5Z/oaBpg1920yptk0mS
         ITd4s10kjIlOiSIPuHgrNPzxl9IE1fidx95HSejxbFcY1DCMEhTrRHqAHoBIg5h8QLJG
         bhjA==
X-Forwarded-Encrypted: i=1; AKwUvByQtdgyWAhXsD+3gb67rxzsu7O4a7q8qaOrIVCnLrdODQcEngbt6I9JYZhsXYZQf0hrbJcfuZopYw==@kvack.org
X-Gm-Message-State: AFuF++m6+8vy+OjFr+MZYdSxGMQ6O1mma6qg55YPS55gF6cVvDYZwBpJ
	0oh4WpEImu3RV8Ez13F2Sa6x1cBXC021bXWJXq+8viU89lmAH02MUaaYaRz06YLQ4g==
X-Gm-Gg: AYBFou38C6VVbxrLsZlJ2dnhtHIAsrx0ZEINKGMhIB2TCUkZgN/u6JSPZmJ0MLwi4/p
	lmH5x0nfvEsWegl47A8jPOjtBlIz2SLN//sSz/fYpLgkI2GysejSqAHRqyiW1a1ZHfpImzvLOPJ
	EcPObXswNiLNvSmNSmbfRSD63sjOiwAC+9HrSqHMNIWo8yzATqESUaZQuoK3e3pT+T4igYOiFCT
	LmTQv17NEyFZk4Eg0G5vw8lqSMfbZryYw36uxIIHIKUZwRHCF+4IxpaPwXV5D4wMMj4jJdfJkC5
	fb+6dG2vGPRh1r45CU9209Fl4UxJlhdKSQw/07VybUO7lT0RkezrLihHHdQPmEdz19xAUFlEJvn
	m7jeRbMlXBAO1EbkWRkvUa9l1vPvItds+LPqFbrfoYlkZsD5Phvcgjy6rqo+WW/81T408Bwv8aU
	svgItJFB1chmSMXoLYalGf9eQR5VXkh07hsi4JVxteY8jsaiXiXuG/5Ur6OoNmkpkrjCPyvXw8j
	rMEQwdUQwqPI0fzKXA6odBX9493TiBIAPrgCrU=
X-Received: by 2002:a17:903:2309:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2dd47eceefcmr3132765ad.2.1789169048773;
        Fri, 11 Sep 2026 16:24:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:5f1c:c62:bce3:653f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e52a60sm9050841eec.6.2026.09.11.16.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 16:24:08 -0700 (PDT)
Date: Fri, 11 Sep 2026 16:24:01 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: =?utf-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xiang Gao <gxxa03070307@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?utf-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [External Mail]Re: [RFC] bpf: account ring buffer backing pages
 separately from Lost RAM
Message-ID: <aqSNkbhIuaB5D0H0@google.com>
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
 <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
 <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A02A40002
X-Stat-Signature: kksgr9makk15rjoruf4d5sfizjgerdwe
X-Rspamd-Server: rspam01
X-HE-Tag: 1789169050-486720
X-HE-Meta: U2FsdGVkX1/riCFhxSPZTOkTEIyiyS4VhqD6CdFBagaZYVwyAVHkuh8Dh2Fzytw2yokS+33SWpDSDJXciWiY31fc1MUwTB5yzMAKFtVkCfess6dJ9wA8D2p7ebYwEJ7T7sewFFqYDb1/Rr7GRPntCgu2wqQg9YmXmrq4W8sR9PUY7AypKdhLLXzyxA1/Kpsaq5dWY3D8ApTqCyALOpTJVzzBIoWyaBPcg5WqxmoVSmTjf2Misml/HCfjcVDaJ0/LDJFW9LDw/TewysiPly8cKq5CcLUsPBCmSs3rSkw+V/Ys82tNg0fWBsMeYXY5pDqz7dTlL9tGpgNTg95YlsvSGxycpF4S9ygBiZ7ALOgIZv0EkEvxmqZibP46p1Mw8j7wTji3SL2KuTlVjaZlxPFp7faejA5gKrF80DscXgBKoz8Ai911QPSzso3inJ5kdrvyTQTCpOLF6jcy2ubDB9Rk7MKXopbt/P7O5DtWv6CQMlhlxHRfpcwTD/bDs0YznY0jUrvTMl2bVWDqgPJfdC2HojGfdh3bQX0AuA+9ISMve1lQXLLCDt0m6bey4xaencScrh8ffXCy6aGP+RLS0g9no4svYvEF7eDK2xm20Qn1S4I0eOL8GKgOy8yPHs67aZaSQzfoc4Rc1xlup0xRWaIZW9bJaJvTjZQv2wsFVHB0x8IFcpRITXFwXb4ficPUG8VfNDnsj/NGKTtYTUumamqTWylqx9vM0qb6TGDR9guv1s6rCiCWBwdhMnl80pPtH+ubom7uuzmsimMhlE6NFejpraVSQ7d2rloILPAuxoF8OcwGrUlObdNdf/wG4nPeCQi9+Hq9IdjhBdRTGfsetG7FKPt16SSXM0FUARTgt/N2OWGXNybZOMoFg6ASV99qNI8jI4+kyXW8eVSBenH47ulaZFl7d0FodG4WYdtmo9iGO1q+qpgV1LI0n64b12PRL8U5rklMlHpBlaq4iIc5oML
 p8woEhEU
 8KCIv3n8pmm+d//Q3w142WFDZm9qrFN8lJAuGrZH5PdwXhVftjtS5yNVPW6gyaam9+I+/sLUkO9Bjqi5a7EcKHCwavBKQ+rfSGdV1X0E94ofhfvcWxmMv/6hggL9q1OlOsaKI987V9heDMFc93dBAhTjnFBxeIFJga4E0CHKEqWaZKe3tQfx2Rw8saQOh3Wg1UTQbcQPX+nSCoAclo5b0YpLunfSu+hz8004kP9OYMyz2Vh409aAr8/o5xZOyUBKNzf75PNu5SqOGUundAf3b9lnBW7Abd5w7Cg56NFYqit3Qvmw3S/n/4AGdSDbDIbrlCM6DSGgfdEOv7qab8gXxkj07mG00p0X9vceVEQxdG69sCLx26z9FbCW20kcNwVt66FjRUIbIThEp24xKcMdZwoHpVFMv+pAAf0ARY5KWhu0aWGuvrGMUNxHt9dgUzPTjKCrTeO3r55W3ysD9KehGpiPtOk849b7pSLhceL/pftkzZDQSjMqrmfvh2sXws42fxxCXyZfN6Ntql/pQ/A3Ph/HN8YrelNK/exBH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 10:24:28AM -0700, Andrii Nakryiko wrote:
> On Tue, Aug 18, 2026 at 6:46 AM 高翔 <gaoxiang17@xiaomi.com> wrote:
> >
> > Thanks for the pointer. Understood — no new NR_* counter or
> > /proc/meminfo entry.
> >
> >
> > The remaining question is on the consumer side: Android's Lost RAM
> > accounting would need to enumerate all live BPF ringbuf maps
> > (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
> >
> 
> For BPF ringbufs specifically, you should be fine just iterating all
> map with BPF_MAP_GET_NEXT_ID, getting its FD with
> BPF_BTF_GET_FD_BY_ID, and then passing that fd to
> BPF_OBJ_GET_INFO_BY_FD to get map's size.
> 
Hi Andrii,

Thanks for the suggestion on this! I did want to express a couple of
concerns with this:

Scalability

I counted the number of maps on one of our devices, and there are 112
maps, meaning that there will be between 224-336 syscalls with this
approach. eBPF is becoming more popular, so I'm concerned about how well
this will scale, if we have to invoke 2-3 syscalls per map.

I had a test program that implemented your suggestion, and it took about
2 ms to identify 39/112 ringbufs. As the number of maps in the system
grows, I'm concerned that the latency associated with computing the
memory usage from ringbufs will become even more expensive. This is
something we had an issue with before on Android, where we had to
iterate through various sysfs files to gather wakeupsource metrics [1].

To improve on this, I was wondering if we could expose the ringbuf
memory usage and potentially other bpf stats through bpffs
(/sys/fs/bpf/stats)? This counter could be a lightweight counter that is
incremented/decremented on ringbuf allocation/freeing so that when it is
read, there aren't any expensive computations.

For this specific metric, we could just use a counter to track how much
memory is being used by ringbufs and have userspace read that. That also
brings me to my next point.

Correctness

The max_entries value is the size of the data in the ringbufs.
However, it doesn't capture the 3 metadata pages associated with each
ringbuf, which leaves a gap of ~468 KB, and that gap can keep growing
as the number of ringbufs increases. It's important to have as much
information as to where memory is being allocated to, as there are
devices with as little as 2 GB of memory that we need to be able to
profile memory usage with.

I think exposing the sum of ringbuf data + metadata pages through the
node I proposed earlier would help achieve this.

[1] https://lore.kernel.org/all/20260511174559.659782-1-wusamuel@google.com/

Thanks,
Isaac

