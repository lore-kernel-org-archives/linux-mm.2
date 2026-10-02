Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924FDCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32126B0088; Fri,  2 Oct 2026 12:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95856B008A; Fri,  2 Oct 2026 12:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982BD6B0093; Fri,  2 Oct 2026 12:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0016B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:18:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4D70407A6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:18:07 +0000 (UTC)
X-FDA: 85278193014.23.CC8ECAE
Received: from mail-dl2-f33.google.com (mail-dl2-f33.google.com [74.125.229.161])
	by imf05.hostedemail.com (Postfix) with ESMTP id 048EE100007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:18:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cz3Y9pYC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790957886;
	b=YHJPE5AV6kQQXa7Zpz6ZhOPYA2Xwb4Q51GDT3QxJmI+3h2AcGlUzA67ys68H+fUFNsONUk
	IUTyPLNPosmh6H6zav4MhPg7HsxD+IOF3mkX1yDeAUrU7bS3MSzEdCIprFrdCrsWfnP6hY
	p+vXhSFqfoFyjJms5YG3l25851ZAnUU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cz3Y9pYC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJzj3UJHIC23fa9yBSqokKxP7nnZfefuPAvJHZmQ5n0=;
	b=nDC6WSrUTzQq5rAZIp49EnrC5En5HpUm47uaE1FQUSTCJk5wm5o5p5fsJrEHueqa0LV/AS
	K2L0C28530o3j5tItY1Ijkywou8G1vGFg14HtDPGGQ20mSUtdjNZsvcHWGkGTtlZzTkbfj
	0rIIko+1r8yuIK6ndemLlbxzK1GSaok=
Received: by mail-dl2-f33.google.com with SMTP id a92af1059eb24-1438e88300cso8360397c88.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957885; x=1791562685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oJzj3UJHIC23fa9yBSqokKxP7nnZfefuPAvJHZmQ5n0=;
        b=Cz3Y9pYC2Q+Mb1OVxkAoNdGIOGaIkLHuCLdnmKhJk06CBC4hNWsseCqKekL9mWRAmR
         m6abi9pWzo5bL/KHTBMRDeIozsbMdtKQNDluodmuAKaSTNbIVWALk9ezgszqTy0LQHdF
         iuJ3HV1ImScatcuw6tR2xkkV0VYRMzV5gza9NaavJG97IL/L6ACLtOKjDky19K+/HsG3
         VPRzOcH61wL2dsyyc2cE4aYfokhy+fKd0aDn1ODf79DEBkOvbRpXo0/gynaqeOFKUgVZ
         4HgwHIDYEoKm4vDPhGyXZ41utPWAuE41D5jpI3P+349Cz0xXIiD+T9sDC/LLMlWAzIh1
         TVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957885; x=1791562685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oJzj3UJHIC23fa9yBSqokKxP7nnZfefuPAvJHZmQ5n0=;
        b=I3GcOlMCX8UfpxAP6cjs3aKrxh29HcOByneD8a//mStV0pExTtkSokur2vqdiTH3km
         EY2BA/krFbMqRi7hR9I+jzvSMdJl2FxMfcAO38uSMsmtU3QDh1DtFsEoDxdtUjjcYUKC
         7Hgvi2ROD/DVDiSNDgsGTDClTzHLxlEZcXQzFzLTSglz4iOtuUDc+I7UI5Fnp/ISW7ZV
         iRfQqBvQOlM35cXp+est0ZZNFN+HTcyk94xQvPmnuSRLxconnGStZ1XcyBO+bkNKxYqf
         99qv/VispcnJA2hLfIfxcvOf8zMFyEaQu5asHJEX+94fpKl1WzJbqWWaJvu9UUUhIBx3
         MxPw==
X-Forwarded-Encrypted: i=1; AKwUvBzgsV9bWMZKgUBKr0oL4mT0jlHqbxh/x6V9RyX//OzMuO/ixil2gYOJX7z7K9GEQpw5I+ztg1kiFQ==@kvack.org
X-Gm-Message-State: AFuF++ljPxEhO0xAawem5h21sufs/9D05yR6V/n0grIIYdbCDB2aXW/6
	dxDA0uf4vtrKxiz4dLrdvo5JonBywtaUD4PjienoY7G8caIkBu0UAQ8g
