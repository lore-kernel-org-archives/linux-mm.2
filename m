Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9BFCFA442
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8772D6B002B; Thu, 20 Nov 2025 14:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E936B002C; Thu, 20 Nov 2025 14:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7641A6B002D; Thu, 20 Nov 2025 14:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654956B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:20:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 142BA140322
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:20:24 +0000 (UTC)
X-FDA: 84131951568.12.4356040
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id D48D018000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:20:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GmJD9zCO;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763666422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GdkfT+k3vOqAIJe3mmQZm2FSZ3v5dOxrZlq1SxHp5k=;
	b=3m3S8ULvb4QNWr+/MNoAL/0VCupJ70ZTsz4425PeblRrvcAbG1xoftfiN81rIxDUfFk+Nk
	y0PoH795PPkohbnnNuU7ATBsjDkrDKpkozvHRR8tZItp/Dbij/JuU4mChgNXoC1egfiFk7
	sQjuvLWHth+o3mTM5g5rClAEFHam8Ow=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GmJD9zCO;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763666422; a=rsa-sha256;
	cv=none;
	b=dNmYgIRjWBnBJ/oLFI/sl1H3UR7t20/TVrFrQvm3U2bwWnXhxUq884ErvguIO5Zg6gquRC
	gNs2z67HrRjqDeic4XTPZNO5M2i3kiqDBWsZ0Iaj6luO+1I5bsP0s8LZNy1XQ8dCXUJvOv
	z0IG9YJ6nU77gnAP7hDppiWzDtWIn6M=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b3d4d9ca6so1118109f8f.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763666420; x=1764271220; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1GdkfT+k3vOqAIJe3mmQZm2FSZ3v5dOxrZlq1SxHp5k=;
        b=GmJD9zCOVaftY1LAjXU4hFPGMPRxpThd/UpoS9rWvvQpmvcnZgY6Bwxixb9+8puUQ9
         3DFJdJSiywSxRduxc0s85lceex0OnwiVYNUJQlt4wnwUcnkC0aD+eHXd/VlzrA54JkvP
         QAcerIyNDxzFaqC/zDkfQ9WTh50CKsGZWA7co/pbC7fJxJbR4durMmM0MITT8thi7hD6
         heEC5Gz9WJwfr5VXwIrbDjApuczPKkTmrIFk4rW+RMUwIQbg1wE6cUk3YGwjCZL6kDAj
         H/nl3HVFfF7uGK7VrdlIJQWTLS0lcbwcOi5EzPghkeuJ0OCt287CNpc7KlftakwolvKB
         coQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763666420; x=1764271220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1GdkfT+k3vOqAIJe3mmQZm2FSZ3v5dOxrZlq1SxHp5k=;
        b=ou10UHTtGJmfstlJC7Ad2yFSwL2tGjE8RK1+Zw/QUlvk6S8qVXqgCeMFs6QZIPPhmU
         BXj81oUQ//6PC+sGa3liJmYIMYpvanmu8Fo/c66A4V5TaInA6km/Nd/fWCqc0fLbRB4c
         qIeR/ke+dNHQ+sSymh58ncO26LX33TYZapmOba15xT74szS0YUu68YKXVdDEH5bD5ZYY
         wJJBn8Wy0YjXTBW4eD45z2U1eholo2kIA/zMqVazMG+8eK0oeOyUe5UTrsm2yMXol/aG
         3Mz+fUpxMHoYJ2LnXMoK5ZggHYbxTUO/Qe9QlewXpRHvR51dQ2u1vY6C06jplo/Jy/bC
         Z9rA==
X-Forwarded-Encrypted: i=1; AJvYcCWIL7px+535KToE/78Ej3EC1Vfv/CQOlg0Lla574oIaXw6fEzijzmiRQeqyHLXuJA0TyYYLSBmoNw==@kvack.org
X-Gm-Message-State: AOJu0YzsTO08/bSgxtcGZLoipPm4ruP80ti4cMGPxs2T15nwWPQyomPE
	OXS7nllCF2mC4Lo+xXuqzjNy8lF6BQ86fSUyyrYhQBOMuDDjX4Mlj7QfVVOIwKuuZRE=
