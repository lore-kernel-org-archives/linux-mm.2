Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C3460A261E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=SUE2dQ4t
Received: by kanga.kvack.org (Postfix)
	id D8ECE6B05BA; Wed, 11 Nov 2026 02:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65646B05BC; Wed, 11 Nov 2026 02:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07076B05BD; Wed, 11 Nov 2026 02:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 987D06B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20ADDC0237
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:32 +0000 (UTC)
X-FDA: 85422073464.14.AA8EC4F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3B2394000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SUE2dQ4t;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnMzGzAa5g0/2fGWNckudlYHrRY4wmAMpp2a4sY0JEw=;
	b=jLPsFNvpdatlQXwbg4UUzUZHjbe5d7PwVqxt9h+nV+XT3C0CHyXrtXV8tinF791kM9Em/v
	aUmFkrUFOEuNTWhZqLj0Fv8hPMsvqNKvrKIyNiUAiQAIUZfQP0tF3fZ/j+VTEjelnzG90L
	OR/qQWzmoTUtJeU4gKjdbt+SBXS88ng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383610;
	b=XhRvPr036Wf7VQQJLFQBtc3+y92JY4np7wbjUzoImJ1QaBn0vsPR/sd3KUQZ7FgU1LJ275
	ztUZ55Q5BqQwKinHQvecy9J5BzeN6PpLHlA+QrlCepk4VZ48A79O2RTEbR8sDJh/bb9erw
	jCKsSpPgnFE8Pg2DVhdH7cS99EET7q4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SUE2dQ4t;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so22534945e9.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383609; x=1794988409; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=pnMzGzAa5g0/2fGWNckudlYHrRY4wmAMpp2a4sY0JEw=;
        b=SUE2dQ4tSc9ovebB6c7NBDj/7OwN/M2B+VdKcGlDH7OVTiLrJBYHJSNGXcf/lYvUnd
         KWgwktDmNKUThVJ8D3ZM8MKZt6dy5WNfHeXq2tYw3uvxSJobipWNdiiq2lDX8ow6HrSc
         Tg/XpAdG8EgKbNW2uG5pvviEvB4QjiST/IDJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383609; x=1794988409;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnMzGzAa5g0/2fGWNckudlYHrRY4wmAMpp2a4sY0JEw=;
        b=vjGRthn/OQZez31wEszUJGO23765jLgop8AQxSvdxq7VID3EMTVIpYbExthdzuA03N
         z3ll5J1TPxtW0GDuPZ40peZN/QWv8zYSGqHB3Hj0TDpUBkFVhzeGuURrmphBrQ1gTsBu
         daQyYmGBILx07OWKxX/tli2SIBx5Xeky3+lygg2lCPPp0GAd/gXmtBKe08Fd5eC0bu+r
         Qbc1P3UUETcQxdRwcqoxyjdNIpH6JU/xtsJ0QC1Jwx2+AzC3PNkeveODgi32kgJ2WO48
         yq5zBjezvqTlg9qLIGPtmHyQn5QqNbBZVpbT4GUtSINFrsPev1d6snXg0JUs0c6Xv7Ea
         TbWA==
X-Forwarded-Encrypted: i=1; AL+hErGn/vNJDb3qQBKSscarmDS3Z1tXax6P/DV0w1H2bvJ13EADrMhHeVd29rVJnt2136GRY55oWP/2/Q==@kvack.org
X-Gm-Message-State: APuU4Z8kzhTMnVhWZpF3GrfGnEiz6RMCYBSbKE5jomU0CtdotkRlZjDf
	p2kPZBC2JkGh4ooSEPJwalfJpxDhbpzFnHKJxgzkhZ4ibOQB1wY7LwoXWtzPmg+iAlc=
