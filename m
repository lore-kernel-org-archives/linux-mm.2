Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640ED606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B84F6B05B3; Wed, 28 Oct 2026 04:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EFA6B05B4; Wed, 28 Oct 2026 04:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC586B05B5; Wed, 28 Oct 2026 04:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8CF6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:07:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1097C0BDA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:07:37 +0000 (UTC)
X-FDA: 85371305754.30.5FA370B
Received: from mailsc.amlogic.com (unknown [64.106.246.77])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A26A1A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:07:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793174856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=h+iT6wmE4ByXBF7sQha5D04NNu/JKAHodJVSAbVAhYQ=;
	b=kSCliL72NvF86rdmLRZEpyI9ab9N18EkaIrc4kgHN+IR9pd/lk07c8M5JI7qWLzYZwUQxA
	S888uWy63BeXLrDQCaF3AqfQ1svJsPB7GuYCd600PNtViI+92AkytXpw7IVkrv5kSXCL+J
	vjfUYcQWJwBGnUp+GsLOqGPWKGcRk7M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793174856;
	b=CX9Ix09rg19hM34FP6rIaXaaAWhxBo0XwsSGNqGyPCpx7wHzgesEB1W5IFsJN1m8vbfsVo
	qdNUE75gMosEh/Nu3kQHAKREARB+CSd+vVN6KcsnJRbIRjyvsq10rKH5DwR52AtxNCYF1s
	fJ0AI3ukv4DqLbWZF9HmjMq1NcS1hCo=
