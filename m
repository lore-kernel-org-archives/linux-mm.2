Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7402FCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47DA800B9; Mon, 27 Oct 2025 19:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EF08009B; Mon, 27 Oct 2025 19:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DC9800B9; Mon, 27 Oct 2025 19:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04078009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 636D78634C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:50 +0000 (UTC)
X-FDA: 84045471300.30.3B2D175
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF52F20007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="acx+GaZ/";
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJ5jF1KqqBtpRr4lYaVGPUnGDQslbYhlpMRXuPv0AtM=;
	b=gc/jfInzhzdnd6IKo4XBqoE53C/JnqwSmdY4tHzoNjoxU6KNwehDyPZRbFHyVfu8OM/5ht
	mXknATXDnZ1KYC2XMvlqMqWSfFNyHd6eaYB0T4xvG6rLVtg6wH4HNjIK5+6LSXtRy0hJSW
	FUnprCLrpy5ZLYCi1jp1G4pmo9iCw74=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="acx+GaZ/";
	spf=pass (imf13.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607368; a=rsa-sha256;
	cv=none;
	b=2RuiLaEyzfOyi6FOnU7Nz4YxQZYQX1+h65pnl0dVQZuA0lNQVPagnAQLTn8iuZglgjQ5bd
	HVzPmVP7f8jgYok2A1ItXTZEmyFP3O6NW/QThzwSq0SZYEVfScY3c8xfCB54GeG6JzDUXs
	nt6i3iK5q0SdM0EP+hyT9iRDoFlccQY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJ5jF1KqqBtpRr4lYaVGPUnGDQslbYhlpMRXuPv0AtM=;
	b=acx+GaZ/3IyRJBXp7KA1NErrPT//rMvPKOxJHJZoj5KpfXo9fjcmBYbgjKgqG6BVB5kRXl
	DtpNkULE9kwRHtW+fa8iZuz/RQQyN/Gkncab8G5m595kp90vn7WBM+GZ9LtPi0+cpouzWD
	WWt6B9Fc88j+Q3xIvgjeoaHogKqZLVE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 17/23] bpf: selftests: introduce read_cgroup_file() helper
Date: Mon, 27 Oct 2025 16:22:00 -0700
Message-ID: <20251027232206.473085-7-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yfwn38i4nx63i4u8e751p9ca1qh3pgc3
X-Rspamd-Queue-Id: AF52F20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761607368-496742
X-HE-Meta: U2FsdGVkX19Bou+fuC9jHkKda9G0DIVeMXZuE62o00LXLiKUDDn0Wz3TSzbvcadjrYcqby3/8zA5k7CLKHD2yEbLaj2Ea2hPuWJSmeti+NZBPdbMYToQGGlLcX3J6gKj7rc/7+zqKGYcCCDVW0qemq+lG4MpXjqXbE1Un4X4rUsdS66xN5WV3q+B+8n3iMr9/Nr0IQZuQMTDmQg9+uhSOiQb3yPDGlqCJt0fjuRC3ALYNaypVvTGCqwTWWEzQIx7bolCHQ7M9UQVajoH1FsMYVZxLVNeuh6FRO1tTy/0gKxxAQDbo8Hn2Q23mJbNWwCSFXWeZYuHry/a55/nqumNw2R1t+C1td48ESEouO6hAU4oOMB9ovWtX1MQB1p9fLfC/ZFOfEHsmIML/6CURqgNcqdWQE92gVwlbMMB2pp4Lwb6iTGnMBvKbJw2n7cnLYVkhGwVWyHrrOBA0c64Y2N07FNTjtp1flzj5HKJ53fR7lEtSyWetlhUOZinkKMGIIsGNyaqzYi8L09MawEtjMw5duzy1M8cpsi8suZFj6F/hgskVh8DXcrl8vRpf7hK86fL+IiosPmT9U6PGxp3+p0UndZ9hQQYowXdyIceFOnkG4OCFKuevlwZg11Lowp3qoZx2RI2bMUO0mjbfRpBVlG8omW1m0IOOmk9EQJITsBSCk+DBV1ILw7yXCIjQ+tolqQVwvuXCzsFhexEmFlOKh0BSfOjZFIrt6ePC+9+r0ARVsOAEhQiLkrIKy6boucYAQlwj9cxdxZgCDZUmXSFprD/ieRulSv0ou5ogg8rpMwfoFGbNQKA3Yooe5FY4k8cvgIq+QWVlPo1kB3JfbPlih5C6jzPW73MW6G161+z8bZP2Wv2XvUM4AF7IyMC5pdWvOkZ8te8K8siEfib6twWi8CrxHZvmugurO3jvU/slJg0xgi3oBjVSmK+3ZJkq138D8e/vIkGj/PxRA8ysqD5u7r
 smGQSSYE
 ym+3A+fwifTDlBoLHSx+PJQODpMuePw9MlimurtEOvTR0O/bUHUfc8N/YeP4PPZq13eXSzaPRbZ+SiSdBA+WuNxlKNwg3/rvuTym04fUGIG0Jpdo6oNSJGOaCuKpDFuqaoqqXXJKfkFHHrwtFn1uV8hy6UdwxRtZE+AZxOtwlodKiwr6RrQY/dBrQA4nFcO+GW5zAtJDxAqBEvWDnylCumMWWdgaWST+0PRULb9xn7r3Li40xqTrCLmIpHA==
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
index 20cede4db3ce..8fb02fe4c4aa 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -126,6 +126,45 @@ int enable_controllers(const char *relative_path, const char *controllers)
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
index 3857304be874..9f9bb6b5d992 100644
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
2.51.0


