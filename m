Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC32FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447686B0099; Mon,  4 May 2026 05:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7426B009B; Mon,  4 May 2026 05:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DB86B009D; Mon,  4 May 2026 05:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5446B0099
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D826A1A0385
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:41 +0000 (UTC)
X-FDA: 84729225042.16.B710CE9
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 05BBC20003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=mytd3Boy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SmVfsSu9;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txu04uvacD5BOS6pZdks2wuxHk5ixo4TfuHlWKL2s0s=;
	b=aVqRLfDV+i8mwBF2P0iVcC7C7nas/HMlnEBupMMefy1pdHaQLHmOYZ+MjeJ6zyOnHmg29k
	eqaJNcwOthonxtnPx53s1qQvGpXuabfh05Ejn8aXGN3B5cWEtffSjfzxFZ/CsGgeTby1UL
	QYhHI+QAILRgIvJ2jg3w5X/UrZkZDpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887220; a=rsa-sha256;
	cv=none;
	b=e4UABUTi07nzgbBIJpCwFz+k5WMe+43mbNED7qtfZ4jJv9xpccRWI88R94+KIInShjo5kg
	II10VmMR0MOD+MXo/Y0pWQXxfiDOxMPLO55sa9O5FU6fpcTPZ2w9STnP4vWf8N7hb9cQ9q
	z3RG1qlwO3v2EoY8WGp8ak6ZbYjkXeo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=mytd3Boy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SmVfsSu9;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txu04uvacD5BOS6pZdks2wuxHk5ixo4TfuHlWKL2s0s=;
	b=mytd3Boyf69X4DDkWYFsi3ghOpooOmkdsKjdjdOBxbNWBWvOZP9MPNV43Sc79YmSQtHmRE
	eva8BnHmWcioprtk8fVgJd3wokb8PwA5ABxUvu9bO1BJGh8iRtLshnMDDIEgMkfXXnupq6
	AQTA2l9yxbUhGe8cvG/rq3Vr1TSuiIKGR4sVCZ73LzT9lnfbc7F7j0TpunBJsfo7kSSbIs
	2vFXEW3QMA90ILnGysdIhsPPNdRC2eOl+RUj9baIAALDNFxvdQJQ/x2rYgWy5kJwV8r2BI
	h8rZyhDn0/kpWS1B1xoj96n2d+IvapYP4hB7J3MPtfAajl0Mrbwo86x78k6WgQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txu04uvacD5BOS6pZdks2wuxHk5ixo4TfuHlWKL2s0s=;
	b=SmVfsSu9Ki8BtDRjyzCt/w/mgkUvSIl+eZyl+8rVP3O0aXLRqNJ5Md6wQqTc+aIj6Ss/iO
	OGjOTGd18wjqzsAQ==
