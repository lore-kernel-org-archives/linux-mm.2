Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1202CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F73B900103; Thu, 14 Aug 2025 03:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF4E900088; Thu, 14 Aug 2025 03:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E61A900103; Thu, 14 Aug 2025 03:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4567900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:25:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61C00140563
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:25:25 +0000 (UTC)
X-FDA: 83774527410.24.B6A1197
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC65F8000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:25:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tES5zydb;
	spf=pass (imf30.hostedemail.com: domain of jirislaby@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156323; a=rsa-sha256;
	cv=none;
	b=FNKibBAdP6Wrjgy3EQhM7lEIA+hnWb93jGtAPJMTMcBKfzE6RhXvYD5fRWPNVYTya4/URK
	Lh6ZX37AVHLT0fi3ggAukLn8bqItDCO2qs1GRaaenynsDDxs3K9Jts0Y+3XybOtRyjvG4R
	cAF/+U8cWvfhIa6FK5nr9ZtgBoDuAV0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tES5zydb;
	spf=pass (imf30.hostedemail.com: domain of jirislaby@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIPuM2s0qMiv/0q3uGtNw+s9EkPbMkW57iclvQXkG6k=;
	b=ocWLW++O+eG8k9wpAg4B2hUz4pBgL3Drb3xSOpAUmKIOFdfnKujx9OnxLUz3RmaqMl5qE6
	22zmpKZh+HnTZfDmnL4T9xo3uFQ+YVm1X4TPMC9eQwfhYERZ+1DBCun9MOR8IFRdZKuOAZ
	pyo6/+vFK7XkaGQFw881YSQ5/+Da1lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id E4D70A54488;
	Thu, 14 Aug 2025 07:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A8AC4CEF6;
	Thu, 14 Aug 2025 07:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755156322;
	bh=dQnUKMcs6b08ZtMwS1mLWORnFN2eoNfA4YNem+Prk4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tES5zydb+44vZrDZntm9PcIrm2c7YXHv+xRi1Y7gMXcSS4t7xEA/z7B2aeXCcU67i
	 m5hQEnRcQRSmB8995uZpKkr3wgVBxZSn/LrNS/0rhcgWPtGUi7s5nuf77/KCiwhNzd
	 Gsdaf0eQozx0Z8n5eetlREejUCwe8xfu7OdpLIyVbuZELpjHrmi9mlkI6PfmFn5EDc
	 IpysvR3NWFdBuMIxiQjNu4iArjSGFd1dVVOATQ0sL2ADLNlytIfeQsCz0754X1RyaC
	 KIT9s0BFkRAWbRLyFH3XPA5E4GuESep2bSkMEeKLSjEtSMPcQoQlfinQcCW1xi3tat
	 uoQjByjcQYkIQ==
From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH 15/16] tty/vt: use guard()s
Date: Thu, 14 Aug 2025 09:24:55 +0200
Message-ID: <20250814072456.182853-16-jirislaby@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814072456.182853-1-jirislaby@kernel.org>
References: <20250814072456.182853-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC65F8000A
X-Stat-Signature: sd94bwyzqfw1pte1hp7giaqmjfwn9d1q
X-Rspam-User: 
X-HE-Tag: 1755156323-40160
X-HE-Meta: U2FsdGVkX1+yc/ztcwTdCy116yUlJEnLI6t4LDJAjx6SZBNHcEo0VZbXRg5qlY3QcZP7YSjXbnj+vaVrQ38uxNsM5pOTGG1VbaSgoR12+l58oG33YeI+e/vf4eHAC6jt9Cr3zgJJyLPbdV1zcvvCAnu8yD0gVxPyGXHQ3p0g22+VBAlEt6YfDVNPKCjANl/ZUmfc77xa/Du3GyI6gLJrP/2MculWxuyRMKy0gDZQu9qQVSIJZpB3vrpxAZPNBIjPWmZBldfllw5yHyVRxDS0ZedLa+3gFJGabbI4aLZW7UK+kJ5v3XqfwhpgoDEiYUAzq0A2bxaD7YCV9duoM/efB81eCn6GvCwwE5uiQUSVkcpwNtjPkPM8YPW/qEPXu5WOZH+IadNLXx4dQGEUoKduGOTr6aMBdr1rWTaSYDtbLQsxwnx32I5wAhVDfmPR7ZAdDDSRIRdOsitEO0NXpvscV69VaVNIywNT/z10Vib4W3qgLafcFAj78xzdxXsFNs8dZncfV6P07wh8+vcEsNdM7ux22uRZZqVKJCmSV2BozJTAnZgyJSSCd+9oPsaEWVzJjvLHU7WwAoNSZ8AfY3SURG1EZLr8EmvyIWlZpetvmg9OI2SnYhUIFRHjkj2zp4zT1PeRlamgaqbvk1dSfMYoB/VSLCkE506OzrjZsW+hVv3XpAq+TRW03u/ttQVhwOyzOzPdw+LoM6ZaqE8zMT9+3gJ72iCjxaPeLh+cDfkFSFnf/rEYF41H85RYrdYVKKVdqqWqism9r3AfKkqzjc3+Rd/NUrJNeaSCx8k+2byHIbtQl6YZWhP8cjAvo+bpYThe6HweAb6xunf3TRSsJRnfe34EBBptolsFivFlbdV4Q3fj+L/plmoFzAb0liD/oiiBE/IVctzujsOMch6oPKkmJuDwUZl0EvA0WUGYqYkauh7+ihff+KMmM2pfg79wWl1zXicIjErf82aviJs6kEl
 loExXTT+
 l0rnF7/QgHVjpR3MVSJ0wBseVHpsWSKIj7HsSJtOj6ZDZwuM53XyndL7SXKTj46mrmlos+XOVbwZmxr9AA6qkLuDjNfWOtRV1cZcnhAAYsIZlofwGDI2EzMjkvgkE2pty8K2eAhWwUcUGrYWT6ebTsVHhDchZbxH/+6pZcWXXDiL9aapk0KBf56V/uQ/ICMyCe0hLpWG2oPIcGkKP6i9INqsujs213l6N9j5DrXJWgAI3lT0HOi9MQBaKCH5ikNzAOaG5kISmeDwSSbIYTJOO3/oM3SGjegChJYJkerlLMUF1TdUAnbhkwTU3XXRetOnBib8tSVNVMo5+BzAg7TfIk7HRdOwmIp4FdoGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having all the new guards, use them in the vt code. This improves
readability, makes error handling easier, and marks locked portions of
code explicit.

A local free_page_ptr __free guard is introduced for
__get_free_page/free_page (with proper casts). This could be made public
in include/. But I am not sure if there are more possible users, so
keeping completely private here.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
Cc: linux-mm@kvack.org

MM fellows,

just so you know:

Apart from here included (and easy to define) __get_free_page() guard:
    DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
it also could be extended to __get_free_pages(). But likely the only
user which would profit from that one is raid6_select_algo(). And it's
not that straighforward. Adding the free_pages guard for reference:

  struct gfp_holder {
         union {
                 unsigned long mem;
                 void *ptr;
         };
         unsigned order;
  };

  DEFINE_CLASS(get_free_pages, struct gfp_holder, free_pages(_T.mem, _T.order),
              { .order = order }; t.mem = __get_free_pages(gfp, order),
              gfp_t gfp, unsigned order);

  #define ___get_free_pages_free(var, what, gfp, order, id)              \
         CLASS(get_free_pages, id)(gfp, order);                          \
         var = id.what

  #define __get_free_pages_free(var, gfp, order)                         \
         ___get_free_pages_free(var, mem, gfp, order, __UNIQUE_ID(xxx))

  #define __get_free_pages_ptr_free(var, gfp, order)                     \
         ___get_free_pages_free(var, ptr, gfp, order, __UNIQUE_ID(xxx))

Use like:
  __get_free_pages_ptr_free(char *disk_ptr, GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
  if (!disk_ptr)
    return -ENOMEM;
  disk_ptr[0] = 10;
---
 drivers/tty/vt/consolemap.c |  32 +++---
 drivers/tty/vt/selection.c  |  20 ++--
 drivers/tty/vt/vc_screen.c  |  74 ++++++--------
 drivers/tty/vt/vt.c         |  98 ++++++++-----------
 drivers/tty/vt/vt_ioctl.c   | 190 ++++++++++++++++--------------------
 5 files changed, 170 insertions(+), 244 deletions(-)

diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index 8eb9d745a868..7a11c3f2e875 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -361,10 +361,10 @@ int con_set_trans_old(unsigned char __user * arg)
 		inbuf[i] = UNI_DIRECT_BASE | ch;
 	}
 
-	console_lock();
+	guard(console_lock)();
 	memcpy(translations[USER_MAP], inbuf, sizeof(inbuf));
 	update_user_maps();
-	console_unlock();
+
 	return 0;
 }
 
