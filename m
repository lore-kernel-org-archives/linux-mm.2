Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC27010D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353426B0095; Mon, 30 Mar 2026 07:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A8B6B0098; Mon, 30 Mar 2026 07:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240686B009E; Mon, 30 Mar 2026 07:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12AD46B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7CA7C29FC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:50 +0000 (UTC)
X-FDA: 84602547540.22.881850D
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id F265F1C0006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:44:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mJ5U9rVV;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mJ5U9rVV;
	spf=pass (imf18.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871089; a=rsa-sha256;
	cv=none;
	b=sWWABkicliV1cDCMpkDMm8o1EYqj7NgUaKgIJ7F4YouoomStBdYgu9j6w4Qu32GO6uaPac
	Hkbyc6LAIsFqtQaFGNGaSy9GqCKh8ptyE6a4aDGQkgLzjxrxlITEbB9C8CH6d6gGZRuQ8L
	BEIP1TOLM1D1pc+u9/bAGKlkL3Ndp9I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzzaOpPhZbZN55mNe4Js19w6I5yLbDcoIKbm6OR7/GM=;
	b=d+pqkX/b98EWjRnvGB2qTV4cf72HONEcoxjqgmNaMAx6NA5fcia3fvi2XwY3MkMOOn8igG
	KBkOTeaB0fs0PCJkTiKHMuf/81wWrFhLIChctOk16JukEPTyLWxbNjnckP0LRDLhjWsqXM
	JO4Ao4IY0T2Y77aMOP0HizgBTrJjGlA=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12a693cdf29so4109486c88.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871088; x=1775475888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzzaOpPhZbZN55mNe4Js19w6I5yLbDcoIKbm6OR7/GM=;
        b=mJ5U9rVVVYaD10L2IFvG1oiWqz+hLFYL+b+TJCgNmqDCpQ1X2mGyFibyA2W6EUtRYX
         IHh1fG+nlH+KqGQR8ZHlx2kGEgvxgKpzrY+LDvjziuAeuePRJ2xMRcmFEUj12EA4/UA5
         /Mi7CGu6zFfLcylmCm5m0VGuARK5wtilNbp+9XeUHl+lgdSyTayjutf0ZLaYy1bEj/H3
         GgN2kJ3ggrJMys/Ux5gNis7XISXCnoVxr88a8ogk4WSfSm3My3jcxMwZ0cw8Yh1wt0+4
         i5VjQJOWyjJhGFQGO2CVR4pQhJOLF4XXdvPpWJE/6Gr6uLg15l+S7UQ0oOKJEot4fH9L
         bQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871088; x=1775475888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IzzaOpPhZbZN55mNe4Js19w6I5yLbDcoIKbm6OR7/GM=;
        b=Nwh5qSEtDRLvD9EsaZqHeDL4aCHq0erVajYUb7JTfN8LCKUQeYJcjAfyDBmjKubIDW
         coR+OEdgJv8I7RcNZyAzZ3wQ+/l9U2RTucbCzU7IclTtXC0JCt80vUKsdl8Rd4upmql5
         D45/dK4DV7deDl2FkTWyPWKNVKpdHACKZ2tpykPV2iAuN5+JsqyN0MxuRtgYn4dt/xt6
         GdFSUhh5fQthyJWEMvNA5LrTGKkSnf4SspmNLjP+pJ2vcxslIrjIj8ut6H8sXbeWlkVm
         CyM3JMSTH+OMs0BJ23RdgKAc2lQ2fg85iADEbvq9ER2uzvQIIy/fnQ3DJg49rGVcE+uV
         zY0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1VAB6iJwFn/pxuaXk6UaB1cj9yJ5ur1ZVa97gBgpMqd5RaoFw5aXq8nwayX/Im5uw65bCJrL+sg==@kvack.org
X-Gm-Message-State: AOJu0YyLQrYdfhzbJM06qewztgzSynPS505z/JjfTz6PMPWZzif+uYdW
	kctu0CwBFBmstIUVFAbKsrLejAbU5Clrho5V7T2fPg4KXG4WDLdTDik/
X-Gm-Gg: ATEYQzxMDW+klDh/z5PJ0dpj1rX3Bgm1oZA6JRYZhZnCXXnvY29K3+OKuQPJVgKvewZ
	AfQDR18gRjRirz0AKfeJ+fhzCluU2tfH1ss4KhOlLGYjmlOriKlXjTN8YpVqo5XHj0rWyPLU9Uv
	ESdcydqLILW8BUwO2sUOHFFPLYeZNzBkCYRXDZV3ptuztS2yYnXN2k/vW9ljEYeNe2s62eDwyl0
	jaY+XlvbNd/nzrbe1EavnzqGugydBeLkQIsZhyQ6Tp29N4F70ImYGgu/HwIjtJB4xjMT4GaeGm/
	sHav88nuQkvoiAGeX8bbdPFdgJc+/7OjS+flf5Cndkab3F7SdQm+OGb2rBlsr2oDeQBgFClQO4s
	uhCeERbBlBnhNOOvJAA1mnyV+zbJG1mZ9/hmL0w6twi3DjzmtceWkO3x/H0Z8J0WcIcHSMjeJNB
	4IVMhdBkkqSqwOWqdxmNZ51f7Wxv1vghBxGEW41aIp8FCoEg==
X-Received: by 2002:a05:7022:238d:b0:12a:68cc:3ee4 with SMTP id a92af1059eb24-12aaba5a813mr7281333c88.0.1774871087497;
        Mon, 30 Mar 2026 04:44:47 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c7971d97sm7227739eec.30.2026.03.30.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:44:47 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 02/15] sched/isolation: Introduce housekeeping notifier infrastructure
