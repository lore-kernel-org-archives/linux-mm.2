Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BD3D25922
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3816B009E; Mon, 26 Jan 2026 21:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74996B009F; Mon, 26 Jan 2026 21:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D906B00A0; Mon, 26 Jan 2026 21:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C80676B009E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90FF014092E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:09 +0000 (UTC)
X-FDA: 84376201938.30.BD82BCC
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id DBA0A160010
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MVYbxj8b;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kycmWS+Mn50NTNG9vDPdXnOmThXS8tkuWasjOZWHyE=;
	b=IUA/4nL4pGXJnrcpPeNxIBlnc8LG4tJlHEaEUZKIw1eo0QovR0Z/PKZgylZOZihvifUm6w
	RHPy0DvzcHMnanpBPC/DSO5Rv/wcwSAucw3Gk1j55/7lulHwcXQyK0BJkrFCpf/h8mebkM
	WF1nzhl7lpiixrWsxKSgyncX47x1FtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481908; a=rsa-sha256;
	cv=none;
	b=ab+xwfE4s0x0fk5rDXSgmx74w9HnD8CwSqLbxwrAzFQCwHNsocTNNtcEOgsb6vPEwOAtEh
	vaaNmeaLIwsRzTV74wrj/2l1LJBqATQ75vQ0PghO02Ul5qSsomTS9qLJbcSNyVdRVvZP3D
	EEWxX8oVe7x/zRGvDUbqT6jaVM91t24=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MVYbxj8b;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kycmWS+Mn50NTNG9vDPdXnOmThXS8tkuWasjOZWHyE=;
	b=MVYbxj8bguPU/jWUxphCtMV2M4pyasjfYogGFJ2vNcT1KF2goib3pEeYc8kLCil+Me1cqA
	A+YE5JjAKsshrTPbuVZ0E9j1WggR0qhRanDpJE3AsiU2VhodIOexFViw0YdvUqPvkcyoBD
	IpQB4/liQnnBeuM18rgJmTEtSMseg/k=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 11/17] bpf: selftests: introduce read_cgroup_file() helper
Date: Mon, 26 Jan 2026 18:44:14 -0800
Message-ID: <20260127024421.494929-12-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DBA0A160010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: e7gmwdngf3aop3sbkawn3rqtimqhwq5b
X-HE-Tag: 1769481907-579445
X-HE-Meta: U2FsdGVkX1/yEf6AzPC4hASBvN9yZtN4pElGc0uk/NGcq0s52dt2GGhDuZRgkufvafuLH7qT8x28BlktAMJ1gD0yIF+2cvPXz0RO5ZaXnu6K8ce6l1zCqjrTGl7gxCN/bK4E+8Tjy67pO2FoGi5xHIbFIJxU6Dl4bw1p7iYDpX/SuFEWANs/68gO4vFACFUG+Oh5eXtnSv4ndcexjrxu3dGdObDXyybmQasLhc0/j0Z5MDqwXnONmQb5HKr52cT320IXh4BUYD5l7XRGE/VWs7H61iV73HY879uNzjHiLLZvIBsGPo9pskfupVso7mc3JIMniaetVW0y+n/RbEZfGjXa3UL3Llc05UBm/6BluzYluuq3VemnL7i4n9a0ByQF1TVi7jxZ4LgEWWQwNBykZvTFjaohIBcZLcWGqnZsfK6CJPbzB2PiXYXkVPFh+Bfa9ujR0No2hkb9FMfNvlRVbgrU3HGBY9z3+4aNutngJyEJtXmTOo5C6rUddPGhmxYyQMUvMhsuwcJ0PaP4QQr07f8XUqfu7QZ1dJUQErIwFDZm0wT2Kk38MMGpq4m0Rvk+cRy52GrRQzYH+Whhk+ssE8+yg22uxTfwE59ad1RzNd7wffy0DHORGPE8njqRxCva3oNxVgMHoVbMzi4Axw44Wf76NNZqdPrG6RtfwYZYWsA2jDcwAhC4N2AIYJKUNPdwMjfK7Th9O85QVMBv8JXRWfWknvisVW7zg4hNTxd44hDrCQZapW/OpXnDnO7fAtMfI6vEhvu+ieb9+7o0sTdAvGQPYQ/OWzkLm4UhnX07IUpMZtL9ecsDSq3HGdloQIxSVkBSEIGcJMEXn57k5bTFAHT0DZIM45LDjnl+Y8syAw5n3wx5njrwZBaLfyhVLJNOk31/gAaKCICOu7AACCTF4yuTBJ44zM84n2HDRFLwmwmM21eBte6ensk2Slagq10KPYN8vka4mQX+enKLNDK
 ATIyWS9j
 4LLSyjY1NLfibseVYobeeF2GWPOHWRyJQ6Nx9T7tTWCNHX5hf2ygI5qBnF4x/a71lm9RruxTJgxNiLCNgpjlgfwP+Y6hU50E6KDD135aS1OZ5UHpSU46Q0tSP9kof2s+spmX3Er7fL649Un+k/GzWyFuk26rMi8ZGqTu8FxmH7frakZu/lzP0ryEZDZnENF2rECkUCVmk+1IGFU16JRx2ajBBpriREYUowcdADpqB3/LCs+sdQrRjgl5Vzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement read_cgroup_file() helper to read from cgroup control files,