@@ -374,13 +374,11 @@ int con_get_trans_old(unsigned char __user * arg)
 	unsigned short *p = translations[USER_MAP];
 	unsigned char outbuf[E_TABSZ];
 
-	console_lock();
-	for (i = 0; i < ARRAY_SIZE(outbuf); i++)
-	{
-		ch = conv_uni_to_pc(vc_cons[fg_console].d, p[i]);
-		outbuf[i] = (ch & ~0xff) ? 0 : ch;
-	}
-	console_unlock();
+	scoped_guard(console_lock)
+		for (i = 0; i < ARRAY_SIZE(outbuf); i++) {
+			ch = conv_uni_to_pc(vc_cons[fg_console].d, p[i]);
+			outbuf[i] = (ch & ~0xff) ? 0 : ch;
+		}
 
 	return copy_to_user(arg, outbuf, sizeof(outbuf)) ? -EFAULT : 0;
 }
@@ -392,10 +390,10 @@ int con_set_trans_new(ushort __user * arg)
 	if (copy_from_user(inbuf, arg, sizeof(inbuf)))
 		return -EFAULT;
 
-	console_lock();
+	guard(console_lock)();
 	memcpy(translations[USER_MAP], inbuf, sizeof(inbuf));
 	update_user_maps();
-	console_unlock();
+
 	return 0;
 }
 