X-Gm-Gg: ASbGnctZHqsYof6zIBhBzNXHXnNmAgUCMXfSceeveVg5mQleToi0H7Y+fo4+JASseQa
	brzzEx98AwBFeNR6utoroYCBq3QkbLIu+ZrqYYypwUMStc0MHQIOhefXXvvj7z+2W0JYp/SubKi
	5zVQEWDUhGphlVluXc99YIuge/FHqd3F3xlMeorCVANpeIWFDJteVAWQdEynkz3XNFzkzilTO7/
	pqQM+SqySoIBxMvPFg1/XVZ/UGPolJyAQzOOwtjOa3heosaCP4GQZzuYVwShBmEILjW6rXMPoOQ
	2DL+M3lYLBpyBxC3ERAIND7nMZOCdstI2CjNRkcj4ccyamT851EGIaPkwb0RV/eoOPUbwGGrbkN
	dIYLUc0u7PP7FiIue7pQHqezwu2bfP5+gjpR6n8w1atmogyVDBetHSufgemRD1xe/oM361+08oH
	S1erlglnzhXkD4BCSPU1YuPyNS
X-Google-Smtp-Source: AGHT+IGAoi9mcb2Ki+Vf2x8GF9MIVNCxw9/ODHm+fzM81xCrrAi2YNRfJaEumj8/F5Vldpj31JhIrw==
X-Received: by 2002:a5d:5f50:0:b0:42b:5628:f4a3 with SMTP id ffacd0b85a97d-42cb9a0d86bmr4652179f8f.1.1763666420131;
        Thu, 20 Nov 2025 11:20:20 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa41d2sm6785593f8f.22.2025.11.20.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 11:20:19 -0800 (PST)
Date: Thu, 20 Nov 2025 20:20:18 +0100
From: Michal Hocko <mhocko@suse.com>
To: hui.zhu@linux.dev
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
Message-ID: <aR9p8n3VzpNHdPFw@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D48D018000C
X-Stat-Signature: wcc8kxpxmyuyw9km3qigwuxgzkhx66ba
X-Rspam-User: 
X-HE-Tag: 1763666421-994693
X-HE-Meta: U2FsdGVkX1+W+qOSzYeq+jTqUkmAT5MPcqQ7+6GmF+s2IOCwK9ShShgK2yT7KDmvPQtwD+8qJbNL+jkEdXd2IsqiTACqcbcGXHIDIwnzXwQEZGF+ITd8YBxKmb8oTKXaYzaa+C7dMyMpSEDZhNtww9uyoDHhX3A8HInM8GES6tU+GAiCSu+ocrcjgzGNL0szRy6Q4SFmDdoyZ+8O9uOe39voy+0mC/a1kQKVD4NwmFU2LTSlQWfNvwOn3qCJ1c2j+lmokZ02K4O2+tMBpyQ9QiUC5mp5xcKF/nwPGqApUGHL0vNB4WT0K4FGlsxIlq+3GKIEnDWfjgwZxJt38EFXQ6abmJ10D7n1XybGVbZpwGAEEN7jUu5nDg5wuhOxOmwR3yybfCjmNdDN1vECxDl2E8DAps86A7Lgv3rfc2cRG5yV+/+eDwHPpFoQzJL6zGOioGebVyIv0BSyOo2JZZS3/gJatKANFNb3uPUJpE3Y2g3eP918WvclwkPro/eSc9mUPlWErMFzw3I4KZgbXmM6nbbLbFfupW4ceaO7OLuyZg9kTbtoyCNSQmevwVfqyaRpcdp5AuMRFADTdmCjKl9gfr5zI1DpPRicn+pFlb/l5DO0/A/T1SDXrl99aGojTXprHbSiDpnlRK9AQ5C31JfczfqQ41Vvn6054/g8gJrhGrH7JSIdpAfXdAG28VtVBxayZzeRZ6u46ZZtQBS1JsMbfK1G68iV6yYezvoIgMQlqAL5iTAPhTTEEqrzmAhG7BBbhacZKB1IKeXI0TRZ7O39LDPe4do1gmI8XZ2xi627yMtyqvTTwimWGZ1kPpe5VpGSrDWQuPvLKjS3KE0irNAtBlvyjzNT+AwxUj/koJetQ7axWdvdzmg85tKJh7bxPAzOtDya35nrXywJQ1GCs3Ncx/wJrKt8vYn04P1/gdF+wzxugR6lQetWJ1/6SlUt4YV47b2xGHAQ+7U9PX6xnPn
 CMmel9QH
 KI/WjGJvbXVSAqFpXdBnS9rM+d6CXldXuTFiRUHkJ3DK6k2MWYoU3cvbwn6wKk7ayeV5NuyBXalG9/r0xkxveaccuQLs18cTUKEMWMLQOwf35NE07U8wL0i6TAY/UX20OGqPwJ+lb/lC/vC4AF9caJ3/iCET//NwoBae6/nmzQTdimc2wXQslqNcf43Mkso/Ckrt3/27+0XXmCy4RQiK10BxKA/oSAZ++eB83qMmOmlUNj9bqCP6CtDdDL6IgexoV+7wd45vxLPPeTScxeqJtFByYaRFvonStkBug1Ss6hzgFCPx7NiX6es+Q3fCOVMHzYFpBiGsvdlncwFXTAhuU4jAZQFjGSWAjBjK+bLtxETl9pvgLauagW0TLO6qiai4NPBYpsCbshjTfWfv0t7gAWhZvYzHDuOsnv0yScdTOpwySHgnh+bOsEEfDS4mblUEH0YhV2/nSXjkN6cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 20-11-25 09:29:52, hui.zhu@linux.dev wrote:
