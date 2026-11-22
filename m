Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C009F606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AG7ZMljE
Received: by kanga.kvack.org (Postfix)
	id E5F486B05D6; Sun, 22 Nov 2026 13:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E105C6B05D7; Sun, 22 Nov 2026 13:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26D46B05D8; Sun, 22 Nov 2026 13:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4E696B05D6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:51:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D2EA1C036F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:51:18 +0000 (UTC)
X-FDA: 85463647836.24.CED55F5
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19617100003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:51:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AG7ZMljE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373476;
	b=MWE/ZktFJcmdKaoGygyD3PIDjhKg7V5fvOAECzl4C6jUMXgQEiN517Tc5zex6It1tN3rSV
	VBOrQXjm3F5+7AkgBV1HByKIK9cXMdhfPUM6BvqbNpNt/FMa3U7rwubF/H67dOIylqTgBm
	4/P6cKEyex34j9lsA7WNjfZYaSwd9v4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=50wCei2ezE7qqlKPwEZQKfaQvojP+aADu/REaQZidPs=;
	b=Kr+34BuvT+zrwYYTQwrc+m4RYj4NeoC92k//wVmf+riktZaB0LXpu6EI50DnDtiXsYV6BJ
	N1yNjmYsqI/Ty4mXuH5GeyfShJzpZ4CtAJqV9wGFGqy32ek8bzAeL0AS9n7h6Z2nvPsq9J
	r65j2J3R8mJI+Q2DF+/LMO14mJ1GN60=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AG7ZMljE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CGiHf1+jeEEE2NgCdnd+kn0vFA9jhJqMPHDtP1DXzTo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795373468; v=1; x=1795978268;
 b=AG7ZMljEFcgdXpoFbhVCSP8JdoaoMScibEqrZ0bUbP6G3SjGU3ySmGbyLvS1SC2HZjB3BEGP
 SgLnws+Ya1IqxZp1bBWYnjlUuqYJPaiWWT3WLUe6tTa1roXgjX89dkKCXR5cjf8A1br11EVLexw
 3eXnjs4yCGXkKHveCoG5TIO0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 57ff06e043170ff8;
	Sun, 22 Nov 2026 18:51:07 +0000
X-Mizu-Trace-ID: 57ff06e043170ff8
X-Migadu-Flow: FLOW_OUT
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Sun, 22 Nov 2026 11:50:36 -0700
Subject: [PATCH] selftests/mm: honor VM_SELFTEST_ITEMS from the environment
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261122-vm_selftests_items_fix-v1-1-9edef5e7975d@linux.dev>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM7QqCQBCF4VuR+d2CM4RJtxKx+HG2RtJiZxNBv
 HfX+vkcOO9KhqgwuhYrRcxq+p4y+FRQ92ymB5z22SSlVMwibh694RUSLJnXhNF80MUF5rppL/V
 ZKlA+fyLy/Avf7n/btx3QpaNG27YDejFqxnoAAAA=