@@ -403,9 +401,8 @@ int con_get_trans_new(ushort __user * arg)
 {
 	unsigned short outbuf[E_TABSZ];
 
-	console_lock();
-	memcpy(outbuf, translations[USER_MAP], sizeof(outbuf));
-	console_unlock();
+	scoped_guard(console_lock)
+		memcpy(outbuf, translations[USER_MAP], sizeof(outbuf));
 
 	return copy_to_user(arg, outbuf, sizeof(outbuf)) ? -EFAULT : 0;
 }
@@ -571,11 +568,8 @@ static int con_do_clear_unimap(struct vc_data *vc)
 
 int con_clear_unimap(struct vc_data *vc)
 {
-	int ret;
-	console_lock();
-	ret = con_do_clear_unimap(vc);
-	console_unlock();
-	return ret;
+	guard(console_lock)();
+	return con_do_clear_unimap(vc);
 }
 
 static struct uni_pagedict *con_unshare_unimap(struct vc_data *vc,
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 24b0a53e5a79..07d3b93975d3 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -127,9 +127,8 @@ int sel_loadlut(u32 __user *lut)
 	if (copy_from_user(tmplut, lut, sizeof(inwordLut)))
 		return -EFAULT;
 
-	console_lock();
+	guard(console_lock)();
 	memcpy(inwordLut, tmplut, sizeof(inwordLut));
-	console_unlock();
 
 	return 0;
 }
@@ -375,15 +374,9 @@ static int vc_selection(struct vc_data *vc, struct tiocl_selection *v,
 
 int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 {
-	int ret;
-
-	mutex_lock(&vc_sel.lock);
-	console_lock();
-	ret = vc_selection(vc_cons[fg_console].d, v, tty);
-	console_unlock();
-	mutex_unlock(&vc_sel.lock);
-
-	return ret;
+	guard(mutex)(&vc_sel.lock);
+	guard(console_lock)();
+	return vc_selection(vc_cons[fg_console].d, v, tty);
 }
 EXPORT_SYMBOL_GPL(set_selection_kernel);
 
@@ -409,9 +402,8 @@ int paste_selection(struct tty_struct *tty)
 	const char *bps = bp ? bracketed_paste_start : NULL;
 	const char *bpe = bp ? bracketed_paste_end : NULL;
 
-	console_lock();
-	poke_blanked_console();
-	console_unlock();
+	scoped_guard(console_lock)
+		poke_blanked_console();
 
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld)
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 79b33d998d43..c814644ef4ee 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,6 +53,8 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
+DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
+
 /*
  * Our minor space:
  *
@@ -72,7 +74,6 @@
 #define use_unicode(inode)	(iminor(inode) & 64)
 #define use_attributes(inode)	(iminor(inode) & 128)
 
-
 struct vcs_poll_data {
 	struct notifier_block notifier;
 	unsigned int cons_num;
@@ -231,15 +232,13 @@ static loff_t vcs_lseek(struct file *file, loff_t offset, int orig)
 	struct vc_data *vc;
 	int size;
 
-	console_lock();
-	vc = vcs_vc(inode, NULL);
-	if (!vc) {
-		console_unlock();
-		return -ENXIO;
-	}
+	scoped_guard(console_lock) {
+		vc = vcs_vc(inode, NULL);
+		if (!vc)
+			return -ENXIO;
 
-	size = vcs_size(vc, use_attributes(inode), use_unicode(inode));
-	console_unlock();
+		size = vcs_size(vc, use_attributes(inode), use_unicode(inode));
+	}
 	if (size < 0)
 		return size;
 	return fixed_size_llseek(file, offset, orig, size);
@@ -369,11 +368,10 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct vcs_poll_data *poll;
 	unsigned int read;
 	ssize_t ret;
-	char *con_buf;
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	con_buf = (char *) __get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -382,17 +380,16 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	/* Select the proper current console and verify
 	 * sanity of the situation under the console lock.
 	 */
