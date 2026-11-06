Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13C3606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UPIJP6Q0
Received: by kanga.kvack.org (Postfix)
	id E15186B05B0; Fri,  6 Nov 2026 02:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EFB6B05B6; Fri,  6 Nov 2026 02:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E996B05B7; Fri,  6 Nov 2026 02:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3F6B6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:51:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59EA5140C99
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:51:42 +0000 (UTC)
X-FDA: 85403924844.12.4E2EB88
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6796D180007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:51:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPIJP6Q0;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8L/HnUYVSEblkQSsd0Qj26nxFzNN+cxfs3MphjQg/M=;
	b=t5gP5E6M2IYlMt1CClyBIr/HrermRWKT61TRqPrIe3VBK4ejj+ZczLPS+iF7EsO1hh84gS
	gkVHxNip0+llztqA5yOXpjqrkTmnNSsNxiVV39TJQbdY6u95X+SC06E97WRqmmkbDkmWZn
	MOM1c+YPVMh9/XF7JvUWU+X6tLWW810=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951500;
	b=S2DHhDSLU5TWOgLv+pCyPKCGKeFF/P4rki95SPjeEaaajAHkpAUVx7rbludpVGsWKmXM9Y
	Ycy4IVS+Nf08Bwqha1fpKtfDB7+hRa6XYpNYVTa0MySan7Ki4+LYr/D7WP/09iVJj2Cz42
	PO8agN2mmTo9r8uN+2IGmDfk2UJQZK8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPIJP6Q0;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A8L/HnUYVSEblkQSsd0Qj26nxFzNN+cxfs3MphjQg/M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793951497; v=1; x=1794556297;
 b=UPIJP6Q0nfXlvvfpln4wX/UfZkaGFDuF9gkUkIPdmlKEkN/imHhQCz3ox4XK08+ctE4izmGf
 DHMetZz49duJzYzwzdygnE2PamAUcsl1T1fAJvv3Fb1FBZ7jr9ga5OWjU4lI/o1eRpS4xNVVWOu
 khNo4qEaARHzv1qqESBWv7Y8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2a97fd523a3d8c6c;
	Fri, 06 Nov 2026 07:51:35 +0000
X-Mizu-Trace-ID: 2a97fd523a3d8c6c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	willy@infradead.org,
	jack@suse.cz,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	maddy@linux.ibm.com,
	npiggin@gmail.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	leon@kernel.org,
	sj@kernel.org,
	rakie.kim@sk.com,
	rientjes@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	james.clark@linaro.org,
	mhiramat@kernel.org,
	oleg@redhat.com,
	john.johansen@canonical.com,
	georgia.garcia@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	zohar@linux.ibm.com,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com,
	wufan@kernel.org,
	stephen.smalley.work@gmail.com,
	omosnacek@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org
Subject: Re: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 15:51:30 +0800
Message-ID: <20261106075130.55333-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7is39wf9naoi6s6u8ipzyy65o6ikgtn8
X-Rspamd-Queue-Id: 6796D180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793951500-870231
X-HE-Meta: U2FsdGVkX1/+WaXuc31uXkNEd94ZyQfi2adoblL3FZAzawhShQ++C8rpeVB/XVFEyEINI+EDhH92f1yppUHH/ncUWDrpWZhG71xiFDz7pNvaO11h3Ia9L3DrRWsURSGc6HwbIzQPfuQkE5mIkH8ffpH68VSZ6L4+gkrdhLATkfhU04Jy02UA15or58/nWqCQlAT0ZLkmdfKCY2DN1x35EGYtPwIt6MJ2MoIJl2jVDugRSf3aC8YolvgRAx23HlP6Tut7heOMEfBZ8v50i6VBoWow+HPz/BKJaz4pzPZ3BSzymh4LjdcOLGKyo2g1XHJxqr+XfpDXCKijpmJ4amvbsGVbL4TGeyQsWSomOtor00wc7ZeZScZ2Qc28K+HrTPPG3eVWWQCbbBxrz2kZff4niu5vxR5fRIt6Y7wiWAG8q4EV760RXQj/ceYDPCKGMJG0gnh2lf9EAnq/bsGxw9PpSlox2IcqO2q2CRuXxtKzdnjcqeLzvAbR7XkJeZxUOGikbK54VulbIwZouKKbY0pchyuj2XYs35rHeeJ9PWOvO0CVnObbZpjRGkkFJa+LLLi+rzzuU3fd5jsemhZA8GatNy11rBXxBgHDQOn+iu4kZTa2LxyaObe52mJ+gMADVWAwXlEcyFQHUP35ByQGRb6OSILQFW5GAQn+gq03SIN+J5v3jkdgtgG1UaYQoiV79JoUUIHW+sYfgYk3Ifw9Tx+HGPVDH9oyXRscULzH5mFXEgN97GW6olWJ93DbRDE5yOl0gaW+5bwU899PLPwSq37fJCoEdwEkYDPrjm2/qvK9NiMB2aDJo8Tky6bgjAxjzwMCFaq/9Jh/qVjXUcouqqV62reyGznpa2FduWq/ZJpFEMSWvgXhtkD5Go/85EKaME/b7mxYhJXaCvjJCWS0B57IYZlzjKwEuaJ4527KbZTIvZUE4Vw0A1uUfOH7T24u3MC8lP0t5doXCBXlktogfi0
 js4ZFUDa
 SOiISHNB1w3MttsFteny+Lhz+PLi6d3Z2zXmfn8E2r80giqB3JhPvYM0vIkCU8JtDhobcB8Hwjhhi7XVDc7VgJr9YU3qokv7E3evPb2nLTpVRPik4+3AFeTO2hpLFbAQoId+5o38Hxi32ZovCszYo+NfYtuLnjgp6EFoWslo9jeK92dCXtT4wu+KV0S2eZkXMQIMvow3zd+CsDASqCuAZS8I6ExKI/wO9mCRljNYIN+V0FC/EJJm5TSOAFOHSXe2VsWo3Zct7n+0f2CMxJI85YLOAM5F7C24ERMH3zZY7w314ubhWf55le3KvTBi5r/yQ+/IXkhy91fKYx+ZwuHDewu7IbZ2sk81n8GDMXAWtLOOwPE7uEG8aXtj2+Oi6Hg/9C0tO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:31:04PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