X-Gm-Gg: AYBFou2smA/cLH8wuN3XnF8xC6Sewhf6pj5gUqwDJGBqKGbNWrP+qF7xU8r7vgebCJ/
	mSVeHpp1kJXafCXHI3V6EJwlr8qgkocQXAnrr+KDtCod89JwILikSyqHGzysp4DZpwT4vBh/18T
	8R0sc8LXeHgA+mQkOnaUOXbjZrnGfPTSdRPeCeQ+nYqokC+mV+FkvzThUUIwX5ErFvKT7C08qYE
	Yh2frxf/zOrwb5Vcr3rLb4Vin3+zc0NEOnPXwPWxdQ7eLsIvArAuCie7ydc3epg9IprDOoSEHj3
	L54YncnaxFAljA3WGfhjhQOmyX2oUZMdPp8kZvaTd8yO1X3BifT1f3P0L5H8CIVHKRevMZaQ/9d
	qmYlFbPpr8/odk98GvVuLrUJqqbysXa/hqrGxK76AOnAfv/x91bmfRGJohk4CZXvGJTFDB0Py5k
	tXYSfbPHC2DdlrnG9wqb1ekwhz8sNp0E/yVH9NK7caeCdj1TmP61hDL90uUy0TMCzn+cc4CAYSY
	jiaeY8KRu4O+LtgWKKa941hBcO7qTBHEPoJCcvJqtcI3zsrRBmR5U50keQjwUtJrppmhzkPOnjp
	KYh+oRETSjgQ9gq4aXPOtQ+yBLjVOgdqFhY2SbJoPpnmRi3xk1KiOH8iF6gbwdZdIj+HysWkjq8
	o9xIvEUJ0I/ldpqQ26aXrichCLTrhslxrHZhKkPmksZfMqPgI2puY62uD/bj2+4NYIdlnhHuZgx
	VkAFR9c17ngfE6nJaU23h0qxXNRHbAdJ7RMfm3GSKMnU/qrnbS7/l1
X-Received: by 2002:a05:600d:16:b0:4ba:4395:56c9 with SMTP id 5b1f17b1804b1-4ba439561a5mr11281775e9.26.1794383609006;
        Tue, 10 Nov 2026 23:53:29 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49842f2a1f9sm9790339f8f.15.2026.11.10.23.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:28 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:25 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 5/9] selftests/kho: Catch missing or zero bootmem reports
 before kexec