Date: Mon, 04 May 2026 11:33:24 +0200
Subject: [PATCH v6 08/11] kunit: uapi: Forward test executable output to
 KUnit log
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-8-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=5270;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=2eKO4vMe4Rs11ZE058NHDusLM5GzLyo6TWJUCIU1st4=;
 b=eAyXR25yto2GniYCRLnQQbR726ZuqwLNF+cJwkhT563vUaH60/3lrMUsQgD6kXStTvdCBgEwI
 vf+45teK5TZC+XQ54PNDtmEuDO+/q/Y8/AerLsK3YVRVM8UiBjRLNwu
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05BBC20003
X-Rspam-User: 
X-Stat-Signature: xpiu9d1u8uoskbnkjfwiqnsxof97embx
X-HE-Tag: 1777887219-805896
X-HE-Meta: U2FsdGVkX19peldbyUVKYVPA0a1xPL26JlrAqzZUj4se4mh3dPSX5E46Ww46WFTDeTvh4YCRBKg5nj2LguUnIphJ0n2WoeTxnzmwgKOkDQhkt2v6zoPd/nV4szCUOf1sEO5Kj7lQjplvBGlO+tVvvN442mOJ2OckB5PCJlpXM6ZUPeH1Oun8YWvTO+slZX6jvh//MNuzgpUkaLIYRBYqswtJuYIRNaRNhBc73U4r5O7oSfjYZSUfN3UhACdqSyEkW3bcIqqM+yj8oYhicWYUV6StVrCOsU5K/jEM6QLs1J0crgvfV1wahYKt9oseKsqKpqtJsAQ5AR1yrRN3gWX8dlXod3eMahtuNAn2bVTwV8kklgdkvdov0e8VdGUTyn2bcOOEl8peRzhekBv8iqhQJOqzGV7vSFv+mEUyA+gIyCT657Xp1HkhnuOrKOJYlhnUf2nsvT2ufiZR9pDAE6BU/fCtPdwRs9t7eDcGDXmvMqkG4F5Y5N4LFFVG9pXXDPBJClyPwVIjiBJUQUgZ/Mtb5uwj5JWKe3dIXWwZNU2NCMwg5ATR2+j8LN5XezpM3/0KOq1LWtuFAEXVBf8ueN9+vicaA0oWT4z/JsFBHT3zx12SDEtKZLLs49UYgxopJYo7Nk7Ec1339pptIW3EqkEltwFjVP3vkFCuVOSeGnMTXswvduB4VUXZFwJpn9K9KgZPvw8LoYljDbSuC4XbQosTKv0OARiXQ7diNMf4c/BfC/dvS6aVeU/1re2fQECVl5PGqI+beNyXyUAnBRJJU/yb/lMc6ZMhxj/R+Ef7DppX8kNztXGijZt3zQ5c5FEdd8uIPhqJUU6UdXxz609x/dO1K4888lqYCVMhFbb4cVK6Gu+dTyncvmyxsD4rpmSl7cXJBhADL58zwHiYH2+SE/cUUqkJi5kB3d0D8qtA0BX2ePo4DHYJ9dDmv443G8GHaMfTm2IwcuO10bocm6VmH4W
 FMl4XA91
 CWDl2ogpUATL5ND5VrayuYlaffzdRPCqlSznD+UqNdF7+iO5/vOS4G8+K5zUI5Qd29C3Y697Jg5F6/8P0cmsahJ5gOQIRVNyDiL1pJcqaazXIeQW3quSetMoN+uz9H4s3sVX5HO/iVx9SXBUSYRVPUpdjv8qeRhbtCllE8IVtFY3DCD5bZVGOyvTtoqgIeERcD8Ei7ueDwouYkTeoUAytqU0/Mfy9tNqYDht745qtAWOXER2kfLG4HXzaofhyMOrO+gfinsgtkEZLkA4/Kxx5TxlogF2to2EGPQq6ucJZDwhCP4h7v0+HpyfeiS8Yl4PhRQd8QUMZOBOjHRKmiquCjgs/eO+DIIkogCb6YOkDEzj9hMBdZB3oTHN7/Hr7vGM3urZUXftBVdGRb/sdtQ3RAbhkFNcBFZzfNKEfsE4IAq+rwBfF8WFB5CWUPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The output of the test executable should be grouped together with the
regular KUnit output and also be available in debugfs.
Install a custom miscdevice as stdout and stderr which forwards the
written data to the KUnit log.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 lib/kunit/kunit-uapi.c | 155 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/kunit-uapi.c b/lib/kunit/kunit-uapi.c
index 485b79fd193d..7f0309a827a5 100644
--- a/lib/kunit/kunit-uapi.c
+++ b/lib/kunit/kunit-uapi.c
@@ -11,6 +11,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
+#include <linux/miscdevice.h>
 #include <linux/pid.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/sched/task.h>
@@ -22,6 +23,8 @@
 #include <kunit/test.h>
 #include <kunit/uapi.h>
 
+#define KUNIT_LOG_DEVICE "kunit-log"
+
 enum {
 	KSFT_PASS	= 0,
 	KSFT_FAIL	= 1,
@@ -94,10 +97,48 @@ static int kunit_uapi_get_cwd(struct vfsmount *mnt)
 	return take_fd(fd);
 }
 