-	console_lock();
+	guard(console_lock)();
 
 	uni_mode = use_unicode(inode);
 	attr = use_attributes(inode);
 
-	ret = -EINVAL;
 	if (pos < 0)
-		goto unlock_out;
+		return -EINVAL;
 	/* we enforce 32-bit alignment for pos and count in unicode mode */
 	if (uni_mode && (pos | count) & 3)
-		goto unlock_out;
+		return -EINVAL;
 
 	poll = file->private_data;
 	if (count && poll)
@@ -468,10 +465,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	}
 	*ppos += read;
 	if (read)
-		ret = read;
-unlock_out:
-	console_unlock();
-	free_page((unsigned long) con_buf);
+		return read;
+
 	return ret;
 }
 
@@ -591,7 +586,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct inode *inode = file_inode(file);
 	struct vc_data *vc;
-	char *con_buf;
 	u16 *org0, *org;
 	unsigned int written;
 	int size;
@@ -602,7 +596,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	con_buf = (char *) __get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -611,22 +605,18 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	/* Select the proper current console and verify
 	 * sanity of the situation under the console lock.
 	 */
-	console_lock();
+	guard(console_lock)();
 
 	attr = use_attributes(inode);
-	ret = -ENXIO;
 	vc = vcs_vc(inode, &viewed);
 	if (!vc)
-		goto unlock_out;
+		return -ENXIO;
 
 	size = vcs_size(vc, attr, false);
-	if (size < 0) {
-		ret = size;
-		goto unlock_out;
-	}
-	ret = -EINVAL;
+	if (size < 0)
+		return size;
 	if (pos < 0 || pos > size)
-		goto unlock_out;
+		return -EINVAL;
 	if (count > size - pos)
 		count = size - pos;
 	written = 0;
@@ -651,8 +641,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 				 */
 				if (written)
 					break;
-				ret = -EFAULT;
-				goto unlock_out;
+				return -EFAULT;
 			}
 		}
 
@@ -664,15 +653,13 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 		if (!vc) {
 			if (written)
 				break;
-			ret = -ENXIO;
-			goto unlock_out;
+			return -ENXIO;
 		}
 		size = vcs_size(vc, attr, false);
 		if (size < 0) {
 			if (written)
 				break;
-			ret = size;
-			goto unlock_out;
+			return size;
 		}
 		if (pos >= size)
 			break;
@@ -702,9 +689,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (written)
 		vcs_scr_updated(vc);
 
-unlock_out:
-	console_unlock();
-	free_page((unsigned long) con_buf);
 	return ret;
 }
 
@@ -754,17 +738,17 @@ vcs_open(struct inode *inode, struct file *filp)
 	unsigned int currcons = console(inode);
 	bool attr = use_attributes(inode);
 	bool uni_mode = use_unicode(inode);
-	int ret = 0;
 
 	/* we currently don't support attributes in unicode mode */
 	if (attr && uni_mode)
 		return -EOPNOTSUPP;
 
-	console_lock();
-	if(currcons && !vc_cons_allocated(currcons-1))
-		ret = -ENXIO;
-	console_unlock();
-	return ret;
+	guard(console_lock)();
+
+	if (currcons && !vc_cons_allocated(currcons - 1))
+		return -ENXIO;
+
+	return 0;
 }
 
 static int vcs_release(struct inode *inode, struct file *file)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 100d6cb26887..869261141535 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1317,12 +1317,9 @@ EXPORT_SYMBOL(__vc_resize);
 static int vt_resize(struct tty_struct *tty, struct winsize *ws)
 {
 	struct vc_data *vc = tty->driver_data;
-	int ret;
 
-	console_lock();
-	ret = vc_do_resize(tty, vc, ws->ws_col, ws->ws_row, false);
-	console_unlock();
-	return ret;
+	guard(console_lock)();
+	return vc_do_resize(tty, vc, ws->ws_col, ws->ws_row, false);
 }
 
 struct vc_data *vc_deallocate(unsigned int currcons)
@@ -3135,12 +3132,11 @@ static int do_con_write(struct tty_struct *tty, const u8 *buf, int count)
 	if (in_interrupt())
 		return count;
 
