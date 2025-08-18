Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A8ACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1278E004E; Mon, 18 Aug 2025 13:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8818E0013; Mon, 18 Aug 2025 13:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298E98E004E; Mon, 18 Aug 2025 13:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 169728E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:01:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B95501409F8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:01:57 +0000 (UTC)
X-FDA: 83790495474.18.8BEBB03
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id ECF5E4000E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:01:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=stwTv26k;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spKMQn7nIVpT0/mjP9As0UlCNDUJOgYkELPXiq5D32U=;
	b=QbMbdRPrY30ui2MnTL2A6rZfTTNX7MMgQrOosmZNEosg60pXjBFAKovJUCtA0jdjN05Eo+
	/BJlRqG9XyZnWY2uYLvk94uFTHhCJrtR+T7/h2WmNp8yi20gjbkgGiVU5QW9bU3yMrYFGv
	rQ8/OPTQ0wRxtbQwlVdR4+4U/mscLkM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=stwTv26k;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536516; a=rsa-sha256;
	cv=none;
	b=D4rftUMxScyAnETFsKD1/st5sW0ZzgDNpxW7s7dwxSTOBAO3kL7VN6l+Bggv5OA9DaZ6/7
	STWq5JfkWIBWzoduKdyoPsWx8W4E6bhEDBNCsFKc2yOmSGyw81qhU1S5RzMtFlsr6JNUDD
	gr11pLyT+uA+dvYIa1ubAaebSH2oq/I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=spKMQn7nIVpT0/mjP9As0UlCNDUJOgYkELPXiq5D32U=;
	b=stwTv26ksBnQzC/fOPKoIoZj8nFwNHuCsH2a3/p+NiLavlZyC/iWksVguM9b1cmfmHwuht
	4qxDw5kejSx5NB86vwRw7QmLxeji0zoV/T7OPU/5t5WVbx/yXBGUQMmmory7rKcWcW7Hah
	GM6PJtse+KnlXgK7IcEtdM0FKn5dcm8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 02/14] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Mon, 18 Aug 2025 10:01:24 -0700
Message-ID: <20250818170136.209169-3-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ECF5E4000E
X-Rspam-User: 
X-Stat-Signature: qahddmp4sdgsinkcnw5gsfcjjwsxtsjf
X-Rspamd-Server: rspam09
X-HE-Tag: 1755536515-715973
X-HE-Meta: U2FsdGVkX18u2joLp0EqUe6sbsv3hVZIe22GXPEg9MQJISsDerqW4Ox7uNDo2Tb7S8Rk0wfMse1QHTJEAi87rK1DbN/lOpss6rcl6QXs8bDpyvQUr0c43vlAT9F0fm2bZjdGJGWivW7KEe5HTTiVdkvuyMC0EIQVMySCxQLRAxy4zkvdUqU8pfn+oMZrqJeNSe4j3KhxcOlLpxGU03nhtvdK287AxBuN7ttIDHN0HHJ0baDcoWzVltSMqRPGTTUvaWSYVKIsne3Edu4tfYf3VOElxrNUPlqfvOVo5bVHrHbMDIQ1M3RFWbvtnBz+8aJ0Fz9L4g9i/XgERMzt3dPcvyFaDLJmNPwczIxYjXHvOhJPDDmX41KrF9S581iOw2f+HOPD5/8+osAGNZMdiMn/Je/3+39D+YKPokZRxWTvtcrB7Pqy4PoB2W5+rk/LVQwWw7rC4l6/Mhtzn8ozlxC7v/xfqcq+5J4jk+YrifjcDgLyKSIaCxZLeenl7vICQS75O27qQQZn8ySSCATFCYyBNtwm9o0+uVK4hLeWr3KP7E7j33T34HIUVloavnaW2kmA/uYLNy+YKhyR0GamB1a5HCiij5eU/1f02ftKqSTV1kGgtt8OWZkVOwR9to0ihKo5Eb/hheRhWcYf1e+m6Z6D+/zUrZi2TzXTJDlF1MTYR305JABLWP8vIsDiB8MCxW2FhFD4VJjgTG+q/v56iksl7bGigdNlfzpLgThc3Y5DoubIuN9SUxKNlO2+1Ax6c0nYtLZCNmiBmJbae79btnyPmWgbB0+Ylogn/aUOo6lk1OtrlsawFD5WD5tHHU/WOv6npCfKmx9ZuYEzphHVZJOkvLyL8htcsIe0oeJrv0MhxmVWwwcycZ06DLT79Swzr1cnmPkl5JFzRyyj2IDMT/UBVadkQ2+CxRdbtjrres3nKrI5hSsYvHS7UMOCfhO5JDrbFigObGwoy0+11bPfwxK
 VuBvwaTa
 k35qYOau9wNgvga0Z1GZVJAD7EYoD7CZILp1emm2vaEMtgm/WFU6etWSx2WM8rg3icOHk17e1Jw2PJq3O7n086VxCeqAANC5wTylXVmfL+ovb/UrZvaXh6ulCyg1Nqwm4uI+iTB/4sp3Sr8JOipSXGepvlR70vFbBJYrYQOElKO5qYPFidku7SmqxA4XQKs7JknyuKzz94S6XVppnvUGGYx3AiyCL12gJNxq+OWVfyZHjbRfKgchQYhRKvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Struct oom_control is used to describe the OOM context.
It's memcg field defines the scope of OOM: it's NULL for global
OOMs and a valid memcg pointer for memcg-scoped OOMs.
Teach bpf verifier to recognize it as trusted or NULL pointer.
It will provide the bpf OOM handler a trusted memcg pointer,
which for example is required for iterating the memcg's subtree.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 169845710c7e..b5153c843028 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7035,6 +7035,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
+	struct mem_cgroup *memcg;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7075,6 +7079,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
-- 
2.50.1