X-Change-ID: 20261122-vm_selftests_items_fix-f118ab78426e
To: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Tianyi Chen <hi@tychen.cc>, stable@vger.kernel.org, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mailer: b4 0.17-dev
X-Stat-Signature: f7td8mhtocjgi7jptwuftdasxf7ds7e1
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19617100003
X-HE-Tag: 1795373475-707896
X-HE-Meta: U2FsdGVkX1917/Cqsag8FHfBqqipvTEy4QvLsSS3+j3dqEuiuNmCmzXkJx6iALGhmQ0IbTGaXd2TdQGLQjpq01kevFgymgk/KgBP3EF8Nw8C0dsW+izGisClO9lcW2w4HFbbKyxoCrNyqFB+zv29y8vNw5Y/IjR00Y2J2vn7XTO4Mmpmqcyx9URdS9hBa21hD2wzKVrWvtFVVaeHHspevVg81UF73urITTA4HpDdgeva8dB+8yUFJP9x9ijzJ8iLE0zUeh8Jw154P9oHOVrv1RbdkjQUKCfnHYo3si1tfNqkkUMz2HkDnX6rhK94O6lETtrX9YWA6byitzkcdqRjVO0gm289gvNHUkkuEUJEk7Ctx1g6gOCq3pi0Rcrun2bdizH/IjsBfqfp34gBx2HZkh9apPO5ZvY92YzmGBcF42j7ZtmVJHBeIgA8ucgQCEp6j/0TFX3Jew8BxqORDsj07/PG5SdvidGFPDLpMF9Ir9oXC2+CAbiCdyFnhhZghmL+Ru6w3QuMBxoei4K28C07vduHuPKovmKt5veTDU2Cmf9GZqvKWM31XI0nMVhJKeaYjIZD6hk1+naoFv+IlvmJK82OpKTOKeRy6KGk4cLr8NGJNaGAjheerSwRqreK/NLGuX26HYCVZLBmcJ2kXQ4S7VbqRve48+x8aqxBaG92fzRO0wzssICbWdMrexYPdsoiRLHGjJ8/7d9AtrcxRWYdcb8T1EGl9eBOZzPAQDk1MGBT2S97y8W19t1GP18E9r9XfJs9TyB8kmgAElkrBaLKfOINqD2kx2f6F43VqzgBwyG9s88OS0vadQMvksGUmNM/ekNjcL4A3pgB3Jo5rqYGDe8dS+ATCHGEWtpaZ5q1AxbnzTlNzDjcCOnyYoQLW8cG/tPo+LW6JjEQAr0k2jqosqQdiM32uEvO1YpdbST4YWUs2kmEgkTI/s6IRoEiFl9XkedUH7kYWfKRepfbzb/
 Rjm7LMRD
 4bqzGl89rC3VliV1NO9qh5a1Kw5mzzAuDIKsDR4tw6+Loyh/pWlm62vpr9S8y1BwHpBhC+KNx+zQnZqkI6Zf0COvocgwiuvd5JzfzSiflYmxl/VXM+565R3eW3jjBqd50a1PQzAxcvS77f55LDoC609l/w+rFjoLFlk9ZX850XPXZ4WCF3OwKgWZScY8z6VR7lTdQ/rbGrYGh4KcWvffH7idR8F0JkqfBHy5VPksK/SNvJbJAle3QBkcdkY4fAgbb3ognFQGmcsboDkC7T3xsETHnmJt1wp9yVronJoy09GCaeoSfYKIuDnlag58+YyAVJoMsvj2AMVKA2vcocxsjKAsC7eLZtJsygrleLiThc/p8xY5hyJ2NzSo3jU8vEEYFU7+OZTXGBjhrXth9VEeu2WnMPUCSxj1pHjMQNxsv/vcuYqNhepvsAvbnY5OolBnEpiL73UE7yjrMG5LdG62Rn2aq34BoonfTJpcxD0yxuvz7UGLv7AJOubwS+m9N8hWFwtBTo2AR4FgGgDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The unconditional default assignment overwrites VM_SELFTEST_ITEMS from
the environment. This regresses environments that use the variable to
select test groups: without -t, all default test categories run instead
of the requested groups. The -t option continues to override it.

Fixes: 4844f5b84a8e ("selftests/mm: reject invalid test selections before running tests")
Cc: stable@vger.kernel.org
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedae..aa63f840cf60 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -102,7 +102,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-VM_SELFTEST_ITEMS="default"
+: "${VM_SELFTEST_ITEMS:=default}"
 
 while getopts "aht:nd" OPT; do
 	case ${OPT} in

---
base-commit: 2dc60bd9975fc8666a13d58410499e06e6799ba9
change-id: 20261122-vm_selftests_items_fix-f118ab78426e

Best regards,
--  
Nico Pache (Red Hat) <nico.pache@linux.dev>