-	console_lock();
+	guard(console_lock)();
 	currcons = vc->vc_num;
 	if (!vc_cons_allocated(currcons)) {
 		/* could this happen? */
 		pr_warn_once("con_write: tty %d not allocated\n", currcons+1);
-		console_unlock();
 		return 0;
 	}
 
@@ -3184,7 +3180,7 @@ static int do_con_write(struct tty_struct *tty, const u8 *buf, int count)
 	con_flush(vc, &draw);
 	console_conditional_schedule();
 	notify_update(vc);
-	console_unlock();
+
 	return n;
 }
 
@@ -3199,7 +3195,7 @@ static int do_con_write(struct tty_struct *tty, const u8 *buf, int count)
  */
 static void console_callback(struct work_struct *ignored)
 {
-	console_lock();
+	guard(console_lock)();
 
 	if (want_console >= 0) {
 		if (want_console != fg_console &&
@@ -3228,8 +3224,6 @@ static void console_callback(struct work_struct *ignored)
 		blank_timer_expired = 0;
 	}
 	notify_update(vc_cons[fg_console].d);
-
-	console_unlock();
 }
 
 int set_console(int nr)
@@ -3433,9 +3427,8 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			return -EPERM;
 		return paste_selection(tty);
 	case TIOCL_UNBLANKSCREEN:
-		console_lock();
-		unblank_screen();
-		console_unlock();
+		scoped_guard(console_lock)
+			unblank_screen();
 		break;
 	case TIOCL_SELLOADLUT:
 		if (!capable(CAP_SYS_ADMIN))
@@ -3451,9 +3444,8 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		data = vt_get_shift_state();
 		return put_user(data, p);
 	case TIOCL_GETMOUSEREPORTING:
-		console_lock();	/* May be overkill */
-		data = mouse_reporting();
-		console_unlock();
+		scoped_guard(console_lock)	/* May be overkill */
+			data = mouse_reporting();
 		return put_user(data, p);
 	case TIOCL_SETVESABLANK:
 		return set_vesa_blanking(param);
@@ -3484,15 +3476,14 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		 * Needs the console lock here. Note that lots of other calls
 		 * need fixing before the lock is actually useful!
 		 */
-		console_lock();
-		scrollfront(vc_cons[fg_console].d, lines);
-		console_unlock();
+		scoped_guard(console_lock)
+			scrollfront(vc_cons[fg_console].d, lines);
 		break;
 	case TIOCL_BLANKSCREEN:	/* until explicitly unblanked, not only poked */
-		console_lock();
-		ignore_poke = 1;
-		do_blank_screen(0);
-		console_unlock();
+		scoped_guard(console_lock) {
+			ignore_poke = 1;
+			do_blank_screen(0);
+		}
 		break;
 	case TIOCL_BLANKEDSCREEN:
 		return console_blanked;
@@ -3582,9 +3573,8 @@ static void con_flush_chars(struct tty_struct *tty)
 	if (in_interrupt())	/* from flush_to_ldisc */
 		return;
 
-	console_lock();
+	guard(console_lock)();
 	set_cursor(vc);
-	console_unlock();
 }
 
 /*
@@ -3596,22 +3586,20 @@ static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 	struct vc_data *vc;
 	int ret;
 
-	console_lock();
+	guard(console_lock)();
 	ret = vc_allocate(currcons);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	vc = vc_cons[currcons].d;
 
 	/* Still being freed */
-	if (vc->port.tty) {
-		ret = -ERESTARTSYS;
-		goto unlock;
-	}
+	if (vc->port.tty)
+		return -ERESTARTSYS;
 
 	ret = tty_port_install(&vc->port, driver, tty);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	tty->driver_data = vc;
 	vc->port.tty = tty;
@@ -3625,9 +3613,8 @@ static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 		tty->termios.c_iflag |= IUTF8;
 	else
 		tty->termios.c_iflag &= ~IUTF8;
-unlock:
-	console_unlock();
-	return ret;
+
+	return 0;
 }
 
 static int con_open(struct tty_struct *tty, struct file *filp)
@@ -3646,9 +3633,9 @@ static void con_shutdown(struct tty_struct *tty)
 {
 	struct vc_data *vc = tty->driver_data;
 	BUG_ON(vc == NULL);
-	console_lock();
+
+	guard(console_lock)();
 	vc->port.tty = NULL;
-	console_unlock();
 }
 
 static void con_cleanup(struct tty_struct *tty)
@@ -4137,15 +4124,13 @@ static ssize_t store_bind(struct device *dev, struct device_attribute *attr,
 	struct con_driver *con = dev_get_drvdata(dev);
 	int bind = simple_strtoul(buf, NULL, 0);
 
-	console_lock();
+	guard(console_lock)();
 
 	if (bind)
 		vt_bind(con);
 	else
 		vt_unbind(con);
 
-	console_unlock();
-
 	return count;
 }
 