[...]
> > I generally agree with an idea to use BPF for various memcg-related
> > policies, but I'm not sure how specific callbacks can be used in
> > practice.
> 
> Hi Roman,
> 
> Following are some ideas that can use ebpf memcg:
> 
> Priority‑Based Reclaim and Limits in Multi‑Tenant Environments:
> On a single machine with multiple tenants / namespaces / containers,
> under memory pressure it’s hard to decide “who should be squeezed first”
> with static policies baked into the kernel.
> Assign a BPF profile to each tenant’s memcg:
> Under high global pressure, BPF can decide:
> Which memcgs’ memory.high should be raised (delaying reclaim),
> Which memcgs should be scanned and reclaimed more aggressively.
> 
> Online Profiling / Diagnosing Memory Hotspots:
> A cgroup’s memory keeps growing, but without patching the kernel it’s
> difficult to obtain fine‑grained information.
> Attach BPF to the memcg charge/uncharge path:
> Record large allocations (greater than N KB) with call stacks and
> owning file/module, and send them to user space via a BPF ring buffer.
> Based on sampled data, generate:
> “Top N memory allocation stacks in this container over the last 10 minutes,”
> Reports of which objects / call paths are growing fastest.
> This makes it possible to pinpoint the root cause of host memory
> anomalies without changing application code, which is very useful
> in operations/ops scenarios.
> 
> SLO‑Driven Auto Throttling / Scale‑In/Out Signals:
> Use eBPF to observe memory usage slope, frequent reclaim,
> or near‑OOM behavior within a memcg.
> When it decides “OOM is imminent,” instead of just killing/raising
> limits, it can emit a signal to a control‑plane component.
> For example, send an event to a user‑space agent to trigger
> automatic scaling, QPS adjustment, or throttling.
> 
> Prevent a cgroup from launching a large‑scale fork+malloc attack:
> BPF checks per‑uid or per‑cgroup allocation behavior over the
> last few seconds during memcg charge.

AFAIU, these are just very high level ideas rather than anything you are
trying to target with this patch series, right?

All I can see is that you add a reclaim hook but it is not really clear
to me how feasible it is to actually implement a real memory reclaim
strategy this way.

In prinicipal I am not really opposed but the memory reclaim process is
rather involved process and I would really like to see there is
something real to be done without exporting all the MM code to BPF for
any practical use. Is there any POC out there?
-- 
Michal Hocko
SUSE Labs