X-Gm-Gg: AYBFou16G1M5AlOWcpFoUJUCFutaQIuUFPN0+6J1DI/L7Qqm/dpdZE5/ia3zo+kCWZv
	Dnh397MYeRow4FBLbl9T2kBhxswHvvVzXHyZ/ha1VIxi4WgZIc0ikuBbHQfOaC6UrRoYfXf4Xir
	DZ+p3i3uwHwPmp4rjwQ064V7w0ip+lkRVJABEZF8q7U0aHEeKMsBP+jPv24n7VzGfkcZ8qtB093
	r9B7+f+iCzxPcMZIw1sXfsZDVkU9oYyG3S5MBmdc6J10Wko4f1GVukNmQJ3kAA6oCx7l05rjP+V
	trgYtSpNb27sGz+rMbvAYMc5a371xM8wlkcvXTHQJ3dxJQSjqFSA8dg3Sly6RvBhAf4EBBWnDdA
	Bj0VJKLnRXWxsocRb0JaAAKCUlInlWsixUaemWJKprk1rZH3IfeXLPSsEYruCv/bUZTtBj1jTwR
	lx65F7OGjfdAyIaH8EunGmk1j2OEBvi6ATUm9kN94KZhvFKbXU3NPT5Niq+lZnnQ==
X-Received: by 2002:a05:701b:42c3:20b0:147:5149:d12d with SMTP id a92af1059eb24-14f5b70fdcamr3720638c88.18.1790957883694;
        Fri, 02 Oct 2026 09:18:03 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f468c08absm6985681c88.8.2026.10.02.09.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:18:03 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	brendan.jackman@linux.dev,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mathieu.desnoyers@efficios.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	odys.yuan@gmail.com,
	qi.zheng@linux.dev,
	rostedt@goodmis.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	weixugc@google.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/compaction: stop repeating failed async compaction on every THP fault
Date: Sat,  3 Oct 2026 00:17:44 +0800
Message-ID: <20261002161744.859093-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ar-8Vkchzn4QobA6@gremlin>
References: <ar-8Vkchzn4QobA6@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: hykpcsd5shn3hx8479rotbnm5aoaxkey
X-Rspam-User: 
X-Rspamd-Queue-Id: 048EE100007
X-HE-Tag: 1790957885-214297
X-HE-Meta: U2FsdGVkX1+cu7x6FEFQyJhtqCFcbmxmz9XrQu2wpE0mZDF2Ypnp7IYvP71aqL2YQJdDE7d3YCJ+5J2NNTfjFaHJcK1NtBJ9ekp2l6RX/Al3imqodkAIQbRLP9gpMjlKIHhf78fGNDqaGb8hhNNRn6hPtZIlBwarQ6+iPiy7FW20ppe19Ro2J0T6k7Nc8R7mvUrqaUhDcWeQWtlabdMv0nSsLSXwzbkcJG1vPuSPEvxeb5KDBtz0DidCBtDyzJq24OgkrfsKD/exBNOFxuTnk9FkTczUqSVKRjIEcK5e879WZuUhRD0lEG3Hh6CQBWKLVL0gQqlVhNrGYB5TVLjDyguXCUoycKAgn3hqot20rqVG/exIC2tkEu0XIU49VX8YRkC7DGInNyT9meQTM+id9jPRI4IVLpAQMAB1cWMaNR/f9aWFL9QDbnlf3pXyD3pvp+Mi7txvVdUbkf2AVuKDVuOuVtMR9MXaj1opwydi4jxTRZNEqniPqKVtrq6ERwrdfLLOddMz5/vEDwWEkdIvW09VyDXVJHtSlOwW96KmFQ8tZXq4Eci8UXY9uv3vupCQ2gb9yfUQZk5BngTCbwP2Swc1hGYyrnIsBao8TTlAEQE4huTesTBTSDSevHrlhjSXd4ajZOU5EOdbEzFqDqpxbBK/Sryub8gcLtBf6W7wyl3hlWxLwpDOpRJZ+pv+67M5KZPOwX0nCYXqZjBBC+O5DPo4CpNiQwg1Fm4Qwrqq6Dbj8RWdtDOUDVX8s6Sbf8QJIw9LbPSm3IeH3NOSsUeJhIOBLfBO6n7sG6a5I4w2OSzkA+vh7Kc5F2oFt8XzNE5h9SgYTi7fqaTt3TC/tvgoqW7ck03soGGzIyy7lOldGxmJIs/6hjxxvDKy3reIfQP1R56T68iOPR1qR8zB0g4703LkyniMdzF3OvEEsysjYC9ArydLxlKxOOLxjY/RkHCfCbL2mWUQge6STZLY38I
 rPhJ9G24
 kDf/Yx2egR3sU820NfVgN4yHXQhzKFyAJro0KiZ60jh/1p0NBuoFZ+WSj/oXz6iu76w/PZCL073rohW3DMaBpVWudlASwGqTM65wmSfKatGohrGQMbmbdBT+TeJOMmWIbh1RL6vcbVvb0ywh7gYQF1LJHs7NNhCR0J5bcHfkMbn6mTPufsw8Tn7ZeUXzkzmDhN0GCcbAI0IbgpfWT2GSzyTUH43URRnFd5Iv1Bw11OE806ZOF5WvZ4TKU5CVRaCnqCDSY8PgFukpc+NcVyPTU08Ihphl63wpEqtV4jUvWUV9oLPkxyA5hXwF894IqoTuOdBR7ftVaPSeVW7qjHfvEXLzthgYlV3rUoHp8tr5+RANd3ta7g2uogSnixFXQIH/nc1f2vMXoS49hqxbjMpdMk/RQVPivC68MwuryFa7JOPJmMgg9TJFBw80nCd25xQ+wuXjGxaazj+kNUT70h5atxkM6bmNd9JEaV+tdQXFBMKhTQLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for your review. I would like to respond to your points,