@@ -4155,9 +4140,8 @@ static ssize_t show_bind(struct device *dev, struct device_attribute *attr,
 	struct con_driver *con = dev_get_drvdata(dev);
 	int bind;
 
-	console_lock();
-	bind = con_is_bound(con->con);
-	console_unlock();
+	scoped_guard(console_lock)
+		bind = con_is_bound(con->con);
 
 	return sysfs_emit(buf, "%i\n", bind);
 }
@@ -4429,7 +4413,7 @@ static void con_driver_unregister_callback(struct work_struct *ignored)
 {
 	int i;
 
-	console_lock();
+	guard(console_lock)();
 
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		struct con_driver *con_driver = &registered_con_driver[i];
@@ -4454,8 +4438,6 @@ static void con_driver_unregister_callback(struct work_struct *ignored)
 		con_driver->first = 0;
 		con_driver->last = 0;
 	}
-
-	console_unlock();
 }
 
 /*
@@ -4491,9 +4473,8 @@ EXPORT_SYMBOL_GPL(do_take_over_console);
  */
 void give_up_console(const struct consw *csw)
 {
-	console_lock();
+	guard(console_lock)();
 	do_unregister_con_driver(csw);
-	console_unlock();
 }
 EXPORT_SYMBOL(give_up_console);
 
@@ -4541,9 +4522,8 @@ static int set_vesa_blanking(u8 __user *mode_user)
 	if (get_user(mode, mode_user))
 		return -EFAULT;
 
-	console_lock();
+	guard(console_lock)();
 	vesa_blank_mode = (mode <= VESA_BLANK_MAX) ? mode : VESA_NO_BLANKING;
-	console_unlock();
 
 	return 0;
 }
@@ -4729,7 +4709,7 @@ int con_set_cmap(unsigned char __user *arg)
 	if (copy_from_user(colormap, arg, sizeof(colormap)))
 		return -EFAULT;
 
-	console_lock();
+	guard(console_lock)();
 	for (i = k = 0; i < 16; i++) {
 		default_red[i] = colormap[k++];
 		default_grn[i] = colormap[k++];
@@ -4745,7 +4725,6 @@ int con_set_cmap(unsigned char __user *arg)
 		}
 		set_palette(vc_cons[i].d);
 	}
-	console_unlock();
 
 	return 0;
 }
@@ -4755,13 +4734,12 @@ int con_get_cmap(unsigned char __user *arg)
 	int i, k;
 	unsigned char colormap[3*16];
 
-	console_lock();
-	for (i = k = 0; i < 16; i++) {
-		colormap[k++] = default_red[i];
-		colormap[k++] = default_grn[i];
-		colormap[k++] = default_blu[i];
-	}
-	console_unlock();
+	scoped_guard(console_lock)
+		for (i = k = 0; i < 16; i++) {
+			colormap[k++] = default_red[i];
+			colormap[k++] = default_grn[i];
+			colormap[k++] = default_blu[i];
+		}
 
 	if (copy_to_user(arg, colormap, sizeof(colormap)))
 		return -EFAULT;
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 61342e06970a..c9f11c4bd9fe 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -373,15 +373,13 @@ static int vt_k_ioctl(struct tty_struct *tty, unsigned int cmd,
 		break;
 	}
 
-	case KDSETMODE:
+	case KDSETMODE: {
 		if (!perm)
 			return -EPERM;
 
-		console_lock();
-		ret = vt_kdsetmode(vc, arg);
-		console_unlock();
-		return ret;
-
+		guard(console_lock)();
+		return vt_kdsetmode(vc, arg);
+	}
 	case KDGETMODE:
 		return put_user(vc->vc_mode, (int __user *)arg);
 
@@ -601,23 +599,21 @@ static int vt_setactivate(struct vt_setactivate __user *sa)
 
 	vsa.console--;
 	vsa.console = array_index_nospec(vsa.console, MAX_NR_CONSOLES);
