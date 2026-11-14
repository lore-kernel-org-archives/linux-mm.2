Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE57606A33D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=p6W00gD/
Received: by kanga.kvack.org (Postfix)
	id 1A77F6B00EF; Sat, 14 Nov 2026 14:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1595D6B05B0; Sat, 14 Nov 2026 14:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049CB6B05B1; Sat, 14 Nov 2026 14:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D46476B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:47:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AED1A015A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:47:21 +0000 (UTC)
X-FDA: 85434758682.08.9BE1F58
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B6FF40002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:47:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="p6W00gD/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794685639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98emB7w1WvhIxOBHV30lEu1AvQx3qKoZ54Faa6ikAUU=;
	b=RbV5W5LnSiSLt2JsABIubGMhOUoFb94HZ7FhZ/n42fEGnEw3biTm7JYFtmoCb45WMvb+3D
	MnQcODTOHuhjVL4y3LdSrpy63AP+8yS014aIPJinTmkDlclciB/pygRI+cdA07fkuYlHym
	gZ8zu7x5VW2i/yYBEceob7PIhJE6XkU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="p6W00gD/";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794685639;
	b=NZMoqcSJf3ayyEDEDHwpUonYaae0GQytOOd1ZR0LPJ/Xin0gv3Mx6PhNYcKp9V3Py2eqhY
	b7nYEUSFuse3mpQGnv99qqPhfIqpja5e6K4mEO5p7ZwfuqzlvLyKiJ974q6Wcqlh4Su4LU
	Cw1P9TsMaoFNApw7Th0RmzqRMruhqQs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-55b8cd4e2abso21761521cf.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794685638; x=1795290438; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=98emB7w1WvhIxOBHV30lEu1AvQx3qKoZ54Faa6ikAUU=;
        b=p6W00gD/oQZbBhqrrQCk2Rh5eW4NLlj0l0rkQG0aOaJH4YuwbuqOK0ODjaIGPm+V7z
         Ci7GUof/kKa2lodrFOJO7m+WxbTmVtL1pbNKOCklaZcAb3KMtogXgNb86Z3rAgjYD9mx
         ACakchMM1RKzXRp/XZGiGr4wOwbpFWWmvn5gqYNpbns6Z+ttEd4vOH39q9mQ8EOI19Z8
         XYnAlHvmOw/eRRJDnmaD/4BnGJnCPxc2RoJiTVPXfi4kyogqCm5cc5SAL4GtFcmBQh7K
         LYlyIJIIeVnnRlgheDfDgElxOLrDUKXAdQjlMhBphc3vWb6tBgfzWobUQQFBKmTkJKwN
         M29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794685638; x=1795290438;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98emB7w1WvhIxOBHV30lEu1AvQx3qKoZ54Faa6ikAUU=;
        b=CVt7YfKI70yh/ZjOnYnMcH1q3xoSbVwc7bBbCjj8wqKgZTSkpdkzMUyfPYG260IO+2
         MEJbimXh0TaYnfcZ1e7xIi33ow+D+0Akstd1rXCEa+PfTfwG3f2GmOGo6GDfzbKCrDbQ
         3B4e0DtqifZlf9NohH73Nok3sXCtQE2OlYdqKGFXkfrb8V5IlowhudwXbVvvIl1/WSvZ
         AX1fK/BU3aKx4/7l3YnqmIQejsnOMOhtlW6bioS259OfRBJm9I4APowf1CnGRNuOWZR9
         6FrHpbb3FIAZCirc9pdKD6ZKU2CW8EBRrLpMyKBsqrxd0SL+rbDCHJLBX/P+4Rj7wEm3
         v/YA==
X-Forwarded-Encrypted: i=1; AL+hErEJfgZEcUbUbhGNvzDG9Skr6Ynyk/sRZ4c+U5xQbxDQmIg6Wq+zQB91tkxKJeQQDXbFFAq1HBoTgQ==@kvack.org
X-Gm-Message-State: APuU4Z/UJt6aXm5AjaR60D2DEo7dgXA/AXWeNMCEERAamg/e97rABnsF
	WV20XI2xMiuqw8S0ZwE/mRJgPBTNC5/2s9GKBqoVN1bmQ2LZMCdrI8JXv2hl2N75UZQ=
X-Gm-Gg: AYBFou1SVOD8J9uD5TJE3oABSaQ7u4r4l3PuO56WQfu3mNLSPLVJUHMxZNpsDyBTdyA
	0AFYGv36aj7ULp8KsLV7XAsI0v/TPcqOwJeAdqWOJrdKEhm6NyyjvCzp0Xuq3McUvpl2EgZBkGr
	MGR0K8DuP4uBGvOjnGURXMh1MNrWYptHbDRZOVjInN0Cs37e6ZBm+xUEV2wfddFp0XLZG8UlCbH
	B5WNZoExNkk5gxa+447gZFNdq+Q8item1VYiPfzmKfbsAns6D7OGRfh9/wos4Cr2G2z0DZERVeR
	Ngsnx60zHYzHxBFg/yYfkYdXxNY1tiu3fwW6DvSM/0oo4x5XCsZIXAdvppklQHSsXfihmXpXO6O
	2PnxxfD5DDDDkp4/XfzQwaL20pzKkSLVEVyPXCxfEJCoPgHShtJyJi0yihXglTmAT9CYGhr+xIm
	m584lSHB6dcj4sBDZ+NfDKW7MSlo5ZsXYEijMOqn1LwX9Tjp/kKfjTUOsap+MJVM6NsffI0E5pn
	E4PcK6dcY2GpCPtc5uKdvfu6RJ3tVPOhIVUUFiM86JZunGuKPZr6Ggi8ITduQZj2Vh9LbKr7nZq
	9F9vN20tOgdiER4nTPFPf/p/RsBuFRfgmSFay+Wlqqpsl5nuAgrZrnX9MPOPttOvAxytAGKM9ns
	WiWzPNGk=
