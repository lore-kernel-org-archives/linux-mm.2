Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE6BCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3B56B00C5; Mon, 18 Aug 2025 13:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35F96B00C7; Mon, 18 Aug 2025 13:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE276B00C9; Mon, 18 Aug 2025 13:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4086B00C5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 705E91609B2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:24 +0000 (UTC)
X-FDA: 83790496608.22.1972377
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9926440011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7chACaY;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyQY6WbHHR935OUk0tr0hH/Nv0XIIXTz4uXs9PTYD5s=;
	b=oOPY/yiFBR5qUciFIKhyDVHoqN5RkDSk+JxTn9dxbGXtSTGxlCh9mVipfmlOTreHCie2xu
	rFwCvGeUB0V5XeA1WRaGNt1nWb+QDEIZok6Q16aL94Y9NxVhSXtbEFC7L8zXW5dW867Bqv
	iqCZq2CEGeQqN0UhxT8Jtia42rtKdow=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7chACaY;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536542; a=rsa-sha256;
	cv=none;
	b=fYUtCg126x3EdpEm9A6xqIoLVcuiNBJS1LUW9MSQ1ZRwEm4xsWQjDLV/v6AvFe5VBljcZv
	dVLdk0zDq9o8tRkzlQgVZbqBvd3NYGfVULeu7ckyBz560tOpfnBBX8FyaqD91UZoMf1Bjb
	XZ57YwldO7YPQvZ98uKvt3V+qo0msok=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fyQY6WbHHR935OUk0tr0hH/Nv0XIIXTz4uXs9PTYD5s=;
	b=K7chACaYMDaRGExX1A6HHl1xtyW3fyGo3b4d8d7yQX+89xHyZKKYsNXUFRUAJl7ieMHKQQ
	9lYnqpAC/gwQ/sUsGNIpFUZZxXBih2tznXkSby/csvimM2HtnoCeDG9Dy8Sf9jixe5XS8Q
	g3zmzuv1E5IK60R00CA8D1tLLixhhOo=
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
Subject: [PATCH v1 09/14] bpf: selftests: introduce read_cgroup_file() helper
Date: Mon, 18 Aug 2025 10:01:31 -0700
Message-ID: <20250818170136.209169-10-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9926440011
X-Rspam-User: 
X-Stat-Signature: gg6m8fukgw451c6oiawjx4ccgojiru6g
X-Rspamd-Server: rspam09
X-HE-Tag: 1755536542-428870
X-HE-Meta: U2FsdGVkX19XasUfjnbAs1QwQr9DaIIqAezaJcq8pqpJBjaRFbibyNpEr87uIi0asoPdbpDuJeDAir3P/8XheI54omyczSoIfUY+Jl3IXnTSQiYwhM2mQekUjdotjJ7XWQ7ULgi/se0hgEc/sn+PdE0aKYl5i3QEii2XHPB3Ruw9eOHgsY+Ic7efNFf59TJXNKRdnnUgRbdpjyV/UFe/TBH/DABJzCveI2ZdRYemYh3hodTL5HxosAweasgFCta+IQtOEberTty31rGVlqAsjahJBxbFY7dyQErEG8RtpUzaFK15ekg9pswvmDrfTvAn8nNBt7sd341Mx4whbdOLi3R8M2rEkKXBOGVD2LKCa6UhxC/kCtz/aXryevxOqEvnUWh9W7v1DoxKK+tbEjpFZa7HdkY4ZBzYIHNd3A9oZIQ9aSMfIsrINmwZUgd3BdcfYfZf0WGW4oURwHW1RS/3MQrFmmGHu8qm86+KljR+CE0q32guajk32ve4gHwb4dY6lGWbhVm7pvwv2Eda3ddXW3n0KRGEbT1XIrWfpFAUkF7LgjybEnOpHYjemnuuKD+H1IXj0EDFhbAfh+ayfpDL9qtnd/HUE7rJSq/WAtP162tjlG/LQKvbiJzBZnA67yR3/t3XlTsUAFm6rqTLrKvdKLPIPNyuV/lRpJilAAIA/UqUBgZ1k7OvSfwA4M3EZivOnznJ7uKj9l8xhHRCVr3R6wR1U2KqT4ziJ1NTDOsVxUd9/0EaUJSNElftAJA+Vov9yleNJ3SbmMpWLE0sHyuwomca9ueCPNIc2dpuFwAmWdjhrDVk2zQJ1M6hEnMxRrTLVEGXUSKE1fmKyTYFULxvDh5cD/aAkmenO4ZFYKhmNzmIhKwcQMnfVz3jnicBSoYalOdn64I/dek1OFY7t7LNhObxIU87x54VXhNv7PhJDf4v7CX/hNUxjfUQ+PXJR49FmrVNwzzdGtZyxlLKiQa
 xliYLri7
 dtz1iC2e1Z701f87ZVEAu9y5SkxP08P8QOv1KmGnLjI6XQG9EbbO+FOZzXHi0x9SA0uHdu6mR39GSc53eKefeCYnTdlxujQ8q0k8OhS6Ri8zz3OqeZQGZ9MD3mFssg/obJvvclCb9WD/0iDISGUFobYmN3mmbLS2CDyWZp6n6zHMJ1YKjqDDLtd7hsmMggbU9d4C4ELJmQ7WQeFUz2yS+FF9iEIYCPmuoJk+3K6eU2sz9yRBGbsf3KdtGew==
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
 tools/testing/selftests/bpf/cgroup_helpers.c | 39 ++++++++++++++++++++
 tools/testing/selftests/bpf/cgroup_helpers.h |  2 +
 2 files changed, 41 insertions(+)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index e4535451322e..3ffd4b764f91 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -125,6 +125,45 @@ int enable_controllers(const char *relative_path, const char *controllers)
 	return __enable_controllers(cgroup_path, controllers);
 }
 
+static size_t __read_cgroup_file(const char *cgroup_path, const char *file,
+				 char *buf, size_t size)
+{
+	char file_path[PATH_MAX + 1];
+	size_t ret;
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
+	close(fd);
+	return ret;
+}
+
+/**
+ * read_cgroup_file() - Read to a cgroup file
+ * @relative_path: The cgroup path, relative to the workdir
+ * @file: The name of the file in cgroupfs to read to
+ * @buf: Buffer to read from the file
+ * @size: Size of the buffer
+ *
+ * Read to a file in the given cgroup's directory.
+ *
+ * If successful, the number of read bytes is returned.
+ */
+size_t read_cgroup_file(const char *relative_path, const char *file,
+			char *buf, size_t size)
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
index 502845160d88..821cb76db1f7 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.h
+++ b/tools/testing/selftests/bpf/cgroup_helpers.h
@@ -11,6 +11,8 @@
 
 /* cgroupv2 related */
 int enable_controllers(const char *relative_path, const char *controllers);
+size_t read_cgroup_file(const char *relative_path, const char *file,
+			char *buf, size_t size);
 int write_cgroup_file(const char *relative_path, const char *file,
 		      const char *buf);
 int write_cgroup_file_parent(const char *relative_path, const char *file,
-- 
2.50.1


