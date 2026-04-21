Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9F5F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9586B0089; Tue, 21 Apr 2026 12:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A006B008A; Tue, 21 Apr 2026 12:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFACB6B008C; Tue, 21 Apr 2026 12:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEC6A6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D2C5BE73C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:55:13 +0000 (UTC)
X-FDA: 84683163306.25.CF8C9B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A82D140004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:55:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OkKMAKTL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776790511; a=rsa-sha256;
	cv=none;
	b=15y/N8kXXl7zSvboYL4xOzbKmhg6rV2jJwimyucLohMhAGpVLYvcp0mfrxfCahKZ0FlUvU
	lDH/HmZ5zpBrDY+CIcj2eT5gnavCFdCRdGrlONZSBVv+pxRRVPA/aAt37F+d/UvIxHWFpp
	c8xxL+TGoh1HQDCHmQ3gZXleH2q2bis=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OkKMAKTL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776790511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pB0pdigc2ct9Sagaut5/YJQrQFTq+l4gh/sJ1DFYVQ0=;
	b=dCcr6r6Z1Ady1OhTrHh2p32JIXSDmhgDgbrbzeLlgkirDsI3F0oODiy9+wPaExD6ymNN8R
	d1xrtBEUxdiVXCPmGEPOSSS9yJyvAMZFoKOMBpxP5A+NViNNv3yNDU+Zs1l1qFlMqUAUJF
	/lsy2ODIsOgknnfxw8iWTecHKKf8QTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 435E541870;
	Tue, 21 Apr 2026 16:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA468C2BCB6;
	Tue, 21 Apr 2026 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776790510;
	bh=rC+pyjU2yTuTjyO+bqTQtq5LAqMehjWCZQKRpDlj5Ag=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OkKMAKTLB541h9NNZbDML9uix/g4liWjDNKH8oFS8keYGZeRBwbuR1ZVxF+uQP7E2
	 CzKgI2Izx/Knz9u/iZxgrsD4b1WV5zs0PqPqG2Gy5CfR89Z2rFf+g5NLoEdp1jGJKR
	 cGhQ9unaqCHIg6aJ7IUKEjk51iOGcZdRTOvUOSTiK+6D5AqyUKYXLRvNaguPbhT8wH
	 g1dQq9r0B4wfuGDSB7RxU6jIirRBvAgNEgKEuw1CYLyvWyFna1XPeoYZC2Vo3GORcp
	 NsI5r1J5wTgMopkpzCA1VJOHvPWvaF/vrlaB3vPBPRJBfqD+56QXQpayELto0GZFLo
	 qQSX66nTfYksQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFENO-0000000DUic-2e3O;
	Tue, 21 Apr 2026 16:55:06 +0000
Date: Tue, 21 Apr 2026 17:55:05 +0100
Message-ID: <86fr4o1ceu.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>,
	"linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net"
	<corbet@lwn.net>,
	"oupton@kernel.org"
	<oupton@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com"
	<yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org"
	<willy@infradead.org>,
	"akpm@linux-foundation.org"
	<akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net"
	<daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com"
	<eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org"
	<kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org"
	<jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com"
	<jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"riel@surriel.com"
	<riel@surriel.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"coxu@redhat.com"
	<coxu@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>,
	"ajones@ventanamicro.com"
	<ajones@ventanamicro.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>,
	"prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
	"mlevitsk@redhat.com"
	<mlevitsk@redhat.com>,
	"jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"dev.jain@arm.com"
	<dev.jain@arm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"palmer@dabbelt.com"
	<palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com"
	<thuth@redhat.com>,
	"yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>,
	"Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>,
	"urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>,
	"lenb@kernel.org"
	<lenb@kernel.org>,
	"pavel@kernel.org" <pavel@kernel.org>,
	"rafael@kernel.org"
	<rafael@kernel.org>,
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"jackmanb@google.com"
	<jackmanb@google.com>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Itazuri, Takahiro"
	<itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 09/16] KVM: arm64: define kvm_arch_gmem_supports_no_direct_map()