X-Received: by 2002:a05:622a:191f:b0:536:780e:8f42 with SMTP id d75a77b69052e-55ac7466d2fmr101182171cf.33.1794685638449;
        Sat, 14 Nov 2026 11:47:18 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d7ba48sm49222936d6.28.2026.11.14.11.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:47:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vma: restore VMA iterator on full-range merge
 failure
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: shao.mingyin@zte.com.cn
Cc: ljs@kernel.org, akpm@linux-foundation.org, liam@infradead.org, 
 linux-mm@kvack.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261115025832904-wsPy8LPoyIcDJ6FMU1_H@zte.com.cn>
References: 20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn,aviVQ40at8rZEyjW@gremlin
 <20261115025832904-wsPy8LPoyIcDJ6FMU1_H@zte.com.cn>
Date: Sat, 14 Nov 2026 14:47:17 -0500
Message-Id: <179468563735.482102.182237761852902643.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B6FF40002
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: t5yg7q5coatj5aw7g8gynbty9w4y4q91
X-HE-Tag: 1794685639-688577
X-HE-Meta: U2FsdGVkX19KFEisjE6Zrb4scEYtl/kvUuy9zE4kMPDxnXHMJ3XxSiZOrSiYVNJ0Qwb6+0eRjUKtsRmbRPO+PRCEQPkLloDvwycTjcVlXfghnF9XRtpeGsBQ7DRG+Ew0xZpvrfNhWuc/dy49GRHdTI5PzV/yNmUncdovaXNMXkhdxjWSNpZozac/B5BbpJV+E80wD2kRCmc8aTSnNlYHxfRhP7LXchNI+c/aF3JKOC7dYhfWWrCCix0Myiobo7FTphtc/xqcja/03kBxJuwtKbY5VW7aSube3WEWjeSkPR11IBPaAV4RsViSxB7Oz2X0/HookMUdzoKkOkYi/5zcxHyx6yy4HB7jeibs/iTv8rYmYQw/1Y5K7EZfKT3y+DVRzOpJliIwBXPqR/S+Wdu8k9kpGRcMgjlYqv9gIymbtHADciTF5RNF+2UgqFLp0lv2UkD4+qIzU/THbde/Ok8cB+QTtAKMZAT5CiTfgc4svbNjPJL3Mb2bxUfOEomZ2cpzAKnRmavp+5G+uLttPal8beQLrxSJi8y6FUJ5F02NS2Po7ElWkS3n2ACbT7UEGFvWIIvb0EPzx3eGquHXkCUctqsUUuAKDOL1tbETTJ1mM5Uv/+tVeWAdrzY6fhUVp592PkS5ovixogYmH7wYY6krPnlsJmpFiE1OCj0wVslylkN3sqPDY9cbPOGVL3XgM9Sn3iIegfnH7K8Xk9ob2zMvzEtmtAoO9aGmwF3SzvFoQpZ3N16pmxm4mi/VUsGW2C/qWZu0qvHAEliLri98OAYYulQoZozYf0ogcD9pdM270SHlFzJcREkWyNxHiOd8wohSz3Kqtlqd/2BcBWRIxNtBhLm9ztZeDGFBM8Lm+6C4eMiKx6FSyBm0vHNxzyUWmJOibszDbhNUW6zCvZj8EUPt3ZSl+bKP7RMIQQKG34/4vEUL164YHJO8aqVZtCpHVzWZbtvVmEgTDz498rrW+61
 RKdy6kIB
 zFx1PIH2naTJvzxqr0tbPIRJFyuPf4HzAFv8Hwust2C0H3A5UwnTk9iwHCQbZt+ruOoojnaxO3BN5vxtidttAXygD9fkNnX3omBZLszNFxXy3trXHm54emhFx6Q+M+XvKDUVtCP5BvRvk1e3FpUxo6sfvYqR2xkwM+wc9mhk54EXhqNWVyJH9E9abOOG5CLPZm56ptExsUu3ibhA+XspSUUEJ3lFejEuBWAz64hqVjUME1VqX80WIqHFhJ68wNkjx5QZNaNd44F5beU6rZc1e5QtGPqBF4Tsg6sj2USIpOitAKHLIExz/sxTSxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 02:58 +0800, shao.mingyin@zte.com.cn wrote:
> 
> I would like to learn from the technical feedback and improve the
> quality of my contributions. Thank you for any further guidance you
> are willing to offer, and again, sorry for the interruption.
> 

It's a matter of triage, attention, and respect for people's time.

If a bug is unreachable or so low impact that it has no appreciable
effect on in-tree code, mass-driveby submissions take maintainer
attention away from critical issues. That is a net-negative.

Exporting this triage (mental load) to maintainers creates a strain
on the humans in the loop.

By the time the patch / report is read, the damage is done.

Even reading your patch message, it's unclear to me what the iterator
position being off even means.  What visible effect does this have?
(None, it's not even obviously a bug).

You may ask why not pass the patch to an LLM to help automate that,
but then you are externalizing the token cost (and someone still has
to read the output).

This is not intended to put you down, just to illustrate the frustration
that these kinds of submissions is causing.

-- 
~Gregory


