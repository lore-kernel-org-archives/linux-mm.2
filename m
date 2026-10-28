Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45156606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753E76B05B1; Wed, 28 Oct 2026 03:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BA66B05B5; Wed, 28 Oct 2026 03:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6682D6B05B6; Wed, 28 Oct 2026 03:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46AB56B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:43:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 385D61C45B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:38 +0000 (UTC)
X-FDA: 85371245316.08.DBC2360
Received: from mailsc.amlogic.com (unknown [64.106.246.77])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4B04140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793173416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=/vGGhDk2kbYeHylZZAFez92EAdypt/B9D5SYJhls24U=;
	b=SB2c9msBm3qN5GbnLMff96OSsji+egDxUmyrCYKItJt06wgKE8WUx/DILk0vemfKrj3a2L
	hUbGGheE29Alp/bVPNPzNAsiZbRpExvdmB+lcmNbDuBPRCcOyFvKLJhQWxivZ8+PJVoFWt
	xoxg1Y1OVTN5FMrwSpST7bPOBejYIco=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of yao.zhang1@amlogic.com designates 64.106.246.77 as permitted sender) smtp.mailfrom=yao.zhang1@amlogic.com;
	dmarc=pass (policy=quarantine) header.from=amlogic.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793173416;
	b=mjaSypf9LBgMT4gGfF1goPMJRabf5Gh823DsmKkLan6PyHvjo/I6PgVw4Qio72INOiWsZa
	KuK/GcPgxBKr+ywhKS8EGqdao3bTFeen3ahL/Z/Or2UMnatX7GR5D20SjobdQERRvQHAbV
	xna6CtZoFtIsHyH9RYiuzDGWwLBAHvw=
Received: from XA202100-0024.amlogic.com (10.88.19.246) by mailsc.amlogic.com
 (10.8.11.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Wed, 28 Oct
 2026 00:43:32 -0700
From: yao zhang1 <yao.zhang1@amlogic.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
	<linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
	<ebpqwerty472123@gmail.com>, <paul@paul-moore.com>,
	<stephen.smalley.work@gmail.com>, <yao.zhang1@amlogic.com>
Subject: [PATCH 5.15.y] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Wed, 28 Oct 2026 15:42:51 +0800
Message-ID: <20261028074251.1695-1-yao.zhang1@amlogic.com>
X-Mailer: git-send-email 2.56.0.windows.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mailsh.amlogic.com (10.18.11.5) To mailsc.amlogic.com
 (10.8.11.35)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B04140004
X-Stat-Signature: zwwqcke1tizqwuschbup4x4wxapxtpca
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793173416-820151
X-HE-Meta: U2FsdGVkX19uw/U0yaabCq5RGFKD7ZALrD5iUaMkrczoPvDOlynwmY69BKUE7BJT1FvAqW6F/9M4JFTDPuWrV0b1sNTAMUpsY6+fRC5gDt9/BwSQvwhzAU2cBxMte0lk9K8ByV7sIN5D0V9RNLKIm0ANekq5Sm/Fwh8iALSr3Z93q5BBfgjpEPSpCh2U2xEtYnPoV/BvQDLSODzQ7twmm8xHjmUZCyGWcmWXYRKo8GVLryIuOXybMUmmCvvgxFzUynmJv08ANCF2nhGESsn2c7Wav44y1EWBYNhpoNNR6Bpnj4LK1thqKYfJzuY4UQj+DQsg0Iek1UuuzaCpWfw+z4euqTwneggsgV3S7IvjBGrRr2fx/bi9fQG83+mJNnZCUYNeC6TbfapaDmNyY8R860JSYeZWcjoQpHq8mzhqVwSM636saoYM+ySBc8KhyVu7GO8FNlcKeCmI87a7jTDu2ma6991RaypQbJQVRsi02ov5vswFmJ81xefZ+1alKK0k35hSFmGhX/tw1wx29sY6ALu5HdM+SaCyFQCBWr8W/wMuZ2sDK47R9ieTzHPnvDgxGt+oxp8iAGkxTO6jz6wRA/5/tZf//NicxBxTla9Q9fOMC3MzBfPi0w2tB5G82u4RSqD1gBaY/hr+dvOGhtZyYckbOjzylF/Sm5EB2mfT/FGlcVG52f1D13OyY+Ec1vM9TMZi3eZ6IIC4cHFxUe4zdZ9WZ52nV1uJsjEwTjad3oNfzxlfHurBpxNQaAjf77zMKnDQ8z8HCVqLvL6GeHVUHQZIOzQDeDokS3gP+N9E73GS1spILEHUQGhjwu/j+T6gKjpWEp2SA/CpP3iqWd4Io1HdsouXvfaK/N8+aSzYlzdAPV2H0cdHvbEioBz94edGWNCmtnh57rY0QxbBGak2fGndJfeciEWeZ53Q5RTK3aBjkN1mPJ0vFAuIiI+ghIs9M2XXP1RtS8GkNMmwKEF
 +tEYlH4z
 RnHNAguZHKvwMMT2hVIszG7EHquEk6TAsZVuXrRKTwCNcEjJZuwoveX6hBUHLiAjt6LK1hTo7XG0fIOlBgf7ddXW3FJbARnpVBO0yZy1tWLBXdzyP9yoBGt21sHi5ci9NoJPGonvFyFVpk/4LWh3v8cCOBw4vBuVhnBVuVijv46sL+vkY+mOUkqaD+j0MmA0dRINGfcjWKRGE4V+UQxh83puopu4lJ04NL/5ynzZMRTcqu3Lco4iefjKmiZaxqhq2o400iMvtclcd+9ubr78C6Uss+r9PLO4QklC3hf1M221AAaEU5ICLInZ5VyisiIPAa1rae+qGux8ynI/2W1/phj2/z87mU/7tTf2ACAE0g5Lw+XbNT7aa6gBrZw3eQlcunlJGynZLCay8v73mpIe1uyfBwSjl2otsCXWkBmWp4tZfYzGTLdFm6iXYbbBd2V1WKVyq2QiDHJ07YEtExfAi3yvIU4tBRgToqgcNlkDI0sTMvY0a9Gx1xQXoaL8mwl8Y8nZ0WfyXIJmTQivEO6XHEguzjMwo8IzZMME1BCS0+jpNOKrAgiakuGalhEXmDTjkWG4pxlSQvw+ol2Ee+5nb9UeMCeuYgPirhFJpsS2Uk2isSAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shu Han <ebpqwerty472123@gmail.com>

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