quoting your mail below.

> NAK.

I understand your right to NAK as a maintainer. I am not asking
you to withdraw it automatically. I am clarifying the facts.

> This series is buggy, and has triggered my AI detection script.

If there are real bugs, I will fix them. But an AI-detection
script finding bugs is not proof that the code was generated by
an LLM. Automated review tools commonly find bugs in complex
kernel code. The dhm series has been in development for a long
time and has gone through several versions; the dynamic core
isolation design touches many kernel subsystems, so bugs found
by automated review are not surprising.

> It is kernel policy that you must disclose this with an
> Assisted-by tag like:
>
> Assisted-by: LLM

I agree with this policy. I did not use an LLM to generate the
patch code, but I used GLM to help run test data. I will disclose
the GLM use; if an Assisted-by tag is required, I will add it.
If I ever use an LLM to generate code, I will disclose that as
well.

> It is also kernel policy that you must fully understand and take
> responsibility for every patch that you send.

I understand and take full responsibility for every patch I send.

> The script noted:
>
> - Output rate: since 09-28 he has sent KVM SMM CR3/Hyper-V,
>   ext4+jbd2+quota "shrinker scan budget accounting" (the same fix
>   applied to three shrinkers; jbd2 went v1->v5 in 3 days and v1->v3
>   in 3 hours), blk-mq SRCU tag sets, a blk-mq sync-run, ublk x2,
>   a 4-patch bpf-next verifier rework, mm/migrate move_pages (v2
>   sent 10h after v1) and this series. That is ~9 unrelated deep
>   areas in 4 days from someone with 4 commits.

I respect this guidance. I do not often have time to send
patches to the community; work keeps me busy. I am not spamming.
I only recently had time to send work that has been in progress
for months:

- The dhm series has been developed for a long time and has gone
  through several versions. The dynamic core isolation design
  touches many kernel subsystems, so bugs found by automated
  review are common.
- The bpf series is something I started while optimizing bpf
  earlier but did not have time to finish. Similar work was
  attempted in 2019, it is complex and not easy to write, and
  this has been pending for more than 9 months.
- The KVM SMM CR3/Hyper-V fix comes from a real problem I hit
  using Win11 WSL2 + virt-manager. I fixed it internally a long
  time ago but did not push it upstream. I only sent it after
  finding Win11 still had not fixed it.
- I have been working on storage for the past few months. The
  ext4+jbd2+quota changes are the same logic in three places;
  once one was found, fixing the others followed naturally, as
  documented in kernel docs. The v1 of those three small patches
  already received Reviewed-by tags; I only made small changes
  and added test data after a reviewer raised a different
  opinion.
- blk-mq, ublk, mm/migrate, and mm/compaction are performance
  issues I found while working on heterogeneous KV-cache AI
  optimization over the past months, using perf, ftrace, bpf,
  etc.

> Given you sent your first mail on 21st September and have since
> been spamming complicated series across multiple different
> domains, I'm absolutely not confident that you have any
> understanding of this.

I am not spamming. I only recently had time to send work that
has been in progress for months. The areas are not unrelated
from my side: they come from storage, virtualization, BPF, and
heterogeneous KV-cache AI optimization work.

> It also noted that you had a previous email, realwujing@gmail.com,
> which you have silent switched from, which also bore the
> hallmarks of AI slop.

realwujing@gmail.com was an old personal email address. I no
longer want to use it, so I switched to odys.yuan@gmail.com.
There was no intent to hide anything; it is simply an email
change.

> It also found several glaring flaws with your series, so it's
> clearly not upstreamable.

If there are concrete flaws, please point them out, or I will go
through the Sashiko findings one by one and fix them.

Thanks,
Qiliang