-	console_lock();
-	ret = vc_allocate(vsa.console);
-	if (ret) {
-		console_unlock();
-		return ret;
-	}
+	scoped_guard(console_lock) {
+		ret = vc_allocate(vsa.console);
+		if (ret)
+			return ret;
 
-	/*
-	 * This is safe providing we don't drop the console sem between
-	 * vc_allocate and finishing referencing nvc.
-	 */
-	nvc = vc_cons[vsa.console].d;
-	nvc->vt_mode = vsa.mode;
-	nvc->vt_mode.frsig = 0;
-	put_pid(nvc->vt_pid);
-	nvc->vt_pid = get_pid(task_pid(current));
-	console_unlock();
+		/*
+		 * This is safe providing we don't drop the console sem between
+		 * vc_allocate and finishing referencing nvc.
+		 */
+		nvc = vc_cons[vsa.console].d;
+		nvc->vt_mode = vsa.mode;
+		nvc->vt_mode.frsig = 0;
+		put_pid(nvc->vt_pid);
+		nvc->vt_pid = get_pid(task_pid(current));
+	}
 
 	/* Commence switch and lock */
 	/* Review set_console locks */
@@ -630,19 +626,18 @@ static int vt_setactivate(struct vt_setactivate __user *sa)
 static int vt_disallocate(unsigned int vc_num)
 {
 	struct vc_data *vc = NULL;
-	int ret = 0;
 
-	console_lock();
-	if (vt_busy(vc_num))
-		ret = -EBUSY;
-	else if (vc_num)
-		vc = vc_deallocate(vc_num);
-	console_unlock();
+	scoped_guard(console_lock) {
+		if (vt_busy(vc_num))
+			return -EBUSY;
+		if (vc_num)
+			vc = vc_deallocate(vc_num);
+	}
 
 	if (vc && vc_num >= MIN_NR_CONSOLES)
 		tty_port_put(&vc->port);
 
-	return ret;
+	return 0;
 }
 
 /* deallocate all unused consoles, but leave 0 */
@@ -651,13 +646,12 @@ static void vt_disallocate_all(void)
 	struct vc_data *vc[MAX_NR_CONSOLES];
 	int i;
 
-	console_lock();
-	for (i = 1; i < MAX_NR_CONSOLES; i++)
-		if (!vt_busy(i))
-			vc[i] = vc_deallocate(i);
-		else
-			vc[i] = NULL;
-	console_unlock();
+	scoped_guard(console_lock)
+		for (i = 1; i < MAX_NR_CONSOLES; i++)
+			if (!vt_busy(i))
+				vc[i] = vc_deallocate(i);
+			else
+				vc[i] = NULL;
 
 	for (i = 1; i < MAX_NR_CONSOLES; i++) {
 		if (vc[i] && i >= MIN_NR_CONSOLES)
@@ -703,7 +697,7 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 
 		if (!vc_cons[i].d)
 			continue;
-		console_lock();
+		guard(console_lock)();
 		vcp = vc_cons[i].d;
 		if (vcp) {
 			int ret;
@@ -718,11 +712,9 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 			if (ret) {
 				vcp->vc_scan_lines = save_scan_lines;
 				vcp->vc_cell_height = save_cell_height;
-				console_unlock();
 				return ret;
 			}
 		}
-		console_unlock();
 	}
 
 	return 0;
@@ -770,7 +762,7 @@ int vt_ioctl(struct tty_struct *tty,
 		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS)
 			return -EINVAL;
 
-		console_lock();
+		guard(console_lock)();
 		vc->vt_mode = tmp;
 		/* the frsig is ignored, so we set it to 0 */
 		vc->vt_mode.frsig = 0;
@@ -778,7 +770,6 @@ int vt_ioctl(struct tty_struct *tty,
 		vc->vt_pid = get_pid(task_pid(current));
 		/* no switch is required -- saw@shade.msu.ru */
 		vc->vt_newvt = -1;
-		console_unlock();
 		break;
 	}
 
@@ -787,9 +778,8 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_mode tmp;
 		int rc;
 
-		console_lock();
-		memcpy(&tmp, &vc->vt_mode, sizeof(struct vt_mode));
-		console_unlock();
+		scoped_guard(console_lock)
+			memcpy(&tmp, &vc->vt_mode, sizeof(struct vt_mode));
 
 		rc = copy_to_user(up, &tmp, sizeof(struct vt_mode));
 		if (rc)
@@ -811,12 +801,10 @@ int vt_ioctl(struct tty_struct *tty,
 			return -EFAULT;
 
 		state = 1;	/* /dev/tty0 is always open */
-		console_lock(); /* required by vt_in_use() */
-		for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask;
-				++i, mask <<= 1)
-			if (vt_in_use(i))
-				state |= mask;
-		console_unlock();
+		scoped_guard(console_lock) /* required by vt_in_use() */
+			for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask; ++i, mask <<= 1)
+				if (vt_in_use(i))
+					state |= mask;
 		return put_user(state, &vtstat->v_state);
 	}
 