+static int kunit_uapi_open_standard_streams(void)
+{
+	struct vfsmount *devtmpfs __free(kern_unmount) = kunit_uapi_mount_fs("devtmpfs");
+	if (IS_ERR(devtmpfs))
+		return PTR_ERR(devtmpfs);
+
+	CLASS(get_unused_fd, stdin_fd)(O_RDONLY);
+	if (stdin_fd < 0)
+		return stdin_fd;
+
+	CLASS(get_unused_fd, stdout_fd)(O_WRONLY);
+	if (stdout_fd < 0)
+		return stdout_fd;
+
+	CLASS(get_unused_fd, stderr_fd)(O_WRONLY);
+	if (stderr_fd < 0)
+		return stderr_fd;
+
+	struct file *logfile __free(fput) = file_open_root_mnt(devtmpfs, KUNIT_LOG_DEVICE,
+							       O_RDWR, 0);
+	if (IS_ERR(logfile))
+		return PTR_ERR(logfile);
+
+	fd_install(stdin_fd, no_free_ptr(logfile));
+	fd_install(stdout_fd, fget(stdin_fd));
+	fd_install(stderr_fd, fget(stdin_fd));
+
+	take_fd(stdin_fd);
+	take_fd(stdout_fd);
+	take_fd(stderr_fd);
+
+	return 0;
+}
+
 static int kunit_uapi_usermodehelper_init(struct subprocess_info *info, struct cred *new)
 {
 	struct kunit_uapi_usermodehelper_ctx *ctx = info->data;
-	int dirfd;
+	int ret, dirfd;
+
+	ret = kunit_uapi_open_standard_streams();
+	if (ret)
+		return ret;
 
 	dirfd = kunit_uapi_get_cwd(ctx->mnt);
 	if (dirfd < 0)
@@ -188,6 +229,118 @@ void kunit_uapi_run_kselftest(struct kunit *test, const struct kunit_uapi_blob *
 }
 EXPORT_SYMBOL_GPL(kunit_uapi_run_kselftest);
 
+struct kunit_uapi_log_private {
+	struct mutex mutex;
+	struct seq_buf buf;
+	char data[4096];
+};
+
+static int kunit_uapi_log_open(struct inode *ino, struct file *file)
+{
+	struct kunit_uapi_log_private *priv;
+
+	priv = kmalloc_obj(*priv);
+	if (!priv)
+		return -ENOMEM;
+
+	mutex_init(&priv->mutex);
+	seq_buf_init(&priv->buf, priv->data, sizeof(priv->data));
+
+	file->private_data = priv;
+
+	return 0;
+}
+
+static void kunit_uapi_log_str(struct kunit *test, const char *str, size_t len)
+{
+	kunit_log(KERN_INFO, test, KUNIT_SUBSUBTEST_INDENT "%.*s", (int)len, str);
+}
+
+static void kunit_uapi_print_buf_to_log(struct kunit *test, struct seq_buf *s)
+{
+	const char *start, *lf;
+
+	if (s->size == 0 || s->len == 0)
+		return;
+
+	start = seq_buf_str(s);
+	while ((lf = strchr(start, '\n'))) {
+		kunit_uapi_log_str(test, start, lf - start + 1);
+		start = ++lf;
+	}
+
+	/* Remove printed data from buffer */
+	memmove(s->buffer, start, start - s->buffer);
+	s->len -= start - s->buffer;
+}
+
+static ssize_t kunit_uapi_log_write(struct file *file, const char __user *ubuf, size_t count,
+				    loff_t *off)
+{
+	struct kunit_uapi_log_private *priv = file->private_data;
+	struct seq_buf *buf = &priv->buf;
+	struct kunit *test;
+
+	test = kunit_get_current_test();
+	if (!test)
+		return -ENODEV;
+
+	guard(mutex)(&priv->mutex);
+
+	if (seq_buf_has_overflowed(buf))
+		return -E2BIG;
+
+	if (buf->size < buf->len + count) {
+		seq_buf_set_overflow(buf);
+		kunit_warn(test, "KUnit UAPI line buffer has overflowed\n");
+		return -E2BIG;
+	}
+
+	if (copy_from_user(buf->buffer + buf->len, ubuf, count))
+		return -EFAULT;
+
+	buf->len += count;
+
+	kunit_uapi_print_buf_to_log(test, &priv->buf);
+
+	return count;
+}
+
+static int kunit_uapi_log_release(struct inode *ino, struct file *file)
+{
+	struct kunit_uapi_log_private *priv = file->private_data;
+	struct kunit *test;
+
+	mutex_destroy(&priv->mutex);
+
+	test = kunit_get_current_test();
+	if (!test) {
+		kfree(priv);
+		return -ENODEV;
+	}
+
+	/* Flush last partial line */
+	kunit_uapi_log_str(test, priv->buf.buffer, priv->buf.len);
+	kunit_uapi_log_str(test, "\n", 1);
+
+	kfree(priv);
+	return 0;
+}
+
+static const struct file_operations kunit_uapi_log_fops = {
+	.owner		= THIS_MODULE,
+	.open		= kunit_uapi_log_open,
+	.release	= kunit_uapi_log_release,
+	.write		= kunit_uapi_log_write,
+};
+
+static struct miscdevice kunit_uapi_log = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= KUNIT_LOG_DEVICE,
+	.fops	= &kunit_uapi_log_fops,
+};
+module_misc_device(kunit_uapi_log);
+
 MODULE_DESCRIPTION("KUnit UAPI testing framework");
 MODULE_AUTHOR("Thomas Weißschuh <thomas.weissschuh@linutronix.de");
 MODULE_LICENSE("GPL");

-- 
2.53.0


