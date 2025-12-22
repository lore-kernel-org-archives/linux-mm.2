Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A08E6B257
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733B26B008C; Mon, 22 Dec 2025 17:18:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3826B0092; Mon, 22 Dec 2025 17:18:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539016B0093; Mon, 22 Dec 2025 17:18:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF246B008C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:18:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BD20B8F5E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:15 +0000 (UTC)
X-FDA: 84248521350.19.C811979
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FEA6180005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5aeOZBV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441893; a=rsa-sha256;
	cv=none;
	b=17w/M//PSyHBsjpXpDywJackV/npSRyjxVHCsp231fXrIHtz+uGXJ6Nf4wOU+aOW9Vz8Yx
	CYOqUvK0gSCjck6x4ahNPh3UPx6kYxsRoDp+4VG8VSZrvy2UVadUhoYqQq9urKy/gg6Sd5
	44Yj3lwBY5bEzph51H5iRhZsf3N92KA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5aeOZBV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1GnAwrKnomf1xfbS9Wxii7iuVLuWoO/88OS8fu1I/I=;
	b=Xk6fDxveob0+K1Fm/XQYsPEAStnFZ8BGu2ccSiwbLg4t19rXemUmfs7qAtuir8KxMQqWo9
	6GMWIEuH3n2jhfKU8eCcaMRQhgVXcd99gUTyb+Sea5NZ/8X366UMPAH9SCzL+EKsEgJCGn
	jvz+8+9VfxmIoaxrq8RirtEVhSoRnF0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766441892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1GnAwrKnomf1xfbS9Wxii7iuVLuWoO/88OS8fu1I/I=;
	b=w5aeOZBV1ksO7V2W3ZBnV/+2HfXWaG53vmwIToGN7i2BQGf0Y4j8OBWnHWjJZIH+fXyAqJ
	bJaC4a4vVVsU2oMBtNmh+nFVtflQanwLrilDAqZzM0TXY4ZazryF1NETo3Ue/XnRsHcbx9
	yYylTY3f/2Lnc6UwDq/G+07Xf7Btjo4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 3/6] mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
Date: Mon, 22 Dec 2025 14:17:51 -0800
Message-ID: <20251222221754.186191-4-roman.gushchin@linux.dev>
In-Reply-To: <20251222221754.186191-1-roman.gushchin@linux.dev>
References: <20251222221754.186191-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FEA6180005
X-Stat-Signature: iwpasntpfcc5hm5inubx8k4fifhtou34
X-Rspam-User: 
X-HE-Tag: 1766441893-791988
X-HE-Meta: U2FsdGVkX1/CvniYYrf5Vi8tA15Ginsi01QAHT0rjkacM5gGd/eH8aXiO0I2Vlne8cCU6hvU1gAF4Z8ObMTtLTtOpYlAOHIjQqOgQKlR/bAA/CV8v/yquwWMDBn5iTGDn3g8JHfasge7Hr6nRFf8pBJ4aselODD9Ap5U8/Q8lijbKzFFXswwdDLQOdXGtFg4HdEFrYP/KDCyUkrLEeIBRBtdH6d43Q7FpLImrNvpck7slcuqCTxbxUJ92var+RpMhIE+ySNT3j0Jy75VnY5M/rOSwY0hwBuAcOaSz969nJ9w2LNK6z71UJkPz/qDJusbHw2XP48pVAQn+MiSAbXZkcHTVicdh+wr+NfCdVNxiJhVHPq2eboy0KQBT2V8XOgMamQXxFA3r7/6sEOXlt6uy2hueoxra4CjVSXbwcARFJ4Ve2HwJ2Ku9sdNMwMnlXTsSF4aYZI1yil3PFv9Xqdc0c4wR/F6PLWu3UpgffIvyQXVQd8dOmBIpI4R8EvDArEwEV9i/gTCLx5cAxEQkfXYgQRHVvFWnFosz0xStbE8e+KIXB+aD2tns28NHehjqfZ7ljgfy/eqxQVBtdagHUU0iMtWDI2J48NayiNc/bnnP5Jcgz54mLn5IAIVBHnTwORy2jNJU3FkvpB0UEGyIh6taqm+vhEghjWatavN3Qca99ki6odNiMtGXUtxTphqnADkQNK+IoUus318xMUDk7AZVQr2eKI2Fcoatoq/giu/Ij7BhddPscN2O3AFLCwqs4m1K5qmrUeeENQvGTR93/Mq7+h4sGcRhtizLRnDQ9wiFiPnpuNA9xVZ1p5dxmYfQwXz5W5hxEr449qsKjx7XDBik/dwo0wu3aAL8bqGGOa9mAXjF8pBHOHTcbVCWKUS5QoVisAy8mo+tvJVh4RnDajurtD7ZBDnwE74Pv13FLRylmdoLSuIA4FqJC3oY7/Is4iD5agYgg6LetkVypWRR1X
 5SMA+xs6
 OlTbAKeRkLo3vm/wcMNnWHP6zjgSSfK5NlFOiUFrMrlqBG/8HsYu4cIRmd4CB98tV6jpwdYiXdL8lY7lyNgXBBscTH6fKQBWiaMRYdLXARhoHATj0Ep01rRhRk9XPfcFv0Gt2ehEH/lBmbYVKxCT2jlSOBhwAkMFiF9IZFPiEm1hOCtOu41Sd8ZIDKBq6pybhQSquqFQLdfDb2lOvPoQIZdwH5iKiXuF++dnoK36timLLbXQXZCaZcc/I/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a BPF kfunc to get a trusted pointer to the root memory
cgroup. It's very handy to traverse the full memcg tree, e.g.
for handling a system-wide OOM.

It's possible to obtain this pointer by traversing the memcg tree
up from any known memcg, but it's sub-optimal and makes BPF programs
more complex and less efficient.

bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
however in reality it's not necessary to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 82eb95de77b7..187919eb2fe2 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,25 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ *
+ * Return: A pointer to the root memory cgroup.
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
-- 
2.52.0


