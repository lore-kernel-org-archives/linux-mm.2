Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3EC608209C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plT89bHn
Received: by kanga.kvack.org (Postfix)
	id 4ECE66B05B5; Wed,  4 Nov 2026 16:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4656B05B6; Wed,  4 Nov 2026 16:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B37D6B05B7; Wed,  4 Nov 2026 16:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E16B6B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:12:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28FCC1207CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:12:14 +0000 (UTC)
X-FDA: 85398684588.27.08783E2
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44C64C000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:12:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=plT89bHn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJCUPJzDGMi7/m5Ob7nLHW2RF/EysBxW/BZZah9AN+I=;
	b=RkeXTj2NVnKlNI/86yIk8Q10kRKQggqML3vFr9zUTlU4zFY7gjhLkvI9KhVUxVMjCdbtN6
	V3IoC0mhrwwSa27Ba6Ho+LE/iVs0nx9Mr/PvRGwGTmUYyQjyVFSNSPn0jN6iTTmIykEzCm
	pOsGBMvLP87azGdPzlvk6pckzL3hlTE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=plT89bHn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=olsajiri@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826732;
	b=QljT7X8wrscyNNEeKo2tintvZuJeQs6xv9YioOa5s/1ed/XlAyYe8xgZa4O89XbZ7n96dd
	9P8NO1923PFk7h6ToWb8cRqkLfIG8iSXwYMwgrTXPFdWHx5omlcSi2rWUIO6cHhID6zeeG
	SGRdVC8goSkr3WFsTJEcfkjnS4Ojoro=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-49134c8509fso99380f8f.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793826731; x=1794431531; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zJCUPJzDGMi7/m5Ob7nLHW2RF/EysBxW/BZZah9AN+I=;
        b=plT89bHn0pqxQ9T2AqDFT0c1tN7/zD79FkdLmnAodU5XbYq4mxIIAswLwvzawSenI2
         /kqtiZW7L4DN0j1OhTPy2FbFLOM4yoOEDOFKkAoyYPuLHWRbWLYsB91ScjgHz0jtNNwU
         dJG1GZiS0RniwMgxtLAyDOwcsgW5dZgZudJnc9MTWDmpNwOyfxhNSdQ2Dc5IviHCqWq6
         diiiUuVx+Hf/VHaGh+FmvVN6dHvYnzgLV89TyarC5zkCkSrshExXqYaRa+mefY7GCu4z
         iFIU/XrvYXasDQtMNr6VzBhyElXb7goGTzwA12UjZPg4zTB4LtDdemiQHghCHyigMIiR
         VTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793826731; x=1794431531;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zJCUPJzDGMi7/m5Ob7nLHW2RF/EysBxW/BZZah9AN+I=;
        b=GUEOHma0x6+Cz7c4uOjFy1JimkfuvWZmFjz66COdPQ4eS3iZmmSY9RgTUqzUaVt806
         nuXA1T+6SWAmsnqE8RHX0lx8+eavxVFz5prw8Q+xB7fIfGhMQLuJwzoNWq8Eq/xJ1a41
         8HNi0yZ4wHlP/UtlS1VBJlgU7Bp4ULt0dEU6iNeje2+sYFwQg1xuHDRPfhJAexehMyRd
         PWiDsae4Lqb/I8rFVSQrozg+m58Dw/ON0lVsjUfXtmLFbTrsRMc0je4tUNP1bodoR8PO
         J44GCL18Zbt+1KCRAAaH6T1wv8cA6uebLtFWAUzPYkWUPkXwxpGisHx15yjkawygNVW2
         ZSUQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWQuilqrEmGKWcFZYlhp6dMXCDjxnv/9EmUzUSdvNEq/8Wu4+s5/D3gDox4re016OboVQz+mLnAA==@kvack.org
X-Gm-Message-State: APuU4Z8j6UyxkPXogx46Qb5e1sKJF8NuDnakNNXS0ywZusDq/fMEseAH
	zMuYchOdgme+e6J7h0d0lpkzY+u20Fk81kSIeae+tsVd204D1bwoYVsJ