In-Reply-To: <20260410151746.61150-10-kalyazin@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
	<20260410151746.61150-10-kalyazin@amazon.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kalyazin@amazon.co.uk, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel@xen0n.name, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, loongarch@lists.linux.dev, linux-pm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, seanjc@google.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org, willy@infradead.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux
 .dev, ed
 dyz87@gmail.com, song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, jannh@google.com, pfalcato@suse.de, skhan@linuxfoundation.org, riel@surriel.com, ryan.roberts@arm.com, jgross@suse.com, yu-cheng.yu@intel.com, kas@kernel.org, coxu@redhat.com, ackerleytng@google.com, yosry@kernel.org, ajones@ventanamicro.com, maobibo@loongson.cn, tabba@google.com, prsampat@amd.com, wu.fei9@sanechips.com.cn, mlevitsk@redhat.com, jmattson@google.com, jthoughton@google.com, agordeev@linux.ibm.com, alex@ghiti.fr, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, chenhuacai@kernel.org, baolu.lu@linux.intel.com, dev.jain@arm.com, gor@linux.ibm.com, hca@linux.ibm.com, palmer@dabbelt.com, pjw@kernel.org, shijie@os.amperecomputing.com, svens@linux.ibm.com, thuth@redhat.com, yang@os.amperecomputing.com, Liam.Howlett@oracle.com, urezki@gmail.com, zhengqi.arch@
 bytedanc
 e.com, gerald.schaefer@linux.ibm.com, jiayuan.chen@shopee.com, lenb@kernel.org, pavel@kernel.org, rafael@kernel.org, yangyicong@hisilicon.com, vannapurve@google.com, jackmanb@google.com, patrick.roy@linux.dev, jackabt@amazon.co.uk, itazur@amazon.co.uk, derekmn@amazon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Queue-Id: 8A82D140004
X-Rspamd-Server: rspam12
X-Stat-Signature: djqype9y5617qyfcthzipjy8n5qip58j
X-Rspam-User: 
X-HE-Tag: 1776790511-124381
X-HE-Meta: U2FsdGVkX1+OUDN8/W+o9X4c2fB+oyWAw7jDukOiuksTec9be4dLzTeeJFmw/9roUQ2pJiWAoKhIlvcOMApqIDKj96hN/94kVQac8UW+mA9vg8X9l5bnu9CMdNB8um8MW3Mu+ky7UnyMGry9dfP7vYokiuU+iKTRHqPgKqGHt2fAfH5RWSmugtDMCGQN+U3ZZ36e6XNeijotKeDSqPBX+E6ILBG2K9KzWo3lAhouHhNsw33+oaBeCE+fhwTxV9loDjztAEPcopg7cDc8znc0UxoLD78AVp4nnv0Ze5ODnqH8/iyDE/+gwX/IK4x66+RrSjwAtf8+Xkkf+WTx7gs8ePgS+TRyyVdO/VhB8mX7ipFCQdxzw4MSOmJNESzilF44dS/xB4ichiNHtTBUwtv/arG5SqmS+4/DXS/OR3r9f3k+rczzIoxiS15RvZEbwfNgzcEt0AHAMVcFQTs5w1INFdkKHw0JnPzJxGEpPQnxMZUmERuNUvyAoOaj/WL8peTf9GvZoxcE6lF/Ers0yZEVWLihdf238RtfUbCS+dCgnLW7mW32tKSM3vyxYikf8CNjz8nUDFQ1WIobmL3wsQK7UZEhs6t6XGcZkCuLdWiyXE866h7nSF9l7bpYRXSKYTF9u6NLyqpMAIz481Vky9d70R+OQ3lOQz/zz2JXM/uU7+WjmBdcKcW+nfsgH5d3vGT7U0rLQWZyVRWGyqHcTqn2bwnVw/bGbCZ6Yj860e9e675pb/VliV26gjue8xZGWNf+XDCnb45CBlLD3zOOeSO2oURBJ8amZyONApd8SvE9IQzbElY4XWG7zYwnz/E6VLI+kW4o7NsgVBJ1PIXvbr8qdQMKLl1gxVe/AG10imQVoAJAGpgT+nJOLmOvHRUieodKtYp4s/zUcPsUAldLC8HR0LSNzVcZzqkYoJ4uJRZ0TSUBJEEYrdS/eRwItKEp+sU8ylqknG2I6NP2OkNXlJ/
 q2huzeyZ
 Uv0+HfLV+T8nfnXqLo6DQlrUWYVOLwVOF39QeozW4xm/dAQOaB0t9cq3oHGy+5T4vXeE+BKNvUnW0UT2QDWsFxqf/AZCZvBr7MykCqGV+P2h1H8MfAw+HKzuPa4t/Ou7LVdc5AkwU8awTNgy8GL+7tEZuWFLSeiFBB5/l1C9dFkO5PLhlAf8cVQAHR4EtSzJsvshnfrNzWng1BxTnKMueVHWKOK+oc+9/BkHRH0NEOc+xtY653kR/ZE3HJ6CGcgWvK8KLwXFeXSDOx7LQz79OLcePiiPis5u9kwA3PG8x+ABfyBSvXeA661Hf5K+4w1/iR1p3YQWCZMLcVKJA9DVHIJkqU81JNoCa0y/q4zPE5oqTSZn+42/v/MZvZnepGhkWyb8WbcOMxJKpWB9Vjb3GKBiL/SHc981iLt9CQ2UXBZz5LvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 16:19:24 +0100,