Message-ID: <2edf50f498070047a363420b890cb7ff0294b87b.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B2394000F
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 7ahrxi8iyasgjfyzmsrc73f67k5mqozj
X-Rspam-User: 
X-HE-Tag: 1794383610-431239
X-HE-Meta: U2FsdGVkX19rg9FyWJYHGkNSzcKzhg/j4FQPc1+ZyYdGNmaon56/eo0UEzc6oAMDaizGbJjforIS76/fM+XYo//RE6c6Bp3exPMIHTitdPzPbh2MXFjyBGY0JGzQpKnRzSmkAcJ95DIpsVvXI6SmXOLPHlhMK0xq3IphUV3n7E0tHbxKX1A2ptxrexzOTJaYRMKyeejbZC79nZSw1L24crsZ6VLu76dzA4wFK2IdxqbGIgJ5oMpFmjuWRyTPiVhvjSglteW0MAPgheSrLUuK8vBhbU+lj/Jg05kc601/CM/J6SmvVTbbFusuJ/+4+BuptN2YvehT0ZAGn8Br0V0d2djdbBRU292uVARznkx46hrPFSC38w+UVhv7FVMsJHMcoCYIitjT5BApPPyGynYHX3kkbHvodAaZz/kb9kKdyRMp2e+Gm5p4zMvNR8I2ClagC9nRPQ8SuEbtFZWEKa8a78yeNL5butTOPxjA3/iRZa4976anpxKT612UBKAtZVRc4vRr7xnsdqIntH4zEE9HseYD1PulwrY+Y33rB7MFSoh+NqPAxM8tHuC3Tpn/Dz/SfKuakxex+RBl7H7naPUEsMiUL7t7xdgcbya2I/gdorDiRdZl7HfLISqAC+Ymrli3z1upujGBpLAwBJD0qu0BUuuS1xnuuKJlKsWKXRltZfvos3+cSDv4C3/qJGdR0aCbX+7hWGhzKizHmuQ3WPsG8qrRs68aQibecpTIjY0A/4egQmEg5mw9SWB2q5m7IxQy+tQW0scqbDhUTWAcMb4sK1kElPFQXtumY5mQBGEq7aJBBzEzqwir78lykVVYNkFeF+th4puX3DH1rCp6uHIDA1q9qHG4d4IkRuPT34EuKjtItvXMa3rAKRZY9E2fiVmRYN2w+7ygk3rMjZxMTlD7qmm4FbTNpWJ36U3UiYp+PT0bFbxXvSOg9qaacfaqKsqJ559BDQvm8eryKMSc5b0
 9EXUHT9g
 2EY5DW1RHO5J7WNjn/DnsFxv31Az2bOoS83cO7wN8nnQ1FoPoaj/9z2TuXgwV+rcWpG5hOhH5I6TaVC6Qvgece/xmbF/iuLZFXf1M/DphRrMlkhreYpZF4Q6tRASv5i6kpjDjXI29j1q1S8W2Yq0/663JHnyVNGiH+KpXoUn5j5cVjyY4NrTXnh/Fue3/7Sc7IG1S089w2/oT4g0um26GINHWU86gUa9PxTwHSuNtY7z0m52Ro0kRdqm6CLOUaYIpfXmGWyAPyEVxd7GMZL8YlemF9qMfmfFxvHe1yfkBk8wN04eRUauPGaL4M6TpoxvkDvDChsjTRJh1iyv36B5U05dEHhV48wXnJQnHLS7xdlIJ5dNDkoPmm++76ynme2UlK0v40WEPdosss0zfSivzgVVB2M6YxGZjEvr67UyZjoC8sU9wlxR++Q3KbfMEL9cLGTUNt637Y7p/Jv9Y41jL7Smmrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The KHO vmtest can pass even if the bootmem size is no longer visible to
userspace. Let's fail if /sys/kernel/kexec/kho_bootmem_size can't be
read or reports zero on the KHO-enabled boot.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/kho/init.c    | 24 ++++++++++++++++++++++++
 tools/testing/selftests/kho/vmtest.sh |  1 +
 2 files changed, 25 insertions(+)

diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 88a41b6eba95..ca9297d896d3 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -18,9 +18,30 @@ static int mount_filesystems(void)
 	if (mount("debugfs", "/debugfs", "debugfs", 0, NULL) < 0)
 		return -1;
 
+	if (mount("sysfs", "/sys", "sysfs", 0, NULL) < 0)
+		return -1;
+
 	return mount("proc", "/proc", "proc", 0, NULL);
 }
 
+static int check_bootmem_size(void)
+{
+	char buf[32];
+	ssize_t len;
+	int fd;
+
+	fd = open("/sys/kernel/kexec/kho_bootmem_size", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	len = read(fd, buf, sizeof(buf));
+	close(fd);
+	if (len <= 0)
+		return -1;
+
+	return buf[0] == '0' ? -1 : 0;
+}
+
 static long kexec_file_load(int kernel_fd, int initrd_fd,
 			    unsigned long cmdline_len, const char *cmdline,
 			    unsigned long flags)
@@ -61,6 +82,9 @@ int main(int argc, char *argv[])
 	if (mount_filesystems())
 		goto err_reboot;
 
+	if (check_bootmem_size())
+		goto err_reboot;
+
 	if (kexec_load())
 		goto err_reboot;
 
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 1e86ffcc3a79..e3e99cfe3ac1 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -95,6 +95,7 @@ function mkinitrd() {
 dir /dev 0755 0 0
 dir /proc 0755 0 0
 dir /debugfs 0755 0 0
+dir /sys 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $tmp_dir/init 0755 0 0
 file /kernel $kernel 0644 0 0
-- 
2.54.0


