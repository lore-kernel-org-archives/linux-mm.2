Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0632710A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1902A6B0093; Thu, 26 Mar 2026 22:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141566B0095; Thu, 26 Mar 2026 22:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02FB96B0096; Thu, 26 Mar 2026 22:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4AD76B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:48:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 843F08D455
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:48:03 +0000 (UTC)
X-FDA: 84590308446.08.0A46B03
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D81CC0008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:48:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oADfDVYz;
	spf=pass (imf10.hostedemail.com: domain of yc1082463@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=yc1082463@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oADfDVYz;
	spf=pass (imf10.hostedemail.com: domain of yc1082463@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=yc1082463@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774579681; a=rsa-sha256;
	cv=pass;
	b=5PZVD3ciKkYGFz1GxHMYD7F2iNAZNaSpFEoPb573MWHUU4hkjDNklXIv8a0WFnAyG6FX3x
	UnyNQ9x0CtS85mW5xxI5N9E+aSLMUeICPDNgVtRl2qTWS6G1HibENFl+xpdLmWaYc3n+NR
	+NQtfq00qOxDdo0KD0yhXb6bBTZ7bY4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774579681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlfyXUX6gjmSlSlJChRNEecXdllpT7D98/cgS8kOMJg=;
	b=5AVx0gxchaTjaRxbtpnTHzf/WY0tz/TA6f2WhftUiYwQFuzH0XFt2Fce/5ZXrgoxUtLf4b
	M05yYm5IQlF7Yl6AhG6PanqUakwlUshFsupCZWurzVuk7M+jB/L4LTWwpdaG7QSjLfD/As
	gfpXvXqspO8ZbDNiVy07YcGINrPOcS4=
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-66b2f6e983bso99787a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:48:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774579680; cv=none;
        d=google.com; s=arc-20240605;
        b=Wt9DVOiRdZkyq4fHT37fxOu/KFxANsjGABNLfxN8Kw231Ks8vdXvNtYrVh2psLndpj
         IKnyirUZ/uW76ByJTn378GFp5RpxvfdOb3F8UET4y/2q9+DtRvdK6R4dOtu4I/M4i/Vj
         Cfx8cwAevJ9W6C7gOURDdUKV6aopEkRK8urGw3uYjQ8zuyEpp39dtJfkbuAFRVVmj9SD
         RPY+B0ii3GWmHNGo/R2+xDJy1fnSVqegu8BVBa78IVspneFQaVCKh63i59UK6+Hqnqk1
         pbT3fI4HpkixCZOU5CN3v6/eVnlXzMtxcw12tb1v/sFGwb0nVpZzTkMlIlyO8ueU8zjt
         9oWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BlfyXUX6gjmSlSlJChRNEecXdllpT7D98/cgS8kOMJg=;
        fh=VkO0QTYfDuhpLc7azXb9b/WafYKO9UYsxfXarOauQbM=;
        b=CunC3L47YYzADou6kZBoihyojNCdAsnqP3WXByG4IrHp2tPz+WaUN5sy3OnWiwVAkV
         UJdZym4UOgWCC/QLs51qMnHJam9/fCHt+L9mFpKUDXWVBH6ouXdrMcZ/j9U7t33gih5W
         XGYwvUp4RmuTcPPvZy9ApQjXsp0P7si0igb+WmmbIyP7hxuzpbpUbBJkOgLOGft0iYSF
         deLtooejA9FEhCpLXtq8gL0U82sV92XylXE99BDPvJxjQOzUo2v+y2e9pyQAJJh4M8TE
         0qHml/ipA2GyX1Te9wGwKtDHKf9E/5Wtv9qW/E9QdBVm0kimeOyyJHJSfZvkgUnVrNnk
         rPng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774579680; x=1775184480; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlfyXUX6gjmSlSlJChRNEecXdllpT7D98/cgS8kOMJg=;
        b=oADfDVYz4yQfyf6tucbP/ui/33MXgLtIgIKfkcmeEKk24XG+Yav+NRT5U1eiu0T+h2
         XMADFzHbJV12ocAcXMJ69Ui0IkDJU7ueqnzdnlcQEMng4bkt2+cqTPiY4bViW1ltFB8T
         YmD2EQI6hCPLKoeuujAk5/Hqs3qNUgQPyzdAv6ZAJRuv0nAw/4KQPH3l761Dv/ELgwAS
         gxbHdzKKNL0oH41rSqNV4rSmnkrJyhX4cEBh8QFHSqNuLlv6oIFKd/bhojeAG8GE1Eu8
         lFUiRGu42BYFGI7+Ado51Q+JOQCdxk1TDJHaMwxCMN/9kHe/TcXQWfihrYBsBGvn3t0a
         qV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774579680; x=1775184480;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BlfyXUX6gjmSlSlJChRNEecXdllpT7D98/cgS8kOMJg=;
        b=czF5GqmGE7GsXf8y1WKwRtEnA1+5rMg4+EXrvLIUhCabnEUAFAxpo5zve3dZ1/IsL/
         gD3WD86taR73nHZb3JXZvRMlViI8w8T1tgRNoKod6gyeRcy4uSc50h9A0mDlZ3BIxx0h
         seSvJ/TB4hmAam7V3pXlkwQtqnyRmuXB73Dfgt8T41fnJeKPkoOpYBGmu+ek11mZibe/
         1ku7N7s2Y/ShR5p1P5inkYeFraNadHK8f31iosmntWlwUF7jZU1QFS1U3Goa2A3a27so
         YKZnT5OhubBYQuJezao0oCTCMNiB9k/TQ4+Tzsu9Dw6g7u5VH8zKbmcIKVbnGdcvhqg/
         vdAg==
X-Forwarded-Encrypted: i=1; AJvYcCU8VrO8VNLPQ6TSbEri6H537ys3MXIh59fmcd/PbSYXVjguvM7lQCVscgMQB8xPGtvDyncH2vWMyA==@kvack.org
X-Gm-Message-State: AOJu0Ywo8EAApCZPGGyRZ9BPdggpC/CEPujCFS31vU+RKayiGULEZKt0
	wNIbbnS6bFTYZLxTsyDXVFsX5Ev0RvHiKvR3u418NhcLnBQ7q1w1F15nz/Hd7VKP71XZe3ancvC
	WFhCRClPrs50A0Qf3RlcsTxBOFkq4YKk=
X-Gm-Gg: ATEYQzzAE6bn82EzUkccF9zyrfba8X+0Qy54d/yN5VGRvhmxxNAPuHTFlU3tdePLSe0
	g9rlxaXxjJHb8TgywyBre87p1A0uEuc3rL+m5sF8R23xxx1WAe9iDfxBbvDKUANznrCAjpIk17D
	cjqm/klzbbwCyrJXIpkDcSCgBe+O1rxqC1yEG15fxDgsaD9B+XZbQWBVNO+swuMSWgVrrIA35UI
	v0ci98J7pUVNVkK65E8LupYG8QjeI2OFcRHEXdj5pt4J8M13kTTcWl2A9FBOwf8QuG8JUG2Nxm1
	ptPS2+NLlOpsWLLL3JtI8czfwAnNew==
X-Received: by 2002:a17:906:9c94:b0:b98:cb6:e896 with SMTP id
 a640c23a62f3a-b9b50909b02mr39272366b.38.1774579679566; Thu, 26 Mar 2026
 19:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAN2Y7hzb6yfHwHdwMC1TTP87dbnn=BHyyWz+iCQ_EswN5jVjeg@mail.gmail.com>
In-Reply-To: <CAN2Y7hzb6yfHwHdwMC1TTP87dbnn=BHyyWz+iCQ_EswN5jVjeg@mail.gmail.com>
From: ying chen <yc1082463@gmail.com>
Date: Fri, 27 Mar 2026 10:47:47 +0800
X-Gm-Features: AQROBzDUAyu9tpNSOVMlX-OjnQJ6xVte-6P4kxe-3-vWu77CbZkBxfC_Vmu4fvo
Message-ID: <CAN2Y7hxx8OQemOiF17swXcLccd-KJ=j0P0tkWD+fQqzL5O1FhQ@mail.gmail.com>
Subject: Fwd: [BUG] rcu_tasks detected stalls in kcompactd during proactive compaction
To: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, paulmck@kernel.org, frederic@kernel.org, 
	quic_neeraju@quicinc.com, josh@joshtriplett.org, 
	Steven Rostedt <rostedt@goodmis.org>, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, joel@joelfernandes.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D81CC0008
X-Stat-Signature: z4otc1c7qoo37erawmpi11mqh1ibi4ju
X-Rspam-User: 
X-HE-Tag: 1774579681-561818
X-HE-Meta: U2FsdGVkX19ZT5OmPzv06IojGkUl6NmHRAX2jfrolxDqhHLkxRZB/marO3+7Lep7Fz6Q887qWp3XpYRcUtdp0G0fXfN8+Feq0/HqI4gmapKt4ePsTvuWqdByNg8bD3esjmr2APRc6NSZ3oIoaFu22t4WWTAnlzvGeQDE8j4XJbxotv4wOl2HyA6JJ4sZME4LkGfwAr20njYg81boapXyqEiYVVepKYws0oII5XPiHbQ7rkAIBbKXsFL3TWGPCHqSz7CENMIB5hNvp1HNBySo929mjBNWmkBkRT3RMpiLOmjNEu7A9f9RfHuxyekSYEgkpBnF4i8Fomhugd+RYa+l1u9F9eb1oCodPA27TxhawJMreuV+2FdlY5ASdrGyUPOiE1tDD3LFiWrZmA4BI1h4r+dbVuY19GwuIyyjN8OFakjdkTWXrrJt3hPLikX1PaZcYE7aUmlz7uu5VAacYsyQqGQ+foB69Ar86vu32LoVBd1XtLvo/EVU/8HY+izrR1ClNO+00E8VD1xX9PrZFSuRgguLrepeqZqD0xX3MpEf40t1p1DQztiJ/Cnw3DO58B3G5QucTRSekhHvHVK4m2ovLF+I2y2cImq0F4eEFH3NslShk+2qCGy3+F1g4yZIYUgdAhXCQXWxG5Tbcl5lpjX6ZR+3AkKe0bR6LSX78LduT9ck9ImD26ml9wxZv4pbCuDhg7FOBigFEFwmDFOFDAyLhjYN9aEMF5/o8Y0SoEelWXruiUeZLInj7psVUiDUiKX411imY7uCE0JA8eVERhhw76vK8N5oPQJDCXDtn2Y6q3t3hW0782ZNWSSvriQL7qVRF2FfeBC6FEpP/5h2sdYbveDmSxGx5lRbK/yDHBQh+K1LSegKBCTQHKep+EzYHcoKi9lJ732qplAJNpBSofPDJJPUHeEbh0KJAhs8m0XvEWHMkj9d2aKhvprouby34E1UYzRAJXtlnPYytA+xK4A
 ZeBZwvwB
 ePsXHdlKRSrCcLfhLiGQCvmaEaBKUrEMYH+ekQ9jl2eX2ZDzbzeemMxDLfZquQgKrYyNTe0spXJhwixfj3clpnINHojFnZFueQItXk6xeJB+Cr6dzlSKaa/4tFniG08kuGuqb0nFHu7PM3RRD/m8uZAzXj5o10j+OK680QfripI7p+0axEQYN6JDVNw8YofcM6OZgfsNjJfVrob+8psp6MlqiIrov6akwwaPuFeX9SG5aUXx3o0Rl+bD/I8aXgWJbqCwENUBTblCajEyjPru8NFP8awPrpNNIHSblzfvmEDYwo8ACX2xGfa/MXkN8ww3mTAhmYUavt24MdODpQGguChWbaXZlQ6q48ioimBsy6cUcDJTQ505moSDTsF9IL3zjxQpN0Q4mOhR08O/Hhe5ppauf2KjFrhzDigBgiOkCdGpM2f+BUTR0dd0TyTS+wF2hHy8N0GkPSwJMaZCzy4j8xTBfu/RqeRAssHC0oWJyTpn6ujSSOgEsepW58Gzl7g4zvZqAF0QDIu6WIqoVuSDowQ/51+L8SNuVS+OaNLooJ+RtCtcxbXzpUNzccKx97BKWh/Gm2dQLbicUoX3kEuBF2d9iC4BVXZtStXCILuLrEPuJ+i5okmI9AYMXai/BNT47NdwEOztLlwOSGYQ6z9tbJ/+qw4QqZQZwceT9P541H54qixASb59cC9q6fK9bWvg7AGD4+PaAfgo7TYgWgF7wRYY5sViJw1ETArmI2zk2vGtN0xq2ecvoP8QkYWtXtciXK8fi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

---------- Forwarded message ---------
From: ying chen <yc1082463@gmail.com>
Date: Tue, Mar 24, 2026 at 4:26=E2=80=AFPM
Subject: [BUG] rcu_tasks detected stalls in kcompactd during proactive
compaction
To: <linux-mm@kvack.org>, <linux-kernel@vger.org>,
<paulmck@kernel.org>, <akpm@linux-foundation.org>


Hi all,
I encountered an RCU tasks stall issue triggered by kcompactd0 on my
system.Below are the details of the incident:

Kernel Version=EF=BC=9A6.1.0-x
vm.compaction_proactiveness =3D 20
CONFIG_PREEMPT_RCU=3Dy

[Sun Mar 22 16:36:04 2026] INFO: rcu_tasks detected stalls on tasks:
[Sun Mar 22 16:36:04 2026] 00000000fcafb4d6: .. nvcsw: 622963/622963
holdout: 1 idle_cpu: -1/1
[Sun Mar 22 16:36:04 2026] task:kcompactd0      state:R running task
 stack:0         pid:1943
[Sun Mar 22 16:36:04 2026] Call Trace:
[Sun Mar 22 16:36:04 2026]  <TASK>
[Sun Mar 22 16:36:04 2026]  ? rmap_walk_anon+0x16b/0x330
[Sun Mar 22 16:36:04 2026]  ? try_to_migrate+0x96/0x110
[Sun Mar 22 16:36:04 2026]  ? try_to_unmap_one+0xd0/0xd0
[Sun Mar 22 16:36:04 2026]  ? anon_vma_ctor+0x50/0x50
[Sun Mar 22 16:36:04 2026]  ? folio_get_anon_vma+0x90/0x90
[Sun Mar 22 16:36:04 2026]  ? invalid_mkclean_vma+0x20/0x20
[Sun Mar 22 16:36:04 2026]  ? __unmap_and_move+0x21e/0x340
[Sun Mar 22 16:36:04 2026]  ? free_unref_page+0x17d/0x1f0
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? unmap_and_move+0xaa/0x4c0
[Sun Mar 22 16:36:04 2026]  ? migrate_pages+0x3a9/0x790
[Sun Mar 22 16:36:04 2026]  ? release_freepages+0xc0/0xc0
[Sun Mar 22 16:36:04 2026]  ? isolate_migratepages+0x2a0/0x2a0
[Sun Mar 22 16:36:04 2026]  ? compact_zone+0x310/0x5d0
[Sun Mar 22 16:36:04 2026]  ? proactive_compact_node+0x88/0xc0
[Sun Mar 22 16:36:04 2026]  ? kcompactd+0x365/0x3f0
[Sun Mar 22 16:36:04 2026]  ? membarrier_register_private_expedited+0xa0/0x=
a0
[Sun Mar 22 16:36:04 2026]  ? kcompactd_do_work+0x2a0/0x2a0
[Sun Mar 22 16:36:04 2026]  ? kthread+0xeb/0x120