"Kalyazin, Nikita" <kalyazin@amazon.co.uk> wrote:
> 
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Support for GUEST_MEMFD_FLAG_NO_DIRECT_MAP on arm64 depends on 1) direct
> map manipulations at 4k granularity being possible, and 2) FEAT_S2FWB.
> 
> 1) is met whenever the direct map is set up at 4k granularity (e.g. not
>  with huge/gigantic pages) at boottime, as due to ARM's
> break-before-make semantics, breaking huge mappings into 4k mappings in
> the direct map is not possible (BBM would require temporary invalidation
> of the entire huge mapping, even if only a 4k subrange should be zapped,
> which will probably crash the kernel). However, the current default for
> rodata_full is true, which forces a 4k direct map.

Where is this 4kB requirement enforced? Or is it that you means
"PAGE_SIZE"?

> 
> 2) is required to allow KVM to elide cache coherency operations when
> installing stage 2 page tables, which require the direct map to be
> entry for the newly mapped memory to be present (which it will not be,
> as guest_memfd would have removed direct map entries in
> kvm_gmem_get_pfn()).
> 
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 70cb9cfd760a..fbdd43e7e94e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>  #include <linux/maple_tree.h>
>  #include <linux/percpu.h>
>  #include <linux/psci.h>
> +#include <linux/set_memory.h>
>  #include <asm/arch_gicv3.h>
>  #include <asm/barrier.h>
>  #include <asm/cpufeature.h>
> @@ -1682,6 +1683,18 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
>  									\
>  		p;							\
>  	})
> +#ifdef CONFIG_KVM_GUEST_MEMFD

KVM/arm64 has:

        select KVM_GUEST_MEMFD

> +static inline bool kvm_arch_gmem_supports_no_direct_map(struct kvm *kvm)
> +{
> +	/*
> +	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),
> +	 * as it calls dcache_clean_inval_poc().
> +	 */
> +	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
> +}
> +#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_direct_map
> +#endif /* CONFIG_KVM_GUEST_MEMFD */

Why is it an inline function? Given that it takes a kvm parameter,
I fully expect that you'll have to evaluate this at some point.

But since struct kvm cannot be dereferenced in asm/kvm_host.h, it will
have to move. How about doing it right now?

	M.

-- 
Without deviation from the norm, progress is not possible.

