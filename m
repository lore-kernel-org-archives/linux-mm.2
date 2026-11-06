Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8725606A339
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hUWosO7V
Received: by kanga.kvack.org (Postfix)
	id B86386B05B0; Fri,  6 Nov 2026 02:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B556A6B05B1; Fri,  6 Nov 2026 02:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20ED6B05B2; Fri,  6 Nov 2026 02:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EACE6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:12:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FAA51C47BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:15 +0000 (UTC)
X-FDA: 85403825430.09.DFDFC18
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB88080004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:12:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUWosO7V;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tr7RAK1Z1e7MRIJGh8p+CCxNaKqEt5LEou42TFWdC0=;
	b=H7z98pzAvqUyhSDa7+CI9Omkrhnj8JRlExEbgzYYoPS/W5LYfj+QSFuCYHZWQP+5nk1XS6
	hthWde1KvBxeZwW89A5Z3Atl81poiMe6Hx0ogMWpwoh6K4zSoSyiV7RE67yKb63uUkISQS
	NO9gB7qTUsRiMtFYwkWqyXMFkk2Owy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949133;
	b=TCR1WTFOwpnFaliXbaIUVMxjDJXmWAN538CdDIdbSdjPI6/MWOFhvXVHjJEl300vewumIH
	Ukn3D545HRC1q8/Dx9Ipzg8h5rqJLJraMhUM1Q6KBQX80QK+Ji8y4mDz9cttH9/v5zd1PU
	yDlfKLwYmHY/OC15bc3muPutY9sVcks=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUWosO7V;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2tr7RAK1Z1e7MRIJGh8p+CCxNaKqEt5LEou42TFWdC0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793949131; v=1; x=1794553931;
 b=hUWosO7VT/rCOyObOqACqZsQEy19bkG1P26xbOjYFvsoQbtiwvyMiwrnRjaYlwh2wYqYwpjv
 JV3qhCrQks7lpYRfunnGdRIINQ495SS2MPPRiaWzoE+0ql6RTPU1MCiu8zryk/gZqLRS6y3XZJw
 Uv4Ngz0djRsmju7g3j2Zqqw0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 007461dbe1b04954;
	Fri, 06 Nov 2026 07:12:09 +0000
X-Mizu-Trace-ID: 007461dbe1b04954
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
Subject: Re: [PATCH 11/13] uprobes: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 15:12:00 +0800
Message-ID: <20261106071200.52897-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-11-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-11-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: so8tp9hc1exxa7hijc1raapjrznog3k3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EB88080004
X-Rspam-User: 
X-HE-Tag: 1793949132-91856
X-HE-Meta: U2FsdGVkX18j8PijPmaTYzOHX5bTqfcYLCZbXjD5+0qrtRpLA4Z90SpBZ4lz3mrHtzlBj0ORrc6HG+QROGMnrmf7YeSeJL3c+EDxctrbNWO2LktAsqujsafcPDOi7v2p49nilWb0mLZxG5PHgC296NxMh1b8jSLvN2+N87YvMqWa5uurrTW0Y/ABjPrLpP4lD2Xb20yWCzP/paxWpPNg517xWj7YsTVqR8tbRy7O3yTsxOhJi2K1yQGs7QeRvfYuTsj3v0gLuryD4n01dWIxb7T0tDdZUpjytWwW0HZf+Z/HIQ2riTYF+oxSneotlipdT2ISLRp9E54o5xTQlyHtpcI8QW58v9OvEawimsnrdT2QcaxW80ucFd6+DKtNdxFGYlrK3zW1JUjYZCuL3MKjUCtaeC65vv8SxbEqW+dURFdloAujJ9akJBKFGUBOwloucL6dqo/Sg67mrjEnjNT3kbycwyFnbpLc9DGtIkv9KwuGpuAryaKSXra69sLbomxdNCrzGfGnKiIh48B9PWErkJQqkgkUnpdDqtPkSzduAXNeVLGoFLv/4xWmZZBD/TgHOEaP5sl1ru8XMCmrrTLhoHYjgPyQRtX7kf6CFrnMGf6vqWgdnqNzBbh3vQ290qgntP+PSW7Ah8HnuXs5dWhHTYKnMDg0hdvHMz3CVlBjgvw3KAk9Ub0KGh29yREzFv85YvMLHcQDdls05f4hI7tHCB+9wm6CMxB5xma4JmaSZRi09a1AnMKCdKx2HGR3K7GGUqj+XqoCxvSoYmi3D5/NEDk1rttu5rFiPuv+xFUB6VTFmPs0sD/N7NwUJu9QSEMOe1Uzou2iWwgA7mvFR24RUEfD6YA8pTXeBGMC5fXE6MGJYh/lC2X8eO72EsagdqBwVnPTAfB9Ko27Mui7CkhrMS6tLfR0+tnfMQDH/vHXPW7p+zRTVQEn5y51TTjealAOZQg6kyTxM19AsIj5A8f
 q/fnI9z+
 sSt6lecoXRyINlSLak4lFeN7Zev5sOTNmgcfLCI59I4tvZCLFBsxHTTu14rj3I1ahge2zWptjOQBXCrdqjuqeHS6ielXXQv3d1VPrSNibmTdu+2mytmiZNuJQqPYDDXIk/0grcmEOpG9fC9gdjBD0zYTi8KFLRJ47YBfPcMlvTWJTnkX7lK/kz4rAVNLRokpC4QIIRnLGfMmjdNVq42VvkIH3MW1pkn5e9srYRRwi4Uittc3SKsZ4cHvos+aoETWjjLuoVqf2l2GePFWdqr3Esc5N/Pf2KG8UxNKzm6uWbPsqnPJ3zRHrWGZIy2QVIZ2SAtt9+pcQ/JXi8bLUKJuXLvSs7WdByYGPQ7OyFfDQbij8IfbxcCdchGg1M3HeNOh8FIpm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:31:02PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
>uprobes VMA validity checks.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