@@ -824,11 +812,10 @@ int vt_ioctl(struct tty_struct *tty,
 	 * Returns the first available (non-opened) console.
 	 */
 	case VT_OPENQRY:
-		console_lock(); /* required by vt_in_use() */
-		for (i = 0; i < MAX_NR_CONSOLES; ++i)
-			if (!vt_in_use(i))
-				break;
-		console_unlock();
+		scoped_guard(console_lock) /* required by vt_in_use() */
+			for (i = 0; i < MAX_NR_CONSOLES; ++i)
+				if (!vt_in_use(i))
+					break;
 		i = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		return put_user(i, (int __user *)arg);
 
@@ -845,11 +832,11 @@ int vt_ioctl(struct tty_struct *tty,
 
 		arg--;
 		arg = array_index_nospec(arg, MAX_NR_CONSOLES);
-		console_lock();
-		ret = vc_allocate(arg);
-		console_unlock();
-		if (ret)
-			return ret;
+		scoped_guard(console_lock) {
+			ret = vc_allocate(arg);
+			if (ret)
+				return ret;
+		}
 		set_console(arg);
 		break;
 
@@ -880,15 +867,13 @@ int vt_ioctl(struct tty_struct *tty,
 	 *	2:	completed switch-to OK
 	 */
 	case VT_RELDISP:
+	{
 		if (!perm)
 			return -EPERM;
 
-		console_lock();
-		ret = vt_reldisp(vc, arg);
-		console_unlock();
-
-		return ret;
-
+		guard(console_lock)();
+		return vt_reldisp(vc, arg);
+	}
 
 	 /*
 	  * Disallocate memory associated to VT (but leave VT1)
@@ -917,7 +902,7 @@ int vt_ioctl(struct tty_struct *tty,
 		    get_user(cc, &vtsizes->v_cols))
 			return -EFAULT;
 
-		console_lock();
+		guard(console_lock)();
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			vc = vc_cons[i].d;
 
@@ -926,7 +911,6 @@ int vt_ioctl(struct tty_struct *tty,
 				__vc_resize(vc_cons[i].d, cc, ll, true);
 			}
 		}
-		console_unlock();
 		break;
 	}
 
@@ -996,20 +980,17 @@ void vc_SAK(struct work_struct *work)
 	struct vc_data *vc;
 	struct tty_struct *tty;
 
-	console_lock();
+	guard(console_lock)();
 	vc = vc_con->d;
-	if (vc) {
-		/* FIXME: review tty ref counting */
-		tty = vc->port.tty;
-		/*
-		 * SAK should also work in all raw modes and reset
-		 * them properly.
-		 */
-		if (tty)
-			__do_SAK(tty);
-		reset_vc(vc);
-	}
-	console_unlock();
+	if (!vc)
+		return;
+
+	/* FIXME: review tty ref counting */
+	tty = vc->port.tty;
+	/* SAK should also work in all raw modes and reset them properly. */
+	if (tty)
+		__do_SAK(tty);
+	reset_vc(vc);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1287,31 +1268,29 @@ int vt_move_to_console(unsigned int vt, int alloc)
 {
 	int prev;
 
-	console_lock();
-	/* Graphics mode - up to X */
-	if (disable_vt_switch) {
-		console_unlock();
-		return 0;
-	}
-	prev = fg_console;
+	scoped_guard(console_lock) {
+		/* Graphics mode - up to X */
+		if (disable_vt_switch)
+			return 0;
 
-	if (alloc && vc_allocate(vt)) {
-		/* we can't have a free VC for now. Too bad,
-		 * we don't want to mess the screen for now. */
-		console_unlock();
-		return -ENOSPC;
-	}
+		prev = fg_console;
 
-	if (set_console(vt)) {
-		/*
-		 * We're unable to switch to the SUSPEND_CONSOLE.
-		 * Let the calling function know so it can decide
-		 * what to do.
-		 */
-		console_unlock();
-		return -EIO;
+		if (alloc && vc_allocate(vt)) {
+			/*
+			 * We can't have a free VC for now. Too bad, we don't want to mess the
+			 * screen for now.
+			 */
+			return -ENOSPC;
+		}
+
+		if (set_console(vt)) {
+			/*
+			 * We're unable to switch to the SUSPEND_CONSOLE. Let the calling function
+			 * know so it can decide what to do.
+			 */
+			return -EIO;
+		}
 	}
-	console_unlock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
 		return -EINTR;
@@ -1328,8 +1307,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
  */
 void pm_set_vt_switch(int do_switch)
 {
-	console_lock();
+	guard(console_lock)();
 	disable_vt_switch = !do_switch;
-	console_unlock();
 }
 EXPORT_SYMBOL(pm_set_vt_switch);
-- 
2.50.1