Received: from XA202100-0024.amlogic.com (10.88.19.246) by mailsc.amlogic.com
 (10.8.11.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Wed, 28 Oct
 2026 01:07:32 -0700
From: yao zhang1 <yao.zhang1@amlogic.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
	<linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
	<ebpqwerty472123@gmail.com>, <paul@paul-moore.com>,
	<stephen.smalley.work@gmail.com>, <yao.zhang1@amlogic.com>
Subject: [PATCH 5.15.y] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Wed, 28 Oct 2026 16:07:18 +0800
Message-ID: <20261028080719.1821-1-yao.zhang1@amlogic.com>
X-Mailer: git-send-email 2.56.0.windows.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mailsh.amlogic.com (10.18.11.5) To mailsc.amlogic.com
 (10.8.11.35)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A26A1A0002
X-Stat-Signature: mmydkoophwyckqqp4reiop9owptjox87
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793174856-716221
X-HE-Meta: U2FsdGVkX18pTz1Bcc+CP9UlGgJVqqbew0Zm6+68aSFWAxYKwUOkcEbmqui6CLMszVTigtZ0JbLbaHnPRQP1Yh9UIQ25nfGUQNYnyTXtmUy1ZDnCR90K/JZpVc5sdH2Uqlw8WFA2vV5kdpD8er1qDF87lOGEOHFX61/PnBNt+SVGY0XLQA+JYwKbU5D0jtujRNsN3lXkPN8q6EmQMC9JPxVkR2D09gJxXXY4c6Nlv6gMUfirSquKl3gf3mUhmjbUQZjoJ8z3ghwSo19nRkimxBT8r/FnrZFGE6m8VWBp1xd1AUV+nb0/VmCpQjfwUe9Sf8CEXEjSYnO0UQhMyGCKQTkyc0zQrpslOaY1F6XtvfN/COTJlkOnzvE97KLzXwpwzz94cbxNE16HVuuOUHm6A/GRZo6lSsmmX2b42yU0pd6h/DqTB58q1XnjR3Fd5b+AYo2JgyqLDW8tFBkVnPC6Ojnpn88RJSJ1XYEQYdSEy7ljvVNX6/In67PC8EKO6v8eMGSxmfe/cCItIxzFjPhsaX8mzngqGLvj3L7GeRifZS9iP0lcDgdGcWEfkShwhU6hpifaHxbnpwNV7A4dDnXRm43tZp/x3Uu99/5mqAx7qiPHgaLUni+G9TfiquhQgWEWpwP+XX/tnnyGB1MNUT6eGR4bJfIdPBp4garB6hrsFdYt1/WByhGbeSs0g+YNaBxtN4lahI3HVfgLUn/Hf0h+QdH4PclBxgJ56GNEMxNs+Q1nT889GUHhcq8hTUJ8xqptCtABbJU/L225dr4PoLs/GyoQtTD6u2wf9OD3beG0Xf4stSZ2PZ45sqH178D2+6YElGtIoVXH4uwUW/Wmcq+1fjWHJaOp58s60jkYgDxIzu3JsQfrCZuPajF8LXpuVby0Frfw/x3QdUjVgBgwy9hQLnlVl/q8R/+CP2SSn4OqmNjCw6bIA+KrtzZLNI3fkimTcSVZS+nxMuBxSu2xV3U
 36Qhok8D
 Ro3L4DIYWj/BF1EexeTesLXOecFObt9tRhP66LVKNGi4vib9O187xbWGJ0gRjzmsguQZj4RvZmOYB68erwqml3OW4xWGWgMkNhXQhFErmsKVAeeiPJzUdkLO0FHdlkRM+SROf9kveZyR81xy+/JEDKSv/6ZZM2v8f8Kvo3R3/XtMYEtaa5TUpG+A0QKWnZth/ZNGrwUS+mWLUkQxptvIYY4ZJFXvp4OkCofLwlnyuiB5YfgQv0GAy5ZoyNtKpHy4aj3wbgTX5E+BWLqhXtUZibhR6RMqkBLXJ03HszJA48Vl19FYEVcYR1JWpvsQwH4NZJjkyWhI+BuYc63tcUPYeiPTsbhVoQ+0xjfHBj9R//oXfPTSXUDmd7skHJ1h4e3SeGGprE8UEmbGzrtLi0iwkVQarP3oidMFGnXdBNTCb0kwIt7f3VkPxJDPRTlq2jAoc3t3KfZl8ecahKY4d9GltNbWHuIJSXUbWyKvZYMUEV0IooTlcaSdPJaoqU4NxljbquvfU97M1oMQ9kufjkkltM7E8EbDdzqruMI/p38pvevNv61PYqTdzpmnE4GitnuMG/WxLeGdbjZndZcwS0NnOLypdcyNrplaVVB75xlkuIUR0He8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shu Han <ebpqwerty472123@gmail.com>

commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2 upstream.

The remap_file_pages syscall handler calls do_mmap() directly, which
doesn't contain the LSM security check. And if the process has called
personality(READ_IMPLIES_EXEC) before and remap_file_pages() is called for
RW pages, this will actually result in remapping the pages to RWX,
bypassing a W^X policy enforced by SELinux.

So we should check prot by security_mmap_file LSM hook in the
remap_file_pages syscall handler before do_mmap() is called. Otherwise, it
potentially permits an attacker to bypass a W^X policy enforced by
SELinux.

The bypass is similar to CVE-2016-10044, which bypass the same thing via
AIO and can be found in [1].

The PoC:

$ cat > test.c

int main(void) {
	size_t pagesz = sysconf(_SC_PAGE_SIZE);
	int mfd = syscall(SYS_memfd_create, "test", 0);
	const char *buf = mmap(NULL, 4 * pagesz, PROT_READ | PROT_WRITE,
		MAP_SHARED, mfd, 0);
	unsigned int old = syscall(SYS_personality, 0xffffffff);
	syscall(SYS_personality, READ_IMPLIES_EXEC | old);
	syscall(SYS_remap_file_pages, buf, pagesz, 0, 2, 0);
	syscall(SYS_personality, old);
	// show the RWX page exists even if W^X policy is enforced
	int fd = open("/proc/self/maps", O_RDONLY);
	unsigned char buf2[1024];
	while (1) {
		int ret = read(fd, buf2, 1024);
		if (ret <= 0) break;
		write(1, buf2, ret);
	}
	close(fd);
}

$ gcc test.c -o test
$ ./test | grep rwx
7f1836c34000-7f1836c35000 rwxs 00002000 00:01 2050 /memfd:test (deleted)

Link: https://project-zero.issues.chromium.org/issues/42452389 [1]
Cc: stable@vger.kernel.org
Signed-off-by: Shu Han <ebpqwerty472123@gmail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
(cherry picked from commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2)
Signed-off-by: yao zhang1 <yao.zhang1@amlogic.com>
---
 mm/mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 273e06dad3c6..7f357de8f4d6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3047,8 +3047,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		flags |= MAP_LOCKED;
 
 	file = get_file(vma->vm_file);
+	ret = security_mmap_file(vma->vm_file, prot, flags);
+	if (ret)
+		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
+out_fput:
 	fput(file);
 out:
 	mmap_write_unlock(mm);
-- 
2.46.0