e.g. statistics.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 45 ++++++++++++++++++++
 tools/testing/selftests/bpf/cgroup_helpers.h |  3 ++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 20cede4db3ce..fc5f22409ce5 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -126,6 +126,51 @@ int enable_controllers(const char *relative_path, const char *controllers)
 	return __enable_controllers(cgroup_path, controllers);
 }
 
+static ssize_t __read_cgroup_file(const char *cgroup_path, const char *file,
+				 char *buf, size_t size)
+{
+	char file_path[PATH_MAX + 1];
+	ssize_t ret;
+	int fd;
+
+	snprintf(file_path, sizeof(file_path), "%s/%s", cgroup_path, file);
+	fd = open(file_path, O_RDONLY);
+	if (fd < 0) {
+		log_err("Opening %s", file_path);
+		return -1;
+	}
+
+	ret = read(fd, buf, size);
+	if (ret < 0) {
+		close(fd);
+		log_err("Reading %s", file_path);
+		return -1;
+	}
+
+	close(fd);
+	return ret;
+}
+
+/**
+ * read_cgroup_file() - Read from a cgroup file
+ * @relative_path: The cgroup path, relative to the workdir
+ * @file: The name of the file in cgroupfs to read from
+ * @buf: Buffer to read from the file
+ * @size: Size of the buffer
+ *
+ * Read from a file in the given cgroup's directory.
+ *
+ * If successful, the number of read bytes is returned.
+ */
+ssize_t read_cgroup_file(const char *relative_path, const char *file,
+			 char *buf, size_t size)
+{
+	char cgroup_path[PATH_MAX - 24];
+
+	format_cgroup_path(cgroup_path, relative_path);
+	return __read_cgroup_file(cgroup_path, file, buf, size);
+}
+
 static int __write_cgroup_file(const char *cgroup_path, const char *file,
 			       const char *buf)
 {
diff --git a/tools/testing/selftests/bpf/cgroup_helpers.h b/tools/testing/selftests/bpf/cgroup_helpers.h
index 3857304be874..66a08b64838b 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.h
+++ b/tools/testing/selftests/bpf/cgroup_helpers.h
@@ -4,6 +4,7 @@
 
 #include <errno.h>
 #include <string.h>
+#include <sys/types.h>
 
 #define clean_errno() (errno == 0 ? "None" : strerror(errno))
 #define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
@@ -11,6 +12,8 @@
 
 /* cgroupv2 related */
 int enable_controllers(const char *relative_path, const char *controllers);
+ssize_t read_cgroup_file(const char *relative_path, const char *file,
+			char *buf, size_t size);
 int write_cgroup_file(const char *relative_path, const char *file,
 		      const char *buf);
 int write_cgroup_file_parent(const char *relative_path, const char *file,
-- 
2.52.0