Date: Mon, 30 Mar 2026 19:44:17 +0800
Message-ID: <20260330114417.102812-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325135821.GA3738786@noisy.programming.kicks-ass.net>
References: <20260325135821.GA3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F265F1C0006
X-Stat-Signature: 7ypy8a5o3uoaeakpzhjowy4rrc65gma1
X-Rspam-User: 
X-HE-Tag: 1774871088-713709
X-HE-Meta: U2FsdGVkX1/tOgXV08QC+TQXtBsmzgKV79aMylR4bsBTPWpNfGGyvKAzjFgIy++Fhvce/UBxRnW4PScQq8DZjS4JkwkNOxHkbIXaNnXDocfw6EG8HJmgV+nB5lGAYOVSHu0Wu9gFUcPbFeO8wUQ5lYbqSYBc00TrzMEz28ISRWqS4Sv0Ze/hfld3QNUMHWmhPkcUUtNA//km2AH3A39km2kjxgFHF7G3XLpbn2fPxD2kgDQufMQyBLGAcAawadUw/D2nsCF7gjct6eJRFVJCKDFC7/FRQrb+ZClQyAspj9I6YKffaQIfETuqMSr7Hk3XNxGcRMqVtVLGH1aN/ZhNx5Veh1SvZC9Pcovpc8YBdneV2DllURm5D0JkcXhCsOnfPzmgas+Y+RdUyKS/5UGCjjvfSQ2ALAhCoTrMC1r9dqI2uhUyD7HwjrpJ4btl9acyT39sRrrGIjfiyjzGAnn7piu4gsSCBgtT3ddKH+Nx1afj2BHno4nlVBDXF/9Gx2WrBJ20+pC0xa8JZ/7psIKQS8N5+keqLvJ3up8bdJuLMlpMnK+iT3MzwYbxIf7bvi27FsDfaAdp/LgeitDBn+3aZZTJdQxp6PJ7rC/0eV84/ft4SFq5ywQQL2OZPW7+D7DfamKomU0EGZeOws4Oh4HsgZD77wWmMFBz9NogrmutUdApL55dcl6gelOaso8QQ/4hcGd8/MnrPyTmtQcV0TsouzM1K3gPK9R7XEbKkiYuBfZyOVM7DBN6h9OC8cpM83n602FQSvIDN/lJMkmjX355i8WN4hNbS5Mh5hTh6TtWmw4j7/OgqhaqUtNT6TndHawQ9iR0Wq0Hto97eo7hp4cpuMsvtwebU+kfCWPM9eqlBSioKhYHCNuAQDPM8oCd2oDt0vm95YA0owRvwIUJqxTBVscA1the/SWpf0xAVrGopTdqVGR2pQzUIH4ZAS1nLNreGpVH7FMOS8rFrgc2A1x
 JOqP6GEP
 IZ8pRTaacXsY+2RRr5sIfgbOQ2rn0Mit/PlR5T0Lm5+E19IM0+FAmkRG711hmZy/4cW0buyTNqBLWHB5drZXl1FcqvgkO48lRb+QNZ3Od3bQ/gWyejwahsWqBEF1J7seltArfpQiSLb1vAsaVv8g5AsZRCgGKuG0WSdYjHHao3Nvi8WtNdzwxLWijymh2ikNwMTuak3vBEu1sNhqipZYHLTBgtR8cxmhGFXrVNbz3Yw+HO61maK7xMxXZNhCMC3AWcgfJl7zHHOt/eR4Stqb/Z6TqA8ISLDdotS3RjFbr5BLozIUSZ4NtFMjfHk/LQpHN4hsygpTjTUP85J/TT39otC/UsY6VivfbEdwl6c0u1mvzTcBp7+gNSNoX/WlFtnW0ytHFT0NB6M4j1j1KOMN75yKAsH4D4obzKfCaspef2pYuX7GasE+AkyX2ttHgav2qR94Gig4Ktrf4qEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 01:58:21PM +0100, Peter Zijlstra wrote:
> Drop the DHEI name, it makes no sense.

Fair enough. The acronym is indeed obscure. I will drop "DHEI" in V13 
and rename the features to "Dynamic Housekeeping Management" to 
better reflect their purpose.

