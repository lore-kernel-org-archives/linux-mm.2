Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B4ECAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40928E0016; Tue,  9 Sep 2025 05:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18198E0015; Tue,  9 Sep 2025 05:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55AF8E0016; Tue,  9 Sep 2025 05:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 949B68E0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:04:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C1B213AF8D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:04:17 +0000 (UTC)
X-FDA: 83869125354.22.AA1B43A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C1B5A0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:04:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=FEfgeDR9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpXa+vu5fBKULSWcWQHqLrFFROyEpt4qyTDAIt4nodE=;
	b=4EaAeevqlhwMkSSyXdnMg5zSUDfGZ2jWUQbQa/27GD0VpwbzCjI9mgsxsHOEsLuINiBIrv
	rQh5tIRcBDJ0T0fyUxkp4ltD8DDoFsCcit4IVF2YyOxwd4Mib+LYRdMH3u+asiCJWwYQU6
	QpGXoELTU3Rwnw0VWYzg6XbPNZHzfwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408655; a=rsa-sha256;
	cv=none;
	b=faCPQl54R0iuzpT5SYQ3lugXc/i2GJvdkbVFjzR8p/pOOldnr15HK8dyN7c5fIqFw2Lv5h
	BDzZg6C45cfqLyo6IxcsNHF1XSxQuqwe1Mee1Oa07oFJyRwqGGOeTjYfW13UnT64vvRPpe
	jb2eTsghc9XnqpP9tEpE2YqmeBLwnwY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=FEfgeDR9;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NpXa+vu5fBKULSWcWQHqLrFFROyEpt4qyTDAIt4nodE=; b=FEfgeDR9N3y94fqc91GS8X3CKX
	JAKsAe00a802RdsTP3D0LCjDvhpJ0uVCmfDe0Kh7wY8VRtiqWYEziNPcsQpoYyq+PjBzkVByulS3+
	2jUKwEa0JuXfuUcldWyx/kb9A4eiOEPkAY5940SKPO736tP9QyxTzS23gMm0NmEwDIFs5f5okjwLa
	tU+gRrluo4Jz15EadIcek/1ZVQ6LxoFYFa/aE5jsPV2lBHM3zQOUha0m3/Y87k8gh3fYaap5ZvWk1
	QLn6DE/5QDIjE9uYvzmHOv/SQcCN3I+wK143A/Hyd0K8+dFvY91nMO8KVottGkQzV08agpNh0MY10
	B6+GrbjA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvuGc-00000005GfE-0h0I;
	Tue, 09 Sep 2025 09:03:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A7C8F300399; Tue, 09 Sep 2025 11:03:57 +0200 (CEST)
Date: Tue, 9 Sep 2025 11:03:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, sohil.mehta@intel.com,
	baohua@kernel.org, david@redhat.com, kbingham@kernel.org,
	weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	catalin.marinas@arm.com, alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	corbet@lwn.net, xin@zytor.com, dvyukov@google.com,
	tglx@linutronix.de, scott@os.amperecomputing.com,
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
	mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com,
	leitao@debian.org, wangkefeng.wang@huawei.com, surenb@google.com,
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com,
	rppt@kernel.org, pcc@google.com, jan.kiszka@siemens.com,
	nicolas.schier@linux.dev, will@kernel.org, jhubbard@nvidia.com,
	bp@alien8.de, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
Message-ID: <20250909090357.GJ4067720@noisy.programming.kicks-ass.net>
References: <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
 <couuy2aawztipvnlmaloadkbceewcekur5qbtzktr7ovneduvf@l47rxycy65aa>
 <hw7xa2ooqeyjo5ypc5jluuyjlgyzimxtylj5sh6igyffsxtyaf@qajqp37h6v2n>
 <epbqhjyfdt3daudp2wx54jsw6d7jf6ifbr3yknlfuqptz7b4uq@73n5k6b2jrrl>
 <CA+fCnZdJckDC4AKYxLS1MLBXir4wWqNddrD0o+mY4MXt0CYhcQ@mail.gmail.com>
 <ra5s3u5ha6mveijzwkoe2437ged5k5kacs5nqvkf4o7c2lcfzd@fishogqlatjb>
 <20250909083425.GH4067720@noisy.programming.kicks-ass.net>
 <20250909084029.GI4067720@noisy.programming.kicks-ass.net>
 <xeedvhlav5rwra4pirinqcgqynth2zrixv7aknlsh2rz7lkppq@kubknviwhpfp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xeedvhlav5rwra4pirinqcgqynth2zrixv7aknlsh2rz7lkppq@kubknviwhpfp>