X-Gm-Gg: AYBFou2d+l8ShbxxUscgc6gNgqGBPeZm9Ld/0LrhVyuPTpq6XXs7DRJrdJZsz0g5TYB
	k+7ACyKSxzfoDkwG9rUEo7+LIBxsrgn7rNHtzgJpKCWxR83xf7zLIkeOGlBCxZX4WWCDjS2sryo
	Gtqk5IkUsjt2Qq+tzZiWbLQ84KvBi4A/B7RQyZMku7EHlJFaya26pSukAVyHvkFlBK+2voyEtD+
	0vTMQurd8MMfQbqrffV0nAFoVDBNoueXll8bMjGKPkBXdNjhYA92GJXJrx0G7WDkkh5n19Hko4G
	1Zb+CScdIp1+uhXQG8yB/IOWJbgdYTag7lMNyNeZfNfAATQ5WUMctYb/g9IOZy8aFltRAj8xvqJ
	0wehvn5ukN55WarhIcp8/jXv6R6EOz1czMRjONNZ5siEofLkpsPYGdou9YJTJYTxAK6300FW7C3
	LRgrEPVv7TNCXQBimA3VLnf03I1YjL2dw0wi5uPsO/QOy7uPEyEUXU7Pu8cZcEqZXs1ZE3Wl38d
	N1yX4oCNHPpIn7rwuZVTqCNXQXVtFHmNklM9dOSvORBFsRllzTs+uC77+HyjR0+JGkXC/czDhy+
	aJUxFycPUGhsTsE=
X-Received: by 2002:a5d:5d13:0:b0:48e:47e6:fdfb with SMTP id ffacd0b85a97d-48e6e302699mr32449578f8f.13.1793826730893;
        Wed, 04 Nov 2026 13:12:10 -0800 (PST)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea18104bsm6173320f8f.6.2026.11.04.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 13:12:10 -0800 (PST)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Wed, 4 Nov 2026 22:12:08 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCHv2 bpf-next 6/8] selftests/bpf: Test user memory page exec
Message-ID: <auufqLgICAPhcHrj@krava>
References: <20261103075916.100050-7-jolsa@kernel.org>
 <f140cba1c8d3bbefc759df505554da49c4ffea61ed0684ddb9f1d3c6effa529e@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f140cba1c8d3bbefc759df505554da49c4ffea61ed0684ddb9f1d3c6effa529e@mail.kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 44C64C000D