X-Rspamd-Queue-Id: 6C1B5A0009
X-Stat-Signature: gzagfx11uyy84my9sipmkpb3g6ttfg5h
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757408655-599238
X-HE-Meta: U2FsdGVkX1/7BDiZKL8VrqQz0Zs12/MPVU6S4u28YaS9v1CaWZCvr4dQccmmtYNBtFqh+9uKyEH71xM4d1+mGxQSwrv74DW/5mLYAKyNek9KvwChFpw510Cp/BCHG7RAc5vAohn1CDIatyptD3ncz3s/eNmejzC/AwpqKOdV21+eUDwIz/Y3lFDj+buAfillbOoT6JsxMRn1kr6Vb1fqMbYJU8SA3/t+py43lvyAuUQ4+GIQns3/SqilDHLdLf5BJwHQgWBKbbbRR9SOTyj4bPUUXMl7Veo4t97m6PWoPOxWpHefHyyvhM4rbl3fRIzmz1U9nWdIbXxnQ/CKFiRblC8AUgdsiYA0dE+2W8umHaMNx06dNU7UHVLrmzTECpKWN0KsunIC5+I7YP5PdOTLOQGH8mEXXhjt9nerdUDClPWAm+/buLd1odQ3p9x/c6Vs+nPTMcLi1sDlZQqJGVK4gKYpzXdxDPdqjIkhct+lbxfQEnAgSY/HP5/oCMY2tQiavLowPAeOQfKncv3plpdlznnXcDdoyHKX8jFIiWPa1oKLEpKOnqOp1IuUrH7+3G/rbfx+65xrslMMh2c0UbB8JtH5GS3JQKDWdsCoqA3JPKs8oaucbTis29CNDa0sxudGaoFBlTEPQbcAlzCxpxLDa/yRn3iDHXw0mLwzAZ20RDdujR8uXZJbyfiQq9NAWHCAM4mYl1+cRDChLZ0kzeE5AZTWfQnNxcL1YpPVgVL5vwCX/07MaVt73mro/4fXeLYG8fyIuwINPTyltfXlArmAdxccKaNN3Uf9r0MnxTyFnoCfyWh+RGAJX61zcdDuRFGxO6Ko5SXrSuottaB9h6Lj+ORLWr0qxXKoGrHrErCUgAeVNdRoLc+R3FoCQhKyDBG3XnNpr9gUzmEf1Fop8XPE8FdjIXk0ex/bPUrPEbXmRE/+6argcQAnbKHn2Hg8BQm/YzQvDUciCBIto+iySwx
 YkaTt85O
 O3jmaCh8RQRXBh7Sc4O9y+e2hvzewqc+PvQtPDke6g/bpSj9ZDUSBytd6r+a1qiLOYjFAylOWm78MQBxs7MBvJe5w7A8Mop4fpOsuOFFAWXnnpscvAOMpQEsXZSRVihL0c/i0Ev/yA5jg7UNonMg8Jr2zy/gD8tcw/IDdqtfwXNUxSu1JO6scSEGuezCKqcJParuF0laZqu78g3Tu6qdYa87/Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 10:49:53AM +0200, Maciej Wieczor-Retman wrote:

> >Specifically, look at arch/x86/kernel/traps.h:decode_bug(), UBSan uses
> >UD1 /0, I would suggest KASAN to use UD1 /1.
> 
> Okay, that sounds great, I'll change it in this patchset and write the LLVM
> patch later.

Thanks! Also note how UBSAN encodes an immediate in the UD1 instruction.
You can use that same to pass through your meta-data thing.

MOD=1 gives you a single byte immediate, and MOD=2 gives you 4 bytes,
eg:

  0f b9 49 xx -- ud1 xx(%rcx), %rcx

When poking at LLVM, try and convince the thing to not emit that
'operand address size prefix' byte like UBSAN does, that's just a waste
of bytes.