X-Stat-Signature: cgh8wa1tyxmgwgzeh5gxozzouc7y46ob
X-Rspam-User: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793826732-927373
X-HE-Meta: U2FsdGVkX1/tT7vMnQndBNqOuVJkcurC442mgOuH3Auluhv7slo4rZoBcE7DXqbn5UCCp86ZfCGt3oGgBF801AkfS10vBkukZUrC0feim5BJ2JKAywPZfYtfBjNYAqy8mqexxuljEWRKrBmHHC0rVN3PtRBDQBjnFMqkSvQMRYkHZOhvQv5ZkCaNOR0yD1KDnLW9bqoAqyAK8/L8OwXQI7PxuwzpVHkwMcNJkqiYv6JomQO536VeXaSgWJKu/MV8SXkUjC3U3OH2C7lRNi7GKAZGfilPSoAvm/L2YBV7PzNKiZddfG4/Mg/cEqvGAnljobjNoqpNWXWZCJXwyDRPEYICMkGcowpaLTgfYuR7byKPt/9n89krPch0PC661pyAobfBZr2X4MC48bpqTfLuSZofPqCQN5xiqH2uKcYMu/0s6MMeD2+5DSV03QBSuPw8ybWRO/p+rka+OEnezEU32pAwyI3n4NWbzeVukX4sGsxYi4WiRORV+7jmg8rI7Rw4z6kn3ClpnPurlwt9aK1JjCGI7qsg4MSiW/MR3mzve15d/3KukqUS4zCeW4E5OsZ3ndKRfovXIchQ5Wv2SOhi7Dgs1/BmhYjjHxMAxyROr/TbJFrlww7cTrfoh5RpdnELUm6qKi4PoAOrPgCZKHCaSmT+YAnwiiXnk6unT8i+o4BdIY7pOWb+gSnTQhUP9vmTIXYAJfOjVJLDeMwasMhGjgwadelSeFegrVfNv5hBx6x5Mm9z+xxxmD7cnXw5UBeJeaQsorxUo5krSCubGIx8EyQZWBMFewjn6M7vbzzQPgifiDftI7d69P/8tlVP5fU4D5otFu84Tw8md5ycLx9a/fAZlqUj7VtAoRncb5xqPe75liPvuxwfDdkEMdnTDuKDjHe4m5OGEDZQjjpyq8Hoqip7D4kMhJ7qos4Y4DaO2vX6k/nYlQExIlahizaG8dpKwI6jQA6eDHuKudEDNJd
 zCR/48JO
 NLgosfEGOVqe2leBvDX/tef2JelGKkCVG+zf0Uu4WYnj+3NlimxbFnITDpVPwECUhwP5Lu2811EU6PdGPWwKayzCDnQyRvFFqFW7R6FeyjbbuIfBgCviIpO4z3sHiFP0LoUtdQXDBdXtSZpG3JKj3BgPM0I9IxObccSlt/GJjT8gQoRsojoEOtmlVaNPx0E1hB9JLh9KVNdI59IDYv+KiImWuTGuHu800hvHAkFqMTXbXOgdfxOiYDaKpISP1HwVXnH27jsQ7PvzwoIwDy1gpR7qPOkR8T/zj8Jxixv200tYhhISdjWaarQ9+2KiE7DKqjhT369xDZBUFIM0CzbMnThKDZpzEbJ68DoDyfDQlZ31Xj2p3+fxTYxMcvOTS7gorma2scXbIXLNB9S+XO4l6FwOpAsAfy9C8QqKSh+8PUkq6LjETfo8p9MvpjC/vbejoyh+4ZoZtJTJR6Z3adrq9b9nou/WMvo3LG4Eri3naW0vQBEAasBrSnmLwcdfgY44l6qYzY1yYZ2GHVBRDn+I0hgHui9tTjFJh1zv0y8jA3YMJno0/JaUvyErBH+FodImml7HZqW/OuSaSPmlEAhjb1zMEIUzMxoVdk0KTG+/4Q8IO/ycwl++F8geHiybF/ZE79uVRyfiPg5kMLEPBqNzAosJskg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:39:47AM +0000, bot+bpf-ci@kernel.org wrote:
> > selftests/bpf: Test user memory page exec
> 
> TL;DR: Nit only: in user_mem.c selftest, the bpf_copy_to_user() ksym
> declaration names its second parameter src__srcptr, which may not match the
> kernel prototype's src and isn't a recognised verifier suffix.
> 
> > diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
> > --- a/tools/testing/selftests/bpf/progs/user_mem.c
> > +++ b/tools/testing/selftests/bpf/progs/user_mem.c
> 
> [ ... ]
> 
> > @@ -10,10 +10,13 @@ char _license[] SEC("license") = "GPL";
> >  
> >  extern unsigned long bpf_user_anon_mmap(unsigned long len, unsigned long prot) __ksym;
> >  extern int bpf_user_munmap(unsigned long addr, unsigned long len) __ksym;
> > +extern int bpf_copy_to_user(void *unsafe_ptr__ign, const void *src__srcptr,
> > +			    u32 src__sz, u64 flags) __ksym;
> 
> This isn't a bug, but should the second parameter be named src, as in the
> kernel prototype of bpf_copy_to_user()?
> 
> The __srcptr suffix looks like a verifier annotation, but the verifier does
> not recognise it, and it sits between unsafe_ptr__ign and src__sz, which are
> real suffixes.

yep, leftover from previous change, will remove

jirka

> 
> 
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md
> 
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41602296728


